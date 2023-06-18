VUHDO_PANEL_MODELS = {};
VUHDO_PANEL_DYN_MODELS = {};


local tinsert = tinsert;
local tremove = tremove;
local twipe = table.wipe;
local ceil = ceil;
local pairs = pairs;
local _;
local sEmpty = {};

local sConfiguredModels = {};
local sRemoveUnitFromRaidGroupsCache = {};



--
local VUHDO_PANEL_SETUP;
local VUHDO_GROUPS;
local VUHDO_RAID;
local VUHDO_ID_MEMBER_TYPES;

local VUHDO_getGroupMembers;
function VUHDO_modelToolsInitLocalOverrides()
	VUHDO_PANEL_SETUP = _G["VUHDO_PANEL_SETUP"];
	VUHDO_GROUPS = _G["VUHDO_GROUPS"];
	VUHDO_RAID = _G["VUHDO_RAID"];
	VUHDO_ID_MEMBER_TYPES = _G["VUHDO_ID_MEMBER_TYPES"];
	VUHDO_getGroupMembers = _G["VUHDO_getGroupMembers"];

	twipe(sRemoveUnitFromRaidGroupsCache);
end



--
function VUHDO_clearUndefinedModelEntries()
	for tIndex, tModelArray in pairs(VUHDO_PANEL_MODELS) do
		local tNewArray = { };

		for _, tModel in ipairs(tModelArray) do
			if tModel ~= VUHDO_ID_UNDEFINED then tinsert(tNewArray, tModel); end
		end
		VUHDO_PANEL_MODELS[tIndex] = tNewArray;
	end

	for tKey, tModelArray in pairs(VUHDO_PANEL_MODELS) do
		if #(tModelArray or sEmpty) == 0 then VUHDO_PANEL_MODELS[tKey] = nil; end
	end
end



--
function VUHDO_initPanelModels()
	twipe(sConfiguredModels);

	for tCnt = 1, 10 do -- VUHDO_MAX_PANELS
		VUHDO_PANEL_MODELS[tCnt] = VUHDO_PANEL_SETUP[tCnt]["MODEL"]["groups"];

		for _, tModel in pairs(VUHDO_PANEL_MODELS[tCnt] or sEmpty) do
			sConfiguredModels[tModel] = true;
		end
	end

end



--
local tIsShowModel;
local tIsOmitEmpty;
local tMaxRows, tNumModels, tRepeatModels;
function VUHDO_initDynamicPanelModels()
	if VUHDO_isConfigPanelShowing() then
		VUHDO_PANEL_DYN_MODELS = VUHDO_deepCopyTable(VUHDO_PANEL_MODELS);
		return;
	end

	twipe(VUHDO_PANEL_DYN_MODELS);

	for tPanelNum, tModelArray in pairs(VUHDO_PANEL_MODELS) do
		tIsOmitEmpty = VUHDO_PANEL_SETUP[tPanelNum]["SCALING"]["ommitEmptyWhenStructured"];
		VUHDO_PANEL_DYN_MODELS[tPanelNum] = {};

		tMaxRows = VUHDO_PANEL_SETUP[tPanelNum]["SCALING"]["arrangeHorizontal"]
			and VUHDO_PANEL_SETUP[tPanelNum]["SCALING"]["maxColumnsWhenStructured"]
			or VUHDO_PANEL_SETUP[tPanelNum]["SCALING"]["maxRowsWhenLoose"];

		for _, tModelId in pairs(tModelArray) do
			tNumModels = #VUHDO_getGroupMembers(tModelId);
			if not tIsOmitEmpty or tNumModels > 0 then

				tRepeatModels = ceil(tNumModels / tMaxRows);
				if tRepeatModels == 0 then tRepeatModels = 1;	end

				for tCnt = 1, tRepeatModels do
					tinsert(VUHDO_PANEL_DYN_MODELS[tPanelNum], tModelId);
				end
			end
		end

	end
end



-- Returns the type of a given model id
function VUHDO_getModelType(aModelId)
	return VUHDO_ID_MEMBER_TYPES[aModelId] or 3; -- VUHDO_ID_TYPE_SPECIAL
end
local VUHDO_getModelType = VUHDO_getModelType;



--
function VUHDO_isModelConfigured(aModelId)
	return sConfiguredModels[aModelId];
end



--
local tGroup;
function VUHDO_isUnitInModelIterative(aUnit, aModelId)
	tGroup = VUHDO_GROUPS[aModelId] or sEmpty;
	for _, tUnit in pairs(tGroup) do
		if aUnit == tUnit then return true; end
	end

	return false;
end
local VUHDO_isUnitInModelIterative = VUHDO_isUnitInModelIterative;



--
local tModelType;
function VUHDO_isUnitInModel(aUnit, aModelId)

	tModelType = VUHDO_getModelType(aModelId);

	if 2 == tModelType then -- VUHDO_ID_TYPE_GROUP
		return aModelId == VUHDO_RAID[aUnit]["group"];
	elseif 1 == tModelType then -- VUHDO_ID_TYPE_CLASS
		return aModelId == VUHDO_RAID[aUnit]["classId"];
	else -- VUHDO_ID_TYPE_SPECIAL
		return VUHDO_isUnitInModelIterative(aUnit, aModelId);
	end
end
local VUHDO_isUnitInModel = VUHDO_isUnitInModel;



--
function VUHDO_isModelInPanel(aPanelNum, aModelId)
	for _, tModelId in pairs(VUHDO_PANEL_DYN_MODELS[aPanelNum] or sEmpty) do
		if tModelId == aModelId then return true; end
	end

	return false;
end



--
function VUHDO_resetRemoveFromRaidGroupsCache()
	twipe(sRemoveUnitFromRaidGroupsCache);
end



--
local function VUHDO_isRemoveUnitFromRaidGroups(aUnit)
	if not sRemoveUnitFromRaidGroupsCache[aUnit] then

		if (VUHDO_CONFIG["OMIT_MAIN_TANKS"] and VUHDO_isUnitInModelIterative(aUnit, 41))       -- VUHDO_ID_MAINTANKS
		 or (VUHDO_CONFIG["OMIT_PLAYER_TARGETS"] and VUHDO_isUnitInModelIterative(aUnit, 42))       -- VUHDO_ID_PRIVATE_TANKS
		 or (VUHDO_CONFIG["OMIT_MAIN_ASSIST"] and VUHDO_isUnitInModelIterative(aUnit, 43)) then -- VUHDO_ID_MAIN_ASSISTS
			sRemoveUnitFromRaidGroupsCache[aUnit] = 1;
		else
			sRemoveUnitFromRaidGroupsCache[aUnit] = 0;
		end
	end

	return sRemoveUnitFromRaidGroupsCache[aUnit] == 1;
end



--
local tModelType;
function VUHDO_isUnitInPanel(aPanelNum, aUnit)

	for _, tModelId in pairs(VUHDO_PANEL_MODELS[aPanelNum]) do
		tModelType = VUHDO_getModelType(tModelId);
		if 2 == tModelType or 1 == tModelType then -- VUHDO_ID_TYPE_GROUP -- VUHDO_ID_TYPE_CLASS
			if VUHDO_isUnitInModel(aUnit, tModelId) and not VUHDO_isRemoveUnitFromRaidGroups(aUnit) then
				return true;
			end
		elseif VUHDO_isUnitInModelIterative(aUnit, tModelId) then
			return true;
		end
	end

	return false;
end
