# Supabase 配置指南

## 项目当前状态

✅ **已完成配置：**
- Supabase JS SDK 已安装 (`@supabase/supabase-js`)
- 数据库 schema 已设计 (`supabase/schema.sql`)
- 客户端配置已创建 (`src/supabase.js`)
- 环境变量模板已配置 (`.env.example`)

## 配置步骤

### 1. 创建 Supabase 项目

1. 访问 [Supabase 官网](https://supabase.com)
2. 注册/登录账户
3. 创建新项目
4. 获取项目 URL 和 anon key

### 2. 配置环境变量

复制 `.env.example` 为 `.env` 并填入实际值：

```env
# Supabase 配置
VITE_SUPABASE_URL=你的实际项目URL
VITE_SUPABASE_ANON_KEY=你的实际anon key

# 开发环境配置
VITE_APP_ENV=development
```

### 3. 部署数据库

在 Supabase 控制台的 SQL 编辑器中，运行 `supabase/schema.sql` 文件中的 SQL 语句来创建表结构和示例数据。

### 4. 配置 Row Level Security (RLS)

数据库表已启用 RLS 并配置了基本策略：
- 诗词和诗人表：所有人可读
- 用户档案：用户只能管理自己的数据
- 收藏和评论：用户只能管理自己的记录

### 5. 测试连接

启动开发服务器测试连接：

```bash
npm run dev
```

## 数据库结构

### 主要表

1. **poets** - 诗人信息
2. **poems** - 诗词内容
3. **profiles** - 用户档案（扩展 Supabase Auth）
4. **favorites** - 收藏关系
5. **comments** - 评论系统

## API 使用示例

```javascript
import { supabase, TABLES } from './src/supabase.js'

// 获取所有诗词
const { data: poems, error } = await supabase
  .from(TABLES.POEMS)
  .select(`
    *,
    poets (*)
  `)

// 搜索特定朝代的诗词
const { data: tangPoems } = await supabase
  .from(TABLES.POEMS)
  .select('*')
  .eq('dynasty', '唐')

// 用户收藏诗词
const { error: favError } = await supabase
  .from(TABLES.FAVORITES)
  .insert({
    user_id: currentUser.id,
    poem_id: selectedPoem.id
  })
```

## 故障排除

### 常见问题

1. **环境变量未生效**：确保 `.env` 文件在项目根目录
2. **RLS 策略错误**：检查 Supabase 控制台的 RLS 策略
3. **CORS 问题**：在 Supabase 项目中配置正确的域名

### 调试模式

项目配置了降级方案，当 Supabase 环境变量未配置时会自动使用模拟数据。

## 下一步

1. 配置 Supabase 项目并获取 URL/key
2. 更新 `.env` 文件中的实际值
3. 在 Supabase 控制台运行数据库初始化脚本
4. 测试 API 连接
5. 根据需求调整 RLS 策略