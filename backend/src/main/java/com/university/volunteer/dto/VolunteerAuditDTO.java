package com.university.volunteer.dto;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 志愿者审核数据传输对象
 * 包含报名信息、学生摘要和学生详情
 */
public class VolunteerAuditDTO {
    // 报名信息
    private Long id;                    // 报名记录ID
    private String activityName;        // 活动名称
    private LocalDateTime registerTime; // 报名时间
    private String status;              // 状态：未审核/已审核通过/已拒绝
    
    // 学生摘要（列表用）
    private String studentName;         // 学生姓名
    
    // 学生详情（弹窗用）
    private Long studentId;             // 学号
    private String college;             // 学院
    private String className;           // 班级
    private String phone;               // 联系电话
    private String politic;             // 政治面貌
    private String interests;           // 兴趣标签
    private String skills;              // 技能标签
    private String introduction;        // 个人简介
    private String auditReason;         // 驳回原因
    
    // 活动详情
    private Long activityId;            // 活动ID
    private Integer requiredVolunteers; // 需要志愿者数量
    private Integer currentVolunteers;  // 当前报名人数
    
    // 构造函数
    public VolunteerAuditDTO() {
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName;
    }

    public LocalDateTime getRegisterTime() {
        return registerTime;
    }

    public void setRegisterTime(LocalDateTime registerTime) {
        this.registerTime = registerTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public Long getStudentId() {
        return studentId;
    }

    public void setStudentId(Long studentId) {
        this.studentId = studentId;
    }

    public String getCollege() {
        return college;
    }

    public void setCollege(String college) {
        this.college = college;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPolitic() {
        return politic;
    }

    public void setPolitic(String politic) {
        this.politic = politic;
    }

    public String getInterests() {
        return interests;
    }

    public void setInterests(String interests) {
        this.interests = interests;
    }

    public String getSkills() {
        return skills;
    }

    public void setSkills(String skills) {
        this.skills = skills;
    }

    public String getIntroduction() {
        return introduction;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }

    public String getAuditReason() {
        return auditReason;
    }

    public void setAuditReason(String auditReason) {
        this.auditReason = auditReason;
    }

    public Long getActivityId() {
        return activityId;
    }

    public void setActivityId(Long activityId) {
        this.activityId = activityId;
    }

    public Integer getRequiredVolunteers() {
        return requiredVolunteers;
    }

    public void setRequiredVolunteers(Integer requiredVolunteers) {
        this.requiredVolunteers = requiredVolunteers;
    }

    public Integer getCurrentVolunteers() {
        return currentVolunteers;
    }

    public void setCurrentVolunteers(Integer currentVolunteers) {
        this.currentVolunteers = currentVolunteers;
    }

    @Override
    public String toString() {
        return "VolunteerAuditDTO{" +
                "id=" + id +
                ", activityName='" + activityName + '\'' +
                ", registerTime=" + registerTime +
                ", status='" + status + '\'' +
                ", studentName='" + studentName + '\'' +
                ", studentId=" + studentId +
                ", college='" + college + '\'' +
                ", className='" + className + '\'' +
                ", phone='" + phone + '\'' +
                ", politic='" + politic + '\'' +
                '}';
    }
}