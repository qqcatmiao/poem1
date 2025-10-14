# 故障排除指南

## 连接被拒绝问题 (ERR_CONNECTION_REFUSED)

### 1. 检查开发服务器是否运行
```bash
# 检查进程
netstat -ano | findstr :3000

# 如果没有输出，说明服务器未运行
```

### 2. 手动启动开发服务器
```bash
# 方法1: 使用 npm
npm run dev

# 方法2: 使用批处理文件
start-dev.bat

# 方法3: 直接运行 vite
npx vite --host 0.0.0.0 --port 3000
```

### 3. 检查防火墙设置
- 确保防火墙允许 Node.js 访问网络
- 临时关闭防火墙测试连接

### 4. 端口占用问题
如果端口 3000 被占用，Vite 会自动选择其他端口。检查控制台输出：
```
➜  Local:   http://localhost:3000/
➜  Network: http://192.168.1.100:3000/
```

### 5. 使用不同浏览器测试
- 尝试 Chrome、Firefox、Edge 等不同浏览器
- 清除浏览器缓存

## 常见错误解决方案

### 依赖安装失败
```bash
# 清除缓存重新安装
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

### Supabase 连接问题
1. 检查 `.env` 文件配置是否正确
2. 验证 Supabase 项目是否激活
3. 检查网络连接

### Vue 组件错误
1. 检查浏览器控制台错误信息
2. 使用 Vue Devtools 调试组件

## 调试技巧

### VSCode 调试
1. 按 F5 启动调试
2. 选择 "全栈调试" 配置
3. 设置断点进行调试

### 浏览器调试
1. 打开开发者工具 (F12)
2. 查看 Console 和 Network 标签
3. 检查错误信息和网络请求

## 环境检查清单

- [ ] Node.js 版本 >= 16
- [ ] npm 已正确安装
- [ ] 项目依赖已安装 (node_modules 存在)
- [ ] .env 文件已配置 Supabase 信息
- [ ] 端口 3000 未被占用
- [ ] 防火墙允许 Node.js 访问

## 快速测试
运行以下命令检查环境：
```bash
node --version
npm --version
npm list vue
```

如果以上检查都通过，但问题仍然存在，请提供具体的错误信息以便进一步诊断。