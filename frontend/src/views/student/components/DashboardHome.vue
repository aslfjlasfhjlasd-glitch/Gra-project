<script setup lang="ts">
import { onMounted, ref, onUnmounted } from 'vue'
import axios from 'axios'
import type { EChartsType } from 'echarts'
const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'
import { Card, CardContent } from '@/components/ui/card'
import { 
  Activity, 
  Users, 
  Clock,
  TrendingUp,
  PieChart,
  BarChart
} from 'lucide-vue-next'
import { getMockDataWithCache, clearMockDataCache } from '@/api/mockData.js'

// 模拟数据类型定义
type MockData = {
  metrics: {
    totalActivities: number
    activeVolunteers: number
    totalHours: number
  }
  lineChart: {
    months: string[]
    activityData: number[]
    participantData: number[]
  }
  pieChart: {
    data: Array<{ name: string; value: number }>
  }
  barChart: {
    months6: string[]
    values6: number[]
    months3: string[]
    values3: number[]
  }
  genderPieChart: {
    data: Array<{ name: string; value: number }>
  }
}

// DOM 引用
const lineChartRef = ref<HTMLElement | null>(null)
const pieChartRef = ref<HTMLElement | null>(null)
const barChartRef = ref<HTMLElement | null>(null)
const genderPieRef = ref<HTMLElement | null>(null)

// 图表实例
let lineChart: EChartsType | null = null
let pieChart: EChartsType | null = null
let barChart: EChartsType | null = null
let genderPieChart: EChartsType | null = null

// 演示模式控制
const isMockMode = ref(false)
let liveUpdateTimer: number | null = null

// 配置数据
type DashboardConfig = {
  dashboard_title: string
  dashboard_notice: string
  goal_total_hours: number
  show_academy_rank: boolean
  show_gender_ratio: boolean
}

const dashboardConfig = ref<DashboardConfig>({
  dashboard_title: '志愿活动数据可视化大屏',
  dashboard_notice: '欢迎各位领导莅临指导，本学期志愿活动火热进行中！',
  goal_total_hours: 5000,
  show_academy_rank: true,
  show_gender_ratio: true
})

// 指标数据（响应式）
const metrics = ref({
  totalActivities: 128,
  activeVolunteers: 356,
  totalHours: 12450
})

// 参与率数据源
const participationRange = ref<'3m' | '6m'>('6m')
const baseParticipation = ref({
  months6: ['7月', '8月', '9月', '10月', '11月', '12月'],
  values6: [65, 70, 85, 88, 82, 92],
  months3: ['10月', '11月', '12月'],
  values3: [70, 78, 82]
})

// 加载配置信息
const loadDashboardConfig = async () => {
  try {
    const response = await axios.get(`${API_BASE}/api/dashboard/configs`)
    if (response.data.code === 200) {
      const configs: Record<string, any> = response.data.data || {}
      const current = dashboardConfig.value
      
      // 分别处理每个字段，避免类型推断问题
      if ('dashboard_title' in configs && typeof configs.dashboard_title === 'string') {
        current.dashboard_title = configs.dashboard_title
      }
      if ('dashboard_notice' in configs && typeof configs.dashboard_notice === 'string') {
        current.dashboard_notice = configs.dashboard_notice
      }
      if ('goal_total_hours' in configs) {
        const num = Number(configs.goal_total_hours)
        if (!isNaN(num)) {
          current.goal_total_hours = num
        }
      }
      if ('show_academy_rank' in configs) {
        current.show_academy_rank = configs.show_academy_rank === 'true' || configs.show_academy_rank === true
      }
      if ('show_gender_ratio' in configs) {
        current.show_gender_ratio = configs.show_gender_ratio === 'true' || configs.show_gender_ratio === true
      }
      
      console.log('✅ 大屏配置加载成功:', dashboardConfig.value)
    }
  } catch (error: any) {
    console.error('❌ 加载大屏配置失败:', error)
    // 使用默认配置
  }
}

