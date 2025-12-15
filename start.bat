@echo off
echo ======================================================
echo          Starting Graduation Project...
echo ======================================================

:: Check if backend folder exists
if not exist "backend" (
    echo Error: Folder 'backend' not found!
    echo Please make sure this script is in the project root.
    pause
    exit
)

:: Check if frontend folder exists
if not exist "frontend" (
    echo Error: Folder 'frontend' not found!
    echo Please make sure this script is in the project root.
    pause
    exit
)

:: Check if node_modules exists in frontend
if not exist "frontend\node_modules" (
    echo [0/3] Installing frontend dependencies...
    cd frontend
    call npm install
    cd ..
    echo.
)

:: 1. Start Backend in a new window
echo [1/3] Starting Spring Boot Backend...
:: Use /k to keep window open on error
start "Backend-Server" cmd /k "cd backend && mvn spring-boot:run"

:: 2. Start Frontend in a new window
echo [2/3] Starting Vue Frontend...
:: Use /k to keep window open on error
start "Frontend-Server" cmd /k "cd frontend && npm run dev"

:: 3. Wait 15 seconds for services to initialize, then open browser
echo [3/3] Waiting for services to initialize...
timeout /t 15 >nul
start http://localhost:5174

echo.
echo ======================================================
echo      Done! Please do not close the new windows.
echo ======================================================
echo.
echo If you see errors in the new windows:
echo - Frontend errors: Check if npm dependencies are installed
echo - Backend errors: Check if MySQL is running and configured
echo.
pause