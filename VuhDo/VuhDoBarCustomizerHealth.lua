local _;

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
local VUHDO_getUnitButtonsSafe;
local VUHDO_getUnitButtonsPanel;
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
local strfind = strfind;
local strbyte = strbyte;
local GetRaidTargetIndex = GetRaidTargetIndex;
local UnitIsUnit = UnitIsUnit;
local pairs = pairs;
local twipe = table.wipe;
local format = format;
local sIsOverhealText;
local sIsAggroText;
local sIsInvertGrowth;
local sLifeColor;


function VUHDO_customHealthInitLocalOverrides()
	VUHDO_PANEL_SETUP = _G["VUHDO_PANEL_SETUP"];
	VUHDO_BUTTON_CACHE = _G["VUHDO_BUTTON_CACHE"];
	VUHDO_RAID = _G["VUHDO_RAID"];
	VUHDO_CONFIG = _G["VUHDO_CONFIG"];
	VUHDO_INDICATOR_CONFIG = _G["VUHDO_INDICATOR_CONFIG"];
 	VUHDO_BAR_COLOR = VUHDO_PANEL_SETUP["BAR_COLORS"];
 	VUHDO_THREAT_CFG = VUHDO_CONFIG["THREAT"];
 	VUHDO_IN_RAID_TARGET_BUTTONS = _G["VUHDO_IN_RAID_TARGET_BUTTONS"];
	VUHDO_INTERNAL_TOGGLES = _G["VUHDO_INTERNAL_TOGGLES"];

	VUHDO_getUnitButtons = _G["VUHDO_getUnitButtons"];
	VUHDO_getUnitButtonsPanel = _G["VUHDO_getUnitButtonsPanel"];
	VUHDO_getHealthBar = _G["VUHDO_getHealthBar"];
	VUHDO_getBarText = _G["VUHDO_getBarText"];
	VUHDO_getIncHealOnUnit = _G["VUHDO_getIncHealOnUnit"];
	VUHDO_getDiffColor = _G["VUHDO_getDiffColor"];
	VUHDO_isPanelVisible = _G["VUHDO_isPanelVisible"];
	VUHDO_updateManaBars = _G["VUHDO_updateManaBars"];
	VUHDO_removeAllHots = _G["VUHDO_removeAllHots"];
	VUHDO_updateAllHoTs = _G["VUHDO_updateAllHoTs"];
	VUHDO_getUnitHealthPercent = _G["VUHDO_getUnitHealthPercent"];
	VUHDO_getPanelButtons = _G["VUHDO_getPanelButtons"];
	VUHDO_updateBouquetsForEvent = _G["VUHDO_updateBouquetsForEvent"];
	VUHDO_utf8Cut = _G["VUHDO_utf8Cut"];
	VUHDO_resolveVehicleUnit = _G["VUHDO_resolveVehicleUnit"];
	VUHDO_getOverhealPanel = _G["VUHDO_getOverhealPanel"];
	VUHDO_getOverhealText = _G["VUHDO_getOverhealText"];
	VUHDO_getBarRoleIcon = _G["VUHDO_getBarRoleIcon"];
	VUHDO_getBarIconFrame = _G["VUHDO_getBarIconFrame"];
  VUHDO_updateClusterHighlights = _G["VUHDO_updateClusterHighlights"];
	VUHDO_customizeTargetBar = _G["VUHDO_customizeTargetBar"];
	VUHDO_getColoredString = _G["VUHDO_getColoredString"];
	VUHDO_textColor = _G["VUHDO_textColor"];
	VUHDO_getUnitButtonsSafe = _G["VUHDO_getUnitButtonsSafe"];

	sIsOverhealText = VUHDO_CONFIG["SHOW_TEXT_OVERHEAL"]
	sIsAggroText = VUHDO_CONFIG["THREAT"]["AGGRO_USE_TEXT"];
	sIsInvertGrowth = VUHDO_INDICATOR_CONFIG["CUSTOM"]["HEALTH_BAR"]["invertGrowth"];
	sLifeColor = VUHDO_PANEL_SETUP["PANEL_COLOR"]["HEALTH_TEXT"];
	sIsNoRangeFade = VUHDO_CONFIG["CUSTOM_DEBUFF"]["isNoRangeFade"];

	twipe(VUHDO_NAME_TEXTS);
