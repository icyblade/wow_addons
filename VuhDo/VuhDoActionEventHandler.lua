local VUHDO_IS_SMART_CAST = false;

local IsAltKeyDown = IsAltKeyDown;
local IsControlKeyDown = IsControlKeyDown;
local IsShiftKeyDown = IsShiftKeyDown;
local SecureButton_GetButtonSuffix = SecureButton_GetButtonSuffix;
local InCombatLockdown = InCombatLockdown;
local strlower = strlower;
local strfind = strfind;
local pairs = pairs;
local GameTooltip = GameTooltip;

local sMouseoverUnit = nil;



local VUHDO_updateBouquetsForEvent;
local VUHDO_highlightClusterFor;
local VUHDO_showTooltip;
local VUHDO_hideTooltip;
local VUHDO_resetClusterUnit;
local VUHDO_removeAllClusterHighlights;
local VUHDO_getHealthBar;
local VUHDO_setupSmartCast;
local VUHDO_updateDirectionFrame;
local VUHDO_getPanelButtons;



local VUHDO_SPELL_CONFIG;
local VUHDO_SPELL_ASSIGNMENTS;
local VUHDO_getUnitButtons;
local VUHDO_CONFIG;
local VUHDO_INTERNAL_TOGGLES;
local VUHDO_RAID;
function VUHDO_actionEventHandlerInitBurst()
	VUHDO_updateBouquetsForEvent = VUHDO_GLOBAL["VUHDO_updateBouquetsForEvent"];
	VUHDO_highlightClusterFor = VUHDO_GLOBAL["VUHDO_highlightClusterFor"];
	VUHDO_showTooltip = VUHDO_GLOBAL["VUHDO_showTooltip"];
	VUHDO_hideTooltip = VUHDO_GLOBAL["VUHDO_hideTooltip"];
	VUHDO_resetClusterUnit = VUHDO_GLOBAL["VUHDO_resetClusterUnit"];
	VUHDO_removeAllClusterHighlights = VUHDO_GLOBAL["VUHDO_removeAllClusterHighlights"];
	VUHDO_getHealthBar = VUHDO_GLOBAL["VUHDO_getHealthBar"];
	VUHDO_setupSmartCast = VUHDO_GLOBAL["VUHDO_setupSmartCast"];
	VUHDO_updateDirectionFrame = VUHDO_GLOBAL["VUHDO_updateDirectionFrame"];
	VUHDO_getUnitButtons = VUHDO_GLOBAL["VUHDO_getUnitButtons"];

	VUHDO_SPELL_CONFIG = VUHDO_GLOBAL["VUHDO_SPELL_CONFIG"];
	VUHDO_SPELL_ASSIGNMENTS = VUHDO_GLOBAL["VUHDO_SPELL_ASSIGNMENTS"];
	VUHDO_CONFIG = VUHDO_GLOBAL["VUHDO_CONFIG"];
	VUHDO_INTERNAL_TOGGLES = VUHDO_GLOBAL["VUHDO_INTERNAL_TOGGLES"];
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];
	VUHDO_getPanelButtons = VUHDO_GLOBAL["VUHDO_getPanelButtons"];
end



--
function VUHDO_getCurrentMouseOver()
	return sMouseoverUnit;
end



--
local anIcon, tFrame;
local function VUHDO_placePlayerIcon(aButton, anIconNo, anIndex)
	VUHDO_getBarIconTimer(aButton, anIconNo):SetText("");
	VUHDO_getBarIconCounter(aButton, anIconNo):SetText("");
	VUHDO_getBarIconCharge(aButton, anIconNo):Hide();
	tFrame = VUHDO_getBarIconFrame(aButton, anIconNo);
	tFrame:SetScale(1);
	tFrame:Show();

	anIcon = VUHDO_getBarIcon(aButton, anIconNo);
	anIcon:ClearAllPoints();
	if (anIndex == 2) then
		anIcon:SetPoint("CENTER", aButton:GetName(), "TOPRIGHT", -5, -10);
	else
		if (anIndex > 2) then
			anIndex = anIndex - 1;
		end
		local tCol = floor(anIndex * 0.5);
		local tRow = anIndex - tCol * 2;
		anIcon:SetPoint("TOPLEFT", aButton:GetName(), "TOPLEFT", tCol * 14, -tRow * 14);
	end

	anIcon:SetWidth(16);
	anIcon:SetHeight(16);
	anIcon:SetAlpha(1);
	anIcon:SetVertexColor(1, 1, 1);
	anIcon:Show();
end



