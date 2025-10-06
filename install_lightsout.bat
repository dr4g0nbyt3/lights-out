@echo off
REM Lights Out Mod - Installation Script
REM This script installs the Lights Out Halloween mod files to Rocket League

echo ========================================
echo   Lights Out Mod - Installer
echo ========================================
echo.

REM Define paths
set "SCRIPT_DIR=%~dp0"
set "RL_DIR=%USERPROFILE%\Documents\My Games\Rocket League\TAGame\CookedPCConsole"
set "BACKUP_DIR=%RL_DIR%\LightsOut_Backup"

REM Check if Rocket League directory exists
if not exist "%RL_DIR%" (
    echo ERROR: Rocket League directory not found!
    echo Expected: %RL_DIR%
    echo.
    echo Please ensure Rocket League is installed and you've launched it at least once.
    pause
    exit /b 1
)

echo Rocket League directory found: %RL_DIR%
echo.

REM Create backup directory if it doesn't exist
if not exist "%BACKUP_DIR%" (
    echo Creating backup directory...
    mkdir "%BACKUP_DIR%"
)

REM Backup existing files if they exist
if exist "%RL_DIR%\LightsOut.upk" (
    echo Backing up existing LightsOut.upk...
    copy /Y "%RL_DIR%\LightsOut.upk" "%BACKUP_DIR%\LightsOut.upk.backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
)

if exist "%RL_DIR%\LightsOut_MaterialOverrides.ini" (
    echo Backing up existing LightsOut_MaterialOverrides.ini...
    copy /Y "%RL_DIR%\LightsOut_MaterialOverrides.ini" "%BACKUP_DIR%\LightsOut_MaterialOverrides.ini.backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
)

echo.
echo Installing Lights Out mod files...

REM Copy mod files
if exist "%SCRIPT_DIR%LightsOut.upk" (
    echo Installing LightsOut.upk...
    copy /Y "%SCRIPT_DIR%LightsOut.upk" "%RL_DIR%\LightsOut.upk"
    if errorlevel 1 (
        echo ERROR: Failed to copy LightsOut.upk
        pause
        exit /b 1
    )
) else (
    echo ERROR: LightsOut.upk not found in script directory!
    pause
    exit /b 1
)

if exist "%SCRIPT_DIR%LightsOut_MaterialOverrides.ini" (
    echo Installing LightsOut_MaterialOverrides.ini...
    copy /Y "%SCRIPT_DIR%LightsOut_MaterialOverrides.ini" "%RL_DIR%\LightsOut_MaterialOverrides.ini"
    if errorlevel 1 (
        echo ERROR: Failed to copy LightsOut_MaterialOverrides.ini
        pause
        exit /b 1
    )
) else (
    echo ERROR: LightsOut_MaterialOverrides.ini not found in script directory!
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Installation Complete!
echo ========================================
echo.
echo Mod files installed to: %RL_DIR%
echo Backups saved to: %BACKUP_DIR%
echo.
echo IMPORTANT: You must restart Rocket League for changes to take effect!
echo.
pause
