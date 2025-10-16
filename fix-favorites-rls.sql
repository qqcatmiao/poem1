-- 修复收藏表RLS策略的SQL脚本
-- 在Supabase SQL Editor中执行

-- 1. 检查当前收藏表的RLS策略
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'favorites';

-- 2. 删除现有的收藏表RLS策略（如果存在）
DROP POLICY IF EXISTS "用户可以查看自己的收藏" ON favorites;
DROP POLICY IF EXISTS "用户可以添加收藏" ON favorites;
DROP POLICY IF EXISTS "用户可以删除自己的收藏" ON favorites;

-- 3. 重新创建正确的RLS策略
-- 允许用户查看所有收藏（包括自己的）
CREATE POLICY "任何人都可以查看收藏" ON favorites FOR SELECT USING (true);

-- 允许用户添加收藏（只能添加自己的）
CREATE POLICY "用户可以添加收藏" ON favorites 
FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 允许用户删除自己的收藏
CREATE POLICY "用户可以删除自己的收藏" ON favorites 
FOR DELETE USING (auth.uid() = user_id);

-- 4. 验证策略创建成功
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies 
WHERE tablename = 'favorites'
ORDER BY policyname;

-- 5. 测试收藏功能是否正常工作
-- 插入测试收藏记录（需要先有用户登录）
-- INSERT INTO favorites (user_id, poem_id) VALUES ('user-uuid-here', 'poem-uuid-here');

-- 查询测试
SELECT 'RLS策略修复完成！' as result;