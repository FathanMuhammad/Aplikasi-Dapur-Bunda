@echo off
echo ========================================
echo    Dapur Bunda Bahagia - Restaurant App
echo ========================================
echo.

echo Checking Flutter installation...
flutter --version
if %errorlevel% neq 0 (
    echo ERROR: Flutter not found! Please install Flutter first.
    echo Visit: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo.
echo Getting dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Failed to get dependencies!
    pause
    exit /b 1
)

echo.
echo Checking for connected devices...
flutter devices
if %errorlevel% neq 0 (
    echo ERROR: No devices found!
    echo Please connect an Android device or start an emulator.
    pause
    exit /b 1
)

echo.
echo Starting the application...
echo.
echo NOTE: Make sure you have:
echo 1. Setup Firebase project
echo 2. Added google-services.json to android/app/
echo 3. Connected Android device or emulator
echo.

flutter run
pause
