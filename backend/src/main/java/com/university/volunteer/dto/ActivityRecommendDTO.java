package com.university.volunteer.dto;

import com.university.volunteer.entity.Tag;
import com.university.volunteer.entity.VolunteerActivity;

import java.util.List;

/**
 * 活动推荐DTO
 * 包含活动信息、匹配分数和推荐理由
 */
public class ActivityRecommendDTO {
    
    private VolunteerActivity activity;
    
    /**
     * 匹配分数（标签重合数量）
     */
    private Integer matchScore;
    
    /**
     * 推荐理由（匹配的标签列表）
     */
    private List<String> matchedTags;
    
    /**
     * 活动的所有标签
     */
    private List<Tag> activityTags;
    
    /**
     * 推荐类型：CONTENT_BASED(基于内容), HOT(热门兜底), LATEST(最新兜底)
     */
    private String recommendType;

    public ActivityRecommendDTO() {
    }

    public ActivityRecommendDTO(VolunteerActivity activity, Integer matchScore, 
                                List<String> matchedTags, List<Tag> activityTags, 
                                String recommendType) {
        this.activity = activity;
        this.matchScore = matchScore;
        this.matchedTags = matchedTags;
        this.activityTags = activityTags;
        this.recommendType = recommendType;
    }

    // Getters and Setters
    public VolunteerActivity getActivity() {
        return activity;
    }

    public void setActivity(VolunteerActivity activity) {
        this.activity = activity;
    }

    public Integer getMatchScore() {
        return matchScore;
    }

    public void setMatchScore(Integer matchScore) {
        this.matchScore = matchScore;
    }

    public List<String> getMatchedTags() {
        return matchedTags;
    }

    public void setMatchedTags(List<String> matchedTags) {
        this.matchedTags = matchedTags;
    }

    public List<Tag> getActivityTags() {
        return activityTags;
    }

    public void setActivityTags(List<Tag> activityTags) {
        this.activityTags = activityTags;
    }

    public String getRecommendType() {
        return recommendType;
    }

    public void setRecommendType(String recommendType) {
        this.recommendType = recommendType;
    }
}