
古诗词赏析平台（MVP）需求文档
1. 项目概述

本项目旨在构建一个基于现代Web技术的古诗词赏析平台（MVP版本）。前端采用Vue.js框架以实现动态且响应式的用户界面，后端则完全依托Supabase提供的后端即服务（BaaS）能力，包括数据库、即时API、身份认证、存储和实时订阅功能。MVP阶段的核心目标是快速验证产品概念，为用户提供一个能够浏览、搜索、赏析古诗词并进行基本互动的轻量级平台。

2. 用户角色

角色 描述 MVP阶段权限

游客 未登录的访问者 可浏览首页、查看诗词列表、搜索诗词、阅读公开的诗词详情与赏析。

注册用户 已注册并登录的个人用户 拥有游客所有权限。此外，可收藏/取消收藏诗词、发表评论、管理个人收藏夹和评论。

系统管理员 管理平台内容的后台用户 拥有最高权限。负责管理（增、删、改、查）诗词库、诗人信息，以及管理用户评论。

3. 功能需求（MVP范围）

3.1. 诗词内容浏览与查询

1.  首页/诗词列表页：
    ◦   展示精选诗词或最新录入的诗词。

    ◦   支持按朝代（如唐、宋）、作者、题材（如山水田园、边塞征战、咏史怀古）进行筛选和浏览。

2.  诗词搜索：
    ◦   提供按诗词标题、作者名或诗句内容（关键字）进行搜索的功能。

3.  诗词详情页：
    ◦   展示内容：诗词标题、作者、朝代、正文、注音（可选，MVP可暂缓）。

    ◦   赏析内容：提供对诗词的背景（创作背景）、意象（如月、柳、雁等特定含义）、意境（如雄浑壮丽、清幽明净）、表现技巧（如比喻、借景抒情）及语言风格（如沉郁顿挫、婉约）的专业赏析。

    ◦   关联信息：展示该诗人的基本信息及其他作品链接。

3.2. 用户互动

1.  用户认证：
    ◦   用户可通过邮箱和密码进行注册和登录。

    ◦   Supabase将管理完整的用户身份验证流程。

2.  收藏功能：
    ◦   登录用户可以对喜爱的诗词进行收藏或取消收藏。

    ◦   提供“我的收藏”页面，集中展示用户个人收藏的诗词。

3.  评论功能：
    ◦   登录用户可在诗词详情页下方发表评论，或回复其他用户的评论（MVP可先仅支持一级评论）。

    ◦   管理员有权审核或删除不当评论。

3.3. 内容管理（管理员后台）

1.  诗词管理：管理员可对诗词数据进行增、删、改、查操作。
2.  诗人管理：管理员可对诗人信息进行管理。
3.  评论管理：管理员可查看、审核或删除用户评论。

4. 技术架构

4.1. 前端（Frontend）

•   技术栈：Vue 3 + Pinia（状态管理） + Vue Router（路由） + Axios/@supabase/supabase-js（HTTP客户端）。

•   UI框架：可选基于Vue的UI库（如Element Plus, Naive UI）以快速搭建界面。

•   特性：组件化开发，响应式设计，支持单页面应用（SPA）体验。

4.2. 后端与基础设施（Backend & Infrastructure）

•   核心服务：Supabase（作为完整的BaaS提供商）。

•   数据库：Supabase提供的PostgreSQL数据库。它将自动为每个表生成即时RESTful API，无需自行编写后端接口。

•   身份认证（Auth）：直接使用Supabase内置的认证系统，管理用户注册、登录和会话。

•   实时功能：可利用Supabase的Realtime功能，未来轻松实现如评论实时更新等特性。

•   存储（Storage）：使用Supabase Storage，可用于存储诗人头像、诗词相关插图等。

5. 数据模型（Supabase数据库表设计）

在Supabase中，以下表将被创建，并自动生成对应的API。

表名 关键字段 说明与关系

poets (诗人表) id, name, dynasty, lifespan, introduction, created_at 存储诗人基本信息。

poems (诗词表) id, title, content, poet_id (关联poets.id), dynasty, appreciation (赏析内容), theme (题材), created_at 核心表，存储诗词及赏析。poet_id外键关联诗人。

profiles (用户档案) id (与Supabase Auth用户UID关联), username, avatar_url, created_at 扩展存储用户基本信息。

favorites (收藏表) id, user_id (关联profiles.id), poem_id (关联poems.id), created_at 记录用户收藏行为，user_id和poem_id组合唯一。

comments (评论表) id, content, user_id (关联profiles.id), poem_id (关联poems.id), parent_id (自关联，用于回复), created_at 存储评论信息。

注意：需在Supabase中启用行级安全（RLS）策略，精细控制每条数据的访问权限（如：用户只能删除自己的评论）。

6. MVP阶段技术实现要点

1.  环境设置：创建Vue项目；在Supabase上创建新项目并获取API URL和anon key。
2.  数据库初始化：在Supabase的SQL编辑器中运行建表语句，并配置RLS策略。
3.  前端集成：
    ◦   安装@supabase/supabase-js库。

    ◦   初始化Supabase客户端。

    ◦   实现基于Supabase Auth的登录/注册组件。

    ◦   使用Supabase的JavaScript SDK进行数据操作（如：从poems表查询数据，向favorites表插入数据）。

4.  部署：前端可部署至Vercel, Netlify等平台；Supabase服务由官方托管。

7. 后续版本展望

•   AI集成：利用Supabase的向量数据库（pgvector）扩展和AI工具，实现基于意境的智能推荐（“查找意境类似的诗词”）或AI辅助赏析。

•   社交功能：诗词接龙、飞花令等小游戏，用户创作平台。

•   多媒体内容：为诗词配乐或朗诵音频。

•   更强大的搜索：实现全文检索，支持按意象（如“包含‘月亮’的诗词”）搜索。
