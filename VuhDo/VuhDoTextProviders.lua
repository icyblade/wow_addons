local floor = floor;
local UnitPower = UnitPower;
local UnitPowerMax = UnitPowerMax;

local VUHDO_getIncHealOnUnit;
local VUHDO_getUnitOverallShieldRemain;

function VUHDO_textProvidersInitLocalOverrides()
	VUHDO_getIncHealOnUnit = _G["VUHDO_getIncHealOnUnit"];
	VUHDO_getUnitOverallShieldRemain = _G["VUHDO_getUnitOverallShieldRemain"];
end



--
local function VUHDO_chiCalculator(anInfo)
	if anInfo["connected"] and not anInfo["dead"] then
		return UnitPower(anInfo["unit"], SPELL_POWER_CHI), UnitPowerMax(anInfo["unit"], SPELL_POWER_CHI)
	else
		return 0, 0;
	end
end



--
local function VUHDO_holyPowerCalculator(anInfo)
	if anInfo["connected"] and not anInfo["dead"] then
		return UnitPower(anInfo["unit"], 9), UnitPowerMax(anInfo["unit"], 9);
	else
		return 0, 0;
	end
end



--
local tAmountInc;
local function VUHDO_overhealCalculator(anInfo)
	tAmountInc = VUHDO_getIncHealOnUnit(anInfo["unit"]);
	if tAmountInc > 0 and anInfo["connected"] and not anInfo["dead"] then
		return tAmountInc - anInfo["healthmax"] + anInfo["health"], nil;
	else
		return 0, nil;
	end
end


--
local tAmountInc;
local function VUHDO_incomingHealCalculator(anInfo)
	tAmountInc = VUHDO_getIncHealOnUnit(anInfo["unit"]);
	if tAmountInc > 0 and anInfo["connected"] and not anInfo["dead"] then
		return tAmountInc, nil;
	else
		return 0, nil;
	end
end


--
local function VUHDO_shieldAbsorbCalculator(anInfo)
	return VUHDO_getUnitOverallShieldRemain(anInfo["unit"]), nil;
end


--
local function VUHDO_manaCalculator(anInfo)
	if anInfo["powertype"] == 0 and anInfo["powermax"] > 0 then
		return anInfo["power"], anInfo["powermax"]
	else
		return 0, 0;
	end
end


--
local function VUHDO_threatCalculator(anInfo)
	return anInfo["threatPerc"], 100;
end



------------------------------------------------------------------



--
local function VUHDO_kiloValidator(anInfo, aValue)
	return aValue >= 500 and floor(aValue * 0.001 + 0.5) or "";
end


local function VUHDO_plusKiloValidator(anInfo, aValue)
	return aValue >= 500 and format("+%dk", aValue * 0.001 + 0.5) or "";
end

--
local function VUHDO_percentValidator(anInfo, aValue, aMaxValue)
	return anInfo["powertype"] == 0 and anInfo["powermax"] > 0
		and format("%d%%", 100 * aValue / aMaxValue) or "";
end

--
local function VUHDO_tenthPercentValidator(anInfo, aValue, aMaxValue)
	return anInfo["powertype"] == 0 and anInfo["powermax"] > 0
		and format("%d", 10 * aValue / aMaxValue) or "";
end


local function VUHDO_unitOfUnitValidator(anInfo, aValue, aMaxValue)
	return anInfo["powertype"] == 0 and format("%d/%d", aValue, aMaxValue) or "";
end

--
local function VUHDO_kiloOfKiloValidator(anInfo, aValue, aMaxValue)
	return anInfo["powertype"] == 0
		and format("%d/%d", floor(aValue * 0.001), floor(aMaxValue * 0.001)) or "";
end

--
local function VUHDO_absoluteValidator(anInfo, aValue)
	return aValue;
end



---------------------------------------------------------------------------------

function VUHDO_initTextProviderConfig()
  -- Falls man mal was löscht oder umbenennt
	for tIndicatorName, anIndicatorConfig in pairs(VUHDO_INDICATOR_CONFIG["TEXT_INDICATORS"]) do
		for tIndex, tProviderName in pairs(anIndicatorConfig["TEXT_PROVIDER"]) do
			if not VUHDO_TEXT_PROVIDERS[tProviderName] then
				anIndicatorConfig["TEXT_PROVIDER"][tIndex] = "";
			end
		end
	end
end

------------------------------------------------------------------------------------



