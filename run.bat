@echo off
title NetSpeedBooster - Network & Speed Optimizer
cd /d "%~dp0"

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Requesting Administrator Elevation for Network Tuning...
    powershell -Command "Start-Process cmd -ArgumentList '/c `\"%~dpnx0`\"' -Verb RunAs"
    exit /b
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0optimize.ps1"
pause
