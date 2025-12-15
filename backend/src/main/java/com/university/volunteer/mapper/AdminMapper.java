package com.university.volunteer.mapper;

import com.university.volunteer.entity.Admin;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface AdminMapper {
    @Select("SELECT GLY_ZH, GLY_MM, GLY_MC FROM t_gly WHERE GLY_ZH = #{username}")
    Admin findByUsername(String username);
    
    @Update("UPDATE t_gly SET GLY_MM = #{newPassword} WHERE GLY_ZH = #{username}")
    int updatePassword(@Param("username") String username, @Param("newPassword") String newPassword);
}