// 初始化折线图（空图表）
const initLineChart = async () => {
  if (!lineChartRef.value) return
  
  // 如果已存在实例,先销毁
  if (lineChart && !lineChart.isDisposed()) {
    lineChart.dispose()
  }
  
  const echarts = await import('echarts')
  lineChart = echarts.init(lineChartRef.value)
  const option = {
    tooltip: {
      trigger: 'axis'
    },
    legend: {
      data: ['活动数量', '参与人数'],
      bottom: 0
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '10%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: []
    },
    yAxis: {
      type: 'value'
    },
    series: [
      {
        name: '活动数量',
        type: 'line',
        smooth: true,
        data: [],
        itemStyle: { color: '#2563eb' },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(37, 99, 235, 0.3)' },
            { offset: 1, color: 'rgba(37, 99, 235, 0)' }
          ])
        }
      },
      {
        name: '参与人数',
        type: 'line',
        smooth: true,
        data: [],
        itemStyle: { color: '#10b981' },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(16, 185, 129, 0.3)' },
            { offset: 1, color: 'rgba(16, 185, 129, 0)' }
          ])
        }
      }
    ]
  }
  lineChart.setOption(option)
}

// 初始化饼图（空图表）
const initPieChart = async () => {
  if (!pieChartRef.value) return
  
  // 如果已存在实例,先销毁
  if (pieChart && !pieChart.isDisposed()) {
    pieChart.dispose()
  }
  
  const echarts = await import('echarts')
  pieChart = echarts.init(pieChartRef.value)
  
  const option = {
    tooltip: {
      trigger: 'item',
      formatter: '{b}: {c} ({d}%)'
    },
    legend: {
      show: false
    },
    series: [
      {
        name: '参与度占比',
        type: 'pie',
        radius: ['40%', '70%'],
        center: ['50%', '50%'],
        avoidLabelOverlap: false,
        itemStyle: {
          borderRadius: 10,
          borderColor: '#fff',
          borderWidth: 2
        },
        label: {
          show: false,
          position: 'center'
        },
        emphasis: {
          label: {
            show: true,
            fontSize: 16,
            fontWeight: 'bold'
          }
        },
        labelLine: {
          show: false
        },
        data: []
      }
    ]
  }
  pieChart.setOption(option)
}

// 初始化男女比例环形图（空图表）
const initGenderPieChart = async () => {
  if (!genderPieRef.value || !dashboardConfig.value.show_gender_ratio) return
  
  // 如果已存在实例,先销毁
  if (genderPieChart && !genderPieChart.isDisposed()) {
    genderPieChart.dispose()
  }
  
  const echarts = await import('echarts')
  genderPieChart = echarts.init(genderPieRef.value)

  const option = {
    tooltip: {
      trigger: 'item',
      formatter: '{b}: {c}%'
    },
    legend: { show: false },
    series: [
      {
        name: '男女参与比例',
        type: 'pie',
        radius: ['40%', '70%'],
        center: ['50%', '50%'],
        avoidLabelOverlap: false,
        itemStyle: {
          borderRadius: 10,
          borderColor: '#fff',
          borderWidth: 2
        },
        label: { show: false, position: 'center' },
        emphasis: {
          label: {
            show: true,
            fontSize: 16,
            fontWeight: 'bold'
          }
        },
        labelLine: { show: false },
        data: []
      }
    ]
  }
  genderPieChart.setOption(option)
}

// 初始化柱状图（空图表）
const initBarChart = async () => {
  if (!barChartRef.value) return
  
  // 如果已存在实例,先销毁
  if (barChart && !barChart.isDisposed()) {
    barChart.dispose()
  }
  
  const echarts = await import('echarts')
  barChart = echarts.init(barChartRef.value)
  const option = {
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow'
      }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: [],
      axisLabel: {
        interval: 0
      }
    },
    yAxis: {
      type: 'value',
      axisLabel: {
        formatter: '{value}%'
      }
    },
    series: [
      {
        name: '参与率',
        type: 'bar',
        barWidth: '40%',
        data: [],
        itemStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: '#6366f1' },
            { offset: 1, color: '#8b5cf6' }
          ]),
          borderRadius: [4, 4, 0, 0]
        },
        label: {
          show: true,
          position: 'top',
          formatter: '{c}%'
        }
      }
    ]
  }
  barChart.setOption(option)
}

// ========== 模拟数据模式逻辑 ==========

/**
 * 运行模拟数据逻辑
 */
