
local AddonName, HubData = ...;
local LocalVars = TidyPlatesHubDefaults


------------------------------------------------------------------------------
-- References
------------------------------------------------------------------------------
local InCombatLockdown = InCombatLockdown
local GetAggroCondition = TidyPlatesWidgets.GetThreatCondition
local IsTankedByAnotherTank = HubData.Functions.IsTankedByAnotherTank
local IsTankingAuraActive = HubData.Functions.IsTankingAuraActive
local IsHealer = TidyPlatesUtility.IsHealer
local IsAuraShown = TidyPlatesWidgets.IsAuraShown
local UnitFilter = TidyPlatesHubFunctions.UnitFilter
local function DummyFunction() end

------------------------------------------------------------------------------
-- Opacity / Alpha
------------------------------------------------------------------------------

-- By Low Health
local function AlphaFunctionByLowHealth(unit)
	if unit.health/unit.healthmax < LocalVars.LowHealthThreshold then return LocalVars.OpacitySpotlight end
end

-- By Threat (High)
local function AlphaFunctionByThreatHigh (unit)
	if InCombatLockdown() and unit.reaction ~= "FRIENDLY" then
		if unit.threatValue > 1 and unit.health > 0 then return LocalVars.OpacitySpotlight end
	elseif LocalVars.ColorShowPartyAggro and unit.reaction == "FRIENDLY" then
		if GetAggroCondition(unit.rawName) then return LocalVars.OpacitySpotlight end
	end
end

-- Tank Mode
local function AlphaFunctionByThreatLow (unit)
	if InCombatLockdown() and unit.reaction ~= "FRIENDLY" then
		if  IsTankedByAnotherTank(unit) then return end
		if unit.threatValue < 2 and unit.health > 0 then return LocalVars.OpacitySpotlight end
	elseif LocalVars.ColorShowPartyAggro and unit.reaction == "FRIENDLY" then
		if GetAggroCondition(unit.rawName) then return LocalVars.OpacitySpotlight end
	end
end

local function AlphaFunctionByMouseover(unit)
	if unit.isMouseover then return LocalVars.OpacitySpotlight end
end

local function AlphaFunctionByEnemy(unit)
	if unit.reaction ~= "FRIENDLY" then return LocalVars.OpacitySpotlight end
end

local function AlphaFunctionByNPC(unit)
	if unit.type == "NPC" then return LocalVars.OpacitySpotlight end
end

local function AlphaFunctionByRaidIcon(unit)
	if unit.isMarked then return LocalVars.OpacitySpotlight end
end

local function AlphaFunctionByActive(unit)
	if (unit.health < unit.healthmax) or (unit.threatValue > 1) or unit.isInCombat or unit.isMarked then return LocalVars.OpacitySpotlight end
end

local function AlphaFunctionByActiveAuras(unit)
	local widget = unit.frame.widgets.DebuffWidget
	--local widget = TidyPlatesWidgets.GetAuraWidgetByGUID(unit.guid)
	if IsAuraShown(widget) then return LocalVars.OpacitySpotlight end
end

-- By Enemy Healer
local function AlphaFunctionByEnemyHealer(unit)
	if unit.reaction == "HOSTILE" and unit.type == "PLAYER" then
		--if TidyPlatesCache and TidyPlatesCache.HealerListByName[unit.rawName] then
		if IsHealer(unit.rawName) then
			return LocalVars.OpacitySpotlight
		end
	end
end

-- By Threat (Auto Detect)
local function AlphaFunctionByThreat(unit)
		if (LocalVars.ThreatMode == THREATMODE_AUTO and IsTankingAuraActive())
			or LocalVars.ThreatMode == THREATMODE_TANK then
				return AlphaFunctionByThreatLow(unit)	-- tank mode
		else return AlphaFunctionByThreatHigh(unit) end
end


local function AlphaFunctionGroupMembers(unit)
	local class = TidyPlatesUtility.GroupMembers.Class[unit.name]
	if class then return LocalVars.OpacitySpotlight end
end


local function AlphaFunctionByPlayers(unit)
	if unit.type == "PLAYER" then return LocalVars.OpacitySpotlight end
end


local AlphaFunctionsEnemy = { 	DummyFunction,
	AlphaFunctionByThreat, AlphaFunctionByLowHealth,
	AlphaFunctionByNPC, AlphaFunctionByActiveAuras,
	AlphaFunctionByEnemyHealer, AlphaFunctionByActive,
}

local AlphaFunctionsFriendly = {DummyFunction,
	AlphaFunctionByLowHealth, AlphaFunctionGroupMembers,
	AlphaFunctionByPlayers,  AlphaFunctionByActive,
}



-- Alpha Functions Listed by Role order: Damage, Tank, Heal
local AlphaFunctions = {AlphaFunctionsDamage, AlphaFunctionsTank}

local function Diminish(num)
	if num == 1 then return 1
	elseif num < .3 then return num*.60
	elseif num < .6 then return num*.70
	else return num * .80 end
end

local function AlphaDelegate(...)
	local unit = ...
	local alpha

	if LocalVars.UnitSpotlightOpacityEnable and LocalVars.UnitSpotlightLookup[unit.name] then
		return LocalVars.UnitSpotlightOpacity
	end

	if unit.isTarget then return Diminish(LocalVars.OpacityTarget)
	elseif unit.isCasting and unit.reaction == "HOSTILE" and LocalVars.OpacitySpotlightSpell then alpha = LocalVars.OpacitySpotlight
	elseif unit.isMouseover and LocalVars.OpacitySpotlightMouseover then alpha = LocalVars.OpacitySpotlight
	elseif unit.isMarked and LocalVars.OpacitySpotlightRaidMarked then alpha = LocalVars.OpacitySpotlight

	else
		-- Filter
		if UnitFilter(unit) then alpha = LocalVars.OpacityFiltered
		-- Spotlight
		else
			local func = DummyFunction

			if unit.reaction == "FRIENDLY" then
				func = AlphaFunctionsFriendly[LocalVars.FriendlyAlphaSpotlightMode] or func
			else
				func = AlphaFunctionsEnemy[LocalVars.EnemyAlphaSpotlightMode] or func
			end

			alpha = func(...)
		end
	end


	if alpha then return Diminish(alpha)
	else
		if (not UnitExists("target")) and LocalVars.OpacityFullNoTarget then return Diminish(LocalVars.OpacityTarget)
		else return Diminish(LocalVars.OpacityNonTarget) end
	end
end

------------------------------------------------------------------------------
-- Local Variable
------------------------------------------------------------------------------

local function OnVariableChange(vars) LocalVars = vars end
HubData.RegisterCallback(OnVariableChange)


------------------------------------------------------------------------------
-- Add References
------------------------------------------------------------------------------
TidyPlatesHubFunctions.SetAlpha = AlphaDelegate

