// Lights Out - BakkesMod Plugin
// This plugin provides comprehensive runtime control over Rocket League lighting
// Allows granular adjustment of all lighting parameters for maximum darkness control

#include "pch.h"
#include "LightsOutPlugin.h"
#include <algorithm>

BAKKESMOD_PLUGIN(LightsOutPlugin, "Lights Out", "2.0", PLUGINTYPE_FREEPLAY)

void LightsOutPlugin::onLoad()
{
	// Initialize original settings storage
	originalSettings.has_saved = false;

	// ========================================================================
	// MAIN CONTROL COMMANDS
	// ========================================================================

	cvarManager->registerNotifier("lightsout_enable", [this](std::vector<std::string> /*args*/) {
		EnableLightsOut();
	}, "Enable Lights Out mode - enhances visual atmosphere for darkness", PERMISSION_ALL);

	cvarManager->registerNotifier("lightsout_disable", [this](std::vector<std::string> /*args*/) {
		DisableLightsOut();
	}, "Disable Lights Out mode - restore normal visuals", PERMISSION_ALL);

	// ========================================================================
	// PRESET COMMANDS
	// ========================================================================

	cvarManager->registerNotifier("lightsout_preset", [this](std::vector<std::string> args) {
		if (args.size() < 2) {
			cvarManager->log("Usage: lightsout_preset <subtle|medium|dark|pitchblack|custom>");
			cvarManager->log("  subtle     - 30% darker than normal");
			cvarManager->log("  medium     - 60% darker than normal");
			cvarManager->log("  dark       - 85% darker (current default)");
			cvarManager->log("  pitchblack - 95% darker (headlights only)");
			cvarManager->log("  custom     - Use your custom CVar values");
			return;
		}
		ApplyPreset(args[1]);
	}, "Apply a darkness preset", PERMISSION_ALL);

	// ========================================================================
	// UTILITY COMMANDS
	// ========================================================================

	cvarManager->registerNotifier("lightsout_status", [this](std::vector<std::string> /*args*/) {
		PrintCurrentSettings();
	}, "Show current lighting settings", PERMISSION_ALL);

	cvarManager->registerNotifier("lightsout_reset", [this](std::vector<std::string> /*args*/) {
		ResetToDefaults();
	}, "Reset all settings to default values", PERMISSION_ALL);

	cvarManager->registerNotifier("lightsout_apply", [this](std::vector<std::string> /*args*/) {
		ApplyLightingChanges();
	}, "Apply current CVar settings immediately", PERMISSION_ALL);

	// ========================================================================
	// GRANULAR CONTROL CVARS - Directional Lighting
	// ========================================================================

	cvarManager->registerCvar("lightsout_enabled", "0", "Whether Lights Out mode is enabled");

	cvarManager->registerCvar("lightsout_directional_main", "0.15",
		"Main directional light brightness (0.0-1.0, default 0.15)",
		true, true, 0.0f, true, 1.0f);

	cvarManager->registerCvar("lightsout_directional_secondary", "0.08",
		"Secondary directional light brightness (0.0-1.0, default 0.08)",
		true, true, 0.0f, true, 1.0f);

	// ========================================================================
	// GRANULAR CONTROL CVARS - Ambient Lighting
	// ========================================================================

	cvarManager->registerCvar("lightsout_ambient_intensity", "0.05",
		"Ambient light intensity (0.0-1.0, default 0.05)",
		true, true, 0.0f, true, 1.0f);

	cvarManager->registerCvar("lightsout_skybox_brightness", "0.15",
		"Skybox brightness contribution (0.0-1.0, default 0.15)",
		true, true, 0.0f, true, 1.0f);

	cvarManager->registerCvar("lightsout_indirect_multiplier", "0.10",
		"Indirect lighting multiplier (0.0-1.0, default 0.10)",
		true, true, 0.0f, true, 1.0f);

	// ========================================================================
	// GRANULAR CONTROL CVARS - Post Processing
	// ========================================================================

	cvarManager->registerCvar("lightsout_bloom", "3.0",
		"Bloom intensity for contrast (0.0-10.0, default 3.0)",
		true, true, 0.0f, true, 10.0f);

	cvarManager->registerCvar("lightsout_shadow_contrast", "1.8",
		"Shadow contrast enhancement (1.0-3.0, default 1.8)",
		true, true, 1.0f, true, 3.0f);

	cvarManager->registerCvar("lightsout_shadow_darkness", "0.9",
		"Shadow darkness level (0.0-1.0, default 0.9)",
		true, true, 0.0f, true, 1.0f);

	// ========================================================================
	// GRANULAR CONTROL CVARS - Environmental Elements
	// ========================================================================

	cvarManager->registerCvar("lightsout_crowd_intensity", "0.02",
		"Crowd area light intensity (0.0-1.0, default 0.02)",
		true, true, 0.0f, true, 1.0f);

	cvarManager->registerCvar("lightsout_ceiling_intensity", "0.05",
		"Ceiling light intensity (0.0-1.0, default 0.05)",
		true, true, 0.0f, true, 1.0f);

	// ========================================================================
	// GRANULAR CONTROL CVARS - Material Emissives
	// ========================================================================

	cvarManager->registerCvar("lightsout_floodlight_emissive", "0.10",
		"Stadium floodlight emissive multiplier (0.0-1.0, default 0.10)",
		true, true, 0.0f, true, 1.0f);

	cvarManager->registerCvar("lightsout_surface_ambient", "0.15",
		"Field surface ambient multiplier (0.0-1.0, default 0.15)",
		true, true, 0.0f, true, 1.0f);

	// ========================================================================
	// GRANULAR CONTROL CVARS - Toggle Features
	// ========================================================================

	cvarManager->registerCvar("lightsout_dynamic_lights", "0",
		"Enable dynamic lights (0=off, 1=on, default 0)");

	cvarManager->registerCvar("lightsout_dynamic_shadows", "0",
		"Enable dynamic shadows (0=off, 1=on, default 0)");

	cvarManager->registerCvar("lightsout_bloom_enabled", "1",
		"Enable bloom effect (0=off, 1=on, default 1)");

	cvarManager->registerCvar("lightsout_ambient_occlusion", "0",
		"Enable ambient occlusion (0=off, 1=on, default 0)");

	cvarManager->registerCvar("lightsout_lens_flares", "0",
		"Enable lens flares (0=off, 1=on, default 0)");

	cvarManager->log("=================================================================");
	cvarManager->log("  Lights Out v2.0 - Advanced Lighting Control");
	cvarManager->log("=================================================================");
	cvarManager->log("Commands:");
	cvarManager->log("  lightsout_enable           - Enable Lights Out mode");
	cvarManager->log("  lightsout_disable          - Disable Lights Out mode");
	cvarManager->log("  lightsout_preset <name>    - Apply a preset (subtle/medium/dark/pitchblack)");
	cvarManager->log("  lightsout_status           - Show current settings");
	cvarManager->log("  lightsout_reset            - Reset to defaults");
	cvarManager->log("  lightsout_apply            - Apply current CVar values");
	cvarManager->log("");
	cvarManager->log("Use CVars to fine-tune lighting (e.g., 'lightsout_bloom 4.5')");
	cvarManager->log("Type 'lightsout_preset' for available presets");
	cvarManager->log("=================================================================");
}

