
-- BURST CACHE ---------------------------------------------------
local _G = _G;
local table = table;
local floor = floor;
local ipairs = ipairs;
local twipe = table.wipe;

local VUHDO_CONFIG;
local VUHDO_PANEL_SETUP;
local VUHDO_RAID;

local VUHDO_getHeaderPos;
local VUHDO_customizeHeader;
local VUHDO_getDynamicModelArray;
local VUHDO_getGroupMembersSorted;
local VUHDO_getHealButton;
local VUHDO_getHealButtonPos;
local VUHDO_setupAllHealButtonAttributes;
local VUHDO_isDifferentButtonPoint;
local VUHDO_addUnitButton;
local VUHDO_getTargetButton;
local VUHDO_getTotButton;
local VUHDO_getOrCreateHealButton;
local VUHDO_updateAllCustomDebuffs;
local VUHDO_getHeaderWidth;
local VUHDO_initAllEventBouquets;
local VUHDO_getActionPanelOrStub;
local VUHDO_isPanelPopulated;
local VUHDO_updateAllRaidBars;
local VUHDO_isTableHeaderOrFooter;
local VUHDO_fixFrameLevels;
local VUHDO_resetNameTextCache;
local VUHDO_reloadRaidMembers;
local VUHDO_isPanelVisible;
local VUHDO_positionHealButton;
local VUHDO_positionTableHeaders;

local sLastDebuffIcon;
local sShowPanels;

function VUHDO_panelRefreshInitLocalOverrides()
	VUHDO_CONFIG = _G["VUHDO_CONFIG"];
	VUHDO_PANEL_SETUP = _G["VUHDO_PANEL_SETUP"];
	VUHDO_RAID = _G["VUHDO_RAID"];

	VUHDO_getHeaderPos = _G["VUHDO_getHeaderPos"];
	VUHDO_customizeHeader = _G["VUHDO_customizeHeader"];
	VUHDO_getDynamicModelArray = _G["VUHDO_getDynamicModelArray"];
	VUHDO_getGroupMembersSorted = _G["VUHDO_getGroupMembersSorted"];
	VUHDO_getHealButton = _G["VUHDO_getHealButton"];
	VUHDO_getHealButtonPos = _G["VUHDO_getHealButtonPos"];
	VUHDO_setupAllHealButtonAttributes = _G["VUHDO_setupAllHealButtonAttributes"];
	VUHDO_isDifferentButtonPoint = _G["VUHDO_isDifferentButtonPoint"];
	VUHDO_addUnitButton = _G["VUHDO_addUnitButton"];
	VUHDO_getTargetButton = _G["VUHDO_getTargetButton"];
	VUHDO_getTotButton = _G["VUHDO_getTotButton"];
	VUHDO_getOrCreateHealButton = _G["VUHDO_getOrCreateHealButton"];
	VUHDO_updateAllCustomDebuffs = _G["VUHDO_updateAllCustomDebuffs"];
	VUHDO_getHeaderWidth = _G["VUHDO_getHeaderWidth"];
	VUHDO_initAllEventBouquets = _G["VUHDO_initAllEventBouquets"];
	VUHDO_getActionPanelOrStub = _G["VUHDO_getActionPanelOrStub"];
	VUHDO_isPanelPopulated = _G["VUHDO_isPanelPopulated"];
	VUHDO_updateAllRaidBars = _G["VUHDO_updateAllRaidBars"];
	VUHDO_isTableHeaderOrFooter = _G["VUHDO_isTableHeaderOrFooter"];
	VUHDO_fixFrameLevels = _G["VUHDO_fixFrameLevels"];
	VUHDO_resetNameTextCache = _G["VUHDO_resetNameTextCache"];
	VUHDO_reloadRaidMembers = _G["VUHDO_reloadRaidMembers"];
	VUHDO_isPanelVisible = _G["VUHDO_isPanelVisible"];
	VUHDO_positionHealButton = _G["VUHDO_positionHealButton"];
	VUHDO_positionTableHeaders = _G["VUHDO_positionTableHeaders"];
	if (VUHDO_CONFIG["DEBUFF_TOOLTIP"]) then
		sLastDebuffIcon = VUHDO_CONFIG["CUSTOM_DEBUFF"]["max_num"] + 39;
	else
		sLastDebuffIcon = -1;
	end
	sShowPanels = VUHDO_CONFIG["SHOW_PANELS"];
end
-- BURST CACHE ---------------------------------------------------



--
local function VUHDO_hasPanelButtons(aPanelNum)
	if not sShowPanels or not VUHDO_IS_SHOWN_BY_GROUP then
		return false;
	end

	return #VUHDO_PANEL_DYN_MODELS[aPanelNum] > 0;
end



