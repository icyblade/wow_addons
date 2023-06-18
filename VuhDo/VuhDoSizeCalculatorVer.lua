-- BURST CACHE ---------------------------------------------------
local VUHDO_CONFIG;
local VUHDO_PANEL_SETUP;

local VUHDO_isTableHeadersShowing;
local VUHDO_isTableFootersShowing;
local VUHDO_isLooseOrderingShowing;
local VUHDO_isConfigPanelShowing;
local VUHDO_isTableHeaderOrFooter;
local VUHDO_getNumHotSlots;

local ceil = ceil;
local floor = floor;
local twipe = table.wipe;
local strfind = strfind;
local ipairs = ipairs;

function VUHDO_sizeCalculatorInitLocalOverridesVer()
	VUHDO_CONFIG = _G["VUHDO_CONFIG"];
	VUHDO_PANEL_SETUP = _G["VUHDO_PANEL_SETUP"];

	VUHDO_isTableHeadersShowing = _G["VUHDO_isTableHeadersShowing"];
	VUHDO_isTableFootersShowing = _G["VUHDO_isTableFootersShowing"];
	VUHDO_isLooseOrderingShowing = _G["VUHDO_isLooseOrderingShowing"];
	VUHDO_isConfigPanelShowing = _G["VUHDO_isConfigPanelShowing"];
	VUHDO_isTableHeaderOrFooter = _G["VUHDO_isTableHeaderOrFooter"];
	VUHDO_getNumHotSlots = _G["VUHDO_getNumHotSlots"];

end

-- BURST CACHE ---------------------------------------------------



local sHeaderTotalHeightCache = { };
local sHeaderFooterTotalHeightCache = { };
function VUHDO_resetSizeCalcCachesVer()
	twipe(sHeaderTotalHeightCache);
	twipe(sHeaderFooterTotalHeightCache);
end



-- Returns total header height
local function VUHDO_getHeaderTotalHeight(aPanelNum)
	if not sHeaderTotalHeightCache[aPanelNum] then
		if VUHDO_isTableHeadersShowing(aPanelNum) then
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
	if not sHeaderFooterTotalHeightCache[aPanelNum] then
		if VUHDO_isTableHeaderOrFooter(aPanelNum) then
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

	if VUHDO_isLooseOrderingShowing(aPanelNum) then
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

	if VUHDO_isLooseOrderingShowing(aPanelNum) then
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
local tRow;
local tGroup;
local tAktBars, tMaxBars;
local tPlaceNo;
local tPanelModel;
local function VUHDO_determineGridRowMaxBars(aRowNum, aPanelNum)
	tPanelModel = VUHDO_PANEL_DYN_MODELS[aPanelNum];
	tPlaceNo = 1;

	tMaxBars = 0;
	for tModelIdx, tModelId in ipairs(tPanelModel) do
		tRow = VUHDO_determineGridRow(tPlaceNo, aPanelNum);

		if tRow == aRowNum then
			tGroup = VUHDO_getGroupMembers(tModelId, aPanelNum, tModelIdx);
			tAktBars = #tGroup;
			if tAktBars > tMaxBars then
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
	if VUHDO_isTableHeadersShowing(aPanelNum) or aRowNum > 1 then
		tHeight = tHeight + VUHDO_getHeaderFooterTotalHeight(aPanelNum);
	else
		tHeight = tHeight + VUHDO_getAdditionalTopHeight(aPanelNum);
	end

	if VUHDO_isConfigPanelShowing() then
		tConfigPanel = VUHDO_getGroupOrderPanel(aPanelNum, 1);
		return tHeight + tConfigPanel:GetHeight() * tConfigPanel:GetScale();
	else
		tMaxBarsInRow = VUHDO_determineGridRowMaxBars(aRowNum, aPanelNum);
		tHeight = tHeight + VUHDO_getHealButtonHeight(aPanelNum) * tMaxBarsInRow;

		if tMaxBarsInRow > 0 then
			tHeight = tHeight + tBarScaling["rowSpacing"] * (tMaxBarsInRow - 1);
		end
	end

	if aRowNum < VUHDO_determineLastRow(aPanelNum) then
		tHeight = tHeight + tBarScaling["headerSpacing"];
	end

	return tHeight;
end



