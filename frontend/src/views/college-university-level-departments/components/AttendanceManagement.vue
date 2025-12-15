<script setup>
import { ref, onMounted } from 'vue'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import Button from '@/components/ui/button/button.vue'
import { Clock, AlertCircle } from 'lucide-vue-next'
import axios from 'axios'

const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'

const registrations = ref([])
const loading = ref(false)
const errorMessage = ref('')
const showEditModal = ref(false)
const editingRecord = ref(null)
const form = ref({
  checkInTime: '',
  checkOutTime: '',
  attendanceStatus: 0
})

// 获取报名记录（用于考勤管理）
// 获取报名记录（用于考勤管理）
const fetchRegistrations = async () => {
  const username = localStorage.getItem('headUsername') // 修正：读取负责人账号
  if (!username) {
    errorMessage.value = '未找到登录信息，请重新登录'
    return
  }

  loading.value = true
  errorMessage.value = ''

  try {
    const response = await axios.get(`${API_BASE}/api/head/registrations/${username}`)
    if (response.data.code === 200) {
      registrations.value = response.data.data || []
    } else {
      // 显示后端返回的具体错误，如果后端报错“获取负责人信息失败”，这里会显示出来
      errorMessage.value = response.data.message || '获取数据失败'
    }
  } catch (error) {
    console.error('获取数据失败:', error)
    errorMessage.value = '网络错误，请检查后端服务是否启动'
  } finally {
    loading.value = false
  }
}

const formatInput = (dateStr) => {
  if (!dateStr) return ''
  const d = new Date(dateStr)
  const iso = new Date(d.getTime() - d.getTimezoneOffset() * 60000).toISOString()
  return iso.slice(0, 16) // yyyy-MM-ddTHH:mm
}

const openEdit = (record) => {
  editingRecord.value = record
  form.value.checkInTime = formatInput(record.checkInTime)
  form.value.checkOutTime = formatInput(record.checkOutTime)
  form.value.attendanceStatus = record.attendanceStatus ?? 0
  showEditModal.value = true
}

const submitEdit = async () => {
  if (!editingRecord.value) return
  const username = localStorage.getItem('headUsername')
  if (!username) {
    errorMessage.value = '未找到登录信息，请重新登录'
    return
  }
  try {
    await axios.put(`${API_BASE}/api/head/attendance/${editingRecord.value.id}`, {
      username,
      checkInTime: form.value.checkInTime ? new Date(form.value.checkInTime).getTime() : null,
      checkOutTime: form.value.checkOutTime ? new Date(form.value.checkOutTime).getTime() : null,
      attendanceStatus: Number(form.value.attendanceStatus)
    })
    showEditModal.value = false
    await fetchRegistrations()
  } catch (e) {
    console.error(e)
    errorMessage.value = e?.response?.data?.message || '更新考勤失败'
  }
}

// 格式化时间
const formatTime = (time) => {
  if (!time) return '-'
  return new Date(time).toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// 获取考勤状态样式
const getAttendanceStatusClass = (status) => {
  const text = displayAttendance(status)
  switch (text) {
    case '正常': return 'bg-green-100 text-green-700'
    case '迟到': return 'bg-yellow-100 text-yellow-700'
    case '早退': return 'bg-orange-100 text-orange-700'
    case '缺勤': return 'bg-red-100 text-red-700'
    default: return 'bg-slate-100 text-slate-700'
  }
}

const displayAttendance = (status) => {
  if (status === null || status === undefined) return '未记录'
  if (typeof status === 'string' && isNaN(Number(status))) return status
  const code = Number(status)
  switch (code) {
    case 1: return '正常'
    case 2: return '迟到'
    case 3: return '缺勤'
    default: return '未记录'
  }
}

onMounted(() => {
  fetchRegistrations()
})
</script>

<template>
  <div class="space-y-6">
    <h2 class="text-2xl font-bold text-slate-900">考勤管理</h2>

    <div v-if="errorMessage" class="bg-red-50 border border-red-200 rounded-lg p-4 flex items-start gap-3">
      <AlertCircle class="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
      <div class="flex-1">
        <p class="text-sm font-medium text-red-800">{{ errorMessage }}</p>
      </div>
    </div>

    <Card>
      <CardHeader>
        <CardTitle>考勤记录</CardTitle>
      </CardHeader>
      <CardContent>
        <div v-if="loading" class="text-center py-12 text-slate-500">
          加载中...
        </div>
        <div v-else-if="registrations.length === 0" class="text-center py-12 text-slate-400">
          <Clock class="w-12 h-12 mx-auto mb-3 text-slate-300" />
          <p class="text-lg mb-2">暂无考勤记录</p>
          <p class="text-sm">当学生参与活动后，考勤记录将显示在此处</p>
        </div>
        <div v-else class="overflow-x-auto">
          <table class="w-full">
            <thead>
              <tr class="border-b border-slate-200">
                <th class="text-left py-3 px-4 font-semibold text-slate-700">学生姓名</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">学号</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">活动名称</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">签到时间</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">签退时间</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">考勤状态</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="record in registrations" :key="record.id" class="border-b border-slate-100 hover:bg-slate-50">
                <td class="py-3 px-4">{{ record.studentName }}</td>
                <td class="py-3 px-4 text-slate-600">{{ record.studentId }}</td>
                <td class="py-3 px-4">{{ record.activityName }}</td>
                <td class="py-3 px-4 text-sm text-slate-600">{{ formatTime(record.checkInTime) }}</td>
                <td class="py-3 px-4 text-sm text-slate-600">{{ formatTime(record.checkOutTime) }}</td>
                <td class="py-3 px-4">
                  <span :class="['px-3 py-1 rounded-full text-sm font-medium', getAttendanceStatusClass(record.attendanceStatus)]">
                    {{ displayAttendance(record.attendanceStatus) }}
                  </span>
                </td>
                <td class="py-3 px-4">
                  <Button variant="outline" size="sm" @click="openEdit(record)">编辑</Button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </CardContent>
    </Card>

    <!-- 考勤编辑弹窗 -->
    <div
      v-if="showEditModal"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 px-4"
      @click.self="showEditModal = false"
    >
      <div class="w-full max-w-md rounded-lg bg-white shadow-xl">
        <div class="flex items-center justify-between border-b px-4 py-3">
          <h3 class="text-base font-semibold text-slate-800">编辑考勤</h3>
          <button class="text-slate-500 hover:text-slate-700" aria-label="关闭" @click="showEditModal = false">✕</button>
        </div>
        <div class="px-4 py-4 space-y-3">
          <label class="block text-sm text-slate-700">
            签到时间
            <input type="datetime-local" v-model="form.checkInTime" class="mt-1 w-full border rounded px-3 py-2 text-sm" />
          </label>
          <label class="block text-sm text-slate-700">
            签退时间
            <input type="datetime-local" v-model="form.checkOutTime" class="mt-1 w-full border rounded px-3 py-2 text-sm" />
          </label>
          <label class="block text-sm text-slate-700">
            考勤状态
            <select v-model="form.attendanceStatus" class="mt-1 w-full border rounded px-3 py-2 text-sm">
              <option :value="0">未记录</option>
              <option :value="1">正常</option>
              <option :value="2">迟到</option>
              <option :value="3">缺勤</option>
            </select>
          </label>
        </div>
        <div class="flex justify-end gap-2 border-t px-4 py-3">
          <Button variant="outline" size="sm" @click="showEditModal = false">取消</Button>
          <Button variant="default" size="sm" @click="submitEdit">保存</Button>
        </div>
      </div>
    </div>
  </div>
</template>