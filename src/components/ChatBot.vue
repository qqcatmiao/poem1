<template>
  <div class="chat-bot">
    <!-- 聊天机器人按钮 -->
    <button 
      class="chat-toggle" 
      @click="toggleChat"
      :class="{ active: isOpen }"
    >
      <span v-if="!isOpen">💬</span>
      <span v-else>✕</span>
    </button>

    <!-- 聊天窗口 -->
    <div v-if="isOpen" class="chat-window">
      <div class="chat-header">
        <h3>诗词助手</h3>
        <button class="close-btn" @click="closeChat">✕</button>
      </div>

      <div class="messages-container" ref="messagesContainer">
        <div 
          v-for="(message, index) in messages" 
          :key="index"
          :class="['message', message.type]"
        >
          <div class="message-content">
            {{ message.content }}
          </div>
          <div class="message-time">
            {{ formatTime(message.timestamp) }}
          </div>
        </div>
      </div>

      <div class="input-container">
        <input
          v-model="inputMessage"
          @keyup.enter="sendMessage"
          placeholder="输入您的问题..."
          class="message-input"
        />
        <button 
          @click="sendMessage" 
          :disabled="!inputMessage.trim() || isLoading"
          class="send-btn"
        >
          {{ isLoading ? '发送中...' : '发送' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick, watch } from 'vue'
import { callN8nChatBot } from '../utils/n8nChatBot'

const isOpen = ref(false)
const inputMessage = ref('')
const messages = ref([])
const isLoading = ref(false)
const messagesContainer = ref(null)

// 初始化欢迎消息
onMounted(() => {
  messages.value.push({
    type: 'bot',
    content: '您好！我是诗词助手，可以帮您解答关于古诗词的问题。',
    timestamp: new Date()
  })
})

// 滚动到底部
const scrollToBottom = () => {
  nextTick(() => {
    if (messagesContainer.value) {
      messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight
    }
  })
}

// 监听消息变化，自动滚动
watch(messages, scrollToBottom, { deep: true })

const toggleChat = () => {
  isOpen.value = !isOpen.value
}

const closeChat = () => {
  isOpen.value = false
}

const formatTime = (timestamp) => {
  return new Date(timestamp).toLocaleTimeString('zh-CN', {
    hour: '2-digit',
    minute: '2-digit'
  })
}

const sendMessage = async () => {
  const message = inputMessage.value.trim()
  if (!message) return

  // 添加用户消息
  messages.value.push({
    type: 'user',
    content: message,
    timestamp: new Date()
  })

  inputMessage.value = ''
  isLoading.value = true

  try {
    // 调用n8n聊天机器人
    const response = await callN8nChatBot(message)
    
    // 添加机器人回复
    messages.value.push({
      type: 'bot',
      content: response,
      timestamp: new Date()
    })
  } catch (error) {
    console.error('聊天机器人错误:', error)
    messages.value.push({
      type: 'bot',
      content: '抱歉，暂时无法处理您的请求，请稍后再试。',
      timestamp: new Date()
    })
  } finally {
    isLoading.value = false
  }
}
</script>

<style scoped>
.chat-bot {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 1000;
}

.chat-toggle {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: linear-gradient(135deg, #8b4513 0%, #a0522d 100%);
  border: none;
  color: white;
  font-size: 24px;
  cursor: pointer;
  box-shadow: 0 4px 15px rgba(139, 69, 19, 0.3);
  transition: all 0.3s ease;
}

.chat-toggle:hover {
  transform: scale(1.1);
  box-shadow: 0 6px 20px rgba(139, 69, 19, 0.4);
}

.chat-toggle.active {
  background: linear-gradient(135deg, #a0522d 0%, #8b4513 100%);
}

.chat-window {
  position: absolute;
  bottom: 80px;
  right: 0;
  width: 350px;
  height: 500px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.chat-header {
  background: linear-gradient(135deg, #8b4513 0%, #a0522d 100%);
  color: white;
  padding: 15px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.chat-header h3 {
  margin: 0;
  font-size: 16px;
}

.close-btn {
  background: none;
  border: none;
  color: white;
  font-size: 18px;
  cursor: pointer;
  padding: 5px;
}

.messages-container {
  flex: 1;
  padding: 15px;
  overflow-y: auto;
  background: #f8f5f0;
}

.message {
  margin-bottom: 15px;
  display: flex;
  flex-direction: column;
}

.message.user {
  align-items: flex-end;
}

.message.bot {
  align-items: flex-start;
}

.message-content {
  max-width: 80%;
  padding: 10px 15px;
  border-radius: 18px;
  word-wrap: break-word;
}

.message.user .message-content {
  background: linear-gradient(135deg, #8b4513 0%, #a0522d 100%);
  color: white;
}

.message.bot .message-content {
  background: white;
  color: #333;
  border: 1px solid #e0e0e0;
}

.message-time {
  font-size: 11px;
  color: #999;
  margin-top: 5px;
}

.input-container {
  padding: 15px;
  border-top: 1px solid #e0e0e0;
  background: white;
  display: flex;
  gap: 10px;
}

.message-input {
  flex: 1;
  padding: 10px 15px;
  border: 1px solid #ddd;
  border-radius: 20px;
  outline: none;
  font-size: 14px;
}

.message-input:focus {
  border-color: #8b4513;
}

.send-btn {
  padding: 10px 20px;
  background: linear-gradient(135deg, #8b4513 0%, #a0522d 100%);
  color: white;
  border: none;
  border-radius: 20px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s ease;
}

.send-btn:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 2px 10px rgba(139, 69, 19, 0.3);
}

.send-btn:disabled {
  background: #ccc;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

/* 滚动条样式 */
.messages-container::-webkit-scrollbar {
  width: 6px;
}

.messages-container::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

.messages-container::-webkit-scrollbar-thumb {
  background: #8b4513;
  border-radius: 3px;
}

.messages-container::-webkit-scrollbar-thumb:hover {
  background: #a0522d;
}
</style>