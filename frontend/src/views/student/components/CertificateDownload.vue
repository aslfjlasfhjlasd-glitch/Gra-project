<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import Button from '@/components/ui/button/button.vue'
import { FileText, Download, AlertCircle } from 'lucide-vue-next'

const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'

const loading = ref(false)
const errorMessage = ref('')
const records = ref([])

const fetchData = async () => {
  const studentId = localStorage.getItem('studentId')
  if (!studentId) {
    errorMessage.value = '未找到学生登录信息，请重新登录'
    return
  }
  loading.value = true
  errorMessage.value = ''
  try {
    const res = await axios.get(`${API_BASE}/api/student/certificates`, { params: { studentId } })
    if (res.data.code === 200) {
      records.value = res.data.data || []
    } else {
      errorMessage.value = res.data.message || '获取证明失败'
    }
  } catch (e) {
    console.error(e)
    errorMessage.value = '网络错误，请稍后重试'
  } finally {
    loading.value = false
  }
}

const downloadPdf = async (record) => {
  const studentId = localStorage.getItem('studentId')
  try {
    const res = await axios.get(`${API_BASE}/api/student/certificates/${record.id}/download`, {
      params: { studentId },
      responseType: 'blob'
    })
    const blob = new Blob([res.data], { type: 'application/pdf' })
    const url = window.URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `certificate-${record.id}.pdf`
    a.click()
    window.URL.revokeObjectURL(url)
  } catch (e) {
    console.error(e)
    errorMessage.value = '下载失败'
  }
}

onMounted(fetchData)
</script>

<template>
  <div class="space-y-6">
    <h2 class="text-2xl font-bold text-slate-900">志愿活动证明下载</h2>

    <div v-if="errorMessage" class="bg-red-50 border border-red-200 rounded-lg p-4 flex items-start gap-3">
      <AlertCircle class="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
      <div class="flex-1">
        <p class="text-sm font-medium text-red-800">{{ errorMessage }}</p>
      </div>
    </div>

    <Card>
      <CardHeader>
        <CardTitle>已确认证明</CardTitle>
      </CardHeader>
      <CardContent>
        <div v-if="loading" class="text-center py-12 text-slate-500">加载中...</div>
        <div v-else-if="records.length === 0" class="text-center py-12 text-slate-400">
          <FileText class="w-12 h-12 mx-auto mb-3 text-slate-300" />
          <p class="text-lg mb-2">暂无已确认证明</p>
          <p class="text-sm">仅展示负责人已确认的证明</p>
        </div>
        <div v-else class="space-y-4">
          <div
            v-for="item in records"
            :key="item.id"
            class="border border-slate-200 rounded-lg p-4 flex items-center justify-between hover:bg-slate-50 transition-colors"
          >
            <div class="space-y-1">
              <p class="font-semibold text-slate-900">{{ item.activityName }}</p>
              <p class="text-sm text-slate-600">参与日期：{{ item.activityTime || '-' }}</p>
              <p class="text-xs text-slate-500">工时：{{ item.duration || 0 }}h | 学分：{{ item.credits || 0 }}</p>
            </div>
            <Button variant="outline" size="sm" class="gap-2" @click="downloadPdf(item)">
              <Download class="w-4 h-4" />
              下载PDF
            </Button>
          </div>
        </div>
      </CardContent>
    </Card>
  </div>
</template>

