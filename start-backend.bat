@echo off
REM Start Backend Only - Starts FastAPI server on port 8000

echo.
echo ================================
echo Smartflow - Backend Server
echo ================================
echo.

cd backend

REM Check if virtual environment exists
if not exist venv (
    echo Python virtual environment not found!
    echo Please run 'setup-all.bat' first to set up the environment.
    pause
    exit /b 1
)

echo Activating Python virtual environment...
call venv\Scripts\activate.bat

echo.
echo Starting FastAPI server...
echo.
echo Backend API: http://localhost:8000
echo API Documentation: http://localhost:8000/docs
echo.

python main.py

pause
