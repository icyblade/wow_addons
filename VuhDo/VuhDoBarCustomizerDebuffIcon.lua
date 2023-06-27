VUHDO_MAY_DEBUFF_ANIM = true;

local VUHDO_DEBUFF_ICONS = { };
local sIsName;

-- BURST CACHE ---------------------------------------------------

local floor = floor;
local GetTime = GetTime;
local pairs = pairs;
local twipe = table.wipe;
local _;

local VUHDO_GLOBAL = getfenv();

local VUHDO_getUnitButtons;
local VUHDO_getBarIconTimer
local VUHDO_getBarIconCounter;
local VUHDO_getBarIconFrame;
local VUHDO_getBarIcon;
local VUHDO_getBarIconName;
local VUHDO_getShieldPerc;

local VUHDO_CONFIG;
local sCuDeStoredSettings;
local sMaxIcons;
local sStaticConfig;

local sEmpty = { };

function VUHDO_customDebuffIconsInitBurst()
	-- functions
	VUHDO_getUnitButtons = VUHDO_GLOBAL["VUHDO_getUnitButtons"];
	VUHDO_getBarIconTimer = VUHDO_GLOBAL["VUHDO_getBarIconTimer"];
	VUHDO_getBarIconCounter = VUHDO_GLOBAL["VUHDO_getBarIconCounter"];
	VUHDO_getBarIconFrame = VUHDO_GLOBAL["VUHDO_getBarIconFrame"];
	VUHDO_getBarIcon = VUHDO_GLOBAL["VUHDO_getBarIcon"];
	VUHDO_getBarIconName = VUHDO_GLOBAL["VUHDO_getBarIconName"];
	VUHDO_getShieldPerc = VUHDO_GLOBAL["VUHDO_getShieldPerc"];

	VUHDO_CONFIG = VUHDO_GLOBAL["VUHDO_CONFIG"];
	sCuDeStoredSettings = VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"];
	sMaxIcons = VUHDO_CONFIG["CUSTOM_DEBUFF"]["max_num"];
	if (sMaxIcons < 1) then -- Damit das Bouquet item "Letzter Debuff" funktioniert
		sMaxIcons = 1;
	end
	sIsName = VUHDO_CONFIG["CUSTOM_DEBUFF"]["isName"];

	sStaticConfig = {
		["animate"] = VUHDO_CONFIG["CUSTOM_DEBUFF"]["animate"],
		["timer"] = VUHDO_CONFIG["CUSTOM_DEBUFF"]["timer"],
		["isStacks"] = VUHDO_CONFIG["CUSTOM_DEBUFF"]["isStacks"],
		["isAliveTime"] = false,
		["isFullDuration"] = false
	};

end

----------------------------------------------------

