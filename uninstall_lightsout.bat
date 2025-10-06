@echo off
REM Lights Out Mod - Uninstallation Script
REM This script removes the Lights Out Halloween mod files from Rocket League

echo ========================================
echo   Lights Out Mod - Uninstaller
echo ========================================
echo.

REM Define paths
set "RL_DIR=%USERPROFILE%\Documents\My Games\Rocket League\TAGame\CookedPCConsole"
set "BACKUP_DIR=%RL_DIR%\LightsOut_Backup"

REM Check if Rocket League directory exists
if not exist "%RL_DIR%" (
    echo ERROR: Rocket League directory not found!
    echo Expected: %RL_DIR%
    pause
    exit /b 1
)

echo Rocket League directory found: %RL_DIR%
echo.

REM Check if mod files exist
set "MOD_FOUND=0"

if exist "%RL_DIR%\LightsOut.upk" (
    set "MOD_FOUND=1"
    echo Found: LightsOut.upk
)

if exist "%RL_DIR%\LightsOut_MaterialOverrides.ini" (
    set "MOD_FOUND=1"
    echo Found: LightsOut_MaterialOverrides.ini
)

if "%MOD_FOUND%"=="0" (
    echo.
    echo No Lights Out mod files found. Mod may already be uninstalled.
    pause
    exit /b 0
)

echo.
echo Removing Lights Out mod files...

REM Delete mod files
if exist "%RL_DIR%\LightsOut.upk" (
    echo Removing LightsOut.upk...
    del /F /Q "%RL_DIR%\LightsOut.upk"
    if errorlevel 1 (
        echo WARNING: Failed to delete LightsOut.upk
    ) else (
        echo   - Removed successfully
    )
)

if exist "%RL_DIR%\LightsOut_MaterialOverrides.ini" (
    echo Removing LightsOut_MaterialOverrides.ini...
    del /F /Q "%RL_DIR%\LightsOut_MaterialOverrides.ini"
    if errorlevel 1 (
        echo WARNING: Failed to delete LightsOut_MaterialOverrides.ini
    ) else (
        echo   - Removed successfully
    )
)

echo.
echo ========================================
echo   Uninstallation Complete!
echo ========================================
echo.

if exist "%BACKUP_DIR%" (
    echo Backup files are still available at: %BACKUP_DIR%
    echo You can safely delete this folder if you no longer need the backups.
    echo.
)

echo IMPORTANT: You must restart Rocket League for changes to take effect!
echo.
pause
