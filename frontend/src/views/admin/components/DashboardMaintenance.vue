<script setup>
import { ref, onMounted, computed, onUnmounted } from 'vue'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { Settings, Save, RefreshCw, Eye, AlertCircle, Sparkles } from 'lucide-vue-next'
import { getConfigList, batchUpdateConfigs } from '@/api/admin'

// 配置数据
const configs = ref([])
const loading = ref(false)
const saving = ref(false)
const generating = ref(false)
const message = ref({ type: '', text: '' })

// --- 新增：演示模式控制逻辑 ---
// 初始化时读取 localStorage
const isDemoModeGlobal = ref(localStorage.getItem('DASHBOARD_MODE') === 'demo')

// 切换演示模式
const toggleGlobalDemoMode = () => {
  if (isDemoModeGlobal.value) {
    localStorage.setItem('DASHBOARD_MODE', 'demo')
    // 开启时，顺便清除旧的缓存，确保持久化的是新数据
    sessionStorage.removeItem('DASHBOARD_MOCK_DATA')
    showMessage('success', '✨ 演示模式已开启！进入大屏将展示随机数据')
  } else {
    localStorage.removeItem('DASHBOARD_MODE')
    sessionStorage.removeItem('DASHBOARD_MOCK_DATA')
    showMessage('info', '演示模式已关闭，恢复真实数据')
  }
}
// ----------------------------

// 表单数据
const formData = ref({
  dashboard_title: '',
  dashboard_notice: '',
  goal_total_hours: '',
  show_academy_rank: true,
  show_gender_ratio: true
})

// 动态预览数据
const previewData = ref({
  currentHours: 3250, // 当前工时
  activityTrend: [
    { month: '10月', value: 18, height: 60 },
    { month: '11月', value: 22, height: 70 },
    { month: '12月', value: 20, height: 65 }
  ],
  academyRank: [
    { name: '语言文化学院', value: 95 },
    { name: '国商学院', value: 88 },
    { name: '教育学院', value: 76 }
  ]
})

const POINT_SPACING = 100
const BASE_Y = 120

const pointX = (index) => index * POINT_SPACING + 50
const pointY = (height) => BASE_Y - height * 1.2

const previewLineRef = ref(null)
let previewLineChart = null

// 实时预览数据（与formData同步）
const previewConfig = computed(() => ({
  title: formData.value.dashboard_title || '志愿活动数据可视化大屏',
  notice: formData.value.dashboard_notice || '欢迎各位领导莅临指导',
  goalHours: parseInt(formData.value.goal_total_hours) || 5000,
  showAcademyRank: formData.value.show_academy_rank,
  showGenderRatio: formData.value.show_gender_ratio
}))

// 渲染近期活动趋势折线图（复用大屏风格，3个月数据，平滑）
const renderPreviewLine = async () => {
  if (!previewLineRef.value) return
  const echarts = await import('echarts')
  if (!previewLineChart) {
    previewLineChart = echarts.init(previewLineRef.value)
  }
  const months = previewData.value.activityTrend.map(i => i.month)
  const values = previewData.value.activityTrend.map(i => i.value)
  const maxVal = Math.max(...values, 1)
  const paddedMax = Math.ceil(maxVal / 0.8) // 确保最高点不超过80%

  previewLineChart.setOption({
    tooltip: { trigger: 'axis' },
    grid: { left: '6%', right: '4%', top: '8%', bottom: '12%', containLabel: true },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: months,
      axisLine: { lineStyle: { color: 'rgba(255,255,255,0.3)' } },
      axisLabel: { color: 'rgba(255,255,255,0.7)' }
    },
    yAxis: {
      type: 'value',
      max: paddedMax,
      splitLine: { lineStyle: { color: 'rgba(255,255,255,0.08)' } },
      axisLabel: { color: 'rgba(255,255,255,0.6)' }
    },
    series: [
      {
        name: '活动数量',
        type: 'line',
        smooth: true,
        data: values,
        symbolSize: 8,
        lineStyle: { width: 3, color: '#ef4444' },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(239,68,68,0.35)' },
            { offset: 1, color: 'rgba(239,68,68,0)' }
          ])
        }
      }
    ]
  })
}

