@echo off
REM Starts the React + Vite frontend dev server (http://localhost:5173).
REM Usage: run_frontend.bat
cd /d "%~dp0frontend"

where npm >nul 2>nul
if errorlevel 1 (
  echo Error: npm not found. Install Node.js from https://nodejs.org and try again.
  exit /b 1
)

if not exist node_modules (
  echo Installing dependencies...
  call npm install || exit /b 1
)

echo Starting frontend at http://localhost:5173 (Ctrl+C to stop)
call npm run dev %*
