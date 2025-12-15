package com.university.volunteer.controller;

import com.university.volunteer.common.Result;
import com.university.volunteer.dto.LoginRequest;
import com.university.volunteer.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    /**
     * 用户登录接口
     * 接收前端发送的登录请求，调用Service层进行验证
     *
     * @param loginRequest 登录请求实体（包含用户名、密码、角色）
     * @return 统一响应结果
     */
    @PostMapping("/login")
    public Result<?> login(@RequestBody LoginRequest loginRequest) {
        return authService.login(loginRequest);
    }
}
