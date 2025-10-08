@echo off
REM Lights Out Plugin - Build Script
REM This script compiles the BakkesMod plugin

echo ========================================
echo   Lights Out Plugin - Build Script
echo ========================================
echo.

REM Check if Visual Studio is already in PATH
where cl.exe >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Visual Studio C++ compiler not in PATH, searching for it...
    echo.

    REM Try to find and load Visual Studio environment
    set "VS_FOUND=0"

    REM Check for VS 2022
    if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" (
        echo Found Visual Studio 2022 Community
        call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
        set "VS_FOUND=1"
    ) else if exist "C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvarsall.bat" (
        echo Found Visual Studio 2022 Professional
        call "C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvarsall.bat" x64
        set "VS_FOUND=1"
    ) else if exist "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" (
        echo Found Visual Studio 2022 Enterprise
        call "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" x64
        set "VS_FOUND=1"
    )

    REM Check for VS 2019
    if "%VS_FOUND%"=="0" (
        if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" (
            echo Found Visual Studio 2019 Community
            call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
            set "VS_FOUND=1"
        ) else if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Auxiliary\Build\vcvarsall.bat" (
            echo Found Visual Studio 2019 Professional
            call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Auxiliary\Build\vcvarsall.bat" x64
            set "VS_FOUND=1"
        ) else if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" (
            echo Found Visual Studio 2019 Enterprise
            call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" x64
            set "VS_FOUND=1"
        )
    )

    if "%VS_FOUND%"=="0" (
        echo ERROR: Visual Studio not found!
        echo.
        echo Please install Visual Studio 2019 or later with C++ support.
        echo Download from: https://visualstudio.microsoft.com/downloads/
        echo.
        echo Make sure to install "Desktop development with C++"
        echo.
        pause
        exit /b 1
    )

    echo Visual Studio environment loaded successfully!
    echo.
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

REM Save the project directory
set "PROJECT_DIR=%CD%"
echo Project directory: %PROJECT_DIR%
echo.

REM Create build directory
echo Creating build directory...
if exist "build" (
    echo Cleaning old build...
    rmdir /s /q "build"
)
mkdir build
cd build

REM Detect Visual Studio version for CMake generator
set "CMAKE_GENERATOR=Visual Studio 16 2019"
if exist "C:\Program Files\Microsoft Visual Studio\2022" (
    set "CMAKE_GENERATOR=Visual Studio 17 2022"
    echo Using Visual Studio 2022
) else (
    echo Using Visual Studio 2019
)

REM Run CMake
echo.
echo Running CMake configuration...
echo Generator: %CMAKE_GENERATOR%
echo SDK Path: %BAKKESMOD_SDK_DIR%
echo Source Path: %PROJECT_DIR%
echo.
cmake -G "%CMAKE_GENERATOR%" -A x64 -DBAKKESMOD_SDK_DIR="%BAKKESMOD_SDK_DIR%" "%PROJECT_DIR%"
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: CMake configuration failed!
    echo.
    echo Troubleshooting:
    echo 1. Make sure you're running from the lights-out project directory
    echo 2. Check that CMakeLists.txt exists in the project folder
    echo 3. Verify SDK path: %BAKKESMOD_SDK_DIR%
    echo.
    echo Current directory: %CD%
    echo Project directory: %PROJECT_DIR%
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

    REM Try to find BakkesMod plugins directory
    set "PLUGIN_DIR="

    if exist "%APPDATA%\bakkesmod\bakkesmod\plugins" (
        set "PLUGIN_DIR=%APPDATA%\bakkesmod\bakkesmod\plugins"
    ) else if exist "%LOCALAPPDATA%\bakkesmod\bakkesmod\plugins" (
        set "PLUGIN_DIR=%LOCALAPPDATA%\bakkesmod\bakkesmod\plugins"
    ) else (
        REM Try to create in APPDATA
        echo BakkesMod plugins directory not found, creating...
        mkdir "%APPDATA%\bakkesmod\bakkesmod\plugins" 2>nul
        if exist "%APPDATA%\bakkesmod\bakkesmod\plugins" (
            set "PLUGIN_DIR=%APPDATA%\bakkesmod\bakkesmod\plugins"
        )
    )

    if not defined PLUGIN_DIR (
        echo ERROR: Could not find or create BakkesMod plugins directory
        echo Please copy the plugin manually from:
        echo   %CD%\bin\Release\LightsOut.dll
        echo To one of these locations:
        echo   %APPDATA%\bakkesmod\bakkesmod\plugins\
        echo   %LOCALAPPDATA%\bakkesmod\bakkesmod\plugins\
        cd ..
        pause
        exit /b 1
    )

    echo Installing to: %PLUGIN_DIR%
    copy /Y "bin\Release\LightsOut.dll" "%PLUGIN_DIR%\LightsOut.dll"
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo ========================================
        echo   Plugin Installed Successfully!
        echo ========================================
        echo Location: %PLUGIN_DIR%\LightsOut.dll
        echo.
        echo To use the plugin:
        echo 1. Launch Rocket League
        echo 2. Press F6 to open BakkesMod console
        echo 3. Type: plugin load lightsout
        echo 4. Type: lightsout_enable
        echo.
        echo The arena lights will turn off!
    ) else (
        echo.
        echo ERROR: Failed to copy plugin
        echo You may need to run as Administrator
    )
)

echo.
cd ..
pause
