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

function VUHDO_sizeCalculatorInitBurstHor()
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
function VUHDO_resetSizeCalcCachesHor()
	twipe(sTopHeightCache);
	twipe(sBottomHeightCache);
	twipe(sHeaderTotalHeightCache);
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
		local tHotCfg = VUHDO_PANEL_SETUP["HOTS"];
		local tBottomSpace;

		if  (tHotCfg["radioValue"] == 7 or tHotCfg["radioValue"] == 8) then
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



-- Returns total header width
local tBarScaling;
local function VUHDO_getHeaderTotalWidth(aPanelNum)
	if (VUHDO_isTableHeadersShowing(aPanelNum)) then
		tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
		return tBarScaling["headerHeight"] + tBarScaling["headerSpacing"];
	else
		return 0;
	end
end



-- Returns total footer height
local tBarScaling;
local function VUHDO_getHeaderFooterTotalWidth(aPanelNum)
	if (VUHDO_isTableHeaderOrFooter(aPanelNum)) then
		tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
		return tBarScaling["headerHeight"] + tBarScaling["headerSpacing"];
	else
		return 0;
	end
end



-- Returns total header height
function VUHDO_getHeaderWidthHor(aPanelNum)
	return VUHDO_isTableHeaderOrFooter(aPanelNum)
		and VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["headerHeight"] or 0;
end



--
local function VUHDO_getHealButtonHeight(aPanelNum)
	return VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["barHeight"]
		+ VUHDO_getAdditionalTopHeight(aPanelNum)
		+ VUHDO_getAdditionalBottomHeight(aPanelNum);
end



-- Returns total header height
function VUHDO_getHeaderHeightHor(aPanelNum)
	return VUHDO_isTableHeaderOrFooter(aPanelNum)
		and VUHDO_getHealButtonHeight(aPanelNum) or 0;
end



-- Returns the Y-offset in Pixels a heal button has within a model (from the top of the models position)
local tRowNo;
local tRowStep;
local tMaxRows;
local tColOfs;
local tColFrag;
local tBarScaling;
local function VUHDO_getColumnOffset(aRowNo, aPanelNum)
	tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
	tRowStep = VUHDO_getHealButtonWidth(aPanelNum) + tBarScaling["columnSpacing"];

	tRowNo = aRowNo;
	if (VUHDO_isLooseOrderingShowing(aPanelNum)) then
		tMaxRows = tBarScaling["maxColumnsWhenStructured"];
		tColOfs = tRowNo - 1;
		tColFrag = floor((tColOfs) / tMaxRows);
		tRowNo = (tColOfs - tColFrag * tMaxRows) + 1;
	end

	return VUHDO_getHeaderTotalWidth(aPanelNum) + (tRowNo - 1) * tRowStep;
end




