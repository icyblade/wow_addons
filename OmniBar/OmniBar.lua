
-- OmniBar by Jordon

local addonName, L = ...

local cooldowns = {
	[47476]  = { default = true,  duration = 60,  class = "DEATHKNIGHT" },                                   -- Strangulate
	[47481]  = { default = false, duration = 60,  class = "DEATHKNIGHT", specID = { 252 } },                 -- Gnaw (Ghoul)
	[47482]  = { default = false, duration = 30,  class = "DEATHKNIGHT", specID = { 252 } },                 -- Leap (Ghoul)
	[47528]  = { default = true,  duration = 15,  class = "DEATHKNIGHT" },                                   -- Mind Freeze
	[48707]  = { default = false, duration = 45,  class = "DEATHKNIGHT" },                                   -- Anti-Magic Shell
	[48743]  = { default = false, duration = 120, class = "DEATHKNIGHT" },                                   -- Death Pact
	[48792]  = { default = false, duration = 180, class = "DEATHKNIGHT" },                                   -- Icebound Fortitude
	[49028]  = { default = false, duration = 90,  class = "DEATHKNIGHT", specID = { 250 } },                 -- Dancing Rune Weapon
	[49039]  = { default = false, duration = 120, class = "DEATHKNIGHT" },                                   -- Lichborne
	[49576]  = { default = false, duration = 25,  class = "DEATHKNIGHT" },                                   -- Death Grip
	[51052]  = { default = false, duration = 120, class = "DEATHKNIGHT" },                                   -- Anti-Magic Zone
	[51271]  = { default = false, duration = 60,  class = "DEATHKNIGHT", specID = { 251 } },                 -- Pillar of Frost
	[55233]  = { default = false, duration = 60,  class = "DEATHKNIGHT", specID = { 250 } },                 -- Vampiric Blood
	[77606]  = { default = false, duration = 30,  class = "DEATHKNIGHT" },                                   -- Dark Simulacrum
	[91802]  = { default = true,  duration = 30,  class = "DEATHKNIGHT", specID = { 252 } },                 -- Shambling Rush
	-- [96268]  = { default = false, duration = 30,  class = "DEATHKNIGHT" },                                   -- Death's Advance
	[108194] = { default = false, duration = 30,  class = "DEATHKNIGHT" },                                   -- Asphyxiate
	[108201] = { default = false, duration = 120, class = "DEATHKNIGHT" },                                   -- Desecrated Ground
	[152279] = { default = false, duration = 120, class = "DEATHKNIGHT" },                                   -- Breath of Sindragosa
	[498]    = { default = false, duration = 30,  class = "PALADIN" },                                       -- Divine Protection
	[642]    = { default = false, duration = 150, class = "PALADIN" },                                       -- Divine Shield
	[853]    = { default = false, duration = 60,  class = "PALADIN" },                                       -- Hammer of Justice
	    -- [105593] = { parent = 853, duration = 30 },                                                          -- Fist of Justice
	[1022]   = { default = false, duration = 300, class = "PALADIN", charges = 2 },                          -- Hand of Protection
	[1044]   = { default = false, duration = 25,  class = "PALADIN", charges = 2 },                          -- Hand of Freedom
	[6940]   = { default = false, duration = { default = 90, [65] = 110 }, class = "PALADIN", charges = 2 }, -- Hand of Sacrifice
	[20066]  = { default = false, duration = 15,  class = "PALADIN" },                                       -- Repentance
	[31821]  = { default = false, duration = 180, class = "PALADIN", specID = { 65 } },                      -- Devotion Aura
	[31884]  = { default = false, duration = 120, class = "PALADIN" },                                       -- Avenging Wrath
	[96231]  = { default = true,  duration = 15,  class = "PALADIN" },                                       -- Rebuke
	-- [114039] = { default = false, duration = 30,  class = "PALADIN" },                                       -- Hand of Purity
	[114157] = { default = false, duration = 60,  class = "PALADIN" },                                       -- Execution Sentence
	[115750] = { default = false, duration = 120, class = "PALADIN" },                                       -- Blinding Light
	[871]    = { default = false, duration = 180, class = "WARRIOR", specID = { 73 } },                      -- Shield Wall
	[1719]   = { default = false, duration = 180, class = "WARRIOR", specID = { 71, 72 } },                  -- Recklessness
	[3411]   = { default = false, duration = 30,  class = "WARRIOR" },                                       -- Intervene
	[5246]   = { default = false, duration = 90,  class = "WARRIOR" },                                       -- Intimidating Shout
	[6544]   = { default = false, duration = 45,  class = "WARRIOR" },                                       -- Heroic Leap
	[6552]   = { default = true,  duration = 15,  class = "WARRIOR" },                                       -- Pummel
	[18499]  = { default = false, duration = 30,  class = "WARRIOR" },                                       -- Berserker Rage
	[23920]  = { default = false, duration = 25,  class = "WARRIOR" },                                       -- Spell Reflection
		[114028] = { parent = 23920, duration = 30 },                                                        -- Mass Spell Reflection
	[46968]  = { default = false, duration = 20,  class = "WARRIOR" },                                       -- Shockwave
	[107570] = { default = false, duration = 30,  class = "WARRIOR" },                                       -- Storm Bolt
	[107574] = { default = false, duration = 90,  class = "WARRIOR" },                                       -- Avatar
	[114029] = { default = false, duration = 30,  class = "WARRIOR" },                                       -- Safeguard
	[118000] = { default = false, duration = 60,  class = "WARRIOR" },                                       -- Dragon Roar
	[118038] = { default = false, duration = 120, class = "WARRIOR", specID = { 71, 72 } },                  -- Die by the Sword
	[99]     = { default = false, duration = 30,  class = "DRUID" },                                         -- Disorienting Roar
	[5211]   = { default = false, duration = 50,  class = "DRUID" },                                         -- Bash
	[22812]  = { default = false, duration = 60,  class = "DRUID", specID = { 102, 104, 105 } },             -- Barkskin
	[33891]  = { default = false, duration = 180, class = "DRUID", specID = { 105 } },                       -- Incarnation: Tree of Life
	-- [50334]  = { default = false, duration = 180, class = "DRUID", specID = { 103, 104 } },                  -- Berserk
	[61336]  = { default = false, duration = 180, class = "DRUID", specID = { 103, 104 }, charges = 2 },     -- Survival Instincts
	[78675]  = { default = true,  duration = 60,  class = "DRUID", specID = { 102 } },                       -- Solar Beam
	[102280] = { default = false, duration = 30,  class = "DRUID" },                                         -- Displacer Beast
	[102342] = { default = false, duration = 60,  class = "DRUID", specID = { 105 } },                       -- Ironbark
	[102359] = { default = false, duration = 30,  class = "DRUID" },                                         -- Mass Entanglement
	[102543] = { default = false, duration = 180, class = "DRUID", specID = { 103 } },                       -- Incarnation: King of the Jungle
	[102560] = { default = false, duration = 180, class = "DRUID", specID = { 102 } },                       -- Incarnation: Chosen of Elune
	[106839] = { default = true,  duration = 15,  class = "DRUID", specID = { 103, 104 } },                  -- Skull Bash
	-- [108291] = { default = false, duration = 360, class = "DRUID" },                                         -- Heart of the Wild (Balance)
		-- [108292] = { parent = 108291 },                                                                      -- Heart of the Wild (Feral)
		-- [108293] = { parent = 108291 },                                                                      -- Heart of the Wild (Guardian)
		-- [108294] = { parent = 108291 },                                                                      -- Heart of the Wild (Resto)
	-- [112071] = { default = false, duration = 180, class = "DRUID", specID = { 102 } },                       -- Celestial Alignment
	[124974] = { default = false, duration = 90,  class = "DRUID" },                                         -- Nature's Vigil
	-- [132158] = { default = false, duration = 60,  class = "DRUID", specID = { 105 } },                       -- Nature's Swiftness
	[132469] = { default = false, duration = 30,  class = "DRUID" },                                         -- Typhoon
	-- [159630] = { default = false, duration = 90,  class = "PRIEST", specID = { 256, 257 } },                 -- Shadow Magic
	[8122]   = { default = false, duration = 30,  class = "PRIEST" },                                        -- Psychic Scream
	[15487]  = { default = true,  duration = 45,  class = "PRIEST", specID = { 256, 258 } },                 -- Silence
	[33206]  = { default = false, duration = 120, class = "PRIEST", specID = { 256 } },                      -- Pain Suppression
	[47585]  = { default = false, duration = 120, class = "PRIEST", specID = { 258 } },                      -- Dispersion
	[47788]  = { default = false, duration = 180, class = "PRIEST", specID = { 257 } },                      -- Guardian Spirit
	[64044]  = { default = false, duration = 45,  class = "PRIEST", specID = { 258 } },                      -- Psychic Horror
	[73325]  = { default = false, duration = 90,  class = "PRIEST" },                                        -- Leap of Faith
	[5484]   = { default = false, duration = 40,  class = "WARLOCK" },                                       -- Howl of Terror
	[6360]   = { default = false, duration = 25,  class = "WARLOCK" },                                       -- Whiplash
	[6789]   = { default = false, duration = 45,  class = "WARLOCK" },                                       -- Mortal Coil
	-- [19505]  = { default = false, duration = 15,  class = "WARLOCK" },                                       -- Devour Magic (Felhunter)
	[30283]  = { default = false, duration = 30,  class = "WARLOCK" },                                       -- Shadowfury
	[48020]  = { default = false, duration = 26,  class = "WARLOCK" },                                       -- Demonic Portal
	[89766]  = { default = false, duration = 30,  class = "WARLOCK" },                                       -- Axe Toss
	-- [108482] = { default = false, duration = 120, class = "WARLOCK" },                                       -- Unbound Will
	[119910] = { default = true,  duration = 24,  class = "WARLOCK" },                                       -- Spell Lock (Command Demon)
	    [19647]  = { parent = 119910 },                                                                      -- Spell Lock (Felhunter)
	    [119911] = { parent = 119910 },                                                                      -- Optical Blast (Command Demon)
	    [115781] = { parent = 119910 },                                                                      -- Optical Blast (Observer)
	    [132409] = { parent = 119910 },                                                                      -- Spell Lock (Grimoire of Sacrifice)
	    [171138] = { parent = 119910 },                                                                      -- Shadow Lock (Doomguard)
	    [171139] = { parent = 119910 },                                                                      -- Shadow Lock (Grimoire of Sacrifice)
	    [171140] = { parent = 119910 },                                                                      -- Shadow Lock (Command Demon)
	[111859] = { default = false, duration = 120, class = "WARLOCK" },                                       -- Grimoire: Imp
	[111896] = { default = false, duration = 120, class = "WARLOCK" },                                       -- Grimoire: Succubus
	[111897] = { default = true,  duration = 120, class = "WARLOCK" },                                       -- Grimoire: Felhunter
	-- [77801]  = { default = false, duration = 120, class = "WARLOCK", charges = 2 },                          -- Dark Soul
		-- [113858] = { parent = 77801 },                                                                       -- Dark Soul: Instability
		-- [113860] = { parent = 77801 },                                                                       -- Dark Soul: Misery
		-- [113861] = { parent = 77801 },                                                                       -- Dark Soul: Knowledge
	[115284] = { default = false, duration = 15,  class = "WARLOCK" },                                       -- Clone Magic (Observer)
	[115770] = { default = false, duration = 25,  class = "WARLOCK" },                                       -- Fellash
	-- [8143]   = { default = false, duration = 60,  class = "SHAMAN" },                                        -- Tremor Totem
	-- [8177]   = { default = false, duration = 25,  class = "SHAMAN" },                                        -- Grounding Totem
	[30823]  = { default = false, duration = 60,  class = "SHAMAN", specID = { 262, 263 } },                 -- Shamanistic Rage
	[51490]  = { default = false, duration = 45,  class = "SHAMAN", specID = { 262, 263 } },                 -- Thunderstorm
	[51514]  = { default = false, duration = 45,  class = "SHAMAN" },                                        -- Hex
	[57994]  = { default = true,  duration = 12,  class = "SHAMAN" },                                        -- Wind Shear
	[98008]  = { default = false, duration = 180, class = "SHAMAN" },                                        -- Spirit Link Totem
	-- [108269] = { default = false, duration = 45,  class = "SHAMAN" },                                        -- Capacitor Totem
	-- [108271] = { default = false, duration = 90,  class = "SHAMAN" },                                        -- Astral Shift
	[108273] = { default = false, duration = 60,  class = "SHAMAN" },                                        -- Windwalk Totem
	[108285] = { default = false, duration = 180, class = "SHAMAN" },                                        -- Call of the Elements
	-- [1499]   = { default = false, duration = { default = 20, [253] = 30, [254] = 30 }, class = "HUNTER" },   -- Freezing Trap
	    -- [60192] = { parent = 1499 },                                                                         -- Freezing Trap (Trap Launcher)
	[13813]  = { default = false, duration = { default = 20, [253] = 30, [254] = 30 }, class = "HUNTER" },   -- Explosive Trap
	    -- [82939] = { parent = 13813 },                                                                        -- Explosive Trap (Trap Launcher)
	[19263]  = { default = false, duration = 180, class = "HUNTER", charges = 2 },                           -- Deterrence
	[19386]  = { default = false, duration = 45,  class = "HUNTER" },                                        -- Wyvern Sting
	[19574]  = { default = false, duration = 60,  class = "HUNTER", specID = { 253 } },                      -- Bestial Wrath
	[53480]  = { default = false, duration = 60,  class = "HUNTER" },                                        -- Roar of Sacrifice
	[131894] = { default = false, duration = 60,  class = "HUNTER" },                                        -- A Murder of Crows
	[147362] = { default = true,  duration = 24,  class = "HUNTER" },                                        -- Counter Shot
	[66]     = { default = false, duration = 300, class = "MAGE" },                                          -- Invisibility
	[1953]   = { default = false, duration = 15,  class = "MAGE" },                                          -- Blink
	[2139]   = { default = true,  duration = 24,  class = "MAGE" },                                          -- Counterspell
	-- [11129]  = { default = false, duration = 45,  class = "MAGE", specID = { 63 } },                         -- Combustion
	[11958]  = { default = false, duration = 180, class = "MAGE" },                                          -- Cold Snap
	-- [12043]  = { default = false, duration = 90,  class = "MAGE", specID = { 62 } },                         -- Presence of Mind
	[12472]  = { default = false, duration = 180, class = "MAGE", specID = { 64 } },                         -- Icy Veins
	[31661]  = { default = false, duration = 20,  class = "MAGE", specID = { 63 } },                         -- Dragon's Breath
	[44572]  = { default = false, duration = 30,  class = "MAGE", specID = { 64 } },                         -- Deep Freeze
	[45438]  = { default = false, duration = 300, class = "MAGE" },                                          -- Ice Block
	[84714]  = { default = false, duration = 60,  class = "MAGE", specID = { 64 } },                         -- Frozen Orb
	[102051] = { default = false, duration = 20,  class = "MAGE" },                                          -- Frostjaw
	[113724] = { default = false, duration = 45,  class = "MAGE" },                                          -- Ring of Frost
	[157997] = { default = false, duration = 25,  class = "MAGE", specID = { 64 }, charges = 2 },            -- Ice Nova
	[408]    = { default = false, duration = 20,  class = "ROGUE" },                                         -- Kidney Shot
	[1766]   = { default = true,  duration = 15,  class = "ROGUE" },                                         -- Kick
	[1856]   = { default = false, duration = { default = 60, [261] = 120 }, class = "ROGUE" },               -- Vanish
	[2094]   = { default = false, duration = 120, class = "ROGUE" },                                         -- Blind
	[2983]   = { default = false, duration = 60,  class = "ROGUE" },                                         -- Sprint
	[5277]   = { default = false, duration = 180, class = "ROGUE" },                                         -- Evasion
	[13750]  = { default = false, duration = 180, class = "ROGUE", specID = { 260 } },                       -- Adrenaline Rush
	-- [14185]  = { default = false, duration = 300, class = "ROGUE" },                                         -- Preparation
	[31224]  = { default = false, duration = 60,  class = "ROGUE" },                                         -- Cloak of Shadows
	[36554]  = { default = false, duration = 20,  class = "ROGUE" },                                         -- Shadow Step
	[51690]  = { default = false, duration = 120, class = "ROGUE", specID = { 260} },                        -- Killing Spree
	-- [51713]  = { default = false, duration = 60,  class = "ROGUE", specID = { 261 } },                       -- Shadow Dance
	[74001]  = { default = false, duration = 120, class = "ROGUE" },                                         -- Combat Readiness
	[76577]  = { default = false, duration = 180, class = "ROGUE" },                                         -- Smoke Bomb
	[115176] = { default = false, duration = 180, class = "MONK", specID = { 268, 269 } },                   -- Zen Meditation
	[115203] = { default = false, duration = 180, class = "MONK" },                                          -- Fortifying Brew
	[115310] = { default = false, duration = 180, class = "MONK" },                                          -- Revival
	[116705] = { default = true,  duration = 15,  class = "MONK" },                                          -- Spear Hand Strike
	[116844] = { default = false, duration = 45,  class = "MONK" },                                          -- Ring of Peace
	[116849] = { default = false, duration = 55,  class = "MONK", specID = { 270 } },                        -- Life Cocoon
	[119381] = { default = false, duration = 45,  class = "MONK" },                                          -- Leg Sweep
	[119996] = { default = false, duration = 25,  class = "MONK" },                                          -- Transcendence: Transfer
	[122470] = { default = false, duration = 90,  class = "MONK", specID = { 269 } },                        -- Touch of Karma
	[122783] = { default = false, duration = 90,  class = "MONK" },                                          -- Diffuse Magic
	-- [137562] = { default = false, duration = 120, class = "MONK" },                                          -- Nimble Brew
}

