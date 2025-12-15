package com.university.volunteer.service;

import com.university.volunteer.common.Result;
import com.university.volunteer.dto.VolunteerAuditDTO;
import com.university.volunteer.entity.VolunteerActivity;
import com.university.volunteer.mapper.StudentActivityMapper;
import com.university.volunteer.mapper.VolunteerAuditMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class AdminService {

    @Autowired
    private StudentActivityMapper studentActivityMapper;

    @Autowired
    private VolunteerAuditMapper volunteerAuditMapper;

    /**
     * 获取所有活动列表（管理员可以查看除"未申报"外的所有活动）
     */
    public Result<List<VolunteerActivity>> getAllActivities() {
        try {
            List<VolunteerActivity> activities = studentActivityMapper.findAllActivities();
            
            // 过滤掉"未申报"状态的活动，保留其他所有状态
            List<VolunteerActivity> visibleActivities = activities.stream()
                    .filter(activity -> !"未申报".equals(activity.getFbZt()))
                    .collect(java.util.stream.Collectors.toList());
            
            // 动态更新活动状态
            java.util.Date now = new java.util.Date();
            for (VolunteerActivity activity : visibleActivities) {
                String newStatus = calculateActivityStatus(activity, now);
                // 如果状态发生变化，更新数据库
                if (!newStatus.equals(activity.getHdZt())) {
                    activity.setHdZt(newStatus);
                    studentActivityMapper.updateActivityStatus(activity.getHdBh(), newStatus);
                }
            }
            
            return Result.success(visibleActivities);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取活动列表失败：" + e.getMessage());
        }
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
     * 发布活动（将"待发布"或"已下架"状态的活动改为"已发布"）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> publishActivity(Integer activityId) {
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
            // 修改逻辑：允许"待发布"或"已下架"的活动发布
            if (!"待发布".equals(currentStatus) && !"已下架".equals(currentStatus)) {
                return Result.error("只能发布状态为'待发布'或'已下架'的活动，当前状态：" + currentStatus);
            }
            
            int rows = studentActivityMapper.updateActivityPublishStatus(activityId, "已发布");
            if (rows > 0) {
                return Result.success("活动已发布");
            } else {
                return Result.error("发布失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("发布失败：" + e.getMessage());
        }
    }

    /**
     * 下架活动（将"已发布"状态的活动改为"已下架"）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> unpublishActivity(Integer activityId) {
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
            if (!"已发布".equals(currentStatus)) {
                return Result.error("只能下架状态为'已发布'的活动");
            }
            
            int rows = studentActivityMapper.updateActivityPublishStatus(activityId, "已下架");
            if (rows > 0) {
                return Result.success("活动已下架");
            } else {
                return Result.error("下架失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("下架失败：" + e.getMessage());
        }
    }

    /**
     * 获取志愿者审核列表
     * @param status 审核状态：未审核/已审核通过/已拒绝，为空则查询所有状态
     * @return 审核列表
     */
    public Result<List<VolunteerAuditDTO>> getVolunteerReviews(String status) {
        try {
            List<VolunteerAuditDTO> reviews = volunteerAuditMapper.findRegistrationsByStatus(status);
            return Result.success(reviews);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取审核列表失败：" + e.getMessage());
        }
    }

    /**
     * 根据ID获取志愿者审核详情
     * @param registrationId 报名ID
     * @return 审核详情
     */
    public Result<VolunteerAuditDTO> getVolunteerReviewDetail(Integer registrationId) {
        try {
            VolunteerAuditDTO review = volunteerAuditMapper.findRegistrationById(registrationId);
            if (review == null) {
                return Result.error("审核记录不存在");
            }
            return Result.success(review);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取审核详情失败：" + e.getMessage());
        }
    }

    /**
     * 审核通过志愿者报名
     * @param registrationId 报名ID
     * @return 操作结果
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> approveVolunteerRegistration(Integer registrationId) {
        try {
            // 1. 获取活动编号（用于更新YBM_RS）
            Integer activityId = volunteerAuditMapper.findActivityIdByRegistrationId(registrationId);
            if (activityId == null) {
                return Result.error("审核失败，未找到对应的活动");
            }
            
            // 2. 更新报名状态为"已审核通过"
            // 与数据库/其他模块保持一致：未审核/已审核通过/已拒绝
            int rows = volunteerAuditMapper.updateRegistrationStatus(registrationId, "已审核通过", null);
            if (rows > 0) {
                // 3. 更新活动的已报名人数（YBM_RS）
                // 注意：触发器会自动处理，但手动更新作为双重保障
                // 只统计"已审核通过"的记录
                studentActivityMapper.updateRegisteredCount(activityId);
                return Result.success("审核通过");
            } else {
                return Result.error("审核失败，请检查报名ID是否正确");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("审核失败：" + e.getMessage());
        }
    }

    /**
     * 审核拒绝志愿者报名
     * @param registrationId 报名ID
     * @param reason 拒绝原因
     * @return 操作结果
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> rejectVolunteerRegistration(Integer registrationId, String reason) {
        try {
            // 1. 获取活动编号和原状态（用于更新YBM_RS）
            Integer activityId = volunteerAuditMapper.findActivityIdByRegistrationId(registrationId);
            if (activityId == null) {
                return Result.error("操作失败，未找到对应的活动");
            }
            
            // 2. 查询原状态，判断是否需要减少YBM_RS
            VolunteerAuditDTO oldRegistration = volunteerAuditMapper.findRegistrationById(registrationId);
            boolean wasApproved = oldRegistration != null && "已审核通过".equals(oldRegistration.getStatus());
            
            // 3. 更新报名状态为"已拒绝"
            int rows = volunteerAuditMapper.updateRegistrationStatus(registrationId, "已拒绝", reason);
            if (rows > 0) {
                // 4. 如果原状态是"已审核通过"，需要更新YBM_RS（减少人数）
                // 注意：触发器会自动处理，但手动更新作为双重保障
                if (wasApproved) {
                    studentActivityMapper.updateRegisteredCount(activityId);
                }
                return Result.success("已拒绝该报名申请");
            } else {
                return Result.error("操作失败，请检查报名ID是否正确");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("操作失败：" + e.getMessage());
        }
    }
}