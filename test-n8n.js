import axios from 'axios'

async function testN8nConnection() {
  console.log('正在测试n8n聊天机器人连接...')
  
  try {
    const response = await axios.post(
      'https://n8n-mcwlygnr.us-east-1.clawcloudrun.com/webhook/8gVnRdN9s9VGJNQx',
      {
        message: '你好，测试连接',
        timestamp: new Date().toISOString()
      },
      {
        timeout: 10000,
        headers: {
          'Content-Type': 'application/json'
        }
      }
    )
    
    console.log('✅ 连接成功！')
    console.log('响应状态:', response.status)
    console.log('响应数据:', JSON.stringify(response.data, null, 2))
    
  } catch (error) {
    console.error('❌ 连接失败:')
    
    if (error.response) {
      console.log('状态码:', error.response.status)
      console.log('响应数据:', error.response.data)
    } else if (error.request) {
      console.log('请求已发送但无响应:', error.message)
    } else {
      console.log('错误信息:', error.message)
    }
  }
}

testN8nConnection()