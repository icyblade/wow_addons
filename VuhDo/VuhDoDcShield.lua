
-----------------------------------------------------------------------------------
local twipe = table.wipe;
local UnitInRaid = UnitInRaid;
local CreateMacro = CreateMacro;
local EditMacro = EditMacro;
local strsub = strsub;
local GetMacroBody = GetMacroBody;
local GetMacroIndexByName = GetMacroIndexByName;
local tonumber = tonumber;
local pairs = pairs;
local GetNumMacros = GetNumMacros;
local _ = _;
local format = format;

local VUHDO_RAID;
function VUHDO_dcShieldInitBurst()
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];
end
-----------------------------------------------------------------------------------



local VUHDO_MACRO_NAME_GROUPS = "VuhDoDCShieldData";
local VUHDO_MACRO_NAME_NAMES = "VuhDoDCShieldNames";
--local VUHDO_MAX_MACRO_UNITS = 41; -- 40 raid + player (*2 = 82 for pets)
local VUHDO_EMPTY_SNIPPET = "[x]";
local VUHDO_IS_DC_TEMP_DISABLE = false;


local VUHDO_CLASS_TO_MACRO = {
	[VUHDO_ID_WARRIORS] = "W",
	[VUHDO_ID_ROGUES] = "R",
	[VUHDO_ID_HUNTERS] = "H",
	[VUHDO_ID_PALADINS] = "P",
	[VUHDO_ID_MAGES] = "M",
	[VUHDO_ID_WARLOCKS] = "L",
	[VUHDO_ID_SHAMANS] = "S",
	[VUHDO_ID_DRUIDS] = "D",
	[VUHDO_ID_PRIESTS] = "I",
	[VUHDO_ID_DEATH_KNIGHT] = "E"
};


local VUHDO_MACRO_TO_CLASS = {
	["W"] = VUHDO_ID_WARRIORS,
	["R"] = VUHDO_ID_ROGUES,
	["H"] = VUHDO_ID_HUNTERS,
	["P"] = VUHDO_ID_PALADINS,
	["M"] = VUHDO_ID_MAGES,
	["L"] = VUHDO_ID_WARLOCKS,
	["S"] = VUHDO_ID_SHAMANS,
	["D"] = VUHDO_ID_DRUIDS,
	["I"] = VUHDO_ID_PRIESTS,
	["E"] = VUHDO_ID_DEATH_KNIGHT
};


local VUHDO_ROLE_TO_MACRO = {
	[VUHDO_ID_MELEE_TANK] = "T",
	[VUHDO_ID_MELEE_DAMAGE] = "M",
	[VUHDO_ID_RANGED_DAMAGE] = "R",
	[VUHDO_ID_RANGED_HEAL] = "H"
};


local VUHDO_MACRO_TO_ROLE = {
	["T"] = VUHDO_ID_MELEE_TANK,
	["M"] = VUHDO_ID_MELEE_DAMAGE,
	["R"] = VUHDO_ID_RANGED_DAMAGE,
	["H"] = VUHDO_ID_RANGED_HEAL
};


local VUHDO_GROUP_SNIPPETS = { };
local VUHDO_NAME_SNIPPETS = { };



--
local tMacroIndex;
local tUnit, tInfo;
local function VUHDO_buildSnippetArray()
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		tMacroIndex = ("player" == tUnit or "pet" == tUnit) and 41 or tInfo["number"];

		if ((tMacroIndex or 0) > 0) then -- nicht: Target, Focus
			if (tInfo["isPet"]) then
				tMacroIndex = tMacroIndex + 41; -- VUHDO_MAX_MACRO_UNITS
			end

			VUHDO_GROUP_SNIPPETS[tMacroIndex] = format("%01d%s%s",
				tInfo["group"] % 10,
				VUHDO_CLASS_TO_MACRO[tInfo["classId"]] or "_",
				VUHDO_ROLE_TO_MACRO[tInfo["role"]] or "_"
			);

			VUHDO_NAME_SNIPPETS[tMacroIndex] = format("%-3.3s", tInfo["name"] or "");
		end
	end
end