local order = {
	["DEATHKNIGHT"] = 1,
	["PALADIN"] = 2,
	["WARRIOR"] = 3,
	["DRUID"] = 4,
	["PRIEST"] = 5,
	["WARLOCK"] = 6,
	["SHAMAN"] = 7,
	["HUNTER"] = 8,
	["MAGE"] = 9,
	["ROGUE"] = 10,
	["MONK"] = 11,
    ["DEMONHUNTER"] = 12, -- ICY: demonhunter
}

local resets = {
	--[[ Summon Felhunter
	     - Spell Lock
	  ]]
	[691] = { 119910 },

	--[[ Cold Snap
	     - Ice Block
	     - Presence of Mind
	     - Dragon's Breath
	  ]]
	[11958] = { 45438, 12043, 31661 },

	--[[ Preparation
	     - Sprint
	     - Vanish
	     - Evasion
	  ]]
	[14185] = { 2983, 1856, 5277 },

	--[[ Call of the Elements
	     - Tremor Totem
	     - Grounding Totem
	     - Capacitor Totem
	     - Windwalk Totem
	  ]]
	[108285] = { 8143, 8177, 108269, 108273 },
}

-- Defaults
local defaults = {
	size                 = 40,
	columns              = 8,
	padding              = 2,
	locked               = false,
	center               = false,
	border               = true,
	noHighlightTarget    = false,
	noHighlightFocus     = true,
	growUpward           = true,
	showUnused           = false,
	adaptive             = false,
	unusedAlpha          = 0.45,
	swipeAlpha           = 0.65,
	noCooldownCount      = false,
	noArena              = false,
	noRatedBattleground  = false,
	noBattleground       = false,
	noWorld              = false,
	noAshran             = false,
	noMultiple           = false,
	noGlow               = false,
	noTooltips           = false,
}

