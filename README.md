# 古诗词赏析平台

基于 Vue 3 + Supabase 的古诗词赏析平台 MVP 版本。

## 项目特性

- 🎨 现代化响应式设计
- 📚 古诗词浏览与搜索
- ❤️ 用户收藏功能
- 💬 评论互动系统
- 🔐 Supabase 身份认证
- 🚀 实时数据同步

## 技术栈

### 前端
- Vue 3 - 渐进式 JavaScript 框架
- Vue Router - 路由管理
- Pinia - 状态管理
- Vite - 构建工具

### 后端服务
- Supabase - BaaS 平台
- PostgreSQL - 数据库
- 实时 API - 数据同步

## 快速开始

### 环境要求

- Node.js 16+
- npm 或 yarn

### 安装步骤

1. 克隆项目
```bash
git clone <repository-url>
cd poem-platform
```

2. 安装依赖
```bash
npm install
```

3. 配置环境变量
```bash
cp .env.example .env
```
编辑 `.env` 文件，填入你的 Supabase 配置：
```
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

4. 初始化数据库
- 在 Supabase 控制台创建新项目
- 运行 `supabase/schema.sql` 中的 SQL 语句

5. 启动开发服务器
```bash
npm run dev
```

## 项目结构

```
src/
├── components/          # 可复用组件
│   └── NavBar.vue      # 导航栏组件
├── views/              # 页面视图
│   ├── HomeView.vue    # 首页
│   ├── PoemsView.vue   # 诗词列表页
│   ├── PoemDetailView.vue # 诗词详情页
│   ├── SearchView.vue  # 搜索页面
│   ├── FavoritesView.vue # 收藏页面
│   ├── LoginView.vue   # 登录页面
│   └── RegisterView.vue # 注册页面
├── stores/             # 状态管理
│   └── auth.js        # 认证状态
├── router/             # 路由配置
│   └── index.js       # 路由定义
├── supabase.js         # Supabase 客户端配置
└── main.js            # 应用入口

supabase/
└── schema.sql         # 数据库初始化脚本
```

## 功能模块

### 游客功能
- 浏览首页和诗词列表
- 搜索诗词内容
- 查看诗词详情和赏析

### 注册用户功能
- 用户注册和登录
- 收藏/取消收藏诗词
- 发表评论
- 管理个人收藏

### 管理员功能
- 管理诗词库
- 管理诗人信息
- 审核用户评论

## 数据库设计

主要数据表：
- `poets` - 诗人信息
- `poems` - 诗词内容
- `profiles` - 用户档案
- `favorites` - 收藏记录
- `comments` - 评论信息

## 开发指南

### 添加新功能
1. 在 `src/views/` 创建新的页面组件
2. 在 `src/router/index.js` 中添加路由
3. 如需状态管理，在 `src/stores/` 创建新的 store

### 样式规范
- 使用 CSS 变量维护主题色彩
- 采用响应式设计
- 保持古典雅致的视觉风格

## 部署

### 前端部署
可部署到 Vercel、Netlify 等平台：
```bash
npm run build
```

### Supabase 配置
- 确保 RLS 策略正确配置
- 设置适当的 CORS 规则
- 配置环境变量

## 后续开发计划

- [ ] AI 智能推荐功能
- [ ] 诗词接龙小游戏
- [ ] 多媒体内容支持
- [ ] 高级搜索功能
- [ ] 移动端优化

## 贡献指南

欢迎提交 Issue 和 Pull Request 来改进项目。

## 许可证

MIT License