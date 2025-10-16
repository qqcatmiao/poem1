-- 修复诗词表诗人名字的SQL脚本
-- 在Supabase SQL Editor中执行

-- 1. 首先检查诗词表结构
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'poems' 
ORDER BY ordinal_position;

-- 2. 检查诗词表中的诗人名字数据
SELECT id, title, poet_name, poet_id FROM poems LIMIT 10;

-- 3. 检查诗人表数据
SELECT * FROM poets;

-- 4. 更新诗词表的诗人名字
UPDATE poems 
SET poet_name = (
    SELECT name FROM poets WHERE poets.id = poems.poet_id
)
WHERE poet_name IS NULL OR poet_name = 'undefined';

-- 5. 验证修复结果
SELECT id, title, poet_name FROM poems;

-- 如果上面的更新不工作，尝试直接设置诗人名字
UPDATE poems SET poet_name = '李白' WHERE title = '静夜思';
UPDATE poems SET poet_name = '杜甫' WHERE title = '春望';
UPDATE poems SET poet_name = '苏轼' WHERE title = '水调歌头';

-- 6. 最终验证
SELECT id, title, poet_name FROM poems;