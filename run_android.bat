@echo off
echo ========================================================
echo   Launching EduPulse School Management on Android...
echo ========================================================
powershell -ExecutionPolicy Bypass -File "%~dp0flutter_runner.ps1" run -d android
pause
