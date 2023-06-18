VUHDO_BOUQUET_CUSTOM_TYPE_PERCENT = 1;
VUHDO_BOUQUET_CUSTOM_TYPE_PLAYERS = 2;
VUHDO_BOUQUET_CUSTOM_TYPE_STATUSBAR = 3;
VUHDO_BOUQUET_CUSTOM_TYPE_BRIGHTNESS = 4;
VUHDO_BOUQUET_CUSTOM_TYPE_HEALTH = 5;
VUHDO_BOUQUET_CUSTOM_TYPE_HOLY_POWER = 6;
VUHDO_BOUQUET_CUSTOM_TYPE_SECONDS = 7;
VUHDO_BOUQUET_CUSTOM_TYPE_STACKS = 8;

VUHDO_FORCE_RESET = false;

local floor = floor;
local select = select;
local twipe = table.wipe;
local GetRaidTargetIndex = GetRaidTargetIndex;
local UnitPower = UnitPower;
local UnitPowerMax = UnitPowerMax;
local UnitIsFriend = UnitIsFriend;
local UnitIsEnemy = UnitIsEnemy;
local UnitIsDeadOrGhost = UnitIsDeadOrGhost;
local UnitIsPlayer = UnitIsPlayer;
local UnitIsTapped = UnitIsTapped;
local UnitIsTappedByPlayer = UnitIsTappedByPlayer;
local GetTexCoordsForRole = GetTexCoordsForRole;
local UnitIsPVP = UnitIsPVP;
local UnitFactionGroup = UnitFactionGroup;
local UnitHasIncomingResurrection = UnitHasIncomingResurrection;
local _;

local VUHDO_RAID = { };
local VUHDO_USER_CLASS_COLORS;
local VUHDO_PANEL_SETUP;

local VUHDO_getOtherPlayersHotInfo;
local VUHDO_getChosenDebuffInfo;
local VUHDO_getCurrentPlayerTarget;
local VUHDO_getCurrentPlayerFocus;
local VUHDO_getCurrentMouseOver;
local VUHDO_getDistanceBetween;
local VUHDO_isUnitSwiftmendable;
local VUHDO_getNumInUnitCluster;
local VUHDO_getIsInHiglightCluster;
local VUHDO_getDebuffColor;
local VUHDO_getIsCurrentBouquetActive;
local VUHDO_getCurrentBouquetColor;
local VUHDO_getIncHealOnUnit;
local VUHDO_getUnitDebuffSchoolInfos;
local VUHDO_getCurrentBouquetStacks;
local VUHDO_getCurrentPlayerFocus;
local VUHDO_getAoeAdviceForUnit;
local VUHDO_getCurrentBouquetTimer;
local VUHDO_getRaidTargetIconTexture;
local VUHDO_shouldDisplayArrow;
local VUHDO_getUnitDirection;
local VUHDO_getCellForDirection;
local VUHDO_getRedGreenForDistance;
local VUHDO_getTexCoordsForCell;
local VUHDO_getUnitGroupPrivileges;
local VUHDO_getLatestCustomDebuff;

local sIsInverted;
local sBarColors;
local sIsDistance;

----------------------------------------------------------



function VUHDO_bouquetValidatorsInitLocalOverrides()
	VUHDO_RAID = _G["VUHDO_RAID"];
	VUHDO_USER_CLASS_COLORS = _G["VUHDO_USER_CLASS_COLORS"];
	VUHDO_PANEL_SETUP = _G["VUHDO_PANEL_SETUP"];

	VUHDO_getOtherPlayersHotInfo = _G["VUHDO_getOtherPlayersHotInfo"];
	VUHDO_getChosenDebuffInfo = _G["VUHDO_getChosenDebuffInfo"];
	VUHDO_getCurrentPlayerTarget = _G["VUHDO_getCurrentPlayerTarget"];
	VUHDO_getCurrentPlayerFocus = _G["VUHDO_getCurrentPlayerFocus"];
	VUHDO_getCurrentMouseOver = _G["VUHDO_getCurrentMouseOver"];
	VUHDO_getDistanceBetween = _G["VUHDO_getDistanceBetween"];
	VUHDO_isUnitSwiftmendable = _G["VUHDO_isUnitSwiftmendable"];
	VUHDO_getNumInUnitCluster = _G["VUHDO_getNumInUnitCluster"];
	VUHDO_getIsInHiglightCluster = _G["VUHDO_getIsInHiglightCluster"];
	VUHDO_getDebuffColor = _G["VUHDO_getDebuffColor"];
	VUHDO_getCurrentBouquetColor = _G["VUHDO_getCurrentBouquetColor"];
	VUHDO_getIncHealOnUnit = _G["VUHDO_getIncHealOnUnit"];
	VUHDO_getUnitDebuffSchoolInfos = _G["VUHDO_getUnitDebuffSchoolInfos"];
	VUHDO_getCurrentBouquetStacks = _G["VUHDO_getCurrentBouquetStacks"];
	VUHDO_getCurrentPlayerFocus = _G["VUHDO_getCurrentPlayerFocus"];
	VUHDO_getIsCurrentBouquetActive = _G["VUHDO_getIsCurrentBouquetActive"];
	VUHDO_getAoeAdviceForUnit = _G["VUHDO_getAoeAdviceForUnit"];
	VUHDO_getCurrentBouquetTimer = _G["VUHDO_getCurrentBouquetTimer"];
	VUHDO_getRaidTargetIconTexture = _G["VUHDO_getRaidTargetIconTexture"];
	VUHDO_shouldDisplayArrow = _G["VUHDO_shouldDisplayArrow"];
	VUHDO_getUnitDirection = _G["VUHDO_getUnitDirection"];
	VUHDO_getCellForDirection = _G["VUHDO_getCellForDirection"];
	VUHDO_getRedGreenForDistance = _G["VUHDO_getRedGreenForDistance"];
	VUHDO_getTexCoordsForCell = _G["VUHDO_getTexCoordsForCell"];
	VUHDO_getUnitGroupPrivileges = _G["VUHDO_getUnitGroupPrivileges"];
	VUHDO_getLatestCustomDebuff = _G["VUHDO_getLatestCustomDebuff"];

	sIsInverted = VUHDO_INDICATOR_CONFIG["CUSTOM"]["HEALTH_BAR"]["invertGrowth"];
	sBarColors = VUHDO_PANEL_SETUP["BAR_COLORS"];
	sIsDistance = VUHDO_CONFIG["DIRECTION"]["isDistanceText"];
