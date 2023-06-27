VUHDO_DID_DC_RESTORE = false;

VUHDO_IN_COMBAT_RELOG = false;


VUHDO_RAID = { };
local VUHDO_RAID;

VUHDO_RAID_NAMES = { };
local VUHDO_RAID_NAMES = VUHDO_RAID_NAMES;

VUHDO_GROUPS = { };
local VUHDO_GROUPS = VUHDO_GROUPS;

VUHDO_RAID_GUIDS = { };
local VUHDO_RAID_GUIDS = VUHDO_RAID_GUIDS;

VUHDO_EMERGENCIES = { };
local VUHDO_EMERGENCIES = VUHDO_EMERGENCIES;

VUHDO_CLUSTER_BASE_RAID = { };
local VUHDO_CLUSTER_BASE_RAID = VUHDO_CLUSTER_BASE_RAID;

VUHDO_PLAYER_TARGETS = { };

local VUHDO_IS_SUSPICIOUS_ROSTER = false;

local VUHDO_RAID_SORTED = { };
local VUHDO_MAINTANKS = { };
local VUHDO_INTERNAL_TOGGLES = { };
local VUHDO_PANEL_UNITS = { {}, {}, {}, {}, {}, {}, {}, {}, {}, {} };


VUHDO_PLAYER_CLASS = nil;
VUHDO_PLAYER_NAME = nil;
VUHDO_PLAYER_RAID_ID = nil;
VUHDO_PLAYER_GROUP = nil;

VUHDO_GLOBAL = getfenv();

-- BURST CACHE ---------------------------------------------------
local VUHDO_CONFIG;
local VUHDO_PET_2_OWNER;
local VUHDO_OWNER_2_PET;

local VUHDO_getUnitIds;
local VUHDO_getUnitNo;
local VUHDO_isInRange;
local VUHDO_determineDebuff;
local VUHDO_getUnitGroup;
local VUHDO_tableUniqueAdd;
local VUHDO_getTargetUnit;
local VUHDO_updateHealthBarsFor;
local VUHDO_trimInspected;

local VUHDO_getPlayerRaidUnit;
local VUHDO_getModelType;
local VUHDO_isConfigDemoUsers;
local VUHDO_updateBouquetsForEvent;
local VUHDO_resetClusterCoordDeltas;
local VUHDO_getUnitZoneName;
local VUHDO_isModelInPanel;
local VUHDO_isAltPowerActive;
local VUHDO_isModelConfigured;
local VUHDO_determineRole;
local VUHDO_getUnitHealthPercent;
local VUHDO_isUnitInModel;
local VUHDO_isUnitInModelIterative;
local VUHDO_isUnitInPanel;
local VUHDO_initDynamicPanelModels;

local GetRaidTargetIndex = GetRaidTargetIndex;
local UnitIsDeadOrGhost = UnitIsDeadOrGhost;
local UnitIsFeignDeath = UnitIsFeignDeath;
local UnitExists = UnitExists;
local UnitHealth = UnitHealth;
local UnitHealthMax = UnitHealthMax;
local string = string;
local UnitIsAFK = UnitIsAFK;
local UnitIsConnected = UnitIsConnected;
local UnitIsCharmed = UnitIsCharmed;
local UnitCanAttack = UnitCanAttack;
local GetNumRaidMembers = GetNumRaidMembers;
local GetNumPartyMembers = GetNumPartyMembers;
local UnitName = UnitName;
local UnitMana = UnitMana;
local UnitManaMax = UnitManaMax;
local UnitThreatSituation = UnitThreatSituation;
local UnitClass = UnitClass;
local UnitPowerType = UnitPowerType;
local UnitHasVehicleUI = UnitHasVehicleUI;
local UnitGroupRolesAssigned = UnitGroupRolesAssigned;
local GetRaidRosterInfo = GetRaidRosterInfo;
local InCombatLockdown = InCombatLockdown;
local table = table;
local UnitGUID = UnitGUID;
local tinsert = tinsert;
local tremove = tremove;
local strfind = strfind;
local gsub = gsub;
--local VUHDO_PANEL_MODELS;
local GetTime = GetTime;
local pairs = pairs;
local ipairs = ipairs;
local format = format;
local twipe = table.wipe;
local tsort = table.sort;
local _ = _;
local sTrigger;
local sCurrentMode;


