package com.university.volunteer.dto;

/**
 * 账号更新DTO
 * 用于管理员修改学生或负责人信息
 */
public class AccountUpdateDTO {
    private Integer id;
    private String username;      // 姓名
    private String phone;         // 联系电话
    private String academy;       // 学院 (for student)
    private String department;    // 部门 (for department_head)
    private String password;      // 密码（可选，为空则不修改）
    private String accountType;   // 账号类型：department(校级部门) / academy(学院)
    
    // 学生专属字段
    private String gender;        // 性别 (1-男, 0-女)
    private String politicalStatus; // 政治面貌
    private String className;     // 班级名称

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
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