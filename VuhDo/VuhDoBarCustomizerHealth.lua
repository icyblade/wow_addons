
local VUHDO_NAME_TEXTS = { };


-- BURST CACHE ---------------------------------------------------

local VUHDO_getHealthBar;
local VUHDO_getBarText;
local VUHDO_getIncHealOnUnit;
local VUHDO_getDiffColor;
local VUHDO_isPanelVisible;
local VUHDO_updateManaBars;
local VUHDO_updateAllHoTs;
local VUHDO_removeAllHots;
local VUHDO_getUnitHealthPercent;
local VUHDO_getPanelButtons;
local VUHDO_updateBouquetsForEvent;
local VUHDO_utf8Cut;
local VUHDO_resolveVehicleUnit;
local VUHDO_getOverhealPanel;
local VUHDO_getOverhealText;
local VUHDO_getUnitButtons;
local VUHDO_getBarRoleIcon;
local VUHDO_getBarIconFrame;
local VUHDO_updateClusterHighlights;
local VUHDO_customizeTargetBar;
local VUHDO_getColoredString;
local VUHDO_textColor;

local VUHDO_PANEL_SETUP;
local VUHDO_BUTTON_CACHE;
local VUHDO_RAID;
local VUHDO_CONFIG;
local VUHDO_INDICATOR_CONFIG;
local VUHDO_BAR_COLOR;
local VUHDO_THREAT_CFG;
local VUHDO_IN_RAID_TARGET_BUTTONS;
local VUHDO_INTERNAL_TOGGLES;

local abs = abs;
local floor = floor;
local strlen = strlen;
local strfind = strfind;
local strbyte = strbyte;
local GetRaidTargetIndex = GetRaidTargetIndex;
local UnitIsUnit = UnitIsUnit;
local pairs = pairs;
local twipe = table.wipe;
local format = format;
local _ = _;
local UIFrameFlash = UIFrameFlash;
local sIsOverhealText;
local sIsAggroText;
local sIsInvertGrowth;
local sLifeColor;


function VUHDO_customHealthInitBurst()
	VUHDO_PANEL_SETUP = VUHDO_GLOBAL["VUHDO_PANEL_SETUP"];
	VUHDO_BUTTON_CACHE = VUHDO_GLOBAL["VUHDO_BUTTON_CACHE"];
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];
	VUHDO_CONFIG = VUHDO_GLOBAL["VUHDO_CONFIG"];
	VUHDO_INDICATOR_CONFIG = VUHDO_GLOBAL["VUHDO_INDICATOR_CONFIG"];
	VUHDO_getUnitButtons = VUHDO_GLOBAL["VUHDO_getUnitButtons"];
 	VUHDO_BAR_COLOR = VUHDO_PANEL_SETUP["BAR_COLORS"];
 	VUHDO_THREAT_CFG = VUHDO_CONFIG["THREAT"];
 	VUHDO_IN_RAID_TARGET_BUTTONS = VUHDO_GLOBAL["VUHDO_IN_RAID_TARGET_BUTTONS"];
	VUHDO_INTERNAL_TOGGLES = VUHDO_GLOBAL["VUHDO_INTERNAL_TOGGLES"];

	VUHDO_getHealthBar = VUHDO_GLOBAL["VUHDO_getHealthBar"];
	VUHDO_getBarText = VUHDO_GLOBAL["VUHDO_getBarText"];
	VUHDO_getIncHealOnUnit = VUHDO_GLOBAL["VUHDO_getIncHealOnUnit"];
	VUHDO_getDiffColor = VUHDO_GLOBAL["VUHDO_getDiffColor"];
	VUHDO_isPanelVisible = VUHDO_GLOBAL["VUHDO_isPanelVisible"];
	VUHDO_updateManaBars = VUHDO_GLOBAL["VUHDO_updateManaBars"];
	VUHDO_removeAllHots = VUHDO_GLOBAL["VUHDO_removeAllHots"];
	VUHDO_updateAllHoTs = VUHDO_GLOBAL["VUHDO_updateAllHoTs"];
	VUHDO_getUnitHealthPercent = VUHDO_GLOBAL["VUHDO_getUnitHealthPercent"];
	VUHDO_getPanelButtons = VUHDO_GLOBAL["VUHDO_getPanelButtons"];
	VUHDO_updateBouquetsForEvent = VUHDO_GLOBAL["VUHDO_updateBouquetsForEvent"];
	VUHDO_utf8Cut = VUHDO_GLOBAL["VUHDO_utf8Cut"];
	VUHDO_resolveVehicleUnit = VUHDO_GLOBAL["VUHDO_resolveVehicleUnit"];
	VUHDO_getOverhealPanel = VUHDO_GLOBAL["VUHDO_getOverhealPanel"];
	VUHDO_getOverhealText = VUHDO_GLOBAL["VUHDO_getOverhealText"];
	VUHDO_getBarRoleIcon = VUHDO_GLOBAL["VUHDO_getBarRoleIcon"];
	VUHDO_getBarIconFrame = VUHDO_GLOBAL["VUHDO_getBarIconFrame"];
  VUHDO_updateClusterHighlights = VUHDO_GLOBAL["VUHDO_updateClusterHighlights"];
	VUHDO_customizeTargetBar = VUHDO_GLOBAL["VUHDO_customizeTargetBar"];
	VUHDO_getColoredString = VUHDO_GLOBAL["VUHDO_getColoredString"];
	VUHDO_textColor = VUHDO_GLOBAL["VUHDO_textColor"];

	sIsOverhealText = VUHDO_CONFIG["SHOW_TEXT_OVERHEAL"]
	sIsAggroText = VUHDO_CONFIG["THREAT"]["AGGRO_USE_TEXT"];
	sIsInvertGrowth = VUHDO_INDICATOR_CONFIG["CUSTOM"]["HEALTH_BAR"]["invertGrowth"];
	sLifeColor = VUHDO_PANEL_SETUP["PANEL_COLOR"]["HEALTH_TEXT"];

	twipe(VUHDO_NAME_TEXTS);
