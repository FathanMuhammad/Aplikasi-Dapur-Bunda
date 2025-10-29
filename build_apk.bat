@echo off
echo ========================================
echo    Building APK - Dapur Bunda Bahagia
echo ========================================
echo.

echo Checking Flutter installation...
flutter --version
if %errorlevel% neq 0 (
    echo ERROR: Flutter not found! Please install Flutter first.
    pause
    exit /b 1
)

echo.
echo Cleaning previous builds...
flutter clean

echo.
echo Getting dependencies...
flutter pub get

echo.
echo Running code analysis...
flutter analyze
if %errorlevel% neq 0 (
    echo WARNING: Code analysis found issues. Continue anyway? (Y/N)
    set /p continue=
    if /i not "%continue%"=="Y" (
        echo Build cancelled.
        pause
        exit /b 1
    )
)

echo.
echo Running tests...
flutter test
if %errorlevel% neq 0 (
    echo WARNING: Some tests failed. Continue anyway? (Y/N)
    set /p continue=
    if /i not "%continue%"=="Y" (
        echo Build cancelled.
        pause
        exit /b 1
    )
)

echo.
echo Building APK...
echo This may take several minutes...
flutter build apk --release

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo           BUILD SUCCESSFUL!
    echo ========================================
    echo.
    echo APK location: build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo You can now install this APK on Android devices.
    echo.
) else (
    echo.
    echo ========================================
    echo            BUILD FAILED!
    echo ========================================
    echo.
    echo Please check the error messages above.
    echo Make sure:
    echo 1. Firebase is properly configured
    echo 2. google-services.json is in android/app/
    echo 3. All dependencies are installed
    echo.
)

pause