-- Returns the row number a heal button/model will be in (#1 .. #x)
local tMaxCols;
local tOfs, tRemain, tFrag;
local function VUHDO_determineGridRow(aPlaceNum, aPanelNum, aRowNum)

	if (VUHDO_isLooseOrderingShowing(aPanelNum)) then
		tOfs = aRowNum - 1;
		tFrag = floor(tOfs / VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["maxColumnsWhenStructured"]);
		return tFrag + 1;
	else
		tMaxCols = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["maxRowsWhenLoose"];
		tOfs = aPlaceNum - 1;
		tFrag = floor(tOfs / tMaxCols);
		tRemain = tOfs - tFrag * tMaxCols;
		return tRemain + 1;
	end
end



-- Returns the column number a model will be in
local function VUHDO_determineGridColumn(aPlaceNum, aPanelNum)
	return floor((aPlaceNum - 1) / VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["maxRowsWhenLoose"]) + 1;
end



-- returns the number of buttons that the biggest model has in a given row
local tId;
local tRow;
local tGroup;
local tAktBars, tMaxBar;
local tPlaceNum;
local tModelIdx;
local tPanelModel;
local function VUHDO_determineGridColumnMaxBars(aRowNum, aPanelNum)
	tPanelModel = VUHDO_PANEL_DYN_MODELS[aPanelNum];
	tPlaceNum = 1;

	tMaxBar = 0;
	for tModelIdx, tId in ipairs(tPanelModel) do
		tRow = VUHDO_determineGridColumn(tPlaceNum, aPanelNum);

		if (tRow == aRowNum) then
			tGroup = VUHDO_getGroupMembers(tId, aPanelNum, tModelIdx);
			tAktBars = #tGroup;
			if (tAktBars > tMaxBar) then
				tMaxBar = tAktBars;
			end
		end

		tPlaceNum = tPlaceNum + 1;
	end

	return tMaxBar;
end



local function VUHDO_determineGridColumnPlaceBars(aPlaceNum, aRowNum, aPanelNum)
	return #VUHDO_getGroupMembers(VUHDO_PANEL_DYN_MODELS[aPanelNum][aPlaceNum], aPanelNum, aPlaceNum);
end



-- Returns the highest row number for the given panel
local function VUHDO_determineLastColumn(aPanelNum)
	return ceil(#VUHDO_PANEL_DYN_MODELS[aPanelNum] / VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["maxRowsWhenLoose"]);
end




-- Returns the width of the given row in Pixels
local tHeight;
local tMaxBarInRow;
local tBarScaling;
local tCfgPanel;
local function VUHDO_getColumnWidth(aRowNum, aPanelNum)
	tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
	tHeight = 0;
	if (VUHDO_isTableHeadersShowing(aPanelNum) or aRowNum > 1) then
		tHeight = tHeight + VUHDO_getHeaderFooterTotalWidth(aPanelNum);
	end

	if (VUHDO_isConfigPanelShowing()) then
		tCfgPanel = VUHDO_getGroupOrderPanel(aPanelNum, 1);
		return tHeight + tCfgPanel:GetWidth();
	else
		tMaxBarInRow = VUHDO_determineGridColumnMaxBars(aRowNum, aPanelNum);
		tHeight = tHeight + VUHDO_getHealButtonWidth(aPanelNum) * tMaxBarInRow;

		if (tMaxBarInRow > 0) then
			tHeight = tHeight + tBarScaling["columnSpacing"] * (tMaxBarInRow - 1);
		end
	end

	if (aRowNum < VUHDO_determineLastColumn(aPanelNum)) then
		tHeight = tHeight + tBarScaling["headerSpacing"];
	end

	return tHeight;
end




-- Returns the pixel X-offset of a given model slot
local tRowY;
local tRowNum;
local tCnt;
local function VUHDO_getColumnPos(aPlaceNum, aPanelNum)
	tRowY = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["borderGapX"];

	-- When ordering loose all rows start from the very top
	if (VUHDO_isLooseOrderingShowing(aPanelNum)) then
		return tRowY;
	end

	tRowNum = VUHDO_determineGridColumn(aPlaceNum, aPanelNum);
	for tCnt = 1, tRowNum - 1 do
		tRowY = tRowY + VUHDO_getColumnWidth(tCnt, aPanelNum);
	end

	return tRowY;
end



-- Returns the pixel Y-offset of a given model slot
local tColX;
local tBarScaling;
local tGridColNo;
local tColSpacing;
local function VUHDO_getRowPos(aPlaceNum, aPanelNum, aRowNo)
	tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
	tGridColNo = VUHDO_determineGridRow(aPlaceNum, aPanelNum, aRowNo);
	tColSpacing = VUHDO_getHealButtonHeight(aPanelNum) + tBarScaling["rowSpacing"];

	tColX = tBarScaling["borderGapY"];
	tColX = tColX + (tGridColNo - 1) * tColSpacing;

	return tColX;
end



--
local tX, tY, tOffset;
local tColumnNum, tBarScaling;
function VUHDO_getHeaderPosHor(aHeaderPlace, aPanelNum)
	tX = VUHDO_getColumnPos(aHeaderPlace, aPanelNum);
	tY = VUHDO_getRowPos(aHeaderPlace, aPanelNum);
	if (VUHDO_isTableFootersShowing(aPanelNum)) then
		tColumnNum = VUHDO_determineGridColumn(aHeaderPlace, aPanelNum);
		tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
		tOffset = tBarScaling["headerSpacing"];
		tX = tX + VUHDO_getColumnWidth(tColumnNum, aPanelNum) + tOffset;
	end

	return tX, tY;
end



--
local tButtonX;
local tButtonY;
local tHots;
local tScaling;
local tGridColumn;
local tNumBars;
local tCurrWidth;
local tColumnWidth;
function VUHDO_getHealButtonPosHor(aPlaceNum, aRowNo, aPanelNum)
	tButtonX = VUHDO_getColumnPos(aPlaceNum, aPanelNum) + VUHDO_getColumnOffset(aRowNo, aPanelNum);
	tButtonY = VUHDO_getRowPos(aPlaceNum, aPanelNum, aRowNo);

	if (VUHDO_INDICATOR_CONFIG["BOUQUETS"]["THREAT_BAR"] ~= "") then
		tButtonY = tButtonY + VUHDO_INDICATOR_CONFIG["CUSTOM"]["THREAT_BAR"]["HEIGHT"];
	end


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

	if (tScaling["alignBottom"] and not VUHDO_isConfigPanelShowing()) then
		tGridColumn = VUHDO_determineGridColumn(aPlaceNum, aPanelNum);
		tColumnWidth = VUHDO_getColumnWidth(tGridColumn, aPanelNum);
		tNumBars = VUHDO_determineGridColumnPlaceBars(aPlaceNum, tGridColumn, aPanelNum);
		tCurrWidth = tNumBars * VUHDO_getHealButtonWidth(aPanelNum) ;
		tCurrWidth = tCurrWidth + (tNumBars - 1) * tScaling["columnSpacing"] + VUHDO_getHeaderTotalWidth(aPanelNum);
		tButtonX = tButtonX + (tColumnWidth - tCurrWidth);

		if (tGridColumn ~= VUHDO_determineLastColumn(aPanelNum)) then
			tButtonX = tButtonX - tScaling["headerSpacing"];
		end

	end

	return tButtonX, tButtonY;
end



--
local tBarScaling;
local tAnzPlaces;
local tRows;
local tHeight;
local tLastPlace;
local tLastHeaderX;
local tLastRowWidth;
local tWidth;
function VUHDO_getHealPanelWidthHor(aPanelNum)
	tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
	if (VUHDO_isLooseOrderingShowing(aPanelNum)) then
		tAnzPlaces = #VUHDO_PANEL_UNITS[aPanelNum];
		if (tAnzPlaces > tBarScaling["maxColumnsWhenStructured"]) then
			tRows = tBarScaling["maxColumnsWhenStructured"];
		else
			tRows = tAnzPlaces;
		end

		tHeight = VUHDO_getHeaderTotalWidth(aPanelNum);
		tHeight = tHeight + tBarScaling["borderGapX"] * 2;
		tHeight = tHeight + tRows * VUHDO_getHealButtonWidth(aPanelNum);
		tHeight = tHeight + (tRows - 1) * tBarScaling["columnSpacing"];
		return tHeight;
	else
		tLastPlace = #VUHDO_PANEL_DYN_MODELS[aPanelNum];
		tLastHeaderX = VUHDO_getColumnPos(tLastPlace, aPanelNum);
		tLastRowWidth =  VUHDO_getColumnWidth(VUHDO_determineGridColumn(tLastPlace, aPanelNum), aPanelNum);
		tWidth = tLastHeaderX + tLastRowWidth + tBarScaling["borderGapX"];

		if (tBarScaling["alignBottom"]) then
			tWidth = tWidth + VUHDO_getHeaderWidthHor(aPanelNum) + tBarScaling["headerSpacing"];
		end

		return tWidth;
	end
end



--
local tBarScaling;
local tAnzCols;
local tAnzPlaces;
local tWidth;
function VUHDO_getHealPanelHeightHor(aPanelNum)
	tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];

	if (VUHDO_isLooseOrderingShowing(aPanelNum)) then
		tAnzPlaces = #VUHDO_PANEL_UNITS[aPanelNum];
		tAnzCols = floor((tAnzPlaces - 1) / tBarScaling["maxColumnsWhenStructured"]) + 1;
	else
		tAnzPlaces = #VUHDO_PANEL_DYN_MODELS[aPanelNum];
		if (tAnzPlaces < tBarScaling["maxRowsWhenLoose"]) then
			tAnzCols = tAnzPlaces;
		else
			tAnzCols = tBarScaling["maxRowsWhenLoose"];
		end
	end

	if (tAnzCols < 1) then
		tAnzCols = 1;
	end

	tWidth = tBarScaling["borderGapY"] * 2;
	tWidth = tWidth + tAnzCols * VUHDO_getHealButtonHeight(aPanelNum);
	tWidth = tWidth + (tAnzCols - 1) * tBarScaling["rowSpacing"];

	return tWidth;
end

