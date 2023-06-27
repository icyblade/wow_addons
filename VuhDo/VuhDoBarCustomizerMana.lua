
-- BURST CACHE ---------------------------------------------------


local VUHDO_RAID;
local VUHDO_getUnitButtons;
local VUHDO_IN_RAID_TARGET_BUTTONS;
local VUHDO_PANEL_SETUP;
local VUHDO_BUTTON_CACHE;
local UnitPowerType = UnitPowerType;
local UnitMana = UnitMana;
local UnitManaMax = UnitManaMax;
local InCombatLockdown = InCombatLockdown;
local pairs = pairs;

local VUHDO_getHealthBar;
local VUHDO_isConfigDemoUsers;
local VUHDO_updateBouquetsForEvent;
local sIsInverted;
function VUHDO_customManaInitBurst()
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];
	VUHDO_getUnitButtons = VUHDO_GLOBAL["VUHDO_getUnitButtons"];
	VUHDO_IN_RAID_TARGET_BUTTONS = VUHDO_GLOBAL["VUHDO_IN_RAID_TARGET_BUTTONS"];
	VUHDO_PANEL_SETUP = VUHDO_GLOBAL["VUHDO_PANEL_SETUP"];
	VUHDO_BUTTON_CACHE = VUHDO_GLOBAL["VUHDO_BUTTON_CACHE"];

	VUHDO_getHealthBar = VUHDO_GLOBAL["VUHDO_getHealthBar"];
	VUHDO_isConfigDemoUsers = VUHDO_GLOBAL["VUHDO_isConfigDemoUsers"];
	VUHDO_updateBouquetsForEvent = VUHDO_GLOBAL["VUHDO_updateBouquetsForEvent"];
	sIsInverted = VUHDO_INDICATOR_CONFIG["CUSTOM"]["MANA_BAR"]["invertGrowth"];
end

----------------------------------------------------


--
local tInfo;
local tPowerType;
function VUHDO_updateManaBars(aUnit, aChange)
	tInfo = VUHDO_RAID[aUnit];

	if (tInfo["isVehicle"]) then
		if (tInfo["petUnit"] == nil) then
			return;
		end

		aUnit = tInfo["petUnit"];
		tInfo = VUHDO_RAID[aUnit];
		if (tInfo == nil) then
			return;
		end
	end

	if (not VUHDO_isConfigDemoUsers()) then
		if (aChange == 1) then
			tInfo["power"] = UnitMana(aUnit);
		elseif (aChange == 2) then
			tInfo["powermax"] = UnitManaMax(aUnit);
		elseif (aChange == 3) then
			tPowerType, _ = UnitPowerType(aUnit);
			tInfo["powertype"] = tonumber(tPowerType);
			tInfo["powermax"] = UnitManaMax(aUnit);
			tInfo["power"] = UnitMana(aUnit);
		end
	end

	if (tInfo["powertype"] == 0) then -- VUHDO_UNIT_POWER_MANA
		VUHDO_updateBouquetsForEvent(aUnit, 13); -- VUHDO_UPDATE_MANA

		if (aChange == 3) then
			VUHDO_updateBouquetsForEvent(aUnit, 21); -- VUHDO_UPDATE_OTHER_POWERS
		end
	else
		VUHDO_updateBouquetsForEvent(aUnit, 21); -- VUHDO_UPDATE_OTHER_POWERS

		if (aChange == 3) then
			VUHDO_updateBouquetsForEvent(aUnit, 13); -- VUHDO_UPDATE_MANA
		end
	end
end



