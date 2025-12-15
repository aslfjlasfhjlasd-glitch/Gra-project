package com.university.volunteer.service;

import com.university.volunteer.common.Result;
import com.university.volunteer.dto.AccountCreateDTO;
import com.university.volunteer.dto.AccountUpdateDTO;
import com.university.volunteer.entity.Student;
import com.university.volunteer.entity.StudentTag;
import com.university.volunteer.entity.Tag;
import com.university.volunteer.mapper.StudentMapper;
import com.university.volunteer.mapper.StudentTagMapper;
import com.university.volunteer.mapper.TagMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class StudentService {

    @Autowired
    private StudentMapper studentMapper;
    
    @Autowired
    private StudentTagMapper studentTagMapper;
    
    @Autowired
    private TagMapper tagMapper;

    /**
     * 根据学号获取学生完整信息
     * @param studentId 学号
     * @return 学生信息
     */
    public Result<Student> getStudentProfile(Integer studentId) {
        try {
            Student student = studentMapper.findStudentById(studentId);
            if (student == null) {
                return Result.error("学生信息不存在");
            }
            // 不返回密码信息
            student.setXsMm(null);
            return Result.success(student);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取学生信息失败: " + e.getMessage());
        }
    }

    /**
     * 更新学生个人信息（学生权限）
     * 仅允许更新：政治面貌、联系电话、兴趣标签、技能标签、个人简介
     * @param student 学生信息
     * @return 更新结果
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> updateStudentProfile(Student student) {
        try {
            // 验证必填字段
            if (student.getXsXh() == null) {
                return Result.error("学号不能为空");
            }

            // 验证联系电话格式（如果提供）
            if (student.getXsDh() != null && !student.getXsDh().isEmpty()) {
                if (!student.getXsDh().matches("^1[3-9]\\d{9}$")) {
                    return Result.error("联系电话格式不正确");
                }
            }

            // 验证政治面貌（如果提供）
            if (student.getZzmm() != null && !student.getZzmm().isEmpty()) {
                String[] validPoliticalStatus = {"群众", "共青团员", "中共党员", "中共预备党员", "民主党派", "无党派人士"};
                boolean isValid = false;
                for (String status : validPoliticalStatus) {
                    if (status.equals(student.getZzmm())) {
                        isValid = true;
                        break;
                    }
                }
                if (!isValid) {
                    return Result.error("政治面貌选项不正确");
                }
            }

            // 处理标签更新（新增逻辑）
            if (student.getTagIds() != null && !student.getTagIds().isEmpty()) {
                // 1. 删除学生的所有旧标签关联
                studentTagMapper.deleteByStudentId(student.getXsXh());
                
                // 2. 批量插入新的标签关联
                List<StudentTag> studentTags = new ArrayList<>();
                for (Integer tagId : student.getTagIds()) {
                    StudentTag st = new StudentTag();
                    st.setXsXh(student.getXsXh());
                    st.setBqId(tagId);
                    studentTags.add(st);
                }
                if (!studentTags.isEmpty()) {
                    studentTagMapper.insertBatch(studentTags);
                }
                
                // 3. 更新冗余字段（用于兼容和快速查询）
                List<Tag> tags = tagMapper.findByIds(student.getTagIds());
                if (tags != null && !tags.isEmpty()) {
                    // 分离兴趣标签和技能标签
                    String xqBq = tags.stream()
                            .filter(tag -> tag.getBqLx() == 1)
                            .map(Tag::getBqMc)
                            .collect(Collectors.joining(","));
                    String jnBq = tags.stream()
                            .filter(tag -> tag.getBqLx() == 2)
                            .map(Tag::getBqMc)
                            .collect(Collectors.joining(","));
                    student.setXqBq(xqBq.isEmpty() ? null : xqBq);
                    student.setJnBq(jnBq.isEmpty() ? null : jnBq);
                }
            }

            // 更新学生基本信息
            int rows = studentMapper.updateStudentProfile(student);
            if (rows > 0) {
                return Result.success("个人信息更新成功");
            } else {
                return Result.error("更新失败，学生不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("更新个人信息失败: " + e.getMessage());
        }
    }

    /**
     * 更新学生完整信息（管理员权限）
     * @param student 学生信息
     * @return 更新结果
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> updateStudentFullInfo(Student student) {
        try {
            if (student.getXsXh() == null) {
                return Result.error("学号不能为空");
            }

            // 处理标签更新（与updateStudentProfile相同的逻辑）
            if (student.getTagIds() != null && !student.getTagIds().isEmpty()) {
                studentTagMapper.deleteByStudentId(student.getXsXh());
                
                List<StudentTag> studentTags = new ArrayList<>();
                for (Integer tagId : student.getTagIds()) {
                    StudentTag st = new StudentTag();
                    st.setXsXh(student.getXsXh());
                    st.setBqId(tagId);
                    studentTags.add(st);
                }
                if (!studentTags.isEmpty()) {
                    studentTagMapper.insertBatch(studentTags);
                }
                
                List<Tag> tags = tagMapper.findByIds(student.getTagIds());
                if (tags != null && !tags.isEmpty()) {
                    String xqBq = tags.stream()
                            .filter(tag -> tag.getBqLx() == 1)
                            .map(Tag::getBqMc)
                            .collect(Collectors.joining(","));
                    String jnBq = tags.stream()
                            .filter(tag -> tag.getBqLx() == 2)
                            .map(Tag::getBqMc)
                            .collect(Collectors.joining(","));
                    student.setXqBq(xqBq.isEmpty() ? null : xqBq);
                    student.setJnBq(jnBq.isEmpty() ? null : jnBq);
                }
            }

            int rows = studentMapper.updateStudentFullInfo(student);
            if (rows > 0) {
                return Result.success("学生信息更新成功");
            } else {
                return Result.error("更新失败，学生不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("更新学生信息失败: " + e.getMessage());
        }
    }

    /**
     * 验证密码格式
     * 要求：8-15位，必须包含大写字母和小写字母
     * @param password 密码
     * @return 验证结果消息，null表示验证通过
     */
    private String validatePasswordFormat(String password) {
        if (password == null || password.trim().isEmpty()) {
            return "密码不能为空";
        }
        
        // 检查长度
        if (password.length() < 8 || password.length() > 15) {
            return "密码长度必须为8-15位";
        }
        
        // 检查是否包含大写字母
        boolean hasUpperCase = false;
        boolean hasLowerCase = false;
        
        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) {
                hasUpperCase = true;
            }
            if (Character.isLowerCase(c)) {
                hasLowerCase = true;
            }
            if (hasUpperCase && hasLowerCase) {
                break;
            }
        }
        
        if (!hasUpperCase) {
            return "密码必须包含至少一个大写字母";
        }
        
        if (!hasLowerCase) {
            return "密码必须包含至少一个小写字母";
        }
        
        return null; // 验证通过
    }

    /**
     * 修改学生密码
     * @param studentId 学号
     * @param oldPassword 原密码
     * @param newPassword 新密码
     * @return 修改结果
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> updatePassword(Integer studentId, String oldPassword, String newPassword) {
        try {
            // 验证新密码格式
            String validationError = validatePasswordFormat(newPassword);
            if (validationError != null) {
                return Result.error(validationError);
            }
            
            // 查询学生信息验证旧密码
            Student student = studentMapper.findStudentById(studentId);
            if (student == null) {
                return Result.error("学生信息不存在");
            }
            
            // 验证旧密码
            if (!oldPassword.equals(student.getXsMm())) {
                return Result.error("原密码错误");
            }
            
            // 更新密码
            int rows = studentMapper.updatePassword(studentId, newPassword);
            if (rows > 0) {
                return Result.success("密码修改成功");
            } else {
                return Result.error("密码修改失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("密码修改失败: " + e.getMessage());
        }
    }

    /**
     * 更新学生标签（用于首次登录设置）
     * @param studentId 学号
     * @param tagIds 标签ID列表
     * @return 更新结果
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> updateStudentTags(Integer studentId, List<Integer> tagIds) {
        try {
            if (studentId == null) {
                return Result.error("学号不能为空");
            }
            
            // 验证学生是否存在
            Student student = studentMapper.findStudentById(studentId);
            if (student == null) {
                return Result.error("学生信息不存在");
            }
            
            // 1. 删除学生的所有旧标签关联
            studentTagMapper.deleteByStudentId(studentId);
            
            // 2. 如果有新标签，批量插入
            if (tagIds != null && !tagIds.isEmpty()) {
                List<StudentTag> studentTags = new ArrayList<>();
                for (Integer tagId : tagIds) {
                    StudentTag st = new StudentTag();
                    st.setXsXh(studentId);
                    st.setBqId(tagId);
                    studentTags.add(st);
                }
                studentTagMapper.insertBatch(studentTags);
                
                // 3. 更新冗余字段（用于兼容和快速查询）
                List<Tag> tags = tagMapper.findByIds(tagIds);
                if (tags != null && !tags.isEmpty()) {
                    // 分离兴趣标签和技能标签
                    String xqBq = tags.stream()
                            .filter(tag -> tag.getBqLx() == 1)
                            .map(Tag::getBqMc)
                            .collect(Collectors.joining(","));
                    String jnBq = tags.stream()
                            .filter(tag -> tag.getBqLx() == 2)
                            .map(Tag::getBqMc)
                            .collect(Collectors.joining(","));
                    
                    // 更新学生表中的标签字段
                    Student updateStudent = new Student();
                    updateStudent.setXsXh(studentId);
                    updateStudent.setXqBq(xqBq.isEmpty() ? null : xqBq);
                    updateStudent.setJnBq(jnBq.isEmpty() ? null : jnBq);
                    studentMapper.updateStudentProfile(updateStudent);
                }
            }
            
            return Result.success("标签更新成功");
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("标签更新失败: " + e.getMessage());
        }
    }

    // ========== 管理员账号管理功能 ==========

    /**
     * 分页查询学生列表（管理员用）
     */
    public Result<Map<String, Object>> getStudentsByPage(String keyword, int page, int size) {
        try {
            // 使用 PageHelper 进行分页
            List<Student> students = studentMapper.findStudentsByPage(keyword);
            
            // 手动分页处理
            int total = students.size();
            int start = (page - 1) * size;
            int end = Math.min(start + size, total);
            
            List<Student> pageData = students.subList(start, end);
            
            // 清除密码信息
            for (Student student : pageData) {
                student.setXsMm(null);
            }
            
            Map<String, Object> result = new HashMap<>();
            result.put("list", pageData);
            result.put("total", total);
            result.put("page", page);
            result.put("size", size);
            
            return Result.success(result);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("查询学生列表失败: " + e.getMessage());
        }
    }

    /**
     * 创建学生账号（管理员用）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> createStudent(AccountCreateDTO dto) {
        try {
            // 1. 验证必填字段
            if (dto.getCode() == null || dto.getCode().trim().isEmpty()) {
                return Result.error("学号不能为空");
            }
            if (dto.getUsername() == null || dto.getUsername().trim().isEmpty()) {
                return Result.error("姓名不能为空");
            }
            if (dto.getAcademy() == null || dto.getAcademy().trim().isEmpty()) {
                return Result.error("学院不能为空");
            }
            
            // 2. 验证学号格式（必须为数字）
            Integer studentId;
            try {
                studentId = Integer.parseInt(dto.getCode());
            } catch (NumberFormatException e) {
                return Result.error("学号必须为数字");
            }
            
            // 3. 检查学号是否已存在（查重）
            Integer count = studentMapper.existsByStudentId(studentId);
            if (count != null && count > 0) {
                return Result.error("学号已存在");
            }
            
            // 4. 设置默认密码（如果未提供）
            String password = dto.getPassword();
            if (password == null || password.trim().isEmpty()) {
                password = "123456"; // 默认密码
            }
            
            // 5. 创建学生对象
            Student student = new Student();
            student.setXsXh(studentId);
            student.setXsXm(dto.getUsername());
            student.setXsMm(password); // 密码以明文存储（与登录逻辑一致）
            student.setSsXy(dto.getAcademy());
            student.setXsDh(dto.getPhone());
            
            // 设置新增的字段
            student.setXsXb(dto.getGender());
            student.setZzmm(dto.getPoliticalStatus());
            student.setBjMc(dto.getClassName());
            
            // 6. 插入数据库
            int rows = studentMapper.insertStudent(student);
            if (rows > 0) {
                return Result.success("学生账号创建成功，初始密码：" + password);
            } else {
                return Result.error("创建失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("创建学生账号失败: " + e.getMessage());
        }
    }

    /**
     * 更新学生账号（管理员用）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> updateStudentAccount(AccountUpdateDTO dto) {
        try {
            if (dto.getId() == null) {
                return Result.error("学号不能为空");
            }
            
            Student student = new Student();
            student.setXsXh(dto.getId());
            student.setXsXm(dto.getUsername());
            student.setSsXy(dto.getAcademy());
            student.setXsDh(dto.getPhone());
            
            // 设置新增的字段
            student.setXsXb(dto.getGender());
            student.setZzmm(dto.getPoliticalStatus());
            student.setBjMc(dto.getClassName());
            
            // 如果提供了密码，则更新密码
            if (dto.getPassword() != null && !dto.getPassword().trim().isEmpty()) {
                student.setXsMm(dto.getPassword());
            }
            
            int rows = studentMapper.updateStudentFullInfo(student);
            if (rows > 0) {
                return Result.success("学生信息更新成功");
            } else {
                return Result.error("更新失败，学生不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("更新学生信息失败: " + e.getMessage());
        }
    }

    /**
     * 重置学生密码（管理员用）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> resetStudentPassword(Integer studentId) {
        try {
            if (studentId == null) {
                return Result.error("学号不能为空");
            }
            
            // 检查学生是否存在
            Student student = studentMapper.findStudentById(studentId);
            if (student == null) {
                return Result.error("学生不存在");
            }
            
            // 重置为默认密码
            String defaultPassword = "123456";
            int rows = studentMapper.updatePassword(studentId, defaultPassword);
            if (rows > 0) {
                return Result.success("密码已重置为：" + defaultPassword);
            } else {
                return Result.error("密码重置失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("重置密码失败: " + e.getMessage());
        }
    }

    /**
     * 删除学生账号（管理员用）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> deleteStudent(Integer studentId) {
        try {
            if (studentId == null) {
                return Result.error("学号不能为空");
            }
            
            // 先删除学生的标签关联
            studentTagMapper.deleteByStudentId(studentId);
            
            // 再删除学生记录
            int rows = studentMapper.deleteStudent(studentId);
            if (rows > 0) {
                return Result.success("学生账号删除成功");
            } else {
                return Result.error("删除失败，学生不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("删除学生账号失败: " + e.getMessage());
        }
    }
}