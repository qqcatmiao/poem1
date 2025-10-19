-- 修复Supabase认证重定向URL配置
-- 在Supabase控制台的Authentication > URL Configuration中设置

-- 1. 检查当前的重定向URL配置
SELECT '请在Supabase控制台配置以下重定向URL:' as instruction;

-- 2. 需要配置的重定向URL
SELECT '网站URL:' as type, 'http://localhost:5173' as url
UNION ALL
SELECT '重定向URL:', 'http://localhost:5173/*'
UNION ALL  
SELECT '注销重定向URL:', 'http://localhost:5173/'

-- 3. 如果部署到生产环境，还需要添加生产环境URL
UNION ALL
SELECT '生产环境URL:', 'https://your-domain.vercel.app'
UNION ALL
SELECT '生产重定向URL:', 'https://your-domain.vercel.app/*'
UNION ALL
SELECT '生产注销URL:', 'https://your-domain.vercel.app/';

-- 4. 配置说明
SELECT '配置步骤:' as step;
SELECT '1. 登录Supabase控制台' as detail;
SELECT '2. 进入Authentication > URL Configuration' as detail;
SELECT '3. 在"Site URL"中填入: http://localhost:5173' as detail;
SELECT '4. 在"Redirect URLs"中添加: http://localhost:5173/*' as detail;
SELECT '5. 保存配置' as detail;