local _;

VUHDO_COMBO_MAX_ENTRIES = 10000;

local floor = floor;
local mod = mod;
local tonumber = tonumber;
local strsub = strsub;
local pairs = pairs;
local format = format;
local GetLocale = GetLocale;
local InCombatLockdown = InCombatLockdown;
local UnitExists = UnitExists;
local sIsNotInChina = GetLocale() ~= "zhCN" and GetLocale() ~= "zhTW" and GetLocale() ~= "koKR";
local sIsManaBar;
local sIsSideBarLeft;
local sIsSideBarRight;
local sShowPanels;
local sIsHideEmptyAndClickThrough;
local sEmpty = { };

local VUHDO_LibSharedMedia;
local VUHDO_getActionPanelOrStub;
local VUHDO_getPanelButtons;
local VUHDO_getHealthBarText;
local VUHDO_getUnitButtonsSafe;

-----------------------------------------------------------------------
--local VUHDO_getNumbersFromString;

local VUHDO_CONFIG = { };
local VUHDO_PANEL_SETUP = { };
local VUHDO_USER_CLASS_COLORS = { };
function VUHDO_guiToolboxInitLocalOverrides()
	--VUHDO_getNumbersFromString = _G["VUHDO_getNumbersFromString"];

	VUHDO_CONFIG = _G["VUHDO_CONFIG"];
	VUHDO_PANEL_SETUP = _G["VUHDO_PANEL_SETUP"];
	VUHDO_USER_CLASS_COLORS = _G["VUHDO_USER_CLASS_COLORS"];
	VUHDO_LibSharedMedia = _G["VUHDO_LibSharedMedia"];
	VUHDO_getActionPanelOrStub = _G["VUHDO_getActionPanelOrStub"];
	VUHDO_getPanelButtons = _G["VUHDO_getPanelButtons"];
	VUHDO_getHealthBarText = _G["VUHDO_getHealthBarText"];
	VUHDO_getUnitButtonsSafe = _G["VUHDO_getUnitButtonsSafe"];

	sIsManaBar = VUHDO_INDICATOR_CONFIG["BOUQUETS"]["MANA_BAR"] ~= "";
	sIsSideBarLeft = VUHDO_INDICATOR_CONFIG["BOUQUETS"]["SIDE_LEFT"] ~= "";
	sIsSideBarRight = VUHDO_INDICATOR_CONFIG["BOUQUETS"]["SIDE_RIGHT"] ~= "";
	sShowPanels = VUHDO_CONFIG["SHOW_PANELS"];
	sIsHideEmptyAndClickThrough = VUHDO_CONFIG["HIDE_EMPTY_BUTTONS"]
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
local tUnit;
local function VUHDO_hasPanelVisibleButtons(aPanelNum)
	if not sShowPanels or not VUHDO_IS_SHOWN_BY_GROUP then
		return false;

	elseif not sIsHideEmptyAndClickThrough or VUHDO_isConfigPanelShowing() then
		return true;

	else
		for _, tButton in pairs(VUHDO_getPanelButtons(aPanelNum)) do
			tUnit = tButton:GetAttribute("unit");
			if not tUnit then return false;
			elseif UnitExists(tUnit) then return true; end
		end
	end
end



