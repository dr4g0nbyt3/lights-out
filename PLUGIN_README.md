# Lights Out - BakkesMod Plugin

This is a BakkesMod plugin that actually reduces arena lighting in Rocket League to create a spooky, dark atmosphere.

## How It Works

The plugin hooks into Rocket League's lighting system and reduces the brightness of DirectionalLights (the main stadium lights) to 15% of their original value, while preserving car headlights, boost effects, and ball visibility.

## Prerequisites

- Visual Studio 2019 or later
- BakkesMod SDK
- CMake 3.15+

## Compilation Instructions

### 1. Set up BakkesMod SDK

```bash
git clone https://github.com/bakkesmodorg/BakkesModSDK.git
cd BakkesModSDK
```

### 2. Create Plugin Project

Create a new folder in `BakkesModSDK/plugins/`:

```bash
mkdir BakkesModSDK/plugins/LightsOut
```

Copy these files into that folder:
- `LightsOutPlugin.cpp`
- `LightsOutPlugin.h`

### 3. Create CMakeLists.txt

Create `BakkesModSDK/plugins/LightsOut/CMakeLists.txt`:

```cmake
cmake_minimum_required(VERSION 3.15)
project(LightsOut)

set(CMAKE_CXX_STANDARD 17)

add_library(LightsOut SHARED
    LightsOutPlugin.cpp
    LightsOutPlugin.h
)

target_link_libraries(LightsOut PRIVATE bakkesmod)
target_include_directories(LightsOut PRIVATE ${BAKKESMOD_INCLUDE_DIR})
```

### 4. Build the Plugin

```bash
cd BakkesModSDK
mkdir build
cd build
cmake ..
cmake --build . --config Release
```

The compiled `.dll` file will be in `build/plugins/LightsOut/Release/LightsOut.dll`

### 5. Install the Plugin

Copy `LightsOut.dll` to:
```
%APPDATA%\bakkesmod\bakkesmod\plugins\
```

## Usage

### In-Game Commands

Once installed, open the BakkesMod console (F6) and use:

```
lightsout_enable   - Turn on lights-out mode
lightsout_disable  - Turn off lights-out mode
```

### Customize Lighting

Adjust the darkness level:

```
lightsout_brightness 0.15   // 0.0 (pitch black) to 1.0 (full brightness)
lightsout_ambient 0.05      // Ambient light intensity
```

### Auto-Enable

To automatically enable lights-out mode, add to your BakkesMod autoexec.cfg:

```
plugin load lightsout
lightsout_enable
```

## Troubleshooting

**Plugin doesn't load:**
- Check BakkesMod console for error messages
- Ensure the DLL is in the correct plugins folder
- Verify BakkesMod version compatibility

**Lighting doesn't change:**
- Make sure you're in a match (not main menu)
- Try reloading: `plugin unload lightsout; plugin load lightsout`
- Check that you've run `lightsout_enable`

**Game crashes:**
- This shouldn't happen, but if it does, remove the plugin and report the issue

## Alternative: Simple Configuration (No Compilation)

If you don't want to compile a plugin, you can use the included `lightsout.cfg` for basic visual enhancements:

1. Copy `lightsout.cfg` to `%APPDATA%\bakkesmod\bakkesmod\cfg\`
2. In Rocket League, press F6 and type: `exec lightsout.cfg`
3. Manually adjust video settings in Rocket League:
   - Light Shafts: OFF
   - Bloom: ON
   - Ambient Occlusion: ON

This won't actually reduce arena lights but will enhance the atmosphere.

## Technical Notes

The plugin modifies:
- DirectionalLight brightness (reduced to 15%)
- Light color tint (slightly blue for eerie effect)
- Ambient lighting intensity

It does NOT modify:
- Car headlights
- Boost particle effects
- Ball lighting
- UI elements

## Contributing

If you improve the lighting algorithm or add features, please submit a pull request!

## License

See LICENSE file in the repository root.
