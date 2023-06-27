local sIsFade;
local sIsWarnColor;
local sIsSwiftmend;
local sHotSetup;
local sBuffs2Hots = { };
local sHotCols;
local sHotSlots;
local sBarColors;
local sIsHotShowIcon;
local sHotSlotCfgs;
local sIsChargesIcon;
local sClipL, sClipR, sClipT, sClipB = 0, 1, 0, 1;

local VUHDO_KNOWS_SWIFTMEND = false;
local VUHDO_SWIFTMEND_UNITS = { };
local VUHDO_FLASHING_ICONS = { };

VUHDO_MY_HOTS = { };
local VUHDO_MY_HOTS = VUHDO_MY_HOTS;
VUHDO_OTHER_HOTS = { };
local VUHDO_OTHER_HOTS = VUHDO_OTHER_HOTS;
VUHDO_MY_AND_OTHERS_HOTS = { };
local VUHDO_MY_AND_OTHERS_HOTS = VUHDO_MY_AND_OTHERS_HOTS;

local VUHDO_ACTIVE_HOTS = { };
local VUHDO_ACTIVE_HOTS_OTHERS = { };
local sOthersHotsInfo = { };

local VUHDO_CHARGE_TEXTURES = {
	"Interface\\AddOns\\VuhDo\\Images\\hot_stacks1",
	"Interface\\AddOns\\VuhDo\\Images\\hot_stacks2",
	"Interface\\AddOns\\VuhDo\\Images\\hot_stacks3",
	"Interface\\AddOns\\VuhDo\\Images\\hot_stacks4",
};

local VUHDO_SHIELD_TEXTURES = {
	"Interface\\AddOns\\VuhDo\\Images\\shield_stacks1",
	"Interface\\AddOns\\VuhDo\\Images\\shield_stacks2",
	"Interface\\AddOns\\VuhDo\\Images\\shield_stacks3",
	"Interface\\AddOns\\VuhDo\\Images\\shield_stacks4",
};

local VUHDO_CHARGE_COLORS = {
	"HOT_CHARGE_1",
	"HOT_CHARGE_2",
	"HOT_CHARGE_3",
	"HOT_CHARGE_4",
};

local VUHDO_HOT_CFGS = {
	"HOT1",
	"HOT2",
	"HOT3",
	"HOT4",
	"HOT5",
	"HOT6",
	"HOT7",
	"HOT8",
	"HOT9",
	"HOT10",
};

-- BURST CACHE -------------------------------------------------


local floor = floor;
local strlen = strlen;
local table = table;
local UnitBuff = UnitBuff;
local GetSpellCooldown = GetSpellCooldown;
local GetTime = GetTime;
local strfind = strfind;
local pairs = pairs;
local twipe = table.wipe;
local _ = _;
local tostring = tostring;

local VUHDO_GLOBAL = getfenv();

local VUHDO_getHealthBar;
local VUHDO_getBarRoleIcon;
local VUHDO_updateAllClusterIcons;
local VUHDO_shouldScanUnit;
local VUHDO_getShieldLeftCount;
local VUHDO_resolveVehicleUnit;
local VUHDO_isPanelVisible;
local VUHDO_getHealButton;
local VUHDO_getUnitButtons;
local VUHDO_getBarIcon;
local VUHDO_getBarIconTimer;
local VUHDO_getBarIconCounter;
local VUHDO_getBarIconCharge;
local VUHDO_getBarIconClockOrStub;
local VUHDO_backColor;
local VUHDO_textColor;

local VUHDO_PANEL_SETUP;
local VUHDO_CAST_ICON_DIFF;
local VUHDO_HEALING_HOTS;
local VUHDO_RAID;
local sIsClusterIcons;
local sIsOthersHots;
local sIsFlash;


