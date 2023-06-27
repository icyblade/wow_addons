local VUHDO_IN_RAID_TARGETS = { };
VUHDO_IN_RAID_TARGET_BUTTONS = { };
local VUHDO_IN_RAID_TARGET_BUTTONS = VUHDO_IN_RAID_TARGET_BUTTONS;
local VUHDO_TOT_GUIDS = { };


-------------------------------------------------
local UnitClass = UnitClass;
local UnitPowerType = UnitPowerType;
local UnitHealthMax = UnitHealthMax;
local UnitHealth = UnitHealth;
local UnitName = UnitName;
local UnitMana = UnitMana;
local UnitManaMax = UnitManaMax;
local UnitIsDeadOrGhost = UnitIsDeadOrGhost;
local UnitIsConnected = UnitIsConnected;
local UnitIsUnit = UnitIsUnit;
local UnitExists = UnitExists;
local UnitCreatureType = UnitCreatureType;
local CheckInteractDistance = CheckInteractDistance;
local strfind = strfind;
local gsub = gsub;
local GetRaidTargetIndex = GetRaidTargetIndex;
local tonumber = tonumber;
local pairs = pairs;
local tostring = tostring;
local twipe = table.wipe;
local _ = _;


local VUHDO_CUSTOM_INFO;
local VUHDO_CLASS_IDS;

local VUHDO_getHealthBar;
local VUHDO_customizeText;
local VUHDO_setRaidTargetIconTexture
local VUHDO_RAID;
local VUHDO_getUnitButtons;
local VUHDO_getTargetButton;
local VUHDO_getTotButton;
local VUHDO_PANEL_SETUP;
local VUHDO_getTargetBarRoleIcon;
local VUHDO_POWER_TYPE_COLORS;
local VUHDO_BUTTON_CACHE;
local VUHDO_getUnitZoneName;
local VUHDO_getDisplayUnit;
local VUHDO_textColor;

local sOOROpacity;

function VUHDO_customTargetInitBurst()
	VUHDO_CUSTOM_INFO = VUHDO_GLOBAL["VUHDO_CUSTOM_INFO"];
	VUHDO_CLASS_IDS = VUHDO_GLOBAL["VUHDO_CLASS_IDS"];

	VUHDO_getHealthBar = VUHDO_GLOBAL["VUHDO_getHealthBar"];
	VUHDO_customizeText = VUHDO_GLOBAL["VUHDO_customizeText"];
	VUHDO_setRaidTargetIconTexture = VUHDO_GLOBAL["VUHDO_setRaidTargetIconTexture"];
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];
	VUHDO_getUnitButtons = VUHDO_GLOBAL["VUHDO_getUnitButtons"];
	VUHDO_getTargetButton = VUHDO_GLOBAL["VUHDO_getTargetButton"];
	VUHDO_getTotButton = VUHDO_GLOBAL["VUHDO_getTotButton"];
	VUHDO_BUTTON_CACHE = VUHDO_GLOBAL["VUHDO_BUTTON_CACHE"];
	VUHDO_PANEL_SETUP = VUHDO_GLOBAL["VUHDO_PANEL_SETUP"];
	VUHDO_getTargetBarRoleIcon = VUHDO_GLOBAL["VUHDO_getTargetBarRoleIcon"];
	VUHDO_POWER_TYPE_COLORS =  VUHDO_GLOBAL["VUHDO_POWER_TYPE_COLORS"];
	VUHDO_getUnitZoneName = VUHDO_GLOBAL["VUHDO_getUnitZoneName"];
	VUHDO_getDisplayUnit = VUHDO_GLOBAL["VUHDO_getDisplayUnit"];
	VUHDO_textColor = VUHDO_GLOBAL["VUHDO_textColor"];

	if (VUHDO_PANEL_SETUP["BAR_COLORS"]["OUTRANGED"]["useOpacity"]) then
		sOOROpacity = VUHDO_PANEL_SETUP["BAR_COLORS"]["OUTRANGED"]["O"];
	else
		sOOROpacity = 1;
	end
end
------------------------------------------------------------------


--
local tManaBar;
local tInfo;
local function VUHDO_customizeManaBar(aButton)

	_, tInfo = VUHDO_getDisplayUnit(aButton);

	if (tInfo["connected"]) then
		tManaBar = VUHDO_getHealthBar(aButton, 2);
		tManaBar:SetValue(tInfo["powermax"] < 2 and 0 or tInfo["power"] / tInfo["powermax"]); -- Some addons return 1 mana-max instead of zero
		tManaBar:SetVuhDoColor(VUHDO_POWER_TYPE_COLORS[tInfo["powertype"]]);
	else
		VUHDO_getHealthBar(aButton, 2):SetValue(0);
	end
end



