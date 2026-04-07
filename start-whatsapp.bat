@echo off
REM Start WhatsApp Bridge Only

echo.
echo ================================
echo Smartflow - WhatsApp Bridge
echo ================================
echo.

cd whatsapp-bridge

REM Check if node_modules exists
if not exist node_modules (
    echo Node.js dependencies not found!
    echo Installing dependencies...
    call npm install
)

echo.
echo Starting WhatsApp Bridge...
echo.

call node index.js

pause