end

----------------------------------------------------


function VUHDO_resetNameTextCache()
	twipe(VUHDO_NAME_TEXTS);
end



local tIncColor = { ["useBackground"] = true };



--
local function VUHDO_getUnitHealthModiPercent(anInfo, aModifier)
	return anInfo["healthmax"] == 0 and 0
		or (anInfo["health"] + aModifier) / anInfo["healthmax"];
end



--
local tOpacity;
local function VUHDO_setStatusBarColor(aBar, aColor)
	tOpacity = aColor["useOpacity"] and aColor["O"] or nil;

	if (aColor["useBackground"]) then
		aBar:SetStatusBarColor(aColor["R"], aColor["G"], aColor["B"], tOpacity);
	elseif (tOpacity ~= nil) then
		aBar:SetAlpha(tOpacity);
	end
end



--
local function VUHDO_getKiloText(aNumber, aMaxNumber, aSetup)
	return aSetup["LIFE_TEXT"]["verbose"] and aNumber
	  or aMaxNumber > 100000 and format("%.0fk", aNumber * 0.001)
		or aMaxNumber > 10000 and format("%.1fk", aNumber * 0.001)
		or aNumber;
end



--
local tOverheal;
local tRatio;
local tAllButtons;
local tHealthPlusInc;
local tIncBar;
local tButton;
local tAmountInc;
local tInfo;
local tOverhealSetup;
local tValue;
local tOpacity;
local function VUHDO_updateIncHeal(aUnit)
	tInfo = VUHDO_RAID[aUnit];
	tAllButtons = VUHDO_getUnitButtons(VUHDO_resolveVehicleUnit(aUnit));

	if (tInfo == nil or tAllButtons == nil) then
		return;
	end

	tAmountInc = VUHDO_getIncHealOnUnit(aUnit);

	if (tAmountInc > 0 and tInfo["connected"] and not tInfo["dead"]) then
		tHealthPlusInc = VUHDO_getUnitHealthModiPercent(tInfo, tAmountInc);
		if (tHealthPlusInc > 1) then
			tHealthPlusInc = 1;
		end
	else
		tAmountInc = 0;
		tHealthPlusInc = 0;
	end

	if (tAmountInc > 0) then

  	for _, tButton in pairs(tAllButtons) do
    	tIncBar = VUHDO_getHealthBar(tButton, 6);

			if (sIsInvertGrowth and tInfo["healthmax"] > 0) then
				tIncBar:SetValueRange(tInfo["health"] / tInfo["healthmax"], tHealthPlusInc);
			else
  			tIncBar:SetValue(tHealthPlusInc);
  		end

 			tIncColor["R"], tIncColor["G"], tIncColor["B"], tOpacity = VUHDO_getHealthBar(tButton, 1):GetStatusBarColor();
 			tIncColor = VUHDO_getDiffColor(tIncColor, VUHDO_PANEL_SETUP["BAR_COLORS"]["INCOMING"]);
 			if (tIncColor["O"] ~= nil and tOpacity ~= nil) then
 				tIncColor["O"] = tIncColor["O"] * tOpacity;
 			end

    	VUHDO_setStatusBarColor(tIncBar, tIncColor);
    	tOverhealSetup = VUHDO_PANEL_SETUP[VUHDO_BUTTON_CACHE[tButton]]["OVERHEAL_TEXT"];

    	if (tOverhealSetup["show"]) then
				tOverheal = tAmountInc - tInfo["healthmax"] + tInfo["health"];

  	  	if (tOverheal > 0 and tInfo["healthmax"] > 0) then
					tRatio = tOverheal / tInfo["healthmax"];
    			if (tRatio < 1) then
    				VUHDO_getOverhealPanel(VUHDO_getHealthBar(tButton, 1)):SetScale((0.5 + tRatio) * tOverhealSetup["scale"]);
    			else
	    			VUHDO_getOverhealPanel(VUHDO_getHealthBar(tButton, 1)):SetScale(1.5 * tOverhealSetup["scale"]);
  	  		end

					VUHDO_getOverhealText(VUHDO_getHealthBar(tButton, 1)):SetText(format("+%.1fk", tOverheal * 0.001));
				else
					VUHDO_getOverhealText(VUHDO_getHealthBar(tButton, 1)):SetText("");
				end
  		end
  	end

	else
		for _, tButton in pairs(tAllButtons) do
			if (sIsInvertGrowth) then
				VUHDO_getHealthBar(tButton, 6):SetValueRange(0, 0);
			else
  			VUHDO_getHealthBar(tButton, 6):SetValue(0);
  		end

			VUHDO_getOverhealText(VUHDO_getHealthBar(tButton, 1)):SetText("");
		end
	end