end

----------------------------------------------------


function VUHDO_resetNameTextCache()
	twipe(VUHDO_NAME_TEXTS);
end



local tIncColor = { ["useBackground"] = true };
local tShieldColor = { ["useBackground"] = true };



--
function VUHDO_getUnitHealthModiPercent(anInfo, aModifier)
	return anInfo["healthmax"] == 0 and 0
		or (anInfo["health"] + aModifier) / anInfo["healthmax"];
end
local VUHDO_getUnitHealthModiPercent = VUHDO_getUnitHealthModiPercent;



--
local tOpacity;
local function VUHDO_setStatusBarColor(aBar, aColor)
	tOpacity = aColor["useOpacity"] and aColor["O"] or nil;

	if aColor["useBackground"] then	aBar:SetStatusBarColor(aColor["R"], aColor["G"], aColor["B"], tOpacity);
	elseif tOpacity then aBar:SetAlpha(tOpacity); end
end



--
local function VUHDO_getKiloText(aNumber, aMaxNumber, aSetup)
	return aSetup["LIFE_TEXT"]["verbose"] and aNumber
	  or aMaxNumber > 100000 and format("%.0fk", aNumber * 0.001)
		or aMaxNumber > 10000 and format("%.1fk", aNumber * 0.001)
		or aNumber;
end



--
local tInfo;
local tAmountInc;
local tHealthPlusInc;
local function VUHDO_getHealthPlusIncQuota(aUnit)
	tInfo = VUHDO_RAID[aUnit];
	if not tInfo["connected"] or tInfo["dead"] then
		return 0, 0;
	else
		tAmountInc = VUHDO_getIncHealOnUnit(aUnit);
		tHealthPlusInc = VUHDO_getUnitHealthModiPercent(tInfo, tAmountInc);
		tHealthPlusInc = tHealthPlusInc > 1 and 1 or tHealthPlusInc;
		return tHealthPlusInc, tAmountInc;
	end
end



--
local tInfo;
local tAllButtons;
local tAbsorbAmount;
local tOpacity;
local tHealthBar;
local tIncBar;
function VUHDO_updateShieldBar(aUnit, aHealthPlusIncQuota)
	if not VUHDO_CONFIG["SHOW_SHIELD_BAR"] then return; end

	tInfo = VUHDO_RAID[aUnit];
	tAllButtons = VUHDO_getUnitButtons(VUHDO_resolveVehicleUnit(aUnit));

	if not tInfo or not tAllButtons or not tInfo["connected"] or tInfo["dead"] or tInfo["healthmax"] <= 0 then
		return;
	end
	aHealthPlusIncQuota = aHealthPlusIncQuota and aHealthPlusIncQuota or VUHDO_getHealthPlusIncQuota(aUnit);

	tAbsorbAmount = VUHDO_getUnitOverallShieldRemain(aUnit) / tInfo["healthmax"];
  for _, tButton in pairs(tAllButtons) do
    tShieldBar = VUHDO_getHealthBar(tButton, 19);

    if tAbsorbAmount > 0 then
			tShieldBar:SetValueRange(aHealthPlusIncQuota, aHealthPlusIncQuota + tAbsorbAmount);
			tHealthBar = VUHDO_getHealthBar(tButton, 1);
 			tShieldColor["R"], tShieldColor["G"], tShieldColor["B"], tOpacity = tHealthBar:GetStatusBarColor();
 			tShieldColor = VUHDO_getDiffColor(tShieldColor, VUHDO_PANEL_SETUP["BAR_COLORS"]["SHIELD"]);
 			if tShieldColor["O"] and tOpacity then
 				tShieldColor["O"] = tShieldColor["O"] * tOpacity * (tHealthBar:GetAlpha() or 1);
 			end

    	VUHDO_setStatusBarColor(tShieldBar, tShieldColor);
    else
    	tShieldBar:SetValueRange(0,0);
    end
  end
end
local VUHDO_updateShieldBar = VUHDO_updateShieldBar;



