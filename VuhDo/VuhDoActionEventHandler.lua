local _;

local VUHDO_IS_SMART_CAST = false;

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
local VUHDO_getCurrentKeyModifierString;



local VUHDO_SPELL_CONFIG;
local VUHDO_SPELL_ASSIGNMENTS;
local VUHDO_getUnitButtonsSafe;
local VUHDO_CONFIG;
local VUHDO_INTERNAL_TOGGLES;
local VUHDO_RAID;
function VUHDO_actionEventHandlerInitLocalOverrides()
	VUHDO_updateBouquetsForEvent = _G["VUHDO_updateBouquetsForEvent"];
	VUHDO_highlightClusterFor = _G["VUHDO_highlightClusterFor"];
	VUHDO_showTooltip = _G["VUHDO_showTooltip"];
	VUHDO_hideTooltip = _G["VUHDO_hideTooltip"];
	VUHDO_resetClusterUnit = _G["VUHDO_resetClusterUnit"];
	VUHDO_removeAllClusterHighlights = _G["VUHDO_removeAllClusterHighlights"];
	VUHDO_getHealthBar = _G["VUHDO_getHealthBar"];
	VUHDO_setupSmartCast = _G["VUHDO_setupSmartCast"];
	VUHDO_updateDirectionFrame = _G["VUHDO_updateDirectionFrame"];
	VUHDO_getUnitButtonsSafe = _G["VUHDO_getUnitButtonsSafe"];
	VUHDO_getCurrentKeyModifierString = _G["VUHDO_getCurrentKeyModifierString"];

	VUHDO_SPELL_CONFIG = _G["VUHDO_SPELL_CONFIG"];
	VUHDO_SPELL_ASSIGNMENTS = _G["VUHDO_SPELL_ASSIGNMENTS"];
	VUHDO_CONFIG = _G["VUHDO_CONFIG"];
	VUHDO_INTERNAL_TOGGLES = _G["VUHDO_INTERNAL_TOGGLES"];
	VUHDO_RAID = _G["VUHDO_RAID"];
end



--
function VUHDO_getCurrentMouseOver()
	return sMouseoverUnit;
end



--
local function VUHDO_placePlayerIcon(aButton, anIconNo, anIndex)
	VUHDO_getBarIconTimer(aButton, anIconNo):SetText("");
	VUHDO_getBarIconCounter(aButton, anIconNo):SetText("");
	VUHDO_getBarIconCharge(aButton, anIconNo):Hide();

	local tFrame = VUHDO_getBarIconFrame(aButton, anIconNo);
	tFrame:SetScale(1);
	tFrame:Show();

	local anIcon = VUHDO_getBarIcon(aButton, anIconNo);
	anIcon:ClearAllPoints();
	if 2 == anIndex then
		anIcon:SetPoint("CENTER", aButton:GetName(), "TOPRIGHT", -5, -10);
	else
		if anIndex > 2 then anIndex = anIndex - 1; end
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

	if VUHDO_GROUP_TYPE_RAID == VUHDO_getCurrentGroupType() then
		tUnitNo = VUHDO_getUnitNo(aUnit);
		if tUnitNo then
			_, tRank, _, _, _, _, _, _, _, _, tIsMasterLooter = GetRaidRosterInfo(tUnitNo);
			if 2 == tRank then tIsLeader = true;
			elseif 1 == tRank then tIsAssist = true; end
		end
	else
		tIsLeader = UnitIsGroupLeader(aUnit);
	end

	return tIsLeader, tIsAssist, tIsMasterLooter;
end



--
local function VUHDO_showPlayerIcons(aButton, aPanelNum)
	local tUnit = aButton:GetAttribute("unit");
	local tInfo = VUHDO_RAID[tUnit];
	if not tInfo then	return; end

	local tIsLeader, tIsAssist, tIsMasterLooter = VUHDO_getUnitGroupPrivileges(tUnit);
	if tIsLeader or tIsAssist then
		VUHDO_getOrCreateHotIcon(aButton, 1):SetTexture(
			"Interface\\groupframe\\ui-group-" .. (tIsLeader and "leader" or "assistant") .. "icon");
		VUHDO_placePlayerIcon(aButton, 1, 0);
	end

	if tIsMasterLooter then
		VUHDO_getOrCreateHotIcon(aButton, 2):SetTexture("Interface\\groupframe\\ui-group-masterlooter");
		VUHDO_placePlayerIcon(aButton, 2, 1);
	end

	local tIcon;
	if UnitIsPVP(tUnit) and VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["barWidth"] > 54 then
		tIcon = VUHDO_getOrCreateHotIcon(aButton, 3);

		tIcon:SetTexture("Interface\\groupframe\\ui-group-pvp-"
			.. ("Alliance" == (UnitFactionGroup(tUnit)) and "alliance" or "horde"));

		VUHDO_placePlayerIcon(aButton, 3, 2);
		tIcon:SetWidth(32);
		tIcon:SetHeight(32);
	end

	if tInfo["class"] then
		tIcon = VUHDO_getOrCreateHotIcon(aButton, 4);
		tIcon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles");
		tIcon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[tInfo["class"]]));
		VUHDO_placePlayerIcon(aButton, 4, 3);
	end

	if tInfo["role"] then
		tIcon = VUHDO_getOrCreateHotIcon(aButton, 5);
		tIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-ROLES");
		tIcon:SetTexCoord(GetTexCoordsForRole(
			VUHDO_ID_MELEE_TANK == tInfo["role"] and "TANK"
			or VUHDO_ID_RANGED_HEAL == tInfo["role"] and "HEALER"	or "DAMAGER"));
		VUHDO_placePlayerIcon(aButton, 5, 5);
	end
