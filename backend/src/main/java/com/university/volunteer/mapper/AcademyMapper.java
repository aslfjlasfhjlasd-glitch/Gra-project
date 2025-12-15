package com.university.volunteer.mapper;

import com.university.volunteer.entity.Academy;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface AcademyMapper {
    @Select("SELECT XY_ZH as xyZh, XY_MM as xyMm, XY_MC as xyMc, FZR_XM as fzrXm, XY_DH as xyDh FROM t_xy WHERE XY_ZH = #{username}")
    Academy findByUsername(String username);
    
    @Update("UPDATE t_xy SET FZR_XM = #{fzrXm}, XY_DH = #{xyDh} WHERE XY_ZH = #{xyZh}")
    int updateAcademy(Academy academy);
    
    @Update("UPDATE t_xy SET XY_MM = #{newPassword} WHERE XY_ZH = #{username}")
    int updatePassword(@Param("username") String username, @Param("newPassword") String newPassword);
    
    // ========== 管理员账号管理功能 ==========
    
    // 分页查询学院列表
    List<Academy> findAcademiesByPage(@Param("keyword") String keyword);
    
    // 检查学院账号是否存在
    Integer existsByUsername(@Param("username") String username);
    
    // 插入新学院
    int insertAcademy(Academy academy);
    
    // 删除学院
    int deleteAcademy(@Param("username") String username);
}
