import axios from 'axios';

// API基础URL
const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080';
const API_BASE_URL = `${API_BASE}/api/admin`;

// 获取志愿者审核列表
export const getVolunteerReviews = (status) => {
  return axios.get(`${API_BASE_URL}/reviews`, {
    params: { status }
  });
};

// 根据ID获取志愿者审核详情
export const getVolunteerReviewDetail = (registrationId) => {
  return axios.get(`${API_BASE_URL}/reviews/${registrationId}`);
};

// 审核通过志愿者报名
export const approveVolunteerRegistration = (registrationId) => {
  return axios.put(`${API_BASE_URL}/reviews/${registrationId}/approve`);
};

// 审核拒绝志愿者报名
export const rejectVolunteerRegistration = (registrationId, reason) => {
  return axios.put(`${API_BASE_URL}/reviews/${registrationId}/reject`, { reason });
};

// 获取所有活动列表
export const getAllActivities = () => {
  return axios.get(`${API_BASE_URL}/activities`);
};

// 发布活动
export const publishActivity = (activityId) => {
  return axios.put(`${API_BASE_URL}/activity/${activityId}/publish`);
};

// 下架活动
export const unpublishActivity = (activityId) => {
  return axios.put(`${API_BASE_URL}/activity/${activityId}/unpublish`);
};

// ==================== 配置管理 API ====================

/**
 * 获取所有配置项列表
 * @returns {Promise} 配置列表
 */
export const getConfigList = () => {
  return axios.get(`${API_BASE_URL}/config/list`);
};

/**
 * 获取所有配置项（Map格式）
 * @returns {Promise} 配置Map
 */
export const getConfigMap = () => {
  return axios.get(`${API_BASE_URL}/config/map`);
};

/**
 * 根据配置键获取配置值
 * @param {string} configKey 配置键
 * @returns {Promise} 配置值
 */
export const getConfigValue = (configKey) => {
  return axios.get(`${API_BASE_URL}/config/${configKey}`);
};

/**
 * 更新单个配置
 * @param {string} configKey 配置键
 * @param {string} configValue 配置值
 * @returns {Promise} 更新结果
 */
export const updateConfig = (configKey, configValue) => {
  return axios.put(`${API_BASE_URL}/config/${configKey}`, { configValue });
};

/**
 * 批量更新配置
 * @param {Object} configMap 配置Map对象 {key: value, ...}
 * @returns {Promise} 更新结果
 */
export const batchUpdateConfigs = (configMap) => {
  return axios.post(`${API_BASE_URL}/config/batch-update`, configMap);
};

/**
 * 添加新配置
 * @param {Object} config 配置对象
 * @returns {Promise} 添加结果
 */
export const addConfig = (config) => {
  return axios.post(`${API_BASE_URL}/config`, config);
};

// ==================== 大屏数据 API ====================

/**
 * 获取大屏综合数据
 * @returns {Promise} 大屏数据
 */
export const getDashboardData = () => {
  return axios.get(`${API_BASE}/api/dashboard/data`);
};

/**
 * 获取大屏配置信息
 * @returns {Promise} 配置信息
 */
export const getDashboardConfigs = () => {
  return axios.get(`${API_BASE}/api/dashboard/configs`);
};

// ==================== 模拟数据生成 API ====================

/**
 * 生成模拟数据
 * @param {number} count 生成数量（默认50条）
 * @returns {Promise} 生成结果
 */
export const generateMockData = (count = 50) => {
  return axios.post(`${API_BASE_URL}/mock-data/generate`, { count });
};

/**
 * 清空模拟数据
 * @returns {Promise} 清空结果
 */
export const clearMockData = () => {
  return axios.delete(`${API_BASE_URL}/mock-data/clear`);
};

// ==================== 账号管理 API ====================

/**
 * 获取学生账号列表（分页）
 * @param {string} keyword 搜索关键词
 * @param {number} page 页码
 * @param {number} size 每页大小
 * @returns {Promise} 学生列表
 */
export const getStudentList = (keyword = '', page = 1, size = 10) => {
  return axios.get(`${API_BASE_URL}/accounts/student/list`, {
    params: { keyword, page, size }
  });
};

/**
 * 新增学生账号
 * @param {Object} data 学生账号信息
 * @returns {Promise} 创建结果
 */
export const addStudent = (data) => {
  return axios.post(`${API_BASE_URL}/accounts/student/add`, data);
};

/**
 * 更新学生账号信息
 * @param {Object} data 学生账号信息
 * @returns {Promise} 更新结果
 */
export const updateStudent = (data) => {
  return axios.put(`${API_BASE_URL}/accounts/student/update`, data);
};

/**
 * 重置学生密码
 * @param {number} id 学号
 * @returns {Promise} 重置结果
 */
export const resetStudentPassword = (id) => {
  return axios.post(`${API_BASE_URL}/accounts/student/reset-pwd`, { id });
};

/**
 * 删除学生账号
 * @param {number} id 学号
 * @returns {Promise} 删除结果
 */
export const deleteStudent = (id) => {
  return axios.delete(`${API_BASE_URL}/accounts/student/${id}`);
};

/**
 * 获取负责人账号列表（分页）
 * @param {string} keyword 搜索关键词
 * @param {number} page 页码
 * @param {number} size 每页大小
 * @returns {Promise} 负责人列表
 */
export const getDepartmentHeadList = (keyword = '', page = 1, size = 10) => {
  return axios.get(`${API_BASE_URL}/accounts/head/list`, {
    params: { keyword, page, size }
  });
};

/**
 * 新增负责人账号
 * @param {Object} data 负责人账号信息
 * @returns {Promise} 创建结果
 */
export const addDepartmentHead = (data) => {
  return axios.post(`${API_BASE_URL}/accounts/head/add`, data);
};

/**
 * 更新负责人账号信息
 * @param {Object} data 负责人账号信息
 * @returns {Promise} 更新结果
 */
export const updateDepartmentHead = (data) => {
  return axios.put(`${API_BASE_URL}/accounts/head/update`, data);
};

/**
 * 重置负责人密码
 * @param {string} username 账号
 * @param {string} accountType 账号类型 (department/academy)
 * @returns {Promise} 重置结果
 */
export const resetDepartmentHeadPassword = (username, accountType) => {
  return axios.post(`${API_BASE_URL}/accounts/head/reset-pwd`, { username, accountType });
};

/**
 * 删除负责人账号
 * @param {string} username 账号
 * @param {string} accountType 账号类型 (department/academy)
 * @returns {Promise} 删除结果
 */
export const deleteDepartmentHead = (username, accountType) => {
  return axios.delete(`${API_BASE_URL}/accounts/head/${username}`, {
    params: { accountType }
  });
};

/**
 * 修改管理员密码
 * @param {string} username 管理员账号
 * @param {string} oldPassword 旧密码
 * @param {string} newPassword 新密码
 * @returns {Promise} 修改结果
 */
export const changeAdminPassword = (username, oldPassword, newPassword) => {
  return axios.post(`${API_BASE_URL}/change-password`, {
    username,
    oldPassword,
    newPassword
  });
};