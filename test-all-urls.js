import axios from 'axios'

async function testAllUrls() {
  console.log('=== 测试所有可能的n8n URL格式 ===\n')
  
  const baseUrl = 'https://n8n-mcwlygnr.us-east-1.clawcloudrun.com'
  const workflowId = '8gVnRdN9s9VGJNQx'
  
  const testUrls = [
    // 生产URL格式
    `${baseUrl}/webhook/${workflowId}`,
    `${baseUrl}/webhook/${workflowId}/`,
    
    // 测试URL格式
    `${baseUrl}/webhook-test/${workflowId}`,
    `${baseUrl}/webhook-test/${workflowId}/`,
    
    // 可能的其他格式
    `${baseUrl}/api/v1/webhook/${workflowId}`,
    `${baseUrl}/api/v1/webhook-test/${workflowId}`,
    
    // 带路径的格式
    `${baseUrl}/webhook/${workflowId}/test`,
    `${baseUrl}/webhook-test/${workflowId}/test`,
  ]
  
  for (const url of testUrls) {
    console.log(`测试 URL: ${url}`)
    try {
      const response = await axios.post(
        url,
        { message: '测试连接', timestamp: new Date().toISOString() },
        { timeout: 5000, headers: { 'Content-Type': 'application/json' } }
      )
      console.log(`✅ 成功! 状态码: ${response.status}`)
      if (response.data) {
        console.log('响应数据:', JSON.stringify(response.data, null, 2))
      }
      console.log('---')
    } catch (error) {
      if (error.response) {
        console.log(`❌ 失败! 状态码: ${error.response.status}`)
        if (error.response.data) {
          console.log('错误信息:', JSON.stringify(error.response.data, null, 2))
        }
      } else {
        console.log(`❌ 失败! ${error.message}`)
      }
      console.log('---')
    }
  }
  
  console.log('\n=== 建议 ===')
  console.log('1. 如果所有URL都失败，请确认工作流已激活并保存')
  console.log('2. 检查n8n实例的控制台查看webhook URL')
  console.log('3. 确认工作流ID是否正确')
  console.log('4. 可能需要等待几分钟让激活生效')
}

testAllUrls()