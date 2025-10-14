<template>
  <div class="login-view">
    <div class="login-container">
      <h2>用户登录</h2>
      <form @submit.prevent="handleLogin" class="login-form">
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
            placeholder="请输入密码"
          />
        </div>
        
        <button type="submit" class="login-btn" :disabled="loading">
          {{ loading ? '登录中...' : '登录' }}
        </button>
        
        <div v-if="error" class="error-message">{{ error }}</div>
      </form>
      
      <p class="register-link">
        还没有账号？<router-link to="/register">立即注册</router-link>
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const authStore = useAuthStore()
const email = ref('')
const password = ref('')
const loading = ref(false)
const error = ref('')

const handleLogin = async () => {
  if (!email.value || !password.value) {
    error.value = '请填写完整信息'
    return
  }

  loading.value = true
  error.value = ''

  const { data, error: authError } = await authStore.signIn(email.value, password.value)

  if (authError) {
    error.value = authError.message
  } else {
    router.push('/')
  }

  loading.value = false
}
</script>

<style scoped>
.login-view {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 80vh;
  padding: 2rem;
}

.login-container {
  background: white;
  padding: 3rem;
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.1);
  width: 100%;
  max-width: 400px;
}

.login-container h2 {
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

.login-btn {
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

.login-btn:hover:not(:disabled) {
  background: var(--primary-light);
}

.login-btn:disabled {
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

.register-link {
  text-align: center;
  margin-top: 1.5rem;
  color: var(--text-secondary);
}

.register-link a {
  color: var(--primary-color);
  font-weight: 500;
}
</style>