--
function VUHDO_updatePanelVisibility()
	for tCnt = 1, 10 do -- VUHDO_MAX_PANELS
		if #(VUHDO_PANEL_MODELS[tCnt] or sEmpty) > 0 then
			VUHDO_getActionPanelOrStub(tCnt):SetAlpha(VUHDO_hasPanelVisibleButtons(tCnt) and 1 or 0);
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
local tAnchorCoords = {
	TOPLEFT = function(aPanel) return aPanel:GetLeft(), aPanel:GetTop(); end,
	TOP = function(aPanel) return (aPanel:GetRight() + aPanel:GetLeft()) * 0.5, aPanel:GetTop(); end,
	BOTTOM = function(aPanel) return (aPanel:GetRight() + aPanel:GetLeft()) * 0.5, aPanel:GetBottom(); end,
	LEFT = function(aPanel) return aPanel:GetLeft(), (aPanel:GetBottom() + aPanel:GetTop()) * 0.5; end,
	RIGHT = function(aPanel) return aPanel:GetRight(), (aPanel:GetBottom() + aPanel:GetTop()) * 0.5; end,
	TOPRIGHT = function(aPanel) return aPanel:GetRight(), aPanel:GetTop(); end,
	BOTTOMLEFT = function(aPanel) return aPanel:GetLeft(), aPanel:GetBottom(); end,
	BOTTOMRIGHT = function(aPanel) return aPanel:GetRight(), aPanel:GetBottom(); end,
};
function VUHDO_getAnchorCoords(aPanel, anOrientation, aScaleDiff)
	local tX, tY = tAnchorCoords[anOrientation](aPanel);
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
	if aColor["useText"] then
		return format("|cff%02x%02x%02x%s|r", aColor["TR"] * 255, aColor["TG"] * 255, aColor["TB"] * 255, aString);
	else
		return aString;
	end
end


--
function VUHDO_toggleMenu(aPanel)
	aPanel:SetShown(not aPanel:IsShown());
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
	return sIsManaBar and VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["manaBarHeight"] or 0;
end
local VUHDO_getManaBarHeight = VUHDO_getManaBarHeight;



--
function VUHDO_getHealthBarHeight(aPanelNum)
	return VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["barHeight"] - VUHDO_getManaBarHeight(aPanelNum);
end



--
function VUHDO_getSideBarWidthLeft(aPanelNum)
	return sIsSideBarLeft and VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["sideLeftWidth"] or 0;
end



--
function VUHDO_getSideBarWidthRight(aPanelNum)
	return sIsSideBarRight and VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["sideRightWidth"] or 0;
end



--
function VUHDO_getHealthBarWidth(aPanelNum)
	return VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["barWidth"]
		- VUHDO_getSideBarWidthLeft(aPanelNum) - VUHDO_getSideBarWidthRight(aPanelNum);
end



--
function VUHDO_getDiffColor(aBaseColor, aModColor)
	if aModColor["useText"] then
		aBaseColor["useText"] = true;
		aBaseColor["TR"], aBaseColor["TG"], aBaseColor["TB"], aBaseColor["TO"]
			= aModColor["TR"], aModColor["TG"], aModColor["TB"], aModColor["TO"];
	end

	if aModColor["useBackground"] then
		aBaseColor["useBackground"] = true;
		aBaseColor["R"], aBaseColor["G"], aBaseColor["B"] = aModColor["R"], aModColor["G"], aModColor["B"];
	end

	if aModColor["useOpacity"] then
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



-- Liefert sicheren Fontnamen. Falls in LSM nicht (mehr) vorhanden oder
-- in asiatischem Land den Standard-Font zurückliefern. Genauso wenn als Argument nil geliefert wurde
function VUHDO_getFont(aFont)
	if (aFont or "") ~= "" and sIsNotInChina then
		for _, tFontInfo in pairs(VUHDO_FONTS) do
			if aFont == tFontInfo[1] then return aFont; end
		end
	end

	return GameFontNormal:GetFont();
end



