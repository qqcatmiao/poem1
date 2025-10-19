# 聊天机器人集成指南

## 当前状态

✅ **前端集成已完成**
- 创建了悬浮式聊天机器人组件 (`src/components/ChatBot.vue`)
- 创建了n8n API调用工具 (`src/utils/n8nChatBot.js`)
- 已将聊天机器人添加到主应用 (`src/App.vue`)

❌ **n8n工作流需要激活**

## 需要您完成的操作

### 1. 激活n8n工作流

1. 登录您的n8n实例：https://n8n-mcwlygnr.us-east-1.clawcloudrun.com
2. 进入工作流编辑器，找到ID为 `8gVnRdN9s9VGJNQx` 的工作流
3. 在编辑器右上角找到激活/停用开关
4. **将开关切换到激活状态**（通常显示为绿色或"Active"）

### 2. 验证工作流URL

激活后，请确认webhook URL是否正确：
- **生产URL**: `https://n8n-mcwlygnr.us-east-1.clawcloudrun.com/webhook/8gVnRdN9s9VGJNQx`

### 3. 测试连接

激活工作流后，运行以下命令测试连接：

```bash
node test-n8n.js
```

如果返回成功响应，说明集成已完成。

## 功能特性

### 聊天机器人组件特性
- ✅ 悬浮在页面右下角的聊天按钮
- ✅ 可展开/收起的聊天窗口
- ✅ 实时消息显示和时间戳
- ✅ 响应式设计，适配移动端
- ✅ 与项目主题一致的UI风格

### 技术实现
- 使用Vue 3 Composition API
- 集成axios进行HTTP请求
- 自动滚动到最新消息
- 错误处理和超时机制
- 加载状态指示

## 启动项目

激活n8n工作流后，启动开发服务器：

```bash
npm run dev
```

访问 http://localhost:3000 即可看到右下角的聊天机器人按钮。

## 故障排除

### 常见问题

1. **工作流未激活**
   - 症状：返回404错误，提示"webhook is not registered"
   - 解决：按照上述步骤激活工作流

2. **网络连接问题**
   - 症状：请求超时或网络错误
   - 解决：检查网络连接，确认n8n实例可访问

3. **CORS错误**
   - 症状：浏览器控制台显示CORS错误
   - 解决：确保n8n工作流配置了正确的CORS头

### 测试脚本

项目根目录下的 `test-n8n.js` 可用于测试n8n连接：

```bash
node test-n8n.js
```

## 自定义配置

如果需要修改n8n工作流URL，请编辑 `src/utils/n8nChatBot.js` 中的 `N8N_WORKFLOW_URL` 常量。

## 下一步

完成上述步骤后，您的古诗词平台将拥有一个功能完整的AI聊天助手，可以帮助用户解答诗词相关问题！