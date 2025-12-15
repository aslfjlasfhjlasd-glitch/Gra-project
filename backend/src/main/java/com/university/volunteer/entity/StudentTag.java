package com.university.volunteer.entity;

import java.util.Date;

/**
 * 学生-标签关联实体类
 * 对应数据库表: t_xs_bq
 */
public class StudentTag {
    // 学生学号
    private Integer xsXh;
    // 标签ID
    private Integer bqId;
    // 创建时间
    private Date createTime;

    public StudentTag() {
    }

    public StudentTag(Integer xsXh, Integer bqId) {
        this.xsXh = xsXh;
        this.bqId = bqId;
    }

    public Integer getXsXh() {
        return xsXh;
    }

    public void setXsXh(Integer xsXh) {
        this.xsXh = xsXh;
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