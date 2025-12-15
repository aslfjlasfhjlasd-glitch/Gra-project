package com.university.volunteer.entity;

import java.util.Date;

/**
 * 活动-标签关联实体类
 * 对应数据库表: t_zyhd_bq
 */
public class ActivityTag {
    // 活动编号
    private Integer hdBh;
    // 标签ID
    private Integer bqId;
    // 创建时间
    private Date createTime;

    public ActivityTag() {
    }

    public ActivityTag(Integer hdBh, Integer bqId) {
        this.hdBh = hdBh;
        this.bqId = bqId;
    }

    public Integer getHdBh() {
        return hdBh;
    }

    public void setHdBh(Integer hdBh) {
        this.hdBh = hdBh;
    }

    public Integer getBqId() {
        return bqId;
    }

    public void setBqId(Integer bqId) {
        this.bqId = bqId;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}