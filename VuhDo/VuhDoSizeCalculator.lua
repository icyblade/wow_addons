-- BURST CACHE ---------------------------------------------------
local VUHDO_PANEL_SETUP;
local VUHDO_getHeaderWidthHor;
local VUHDO_getHeaderWidthVer;
local VUHDO_getHeaderHeightHor;
local VUHDO_getHeaderHeightVer;
local VUHDO_getHeaderPosHor;
local VUHDO_getHeaderPosVer;
local VUHDO_getHealButtonPosHor;
local VUHDO_getHealButtonPosVer;
local VUHDO_resetSizeCalcCachesHor;
local VUHDO_resetSizeCalcCachesVer;

local twipe = table.wipe;

function VUHDO_sizeCalculatorInitBurst()
	VUHDO_PANEL_SETUP = VUHDO_GLOBAL["VUHDO_PANEL_SETUP"];
	VUHDO_sizeCalculatorInitBurstHor();
	VUHDO_sizeCalculatorInitBurstVer();

	VUHDO_getHeaderWidthHor = VUHDO_GLOBAL["VUHDO_getHeaderWidthHor"];
	VUHDO_getHeaderWidthVer = VUHDO_GLOBAL["VUHDO_getHeaderWidthVer"];
	VUHDO_getHeaderHeightHor = VUHDO_GLOBAL["VUHDO_getHeaderHeightHor"];
	VUHDO_getHeaderHeightVer = VUHDO_GLOBAL["VUHDO_getHeaderHeightVer"];
	VUHDO_getHeaderPosHor = VUHDO_GLOBAL["VUHDO_getHeaderPosHor"];
	VUHDO_getHeaderPosVer = VUHDO_GLOBAL["VUHDO_getHeaderPosVer"];
	VUHDO_getHealButtonPosHor = VUHDO_GLOBAL["VUHDO_getHealButtonPosHor"];
	VUHDO_getHealButtonPosVer = VUHDO_GLOBAL["VUHDO_getHealButtonPosVer"];
	VUHDO_resetSizeCalcCachesHor = VUHDO_GLOBAL["VUHDO_resetSizeCalcCachesHor"];
	VUHDO_resetSizeCalcCachesVer = VUHDO_GLOBAL["VUHDO_resetSizeCalcCachesVer"];
end

-- BURST CACHE ---------------------------------------------------


local sHealButtonWidthCache = { };

function resetSizeCalcCaches()
	twipe(sHealButtonWidthCache);
	VUHDO_resetSizeCalcCachesHor();
	VUHDO_resetSizeCalcCachesVer();
end



--
local tBarScaling;
local tTargetWidth;
local function VUHDO_getTargetBarWidth(aPanelNum)
	tBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];

	tTargetWidth = 0;
	if (tBarScaling["showTarget"]) then
		tTargetWidth = tTargetWidth + tBarScaling["targetSpacing"] + tBarScaling["targetWidth"];
	end

	if (tBarScaling["showTot"]) then
		tTargetWidth = tTargetWidth + tBarScaling["totSpacing"] + tBarScaling["totWidth"];
	end

	return tTargetWidth;
end



--
local tCnt;
function VUHDO_getNumHotSlots(aPanelNum)
	tHotSlots = 0;
	if (VUHDO_PANEL_SETUP["HOTS"]["SLOTS"][10] ~= nil) then
		return 7;
	end

	if (VUHDO_PANEL_SETUP["HOTS"]["SLOTS"][9] ~= nil) then
		return 6;
	end

	for tCnt = 5, 1, -1 do
		if (VUHDO_PANEL_SETUP["HOTS"]["SLOTS"][tCnt] ~= nil) then
			return tCnt;
		end
	end

	return 0;
end
local VUHDO_getNumHotSlots = VUHDO_getNumHotSlots;



--
local tHotCfg;
local tHotSlots;
local function VUHDO_getHotIconWidth(aPanelNum)
	tHotCfg = VUHDO_PANEL_SETUP["HOTS"];

	if (tHotCfg["radioValue"] == 1 or tHotCfg["radioValue"] == 4) then
		tHotSlots = VUHDO_getNumHotSlots(aPanelNum);
		return VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["barHeight"] * VUHDO_PANEL_SETUP[aPanelNum]["HOTS"]["size"] * tHotSlots * 0.01;
	end

	return 0;
end



--
function VUHDO_getHealButtonWidth(aPanelNum)
	if (VUHDO_IS_PANEL_CONFIG and not VUHDO_CONFIG_SHOW_RAID) then
		return VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["barWidth"];
	elseif (sHealButtonWidthCache[aPanelNum] == nil) then
		sHealButtonWidthCache[aPanelNum] = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["barWidth"] + VUHDO_getTargetBarWidth(aPanelNum) + VUHDO_getHotIconWidth(aPanelNum);
	end

	return sHealButtonWidthCache[aPanelNum];
end



--
local function VUHDO_isPanelHorizontal(aPanelNum)
	return VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["arrangeHorizontal"] and (not VUHDO_IS_PANEL_CONFIG or VUHDO_CONFIG_SHOW_RAID);
end



-- Returns total header width
function VUHDO_getHeaderWidth(aPanelNum)
	return VUHDO_isPanelHorizontal(aPanelNum)
		and VUHDO_getHeaderWidthHor(aPanelNum) or VUHDO_getHeaderWidthVer(aPanelNum);
end



-- Returns total header height
function VUHDO_getHeaderHeight(aPanelNum)
	return VUHDO_isPanelHorizontal(aPanelNum)
		and VUHDO_getHeaderHeightHor(aPanelNum) or VUHDO_getHeaderHeightVer(aPanelNum);
end



--
function VUHDO_getHeaderPos(aHeaderPlace, aPanelNum)
	if (VUHDO_isPanelHorizontal(aPanelNum)) then
		return VUHDO_getHeaderPosHor(aHeaderPlace, aPanelNum);
	else
		return VUHDO_getHeaderPosVer(aHeaderPlace, aPanelNum);
	end
end



--
function VUHDO_getHealButtonPos(aPlaceNum, aRowNo, aPanelNum)
	-- Achtung: Positionen nicht cachen, da z.T. von dynamischen Models abh„ngig
	if (VUHDO_isPanelHorizontal(aPanelNum)) then
		return VUHDO_getHealButtonPosHor(aPlaceNum, aRowNo, aPanelNum);
	else
		return VUHDO_getHealButtonPosVer(aPlaceNum, aRowNo, aPanelNum);
	end
end



--
function VUHDO_getHealPanelWidth(aPanelNum)
	return VUHDO_isPanelHorizontal(aPanelNum)
		and VUHDO_getHealPanelWidthHor(aPanelNum) or VUHDO_getHealPanelWidthVer(aPanelNum);
end



--
function VUHDO_getHealPanelHeight(aPanelNum)
	return VUHDO_isPanelHorizontal(aPanelNum)
		and VUHDO_getHealPanelHeightHor(aPanelNum) or VUHDO_getHealPanelHeightVer(aPanelNum);
end

