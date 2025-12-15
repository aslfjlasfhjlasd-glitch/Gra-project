@echo off
echo ======================================================
echo          Stopping Graduation Project...
echo ======================================================

:: 1. Stop Backend (Kill process on port 8080)
echo [1/2] Stopping Backend (Port 8080)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8080') do (
    taskkill /f /pid %%a >nul 2>&1
)

:: 2. Stop Frontend (Kill process on port 5174)
echo [2/2] Stopping Frontend (Port 5174)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :5174') do (
    taskkill /f /pid %%a >nul 2>&1
)

echo.
echo ======================================================
echo                 Project Stopped.
echo ======================================================
pause