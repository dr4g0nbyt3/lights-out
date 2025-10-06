# Lights Out - Rocket League Halloween Mod

Transform Rocket League into a spooky Halloween experience with dramatically reduced arena lighting while maintaining essential gameplay visibility through headlights and boost effects.

## Features

### Atmospheric Changes
- **Arena lighting reduced by 85-90%** - Stadium floodlights dimmed to create a dark, eerie environment
- **Enhanced shadows and contrast** - Deeper shadows with improved definition for maximum spookiness
- **Darkened skybox and crowd areas** - Complete environmental transformation
- **Halloween atmosphere** - Volumetric fog with subtle purple tint

### Preserved Gameplay Elements
✅ **Car headlights at 100% intensity** - Your primary light source
✅ **All boost effects fully illuminated** - Trails, flames, and pickup pads
✅ **Ball visibility maintained** - Enhanced ambient lighting on the ball
✅ **Goal recognition** - Goal posts remain illuminated for orientation
✅ **Player nameplates** - Full visibility preserved
✅ **Competitive balance** - No gameplay advantages or disadvantages

## Installation

### Requirements
- Rocket League (Steam version recommended)
- BakkesMod (optional, for easier mod management)

### Manual Installation

1. **Locate your Rocket League directory:**
   ```
   Documents\My Games\Rocket League\TAGame\CookedPCConsole
   ```

2. **Backup original files** (recommended):
   - Create a backup folder and copy any existing lighting configuration files

3. **Install the mod:**
   - Copy `LightsOut.upk` to the `CookedPCConsole` folder
   - Copy `LightsOut_MaterialOverrides.ini` to the same folder

4. **Launch Rocket League** and enjoy the spooky atmosphere!

### BakkesMod Installation (Alternative)

1. Install [BakkesMod](https://bakkesmod.com/)
2. Place mod files in: `%APPDATA%\bakkesmod\bakkesmod\data\`
3. Load the mod through BakkesMod's plugin menu

## Technical Details

### Lighting Configuration

**Arena Lighting:**
- Main directional light: 15% brightness (was 100%)
- Secondary upward light: 8% brightness
- Ambient lighting: 5% intensity
- Crowd area lighting: 2% intensity

**Preserved at 100%:**
- Car headlights (full brightness, range, and shadow casting)
- Boost trails (particles, glow, and light radius)
- Boost pads (glow intensity and pulse animation)
- Boost flames (dynamic lighting and shadows)

**Visibility Safeguards:**
- Ball ambient light: 40%
- Ball self-illumination: 20%
- Goal post lighting: 100%
- Field boundaries: 30% visibility

### Performance Impact

This mod actually **improves performance** on most systems by:
- Reducing the number of active light sources
- Optimizing lightmap calculations
- Disabling unnecessary ambient lighting

Expected FPS improvement: 5-15% on mid-range systems

## Customization

### Adjusting Darkness Level

Edit `LightsOut.upk` and modify these values:

```ini
[ArenaLighting]
DirectionalLight_Main_Brightness=0.15    ; Range: 0.10-0.30
AmbientLight_Intensity=0.05              ; Range: 0.03-0.10
```

- **Lower values** = Darker (more challenging)
- **Higher values** = Brighter (easier to see)

### Fog Density

```ini
[AtmosphericEffects]
VolumetricFog_Density=0.15    ; Range: 0.05-0.30
```

### Headlight Brightness

**⚠️ Not recommended to change, but possible:**

```ini
[CarHeadlights]
Headlight_Brightness=1.0    ; Keep at 1.0 for best experience
Headlight_Range=3000.0      ; Increase for wider light cone
```

## Gameplay Tips

1. **Use headlights strategically** - Your car orientation now affects visibility
2. **Boost management** - Boost trails create additional light, plan accordingly
3. **Team coordination** - Stay closer to teammates to share lighting
4. **Positioning awareness** - Learn to play with limited vision
5. **Goal orientation** - Use illuminated goal posts as reference points

## Troubleshooting

### Mod not loading
- Verify files are in the correct directory
- Ensure Rocket League is fully closed before installing
- Check file permissions (should not be read-only)

### Too dark to play
- Adjust `DirectionalLight_Main_Brightness` to 0.20 or 0.25
- Increase `AmbientLight_Intensity` to 0.08
- Reduce `VolumetricFog_Density` to 0.10

### Performance issues
- Lower `ShadowQuality` from `High` to `Medium`
- Disable `VolumetricFog_Enabled`
- Set `DynamicShadows_Enabled=False`

### Headlights not working
- Verify your car has headlights enabled in customization
- Some car bodies don't have visible headlights
- Try a different car (Octane, Dominus recommended)

## Compatibility

### Compatible With:
✅ Custom car skins and decals
✅ Boost effect mods
✅ Audio mods
✅ HUD mods
✅ BakkesMod plugins

### May Conflict With:
⚠️ Other lighting mods
⚠️ Arena/map retexture mods
⚠️ Visual overhaul mods

## Uninstallation

1. Navigate to `Documents\My Games\Rocket League\TAGame\CookedPCConsole`
2. Delete `LightsOut.upk` and `LightsOut_MaterialOverrides.ini`
3. Restore backup files if you created them
4. Restart Rocket League

## Testing Checklist

Before playing competitively, verify:
- [ ] Headlights illuminate properly
- [ ] Boost trails are fully visible
- [ ] Ball is clearly trackable
- [ ] Goals are identifiable
- [ ] Nameplates are readable
- [ ] No performance stuttering

## Version History

### v1.0.0 (Current)
- Initial release
- 85% arena lighting reduction
- Full headlight and boost preservation
- Halloween atmospheric effects
- Performance optimizations

## Credits

**Developed by:** Halloween Mod Team
**Engine:** UDK (Unreal Development Kit)
**Game:** Rocket League by Psyonix

## Legal

This is an unofficial mod. Rocket League is a registered trademark of Psyonix LLC.
Use at your own risk. Always follow Psyonix's terms of service regarding mods.

## Support

For issues, questions, or suggestions:
- Create an issue in the repository
- Join the Rocket League modding community
- Visit [rocketleaguemods.com](https://videogamemods.com/rocketleague/)

---

**Enjoy the spooky atmosphere and Happy Halloween! 🎃**
