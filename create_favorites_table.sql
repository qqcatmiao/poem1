-- 创建收藏表的SQL命令
-- 在Supabase SQL Editor中执行

-- 创建收藏表
CREATE TABLE IF NOT EXISTS favorites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    poem_id UUID NOT NULL REFERENCES poems(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, poem_id) -- 防止重复收藏
);

-- 启用行级安全策略
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;

-- 创建安全策略
CREATE POLICY "用户可以查看自己的收藏" ON favorites 
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "用户可以添加收藏" ON favorites 
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "用户可以删除自己的收藏" ON favorites 
FOR DELETE USING (auth.uid() = user_id);

-- 创建索引提高查询性能
CREATE INDEX IF NOT EXISTS idx_favorites_user_id ON favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_favorites_poem_id ON favorites(poem_id);

-- 验证表创建成功
SELECT '收藏表创建成功！' as result;