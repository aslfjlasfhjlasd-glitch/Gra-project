package com.university.volunteer.entity;

/**
 * 部门负责人实体类
 * 对应数据库表: t_xjbmfzr
 */
public class DepartmentHead {
    // 部门名称
    private String xjbmMc;
    // 账号 (主键)
    private String xjbmfzrZh;
    // 密码
    private String xjbmfzrMm;
    // 姓名
    private String xjbmfzrXm;
    // 电话
    private String xjbmfzrDh;

    public String getXjbmMc() {
        return xjbmMc;
    }

    public void setXjbmMc(String xjbmMc) {
        this.xjbmMc = xjbmMc;
    }

    public String getXjbmfzrZh() {
        return xjbmfzrZh;
    }

    public void setXjbmfzrZh(String xjbmfzrZh) {
        this.xjbmfzrZh = xjbmfzrZh;
    }

    public String getXjbmfzrMm() {
        return xjbmfzrMm;
    }

    public void setXjbmfzrMm(String xjbmfzrMm) {
        this.xjbmfzrMm = xjbmfzrMm;
    }

    public String getXjbmfzrXm() {
        return xjbmfzrXm;
    }

    public void setXjbmfzrXm(String xjbmfzrXm) {
        this.xjbmfzrXm = xjbmfzrXm;
    }

    public String getXjbmfzrDh() {
        return xjbmfzrDh;
    }

    public void setXjbmfzrDh(String xjbmfzrDh) {
        this.xjbmfzrDh = xjbmfzrDh;
    }
}