local tCnt;
function VUHDO_customHotsInitBurst()
	-- variables
	VUHDO_PANEL_SETUP = VUHDO_GLOBAL["VUHDO_PANEL_SETUP"];
	VUHDO_CAST_ICON_DIFF = VUHDO_GLOBAL["VUHDO_CAST_ICON_DIFF"];
	VUHDO_HEALING_HOTS = VUHDO_GLOBAL["VUHDO_HEALING_HOTS"];
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];
	VUHDO_ACTIVE_HOTS = VUHDO_GLOBAL["VUHDO_ACTIVE_HOTS"];
	VUHDO_ACTIVE_HOTS_OTHERS = VUHDO_GLOBAL["VUHDO_ACTIVE_HOTS_OTHERS"];
	-- functions
	VUHDO_getUnitButtons = VUHDO_GLOBAL["VUHDO_getUnitButtons"];
	VUHDO_getHealthBar = VUHDO_GLOBAL["VUHDO_getHealthBar"];
	VUHDO_getBarRoleIcon = VUHDO_GLOBAL["VUHDO_getBarRoleIcon"];
	VUHDO_updateAllClusterIcons = VUHDO_GLOBAL["VUHDO_updateAllClusterIcons"];
	VUHDO_shouldScanUnit = VUHDO_GLOBAL["VUHDO_shouldScanUnit"];
	VUHDO_getShieldLeftCount = VUHDO_GLOBAL["VUHDO_getShieldLeftCount"];
	VUHDO_resolveVehicleUnit = VUHDO_GLOBAL["VUHDO_resolveVehicleUnit"];
	VUHDO_isPanelVisible = VUHDO_GLOBAL["VUHDO_isPanelVisible"];
	VUHDO_getHealButton = VUHDO_GLOBAL["VUHDO_getHealButton"];
	VUHDO_getBarIcon = VUHDO_GLOBAL["VUHDO_getBarIcon"];
	VUHDO_getBarIconTimer = VUHDO_GLOBAL["VUHDO_getBarIconTimer"];
	VUHDO_getBarIconCounter = VUHDO_GLOBAL["VUHDO_getBarIconCounter"];
	VUHDO_getBarIconCharge = VUHDO_GLOBAL["VUHDO_getBarIconCharge"];
	VUHDO_getBarIconClockOrStub = VUHDO_GLOBAL["VUHDO_getBarIconClockOrStub"];
	VUHDO_backColor = VUHDO_GLOBAL["VUHDO_backColor"];
	VUHDO_textColor = VUHDO_GLOBAL["VUHDO_textColor"];

	sBarColors = VUHDO_PANEL_SETUP["BAR_COLORS"];
	sHotCols = sBarColors["HOTS"];
	sIsFade = sHotCols["isFadeOut"];
	sIsFlash = sHotCols["isFlashWhenLow"];
	sIsWarnColor = sHotCols["WARNING"]["enabled"];
	sHotSetup = VUHDO_PANEL_SETUP["HOTS"];
	sHotSlots = VUHDO_PANEL_SETUP["HOTS"]["SLOTS"];
	sIsHotShowIcon = sHotSetup["iconRadioValue"] == 1;
	sIsChargesIcon = sHotSetup["stacksRadioValue"] == 3;
	sIsClusterIcons = VUHDO_INTERNAL_TOGGLES[16] or VUHDO_INTERNAL_TOGGLES[18]; -- -- VUHDO_UPDATE_NUM_CLUSTER -- VUHDO_UPDATE_MOUSEOVER_CLUSTER
	sIsOthersHots = VUHDO_ACTIVE_HOTS["OTHER"];

	sHotSlotCfgs = { };
	for tCnt = 1, 10 do
		sHotSlotCfgs[tCnt] = VUHDO_PANEL_SETUP["HOTS"]["SLOTCFG"][tostring(tCnt)];
	end
end

----------------------------------------------------



--
function VUHDO_hotsSetClippings(aLeft, aRight, aTop, aBottom)
	sClipL, sClipR, sClipT, sClipB = aLeft, aRight, aTop, aBottom;
end



--
local tOphEmpty = { nil, 0 };
function VUHDO_getOtherPlayersHotInfo(aUnit)
	return sOthersHotsInfo[aUnit] or tOphEmpty;
end



--
function VUHDO_setKnowsSwiftmend(aKnowsSwiftmend)
	VUHDO_KNOWS_SWIFTMEND = aKnowsSwiftmend;
end



--
--
local tCopy = { };
local function VUHDO_copyColor(aColor)
	tCopy["R"], tCopy["G"], tCopy["B"], tCopy["O"] = aColor["R"], aColor["G"], aColor["B"], aColor["O"];
	tCopy["TR"], tCopy["TG"], tCopy["TB"], tCopy["TO"] = aColor["TR"], aColor["TG"], aColor["TB"], aColor["TO"];
	tCopy["useBackground"], tCopy["useText"], tCopy["useOpacity"] = aColor["useBackground"], aColor["useText"], aColor["useOpacity"];
	return tCopy;
