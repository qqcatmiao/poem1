# 诗词收藏网站

基于Vue 3 + Supabase的诗词收藏和评论网站

## 功能特性
- 📚 诗词浏览和搜索
- 🔐 用户注册登录
- ⭐ 诗词收藏功能
- 💬 评论系统
- 📱 响应式设计

## 技术栈
- Vue 3 + Vite
- Supabase (后端即服务)
- Vue Router
- Pinia (状态管理)

## 项目结构
```
src/
├── components/     # 公共组件
├── views/          # 页面组件
├── stores/         # 状态管理
├── router/         # 路由配置
├── utils/          # 工具函数
└── supabase.js     # Supabase配置
```

## 快速开始

### 环境要求
- Node.js 16+
- npm 或 yarn

### 安装依赖
```bash
npm install
```

### 环境配置
复制 `.env.example` 为 `.env` 并配置：
```
VITE_SUPABASE_URL=your_supabase_project_url_here
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key_here
```

### 开发运行
```bash
npm run dev
```

### 构建生产版本
```bash
npm run build
```

## 数据库结构
项目使用Supabase PostgreSQL数据库，包含以下表：
- `poems` - 诗词表
- `poets` - 诗人表  
- `profiles` - 用户档案表
- `favorites` - 收藏表
- `comments` - 评论表

## 部署指南

### Vercel部署
1. Fork此仓库
2. 在Vercel中导入项目
3. 配置环境变量
4. 部署完成

### Netlify部署
1. 构建项目：`npm run build`
2. 将dist文件夹拖拽到Netlify
3. 配置环境变量

## 功能截图
- 首页诗词展示
- 诗词详情页（含收藏和评论）
- 用户登录注册
- 收藏管理
- 搜索功能

## 许可证
MIT License