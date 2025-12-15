/**
 * 数据可视化大屏 - 模拟数据生成器
 * 用于演示模式，生成合理且联动的随机数据
 */

/**
 * 生成指定范围内的随机整数
 * @param {number} min - 最小值
 * @param {number} max - 最大值
 * @returns {number} 随机整数
 */
const randomInt = (min, max) => {
  return Math.floor(Math.random() * (max - min + 1)) + min
}

/**
 * 生成指定范围内的随机浮点数
 * @param {number} min - 最小值
 * @param {number} max - 最大值
 * @param {number} decimals - 小数位数
 * @returns {number} 随机浮点数
 */
const randomFloat = (min, max, decimals = 2) => {
  return parseFloat((Math.random() * (max - min) + min).toFixed(decimals))
}

/**
 * 生成带趋势的数组（模拟业务增长）
 * @param {number} length - 数组长度
 * @param {number} baseValue - 基准值
 * @param {number} trend - 趋势系数（正数为上升，负数为下降）
 * @param {number} variance - 波动范围
 * @returns {number[]} 数据数组
 */
const generateTrendArray = (length, baseValue, trend = 2, variance = 3) => {
  const result = []
  for (let i = 0; i < length; i++) {
    const trendValue = baseValue + (i * trend)
    const randomVariance = randomInt(-variance, variance)
    result.push(Math.max(1, trendValue + randomVariance))
  }
  return result
}

/**
 * 主函数：生成完整的大屏模拟数据
 * @param {number} goalTotalHours - 目标工时（用于计算合理的累计工时）
 * @returns {Object} 包含所有卡片数据的对象
 */
export const generateDashboardMock = (goalTotalHours = 5000) => {
  // ========== 第一步：生成顶部三大指标（联动设计） ==========
  
  // 1. 累计活动数量（基准数据）
  const totalActivities = randomInt(100, 300)
  
  // 2. 活跃志愿者（基于活动数量计算，确保合理性）
  // 平均每个活动 15-40 人参加
  const activeVolunteers = totalActivities * randomInt(15, 40)
  
  // 3. 累计活动时长（基于志愿者人数计算）
  // 平均每人贡献 5-12 小时，并确保不超过目标太多
  const avgHoursPerPerson = randomInt(5, 12)
  let totalHours = activeVolunteers * avgHoursPerPerson
  
  // 修正：确保累计工时在目标的 70%-110% 之间（更真实）
  const minHours = Math.floor(goalTotalHours * 0.7)
  const maxHours = Math.floor(goalTotalHours * 1.1)
  totalHours = Math.min(Math.max(totalHours, minHours), maxHours)
  
  // ========== 第二步：生成折线图数据（近半年活动趋势） ==========
  
  // 生成 6 个月的活动数量（呈上升趋势）
  const activityTrend = generateTrendArray(6, 10, 2, 2)
  
  // 生成参与人数（强关联活动数量，保持曲线一致性）
  const participantTrend = activityTrend.map(count => {
    const multiplier = randomInt(20, 30)
    return count * multiplier
  })
  
  // ========== 第三步：生成饼图数据（各学院参与度） ==========
  
  const academies = [
    '语言文化学院',
    '国商学院',
    '教育学院',
    '文化和旅游学院',
    '艺术学院',
    '马克思主义学院'
  ]
  
  const academyData = academies.map(name => ({
    name,
    value: randomInt(100, 500)
  }))
  
  // ========== 第四步：生成柱状图数据（活动参与率） ==========
  
  // 生成 6 个月的参与率（60%-95% 之间，呈波动上升）
  const participation6m = generateTrendArray(6, 65, 3, 5).map(val => 
    Math.min(95, Math.max(60, val))
  )
  
  // 3 个月数据直接截取后 3 位（保证数据一致性）
  const participation3m = participation6m.slice(-3)
  
  // ========== 第五步：生成男女比例数据 ==========
  
  const maleRatio = randomInt(35, 65)
  const femaleRatio = 100 - maleRatio
  
  const genderData = [
    { name: '男', value: maleRatio },
    { name: '女', value: femaleRatio }
  ]
  
  // ========== 返回完整数据对象 ==========
  
  return {
    // 顶部指标
    metrics: {
      totalActivities,
      activeVolunteers,
      totalHours
    },
    
    // 折线图：近半年活动趋势
    lineChart: {
      months: ['7月', '8月', '9月', '10月', '11月', '12月'],
      activityData: activityTrend,
      participantData: participantTrend
    },
    
    // 饼图：各学院参与度
    pieChart: {
      data: academyData
    },
    
    // 柱状图：活动参与率
    barChart: {
      months6: ['7月', '8月', '9月', '10月', '11月', '12月'],
      values6: participation6m,
      months3: ['10月', '11月', '12月'],
      values3: participation3m
    },
    
    // 饼图：男女参与比例
    genderPieChart: {
      data: genderData
    }
  }
}

/**
 * 从 sessionStorage 获取或生成新的模拟数据
 * 确保同一会话中数据稳定（刷新页面不变）
 * @param {number} goalTotalHours - 目标工时
 * @returns {Object} 模拟数据对象
 */
export const getMockDataWithCache = (goalTotalHours = 5000) => {
  const CACHE_KEY = 'DASHBOARD_MOCK_DATA'
  
  try {
    // 尝试从 sessionStorage 读取
    const cached = sessionStorage.getItem(CACHE_KEY)
    if (cached) {
      console.log('📦 使用缓存的模拟数据')
      return JSON.parse(cached)
    }
  } catch (error) {
    console.warn('读取缓存失败:', error)
  }
  
  // 生成新数据
  console.log('🎲 生成新的模拟数据')
  const mockData = generateDashboardMock(goalTotalHours)
  
  // 存入 sessionStorage
  try {
    sessionStorage.setItem(CACHE_KEY, JSON.stringify(mockData))
  } catch (error) {
    console.warn('缓存数据失败:', error)
  }
  
  return mockData
}

/**
 * 清除模拟数据缓存
 */
export const clearMockDataCache = () => {
  sessionStorage.removeItem('DASHBOARD_MOCK_DATA')
  console.log('🗑️ 已清除模拟数据缓存')
}