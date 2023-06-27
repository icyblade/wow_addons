VUHDO_GLOBAL_ICONS = { };
VUHDO_GI_SCAN_IDX = 150001;


local GetSpellInfo = GetSpellInfo;
local pairs = pairs;


local VUHDO_GROUP_ORDER_BARS_LEFT = { };
local VUHDO_GROUP_ORDER_BARS_RIGHT = { };



--
function VUHDO_removeFromModel(aPanelNum, anOrderNum)
	tremove(VUHDO_PANEL_MODELS[aPanelNum], anOrderNum);
	VUHDO_initDynamicPanelModels();
end



--
function VUHDO_insertIntoModel(aPanelNum, anOrderNum, anIsLeft, aModelId)
	if (anIsLeft) then
		tinsert(VUHDO_PANEL_MODELS[aPanelNum], anOrderNum, aModelId)
	else
		tinsert(VUHDO_PANEL_MODELS[aPanelNum], anOrderNum + 1, aModelId)
	end
	VUHDO_initDynamicPanelModels();
end



--
local tCnt;
function VUHDO_rewritePanelModels()
	for tCnt = 1, VUHDO_MAX_PANELS do
		VUHDO_PANEL_SETUP[tCnt]["MODEL"].groups = VUHDO_PANEL_MODELS[tCnt];
	end
end



--
local tCount;
function VUHDO_tableCount(anArray)
	tCount = 0;
	for _, _ in pairs(anArray) do
		tCount = tCount + 1;
	end

	return tCount;
end



--
function VUHDO_getOrCreateGroupOrderPanel(aParentPanelNum, aPanelNum)
	local tName = "Vd" .. aParentPanelNum .. "GrpOrd" .. aPanelNum;
	if (VUHDO_GLOBAL[tName] == nil) then
		CreateFrame("Frame", tName, VUHDO_GLOBAL["Vd" .. aParentPanelNum], "VuhDoGrpOrdTemplate");
	end

	return VUHDO_GLOBAL[tName];
end



--
function VUHDO_getOrCreateGroupSelectPanel(aParentPanelNum, aPanelNum)
	local tName = "Vd" .. aParentPanelNum .. "GrpSel" .. aPanelNum;
	if (VUHDO_GLOBAL[tName] == nil) then
		CreateFrame("Frame", tName, VUHDO_GLOBAL["Vd" .. aParentPanelNum], "VuhDoGrpSelTemplate");
	end

	return VUHDO_GLOBAL[tName];
end



--
function VUHDO_getConfigOrderBarRight(aPanelNum, anOrderNum)
	local tIndex = aPanelNum * 100 + anOrderNum;
	if (VUHDO_GROUP_ORDER_BARS_RIGHT[tIndex] == nil) then
		local tPanel = VUHDO_getOrCreateGroupOrderPanel(aPanelNum, anOrderNum);
		VUHDO_GROUP_ORDER_BARS_RIGHT[tIndex] = VUHDO_GLOBAL[tPanel:GetName() .. "InsTxuR"];
	end

	return VUHDO_GROUP_ORDER_BARS_RIGHT[tIndex];
end



--
function VUHDO_getConfigOrderBarLeft(aPanelNum, anOrderNum)
	local tIndex = aPanelNum * 100 + anOrderNum;
	if (VUHDO_GROUP_ORDER_BARS_LEFT[tIndex] == nil) then
		local tPanel = VUHDO_getOrCreateGroupOrderPanel(aPanelNum, anOrderNum);
		VUHDO_GROUP_ORDER_BARS_LEFT[tIndex] = VUHDO_GLOBAL[tPanel:GetName() .. "InsTxuL"];
	end

	return VUHDO_GROUP_ORDER_BARS_LEFT[tIndex];
end



--
function VUHDO_forceBooleanValue(aRawValue)
	if (aRawValue == nil or aRawValue == 0 or aRawValue == false) then
		return false;
	else
		return true;
	end
end



--
local tSpellNameById;
function VUHDO_resolveSpellId(aSpellName)
	if (tonumber(aSpellName or "x") ~= nil) then
		tSpellNameById = GetSpellInfo(tonumber(aSpellName));
		if (tSpellNameById ~= nil) then
			return tSpellNameById;
		end
	end
	return aSpellName;
