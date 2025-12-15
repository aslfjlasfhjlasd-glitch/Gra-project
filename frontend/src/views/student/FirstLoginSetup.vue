<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center p-4">
    <Card class="w-full max-w-3xl">
      <CardHeader>
        <CardTitle class="text-2xl text-center">
          <div class="flex items-center justify-center gap-2 mb-2">
            <svg class="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
            </svg>
            <span>欢迎加入志愿服务平台</span>
          </div>
        </CardTitle>
        <div class="text-center text-gray-600 mt-2">
          为了您的账户安全，请修改初始密码并完善兴趣标签
        </div>
      </CardHeader>
      
      <CardContent class="space-y-6">
        <!-- 模块一：个人信息展示 -->
        <div class="bg-blue-50 rounded-lg p-4">
          <h3 class="text-lg font-semibold mb-4 flex items-center gap-2">
            <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
            </svg>
            个人信息
          </h3>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">姓名</label>
              <Input :value="userInfo.name" disabled class="bg-white" />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">学号</label>
              <Input :value="userInfo.studentId" disabled class="bg-white" />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">学院</label>
              <Input :value="userInfo.academy" disabled class="bg-white" />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">班级</label>
              <Input :value="userInfo.class" disabled class="bg-white" />
            </div>
          </div>
        </div>

        <!-- 模块二：密码修改 -->
        <div class="bg-amber-50 rounded-lg p-4">
          <h3 class="text-lg font-semibold mb-4 flex items-center gap-2">
            <svg class="w-5 h-5 text-amber-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
            </svg>
            修改密码 <span class="text-red-500 text-sm">(必填)</span>
          </h3>
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">新密码</label>
              <Input
                v-model="passwordForm.newPassword"
                type="password"
                autocomplete="new-password"
                placeholder="8-15位，必须包含大小写字母"
                class="bg-white"
                :class="{ 'border-red-500': passwordError }"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">确认新密码</label>
              <Input
                v-model="passwordForm.confirmPassword"
                type="password"
                autocomplete="new-password"
                placeholder="请再次输入新密码"
                class="bg-white"
                :class="{ 'border-red-500': passwordError }"
              />
            </div>
            <div v-if="passwordError" class="text-red-500 text-sm flex items-center gap-1">
              <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
              </svg>
              {{ passwordError }}
            </div>
            <!-- 密码要求提示 -->
            <div class="bg-white rounded-md p-3 border border-amber-200">
              <p class="text-xs font-semibold text-amber-700">
                密码要求：密码长度必须为 8-15位，且包含大小写字母
              </p>
            </div>
          </div>
        </div>

        <!-- 模块三：兴趣/技能标签选择 -->
        <div class="bg-green-50 rounded-lg p-4">
          <h3 class="text-lg font-semibold mb-4 flex items-center gap-2">
            <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
            </svg>
            兴趣与技能标签 <span class="text-gray-500 text-sm">(推荐选择，有助于智能推荐)</span>
          </h3>
          
          <div v-if="loading" class="text-center py-4 text-gray-500">
            加载标签中...
          </div>
          
          <div v-else class="space-y-4">
            <!-- 兴趣标签 -->
            <div v-if="interestTags.length > 0">
              <h4 class="text-sm font-medium text-gray-700 mb-2">兴趣标签</h4>
              <div class="flex flex-wrap gap-2">
                <label
                  v-for="tag in interestTags"
                  :key="tag.bqId"
                  class="inline-flex items-center gap-2 px-3 py-2 rounded-full cursor-pointer transition-all"
                  :class="selectedInterests.includes(tag.bqId)
                    ? 'bg-blue-500 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-blue-100 border border-gray-300'"
                >
                  <Checkbox
                    :checked="selectedInterests.includes(tag.bqId)"
                    @update:checked="toggleInterest(tag.bqId)"
                    class="hidden"
                  />
                  <span>{{ tag.bqMc }}</span>
                </label>
              </div>
            </div>

            <!-- 技能标签 -->
            <div v-if="skillTags.length > 0">
              <h4 class="text-sm font-medium text-gray-700 mb-2">技能标签</h4>
              <div class="flex flex-wrap gap-2">
                <label
                  v-for="tag in skillTags"
                  :key="tag.bqId"
                  class="inline-flex items-center gap-2 px-3 py-2 rounded-full cursor-pointer transition-all"
                  :class="selectedSkills.includes(tag.bqId)
                    ? 'bg-green-500 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-green-100 border border-gray-300'"
                >
                  <Checkbox
                    :checked="selectedSkills.includes(tag.bqId)"
                    @update:checked="toggleSkill(tag.bqId)"
                    class="hidden"
                  />
                  <span>{{ tag.bqMc }}</span>
                </label>
              </div>
            </div>
          </div>
        </div>
      </CardContent>

      <CardFooter class="flex justify-center gap-4">
        <button
          @click="handleSubmit"
          :disabled="submitting"
          class="px-8 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors font-medium shadow-md"
        >
          <span v-if="submitting">提交中...</span>
          <span v-else>完成设置</span>
        </button>
      </CardFooter>
    </Card>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { Card, CardHeader, CardTitle, CardContent, CardFooter } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Checkbox } from '@/components/ui/checkbox'
import axios from 'axios'

const router = useRouter()

// 用户信息
const userInfo = ref({
  name: '',
  studentId: '',
  academy: '',
  class: ''
})

// 密码表单
const passwordForm = ref({
  newPassword: '',
  confirmPassword: ''
})