--
local tMacroString, tMacroNames;
local tCnt;
local tIndexGroups, tIndexNames;
local tNumMacros;
function VUHDO_mirrorToMacro()
	if (VUHDO_IS_DC_TEMP_DISABLE) then
		return;
	end

	tIndexGroups = GetMacroIndexByName(VUHDO_MACRO_NAME_GROUPS);
	tIndexNames = GetMacroIndexByName(VUHDO_MACRO_NAME_NAMES);

	if (VUHDO_CONFIG["IS_DC_SHIELD_DISABLED"]) then
		if ((tIndexGroups or 0) ~= 0) then
			DeleteMacro(tIndexGroups);
		end

		if ((tIndexNames or 0) ~= 0) then
			DeleteMacro(tIndexNames);
		end

		return;
	end
	tMacroString = UnitInRaid("player") and "R" or "P";
	tMacroNames = "N"; -- Filler

	VUHDO_buildSnippetArray();
	for tCnt = 1, 82 do -- VUHDO_MAX_MACRO_UNITS * 2
		tMacroString = tMacroString .. (VUHDO_GROUP_SNIPPETS[tCnt] or VUHDO_EMPTY_SNIPPET);
		tMacroNames = tMacroNames .. (VUHDO_NAME_SNIPPETS[tCnt] or VUHDO_EMPTY_SNIPPET)
	end
	twipe(VUHDO_GROUP_SNIPPETS);
	twipe(VUHDO_NAME_SNIPPETS);

	if ((tIndexGroups or 0) == 0) then
		_, tNumMacros = GetNumMacros();
		if ((tNumMacros or 0) > 17) then
			VUHDO_Msg(VUHDO_I18N_DC_SHIELD_NO_MACROS);
			VUHDO_IS_DC_TEMP_DISABLE = true;
		else
			CreateMacro(VUHDO_MACRO_NAME_GROUPS, 130, tMacroString, 1, 1);
		end
	else
		EditMacro(tIndexGroups, VUHDO_MACRO_NAME_GROUPS, 130, tMacroString, 1, 1);
	end

	if ((tIndexNames or 0) == 0) then
		_, tNumMacros = GetNumMacros();
		if ((tNumMacros or 0) > 17) then
			VUHDO_Msg(VUHDO_I18N_DC_SHIELD_NO_MACROS);
			VUHDO_IS_DC_TEMP_DISABLE = true;
		else
			CreateMacro(VUHDO_MACRO_NAME_NAMES, 130, tMacroNames, 1, 1);
		end
	else
		EditMacro(tIndexNames, VUHDO_MACRO_NAME_NAMES, 130, tMacroNames, 1, 1);
	end
end



--
local function VUHDO_buildInfoFromSnippet(aUnit, aSnippet, aName)
	local tInfo;
	local tClassId;

	if (VUHDO_RAID[aUnit] == nil) then
		VUHDO_RAID[aUnit] = { };
	end

	tClassId = VUHDO_MACRO_TO_CLASS[strsub(aSnippet, 2, 2)] or VUHDO_ID_PETS;

	tInfo = VUHDO_RAID[aUnit];
	tInfo["healthmax"] = 100;
	tInfo["health"] = 100;
	tInfo["name"] = aName or VUHDO_I18N_NOT_AVAILABLE;
	tInfo["number"] = VUHDO_getUnitNo(aUnit);
	tInfo["unit"] = aUnit;
	tInfo["class"] = VUHDO_ID_CLASSES[tClassId];
	tInfo["range"] = true;
	tInfo["debuff"] = 0;
	tInfo["isPet"] = strfind(aUnit, "pet", 1, true) ~= nil;
	tInfo["powertype"] = VUHDO_UNIT_POWER_MANA;
	tInfo["power"] = 100;
	tInfo["powermax"] = 100;
	tInfo["charmed"] = false;
	tInfo["dead"] = false;
	tInfo["connected"] = true;
	tInfo["aggro"] = false;
	tInfo["group"] = tonumber(strsub(aSnippet, 1, 1) or "1") or 1;
	tInfo["afk"] = false;
	tInfo["threat"] = false;
	tInfo["threatPerc"] = 0;
	tInfo["isVehicle"] = false;
	tInfo["ownerUnit"] = VUHDO_PET_2_OWNER[aUnit];
	tInfo["className"] = "";
	tInfo["petUnit"] = VUHDO_OWNER_2_PET[aUnit];
	tInfo["targetUnit"] = VUHDO_getTargetUnit(aUnit);
	tInfo["classId"] = tClassId;
	tInfo["sortMaxHp"] = 1;
	tInfo["role"] = VUHDO_MACRO_TO_ROLE[strsub(aSnippet, 3, 3)];
	tInfo["fullName"] = tInfo["name"];
	tInfo["raidIcon"] = nil;
	tInfo["visible"] = true;
	tInfo["zone"], tInfo["map"] = "foo", "foo";
	tInfo["baseRange"] = true;
