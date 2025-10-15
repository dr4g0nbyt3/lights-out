# Lights Out Plugin - Detailed Usage Instructions

## ⚠️ CRITICAL: Plugin Activation Requirements

### Required Game Mode
**The Lights Out plugin ONLY works in FREEPLAY mode.**

The plugin is programmed with `PLUGINTYPE_FREEPLAY` restriction (line 7 in LightsOutPlugin.cpp), which means:

- ✅ **WORKS:** Freeplay/Training modes
- ❌ **DOES NOT WORK:** Online matches, private matches, exhibition matches, main menu

### Complete Checklist for Plugin to Take Effect

Before the Lights Out plugin will activate, ALL of the following conditions must be met:

#### 1. **Installation Requirements**
- [ ] BakkesMod is installed and running
- [ ] `LightsOut.dll` is located in `%APPDATA%\bakkesmod\bakkesmod\plugins\`
- [ ] Plugin is loaded (check with `plugin list` command in BakkesMod console)

#### 2. **Game State Requirements**
- [ ] You must be IN a Freeplay session (not in main menu, not in any match type)
- [ ] The game must be fully loaded (not in loading screen)
- [ ] You must be actively controlling your car

#### 3. **Plugin Activation**
- [ ] Open BakkesMod console (press **F6**)
- [ ] Type: `lightsout_enable`
- [ ] Press Enter
- [ ] Look for confirmation message: "Lights Out Mode: ENABLED"

#### 4. **Recommended Video Settings** (for maximum effect)
- [ ] Settings → Video → **Light Shafts: OFF**
- [ ] Settings → Video → **Bloom: ON**
- [ ] Settings → Video → **Ambient Occlusion: ON**
- [ ] Settings → Video → **Render Quality: High Quality or Performance**

---

## Step-by-Step Activation Process

### First-Time Setup

**Step 1: Install the Plugin**
1. Download or compile `LightsOut.dll`
2. Press `Win + R` on your keyboard
3. Type: `%APPDATA%\bakkesmod\bakkesmod\plugins\`
4. Press Enter
5. Copy `LightsOut.dll` into this folder
6. Launch Rocket League

**Step 2: Verify Plugin Loaded**
1. In Rocket League, press **F6** to open BakkesMod console
2. Type: `plugin list`
3. Verify "Lights Out" appears in the list
4. If not listed, type: `plugin load lightsout`

**Step 3: Configure Video Settings**
1. Main Menu → Settings → Video
2. Set the following:
   - **Light Shafts:** OFF (most important!)
   - **Bloom:** ON
   - **Ambient Occlusion:** ON
   - **Lens Flares:** OFF (optional, reduces glare)
   - **Dynamic Shadows:** ON (helps with contrast)

### Every Session Activation

**Each time you want to use Lights Out:**

1. Launch Rocket League (BakkesMod should auto-start)

2. Navigate to: **Play → Training → Free Play**

3. Wait for freeplay session to fully load (you see your car on the field)

4. Press **F6** to open BakkesMod console

5. Type: `lightsout_enable`

6. Press **Enter**

7. You should see:
   ```
   =================================
     Lights Out Mode: ENABLED
   =================================
   Bloom enhanced for better contrast

   For maximum darkness:
   1. Settings > Video > Light Shafts: OFF
   2. Settings > Video > Bloom: ON
   3. Settings > Video > Ambient Occlusion: ON
   ```

8. Close the console (press **F6** again)

9. The visual changes should now be active!

---

## Conditions That Must Be Met

### ✅ Plugin WILL Work When:
- You are in **Freeplay mode**
- Plugin is properly loaded via BakkesMod
- You have executed `lightsout_enable` command
- Game is not minimized or in loading screen
- BakkesMod is running in the background

### ❌ Plugin WILL NOT Work When:
- You are in **online matches** (Casual, Competitive, Tournaments)
- You are in **private matches** or **exhibition matches**
- You are in **training packs** (some may work, some may not)
- You are in the **main menu** or **garage**
- BakkesMod is not running
- Plugin has not been enabled with the command
- Game mode restriction prevents activation

### 🔧 Visual Effect Conditions

The plugin modifies these visual settings:
- **Bloom intensity:** Increased to 3.0× (adjustable with `lightsout_bloom` cvar)
- **Dynamic shadows:** Enabled for better contrast
- **Light quality:** Enhanced for visual depth
- **Particle detail:** Increased for visible boost effects

These changes are **temporary** and only apply while:
- Lights Out mode is enabled
- You remain in the freeplay session
- The plugin remains loaded

---

## Customization Options

### Adjust Bloom Intensity
Default is 3.0, but you can customize:

```
lightsout_bloom 2.5   // Subtle enhancement
lightsout_bloom 3.0   // Default (recommended)
lightsout_bloom 4.0   // Maximum glow effect
```

Then re-apply with: `lightsout_enable`

### Check Current Status
```
lightsout_enabled   // Check if mode is active (1 = on, 0 = off)
```

### Disable Lights Out
```
lightsout_disable   // Restore normal visuals
```

---

## Troubleshooting

### "Nothing happens when I type lightsout_enable"

**Problem:** Plugin not loaded or wrong game mode

**Solutions:**
1. Verify you're in Freeplay mode (not any other mode)
2. Check plugin is loaded: `plugin list`
3. If not loaded, type: `plugin load lightsout`
4. Try typing the command again: `lightsout_enable`

### "Command not found"

**Problem:** Plugin DLL is not in the correct location

**Solutions:**
1. Press `Win + R`, type: `%APPDATA%\bakkesmod\bakkesmod\plugins\`
2. Verify `LightsOut.dll` exists in this folder
3. Restart Rocket League
4. Load plugin manually: `plugin load lightsout`

### "Visuals don't look different"

**Problem:** Video settings or plugin settings conflict

**Solutions:**
1. Ensure Light Shafts are **OFF** in video settings (critical!)
2. Enable Bloom in video settings
3. Exit and re-enter Freeplay mode
4. Try disabling and re-enabling:
   ```
   lightsout_disable
   lightsout_enable
   ```

### "Plugin worked before but stopped working"

**Problem:** Game mode changed or plugin unloaded

**Solutions:**
1. Make sure you're still in Freeplay mode
2. Check if plugin is still loaded: `plugin list`
3. Reload if needed: `plugin load lightsout`
4. Re-enable: `lightsout_enable`

### "Game performance is worse"

**Problem:** Enhanced visual settings use more GPU

**Solutions:**
1. Lower other video settings (Render Quality, Anti-Aliasing)
2. Reduce bloom intensity: `lightsout_bloom 1.5`
3. Disable Ambient Occlusion if needed
4. Use `lightsout_disable` if performance is critical

---

## Auto-Enable Feature (Optional)

To automatically enable Lights Out whenever you enter Freeplay:

**Step 1:** Navigate to BakkesMod config folder
```
%APPDATA%\bakkesmod\bakkesmod\cfg\
```

**Step 2:** Create or edit `autoexec.cfg`

**Step 3:** Add these lines:
```
plugin load lightsout
// lightsout_enable will auto-run when entering freeplay
```

**Note:** Due to the `PLUGINTYPE_FREEPLAY` restriction, the plugin will only activate when you're in the correct game mode, so auto-enabling is safe.

---

## Technical Notes

### Plugin Permissions
- **Permission Level:** `PERMISSION_ALL` (LightsOutPlugin.cpp:13, 17)
- **Plugin Type:** `PLUGINTYPE_FREEPLAY` (LightsOutPlugin.cpp:7)
- **Effect:** Plugin only registers and executes in Freeplay mode

### Visual Settings Modified
From `ApplyLightingChanges()` function (LightsOutPlugin.cpp:65-78):

| Setting | Console Command | Value |
|---------|----------------|-------|
| Bloom Scale | `cl_bloom_scale` | 3.0 (configurable) |
| Dynamic Shadows | `cl_dynamicshadows` | 1 (enabled) |
| Light Quality | `cl_lightquality` | 1 (high) |
| Particle Detail | `cl_particledetail` | 2 (high) |

### Restored Settings
From `RestoreLighting()` function (LightsOutPlugin.cpp:80-89):

| Setting | Restored Value |
|---------|----------------|
| Bloom Scale | 1.0 (default) |
| Dynamic Shadows | 1 (enabled) |
| Light Quality | 0 (normal) |
| Particle Detail | 1 (normal) |

---

## FAQ

**Q: Can I use this in online matches?**
**A:** No, the plugin is hard-coded to only work in Freeplay mode (PLUGINTYPE_FREEPLAY restriction).

**Q: Will this give me an advantage?**
**A:** No, because it only works in Freeplay (training), not in competitive modes.

**Q: Can I modify the plugin to work in online matches?**
**A:** Technically yes by changing the plugin type, but this may violate Psyonix TOS and could result in a ban. Not recommended.

**Q: Does this work with other BakkesMod plugins?**
**A:** Yes, this plugin is compatible with most other BakkesMod plugins as it only modifies visual CVars.

**Q: What if I want darker/lighter visuals?**
**A:** Adjust the bloom value: `lightsout_bloom X` (where X is 0.5-5.0)

**Q: Can I bind this to a key?**
**A:** Yes! Add to your BakkesMod config:
```
bind F9 "lightsout_enable"
bind F10 "lightsout_disable"
```

---

## Summary Checklist

Before expecting Lights Out to work, verify:

- [x] **Game Mode:** Must be in Freeplay
- [x] **BakkesMod:** Running and injected into game
- [x] **Plugin:** DLL in plugins folder and loaded
- [x] **Command:** `lightsout_enable` executed
- [x] **Video Settings:** Light Shafts OFF, Bloom ON
- [x] **Session:** Fully loaded into freeplay (not loading screen)

If all boxes are checked and it still doesn't work, check the BakkesMod console for error messages and review the Troubleshooting section.

---

**Note:** This plugin modifies visual presentation only and does not alter gameplay mechanics, physics, or network traffic. It is safe to use in Freeplay mode without risk to your account.
