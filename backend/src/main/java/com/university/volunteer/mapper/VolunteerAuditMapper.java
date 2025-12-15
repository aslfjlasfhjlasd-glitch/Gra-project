package com.university.volunteer.mapper;

import com.university.volunteer.dto.VolunteerAuditDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface VolunteerAuditMapper {
    
    /**
     * 查询待审核的志愿者报名列表
     * @param status 审核状态：待审核/已通过/已拒绝
     * @return 报名审核列表
     */
    List<VolunteerAuditDTO> findRegistrationsByStatus(@Param("status") String status);
    
    /**
     * 根据报名ID查询详细信息
     * @param registrationId 报名ID
     * @return 报名详细信息
     */
    VolunteerAuditDTO findRegistrationById(@Param("registrationId") Integer registrationId);
    
    /**
     * 更新报名审核状态
     * @param registrationId 报名ID
     * @param status 新状态
     * @param reviewComment 审核意见
     * @return 影响行数
     */
    int updateRegistrationStatus(@Param("registrationId") Integer registrationId, 
                                  @Param("status") String status,
                                  @Param("reviewComment") String reviewComment);
    
    /**
     * 根据报名ID查询活动编号（用于更新YBM_RS）
     * @param registrationId 报名ID
     * @return 活动编号
     */
    Integer findActivityIdByRegistrationId(@Param("registrationId") Integer registrationId);
    
    /**
     * 插入模拟志愿审核记录（用于演示数据生成）
     */
    int insertMockAudit(@Param("studentId") Integer studentId,
                       @Param("activityId") Integer activityId,
                       @Param("hours") double hours,
                       @Param("description") String description,
                       @Param("submitTime") String submitTime,
                       @Param("status") int status,
                       @Param("auditTime") String auditTime,
                       @Param("rejectReason") String rejectReason);
}