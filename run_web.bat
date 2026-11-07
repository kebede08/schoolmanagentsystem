@echo off
echo Starting EduPulse School Management System on Flutter Web...
powershell -ExecutionPolicy Bypass -File "%~dp0flutter_runner.ps1" run -d chrome
pause

