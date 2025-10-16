-- 修复搜索功能的SQL脚本
-- 在Supabase SQL Editor中执行

-- 1. 为诗词表添加poet_name字段（如果不存在）
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'poems' AND column_name = 'poet_name') THEN
        ALTER TABLE poems ADD COLUMN poet_name TEXT;
    END IF;
END $$;

-- 2. 更新现有诗词的诗人名字
UPDATE poems SET poet_name = '李白' WHERE title = '静夜思';
UPDATE poems SET poet_name = '杜甫' WHERE title = '春望';
UPDATE poems SET poet_name = '苏轼' WHERE title = '水调歌头';

-- 3. 验证更新结果
SELECT id, title, poet_name FROM poems;

-- 4. 创建索引以提高搜索性能
CREATE INDEX IF NOT EXISTS idx_poems_title ON poems(title);
CREATE INDEX IF NOT EXISTS idx_poems_content ON poems(content);
CREATE INDEX IF NOT EXISTS idx_poems_poet_name ON poems(poet_name);

-- 5. 测试搜索功能
SELECT * FROM poems WHERE title ILIKE '%李白%' OR content ILIKE '%李白%' OR poet_name ILIKE '%李白%';
SELECT * FROM poems WHERE title ILIKE '%静夜思%' OR content ILIKE '%静夜思%' OR poet_name ILIKE '%静夜思%';
SELECT * FROM poems WHERE title ILIKE '%明月%' OR content ILIKE '%明月%' OR poet_name ILIKE '%明月%';