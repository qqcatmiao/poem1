// 调试首页数据加载问题
import { createMockClient } from './src/utils/mockData.js'

async function debugHomeView() {
  console.log('🔍 调试首页数据加载...')
  
  const mockClient = createMockClient()
  
  try {
    // 模拟首页的查询
    console.log('📖 执行首页查询...')
    const { data, error } = await mockClient
      .from('poems')
      .select('*, poets (name)')
      .limit(6)
      .order('created_at', { ascending: false })
    
    if (error) {
      console.error('❌ 查询错误:', error)
      return
    }
    
    console.log('✅ 查询成功')
    console.log('📊 返回数据数量:', data.length)
    console.log('📋 数据结构:', Object.keys(data[0]))
    
    // 检查数据转换逻辑
    console.log('\n🔄 检查数据转换...')
    const transformedData = data.map(poem => ({
      ...poem,
      poet_name: poem.poets?.name || poem.poet_name
    }))
    
    console.log('✅ 转换后数据:', transformedData[0])
    console.log('🎯 poet_name 字段:', transformedData[0].poet_name)
    
    console.log('\n🎉 调试完成，数据加载正常！')
    
  } catch (error) {
    console.error('❌ 调试失败:', error)
  }
}

debugHomeView()