-- BURST CACHE ---------------------------------------------------
local VUHDO_CONFIG;
local VUHDO_PANEL_SETUP;

local VUHDO_splitString;
local VUHDO_isTableHeadersShowing;
local VUHDO_isTableFootersShowing;
local VUHDO_isLooseOrderingShowing;
local VUHDO_isConfigPanelShowing;
local VUHDO_isTableHeaderOrFooter;

local ceil = ceil;
local floor = floor;
local twipe = table.wipe;
local strfind = strfind;
local ipairs = ipairs;

function VUHDO_sizeCalculatorInitBurstVer()
	VUHDO_CONFIG = VUHDO_GLOBAL["VUHDO_CONFIG"];
	VUHDO_PANEL_SETUP = VUHDO_GLOBAL["VUHDO_PANEL_SETUP"];

	VUHDO_splitString = VUHDO_GLOBAL["VUHDO_splitString"];
	VUHDO_isTableHeadersShowing = VUHDO_GLOBAL["VUHDO_isTableHeadersShowing"];
	VUHDO_isTableFootersShowing = VUHDO_GLOBAL["VUHDO_isTableFootersShowing"];
	VUHDO_isLooseOrderingShowing = VUHDO_GLOBAL["VUHDO_isLooseOrderingShowing"];
	VUHDO_isConfigPanelShowing = VUHDO_GLOBAL["VUHDO_isConfigPanelShowing"];
	VUHDO_isTableHeaderOrFooter = VUHDO_GLOBAL["VUHDO_isTableHeaderOrFooter"];
end

-- BURST CACHE ---------------------------------------------------



local sTopHeightCache = { };
local sBottomHeightCache = { };
local sHeaderTotalHeightCache = { };
local sHeaderFooterTotalHeightCache = { };
function VUHDO_resetSizeCalcCachesVer()
	twipe(sTopHeightCache);
	twipe(sBottomHeightCache);
	twipe(sHeaderTotalHeightCache);
	twipe(sHeaderFooterTotalHeightCache);
end



-- Returns the total height of optional threat bars
local function VUHDO_getAdditionalTopHeight(aPanelNum)
	if (sTopHeightCache[aPanelNum] == nil) then
		local tTopSpace;

		if (VUHDO_INDICATOR_CONFIG["BOUQUETS"]["THREAT_BAR"] ~= "") then
			tTopSpace = VUHDO_INDICATOR_CONFIG["CUSTOM"]["THREAT_BAR"]["HEIGHT"];
		else
			tTopSpace = 0;
		end

		local tNamePos = VUHDO_splitString(VUHDO_PANEL_SETUP[aPanelNum]["ID_TEXT"]["position"], "+");
		if (strfind(tNamePos[1], "BOTTOM", 1, true) and strfind(tNamePos[2], "TOP", 1, true)) then
			local tNameHeight = VUHDO_PANEL_SETUP[aPanelNum]["ID_TEXT"]["_spacing"];
			if (tNameHeight ~= nil and tNameHeight > tTopSpace) then
				tTopSpace = tNameHeight;
			end
		end
		sTopHeightCache[aPanelNum] = tTopSpace;
	end

	return sTopHeightCache[aPanelNum];
end



--
local function VUHDO_getAdditionalBottomHeight(aPanelNum)
	if (sBottomHeightCache[aPanelNum] == nil) then
		-- HoT icons
		local tHotConfig = VUHDO_PANEL_SETUP["HOTS"];
		local tBottomSpace;

		if  (tHotConfig["radioValue"] == 7 or tHotConfig["radioValue"] == 8) then
			tBottomSpace = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["barHeight"] * VUHDO_PANEL_SETUP[aPanelNum]["HOTS"]["size"] * 0.01;
		else
			tBottomSpace = 0;
		end

		local tNamePos = VUHDO_splitString(VUHDO_PANEL_SETUP[aPanelNum]["ID_TEXT"]["position"], "+");
		if (strfind(tNamePos[1], "TOP", 1, true) and strfind(tNamePos[2], "BOTTOM", 1, true)) then
			local tNameHeight = VUHDO_PANEL_SETUP[aPanelNum]["ID_TEXT"]["_spacing"];
			if (tNameHeight ~= nil and tNameHeight > tBottomSpace) then
				tBottomSpace = tNameHeight;
			end
		end

		sBottomHeightCache[aPanelNum] = tBottomSpace;
	end

	return sBottomHeightCache[aPanelNum];
end



