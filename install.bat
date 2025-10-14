@echo off
echo 古诗词赏析平台 - 安装脚本
echo.

echo 正在检查 Node.js 环境...
node --version >nul 2>&1
if errorlevel 1 (
    echo 错误: 未检测到 Node.js，请先安装 Node.js 16+
    echo 下载地址: https://nodejs.org/
    pause
    exit /b 1
)

echo 正在安装项目依赖...
npm install

if errorlevel 1 (
    echo 错误: 依赖安装失败
    pause
    exit /b 1
)

echo.
echo 安装完成！
echo.
echo 下一步操作：
echo 1. 复制 .env.example 为 .env
echo 2. 配置 Supabase 项目信息
echo 3. 运行 npm run dev 启动开发服务器
echo.
pause