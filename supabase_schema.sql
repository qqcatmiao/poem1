-- Supabase 数据库表结构创建脚本
-- 在 Supabase SQL Editor 中执行这些命令

-- 1. 创建诗词表
CREATE TABLE IF NOT EXISTS poems (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    poet_name TEXT NOT NULL,
    dynasty TEXT NOT NULL,
    theme TEXT,
    appreciation TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. 创建诗人表
CREATE TABLE IF NOT EXISTS poets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT UNIQUE NOT NULL,
    dynasty TEXT NOT NULL,
    lifespan TEXT,
    introduction TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 创建用户资料表（扩展默认的 auth.users 表）
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT UNIQUE,
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. 创建收藏表
CREATE TABLE IF NOT EXISTS favorites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    poem_id UUID NOT NULL REFERENCES poems(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, poem_id) -- 防止重复收藏
);

-- 5. 创建评论表
CREATE TABLE IF NOT EXISTS comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    poem_id UUID NOT NULL REFERENCES poems(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. 启用行级安全策略 (RLS)
ALTER TABLE poems ENABLE ROW LEVEL SECURITY;
ALTER TABLE poets ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- 7. 创建安全策略

-- 诗词表策略：所有人都可以读取
CREATE POLICY "诗词公开读取" ON poems FOR SELECT USING (true);

-- 诗人表策略：所有人都可以读取
CREATE POLICY "诗人公开读取" ON poets FOR SELECT USING (true);

-- 用户资料表策略：用户可以读取所有资料，但只能修改自己的
CREATE POLICY "用户资料公开读取" ON profiles FOR SELECT USING (true);
CREATE POLICY "用户只能修改自己的资料" ON profiles FOR UPDATE USING (auth.uid() = id);

-- 收藏表策略：用户只能操作自己的收藏
CREATE POLICY "用户可以查看自己的收藏" ON favorites FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "用户可以添加收藏" ON favorites FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "用户可以删除自己的收藏" ON favorites FOR DELETE USING (auth.uid() = user_id);

-- 评论表策略：用户可以查看所有评论，但只能操作自己的
CREATE POLICY "评论公开读取" ON comments FOR SELECT USING (true);
CREATE POLICY "用户可以添加评论" ON comments FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "用户可以修改自己的评论" ON comments FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "用户可以删除自己的评论" ON comments FOR DELETE USING (auth.uid() = user_id);

-- 8. 插入示例数据

-- 插入诗人数据
INSERT INTO poets (name, dynasty, lifespan, introduction) VALUES
('李白', '唐', '701年-762年', '唐代伟大的浪漫主义诗人，被后人誉为"诗仙"。'),
('杜甫', '唐', '712年-770年', '唐代伟大的现实主义诗人，被后人誉为"诗圣"。'),
('苏轼', '宋', '1037年-1101年', '北宋文学家、书画家，唐宋八大家之一。')
ON CONFLICT (name) DO NOTHING;

-- 插入诗词数据
INSERT INTO poems (title, content, poet_name, dynasty, theme, appreciation) VALUES
('静夜思', '床前明月光，疑是地上霜。举头望明月，低头思故乡。', '李白', '唐', '思乡', '这首诗通过描绘月夜思乡的场景，表达了游子对故乡的深切思念。语言朴素自然，意境深远。'),
('春望', '国破山河在，城春草木深。感时花溅泪，恨别鸟惊心。烽火连三月，家书抵万金。白头搔更短，浑欲不胜簪。', '杜甫', '唐', '忧国', '这首诗反映了安史之乱时期的社会动荡和人民苦难，展现了诗人忧国忧民的情怀。'),
('水调歌头', '明月几时有？把酒问青天。不知天上宫阙，今夕是何年。我欲乘风归去，又恐琼楼玉宇，高处不胜寒。起舞弄清影，何似在人间。', '苏轼', '宋', '人生哲理', '这首词以中秋明月为背景，表达了作者对人生的思考和对亲人的思念，展现了苏轼豁达的人生态度。')
ON CONFLICT (title, poet_name) DO NOTHING;

-- 9. 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_poems_dynasty ON poems(dynasty);
CREATE INDEX IF NOT EXISTS idx_poems_theme ON poems(theme);
CREATE INDEX IF NOT EXISTS idx_favorites_user_id ON favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_favorites_poem_id ON favorites(poem_id);
CREATE INDEX IF NOT EXISTS idx_comments_poem_id ON comments(poem_id);
CREATE INDEX IF NOT EXISTS idx_comments_user_id ON comments(user_id);

-- 10. 创建更新时间的触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为需要更新时间的表创建触发器
CREATE TRIGGER update_poems_updated_at BEFORE UPDATE ON poems FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_comments_updated_at BEFORE UPDATE ON comments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();