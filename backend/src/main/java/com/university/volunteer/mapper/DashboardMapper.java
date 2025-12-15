package com.university.volunteer.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface DashboardMapper {

    /**
     * 统计各学院学生人数（作为参与度数据）
     * 关联 t_xy 和 t_xs 表，确保包含所有学院，即使该学院没有学生
     */
    @Select("SELECT t_xy.XY_MC as name, COUNT(t_xs.XS_XH) as value " +
            "FROM t_xy " +
            "LEFT JOIN t_xs ON t_xy.XY_MC = t_xs.SS_XY " +
            "GROUP BY t_xy.XY_MC")
    List<Map<String, Object>> getAcademyParticipationStats();

   @Select("SELECT HD_BH AS id, HD_MC AS hdmc, " +
            "CONCAT(DATE_FORMAT(BM_KSSJ, '%Y-%m-%d %H:%i'), '至', DATE_FORMAT(BM_JSSJ, '%Y-%m-%d %H:%i')) AS bmsj, " +
            "CONCAT(DATE_FORMAT(HD_KSSJ, '%Y-%m-%d %H:%i'), '-', DATE_FORMAT(HD_JSSJ, '%H:%i')) AS hdsj, " +
            "DATE_FORMAT(BM_KSSJ, '%Y-%m-%d %H:%i:%s') AS bmkssj, " +
            "DATE_FORMAT(BM_JSSJ, '%Y-%m-%d %H:%i:%s') AS bmjssj, " +
            "DATE_FORMAT(HD_KSSJ, '%Y-%m-%d %H:%i:%s') AS hdkssj, " +
            "DATE_FORMAT(HD_JSSJ, '%Y-%m-%d %H:%i:%s') AS hdjssj, " +
            "HD_DD AS hddd, ZM_RS AS zyrs, YBM_RS AS ybmrs, HD_BQ AS hdbq, HD_XF AS hdxf " + 
            "FROM t_zyhd WHERE FB_ZT = '已发布' ORDER BY HD_BH DESC")
    List<Map<String, Object>> listVolunteerActivities();

   @Select("SELECT HD_BH AS id, HD_MC AS hdmc, " +
            "CONCAT(DATE_FORMAT(BM_KSSJ, '%Y-%m-%d %H:%i'), '至', DATE_FORMAT(BM_JSSJ, '%Y-%m-%d %H:%i')) AS bmsj, " +
            "CONCAT(DATE_FORMAT(HD_KSSJ, '%Y-%m-%d %H:%i'), '-', DATE_FORMAT(HD_JSSJ, '%H:%i')) AS hdsj, " +
            "DATE_FORMAT(BM_KSSJ, '%Y-%m-%d %H:%i:%s') AS bmkssj, " +
            "DATE_FORMAT(BM_JSSJ, '%Y-%m-%d %H:%i:%s') AS bmjssj, " +
            "DATE_FORMAT(HD_KSSJ, '%Y-%m-%d %H:%i:%s') AS hdkssj, " +
            "DATE_FORMAT(HD_JSSJ, '%Y-%m-%d %H:%i:%s') AS hdjssj, " +
            "HD_NR AS hdnr, HD_DD AS hddd, ZM_RS AS zyrs, YBM_RS AS ybmrs, HDXQ AS hdxq, HD_BZ AS hdbz, HD_FQ_DW AS hdfqdw, HD_ZT AS hdzt, HD_BQ AS hdbq, HD_XF AS hdXf " +
            "FROM t_zyhd WHERE HD_BH = #{id} AND FB_ZT = '已发布'")
    Map<String, Object> getVolunteerActivityDetail(Integer id);
}
