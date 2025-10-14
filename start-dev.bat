@echo off
echo 启动古诗词赏析平台开发服务器
echo.

echo 检查 Node.js 环境...
node --version >nul 2>&1
if errorlevel 1 (
    echo 错误: 未检测到 Node.js，请先安装 Node.js 16+
    echo 下载地址: https://nodejs.org/
    pause
    exit /b 1
)

echo 检查依赖是否已安装...
if not exist "node_modules" (
    echo 依赖未安装，正在安装...
    npm install
    if errorlevel 1 (
        echo 错误: 依赖安装失败
        pause
        exit /b 1
    )
)

echo 启动开发服务器...
echo 服务器将在 http://localhost:3000 启动
echo 如果端口被占用，将自动使用其他端口
echo 按 Ctrl+C 停止服务器
echo.

npm run dev -- --host 0.0.0.0 --port 3000

pause