--
local tInfo;
local tLocalClass, tClassName;
local tPowerType;
local tName;
local function VUHDO_fillCustomInfo(aUnit)
	tLocalClass, tClassName = UnitClass(aUnit);
	tPowerType = UnitPowerType(aUnit);
	tName = UnitName(aUnit);

	tInfo = VUHDO_CUSTOM_INFO;
	tInfo["healthmax"] = UnitHealthMax(aUnit);
	tInfo["health"] = UnitHealth(aUnit);
	tInfo["name"] = tName;
	tInfo["unit"] = aUnit;
	tInfo["class"] = tClassName;
	tInfo["powertype"] = tonumber(tPowerType);
	tInfo["power"] = UnitMana(aUnit);
	tInfo["powermax"] = UnitManaMax(aUnit);
	tInfo["dead"] = UnitIsDeadOrGhost(aUnit);
	tInfo["connected"] = UnitIsConnected(aUnit);
	if (tLocalClass == tName) then
		tInfo["className"] = UnitCreatureType(aUnit) or "";
	else
		tInfo["className"] = tLocalClass or "";
	end
	tInfo["classId"] = VUHDO_CLASS_IDS[tClassName];
	tInfo["fullName"] = tName;
	tInfo["zone"], tInfo["map"] = (VUHDO_RAID["player"] or { })["zone"], (VUHDO_RAID["player"] or { })["map"];
	tInfo["fixResolveId"] = nil;

	tInfo["raidIcon"] = GetRaidTargetIndex(aUnit);
end



--
local tBar;
local tQuota;
local function VUHDO_targetHealthBouquetCallback(aButton, aUnit, anIsActive, anIcon, aCurrValue, aCounter, aMaxValue, aColor, aBuffName, aBouquetName)

	tQuota = anIsActive and (aMaxValue or 0) > 0
		and aCurrValue / aMaxValue or 0;

	if (tQuota > 0) then
		tBar = VUHDO_getHealthBar(aButton, 1);
		tBar:SetValue(tQuota);
		tBar:SetVuhDoColor(aColor);
		VUHDO_getBarText(tBar):SetTextColor(VUHDO_textColor(aColor));
		VUHDO_getLifeText(tBar):SetTextColor(VUHDO_textColor(aColor));
		aButton:SetAlpha(1);
	else
		aButton:SetAlpha(0);
	end
end



--
local tTexture;
local tIconIdx;
function VUHDO_customizeTargetBar(aButton, aUnit, anIsInRange)
	VUHDO_CUSTOM_INFO["range"] = anIsInRange;
	VUHDO_invokeCustomBouquet(aButton, aUnit, VUHDO_RAID[aUnit] or VUHDO_CUSTOM_INFO, VUHDO_I18N_DEF_BOUQUET_TARGET_HEALTH, VUHDO_targetHealthBouquetCallback);
	VUHDO_customizeText(aButton, 1, true); -- VUHDO_UPDATE_ALL
	VUHDO_customizeManaBar(aButton, true);

	tIconIdx = GetRaidTargetIndex(aUnit);
	if (not VUHDO_PANEL_SETUP[VUHDO_BUTTON_CACHE[aButton]]["RAID_ICON"]["show"]
		or not VUHDO_PANEL_SETUP["RAID_ICON_FILTER"][tIconIdx]) then
		tIconIdx = nil;
	end

	if (tIconIdx ~= nil) then
		tTexture = VUHDO_getTargetBarRoleIcon(aButton, 50);
		VUHDO_setRaidTargetIconTexture(tTexture, tIconIdx);
		tTexture:Show();
	else
		VUHDO_getTargetBarRoleIcon(aButton, 50):Hide();
	end
end
local VUHDO_customizeTargetBar = VUHDO_customizeTargetBar;



-- Wir merken uns die Target-Buttons, wenn das Ziel im Raid ist,
-- um Gesundheitsupdates mit dem regulären Mechanismus durchzuführen
-- die Target-Buttons sind also durch den Target-Namen indiziert.
local tUnit, tInfo;
local tName;
local function VUHDO_rememberTargetButton(aTargetUnit, aButton)
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if (UnitIsUnit(tUnit, aTargetUnit)) then
			tName = tInfo["name"];
			if (VUHDO_IN_RAID_TARGET_BUTTONS[tName] == nil) then
				VUHDO_IN_RAID_TARGET_BUTTONS[tName] = { };
			end

			VUHDO_IN_RAID_TARGET_BUTTONS[tName][aButton] = aButton;
			VUHDO_IN_RAID_TARGETS[aTargetUnit] = tName;
			break;
		end
	end
end



-- Lösche alle Target-Buttons der Person, deren Ziel sich geändert hat
-- Wobei die Buttons mit dem Namen des TARGETS indiziert sind, welchen
-- wir uns VUHDO_IN_RAID_TARGETS aber gemerkt haben
local tName;
local function VUHDO_forgetTargetButton(aTargetUnit, aButton)
	tName = VUHDO_IN_RAID_TARGETS[aTargetUnit];
	if (tName ~= nil) then
		if (VUHDO_IN_RAID_TARGET_BUTTONS[tName] == nil) then
			VUHDO_IN_RAID_TARGET_BUTTONS[tName] = { };
		end
		VUHDO_IN_RAID_TARGET_BUTTONS[tName][aButton] = nil;
	end
