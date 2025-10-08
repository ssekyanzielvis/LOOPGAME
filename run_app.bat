@echo off
echo Math Shape Creator - Flutter App Runner
echo =====================================
echo.

cd /d "C:\Users\SSEKYANZI\Desktop\MYLOOP\math_shape_creator"

echo Step 1: Checking Flutter installation...
flutter --version
if %errorlevel% neq 0 (
    echo ERROR: Flutter is not installed or not in PATH
    pause
    exit /b 1
)
echo.

echo Step 2: Installing dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Failed to get dependencies
    pause
    exit /b 1
)
echo.

echo Step 3: Analyzing code for issues...
flutter analyze
echo.

echo Step 4: Checking available devices...
flutter devices
echo.

echo Step 5: Choose your preferred platform:
echo [1] Windows Desktop
echo [2] Web Browser (Chrome)
echo [3] Android Emulator (if available)
set /p choice="Enter choice (1-3): "

if "%choice%"=="1" (
    echo Running on Windows Desktop...
    flutter run -d windows
) else if "%choice%"=="2" (
    echo Running on Web Browser...
    flutter run -d chrome
) else if "%choice%"=="3" (
    echo Running on Android...
    flutter run -d android
) else (
    echo Running with default device...
    flutter run
)

echo.
echo App finished running.
pause