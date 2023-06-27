VUHDO_COMBO_MAX_ENTRIES = 10000;

local floor = floor;
local mod = mod;
local tonumber = tonumber;
local strlen = strlen;
local strsub = strsub;
local pairs = pairs;
local GetLocale = GetLocale;
local InCombatLockdown = InCombatLockdown;
local UnitExists = UnitExists;
local sIsNotInChina = GetLocale() ~= "zhCN" and GetLocale() ~= "zhTW" and GetLocale() ~= "koKR";
local sIsManaBar;
local sIsSideBarLeft;
local sIsSideBarRight;
local sShowPanels;
local sHideEmptyAndClickThrough;
local sEmpty = { };

local VUHDO_LibSharedMedia;
local VUHDO_getActionPanel;
local VUHDO_getPanelButtons;

-----------------------------------------------------------------------
local VUHDO_getNumbersFromString;

local VUHDO_CONFIG = { };
local VUHDO_PANEL_SETUP = { };
local VUHDO_USER_CLASS_COLORS = { };
function VUHDO_guiToolboxInitBurst()
	VUHDO_getNumbersFromString = VUHDO_GLOBAL["VUHDO_getNumbersFromString"];

	VUHDO_CONFIG = VUHDO_GLOBAL["VUHDO_CONFIG"];
	VUHDO_PANEL_SETUP = VUHDO_GLOBAL["VUHDO_PANEL_SETUP"];
	VUHDO_USER_CLASS_COLORS = VUHDO_GLOBAL["VUHDO_USER_CLASS_COLORS"];
	VUHDO_LibSharedMedia = VUHDO_GLOBAL["VUHDO_LibSharedMedia"];
	VUHDO_getActionPanel = VUHDO_GLOBAL["VUHDO_getActionPanel"];
	VUHDO_getPanelButtons = VUHDO_GLOBAL["VUHDO_getPanelButtons"];

	sIsManaBar = VUHDO_INDICATOR_CONFIG["BOUQUETS"]["MANA_BAR"] ~= "";
	sIsSideBarLeft = VUHDO_INDICATOR_CONFIG["BOUQUETS"]["SIDE_LEFT"] ~= "";
	sIsSideBarRight = VUHDO_INDICATOR_CONFIG["BOUQUETS"]["SIDE_RIGHT"] ~= "";
	sShowPanels = VUHDO_CONFIG["SHOW_PANELS"];
	sHideEmptyAndClickThrough = VUHDO_CONFIG["HIDE_EMPTY_BUTTONS"]
		and VUHDO_CONFIG["HIDE_EMPTY_PANELS"]
		and VUHDO_CONFIG["LOCK_CLICKS_THROUGH"];
end
------------------------------------------------------------------------



--
function VUHDO_isConfigPanelShowing()
	return VUHDO_IS_PANEL_CONFIG and not VUHDO_CONFIG_SHOW_RAID;
end
local VUHDO_isConfigPanelShowing = VUHDO_isConfigPanelShowing;



--
local tButtons, tButton, tUnit;
local function VUHDO_hasPanelVisibleButtons(aPanelNum)
	if (not sShowPanels or not VUHDO_IS_SHOWN_BY_GROUP) then
		return false;
	end

	if (not sHideEmptyAndClickThrough or VUHDO_isConfigPanelShowing()) then
		return true;
	end

	tButtons = VUHDO_getPanelButtons(aPanelNum);
	for _, tButton in pairs(tButtons) do
		tUnit = tButton:GetAttribute("unit");
		if (tUnit == nil) then
			break;
		elseif (UnitExists(tUnit)) then
			return true;
		end
	end

	return false;
end



