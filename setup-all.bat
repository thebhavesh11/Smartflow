@echo off
REM Setup All - Installs dependencies for backend, frontend, and whatsapp-bridge

echo.
echo ================================
echo Smartflow - Complete Setup
echo ================================
echo.

REM Setup Backend
echo [1/3] Setting up Backend...
cd backend
echo Creating Python virtual environment...
python -m venv venv
echo Activating virtual environment...
call venv\Scripts\activate.bat
echo Installing Python dependencies...
pip install -r requirements.txt
cd ..

REM Setup Frontend
echo.
echo [2/3] Setting up Frontend...
cd frontend
echo Installing Node.js dependencies...
call npm install
cd ..

REM Setup WhatsApp Bridge
echo.
echo [3/3] Setting up WhatsApp Bridge...
cd whatsapp-bridge
echo Installing Node.js dependencies...
call npm install
cd ..

echo.
echo ================================
echo Setup Complete!
echo ================================
echo.
echo Next steps:
echo   - Run 'start-all.bat' to start all services
echo   - Or run individual batch files:
echo     * start-backend.bat
echo     * start-frontend.bat
echo     * start-whatsapp.bat
echo.
pause