end



--
local tTargetButton, tTotButton, tInfo;
local tAllButtons;
local tButton;
local tTarget;
local tTargetOfTarget;
local tIcon;
local tPanelNum;
function VUHDO_updateTargetBars(aUnit)
	if (strfind(aUnit, "target", 1, true) and aUnit ~= "target") then
		aUnit = gsub(aUnit, "target", "");
	end

	tAllButtons = VUHDO_getUnitButtons(aUnit);
	if (tAllButtons == nil) then
		return;
	end

	tTarget = aUnit .. "target";
	tTargetOfTarget = tTarget .. "target";

	for _, tButton in pairs(tAllButtons) do
		VUHDO_forgetTargetButton(tTarget, VUHDO_getTargetButton(tButton));
		VUHDO_forgetTargetButton(tTargetOfTarget, VUHDO_getTotButton(tButton));
	end

	VUHDO_IN_RAID_TARGETS[tTarget] = nil;
	VUHDO_IN_RAID_TARGETS[tTargetOfTarget] = nil;

	if (not UnitExists(tTarget)) then
		for _, tButton in pairs(tAllButtons) do
			VUHDO_getTargetButton(tButton):SetAlpha(0);
			VUHDO_getTotButton(tButton):SetAlpha(0);
		end

		return;
	end

	-- Target
	VUHDO_fillCustomInfo(tTarget);

	for _, tButton in pairs(tAllButtons) do
		if (VUHDO_PANEL_SETUP[VUHDO_BUTTON_CACHE[tButton]]["SCALING"]["showTarget"]) then
			tTargetButton = VUHDO_getTargetButton(tButton);
			VUHDO_customizeTargetBar(tTargetButton, tTarget, CheckInteractDistance(tTarget, 1));
			tTargetButton:SetAlpha(1);
			VUHDO_rememberTargetButton(tTarget, tTargetButton);
		end
	end

	-- Target-of-target
	if (not UnitExists(tTargetOfTarget)) then
		for _, tButton in pairs(tAllButtons) do
			VUHDO_getTotButton(tButton):SetAlpha(0);
		end
		return;
	end

	VUHDO_fillCustomInfo(tTargetOfTarget);

	for _, tButton in pairs(tAllButtons) do
		if (VUHDO_PANEL_SETUP[VUHDO_BUTTON_CACHE[tButton]]["SCALING"]["showTot"]) then
			tTotButton = VUHDO_getTotButton(tButton);
			VUHDO_customizeTargetBar(tTotButton, tTargetOfTarget, CheckInteractDistance(tTargetOfTarget, 1));
			tTotButton:SetAlpha(1);
			VUHDO_rememberTargetButton(tTargetOfTarget, tTotButton);
		end
	end
end
local VUHDO_updateTargetBars = VUHDO_updateTargetBars;



--
local tUnit;
function VUHDO_rebuildTargets()
	if (not VUHDO_INTERNAL_TOGGLES[22]) then -- VUHDO_UPDATE_UNIT_TARGET
		return;
	end

	twipe(VUHDO_IN_RAID_TARGETS);
	twipe(VUHDO_IN_RAID_TARGET_BUTTONS);
	twipe(VUHDO_TOT_GUIDS);

	for tUnit, _ in pairs(VUHDO_RAID) do
		VUHDO_updateTargetBars(tUnit);
	end
end



--
local tButton, tTotUnit, tGuid;
local tAllButtons;
local tButton;
local function VUHDO_updateTargetHealth(aUnit, aTargetUnit)
	tAllButtons = VUHDO_getUnitButtons(aUnit);
	if (tAllButtons == nil) then
		return;
	end

	if (VUHDO_IN_RAID_TARGETS[aTargetUnit] == nil)  then
		VUHDO_fillCustomInfo(aTargetUnit);
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeTargetBar(VUHDO_getTargetButton(tButton), aTargetUnit, CheckInteractDistance(aTargetUnit, 1));
		end
	end

	tTotUnit = aTargetUnit .. "target";

	tGuid = UnitGUID(tTotUnit);
	if (VUHDO_TOT_GUIDS[aUnit] ~= tGuid) then
		VUHDO_updateTargetBars(aUnit);
		VUHDO_TOT_GUIDS[aUnit] = tGuid;
	elseif (VUHDO_IN_RAID_TARGETS[tTotUnit] == nil and UnitExists(tTotUnit))  then
		VUHDO_fillCustomInfo(tTotUnit);
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeTargetBar(VUHDO_getTotButton(tButton), tTotUnit, CheckInteractDistance(tTotUnit, 1));
		end
	end
end



--
local tUnit, tInfo;
function VUHDO_updateAllOutRaidTargetButtons()
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if (UnitExists(tInfo["targetUnit"])) then
			VUHDO_updateTargetHealth(tUnit, tInfo["targetUnit"]);
		end
	end
end