end



--
local tHotBar;
local function VUHDO_customizeHotBar(aButton, aRest, anIndex, aDuration, aColor)
	tHotBar = VUHDO_getHealthBar(aButton, anIndex + 3);

	if (aColor ~= nil) then
		tHotBar:SetVuhDoColor(aColor);
	end

	if ((aDuration or 0) == 0 or aRest == nil) then
		tHotBar:SetValue(0);
	else
		tHotBar:SetValue(aRest / aDuration);
	end
end



--
local tHotName;
local tDuration2;
local tChargeTexture;
local tIsChargeShown;
local tIcon;
local tTimer;
local tCounter;
local tClock;
local tDuration;
local tHotCfg;
local tIsChargeAlpha;
local tStarted;
local function VUHDO_customizeHotIcons(aButton, aHotName, aRest, aTimes, anIcon, aDuration, aShieldCharges, aColor, anIndex, aClipL, aClipR, aClipT, aClipB)

	tHotCfg = sBarColors[VUHDO_HOT_CFGS[anIndex]];
	tIcon = VUHDO_getBarIcon(aButton, anIndex);

	if (aRest == nil) then
		if (sIsFlash and (VUHDO_FLASHING_ICONS[aButton] or {})[anIndex]) then
			UIFrameFlashStop(tIcon);
			VUHDO_FLASHING_ICONS[aButton][anIndex] = nil;
		end
		VUHDO_getBarIconFrame(aButton, anIndex):Hide();
		return;
	else
		VUHDO_getBarIconFrame(aButton, anIndex):Show();
	end

	tTimer = VUHDO_getBarIconTimer(aButton, anIndex);
	tCounter = VUHDO_getBarIconCounter(aButton, anIndex);
	tClock = VUHDO_getBarIconClockOrStub(aButton, anIndex, tHotCfg["isClock"]);
	tChargeTexture = VUHDO_getBarIconCharge(aButton, anIndex);

	if (aColor ~= nil and aColor["useText"] and aColor["TR"] ~= nil) then
		tCounter:SetTextColor(VUHDO_textColor(aColor));
	end

	if (anIcon ~= nil and (sIsHotShowIcon or aColor ~= nil)) then
		tIcon:SetTexture(anIcon);
	end

	tIcon:SetTexCoord(aClipL or sClipL, aClipR or sClipR, aClipT or sClipT, aClipB or sClipB);
	aTimes = aTimes or 0;
	tIsChargeShown = sIsChargesIcon and aTimes > 0;

	if (aRest == 999) then -- Other players' HoTs
		if (aTimes > 0) then
			tIcon:SetAlpha(tHotCfg["O"]);
			tCounter:SetText(aTimes > 1 and aTimes or "");
		else
			if (sIsFlash and (VUHDO_FLASHING_ICONS[aButton] or {})[anIndex]) then
				UIFrameFlashStop(tIcon);
				VUHDO_FLASHING_ICONS[aButton][anIndex] = nil;
			end

			tIcon:SetAlpha(0);
			tCounter:SetText("");
		end
		tTimer:SetText("");
		tClock:SetAlpha(0);
		return;
	elseif (aRest > 0) then
		tIcon:SetAlpha((aRest < 10 and sIsFade) and tHotCfg["O"] * aRest * 0.1 or tHotCfg["O"]);

		if (aRest < 10 or tHotCfg["isFullDuration"]) then
			tDuration = (tHotCfg["countdownMode"] == 2 and aRest < sHotCols["WARNING"]["lowSecs"])
				and format("%.1f", aRest) or format("%d", aRest);
		else
			tDuration = (tHotCfg["O"] > 0 or tIsChargeShown) and "" or "X";
		end

		tTimer:SetText(tDuration);
		tStarted = floor(10 * (GetTime() - aDuration + aRest + 0.5)) * 0.1;
		if (tClock:GetAlpha() == 0 or (tClock:GetAttribute("started") or tStarted) ~= tStarted) then
			tClock:SetAlpha(1);
			tClock:SetCooldown(tStarted, aDuration);
			tClock:SetAttribute("started", tStarted);
		end
		tIcon:SetAlpha((sIsFade and aRest < 10) and tHotCfg["O"] * aRest * 0.1 or tHotCfg["O"]);

		if (aRest > 5) then
			if (sIsFlash and (VUHDO_FLASHING_ICONS[aButton] or {})[anIndex]) then
				UIFrameFlashStop(tIcon);
				VUHDO_FLASHING_ICONS[aButton][anIndex] = nil;
			end
			tTimer:SetTextColor(1, 1, 1, 1);
		else
			tDuration2 = aRest * 0.2;
			tTimer:SetTextColor(1, tDuration2, tDuration2, 1);
			if (sIsFlash) then
				if (VUHDO_FLASHING_ICONS[aButton] == nil) then
					VUHDO_FLASHING_ICONS[aButton] = { };
				end
				if (not VUHDO_FLASHING_ICONS[aButton][anIndex]) then
					VUHDO_FLASHING_ICONS[aButton][anIndex] = true;
					UIFrameFlash(tIcon, 0.2, 0.1, 5, true, 0, 0.1);
				end
			end
		end

		tCounter:SetText(aTimes > 1 and aTimes or "");
	else
		if (sIsFlash and (VUHDO_FLASHING_ICONS[aButton] or {})[anIndex]) then
			UIFrameFlashStop(tIcon);
			VUHDO_FLASHING_ICONS[aButton][anIndex] = nil;
		end
		tTimer:SetText("");
		tClock:SetAlpha(0);
		tIcon:SetAlpha(tHotCfg["O"]);
		tCounter:SetText(aTimes > 1 and aTimes or "");
	end

	--@TESTING
	--aTimes = floor(aRest / 3.5);

	if (aTimes > 4) then
		aTimes = 4;
	end

	tIsChargeAlpha = false;

	if (aColor ~= nil and (not aColor["isDefault"] or not sIsHotShowIcon)) then
		tHotColor = aColor;

		if (aTimes > 1) then
			tChargeColor = sBarColors[VUHDO_CHARGE_COLORS[aTimes]];
			if (sHotCols["useColorBack"]) then
				tHotColor["R"], tHotColor["G"], tHotColor["B"], tHotColor["O"]
					= tChargeColor["R"], tChargeColor["G"], tChargeColor["B"], tChargeColor["O"];
				tIsChargeAlpha = true;
			end
			if (sHotCols["useColorText"]) then
				tHotColor["TR"], tHotColor["TG"], tHotColor["TB"], tHotColor["TO"]
					= tChargeColor["TR"], tChargeColor["TG"], tChargeColor["TB"], tChargeColor["TO"];
			end
		end

		if (tHotColor["useText"] and not sIsHotShowIcon) then
			tTimer:SetTextColor(VUHDO_textColor(tHotColor));
		end

	elseif (sIsWarnColor and aRest < sHotCols["WARNING"]["lowSecs"]) then
		tHotColor = sHotCols["WARNING"];
		tTimer:SetTextColor(VUHDO_textColor(tHotColor));
	else
		tHotColor = VUHDO_copyColor(tHotCfg);
		if (sIsHotShowIcon) then
			tHotColor["R"], tHotColor["G"], tHotColor["B"] = 1, 1, 1;
		elseif (aTimes <= 1 or not sHotCols["useColorText"]) then
			tTimer:SetTextColor(VUHDO_textColor(tHotColor));
		end

		if (aTimes > 1) then
			tChargeColor = sBarColors[VUHDO_CHARGE_COLORS[aTimes]];
			if (sHotCols["useColorBack"]) then
				tHotColor["R"], tHotColor["G"], tHotColor["B"], tHotColor["O"]
					= tChargeColor["R"], tChargeColor["G"], tChargeColor["B"], tChargeColor["O"];
				tIsChargeAlpha = true;
			end
			if (sHotCols["useColorText"]) then
				tHotColor["TR"], tHotColor["TG"], tHotColor["TB"], tHotColor["TO"]
					= tChargeColor["TR"], tChargeColor["TG"], tChargeColor["TB"], tChargeColor["TO"];
				tTimer:SetTextColor(VUHDO_textColor(tHotColor));
			end
		end
	end

	tIcon:SetVertexColor(tHotColor["R"], tHotColor["G"], tHotColor["B"], tIsChargeAlpha and tHotColor["O"]);

	if (tIsChargeShown) then
		tChargeTexture:SetTexture(VUHDO_CHARGE_TEXTURES[aTimes]);
		if (tHotColor["R"]) then
			tChargeTexture:SetVertexColor(VUHDO_backColor(tHotColor));
		end
		tChargeTexture:Show();
	elseif (aShieldCharges > 0) then
		if (sIsHotShowIcon) then
			tHotColor = tHotCfg;
		end
		tChargeTexture:SetTexture(VUHDO_SHIELD_TEXTURES[aShieldCharges]);
		if (tHotColor["R"]) then
			tChargeTexture:SetVertexColor(tHotColor["R"] + 0.15, tHotColor["G"] + 0.15, tHotColor["B"] + 0.15, tHotColor["O"]);
		end
		tChargeTexture:Show();
	else
		tChargeTexture:Hide();
	end
