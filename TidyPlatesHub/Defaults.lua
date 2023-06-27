
TidyPlatesHubCache = {}
TidyPlatesHubSettings = {}

TidyPlatesHubDefaults = {
	-- Style
	---------------------------------------
	StyleTheme = 3, 
	StyleEnemyMode = 1, 
	StyleFriendlyMode = 1,
	
	-- Opacity
	---------------------------------------
	OpacityTarget = 1,
	OpacityNonTarget = .5,
	OpacitySpotlightMode = 1,
	OpacitySpotlight = 1,
	OpacityFullSpell = false,				-- Bring Casting units to Full Opacity
	OpacityFullNoTarget = true,				-- Use full opacity when No Target
	OpacityFullMouseover = false,
	OpacityFiltered = 0,
	OpacityFilterNeutralUnits = false,		-- OpacityHideNeutral = false,
	OpacityFilterNonElite = false,			-- OpacityHideNonElites = false,
	OpacityFilterNPC = false,
	OpacityFilterFriendlyNPC = false,
	OpacityFilterInactive = false,
	OpacityFilterList = "Fanged Pit Viper",
	OpacityFilterLookup = {},

	-- Scale
	---------------------------------------
	ScaleStandard = 1,
	ScaleSpotlight = 1.2,
	ScaleSpotlightMode = 4, 
	ScaleIgnoreNeutralUnits = false,
	ScaleIgnoreNonEliteUnits = false,
	ScaleIgnoreInactive = false,
	ScaleCastingSpotlight = false,
	
	-- Text
	---------------------------------------
	TextHealthTextMode = 1,
	TextPlateFieldMode = 3,
	TextShowLevel = false,
	TextUseBlizzardFont = false,

	-- Color
	---------------------------------------
	ColorHealthBarMode = 3,
	ColorDangerGlowMode = 2,
	TextNameColorMode = 1,
	TextPlateNameColorMode = 1,
	ClassColorPartyMembers = false,
	
	-- Threat
	ColorAttackingMe = {r = .8, g = 0, b = 0,},		-- Orange
	ColorAggroTransition = {r = 255/255, g = 160/255, b = 0},	-- Yellow
	--ColorAggroTransition = {r = 255/255, g = 128/255, b = 0},	-- Orange
	--ColorAttackingOthers = {r = 15/255, g = 133/255, b = 255/255},		-- Bright Blue
	ColorAttackingOthers = {r = 15/255, g = 150/255, b = 230/255},	-- Bright Blue
	ColorAttackingOtherTank = {r = 15/255, g = 170/255, b = 200/255},	-- Bright Blue
	ColorShowPartyAggro = false,
	--ColorPartyAggro = {r = 255/255, g = 0, b = 0,},
	ColorPartyAggro = {r = 255/255, g = 0, b = .4,},
	ColorPartyAggroBar = false,
	ColorPartyAggroGlow = true,
	ColorPartyAggroText = false,
	
	
	-- Health
	---------------------------------------
	HighHealthThreshold = .7,
	LowHealthThreshold = .3,
	ColorLowHealth = {r = 1, g = 0, b = 0,},		-- Orange
	ColorMediumHealth = {r = 1, g = 1, b = 0},	-- Yellow
	ColorHighHealth = {r = 0, g = 1, b = .2},	-- Bright Blue
	
	-- Widgets
	---------------------------------------
	WidgetTargetHighlight = true,
	WidgetEliteIndicator = true,
	ClassEnemyIcon = false,
	ClassPartyIcon = false,
	WidgetsTotemIcon = false,
	WidgetsComboPoints = true,
	WidgetsThreatIndicator = true,
	WidgetsThreatIndicatorMode = 1,
	WidgetsRangeIndicator = false,
	WidgetsRangeMode = 1,
	WidgetsDebuff = true,
	WidgetsDebuffStyle = 1,
	WidgetsDebuffMode = 3,
	WidgetsDebuffTrackList = "My Rake\nMy Rip\nMy Moonfire\nAll 339",
	WidgetsDebuffLookup = {},
	WidgetsDebuffPriority = {},	
	
	-- Frame
	---------------------------------------
	FrameVerticalPosition = .7,
	AdvancedEnableUnitCache = true,
}








