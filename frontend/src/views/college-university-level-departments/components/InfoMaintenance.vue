<script setup>
import { ref, onMounted } from 'vue'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import Button from '@/components/ui/button/button.vue'
import Input from '@/components/ui/input/Input.vue'
import { Save, User, Phone, Building2, AlertCircle, Lock } from 'lucide-vue-next'
import axios from 'axios'

// 使用环境变量或默认地址
const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'

const adminInfo = ref({
  username: '',
  name: '',
  department: '',
  phone: '',
  type: '' // 'department' 或 'academy'
})

const passwordForm = ref({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

const loading = ref(false)
const saving = ref(false)
const changingPassword = ref(false)
const errorMessage = ref('')
const successMessage = ref('')
const passwordError = ref('')
const passwordSuccess = ref('')

// 获取负责人信息
const fetchHeadInfo = async () => {
  // --- 修复点 1：使用正确的 Key 'headUsername' 获取负责人账号 ---
  const username = localStorage.getItem('headUsername')
  if (!username) {
    errorMessage.value = '未找到登录信息，请重新登录'
    return
  }

  loading.value = true
  errorMessage.value = ''

  try {
    const response = await axios.get(`${API_BASE}/api/head/info/${username}`)
    if (response.data.code === 200) {
      const data = response.data.data
      adminInfo.value = {
        username: data.username,
        name: data.name,
        department: data.department,
        phone: data.phone || '',
        type: data.type
      }
    } else {
      errorMessage.value = response.data.message || '获取信息失败'
    }
  } catch (error) {
    console.error('获取信息失败:', error)
    errorMessage.value = '网络错误，请稍后重试'
  } finally {
    loading.value = false
  }
}

// 保存修改
const handleSave = async () => {
  if (!adminInfo.value.name || !adminInfo.value.phone) {
    errorMessage.value = '姓名和电话不能为空'
    return
  }

  saving.value = true
  errorMessage.value = ''
  successMessage.value = ''

  try {
    const response = await axios.put(`${API_BASE}/api/head/info`, {
      username: adminInfo.value.username,
      name: adminInfo.value.name,
      phone: adminInfo.value.phone
    })

    if (response.data.code === 200) {
      successMessage.value = '信息更新成功'
      
      // --- 修复点 2：更新 localStorage 中对应的 'headName' ---
      localStorage.setItem('headName', adminInfo.value.name)
      
      // 3秒后清除成功消息
      setTimeout(() => {
        successMessage.value = ''
      }, 3000)
    } else {
      errorMessage.value = response.data.message || '更新失败'
    }
  } catch (error) {
    console.error('更新信息失败:', error)
    errorMessage.value = '网络错误，请稍后重试'
  } finally {
    saving.value = false
  }
}

// 取消修改
const handleCancel = () => {
  fetchHeadInfo()
  errorMessage.value = ''
  successMessage.value = ''
}

// 修改密码
const handlePasswordChange = async () => {
  // 验证表单
  if (!passwordForm.value.oldPassword || !passwordForm.value.newPassword || !passwordForm.value.confirmPassword) {
    passwordError.value = '请填写所有密码字段'
    return
  }

  if (passwordForm.value.newPassword.length < 6) {
    passwordError.value = '新密码长度不能少于6位'
    return
  }

  if (passwordForm.value.newPassword !== passwordForm.value.confirmPassword) {
    passwordError.value = '两次输入的新密码不一致'
    return
  }

  changingPassword.value = true
  passwordError.value = ''
  passwordSuccess.value = ''

  try {
    const response = await axios.put(`${API_BASE}/api/head/password`, {
      username: adminInfo.value.username,
      oldPassword: passwordForm.value.oldPassword,
      newPassword: passwordForm.value.newPassword
    })

    if (response.data.code === 200) {
      passwordSuccess.value = '密码修改成功'
      // 清空表单
      passwordForm.value = {
        oldPassword: '',
        newPassword: '',
        confirmPassword: ''
      }
      
      // 3秒后清除成功消息
      setTimeout(() => {
        passwordSuccess.value = ''
      }, 3000)
    } else {
      passwordError.value = response.data.message || '密码修改失败'
    }
  } catch (error) {
    console.error('密码修改失败:', error)
    passwordError.value = '网络错误，请稍后重试'
  } finally {
    changingPassword.value = false
  }
}

// 取消密码修改
const handlePasswordCancel = () => {
  passwordForm.value = {
    oldPassword: '',
    newPassword: '',
    confirmPassword: ''
  }
  passwordError.value = ''
  passwordSuccess.value = ''
}

onMounted(() => {
  fetchHeadInfo()
})
</script>

<template>
  <div class="space-y-6">
    <h2 class="text-2xl font-bold text-slate-900">信息维护</h2>

    <div v-if="errorMessage" class="bg-red-50 border border-red-200 rounded-lg p-4 flex items-start gap-3">
      <AlertCircle class="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
      <div class="flex-1">
        <p class="text-sm font-medium text-red-800">{{ errorMessage }}</p>
      </div>
    </div>

    <div v-if="successMessage" class="bg-green-50 border border-green-200 rounded-lg p-4 flex items-start gap-3">
      <AlertCircle class="w-5 h-5 text-green-600 flex-shrink-0 mt-0.5" />
      <div class="flex-1">
        <p class="text-sm font-medium text-green-800">{{ successMessage }}</p>
      </div>
    </div>

    <Card>
      <CardHeader>
        <CardTitle>个人信息</CardTitle>
      </CardHeader>
      <CardContent>
        <div v-if="loading" class="text-center py-12 text-slate-500">
          加载中...
        </div>
        <div v-else class="space-y-6 max-w-2xl">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2 flex items-center gap-2">
                <User class="w-4 h-4" />
                账号
              </label>
              <Input v-model="adminInfo.username" placeholder="账号" disabled class="bg-slate-50" />
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2 flex items-center gap-2">
                <User class="w-4 h-4" />
                姓名 <span class="text-red-500">*</span>
              </label>
              <Input v-model="adminInfo.name" placeholder="请输入姓名" />
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2 flex items-center gap-2">
                <Building2 class="w-4 h-4" />
                所属{{ adminInfo.type === 'department' ? '部门' : '学院' }}
              </label>
              <Input v-model="adminInfo.department" placeholder="部门/学院" disabled class="bg-slate-50" />
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2 flex items-center gap-2">
                <Phone class="w-4 h-4" />
                联系电话 <span class="text-red-500">*</span>
              </label>
              <Input v-model="adminInfo.phone" placeholder="请输入电话" />
            </div>
          </div>

          <div class="flex gap-4 pt-4">
            <Button @click="handleSave" :disabled="saving" class="gap-2">
              <Save class="w-4 h-4" />
              {{ saving ? '保存中...' : '保存修改' }}
            </Button>
            <Button variant="outline" @click="handleCancel" :disabled="saving">
              取消
            </Button>
          </div>

          <div class="text-xs text-slate-500 pt-4 border-t">
            <p>提示：</p>
            <ul class="list-disc list-inside space-y-1 mt-2">
              <li>账号和所属{{ adminInfo.type === 'department' ? '部门' : '学院' }}不可修改</li>
              <li>修改姓名和电话后，请点击"保存修改"按钮</li>
              <li>标记 <span class="text-red-500">*</span> 的字段为必填项</li>
            </ul>
          </div>
        </div>
      </CardContent>
    </Card>

    <Card>
      <CardHeader>
        <CardTitle>修改密码</CardTitle>
      </CardHeader>
      <CardContent>
        <div v-if="passwordError" class="bg-red-50 border border-red-200 rounded-lg p-4 flex items-start gap-3 mb-6">
          <AlertCircle class="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
          <div class="flex-1">
            <p class="text-sm font-medium text-red-800">{{ passwordError }}</p>
          </div>
        </div>

        <div v-if="passwordSuccess" class="bg-green-50 border border-green-200 rounded-lg p-4 flex items-start gap-3 mb-6">
          <AlertCircle class="w-5 h-5 text-green-600 flex-shrink-0 mt-0.5" />
          <div class="flex-1">
            <p class="text-sm font-medium text-green-800">{{ passwordSuccess }}</p>
          </div>
        </div>

        <div class="space-y-6 max-w-2xl">
          <div class="grid grid-cols-1 gap-6">
            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2 flex items-center gap-2">
                <Lock class="w-4 h-4" />
                原密码 <span class="text-red-500">*</span>
              </label>
              <Input
                v-model="passwordForm.oldPassword"
                type="password"
                placeholder="请输入原密码"
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2 flex items-center gap-2">
                <Lock class="w-4 h-4" />
                新密码 <span class="text-red-500">*</span>
              </label>
              <Input
                v-model="passwordForm.newPassword"
                type="password"
                placeholder="请输入新密码（至少6位）"
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-slate-700 mb-2 flex items-center gap-2">
                <Lock class="w-4 h-4" />
                确认新密码 <span class="text-red-500">*</span>
              </label>
              <Input
                v-model="passwordForm.confirmPassword"
                type="password"
                placeholder="请再次输入新密码"
              />
            </div>
          </div>

          <div class="flex gap-4 pt-4">
            <Button @click="handlePasswordChange" :disabled="changingPassword" class="gap-2">
              <Lock class="w-4 h-4" />
              {{ changingPassword ? '修改中...' : '修改密码' }}
            </Button>
            <Button variant="outline" @click="handlePasswordCancel" :disabled="changingPassword">
              取消
            </Button>
          </div>

          <div class="text-xs text-slate-500 pt-4 border-t">
            <p>提示：</p>
            <ul class="list-disc list-inside space-y-1 mt-2">
              <li>新密码长度不能少于6位</li>
              <li>请妥善保管您的密码</li>
              <li>修改密码后，下次登录需使用新密码</li>
            </ul>
          </div>
        </div>
      </CardContent>
    </Card>
  </div>
</template>