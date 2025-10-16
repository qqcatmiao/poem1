<template>
  <div class="poem-detail" v-if="poem">
    <div class="poem-header">
      <h1>{{ poem.title }}</h1>
      <p class="author-info">{{ poem.poet_name }} · {{ poem.dynasty }}</p>
    </div>
    
    <div class="poem-content">
      <pre>{{ formatContent(poem.content) }}</pre>
    </div>
    
    <div class="poem-actions" v-if="authStore.user">
      <button @click="toggleFavorite" class="favorite-btn">
        {{ isFavorite ? '取消收藏' : '收藏' }}
      </button>
    </div>
    
    <div class="appreciation-section">
      <h2>诗词赏析</h2>
      <div class="appreciation-content">
        {{ poem.appreciation }}
      </div>
    </div>
    
    <div class="comments-section">
      <h2>评论</h2>
      <div v-if="authStore.user" class="comment-form">
        <textarea v-model="newComment" placeholder="写下你的评论..."></textarea>
        <button @click="submitComment" class="submit-btn">发表评论</button>
      </div>
      
      <div class="comments-list">
        <div v-for="comment in comments" :key="comment.id" class="comment-item">
          <div class="comment-header">
            <span class="username">{{ comment.profiles?.username || '未知用户' }}</span>
            <span class="date">{{ formatDate(comment.created_at) }}</span>
            <button 
              v-if="authStore.user && comment.user_id === authStore.user.id"
              @click="deleteComment(comment.id)"
              class="delete-btn"
              title="删除评论"
            >
              删除
            </button>
          </div>
          <div class="comment-content">{{ comment.content }}</div>
        </div>
      </div>
    </div>
  </div>
  <div v-else class="loading">加载中...</div>
</template>

<script setup>
import { ref, onMounted, computed, inject } from 'vue'
import { useRoute } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { supabase, TABLES } from '../supabase'
import { formatDate, formatPoemContent } from '../utils/helpers'

const notification = inject('notification')

const route = useRoute()
const authStore = useAuthStore()
const poem = ref(null)
const comments = ref([])
const favorites = ref([])
const newComment = ref('')

const isFavorite = computed(() => {
  return favorites.value.some(fav => fav.poem_id === poem.value?.id)
})

const formatContent = (content) => {
  return formatPoemContent(content)
}

const loadPoem = async () => {
  const { data, error } = await supabase
    .from(TABLES.POEMS)
    .select('*')
    .eq('id', route.params.id)
    .single()

  if (!error && data) {
    poem.value = data
  } else if (error) {
    console.error('加载诗词详情失败:', error)
  }
}

const loadComments = async () => {
  try {
    const { data, error } = await supabase
      .from(TABLES.COMMENTS)
      .select(`
        *,
        profiles (username)
      `)
      .eq('poem_id', route.params.id)
      .order('created_at', { ascending: false })

    if (error) {
      console.error('加载评论失败:', error)
      comments.value = []
    } else {
      comments.value = data || []
      console.log('加载到的评论:', data)
    }
  } catch (error) {
    console.error('加载评论异常:', error)
    comments.value = []
  }
}

const loadFavorites = async () => {
  if (!authStore.user) return
  
  try {
    const { data, error } = await supabase
      .from(TABLES.FAVORITES)
      .select('id, poem_id')
      .eq('user_id', authStore.user.id)
      .eq('poem_id', route.params.id)

    if (error) throw error
    favorites.value = data || []
  } catch (error) {
    console.error('加载收藏失败:', error)
    favorites.value = []
  }
}

