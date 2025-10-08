# How to Apply Lights Out Mod to Rocket League Free Play

## Quick Setup (Recommended Method)

### Step 1: Locate Your TASystemSettings.ini File

**Windows Path:**
```
%USERPROFILE%\Documents\My Games\Rocket League\TAGame\Config\TASystemSettings.ini
```

**Direct Path (copy-paste into File Explorer):**
```
C:\Users\[YourUsername]\Documents\My Games\Rocket League\TAGame\Config\TASystemSettings.ini
```

### Step 2: Backup Your Current Settings

1. Right-click on `TASystemSettings.ini`
2. Select "Copy"
3. Right-click in the same folder and select "Paste"
4. Rename the copy to `TASystemSettings.ini.BACKUP`

### Step 3: Apply the Lights Out Configuration

**Method A: Merge with existing file (Recommended)**

1. Open your current `TASystemSettings.ini` with Notepad or WordPad
2. Open `TASystemSettings_LightsOut.ini` from this repository
3. Copy all lines under `[SystemSettings]` from the LightsOut file
4. Paste them into your `TASystemSettings.ini` file under the `[SystemSettings]` section
5. Save and close

**Method B: Replace entire file (Simpler but may override other custom settings)**

1. Copy `TASystemSettings_LightsOut.ini` from this repository
2. Rename it to `TASystemSettings.ini`
3. Replace your existing file with this one

### Step 4: Launch Rocket League

1. Start Rocket League
2. Load into Free Play
3. The arena should now be significantly darker

---

## What This Does

The TASystemSettings.ini configuration disables:
- **Dynamic arena lights** - Stadium floodlights are no longer rendered
- **Directional lightmaps** - Prebaked arena lighting is disabled
- **Environmental shadows** - Less shadow casting from arena structures
- **Bloom effects** - Reduces bright light glow
- **Ambient occlusion** - Removes ambient light bouncing

**Important:** Car headlights, boost trails, and the ball should still be visible because they use different rendering systems that aren't affected by these settings.

---

## Troubleshooting

### The arena is still too bright
Try these additional changes in TASystemSettings.ini:

```ini
[SystemSettings]
; Add or modify these additional settings:
bAllowLightShafts=False
HighQualityLightmaps=False
UseVsync=False
```

### The arena is too dark / can't see the ball
Re-enable some lighting by changing:

```ini
DirectionalLightmaps=True  ; Re-enables some arena lighting
Bloom=True                  ; Adds glow to remaining lights
```

### Changes aren't applying
1. Make sure Rocket League is completely closed before editing the file
2. Verify you're editing the correct file location
3. Check that the file isn't set to "Read-only" (Right-click > Properties)
4. Make sure you're editing under the `[SystemSettings]` section

### Performance issues
These settings should actually **improve** performance since they disable resource-intensive lighting calculations. If you experience issues, verify your GPU drivers are up to date.

---

## Reverting Changes

To restore original lighting:

1. Delete your modified `TASystemSettings.ini`
2. Rename `TASystemSettings.ini.BACKUP` to `TASystemSettings.ini`
3. Restart Rocket League

Or simply verify game files through Steam/Epic Games Launcher to restore defaults.

---

## Alternative: BakkesMod Method (Advanced)

If you want to toggle lighting on/off without editing files:

### Using BakkesMod Console Commands

1. Install [BakkesMod](https://bakkesmod.com/)
2. Press F6 in-game to open the console
3. Try these experimental commands:
   ```
   cl_rendering_disabled 0
   cl_dynamicshadows 0
   ```

**Note:** BakkesMod has limited lighting control. The TASystemSettings.ini method is more reliable.

---

## Known Limitations

- **Not all arenas support lighting reduction equally** - Some maps have baked-in brightness
- **Online play compatibility** - These are client-side visual changes only
- **Replays** - Lighting changes may not apply to replays
- **Custom maps** - Workshop maps may override these settings

---

## Testing Checklist

After applying changes, verify in Free Play:
- [ ] Arena is noticeably darker
- [ ] Ball is still clearly visible
- [ ] Boost pads are visible
- [ ] Goals are identifiable
- [ ] No performance stuttering
- [ ] Car controls feel normal

---

## Best Arenas for Lights Out Effect

Try Free Play on these maps for the best dark atmosphere:
- **DFH Stadium (Night)** - Already dark, becomes very atmospheric
- **Urban Central (Night)** - Excellent for testing headlight visibility
- **Beckwith Park (Midnight)** - Natural dark setting
- **Farmstead (Night)** - Minimal ambient light

Avoid day arenas initially as they have strong skybox lighting that's harder to override.

---

## Additional Tips

1. **Experiment with brightness settings** - Different monitors may need different values
2. **Use game mode on your monitor** - Can enhance dark scenes
3. **Adjust in-game video settings** - Set quality to "Performance" for better FPS with these changes
4. **Car selection matters** - Some cars have brighter headlights/boost effects than others

---

## Need Help?

If you encounter issues or the lighting isn't changing:
1. Verify you're editing the correct TASystemSettings.ini file
2. Check that Rocket League has file write permissions
3. Try deleting the .ini file and letting the game regenerate it, then reapply changes
4. Join the Rocket League modding community for additional support