-- Returns the pixel Y-offset of a given model slot
local tRowY;
local tRowNum;
local function VUHDO_getRowPos(aPlaceNum, aPanelNum)
	tRowY = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["borderGapY"];

	-- When ordering loose all rows start from the very top
	if VUHDO_isLooseOrderingShowing(aPanelNum) then
		return tRowY;
	end

	tRowNum = VUHDO_determineGridRow(aPlaceNum, aPanelNum);
	for tCnt = 1, tRowNum - 1 do
		tRowY = tRowY + VUHDO_getRowHeight(tCnt, aPanelNum);
	end

	return tRowY;
end



-- Returns the pixel X-offset of a given model slot
local tBarScaling;
local tGridColNo;
local tColSpacing;
local function VUHDO_getColumnPos(aPlaceNum, aPanelNum, aRowNo)
	tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
	tGridColNo = VUHDO_determineGridColumn(aPlaceNum, aPanelNum, aRowNo);

	tColSpacing = VUHDO_getHealButtonWidth(aPanelNum) + tBarScaling["columnSpacing"];
	return tBarScaling["borderGapX"] + (tGridColNo - 1) * tColSpacing;
end



--
local tX, tY, tOffset;
local tRowNum, tBarScaling;
function VUHDO_getHeaderPosVer(aHeaderPlace, aPanelNum)
	tX = VUHDO_getColumnPos(aHeaderPlace, aPanelNum);
	tY = VUHDO_getRowPos(aHeaderPlace, aPanelNum);
	if VUHDO_isTableFootersShowing(aPanelNum) then
		tRowNum = VUHDO_determineGridRow(aHeaderPlace, aPanelNum);
		tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
		tOffset = tBarScaling["headerSpacing"];
		tY = tY + VUHDO_getRowHeight(tRowNum, aPanelNum) + tOffset - VUHDO_getAdditionalTopHeight(aPanelNum);
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

	if not VUHDO_isConfigPanelShowing() then
		tHots = VUHDO_PANEL_SETUP["HOTS"];
		if tHots["radioValue"] == 1 then
			tHotslots = VUHDO_getNumHotSlots(aPanelNum);
			tButtonX = tButtonX + VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["barHeight"] * VUHDO_PANEL_SETUP[aPanelNum]["HOTS"]["size"] * 0.01 * tHotslots;
		end

		tScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
		if tScaling["targetOrientation"] == 2 then
			if tScaling["showTarget"] then
				tButtonX = tButtonX + tScaling["targetWidth"] + tScaling["targetSpacing"];
			end
			if tScaling["showTot"] then
				tButtonX = tButtonX + tScaling["totWidth"] + tScaling["totSpacing"];
			end
		end

		if tScaling["alignBottom"] then
			tGridRow = VUHDO_determineGridRow(aPlaceNum, aPanelNum);
			tRowHeight = VUHDO_getRowHeight(tGridRow, aPanelNum);
			tNumBars = VUHDO_determineGridRowPlaceBars(aPlaceNum, tGridRow, aPanelNum);
			tCurrHeight = tNumBars * VUHDO_getHealButtonHeight(aPanelNum);
			tCurrHeight = tCurrHeight + (tNumBars - 1) * tScaling["rowSpacing"] + VUHDO_getHeaderTotalHeight(aPanelNum);
			tButtonY = tButtonY + (tRowHeight - tCurrHeight);

			if tGridRow ~= VUHDO_determineLastRow(aPanelNum) then
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

	if VUHDO_isLooseOrderingShowing(aPanelNum) then
		tAnzPlaces = #VUHDO_PANEL_UNITS[aPanelNum];
		tAnzCols = floor((tAnzPlaces - 1) / tBarScaling["maxRowsWhenLoose"]) + 1;
	else
		tAnzPlaces = #VUHDO_PANEL_DYN_MODELS[aPanelNum];
		if tAnzPlaces < tBarScaling["maxColumnsWhenStructured"] then
			tAnzCols = tAnzPlaces;
		else
			tAnzCols = tBarScaling["maxColumnsWhenStructured"];
		end
	end

	if tAnzCols < 1 then tAnzCols = 1; end

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
	if VUHDO_isLooseOrderingShowing(aPanelNum) then
		tAnzPlaces = #VUHDO_PANEL_UNITS[aPanelNum];
		if tAnzPlaces > tBarScaling["maxRowsWhenLoose"] then
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
		if tBarScaling["alignBottom"] and VUHDO_isTableFootersShowing(aPanelNum) then
			tHeight = tHeight + VUHDO_getHeaderHeightVer(aPanelNum) + tBarScaling["headerSpacing"];
		end
		return tHeight;
	end
end
