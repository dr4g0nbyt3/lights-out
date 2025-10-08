@echo off
REM Lights Out Mod - Installation Script
REM This script installs the Lights Out Halloween mod files to Rocket League

echo ========================================
echo   Lights Out Mod - Installer
echo ========================================
echo.

REM Define paths
set "SCRIPT_DIR=%~dp0"
set "RL_DIR="

REM Try default location first
set "DEFAULT_RL_DIR=%USERPROFILE%\Documents\My Games\Rocket League\TAGame\CookedPCConsole"
if exist "%DEFAULT_RL_DIR%" (
    set "RL_DIR=%DEFAULT_RL_DIR%"
    goto :found_rl_dir
)

REM Search for Steam library folders
echo Searching for Rocket League in Steam library folders...
echo.

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
REM Note: libraryfolders.vdf can be in steamapps OR in the steam root directory
for %%D in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%D:\Steam\steamapps\libraryfolders.vdf" (
        call :search_steam_libraries "%%D:\Steam\steamapps\libraryfolders.vdf"
    )
    if exist "%%D:\Steam\libraryfolders.vdf" (
        call :search_steam_libraries "%%D:\Steam\libraryfolders.vdf"
    )
    if exist "%%D:\SteamLibrary\steamapps\libraryfolders.vdf" (
        call :search_steam_libraries "%%D:\SteamLibrary\steamapps\libraryfolders.vdf"
    )
    if exist "%%D:\SteamLibrary\libraryfolders.vdf" (
        call :search_steam_libraries "%%D:\SteamLibrary\libraryfolders.vdf"
    )
    if exist "%%D:\Games\Steam\steamapps\libraryfolders.vdf" (
        call :search_steam_libraries "%%D:\Games\Steam\steamapps\libraryfolders.vdf"
    )
    if exist "%%D:\Games\Steam\libraryfolders.vdf" (
        call :search_steam_libraries "%%D:\Games\Steam\libraryfolders.vdf"
    )
)

REM Check for nested custom paths like D:\data\gaming\pc\steam
for %%D in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    for %%P in (data\gaming\pc\steam games\steam program_files\steam) do (
        if exist "%%D:\%%P\libraryfolders.vdf" (
            echo Found VDF: %%D:\%%P\libraryfolders.vdf
            call :search_steam_libraries "%%D:\%%P\libraryfolders.vdf"
        )
        if exist "%%D:\%%P\steamapps\libraryfolders.vdf" (
            echo Found VDF: %%D:\%%P\steamapps\libraryfolders.vdf
            call :search_steam_libraries "%%D:\%%P\steamapps\libraryfolders.vdf"
        )
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
set "CONFIG_DIR=%USERPROFILE%\Documents\My Games\Rocket League\TAGame\Config"
set "TASYSTEM_FILE=%CONFIG_DIR%\TASystemSettings.ini"

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

REM Backup TASystemSettings.ini
if exist "%TASYSTEM_FILE%" (
    echo Backing up TASystemSettings.ini...
    copy /Y "%TASYSTEM_FILE%" "%BACKUP_DIR%\TASystemSettings.ini.backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
) else (
    echo WARNING: TASystemSettings.ini not found at %TASYSTEM_FILE%
    echo The lighting changes may not apply properly.
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
echo Applying lighting changes to TASystemSettings.ini...

REM Apply lighting settings to TASystemSettings.ini
if exist "%TASYSTEM_FILE%" (
    REM Check if [SystemSettings] section exists
    findstr /C:"[SystemSettings]" "%TASYSTEM_FILE%" >nul 2>&1
    if errorlevel 1 (
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

    echo Lighting settings applied successfully!
) else (
    echo ERROR: Could not apply lighting settings - TASystemSettings.ini not found
    echo You may need to launch Rocket League once to generate this file.
)

echo.
echo ========================================
echo   Installation Complete!
echo ========================================
echo.
echo Mod files installed to: %RL_DIR%
echo Lighting settings applied to: %TASYSTEM_FILE%
echo Backups saved to: %BACKUP_DIR%
echo.
echo IMPORTANT: You must restart Rocket League for changes to take effect!
echo.
pause
exit /b 0

:search_steam_libraries
REM This subroutine searches for Rocket League in Steam library folders
setlocal enabledelayedexpansion
set "VDF_FILE=%~1"

echo Parsing VDF: %VDF_FILE%

REM Parse libraryfolders.vdf to find all library paths
REM The path value is in the format: "path"		"C:\\Path\\To\\Steam"
for /f "usebackq tokens=2* delims=	 " %%P in (`findstr /C:"path" "%VDF_FILE%"`) do (
    set "LIBRARY_PATH=%%~P"

    REM Remove quotes and handle escaped backslashes
    set "LIBRARY_PATH=!LIBRARY_PATH:"=!"
    set "LIBRARY_PATH=!LIBRARY_PATH:\\=\!"

    echo Checking library path: !LIBRARY_PATH!

    REM Check if Rocket League is installed in this library
    set "RL_STEAM_PATH=!LIBRARY_PATH!\steamapps\common\rocketleague"
    if exist "!RL_STEAM_PATH!" (
        echo Found Rocket League at: !RL_STEAM_PATH!
        REM Found the game installation, now check for config directories
        REM First check the standard Documents location
        set "RL_CONFIG_DIR=%USERPROFILE%\Documents\My Games\Rocket League\TAGame\CookedPCConsole"
        echo Checking: !RL_CONFIG_DIR!
        if exist "!RL_CONFIG_DIR!" (
            echo SUCCESS: Found config at !RL_CONFIG_DIR!
            endlocal
            set "RL_DIR=!RL_CONFIG_DIR!"
            goto :eof
        )

        REM If not found, check inside the game installation directory
        set "RL_CONFIG_DIR=!RL_STEAM_PATH!\TAGame\CookedPCConsole"
        echo Checking: !RL_CONFIG_DIR!
        if exist "!RL_CONFIG_DIR!" (
            echo SUCCESS: Found config at !RL_CONFIG_DIR!
            endlocal
            set "RL_DIR=!RL_CONFIG_DIR!"
            goto :eof
        ) else (
            echo NOT FOUND: !RL_CONFIG_DIR!
        )
    )
)
endlocal
goto :eof