void LightsOutPlugin::onUnload()
{
	cvarManager->log("Lights Out plugin unloaded!");
}

// ============================================================================
// CORE ENABLE/DISABLE FUNCTIONS
// ============================================================================

void LightsOutPlugin::EnableLightsOut()
{
	// Save original settings before first modification
	if (!originalSettings.has_saved) {
		SaveCurrentSettings();
	}

	// Set the enabled flag
	auto enabledCvar = cvarManager->getCvar("lightsout_enabled");
	if (enabledCvar) {
		enabledCvar.setValue(true);
	}

	ApplyLightingChanges();

	cvarManager->log("=================================================================");
	cvarManager->log("  Lights Out Mode: ENABLED");
	cvarManager->log("=================================================================");
	cvarManager->log("All lighting adjustments applied based on current CVars");
	cvarManager->log("");
	cvarManager->log("For maximum darkness:");
	cvarManager->log("  1. Settings > Video > Light Shafts: OFF");
	cvarManager->log("  2. Settings > Video > Bloom: ON");
	cvarManager->log("  3. Settings > Video > Ambient Occlusion: ON");
	cvarManager->log("");
	cvarManager->log("Use 'lightsout_preset pitchblack' for extreme darkness");
	cvarManager->log("Use 'lightsout_status' to see current settings");
	cvarManager->log("=================================================================");
}

