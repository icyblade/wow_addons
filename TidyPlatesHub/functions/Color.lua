
local AddonName, HubData = ...;
local LocalVars = TidyPlatesHubDefaults



------------------------------------------------------------------
-- Color Definitions
------------------------------------------------------------------
local RaidClassColors = RAID_CLASS_COLORS

local RaidIconColors = {
	["STAR"] = {r = 251/255, g = 240/255, b = 85/255,},
	["MOON"] = {r = 100/255, g = 180/255, b = 255/255,},
	["CIRCLE"] = {r = 230/255, g = 116/255, b = 11/255,},
	["SQUARE"] = {r = 0, g = 174/255, b = 1,},
	["DIAMOND"] = {r = 207/255, g = 49/255, b = 225/255,},
	--["CROSS"] = {r = 195/255, g = 38/255, b = 23/255,},
	["CROSS"] = {r = 255/255, g = 130/255, b = 100/255,},
	["TRIANGLE"] = {r = 31/255, g = 194/255, b = 27/255,},
	["SKULL"] = {r = 244/255, g = 242/255, b = 240/255,},
}

local ReactionColors = HubData.Colors.ReactionColors
local NameReactionColors = HubData.Colors.NameReactionColors

------------------------------------------------------------------
-- References
------------------------------------------------------------------
local GetAggroCondition = TidyPlatesWidgets.GetThreatCondition
local IsFriend = TidyPlatesUtility.IsFriend
local IsHealer = TidyPlatesUtility.IsHealer
local IsGuildmate = TidyPlatesUtility.IsGuildmate
local IsTankedByAnotherTank = HubData.Functions.IsTankedByAnotherTank
local IsTankingAuraActive = HubData.Functions.IsTankingAuraActive
local InCombatLockdown = InCombatLockdown
local GetFriendlyClass = HubData.Functions.GetFriendlyClass
local GetEnemyClass = HubData.Functions.GetEnemyClass
local StyleDelegate = TidyPlatesHubFunctions.SetMultistyle

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Health Bar Color
------------------------------------------------------------------------------
------------------------------------------------------------------------------
local tempColor = {}
local function DummyFunction() return end

-- By Low Health
local function ColorFunctionByHealth(unit)
	local health = unit.health/unit.healthmax
	if health > LocalVars.HighHealthThreshold then return LocalVars.ColorHighHealth
	elseif health > LocalVars.LowHealthThreshold then return LocalVars.ColorMediumHealth
	else return LocalVars.ColorLowHealth end
end

HubData.Functions.ColorFunctionByHealth = ColorFunctionByHealth

--"By Class"
local function ColorFunctionByClassEnemy(unit)
	local class

	if unit.type == "PLAYER" then
		-- Determine Unit Class
		if unit.reaction ~= "FRIENDLY" then class = unit.class or GetEnemyClass(unit.name) end

		-- Return Color
		if class and RaidClassColors[class] then
			return RaidClassColors[class] end
	end

	-- For unit types with no Class info available, the function returns nil (meaning, default reaction color)
end

local function ColorFunctionByClassFriendly(unit)
	local class

	if unit.type == "PLAYER" then
		-- Determine Unit Class
		if unit.reaction == "FRIENDLY" then class = GetFriendlyClass(unit.name)	end

		-- Return Color
		if class and RaidClassColors[class] then
			return RaidClassColors[class]
		end
	end

	-- For unit types with no Class info available, the function returns nil (meaning, default reaction color)
end

local function ColorFunctionBlack()
	return Black
end

--[[
unit.threatValue
	0 - Unit has less than 100% raw threat (default UI shows no indicator)
	1 - Unit has 100% or higher raw threat but isn't mobUnit's primary target (default UI shows yellow indicator)
	2 - Unit is mobUnit's primary target, and another unit has 100% or higher raw threat (default UI shows orange indicator)
	3 - Unit is mobUnit's primary target, and no other unit has 100% or higher raw threat (default UI shows red indicator)

	ColorAttackingMe		Warning
	ColorAggroTransition	Transition
	ColorAttackingOthers	Safe
--]]

local function ColorFunctionByReaction(unit)
	if unit.reaction == "FRIENDLY" and unit.type == "PLAYER" then
		if IsGuildmate(unit.name) then return LocalVars.ColorGuildMember
		elseif IsFriend(unit.name) then return LocalVars.ColorGuildMember end
	end

	return ReactionColors[unit.reaction][unit.type]
end