end



--
VUHDO_CUSTOM_INFO = {
	["number"] = 1,
	["range"] = true,
	["debuff"] = 0,
	["isPet"] = false,
	["charmed"] = false,
	["aggro"] = false,
	["group"] = 0,
	["afk"] = false,
	["threat"] = 0,
	["threatPerc"] = 0,
	["isVehicle"] = false,
	["ownerUnit"] = nil,
	["petUnit"] = nil,
	["missbuff"] = nil,
	["mibucateg"] = nil,
	["mibuvariants"] = nil,
	["raidIcon"] = nil,
	["visible"] = true,
	["baseRange"] = true,
};
local VUHDO_CUSTOM_INFO = VUHDO_CUSTOM_INFO;



--
local tUnit;
function VUHDO_getDisplayUnit(aButton)
	tUnit = aButton:GetAttribute("unit");

	if (strfind(tUnit, "target", 1, true) and tUnit ~= "target") then
		if (VUHDO_CUSTOM_INFO["fixResolveId"] == nil) then
			return tUnit, VUHDO_CUSTOM_INFO;
		else
			return VUHDO_CUSTOM_INFO["fixResolveId"], VUHDO_RAID[VUHDO_CUSTOM_INFO["fixResolveId"]];
		end
	else
		if (VUHDO_RAID[tUnit] ~= nil and VUHDO_RAID[tUnit]["isVehicle"]) then
			tUnit = VUHDO_RAID[tUnit]["petUnit"];
		end
		return tUnit, VUHDO_RAID[tUnit];
	end
end
local VUHDO_getDisplayUnit = VUHDO_getDisplayUnit;



