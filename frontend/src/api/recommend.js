import axios from 'axios'

const API_BASE_URL = 'http://localhost:8080/api'

/**
 * 获取推荐活动列表
 * @param {number} studentId - 学生学号
 * @returns {Promise} 推荐活动列表
 */
export const getRecommendedActivities = (studentId) => {
  return axios.get(`${API_BASE_URL}/student/activity/recommend`, {
    params: { studentId }
  })
}

/**
 * 上报活动浏览次数
 * 前端在点击"查看详情"按钮时调用
 * 注意：此接口应该以"Fire and Forget"方式调用，不等待响应
 * 
 * @param {number} activityId - 活动ID
 * @returns {Promise} 操作结果（通常不需要等待）
 */
export const reportActivityView = (activityId) => {
  return axios.post(`${API_BASE_URL}/student/activity/${activityId}/view`)
}