local function ColorFunctionDamage(unit)
	if unit.threatValue > 1 then return LocalVars.ColorAttackingMe				-- When player is unit's target		-- Warning
	elseif unit.threatValue == 1 then return LocalVars.ColorAggroTransition											-- Transition
	else return LocalVars.ColorAttackingOthers end																	-- Safe
end

local function ColorFunctionRawTank(unit)

	if unit.threatValue > 2 then
		return LocalVars.ColorAttackingMe							-- When player is solid target, ie. Safe
	else
		--if IsTankedByAnotherTank(unit) then return LocalVars.ColorAttackingOtherTank		-- When unit is tanked by another
		if unit.threatValue == 2 then return LocalVars.ColorAggroTransition				-- Transition
		else return LocalVars.ColorAttackingOthers end										-- Warning
	end
end

local function ColorFunctionTankSwapColors(unit)

	if unit.threatValue > 2 then
		return LocalVars.ColorAttackingOthers				-- When player is solid target		-- Safe
	else
		--if IsTankedByAnotherTank(unit) then return LocalVars.ColorAttackingOtherTank			-- When unit is tanked by another
		if unit.threatValue == 2 then return LocalVars.ColorAggroTransition					-- Transition
		else return LocalVars.ColorAttackingMe end												-- Warning
	end
end


local function ColorFunctionByThreat(unit)
	if InCombatLockdown() and unit.reaction ~= "FRIENDLY" and unit.type == "NPC" then

		if IsTankedByAnotherTank(unit) then return LocalVars.ColorAttackingOtherTank end

		if LocalVars.ThreatMode == THREATMODE_AUTO and TidyPlatesWidgets.IsTankingAuraActive then
			return ColorFunctionTankSwapColors(unit)
		elseif LocalVars.ThreatMode == THREATMODE_TANK then
			return ColorFunctionRawTank(unit)
		else return ColorFunctionDamage(unit) end

	else
		return RaidClassColors[unit.class or ""] or ReactionColors[unit.reaction][unit.type]
		--return ReactionColors[unit.reaction][unit.type]
	end

end


-- By Raid Icon
local function ColorFunctionByRaidIcon(unit)
	return RaidIconColors[unit.raidIcon]
end

-- By Level Color
local function ColorFunctionByLevelColor(unit)
	tempColor.r, tempColor.g, tempColor.b = unit.levelcolorRed, unit.levelcolorGreen, unit.levelcolorBlue
	return tempColor
end

local FriendlyBarFunctions = {DummyFunction, ColorFunctionByReaction, ColorFunctionByClassFriendly,
								ColorFunctionByHealth, }

local EnemyBarFunctions = {DummyFunction, ColorFunctionByThreat, ColorFunctionByReaction,
								ColorFunctionByClassEnemy, ColorFunctionByHealth, }

------------------
local function HealthColorDelegate(unit)

	local color, class

	-- Group Member Aggro Coloring
	if unit.reaction == "FRIENDLY"  then
		if LocalVars.ColorShowPartyAggro and LocalVars.ColorPartyAggroBar then
			if GetAggroCondition(unit.rawName) then color = LocalVars.ColorPartyAggro end
		end
	elseif unit.reaction == "TAPPED" then
		color = LocalVars.ColorTapped
	end

	-- Color Mode / Color Spotlight
	if not color then
		local mode = 1
		local func

		if unit.reaction == "FRIENDLY" then
			func = FriendlyBarFunctions[LocalVars.ColorFriendlyBarMode] or DummyFunction
		else
			func = EnemyBarFunctions[LocalVars.ColorEnemyBarMode] or DummyFunction
		end

		--local func = ColorFunctions[mode] or DummyFunction
		color = func(unit)
	end

	if LocalVars.UnitSpotlightBarEnable and LocalVars.UnitSpotlightLookup[unit.name] then
		color = LocalVars.UnitSpotlightColor
	end

	if color then
		return color.r, color.g, color.b, 1	--, color.r/4, color.g/4, color.b/4, 1
	else return unit.red, unit.green, unit.blue end
end

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Cast Bar Color
------------------------------------------------------------------------------
------------------------------------------------------------------------------
local function CastBarDelegate(unit)
	local color, alpha
	if unit.spellInterruptible then
		color = LocalVars.ColorNormalSpellCast
	else color = LocalVars.ColorUnIntpellCast end

	if unit.reaction ~= "FRIENDLY" or LocalVars.SpellCastEnableFriendly then alpha = 1
	else alpha = 0 end

	return color.r, color.g, color.b, alpha
end



------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Warning Border Color
------------------------------------------------------------------------------
------------------------------------------------------------------------------
local WarningColor = {}