local OmniBar

local Masque = LibStub and LibStub("Masque", true)

local SETTINGS_VERSION = 2

local MAX_DUPLICATE_ICONS = 5

local BASE_ICON_SIZE = 36

local ASHRAN_MAP_ID = 978

StaticPopupDialogs["OMNIBAR_CONFIRM_RESET"] = {
	text = CONFIRM_RESET_SETTINGS,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		OmniBar_Reset(OmniBar)
		if OmniBarOptions then OmniBarOptions:refresh() end

		-- Refresh the cooldowns
		i = 1
		while _G["OmniBarOptionsPanel" .. i] do
			_G["OmniBarOptionsPanel" .. i]:refresh()
			i = i + 1
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	enterClicksFirstButton = true
}

for spellID,_ in pairs(cooldowns) do
	local name, _, icon = GetSpellInfo(spellID)
	cooldowns[spellID].icon = icon
	cooldowns[spellID].name = name
end

-- create a lookup table to translate spec names into IDs
local specNames = {}
for classID = 1, MAX_CLASSES do
	local _, classToken = GetClassInfoByID(classID)
	specNames[classToken] = {}
	for i = 1, GetNumSpecializationsForClassID(classID) do
		local id, name = GetSpecializationInfoForClassID(classID, i)
		specNames[classToken][name] = id
	end
