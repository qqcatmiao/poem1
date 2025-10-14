<template>
  <div class="search-view">
    <div class="search-header">
      <h1>搜索诗词</h1>
      <div class="search-box">
        <input 
          v-model="searchQuery" 
          @input="handleSearch" 
          placeholder="输入诗词标题、作者或内容关键词..."
          type="text"
          class="search-input"
        />
        <button @click="performSearch" class="search-btn">搜索</button>
      </div>
    </div>

    <div class="search-results">
      <div v-if="loading" class="loading">搜索中...</div>
      <div v-else-if="searchResults.length === 0 && searchQuery" class="no-results">
        未找到相关诗词
      </div>
      <div v-else class="results-list">
        <div v-for="poem in searchResults" :key="poem.id" class="result-item">
          <h3>{{ poem.title }}</h3>
          <p class="author">{{ poem.poet_name }} · {{ poem.dynasty }}</p>
          <p class="content-preview">{{ getContentPreview(poem.content) }}</p>
          <router-link :to="`/poems/${poem.id}`" class="view-link">查看详情</router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase, TABLES } from '../supabase'
import { debounce } from '../utils/helpers'

const searchQuery = ref('')
const searchResults = ref([])
const loading = ref(false)

const performSearch = async () => {
  if (!searchQuery.value.trim()) {
    searchResults.value = []
    return
  }

  loading.value = true
  
  const { data, error } = await supabase
    .from(TABLES.POEMS)
    .select(`
      *,
      poets (name)
    `)
    .or(`title.ilike.%${searchQuery.value}%,content.ilike.%${searchQuery.value}%,poets.name.ilike.%${searchQuery.value}%`)
    .order('created_at', { ascending: false })

  if (!error && data) {
    searchResults.value = data.map(poem => ({
      ...poem,
      poet_name: poem.poets?.name || poem.poet_name
    }))
  }
  
  loading.value = false
}

const handleSearch = debounce(performSearch, 300)

const getContentPreview = (content) => {
  const index = content.toLowerCase().indexOf(searchQuery.value.toLowerCase())
  if (index === -1) {
    return content.substring(0, 100) + '...'
  }
  
  const start = Math.max(0, index - 30)
  const end = Math.min(content.length, index + searchQuery.value.length + 70)
  let preview = content.substring(start, end)
  
  if (start > 0) preview = '...' + preview
  if (end < content.length) preview = preview + '...'
  
  return preview
}

onMounted(() => {
  // 可以加载一些热门诗词作为默认展示
})
</script>

<style scoped>
.search-view {
  max-width: 1000px;
  margin: 0 auto;
  padding: 2rem;
}

.search-header {
  text-align: center;
  margin-bottom: 3rem;
}

.search-header h1 {
  color: #8b4513;
  margin-bottom: 1.5rem;
}

.search-box {
  display: flex;
  max-width: 600px;
  margin: 0 auto;
}

.search-input {
  flex: 1;
  padding: 1rem;
  border: 2px solid #8b4513;
  border-radius: 8px 0 0 8px;
  font-size: 1rem;
}

.search-btn {
  background: #8b4513;
  color: white;
  border: none;
  padding: 0 2rem;
  border-radius: 0 8px 8px 0;
  cursor: pointer;
  font-size: 1rem;
}

.search-results {
  min-height: 300px;
}

.loading, .no-results {
  text-align: center;
  padding: 2rem;
  font-size: 1.2rem;
  color: #666;
}

.results-list {
  display: grid;
  gap: 1.5rem;
}

.result-item {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  transition: transform 0.3s;
}

.result-item:hover {
  transform: translateY(-2px);
}

.result-item h3 {
  color: #8b4513;
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

.view-link {
  color: #8b4513;
  text-decoration: none;
  font-weight: bold;
}

.view-link:hover {
  text-decoration: underline;
}
</style>