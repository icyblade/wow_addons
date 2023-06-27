VUHDO_MANUAL_ROLES = { };
local VUHDO_FIX_ROLES = { };
local VUHDO_INSPECTED_ROLES = { };
local VUHDO_DF_TOOL_ROLES = { };
local VUHDO_INSPECT_TIMEOUT = 5;

local tPoints1, tPoints2, tPoints3, tRank;
VUHDO_NEXT_INSPECT_UNIT = nil;
VUHDO_NEXT_INSPECT_TIME_OUT = nil;


--------------------------------------------------------------
local twipe = table.wipe;
local CheckInteractDistance = CheckInteractDistance;
local UnitIsUnit = UnitIsUnit;
local NotifyInspect = NotifyInspect;
local GetActiveTalentGroup = GetActiveTalentGroup;
local GetTalentTabInfo = GetTalentTabInfo;
local ClearInspectPlayer = ClearInspectPlayer;
local UnitBuff = UnitBuff;
local UnitStat = UnitStat;
local UnitDefense = UnitDefense;
local UnitGroupRolesAssigned = UnitGroupRolesAssigned;
local UnitLevel = UnitLevel;
local UnitPowerType = UnitPowerType;
local VUHDO_isUnitInModel;
local pairs = pairs;
local _ = _;

local VUHDO_MANUAL_ROLES;
local VUHDO_RAID_NAMES;
local VUHDO_RAID;

function VUHDO_roleCheckerInitBurst()
	VUHDO_MANUAL_ROLES = VUHDO_GLOBAL["VUHDO_MANUAL_ROLES"];
	VUHDO_RAID_NAMES = VUHDO_GLOBAL["VUHDO_RAID_NAMES"];
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];
	VUHDO_isUnitInModel = VUHDO_GLOBAL["VUHDO_isUnitInModel"];
end
--------------------------------------------------------------



-- Reset if spec changed or slash command
function VUHDO_resetTalentScan(aUnit)
	if (VUHDO_PLAYER_RAID_ID == aUnit) then
		aUnit = "player";
	end

	local tInfo = VUHDO_RAID[aUnit];
	if (tInfo ~= nil) then
		VUHDO_INSPECTED_ROLES[tInfo["name"]] = nil;
		VUHDO_FIX_ROLES[tInfo["name"]] = nil;
		VUHDO_DF_TOOL_ROLES[tInfo["name"]] = nil;
	end
end



--
function VUHDO_trimInspected()
	local tName;

	for tName, _ in pairs(VUHDO_INSPECTED_ROLES) do
		if (VUHDO_RAID_NAMES[tName] == nil) then
			VUHDO_INSPECTED_ROLES[tName] = nil;
			VUHDO_FIX_ROLES[tName] = nil;
		end
	end
end



-- If timeout after talent tree server request
function VUHDO_setRoleUndefined(aUnit)
	local tInfo = VUHDO_RAID[aUnit];
	if (tInfo ~= nil) then
		VUHDO_INSPECTED_ROLES[tInfo["name"]] = nil;
	end
end



local VUHDO_CLASS_ROLES = {
	[VUHDO_ID_ROGUES] = VUHDO_ID_MELEE_DAMAGE,
	[VUHDO_ID_HUNTERS] = VUHDO_ID_RANGED_DAMAGE,
	[VUHDO_ID_MAGES] = VUHDO_ID_RANGED_DAMAGE,
	[VUHDO_ID_WARLOCKS] = VUHDO_ID_RANGED_DAMAGE,
};



--
local tInfo;
local tClass, tName;
local function VUHDO_shouldBeInspected(aUnit)
	if ("focus" == aUnit or "target" == aUnit) then
		return false;
	end

	tInfo = VUHDO_RAID[aUnit];
	if (tInfo["isPet"] or not tInfo["connected"]) then
		return false;
	end
	-- Determined by role or can't tell by talent trees (dk)?
	tClass = tInfo["classId"];
	if (VUHDO_CLASS_ROLES[tClass] ~= nil) then -- VUHDO_ID_DEATH_KNIGHT, hat zwar keine feste Rolle, Talentbäume bringen aber auch nichts
		return false;
	end

	-- Already inspected or manually overridden?
	-- or assigned tank or heal via dungeon finder? (in case of DPS inspect anyway)
	tName = tInfo["name"];
	if (VUHDO_INSPECTED_ROLES[tName] ~= nil or VUHDO_MANUAL_ROLES[tName] ~= nil
		or VUHDO_DF_TOOL_ROLES[tName] == 60 or VUHDO_DF_TOOL_ROLES[tName] == 63) then -- VUHDO_ID_MELEE_TANK -- VUHDO_ID_RANGED_HEAL
		return false;
	end

	-- In inspect range?
	return CheckInteractDistance(aUnit, 1);