--
local function VUHDO_getTagText(anInfo, aLifeString)
	if (not anInfo["connected"]) then
		return VUHDO_I18N_DC;
	elseif (anInfo["dead"]) then
		return UnitIsGhost(anInfo["unit"]) and format("|cffff0000%s|r", VUHDO_I18N_GHOST) or VUHDO_I18N_RIP;
	elseif (anInfo["afk"]) then
  	return "afk";
	end

	return "";
end



--
local tMissLife;
local tIsName, tIsLife, tIsLifeInName;
local tTextString;
local tHealthBar;
local tSetup;
local tLifeConfig;
local tOwnerInfo;
local tMaxChars;
local tLifeString;
local tUnit, tInfo;
local tIsShowLife;
local tLifeAmount;
local tIsHideIrrel;
local tIndex;
local tTagText;
local tIsLifeLeftOrRight;
function VUHDO_customizeText(aButton, aMode, anIsTarget)
	tUnit, tInfo = VUHDO_getDisplayUnit(aButton);
 	tHealthBar = VUHDO_getHealthBar(aButton, 1);

	if (tInfo == nil) then
		if ("focus" == tUnit) then
			VUHDO_getBarText(tHealthBar):SetText(VUHDO_I18N_NO_FOCUS);
		elseif ("target" == tUnit) then
			VUHDO_getBarText(tHealthBar):SetText(VUHDO_I18N_NO_TARGET);
		else
			VUHDO_getBarText(tHealthBar):SetText(VUHDO_I18N_NOT_AVAILABLE);
		end
		VUHDO_getLifeText(tHealthBar):SetText("");
		return;
	end

  tSetup = VUHDO_PANEL_SETUP[VUHDO_BUTTON_CACHE[aButton]];
  tLifeConfig = tSetup["LIFE_TEXT"];

	tIsHideIrrel = tLifeConfig["hideIrrelevant"] and VUHDO_getUnitHealthPercent(tInfo) >= VUHDO_CONFIG["EMERGENCY_TRIGGER"];
	tIsShowLife = tLifeConfig["show"] and not tIsHideIrrel;

	tIsLifeLeftOrRight =
		1 == tLifeConfig["position"] -- VUHDO_LT_POS_RIGHT
		or 2 == tLifeConfig["position"]; -- VUHDO_LT_POS_LEFT

	tIsLifeInName = tLifeConfig["show"] and tIsLifeLeftOrRight;

	tIsName = aMode ~= 2 or tIsLifeInName; -- VUHDO_UPDATE_HEALTH
	tIsLife = aMode ~= 7 or tIsLifeInName; -- VUHDO_UPDATE_AGGRO

	tTextString = "";
	-- Basic name text
	if (tIsName) then

	  tOwnerInfo = VUHDO_RAID[tInfo["ownerUnit"]];
	  tIndex = tInfo["name"] .. (tInfo["ownerUnit"] or "");
		if (VUHDO_NAME_TEXTS[tIndex] == nil) then
	  	if (tSetup["ID_TEXT"]["showName"]) then
	  		tTextString = (tSetup["ID_TEXT"]["showClass"] and not tInfo["isPet"])
	  			and tInfo["className"] .. ": " or "";

				tTextString = tTextString .. ((tOwnerInfo == nil or not tSetup["ID_TEXT"]["showPetOwners"])
					and tInfo["name"] or tOwnerInfo["name"] .. ": " .. tInfo["name"]);
	  	else
	  		tTextString = (tSetup["ID_TEXT"]["showClass"] and not tInfo["isPet"])
	  			and tInfo["className"] or "";

	  		if (tOwnerInfo ~= nil and tSetup["ID_TEXT"]["showPetOwners"]) then
	  			tTextString = tTextString .. tOwnerInfo["name"];
	  		end
	  	end
	  	tMaxChars = tSetup["PANEL_COLOR"]["TEXT"]["maxChars"];
	  	if (tMaxChars > 0 and strlen(tTextString) > tMaxChars) then
	  		tTextString = VUHDO_utf8Cut(tTextString, tMaxChars);
	  	end
	  	VUHDO_NAME_TEXTS[tIndex] = tTextString;
	  else
	  	tTextString = VUHDO_NAME_TEXTS[tIndex];
	  end

  	-- Add title flags
  	if (tSetup["ID_TEXT"]["showTags"] and not anIsTarget) then
  		if ("focus" == tUnit) then
    		tTextString = format("|cffff0000%s|r-%s", VUHDO_I18N_FOC, tTextString);
  		elseif ("target" == tUnit) then
    		tTextString = format("|cffff0000%s|r-%s", VUHDO_I18N_TAR, tTextString);
 			elseif (tOwnerInfo ~= nil and tOwnerInfo["isVehicle"]) then
    		tTextString = format("|cffff0000%s|r-%s", VUHDO_I18N_VEHICLE, tTextString);
 			end
  	end
	end

	tTagText = (tSetup["ID_TEXT"]["showTags"] and not anIsTarget)
		and VUHDO_getTagText(tInfo) or "";

	-- Life Text
	if (tIsLife and tIsShowLife) then
		tLifeAmount = sIsOverhealText
			and tInfo["health"] + VUHDO_getIncHealOnUnit(tUnit) or tInfo["health"];

		if (tTagText ~= "" or tIsHideIrrel) then
			tLifeString = "";
		elseif (1 == tLifeConfig["mode"] or anIsTarget) then -- VUHDO_LT_MODE_PERCENT
			tLifeString = format("%d%%", VUHDO_getUnitHealthModiPercent(tInfo, tLifeAmount - tInfo["health"]) * 100);
		elseif (3 == tLifeConfig["mode"]) then -- VUHDO_LT_MODE_MISSING
			tMissLife = tLifeAmount - tInfo["healthmax"];
			if (tMissLife < -10) then
				if (tLifeConfig["showTotalHp"]) then
					tLifeString = format("%s / %s",
						VUHDO_getKiloText(tMissLife, tInfo["healthmax"], tSetup),
						VUHDO_getKiloText(tInfo["healthmax"], tInfo["healthmax"], tSetup)
					);
				else
					tLifeString = VUHDO_getKiloText(tMissLife, tInfo["healthmax"], tSetup);
				end
			else
				tLifeString = tLifeConfig["showTotalHp"]
					and VUHDO_getKiloText(tInfo["healthmax"], tInfo["healthmax"], tSetup) or "";
			end
		else -- VUHDO_LT_MODE_LEFT
			if (tLifeConfig["showTotalHp"]) then
				tLifeString = format("%s / %s",
					VUHDO_getKiloText(tLifeAmount, tInfo["healthmax"], tSetup),
					VUHDO_getKiloText(tInfo["healthmax"], tInfo["healthmax"], tSetup)
				);
			else
				tLifeString = format("%s", VUHDO_getKiloText(tLifeAmount, tInfo["healthmax"], tSetup));
			end
		end

		tLifeString = VUHDO_getColoredString(tLifeString, sLifeColor);

		if (not tIsLifeInName) then
			VUHDO_getLifeText(tHealthBar):SetText(tTagText ~= "" and tTagText or tLifeString);
		else
			if (tTagText ~= "") then
				tTagText = tTagText .. "-";
			end

			if (2 == tLifeConfig["position"]) then -- VUHDO_LT_POS_LEFT
				tTextString = tLifeString ~= ""
					and format("%s%s %s", tTagText, tLifeString, tTextString)
					or format("%s%s", tTagText, tTextString);
			else
				tTextString = format("%s%s %s", tTagText, tTextString, tLifeString);
			end
		end
	elseif (tIsLife) then
		if (tIsLifeLeftOrRight) then
			if (tTagText ~= "") then
				tTextString = tTagText .. "-" .. tTextString;
			end
			VUHDO_getLifeText(tHealthBar):SetText("");
		else
			VUHDO_getLifeText(tHealthBar):SetText(tTagText);
		end
	end

  -- Aggro Text
  if (tIsName) then
	  if (tInfo["aggro"] and sIsAggroText) then

			tTextString = format("|cffff2020%s|r%s|cffff2020%s|r",
				VUHDO_THREAT_CFG["AGGRO_TEXT_LEFT"], tTextString, VUHDO_THREAT_CFG["AGGRO_TEXT_RIGHT"]);
		end

		VUHDO_getBarText(tHealthBar):SetText(tTextString);
	end