--
local tAllButtons, tButton, tManaBar, tHealthBar, tQuota;
local tManaBarHeight;
local tRegularHeight;
function VUHDO_manaBarBouquetCallback(aUnit, anIsActive, anIcon, aCurrValue, aCounter, aMaxValue, aColor, aBuffName, aBouquetName)

	if (aMaxValue == nil or aCurrValue == nil) then
		anIsActive = false;
	end
	aMaxValue = aMaxValue or 0;
	aCurrValue = aCurrValue or 0;

	if (aMaxValue + aCurrValue == 0) then
		anIsActive = false;
	end

	tManaBarHeight = 0;
	tAllButtons =  VUHDO_getUnitButtons(aUnit);
	tQuota = (aCurrValue == 0 and aMaxValue == 0) and 0
		or aMaxValue > 1 and aCurrValue / aMaxValue
		or 0;

	if (tAllButtons ~= nil) then
		for _, tButton in pairs(tAllButtons) do
			if (anIsActive) then
				tManaBarHeight = VUHDO_PANEL_SETUP[VUHDO_BUTTON_CACHE[tButton]]["SCALING"]["manaBarHeight"];
			end
			tManaBar = VUHDO_getHealthBar(tButton, 2);
			if (tQuota > 0 and tManaBarHeight > 0) then
				if (aColor ~= nil) then
					tManaBar:SetVuhDoColor(aColor);
				end
				tManaBar:SetValue(tQuota);
			else
				tManaBar:SetValue((not anIsActive and sIsInverted) and 1 or 0);
			end

			if (not InCombatLockdown()) then
				if (tManaBarHeight > 0) then
					tManaBar:SetHeight(tManaBarHeight);
				end
				tRegularHeight = tButton["regularHeight"];
				if (tRegularHeight ~= nil) then
					VUHDO_getHealthBar(tButton, 1):SetHeight(tRegularHeight - tManaBarHeight);
				end
			end
		end
	end

	if (VUHDO_RAID[aUnit] == nil) then
		return;
	end

	-- Targets und targets-of-target, die im Raid sind
	tAllButtons = VUHDO_IN_RAID_TARGET_BUTTONS[VUHDO_RAID[aUnit]["name"]];
	if (tAllButtons == nil) then
		return;
	end
	for _, tButton in pairs(tAllButtons) do
		tManaBar = VUHDO_getHealthBar(tButton, 2);
		if (tQuota > 0) then
			if (aColor ~= nil) then
				tManaBar:SetVuhDoColor(aColor);
			end
			tManaBar:SetValue(tQuota);
		else
			tManaBar:SetValue(0);
		end
		if (not InCombatLockdown()) then
			tManaBarHeight = VUHDO_PANEL_SETUP[VUHDO_BUTTON_CACHE[tButton]]["SCALING"]["manaBarHeight"];
			tManaBar:SetHeight(tManaBarHeight);
			tRegularHeight = tButton["regularHeight"];
			if (tRegularHeight ~= nil) then
				VUHDO_getHealthBar(tButton, 1):SetHeight(tRegularHeight - tManaBarHeight);
			end
		end
	end
end



--
local tQuota, tAllButtons, tBar, tButton;
function VUHDO_sideBarLeftBouquetCallback(aUnit, anIsActive, anIcon, aCurrValue, aCounter, aMaxValue, aColor, aBuffName, aBouquetName)
	tQuota = (aCurrValue == 0 and aMaxValue == 0) and 0
		or (aMaxValue or 0) > 1 and aCurrValue / aMaxValue
		or 0;

	tAllButtons = VUHDO_getUnitButtons(aUnit);
	if (tAllButtons ~= nil) then
		for _, tButton in pairs(tAllButtons) do
			if (tQuota > 0) then
				tBar = VUHDO_getHealthBar(tButton, 17);
				tBar:SetValue(tQuota);
				tBar:SetVuhDoColor(aColor);
			else
				VUHDO_getHealthBar(tButton, 17):SetValue(0);
			end
		end
	end
end



--
local tQuota, tAllButtons, tBar, tButton;
function VUHDO_sideBarRightBouquetCallback(aUnit, anIsActive, anIcon, aCurrValue, aCounter, aMaxValue, aColor, aBuffName, aBouquetName)
	tQuota = (aCurrValue == 0 and aMaxValue == 0) and 0
		or (aMaxValue or 0) > 1 and aCurrValue / aMaxValue
		or 0;

	tAllButtons = VUHDO_getUnitButtons(aUnit);
	if (tAllButtons ~= nil) then
		for _, tButton in pairs(tAllButtons) do
			if (tQuota > 0) then
				tBar = VUHDO_getHealthBar(tButton, 18);
				tBar:SetValue(tQuota);
				tBar:SetVuhDoColor(aColor);
			else
				VUHDO_getHealthBar(tButton, 18):SetValue(0);
			end
		end
	end
end
