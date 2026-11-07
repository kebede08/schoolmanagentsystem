@echo off
echo ========================================================
echo   EduPulse School Management - GitHub Connector
echo ========================================================
echo.
set /p REPO_URL="Enter your GitHub repository URL (e.g., https://github.com/kebede-delelegn/school-management.git): "
if "%REPO_URL%"=="" (
    echo [ERROR] No repository URL entered. Exiting.
    pause
    exit /b 1
)

echo.
echo Setting remote origin to %REPO_URL% ...
git remote remove origin 2>nul
git remote add origin %REPO_URL%
git branch -M main

echo.
echo Pushing commits to GitHub...
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================================
    echo   Successfully connected and pushed to GitHub!
    echo ========================================================
) else (
    echo.
    echo [NOTICE] If Git prompted you for credentials, please sign in.
    echo If pushing failed, verify the repository exists and your permissions.
)
echo.
pause