-- Returns total header height
local function VUHDO_getHeaderTotalHeight(aPanelNum)
	if (sHeaderTotalHeightCache[aPanelNum] == nil) then
		if (VUHDO_isTableHeadersShowing(aPanelNum)) then
				local tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
				sHeaderTotalHeightCache[aPanelNum] = tBarScaling["headerHeight"] + tBarScaling["headerSpacing"]
					+ VUHDO_getAdditionalTopHeight(aPanelNum);
		else
			sHeaderTotalHeightCache[aPanelNum] = VUHDO_getAdditionalTopHeight(aPanelNum);
		end
	end

	return sHeaderTotalHeightCache[aPanelNum];
end



-- Returns total header or height
local function VUHDO_getHeaderFooterTotalHeight(aPanelNum)
	if (sHeaderFooterTotalHeightCache[aPanelNum] == nil) then
		if (VUHDO_isTableHeaderOrFooter(aPanelNum)) then
				local tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
				sHeaderFooterTotalHeightCache[aPanelNum] = tBarScaling["headerHeight"] + tBarScaling["headerSpacing"]
					+ VUHDO_getAdditionalTopHeight(aPanelNum);
		else
			sHeaderFooterTotalHeightCache[aPanelNum] = VUHDO_getAdditionalTopHeight(aPanelNum);
		end
	end

	return sHeaderFooterTotalHeightCache[aPanelNum];
end



-- Returns total header height
function VUHDO_getHeaderWidthVer(aPanelNum)
	return VUHDO_isTableHeaderOrFooter(aPanelNum)
		and VUHDO_getHealButtonWidth(aPanelNum) or 0;
end



-- Returns total header height
function VUHDO_getHeaderHeightVer(aPanelNum)
	return VUHDO_isTableHeaderOrFooter(aPanelNum)
		and VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["headerHeight"] or 0;
end



--
local function VUHDO_getHealButtonHeight(aPanelNum)
	return VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["barHeight"]
		+ VUHDO_getAdditionalTopHeight(aPanelNum)
		+ VUHDO_getAdditionalBottomHeight(aPanelNum);
end



-- Returns the Y-offset in Pixels a heal button has within a model (from the top of the models position)
local tRowStep;
local tMaxRows;
local tColOfs;
local tColFrag;
local tBarScaling;
local function VUHDO_getRowOffset(aRowNo, aPanelNum)
	tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
	tRowStep = VUHDO_getHealButtonHeight(aPanelNum) + tBarScaling["rowSpacing"];

	if (VUHDO_isLooseOrderingShowing(aPanelNum)) then
		tMaxRows = tBarScaling["maxRowsWhenLoose"];
		tColOfs = aRowNo - 1;
		tColFrag = floor((tColOfs) / tMaxRows);
		aRowNo = (tColOfs - tColFrag * tMaxRows) + 1;
	end

	return VUHDO_getHeaderTotalHeight(aPanelNum) + (aRowNo - 1) * tRowStep;
end



