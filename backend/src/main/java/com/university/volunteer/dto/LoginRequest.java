package com.university.volunteer.dto;

/**
 * 登录请求数据传输对象 (DTO)
 * 封装前端发送的登录表单数据
 */
public class LoginRequest {
    // 用户名 (学号/工号/管理员账号)
    private String username;
    // 密码
    private String password;
    // 角色 (student, head, admin)
    private String role;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
