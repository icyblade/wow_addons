VUHDO_MANUAL_ROLES = { };
local VUHDO_FIX_ROLES = { };
local VUHDO_INSPECTED_ROLES = { };
local VUHDO_DF_TOOL_ROLES = { };
local VUHDO_INSPECT_TIMEOUT = 5;

--local tPoints1, tPoints2, tPoints3, tRank;
VUHDO_NEXT_INSPECT_UNIT = nil;
VUHDO_NEXT_INSPECT_TIME_OUT = nil;


--------------------------------------------------------------
local twipe = table.wipe;
local CheckInteractDistance = CheckInteractDistance;
local UnitIsUnit = UnitIsUnit;
local NotifyInspect = NotifyInspect;
local GetActiveSpecGroup = GetActiveSpecGroup;
local GetSpecializationInfo = GetSpecializationInfo;
local ClearInspectPlayer = ClearInspectPlayer;
local UnitBuff = UnitBuff;
local UnitStat = UnitStat;
local UnitDefense = UnitDefense;
local UnitGroupRolesAssigned = UnitGroupRolesAssigned;
local UnitLevel = UnitLevel;
local UnitPowerType = UnitPowerType;
local VUHDO_isUnitInModel;
local pairs = pairs;
local _;

local VUHDO_MANUAL_ROLES;
local VUHDO_RAID_NAMES;
local VUHDO_RAID;

function VUHDO_roleCheckerInitLocalOverrides()
	VUHDO_MANUAL_ROLES = _G["VUHDO_MANUAL_ROLES"];
	VUHDO_RAID_NAMES = _G["VUHDO_RAID_NAMES"];
	VUHDO_RAID = _G["VUHDO_RAID"];
	VUHDO_isUnitInModel = _G["VUHDO_isUnitInModel"];
end
--------------------------------------------------------------



-- Reset if spec changed or slash command
function VUHDO_resetTalentScan(aUnit)
	if VUHDO_PLAYER_RAID_ID == aUnit then aUnit = "player"; end

	local tInfo = VUHDO_RAID[aUnit];
	if tInfo then
		VUHDO_INSPECTED_ROLES[tInfo["name"]] = nil;
		VUHDO_FIX_ROLES[tInfo["name"]] = nil;
		VUHDO_DF_TOOL_ROLES[tInfo["name"]] = nil;
	end
end



--
function VUHDO_trimInspected()
	for tName, _ in pairs(VUHDO_INSPECTED_ROLES) do
		if not VUHDO_RAID_NAMES[tName] then
			VUHDO_INSPECTED_ROLES[tName] = nil;
			VUHDO_FIX_ROLES[tName] = nil;
		end
	end
end



-- If timeout after talent tree server request
function VUHDO_setRoleUndefined(aUnit)
	local tInfo = VUHDO_RAID[aUnit];
	if tInfo then	VUHDO_INSPECTED_ROLES[tInfo["name"]] = nil;	end
end



local VUHDO_CLASS_ROLES = {
	[VUHDO_ID_ROGUES] = VUHDO_ID_MELEE_DAMAGE,
	[VUHDO_ID_HUNTERS] = VUHDO_ID_RANGED_DAMAGE,
	[VUHDO_ID_MAGES] = VUHDO_ID_RANGED_DAMAGE,
	[VUHDO_ID_WARLOCKS] = VUHDO_ID_RANGED_DAMAGE,
};



--
local tInfo;
local tName;
local function VUHDO_shouldBeInspected(aUnit)
	if "focus" == aUnit or "target" == aUnit then return false; end

	tInfo = VUHDO_RAID[aUnit];
	if tInfo["isPet"] or not tInfo["connected"] then return false; end

	-- Determined by role or can't tell by talent trees (dk)?
	if VUHDO_CLASS_ROLES[tInfo["classId"]] then -- VUHDO_ID_DEATH_KNIGHT, hat zwar keine feste Rolle, Talentbäume bringen aber auch nichts
		return false;
	end

	-- Already inspected or manually overridden?
	-- or assigned tank or heal via dungeon finder? (in case of DPS inspect anyway)
	tName = tInfo["name"];
	if VUHDO_INSPECTED_ROLES[tName] or VUHDO_MANUAL_ROLES[tName]
		or VUHDO_DF_TOOL_ROLES[tName] == 60 or VUHDO_DF_TOOL_ROLES[tName] == 63 then -- VUHDO_ID_MELEE_TANK -- VUHDO_ID_RANGED_HEAL
		return false;
	end

	-- In inspect range?
	return CheckInteractDistance(aUnit, 1);