end

local tEmptyInfo = { };
local tEmptyColor = { };

----------------------------------------------------------



local VUHDO_CHARGE_COLORS = {
	"HOT_CHARGE_1",
	"HOT_CHARGE_2",
	"HOT_CHARGE_3",
	"HOT_CHARGE_4",
};



--
local tCopy = { };
local function VUHDO_copyColor(aColor)
	if not aColor then return tEmptyColor; end
	tCopy["R"], tCopy["G"], tCopy["B"], tCopy["O"] = aColor["R"], aColor["G"], aColor["B"], aColor["O"];
	tCopy["TR"], tCopy["TG"], tCopy["TB"], tCopy["TO"] = aColor["TR"], aColor["TG"], aColor["TB"], aColor["TO"];
	tCopy["useBackground"], tCopy["useText"], tCopy["useOpacity"] = aColor["useBackground"], aColor["useText"], aColor["useOpacity"];
	return tCopy;
end



--
local tSummand;
local function VUHDO_brightenColor(aColor, aFactor)
	if not aColor then return; end
	tSummand = aFactor - 1;
	aColor["R"], aColor["G"], aColor["B"] = (aColor["R"] or 0) + tSummand, (aColor["G"] or 0) + tSummand, (aColor["B"] or 0) + tSummand;
	return aColor;
end




-- return tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tTimer2, clipLeft, clipRight, clipTop, clipBottom



--
local tInfo;
local function VUHDO_aoeAdviceValidator(anInfo, _)
	tInfo = VUHDO_getAoeAdviceForUnit(anInfo["unit"]);

	if tInfo then
		return true, tInfo["icon"], -1, -1, -1;
	else
		return false, nil, -1, -1, -1;
	end
end



--
local function VUHDO_aggroValidator(anInfo, _)
	return anInfo["aggro"], nil, -1, -1, -1;
end



--
local function VUHDO_outOfRangeValidator(anInfo, _)
	return not anInfo["range"], nil, -1, -1, -1;
end



--
local function VUHDO_inRangeValidator(anInfo, _)
	return anInfo["range"], nil, -1, -1, -1;
end



--
local tDistance;
local function VUHDO_inYardsRangeValidator(anInfo, someCustom)
	tDistance = VUHDO_getDistanceBetween("player", anInfo["unit"]);
	return tDistance and (tDistance <= someCustom["custom"][1]), nil, -1, -1, -1;
end



--
local function VUHDO_swiftmendValidator(anInfo, _)
	return VUHDO_isUnitSwiftmendable(anInfo["unit"]), nil, -1, -1, -1;
end



--
local tOPHotInfo;
local function VUHDO_otherPlayersHotsValidator(anInfo, _)
	tOPHotInfo = VUHDO_getOtherPlayersHotInfo(anInfo["unit"]);
	return tOPHotInfo[1] ~= nil, tOPHotInfo[1], -1, tOPHotInfo[2], -1;
end



--
local tDebuffInfo;
local function VUHDO_debuffMagicValidator(anInfo, _)
	tDebuffInfo = VUHDO_getUnitDebuffSchoolInfos(anInfo["unit"], VUHDO_DEBUFF_TYPE_MAGIC);
	if tDebuffInfo[2] then
		return true, tDebuffInfo[1], tDebuffInfo[2], tDebuffInfo[3], tDebuffInfo[4];
	else
		return false, nil, -1, -1, -1;
	end
end



--
local tDebuffInfo;
local function VUHDO_debuffDiseaseValidator(anInfo, _)
	tDebuffInfo = VUHDO_getUnitDebuffSchoolInfos(anInfo["unit"], VUHDO_DEBUFF_TYPE_DISEASE);
	if tDebuffInfo[2] then
		return true, tDebuffInfo[1], tDebuffInfo[2], tDebuffInfo[3], tDebuffInfo[4];
	else
		return false, nil, -1, -1, -1;
	end
end



--
local tDebuffInfo;
local function VUHDO_debuffPoisonValidator(anInfo, _)
	tDebuffInfo = VUHDO_getUnitDebuffSchoolInfos(anInfo["unit"], VUHDO_DEBUFF_TYPE_POISON);
	if tDebuffInfo[2] then
		return true, tDebuffInfo[1], tDebuffInfo[2], tDebuffInfo[3], tDebuffInfo[4];
	else
		return false, nil, -1, -1, -1;
	end
end



--
local tDebuffInfo;
local function VUHDO_debuffCurseValidator(anInfo, _)
	tDebuffInfo = VUHDO_getUnitDebuffSchoolInfos(anInfo["unit"], VUHDO_DEBUFF_TYPE_CURSE);
	if tDebuffInfo[2] then
		return true, tDebuffInfo[1], tDebuffInfo[2], tDebuffInfo[3], tDebuffInfo[4];
	else
		return false, nil, -1, -1, -1;
	end
end


-- return tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tTimer2, clipLeft, clipRight, clipTop, clipBottom
local tDebuffInfo;
local function VUHDO_debuffBarColorValidator(anInfo, _)
	if anInfo["charmed"] then
		return true, nil, -1, -1, -1, VUHDO_getDebuffColor(anInfo);
	elseif 0 ~= anInfo["debuff"] then -- VUHDO_DEBUFF_TYPE_NONE
		tDebuffInfo = VUHDO_getChosenDebuffInfo(anInfo["unit"]);
		return true, tDebuffInfo[1], -1, tDebuffInfo[2], -1, VUHDO_getDebuffColor(anInfo);
	else
		return false, nil, -1, -1, -1;
	end
end



--
local function VUHDO_debuffCharmedValidator(anInfo, _)
	return anInfo["charmed"], nil, -1, -1, -1;
end



--
local function VUHDO_deadValidator(anInfo, _)
	return anInfo["dead"], nil, 100, -1, 100;
end



--
local function VUHDO_disconnectedValidator(anInfo, _)
	return not anInfo or not anInfo["connected"], nil, 100, -1, 100;
end



--
local function VUHDO_afkValidator(anInfo, _)
	return anInfo["afk"], nil, -1, -1, -1;
end



--
local function VUHDO_playerTargetValidator(anInfo, _)
	if anInfo["isPet"] and (VUHDO_RAID[anInfo["ownerUnit"]] or tEmptyInfo)["isVehicle"] then
		return anInfo["ownerUnit"] == VUHDO_getCurrentPlayerTarget(), nil, -1, -1, -1;
	else
		return anInfo["unit"] == VUHDO_getCurrentPlayerTarget(), nil, -1, -1, -1;
	end
