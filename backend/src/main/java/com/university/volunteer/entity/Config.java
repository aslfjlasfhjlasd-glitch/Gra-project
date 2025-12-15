package com.university.volunteer.entity;

import java.time.LocalDateTime;

/**
 * 系统配置实体类
 * 对应 sys_config 表
 */
public class Config {
    private Integer configId;
    private String configKey;
    private String configValue;
    private String configName;
    private String description;
    private LocalDateTime updateTime;

    // 构造函数
    public Config() {
    }

    public Config(String configKey, String configValue) {
        this.configKey = configKey;
        this.configValue = configValue;
    }

    // Getters and Setters
    public Integer getConfigId() {
        return configId;
    }

    public void setConfigId(Integer configId) {
        this.configId = configId;
    }

    public String getConfigKey() {
        return configKey;
    }

    public void setConfigKey(String configKey) {
        this.configKey = configKey;
    }

    public String getConfigValue() {
        return configValue;
    }

    public void setConfigValue(String configValue) {
        this.configValue = configValue;
    }

    public String getConfigName() {
        return configName;
    }

    public void setConfigName(String configName) {
        this.configName = configName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return "Config{" +
                "configId=" + configId +
                ", configKey='" + configKey + '\'' +
                ", configValue='" + configValue + '\'' +
                ", configName='" + configName + '\'' +
                ", description='" + description + '\'' +
                ", updateTime=" + updateTime +
                '}';
    }
}