local _;
local select = select;
local type = type;

local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs;

local VUHDO_SHIELDS = {
	[17] = 15, -- VUHDO_SPELL_ID.POWERWORD_SHIELD -- ok
	[123258] = 15, -- Power Word: Shield (Improved)
	[47753] = 15, -- VUHDO_SPELL_ID.DIVINE_AEGIS -- ok
	[86273] = 15, -- VUHDO_SPELL_ID.ILLUMINATED_HEALING (buff) ok
	[11426] = 60, -- VUHDO_SPELL_ID.ICE_BARRIER -- ok
	[65148] = 15, -- VUHDO_SPELL_ID.SACRED_SHIELD (Buff) -- ok
	[114908] = 15, -- VUHDO_SPELL_ID.SPIRIT_SHELL (Buff) -- ok
	[116849] = 12, -- Life Cocoon
	[115295] = 30, -- Guard (brewmaster monk's self buff, unglyphed)
	[118604] = 30, -- Guard (brewmaster monk's black ox statue (cast on group), unglyphed)
	--[123402] = 30, -- Guard (brewmaster monk's self buff, with Glyph of Guard) - Magic damage ONLY
	--[136070] = 30, -- Guard (brewmaster monk's black ox statue (cast on group), with Glyph of Guard) - Magic damage ONLY
	[112048] = 6, -- Shield Barrier (Prot warrior)
	--[77535] = 10, -- Blood Shield (Blood DK) - Physical damage ONLY
	[108416] = 20, -- Sacrificial Pact (warlock talent)
	[1463] = 8, -- Incanter's Ward (mage talent)
	[114893] = 10, -- Stone Bulwark Totem (shaman talent)
}


--
local VUHDO_PUMP_SHIELDS = {
	[VUHDO_SPELL_ID.DIVINE_AEGIS] = 0.6,
	[VUHDO_SPELL_ID.SPIRIT_SHELL] = 0.6,
}



local VUHDO_ABSORB_DEBUFFS = {
	[109379] = function() return 200000, 5 * 60; end, -- Searing Plasma
	[109362] = function() return 300000, 5 * 60; end,
	[105479] = function() return 200000, 5 * 60; end,
	[109364] = function() return 420000, 5 * 60; end,
	[109363] = function() return 280000, 5 * 60; end,

	[110598] = function() return 420000, 2 * 60; end, -- Consuming Shroud
	[110214] = function() return 280000, 2 * 60; end,

	--[79105] = function() return 280000, 60 * 60; end, -- @TESTING PW:F
};



local sMissedEvents = {
	["SWING_MISSED"] = true,
	["RANGE_MISSED"] = true,
	["SPELL_MISSED"] = true,
	["SPELL_PERIODIC_MISSED"] = true,
	["ENVIRONMENTAL_MISSED"] = true
};



local VUHDO_SHIELD_LEFT = { };
setmetatable(VUHDO_SHIELD_LEFT, VUHDO_META_NEW_ARRAY);
local VUHDO_SHIELD_SIZE = { };
setmetatable(VUHDO_SHIELD_SIZE, VUHDO_META_NEW_ARRAY);
local VUHDO_SHIELD_EXPIRY = { };
setmetatable(VUHDO_SHIELD_EXPIRY, VUHDO_META_NEW_ARRAY);
local VUHDO_SHIELD_LAST_SOURCE_GUID = { };
setmetatable(VUHDO_SHIELD_LAST_SOURCE_GUID, VUHDO_META_NEW_ARRAY);


local VUHDO_PLAYER_SHIELDS = { };


--
local pairs = pairs;
local ceil = ceil;
local GetTime = GetTime;
local select = select;
local UnitAura = UnitAura;
local GetSpellInfo = GetSpellInfo;



--
local VUHDO_PLAYER_GUID = -1;
local sIsPumpAegis = false;
local sShowAbsorb = false;
function VUHDO_shieldAbsorbInitLocalOverrides()
	VUHDO_PLAYER_GUID = UnitGUID("player");
	sShowAbsorb = VUHDO_PANEL_SETUP["BAR_COLORS"]["HOTS"]["showShieldAbsorb"];
	sIsPumpAegis = VUHDO_PANEL_SETUP["BAR_COLORS"]["HOTS"]["isPumpDivineAegis"];
end


--
local function VUHDO_initShieldValue(aUnit, aShieldName, anAmount, aDuration)
	if (anAmount or 0) == 0 then
		--VUHDO_xMsg("ERROR: Failed to init shield " .. aShieldName .. " on " .. aUnit, anAmount);
		return;
	end

	VUHDO_SHIELD_LEFT[aUnit][aShieldName] = anAmount;

	if sIsPumpAegis and VUHDO_PUMP_SHIELDS[aShieldName] then
		VUHDO_SHIELD_SIZE[aUnit][aShieldName] = VUHDO_RAID["player"]["healthmax"] * VUHDO_PUMP_SHIELDS[aShieldName];
	else
		VUHDO_SHIELD_SIZE[aUnit][aShieldName] = anAmount;
	end
	VUHDO_SHIELD_EXPIRY[aUnit][aShieldName] = GetTime() + aDuration;
	--VUHDO_xMsg("Init shield " .. aShieldName .. " on " .. aUnit .. " for " .. anAmount, aDuration);
end



--
local function VUHDO_updateShieldValue(aUnit, aShieldName, anAmount, aDuration)
	if not VUHDO_SHIELD_SIZE[aUnit][aShieldName] then
		return;
	end

	if (anAmount or 0) == 0 then
		--VUHDO_xMsg("ERROR: Failed to update shield " .. aShieldName .. " on " .. aUnit, anAmount);
		return;
	end

	if aDuration and VUHDO_SHIELD_LEFT[aUnit][aShieldName] <= anAmount then
		VUHDO_SHIELD_EXPIRY[aUnit][aShieldName] = GetTime() + aDuration;
		--VUHDO_Msg("Shield overwritten");
	end

	if VUHDO_SHIELD_SIZE[aUnit][aShieldName] < anAmount then
		VUHDO_SHIELD_SIZE[aUnit][aShieldName] = anAmount;
	end

	VUHDO_SHIELD_LEFT[aUnit][aShieldName] = anAmount;
  --VUHDO_xMsg("Updated shield " .. aShieldName .. " on " .. aUnit .. " to " .. anAmount, aDuration);
end



--
local function VUHDO_removeShield(aUnit, aShieldName)
	if not VUHDO_SHIELD_SIZE[aUnit][aShieldName] then return; end

	VUHDO_SHIELD_SIZE[aUnit][aShieldName] = nil;
	VUHDO_SHIELD_LEFT[aUnit][aShieldName] = nil;
	VUHDO_SHIELD_EXPIRY[aUnit][aShieldName] = nil;
	VUHDO_SHIELD_LAST_SOURCE_GUID[aUnit][aShieldName] = nil;
	--VUHDO_Msg("Removed shield " .. aShieldName .. " from " .. aUnit);
end



--
local tNow;
function VUHDO_removeObsoleteShields()
	tNow = GetTime();
	for tUnit, tAllShields in pairs(VUHDO_SHIELD_EXPIRY) do
		for tShieldName, tExpiry in pairs(tAllShields) do
			if tExpiry < tNow then
				VUHDO_removeShield(tUnit, tShieldName);
			end
		end
	end
end



--
local tInit, tValue, tSourceGuid;
function VUHDO_getShieldLeftCount(aUnit, aShield, aMode)
	tInit = sShowAbsorb and VUHDO_SHIELD_SIZE[aUnit][aShield] or 0;

	if tInit > 0 then
		tSourceGuid = VUHDO_SHIELD_LAST_SOURCE_GUID[aUnit][aShield];
		if aMode == 3 or aMode == 0
		or (aMode == 1 and tSourceGuid == VUHDO_PLAYER_GUID)
		or (aMode == 2 and tSourceGuid ~= VUHDO_PLAYER_GUID) then
			tValue = ceil(4 * (VUHDO_SHIELD_LEFT[aUnit][aShield] or 0) / tInit);
			return tValue > 4 and 4 or tValue;
		end
	end
	return 0;
end



--
local tRemain;
local tSpellName;
local function VUHDO_updateShields(aUnit)
	for tSpellId, _ in pairs(VUHDO_SHIELDS) do
		tSpellName = select(1, GetSpellInfo(tSpellId));
		tRemain = select(15, UnitAura(aUnit, tSpellName));

		--VUHDO_xMsg(UnitAura(aUnit, tSpellName));
		if tRemain and "number" == type(tRemain) then
			if tRemain > 0 then
				VUHDO_updateShieldValue(aUnit, tSpellName, tRemain, nil);
			else
				VUHDO_removeShield(aUnit, tSpellName);
			end
		end
	end
end



--
local function VUHDO_getShieldLeftAmount(aUnit, aShieldName)
	return VUHDO_SHIELD_LEFT[aUnit][aShieldName] or 0;
end



--
local tInit, tValue;
function VUHDO_getShieldPerc(aUnit, aShield)
	tInit = VUHDO_SHIELD_SIZE[aUnit][aShield] or 0;

	if tInit > 0 then
		tValue = ceil(100 * (VUHDO_SHIELD_LEFT[aUnit][aShield] or 0) / tInit);
		return tValue > 100 and 100 or tValue;
	else
		return 0;
	end
end



--
local tSummeLeft;
function VUHDO_getUnitOverallShieldRemain(aUnit)
	return UnitGetTotalAbsorbs(aUnit) or 0;
end



--
local tUnit;
local VUHDO_DEBUFF_SHIELDS = { };
local tDelta, tShieldName;
function VUHDO_parseCombatLogShieldAbsorb(aMessage, aSrcGuid, aDstGuid, aShieldName, anAmount, aSpellId, anAbsorbAmount)
	tUnit = VUHDO_RAID_GUIDS[aDstGuid];
	if not tUnit then return; end

	if sMissedEvents[aMessage] then
		VUHDO_updateShields(tUnit);
		return;
	end

	--VUHDO_Msg(aSpellId);

	--[[if ("SPELL_AURA_APPLIED" == aMessage) then
	VUHDO_xMsg(aShieldName, aSpellId);
	end]]

	if VUHDO_SHIELDS[aSpellId] then

		if "SPELL_AURA_REFRESH" == aMessage then
			VUHDO_updateShieldValue(tUnit, aShieldName, anAmount, VUHDO_SHIELDS[aSpellId]);
		elseif "SPELL_AURA_APPLIED" == aMessage then
			VUHDO_initShieldValue(tUnit, aShieldName, anAmount, VUHDO_SHIELDS[aSpellId]);
			VUHDO_SHIELD_LAST_SOURCE_GUID[tUnit][aShieldName] = aSrcGuid;
		elseif "SPELL_AURA_REMOVED" == aMessage
			or "SPELL_AURA_BROKEN" == aMessage
			or "SPELL_AURA_BROKEN_SPELL" == aMessage then
			VUHDO_removeShield(tUnit, aShieldName);
		end
	elseif VUHDO_ABSORB_DEBUFFS[aSpellId] then

		if "SPELL_AURA_REFRESH" == aMessage then
			VUHDO_updateShieldValue(tUnit, aShieldName, VUHDO_ABSORB_DEBUFFS[aSpellId]());
		elseif "SPELL_AURA_APPLIED" == aMessage then
			VUHDO_initShieldValue(tUnit, aShieldName, VUHDO_ABSORB_DEBUFFS[aSpellId]());
			VUHDO_DEBUFF_SHIELDS[tUnit] = aShieldName;
		elseif "SPELL_AURA_REMOVED" == aMessage
			or "SPELL_AURA_BROKEN" == aMessage
			or "SPELL_AURA_BROKEN_SPELL" == aMessage then
			VUHDO_removeShield(tUnit, aShieldName);
			VUHDO_DEBUFF_SHIELDS[tUnit] = nil;
		end
	elseif "SPELL_HEAL" == aMessage or "SPELL_PERIODIC_HEAL" == aMessage
		and VUHDO_DEBUFF_SHIELDS[tUnit]
		and (tonumber(anAbsorbAmount) or 0) > 0 then
		tShieldName = VUHDO_DEBUFF_SHIELDS[tUnit];
		tDelta = VUHDO_getShieldLeftAmount(tUnit, tShieldName) - anAbsorbAmount;
		VUHDO_updateShieldValue(tUnit, tShieldName, tDelta, nil);
	elseif "UNIT_DIED" == aMessage then
		VUHDO_SHIELD_SIZE[tUnit] = nil;
		VUHDO_SHIELD_LEFT[tUnit] = nil;
		VUHDO_SHIELD_EXPIRY[tUnit] = nil;
		VUHDO_DEBUFF_SHIELDS[tUnit] = nil;
		VUHDO_SHIELD_LAST_SOURCE_GUID[tUnit] = nil;
	end

	VUHDO_updateBouquetsForEvent(tUnit, 36); -- VUHDO_UPDATE_SHIELD
	VUHDO_updateShieldBar(tUnit);
end
