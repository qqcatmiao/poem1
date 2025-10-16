// 检查数据库状态脚本
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://rbarqocuypmpybeckwxk.supabase.co'
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJiYXJxb2N1eXBtcHliZWNrd3hrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1MDkzNjEsImV4cCI6MjA3NjA4NTM2MX0.pfnRg8585zathN6QGRW3IPS-OT-z8RrPGaxWUpttLRQ'

const supabase = createClient(supabaseUrl, supabaseKey)

console.log('🔍 检查 Supabase 数据库状态...\n')

async function checkDatabase() {
  try {
    // 检查 poems 表
    console.log('1. 检查 poems 表...')
    const { data: poems, error: poemsError } = await supabase
      .from('poems')
      .select('*')
      .limit(1)

    if (poemsError) {
      console.log('   ❌ 错误:', poemsError.message)
      console.log('   💡 表可能不存在或权限问题')
    } else {
      console.log(`   ✅ 表存在，数据条数: ${poems.length}`)
      if (poems.length > 0) {
        console.log(`   示例: "${poems[0].title}"`)
      }
    }

    // 检查 poets 表
    console.log('\n2. 检查 poets 表...')
    const { data: poets, error: poetsError } = await supabase
      .from('poets')
      .select('*')
      .limit(1)

    if (poetsError) {
      console.log('   ❌ 错误:', poetsError.message)
    } else {
      console.log(`   ✅ 表存在，数据条数: ${poets.length}`)
    }

    console.log('\n🎯 问题分析:')
    if (poemsError || poetsError) {
      console.log('   📝 数据库表尚未创建')
      console.log('   🔧 解决方案:')
      console.log('      1. 登录 Supabase 控制台 (https://supabase.com/dashboard)')
      console.log('      2. 进入您的项目')
      console.log('      3. 在 SQL Editor 中运行 supabase/schema.sql 文件')
      console.log('      4. 重新检查数据库状态')
    } else if (poems.length === 0) {
      console.log('   📝 表已创建但数据为空')
      console.log('   🔧 解决方案:')
      console.log('      运行 schema.sql 中的 INSERT 语句插入示例数据')
    } else {
      console.log('   ✅ 数据库配置正常，诗词内容应该正常显示')
    }

  } catch (error) {
    console.log('❌ 检查过程中出现错误:', error.message)
  }
}

checkDatabase()