-- Returns the column number a heal button/model will be in (#1 .. #x)
local tMaxCols;
local tOffset, tRemain, tFrag;
local function VUHDO_determineGridColumn(aPlaceNum, aPanelNum, aRowNum)

	if (VUHDO_isLooseOrderingShowing(aPanelNum)) then
		tOffset = aRowNum - 1;
		tFrag = floor(tOffset / VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["maxRowsWhenLoose"]);
		return tFrag + 1;
	else
		tMaxCols = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["maxColumnsWhenStructured"];
		tOffset = aPlaceNum - 1;
		tFrag = floor(tOffset / tMaxCols);
		tRemain = tOffset - tFrag * tMaxCols;
		return tRemain + 1;
	end
end



-- Returns the row number a model will be in
local function VUHDO_determineGridRow(aPlaceNum, aPanelNum)
	return floor((aPlaceNum - 1) / VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["maxColumnsWhenStructured"]) + 1;
end



-- returns the number of buttons that the biggest model has in a given row
local tModelId;
local tRow;
local tGroup;
local tAktBars, tMaxBars;
local tPlaceNo;
local tModelIdx;
local tPanelModel;
local function VUHDO_determineGridRowMaxBars(aRowNum, aPanelNum)
	tPanelModel = VUHDO_PANEL_DYN_MODELS[aPanelNum];
	tPlaceNo = 1;

	tMaxBars = 0;
	for tModelIdx, tModelId in ipairs(tPanelModel) do
		tRow = VUHDO_determineGridRow(tPlaceNo, aPanelNum);

		if (tRow == aRowNum) then
			tGroup = VUHDO_getGroupMembers(tModelId, aPanelNum, tModelIdx);
			tAktBars = #tGroup;
			if (tAktBars > tMaxBars) then
				tMaxBars = tAktBars;
			end
		end

		tPlaceNo = tPlaceNo + 1;
	end

	return tMaxBars;
end



--
local function VUHDO_determineGridRowPlaceBars(aPlaceNum, aRowNum, aPanelNum)
	return #VUHDO_getGroupMembers(VUHDO_PANEL_DYN_MODELS[aPanelNum][aPlaceNum], aPanelNum, aPlaceNum);
end



-- Returns the highest row number for the given panel
local function VUHDO_determineLastRow(aPanelNum)
	return ceil(#VUHDO_PANEL_DYN_MODELS[aPanelNum] / VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["maxColumnsWhenStructured"]);
end



-- Returns the height of the given row in Pixels
local tHeight;
local tMaxBarsInRow;
local tBarScaling;
local tConfigPanel;
local function VUHDO_getRowHeight(aRowNum, aPanelNum)
	tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
	tHeight = 0;
	if (VUHDO_isTableHeadersShowing(aPanelNum) or aRowNum > 1) then
		tHeight = tHeight + VUHDO_getHeaderFooterTotalHeight(aPanelNum);
	end

	if (VUHDO_isConfigPanelShowing()) then
		tConfigPanel = VUHDO_getGroupOrderPanel(aPanelNum, 1);
		return tHeight + tConfigPanel:GetHeight() * tConfigPanel:GetScale();
	else
		tMaxBarsInRow = VUHDO_determineGridRowMaxBars(aRowNum, aPanelNum);
		tHeight = tHeight + VUHDO_getHealButtonHeight(aPanelNum) * tMaxBarsInRow;

		if (tMaxBarsInRow > 0) then
			tHeight = tHeight + tBarScaling["rowSpacing"] * (tMaxBarsInRow - 1);
		end
	end

	if (aRowNum < VUHDO_determineLastRow(aPanelNum)) then
		tHeight = tHeight + tBarScaling["headerSpacing"];
	end

	return tHeight;
end



-- Returns the pixel Y-offset of a given model slot
local tRowY;
local tRowNum;
local tCnt;
local function VUHDO_getRowPos(aPlaceNum, aPanelNum)
	tRowY = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["borderGapY"];

	-- When ordering loose all rows start from the very top
	if (VUHDO_isLooseOrderingShowing(aPanelNum)) then
		return tRowY;
	end

	tRowNum = VUHDO_determineGridRow(aPlaceNum, aPanelNum);
	for tCnt = 1, tRowNum - 1 do
		tRowY = tRowY + VUHDO_getRowHeight(tCnt, aPanelNum);
	end

	return tRowY;
end



-- Returns the pixel X-offset of a given model slot
local tColX;
local tBarScaling;
local tGridColNo;
local tColSpacing;

local function VUHDO_getColumnPos(aPlaceNum, aPanelNum, aRowNo)
	tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
	tGridColNo = VUHDO_determineGridColumn(aPlaceNum, aPanelNum, aRowNo);
	tColSpacing = VUHDO_getHealButtonWidth(aPanelNum) + tBarScaling["columnSpacing"];

	tColX = tBarScaling["borderGapX"];
	tColX = tColX + (tGridColNo - 1) * tColSpacing;

	return tColX;
end



--
local tX, tY, tOffset;
local tRowNum, tBarScaling;
function VUHDO_getHeaderPosVer(aHeaderPlace, aPanelNum)
	tX = VUHDO_getColumnPos(aHeaderPlace, aPanelNum);
	tY = VUHDO_getRowPos(aHeaderPlace, aPanelNum);
	if (VUHDO_isTableFootersShowing(aPanelNum)) then
		tRowNum = VUHDO_determineGridRow(aHeaderPlace, aPanelNum);
		tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
		tOffset = tBarScaling["headerSpacing"] + VUHDO_getAdditionalBottomHeight(aPanelNum);
		tY = tY + VUHDO_getRowHeight(tRowNum, aPanelNum) + tOffset;
	end

	return tX, tY;
end



--
local tButtonX;
local tButtonY;
local tHots;
local tScaling;
local tGridRow;
local tNumBars;
local tCurrHeight;
local tRowHeight;
function VUHDO_getHealButtonPosVer(aPlaceNum, aRowNo, aPanelNum)
	tButtonX = VUHDO_getColumnPos(aPlaceNum, aPanelNum, aRowNo);
	tButtonY = VUHDO_getRowPos(aPlaceNum, aPanelNum) + VUHDO_getRowOffset(aRowNo, aPanelNum);

	if (not VUHDO_isConfigPanelShowing()) then
		tHots = VUHDO_PANEL_SETUP["HOTS"];
		if (tHots["radioValue"] == 1) then
			tHotslots = VUHDO_getNumHotSlots(aPanelNum);
			tButtonX = tButtonX + VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["barHeight"] * VUHDO_PANEL_SETUP[aPanelNum]["HOTS"]["size"] * 0.01 * tHotslots;
		end

		tScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
		if (tScaling["targetOrientation"] == 2) then
			if (tScaling["showTarget"]) then
				tButtonX = tButtonX + tScaling["targetWidth"] + tScaling["targetSpacing"];
			end
			if (tScaling["showTot"]) then
				tButtonX = tButtonX + tScaling["totWidth"] + tScaling["totSpacing"];
			end
		end

		if (tScaling["alignBottom"]) then
			tGridRow = VUHDO_determineGridRow(aPlaceNum, aPanelNum);
			tRowHeight = VUHDO_getRowHeight(tGridRow, aPanelNum);
			tNumBars = VUHDO_determineGridRowPlaceBars(aPlaceNum, tGridRow, aPanelNum);
			tCurrHeight = tNumBars * VUHDO_getHealButtonHeight(aPanelNum);
			tCurrHeight = tCurrHeight + (tNumBars - 1) * tScaling["rowSpacing"] + VUHDO_getHeaderTotalHeight(aPanelNum);
			tButtonY = tButtonY + (tRowHeight - tCurrHeight);

			if (tGridRow ~= VUHDO_determineLastRow(aPanelNum)) then
				tButtonY = tButtonY - tScaling["headerSpacing"];
			end
		end
	end
	return tButtonX, tButtonY;
end



--
local tBarScaling;
local tAnzCols;
local tAnzPlaces;
local tWidth;
function VUHDO_getHealPanelWidthVer(aPanelNum)
	tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];

	if (VUHDO_isLooseOrderingShowing(aPanelNum)) then
		tAnzPlaces = #VUHDO_PANEL_UNITS[aPanelNum];
		tAnzCols = floor((tAnzPlaces - 1) / tBarScaling["maxRowsWhenLoose"]) + 1;
	else
		tAnzPlaces = #VUHDO_PANEL_DYN_MODELS[aPanelNum];
		if (tAnzPlaces < tBarScaling["maxColumnsWhenStructured"]) then
			tAnzCols = tAnzPlaces;
		else
			tAnzCols = tBarScaling["maxColumnsWhenStructured"];
		end
	end

	if (tAnzCols < 1) then
		tAnzCols = 1;
	end

	tWidth = tBarScaling["borderGapX"] * 2;
	tWidth = tWidth + tAnzCols * VUHDO_getHealButtonWidth(aPanelNum);
	tWidth = tWidth + (tAnzCols - 1) * tBarScaling["columnSpacing"];

	return tWidth;
end



--
local tBarScaling
local tAnzPlaces;
local tRows;
local tHeight;
local tLastPlace;
local tLastHeaderY;
local tLastRowHeight;
local tHeight;
function VUHDO_getHealPanelHeightVer(aPanelNum)
	tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
	if (VUHDO_isLooseOrderingShowing(aPanelNum)) then
		tAnzPlaces = #VUHDO_PANEL_UNITS[aPanelNum];
		if (tAnzPlaces > tBarScaling["maxRowsWhenLoose"]) then
			tRows = tBarScaling["maxRowsWhenLoose"];
		else
			tRows = tAnzPlaces;
		end

		tHeight = VUHDO_getHeaderTotalHeight(aPanelNum);
		tHeight = tHeight + tBarScaling["borderGapY"] * 2;
		tHeight = tHeight + tRows * VUHDO_getHealButtonHeight(aPanelNum);
		tHeight = tHeight + (tRows - 1) * tBarScaling["rowSpacing"];
		return tHeight - VUHDO_getAdditionalTopHeight(aPanelNum);
	else
		tLastPlace = #VUHDO_PANEL_DYN_MODELS[aPanelNum];
		tLastHeaderY = VUHDO_getRowPos(tLastPlace, aPanelNum);
		tLastRowHeight =  VUHDO_getRowHeight(VUHDO_determineGridRow(tLastPlace, aPanelNum), aPanelNum);
		tHeight = tLastHeaderY + tLastRowHeight + tBarScaling["borderGapY"] - VUHDO_getAdditionalTopHeight(aPanelNum);
		if (tBarScaling["alignBottom"]) then
			tHeight = tHeight + VUHDO_getHeaderHeightVer(aPanelNum) + tBarScaling["headerSpacing"];
		end
		return tHeight;
	end
end