--
local tUnitNo, tRank;
local tIsLeader;
local tIsAssist;
local tIsMasterLooter;
function VUHDO_getUnitGroupPrivileges(aUnit)
	tIsLeader, tIsAssist, tIsMasterLooter = false, false, false;

	if (UnitInRaid(aUnit)) then
		tUnitNo = VUHDO_getUnitNo(aUnit);
		if (tUnitNo ~= nil) then
			_, tRank, _, _, _, _, _, _, _, _, tIsMasterLooter = GetRaidRosterInfo(tUnitNo);
			if (tRank == 2) then
				tIsLeader = true;
			elseif (tRank == 1) then
				tIsAssist = true;
			end
		end
	else
		tIsLeader = UnitIsPartyLeader(aUnit);
	end

	return tIsLeader, tIsAssist, tIsMasterLooter;
end
local VUHDO_getUnitGroupPrivileges = VUHDO_getUnitGroupPrivileges;



--
local tUnit;
local tIsLeader;
local tIsAssist;
local tIsMasterLooter;
local tInfo;
local tClass;
local tRole;
local function VUHDO_showPlayerIcons(aButton, aPanelNum)
	tUnit = aButton:GetAttribute("unit");

	tInfo = VUHDO_RAID[tUnit];

	if (tInfo == nil) then
		return;
	end

	tIsLeader, tIsAssist, tIsMasterLooter = VUHDO_getUnitGroupPrivileges(tUnit);

	local tIcon;
	if (tIsLeader) then
		tIcon = VUHDO_getBarIcon(aButton, 1);
		tIcon:SetTexture("Interface\\groupframe\\ui-group-leadericon");
		VUHDO_placePlayerIcon(aButton, 1, 0);
	elseif (tIsAssist) then
		tIcon = VUHDO_getBarIcon(aButton, 1);
		tIcon:SetTexture("Interface\\groupframe\\ui-group-assistanticon");
		VUHDO_placePlayerIcon(aButton, 1, 0);
	end

	if (tIsMasterLooter) then
		tIcon = VUHDO_getBarIcon(aButton, 2);
		tIcon:SetTexture("Interface\\groupframe\\ui-group-masterlooter");
		VUHDO_placePlayerIcon(aButton, 2, 1);
	end

	if (UnitIsPVP(tUnit) and VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["barWidth"] > 54) then
		tIcon = VUHDO_getBarIcon(aButton, 3);

		if ("Alliance" == (UnitFactionGroup(tUnit))) then
			tIcon:SetTexture("Interface\\groupframe\\ui-group-pvp-alliance");
		else
			tIcon:SetTexture("Interface\\groupframe\\ui-group-pvp-horde");
		end

		VUHDO_placePlayerIcon(aButton, 3, 2);
		tIcon:SetWidth(32);
		tIcon:SetHeight(32);
	end

	tClass = tInfo["class"];
	if (tClass ~= nil) then
		tIcon = VUHDO_getBarIcon(aButton, 4);

		tIcon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles");
		tIcon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[tClass]));
		VUHDO_placePlayerIcon(aButton, 4, 3);
	end

	tRole = tInfo["role"];
	if (tRole ~= nil) then
		tIcon = VUHDO_getBarIcon(aButton, 5);
		tIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-ROLES");
		if (VUHDO_ID_MELEE_TANK == tRole) then
			tIcon:SetTexCoord(GetTexCoordsForRole("TANK"));
		elseif (VUHDO_ID_RANGED_HEAL == tRole) then
			tIcon:SetTexCoord(GetTexCoordsForRole("HEALER"));
		else
			tIcon:SetTexCoord(GetTexCoordsForRole("DAMAGER"));
		end
		VUHDO_placePlayerIcon(aButton, 5, 5);
	end
end



--
local tPanelNum;
local tAllButtons;
local tButton;
local tCnt;
function VUHDO_hideAllPlayerIcons()

	for tPanelNum = 1, 10 do -- VUHDO_MAX_PANELS
		VUHDO_initLocalVars(tPanelNum);
		tAllButtons = VUHDO_getPanelButtons(tPanelNum);

		for _, tButton in pairs(tAllButtons) do
			if (tButton:IsShown()) then
				VUHDO_initButtonStatics(tButton, tPanelNum);
				VUHDO_initAllHotIcons();
			end
		end
	end

	VUHDO_removeAllHots();
	VUHDO_suspendHoTs(false);
end



--
local function VUHDO_showAllPlayerIcons(aPanel)
	VUHDO_suspendHoTs(true);
	VUHDO_removeAllHots();
	local tPanelNum = VUHDO_getPanelNum(aPanel);

	local tAllButtons = VUHDO_getPanelButtons(tPanelNum);
	local tButton;

	for _, tButton in pairs(tAllButtons) do
		if (tButton:IsShown()) then
			VUHDO_showPlayerIcons(tButton, tPanelNum);
		end
	end
end



