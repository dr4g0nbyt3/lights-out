## Building the Lights Out BakkesMod Plugin

### Quick Start (Windows)

**Just run this:**
```batch
build_plugin.bat
```

The script will:
1. Check for required tools (Visual Studio, CMake)
2. Download BakkesMod SDK if needed
3. Compile the plugin
4. Optionally install it to BakkesMod

### Prerequisites

Before running the build script, you need:

#### 1. Visual Studio 2019 or 2022 (Community Edition is free)
- Download from: https://visualstudio.microsoft.com/downloads/
- During installation, select "Desktop development with C++"
- Make sure "MSVC v142 - VS 2019 C++ x64/x86 build tools" is checked

#### 2. CMake 3.15 or later
- Download from: https://cmake.org/download/
- During installation, select "Add CMake to system PATH"

#### 3. Git (optional, but recommended)
- Download from: https://git-scm.com/
- Used to automatically download BakkesMod SDK

### Manual Build Steps

If the automated script doesn't work, follow these steps:

#### Step 1: Download BakkesMod SDK

```batch
mkdir %USERPROFILE%\BakkesMod
cd %USERPROFILE%\BakkesMod
git clone https://github.com/bakkesmodorg/BakkesModSDK.git
```

#### Step 2: Open Developer Command Prompt

- Open Start Menu
- Search for "Developer Command Prompt for VS 2019" (or VS 2022)
- Run as Administrator

#### Step 3: Navigate to Plugin Directory

```batch
cd path\to\lights-out
```

#### Step 4: Run CMake

```batch
mkdir build
cd build
cmake -G "Visual Studio 16 2019" -A x64 -DBAKKESMOD_SDK_DIR="%USERPROFILE%\BakkesMod\BakkesModSDK" ..
```

*Note: For VS 2022, use "Visual Studio 17 2022"*

#### Step 5: Build

```batch
cmake --build . --config Release
```

#### Step 6: Install Plugin

```batch
copy bin\Release\LightsOut.dll %APPDATA%\bakkesmod\bakkesmod\plugins\
```

### Testing the Plugin

1. Launch Rocket League
2. Press `F6` to open BakkesMod console
3. Type: `plugin load lightsout`
4. Type: `lightsout_enable`
5. Start a match or freeplay

You should see dramatically reduced arena lighting!

### Troubleshooting

**"CMake not found"**
- Install CMake and make sure it's in your PATH
- Or use full path: `C:\Program Files\CMake\bin\cmake.exe`

**"Visual Studio not found"**
- Run from Developer Command Prompt
- Or manually run: `"C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x64`

**"BakkesMod SDK not found"**
- Clone it manually: `git clone https://github.com/bakkesmodorg/BakkesModSDK.git`
- Or download ZIP from GitHub and extract

**Build errors about missing headers**
- Make sure BAKKESMOD_SDK_DIR points to the correct location
- Check that the SDK was cloned completely

**Plugin doesn't load in BakkesMod**
- Check BakkesMod console for error messages
- Verify the .dll is in `%APPDATA%\bakkesmod\bakkesmod\plugins\`
- Make sure you built for x64 (not x86)

**Plugin loads but doesn't affect lighting**
- Make sure you're in a match (not main menu)
- Try typing `lightsout_enable` again
- Check values: `lightsout_brightness` and `lightsout_ambient`

### Advanced Options

**Adjust darkness level:**
```
lightsout_brightness 0.10    # Darker (0.0 = pitch black)
lightsout_brightness 0.20    # Lighter
```

**Adjust ambient lighting:**
```
lightsout_ambient 0.03       # Darker shadows
lightsout_ambient 0.08       # Lighter shadows
```

**Auto-load on startup:**

Add to `%APPDATA%\bakkesmod\bakkesmod\cfg\autoexec.cfg`:
```
plugin load lightsout
lightsout_enable
lightsout_brightness 0.15
```

### Development

To modify the plugin:

1. Edit `LightsOutPlugin.cpp` or `LightsOutPlugin.h`
2. Run `build_plugin.bat` again
3. Reload in BakkesMod: `plugin reload lightsout`

### Getting Help

If you encounter issues:

1. Check the [BakkesMod Discord](https://discord.gg/bakkesmod)
2. Create an issue in this repository
3. Make sure you have the latest version of BakkesMod

---

**Note:** This plugin only works with BakkesMod. It will not work in online competitive matches (BakkesMod is disabled in competitive for fairness).