end

local VUHDO_customizeText = VUHDO_customizeText;



--
local tScaling;
local function VUHDO_customizeDamageFlash(aButton, aLossPercent)
	if (aLossPercent ~= nil) then
		tScaling = VUHDO_PANEL_SETUP[VUHDO_BUTTON_CACHE[aButton]]["SCALING"];
		if (tScaling["isDamFlash"] and tScaling["damFlashFactor"] >= aLossPercent) then
			UIFrameFlash(VUHDO_GLOBAL[aButton:GetName() .. "BgBarIcBarHlBarFlBar"], 0.05, 0.15, 0.25, false, 0.05, 0);
		end
	end
end



--
local tAllButtons, tButton, tHealthBar, tQuota, tInfo;
function VUHDO_healthBarBouquetCallback(aUnit, anIsActive, anIcon, aCurrValue, aCounter, aMaxValue, aColor, aBuffName, aBouquetName, aLevel, aCurrValue2)
	aMaxValue = aMaxValue or 0;
	aCurrValue = aCurrValue or 0;

	tQuota = (aCurrValue == 0 and aMaxValue == 0) and 0
		or aMaxValue > 1 and aCurrValue / aMaxValue
		or 0;

	tAllButtons = VUHDO_getUnitButtons(aUnit);
	if (tAllButtons ~= nil) then
		for _, tButton in pairs(tAllButtons) do
			if (VUHDO_INDICATOR_CONFIG["BOUQUETS"]["HEALTH_BAR_PANEL"][VUHDO_BUTTON_CACHE[tButton]] == "") then
				tHealthBar = VUHDO_getHealthBar(tButton, 1);

				if (tQuota > 0) then
					if (aColor ~= nil) then
						tHealthBar:SetVuhDoColor(aColor);
						if (aColor["useText"]) then
							VUHDO_getBarText(tHealthBar):SetTextColor(VUHDO_textColor(aColor));
							VUHDO_getLifeText(tHealthBar):SetTextColor(VUHDO_textColor(aColor));
						end
					end
				  tHealthBar:SetValue(tQuota);
				else
					tHealthBar:SetValue(0);
				end
			end
		end
	end

	tInfo = VUHDO_RAID[aUnit]
	if (tInfo == nil) then
		return;
	end

	-- Targets und targets-of-target, die im Raid sind
  tAllButtons = VUHDO_IN_RAID_TARGET_BUTTONS[tInfo["name"]];
	if (tAllButtons == nil) then
		return;
	end

	VUHDO_CUSTOM_INFO["fixResolveId"] = aUnit;
	for _, tButton in pairs(tAllButtons) do
		VUHDO_customizeTargetBar(tButton, aUnit, tInfo["range"]);
	end