-- Player Health (na)
local function WarningBorderFunctionByPlayerHealth(unit)
	local healthPct = UnitHealth("player")/UnitHealthMax("player")
	if healthPct < .3 then return DarkRed end
end

-- By Enemy Healer
local function WarningBorderFunctionByEnemyHealer(unit)
	if unit.reaction == "HOSTILE" and unit.type == "PLAYER" then
		--if TidyPlatesCache and TidyPlatesCache.HealerListByName[unit.rawName] then

		if IsHealer(unit.rawName) then
			return RaidClassColors[unit.class or ""] or ReactionColors[unit.reaction][unit.type]
		end
	end
end

-- "By Threat (High) Damage"
local function WarningBorderFunctionByThreatDamage(unit)
	if InCombatLockdown and unit.reaction ~= "FRIENDLY" and unit.type == "NPC" then
		if unit.threatValue > 0 then
			return ColorFunctionDamage(unit)
		end
	end
end

-- "By Threat (Low) Tank"
local function WarningBorderFunctionByThreatTank(unit)
	if InCombatLockdown() and unit.reaction ~= "FRIENDLY" and unit.type == "NPC" then
		if unit.threatValue < 3 then
			if IsTankedByAnotherTank(unit) then return else	return ColorFunctionRawTank(unit) end
		end
	end
end


-- Warning Glow (Auto Detect)
local function WarningBorderFunctionByThreat(unit)
	if InCombatLockdown() and unit.reaction ~= "FRIENDLY" and unit.type == "NPC" then
		if (LocalVars.ThreatMode == THREATMODE_AUTO and TidyPlatesWidgets.IsTankingAuraActive)
			or LocalVars.ThreatMode == THREATMODE_TANK then
				if IsTankedByAnotherTank(unit) then return
				elseif unit.threatValue == 2 then return LocalVars.ColorAggroTransition
				elseif unit.threatValue < 2 then return LocalVars.ColorAttackingMe	end
		elseif unit.threatValue > 0 then return ColorFunctionDamage(unit) end
	else
		-- Add healer tracking
		return WarningBorderFunctionByEnemyHealer(unit)

	end
end


local WarningBorderFunctionsUniversal = { DummyFunction, WarningBorderFunctionByThreat,
			WarningBorderFunctionByEnemyHealer }

local function ThreatColorDelegate(unit)
	local color

	--LocalVars.ThreatGlowEnable

	-- Friendly Unit Aggro
	if LocalVars.ColorShowPartyAggro and LocalVars.ColorPartyAggroGlow and unit.reaction == "FRIENDLY" then
		if GetAggroCondition(unit.rawName) then color = LocalVars.ColorPartyAggro end

	-- Enemy Units
	else

		-- NPCs
		if LocalVars.ThreatGlowEnable then
			color = WarningBorderFunctionByThreat(unit)
		end

		-- Players
		-- Check for Healer?  By Threat already does this.
	end

	if LocalVars.UnitSpotlightGlowEnable and LocalVars.UnitSpotlightLookup[unit.name] then
		color = LocalVars.UnitSpotlightColor
	end

	if color then return color.r, color.g, color.b, 1
	else return 0, 0, 0, 0 end
end



------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Name Text Color
------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- By Reaction
local function NameColorByReaction(unit)
	if IsGuildmate(unit.name) then return LocalVars.TextColorGuildMember
	elseif IsFriend(unit.name) then return LocalVars.TextColorGuildMember end

	return NameReactionColors[unit.reaction][unit.type]
end

-- By Significance
local function NameColorBySignificance(unit)
	-- [[
	if unit.reaction ~= "FRIENDLY" then
		if unit.isTarget then return White
		elseif unit.isBoss or unit.isMarked then return BossGrey
		elseif unit.isElite or (unit.levelcolorRed > .9 and unit.levelcolorGreen < .9) then return EliteGrey
		else return NormalGrey end
	else
		return NameColorByReaction(unit)
	end
	--]]
	--[[
	if unit.reaction == "FRIENDLY" then return White
	elseif unit.isBoss or unit.isMarked then return BossGrey
	elseif unit.isElite or (unit.levelcolorRed > .9 and unit.levelcolorGreen < .9) then return EliteGrey
	else return NormalGrey end
	--]]
end

local function NameColorByClass(unit)
	local class, color

	if unit.type == "PLAYER" then
		-- Determine Unit Class
		if unit.reaction == "FRIENDLY" then class = GetFriendlyClass(unit.name)
		else class = unit.class or GetEnemyClass(unit.name); end

		-- Return color
		if class and RaidClassColors[class] then
			return RaidClassColors[class] end
	end

	-- For unit types with no Class info available, return reaction color
	return NameReactionColors[unit.reaction][unit.type]
