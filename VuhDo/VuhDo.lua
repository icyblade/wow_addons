local sIsRestoredAfterDc = false;

VUHDO_IN_COMBAT_RELOG = false;

VUHDO_DEBUG = { };


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
local VUHDO_PANEL_UNITS = { };
setmetatable(VUHDO_PANEL_UNITS, VUHDO_META_NEW_ARRAY);


VUHDO_PLAYER_CLASS = nil;
VUHDO_PLAYER_NAME = nil;
VUHDO_PLAYER_RAID_ID = nil;
VUHDO_PLAYER_GROUP = nil;

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
local VUHDO_updateBuffRaidGroup;

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
local GetNumGroupMembers = GetNumGroupMembers;
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
local IsInRaid = IsInRaid;
local table = table;
local UnitGUID = UnitGUID;
local tinsert = tinsert;
local tremove = tremove;
local strfind = strfind;
--local VUHDO_PANEL_MODELS;
local GetTime = GetTime;
local pairs = pairs;
local ipairs = ipairs;
local twipe = table.wipe;
local tsort = table.sort;
local _;
local sTrigger;
local sCurrentMode;


function VUHDO_vuhdoInitLocalOverrides()
	VUHDO_CONFIG = _G["VUHDO_CONFIG"];
	VUHDO_RAID = _G["VUHDO_RAID"];
	VUHDO_PET_2_OWNER = _G["VUHDO_PET_2_OWNER"];
	VUHDO_OWNER_2_PET = _G["VUHDO_OWNER_2_PET"];
	VUHDO_getUnitIds = _G["VUHDO_getUnitIds"];
	VUHDO_getUnitNo = _G["VUHDO_getUnitNo"];
	VUHDO_isInRange = _G["VUHDO_isInRange"];
	VUHDO_determineDebuff = _G["VUHDO_determineDebuff"];
	VUHDO_getUnitGroup = _G["VUHDO_getUnitGroup"];
	VUHDO_updateHealthBarsFor = _G["VUHDO_updateHealthBarsFor"];
	VUHDO_tableUniqueAdd = _G["VUHDO_tableUniqueAdd"];
	VUHDO_trimInspected = _G["VUHDO_trimInspected"];
	VUHDO_getTargetUnit = _G["VUHDO_getTargetUnit"];
	VUHDO_getModelType = _G["VUHDO_getModelType"];
	VUHDO_isModelInPanel = _G["VUHDO_isModelInPanel"];
	VUHDO_isAltPowerActive = _G["VUHDO_isAltPowerActive"];
	VUHDO_getPlayerRaidUnit = _G["VUHDO_getPlayerRaidUnit"];
	VUHDO_isModelConfigured = _G["VUHDO_isModelConfigured"];
	VUHDO_isUnitInModel = _G["VUHDO_isUnitInModel"];
	VUHDO_isUnitInModelIterative = _G["VUHDO_isUnitInModelIterative"];
	VUHDO_isUnitInPanel = _G["VUHDO_isUnitInPanel"];
	VUHDO_initDynamicPanelModels = _G["VUHDO_initDynamicPanelModels"];
	VUHDO_updateBuffRaidGroup = _G["VUHDO_updateBuffRaidGroup"];

	--VUHDO_PANEL_MODELS = _G["VUHDO_PANEL_MODELS"];
	VUHDO_determineRole = _G["VUHDO_determineRole"];
	VUHDO_getUnitHealthPercent = _G["VUHDO_getUnitHealthPercent"];
	VUHDO_isConfigDemoUsers = _G["VUHDO_isConfigDemoUsers"];
	VUHDO_updateBouquetsForEvent = _G["VUHDO_updateBouquetsForEvent"];
	VUHDO_resetClusterCoordDeltas = _G["VUHDO_resetClusterCoordDeltas"];
	VUHDO_getUnitZoneName = _G["VUHDO_getUnitZoneName"];
	VUHDO_INTERNAL_TOGGLES = _G["VUHDO_INTERNAL_TOGGLES"];
	VUHDO_PANEL_UNITS = _G["VUHDO_PANEL_UNITS"];

	sTrigger = VUHDO_CONFIG["EMERGENCY_TRIGGER"];
	sCurrentMode = VUHDO_CONFIG["MODE"];
