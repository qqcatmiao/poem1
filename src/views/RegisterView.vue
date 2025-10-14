<template>
  <div class="register-view">
    <div class="register-container">
      <h2>用户注册</h2>
      <form @submit.prevent="handleRegister" class="register-form">
        <div class="form-group">
          <label for="username">用户名</label>
          <input 
            id="username"
            v-model="username" 
            type="text" 
            required 
            placeholder="请输入用户名"
          />
        </div>
        
        <div class="form-group">
          <label for="email">邮箱地址</label>
          <input 
            id="email"
            v-model="email" 
            type="email" 
            required 
            placeholder="请输入邮箱地址"
          />
        </div>
        
        <div class="form-group">
          <label for="password">密码</label>
          <input 
            id="password"
            v-model="password" 
            type="password" 
            required 
            placeholder="请输入密码（至少6位）"
            minlength="6"
          />
        </div>
        
        <div class="form-group">
          <label for="confirmPassword">确认密码</label>
          <input 
            id="confirmPassword"
            v-model="confirmPassword" 
            type="password" 
            required 
            placeholder="请再次输入密码"
          />
        </div>
        
        <button type="submit" class="register-btn" :disabled="loading">
          {{ loading ? '注册中...' : '注册' }}
        </button>
        
        <div v-if="error" class="error-message">{{ error }}</div>
        <div v-if="success" class="success-message">注册成功！请检查邮箱验证邮件。</div>
      </form>
      
      <p class="login-link">
        已有账号？<router-link to="/login">立即登录</router-link>
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { supabase, TABLES } from '../supabase'

const router = useRouter()
const authStore = useAuthStore()
const username = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const loading = ref(false)
const error = ref('')
const success = ref(false)

const handleRegister = async () => {
  if (!username.value || !email.value || !password.value) {
    error.value = '请填写完整信息'
    return
  }

  if (password.value.length < 6) {
    error.value = '密码长度至少6位'
    return
  }

  if (password.value !== confirmPassword.value) {
    error.value = '两次输入的密码不一致'
    return
  }

  loading.value = true
  error.value = ''
  success.value = false

  try {
    // 注册用户
    const { data: authData, error: authError } = await authStore.signUp(email.value, password.value)
    
    if (authError) throw authError

    // 创建用户档案
    if (authData.user) {
      const { error: profileError } = await supabase
        .from(TABLES.PROFILES)
        .insert([{
          id: authData.user.id,
          username: username.value
        }])

      if (profileError) throw profileError
    }

    success.value = true
    setTimeout(() => {
      router.push('/login')
    }, 2000)
  } catch (err) {
    error.value = err.message
  }

  loading.value = false
}
</script>

<style scoped>
.register-view {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 80vh;
  padding: 2rem;
}

.register-container {
  background: white;
  padding: 3rem;
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.1);
  width: 100%;
  max-width: 400px;
}

.register-container h2 {
  text-align: center;
  color: var(--primary-color);
  margin-bottom: 2rem;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  color: var(--text-primary);
  font-weight: 500;
}

.form-group input {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid var(--border-color);
  border-radius: 4px;
  font-size: 1rem;
}

.register-btn {
  width: 100%;
  background: var(--primary-color);
  color: white;
  border: none;
  padding: 0.75rem;
  border-radius: 4px;
  font-size: 1rem;
  cursor: pointer;
  transition: background-color 0.3s;
}

.register-btn:hover:not(:disabled) {
  background: var(--primary-light);
}

.register-btn:disabled {
  background: var(--text-light);
  cursor: not-allowed;
}

.error-message {
  color: #e74c3c;
  text-align: center;
  margin-top: 1rem;
  padding: 0.5rem;
  background: #ffeaea;
  border-radius: 4px;
}

.success-message {
  color: #27ae60;
  text-align: center;
  margin-top: 1rem;
  padding: 0.5rem;
  background: #eafaf1;
  border-radius: 4px;
}

.login-link {
  text-align: center;
  margin-top: 1.5rem;
  color: var(--text-secondary);
}

.login-link a {
  color: var(--primary-color);
  font-weight: 500;
}
</style>