end



--
local tAllButtons;
local tButton;
local tShieldCharges;
local tIsMatch;
local tIndex, tHotName;
local tIsMine, tIsOthers;
local function VUHDO_updateHotIcons(aUnit, aHotName, aRest, aTimes, anIcon, aDuration, aMode, aColor, aHotSpellName, aClipL, aClipR, aClipT, aClipB)
	tAllButtons = VUHDO_getUnitButtons(VUHDO_resolveVehicleUnit(aUnit));
	if (tAllButtons == nil) then
		return;
	end

	tShieldCharges = aMode ~= 2 and VUHDO_getShieldLeftCount(aUnit, aHotSpellName or aHotName) or 0; -- if not our shield don't show remaining absorption

	for tIndex, tHotName in pairs(sHotSlots) do
		if (aHotName == tHotName) then

			if (aMode == 0 or aColor ~= nil) then -- Bouquet => color ~= nil
				tIsMatch = true;
			else
				tIsMine, tIsOthers = sHotSlotCfgs[tIndex]["mine"], sHotSlotCfgs[tIndex]["others"];
				tIsMatch = (aMode == 1 and     tIsMine and not tIsOthers)
								or (aMode == 2 and not tIsMine and     tIsOthers)
								or (aMode == 3 and     tIsMine and     tIsOthers);
			end

			if (tIsMatch) then
				if (tIndex >= 6 and tIndex <= 8) then
					for _, tButton in pairs(tAllButtons) do
						VUHDO_customizeHotBar(tButton, aRest, tIndex, aDuration, aColor);
					end
				else
					for _, tButton in pairs(tAllButtons) do
						VUHDO_customizeHotIcons(tButton, aHotName, aRest, aTimes, anIcon, aDuration, tShieldCharges, aColor, tIndex, aClipL, aClipR, aClipT, aClipB);
					end
				end
			end
		end
	end

