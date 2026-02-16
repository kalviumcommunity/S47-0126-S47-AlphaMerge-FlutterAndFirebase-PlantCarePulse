@echo off
echo ========================================
echo Firebase Cloud Functions Deployment
echo ========================================
echo.

echo Step 1: Installing dependencies...
cd functions
call npm install
if %errorlevel% neq 0 (
    echo Error: Failed to install dependencies
    pause
    exit /b 1
)
echo Dependencies installed successfully!
echo.

echo Step 2: Deploying functions to Firebase...
cd ..
call firebase deploy --only functions
if %errorlevel% neq 0 (
    echo Error: Failed to deploy functions
    pause
    exit /b 1
)
echo.

echo ========================================
echo Deployment completed successfully!
echo ========================================
echo.
echo Next steps:
echo 1. Run the Flutter app
echo 2. Navigate to "Cloud Functions Demo"
echo 3. Test the functions
echo 4. Check logs: firebase functions:log
echo.
pause
