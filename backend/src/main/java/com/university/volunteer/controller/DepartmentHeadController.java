package com.university.volunteer.controller;

import com.university.volunteer.common.Result;
import com.university.volunteer.entity.VolunteerActivity;
import com.university.volunteer.service.DepartmentHeadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/head")
public class DepartmentHeadController {

    @Autowired
    private DepartmentHeadService departmentHeadService;

    /**
     * 审核活动报名
     * @param requestBody 包含 registrationId 和 status
     */
    @PostMapping("/audit/registration")
    public Result<String> auditRegistration(@RequestBody Map<String, Object> requestBody) {
        Integer registrationId = (Integer) requestBody.get("registrationId");
        String status = (String) requestBody.get("status");

        if (registrationId == null || status == null) {
            return Result.error("参数不完整");
        }

        if (!"已审核通过".equals(status) && !"已拒绝".equals(status)) {
            return Result.error("无效的状态值");
        }

        return departmentHeadService.auditRegistration(registrationId, status);
    }

    /**
     * 获取负责人信息
     * @param username 用户账号
     */
    @GetMapping("/info/{username}")
    public Result<Map<String, Object>> getHeadInfo(@PathVariable String username) {
        return departmentHeadService.getHeadInfo(username);
    }

    /**
     * 更新负责人信息
     * @param requestBody 包含 username, name, phone
     */
    @PutMapping("/info")
    public Result<String> updateHeadInfo(@RequestBody Map<String, String> requestBody) {
        String username = requestBody.get("username");
        String name = requestBody.get("name");
        String phone = requestBody.get("phone");

        if (username == null || name == null || phone == null) {
            return Result.error("参数不完整");
        }

        return departmentHeadService.updateHeadInfo(username, name, phone);
    }

    /**
     * 修改密码
     * @param requestBody 包含 username, oldPassword, newPassword
     */
    @PutMapping("/password")
    public Result<String> updatePassword(@RequestBody Map<String, String> requestBody) {
        String username = requestBody.get("username");
        String oldPassword = requestBody.get("oldPassword");
        String newPassword = requestBody.get("newPassword");

        if (username == null || oldPassword == null || newPassword == null) {
            return Result.error("参数不完整");
        }

        return departmentHeadService.updatePassword(username, oldPassword, newPassword);
    }

    /**
     * 获取负责人发起的活动列表
     * @param username 负责人账号
     */
    @GetMapping("/activities/{username}")
    public Result<?> getActivitiesByHead(@PathVariable String username) {
        return departmentHeadService.getActivitiesByHead(username);
    }

    /**
     * 获取负责人管理的报名记录列表
     * @param username 负责人账号
     */
    @GetMapping("/registrations/{username}")
    public Result<?> getRegistrationsByHead(@PathVariable String username) {
        try {
            return departmentHeadService.getRegistrationsByHead(username);
        } catch (Exception e) {
            e.printStackTrace();
            return com.university.volunteer.common.Result.error("获取报名记录失败：" + e.getMessage());
        }
    }

    /**
     * 更新活动信息
     * @param activity 活动信息
     */
    @PutMapping("/activity")
    public Result<String> updateActivity(@RequestBody VolunteerActivity activity) {
        return departmentHeadService.updateActivity(activity);
    }

    /**
     * 删除活动
     * @param activityId 活动编号
     */
    @DeleteMapping("/activity/{activityId}")
    public Result<String> deleteActivity(@PathVariable Integer activityId) {
        return departmentHeadService.deleteActivity(activityId);
    }

    /**
     * 更新考勤
     */
    @PutMapping("/attendance/{registrationId}")
    public Result<String> updateAttendance(@PathVariable Integer registrationId,
                                           @RequestBody Map<String, Object> body) {
        String username = (String) body.get("username");
        Long checkInTime = body.get("checkInTime") == null ? null : Long.parseLong(body.get("checkInTime").toString());
        Long checkOutTime = body.get("checkOutTime") == null ? null : Long.parseLong(body.get("checkOutTime").toString());
        Integer attendanceStatus = body.get("attendanceStatus") == null ? null : Integer.parseInt(body.get("attendanceStatus").toString());
        return departmentHeadService.updateAttendance(username, registrationId, checkInTime, checkOutTime, attendanceStatus);
    }

    /**
     * 确认工时学分
     */
    @PutMapping("/credits/{registrationId}")
    public Result<String> confirmCredits(@PathVariable Integer registrationId,
                                         @RequestBody Map<String, Object> body) {
        String username = (String) body.get("username");
        Double duration = body.get("duration") == null ? null : Double.parseDouble(body.get("duration").toString());
        Double credits = body.get("credits") == null ? null : Double.parseDouble(body.get("credits").toString());
        return departmentHeadService.confirmDurationAndCredits(username, registrationId, duration, credits);
    }

    /**
     * 评价志愿者
     */
    @PutMapping("/evaluation/{registrationId}")
    public Result<String> evaluateVolunteer(@PathVariable Integer registrationId,
                                            @RequestBody Map<String, Object> body) {
        String username = (String) body.get("username");
        Integer rating = body.get("rating") == null ? null : Integer.parseInt(body.get("rating").toString());
        String evaluation = (String) body.get("evaluation");
        return departmentHeadService.evaluateVolunteer(username, registrationId, rating, evaluation);
    }