--
local VUHDO_BLIZZ_EVENTS = {
	"CVAR_UPDATE",
	"DISPLAY_SIZE_CHANGED",
	"GROUP_ROSTER_UPDATE",
	"IGNORELIST_UPDATE",
	"INCOMING_RESURRECT_CHANGED",
	"INSTANCE_ENCOUNTER_ENGAGE_UNIT",
	"MUTELIST_UPDATE",
	"PARTY_LEADER_CHANGED",
	"PARTY_LFG_RESTRICTED",
	"PARTY_LOOT_METHOD_CHANGED",
	"PARTY_MEMBER_DISABLE",
	"PARTY_MEMBER_ENABLE",
	"PLAYER_ENTER_COMBAT",
	"PLAYER_LEAVE_COMBAT",
	"PLAYER_ENTERING_WORLD",
	"PLAYER_FLAGS_CHANGED",
	"PLAYER_FOCUS_CHANGED",
	"PLAYER_LOGIN",
	"PLAYER_ROLES_ASSIGNED",
	"PLAYER_TARGET_CHANGED",
	"PLAYER_UPDATE_RESTING",
	"PLAYTIME_CHANGED",
	"RAID_TARGET_UPDATE",
	"READY_CHECK",
	"READY_CHECK_CONFIRM",
	"READY_CHECK_FINISHED",
	"RUNE_POWER_UPDATE",
	"RUNE_TYPE_UPDATE",
	"UI_SCALE_CHANGED",
	"UNIT_AURA",
	"UNIT_CLASSIFICATION_CHANGED",
	"UNIT_CONNECTION",
	"UNIT_COMBAT",
	"UNIT_COMBO_POINTS",
	"UNIT_DISPLAYPOWER",
	"UNIT_ENTERED_VEHICLE",
	"UNIT_ENTERING_VEHICLE",
	"UNIT_EXITED_VEHICLE",
	"UNIT_EXITING_VEHICLE",
	"UNIT_FACTION",
	"UNIT_FLAGS",
	"UNIT_HEAL_PREDICTION",
	"UNIT_HEALTH",
	"UNIT_HEALTH_FREQUENT",
	"UNIT_LEVEL",
	"UNIT_MAXHEALTH",
	"UNIT_MAXPOWER",
	"UNIT_NAME_UPDATE",
	"UNIT_OTHER_PARTY_CHANGED",
	"UNIT_PET",
	"UNIT_PHASE",
	"UNIT_PORTRAIT_UPDATE",
	"UNIT_POWER",
	"UNIT_POWER_BAR_HIDE",
	"UNIT_POWER_BAR_SHOW",
	"UNIT_POWER_FREQUENT",
	"UNIT_TARGETABLE_CHANGED",
	"UNIT_THREAT_SITUATION_UPDATE",
	"UPDATE_INSTANCE_INFO",
	"UPDATE_SHAPESHIFT_FORM",
	"UPDATE_STEALTH",
	"VARIABLES_LOADED",
	"VOICE_START",
	"VOICE_STATUS_UPDATE",
	"VOICE_STOP",
};



--
local VUHDO_FIX_EVENTS = {
	"UNIT_AURA",
	"UNIT_COMBAT",
	"UNIT_HEAL_PREDICTION",
	"UNIT_HEALTH",
	"UNIT_HEALTH_FREQUENT",
	"UNIT_MAXHEALTH",
	"UNIT_MAXPOWER",
	"UNIT_PET",
	"UNIT_POWER",
	"UNIT_POWER_FREQUENT",
	"UNIT_THREAT_SITUATION_UPDATE",
};




local sEventsPerFrame = {};



local function VUHDO_unregisterAndSaveEvents(anIsHide, ...)
	local tFrame;
	for tCnt = 1, select('#', ...) do
		tFrame = select(tCnt, ...);

		if tFrame then
			if not sEventsPerFrame[tFrame] then
				sEventsPerFrame[tFrame] = { };

				for tIndex, tEvent in pairs(VUHDO_BLIZZ_EVENTS) do
					if (tFrame:IsEventRegistered(tEvent)) then
						tinsert(sEventsPerFrame[tFrame], tIndex);
					end
				end

			end

			tFrame:UnregisterAllEvents();
			if anIsHide then tFrame:Hide(); end
		end
	end
end





--
local function VUHDO_registerOriginalEvents(anIsShow, ...)
	local tFrame;
	for tCnt = 1, select('#', ...) do
		tFrame = select(tCnt, ...);

		if tFrame then
			if sEventsPerFrame[tFrame] then
				for _, tIndex in pairs(sEventsPerFrame[tFrame]) do
					tFrame:RegisterEvent(VUHDO_BLIZZ_EVENTS[tIndex]);
				end

				for _, tEvent in pairs(VUHDO_FIX_EVENTS) do
					tFrame:RegisterEvent(tEvent);
				end
			else -- must not happen
				tFrame:RegisterAllEvents();
			end

			if anIsShow then tFrame:Show(); end
		end
	end