end

local function IsHostilePlayer(unit)
	if not unit then return end
	local reaction = UnitReaction("player", unit)
	if not reaction then return end -- out of range
	return UnitIsPlayer(unit) and reaction < 4 and not UnitIsPossessed(unit)
end

function OmniBar_ShowAnchor(self)
	if self.disabled or self.settings.locked or #self.active > 0 then
		self.anchor:Hide()
	else
		self.anchor:Show()
	end
end

function OmniBar_CreateIcon(self)
	if InCombatLockdown() then return end
	self.numIcons = self.numIcons + 1
	local f = CreateFrame("Button", self:GetName().."Icon"..self.numIcons, self.anchor, "OmniBarButtonTemplate")
	table.insert(self.icons, f)
end

local function SpellBelongsToSpec(spellID, specID)
	if not specID then return true end
	if not cooldowns[spellID].specID then return true end
	for i = 1, #cooldowns[spellID].specID do
		if cooldowns[spellID].specID[i] == specID then return true end
	end
	return false
end

function OmniBar_AddIconsByClass(self, class, sourceGUID, specID)
	for spellID, spell in pairs(cooldowns) do
		if OmniBar_IsSpellEnabled(self, spellID) and spell.class == class and SpellBelongsToSpec(spellID, specID) then
			OmniBar_AddIcon(self, spellID, sourceGUID, nil, true, specID)
		end
	end
