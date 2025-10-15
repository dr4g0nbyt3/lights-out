#pragma once

#include "bakkesmod/plugin/bakkesmodplugin.h"

class LightsOutPlugin : public BakkesMod::Plugin::BakkesModPlugin
{
public:
	virtual void onLoad();
	virtual void onUnload();

private:
	// Core enable/disable functions
	void EnableLightsOut();
	void DisableLightsOut();
	void ApplyLightingChanges();
	void RestoreLighting();

	// Granular lighting control functions
	void UpdateDirectionalLighting();
	void UpdateAmbientLighting();
	void UpdateSkyboxLighting();
	void UpdatePostProcessing();
	void UpdateShadowSettings();
	void UpdateMaterialEmissives();

	// Preset management
	void ApplyPreset(const std::string& presetName);
	void LoadPreset_Subtle();
	void LoadPreset_Medium();
	void LoadPreset_Dark();
	void LoadPreset_PitchBlack();
	void LoadPreset_Custom();

	// Utility functions
	void SaveCurrentSettings();
	void PrintCurrentSettings();
	void ResetToDefaults();

	// Store original values for restoration
	struct OriginalSettings {
		float bloom_scale;
		int dynamic_shadows;
		int light_quality;
		int particle_detail;
		bool has_saved;
	} originalSettings;
};