end



--
function VUHDO_buildRaidFromMacro()
	local tIndexGroups;
	local tIndexNames;
	local tMacroGroups;
	local tMacroNames;
	local tCnt;
	local tStrIdx;
	local tSnippet;
	local tPrefix;
	local tUnit;
	local tName;

	tIndexGroups = GetMacroIndexByName(VUHDO_MACRO_NAME_GROUPS);
	tIndexNames = GetMacroIndexByName(VUHDO_MACRO_NAME_NAMES);

	if ((tIndexGroups or 0) == 0 or (tIndexNames or 0) == 0) then
		return false;
	end

	twipe(VUHDO_RAID);
	tMacroGroups = GetMacroBody(tIndexGroups);
	tMacroNames = GetMacroBody(tIndexNames);

	tSnippet = strsub(tMacroGroups, 1, 1);
	tPrefix = tSnippet == "R" and "raid" or "party";

	for tCnt = 1, 82 do -- VUHDO_MAX_MACRO_UNITS * 2
	  tStrIdx = tCnt * 3 - 1;
		tSnippet = strsub(tMacroGroups, tStrIdx, tStrIdx + 2);
		if ((tSnippet or VUHDO_EMPTY_SNIPPET) ~= VUHDO_EMPTY_SNIPPET) then
			if (tCnt == 41) then -- VUHDO_MAX_MACRO_UNITS
				tUnit = "player";
			elseif (tCnt == 82) then -- VUHDO_MAX_MACRO_UNITS * 2
				tUnit = "pet";
			elseif (tCnt > 41) then -- VUHDO_MAX_MACRO_UNITS
				tUnit = format("%spet%d", tPrefix, tCnt - 41);
			else
				tUnit = format("%s%d", tPrefix, tCnt);
			end

			tName = strsub(tMacroNames, tStrIdx, tStrIdx + 2);
			VUHDO_buildInfoFromSnippet(tUnit, tSnippet, tName);
		end
	end

	return true;
end



--
local VUHDO_SAFE_PARTY = {
	"player", "party1",	"party2",	"party3",	"party4"
};



function VUHDO_buildSafeParty()
	if (InCombatLockdown()) then
		return;
	end

	--local proposalExists, id, typeID, subtypeID, name, texture, role, hasResponded, totalEncounters, completedEncounters, numMembers, isLeader = GetLFGProposal();
	local _, _, _, tSubtypeID = GetLFGProposal();
	if (LFG_SUBTYPEID_RAID == tSubtypeID) then
		local tCnt, tUnit, tGroup;
		for tCnt = 0, 25 do
			tGroup = floor(tCnt / 5) + 1;
			tUnit = tCnt == 0 and "player" or "raid" .. tCnt;
			if (VUHDO_GROUPS[tGroup] == nil) then
				VUHDO_GROUPS[tGroup] = {};
			end
			if (tCnt % 5 == 0) then
				twipe(VUHDO_GROUPS[tGroup]);
			end

			tinsert(VUHDO_GROUPS[tGroup], tUnit);
			--VUHDO_xMsg(tGroup, tUnit);
		end
	else
		VUHDO_GROUPS[1] = VUHDO_deepCopyTable(VUHDO_SAFE_PARTY);
		VUHDO_GROUPS[10] = VUHDO_deepCopyTable(VUHDO_SAFE_PARTY);
	end

	VUHDO_initDynamicPanelModels();
	VUHDO_refreshUiNoMembers();
end
