# Supabase 数据库设置指南

## 快速设置步骤

### 方法1：使用Supabase Dashboard（最简单）

1. **访问Supabase Dashboard**
   - 打开 https://supabase.com/dashboard
   - 登录您的账户
   - 选择项目：`rbarqocuypmpybeckwxk`

2. **创建数据库表**
   - 在左侧菜单点击 **Table Editor**
   - 点击 **Create a new table**
   - 按照以下顺序创建表：

#### 表1：poems（诗词表）
| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | UUID (主键) | 自动生成 |
| title | TEXT | 诗词标题 |
| content | TEXT | 诗词内容 |
| poet_name | TEXT | 诗人姓名 |
| dynasty | TEXT | 朝代 |
| theme | TEXT | 题材（可选） |
| appreciation | TEXT | 赏析（可选） |
| created_at | TIMESTAMP | 创建时间 |

#### 表2：favorites（收藏表）
| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | UUID (主键) | 自动生成 |
| user_id | UUID | 用户ID（关联auth.users） |
| poem_id | UUID | 诗词ID（关联poems） |
| created_at | TIMESTAMP | 创建时间 |

**重要**：在favorites表中添加唯一约束，防止重复收藏：
- 点击 **Add constraint**
- 名称：`unique_user_poem`
- 类型：UNIQUE
- 字段：`user_id, poem_id`

3. **启用行级安全策略 (RLS)**
   - 在每个表的 **Authentication** 标签页
   - 开启 **Enable Row Level Security (RLS)**
   - 添加策略：
     - poems: SELECT策略允许所有人
     - favorites: 
       - SELECT策略：`auth.uid() = user_id`
       - INSERT策略：`auth.uid() = user_id`
       - DELETE策略：`auth.uid() = user_id`

4. **插入示例数据**
   - 在 **Table Editor** 中点击 **Insert row**
   - 插入诗词数据：
   
```sql
-- 诗词示例数据
INSERT INTO poems (title, content, poet_name, dynasty, theme, appreciation) VALUES
('静夜思', '床前明月光，疑是地上霜。举头望明月，低头思故乡。', '李白', '唐', '思乡', '这首诗通过描绘月夜思乡的场景，表达了游子对故乡的深切思念。'),
('春望', '国破山河在，城春草木深。感时花溅泪，恨别鸟惊心。烽火连三月，家书抵万金。白头搔更短，浑欲不胜簪。', '杜甫', '唐', '忧国', '这首诗反映了安史之乱时期的社会动荡和人民苦难。'),
('水调歌头', '明月几时有？把酒问青天。不知天上宫阙，今夕是何年。我欲乘风归去，又恐琼楼玉宇，高处不胜寒。起舞弄清影，何似在人间。', '苏轼', '宋', '人生哲理', '这首词以中秋明月为背景，表达了作者对人生的思考。');
```

### 方法2：使用SQL Editor

1. 在Supabase Dashboard中点击 **SQL Editor**
2. 新建查询，执行以下SQL：

```sql
-- 创建诗词表
CREATE TABLE poems (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    poet_name TEXT NOT NULL,
    dynasty TEXT NOT NULL,
    theme TEXT,
    appreciation TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建收藏表
CREATE TABLE favorites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    poem_id UUID NOT NULL REFERENCES poems(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, poem_id)
);

-- 启用RLS
ALTER TABLE poems ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;

-- 创建策略
CREATE POLICY "诗词公开读取" ON poems FOR SELECT USING (true);
CREATE POLICY "用户查看自己的收藏" ON favorites FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "用户添加收藏" ON favorites FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "用户删除收藏" ON favorites FOR DELETE USING (auth.uid() = user_id);

-- 插入示例数据
INSERT INTO poems (title, content, poet_name, dynasty, theme, appreciation) VALUES
('静夜思', '床前明月光，疑是地上霜。举头望明月，低头思故乡。', '李白', '唐', '思乡', '思乡名篇'),
('春望', '国破山河在，城春草木深。感时花溅泪，恨别鸟惊心。', '杜甫', '唐', '忧国', '忧国忧民');
```

## 验证设置

设置完成后，您的应用应该能够：
1. 正常连接到Supabase数据库
2. 用户登录后可以收藏诗词
3. 收藏数据会持久化存储在数据库中
4. 在"我的收藏"页面可以看到收藏的诗词

如果仍有问题，请检查：
- 环境变量是否正确配置在 `.env` 文件中
- 数据库表是否创建成功
- RLS策略是否正确设置