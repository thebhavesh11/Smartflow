@echo off
REM Start Frontend Only - Starts Next.js development server on port 3000

echo.
echo ================================
echo Smartflow - Frontend Server
echo ================================
echo.

cd frontend

REM Check if node_modules exists
if not exist node_modules (
    echo Node.js dependencies not found!
    echo Installing dependencies...
    call npm install
)

echo.
echo Starting Next.js development server...
echo.
echo Frontend URL: http://localhost:3000
echo.

call npm run dev

pause
