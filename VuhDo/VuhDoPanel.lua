VUHDO_PANEL_UNITS = { {}, {}, {}, {}, {}, {}, {}, {}, {}, {} };
local VUHDO_PANEL_UNITS = VUHDO_PANEL_UNITS;

VUHDO_UNIT_BUTTONS = {};
local VUHDO_UNIT_BUTTONS = VUHDO_UNIT_BUTTONS;

local tinsert = tinsert;
local ipairs = ipairs;
local twipe = table.wipe;
local tsort = table.sort;
local _;



-- BURST CACHE ---------------------------------------------------

local VUHDO_PANEL_SETUP;
local VUHDO_HEADER_TEXTS;
local VUHDO_GROUPS;
local VUHDO_RAID;

local VUHDO_getHeaderTextId;
local VUHDO_getClassColorByModelId;
local VUHDO_getHeaderBar;
local VUHDO_getModelType;
local VUHDO_isUnitInModel;

local sEmpty = { };


--
function VUHDO_panelInitBurst()
	VUHDO_PANEL_SETUP = VUHDO_GLOBAL["VUHDO_PANEL_SETUP"];
	VUHDO_HEADER_TEXTS = VUHDO_GLOBAL["VUHDO_HEADER_TEXTS"];
	VUHDO_GROUPS = VUHDO_GLOBAL["VUHDO_GROUPS"];
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];

	VUHDO_getHeaderTextId = VUHDO_GLOBAL["VUHDO_getHeaderTextId"];
	VUHDO_getClassColorByModelId = VUHDO_GLOBAL["VUHDO_getClassColorByModelId"];
	VUHDO_getHeaderBar = VUHDO_GLOBAL["VUHDO_getHeaderBar"];
	VUHDO_getModelType = VUHDO_GLOBAL["VUHDO_getModelType"];
	VUHDO_isUnitInModel = VUHDO_GLOBAL["VUHDO_isUnitInModel"];
end
-- BURST CACHE ---------------------------------------------------



--
local tIdAll = { VUHDO_ID_ALL };
function VUHDO_getDynamicModelArray(aPanelNum)
	if (0 == VUHDO_PANEL_SETUP[aPanelNum]["MODEL"]["ordering"]) then -- VUHDO_ORDERING_STRICT
		return VUHDO_PANEL_DYN_MODELS[aPanelNum] or sEmpty;
	else
		return tIdAll;
	end
end
local VUHDO_getDynamicModelArray = VUHDO_getDynamicModelArray;



--
function VUHDO_getHeaderText(aModelId)
	return 10 == aModelId -- VUHDO_ID_GROUP_OWN
		and VUHDO_HEADER_TEXTS[aModelId] .. " (" .. VUHDO_PLAYER_GROUP .. ")"
		or VUHDO_HEADER_TEXTS[aModelId];
end
local VUHDO_getHeaderText = VUHDO_getHeaderText;



--
local tHeaderText;
local tColor;
function VUHDO_customizeHeader(aHeader, aPanelNum, aModelId)
	tHeaderText = VUHDO_getHeaderTextId(aHeader);
	tHeaderText:SetText(VUHDO_getHeaderText(aModelId));

	if (VUHDO_PANEL_SETUP[aPanelNum]["PANEL_COLOR"]["classColorsHeader"]
		and 1 == VUHDO_getModelType(aModelId)) then -- VUHDO_ID_TYPE_CLASS
		tColor = VUHDO_getClassColorByModelId(aModelId);
	else
		tColor = VUHDO_PANEL_SETUP[aPanelNum]["PANEL_COLOR"]["HEADER"];
	end
	tHeaderText:SetTextColor(tColor["TR"], tColor["TG"], tColor["TB"], tColor["TO"]);

	if (VUHDO_PANEL_SETUP[aPanelNum]["PANEL_COLOR"]["classColorsBackHeader"]
		and 1 == VUHDO_getModelType(aModelId)) then -- VUHDO_ID_TYPE_CLASS
		tColor = VUHDO_getClassColorByModelId(aModelId);
	else
		tColor = VUHDO_PANEL_SETUP[aPanelNum]["PANEL_COLOR"]["HEADER"];
	end
	VUHDO_getHeaderBar(aHeader):SetVuhDoColor(tColor);
end



