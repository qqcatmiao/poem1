# MCP配置修复说明

## 🔍 问题分析
CodeBuddy的Supabase MCP配置出现连接错误，主要原因是：

1. **包不存在**: `@modelcontextprotocol/server-supabase` 包在npm仓库中不存在
2. **配置复杂**: 复杂的MCP服务器配置导致连接失败

## ✅ 解决方案
已采用简化配置方案：

### 配置调整
- **移除了MCP服务器配置**: 使用CodeBuddy内置的Supabase工具
- **保留核心配置**: Supabase项目URL和Anon Key保持不变
- **启用集成功能**: 启用数据库浏览器和查询构建器

### 当前配置状态
```json
{
  "supabaseConfig": {
    "projectUrl": "https://rbarqocuypmpybeckwxk.supabase.co",
    "anonKey": "您的Anon Key",
    "database": {
      "tables": ["poems", "poets", "profiles", "favorites", "comments"]
    }
  },
  "codebuddyIntegration": {
    "supabaseTools": true,
    "databaseExplorer": true,
    "queryBuilder": true
  }
}
```

## 🚀 功能预期
简化配置后，CodeBuddy将能够：
- 识别Supabase项目配置
- 提供基本的数据库工具支持
- 在开发过程中提供更好的代码提示

## 💡 后续建议
如果仍需要MCP功能，可以考虑：
1. 使用其他可用的Supabase MCP服务器
2. 等待官方发布稳定的MCP服务器包
3. 使用CodeBuddy现有的Supabase集成功能

当前配置已是最佳解决方案，应该能够解决连接错误问题。