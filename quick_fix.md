# 快速修复收藏功能

## 问题诊断
收藏功能不工作的原因是：**收藏表 (favorites) 不存在**

## 解决方案

### 方法1：使用Supabase Dashboard（推荐）

1. **登录Supabase Dashboard**
   - 访问 https://supabase.com/dashboard
   - 选择项目 `rbarqocuypmpybeckwxk`

2. **执行SQL创建收藏表**
   - 在左侧菜单点击 **SQL Editor**
   - 新建查询
   - 复制粘贴以下SQL并执行：

```sql
CREATE TABLE favorites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id),
    poem_id UUID NOT NULL REFERENCES poems(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, poem_id)
);

ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;

CREATE POLICY "用户管理收藏" ON favorites 
FOR ALL USING (auth.uid() = user_id);
```

3. **验证创建成功**
   - 执行后应该看到成功消息
   - 在左侧菜单点击 **Table Editor**，应该能看到 `favorites` 表

### 方法2：使用cURL命令

如果无法访问Dashboard，可以使用以下命令：

```bash
curl -X POST "https://rbarqocuypmpybeckwxk.supabase.co/rest/v1/" \
-H "apikey: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJiYXJxb2N1eXBtcHliZWNrd3hrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1MDkzNjEsImV4cCI6MjA3NjA4NTM2MX0.pfnRg8585zathN6QGRW3IPS-OT-z8RrPGaxWUpttLRQ" \
-H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJiYXJxb2N1eXBtcHliZWNrd3hrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1MDkzNjEsImV4cCI6MjA3NjA4NTM2MX0.pfnRg8585zathN6QGRW3IPS-OT-z8RrPGaxWUpttLRQ" \
-H "Content-Type: application/json" \
-d '{
  "query": "CREATE TABLE favorites (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), user_id UUID NOT NULL REFERENCES auth.users(id), poem_id UUID NOT NULL REFERENCES poems(id), created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(), UNIQUE(user_id, poem_id))"
}'
```

## 验证修复

表创建完成后：
1. 重启应用（如果正在运行）
2. 重新登录
3. 尝试收藏一首诗词
4. 检查"我的收藏"页面

收藏功能应该就能正常工作了！

## 如果仍有问题

如果创建表后仍有问题，请检查：
1. 浏览器控制台是否有错误信息
2. 网络连接是否正常
3. 用户是否已正确登录