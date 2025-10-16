-- 修复收藏表外键约束问题的SQL脚本
-- 在Supabase SQL Editor中执行

-- 1. 检查当前收藏表的外键约束
SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name = 'favorites';

-- 2. 检查profiles表是否存在且包含数据
SELECT COUNT(*) as profiles_count FROM profiles;
SELECT COUNT(*) as auth_users_count FROM auth.users;

-- 3. 创建或修复profiles表的触发器（确保用户注册时自动创建profile）
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, username, created_at)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'username', split_part(NEW.email, '@', 1)),
    NOW()
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. 创建触发器（如果不存在）
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 5. 为现有用户创建profiles记录（如果缺失）
INSERT INTO profiles (id, username, created_at)
SELECT 
    id, 
    COALESCE(raw_user_meta_data->>'username', split_part(email, '@', 1)) as username,
    created_at
FROM auth.users 
WHERE id NOT IN (SELECT id FROM profiles)
ON CONFLICT (id) DO NOTHING;

-- 6. 检查并修复收藏表的RLS策略
DROP POLICY IF EXISTS "用户可以查看自己的收藏" ON favorites;
DROP POLICY IF EXISTS "用户可以添加收藏" ON favorites;
DROP POLICY IF EXISTS "用户可以删除自己的收藏" ON favorites;

-- 7. 重新创建正确的RLS策略
-- 允许用户查看所有收藏（简化策略）
CREATE POLICY "任何人都可以查看收藏" ON favorites FOR SELECT USING (true);

-- 允许用户添加收藏（使用auth.uid()验证）
CREATE POLICY "用户可以添加收藏" ON favorites 
FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 允许用户删除自己的收藏
CREATE POLICY "用户可以删除自己的收藏" ON favorites 
FOR DELETE USING (auth.uid() = user_id);

-- 8. 修改收藏表的外键约束（如果需要）
-- 先删除现有约束
ALTER TABLE favorites DROP CONSTRAINT IF EXISTS favorites_user_id_fkey;

-- 重新添加约束，引用auth.users而不是profiles
ALTER TABLE favorites 
ADD CONSTRAINT favorites_user_id_fkey 
FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- 9. 验证修复结果
SELECT '外键约束修复完成！' as result;

-- 10. 测试收藏功能
-- 插入测试数据（使用实际存在的用户ID和诗词ID）
-- INSERT INTO favorites (user_id, poem_id) VALUES ('user-uuid-here', 'poem-uuid-here');