package com.university.volunteer.mapper;

import com.university.volunteer.entity.Admin;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface AdminMapper {
    @Select("SELECT GLY_ZH, GLY_MM, GLY_MC FROM t_gly WHERE GLY_ZH = #{username}")
    Admin findByUsername(String username);
}
