<script setup>
import { ref, onMounted } from 'vue'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import Button from '@/components/ui/button/button.vue'
import { Award, AlertCircle } from 'lucide-vue-next'
import axios from 'axios'

const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'

const registrations = ref([])
const loading = ref(false)
const errorMessage = ref('')
const showModal = ref(false)
const editingRecord = ref(null)
const form = ref({
  duration: '',
  credits: ''
})

const fetchRegistrations = async () => {
  const username = localStorage.getItem('headUsername') // 修正
  if (!username) {
    errorMessage.value = '未找到登录信息，请重新登录'
    return
  }

  loading.value = true
  errorMessage.value = ''

  try {
    const response = await axios.get(`${API_BASE}/api/head/registrations/${username}`)
    if (response.data.code === 200) {
      // 只显示有考勤记录的
      registrations.value = (response.data.data || []).filter(r => r.checkInTime && r.checkOutTime)
    } else {
      errorMessage.value = response.data.message || '获取数据失败'
    }
  } catch (error) {
    console.error('获取数据失败:', error)
    errorMessage.value = '网络错误，请稍后重试'
  } finally {
    loading.value = false
  }
}

// 计算工时（小时）
const calculateDuration = (checkIn, checkOut) => {
  if (!checkIn || !checkOut) return 0
  const diff = new Date(checkOut) - new Date(checkIn)
  return (diff / (1000 * 60 * 60)).toFixed(1)
}

// 获取确认状态样式
const getStatusClass = (duration, credits) => {
  if (credits > 0) return 'bg-green-100 text-green-700'
  if (duration > 0) return 'bg-yellow-100 text-yellow-700'
  return 'bg-slate-100 text-slate-700'
}

const openConfirm = (record) => {
  editingRecord.value = record
  const dur = record.duration ?? Number(calculateDuration(record.checkInTime, record.checkOutTime))
  form.value.duration = dur || 0
  form.value.credits = record.credits || ''
  showModal.value = true
}

const submitConfirm = async () => {
  if (!editingRecord.value) return
  const username = localStorage.getItem('headUsername')
  if (!username) {
    errorMessage.value = '未找到登录信息，请重新登录'
    return
  }
  try {
    await axios.put(`${API_BASE}/api/head/credits/${editingRecord.value.id}`, {
      username,
      duration: Number(form.value.duration || 0),
      credits: Number(form.value.credits || 0)
    })
    showModal.value = false
    await fetchRegistrations()
  } catch (e) {
    console.error(e)
    errorMessage.value = e?.response?.data?.message || '工时学分更新失败'
  }
}

onMounted(() => {
  fetchRegistrations()
})
</script>

<template>
  <div class="space-y-6">
    <h2 class="text-2xl font-bold text-slate-900">工时学分确认</h2>

    <div v-if="errorMessage" class="bg-red-50 border border-red-200 rounded-lg p-4 flex items-start gap-3">
      <AlertCircle class="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
      <div class="flex-1">
        <p class="text-sm font-medium text-red-800">{{ errorMessage }}</p>
      </div>
    </div>

    <Card>
      <CardHeader>
        <CardTitle>待确认工时学分</CardTitle>
      </CardHeader>
      <CardContent>
        <div v-if="loading" class="text-center py-12 text-slate-500">
          加载中...
        </div>
        <div v-else-if="registrations.length === 0" class="text-center py-12 text-slate-400">
          <Award class="w-12 h-12 mx-auto mb-3 text-slate-300" />
          <p class="text-lg mb-2">暂无待确认记录</p>
          <p class="text-sm">当学生完成活动考勤后，可在此处确认工时学分</p>
        </div>
        <div v-else class="overflow-x-auto">
          <table class="w-full">
            <thead>
              <tr class="border-b border-slate-200">
                <th class="text-left py-3 px-4 font-semibold text-slate-700">学生姓名</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">学号</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">活动名称</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">实际工时</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">学分</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">状态</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="record in registrations" :key="record.id" class="border-b border-slate-100 hover:bg-slate-50">
                <td class="py-3 px-4">{{ record.studentName }}</td>
                <td class="py-3 px-4 text-slate-600">{{ record.studentId }}</td>
                <td class="py-3 px-4">{{ record.activityName }}</td>
                <td class="py-3 px-4">
                  <span v-if="record.duration">{{ record.duration }} 小时</span>
                  <span v-else class="text-slate-400">{{ calculateDuration(record.checkInTime, record.checkOutTime) }} 小时</span>
                </td>
                <td class="py-3 px-4">
                  <span v-if="record.credits" class="font-semibold text-blue-600">{{ record.credits }}</span>
                  <span v-else class="text-slate-400">待确认</span>
                </td>
                <td class="py-3 px-4">
                  <span :class="['px-3 py-1 rounded-full text-sm font-medium', getStatusClass(record.duration, record.credits)]">
                    {{ record.credits > 0 ? '已确认' : '待确认' }}
                  </span>
                </td>
                <td class="py-3 px-4">
                  <Button v-if="!record.credits" variant="default" size="sm" @click="openConfirm(record)">确认</Button>
                  <Button v-else variant="outline" size="sm" @click="openConfirm(record)">修改</Button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </CardContent>
    </Card>

    <!-- 工时学分确认弹窗 -->
    <div
      v-if="showModal"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 px-4"
      @click.self="showModal = false"
    >
      <div class="w-full max-w-md rounded-lg bg-white shadow-xl">
        <div class="flex items-center justify-between border-b px-4 py-3">
          <h3 class="text-base font-semibold text-slate-800">确认工时学分</h3>
          <button class="text-slate-500 hover:text-slate-700" aria-label="关闭" @click="showModal = false">✕</button>
        </div>
        <div class="px-4 py-4 space-y-3">
          <label class="block text-sm text-slate-700">
            工时（小时）
            <input type="number" min="0" step="0.1" v-model="form.duration" class="mt-1 w-full border rounded px-3 py-2 text-sm" />
          </label>
          <label class="block text-sm text-slate-700">
            学分
            <input type="number" min="0" step="0.1" v-model="form.credits" class="mt-1 w-full border rounded px-3 py-2 text-sm" />
          </label>
        </div>
        <div class="flex justify-end gap-2 border-t px-4 py-3">
          <Button variant="outline" size="sm" @click="showModal = false">取消</Button>
          <Button variant="default" size="sm" @click="submitConfirm">保存</Button>
        </div>
      </div>
    </div>
  </div>
</template>