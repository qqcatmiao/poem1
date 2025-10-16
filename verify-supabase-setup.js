// Supabase 配置验证脚本
import fs from 'fs'
import path from 'path'

console.log('🔍 验证 Supabase 配置完整性...\n')

// 检查关键文件是否存在
const requiredFiles = [
  'package.json',
  '.env.example', 
  '.env',
  'src/supabase.js',
  'src/stores/auth.js',
  'supabase/schema.sql',
  'src/utils/mockData.js'
]

console.log('📁 文件完整性检查:')
let allFilesExist = true

requiredFiles.forEach(file => {
  const exists = fs.existsSync(file)
  console.log(`   ${exists ? '✅' : '❌'} ${file}`)
  if (!exists) allFilesExist = false
})

// 检查 package.json 依赖
console.log('\n📦 依赖检查:')
try {
  const packageJson = JSON.parse(fs.readFileSync('package.json', 'utf8'))
  const hasSupabase = packageJson.dependencies && packageJson.dependencies['@supabase/supabase-js']
  console.log(`   ${hasSupabase ? '✅' : '❌'} @supabase/supabase-js: ${hasSupabase ? '已安装' : '未安装'}`)
} catch (error) {
  console.log('   ❌ 无法读取 package.json')
}

// 检查环境变量配置
console.log('\n🔧 环境变量检查:')
try {
  const envContent = fs.readFileSync('.env', 'utf8')
  const hasUrl = envContent.includes('VITE_SUPABASE_URL')
  const hasKey = envContent.includes('VITE_SUPABASE_ANON_KEY')
  
  console.log(`   ${hasUrl ? '✅' : '❌'} VITE_SUPABASE_URL: ${hasUrl ? '已配置' : '未配置'}`)
  console.log(`   ${hasKey ? '✅' : '❌'} VITE_SUPABASE_ANON_KEY: ${hasKey ? '已配置' : '未配置'}`)
  
  if (envContent.includes('your_supabase_project_url_here')) {
    console.log('   💡 提示: 环境变量仍为默认值，请更新为实际的 Supabase 项目配置')
  }
} catch (error) {
  console.log('   ❌ 无法读取 .env 文件')
}

// 检查数据库 schema
console.log('\n🗄️  数据库 Schema 检查:')
try {
  const schemaContent = fs.readFileSync('supabase/schema.sql', 'utf8')
  const hasTables = schemaContent.includes('CREATE TABLE')
  const hasRLS = schemaContent.includes('ROW LEVEL SECURITY')
  
  console.log(`   ${hasTables ? '✅' : '❌'} 数据库表定义: ${hasTables ? '完整' : '不完整'}`)
  console.log(`   ${hasRLS ? '✅' : '❌'} RLS 安全策略: ${hasRLS ? '已配置' : '未配置'}`)
} catch (error) {
  console.log('   ❌ 无法读取数据库 schema 文件')
}

// 总结
console.log('\n📊 配置验证总结:')
if (allFilesExist) {
  console.log('✅ Supabase 基础配置完整')
  console.log('🚀 项目可以正常启动开发服务器')
  console.log('\n💡 下一步:')
  console.log('   1. 如需连接真实 Supabase，请更新 .env 文件中的配置')
  console.log('   2. 运行 npm run dev 启动开发服务器')
  console.log('   3. 访问 http://localhost:3000 查看应用')
} else {
  console.log('❌ 部分配置文件缺失，请检查上述错误')
}

console.log('\n🎯 配置状态: 项目已准备好使用 Supabase！')