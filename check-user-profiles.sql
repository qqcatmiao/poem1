-- 检查用户和profiles表状态的SQL脚本
-- 在Supabase SQL Editor中执行

-- 1. 检查auth.users表中的用户
SELECT 
    id, 
    email, 
    created_at,
    raw_user_meta_data->>'username' as meta_username
FROM auth.users 
ORDER BY created_at DESC 
LIMIT 10;

-- 2. 检查profiles表中的记录
SELECT 
    id, 
    username, 
    created_at 
FROM profiles 
ORDER BY created_at DESC 
LIMIT 10;

-- 3. 检查缺失的profiles记录
SELECT 
    u.id as user_id,
    u.email,
    u.created_at as user_created
FROM auth.users u
LEFT JOIN profiles p ON u.id = p.id
WHERE p.id IS NULL;

-- 4. 检查收藏表中的用户引用
SELECT 
    f.user_id,
    COUNT(*) as favorite_count
FROM favorites f
LEFT JOIN auth.users u ON f.user_id = u.id
WHERE u.id IS NULL
GROUP BY f.user_id;

-- 5. 检查诗词表数据
SELECT 
    id,
    title,
    poet_name,
    dynasty
FROM poems 
ORDER BY created_at DESC 
LIMIT 10;

-- 6. 检查收藏表数据
SELECT 
    f.id as favorite_id,
    f.user_id,
    f.poem_id,
    p.title as poem_title,
    f.created_at
FROM favorites f
LEFT JOIN poems p ON f.poem_id = p.id
ORDER BY f.created_at DESC 
LIMIT 10;