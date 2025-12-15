package com.university.volunteer.entity;

/**
 * 标签实体类
 * 对应数据库表: t_bqzd
 */
public class Tag {
    // 标签ID
    private Integer bqId;
    // 标签名称
    private String bqMc;
    // 标签类型：1-兴趣/活动类别, 2-技能
    private Integer bqLx;
    // 父标签ID(用于层级分类)
    private Integer fId;
    // 状态：1-启用, 0-禁用
    private Integer zt;
    // 热度值(被引用次数)
    private Integer rd;
    // 备注说明
    private String bz;

    public Integer getBqId() {
        return bqId;
    }

    public void setBqId(Integer bqId) {
        this.bqId = bqId;
    }

    public String getBqMc() {
        return bqMc;
    }

    public void setBqMc(String bqMc) {
        this.bqMc = bqMc;
    }

    public Integer getBqLx() {
        return bqLx;
    }

    public void setBqLx(Integer bqLx) {
        this.bqLx = bqLx;
    }

    public Integer getfId() {
        return fId;
    }

    public void setfId(Integer fId) {
        this.fId = fId;
    }

    public Integer getZt() {
        return zt;
    }

    public void setZt(Integer zt) {
        this.zt = zt;
    }

    public Integer getRd() {
        return rd;
    }

    public void setRd(Integer rd) {
        this.rd = rd;
    }

    public String getBz() {
        return bz;
    }

    public void setBz(String bz) {
        this.bz = bz;
    }
}