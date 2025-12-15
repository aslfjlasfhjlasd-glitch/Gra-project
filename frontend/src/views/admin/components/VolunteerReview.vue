<script setup>
import { ref, onMounted, computed } from 'vue';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import Button from '@/components/ui/button/button.vue';
import Badge from '@/components/ui/badge/Badge.vue';
import Textarea from '@/components/ui/textarea/Textarea.vue';
import { UserCheck, Eye, CheckCircle, XCircle, Phone, Mail, Users, BookOpen, Award, AlertCircle, Loader2 } from 'lucide-vue-next';
import { getVolunteerReviews, approveVolunteerRegistration, rejectVolunteerRegistration } from '@/api/admin';

// 状态管理
const reviews = ref([]);
const loading = ref(false);
const selectedReview = ref(null);
const isDetailOpen = ref(false);
const isRejectDialogOpen = ref(false);
const rejectReason = ref('');
const processingId = ref(null);
const successMessage = ref('');
const errorMessage = ref('');

// 筛选状态
const filterStatus = ref('未审核');
const statusOptions = ['全部', '未审核', '已审核通过', '已拒绝'];

// 过滤后的审核列表
const filteredReviews = computed(() => {
  if (filterStatus.value === '全部') {
    return reviews.value;
  }
  return reviews.value.filter(r => r.status === filterStatus.value);
});

// 统计信息
const statistics = computed(() => {
  return {
    total: reviews.value.length,
    pending: reviews.value.filter(r => r.status === '未审核').length,
    approved: reviews.value.filter(r => r.status === '已审核通过').length,
    rejected: reviews.value.filter(r => r.status === '已拒绝').length
  };
});

// 获取审核列表（获取所有状态，前端筛选）
const fetchReviews = async () => {
  loading.value = true;
  errorMessage.value = '';
  try {
    const response = await getVolunteerReviews(''); // 传空字符串获取所有状态
    if (response.data.code === 200) {
      reviews.value = response.data.data || [];
    } else {
      errorMessage.value = response.data.message || '获取审核列表失败';
    }
  } catch (error) {
    console.error('获取审核列表失败:', error);
    errorMessage.value = '网络错误，请稍后重试';
  } finally {
    loading.value = false;
  }
};

// 显示消息并自动隐藏
const showMessage = (type, message) => {
  if (type === 'success') {
    successMessage.value = message;
    errorMessage.value = '';
  } else {
    errorMessage.value = message;
    successMessage.value = '';
  }
  
  setTimeout(() => {
    successMessage.value = '';
    errorMessage.value = '';
  }, 3000);
};

// 格式化时间
const formatDate = (dateString) => {
  if (!dateString) return '-';
  const date = new Date(dateString);
  return date.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  });
};

// 获取状态对应的Badge样式
const getStatusClass = (status) => {
  const statusMap = {
    '未审核': 'bg-yellow-100 text-yellow-700 border-yellow-200',
    '已审核通过': 'bg-green-100 text-green-700 border-green-200',
    '已拒绝': 'bg-red-100 text-red-700 border-red-200'
  };
  return statusMap[status] || 'bg-slate-100 text-slate-700 border-slate-200';
};

// 打开学生详情
const openStudentDetail = (review) => {
  selectedReview.value = review;
  isDetailOpen.value = true;
};

// 关闭详情弹窗
const closeDetailDialog = () => {
  isDetailOpen.value = false;
  setTimeout(() => {
    selectedReview.value = null;
  }, 200);
};

// 打开拒绝对话框
const openRejectDialog = (review) => {
  // 如果是从详情弹窗打开，先关闭详情弹窗
  if (isDetailOpen.value) {
    isDetailOpen.value = false;
  }
  selectedReview.value = review;
  isRejectDialogOpen.value = true;
  rejectReason.value = '';
};

// 关闭拒绝对话框
const closeRejectDialog = () => {
  isRejectDialogOpen.value = false;
  setTimeout(() => {
    selectedReview.value = null;
    rejectReason.value = '';
  }, 200);
};

