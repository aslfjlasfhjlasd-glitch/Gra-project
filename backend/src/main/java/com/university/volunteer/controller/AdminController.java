package com.university.volunteer.controller;

import com.university.volunteer.common.Result;
import com.university.volunteer.dto.AccountCreateDTO;
import com.university.volunteer.dto.AccountUpdateDTO;
import com.university.volunteer.dto.VolunteerAuditDTO;
import com.university.volunteer.entity.Config;
import com.university.volunteer.entity.VolunteerActivity;
import com.university.volunteer.service.AdminService;
import com.university.volunteer.service.ConfigService;
import com.university.volunteer.service.DepartmentHeadService;
import com.university.volunteer.service.MockDataService;
import com.university.volunteer.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private ConfigService configService;

    @Autowired
    private MockDataService mockDataService;

    @Autowired
    private StudentService studentService;

    @Autowired
    private DepartmentHeadService departmentHeadService;

    /**
     * 获取所有活动列表（管理员可以查看所有活动）
     */
    @GetMapping("/activities")
    public Result<List<VolunteerActivity>> getAllActivities() {
        return adminService.getAllActivities();
    }

    /**
     * 发布活动（将"已申报"状态的活动改为"已发布"）
     * @param activityId 活动编号
     */
    @PutMapping("/activity/{activityId}/publish")
    public Result<String> publishActivity(@PathVariable Integer activityId) {
        return adminService.publishActivity(activityId);
    }

    /**
     * 下架活动（将"已发布"状态的活动改为"已下架"）
     * @param activityId 活动编号
     */
    @PutMapping("/activity/{activityId}/unpublish")
    public Result<String> unpublishActivity(@PathVariable Integer activityId) {
        return adminService.unpublishActivity(activityId);
    }

    /**
     * 获取志愿者审核列表
     * @param status 审核状态：未审核/已审核通过/已拒绝，为空则查询所有状态
     */
    @GetMapping("/reviews")
    public Result<List<VolunteerAuditDTO>> getVolunteerReviews(@RequestParam(required = false) String status) {
        return adminService.getVolunteerReviews(status);
    }

    /**
     * 根据ID获取志愿者审核详情
     * @param registrationId 报名ID
     */
    @GetMapping("/reviews/{registrationId}")
    public Result<VolunteerAuditDTO> getVolunteerReviewDetail(@PathVariable Integer registrationId) {
        return adminService.getVolunteerReviewDetail(registrationId);
    }

    /**
     * 审核通过志愿者报名
     * @param registrationId 报名ID
     */
    @PutMapping("/reviews/{registrationId}/approve")
    public Result<String> approveVolunteerRegistration(@PathVariable Integer registrationId) {
        return adminService.approveVolunteerRegistration(registrationId);
    }

    /**
     * 审核拒绝志愿者报名
     * @param registrationId 报名ID
     * @param payload 携带拒绝原因的请求体
     */
    @PutMapping("/reviews/{registrationId}/reject")
    public Result<String> rejectVolunteerRegistration(@PathVariable Integer registrationId,
                                                      @RequestBody(required = false) java.util.Map<String, String> payload) {
        String reason = payload != null ? payload.getOrDefault("reason", null) : null;
        return adminService.rejectVolunteerRegistration(registrationId, reason);
    }

    // ==================== 配置管理接口 ====================

    /**
     * 获取所有配置项列表（用于维护界面）
     * @return 配置列表
     */
    @GetMapping("/config/list")
    public Result<List<Config>> getConfigList() {
        try {
            List<Config> configs = configService.getAllConfigs();
            return Result.success(configs);
        } catch (Exception e) {
            return Result.error("获取配置列表失败: " + e.getMessage());
        }
    }

    /**
     * 获取所有配置项（Map格式，用于大屏展示）
     * @return 配置Map
     */
    @GetMapping("/config/map")
    public Result<Map<String, String>> getConfigMap() {
        try {
            Map<String, String> configMap = configService.getAllConfigsAsMap();
            return Result.success(configMap);
        } catch (Exception e) {
            return Result.error("获取配置失败: " + e.getMessage());
        }
    }

    /**
     * 根据配置键获取配置值
     * @param configKey 配置键
     * @return 配置值
     */
    @GetMapping("/config/{configKey}")
    public Result<String> getConfigValue(@PathVariable String configKey) {
        try {
            String value = configService.getConfigValue(configKey);
            if (value != null) {
                return Result.success(value);
            } else {
                return Result.error("配置项不存在");
            }
        } catch (Exception e) {
            return Result.error("获取配置失败: " + e.getMessage());
        }
    }

    /**
     * 更新单个配置
     * @param configKey 配置键
     * @param payload 包含配置值的请求体
     * @return 更新结果
     */
    @PutMapping("/config/{configKey}")
    public Result<String> updateConfig(@PathVariable String configKey,
                                       @RequestBody Map<String, String> payload) {
        try {
            String configValue = payload.get("configValue");
            if (configValue == null) {
                return Result.error("配置值不能为空");
            }
            
            boolean success = configService.updateConfig(configKey, configValue);
            if (success) {
                return Result.success("配置更新成功");
            } else {
                return Result.error("配置更新失败，配置项可能不存在");
            }
        } catch (Exception e) {
            return Result.error("更新配置失败: " + e.getMessage());
        }
    }

    /**
     * 批量更新配置
     * @param configMap 配置Map (key -> value)
     * @return 更新结果
     */
    @PostMapping("/config/batch-update")
    public Result<String> batchUpdateConfigs(@RequestBody Map<String, String> configMap) {
        try {
            if (configMap == null || configMap.isEmpty()) {
                return Result.error("配置数据不能为空");
            }
            
            int count = configService.batchUpdateConfigs(configMap);
            return Result.success("成功更新 " + count + " 个配置项");
        } catch (Exception e) {
            return Result.error("批量更新配置失败: " + e.getMessage());
        }
    }

    /**
     * 添加新配置
     * @param config 配置对象
     * @return 添加结果
     */
    @PostMapping("/config")
    public Result<String> addConfig(@RequestBody Config config) {
        try {
            if (config.getConfigKey() == null || config.getConfigKey().isEmpty()) {
                return Result.error("配置键不能为空");
            }
            
            boolean success = configService.insertConfig(config);
            if (success) {
                return Result.success("配置添加成功");
            } else {
                return Result.error("配置添加失败");
            }
        } catch (Exception e) {
            return Result.error("添加配置失败: " + e.getMessage());
        }
    }

    // ==================== 模拟数据生成接口 ====================

    /**
     * 生成模拟数据（用于演示和测试）
     * @param payload 包含生成数量的请求体
     * @return 生成结果
     */
    @PostMapping("/mock-data/generate")
    public Result<String> generateMockData(@RequestBody(required = false) Map<String, Integer> payload) {
        try {
            int count = 50; // 默认生成50条
            if (payload != null && payload.containsKey("count")) {
                count = payload.get("count");
                if (count < 1 || count > 200) {
                    return Result.error("生成数量必须在1-200之间");
                }
            }
            
            String result = mockDataService.generateMockData(count);
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("生成模拟数据失败: " + e.getMessage());
        }
    }

    /**
     * 清空模拟数据（可选功能）
     * @return 清空结果
     */
    @DeleteMapping("/mock-data/clear")
    public Result<String> clearMockData() {
        try {
            String result = mockDataService.clearMockData();
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("清空数据失败: " + e.getMessage());
        }
    }

    // ==================== 账号管理接口 ====================

    /**
     * 获取学生账号列表（分页）
     * @param keyword 搜索关键词（姓名或学号）
     * @param page 页码
     * @param size 每页大小
     * @return 学生列表
     */
    @GetMapping("/accounts/student/list")
    public Result<Map<String, Object>> getStudentList(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        return studentService.getStudentsByPage(keyword, page, size);
    }

    /**
     * 新增学生账号
     * @param dto 学生账号信息
     * @return 创建结果
     */
    @PostMapping("/accounts/student/add")
    public Result<String> addStudent(@RequestBody AccountCreateDTO dto) {
        dto.setAccountType("student");
        return studentService.createStudent(dto);
    }

    /**
     * 更新学生账号信息
     * @param dto 学生账号信息
     * @return 更新结果
     */
    @PutMapping("/accounts/student/update")
    public Result<String> updateStudent(@RequestBody AccountUpdateDTO dto) {
        return studentService.updateStudentAccount(dto);
    }

    /**
     * 重置学生密码
     * @param id 学号
     * @return 重置结果
     */
    @PostMapping("/accounts/student/reset-pwd")
    public Result<String> resetStudentPassword(@RequestBody Map<String, Integer> payload) {
        Integer id = payload.get("id");
        if (id == null) {
            return Result.error("学号不能为空");
        }
        return studentService.resetStudentPassword(id);
    }

    /**
     * 删除学生账号
     * @param id 学号
     * @return 删除结果
     */
    @DeleteMapping("/accounts/student/{id}")
    public Result<String> deleteStudent(@PathVariable Integer id) {
        return studentService.deleteStudent(id);
    }

    /**
     * 获取负责人账号列表（分页）
     * @param keyword 搜索关键词（姓名或工号）
     * @param page 页码
     * @param size 每页大小
     * @return 负责人列表
     */
    @GetMapping("/accounts/head/list")
    public Result<Map<String, Object>> getDepartmentHeadList(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        return departmentHeadService.getDepartmentHeadsByPage(keyword, page, size);
    }

    /**
     * 新增负责人账号
     * @param dto 负责人账号信息
     * @return 创建结果
     */
    @PostMapping("/accounts/head/add")
    public Result<String> addDepartmentHead(@RequestBody AccountCreateDTO dto) {
        dto.setAccountType("department_head");
        return departmentHeadService.createDepartmentHead(dto);
    }

    /**
     * 更新负责人账号信息
     * @param dto 负责人账号信息
     * @return 更新结果
     */
    @PutMapping("/accounts/head/update")
    public Result<String> updateDepartmentHead(@RequestBody AccountUpdateDTO dto) {
        return departmentHeadService.updateDepartmentHeadAccount(dto);
    }

    /**
     * 重置负责人密码
     * @param payload 包含账号和类型的请求体
     * @return 重置结果
     */
    @PostMapping("/accounts/head/reset-pwd")
    public Result<String> resetDepartmentHeadPassword(@RequestBody Map<String, String> payload) {
        String username = payload.get("username");
        String accountType = payload.get("accountType");
        if (username == null || username.trim().isEmpty()) {
            return Result.error("账号不能为空");
        }
        return departmentHeadService.resetDepartmentHeadPassword(username, accountType);
    }

    /**
     * 删除负责人账号
     * @param username 账号
     * @param accountType 账号类型
     * @return 删除结果
     */
    @DeleteMapping("/accounts/head/{username}")
    public Result<String> deleteDepartmentHead(@PathVariable String username, @RequestParam(required = false) String accountType) {
        return departmentHeadService.deleteDepartmentHead(username, accountType);
    }
    
    /**
     * 修改管理员密码
     * @param payload 包含账号、旧密码、新密码的请求体
     * @return 修改结果
     */
    @PostMapping("/change-password")
    public Result<String> changeAdminPassword(@RequestBody Map<String, String> payload) {
        String username = payload.get("username");
        String oldPassword = payload.get("oldPassword");
        String newPassword = payload.get("newPassword");
        
        if (username == null || username.trim().isEmpty()) {
            return Result.error("管理员账号不能为空");
        }
        if (oldPassword == null || oldPassword.trim().isEmpty()) {
            return Result.error("旧密码不能为空");
        }
        if (newPassword == null || newPassword.trim().isEmpty()) {
            return Result.error("新密码不能为空");
        }
        
        return adminService.changeAdminPassword(username, oldPassword, newPassword);
    }
}