--
local tCnt, tPanel;
function VUHDO_updatePanelVisibility()
	for tCnt = 1, 10 do
		if (#(VUHDO_PANEL_MODELS[tCnt] or sEmpty) > 0) then
			tPanel = VUHDO_getActionPanel(tCnt);
			if (VUHDO_hasPanelVisibleButtons(tCnt)) then
				if (tPanel:GetAlpha() < 1) then
					tPanel:SetAlpha(1);
				end
			else
				if (tPanel:GetAlpha() > 0) then
					tPanel:SetAlpha(0);
				end
			end
		end
	end
end



--
function VUHDO_mayMoveHealPanels()
	return (VUHDO_IS_PANEL_CONFIG or not VUHDO_CONFIG["LOCK_PANELS"])
		and (not InCombatLockdown() or not VUHDO_CONFIG["LOCK_IN_FIGHT"]);
end



--
function VUHDO_getComponentPanelNum(aComponent)
	return VUHDO_getNumbersFromString(aComponent:GetName(), 1)[1];
end



--
local tX, tY;
function VUHDO_getAnchorCoords(aPanel, anOrientation, aScaleDiff)

	if (anOrientation == "TOPLEFT") then
		tX, tY = aPanel:GetLeft(), aPanel:GetTop();
	elseif (anOrientation == "TOP") then
		tX, tY = (aPanel:GetRight() + aPanel:GetLeft()) * 0.5, aPanel:GetTop();
	elseif (anOrientation == "BOTTOM") then
		tX, tY = (aPanel:GetRight() + aPanel:GetLeft()) * 0.5, aPanel:GetBottom();
	elseif (anOrientation == "LEFT") then
		tX, tY = aPanel:GetLeft(), (aPanel:GetBottom() + aPanel:GetTop()) * 0.5;
	elseif (anOrientation == "RIGHT") then
		tX, tY = aPanel:GetRight(), (aPanel:GetBottom() + aPanel:GetTop()) * 0.5;
	elseif (anOrientation == "TOPRIGHT") then
		tX, tY = aPanel:GetRight(), aPanel:GetTop();
	elseif (anOrientation == "BOTTOMLEFT") then
		tX, tY = aPanel:GetLeft(), aPanel:GetBottom();
	else -- BOTTOMRIGHT
		tX, tY = aPanel:GetRight(), aPanel:GetBottom();
	end
	return (tX or 0) / aScaleDiff, (tY or 0) / aScaleDiff;
end



--
function VUHDO_isLooseOrderingShowing(aPanelNum)
	return VUHDO_PANEL_SETUP[aPanelNum]["MODEL"]["ordering"] ~= 0 -- VUHDO_ORDERING_STRICT
		and (not VUHDO_IS_PANEL_CONFIG or VUHDO_CONFIG_SHOW_RAID);
end
local VUHDO_isLooseOrderingShowing = VUHDO_isLooseOrderingShowing;



--
function VUHDO_isTableHeadersShowing(aPanelNum)
	return not VUHDO_isLooseOrderingShowing(aPanelNum)
		and VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["showHeaders"]
		and not VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["alignBottom"];
end



--
function VUHDO_isTableFootersShowing(aPanelNum)
	return not VUHDO_isLooseOrderingShowing(aPanelNum)
		and VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["showHeaders"]
		and VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["alignBottom"];
end



--
function VUHDO_isTableHeaderOrFooter(aPanelNum)
	return not VUHDO_isLooseOrderingShowing(aPanelNum)
		and VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["showHeaders"];
end



--
function VUHDO_getColoredString(aString, aColor)
	if (aColor["useText"]) then
		return format("|cff%02x%02x%02x%s|r", aColor["TR"] * 255, aColor["TG"] * 255, aColor["TB"] * 255, aString);
	else
		return aString;
	end
end


--
function VUHDO_toggleMenu(aPanel)
	if (aPanel:IsShown()) then
		aPanel:Hide();
	else
		aPanel:Show();
	end
end



--
function VUHDO_getPanelNum(aPanel)
	return tonumber(strsub(aPanel:GetName(), -2)) or tonumber(strsub(aPanel:GetName(), -1)) or 1;
end



--
function VUHDO_getClassColor(anInfo)
	return VUHDO_USER_CLASS_COLORS[anInfo["classId"]];
end



--
function VUHDO_getClassColorByModelId(aModelId)
	return VUHDO_USER_CLASS_COLORS[aModelId];
end



--
function VUHDO_getManaBarHeight(aPanelNum)
	return sIsManaBar
		and VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["manaBarHeight"] or 0;
end
local VUHDO_getManaBarHeight = VUHDO_getManaBarHeight;



--
function VUHDO_getHealthBarHeight(aPanelNum)
	return VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["barHeight"] - VUHDO_getManaBarHeight(aPanelNum);
end



--
function VUHDO_getSideBarWidthLeft(aPanelNum)
	return sIsSideBarLeft
		and VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["sideLeftWidth"] or 0;
end



--
function VUHDO_getSideBarWidthRight(aPanelNum)
	return sIsSideBarRight
		and VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["sideRightWidth"] or 0;
end



--
function VUHDO_getHealthBarWidth(aPanelNum)
	return VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["barWidth"]
		- VUHDO_getSideBarWidthLeft(aPanelNum)
		- VUHDO_getSideBarWidthRight(aPanelNum);
end



--
function VUHDO_getDiffColor(aBaseColor, aModColor)
	if (aModColor["useText"]) then
		aBaseColor["useText"] = true;
		aBaseColor["TR"], aBaseColor["TG"], aBaseColor["TB"], aBaseColor["TO"]
			= aModColor["TR"], aModColor["TG"], aModColor["TB"], aModColor["TO"];
	end

	if (aModColor["useBackground"]) then
		aBaseColor["useBackground"] = true;
		aBaseColor["R"], aBaseColor["G"], aBaseColor["B"] = aModColor["R"], aModColor["G"], aModColor["B"];
	end

	if (aModColor["useOpacity"]) then
		aBaseColor["useOpacity"] = true;
		aBaseColor["O"], aBaseColor["TO"] = aModColor["O"], aModColor["TO"];
	end

	return aBaseColor;
end



--
function VUHDO_brightenTextColor(aColor, aSummand)
	aColor["TR"], aColor["TG"], aColor["TB"]
		= aColor["TR"] + aSummand, aColor["TG"] + aSummand, aColor["TB"] + aSummand;
	return aColor;
end



-- Bitmap ist 256*256 pixel mit 16 (4*4) Icons (je 64*64 pixel)
local tLeft, tTop;
function VUHDO_getRaidTargetIconTexture(anIndex)
	anIndex = anIndex - 1;
	tLeft = anIndex % 4 * 0.25;
	tTop = floor(anIndex * 0.25) * 0.25;
	return tLeft, tLeft + 0.25, tTop, tTop + 0.25;
end



--
function VUHDO_setRaidTargetIconTexture(aTexture, anIndex)
	aTexture:SetTexCoord(VUHDO_getRaidTargetIconTexture(anIndex));
end



--
local tMX, tMY;
function VUHDO_getMouseCoords()
	tMX, tMY = GetCursorPosition();
	return tMX / UIParent:GetEffectiveScale(), tMY / UIParent:GetEffectiveScale();
end



-- Liefert sicheren Fontnamen. Falls in LSM nicht (mehr) vorhanden oder
-- in asiatischem Land den Standard-Font zurückliefern. Genauso wenn als Argument nil geliefert wurde
local tFontInfo;
function VUHDO_getFont(aFont)
	if ((aFont or "") ~= "" and sIsNotInChina) then
		for _, tFontInfo in pairs(VUHDO_FONTS) do
			if (aFont == tFontInfo[1]) then
				return aFont;
			end
		end
	end

	return GameFontNormal:GetFont();
end



--
local function VUHDO_hideBlizzRaid()
	if (CompactRaidFrameContainer ~= nil) then
		CompactRaidFrameContainer:UnregisterAllEvents();
		CompactRaidFrameContainer:Hide();
	end
end



--
local function VUHDO_showBlizzRaid()
	if (CompactRaidFrameContainer ~= nil) then
		CompactRaidFrameContainer:RegisterAllEvents();
		if (not UnitExists("party1") and not UnitInRaid("player")) then
			return;
		end
		CompactRaidFrameContainer:Show();
	end
end



--
local function VUHDO_hideBlizzRaidMgr()
	if (CompactRaidFrameManager ~= nil) then
		CompactRaidFrameManager:UnregisterAllEvents();
		CompactRaidFrameManager:Hide();
	end
end


--
local function VUHDO_showBlizzRaidMgr()
	if (CompactRaidFrameManager ~= nil) then
		CompactRaidFrameManager:RegisterAllEvents();
		if (not UnitExists("party1") and not UnitInRaid("player")) then
			return;
		end
		CompactRaidFrameManager:Show();
	end
end



--
function VUHDO_hideBlizzCompactPartyFrame()
	if (VUHDO_CONFIG["BLIZZ_UI_HIDE_PARTY"] and not InCombatLockdown() and CompactPartyFrame ~= nil and CompactPartyFrame:IsVisible()) then
		CompactPartyFrame:UnregisterAllEvents();
		CompactPartyFrame:Hide();
	end
end



--
local function VUHDO_hideBlizzParty()
	local tCnt;
	HIDE_PARTY_INTERFACE = "1";

	hooksecurefunc("ShowPartyFrame",
		function()
			if (not InCombatLockdown()) then
				for tCnt = 1, 4 do
					VUHDO_GLOBAL["PartyMemberFrame" .. tCnt]:Hide();
				end
			end
		end
	);

	local tPartyFrame;
	for tCnt = 1, 4 do
		tPartyFrame = VUHDO_GLOBAL["PartyMemberFrame" .. tCnt];
		tPartyFrame:Hide();
		tPartyFrame:UnregisterAllEvents();
		VUHDO_GLOBAL["PartyMemberFrame" .. tCnt .. "HealthBar"]:UnregisterAllEvents();
		VUHDO_GLOBAL["PartyMemberFrame" .. tCnt .. "ManaBar"]:UnregisterAllEvents();
	end

	if (CompactPartyFrame ~= nil and CompactPartyFrame:IsVisible()) then
		RunScript("CompactPartyFrame:UnregisterAllEvents()");
		RunScript("CompactPartyFrame:Hide()");
	end
end



--
local function VUHDO_showBlizzParty()
	if (not UnitExists("party1")) then
		return;
	end

	if (tonumber(GetCVar("useCompactPartyFrames")) == 0) then
		local tCnt;
		HIDE_PARTY_INTERFACE = "0";

		hooksecurefunc("ShowPartyFrame",
			function()
				if (not InCombatLockdown()) then
					for tCnt = 1, 4 do
						VUHDO_GLOBAL["PartyMemberFrame" .. tCnt]:Show();
					end
				end
			end
		);

		local tPartyFrame;
		for tCnt = 1, 4 do
			tPartyFrame = VUHDO_GLOBAL["PartyMemberFrame" .. tCnt];
			if (GetPartyMember(tCnt)) then
				tPartyFrame:Show();
			end

			tPartyFrame:RegisterAllEvents();
			VUHDO_GLOBAL["PartyMemberFrame" .. tCnt .. "HealthBar"]:RegisterAllEvents();
			VUHDO_GLOBAL["PartyMemberFrame" .. tCnt .. "ManaBar"]:RegisterAllEvents();
		end
	else
		if (CompactPartyFrame ~= nil) then
			RunScript("CompactPartyFrame:Show()");
			RunScript("CompactPartyFrame:RegisterAllEvents()");
		end
	end
end



--
local function VUHDO_hideBlizzPlayer()
	PlayerFrame:UnregisterAllEvents();
	PlayerFrameHealthBar:UnregisterAllEvents();
	PlayerFrameManaBar:UnregisterAllEvents();
	PlayerFrame:Hide();
end



--
local function VUHDO_showBlizzPlayer()
	PlayerFrame:RegisterAllEvents();
	PlayerFrameHealthBar:RegisterAllEvents();
	PlayerFrameManaBar:RegisterAllEvents();
	PlayerFrame:Show();
end



--
local function VUHDO_hideBlizzTarget()
	TargetFrame:UnregisterAllEvents();
	TargetFrameHealthBar:UnregisterAllEvents();
	TargetFrameManaBar:UnregisterAllEvents();
	TargetFrame:Hide();

	TargetFrameToT:UnregisterAllEvents();
	TargetFrameToT:Hide();

	FocusFrameToT:UnregisterAllEvents();
	FocusFrameToT:Hide();

	ComboFrame:ClearAllPoints();
end



--
local function VUHDO_showBlizzTarget()
	TargetFrame:RegisterAllEvents();
	TargetFrameHealthBar:RegisterAllEvents();
	TargetFrameManaBar:RegisterAllEvents();

	TargetFrameToT:RegisterAllEvents();
	FocusFrameToT:RegisterAllEvents();
	ComboFrame:SetPoint("TOPRIGHT", "TargetFrame", "TOPRIGHT", -44, -9);
end



--
local function VUHDO_hideBlizzPet()
	PetFrame:UnregisterAllEvents();
	PetFrame:Hide();
end



--
local function VUHDO_showBlizzPet()
	PetFrame:RegisterAllEvents();
	PetFrame:Show();
end


--
local function VUHDO_hideBlizzFocus()
	FocusFrame:UnregisterAllEvents();
	FocusFrame:Hide();
end



--
local function VUHDO_showBlizzFocus()
	FocusFrame:RegisterAllEvents();
	TargetFrame_OnLoad(FocusFrame, "focus", FocusFrameDropDown_Initialize);
end




--
function VUHDO_initBlizzFrames()
	if (InCombatLockdown()) then
		return;
	end

	if (VUHDO_CONFIG["BLIZZ_UI_HIDE_PARTY"]) then
		VUHDO_hideBlizzParty();
	else
		VUHDO_showBlizzParty();
	end

	if (VUHDO_CONFIG["BLIZZ_UI_HIDE_PLAYER"]) then
		VUHDO_hideBlizzPlayer();
	else
		VUHDO_showBlizzPlayer();
	end

	if (VUHDO_CONFIG["BLIZZ_UI_HIDE_TARGET"]) then
		VUHDO_hideBlizzTarget();
	else
		VUHDO_showBlizzTarget();
	end

	if (VUHDO_CONFIG["BLIZZ_UI_HIDE_PET"]) then
		VUHDO_hideBlizzPet();
	else
		VUHDO_showBlizzPet();
	end

	if (VUHDO_CONFIG["BLIZZ_UI_HIDE_FOCUS"]) then
		VUHDO_hideBlizzFocus();
	else
		VUHDO_showBlizzFocus();
	end

	if (VUHDO_CONFIG["BLIZZ_UI_HIDE_RAID"]) then
		VUHDO_hideBlizzRaid();
	else
		VUHDO_showBlizzRaid();
	end

	if (VUHDO_CONFIG["BLIZZ_UI_HIDE_RAID_MGR"]) then
		VUHDO_hideBlizzRaidMgr();
	else
		VUHDO_showBlizzRaidMgr();
	end
end



--
function VUHDO_initHideBlizzRaid()
	if (VUHDO_CONFIG["BLIZZ_UI_HIDE_RAID"]) then
		VUHDO_hideBlizzRaid();

	end
	if (VUHDO_CONFIG["BLIZZ_UI_HIDE_RAID_MGR"]) then
		VUHDO_hideBlizzRaidMgr();
	end
end
local VUHDO_initHideBlizzRaid = VUHDO_initHideBlizzRaid;



--
function VUHDO_initHideBlizzFrames()
	if (InCombatLockdown()) then
		return;
	end

	if (VUHDO_CONFIG["BLIZZ_UI_HIDE_PARTY"]) then
		VUHDO_hideBlizzParty();
	end

	if (VUHDO_CONFIG["BLIZZ_UI_HIDE_PLAYER"]) then
		VUHDO_hideBlizzPlayer();
	end

	if (VUHDO_CONFIG["BLIZZ_UI_HIDE_TARGET"]) then
		VUHDO_hideBlizzTarget();
	end

	if (VUHDO_CONFIG["BLIZZ_UI_HIDE_PET"]) then
		VUHDO_hideBlizzPet();
	end

	if (VUHDO_CONFIG["BLIZZ_UI_HIDE_FOCUS"]) then
		VUHDO_hideBlizzFocus();
	end

	VUHDO_initHideBlizzRaid();
end



--
local tOldX, tOldY;
function VUHDO_isDifferentButtonPoint(aRegion, aPointX, aPointY)
	_, _, _, tOldX, tOldY	= aRegion:GetPoint();
	if (tOldX ~= nil) then
		tOldX = floor(tOldX + 0.5);
		tOldY = floor(tOldY + 0.5);
	end
	return aPointX ~= tOldX or aPointY ~= tOldY;
end



--
function VUHDO_lnfPatchFont(aComponent, aLabelName)
	if (not sIsNotInChina) then
		VUHDO_GLOBAL[aComponent:GetName() .. aLabelName]:SetFont(VUHDO_OPTIONS_FONT_NAME, 12);
	end
end



--
function VUHDO_isConfigDemoUsers()
	return VUHDO_IS_PANEL_CONFIG and VUHDO_CONFIG_SHOW_RAID and VUHDO_CONFIG_TEST_USERS > 0;
end



--
local tFile;
function VUHDO_setLlcStatusBarTexture(aStatusBar, aTextureName)
	tFile = VUHDO_LibSharedMedia:Fetch('statusbar', aTextureName);
	if (tFile ~= nil) then
		aStatusBar:SetStatusBarTexture(tFile);
	end
end



--
local tOurLevel;
function VUHDO_fixFrameLevels(aFrame, aBaseLevel, ...)
	local tCnt = 1;
	local tChild = select(tCnt, ...);
	aFrame:SetFrameLevel(aBaseLevel);
	while (tChild ~= nil) do -- Layer components seem to have no name, important for HoT icons.
		if (tChild:GetName() ~= nil and not tChild["vfl"]) then
			tChild:SetFrameStrata(aFrame:GetFrameStrata());
			tOurLevel = aBaseLevel + 1 + (tChild["addLevel"] or 0);
			tChild:SetFrameLevel(tOurLevel);
			tChild["vfl"] = true;

			VUHDO_fixFrameLevels(tChild, tOurLevel, tChild:GetChildren());
		end
		tCnt = tCnt + 1;
		tChild = select(tCnt, ...);
	end
end



--
local tOutline, tShadowAlpha, tColor, tFactor;
function VUHDO_customizeIconText(aParent, aHeight, aLabel, aSetup)
	tFactor = aHeight * 0.01;
	aLabel:SetPoint(aSetup["ANCHOR"], aParent:GetName(), aSetup["ANCHOR"], tFactor * aSetup["X_ADJUST"], -tFactor * aSetup["Y_ADJUST"]);
	tOutline = aSetup["USE_OUTLINE"] and "OUTLINE|" or "";
	tOutline = tOutline .. (aSetup["USE_MONO"] and "MONOCHROME" or "");

	tColor = aSetup["COLOR"];
	if (tColor ~= nil) then
		tShadowAlpha = aSetup["USE_SHADOW"] and tColor["O"] or 0;
		aLabel:SetTextColor(tColor["TR"], tColor["TG"], tColor["TB"], tColor["TO"]);
		aLabel:SetShadowColor(tColor["R"], tColor["G"], tColor["B"], tShadowAlpha);
	else
		tShadowAlpha = aSetup["USE_SHADOW"] and 1 or 0;
		aLabel:SetTextColor(1, 1, 1, 1);
		aLabel:SetShadowColor(0, 0, 0, tShadowAlpha);
	end

	aLabel:SetFont(aSetup["FONT"], tFactor * aSetup["SCALE"], tOutline);
	aLabel:SetShadowOffset(1, -1);
end



--
function VUHDO_setupAllButtonsUnitWatch(anIsRegister)
	if (InCombatLockdown()) then
		return;
	end

	local tFunc = anIsRegister and RegisterUnitWatch or UnregisterUnitWatch;
	local tButton;

	for tButton, _ in pairs(VUHDO_BUTTON_CACHE) do
		tFunc(tButton);
	end
end



--
function VUHDO_backColor(aColor)
	return aColor["R"], aColor["G"], aColor["B"], aColor["O"];
end



--
function VUHDO_textColor(aColor)
	return aColor["TR"], aColor["TG"], aColor["TB"], aColor["TO"];
end