end



local tCnt;
local function VUHDO_removeButtonHots(aButton)
	for tCnt = 1, 5 do
		if (sIsFlash and (VUHDO_FLASHING_ICONS[aButton] or {})[tCnt]) then
			UIFrameFlashStop(VUHDO_getBarIcon(aButton, tCnt));
		end
		VUHDO_getBarIconFrame(aButton, tCnt):Hide();
	end

	for tCnt = 9, 10 do
		if (sIsFlash and (VUHDO_FLASHING_ICONS[aButton] or {})[tCnt]) then
			UIFrameFlashStop(VUHDO_getBarIcon(aButton, tCnt));
		end
		VUHDO_getBarIconFrame(aButton, tCnt):Hide();
	end

	for tCnt = 9, 11 do
		VUHDO_getHealthBar(aButton, tCnt):SetValue(0);
	end
	VUHDO_FLASHING_ICONS[aButton] = nil;
	VUHDO_getBarRoleIcon(aButton, 51):Hide(); -- Swiftmend indicator
end



--
local tButton, tAllButtons;
function VUHDO_removeHots(aUnit)
	tAllButtons = VUHDO_getUnitButtons(aUnit) or {};

	for _, tButton in pairs(tAllButtons) do
		VUHDO_removeButtonHots(tButton);
	end
end
local VUHDO_removeHots = VUHDO_removeHots;



