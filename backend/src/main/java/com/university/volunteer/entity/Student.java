package com.university.volunteer.entity;

import java.util.List;

/**
 * 学生实体类
 * 对应数据库表: t_xs
 */
public class Student {
    // 学号 (主键)
    private Integer xsXh;
    // 姓名
    private String xsXm;
    // 密码
    private String xsMm;
    // 联系电话
    private String xsDh;
    // 性别 (1-男, 0-女)
    private String xsXb;
    // 政治面貌
    private String zzmm;
    // 所属学院
    private String ssXy;
    // 班级编号
    private Integer bjBh;
    // 班级名称
    private String bjMc;
    // 兴趣标签（字符串，用于兼容和冗余存储）
    private String xqBq;
    // 技能标签（字符串，用于兼容和冗余存储）
    private String jnBq;
    // 个人简介
    private String grjj;
    
    // 新增：标签列表（用于结构化数据）
    private List<Tag> tags;
    // 新增：标签ID列表（用于前后端交互）
    private List<Integer> tagIds;

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

    public String getXsMm() {
        return xsMm;
    }

    public void setXsMm(String xsMm) {
        this.xsMm = xsMm;
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

    public String getGrjj() {
        return grjj;
    }

    public void setGrjj(String grjj) {
        this.grjj = grjj;
    }

    public List<Tag> getTags() {
        return tags;
    }

    public void setTags(List<Tag> tags) {
        this.tags = tags;
    }

    public List<Integer> getTagIds() {
        return tagIds;
    }

    public void setTagIds(List<Integer> tagIds) {
        this.tagIds = tagIds;
    }
}
