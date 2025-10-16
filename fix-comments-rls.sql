-- 修复评论功能的RLS策略
-- 在Supabase SQL Editor中执行

-- 1. 检查当前的RLS策略
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies 
WHERE tablename = 'comments';

-- 2. 删除现有的评论表RLS策略（如果存在）
DROP POLICY IF EXISTS "用户可以查看所有评论" ON comments;
DROP POLICY IF EXISTS "用户只能管理自己的评论" ON comments;

-- 3. 重新创建评论表的RLS策略
-- 允许所有人查看评论
CREATE POLICY "任何人都可以查看评论" ON comments FOR SELECT USING (true);

-- 允许认证用户插入评论
CREATE POLICY "认证用户可以添加评论" ON comments FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

-- 允许用户更新自己的评论
CREATE POLICY "用户可以更新自己的评论" ON comments FOR UPDATE USING (auth.uid() = user_id);

-- 允许用户删除自己的评论
CREATE POLICY "用户可以删除自己的评论" ON comments FOR DELETE USING (auth.uid() = user_id);

-- 4. 验证策略是否生效
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies 
WHERE tablename = 'comments';

-- 5. 测试评论功能
SELECT '评论功能RLS策略修复完成！' as status;