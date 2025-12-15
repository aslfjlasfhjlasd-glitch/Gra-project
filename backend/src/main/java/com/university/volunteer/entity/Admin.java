package com.university.volunteer.entity;

/**
 * 管理员实体类
 * 对应数据库表: t_gly
 */
public class Admin {
    // 账号 (主键)
    private String glyZh;
    // 密码
    private String glyMm;
    // 管理员名称
    private String glyMc;

    public String getGlyZh() {
        return glyZh;
    }

    public void setGlyZh(String glyZh) {
        this.glyZh = glyZh;
    }

    public String getGlyMm() {
        return glyMm;
    }

    public void setGlyMm(String glyMm) {
        this.glyMm = glyMm;
    }

    public String getGlyMc() {
        return glyMc;
    }

    public void setGlyMc(String glyMc) {
        this.glyMc = glyMc;
    }
}