end



--
local tUnit;
function VUHDO_tryInspectNext()
	for tUnit, _ in pairs(VUHDO_RAID) do
		if (VUHDO_shouldBeInspected(tUnit)) then
			VUHDO_NEXT_INSPECT_TIME_OUT = GetTime() + VUHDO_INSPECT_TIMEOUT;
			VUHDO_NEXT_INSPECT_UNIT = tUnit;
			if ("player" == tUnit) then
				VUHDO_inspectLockRole();
			else
				NotifyInspect(tUnit);
			end

			return;
		end
	end
end



--
local tActiveTree;
local tIsInspect;
local tInfo;
local tClassId;
function VUHDO_inspectLockRole()
	tInfo = VUHDO_RAID[VUHDO_NEXT_INSPECT_UNIT];

	if (tInfo == nil) then
		VUHDO_NEXT_INSPECT_UNIT = nil;
		return;
	end

	tIsInspect = "player" ~= VUHDO_NEXT_INSPECT_UNIT;

	tActiveTree = GetActiveTalentGroup(tIsInspect);
	_, _, _, _, tPoints1 = GetTalentTabInfo(1, tIsInspect, false, tActiveTree);
	_, _, _, _, tPoints2 = GetTalentTabInfo(2, tIsInspect, false, tActiveTree);
	_, _, _, _, tPoints3 = GetTalentTabInfo(3, tIsInspect, false, tActiveTree);

	tClassId = tInfo["classId"];

	if (VUHDO_ID_PRIESTS == tClassId) then
		-- 1 = Disc, 2 = Holy, 3 = Shadow
		if (tPoints1 > tPoints3	or tPoints2 > tPoints3)	 then
			VUHDO_INSPECTED_ROLES[tInfo["name"]] = 63; -- VUHDO_ID_RANGED_HEAL
		else
			VUHDO_INSPECTED_ROLES[tInfo["name"]] = 62; -- VUHDO_ID_RANGED_DAMAGE
		end

	elseif (VUHDO_ID_WARRIORS == tClassId) then
		-- 1 = Waffen, 2 = Furor, 3 = Schutz
		if (tPoints1 > tPoints3	or tPoints2 > tPoints3)	 then
			VUHDO_INSPECTED_ROLES[tInfo["name"]] = 61; -- VUHDO_ID_MELEE_DAMAGE
		else
			VUHDO_INSPECTED_ROLES[tInfo["name"]] = 60; -- VUHDO_ID_MELEE_TANK
		end

	elseif (VUHDO_ID_DRUIDS == tClassId) then
		-- 1 = Gleichgewicht, 2 = Wilder Kampf, 3 = Wiederherstellung
		if (tPoints1 > tPoints2 and tPoints1 > tPoints3) then
			VUHDO_INSPECTED_ROLES[tInfo["name"]] = 62; -- VUHDO_ID_RANGED_DAMAGE
		elseif(tPoints3 > tPoints2) then
			VUHDO_INSPECTED_ROLES[tInfo["name"]] = 63; -- VUHDO_ID_RANGED_HEAL
		else
			-- "Natürliche Reaktion" geskillt => Wahrsch. Tank?
			_, _, _, _, tRank, _, _, _ = GetTalentInfo(2, 18, tIsInspect, false, tActiveTree);
			if (tRank > 0) then
				VUHDO_INSPECTED_ROLES[tInfo["name"]] = 60; -- VUHDO_ID_MELEE_TANK
			else
				VUHDO_INSPECTED_ROLES[tInfo["name"]] = 61; -- VUHDO_ID_MELEE_DAMAGE
			end
		end

	elseif (VUHDO_ID_PALADINS == tClassId) then
		-- 1 = Heilig, 2 = Schutz, 3 = Vergeltung
		if (tPoints1 > tPoints2 and tPoints1 > tPoints3) then
			VUHDO_INSPECTED_ROLES[tInfo["name"]] = 63; -- VUHDO_ID_RANGED_HEAL
		elseif (tPoints2 > tPoints3) then
			VUHDO_INSPECTED_ROLES[tInfo["name"]] = 60; -- VUHDO_ID_MELEE_TANK
		else
			VUHDO_INSPECTED_ROLES[tInfo["name"]] = 61; -- VUHDO_ID_MELEE_DAMAGE
		end

	elseif (VUHDO_ID_SHAMANS == tClassId) then
		-- 1 = Elementar, 2 = Verstärker, 3 = Wiederherstellung
		if (tPoints1 > tPoints2 and tPoints1 > tPoints3) then
			VUHDO_INSPECTED_ROLES[tInfo["name"]] = 62; -- VUHDO_ID_RANGED_DAMAGE
		elseif (tPoints2 > tPoints3) then
			VUHDO_INSPECTED_ROLES[tInfo["name"]] = 61; -- VUHDO_ID_MELEE_DAMAGE
		else
			VUHDO_INSPECTED_ROLES[tInfo["name"]] = 63; -- VUHDO_ID_RANGED_HEAL
		end
	elseif (VUHDO_ID_DEATH_KNIGHT == tClassId) then
		-- 1 = Blut, 2 = Frost, 3 = Unheilig
		if (tPoints1 > tPoints2 and tPoints1 > tPoints3) then
			VUHDO_INSPECTED_ROLES[tInfo["name"]] = 60; -- VUHDO_ID_MELEE_TANK
		else
			VUHDO_INSPECTED_ROLES[tInfo["name"]] = 61; -- VUHDO_ID_MELEE_DAMAGE
		end
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

	if ("NONE" == tDfRole) then
		VUHDO_DF_TOOL_ROLES[tName] = nil;
		tReturnRole = nil;
	elseif("TANK" == tDfRole) then
		VUHDO_DF_TOOL_ROLES[tName] = 60; -- VUHDO_ID_MELEE_TANK
		tReturnRole = 60; -- VUHDO_ID_MELEE_TANK
	elseif("HEALER" == tDfRole) then
		VUHDO_DF_TOOL_ROLES[tName] = 63; -- VUHDO_ID_RANGED_HEAL
		tReturnRole = 63; -- VUHDO_ID_RANGED_HEAL
	elseif("DAMAGER" == tDfRole) then

		if (anInfo["classId"] == VUHDO_ID_WARRIORS
		or anInfo["classId"] == VUHDO_ID_PALADINS
		or anInfo["classId"] == VUHDO_ID_DEATH_KNIGHT) then
			VUHDO_DF_TOOL_ROLES[tName] = VUHDO_ID_MELEE_DAMAGE;
			tReturnRole = VUHDO_ID_MELEE_DAMAGE;
		elseif (anInfo["classId"] == VUHDO_ID_PRIESTS) then
			VUHDO_DF_TOOL_ROLES[tName] = VUHDO_ID_RANGED_DAMAGE;
			tReturnRole = VUHDO_ID_RANGED_DAMAGE;
		else -- Shaman/Druid
			VUHDO_DF_TOOL_ROLES[tName] = VUHDO_ID_MELEE_DAMAGE;
			tReturnRole = nil;
		end

	end

	if (tOldRole ~= VUHDO_DF_TOOL_ROLES[tName]) then
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
function VUHDO_determineRole(aUnit)
	tInfo = VUHDO_RAID[aUnit];

	if (tInfo == nil or tInfo["isPet"]) then
		return nil;
	end

	-- Role determined by non-hybrid class?
	tClassId = tInfo["classId"];
	tClassRole = VUHDO_CLASS_ROLES[tClassId];
	if (tClassRole ~= nil) then
		return tClassRole;
	end

	tName = tInfo["name"];
	-- Manual role override oder dungeon finder role?
	tFixRole = VUHDO_MANUAL_ROLES[tName] or VUHDO_determineDfToolRole(tInfo);
	if (tFixRole ~= nil) then
		return tFixRole;
	end
	-- Assigned for MT?
	if (VUHDO_isUnitInModel(aUnit, 41)) then -- VUHDO_ID_MAINTANKS
		return 60; -- VUHDO_ID_MELEE_TANK
	end
	-- Talent tree inspected?
	if (VUHDO_INSPECTED_ROLES[tName] ~= nil) then
		return VUHDO_INSPECTED_ROLES[tName];
	end
	-- Estimated role fixed?
	if (VUHDO_FIX_ROLES[tName] ~= nil) then
		return VUHDO_FIX_ROLES[tName];
	end

	if (29 == tClassId) then -- VUHDO_ID_DEATH_KNIGHT
		_, _, tBuffExist = UnitBuff(aUnit, VUHDO_SPELL_ID.BUFF_FROST_PRESENCE);
		if (tBuffExist) then
			--VUHDO_FIX_ROLES[tName] = 60; -- VUHDO_ID_MELEE_TANK
			return 60; -- VUHDO_ID_MELEE_TANK
		else
			VUHDO_FIX_ROLES[tName] = 61; -- VUHDO_ID_MELEE_DAMAGE
			return 61; -- VUHDO_ID_MELEE_DAMAGE
		end

	elseif (28 == tClassId) then -- VUHDO_ID_PRIESTS
		_, _, tBuffExist = UnitBuff(aUnit, VUHDO_SPELL_ID.SHADOWFORM);
		if (tBuffExist) then
			VUHDO_FIX_ROLES[tName] = 62; -- VUHDO_ID_RANGED_DAMAGE
			return 62; -- VUHDO_ID_RANGED_DAMAGE
		else
			return 63; -- VUHDO_ID_RANGED_HEAL
		end

	elseif (20 == tClassId) then -- VUHDO_ID_WARRIORS
		_, tDefense = UnitDefense(aUnit);
		tDefense = tDefense / UnitLevel(aUnit);

		if (tDefense > 2 or VUHDO_isUnitInModel(aUnit, VUHDO_ID_MAINTANKS)) then
			return 60; -- VUHDO_ID_MELEE_TANK
		else
			return 61; -- VUHDO_ID_MELEE_DAMAGE
		end

	elseif (27 == tClassId) then -- VUHDO_ID_DRUIDS
		tPowerType = UnitPowerType(aUnit);
		if (VUHDO_UNIT_POWER_MANA == tPowerType) then
			_, _, tBuffExist = UnitBuff(aUnit, VUHDO_SPELL_ID.MOONKIN_FORM);
			if (tBuffExist) then
				VUHDO_FIX_ROLES[tName] = 62; -- VUHDO_ID_RANGED_DAMAGE
				return 62; -- VUHDO_ID_RANGED_DAMAGE
			else
				_, _, tBuffExist = UnitBuff(aUnit, VUHDO_SPELL_ID.TREE_OF_LIFE);
				if (tBuffExist) then
					VUHDO_FIX_ROLES[tName] = 63; -- VUHDO_ID_RANGED_HEAL
				end

				return 63; -- VUHDO_ID_RANGED_HEAL
			end
		elseif (VUHDO_UNIT_POWER_RAGE == tPowerType) then
			VUHDO_FIX_ROLES[tName] = 60; -- VUHDO_ID_MELEE_TANK
			return 60; -- VUHDO_ID_MELEE_TANK
		elseif (VUHDO_UNIT_POWER_ENERGY == tPowerType) then
			VUHDO_FIX_ROLES[tName] = 61; -- VUHDO_ID_MELEE_DAMAGE
			return 61; -- VUHDO_ID_MELEE_DAMAGE
		end

	elseif (23 == tClassId) then -- VUHDO_ID_PALADINS
		_, tDefense = UnitDefense(aUnit);
		tDefense = tDefense / UnitLevel(aUnit);

		if (tDefense > 2) then
			return 60; -- VUHDO_ID_MELEE_TANK
		else
			tIntellect = UnitStat(aUnit, 4);
			tStrength = UnitStat(aUnit, 1);

			if (tIntellect > tStrength) then
				return 63; -- VUHDO_ID_RANGED_HEAL
			else
				return 61; -- VUHDO_ID_MELEE_DAMAGE
			end
		end

	elseif (26 == tClassId) then -- VUHDO_ID_SHAMANS
		tIntellect = UnitStat(aUnit, 4);
		tAgility = UnitStat(aUnit, 2);

		if (tAgility > tIntellect) then
			return 61; -- VUHDO_ID_MELEE_DAMAGE
		else
			if (VUHDO_DF_TOOL_ROLES[tName] == 61) then -- VUHDO_ID_MELEE_DAMAGE
				return 62; -- VUHDO_ID_RANGED_DAMAGE
			else
				return 63; -- Can't tell, assume its a healer -- VUHDO_ID_RANGED_HEAL
			end
		end
	end

	return nil;
end

