<template>
  <nav class="navbar">
    <div class="nav-container">
      <router-link to="/" class="nav-logo">
        <h1>古诗词赏析</h1>
      </router-link>
      
      <div class="nav-menu">
        <router-link to="/" class="nav-link">首页</router-link>
        <router-link to="/poems" class="nav-link">诗词浏览</router-link>
        <router-link to="/search" class="nav-link">搜索</router-link>
        
        <template v-if="authStore.user">
          <router-link to="/favorites" class="nav-link">我的收藏</router-link>
          <button @click="handleLogout" class="nav-link">退出</button>
        </template>
        <template v-else>
          <router-link to="/login" class="nav-link">登录</router-link>
          <router-link to="/register" class="nav-link">注册</router-link>
        </template>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { useAuthStore } from '../stores/auth'

const authStore = useAuthStore()

const handleLogout = async () => {
  await authStore.signOut()
}
</script>

<style scoped>
.navbar {
  background: linear-gradient(135deg, #8b4513 0%, #a0522d 100%);
  padding: 1rem 0;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.nav-container {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 2rem;
}

.nav-logo h1 {
  color: #fff;
  font-size: 1.8rem;
  text-decoration: none;
}

.nav-menu {
  display: flex;
  gap: 2rem;
}

.nav-link {
  color: #fff;
  text-decoration: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.nav-link:hover {
  background-color: rgba(255,255,255,0.1);
}

.nav-link.router-link-active {
  background-color: rgba(255,255,255,0.2);
}
</style>