--
local tCount;
local tHotInfo;
local tAlive;
local function VUHDO_snapshotHot(aHotName, aRest, aStacks, anIcon, anIsMine, aDuration, aUnit, anExpiry)

	aStacks = aStacks or 0;
	tCount = aStacks == 0 and 1 or aStacks;
	tAlive = GetTime() - anExpiry + (aDuration or 0);

	if (anIsMine) then
		if (VUHDO_MY_HOTS[aUnit][aHotName] == nil) then
			VUHDO_MY_HOTS[aUnit][aHotName] = { };
		end
		tHotInfo = VUHDO_MY_HOTS[aUnit][aHotName];
		tHotInfo[1], tHotInfo[2], tHotInfo[3], tHotInfo[4], tHotInfo[5] = aRest, aStacks, anIcon, aDuration, tAlive;
	elseif (VUHDO_ACTIVE_HOTS_OTHERS[aHotName]) then
		if (VUHDO_OTHER_HOTS[aUnit][aHotName] == nil) then
			VUHDO_OTHER_HOTS[aUnit][aHotName] = { };
		end
		tHotInfo = VUHDO_OTHER_HOTS[aUnit][aHotName];

		if (tHotInfo[1] == nil) then
			tHotInfo[1], tHotInfo[2], tHotInfo[3], tHotInfo[4], tHotInfo[5] = aRest, aStacks, anIcon, aDuration, tAlive;
		else
			if (aRest > tHotInfo[1]) then
				tHotInfo[1] = aRest;
			end

			tHotInfo[2] = tHotInfo[2] + tCount;
		end
	end

	if (VUHDO_MY_AND_OTHERS_HOTS[aUnit][aHotName] == nil) then
		VUHDO_MY_AND_OTHERS_HOTS[aUnit][aHotName] = { };
	end

	tHotInfo = VUHDO_MY_AND_OTHERS_HOTS[aUnit][aHotName];
	if (tHotInfo[1] == nil) then
		tHotInfo[1], tHotInfo[2], tHotInfo[3], tHotInfo[4], tHotInfo[5] = aRest, aStacks, anIcon, aDuration, tAlive;
	else
		if (anIsMine or aRest > tHotInfo[1]) then
			tHotInfo[1] = aRest;
		end

		tHotInfo[2] = tHotInfo[2] + tCount;
	end
end



local VUHDO_IGNORE_HOT_IDS = {
	[67358] = true, -- "Rejuvenating" proc has same name in russian and spanish as rejuvenation
}



--
function VUHDO_hotBouquetCallback(aUnit, anIsActive, anIcon, aTimer, aCounter, aDuration, aColor, aBuffName, aBouquetName, anImpact, aTimer2, aClipL, aClipR, aClipT, aClipB)
	VUHDO_updateHotIcons(aUnit, "BOUQUET_" .. (aBouquetName or ""), aTimer, aCounter, anIcon, aDuration, 0, aColor, aBuffName, aClipL, aClipR, aClipT, aClipB);
end



