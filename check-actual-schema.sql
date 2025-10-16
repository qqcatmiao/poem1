-- 检查实际数据库表结构的SQL脚本
-- 在Supabase SQL Editor中执行

-- 1. 检查诗词表的实际结构
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'poems' 
ORDER BY ordinal_position;

-- 2. 检查诗词表的前几条数据
SELECT * FROM poems LIMIT 5;

-- 3. 检查是否有poet_id字段
SELECT column_name 
FROM information_schema.columns 
WHERE table_name = 'poems' AND column_name = 'poet_id';

-- 4. 检查是否有poet_name字段
SELECT column_name 
FROM information_schema.columns 
WHERE table_name = 'poems' AND column_name = 'poet_name';

-- 5. 检查诗人表结构
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'poets' 
ORDER BY ordinal_position;

-- 6. 检查诗人表数据
SELECT * FROM poets LIMIT 5;