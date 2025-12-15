package com.university.volunteer.controller;

import com.university.volunteer.common.Result;
import com.university.volunteer.dto.ActivityPerformanceDTO;
import com.university.volunteer.dto.ActivityRecommendDTO;
import com.university.volunteer.entity.ActivityRegistration;
import com.university.volunteer.entity.VolunteerActivity;
import com.university.volunteer.service.StudentActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/student")
public class StudentActivityController {

    @Autowired
    private StudentActivityService studentActivityService;

    @GetMapping("/registrations")
    public Result<List<ActivityRegistration>> getRegistrationStatus(@RequestParam String studentId) {
        return studentActivityService.getRegistrationStatus(studentId);
    }

    /**
     * 公假单（已确认）列表
     */
    @GetMapping("/leave-permits")
    public Result<List<ActivityRegistration>> getLeavePermits(@RequestParam String studentId) {
        return studentActivityService.getConfirmedLeavePermits(studentId);
    }

    /**
     * 公假单下载
     */
    @GetMapping("/leave-permits/{registrationId}/download")
    public org.springframework.http.ResponseEntity<byte[]> downloadLeavePermit(@PathVariable Integer registrationId,
                                                                              @RequestParam String studentId) {
        return studentActivityService.downloadLeavePermit(studentId, registrationId);
    }

    /**
     * 证明（已确认）列表
     */
    @GetMapping("/certificates")
    public Result<List<ActivityRegistration>> getCertificates(@RequestParam String studentId) {
        return studentActivityService.getConfirmedCertificates(studentId);
    }

    /**
     * 证明下载
     */
    @GetMapping("/certificates/{registrationId}/download")
    public org.springframework.http.ResponseEntity<byte[]> downloadCertificate(@PathVariable Integer registrationId,
                                                                              @RequestParam String studentId) {
        return studentActivityService.downloadCertificate(studentId, registrationId);
    }

    /**
     * 学生活动评分
     */
    @PutMapping("/performance/{registrationId}/rate")
    public Result<String> rateActivity(@PathVariable Integer registrationId,
                                       @RequestBody Map<String, Object> body) {
        String studentId = (String) body.get("studentId");
        Integer rating = body.get("rating") == null ? null : Integer.parseInt(body.get("rating").toString());
        return studentActivityService.rateActivity(studentId, registrationId, rating);
    }

    @GetMapping("/performance")
    public Result<List<ActivityPerformanceDTO>> getActivityPerformance(@RequestParam String studentId) {
        return studentActivityService.getActivityPerformance(studentId);
    }

    /**
     * 活动详情（学生端查看）
     */
    @GetMapping("/activity/{activityId}")
    public Result<VolunteerActivity> getActivityDetail(@PathVariable Integer activityId) {
        return studentActivityService.getActivityDetail(activityId);
    }

    /**
     * 增加活动浏览次数
     * 前端在点击"查看详情"按钮时调用此接口
     * 使用 POST 方法，路径为 /api/student/activity/{id}/view
     * 
     * 注意：此接口设计为"只写不读"，不返回具体数据，只返回操作状态
     * 前端应该以"Fire and Forget"方式调用，不等待响应，避免影响用户体验
     * 
     * @param activityId 活动ID
     * @return 操作结果
     */
    @PostMapping("/activity/{activityId}/view")
    public Result<String> addViewCount(@PathVariable Integer activityId) {
        return studentActivityService.addViewCount(activityId);
    }

    /**
     * 报名参加活动
     *
     * @param requestBody 包含 studentId 和 activityId
     */
    @PostMapping("/activity/register")
    public Result<String> registerActivity(@RequestBody Map<String, Object> requestBody) {
        String studentId = (String) requestBody.get("studentId");
        Integer activityId = (Integer) requestBody.get("activityId");

        if (studentId == null || activityId == null) {
            return Result.error("参数不完整");
        }

        return studentActivityService.registerActivity(studentId, activityId);
    }

    /**
     * 取消报名
     *
     * @param requestBody 包含 studentId 和 activityId
     */
    @PostMapping("/activity/cancel")
    public Result<String> cancelRegistration(@RequestBody Map<String, Object> requestBody) {
        String studentId = (String) requestBody.get("studentId");
        Integer activityId = (Integer) requestBody.get("activityId");

        if (studentId == null || activityId == null) {
            return Result.error("参数不完整");
        }

        return studentActivityService.cancelRegistration(studentId, activityId);
    }

    /**
     * 智能推荐活动（升级版）
     * 基于学生标签的内容推荐算法 + 热门兜底策略
     * 新增：引入浏览次数作为推荐权重因子
     *
     * @param studentId 学生学号
     * @return 推荐活动列表（最多10个）
     */
    @GetMapping("/activity/recommend")
    public Result<List<ActivityRecommendDTO>> getRecommendedActivities(@RequestParam Integer studentId) {
        return studentActivityService.getRecommendedActivities(studentId);
    }
}
