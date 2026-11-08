@echo off
echo ========================================================
echo   Building EduPulse School Management Android APK...
echo ========================================================
powershell -ExecutionPolicy Bypass -File "%~dp0flutter_runner.ps1" build apk --release
echo.
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] APK built successfully!
    echo Output located in: build\app\outputs\flutter-apk\app-release.apk
) else (
    echo [ERROR] Failed to build APK. Please check your Android SDK and Java installation.
)
pause

