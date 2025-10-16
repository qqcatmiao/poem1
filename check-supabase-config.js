// Supabase 配置检查脚本
import { supabase } from './src/supabase.js'

async function checkSupabaseConfig() {
  console.log('🔍 检查 Supabase 配置...')
  
  // 检查环境变量
  const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
  const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY
  
  console.log('📋 环境变量检查:')
  console.log(`   VITE_SUPABASE_URL: ${supabaseUrl ? '✅ 已配置' : '❌ 未配置'}`)
  console.log(`   VITE_SUPABASE_ANON_KEY: ${supabaseKey ? '✅ 已配置' : '❌ 未配置'}`)
  
  if (!supabaseUrl || !supabaseKey || supabaseUrl.includes('your_supabase_project_url')) {
    console.log('⚠️  检测到使用模拟数据模式')
    console.log('💡 提示: 请配置 .env 文件中的 Supabase 环境变量')
    return
  }
  
  // 测试连接
  console.log('🔗 测试 Supabase 连接...')
  try {
    const { data, error } = await supabase.from('poems').select('count').single()
    
    if (error) {
      console.log('❌ 连接失败:', error.message)
      console.log('💡 可能的原因:')
      console.log('   - Supabase 项目 URL 或密钥错误')
      console.log('   - 数据库表尚未创建')
      console.log('   - RLS 策略配置问题')
    } else {
      console.log('✅ Supabase 连接成功!')
      console.log(`📊 数据库状态: ${data.count || 0} 条诗词记录`)
    }
  } catch (err) {
    console.log('❌ 连接测试异常:', err.message)
  }
}

// 运行检查
checkSupabaseConfig()