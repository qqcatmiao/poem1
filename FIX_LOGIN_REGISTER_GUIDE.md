# 登录注册功能修复指南

## 🔍 问题分析
登录注册功能出现 "new row violates row-level security policy for table 'profiles'" 错误，原因是：
- 用户注册时前端代码尝试插入profiles表记录
- 但RLS策略阻止了非认证用户的插入操作

## 🛠️ 解决方案

### 方案1：使用数据库触发器（推荐）

#### 步骤1：创建触发器
在Supabase SQL编辑器中运行 `create-auth-trigger.sql`：

1. 登录 Supabase 控制台
2. 进入 SQL Editor
3. 复制 `create-auth-trigger.sql` 内容
4. 执行SQL语句

#### 步骤2：验证触发器
执行后检查触发器是否创建成功。

### 方案2：修复RLS策略

#### 步骤1：运行RLS修复脚本
在SQL编辑器中运行 `fix-auth-rls.sql` 文件。

#### 步骤2：修改注册逻辑
前端代码已经修改为使用Supabase Auth的元数据功能，不再直接插入profiles表。

## 🔧 代码修改说明

### 前端修改
- **RegisterView.vue**: 移除了直接插入profiles表的代码
- 现在使用 `supabase.auth.signUp()` 的 `options.data` 传递用户名
- 用户档案将通过数据库触发器自动创建

### 数据库修改
- **触发器**: 用户注册后自动创建profiles记录
- **RLS策略**: 允许用户管理自己的档案

## 🚀 测试步骤

### 1. 部署数据库修改
在Supabase控制台执行相应的SQL脚本。

### 2. 测试注册功能
1. 访问 `/register` 页面
2. 填写用户名、邮箱、密码
3. 点击注册按钮
4. 应该看到注册成功提示

### 3. 测试登录功能
1. 访问 `/login` 页面  
2. 使用注册的邮箱和密码登录
3. 应该成功跳转到首页

## 💡 故障排除

### 如果注册仍然失败
1. **检查Supabase认证设置**:
   - 进入 Authentication > Settings
   - 确认邮箱验证设置（开发环境建议关闭）
   - 检查允许的域名和重定向URL

2. **检查触发器状态**:
   ```sql
   SELECT * FROM information_schema.triggers 
   WHERE event_object_table = 'users';
   ```

3. **手动测试触发器**:
   ```sql
   -- 测试触发器函数
   SELECT public.handle_new_user();
   ```

### 如果登录失败
1. 检查邮箱和密码是否正确
2. 确认用户是否已通过邮箱验证（如果启用了验证）
3. 检查浏览器控制台是否有错误信息

## 📋 验证清单

- [ ] 数据库触发器已创建
- [ ] RLS策略配置正确  
- [ ] 注册功能正常工作
- [ ] 登录功能正常工作
- [ ] 用户档案自动创建
- [ ] 导航栏显示用户状态

完成以上步骤后，登录注册功能应该可以正常使用。