VUHDO_TEXT_PROVIDERS = {
	["OVERHEAL_KILO_N_K"] = {
		["displayName"] = "Overheal: <#nk>",
		["calculator"] = VUHDO_overhealCalculator,
		["validator"] = VUHDO_kiloValidator,
		["interests"] = { VUHDO_UPDATE_INC, VUHDO_UPDATE_HEALTH, VUHDO_UPDATE_RANGE, VUHDO_UPDATE_HEALTH_MAX, VUHDO_UPDATE_ALIVE },
	},
	["OVERHEAL_KILO_PLUS_N_K"] = {
		["displayName"] = "Overheal: +<#n>k",
		["calculator"] = VUHDO_overhealCalculator,
		["validator"] = VUHDO_plusKiloValidator,
		["interests"] = { VUHDO_UPDATE_INC, VUHDO_UPDATE_HEALTH, VUHDO_UPDATE_RANGE, VUHDO_UPDATE_HEALTH_MAX, VUHDO_UPDATE_ALIVE },
	},
	["INCOMING_HEAL_NK"] = {
		["displayName"] = "Incoming Heal: <#nk>",
		["calculator"] = VUHDO_incomingHealCalculator,
		["validator"] = VUHDO_kiloValidator,
		["interests"] = { VUHDO_UPDATE_INC, VUHDO_UPDATE_HEALTH, VUHDO_UPDATE_RANGE, VUHDO_UPDATE_HEALTH_MAX, VUHDO_UPDATE_ALIVE },
	},
	["SHIELD_ABSORB_OVERALL_N_K"] = {
		["displayName"] = "Shield absorb total: <#nk>",
		["calculator"] = VUHDO_shieldAbsorbCalculator,
		["validator"] = VUHDO_kiloValidator,
		["interests"] = { VUHDO_UPDATE_SHIELD },
	},
	["THREAT_PERCENT"] = {
		["displayName"] = "Threat: <#n>%",
		["calculator"] = VUHDO_threatCalculator,
		["validator"] = VUHDO_percentValidator,
		["interests"] = { VUHDO_UPDATE_THREAT_PERC },
	},
	["CHI_N"] = {
		["displayName"] = "Chi: <#n>",
		["calculator"] = VUHDO_chiCalculator,
		["validator"] = VUHDO_absoluteValidator,
		["interests"] = { VUHDO_UPDATE_CHI, VUHDO_UPDATE_DC, VUHDO_UPDATE_ALIVE },
	},
	["HOLY_POWER_N"] = {
		["displayName"] = "Holy Power: <#n>",
		["calculator"] = VUHDO_holyPowerCalculator,
		["validator"] = VUHDO_absoluteValidator,
		["interests"] = { VUHDO_UPDATE_OWN_HOLY_POWER, VUHDO_UPDATE_DC, VUHDO_UPDATE_ALIVE },
	},
	["MANA_PERCENT"] = {
		["displayName"] = "Mana: <#n>%",
		["calculator"] = VUHDO_manaCalculator,
		["validator"] = VUHDO_percentValidator,
		["interests"] = { VUHDO_UPDATE_MANA, VUHDO_UPDATE_DC },
	},
	["MANA_PERCENT_TENTH"] = {
		["displayName"] = "Mana: <#n/10%>",
		["calculator"] = VUHDO_manaCalculator,
		["validator"] = VUHDO_tenthPercentValidator,
		["interests"] = { VUHDO_UPDATE_MANA, VUHDO_UPDATE_DC },
	},
	["MANA_UNIT_OF_UNIT"] = {
		["displayName"] = "Mana: <#n>/<#n>",
		["calculator"] = VUHDO_manaCalculator,
		["validator"] = VUHDO_unitOfUnitValidator,
		["interests"] = { VUHDO_UPDATE_MANA, VUHDO_UPDATE_DC },
	},
	["MANA_KILO_OF_KILO"] = {
		["displayName"] = "Mana: <#nk>/<#nk>",
		["calculator"] = VUHDO_manaCalculator,
		["validator"] = VUHDO_kiloOfKiloValidator,
		["interests"] = { VUHDO_UPDATE_MANA, VUHDO_UPDATE_DC },
	},
	["MANA_N"] = {
		["displayName"] = "Mana: <#n>",
		["calculator"] = VUHDO_manaCalculator,
		["validator"] = VUHDO_absoluteValidator,
		["interests"] = { VUHDO_UPDATE_MANA, VUHDO_UPDATE_DC },
	},
	["MANA_NK"] = {
		["displayName"] = "Mana: <#nk>",
		["calculator"] = VUHDO_manaCalculator,
		["validator"] = VUHDO_kiloValidator,
		["interests"] = { VUHDO_UPDATE_MANA, VUHDO_UPDATE_DC },
	},
}
