package com.university.volunteer.service;

import com.university.volunteer.common.Result;
import com.university.volunteer.mapper.DashboardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class DashboardService {

    @Autowired
    private DashboardMapper dashboardMapper;

    /**
     * 获取各学院参与度统计数据
     */
    public Result<List<Map<String, Object>>> getAcademyStats() {
        try {
            List<Map<String, Object>> stats = dashboardMapper.getAcademyParticipationStats();
            return Result.success(stats);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取统计数据失败: " + e.getMessage());
        }
    }

    public Result<List<Map<String, Object>>> listActivities() {
        try {
            List<Map<String, Object>> rows = dashboardMapper.listVolunteerActivities();
            return Result.success(rows);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取活动列表失败: " + e.getMessage());
        }
    }

    public Result<Map<String, Object>> getActivityDetail(Integer id) {
        try {
            Map<String, Object> row = dashboardMapper.getVolunteerActivityDetail(id);
            return Result.success(row);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取活动详情失败: " + e.getMessage());
        }
    }
}