end

----------------------------------------------------

local VUHDO_UNIT_AFK_DC = { };



--
local function VUHDO_updateAllRaidNames()
	twipe(VUHDO_RAID_NAMES);

	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if tUnit ~= "focus" and tUnit ~= "target" then
			-- ensure not to overwrite a player name with a pet's identical name
			if not VUHDO_RAID_NAMES[tInfo["name"]] or not tInfo["isPet"] then
				VUHDO_RAID_NAMES[tInfo["name"]] = tUnit;
			end
		end
	end
end



--
local function VUHDO_isValidEmergency(anInfo)
	return not anInfo["isPet"] and anInfo["range"] and not anInfo["dead"]
		and anInfo["connected"] and not anInfo["charmed"];
end



--
local function VUHDO_setTopEmergencies(aMaxAnz)
	twipe(VUHDO_EMERGENCIES);
	for tIndex, tUnit in ipairs(VUHDO_RAID_SORTED) do
		VUHDO_EMERGENCIES[tUnit] = tIndex;
		if tIndex == aMaxAnz then return; end
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
local function VUHDO_sortEmergencies()
	twipe(VUHDO_RAID_SORTED);

	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if "target" ~= tUnit and "focus" ~= tUnit
			and VUHDO_getUnitHealthPercent(tInfo) < sTrigger and VUHDO_isValidEmergency(tInfo) then

			VUHDO_RAID_SORTED[#VUHDO_RAID_SORTED + 1] = tUnit;
 		end
	end

	tsort(VUHDO_RAID_SORTED, VUHDO_EMERGENCY_SORTERS[sCurrentMode]);
	VUHDO_setTopEmergencies(VUHDO_CONFIG["MAX_EMERGENCIES"]);
end



-- Avoid reordering sorting by max-health if someone dies or gets offline
local tEmptyInfo = {};
local function VUHDO_getUnitSortMaxHp(aUnit)
	return VUHDO_RAID[aUnit][
		((VUHDO_RAID[aUnit] or tEmptyInfo)["sortMaxHp"] ~= nil and InCombatLockdown())
			and "sortMaxHp" or "healthmax"
	];
end



--
local tIsAfk;
local tIsConnected;
local function VUHDO_updateAfkDc(aUnit)
	tIsAfk = UnitIsAFK(aUnit);
	tIsConnected = UnitIsConnected(aUnit);
	if tIsAfk or not tIsConnected then
		if not VUHDO_UNIT_AFK_DC[aUnit] then VUHDO_UNIT_AFK_DC[aUnit] = GetTime(); end
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

	tUnitId = VUHDO_getUnitIds();
	tOwner = VUHDO_PET_2_OWNER[aUnit];
	tIsPet = tOwner ~= nil;

	if strfind(aUnit, tUnitId, 1, true) or tIsPet
			or aUnit == "player" or aUnit == "focus" or aUnit == "target" then

		tIsDead = UnitIsDeadOrGhost(aUnit) and not UnitIsFeignDeath(aUnit);
		if tIsDead then
			VUHDO_removeAllDebuffIcons(aUnit);
			VUHDO_removeHots(aUnit);
			VUHDO_initEventBouquetsFor(aUnit);
		end

		if 1 == aMode then -- VUHDO_UPDATE_ALL
			tLocalClass, tClassName = UnitClass(aUnit);
			tPowerType = UnitPowerType(aUnit);
			tIsAfk, tIsConnected, _ = VUHDO_updateAfkDc(aUnit);

			if not VUHDO_RAID[aUnit] then	VUHDO_RAID[aUnit] = { }; end
			tInfo = VUHDO_RAID[aUnit];
			tInfo["ownerUnit"] = tOwner;

			if tIsPet and tClassId then
				if VUHDO_USER_CLASS_COLORS["petClassColor"] and VUHDO_RAID[tInfo["ownerUnit"]] then
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
			tInfo["threat"] = UnitThreatSituation(aUnit) or 0;
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
			tInfo["baseRange"] = UnitInRange(aUnit) or "player" == aUnit;
			tInfo["isAltPower"] = VUHDO_isAltPowerActive(aUnit);
			--[[tInfo["missbuff"] = nil;
			tInfo["mibucateg"] = nil;
			tInfo["mibuvariants"] = nil;]]

			if aUnit ~= "focus" and aUnit ~= "target" then
				if not tIsPet and tInfo["fullName"] == tName and VUHDO_RAID_NAMES[tName] then
					VUHDO_IS_SUSPICIOUS_ROSTER = true;
				end

				-- ensure not to overwrite a player name with a pet's identical name
				if not VUHDO_RAID_NAMES[tName] or not tIsPet then
					VUHDO_RAID_NAMES[tName] = aUnit;
				end
			end

		elseif tInfo then
			tIsAfk, tInfo["connected"], tIsDcChange = VUHDO_updateAfkDc(aUnit);
			tInfo["dead"] = tIsDead;

			if tIsDcChange then VUHDO_updateBouquetsForEvent(aUnit, 19); end-- VUHDO_UPDATE_DC

			if 2 == aMode then -- VUHDO_UPDATE_HEALTH
				tNewHealth = UnitHealth(aUnit);
				if not tIsDead and tInfo["health"] > 0 then
					tInfo["lifeLossPerc"] = tNewHealth / tInfo["health"];
				end

				tInfo["health"] = tNewHealth;

				if tInfo["dead"] ~= tIsDead then
					if not tIsDead then
						tInfo["healthmax"] = UnitHealthMax(aUnit);
					end
					tInfo["dead"] = tIsDead;
					VUHDO_updateHealthBarsFor(aUnit, 10); -- VUHDO_UPDATE_ALIVE
					VUHDO_updateBouquetsForEvent(aUnit, 10); -- VUHDO_UPDATE_ALIVE
				end

			elseif 3 == aMode then -- VUHDO_UPDATE_HEALTH_MAX
				tInfo["dead"] = tIsDead;
				tInfo["healthmax"] = UnitHealthMax(aUnit);
				tInfo["sortMaxHp"] = VUHDO_getUnitSortMaxHp(aUnit);

			elseif 6 == aMode then -- VUHDO_UPDATE_AFK
				tInfo["afk"] = tIsAfk;
			end
		end
	end
end
local VUHDO_setHealth = VUHDO_setHealth;



--
local function VUHDO_setHealthSafe(aUnit, aMode)
	if UnitExists(aUnit) then VUHDO_setHealth(aUnit, aMode); end
end



-- Callback for UNIT_HEALTH / UNIT_MAXHEALTH events
local tOwner;
local tIsPet;
function VUHDO_updateHealth(aUnit, aMode)
	tIsPet = VUHDO_RAID[aUnit]["isPet"];

	if not tIsPet or VUHDO_INTERNAL_TOGGLES[26] then -- VUHDO_UPDATE_PETS  -- Enth„lt nur Pets als eigene Balken, vehicles werden ?ber owner dargestellt s.unten
		VUHDO_setHealth(aUnit, aMode);
		VUHDO_updateHealthBarsFor(aUnit, aMode);
	end

	if tIsPet then -- Vehikel?
		tOwner = VUHDO_RAID[aUnit]["ownerUnit"];
		-- tOwner may not be present when leaving a vehicle
		if VUHDO_RAID[tOwner] and VUHDO_RAID[tOwner]["isVehicle"] then
			VUHDO_setHealth(tOwner, aMode);
			VUHDO_updateHealthBarsFor(tOwner, aMode);
		end
	end

	if 1 ~= sCurrentMode -- VUHDO_MODE_NEUTRAL
		and (2 == aMode or 3 == aMode) then -- VUHDO_UPDATE_HEALTH -- VUHDO_UPDATE_HEALTH_MAX
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
local tIcon;
function VUHDO_updateAllRaidTargetIndices()
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		tIcon = GetRaidTargetIndex(tUnit);
		if tInfo["raidIcon"] ~= tIcon then
			tInfo["raidIcon"] = tIcon;
			VUHDO_updateBouquetsForEvent(tUnit, 24); -- VUHDO_UPDATE_RAID_TARGET
		end
	end
end



-- Add to groups 1-8
local function VUHDO_addUnitToGroup(aUnit, aGroupNum)
	if "player" ~= aUnit or not VUHDO_CONFIG["OMIT_SELF"] then
		if not VUHDO_CONFIG["OMIT_OWN_GROUP"] or aGroupNum ~= VUHDO_PLAYER_GROUP then
			tinsert(VUHDO_GROUPS[aGroupNum] or {}, aUnit);
		end

		if VUHDO_PLAYER_GROUP == aGroupNum then tinsert(VUHDO_GROUPS[10], aUnit); end -- VUHDO_ID_GROUP_OWN
	end
end



--
local function VUHDO_addUnitToClass(aUnit, aClassId)
	if ("player" ~= aUnit or not VUHDO_CONFIG["OMIT_SELF"]) and aClassId then
		tinsert(VUHDO_GROUPS[aClassId], aUnit);
	end
end



--
local function VUHDO_removeUnitFromRaidGroups(aUnit)
	for tModelId, tAllUnits in pairs(VUHDO_GROUPS) do
		if tModelId ~= 41 and tModelId ~= 42 and tModelId ~= 43 then  -- VUHDO_ID_MAINTANKS -- VUHDO_ID_PRIVATE_TANKS -- VUHDO_ID_MAIN_ASSISTS
			for tIndex, tUnit in pairs(tAllUnits) do
				if tUnit == aUnit then tremove(tAllUnits, tIndex); end
			end
		end
	end
end



--
local function VUHDO_removeSpecialFromAllRaidGroups()
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if VUHDO_CONFIG["OMIT_MAIN_TANKS"] and VUHDO_isModelConfigured(41) and VUHDO_isUnitInModelIterative(tUnit, 41) then -- VUHDO_ID_MAINTANKS
			VUHDO_removeUnitFromRaidGroups(tUnit); -- VUHDO_ID_MAINTANKS
		elseif VUHDO_CONFIG["OMIT_PLAYER_TARGETS"] and VUHDO_isModelConfigured(42) and VUHDO_isUnitInModelIterative(tUnit, 42) then -- VUHDO_ID_PRIVATE_TANKS
			VUHDO_removeUnitFromRaidGroups(tUnit); -- VUHDO_ID_PRIVATE_TANKS
		elseif VUHDO_CONFIG["OMIT_MAIN_ASSIST"] and VUHDO_isModelConfigured(43) and VUHDO_isUnitInModelIterative(tUnit, 43) then -- VUHDO_ID_MAIN_ASSISTS
			VUHDO_removeUnitFromRaidGroups(tUnit); -- VUHDO_ID_MAIN_ASSISTS
		end
	end
end



--
local tRole;
local function VUHDO_addUnitToSpecial(aUnit)
	if VUHDO_CONFIG["OMIT_DFT_MTS"] and "TANK" == (UnitGroupRolesAssigned(aUnit)) then
		tinsert(VUHDO_GROUPS[41], aUnit); -- VUHDO_ID_MAINTANKS
		return;
	end

	if not IsInRaid() then return; end

	_, _, _, _, _, _, _, _, _, tRole = GetRaidRosterInfo(VUHDO_RAID[aUnit]["number"]);
	if "MAINTANK" == tRole then tinsert(VUHDO_GROUPS[41], aUnit); -- VUHDO_ID_MAINTANKS
	elseif "MAINASSIST" == tRole then tinsert(VUHDO_GROUPS[43], aUnit); end -- VUHDO_ID_MAIN_ASSISTS
end



--
local function VUHDO_addUnitToCtraMainTanks()
	local tUnit;

	for tCnt = 1, 8 do -- VUHDO_MAX_MTS
		tUnit = VUHDO_MAINTANKS[tCnt];
		if tUnit then VUHDO_tableUniqueAdd(VUHDO_GROUPS[41], tUnit); end -- VUHDO_ID_MAINTANKS
	end
end



--
local function VUHDO_addUnitToPrivateTanks()
	if not VUHDO_CONFIG["OMIT_TARGET"] then tinsert(VUHDO_GROUPS[42], "target"); end -- VUHDO_ID_PRIVATE_TANKS
	if not VUHDO_CONFIG["OMIT_FOCUS"] then tinsert(VUHDO_GROUPS[42], "focus"); end -- VUHDO_ID_PRIVATE_TANKS

	local tUnit;
	for tName, _ in pairs(VUHDO_PLAYER_TARGETS) do
		tUnit = VUHDO_RAID_NAMES[tName];
		if tUnit then VUHDO_tableUniqueAdd(VUHDO_GROUPS[42], tUnit); -- VUHDO_ID_PRIVATE_TANKS
		else VUHDO_PLAYER_TARGETS[tName] = nil; end
	end
end



--
local tVehicleInfo = { ["isVehicle"] = true };
local function VUHDO_addUnitToPets(aPetUnit)
	if (VUHDO_RAID[VUHDO_RAID[aPetUnit]["ownerUnit"]] or tVehicleInfo)["isVehicle"] then return; end
	tinsert(VUHDO_GROUPS[40], aPetUnit); -- VUHDO_ID_PETS
end



--
local tRole;
local function VUHDO_addUnitToRole(aUnit)
	if "player" == aUnit and VUHDO_CONFIG["OMIT_SELF"] then return; end

	tRole = VUHDO_RAID[aUnit]["role"] or 62; -- -- VUHDO_ID_RANGED_DAMAGE

	tinsert(VUHDO_GROUPS[tRole], aUnit);
	if tRole == 63 or tRole == 62 then tinsert(VUHDO_GROUPS[51], aUnit); -- VUHDO_ID_RANGED_HEAL -- VUHDO_ID_RANGED_DAMAGE -- VUHDO_ID_RANGED
	elseif tRole == 61 or tRole == 60 then tinsert(VUHDO_GROUPS[50], aUnit); end -- VUHDO_ID_MELEE_DAMAGE -- VUHDO_ID_MELEE_TANK -- VUHDO_ID_MELEE
end



--
local function VUHDO_addUnitToVehicles(aUnit)
	if VUHDO_RAID[aUnit]["petUnit"] then tinsert(VUHDO_GROUPS[70], VUHDO_RAID[aUnit]["petUnit"]); end -- VUHDO_ID_VEHICLES
end



--
local function VUHDO_updateGroupArrays(anWasMacroRestore)
	-- Get an empty array for each group
	for tType, tTypeMembers in pairs(VUHDO_ID_TYPE_MEMBERS) do
		for _, tMember in pairs(tTypeMembers) do
			if not VUHDO_GROUPS[tMember] then VUHDO_GROUPS[tMember] = { };
			else twipe(VUHDO_GROUPS[tMember]); end
		end
	end

	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if not tInfo["isPet"] then
			if "focus" ~= tUnit and "target" ~= tUnit then
				VUHDO_addUnitToGroup(tUnit, tInfo["group"]);
				VUHDO_addUnitToClass(tUnit, tInfo["classId"]);
				VUHDO_addUnitToVehicles(tUnit);
				VUHDO_addUnitToSpecial(tUnit);
			end
		else
			VUHDO_addUnitToPets(tUnit);
		end
	end
	VUHDO_GROUPS[80][1] = "player"; -- VUHDO_ID_SELF
	VUHDO_GROUPS[81][1] = "pet"; -- VUHDO_ID_SELF_PET
	VUHDO_GROUPS[82][1] = "target"; -- VUHDO_ID_TARGET
	VUHDO_GROUPS[83][1] = "focus"; -- VUHDO_ID_FOCUS

	VUHDO_addUnitToCtraMainTanks();
	VUHDO_addUnitToPrivateTanks();

	-- Need MTs for role estimation
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if "focus" ~= tUnit and "target" ~= tUnit and not tInfo["isPet"] then
			VUHDO_addUnitToRole(tUnit);
		end
	end
	if not anWasMacroRestore then
		VUHDO_removeSpecialFromAllRaidGroups();
	end
	VUHDO_initDynamicPanelModels();
end



-- Uniquely buffer all units defined in a panel
local tPanelUnits = { };
local tHasVehicles;
local tVehicleUnit;
local function VUHDO_updateAllPanelUnits()

	VUHDO_resetRemoveFromRaidGroupsCache();

	for tPanelNum = 1, 10 do -- VUHDO_MAX_PANELS
		twipe(VUHDO_PANEL_UNITS[tPanelNum]);

		if VUHDO_PANEL_MODELS[tPanelNum] then
			tHasVehicles = VUHDO_isModelInPanel(tPanelNum, 70); -- VUHDO_ID_VEHICLES
			twipe(tPanelUnits);
			for tUnit, _ in pairs(VUHDO_RAID) do
				if VUHDO_isUnitInPanel(tPanelNum, tUnit) then tPanelUnits[tUnit] = tUnit; end

				if tHasVehicles and not VUHDO_RAID[tUnit]["isPet"] then
					tVehicleUnit = VUHDO_RAID[tUnit]["petUnit"];
					if tVehicleUnit then tPanelUnits[tVehicleUnit] = tVehicleUnit end -- e.g. "focus", "target"
				end
			end

			if VUHDO_isModelInPanel(tPanelNum, 42) then -- VUHDO_ID_PRIVATE_TANKS
				if not VUHDO_CONFIG["OMIT_TARGET"] then tPanelUnits["target"] = "target"; end
				if not VUHDO_CONFIG["OMIT_FOCUS"] then tPanelUnits["focus"] = "focus"; end
			end

			for _, tUnit in pairs(tPanelUnits) do
				tinsert(VUHDO_PANEL_UNITS[tPanelNum], tUnit);
			end
		end
	end
end



--
local function VUHDO_updateAllGuids()
	twipe(VUHDO_RAID_GUIDS);
	for tUnit, _ in pairs(VUHDO_RAID) do
		if tUnit ~= "focus" and tUnit ~= "target" then
			VUHDO_RAID_GUIDS[UnitGUID(tUnit) or 0] = tUnit;
		end
	end
end



--
local function VUHDO_convertMainTanks()
	-- Discard deprecated
	for tCnt = 1, 8 do -- VUHDO_MAX_MTS
		if not VUHDO_RAID_NAMES[VUHDO_MAINTANK_NAMES[tCnt] or "*"] then
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
local function VUHDO_createClusterUnits()
	twipe(VUHDO_CLUSTER_BASE_RAID);
	VUHDO_resetClusterCoordDeltas();

	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if not tInfo["isPet"] and "focus" ~= tUnit and "target" ~= tUnit then
			VUHDO_CLUSTER_BASE_RAID[#VUHDO_CLUSTER_BASE_RAID + 1] = tInfo;
		end
	end
end



--
-- Reload all raid members into the raid array e.g. in case of raid roster change
function VUHDO_reloadRaidMembers()
	local tPlayer;
	local tMaxMembers;
	local tUnit, tPetUnit;
	local tWasRestored = false;

	VUHDO_IS_SUSPICIOUS_ROSTER = false;

	if GetNumGroupMembers() == 0 and not UnitExists("party1") and not sIsRestoredAfterDc then
		VUHDO_IN_COMBAT_RELOG = true;
		tWasRestored = VUHDO_buildRaidFromMacro();
		VUHDO_updateAllRaidNames();
		if (tWasRestored) then
			VUHDO_normalRaidReload(true);
		end
		sIsRestoredAfterDc = true;

	elseif VUHDO_isConfigDemoUsers() then
		VUHDO_demoSetupResetUsers();
		VUHDO_reloadRaidDemoUsers();
		VUHDO_updateAllRaidNames();

	else
		VUHDO_PLAYER_RAID_ID = VUHDO_getPlayerRaidUnit();
		VUHDO_IN_COMBAT_RELOG = false;
		sIsRestoredAfterDc = true;
		tUnit, tPetUnit = VUHDO_getUnitIds();

		tMaxMembers = ("raid" == tUnit) and GetNumGroupMembers() or ("party" == tUnit) and 4 or 0;

		twipe(VUHDO_RAID);
		twipe(VUHDO_RAID_NAMES);

		for tCnt = 1, tMaxMembers do
			tPlayer = tUnit .. tCnt;
			if UnitExists(tPlayer) and tPlayer ~= VUHDO_PLAYER_RAID_ID then
				VUHDO_setHealth(tPlayer, 1); -- VUHDO_UPDATE_ALL
				VUHDO_setHealthSafe(tPetUnit .. tCnt, 1); -- VUHDO_UPDATE_ALL
			end
		end

		VUHDO_setHealthSafe("player", 1); -- VUHDO_UPDATE_ALL
		VUHDO_setHealthSafe("pet", 1); -- VUHDO_UPDATE_ALL
		VUHDO_setHealthSafe("focus", 1); -- VUHDO_UPDATE_ALL

		if VUHDO_INTERNAL_TOGGLES[27] then -- VUHDO_UPDATE_PLAYER_TARGET
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

	if sCurrentMode ~= 1 then VUHDO_sortEmergencies(); end -- VUHDO_MODE_NEUTRAL

	VUHDO_createClusterUnits();

	if VUHDO_IS_SUSPICIOUS_ROSTER then VUHDO_normalRaidReload(); end
end



--
local tPlayer;
local tMaxMembers;
local tUnitType = "foo";
local tPetUnitType;
local tInfo;
local tIsDcChange;
local tName, tRealm;
local tOldUnitType;
local tPet;
function VUHDO_refreshRaidMembers()
	VUHDO_PLAYER_RAID_ID = VUHDO_getPlayerRaidUnit();
	VUHDO_IN_COMBAT_RELOG = false;

	tOldUnitType = tUnitType;
	tUnitType, tPetUnitType = VUHDO_getUnitIds();

	tMaxMembers = ("raid" == tUnitType) and 40 or ("party" == tUnitType) and 4 or 0;

	for tCnt = 1, tMaxMembers do
		tPlayer = tUnitType .. tCnt;

		if UnitExists(tPlayer) and tPlayer ~= VUHDO_PLAYER_RAID_ID then
			tInfo = VUHDO_RAID[tPlayer];
			if not tInfo or VUHDO_RAID_GUIDS[UnitGUID(tPlayer)] ~= tPlayer then
				VUHDO_setHealth(tPlayer, 1); -- VUHDO_UPDATE_ALL
			else
				tInfo["group"] = VUHDO_getUnitGroup(tPlayer, false);
				tInfo["isVehicle"] = UnitHasVehicleUI(tPlayer);
				tInfo["afk"], tInfo["connected"], tIsDcChange = VUHDO_updateAfkDc(tPlayer);

				if tIsDcChange then
					VUHDO_updateBouquetsForEvent(tPlayer, 19); -- VUHDO_UPDATE_DC
				end
				VUHDO_setHealthSafe(tPetUnitType .. tCnt, 1); -- VUHDO_UPDATE_ALL
			end

		elseif VUHDO_RAID[tPlayer] then
			VUHDO_RAID[tPlayer]["connected"] = false;
			tPet = VUHDO_RAID[tPlayer]["petUnit"];
			if VUHDO_RAID[tPet] then
				VUHDO_RAID[tPet]["connected"] = false;
			end
		end
	end

	VUHDO_setHealthSafe("player", 1); -- VUHDO_UPDATE_ALL
	VUHDO_setHealthSafe("pet", 1); -- VUHDO_UPDATE_ALL
	VUHDO_setHealthSafe("focus", 1); -- VUHDO_UPDATE_ALL
	if VUHDO_INTERNAL_TOGGLES[27] then -- VUHDO_UPDATE_PLAYER_TARGET
		VUHDO_setHealthSafe("target", 1); -- VUHDO_UPDATE_ALL
	end

	VUHDO_PLAYER_GROUP = VUHDO_getUnitGroup(VUHDO_PLAYER_RAID_ID, false);

	VUHDO_updateAllRaidNames();
	VUHDO_trimInspected();
	VUHDO_convertMainTanks();
	VUHDO_updateGroupArrays(false);
	VUHDO_updateAllPanelUnits();
	VUHDO_updateAllGuids();
	VUHDO_updateBuffRaidGroup();
	if sCurrentMode ~= 1 then VUHDO_sortEmergencies(); end -- VUHDO_MODE_NEUTRAL
	VUHDO_createClusterUnits();
end

