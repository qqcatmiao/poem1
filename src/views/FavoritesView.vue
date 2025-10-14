<template>
  <div class="favorites-view">
    <div v-if="!authStore.user" class="login-required">
      <h2>请先登录</h2>
      <p>登录后即可查看和管理您的收藏</p>
      <router-link to="/login" class="login-btn">立即登录</router-link>
    </div>
    
    <div v-else>
      <h2>我的收藏</h2>
      <div v-if="favorites.length === 0" class="empty-state">
        <p>您还没有收藏任何诗词</p>
        <router-link to="/poems" class="browse-link">去浏览诗词</router-link>
      </div>
      
      <div v-else class="favorites-list">
        <div v-for="favorite in favorites" :key="favorite.id" class="favorite-item">
          <h3>{{ favorite.poems.title }}</h3>
          <p class="author">{{ favorite.poems.poet_name }} · {{ favorite.poems.dynasty }}</p>
          <p class="content-preview">{{ getContentPreview(favorite.poems.content) }}</p>
          <div class="actions">
            <router-link :to="`/poems/${favorite.poems.id}`" class="view-btn">查看详情</router-link>
            <button @click="removeFavorite(favorite)" class="remove-btn">取消收藏</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useAuthStore } from '../stores/auth'
import { supabase, TABLES } from '../supabase'

const authStore = useAuthStore()
const favorites = ref([])

const loadFavorites = async () => {
  if (!authStore.user) return

  const { data, error } = await supabase
    .from(TABLES.FAVORITES)
    .select(`
      *,
      poems (
        *,
        poets (name)
      )
    `)
    .eq('user_id', authStore.user.id)
    .order('created_at', { ascending: false })

  if (!error) {
    favorites.value = data.map(fav => ({
      ...fav,
      poems: {
        ...fav.poems,
        poet_name: fav.poems.poets.name
      }
    }))
  }
}

const removeFavorite = async (favorite) => {
  const { error } = await supabase
    .from(TABLES.FAVORITES)
    .delete()
    .eq('id', favorite.id)

  if (!error) {
    loadFavorites()
  }
}

const getContentPreview = (content) => {
  return content.substring(0, 100) + '...'
}

onMounted(() => {
  loadFavorites()
})
</script>

<style scoped>
.favorites-view {
  max-width: 1000px;
  margin: 0 auto;
  padding: 2rem;
}

.login-required, .empty-state {
  text-align: center;
  padding: 3rem;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.login-required h2, .favorites-view h2 {
  color: var(--primary-color);
  margin-bottom: 1rem;
}

.login-btn, .browse-link {
  display: inline-block;
  background: var(--primary-color);
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 4px;
  text-decoration: none;
  margin-top: 1rem;
}

.favorites-list {
  display: grid;
  gap: 1.5rem;
}

.favorite-item {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.favorite-item h3 {
  color: var(--primary-color);
  margin-bottom: 0.5rem;
}

.author {
  color: #666;
  font-style: italic;
  margin-bottom: 1rem;
}

.content-preview {
  line-height: 1.6;
  margin-bottom: 1rem;
  color: #333;
}

.actions {
  display: flex;
  gap: 1rem;
}

.view-btn {
  background: var(--primary-color);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  text-decoration: none;
}

.remove-btn {
  background: #f0f0f0;
  color: #666;
  border: 1px solid #ddd;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
}

.remove-btn:hover {
  background: #e0e0e0;
}
</style>