end



--
local function VUHDO_playerFocusValidator(anInfo, _)
	if anInfo["isPet"] and (VUHDO_RAID[anInfo["ownerUnit"]] or tEmptyInfo)["isVehicle"] then
		return anInfo["ownerUnit"] == VUHDO_getCurrentPlayerFocus(), nil, -1, -1, -1;
	else
		return anInfo["unit"] == VUHDO_getCurrentPlayerFocus(), nil, -1, -1, -1;
	end
end


-- return tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tTimer2, clipLeft, clipRight, clipTop, clipBottom

--
local function VUHDO_mouseOverTargetValidator(anInfo, _)
	if anInfo["isPet"] and (VUHDO_RAID[anInfo["ownerUnit"]] or tEmptyInfo)["isVehicle"] then
		return anInfo["ownerUnit"] == VUHDO_getCurrentMouseOver(), nil, -1, -1, -1;
	else
		return anInfo["unit"] == VUHDO_getCurrentMouseOver(), nil, -1, -1, -1;
	end
end



--
local tMouseOverUnit;
local function VUHDO_mouseOverGroupValidator(anInfo, _)
	tMouseOverUnit = VUHDO_getCurrentMouseOver();
	return VUHDO_RAID[tMouseOverUnit] and anInfo["group"] == VUHDO_RAID[tMouseOverUnit]["group"],
		nil, -1, -1, -1;
end



--
local function VUHDO_healthBelowValidator(anInfo, someCustom)
	if anInfo["healthmax"] > 0 then
		return 100 * anInfo["health"] / anInfo["healthmax"] < someCustom["custom"][1],
			nil, -1, -1, -1;
	else
		return false, nil, tPower, -1, -1;
	end
end



--
local function VUHDO_healthAboveValidator(anInfo, someCustom)
	if anInfo["healthmax"] > 0 then
		return 100 * anInfo["health"] / anInfo["healthmax"] >= someCustom["custom"][1],
			nil, -1, -1, -1;
	else
		return false, nil, tPower, -1, -1;
	end
end



--
local function VUHDO_healthBelowAbsValidator(anInfo, someCustom)
	return anInfo["health"] * 0.001 < someCustom["custom"][1], nil, -1, -1, -1;
end



--
local function VUHDO_healthAboveAbsValidator(anInfo, someCustom)
	return anInfo["health"] * 0.001 >= someCustom["custom"][1], nil, -1, -1, -1;
end



--
local function VUHDO_manaBelowValidator(anInfo, someCustom)
	if anInfo["powermax"] > 0 then
		return anInfo["powertype"] == 0 and 100 * anInfo["power"] / anInfo["powermax"] < someCustom["custom"][1],
			nil, -1, -1, -1;
	else
		return false, nil, tPower, -1, -1;
	end
end



--
local function VUHDO_threatAboveValidator(anInfo, someCustom)
	return anInfo["threatPerc"] > someCustom["custom"][1], nil, -1, -1, -1;
end



--
local tPerc;
local function VUHDO_alternatePowersAboveValidator(anInfo, someCustom)
	if anInfo["connected"] and anInfo["isAltPower"] and not anInfo["dead"] then
		tPerc = 100 * (UnitPower(anInfo["unit"], ALTERNATE_POWER_INDEX) or 0) / (UnitPowerMax(anInfo["unit"], ALTERNATE_POWER_INDEX) or 100);
		return tPerc > someCustom["custom"][1], nil, -1, -1, -1;
	else
		return false, nil, -1, -1, -1;
	end

end



--
local tPower;
local function VUHDO_holyPowersEqualsValidator(anInfo, someCustom)
	if anInfo["connected"] and not anInfo["dead"] then
		tPower = UnitPower(anInfo["unit"], 9);
		if tPower == someCustom["custom"][1] then
			return true, nil, tPower, -1, UnitPowerMax(anInfo["unit"], 9);
		else
			return false, nil, -1, -1, -1;
		end
	else
		return false, nil, tPower, -1, -1;
	end
end



--
local function VUHDO_chiEqualsValidator(anInfo, someCustom)
	if anInfo["connected"] and not anInfo["dead"] then
		tPower = UnitPower(anInfo["unit"], SPELL_POWER_CHI);
		if tPower == someCustom["custom"][1] then
			return true, nil, tPower, -1, UnitPowerMax(anInfo["unit"], SPELL_POWER_CHI);
		else
			return false, nil, -1, -1, -1;
		end
	else
		return false, nil, tPower, -1, -1;
	end
end



--
local function VUHDO_durationAboveValidator(anInfo, someCustom)
	if VUHDO_getIsCurrentBouquetActive() then
		return VUHDO_getCurrentBouquetTimer() > someCustom["custom"][1], nil, -1, -1, -1;
	else
		return false, nil, -1, -1, -1;
	end
end



--
local function VUHDO_durationBelowValidator(anInfo, someCustom)
	if VUHDO_getIsCurrentBouquetActive() then
		return VUHDO_getCurrentBouquetTimer() < someCustom["custom"][1], nil, -1, -1, -1;
	else
		return false, nil, -1, -1, -1;
	end
end



--
local tNumInCluster;
local function VUHDO_numInClusterValidator(anInfo, someCustom)
	tNumInCluster = VUHDO_getNumInUnitCluster(anInfo["unit"]);
	return tNumInCluster >= someCustom["custom"][1], nil, -1, tNumInCluster, -1;
end



--
local function VUHDO_mouseClusterValidator(anInfo, _)
	return VUHDO_getIsInHiglightCluster(anInfo["unit"]), nil, -1, -1, -1;
end



--
local function VUHDO_threatMediumValidator(anInfo, _)
	return anInfo["threat"] == 2, nil, -1, -1, -1;
end



--
local function VUHDO_threatHighValidator(anInfo, _)
	return anInfo["threat"] == 3, nil, -1, -1, -1;
end


--
local tIsRaidIconColor;
local tColor, tIcon;
local function VUHDO_raidTargetValidator(anInfo, _)
	if anInfo["raidIcon"] then
		tIcon = tostring(anInfo["raidIcon"]);
		tIsRaidIconColor = not sBarColors["RAID_ICONS"]["filterOnly"] or VUHDO_PANEL_SETUP["RAID_ICON_FILTER"][tIcon];

		if tIsRaidIconColor then
			tColor = sBarColors["RAID_ICONS"][tIcon];
		else
			tColor = nil;
		end
		return tIsRaidIconColor, nil, -1, -1, -1, tColor;
	else
		return false, nil, -1, -1, -1;
	end
