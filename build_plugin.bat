@echo off
REM Lights Out Plugin - Build Script
REM This script compiles the BakkesMod plugin

echo ========================================
echo   Lights Out Plugin - Build Script
echo ========================================
echo.

REM Check if Visual Studio is installed
where cl.exe >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Visual Studio C++ compiler not found!
    echo.
    echo Please install Visual Studio 2019 or later with C++ support.
    echo Make sure to run this from a "Developer Command Prompt for VS"
    echo or run vcvarsall.bat first.
    echo.
    pause
    exit /b 1
)

REM Check if CMake is installed
where cmake.exe >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: CMake not found!
    echo.
    echo Please install CMake from https://cmake.org/download/
    echo and add it to your PATH.
    echo.
    pause
    exit /b 1
)

REM Check for BakkesMod SDK
set "SDK_DIR=%USERPROFILE%\BakkesMod\BakkesModSDK"
if not exist "%SDK_DIR%" (
    echo BakkesMod SDK not found at default location: %SDK_DIR%
    echo.
    echo Attempting to download BakkesMod SDK...
    echo.

    REM Try to clone the SDK
    where git.exe >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo Cloning BakkesMod SDK...
        mkdir "%USERPROFILE%\BakkesMod" 2>nul
        cd /d "%USERPROFILE%\BakkesMod"
        git clone https://github.com/bakkesmodorg/BakkesModSDK.git
        if %ERRORLEVEL% NEQ 0 (
            echo ERROR: Failed to clone BakkesMod SDK
            pause
            exit /b 1
        )
    ) else (
        echo ERROR: Git not found. Cannot download BakkesMod SDK automatically.
        echo.
        echo Please manually:
        echo 1. Download from: https://github.com/bakkesmodorg/BakkesModSDK
        echo 2. Extract to: %SDK_DIR%
        echo 3. Run this script again
        echo.
        pause
        exit /b 1
    )
)

echo BakkesMod SDK found: %SDK_DIR%
echo.

REM Set SDK directory for CMake
set "BAKKESMOD_SDK_DIR=%SDK_DIR%"

REM Create build directory
echo Creating build directory...
if exist "build" (
    echo Cleaning old build...
    rmdir /s /q "build"
)
mkdir build
cd build

REM Run CMake
echo.
echo Running CMake configuration...
cmake -G "Visual Studio 16 2019" -A x64 -DBAKKESMOD_SDK_DIR="%BAKKESMOD_SDK_DIR%" ..
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: CMake configuration failed!
    echo.
    echo Try running CMake with different generator:
    echo cmake -G "Visual Studio 17 2022" -A x64 -DBAKKESMOD_SDK_DIR="%BAKKESMOD_SDK_DIR%" ..
    echo.
    cd ..
    pause
    exit /b 1
)

REM Build the project
echo.
echo Building plugin...
cmake --build . --config Release
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Build failed!
    cd ..
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Build Successful!
echo ========================================
echo.
echo Plugin location: %CD%\bin\Release\LightsOut.dll
echo.

REM Ask if user wants to install the plugin
echo Do you want to install the plugin to BakkesMod? (Y/N)
set /p INSTALL_CHOICE="> "

if /i "%INSTALL_CHOICE%"=="Y" (
    echo.
    echo Installing plugin...
    set "PLUGIN_DIR=%APPDATA%\bakkesmod\bakkesmod\plugins"

    if not exist "%PLUGIN_DIR%" (
        echo Creating plugin directory...
        mkdir "%PLUGIN_DIR%"
    )

    copy /Y "bin\Release\LightsOut.dll" "%PLUGIN_DIR%\LightsOut.dll"
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo Plugin installed successfully!
        echo Location: %PLUGIN_DIR%\LightsOut.dll
        echo.
        echo To use the plugin:
        echo 1. Launch Rocket League
        echo 2. Press F6 to open BakkesMod console
        echo 3. Type: plugin load lightsout
        echo 4. Type: lightsout_enable
    ) else (
        echo.
        echo ERROR: Failed to copy plugin to BakkesMod directory
    )
)

echo.
cd ..
pause
