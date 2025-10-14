<template>
  <div class="home">
    <div class="hero-section">
      <h1>欢迎来到古诗词赏析平台</h1>
      <p>探索千年诗词之美，感受中华文化精髓</p>
    </div>
    
    <div class="featured-poems">
      <h2>精选诗词</h2>
      <div class="poems-grid">
        <div v-for="poem in featuredPoems" :key="poem.id" class="poem-card">
          <h3>{{ poem.title }}</h3>
          <p class="author">{{ poem.poet_name }} · {{ poem.dynasty }}</p>
          <p class="excerpt">{{ poem.content.substring(0, 50) }}...</p>
          <router-link :to="`/poems/${poem.id}`" class="read-more">阅读全文</router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase, TABLES } from '../supabase'

const featuredPoems = ref([])

onMounted(async () => {
  try {
    const { data, error } = await supabase
      .from(TABLES.POEMS)
      .select(`
        *,
        poets (name)
      `)
      .limit(6)
      .order('created_at', { ascending: false })

    if (error) {
      console.error('数据加载错误:', error)
      return
    }

    console.log('加载到的数据:', data) // 调试日志
    
    if (data && data.length > 0) {
      featuredPoems.value = data.map(poem => ({
        ...poem,
        poet_name: poem.poets?.name || poem.poet_name
      }))
      console.log('转换后的数据:', featuredPoems.value) // 调试日志
    } else {
      console.warn('未加载到数据')
    }
  } catch (err) {
    console.error('数据加载异常:', err)
  }
})
</script>

<style scoped>
.home {
  max-width: 1200px;
  margin: 0 auto;
}

.hero-section {
  text-align: center;
  padding: 4rem 0;
  background: linear-gradient(135deg, #f8f5f0 0%, #e8e0d5 100%);
  border-radius: 10px;
  margin-bottom: 3rem;
}

.hero-section h1 {
  font-size: 3rem;
  color: #8b4513;
  margin-bottom: 1rem;
}

.featured-poems h2 {
  text-align: center;
  margin-bottom: 2rem;
  color: #8b4513;
}

.poems-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

.poem-card {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  transition: transform 0.3s;
}

.poem-card:hover {
  transform: translateY(-5px);
}

.poem-card h3 {
  color: #8b4513;
  margin-bottom: 0.5rem;
}

.author {
  color: #666;
  font-style: italic;
  margin-bottom: 1rem;
}

.excerpt {
  color: #333;
  line-height: 1.6;
  margin-bottom: 1rem;
}

.read-more {
  color: #8b4513;
  text-decoration: none;
  font-weight: bold;
}

.read-more:hover {
  text-decoration: underline;
}
</style>