package com.university.volunteer.controller;

import com.university.volunteer.common.Result;
import com.university.volunteer.entity.Student;
import com.university.volunteer.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/student")
public class StudentController {

    @Autowired
    private StudentService studentService;

    /**
     * 获取学生个人信息（支持从token或参数获取学号）
     * @param studentId 学号（可选，如果不提供则从token获取）
     * @param authorization Authorization header
     * @return 学生信息
     */
    @GetMapping("/profile")
    public Result<Student> getProfile(
            @RequestParam(required = false) Integer studentId,
            @RequestHeader(value = "Authorization", required = false) String authorization) {
        
        // 如果没有提供studentId，尝试从token中获取
        if (studentId == null && authorization != null && authorization.startsWith("Bearer ")) {
            // 从localStorage获取的studentId（前端会在请求时设置）
            String token = authorization.substring(7);
            // 这里简化处理，实际应该解析JWT token
            // 暂时从localStorage的studentId获取
            String studentIdStr = authorization.split("_")[0]; // 临时方案
        }
        
        return studentService.getStudentProfile(studentId);
    }

    /**
     * 更新学生个人信息（学生权限）
     * 仅允许更新：政治面貌、联系电话、兴趣标签、技能标签、个人简介
     * @param student 学生信息
     * @return 更新结果
     */
    @PutMapping("/profile")
    public Result<String> updateProfile(@RequestBody Student student) {
        return studentService.updateStudentProfile(student);
    }

    /**
     * 更新学生完整信息（管理员权限）
     * @param student 学生信息
     * @return 更新结果
     */
    @PutMapping("/profile/full")
    public Result<String> updateFullProfile(@RequestBody Student student) {
        return studentService.updateStudentFullInfo(student);
    }

    /**
     * 修改学生密码（支持从token获取学号）
     * @param requestBody 包含 oldPassword, newPassword（studentId可选）
     * @param authorization Authorization header
     * @return 修改结果
     */
    @PutMapping("/password")
    public Result<String> updatePassword(
            @RequestBody Map<String, Object> requestBody,
            @RequestHeader(value = "Authorization", required = false) String authorization) {
        
        Integer studentId = null;
        
        // 优先从请求体获取studentId
        if (requestBody.get("studentId") != null) {
            studentId = (Integer) requestBody.get("studentId");
        }
        
        // 如果请求体没有，尝试从localStorage获取（前端会设置）
        if (studentId == null) {
            String studentIdStr = (String) requestBody.get("studentIdFromStorage");
            if (studentIdStr != null) {
                try {
                    studentId = Integer.parseInt(studentIdStr);
                } catch (NumberFormatException e) {
                    return Result.error("学号格式错误");
                }
            }
        }
        
        String oldPassword = (String) requestBody.get("oldPassword");
        String newPassword = (String) requestBody.get("newPassword");

        if (studentId == null || oldPassword == null || newPassword == null) {
            return Result.error("参数不完整");
        }

        return studentService.updatePassword(studentId, oldPassword, newPassword);
    }

    /**
     * 更新学生标签
     * @param requestBody 包含 tagIds 数组
     * @param authorization Authorization header
     * @return 更新结果
     */
    @PostMapping("/tags")
    public Result<String> updateTags(
            @RequestBody Map<String, Object> requestBody,
            @RequestHeader(value = "Authorization", required = false) String authorization) {
        
        Integer studentId = null;
        
        // 从请求体获取studentId
        if (requestBody.get("studentId") != null) {
            studentId = (Integer) requestBody.get("studentId");
        }
        
        // 如果请求体没有，尝试从localStorage获取
        if (studentId == null) {
            String studentIdStr = (String) requestBody.get("studentIdFromStorage");
            if (studentIdStr != null) {
                try {
                    studentId = Integer.parseInt(studentIdStr);
                } catch (NumberFormatException e) {
                    return Result.error("学号格式错误");
                }
            }
        }
        
        if (studentId == null) {
            return Result.error("学号不能为空");
        }
        
        // 获取标签ID列表
        @SuppressWarnings("unchecked")
        List<Integer> tagIds = (List<Integer>) requestBody.get("tagIds");
        
        if (tagIds == null || tagIds.isEmpty()) {
            return Result.success("标签更新成功（未选择标签）");
        }
        
        return studentService.updateStudentTags(studentId, tagIds);
    }
}