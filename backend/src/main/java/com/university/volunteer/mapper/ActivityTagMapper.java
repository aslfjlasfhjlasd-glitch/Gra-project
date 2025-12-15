package com.university.volunteer.mapper;

import com.university.volunteer.entity.ActivityTag;
import com.university.volunteer.entity.Tag;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 活动-标签关联Mapper接口
 * 对应数据库表: t_zyhd_bq
 */
@Mapper
public interface ActivityTagMapper {
    
    /**
     * 根据活动编号查询其所有标签
     * @param hdBh 活动编号
     * @return 标签列表
     */
    List<Tag> findTagsByActivityId(@Param("hdBh") Integer hdBh);
    
    /**
     * 根据标签ID查询拥有该标签的活动编号列表
     * @param bqId 标签ID
     * @return 活动编号列表
     */
    List<Integer> findActivityIdsByTagId(@Param("bqId") Integer bqId);
    
    /**
     * 批量插入活动-标签关联
     * @param activityTags 活动-标签关联列表
     * @return 影响行数
     */
    int insertBatch(@Param("list") List<ActivityTag> activityTags);
    
    /**
     * 删除活动的所有标签关联
     * @param hdBh 活动编号
     * @return 影响行数
     */
    int deleteByActivityId(@Param("hdBh") Integer hdBh);
    
    /**
     * 删除指定活动的指定标签
     * @param hdBh 活动编号
     * @param bqId 标签ID
     * @return 影响行数
     */
    int deleteByActivityIdAndTagId(@Param("hdBh") Integer hdBh, @Param("bqId") Integer bqId);
    
    /**
     * 检查活动是否拥有某个标签
     * @param hdBh 活动编号
     * @param bqId 标签ID
     * @return 存在返回1，不存在返回0
     */
    int existsByActivityIdAndTagId(@Param("hdBh") Integer hdBh, @Param("bqId") Integer bqId);
}