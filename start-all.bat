@echo off
REM Start All Services - Opens backend, frontend, and whatsapp-bridge in separate windows

echo.
echo ================================
echo Smartflow - Starting All Services
echo ================================
echo.

REM Start Backend in new window
echo Starting Backend (FastAPI on port 8000)...
start "Smartflow Backend" cmd /k "cd backend && .\venv\Scripts\activate.bat && python main.py"

timeout /t 2 /nobreak

REM Start Frontend in new window
echo Starting Frontend (Next.js on port 3000)...
start "Smartflow Frontend" cmd /k "cd frontend && npm run dev"

timeout /t 2 /nobreak

REM Start WhatsApp Bridge in new window
echo Starting WhatsApp Bridge...
start "Smartflow WhatsApp Bridge" cmd /k "cd whatsapp-bridge && node index.js"

echo.
echo ================================
echo Services Started!
echo ================================
echo.
echo Backend API: http://localhost:8000
echo Backend Docs: http://localhost:8000/docs
echo Frontend: http://localhost:3000
echo.
echo Close any window to stop that service.
echo.
pause