--
local tAllUnits;
local tUnit;
local tInfo;
local tOldMouseover;
function VuhDoActionOnEnter(aButton)
	VUHDO_showTooltip(aButton);

	tOldMouseover = sMouseoverUnit;
	sMouseoverUnit = aButton:GetAttribute("unit");
	if (VUHDO_INTERNAL_TOGGLES[15]) then -- VUHDO_UPDATE_MOUSEOVER
		VUHDO_updateBouquetsForEvent(tOldMouseover, 15); -- Seems to be ghosting sometimes, -- VUHDO_UPDATE_MOUSEOVER
		VUHDO_updateBouquetsForEvent(sMouseoverUnit, 15); -- VUHDO_UPDATE_MOUSEOVER
	end

	if (VUHDO_CONFIG["DIRECTION"]["enable"]) then
		VUHDO_updateDirectionFrame(aButton);
	end

	if (VUHDO_CONFIG["IS_SHOW_GCD"]) then
		VuhDoGcdStatusBar:ClearAllPoints();
		VuhDoGcdStatusBar:SetAllPoints(aButton);
		VuhDoGcdStatusBar:SetValue(0);
		VuhDoGcdStatusBar:Show();
	end

	if (VUHDO_INTERNAL_TOGGLES[18]) then -- VUHDO_UPDATE_MOUSEOVER_CLUSTER
		if (sMouseoverUnit ~= nil) then
			VUHDO_highlightClusterFor(sMouseoverUnit);
		end
	end

	if (VUHDO_INTERNAL_TOGGLES[20]) then -- VUHDO_UPDATE_MOUSEOVER_GROUP
		tInfo = VUHDO_RAID[sMouseoverUnit];
		if (tInfo == nil) then
			return;
		end

		tAllUnits = VUHDO_GROUPS[tInfo["group"]];
		if (tAllUnits ~= nil) then
			for _, tUnit in pairs(tAllUnits) do
				VUHDO_updateBouquetsForEvent(tUnit, 20); -- VUHDO_UPDATE_MOUSEOVER_GROUP
			end
		end
	end
end



--
local tOldMouseover;
local tAllUnits;
local tUnit;
local tInfo;
function VuhDoActionOnLeave(aButton)

	VUHDO_hideTooltip();
	VuhDoDirectionFrame["shown"] = false;
	VuhDoDirectionFrame:Hide();

	tOldMouseover = sMouseoverUnit;
	sMouseoverUnit = nil;
	if (VUHDO_INTERNAL_TOGGLES[15]) then -- VUHDO_UPDATE_MOUSEOVER
		VUHDO_updateBouquetsForEvent(tOldMouseover, 15); -- VUHDO_UPDATE_MOUSEOVER
	end

	if (VUHDO_INTERNAL_TOGGLES[18]) then -- VUHDO_UPDATE_MOUSEOVER_CLUSTER
		VUHDO_resetClusterUnit();
		VUHDO_removeAllClusterHighlights();
	end

	if (VUHDO_INTERNAL_TOGGLES[20]) then -- VUHDO_UPDATE_MOUSEOVER_GROUP
		tInfo = VUHDO_RAID[aButton:GetAttribute("unit")];

		if (tInfo == nil) then
			return;
		end
		tAllUnits = VUHDO_GROUPS[tInfo["group"]];
		if (tAllUnits ~= nil) then
			for _, tUnit in pairs(tAllUnits) do
				VUHDO_updateBouquetsForEvent(tUnit, 20); -- VUHDO_UPDATE_MOUSEOVER_GROUP
			end
		end
	end
end



--
local tAllButtons, tButton, tQuota, tHighlightBar;
function VUHDO_highlighterBouquetCallback(aUnit, anIsActive, anIcon, aCurrValue, aCounter, aMaxValue, aColor, aBuffName, aBouquetName)
	tQuota = (anIsActive or (aMaxValue or 0) > 1)	and 1 or 0;

	tAllButtons = VUHDO_getUnitButtons(aUnit);
	if (tAllButtons ~= nil) then
		for _, tButton in pairs(tAllButtons) do
			tHighlightBar = VUHDO_getHealthBar(tButton, 8);
			if (aColor ~= nil) then
				tHighlightBar:SetVuhDoColor(aColor);
			end
			tHighlightBar:SetValue(tQuota);
		end
	end
end



