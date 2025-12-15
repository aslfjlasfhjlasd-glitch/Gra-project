package com.university.volunteer.dto;

import java.util.List;

/**
 * 学生档案数据传输对象
 * 用于学生信息的输入和输出
 */
public class StudentProfileDTO {
    // 学号
    private Integer xsXh;
    // 姓名
    private String xsXm;
    // 联系电话
    private String xsDh;
    // 性别
    private String xsXb;
    // 政治面貌
    private String zzmm;
    // 所属学院
    private String ssXy;
    // 班级编号
    private Integer bjBh;
    // 班级名称
    private String bjMc;
    // 个人简介
    private String grjj;
    
    // 兴趣标签（字符串，兼容旧版）
    private String xqBq;
    // 技能标签（字符串，兼容旧版）
    private String jnBq;
    
    // 标签ID列表（新版，用于提交）
    private List<Integer> tagIds;
    // 标签详情列表（新版，用于展示）
    private List<TagDTO> tags;

    public Integer getXsXh() {
        return xsXh;
    }

    public void setXsXh(Integer xsXh) {
        this.xsXh = xsXh;
    }

    public String getXsXm() {
        return xsXm;
    }

    public void setXsXm(String xsXm) {
        this.xsXm = xsXm;
    }

    public String getXsDh() {
        return xsDh;
    }

    public void setXsDh(String xsDh) {
        this.xsDh = xsDh;
    }

    public String getXsXb() {
        return xsXb;
    }

    public void setXsXb(String xsXb) {
        this.xsXb = xsXb;
    }

    public String getZzmm() {
        return zzmm;
    }

    public void setZzmm(String zzmm) {
        this.zzmm = zzmm;
    }

    public String getSsXy() {
        return ssXy;
    }

    public void setSsXy(String ssXy) {
        this.ssXy = ssXy;
    }

    public Integer getBjBh() {
        return bjBh;
    }

    public void setBjBh(Integer bjBh) {
        this.bjBh = bjBh;
    }

    public String getBjMc() {
        return bjMc;
    }

    public void setBjMc(String bjMc) {
        this.bjMc = bjMc;
    }

    public String getGrjj() {
        return grjj;
    }

    public void setGrjj(String grjj) {
        this.grjj = grjj;
    }

    public String getXqBq() {
        return xqBq;
    }

    public void setXqBq(String xqBq) {
        this.xqBq = xqBq;
    }

    public String getJnBq() {
        return jnBq;
    }

    public void setJnBq(String jnBq) {
        this.jnBq = jnBq;
    }

    public List<Integer> getTagIds() {
        return tagIds;
    }

    public void setTagIds(List<Integer> tagIds) {
        this.tagIds = tagIds;
    }

    public List<TagDTO> getTags() {
        return tags;
    }

    public void setTags(List<TagDTO> tags) {
        this.tags = tags;
    }
}