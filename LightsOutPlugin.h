#pragma once

#include "bakkesmod/plugin/bakkesmodplugin.h"
#include "bakkesmod/plugin/pluginwindow.h"

class LightsOutPlugin : public BakkesMod::Plugin::BakkesModPlugin
{
public:
	virtual void onLoad();
	virtual void onUnload();

private:
	void EnableLightsOut();
	void DisableLightsOut();
	void ApplyLightingChanges();
	void RestoreLighting();
};