end



--
local function VUHDO_hideBlizzRaid()
	VUHDO_unregisterAndSaveEvents(true, CompactRaidFrameContainer);
end



--
local function VUHDO_showBlizzRaid()
	VUHDO_registerOriginalEvents(VUHDO_GROUP_TYPE_SOLO ~= VUHDO_getCurrentGroupType(), CompactRaidFrameContainer);
end



--
local function VUHDO_hideBlizzRaidMgr()
	VUHDO_unregisterAndSaveEvents(true, CompactRaidFrameManager);
end


--
local function VUHDO_showBlizzRaidMgr()
	VUHDO_registerOriginalEvents(VUHDO_GROUP_TYPE_SOLO ~= VUHDO_getCurrentGroupType(), CompactRaidFrameManager);
end



--
function VUHDO_hideBlizzCompactPartyFrame()
	if VUHDO_CONFIG["BLIZZ_UI_HIDE_PARTY"] == 3 and not InCombatLockdown() and CompactPartyFrame and CompactPartyFrame:IsVisible() then
		VUHDO_unregisterAndSaveEvents(true, CompactPartyFrame);
	end
end



--
local function VUHDO_hideBlizzParty()
	HIDE_PARTY_INTERFACE = "1";

	hooksecurefunc("ShowPartyFrame",
		function()
			if not InCombatLockdown() then
				for tCnt = 1, 4 do
					_G["PartyMemberFrame" .. tCnt]:Hide();
				end
			end
		end
	);

	local tPartyFrame;
	for tCnt = 1, 4 do
		tPartyFrame = _G["PartyMemberFrame" .. tCnt];
		VUHDO_unregisterAndSaveEvents(false,
			tPartyFrame, _G["PartyMemberFrame" .. tCnt .. "HealthBar"], _G["PartyMemberFrame" .. tCnt .. "ManaBar"]
		);
		tPartyFrame:Hide();
	end

	if (CompactPartyFrame ~= nil and CompactPartyFrame:IsVisible()) then
		VUHDO_unregisterAndSaveEvents(true, CompactPartyFrame);
	end
end



--
local function VUHDO_showBlizzParty()
	if VUHDO_GROUP_TYPE_PARTY ~= VUHDO_getCurrentGroupType() then return; end

	if tonumber(GetCVar("useCompactPartyFrames")) == 0 then
		HIDE_PARTY_INTERFACE = "0";

		hooksecurefunc("ShowPartyFrame",
			function()
				if not InCombatLockdown() then
					for tCnt = 1, 4 do
						_G["PartyMemberFrame" .. tCnt]:Show();
					end
				end
			end
		);

		local tPartyFrame;
		for tCnt = 1, 4 do
			tPartyFrame = _G["PartyMemberFrame" .. tCnt];
			VUHDO_registerOriginalEvents(false,
				tPartyFrame, _G["PartyMemberFrame" .. tCnt .. "HealthBar"], _G["PartyMemberFrame" .. tCnt .. "ManaBar"]);

			if (UnitExists("party" .. tCnt)) then
				tPartyFrame:Show();
			end
		end
	else
		VUHDO_registerOriginalEvents(true, CompactPartyFrame);
	end
end



--
local function VUHDO_hideBlizzPlayer()
	VUHDO_unregisterAndSaveEvents(true, PlayerFrame, RuneFrame);
	VUHDO_unregisterAndSaveEvents(false, PlayerFrameHealthBar, PlayerFrameManaBar);
end



--
local function VUHDO_showBlizzPlayer()
	VUHDO_registerOriginalEvents(false, PlayerFrame, PlayerFrameHealthBar, PlayerFrameManaBar);
	PlayerFrame:Show();
	if "DEATHKNIGHT" == VUHDO_PLAYER_CLASS then
		VUHDO_registerOriginalEvents(RuneFrame);
		RuneFrame:Show();
	end
