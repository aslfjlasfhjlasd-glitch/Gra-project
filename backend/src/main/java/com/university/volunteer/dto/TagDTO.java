package com.university.volunteer.dto;

/**
 * 标签数据传输对象
 * 用于前后端交互
 */
public class TagDTO {
    // 标签ID
    private Integer bqId;
    // 标签名称
    private String bqMc;
    // 标签类型 (1-兴趣类别, 2-技能)
    private Integer bqLx;
    // 父标签ID
    private Integer fId;
    // 父标签名称
    private String fMc;
    // 状态 (1-启用, 0-禁用)
    private Integer zt;
    // 热度
    private Integer rd;

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

    public String getfMc() {
        return fMc;
    }

    public void setfMc(String fMc) {
        this.fMc = fMc;
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
}