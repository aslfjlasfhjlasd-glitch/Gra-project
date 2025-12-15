package com.university.volunteer.mapper;

import com.university.volunteer.entity.Config;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 系统配置 Mapper 接口
 */
@Mapper
public interface ConfigMapper {
    
    /**
     * 查询所有配置项
     * @return 配置列表
     */
    List<Config> selectAllConfigs();
    
    /**
     * 根据配置键查询配置
     * @param configKey 配置键
     * @return 配置对象
     */
    Config selectByKey(@Param("configKey") String configKey);
    
    /**
     * 更新配置值
     * @param configKey 配置键
     * @param configValue 配置值
     * @return 影响行数
     */
    int updateConfig(@Param("configKey") String configKey, @Param("configValue") String configValue);
    
    /**
     * 批量更新配置
     * @param configs 配置列表
     * @return 影响行数
     */
    int batchUpdateConfigs(@Param("configs") List<Config> configs);
    
    /**
     * 插入新配置
     * @param config 配置对象
     * @return 影响行数
     */
    int insertConfig(Config config);
}