// 审核通过
const handleApprove = async (review) => {
  if (!confirm(`确定通过 ${review.studentName} 对活动"${review.activityName}"的报名申请吗？`)) {
    return;
  }
  
  processingId.value = review.id;
  try {
    const response = await approveVolunteerRegistration(review.id);
    if (response.data.code === 200) {
      // 更新本地状态
      const index = reviews.value.findIndex(r => r.id === review.id);
      if (index !== -1) {
        reviews.value[index].status = '已审核通过';
      }
      showMessage('success', '审核通过成功');
      closeDetailDialog();
    } else {
      showMessage('error', response.data.message || '审核失败');
    }
  } catch (error) {
    console.error('审核通过失败:', error);
    showMessage('error', '网络错误，请稍后重试');
  } finally {
    processingId.value = null;
  }
};

// 审核拒绝
const handleReject = async () => {
  if (!rejectReason.value.trim()) {
    showMessage('error', '请输入拒绝原因');
    return;
  }
  
  processingId.value = selectedReview.value.id;
  try {
    const response = await rejectVolunteerRegistration(selectedReview.value.id, rejectReason.value);
    if (response.data.code === 200) {
      // 更新本地状态
      const index = reviews.value.findIndex(r => r.id === selectedReview.value.id);
      if (index !== -1) {
        reviews.value[index].status = '已拒绝';
        reviews.value[index].auditReason = rejectReason.value;
      }
      showMessage('success', '已拒绝该申请');
      closeRejectDialog();
      closeDetailDialog();
    } else {
      showMessage('error', response.data.message || '操作失败');
    }
  } catch (error) {
    console.error('审核拒绝失败:', error);
    showMessage('error', '网络错误，请稍后重试');
  } finally {
    processingId.value = null;
  }
};

// 组件挂载时获取数据
onMounted(() => {
  fetchReviews();
});
</script>

