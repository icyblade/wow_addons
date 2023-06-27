--
local UnitBuff = UnitBuff;
local UnitPower = UnitPower;
--local GetPrimaryTalentTree = GetPrimaryTalentTree;
--local GetTalentInfo = GetTalentInfo;
--local GetSpellBonusHealing = GetSpellBonusHealing;
local UnitGetIncomingHeals = UnitGetIncomingHeals;
local pairs = pairs;
local ipairs = ipairs;
local floor = floor;
local twipe = table.wipe;
local select = select;
local _ = _;

local sIsIncoming;
local sIsCooldown;
local sIsIncCastTimeOnly;
local sIsPerGroup;

local VUHDO_AOE_FOR_UNIT = { };

local VUHDO_getCustomDestCluster;
local VUHDO_RAID;
function VUHDO_aoeAdvisorInitBurst()
	VUHDO_getCustomDestCluster = VUHDO_GLOBAL["VUHDO_getCustomDestCluster"];
	sIsIncoming = VUHDO_CONFIG["AOE_ADVISOR"]["subInc"];
	sIsCooldown = VUHDO_CONFIG["AOE_ADVISOR"]["isCooldown"];
	sIsIncCastTimeOnly = VUHDO_CONFIG["AOE_ADVISOR"]["subIncOnlyCastTime"];
	sIsPerGroup = VUHDO_CONFIG["AOE_ADVISOR"]["isGroupWise"];

	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];
end



local VUHDO_SPELL_ID_COH = 34861;
local VUHDO_SPELL_ID_POH = 596;
local VUHDO_SPELL_ID_CH = 1064;
local VUHDO_SPELL_ID_WG = 48438;
local VUHDO_SPELL_ID_TQ = 740;
local VUHDO_SPELL_ID_EF = 81275;
local VUHDO_SPELL_ID_SM = 18562;
local VUHDO_SPELL_ID_LOD = 85222;
local VUHDO_SPELL_ID_HR = 82327;