end



--
function VUHDO_healthBarBouquetCallbackCustom(aUnit, anIsActive, anIcon, aCurrValue, aCounter, aMaxValue, aColor, aBuffName, aBouquetName)
	aMaxValue = aMaxValue or 0;
	aCurrValue = aCurrValue or 0;

	tQuota = (aCurrValue == 0 and aMaxValue == 0) and 0
		or aMaxValue > 1 and aCurrValue / aMaxValue
		or 0;

	tAllButtons = VUHDO_getUnitButtons(aUnit);
	if (tAllButtons ~= nil) then
		for _, tButton in pairs(tAllButtons) do
			if (VUHDO_INDICATOR_CONFIG["BOUQUETS"]["HEALTH_BAR_PANEL"][VUHDO_BUTTON_CACHE[tButton]] == aBouquetName) then
				tHealthBar = VUHDO_getHealthBar(tButton, 1);

				if (tQuota > 0) then
					if (aColor ~= nil) then
						tHealthBar:SetVuhDoColor(aColor);
						if (aColor["useText"]) then
							VUHDO_getBarText(tHealthBar):SetTextColor(VUHDO_textColor(aColor));
							VUHDO_getLifeText(tHealthBar):SetTextColor(VUHDO_textColor(aColor));
						end
					end
				  tHealthBar:SetValue(tQuota);
				else
					tHealthBar:SetValue(0);
				end
			end
		end
	end
