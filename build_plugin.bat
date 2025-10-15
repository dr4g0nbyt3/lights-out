@echo off
setlocal enabledelayedexpansion
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

REM Find the actual DLL location
set "DLL_PATH="
if exist "bin\Release\LightsOut.dll" (
    set "DLL_PATH=bin\Release\LightsOut.dll"
    echo Plugin location: %CD%\bin\Release\LightsOut.dll
) else if exist "bin\LightsOut.dll" (
    set "DLL_PATH=bin\LightsOut.dll"
    echo Plugin location: %CD%\bin\LightsOut.dll
) else if exist "Release\LightsOut.dll" (
    set "DLL_PATH=Release\LightsOut.dll"
    echo Plugin location: %CD%\Release\LightsOut.dll
) else (
    echo ERROR: Could not find LightsOut.dll in expected locations
    echo Searched:
    echo   - %CD%\bin\Release\LightsOut.dll
    echo   - %CD%\bin\LightsOut.dll
    echo   - %CD%\Release\LightsOut.dll
    cd ..
    pause
    exit /b 1
)
echo.

REM Ask if user wants to install the plugin
echo Do you want to install the plugin to BakkesMod? (Y/N)
set /p INSTALL_CHOICE="> "

if /i "!INSTALL_CHOICE!"=="Y" (
    echo.
    echo Installing plugin...
    echo.
    echo DEBUG: DLL_PATH = %DLL_PATH%
    echo DEBUG: APPDATA = %APPDATA%
    echo.

    REM Try to find BakkesMod plugins directory
    set "PLUGIN_DIR="

    if exist "%APPDATA%\bakkesmod\bakkesmod\plugins" (
        set "PLUGIN_DIR=%APPDATA%\bakkesmod\bakkesmod\plugins"
        echo DEBUG: Found plugins directory in APPDATA
    ) else if exist "%LOCALAPPDATA%\bakkesmod\bakkesmod\plugins" (
        set "PLUGIN_DIR=%LOCALAPPDATA%\bakkesmod\bakkesmod\plugins"
        echo DEBUG: Found plugins directory in LOCALAPPDATA
    ) else (
        REM Try to create in APPDATA
        echo BakkesMod plugins directory not found, creating...
        mkdir "%APPDATA%\bakkesmod\bakkesmod\plugins" 2>nul
        if exist "%APPDATA%\bakkesmod\bakkesmod\plugins" (
            set "PLUGIN_DIR=%APPDATA%\bakkesmod\bakkesmod\plugins"
            echo DEBUG: Created plugins directory in APPDATA
        )
    )

    echo DEBUG: PLUGIN_DIR = %PLUGIN_DIR%
    echo.

    if not defined PLUGIN_DIR (
        echo ERROR: Could not find or create BakkesMod plugins directory
        echo Please copy the plugin manually from:
        echo   %CD%\%DLL_PATH%
        echo To one of these locations:
        echo   %APPDATA%\bakkesmod\bakkesmod\plugins\
        echo   %LOCALAPPDATA%\bakkesmod\bakkesmod\plugins\
        cd ..
        pause
        exit /b 1
    )

    echo Installing from: %CD%\!DLL_PATH!
    echo Installing to: "!PLUGIN_DIR!\LightsOut.dll"
    echo.
    copy /Y "!DLL_PATH!" "!PLUGIN_DIR!\LightsOut.dll"
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo ========================================
        echo   Plugin Installed Successfully!
        echo ========================================
        echo Location: "%PLUGIN_DIR%\LightsOut.dll"
        echo.

        REM Apply lighting settings to TASystemSettings.ini
        set "CONFIG_DIR=%USERPROFILE%\Documents\My Games\Rocket League\TAGame\Config"
        set "TASYSTEM_FILE=%CONFIG_DIR%\TASystemSettings.ini"

        echo Checking for TASystemSettings.ini...
        if exist "%TASYSTEM_FILE%" (
            echo Found TASystemSettings.ini
            echo Creating backup...
            set "BACKUP_DIR=%CONFIG_DIR%\LightsOut_Backup"
            echo Backup directory path: %BACKUP_DIR%
            if not exist "%BACKUP_DIR%" (
                mkdir "%BACKUP_DIR%"
                if not exist "%BACKUP_DIR%" (
                    echo WARNING: Failed to create backup directory at %BACKUP_DIR%
                    echo Backup will not be saved.
                    set "BACKUP_DIR="
                ) else (
                    echo Backup directory created successfully.
                )
            ) else (
                echo Using existing backup directory.
            )

            if defined BACKUP_DIR (
                REM Get timestamp components
                for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%a%%b)
                for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)
                set "timestamp=!mydate!_!mytime!"
                set "timestamp=!timestamp: =0!"
                copy /Y "%TASYSTEM_FILE%" "%BACKUP_DIR%\TASystemSettings.ini.backup_!timestamp!"
            )

            echo Applying lighting changes to TASystemSettings.ini...

            REM Check if [SystemSettings] section exists
            findstr /C:"[SystemSettings]" "%TASYSTEM_FILE%" >nul 2>&1
            if %ERRORLEVEL% NEQ 0 (
                echo Adding [SystemSettings] section...
                echo [SystemSettings] >> "%TASYSTEM_FILE%"
            )

            REM Append lighting reduction settings
            echo ; Lights Out Mod - Applied lighting reduction settings >> "%TASYSTEM_FILE%"
            echo DynamicLights=False >> "%TASYSTEM_FILE%"
            echo DynamicShadows=False >> "%TASYSTEM_FILE%"
            echo LightEnvironmentShadows=False >> "%TASYSTEM_FILE%"
            echo CompositeDynamicLights=False >> "%TASYSTEM_FILE%"
            echo SHSecondaryLighting=False >> "%TASYSTEM_FILE%"
            echo DirectionalLightmaps=False >> "%TASYSTEM_FILE%"
            echo Bloom=False >> "%TASYSTEM_FILE%"
            echo AmbientOcclusion=False >> "%TASYSTEM_FILE%"
            echo LensFlares=False >> "%TASYSTEM_FILE%"
            echo FullEffectIntensity=False >> "%TASYSTEM_FILE%"
            echo MinShadowResolution=16 >> "%TASYSTEM_FILE%"
            echo MaxShadowResolution=16 >> "%TASYSTEM_FILE%"
            echo ShadowFilterQualityBias=0 >> "%TASYSTEM_FILE%"

            echo.
            echo Lighting settings applied successfully!
            if defined BACKUP_DIR (
                echo Backup saved to: "%BACKUP_DIR%"
            ) else (
                echo Backup saved to: (No backup directory created)
            )
        ) else (
            echo.
            echo WARNING: TASystemSettings.ini not found at %TASYSTEM_FILE%
            echo Please launch Rocket League at least once to generate this file.
            echo You can apply lighting settings later by running install_lightsout.bat
        )

        echo.
        echo ========================================
        echo   Lights Out v2.0 - Usage Instructions
        echo ========================================
        echo.
        echo CRITICAL: Plugin ONLY works in FREEPLAY mode!
        echo.
        echo STEP 1: Launch Rocket League ^(BakkesMod auto-starts^)
        echo.
        echo STEP 2: Navigate to: Play ^> Training ^> Free Play
        echo.
        echo STEP 3: Wait for freeplay to fully load
        echo.
        echo STEP 4: Press F6 to open BakkesMod console
        echo.
        echo STEP 5: Load the plugin
        echo   Type: plugin load lightsout
        echo.
        echo STEP 6: Load the configuration file
        echo   First, copy lightsout.cfg to: %%APPDATA%%\bakkesmod\bakkesmod\cfg\
        echo   Then in BakkesMod console: exec lightsout.cfg
        echo.
        echo STEP 7: Enable Lights Out
        echo   Type: lightsout_enable
        echo.
        echo ========================================
        echo   Available Commands
        echo ========================================
        echo.
        echo QUICK START:
        echo   lightsout_enable              - Enable Lights Out mode
        echo   lightsout_disable             - Disable and restore defaults
        echo.
        echo PRESETS (30%% to 95%% darker):
        echo   lightsout_preset subtle       - 30%% darker (bright maps)
        echo   lightsout_preset medium       - 60%% darker (balanced)
        echo   lightsout_preset dark         - 85%% darker (default)
        echo   lightsout_preset pitchblack   - 95%% darker (EXTREME)
        echo.
        echo QUICK ALIASES (from lightsout.cfg):
        echo   lo_enable / lo_disable        - Toggle mod
        echo   lo_subtle / lo_medium          - Apply presets
        echo   lo_dark / lo_pitchblack       - Apply dark presets
        echo   lo_status                     - Show current settings
        echo.
        echo GRANULAR CONTROLS (adjust individual parameters):
        echo   lightsout_directional_main    - Main light brightness (0.0-1.0)
        echo   lightsout_ambient_intensity   - Ambient light (0.0-1.0)
        echo   lightsout_bloom               - Bloom intensity (0.0-10.0)
        echo   lightsout_shadow_darkness     - Shadow depth (0.0-1.0)
        echo   lightsout_skybox_brightness   - Sky contribution (0.0-1.0)
        echo   lightsout_apply               - Apply current settings
        echo.
        echo UTILITY:
        echo   lightsout_status              - Display all current values
        echo   lightsout_reset               - Reset to default values
        echo.
        echo EXAMPLES:
        echo   lightsout_enable
        echo   lightsout_preset pitchblack
        echo   lightsout_bloom 6.0
        echo   lightsout_status
        echo.
        echo ========================================
        echo   Video Settings (IMPORTANT!)
        echo ========================================
        echo.
        echo For maximum darkness, set in Rocket League:
        echo   - Light Shafts: OFF (critical!)
        echo   - Bloom: ON (needed for headlights)
        echo   - Ambient Occlusion: ON (deeper shadows)
        echo.
        echo See LIGHTS_OUT_DETAILED_INSTRUCTIONS.md for full guide
        echo ========================================
    ) else (
        echo.
        echo ERROR: Failed to copy plugin
        echo You may need to run as Administrator
    )
) else if /i "!INSTALL_CHOICE!"=="N" (
    echo.
    echo Installation skipped.
    echo You can manually copy the plugin from:
    echo   %CD%\%DLL_PATH%
    echo To:
    echo   %%APPDATA%%\bakkesmod\bakkesmod\plugins\
) else (
    echo.
    echo Invalid input. Please enter Y or N.
    echo Installation skipped.
)

echo.
cd ..
pause
