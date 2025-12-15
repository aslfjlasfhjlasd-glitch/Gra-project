<script setup>
import { ref, defineAsyncComponent, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import {
  LayoutDashboard,
  ClipboardEdit,
  UserCheck,
  Settings,
  LogOut,
  ChevronDown,
  ChevronRight,
  FileCheck,
  Upload,
  GraduationCap,
  Users
} from 'lucide-vue-next'
import Button from '@/components/ui/button/button.vue'
import { Card, CardContent } from '@/components/ui/card'

// 异步加载组件 - 复用学生端的数据可视化大屏和负责人端的活动设计
const DashboardHome = defineAsyncComponent(() => import('@/views/student/components/DashboardHome.vue'))
const ActivityDesign = defineAsyncComponent(() => import('@/views/college-university-level-departments/components/ActivityDesign.vue'))
const ActivityManagement = defineAsyncComponent(() => import('./components/ActivityManagement.vue'))
const VolunteerReview = defineAsyncComponent(() => import('./components/VolunteerReview.vue'))
const DashboardMaintenance = defineAsyncComponent(() => import('./components/DashboardMaintenance.vue'))
const AccountManagement = defineAsyncComponent(() => import('./components/AccountManagement.vue'))

const router = useRouter()

// 状态管理
const isActivityManagementOpen = ref(false)
const activeMenu = ref('dashboard')

// 从localStorage获取管理员信息
const adminName = ref(localStorage.getItem('adminName') || '管理员')

// 组件挂载时检查登录状态
onMounted(() => {
  const storedName = localStorage.getItem('adminName')
  
  if (storedName) {
    adminName.value = storedName
  }
  
  const userRole = localStorage.getItem('userRole')
  if (!userRole || userRole !== 'superadmin') {
    router.push('/')
  }
})

const toggleActivityManagement = () => {
  isActivityManagementOpen.value = !isActivityManagementOpen.value
}

const handleMenuClick = (menuKey) => {
  activeMenu.value = menuKey
}

const handleLogout = () => {
  if (confirm('确定要退出登录吗？')) {
    localStorage.removeItem('adminName')
    localStorage.removeItem('userRole')
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
        <div class="bg-red-600 p-1.5 rounded-lg shadow-lg shadow-red-900/20">
          <GraduationCap class="w-5 h-5 text-white" />
        </div>
        <h1 class="text-base font-bold text-white tracking-wide">
          管理员端
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
              ? 'bg-red-600 text-white shadow-md shadow-red-900/20' 
              : 'text-slate-400 hover:bg-slate-800 hover:text-white'
          ]"
        >
          <LayoutDashboard class="w-4 h-4 transition-colors group-hover:text-white" :class="activeMenu === 'dashboard' ? 'text-white' : 'text-slate-400'" />
          数据可视化大屏
        </button>

        <!-- 菜单项：志愿活动管理 (可展开) -->
        <div class="space-y-1">
          <button 
            @click="toggleActivityManagement"
            :class="[
              'w-full flex items-center justify-between px-4 py-3 rounded-lg text-sm font-medium transition-all duration-200 group',
              activeMenu.startsWith('activity-') 
                ? 'bg-slate-800 text-white' 
                : 'text-slate-400 hover:bg-slate-800 hover:text-white'
            ]"
          >
            <div class="flex items-center gap-3">
              <ClipboardEdit class="w-4 h-4 transition-colors group-hover:text-white" :class="activeMenu.startsWith('activity-') ? 'text-white' : 'text-slate-400'" />
              志愿活动管理
            </div>
            <component 
              :is="isActivityManagementOpen ? ChevronDown : ChevronRight" 
              class="w-4 h-4 text-slate-500 transition-colors group-hover:text-slate-300"
            />
          </button>

          <!-- 子菜单 -->
          <div v-show="isActivityManagementOpen" class="pl-4 space-y-1 mt-1">
            <button
              @click="handleMenuClick('activity-design')"
              :class="[
                'w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm transition-all duration-200 border-l-2 ml-2',
                activeMenu === 'activity-design'
                  ? 'border-red-500 text-red-400 bg-slate-800/50'
                  : 'border-transparent text-slate-500 hover:text-slate-300 hover:border-slate-600'
              ]"
            >
              <ClipboardEdit class="w-3.5 h-3.5" />
              志愿活动设计
            </button>
            <button
              @click="handleMenuClick('activity-management')"
              :class="[
                'w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm transition-all duration-200 border-l-2 ml-2',
                activeMenu === 'activity-management'
                  ? 'border-red-500 text-red-400 bg-slate-800/50'
                  : 'border-transparent text-slate-500 hover:text-slate-300 hover:border-slate-600'
              ]"
            >
              <FileCheck class="w-3.5 h-3.5" />
              活动审核管理
            </button>
            <button
              @click="handleMenuClick('activity-review')"
              :class="[
                'w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm transition-all duration-200 border-l-2 ml-2',
                activeMenu === 'activity-review'
                  ? 'border-red-500 text-red-400 bg-slate-800/50'
                  : 'border-transparent text-slate-500 hover:text-slate-300 hover:border-slate-600'
              ]"
            >
              <UserCheck class="w-3.5 h-3.5" />
              志愿者审核
            </button>
          </div>
        </div>

        <!-- 菜单项：数据可视化大屏维护 -->
        <button
          @click="handleMenuClick('dashboard-maintenance')"
          :class="[
            'w-full flex items-center gap-3 px-4 py-3 rounded-lg text-sm font-medium transition-all duration-200 group',
            activeMenu === 'dashboard-maintenance'
              ? 'bg-red-600 text-white shadow-md shadow-red-900/20'
              : 'text-slate-400 hover:bg-slate-800 hover:text-white'
          ]"
        >
          <Settings class="w-4 h-4 transition-colors group-hover:text-white" :class="activeMenu === 'dashboard-maintenance' ? 'text-white' : 'text-slate-400'" />
          数据可视化大屏维护
        </button>

        <!-- 菜单项：账号管理维护 -->
        <button
          @click="handleMenuClick('account-management')"
          :class="[
            'w-full flex items-center gap-3 px-4 py-3 rounded-lg text-sm font-medium transition-all duration-200 group',
            activeMenu === 'account-management'
              ? 'bg-red-600 text-white shadow-md shadow-red-900/20'
              : 'text-slate-400 hover:bg-slate-800 hover:text-white'
          ]"
        >
          <Users class="w-4 h-4 transition-colors group-hover:text-white" :class="activeMenu === 'account-management' ? 'text-white' : 'text-slate-400'" />
          账号管理维护
        </button>

      </nav>
      
      <!-- 底部版权信息 -->
      <div class="p-6 border-t border-slate-800 bg-slate-900/50">
        <div class="flex flex-col gap-2">
          <p class="text-xs text-slate-500 font-medium">© 2025 高校志愿平台</p>
          <p class="text-[10px] text-slate-600">管理员端 v1.0.0</p>
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
              activeMenu === 'activity-design' ? '志愿活动管理 / 志愿活动设计' :
              activeMenu === 'activity-management' ? '志愿活动管理 / 活动审核管理' :
              activeMenu === 'activity-review' ? '志愿活动管理 / 志愿者审核' :
              activeMenu === 'dashboard-maintenance' ? '数据可视化大屏维护' :
              activeMenu === 'account-management' ? '账号管理维护' : '欢迎'
            }}
          </h2>
        </div>

        <!-- 右侧用户信息 -->
        <div class="flex items-center gap-6">
          <div class="flex items-center gap-3 pl-4 border-l border-slate-100">
            <div class="flex flex-col items-end mr-1">
              <span class="text-sm font-semibold text-slate-700">{{ adminName }}</span>
              <span class="text-xs text-slate-400">管理员账号</span>
            </div>
            <div class="w-9 h-9 rounded-full bg-red-50 flex items-center justify-center text-red-600 font-bold text-sm border-2 border-white shadow-sm ring-1 ring-slate-100">
              {{ adminName.charAt(0) }}
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
    
    <Transition name="fade" mode="out-in">
      <div v-if="activeMenu === 'dashboard'">
        <DashboardHome />
      </div>
      <ActivityDesign v-else-if="activeMenu === 'activity-design'" :force-admin="true" />
      <ActivityManagement v-else-if="activeMenu === 'activity-management'" />
      <VolunteerReview v-else-if="activeMenu === 'activity-review'" />
      <DashboardMaintenance v-else-if="activeMenu === 'dashboard-maintenance'" />
      <AccountManagement v-else-if="activeMenu === 'account-management'" />
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