function VUHDO_vuhdoInitBurst()
	VUHDO_CONFIG = VUHDO_GLOBAL["VUHDO_CONFIG"];
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];
	VUHDO_PET_2_OWNER = VUHDO_GLOBAL["VUHDO_PET_2_OWNER"];
	VUHDO_OWNER_2_PET = VUHDO_GLOBAL["VUHDO_OWNER_2_PET"];
	VUHDO_getUnitIds = VUHDO_GLOBAL["VUHDO_getUnitIds"];
	VUHDO_getUnitNo = VUHDO_GLOBAL["VUHDO_getUnitNo"];
	VUHDO_isInRange = VUHDO_GLOBAL["VUHDO_isInRange"];
	VUHDO_determineDebuff = VUHDO_GLOBAL["VUHDO_determineDebuff"];
	VUHDO_getUnitGroup = VUHDO_GLOBAL["VUHDO_getUnitGroup"];
	VUHDO_updateHealthBarsFor = VUHDO_GLOBAL["VUHDO_updateHealthBarsFor"];
	VUHDO_tableUniqueAdd = VUHDO_GLOBAL["VUHDO_tableUniqueAdd"];
	VUHDO_trimInspected = VUHDO_GLOBAL["VUHDO_trimInspected"];
	VUHDO_getTargetUnit = VUHDO_GLOBAL["VUHDO_getTargetUnit"];
	VUHDO_getModelType = VUHDO_GLOBAL["VUHDO_getModelType"];
	VUHDO_isModelInPanel = VUHDO_GLOBAL["VUHDO_isModelInPanel"];
	VUHDO_isAltPowerActive = VUHDO_GLOBAL["VUHDO_isAltPowerActive"];
	VUHDO_getPlayerRaidUnit = VUHDO_GLOBAL["VUHDO_getPlayerRaidUnit"];
	VUHDO_isModelConfigured = VUHDO_GLOBAL["VUHDO_isModelConfigured"];
	VUHDO_isUnitInModel = VUHDO_GLOBAL["VUHDO_isUnitInModel"];
	VUHDO_isUnitInModelIterative = VUHDO_GLOBAL["VUHDO_isUnitInModelIterative"];
	VUHDO_isUnitInPanel = VUHDO_GLOBAL["VUHDO_isUnitInPanel"];
	VUHDO_initDynamicPanelModels = VUHDO_GLOBAL["VUHDO_initDynamicPanelModels"];

	--VUHDO_PANEL_MODELS = VUHDO_GLOBAL["VUHDO_PANEL_MODELS"];
	VUHDO_determineRole = VUHDO_GLOBAL["VUHDO_determineRole"];
	VUHDO_getUnitHealthPercent = VUHDO_GLOBAL["VUHDO_getUnitHealthPercent"];
	VUHDO_isConfigDemoUsers = VUHDO_GLOBAL["VUHDO_isConfigDemoUsers"];
	VUHDO_updateBouquetsForEvent = VUHDO_GLOBAL["VUHDO_updateBouquetsForEvent"];
	VUHDO_resetClusterCoordDeltas = VUHDO_GLOBAL["VUHDO_resetClusterCoordDeltas"];
	VUHDO_getUnitZoneName = VUHDO_GLOBAL["VUHDO_getUnitZoneName"];
	VUHDO_INTERNAL_TOGGLES = VUHDO_GLOBAL["VUHDO_INTERNAL_TOGGLES"];
	VUHDO_PANEL_UNITS = VUHDO_GLOBAL["VUHDO_PANEL_UNITS"];

	sTrigger = VUHDO_CONFIG["EMERGENCY_TRIGGER"];
	sCurrentMode = VUHDO_CONFIG["MODE"];
end

----------------------------------------------------

local VUHDO_UNIT_AFK_DC = { };



--
local tUnit, tInfo, tName;
local function VUHDO_updateAllRaidNames()
	twipe(VUHDO_RAID_NAMES);

	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if (tUnit ~= "focus" and tUnit ~= "target") then
			-- ensure not to overwrite a player name with a pet's identical name
			tName = tInfo["name"];
			if (VUHDO_RAID_NAMES[tName] == nil or not tInfo["isPet"]) then
				VUHDO_RAID_NAMES[tName] = tUnit;
			end
		end
	end
end



--
local function VUHDO_isValidEmergency(anInfo)
	return
		not anInfo["isPet"]
		and anInfo["range"]
		and not anInfo["dead"]
		and anInfo["connected"]
		and not anInfo["charmed"];
end



--
local tIndex, tUnit;
local function VUHDO_setTopEmergencies(aMaxAnz)
	twipe(VUHDO_EMERGENCIES);
	for tIndex, tUnit in ipairs(VUHDO_RAID_SORTED) do
		VUHDO_EMERGENCIES[tUnit] = tIndex;
		if (tIndex == aMaxAnz) then
			return;
		end
	end
end



--
local VUHDO_EMERGENCY_SORTERS = {
	[VUHDO_MODE_EMERGENCY_MOST_MISSING]
		= function(aUnit, anotherUnit)
				return VUHDO_RAID[aUnit]["healthmax"] - VUHDO_RAID[aUnit]["health"]
							> VUHDO_RAID[anotherUnit]["healthmax"] - VUHDO_RAID[anotherUnit]["health"];
			end,

	[VUHDO_MODE_EMERGENCY_PERC]
		= function(aUnit, anotherUnit)
					return VUHDO_RAID[aUnit]["health"] / VUHDO_RAID[aUnit]["healthmax"]
								< VUHDO_RAID[anotherUnit]["health"] / VUHDO_RAID[anotherUnit]["healthmax"];
			end,

	[VUHDO_MODE_EMERGENCY_LEAST_LEFT]
		= function(aUnit, anotherUnit)
				return VUHDO_RAID[aUnit]["health"] < VUHDO_RAID[anotherUnit]["health"];
			end,
}