// 生成随机预览数据
const generateRandomPreviewData = () => {
  // 随机生成当前工时 (2000-4500)
  previewData.value.currentHours = Math.floor(Math.random() * 2500) + 2000
  
  // 随机生成活动趋势数据（近3个月，值更小）
  const months = ['10月', '11月', '12月']
  let maxValue = 0
  const trendData = months.map(month => {
    const value = Math.floor(Math.random() * 15) + 10 // 10-24之间
    if (value > maxValue) maxValue = value
    return { month, value, height: 0 }
  })

  // 计算高度百分比（基于最大值），确保最小高度为20%
  trendData.forEach(item => {
    const calculatedHeight = Math.round((item.value / maxValue) * 100)
    item.height = Math.max(calculatedHeight, 20)
  })

  previewData.value.activityTrend = trendData
  
  // 随机生成学院排名数据
  const academies = [
    '语言文化学院', '国商学院', '教育学院',
    '文化和旅游学院', '艺术学院', '马克思主义学院'
  ]
  
  // 随机选择3个学院
  const shuffled = [...academies].sort(() => Math.random() - 0.5)
  const selected = shuffled.slice(0, 3)
  
  // 生成随机分数并排序
  const rankData = selected.map(name => ({
    name,
    value: Math.floor(Math.random() * 30) + 70 // 70-100之间
  })).sort((a, b) => b.value - a.value)
  
  previewData.value.academyRank = rankData
}

// 显示消息提示（1.5秒后自动消失）
const showMessage = (type, text) => {
  message.value = { type, text }
  setTimeout(() => {
    message.value = { type: '', text: '' }
  }, 1500)
}

// 加载配置数据
const loadConfigs = async () => {
  loading.value = true
  message.value = { type: '', text: '' }
  
  try {
    const response = await getConfigList()
    if (response.data.code === 200) {
      configs.value = response.data.data
      
      // 填充表单数据
      configs.value.forEach(config => {
        if (config.configKey in formData.value) {
          // 处理布尔值
          if (config.configKey.startsWith('show_')) {
            formData.value[config.configKey] = config.configValue === 'true'
          } else {
            formData.value[config.configKey] = config.configValue
          }
        }
      })
      
      // 配置加载成功，不显示提示消息
    } else {
      showMessage('error', response.data.message || '加载配置失败')
    }
  } catch (error) {
    console.error('加载配置失败:', error)
    showMessage('error', '加载配置失败: ' + (error.message || '网络错误'))
  } finally {
    loading.value = false
  }
}

// 保存配置
const saveConfigs = async () => {
  saving.value = true
  message.value = { type: '', text: '' }
  
  try {
    // 构建配置Map
    const configMap = {}
    Object.keys(formData.value).forEach(key => {
      const value = formData.value[key]
      // 布尔值转字符串
      configMap[key] = typeof value === 'boolean' ? value.toString() : value.toString()
    })
    
    const response = await batchUpdateConfigs(configMap)
    if (response.data.code === 200) {
      showMessage('success', '配置保存成功！')
      // 重新加载配置（不显示加载成功消息）
      loading.value = true
      try {
        const reloadResponse = await getConfigList()
        if (reloadResponse.data.code === 200) {
          configs.value = reloadResponse.data.data
        }
      } catch (error) {
        console.error('重新加载配置失败:', error)
      } finally {
        loading.value = false
      }
    } else {
      showMessage('error', response.data.message || '保存配置失败')
    }
  } catch (error) {
    console.error('保存配置失败:', error)
    showMessage('error', '保存配置失败: ' + (error.message || '网络错误'))
  } finally {
    saving.value = false
  }
}

// 重置表单
const resetForm = () => {
  loadConfigs()
  showMessage('info', '表单已重置')
}

// 预览大屏
const previewDashboard = () => {
  // 在新窗口打开大屏
  window.open('/admin/dashboard', '_blank')
}

// 生成模拟数据（纯前端，每次点击自动清除旧数据并生成新数据）
const handleGenerateMockData = () => {
  generating.value = true
  
  // 生成随机预览数据（自动替换旧数据）
  generateRandomPreviewData()
  
  setTimeout(() => {
    generating.value = false
  }, 300) // 短暂延迟以显示加载状态

  // 刷新曲线
  renderPreviewLine()
}

// 组件挂载时加载配置
onMounted(() => {
  loadConfigs()
  renderPreviewLine()
})

onUnmounted(() => {
  if (previewLineChart) {
    try {
      previewLineChart.dispose()
    } catch {}
  }
})
</script>