end



--
local tText, tTextById, tLabel;
function VUHDO_newOptionsSpellEditBoxCheckId(anEditBox)
	tLabel = VUHDO_GLOBAL[anEditBox:GetName() .. "Hint"];
	tText = anEditBox:GetText();
	tTextById = VUHDO_resolveSpellId(tText);

	if (tText ~= tTextById) then
		tTextById = strsub(tTextById, 1, 20);
		tLabel:SetText(tTextById);
		tLabel:SetTextColor(0.4, 0.4, 1, 1);
	else
		tLabel:SetText("");
	end
end



--
local VUHDO_USED_BUFFS = { };
function VUHDO_updateGlobalIconList()
	local tName, tItems, tItem, tValue;
	table.wipe(VUHDO_USED_BUFFS);

	-- Add custom debuffs
	for _, tName in pairs(VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED"]) do
		VUHDO_USED_BUFFS[tName] = true;
	end

	-- Add bouquet item buffs
	for _, tItems in pairs(VUHDO_BOUQUETS["STORED"]) do
		tItems = VUHDO_decompressIfCompressed(tItems);
		for _, tItem in pairs(tItems) do
			if (VUHDO_BOUQUET_BUFFS_SPECIAL[tItem["name"]] == nil) then
				VUHDO_USED_BUFFS[tItem["name"]] = true;
			end
		end
	end

	-- Add standard icons
	for _, tValues in pairs(VUHDO_CUSTOM_ICONS) do
		if (tValues[2] ~= nil) then
			VUHDO_USED_BUFFS[tValues[1]] = true;
			VUHDO_GLOBAL_ICONS[tValues[1]] = tValues[2];
		end
	end

	-- Add standard ignore debuffs
	for tName, _  in pairs(VUHDO_DEBUFF_BLACKLIST) do
		VUHDO_USED_BUFFS[tName] = true;
	end

	-- Remove obsolete
	for tName, _ in pairs(VUHDO_GLOBAL_ICONS) do
		if (not VUHDO_USED_BUFFS[tName]) then
			VUHDO_GLOBAL_ICONS[tName] = nil;
		end
	end

	-- Add new
	for tName, _ in pairs(VUHDO_USED_BUFFS) do
		if (VUHDO_GLOBAL_ICONS[tName] == nil) then
			if (tonumber(tName) ~= nil) then
				local _, _, tIcon = GetSpellInfo(tonumber(tName));
				VUHDO_GLOBAL_ICONS[tName] = tIcon;
			else
				VUHDO_GLOBAL_ICONS[tName] = "";
			end
		end
	end
end



--
local tValue, _;
local function VUHDO_tableContains(aTable, aValue)
	for _, tValue in pairs(aTable) do
		if tValue == aValue then
			return true;
		end
	end

	return false;
end



--
local tStep = 50;
local tCnt;
local tRef;
local tName, _, tIcon;
local function VUHDO_scanNextGlobalIcons()
	if (not VUHDO_tableContains(VUHDO_GLOBAL_ICONS, "")) then
		return;
	end
	tRef = VUHDO_GLOBAL_ICONS;
	for tCnt = VUHDO_GI_SCAN_IDX + tStep , VUHDO_GI_SCAN_IDX, -1 do
		tName, _, tIcon = GetSpellInfo(tCnt);
		if tRef[tName] == "" then
			tRef[tName] = tIcon;
		end
	end

	VUHDO_GI_SCAN_IDX = VUHDO_GI_SCAN_IDX - tStep;

	if (VUHDO_GI_SCAN_IDX < 1) then
		VUHDO_GI_SCAN_IDX = 150001;
	end
end



--
function VUHDO_optionsOnUpdate(self, aTimeDelta)
	VUHDO_scanNextGlobalIcons();
	VUHDO_updateRequestsInProgress();
end



--
function VUHDO_getGlobalIcon(aDeBuffName)
	if (aDeBuffName == nil) then
		return nil;
	end
	return GetSpellBookItemTexture(aDeBuffName) or VUHDO_GLOBAL_ICONS[aDeBuffName];
end