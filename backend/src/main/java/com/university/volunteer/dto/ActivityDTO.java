package com.university.volunteer.dto;

import java.util.Date;
import java.util.List;

/**
 * 志愿活动数据传输对象
 * 用于活动信息的输入和输出
 */
public class ActivityDTO {
    // 活动编号
    private Integer hdBh;
    // 活动名称
    private String hdMc;
    // 报名时间 (范围字符串)
    private String bmSj;
    // 活动时间
    private String hdSj;
    
    // 报名开始时间
    private Date bmKssj;
    // 报名结束时间
    private Date bmJssj;
    // 活动开始时间
    private Date hdKssj;
    // 活动结束时间
    private Date hdJssj;

    // 活动内容
    private String hdNr;
    // 活动地点
    private String hdDd;
    // 招募人数
    private Integer zmRs;
    // 已报名人数
    private Integer ybmRs;
    // 活动需求
    private String hdXq;
    // 活动保障
    private String hdBz;
    // 发起单位
    private String hdFqDw;
    // 活动状态
    private String hdZt;
    // 发布状态
    private String fbZt;
    // 专业限制
    private String zyXz;
    
    // 活动标签（字符串，兼容旧版）
    private String hdBq;
    // 技能要求（字符串，兼容旧版）
    private String jnYq;
    
    // 标签ID列表（新版，用于提交）
    private List<Integer> tagIds;
    // 标签详情列表（新版，用于展示）
    private List<TagDTO> tags;

    public Integer getHdBh() {
        return hdBh;
    }

    public void setHdBh(Integer hdBh) {
        this.hdBh = hdBh;
    }

    public String getHdMc() {
        return hdMc;
    }

    public void setHdMc(String hdMc) {
        this.hdMc = hdMc;
    }

    public String getBmSj() {
        return bmSj;
    }

    public void setBmSj(String bmSj) {
        this.bmSj = bmSj;
    }

    public String getHdSj() {
        return hdSj;
    }

    public void setHdSj(String hdSj) {
        this.hdSj = hdSj;
    }

    public Date getBmKssj() {
        return bmKssj;
    }

    public void setBmKssj(Date bmKssj) {
        this.bmKssj = bmKssj;
    }

    public Date getBmJssj() {
        return bmJssj;
    }

    public void setBmJssj(Date bmJssj) {
        this.bmJssj = bmJssj;
    }

    public Date getHdKssj() {
        return hdKssj;
    }

    public void setHdKssj(Date hdKssj) {
        this.hdKssj = hdKssj;
    }

    public Date getHdJssj() {
        return hdJssj;
    }

    public void setHdJssj(Date hdJssj) {
        this.hdJssj = hdJssj;
    }

    public String getHdNr() {
        return hdNr;
    }

    public void setHdNr(String hdNr) {
        this.hdNr = hdNr;
    }

    public String getHdDd() {
        return hdDd;
    }

    public void setHdDd(String hdDd) {
        this.hdDd = hdDd;
    }

    public Integer getZmRs() {
        return zmRs;
    }

    public void setZmRs(Integer zmRs) {
        this.zmRs = zmRs;
    }

    public Integer getYbmRs() {
        return ybmRs;
    }

    public void setYbmRs(Integer ybmRs) {
        this.ybmRs = ybmRs;
    }

    public String getHdXq() {
        return hdXq;
    }

    public void setHdXq(String hdXq) {
        this.hdXq = hdXq;
    }

    public String getHdBz() {
        return hdBz;
    }

    public void setHdBz(String hdBz) {
        this.hdBz = hdBz;
    }

    public String getHdFqDw() {
        return hdFqDw;
    }

    public void setHdFqDw(String hdFqDw) {
        this.hdFqDw = hdFqDw;
    }

    public String getHdZt() {
        return hdZt;
    }

    public void setHdZt(String hdZt) {
        this.hdZt = hdZt;
    }

    public String getFbZt() {
        return fbZt;
    }

    public void setFbZt(String fbZt) {
        this.fbZt = fbZt;
    }

    public String getZyXz() {
        return zyXz;
    }

    public void setZyXz(String zyXz) {
        this.zyXz = zyXz;
    }

    public String getHdBq() {
        return hdBq;
    }

    public void setHdBq(String hdBq) {
        this.hdBq = hdBq;
    }

    public String getJnYq() {
        return jnYq;
    }

    public void setJnYq(String jnYq) {
        this.jnYq = jnYq;
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