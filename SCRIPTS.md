# Lights Out Mod - Scripts & Commands Documentation

This document provides detailed information about the automated installation scripts and BakkesMod commands for the Lights Out mod.

## Table of Contents
- [Installation Scripts](#installation-scripts)
- [BakkesMod Commands](#bakkesmod-commands)
- [Troubleshooting](#troubleshooting)
- [Advanced Usage](#advanced-usage)

---

## Installation Scripts

### `install_lightsout.bat`

**Purpose:** Automatically installs the Lights Out mod to your Rocket League directory.

**What it does:**
1. Locates your Rocket League installation directory
2. Creates a backup directory if it doesn't exist
3. Backs up any existing mod files with timestamps
4. Copies the mod files to the correct location
5. Validates that the installation was successful

**Usage:**
```batch
# Double-click the file, or run from command line:
install_lightsout.bat
```

**Requirements:**
- Windows OS
- Rocket League installed
- User has launched Rocket League at least once (to create the save directory)

**Backup Location:**
```
%USERPROFILE%\Documents\My Games\Rocket League\TAGame\CookedPCConsole\LightsOut_Backup\
```

**Backup Format:**
```
LightsOut.upk.backup_YYYYMMDD_HHMMSS
LightsOut_MaterialOverrides.ini.backup_YYYYMMDD_HHMMSS
```

**Error Codes:**
- Exit code 0: Success
- Exit code 1: Error (check console output)

---

### `uninstall_lightsout.bat`

**Purpose:** Removes the Lights Out mod from your Rocket League directory.

**What it does:**
1. Locates your Rocket League installation directory
2. Checks for the presence of mod files
3. Removes all Lights Out mod files
4. Keeps backups intact (manual deletion required)

**Usage:**
```batch
# Double-click the file, or run from command line:
uninstall_lightsout.bat
```

**Files Removed:**
- `LightsOut.upk`
- `LightsOut_MaterialOverrides.ini`

**Note:** Backups are NOT deleted automatically. You can safely delete the backup folder if you no longer need them.

---

## BakkesMod Commands

### Setup

1. **Install BakkesMod:**
   - Download from [bakkesmod.com](https://bakkesmod.com/)
   - Run the installer
   - Launch Rocket League to initialize BakkesMod

2. **Install the Config File:**
   ```
   Copy lightsout.cfg to:
   %APPDATA%\bakkesmod\bakkesmod\cfg\
   ```

3. **Load the Config:**
   - In Rocket League, press `F6` to open the console
   - Type: `exec lightsout.cfg`
   - You should see: "Lights Out mod config loaded!"

### Available Commands

#### `lightsout_install`
Runs the installation script to add the mod to Rocket League.

```
lightsout_install
```

**What happens:**
- Executes `install_lightsout.bat`
- A console window appears showing installation progress
- You must restart Rocket League after installation

---

#### `lightsout_uninstall`
Runs the uninstallation script to remove the mod from Rocket League.

```
lightsout_uninstall
```

**What happens:**
- Executes `uninstall_lightsout.bat`
- A console window appears showing uninstallation progress
- You must restart Rocket League after uninstallation

---

#### `lightsout_info`
Displays mod information in the console.

```
lightsout_info
```

**Output:**
- Version number
- Description
- Preserved features
- File names
- Available commands

---

#### `lightsout_help`
Shows all available Lights Out commands.

```
lightsout_help
```

**Output:**
- List of all commands
- Brief description of each
- Important notes

---

#### `lightsout_toggle`
Helper command that explains the toggle process.

```
lightsout_toggle
```

**Note:** Due to how Rocket League loads UPK files, the mod cannot be toggled on-the-fly. A game restart is required after install/uninstall.

---

### Key Binds (Optional)

You can bind the commands to specific keys for quick access.

**Edit `lightsout.cfg` and uncomment these lines:**

```cfg
bind F9 "lightsout_install"
bind F10 "lightsout_uninstall"
bind F11 "lightsout_info"
bind F12 "lightsout_help"
```

**Or add custom binds in the BakkesMod console:**

```
bind KEY "COMMAND"
```

**Examples:**
```
bind F9 "lightsout_install"
bind NUMPAD1 "lightsout_uninstall"
bind HOME "lightsout_info"
```

**Available Keys:**
- Function keys: F1-F12
- Numpad: NUMPAD0-NUMPAD9
- Special: HOME, END, PAGEUP, PAGEDOWN, INSERT, DELETE
- Letters: A-Z
- Numbers: 0-9

---

## Troubleshooting

### Scripts

#### "Rocket League directory not found"
**Cause:** The script cannot locate your Rocket League save directory.

**Solutions:**
1. Launch Rocket League at least once to create the save directory
2. Verify the path exists: `%USERPROFILE%\Documents\My Games\Rocket League\TAGame\CookedPCConsole`
3. If using a custom path, edit the BAT file and change the `RL_DIR` variable

---

#### "Failed to copy files"
**Cause:** Permission issues or files are in use.

**Solutions:**
1. Close Rocket League completely
2. Run the script as Administrator (right-click → "Run as administrator")
3. Check that the mod files are in the same directory as the script

---

#### Script doesn't run / Windows blocks it
**Cause:** Windows security blocking unsigned scripts.

**Solutions:**
1. Right-click the .bat file → Properties
2. Check "Unblock" at the bottom
3. Click Apply → OK
4. Try running again

---

### BakkesMod Commands

#### "lightsout.cfg not found"
**Cause:** The config file is not in the correct location.

**Solution:**
```
Ensure lightsout.cfg is in: %APPDATA%\bakkesmod\bakkesmod\cfg\
Full path example: C:\Users\YourName\AppData\Roaming\bakkesmod\bakkesmod\cfg\lightsout.cfg
```

---

#### Commands do nothing
**Cause:** Config not loaded or BakkesMod not running.

**Solutions:**
1. Press `F6` to open console
2. Type: `exec lightsout.cfg`
3. Verify BakkesMod is running (should see overlay)
4. Try typing the command again

---

#### "Command not recognized"
**Cause:** Config file not loaded or typo in command.

**Solutions:**
1. Load the config: `exec lightsout.cfg`
2. Check command spelling: `lightsout_help`
3. Verify the config file syntax (no syntax errors)

---

## Advanced Usage

### Customizing the Scripts

You can edit the `.bat` files to change behavior.

**Common Modifications:**

#### Change Rocket League Directory
Edit this line in the script:
```batch
set "RL_DIR=%USERPROFILE%\Documents\My Games\Rocket League\TAGame\CookedPCConsole"
```

Example for custom location:
```batch
set "RL_DIR=D:\Games\RocketLeague\TAGame\CookedPCConsole"
```

---

#### Disable Backups
Comment out backup sections by adding `REM` at the start of lines:
```batch
REM if exist "%RL_DIR%\LightsOut.upk" (
REM     echo Backing up existing LightsOut.upk...
REM     copy /Y "%RL_DIR%\LightsOut.upk" "%BACKUP_DIR%\LightsOut.upk.backup"
REM )
```

---

#### Silent Installation (No Pause)
Remove the `pause` command at the end:
```batch
REM pause
```

---

### Customizing BakkesMod Config

Edit `lightsout.cfg` to add functionality.

#### Add Automatic Visual Settings
Uncomment these lines to enable visual enhancements automatically:
```cfg
cl_dynamicshadows 1
cl_bloom_scale 1.2
cl_lightquality 1
```

---

#### Create Custom Commands
Add your own aliases:
```cfg
alias lightsout_darkmode "lightsout_install; cl_bloom_scale 1.5; echo Dark mode activated!"
alias lightsout_normal "lightsout_uninstall; cl_bloom_scale 1.0; echo Normal mode activated!"
```

---

#### Auto-Load on Startup
Add this line to your `autoexec.cfg` in BakkesMod:
```cfg
exec lightsout.cfg
```

Location: `%APPDATA%\bakkesmod\bakkesmod\cfg\autoexec.cfg`

---

### Running Scripts from Command Line

You can run the scripts with parameters (requires modification of the scripts).

**Current usage:**
```batch
install_lightsout.bat
uninstall_lightsout.bat
```

**Silent installation (no pause):**
Add `/silent` parameter support by editing the script:
```batch
if "%1"=="/silent" (
    goto :skipPause
)
pause
:skipPause
```

Then run:
```batch
install_lightsout.bat /silent
```

---

## Quick Reference

### File Locations

| File | Location |
|------|----------|
| Mod files | Same folder as scripts |
| Scripts | Anywhere (Desktop recommended) |
| BakkesMod config | `%APPDATA%\bakkesmod\bakkesmod\cfg\` |
| Rocket League install | `%USERPROFILE%\Documents\My Games\Rocket League\TAGame\CookedPCConsole` |
| Backups | `[Rocket League Install]\LightsOut_Backup\` |

---

### Command Quick Reference

| Command | Description | Requires Restart |
|---------|-------------|------------------|
| `lightsout_install` | Install the mod | ✅ Yes |
| `lightsout_uninstall` | Uninstall the mod | ✅ Yes |
| `lightsout_info` | Show mod info | ❌ No |
| `lightsout_help` | Show help | ❌ No |
| `lightsout_toggle` | Toggle helper | ✅ Yes |

---

## Support

For issues with the scripts or commands:

1. Check this documentation first
2. Verify all files are in correct locations
3. Try running scripts as Administrator
4. Check the troubleshooting section
5. Create an issue in the repository with:
   - Error message (exact text)
   - Steps you followed
   - Your Rocket League installation path
   - BakkesMod version (if applicable)

---

**Happy modding! 🎃**
