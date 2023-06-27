if not TidyPlatesThemeList then TidyPlatesThemeList = {} end

-------------------------------------------------------------------------------------
-- Template
-------------------------------------------------------------------------------------

local theme = {}
local defaultArtPath = "Interface\\Addons\\TidyPlates\\Media"
--local font =					"FONTS\\arialn.ttf"
local font =					NAMEPLATE_FONT
local EMPTY_TEXTURE = defaultArtPath.."\\Empty"

--[[  Theme elements
theme.hitbox 
theme.highlight
theme.healthborder
theme.eliteicon
theme.threatborder
theme.castborder
theme.castnostop 
theme.name
theme.level
theme.healthbar
theme.castbar
theme.spelltext
theme.customtext
theme.customart
theme.spellicon
theme.raidicon
theme.skullicon 
theme.frame
theme.target
theme.threatcolor
--]]

theme.hitbox = {
	width = 149,
	height = 40,
}

theme.highlight = {
	texture =					EMPTY_TEXTURE,
	width = 128,
	height = 64,
}

theme.healthborder = {
	texture		 =				EMPTY_TEXTURE,
	--elitetexture =					EMPTY_TEXTURE,
	--width = 128,
	width = 0,
	height = 64,
	x = 0,
	y = -5,
	anchor = "CENTER",
	show = true,
}

theme.eliteicon = {
	texture = EMPTY_TEXTURE,
	width = 128,
	height = 64,
	x = 0,
	y = -5,
	anchor = "CENTER",
	show = false,
}

theme.threatborder = {
	texture =			EMPTY_TEXTURE,
	--elitetexture =			EMPTY_TEXTURE,
	width = 128,
	height = 64,
	x = 0,
	y = -5,
	anchor = "CENTER",
	show = true,
}

theme.castborder = {
	texture =					EMPTY_TEXTURE,
	width = 128,
	height = 64,
	x = 0,
	y = -11,
	anchor = "CENTER",
	show = true,
}

theme.castnostop = {
	texture = 				EMPTY_TEXTURE,
	width = 128,
	height = 64,
	x = 0,
	y = -11,
	anchor = "CENTER",
	show = true,
}

theme.name = {
	typeface =					font,
	size = 9,
	width = 88,
	height = 10,
	x = 0,
	y = 1,
	align = "LEFT",
	anchor = "LEFT",
	vertical = "BOTTOM",
	shadow = true,
	flags = "NONE",
	show = true,
}

theme.level = {
	typeface =					font,
	size = 9,
	width = 25,
	height = 10,
	x = 36,
	y = 1,
	align = "RIGHT",
	anchor = "CENTER",
	vertical = "BOTTOM",
	shadow = true,
	flags = "NONE",
	show = true,
}

theme.healthbar = {
	texture =					 EMPTY_TEXTURE,
	backdrop = 				EMPTY_TEXTURE,
	height = 12,
	--width = 101,
	width = 0,
	x = 0,
	y = 10,
	anchor = "CENTER",
	orientation = "HORIZONTAL",
	
	linkwidth = false,
	edgeFile = EMPTY_TEXTURE,
	edgeSize = 1,
	edgeInset = { left = 0, right = 0, top = 0, bottom = 0, }	,		
}

theme.castbar = {
	texture =					EMPTY_TEXTURE,
	backdrop = 				EMPTY_TEXTURE,
	height = 12,
	width = 99,
	x = 0,
	y = -19,
	anchor = "CENTER",
	orientation = "HORIZONTAL",
	
	linkwidth = false,
	edgeFile = EMPTY_TEXTURE,
	edgeSize = 1,		-- Border thickness and corner size
	edgeInset = { left = 0, right = 0, top = 0, bottom = 0, },	-- Controls how far into the frame the background will be drawn (use higher values the thicker the edges are)
}

theme.spelltext = {
	typeface =					font,
	size = 9,
	width = 93,
	height = 10,
	x = 0,
	y = 11,
	align = "RIGHT",
	anchor = "CENTER",
	vertical = "BOTTOM",
	shadow = true,
	flags = "NONE",
	show = false,
}

theme.customtext = {
	typeface =					font,
	size = 8,
	width = 100,
	height = 10,
	x = 1,
	y = -19,
	align = "LEFT",
	anchor = "CENTER",
	vertical = "BOTTOM",
	shadow = true,
	flags = "NONE",
	show = false,
}

theme.customart = {
	width = 24,
	height = 24,
	x = -5,
	y = 10,
	anchor = "TOP",
	show = false,
}

theme.spellicon = {
	width = 18,
	height = 18,
	x = 62,
	y = -19,
	anchor = "CENTER",
	show = true,
}

theme.raidicon = {
	width = 20,
	height = 20,
	x = -35,
	y = 7,
	anchor = "TOP",
	show = true,
}

theme.skullicon = {
	texture = "Interface\\TargetingFrame\\UI-TargetingFrame-Skull",
	width = 14,
	height = 14,
	x = 44,
	y = 3,
	anchor = "CENTER",
	show = true,
}

theme.frame = {
	width = 101,
	height = 45,
	x = 0,
	y = 0,
	anchor = "CENTER",
}

theme.target = {
	texture = EMPTY_TEXTURE,
	width = 128,
	height = 64,
	x = 0,
	y = -5,
	anchor = "CENTER",
	show = false,
}

