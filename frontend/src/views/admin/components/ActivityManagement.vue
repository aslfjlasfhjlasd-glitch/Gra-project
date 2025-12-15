<script setup>
import { ref, onMounted } from 'vue'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import Button from '@/components/ui/button/button.vue'
import { Calendar, MapPin, Users, AlertCircle, Upload, Archive, Eye, X, Tag, Briefcase, Shield } from 'lucide-vue-next'
import axios from 'axios'

const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'

const activities = ref([])
const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')
const showDetailModal = ref(false)
const selectedActivity = ref(null)
let messageTimer = null

// 显示消息并自动隐藏
const showMessage = (type, message) => {
  if (messageTimer) {
    clearTimeout(messageTimer)
  }
  
  if (type === 'success') {
    successMessage.value = message
    errorMessage.value = ''
  } else {
    errorMessage.value = message
    successMessage.value = ''
  }
  
  messageTimer = setTimeout(() => {
    successMessage.value = ''
    errorMessage.value = ''
  }, 2000)
}

// 获取所有活动列表（管理员可以看到所有活动）
const fetchActivities = async () => {
  loading.value = true
  errorMessage.value = ''

  try {
    const response = await axios.get(`${API_BASE}/api/admin/activities`)
    if (response.data.code === 200) {
      activities.value = response.data.data || []
    } else {
      errorMessage.value = response.data.message || '获取活动列表失败'
    }
  } catch (error) {
    console.error('获取活动列表失败:', error)
    errorMessage.value = '网络错误，请稍后重试'
  } finally {
    loading.value = false
  }
}

// 根据独立时间字段计算活动状态
const computeStatus = (item) => {
  // 获取北京时间（UTC+8）
  const now = new Date()
  const bjNow = new Date(now.getTime() + (8 * 60 * 60 * 1000))
  
  // 解析时间字段（假设后端返回的是 ISO 8601 格式或时间戳）
  const bmKssj = new Date(item.bmKssj)
  const bmJssj = new Date(item.bmJssj)
  const hdKssj = new Date(item.hdKssj)
  const hdJssj = new Date(item.hdJssj)
  
  // 根据时间判断状态
  if (bjNow < bmKssj) {
    return '报名未开始'
  } else if (bjNow >= bmKssj && bjNow <= bmJssj) {
    return '活动报名中'
  } else if (bjNow > bmJssj && bjNow < hdKssj) {
    return '活动未开始'
  } else if (bjNow >= hdKssj && bjNow <= hdJssj) {
    return '活动进行中'
  } else {
    return '活动已结束'
  }
}

// 计算活动状态的显示样式
const getStatusClass = (status) => {
  const statusMap = {
    '报名未开始': 'bg-slate-100 text-slate-700',
    '活动报名中': 'bg-blue-100 text-blue-700',
    '活动未开始': 'bg-yellow-100 text-yellow-700',
    '活动进行中': 'bg-green-100 text-green-700',
    '活动已结束': 'bg-slate-100 text-slate-500'
  }
  return statusMap[status] || 'bg-slate-100 text-slate-700'
}

// 计算发布状态的显示样式
const getPublishStatusClass = (status) => {
  const statusMap = {
    '待申报': 'bg-yellow-100 text-yellow-700',
    '待发布': 'bg-blue-100 text-blue-700',
    '已发布': 'bg-green-100 text-green-700',
    '已下架': 'bg-slate-100 text-slate-500'
  }
  return statusMap[status] || 'bg-slate-100 text-slate-700'
}

// 计算报名进度百分比
const getProgressPercentage = (current, max) => {
  if (!max || max === 0) return 0
  const percentage = (current / max) * 100
  return Math.min(percentage, 100)
}

