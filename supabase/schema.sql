-- 古诗词赏析平台数据库初始化脚本

-- 创建诗人表
CREATE TABLE IF NOT EXISTS poets (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  dynasty VARCHAR(50) NOT NULL,
  lifespan VARCHAR(100),
  introduction TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);

-- 创建诗词表
CREATE TABLE IF NOT EXISTS poems (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  content TEXT NOT NULL,
  poet_id UUID REFERENCES poets(id) ON DELETE CASCADE,
  dynasty VARCHAR(50) NOT NULL,
  appreciation TEXT,
  theme VARCHAR(100),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);

-- 创建用户档案表（扩展Supabase Auth用户信息）
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  username VARCHAR(100),
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);

-- 创建收藏表
CREATE TABLE IF NOT EXISTS favorites (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  poem_id UUID REFERENCES poems(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
  UNIQUE(user_id, poem_id)
);

-- 创建评论表
CREATE TABLE IF NOT EXISTS comments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  content TEXT NOT NULL,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  poem_id UUID REFERENCES poems(id) ON DELETE CASCADE,
  parent_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);

-- 启用行级安全（RLS）
ALTER TABLE poets ENABLE ROW LEVEL SECURITY;
ALTER TABLE poems ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- RLS策略：诗词和诗人表所有人都可读
CREATE POLICY "任何人都可以查看诗词" ON poems FOR SELECT USING (true);
CREATE POLICY "任何人都可以查看诗人" ON poets FOR SELECT USING (true);

-- RLS策略：用户只能管理自己的档案
CREATE POLICY "用户可以查看所有档案" ON profiles FOR SELECT USING (true);
CREATE POLICY "用户可以更新自己的档案" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "用户可以插入自己的档案" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- RLS策略：收藏功能
CREATE POLICY "用户可以查看所有收藏" ON favorites FOR SELECT USING (true);
CREATE POLICY "用户只能管理自己的收藏" ON favorites FOR ALL USING (auth.uid() = user_id);

-- RLS策略：评论功能
CREATE POLICY "用户可以查看所有评论" ON comments FOR SELECT USING (true);
CREATE POLICY "用户只能管理自己的评论" ON comments FOR ALL USING (auth.uid() = user_id);

-- 插入示例数据
INSERT INTO poets (name, dynasty, lifespan, introduction) VALUES
('李白', '唐', '701年-762年', '唐代伟大的浪漫主义诗人，被后人誉为"诗仙"。'),
('杜甫', '唐', '712年-770年', '唐代伟大的现实主义诗人，被后人誉为"诗圣"。'),
('苏轼', '宋', '1037年-1101年', '北宋文学家、书画家，唐宋八大家之一。');

INSERT INTO poems (title, content, poet_id, dynasty, appreciation, theme) VALUES
('静夜思', '床前明月光，疑是地上霜。举头望明月，低头思故乡。', 
 (SELECT id FROM poets WHERE name = '李白'), '唐',
 '这首诗通过描绘月夜思乡的场景，表达了游子对故乡的深切思念。语言朴素自然，意境深远。', '思乡'),

('春望', '国破山河在，城春草木深。感时花溅泪，恨别鸟惊心。烽火连三月，家书抵万金。白头搔更短，浑欲不胜簪。',
 (SELECT id FROM poets WHERE name = '杜甫'), '唐',
 '这首诗反映了安史之乱时期的社会动荡和人民苦难，展现了诗人忧国忧民的情怀。', '忧国'),

('水调歌头', '明月几时有？把酒问青天。不知天上宫阙，今夕是何年。我欲乘风归去，又恐琼楼玉宇，高处不胜寒。起舞弄清影，何似在人间。',
 (SELECT id FROM poets WHERE name = '苏轼'), '宋',
 '这首词以中秋明月为背景，表达了作者对人生的思考和对亲人的思念，展现了苏轼豁达的人生态度。', '人生哲理');