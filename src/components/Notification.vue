<template>
  <div class="notification-container">
    <transition-group name="notification" tag="div">
      <div 
        v-for="notification in notifications" 
        :key="notification.id"
        :class="['notification', `notification-${notification.type}`]"
        @click="removeNotification(notification.id)"
      >
        <div class="notification-content">
          <span class="notification-icon">
            {{ notification.type === 'success' ? '✓' : '⚠' }}
          </span>
          <span class="notification-message">{{ notification.message }}</span>
        </div>
      </div>
    </transition-group>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const notifications = ref([])
let nextId = 1

const addNotification = (message, type = 'success', duration = 3000) => {
  const id = nextId++
  const notification = {
    id,
    message,
    type,
    duration
  }
  
  notifications.value.push(notification)
  
  if (duration > 0) {
    setTimeout(() => {
      removeNotification(id)
    }, duration)
  }
}

const removeNotification = (id) => {
  const index = notifications.value.findIndex(n => n.id === id)
  if (index > -1) {
    notifications.value.splice(index, 1)
  }
}

// 导出方法供其他组件使用
defineExpose({
  addNotification,
  removeNotification
})
</script>

<style scoped>
.notification-container {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 1000;
  pointer-events: none;
}

.notification {
  pointer-events: auto;
  background: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  margin-bottom: 10px;
  cursor: pointer;
  transition: all 0.3s ease;
  border-left: 4px solid;
}

.notification-success {
  border-left-color: #10b981;
}

.notification-error {
  border-left-color: #ef4444;
}

.notification-content {
  display: flex;
  align-items: center;
  padding: 12px 16px;
  min-width: 300px;
}

.notification-icon {
  font-size: 16px;
  margin-right: 12px;
  font-weight: bold;
}

.notification-success .notification-icon {
  color: #10b981;
}

.notification-error .notification-icon {
  color: #ef4444;
}

.notification-message {
  flex: 1;
  color: #374151;
  font-size: 14px;
}

/* 动画效果 */
.notification-enter-active,
.notification-leave-active {
  transition: all 0.3s ease;
}

.notification-enter-from {
  opacity: 0;
  transform: translateX(100%);
}

.notification-leave-to {
  opacity: 0;
  transform: translateX(100%);
}

.notification-move {
  transition: transform 0.3s ease;
}
</style>