end



--
local tOverheal;
local function VUHDO_overhealHighlightValidator(anInfo, _)
	tOverheal = VUHDO_getIncHealOnUnit(anInfo["unit"]) + anInfo["health"];
	if tOverheal > anInfo["healthmax"] and anInfo["healthmax"] > 0 then
		VUHDO_brightenColor(VUHDO_getCurrentBouquetColor(), tOverheal / anInfo["healthmax"]);
	end
	return false, nil, -1, -1, -1;
end




--
local tStacks;
local function VUHDO_stacksColorValidator(anInfo, _)
	tStacks = VUHDO_getCurrentBouquetStacks() or 0;
	if tStacks > 4 then	tStacks = 4; end

	if tStacks > 1 then
		return true, nil, -1, -1, -1, VUHDO_copyColor(sBarColors[VUHDO_CHARGE_COLORS[tStacks]]);
	else
		return false, nil, -1, -1, -1;
	end
end



--
local tStacks;
local function VUHDO_stacksValidator(anInfo, someCustom)
	tStacks = VUHDO_getCurrentBouquetStacks() or 0;

	if tStacks > someCustom["custom"][1] then
		return true, nil, -1, -1, -1;
	else
		return false, nil, -1, -1, -1;
	end
end



--
local tIndex, tFactor, tColor, tUnit;
local function VUHDO_emergencyColorValidator(anInfo, someCustom)
	if not VUHDO_FORCE_RESET then
		tUnit = anInfo["unit"];

		if tUnit == "target" then
			tUnit = VUHDO_getCurrentPlayerTarget();
		elseif tUnit == "focus" then
			tUnit = VUHDO_getCurrentPlayerFocus();
		end

		tIndex = VUHDO_EMERGENCIES[tUnit];
		if tIndex then
			tFactor = 1 / tIndex;

			tColor = VUHDO_copyColor(someCustom["color"]);
			tColor["R"], tColor["G"], tColor["B"] = (tColor["R"] or 0) * tFactor, (tColor["G"] or 0) * tFactor, (tColor["B"] or 0) * tFactor;
			return true, nil, -1, -1, -1, tColor;
		end
	end

	return false, nil, -1, -1, -1;
end



--
local function VUHDO_resurrectionValidator(anInfo, someCustom)
	return anInfo["dead"] and UnitHasIncomingResurrection(anInfo["unit"]), "Interface\\RaidFrame\\Raid-Icon-Rez", -1, -1, -1;
end



-- return tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tTimer2, clipLeft, clipRight, clipTop, clipBottom

--
local tHealth, tHealthMax;
local function VUHDO_statusHealthValidator(anInfo, _)
	if sIsInverted then
		return true, nil, anInfo["health"] + VUHDO_getIncHealOnUnit(anInfo["unit"]), -1,
			anInfo["healthmax"], nil, anInfo["health"];
	else
		return true, nil, anInfo["health"], -1,
			anInfo["healthmax"], nil, anInfo["health"];
	end
end



--
local function VUHDO_statusManaValidator(anInfo, _)
	return anInfo["powertype"] == 0, nil, anInfo["power"], -1,
		anInfo["powermax"], VUHDO_copyColor(VUHDO_POWER_TYPE_COLORS[0]);
end



--
local function VUHDO_statusOtherPowersValidator(anInfo, _)
	return anInfo["powertype"] ~= 0, nil, anInfo["power"], -1,
		anInfo["powermax"], VUHDO_copyColor(VUHDO_POWER_TYPE_COLORS[anInfo["powertype"] or 0]);
end



--
local function VUHDO_statusAlternatePowersValidator(anInfo, _)
	if anInfo["connected"] and anInfo["isAltPower"] and not anInfo["dead"] then
		return true, nil, UnitPower(anInfo["unit"], ALTERNATE_POWER_INDEX) or 0, -1,
			UnitPowerMax(anInfo["unit"], ALTERNATE_POWER_INDEX) or 100;
	else
		return false, nil, -1, -1, -1;
	end
end



--
local function VUHDO_statusIncomingValidator(anInfo, _)
	return true, nil, VUHDO_getIncHealOnUnit(anInfo["unit"]), -1, anInfo["healthmax"];
end



--
local function VUHDO_statusThreatValidator(anInfo, _)
	return true, nil, anInfo["threatPerc"], -1, 100;
end



--
local function VUHDO_statusAlwaysFullValidator(_, _)
	return true, nil, 100, -1, 100, nil, 100;
end

-- return tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tTimer2, clipLeft, clipRight, clipTop, clipBottom

--
local function VUHDO_statusFullIfActiveValidator(_, _)
	if VUHDO_getIsCurrentBouquetActive() then
		return true, nil, 100, -1, 100, VUHDO_getCurrentBouquetColor(), 100;
	else
		return false, nil, -1, -1, -1;
	end
end



--
local function VUHDO_classIconValidator(anInfo, _)
	if CLASS_ICON_TCOORDS[anInfo["class"]] then
		return true, "Interface\\TargetingFrame\\UI-Classes-Circles", -1, -1, -1, nil, nil, unpack(CLASS_ICON_TCOORDS[anInfo["class"]]);
	else
		return false, nil, -1, -1, -1;
	end
end



--
local tIndex;
local function VUHDO_raidIconValidator(anInfo, _)
	tIndex = GetRaidTargetIndex(anInfo["unit"]);

	if tIndex then
		return true, "interface\\targetingframe\\ui-raidtargetingicons", -1, -1, -1, nil, nil, VUHDO_getRaidTargetIconTexture(tIndex);
	else
		return false, nil, -1, -1, -1;
	end
end



--
local tIndex;
local function VUHDO_raidIconTargetValidator(anInfo, _)
	tIndex = UnitExists(anInfo["targetUnit"] or "foo") and GetRaidTargetIndex(anInfo["targetUnit"]);

	if tIndex then
		return true, "interface\\targetingframe\\ui-raidtargetingicons", -1, -1, -1, nil, nil, VUHDO_getRaidTargetIconTexture(tIndex);
	else
		return false, nil, -1, -1, -1;
	end
end



