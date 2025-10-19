import axios from 'axios'

async function debugN8nConnection() {
  console.log('=== n8n聊天机器人连接诊断 ===\n')
  
  const testUrl = 'https://n8n-mcwlygnr.us-east-1.clawcloudrun.com/webhook/8gVnRdN9s9VGJNQx'
  
  console.log('1. 测试URL可达性...')
  try {
    // 先测试基本连接
    const headResponse = await axios.head(testUrl, { timeout: 5000 })
    console.log('✅ URL可达，状态码:', headResponse.status)
  } catch (error) {
    console.log('❌ URL不可达:', error.message)
    return
  }
  
  console.log('\n2. 测试POST请求...')
  try {
    const response = await axios.post(
      testUrl,
      {
        message: '测试连接',
        timestamp: new Date().toISOString()
      },
      {
        timeout: 10000,
        headers: {
          'Content-Type': 'application/json'
        }
      }
    )
    
    console.log('✅ POST请求成功！')
    console.log('状态码:', response.status)
    console.log('响应头:', JSON.stringify(response.headers, null, 2))
    console.log('响应数据:', JSON.stringify(response.data, null, 2))
    
  } catch (error) {
    console.log('❌ POST请求失败:')
    
    if (error.response) {
      console.log('状态码:', error.response.status)
      console.log('响应头:', JSON.stringify(error.response.headers, null, 2))
      console.log('响应数据:', error.response.data)
      
      if (error.response.status === 404) {
        console.log('\n🔍 问题分析:')
        console.log('工作流未激活或URL不正确')
        console.log('请检查:')
        console.log('1. 工作流ID是否正确: 8gVnRdN9s9VGJNQx')
        console.log('2. 工作流是否已激活')
        console.log('3. URL格式是否正确 (应该是/webhook/路径)')
      }
      
    } else if (error.code === 'ECONNABORTED') {
      console.log('请求超时 - 可能是网络问题或服务器响应慢')
    } else if (error.request) {
      console.log('无响应 - 网络连接问题')
    } else {
      console.log('其他错误:', error.message)
    }
  }
  
  console.log('\n3. 测试备选URL...')
  const alternativeUrls = [
    'https://n8n-mcwlygnr.us-east-1.clawcloudrun.com/webhook/test/8gVnRdN9s9VGJNQx',
    'https://n8n-mcwlygnr.us-east-1.clawcloudrun.com/webhook/8gVnRdN9s9VGJNQx/test'
  ]
  
  for (const url of alternativeUrls) {
    try {
      const response = await axios.post(url, { message: 'test' }, { timeout: 5000 })
      console.log(`✅ 备选URL可用: ${url}`)
      console.log('状态码:', response.status)
    } catch (error) {
      console.log(`❌ 备选URL不可用: ${url}`)
    }
  }
}

debugN8nConnection()