package com.university.volunteer.dto;

/**
 * 负责人账号统一DTO
 * 用于同时表示校级部门负责人和学院负责人
 */
public class HeadAccountDTO {
    private String username;      // 账号（工号/学院账号）
    private String name;          // 姓名
    private String department;    // 部门/学院名称
    private String phone;         // 联系电话
    private String type;          // 类型：department（校级部门）或 academy（学院）
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDepartment() {
        return department;
    }
    
    public void setDepartment(String department) {
        this.department = department;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
}