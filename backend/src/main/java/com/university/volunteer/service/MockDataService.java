package com.university.volunteer.service;

import com.university.volunteer.mapper.StudentActivityMapper;
import com.university.volunteer.mapper.VolunteerAuditMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * 模拟数据生成服务
 * 用于演示和测试，生成随机的志愿活动报名和审核数据
 */
@Service
public class MockDataService {

    @Autowired
    private StudentActivityMapper studentActivityMapper;

    @Autowired
    private VolunteerAuditMapper volunteerAuditMapper;

    private static final Random random = new Random();
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    /**
     * 生成模拟数据
     * @param count 生成数据条数
     * @return 生成结果描述
     */
    @Transactional
    public String generateMockData(int count) {
        int registrationCount = 0;
        int auditCount = 0;

        try {
            // 生成活动报名数据
            registrationCount = generateActivityRegistrations(count);
            
            // 生成志愿审核数据
            auditCount = generateVolunteerAudits(count);

            return String.format("成功生成 %d 条活动报名数据和 %d 条志愿审核数据", 
                registrationCount, auditCount);
        } catch (Exception e) {
            throw new RuntimeException("生成模拟数据失败: " + e.getMessage(), e);
        }
    }

    /**
     * 生成活动报名数据
     */
    private int generateActivityRegistrations(int count) {
        List<Integer> studentIds = getAvailableStudentIds();
        List<Integer> activityIds = getAvailableActivityIds();

        if (studentIds.isEmpty() || activityIds.isEmpty()) {
            return 0;
        }

        int successCount = 0;
        LocalDateTime now = LocalDateTime.now();

        for (int i = 0; i < count; i++) {
            try {
                Integer studentId = studentIds.get(random.nextInt(studentIds.size()));
                Integer activityId = activityIds.get(random.nextInt(activityIds.size()));
                
                // 随机生成过去30天内的报名时间
                LocalDateTime registrationTime = now.minusDays(random.nextInt(30))
                    .minusHours(random.nextInt(24))
                    .minusMinutes(random.nextInt(60));

                // 随机状态：已报名(0)、已签到(1)、已完成(2)、已取消(3)
                int status = random.nextInt(4);
                
                // 插入数据
                studentActivityMapper.insertMockRegistration(
                    studentId, 
                    activityId, 
                    registrationTime.format(formatter),
                    status
                );
                successCount++;
            } catch (Exception e) {
                // 忽略重复数据等错误，继续生成
                continue;
            }
        }

        return successCount;
    }

    /**
     * 生成志愿审核数据
     */
    private int generateVolunteerAudits(int count) {
        List<Integer> studentIds = getAvailableStudentIds();
        List<Integer> activityIds = getAvailableActivityIds();

        if (studentIds.isEmpty() || activityIds.isEmpty()) {
            return 0;
        }

        int successCount = 0;
        LocalDateTime now = LocalDateTime.now();

        for (int i = 0; i < count; i++) {
            try {
                Integer studentId = studentIds.get(random.nextInt(studentIds.size()));
                Integer activityId = activityIds.get(random.nextInt(activityIds.size()));
                
                // 随机生成过去30天内的提交时间
                LocalDateTime submitTime = now.minusDays(random.nextInt(30))
                    .minusHours(random.nextInt(24))
                    .minusMinutes(random.nextInt(60));

                // 随机工时：1-8小时
                double hours = 1 + random.nextInt(8) + random.nextDouble();
                hours = Math.round(hours * 10) / 10.0; // 保留一位小数

                // 随机状态：待审核(0)、已通过(1)、已拒绝(2)
                int status = random.nextInt(3);
                
                // 审核时间（如果已审核）
                String auditTime = null;
                if (status > 0) {
                    auditTime = submitTime.plusDays(random.nextInt(3))
                        .plusHours(random.nextInt(24))
                        .format(formatter);
                }

                // 插入数据
                volunteerAuditMapper.insertMockAudit(
                    studentId,
                    activityId,
                    hours,
                    "模拟生成的志愿活动记录 #" + (i + 1),
                    submitTime.format(formatter),
                    status,
                    auditTime,
                    status == 2 ? "不符合要求" : null
                );
                successCount++;
            } catch (Exception e) {
                // 忽略重复数据等错误，继续生成
                continue;
            }
        }

        return successCount;
    }

    /**
     * 获取可用的学生ID列表
     */
    private List<Integer> getAvailableStudentIds() {
        List<Integer> ids = studentActivityMapper.getAllStudentIds();
        return ids != null ? ids : new ArrayList<>();
    }

    /**
     * 获取可用的活动ID列表
     */
    private List<Integer> getAvailableActivityIds() {
        List<Integer> ids = studentActivityMapper.getAllActivityIds();
        return ids != null ? ids : new ArrayList<>();
    }

    /**
     * 清空模拟数据（可选功能）
     */
    @Transactional
    public String clearMockData() {
        try {
            // 这里可以添加清空逻辑，但要小心不要删除真实数据
            // 建议在生成时添加标记字段来区分模拟数据
            return "清空功能暂未实现，请手动清理数据库";
        } catch (Exception e) {
            throw new RuntimeException("清空数据失败: " + e.getMessage(), e);
        }
    }
}