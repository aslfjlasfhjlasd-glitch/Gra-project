package com.university.volunteer.service;

import com.university.volunteer.common.Result;
import com.university.volunteer.dto.ActivityPerformanceDTO;
import com.university.volunteer.dto.ActivityRecommendDTO;
import com.university.volunteer.entity.ActivityRegistration;
import com.university.volunteer.entity.Student;
import com.university.volunteer.entity.Tag;
import com.university.volunteer.entity.VolunteerActivity;
import com.university.volunteer.mapper.ActivityTagMapper;
import com.university.volunteer.mapper.StudentActivityMapper;
import com.university.volunteer.mapper.StudentMapper;
import com.university.volunteer.mapper.StudentTagMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class StudentActivityService {

    @Autowired
    private StudentActivityMapper studentActivityMapper;

    @Autowired
    private StudentMapper studentMapper;
    
    @Autowired
    private StudentTagMapper studentTagMapper;
    
    @Autowired
    private ActivityTagMapper activityTagMapper;

    public Result<List<ActivityRegistration>> getRegistrationStatus(String studentId) {
        List<ActivityRegistration> list = studentActivityMapper.selectRegistrationsByStudentId(studentId);
        return Result.success(list);
    }

    public Result<List<ActivityPerformanceDTO>> getActivityPerformance(String studentId) {
        List<ActivityPerformanceDTO> list = studentActivityMapper.selectPerformanceByStudentId(studentId);
        return Result.success(list);
    }

    public Result<VolunteerActivity> getActivityDetail(Integer activityId) {
        VolunteerActivity activity = studentActivityMapper.findActivityById(activityId);
        if (activity == null) {
            return Result.error("活动不存在");
        }
        // 兜底格式化：将时间字段转为字符串（避免前端解析 null 时报错）
        if (activity.getHdSj() == null && activity.getHdKssj() != null && activity.getHdJssj() != null) {
            activity.setHdSj(activity.getHdKssj() + " - " + activity.getHdJssj());
        }
        return Result.success(activity);
    }

    /**
     * 增加活动浏览次数
     * 使用原子性更新，保证高并发下的数据准确性
     * 
     * @param activityId 活动ID
     * @return 操作结果
     */
    public Result<String> addViewCount(Integer activityId) {
        try {
            // 验证活动是否存在（可选，为了性能可以省略）
            // VolunteerActivity activity = studentActivityMapper.findActivityById(activityId);
            // if (activity == null) {
            //     return Result.error("活动不存在");
            // }
            
            // 直接执行原子性更新
            int rows = studentActivityMapper.incrementViewCount(activityId);
            if (rows > 0) {
                return Result.success("浏览计数成功");
            } else {
                return Result.error("活动不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 浏览计数失败不应该影响用户体验，静默处理
            return Result.error("浏览计数失败");
        }
    }

    /**
     * 学生对活动评分（1-5）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> rateActivity(String studentId, Integer registrationId, Integer rating) {
        if (rating == null || rating < 1 || rating > 5) {
            return Result.error("评分需在1-5之间");
        }
        // 校验归属
        ActivityRegistration reg = studentActivityMapper.findRegistrationById(registrationId);
        if (reg == null || !studentId.equals(reg.getStudentId())) {
            return Result.error("无权评分该活动");
        }
        if (!"已审核通过".equals(reg.getStatus())) {
            return Result.error("仅已审核通过的记录可评分");
        }
        int rows = studentActivityMapper.updateActivityRating(registrationId, studentId, rating);
        return rows > 0 ? Result.success("评分成功") : Result.error("评分失败");
    }

    public Result<List<ActivityRegistration>> getConfirmedLeavePermits(String studentId) {
        return Result.success(studentActivityMapper.selectConfirmedLeaveByStudent(studentId));
    }

    public Result<List<ActivityRegistration>> getConfirmedCertificates(String studentId) {
        return Result.success(studentActivityMapper.selectConfirmedCertificateByStudent(studentId));
    }

    public ResponseEntity<byte[]> downloadLeavePermit(String studentId, Integer registrationId) {
        ActivityRegistration reg = studentActivityMapper.findRegistrationById(registrationId);
        if (reg == null || reg.getLeaveConfirmed() == null || reg.getLeaveConfirmed() != 1) {
            return buildErrorFile("公假单未出具或记录不存在");
        }
        if (!reg.getStudentId().equals(studentId)) {
            return buildErrorFile("无权下载该公假单");
        }
        String content = "公假单\n学生: " + reg.getStudentName()
                + "\n学号: " + reg.getStudentId()
                + "\n活动: " + reg.getActivityName()
                + "\n时间: " + nullSafe(reg.getActivityTime())
                + "\n出具时间: " + nullSafe(reg.getLeaveIssuedAt());
        return buildPdf(content, "leave-permit-" + registrationId + ".pdf");
    }

    public ResponseEntity<byte[]> downloadCertificate(String studentId, Integer registrationId) {
        ActivityRegistration reg = studentActivityMapper.findRegistrationById(registrationId);
        if (reg == null || reg.getCertificateConfirmed() == null || reg.getCertificateConfirmed() != 1) {
            return buildErrorFile("证明未出具或记录不存在");
        }
        if (!reg.getStudentId().equals(studentId)) {
            return buildErrorFile("无权下载该证明");
        }
        String content = "志愿活动证明\n学生: " + reg.getStudentName()
                + "\n学号: " + reg.getStudentId()
                + "\n活动: " + reg.getActivityName()
                + "\n参与时间: " + nullSafe(reg.getActivityTime())
                + "\n服务时长: " + nullSafe(reg.getDuration()) + " 小时"
                + "\n获得学分: " + nullSafe(reg.getCredits())
                + "\n出具时间: " + nullSafe(reg.getCertificateIssuedAt());
        return buildPdf(content, "certificate-" + registrationId + ".pdf");
    }

    /**
     * 活动报名
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> registerActivity(String studentId, Integer activityId) {
        // 1. 验证学生身份
        // 注意：这里 studentId 是 String，但 studentMapper.findStudentById 接受 Integer
        // 假设 studentId 总是数字字符串
        Student student;
        try {
            student = studentMapper.findStudentById(Integer.parseInt(studentId));
        } catch (NumberFormatException e) {
            return Result.error("无效的学生ID");
        }

        if (student == null) {
            return Result.error("学生不存在");
        }

        // 2. 验证活动是否存在
        VolunteerActivity activity = studentActivityMapper.findActivityById(activityId);
        if (activity == null) {
            return Result.error("活动不存在");
        }

        // 3. 检查活动状态（统一口径：报名未开始/活动报名中/活动未开始/活动进行中/活动已结束）
        Date now = new Date();
        String status;
        if (activity.getBmKssj() == null || activity.getBmJssj() == null ||
            activity.getHdKssj() == null || activity.getHdJssj() == null) {
            // 时间字段不完整时不允许报名（避免"时间未配置"导致异常开放）
            return Result.error("活动时间配置不完整，暂不可报名");
        }

        if (now.before(activity.getBmKssj())) {
            status = "报名未开始";
        } else if (!now.after(activity.getBmJssj())) {
            // now >= bmKssj && now <= bmJssj
            status = "活动报名中";
        } else if (now.before(activity.getHdKssj())) {
            // now > bmJssj && now < hdKssj
            status = "活动未开始";
        } else if (!now.after(activity.getHdJssj())) {
            // now >= hdKssj && now <= hdJssj
            status = "活动进行中";
        } else {
            // now > hdJssj
            status = "活动已结束";
        }

        if ("报名未开始".equals(status)) {
            return Result.error("报名尚未开始");
        }
        if ("活动未开始".equals(status)) {
            return Result.error("报名已结束，活动尚未开始，无法报名");
        }
        if ("活动进行中".equals(status)) {
            return Result.error("活动进行中，无法报名");
        }
        if ("活动已结束".equals(status)) {
            return Result.error("活动已结束，无法报名");
        }
        if (!"活动报名中".equals(status)) {
            return Result.error("不在报名时间内");
        }

        // 4. 检查是否重复报名
        int count = studentActivityMapper.countRegistration(studentId, activityId);
        if (count > 0) {
            return Result.error("您已报名该活动");
        }

        // 5. 检查剩余名额
        // 注意：这里检查的是"已审核通过"的人数，而不是所有报名记录
        // 因为未审核的可能会被拒绝，不应该占用名额
        Integer maxCapacity = activity.getZmRs();
        if (maxCapacity == null) {
            maxCapacity = 0;
        }

        // 从缓存字段直接读取已审核通过的人数（由触发器维护）
        int currentApproved = activity.getYbmRs() != null ? activity.getYbmRs() : 0;
        if (maxCapacity > 0 && currentApproved >= maxCapacity) {
            return Result.error("活动名额已满");
        }

        // 6. 构造报名记录
        ActivityRegistration registration = new ActivityRegistration();
        registration.setStudentId(studentId);
        registration.setStudentName(student.getXsXm());
        registration.setAcademyName(student.getSsXy());
        registration.setActivityId(String.valueOf(activityId));
        registration.setActivityName(activity.getHdMc());
        registration.setActivityTime(activity.getHdSj());
        registration.setActivityLocation(activity.getHdDd()); // 同步活动地点
        registration.setStatus("未审核"); // 初始状态
        // registration.setRegisterTime(new Date()); // 数据库没有该字段，暂不设置

        // 7. 插入数据库
        int rows = studentActivityMapper.insertRegistration(registration);
        if (rows <= 0) {
            return Result.error("报名失败");
        }

        // 8. 不需要手动更新 YBM_RS，触发器会自动处理
        // 注意：INSERT 时状态为"未审核"，触发器不会增加人数（符合预期）
        // 只有审核通过后，UPDATE 触发器才会增加人数

        return Result.success("报名成功");
    }

    /**
     * 取消报名
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> cancelRegistration(String studentId, Integer activityId) {
        // 1. 检查报名记录是否存在
        int count = studentActivityMapper.countRegistration(studentId, activityId);
        if (count == 0) {
            return Result.error("未找到报名记录");
        }

        // 2. 验证活动状态（可选：只允许在特定状态下取消）
        VolunteerActivity activity = studentActivityMapper.findActivityById(activityId);
        if (activity == null) {
            return Result.error("活动不存在");
        }

        // 检查活动是否已开始或已结束
        Date now = new Date();
        if (activity.getHdKssj() != null && now.after(activity.getHdKssj())) {
            return Result.error("活动已开始，无法取消报名");
        }

        // 3. 删除报名记录
        int rows = studentActivityMapper.deleteRegistration(studentId, activityId);
        if (rows <= 0) {
            return Result.error("取消报名失败");
        }

        // 4. 不需要手动更新 YBM_RS，DELETE 触发器会自动处理
        // 注意：触发器只在原状态为"已审核通过"时才会减少人数

        return Result.success("取消报名成功");
    }

    /**
     * 智能推荐活动（升级版）
     * 基于学生标签的内容推荐算法 + 热门兜底策略
     * 新增：引入浏览次数作为推荐权重因子
     *
     * 加权公式：Score = (TagMatch × 10) + (SignupCount × 2) + (ViewCount × 0.3)
     * - TagMatch: 标签匹配数（权重最高，保证相关性）
     * - SignupCount: 报名人数（代表硬核热度）
     * - ViewCount: 浏览次数（权重最低，避免标题党霸榜）
     *
     * @param studentId 学生学号
     * @return 推荐活动列表
     */
    public Result<List<ActivityRecommendDTO>> getRecommendedActivities(Integer studentId) {
        try {
            // 1. 获取学生的标签画像
            List<Tag> studentTags = studentTagMapper.findTagsByStudentId(studentId);
            
            // 2. 获取所有招募中的活动（现在包含 LL_CS 字段）
            List<VolunteerActivity> candidateActivities = studentActivityMapper.findRecruitingActivities();
            
            if (candidateActivities == null || candidateActivities.isEmpty()) {
                return Result.success(new ArrayList<>());
            }
            
            // 3. 计算综合匹配分数
            List<ActivityRecommendDTO> recommendList = new ArrayList<>();
            
            if (studentTags != null && !studentTags.isEmpty()) {
                // 学生有标签，进行基于内容的推荐
                Set<String> studentTagNames = studentTags.stream()
                        .map(Tag::getBqMc)
                        .collect(Collectors.toSet());
                
                Set<Integer> studentTagIds = studentTags.stream()
                        .map(Tag::getBqId)
                        .collect(Collectors.toSet());
                
                for (VolunteerActivity activity : candidateActivities) {
                    // 获取活动的标签
                    List<Tag> activityTags = activity.getTags();
                    
                    if (activityTags == null) {
                    activityTags = activityTagMapper.findTagsByActivityId(activity.getHdBh());
                    }
                    if (activityTags == null || activityTags.isEmpty()) {
                    continue;
                    }
                    // 计算标签交集
                    List<String> matchedTags = new ArrayList<>();
                    int tagMatchCount = 0;
                    
                    for (Tag activityTag : activityTags) {
                        if (studentTagIds.contains(activityTag.getBqId())) {
                            matchedTags.add(activityTag.getBqMc());
                            tagMatchCount++;
                        }
                    }
                    
                    // 只推荐有匹配标签的活动
                    if (tagMatchCount > 0) {
                        // 计算综合评分
                        int signupCount = activity.getYbmRs() != null ? activity.getYbmRs() : 0;
                        int viewCount = activity.getLlCs() != null ? activity.getLlCs() : 0;
                        
                        // 加权公式：标签匹配 × 10 + 报名人数 × 2 + 浏览次数 × 0.3
                        double comprehensiveScore = (tagMatchCount * 10.0) + (signupCount * 2.0) + (viewCount * 0.3);
                        
                        ActivityRecommendDTO dto = new ActivityRecommendDTO();
                        dto.setActivity(activity);
                        dto.setMatchScore((int) comprehensiveScore); // 综合评分
                        dto.setMatchedTags(matchedTags);
                        dto.setActivityTags(activityTags);
                        dto.setRecommendType("CONTENT_BASED");
                        recommendList.add(dto);
                    }
                }
                
                // 按综合评分降序排序
                recommendList.sort((a, b) -> b.getMatchScore().compareTo(a.getMatchScore()));
            }
            
            // 4. 兜底策略：如果推荐结果少于5个，补充热门活动
            if (recommendList.size() < 5) {
                // ------------------ 修改开始 ------------------
                
                // 步骤A：获取学生总数
                int totalStudents = 0;
                try {
                    totalStudents = studentMapper.countAllStudents();
                } catch (Exception e) {
                    // 防止统计失败影响推荐，给个默认值或打日志
                    e.printStackTrace();
                }

                // 步骤B：计算阈值 (10%)
                // 如果是新系统学生很少，至少要求1次浏览
                int minViewsThreshold = Math.max(1, (int) Math.ceil(totalStudents * 0.1));
                
                // 步骤C：查询符合条件的热门活动
                List<VolunteerActivity> hotActivities = studentActivityMapper.findHotActivitiesWithThreshold(10, minViewsThreshold);
                
                // ------------------ 修改结束 ------------------
                
                // 去重：排除已经在推荐列表中的活动
                Set<Integer> existingActivityIds = recommendList.stream()
                        .map(dto -> dto.getActivity().getHdBh())
                        .collect(Collectors.toSet());
                
                if (hotActivities != null) {
                    for (VolunteerActivity hotActivity : hotActivities) {
                        if (recommendList.size() >= 10) {
                            break; // 最多推荐10个
                        }
                        
                        if (!existingActivityIds.contains(hotActivity.getHdBh())) {
                            List<Tag> activityTags = hotActivity.getTags();
                            if (activityTags == null) {
                                activityTags = activityTagMapper.findTagsByActivityId(hotActivity.getHdBh());
                            }
                            
                            // 热门活动也使用综合评分（但标签匹配为0）
                            int signupCount = hotActivity.getYbmRs() != null ? hotActivity.getYbmRs() : 0;
                            int viewCount = hotActivity.getLlCs() != null ? hotActivity.getLlCs() : 0;
                            double comprehensiveScore = (signupCount * 2.0) + (viewCount * 0.3);
                            
                            ActivityRecommendDTO dto = new ActivityRecommendDTO();
                            dto.setActivity(hotActivity);
                            dto.setMatchScore((int) comprehensiveScore);
                            dto.setMatchedTags(new ArrayList<>());
                            dto.setActivityTags(activityTags);
                            dto.setRecommendType("HOT"); // 标识为热门推荐
                            recommendList.add(dto);
                            existingActivityIds.add(hotActivity.getHdBh());
                        }
                    }
                }
            }
            
            // 5. 截取前10个
            if (recommendList.size() > 10) {
                recommendList = recommendList.subList(0, 10);
            }
            
            return Result.success(recommendList);
            
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取推荐活动失败：" + e.getMessage());
        }
    }

    private ResponseEntity<byte[]> buildPdf(String content, String filename) {
        // 极简PDF：作为占位，满足下载格式要求
        String pdf = "%PDF-1.4\n1 0 obj<<>>endobj\n2 0 obj<< /Length " + content.length() + " >>stream\n" + content + "\nendstream\nendobj\ntrailer<<>>\n%%EOF";
        byte[] data = pdf.getBytes(java.nio.charset.StandardCharsets.UTF_8);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_PDF);
        headers.setContentDispositionFormData("attachment", filename);
        return ResponseEntity.ok().headers(headers).body(data);
    }

    private ResponseEntity<byte[]> buildErrorFile(String message) {
        byte[] data = message.getBytes(java.nio.charset.StandardCharsets.UTF_8);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.TEXT_PLAIN);
        headers.setContentDispositionFormData("attachment", "error.txt");
        return ResponseEntity.ok().headers(headers).body(data);
    }

    private String nullSafe(Object o) {
        return o == null ? "-" : o.toString();
    }
}
