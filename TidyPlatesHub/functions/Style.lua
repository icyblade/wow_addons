
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

------------------------------------------------------------------------------------
-- Style
------------------------------------------------------------------------------------

local BARMODE, HEADLINEMODE = 1, 2

local StyleModeFunctions = {
	--	Full Bars and Widgets
	function(unit)
		return BARMODE
	end,
	-- NameOnly
	function(unit)
		return HEADLINEMODE
	end,
	-- Bars during combat
	function(unit)
		if InCombatLockdown() then
			return BARMODE
		else return HEADLINEMODE end
	end,
	-- Bars when unit is active or damaged
	function(unit)
		if (unit.health < unit.healthmax) or (unit.threatValue > 1) or unit.isInCombat or unit.isMarked then
			return BARMODE
		end
		return HEADLINEMODE
	end,
	--[[
	-- elite units
	function(unit)
		if unit.isElite then
			return BARMODE
		else return HEADLINEMODE end
	end,
	--]]

	--[[
	-- marked
	function(unit)
		if unit.isMarked then
			return BARMODE
		else return HEADLINEMODE end
	end,
	--]]
		-- player chars
	function(unit)

		if unit.type == "PLAYER" then
			return BARMODE
		else return HEADLINEMODE end
	end,

	-- Current Target
	function(unit)
		if unit.isTarget == true then
			return BARMODE
		else return HEADLINEMODE end
	end,
	-- low threat
	function(unit)
		if InCombatLockdown() and unit.reaction ~= "FRIENDLY" then
			if IsTankedByAnotherTank(unit) then return HEADLINEMODE end
			if unit.threatValue < 2 and unit.health > 0 then return BARMODE end
		elseif LocalVars.ColorShowPartyAggro and unit.reaction == "FRIENDLY" then
			if GetAggroCondition(unit.rawName) == true then return BARMODE end
		end
		return HEADLINEMODE
	end,
}

local function StyleIndexDelegate(unit)
	local func

	if unit.reaction == "FRIENDLY" then func = StyleModeFunctions[LocalVars.StyleFriendlyMode]
	else func = StyleModeFunctions[LocalVars.StyleEnemyMode] end

	return func(unit)
end


------------------------------------------------------------------------------------
-- Binary Plate Styles
------------------------------------------------------------------------------------

local function StyleNameDelegate(unit)
	if StyleIndexDelegate(unit) == 2 then return "NameOnly"
	else return "Default" end
end


--[[
------------------------------------------------------------------
-- Experimental Style Delegate
------------------------------------------------------------------

local function IsThereText(unit)
	local text = CustomTextBinaryDelegate(unit)
	if text and text ~= "" then return true end
end

local function SetStyleTrinaryDelegate(unit)
	local style = StyleDelegate(unit)
	local widget = unit.frame.widgets.DebuffWidget

	if style == 2 then
		if IsThereText(unit) then
			return "NameOnly"
		else
			return "NameOnly-NoDescription"
		end
	elseif IsAuraShown(widget) then
		return "Default"
	else
		return "Default-NoAura"
	end
end
--]]


------------------------------------------------------------------------------
-- Local Variable
------------------------------------------------------------------------------

local function OnVariableChange(vars) LocalVars = vars end
HubData.RegisterCallback(OnVariableChange)


------------------------------------------------------------------------------
-- Add References
------------------------------------------------------------------------------
TidyPlatesHubFunctions.SetMultistyle = StyleIndexDelegate
TidyPlatesHubFunctions.SetStyleBinary = StyleNameDelegate
TidyPlatesHubFunctions.SetStyleNamed = StyleNameDelegate
--TidyPlatesHubFunctions.SetStyleTrinary = SetStyleTrinaryDelegate


