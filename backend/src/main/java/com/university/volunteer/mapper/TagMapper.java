package com.university.volunteer.mapper;

import com.university.volunteer.entity.Tag;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 标签Mapper接口
 * 对应数据库表: t_bqzd
 */
@Mapper
public interface TagMapper {
    
    /**
     * 查询所有启用的标签
     * @return 标签列表
     */
    List<Tag> findAllEnabled();
    
    /**
     * 根据标签类型查询标签
     * @param bqLx 标签类型 (1-兴趣类别, 2-技能)
     * @return 标签列表
     */
    List<Tag> findByType(@Param("bqLx") Integer bqLx);
    
    /**
     * 根据ID查询标签
     * @param bqId 标签ID
     * @return 标签对象
     */
    Tag findById(@Param("bqId") Integer bqId);
    
    /**
     * 根据ID列表批量查询标签
     * @param bqIds 标签ID列表
     * @return 标签列表
     */
    List<Tag> findByIds(@Param("bqIds") List<Integer> bqIds);
    
    /**
     * 根据父标签ID查询子标签
     * @param fId 父标签ID
     * @return 标签列表
     */
    List<Tag> findByParentId(@Param("fId") Integer fId);
    
    /**
     * 插入标签
     * @param tag 标签对象
     * @return 影响行数
     */
    int insert(Tag tag);
    
    /**
     * 更新标签
     * @param tag 标签对象
     * @return 影响行数
     */
    int update(Tag tag);
    
    /**
     * 更新标签热度
     * @param bqId 标签ID
     * @param increment 增量（可为负数）
     * @return 影响行数
     */
    int updateHotness(@Param("bqId") Integer bqId, @Param("increment") Integer increment);
    
    /**
     * 删除标签（逻辑删除，设置状态为0）
     * @param bqId 标签ID
     * @return 影响行数
     */
    int delete(@Param("bqId") Integer bqId);
}