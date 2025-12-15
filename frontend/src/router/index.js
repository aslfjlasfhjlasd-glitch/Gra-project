import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/Login.vue'

const routes = [
  {
    path: '/',
    name: 'Login',
    component: Login
  },
  {
    path: '/first-login',
    name: 'FirstLoginSetup',
    component: () => import('../views/student/FirstLoginSetup.vue'),
    meta: { 
      requiresAuth: true, 
      role: 'student' 
    }
  },
  {
    path: '/student/dashboard',
    name: 'StudentDashboard',
    // 路由懒加载
    component: () => import('../views/student/Dashboard.vue'),
    meta: { 
      requiresAuth: true, 
      role: 'student' 
    }
  },
  {
    path: '/head/dashboard',
    name: 'HeadDashboard',
    // 负责人管理端路由
    component: () => import('../views/college-university-level-departments/Dashboard.vue'),
    meta: { 
      requiresAuth: true, 
      role: 'head' 
    }
  },
  {
    path: '/admin/dashboard',
    name: 'SuperAdminDashboard',
    // 管理员端路由
    component: () => import('../views/admin/Dashboard.vue'),
    meta: { 
      requiresAuth: true, 
      role: 'admin' 
    }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫 - 验证登录状态
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  const userRole = localStorage.getItem('role')
  
  // 如果需要认证但没有token，跳转到登录页
  if (to.meta.requiresAuth && !token) {
    next('/')
    return
  }
  
  // 如果有角色要求，验证角色是否匹配
  if (to.meta.role && to.meta.role !== userRole) {
    next('/')
    return
  }
  
  next()
})

export default router
