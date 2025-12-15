package com.university.volunteer.mapper;

import com.university.volunteer.entity.StudentTag;
import com.university.volunteer.entity.Tag;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 学生-标签关联Mapper接口
 * 对应数据库表: t_xs_bq
 */
@Mapper
public interface StudentTagMapper {
    
    /**
     * 根据学生学号查询其所有标签
     * @param xsXh 学生学号
     * @return 标签列表
     */
    List<Tag> findTagsByStudentId(@Param("xsXh") Integer xsXh);
    
    /**
     * 根据标签ID查询拥有该标签的学生学号列表
     * @param bqId 标签ID
     * @return 学生学号列表
     */
    List<Integer> findStudentIdsByTagId(@Param("bqId") Integer bqId);
    
    /**
     * 批量插入学生-标签关联
     * @param studentTags 学生-标签关联列表
     * @return 影响行数
     */
    int insertBatch(@Param("list") List<StudentTag> studentTags);
    
    /**
     * 删除学生的所有标签关联
     * @param xsXh 学生学号
     * @return 影响行数
     */
    int deleteByStudentId(@Param("xsXh") Integer xsXh);
    
    /**
     * 删除指定学生的指定标签
     * @param xsXh 学生学号
     * @param bqId 标签ID
     * @return 影响行数
     */
    int deleteByStudentIdAndTagId(@Param("xsXh") Integer xsXh, @Param("bqId") Integer bqId);
    
    /**
     * 检查学生是否拥有某个标签
     * @param xsXh 学生学号
     * @param bqId 标签ID
     * @return 存在返回1，不存在返回0
     */
    int existsByStudentIdAndTagId(@Param("xsXh") Integer xsXh, @Param("bqId") Integer bqId);
}