--
local function VUHDO_roleIconValidator(anInfo, _)
	if VUHDO_ID_MELEE_TANK == anInfo["role"] then
		return true, "Interface\\LFGFrame\\UI-LFG-ICON-ROLES", -1, -1, -1, nil, nil, GetTexCoordsForRole("TANK");
	elseif VUHDO_ID_RANGED_HEAL == anInfo["role"] then
		return true, "Interface\\LFGFrame\\UI-LFG-ICON-ROLES", -1, -1, -1, nil, nil, GetTexCoordsForRole("HEALER");
	elseif VUHDO_ID_MELEE_DAMAGE == anInfo["role"] or VUHDO_ID_RANGED_DAMAGE == anInfo["role"] then
		return true, "Interface\\LFGFrame\\UI-LFG-ICON-ROLES", -1, -1, -1, nil, nil, GetTexCoordsForRole("DAMAGER");
	else
		return false, nil, -1, -1, -1;
	end
end



--
local function VUHDO_roleTankValidator(anInfo, _)
	if VUHDO_ID_MELEE_TANK == anInfo["role"] then
		return true, "Interface\\LFGFrame\\UI-LFG-ICON-ROLES", -1, -1, -1, nil, nil, GetTexCoordsForRole("TANK");
	else
		return false, nil, -1, -1, -1;
	end
end



--
local function VUHDO_roleDamageValidator(anInfo, _)
	if VUHDO_ID_MELEE_DAMAGE == anInfo["role"] or VUHDO_ID_RANGED_DAMAGE == anInfo["role"] then
		return true, "Interface\\LFGFrame\\UI-LFG-ICON-ROLES", -1, -1, -1, nil, nil, GetTexCoordsForRole("DAMAGER");
	else
		return false, nil, -1, -1, -1;
	end
end



--
local function VUHDO_roleHealerValidator(anInfo, _)
	if VUHDO_ID_RANGED_HEAL == anInfo["role"] then
		return true, "Interface\\LFGFrame\\UI-LFG-ICON-ROLES", -1, -1, -1, nil, nil, GetTexCoordsForRole("HEALER");
	else
		return false, nil, -1, -1, -1;
	end
end



--
local tIcon, tExpiry, tStacks, tDuration;
local function VUHDO_customDebuffIconValidator(anInfo, _)
	tIcon, tExpiry, tStacks, tDuration = VUHDO_getLatestCustomDebuff(anInfo["unit"]);
	if tIcon then
		return true, tIcon, tExpiry - GetTime(), tStacks, tDuration;
	else
		return false, nil, -1, -1, -1;
	end
end



--
local tIsLeader;
local function VUHDO_leaderIconValidator(anInfo, _)
	tIsLeader = VUHDO_getUnitGroupPrivileges(anInfo["unit"]);
	if tIsLeader then
		return true, "Interface\\groupframe\\ui-group-leadericon", -1, -1, -1;
	else
		return false, nil, -1, -1, -1;
	end
end



--
local tIsAssistant;
local function VUHDO_assistantIconValidator(anInfo, _)
	_, tIsAssistant = VUHDO_getUnitGroupPrivileges(anInfo["unit"]);
	if tIsAssistant then
		return true, "Interface\\groupframe\\ui-group-assistanticon", -1, -1, -1;
	else
		return false, nil, -1, -1, -1;
	end
end



--
local tIsMasterLooter
local function VUHDO_masterLooterIconValidator(anInfo, _)
	_, _, tIsMasterLooter = VUHDO_getUnitGroupPrivileges(anInfo["unit"]);
	if tIsMasterLooter then
		return true, "Interface\\groupframe\\ui-group-masterlooter", -1, -1, -1;
	else
		return false, nil, -1, -1, -1;
	end
end



--
local function VUHDO_pvpIconValidator(anInfo, _)
	if UnitIsPVP(anInfo["unit"]) then
		if "Alliance" == (UnitFactionGroup(anInfo["unit"])) then
			return true, "Interface\\groupframe\\ui-group-pvp-alliance", -1, -1, -1;
		else
			return true, "Interface\\groupframe\\ui-group-pvp-horde", -1, -1, -1;
		end
	else
		return false, nil, -1, -1, -1;
	end
end



--
local tUnit;
local tDirection;
local tColor = { ["useBackground"] = true, ["noStacksColor"] = true };
local tDefaultColor = { ["R"] = 1, ["G"] = 0.4, ["B"] = 0.4, ["O"] = 1, ["useBackground"] = true, ["useSlotColor"] = true }
local tDistance;
local function VUHDO_directionArrowValidator(anInfo, someInfos)
	tUnit = anInfo["unit"];

	if not VUHDO_shouldDisplayArrow(tUnit) then
		return false, nil, -1, -1, -1;
	end

	tDirection = VUHDO_getUnitDirection(tUnit);
	if not tDirection then
		return false, nil, -1, -1, -1;
	end

	if sIsDistance then
		tDistance = VUHDO_getDistanceBetween("player", tUnit);
		if tDistance then
			tColor["R"], tColor["G"] = VUHDO_getRedGreenForDistance(tDistance);
			tDistance = (tDistance > 0 and tDistance < 100) and floor(tDistance * 0.1) or nil;
			if tDistance then
				tColor["B"], tColor["useText"] = 0.2, true;
				tColor["TR"], tColor["TG"], tColor["TB"] = tColor["R"], tColor["G"], 0.2;
			end
		else
			tDistance = nil;
		end
	else
		tDistance = nil;
	end

	return true, "Interface\\AddOns\\VuhDo\\Images\\Arrow.blp", -1,
		tDistance or -1, -1, tDistance ~= nil and tColor or tDefaultColor, nil, VUHDO_getTexCoordsForCell(VUHDO_getCellForDirection(tDirection));
end



--
local function VUHDO_classColorIfActiveValidator(anInfo, _)
	if VUHDO_getIsCurrentBouquetActive() then
		return true, nil, -1, -1, -1,
			VUHDO_copyColor(VUHDO_USER_CLASS_COLORS[anInfo["classId"]]);
	else
		return false, nil, -1, -1, -1;
	end
end



--
local function VUHDO_classColorValidator(anInfo, _)
	return true, nil, -1, -1, -1,
		VUHDO_copyColor(VUHDO_USER_CLASS_COLORS[anInfo["classId"]]);
end