--
local tHotCmpName;
local tOtherHotCnt;
local tIconFound;
local tOtherIcon;
local tBuffIcon;
local tExpiry;
local tRest;
local tStacks;
local tCnt;
local tCaster;
local tBuffName;
local tStart, tEnabled;
local tSmDuration;
local tDiffIcon;
local tHotFromBuff;
local tIsCastByPlayer;
local tDuration;
local tHotInfo, tIndex;
local tSpellId, tDebuffOffset;
local tNow;
local tFilter;
local function VUHDO_updateHots(aUnit, anInfo)
	if (anInfo["isVehicle"]) then
		VUHDO_removeHots(aUnit);
		aUnit = anInfo["petUnit"];
		if (aUnit == nil) then -- bei z.B. focus/target
			return;
		end
	end

	if (VUHDO_MY_HOTS[aUnit] == nil) then
		VUHDO_MY_HOTS[aUnit] = { };
	end

	if (VUHDO_OTHER_HOTS[aUnit] == nil) then
		VUHDO_OTHER_HOTS[aUnit] = { };
	end

	if (VUHDO_MY_AND_OTHERS_HOTS[aUnit] == nil) then
		VUHDO_MY_AND_OTHERS_HOTS[aUnit] = { };
	end

	for tIndex, tHotInfo in pairs(VUHDO_MY_HOTS[aUnit]) do
		tHotInfo[1] = nil; -- Rest == nil => Icon löschen
	end

	for tIndex, tHotInfo in pairs(VUHDO_OTHER_HOTS[aUnit]) do
		tHotInfo[1] = nil;
	end

	for tIndex, tHotInfo in pairs(VUHDO_MY_AND_OTHERS_HOTS[aUnit]) do
		tHotInfo[1] = nil;
	end

	sIsSwiftmend = false;
	tOtherIcon = nil;
	tOtherHotCnt = 0;

	if (sOthersHotsInfo[aUnit] == nil) then
		sOthersHotsInfo[aUnit] = { nil, 0 };
	else
		sOthersHotsInfo[aUnit][1] = nil;
		sOthersHotsInfo[aUnit][2] = 0;
	end

	if (VUHDO_shouldScanUnit(aUnit)) then
		tNow = GetTime();
		tDebuffOffset = nil;
		for tCnt = 1, 255 do

			if (tDebuffOffset == nil) then
				tBuffName, _, tBuffIcon, tStacks, _, tDuration, tExpiry, tCaster, _, _, tSpellId = UnitBuff(aUnit, tCnt);
				if (tBuffIcon == nil) then
					tDebuffOffset = tCnt - 1;
				end
			end

			if (tDebuffOffset ~= nil) then -- Achtung kein elseif
				tBuffName, _, tBuffIcon, tStacks, _, tDuration, tExpiry, tCaster, _, _, tSpellId = UnitDebuff(aUnit, tCnt - tDebuffOffset);
				if (tBuffIcon == nil) then
					break;
				end
			end

			if (VUHDO_KNOWS_SWIFTMEND and not sIsSwiftmend) then
				if (VUHDO_SPELL_ID.REGROWTH == tBuffName or VUHDO_SPELL_ID.REJUVENATION == tBuffName) then
					tStart, tSmDuration, tEnabled = GetSpellCooldown(VUHDO_SPELL_ID.SWIFTMEND);
					if (tEnabled ~= 0 and (tStart == nil or tSmDuration == nil or tStart <= 0 or tSmDuration <= 1.6)) then
						sIsSwiftmend = true;
					end
				end
			end

			if ((tExpiry or 0) == 0) then
				tExpiry = (tNow + 9999);
			end
			tIsCastByPlayer = tCaster == "player" or tCaster == VUHDO_PLAYER_RAID_ID;
			tHotFromBuff = sBuffs2Hots[tBuffName .. tBuffIcon] or sBuffs2Hots[tSpellId];

			if (tHotFromBuff == "" or VUHDO_IGNORE_HOT_IDS[tSpellId]) then -- non hot buff
			elseif(tHotFromBuff ~= nil) then -- Hot buff cached
				tRest = tExpiry - tNow;
				if (tRest > 0) then
					VUHDO_snapshotHot(tHotFromBuff, tRest, tStacks, tBuffIcon, tIsCastByPlayer, tDuration, aUnit, tExpiry);
				end
			else -- not yet scanned
				sBuffs2Hots[tBuffName .. tBuffIcon] = "";
				sBuffs2Hots[tSpellId] = "";
				for tHotCmpName, _ in pairs(VUHDO_ACTIVE_HOTS) do
					tDiffIcon = VUHDO_CAST_ICON_DIFF[tHotCmpName];

					if (tDiffIcon == tBuffIcon
						or (tDiffIcon == nil and tBuffName == tHotCmpName)
						or tostring(tSpellId or -1) == tHotCmpName) then
						tRest = tExpiry - tNow;
						if (tRest > 0) then
							VUHDO_snapshotHot(tHotCmpName, tRest, tStacks, tBuffIcon, tIsCastByPlayer, tDuration, aUnit, tExpiry);
						end
						sBuffs2Hots[tBuffName .. tBuffIcon] = tHotCmpName;
						sBuffs2Hots[tSpellId] = tHotCmpName;
						break;
					end
				end
			end

			if (not tIsCastByPlayer and VUHDO_HEALING_HOTS[tBuffName] and not VUHDO_ACTIVE_HOTS_OTHERS[tBuffName]) then
				tOtherIcon = tBuffIcon;
				tOtherHotCnt = tOtherHotCnt + 1;
				sOthersHotsInfo[aUnit][1] = tOtherIcon;
				sOthersHotsInfo[aUnit][2] = tOtherHotCnt;
			end
		end

		-- Other players' HoTs
		if (sIsOthersHots) then
			VUHDO_updateHotIcons(aUnit, "OTHER", 999, tOtherHotCnt, tOtherIcon, nil, 0, nil, nil, nil, nil, nil, nil);
		end

		-- Clusters
		if (sIsClusterIcons) then
			VUHDO_updateAllClusterIcons(aUnit, anInfo);
		end

		if (VUHDO_KNOWS_SWIFTMEND) then
			VUHDO_SWIFTMEND_UNITS[aUnit] = sIsSwiftmend;
		end

	end -- Should scan unit

	-- Own
	for tHotCmpName, tHotInfo in pairs(VUHDO_MY_HOTS[aUnit]) do
		VUHDO_updateHotIcons(aUnit, tHotCmpName, tHotInfo[1], tHotInfo[2], tHotInfo[3], tHotInfo[4], 1, nil, nil, nil, nil, nil, nil);
		if (tHotInfo[1] == nil) then
			twipe(tHotInfo);
			VUHDO_MY_HOTS[aUnit][tHotCmpName] = nil;
		end
	end
	-- Others
	for tHotCmpName, tHotInfo in pairs(VUHDO_OTHER_HOTS[aUnit]) do
		VUHDO_updateHotIcons(aUnit, tHotCmpName, tHotInfo[1], tHotInfo[2], tHotInfo[3], tHotInfo[4], 2, nil, nil, nil, nil, nil, nil);
		if (tHotInfo[1] == nil) then
			twipe(tHotInfo);
			VUHDO_OTHER_HOTS[aUnit][tHotCmpName] = nil;
		end
	end
	-- Own+Others
	for tHotCmpName, tHotInfo in pairs(VUHDO_MY_AND_OTHERS_HOTS[aUnit]) do
		VUHDO_updateHotIcons(aUnit, tHotCmpName, tHotInfo[1], tHotInfo[2], tHotInfo[3], tHotInfo[4], 3, nil, nil, nil, nil, nil, nil);
		if (tHotInfo[1] == nil) then
			twipe(tHotInfo);
			VUHDO_MY_AND_OTHERS_HOTS[aUnit][tHotCmpName] = nil;
		end
	end