end



--
function VUHDO_hideAllPlayerIcons()

	for tPanelNum = 1, 10 do -- VUHDO_MAX_PANELS
		VUHDO_initLocalVars(tPanelNum);

		for _, tButton in pairs(VUHDO_getPanelButtons(tPanelNum)) do
			if tButton:IsShown() then
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

	for _, tButton in pairs(VUHDO_getPanelButtons(tPanelNum)) do
		if tButton:IsShown() then VUHDO_showPlayerIcons(tButton, tPanelNum); end
	end
end



--
local tAllUnits;
local tInfo;
local tOldMouseover;
function VuhDoActionOnEnter(aButton)
	VUHDO_showTooltip(aButton);

	tOldMouseover = sMouseoverUnit;
	sMouseoverUnit = aButton:GetAttribute("unit");
	if VUHDO_INTERNAL_TOGGLES[15] then -- VUHDO_UPDATE_MOUSEOVER
		VUHDO_updateBouquetsForEvent(tOldMouseover, 15); -- Seems to be ghosting sometimes, -- VUHDO_UPDATE_MOUSEOVER
		VUHDO_updateBouquetsForEvent(sMouseoverUnit, 15); -- VUHDO_UPDATE_MOUSEOVER
	end

	if VUHDO_isShowDirectionArrow() then VUHDO_updateDirectionFrame(aButton); end

	if VUHDO_isShowGcd() then
		VuhDoGcdStatusBar:ClearAllPoints();
		VuhDoGcdStatusBar:SetAllPoints(aButton);
		VuhDoGcdStatusBar:SetValue(0);
		VuhDoGcdStatusBar:Show();
	end

	if VUHDO_INTERNAL_TOGGLES[18] and sMouseoverUnit then -- VUHDO_UPDATE_MOUSEOVER_CLUSTER
		VUHDO_highlightClusterFor(sMouseoverUnit);
	end

	if VUHDO_INTERNAL_TOGGLES[20] then -- VUHDO_UPDATE_MOUSEOVER_GROUP
		tInfo = VUHDO_RAID[sMouseoverUnit];
		if not tInfo then	return;	end

		tAllUnits = VUHDO_GROUPS[tInfo["group"]];
		if tAllUnits then
			for _, tUnit in pairs(tAllUnits) do
				VUHDO_updateBouquetsForEvent(tUnit, 20); -- VUHDO_UPDATE_MOUSEOVER_GROUP
			end
		end
	end
end



--
local tOldMouseover;
local tAllUnits;
local tInfo;
function VuhDoActionOnLeave(aButton)

	VUHDO_hideTooltip();
	VuhDoDirectionFrame["shown"] = false;
	VuhDoDirectionFrame:Hide();

	tOldMouseover = sMouseoverUnit;
	sMouseoverUnit = nil;
	if VUHDO_INTERNAL_TOGGLES[15] then -- VUHDO_UPDATE_MOUSEOVER
		VUHDO_updateBouquetsForEvent(tOldMouseover, 15); -- VUHDO_UPDATE_MOUSEOVER
	end

	if VUHDO_INTERNAL_TOGGLES[18] then -- VUHDO_UPDATE_MOUSEOVER_CLUSTER
		VUHDO_resetClusterUnit();
		VUHDO_removeAllClusterHighlights();
	end

	if VUHDO_INTERNAL_TOGGLES[20] then -- VUHDO_UPDATE_MOUSEOVER_GROUP
		tInfo = VUHDO_RAID[aButton:GetAttribute("unit")];

		if not tInfo then return; end

		tAllUnits = VUHDO_GROUPS[tInfo["group"]];
		if tAllUnits then
			for _, tUnit in pairs(tAllUnits) do
				VUHDO_updateBouquetsForEvent(tUnit, 20); -- VUHDO_UPDATE_MOUSEOVER_GROUP
			end
		end
	end
end