// 标签数据
const interestTags = ref([])
const skillTags = ref([])
const selectedInterests = ref([])
const selectedSkills = ref([])

// 状态
const loading = ref(false)
const submitting = ref(false)
const passwordError = ref('')

// 密码校验 - 更新为新的要求
const validatePassword = () => {
  const { newPassword, confirmPassword } = passwordForm.value
  
  if (!newPassword) {
    passwordError.value = '请输入新密码'
    return false
  }
  
  if (newPassword === '123456') {
    passwordError.value = '新密码不能为初始密码123456'
    return false
  }
  
  // 检查长度：8-15位
  if (newPassword.length < 8 || newPassword.length > 15) {
    passwordError.value = '密码长度必须为8-15位'
    return false
  }
  
  // 检查是否包含大写字母
  if (!/[A-Z]/.test(newPassword)) {
    passwordError.value = '密码必须包含至少一个大写字母'
    return false
  }
  
  // 检查是否包含小写字母
  if (!/[a-z]/.test(newPassword)) {
    passwordError.value = '密码必须包含至少一个小写字母'
    return false
  }
  
  if (newPassword !== confirmPassword) {
    passwordError.value = '两次输入的密码不一致'
    return false
  }
  
  passwordError.value = ''
  return true
}

// 切换兴趣标签
const toggleInterest = (tagId) => {
  const index = selectedInterests.value.indexOf(tagId)
  if (index > -1) {
    selectedInterests.value.splice(index, 1)
  } else {
    selectedInterests.value.push(tagId)
  }
}

// 切换技能标签
const toggleSkill = (tagId) => {
  const index = selectedSkills.value.indexOf(tagId)
  if (index > -1) {
    selectedSkills.value.splice(index, 1)
  } else {
    selectedSkills.value.push(tagId)
  }
}

// 加载用户信息
const loadUserInfo = async () => {
  try {
    const token = localStorage.getItem('token')
    const studentId = localStorage.getItem('studentId')
    
    if (!studentId) {
      alert('未找到学号信息，请重新登录')
      router.push('/login')
      return
    }
    
    const response = await axios.get('http://localhost:8080/api/student/profile', {
      params: { studentId: parseInt(studentId) },
      headers: { Authorization: `Bearer ${token}` }
    })
    
    if (response.data.code === 200) {
      const data = response.data.data
      userInfo.value = {
        name: data.xsXm || '',
        studentId: data.xsXh || '',
        academy: data.ssXy || '',
        class: data.bjMc || ''
      }
    }
  } catch (error) {
    console.error('加载用户信息失败:', error)
    alert('加载用户信息失败，请重新登录')
    router.push('/login')
  }
}

// 加载标签列表
const loadTags = async () => {
  loading.value = true
  try {
    const token = localStorage.getItem('token')
    const response = await axios.get('http://localhost:8080/api/tags', {
      headers: { Authorization: `Bearer ${token}` }
    })
    
    if (response.data.code === 200) {
      const tags = response.data.data
      // 后端约定：bqLx=1 是兴趣/活动类别，bqLx=2 是技能
      interestTags.value = tags.filter(tag => tag.bqLx === 1)
      skillTags.value = tags.filter(tag => tag.bqLx === 2)
      console.log('兴趣标签:', interestTags.value)
      console.log('技能标签:', skillTags.value)
    }
  } catch (error) {
    console.error('加载标签失败:', error)
  } finally {
    loading.value = false
  }
}

// 提交表单
const handleSubmit = async () => {
  // 校验密码
  if (!validatePassword()) {
    return
  }
  
  submitting.value = true
  
  try {
    const token = localStorage.getItem('token')
    const studentId = localStorage.getItem('studentId')
    
    if (!studentId) {
      alert('未找到学号信息，请重新登录')
      router.push('/login')
      return
    }
    
    const headers = { Authorization: `Bearer ${token}` }
    
    // 1. 修改密码
    const passwordResponse = await axios.put(
      'http://localhost:8080/api/student/password',
      {
        studentIdFromStorage: studentId,
        oldPassword: '123456',
        newPassword: passwordForm.value.newPassword
      },
      { headers }
    )
    
    if (passwordResponse.data.code !== 200) {
      throw new Error(passwordResponse.data.message || '密码修改失败')
    }
    
    // 2. 更新标签（如果有选择）
    const allSelectedTags = [...selectedInterests.value, ...selectedSkills.value]
    if (allSelectedTags.length > 0) {
      const tagsResponse = await axios.post(
        'http://localhost:8080/api/student/tags',
        {
          studentIdFromStorage: studentId,
          tagIds: allSelectedTags
        },
        { headers }
      )
      
      if (tagsResponse.data.code !== 200) {
        console.warn('标签更新失败:', tagsResponse.data.message)
        // 标签更新失败不阻断流程
      }
    }
    
    // 3. 成功提示并跳转
    alert('设置成功！欢迎使用志愿服务平台')
    
    // 清除首次登录标记（如果有）
    localStorage.removeItem('isFirstLogin')
    
    // 跳转到学生首页
    router.replace('/student/dashboard')
    
  } catch (error) {
    console.error('提交失败:', error)
    alert(error.message || '设置失败，请重试')
  } finally {
    submitting.value = false
  }
}

// 组件挂载时加载数据
onMounted(() => {
  loadUserInfo()
  loadTags()
})
</script>

<style scoped>
/* 自定义样式 */
</style>