end



--
function VUHDO_tryInspectNext()
	for tUnit, _ in pairs(VUHDO_RAID) do
		if VUHDO_shouldBeInspected(tUnit) then
			VUHDO_NEXT_INSPECT_TIME_OUT = GetTime() + VUHDO_INSPECT_TIMEOUT;
			VUHDO_NEXT_INSPECT_UNIT = tUnit;

			if "player" == tUnit then VUHDO_inspectLockRole();
			else NotifyInspect(tUnit); end

			return;
		end
	end
end



--
local tActiveTree;
local tIsInspect;
local tInfo;
local tClassId;
local tRole;
local tTreeId;
function VUHDO_inspectLockRole()
	tInfo = VUHDO_RAID[VUHDO_NEXT_INSPECT_UNIT];

	if not tInfo then	VUHDO_NEXT_INSPECT_UNIT = nil; return; end

	if "player" == VUHDO_NEXT_INSPECT_UNIT then
		tActiveTree = GetSpecialization();

		if not tActiveTree then
			VUHDO_INSPECTED_ROLES[tInfo["name"]] = VUHDO_ID_UNDEFINED;
			VUHDO_NEXT_INSPECT_UNIT = nil;
			return;
		end
		tTreeId, _, _, _, _, tRole = GetSpecializationInfo(tActiveTree, false, false);

	else
		tTreeId = GetInspectSpecialization(VUHDO_NEXT_INSPECT_UNIT);
		tRole = GetSpecializationRoleByID(tTreeId);
	end

	if (tTreeId or 0) == 0 then
		ClearInspectPlayer();
		VUHDO_NEXT_INSPECT_UNIT = nil;
		VUHDO_INSPECTED_ROLES[tInfo["name"]] = VUHDO_ID_UNDEFINED;
		return;
	end

	--VUHDO_xMsg(VUHDO_NEXT_INSPECT_UNIT, tTreeId);

	if "HEALER" == tRole then
		VUHDO_INSPECTED_ROLES[tInfo["name"]] = VUHDO_ID_RANGED_HEAL;

	elseif "TANK" == tRole then
		VUHDO_INSPECTED_ROLES[tInfo["name"]] = VUHDO_ID_MELEE_TANK;

	elseif "DAMAGER" == tRole then
		tClassId = tInfo["classId"];
		if VUHDO_ID_WARRIORS == tClassId
			or VUHDO_ID_ROGUES == tClassId
			or VUHDO_ID_PALADINS == tClassId
			or VUHDO_ID_MONKS == tClassId
			or VUHDO_ID_DEATH_KNIGHT == tClassId then

			VUHDO_INSPECTED_ROLES[tInfo["name"]] = VUHDO_ID_MELEE_DAMAGE;

		elseif VUHDO_ID_SHAMANS == tClassId then
			if 263 == tTreeId then
				VUHDO_INSPECTED_ROLES[tInfo["name"]] = VUHDO_ID_MELEE_DAMAGE;
			else -- 2
				VUHDO_INSPECTED_ROLES[tInfo["name"]] = VUHDO_ID_RANGED_DAMAGE;
			end

		elseif VUHDO_ID_DRUIDS == tClassId then
			if 103 == tTreeId then -- Feral
				VUHDO_INSPECTED_ROLES[tInfo["name"]] = VUHDO_ID_MELEE_DAMAGE;
			else -- 2
				VUHDO_INSPECTED_ROLES[tInfo["name"]] = VUHDO_ID_RANGED_DAMAGE;
			end

		else
			VUHDO_INSPECTED_ROLES[tInfo["name"]] = VUHDO_ID_RANGED_DAMAGE;
		end
	else
		VUHDO_INSPECTED_ROLES[tInfo["name"]] = VUHDO_ID_UNDEFINED;
	end

	ClearInspectPlayer();
	VUHDO_NEXT_INSPECT_UNIT = nil;
	VUHDO_normalRaidReload();
