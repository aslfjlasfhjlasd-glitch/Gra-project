package com.university.volunteer.service;

import com.university.volunteer.common.Result;
import com.university.volunteer.dto.LoginRequest;
import com.university.volunteer.entity.Academy;
import com.university.volunteer.entity.Admin;
import com.university.volunteer.entity.DepartmentHead;
import com.university.volunteer.entity.Student;
import com.university.volunteer.mapper.AcademyMapper;
import com.university.volunteer.mapper.AdminMapper;
import com.university.volunteer.mapper.DepartmentHeadMapper;
import com.university.volunteer.mapper.StudentMapper;
import com.university.volunteer.utils.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    @Autowired
    private StudentMapper studentMapper;

    @Autowired
    private DepartmentHeadMapper departmentHeadMapper;

    @Autowired
    private AcademyMapper academyMapper;

    @Autowired
    private AdminMapper adminMapper;

    /**
     * 统一登录接口
     * 根据传入的角色类型调用相应的登录验证逻辑
     *
     * @param request 登录请求参数（包含用户名、密码、角色）
     * @return 登录结果（包含用户信息或错误提示）
     */
    public Result<?> login(LoginRequest request) {
        String role = request.getRole();
        String username = request.getUsername();
        String password = request.getPassword();

        if (username == null || password == null) {
            return Result.error("用户名和密码不能为空");
        }

        try {
            switch (role) {
                case "student":
                    return loginStudent(username, password);
                case "head":
                    return loginHead(username, password);
                case "admin":
                    return loginAdmin(username, password);
                default:
                    return Result.error("无效的角色类型");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("数据库错误: " + e.getMessage());
        }
    }

    /**
     * 学生登录验证逻辑
     *
     * @param username 学号
     * @param password 密码
     * @return 验证结果
     */
    private Result<?> loginStudent(String username, String password) {
        Integer studentId;
        try {
            // 学号必须为数字
            studentId = Integer.parseInt(username);
        } catch (NumberFormatException e) {
            return Result.error("学号必须为数字");
        }

        // 查询学生信息
        Student student = studentMapper.findByUsername(username);
        if (student == null) {
            return Result.error("账号不存在");
        }

        // 验证密码：将输入的密码加密后，再与数据库对比
        if (!MD5Util.encrypt(password).equals(student.getXsMm())) {
            return Result.error("密码错误");
        }

        return Result.success(student);
    }

    /**
     * 学院/部门负责人登录验证逻辑
     * 采用OR逻辑：既查部门负责人表，也查学院表
     *
     * @param username 账号
     * @param password 密码
     * @return 验证结果
     */
    private Result<?> loginHead(String username, String password) {
        // 先加密输入的密码
        String encryptedPassword = MD5Util.encrypt(password);
        
        // 1. 检查部门负责人表
        DepartmentHead deptHead = departmentHeadMapper.findByUsername(username);
        if (deptHead != null) {
            if (encryptedPassword.equals(deptHead.getXjbmfzrMm())) {
                return Result.success(deptHead);
            }
        }

        // 2. 检查学院表
        Academy academy = academyMapper.findByUsername(username);
        if (academy != null) {
            if (encryptedPassword.equals(academy.getXyMm())) {
                return Result.success(academy);
            }
        }
        
        // 两个表中都未找到账号
        if (deptHead == null && academy == null) {
             return Result.error("账号不存在");
        }

        // 账号存在但密码错误
        return Result.error("密码错误");
    }

    /**
     * 管理员登录验证逻辑
     *
     * @param username 管理员账号
     * @param password 密码
     * @return 验证结果
     */
    private Result<?> loginAdmin(String username, String password) {
        // 查询管理员信息
        Admin admin = adminMapper.findByUsername(username);
        if (admin == null) {
            return Result.error("账号不存在");
        }

        // 验证密码：将输入的密码加密后，再与数据库对比
        if (!MD5Util.encrypt(password).equals(admin.getGlyMm())) {
            return Result.error("密码错误");
        }

        return Result.success(admin);
    }
}
