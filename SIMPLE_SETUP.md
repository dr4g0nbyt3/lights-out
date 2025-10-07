# Lights Out - Simple Setup (No Compilation Required)

Since compiling the BakkesMod plugin requires the full Plugin SDK with library files (not available on GitHub), here's the **simple, working solution** that doesn't require any compilation:

## Method 1: BakkesMod Config (Easiest - Works Now!)

### Setup:

1. **Copy the config file:**
   ```batch
   copy lightsout.cfg "%APPDATA%\bakkesmod\bakkesmod\cfg\"
   ```

2. **In Rocket League:**
   - Press `F6` to open BakkesMod console
   - Type: `exec lightsout.cfg`

3. **Manually adjust Video Settings:**
   - Settings → Video
   - **Light Shafts: OFF** (most important!)
   - **Bloom: ON**
   - **Ambient Occlusion: ON**
   - **Depth of Field: OFF**

### Result:
You'll get a significantly darker arena atmosphere with enhanced contrast from headlights and boost effects.

### Commands:
- `lo_on` - Apply dark atmosphere settings
- `lo_off` - Restore normal settings
- `lightsout_help` - Show all commands

---

## Method 2: Manual Video Settings (No BakkesMod Required)

If you don't use BakkesMod at all:

1. **Rocket League → Settings → Video:**
   - Light Shafts: **OFF**
   - Bloom: **ON**
   - Ambient Occlusion: **ON**
   - Lens Flares: **OFF**
   - Light Quality: **High**

2. **Optional - Graphics Settings:**
   - Render Quality: High
   - Texture Detail: High Quality
   - World Detail: High Quality

This creates a darker atmosphere without any mods.

---

## About the Plugin

The C++ plugin in this repo (`LightsOutPlugin.cpp`) was an attempt to programmatically control lighting, but:

- BakkesMod SDK on GitHub is header-only (no .lib files)
- Full Plugin SDK with libraries is harder to obtain
- Plugin compilation is complex for most users

**The config-based approach above works just as well** for creating the lights-out atmosphere!

---

## Troubleshooting

**Still too bright?**
- Make sure Light Shafts are OFF (this is the key setting!)
- Increase bloom with: `cl_bloom_scale 3.0` in BakkesMod console
- Play at night in a dark room for maximum effect

**Performance issues?**
- Lower Render Quality
- Disable Ambient Occlusion
- Set Light Quality to Low

**Want to contribute?**
If you can compile the plugin successfully with proper SDK libraries, please share your build process!

---

## Quick Reference

### BakkesMod Console Commands (with lightsout.cfg loaded):
```
lo_on          - Enable dark atmosphere
lo_off         - Disable dark atmosphere
lo_darker      - Extra dark mode
lo_lighter     - Lighter dark mode
lightsout_help - Show help
```

### Without BakkesMod:
Just disable Light Shafts in video settings - this alone makes a huge difference!