VUHDO_AOE_SPELLS = {

	-- Circle of Healing
	["coh"] = {
		["present"] = false,
		["id"] = VUHDO_SPELL_ID_COH,
		["base"] = (2309 + 2551) * 0.5,
		["divisor"] = 9345,
		["icon"] = (GetSpellTexture(VUHDO_SPELL_ID_COH)),
		["name"] = (GetSpellInfo(VUHDO_SPELL_ID_COH)),
		["avg"] = 0,
		["max_targets"] = 5,
		["degress"] = 1,
		["rangePow"] = 30 * 30,
		["isRadial"] = true,
		["isSourcePlayer"] = false,
		["isDestRaid"] = true,
		["thresh"] = 15000,
		["cone"] = 360,
		["checkCd"] = true,
		["time"] = select(7, GetSpellInfo(VUHDO_SPELL_ID_COH)) or 0,
	},

	-- Prayer of Healing
	["poh"] = {
		["present"] = false,
		["id"] = VUHDO_SPELL_ID_POH,
		["base"] = (3087 + 3261) * 0.5,
		["divisor"] = 9345,
		["icon"] = (GetSpellTexture(VUHDO_SPELL_ID_POH)),
		["name"] = (GetSpellInfo(VUHDO_SPELL_ID_POH)),
		["avg"] = 0,
		["max_targets"] = 5,
		["degress"] = 1,
		["rangePow"] = 30 * 30,
		["isRadial"] = true,
		["isSourcePlayer"] = false,
		["isDestRaid"] = false,
		["thresh"] = 20000,
		["cone"] = 360,
		["checkCd"] = false,
		["time"] = select(7, GetSpellInfo(VUHDO_SPELL_ID_POH)) or 0,
	},

	-- Chain Heal
	["ch"] = {
		["present"] = false,
		["id"] = VUHDO_SPELL_ID_CH,
		["base"] = (3282 + 3748) * 0.5,
		["divisor"] = 10035,
		["icon"] = (GetSpellTexture(VUHDO_SPELL_ID_CH)),
		["name"] = (GetSpellInfo(VUHDO_SPELL_ID_CH)),
		["avg"] = 0,
		["max_targets"] = 4,
		["degress"] = 0.8,
		["rangePow"] = 40 * 40,
		["isRadial"] = false,
		["isSourcePlayer"] = false,
		["isDestRaid"] = true,
		["thresh"] = 15000,
		["cone"] = 360,
		["checkCd"] = false,
		["time"] = select(7, GetSpellInfo(VUHDO_SPELL_ID_CH)) or 0,
	},

	-- Wild Growth
	["wg"] = {
		["present"] = false,
		["id"] = VUHDO_SPELL_ID_WG,
		["base"] = 3717,
		["divisor"] = 9345,
		["icon"] = (GetSpellTexture(VUHDO_SPELL_ID_WG)),
		["name"] = (GetSpellInfo(VUHDO_SPELL_ID_WG)),
		["avg"] = 0,
		["max_targets"] = 5,
		["degress"] = 1,
		["rangePow"] = 30 * 30,
		["isRadial"] = true,
		["isSourcePlayer"] = false,
		["isDestRaid"] = true,
		["thresh"] = 15000,
		["cone"] = 360,
		["checkCd"] = true,
		["time"] = select(7, GetSpellInfo(VUHDO_SPELL_ID_WG)) or 0,
	},

	-- Tranqulity
	["tq"] = {
		["present"] = false,
		["id"] = VUHDO_SPELL_ID_TQ,
		["base"] = 3882,
		["divisor"] = 9345,
		["icon"] = (GetSpellTexture(VUHDO_SPELL_ID_TQ)),
		["name"] = (GetSpellInfo(VUHDO_SPELL_ID_TQ)),
		["avg"] = 0,
		["max_targets"] = 5,
		["degress"] = 1,
		["rangePow"] = 40 * 40,
		["isRadial"] = true,
		["isSourcePlayer"] = true,
		["isDestRaid"] = true,
		["thresh"] = 15000,
		["cone"] = 360,
		["checkCd"] = true,
		["time"] = select(7, GetSpellInfo(VUHDO_SPELL_ID_TQ)) or 0,
	},

	-- Efflorescence
	["ef"] = {
		["present"] = false,
		["id"] = VUHDO_SPELL_ID_EF,
		["base"] = 5229,
 		["divisor"] = 9345,
		["icon"] = (GetSpellTexture(VUHDO_SPELL_ID_EF)),
		["name"] = (GetSpellInfo(VUHDO_SPELL_ID_EF)),
		["avg"] = 0,
		["max_targets"] = 3,
		["degress"] = 1,
		["rangePow"] = 8 * 8,
		["isRadial"] = true,
		["isSourcePlayer"] = false,
		["isDestRaid"] = true,
		["thresh"] = 5000,
		["cone"] = 360,
		["checkCd"] = true,
		["evaluator"] = VUHDO_isUnitSwiftmendable,
		["time"] = select(7, GetSpellInfo(VUHDO_SPELL_ID_SM)) or 0,
	},

	-- Light of Dawn
	["lod"] = {
		["present"] = false,
		["id"] = VUHDO_SPELL_ID_LOD,
		["base"] = (606 + 674) * 3 * 0.5,
		["divisor"] = 4859,
		["icon"] = (GetSpellTexture(VUHDO_SPELL_ID_LOD)),
		["name"] = (GetSpellInfo(VUHDO_SPELL_ID_LOD)),
		["avg"] = 0,
		["max_targets"] = 5,
		["degress"] = 1,
		["rangePow"] = 30 * 30,
		["isRadial"] = true,
		["isSourcePlayer"] = true,
		["isDestRaid"] = true,
		["thresh"] = 8000,
		["cone"] = 180,
		["checkCd"] = false,
		["time"] = select(7, GetSpellInfo(VUHDO_SPELL_ID_LOD)) or 0,
	},

	-- Holy Radiance
	["hr"] = {
		["present"] = false,
		["id"] = VUHDO_SPELL_ID_HR,
		["base"] = (683 + 683) * 0.5,
		["divisor"] = 4859,
		["icon"] = (GetSpellTexture(VUHDO_SPELL_ID_HR)),
		["name"] = (GetSpellInfo(VUHDO_SPELL_ID_HR)),
		["avg"] = 0,
		["max_targets"] = 40,
		["degress"] = 1,
		["rangePow"] = 10 * 10,
		["isRadial"] = true,
		["isSourcePlayer"] = true,
		["isDestRaid"] = true,
		["thresh"] = 10000,
		["cone"] = 360,
		["checkCd"] = false,
		["time"] = select(7, GetSpellInfo(VUHDO_SPELL_ID_HR)) or 0,
	},
};
local VUHDO_AOE_SPELLS = VUHDO_AOE_SPELLS;



