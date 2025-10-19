# n8n工作流激活详细指南

## 问题诊断结果
- **状态**: ❌ 工作流未激活
- **错误**: 404 - "The requested webhook is not registered"
- **URL**: `https://n8n-mcwlygnr.us-east-1.clawcloudrun.com/webhook/8gVnRdN9s9VGJNQx`

## 详细激活步骤

### 步骤1: 登录n8n控制台
1. 打开浏览器，访问: https://n8n-mcwlygnr.us-east-1.clawcloudrun.com
2. 使用您的n8n账户登录

### 步骤2: 找到工作流
1. 登录后进入主控制台
2. 在左侧菜单点击"Workflows"
3. 在列表中找到ID为 `8gVnRdN9s9VGJNQx` 的工作流
4. 或者根据工作流名称查找（可能是"诗词助手"或类似名称）

### 步骤3: 激活工作流
1. 点击工作流进入编辑器
2. 在编辑器右上角找到激活开关
3. **将开关从"停用"切换到"激活"**
4. 开关通常显示为:
   - 🔴 红色/灰色 = 停用
   - 🟢 绿色 = 激活

### 步骤4: 验证激活
激活后，工作流应该显示为"Active"状态。此时webhook URL应该可以正常访问。

## 验证方法

激活后运行测试命令:
```bash
node test-n8n.js
```

期望结果:
```
✅ 连接成功！
状态码: 200
响应数据: { ... }
```

## 备选方案

如果无法激活工作流，可以考虑:

### 方案1: 使用测试URL
n8n通常提供两种URL:
- **生产URL**: `https://n8n-mcwlygnr.us-east-1.clawcloudrun.com/webhook/8gVnRdN9s9VGJNQx` (需要激活)
- **测试URL**: `https://n8n-mcwlygnr.us-east-1.clawcloudrun.com/webhook-test/8gVnRdN9s9VGJNQx` (无需激活)

尝试修改 `src/utils/n8nChatBot.js` 中的URL为测试版本。

### 方案2: 检查工作流配置
确保工作流中:
1. Webhook节点配置正确
2. 有正确的响应输出
3. 工作流逻辑完整

## 临时解决方案

在激活工作流之前，可以启用模拟模式让聊天机器人暂时工作:

1. 编辑 `src/utils/n8nChatBot.js`
2. 取消注释模拟响应代码
3. 这样用户可以看到界面，但收到模拟回复

## 技术支持

如果仍有问题:
1. 检查n8n实例的运行状态
2. 确认工作流ID是否正确
3. 联系n8n管理员确认权限

## 成功标志

当您看到以下响应时，说明集成成功:
- 聊天机器人按钮正常显示
- 点击后可以展开聊天窗口
- 发送消息后收到n8n工作流的智能回复
- 没有超时或404错误