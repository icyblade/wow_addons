DeathNote.SurvivalIDs = {
	-- [48707] = { class = "DEATHKNIGHT", priority = 1 },	-- Anti-Magic Shell
	[50461] = { class = "DEATHKNIGHT", priority = 2  },	-- Anti-Magic Zone
	[49222] = { class = "DEATHKNIGHT", priority = 2  },	-- Bone Shield
	[48792] = { class = "DEATHKNIGHT", priority = 1  },	-- Icebound Fortitude
	[55233] = { class = "DEATHKNIGHT", priority = 3  },	-- Vampiric Blood

	[22812] = { class = "DRUID", priority = 2 },		-- Barkskin
	[22842] = { class = "DRUID", priority = 3 },		-- Frenzied Regeneration
	[61336] = { class = "DRUID", priority = 1 },		-- Survival Instincts

	[45438] = { class = "MAGE", priority = 1 },			-- Ice Block

	[86659] = { class = "PALADIN", priority = 1 },		-- Guardian of Ancient Kings
	[31850] = { class = "PALADIN", priority = 1 },		-- Ardent Defender
	[70940] = { class = "PALADIN", priority = 2 },		-- Divine Guardian
	[498] =   { class = "PALADIN", priority = 2 },		-- Divine Protection
	[64205] = { class = "PALADIN", priority = 1 },		-- Divine Sacrifice
	[642] =   { class = "PALADIN", priority = 1 },		-- Divine Shield
	[1022] =  { class = "PALADIN", priority = 2 },		-- Hand of Protection
	[6940] =  { class = "PALADIN", priority = 1 },		-- Hand of Sacrifice

	[47585] = { class = "PRIEST", priority = 1 },		-- Dispersion
	[33206] = { class = "PRIEST", priority = 1 },		-- Pain Suppression
	[47788] = { class = "PRIEST", priority = 1 },		-- Guardian Spirit
	[81782] = { class = "PRIEST", priority = 1 },		-- Power Word: Barrier

	[31224] = { class = "ROGUE", priority = 1 },		-- Cloak of Shadows
	[1966] =  { class = "ROGUE", priority = 2 },		-- Feint

	[30823] = { class = "SHAMAN", priority = 1 },		-- Shamanistic Rage

	[12975] = { class = "WARRIOR", priority = 3 },		-- Last Stand
	-- [2565] =  { class = "WARRIOR", priority = 3 },		-- Shield Block
	[871] =   { class = "WARRIOR", priority = 1 },		-- Shield Wall
	[97463] = { class = "WARRIOR", priority = 3 },		-- Rallying Cry
	
	-- bonus stuffs
	[105914] = { class = "WARRIOR", priority = 2 },		-- Shield Fortress	
	[105588] = { class = "DEATHKNIGHT", priority = 2  },-- Vampiric Brood
}

do
	DeathNote.SurvivalColors = {}

	for class, color in pairs(RAID_CLASS_COLORS) do
		local class_color = RAID_CLASS_COLORS[class]
		local color = { r = class_color.r, g  = class_color.g, b = class_color.b, a = 0.2 }
		DeathNote.SurvivalColors[class] = color
	end
end