--
local tAltPower;
local function VUHDO_getPlayerHealingMod()
	if ("PRIEST" == VUHDO_PLAYER_CLASS) then
		return 1 + (0.15 * (UnitBuff("player", VUHDO_SPELL_ID.CHAKRA_SANCTUARY) and 1 or 0));
	elseif ("DRUID" == VUHDO_PLAYER_CLASS) then
		return 1 + (0.15 * (UnitBuff("player", VUHDO_SPELL_ID.TREE_OF_LIFE) and 1 or 0));
	elseif ("PALADIN" == VUHDO_PLAYER_CLASS) then
		tAltPower = UnitPower("player", 9);
		if ((tAltPower or 4) ~= 4) then
			return 1 / (4 - tAltPower);
		end
	end

	return 1;
end



--
local function VUHDO_getTalentModifiers()
	if ("PRIEST" == VUHDO_PLAYER_CLASS) then
		local tSpiriutalHealing = GetPrimaryTalentTree() == 2 and 1 or 0; -- Holy
		local _, _, _, _, tTwinDisciplines = GetTalentInfo(1, 2);
		return 1 + tSpiriutalHealing * 0.15 + (tTwinDisciplines * 0.02) * (1 + tSpiriutalHealing * 0.15);
	elseif ("SHAMAN" == VUHDO_PLAYER_CLASS) then
		local tPurification = GetPrimaryTalentTree() == 3 and 1 or 0;
		local _, _, _, _, tSparcOfLife = GetTalentInfo(3, 3);
		return 1 + tPurification * 0.25 + (tSparcOfLife * 0.02) * (1 + tPurification * 0.25);
	elseif ("DRUID" == VUHDO_PLAYER_CLASS) then
		local tGiftOfTheNature = GetPrimaryTalentTree == 3 and 1 or 0;
		return 1 + tGiftOfTheNature * 0.25;
	elseif ("PALADIN" == VUHDO_PLAYER_CLASS) then
		local tWalkInTheLight = GetPrimaryTalentTree() == 1 and 1 or 0;
		local _, _, _, _, tDivinity = GetTalentInfo(2, 1);
		return 1 + tWalkInTheLight * 0.1  + (tDivinity * 0.02) * (1 + tWalkInTheLight * 0.1);
	end

	return 1;
end



--
local tPoints;
local function VUHDO_getSpellTalentModifiers(anAoeInfo)
	if ("DRUID" == VUHDO_PLAYER_CLASS) then
		if (VUHDO_SPELL_ID_EF == anAoeInfo["id"]) then
			_, _, _, _, tPoints = GetTalentInfo(3, 15);
			return anAoeInfo["avg"] * 0.04 * tPoints;
		end
	end

	return 1;
end



--
function VUHDO_aoeUpdateSpellAverages()
	local tName, tInfo;
	local tTalentModi = VUHDO_getTalentModifiers();
	local tBonus = GetSpellBonusHealing();
	local tSpellModi;

	for tName, tInfo in pairs(VUHDO_AOE_SPELLS) do
		tSpellModi = tInfo["base"] / tInfo["divisor"];
		tInfo["avg"] = floor((tInfo["base"] + tBonus * tSpellModi) * tTalentModi + 0.5);
		tInfo["avg"] = tInfo["avg"] * VUHDO_getSpellTalentModifiers(tInfo);
		tInfo["thresh"] = VUHDO_CONFIG["AOE_ADVISOR"]["config"][tName]["thresh"];
	end
end



--
local function VUHDO_isAoeSpellEnabled(aSpell)
	if (not VUHDO_CONFIG["AOE_ADVISOR"]["config"][aSpell]["enable"]) then
		return false;
	end

	if (not VUHDO_CONFIG["AOE_ADVISOR"]["knownOnly"]) then
		return true;
	end

	return VUHDO_isSpellKnown(VUHDO_AOE_SPELLS[aSpell]["name"]);
end