--
local tSubTable = { };
local tSubCount;
local function VUHDO_getSubTable(aTable, anIndex, aCount)
	twipe(tSubTable);

	for tSubCount = anIndex, anIndex + aCount - 1 do
		if (aTable[tSubCount] ~= nil) then
			tSubTable[#tSubTable + 1] = aTable[tSubCount];
		else
			break;
		end
	end

	return tSubTable;
end



--
local tOccurrence;
local tDynModel;
local tMaxRows;
local tModelNo;
local function VUHDO_cutSubGroup(anIdentifier, aPanelNum, aModelIndex)
	tDynModel = VUHDO_getDynamicModelArray(aPanelNum);
	tOccurrence = 0;
	for tModelNo = 1, aModelIndex do
		if (tDynModel[tModelNo] == anIdentifier) then
			tOccurrence = tOccurrence + 1;
		end
	end

	tMaxRows = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["arrangeHorizontal"]
		and VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["maxColumnsWhenStructured"]
		or VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["maxRowsWhenLoose"];

	return VUHDO_getSubTable(VUHDO_GROUPS[anIdentifier] or sEmpty, (tOccurrence - 1) * tMaxRows + 1, tMaxRows);
end



--
function VUHDO_getGroupMembers(anIdentifier, aPanelNum, aModelIndex)
	return 999 ~= anIdentifier
		and	(aModelIndex == nil
			and VUHDO_GROUPS[anIdentifier]
			or VUHDO_cutSubGroup(anIdentifier, aPanelNum, aModelIndex)
		)
		or VUHDO_PANEL_UNITS[aPanelNum]
		or sEmpty;
end
local VUHDO_getGroupMembers = VUHDO_getGroupMembers;



--
local tIndex, tModelId;
local function VUHDO_getPanelUnitFirstModel(aPanelNum, aUnit)
	for tIndex, tModelId in ipairs(VUHDO_PANEL_MODELS[aPanelNum]) do
		if (VUHDO_isUnitInModel(aUnit, tModelId)) then
			return tIndex;
		end
	end

	return 9999;
end



--
local sPanelNum;
local sIsPlayerFirst;
local tInfo1, tInfo2;
local tRole1, tRole2;



--
local VUHDO_RAID_SORTERS = {
	[VUHDO_SORT_RAID_UNITID]
		= function(aUnitId, anotherUnitId)
				if (sIsPlayerFirst and aUnitId == "player") then
					return true;
				elseif (sIsPlayerFirst and anotherUnitId == "player") then
					return false;
				else
					if (VUHDO_PANEL_SETUP[sPanelNum]["MODEL"]["isReverse"]) then
						aUnitId, anotherUnitId = anotherUnitId, aUnitId;
					end
					tInfo1, tInfo2 = VUHDO_RAID[aUnitId] or sEmpty, VUHDO_RAID[anotherUnitId] or sEmpty;
					return (tInfo1["number"] or 0) < (tInfo2["number"] or 0); -- comparing strings doesn't work
				end
			end,

	[VUHDO_SORT_RAID_NAME]
		= function(aUnitId, anotherUnitId)
				if (sIsPlayerFirst and aUnitId == "player") then
					return true;
				elseif (sIsPlayerFirst and anotherUnitId == "player") then
					return false;
				else
					if (VUHDO_PANEL_SETUP[sPanelNum]["MODEL"]["isReverse"]) then
						aUnitId, anotherUnitId = anotherUnitId, aUnitId;
					end
					tInfo1, tInfo2 = VUHDO_RAID[aUnitId] or sEmpty, VUHDO_RAID[anotherUnitId] or sEmpty;
					return (tInfo1["name"] or "") < (tInfo2["name"] or "");
				end
			end,

	[VUHDO_SORT_RAID_CLASS]
		= function(aUnitId, anotherUnitId)
				if (sIsPlayerFirst and aUnitId == "player") then
					return true;
				elseif (sIsPlayerFirst and anotherUnitId == "player") then
					return false;
				elseif (VUHDO_RAID[aUnitId]["class"] ~= nil and VUHDO_RAID[anotherUnitId]["class"] ~= nil) then
					if (VUHDO_PANEL_SETUP[sPanelNum]["MODEL"]["isReverse"]) then
						aUnitId, anotherUnitId = anotherUnitId, aUnitId;
					end
					tInfo1, tInfo2 = VUHDO_RAID[aUnitId], VUHDO_RAID[anotherUnitId];
					return tInfo1["class"] .. (tInfo1["name"] or "") > tInfo2["class"] .. (tInfo2["name"] or "");
				else
					if (VUHDO_PANEL_SETUP[sPanelNum]["MODEL"]["isReverse"]) then
						aUnitId, anotherUnitId = anotherUnitId, aUnitId;
					end
					tInfo1, tInfo2 = VUHDO_RAID[aUnitId] or sEmpty, VUHDO_RAID[anotherUnitId] or sEmpty;
					return (tInfo1["name"] or "") < (tInfo2["name"] or "");
				end
			end,

	[VUHDO_SORT_RAID_MAX_HP]
		= function(aUnitId, anotherUnitId)
				if (sIsPlayerFirst and aUnitId == "player") then
					return true;
				elseif (sIsPlayerFirst and anotherUnitId == "player") then
					return false;
				elseif (VUHDO_RAID[aUnitId]["sortMaxHp"] ~= nil and VUHDO_RAID[anotherUnitId]["sortMaxHp"] ~= nil) then
					if (VUHDO_PANEL_SETUP[sPanelNum]["MODEL"]["isReverse"]) then
						aUnitId, anotherUnitId = anotherUnitId, aUnitId;
					end
					tInfo1, tInfo2 = VUHDO_RAID[aUnitId], VUHDO_RAID[anotherUnitId];
					return tInfo1["sortMaxHp"] > tInfo2["sortMaxHp"];
				else
					if (VUHDO_PANEL_SETUP[sPanelNum]["MODEL"]["isReverse"]) then
						aUnitId, anotherUnitId = anotherUnitId, aUnitId;
					end
					tInfo1, tInfo2 = VUHDO_RAID[aUnitId] or sEmpty, VUHDO_RAID[anotherUnitId] or sEmpty;
					return (tInfo1["name"] or "") < (tInfo2["name"] or "");
				end
			end,

	[VUHDO_SORT_RAID_MODELS]
		= function(aUnitId, anotherUnitId)
				if (sIsPlayerFirst and aUnitId == "player") then
					return true;
				elseif (sIsPlayerFirst and anotherUnitId == "player") then
					return false;
				else
					if (VUHDO_PANEL_SETUP[sPanelNum]["MODEL"]["isReverse"]) then
						aUnitId, anotherUnitId = anotherUnitId, aUnitId;
					end
					tFirstIdx = VUHDO_getPanelUnitFirstModel(sPanelNum, aUnitId);
					tSecondIdx = VUHDO_getPanelUnitFirstModel(sPanelNum, anotherUnitId);
					if (tFirstIdx ~= tSecondIdx) then
						return tFirstIdx < tSecondIdx;
					else
						tInfo1, tInfo2 = VUHDO_RAID[aUnitId] or sEmpty, VUHDO_RAID[anotherUnitId] or sEmpty;
						return (tInfo1["name"] or "") < (tInfo2["name"] or "");
					end
				end
			end,

	[VUHDO_SORT_TA_DD_HL]
		= function(aUnitId, anotherUnitId)
				if (sIsPlayerFirst and aUnitId == "player") then
					return true;
				elseif (sIsPlayerFirst and anotherUnitId == "player") then
					return false;
				else
					if (VUHDO_PANEL_SETUP[sPanelNum]["MODEL"]["isReverse"]) then
						aUnitId, anotherUnitId = anotherUnitId, aUnitId;
					end

					tInfo1, tInfo2 = VUHDO_RAID[aUnitId] or sEmpty, VUHDO_RAID[anotherUnitId] or sEmpty;
					tRole1, tRole2 = tInfo1["role"], tInfo2["role"];

					if (tRole1 == VUHDO_ID_MELEE_TANK and tRole2 ~= VUHDO_ID_MELEE_TANK) then
						return true;
					elseif (tRole2 == VUHDO_ID_MELEE_TANK and tRole1 ~= VUHDO_ID_MELEE_TANK) then
						return false;
					elseif ((tRole1 == VUHDO_ID_MELEE_DAMAGE or tRole1 == VUHDO_ID_RANGED_DAMAGE)
						and tRole2 == VUHDO_ID_RANGED_HEAL) then
						return true;
					elseif ((tRole2 == VUHDO_ID_MELEE_DAMAGE or tRole2 == VUHDO_ID_RANGED_DAMAGE)
						and tRole1 == VUHDO_ID_RANGED_HEAL) then
						return false;
					else
						return (tInfo1["name"] or "") < (tInfo2["name"] or "");
					end
				end
			end,

	[VUHDO_SORT_TA_HL_DD]
		= function(aUnitId, anotherUnitId)
				if (sIsPlayerFirst and aUnitId == "player") then
					return true;
				elseif (sIsPlayerFirst and anotherUnitId == "player") then
					return false;
				else
					if (VUHDO_PANEL_SETUP[sPanelNum]["MODEL"]["isReverse"]) then
						aUnitId, anotherUnitId = anotherUnitId, aUnitId;
					end

					tInfo1, tInfo2 = VUHDO_RAID[aUnitId] or sEmpty, VUHDO_RAID[anotherUnitId] or sEmpty;
					tRole1, tRole2 = tInfo1["role"], tInfo2["role"];

					if (tRole1 == VUHDO_ID_MELEE_TANK and tRole2 ~= VUHDO_ID_MELEE_TANK) then
						return true;
					elseif (tRole2 == VUHDO_ID_MELEE_TANK and tRole1 ~= VUHDO_ID_MELEE_TANK) then
						return false;
					elseif (tRole1 == VUHDO_ID_RANGED_HEAL
						and (tRole2 == VUHDO_ID_MELEE_DAMAGE or tRole2 == VUHDO_ID_RANGED_DAMAGE)) then
						return true;
					elseif (tRole2 == VUHDO_ID_RANGED_HEAL
						and (tRole1 == VUHDO_ID_MELEE_DAMAGE or tRole1 == VUHDO_ID_RANGED_DAMAGE)) then
						return false;
					else
						return (tInfo1["name"] or "") < (tInfo2["name"] or "");
					end
				end
			end,

	[VUHDO_SORT_HL_TA_DD]
		= function(aUnitId, anotherUnitId)
				if (sIsPlayerFirst and aUnitId == "player") then
					return true;
				elseif (sIsPlayerFirst and anotherUnitId == "player") then
					return false;
				else
					if (VUHDO_PANEL_SETUP[sPanelNum]["MODEL"]["isReverse"]) then
						aUnitId, anotherUnitId = anotherUnitId, aUnitId;
					end

					tInfo1, tInfo2 = VUHDO_RAID[aUnitId] or sEmpty, VUHDO_RAID[anotherUnitId] or sEmpty;
					tRole1, tRole2 = tInfo1["role"], tInfo2["role"];

					if (tRole1 == VUHDO_ID_RANGED_HEAL and tRole2 ~= VUHDO_ID_RANGED_HEAL) then
						return true;
					elseif (tRole2 == VUHDO_ID_RANGED_HEAL and tRole1 ~= VUHDO_ID_RANGED_HEAL) then
						return false;
					elseif (tRole1 == VUHDO_ID_MELEE_TANK
						and (tRole2 == VUHDO_ID_MELEE_DAMAGE or tRole2 == VUHDO_ID_RANGED_DAMAGE)) then
						return true;
					elseif (tRole2 == VUHDO_ID_MELEE_TANK
						and (tRole1 == VUHDO_ID_MELEE_DAMAGE or tRole1 == VUHDO_ID_RANGED_DAMAGE)) then
						return false;
					else
						return (tInfo1["name"] or "") < (tInfo2["name"] or "");
					end
				end
			end,
};



--
local tSorted = { };
local tMembers;
local tUnit;
local tNoExists;
local tWasTarget, tWasFocus;
local tCnt;
function VUHDO_getGroupMembersSorted(anIdentifier, aSortCriterion, aPanelNum, aModelIndex)
	tMembers = VUHDO_getGroupMembers(anIdentifier, aPanelNum, aModelIndex);
	sIsPlayerFirst = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"]["isPlayerOnTop"];

	if (41 ~= anIdentifier) then -- VUHDO_ID_MAINTANKS
		twipe(tSorted);
		tNoExists = false;
		tWasTarget, tWasFocus = false, false;
		for _, tUnit in ipairs(tMembers) do
			if (tUnit == "target") then
				tWasTarget = true;
			elseif (tUnit == "focus") then
				tWasFocus = true;
			else
				tSorted[#tSorted + 1] = tUnit;
				if (VUHDO_RAID[tUnit] == nil) then
					tNoExists = true;
				end
			end
		end
		if (70 == anIdentifier or tNoExists) then -- VUHDO_ID_VEHICLES
			tsort(tSorted,
				function(aUnitId, anotherUnitId)
					if (sIsPlayerFirst and aUnitId == "player") then
						return true;
					elseif (sIsPlayerFirst and anotherUnitId == "player") then
						return false;
					else
						return aUnitId < anotherUnitId;
					end
				end
			);
		else
			sPanelNum = aPanelNum;
			tsort(tSorted, VUHDO_RAID_SORTERS[aSortCriterion]);
		end

		if (tWasFocus) then
			tinsert(tSorted, 1, "focus");
		end
		if (tWasTarget) then
			tinsert(tSorted, 1, "target");
		end

	else -- for main tanks keep the order of CTRA/ORA
		twipe(tSorted); -- has to be copied!!! conflicts in size calculator otherwise!
		for tCnt = 1, #tMembers do
			tSorted[tCnt] = tMembers[tCnt];
		end
	end

	return tSorted;
end



--
local tUnit;
function VUHDO_addUnitButton(aHealButton)
	tUnit = aHealButton:GetAttribute("unit");
	if (VUHDO_UNIT_BUTTONS[tUnit] == nil) then
		VUHDO_UNIT_BUTTONS[tUnit] = { };
	end
	tinsert(VUHDO_UNIT_BUTTONS[tUnit], aHealButton);
end
