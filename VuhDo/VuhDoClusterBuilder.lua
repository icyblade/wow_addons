-- for saving once learnt yards in saved variables
local VUHDO_STORED_ZONES = { };
local VUHDO_CLUSTER_BLACKLIST = { };
local VUHDO_RAID = {};

local sqrt = sqrt;
local GetPlayerMapPosition = GetPlayerMapPosition;
local CheckInteractDistance = CheckInteractDistance;
local GetMapInfo = GetMapInfo;
local GetCurrentMapDungeonLevel = GetCurrentMapDungeonLevel;
local table = table;
local format = format;
local WorldMapFrame = WorldMapFrame;
local GetMouseFocus = GetMouseFocus;
local pairs = pairs;
local GetTime = GetTime;
local GetSpellCooldown = GetSpellCooldown;
local twipe = table.wipe;
local tsort = table.sort;
local VUHDO_setMapToCurrentZone;
local _;

local VUHDO_COORD_DELTAS = { };
local VUHDO_MAP_WIDTH = 0;
local VUHDO_LAST_ZONE = nil;

local VUHDO_MIN_TICK_UNIT = 0.000000000001;
local VUHDO_MAX_TICK_UNIT = 1;
local VUHDO_MAP_LIMIT_YARDS = 1000000;
local VUHDO_MAX_SAMPLES = 50;
local VUHDO_MAX_ITERATIONS = 120; -- For a 40 man raid there is a total of +800 iterations

--
local VUHDO_CLUSTER_BASE_RAID = { };
function VUHDO_clusterBuilderInitBurst()
	VUHDO_CLUSTER_BASE_RAID = VUHDO_GLOBAL["VUHDO_CLUSTER_BASE_RAID"];
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];

	VUHDO_setMapToCurrentZone = VUHDO_GLOBAL["VUHDO_setMapToCurrentZone"];
end



--
local VUHDO_MAP_FIX_WIDTH = {
	["AlteracValley"] = {
		[1] = 4237.49987792969,
	},

	-- Cataclysm
	["BlackrockCaverns"] = {
		[1] = 1019.50793457031,
		[2] = 1019.50793457031,
	},

	["ThroneofTides"] = {
		[1] = 998.171936035156,
		[2] = 998.171936035156,
	},

	["MoltenFront"] = {
			[1] = 1189.58331298828,
	},

	["TheStonecore"] = {
		[1] = 1317.12899780273,
	},

	["HallsofOrigination"] = {
		[1] = 1531.7509765625,
		[2] = 1272.75503540039,
		[3] = 1128.76898193359,
	},

	["GrimBatol"] = {
		[1] = 869.047431945801,
	},

	["TheNexusLegendary"] = {
		[1] = 1101.2841796875,
	},

	["TheBastionofTwilight"] = {
		[1] = 1078.33402252197,
		[2] = 778.343017578125,
		[3] = 1042.34202575684,
	},

	["BlackwingDescent"] = {
		[1] = 849.69401550293,
		[2] = 999.692977905273,
	},

	["Firelands"] = {
		[1] = 1587.49993896484,
		[2] = 375.0,
		[3] = 1440.0,
	},

	["ThroneoftheFourWinds"] = {
		[1] = 1500.0,
	},

	["BaradinHold"] = {
		[1] = 585.0,
	},

	["Uldum"] = {
		[1] = 6193.74975585938,
	},

	["ZulGurub"] = {
		[1] = 2120.83325195312,
	},

	["ZulAman"] = {
		[1] = 1268.74993896484,
	},

	--[[["EndTime"] = {
			[1] = 3295.8331298829,
			[2] = 562.5,
			[3] = 865.62054443357,
			[4] = 475,316.6665039063,
			[5] = 696.884765625,
			[6] = 453.13500976562,
	},

	["WellofEternity"] = {
			[1] = 1252.0830078125,
	},

	["HourofTwilight"] = {
			[1] = 3043.7498779297,
			--[2] = 0,
	},

	["DragonSoul"] = {
			[1] = 3106.7084960938,
			[2] = 223.75,
			[3] = 1352,
			[4] = 185.19921875,
			--[5] = 1.5,
			--[6] = 1.5,
			[7] = 1108.3515625,
	},]]
};