--
function VUHDO_aoeUpdateTalents()
	local tName, tInfo;
	local tSpell;

	for tName, tInfo in pairs(VUHDO_AOE_SPELLS) do
		tInfo["present"] = VUHDO_isAoeSpellEnabled(tName);
	end

	if ("PRIEST" == VUHDO_PLAYER_CLASS) then
		if (VUHDO_isGlyphed(55675)) then -- Glyph of CoH
			VUHDO_AOE_SPELLS["coh"]["max_targets"] = 6;
		else
			VUHDO_AOE_SPELLS["coh"]["max_targets"] = 5;
		end

	elseif ("SHAMAN" == VUHDO_PLAYER_CLASS) then
		tSpell = VUHDO_AOE_SPELLS["ch"];
		if (VUHDO_isGlyphed(55437)) then -- Glyph of CH
			tSpell["degress"] = 0.85;
			tSpell["base"] = (3282 + 3748) * 0.5 * 0.92;
		else
			tSpell["degress"] = 0.7;
			tSpell["base"] = (3282 + 3748) * 0.5;
		end
	elseif ("DRUID" == VUHDO_PLAYER_CLASS) then
		if (VUHDO_isGlyphed(62970)) then -- Glyph of WG
			VUHDO_AOE_SPELLS["wg"]["max_targets"] = 6;
		else
			VUHDO_AOE_SPELLS["wg"]["max_targets"] = 5;
		end
	elseif ("PALADIN" == VUHDO_PLAYER_CLASS) then
		if (VUHDO_isGlyphed(54940)) then -- Glyph of LoD
			VUHDO_AOE_SPELLS["lod"]["max_targets"] = 6;
		else
			VUHDO_AOE_SPELLS["lod"]["max_targets"] = 5;
		end
	end

	VUHDO_aoeUpdateSpellAverages();
end



--
local function VUHDO_aoeGetIncHeals(aUnit, aCastTime)
	if (not sIsIncoming or (sIsIncCastTimeOnly and aCastTime == 0)) then
		return 0;
	end

	return (UnitGetIncomingHeals(aUnit) or 0) - (UnitGetIncomingHeals(aUnit, "player") or 0);
end



--
local tTotal;
local tDeficit;
local tCnt;
local tUnit;
local tInfo;
local function VUHDO_sumClusterHealing(aCluster, aMaxAmount, aDegression, aCastTime)
	tTotal = 0;

	for tCnt = 1, #aCluster do
		tUnit = aCluster[tCnt];
		tInfo = VUHDO_RAID[tUnit];
		tDeficit = tInfo["healthmax"] - tInfo["health"] - VUHDO_aoeGetIncHeals(tUnit, aCastTime);

		if (tInfo["healthmax"] > 0) then
			if (tDeficit > aMaxAmount) then
				tTotal = tTotal + aMaxAmount + (1 - tInfo["health"] / tInfo["healthmax"]); -- To avoid hopping
			elseif (tDeficit > 0) then
				tTotal = tTotal + tDeficit;
			end
		end

		aMaxAmount = aMaxAmount * aDegression;
	end

	return tTotal;
end



--
local tBestUnit, tBestTotal;
local tCurrTotal;
local tCluster = { };
local tInfo;
local tCnt;

local tEvaluator;
local tIsSourcePlayer;
local tIsDestRaid;
local tIsRadial;
local tRangePow;
local tMaxTargets;
local tCdSpell;
local tCone;
local tSpellHeal;
local tTime;
local tDegress;
local tThresh;



