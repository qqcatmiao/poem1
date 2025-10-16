// 修复注册功能的代码调整

// 问题分析：注册时profiles表插入被RLS策略阻止
// 解决方案：修改注册逻辑，使用服务端密钥或调整策略

import { createClient } from '@supabase/supabase-js'

// 使用服务端密钥（需要在Supabase项目设置中获取）
const supabaseUrl = 'https://rbarqocuypmpybeckwxk.supabase.co'
const supabaseServiceKey = '您的服务端密钥' // 需要在Supabase项目设置中获取

// 修复后的注册函数
async function fixedRegister(userData) {
  const { email, password, username } = userData
  
  try {
    // 1. 使用客户端进行用户认证
    const authClient = createClient(supabaseUrl, '您的anon key')
    const { data: authData, error: authError } = await authClient.auth.signUp({
      email,
      password
    })
    
    if (authError) throw authError
    
    // 2. 使用服务端密钥创建用户档案（绕过RLS）
    if (authData.user) {
      const serviceClient = createClient(supabaseUrl, supabaseServiceKey)
      const { error: profileError } = await serviceClient
        .from('profiles')
        .insert([{
          id: authData.user.id,
          username: username,
          created_at: new Date().toISOString()
        }])
        
      if (profileError) {
        console.warn('档案创建失败，但用户已注册:', profileError.message)
        // 可以在这里添加重试逻辑或使用触发器
      }
    }
    
    return { success: true, user: authData.user }
  } catch (error) {
    return { success: false, error: error.message }
  }
}

// 替代方案：修改前端代码，使用更简单的注册流程
export const simplifiedRegister = async (userData) => {
  const { email, password, username } = userData
  
  try {
    // 只进行基本的用户注册，档案通过触发器自动创建
    const authClient = createClient(supabaseUrl, '您的anon key')
    const { data, error } = await authClient.auth.signUp({
      email,
      password,
      options: {
        data: {
          username: username
        }
      }
    })
    
    if (error) throw error
    return { success: true, user: data.user }
  } catch (error) {
    return { success: false, error: error.message }
  }
}

console.log('注册功能修复方案已准备')
console.log('请选择以下方案之一：')
console.log('1. 运行 fix-auth-rls.sql 修复RLS策略')
console.log('2. 获取服务端密钥并更新代码')
console.log('3. 使用触发器自动创建用户档案')