-- Inspect, Trade, Duel, UnitInRange(, UnitIsVisible? => doesn't seem to be reliable)
local VUHDO_INTERACT_MAX_DISTANCES = { VUHDO_MIN_TICK_UNIT, VUHDO_MIN_TICK_UNIT, VUHDO_MIN_TICK_UNIT, VUHDO_MIN_TICK_UNIT };
local VUHDO_INTERACT_FAIL_MIN_DISTANCES = { VUHDO_MAX_TICK_UNIT, VUHDO_MAX_TICK_UNIT, VUHDO_MAX_TICK_UNIT, VUHDO_MAX_TICK_UNIT };
local VUHDO_INTERACT_YARDS = { 28, 11.11, 9.9, 40 };



--
local function VUHDO_clusterBuilderStoreZone(aZone)
	if (aZone ~= nil)  then
		VUHDO_STORED_ZONES[aZone] = { };
		VUHDO_STORED_ZONES[aZone]["good"] = VUHDO_deepCopyTable(VUHDO_INTERACT_MAX_DISTANCES);
		VUHDO_STORED_ZONES[aZone]["fail"] = VUHDO_deepCopyTable(VUHDO_INTERACT_FAIL_MIN_DISTANCES);
	end
end



--
local tIsValid;
local function VUHDO_isValidClusterUnit(anInfo)
	tIsValid = not anInfo["dead"]	and anInfo["connected"] and anInfo["visible"];
	VUHDO_CLUSTER_BLACKLIST[anInfo["unit"]] = not tIsValid;
	return tIsValid;
end



--
local tCnt, tDistance;
local tEmptyUnit = { };
local function VUHDO_calibrateMapScale(aUnit, aDeltaX, aDeltaY)
	tDistance = sqrt((aDeltaX * aDeltaX)  + ((aDeltaY * 0.6666666666666) ^ 2));

	for tCnt = 1, 3 do
		-- Check only if new distance is within bandwidth (= better result than before)
		if (tDistance > VUHDO_INTERACT_MAX_DISTANCES[tCnt] and tDistance < VUHDO_INTERACT_FAIL_MIN_DISTANCES[tCnt]) then
			if (CheckInteractDistance(aUnit, tCnt)) then
				VUHDO_INTERACT_MAX_DISTANCES[tCnt] = tDistance;
			else
				VUHDO_INTERACT_FAIL_MIN_DISTANCES[tCnt] = tDistance;
			end
			VUHDO_clusterBuilderStoreZone(VUHDO_LAST_ZONE);
		end
	end

	if (tDistance > VUHDO_INTERACT_MAX_DISTANCES[4] and tDistance < VUHDO_INTERACT_FAIL_MIN_DISTANCES[4]) then
		if ((VUHDO_RAID[aUnit] or tEmptyUnit)["baseRange"]) then
			VUHDO_INTERACT_MAX_DISTANCES[4] = tDistance;
		else
			VUHDO_INTERACT_FAIL_MIN_DISTANCES[4] = tDistance;
		end
		VUHDO_clusterBuilderStoreZone(VUHDO_LAST_ZONE);
	end
end



--
local tIndex, tNormFactor;
local tCurrWorldSize, tMinWorldSize, tUpperBoundary;
local function VUHDO_getHeuristicMapWidth()
	tMinWorldSize = VUHDO_MAP_LIMIT_YARDS;
	tUpperBoundary = nil;
	for tIndex, tNormFactor in pairs(VUHDO_INTERACT_YARDS) do
		tCurrWorldSize = tNormFactor / VUHDO_INTERACT_MAX_DISTANCES[tIndex]; -- yards per full tick = world size in yards

		if (tCurrWorldSize < tMinWorldSize) then -- Better test results are always smaller = closer to the limit of interact distance
			tMinWorldSize = tCurrWorldSize;
			if (VUHDO_INTERACT_FAIL_MIN_DISTANCES[tIndex] < VUHDO_MAX_TICK_UNIT) then
				tUpperBoundary = tNormFactor / VUHDO_INTERACT_FAIL_MIN_DISTANCES[tIndex];
			end
		end
	end

	return tUpperBoundary ~= nil and (tMinWorldSize + tUpperBoundary) * 0.5 or tMinWorldSize;
end



--
local tX1, tY1, tX2, tY2;
local tIsValid;
local function VUHDO_determineDistanceBetween(aUnit, anotherUnit)
	tIsValid = true;

	tX1, tY1 = GetPlayerMapPosition(aUnit);
	if (tX1 + tY1 <= 0) then
		VUHDO_CLUSTER_BLACKLIST[aUnit] = true;
		tIsValid = false;
	end

	tX2, tY2 = GetPlayerMapPosition(anotherUnit);
	if (tX2 + tY2 <= 0) then
		VUHDO_CLUSTER_BLACKLIST[anotherUnit] = true;
		tIsValid = false;
	end

	if (not tIsValid) then
		return nil, nil;
	end

	return tX1 - tX2, tY1 - tY2;
end



--
local function VUHDO_clusterBuilderNewZone(anOldZone, aNewZone)
	VUHDO_clusterBuilderStoreZone(anOldZone);

	if (VUHDO_STORED_ZONES[aNewZone] ~= nil) then
		VUHDO_INTERACT_MAX_DISTANCES = VUHDO_deepCopyTable(VUHDO_STORED_ZONES[aNewZone]["good"]);
		VUHDO_INTERACT_FAIL_MIN_DISTANCES = VUHDO_deepCopyTable(VUHDO_STORED_ZONES[aNewZone]["fail"]);
	else
		VUHDO_INTERACT_MAX_DISTANCES[1] = VUHDO_MIN_TICK_UNIT;
		VUHDO_INTERACT_MAX_DISTANCES[2] = VUHDO_MIN_TICK_UNIT;
		VUHDO_INTERACT_MAX_DISTANCES[3] = VUHDO_MIN_TICK_UNIT;
		VUHDO_INTERACT_MAX_DISTANCES[4] = VUHDO_MIN_TICK_UNIT;
		VUHDO_INTERACT_FAIL_MIN_DISTANCES[1] = VUHDO_MAX_TICK_UNIT;
		VUHDO_INTERACT_FAIL_MIN_DISTANCES[2] = VUHDO_MAX_TICK_UNIT;
		VUHDO_INTERACT_FAIL_MIN_DISTANCES[3] = VUHDO_MAX_TICK_UNIT;
		VUHDO_INTERACT_FAIL_MIN_DISTANCES[4] = VUHDO_MAX_TICK_UNIT;
	end
end



--
local tUnit, tInfo, tCnt;
local tAnotherUnit, tAnotherInfo;
local tX, tY, tDeltaX, tDeltaY, tDeltas;
local tMaxX, tMaxY;
local tMapFileName, tDungeonLevels, tCurrLevel;
local tCurrentZone;
local tNumRaid;
local tIndex = 0;
local tNumSamples, tNumIterations;
local VuhDoDummyStub = {
	["IsShown"] = function() return false; end,
	["GetName"] = function() return ""; end
};

function VUHDO_updateAllClusters()
	if (((WorldMapFrame or VuhDoDummyStub()):IsShown())
		or ((GetMouseFocus() or VuhDoDummyStub):GetName() == nil)) then -- @UGLY Carbonite workaround
		return;
	end

	tX, tY = GetPlayerMapPosition("player");
	if ((tX or 0) + (tY or 0) <= 0) then
		VUHDO_setMapToCurrentZone();
	end

	tMapFileName = (GetMapInfo()) or "*";
	tCurrLevel = GetCurrentMapDungeonLevel() or 0;
	tCurrentZone = format("%s%d", tMapFileName, tCurrLevel);

	if (VUHDO_LAST_ZONE ~= tCurrentZone) then
		VUHDO_clusterBuilderNewZone(VUHDO_LAST_ZONE, tCurrentZone);
		VUHDO_LAST_ZONE = tCurrentZone;
	end

	tNumSamples, tNumIterations = 0, 0;
	tNumRaid = #VUHDO_CLUSTER_BASE_RAID;

	while (true) do
		tIndex = tIndex + 1;
		if (tIndex > tNumRaid) then
			tIndex = 0;
			break;
		end

		tInfo = VUHDO_CLUSTER_BASE_RAID[tIndex];
		if (tInfo == nil) then
			break;
		end

		tUnit = tInfo["unit"];

		if (VUHDO_COORD_DELTAS[tUnit] == nil) then
			VUHDO_COORD_DELTAS[tUnit] = { };
		end

		if (VUHDO_isValidClusterUnit(tInfo)) then
			for tCnt = tIndex + 1, tNumRaid do
				tAnotherInfo = VUHDO_CLUSTER_BASE_RAID[tCnt];
				if (tAnotherInfo == nil) then
					break;
				end
				tAnotherUnit = tAnotherInfo["unit"];

				if (VUHDO_isValidClusterUnit(tAnotherInfo)) then
					tDeltaX, tDeltaY = VUHDO_determineDistanceBetween(tUnit, tAnotherUnit);

					if (tDeltaX ~= nil) then
						if (VUHDO_COORD_DELTAS[tUnit][tAnotherUnit] == nil) then
							VUHDO_COORD_DELTAS[tUnit][tAnotherUnit] = { };
						end

						VUHDO_COORD_DELTAS[tUnit][tAnotherUnit][1] = tDeltaX;
						VUHDO_COORD_DELTAS[tUnit][tAnotherUnit][2] = tDeltaY;

						-- and the other way round to reduce iterations
						if (VUHDO_COORD_DELTAS[tAnotherUnit] == nil) then
							VUHDO_COORD_DELTAS[tAnotherUnit] = { };
						end
						if (VUHDO_COORD_DELTAS[tAnotherUnit][tUnit] == nil) then
							VUHDO_COORD_DELTAS[tAnotherUnit][tUnit] = { };
						end
						VUHDO_COORD_DELTAS[tAnotherUnit][tUnit][1] = tDeltaX;
						VUHDO_COORD_DELTAS[tAnotherUnit][tUnit][2] = tDeltaY;

						tNumSamples = tNumSamples + 1;
						if (tNumSamples > 50) then -- VUHDO_MAX_SAMPLES
							break;
						end
					end
				end
				tNumIterations = tNumIterations + 1;
				if (tNumIterations > 120) then -- VUHDO_MAX_ITERATIONS
					break;
				end
			end -- for
		else -- Blacklist updaten
			for tCnt = tIndex + 1, tNumRaid do
				tAnotherInfo = VUHDO_CLUSTER_BASE_RAID[tCnt];
				if (tAnotherInfo == nil) then
					break;
				end
				VUHDO_isValidClusterUnit(tAnotherInfo);
			end
		end

		if (tNumSamples > 50 or tNumIterations > 120) then -- VUHDO_MAX_SAMPLES -- VUHDO_MAX_ITERATIONS
			break;
		end
	end

	tMaxX = nil;

	-- Try to determine well known dungeons
	tDungeonLevels = VUHDO_MAP_FIX_WIDTH[tMapFileName];
	if (tDungeonLevels ~= nil) then
		tMaxX = tDungeonLevels[tCurrLevel];
	end

	-- Otherwise get from heuristic database
	if ((tMaxX or 0) == 0) then
		if (VUHDO_COORD_DELTAS["player"] ~= nil) then
			for tUnit, tDeltas in pairs(VUHDO_COORD_DELTAS["player"]) do
				VUHDO_calibrateMapScale(tUnit, tDeltas[1], tDeltas[2]);
			end
		end

		tMaxX = VUHDO_getHeuristicMapWidth();

		-- Unreasonable?
		if (tMaxX < 1 or tMaxX >= VUHDO_MAP_LIMIT_YARDS) then
			VUHDO_MAP_WIDTH = 0;
			return;
		end
	end

--	if (VUHDO_MAP_WIDTH ~= tMaxX) then
--		VUHDO_Msg("Map approx yards changed from " .. floor(VUHDO_MAP_WIDTH * 10) / 10 .. " to " .. floor(tMaxX * 10) / 10);
--	end

	VUHDO_MAP_WIDTH = tMaxX;
end



--
function VUHDO_resetClusterCoordDeltas()
	twipe(VUHDO_COORD_DELTAS);
end



--
local function VUHDO_sortClusterComparator(aUnit, anotherUnit)
	return VUHDO_RAID[aUnit]["healthmax"] - VUHDO_RAID[aUnit]["health"]
		> VUHDO_RAID[anotherUnit]["healthmax"] - VUHDO_RAID[anotherUnit]["health"];
end



--
local tDeltas, tDistance, tNumber, tOtherUnit, tInfo;
local tStart, tDuration;
function VUHDO_getUnitsInRadialClusterWith(aUnit, aYards, anArray, aCdSpell)
	twipe(anArray);

	if (aCdSpell) then
		tStart, tDuration = GetSpellCooldown(aCdSpell);
		tDuration = tDuration or 0;

		if (tDuration > 1.5) then -- Don't remove clusters for gcd
			tStart = tStart or 0;
			if (tStart + tDuration > GetTime()) then
				return anArray;
			end
		end
	end

	tInfo = VUHDO_RAID[aUnit];
	if (tInfo ~= nil and not VUHDO_CLUSTER_BLACKLIST[aUnit]) then
		anArray[1] = aUnit;-- Source is always part of the cluster
	end
	if (VUHDO_MAP_WIDTH == 0 or VUHDO_COORD_DELTAS[aUnit] == nil) then
		return anArray;
	end

	for tOtherUnit, tDeltas in pairs(VUHDO_COORD_DELTAS[aUnit]) do
		tDistance = (((tDeltas[1] or 0) * VUHDO_MAP_WIDTH) ^ 2)  + (((tDeltas[2] or 0) * VUHDO_MAP_WIDTH / 1.5) ^ 2);
		if (tDistance <= aYards and not VUHDO_CLUSTER_BLACKLIST[tOtherUnit]) then
			anArray[#anArray + 1] = tOtherUnit;
		end
	end

	tsort(anArray, VUHDO_sortClusterComparator);
	return anArray;
end
local VUHDO_getUnitsInRadialClusterWith = VUHDO_getUnitsInRadialClusterWith;



--
local tUnit, tWinnerUnit, tInfo, tWinnerMissLife;
local tCurrMissLife;
local function VUHDO_getMostDeficitUnitOutOf(anIncludeList, anExcludeList)
	tWinnerUnit = nil;
	tWinnerMissLife = -1;

	for _, tUnit in pairs(anIncludeList) do
		if (not anExcludeList[tUnit]) then
			tInfo = VUHDO_RAID[tUnit];
			if (tInfo ~= nil and tInfo["healthmax"] - tInfo["health"] > tWinnerMissLife) then
				tWinnerUnit = tUnit;
				tWinnerMissLife = tInfo["healthmax"] - tInfo["health"];
			end
		end
	end
	return tWinnerUnit;
end



--
local tNextJumps = { };
local tExcludeList = { };
local tNumJumps = 0;
local tCnt;
function VUHDO_getUnitsInChainClusterWith(aUnit, aYards, anArray, aMaxTargets, aCdSpell)
	twipe(anArray);
	twipe(tExcludeList)
	for tCnt = 1, aMaxTargets do
		anArray[tCnt] = aUnit;
		tExcludeList[aUnit] = true;
		VUHDO_getUnitsInRadialClusterWith(aUnit, aYards, tNextJumps, aCdSpell);
		aUnit = VUHDO_getMostDeficitUnitOutOf(tNextJumps, tExcludeList);
		if (aUnit == nil) then
			break;
		end
	end
	return anArray;
end



--
local tDeltas, tDistance;
function VUHDO_getDistanceBetween(aUnit, anotherUnit)
	if (VUHDO_CLUSTER_BLACKLIST[aUnit] or VUHDO_CLUSTER_BLACKLIST[anotherUnit]) then
		return nil;
	end

	if (VUHDO_COORD_DELTAS[aUnit] ~= nil and VUHDO_COORD_DELTAS[aUnit][anotherUnit] ~= nil) then
		tDeltas = VUHDO_COORD_DELTAS[aUnit][anotherUnit];
		return sqrt((((tDeltas[1] or 0) * VUHDO_MAP_WIDTH) ^ 2)  + (((tDeltas[2] or 0) * VUHDO_MAP_WIDTH / 1.5) ^ 2));
	end

	return nil;
end