const toggleFavorite = async () => {
  if (!authStore.user) return

  try {
    if (isFavorite.value) {
      // 取消收藏 - 删除对应的收藏记录
      const favoriteToDelete = favorites.value.find(fav => fav.poem_id === poem.value.id)
      if (favoriteToDelete) {
        const { error } = await supabase
          .from(TABLES.FAVORITES)
          .delete()
          .eq('id', favoriteToDelete.id)

        if (error) throw error
        notification.success('已取消收藏')
      }
    } else {
      // 添加收藏
      const { error } = await supabase
        .from(TABLES.FAVORITES)
        .insert([{ 
          poem_id: poem.value.id, 
          user_id: authStore.user.id 
        }])

      if (error) throw error
      notification.success('收藏成功！')
    }
    // 重新加载收藏状态
    await loadFavorites()
  } catch (error) {
    console.error('收藏操作失败:', error)
    if (error.code === '23505') {
      notification.error('已经收藏过这首诗词了')
    } else {
      notification.error('操作失败，请重试')
    }
  }
}

const submitComment = async () => {
  if (!newComment.value.trim() || !authStore.user) {
    notification.error('请先登录并输入评论内容')
    return
  }

  try {
    const { error } = await supabase
      .from(TABLES.COMMENTS)
      .insert([{
        content: newComment.value.trim(),
        poem_id: poem.value.id,
        user_id: authStore.user.id
      }])

    if (error) {
      console.error('发表评论失败:', error)
      notification.error('发表评论失败: ' + error.message)
    } else {
      newComment.value = ''
      notification.success('评论发表成功！')
      await loadComments()
    }
  } catch (error) {
    console.error('发表评论异常:', error)
    notification.error('发表评论异常，请重试')
  }
}

const deleteComment = async (commentId) => {
  if (!authStore.user) return

  try {
    const { error } = await supabase
      .from(TABLES.COMMENTS)
      .delete()
      .eq('id', commentId)
      .eq('user_id', authStore.user.id) // 确保只能删除自己的评论

    if (error) {
      console.error('删除评论失败:', error)
      notification.error('删除评论失败: ' + error.message)
    } else {
      notification.success('评论删除成功！')
      await loadComments()
    }
  } catch (error) {
    console.error('删除评论异常:', error)
    notification.error('删除评论异常，请重试')
  }
}

onMounted(() => {
  loadPoem()
  loadComments()
  loadFavorites()
})
</script>

<style scoped>
.poem-detail {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem;
}

.poem-header {
  text-align: center;
  margin-bottom: 2rem;
}

.poem-header h1 {
  color: #8b4513;
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
}

.author-info {
  color: #666;
  font-size: 1.2rem;
}

.poem-content {
  background: #f9f5f0;
  padding: 2rem;
  border-radius: 8px;
  margin-bottom: 2rem;
  text-align: center;
}

.poem-content pre {
  font-family: 'SimSun', '宋体', serif;
  font-size: 1.2rem;
  line-height: 2;
  white-space: pre-wrap;
}

.poem-actions {
  text-align: center;
  margin-bottom: 2rem;
}

.favorite-btn {
  background: #8b4513;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
}

.appreciation-section {
  margin-bottom: 3rem;
}

.appreciation-section h2 {
  color: #8b4513;
  margin-bottom: 1rem;
}

.appreciation-content {
  line-height: 1.8;
  background: #f8f5f0;
  padding: 1.5rem;
  border-radius: 8px;
}

.comments-section h2 {
  color: #8b4513;
  margin-bottom: 1rem;
}

.comment-form {
  margin-bottom: 2rem;
}

.comment-form textarea {
  width: 100%;
  height: 100px;
  padding: 1rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  resize: vertical;
}

.submit-btn {
  background: #8b4513;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
  margin-top: 0.5rem;
}

.comment-item {
  background: white;
  padding: 1rem;
  border-radius: 8px;
  margin-bottom: 1rem;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.comment-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.5rem;
}

.username {
  font-weight: bold;
  color: #8b4513;
}

.date {
  color: #666;
  font-size: 0.9rem;
  margin-right: auto;
  margin-left: 10px;
}

.delete-btn {
  background: #dc3545;
  color: white;
  border: none;
  padding: 2px 8px;
  border-radius: 3px;
  font-size: 0.8rem;
  cursor: pointer;
}

.delete-btn:hover {
  background: #c82333;
}

.loading {
  text-align: center;
  padding: 2rem;
  font-size: 1.2rem;
}
</style>