end

local function IconIsSource(iconGUID, guid)
	if not guid then return end
	if string.len(iconGUID) == 1 then
		-- arena target
		return UnitGUID("arena"..iconGUID) == guid
	end
	return iconGUID == guid
end

function OmniBar_UpdateBorders(self)
	for i = 1, #self.active do
		local border
		local guid = self.active[i].sourceGUID
		if guid then
			if not self.settings.noHighlightFocus and IconIsSource(guid, UnitGUID("focus")) then
				self.active[i].FocusTexture:SetAlpha(1)
				border = true
			else
				self.active[i].FocusTexture:SetAlpha(0)
			end
			if not self.settings.noHighlightTarget and IconIsSource(guid, UnitGUID("target")) then
				self.active[i].FocusTexture:SetAlpha(0)
				self.active[i].TargetTexture:SetAlpha(1)
				border = true
			else
				self.active[i].TargetTexture:SetAlpha(0)
			end
		else
			local class = select(2, UnitClass("focus"))
			if not self.settings.noHighlightFocus and class and IsHostilePlayer("focus") and class == self.active[i].class then
				self.active[i].FocusTexture:SetAlpha(1)
				border = true
			else
				self.active[i].FocusTexture:SetAlpha(0)
			end
			class = select(2, UnitClass("target"))
			if not self.settings.noHighlightTarget and class and IsHostilePlayer("target") and class == self.active[i].class then
				self.active[i].FocusTexture:SetAlpha(0)
				self.active[i].TargetTexture:SetAlpha(1)
				border = true
			else
				self.active[i].TargetTexture:SetAlpha(0)
			end
		end

		-- Set dim
		self.active[i]:SetAlpha(self.settings.unusedAlpha and self.active[i].cooldown:GetCooldownTimes() == 0 and not border and
			self.settings.unusedAlpha or 1)
	end
end

function OmniBar_UpdateArenaSpecs(self)
	if self.zone ~= "arena" then return end
	for i = 1, 5 do
		local specID = GetArenaOpponentSpec(i)
		if specID and specID > 0 then
			local name = GetUnitName("arena"..i, true)
			if name then self.specs[name] = specID end
		end
	end
end

