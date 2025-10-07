// Lights Out - BakkesMod Plugin
// This plugin provides commands to adjust visual settings for a darker atmosphere

#include "pch.h"
#include "LightsOutPlugin.h"

BAKKESMOD_PLUGIN(LightsOutPlugin, "Lights Out", "1.0", PLUGINTYPE_FREEPLAY)

void LightsOutPlugin::onLoad()
{
	cvarManager->registerNotifier("lightsout_enable", [this](std::vector<std::string> /*args*/) {
		EnableLightsOut();
	}, "Enable Lights Out mode - enhances visual atmosphere for darkness", PERMISSION_ALL);

	cvarManager->registerNotifier("lightsout_disable", [this](std::vector<std::string> /*args*/) {
		DisableLightsOut();
	}, "Disable Lights Out mode - restore normal visuals", PERMISSION_ALL);

	// Register CVars for settings
	cvarManager->registerCvar("lightsout_enabled", "0", "Whether Lights Out mode is enabled");
	cvarManager->registerCvar("lightsout_bloom", "3.0", "Bloom intensity for Lights Out mode", true, true, 0.0f, true, 5.0f);

	cvarManager->log("Lights Out plugin loaded! Use 'lightsout_enable' to activate.");
	cvarManager->log("Note: For best effect, disable Light Shafts in Video Settings.");
}

void LightsOutPlugin::onUnload()
{
	cvarManager->log("Lights Out plugin unloaded!");
}

void LightsOutPlugin::EnableLightsOut()
{
	// Set the enabled flag
	auto enabledCvar = cvarManager->getCvar("lightsout_enabled");
	if (enabledCvar) {
		enabledCvar.setValue(true);
	}

	ApplyLightingChanges();

	cvarManager->log("=================================");
	cvarManager->log("  Lights Out Mode: ENABLED");
	cvarManager->log("=================================");
	cvarManager->log("Bloom enhanced for better contrast");
	cvarManager->log("");
	cvarManager->log("For maximum darkness:");
	cvarManager->log("1. Settings > Video > Light Shafts: OFF");
	cvarManager->log("2. Settings > Video > Bloom: ON");
	cvarManager->log("3. Settings > Video > Ambient Occlusion: ON");
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
	// Get bloom setting
	auto bloomCvar = cvarManager->getCvar("lightsout_bloom");
	float bloomValue = bloomCvar ? bloomCvar.getFloatValue() : 3.0f;

	// Apply visual enhancement settings via console commands
	cvarManager->executeCommand("cl_bloom_scale " + std::to_string(bloomValue));
	cvarManager->executeCommand("cl_dynamicshadows 1");
	cvarManager->executeCommand("cl_lightquality 1");
	cvarManager->executeCommand("cl_particledetail 2");

	cvarManager->log("Visual enhancements applied!");
}

void LightsOutPlugin::RestoreLighting()
{
	// Restore default visual settings
	cvarManager->executeCommand("cl_bloom_scale 1.0");
	cvarManager->executeCommand("cl_dynamicshadows 1");
	cvarManager->executeCommand("cl_lightquality 0");
	cvarManager->executeCommand("cl_particledetail 1");

	cvarManager->log("Visual settings restored to defaults.");
}