--
local tUnit, tInfo;
local function VUHDO_sortEmergencies()
	if (sCurrentMode == 1) then -- VUHDO_MODE_NEUTRAL
		return;
	end

	twipe(VUHDO_RAID_SORTED);

	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if ("target" ~= tUnit and "focus" ~= tUnit
			and VUHDO_getUnitHealthPercent(tInfo) < sTrigger and VUHDO_isValidEmergency(tInfo)) then

			VUHDO_RAID_SORTED[#VUHDO_RAID_SORTED + 1] = tUnit;
 		end
	end

	tsort(VUHDO_RAID_SORTED, VUHDO_EMERGENCY_SORTERS[sCurrentMode]);
	VUHDO_setTopEmergencies(VUHDO_CONFIG["MAX_EMERGENCIES"]);
end



-- Avoid reordering sorting by max-health if someone dies or gets offline
local tEmptyInfo = {};
local function VUHDO_getUnitSortMaxHp(aUnit)
	if ((VUHDO_RAID[aUnit] or tEmptyInfo)["sortMaxHp"] ~= nil and InCombatLockdown()) then
		return VUHDO_RAID[aUnit]["sortMaxHp"];
	else
		return VUHDO_RAID[aUnit]["healthmax"];
	end
end



--
local tIsAfk;
local tIsConnected;
local function VUHDO_updateAfkDc(aUnit)
	tIsAfk = UnitIsAFK(aUnit);
	tIsConnected = UnitIsConnected(aUnit);
	if (tIsAfk or not tIsConnected) then
		if (VUHDO_UNIT_AFK_DC[aUnit] == nil) then
			VUHDO_UNIT_AFK_DC[aUnit] = GetTime();
		end
	else
		VUHDO_UNIT_AFK_DC[aUnit] = nil;
	end

	return tIsAfk, tIsConnected, VUHDO_RAID[aUnit] ~= nil and tIsConnected ~= VUHDO_RAID[aUnit]["connected"];
end



--
function VUHDO_getAfkDcTime(aUnit)
	return VUHDO_UNIT_AFK_DC[aUnit];
end



-- Sets a Member info into raid array
local tUnitId;
local tIsPet;
local tClassName;
local tPowerType;
local tIsAfk, tIsConnected;
local tLocalClass;
local tIsDead;
local tClassId;
local tInfo;
local tNewHealth;
local tName, tRealm;
local tIsDcChange;
local tOwner;
function VUHDO_setHealth(aUnit, aMode)

	tInfo = VUHDO_RAID[aUnit];

	if (4 == aMode) then -- VUHDO_UPDATE_DEBUFF
		if (tInfo ~= nil) then
			tInfo["debuff"], tInfo["debuffName"] = VUHDO_determineDebuff(aUnit);
		end
		return;
	end

	tUnitId, _ = VUHDO_getUnitIds();
	tOwner = VUHDO_PET_2_OWNER[aUnit];
	tIsPet = tOwner ~= nil;

	if (strfind(aUnit, tUnitId, 1, true) ~= nil
			or tIsPet
			or aUnit == "player" or aUnit == "focus" or aUnit == "target") then

		tIsDead = UnitIsDeadOrGhost(aUnit) and not UnitIsFeignDeath(aUnit);
		if (tIsDead) then
			VUHDO_removeAllDebuffIcons(aUnit);
			VUHDO_removeHots(aUnit);
		end

		if (1 == aMode) then -- VUHDO_UPDATE_ALL
			tLocalClass, tClassName = UnitClass(aUnit);
			tPowerType = UnitPowerType(aUnit);
			tIsAfk, tIsConnected, _ = VUHDO_updateAfkDc(aUnit);

			if (VUHDO_RAID[aUnit] == nil) then
				VUHDO_RAID[aUnit] = { };
			end
			tInfo = VUHDO_RAID[aUnit];
			tInfo["ownerUnit"] = tOwner;

			if (tIsPet and tClassId ~= nil) then
				if (VUHDO_USER_CLASS_COLORS["petClassColor"] and VUHDO_RAID[tInfo["ownerUnit"]] ~= nil) then
					tClassId = VUHDO_RAID[tInfo["ownerUnit"]]["classId"] or VUHDO_ID_PETS;
				else
					tClassId = VUHDO_ID_PETS;
				end
			else
				tClassId = VUHDO_CLASS_IDS[tClassName];
			end

			tName, tRealm = UnitName(aUnit);
			tInfo["healthmax"] = UnitHealthMax(aUnit);
			tInfo["health"] = UnitHealth(aUnit);
			tInfo["name"] = tName;
			tInfo["number"] = VUHDO_getUnitNo(aUnit);
			tInfo["unit"] = aUnit;
			tInfo["class"] = tClassName;
			tInfo["range"] = VUHDO_isInRange(aUnit);
			tInfo["debuff"], tInfo["debuffName"] = VUHDO_determineDebuff(aUnit);
			tInfo["isPet"] = tIsPet;
			tInfo["powertype"] = tonumber(tPowerType);
			tInfo["power"] = UnitMana(aUnit);
			tInfo["powermax"] = UnitManaMax(aUnit);
			tInfo["charmed"] = UnitIsCharmed(aUnit) and UnitCanAttack("player", aUnit);
			tInfo["aggro"] = false;
			tInfo["group"] = VUHDO_getUnitGroup(aUnit, tIsPet);
			tInfo["dead"] = tIsDead;
			tInfo["afk"] = tIsAfk;
			tInfo["connected"] = tIsConnected;
			tInfo["threat"] = UnitThreatSituation(aUnit);
			tInfo["threatPerc"] = 0;
			tInfo["isVehicle"] = UnitHasVehicleUI(aUnit);
			tInfo["className"] = tLocalClass or "";
			tInfo["petUnit"] = VUHDO_OWNER_2_PET[aUnit];
			tInfo["targetUnit"] = VUHDO_getTargetUnit(aUnit);
			tInfo["classId"] = tClassId;
			tInfo["sortMaxHp"] = VUHDO_getUnitSortMaxHp(aUnit);
			tInfo["role"] = VUHDO_determineRole(aUnit);
			tInfo["fullName"] = (tRealm or "") ~= "" and (tName .. "-" .. tRealm) or tName;
			tInfo["raidIcon"] = GetRaidTargetIndex(aUnit);
			tInfo["visible"] = UnitIsVisible(aUnit); -- Reihenfolge beachten
			tInfo["zone"], tInfo["map"] = VUHDO_getUnitZoneName(aUnit); -- ^^
			tInfo["baseRange"] = UnitInRange(aUnit);
			tInfo["isAltPower"] = VUHDO_isAltPowerActive(aUnit);
			--[[tInfo["missbuff"] = nil;
			tInfo["mibucateg"] = nil;
			tInfo["mibuvariants"] = nil;]]

			if (aUnit ~= "focus" and aUnit ~= "target") then
				if (not tIsPet and tInfo["fullName"] == tName and VUHDO_RAID_NAMES[tName] ~= nil) then
					VUHDO_IS_SUSPICIOUS_ROSTER = true;
				end

				-- ensure not to overwrite a player name with a pet's identical name
				if (VUHDO_RAID_NAMES[tName] == nil or not tIsPet) then
					VUHDO_RAID_NAMES[tName] = aUnit;
				end
			end

		elseif (tInfo ~= nil) then
			tIsAfk, tInfo["connected"], tIsDcChange = VUHDO_updateAfkDc(aUnit);

			if (tIsDcChange) then
				VUHDO_updateBouquetsForEvent(aUnit, 19); -- VUHDO_UPDATE_DC
			end

			if (2 == aMode) then -- VUHDO_UPDATE_HEALTH
				tNewHealth = UnitHealth(aUnit);
				if (not tIsDead and tInfo["health"] > 0) then
					tInfo["lifeLossPerc"] = tNewHealth / tInfo["health"];
				end

				tInfo["health"] = tNewHealth;

				if (tInfo["dead"] ~= tIsDead) then
					if (tInfo["dead"] and not tIsDead) then
						tInfo["healthmax"] = UnitHealthMax(aUnit);
					end
					tInfo["dead"] = tIsDead;
					VUHDO_updateHealthBarsFor(aUnit, 10); -- VUHDO_UPDATE_ALIVE
					VUHDO_updateBouquetsForEvent(aUnit, 10); -- VUHDO_UPDATE_ALIVE
				end

			elseif (3 == aMode) then -- VUHDO_UPDATE_HEALTH_MAX
				tInfo["dead"] = tIsDead;
				tInfo["healthmax"] = UnitHealthMax(aUnit);
				tInfo["sortMaxHp"] = VUHDO_getUnitSortMaxHp(aUnit);

			elseif (6 == aMode) then -- VUHDO_UPDATE_AFK
				tInfo["afk"] = tIsAfk;
			end
		end
	end
end
local VUHDO_setHealth = VUHDO_setHealth;



--
local function VUHDO_setHealthSafe(aUnit, aMode)
	if (UnitExists(aUnit)) then
		VUHDO_setHealth(aUnit, aMode);
	end
end



-- Callback for UNIT_HEALTH / UNIT_MAXHEALTH events
local tUnit;
local tOwner;
local tIsPet;
function VUHDO_updateHealth(aUnit, aMode)
	tIsPet = VUHDO_RAID[aUnit]["isPet"];

	if (not tIsPet or VUHDO_INTERNAL_TOGGLES[26]) then -- VUHDO_UPDATE_PETS  -- Enth„lt nur Pets als eigene Balken, vehicles werden ?ber owner dargestellt s.unten
		VUHDO_setHealth(aUnit, aMode);
		VUHDO_updateHealthBarsFor(aUnit, aMode);
	end

	if (tIsPet) then -- Vehikel?
		tOwner = VUHDO_RAID[aUnit]["ownerUnit"];
		if (tOwner ~= nil and VUHDO_RAID[tOwner]["isVehicle"]) then
			VUHDO_setHealth(tOwner, aMode);
			VUHDO_updateHealthBarsFor(tOwner, aMode);
		end
	end

	if (1 ~= sCurrentMode -- VUHDO_MODE_NEUTRAL
		and (2 == aMode or 3 == aMode)) then -- VUHDO_UPDATE_HEALTH -- VUHDO_UPDATE_HEALTH_MAX
		-- Remove old emergencies
		VUHDO_FORCE_RESET = true;
		for tUnit, _ in pairs(VUHDO_EMERGENCIES) do
			VUHDO_updateHealthBarsFor(tUnit, 11); -- VUHDO_UPDATE_EMERGENCY
		end
		VUHDO_sortEmergencies();
		-- Set new Emergencies
		VUHDO_FORCE_RESET = false;
		for tUnit, _ in pairs(VUHDO_EMERGENCIES) do
			VUHDO_updateHealthBarsFor(tUnit, 11); -- VUHDO_UPDATE_EMERGENCY
		end
	end
end



--
local tUnit, tInfo, tIcon;
function VUHDO_updateAllRaidTargetIndices()
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		tIcon = GetRaidTargetIndex(tUnit);
		if (tInfo["raidIcon"] ~= tIcon) then
			tInfo["raidIcon"] = tIcon;
			VUHDO_updateBouquetsForEvent(tUnit, 24); -- VUHDO_UPDATE_RAID_TARGET
		end
	end
end



-- Add to groups 1-8
local function VUHDO_addUnitToGroup(aUnit, aGroupNum)
	if ("player" == aUnit and VUHDO_CONFIG["OMIT_SELF"]) then
		return;
	end

	if (not VUHDO_CONFIG["OMIT_OWN_GROUP"] or aGroupNum ~= VUHDO_PLAYER_GROUP) then
		tinsert(VUHDO_GROUPS[aGroupNum] or {}, aUnit);
	end

	if (VUHDO_PLAYER_GROUP == aGroupNum) then
		tinsert(VUHDO_GROUPS[10], aUnit); -- VUHDO_ID_GROUP_OWN
	end
end



--
local function VUHDO_addUnitToClass(aUnit, aClassId)
	if (("player" == aUnit and VUHDO_CONFIG["OMIT_SELF"]) or aClassId == nil) then
		return;
	end

	tinsert(VUHDO_GROUPS[aClassId], aUnit);
end



--
local tModelId, tAllUnits, tIndex, tUnit;
local function VUHDO_removeUnitFromRaidGroups(aUnit)
	for tModelId, tAllUnits in pairs(VUHDO_GROUPS) do
		if (tModelId ~= 41 -- VUHDO_ID_MAINTANKS
			and tModelId ~= 42 -- VUHDO_ID_PRIVATE_TANKS
			and tModelId ~= 43) then -- VUHDO_ID_MAIN_ASSISTS
			for tIndex, tUnit in pairs(tAllUnits) do
				if (tUnit == aUnit) then
					tremove(tAllUnits, tIndex);
				end
			end
		end
	end
end



--
local function VUHDO_removeSpecialFromAllRaidGroups()
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if (VUHDO_CONFIG["OMIT_MAIN_TANKS"] and VUHDO_isModelConfigured(41) and VUHDO_isUnitInModelIterative(tUnit, 41)) then -- VUHDO_ID_MAINTANKS
			VUHDO_removeUnitFromRaidGroups(tUnit); -- VUHDO_ID_MAINTANKS
		elseif (VUHDO_CONFIG["OMIT_PLAYER_TARGETS"] and VUHDO_isModelConfigured(42) and VUHDO_isUnitInModelIterative(tUnit, 42)) then -- VUHDO_ID_PRIVATE_TANKS
			VUHDO_removeUnitFromRaidGroups(tUnit); -- VUHDO_ID_PRIVATE_TANKS
		elseif (VUHDO_CONFIG["OMIT_MAIN_ASSIST"] and VUHDO_isModelConfigured(43) and VUHDO_isUnitInModelIterative(tUnit, 43)) then -- VUHDO_ID_MAIN_ASSISTS
			VUHDO_removeUnitFromRaidGroups(tUnit); -- VUHDO_ID_MAIN_ASSISTS
		end
	end
end



--
local tRole;
local function VUHDO_addUnitToSpecial(aUnit)
	if (VUHDO_CONFIG["OMIT_DFT_MTS"] and "TANK" == (UnitGroupRolesAssigned(aUnit))) then
		tinsert(VUHDO_GROUPS[41], aUnit); -- VUHDO_ID_MAINTANKS
		return;
	end

	if (GetNumRaidMembers() == 0) then
		return;
	end
	_, _, _, _, _, _, _, _, _, tRole, _ = GetRaidRosterInfo(VUHDO_RAID[aUnit]["number"]);

	if ("MAINTANK" == tRole) then
		tinsert(VUHDO_GROUPS[41], aUnit); -- VUHDO_ID_MAINTANKS
	elseif ("MAINASSIST" == tRole) then
		tinsert(VUHDO_GROUPS[43], aUnit); -- VUHDO_ID_MAIN_ASSISTS
	end
end



--
local tCnt;
local tUnit;
local function VUHDO_addUnitToCtraMainTanks()
	for tCnt = 1, 8 do -- VUHDO_MAX_MTS
		tUnit = VUHDO_MAINTANKS[tCnt];
		if (tUnit ~= nil) then
			VUHDO_tableUniqueAdd(VUHDO_GROUPS[41], tUnit); -- VUHDO_ID_MAINTANKS
		end
	end
end



--
local tUnit, tName;
local function VUHDO_addUnitToPrivateTanks()
	if (VUHDO_INTERNAL_TOGGLES[27]) then -- VUHDO_UPDATE_PLAYER_TARGET
		tinsert(VUHDO_GROUPS[42], "target"); -- VUHDO_ID_PRIVATE_TANKS
	end

	if (not VUHDO_CONFIG["OMIT_FOCUS"]) then
		tinsert(VUHDO_GROUPS[42], "focus"); -- VUHDO_ID_PRIVATE_TANKS
	end

	for tName, _ in pairs(VUHDO_PLAYER_TARGETS) do
		tUnit = VUHDO_RAID_NAMES[tName];
		if (tUnit ~= nil) then
			VUHDO_tableUniqueAdd(VUHDO_GROUPS[42], tUnit); -- VUHDO_ID_PRIVATE_TANKS
		else
			VUHDO_PLAYER_TARGETS[tName] = nil;
		end
	end
end



--
local tVehicleInfo = { ["isVehicle"] = true };
local function VUHDO_addUnitToPets(aPetUnit)
	if ((VUHDO_RAID[VUHDO_RAID[aPetUnit]["ownerUnit"]] or tVehicleInfo)["isVehicle"]) then
		return;
	end

	tinsert(VUHDO_GROUPS[40], aPetUnit); -- VUHDO_ID_PETS
end



--
local tRole;
local function VUHDO_addUnitToRole(aUnit)
	if ("player" == aUnit and VUHDO_CONFIG["OMIT_SELF"]) then
		return;
	end

	tRole = VUHDO_RAID[aUnit]["role"] or 62; -- -- VUHDO_ID_RANGED_DAMAGE

	tinsert(VUHDO_GROUPS[tRole], aUnit);
	if(tRole == 63 or tRole == 62) then -- VUHDO_ID_RANGED_HEAL -- VUHDO_ID_RANGED_DAMAGE
		tinsert(VUHDO_GROUPS[51], aUnit); -- VUHDO_ID_RANGED
	elseif(tRole == 61 or tRole == 60) then -- VUHDO_ID_MELEE_DAMAGE -- VUHDO_ID_MELEE_TANK
		tinsert(VUHDO_GROUPS[50], aUnit); -- VUHDO_ID_MELEE
	end
end



--
local function VUHDO_addUnitToVehicles(aUnit)
	if (VUHDO_RAID[aUnit]["petUnit"] ~= nil) then
		tinsert(VUHDO_GROUPS[70], VUHDO_RAID[aUnit]["petUnit"]); -- VUHDO_ID_VEHICLES
	end
end



-- Get an empty array for each group
local tType, tTypeMembers, tMember, tBuffClassGroup;
local function VUHDO_initGroupArrays()
	twipe(VUHDO_GROUPS);

	for tType, tTypeMembers in pairs(VUHDO_ID_TYPE_MEMBERS) do
		for _, tMember in pairs(tTypeMembers) do
			VUHDO_GROUPS[tMember] = { };
		end
	end
end



--
local tUnit, tInfo;
local function VUHDO_updateGroupArrays(anWasMacroRestore)
	VUHDO_initGroupArrays();

	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if (not tInfo["isPet"]) then
			if ("focus" ~= tUnit and "target" ~= tUnit) then
				VUHDO_addUnitToGroup(tUnit, tInfo["group"]);
				VUHDO_addUnitToClass(tUnit, tInfo["classId"]);
				VUHDO_addUnitToVehicles(tUnit);
				VUHDO_addUnitToSpecial(tUnit);
			end
		else
			VUHDO_addUnitToPets(tUnit);
		end
	end
	tinsert(VUHDO_GROUPS[80], "player"); -- VUHDO_ID_SELF
	tinsert(VUHDO_GROUPS[81], "pet"); -- VUHDO_ID_SELF_PET

	VUHDO_addUnitToCtraMainTanks();
	VUHDO_addUnitToPrivateTanks();

	-- Need MTs for role estimation
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if ("focus" ~= tUnit and "target" ~= tUnit and not tInfo["isPet"]) then
			VUHDO_addUnitToRole(tUnit);
		end
	end
	if (not anWasMacroRestore) then
		VUHDO_removeSpecialFromAllRaidGroups();
	end
	VUHDO_initDynamicPanelModels();
end



-- Uniquely buffer all units defined in a panel
local tPanelUnits = { };
local tPanelNum;
local tHasVehicles;
local tHasPrivateTanks;
local tVehicleUnit;
local tUnit;
local function VUHDO_updateAllPanelUnits()

	VUHDO_resetRemoveFromRaidGroupsCache();

	for tPanelNum = 1, 10 do -- VUHDO_MAX_PANELS
		twipe(VUHDO_PANEL_UNITS[tPanelNum]);

		if (VUHDO_PANEL_MODELS[tPanelNum] ~= nil) then
			tHasVehicles = VUHDO_isModelInPanel(tPanelNum, 70); -- VUHDO_ID_VEHICLES
			twipe(tPanelUnits);
			for tUnit, _ in pairs(VUHDO_RAID) do
				if (VUHDO_isUnitInPanel(tPanelNum, tUnit)) then
					tPanelUnits[tUnit] = tUnit;
				end

				if (tHasVehicles and not VUHDO_RAID[tUnit]["isPet"]) then
					tVehicleUnit =	VUHDO_RAID[tUnit]["petUnit"];
					if (tVehicleUnit ~= nil) then -- e.g. "focus", "target"
						tPanelUnits[tVehicleUnit] = tVehicleUnit;
					end
				end
			end

			tHasPrivateTanks = VUHDO_isModelInPanel(tPanelNum, 42); -- VUHDO_ID_PRIVATE_TANKS
			if (tHasPrivateTanks) then
				if (not VUHDO_CONFIG["OMIT_TARGET"]) then
					tPanelUnits["target"] = "target";
				end
				if (not VUHDO_CONFIG["OMIT_FOCUS"]) then
					tPanelUnits["focus"] = "focus";
				end
			end

			for _, tUnit in pairs(tPanelUnits) do
				tinsert(VUHDO_PANEL_UNITS[tPanelNum], tUnit);
			end
		end
	end
end



--
local tUnit;
local function VUHDO_updateAllGuids()
	twipe(VUHDO_RAID_GUIDS);
	for tUnit, _ in pairs(VUHDO_RAID) do
		if (tUnit ~= "focus" and tUnit ~= "target") then
			VUHDO_RAID_GUIDS[UnitGUID(tUnit) or 0] = tUnit;
		end
	end
end



--
local tCnt, tName;
local function VUHDO_convertMainTanks()
	-- Discard deprecated
	for tCnt = 1, 8 do -- VUHDO_MAX_MTS
		tName = VUHDO_MAINTANK_NAMES[tCnt] or "*";
		if (VUHDO_RAID_NAMES[tName] == nil) then
			VUHDO_MAINTANK_NAMES[tCnt] = nil;
		end
	end
	-- Convert to units instead of names
	twipe(VUHDO_MAINTANKS);
	for tCnt, tName in pairs(VUHDO_MAINTANK_NAMES) do
		VUHDO_MAINTANKS[tCnt] = VUHDO_RAID_NAMES[tName];
	end
end



--
local tUnit, tInfo;
local function VUHDO_createClusterUnits()
	twipe(VUHDO_CLUSTER_BASE_RAID);
	VUHDO_resetClusterCoordDeltas();

	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if (not tInfo["isPet"] -- won't work for pets
				and "focus" ~= tUnit and "target" ~= tUnit) then

			VUHDO_CLUSTER_BASE_RAID[#VUHDO_CLUSTER_BASE_RAID + 1] = tInfo;
		end
	end
end



--
-- Reload all raid members into the raid array e.g. in case of raid roster change
function VUHDO_reloadRaidMembers()
	local i;
	local tPlayer;
	local tMaxMembers;
	local tUnit, tPetUnit;
	local tWasRestored = false;

	VUHDO_IS_SUSPICIOUS_ROSTER = false;

	if (GetNumRaidMembers() == 0 and not UnitExists("party1") and not VUHDO_DID_DC_RESTORE) then
		VUHDO_IN_COMBAT_RELOG = true;
		tWasRestored = VUHDO_buildRaidFromMacro();
		VUHDO_updateAllRaidNames();
		if (tWasRestored) then
			VUHDO_normalRaidReload(true);
		end
		VUHDO_DID_DC_RESTORE = true;
	elseif (VUHDO_isConfigDemoUsers()) then
		VUHDO_demoSetupResetUsers();
		VUHDO_reloadRaidDemoUsers();
		VUHDO_updateAllRaidNames();
	else
		VUHDO_PLAYER_RAID_ID = VUHDO_getPlayerRaidUnit();
		VUHDO_IN_COMBAT_RELOG = false;
		VUHDO_DID_DC_RESTORE = true;
		tUnit, tPetUnit = VUHDO_getUnitIds();

		tMaxMembers = ("raid" == tUnit) and GetNumRaidMembers() or ("party" == tUnit) and 4 or 0;

		twipe(VUHDO_RAID);
		twipe(VUHDO_RAID_NAMES);

		for i = 1, tMaxMembers do
			tPlayer = format("%s%d", tUnit, i);
			if (UnitExists(tPlayer) and tPlayer ~= VUHDO_PLAYER_RAID_ID) then
				VUHDO_setHealth(tPlayer, 1); -- VUHDO_UPDATE_ALL
				VUHDO_setHealthSafe(format("%s%d", tPetUnit, i), 1); -- VUHDO_UPDATE_ALL
			end
		end

		VUHDO_setHealthSafe("player", 1); -- VUHDO_UPDATE_ALL
		VUHDO_setHealthSafe("pet", 1); -- VUHDO_UPDATE_ALL
		VUHDO_setHealthSafe("focus", 1); -- VUHDO_UPDATE_ALL

		if (VUHDO_INTERNAL_TOGGLES[27]) then -- VUHDO_UPDATE_PLAYER_TARGET
			VUHDO_setHealthSafe("target", 1); -- VUHDO_UPDATE_ALL
		end

		VUHDO_TIMERS["MIRROR_TO_MACRO"] = 8;
	end

	VUHDO_PLAYER_GROUP = VUHDO_getUnitGroup(VUHDO_PLAYER_RAID_ID, false);

	VUHDO_trimInspected();
	VUHDO_convertMainTanks();
	VUHDO_updateGroupArrays(tWasRestored);
	VUHDO_updateAllPanelUnits();
	VUHDO_updateAllGuids();
	VUHDO_updateBuffRaidGroup();
	VUHDO_updateBuffPanel();
	VUHDO_sortEmergencies();
	VUHDO_createClusterUnits();

	if (VUHDO_IS_SUSPICIOUS_ROSTER) then
		VUHDO_normalRaidReload();
	end
end



--
local i;
local tPlayer;
local tMaxMembers;
local tUnitType = "foo";
local tPetUnitType;
local tInfo;
local tIsDcChange;
local tName, tRealm;
local tOldUnitType;
function VUHDO_refreshRaidMembers()
	VUHDO_IS_SUSPICIOUS_ROSTER = false;

	if (VUHDO_isConfigDemoUsers()) then
		VUHDO_reloadRaidDemoUsers();
		VUHDO_updateAllRaidNames();
	else
		VUHDO_PLAYER_RAID_ID = VUHDO_getPlayerRaidUnit();
		VUHDO_IN_COMBAT_RELOG = false;

		tOldUnitType = tUnitType;
		tUnitType, tPetUnitType = VUHDO_getUnitIds();

		tMaxMembers = ("raid" == tUnitType) and 4 or ("party" == tUnitType) and 4 or 0;
		twipe(VUHDO_RAID_NAMES); -- für VUHDO_SUSPICIOUS_RAID_ROSTER

		if (not InCombatLockdown()) then -- Im combat lockdown heben wir uns verwaiste unit-ids auf um nachrückende Spieler darstellen zu können
			if (tOldUnitType ~= tUnitType) then -- Falls Gruppe<->Raid
				twipe(VUHDO_RAID);
			else
				for tPlayer, _ in pairs(VUHDO_RAID) do
					if (not UnitExists(tPlayer) or tPlayer == VUHDO_PLAYER_RAID_ID) then -- bei raid roster wechsel kann unsere raid id vorher wem anders gehört haben
						VUHDO_RAID[tPlayer] = nil;
					end
				end
			end
		end

		for i = 1, tMaxMembers do
			tPlayer = format("%s%d", tUnitType, i);
			if (UnitExists(tPlayer) and tPlayer ~= VUHDO_PLAYER_RAID_ID) then
				tInfo = VUHDO_RAID[tPlayer];
				if (tInfo == nil or VUHDO_RAID_GUIDS[UnitGUID(tPlayer)] ~= tPlayer) then
					VUHDO_setHealth(tPlayer, VUHDO_UPDATE_ALL);
				else
					tInfo["group"] = VUHDO_getUnitGroup(tPlayer, false);
					tInfo["isVehicle"] = UnitHasVehicleUI(tPlayer);
					tInfo["role"] = VUHDO_determineRole(tPlayer); -- weil talent-scanner nach und nach arbeitet
					tInfo["afk"], tInfo["connected"], tIsDcChange = VUHDO_updateAfkDc(tPlayer);
					tInfo["range"] = VUHDO_isInRange(tPlayer);

					tName, tRealm = UnitName(tPlayer);
					tInfo["name"] = tName;
					if (strlen(tRealm or "") > 0) then
						tInfo["fullName"] = tName .. "-" .. tRealm;
					else
						tInfo["fullName"] = tName;
						if (VUHDO_RAID_NAMES[tName] ~= nil) then
							VUHDO_IS_SUSPICIOUS_ROSTER = true;
						end
					end
					VUHDO_RAID_NAMES[tName] = tPlayer;

					if (tIsDcChange) then
						VUHDO_updateBouquetsForEvent(tPlayer, 19); -- VUHDO_UPDATE_DC
					end
				end

				VUHDO_setHealthSafe(format("%s%d", tPetUnitType, i), 1); -- VUHDO_UPDATE_ALL
			end

			VUHDO_TIMERS["MIRROR_TO_MACRO"] = 8;
		end

		VUHDO_setHealthSafe("player", 1); -- VUHDO_UPDATE_ALL
		VUHDO_setHealthSafe("pet", 1); -- VUHDO_UPDATE_ALL
		VUHDO_setHealthSafe("focus", 1); -- VUHDO_UPDATE_ALL
		if (VUHDO_INTERNAL_TOGGLES[27]) then -- VUHDO_UPDATE_PLAYER_TARGET
			VUHDO_setHealthSafe("target", 1); -- VUHDO_UPDATE_ALL
		end
	end

	VUHDO_PLAYER_GROUP = VUHDO_getUnitGroup(VUHDO_PLAYER_RAID_ID, false);

	VUHDO_updateAllRaidNames();
	VUHDO_trimInspected();
	VUHDO_convertMainTanks();
	VUHDO_updateGroupArrays(false);
	VUHDO_updateAllPanelUnits();
	VUHDO_updateAllGuids();
	VUHDO_updateBuffRaidGroup();
	VUHDO_sortEmergencies();
	VUHDO_createClusterUnits();

	if (VUHDO_IS_SUSPICIOUS_ROSTER) then
		VUHDO_lateRaidReload();
	end
end

