-- 添加更多诗词的SQL脚本
-- 在Supabase SQL Editor中执行

-- 1. 先添加更多诗人（如果不存在）
INSERT INTO poets (name, dynasty, lifespan, introduction) 
SELECT '王维', '唐', '701年-761年', '唐代著名诗人、画家，被誉为"诗佛"，山水田园诗派的代表人物。'
WHERE NOT EXISTS (SELECT 1 FROM poets WHERE name = '王维');

INSERT INTO poets (name, dynasty, lifespan, introduction) 
SELECT '白居易', '唐', '772年-846年', '唐代伟大的现实主义诗人，新乐府运动的倡导者。'
WHERE NOT EXISTS (SELECT 1 FROM poets WHERE name = '白居易');

INSERT INTO poets (name, dynasty, lifespan, introduction) 
SELECT '李清照', '宋', '1084年-1155年', '宋代著名女词人，婉约词派的代表，有"千古第一才女"之称。'
WHERE NOT EXISTS (SELECT 1 FROM poets WHERE name = '李清照');

INSERT INTO poets (name, dynasty, lifespan, introduction) 
SELECT '辛弃疾', '宋', '1140年-1207年', '南宋豪放派词人，与苏轼合称"苏辛"，与李清照并称"济南二安"。'
WHERE NOT EXISTS (SELECT 1 FROM poets WHERE name = '辛弃疾');

INSERT INTO poets (name, dynasty, lifespan, introduction) 
SELECT '王安石', '宋', '1021年-1086年', '北宋著名政治家、文学家，唐宋八大家之一。'
WHERE NOT EXISTS (SELECT 1 FROM poets WHERE name = '王安石');

-- 2. 添加更多诗词
INSERT INTO poems (title, content, poet_name, dynasty, theme, appreciation) VALUES
('相思', '红豆生南国，春来发几枝。愿君多采撷，此物最相思。', '王维', '唐', '爱情', '这首诗以红豆起兴，借物抒情，表达了深切的相思之情。语言简练，意境深远。'),

('赋得古原草送别', '离离原上草，一岁一枯荣。野火烧不尽，春风吹又生。远芳侵古道，晴翠接荒城。又送王孙去，萋萋满别情。', '白居易', '唐', '离别', '这首诗通过对原野野草的咏叹，表达了送别友人的依依不舍之情。'),

('声声慢', '寻寻觅觅，冷冷清清，凄凄惨惨戚戚。乍暖还寒时候，最难将息。三杯两盏淡酒，怎敌他、晚来风急？雁过也，正伤心，却是旧时相识。', '李清照', '宋', '忧伤', '这首词以细腻的笔触描绘了词人内心的孤寂和忧伤，是婉约词的代表作。'),

('青玉案·元夕', '东风夜放花千树。更吹落、星如雨。宝马雕车香满路。凤箫声动，玉壶光转，一夜鱼龙舞。', '辛弃疾', '宋', '节日', '这首词描绘了元宵佳节的热闹景象，展现了辛弃疾豪放词风的另一面。'),

('泊船瓜洲', '京口瓜洲一水间，钟山只隔数重山。春风又绿江南岸，明月何时照我还？', '王安石', '宋', '思乡', '这首诗表达了诗人对故乡的思念之情，语言清新自然，意境优美。'),

('鹿柴', '空山不见人，但闻人语响。返景入深林，复照青苔上。', '王维', '唐', '山水', '这首诗描绘了深山林中的幽静景色，展现了王维诗中有画的独特风格。'),

('钱塘湖春行', '孤山寺北贾亭西，水面初平云脚低。几处早莺争暖树，谁家新燕啄春泥。乱花渐欲迷人眼，浅草才能没马蹄。最爱湖东行不足，绿杨阴里白沙堤。', '白居易', '唐', '春景', '这首诗生动描绘了杭州西湖早春的美景，语言明快，意境清新。'),

('如梦令', '常记溪亭日暮，沉醉不知归路。兴尽晚回舟，误入藕花深处。争渡，争渡，惊起一滩鸥鹭。', '李清照', '宋', '回忆', '这首小令以白描手法回忆了一次愉快的郊游，语言清新自然。'),

('破阵子·为陈同甫赋壮词以寄之', '醉里挑灯看剑，梦回吹角连营。八百里分麾下炙，五十弦翻塞外声。沙场秋点兵。', '辛弃疾', '宋', '壮志', '这首词表达了词人抗金复国的雄心壮志，是辛弃疾豪放词的代表作。'),

('元日', '爆竹声中一岁除，春风送暖入屠苏。千门万户曈曈日，总把新桃换旧符。', '王安石', '宋', '节日', '这首诗描绘了春节的热闹景象，表达了除旧布新的喜悦心情。');

-- 3. 验证添加结果
SELECT '诗词添加完成！' as status;
SELECT COUNT(*) as total_poems FROM poems;
SELECT poet_name, COUNT(*) as poem_count FROM poems GROUP BY poet_name ORDER BY poem_count DESC;

-- 4. 测试搜索功能
SELECT '测试搜索功能:' as test;
SELECT * FROM poems WHERE title ILIKE '%相思%' OR content ILIKE '%相思%' OR poet_name ILIKE '%相思%';
SELECT * FROM poems WHERE title ILIKE '%春风%' OR content ILIKE '%春风%' OR poet_name ILIKE '%春风%';
SELECT * FROM poems WHERE poet_name ILIKE '%李清照%';