local E, L, V, P, G, _ = unpack(select(2, ...)); --Engine

--Cache global variables
--Lua functions
local print, unpack, select, pairs = print, unpack, select, pairs
local lower = string.lower
--WoW API / Variables
local GetSpellInfo = GetSpellInfo
local UnitClass, IsEquippedItem = UnitClass, IsEquippedItem

local function SpellName(id)
	local name, _, _, _, _, _, _, _, _ = GetSpellInfo(id)
	if not name then
		print('|cff1784d1ElvUI:|r SpellID is not valid: '..id..'. Please check for an updated version, if none exists report to ElvUI author.')
		return 'Impale'
	else
		return name
	end
end

local function Defaults(priorityOverride)
	return {['enable'] = true, ['priority'] = priorityOverride or 0, ['stackThreshold'] = 0}
end

G.unitframe.aurafilters = {};

-- These are debuffs that are some form of CC
G.unitframe.aurafilters['CCDebuffs'] = {
	['type'] = 'Whitelist',
	['spells'] = {
	--Death Knight
		[47476]  = Defaults(2), -- Strangulate
		[108194] = Defaults(4), -- Asphyxiate UH
		[221562] = Defaults(4), -- Asphyxiate Blood
		[207171] = Defaults(4), -- Winter is Coming
		[206961] = Defaults(3), -- Tremble Before Me
		[207167] = Defaults(4), -- Blinding Sleet
		[212540] = Defaults(1), -- Flesh Hook (Pet)
		[91807]  = Defaults(1), -- Shambling Rush (Pet)
		[204085] = Defaults(1), -- Deathchill
		[233395] = Defaults(1), -- Frozen Center
		[212332] = Defaults(4), -- Smash (Pet)
		[212337] = Defaults(4), -- Powerful Smash (Pet)
		[91800]  = Defaults(4), -- Gnaw (Pet)
		[91797]  = Defaults(4), -- Monstrous Blow (Pet)
	--	[?????]  = Defaults(),  -- Reanimation (missing data)
		[210141] = Defaults(3), -- Zombie Explosion
	--Demon Hunter
		[207685] = Defaults(4), -- Sigil of Misery
		[217832] = Defaults(3), -- Imprison
		[221527] = Defaults(5), -- Imprison (Banished version)
		[204490] = Defaults(2), -- Sigil of Silence
		[179057] = Defaults(3), -- Chaos Nova
		[211881] = Defaults(4), -- Fel Eruption
		[205630] = Defaults(3), -- Illidan's Grasp
		[208618] = Defaults(3), -- Illidan's Grasp (Afterward)
		[213491] = Defaults(4), -- Demonic Trample (it's this one or the other)
		[208645] = Defaults(4), -- Demonic Trample
		[200166] = Defaults(4), -- Metamorphosis
	--Druid
		[81261]  = Defaults(2), -- Solar Beam
		[5211]   = Defaults(4), -- Mighty Bash
		[163505] = Defaults(4), -- Rake
		[203123] = Defaults(4), -- Maim
		[202244] = Defaults(4), -- Overrun
		[99]     = Defaults(4), -- Incapacitating Roar
		[33786]  = Defaults(5), -- Cyclone
		[209753] = Defaults(5), -- Cyclone Balance
		[45334]  = Defaults(1), -- Immobilized
		[102359] = Defaults(1), -- Mass Entanglement
		[339]    = Defaults(1), -- Entangling Roots
	--Hunter
		[202933] = Defaults(2), -- Spider Sting (it's this one or the other)
		[233022] = Defaults(2), -- Spider Sting
		[224729] = Defaults(4), -- Bursting Shot
		[213691] = Defaults(4), -- Scatter Shot
		[19386]  = Defaults(3), -- Wyvern Sting
		[3355]   = Defaults(3), -- Freezing Trap
		[203337] = Defaults(5), -- Freezing Trap (Survival PvPT)
		[209790] = Defaults(3), -- Freezing Arrow
		[24394]  = Defaults(4), -- Intimidation
		[117526] = Defaults(4), -- Binding Shot
		[190927] = Defaults(1), -- Harpoon
		[201158] = Defaults(1), -- Super Sticky Tar
		[162480] = Defaults(1), -- Steel Trap
		[212638] = Defaults(1), -- Tracker's Net
		[200108] = Defaults(1), -- Ranger's Net
	--Mage
		[61721]  = Defaults(3), -- Rabbit (Poly)
		[61305]  = Defaults(3), -- Black Cat (Poly)
		[28272]  = Defaults(3), -- Pig (Poly)
		[28271]  = Defaults(3), -- Turtle (Poly)
		[126819] = Defaults(3), -- Porcupine (Poly)
		[161354] = Defaults(3), -- Monkey (Poly)
		[161353] = Defaults(3), -- Polar bear (Poly)
		[118]    = Defaults(3), -- Polymorph
		[82691]  = Defaults(3), -- Ring of Frost
		[31661]  = Defaults(3), -- Dragon's Breath
		[122]    = Defaults(1), -- Frost Nova
		[33395]  = Defaults(1), -- Freeze
		[157997] = Defaults(1), -- Ice Nova
		[228600] = Defaults(1), -- Glacial Spike
		[198121] = Defaults(1), -- Forstbite
	--Monk
		[119381] = Defaults(4), -- Leg Sweep
		[202346] = Defaults(4), -- Double Barrel
		[115078] = Defaults(4), -- Paralysis
		[198909] = Defaults(3), -- Song of Chi-Ji
		[202274] = Defaults(3), -- Incendiary Brew
		[233759] = Defaults(2), -- Grapple Weapon
		[123407] = Defaults(1), -- Spinning Fire Blossom
		[116706] = Defaults(1), -- Disable
		[232055] = Defaults(4), -- Fists of Fury (it's this one or the other)
	--Paladin
		[853]    = Defaults(3), -- Hammer of Justice
		[20066]  = Defaults(3), -- Repentance
		[105421] = Defaults(3), -- Blinding Light
		[31935]  = Defaults(2), -- Avenger's Shield
		[217824] = Defaults(2), -- Shield of Virtue
		[205290] = Defaults(3), -- Wake of Ashes
	--Priest
		[9484]   = Defaults(3), -- Shackle Undead
		[200196] = Defaults(4), -- Holy Word: Chastise
		[200200] = Defaults(4), -- Holy Word: Chastise
		[226943] = Defaults(3), -- Mind Bomb
		[605]    = Defaults(5), -- Mind Control
		[8122]   = Defaults(3), -- Psychic Scream
		[15487]  = Defaults(2), -- Silence
		[199683] = Defaults(2), -- Last Word
	--Rogue
		[2094]   = Defaults(4), -- Blind
		[6770]   = Defaults(4), -- Sap
		[1776]   = Defaults(4), -- Gouge
		[199743] = Defaults(4), -- Parley
		[1330]   = Defaults(2), -- Garrote - Silence
		[207777] = Defaults(2), -- Dismantle
		[199804] = Defaults(4), -- Between the Eyes
		[408]    = Defaults(4), -- Kidney Shot
		[1833]   = Defaults(4), -- Cheap Shot
		[207736] = Defaults(5), -- Shadowy Duel (Smoke effect)
		[212182] = Defaults(5), -- Smoke Bomb
	--Shaman
		[51514]  = Defaults(3), -- Hex
		[211015] = Defaults(3), -- Hex (Cockroach)
		[211010] = Defaults(3), -- Hex (Snake)
		[211004] = Defaults(3), -- Hex (Spider)
		[210873] = Defaults(3), -- Hex (Compy)
		[196942] = Defaults(3), -- Hex (Voodoo Totem)
		[118905] = Defaults(3), -- Static Charge
		[77505]  = Defaults(4), -- Earthquake (Knocking down)
		[118345] = Defaults(4), -- Pulverize (Pet)
		[204399] = Defaults(3), -- Earthfury
		[204437] = Defaults(3), -- Lightning Lasso
		[157375] = Defaults(4), -- Gale Force
		[64695]  = Defaults(1), -- Earthgrab
	--Warlock
		[710]    = Defaults(5), -- Banish
		[6789]   = Defaults(3), -- Mortal Coil
		[118699] = Defaults(3), -- Fear
		[5484]   = Defaults(3), -- Howl of Terror
		[6358]   = Defaults(3), -- Seduction (Succub)
		[171017] = Defaults(4), -- Meteor Strike (Infernal)
		[22703]  = Defaults(4), -- Infernal Awakening (Infernal CD)
		[30283]  = Defaults(3), -- Shadowfury
		[89766]  = Defaults(4), -- Axe Toss
		[233582] = Defaults(1), -- Entrenched in Flame
	--Warrior
		[5246]   = Defaults(4), -- Intimidating Shout
		[7922]   = Defaults(4), -- Warbringer
		[132169] = Defaults(4), -- Storm Bolt
		[132168] = Defaults(4), -- Shockwave
		[199085] = Defaults(4), -- Warpath
		[105771] = Defaults(1), -- Charge
		[199042] = Defaults(1), -- Thunderstruck
	--Racial
		[155145] = Defaults(2), -- Arcane Torrent
		[20549]  = Defaults(4), -- War Stomp
		[107079] = Defaults(4), -- Quaking Palm
	},
}

-- These are buffs that can be considered "protection" buffs
G.unitframe.aurafilters['TurtleBuffs'] = {
	['type'] = 'Whitelist',
	['spells'] = {
	--Death Knight
		[48707]  = Defaults(), -- Anti-Magic Shell
		[81256]  = Defaults(), -- Dancing Rune Weapon
		[55233]  = Defaults(), -- Vampiric Blood
		[193320] = Defaults(), -- Umbilicus Eternus
		[219809] = Defaults(), -- Tombstone
		[48792]  = Defaults(), -- Icebound Fortitude
		[207319] = Defaults(), -- Corpse Shield
		[194844] = Defaults(), -- BoneStorm
		[145629] = Defaults(), -- Anti-Magic Zone
		[194679] = Defaults(), -- Rune Tap
	--Demon Hunter
		[207811] = Defaults(), -- Nether Bond (DH)
		[207810] = Defaults(), -- Nether Bond (Target)
		[187827] = Defaults(), -- Metamorphosis
		[227225] = Defaults(), -- Soul Barrier
		[209426] = Defaults(), -- Darkness
		[196555] = Defaults(), -- Netherwalk
		[212800] = Defaults(), -- Blur
		[188499] = Defaults(), -- Blade Dance
		[203819] = Defaults(), -- Demon Spikes
		[218256] = Defaults(), -- Empower Wards
	-- Druid
		[102342] = Defaults(), -- Ironbark
		[61336]  = Defaults(), -- Survival Instincts
		[210655] = Defaults(), -- Protection of Ashamane
		[22812]  = Defaults(), -- Barkskin
		[200851] = Defaults(), -- Rage of the Sleeper
		[234081] = Defaults(), -- Celestial Guardian
		[202043] = Defaults(), -- Protector of the Pack (it's this one or the other)
		[201940] = Defaults(), -- Protector of the Pack
		[201939] = Defaults(), -- Protector of the Pack (Allies)
		[192081] = Defaults(), -- Ironfur
	--Hunter
		[186265] = Defaults(), -- Aspect of the Turtle
		[53480]  = Defaults(), -- Roar of Sacrifice
		[202748] = Defaults(), -- Survival Tactics
	--Mage
		[45438]  = Defaults(), -- Ice Block
		[113862] = Defaults(), -- Greater Invisibility
		[198111] = Defaults(), -- Temporal Shield
		[198065] = Defaults(), -- Prismatic Cloak
		[11426]  = Defaults(), -- Ice Barrier
	--Monk
		[122783] = Defaults(), -- Diffuse Magic
		[122278] = Defaults(), -- Dampen Harm
		[125174] = Defaults(), -- Touch of Karma
		[201318] = Defaults(), -- Fortifying Elixir
		[201325] = Defaults(), -- Zen Moment
		[202248] = Defaults(), -- Guided Meditation
		[120954] = Defaults(), -- Fortifying Brew
		[116849] = Defaults(), -- Life Cocoon
		[202162] = Defaults(), -- Guard
		[215479] = Defaults(), -- Ironskin Brew
	--Paladin
		[642]    = Defaults(), -- Divine Shield
		[498]    = Defaults(), -- Divine Protection
		[205191] = Defaults(), -- Eye for an Eye
		[184662] = Defaults(), -- Shield of Vengeance
		[1022]   = Defaults(), -- Blessing of Protection
		[6940]   = Defaults(), -- Blessing of Sacrifice
		[204018] = Defaults(), -- Blessing of Spellwarding
		[199507] = Defaults(), -- Spreading The Word: Protection
		[216857] = Defaults(), -- Guarded by the Light
		[228049] = Defaults(), -- Guardian of the Forgotten Queen
		[31850]  = Defaults(), -- Ardent Defender
		[86659]  = Defaults(), -- Guardian of Ancien Kings
		[209388] = Defaults(), -- Bulwark of Order
		[204335] = Defaults(), -- Aegis of Light
		[152262] = Defaults(), -- Seraphim
		[132403] = Defaults(), -- Shield of the Righteous
	--Priest
		[81782]  = Defaults(), -- Power Word: Barrier
		[47585]  = Defaults(), -- Dispersion
		[19236]  = Defaults(), -- Desperate Prayer
		[213602] = Defaults(), -- Greater Fade
		[27827]  = Defaults(), -- Spirit of Redemption
		[197268] = Defaults(), -- Ray of Hope
		[47788]  = Defaults(), -- Guardian Spirit
		[33206]  = Defaults(), -- Pain Suppression
	--Rogue
		[5277]   = Defaults(), -- Evasion
		[31224]  = Defaults(), -- Cloak of Shadows
		[1966]   = Defaults(), -- Feint
		[199754] = Defaults(), -- Riposte
		[45182]  = Defaults(), -- Cheating Death
		[199027] = Defaults(), -- Veil of Midnight
	--Shaman
		[204293] = Defaults(), -- Spirit Link
		[204288] = Defaults(), -- Earth Shield
		[210918] = Defaults(), -- Ethereal Form
		[207654] = Defaults(), -- Servant of the Queen
		[108271] = Defaults(), -- Astral Shift
		[98007]  = Defaults(), -- Spirit Link Totem
		[207498] = Defaults(), -- Ancestral Protection
	--Warlock
		[108416] = Defaults(), -- Dark Pact
		[104773] = Defaults(), -- Unending Resolve
		[221715] = Defaults(), -- Essence Drain
		[212295] = Defaults(), -- Nether Ward
	--Warrior
		[118038] = Defaults(), -- Die by the Sword
		[184364] = Defaults(), -- Enraged Regeneration
		[209484] = Defaults(), -- Tactical Advance
		[97463]  = Defaults(), -- Commanding Shout
		[213915] = Defaults(), -- Mass Spell Reflection
		[199038] = Defaults(), -- Leave No Man Behind
		[223658] = Defaults(), -- Safeguard
		[147833] = Defaults(), -- Intervene
		[198760] = Defaults(), -- Intercept
		[12975]  = Defaults(), -- Last Stand
		[871]    = Defaults(), -- Shield Wall
		[23920]  = Defaults(), -- Spell Reflection
		[216890] = Defaults(), -- Spell Reflection (PvPT)
		[227744] = Defaults(), -- Ravager
		[203524] = Defaults(), -- Neltharion's Fury
		[190456] = Defaults(), -- Ignore Pain
		[132404] = Defaults(), -- Shield Block
	--Racial
		[65116]  = Defaults(), -- Stoneform
	--Potion
		[188029] = Defaults(), -- Unbending Potion (Legion Armor Potion)
	},
}

G.unitframe.aurafilters['PlayerBuffs'] = {
	['type'] = 'Whitelist',
	['spells'] = {
	--Death Knight
		[48707]  = Defaults(), -- Anti-Magic Shell
		[81256]  = Defaults(), -- Dancing Rune Weapon
		[55233]  = Defaults(), -- Vampiric Blood
		[193320] = Defaults(), -- Umbilicus Eternus
		[219809] = Defaults(), -- Tombstone
		[48792]  = Defaults(), -- Icebound Fortitude
		[207319] = Defaults(), -- Corpse Shield
		[194844] = Defaults(), -- BoneStorm
		[145629] = Defaults(), -- Anti-Magic Zone
		[194679] = Defaults(), -- Rune Tap
		[51271]  = Defaults(), -- Pilar of Frost
		[207256] = Defaults(), -- Obliteration
		[152279] = Defaults(), -- Breath of Sindragosa
		[233411] = Defaults(), -- Blood for Blood
		[212552] = Defaults(), -- Wraith Walk
		[215711] = Defaults(), -- Soul Reaper
		[194918] = Defaults(), -- Blighted Rune Weapon
	--Demon Hunter
		[207811] = Defaults(), -- Nether Bond (DH)
		[207810] = Defaults(), -- Nether Bond (Target)
		[187827] = Defaults(), -- Metamorphosis
		[227225] = Defaults(), -- Soul Barrier
		[209426] = Defaults(), -- Darkness
		[196555] = Defaults(), -- Netherwalk
		[212800] = Defaults(), -- Blur
		[188499] = Defaults(), -- Blade Dance
		[203819] = Defaults(), -- Demon Spikes
		[218256] = Defaults(), -- Empower Wards
		[206804] = Defaults(), -- Rain from Above
		[211510] = Defaults(), -- Solitude
		[211048] = Defaults(), -- Chaos Blades
		[162264] = Defaults(), -- Metamorphosis
		[205629] = Defaults(), -- Demonic Trample
	-- Druid
		[102342] = Defaults(), -- Ironbark
		[61336]  = Defaults(), -- Survival Instincts
		[210655] = Defaults(), -- Protection of Ashamane
		[22812]  = Defaults(), -- Barkskin
		[200851] = Defaults(), -- Rage of the Sleeper
		[234081] = Defaults(), -- Celestial Guardian
		[202043] = Defaults(), -- Protector of the Pack (it's this one or the other)
		[201940] = Defaults(), -- Protector of the Pack
		[201939] = Defaults(), -- Protector of the Pack (Allies)
		[192081] = Defaults(), -- Ironfur
		[29166]  = Defaults(), -- Innervate
		[208253] = Defaults(), -- Essence of G'Hanir
		[194223] = Defaults(), -- Celestial Alignment
		[102560] = Defaults(), -- Incarnation: Chosen of Elune
		[102543] = Defaults(), -- Incarnation: King of the Jungle
		[102558] = Defaults(), -- Incarnation: Guardian of Ursoc
		[117679] = Defaults(), -- Incarnation
		[106951] = Defaults(), -- Berserk
		[5217]   = Defaults(), -- Tiger's Fury
		[1850]   = Defaults(), -- Dash
		[137452] = Defaults(), -- Displacer Beast
		[102416] = Defaults(), -- Wild Charge
		[77764]  = Defaults(), -- Stampeding Roar (Cat)
		[77761]  = Defaults(), -- Stampeding Roar (Bear)
		[203727] = Defaults(), -- Thorns
		[233756] = Defaults(), -- Eclipse (it's this one or the other)
		[234084] = Defaults(), -- Eclipse
		[22842]  = Defaults(), -- Frenzied Regeneration
	--Hunter
		[186265] = Defaults(), -- Aspect of the Turtle
		[53480]  = Defaults(), -- Roar of Sacrifice
		[202748] = Defaults(), -- Survival Tactics
		[62305]  = Defaults(), -- Master's Call (it's this one or the other)
		[54216]  = Defaults(), -- Master's Call
		[193526] = Defaults(), -- Trueshot
		[193530] = Defaults(), -- Aspect of the Wild
		[19574]  = Defaults(), -- Bestial Wrath
		[186289] = Defaults(), -- Aspect of the Eagle
		[186257] = Defaults(), -- Aspect of the Cheetah
		[118922] = Defaults(), -- Posthaste
		[90355]  = Defaults(), -- Ancient Hysteria (Pet)
		[160452] = Defaults(), -- Netherwinds (Pet)
	--Mage
		[45438]  = Defaults(), -- Ice Block
		[113862] = Defaults(), -- Greater Invisibility
		[198111] = Defaults(), -- Temporal Shield
		[198065] = Defaults(), -- Prismatic Cloak
		[11426]  = Defaults(), -- Ice Barrier
		[190319] = Defaults(), -- Combustion
		[80353]  = Defaults(), -- Time Warp
		[12472]  = Defaults(), -- Icy Veins
		[12042]  = Defaults(), -- Arcane Power
		[116014] = Defaults(), -- Rune of Power
		[198144] = Defaults(), -- Ice Form
		[108839] = Defaults(), -- Ice Floes
		[205025] = Defaults(), -- Presence of Mind
		[198158] = Defaults(), -- Mass Invisibility
		[221404] = Defaults(), -- Burning Determination
	--Monk
		[122783] = Defaults(), -- Diffuse Magic
		[122278] = Defaults(), -- Dampen Harm
		[125174] = Defaults(), -- Touch of Karma
		[201318] = Defaults(), -- Fortifying Elixir
		[201325] = Defaults(), -- Zen Moment
		[202248] = Defaults(), -- Guided Meditation
		[120954] = Defaults(), -- Fortifying Brew
		[116849] = Defaults(), -- Life Cocoon
		[202162] = Defaults(), -- Guard
		[215479] = Defaults(), -- Ironskin Brew
		[152173] = Defaults(), -- Serenity
		[137639] = Defaults(), -- Storm, Earth, and Fire
		[216113] = Defaults(), -- Way of the Crane
		[213664] = Defaults(), -- Nimble Brew
		[201447] = Defaults(), -- Ride the Wind
		[195381] = Defaults(), -- Healing Winds
		[116841] = Defaults(), -- Tiger's Lust
		[119085] = Defaults(), -- Chi Torpedo
		[199407] = Defaults(), -- Light on Your Feet
		[209584] = Defaults(), -- Zen Focus Tea
	--Paladin
		[642]    = Defaults(), -- Divine Shield
		[498]    = Defaults(), -- Divine Protection
		[205191] = Defaults(), -- Eye for an Eye
		[184662] = Defaults(), -- Shield of Vengeance
		[1022]   = Defaults(), -- Blessing of Protection
		[6940]   = Defaults(), -- Blessing of Sacrifice
		[204018] = Defaults(), -- Blessing of Spellwarding
		[199507] = Defaults(), -- Spreading The Word: Protection
		[216857] = Defaults(), -- Guarded by the Light
		[228049] = Defaults(), -- Guardian of the Forgotten Queen
		[31850]  = Defaults(), -- Ardent Defender
		[86659]  = Defaults(), -- Guardian of Ancien Kings
		[209388] = Defaults(), -- Bulwark of Order
		[204335] = Defaults(), -- Aegis of Light
		[152262] = Defaults(), -- Seraphim
		[132403] = Defaults(), -- Shield of the Righteous
		[31842]  = Defaults(), -- Avenging Wrath (Holy)
		[31884]  = Defaults(), -- Avenging Wrath
		[105809] = Defaults(), -- Holy Avenger
		[224668] = Defaults(), -- Crusade
		[200652] = Defaults(), -- Tyr's Deliverance
		[216331] = Defaults(), -- Avenging Crusader
		[1044]   = Defaults(), -- Blessing of Freedom
		[210256] = Defaults(), -- Blessing of Sanctuary
		[199545] = Defaults(), -- Steed of Glory
		[210294] = Defaults(), -- Divine Favor
		[221886] = Defaults(), -- Divine Steed
		[31821]  = Defaults(), -- Aura Mastery
		[203538] = Defaults(), -- Greater Blessing of Kings
		[203539] = Defaults(), -- Greater Blessing of Wisdom
	--Priest
		[81782]  = Defaults(), -- Power Word: Barrier
		[47585]  = Defaults(), -- Dispersion
		[19236]  = Defaults(), -- Desperate Prayer
		[213602] = Defaults(), -- Greater Fade
		[27827]  = Defaults(), -- Spirit of Redemption
		[197268] = Defaults(), -- Ray of Hope
		[47788]  = Defaults(), -- Guardian Spirit
		[33206]  = Defaults(), -- Pain Suppression
		[200183] = Defaults(), -- Apotheosis
		[10060]  = Defaults(), -- Power Infusion
		[47536]  = Defaults(), -- Rapture
		[194249] = Defaults(), -- Voidform
		[193223] = Defaults(), -- Surrdender to Madness
		[197862] = Defaults(), -- Archangel
		[197871] = Defaults(), -- Dark Archangel
		[197874] = Defaults(), -- Dark Archangel
		[215769] = Defaults(), -- Spirit of Redemption
		[213610] = Defaults(), -- Holy Ward
		[121557] = Defaults(), -- Angelic Feather
		[214121] = Defaults(), -- Body and Mind
		[65081]  = Defaults(), -- Body and Soul
		[197767] = Defaults(), -- Speed of the Pious
		[210980] = Defaults(), -- Focus in the Light
		[221660] = Defaults(), -- Holy Concentration
		[15286]  = Defaults(), -- Vampiric Embrace
	--Rogue
		[5277]   = Defaults(), -- Evasion
		[31224]  = Defaults(), -- Cloak of Shadows
		[1966]   = Defaults(), -- Feint
		[199754] = Defaults(), -- Riposte
		[45182]  = Defaults(), -- Cheating Death
		[199027] = Defaults(), -- Veil of Midnight
		[121471] = Defaults(), -- Shadow Blades
		[13750]  = Defaults(), -- Adrenaline Rush
		[51690]  = Defaults(), -- Killing Spree
		[185422] = Defaults(), -- Shadow Dance
		[198368] = Defaults(), -- Take Your Cut
		[198027] = Defaults(), -- Turn the Tables
		[213985] = Defaults(), -- Thief's Bargain
		[197003] = Defaults(), -- Maneuverability
		[212198] = Defaults(), -- Crimson Vial
		[185311] = Defaults(), -- Crimson Vial
		[209754] = Defaults(), -- Boarding Party
		[36554]  = Defaults(), -- Shadowstep
		[2983]   = Defaults(), -- Sprint
		[202665] = Defaults(), -- Curse of the Dreadblades (Self Debuff)
	--Shaman
		[204293] = Defaults(), -- Spirit Link
		[204288] = Defaults(), -- Earth Shield
		[210918] = Defaults(), -- Ethereal Form
		[207654] = Defaults(), -- Servant of the Queen
		[108271] = Defaults(), -- Astral Shift
		[98007]  = Defaults(), -- Spirit Link Totem
		[207498] = Defaults(), -- Ancestral Protection
		[204366] = Defaults(), -- Thundercharge
		[209385] = Defaults(), -- Windfury Totem
		[208963] = Defaults(), -- Skyfury Totem
		[204945] = Defaults(), -- Doom Winds
		[205495] = Defaults(), -- Stormkeeper
		[208416] = Defaults(), -- Sense of Urgency
		[2825]   = Defaults(), -- Bloodlust
		[16166]  = Defaults(), -- Elemental Mastery
		[167204] = Defaults(), -- Feral Spirit
		[114050] = Defaults(), -- Ascendance (Elem)
		[114051] = Defaults(), -- Ascendance (Enh)
		[114052] = Defaults(), -- Ascendance (Resto)
		[79206]  = Defaults(), -- Spiritwalker's Grace
		[58875]  = Defaults(), -- Spirit Walk
		[157384] = Defaults(), -- Eye of the Storm
		[192082] = Defaults(), -- Wind Rush
		[2645]   = Defaults(), -- Ghost Wolf
		[32182]  = Defaults(), -- Heroism
		[108281] = Defaults(), -- Ancestral Guidance
	--Warlock
		[108416] = Defaults(), -- Dark Pact
		[104773] = Defaults(), -- Unending Resolve
		[221715] = Defaults(), -- Essence Drain
		[212295] = Defaults(), -- Nether Ward
		[212284] = Defaults(), -- Firestone
		[196098] = Defaults(), -- Soul Harvest
		[221705] = Defaults(), -- Casting Circle
		[111400] = Defaults(), -- Burning Rush
		[196674] = Defaults(), -- Planeswalker
	--Warrior
		[118038] = Defaults(), -- Die by the Sword
		[184364] = Defaults(), -- Enraged Regeneration
		[209484] = Defaults(), -- Tactical Advance
		[97463]  = Defaults(), -- Commanding Shout
		[213915] = Defaults(), -- Mass Spell Reflection
		[199038] = Defaults(), -- Leave No Man Behind
		[223658] = Defaults(), -- Safeguard
		[147833] = Defaults(), -- Intervene
		[198760] = Defaults(), -- Intercept
		[12975]  = Defaults(), -- Last Stand
		[871]    = Defaults(), -- Shield Wall
		[23920]  = Defaults(), -- Spell Reflection
		[216890] = Defaults(), -- Spell Reflection (PvPT)
		[227744] = Defaults(), -- Ravager
		[203524] = Defaults(), -- Neltharion's Fury
		[190456] = Defaults(), -- Ignore Pain
		[132404] = Defaults(), -- Shield Block
		[1719]   = Defaults(), -- Battle Cry
		[107574] = Defaults(), -- Avatar
		[227847] = Defaults(), -- Bladestorm (Arm)
		[46924]  = Defaults(), -- Bladestorm (Fury)
		[12292]  = Defaults(), -- Bloodbath
		[118000] = Defaults(), -- Dragon Roar
		[199261] = Defaults(), -- Death Wish
		[18499]  = Defaults(), -- Berserker Rage
		[202164] = Defaults(), -- Bounding Stride
		[215572] = Defaults(), -- Frothing Berserker
		[199203] = Defaults(), -- Thirst for Battle
	--Racial
		[65116] = Defaults(), -- Stoneform
		[59547] = Defaults(), -- Gift of the Naaru
		[20572] = Defaults(), -- Blood Fury
		[26297] = Defaults(), -- Berserking
		[68992] = Defaults(), -- Darkflight
		[58984] = Defaults(), -- Shadowmeld
	--Consumables
		[188029] = Defaults(), -- Unbending Potion (Legion Armor)
		[188028] = Defaults(), -- Potion of the Old War (Legion Melee)
		[188027] = Defaults(), -- Potion of Deadly Grace (Legion Caster)
		[229206] = Defaults(), -- Potion of Prolonged Power (Legion)
		[178207] = Defaults(), -- Drums of Fury
		[230935] = Defaults(), -- Drums of the Mountain
	},
}

-- Buffs that really we dont need to see
G.unitframe.aurafilters['Blacklist'] = {
	['type'] = 'Blacklist',
	['spells'] = {
		[36900]  = Defaults(), -- Soul Split: Evil!
		[36901]  = Defaults(), -- Soul Split: Good
		[36893]  = Defaults(), -- Transporter Malfunction
		[97821]  = Defaults(), -- Void-Touched
		[36032]  = Defaults(), -- Arcane Charge
		[8733]   = Defaults(), -- Blessing of Blackfathom
		[25771]  = Defaults(), -- Forbearance (pally: divine shield, hand of protection, and lay on hands)
		[57724]  = Defaults(), -- Sated (lust debuff)
		[57723]  = Defaults(), -- Exhaustion (heroism debuff)
		[80354]  = Defaults(), -- Temporal Displacement (timewarp debuff)
		[95809]  = Defaults(), -- Insanity debuff (hunter pet heroism: ancient hysteria)
		[58539]  = Defaults(), -- Watcher's Corpse
		[26013]  = Defaults(), -- Deserter
		[71041]  = Defaults(), -- Dungeon Deserter
		[41425]  = Defaults(), -- Hypothermia
		[55711]  = Defaults(), -- Weakened Heart
		[8326]   = Defaults(), -- Ghost
		[23445]  = Defaults(), -- Evil Twin
		[24755]  = Defaults(), -- Tricked or Treated
		[25163]  = Defaults(), -- Oozeling's Disgusting Aura
		[124275] = Defaults(), -- Stagger
		[124274] = Defaults(), -- Stagger
		[124273] = Defaults(), -- Stagger
		[117870] = Defaults(), -- Touch of The Titans
		[123981] = Defaults(), -- Perdition
		[15007]  = Defaults(), -- Ress Sickness
		[113942] = Defaults(), -- Demonic: Gateway
		[89140]  = Defaults(), -- Demonic Rebirth: Cooldown
	},
}

--[[
	This should be a list of important buffs that we always want to see when they are active
	bloodlust, paladin hand spells, raid cooldowns, etc..
]]
G.unitframe.aurafilters['Whitelist'] = {
	['type'] = 'Whitelist',
	['spells'] = {
		[31821]  = Defaults(), -- Devotion Aura
		[2825]   = Defaults(), -- Bloodlust
		[32182]  = Defaults(), -- Heroism
		[80353]  = Defaults(), -- Time Warp
		[90355]  = Defaults(), -- Ancient Hysteria
		[47788]  = Defaults(), -- Guardian Spirit
		[33206]  = Defaults(), -- Pain Suppression
		[116849] = Defaults(), -- Life Cocoon
		[22812]  = Defaults(), -- Barkskin
		[192132] = Defaults(), -- Mystic Empowerment: Thunder (Hyrja, Halls of Valor)
		[192133] = Defaults(), -- Mystic Empowerment: Holy (Hyrja, Halls of Valor)
	},
}

-- RAID DEBUFFS: This should be pretty self explainitory
G.unitframe.aurafilters['RaidDebuffs'] = {
	['type'] = 'Whitelist',
	['spells'] = {
	-- Legion
	-- Antorus, the Burning Throne
		-- Garothi Worldbreaker
		[244590] = Defaults(), -- Molten Hot Fel
		[244761] = Defaults(), -- Annihilation
		[246920] = Defaults(), -- Haywire Decimation
		[246369] = Defaults(), -- Searing Barrage
		[246848] = Defaults(), -- Luring Destruction
		[246220] = Defaults(), -- Fel Bombardment
		[247159] = Defaults(), -- Luring Destruction
		[244122] = Defaults(), -- Carnage
		[244410] = Defaults(), -- Decimation
		[245294] = Defaults(), -- Empowered Decimation
		[246368] = Defaults(), -- Searing Barrage

		-- Felhounds of Sargeras
		[245022] = Defaults(), -- Burning Remnant
		[251445] = Defaults(), -- Smouldering
		[251448] = Defaults(), -- Burning Maw
		[244086] = Defaults(), -- Molten Touch
		[244091] = Defaults(), -- Singed
		[244768] = Defaults(), -- Desolate Gaze
		[244767] = Defaults(), -- Desolate Path
		[244471] = Defaults(), -- Enflame Corruption
		[248815] = Defaults(), -- Enflamed
		[244517] = Defaults(), -- Lingering Flames
		[245098] = Defaults(), -- Decay
		[251447] = Defaults(), -- Corrupting Maw
		[244131] = Defaults(), -- Consuming Sphere
		[245024] = Defaults(), -- Consumed
		[244071] = Defaults(), -- Weight of Darkness
		[244578] = Defaults(), -- Siphon Corruption
		[248819] = Defaults(), -- Siphoned
		[254429] = Defaults(), -- Weight of Darkness
		[244072] = Defaults(), -- Molten Touch

		-- Antoran High Command
		[245121] = Defaults(), -- Entropic Blast
		[244748] = Defaults(), -- Shocked
		[244824] = Defaults(), -- Warp Field
		[244892] = Defaults(), -- Exploit Weakness
		[244172] = Defaults(), -- Psychic Assault
		[244388] = Defaults(), -- Psychic Scarring
		[244420] = Defaults(), -- Chaos Pulse
		[254771] = Defaults(), -- Disruption Field
		[257974] = Defaults(), -- Chaos Pulse
		[244910] = Defaults(), -- Felshield
		[244737] = Defaults(), -- Shock Grenade

		-- Portal Keeper Hasabel
		[244016] = Defaults(), -- Reality Tear
		[245157] = Defaults(), -- Everburning Light
		[245075] = Defaults(), -- Hungering Gloom
		[245240] = Defaults(), -- Oppressive Gloom
		[244709] = Defaults(), -- Fiery Detonation
		[246208] = Defaults(), -- Acidic Web
		[246075] = Defaults(), -- Catastrophic Implosion
		[244826] = Defaults(), -- Fel Miasma
		[246316] = Defaults(), -- Poison Essence
		[244849] = Defaults(), -- Caustic Slime
		[245118] = Defaults(), -- Cloying Shadows
		[245050] = Defaults(), -- Delusions
		[245040] = Defaults(), -- Corrupt
		[244607] = Defaults(), -- Flames of Xoroth
		[244915] = Defaults(), -- Leech Essence
		[244926] = Defaults(), -- Felsilk Wrap
		[244949] = Defaults(), -- Felsilk Wrap
		[244613] = Defaults(), -- Everburning Flames

		-- Eonar the Life-Binder
		[248326] = Defaults(), -- Rain of Fel
		[248861] = Defaults(), -- Spear of Doom
		[249016] = Defaults(), -- Feedback - Targeted
		[249015] = Defaults(), -- Feedback - Burning Embers
		[249014] = Defaults(), -- Feedback - Foul Steps
		[249017] = Defaults(), -- Feedback - Arcane Singularity
		[250693] = Defaults(), -- Arcane Buildup
		[250691] = Defaults(), -- Burning Embers
		[248795] = Defaults(), -- Fel Wake
		[248332] = Defaults(), -- Rain of Fel
		[250140] = Defaults(), -- Foul Steps

		-- Imonar the Soulhunter
		[248424] = Defaults(), -- Gathering Power
		[247552] = Defaults(), -- Sleep Canister
		[247565] = Defaults(), -- Slumber Gas
		[250224] = Defaults(), -- Shocked
		[248252] = Defaults(), -- Infernal Rockets
		[247687] = Defaults(), -- Sever
		[247716] = Defaults(), -- Charged Blasts
		[247367] = Defaults(), -- Shock Lance
		[250255] = Defaults(), -- Empowered Shock Lance
		[247641] = Defaults(), -- Stasis Trap
		[255029] = Defaults(), -- Sleep Canister
		[248321] = Defaults(), -- Conflagration
		[247932] = Defaults(), -- Shrapnel Blast
		[248070] = Defaults(), -- Empowered Shrapnel Blast
		[254183] = Defaults(), -- Seared Skin

		-- Kin'garoth
		[244312] = Defaults(), -- Forging Strike
		[246840] = Defaults(), -- Ruiner
		[248061] = Defaults(), -- Purging Protocol
		[249686] = Defaults(), -- Reverberating Decimation
		[246706] = Defaults(), -- Demolish
		[246698] = Defaults(), -- Demolish
		[245919] = Defaults(), -- Meteor Swarm
		[245770] = Defaults(), -- Decimation

		-- Varimathras
		[244042] = Defaults(), -- Marked Prey
		[243961] = Defaults(), -- Misery
		[248732] = Defaults(), -- Echoes of Doom
		[243973] = Defaults(), -- Torment of Shadows
		[244005] = Defaults(), -- Dark Fissure
		[244093] = Defaults(), -- Necrotic Embrace
		[244094] = Defaults(), -- Necrotic Embrace

		-- The Coven of Shivarra
		[244899] = Defaults(), -- Fiery Strike
		[245518] = Defaults(), -- Flashfreeze
		[245586] = Defaults(), -- Chilled Blood
		[246763] = Defaults(), -- Fury of Golganneth
		[245674] = Defaults(), -- Flames of Khaz'goroth
		[245671] = Defaults(), -- Flames of Khaz'goroth
		[245910] = Defaults(), -- Spectral Army of Norgannon
		[253520] = Defaults(), -- Fulminating Pulse
		[245634] = Defaults(), -- Whirling Saber
		[253020] = Defaults(), -- Storm of Darkness
		[245921] = Defaults(), -- Spectral Army of Norgannon
		[250757] = Defaults(), -- Cosmic Glare

		-- Aggramar
		[244291] = Defaults(), -- Foe Breaker
		[255060] = Defaults(), -- Empowered Foe Breaker
		[245995] = Defaults(), -- Scorching Blaze
		[246014] = Defaults(), -- Searing Tempest
		[244912] = Defaults(), -- Blazing Eruption
		[247135] = Defaults(), -- Scorched Earth
		[247091] = Defaults(), -- Catalyzed
		[245631] = Defaults(), -- Unchecked Flame
		[245916] = Defaults(), -- Molten Remnants
		[245990] = Defaults(), -- Taeshalach's Reach
		[254452] = Defaults(), -- Ravenous Blaze
		[244736] = Defaults(), -- Wake of Flame
		[247079] = Defaults(), -- Empowered Flame Rend

		-- Argus the Unmaker
		[251815] = Defaults(), -- Edge of Obliteration
		[248499] = Defaults(), -- Sweeping Scythe
		[250669] = Defaults(), -- Soulburst
		[251570] = Defaults(), -- Soulbomb
		[248396] = Defaults(), -- Soulblight
		[258039] = Defaults(), -- Deadly Scythe
		[252729] = Defaults(), -- Cosmic Ray
		[256899] = Defaults(), -- Soul Detonation
		[252634] = Defaults(), -- Cosmic Smash
		[252616] = Defaults(), -- Cosmic Beacon
		[255200] = Defaults(), -- Aggramar's Boon
		[255199] = Defaults(), -- Avatar of Aggramar
		[258647] = Defaults(), -- Gift of the Sea
		[253901] = Defaults(), -- Strength of the Sea
		[257299] = Defaults(), -- Ember of Rage
		[248167] = Defaults(), -- Death Fog
		[258646] = Defaults(), -- Gift of the Sky
		[253903] = Defaults(), -- Strength of the Sky

	-- Tomb of Sargeras
		-- Goroth
		[233279] = Defaults(), -- Shattering Star
		[230345] = Defaults(), -- Crashing Comet (Dot)
		[232249] = Defaults(), -- Crashing Comet
		[231363] = Defaults(), -- Burning Armor
		[234264] = Defaults(), -- Melted Armor
		[233062] = Defaults(), -- Infernal Burning
		[230348] = Defaults(), -- Fel Pool

		-- Demonic Inquisition
		[233430] = Defaults(), -- Ubearable Torment
		[233983] = Defaults(), -- Echoing Anguish
		[248713] = Defaults(), -- Soul Corruption

		-- Harjatan
		[231770] = Defaults(), -- Drenched
		[231998] = Defaults(), -- Jagged Abrasion
		[231729] = Defaults(), -- Aqueous Burst
		[234128] = Defaults(), -- Driven Assault
		[234016] = Defaults(), -- Driven Assault

		-- Sisters of the Moon
		[236603] = Defaults(), -- Rapid Shot
		[236596] = Defaults(), -- Rapid Shot
		[234995] = Defaults(), -- Lunar Suffusion
		[234996] = Defaults(), -- Umbra Suffusion
		[236519] = Defaults(), -- Moon Burn
		[236697] = Defaults(), -- Deathly Screech
		[239264] = Defaults(), -- Lunar Flare (Tank)
		[236712] = Defaults(), -- Lunar Beacon
		[236304] = Defaults(), -- Incorporeal Shot
		[236305] = Defaults(), -- Incorporeal Shot (Heroic)
		[236306] = Defaults(), -- Incorporeal Shot
		[237570] = Defaults(), -- Incorporeal Shot
		[248911] = Defaults(), -- Incorporeal Shot
		[236550] = Defaults(), -- Discorporate (Tank)
		[236330] = Defaults(), -- Astral Vulnerability
		[236529] = Defaults(), -- Twilight Glaive
		[236541] = Defaults(), -- Twilight Glaive
		[237561] = Defaults(), -- Twilight Glaive (Heroic)
		[237633] = Defaults(), -- Spectral Glaive
		[233263] = Defaults(), -- Embrace of the Eclipse

		-- Mistress Sassz'ine
		[230959] = Defaults(), -- Concealing Murk
		[232732] = Defaults(), -- Slicing Tornado
		[232913] = Defaults(), -- Befouling Ink
		[234621] = Defaults(), -- Devouring Maw
		[230201] = Defaults(), -- Burden of Pain (Tank)
		[230139] = Defaults(), -- Hydra Shot
		[232754] = Defaults(), -- Hydra Acid
		[230920] = Defaults(), -- Consuming Hunger
		[230358] = Defaults(), -- Thundering Shock
		[230362] = Defaults(), -- Thundering Shock

		-- The Desolate Host
		[236072] = Defaults(), -- Wailing Souls
		[236449] = Defaults(), -- Soulbind
		[236515] = Defaults(), -- Shattering Scream
		[235989] = Defaults(), -- Tormented Cries
		[236241] = Defaults(), -- Soul Rot
		[236361] = Defaults(), -- Spirit Chains
		[235968] = Defaults(), -- Grasping Darkness

		-- Maiden of Vigilance
		[235117] = Defaults(), -- Unstable Soul
		[240209] = Defaults(), -- Unstable Soul
		[243276] = Defaults(), -- Unstable Soul
		[249912] = Defaults(), -- Unstable Soul
		[235534] = Defaults(), -- Creator's Grace
		[235538] = Defaults(), -- Demon's Vigor
		[234891] = Defaults(), -- Wrath of the Creators
		[235569] = Defaults(), -- Hammer of Creation
		[235573] = Defaults(), -- Hammer of Obliteration
		[235213] = Defaults(), -- Light Infusion
		[235240] = Defaults(), -- Fel Infusion

		-- Fallen Avatar
		[239058] = Defaults(), -- Touch of Sargeras
		[239739] = Defaults(), -- Dark Mark
		[234059] = Defaults(), -- Unbound Chaos
		[240213] = Defaults(), -- Chaos Flames
		[236604] = Defaults(), -- Shadowy Blades
		[236494] = Defaults(), -- Desolate (Tank)
		[240728] = Defaults(), -- Tainted Essence

		-- Kil'jaeden
		[238999] = Defaults(), -- Darkness of a Thousand Souls
		[239216] = Defaults(), -- Darkness of a Thousand Souls (Dot)
		[239155] = Defaults(), -- Gravity Squeeze
		[234295] = Defaults(), -- Armageddon Rain
		[240908] = Defaults(), -- Armageddon Blast
		[239932] = Defaults(), -- Felclaws (Tank)
		[240911] = Defaults(), -- Armageddon Hail
		[238505] = Defaults(), -- Focused Dreadflame
		[238429] = Defaults(), -- Bursting Dreadflame
		[236710] = Defaults(), -- Shadow Reflection: Erupting
		[241822] = Defaults(), -- Choking Shadow
		[236555] = Defaults(), -- Deceiver's Veil
		[234310] = Defaults(), -- Armageddon Rain

	-- The Nighthold
		-- Skorpyron
		[204766] = Defaults(), -- Energy Surge
		[214718] = Defaults(), -- Acidic Fragments
		[211801] = Defaults(), -- Volatile Fragments
		[204284] = Defaults(), -- Broken Shard (Protection)
		[204275] = Defaults(), -- Arcanoslash (Tank)
		[211659] = Defaults(), -- Arcane Tether (Tank debuff)
		[204483] = Defaults(), -- Focused Blast (Stun)

		-- Chronomatic Anomaly
		[206607] = Defaults(), -- Chronometric Particles (Tank stack debuff)
		[206609] = Defaults(), -- Time Release (Heal buff/debuff)
		[219966] = Defaults(), -- Time Release (Heal Absorb Red)
		[219965] = Defaults(), -- Time Release (Heal Absorb Yellow)
		[219964] = Defaults(), -- Time Release (Heal Absorb Green)
		[205653] = Defaults(), -- Passage of Time
		[207871] = Defaults(), -- Vortex (Mythic)
		[212099] = Defaults(), -- Temporal Charge

		-- Trilliax
		[206488] = Defaults(), -- Arcane Seepage
		[206641] = Defaults(), -- Arcane Spear (Tank)
		[206798] = Defaults(), -- Toxic Slice
		[214672] = Defaults(), -- Annihilation
		[214573] = Defaults(), -- Stuffed
		[214583] = Defaults(), -- Sterilize
		[208910] = Defaults(), -- Arcing Bonds
		[206838] = Defaults(), -- Succulent Feast

		-- Spellblade Aluriel
		[212492] = Defaults(), -- Annihilate (Tank)
		[212494] = Defaults(), -- Annihilated (Main Tank debuff)
		[212587] = Defaults(), -- Mark of Frost
		[212531] = Defaults(), -- Mark of Frost (marked)
		[212530] = Defaults(), -- Replicate: Mark of Frost
		[212647] = Defaults(), -- Frostbitten
		[212736] = Defaults(), -- Pool of Frost
		[213085] = Defaults(), -- Frozen Tempest
		[213621] = Defaults(), -- Entombed in Ice
		[213148] = Defaults(), -- Searing Brand Chosen
		[213181] = Defaults(), -- Searing Brand Stunned
		[213166] = Defaults(), -- Searing Brand
		[213278] = Defaults(), -- Burning Ground
		[213504] = Defaults(), -- Arcane Fog

		-- Tichondrius
		[206480] = Defaults(), -- Carrion Plague
		[215988] = Defaults(), -- Carrion Nightmare
		[208230] = Defaults(), -- Feast of Blood
		[212794] = Defaults(), -- Brand of Argus
		[216685] = Defaults(), -- Flames of Argus
		[206311] = Defaults(), -- Illusionary Night
		[206466] = Defaults(), -- Essence of Night
		[216024] = Defaults(), -- Volatile Wound
		[216027] = Defaults(), -- Nether Zone
		[216039] = Defaults(), -- Fel Storm
		[216726] = Defaults(), -- Ring of Shadows
		[216040] = Defaults(), -- Burning Soul

		-- Krosus
		[206677] = Defaults(), -- Searing Brand
		[205344] = Defaults(), -- Orb of Destruction

		-- High Botanist Tel'arn
		[218503] = Defaults(), -- Recursive Strikes (Tank)
		[219235] = Defaults(), -- Toxic Spores
		[218809] = Defaults(), -- Call of Night
		[218342] = Defaults(), -- Parasitic Fixate
		[218304] = Defaults(), -- Parasitic Fetter
		[218780] = Defaults(), -- Plasma Explosion

		-- Star Augur Etraeus
		[205984] = Defaults(), -- Gravitaional Pull
		[214167] = Defaults(), -- Gravitaional Pull
		[214335] = Defaults(), -- Gravitaional Pull
		[206936] = Defaults(), -- Icy Ejection
		[206388] = Defaults(), -- Felburst
		[206585] = Defaults(), -- Absolute Zero
		[206398] = Defaults(), -- Felflame
		[206589] = Defaults(), -- Chilled
		[205649] = Defaults(), -- Fel Ejection
		[206965] = Defaults(), -- Voidburst
		[206464] = Defaults(), -- Coronal Ejection
		[207143] = Defaults(), -- Void Ejection
		[206603] = Defaults(), -- Frozen Solid
		[207720] = Defaults(), -- Witness the Void
		[216697] = Defaults(), -- Frigid Pulse

		-- Grand Magistrix Elisande
		[209166] = Defaults(), -- Fast Time
		[211887] = Defaults(), -- Ablated
		[209615] = Defaults(), -- Ablation
		[209244] = Defaults(), -- Delphuric Beam
		[209165] = Defaults(), -- Slow Time
		[209598] = Defaults(), -- Conflexive Burst
		[209433] = Defaults(), -- Spanning Singularity
		[209973] = Defaults(), -- Ablating Explosion
		[209549] = Defaults(), -- Lingering Burn
		[211261] = Defaults(), -- Permaliative Torment
		[208659] = Defaults(), -- Arcanetic Ring

		-- Gul'dan
		[210339] = Defaults(), -- Time Dilation
		[180079] = Defaults(), -- Felfire Munitions
		[206875] = Defaults(), -- Fel Obelisk (Tank)
		[206840] = Defaults(), -- Gaze of Vethriz
		[206896] = Defaults(), -- Torn Soul
		[206221] = Defaults(), -- Empowered Bonds of Fel
		[208802] = Defaults(), -- Soul Corrosion
		[212686] = Defaults(), -- Flames of Sargeras

	-- The Emerald Nightmare
		-- Nythendra
		[204504] = Defaults(), -- Infested
		[205043] = Defaults(), -- Infested mind
		[203096] = Defaults(), -- Rot
		[204463] = Defaults(), -- Volatile Rot
		[203045] = Defaults(), -- Infested Ground
		[203646] = Defaults(), -- Burst of Corruption

		-- Elerethe Renferal
		[210228] = Defaults(), -- Dripping Fangs
		[215307] = Defaults(), -- Web of Pain
		[215300] = Defaults(), -- Web of Pain
		[215460] = Defaults(), -- Necrotic Venom
		[213124] = Defaults(), -- Venomous Pool
		[210850] = Defaults(), -- Twisting Shadows
		[215489] = Defaults(), -- Venomous Pool
		[218519] = Defaults(), -- Wind Burn (Mythic)

		-- Il'gynoth, Heart of the Corruption
		[208929] = Defaults(),  -- Spew Corruption
		[210984] = Defaults(),  -- Eye of Fate
		[209469] = Defaults(5), -- Touch of Corruption
		[208697] = Defaults(),  -- Mind Flay
		[215143] = Defaults(),  -- Cursed Blood

		-- Ursoc
		[198108] = Defaults(), -- Unbalanced
		[197943] = Defaults(), -- Overwhelm
		[204859] = Defaults(), -- Rend Flesh
		[205611] = Defaults(), -- Miasma
		[198006] = Defaults(), -- Focused Gaze
		[197980] = Defaults(), -- Nightmarish Cacophony

		-- Dragons of Nightmare
		[203102] = Defaults(),  -- Mark of Ysondre
		[203121] = Defaults(),  -- Mark of Taerar
		[203125] = Defaults(),  -- Mark of Emeriss
		[203124] = Defaults(),  -- Mark of Lethon
		[204731] = Defaults(5), -- Wasting Dread
		[203110] = Defaults(5), -- Slumbering Nightmare
		[207681] = Defaults(5), -- Nightmare Bloom
		[205341] = Defaults(5), -- Sleeping Fog
		[203770] = Defaults(5), -- Defiled Vines
		[203787] = Defaults(5), -- Volatile Infection

		-- Cenarius
		[210279] = Defaults(), -- Creeping Nightmares
		[213162] = Defaults(), -- Nightmare Blast
		[210315] = Defaults(), -- Nightmare Brambles
		[212681] = Defaults(), -- Cleansed Ground
		[211507] = Defaults(), -- Nightmare Javelin
		[211471] = Defaults(), -- Scorned Touch
		[211612] = Defaults(), -- Replenishing Roots
		[216516] = Defaults(), -- Ancient Dream

		-- Xavius
		[206005] = Defaults(), -- Dream Simulacrum
		[206651] = Defaults(), -- Darkening Soul
		[209158] = Defaults(), -- Blackening Soul
		[211802] = Defaults(), -- Nightmare Blades
		[206109] = Defaults(), -- Awakening to the Nightmare
		[209034] = Defaults(), -- Bonds of Terror
		[210451] = Defaults(), -- Bonds of Terror
		[208431] = Defaults(), -- Corruption: Descent into Madness
		[207409] = Defaults(), -- Madness
		[211634] = Defaults(), -- The Infinite Dark
		[208385] = Defaults(), -- Tainted Discharge

	-- Trial of Valor
		-- Odyn
		[227959] = Defaults(), -- Storm of Justice
		[227807] = Defaults(), -- Storm of Justice
		[227475] = Defaults(), -- Cleansing Flame
		[192044] = Defaults(), -- Expel Light
		[228030] = Defaults(), -- Expel Light
		[227781] = Defaults(), -- Glowing Fragment
		[228918] = Defaults(), -- Stormforged Spear
		[227490] = Defaults(), -- Branded
		[227491] = Defaults(), -- Branded
		[227498] = Defaults(), -- Branded
		[227499] = Defaults(), -- Branded
		[227500] = Defaults(), -- Branded
		[231297] = Defaults(), -- Runic Brand (Mythic Only)

		-- Guarm
		[228228] = Defaults(), -- Flame Lick
		[228248] = Defaults(), -- Frost Lick
		[228253] = Defaults(), -- Shadow Lick
		[227539] = Defaults(), -- Fiery Phlegm
		[227566] = Defaults(), -- Salty Spittle
		[227570] = Defaults(), -- Dark Discharge

		-- Helya
		[228883] = Defaults(5), -- Unholy Reckoning (Trash)
		[227903] = Defaults(),  -- Orb of Corruption
		[228058] = Defaults(),  -- Orb of Corrosion
		[229119] = Defaults(),  -- Orb of Corrosion
		[228054] = Defaults(),  -- Taint of the Sea
		[193367] = Defaults(),  -- Fetid Rot
		[227982] = Defaults(),  -- Bilewater Redox
		[228519] = Defaults(),  -- Anchor Slam
		[202476] = Defaults(),  -- Rabid
		[232450] = Defaults(),  -- Corrupted Axion

	-- Mythic Dungeons
		[226303] = Defaults(), -- Piercing Shards (Neltharion's Lair)
		[227742] = Defaults(), -- Garrote (Karazhan)
		[209858] = Defaults(), -- Necrotic
		[226512] = Defaults(), -- Sanguine
		[240559] = Defaults(), -- Grievous
		[240443] = Defaults(), -- Bursting
		[196376] = Defaults(), -- Grievous Tear
		[200227] = Defaults(), -- Tangled Web
	},
}

--[[
	RAID BUFFS:
	Buffs that are provided by NPCs in raid or other PvE content.
	This can be buffs put on other enemies or on players.
]]
G.unitframe.aurafilters['RaidBuffsElvUI'] = {
	['type'] = 'Whitelist',
	['spells'] = {
		--Mythic/Mythic+
		[209859] = Defaults(), -- Bolster
		[178658] = Defaults(), -- Raging
		[226510] = Defaults(), -- Sanguine

		--Raids
	},
}

-- Spells that we want to show the duration backwards
E.ReverseTimer = {

}

-- BuffWatch: List of personal spells to show on unitframes as icon
local function ClassBuff(id, point, color, anyUnit, onlyShowMissing, style, displayText, decimalThreshold, textColor, textThreshold, xOffset, yOffset, sizeOverride)
	local r, g, b = unpack(color)

	local r2, g2, b2 = 1, 1, 1
	if textColor then
		r2, g2, b2 = unpack(textColor)
	end

	return {["enabled"] = true, ["id"] = id, ["point"] = point, ["color"] = {["r"] = r, ["g"] = g, ["b"] = b},
	["anyUnit"] = anyUnit, ["onlyShowMissing"] = onlyShowMissing, ['style'] = style or 'coloredIcon', ['displayText'] = displayText or false, ['decimalThreshold'] = decimalThreshold or 5,
	['textColor'] = {["r"] = r2, ["g"] = g2, ["b"] = b2}, ['textThreshold'] = textThreshold or -1, ['xOffset'] = xOffset or 0, ['yOffset'] = yOffset or 0, ["sizeOverride"] = sizeOverride or 0}
end

G.unitframe.buffwatch = {
	PRIEST = {
		[194384] = ClassBuff(194384, "TOPRIGHT", {1, 1, 0.66}),          -- Atonement
		[41635]  = ClassBuff(41635, "BOTTOMRIGHT", {0.2, 0.7, 0.2}),     -- Prayer of Mending
		[193065] = ClassBuff(193065, "BOTTOMRIGHT", {0.54, 0.21, 0.78}), -- Masochism
		[139]    = ClassBuff(139, "BOTTOMLEFT", {0.4, 0.7, 0.2}),        -- Renew
		[17]     = ClassBuff(17, "TOPLEFT", {0.7, 0.7, 0.7}, true),      -- Power Word: Shield
		[47788]  = ClassBuff(47788, "LEFT", {0.86, 0.45, 0}, true),      -- Guardian Spirit
		[33206]  = ClassBuff(33206, "LEFT", {0.47, 0.35, 0.74}, true),   -- Pain Suppression
	},
	DRUID = {
		[774]    = ClassBuff(774, "TOPRIGHT", {0.8, 0.4, 0.8}),   		-- Rejuvenation
		[155777] = ClassBuff(155777, "RIGHT", {0.8, 0.4, 0.8}),   		-- Germination
		[8936]   = ClassBuff(8936, "BOTTOMLEFT", {0.2, 0.8, 0.2}),		-- Regrowth
		[33763]  = ClassBuff(33763, "TOPLEFT", {0.4, 0.8, 0.2}),  		-- Lifebloom
		[188550] = ClassBuff(188550, "TOPLEFT", {0.4, 0.8, 0.2}), 		-- Lifebloom T18 4pc
		[48438]  = ClassBuff(48438, "BOTTOMRIGHT", {0.8, 0.4, 0}),		-- Wild Growth
		[207386] = ClassBuff(207386, "TOP", {0.4, 0.2, 0.8}),     		-- Spring Blossoms
		[102351] = ClassBuff(102351, "LEFT", {0.2, 0.8, 0.8}),    		-- Cenarion Ward (Initial Buff)
		[102352] = ClassBuff(102352, "LEFT", {0.2, 0.8, 0.8}),    		-- Cenarion Ward (HoT)
		[200389] = ClassBuff(200389, "BOTTOM", {1, 1, 0.4}),      		-- Cultivation
	},
	PALADIN = {
		[53563]  = ClassBuff(53563, "TOPRIGHT", {0.7, 0.3, 0.7}),          -- Beacon of Light
		[156910] = ClassBuff(156910, "TOPRIGHT", {0.7, 0.3, 0.7}),         -- Beacon of Faith
		[200025] = ClassBuff(200025, "TOPRIGHT", {0.7, 0.3, 0.7}),         -- Beacon of Virtue
		[1022]   = ClassBuff(1022, "BOTTOMRIGHT", {0.2, 0.2, 1}, true),    -- Hand of Protection
		[1044]   = ClassBuff(1044, "BOTTOMRIGHT", {0.89, 0.45, 0}, true),  -- Hand of Freedom
		[6940]   = ClassBuff(6940, "BOTTOMRIGHT", {0.89, 0.1, 0.1}, true), -- Hand of Sacrifice
		[223306] = ClassBuff(223306, 'BOTTOMLEFT', {0.7, 0.7, 0.3}),       -- Bestow Faith
	},
	SHAMAN = {
		[61295]  = ClassBuff(61295, "TOPRIGHT", {0.7, 0.3, 0.7}),   	 -- Riptide
		[204288] = ClassBuff(204288, "BOTTOMRIGHT", {0.2, 0.2, 1}), 	 -- Earth Shield (Honor Talent)
	},
	MONK = {
		[119611] = ClassBuff(119611, "TOPLEFT", {0.3, 0.8, 0.6}),        -- Renewing Mist
		[116849] = ClassBuff(116849, "TOPRIGHT", {0.2, 0.8, 0.2}, true), -- Life Cocoon
		[124682] = ClassBuff(124682, "BOTTOMLEFT", {0.8, 0.8, 0.25}),    -- Enveloping Mist
		[191840] = ClassBuff(191840, "BOTTOMRIGHT", {0.27, 0.62, 0.7}),  -- Essence Font
	},
	ROGUE = {
		[57934] = ClassBuff(57934, "TOPRIGHT", {0.89, 0.09, 0.05}),		 -- Tricks of the Trade
	},
	WARRIOR = {
		[114030] = ClassBuff(114030, "TOPLEFT", {0.2, 0.2, 1}),     	 -- Vigilance
		[3411]   = ClassBuff(3411, "TOPRIGHT", {0.89, 0.09, 0.05}), 	 -- Intervene
	},
	PET = {
		-- Warlock Pets
		[193396] = ClassBuff(193396, 'TOPRIGHT', {0.6, 0.2, 0.8}, true), -- Demonic Empowerment
		-- Hunter Pets
		[19615] = ClassBuff(19615, 'TOPLEFT', {0.89, 0.09, 0.05}, true), -- Frenzy
		[136]   = ClassBuff(136, 'TOPRIGHT', {0.2, 0.8, 0.2}, true)      -- Mend Pet
	},
	HUNTER = {}, --Keep even if it's an empty table, so a reference to G.unitframe.buffwatch[E.myclass][SomeValue] doesn't trigger error
	DEMONHUNTER = {},
	WARLOCK = {},
	MAGE = {},
	DEATHKNIGHT = {},
}

-- Profile specific BuffIndicator
P['unitframe']['filters'] = {
	['buffwatch'] = {},
}

-- List of spells to display ticks
G.unitframe.ChannelTicks = {
	-- Warlock
	[SpellName(198590)] = 6, -- Drain Soul
	[SpellName(755)]    = 6, -- Health Funnel
	-- Priest
	[SpellName(64843)]  = 4, -- Divine Hymn
	[SpellName(15407)]  = 4, -- Mind Flay
	-- Mage
	[SpellName(5143)]   = 5,  -- Arcane Missiles
	[SpellName(12051)]  = 3,  -- Evocation
	[SpellName(205021)] = 10, -- Ray of Frost
}

local priestTier17 = {115560,115561,115562,115563,115564}
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
f:SetScript("OnEvent", function()
	local class = select(2, UnitClass("player"))
	if lower(class) ~= "priest" then return; end

	local penanceTicks = 3
	local equippedPriestTier17 = 0
	for _, item in pairs(priestTier17) do
		if IsEquippedItem(item) then
			equippedPriestTier17 = equippedPriestTier17 + 1
		end
	end
	if equippedPriestTier17 >= 2 then
		penanceTicks = 4
	end
	E.global.unitframe.ChannelTicks[SpellName(47540)] = penanceTicks --Penance
end)

G.unitframe.ChannelTicksSize = {
	-- Warlock
	[SpellName(198590)] = 1, -- Drain Soul
}

-- Spells Effected By Haste
G.unitframe.HastedChannelTicks = {
	[SpellName(205021)] = true, -- Ray of Frost
}

-- This should probably be the same as the whitelist filter + any personal class ones that may be important to watch
G.unitframe.AuraBarColors = {
	[2825]  = {r = 0.98, g = 0.57, b = 0.10}, -- Bloodlust
	[32182] = {r = 0.98, g = 0.57, b = 0.10}, -- Heroism
	[80353] = {r = 0.98, g = 0.57, b = 0.10}, -- Time Warp
	[90355] = {r = 0.98, g = 0.57, b = 0.10}, -- Ancient Hysteria
}

G.unitframe.DebuffHighlightColors = {
	[25771] = {enable = false, style = "FILL", color = {r = 0.85, g = 0, b = 0, a = 0.85}},
}

G.unitframe.specialFilters = {
	['Boss'] = true,
	['Personal'] = true,
	['nonPersonal'] = true,
	['blockNonPersonal'] = true,
	['CastByUnit'] = true,
	['notCastByUnit'] = true,
	['blockNoDuration'] = true,
	['Dispellable'] = true,
	['CastByNPC'] = true,
	['CastByPlayers'] = true,
	['blockCastByPlayers'] = true,
};