end


local function NameColorByFriendlyClass(unit)
	local class, color

	if unit.type == "PLAYER" and unit.reaction == "FRIENDLY" then
		-- Determine Unit Class
		class = GetFriendlyClass(unit.name)
		--print(unit.name, class)

		-- Return color
		if class and RaidClassColors[class] then
			return RaidClassColors[class] end
	end

	-- For unit types with no Class info available, return reaction color
	return NameReactionColors[unit.reaction][unit.type]
end



local function NameColorByEnemyClass(unit)
	local class, color

	if unit.type == "PLAYER" and unit.reaction == "HOSTILE" then
		class = unit.class or GetEnemyClass(unit.name)

		-- Return color
		if class and RaidClassColors[class] then
			return RaidClassColors[class] end
	end

	-- For unit types with no Class info available, return reaction color
	return NameReactionColors[unit.reaction][unit.type]
end

local function NameColorByClass(unit)
	if unit.reaction == "HOSTILE" then
		return NameColorByEnemyClass(unit)
	else
		return NameColorByFriendlyClass(unit)
	end
end

local function NameColorByThreat(unit)
	if InCombatLockdown() then return ColorFunctionByThreat(unit)
	else return RaidClassColors[unit.class or ""] or NameReactionColors[unit.reaction][unit.type] end
end

local SemiWhite = {r=1, g=1, b=1, a=.8}
local SemiWhiter = {r=1, g=1, b=1, a=.9}
local SemiYellow = {r=1, g=1, b=.8, a=1}
-- GoldColor, YellowColor
local function NameColorDefault(unit)
	return White
end

local NameColorFunctions = {
	-- Default
	NameColorDefault,
	-- By Class
	NameColorByClass,
	--NameColorByClass,
	-- By Threat
	NameColorByThreat,
	-- By Reaction
	NameColorByReaction,
	-- By Health
	ColorFunctionByHealth,
	-- By Level Color
	ColorFunctionByLevelColor,
	-- By Significance
	NameColorBySignificance,
}

-- [[
local function SetNameColorDelegate(unit)
	local color, colorMode
	local alphaFade = 1

	--if unit.isTarget or unit.isMouseover then alphaFade = 1
	--else alphaFade = .8 end

	--if unit.guid then alphaFade = 1
	--else alphaFade = .6 end


	if unit.reaction == "FRIENDLY" then
		-- Party Aggro Coloring -- Overrides the normal coloring
		if LocalVars.ColorShowPartyAggro and LocalVars.ColorPartyAggroText then
			if GetAggroCondition(unit.rawName) then color = LocalVars.ColorPartyAggro end
		end
	elseif unit.reaction == "TAPPED"  then
		color = LocalVars.ColorTapped
	end

	if not color then
		if StyleDelegate(unit) == 2 then

			if unit.reaction == "FRIENDLY" then
				colorMode = tonumber(LocalVars.HeadlineFriendlyColor)
			else
				colorMode = tonumber(LocalVars.HeadlineEnemyColor)
			end

		else
			--colorMode = tonumber(LocalVars.TextNameColorMode)
			if unit.reaction == "FRIENDLY" then colorMode = LocalVars.ColorFriendlyNameMode
			else colorMode = LocalVars.ColorEnemyNameMode
			end

		end

		local func = NameColorFunctions[colorMode or 1] or DummyFunction
		color = func(unit)
	end

	if color then
		return color.r, color.g, color.b , ((color.a or 1) * alphaFade)
	--elseif unit.isMouseover then
		--return 1, 1, 0, 1*alphaFade
	else
		return 1, 1, 1, 1*alphaFade
	end
end
--]]

------------------------------------------------------------------------------
-- Local Variable
------------------------------------------------------------------------------

local function OnVariableChange(vars)
	LocalVars = vars
	if (EnemyBarFunctions[LocalVars.ColorEnemyBarMode] == ColorFunctionByThreat) or LocalVars.ThreatGlowEnable then
		SetCVar("threatWarning", 3)
	end
end
HubData.RegisterCallback(OnVariableChange)


------------------------------------------------------------------------------
-- Add References
------------------------------------------------------------------------------
TidyPlatesHubFunctions.SetHealthbarColor = HealthColorDelegate
TidyPlatesHubFunctions.SetCastbarColor = CastBarDelegate
TidyPlatesHubFunctions.SetThreatColor = ThreatColorDelegate
TidyPlatesHubFunctions.SetNameColor = SetNameColorDelegate