    /**
     * 确认公假单
     */
    @PutMapping("/permit/{registrationId}/confirm")
    public Result<String> confirmLeavePermit(@PathVariable Integer registrationId,
                                             @RequestBody Map<String, Object> body) {
        String username = (String) body.get("username");
        return departmentHeadService.confirmLeavePermit(username, registrationId);
    }

    /**
     * 确认证明
     */
    @PutMapping("/certificate/{registrationId}/confirm")
    public Result<String> confirmCertificate(@PathVariable Integer registrationId,
                                             @RequestBody Map<String, Object> body) {
        String username = (String) body.get("username");
        return departmentHeadService.confirmCertificate(username, registrationId);
    }

    /**
     * 导出公假单
     */
    @GetMapping("/permit/{registrationId}")
    public ResponseEntity<byte[]> exportLeavePermit(@PathVariable Integer registrationId,
                                                    @RequestParam String username) {
        return departmentHeadService.exportLeavePermit(username, registrationId);
    }

    /**
     * 导出参与证明
     */
    @GetMapping("/certificate/{registrationId}")
    public ResponseEntity<byte[]> exportCertificate(@PathVariable Integer registrationId,
                                                    @RequestParam String username,
                                                    @RequestParam(defaultValue = "false") boolean credits) {
        return departmentHeadService.exportCertificate(username, registrationId, credits);
    }

    /**
     * 下架活动
     * @param activityId 活动编号
     */
    @PutMapping("/activity/{activityId}/unpublish")
    public Result<String> unpublishActivity(@PathVariable Integer activityId) {
        return departmentHeadService.unpublishActivity(activityId);
    }

    /**
     * 上架活动（已废弃，负责人不再有此权限）
     * @param activityId 活动编号
     */
    @Deprecated
    @PutMapping("/activity/{activityId}/publish")
    public Result<String> publishActivity(@PathVariable Integer activityId) {
        return Result.error("负责人无权限发布活动，请申报后由管理员发布");
    }

    /**
     * 申报活动（将活动状态从"待申报"改为"待发布"）
     * @param activityId 活动编号
     */
    @PutMapping("/activity/{activityId}/submit")
    public Result<String> submitActivity(@PathVariable Integer activityId) {
        return departmentHeadService.submitActivity(activityId);
    }

    /**
     * 撤销申报（将活动状态从"待发布"改回"待申报"）
     * @param activityId 活动编号
     */
    @PutMapping("/activity/{activityId}/cancel-submit")
    public Result<String> cancelSubmitActivity(@PathVariable Integer activityId) {
        return departmentHeadService.cancelSubmitActivity(activityId);
    }

    /**
     * 创建新活动
     * @param requestBody 包含 username 和 activity 信息
     */
    @PostMapping("/activity")
    public Result<VolunteerActivity> createActivity(@RequestBody Map<String, Object> requestBody) {
        String username = (String) requestBody.get("username");
        if (username == null || username.isEmpty()) {
            return Result.error("用户名不能为空");
        }

        // 将 activity 数据转换为 VolunteerActivity 对象
        @SuppressWarnings("unchecked")
        Map<String, Object> activityData = (Map<String, Object>) requestBody.get("activity");
        if (activityData == null) {
            return Result.error("活动信息不能为空");
        }

        VolunteerActivity activity = new VolunteerActivity();
        activity.setHdMc((String) activityData.get("hdMc"));
        activity.setHdNr((String) activityData.get("hdNr"));
        activity.setHdDd((String) activityData.get("hdDd"));
        
        // 处理招募人数
        Object zmRsObj = activityData.get("zmRs");
        if (zmRsObj != null) {
            if (zmRsObj instanceof Integer) {
                activity.setZmRs((Integer) zmRsObj);
            } else if (zmRsObj instanceof String) {
                try {
                    activity.setZmRs(Integer.parseInt((String) zmRsObj));
                } catch (NumberFormatException e) {
                    return Result.error("招募人数格式错误");
                }
            }
        }

        // 处理时间字段
        try {
            if (activityData.get("bmKssj") != null) {
                activity.setBmKssj(new java.util.Date(Long.parseLong(activityData.get("bmKssj").toString())));
            }
            if (activityData.get("bmJssj") != null) {
                activity.setBmJssj(new java.util.Date(Long.parseLong(activityData.get("bmJssj").toString())));
            }
            if (activityData.get("hdKssj") != null) {
                activity.setHdKssj(new java.util.Date(Long.parseLong(activityData.get("hdKssj").toString())));
            }
            if (activityData.get("hdJssj") != null) {
                activity.setHdJssj(new java.util.Date(Long.parseLong(activityData.get("hdJssj").toString())));
            }
        } catch (Exception e) {
            return Result.error("时间格式错误");
        }

        activity.setHdBq((String) activityData.get("hdBq"));
        activity.setJnYq((String) activityData.get("jnYq"));
        activity.setZyXz((String) activityData.get("zyXz"));
        activity.setHdXq((String) activityData.get("hdXq"));
        activity.setHdBz((String) activityData.get("hdBz"));

        return departmentHeadService.createActivity(username, activity);
    }
}