end



--
local tAllButtons, tButton, tAggroBar;
function VUHDO_aggroBarBouquetCallback(aUnit, anIsActive, anIcon, aTimer, aCounter, aDuration, aColor, aBuffName, aBouquetName)
	tAllButtons = VUHDO_getUnitButtons(aUnit);
	if (tAllButtons ~= nil) then
		for _, tButton in pairs(tAllButtons) do
			if (anIsActive) then
				tAggroBar = VUHDO_getHealthBar(tButton, 4);
				tAggroBar:SetVuhDoColor(aColor);
				tAggroBar:SetValue(1);
			else
				VUHDO_getHealthBar(tButton, 4):SetValue(0);
			end
		end
	end
end



--
local tAllButtons, tButton, tBar, tQuota;
function VUHDO_backgroundBarBouquetCallback(aUnit, anIsActive, anIcon, aCurrValue, aCounter, aMaxValue, aColor, aBuffName, aBouquetName)
	aMaxValue = aMaxValue or 0;

	tQuota = (anIsActive or (aMaxValue or 0) > 1)
		and 1 or 0;

	tAllButtons =  VUHDO_getUnitButtons(aUnit);
	if (tAllButtons ~= nil) then
		for _, tButton in pairs(tAllButtons) do
			tBar = VUHDO_getHealthBar(tButton, 3);
			if (aColor ~= nil) then
				tBar:SetVuhDoColor(aColor);
			end
			tBar:SetValue(tQuota);
		end
	end
end



--
local tTexture;
local tIcon;
local tUnit;
function VUHDO_customizeHealButton(aButton)
	VUHDO_customizeText(aButton, 1, false); -- VUHDO_UPDATE_ALL

	tUnit, _ = VUHDO_getDisplayUnit(aButton);
	-- Raid icon
	if (VUHDO_PANEL_SETUP[VUHDO_BUTTON_CACHE[aButton]]["RAID_ICON"]["show"] and tUnit ~= nil) then
  	tIcon = GetRaidTargetIndex(tUnit);
  	if (tIcon ~= nil and VUHDO_PANEL_SETUP["RAID_ICON_FILTER"][tIcon]) then
	  	tTexture = VUHDO_getBarRoleIcon(aButton, 50);
  		VUHDO_setRaidTargetIconTexture(tTexture, tIcon);
  		tTexture:Show();
  	else
  		VUHDO_getBarRoleIcon(aButton, 50):Hide();
  	end
	end
end
local VUHDO_customizeHealButton = VUHDO_customizeHealButton;



--
local tInfo, tCnt, tAlpha, tIcon;
local function VUHDO_customizeDebuffIconsRange(aButton)
	_, tInfo = VUHDO_getDisplayUnit(aButton);

  if (tInfo ~= nil) then
  	tAlpha = tInfo["range"] and 1 or VUHDO_BAR_COLOR["OUTRANGED"]["O"];

  	for tCnt = 40, 44 do
  		tIcon = VUHDO_getBarIconFrame(aButton, tCnt);
  		if (tIcon:GetAlpha() > 0) then
  			tIcon:SetAlpha(tAlpha);
  		end
  	end
  end
end



