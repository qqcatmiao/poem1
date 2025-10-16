-- 修复登录注册功能的RLS策略

-- 1. 首先检查现有的profiles表策略
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check 
FROM pg_policies 
WHERE tablename = 'profiles';

-- 2. 删除现有的profiles表策略（如果存在）
DROP POLICY IF EXISTS "任何人都可以查看档案" ON profiles;
DROP POLICY IF EXISTS "用户可以管理自己的档案" ON profiles;
DROP POLICY IF EXISTS "用户可以查看所有档案" ON profiles;
DROP POLICY IF EXISTS "用户可以更新自己的档案" ON profiles;
DROP POLICY IF EXISTS "用户可以插入自己的档案" ON profiles;

-- 3. 重新创建正确的profiles表RLS策略
-- 允许任何人查看档案（用于显示用户信息）
CREATE POLICY "任何人都可以查看档案" ON profiles FOR SELECT USING (true);

-- 允许用户插入自己的档案（注册时自动创建）
CREATE POLICY "用户可以插入自己的档案" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- 允许用户更新自己的档案
CREATE POLICY "用户可以更新自己的档案" ON profiles FOR UPDATE USING (auth.uid() = id);

-- 4. 修复auth配置 - 启用邮箱验证（可选）
-- 在Supabase仪表板的Authentication > Settings中配置
-- 建议设置：Enable email confirmations = OFF（开发环境）

-- 5. 创建触发器函数来自动创建用户档案（备用方案）
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

-- 6. 创建触发器（如果希望自动创建档案）
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 7. 验证修复结果
SELECT 'RLS策略修复完成！' as status;

-- 检查profiles表的新策略
SELECT policyname, cmd, qual 
FROM pg_policies 
WHERE tablename = 'profiles'
ORDER BY policyname;