--
local tUnit;
local function VUHDO_tappedValidator(anInfo, _)
	tUnit = anInfo["unit"];

	if not UnitIsPlayer(tUnit) and UnitIsTapped(tUnit) and not UnitIsTappedByPlayer(tUnit) then
		return true, nil, -1, -1, -1,
			VUHDO_copyColor(sBarColors["TAPPED"]);
	else
		return false, nil, -1, -1, -1;
	end
end



--
local tUnit;
local function VUHDO_enemyStateValidator(anInfo, _)
	tUnit = anInfo["unit"];
	if UnitIsFriend("player", tUnit) then
		return true, nil, -1, -1, -1,
			VUHDO_copyColor(sBarColors["TARGET_FRIEND"]);
	elseif UnitIsEnemy("player", tUnit) then
		return true, nil, -1, -1, -1,
			VUHDO_copyColor(sBarColors["TARGET_ENEMY"]);
	else
		return true, nil, -1, -1, -1,
			VUHDO_copyColor(sBarColors["TARGET_NEUTRAL"]);
	end
end

-- return tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tTimer2, clipLeft, clipRight, clipTop, clipBottom



--
local tShieldLeft;
local function VUHDO_shieldCountValidator(anInfo, _)
	tShieldLeft = VUHDO_getUnitOverallShieldRemain(anInfo["unit"]);
	return tShieldLeft >= 1000, nil, -1, floor(tShieldLeft * 0.001 + 0.5), -1;
end



--
local tShieldLeft, tHealthMax;
local function VUHDO_statusShieldFromHealthValidator(anInfo, _)
	tHealthMax = anInfo["healthmax"];
	tShieldLeft = VUHDO_getUnitOverallShieldRemain(anInfo["unit"]);
	return true, nil, tShieldLeft < tHealthMax and tShieldLeft or tHealthMax, -1, tHealthMax;
end



--
local tShieldLeft, tHealthMax, tHealth;
local function VUHDO_statusShieldOvershieldValidator(anInfo, _)
	tHealthMax = anInfo["healthmax"];
	tHealth = anInfo["health"];
	tShieldLeft = VUHDO_getUnitOverallShieldRemain(anInfo["unit"]);
	return tHealth + tShieldLeft > tHealthMax, nil, tShieldLeft - tHealthMax + tHealth, -1, tHealthMax;
end



--
local function VUHDO_alwaysTrueValidator(_, _)
	return true, nil, -1, -1, -1;
end



