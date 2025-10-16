<template>
  <div id="app">
    <NavBar />
    <main class="main-content">
      <router-view />
    </main>
    <Notification ref="notification" />
  </div>
</template>

<script setup>
import { ref, provide } from 'vue'
import NavBar from './components/NavBar.vue'
import Notification from './components/Notification.vue'

const notification = ref()

// 提供通知方法给所有子组件
provide('notification', {
  success: (message) => notification.value?.addNotification(message, 'success'),
  error: (message) => notification.value?.addNotification(message, 'error')
})
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'SimSun', '宋体', serif;
  background-color: #f8f5f0;
  color: #333;
}

.main-content {
  min-height: calc(100vh - 80px);
  padding: 20px;
}
</style>