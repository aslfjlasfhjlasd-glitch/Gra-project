package com.university.volunteer.service;

import com.university.volunteer.entity.Config;
import com.university.volunteer.mapper.ConfigMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 系统配置服务类
 */
@Service
public class ConfigService {

    @Autowired
    private ConfigMapper configMapper;

    /**
     * 获取所有配置项
     * @return 配置列表
     */
    public List<Config> getAllConfigs() {
        return configMapper.selectAllConfigs();
    }

    /**
     * 获取所有配置项（Map格式）
     * @return key-value格式的配置Map
     */
    public Map<String, String> getAllConfigsAsMap() {
        List<Config> configs = configMapper.selectAllConfigs();
        Map<String, String> configMap = new HashMap<>();
        for (Config config : configs) {
            configMap.put(config.getConfigKey(), config.getConfigValue());
        }
        return configMap;
    }

    /**
     * 根据配置键获取配置值
     * @param configKey 配置键
     * @return 配置值
     */
    public String getConfigValue(String configKey) {
        Config config = configMapper.selectByKey(configKey);
        return config != null ? config.getConfigValue() : null;
    }

    /**
     * 根据配置键获取配置对象
     * @param configKey 配置键
     * @return 配置对象
     */
    public Config getConfigByKey(String configKey) {
        return configMapper.selectByKey(configKey);
    }

    /**
     * 更新单个配置
     * @param configKey 配置键
     * @param configValue 配置值
     * @return 是否更新成功
     */
    @Transactional
    public boolean updateConfig(String configKey, String configValue) {
        return configMapper.updateConfig(configKey, configValue) > 0;
    }

    /**
     * 批量更新配置
     * @param configMap 配置Map (key -> value)
     * @return 更新成功的数量
     */
    @Transactional
    public int batchUpdateConfigs(Map<String, String> configMap) {
        int count = 0;
        for (Map.Entry<String, String> entry : configMap.entrySet()) {
            if (configMapper.updateConfig(entry.getKey(), entry.getValue()) > 0) {
                count++;
            }
        }
        return count;
    }

    /**
     * 插入新配置
     * @param config 配置对象
     * @return 是否插入成功
     */
    @Transactional
    public boolean insertConfig(Config config) {
        return configMapper.insertConfig(config) > 0;
    }

    /**
     * 获取大屏配置信息（用于大屏展示）
     * @return 大屏配置Map
     */
    public Map<String, Object> getDashboardConfigs() {
        Map<String, Object> result = new HashMap<>();
        
        // 获取所有配置
        List<Config> configs = configMapper.selectAllConfigs();
        
        for (Config config : configs) {
            String key = config.getConfigKey();
            String value = config.getConfigValue();
            
            // 将布尔值字符串转换为布尔类型
            if ("true".equalsIgnoreCase(value) || "false".equalsIgnoreCase(value)) {
                result.put(key, Boolean.parseBoolean(value));
            } 
            // 尝试转换为数字
            else if (value != null && value.matches("\\d+")) {
                try {
                    result.put(key, Integer.parseInt(value));
                } catch (NumberFormatException e) {
                    result.put(key, value);
                }
            } 
            // 其他情况保持字符串
            else {
                result.put(key, value);
            }
        }
        
        return result;
    }
}