const runMockDataLogic = () => {
  console.log('🎭 进入演示模式')
  
  // 获取模拟数据（带缓存）
  const mockData = getMockDataWithCache(dashboardConfig.value.goal_total_hours) as MockData
  
  // 1. 更新顶部指标
  metrics.value = mockData.metrics
  
  // 2. 更新折线图
  if (lineChart) {
    lineChart.setOption({
      xAxis: {
        data: mockData.lineChart.months
      },
      series: [
        { data: mockData.lineChart.activityData },
        { data: mockData.lineChart.participantData }
      ]
    })
  }
  
  // 3. 更新学院参与度饼图
  if (pieChart && dashboardConfig.value.show_academy_rank) {
    pieChart.setOption({
      series: [
        { data: mockData.pieChart.data }
      ]
    })
  }
  
  // 4. 更新参与率柱状图数据源
  baseParticipation.value = {
    months6: mockData.barChart.months6,
    values6: mockData.barChart.values6,
    months3: mockData.barChart.months3,
    values3: mockData.barChart.values3
  }
  
  // 更新柱状图显示
  if (barChart) {
    const months = participationRange.value === '3m' ? mockData.barChart.months3 : mockData.barChart.months6
    const values = participationRange.value === '3m' ? mockData.barChart.values3 : mockData.barChart.values6
    barChart.setOption({
      xAxis: { data: months },
      series: [{ data: values }]
    })
  }
  
  // 5. 更新男女比例饼图
  if (genderPieChart && dashboardConfig.value.show_gender_ratio) {
    genderPieChart.setOption({
      series: [
        { data: mockData.genderPieChart.data }
      ]
    })
  }
  
  // 6. 启动实时增长效果
  startLiveUpdate()
  
  console.log('✨ 模拟数据已加载:', mockData)
}

/**
 * 启动实时增长效果（让数据"活"起来）
 */
const startLiveUpdate = () => {
  if (liveUpdateTimer) return
  
  liveUpdateTimer = window.setInterval(() => {
    // 30% 概率触发增长
    if (Math.random() < 0.3) {
      metrics.value.totalHours += 1
      console.log('⏱️ 实时工时 +1:', metrics.value.totalHours)
    }
  }, 5000) // 每 5 秒检查一次
}

/**
 * 停止实时增长效果
 */
const stopLiveUpdate = () => {
  if (liveUpdateTimer) {
    clearInterval(liveUpdateTimer)
    liveUpdateTimer = null
  }
}

// ========== 真实数据模式逻辑 ==========

/**
 * 从后端获取真实数据
 */
const fetchRealData = async () => {
  console.log('🌐 加载真实数据')
  
  try {
    // 1. 加载折线图数据（示例，需要根据实际 API 调整）
    // 这里保持原有的静态数据作为示例
    if (lineChart) {
      lineChart.setOption({
        xAxis: {
          data: ['7月', '8月', '9月', '10月', '11月', '12月']
        },
        series: [
          { data: [12, 15, 25, 30, 28, 35] },
          { data: [120, 150, 380, 420, 390, 510] }
        ]
      })
    }
    
    // 2. 加载学院参与度数据（从后端）
    if (pieChart && dashboardConfig.value.show_academy_rank) {
      pieChart.showLoading({ text: '加载中...', color: '#6b7280' })
      
      const response = await axios.get(`${API_BASE}/api/dashboard/academy-stats`)
      let data = []
      
      if (response.data.code === 200) {
        const raw = Array.isArray(response.data.data) ? response.data.data : []
        data = raw.map((item: any) => ({
          name: String(item.name ?? ''),
          value: Number(item.value ?? 0)
        }))
      }
      
      pieChart.setOption({
        series: [{ data }]
      })
      pieChart.hideLoading()
    }
    
    // 3. 更新柱状图
    if (barChart) {
      const months = participationRange.value === '3m' ? baseParticipation.value.months3 : baseParticipation.value.months6
      const values = participationRange.value === '3m' ? baseParticipation.value.values3 : baseParticipation.value.values6
      barChart.setOption({
        xAxis: { data: months },
        series: [{ data: values }]
      })
    }
    
    // 4. 更新男女比例
    if (genderPieChart && dashboardConfig.value.show_gender_ratio) {
      genderPieChart.setOption({
        series: [
          {
            data: [
              { name: '男', value: 58 },
              { name: '女', value: 42 }
            ]
          }
        ]
      })
    }
    
    console.log('✅ 真实数据加载完成')
    
  } catch (error: any) {
    console.error('❌ 加载真实数据失败:', error)
  }
}

