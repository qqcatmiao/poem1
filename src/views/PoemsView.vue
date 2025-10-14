<template>
  <div class="poems-view">
    <div class="filters">
      <select v-model="selectedDynasty" @change="filterPoems">
        <option value="">全部朝代</option>
        <option v-for="dynasty in dynasties" :key="dynasty" :value="dynasty">{{ dynasty }}</option>
      </select>
      
      <select v-model="selectedTheme" @change="filterPoems">
        <option value="">全部题材</option>
        <option v-for="theme in themes" :key="theme" :value="theme">{{ theme }}</option>
      </select>
    </div>

    <div class="poems-list">
      <div v-for="poem in filteredPoems" :key="poem.id" class="poem-item">
        <h3>{{ poem.title }}</h3>
        <p class="author">{{ poem.poet_name }} · {{ poem.dynasty }}</p>
        <p class="content">{{ poem.content.substring(0, 100) }}...</p>
        <div class="actions">
          <router-link :to="`/poems/${poem.id}`" class="btn-primary">阅读详情</router-link>
          <button v-if="authStore.user" @click="toggleFavorite(poem)" class="btn-secondary">
            {{ isFavorite(poem.id) ? '取消收藏' : '收藏' }}
          </button>
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
const poems = ref([])
const favorites = ref([])
const selectedDynasty = ref('')
const selectedTheme = ref('')

const dynasties = computed(() => [...new Set(poems.value.map(p => p.dynasty))])
const themes = computed(() => [...new Set(poems.value.map(p => p.theme).filter(Boolean))])

const filteredPoems = computed(() => {
  return poems.value.filter(poem => {
    const dynastyMatch = !selectedDynasty.value || poem.dynasty === selectedDynasty.value
    const themeMatch = !selectedTheme.value || poem.theme === selectedTheme.value
    return dynastyMatch && themeMatch
  })
})

const isFavorite = (poemId) => {
  return favorites.value.some(fav => fav.poem_id === poemId)
}

const toggleFavorite = async (poem) => {
  if (!authStore.user) return

  if (isFavorite(poem.id)) {
    await supabase
      .from(TABLES.FAVORITES)
      .delete()
      .eq('poem_id', poem.id)
      .eq('user_id', authStore.user.id)
  } else {
    await supabase
      .from(TABLES.FAVORITES)
      .insert([{ poem_id: poem.id, user_id: authStore.user.id }])
  }
  loadFavorites()
}

const loadPoems = async () => {
  const { data, error } = await supabase
    .from(TABLES.POEMS)
    .select(`
      *,
      poets (name)
    `)
    .order('created_at', { ascending: false })

  if (!error && data) {
    poems.value = data.map(poem => ({
      ...poem,
      poet_name: poem.poets?.name || poem.poet_name
    }))
  }
}

const loadFavorites = async () => {
  if (!authStore.user) return
  
  const { data, error } = await supabase
    .from(TABLES.FAVORITES)
    .select('poem_id')
    .eq('user_id', authStore.user.id)

  if (!error) {
    favorites.value = data
  }
}

const filterPoems = () => {
  // 过滤逻辑已在 computed 中实现
}

onMounted(() => {
  loadPoems()
  loadFavorites()
})
</script>

<style scoped>
.poems-view {
  max-width: 1000px;
  margin: 0 auto;
}

.filters {
  margin-bottom: 2rem;
  display: flex;
  gap: 1rem;
}

.filters select {
  padding: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.poems-list {
  display: grid;
  gap: 1.5rem;
}

.poem-item {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.poem-item h3 {
  color: #8b4513;
  margin-bottom: 0.5rem;
}

.author {
  color: #666;
  font-style: italic;
  margin-bottom: 1rem;
}

.content {
  line-height: 1.6;
  margin-bottom: 1rem;
}

.actions {
  display: flex;
  gap: 1rem;
}

.btn-primary, .btn-secondary {
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  text-decoration: none;
  display: inline-block;
}

.btn-primary {
  background: #8b4513;
  color: white;
}

.btn-secondary {
  background: #f0f0f0;
  color: #333;
  border: 1px solid #ddd;
}
</style>