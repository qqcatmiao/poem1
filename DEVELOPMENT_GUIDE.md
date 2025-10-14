# 开发指南

## 环境准备

### 1. 安装 Node.js
- 确保 Node.js 版本 16+
- 下载地址：https://nodejs.org/

### 2. 安装依赖
```bash
npm install
```

### 3. 配置 Supabase

#### 创建 Supabase 项目
1. 访问 https://supabase.com
2. 注册账号并创建新项目
3. 获取项目 URL 和 anon key

#### 配置环境变量
```bash
cp .env.example .env
```
编辑 `.env` 文件：
```env
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

#### 初始化数据库
1. 在 Supabase 控制台打开 SQL 编辑器
2. 运行 `supabase/schema.sql` 中的 SQL 语句

### 4. 启动开发服务器
```bash
npm run dev
```

## 开发流程

### 添加新功能

#### 1. 添加新页面
```javascript
// 在 src/views/ 创建组件
// 在 src/router/index.js 添加路由
{
  path: '/new-page',
  name: 'NewPage',
  component: () => import('../views/NewPageView.vue')
}
```

#### 2. 添加状态管理
```javascript
// 在 src/stores/ 创建新的 store
import { defineStore } from 'pinia'

export const useNewStore = defineStore('new', {
  state: () => ({
    data: null
  }),
  actions: {
    async fetchData() {
      // 调用 API
    }
  }
})
```

#### 3. 调用 API
```javascript
import { supabase, TABLES } from '../supabase'

// 查询数据
const { data, error } = await supabase
  .from(TABLES.POEMS)
  .select('*')
  .eq('dynasty', '唐')

// 插入数据
const { error } = await supabase
  .from(TABLES.COMMENTS)
  .insert([{ content: '评论内容', poem_id: 'xxx' }])
```

### 样式开发

#### CSS 变量使用
```css
.element {
  color: var(--primary-color);
  background: var(--bg-primary);
}
```

#### 响应式设计
```css
@media (max-width: 768px) {
  .container {
    padding: 1rem;
  }
}
```

### 测试和调试

#### 开发工具
- 使用 Vue Devtools 调试组件
- 浏览器开发者工具检查网络请求

#### 错误处理
```javascript
try {
  const { data, error } = await supabase.from('table').select('*')
  if (error) throw error
  // 处理数据
} catch (error) {
  console.error('API 调用失败:', error)
}
```

## 部署指南

### 构建生产版本
```bash
npm run build
```

### 部署到平台

#### Vercel
1. 连接 GitHub 仓库
2. 配置环境变量
3. 自动部署

#### Netlify
1. 拖拽 dist 文件夹到 Netlify
2. 或连接 Git 仓库自动部署

### Supabase 配置

#### 环境设置
- 确保生产环境 RLS 策略正确
- 配置适当的 CORS 规则

#### 数据库备份
- 定期备份生产数据库
- 使用 Supabase 的备份功能

## 性能优化

### 代码分割
- 使用路由懒加载
- 按需引入组件

### 图片优化
- 使用 WebP 格式
- 实现懒加载

### 缓存策略
- 合理使用浏览器缓存
- Supabase 查询优化

## 安全最佳实践

### 认证安全
- 使用 HTTPS
- 验证用户输入
- 实施适当的 RLS 策略

### 数据保护
- 不存储敏感信息在前端
- 使用环境变量保护密钥

## 故障排除

### 常见问题

#### 1. 环境变量不生效
- 检查 `.env` 文件格式
- 重启开发服务器

#### 2. Supabase 连接失败
- 检查项目 URL 和密钥
- 验证网络连接

#### 3. 构建错误
- 清除 node_modules 重新安装
- 检查依赖版本兼容性

### 获取帮助
- 查看 Supabase 文档
- 检查 Vue 3 官方文档
- 在项目 Issues 中提问