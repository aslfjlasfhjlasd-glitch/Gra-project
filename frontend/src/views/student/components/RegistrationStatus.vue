<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'

const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'

interface Registration {
  activityId: string
  activityName: string
  activityTime: string
  activityLocation: string
  status: string
  auditReason?: string
}

interface ActivityDetail {
  hdBh?: number
  hdMc?: string
  hdSj?: string
  hdDd?: string
  hdNr?: string
  hdXq?: string
  hdBz?: string
  hdZt?: string
  fbZt?: string
  hdFqDw?: string
  bmKssj?: string
  bmJssj?: string
  hdKssj?: string
  hdJssj?: string
  zmRs?: number
  ybmRs?: number
  hdBq?: string
  jnYq?: string
  zyXz?: string
}

const registrations = ref<Registration[]>([])
const loading = ref(false)
const error = ref(false)
const cancelingId = ref<string | null>(null)
const showDetailModal = ref(false)
const detailItem = ref<ActivityDetail | null>(null)

// Toast 通知相关
const toastMessage = ref('')
const toastType = ref<'success' | 'error'>('success')
const showToast = ref(false)

const showToastMessage = (message: string, type: 'success' | 'error' = 'success') => {
  toastMessage.value = message
  toastType.value = type
  showToast.value = true
  setTimeout(() => {
    showToast.value = false
  }, 3000)
}

const fetchRegistrations = async () => {
  loading.value = true
  try {
    // 优先使用登录后保存的 studentId；没有则回退演示账号
    const studentId = localStorage.getItem('studentId') || '2024104'
    const res = await axios.get(`${API_BASE}/api/student/registrations`, {
      params: { studentId }
    })
    if (res.data.code === 200) {
        registrations.value = res.data.data || []
    } else {
        registrations.value = []
    }
  } catch (e) {
    console.error(e)
    error.value = true
  } finally {
    loading.value = false
  }
}

// 驳回原因弹窗
const showRejectModal = ref(false)
const rejectReason = ref('')

const openRejectModal = (reason?: string) => {
  rejectReason.value = reason || '暂无拒绝原因'
  showRejectModal.value = true
}

const closeRejectModal = () => {
  showRejectModal.value = false
  rejectReason.value = ''
}

const openDetailModal = async (item: Registration) => {
  try {
    const res = await axios.get(`${API_BASE}/api/student/activity/${item.activityId}`)
    if (res.data.code === 200) {
      detailItem.value = res.data.data || null
      showDetailModal.value = true
    } else {
      detailItem.value = null
      showDetailModal.value = true
      showToastMessage(res.data.message || '获取活动详情失败', 'error')
    }
  } catch (e) {
    console.error(e)
    detailItem.value = null
    showDetailModal.value = true
    showToastMessage('获取活动详情失败', 'error')
  }
}

const closeDetailModal = () => {
  showDetailModal.value = false
  detailItem.value = null
}

const cancelRegistration = async (activityId: string) => {
  if (!confirm('确定要取消报名吗？')) {
    return
  }

  cancelingId.value = activityId
  try {
    const studentId = localStorage.getItem('studentId') || '2024104'
    const res = await axios.post(`${API_BASE}/api/student/activity/cancel`, {
      studentId,
      activityId: parseInt(activityId)
    })

    if (res.data.code === 200) {
      showToastMessage('取消报名成功', 'success')
      // 刷新列表
      await fetchRegistrations()
    } else {
      showToastMessage(res.data.message || '取消报名失败', 'error')
    }
  } catch (e: any) {
    console.error(e)
    showToastMessage(e.response?.data?.message || '取消报名失败', 'error')
  } finally {
    cancelingId.value = null
  }
}

onMounted(() => {
  fetchRegistrations()
})
</script>

