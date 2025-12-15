package com.university.volunteer.mapper;

import com.university.volunteer.entity.DepartmentHead;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface DepartmentHeadMapper {
    @Select("SELECT XJBM_MC as xjbmMc, XJBMFZR_ZH as xjbmfzrZh, XJBMFZR_MM as xjbmfzrMm, XJBMFZR_XM as xjbmfzrXm, XJBMFZR_DH as xjbmfzrDh FROM t_xjbmfzr WHERE XJBMFZR_ZH = #{username}")
    DepartmentHead findByUsername(String username);

    @Update("UPDATE t_zyhdbmb SET BM_ZT = #{status} WHERE ID = #{registrationId}")
    int updateRegistrationStatus(Integer registrationId, String status);
    
    @Update("UPDATE t_xjbmfzr SET XJBMFZR_XM = #{xjbmfzrXm}, XJBMFZR_DH = #{xjbmfzrDh} WHERE XJBMFZR_ZH = #{xjbmfzrZh}")
    int updateDepartmentHead(DepartmentHead departmentHead);
    
    @Update("UPDATE t_xjbmfzr SET XJBMFZR_MM = #{newPassword} WHERE XJBMFZR_ZH = #{username}")
    int updatePassword(@Param("username") String username, @Param("newPassword") String newPassword);
    
    // ========== 管理员账号管理功能 ==========
    
    // 分页查询负责人列表
    List<DepartmentHead> findDepartmentHeadsByPage(@Param("keyword") String keyword);
    
    // 检查工号是否存在
    Integer existsByUsername(@Param("username") String username);
    
    // 插入新负责人
    int insertDepartmentHead(DepartmentHead departmentHead);
    
    // 删除负责人
    int deleteDepartmentHead(@Param("username") String username);
}
