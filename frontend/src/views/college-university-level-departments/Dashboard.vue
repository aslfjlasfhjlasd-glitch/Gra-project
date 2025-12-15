<script setup>
import { ref, defineAsyncComponent, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import {
  LayoutDashboard,
  ClipboardEdit,
  Users,
  Award,
  Settings,
  LogOut,
  ChevronDown,
  ChevronRight,
  FileText,
  ClipboardCheck,
  Clock,
  Star,
  FileCheck,
  GraduationCap
} from 'lucide-vue-next'
import Button from '@/components/ui/button/button.vue'
import { Card, CardContent } from '@/components/ui/card'

// 异步加载组件 - 数据可视化大屏直接使用学生端组件
const DashboardHome = defineAsyncComponent(() => import('@/views/student/components/DashboardHome.vue'))
const ActivityDesign = defineAsyncComponent(() => import('./components/ActivityDesign.vue'))
const LeavePermit = defineAsyncComponent(() => import('./components/LeavePermit.vue'))
const AttendanceManagement = defineAsyncComponent(() => import('./components/AttendanceManagement.vue'))
const WorkHoursConfirm = defineAsyncComponent(() => import('./components/WorkHoursConfirm.vue'))
const VolunteerEvaluation = defineAsyncComponent(() => import('./components/VolunteerEvaluation.vue'))
const CertificateExport = defineAsyncComponent(() => import('./components/CertificateExport.vue'))
const InfoMaintenance = defineAsyncComponent(() => import('./components/InfoMaintenance.vue'))

const router = useRouter()

// 状态管理
const isVolunteerManagementOpen = ref(false)
const isEvaluationOpen = ref(false)
const activeMenu = ref('dashboard')

// 从localStorage获取用户信息
const headName = ref(localStorage.getItem('headName') || '负责人')
const headDepartment = ref(localStorage.getItem('headDepartment') || '')

// 组件挂载时检查登录状态
onMounted(() => {
  const storedName = localStorage.getItem('headName')
  const storedDepartment = localStorage.getItem('headDepartment')
  
  if (storedName) {
    headName.value = storedName
  }
  if (storedDepartment) {
    headDepartment.value = storedDepartment
  }
  
  const userRole = localStorage.getItem('userRole')
  if (!userRole || userRole !== 'head') {
    router.push('/')
  }
})

const toggleVolunteerManagement = () => {
  isVolunteerManagementOpen.value = !isVolunteerManagementOpen.value
}

const toggleEvaluation = () => {
  isEvaluationOpen.value = !isEvaluationOpen.value
}

const handleMenuClick = (menuKey) => {
  activeMenu.value = menuKey
}

const handleLogout = () => {
  if (confirm('确定要退出登录吗？')) {
    localStorage.removeItem('headName')
    localStorage.removeItem('headDepartment')
    localStorage.removeItem('headUsername')
    localStorage.removeItem('userRole')
    router.push('/')
  }
}
</script>

<template>
  <div class="flex h-screen w-full bg-slate-50">
    <aside class="w-[240px] bg-slate-900 text-slate-300 flex flex-col h-full shrink-0 z-30 shadow-xl transition-all duration-300">
      <div class="h-16 flex items-center gap-3 px-6 border-b border-slate-800 bg-slate-900/50 backdrop-blur-sm">
        <div class="bg-teal-600 p-1.5 rounded-lg shadow-lg shadow-teal-900/20">
          <GraduationCap class="w-5 h-5 text-white" />
        </div>
        <h1 class="text-base font-bold text-white tracking-wide">负责人管理端</h1>
      </div>

      <nav class="flex-1 py-6 px-3 space-y-1.5 overflow-y-auto custom-scrollbar">
        <button @click="handleMenuClick('dashboard')" :class="['w-full flex items-center gap-3 px-4 py-3 rounded-lg text-sm font-medium transition-all duration-200 group', activeMenu === 'dashboard' ? 'bg-teal-600 text-white shadow-md shadow-teal-900/20' : 'text-slate-400 hover:bg-slate-800 hover:text-white']">
          <LayoutDashboard class="w-4 h-4 transition-colors group-hover:text-white" :class="activeMenu === 'dashboard' ? 'text-white' : 'text-slate-400'" />
          数据可视化大屏
        </button>

        <button @click="handleMenuClick('activity-design')" :class="['w-full flex items-center gap-3 px-4 py-3 rounded-lg text-sm font-medium transition-all duration-200 group', activeMenu === 'activity-design' ? 'bg-teal-600 text-white shadow-md shadow-teal-900/20' : 'text-slate-400 hover:bg-slate-800 hover:text-white']">
          <ClipboardEdit class="w-4 h-4 transition-colors group-hover:text-white" :class="activeMenu === 'activity-design' ? 'text-white' : 'text-slate-400'" />
          志愿活动设计
        </button>

        <div class="space-y-1">
          <button @click="toggleVolunteerManagement" :class="['w-full flex items-center justify-between px-4 py-3 rounded-lg text-sm font-medium transition-all duration-200 group', activeMenu.startsWith('volunteer-') ? 'bg-slate-800 text-white' : 'text-slate-400 hover:bg-slate-800 hover:text-white']">
            <div class="flex items-center gap-3">
              <Users class="w-4 h-4 transition-colors group-hover:text-white" :class="activeMenu.startsWith('volunteer-') ? 'text-white' : 'text-slate-400'" />
              志愿者管理
            </div>
            <component :is="isVolunteerManagementOpen ? ChevronDown : ChevronRight" class="w-4 h-4 text-slate-500 transition-colors group-hover:text-slate-300" />
          </button>

          <div v-show="isVolunteerManagementOpen" class="pl-4 space-y-1 mt-1">
            <button @click="handleMenuClick('volunteer-leave')" :class="['w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm transition-all duration-200 border-l-2 ml-2', activeMenu === 'volunteer-leave' ? 'border-teal-500 text-teal-400 bg-slate-800/50' : 'border-transparent text-slate-500 hover:text-slate-300 hover:border-slate-600']">
              <FileText class="w-3.5 h-3.5" />
              公假单出具
            </button>
            <button @click="handleMenuClick('volunteer-attendance')" :class="['w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm transition-all duration-200 border-l-2 ml-2', activeMenu === 'volunteer-attendance' ? 'border-teal-500 text-teal-400 bg-slate-800/50' : 'border-transparent text-slate-500 hover:text-slate-300 hover:border-slate-600']">
              <ClipboardCheck class="w-3.5 h-3.5" />
              考勤管理
            </button>
            <button @click="handleMenuClick('volunteer-workhours')" :class="['w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm transition-all duration-200 border-l-2 ml-2', activeMenu === 'volunteer-workhours' ? 'border-teal-500 text-teal-400 bg-slate-800/50' : 'border-transparent text-slate-500 hover:text-slate-300 hover:border-slate-600']">
              <Clock class="w-3.5 h-3.5" />
              工时学分确认
            </button>
          </div>
        </div>

        <div class="space-y-1">
          <button @click="toggleEvaluation" :class="['w-full flex items-center justify-between px-4 py-3 rounded-lg text-sm font-medium transition-all duration-200 group', activeMenu.startsWith('evaluation-') ? 'bg-slate-800 text-white' : 'text-slate-400 hover:bg-slate-800 hover:text-white']">
            <div class="flex items-center gap-3">
              <Award class="w-4 h-4 transition-colors group-hover:text-white" :class="activeMenu.startsWith('evaluation-') ? 'text-white' : 'text-slate-400'" />
              评价与认证
            </div>
            <component :is="isEvaluationOpen ? ChevronDown : ChevronRight" class="w-4 h-4 text-slate-500 transition-colors group-hover:text-slate-300" />
          </button>

          <div v-show="isEvaluationOpen" class="pl-4 space-y-1 mt-1">
            <button @click="handleMenuClick('evaluation-volunteer')" :class="['w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm transition-all duration-200 border-l-2 ml-2', activeMenu === 'evaluation-volunteer' ? 'border-teal-500 text-teal-400 bg-slate-800/50' : 'border-transparent text-slate-500 hover:text-slate-300 hover:border-slate-600']">
              <Star class="w-3.5 h-3.5" />
              志愿者评价
            </button>
            <button @click="handleMenuClick('evaluation-certificate')" :class="['w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm transition-all duration-200 border-l-2 ml-2', activeMenu === 'evaluation-certificate' ? 'border-teal-500 text-teal-400 bg-slate-800/50' : 'border-transparent text-slate-500 hover:text-slate-300 hover:border-slate-600']">
              <FileCheck class="w-3.5 h-3.5" />
              志愿活动证明确认
            </button>
          </div>
        </div>

        <button @click="handleMenuClick('info-maintenance')" :class="['w-full flex items-center gap-3 px-4 py-3 rounded-lg text-sm font-medium transition-all duration-200 group', activeMenu === 'info-maintenance' ? 'bg-teal-600 text-white shadow-md shadow-teal-900/20' : 'text-slate-400 hover:bg-slate-800 hover:text-white']">
          <Settings class="w-4 h-4 transition-colors group-hover:text-white" :class="activeMenu === 'info-maintenance' ? 'text-white' : 'text-slate-400'" />
          信息维护
        </button>
      </nav>
      
      <div class="p-6 border-t border-slate-800 bg-slate-900/50">
        <div class="flex flex-col gap-2">
          <p class="text-xs text-slate-500 font-medium">© 2025 高校志愿平台</p>
          <p class="text-[10px] text-slate-600">负责人管理端 v1.0.0</p>
        </div>
      </div>
    </aside>

    <div class="flex flex-col flex-1 overflow-hidden bg-slate-50">
      <header class="h-16 bg-white border-b border-slate-200 flex items-center justify-between px-8 shadow-sm z-20">
        <div class="flex items-center">
          <h2 class="text-lg font-semibold text-slate-800 tracking-tight">
             {{ 
              activeMenu === 'dashboard' ? '数据可视化大屏' :
              activeMenu === 'activity-design' ? '志愿活动设计' :
              activeMenu === 'volunteer-leave' ? '志愿者管理 / 公假单出具' :
              activeMenu === 'volunteer-attendance' ? '志愿者管理 / 考勤管理' :
              activeMenu === 'volunteer-workhours' ? '志愿者管理 / 工时学分确认' :
              activeMenu === 'evaluation-volunteer' ? '评价与认证 / 志愿者评价' :
              activeMenu === 'evaluation-certificate' ? '评价与认证 / 志愿活动证明确认' :
              activeMenu === 'info-maintenance' ? '信息维护' : '欢迎'
            }}
          </h2>
        </div>

        <div class="flex items-center gap-6">
          <div class="flex items-center gap-3 pl-4 border-l border-slate-100">
            <div class="flex flex-col items-end mr-1">
              <span class="text-sm font-semibold text-slate-700">{{ headName }}</span>
              <span class="text-xs text-slate-400">{{ headDepartment || '负责人账号' }}</span>
            </div>
            <div class="w-9 h-9 rounded-full bg-teal-50 flex items-center justify-center text-teal-600 font-bold text-sm border-2 border-white shadow-sm ring-1 ring-slate-100">
              {{ headName.charAt(0) }}
            </div>
          </div>
          
          <Button variant="ghost" size="sm" class="text-slate-500 hover:text-red-600 hover:bg-red-50 gap-2 px-3 transition-colors" @click="handleLogout">
            <LogOut class="w-4 h-4" />
            <span class="font-medium text-xs">退出</span>
          </Button>
        </div>
      </header>

      <main class="flex-1 overflow-auto p-8">
  <div class="max-w-7xl mx-auto space-y-8">
    
    <Transition name="fade" mode="out-in">
      <div v-if="activeMenu === 'dashboard'">
        <DashboardHome />
      </div>
      <ActivityDesign v-else-if="activeMenu === 'activity-design'" />
      <LeavePermit v-else-if="activeMenu === 'volunteer-leave'" />
      <AttendanceManagement v-else-if="activeMenu === 'volunteer-attendance'" />
      <WorkHoursConfirm v-else-if="activeMenu === 'volunteer-workhours'" />
      <VolunteerEvaluation v-else-if="activeMenu === 'evaluation-volunteer'" />
      <CertificateExport v-else-if="activeMenu === 'evaluation-certificate'" />
      <InfoMaintenance v-else-if="activeMenu === 'info-maintenance'" />
      <div v-else class="grid gap-6">
        <Card class="bg-white border-slate-100 shadow-sm min-h-[300px]">
          <CardContent class="p-12 text-slate-400 text-center">模块建设中</CardContent>
        </Card>
      </div>
    </Transition>

  </div>
</main>
    </div>
  </div>
</template>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #334155;
  border-radius: 4px;
}
.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: #475569;
}
</style>