<template>
  <div class="dashboard-maintenance-container">
    <!-- 标题 -->
    <div class="mb-6">
      <h1 class="text-3xl font-bold text-slate-800 tracking-tight">数据可视化大屏维护</h1>
      <p class="text-slate-500 mt-2 text-sm font-medium">配置和维护数据可视化大屏的展示内容，右侧可实时预览效果</p>
    </div>

    <!-- 消息提示 - 固定在页面顶部 -->
    <transition
      enter-active-class="transition ease-out duration-300"
      enter-from-class="opacity-0 transform -translate-y-full"
      enter-to-class="opacity-100 transform translate-y-0"
      leave-active-class="transition ease-in duration-200"
      leave-from-class="opacity-100 transform translate-y-0"
      leave-to-class="opacity-0 transform -translate-y-full"
    >
      <div v-if="message.text"
           :class="[
             'fixed top-4 left-1/2 transform -translate-x-1/2 z-50 p-4 rounded-lg border flex items-center gap-3 shadow-lg min-w-[400px] max-w-[600px]',
             message.type === 'success' ? 'bg-green-50 border-green-200 text-green-800' : '',
             message.type === 'error' ? 'bg-red-50 border-red-200 text-red-800' : '',
             message.type === 'info' ? 'bg-blue-50 border-blue-200 text-blue-800' : ''
           ]">
        <AlertCircle class="w-5 h-5 flex-shrink-0" />
        <p class="text-sm font-medium">{{ message.text }}</p>
      </div>
    </transition>

    <!-- 左右分栏布局 -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <!-- 左侧：配置表单 -->
      <div class="space-y-6">
        <!-- 基础设置 -->
        <Card class="border-slate-200 shadow-sm">
          <CardHeader class="border-b border-slate-100 bg-slate-50/50">
            <CardTitle class="flex items-center gap-2 text-slate-700">
              <Settings class="w-5 h-5 text-red-600" />
              基础设置
            </CardTitle>
          </CardHeader>
          <CardContent class="p-6 space-y-6">
            <!-- 大屏标题 -->
            <div class="space-y-2">
              <label class="text-sm font-medium text-slate-700">
                大屏主标题
                <span class="text-slate-400 font-normal ml-2">（显示在大屏顶部）</span>
              </label>
              <Input 
                v-model="formData.dashboard_title"
                placeholder="请输入大屏主标题"
                class="w-full"
              />
            </div>

            <!-- 滚动公告 -->
            <div class="space-y-2">
              <label class="text-sm font-medium text-slate-700">
                大屏滚动公告
                <span class="text-slate-400 font-normal ml-2">（跑马灯文字）</span>
              </label>
              <Input 
                v-model="formData.dashboard_notice"
                placeholder="请输入滚动公告内容"
                class="w-full"
              />
            </div>

            <!-- 目标工时 -->
            <div class="space-y-2">
              <label class="text-sm font-medium text-slate-700">
                学期目标工时
                <span class="text-slate-400 font-normal ml-2">（用于进度条展示）</span>
              </label>
              <Input 
                v-model="formData.goal_total_hours"
                type="number"
                placeholder="请输入目标工时"
                class="w-full"
              />
            </div>
          </CardContent>
        </Card>

        <!-- 显示开关 -->
        <Card class="border-slate-200 shadow-sm">
          <CardHeader class="border-b border-slate-100 bg-slate-50/50">
            <CardTitle class="flex items-center gap-2 text-slate-700">
              <Eye class="w-5 h-5 text-red-600" />
              显示开关控制
            </CardTitle>
          </CardHeader>
          <CardContent class="p-6 space-y-4">
            
            <!-- 演示模式总开关 -->
            <div class="flex items-center justify-between p-4 bg-blue-50 border border-blue-100 rounded-lg mb-6">
              <div>
                <div class="flex items-center gap-2">
                  <Sparkles class="w-4 h-4 text-blue-600" />
                  <p class="font-bold text-blue-800">启用演示/答辩模式</p>
                </div>
                <p class="text-xs text-blue-600 mt-1">开启后，大屏将忽略后端数据，使用自动生成的随机仿真数据</p>
              </div>
              <label class="relative inline-flex items-center cursor-pointer">
                <input
                  type="checkbox"
                  v-model="isDemoModeGlobal"
                  @change="toggleGlobalDemoMode"
                  class="sr-only peer"
                >
                <div class="w-11 h-6 bg-slate-300 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
              </label>
            </div>

            <p class="text-sm text-slate-500 mb-4">控制大屏上各个图表模块的显示/隐藏</p>
            
            <!-- 学院排名开关 -->
            <div class="flex items-center justify-between p-4 bg-slate-50 rounded-lg">
              <div>
                <p class="font-medium text-slate-700">显示学院排名</p>
                <p class="text-sm text-slate-500 mt-1">控制学院活跃度排行榜的显示</p>
              </div>
              <label class="relative inline-flex items-center cursor-pointer">
                <input 
                  type="checkbox" 
                  v-model="formData.show_academy_rank"
                  class="sr-only peer"
                >
                <div class="w-11 h-6 bg-slate-300 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-red-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-red-600"></div>
              </label>
            </div>

            <!-- 男女参与比例开关 -->
            <div class="flex items-center justify-between p-4 bg-slate-50 rounded-lg">
              <div>
                <p class="font-medium text-slate-700">显示男女参与比例</p>
                <p class="text-sm text-slate-500 mt-1">控制男女参与比例环形图显示</p>
              </div>
              <label class="relative inline-flex items-center cursor-pointer">
                <input 
                  type="checkbox" 
                  v-model="formData.show_gender_ratio"
                  class="sr-only peer"
                >
                <div class="w-11 h-6 bg-slate-300 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-red-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-red-600"></div>
              </label>
            </div>
          </CardContent>
        </Card>

        <!-- 操作按钮 -->
        <div class="flex flex-wrap items-center gap-3">
          <Button 
            @click="saveConfigs"
            :disabled="saving || loading"
            class="bg-red-600 hover:bg-red-700 text-white"
          >
            <Save class="w-4 h-4 mr-2" />
            {{ saving ? '保存中...' : '保存配置' }}
          </Button>

          <Button 
            @click="resetForm"
            :disabled="saving || loading"
            variant="outline"
            class="border-slate-300 text-slate-700 hover:bg-slate-50"
          >
            <RefreshCw class="w-4 h-4 mr-2" />
            重置
          </Button>

          <Button 
            @click="previewDashboard"
            variant="outline"
            class="border-red-300 text-red-600 hover:bg-red-50"
          >
            <Eye class="w-4 h-4 mr-2" />
            预览大屏
          </Button>

        </div>

        <!-- 配置列表（调试用） -->
        <Card v-if="configs.length > 0" class="border-slate-200 shadow-sm">
          <CardHeader class="border-b border-slate-100 bg-slate-50/50">
            <CardTitle class="text-slate-700 text-sm">
              当前配置详情（调试信息）
            </CardTitle>
          </CardHeader>
          <CardContent class="p-6">
            <div class="overflow-x-auto">
              <table class="w-full text-sm">
                <thead class="bg-slate-50 border-b border-slate-200">
                  <tr>
                    <th class="px-4 py-2 text-left font-medium text-slate-700">配置键</th>
                    <th class="px-4 py-2 text-left font-medium text-slate-700">配置名称</th>
                    <th class="px-4 py-2 text-left font-medium text-slate-700">当前值</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="config in configs" :key="config.configId" class="border-b border-slate-100">
                    <td class="px-4 py-3 font-mono text-xs text-slate-600">{{ config.configKey }}</td>
                    <td class="px-4 py-3 text-slate-700">{{ config.configName }}</td>
                    <td class="px-4 py-3 font-medium text-slate-900">{{ config.configValue }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </CardContent>
        </Card>
      </div>

      <!-- 右侧：实时预览 -->
      <div class="space-y-6">
        <Card class="border-slate-200 shadow-sm sticky top-6">
          <CardHeader class="border-b border-slate-100 bg-gradient-to-r from-red-50 to-orange-50">
            <CardTitle class="flex items-center gap-2 text-slate-700">
              <Eye class="w-5 h-5 text-red-600" />
              实时预览
              <span class="ml-auto text-xs font-normal text-slate-500">修改左侧配置即可实时查看效果</span>
            </CardTitle>
          </CardHeader>
          <CardContent class="p-6">
            <!-- 缩小版大屏预览 -->
            <div class="preview-container bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 rounded-lg p-6 text-white shadow-2xl">
              <!-- 大屏标题 -->
              <div class="text-center mb-6">
                <h2 class="text-2xl font-bold bg-gradient-to-r from-red-400 to-orange-400 bg-clip-text text-transparent">
                  {{ previewConfig.title }}
                </h2>
              </div>

              <!-- 滚动公告 -->
              <div class="bg-slate-800/50 rounded-lg p-3 mb-6 overflow-hidden">
                <div class="flex items-center gap-2">
                  <span class="text-red-400 text-sm font-medium flex-shrink-0">📢 公告</span>
                  <div class="flex-1 overflow-hidden">
                    <div class="animate-marquee whitespace-nowrap text-sm text-slate-300">
                      {{ previewConfig.notice }}
                    </div>
                  </div>
                </div>
              </div>

              <!-- 近期活动趋势曲线图（复用大屏风格，echarts） -->
              <div class="bg-slate-800/50 rounded-lg p-4 mb-6">
                <div class="text-sm font-medium mb-3 text-slate-300 flex items-center justify-between">
                  <span>近期活动趋势</span>
                  <Button size="sm" variant="outline" class="text-xs gap-2" :disabled="generating" @click="handleGenerateMockData">
                    <RefreshCw class="w-4 h-4" />
                    刷新模拟数据
                  </Button>
                </div>
                <div class="relative h-48">
                  <div ref="previewLineRef" class="w-full h-full"></div>
                </div>
              </div>

              <!-- 目标工时进度 -->
              <div class="bg-slate-800/50 rounded-lg p-4 mb-6">
                <div class="flex justify-between items-center mb-2">
                  <span class="text-sm text-slate-300">学期目标工时</span>
                  <span class="text-sm font-medium">{{ previewData.currentHours.toLocaleString() }} / {{ previewConfig.goalHours.toLocaleString() }}</span>
                </div>
                <div class="w-full bg-slate-700 rounded-full h-2">
                  <div
                    class="bg-gradient-to-r from-red-500 to-orange-500 h-2 rounded-full transition-all duration-500"
                    :style="{ width: `${Math.min((previewData.currentHours / previewConfig.goalHours) * 100, 100)}%` }"
                  ></div>
                </div>
                <div class="text-xs text-slate-400 mt-1 text-right">
                  完成度: {{ Math.round((previewData.currentHours / previewConfig.goalHours) * 100) }}%
                </div>
              </div>

              <!-- 学院排名（根据开关显示） -->
              <div v-if="previewConfig.showAcademyRank" class="bg-slate-800/50 rounded-lg p-4 mb-4">
                <div class="text-sm font-medium mb-3 text-slate-300">学院活跃度排行</div>
                <div class="space-y-2">
                  <div v-for="(item, index) in previewData.academyRank"
                       :key="index"
                       class="flex items-center gap-2">
                    <span class="text-xs text-slate-400 w-4">{{ index + 1 }}</span>
                    <span class="text-xs text-slate-300 flex-1">{{ item.name }}</span>
                    <div class="flex-1 bg-slate-700 rounded-full h-1.5">
                      <div
                        class="bg-gradient-to-r from-red-500 to-orange-500 h-1.5 rounded-full transition-all duration-500"
                        :style="{ width: `${item.value}%` }"
                      ></div>
                    </div>
                    <span class="text-xs font-medium text-red-400">{{ item.value }}%</span>
                  </div>
                </div>
              </div>
              <div v-else class="bg-slate-800/50 rounded-lg p-4 text-center text-slate-500 text-sm mb-4">
                学院排名已隐藏
              </div>

              <!-- 男女参与比例（根据开关显示） -->
              <div v-if="previewConfig.showGenderRatio" class="bg-slate-800/50 rounded-lg p-4">
                <div class="text-sm font-medium mb-3 text-slate-300">男女参与比例</div>
                <div class="flex items-center justify-center gap-8">
                  <div class="text-center">
                    <div class="text-3xl font-bold text-blue-400">58%</div>
                    <div class="text-xs text-slate-400 mt-1">男生</div>
                  </div>
                  <div class="text-slate-600 text-2xl">|</div>
                  <div class="text-center">
                    <div class="text-3xl font-bold text-pink-400">42%</div>
                    <div class="text-xs text-slate-400 mt-1">女生</div>
                  </div>
                </div>
              </div>
              <div v-else class="bg-slate-800/50 rounded-lg p-4 text-center text-slate-500 text-sm">
                男女参与比例已隐藏
              </div>

              <!-- 提示信息 -->
              <div class="mt-6 text-center text-xs text-slate-500">
                这是实时预览，修改左侧配置即可看到效果变化
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  </div>
</template>

<style scoped>
.dashboard-maintenance-container {
  max-width: 1600px;
  margin: 0 auto;
  padding: 2rem;
}

.preview-container {
  min-height: 600px;
}

@keyframes marquee {
  0% {
    transform: translateX(100%);
  }
  100% {
    transform: translateX(-100%);
  }
}

.animate-marquee {
  animation: marquee 15s linear infinite;
}

.animate-marquee:hover {
  animation-play-state: paused;
}

/* 响应式调整 */
@media (max-width: 1024px) {
  .dashboard-maintenance-container {
    padding: 1rem;
  }
  
  .preview-container {
    min-height: 400px;
  }
}
</style>