end



--
local function VUHDO_hideBlizzTarget()
	VUHDO_unregisterAndSaveEvents(true, TargetFrame, TargetFrameToT, FocusFrameToT);
	VUHDO_unregisterAndSaveEvents(false, TargetFrameHealthBar, TargetFrameManaBar);
	ComboFrame:ClearAllPoints();
end



--
local function VUHDO_showBlizzTarget()
	VUHDO_registerOriginalEvents(false, TargetFrame, TargetFrameHealthBar, TargetFrameManaBar, TargetFrameToT, FocusFrameToT);
	ComboFrame:SetPoint("TOPRIGHT", "TargetFrame", "TOPRIGHT", -44, -9);
end



--
local function VUHDO_hideBlizzPet()
	VUHDO_unregisterAndSaveEvents(true, PetFrame);
end



--
local function VUHDO_showBlizzPet()
	VUHDO_registerOriginalEvents(true, PetFrame);
end


--
local function VUHDO_hideBlizzFocus()
	VUHDO_unregisterAndSaveEvents(true, FocusFrame);
end



--
local function VUHDO_showBlizzFocus()
	VUHDO_registerOriginalEvents(false, FocusFrame);
end



--
function VUHDO_initHideBlizzRaid()
	if VUHDO_CONFIG["BLIZZ_UI_HIDE_RAID"] == 3 then VUHDO_hideBlizzRaid(); end
	if VUHDO_CONFIG["BLIZZ_UI_HIDE_RAID_MGR"] == 3 then VUHDO_hideBlizzRaidMgr(); end
	if VUHDO_CONFIG["BLIZZ_UI_HIDE_PARTY"] == 3 then VUHDO_hideBlizzParty(); end
end


--
function VUHDO_initBlizzFrames()
	if (InCombatLockdown()) then
		return;
	end

	if VUHDO_CONFIG["BLIZZ_UI_HIDE_PLAYER"] == 3 then VUHDO_hideBlizzPlayer();
	elseif VUHDO_CONFIG["BLIZZ_UI_HIDE_PLAYER"] == 1 then VUHDO_showBlizzPlayer(); end

	if VUHDO_CONFIG["BLIZZ_UI_HIDE_TARGET"] == 3 then VUHDO_hideBlizzTarget();
	elseif VUHDO_CONFIG["BLIZZ_UI_HIDE_TARGET"] == 1 then VUHDO_showBlizzTarget(); end

	if VUHDO_CONFIG["BLIZZ_UI_HIDE_PET"] == 3 then VUHDO_hideBlizzPet();
	elseif VUHDO_CONFIG["BLIZZ_UI_HIDE_PET"] == 1 then VUHDO_showBlizzPet(); end

	if VUHDO_CONFIG["BLIZZ_UI_HIDE_FOCUS"] == 3 then VUHDO_hideBlizzFocus();
	elseif VUHDO_CONFIG["BLIZZ_UI_HIDE_FOCUS"] == 1 then VUHDO_showBlizzFocus(); end

	if VUHDO_CONFIG["BLIZZ_UI_HIDE_RAID"] == 3 then VUHDO_hideBlizzRaid();
	elseif VUHDO_CONFIG["BLIZZ_UI_HIDE_RAID"] == 1 then VUHDO_showBlizzRaid(); end

	if VUHDO_CONFIG["BLIZZ_UI_HIDE_RAID_MGR"] == 3 then VUHDO_hideBlizzRaidMgr();
	elseif VUHDO_CONFIG["BLIZZ_UI_HIDE_RAID_MGR"] == 1 then VUHDO_showBlizzRaidMgr(); end

	if VUHDO_CONFIG["BLIZZ_UI_HIDE_PARTY"] == 3 then VUHDO_hideBlizzParty();
	elseif VUHDO_CONFIG["BLIZZ_UI_HIDE_PARTY"] == 1 then VUHDO_showBlizzParty(); end
end