--
VUHDO_BOUQUET_BUFFS_SPECIAL = {
	["AGGRO"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_AGGRO,
		["validator"] = VUHDO_aggroValidator,
		["interests"] = { VUHDO_UPDATE_AGGRO },
	},

	["NO_RANGE"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_OUT_OF_RANGE,
		["validator"] = VUHDO_outOfRangeValidator,
		["interests"] = { VUHDO_UPDATE_RANGE },
	},

	["IN_RANGE"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_IN_RANGE,
		["validator"] = VUHDO_inRangeValidator,
		["interests"] = { VUHDO_UPDATE_RANGE },
	},

	["YARDS_RANGE"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_IN_YARDS,
		["validator"] = VUHDO_inYardsRangeValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_PERCENT,
		["updateCyclic"] = true,
		["interests"] = { },
	},

	["OTHER"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_OTHER_HOTS,
		["validator"] = VUHDO_otherPlayersHotsValidator,
		["updateCyclic"] = true,
		["interests"] = { },
	},

	["SWIFTMEND"] = {
		["displayName"] = VUHDO_I18N_SWIFTMEND_POSSIBLE,
		["validator"] = VUHDO_swiftmendValidator,
		["updateCyclic"] = true,
		["interests"] = { },
	},

	["DEBUFF_MAGIC"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_DEBUFF_MAGIC,
		["validator"] = VUHDO_debuffMagicValidator,
		["updateCyclic"] = true,
		["interests"] = { VUHDO_UPDATE_DEBUFF },
	},

	["DEBUFF_DISEASE"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_DEBUFF_DISEASE,
		["validator"] = VUHDO_debuffDiseaseValidator,
		["updateCyclic"] = true,
		["interests"] = { VUHDO_UPDATE_DEBUFF },
	},

	["DEBUFF_POISON"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_DEBUFF_POISON,
		["validator"] = VUHDO_debuffPoisonValidator,
		["updateCyclic"] = true,
		["interests"] = { VUHDO_UPDATE_DEBUFF },
	},

	["DEBUFF_CURSE"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_DEBUFF_CURSE,
		["validator"] = VUHDO_debuffCurseValidator,
		["updateCyclic"] = true,
		["interests"] = { VUHDO_UPDATE_DEBUFF },
	},

	["DEBUFF_CHARMED"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_CHARMED,
		["validator"] = VUHDO_debuffCharmedValidator,
		["interests"] = { VUHDO_UPDATE_DEBUFF },
	},

	["DEBUFF_BAR_COLOR"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_DEBUFF_BAR_COLOR,
		["validator"] = VUHDO_debuffBarColorValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_BRIGHTNESS,
		["no_color"] = true,
		["interests"] = { VUHDO_UPDATE_DEBUFF },
	},

	["DEAD"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_DEAD,
		["validator"] = VUHDO_deadValidator,
		["interests"] = { VUHDO_UPDATE_ALIVE },
	},

	["DISCONNECTED"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_DISCONNECTED,
		["validator"] = VUHDO_disconnectedValidator,
		["interests"] = { VUHDO_UPDATE_DC },
	},

	["AFK"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_AFK,
		["validator"] = VUHDO_afkValidator,
		["interests"] = { VUHDO_UPDATE_AFK },
	},

	["PLAYER_TARGET"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_PLAYER_TARGET,
		["validator"] = VUHDO_playerTargetValidator,
		["interests"] = { VUHDO_UPDATE_TARGET },
	},

	["PLAYER_FOCUS"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_PLAYER_FOCUS,
		["validator"] = VUHDO_playerFocusValidator,
		["interests"] = { VUHDO_UPDATE_PLAYER_FOCUS },
	},

	["MOUSE_TARGET"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_MOUSEOVER_TARGET,
		["validator"] = VUHDO_mouseOverTargetValidator,
		["interests"] = { VUHDO_UPDATE_MOUSEOVER },
	},

	["MOUSE_GROUP"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_MOUSEOVER_GROUP,
		["validator"] = VUHDO_mouseOverGroupValidator,
		["interests"] = { VUHDO_UPDATE_MOUSEOVER_GROUP },
	},

	["HEALTH_BELOW"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_HEALTH_BELOW,
		["validator"] = VUHDO_healthBelowValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_PERCENT,
		["interests"] = { VUHDO_UPDATE_HEALTH, VUHDO_UPDATE_HEALTH_MAX },
	},

	["HEALTH_ABOVE"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_HEALTH_ABOVE,
		["validator"] = VUHDO_healthAboveValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_PERCENT,
		["interests"] = { VUHDO_UPDATE_HEALTH, VUHDO_UPDATE_HEALTH_MAX },
	},

	["HEALTH_BELOW_ABS"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_HEALTH_BELOW_ABS,
		["validator"] = VUHDO_healthBelowAbsValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_HEALTH,
		["interests"] = { VUHDO_UPDATE_HEALTH, VUHDO_UPDATE_HEALTH_MAX },
	},

	["HEALTH_ABOVE_ABS"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_HEALTH_ABOVE_ABS,
		["validator"] = VUHDO_healthAboveAbsValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_HEALTH,
		["interests"] = { VUHDO_UPDATE_HEALTH, VUHDO_UPDATE_HEALTH_MAX },
	},

	["MANA_BELOW"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_MANA_BELOW,
		["validator"] = VUHDO_manaBelowValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_PERCENT,
		["interests"] = { VUHDO_UPDATE_MANA },
	},

	["THREAT_ABOVE"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_THREAT_ABOVE,
		["validator"] = VUHDO_threatAboveValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_PERCENT,
		["interests"] = { VUHDO_UPDATE_THREAT_PERC },
	},

	["ALTERNATE_POWERS_ABOVE"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_ALTERNATE_POWERS_ABOVE,
		["validator"] = VUHDO_alternatePowersAboveValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_PERCENT,
		["interests"] = { VUHDO_UPDATE_ALT_POWER, VUHDO_UPDATE_DC, VUHDO_UPDATE_ALIVE },
	},

	["OWN_HOLY_POWER_EQUALS"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_HOLY_POWER_EQUALS,
		["validator"] = VUHDO_holyPowersEqualsValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_HOLY_POWER,
		["interests"] = { VUHDO_UPDATE_OWN_HOLY_POWER, VUHDO_UPDATE_DC, VUHDO_UPDATE_ALIVE },
	},

	["OWN_CHI_EQUALS"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_OWN_CHI_EQUALS,
		["validator"] = VUHDO_chiEqualsValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_HOLY_POWER,
		["interests"] = { VUHDO_UPDATE_CHI, VUHDO_UPDATE_DC, VUHDO_UPDATE_ALIVE },
	},

	["DURATION_ABOVE"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_DURATION_ABOVE,
		["validator"] = VUHDO_durationAboveValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_SECONDS,
		["updateCyclic"] = true,
		["interests"] = { },
	},

	["DURATION_BELOW"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_DURATION_BELOW,
		["validator"] = VUHDO_durationBelowValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_SECONDS,
		["updateCyclic"] = true,
		["interests"] = { },
	},

	["NUM_CLUSTER"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_NUM_IN_CLUSTER,
		["validator"] = VUHDO_numInClusterValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_PLAYERS,
		["interests"] = { VUHDO_UPDATE_NUM_CLUSTER },
	},

	["MOUSE_CLUSTER"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_MOUSEOVER_CLUSTER,
		["validator"] = VUHDO_mouseClusterValidator,
		["updateCyclic"] = true,
		["interests"] = { VUHDO_UPDATE_MOUSEOVER_CLUSTER },
	},

	["THREAT_LEVEL_MEDIUM"] = {
		["displayName"] = VUHDO_I18N_THREAT_LEVEL_MEDIUM,
		["validator"] = VUHDO_threatMediumValidator,
		["interests"] = { VUHDO_UPDATE_THREAT_LEVEL },
	},

	["THREAT_LEVEL_HIGH"] = {
		["displayName"] = VUHDO_I18N_THREAT_LEVEL_HIGH,
		["validator"] = VUHDO_threatHighValidator,
		["interests"] = { VUHDO_UPDATE_THREAT_LEVEL },
	},

	["RAID_ICON_COLOR"] = {
		["displayName"] = VUHDO_I18N_UPDATE_RAID_TARGET,
		["validator"] = VUHDO_raidTargetValidator,
		["no_color"] = true,
		["interests"] = { VUHDO_UPDATE_RAID_TARGET },
	},

	["OVERHEAL_HIGHLIGHT"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_OVERHEAL_HIGHLIGHT,
		["validator"] = VUHDO_overhealHighlightValidator,
		["no_color"] = true,
		["interests"] = { VUHDO_UPDATE_INC },
	},

	["EMERGENCY_COLOR"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_EMERGENCY_COLOR,
		["validator"] = VUHDO_emergencyColorValidator,
		["interests"] = { VUHDO_UPDATE_EMERGENCY },
	},

	["RESURRECTION"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_RESURRECTION,
		["validator"] = VUHDO_resurrectionValidator,
		["interests"] = { VUHDO_UPDATE_RESURRECTION },
	},

	["STATUS_HEALTH"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_STATUS_HEALTH,
		["validator"] = VUHDO_statusHealthValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_STATUSBAR,
		["interests"] = { VUHDO_UPDATE_HEALTH, VUHDO_UPDATE_HEALTH_MAX, VUHDO_UPDATE_INC },
	},

	["STATUS_MANA"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_STATUS_MANA,
		["validator"] = VUHDO_statusManaValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_STATUSBAR,
		["no_color"] = true,
		["interests"] = { VUHDO_UPDATE_MANA, VUHDO_UPDATE_DC },
	},

	["STATUS_OTHER_POWERS"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_STATUS_OTHER_POWERS,
		["validator"] = VUHDO_statusOtherPowersValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_STATUSBAR,
		["no_color"] = true,
		["interests"] = { VUHDO_UPDATE_OTHER_POWERS, VUHDO_UPDATE_DC },
	},

	["STATUS_ALTERNATE_POWERS"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_STATUS_ALTERNATE_POWERS,
		["validator"] = VUHDO_statusAlternatePowersValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_STATUSBAR,
		["interests"] = { VUHDO_UPDATE_ALT_POWER, VUHDO_UPDATE_DC, VUHDO_UPDATE_ALIVE },
	},

	["STATUS_INCOMING"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_STATUS_INCOMING,
		["validator"] = VUHDO_statusIncomingValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_STATUSBAR,
		["interests"] = { VUHDO_UPDATE_INC },
	},

	["STATUS_THREAT"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_STATUS_THREAT,
		["validator"] = VUHDO_statusThreatValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_STATUSBAR,
		["interests"] = { VUHDO_UPDATE_THREAT_PERC },
	},

	["STATUS_FULL"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_STATUS_ALWAYS_FULL,
		["validator"] = VUHDO_statusAlwaysFullValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_STATUSBAR,
		["interests"] = { },
	},

	["STATUS_ACTIVE"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_STATUS_FULL_IF_ACTIVE,
		["validator"] = VUHDO_statusFullIfActiveValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_STATUSBAR,
		["interests"] = { },
	},

	["STATUS_CC_ACTIVE"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_STATUS_CLASS_COLOR_IF_ACTIVE,
		["validator"] = VUHDO_classColorIfActiveValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_BRIGHTNESS,
		["no_color"] = true,
		["interests"] = { },
	},

	["STACKS_COLOR"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_STACKS_COLOR,
		["validator"] = VUHDO_stacksColorValidator,
		["updateCyclic"] = true,
		["no_color"] = true,
		["interests"] = { },
	},

	["STACKS"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_STACKS,
		["validator"] = VUHDO_stacksValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_STACKS,
		["updateCyclic"] = true,
		["interests"] = { },
	},

	["CLASS_ICON"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_CLASS_ICON,
		["validator"] = VUHDO_classIconValidator,
		["no_color"] = true,
		["interests"] = { },
	},

	["RAID_ICON"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_RAID_ICON,
		["validator"] = VUHDO_raidIconValidator,
		["no_color"] = true,
		["interests"] = { },
	},

	["RAID_ICON_TARGET"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_TARGET_RAID_ICON,
		["validator"] = VUHDO_raidIconTargetValidator,
		["no_color"] = true,
		["interests"] = { },
	},

	["ROLE_ICON"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_ROLE_ICON,
		["validator"] = VUHDO_roleIconValidator,
		["no_color"] = true,
		["interests"] = { },
	},

	["ROLE_TANK"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_ROLE_TANK,
		["validator"] = VUHDO_roleTankValidator,
		["interests"] = { },
	},

	["ROLE_DAMAGE"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_ROLE_DAMAGE,
		["validator"] = VUHDO_roleDamageValidator,
		["interests"] = { },
	},

	["ROLE_HEALER"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_ROLE_HEALER,
		["validator"] = VUHDO_roleHealerValidator,
		["interests"] = { },
	},

	["DIRECTION"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_DIRECTION_ARROW,
		["validator"] = VUHDO_directionArrowValidator,
		--["no_color"] = true,
		["updateCyclic"] = true,
		["interests"] = { VUHDO_UPDATE_RANGE, VUHDO_UPDATE_ALIVE },
	},

	["CUSTOM_DEBUFF"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_CUSTOM_DEBUFF,
		["validator"] = VUHDO_customDebuffIconValidator,
		["updateCyclic"] = true,
		["no_color"] = true,
		["interests"] = { VUHDO_UPDATE_CUSTOM_DEBUFF },
	},

	["TAPPED"] = {
		["displayName"] = VUHDO_I18N_TAPPED_COLOR,
		["validator"] = VUHDO_tappedValidator,
		["no_color"] = true,
		["updateCyclic"] = true,
		["interests"] = { },
	},

	["ENEMY_STATE"] = {
		["displayName"] = VUHDO_I18N_ENEMY_STATE_COLOR,
		["validator"] = VUHDO_enemyStateValidator,
		["no_color"] = true,
		["interests"] = { VUHDO_UPDATE_UNIT_TARGET },
	},

	["AOE_ADVICE"] = {
		["displayName"] = VUHDO_I18N_AOE_ADVICE,
		["validator"] = VUHDO_aoeAdviceValidator,
		["interests"] = { VUHDO_UPDATE_AOE_ADVICE },
	},

	["LEADER"] = {
		["displayName"] = VUHDO_I18N_DEF_RAID_LEADER,
		["validator"] = VUHDO_leaderIconValidator,
		["interests"] = { VUHDO_UPDATE_MINOR_FLAGS },
	},

	["ASSISTANT"] = {
		["displayName"] = VUHDO_I18N_DEF_RAID_ASSIST,
		["validator"] = VUHDO_assistantIconValidator,
		["interests"] = { VUHDO_UPDATE_MINOR_FLAGS },
	},

	["LOOT_MASTER"] = {
		["displayName"] = VUHDO_I18N_DEF_MASTER_LOOTER,
		["validator"] = VUHDO_masterLooterIconValidator,
		["interests"] = { VUHDO_UPDATE_MINOR_FLAGS },
	},

	["PVP_FLAG"] = {
		["displayName"] = VUHDO_I18N_DEF_PVP_STATUS,
		["validator"] = VUHDO_pvpIconValidator,
		["interests"] = { VUHDO_UPDATE_MINOR_FLAGS },
	},

	["SHIELDS_COUNTER"] = {
		["displayName"] = VUHDO_I18N_DEF_COUNTER_SHIELD_ABSORB,
		["validator"] = VUHDO_shieldCountValidator,
		["interests"] = { VUHDO_UPDATE_SHIELD },
	},

	["SHIELD_STATUS"] = {
		["displayName"] = VUHDO_I18N_DEF_STATUS_SHIELD,
		["validator"] = VUHDO_statusShieldFromHealthValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_STATUSBAR,
		["interests"] = { VUHDO_UPDATE_SHIELD },
	},

	["SHIELD_OVERSHIELD"] = {
		["displayName"] = VUHDO_I18N_DEF_STATUS_OVERSHIELDED,
		["validator"] = VUHDO_statusShieldOvershieldValidator,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_STATUSBAR,
		["interests"] = { VUHDO_UPDATE_SHIELD },
	},

	["CLASS_COLOR"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_CLASS_COLOR,
		["validator"] = VUHDO_classColorValidator,
		["no_color"] = true,
		["custom_type"] = VUHDO_BOUQUET_CUSTOM_TYPE_BRIGHTNESS,
		["interests"] = { },
	},

	["ALWAYS"] = {
		["displayName"] = VUHDO_I18N_BOUQUET_ALWAYS,
		["validator"] = VUHDO_alwaysTrueValidator,
		["interests"] = { },
	},
};