// 切换参与率时间范围
const changeParticipationRange = async (range: '3m' | '6m') => {
  participationRange.value = range
  if (barChart) {
    const months = participationRange.value === '3m' ? baseParticipation.value.months3 : baseParticipation.value.months6
    const values = participationRange.value === '3m' ? baseParticipation.value.values3 : baseParticipation.value.values6
    barChart.setOption({
      xAxis: { data: months },
      series: [{ data: values }]
    })
  } else {
    await initBarChart()
  }
}

// 窗口大小改变时重绘图表
const handleResize = () => {
  lineChart?.resize()
  pieChart?.resize()
  barChart?.resize()
  genderPieChart?.resize()
}

// 检查是否启用演示模式
const checkMockMode = () => {
  // 方式1: 从 localStorage 读取
  const mode = localStorage.getItem('DASHBOARD_MODE')
  if (mode === 'demo' || mode === 'mock') {
    return true
  }
  
  // 方式2: 从 URL 参数读取 (?mode=demo)
  const urlParams = new URLSearchParams(window.location.search)
  if (urlParams.get('mode') === 'demo' || urlParams.get('mode') === 'mock') {
    return true
  }
  
  return false
}

// 显示提示消息
const showToast = (message: string) => {
  // 简单的提示实现（可以替换为更好的 UI 库）
  const toast = document.createElement('div')
  toast.textContent = message
  toast.style.cssText = `
    position: fixed;
    top: 20px;
    right: 20px;
    background: #3b82f6;
    color: white;
    padding: 12px 24px;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    z-index: 9999;
    animation: slideIn 0.3s ease-out;
  `
  document.body.appendChild(toast)
  
  setTimeout(() => {
    toast.style.animation = 'slideOut 0.3s ease-out'
    setTimeout(() => toast.remove(), 300)
  }, 3000)
}

// 组件挂载
onMounted(async () => {
  // 1. 检查演示模式
  isMockMode.value = checkMockMode()
  
  // 2. 加载基础配置（必须先加载配置）
  await loadDashboardConfig()
  
  console.log('📋 配置加载完成:', {
    show_academy_rank: dashboardConfig.value.show_academy_rank,
    show_gender_ratio: dashboardConfig.value.show_gender_ratio
  })
  
  // 3. 初始化图表实例（空图表）- 根据配置决定是否初始化
  await initLineChart()
  
  if (dashboardConfig.value.show_academy_rank) {
    await initPieChart()
    console.log('✅ 学院排名图表已初始化')
  } else {
    console.log('⏭️ 学院排名图表已跳过')
  }
  
  await initBarChart()
  
  if (dashboardConfig.value.show_gender_ratio) {
    await initGenderPieChart()
    console.log('✅ 男女比例图表已初始化')
  } else {
    console.log('⏭️ 男女比例图表已跳过')
  }
  
  // 4. 数据注入
  if (isMockMode.value) {
    // 演示模式：生成模拟数据
    runMockDataLogic()
    showToast('🎭 当前为演示数据模式')
  } else {
    // 真实模式：从后端加载
    await fetchRealData()
  }
  
  // 5. 监听窗口大小变化
  window.addEventListener('resize', handleResize)
})

// 组件卸载
onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  stopLiveUpdate()
  
  // 安全地销毁图表实例
  try {
    if (lineChart && !lineChart.isDisposed()) {
      lineChart.dispose()
      lineChart = null
    }
  } catch (e) {
    console.warn('销毁折线图失败:', e)
  }
  
  try {
    if (pieChart && !pieChart.isDisposed()) {
      pieChart.dispose()
      pieChart = null
    }
  } catch (e) {
    console.warn('销毁饼图失败:', e)
  }
  
  try {
    if (barChart && !barChart.isDisposed()) {
      barChart.dispose()
      barChart = null
    }
  } catch (e) {
    console.warn('销毁柱状图失败:', e)
  }
  
  try {
    if (genderPieChart && !genderPieChart.isDisposed()) {
      genderPieChart.dispose()
      genderPieChart = null
    }
  } catch (e) {
    console.warn('销毁性别比例图失败:', e)
  }
})

// 暴露方法供外部调用（可选）
defineExpose({
  switchToMockMode: () => {
    isMockMode.value = true
    runMockDataLogic()
  },
  switchToRealMode: () => {
    isMockMode.value = false
    stopLiveUpdate()
    fetchRealData()
  },
  clearCache: clearMockDataCache
})
</script>