--
local tAllButtons;
local tHealthPlusInc;
local tIncBar;
local tAmountInc;
local tInfo;
local tOpacity;
local tHealthBar;
local tIncBar;
local function VUHDO_updateIncHeal(aUnit)
	tInfo = VUHDO_RAID[aUnit];
	tAllButtons = VUHDO_getUnitButtons(VUHDO_resolveVehicleUnit(aUnit));

	if not tInfo or not tAllButtons then return; end

	tHealthPlusInc, tAmountInc = VUHDO_getHealthPlusIncQuota(aUnit);

	for _, tButton in pairs(tAllButtons) do
  	tIncBar = VUHDO_getHealthBar(tButton, 6);

		if tAmountInc > 0 and tInfo["healthmax"] > 0 then
			tIncBar:SetValueRange(tInfo["health"] / tInfo["healthmax"], tHealthPlusInc);
			tHealthBar = VUHDO_getHealthBar(tButton, 1);
 			tIncColor["R"], tIncColor["G"], tIncColor["B"], tOpacity = tHealthBar:GetStatusBarColor();
 			tIncColor = VUHDO_getDiffColor(tIncColor, VUHDO_PANEL_SETUP["BAR_COLORS"]["INCOMING"]);
 			if tIncColor["O"] and tOpacity then
 				tIncColor["O"] = tIncColor["O"] * tOpacity * (tHealthBar:GetAlpha() or 1);
 			end

    	VUHDO_setStatusBarColor(tIncBar, tIncColor);
		else
  		tIncBar:SetValueRange(0,0);
		end
	end

	VUHDO_updateShieldBar(aUnit, tHealthPlusInc);
end



--
local tRatio, tBar, tScale;
function VUHDO_overhealTextCallback(aUnit, aPanelNum, aProviderName, aText, aValue)
	for _, tButton in pairs(VUHDO_getUnitButtonsPanel(aUnit, aPanelNum)) do
		--VUHDO_getOverhealText(VUHDO_getHealthBar(tButton, 1)):SetText(aText);
		tBar = VUHDO_getHealthBar(tButton, 1);
		VUHDO_getOverhealText(tBar):SetText(aText);

		-- Sonderwurst Overheal wirklich nötig?
		if strfind(aProviderName, "OVERHEAL", 1, true) then
			tInfo = VUHDO_RAID[aUnit];
			if tInfo then
  	  	if aValue > 0 and tInfo["healthmax"] > 0 then
					tRatio = aValue / tInfo["healthmax"];
				  tScale = VUHDO_PANEL_SETUP[aPanelNum]["OVERHEAL_TEXT"]["scale"];
    			VUHDO_getOverhealPanel(tBar):SetScale(tRatio < 1 and (0.5 + tRatio) * tScale or 1.5 * tScale);
	  	  end
	  	end
		end

	end
end



--
VUHDO_CUSTOM_INFO = {
	["number"] = 1,
	["range"] = true,
	["debuff"] = 0,
	--["isPet"] = false,
	--["charmed"] = false,
	--["aggro"] = false,
	["group"] = 0,
	--["afk"] = false,
	["threat"] = 0,
	["threatPerc"] = 0,
	--["isVehicle"] = false,
	--["ownerUnit"] = nil,
	--["petUnit"] = nil,
	--["missbuff"] = nil,
	--["mibucateg"] = nil,
	--["mibuvariants"] = nil,
	--["raidIcon"] = nil,
	["visible"] = true,
	["baseRange"] = true,
};
local VUHDO_CUSTOM_INFO = VUHDO_CUSTOM_INFO;



--
local tUnit;
function VUHDO_getDisplayUnit(aButton)
	tUnit = aButton:GetAttribute("unit");

	if strfind(tUnit, "target", 1, true) and tUnit ~= "target" then
		if not VUHDO_CUSTOM_INFO["fixResolveId"] then
			return tUnit, VUHDO_CUSTOM_INFO;
		else
			return VUHDO_CUSTOM_INFO["fixResolveId"], VUHDO_RAID[VUHDO_CUSTOM_INFO["fixResolveId"]];
		end
	else
		if VUHDO_RAID[tUnit] and VUHDO_RAID[tUnit]["isVehicle"] then
			tUnit = VUHDO_RAID[tUnit]["petUnit"];
		end
		return tUnit, VUHDO_RAID[tUnit];
	end