function OmniBar_OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		local name = ...
		if name ~= addonName then return end
		self:UnregisterEvent("ADDON_LOADED")
		OmniBar = self
		self.icons = {}
		self.active = {}
		self.cooldowns = cooldowns
		self.detected = {}
		self.specs = {}
		self.BASE_ICON_SIZE = BASE_ICON_SIZE
		self.numIcons = 0
		self:RegisterForDrag("LeftButton")

		-- Load the settings
		OmniBar_LoadSettings(self)

		-- Create the icons
		for spellID,_ in pairs(cooldowns) do
			if OmniBar_IsSpellEnabled(self, spellID) then
				OmniBar_CreateIcon(self)
			end
		end

		-- Create the duplicate icons
		for i = 1, MAX_DUPLICATE_ICONS do
			OmniBar_CreateIcon(self)
		end

		OmniBar_ShowAnchor(self)
		OmniBar_RefreshIcons(self)
		OmniBar_UpdateIcons(self)
		OmniBar_Center(self)

		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("PLAYER_FOCUS_CHANGED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("ARENA_OPPONENT_UPDATE")
		self:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
		self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")

		-- Add Options Panel category
		local frame = CreateFrame("Frame", "OmniBarOptions")
		frame:SetScript("OnShow", function(self)
			if not self.init then
				LoadAddOn("OmniBar_Options")
				self:refresh()
				-- Refresh the cooldowns
				i = 1
				while _G["OmniBarOptionsPanel" .. i] do
					_G["OmniBarOptionsPanel" .. i]:refresh()
					i = i + 1
				end
				self.init = true
			end
		end)
		frame.name = addonName
		InterfaceOptions_AddCategory(frame)

	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, event, _, sourceGUID, sourceName, sourceFlags, _,_,_,_,_, spellID = ...
		if self.disabled then return end
		if event == "SPELL_CAST_SUCCESS" and bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0 then
			if cooldowns[spellID] then
				OmniBar_UpdateArenaSpecs(self)
				OmniBar_AddIcon(self, spellID, sourceGUID, sourceName)
			end

			-- Check if we need to reset any cooldowns
			if resets[spellID] then
				for i = 1, #self.active do
					if self.active[i] and self.active[i].spellID and self.active[i].sourceGUID and self.active[i].sourceGUID == sourceGUID and self.active[i].cooldown:IsVisible() then
						-- cooldown belongs to this source
						for j = 1, #resets[spellID] do
							if resets[spellID][j] == self.active[i].spellID then
								self.active[i].cooldown:Hide()
								OmniBar_CooldownFinish(self.active[i].cooldown, true)
								return
							end
						end
					end
				end
			end
		end

	elseif event == "PLAYER_ENTERING_WORLD" then
		OmniBar_OnEvent(self, "ZONE_CHANGED_NEW_AREA")
		wipe(self.detected)
		wipe(self.specs)
		if self.zone == "arena" then OmniBar_OnEvent(self, "ARENA_OPPONENT_UPDATE") end

	elseif event == "ZONE_CHANGED_NEW_AREA" then
		local _, zone = IsInInstance()
		if zone == "none" then
			SetMapToCurrentZone()
			zone = GetCurrentMapAreaID()
		end
		local rated = IsRatedBattleground()
		self.disabled = (zone == "arena" and self.settings.noArena) or
			(rated and self.settings.noRatedBattleground) or
			(zone == "pvp" and self.settings.noBattleground and not rated) or
			(zone == ASHRAN_MAP_ID and self.settings.noAshran) or 
			(zone ~= "arena" and zone ~= "pvp" and zone ~= ASHRAN_MAP_ID and self.settings.noWorld)
		self.zone = zone
		OmniBar_LoadPosition(self)
		OmniBar_RefreshIcons(self)
		OmniBar_UpdateIcons(self)
		OmniBar_ShowAnchor(self)

	elseif event == "UPDATE_BATTLEFIELD_SCORE" then
		for i = 1, GetNumBattlefieldScores() do
			local name, _,_,_,_,_,_,_, classToken, _,_,_,_,_,_, talentSpec = GetBattlefieldScore(i)
			if name and specNames[classToken] and specNames[classToken][talentSpec] then
				self.specs[name] = specNames[classToken][talentSpec]
			end
		end

	elseif event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" or event == "ARENA_OPPONENT_UPDATE" then
		for i = 1, 5 do
			local specID = GetArenaOpponentSpec(i)
			if specID and specID > 0 then
				-- only add icons if show unused is checked
				if not self.settings.showUnused then return end
				if not self.detected[i] then
					local class = select(7, GetSpecializationInfoByID(specID))
					OmniBar_AddIconsByClass(self, class, i, specID)
					self.detected[i] = class
				end
			end
		end

	elseif event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_FOCUS_CHANGED" or event == "PLAYER_REGEN_DISABLED" then
		-- update icon borders
		OmniBar_UpdateBorders(self)

		-- we don't need to add in arena
		if self.zone == "arena" then return end

		-- only add icons if show adaptive is checked
		if not self.settings.showUnused or not self.settings.adaptive then return end

		-- only add icons when we're in combat
		if event == "PLAYER_TARGET_CHANGED" and not InCombatLockdown() then return end

		local unit = "playertarget"
		if IsHostilePlayer(unit) then
			local guid = UnitGUID(unit)
			local _, class = UnitClass(unit)
			if class then
				if self.detected[guid] then return end
				self.detected[guid] = class
				OmniBar_AddIconsByClass(self, class)
			end
		end
	end
end

function OmniBar_LoadSettings(self, specific)
	if (not OmniBarDB) or (not OmniBarDB.version) or OmniBarDB.version ~= SETTINGS_VERSION then
		OmniBarDB = { version = SETTINGS_VERSION, Default = {} }
		for k,v in pairs(defaults) do
			OmniBarDB.Default[k] = v
		end
	end
	local profile = UnitName("player").." - "..GetRealmName()
	if specific then
		OmniBarDB[profile] = nil
		if specific ~= 0 then
			-- Copy the current settings
			OmniBarDB[profile] = {}
			for a,b in pairs(OmniBarDB.Default) do
				if type(b) == "table" then
					OmniBarDB[profile][a] = {}
					for c,d in pairs(b) do
						if type(d) == "table" then
							OmniBarDB[profile][a][c] = {}
							for e,f in pairs(d) do
								OmniBarDB[profile][a][c][e] = f
							end
						else
							OmniBarDB[profile][a][c] = d
						end
					end
				else
					OmniBarDB[profile][a] = b
				end
			end
		end
	end
	self.profile = OmniBarDB[profile] and profile or "Default"
	self.settings = OmniBarDB[self.profile]

	self.settings.cooldowns = self.settings.cooldowns or {}

	-- Set the scale
	self.container:SetScale(self.settings.size/BASE_ICON_SIZE)

	-- Refresh if we toggled specific
	if specific then
		OmniBar_LoadPosition(self)
		OmniBar_RefreshIcons(self)
		OmniBar_UpdateIcons(self)
		OmniBar_Center(self)
	end	
end

function OmniBar_Reset(self)
	local profile = UnitName("player").." - "..GetRealmName()
	OmniBarDB.Default = {}
	for k,v in pairs(defaults) do
		OmniBarDB.Default[k] = v
	end
	OmniBarDB[profile] = nil
	OmniBar_LoadSettings(self, 0)
end

function OmniBar_SavePosition(self)
	local point, _, relativePoint, xOfs, yOfs = self:GetPoint()
	if not self.settings.position then 
		self.settings.position = {}
	end
	self.settings.position.point = point
	self.settings.position.relativePoint = relativePoint
	self.settings.position.xOfs = xOfs
	self.settings.position.yOfs = yOfs
end

function OmniBar_LoadPosition(self)
	self:ClearAllPoints()
	if self.settings.position then
		self:SetPoint(self.settings.position.point, UIParent, self.settings.position.relativePoint,
			self.settings.position.xOfs, self.settings.position.yOfs)
	else
		self:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
end

function OmniBar_IsSpellEnabled(self, spellID)
	if not spellID then return end
	-- Check for an explicit rule
	if self.settings.cooldowns and self.settings.cooldowns[spellID] then
		if self.settings.cooldowns[spellID].enabled then
			return true
		end
	elseif cooldowns[spellID].default then
		-- Not user-set, but a default cooldown
		return true
	end
end

function OmniBar_Center(self)
	local parentWidth = UIParent:GetWidth()
	local clamp = self.settings.center and (1 - parentWidth)/2 or 0
	self:SetClampRectInsets(clamp, -clamp, 0, 0)
	clamp = self.settings.center and (self.anchor:GetWidth() - parentWidth)/2 or 0
	self.anchor:SetClampRectInsets(clamp, -clamp, 0, 0)
end

function OmniBar_CooldownFinish(self, force)
	local icon = self:GetParent()
	if icon.cooldown and icon.cooldown:GetCooldownTimes() > 0 and not force then return end -- not complete
	local charges = icon.charges
	if charges then
		charges = charges - 1
		if charges > 0 then
			-- remove a charge
			icon.charges = charges
			icon.Count:SetText(charges)
			OmniBar_StartCooldown(icon:GetParent():GetParent(), icon, GetTime())
			return
		end
	end

	local bar = icon:GetParent():GetParent()

	local flash = icon.flashAnim
	local newItemGlowAnim = icon.newitemglowAnim

	if flash:IsPlaying() or newItemGlowAnim:IsPlaying() then
		flash:Stop()
		newItemGlowAnim:Stop()
	end

	if not bar.settings.showUnused then
		icon:Hide()
	else
		if icon.TargetTexture:GetAlpha() == 0 and
			icon.FocusTexture:GetAlpha() == 0 and
			bar.settings.unusedAlpha then
				icon:SetAlpha(bar.settings.unusedAlpha)
		end
	end
	bar:StopMovingOrSizing()
	OmniBar_Position(bar)
end

function OmniBar_RefreshIcons(self)
	-- Hide all the icons
	for i = 1, self.numIcons do
		if self.icons[i].MasqueGroup then
			--self.icons[i].MasqueGroup:Delete()
			self.icons[i].MasqueGroup = nil
		end
		self.icons[i].TargetTexture:SetAlpha(0)
		self.icons[i].FocusTexture:SetAlpha(0)
		self.icons[i].flash:SetAlpha(0)
		self.icons[i].NewItemTexture:SetAlpha(0)
		self.icons[i].cooldown:SetCooldown(0, 0)
		self.icons[i].cooldown:Hide()
		self.icons[i]:Hide()
	end
	wipe(self.active)

	if self.disabled then return end

	if self.settings.showUnused and not self.settings.adaptive then
		for spellID,_ in pairs(cooldowns) do
			if OmniBar_IsSpellEnabled(self, spellID) then
				OmniBar_AddIcon(self, spellID, nil, nil, true)
			end
		end
	end
	OmniBar_Position(self)
end

function OmniBar_StartCooldown(self, icon, start)
	icon.cooldown:SetCooldown(start, icon.duration)
	icon.cooldown.finish = start + icon.duration
	icon.cooldown:SetSwipeColor(0, 0, 0, self.settings.swipeAlpha or 0.65)
	icon:SetAlpha(1)
end


function OmniBar_AddIcon(self, spellID, sourceGUID, sourceName, init, test, specID)
	-- Check for parent spellID
	local originalSpellID = spellID
	if cooldowns[spellID].parent then spellID = cooldowns[spellID].parent end

	if not OmniBar_IsSpellEnabled(self, spellID) then return end

	local icon, duplicate

	-- Try to reuse a visible frame
	for i = 1, #self.active do
		if self.active[i].spellID == spellID then
			duplicate = true
			-- check if we can use this icon, but not when initializing arena opponents
			if not init or self.zone ~= "arena" then
				-- use icon if not bound to a sourceGUID
				if not self.active[i].sourceGUID then
					duplicate = nil
					icon = self.active[i]
					break
				end

				-- if it's the same source, reuse the icon
				if sourceGUID and IconIsSource(self.active[i].sourceGUID, sourceGUID) then
					duplicate = nil
					icon = self.active[i]
					break
				end

			end
		end
	end

	-- We couldn't find a visible frame to reuse, try to find an unused
	if not icon then
		if self.settings.noMultiple and duplicate then return end
		for i = 1, #self.icons do
			if not self.icons[i]:IsVisible() then
				icon = self.icons[i]
				icon.specID = nil
				break
			end
		end
	end

	-- We couldn't find a frame to use
	if not icon then return end

	local now = GetTime()

	if specID then
		icon.specID = specID
	else
		if sourceName and sourceName ~= COMBATLOG_FILTER_STRING_UNKNOWN_UNITS and self.specs[sourceName] then
			icon.specID = self.specs[sourceName]
		end
	end

	icon.class = cooldowns[spellID].class
	icon.sourceGUID = sourceGUID
	icon.icon:SetTexture(cooldowns[spellID].icon)
	icon.spellID = spellID
	icon.added = now

	if icon.charges and cooldowns[originalSpellID].charges and icon:IsVisible() then
		local start, duration = icon.cooldown:GetCooldownTimes()
		if icon.cooldown.finish and icon.cooldown.finish - GetTime() > 1 then
			-- add a charge
			local charges = icon.charges + 1
			icon.charges = charges
			icon.Count:SetText(charges)
			if not self.settings.noGlow then
				icon.flashAnim:Play()
				icon.newitemglowAnim:Play()
			end
			return icon
		end
	elseif cooldowns[originalSpellID].charges then
		icon.charges = 1
		icon.Count:SetText("1")
	else
		icon.charges = nil
		icon.Count:SetText(nil)
	end
	
	if cooldowns[originalSpellID].duration then
		if type(cooldowns[originalSpellID].duration) == "table" then
			if icon.specID and cooldowns[originalSpellID].duration[icon.specID] then
				icon.duration = cooldowns[originalSpellID].duration[icon.specID]
			else
				icon.duration = cooldowns[originalSpellID].duration.default
			end
		else
			icon.duration = cooldowns[originalSpellID].duration
		end
	else -- child doesn't have a custom duration, use parent
		if type(cooldowns[spellID].duration) == "table" then
			if icon.specID and cooldowns[spellID].duration[icon.specID] then
				icon.duration = cooldowns[spellID].duration[icon.specID]
			else
				icon.duration = cooldowns[spellID].duration.default
			end
		else
			icon.duration = cooldowns[spellID].duration
		end
	end

	-- We don't want duration to be too long if we're just testing
	if test then icon.duration = math.random(5,30) end

	-- Masque
	if Masque then
		icon.MasqueGroup = Masque:Group("OmniBar", cooldowns[spellID].name)
		icon.MasqueGroup:AddButton(icon, {
			FloatingBG = false,
			Icon = icon.icon,
			Cooldown = icon.cooldown,
			Flash = false,
			Pushed = false,
			Normal = icon:GetNormalTexture(),
			Disabled = false,
			Checked = false,
			Border = _G[icon:GetName().."Border"],
			AutoCastable = false,
			Highlight = false,
			Hotkey = false,
			Count = false,
			Name = false,
			Duration = false,
			AutoCast = false,
		})
	end

	icon:Show()

	if not init then
		OmniBar_StartCooldown(self, icon, now)
		if not self.settings.noGlow then
			icon.flashAnim:Play()
			icon.newitemglowAnim:Play()
		end
	end

	return icon
end

function OmniBar_UpdateIcons(self)
	for i = 1, self.numIcons do
		-- Set show text
		self.icons[i].cooldown:SetHideCountdownNumbers(self.settings.noCooldownCount and true or false)
		self.icons[i].cooldown.noCooldownCount = self.settings.noCooldownCount and true

		-- Set swipe alpha
		self.icons[i].cooldown:SetSwipeColor(0, 0, 0, self.settings.swipeAlpha or 0.65)

		-- Set border
		if self.settings.border then
			self.icons[i].icon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		else
			self.icons[i].icon:SetTexCoord(0.07, 0.9, 0.07, 0.9)
		end

		-- Set dim
		self.icons[i]:SetAlpha(self.settings.unusedAlpha and self.icons[i].cooldown:GetCooldownTimes() == 0 and
			self.settings.unusedAlpha or 1)

		-- Masque
		if self.icons[i].MasqueGroup then self.icons[i].MasqueGroup:ReSkin() end

	end
end

function OmniBar_Test(self)
	self.disabled = nil
	OmniBar_RefreshIcons(self)
	for k,v in pairs(cooldowns) do
		OmniBar_AddIcon(self, k, nil, nil, nil, true)
	end
end

local function ExtractDigits(str)
	if not str then return 0 end
	if type(str) == "number" then return str end
	local num = str:gsub("%D", "")
	return tonumber(num) or 0
end

function OmniBar_Position(self)
	local numActive = #self.active
	if numActive == 0 then
		-- Show the anchor if needed
		OmniBar_ShowAnchor(self)
		return
	end

	-- Keep cooldowns together by class
	if self.settings.showUnused then
		table.sort(self.active, function(a, b)
			local x, y = ExtractDigits(a.sourceGUID), ExtractDigits(b.sourceGUID)
			if a.class == b.class then
				if x < y then return true end
				if x == y then return a.spellID < b.spellID end
			end
			return order[a.class] < order[b.class]
		end)
	else
		-- if we aren't showing unused, just sort by added time
		table.sort(self.active, function(a, b) return a.added == b.added and a.spellID < b.spellID or a.added < b.added end)
	end

	local count, rows = 0, 1
	local grow = self.settings.growUpward and 1 or -1
	local padding = self.settings.padding and self.settings.padding or 0
	for i = 1, numActive do
		if self.settings.locked then
			self.active[i]:EnableMouse(false)
		else
			self.active[i]:EnableMouse(true)
		end
		self.active[i]:ClearAllPoints()
		local columns = self.settings.columns and self.settings.columns > 0 and self.settings.columns < numActive and
			self.settings.columns or numActive
		if i > 1 then
			count = count + 1
			if count >= columns then
				self.active[i]:SetPoint("CENTER", OmniBarIcons, "CENTER", (-BASE_ICON_SIZE-padding)*(columns-1)/2, (BASE_ICON_SIZE+padding)*rows*grow)
				count = 0
				rows = rows + 1
			else
				self.active[i]:SetPoint("TOPLEFT", self.active[i-1], "TOPRIGHT", padding, 0)
			end
			
		else
			self.active[i]:SetPoint("CENTER", OmniBarIcons, "CENTER", (-BASE_ICON_SIZE-padding)*(columns-1)/2, 0)
		end
	end
	OmniBar_ShowAnchor(self)
end

SLASH_OmniBar1 = "/ob"
SLASH_OmniBar2 = "/omnibar"
SlashCmdList.OmniBar = function(msg)
	local cmd, arg1 = string.split(" ", string.lower(msg))

	if cmd == "lock" or cmd == "unlock" then
		OmniBar.settings.locked = cmd == "lock" and true or false
		OmniBar_Position(OmniBar)
		if OmniBarOptionsPanelLock then OmniBarOptionsPanelLock:SetChecked(OmniBar.settings.locked) end

	elseif cmd == "reset" then
		StaticPopup_Show("OMNIBAR_CONFIRM_RESET")

	elseif cmd == "test" then
		OmniBar_Test(OmniBar)

	else
		if LoadAddOn("OmniBar_Options") then
			InterfaceOptionsFrame_OpenToCategory(addonName)
			InterfaceOptionsFrame_OpenToCategory(addonName)
		end

	end

end
