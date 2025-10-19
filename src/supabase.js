import { createClient } from '@supabase/supabase-js'
import { createMockClient } from './utils/mockData.js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY

// 检查环境变量是否配置
if (!supabaseUrl || !supabaseKey || supabaseUrl === 'your_supabase_project_url_here') {
  console.warn('⚠️ Supabase 环境变量未配置，请检查 .env 文件')
  console.warn('项目将使用模拟数据模式运行')
}

// 创建 Supabase 客户端（如果配置了环境变量）
export const supabase = supabaseUrl && supabaseKey && supabaseUrl !== 'your_supabase_project_url_here' 
  ? createClient(supabaseUrl, supabaseKey, {
      auth: {
        flowType: 'pkce',
        autoRefreshToken: true,
        persistSession: true,
        detectSessionInUrl: true
      }
    })
  : createMockClient()

// 数据库表名常量
export const TABLES = {
  POEMS: 'poems',
  POETS: 'poets',
  PROFILES: 'profiles',
  FAVORITES: 'favorites',
  COMMENTS: 'comments'
}