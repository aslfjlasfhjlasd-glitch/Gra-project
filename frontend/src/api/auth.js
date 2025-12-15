import axios from 'axios';
const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080';
const API_URL = `${API_BASE}/api/auth`;

/**
 * 登录 API 调用
 * 发送用户名、密码和角色到后端进行验证
 * 
 * @param {string} username 用户名
 * @param {string} password 密码
 * @param {string} role 角色
 * @returns {Promise<Object>} 响应结果对象
 */
export const login = async (username, password, role) => {
    try {
        const response = await axios.post(`${API_URL}/login`, {
            username,
            password,
            role
        });
        return response.data;
    } catch (error) {
        if (error.response) {
            // 服务器返回了错误状态码
            return error.response.data;
        } else if (error.request) {
            // 请求已发出但未收到响应（可能是网络问题或服务器宕机）
            return { code: 500, message: '服务器无法连接' };
        } else {
            // 请求设置过程中发生错误
            return { code: 500, message: '请求设置错误' };
        }
    }
};