--
local tColIdx;
local tButtonIdx;
local tModels;
local tSortBy;
local tPanelName;
local tSetup;
local tX, tY;
local tButton;
local tGroupArray;
local tDebuffFrame;
local function VUHDO_refreshPositionAllHealButtons(aPanel, aPanelNum)
	tSetup = VUHDO_PANEL_SETUP[aPanelNum];
	tModels = VUHDO_getDynamicModelArray(aPanelNum);
	tSortBy = tSetup["MODEL"]["sort"];
	tPanelName = aPanel:GetName();

	tColIdx = 1;
	tButtonIdx = 1;

	for tModelIndex, tModelId in ipairs(tModels) do
		tGroupArray = VUHDO_getGroupMembersSorted(tModelId, tSortBy, aPanelNum, tModelIndex);

		for tGroupIdx, tUnit in ipairs(tGroupArray) do

			tButton = VUHDO_getOrCreateHealButton(tButtonIdx, aPanelNum);
			tButtonIdx = tButtonIdx + 1;

			if tButton["raidid"] ~= tUnit then
				VUHDO_setupAllHealButtonAttributes(tButton, tUnit, false, 70 == tModelId, false, false); -- VUHDO_ID_VEHICLES
				for tCnt = 40, sLastDebuffIcon do
					tDebuffFrame = VUHDO_getBarIconFrame(tButton, tCnt);
					if tDebuffFrame then
						VUHDO_setupAllHealButtonAttributes(tDebuffFrame, tUnit, false, 70 == tModelId, false, true); -- VUHDO_ID_VEHICLES
					end
				end
				VUHDO_setupAllTargetButtonAttributes(VUHDO_getTargetButton(tButton), tUnit);
				VUHDO_setupAllTotButtonAttributes(VUHDO_getTotButton(tButton), tUnit);
			end

			tX, tY = VUHDO_getHealButtonPos(tColIdx, tGroupIdx, aPanelNum);
			if VUHDO_isDifferentButtonPoint(tButton, tX, -tY) then
				tButton:Hide();-- for clearing secure handler mouse wheel bindings
				tButton:SetPoint("TOPLEFT", tPanelName, "TOPLEFT", tX, -tY);
			end

			VUHDO_addUnitButton(tButton, aPanelNum);
			if not tButton:IsShown() then tButton:Show(); end -- Wg. Secure handlers?

			-- Bei Profil-Wechseln existiert der Button schon, hat aber die falsche Größe
			VUHDO_positionHealButton(tButton, tSetup["SCALING"]);
		end

		tColIdx = tColIdx + 1;
	end

	while true do
		tButton = VUHDO_getHealButton(tButtonIdx, aPanelNum);
		if not tButton then break; end

		tButton["raidid"] = nil;
		tButton:SetAttribute("unit", nil);
		tButton:Hide();
		tButtonIdx = tButtonIdx + 1;
	end
end



--
local function VUHDO_refreshInitPanel(aPanel, aPanelNum)
	aPanel:SetHeight(VUHDO_getHealPanelHeight(aPanelNum));
	aPanel:SetWidth(VUHDO_getHealPanelWidth(aPanelNum));
	aPanel:StopMovingOrSizing();
	aPanel["isMoving"] = false;
end



--
local tPanel;
local function VUHDO_refreshPanel(aPanelNum)
	tPanel = VUHDO_getOrCreateActionPanel(aPanelNum);

	if VUHDO_hasPanelButtons(aPanelNum) then
		tPanel:Show();

		VUHDO_refreshInitPanel(tPanel, aPanelNum);
		VUHDO_positionTableHeaders(tPanel, aPanelNum);
	end

	-- Even if model is not in panel, we need to refresh VUHDO_UNIT_BUTTONS
	if VUHDO_isPanelPopulated(aPanelNum) then
		VUHDO_refreshPositionAllHealButtons(tPanel, aPanelNum);
		VUHDO_fixFrameLevels(false, tPanel, 2, tPanel:GetChildren());
	end
end



--
local function VUHDO_refreshAllPanels()
	for tCnt = 1, 10 do -- VUHDO_MAX_PANELS
		if VUHDO_isPanelVisible(tCnt) then
			VUHDO_refreshPanel(tCnt);
		else
			VUHDO_getActionPanelOrStub(tCnt):Hide();
		end
	end

	VUHDO_updateAllRaidBars();
	VUHDO_updatePanelVisibility();
	VuhDoGcdStatusBar:Hide();
end



--
function VUHDO_refreshUiNoMembers()
	VUHDO_resetNameTextCache();
	twipe(VUHDO_UNIT_BUTTONS);
	twipe(VUHDO_UNIT_BUTTONS_PANEL);
	VUHDO_refreshAllPanels();
	VUHDO_updateAllCustomDebuffs(true);
	if VUHDO_INTERNAL_TOGGLES[22] then -- VUHDO_UPDATE_UNIT_TARGET
		VUHDO_rebuildTargets();
	end
	VUHDO_initAllEventBouquets();
	VUHDO_resetDebuffIconDispenser();
end
local VUHDO_refreshUiNoMembers = VUHDO_refreshUiNoMembers;



--
function VUHDO_refreshUI()
	VUHDO_IS_RELOADING = true;

	VUHDO_reloadRaidMembers();
	VUHDO_refreshUiNoMembers();

	VUHDO_IS_RELOADING = false;
end
