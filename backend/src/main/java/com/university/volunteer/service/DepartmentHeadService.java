package com.university.volunteer.service;

import com.university.volunteer.common.Result;
import com.university.volunteer.dto.AccountCreateDTO;
import com.university.volunteer.dto.AccountUpdateDTO;
import com.university.volunteer.dto.HeadAccountDTO;
import com.university.volunteer.entity.*;
import com.university.volunteer.mapper.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class DepartmentHeadService {

    @Autowired
    private DepartmentHeadMapper departmentHeadMapper;

    @Autowired
    private AcademyMapper academyMapper;

    @Autowired
    private StudentActivityMapper studentActivityMapper;
    
    @Autowired
    private ActivityTagMapper activityTagMapper;
    
    @Autowired
    private TagMapper tagMapper;
    
    @Autowired
    private AdminMapper adminMapper;

    @Transactional(rollbackFor = Exception.class)
    public Result<String> auditRegistration(Integer registrationId, String status) {
        int rows = departmentHeadMapper.updateRegistrationStatus(registrationId, status);
        if (rows > 0) {
            return Result.success("审核操作成功");
        } else {
            return Result.error("审核操作失败，记录不存在或状态未变更");
        }
    }

    /**
     * 获取负责人信息（支持部门负责人和学院负责人）
     */
    public Result<Map<String, Object>> getHeadInfo(String username) {
        // 先查部门负责人表
        DepartmentHead deptHead = departmentHeadMapper.findByUsername(username);
        if (deptHead != null) {
            Map<String, Object> info = new HashMap<>();
            info.put("type", "department");
            info.put("username", deptHead.getXjbmfzrZh());
            info.put("name", deptHead.getXjbmfzrXm());
            info.put("department", deptHead.getXjbmMc());
            info.put("phone", deptHead.getXjbmfzrDh());
            return Result.success(info);
        }

        // 再查学院表
        Academy academy = academyMapper.findByUsername(username);
        if (academy != null) {
            Map<String, Object> info = new HashMap<>();
            info.put("type", "academy");
            info.put("username", academy.getXyZh());
            info.put("name", academy.getFzrXm());
            info.put("department", academy.getXyMc());
            info.put("phone", academy.getXyDh());
            return Result.success(info);
        }

        return Result.error("未找到用户信息");
    }

    /**
     * 更新负责人信息
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> updateHeadInfo(String username, String name, String phone) {
        // 先尝试更新部门负责人
        DepartmentHead deptHead = departmentHeadMapper.findByUsername(username);
        if (deptHead != null) {
            deptHead.setXjbmfzrXm(name);
            deptHead.setXjbmfzrDh(phone);
            int rows = departmentHeadMapper.updateDepartmentHead(deptHead);
            if (rows > 0) {
                return Result.success("信息更新成功");
            } else {
                return Result.error("信息更新失败");
            }
        }

        // 再尝试更新学院负责人
        Academy academy = academyMapper.findByUsername(username);
        if (academy != null) {
            academy.setFzrXm(name);
            academy.setXyDh(phone);
            int rows = academyMapper.updateAcademy(academy);
            if (rows > 0) {
                return Result.success("信息更新成功");
            } else {
                return Result.error("信息更新失败");
            }
        }

        return Result.error("未找到用户信息");
    }

    /**
     * 修改密码
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> updatePassword(String username, String oldPassword, String newPassword) {
        // 验证新密码格式
        if (newPassword == null || newPassword.trim().isEmpty()) {
            return Result.error("新密码不能为空");
        }
        if (newPassword.length() < 6) {
            return Result.error("新密码长度不能少于6位");
        }
        
        // 先查部门负责人表
        DepartmentHead deptHead = departmentHeadMapper.findByUsername(username);
        if (deptHead != null) {
            // 验证旧密码
            if (!oldPassword.equals(deptHead.getXjbmfzrMm())) {
                return Result.error("原密码错误");
            }
            
            // 更新密码
            int rows = departmentHeadMapper.updatePassword(username, newPassword);
            if (rows > 0) {
                return Result.success("密码修改成功");
            } else {
                return Result.error("密码修改失败");
            }
        }

        // 再查学院表
        Academy academy = academyMapper.findByUsername(username);
        if (academy != null) {
            // 验证旧密码
            if (!oldPassword.equals(academy.getXyMm())) {
                return Result.error("原密码错误");
            }
            
            // 更新密码
            int rows = academyMapper.updatePassword(username, newPassword);
            if (rows > 0) {
                return Result.success("密码修改成功");
            } else {
                return Result.error("密码修改失败");
            }
        }

        return Result.error("未找到用户信息");
    }

    /**
     * 根据负责人获取其发起的活动列表
     */
    public Result<List<VolunteerActivity>> getActivitiesByHead(String username) {
        // 先获取负责人信息以确定部门/学院名称
        Result<Map<String, Object>> headInfoResult = getHeadInfo(username);
        if (headInfoResult.getCode() != 200) {
            return Result.error("获取负责人信息失败");
        }

        String department = (String) headInfoResult.getData().get("department");
        if (department == null || department.isEmpty()) {
            return Result.error("未找到部门/学院信息");
        }

        // 根据部门/学院名称查询活动
        List<VolunteerActivity> activities = studentActivityMapper.findActivitiesByDepartment(department);
        
        // 动态更新活动状态
        java.util.Date now = new java.util.Date();
        for (VolunteerActivity activity : activities) {
            String newStatus = calculateActivityStatus(activity, now);
            // 如果状态发生变化，更新数据库
            if (!newStatus.equals(activity.getHdZt())) {
                activity.setHdZt(newStatus);
                studentActivityMapper.updateActivityStatus(activity.getHdBh(), newStatus);
            }
        }
        
        return Result.success(activities);
    }

    /**
     * 根据当前时间计算活动状态
     */
    private String calculateActivityStatus(VolunteerActivity activity, java.util.Date now) {
        if (activity.getBmKssj() == null || activity.getBmJssj() == null ||
            activity.getHdKssj() == null || activity.getHdJssj() == null) {
            return "报名未开始";
        }

        // 统一口径：报名未开始/活动报名中/活动未开始/活动进行中/活动已结束
        if (now.before(activity.getBmKssj())) {
            return "报名未开始";
        } else if (!now.after(activity.getBmJssj())) {
            // now >= bmKssj && now <= bmJssj
            return "活动报名中";
        } else if (now.before(activity.getHdKssj())) {
            // now > bmJssj && now < hdKssj
            return "活动未开始";
        } else if (!now.after(activity.getHdJssj())) {
            // now >= hdKssj && now <= hdJssj
            return "活动进行中";
        } else {
            return "活动已结束";
        }
    }

    /**
     * 根据负责人获取报名记录列表（用于各种管理功能）
     */
    public Result<List<ActivityRegistration>> getRegistrationsByHead(String username) {
        try {
        // 先获取负责人信息以确定部门/学院名称
        Result<Map<String, Object>> headInfoResult = getHeadInfo(username);
            if (headInfoResult.getCode() != 200 || headInfoResult.getData() == null) {
            return Result.error("获取负责人信息失败");
        }

        String department = (String) headInfoResult.getData().get("department");
        if (department == null || department.isEmpty()) {
            return Result.error("未找到部门/学院信息");
        }

        // 根据部门/学院名称查询报名记录
        List<ActivityRegistration> registrations = studentActivityMapper.findRegistrationsByDepartment(department);
        return Result.success(registrations);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取报名记录失败：" + e.getMessage());
        }
    }

    /**
     * 更新活动信息（新增标签处理）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> updateActivity(VolunteerActivity activity) {
        if (activity.getHdBh() == null) {
            return Result.error("活动编号不能为空");
        }
        
        // 处理标签更新
        if (activity.getTagIds() != null && !activity.getTagIds().isEmpty()) {
            // 1. 删除活动的所有旧标签关联
            activityTagMapper.deleteByActivityId(activity.getHdBh());
            
            // 2. 批量插入新的标签关联
            List<ActivityTag> activityTags = new ArrayList<>();
            for (Integer tagId : activity.getTagIds()) {
                ActivityTag at = new ActivityTag();
                at.setHdBh(activity.getHdBh());
                at.setBqId(tagId);
                activityTags.add(at);
            }
            if (!activityTags.isEmpty()) {
                activityTagMapper.insertBatch(activityTags);
            }
            
            // 3. 更新冗余字段（用于兼容和快速查询）
            List<Tag> tags = tagMapper.findByIds(activity.getTagIds());
            if (tags != null && !tags.isEmpty()) {
                // 分离活动标签和技能要求
                String hdBq = tags.stream()
                        .filter(tag -> tag.getBqLx() == 1)
                        .map(Tag::getBqMc)
                        .collect(Collectors.joining(","));
                String jnYq = tags.stream()
                        .filter(tag -> tag.getBqLx() == 2)
                        .map(Tag::getBqMc)
                        .collect(Collectors.joining(","));
                activity.setHdBq(hdBq.isEmpty() ? null : hdBq);
                activity.setJnYq(jnYq.isEmpty() ? null : jnYq);
            }
        }
        
        int rows = studentActivityMapper.updateActivity(activity);
        if (rows > 0) {
            return Result.success("活动更新成功");
        } else {
            return Result.error("活动更新失败，活动不存在");
        }
    }

    /**
     * 删除活动
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> deleteActivity(Integer activityId) {
        if (activityId == null) {
            return Result.error("活动编号不能为空");
        }
        
        // 先删除该活动的所有报名记录
        // 注意：这里简化处理，实际应该先检查是否有已审核通过的报名
        int rows = studentActivityMapper.deleteActivity(activityId);
        if (rows > 0) {
            return Result.success("活动删除成功");
        } else {
            return Result.error("活动删除失败，活动不存在");
        }
    }

    /**
     * 下架活动（更新发布状态为"已下架"）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> unpublishActivity(Integer activityId) {
        if (activityId == null) {
            return Result.error("活动编号不能为空");
        }
        
        int rows = studentActivityMapper.updateActivityPublishStatus(activityId, "已下架");
        if (rows > 0) {
            return Result.success("活动已下架");
        } else {
            return Result.error("下架失败，活动不存在");
        }
    }

    /**
     * 上架活动（已废弃，负责人不再有此权限）
     */
    @Deprecated
    @Transactional(rollbackFor = Exception.class)
    public Result<String> publishActivity(Integer activityId) {
        return Result.error("负责人无权限发布活动，请申报后由管理员发布");
    }

    /**
     * 申报活动（将活动状态从"待申报"改为"待发布"）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> submitActivity(Integer activityId) {
        if (activityId == null) {
            return Result.error("活动编号不能为空");
        }
        
        try {
            // 先查询活动当前状态
            VolunteerActivity activity = studentActivityMapper.findActivityById(activityId);
            if (activity == null) {
                return Result.error("活动不存在");
            }
            
            String currentStatus = activity.getFbZt();
            if (!"未申报".equals(currentStatus)) {
                return Result.error("只能申报状态为'未申报'的活动");
            }
            
            int rows = studentActivityMapper.updateActivityPublishStatus(activityId, "待发布");
            if (rows > 0) {
                return Result.success("活动已申报，等待管理员审核发布");
            } else {
                return Result.error("申报失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("申报失败：" + e.getMessage());
        }
    }

    /**
     * 撤销申报（将活动状态从"待发布"改回"待申报"）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> cancelSubmitActivity(Integer activityId) {
        if (activityId == null) {
            return Result.error("活动编号不能为空");
        }
        
        try {
            // 先查询活动当前状态
            VolunteerActivity activity = studentActivityMapper.findActivityById(activityId);
            if (activity == null) {
                return Result.error("活动不存在");
            }
            
            String currentStatus = activity.getFbZt();
            if (!"待发布".equals(currentStatus)) {
                return Result.error("只能撤销状态为'待发布'的活动");
            }
            
            int rows = studentActivityMapper.updateActivityPublishStatus(activityId, "未申报");
            if (rows > 0) {
                return Result.success("已撤销申报");
            } else {
                return Result.error("撤销申报失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("撤销申报失败：" + e.getMessage());
        }
    }

    /**
     * 创建新活动（新增标签处理）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<VolunteerActivity> createActivity(String username, VolunteerActivity activity) {
        // 1. 判断用户是否是管理员
        boolean isAdmin = false;
        String department = null;
        
        Admin admin = adminMapper.findByUsername(username);
        if (admin != null) {
            isAdmin = true;
            // 管理员统一使用“国志协”作为发起单位
            department = "国志协";
        } else {
            // 2. 获取负责人信息以确定发起单位
            Result<Map<String, Object>> headInfoResult = getHeadInfo(username);
            if (headInfoResult.getCode() != 200) {
                return Result.error("获取负责人信息失败");
            }

            department = (String) headInfoResult.getData().get("department");
            if (department == null || department.isEmpty()) {
                return Result.error("未找到部门/学院信息");
            }
        }

        // 3. 设置活动发起单位
        activity.setHdFqDw(department);
        
        // 4. 设置默认值
        activity.setYbmRs(0); // 已报名人数初始为0
        activity.setHdZt("未开始"); // 活动状态初始为未开始
        
        // 根据用户类型设置不同的默认发布状态
        // 管理员创建的活动默认为"待发布"，负责人创建的活动默认为"未申报"
        if (isAdmin) {
            activity.setFbZt("待发布"); // 管理员创建的活动默认待发布
        } else {
            activity.setFbZt("未申报"); // 负责人创建的活动默认未申报
        }
        
        activity.setBbh(0); // 乐观锁版本号初始为0

        // 5. 验证必填字段
        if (activity.getHdMc() == null || activity.getHdMc().trim().isEmpty()) {
            return Result.error("活动名称不能为空");
        }
        if (activity.getHdNr() == null || activity.getHdNr().trim().isEmpty()) {
            return Result.error("活动内容不能为空");
        }
        if (activity.getHdDd() == null || activity.getHdDd().trim().isEmpty()) {
            return Result.error("活动地点不能为空");
        }
        if (activity.getZmRs() == null || activity.getZmRs() <= 0) {
            return Result.error("招募人数必须大于0");
        }
        if (activity.getBmKssj() == null || activity.getBmJssj() == null) {
            return Result.error("报名时间不能为空");
        }
        if (activity.getHdKssj() == null || activity.getHdJssj() == null) {
            return Result.error("活动时间不能为空");
        }

        // 6. 验证时间逻辑
        if (activity.getBmKssj().after(activity.getBmJssj())) {
            return Result.error("报名开始时间不能晚于结束时间");
        }
        if (activity.getHdKssj().after(activity.getHdJssj())) {
            return Result.error("活动开始时间不能晚于结束时间");
        }
        if (activity.getBmJssj().after(activity.getHdKssj())) {
            return Result.error("报名结束时间不能晚于活动开始时间");
        }

        // 7. 处理标签（在插入活动之前准备冗余字段）
        if (activity.getTagIds() != null && !activity.getTagIds().isEmpty()) {
            List<Tag> tags = tagMapper.findByIds(activity.getTagIds());
            if (tags != null && !tags.isEmpty()) {
                String hdBq = tags.stream()
                        .filter(tag -> tag.getBqLx() == 1)
                        .map(Tag::getBqMc)
                        .collect(Collectors.joining(","));
                String jnYq = tags.stream()
                        .filter(tag -> tag.getBqLx() == 2)
                        .map(Tag::getBqMc)
                        .collect(Collectors.joining(","));
                activity.setHdBq(hdBq.isEmpty() ? null : hdBq);
                activity.setJnYq(jnYq.isEmpty() ? null : jnYq);
            }
        }

        // 8. 插入活动到数据库
        int rows = studentActivityMapper.insertActivity(activity);
        if (rows > 0) {
            // 9. 插入标签关联
            if (activity.getTagIds() != null && !activity.getTagIds().isEmpty()) {
                List<ActivityTag> activityTags = new ArrayList<>();
                for (Integer tagId : activity.getTagIds()) {
                    ActivityTag at = new ActivityTag();
                    at.setHdBh(activity.getHdBh()); // 使用自动生成的活动编号
                    at.setBqId(tagId);
                    activityTags.add(at);
                }
                if (!activityTags.isEmpty()) {
                    activityTagMapper.insertBatch(activityTags);
                }
            }
            return Result.success(activity);
        } else {
            return Result.error("创建活动失败");
        }
    }

    /**
     * 更新考勤（签到/签退/考勤状态）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> updateAttendance(String username, Integer registrationId, Long checkInMillis, Long checkOutMillis, Integer attendanceStatus) {
        Result<ActivityRegistration> check = loadAndCheckRegistration(username, registrationId);
        if (check.getCode() != 200) {
            return Result.error(check.getMessage());
        }

        Date checkIn = checkInMillis != null ? new Date(checkInMillis) : check.getData().getCheckInTime();
        Date checkOut = checkOutMillis != null ? new Date(checkOutMillis) : check.getData().getCheckOutTime();

        // 考勤状态允许为空，空则默认0（未签）
        Integer statusCode = attendanceStatus == null ? 0 : attendanceStatus;
        if (statusCode < 0 || statusCode > 3) {
            return Result.error("考勤状态非法，应为 0-3");
        }

        int rows = studentActivityMapper.updateAttendance(registrationId, checkIn, checkOut, statusCode);
        return rows > 0 ? Result.success("考勤已更新") : Result.error("考勤更新失败");
    }

    /**
     * 确认或修改工时学分
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> confirmDurationAndCredits(String username, Integer registrationId, Double duration, Double credits) {
        Result<ActivityRegistration> check = loadAndCheckRegistration(username, registrationId);
        if (check.getCode() != 200) {
            return Result.error(check.getMessage());
        }

        ActivityRegistration reg = check.getData();
        // 若未手动传入，尝试根据签到签退计算
        Double finalDuration = duration;
        if (finalDuration == null || finalDuration < 0) {
            if (reg.getCheckInTime() != null && reg.getCheckOutTime() != null) {
                long diff = reg.getCheckOutTime().getTime() - reg.getCheckInTime().getTime();
                finalDuration = Math.max(0d, Math.round(diff / (1000 * 60 * 60.0) * 10d) / 10d);
            } else {
                finalDuration = 0d;
            }
        }

        Double finalCredits = credits == null ? 0d : credits;
        if (finalCredits < 0) {
            return Result.error("学分不能为负数");
        }

        int rows = studentActivityMapper.updateDurationAndCredits(registrationId, finalDuration, finalCredits);
        return rows > 0 ? Result.success("工时/学分已更新") : Result.error("更新失败");
    }

    /**
     * 评价志愿者
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> evaluateVolunteer(String username, Integer registrationId, Integer rating, String evaluation) {
        Result<ActivityRegistration> check = loadAndCheckRegistration(username, registrationId);
        if (check.getCode() != 200) {
            return Result.error(check.getMessage());
        }

        if (rating != null && (rating < 1 || rating > 5)) {
            return Result.error("评分需在1-5之间");
        }
        int finalRating = rating == null ? 5 : rating;

        int rows = studentActivityMapper.updateEvaluation(registrationId, evaluation, finalRating);
        return rows > 0 ? Result.success("评价已提交") : Result.error("评价失败");
    }

    /**
     * 确认公假单
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> confirmLeavePermit(String username, Integer registrationId) {
        Result<ActivityRegistration> check = loadAndCheckRegistration(username, registrationId);
        if (check.getCode() != 200) {
            return Result.error(check.getMessage());
        }
        int rows = studentActivityMapper.updateLeaveConfirm(registrationId, 1, new Date());
        return rows > 0 ? Result.success("公假单已出具") : Result.error("出具失败");
    }

    /**
     * 确认证明
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> confirmCertificate(String username, Integer registrationId) {
        Result<ActivityRegistration> check = loadAndCheckRegistration(username, registrationId);
        if (check.getCode() != 200) {
            return Result.error(check.getMessage());
        }
        int rows = studentActivityMapper.updateCertificateConfirm(registrationId, 1, new Date());
        return rows > 0 ? Result.success("证明已出具") : Result.error("出具失败");
    }

    /**
     * 导出公假单
     */
    public ResponseEntity<byte[]> exportLeavePermit(String username, Integer registrationId) {
        Result<ActivityRegistration> check = loadAndCheckRegistration(username, registrationId);
        if (check.getCode() != 200) {
            return buildErrorFile(check.getMessage(), "permit-error.txt");
        }
        ActivityRegistration reg = check.getData();
        String content = "公假单\n"
                + "学生姓名: " + reg.getStudentName() + "\n"
                + "学号: " + reg.getStudentId() + "\n"
                + "学院: " + reg.getAcademyName() + "\n"
                + "活动: " + reg.getActivityName() + "\n"
                + "时间: " + nullSafe(reg.getActivityTime()) + "\n"
                + "地点: " + nullSafe(reg.getActivityLocation()) + "\n"
                + "审核状态: " + nullSafe(reg.getStatus()) + "\n"
                + "审核/驳回理由: " + nullSafe(reg.getAuditReason()) + "\n"
                + "出具时间: " + new Date() + "\n";
        return buildFile(content, "leave-permit-" + registrationId + ".txt");
    }

    /**
     * 导出参与/学分证明
     */
    public ResponseEntity<byte[]> exportCertificate(String username, Integer registrationId, boolean withCredits) {
        Result<ActivityRegistration> check = loadAndCheckRegistration(username, registrationId);
        if (check.getCode() != 200) {
            return buildErrorFile(check.getMessage(), "certificate-error.txt");
        }
        ActivityRegistration reg = check.getData();
        String title = withCredits ? "志愿活动学分证明" : "志愿活动参与证明";
        String content = title + "\n"
                + "学生姓名: " + reg.getStudentName() + "\n"
                + "学号: " + reg.getStudentId() + "\n"
                + "学院: " + reg.getAcademyName() + "\n"
                + "活动: " + reg.getActivityName() + "\n"
                + "时间: " + nullSafe(reg.getActivityTime()) + "\n"
                + "地点: " + nullSafe(reg.getActivityLocation()) + "\n"
                + "工时: " + (reg.getDuration() == null ? "-" : reg.getDuration() + " 小时") + "\n";
        if (withCredits) {
            content += "学分: " + (reg.getCredits() == null ? "0" : reg.getCredits()) + "\n";
        }
        content += "评价: " + nullSafe(reg.getEvaluation()) + "\n"
                + "评分: " + (reg.getRating() == null ? "-" : reg.getRating()) + "\n"
                + "出具时间: " + new Date() + "\n";
        String filename = withCredits ? "credit-certificate-" + registrationId + ".txt"
                : "participation-certificate-" + registrationId + ".txt";
        return buildFile(content, filename);
    }

    /**
     * 权限校验：报名记录是否属于该负责人所在部门
     */
    private Result<ActivityRegistration> loadAndCheckRegistration(String username, Integer registrationId) {
        if (registrationId == null) {
            return Result.error("报名ID不能为空");
        }
        ActivityRegistration reg = studentActivityMapper.findRegistrationById(registrationId);
        if (reg == null) {
            return Result.error("报名记录不存在");
        }

        Result<Map<String, Object>> headInfo = getHeadInfo(username);
        if (headInfo.getCode() != 200) {
            return Result.error("获取负责人信息失败");
        }
        String dept = (String) headInfo.getData().get("department");
        if (dept == null || reg.getActivityDepartment() == null || !dept.equals(reg.getActivityDepartment())) {
            return Result.error("无权限操作该报名记录");
        }
        return Result.success(reg);
    }

    private ResponseEntity<byte[]> buildFile(String content, String filename) {
        byte[] data = content.getBytes(StandardCharsets.UTF_8);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        headers.setContentDispositionFormData("attachment", filename);
        return ResponseEntity.ok().headers(headers).body(data);
    }

    private ResponseEntity<byte[]> buildErrorFile(String message, String filename) {
        return buildFile("导出失败：" + message, filename);
    }

    private String nullSafe(Object obj) {
        return obj == null ? "-" : obj.toString();
    }

    // ========== 管理员账号管理功能 ==========

    /**
     * 分页查询负责人列表（管理员用）
     * 合并校级部门负责人和学院负责人
     */
    public Result<Map<String, Object>> getDepartmentHeadsByPage(String keyword, int page, int size) {
        try {
            List<HeadAccountDTO> allHeads = new ArrayList<>();
            
            // 1. 查询校级部门负责人
            List<DepartmentHead> deptHeads = departmentHeadMapper.findDepartmentHeadsByPage(keyword);
            for (DepartmentHead head : deptHeads) {
                HeadAccountDTO dto = new HeadAccountDTO();
                dto.setUsername(head.getXjbmfzrZh());
                dto.setName(head.getXjbmfzrXm());
                dto.setDepartment(head.getXjbmMc());
                dto.setPhone(head.getXjbmfzrDh());
                dto.setType("department");
                allHeads.add(dto);
            }
            
            // 2. 查询学院负责人
            List<Academy> academies = academyMapper.findAcademiesByPage(keyword);
            for (Academy academy : academies) {
                HeadAccountDTO dto = new HeadAccountDTO();
                dto.setUsername(academy.getXyZh());
                dto.setName(academy.getFzrXm());
                dto.setDepartment(academy.getXyMc());
                dto.setPhone(academy.getXyDh());
                dto.setType("academy");
                allHeads.add(dto);
            }
            
            // 3. 手动分页处理
            int total = allHeads.size();
            int start = (page - 1) * size;
            int end = Math.min(start + size, total);
            
            List<HeadAccountDTO> pageData = start < total ? allHeads.subList(start, end) : new ArrayList<>();
            
            Map<String, Object> result = new HashMap<>();
            result.put("list", pageData);
            result.put("total", total);
            result.put("page", page);
            result.put("size", size);
            
            return Result.success(result);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("查询负责人列表失败: " + e.getMessage());
        }
    }

    /**
     * 创建负责人账号（管理员用）
     * 根据 accountType 决定创建校级部门负责人还是学院负责人
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> createDepartmentHead(AccountCreateDTO dto) {
        try {
            // 1. 验证必填字段
            if (dto.getCode() == null || dto.getCode().trim().isEmpty()) {
                return Result.error("账号不能为空");
            }
            if (dto.getUsername() == null || dto.getUsername().trim().isEmpty()) {
                return Result.error("姓名不能为空");
            }
            if (dto.getDepartment() == null || dto.getDepartment().trim().isEmpty()) {
                return Result.error("部门/学院不能为空");
            }
            
            // 2. 设置默认密码
            String password = dto.getPassword();
            if (password == null || password.trim().isEmpty()) {
                password = "123456";
            }
            
            // 3. 根据类型创建不同的账号
            String accountType = dto.getAccountType();
            if ("academy".equals(accountType)) {
                // 创建学院负责人
                Integer count = academyMapper.existsByUsername(dto.getCode());
                if (count != null && count > 0) {
                    return Result.error("学院账号已存在");
                }
                
                Academy academy = new Academy();
                academy.setXyZh(dto.getCode());
                academy.setXyMc(dto.getDepartment());
                academy.setFzrXm(dto.getUsername());
                academy.setXyMm(password);
                academy.setXyDh(dto.getPhone());
                
                int rows = academyMapper.insertAcademy(academy);
                if (rows > 0) {
                    return Result.success("学院负责人账号创建成功，初始密码：" + password);
                } else {
                    return Result.error("创建失败");
                }
            } else {
                // 创建校级部门负责人（默认）
                Integer count = departmentHeadMapper.existsByUsername(dto.getCode());
                if (count != null && count > 0) {
                    return Result.error("工号已存在");
                }
                
                DepartmentHead head = new DepartmentHead();
                head.setXjbmfzrZh(dto.getCode());
                head.setXjbmfzrXm(dto.getUsername());
                head.setXjbmfzrMm(password);
                head.setXjbmMc(dto.getDepartment());
                head.setXjbmfzrDh(dto.getPhone());
                
                int rows = departmentHeadMapper.insertDepartmentHead(head);
                if (rows > 0) {
                    return Result.success("校级部门负责人账号创建成功，初始密码：" + password);
                } else {
                    return Result.error("创建失败");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("创建负责人账号失败: " + e.getMessage());
        }
    }

    /**
     * 更新负责人账号（管理员用）
     * 根据 accountType 更新不同类型的负责人
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> updateDepartmentHeadAccount(AccountUpdateDTO dto) {
        try {
            if (dto.getId() == null) {
                return Result.error("账号不能为空");
            }
            
            String username = String.valueOf(dto.getId());
            String accountType = dto.getAccountType();
            
            if ("academy".equals(accountType)) {
                // 更新学院负责人
                Academy academy = academyMapper.findByUsername(username);
                if (academy == null) {
                    return Result.error("学院负责人不存在");
                }
                
                academy.setFzrXm(dto.getUsername());
                academy.setXyMc(dto.getDepartment());
                academy.setXyDh(dto.getPhone());
                
                int rows = academyMapper.updateAcademy(academy);
                
                if (dto.getPassword() != null && !dto.getPassword().trim().isEmpty()) {
                    academyMapper.updatePassword(username, dto.getPassword());
                }
                
                if (rows > 0) {
                    return Result.success("学院负责人信息更新成功");
                } else {
                    return Result.error("更新失败");
                }
            } else {
                // 更新校级部门负责人
                DepartmentHead head = departmentHeadMapper.findByUsername(username);
                if (head == null) {
                    return Result.error("校级部门负责人不存在");
                }
                
                head.setXjbmfzrXm(dto.getUsername());
                head.setXjbmMc(dto.getDepartment());
                head.setXjbmfzrDh(dto.getPhone());
                
                int rows = departmentHeadMapper.updateDepartmentHead(head);
                
                if (dto.getPassword() != null && !dto.getPassword().trim().isEmpty()) {
                    departmentHeadMapper.updatePassword(username, dto.getPassword());
                }
                
                if (rows > 0) {
                    return Result.success("校级部门负责人信息更新成功");
                } else {
                    return Result.error("更新失败");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("更新负责人信息失败: " + e.getMessage());
        }
    }

    /**
     * 重置负责人密码（管理员用）
     * 根据 accountType 重置不同类型负责人的密码
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> resetDepartmentHeadPassword(String username, String accountType) {
        try {
            if (username == null || username.trim().isEmpty()) {
                return Result.error("账号不能为空");
            }
            
            String defaultPassword = "123456";
            int rows = 0;
            
            if ("academy".equals(accountType)) {
                // 重置学院负责人密码
                Academy academy = academyMapper.findByUsername(username);
                if (academy == null) {
                    return Result.error("学院负责人不存在");
                }
                rows = academyMapper.updatePassword(username, defaultPassword);
            } else {
                // 重置校级部门负责人密码
                DepartmentHead head = departmentHeadMapper.findByUsername(username);
                if (head == null) {
                    return Result.error("校级部门负责人不存在");
                }
                rows = departmentHeadMapper.updatePassword(username, defaultPassword);
            }
            
            if (rows > 0) {
                return Result.success("密码已重置为：" + defaultPassword);
            } else {
                return Result.error("密码重置失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("重置密码失败: " + e.getMessage());
        }
    }

    /**
     * 删除负责人账号（管理员用）
     * 根据 accountType 删除不同类型的负责人
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> deleteDepartmentHead(String username, String accountType) {
        try {
            if (username == null || username.trim().isEmpty()) {
                return Result.error("账号不能为空");
            }
            
            int rows = 0;
            if ("academy".equals(accountType)) {
                rows = academyMapper.deleteAcademy(username);
            } else {
                rows = departmentHeadMapper.deleteDepartmentHead(username);
            }
            
            if (rows > 0) {
                return Result.success("负责人账号删除成功");
            } else {
                return Result.error("删除失败，负责人不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("删除负责人账号失败: " + e.getMessage());
        }
    }
}
