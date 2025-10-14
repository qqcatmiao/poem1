// 通用工具函数

// 格式化日期
export const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

// 防抖函数
export const debounce = (func, wait) => {
  let timeout
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout)
      func(...args)
    }
    clearTimeout(timeout)
    timeout = setTimeout(later, wait)
  }
}

// 诗词内容格式化（处理换行）
export const formatPoemContent = (content) => {
  return content.replace(/。/g, '。\n').replace(/？/g, '？\n').replace(/！/g, '！\n')
}

// 提取诗词首句作为简介
export const getPoemExcerpt = (content, length = 50) => {
  const firstSentence = content.split(/[。！？]/)[0]
  return firstSentence.length > length 
    ? firstSentence.substring(0, length) + '...' 
    : firstSentence
}

// 检查用户权限
export const hasPermission = (user, requiredRole) => {
  if (!user) return false
  // 这里可以根据实际需求扩展权限检查逻辑
  return true
}