end
local VUHDO_getDisplayUnit = VUHDO_getDisplayUnit;



--
local function VUHDO_getTagText(anInfo, aLifeString)
	if not anInfo["connected"] then	return VUHDO_I18N_DC;
	elseif anInfo["dead"] then return UnitIsGhost(anInfo["unit"]) and format("|cffff0000%s|r", VUHDO_I18N_GHOST) or VUHDO_I18N_RIP;
	elseif (anInfo["afk"]) then return "afk"; end
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
local tPanelNum;
function VUHDO_customizeText(aButton, aMode, anIsTarget)
	tUnit, tInfo = VUHDO_getDisplayUnit(aButton);
 	tHealthBar = VUHDO_getHealthBar(aButton, 1);

	if not tInfo then
		VUHDO_getBarText(tHealthBar):SetText(
			   "focus" == tUnit and VUHDO_I18N_NO_FOCUS
			or "target" == tUnit and VUHDO_I18N_NO_TARGET
			or VUHDO_I18N_NOT_AVAILABLE);

		VUHDO_getLifeText(tHealthBar):SetText("");
		return;
	end

	tPanelNum = VUHDO_BUTTON_CACHE[aButton];
  tSetup = VUHDO_PANEL_SETUP[tPanelNum];
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
	if tIsName then

	  tOwnerInfo = VUHDO_RAID[tInfo["ownerUnit"]];
	  tIndex = tInfo["name"] .. (tInfo["ownerUnit"] or "") .. tPanelNum;
		if not VUHDO_NAME_TEXTS[tIndex] then

	  	if tSetup["ID_TEXT"]["showName"] then
	  		tTextString = (tSetup["ID_TEXT"]["showClass"] and not tInfo["isPet"])
	  			and tInfo["className"] .. ": " or "";

				tTextString = tTextString .. ((not tOwnerInfo or not tSetup["ID_TEXT"]["showPetOwners"])
					and tInfo["name"] or tOwnerInfo["name"] .. ": " .. tInfo["name"]);
	  	else
	  		tTextString = (tSetup["ID_TEXT"]["showClass"] and not tInfo["isPet"])
	  			and tInfo["className"] or "";

	  		if tOwnerInfo and tSetup["ID_TEXT"]["showPetOwners"] then
	  			tTextString = tTextString .. tOwnerInfo["name"];
	  		end
	  	end
	  	tMaxChars = tSetup["PANEL_COLOR"]["TEXT"]["maxChars"];

	  	if tMaxChars > 0 and #tTextString > tMaxChars then
	  		tTextString = VUHDO_utf8Cut(tTextString, tMaxChars);
	  	end
	  	VUHDO_NAME_TEXTS[tIndex] = tTextString;
	  else
	  	tTextString = VUHDO_NAME_TEXTS[tIndex];
	  end

  	-- Add title flags
  	if tSetup["ID_TEXT"]["showTags"] and not anIsTarget then

  		if "focus" == tUnit then tTextString = format("|cffff0000%s|r-%s", VUHDO_I18N_FOC, tTextString);
  		elseif "target" == tUnit then tTextString = format("|cffff0000%s|r-%s", VUHDO_I18N_TAR, tTextString);
 			elseif tOwnerInfo and tOwnerInfo["isVehicle"] then tTextString = format("|cffff0000%s|r-%s", VUHDO_I18N_VEHICLE, tTextString); end
  	end
	end

	tTagText = (tSetup["ID_TEXT"]["showTags"] and not anIsTarget)
		and VUHDO_getTagText(tInfo) or "";

	-- Life Text
	if tIsLife and tIsShowLife then
		tLifeAmount = sIsOverhealText
			and tInfo["health"] + VUHDO_getIncHealOnUnit(tUnit) or tInfo["health"];

		if tTagText ~= "" or tIsHideIrrel then
			tLifeString = "";

		elseif 1 == tLifeConfig["mode"] or anIsTarget then -- VUHDO_LT_MODE_PERCENT
			tLifeString = format("%d%%", VUHDO_getUnitHealthModiPercent(tInfo, tLifeAmount - tInfo["health"]) * 100);

		elseif 3 == tLifeConfig["mode"] then -- VUHDO_LT_MODE_MISSING
			tMissLife = tLifeAmount - tInfo["healthmax"];
			if tMissLife < -10 then

				if tLifeConfig["showTotalHp"] then
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

			if tLifeConfig["showTotalHp"] then
				tLifeString = format("%s / %s",
					VUHDO_getKiloText(tLifeAmount, tInfo["healthmax"], tSetup),
					VUHDO_getKiloText(tInfo["healthmax"], tInfo["healthmax"], tSetup)
				);
			else
				tLifeString = format("%s", VUHDO_getKiloText(tLifeAmount, tInfo["healthmax"], tSetup));
			end
		end

		tLifeString = VUHDO_getColoredString(tLifeString, sLifeColor);

		if not tIsLifeInName then
			VUHDO_getLifeText(tHealthBar):SetText(tTagText ~= "" and tTagText or tLifeString);
		else
			if tTagText ~= "" then tTagText = tTagText .. "-"; end

			if 2 == tLifeConfig["position"] then -- VUHDO_LT_POS_LEFT
				tTextString = tLifeString ~= ""
					and format("%s%s %s", tTagText, tLifeString, tTextString)
					or format("%s%s", tTagText, tTextString);
			else
				tTextString = format("%s%s %s", tTagText, tTextString, tLifeString);
			end
		end
	elseif tIsLife then
		if tIsLifeLeftOrRight then

			if tTagText ~= "" then tTextString = tTagText .. "-" .. tTextString; end
			VUHDO_getLifeText(tHealthBar):SetText("");
		else
			VUHDO_getLifeText(tHealthBar):SetText(tTagText);
		end
	end

  -- Aggro Text
  if tIsName then
	  if tInfo["aggro"] and sIsAggroText then

			tTextString = format("|cffff2020%s|r%s|cffff2020%s|r",
				VUHDO_THREAT_CFG["AGGRO_TEXT_LEFT"], tTextString, VUHDO_THREAT_CFG["AGGRO_TEXT_RIGHT"]);
		end

		VUHDO_getBarText(tHealthBar):SetText(tTextString);
	end