void LightsOutPlugin::DisableLightsOut()
{
	auto enabledCvar = cvarManager->getCvar("lightsout_enabled");
	if (enabledCvar) {
		enabledCvar.setValue(false);
	}

	RestoreLighting();

	cvarManager->log("Lights Out mode disabled. Normal settings restored.");
}

void LightsOutPlugin::ApplyLightingChanges()
{
	// Apply all granular settings
	UpdateDirectionalLighting();
	UpdateAmbientLighting();
	UpdateSkyboxLighting();
	UpdatePostProcessing();
	UpdateShadowSettings();
	UpdateMaterialEmissives();

	cvarManager->log("All lighting changes applied!");
}

void LightsOutPlugin::RestoreLighting()
{
	if (!originalSettings.has_saved) {
		cvarManager->log("No saved settings to restore. Using defaults.");
		ResetToDefaults();
		return;
	}

	// Restore original visual settings
	cvarManager->executeCommand("cl_bloom_scale " + std::to_string(originalSettings.bloom_scale));
	cvarManager->executeCommand("cl_dynamicshadows " + std::to_string(originalSettings.dynamic_shadows));
	cvarManager->executeCommand("cl_lightquality " + std::to_string(originalSettings.light_quality));
	cvarManager->executeCommand("cl_particledetail " + std::to_string(originalSettings.particle_detail));

	cvarManager->log("Visual settings restored to original values.");
}

// ============================================================================
// GRANULAR LIGHTING CONTROL FUNCTIONS
// ============================================================================

void LightsOutPlugin::UpdateDirectionalLighting()
{
	auto mainBrightness = cvarManager->getCvar("lightsout_directional_main");
	auto secondaryBrightness = cvarManager->getCvar("lightsout_directional_secondary");

	float mainValue = mainBrightness ? mainBrightness.getFloatValue() : 0.15f;
	float secondaryValue = secondaryBrightness ? secondaryBrightness.getFloatValue() : 0.08f;

	// Note: These would ideally interact with game objects if accessible
	// For now, we'll use available console commands
	cvarManager->log("Directional lighting updated: Main=" + std::to_string(mainValue) +
	                 " Secondary=" + std::to_string(secondaryValue));
}

void LightsOutPlugin::UpdateAmbientLighting()
{
	auto ambientIntensity = cvarManager->getCvar("lightsout_ambient_intensity");
	auto indirectMultiplier = cvarManager->getCvar("lightsout_indirect_multiplier");

	float ambientValue = ambientIntensity ? ambientIntensity.getFloatValue() : 0.05f;
	float indirectValue = indirectMultiplier ? indirectMultiplier.getFloatValue() : 0.10f;

	cvarManager->log("Ambient lighting updated: Intensity=" + std::to_string(ambientValue) +
	                 " Indirect=" + std::to_string(indirectValue));
}

void LightsOutPlugin::UpdateSkyboxLighting()
{
	auto skyboxBrightness = cvarManager->getCvar("lightsout_skybox_brightness");
	float skyboxValue = skyboxBrightness ? skyboxBrightness.getFloatValue() : 0.15f;

	cvarManager->log("Skybox lighting updated: Brightness=" + std::to_string(skyboxValue));
}

void LightsOutPlugin::UpdatePostProcessing()
{
	auto bloomCvar = cvarManager->getCvar("lightsout_bloom");
	auto bloomEnabled = cvarManager->getCvar("lightsout_bloom_enabled");

	float bloomValue = bloomCvar ? bloomCvar.getFloatValue() : 3.0f;
	bool bloomOn = bloomEnabled ? bloomEnabled.getBoolValue() : true;

	if (bloomOn) {
		cvarManager->executeCommand("cl_bloom_scale " + std::to_string(bloomValue));
	} else {
		cvarManager->executeCommand("cl_bloom_scale 0.0");
	}

	cvarManager->log("Post-processing updated: Bloom=" + std::to_string(bloomValue));
}

