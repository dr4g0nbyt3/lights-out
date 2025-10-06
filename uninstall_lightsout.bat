@echo off
REM Lights Out Mod - Uninstallation Script
REM This script removes the Lights Out Halloween mod files from Rocket League

echo ========================================
echo   Lights Out Mod - Uninstaller
echo ========================================
echo.

REM Define paths
set "RL_DIR="

REM Try default location first
set "DEFAULT_RL_DIR=%USERPROFILE%\Documents\My Games\Rocket League\TAGame\CookedPCConsole"
if exist "%DEFAULT_RL_DIR%" (
    set "RL_DIR=%DEFAULT_RL_DIR%"
    goto :found_rl_dir
)

REM Search for Steam library folders
echo Searching for Rocket League in Steam library folders...

REM Check default Steam location
set "STEAM_DIR=C:\Program Files (x86)\Steam"
if exist "%STEAM_DIR%\steamapps\libraryfolders.vdf" (
    call :search_steam_libraries "%STEAM_DIR%\steamapps\libraryfolders.vdf"
)

REM Check Program Files (x64)
if exist "C:\Program Files\Steam\steamapps\libraryfolders.vdf" (
    call :search_steam_libraries "C:\Program Files\Steam\steamapps\libraryfolders.vdf"
)

REM Check alternative Steam locations on all drives
for %%D in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%D:\Steam\steamapps\libraryfolders.vdf" (
        call :search_steam_libraries "%%D:\Steam\steamapps\libraryfolders.vdf"
    )
    if exist "%%D:\SteamLibrary\steamapps\libraryfolders.vdf" (
        call :search_steam_libraries "%%D:\SteamLibrary\steamapps\libraryfolders.vdf"
    )
    if exist "%%D:\Games\Steam\steamapps\libraryfolders.vdf" (
        call :search_steam_libraries "%%D:\Games\Steam\steamapps\libraryfolders.vdf"
    )
)

if not defined RL_DIR (
    echo ERROR: Rocket League directory not found!
    echo Expected default location: %DEFAULT_RL_DIR%
    echo.
    echo Please ensure Rocket League is installed and you've launched it at least once.
    echo If you have Steam installed in a custom location, the script may not have found it.
    echo.
    echo You can manually specify the path by setting the RL_DIR environment variable.
    pause
    exit /b 1
)

:found_rl_dir
set "BACKUP_DIR=%RL_DIR%\LightsOut_Backup"

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
exit /b 0

:search_steam_libraries
REM This subroutine searches for Rocket League in Steam library folders
setlocal enabledelayedexpansion
set "VDF_FILE=%~1"

REM Parse libraryfolders.vdf to find all library paths
REM The path value is in the format: "path"		"C:\\Path\\To\\Steam"
for /f "usebackq tokens=2* delims=	 " %%P in (`findstr /C:"path" "%VDF_FILE%"`) do (
    set "LIBRARY_PATH=%%~P"

    REM Remove quotes and handle escaped backslashes
    set "LIBRARY_PATH=!LIBRARY_PATH:"=!"
    set "LIBRARY_PATH=!LIBRARY_PATH:\\=\!"

    REM Check if Rocket League is installed in this library
    set "RL_STEAM_PATH=!LIBRARY_PATH!\steamapps\common\rocketleague"
    if exist "!RL_STEAM_PATH!" (
        REM Found the game, now check for the config directory
        set "RL_CONFIG_DIR=%USERPROFILE%\Documents\My Games\Rocket League\TAGame\CookedPCConsole"
        if exist "!RL_CONFIG_DIR!" (
            endlocal
            set "RL_DIR=!RL_CONFIG_DIR!"
            goto :eof
        )
    )
)
endlocal
goto :eof
