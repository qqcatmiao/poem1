# 项目结构说明

## 整体架构
```
poem-platform/
├── src/                    # 源代码目录
│   ├── components/         # 可复用组件
│   ├── views/             # 页面视图组件
│   ├── stores/            # 状态管理
│   ├── router/            # 路由配置
│   ├── assets/            # 静态资源
│   ├── utils/             # 工具函数
│   └── main.js            # 应用入口
├── supabase/              # 数据库相关
├── public/                # 公共资源
└── 配置文件
```

## 核心文件说明

### 配置文件
- `package.json` - 项目依赖和脚本配置
- `vite.config.js` - Vite 构建工具配置
- `.env.example` - 环境变量模板

### 应用入口
- `src/main.js` - Vue 应用初始化
- `src/App.vue` - 根组件，包含导航和路由视图

### 路由系统
- `src/router/index.js` - 定义所有页面路由
- 支持路由守卫和权限控制

### 状态管理
- `src/stores/auth.js` - 用户认证状态管理
- 使用 Pinia 进行状态管理

### 数据层
- `src/supabase.js` - Supabase 客户端配置
- 统一的 API 调用接口

### 页面组件
- `src/views/HomeView.vue` - 首页，展示精选诗词
- `src/views/PoemsView.vue` - 诗词列表页，支持筛选
- `src/views/PoemDetailView.vue` - 诗词详情页，包含赏析和评论
- `src/views/SearchView.vue` - 搜索页面
- `src/views/FavoritesView.vue` - 用户收藏页面
- `src/views/LoginView.vue` - 用户登录
- `src/views/RegisterView.vue` - 用户注册

### 通用组件
- `src/components/NavBar.vue` - 导航栏组件

### 工具函数
- `src/utils/helpers.js` - 通用工具函数

### 数据库
- `supabase/schema.sql` - 数据库表结构和示例数据

## 开发规范

### 组件命名
- 页面组件使用 PascalCase，如 `PoemDetailView.vue`
- 通用组件使用 PascalCase，如 `NavBar.vue`

### 文件组织
- 相关功能模块放在同一目录
- 组件按功能模块划分
- 工具函数按用途分类

### 样式规范
- 使用 CSS 变量维护主题色彩
- 采用响应式设计
- 组件样式使用 scoped CSS

## 数据流
1. 用户操作触发组件方法
2. 调用 store 中的 action
3. 通过 Supabase SDK 与后端交互
4. 更新 store 状态
5. 组件响应式更新 UI

## 扩展指南
- 添加新页面：在 `views/` 创建组件，在路由中注册
- 添加新功能：创建对应的 store 和组件
- 修改样式：更新 CSS 变量或组件样式