<script setup>
import { ref, defineAsyncComponent, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import {
  LayoutDashboard,
  Tent,
  Activity,
  User,
  LogOut,
  ChevronDown,
  ChevronRight,
  ClipboardList,
  BarChart3,
  GraduationCap,
  FileText
} from 'lucide-vue-next'
import Button from '@/components/ui/button/button.vue'
import { Card, CardContent } from '@/components/ui/card'
const DashboardHome = defineAsyncComponent(() => import('./components/DashboardHome.vue'))
const ActivityHall = defineAsyncComponent(() => import('./components/ActivityHall.vue'))
const RegistrationStatus = defineAsyncComponent(() => import('./components/RegistrationStatus.vue'))
const ActivityPerformance = defineAsyncComponent(() => import('./components/ActivityPerformance.vue'))
const Profile = defineAsyncComponent(() => import('./components/Profile.vue'))
const LeaveDownload = defineAsyncComponent(() => import('./components/LeaveDownload.vue'))
const CertificateDownload = defineAsyncComponent(() => import('./components/CertificateDownload.vue'))

const router = useRouter()

// 状态管理
const isActivitiesOpen = ref(false) // 活动全流程菜单展开状态
const activeMenu = ref('dashboard') // 当前激活的菜单项
const isTransitioning = ref(false) // 过渡状态标记

// 从localStorage获取用户信息
const studentName = ref(localStorage.getItem('studentName') || '学生')

// 组件挂载时检查登录状态
onMounted(() => {
  const userRole = localStorage.getItem('userRole')
  const studentId = localStorage.getItem('studentId')
  
  // 检查学生登录状态
  if (!userRole || userRole !== 'student' || !studentId) {
    alert('登录信息失效或缺失，请重新登录')
    router.push('/')
  }
})

// 切换子菜单展开/收起
const toggleActivities = () => {
  isActivitiesOpen.value = !isActivitiesOpen.value
}

// 防抖定时器
let debounceTimer = null

// 菜单点击处理（添加防抖）
const handleMenuClick = (menuKey) => {
  // 如果正在过渡中，忽略点击
  if (isTransitioning.value) {
    return
  }
  
  // 如果点击的是当前菜单，不做任何操作
  if (activeMenu.value === menuKey) {
    return
  }
  
  // 清除之前的定时器
  if (debounceTimer) {
    clearTimeout(debounceTimer)
  }
  
  // 设置过渡状态
  isTransitioning.value = true
  
  // 立即更新菜单
  activeMenu.value = menuKey
  
  // 300ms 后解除过渡锁定（与 CSS 过渡时间一致）
  debounceTimer = setTimeout(() => {
    isTransitioning.value = false
  }, 300)
}

// 清理定时器
onUnmounted(() => {
  if (debounceTimer) {
    clearTimeout(debounceTimer)
  }
})

// 退出登录
const handleLogout = () => {
  if (confirm('确定要退出登录吗？')) {
    router.push('/')
  }
}
</script>

<template>
  <div class="flex h-screen w-full bg-slate-50">
    
    <!-- 左侧导航菜单栏 (Sidebar) - 深色主题 -->
    <aside class="w-[240px] bg-slate-900 text-slate-300 flex flex-col h-full shrink-0 z-30 shadow-xl transition-all duration-300">
      
      <!-- Logo 区域 -->
      <div class="h-16 flex items-center gap-3 px-6 border-b border-slate-800 bg-slate-900/50 backdrop-blur-sm">
        <div class="bg-blue-600 p-1.5 rounded-lg shadow-lg shadow-blue-900/20">
          <GraduationCap class="w-5 h-5 text-white" />
        </div>
        <h1 class="text-base font-bold text-white tracking-wide">
          高校志愿管理
        </h1>
      </div>

      <!-- 导航菜单 -->
      <nav class="flex-1 py-6 px-3 space-y-1.5 overflow-y-auto custom-scrollbar">
        
        <!-- 菜单项：数据可视化大屏 -->
        <button 
          @click="handleMenuClick('dashboard')"
          :class="[
            'w-full flex items-center gap-3 px-4 py-3 rounded-lg text-sm font-medium transition-all duration-200 group',
            activeMenu === 'dashboard' 
              ? 'bg-blue-600 text-white shadow-md shadow-blue-900/20' 
              : 'text-slate-400 hover:bg-slate-800 hover:text-white'
          ]"
        >
          <LayoutDashboard class="w-4 h-4 transition-colors group-hover:text-white" :class="activeMenu === 'dashboard' ? 'text-white' : 'text-slate-400'" />
          数据可视化大屏
        </button>

        <!-- 菜单项：志愿活动大厅 -->
        <button 
          @click="handleMenuClick('hall')"
          :class="[
            'w-full flex items-center gap-3 px-4 py-3 rounded-lg text-sm font-medium transition-all duration-200 group',
            activeMenu === 'hall' 
              ? 'bg-blue-600 text-white shadow-md shadow-blue-900/20' 
              : 'text-slate-400 hover:bg-slate-800 hover:text-white'
          ]"
        >
          <Tent class="w-4 h-4 transition-colors group-hover:text-white" :class="activeMenu === 'hall' ? 'text-white' : 'text-slate-400'" />
          志愿活动大厅
        </button>

        <!-- 菜单项：活动全流程 (可展开) -->
        <div class="space-y-1">
          <button 
            @click="toggleActivities"
            :class="[
              'w-full flex items-center justify-between px-4 py-3 rounded-lg text-sm font-medium transition-all duration-200 group',
              activeMenu.startsWith('activity') 
                ? 'bg-slate-800 text-white' 
                : 'text-slate-400 hover:bg-slate-800 hover:text-white'
            ]"
          >
            <div class="flex items-center gap-3">
              <Activity class="w-4 h-4 transition-colors group-hover:text-white" :class="activeMenu.startsWith('activity') ? 'text-white' : 'text-slate-400'" />
              活动全流程
            </div>
            <component 
              :is="isActivitiesOpen ? ChevronDown : ChevronRight" 
              class="w-4 h-4 text-slate-500 transition-colors group-hover:text-slate-300"
            />
          </button>

          <!-- 子菜单 -->
          <div v-show="isActivitiesOpen" class="pl-4 space-y-1 mt-1">
            <button 
              @click="handleMenuClick('activity-status')"
              :class="[
                'w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm transition-all duration-200 border-l-2 ml-2',
                activeMenu === 'activity-status' 
                  ? 'border-blue-500 text-blue-400 bg-slate-800/50' 
                  : 'border-transparent text-slate-500 hover:text-slate-300 hover:border-slate-600'
              ]"
            >
              <ClipboardList class="w-3.5 h-3.5" />
              报名状态追踪
            </button>
            <button 
              @click="handleMenuClick('activity-performance')"
              :class="[
                'w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm transition-all duration-200 border-l-2 ml-2',
                activeMenu === 'activity-performance' 
                  ? 'border-blue-500 text-blue-400 bg-slate-800/50' 
                  : 'border-transparent text-slate-500 hover:text-slate-300 hover:border-slate-600'
              ]"
            >
              <BarChart3 class="w-3.5 h-3.5" />
              活动表现查看
            </button>
            <button 
              @click="handleMenuClick('activity-leave')"
              :class="[
                'w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm transition-all duration-200 border-l-2 ml-2',
                activeMenu === 'activity-leave' 
                  ? 'border-blue-500 text-blue-400 bg-slate-800/50' 
                  : 'border-transparent text-slate-500 hover:text-slate-300 hover:border-slate-600'
              ]"
            >
              <FileText class="w-3.5 h-3.5" />
              公假单下载
            </button>
            <button 
              @click="handleMenuClick('activity-certificate')"
              :class="[
                'w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm transition-all duration-200 border-l-2 ml-2',
                activeMenu === 'activity-certificate' 
                  ? 'border-blue-500 text-blue-400 bg-slate-800/50' 
                  : 'border-transparent text-slate-500 hover:text-slate-300 hover:border-slate-600'
              ]"
            >
              <FileText class="w-3.5 h-3.5" />
              志愿活动证明下载
            </button>
          </div>
        </div>

        <!-- 菜单项：个人信息 -->
        <button 
          @click="handleMenuClick('profile')"
          :class="[
            'w-full flex items-center gap-3 px-4 py-3 rounded-lg text-sm font-medium transition-all duration-200 group',
            activeMenu === 'profile' 
              ? 'bg-blue-600 text-white shadow-md shadow-blue-900/20' 
              : 'text-slate-400 hover:bg-slate-800 hover:text-white'
          ]"
        >
          <User class="w-4 h-4 transition-colors group-hover:text-white" :class="activeMenu === 'profile' ? 'text-white' : 'text-slate-400'" />
          个人信息
        </button>

      </nav>
      
      <!-- 底部版权信息 -->
      <div class="p-6 border-t border-slate-800 bg-slate-900/50">
        <div class="flex flex-col gap-2">
          <p class="text-xs text-slate-500 font-medium">© 2025 高校志愿平台</p>
          <p class="text-[10px] text-slate-600">版本 v1.0.0</p>
        </div>
      </div>
    </aside>

    <!-- 右侧主体区域 -->
    <div class="flex flex-col flex-1 overflow-hidden bg-slate-50">
      
      <!-- 顶部导航栏 (Header) -->
      <header class="h-16 bg-white border-b border-slate-200 flex items-center justify-between px-8 shadow-sm z-20">
        <!-- 面包屑/页面标题 -->
        <div class="flex items-center">
          <h2 class="text-lg font-semibold text-slate-800 tracking-tight">
             {{ 
              activeMenu === 'dashboard' ? '数据可视化大屏' :
              activeMenu === 'hall' ? '志愿活动大厅' :
              activeMenu === 'activity-status' ? '活动全流程 / 活动状态追踪' :
              activeMenu === 'activity-performance' ? '活动全流程 / 活动表现查看' :
              activeMenu === 'activity-leave' ? '活动全流程 / 公假单下载' :
              activeMenu === 'activity-certificate' ? '活动全流程 / 志愿活动证明下载' :
              activeMenu === 'profile' ? '个人信息' : '欢迎'
            }}
          </h2>
        </div>

        <!-- 右侧用户信息 -->
        <div class="flex items-center gap-6">
          <div class="flex items-center gap-3 pl-4 border-l border-slate-100">
            <div class="flex flex-col items-end mr-1">
              <span class="text-sm font-semibold text-slate-700">{{ studentName }}</span>
              <span class="text-xs text-slate-400">学生账号</span>
            </div>
            <div class="w-9 h-9 rounded-full bg-blue-50 flex items-center justify-center text-blue-600 font-bold text-sm border-2 border-white shadow-sm ring-1 ring-slate-100">
              {{ studentName.charAt(0) }}
            </div>
          </div>
          
          <Button 
            variant="ghost" 
            size="sm" 
            class="text-slate-500 hover:text-red-600 hover:bg-red-50 gap-2 px-3 transition-colors"
            @click="handleLogout"
          >
            <LogOut class="w-4 h-4" />
            <span class="font-medium text-xs">退出</span>
          </Button>
        </div>
      </header>

      <!-- 内容区域 (Main Content) -->
      <main class="flex-1 overflow-auto p-8">
  <div class="max-w-7xl mx-auto space-y-8">

    <KeepAlive>
      <Transition name="fade" mode="out-in">
        <div v-if="activeMenu === 'dashboard'" key="dashboard">
          <DashboardHome />
        </div>
        
        <div v-else-if="activeMenu === 'hall'" key="hall">
          <ActivityHall />
        </div>
        
        <div v-else-if="activeMenu === 'activity-status'" key="status">
          <RegistrationStatus />
        </div>
        
        <div v-else-if="activeMenu === 'activity-performance'" key="performance">
          <ActivityPerformance />
        </div>
        
        <div v-else-if="activeMenu === 'activity-leave'" key="leave">
          <LeaveDownload />
        </div>
        
        <div v-else-if="activeMenu === 'activity-certificate'" key="certificate">
          <CertificateDownload />
        </div>
        
        <div v-else-if="activeMenu === 'profile'" key="profile">
          <Profile />
        </div>
        
        <div v-else key="empty" class="grid gap-6">
          <Card class="bg-white border-slate-100 shadow-sm min-h-[300px]">
            <CardContent class="p-12 text-slate-400 text-center">模块建设中</CardContent>
          </Card>
        </div>
      </Transition>
    </KeepAlive>

  </div>
</main>
    </div>
  </div>
</template>

<style scoped>
/* 自定义滚动条样式 */
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
