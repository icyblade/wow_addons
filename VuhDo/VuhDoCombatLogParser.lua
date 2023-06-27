local VUHDO_RAID = { };
local VUHDO_RAID_GUIDS = { };
local VUHDO_INTERNAL_TOGGLES = { };

local strsplit = strsplit;
local pairs = pairs;

local VUHDO_updateHealth;
local sCurrentTarget = nil;
local sCurrentFocus = nil;



--
function VUHDO_combatLogInitBurst()
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];
	VUHDO_RAID_GUIDS = VUHDO_GLOBAL["VUHDO_RAID_GUIDS"];
	VUHDO_INTERNAL_TOGGLES = VUHDO_GLOBAL["VUHDO_INTERNAL_TOGGLES"];
	VUHDO_updateHealth = VUHDO_GLOBAL["VUHDO_updateHealth"];
end



--
local tInfo;
local tNewHealth;
local tDeadInfo = { ["dead"] = true };
local function VUHDO_addUnitHealth(aUnit, aDelta)
	tInfo = VUHDO_RAID[aUnit] or tDeadInfo;

	if (not tInfo["dead"]) then
		tNewHealth = tInfo["health"] + aDelta;

		if (tNewHealth < 0) then
			tNewHealth = 0;
		elseif (tNewHealth > tInfo["healthmax"]) then
			tNewHealth = tInfo["healthmax"];
		end

		if (tInfo["health"] ~= tNewHealth) then
			tInfo["health"] = tNewHealth;
			VUHDO_updateHealth(aUnit, 2); -- VUHDO_UPDATE_HEALTH
		end
	end
end



--
local tPre, tSuf, tSpec;
local function VUHDO_getTargetHealthImpact(aMsg, aMsg1, aMsg2, aMsg4)
	tPre, tSuf, tSpec = strsplit("_", aMsg);

	if ("SPELL" == tPre) then
		if (("HEAL" == tSuf or "HEAL" == tSpec) and "MISSED" ~= tSpec) then
			return aMsg4;
		elseif ("DAMAGE" == tSuf or "DAMAGE" == tSpec) then
			return -aMsg4;
		end
	elseif ("DAMAGE" == tSuf) then
		if ("SWING" == tPre) then
			return -aMsg1;
		elseif ("RANGE" == tPre) then
			return -aMsg4;
		elseif ("ENVIRONMENTAL" == tPre) then
			return -aMsg2
		end
	elseif ("DAMAGE" == tPre and "MISSED" ~= tSpec and "RESISTED" ~= tSpec) then
		return -aMsg4;
	end

	return 0;
end



--
function VUHDO_clParserSetCurrentTarget(aUnit)
	sCurrentTarget = VUHDO_INTERNAL_TOGGLES[27] and aUnit or "*"; -- VUHDO_UPDATE_PLAYER_TARGET
end



--
function VUHDO_clParserSetCurrentFocus()
	sCurrentFocus = nil;
	local tUnit, tInfo;
	local tEmptyInfo = { };

	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if (UnitIsUnit("focus", tUnit) and tUnit ~= "focus" and tUnit ~= "target") then
			if (tInfo["isPet"] and (VUHDO_RAID[tInfo["ownerUnit"]] or tEmptyInfo)["isVehicle"]) then
				sCurrentFocus = tInfo["ownerUnit"];
			else
				sCurrentFocus = tUnit;
			end
			break;
		end
	end

end



--
local tUnit;
local tImpact, tLastHeal = nil;
function VUHDO_parseCombatLogEvent(aMsg, aDstGUID, aMsg1, aMsg2, aMsg4)
	tUnit = VUHDO_RAID_GUIDS[aDstGUID];
	if (tUnit == nil) then
		return;
	end

	tImpact = VUHDO_getTargetHealthImpact(aMsg, aMsg1, aMsg2, aMsg4);
	if (tImpact ~= 0) then
		VUHDO_addUnitHealth(tUnit, tImpact);
		if (tUnit == sCurrentTarget) then
			VUHDO_addUnitHealth("target", tImpact);
		end
		if (tUnit == sCurrentFocus) then
			VUHDO_addUnitHealth("focus", tImpact);
		end
	end
end



--
function VUHDO_getCurrentPlayerFocus()
	return sCurrentFocus;
end
