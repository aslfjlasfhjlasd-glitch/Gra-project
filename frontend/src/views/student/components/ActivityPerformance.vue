<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'

const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'

interface Performance {
  registrationId: number
  activityId: string
  activityName: string
  activityTime: string
  duration: number | null
  credits: number | null
  leaderRating?: number | null
  leaderComment?: string | null
  activityRating?: number | null
}

const performances = ref<Performance[]>([])
const loading = ref(false)
const error = ref(false)
const showRateModal = ref(false)
const ratingValue = ref(5)
const ratingTarget = ref<Performance | null>(null)

const fetchPerformance = async () => {
  loading.value = true
  try {
    const studentId = localStorage.getItem('studentId') || '2024104'
    const res = await axios.get(`${API_BASE}/api/student/performance`, {
      params: { studentId }
    })
    if (res.data.code === 200) {
        performances.value = res.data.data || []
    } else {
        performances.value = []
    }
  } catch (e) {
    console.error(e)
    error.value = true
  } finally {
    loading.value = false
  }
}

const openRate = (item: Performance) => {
  ratingTarget.value = item
  ratingValue.value = item.activityRating || 5
  showRateModal.value = true
}

const submitRate = async () => {
  if (!ratingTarget.value) return
  const studentId = localStorage.getItem('studentId') || '2024104'
  try {
    await axios.put(`${API_BASE}/api/student/performance/${ratingTarget.value.registrationId}/rate`, {
      studentId,
      rating: ratingValue.value
    })
    showRateModal.value = false
    ratingTarget.value = null
    await fetchPerformance()
  } catch (e) {
    console.error(e)
    alert('评分失败')
  }
}

onMounted(() => {
  fetchPerformance()
})
</script>

<template>
  <Card>
    <CardHeader>
      <CardTitle>活动表现查看</CardTitle>
    </CardHeader>
    <CardContent>
      <div class="relative w-full overflow-auto">
        <table class="w-full caption-bottom text-sm text-left">
          <thead class="[&_tr]:border-b">
            <tr class="border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted">
              <th class="h-12 px-4 align-middle font-medium text-slate-500">活动编号</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">活动名称</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">活动时间</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">参与时长 (小时)</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">获得学分</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">负责人评分</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">负责人评价</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">活动评分</th>
            </tr>
          </thead>
          <tbody class="[&_tr:last-child]:border-0">
            <tr v-if="loading">
              <td colspan="8" class="p-4 text-center text-slate-500">加载中...</td>
            </tr>
            <tr v-else-if="performances.length === 0">
              <td colspan="8" class="p-4 text-center text-slate-500">暂无活动记录</td>
            </tr>
            <tr v-else v-for="item in performances" :key="item.registrationId" class="border-b transition-colors hover:bg-slate-100/50">
              <td class="p-4 align-middle font-medium">{{ item.activityId }}</td>
              <td class="p-4 align-middle">{{ item.activityName }}</td>
              <td class="p-4 align-middle">{{ item.activityTime }}</td>
              <td class="p-4 align-middle font-medium text-blue-600">
                {{ item.duration !== null ? item.duration : '-' }}
              </td>
              <td class="p-4 align-middle font-medium text-emerald-600">
                {{ item.credits !== null ? item.credits : '-' }}
              </td>
              <td class="p-4 align-middle text-slate-700">
                {{ item.leaderRating ?? '-' }}
              </td>
              <td class="p-4 align-middle text-slate-700">
                {{ item.leaderComment || '-' }}
              </td>
              <td class="p-4 align-middle">
                <div class="flex items-center gap-2">
                  <span class="text-slate-700 text-sm">
                    {{ item.activityRating ? `${item.activityRating}/5` : '' }}
                  </span>
                  <button
                    v-if="!item.activityRating"
                    class="inline-flex items-center gap-1 rounded-full border border-blue-500 px-3 py-1 text-xs font-medium text-blue-600 hover:bg-blue-50 hover:shadow-sm transition"
                    @click="openRate(item)"
                  >
                    评分
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- 评分弹窗 -->
      <div
        v-if="showRateModal"
        class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 px-4"
        @click.self="showRateModal = false"
      >
        <div class="w-full max-w-sm rounded-lg bg-white shadow-xl">
          <div class="flex items-center justify-between border-b px-4 py-3">
            <h3 class="text-base font-semibold text-slate-800">活动评分</h3>
            <button class="text-slate-500 hover:text-slate-700" aria-label="关闭" @click="showRateModal = false">✕</button>
          </div>
          <div class="px-4 py-4 space-y-3">
            <p class="text-sm text-slate-700">
              对活动「{{ ratingTarget?.activityName }}」进行评分（1-5）
            </p>
            <input
              type="number"
              min="1"
              max="5"
              v-model.number="ratingValue"
              class="w-full border rounded px-3 py-2 text-sm"
            />
          </div>
          <div class="flex justify-end gap-2 border-t px-4 py-3">
            <button class="text-sm px-3 py-2 rounded border border-slate-200" @click="showRateModal = false">取消</button>
            <button class="text-sm px-4 py-2 rounded bg-blue-600 text-white" @click="submitRate">提交</button>
          </div>
        </div>
      </div>
    </CardContent>
  </Card>
</template>
