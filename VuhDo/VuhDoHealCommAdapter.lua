-- BURST CACHE ---------------------------------------------------
local UnitGetIncomingHeals = UnitGetIncomingHeals;
local sIsOthers, sIsOwn, sIsInc;
function VUHDO_healCommAdapterInitBurst()
	sIsOthers = VUHDO_CONFIG["SHOW_INCOMING"];
	sIsOwn = VUHDO_CONFIG["SHOW_OWN_INCOMING"];
	sIsInc = sIsOwn or sIsOthers;
end


----------------------------------------------------


local VUHDO_INC_HEAL = { };



--
function VUHDO_getIncHealOnUnit(aUnit)
	return VUHDO_INC_HEAL[aUnit] or 0;
end



--
local tAllIncoming;
function VUHDO_determineIncHeal(aUnit)
	if (not sIsInc) then
		return;
	end

	if (sIsOthers) then
		if (not sIsOwn) then
			tAllIncoming = (UnitGetIncomingHeals(aUnit) or 0) - (UnitGetIncomingHeals(aUnit, "player") or 0);
			VUHDO_INC_HEAL[aUnit] = tAllIncoming < 0 and 0 or tAllIncoming;
		else
			VUHDO_INC_HEAL[aUnit] = UnitGetIncomingHeals(aUnit);
		end
	else
		VUHDO_INC_HEAL[aUnit] = UnitGetIncomingHeals(aUnit, "player");
	end
end