--
local tInfo;
local tAllButtons;
local tButton;
function VUHDO_updateHealthBarsFor(aUnit, anUpdateMode)
	VUHDO_updateBouquetsForEvent(aUnit, anUpdateMode);

	if (4 == anUpdateMode) then -- VUHDO_UPDATE_DEBUFF
		return;
	end

  tAllButtons = VUHDO_getUnitButtons(aUnit);
	tInfo = VUHDO_RAID[aUnit];
	if (tInfo == nil or tAllButtons == nil) then
		return;
	end

	if (2 == anUpdateMode) then -- VUHDO_UPDATE_HEALTH
		VUHDO_determineIncHeal(aUnit);
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 2, false); -- VUHDO_UPDATE_HEALTH
			VUHDO_customizeDamageFlash(tButton, tInfo["lifeLossPerc"]);
		end
		tInfo["lifeLossPerc"] = nil;
		VUHDO_updateIncHeal(aUnit);

	elseif (9 == anUpdateMode) then -- VUHDO_UPDATE_INC
		VUHDO_determineIncHeal(aUnit);
		if (sIsOverhealText) then
			for _, tButton in pairs(tAllButtons) do
				VUHDO_customizeText(tButton, 2, false); -- VUHDO_UPDATE_HEALTH
			end
		end
		VUHDO_updateIncHeal(aUnit);

	elseif (7 == anUpdateMode) then -- VUHDO_UPDATE_AGGRO
		if (sIsAggroText) then
			for _, tButton in pairs(tAllButtons) do
				VUHDO_customizeText(tButton, 7, false); -- VUHDO_UPDATE_AGGRO
			end
		end

	elseif (5 == anUpdateMode) then -- VUHDO_UPDATE_RANGE
		VUHDO_determineIncHeal(aUnit);
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 2, false); -- für d/c tag -- VUHDO_UPDATE_HEALTH
			VUHDO_customizeDebuffIconsRange(tButton);
		end
		VUHDO_updateIncHeal(aUnit);

	elseif (3 == anUpdateMode) then -- VUHDO_UPDATE_HEALTH_MAX
		VUHDO_determineIncHeal(aUnit);
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 2, false); -- VUHDO_UPDATE_HEALTH
		end
		VUHDO_updateIncHeal(aUnit);

	elseif (6 == anUpdateMode) then -- VUHDO_UPDATE_AFK
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 1, false); -- VUHDO_UPDATE_ALL
		end
	elseif (10 == anUpdateMode) then -- VUHDO_UPDATE_ALIVE
		VUHDO_determineIncHeal(aUnit);
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 1, false); -- VUHDO_UPDATE_ALL
		end
		VUHDO_updateIncHeal(aUnit);

	elseif (25 == anUpdateMode) then -- VUHDO_UPDATE_RESURRECTION
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 1, false); -- VUHDO_UPDATE_ALL
		end

	elseif (19 == anUpdateMode) then -- VUHDO_UPDATE_DC
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 2, false); -- VUHDO_UPDATE_HEALTH
		end

	elseif (1 == anUpdateMode) then -- VUHDO_UPDATE_ALL
		VUHDO_determineIncHeal(aUnit);
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeHealButton(tButton);
		end

		VUHDO_updateIncHeal(aUnit);
	end
end



--
local VUHDO_getHealButton = VUHDO_getHealButton;
local tButton;
local tUnit;
local tPanelButtons;
function VUHDO_updateAllPanelBars(aPanelNum)
	tPanelButtons = VUHDO_getPanelButtons(aPanelNum);
	for _, tButton in pairs(tPanelButtons) do
		if (tButton:GetAttribute("unit") == nil) then
			break;
		end
		VUHDO_customizeHealButton(tButton);
	end

	for tUnit, _ in pairs(VUHDO_RAID) do
		VUHDO_updateIncHeal(tUnit); -- Trotzdem wichtig um Balken zu verstecken bei neuen Units
		VUHDO_updateManaBars(tUnit, 3);
		VUHDO_manaBarBouquetCallback(tUnit, false, nil, nil, nil, nil, nil, nil, nil);
	end
end
local VUHDO_updateAllPanelBars = VUHDO_updateAllPanelBars;



--
local tCnt;
VUHDO_REMOVE_HOTS = true;
function VUHDO_updateAllRaidBars()
	for tCnt = 1, 10 do -- VUHDO_MAX_PANELS
		if (VUHDO_isPanelVisible(tCnt)) then
			VUHDO_updateAllPanelBars(tCnt);
		end
	end

	if (VUHDO_REMOVE_HOTS) then
		VUHDO_removeAllHots();
		VUHDO_updateAllHoTs();
	  if (VUHDO_INTERNAL_TOGGLES[18]) then -- VUHDO_UPDATE_MOUSEOVER_CLUSTER
			VUHDO_updateClusterHighlights();
		end
	else
		VUHDO_REMOVE_HOTS = true;
	end
end
