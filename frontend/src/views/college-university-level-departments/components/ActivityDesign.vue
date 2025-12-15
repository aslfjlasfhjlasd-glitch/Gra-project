<script setup>
import { ref, onMounted, computed } from 'vue'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import Button from '@/components/ui/button/button.vue'
import Input from '@/components/ui/input/Input.vue'
import { Plus, Edit, Trash2, Calendar, MapPin, Users, AlertCircle, X, Archive, Upload } from 'lucide-vue-next'
import axios from 'axios'

const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'

const props = defineProps({
  forceAdmin: {
    type: Boolean,
    default: false
  }
})

const activities = ref([])
const loading = ref(false)
const errorMessage = ref('')
const showEditDialog = ref(false)
const showCreateDialog = ref(false)
const editingActivity = ref(null)
const newActivity = ref(null)
const successMessage = ref('')
const createErrorMessage = ref('')
let messageTimer = null

// 判断当前用户角色
const userRole = ref(localStorage.getItem('userRole') || 'head')
const isAdmin = computed(() => props.forceAdmin || userRole.value === 'superadmin')

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
  }, 3000)
}

// 获取活动列表
const fetchActivities = async () => {
  loading.value = true
  errorMessage.value = ''

  try {
    let response
    if (isAdmin.value) {
      // 管理员获取所有活动
      response = await axios.get(`${API_BASE}/api/admin/activities`)
    } else {
      // 负责人获取本单位活动
      const username = localStorage.getItem('headUsername')
      if (!username) {
        errorMessage.value = '未找到登录信息，请重新登录'
        loading.value = false
        return
      }
      response = await axios.get(`${API_BASE}/api/head/activities/${username}`)
    }
    
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
    '未申报': 'bg-yellow-100 text-yellow-700',
    '待发布': 'bg-blue-100 text-blue-700',
    '已发布': 'bg-green-100 text-green-700',
    '已下架': 'bg-slate-100 text-slate-500'
  }
  return statusMap[status] || 'bg-slate-100 text-slate-700'
}

// 格式化日期时间
const formatDateTime = (dateStr) => {
  if (!dateStr) return '-'
  return dateStr
}

// 计算报名进度百分比
const getProgressPercentage = (current, max) => {
  if (!max || max === 0) return 0
  const percentage = (current / max) * 100
  return Math.min(percentage, 100)
}

// 打开编辑弹窗
const openEditDialog = (activity) => {
  editingActivity.value = {
    hdBh: activity.hdBh,
    hdMc: activity.hdMc,
    hdNr: activity.hdNr,
    hdDd: activity.hdDd,
    bmKssj: formatDateTimeForInput(activity.bmKssj),
    bmJssj: formatDateTimeForInput(activity.bmJssj),
    hdKssj: formatDateTimeForInput(activity.hdKssj),
    hdJssj: formatDateTimeForInput(activity.hdJssj),
    zmRs: activity.zmRs,
    hdXf: activity.hdXf,
    hdBq: activity.hdBq || '',
    jnYq: activity.jnYq || '',
    zyXz: activity.zyXz || '',
    hdXq: activity.hdXq || '',
    hdBz: activity.hdBz || ''
  }
  showEditDialog.value = true
  errorMessage.value = ''
  successMessage.value = ''
}

// 关闭编辑弹窗
const closeEditDialog = () => {
  showEditDialog.value = false
  editingActivity.value = null
}

// 打开创建弹窗
const openCreateDialog = () => {
  newActivity.value = {
    hdMc: '',
    hdNr: '',
    hdDd: '',
    bmKssj: '',
    bmJssj: '',
    hdKssj: '',
    hdJssj: '',
    zmRs: null,
    hdXf: null,
    hdBq: '',
    jnYq: '',
    zyXz: '',
    hdXq: '',
    hdBz: ''
  }
  showCreateDialog.value = true
  errorMessage.value = ''
  successMessage.value = ''
}

// 关闭创建弹窗
const closeCreateDialog = () => {
  showCreateDialog.value = false
  newActivity.value = null
}

// 格式化日期时间为input[type="datetime-local"]格式
const formatDateTimeForInput = (date) => {
  if (!date) return ''
  const d = new Date(date)
  const year = d.getFullYear()
  const month = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  const hours = String(d.getHours()).padStart(2, '0')
  const minutes = String(d.getMinutes()).padStart(2, '0')
  return `${year}-${month}-${day}T${hours}:${minutes}`
}

