local VUHDO_GLOBAL = getfenv();

local VUHDO_STD_BACKDROP = nil;
local VUHDO_DESIGN_BACKDROP = nil;
local VUHDO_CONFIG;
local VUHDO_INDICATOR_CONFIG;


local tonumber = tonumber;
local ipairs = ipairs;
local pairs = pairs;
local strfind = strfind;
local twipe = table.wipe;
local InCombatLockdown = InCombatLockdown;


--
local sBarScaling;
local sSortCriterion;
local sMainFont;
local sStatusTexture;
local sTextAnchors;
local sLifeConfig;
local sMainFontHeight;
local sLifeFontHeight;
local sBarWidth;
local sBarHeight;
local sManaBarHeight;
local sSideBarLeftWidth;
local sSideBarRightWidth;
local sRaidIconSetup;
local sOverhealTextSetup;
local sIsManaBouquet;
local sPanelSetup;
local sShadowAlpha;
local sOutlineText;

local VUHDO_getFont;
local VUHDO_getHealthBar;

--
function VUHDO_panelRedrawInitBurst()
	VUHDO_panelRedrawCustomDebuffsInitBurst();
	VUHDO_panelRedrawHeadersInitBurst();
	VUHDO_panelRedrawHotsInitBurst();

	VUHDO_CONFIG = VUHDO_GLOBAL["VUHDO_CONFIG"];
	VUHDO_INDICATOR_CONFIG = VUHDO_GLOBAL["VUHDO_INDICATOR_CONFIG"];
	sIsManaBouquet = VUHDO_INDICATOR_CONFIG["BOUQUETS"]["MANA_BAR"] ~= "";

	VUHDO_getFont = VUHDO_GLOBAL["VUHDO_getFont"];
	VUHDO_getHealthBar = VUHDO_GLOBAL["VUHDO_getHealthBar"];
end



--
function VUHDO_initLocalVars(aPanelNum)
	--VUHDO_panelRedrwawHeadersInitLocalVars(aPanelNum);
	VUHDO_panelRedrwawHotsInitLocalVars(aPanelNum);
	VUHDO_panelRedrwawCustomDebuffsInitLocalVars(aPanelNum);

	sPanelSetup = VUHDO_PANEL_SETUP[aPanelNum];
	sBarScaling = sPanelSetup["SCALING"];
	sRaidIconSetup = sPanelSetup["RAID_ICON"];
	sOverhealTextSetup = sPanelSetup["OVERHEAL_TEXT"];
	sSortCriterion = sPanelSetup["MODEL"]["sort"];
	sMainFont = VUHDO_getFont(sPanelSetup["PANEL_COLOR"]["TEXT"]["font"]);
	sStatusTexture = VUHDO_LibSharedMedia:Fetch('statusbar', sPanelSetup["PANEL_COLOR"]["barTexture"]);
	sTextAnchors = VUHDO_splitString(sPanelSetup["ID_TEXT"]["position"], "+");
	sLifeConfig = sPanelSetup["LIFE_TEXT"];
	sMainFontHeight = sPanelSetup["PANEL_COLOR"]["TEXT"]["textSize"];
	sLifeFontHeight = sPanelSetup["PANEL_COLOR"]["TEXT"]["textSizeLife"];

	sOutlineText = sPanelSetup["PANEL_COLOR"]["TEXT"]["outline"] and "OUTLINE|" or "";
	if (sPanelSetup["PANEL_COLOR"]["TEXT"]["USE_MONO"]) then
		sOutlineText = sOutlineText .. "MONOCHROME";
	end
	sShadowAlpha = sPanelSetup["PANEL_COLOR"]["TEXT"]["USE_SHADOW"] and 1 or 0;

	sBarHeight = VUHDO_getHealthBarHeight(aPanelNum);
	sBarWidth = VUHDO_getHealthBarWidth(aPanelNum);
	sManaBarHeight  = VUHDO_getManaBarHeight(aPanelNum);
	sSideBarLeftWidth = VUHDO_getSideBarWidthLeft(aPanelNum);
	sSideBarRightWidth = VUHDO_getSideBarWidthRight(aPanelNum);
	if (sManaBarHeight == 0) then
		sManaBarHeight = 0.001;
	end
end
local VUHDO_initLocalVars = VUHDO_initLocalVars;



