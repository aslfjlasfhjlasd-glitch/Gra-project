package com.university.volunteer.mapper;

import com.university.volunteer.dto.ActivityPerformanceDTO;
import com.university.volunteer.entity.ActivityRegistration;
import com.university.volunteer.entity.VolunteerActivity;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface StudentActivityMapper {

    @Select("SELECT HD_BH as activityId, HD_MC as activityName, HD_SJ as activityTime, HD_DD as activityLocation, BM_ZT as status, SH_LY as auditReason " +
            "FROM t_zyhdbmb " +
            "WHERE XS_XH = #{studentId}")
    List<ActivityRegistration> selectRegistrationsByStudentId(String studentId);

    @Select("SELECT ID as registrationId, HD_BH as activityId, HD_MC as activityName, HD_SJ as activityTime, " +
            "HD_SC as duration, HD_XF as credits, FZR_PF as leaderRating, ZYZ_PJ as leaderComment, XS_PF as activityRating " +
            "FROM t_zyhdbmb " +
            "WHERE XS_XH = #{studentId} AND BM_ZT = '已审核通过'")
    List<ActivityPerformanceDTO> selectPerformanceByStudentId(String studentId);

    /**
    * 已确认公假单列表
    */
    @Select("SELECT ID as id, HD_BH as activityId, HD_MC as activityName, HD_SJ as activityTime, HD_DD as activityLocation, " +
            "XS_XM as studentName, XS_XH as studentId, GJD_ZT as leaveConfirmed, GJD_SJ as leaveIssuedAt, SH_LY as auditReason " +
            "FROM t_zyhdbmb WHERE XS_XH = #{studentId} AND BM_ZT = '已审核通过' AND GJD_ZT = 1")
    List<ActivityRegistration> selectConfirmedLeaveByStudent(String studentId);

    /**
    * 已确认证明列表
    */
    @Select("SELECT ID as id, HD_BH as activityId, HD_MC as activityName, HD_SJ as activityTime, HD_DD as activityLocation, " +
            "XS_XM as studentName, XS_XH as studentId, HD_SC as duration, HD_XF as credits, ZM_ZT as certificateConfirmed, ZM_SJ as certificateIssuedAt " +
            "FROM t_zyhdbmb WHERE XS_XH = #{studentId} AND BM_ZT = '已审核通过' AND ZM_ZT = 1")
    List<ActivityRegistration> selectConfirmedCertificateByStudent(String studentId);

    /**
     * 根据ID获取活动信息（带标签，由XML实现）
     */
    VolunteerActivity findActivityById(Integer activityId);

    /**
     * 检查是否已报名
     */
    @Select("SELECT COUNT(*) FROM t_zyhdbmb WHERE XS_XH = #{studentId} AND HD_BH = #{activityId}")
    int countRegistration(@Param("studentId") String studentId, @Param("activityId") Integer activityId);

    /**
     * 统计活动已报名人数（已废弃，建议直接读取 t_zyhd.YBM_RS 缓存字段）
     * 注意：此方法统计的是所有报名记录，不区分审核状态，可能与业务语义不符
     * 如需统计"已审核通过"的人数，使用：WHERE HD_BH = #{activityId} AND BM_ZT = '已审核通过'
     */
    @Deprecated
    @Select("SELECT COUNT(*) FROM t_zyhdbmb WHERE HD_BH = #{activityId}")
    int countRegistrationsByActivityId(@Param("activityId") Integer activityId);

    /**
     * 插入报名记录
     */
    @Insert("INSERT INTO t_zyhdbmb (XS_XH, XS_XM, SS_XY, HD_BH, HD_MC, HD_SJ, HD_DD, BM_ZT) " +
            "VALUES (#{studentId}, #{studentName}, #{academyName}, #{activityId}, #{activityName}, #{activityTime}, #{activityLocation}, #{status})")
    int insertRegistration(ActivityRegistration registration);

    /**
     * 更新活动已报名人数（YBM_RS字段）
     * 注意：只统计"已审核通过"的记录，与触发器逻辑保持一致
     */
    @Update("UPDATE t_zyhd SET YBM_RS = (SELECT COUNT(*) FROM t_zyhdbmb WHERE HD_BH = #{activityId} AND BM_ZT = '已审核通过') WHERE HD_BH = #{activityId}")
    int updateRegisteredCount(@Param("activityId") Integer activityId);

    /**
     * 删除报名记录（取消报名）
     */
    @Delete("DELETE FROM t_zyhdbmb WHERE XS_XH = #{studentId} AND HD_BH = #{activityId}")
    int deleteRegistration(@Param("studentId") String studentId, @Param("activityId") Integer activityId);

    /**
     * 根据活动发起单位查询活动列表（带标签，由XML实现）
     */
    List<VolunteerActivity> findActivitiesByDepartment(@Param("department") String department);

    /**
     * 根据部门/学院查询报名记录（用于各种管理功能）
     */
    @Select("SELECT r.ID as id, r.XS_XH as studentId, r.XS_XM as studentName, r.SS_XY as academyName, " +
            "r.HD_BH as activityId, r.HD_MC as activityName, r.HD_SJ as activityTime, r.HD_DD as activityLocation, " +
            "r.BM_ZT as status, r.SH_LY as auditReason, r.QD_SJ as checkInTime, r.QT_SJ as checkOutTime, r.QD_ZT as attendanceStatus, " +
            "r.HD_SC as duration, r.HD_XF as credits, r.ZYZ_PJ as evaluation, r.FZR_PF as rating, r.GJD_ZT as leaveConfirmed, r.GJD_SJ as leaveIssuedAt, " +
            "r.ZM_ZT as certificateConfirmed, r.ZM_SJ as certificateIssuedAt, a.HD_ZT as activityStatus " +
            "FROM t_zyhdbmb r " +
            "INNER JOIN t_zyhd a ON r.HD_BH = a.HD_BH " +
            "WHERE a.HD_FQ_DW = #{department} " +
            "ORDER BY r.ID DESC")
    List<ActivityRegistration> findRegistrationsByDepartment(@Param("department") String department);

    /**
     * 根据报名记录ID获取详情（含负责人部门校验字段）
     */
    @Select("SELECT r.ID as id, r.XS_XH as studentId, r.XS_XM as studentName, r.SS_XY as academyName, " +
            "r.HD_BH as activityId, r.HD_MC as activityName, r.HD_SJ as activityTime, r.HD_DD as activityLocation, " +
            "r.BM_ZT as status, r.SH_LY as auditReason, r.QD_SJ as checkInTime, r.QT_SJ as checkOutTime, r.QD_ZT as attendanceStatus, " +
            "r.HD_SC as duration, r.HD_XF as credits, r.ZYZ_PJ as evaluation, r.FZR_PF as rating, a.HD_FQ_DW as activityDepartment, " +
            "r.GJD_ZT as leaveConfirmed, r.GJD_SJ as leaveIssuedAt, r.ZM_ZT as certificateConfirmed, r.ZM_SJ as certificateIssuedAt, a.HD_ZT as activityStatus " +
            "FROM t_zyhdbmb r " +
            "INNER JOIN t_zyhd a ON r.HD_BH = a.HD_BH " +
            "WHERE r.ID = #{registrationId}")
    ActivityRegistration findRegistrationById(@Param("registrationId") Integer registrationId);

    /**
     * 更新考勤信息
     */
    @Update("UPDATE t_zyhdbmb SET QD_SJ = #{checkInTime}, QT_SJ = #{checkOutTime}, QD_ZT = #{attendanceStatus} WHERE ID = #{registrationId}")
    int updateAttendance(@Param("registrationId") Integer registrationId,
                         @Param("checkInTime") java.util.Date checkInTime,
                         @Param("checkOutTime") java.util.Date checkOutTime,
                         @Param("attendanceStatus") Integer attendanceStatus);

    /**
     * 确认工时与学分
     */
    @Update("UPDATE t_zyhdbmb SET HD_SC = #{duration}, HD_XF = #{credits} WHERE ID = #{registrationId}")
    int updateDurationAndCredits(@Param("registrationId") Integer registrationId,
                                 @Param("duration") Double duration,
                                 @Param("credits") Double credits);

    /**
     * 评价志愿者
     */
    @Update("UPDATE t_zyhdbmb SET ZYZ_PJ = #{evaluation}, FZR_PF = #{rating} WHERE ID = #{registrationId}")
    int updateEvaluation(@Param("registrationId") Integer registrationId,
                         @Param("evaluation") String evaluation,
                         @Param("rating") Integer rating);

    /**
     * 学生对活动评分
     */
    @Update("UPDATE t_zyhdbmb SET XS_PF = #{rating} WHERE ID = #{registrationId} AND XS_XH = #{studentId}")
    int updateActivityRating(@Param("registrationId") Integer registrationId,
                             @Param("studentId") String studentId,
                             @Param("rating") Integer rating);

    /**
     * 确认公假单
     */
    @Update("UPDATE t_zyhdbmb SET GJD_ZT = #{confirmed}, GJD_SJ = #{issuedAt} WHERE ID = #{registrationId}")
    int updateLeaveConfirm(@Param("registrationId") Integer registrationId,
                           @Param("confirmed") Integer confirmed,
                           @Param("issuedAt") java.util.Date issuedAt);

    /**
     * 确认证明
     */
    @Update("UPDATE t_zyhdbmb SET ZM_ZT = #{confirmed}, ZM_SJ = #{issuedAt} WHERE ID = #{registrationId}")
    int updateCertificateConfirm(@Param("registrationId") Integer registrationId,
                                 @Param("confirmed") Integer confirmed,
                                 @Param("issuedAt") java.util.Date issuedAt);

    /**
     * 更新活动信息（使用乐观锁，在XML中实现）
     */
    int updateActivity(VolunteerActivity activity);

    /**
     * 删除活动
     */
    @Delete("DELETE FROM t_zyhd WHERE HD_BH = #{activityId}")
    int deleteActivity(@Param("activityId") Integer activityId);

    /**
     * 更新活动发布状态
     */
    @Update("UPDATE t_zyhd SET FB_ZT = #{status} WHERE HD_BH = #{activityId}")
    int updateActivityPublishStatus(@Param("activityId") Integer activityId, @Param("status") String status);

    /**
     * 更新活动状态
     */
    @Update("UPDATE t_zyhd SET HD_ZT = #{status} WHERE HD_BH = #{activityId}")
    int updateActivityStatus(@Param("activityId") Integer activityId, @Param("status") String status);

    /**
     * 插入新活动
     */
    @Insert("INSERT INTO t_zyhd (HD_MC, BM_KSSJ, BM_JSSJ, HD_KSSJ, HD_JSSJ, HD_NR, HD_DD, " +
            "ZM_RS, YBM_RS, HD_BQ, JN_YQ, ZY_XZ, HDXQ, HD_BZ, HD_FQ_DW, HD_ZT, FB_ZT, BBH) " +
            "VALUES (#{hdMc}, #{bmKssj}, #{bmJssj}, #{hdKssj}, #{hdJssj}, #{hdNr}, #{hdDd}, " +
            "#{zmRs}, 0, #{hdBq}, #{jnYq}, #{zyXz}, #{hdXq}, #{hdBz}, #{hdFqDw}, '未开始', #{fbZt}, 0)")
    @Options(useGeneratedKeys = true, keyProperty = "hdBh")
    int insertActivity(VolunteerActivity activity);

    /**
     * 获取所有活动列表（管理员使用，带标签，由XML实现）
     */
    List<VolunteerActivity> findAllActivities();
    
    /**
     * 根据标签ID查询活动列表（新增：用于标签筛选）
     */
    List<VolunteerActivity> findActivitiesByTagId(@Param("tagId") Integer tagId);
    
    /**
     * 根据多个标签ID查询活动列表（新增：用于智能推荐）
     */
    List<VolunteerActivity> findActivitiesByTagIds(@Param("tagIds") List<Integer> tagIds);
    
    /**
     * 获取所有招募中的活动（用于推荐系统）
     * 状态为"已发布"且在报名时间内的活动
     */
    List<VolunteerActivity> findRecruitingActivities();
    
    /**
     * 获取热门活动（按报名人数倒序）
     */
    List<VolunteerActivity> findHotActivities(@Param("limit") Integer limit);
    
    /**
     * 获取热门活动（带浏览量阈值）
     * @param limit 限制数量
     * @param minViews 最低浏览次数
     */
    List<VolunteerActivity> findHotActivitiesWithThreshold(@Param("limit") int limit, @Param("minViews") int minViews);
    
    /**
     * 获取所有学生ID（用于模拟数据生成）
     */
    @Select("SELECT XS_XH FROM t_xs")
    List<Integer> getAllStudentIds();
    
    /**
     * 获取所有活动ID（用于模拟数据生成）
     */
    @Select("SELECT HD_BH FROM t_zyhd WHERE FB_ZT = '已发布'")
    List<Integer> getAllActivityIds();
    
    /**
     * 插入模拟报名记录（用于演示数据生成）
     */
    @Insert("INSERT INTO t_zyhdbmb (XS_XH, HD_BH, BM_SJ, BM_ZT) " +
            "VALUES (#{studentId}, #{activityId}, #{registrationTime}, #{status})")
    int insertMockRegistration(@Param("studentId") Integer studentId,
                               @Param("activityId") Integer activityId,
                               @Param("registrationTime") String registrationTime,
                               @Param("status") int status);
    
    /**
     * 原子性增加活动浏览次数
     * 使用数据库行锁保证并发安全，避免 select + update 导致的数据丢失
     */
    @Update("UPDATE t_zyhd SET LL_CS = LL_CS + 1 WHERE HD_BH = #{activityId}")
    int incrementViewCount(@Param("activityId") Integer activityId);
}