end



--
local tDfRole, tOldRole, tReturnRole, tName;
local function VUHDO_determineDfToolRole(anInfo)
	tName = anInfo["name"];
	tOldRole = VUHDO_DF_TOOL_ROLES[tName];
	tDfRole = UnitGroupRolesAssigned(anInfo["unit"]);

	if "NONE" == tDfRole then
		VUHDO_DF_TOOL_ROLES[tName] = nil;
		tReturnRole = nil;
	elseif "TANK" == tDfRole then
		VUHDO_DF_TOOL_ROLES[tName] = 60; -- VUHDO_ID_MELEE_TANK
		tReturnRole = 60; -- VUHDO_ID_MELEE_TANK
	elseif "HEALER" == tDfRole then
		VUHDO_DF_TOOL_ROLES[tName] = 63; -- VUHDO_ID_RANGED_HEAL
		tReturnRole = 63; -- VUHDO_ID_RANGED_HEAL
	elseif "DAMAGER" == tDfRole then

		if anInfo["classId"] == VUHDO_ID_WARRIORS
		or anInfo["classId"] == VUHDO_ID_PALADINS
		or anInfo["classId"] == VUHDO_ID_DEATH_KNIGHT
		or anInfo["classId"] == VUHDO_ID_MONKS then
			VUHDO_DF_TOOL_ROLES[tName] = VUHDO_ID_MELEE_DAMAGE;
			tReturnRole = VUHDO_ID_MELEE_DAMAGE;
		elseif anInfo["classId"] == VUHDO_ID_PRIESTS then
			VUHDO_DF_TOOL_ROLES[tName] = VUHDO_ID_RANGED_DAMAGE;
			tReturnRole = VUHDO_ID_RANGED_DAMAGE;
		else -- Shaman/Druid
			VUHDO_DF_TOOL_ROLES[tName] = VUHDO_ID_MELEE_DAMAGE;
			tReturnRole = nil;
		end

	end

	if tOldRole ~= VUHDO_DF_TOOL_ROLES[tName] then
		VUHDO_normalRaidReload();
	end

	return tReturnRole;
end