<template>
  <div class="space-y-6 animate-in fade-in duration-500">
    <!-- 1. 标题区域 - 使用配置的标题 -->
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-slate-800 tracking-tight">
        {{ dashboardConfig.dashboard_title }}
        <span v-if="isMockMode" class="ml-3 text-sm font-normal text-blue-600 bg-blue-50 px-3 py-1 rounded-full">
          🎭 演示模式
        </span>
      </h1>
      <!-- 滚动公告 -->
      <div class="mt-3 bg-gradient-to-r from-red-50 to-orange-50 border border-red-100 rounded-lg px-4 py-2.5 overflow-hidden">
        <div class="flex items-center gap-2">
          <span class="text-red-600 font-semibold text-sm flex-shrink-0">📢 公告</span>
          <div class="flex-1 overflow-hidden">
            <p class="text-slate-700 text-sm font-medium animate-marquee whitespace-nowrap">
              {{ dashboardConfig.dashboard_notice }}
            </p>
          </div>
        </div>
      </div>
    </div>

    <!-- 2. 顶部指标卡片 -->
    <div class="grid gap-6 md:grid-cols-3">
      <!-- 卡片1：累计活动数量 -->
      <Card class="hover:shadow-lg transition-shadow duration-300 border-l-4 border-l-blue-500">
        <CardContent class="p-6">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-slate-500">累计活动数量</p>
              <div class="mt-2 flex items-baseline gap-2">
                <span class="text-3xl font-bold text-slate-800">{{ metrics.totalActivities }}</span>
                <span class="text-xs text-green-600 font-medium">+12%</span>
              </div>
            </div>
            <div class="p-3 bg-blue-50 rounded-xl">
              <Activity class="w-6 h-6 text-blue-600" />
            </div>
          </div>
        </CardContent>
      </Card>

      <!-- 卡片2：活跃志愿者 -->
      <Card class="hover:shadow-lg transition-shadow duration-300 border-l-4 border-l-purple-500">
        <CardContent class="p-6">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-slate-500">活跃志愿者</p>
              <div class="mt-2 flex items-baseline gap-2">
                <span class="text-3xl font-bold text-slate-800">{{ metrics.activeVolunteers }}</span>
                <span class="relative flex h-2 w-2">
                  <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-green-400 opacity-75"></span>
                  <span class="relative inline-flex rounded-full h-2 w-2 bg-green-500"></span>
                </span>
              </div>
            </div>
            <div class="p-3 bg-purple-50 rounded-xl">
              <Users class="w-6 h-6 text-purple-600" />
            </div>
          </div>
        </CardContent>
      </Card>

      <!-- 卡片3：累计活动时长 - 显示目标进度 -->
      <Card class="hover:shadow-lg transition-shadow duration-300 border-l-4 border-l-emerald-500">
        <CardContent class="p-6">
          <div class="flex items-center justify-between">
            <div class="flex-1">
              <p class="text-sm font-medium text-slate-500">累计活动时长</p>
              <div class="mt-2 flex items-baseline gap-2">
                <span class="text-3xl font-bold text-slate-800">{{ (metrics.totalHours / 1000).toFixed(1) }}k</span>
                <span class="text-sm text-slate-400">/ {{ (dashboardConfig.goal_total_hours / 1000).toFixed(1) }}k 小时</span>
              </div>
              <!-- 进度条 -->
              <div class="mt-3 w-full bg-slate-200 rounded-full h-2">
                <div 
                  class="bg-gradient-to-r from-emerald-500 to-green-500 h-2 rounded-full transition-all duration-500"
                  :style="{ width: Math.min((metrics.totalHours / dashboardConfig.goal_total_hours) * 100, 100) + '%' }"
                ></div>
              </div>
              <p class="text-xs text-slate-500 mt-1">
                目标完成度: {{ ((metrics.totalHours / dashboardConfig.goal_total_hours) * 100).toFixed(1) }}%
              </p>
            </div>
            <div class="p-3 bg-emerald-50 rounded-xl ml-4">
              <Clock class="w-6 h-6 text-emerald-600" />
            </div>
          </div>
        </CardContent>
      </Card>
    </div>

    <!-- 3. 中间趋势分析区域 -->
    <div class="grid gap-6 md:grid-cols-12">
      <!-- 左侧卡片 - 根据配置显示/隐藏 -->
      <Card
        v-if="dashboardConfig.show_academy_rank"
        class="md:col-span-5 lg:col-span-4 hover:shadow-lg transition-shadow duration-300 flex flex-col"
      >
        <CardContent class="p-6 flex-1 flex flex-col">
          <div class="flex items-center gap-2 h-[28px] mb-4">
            <PieChart class="w-5 h-5 text-purple-600" />
            <h3 class="text-lg font-semibold text-slate-800">各学院参与度占比</h3>
          </div>
          <div class="relative w-full h-[300px]">
            <div ref="pieChartRef" class="absolute inset-0"></div>
          </div>
        </CardContent>
      </Card>

      <!-- 右侧卡片 - 根据配置调整宽度 -->
      <Card
        :class="dashboardConfig.show_academy_rank ? 'hover:shadow-lg transition-shadow duration-300 flex flex-col md:col-span-7 lg:col-span-8' : 'hover:shadow-lg transition-shadow duration-300 flex flex-col md:col-span-12'"
      >
        <CardContent class="p-6 flex-1 flex flex-col">
          <div class="flex items-center gap-2 h-[28px] mb-4">
            <TrendingUp class="w-5 h-5 text-blue-600" />
            <h3 class="text-lg font-semibold text-slate-800">近半年活动趋势</h3>
          </div>
          <div ref="lineChartRef" class="w-full h-[300px]"></div>
        </CardContent>
      </Card>
    </div>

    <!-- 4. 底部分析卡片：活动参与率 + 男女比例 - 使用与上面相同的列宽比例 -->
    <div class="grid gap-6 md:grid-cols-12">
      <!-- 活动参与率卡片 - 与"近半年活动趋势"宽度对齐 -->
      <Card 
        :class="dashboardConfig.show_gender_ratio ? 'hover:shadow-lg transition-shadow duration-300 md:col-span-7 lg:col-span-8' : 'hover:shadow-lg transition-shadow duration-300 md:col-span-12'"
      >
        <CardContent class="p-6">
          <div class="flex items-center justify-between h-[52px] mb-4">
            <div class="flex items-center gap-2">
              <BarChart class="w-5 h-5 text-indigo-600" />
              <h3 class="text-lg font-semibold text-slate-800">活动参与率</h3>
            </div>
            <div class="flex items-center gap-2">
              <button
                class="px-3 py-1 text-xs rounded border"
                :class="participationRange === '3m' ? 'border-purple-500 text-purple-600 bg-purple-50' : 'border-slate-200 text-slate-600'"
                @click="changeParticipationRange('3m')"
              >
                最近三个月
              </button>
              <button
                class="px-3 py-1 text-xs rounded border"
                :class="participationRange === '6m' ? 'border-purple-500 text-purple-600 bg-purple-50' : 'border-slate-200 text-slate-600'"
                @click="changeParticipationRange('6m')"
              >
                最近六个月
              </button>
            </div>
          </div>
          <div ref="barChartRef" class="w-full h-[300px]"></div>
        </CardContent>
      </Card>

      <!-- 男女参与比例卡片 - 与"各学院参与度占比"宽度对齐 -->
      <Card
        v-if="dashboardConfig.show_gender_ratio"
        class="md:col-span-5 lg:col-span-4 hover:shadow-lg transition-shadow duration-300"
      >
        <CardContent class="p-6">
          <div class="flex items-center gap-2 h-[28px] mb-4">
            <PieChart class="w-5 h-5 text-indigo-500" />
            <h3 class="text-lg font-semibold text-slate-800">男女参与比例</h3>
          </div>
          <div class="relative w-full h-[300px]">
            <div ref="genderPieRef" class="absolute inset-0"></div>
          </div>
        </CardContent>
      </Card>
    </div>
  </div>
</template>

<style scoped>
/* 跑马灯动画 */
@keyframes marquee {
  0% {
    transform: translateX(0);
  }
  100% {
    transform: translateX(-100%);
  }
}

.animate-marquee {
  display: inline-block;
  padding-left: 100%;
  animation: marquee 20s linear infinite;
}

.animate-marquee:hover {
  animation-play-state: paused;
}

/* Toast 动画 */
@keyframes slideIn {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

@keyframes slideOut {
  from {
    transform: translateX(0);
    opacity: 1;
  }
  to {
    transform: translateX(100%);
    opacity: 0;
  }
}
</style>