local function VUHDO_getBestUnitForAoeGroup(anAoeInfo, aPlayerModi, aGroup)
	tBestUnit = nil;
	tBestTotal = -1;

	for tCnt = 1, #aGroup do
		tInfo = aGroup[tCnt];
		if (VUHDO_RAID[tInfo] ~= nil) then
			tInfo = VUHDO_RAID[tInfo];
		end

		if (tInfo["baseRange"] and (tEvaluator == nil or tEvaluator(tInfo["unit"]))) then

			VUHDO_getCustomDestCluster(tInfo["unit"], tCluster,
				tIsSourcePlayer, tIsRadial, tRangePow,
				tMaxTargets, 101, tIsDestRaid, -- 101% = no health limit
				tCdSpell,	tCone
			);

			if (#tCluster > 1) then
				tCurrTotal = VUHDO_sumClusterHealing(tCluster, tSpellHeal, tDegress, tTime);

				if (tCurrTotal > tBestTotal and tCurrTotal >= tThresh) then
					tBestTotal = tCurrTotal;
					tBestUnit = tInfo["unit"];
				end
			end

		end
	end

	return tBestUnit, tBestTotal;
end



--
local tSingleUnit = {
	[0] = { }
};

local tGroupUnit = {
	[1] = { }, [2] = { }, [3] = { }, [4] = { }, [5] = { }, [6] = { }, [7] = { }, [8] = { }
};

local tCnt;
local function VUHDO_getBestUnitsForAoe(anAoeInfo, aPlayerModi)
	tEvaluator = anAoeInfo["evaluator"];
	tIsSourcePlayer = anAoeInfo["isSourcePlayer"];
	tIsDestRaid = anAoeInfo["isDestRaid"];
	tIsRadial = anAoeInfo["isRadial"];
	tRangePow = anAoeInfo["rangePow"];
	tMaxTargets = anAoeInfo["max_targets"];
	tCdSpell = sIsCooldown and anAoeInfo["checkCd"] and anAoeInfo["name"] or nil;
	tCone = anAoeInfo["cone"];
	tSpellHeal = anAoeInfo["avg"] * aPlayerModi;
	tTime = anAoeInfo["time"];
	tDegress = anAoeInfo["degress"];
	tThresh = anAoeInfo["thresh"];
	--tThresh = 1000;

	if (sIsPerGroup and not tIsDestRaid) then
		for tCnt = 1, 8 do
			tGroupUnit[tCnt]["u"], tGroupUnit[tCnt]["h"] = VUHDO_getBestUnitForAoeGroup(anAoeInfo, aPlayerModi, VUHDO_GROUPS[tCnt]);
		end
		return tGroupUnit;
	else
		tSingleUnit[0]["u"], tSingleUnit[0]["h"] = VUHDO_getBestUnitForAoeGroup(anAoeInfo, aPlayerModi, VUHDO_CLUSTER_BASE_RAID);
		return tSingleUnit;
	end
end



--
local tUnitForAoe = { [0] = {}, [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {}, [6] = {}, [7] = {}, [8] = {} };
local tCnt;
local tUnit;
local function VUHDO_abgleichVorherBesserInGruppen(anAoeName, aGroupNum, aUnit, anAoeHealed, ...)
	for tCnt = 1, select('#', ...) do
		if ((tUnitForAoe[select(tCnt, ...)][aUnit] or 0) >= anAoeHealed) then
			return;
		end
	end

	tUnitForAoe[aGroupNum][aUnit] = anAoeHealed;
	VUHDO_AOE_FOR_UNIT[aUnit] = VUHDO_AOE_SPELLS[anAoeName];
end



--
local tName, tInfo;
local tUnit;
local tWarBesser;
local tPlayerModi, tWasBetterBefore;
local tBestUnits;
local tCnt;
local tOldAoeForUnit = {};
local tAoeChangedForUnit = { };
local tAoeSpell;
function VUHDO_aoeUpdateAll()
	if (not VUHDO_INTERNAL_TOGGLES[32]) then -- VUHDO_UPDATE_AOE_ADVICE
		return;
	end

	tPlayerModi = VUHDO_getPlayerHealingMod();

	for tCnt = 0, 8 do
		twipe(tUnitForAoe[tCnt]);
	end

	twipe(tOldAoeForUnit);
	for tUnit, tAoeSpell in pairs(VUHDO_AOE_FOR_UNIT) do
		tOldAoeForUnit[tUnit] = tAoeSpell;
	end
	twipe(VUHDO_AOE_FOR_UNIT);

	for tName, tInfo in pairs(VUHDO_AOE_SPELLS) do
		if (tInfo["present"]) then
			tBestUnits = VUHDO_getBestUnitsForAoe(tInfo, tPlayerModi);

			for tIndex, tUnitInfo in pairs(tBestUnits) do

				tUnit = tUnitInfo["u"];
				if (tUnit ~= nil) then
					if (0 == tIndex) then -- Raidweit => Besser vorher in irgendeiner Gruppen oder Raid?
						VUHDO_abgleichVorherBesserInGruppen(tName, tIndex, tUnit, tUnitInfo["h"], 0, 1, 2, 3, 4, 5, 6, 7, 8);
					else -- je Gruppe => Besser vorher in eigener Gruppe oder Raid?
						VUHDO_abgleichVorherBesserInGruppen(tName, tIndex, tUnit, tUnitInfo["h"], 0, tIndex);
					end
				end

			end
		end
	end

	twipe(tAoeChangedForUnit);
	for tUnit, tAoeSpell in pairs(tOldAoeForUnit) do
		if (VUHDO_AOE_FOR_UNIT[tUnit] ~= tAoeSpell) then
			tAoeChangedForUnit[tUnit] = true;
		end
	end
	for tUnit, tAoeSpell in pairs(VUHDO_AOE_FOR_UNIT) do
		if (tOldAoeForUnit[tUnit] ~= tAoeSpell) then
			tAoeChangedForUnit[tUnit] = true;
		end
	end

	for tUnit, _ in pairs(tAoeChangedForUnit) do
		VUHDO_updateBouquetsForEvent(tUnit, VUHDO_UPDATE_AOE_ADVICE);
	end
end



--
function VUHDO_getAoeAdviceForUnit(aUnit)
	return VUHDO_AOE_FOR_UNIT[aUnit];
end
