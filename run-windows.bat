@echo off
cd /d "%~dp0"
echo Installing dependencies if needed...
call npm install
if errorlevel 1 exit /b 1
call npm run dev