--
function VUHDO_isPanelVisible(aPanelNum)
	if (not VUHDO_CONFIG["SHOW_PANELS"] or VUHDO_PANEL_MODELS[aPanelNum] == nil or not VUHDO_IS_SHOWN_BY_GROUP) then
		return false;
	end

	if (VUHDO_isModelInPanel(aPanelNum, 42) -- VUHDO_ID_PRIVATE_TANKS
		and (not VUHDO_CONFIG["OMIT_TARGET"] or not VUHDO_CONFIG["OMIT_FOCUS"])) then

		return true;
	end

	if (VUHDO_CONFIG["HIDE_EMPTY_PANELS"] and not VUHDO_isConfigPanelShowing()
		and #VUHDO_PANEL_UNITS[aPanelNum] == 0) then
		return false;
	end

	return true;
end
local VUHDO_isPanelVisible = VUHDO_isPanelVisible;



--
function VUHDO_isPanelPopulated(aPanelNum)
	return VUHDO_CONFIG["SHOW_PANELS"] and VUHDO_PANEL_MODELS[aPanelNum] ~= nil and VUHDO_IS_SHOWN_BY_GROUP;
end
local VUHDO_isPanelPopulated = VUHDO_isPanelPopulated;



--
--
local tModelArray;
local tModelIndex, tModelId;
local tMemberNum;
local function VUHDO_getNumButtonsPanel(aPanelNum)
	tModelArray = VUHDO_getDynamicModelArray(aPanelNum);
	tMemberNum = 0;

	for tModelIndex, tModelId in pairs(tModelArray)  do
		tMemberNum = tMemberNum + #VUHDO_getGroupMembers(tModelId, aPanelNum, tModelIndex);
	end

	return tMemberNum;
end



--
local tBackdrop, tBorderCol;
local tWidth, tGap;
local function VUHDO_initPlayerTargetBorder(aButton, aBorderFrame, anIsNoIndicator)

	if (VUHDO_INDICATOR_CONFIG["BOUQUETS"]["BAR_BORDER"] == "") then
		aBorderFrame:Hide();
		aBorderFrame:ClearAllPoints();
		return;
	end

	tWidth = VUHDO_INDICATOR_CONFIG["CUSTOM"]["BAR_BORDER"]["WIDTH"];
	tGap = tWidth + VUHDO_INDICATOR_CONFIG["CUSTOM"]["BAR_BORDER"]["ADJUST"];
	aBorderFrame:SetPoint("TOPLEFT", aButton:GetName(), "TOPLEFT", -tGap, tGap);
	aBorderFrame:SetPoint("BOTTOMRIGHT", aButton:GetName(), "BOTTOMRIGHT", tGap, -tGap);
	if (tBackdrop ==  nil) then
		tBackdrop = aBorderFrame:GetBackdrop();
		tBackdrop["edgeSize"] = tWidth;
		tBackdrop["edgeFile"] = VUHDO_INDICATOR_CONFIG["CUSTOM"]["BAR_BORDER"]["FILE"];
		tBackdrop["insets"]["left"] = 0;
		tBackdrop["insets"]["right"] = 0;
		tBackdrop["insets"]["top"] = 0;
		tBackdrop["insets"]["bottom"] = 0;
	end
	aBorderFrame:SetBackdrop(tBackdrop);
	aBorderFrame:SetBackdropBorderColor(0, 0, 0, 1);
	if (anIsNoIndicator) then
		aBorderFrame:Show();
	else
		aBorderFrame:Hide();
	end
end



--
local tBackdropCluster;
local tClusterFrame;
local function VUHDO_initClusterBorder(aButton)
	tClusterFrame = VUHDO_getClusterBorderFrame(aButton);
	tClusterFrame:Hide();

	if (VUHDO_INDICATOR_CONFIG["BOUQUETS"]["CLUSTER_BORDER"] == "") then
		tClusterFrame:ClearAllPoints();
		return;
	end

	tClusterFrame:SetPoint("TOPLEFT", aButton:GetName(), "TOPLEFT", 0, 0);
	tClusterFrame:SetPoint("BOTTOMRIGHT", aButton:GetName(), "BOTTOMRIGHT", 0, 0);
	if (tBackdropCluster ==  nil) then
		tBackdropCluster = tClusterFrame:GetBackdrop();
		tBackdropCluster["edgeSize"] = VUHDO_INDICATOR_CONFIG["CUSTOM"]["CLUSTER_BORDER"]["WIDTH"];
		tBackdropCluster["edgeFile"] = VUHDO_INDICATOR_CONFIG["CUSTOM"]["CLUSTER_BORDER"]["FILE"];
		tBackdropCluster["insets"]["left"] = 0;
		tBackdropCluster["insets"]["right"] = 0;
		tBackdropCluster["insets"]["top"] = 0;
		tBackdropCluster["insets"]["bottom"] = 0;
	end
	tClusterFrame:SetBackdrop(tBackdropCluster);
	tClusterFrame:SetBackdropColor(0, 0, 0, 0);
end



--
local tIncBar;
function VUHDO_positionHealButton(aButton)
	aButton:SetWidth(sBarScaling["barWidth"]);
	aButton:SetHeight(sBarScaling["barHeight"]);

	-- Player Target
	VUHDO_initPlayerTargetBorder(aButton, VUHDO_getPlayerTargetFrame(aButton), false);
	VUHDO_initPlayerTargetBorder(VUHDO_getTargetButton(aButton), VUHDO_getPlayerTargetFrameTarget(aButton), true);
	VUHDO_initPlayerTargetBorder(VUHDO_getTotButton(aButton), VUHDO_getPlayerTargetFrameToT(aButton), true);

	-- Cluster indicator
	VUHDO_initClusterBorder(aButton);
end
local VUHDO_positionHealButton = VUHDO_positionHealButton;



--
local tHealthBar;
local function VUHDO_initHealthBar(aButton)
	tHealthBar = VUHDO_getHealthBar(aButton, 1);
	tHealthBar:SetPoint("TOPLEFT", VUHDO_getHealthBar(aButton, 6):GetName(), "TOPLEFT", 0, 0); -- Incoming bar
	tHealthBar:SetWidth(sBarWidth);
	tHealthBar:SetHeight(sBarHeight);
end



--
local tFrame;
local function VUHDO_registerFacadeIcon(aButton, aNum, aGroup)
	tFrame = VUHDO_getBarIconFrame(aButton, aNum);
	VUHDO_getBarIcon(aButton, aNum):SetTexCoord(0, 1, 0, 1);

	VUHDO_LibButtonFacade:Group("VuhDo", aGroup):AddButton(tFrame, {
		["Icon"] = VUHDO_getBarIcon(aButton, aNum),
	});
end



--
local tCnt;
local tLeft, tRight, tTop, tBottom;
function VUHDO_initButtonButtonFacade(aButton)
	if (VUHDO_LibButtonFacade ~= nil) then
		for tCnt = 1, 5 do
			VUHDO_registerFacadeIcon(aButton, tCnt, VUHDO_I18N_HOTS);
		end
		for tCnt = 9, 10 do
			VUHDO_registerFacadeIcon(aButton, tCnt, VUHDO_I18N_HOTS);
		end
		tLeft, tTop, _, _, _, _, tRight, tBottom = VUHDO_getBarIcon(aButton, 1):GetTexCoord();
		VUHDO_hotsSetClippings(tLeft, tRight, tTop, tBottom);
	end
end



--
local tModelIndex;
local tBorderCol;
local tXPos,  tYPos;
local tHealButton;
local tUnit;
local tGroupArray;
local tModelId;
local tGroupIndex, tColIdx, tBtnIdx;
local tBorderCol;
local tModelArray;
local tPanelName;
local tCnt;
local function VUHDO_positionAllHealButtons(aPanel, aPanelNum)
	tModelArray = VUHDO_getDynamicModelArray(aPanelNum);
	tPanelName  = aPanel:GetName();

	tColIdx = 1;
	tBtnIdx = 1;

	tBorderCol  = nil;

	for tModelIndex,  tModelId  in ipairs(tModelArray)  do
		tGroupArray = VUHDO_getGroupMembersSorted(tModelId, sSortCriterion, aPanelNum, tModelIndex);
		tGroupIndex = 1;
		for tGroupIndex, tUnit  in ipairs(tGroupArray)  do
			tHealButton = VUHDO_getHealButton(tBtnIdx, aPanelNum);

			tBtnIdx  = tBtnIdx  + 1;
			if (tBtnIdx > 51) then -- VUHDO_MAX_BUTTONS_PANEL
				return;
			end

			VUHDO_positionHealButton(tHealButton);

			VUHDO_setupAllHealButtonAttributes(tHealButton, tUnit, false, 70 == tModelId, false, false); -- VUHDO_ID_VEHICLES
			for tCnt = 40, VUHDO_CONFIG["CUSTOM_DEBUFF"]["max_num"] + 39 do
				VUHDO_setupAllHealButtonAttributes(VUHDO_getBarIconFrame(tHealButton, tCnt), tUnit, false, 70 == tModelId, false, true); -- VUHDO_ID_VEHICLES
			end
			VUHDO_setupAllTargetButtonAttributes(VUHDO_getTargetButton(tHealButton),  tUnit);
			VUHDO_setupAllTotButtonAttributes(VUHDO_getTotButton(tHealButton), tUnit);

			tXPos, tYPos = VUHDO_getHealButtonPos(tColIdx, tGroupIndex, aPanelNum);
			tHealButton:Hide();
			tHealButton:ClearAllPoints();
			tHealButton:SetPoint("TOPLEFT", tPanelName, "TOPLEFT", tXPos, -tYPos);
			VUHDO_addUnitButton(tHealButton);
			tHealButton:Show();
		end

		tColIdx = tColIdx + 1;
	end
end


--


local sButton;
local sHealthBar;



--
local function VUHDO_initAggroTexture()
	VUHDO_getAggroTexture(sHealthBar):Hide();
end



--
local tInfo;
local tManaHeight;
local function VUHDO_initManaBar(aButton, aManaBar, aWidth, anIsForceBar)
	aManaBar:SetPoint("BOTTOMLEFT", aButton:GetName(),  "BOTTOMLEFT", 0, 0);
	VUHDO_setLlcStatusBarTexture(aManaBar, VUHDO_INDICATOR_CONFIG["CUSTOM"]["MANA_BAR"]["TEXTURE"]);

	tInfo = VUHDO_RAID[aButton["raidid"]];
	if (anIsForceBar or tInfo == nil or sIsManaBouquet) then
		tManaHeight = sManaBarHeight;
	else
		tManaHeight = 0;
	end

	aManaBar:SetWidth(aWidth);
	aButton["regularHeight"] = sBarScaling["barHeight"];
	if (sIsManaBouquet) then
		aManaBar:Show();
		aManaBar:SetHeight(tManaHeight);
		if (VUHDO_getHealthBar(aButton, 1):GetHeight() == 0) then
			VUHDO_getHealthBar(aButton, 1):SetHeight(sBarHeight);
		end
	else
		aManaBar:Hide();
		VUHDO_getHealthBar(aButton, 1):SetHeight(sBarHeight + sManaBarHeight);
	end
end



--
local function VUHDO_initBackgroundBar(aBgBar)
	VUHDO_setLlcStatusBarTexture(aBgBar, VUHDO_INDICATOR_CONFIG["CUSTOM"]["BACKGROUND_BAR"]["TEXTURE"]);
	aBgBar:SetHeight(sBarScaling["barHeight"]);
	aBgBar:SetValue(1);
	aBgBar:SetStatusBarColor(0, 0, 0, 0);
	aBgBar:Show();
end



--
local tIncBar;
local function VUHDO_initIncomingBar()
	tIncBar = VUHDO_getHealthBar(sButton, 6);
	tIncBar:SetValueRange(0, 0);
	tIncBar:SetPoint("TOPLEFT", VUHDO_getHealthBar(sButton, 3):GetName(), "TOPLEFT", sSideBarLeftWidth, 0); -- Background bar
	tIncBar:SetWidth(sBarWidth);
	tIncBar:SetHeight(sBarHeight);
end



--
local tThreatBar;
local function VUHDO_initThreatBar()
	tThreatBar = VUHDO_getHealthBar(sButton, 7);

	if (VUHDO_INDICATOR_CONFIG["BOUQUETS"]["THREAT_BAR"] == "") then
		tThreatBar:Hide();
		return;
	end

	tThreatBar:Show();
	VUHDO_setLlcStatusBarTexture(tThreatBar, VUHDO_INDICATOR_CONFIG["CUSTOM"]["THREAT_BAR"]["TEXTURE"]);
	tThreatBar:SetValue(0);
	tThreatBar:SetStatusBarColor(0, 0, 0, 0);
	tThreatBar:SetHeight(VUHDO_INDICATOR_CONFIG["CUSTOM"]["THREAT_BAR"]["HEIGHT"]);
end



--
local tTextPanel;
local tNameText;
local tLifeText;
local tAddHeight;
local function VUHDO_initBarTexts(aButton, aHealthBar, aWidth)
	tTextPanel  = VUHDO_getTextPanel(aHealthBar);
	tNameText = VUHDO_getBarText(aHealthBar);
	tLifeText = VUHDO_getLifeText(aHealthBar);

	tNameText:SetWidth(aWidth);
	tNameText:SetHeight(sMainFontHeight);
	tNameText:SetFont(sMainFont, sMainFontHeight, sOutlineText);
	tNameText:SetShadowColor(0, 0, 0, sShadowAlpha);

	tLifeText:SetFont(sMainFont, sLifeFontHeight, sOutlineText);
	tLifeText:SetShadowColor(0, 0, 0, sShadowAlpha);
	tLifeText:SetText("");

	tNameText:ClearAllPoints();
	tAddHeight  = 0;

	if (VUHDO_LT_POS_RIGHT == sLifeConfig["position"]
		or VUHDO_LT_POS_LEFT == sLifeConfig["position"]
		or (not sLifeConfig["show"] and not sPanelSetup["ID_TEXT"]["showTags"])) then

		tLifeText:SetWidth(0);
		tLifeText:SetHeight(0);
		tNameText:SetPoint("CENTER", tTextPanel:GetName(), "CENTER", 0, 0);
		tLifeText:Hide();
	else
		tLifeText:ClearAllPoints();
		tLifeText:SetWidth(aWidth);
		tLifeText:SetHeight(sLifeFontHeight);
		tAddHeight  = sLifeFontHeight;

		if (VUHDO_LT_POS_BELOW == sLifeConfig["position"]) then
			tNameText:SetPoint("TOP", tTextPanel:GetName(), "TOP", 0, 0);
			tLifeText:SetPoint("TOP", tNameText:GetName(), "BOTTOM", 0, 0);
		else
			tNameText:SetPoint("BOTTOM", tTextPanel:GetName(), "BOTTOM", 0, 0);
			tLifeText:SetPoint("BOTTOM", tNameText:GetName(), "TOP", 0, 0);
		end
		tLifeText:Show();
	end

	tTextPanel:SetHeight(tNameText:GetHeight() + tAddHeight);
	tTextPanel:SetWidth(aWidth);

	sPanelSetup["ID_TEXT"]["_spacing"] = tTextPanel:GetHeight(); -- internal marker

	if (strfind(sTextAnchors[1], "LEFT", 1, true)) then
		tNameText:SetJustifyH("LEFT");
		tLifeText:SetJustifyH("LEFT");
	elseif (strfind(sTextAnchors[1], "RIGHT", 1, true)) then
		tNameText:SetJustifyH("RIGHT");
		tLifeText:SetJustifyH("RIGHT");
	else
		tNameText:SetJustifyH("CENTER");
		tLifeText:SetJustifyH("CENTER");
	end

	local tAnchorObject;
	if (strfind(sTextAnchors[1], "BOTTOM", 1, true) and strfind(sTextAnchors[2], "TOP", 1, true) -- über Button
		and VUHDO_INDICATOR_CONFIG["BOUQUETS"]["THREAT_BAR"] ~= "") then
		tAnchorObject = VUHDO_getHealthBar(aButton, 7) or aButton; -- Target und Tot hat keinen Threat bar
	elseif (strfind(sTextAnchors[2], "BOTTOM", 1, true) and strfind(sTextAnchors[1], "TOP", 1, true)) then
		tAnchorObject = aButton;
	else
		tAnchorObject = aHealthBar;
	end

	tTextPanel:ClearAllPoints();
	tTextPanel:SetPoint(sTextAnchors[1],  tAnchorObject:GetName(),  sTextAnchors[2], sPanelSetup["ID_TEXT"]["xAdjust"], -sPanelSetup["ID_TEXT"]["yAdjust"]);
end



--
local tX, tY;
local tOvhColor;
local tOvhText;
local tOvhPanel;
local function VUHDO_initOverhealText(aHealthBar, aWidth)
	tOvhText = VUHDO_getOverhealText(aHealthBar);
	tOvhText:SetWidth(400);
	tOvhText:SetHeight(sMainFontHeight);
	tOvhColor = VUHDO_PANEL_SETUP["BAR_COLORS"]["OVERHEAL_TEXT"];
	tOvhText:SetTextColor(tOvhColor["TR"], tOvhColor["TG"], tOvhColor["TB"], tOvhColor["TO"]);
	tOvhText:SetFont(sMainFont, sMainFontHeight);
	tOvhText:SetJustifyH("CENTER");
	tOvhText:SetText("");

	tOvhPanel = VUHDO_getOverhealPanel(aHealthBar);
	tOvhPanel:SetHeight(1);
	tOvhPanel:SetWidth(1);

	tX = sOverhealTextSetup["xAdjust"] * aWidth * 0.01;
	tY = -sOverhealTextSetup["yAdjust"] * sBarScaling["barHeight"] * 0.01;
	tOvhPanel:ClearAllPoints();
	tOvhPanel:SetPoint(sOverhealTextSetup["point"],  aHealthBar:GetName(), sOverhealTextSetup["point"], tX, tY);
end



--
local tAggroBar;
local function VUHDO_initAggroBar()
	tAggroBar = VUHDO_getHealthBar(sButton, 4);

	if (VUHDO_INDICATOR_CONFIG["BOUQUETS"]["AGGRO_BAR"] == "") then
		tAggroBar:ClearAllPoints();
		tAggroBar:Hide();
		return;
	end

	VUHDO_setLlcStatusBarTexture(tAggroBar, VUHDO_INDICATOR_CONFIG["CUSTOM"]["AGGRO_BAR"]["TEXTURE"]);
	tAggroBar:SetPoint("BOTTOM", sHealthBar:GetName(), "TOP", 0, 0);
	tAggroBar:SetWidth(sBarScaling["barWidth"]);
	tAggroBar:SetHeight(sBarScaling["rowSpacing"]);
	tAggroBar:SetValue(0);
	tAggroBar:Show();
end



--
local tX, tY;
local function VUHDO_initRaidIcon(aHealthBar, anIcon, aWidth)
	tX = sRaidIconSetup["xAdjust"] * aWidth * 0.01;
	tY = -sRaidIconSetup["yAdjust"] * sBarScaling["barHeight"] * 0.01;

	anIcon:Hide();
	anIcon:ClearAllPoints();
	anIcon:SetPoint(sRaidIconSetup["point"], aHealthBar:GetName(), sRaidIconSetup["point"], tX, tY);
	anIcon:SetWidth(sBarScaling["barHeight"]  * sRaidIconSetup["scale"] /  1.5);
	anIcon:SetHeight(sBarScaling["barHeight"] * sRaidIconSetup["scale"] / 1.5);
end



--
local tIcon, tHeight;
local function VUHDO_initSwiftmendIndicator()
	tIcon = VUHDO_getBarRoleIcon(sButton, 51);
	tIcon:ClearAllPoints();
	tIcon:Hide();

	if (VUHDO_INDICATOR_CONFIG["BOUQUETS"]["SWIFTMEND_INDICATOR"] == "") then
		return;
	end

	tIcon:SetPoint("CENTER",  sHealthBar:GetName(), "TOPLEFT",  sBarScaling["barWidth"] / 5.5, -sBarScaling["barHeight"]  / 14);
	tHeight = sBarScaling["barHeight"] * 0.5 * VUHDO_INDICATOR_CONFIG["CUSTOM"]["SWIFTMEND_INDICATOR"]["SCALE"];
	tIcon:SetWidth(tHeight);
	tIcon:SetHeight(tHeight);
end



--
local tTgButton;
local tTgHealthBar;
local tBackgroundBar;
local function VUHDO_initTargetBar()
	if (sBarScaling["showTarget"]) then
		tTgButton = VUHDO_getTargetButton(sButton);
		tTgButton:SetAlpha(0);
		tTgButton:ClearAllPoints();

		if (sBarScaling["targetOrientation"] == 1) then
			tTgButton:SetPoint("TOPLEFT", sButton:GetName(), "TOPRIGHT", sBarScaling["targetSpacing"],  0);
		else
			tTgButton:SetPoint("TOPRIGHT",  sButton:GetName(), "TOPLEFT", -sBarScaling["targetSpacing"],  0);
		end

		tTgButton:SetWidth(sBarScaling["targetWidth"]);
		tTgButton:SetHeight(sBarScaling["barHeight"]);
		tTgButton:Show();

		tTgHealthBar = VUHDO_getHealthBar(sButton, 5);
		tTgHealthBar:SetValue(1);
		tTgHealthBar:SetHeight(sBarHeight);

		VUHDO_initBackgroundBar(VUHDO_getHealthBar(sButton, 12));
		VUHDO_initManaBar(tTgButton, VUHDO_getHealthBar(sButton, 13), sBarScaling["targetWidth"], true);
		VUHDO_initRaidIcon(tTgHealthBar, VUHDO_getTargetBarRoleIcon(tTgButton, 50), sBarScaling["targetWidth"]);
		VUHDO_initBarTexts(tTgButton, tTgHealthBar, sBarScaling["targetWidth"]);
		VUHDO_initOverhealText(tTgHealthBar, sBarScaling["targetWidth"]);
		tBackgroundBar = VUHDO_getHealthBar(tTgButton, 3);
		if (VUHDO_INDICATOR_CONFIG["BOUQUETS"]["BACKGROUND_BAR"] ~= "") then
			tBackgroundBar:SetStatusBarColor(0, 0, 0, 0.4);
		else
			tBackgroundBar:SetStatusBarColor(0, 0, 0, 0);
		end
	else
		VUHDO_getTargetButton(sButton):Hide();
	end
end



--
local tTotButton;
local tTgHealthBar;
local function VUHDO_initTotBar()
	if (sBarScaling["showTot"])  then
		tTotButton  = VUHDO_getTotButton(sButton);
		tTotButton:SetAlpha(0);
		tTotButton:ClearAllPoints();

		if (sBarScaling["targetOrientation"] == 1) then
			if (sBarScaling["showTarget"]) then
				tTgButton = VUHDO_getTargetButton(sButton);
				tTotButton:SetPoint("TOPLEFT",  tTgButton:GetName(), "TOPRIGHT", sBarScaling["totSpacing"],  0);
			else
				tTotButton:SetPoint("TOPLEFT",  sHealthBar:GetName(), "TOPRIGHT", sBarScaling["totSpacing"], 0);
			end
		else
			if (sBarScaling["showTarget"]) then
				tTgButton = VUHDO_getTargetButton(sButton);
				tTotButton:SetPoint("TOPRIGHT", tTgButton:GetName(), "TOPLEFT", -sBarScaling["totSpacing"],  0);
			else
				tTotButton:SetPoint("TOPRIGHT", sHealthBar:GetName(), "TOPLEFT", -sBarScaling["totSpacing"], 0);
			end
		end

		tTotButton:SetWidth(sBarScaling["totWidth"]);
		tTotButton:SetHeight(sBarScaling["barHeight"]);
		tTotButton:Show();

		tTgHealthBar = VUHDO_getHealthBar(sButton, 14);
		tTgHealthBar:SetValue(1);
		tTgHealthBar:SetHeight(sBarHeight);

		VUHDO_initBackgroundBar(VUHDO_getHealthBar(sButton, 15));
		VUHDO_initManaBar(tTotButton, VUHDO_getHealthBar(sButton, 16), sBarScaling["totWidth"], true);
		VUHDO_initRaidIcon(tTgHealthBar, VUHDO_getTargetBarRoleIcon(tTotButton, 50), sBarScaling["totWidth"]);
		VUHDO_initBarTexts(tTgButton, tTgHealthBar, sBarScaling["totWidth"]);
		VUHDO_initOverhealText(tTgHealthBar, sBarScaling["totWidth"]);

		tBackgroundBar = VUHDO_getHealthBar(tTotButton, 3);
		if (VUHDO_INDICATOR_CONFIG["BOUQUETS"]["BACKGROUND_BAR"] ~= "") then
			tBackgroundBar:SetStatusBarColor(0, 0, 0, 0.4);
		else
			tBackgroundBar:SetStatusBarColor(0, 0, 0, 0);
		end
	else
		VUHDO_getTotButton(sButton):Hide();
	end
end



--
local tFlashBar;
local function VUHDO_initFlashBar()
	tFlashBar = VUHDO_GLOBAL[sButton:GetName() .. "BgBarIcBarHlBarFlBar"];
	tFlashBar:SetStatusBarTexture("Interface\\AddOns\\VuhDo\\Images\\white_square_16_16");
	tFlashBar:SetStatusBarColor(1, 0.8, 0.8, 1);
	tFlashBar:Hide();
end



--
function VUHDO_initReadyCheckIcon(aButton)
	VUHDO_getBarRoleIcon(aButton, 20):Hide();
end



--
local tHighlightBar;
local function VUHDO_initHighlightBar()
	if (VUHDO_INDICATOR_CONFIG["BOUQUETS"]["MOUSEOVER_HIGHLIGHT"] == "") then
		VUHDO_getHealthBar(sButton, 8):Hide();
		return;
	end

	tHighlightBar = VUHDO_getHealthBar(sButton, 8);
	tHighlightBar:SetAlpha(0);
	VUHDO_setLlcStatusBarTexture(tHighlightBar, VUHDO_INDICATOR_CONFIG["CUSTOM"]["MOUSEOVER_HIGHLIGHT"]["TEXTURE"]);
	tHighlightBar:SetValue(0);
	tHighlightBar:Show();
end



--
local tSideBar;
local function VUHDO_initSideBarLeft(aButton)
	tSideBar = VUHDO_getHealthBar(sButton, 17);

	if (VUHDO_INDICATOR_CONFIG["BOUQUETS"]["SIDE_LEFT"] == "") then
		tSideBar:ClearAllPoints();
		tSideBar:Hide();
		return;
	end

	tSideBar:SetPoint("RIGHT", sHealthBar:GetName(), "LEFT", 0, 0);
	tSideBar:SetWidth(sSideBarLeftWidth);
	tSideBar:SetHeight(sBarHeight);
	VUHDO_setLlcStatusBarTexture(tSideBar, VUHDO_INDICATOR_CONFIG["CUSTOM"]["SIDE_LEFT"]["TEXTURE"]);
	tSideBar:SetValue(0);
	tSideBar:Show();
end



--
local tSideBar;
local function VUHDO_initSideBarRight(aButton)
	tSideBar = VUHDO_getHealthBar(sButton, 18);

	if (VUHDO_INDICATOR_CONFIG["BOUQUETS"]["SIDE_RIGHT"] == "") then
		tSideBar:ClearAllPoints();
		tSideBar:Hide();
		return;
	end

	tSideBar:SetPoint("LEFT", sHealthBar:GetName(), "RIGHT", 0, 0);
	tSideBar:SetWidth(sSideBarRightWidth);
	tSideBar:SetHeight(sBarHeight);
	VUHDO_setLlcStatusBarTexture(tSideBar, VUHDO_INDICATOR_CONFIG["CUSTOM"]["SIDE_RIGHT"]["TEXTURE"]);
	tSideBar:SetValue(0);
	tSideBar:Show();
end



--
function VUHDO_initButtonStatics(aButton, aPanelNum)
	VUHDO_initButtonStaticsHots(aButton, aPanelNum);
	VUHDO_initButtonStaticsCustomDebuffs(aButton, aPanelNum);

	sButton = aButton;
	sHealthBar = VUHDO_getHealthBar(aButton,  1);
end
local VUHDO_initButtonStatics = VUHDO_initButtonStatics;



--
local function VUHDO_getStatusbarOrientationString(anIndicatorName)
	if (VUHDO_INDICATOR_CONFIG["CUSTOM"][anIndicatorName]["vertical"]) then
		if (VUHDO_INDICATOR_CONFIG["CUSTOM"][anIndicatorName]["turnAxis"]) then
			return "VERTICAL_INV";
		else
			return "VERTICAL";
		end
	else
		if (VUHDO_INDICATOR_CONFIG["CUSTOM"][anIndicatorName]["turnAxis"]) then
			return "HORIZONTAL_INV";
		else
			return "HORIZONTAL";
		end
	end
end



--
local tCnt;
local tHealthBar, tIsInverted, tOrientation, tIconNum;
function VUHDO_initHealButton(aButton, aPanelNum)

	if (VUHDO_CONFIG["ON_MOUSE_UP"]) then
		aButton:RegisterForClicks("AnyUp");
		for tCnt = 40, 44 do
			VUHDO_getBarIconFrame(aButton, tCnt):RegisterForClicks("AnyUp");
		end
	else
		aButton:RegisterForClicks("AnyDown");
		for tCnt = 40, 44 do
			VUHDO_getBarIconFrame(aButton, tCnt):RegisterForClicks("AnyDown");
		end
	end

	-- Texture
	for tCnt =  1, 16 do
		tHealthBar = VUHDO_getHealthBar(aButton, tCnt);

		if (sStatusTexture ~= nil) then
			tHealthBar:SetStatusBarTexture(sStatusTexture);
		end
	end

	-- Invert Growth
	tIsInverted = VUHDO_INDICATOR_CONFIG["CUSTOM"]["HEALTH_BAR"]["invertGrowth"];
	VUHDO_getHealthBar(aButton, 1):SetIsInverted(tIsInverted);
	VUHDO_getHealthBar(aButton, 5):SetIsInverted(tIsInverted);
	VUHDO_getHealthBar(aButton, 6):SetIsInverted(tIsInverted);
	VUHDO_getHealthBar(aButton, 14):SetIsInverted(tIsInverted);

	tIsInverted = VUHDO_INDICATOR_CONFIG["CUSTOM"]["MANA_BAR"]["invertGrowth"];
	VUHDO_getHealthBar(aButton, 2):SetIsInverted(tIsInverted);
	VUHDO_getHealthBar(aButton, 13):SetIsInverted(tIsInverted);
	VUHDO_getHealthBar(aButton, 16):SetIsInverted(tIsInverted);

	VUHDO_getHealthBar(aButton, 7):SetIsInverted(VUHDO_INDICATOR_CONFIG["CUSTOM"]["THREAT_BAR"]["invertGrowth"]);
	VUHDO_getHealthBar(aButton, 17):SetIsInverted(VUHDO_INDICATOR_CONFIG["CUSTOM"]["SIDE_LEFT"]["invertGrowth"])
	VUHDO_getHealthBar(aButton, 18):SetIsInverted(VUHDO_INDICATOR_CONFIG["CUSTOM"]["SIDE_RIGHT"]["invertGrowth"]);

	-- Orient Health
	tOrientation = VUHDO_getStatusbarOrientationString("HEALTH_BAR");
	VUHDO_getHealthBar(aButton, 1):SetOrientation(tOrientation);
	VUHDO_getHealthBar(aButton, 5):SetOrientation(tOrientation);
	VUHDO_getHealthBar(aButton, 6):SetOrientation(tOrientation);
	VUHDO_getHealthBar(aButton, 14):SetOrientation(tOrientation);

	-- Orient Mana
	tOrientation = VUHDO_getStatusbarOrientationString("MANA_BAR");
	VUHDO_getHealthBar(aButton, 2):SetOrientation(tOrientation);
	VUHDO_getHealthBar(aButton, 13):SetOrientation(tOrientation);
	VUHDO_getHealthBar(aButton, 16):SetOrientation(tOrientation);

	-- Orient Threat
	VUHDO_getHealthBar(aButton, 7):SetOrientation(VUHDO_getStatusbarOrientationString("THREAT_BAR"));

	-- Orient side bar left
	VUHDO_getHealthBar(aButton, 17):SetOrientation(VUHDO_getStatusbarOrientationString("SIDE_LEFT"));

	-- Orient side bar right
	VUHDO_getHealthBar(aButton, 18):SetOrientation(VUHDO_getStatusbarOrientationString("SIDE_RIGHT"));

	VUHDO_initButtonStatics(aButton, aPanelNum);
	VUHDO_initBackgroundBar(VUHDO_getHealthBar(sButton, 3));
	VUHDO_initIncomingBar();
	VUHDO_initHealthBar(aButton);
	VUHDO_initAggroTexture();
	VUHDO_initManaBar(sButton, VUHDO_getHealthBar(sButton,  2), sBarScaling["barWidth"], false);
	VUHDO_initTargetBar();
	VUHDO_initTotBar();
	VUHDO_initThreatBar();
	VUHDO_initBarTexts(aButton, sHealthBar, sBarWidth);
	VUHDO_initOverhealText(sHealthBar, sBarScaling["barWidth"]);
	VUHDO_initHighlightBar(aButton);
	VUHDO_initSideBarLeft(aButton);
	VUHDO_initSideBarRight(aButton);

	VUHDO_initAggroBar();
	VUHDO_initHotBars();
	VUHDO_initAllHotIcons();
	VUHDO_initCustomDebuffs();
	VUHDO_initRaidIcon(sHealthBar, VUHDO_getBarRoleIcon(sButton, 50), sBarScaling["barWidth"]);
	VUHDO_initSwiftmendIndicator();
	VUHDO_initFlashBar();
	VUHDO_initReadyCheckIcon(aButton);

	if (VUHDO_CONFIG["IS_CLIQUE_COMPAT_MODE"]) then
		ClickCastFrames = ClickCastFrames or {};
		ClickCastFrames[aButton] = true;
		ClickCastFrames[VUHDO_GLOBAL[aButton:GetName() .. "Tg"]] = true;
		ClickCastFrames[VUHDO_GLOBAL[aButton:GetName() .. "Tot"]] = true;
		for tIconNum = 40, 44 do
			ClickCastFrames[VUHDO_GLOBAL[format("%sBgBarIcBarHlBarIc%d", aButton:GetName(), tIconNum)]] = true;
		end
	end

end

local VUHDO_initHealButton = VUHDO_initHealButton;



--
local tHealButton,  tGroupPanel;
local tCnt;
local tNumButtons;
local function VUHDO_initAllHealButtons(aPanel, aPanelNum)
	tNumButtons = VUHDO_getNumButtonsPanel(aPanelNum);
	for tCnt  = 1, tNumButtons do
		tHealButton = VUHDO_getOrCreateHealButton(tCnt, aPanelNum);
		VUHDO_initButtonButtonFacade(tHealButton);
		VUHDO_initHealButton(tHealButton, aPanelNum);
	end

	for tCnt  = tNumButtons + 1, 51 do -- VUHDO_MAX_BUTTONS_PANEL
		tHealButton = VUHDO_getHealButton(tCnt, aPanelNum);
		if(tHealButton ~= nil) then
			tHealButton["raidid"] = nil;
			tHealButton:SetAttribute("unit", nil);
			tHealButton:ClearAllPoints();
			tHealButton:Hide();
		else
			break;
		end
	end

	for tCnt = 1, 15 do -- VUHDO_MAX_GROUPS_PER_PANEL
		tGroupPanel = VUHDO_getGroupOrderPanel(aPanelNum, tCnt);
		if (tGroupPanel ~= nil) then
			tGroupPanel:Hide();
		end
		tGroupPanel = VUHDO_getGroupSelectPanel(aPanelNum,  tCnt);
		if (tGroupPanel ~= nil) then
			tGroupPanel:Hide();
		end
	end

end



--
local tSetup;
local tPosition;
local tPanelColor;
local tLabel;
local tWidth, tHeight;
local tGrowth;
local tScale;
local tFactor;
local tX, tY;

VUHDO_PROHIBIT_REPOS = false;

local function VUHDO_initPanel(aPanel, aPanelNum)
	tSetup  = VUHDO_PANEL_SETUP[aPanelNum];
	tPosition = tSetup["POSITION"];
	tPanelColor = tSetup["PANEL_COLOR"];

	tScale  = tSetup["SCALING"]["scale"];
	tFactor = tScale / aPanel:GetScale();

	tGrowth = tPosition["growth"];

	aPanel:ClearAllPoints();
	aPanel:SetWidth(tPosition["width"]);
	aPanel:SetHeight(tPosition["height"]);
	aPanel:SetScale(tScale);
	aPanel:SetPoint(tPosition["orientation"],  "UIParent", tPosition["relativePoint"],  tPosition["x"],  tPosition["y"]);
	aPanel:EnableMouseWheel(1);
	aPanel:SetFrameStrata(tSetup["frameStrata"] or "MEDIUM");

	if (aPanel:IsShown()) then
		tX, tY = VUHDO_getAnchorCoords(aPanel, tGrowth, tFactor);
		aPanel:ClearAllPoints();
		if (VUHDO_PROHIBIT_REPOS) then
			aPanel:SetPoint(tGrowth,  "UIParent", "BOTTOMLEFT", tX, tY);
		else
			aPanel:SetPoint(tGrowth,  "UIParent", "BOTTOMLEFT", tX  * tFactor,  tY  * tFactor);
		end
	end

	VUHDO_PANEL_SETUP[aPanelNum]["POSITION"]["orientation"] = tGrowth;

	tWidth  = VUHDO_getHealPanelWidth(aPanelNum);
	tHeight = VUHDO_getHealPanelHeight(aPanelNum);

	if (tHeight < 20) then
		tHeight = 20;
	end

	aPanel:SetWidth(tWidth);
	aPanel:SetHeight(tHeight);

	VUHDO_savePanelCoords(aPanel);

	tLabel = VUHDO_getPanelNumLabel(aPanel);

	VUHDO_STD_BACKDROP = aPanel:GetBackdrop();
	VUHDO_STD_BACKDROP["edgeFile"] = tPanelColor["BORDER"]["file"];
	VUHDO_STD_BACKDROP["edgeSize"] = tPanelColor["BORDER"]["edgeSize"];
	VUHDO_STD_BACKDROP["insets"]["left"] = tPanelColor["BORDER"]["insets"];
	VUHDO_STD_BACKDROP["insets"]["right"] = tPanelColor["BORDER"]["insets"];
	VUHDO_STD_BACKDROP["insets"]["top"] = tPanelColor["BORDER"]["insets"];
	VUHDO_STD_BACKDROP["insets"]["bottom"] = tPanelColor["BORDER"]["insets"];

	aPanel:SetBackdrop(VUHDO_STD_BACKDROP);
	aPanel:SetBackdropBorderColor(
		tPanelColor["BORDER"]["R"],
		tPanelColor["BORDER"]["G"],
		tPanelColor["BORDER"]["B"],
		tPanelColor["BORDER"]["O"]
	);

	if (VUHDO_IS_PANEL_CONFIG) then
		tLabel:SetText("[PANEL "  .. aPanelNum .. "]");
		tLabel:GetParent():SetPoint("BOTTOM", aPanel:GetName(), "TOP", 0, 3);
		tLabel:GetParent():Show();

		if (DESIGN_MISC_PANEL_NUM ~= nil and DESIGN_MISC_PANEL_NUM == aPanelNum
			and VuhDoNewOptionsPanelPanel ~= nil and VuhDoNewOptionsPanelPanel:IsVisible()) then
			VUHDO_DESIGN_BACKDROP = VUHDO_deepCopyTable(VUHDO_STD_BACKDROP);
			tLabel:SetTextColor(0, 1, 0, 1);
			UIFrameFlash(tLabel, 0.6, 0.6, 10000, true, 0.7, 0);

			aPanel:SetBackdrop(VUHDO_DESIGN_BACKDROP);
			aPanel:SetBackdropBorderColor(1, 1, 1, 1);
		else
			aPanel:SetBackdrop(VUHDO_STD_BACKDROP);
			tLabel:SetTextColor(0.4,  0.4, 0.4, 1);
			UIFrameFlashStop(tLabel);
			aPanel:SetBackdropBorderColor(
				tPanelColor["BORDER"]["R"],
				tPanelColor["BORDER"]["G"],
				tPanelColor["BORDER"]["B"],
				tPanelColor["BORDER"]["O"]
			);
		end

		if (DESIGN_MISC_PANEL_NUM ~= nil) then
			VuhDoNewOptionsTabbedFramePanelNumLabelLabel:SetText(VUHDO_I18N_PANEL .. " #" .. DESIGN_MISC_PANEL_NUM);
			VuhDoNewOptionsTabbedFramePanelNumLabelLabel:Show();
		else
			VuhDoNewOptionsTabbedFramePanelNumLabelLabel:Hide();
		end

		if (not VUHDO_CONFIG_SHOW_RAID) then
			VUHDO_GLOBAL[aPanel:GetName() .. "NewTxu"]:Show();
			VUHDO_GLOBAL[aPanel:GetName() .. "ClrTxu"]:Show();
		else
			VUHDO_GLOBAL[aPanel:GetName() .. "NewTxu"]:Hide();
			VUHDO_GLOBAL[aPanel:GetName() .. "ClrTxu"]:Hide();
		end
	else
		VUHDO_GLOBAL[aPanel:GetName() .. "NewTxu"]:Hide();
		VUHDO_GLOBAL[aPanel:GetName() .. "ClrTxu"]:Hide();
		tLabel:GetParent():Hide();
		if (VuhDoNewOptionsTabbedFrame ~= nil) then
			VuhDoNewOptionsTabbedFramePanelNumLabelLabel:Hide();
		end
	end

	aPanel:SetBackdropColor(
		tPanelColor["BACK"]["R"],
		tPanelColor["BACK"]["G"],
		tPanelColor["BACK"]["B"],
		tPanelColor["BACK"]["O"]
	);

	if (VUHDO_CONFIG["LOCK_CLICKS_THROUGH"]) then
		aPanel:EnableMouse(false);
	else
		aPanel:EnableMouse(true);
	end

	aPanel:StopMovingOrSizing();
	aPanel["isMoving"] = false;
end



--
local tPanel;
function VUHDO_redrawPanel(aPanelNum)
	tPanel = VUHDO_getActionPanel(aPanelNum);

	if (VUHDO_isPanelPopulated(aPanelNum)) then
		VUHDO_initLocalVars(aPanelNum);
		VUHDO_initAllHealButtons(tPanel, aPanelNum);

		if (VUHDO_isConfigPanelShowing()) then
			VUHDO_positionAllGroupConfigPanels(aPanelNum);
		else
			VUHDO_positionAllHealButtons(tPanel, aPanelNum);
		end

		VUHDO_positionTableHeaders(tPanel,  aPanelNum);
		VUHDO_initPanel(tPanel, aPanelNum);
		if (VUHDO_isPanelVisible(aPanelNum)) then
			VUHDO_fixFrameLevels(tPanel, 2, tPanel:GetChildren());
			tPanel:Show();
		else
			tPanel:Hide();
		end
	else
		tPanel:Hide();
	end

end
local VUHDO_redrawPanel = VUHDO_redrawPanel;



--
local tCnt, tGcdCol;
function VUHDO_redrawAllPanels()
	VUHDO_resetMacroCaches();
	resetSizeCalcCaches();
	twipe(VUHDO_UNIT_BUTTONS);
	if (VUHDO_LibButtonFacade ~= nil) then
		VUHDO_LibButtonFacade:Group("VuhDo", VUHDO_I18N_HOTS):Skin(VUHDO_PANEL_SETUP["HOTS"]["BUTTON_FACADE"]);
	end

	tBackdrop = nil;
	tBackdropCluster = nil;
	for tCnt  = 1, 10 do -- VUHDO_MAX_PANELS
		VUHDO_redrawPanel(tCnt);
	end

	VUHDO_setupAllButtonsUnitWatch(VUHDO_CONFIG["HIDE_EMPTY_BUTTONS"] and not VUHDO_IS_PANEL_CONFIG and not VUHDO_isConfigDemoUsers());
	VUHDO_updateAllRaidBars();

	-- GCD bar
	tGcdCol = VUHDO_PANEL_SETUP["BAR_COLORS"]["GCD_BAR"];
	VuhDoGcdStatusBar:SetVuhDoColor(tGcdCol);
	VuhDoGcdStatusBar:SetStatusBarTexture("Interface\\AddOns\\VuhDo\\Images\\white_square_16_16");
	VuhDoGcdStatusBar:SetValue(0);
	VuhDoGcdStatusBar:SetFrameStrata("TOOLTIP");
	VuhDoGcdStatusBar:Hide();

	-- Direction arrow
	VuhDoDirectionFrameArrow:SetVertexColor(1, 0.4, 0.4);
	VuhDoDirectionFrameText:SetFont(VUHDO_getFont(VUHDO_PANEL_SETUP["HOTS"]["TIMER_TEXT"]["FONT"]), 6, "OUTLINE");
	VuhDoDirectionFrameText:SetPoint("TOP", "VuhDoDirectionFrameArrow", "CENTER", 5,  -2);
	VuhDoDirectionFrameText:SetText("");
	VuhDoDirectionFrame:SetFrameStrata("TOOLTIP");

	VUHDO_initAllEventBouquets();
end
local VUHDO_redrawAllPanels = VUHDO_redrawAllPanels;



--
function VUHDO_reloadUI()
	if (InCombatLockdown()) then
		return;
	end
	VUHDO_IS_RELOADING = true;

	VUHDO_initAllBurstCaches(); -- Wichtig für INTERNAL_TOGGLES=>Clusters
	VUHDO_reloadRaidMembers();
	VUHDO_resetNameTextCache();
	VUHDO_redrawAllPanels();
	VUHDO_updateAllCustomDebuffs(true);
	VUHDO_rebuildTargets();
	VUHDO_updatePanelVisibility();
	VUHDO_IS_RELOADING = false;
	VUHDO_reloadBuffPanel();
	VUHDO_initDebuffs(); -- Talente scheinen recht spät zur Verfügung zu stehen...
end



--
function VUHDO_lnfReloadUI()
	if (InCombatLockdown()) then
		return;
	end
	VUHDO_IS_RELOADING = true;
	VUHDO_initAllBurstCaches();
	VUHDO_refreshRaidMembers();
	VUHDO_updatePanelVisibility();
	VUHDO_redrawAllPanels();
	VUHDO_buildGenericHealthBarBouquet();
	VUHDO_buildGenericTargetHealthBouquet();
	VUHDO_bouqetsChanged();
	--VUHDO_aoeUpdateTalents();
	VUHDO_initAllBurstCaches();
	VUHDO_IS_RELOADING = false;
end

