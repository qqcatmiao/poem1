# 快速启动指南

## 环境要求
- Node.js 16+
- npm 或 yarn

## 一键启动（推荐）
运行批处理文件自动完成所有步骤：
```bash
start-dev.bat
```

## 手动启动步骤

### 1. 安装依赖
```bash
npm install
```

### 2. 配置环境变量
复制环境变量模板并配置 Supabase 信息：
```bash
copy .env.example .env
```
编辑 `.env` 文件，填入你的 Supabase 项目 URL 和密钥。

### 3. 启动开发服务器
```bash
npm run dev
```

### 4. 访问应用
打开浏览器访问：http://localhost:3000

## 故障排除

### 如果遇到连接问题：
1. 检查防火墙设置
2. 尝试不同浏览器
3. 查看 `TROUBLESHOOTING.md` 获取详细解决方案

### 如果依赖安装失败：
```bash
# 清除缓存重新安装
npm cache clean --force
rmdir /s node_modules
del package-lock.json
npm install
```

## 项目验证
启动成功后应该看到：
- 古诗词赏析平台首页
- 导航栏功能正常
- 可以浏览诗词列表

## 下一步
1. 在 Supabase 控制台创建项目
2. 运行 `supabase/schema.sql` 初始化数据库
3. 开始开发你的功能模块

## 技术支持
- 查看 `README.md` 了解项目架构
- 查看 `DEVELOPMENT_GUIDE.md` 获取开发指南
- 查看 `PROJECT_STRUCTURE.md` 了解项目结构