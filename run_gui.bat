@echo off
title NetSpeedBooster
cd /d "%~dp0"

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c `\"%~dpnx0`\"' -Verb RunAs"
    exit /b
)

powershell -Sta -NoProfile -ExecutionPolicy Bypass -File "%~dp0gui.ps1"