end



--
local tAllButtons, tButton, tIcon;
function VUHDO_swiftmendIndicatorBouquetCallback(aUnit, anIsActive, anIcon, aTimer, aCounter, aDuration, aColor, aBuffName, aBouquetName, anImpact, aTimer2, aClipL, aClipR, aClipT, aClipB)
	tAllButtons = VUHDO_getUnitButtons(aUnit);
	if (tAllButtons ~= nil) then
		for _, tButton in pairs(tAllButtons) do
			if (anIsActive and aColor ~= nil) then
				tIcon = VUHDO_getBarRoleIcon(tButton, 51);
				tIcon:SetTexture(anIcon);
				tIcon:SetVertexColor(aColor["R"], aColor["G"], aColor["B"], aColor["O"]);
				tIcon:SetTexCoord(aClipL or 0, aClipR or 1, aClipT or 0, aClipB or 1);
				tIcon:Show();
			else
				VUHDO_getBarRoleIcon(tButton, 51):Hide();
			end
		end
	end
end



--
local sIsSuspended = false;
function VUHDO_suspendHoTs(aFlag)
	sIsSuspended = aFlag;
end



--
local tUnit, tInfo;
function VUHDO_updateAllHoTs()
	if (sIsSuspended) then
		return;
	end

	twipe(VUHDO_SWIFTMEND_UNITS);

	for tUnit, tInfo in pairs(VUHDO_RAID) do
		VUHDO_updateHots(tUnit, tInfo);
	end
end



--
local tCnt, tCnt2;
local tButton;
function VUHDO_removeAllHots()
	for tCnt = 1, 10 do -- VUHDO_MAX_PANELS
		if (VUHDO_isPanelVisible(tCnt)) then

			for tCnt2 = 1, 51 do -- VUHDO_MAX_BUTTONS_PANEL
				tButton = VUHDO_getHealButton(tCnt2, tCnt);
				if (tButton == nil) then -- Auch nicht belegte buttons ausblenden
					break;
				end
				VUHDO_removeButtonHots(tButton);
			end

		end
	end

	twipe(VUHDO_FLASHING_ICONS);
	VUHDO_updatePlayerTarget();
end



--
function VUHDO_resetHotBuffCache()
	twipe(sBuffs2Hots);
end



function VUHDO_isUnitSwiftmendable(aUnit)
	return VUHDO_SWIFTMEND_UNITS[aUnit];
end