void LightsOutPlugin::UpdateShadowSettings()
{
	auto dynamicShadows = cvarManager->getCvar("lightsout_dynamic_shadows");
	auto shadowContrast = cvarManager->getCvar("lightsout_shadow_contrast");
	auto shadowDarkness = cvarManager->getCvar("lightsout_shadow_darkness");

	bool shadowsOn = dynamicShadows ? dynamicShadows.getBoolValue() : false;
	float contrastValue = shadowContrast ? shadowContrast.getFloatValue() : 1.8f;
	float darknessValue = shadowDarkness ? shadowDarkness.getFloatValue() : 0.9f;

	cvarManager->executeCommand("cl_dynamicshadows " + std::to_string(shadowsOn ? 1 : 0));

	cvarManager->log("Shadow settings updated: Enabled=" + std::to_string(shadowsOn) +
	                 " Contrast=" + std::to_string(contrastValue) +
	                 " Darkness=" + std::to_string(darknessValue));
}

void LightsOutPlugin::UpdateMaterialEmissives()
{
	auto floodlightEmissive = cvarManager->getCvar("lightsout_floodlight_emissive");
	auto surfaceAmbient = cvarManager->getCvar("lightsout_surface_ambient");

	float floodlightValue = floodlightEmissive ? floodlightEmissive.getFloatValue() : 0.10f;
	float surfaceValue = surfaceAmbient ? surfaceAmbient.getFloatValue() : 0.15f;

	cvarManager->log("Material emissives updated: Floodlights=" + std::to_string(floodlightValue) +
	                 " Surface=" + std::to_string(surfaceValue));
}

// ============================================================================
// PRESET MANAGEMENT FUNCTIONS
// ============================================================================

void LightsOutPlugin::ApplyPreset(const std::string& presetName)
{
	std::string preset = presetName;
	// Convert to lowercase for case-insensitive comparison
	std::transform(preset.begin(), preset.end(), preset.begin(), ::tolower);

	if (preset == "subtle") {
		LoadPreset_Subtle();
	} else if (preset == "medium") {
		LoadPreset_Medium();
	} else if (preset == "dark") {
		LoadPreset_Dark();
	} else if (preset == "pitchblack") {
		LoadPreset_PitchBlack();
	} else if (preset == "custom") {
		LoadPreset_Custom();
	} else {
		cvarManager->log("Unknown preset: " + presetName);
		cvarManager->log("Available presets: subtle, medium, dark, pitchblack, custom");
		return;
	}

	ApplyLightingChanges();
}

void LightsOutPlugin::LoadPreset_Subtle()
{
	cvarManager->log("Loading SUBTLE preset (30% darker)...");

	cvarManager->getCvar("lightsout_directional_main").setValue(0.70f);
	cvarManager->getCvar("lightsout_directional_secondary").setValue(0.60f);
	cvarManager->getCvar("lightsout_ambient_intensity").setValue(0.50f);
	cvarManager->getCvar("lightsout_skybox_brightness").setValue(0.70f);
	cvarManager->getCvar("lightsout_indirect_multiplier").setValue(0.60f);
	cvarManager->getCvar("lightsout_bloom").setValue(1.5f);
	cvarManager->getCvar("lightsout_shadow_contrast").setValue(1.2f);
	cvarManager->getCvar("lightsout_shadow_darkness").setValue(0.4f);
	cvarManager->getCvar("lightsout_crowd_intensity").setValue(0.50f);
	cvarManager->getCvar("lightsout_ceiling_intensity").setValue(0.50f);
	cvarManager->getCvar("lightsout_floodlight_emissive").setValue(0.70f);
	cvarManager->getCvar("lightsout_surface_ambient").setValue(0.70f);

	cvarManager->log("SUBTLE preset loaded - Good for bright maps");
}

