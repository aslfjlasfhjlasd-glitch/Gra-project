package com.university.volunteer.controller;

import com.university.volunteer.common.Result;
import com.university.volunteer.service.ConfigService;
import com.university.volunteer.service.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;

    @Autowired
    private ConfigService configService;

    /**
     * 获取大屏综合数据（包含统计数据和配置信息）
     * @return 大屏数据
     */
    @GetMapping("/data")
    public Result<Map<String, Object>> getDashboardData() {
        try {
            Map<String, Object> result = new HashMap<>();
            
            // 获取统计数据
            Result<List<Map<String, Object>>> academyStats = dashboardService.getAcademyStats();
            Result<List<Map<String, Object>>> activities = dashboardService.listActivities();
            
            // 获取配置信息
            Map<String, Object> configs = configService.getDashboardConfigs();
            
            // 组装数据
            result.put("academyStats", academyStats.getData());
            result.put("activities", activities.getData());
            result.put("configs", configs);
            
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("获取大屏数据失败: " + e.getMessage());
        }
    }

    /**
     * 获取各学院参与度统计
     */
    @GetMapping("/academy-stats")
    public Result<List<Map<String, Object>>> getAcademyStats() {
        return dashboardService.getAcademyStats();
    }

    /**
     * 获取活动列表
     */
    @GetMapping("/activities")
    public Result<List<Map<String, Object>>> listActivities() {
        return dashboardService.listActivities();
    }

    /**
     * 获取活动详情
     * @param id 活动ID
     */
    @GetMapping("/activities/{id}")
    public Result<Map<String, Object>> getActivityDetail(@PathVariable("id") Integer id) {
        return dashboardService.getActivityDetail(id);
    }

    /**
     * 获取大屏配置信息（单独接口）
     * @return 配置信息
     */
    @GetMapping("/configs")
    public Result<Map<String, Object>> getDashboardConfigs() {
        try {
            Map<String, Object> configs = configService.getDashboardConfigs();
            return Result.success(configs);
        } catch (Exception e) {
            return Result.error("获取配置信息失败: " + e.getMessage());
        }
    }
}