--
local tName;
local tInfo;
local tDefense;
local tPowerType;
local tBuffExist;
local tFixRole;
local tIntellect, tStrength, tAgility;
local tClassId, tClassRole, tName;
local tLevel;
function VUHDO_determineRole(aUnit)
	tInfo = VUHDO_RAID[aUnit];
	if not tInfo or tInfo["isPet"] then	return nil; end

	-- Role determined by non-hybrid class?
	tClassId = tInfo["classId"];
	tClassRole = VUHDO_CLASS_ROLES[tClassId];
	if tClassRole then
		return tClassRole;
	end

	tName = tInfo["name"];
	-- Manual role override oder dungeon finder role?
	tFixRole = VUHDO_MANUAL_ROLES[tName] or VUHDO_determineDfToolRole(tInfo);
	if tFixRole then
		return tFixRole;
	end

	-- Assigned for MT?
	if VUHDO_isUnitInModel(aUnit, 41) then -- VUHDO_ID_MAINTANKS
		return 60; -- VUHDO_ID_MELEE_TANK
	end

	-- Talent tree inspected?
	if (VUHDO_INSPECTED_ROLES[tName] or VUHDO_ID_UNDEFINED) ~= VUHDO_ID_UNDEFINED then
		return VUHDO_INSPECTED_ROLES[tName];
	end
	-- Estimated role fixed?
	if VUHDO_FIX_ROLES[tName] then
		return VUHDO_FIX_ROLES[tName];
	end

	if 29 == tClassId then -- VUHDO_ID_DEATH_KNIGHT
		_, _, tBuffExist = UnitBuff(aUnit, VUHDO_SPELL_ID.BUFF_BLOOD_PRESENCE);
		if tBuffExist then
			--VUHDO_FIX_ROLES[tName] = 60; -- VUHDO_ID_MELEE_TANK
			return 60; -- VUHDO_ID_MELEE_TANK
		else
			VUHDO_FIX_ROLES[tName] = 61; -- VUHDO_ID_MELEE_DAMAGE
			return 61; -- VUHDO_ID_MELEE_DAMAGE
		end

	elseif 28 == tClassId then -- VUHDO_ID_PRIESTS
		_, _, tBuffExist = UnitBuff(aUnit, VUHDO_SPELL_ID.SHADOWFORM);
		if (tBuffExist) then
			VUHDO_FIX_ROLES[tName] = 62; -- VUHDO_ID_RANGED_DAMAGE
			return 62; -- VUHDO_ID_RANGED_DAMAGE
		else
			return 63; -- VUHDO_ID_RANGED_HEAL
		end

	elseif 20 == tClassId then -- VUHDO_ID_WARRIORS
		_, tDefense = UnitDefense(aUnit);
		tDefense = tDefense / UnitLevel(aUnit);

		if (tDefense > 2 or VUHDO_isUnitInModel(aUnit, VUHDO_ID_MAINTANKS)) then
			return 60; -- VUHDO_ID_MELEE_TANK
		else
			return 61; -- VUHDO_ID_MELEE_DAMAGE
		end

	elseif 27 == tClassId then -- VUHDO_ID_DRUIDS
		tPowerType = UnitPowerType(aUnit);
		if VUHDO_UNIT_POWER_MANA == tPowerType then
			_, _, tBuffExist = UnitBuff(aUnit, VUHDO_SPELL_ID.MOONKIN_FORM);
			if tBuffExist then
				VUHDO_FIX_ROLES[tName] = 62; -- VUHDO_ID_RANGED_DAMAGE
				return 62; -- VUHDO_ID_RANGED_DAMAGE
			else
				return 63; -- VUHDO_ID_RANGED_HEAL
			end
		elseif VUHDO_UNIT_POWER_RAGE == tPowerType then
			VUHDO_FIX_ROLES[tName] = 60; -- VUHDO_ID_MELEE_TANK
			return 60; -- VUHDO_ID_MELEE_TANK
		elseif VUHDO_UNIT_POWER_ENERGY == tPowerType then
			VUHDO_FIX_ROLES[tName] = 61; -- VUHDO_ID_MELEE_DAMAGE
			return 61; -- VUHDO_ID_MELEE_DAMAGE
		end

	elseif 23 == tClassId then -- VUHDO_ID_PALADINS
		_, tDefense = UnitDefense(aUnit);
		tLevel = UnitLevel(aUnit) or 0;
		if tLevel <= 0 then
			return nil;
		end

		tDefense = tDefense / tLevel;

		if tDefense > 2 then
			return 60; -- VUHDO_ID_MELEE_TANK
		else
			tIntellect = UnitStat(aUnit, 4);
			tStrength = UnitStat(aUnit, 1);

			if tIntellect > tStrength then
				return 63; -- VUHDO_ID_RANGED_HEAL
			else
				return 61; -- VUHDO_ID_MELEE_DAMAGE
			end
		end

	elseif 26 == tClassId then -- VUHDO_ID_SHAMANS
		tIntellect = UnitStat(aUnit, 4);
		tAgility = UnitStat(aUnit, 2);

		if tAgility > tIntellect then
			return 61; -- VUHDO_ID_MELEE_DAMAGE
		else
			if VUHDO_DF_TOOL_ROLES[tName] == 61 then -- VUHDO_ID_MELEE_DAMAGE
				return 62; -- VUHDO_ID_RANGED_DAMAGE
			else
				return 63; -- Can't tell, assume its a healer -- VUHDO_ID_RANGED_HEAL
			end
		end
	end

	return nil;
end

