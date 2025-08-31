@echo off
echo 🤖 AI Teacher - Starting All Servers (Backend + Frontend + Flutter)...
echo ================================================

REM Check if Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python not found in PATH
    echo Trying Anaconda Python...
    C:\Users\HP\anaconda3\python.exe --version >nul 2>&1
    if errorlevel 1 (
        echo ❌ Anaconda Python not found either
        echo Please install Python or update your PATH
        pause
        exit /b 1
    ) else (
        echo ✅ Found Anaconda Python
        set PYTHON_CMD=C:\Users\HP\anaconda3\python.exe
    )
) else (
    echo ✅ Found Python in PATH
    set PYTHON_CMD=python
)

echo.
echo 🚀 Starting AI Teacher servers...
echo.

REM Start the combined startup script
%PYTHON_CMD% start_all_servers.py

echo.
echo Press any key to exit...
pause >nul