--
local tQuota, tHighlightBar;
function VUHDO_highlighterBouquetCallback(aUnit, anIsActive, anIcon, aCurrValue, aCounter, aMaxValue, aColor, aBuffName, aBouquetName)
	tQuota = (anIsActive or (aMaxValue or 0) > 1)	and 1 or 0;

	for _, tButton in pairs(VUHDO_getUnitButtonsSafe(aUnit)) do
		tHighlightBar = VUHDO_getHealthBar(tButton, 8);
		if aColor then tHighlightBar:SetVuhDoColor(aColor); end
		tHighlightBar:SetValue(tQuota);
	end
end



--
local tModi;
local tKey;
function VuhDoActionPreClick(aButton, aMouseButton)
	if VUHDO_CONFIG["IS_CLIQUE_COMPAT_MODE"] then return; end

	tModi = VUHDO_getCurrentKeyModifierString();
	tKey = VUHDO_SPELL_ASSIGNMENTS[tModi .. SecureButton_GetButtonSuffix(aMouseButton)];

	if tKey and strlower(tKey[3]) == "menu" then
		if not InCombatLockdown() then
			VUHDO_disableActions(aButton);
			VUHDO_IS_SMART_CAST = true;
		end
		VUHDO_setMenuUnit(aButton);
		ToggleDropDownMenu(1, nil, VuhDoPlayerTargetDropDown, aButton:GetName(), 0, -5);

	elseif tKey and strlower(tKey[3]) == "tell" then
		ChatFrame_SendTell(VUHDO_RAID[aButton:GetAttribute("unit")]["name"]);

	else
		if VUHDO_SPELL_CONFIG["smartCastModi"] == "all"
			or strfind(tModi, VUHDO_SPELL_CONFIG["smartCastModi"], 1, true) then
			VUHDO_IS_SMART_CAST = VUHDO_setupSmartCast(aButton);
		else
			VUHDO_IS_SMART_CAST = false;
		end
	end
end



--
function VuhDoActionPostClick(aButton)
	if VUHDO_IS_SMART_CAST then
		VUHDO_setupAllHealButtonAttributes(aButton, nil, false, false, false, false);
		VUHDO_IS_SMART_CAST = false;
	end
end


local sIsStatusShown = false;


---
function VUHDO_startMoving(aPanel)
	if VuhDoNewOptionsPanelPanel and VuhDoNewOptionsPanelPanel:IsVisible() then

		local tNewNum = VUHDO_getComponentPanelNum(aPanel);
		if tNewNum ~= DESIGN_MISC_PANEL_NUM then
			VuhDoNewOptionsTabbedFrame:Hide();
			DESIGN_MISC_PANEL_NUM = tNewNum;
			VuhDoNewOptionsTabbedFrame:Show();
			VUHDO_redrawAllPanels(false);
			return;
		end
	end

	if (IsMouseButtonDown(1) and VUHDO_mayMoveHealPanels()) then
		if (not aPanel["isMoving"]) then
			aPanel["isMoving"] = true;
			if not InCombatLockdown() then aPanel:SetFrameStrata("TOOLTIP"); end
			aPanel:StartMoving();
		end
	elseif IsMouseButtonDown(2) and not InCombatLockdown()
		and (not VuhDoNewOptionsPanelPanel or not VuhDoNewOptionsPanelPanel:IsVisible()) then
		VUHDO_showAllPlayerIcons(aPanel);
		sIsStatusShown = true;
	end
end



--
function VUHDO_stopMoving(aPanel)
	aPanel:StopMovingOrSizing();
	aPanel["isMoving"] = false;
	if not InCombatLockdown() then
		aPanel:SetFrameStrata(VUHDO_PANEL_SETUP[VUHDO_getPanelNum(aPanel)]["frameStrata"]);
	end
	VUHDO_savePanelCoords(aPanel);
	VUHDO_saveCurrentProfilePanelPosition(VUHDO_getPanelNum(aPanel));
	if sIsStatusShown then
		sIsStatusShown = false;
		VUHDO_hideAllPlayerIcons();
		VUHDO_initAllEventBouquets();
	end
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
	if not VUHDO_CONFIG["DEBUFF_TOOLTIP"] then return; end

	tButton = aDebuffIcon:GetParent():GetParent():GetParent():GetParent();
	GameTooltip:SetOwner(aDebuffIcon, "ANCHOR_RIGHT", 0, 0);

	if aDebuffIcon["debuffInfo"] then
		if aDebuffIcon["isBuff"] then GameTooltip:SetUnitBuff(tButton["raidid"], aDebuffIcon["debuffInfo"]);
		else GameTooltip:SetUnitDebuff(tButton["raidid"], aDebuffIcon["debuffInfo"]); end
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
	if sDebuffIcon then VUHDO_showDebuffTooltip(sDebuffIcon); end
end
