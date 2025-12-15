<template>
  <div class="account-management">
    <h2 class="text-2xl font-bold mb-6">账号管理维护</h2>

    <!-- Tabs 切换 -->
    <div class="tabs mb-6">
      <button
        :class="['tab-btn', { active: activeTab === 'student' }]"
        @click="activeTab = 'student'"
      >
        学生账号管理
      </button>
      <button
        :class="['tab-btn', { active: activeTab === 'head' }]"
        @click="activeTab = 'head'"
      >
        负责人账号管理
      </button>
      <button
        :class="['tab-btn', { active: activeTab === 'admin' }]"
        @click="activeTab = 'admin'"
      >
        管理员密码修改
      </button>
    </div>

    <!-- 操作栏 -->
    <div v-if="activeTab !== 'admin'" class="operation-bar mb-4 flex items-center gap-4">
      <input
        v-model="searchKeyword"
        type="text"
        :placeholder="activeTab === 'student' ? '搜索姓名或学号' : '搜索姓名或工号'"
        class="search-input flex-1 max-w-md px-4 py-2 border rounded-lg"
        @keyup.enter="handleSearch"
      />
      <button class="btn btn-secondary" @click="handleSearch">搜索</button>
      <button class="btn btn-secondary" @click="handleReset">重置</button>
      <button class="btn btn-primary" @click="handleAdd">
        <span class="mr-1">+</span> 新增用户
      </button>
    </div>

    <!-- 学生账号表格 -->
    <div v-if="activeTab === 'student'" class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th>学号</th>
            <th>姓名</th>
            <th>学院</th>
            <th>联系电话</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="student in studentList" :key="student.xsXh">
            <td>{{ student.xsXh }}</td>
            <td>{{ student.xsXm }}</td>
            <td>{{ student.ssXy || '-' }}</td>
            <td>{{ student.xsDh || '-' }}</td>
            <td class="action-cell">
              <button class="action-btn edit" @click="handleEdit(student)">编辑</button>
              <button class="action-btn reset" @click="handleResetPassword(student)">重置密码</button>
              <button class="action-btn delete" @click="handleDelete(student)">删除</button>
            </td>
          </tr>
          <tr v-if="studentList.length === 0">
            <td colspan="5" class="text-center text-gray-500 py-8">暂无数据</td>
          </tr>
        </tbody>
      </table>

      <!-- 分页 -->
      <div class="pagination mt-4 flex items-center justify-between">
        <div class="text-sm text-gray-600">
          共 {{ studentTotal }} 条记录，第 {{ studentPage }} / {{ Math.ceil(studentTotal / pageSize) }} 页
        </div>
        <div class="flex gap-2">
          <button
            class="btn btn-sm"
            :disabled="studentPage === 1"
            @click="handlePageChange('student', studentPage - 1)"
          >
            上一页
          </button>
          <button
            class="btn btn-sm"
            :disabled="studentPage >= Math.ceil(studentTotal / pageSize)"
            @click="handlePageChange('student', studentPage + 1)"
          >
            下一页
          </button>
        </div>
      </div>
    </div>

    <!-- 负责人账号表格 -->
    <div v-if="activeTab === 'head'" class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th>账号</th>
            <th>姓名</th>
            <th>类型</th>
            <th>部门/学院</th>
            <th>联系电话</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="head in headList" :key="head.username">
            <td>{{ head.username }}</td>
            <td>{{ head.name }}</td>
            <td>
              <span :class="['type-badge', head.type === 'academy' ? 'academy' : 'department']">
                {{ head.type === 'academy' ? '学院' : '校级部门' }}
              </span>
            </td>
            <td>{{ head.department || '-' }}</td>
            <td>{{ head.phone || '-' }}</td>
            <td class="action-cell">
              <button class="action-btn edit" @click="handleEdit(head)">编辑</button>
              <button class="action-btn reset" @click="handleResetPassword(head)">重置密码</button>
              <button class="action-btn delete" @click="handleDelete(head)">删除</button>
            </td>
          </tr>
          <tr v-if="headList.length === 0">
            <td colspan="6" class="text-center text-gray-500 py-8">暂无数据</td>
          </tr>
        </tbody>
      </table>

      <!-- 分页 -->
      <div class="pagination mt-4 flex items-center justify-between">
        <div class="text-sm text-gray-600">
          共 {{ headTotal }} 条记录，第 {{ headPage }} / {{ Math.ceil(headTotal / pageSize) }} 页
        </div>
        <div class="flex gap-2">
          <button
            class="btn btn-sm"
            :disabled="headPage === 1"
            @click="handlePageChange('head', headPage - 1)"
          >
            上一页
          </button>
          <button
            class="btn btn-sm"
            :disabled="headPage >= Math.ceil(headTotal / pageSize)"
            @click="handlePageChange('head', headPage + 1)"
          >
            下一页
          </button>
        </div>
      </div>
    </div>

    <!-- 管理员密码修改 -->
    <div v-if="activeTab === 'admin'" class="admin-password-section">
      <div class="password-card">
        <h3 class="text-xl font-bold mb-6">修改管理员密码</h3>
        <form @submit.prevent="handleChangePassword" class="password-form">
          <div class="form-group">
            <label>管理员账号 <span class="text-red-500">*</span></label>
            <input
              v-model="passwordForm.username"
              type="text"
              placeholder="请输入管理员账号"
              required
              class="form-input"
              autocomplete="off"
            />
          </div>
          <div class="form-group">
            <label>旧密码 <span class="text-red-500">*</span></label>
            <input
              v-model="passwordForm.oldPassword"
              type="password"
              placeholder="请输入旧密码"
              required
              class="form-input"
              autocomplete="new-password"
            />
          </div>
          <div class="form-group">
            <label>新密码 <span class="text-red-500">*</span></label>
            <input
              v-model="passwordForm.newPassword"
              type="password"
              placeholder="请输入新密码（至少6位）"
              required
              minlength="6"
              class="form-input"
              autocomplete="new-password"
            />
            <p class="text-sm text-gray-500 mt-1">密码长度不能少于6位</p>
          </div>
          <div class="form-group">
            <label>确认新密码 <span class="text-red-500">*</span></label>
            <input
              v-model="passwordForm.confirmPassword"
              type="password"
              placeholder="请再次输入新密码"
              required
              class="form-input"
              autocomplete="new-password"
            />
          </div>
          <div class="form-actions">
            <button type="submit" class="btn btn-primary" :disabled="loading">
              {{ loading ? '提交中...' : '确认修改' }}
            </button>
            <button type="button" class="btn btn-secondary" @click="resetPasswordForm">
              重置
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- 新增/编辑弹窗 -->
    <div v-if="showDialog" class="dialog-overlay" @click.self="closeDialog">
      <div class="dialog-content">
        <div class="dialog-header">
          <h3 class="text-xl font-bold">{{ dialogTitle }}</h3>
          <button class="close-btn" @click="closeDialog">×</button>
        </div>
        <div class="dialog-body">
          <form @submit.prevent="handleSubmit">
            <div v-if="activeTab === 'head' && !isEdit" class="form-group">
              <label>账号类型 <span class="text-red-500">*</span></label>
              <select v-model="formData.accountType" required>
                <option value="department">校级部门负责人</option>
                <option value="academy">学院负责人</option>
              </select>
            </div>
            <div class="form-group">
              <label>{{ activeTab === 'student' ? '学号' : '账号' }} <span class="text-red-500">*</span></label>
              <input
                v-model="formData.code"
                type="text"
                :placeholder="activeTab === 'student' ? '请输入学号' : '请输入账号'"
                required
              />
              <p v-if="isEdit" class="text-sm text-orange-600 mt-1">
                ⚠️ 修改账号可能影响用户登录，请谨慎操作
              </p>
            </div>
            <div class="form-group">
              <label>姓名 <span class="text-red-500">*</span></label>
              <input
                v-model="formData.username"
                type="text"
                placeholder="请输入姓名"
                required
              />
            </div>
            <div class="form-group">
              <label>{{ activeTab === 'student' ? '学院' : '部门/学院' }} <span class="text-red-500">*</span></label>
              <input
                v-model="formData.academy"
                type="text"
                :placeholder="activeTab === 'student' ? '请输入学院' : '请输入部门或学院名称'"
                required
              />
            </div>
            
            <!-- 学生专属字段 -->
            <template v-if="activeTab === 'student'">
              <div class="form-group">
                <label>性别</label>
                <select v-model="formData.gender">
                  <option value="">请选择</option>
                  <option value="1">男</option>
                  <option value="0">女</option>
                </select>
              </div>
              <div class="form-group">
                <label>政治面貌</label>
                <select v-model="formData.politicalStatus">
                  <option value="">请选择</option>
                  <option value="群众">群众</option>
                  <option value="共青团员">共青团员</option>
                  <option value="中共党员">中共党员</option>
                </select>
              </div>
              <div class="form-group">
                <label>班级</label>
                <input
                  v-model="formData.className"
                  type="text"
                  placeholder="请输入班级名称"
                />
              </div>
            </template>
            
            <div class="form-group">
              <label>联系电话</label>
              <input
                v-model="formData.phone"
                type="text"
                placeholder="请输入联系电话"
              />
            </div>
            <div class="form-group">
              <label>{{ isEdit ? '修改密码' : '初始密码' }}</label>
              <input
                v-model="formData.password"
                type="text"
                :placeholder="isEdit ? '留空则不修改密码' : '留空则默认为 123456'"
              />
              <p class="text-sm text-gray-500 mt-1">
                {{ isEdit ? '不填写则保持原密码不变' : '不填写则默认密码为：123456' }}
              </p>
            </div>
            <div class="dialog-footer">
              <button type="button" class="btn btn-secondary" @click="closeDialog">取消</button>
              <button type="submit" class="btn btn-primary" :disabled="loading">
                {{ loading ? '提交中...' : '确定' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue';
import {
  getStudentList,
  addStudent,
  updateStudent,
  resetStudentPassword,
  deleteStudent,
  getDepartmentHeadList,
  addDepartmentHead,
  updateDepartmentHead,
  resetDepartmentHeadPassword,
  deleteDepartmentHead,
  changeAdminPassword
} from '@/api/admin';

// 状态管理
const activeTab = ref('student');
const searchKeyword = ref('');
const loading = ref(false);

// 学生数据
const studentList = ref([]);
const studentPage = ref(1);
const studentTotal = ref(0);

// 负责人数据
const headList = ref([]);
const headPage = ref(1);
const headTotal = ref(0);

// 分页大小
const pageSize = ref(10);

// 弹窗相关
const showDialog = ref(false);
const isEdit = ref(false);
const formData = ref({
  code: '',
  username: '',
  academy: '',
  phone: '',
  password: '',
  accountType: 'department', // 默认为校级部门
  // 学生专属字段
  gender: '',
  politicalStatus: '',
  className: ''
});

// 管理员密码修改表单
const passwordForm = ref({
  username: '',
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
});

// 计算属性
const dialogTitle = computed(() => {
  const type = activeTab.value === 'student' ? '学生' : '负责人';
  return isEdit.value ? `编辑${type}账号` : `新增${type}账号`;
});

// 监听 tab 切换，重新加载数据
watch(activeTab, () => {
  searchKeyword.value = '';
  if (activeTab.value !== 'admin') {
    loadData();
  }
});

// 加载数据
const loadData = async () => {
  loading.value = true;
  try {
    if (activeTab.value === 'student') {
      await loadStudentList();
    } else if (activeTab.value === 'head') {
      await loadHeadList();
    }
  } catch (error) {
    console.error('加载数据失败:', error);
    alert('加载数据失败，请稍后重试');
  } finally {
    loading.value = false;
  }
};

// 加载学生列表
const loadStudentList = async () => {
  const response = await getStudentList(searchKeyword.value, studentPage.value, pageSize.value);
  if (response.data.code === 200) {
    const data = response.data.data;
    studentList.value = data.list || [];
    studentTotal.value = data.total || 0;
  }
};

// 加载负责人列表
const loadHeadList = async () => {
  const response = await getDepartmentHeadList(searchKeyword.value, headPage.value, pageSize.value);
  if (response.data.code === 200) {
    const data = response.data.data;
    headList.value = data.list || [];
    headTotal.value = data.total || 0;
  }
};

// 搜索
const handleSearch = () => {
  if (activeTab.value === 'student') {
    studentPage.value = 1;
  } else {
    headPage.value = 1;
  }
  loadData();
};

// 重置搜索
const handleReset = () => {
  searchKeyword.value = '';
  if (activeTab.value === 'student') {
    studentPage.value = 1;
  } else {
    headPage.value = 1;
  }
  loadData();
};

// 分页切换
const handlePageChange = (type, page) => {
  if (type === 'student') {
    studentPage.value = page;
  } else {
    headPage.value = page;
  }
  loadData();
};

// 新增
const handleAdd = () => {
  isEdit.value = false;
  formData.value = {
    code: '',
    username: '',
    academy: '',
    phone: '',
    password: '',
    accountType: 'department',
    gender: '',
    politicalStatus: '',
    className: ''
  };
  showDialog.value = true;
};

// 编辑
const handleEdit = (record) => {
  isEdit.value = true;
  if (activeTab.value === 'student') {
    formData.value = {
      id: record.xsXh,
      code: record.xsXh,
      username: record.xsXm,
      academy: record.ssXy || '',
      phone: record.xsDh || '',
      password: '',
      gender: record.xsXb || '',
      politicalStatus: record.zzmm || '',
      className: record.bjMc || ''
    };
  } else {
    formData.value = {
      id: record.username,
      code: record.username,
      username: record.name,
      academy: record.department || '',
      phone: record.phone || '',
      password: '',
      accountType: record.type || 'department',
      gender: '',
      politicalStatus: '',
      className: ''
    };
  }
  showDialog.value = true;
};

// 提交表单
const handleSubmit = async () => {
  loading.value = true;
  try {
    let response;
    if (activeTab.value === 'student') {
      if (isEdit.value) {
        response = await updateStudent(formData.value);
      } else {
        response = await addStudent(formData.value);
      }
    } else {
      const data = {
        ...formData.value,
        department: formData.value.academy
      };
      if (isEdit.value) {
        response = await updateDepartmentHead(data);
      } else {
        response = await addDepartmentHead(data);
      }
    }

    if (response.data.code === 200) {
      alert(response.data.message || '操作成功');
      closeDialog();
      loadData();
    } else {
      alert(response.data.message || '操作失败');
    }
  } catch (error) {
    console.error('提交失败:', error);
    alert(error.response?.data?.message || '操作失败，请稍后重试');
  } finally {
    loading.value = false;
  }
};

// 重置密码
const handleResetPassword = async (record) => {
  const type = activeTab.value === 'student' ? '学生' : '负责人';
  const name = activeTab.value === 'student' ? record.xsXm : record.name;
  
  if (!confirm(`确定要重置 ${name} 的密码吗？密码将重置为：123456`)) {
    return;
  }

  loading.value = true;
  try {
    let response;
    if (activeTab.value === 'student') {
      response = await resetStudentPassword(record.xsXh);
    } else {
      response = await resetDepartmentHeadPassword(record.username, record.type);
    }

    if (response.data.code === 200) {
      alert(response.data.message || '密码重置成功');
    } else {
      alert(response.data.message || '密码重置失败');
    }
  } catch (error) {
    console.error('重置密码失败:', error);
    alert(error.response?.data?.message || '重置密码失败，请稍后重试');
  } finally {
    loading.value = false;
  }
};

// 删除
const handleDelete = async (record) => {
  const type = activeTab.value === 'student' ? '学生' : '负责人';
  const name = activeTab.value === 'student' ? record.xsXm : record.name;
  
  if (!confirm(`确定要删除 ${name} 的账号吗？此操作不可恢复！`)) {
    return;
  }

  loading.value = true;
  try {
    let response;
    if (activeTab.value === 'student') {
      response = await deleteStudent(record.xsXh);
    } else {
      response = await deleteDepartmentHead(record.username, record.type);
    }

    if (response.data.code === 200) {
      alert(response.data.message || '删除成功');
      loadData();
    } else {
      alert(response.data.message || '删除失败');
    }
  } catch (error) {
    console.error('删除失败:', error);
    alert(error.response?.data?.message || '删除失败，请稍后重试');
  } finally {
    loading.value = false;
  }
};

// 关闭弹窗
const closeDialog = () => {
  showDialog.value = false;
  formData.value = {
    code: '',
    username: '',
    academy: '',
    phone: '',
    password: '',
    accountType: 'department',
    gender: '',
    politicalStatus: '',
    className: ''
  };
};

// 修改管理员密码
const handleChangePassword = async () => {
  // 验证两次密码输入是否一致
  if (passwordForm.value.newPassword !== passwordForm.value.confirmPassword) {
    alert('两次输入的新密码不一致，请重新输入');
    return;
  }

  loading.value = true;
  try {
    const response = await changeAdminPassword(
      passwordForm.value.username,
      passwordForm.value.oldPassword,
      passwordForm.value.newPassword
    );

    if (response.data.code === 200) {
      alert(response.data.message || '密码修改成功');
      resetPasswordForm();
    } else {
      alert(response.data.message || '密码修改失败');
    }
  } catch (error) {
    console.error('修改密码失败:', error);
    alert(error.response?.data?.message || '修改密码失败，请稍后重试');
  } finally {
    loading.value = false;
  }
};

// 重置密码表单
const resetPasswordForm = () => {
  passwordForm.value = {
    username: '',
    oldPassword: '',
    newPassword: '',
    confirmPassword: ''
  };
};

// 初始化
onMounted(() => {
  loadData();
});
</script>

<style scoped>
.account-management {
  padding: 20px;
}

/* Tabs 样式 */
.tabs {
  display: flex;
  gap: 10px;
  border-bottom: 2px solid #e5e7eb;
}

.tab-btn {
  padding: 10px 20px;
  background: none;
  border: none;
  border-bottom: 3px solid transparent;
  cursor: pointer;
  font-size: 16px;
  font-weight: 500;
  color: #6b7280;
  transition: all 0.3s;
}

.tab-btn:hover {
  color: #3b82f6;
}

.tab-btn.active {
  color: #3b82f6;
  border-bottom-color: #3b82f6;
}

/* 按钮样式 */
.btn {
  padding: 8px 16px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s;
}

.btn-primary {
  background: #3b82f6;
  color: white;
}

.btn-primary:hover {
  background: #2563eb;
}

.btn-secondary {
  background: #e5e7eb;
  color: #374151;
}

.btn-secondary:hover {
  background: #d1d5db;
}

.btn-sm {
  padding: 6px 12px;
  font-size: 13px;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* 搜索输入框 */
.search-input {
  border: 1px solid #d1d5db;
}

.search-input:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

/* 表格样式 */
.table-container {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th {
  background: #f9fafb;
  padding: 12px 16px;
  text-align: left;
  font-weight: 600;
  color: #374151;
  border-bottom: 2px solid #e5e7eb;
}

.data-table td {
  padding: 12px 16px;
  border-bottom: 1px solid #e5e7eb;
}

.data-table tbody tr:hover {
  background: #f9fafb;
}

.action-cell {
  display: flex;
  gap: 8px;
}

.action-btn {
  padding: 4px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 13px;
  transition: all 0.3s;
}

.action-btn.edit {
  background: #3b82f6;
  color: white;
}

.action-btn.edit:hover {
  background: #2563eb;
}

.action-btn.reset {
  background: #f59e0b;
  color: white;
}

.action-btn.reset:hover {
  background: #d97706;
}

/* 类型标签样式 */
.type-badge {
  display: inline-block;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.type-badge.department {
  background: #dbeafe;
  color: #1e40af;
}

.type-badge.academy {
  background: #fef3c7;
  color: #92400e;
}

.action-btn.reset:hover {
  background: #d97706;
}

.action-btn.delete {
  background: #ef4444;
  color: white;
}

.action-btn.delete:hover {
  background: #dc2626;
}

/* 弹窗样式 */
.dialog-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.dialog-content {
  background: white;
  border-radius: 8px;
  width: 90%;
  max-width: 500px;
  max-height: 90vh;
  overflow-y: auto;
}

.dialog-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #e5e7eb;
}

.close-btn {
  background: none;
  border: none;
  font-size: 28px;
  cursor: pointer;
  color: #6b7280;
  line-height: 1;
}

.close-btn:hover {
  color: #374151;
}

.dialog-body {
  padding: 20px;
}

.form-group {
  margin-bottom: 16px;
}

.form-group label {
  display: block;
  margin-bottom: 6px;
  font-weight: 500;
  color: #374151;
}

.form-group input,
.form-group select {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  font-size: 14px;
}

.form-group input:focus,
.form-group select:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.form-group input:disabled {
  background: #f3f4f6;
  cursor: not-allowed;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}

/* 管理员密码修改样式 */
.admin-password-section {
  display: flex;
  justify-content: center;
  padding: 40px 20px;
}

.password-card {
  background: white;
  border-radius: 8px;
  padding: 40px;
  width: 100%;
  max-width: 500px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.password-form .form-group {
  margin-bottom: 20px;
}

.password-form .form-input {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  font-size: 14px;
}

.password-form .form-input:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.form-actions {
  display: flex;
  gap: 12px;
  margin-top: 30px;
}

.form-actions .btn {
  flex: 1;
}
</style>