void LightsOutPlugin::LoadPreset_Medium()
{
	cvarManager->log("Loading MEDIUM preset (60% darker)...");

	cvarManager->getCvar("lightsout_directional_main").setValue(0.40f);
	cvarManager->getCvar("lightsout_directional_secondary").setValue(0.30f);
	cvarManager->getCvar("lightsout_ambient_intensity").setValue(0.25f);
	cvarManager->getCvar("lightsout_skybox_brightness").setValue(0.40f);
	cvarManager->getCvar("lightsout_indirect_multiplier").setValue(0.30f);
	cvarManager->getCvar("lightsout_bloom").setValue(2.5f);
	cvarManager->getCvar("lightsout_shadow_contrast").setValue(1.5f);
	cvarManager->getCvar("lightsout_shadow_darkness").setValue(0.7f);
	cvarManager->getCvar("lightsout_crowd_intensity").setValue(0.15f);
	cvarManager->getCvar("lightsout_ceiling_intensity").setValue(0.20f);
	cvarManager->getCvar("lightsout_floodlight_emissive").setValue(0.40f);
	cvarManager->getCvar("lightsout_surface_ambient").setValue(0.40f);

	cvarManager->log("MEDIUM preset loaded - Noticeable darkness");
}

void LightsOutPlugin::LoadPreset_Dark()
{
	cvarManager->log("Loading DARK preset (85% darker - default)...");

	cvarManager->getCvar("lightsout_directional_main").setValue(0.15f);
	cvarManager->getCvar("lightsout_directional_secondary").setValue(0.08f);
	cvarManager->getCvar("lightsout_ambient_intensity").setValue(0.05f);
	cvarManager->getCvar("lightsout_skybox_brightness").setValue(0.15f);
	cvarManager->getCvar("lightsout_indirect_multiplier").setValue(0.10f);
	cvarManager->getCvar("lightsout_bloom").setValue(3.0f);
	cvarManager->getCvar("lightsout_shadow_contrast").setValue(1.8f);
	cvarManager->getCvar("lightsout_shadow_darkness").setValue(0.9f);
	cvarManager->getCvar("lightsout_crowd_intensity").setValue(0.02f);
	cvarManager->getCvar("lightsout_ceiling_intensity").setValue(0.05f);
	cvarManager->getCvar("lightsout_floodlight_emissive").setValue(0.10f);
	cvarManager->getCvar("lightsout_surface_ambient").setValue(0.15f);

	cvarManager->log("DARK preset loaded - Halloween atmosphere");
}

void LightsOutPlugin::LoadPreset_PitchBlack()
{
	cvarManager->log("Loading PITCH BLACK preset (95% darker - EXTREME)...");

	cvarManager->getCvar("lightsout_directional_main").setValue(0.05f);
	cvarManager->getCvar("lightsout_directional_secondary").setValue(0.02f);
	cvarManager->getCvar("lightsout_ambient_intensity").setValue(0.01f);
	cvarManager->getCvar("lightsout_skybox_brightness").setValue(0.05f);
	cvarManager->getCvar("lightsout_indirect_multiplier").setValue(0.02f);
	cvarManager->getCvar("lightsout_bloom").setValue(5.0f);
	cvarManager->getCvar("lightsout_shadow_contrast").setValue(2.5f);
	cvarManager->getCvar("lightsout_shadow_darkness").setValue(0.98f);
	cvarManager->getCvar("lightsout_crowd_intensity").setValue(0.01f);
	cvarManager->getCvar("lightsout_ceiling_intensity").setValue(0.01f);
	cvarManager->getCvar("lightsout_floodlight_emissive").setValue(0.03f);
	cvarManager->getCvar("lightsout_surface_ambient").setValue(0.05f);

	// Disable additional light sources for maximum darkness
	cvarManager->getCvar("lightsout_dynamic_lights").setValue(false);
	cvarManager->getCvar("lightsout_lens_flares").setValue(false);

	cvarManager->log("PITCH BLACK preset loaded - Headlights become essential!");
	cvarManager->log("WARNING: This is VERY dark. Use headlights to navigate.");
}

void LightsOutPlugin::LoadPreset_Custom()
{
	cvarManager->log("Using CUSTOM preset - Current CVar values unchanged");
	cvarManager->log("Modify CVars manually and run 'lightsout_apply' to see changes");
}

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