end

local VUHDO_customizeText = VUHDO_customizeText;



--
local tScaling;
local function VUHDO_customizeDamageFlash(aButton, anInfo)
	tScaling = VUHDO_PANEL_SETUP[VUHDO_BUTTON_CACHE[aButton]]["SCALING"];
	if tScaling["isDamFlash"] and tScaling["damFlashFactor"] >= (anInfo["lifeLossPerc"] or -1) then
		VUHDO_UIFrameFlash(_G[aButton:GetName() .. "BgBarIcBarHlBarFlBar"], 0.05, 0.15, 0.25, false, 0.05, 0);
	end
end



--
local tAllButtons, tHealthBar, tQuota, tInfo;
function VUHDO_healthBarBouquetCallback(aUnit, anIsActive, anIcon, aCurrValue, aCounter, aMaxValue, aColor, aBuffName, aBouquetName, aLevel, aCurrValue2)
	aMaxValue = aMaxValue or 0;
	aCurrValue = aCurrValue or 0;

	tQuota = (aCurrValue == 0 and aMaxValue == 0) and 0
		or aMaxValue > 1 and aCurrValue / aMaxValue or 0;

	for _, tButton in pairs(VUHDO_getUnitButtonsSafe(aUnit)) do
		if VUHDO_INDICATOR_CONFIG["BOUQUETS"]["HEALTH_BAR_PANEL"][VUHDO_BUTTON_CACHE[tButton]] == "" then
			tHealthBar = VUHDO_getHealthBar(tButton, 1);

			if tQuota > 0 then
				if aColor then
					tHealthBar:SetVuhDoColor(aColor);
					if aColor["useText"] then
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

	tInfo = VUHDO_RAID[aUnit]
	if not tInfo then return; end

	-- Targets und targets-of-target, die im Raid sind
  tAllButtons = VUHDO_IN_RAID_TARGET_BUTTONS[tInfo["name"]];
	if not tAllButtons then return; end

	VUHDO_CUSTOM_INFO["fixResolveId"] = aUnit;
	for _, tButton in pairs(tAllButtons) do
		VUHDO_customizeTargetBar(tButton, aUnit, tInfo["range"]);
	end