theme.threatcolor = {
	LOW = { r = .75, g = 1, b = 0, a= 1, },
	MEDIUM = { r = 1, g = 1, b = 0, a = 1, },
	HIGH = { r = 1, g = 0, b = 0, a = 1, },
}

--[[  Delegate Functions
-- Appearance and Indicators
theme.SetNameColor

theme.SetCustomText = function(unit) return "Text to Display" end
theme.SetScale = function(unit) local scale = 1; return scale end
theme.SetAlpha = function(unit) local alpha = 1; return alpha end
theme.SetHealthbarColor = function(unit) local r, g, b = 1, 1, 1; return r, g, b end
theme.SetThreatColor = function(unit) local r, g, b = 1, 1, 1, a; return r, g, b, a end

-- Advanced Behaviors & Widgets
theme.OnInitialize = function(frame) end
theme.OnUpdate = function(frame, unit) end
theme.OnContextUpdate = function(frame, unit) end	
theme.OnActivateTheme = function(themetable, themename)		-- Fired for each theme during unloading, and once for the incoming theme during loading

-- Special Objects
theme.ShowConfigPanel = function() end	-- This function is called when the 'wrench' icon is clicked in the theme chooser menu.  it can be used to activate a theme config panel
--]]

--[[
-- Unit Information Table 
unit.threatSituation				"LOW", "MEDIUM", "HIGH"	
unit.reaction						"FRIENDLY", "NEUTRAL", "HOSTILE"
unit.type							"NPC", "PLAYER"
unit.isBoss							true, if the skull icon is active (the creature is a boss/level ??)
unit.isDangerous					Same as isBoss
unit.isElite						true, if unit is elite (ie. elite symbol is shown)
unit.isMarked						true, if the unit is marked with a raid icon
unit.name							the unit's name
unit.alpha							float, the alpha of the nameplate (ie. 1 = target, Less than 1 = non-target)
unit.level							integer, the unit's level
unit.health							integer, the unit's health
unit.isMouseover					true, if the highlight region is showing (ie. mouse is over the frame)
unit.red, unit.green, unit.blue 	0.0-1 Values, the raw color of the health bar
unit.isCasting						true, if cast bar is being shown
_, unit.healthmax 					integer, the maximum health of the unit
unit.class 							"DEATHKNIGHT", "DRUID","HUNTER", etc.. Only for PvP Enemies
unit.isInCombat						true, if name text is red (ie. unit is in combat with you; Unreliable because of the way that Blizz's nameplates work)
unit.raidIcon
unit.threatValue
	0 - Unit has less than 100% raw threat (default UI shows no indicator)
	1 - Unit has 100% or higher raw threat but isn't mobUnit's primary target (default UI shows yellow indicator)
	2 - Unit is mobUnit's primary target, and another unit has 100% or higher raw threat (default UI shows orange indicator)
	3 - Unit is mobUnit's primary target, and no other unit has 100% or higher raw threat (default UI shows red indicator)
--]]
TidyPlates.Template = theme
TidyPlates:ActivateTheme(theme)		-- Activates the template as a holder theme, until the user preference is loaded

------------
-- "Name Only" Theme
------------
local NameOnlyTheme = TidyPlatesUtility.copyTable(TidyPlates.Template)

NameOnlyTheme.customtext = {
	size = 12,
	width = 200,
	height = 16,
	x = 0,
	y = 12,
	align = "CENTER",
	anchor = "CENTER",
	shadow = true,
	--flags = "OUTLINE",
	show = true,
}

NameOnlyTheme.level = {show = false,}
NameOnlyTheme.name = { show = false,}
NameOnlyTheme.skullicon = { show = false,}
NameOnlyTheme.spellicon = {show = false,}


-- Hex Colors
local TextColors = {}
TextColors.FRIENDLY = { NPC = "|cFF3cee35",	PLAYER = "|cFF5cb8ff", }
TextColors.HOSTILE = { NPC = "|cFFFF3535", PLAYER = "|cFFfc551b", }
TextColors.NEUTRAL = { 	NPC = "|cFFFFEE11" }

local TargetColors = {}
TargetColors.FRIENDLY = { NPC = "|cFF00FF00",	PLAYER = "|cFF0000FF", }
TargetColors.HOSTILE = { NPC = "|cFFFF0000", PLAYER = "|cFFFFEE", }
TargetColors.NEUTRAL = { 	NPC = "|cFFFFFF00" }

local function TextDelegate(unit)
	local TextColor
	--if unit.isTarget then TextColor = TargetColors[unit.reaction][unit.type] or ""
	--else TextColor = TextColors[unit.reaction][unit.type] or "" end
	TextColor = TextColors[unit.reaction][unit.type] or ""
	return TextColor..unit.name 
end

NameOnlyTheme.SetCustomText = TextDelegate

TidyPlatesThemeList["None"] = NameOnlyTheme

--[[
	
	Texture Coordinate Explanation
	coords.left, coords.right, coords.top, coords.bottom
	
	+----- 0 -----+
	|             |
	|             |
	0      | ---> 1
	|      |      |
	|      V      |
	+----- 1 -----+
	
	+----- 0 -----+
	|             |
	|      |      |
	0      V      1
	| ... 0.75 .. |
	|             |
	+----- 1 -----+
	
--]]