function VUHDO_initHideBlizzFrames()
	if InCombatLockdown() then return; end

	if VUHDO_CONFIG["BLIZZ_UI_HIDE_PLAYER"] == 3 then VUHDO_hideBlizzPlayer(); end
	if VUHDO_CONFIG["BLIZZ_UI_HIDE_TARGET"] == 3 then VUHDO_hideBlizzTarget(); end
	if VUHDO_CONFIG["BLIZZ_UI_HIDE_PET"] == 3 then VUHDO_hideBlizzPet(); end
	if VUHDO_CONFIG["BLIZZ_UI_HIDE_FOCUS"] == 3 then VUHDO_hideBlizzFocus(); end

	VUHDO_initHideBlizzRaid();
end



--
local tOldX, tOldY;
function VUHDO_isDifferentButtonPoint(aRegion, aPointX, aPointY)
	_, _, _, tOldX, tOldY	= aRegion:GetPoint();
	if tOldX then
		tOldX = floor(tOldX + 0.5);
		tOldY = floor(tOldY + 0.5);
	end
	return aPointX ~= tOldX or aPointY ~= tOldY;
end



--
function VUHDO_lnfPatchFont(aComponent, aLabelName)
	if not sIsNotInChina then _G[aComponent:GetName() .. aLabelName]:SetFont(VUHDO_OPTIONS_FONT_NAME, 12); end
end



--
function VUHDO_isConfigDemoUsers()
	return VUHDO_IS_PANEL_CONFIG and VUHDO_CONFIG_SHOW_RAID and VUHDO_CONFIG_TEST_USERS > 0;
end



--
local tFile;
function VUHDO_setLlcStatusBarTexture(aStatusBar, aTextureName)
	tFile = VUHDO_LibSharedMedia:Fetch('statusbar', aTextureName);
	if tFile then aStatusBar:SetStatusBarTexture(tFile); end
end



--
local tOurLevel;
function VUHDO_fixFrameLevels(anIsForceUpdateChildren, aFrame, aBaseLevel, ...)
	local tCnt = 1;
	local tChild = select(tCnt, ...);
	aFrame:SetFrameLevel(aBaseLevel);
	while tChild do -- Layer components seem to have no name, important for HoT icons.
		if tChild:GetName() then
			tOurLevel = aBaseLevel + 1 + (tChild["addLevel"] or 0);

			if not tChild["vfl"] then
				tChild:SetFrameStrata(aFrame:GetFrameStrata());
				tChild:SetFrameLevel(tOurLevel);
				tChild["vfl"] = true;
				VUHDO_fixFrameLevels(anIsForceUpdateChildren, tChild, tOurLevel, tChild:GetChildren());
			elseif(anIsForceUpdateChildren) then
				VUHDO_fixFrameLevels(true, tChild, tOurLevel, tChild:GetChildren());
			end

		end
		tCnt = tCnt + 1;
		tChild = select(tCnt, ...);
	end
end



--
local tOutline, tShadowAlpha, tColor, tFactor;
function VUHDO_customizeIconText(aParent, aHeight, aLabel, aSetup)
	tFactor = aHeight * 0.01;
	aLabel:ClearAllPoints();
	aLabel:SetPoint(aSetup["ANCHOR"], aParent:GetName(), aSetup["ANCHOR"], tFactor * aSetup["X_ADJUST"], -tFactor * aSetup["Y_ADJUST"]);
	tOutline = aSetup["USE_OUTLINE"] and "OUTLINE|" or "";
	--tOutline = tOutline .. (aSetup["USE_MONO"] and "MONOCHROME" or ""); -- Bugs out in MoP beta

	tColor = aSetup["COLOR"];
	if tColor then
		tShadowAlpha = aSetup["USE_SHADOW"] and tColor["O"] or 0;
		aLabel:SetTextColor(VUHDO_textColor(tColor));
		aLabel:SetShadowColor(tColor["R"], tColor["G"], tColor["B"], tShadowAlpha);
	else
		tShadowAlpha = aSetup["USE_SHADOW"] and 1 or 0;
		aLabel:SetTextColor(1, 1, 1, 1);
		aLabel:SetShadowColor(0, 0, 0, tShadowAlpha);
	end

	aLabel:SetFont(aSetup["FONT"], tFactor * aSetup["SCALE"], tOutline);
	aLabel:SetShadowOffset(1, -1);
	aLabel:SetText("");
