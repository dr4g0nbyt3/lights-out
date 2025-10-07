// Lights Out - BakkesMod Plugin
// This plugin reduces arena lighting in Rocket League for a spooky atmosphere

#include "pch.h"
#include "LightsOutPlugin.h"

BAKKESMOD_PLUGIN(LightsOutPlugin, "Lights Out", "1.0", PLUGINTYPE_FREEPLAY)

void LightsOutPlugin::onLoad()
{
	cvarManager->registerNotifier("lightsout_enable", [this](std::vector<std::string> args) {
		EnableLightsOut();
	}, "Enable Lights Out mode", PERMISSION_ALL);

	cvarManager->registerNotifier("lightsout_disable", [this](std::vector<std::string> args) {
		DisableLightsOut();
	}, "Disable Lights Out mode", PERMISSION_ALL);

	cvarManager->registerCvar("lightsout_brightness", "0.15", "Arena light brightness multiplier (0.0-1.0)", true, true, 0.0f, true, 1.0f);
	cvarManager->registerCvar("lightsout_ambient", "0.05", "Ambient light intensity (0.0-1.0)", true, true, 0.0f, true, 1.0f);

	gameWrapper->HookEvent("Function TAGame.GameEvent_Soccar_TA.InitGame", [this](std::string eventName) {
		if (cvarManager->getCvar("lightsout_enabled").getBoolValue()) {
			ApplyLightingChanges();
		}
	});

	LOG("Lights Out plugin loaded!");
}

void LightsOutPlugin::onUnload()
{
	LOG("Lights Out plugin unloaded!");
}

void LightsOutPlugin::EnableLightsOut()
{
	cvarManager->getCvar("lightsout_enabled").setValue(true);
	ApplyLightingChanges();
	LOG("Lights Out enabled!");
}

void LightsOutPlugin::DisableLightsOut()
{
	cvarManager->getCvar("lightsout_enabled").setValue(false);
	RestoreLighting();
	LOG("Lights Out disabled!");
}

void LightsOutPlugin::ApplyLightingChanges()
{
	ServerWrapper server = gameWrapper->GetCurrentGameState();
	if (!server) return;

	float brightness = cvarManager->getCvar("lightsout_brightness").getFloatValue();
	float ambient = cvarManager->getCvar("lightsout_ambient").getFloatValue();

	// Get all DirectionalLights in the level
	auto lights = server.GetDirectionalLights();
	for (auto light : lights) {
		if (!light.IsNull()) {
			// Reduce brightness dramatically
			light.SetBrightness(brightness);

			// Adjust light colors for spooky atmosphere
			LinearColor color = light.GetLightColor();
			color.R *= 0.15f;
			color.G *= 0.15f;
			color.B *= 0.20f; // Slightly more blue for eerie effect
			light.SetLightColor(color);
		}
	}

	// Reduce ambient lighting
	// Note: This requires access to the WorldInfo which may vary by BakkesMod version
	LOG("Lighting changes applied!");
}

void LightsOutPlugin::RestoreLighting()
{
	ServerWrapper server = gameWrapper->GetCurrentGameState();
	if (!server) return;

	// Restore original lighting
	auto lights = server.GetDirectionalLights();
	for (auto light : lights) {
		if (!light.IsNull()) {
			light.SetBrightness(1.0f);

			LinearColor color;
			color.R = 1.0f;
			color.G = 1.0f;
			color.B = 1.0f;
			color.A = 1.0f;
			light.SetLightColor(color);
		}
	}

	LOG("Lighting restored to normal!");
}