// 发布活动
const publishActivity = async (activity) => {
  if (!confirm(`确定要发布活动"${activity.hdMc}"吗？发布后学生将可以看到并报名此活动。`)) {
    return
  }

  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''

  try {
    const response = await axios.put(`${API_BASE}/api/admin/activity/${activity.hdBh}/publish`)
    
    if (response.data.code === 200) {
      showMessage('success', '活动已发布')
      await fetchActivities()
    } else {
      showMessage('error', response.data.message || '发布失败')
    }
  } catch (error) {
    console.error('发布活动失败:', error)
    showMessage('error', '网络错误，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 下架活动
const unpublishActivity = async (activity) => {
  if (!confirm(`确定要下架活动"${activity.hdMc}"吗？下架后学生将无法看到此活动。`)) {
    return
  }

  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''

  try {
    const response = await axios.put(`${API_BASE}/api/admin/activity/${activity.hdBh}/unpublish`)
    
    if (response.data.code === 200) {
      showMessage('success', '活动已下架')
      await fetchActivities()
    } else {
      showMessage('error', response.data.message || '下架失败')
    }
  } catch (error) {
    console.error('下架活动失败:', error)
    showMessage('error', '网络错误，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 判断是否可以发布（待发布、已下架的活动可以发布）
const canPublish = (activity) => {
  return activity.fbZt === '待发布' || activity.fbZt === '已下架'
}

// 判断是否可以下架（只有已发布的活动可以下架）
const canUnpublish = (activity) => {
  return activity.fbZt === '已发布'
}

// 获取按钮文本（根据状态显示不同文本）
const getPublishButtonText = (activity) => {
  return '发布活动'
}

// 获取下架按钮文本
const getUnpublishButtonText = () => {
  return '下架'
}

// 查看活动详情
const viewActivityDetail = (activity) => {
  selectedActivity.value = activity
  showDetailModal.value = true
}

// 关闭详情弹窗
const closeDetailModal = () => {
  showDetailModal.value = false
  selectedActivity.value = null
}

onMounted(() => {
  fetchActivities()
})
</script>

<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <div>
        <h2 class="text-2xl font-bold text-slate-900">志愿活动设计</h2>
        <p class="text-sm text-slate-500 mt-1">管理所有志愿活动的发布和下架</p>
      </div>
    </div>

    <!-- 成功提示 -->
    <div v-if="successMessage" class="bg-green-50 border border-green-200 rounded-lg p-4 flex items-start gap-3">
      <AlertCircle class="w-5 h-5 text-green-600 flex-shrink-0 mt-0.5" />
      <div class="flex-1">
        <p class="text-sm font-medium text-green-800">{{ successMessage }}</p>
      </div>
    </div>

    <!-- 错误提示 -->
    <div v-if="errorMessage" class="bg-red-50 border border-red-200 rounded-lg p-4 flex items-start gap-3">
      <AlertCircle class="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
      <div class="flex-1">
        <p class="text-sm font-medium text-red-800">{{ errorMessage }}</p>
      </div>
    </div>

    <Card>
      <CardHeader>
        <CardTitle>活动列表</CardTitle>
      </CardHeader>
      <CardContent>
        <div v-if="loading" class="text-center py-12 text-slate-500">
          加载中...
        </div>
        <div v-else-if="activities.length === 0" class="text-center py-12 text-slate-400">
          <p class="text-lg mb-2">暂无活动</p>
          <p class="text-sm">等待负责人创建和申报活动</p>
        </div>
        <div v-else class="space-y-4">
          <div v-for="activity in activities" :key="activity.hdBh" 
               class="border border-slate-200 rounded-lg hover:shadow-md transition-all duration-200">
            <div class="p-5">
              <div class="flex items-start justify-between mb-4">
                <div class="flex-1">
                  <div class="flex items-center gap-3 mb-2">
                    <h3 class="font-semibold text-lg text-slate-900">{{ activity.hdMc }}</h3>
                    <span :class="['px-3 py-1 rounded-full text-xs font-medium', getStatusClass(computeStatus(activity))]">
                      {{ computeStatus(activity) }}
                    </span>
                    <span :class="['px-3 py-1 rounded-full text-xs font-medium', getPublishStatusClass(activity.fbZt)]">
                      {{ activity.fbZt || '待申报' }}
                    </span>
                  </div>
                  <p class="text-sm text-slate-600 mb-2">{{ activity.hdNr || '暂无描述' }}</p>
                  <p class="text-xs text-slate-500">发起单位：{{ activity.hdFqDw || '-' }}</p>
                </div>
                <div class="flex gap-2 ml-4">
                  <!-- 发布/下架切换按钮 -->
                  <Button
                    v-if="canPublish(activity)"
                    variant="outline"
                    size="sm"
                    class="gap-2 text-green-600 hover:text-green-700 hover:border-green-300"
                    :disabled="loading"
                    @click="publishActivity(activity)"
                  >
                    <Upload class="w-4 h-4" />
                    {{ getPublishButtonText(activity) }}
                  </Button>
                  <Button
                    v-else-if="canUnpublish(activity)"
                    variant="outline"
                    size="sm"
                    class="gap-2 text-orange-600 hover:text-orange-700 hover:border-orange-300"
                    :disabled="loading"
                    @click="unpublishActivity(activity)"
                  >
                    <Archive class="w-4 h-4" />
                    {{ getUnpublishButtonText() }}
                  </Button>
                  <!-- 查看详情按钮 -->
                  <Button
                    variant="outline"
                    size="sm"
                    class="gap-2"
                    :disabled="loading"
                    @click="viewActivityDetail(activity)"
                  >
                    <Eye class="w-4 h-4" />
                    详情
                  </Button>
                </div>
              </div>

              <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                <div class="flex items-center gap-2 text-sm text-slate-600">
                  <Calendar class="w-4 h-4 text-slate-400" />
                  <div>
                    <p class="text-xs text-slate-500">报名时间</p>
                    <p class="font-medium">{{ activity.bmSj || '-' }}</p>
                  </div>
                </div>
                <div class="flex items-center gap-2 text-sm text-slate-600">
                  <Calendar class="w-4 h-4 text-slate-400" />
                  <div>
                    <p class="text-xs text-slate-500">活动时间</p>
                    <p class="font-medium">{{ activity.hdSj || '-' }}</p>
                  </div>
                </div>
                <div class="flex items-center gap-2 text-sm text-slate-600">
                  <MapPin class="w-4 h-4 text-slate-400" />
                  <div>
                    <p class="text-xs text-slate-500">活动地点</p>
                    <p class="font-medium">{{ activity.hdDd || '-' }}</p>
                  </div>
                </div>
              </div>

              <div class="flex items-center gap-4">
                <div class="flex items-center gap-2 text-sm">
                  <Users class="w-4 h-4 text-slate-400" />
                  <span class="text-slate-600">
                    报名人数: 
                    <span class="font-semibold text-slate-900">{{ activity.ybmRs || 0 }}</span>
                    <span class="text-slate-400">/</span>
                    <span class="font-semibold text-slate-900">{{ activity.zmRs || '不限' }}</span>
                  </span>
                </div>
                <div class="flex-1">
                  <div class="w-full bg-slate-100 rounded-full h-2">
                    <div 
                      class="bg-red-500 h-2 rounded-full transition-all duration-300"
                      :style="{ width: `${getProgressPercentage(activity.ybmRs, parseInt(activity.zmRs))}%` }"
                    ></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>

    <!-- 活动详情弹窗 -->
    <div v-if="showDetailModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div class="bg-white rounded-lg shadow-xl max-w-3xl w-full max-h-[90vh] overflow-y-auto">
        <!-- 弹窗头部 -->
        <div class="sticky top-0 bg-white border-b border-slate-200 px-6 py-4 flex items-center justify-between">
          <h3 class="text-xl font-bold text-slate-900">活动详情</h3>
          <button @click="closeDetailModal" class="text-slate-400 hover:text-slate-600 transition-colors">
            <X class="w-6 h-6" />
          </button>
        </div>

        <!-- 弹窗内容 -->
        <div v-if="selectedActivity" class="p-6 space-y-6">
          <!-- 基本信息 -->
          <div>
            <div class="flex items-center gap-3 mb-4">
              <h4 class="text-2xl font-bold text-slate-900">{{ selectedActivity.hdMc }}</h4>
              <span :class="['px-3 py-1 rounded-full text-xs font-medium', getStatusClass(computeStatus(selectedActivity))]">
                {{ computeStatus(selectedActivity) }}
              </span>
              <span :class="['px-3 py-1 rounded-full text-xs font-medium', getPublishStatusClass(selectedActivity.fbZt)]">
                {{ selectedActivity.fbZt || '待申报' }}
              </span>
            </div>
          </div>

          <!-- 活动描述 -->
          <div class="bg-slate-50 rounded-lg p-4">
            <h5 class="font-semibold text-slate-900 mb-2 flex items-center gap-2">
              <AlertCircle class="w-5 h-5 text-red-600" />
              活动内容
            </h5>
            <p class="text-slate-700 whitespace-pre-wrap">{{ selectedActivity.hdNr || '暂无描述' }}</p>
          </div>

          <!-- 时间和地点信息 -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div class="border border-slate-200 rounded-lg p-4">
              <div class="flex items-center gap-2 text-slate-600 mb-2">
                <Calendar class="w-5 h-5 text-red-600" />
                <span class="font-semibold">报名时间</span>
              </div>
              <p class="text-slate-900 ml-7">{{ selectedActivity.bmSj || '-' }}</p>
            </div>
            <div class="border border-slate-200 rounded-lg p-4">
              <div class="flex items-center gap-2 text-slate-600 mb-2">
                <Calendar class="w-5 h-5 text-red-600" />
                <span class="font-semibold">活动时间</span>
              </div>
              <p class="text-slate-900 ml-7">{{ selectedActivity.hdSj || '-' }}</p>
            </div>
            <div class="border border-slate-200 rounded-lg p-4">
              <div class="flex items-center gap-2 text-slate-600 mb-2">
                <MapPin class="w-5 h-5 text-red-600" />
                <span class="font-semibold">活动地点</span>
              </div>
              <p class="text-slate-900 ml-7">{{ selectedActivity.hdDd || '-' }}</p>
            </div>
            <div class="border border-slate-200 rounded-lg p-4">
              <div class="flex items-center gap-2 text-slate-600 mb-2">
                <Briefcase class="w-5 h-5 text-red-600" />
                <span class="font-semibold">发起单位</span>
              </div>
              <p class="text-slate-900 ml-7">{{ selectedActivity.hdFqDw || '-' }}</p>
            </div>
          </div>

          <!-- 招募信息 -->
          <div class="border border-slate-200 rounded-lg p-4">
            <div class="flex items-center gap-2 text-slate-600 mb-3">
              <Users class="w-5 h-5 text-red-600" />
              <span class="font-semibold">招募信息</span>
            </div>
            <div class="ml-7 space-y-2">
              <div class="flex items-center gap-2">
                <span class="text-slate-600">招募人数：</span>
                <span class="font-semibold text-slate-900">{{ selectedActivity.zmRs || '不限' }}</span>
              </div>
              <div class="flex items-center gap-2">
                <span class="text-slate-600">已报名：</span>
                <span class="font-semibold text-slate-900">{{ selectedActivity.ybmRs || 0 }}</span>
              </div>
              <div class="w-full bg-slate-100 rounded-full h-2 mt-2">
                <div
                  class="bg-red-500 h-2 rounded-full transition-all duration-300"
                  :style="{ width: `${getProgressPercentage(selectedActivity.ybmRs, parseInt(selectedActivity.zmRs))}%` }"
                ></div>
              </div>
            </div>
          </div>

          <!-- 标签信息 -->
          <div v-if="selectedActivity.hdBq || selectedActivity.jnYq || selectedActivity.zyXz" class="space-y-3">
            <div v-if="selectedActivity.hdBq" class="border border-slate-200 rounded-lg p-4">
              <div class="flex items-center gap-2 text-slate-600 mb-2">
                <Tag class="w-5 h-5 text-red-600" />
                <span class="font-semibold">活动类别</span>
              </div>
              <div class="ml-7 flex flex-wrap gap-2">
                <span v-for="tag in selectedActivity.hdBq?.split(',')" :key="tag"
                      class="px-3 py-1 bg-red-50 text-red-700 rounded-full text-sm">
                  {{ tag }}
                </span>
              </div>
            </div>
            <div v-if="selectedActivity.jnYq" class="border border-slate-200 rounded-lg p-4">
              <div class="flex items-center gap-2 text-slate-600 mb-2">
                <Shield class="w-5 h-5 text-red-600" />
                <span class="font-semibold">技能要求</span>
              </div>
              <div class="ml-7 flex flex-wrap gap-2">
                <span v-for="skill in selectedActivity.jnYq?.split(',')" :key="skill"
                      class="px-3 py-1 bg-blue-50 text-blue-700 rounded-full text-sm">
                  {{ skill }}
                </span>
              </div>
            </div>
            <div v-if="selectedActivity.zyXz" class="border border-slate-200 rounded-lg p-4">
              <div class="flex items-center gap-2 text-slate-600 mb-2">
                <Briefcase class="w-5 h-5 text-red-600" />
                <span class="font-semibold">专业限制</span>
              </div>
              <p class="text-slate-900 ml-7">{{ selectedActivity.zyXz }}</p>
            </div>
          </div>

          <!-- 活动需求 -->
          <div v-if="selectedActivity.hdXq" class="border border-slate-200 rounded-lg p-4">
            <h5 class="font-semibold text-slate-900 mb-2">活动需求</h5>
            <p class="text-slate-700 whitespace-pre-wrap">{{ selectedActivity.hdXq }}</p>
          </div>

          <!-- 活动保障 -->
          <div v-if="selectedActivity.hdBz" class="border border-slate-200 rounded-lg p-4">
            <h5 class="font-semibold text-slate-900 mb-2">活动保障</h5>
            <p class="text-slate-700 whitespace-pre-wrap">{{ selectedActivity.hdBz }}</p>
          </div>
        </div>

        <!-- 弹窗底部 -->
        <div class="sticky bottom-0 bg-slate-50 border-t border-slate-200 px-6 py-4 flex justify-end">
          <Button @click="closeDetailModal" variant="outline">
            关闭
          </Button>
        </div>
      </div>
    </div>
  </div>
</template>