--
local tAliveTime;
local tRemain;
local tStacks;
local tCuDeStoConfig;
local tNameLabel;
local tTimeStamp;
local tShieldPerc;
local tName;
local tButton;
local tIsAnim;
local function VUHDO_animateDebuffIcon(aButton, anIconInfo, aNow, anIconIndex, anIsInit, aUnit)

	tCuDeStoConfig = sCuDeStoredSettings[anIconInfo[3]] or sStaticConfig;
	tIsAnim = tCuDeStoConfig["animate"] and VUHDO_MAY_DEBUFF_ANIM;
	tTimeStamp = anIconInfo[2];
	tAliveTime = anIsInit and 0 or aNow - tTimeStamp;
	tName = anIconInfo[3];

	if (tCuDeStoConfig["timer"]) then
		if (tCuDeStoConfig["isAliveTime"]) then
			VUHDO_getBarIconTimer(aButton, anIconIndex):SetText(tAliveTime < 99.5 and floor(tAliveTime + 0.5) or ">>");
		else
			tRemain = (anIconInfo[4] or aNow - 1) - aNow;

			if (tRemain >= 0 and (tRemain < 10 or tCuDeStoConfig["isFullDuration"])) then
				VUHDO_getBarIconTimer(aButton, anIconIndex):SetText(tRemain > 100 and ">>" or floor(tRemain));
			else
				VUHDO_getBarIconTimer(aButton, anIconIndex):SetText("");
			end
		end
	end

	tShieldPerc = VUHDO_getShieldPerc(aUnit, tName);
	tStacks = tShieldPerc ~= 0 and tShieldPerc or anIconInfo[5] or 0;

	VUHDO_getBarIconCounter(aButton, anIconIndex):SetText((tCuDeStoConfig["isStacks"] and tStacks > 1) and tStacks or "");

	if (anIsInit) then
		VUHDO_getBarIcon(aButton, anIconIndex):SetTexture(anIconInfo[1]);
		if (sIsName) then
			tNameLabel = VUHDO_getBarIconName(aButton, anIconIndex);
			tNameLabel:SetText(tName);
			tNameLabel:SetAlpha(1);
		end
		VUHDO_getBarIconFrame(aButton, anIconIndex):SetAlpha(1);

		if (tIsAnim) then
			VUHDO_setDebuffAnimation(1.2);
		end
	end

	if (tIsAnim) then
		tButton = VUHDO_getBarIconButton(aButton, anIconIndex);
		if (tAliveTime <= 0.4) then
			tButton:SetScale(1 + tAliveTime * 2.5);
		elseif (tAliveTime <= 0.6) then
			 -- Keep size
		elseif (tAliveTime <= 1.1) then
			tButton:SetScale(3.2 - 2 * tAliveTime);
		elseif (tButton:GetScale() ~= 1) then
			tButton:SetScale(1);
		end
	end

	if (sIsName and tAliveTime > 2) then
		VUHDO_getBarIconName(aButton, anIconIndex):SetAlpha(0);
	end
end



--
local tUnit, tAllDebuffInfos;
local tIndex, tDebuffInfo;
local tAllButtons, tButton;
local tNow;
function VUHDO_updateAllDebuffIcons(anIsFrequent)
	tNow = GetTime();

	for tUnit, tAllDebuffInfos in pairs(VUHDO_DEBUFF_ICONS) do

		tAllButtons = VUHDO_getUnitButtons(tUnit);
		if (tAllButtons ~= nil) then

			for tIndex, tDebuffInfo in pairs(tAllDebuffInfos) do
				if (not anIsFrequent or (anIsFrequent and tDebuffInfo[2] + 1.21 >= tNow)) then
					for _, tButton in pairs(tAllButtons) do
						VUHDO_animateDebuffIcon(tButton, tDebuffInfo, tNow, tIndex + 39, false, tUnit);
					end
				end
			end

		end

	end
end



-- 1 = icon, 2 = timestamp, 3 = name, 4 = expiration time, 5 = stacks, 6 = Duration, 7 = Start time
local tCnt;
local tSlot;
local tOldest;
local tTimestamp;
local tAllButtons, tButton, tFrame, tIconInfo;
function VUHDO_addDebuffIcon(aUnit, anIcon, aName, anExpiry, aStacks, aDuration, anIsBuff)
	if (VUHDO_DEBUFF_ICONS[aUnit] == nil) then
		VUHDO_DEBUFF_ICONS[aUnit] = { };
	end

	tOldest = GetTime();
	tSlot = 1;
	for tCnt = 1, sMaxIcons do
		if (VUHDO_DEBUFF_ICONS[aUnit][tCnt] == nil) then
			tSlot = tCnt;
			break;
		else
			tTimestamp = VUHDO_DEBUFF_ICONS[aUnit][tCnt][2];
			if (tTimestamp > 0 and tTimestamp < tOldest) then
				tOldest = tTimestamp;
				tSlot = tCnt;
			end
		end
	end
	tIconInfo = { anIcon, -1, aName, anExpiry, aStacks, aDuration }
	VUHDO_DEBUFF_ICONS[aUnit][tSlot] = tIconInfo;

	tAllButtons = VUHDO_getUnitButtons(aUnit);
	if (tAllButtons ~= nil) then
		for _, tButton in pairs(tAllButtons) do
			VUHDO_animateDebuffIcon(tButton, tIconInfo, GetTime(), tSlot + 39, true, aUnit);
			tFrame = VUHDO_getBarIconFrame(tButton, tSlot + 39);
			tFrame["debuffInfo"], tFrame["isBuff"] = aName, anIsBuff;
		end
	end
	tIconInfo[2] = GetTime();

	VUHDO_updateHealthBarsFor(aUnit, VUHDO_UPDATE_RANGE);