end



--
local tHealthBar, tQuota;
function VUHDO_healthBarBouquetCallbackCustom(aUnit, anIsActive, anIcon, aCurrValue, aCounter, aMaxValue, aColor, aBuffName, aBouquetName)
	aMaxValue = aMaxValue or 0;
	aCurrValue = aCurrValue or 0;

	tQuota = (aCurrValue == 0 and aMaxValue == 0) and 0
		or aMaxValue > 1 and aCurrValue / aMaxValue
		or 0;

	for _, tButton in pairs(VUHDO_getUnitButtonsSafe(aUnit)) do
		if VUHDO_INDICATOR_CONFIG["BOUQUETS"]["HEALTH_BAR_PANEL"][VUHDO_BUTTON_CACHE[tButton]] == aBouquetName then
			tHealthBar = VUHDO_getHealthBar(tButton, 1);

			if tQuota > 0 then
				if aColor then
					tHealthBar:SetVuhDoColor(aColor);
					if aColor["useText"] then
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



--
local tAggroBar;
function VUHDO_aggroBarBouquetCallback(aUnit, anIsActive, anIcon, aTimer, aCounter, aDuration, aColor, aBuffName, aBouquetName)
	for _, tButton in pairs(VUHDO_getUnitButtonsSafe(aUnit)) do
		if anIsActive then
			tAggroBar = VUHDO_getHealthBar(tButton, 4);
			tAggroBar:SetVuhDoColor(aColor);
			tAggroBar:SetValue(1);
		else
			VUHDO_getHealthBar(tButton, 4):SetValue(0);
		end
	end
end



--
local tBar, tQuota;
function VUHDO_backgroundBarBouquetCallback(aUnit, anIsActive, anIcon, aCurrValue, aCounter, aMaxValue, aColor, aBuffName, aBouquetName)
	tQuota = (anIsActive or (aMaxValue or 0) > 1)	and 1 or 0;

	for _, tButton in pairs(VUHDO_getUnitButtonsSafe(aUnit)) do
		tBar = VUHDO_getHealthBar(tButton, 3);
		if aColor then tBar:SetVuhDoColor(aColor); end
		tBar:SetValue(tQuota);
	end
end



--
local tTexture;
local tIcon;
local tUnit;
function VUHDO_customizeHealButton(aButton)

	VUHDO_customizeText(aButton, 1, false); -- VUHDO_UPDATE_ALL

	tUnit = VUHDO_getDisplayUnit(aButton);
	-- Raid icon
	if VUHDO_PANEL_SETUP[VUHDO_BUTTON_CACHE[aButton]]["RAID_ICON"]["show"] and tUnit then
  	tIcon = GetRaidTargetIndex(tUnit);
  	if tIcon and VUHDO_PANEL_SETUP["RAID_ICON_FILTER"][tIcon] then
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
local tInfo, tAlpha, tIcon;
local function VUHDO_customizeDebuffIconsRange(aButton)
	if sIsNoRangeFade then return; end

	_, tInfo = VUHDO_getDisplayUnit(aButton);

  if tInfo then
  	tAlpha = tInfo["range"] and 1 or VUHDO_BAR_COLOR["OUTRANGED"]["O"];

  	for tCnt = 40, 44 do
  		tIcon = VUHDO_getBarIconFrame(aButton, tCnt);
  		if tIcon then
	  		if tIcon:GetAlpha() > 0 then
	  			tIcon:SetAlpha(tAlpha);
	  		end
	  	end
  	end
  end
end



