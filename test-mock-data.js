// 测试模拟数据功能
import { createMockClient } from './src/utils/mockData.js'

async function testMockClient() {
  console.log('🧪 测试模拟客户端...')
  
  const mockClient = createMockClient()
  
  try {
    // 测试首页数据查询
    console.log('📖 测试首页诗词查询...')
    const result = await mockClient.from('poems')
      .select('*, poets (name)')
      .limit(6)
      .order('created_at', { ascending: false })
    
    console.log('✅ 查询成功，数据长度:', result.data.length)
    console.log('📊 返回数据示例:', JSON.stringify(result.data[0], null, 2))
    
    // 测试单条数据查询
    console.log('\n🔍 测试单条诗词查询...')
    const singleResult = await mockClient.from('poems')
      .select('*, poets (name)')
      .eq('id', '1')
      .single()
    
    console.log('✅ 单条查询成功:', singleResult.data ? '有数据' : '无数据')
    
    console.log('\n🎉 所有测试通过！模拟客户端工作正常。')
    
  } catch (error) {
    console.error('❌ 测试失败:', error)
  }
}

// 运行测试
testMockClient()