<template>
  <div class="space-y-6">
    <!-- 页头 -->
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-3xl font-bold tracking-tight text-slate-900">志愿者审核</h1>
        <p class="text-slate-500 mt-1">审核志愿者报名申请，查看学生详细资料</p>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
      <Card>
        <CardContent class="pt-6">
          <div class="text-center">
            <p class="text-3xl font-bold text-blue-600">{{ statistics.total }}</p>
            <p class="text-sm text-slate-600 mt-1">总申请数</p>
          </div>
        </CardContent>
      </Card>
      <Card>
        <CardContent class="pt-6">
          <div class="text-center">
            <p class="text-3xl font-bold text-yellow-600">{{ statistics.pending }}</p>
            <p class="text-sm text-slate-600 mt-1">待审核</p>
          </div>
        </CardContent>
      </Card>
      <Card>
        <CardContent class="pt-6">
          <div class="text-center">
            <p class="text-3xl font-bold text-green-600">{{ statistics.approved }}</p>
            <p class="text-sm text-slate-600 mt-1">已通过</p>
          </div>
        </CardContent>
      </Card>
      <Card>
        <CardContent class="pt-6">
          <div class="text-center">
            <p class="text-3xl font-bold text-red-600">{{ statistics.rejected }}</p>
            <p class="text-sm text-slate-600 mt-1">已拒绝</p>
          </div>
        </CardContent>
      </Card>
    </div>

    <!-- 成功提示 -->
    <div v-if="successMessage" class="bg-green-50 border border-green-200 rounded-lg p-4 flex items-start gap-3">
      <CheckCircle class="w-5 h-5 text-green-600 flex-shrink-0 mt-0.5" />
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

    <!-- 审核列表 -->
    <Card>
      <CardHeader>
        <div class="flex items-center justify-between">
          <CardTitle class="flex items-center gap-2">
            <UserCheck class="h-5 w-5" />
            审核列表
          </CardTitle>
          <div class="flex items-center gap-2">
            <span class="text-sm text-slate-600">筛选：</span>
            <select 
              v-model="filterStatus" 
              class="px-3 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option v-for="status in statusOptions" :key="status" :value="status">
                {{ status }}
              </option>
            </select>
          </div>
        </div>
      </CardHeader>
      <CardContent>
        <div v-if="loading" class="flex flex-col items-center justify-center py-12">
          <Loader2 class="w-8 h-8 text-blue-600 animate-spin mb-3" />
          <p class="text-slate-500">加载中...</p>
        </div>
        <div v-else-if="filteredReviews.length === 0" class="text-center py-12 text-slate-400">
          <UserCheck class="w-12 h-12 mx-auto mb-3 text-slate-300" />
          <p class="text-lg mb-2">暂无审核记录</p>
          <p class="text-sm">当学生报名活动后，审核记录将显示在此处</p>
        </div>
        <div v-else class="overflow-x-auto">
          <table class="w-full">
            <thead>
              <tr class="border-b border-slate-200 bg-slate-50">
                <th class="text-left py-3 px-4 font-semibold text-slate-700">姓名</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">活动名称</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">报名时间</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">状态</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">操作</th>
              </tr>
            </thead>
            <tbody>
              <tr 
                v-for="review in filteredReviews" 
                :key="review.id" 
                class="border-b border-slate-100 hover:bg-slate-50 transition-colors"
              >
                <td class="py-3 px-4">
                  <button
                    @click="openStudentDetail(review)"
                    class="text-blue-600 hover:text-blue-800 hover:underline font-medium focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 rounded"
                  >
                    {{ review.studentName }}
                  </button>
                </td>
                <td class="py-3 px-4 text-slate-700">{{ review.activityName }}</td>
                <td class="py-3 px-4 text-sm text-slate-600">{{ formatDate(review.registerTime) }}</td>
                <td class="py-3 px-4">
                  <span :class="['px-3 py-1 rounded-full text-xs font-medium border', getStatusClass(review.status)]">
                    {{ review.status }}
                  </span>
                </td>
                <td class="py-3 px-4">
                  <div class="flex gap-2">
                    <Button 
                      v-if="review.status === '未审核'"
                      size="sm"
                      class="gap-1"
                      :disabled="processingId === review.id"
                      @click="handleApprove(review)"
                    >
                      <CheckCircle v-if="processingId !== review.id" class="w-4 h-4" />
                      <Loader2 v-else class="w-4 h-4 animate-spin" />
                      {{ processingId === review.id ? '处理中...' : '通过' }}
                    </Button>
                    <Button 
                      v-if="review.status === '未审核'"
                      variant="outline"
                      size="sm"
                      class="gap-1 text-red-600 hover:text-red-700 border-red-200 hover:border-red-300"
                      :disabled="processingId === review.id"
                      @click="openRejectDialog(review)"
                    >
                      <XCircle class="w-4 h-4" />
                      拒绝
                    </Button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </CardContent>
    </Card>

    <!-- 学生详情弹窗 -->
    <div v-if="isDetailOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div class="bg-white rounded-lg shadow-xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-slate-200 px-6 py-4 flex justify-between items-center">
          <div class="flex items-center gap-3">
            <UserCheck class="w-6 h-6 text-blue-600" />
            <h3 class="text-xl font-semibold text-slate-900">{{ selectedReview?.studentName }} - 详细资料</h3>
          </div>
          <button @click="closeDetailDialog" class="text-slate-400 hover:text-slate-600 transition-colors">
            <XCircle class="w-6 h-6" />
          </button>
        </div>

        <div v-if="selectedReview" class="p-6 space-y-6">
          <!-- 基本信息卡片 -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- 学生基本信息 -->
            <Card>
              <CardHeader>
                <CardTitle class="text-base flex items-center gap-2">
                  <Users class="w-4 h-4" />
                  学生基本信息
                </CardTitle>
              </CardHeader>
              <CardContent class="space-y-3">
                <div class="flex items-start justify-between py-2 border-b border-slate-100">
                  <span class="text-sm text-slate-500 w-24">学号</span>
                  <span class="text-sm font-medium text-slate-900">{{ selectedReview.studentId }}</span>
                </div>
                <div class="flex items-start justify-between py-2 border-b border-slate-100">
                  <span class="text-sm text-slate-500 w-24">姓名</span>
                  <span class="text-sm font-medium text-slate-900">{{ selectedReview.studentName }}</span>
                </div>
                <div class="flex items-start justify-between py-2 border-b border-slate-100">
                  <span class="text-sm text-slate-500 w-24">学院</span>
                  <span class="text-sm font-medium text-slate-900">{{ selectedReview.college }}</span>
                </div>
                <div class="flex items-start justify-between py-2 border-b border-slate-100">
                  <span class="text-sm text-slate-500 w-24">班级</span>
                  <span class="text-sm font-medium text-slate-900">{{ selectedReview.className }}</span>
                </div>
                <div class="flex items-start justify-between py-2 border-b border-slate-100">
                  <span class="text-sm text-slate-500 w-24 flex items-center gap-1">
                    <Phone class="w-3 h-3" />
                    电话
                  </span>
                  <span class="text-sm font-medium text-slate-900">{{ selectedReview.phone }}</span>
                </div>
                <div class="flex items-start justify-between py-2 border-b border-slate-100">
                  <span class="text-sm text-slate-500 w-24">政治面貌</span>
                  <span class="text-sm font-medium text-slate-900">{{ selectedReview.politic }}</span>
                </div>
                
                <!-- 兴趣标签 -->
                <div v-if="selectedReview.interests" class="pt-2 border-t border-slate-200">
                  <div class="flex items-start gap-2 py-2">
                    <span class="text-sm text-slate-500 w-24 flex items-center gap-1">
                      <BookOpen class="w-3 h-3" />
                      兴趣标签
                    </span>
                    <div class="flex-1 flex flex-wrap gap-1.5">
                      <span
                        v-for="(interest, idx) in selectedReview.interests.split(',')"
                        :key="idx"
                        class="px-2 py-0.5 bg-blue-50 text-blue-700 border border-blue-200 rounded-full text-xs"
                      >
                        {{ interest.trim() }}
                      </span>
                    </div>
                  </div>
                </div>
                
                <!-- 技能标签 -->
                <div v-if="selectedReview.skills" class="border-t border-slate-100">
                  <div class="flex items-start gap-2 py-2">
                    <span class="text-sm text-slate-500 w-24 flex items-center gap-1">
                      <Award class="w-3 h-3" />
                      技能标签
                    </span>
                    <div class="flex-1 flex flex-wrap gap-1.5">
                      <span
                        v-for="(skill, idx) in selectedReview.skills.split(',')"
                        :key="idx"
                        class="px-2 py-0.5 bg-green-50 text-green-700 border border-green-200 rounded-full text-xs"
                      >
                        {{ skill.trim() }}
                      </span>
                    </div>
                  </div>
                </div>
                
                <!-- 个人简介 -->
                <div v-if="selectedReview.introduction" class="border-t border-slate-100">
                  <div class="flex items-start gap-2 py-2">
                    <span class="text-sm text-slate-500 w-24">个人简介</span>
                    <p class="flex-1 text-sm text-slate-700 leading-relaxed">{{ selectedReview.introduction }}</p>
                  </div>
                </div>
              </CardContent>
            </Card>

            <!-- 活动信息 -->
            <Card>
              <CardHeader>
                <CardTitle class="text-base flex items-center gap-2">
                  <Award class="w-4 h-4" />
                  报名活动信息
                </CardTitle>
              </CardHeader>
              <CardContent class="space-y-3">
                <div class="flex items-start justify-between py-2 border-b border-slate-100">
                  <span class="text-sm text-slate-500 w-24">活动名称</span>
                  <span class="text-sm font-medium text-slate-900">{{ selectedReview.activityName }}</span>
                </div>
                <div class="flex items-start justify-between py-2 border-b border-slate-100">
                  <span class="text-sm text-slate-500 w-24">活动ID</span>
                  <span class="text-sm font-medium text-slate-900">{{ selectedReview.activityId }}</span>
                </div>
                <div class="flex items-start justify-between py-2 border-b border-slate-100">
                  <span class="text-sm text-slate-500 w-24">报名时间</span>
                  <span class="text-sm font-medium text-slate-900">{{ formatDate(selectedReview.registerTime) }}</span>
                </div>
                <div class="flex items-start justify-between py-2 border-b border-slate-100">
                  <span class="text-sm text-slate-500 w-24">招募人数</span>
                  <span class="text-sm font-medium text-slate-900">
                    {{ selectedReview.currentVolunteers || 0 }} / {{ selectedReview.requiredVolunteers || '不限' }}
                  </span>
                </div>
                <div class="flex items-start justify-between py-2">
                  <span class="text-sm text-slate-500 w-24">审核状态</span>
                  <span :class="['px-3 py-1 rounded-full text-xs font-medium border', getStatusClass(selectedReview.status)]">
                    {{ selectedReview.status }}
                  </span>
                </div>
              </CardContent>
            </Card>
          </div>


          <!-- 审核备注（如果已拒绝） -->
          <Card v-if="selectedReview.auditReason" class="border-red-200 bg-red-50">
            <CardHeader>
              <CardTitle class="text-base text-red-800">拒绝原因</CardTitle>
            </CardHeader>
            <CardContent>
              <p class="text-sm text-red-700">{{ selectedReview.auditReason }}</p>
            </CardContent>
          </Card>
        </div>

        <!-- 弹窗底部操作按钮 -->
        <div class="sticky bottom-0 bg-slate-50 border-t border-slate-200 px-6 py-4">
          <div v-if="selectedReview?.status === '未审核'" class="flex justify-end gap-3">
            <Button 
              variant="outline" 
              @click="closeDetailDialog"
              :disabled="processingId === selectedReview.id"
            >
              关闭
            </Button>
            <Button 
              variant="outline"
              class="gap-2 text-red-600 hover:text-red-700 border-red-200 hover:border-red-300 hover:bg-red-50"
              :disabled="processingId === selectedReview.id"
              @click="openRejectDialog(selectedReview)"
            >
              <XCircle class="w-4 h-4" />
              拒绝申请
            </Button>
            <Button 
              class="gap-2"
              :disabled="processingId === selectedReview.id"
              @click="handleApprove(selectedReview)"
            >
              <CheckCircle v-if="processingId !== selectedReview.id" class="w-4 h-4" />
              <Loader2 v-else class="w-4 h-4 animate-spin" />
              {{ processingId === selectedReview.id ? '处理中...' : '通过审核' }}
            </Button>
          </div>
          <div v-else class="flex justify-end">
            <Button 
              variant="outline" 
              @click="closeDetailDialog"
            >
              关闭
            </Button>
          </div>
        </div>
      </div>
    </div>

    <!-- 拒绝原因输入弹窗 -->
    <div v-if="isRejectDialogOpen" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div class="bg-white rounded-lg shadow-xl max-w-md w-full">
        <div class="border-b border-slate-200 px-6 py-4">
          <h3 class="text-lg font-semibold text-slate-900">拒绝申请</h3>
        </div>
        <div class="p-6 space-y-4">
          <p class="text-sm text-slate-600">请输入拒绝 <span class="font-semibold text-slate-900">{{ selectedReview?.studentName }}</span> 申请的原因：</p>
          <textarea
            v-model="rejectReason"
            class="w-full px-3 py-2 border border-slate-300 rounded-md focus:outline-none focus:ring-2 focus:ring-red-500 text-sm"
            rows="4"
            placeholder="例如：不符合活动要求、名额已满、技能不匹配等..."
          ></textarea>
        </div>
        <div class="bg-slate-50 border-t border-slate-200 px-6 py-4 flex justify-end gap-3">
          <Button 
            variant="outline" 
            @click="closeRejectDialog"
            :disabled="processingId === selectedReview?.id"
          >
            取消
          </Button>
          <Button 
            class="gap-2 bg-red-600 hover:bg-red-700"
            :disabled="processingId === selectedReview?.id || !rejectReason.trim()"
            @click="handleReject"
          >
            <XCircle v-if="processingId !== selectedReview?.id" class="w-4 h-4" />
            <Loader2 v-else class="w-4 h-4 animate-spin" />
            {{ processingId === selectedReview?.id ? '处理中...' : '确认拒绝' }}
          </Button>
        </div>
      </div>
    </div>
  </div>
</template>