--
local tModi;
local tKey;
function VuhDoActionPreClick(aButton, aMouseButton)
	if (VUHDO_CONFIG["IS_CLIQUE_COMPAT_MODE"]) then
		return;
	end
	tModi = "";
	if (IsAltKeyDown()) then
		tModi = tModi .. "alt";
	end

	if (IsControlKeyDown()) then
		tModi = tModi .. "ctrl";
	end

	if (IsShiftKeyDown()) then
		tModi = tModi .. "shift";
	end

	tKey = VUHDO_SPELL_ASSIGNMENTS[tModi .. SecureButton_GetButtonSuffix(aMouseButton)];
	if (tKey ~= nil and strlower(tKey[3]) == "menu") then
		if (not InCombatLockdown()) then
			VUHDO_disableActions(aButton);
		end
		VUHDO_setMenuUnit(aButton);
		ToggleDropDownMenu(1, nil, VuhDoPlayerTargetDropDown, aButton:GetName(), 0, -5);
		VUHDO_IS_SMART_CAST = true;
	elseif (tKey ~= nil and strlower(tKey[3]) == "tell") then
		ChatFrame_SendTell(VUHDO_RAID[aButton:GetAttribute("unit")]["name"]);
	else
		if (VUHDO_SPELL_CONFIG["smartCastModi"] == "all"
			or strfind(tModi, VUHDO_SPELL_CONFIG["smartCastModi"], 1, true)) then
			VUHDO_IS_SMART_CAST = VUHDO_setupSmartCast(aButton);
		else
			VUHDO_IS_SMART_CAST = false;
		end
	end
end



--
function VuhDoActionPostClick(aButton)
	if (VUHDO_IS_SMART_CAST) then
		VUHDO_setupAllHealButtonAttributes(aButton, nil, false, false, false, false);
		VUHDO_IS_SMART_CAST = false;
	end
end



---
function VUHDO_startMoving(aPanel)
	if (VuhDoNewOptionsPanelPanel ~= nil
		and VuhDoNewOptionsPanelPanel:IsVisible()) then

		local tNewNum = VUHDO_getComponentPanelNum(aPanel);
		if (tNewNum ~= DESIGN_MISC_PANEL_NUM) then
			VuhDoNewOptionsTabbedFrame:Hide();
			DESIGN_MISC_PANEL_NUM = tNewNum;
			VuhDoNewOptionsTabbedFrame:Show();
			VUHDO_redrawAllPanels();
			return;
		end
	end

	if (IsMouseButtonDown(1) and VUHDO_mayMoveHealPanels()) then
		if (not aPanel["isMoving"]) then
			aPanel["isMoving"] = true;
			if (not InCombatLockdown()) then
				aPanel:SetFrameStrata("TOOLTIP");
			end
			aPanel:StartMoving();
		end
	elseif (IsMouseButtonDown(2) and not InCombatLockdown()
		and (VuhDoNewOptionsPanelPanel == nil or not VuhDoNewOptionsPanelPanel:IsVisible())) then
		VUHDO_showAllPlayerIcons(aPanel);
	end
end



--
function VUHDO_stopMoving(aPanel)
	aPanel:StopMovingOrSizing();
	aPanel["isMoving"] = false;
	if (not InCombatLockdown()) then
		aPanel:SetFrameStrata(VUHDO_PANEL_SETUP[VUHDO_getPanelNum(aPanel)]["frameStrata"]);
	end
	VUHDO_savePanelCoords(aPanel);
	VUHDO_saveCurrentProfilePanelPosition(VUHDO_getPanelNum(aPanel));
	VUHDO_hideAllPlayerIcons();
end



--
local tPosition;
function VUHDO_savePanelCoords(aPanel)
	tPosition = VUHDO_PANEL_SETUP[VUHDO_getPanelNum(aPanel)]["POSITION"];
	tPosition["orientation"], _, tPosition["relativePoint"], tPosition["x"], tPosition["y"] = aPanel:GetPoint(0);
	tPosition["width"] = aPanel:GetWidth();
	tPosition["height"] = aPanel:GetHeight();
end



--
local tButton;
local sDebuffIcon = nil;
function VUHDO_showDebuffTooltip(aDebuffIcon)
	if (not VUHDO_CONFIG["DEBUFF_TOOLTIP"]) then
		return;
	end

	tButton = aDebuffIcon:GetParent():GetParent():GetParent():GetParent();
	GameTooltip:SetOwner(aDebuffIcon, "ANCHOR_RIGHT", 0, 0);

	if (aDebuffIcon["debuffInfo"] ~= nil) then
		if (aDebuffIcon["isBuff"]) then
			GameTooltip:SetUnitBuff(tButton["raidid"], aDebuffIcon["debuffInfo"]);
		else
			GameTooltip:SetUnitDebuff(tButton["raidid"], aDebuffIcon["debuffInfo"]);
		end
	end
	sDebuffIcon = aDebuffIcon;
end



--
function VUHDO_hideDebuffTooltip()
	sDebuffIcon = nil;
	GameTooltip:Hide();
end



--
function VUHDO_updateCustomDebuffTooltip()
	if (sDebuffIcon ~= nil) then
		VUHDO_showDebuffTooltip(sDebuffIcon);
	end
end
