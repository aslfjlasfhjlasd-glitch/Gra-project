package com.university.volunteer.dto;

public class ActivityPerformanceDTO {
    /**
     * 活动编号 (from t_zyhdbmb)
     */
    private String activityId;

    /**
     * 活动名称 (from t_zyhdbmb)
     */
    private String activityName;

    /**
     * 活动时间 (from t_zyhdbmb)
     */
    private String activityTime;

    /**
     * 参与活动时长 (from t_zyhdbmb)
     */
    private Double duration;

    /**
     * 获得学分 (from t_zyhdbmb)
     */
    private Double credits;

    /**
     * 负责人评分 (FZR_PF)
     */
    private Double leaderRating;

    /**
     * 负责人评价 (ZYZ_PJ)
     */
    private String leaderComment;

    /**
     * 学生对活动评分 (XS_PF)
     */
    private Integer activityRating;

    /**
     * 报名记录ID，用于评分提交
     */
    private Integer registrationId;

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

    public Double getLeaderRating() {
        return leaderRating;
    }

    public void setLeaderRating(Double leaderRating) {
        this.leaderRating = leaderRating;
    }

    public String getLeaderComment() {
        return leaderComment;
    }

    public void setLeaderComment(String leaderComment) {
        this.leaderComment = leaderComment;
    }

    public Integer getActivityRating() {
        return activityRating;
    }

    public void setActivityRating(Integer activityRating) {
        this.activityRating = activityRating;
    }

    public Integer getRegistrationId() {
        return registrationId;
    }

    public void setRegistrationId(Integer registrationId) {
        this.registrationId = registrationId;
    }
}