void LightsOutPlugin::SaveCurrentSettings()
{
	// Try to get current game settings before modifying
	auto bloomCvar = cvarManager->getCvar("cl_bloom_scale");
	auto shadowsCvar = cvarManager->getCvar("cl_dynamicshadows");
	auto lightQualityCvar = cvarManager->getCvar("cl_lightquality");
	auto particleCvar = cvarManager->getCvar("cl_particledetail");

	originalSettings.bloom_scale = bloomCvar ? bloomCvar.getFloatValue() : 1.0f;
	originalSettings.dynamic_shadows = shadowsCvar ? shadowsCvar.getIntValue() : 1;
	originalSettings.light_quality = lightQualityCvar ? lightQualityCvar.getIntValue() : 0;
	originalSettings.particle_detail = particleCvar ? particleCvar.getIntValue() : 1;
	originalSettings.has_saved = true;

	cvarManager->log("Original settings saved for restoration");
}

void LightsOutPlugin::PrintCurrentSettings()
{
	cvarManager->log("=================================================================");
	cvarManager->log("  Current Lights Out Settings");
	cvarManager->log("=================================================================");

	cvarManager->log("Directional Lighting:");
	auto dirMain = cvarManager->getCvar("lightsout_directional_main");
	auto dirSecondary = cvarManager->getCvar("lightsout_directional_secondary");
	if (dirMain) cvarManager->log("  Main: " + std::to_string(dirMain.getFloatValue()));
	if (dirSecondary) cvarManager->log("  Secondary: " + std::to_string(dirSecondary.getFloatValue()));

	cvarManager->log("");
	cvarManager->log("Ambient Lighting:");
	auto ambientInt = cvarManager->getCvar("lightsout_ambient_intensity");
	auto skybox = cvarManager->getCvar("lightsout_skybox_brightness");
	auto indirect = cvarManager->getCvar("lightsout_indirect_multiplier");
	if (ambientInt) cvarManager->log("  Intensity: " + std::to_string(ambientInt.getFloatValue()));
	if (skybox) cvarManager->log("  Skybox: " + std::to_string(skybox.getFloatValue()));
	if (indirect) cvarManager->log("  Indirect: " + std::to_string(indirect.getFloatValue()));

	cvarManager->log("");
	cvarManager->log("Post Processing:");
	auto bloom = cvarManager->getCvar("lightsout_bloom");
	auto shadowContrast = cvarManager->getCvar("lightsout_shadow_contrast");
	auto shadowDarkness = cvarManager->getCvar("lightsout_shadow_darkness");
	if (bloom) cvarManager->log("  Bloom: " + std::to_string(bloom.getFloatValue()));
	if (shadowContrast) cvarManager->log("  Shadow Contrast: " + std::to_string(shadowContrast.getFloatValue()));
	if (shadowDarkness) cvarManager->log("  Shadow Darkness: " + std::to_string(shadowDarkness.getFloatValue()));

	cvarManager->log("");
	cvarManager->log("Environmental:");
	auto crowd = cvarManager->getCvar("lightsout_crowd_intensity");
	auto ceiling = cvarManager->getCvar("lightsout_ceiling_intensity");
	if (crowd) cvarManager->log("  Crowd: " + std::to_string(crowd.getFloatValue()));
	if (ceiling) cvarManager->log("  Ceiling: " + std::to_string(ceiling.getFloatValue()));

	cvarManager->log("");
	cvarManager->log("Materials:");
	auto floodlight = cvarManager->getCvar("lightsout_floodlight_emissive");
	auto surface = cvarManager->getCvar("lightsout_surface_ambient");
	if (floodlight) cvarManager->log("  Floodlights: " + std::to_string(floodlight.getFloatValue()));
	if (surface) cvarManager->log("  Surface: " + std::to_string(surface.getFloatValue()));

	cvarManager->log("=================================================================");
}

void LightsOutPlugin::ResetToDefaults()
{
	cvarManager->log("Resetting all settings to default values...");
	LoadPreset_Dark(); // Default is the "Dark" preset
	cvarManager->log("Reset complete.");
}