end



--
function VUHDO_setupAllButtonsUnitWatch(anIsRegister)
	if InCombatLockdown() then return; end

	local tFunc = anIsRegister and RegisterUnitWatch or UnregisterUnitWatch;

	for tButton, _ in pairs(VUHDO_BUTTON_CACHE) do
		if tButton:IsShown() then
			tFunc(tButton);
		else
			UnregisterUnitWatch(tButton)
		end
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





----------------------------------------

local sFlashFrames = { };
local sIsFlashFrame = { };

--
function VUHDO_UIFrameFlash(aFrame, aFadeInTime, aFadeOutTime, aFlashDuration, anIsShowWhenDone, aFlashInHoldTime, aFlashOutHoldTime)

  if sIsFlashFrame[aFrame] then return; end

  aFrame.fadeInTime = aFadeInTime;
  aFrame.fadeOutTime = aFadeOutTime;
  aFrame.flashDuration = aFlashDuration;
  aFrame.showWhenDone = anIsShowWhenDone;
  aFrame.flashTimer = 0;
  aFrame.flashInHoldTime = aFlashInHoldTime;
  aFrame.flashOutHoldTime = aFlashOutHoldTime;

  sFlashFrames[#sFlashFrames + 1] = aFrame;
  sIsFlashFrame[aFrame] = true;
end



--
local tFrame;
local tIndex;
local tFlashTime;
local tAlpha;
function VUHDO_UIFrameFlash_OnUpdate(aTimeDelta)
	tIndex = #sFlashFrames;

	while sFlashFrames[tIndex] do
	  tFrame = sFlashFrames[tIndex];
	  tFrame.flashTimer = tFrame.flashTimer + aTimeDelta;

	  if tFrame.flashTimer > tFrame.flashDuration and tFrame.flashDuration ~= -1 then
	    VUHDO_UIFrameFlashStop(tFrame);
	  else
	    tFlashTime = tFrame.flashTimer;

	    tFlashTime = tFlashTime
	    	% (tFrame.fadeInTime + tFrame.fadeOutTime + (tFrame.flashInHoldTime or 0) + (tFrame.flashOutHoldTime or 0));

	    if tFlashTime < tFrame.fadeInTime then
	    	tAlpha = tFlashTime / tFrame.fadeInTime;
	    elseif tFlashTime < tFrame.fadeInTime + (tFrame.flashInHoldTime or 0) then
	    	tAlpha = 1;
	    elseif tFlashTime < tFrame.fadeInTime + (tFrame.flashInHoldTime or 0) + tFrame.fadeOutTime then
	    	tAlpha = 1 - ((tFlashTime - tFrame.fadeInTime - (tFrame.flashInHoldTime or 0)) / tFrame.fadeOutTime);
	    else
	    	tAlpha = 0;
	    end

	    tFrame:SetAlpha(tAlpha);
	  end

	  tIndex = tIndex - 1;
	end
end



--
function VUHDO_UIFrameFlashStop(aFrame)
	if sIsFlashFrame[aFrame] then
		tDeleteItem(sFlashFrames, aFrame);
		aFrame:SetAlpha(aFrame.showWhenDone and 1 or 0);
		aFrame.flashTimer = nil;
		sIsFlashFrame[aFrame] = nil;
	end
end



--
function VUHDO_indicatorTextCallback(aBarNum, aUnit, aPanelNum, aProviderName, aText, aValue)
	for _, tButton in pairs(VUHDO_getUnitButtonsSafe(aUnit)) do
		VUHDO_getHealthBarText(tButton, aBarNum):SetText(aText);
	end
end