// 保存编辑
const saveEdit = async () => {
  if (!editingActivity.value) return

  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''
  createErrorMessage.value = ''

  try {
    // 转换日期格式
    const activityData = {
      ...editingActivity.value,
      bmKssj: new Date(editingActivity.value.bmKssj).toISOString(),
      bmJssj: new Date(editingActivity.value.bmJssj).toISOString(),
      hdKssj: new Date(editingActivity.value.hdKssj).toISOString(),
      hdJssj: new Date(editingActivity.value.hdJssj).toISOString()
    }

    const response = await axios.put(`${API_BASE}/api/head/activity`, activityData)
    
    if (response.data.code === 200) {
      showMessage('success', '活动更新成功')
      closeEditDialog()
      await fetchActivities()
    } else {
      showMessage('error', response.data.message || '更新失败')
    }
  } catch (error) {
    console.error('更新活动失败:', error)
    showMessage('error', '网络错误，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 保存新活动
const saveCreate = async () => {
  if (!newActivity.value) return

  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''

  try {
    // 根据角色获取不同的用户名
    const username = isAdmin.value
      ? localStorage.getItem('adminUsername')
      : localStorage.getItem('headUsername')
    
    if (!username) {
      showMessage('error', '未找到登录信息，请重新登录')
      loading.value = false
      return
    }

    // 转换日期格式为时间戳
    const activityData = {
      hdMc: newActivity.value.hdMc,
      hdNr: newActivity.value.hdNr,
      hdDd: newActivity.value.hdDd,
      zmRs: parseInt(newActivity.value.zmRs),
      hdXf: newActivity.value.hdXf ? parseFloat(newActivity.value.hdXf) : null,
      bmKssj: new Date(newActivity.value.bmKssj).getTime(),
      bmJssj: new Date(newActivity.value.bmJssj).getTime(),
      hdKssj: new Date(newActivity.value.hdKssj).getTime(),
      hdJssj: new Date(newActivity.value.hdJssj).getTime(),
      hdBq: newActivity.value.hdBq || '',
      jnYq: newActivity.value.jnYq || '',
      zyXz: newActivity.value.zyXz || '',
      hdXq: newActivity.value.hdXq || '',
      hdBz: newActivity.value.hdBz || ''
    }

    const response = await axios.post(`${API_BASE}/api/head/activity`, {
      username: username,
      activity: activityData
    })
    
    if (response.data.code === 200) {
      showMessage('success', '活动创建成功')
      closeCreateDialog()
      await fetchActivities()
    } else {
      createErrorMessage.value = response.data.message || '创建失败'
    }
  } catch (error) {
    console.error('创建活动失败:', error)
    createErrorMessage.value = error?.response?.data?.message || '网络错误，请稍后重试'
  } finally {
    loading.value = false
  }
}

// 删除活动
const deleteActivity = async (activityId, activityName) => {
  if (!confirm(`确定要删除活动"${activityName}"吗？此操作不可恢复！`)) {
    return
  }

  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''

  try {
    const response = await axios.delete(`${API_BASE}/api/head/activity/${activityId}`)
    
    if (response.data.code === 200) {
      showMessage('success', '活动删除成功')
      await fetchActivities()
    } else {
      showMessage('error', response.data.message || '删除失败')
    }
  } catch (error) {
    console.error('删除活动失败:', error)
    showMessage('error', '网络错误，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 申报活动
const submitActivity = async (activity) => {
  if (!confirm(`确定要申报活动"${activity.hdMc}"吗？申报后状态将变为"待发布"，并提交给管理员审核发布。`)) {
    return
  }

  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''

  try {
    const response = await axios.put(`${API_BASE}/api/head/activity/${activity.hdBh}/submit`)
    
    if (response.data.code === 200) {
      showMessage('success', '活动已申报，等待管理员审核')
      await fetchActivities()
    } else {
      showMessage('error', response.data.message || '申报失败')
    }
  } catch (error) {
    console.error('申报活动失败:', error)
    showMessage('error', '网络错误，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 撤销申报
const cancelSubmitActivity = async (activity) => {
  if (!confirm(`确定要撤销申报活动"${activity.hdMc}"吗？撤销后可以重新编辑和申报。`)) {
    return
  }

  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''

  try {
    const response = await axios.put(`${API_BASE}/api/head/activity/${activity.hdBh}/cancel-submit`)
    
    if (response.data.code === 200) {
      showMessage('success', '已撤销申报')
      await fetchActivities()
    } else {
      showMessage('error', response.data.message || '撤销申报失败')
    }
  } catch (error) {
    console.error('撤销申报失败:', error)
    showMessage('error', '网络错误，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 判断是否可以申报（只有未申报的活动可以申报）
const canSubmit = (activity) => {
  return activity.fbZt === '未申报'
}

// 判断是否可以撤销申报（只有待发布的活动可以撤销申报）
const canCancelSubmit = (activity) => {
  return activity.fbZt === '待发布'
}


onMounted(() => {
  fetchActivities()
})
</script>

<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h2 class="text-2xl font-bold text-slate-900">志愿活动设计</h2>
      <Button class="gap-2" @click="openCreateDialog">
        <Plus class="w-4 h-4" />
        创建新活动
      </Button>
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
          <p class="text-sm">点击"创建新活动"按钮开始创建您的第一个志愿活动</p>
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
                      {{ activity.fbZt || '未申报' }}
                    </span>
                  </div>
                  <p class="text-sm text-slate-600 line-clamp-2">{{ activity.hdNr || '暂无描述' }}</p>
                </div>
                <div class="flex gap-2 ml-4">
                  <Button variant="outline" size="sm" class="gap-2" @click="openEditDialog(activity)">
                    <Edit class="w-4 h-4" />
                    编辑
                  </Button>
                  
                  <!-- 负责人：申报按钮 - 只有待申报的活动可以申报 -->
                  <Button
                    v-if="!isAdmin && canSubmit(activity)"
                    variant="outline"
                    size="sm"
                    class="gap-2 text-blue-600 hover:text-blue-700 hover:border-blue-300"
                    @click="submitActivity(activity)"
                  >
                    <Upload class="w-4 h-4" />
                    申报活动
                  </Button>
                  
                  <!-- 负责人：撤销申报按钮 - 只有待发布的活动可以撤销申报 -->
                  <Button
                    v-if="!isAdmin && canCancelSubmit(activity)"
                    variant="outline"
                    size="sm"
                    class="gap-2 text-orange-600 hover:text-orange-700 hover:border-orange-300"
                    @click="cancelSubmitActivity(activity)"
                  >
                    <X class="w-4 h-4" />
                    撤销申报
                  </Button>
                  
                  <Button
                    variant="outline"
                    size="sm"
                    class="gap-2 text-red-600 hover:text-red-700 hover:border-red-300"
                    @click="deleteActivity(activity.hdBh, activity.hdMc)"
                  >
                    <Trash2 class="w-4 h-4" />
                    删除
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
                      class="bg-blue-500 h-2 rounded-full transition-all duration-300"
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

    <!-- 编辑活动弹窗 -->
    <div v-if="showEditDialog" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div class="bg-white rounded-lg shadow-xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-slate-200 px-6 py-4 flex justify-between items-center">
          <h3 class="text-xl font-semibold text-slate-900">编辑活动</h3>
          <button @click="closeEditDialog" class="text-slate-400 hover:text-slate-600">
            <X class="w-6 h-6" />
          </button>
        </div>

        <div v-if="editingActivity" class="p-6 space-y-6">
          <!-- 基本信息 -->
          <div class="space-y-4">
            <h4 class="font-semibold text-slate-900 border-b pb-2">基本信息</h4>
            
            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">活动名称 *</label>
              <Input v-model="editingActivity.hdMc" placeholder="请输入活动名称" />
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">活动内容 *</label>
              <textarea
                v-model="editingActivity.hdNr"
                class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                rows="4"
                placeholder="请输入活动内容描述"
              ></textarea>
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">活动地点 *</label>
              <Input v-model="editingActivity.hdDd" placeholder="请输入活动地点" />
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">招募人数 *</label>
              <Input v-model="editingActivity.zmRs" type="number" placeholder="请输入招募人数" />
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">活动学分</label>
              <Input v-model="editingActivity.hdXf" type="number" step="0.1" placeholder="请输入活动学分（如：1.5）" />
            </div>
          </div>

          <!-- 时间设置 -->
          <div class="space-y-4">
            <h4 class="font-semibold text-slate-900 border-b pb-2">时间设置</h4>
            
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">报名开始时间 *</label>
                <Input v-model="editingActivity.bmKssj" type="datetime-local" />
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">报名结束时间 *</label>
                <Input v-model="editingActivity.bmJssj" type="datetime-local" />
              </div>
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">活动开始时间 *</label>
                <Input v-model="editingActivity.hdKssj" type="datetime-local" />
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">活动结束时间 *</label>
                <Input v-model="editingActivity.hdJssj" type="datetime-local" />
              </div>
            </div>
          </div>

          <!-- 其他信息 -->
          <div class="space-y-4">
            <h4 class="font-semibold text-slate-900 border-b pb-2">其他信息</h4>
            
            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">活动标签</label>
              <Input v-model="editingActivity.hdBq" placeholder="如：社区服务、赛会服务等" />
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">技能要求</label>
              <Input v-model="editingActivity.jnYq" placeholder="如：摄影摄像、英语翻译等" />
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">专业限制</label>
              <Input v-model="editingActivity.zyXz" placeholder="如：英语、计算机等，留空表示不限" />
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">活动需求</label>
              <textarea
                v-model="editingActivity.hdXq"
                class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                rows="3"
                placeholder="请输入活动需求条件"
              ></textarea>
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">活动保障</label>
              <textarea
                v-model="editingActivity.hdBz"
                class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                rows="3"
                placeholder="请输入活动保障措施"
              ></textarea>
            </div>
          </div>
        </div>

        <div class="sticky bottom-0 bg-slate-50 border-t border-slate-200 px-6 py-4 flex justify-end gap-3">
          <Button variant="outline" @click="closeEditDialog">取消</Button>
          <Button @click="saveEdit" :disabled="loading">
            {{ loading ? '保存中...' : '保存' }}
          </Button>
        </div>
      </div>
    </div>

    <!-- 创建活动弹窗 -->
    <div v-if="showCreateDialog" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div class="bg-white rounded-lg shadow-xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-slate-200 px-6 py-4 flex justify-between items-center">
          <h3 class="text-xl font-semibold text-slate-900">创建新活动</h3>
          <button @click="closeCreateDialog" class="text-slate-400 hover:text-slate-600">
            <X class="w-6 h-6" />
          </button>
        </div>

        <!-- 创建错误弹窗（覆盖在创建窗之上并居中） -->
        <div
          v-if="createErrorMessage"
          class="absolute inset-0 z-50 flex items-center justify-center"
        >
          <div class="bg-white shadow-2xl rounded-lg border border-red-200 w-full max-w-md mx-auto">
            <div class="px-4 py-3 border-b border-red-100 flex items-center gap-2">
              <AlertCircle class="w-5 h-5 text-red-600" />
              <span class="text-sm font-semibold text-red-700">保存失败</span>
            </div>
            <div class="px-4 py-4 text-sm text-red-700 whitespace-pre-line">
              {{ createErrorMessage }}
            </div>
            <div class="px-4 py-3 border-t border-red-100 flex justify-end">
              <Button variant="outline" size="sm" @click="createErrorMessage = ''">知道了</Button>
            </div>
          </div>
        </div>

        <div v-if="newActivity" class="p-6 space-y-6">
          <!-- 基本信息 -->
          <div class="space-y-4">
            <h4 class="font-semibold text-slate-900 border-b pb-2">基本信息</h4>
            
            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">活动名称 *</label>
              <Input v-model="newActivity.hdMc" placeholder="请输入活动名称" />
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">活动内容 *</label>
              <textarea
                v-model="newActivity.hdNr"
                class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                rows="4"
                placeholder="请输入活动内容描述"
              ></textarea>
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">活动地点 *</label>
              <Input v-model="newActivity.hdDd" placeholder="请输入活动地点" />
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">招募人数 *</label>
              <Input v-model="newActivity.zmRs" type="number" placeholder="请输入招募人数" />
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">活动学分</label>
              <Input v-model="newActivity.hdXf" type="number" step="0.1" placeholder="请输入活动学分（如：1.5）" />
            </div>
          </div>

          <!-- 时间设置 -->
          <div class="space-y-4">
            <h4 class="font-semibold text-slate-900 border-b pb-2">时间设置</h4>
            
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">报名开始时间 *</label>
                <Input v-model="newActivity.bmKssj" type="datetime-local" />
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">报名结束时间 *</label>
                <Input v-model="newActivity.bmJssj" type="datetime-local" />
              </div>
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">活动开始时间 *</label>
                <Input v-model="newActivity.hdKssj" type="datetime-local" />
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">活动结束时间 *</label>
                <Input v-model="newActivity.hdJssj" type="datetime-local" />
              </div>
            </div>
          </div>

          <!-- 其他信息 -->
          <div class="space-y-4">
            <h4 class="font-semibold text-slate-900 border-b pb-2">其他信息</h4>
            
            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">活动标签</label>
              <Input v-model="newActivity.hdBq" placeholder="如：社区服务、赛会服务等" />
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">技能要求</label>
              <Input v-model="newActivity.jnYq" placeholder="如：摄影摄像、英语翻译等" />
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">专业限制</label>
              <Input v-model="newActivity.zyXz" placeholder="如：英语、计算机等，留空表示不限" />
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">活动需求</label>
              <textarea
                v-model="newActivity.hdXq"
                class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                rows="3"
                placeholder="请输入活动需求条件"
              ></textarea>
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2">活动保障</label>
              <textarea
                v-model="newActivity.hdBz"
                class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                rows="3"
                placeholder="请输入活动保障措施"
              ></textarea>
            </div>
          </div>
        </div>

        <div class="sticky bottom-0 bg-slate-50 border-t border-slate-200 px-6 py-4 flex justify-end gap-3">
          <Button variant="outline" @click="closeCreateDialog">取消</Button>
          <Button @click="saveCreate" :disabled="loading">
            {{ loading ? '保存中...' : '保存' }}
          </Button>
        </div>
      </div>
    </div>
  </div>
</template>