<template>
  <Card>
    <CardHeader>
      <CardTitle>报名状态追踪</CardTitle>
    </CardHeader>
    <CardContent>
      <div class="relative w-full overflow-auto">
        <table class="w-full caption-bottom text-sm text-left">
          <thead class="[&_tr]:border-b">
            <tr class="border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted">
              <th class="h-12 px-4 align-middle font-medium text-slate-500">活动编号</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">活动名称</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">活动时间</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">活动地点</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">报名状态</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">操作</th> </tr>
          </thead>
          <tbody class="[&_tr:last-child]:border-0">
            <tr v-if="loading">
              <td colspan="6" class="p-4 text-center text-slate-500">加载中...</td>
            </tr>
            <tr v-else-if="registrations.length === 0">
              <td colspan="6" class="p-4 text-center text-slate-500">暂无报名记录</td>
            </tr>
            <tr v-else v-for="item in registrations" :key="item.activityId" class="border-b transition-colors hover:bg-slate-100/50">
            <td class="p-4 align-middle font-medium">{{ item.activityId }}</td>
            <td class="p-4 align-middle">{{ item.activityName }}</td>
            <td class="p-4 align-middle text-slate-600">{{ item.activityTime || '未设置' }}</td>
            <td class="p-4 align-middle text-slate-600">{{ item.activityLocation || '未设置' }}</td>
            <td class="p-4 align-middle">
              <span
                :class="
                  item.status === '已审核通过'
                    ? 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800'
                    : item.status === '已拒绝'
                      ? 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800'
                      : 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800'
                "
              >
                {{ item.status || '未审核' }}
              </span>
            </td>
            <td class="p-4 align-middle">
              <button
                v-if="item.status === '已拒绝'"
                @click="openRejectModal(item.auditReason)"
                class="text-sm font-medium text-slate-600 hover:text-slate-800 hover:underline"
              >
                查看拒绝原因
              </button>
              <button
                v-else-if="item.status === '已审核通过'"
                @click="openDetailModal(item)"
                class="text-sm font-medium text-blue-600 hover:text-blue-800 hover:underline"
              >
                查看活动详情
              </button>
              <button
                v-else
                @click="cancelRegistration(item.activityId)"
                :disabled="cancelingId === item.activityId"
                class="text-sm font-medium text-red-600 hover:text-red-800 hover:underline disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {{ cancelingId === item.activityId ? '取消中...' : '取消报名' }}
              </button>
            </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- 驳回原因弹窗 -->
      <div
        v-if="showRejectModal"
        class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 px-4"
        @click.self="closeRejectModal"
      >
        <div class="w-full max-w-md rounded-lg bg-white shadow-xl">
          <div class="flex items-center justify-between border-b px-4 py-3">
            <h3 class="text-base font-semibold text-slate-800">拒绝原因</h3>
            <button
              class="text-slate-500 hover:text-slate-700"
              aria-label="关闭"
              @click="closeRejectModal"
            >
              ✕
            </button>
          </div>
          <div class="px-4 py-5 text-sm text-slate-700 whitespace-pre-line">
            {{ rejectReason }}
          </div>
          <div class="flex justify-end border-t px-4 py-3">
            <button
              class="rounded bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700"
              @click="closeRejectModal"
            >
              知道了
            </button>
          </div>
        </div>
      </div>

      <!-- 活动详情弹窗 -->
      <div
        v-if="showDetailModal && detailItem"
        class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 px-4"
        @click.self="closeDetailModal"
      >
        <div class="w-full max-w-lg rounded-lg bg-white shadow-xl">
          <div class="flex items-center justify-between border-b px-4 py-3">
            <h3 class="text-base font-semibold text-slate-800">活动详情</h3>
            <button class="text-slate-500 hover:text-slate-700" aria-label="关闭" @click="closeDetailModal">✕</button>
          </div>
          <div class="px-4 py-4 space-y-2 text-sm text-slate-700">
            <p><span class="font-semibold">活动编号：</span>{{ detailItem.hdBh ?? '-' }}</p>
            <p><span class="font-semibold">活动名称：</span>{{ detailItem.hdMc || '-' }}</p>
            <p><span class="font-semibold">活动状态：</span>{{ detailItem.hdZt || '-' }}</p>
            <p><span class="font-semibold">发布状态：</span>{{ detailItem.fbZt || '-' }}</p>
            <p><span class="font-semibold">报名开始：</span>{{ detailItem.bmKssj || '-' }}</p>
            <p><span class="font-semibold">报名结束：</span>{{ detailItem.bmJssj || '-' }}</p>
            <p><span class="font-semibold">活动开始：</span>{{ detailItem.hdKssj || '-' }}</p>
            <p><span class="font-semibold">活动结束：</span>{{ detailItem.hdJssj || '-' }}</p>
            <p><span class="font-semibold">活动时间：</span>{{ detailItem.hdSj || '-' }}</p>
            <p><span class="font-semibold">活动地点：</span>{{ detailItem.hdDd || '-' }}</p>
            <p><span class="font-semibold">发起单位：</span>{{ detailItem.hdFqDw || '-' }}</p>
            <p><span class="font-semibold">招募人数：</span>{{ detailItem.zmRs ?? '-' }}</p>
            <p><span class="font-semibold">已报名人数：</span>{{ detailItem.ybmRs ?? '-' }}</p>
            <p><span class="font-semibold">活动内容：</span>{{ detailItem.hdNr || '-' }}</p>
            <p><span class="font-semibold">活动需求：</span>{{ detailItem.hdXq || '-' }}</p>
            <p><span class="font-semibold">活动保障：</span>{{ detailItem.hdBz || '-' }}</p>
            <p><span class="font-semibold">活动标签：</span>{{ detailItem.hdBq || '-' }}</p>
            <p><span class="font-semibold">技能要求：</span>{{ detailItem.jnYq || '-' }}</p>
            <p><span class="font-semibold">专业限制：</span>{{ detailItem.zyXz || '-' }}</p>
          </div>
          <div class="flex justify-end border-t px-4 py-3">
            <button class="rounded bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700" @click="closeDetailModal">
              知道了
            </button>
          </div>
        </div>
      </div>
    </CardContent>
  </Card>
</template>