--
local tInfo;
local tAllButtons;
function VUHDO_updateHealthBarsFor(aUnit, anUpdateMode)
	VUHDO_updateBouquetsForEvent(aUnit, anUpdateMode);

  tAllButtons = VUHDO_getUnitButtons(aUnit);
	if not tAllButtons then	return; end

	if 2 == anUpdateMode then -- VUHDO_UPDATE_HEALTH
		VUHDO_determineIncHeal(aUnit);

		tInfo = VUHDO_RAID[aUnit];
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 2, false); -- VUHDO_UPDATE_HEALTH
			VUHDO_customizeDamageFlash(tButton, tInfo);
		end
		tInfo["lifeLossPerc"] = nil;
		VUHDO_updateIncHeal(aUnit);

	elseif 9 == anUpdateMode then -- VUHDO_UPDATE_INC
		VUHDO_determineIncHeal(aUnit);
		if sIsOverhealText then
			for _, tButton in pairs(tAllButtons) do
				VUHDO_customizeText(tButton, 2, false); -- VUHDO_UPDATE_HEALTH
			end
		end
		VUHDO_updateIncHeal(aUnit);

	elseif 7 == anUpdateMode then -- VUHDO_UPDATE_AGGRO
		if sIsAggroText then
			for _, tButton in pairs(tAllButtons) do
				VUHDO_customizeText(tButton, 7, false); -- VUHDO_UPDATE_AGGRO
			end
		end

	elseif 5 == anUpdateMode then -- VUHDO_UPDATE_RANGE
		VUHDO_determineIncHeal(aUnit);
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 2, false); -- für d/c tag -- VUHDO_UPDATE_HEALTH
			VUHDO_customizeDebuffIconsRange(tButton);
		end
		VUHDO_updateIncHeal(aUnit);

	elseif 3 == anUpdateMode then -- VUHDO_UPDATE_HEALTH_MAX
		VUHDO_determineIncHeal(aUnit);
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 2, false); -- VUHDO_UPDATE_HEALTH
		end
		VUHDO_updateIncHeal(aUnit);

	elseif 6 == anUpdateMode then -- VUHDO_UPDATE_AFK
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 1, false); -- VUHDO_UPDATE_ALL
		end
	elseif 10 == anUpdateMode then -- VUHDO_UPDATE_ALIVE
		VUHDO_determineIncHeal(aUnit);
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 1, false); -- VUHDO_UPDATE_ALL
		end
		VUHDO_updateIncHeal(aUnit);

	elseif 25 == anUpdateMode then -- VUHDO_UPDATE_RESURRECTION
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 1, false); -- VUHDO_UPDATE_ALL
		end

	elseif 19 == anUpdateMode then -- VUHDO_UPDATE_DC
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 2, false); -- VUHDO_UPDATE_HEALTH
		end

	elseif 1 == anUpdateMode then -- VUHDO_UPDATE_ALL
		VUHDO_determineIncHeal(aUnit);
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeHealButton(tButton);
		end

		VUHDO_updateIncHeal(aUnit);
	end
end



--
function VUHDO_updateAllPanelBars(aPanelNum)
	for _, tButton in pairs(VUHDO_getPanelButtons(aPanelNum)) do
		if not tButton:GetAttribute("unit") then break; end
		VUHDO_customizeHealButton(tButton);
	end

	for tUnit, _ in pairs(VUHDO_RAID) do
		VUHDO_updateIncHeal(tUnit); -- Trotzdem wichtig um Balken zu verstecken bei neuen Units
		VUHDO_updateManaBars(tUnit, 3);
		VUHDO_manaBarBouquetCallback(tUnit, false);
	end
end



--
VUHDO_REMOVE_HOTS = true;
function VUHDO_updateAllRaidBars()
	for tCnt = 1, 10 do -- VUHDO_MAX_PANELS
		if VUHDO_isPanelVisible(tCnt) then
			for _, tButton in pairs(VUHDO_getPanelButtons(tCnt)) do
				if not tButton:GetAttribute("unit") then break; end
				VUHDO_customizeHealButton(tButton);
			end
		end
	end

	for tUnit, _ in pairs(VUHDO_RAID) do
		VUHDO_updateIncHeal(tUnit); -- Trotzdem wichtig um Balken zu verstecken bei neuen Units
		VUHDO_updateManaBars(tUnit, 3);
		VUHDO_manaBarBouquetCallback(tUnit, false);
		VUHDO_aggroBarBouquetCallback(tUnit, false);
	end

	if VUHDO_REMOVE_HOTS then
		VUHDO_removeAllHots();
		VUHDO_updateAllHoTs();
	  if VUHDO_INTERNAL_TOGGLES[18] then VUHDO_updateClusterHighlights(); end -- VUHDO_UPDATE_MOUSEOVER_CLUSTER
	else
		VUHDO_REMOVE_HOTS = true;
	end
end
