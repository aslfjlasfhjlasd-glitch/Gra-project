package com.university.volunteer.dto;

/**
 * 账号创建DTO
 * 用于管理员新增学生或负责人账号
 */
public class AccountCreateDTO {
    private String username;      // 姓名
    private String code;          // 学号/工号
    private String password;      // 初始密码
    private String academy;       // 学院 (for student)
    private String department;    // 部门 (for department_head)
    private String phone;         // 联系电话
    private String accountType;   // "student" or "department_head"
    
    // 学生专属字段
    private String gender;        // 性别 (1-男, 0-女)
    private String politicalStatus; // 政治面貌
    private String className;     // 班级名称

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAcademy() {
        return academy;
    }

    public void setAcademy(String academy) {
        this.academy = academy;
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

    public String getAccountType() {
        return accountType;
    }

    public void setAccountType(String accountType) {
        this.accountType = accountType;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getPoliticalStatus() {
        return politicalStatus;
    }

    public void setPoliticalStatus(String politicalStatus) {
        this.politicalStatus = politicalStatus;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }
}