package com.university.volunteer.entity;

import java.util.Date;

public class ActivityRegistration {
    /**
     * 记录ID (ID)
     */
    private Integer id;

    /**
     * 学生学号 (XS_XH)
     */
    private String studentId;

    /**
     * 学生姓名 (XS_XM)
     */
    private String studentName;

    /**
     * 所属学院 (SS_XY)
     */
    private String academyName;

    /**
     * 已报名活动编号 (HD_BH)
     */
    private String activityId;

    /**
     * 已报名活动名称 (HD_MC)
     */
    private String activityName;

    /**
     * 已报名活动的活动时间 (HD_SJ)
     */
    private String activityTime;

    /**
     * 已报名活动的活动地点 (HD_DD)
     */
    private String activityLocation;

    /**
     * 报名状态：未审核；已审核通过；已拒绝 (BM_ZT)
     */
    private String status;

    /**
     * 审核/驳回理由 (SH_LY)
     */
    private String auditReason;

    /**
     * 签到时间 (QD_SJ)
     */
    private Date checkInTime;

    /**
     * 签退时间 (QT_SJ)
     */
    private Date checkOutTime;

    /**
     * 考勤状态: 0-未签 1-正常 2-迟到 3-缺勤 (QD_ZT)
     */
    private Integer attendanceStatus;

    /**
     * 参与活动时长 (HD_SC)
     */
    private Double duration;

    /**
     * 获得学分 (HD_XF)
     */
    private Double credits;

    /**
     * 志愿者评价 (ZYZ_PJ)
     */
    private String evaluation;

    /**
     * 负责人评分(1-5分) (FZR_PF)
     */
    private Integer rating;

    /**
     * 公假单确认状态 (GJD_ZT) 1-已确认 0-未确认
     */
    private Integer leaveConfirmed;

    /**
     * 公假单出具时间 (GJD_SJ)
     */
    private Date leaveIssuedAt;

    /**
     * 证明确认状态 (ZM_ZT) 1-已确认 0-未确认
     */
    private Integer certificateConfirmed;

    /**
     * 证明出具时间 (ZM_SJ)
     */
    private Date certificateIssuedAt;

    /**
     * 活动所属单位（用于负责人权限校验）
     */
    private String activityDepartment;

    /**
     * 活动状态（用于筛选已结束）
     */
    private String activityStatus;
    /**
     * 报名时间 (BM_SJ) - 新增字段
     */
    private Date registerTime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getAcademyName() {
        return academyName;
    }

    public void setAcademyName(String academyName) {
        this.academyName = academyName;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName;
    }

    public String getActivityTime() {
        return activityTime;
    }

    public void setActivityTime(String activityTime) {
        this.activityTime = activityTime;
    }

    public String getActivityLocation() {
        return activityLocation;
    }

    public void setActivityLocation(String activityLocation) {
        this.activityLocation = activityLocation;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAuditReason() {
        return auditReason;
    }

    public void setAuditReason(String auditReason) {
        this.auditReason = auditReason;
    }

    public Date getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(Date checkInTime) {
        this.checkInTime = checkInTime;
    }

    public Date getCheckOutTime() {
        return checkOutTime;
    }

    public void setCheckOutTime(Date checkOutTime) {
        this.checkOutTime = checkOutTime;
    }

    public Integer getAttendanceStatus() {
        return attendanceStatus;
    }

    public void setAttendanceStatus(Integer attendanceStatus) {
        this.attendanceStatus = attendanceStatus;
    }

    public Double getDuration() {
        return duration;
    }

    public void setDuration(Double duration) {
        this.duration = duration;
    }

    public Double getCredits() {
        return credits;
    }

    public void setCredits(Double credits) {
        this.credits = credits;
    }

    public String getEvaluation() {
        return evaluation;
    }

    public void setEvaluation(String evaluation) {
        this.evaluation = evaluation;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public Integer getLeaveConfirmed() {
        return leaveConfirmed;
    }

    public void setLeaveConfirmed(Integer leaveConfirmed) {
        this.leaveConfirmed = leaveConfirmed;
    }

    public Date getLeaveIssuedAt() {
        return leaveIssuedAt;
    }

    public void setLeaveIssuedAt(Date leaveIssuedAt) {
        this.leaveIssuedAt = leaveIssuedAt;
    }

    public Integer getCertificateConfirmed() {
        return certificateConfirmed;
    }

    public void setCertificateConfirmed(Integer certificateConfirmed) {
        this.certificateConfirmed = certificateConfirmed;
    }

    public Date getCertificateIssuedAt() {
        return certificateIssuedAt;
    }

    public void setCertificateIssuedAt(Date certificateIssuedAt) {
        this.certificateIssuedAt = certificateIssuedAt;
    }

    public String getActivityDepartment() {
        return activityDepartment;
    }

    public void setActivityDepartment(String activityDepartment) {
        this.activityDepartment = activityDepartment;
    }

    public String getActivityStatus() {
        return activityStatus;
    }

    public void setActivityStatus(String activityStatus) {
        this.activityStatus = activityStatus;
    }

    public Date getRegisterTime() {
        return registerTime;
    }

    public void setRegisterTime(Date registerTime) {
        this.registerTime = registerTime;
    }
}
