import axios from 'axios'

// 使用Netlify代理路径解决CORS问题
const N8N_WORKFLOW_URL = '/n8n/webhook/poem-chat'

// 模拟响应（在工作流激活前使用）
const MOCK_RESPONSES = {
  '你好': '您好！我是诗词助手，很高兴为您服务。',
  '春夜喜雨': '《春夜喜雨》是唐代诗人杜甫的作品：好雨知时节，当春乃发生。随风潜入夜，润物细无声。',
  '李白': '李白，字太白，号青莲居士，唐代伟大的浪漫主义诗人。',
  'default': '收到您的消息！n8n工作流正在配置中，请稍后重试。'
}

/**
 * 调用n8n聊天机器人工作流
 * @param {string} message - 用户输入的消息
 * @returns {Promise<string>} - 机器人的回复
 */
export async function callN8nChatBot(message) {
  // 临时模拟响应（取消注释以启用）
  // const mockResponse = MOCK_RESPONSES[message] || MOCK_RESPONSES.default
  // return Promise.resolve(mockResponse)
  
  try {
    const response = await axios.post(N8N_WORKFLOW_URL, {
      message: message,
      timestamp: new Date().toISOString()
    }, {
      timeout: 100000, // 10秒超时
      headers: {
        'Content-Type': 'application/json'
      }
    })

    // 根据n8n工作流的响应格式处理回复
    try {
      const data = response.data
      // 处理原始模板字符串响应
      if (typeof data === 'string') {
        // 尝试解析模板字符串中的内容
        if (data.includes('$json.messages[0].content')) {
          // 检查是否有完整的响应对象
          if (response?.data?.messages?.[0]?.content) {
            return response.data.messages[0].content
          }
          // 尝试从模板字符串中提取内容
          const contentMatch = data.match(/"content":"([^"]+)"/) || 
                             data.match(/content=([^&]+)/) ||
                             data.match(/content:\s*([^]+)/)
          return contentMatch?.[1] || '工作流返回了未解析的模板，请检查n8n工作流配置。'
        }
        // 如果是普通字符串直接返回
        return data
      }
      // 处理对象格式响应
      else if (typeof data === 'object') {
        // 尝试从不同可能的字段中提取内容
        return data.messages?.[0]?.content || 
               data.answer ||
               data.output ||
               data.message ||
               data.reply ||
               JSON.stringify(data)
      }
      // 处理数组格式响应
      else if (Array.isArray(data) && data[0]?.output) {
        return data[0].output
      } 
      // 处理对象格式响应
      else if (data?.output) {
        return data.output
      }
      // 处理字符串格式响应
      else if (typeof data === 'string') {
        return data
      }
      // 处理其他可能格式
      else if (data?.message) {
        return data.message
      } else if (data?.reply) {
        return data.reply
      }
      // 默认处理
      return JSON.stringify(data) || '收到您的消息，但工作流返回的格式无法识别。'
    } catch (e) {
      console.error('解析工作流响应失败:', e)
      return '工作流响应处理出错，请检查控制台日志。'
    }
  } catch (error) {
    console.error('调用n8n聊天机器人失败:', error)
    
    if (error.code === 'ECONNABORTED') {
      return '请求超时，请稍后再试。'
    } else if (error.response) {
      // 服务器返回错误状态码
      return `服务器错误: ${error.response.status}`
    } else if (error.request) {
      // 请求已发送但没有收到响应
      return '网络连接错误，请检查网络连接。'
    } else {
      return '发生未知错误，请稍后再试。'
    }
  }
}