end



--
local tCnt, tIconInfo;
function VUHDO_updateDebuffIcon(aUnit, anIcon, aName, anExpiry, aStacks, aDuration)
	if (VUHDO_DEBUFF_ICONS[aUnit] == nil) then
		VUHDO_DEBUFF_ICONS[aUnit] = { };
	end

	for tCnt = 1, sMaxIcons do
		tIconInfo = VUHDO_DEBUFF_ICONS[aUnit][tCnt];

		if (tIconInfo ~= nil and tIconInfo[3] == aName) then
			tIconInfo[4], tIconInfo[5], tIconInfo[6] = anExpiry, aStacks, aDuration;
		end
	end
end



--
local tAllButtons2, tCnt2, tButton2;
local tFrame;
function VUHDO_removeDebuffIcon(aUnit, aName)
	tAllButtons2 = VUHDO_getUnitButtons(aUnit);
	if (tAllButtons2 == nil) then
		return;
	end

	for tCnt2 = 1, sMaxIcons do
		if ((VUHDO_DEBUFF_ICONS[aUnit][tCnt2] or sEmpty)[3] == aName) then
			VUHDO_DEBUFF_ICONS[aUnit][tCnt2][2] = 1; -- ~= -1, lock icon to not be processed by onupdate
			for _, tButton2 in pairs(tAllButtons2) do
				tFrame = VUHDO_getBarIconFrame(tButton2, tCnt2 + 39);
				tFrame:SetAlpha(0);
				tFrame["debuffInfo"] = nil;
			end

			twipe(VUHDO_DEBUFF_ICONS[aUnit][tCnt2]);
			VUHDO_DEBUFF_ICONS[aUnit][tCnt2] = nil;
		end
	end
end



--
local tAllButtons3, tCnt3, tButton3;
local tFrame;
function VUHDO_removeAllDebuffIcons(aUnit)
	tAllButtons3 = VUHDO_getUnitButtons(aUnit);
	if (tAllButtons3 == nil) then
		return;
	end

	for _, tButton3 in pairs(tAllButtons3) do
		for tCnt3 = 40, 39 + sMaxIcons do
			tFrame = VUHDO_getBarIconFrame(tButton3, tCnt3);
			tFrame:SetAlpha(0);
			tFrame["debuffInfo"] = nil;
		end
	end

	if (VUHDO_DEBUFF_ICONS[aUnit] ~= nil) then
		twipe(VUHDO_DEBUFF_ICONS[aUnit]);
	end

	VUHDO_updateBouquetsForEvent(aUnit, 29);
end



--
local tDebuffInfo;
local tCnt;
local tCurrInfo;
function VUHDO_getLatestCustomDebuff(aUnit)
	tDebuffInfo = sEmpty;

	for tCnt = 1, sMaxIcons do
	  tCurrInfo = (VUHDO_DEBUFF_ICONS[aUnit] or sEmpty)[tCnt];
		if (tCurrInfo ~= nil and tCurrInfo[2] > (tDebuffInfo[2] or 0)) then
			tDebuffInfo = tCurrInfo;
		end
	end

	return tDebuffInfo[1], tDebuffInfo[4], tDebuffInfo[5], tDebuffInfo[6];
end
