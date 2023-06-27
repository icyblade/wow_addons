do
	local _detalhes = _G._detalhes

	_detalhes.PotionList = {}

	--import potion list from the framework
	for spellID, _ in pairs(DetailsFramework.PotionIDs) do
		_detalhes.PotionList[spellID] = true
	end

	_detalhes.SpecSpellList = { --~spec
		-- Unholy Death Knight:
		[49206] = 252, -- Summon Gargoyle
		[55090] = 252, -- Scourge Strike (Physical)
		[70890] = 252, -- Scourge Strike (Shadow)
		[65142] = 252, -- Ebon Plague

		-- Frost Death Knight:
		[49143] = 251, -- Frost Strike
		[66196] = 251, -- Frost Strike Off-Hand
		[49184] = 251, -- Howling Blast

		-- Blood Death Knight:
		[55233] = 250, -- Vampiric Blood
		[53138] = 250, -- Abomination's Might
		[55050] = 250, -- Heart Strike

		-- Balance Druid:
		[50288] = 102, -- Starfall
		[24858] = 102, -- Moonkin Form
		[78674] = 102, -- Starsurge

		-- Feral Druid:
		[52610] = 103, -- Savage Roar
		[5217] = 103, -- Tiger's Fury, Rank 6
		[1822] = 103, -- Rake, Rank 7
		[1079] = 103, -- Rip, Rank 9

		-- Guardian Druid:
		[33745] = 104, -- Lacerate
		[6807] = 104, -- Maul
		[62606] = 104, -- Savage Defense

		-- Restoration Druid:
		[100977] = 105, -- Harmony
		[48438] = 105, -- Wild Growth
		[18562] = 105, -- Swiftmend

		-- Beast Mastery Hunter:
		[34471] = 253, -- Bestial Wrath
		[53257] = 253, -- Cobra Strikes

		-- Marksmanship Hunter:
		[53209] = 254, -- Chimera Shot
		[19506] = 254, -- Trueshot Aura

		-- Survival Hunter:
		[3674] = 255, -- Black Arrow Rank 6
		[53301] = 255, -- Explosive Shot Rank 4
		[53290] = 255, -- Hunting Party
		[56453] = 255, -- Lock and Load
		[64420] = 255, -- Sniper Training

		-- Arcane Mage:
		[12042] = 62, -- Arcane Power
		[31589] = 62, -- Slow
		[44425] = 62, -- Arcane Barrage
		[82930] = 62, -- Arcane Tactics

		-- Fire Mage:
		[44457] = 63, -- Living Bomb (DoT)
		[31661] = 63, -- Dragon's Breath, Rank 6
		[11366] = 63, -- Pyroblast

		-- Frost Mage:
		[44544] = 64, -- Fingers of Frost
		[11426] = 64, -- Ice Barrier
		[44572] = 64, -- Deep Freeze

		-- Holy Paladin:
		[31842] = 65, -- Divine Favor
		[25914] = 65, -- Holy Shock
		[54149] = 65, -- Infusion of Light
		[20053] = 65, -- Conviction
		[86273] = 65, -- Illuminated Healing (mastery)
		[85222] = 65, -- Light of Dawn

		-- Protection Paladin:
		[88263] = 66, -- Hammer of the Righteous
		[53600] = 66, -- Shield of the Righteous
		[31935] = 66, -- Avenger's Shield
		[20925] = 66, -- Holy Shield
		[31850] = 66, -- Ardent Defender

		-- Retribution Paladin:
		[53385] = 70, -- Divine Storm
		[85256] = 70, -- Templar's Verdict
		[89906] = 70, -- Judgements of the Bold
		
		-- Discipline Priest:
		[10060] = 256, -- Power Infusion
		[89485] = 256, -- Inner Focus
		[33206] = 256, -- Pain Suppression
		[47750] = 256, -- Penance
		[47753] = 256, -- Divine Aegis
		[59888] = 256, -- Borrowed Time
		[47755] = 256, -- Rapture

		-- Holy Priest:
		[34861] = 257, -- Circle of Healing, Rank 7
		[47788] = 257, -- Guardian Spirit
		[81206] = 257, -- Chakra: Sanctuary
		[81208] = 257, -- Chakra: Serenity

		-- Shadow Priest:
		[15286] = 258, -- Vampiric Embrace
		[34914] = 258, -- Vampiric Touch
		[15407] = 258, -- Mind Flay

		-- Assassination Rogue:
		[32645] = 259, -- Envenom
		[1329] = 259, -- Mutilate
		[5374] = 259, -- Mutilate
		[27576] = 259, -- Mutilate Off-Hand
		[14177] = 259, -- Cold Blood
		[51662] = 259, -- Hunger for Blood

		-- Combat Rogue:
		[51690] = 260, -- Killing Spree
		[13750] = 260, -- Adrenaline Rush
		[13877] = 260, -- Blade Flurry
		[14251] = 260, -- Riposte

		-- Subtlety Rogue:
		[48660] = 261, -- Hemorrhage rank 5
		[14183] = 261, -- Premeditation
		[14185] = 261, -- Preparation
		[51713] = 261, -- Shadow Dance
		[14278] = 261, -- Ghostly Strike

		-- Elemental Shaman:
		[64701] = 262, -- Elemental Mastery
		[16166] = 262, -- Elemental Mastery
		[51490] = 262, -- Thunderstorm
		[88767] = 262, -- Fulmination

		-- Enhancement Shaman:
		[51533] = 263, -- Feral Spirit
		[51530] = 263, -- Maelstrom Weapon
		[60103] = 263, -- Lava Lash

		-- Restoration Shaman:
		[53390] = 264, -- Tidal Waves
		[1064]  = 264, -- Chain Heal
		[974]   = 264, -- Earth Shield
		[61295] = 264, -- Riptide

		-- Affliction :
		[48181] = 265, -- Haunt
		[30108] = 265, -- Unstable Affliction

		-- Demonology Warlock:
		[30146] = 266, -- Summon Felguard
		[47241] = 266, -- Metamorphosis
		[47193] = 266, -- Demonic Empowerment
		[71521] = 266, -- Hand of Gul'dan

		-- Destruction Warlock:
		[50796] = 267, -- Chaos Bolt, Rank 4
		[17962] = 267, -- Conflagrate
		[80240] = 267, -- Bane of Havoc

		-- Arms Warrior:
		[12328] = 71, -- Sweeping Strikes
		[60503] = 71, -- Taste for Blood
		[12294] = 71, -- Mortal Strike
		[76858] = 71, -- Opportunity Strike (mastery)

		-- Fury Warrior:
		[23881] = 72, -- Bloodthirst
		[29801] = 72, -- Rampage
		[23588] = 72, -- Dual Wield Specialization, Rank 5
		[46917] = 72, -- Titan's Grip
		[49152] = 72, -- Titan's Grip Effect

		-- Protection Warrior:
		[871] = 73, -- Shield Wall
		[12975] = 73, -- Last Stand
		[57823] = 73, -- Revenge
		[47498] = 73, -- Devastate
		[2565] = 73, -- Shield Block
		[47488] = 73, -- Shield Slam
		[46953] = 73, -- Sword and Board
		[50227] = 73, -- Sword and Board Trigger
	}

	_detalhes.ClassSpellList = {
		[47568] = "DEATHKNIGHT", -- Empower Rune Weapon
		[48982] = "DEATHKNIGHT", -- Rune Tap
		[55050] = "DEATHKNIGHT", -- Heart Strike
		[48707] = "DEATHKNIGHT", -- Anti-Magic Shell
		[73975] = "DEATHKNIGHT", -- Necrotic Strike
		[49576] = "DEATHKNIGHT", -- Death Grip
		[45524] = "DEATHKNIGHT", -- Chains of Ice
		[43265] = "DEATHKNIGHT", -- Death and Decay
		[55095] = "DEATHKNIGHT", -- Frost Fever
		[49222] = "DEATHKNIGHT", -- Bone Shield
		[48721] = "DEATHKNIGHT", -- Blood Boil
		[48263] = "DEATHKNIGHT", -- Blood Presence
		[49184] = "DEATHKNIGHT", -- Howling Blast
		[52212] = "DEATHKNIGHT", -- Death and Decay
		[66196] = "DEATHKNIGHT", -- Frost Strike Off-Hand
		[48266] = "DEATHKNIGHT", -- Frost Presence
		[85948] = "DEATHKNIGHT", -- Festering Strike
		[55078] = "DEATHKNIGHT", -- Blood Plague
		[49143] = "DEATHKNIGHT", -- Frost Strike
		[45529] = "DEATHKNIGHT", -- Blood Tap
		[48743] = "DEATHKNIGHT", -- Death Pact
		[45470] = "DEATHKNIGHT", -- Death Strike
		[61999] = "DEATHKNIGHT", -- Raise Ally
		[48265] = "DEATHKNIGHT", -- Unholy Presence
		[45902] = "DEATHKNIGHT", -- Blood Strike
		[57330] = "DEATHKNIGHT", -- Horn of Winter
		[48792] = "DEATHKNIGHT", -- Icebound Fortitude
		[49206] = "DEATHKNIGHT", -- Summon Gargoyle
		[49016] = "DEATHKNIGHT", -- Unholy Frenzy
		[51271] = "DEATHKNIGHT", -- Pillar of Frost
		[47541] = "DEATHKNIGHT", -- Death Coil
		[55090] = "DEATHKNIGHT", -- Scourge Strike
		[96268] = "DEATHKNIGHT", -- Death's Advance
		[53365] = "DEATHKNIGHT", -- Unholy Strength
		[50401] = "DEATHKNIGHT", -- Razor Frost
		[47632] = "DEATHKNIGHT", -- Death Coil
		[55233] = "DEATHKNIGHT", -- Vampiric Blood
		[42650] = "DEATHKNIGHT", -- Army of the Dead
		[77606] = "DEATHKNIGHT", -- Dark Simulacrum
		[3714]  = "DEATHKNIGHT", -- Path of Frost
		[50842] = "DEATHKNIGHT", -- Pestilence
		[50977] = "DEATHKNIGHT", -- Death Gate
		[49039] = "DEATHKNIGHT", -- Lichborne
		[63560] = "DEATHKNIGHT", -- Dark Transformation
		[45477] = "DEATHKNIGHT", -- Icy Touch
		[77575] = "DEATHKNIGHT", -- Outbreak
		[66198] = "DEATHKNIGHT", -- Obliterate Off-Hand
		[49020] = "DEATHKNIGHT", -- Obliterate
		[49998] = "DEATHKNIGHT", -- Death Strike
		[77535] = "DEATHKNIGHT", -- Blood Shield
		[49028] = "DEATHKNIGHT", -- Dancing Rune Weapon
		[56222] = "DEATHKNIGHT", -- Dark Command
		[66216] = "DEATHKNIGHT", -- Plague Strike Off-Hand
		[47528] = "DEATHKNIGHT", -- Mind Freeze
		[45462] = "DEATHKNIGHT", -- Plague Strike
		[56815] = "DEATHKNIGHT", -- Rune Strike

		[24858] = "DRUID", -- Moonkin Form
		[16914] = "DRUID", -- Hurricane
		[33763] = "DRUID", -- Lifebloom
		[8936]  = "DRUID", -- Regrowth
		[17057] = "DRUID", -- Furor
		[48438] = "DRUID", -- Wild Growth
		[48503] = "DRUID", -- Living Seed
		[1126]  = "DRUID", -- Mark of the Wild
		[33891] = "DRUID", -- Tree of Life
		[52610] = "DRUID", -- Savage Roar
		[20484] = "DRUID", -- Rebirth
		[62078] = "DRUID", -- Swipe
		[22842] = "DRUID", -- Frenzied Regeneration
		[18562] = "DRUID", -- Swiftmend
		[33876] = "DRUID", -- Mangle
		[22570] = "DRUID", -- Maim
		[2912]  = "DRUID", -- Starfire
		[48505] = "DRUID", -- Starfall
		[16979] = "DRUID", -- Feral Charge
		[29166] = "DRUID", -- Innervate
		[16959] = "DRUID", -- Primal Fury
		[6807]  = "DRUID", -- Maul
		[5211]  = "DRUID", -- Bash
		[61391] = "DRUID", -- Typhoon
		[2908]  = "DRUID", -- Soothe
		[42231] = "DRUID", -- Hurricane
		[5185]  = "DRUID", -- Healing Touch
		[33831] = "DRUID", -- Force of Nature
		[33878] = "DRUID", -- Mangle
		[22568] = "DRUID", -- Ferocious Bite
		[9005]  = "DRUID", -- Pounce
		[5215]  = "DRUID", -- Prowl
		[5221]  = "DRUID", -- Shred
		[8921]  = "DRUID", -- Moonfire
		[5217]  = "DRUID", -- Tiger's Fury
		[5229]  = "DRUID", -- Enrage
		[5225]  = "DRUID", -- Track Humanoids
		[16953] = "DRUID", -- Primal Fury
		[62606] = "DRUID", -- Savage Defense
		[61336] = "DRUID", -- Survival Instincts
		[44203] = "DRUID", -- Tranquility
		[770]   = "DRUID", -- Faerie Fire
		[50464] = "DRUID", -- Nourish
		[1079]  = "DRUID", -- Rip
		[50334] = "DRUID", -- Berserk
		[68285] = "DRUID", -- Leader of the Pack
		[50288] = "DRUID", -- Starfall
		[774]   = "DRUID", -- Rejuvenation
		[779]   = "DRUID", -- Swipe
		[33917] = "DRUID", -- Mangle
		[6795]  = "DRUID", -- Growl
		[6785]  = "DRUID", -- Ravage
		[49376] = "DRUID", -- Feral Charge
		[1822]  = "DRUID", -- Rake
		[5176]  = "DRUID", -- Wrath
		[1850]  = "DRUID", -- Dash
		[33778] = "DRUID", -- Lifebloom
		[22812] = "DRUID", -- Barkskin
		[768]   = "DRUID", -- Cat Form
		[16689] = "DRUID", -- Nature's Grasp
		[33745] = "DRUID", -- Lacerate

		[781]   = "HUNTER", -- Disengage
		[53353] = "HUNTER", -- Chimera Shot
		[53271] = "HUNTER", -- Master's Call
		[19574] = "HUNTER", -- Bestial Wrath
		[34026] = "HUNTER", -- Kill Command
		[77767] = "HUNTER", -- Cobra Shot
		[53209] = "HUNTER", -- Chimera Shot
		[53301] = "HUNTER", -- Explosive Shot
		[56641] = "HUNTER", -- Steady Shot
		[19386] = "HUNTER", -- Wyvern Sting
		[53351] = "HUNTER", -- Kill Shot
		[13165] = "HUNTER", -- Aspect of the Hawk
		[34477] = "HUNTER", -- Misdirection
		[19263] = "HUNTER", -- Deterrence
		[19503] = "HUNTER", -- Scatter Shot
		[20736] = "HUNTER", -- Distracting Shot
		[5118]  = "HUNTER", -- Aspect of the Cheetah
		[883]   = "HUNTER", -- Call Pet 1
		[19577] = "HUNTER", -- Intimidation
		[13159] = "HUNTER", -- Aspect of the Pack
		[3044]  = "HUNTER", -- Arcane Shot
		[13812] = "HUNTER", -- Explosive Trap
		[51753] = "HUNTER", -- Camouflage
		[1543]  = "HUNTER", -- Flare
		[13813] = "HUNTER", -- Explosive Trap
		[1978]  = "HUNTER", -- Serpent Sting
		[19434] = "HUNTER", -- Aimed Shot
		[3674]  = "HUNTER", -- Black Arrow
		[5116]  = "HUNTER", -- Concussive Shot
		[60192] = "HUNTER", -- Freezing Trap
		[34490] = "HUNTER", -- Silencing Shot
		[1130]  = "HUNTER", -- Hunter's Mark
		[2643]  = "HUNTER", -- Multi-Shot
		[19801] = "HUNTER", -- Tranquilizing Shot
		[2641]  = "HUNTER", -- Dismiss Pet
		[3045]  = "HUNTER", -- Rapid Fire

		[12043] = "MAGE", -- Presence of Mind
		[30449] = "MAGE", -- Spellsteal
		[31687] = "MAGE", -- Summon Water Elemental
		[61316] = "MAGE", -- Dalaran Brilliance
		[1953]  = "MAGE", -- Blink
		[55342] = "MAGE", -- Mirror Image
		[42956] = "MAGE", -- Conjure Refreshment
		[12051] = "MAGE", -- Evocation
		[11129] = "MAGE", -- Combustion
		[45438] = "MAGE", -- Ice Block
		[116]   = "MAGE", -- Frostbolt
		[11958] = "MAGE", -- Cold Snap
		[12042] = "MAGE", -- Arcane Power
		[12472] = "MAGE", -- Icy Veins
		[2139]  = "MAGE", -- Counterspell
		[44572] = "MAGE", -- Deep Freeze

		[31821] = "PALADIN", -- Aura Mastery
		[53652] = "PALADIN", -- Beacon of Light
		[642]   = "PALADIN", -- Divine Shield
		[31803] = "PALADIN", -- Censure
		[62124] = "PALADIN", -- Hand of Reckoning
		[20164] = "PALADIN", -- Seal of Justice
		[53563] = "PALADIN", -- Beacon of Light
		[53595] = "PALADIN", -- Hammer of the Righteous
		[633]   = "PALADIN", -- Lay on Hands
		[31884] = "PALADIN", -- Avenging Wrath
		[66235] = "PALADIN", -- Ardent Defender
		[31801] = "PALADIN", -- Seal of Truth
		[17233] = "PALADIN", -- Lay on Hands
		[54428] = "PALADIN", -- Divine Plea
		[35395] = "PALADIN", -- Crusader Strike
		[1044]  = "PALADIN", -- Hand of Freedom
		[54172] = "PALADIN", -- Divine Storm
		[31842] = "PALADIN", -- Divine Favor
		[4987]  = "PALADIN", -- Cleanse
		[20271] = "PALADIN", -- Judgement
		[20167] = "PALADIN", -- Seal of Insight
		[63148] = "PALADIN", -- Divine Shield
		[25780] = "PALADIN", -- Righteous Fury
		[20217] = "PALADIN", -- Blessing of Kings
		[42463] = "PALADIN", -- Seal of Truth
		[20154] = "PALADIN", -- Seal of Righteousness
		[53385] = "PALADIN", -- Divine Storm
		[20165] = "PALADIN", -- Seal of Insight

		[33110] = "PRIEST", -- Prayer of Mending
		[56160] = "PRIEST", -- Glyph of Power Word: Shield
		[15473] = "PRIEST", -- Shadowform
		[33206] = "PRIEST", -- Pain Suppression
		[32375] = "PRIEST", -- Mass Dispel
		[34919] = "PRIEST", -- Vampiric Touch
		[64843] = "PRIEST", -- Divine Hymn
		[64901] = "PRIEST", -- Hymn of Hope
		[34433] = "PRIEST", -- Shadowfiend
		[1706]  = "PRIEST", -- Levitate
		[64844] = "PRIEST", -- Divine Hymn
		[34650] = "PRIEST", -- Mana Leech
		[15286] = "PRIEST", -- Vampiric Embrace
		[47585] = "PRIEST", -- Dispersion
		[15290] = "PRIEST", -- Vampiric Embrace
		[586]   = "PRIEST", -- Fade
		[64904] = "PRIEST", -- Hymn of Hope
		[10060] = "PRIEST", -- Power Infusion
		[15487] = "PRIEST", -- Silence
		[47753] = "PRIEST", -- Divine Aegis
		[47788] = "PRIEST", -- Guardian Spirit

		[31224] = "ROGUE", -- Cloak of Shadows
		[35546] = "ROGUE", -- Combat Potency
		[13877] = "ROGUE", -- Blade Flurry
		[3408]  = "ROGUE", -- Crippling Poison
		[51637] = "ROGUE", -- Venomous Vim
		[22482] = "ROGUE", -- Blade Flurry
		[8679]  = "ROGUE", -- Instant Poison
		[57841] = "ROGUE", -- Killing Spree
		[57934] = "ROGUE", -- Tricks of the Trade
		[2094]  = "ROGUE", -- Blind
		[2823]  = "ROGUE", -- Deadly Poison
		[2818]  = "ROGUE", -- Deadly Poison
		[13750] = "ROGUE", -- Adrenaline Rush
		[14185] = "ROGUE", -- Preparation
		[1766]  = "ROGUE", -- Kick
		[8680]  = "ROGUE", -- Instant Poison
		[5277]  = "ROGUE", -- Evasion
		[51713] = "ROGUE", -- Shadow Dance
		[51690] = "ROGUE", -- Killing Spree
		[1833]  = "ROGUE", -- Cheap Shot
		[36554] = "ROGUE",   -- Shadowstep
		[5761]  = "ROGUE",   -- Mind-numbing Poison
		[14183] = "ROGUE",   -- Premeditation
		[51723] = "ROGUE",   -- Fan of Knives
		[57842] = "ROGUE",   -- Killing Spree Off-Hand

		[51533] = "SHAMAN",  -- Feral Spirit
		[51522] = "SHAMAN",  -- Primal Wisdom
		[30823] = "SHAMAN",  -- Shamanistic Rage
		[60103] = "SHAMAN",  -- Lava Lash
		[2894]  = "SHAMAN",  -- Fire Elemental Totem
		[2062]  = "SHAMAN",  -- Earth Elemental Totem
		[17364] = "SHAMAN",  -- Stormstrike
		[16166] = "SHAMAN",  -- Elemental Mastery
		[57994] = "SHAMAN",  -- Wind Shear
		[2825]  = "SHAMAN",  -- Bloodlust
		[8143]  = "SHAMAN",  -- Tremor Totem
		[55533] = "SHAMAN",  -- Glyph of Healing Wave
		[36936] = "SHAMAN",  -- Totemic Recall
		[8177]  = "SHAMAN",  -- Grounding Totem
		[52042] = "SHAMAN",  -- Healing Stream Totem
		[32175] = "SHAMAN",  -- Stormstrike
		[51505] = "SHAMAN",  -- Lava Burst
		[61882] = "SHAMAN",  -- Earthquake
		[51886] = "SHAMAN",  -- Cleanse Spirit
		[32176] = "SHAMAN",  -- Stormstrike Off-Hand
		[16188] = "SHAMAN",  -- Nature's Swiftness
		[25504] = "SHAMAN",  -- Windfury Attack
		[2645]  = "SHAMAN",  -- Ghost Wolf
		[10444] = "SHAMAN",  -- Flametongue Attack
		[58875] = "SHAMAN",  -- Spirit Walk
		[51514] = "SHAMAN",  -- Hex
		[63375] = "SHAMAN",  -- Primal Wisdom
		[21169] = "SHAMAN",  -- Reincarnation

		[48018] = "WARLOCK", -- Demonic Circle: Summon
		[17962] = "WARLOCK", -- Conflagrate
		[688]   = "WARLOCK", -- Summon Imp
		[1122]  = "WARLOCK", -- Summon Infernal
		[20707] = "WARLOCK", -- Soulstone Resurrection
		[63106] = "WARLOCK", -- Siphon Life
		[22703] = "WARLOCK", -- Infernal Awakening
		[697]   = "WARLOCK", -- Summon Voidwalker
		[48020] = "WARLOCK", -- Demonic Circle: Teleport
		[29858] = "WARLOCK", -- Soulshatter
		[47231] = "WARLOCK", -- Fel Synergy
		[18540] = "WARLOCK", -- Summon Doomguard
		[30146] = "WARLOCK", -- Summon Felguard
		[47230] = "WARLOCK", -- Fel Synergy

		[18499] = "WARRIOR", -- Berserker Rage
		[1680]  = "WARRIOR", -- Whirlwind
		[1715]  = "WARRIOR", -- Hamstring
		[12323] = "WARRIOR", -- Piercing Howl
		[871]   = "WARRIOR", -- Shield Wall
		[57755] = "WARRIOR", -- Heroic Throw
		[55694] = "WARRIOR", -- Enraged Regeneration
		[12292] = "WARRIOR", -- Death Wish
		[2565]  = "WARRIOR", -- Shield Block
		[34428] = "WARRIOR", -- Victory Rush
		[7384]  = "WARRIOR", -- Overpower
		[1719]  = "WARRIOR", -- Recklessness
		[355]   = "WARRIOR", -- Taunt
		[2457]  = "WARRIOR", -- Battle Stance
		[52174] = "WARRIOR", -- Heroic Leap
		[29842] = "WARRIOR", -- Second Wind
		[23881] = "WARRIOR", -- Bloodthirst
		[5246]  = "WARRIOR", -- Intimidating Shout
		[23920] = "WARRIOR", -- Spell Reflection
		[12975] = "WARRIOR", -- Last Stand
		[44949] = "WARRIOR", -- Whirlwind Off-Hand
		[64382] = "WARRIOR", -- Shattering Throw
		[3411]  = "WARRIOR", -- Intervene
		[12723] = "WARRIOR", -- Sweeping Strikes
		[29841] = "WARRIOR", -- Second Wind
		[50622] = "WARRIOR", -- Whirlwind
		[12328] = "WARRIOR", -- Sweeping Strikes
		[6552]  = "WARRIOR", -- Pummel
		[46924] = "WARRIOR", -- Bladestorm
		[46968] = "WARRIOR", -- Shockwave
	}

	_detalhes.HardCrowdControlSpells = {
		--> death knight

		--> druid
		[33786] = true, -- Cyclone

		--> hunter

		--> mage

		--> paladin

		--> priest

		--> rogue

		--> shaman

		--> warlock

		--> warrior

	}

	_detalhes.CrowdControlSpells = {
		--Racials
		[28730]	= true, -- Arcane Torrent(be)
		[25046]	= true, -- Arcane Torrent(be)
		[50613]	= true, -- Arcane Torrent(be)
		[69179]	= true, -- Arcane Torrent(be)
		[80483]	= true, -- Arcane Torrent(be)
		[20549]	= true, -- War Stomp(tauren)

		--death knight
		[47481]	= true, -- Gnaw
		[47528]	= true, -- Mind Freeze
		[47476]	= true, -- Strangulate
		[49203]	= true, -- Hungering Cold

		--druid
		[33786]	= true, -- Cyclone
		[339]	= true, -- Entangling Toots
		[45334]	= true, -- Immobilized(from Wild Charge)
		[99]	= true, -- Incapacitating Roar
		[22570]	= true, -- Maim
		[5211]	= true, -- Mighty Bash(talent)
		[16979]	= true, -- Wild Charge(talent)
		[78675]	= true, -- Solar Beam

		--hunter
		[64803]	= true, -- Entrapment
		[3355]	= true, -- Freezing trap
		[24394]	= true, -- Intimidation(pet)
		[24335]	= true, -- Wyvern sting
		[19386]	= true, -- Wyvern sting

		--mage
		[2139]	= true, -- Counterspell
		[44572]	= true, -- Deep Freeze
		[58534]	= true, -- Deep Freeze
		[31661]	= true, -- Dragon's Breath
		[33395]	= true, -- Freeze(pet)
		[122]	= true, -- Frost Nova
		[118]	= true, -- Polymorph sheep
		[28272]	= true, -- Polymorph pig
		[61305]	= true, -- Polymorph black cat
		[61721]	= true, -- Polymorph rabbit
		[61780]	= true, -- Polymorph turkey
		[28271]	= true, -- Polymorph turtle

		--paladin
		[31935]	= true, -- Avenger's Shield
		[853]	= true, -- Hammer of Justice
		[20066]	= true, -- Repentance

		--priest
		[605]	= true, -- Dominate Mind
		[64044]	= true, -- Psychic Horror
		[8122]	= true, -- Psychic scream
		[9484]	= true, -- Shackle undead
		[15487]	= true, -- Silence

		--rogue
		[2094]	= true, -- Blind
		[1833]	= true, -- Cheap shot
		[1330]	= true, -- Garrote
		[1776]	= true, -- Gouge
		[1766]	= true, -- Kick
		[408]	= true, -- Kidney shot
		[6770]	= true, -- Sap

		--shaman
		[64695]	= true, -- Earthgrab(earthgrab totem)
		[51514]	= true, -- Hex
		[51490]	= true, -- Thunderstorm
		[57994]	= true, -- Wind Shear

		--warlock
		[5782]	= true, -- Fear
		[5484]	= true, -- Howl of terror
		[6789]	= true, -- Mortal Coil
		[6358]	= true, -- Seduction(succubus)
		[30283]	= true, -- Shadowfury
		[19647]	= true, -- Spell Lock(Felhunters)
		[31117]	= true, -- Unstable Affliction

		--warrior
		[100]	= true, -- Charge
		[5246]	= true, -- Intimidating shout
		[6552]	= true, -- Pummel
		[7922]	= true, -- Warbringer
	}

	_detalhes.MageWardSpells = {
		[543] = 30 , -- Mage Ward (Mage)
	}

	_detalhes.WarlockShadowWardSpells = {
		[6229] = 30, -- Shadow Ward (warlock) Rank 1
	}

	_detalhes.MageIceBarrierSpells = {
		[11426] = 60, -- Ice Barrier (Mage)
	}

	_detalhes.WarlockSacrificeSpells = {
		[7812] = 30, -- Sacrifice (warlock)
	}

	_detalhes.AbsorbSpells = {
		-- Death Knight
		[48707] = 5, -- Anti-Magic Shell (DK) Rank 1 -- Does not currently seem to show tracable combat log events. It shows energizes which do not reveal the amount of damage absorbed
		[51052] = 10, -- Anti-Magic Zone (DK)( Rank 1 (Correct spellID?)
			-- Does DK Spell Deflection show absorbs in the CL?
		[77535] = 10, -- Blood Shield (DK)
		-- Druid
		[62606] = 10, -- Savage Defense proc. (Druid) Tooltip of the original spell doesn't clearly state that this is an absorb, but the buff does.
		-- Mage
		[11426] = 60, -- Ice Barrier (Mage) Rank 1
		[1463] = 60, --  Mana shield (Mage) Rank 1
		[543] = 30, -- Mage Ward
		-- Paladin
		[86273] = 6, -- Illuminated Healing
		[88063] = 6, -- Guarded by the Light
		[96263] = 15, -- Sacred Shield
		-- Priest
		[17] = 30, -- Power Word: Shield (Priest) Rank 1
		[47509] = 12, -- Divine Aegis (Priest) Rank 1
		[47511] = 12,
		[47515] = 12, -- Divine Aegis (Priest) Rank 3 (Some of these are not actual buff spellIDs)
		[47753] = 12, -- Divine Aegis (Priest) Rank 1
		[54704] = 12, -- Divine Aegis (Priest) Rank 1
		[47788] = 10, -- Guardian Spirit  (Priest) (50 nominal absorb, this may not show in the CL)
		[62618] = 25, -- Power Word: Barrier
		[81781] = 25, -- Power Word: Barrier
		-- Warlock
		[7812] = 30, -- Sacrifice (warlock)
		[6229] = 30, -- Shadow Ward (warlock)
		-- Consumables
		[29674] = 86400, -- Lesser Ward of Shielding
		[29719] = 86400, -- Greater Ward of Shielding (these have infinite duration, set for a day here :P)
		[29701] = 86400,
		[28538] = 120, -- Major Holy Protection Potion
		[28537] = 120, -- Major Shadow
		[28536] = 120, --  Major Arcane
		[28513] = 120, -- Major Nature
		[28512] = 120, -- Major Frost
		[28511] = 120, -- Major Fire
		[7233] = 120, -- Fire
		[7239] = 120, -- Frost
		[7242] = 120, -- Shadow Protection Potion
		[7245] = 120, -- Holy
		[6052] = 120, -- Nature Protection Potion
		[53915] = 120, -- Mighty Shadow Protection Potion
		[53914] = 120, -- Mighty Nature Protection Potion
		[53913] = 120, -- Mighty Frost Protection Potion
		[53911] = 120, -- Mighty Fire
		[53910] = 120, -- Mighty Arcane
		[17548] = 120, --  Greater Shadow
		[17546] = 120, -- Greater Nature
		[17545] = 120, -- Greater Holy
		[17544] = 120, -- Greater Frost
		[17543] = 120, -- Greater Fire
		[17549] = 120, -- Greater Arcane
		[28527] = 15, -- Fel Blossom
		[29432] = 3600, -- Frozen Rune usage (Naxx classic)
		-- Item usage
		[36481] = 4, -- Arcane Barrier (TK Kael'Thas) Shield
		[57350] = 6, -- Darkmoon Card: Illusion
		[17252] = 30, -- Mark of the Dragon Lord (LBRS epic ring) usage
		[25750] = 15, -- Defiler's Talisman/Talisman of Arathor Rank 1
		[25747] = 15,
		[25746] = 15,
		[23991] = 15,
		[31000] = 300, -- Pendant of Shadow's End Usage
		[30997] = 300, -- Pendant of Frozen Flame Usage
		[31002] = 300, -- Pendant of the Null Rune
		[30999] = 300, -- Pendant of Withering
		[30994] = 300, -- Pendant of Thawing
		[31000] = 300, -- Shadow Absorption
		[23506]= 20, -- Arena Grand Master Usage (Aura of Protection)
		[12561] = 60, -- Goblin Construction Helmet usage
		[31771] = 20, -- Runed Fungalcap usage
		[21956] = 10, -- Mark of Resolution usage
		[29506] = 20, -- The Burrower's Shell
		[4057] = 60, -- Flame Deflector
		[4077] = 60, -- Ice Deflector
		[39228] = 20, -- Argussian Compass (may not be an actual absorb)
		-- Item procs
		[27779] = 30, -- Divine Protection - Priest dungeon set 1/2  Proc
		[11657] = 20, -- Jang'thraze (Zul Farrak) proc
		[10368] = 15, -- Uther's Strength proc
		[37515] = 15, -- Warbringer Armor Proc
		[42137] = 86400, -- Greater Rune of Warding Proc
		[26467] = 30, -- Scarab Brooch proc
		[27539] = 6, -- Thick Obsidian Breatplate proc
		[28810] = 30, -- Faith Set Proc Armor of Faith
		[54808] = 12, -- Noise Machine proc Sonic Shield 
		[55019] = 12, -- Sonic Shield (one of these too ought to be wrong)
		[64411] = 15, -- Blessing of the Ancient (Val'anyr Hammer of Ancient Kings equip effect)
		[64413] = 8, -- Val'anyr, Hammer of Ancient Kings proc Protection of Ancient Kings
		[105909] = 6, -- Shield of Fury (Warrior T13 Protection 2P Bonus)
		[105801] = 6, -- Delayed Judgement (Paladin T13 Protection 2P Bonus)
		-- Misc
		[40322] = 30, -- Teron's Vengeful Spirit Ghost - Spirit Shield
		-- Boss abilities
		[65874] = 15, -- Twin Val'kyr's Shield of Darkness 175000
		[67257] = 15, -- 300000
		[67256] = 15, -- 700000
		[67258] = 15, -- 1200000
		[65858] = 15, -- Twin Val'kyr's Shield of Lights 175000
		[67260] = 15, -- 300000
		[67259] = 15, -- 700000
		[67261] = 15, -- 1200000
		[65686] = 86400, -- Twin Val'kyr Light Essence
		[65684] = 86400, -- Twin Val'kyr Dark Essence
	}

	-- ~cooldown 1 self
	_detalhes.DefensiveCooldownSpellsNoBuff = {
		[20594]	= {120, 8, 1}, -- racial stoneform

--		[6262] = {120, 1, 1}, -- healthstone

--		["DEATHKNIGHT"] = {},
		[48707]	= {45, 5, 1}, -- Anti-Magic Shell
		[48743]	= {120, 0, 1}, -- Death Pact
		[51052]	= {120, 3, 0}, -- Anti-Magic Zone
		[48982]	= {30, 0, 1}, -- "Blood Tap"

--		["DRUID"] = {},
		[740]	= {480, 8, 0}, -- Tranquility
		[22842]	= {0, 0, 1}, -- Frenzied Regeneration

--		["HUNTER"] = {},

--		["MAGE"] = {},

--		["PALADIN"] = {},
		[633]	= {600, 0, 0}, -- Lay on Hands
		[31821]	= {180, 6, 0}, -- Devotion Aura

--		["PRIEST"] = {},
		[62618]	= {180, 10, 0}, -- Power Word: Barrier
		[64843]	= {180, 8, 0}, -- Divine Hymn

--		["ROGUE"] = {},

--		["SHAMAN"] = {},

--		["WARLOCK"] = {108416, 6229},
		[6229]	= {30, 30, 1}, -- Twilight Ward 1 = self

--		["WARRIOR"] = {},
		[2565]	= {12, 6, 1}, -- Shield Block
		[871]	= {180, 12, 1}, -- Shield Wall
		[12975]	= {180, 20, 1}, -- Last Stand
		[23920]	= {25, 5, 1}, -- Spell Reflection
	}

	--> spellid = {cooldown, duration}
	_detalhes.DefensiveCooldownSpells = {
		-- Death Knigh
		[55233] = {60, 10}, -- Vampiric Blood
		[49222] = {60, 300}, -- Bone Shield
		[48792] = {180, 12}, -- Icebound Fortitude
		[48743] = {120, 0}, -- Death Pact
		[49039] = {12, 10}, -- Lichborne
		[48707] = {45, 7}, -- Anti-Magic Shell
		[49028] = {12, 10}, -- Dancing Rune Weapon
		[51052] = {120, 10}, -- Anti-Magic Zone
		["DEATHKNIGHT"] = {55233, 49222, 48792, 48743, 49039, 48707, 51052},

		-- Druid
		[62606] = {1.5, 6}, -- Savage Defense
		[61336] = {180, 12}, -- Survival Instincts
		[22812] = {60, 12}, -- Barkskin
		["DRUID"] = {62606, 61336, 22812, 740, 22842},

		-- Hunter
		[19263] = {120, 5}, -- Deterrence
		["HUNTER"] = {19263},

		-- Mage
		[45438] = {300, 12}, -- Ice Block
		["MAGE"] = {45438},

		-- Paladin
		[498] = {60, 10}, -- Divine Protection
		[642] = {300, 8}, -- Divine Shield
		[6940] = {120, 12}, -- Hand of Sacrifice
		[1022] = {300, 10}, -- Hand of Protection
		[1038] = {120, 10}, -- Hand of Salvation
		["PALADIN"] = {86659, 31850, 498, 642, 6940, 1022, 1038, 633, 31821},

		-- Priest
		[47788] = {180, 10}, -- Guardian Spirit
		[47585] = {120, 6}, -- Dispersion
		[33206] = {180, 8}, -- Pain Suppression
		["PRIEST"] = {47788, 47585, 33206, 62618, 109964, 64843},

		-- Rogue
		[1966] = {1.5, 5}, -- Feint
		[31224] = {60, 5}, -- Cloak of Shadows
		[5277] = {180, 15}, -- Evasion
		[1856] = {120, 0}, -- Vanish
		["ROGUE"] = {1966, 31224, 5277, 1856, 76577},

		-- Shaman
		[30823] = {60, 15}, -- Shamanistic Rage
		["SHAMAN"] = {30823},

		-- Warlock
		["WARLOCK"] = {6229},

		-- Warrior
		[871] = {180, 12}, -- Shield Wall
		[12975] = {180, 20}, -- Last Stand
		[23920] = {25, 5}, -- Spell Reflection
		["WARRIOR"] = {871, 12975, 23920, 2565}
	}


	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	_detalhes.SpellOverwrite = {
		--[124464] = {name = GetSpellInfo(124464).."("..Loc["STRING_MASTERY"]..")"}, --> shadow word: pain mastery proc(priest)
	}

	function _detalhes:IsCooldown(spellid)
		return _detalhes.DefensiveCooldownSpellsNoBuff[spellid] or _detalhes.DefensiveCooldownSpells[spellid]
	end

	_detalhes.spells_school = {
		[1] = {name = STRING_SCHOOL_PHYSICAL, formated = "|cFFFFFF00"..STRING_SCHOOL_PHYSICAL.."|r", hex = "FFFFFF00", rgb = {255, 255, 0}, decimals = {1.00, 1.00, 0.00}},
		[2] = {name = STRING_SCHOOL_HOLY, formated = "|cFFFFE680"..STRING_SCHOOL_HOLY.."|r", hex = "FFFFE680", rgb = {255, 230, 128}, decimals = {1.00, 0.90, 0.50}},
		[4] = {name = STRING_SCHOOL_FIRE, formated = "|cFFFF8000"..STRING_SCHOOL_FIRE.."|r", hex = "FFFF8000", rgb = {255, 128, 0}, decimals = {1.00, 0.50, 0.00}},
		[8] = {name = STRING_SCHOOL_NATURE, formated = "|cFFbeffbe"..STRING_SCHOOL_NATURE.."|r", hex = "FFbeffbe", rgb = {190, 190, 190}, decimals = {0.7451, 1.0000, 0.7451}},
		[16] = {name = STRING_SCHOOL_FROST, formated = "|cFF80FFFF"..STRING_SCHOOL_FROST.."|r", hex = "FF80FFFF", rgb = {128, 255, 255}, decimals = {0.50, 1.00, 1.00}},
		[32] = {name = STRING_SCHOOL_SHADOW, formated = "|cFF8080FF"..STRING_SCHOOL_SHADOW.."|r", hex = "FF8080FF", rgb = {128, 128, 255}, decimals = {0.50, 0.50, 1.00}},
		[64] = {name = STRING_SCHOOL_ARCANE, formated = "|cFFFF80FF"..STRING_SCHOOL_ARCANE.."|r", hex = "FFFF80FF", rgb = {255, 128, 255}, decimals = {1.00, 0.50, 1.00}},
		[3] = {name = STRING_SCHOOL_HOLYSTRIKE, formated = "|cFFFFF240"..STRING_SCHOOL_HOLYSTRIKE.."|r", hex = "FFFFF240", rgb = {255, 64, 64}, decimals = {1.0000, 0.9490, 0.2510}}, --#FFF240
		[5] = {name = STRING_SCHOOL_FLAMESTRIKE, formated = "|cFFFFB900"..STRING_SCHOOL_FLAMESTRIKE.."|r", hex = "FFFFB900", rgb = {255, 0, 0}, decimals = {1.0000, 0.7255, 0.0000}}, --#FFB900
		[6] = {name = STRING_SCHOOL_HOLYFIRE, formated = "|cFFFFD266"..STRING_SCHOOL_HOLYFIRE.."|r", hex = "FFFFD266", rgb = {255, 102, 102}, decimals = {1.0000, 0.8235, 0.4000}}, --#FFD266
		[9] = {name = STRING_SCHOOL_STORMSTRIKE, formated = "|cFFAFFF23"..STRING_SCHOOL_STORMSTRIKE.."|r", hex = "FFAFFF23", rgb = {175, 35, 35}, decimals = {0.6863, 1.0000, 0.1373}}, --#AFFF23
		[10] = {name = STRING_SCHOOL_HOLYSTORM, formated = "|cFFC1EF6E"..STRING_SCHOOL_HOLYSTORM.."|r", hex = "FFC1EF6E", rgb = {193, 110, 110}, decimals = {0.7569, 0.9373, 0.4314}}, --#C1EF6E
		[12] = {name = STRING_SCHOOL_FIRESTORM, formated = "|cFFAFB923"..STRING_SCHOOL_FIRESTORM.."|r", hex = "FFAFB923", rgb = {175, 35, 35}, decimals = {0.6863, 0.7255, 0.1373}}, --#AFB923
		[17] = {name = STRING_SCHOOL_FROSTSTRIKE, formated = "|cFFB3FF99"..STRING_SCHOOL_FROSTSTRIKE.."|r", hex = "FFB3FF99", rgb = {179, 153, 153}, decimals = {0.7020, 1.0000, 0.6000}},--#B3FF99
		[18] = {name = STRING_SCHOOL_HOLYFROST, formated = "|cFFCCF0B3"..STRING_SCHOOL_HOLYFROST.."|r", hex = "FFCCF0B3", rgb = {204, 179, 179}, decimals = {0.8000, 0.9412, 0.7020}},--#CCF0B3
		[20] = {name = STRING_SCHOOL_FROSTFIRE, formated = "|cFFC0C080"..STRING_SCHOOL_FROSTFIRE.."|r", hex = "FFC0C080", rgb = {192, 128, 128}, decimals = {0.7529, 0.7529, 0.5020}}, --#C0C080
		[24] = {name = STRING_SCHOOL_FROSTSTORM, formated = "|cFF69FFAF"..STRING_SCHOOL_FROSTSTORM.."|r", hex = "FF69FFAF", rgb = {105, 175, 175}, decimals = {0.4118, 1.0000, 0.6863}}, --#69FFAF
		[33] = {name = STRING_SCHOOL_SHADOWSTRIKE, formated = "|cFFC6C673"..STRING_SCHOOL_SHADOWSTRIKE.."|r", hex = "FFC6C673", rgb = {198, 115, 115}, decimals = {0.7765, 0.7765, 0.4510}},--#C6C673
		[34] = {name = STRING_SCHOOL_SHADOWHOLY, formated = "|cFFD3C2AC"..STRING_SCHOOL_SHADOWHOLY.."|r", hex = "FFD3C2AC", rgb = {211, 172, 172}, decimals = {0.8275, 0.7608, 0.6745}},--#D3C2AC
		[36] = {name = STRING_SCHOOL_SHADOWFLAME, formated = "|cFFB38099"..STRING_SCHOOL_SHADOWFLAME.."|r", hex = "FFB38099", rgb = {179, 153, 153}, decimals = {0.7020, 0.5020, 0.6000}}, -- #B38099
		[40] = {name = STRING_SCHOOL_SHADOWSTORM, formated = "|cFF6CB3B8"..STRING_SCHOOL_SHADOWSTORM.."|r", hex = "FF6CB3B8", rgb = {108, 184, 184}, decimals = {0.4235, 0.7020, 0.7216}}, --#6CB3B8
		[48] = {name = STRING_SCHOOL_SHADOWFROST, formated = "|cFF80C6FF"..STRING_SCHOOL_SHADOWFROST.."|r", hex = "FF80C6FF", rgb = {128, 255, 255}, decimals = {0.5020, 0.7765, 1.0000}},--#80C6FF
		[65] = {name = STRING_SCHOOL_SPELLSTRIKE, formated = "|cFFFFCC66"..STRING_SCHOOL_SPELLSTRIKE.."|r", hex = "FFFFCC66", rgb = {255, 102, 102}, decimals = {1.0000, 0.8000, 0.4000}},--#FFCC66
		[66] = {name = STRING_SCHOOL_DIVINE, formated = "|cFFFFBDB3"..STRING_SCHOOL_DIVINE.."|r", hex = "FFFFBDB3", rgb = {255, 179, 179}, decimals = {1.0000, 0.7412, 0.7020}},--#FFBDB3
		[68] = {name = STRING_SCHOOL_SPELLFIRE, formated = "|cFFFF808C"..STRING_SCHOOL_SPELLFIRE.."|r", hex = "FFFF808C", rgb = {255, 140, 140}, decimals = {1.0000, 0.5020, 0.5490}}, --#FF808C
		[72] = {name = STRING_SCHOOL_SPELLSTORM, formated = "|cFFAFB9AF"..STRING_SCHOOL_SPELLSTORM.."|r", hex = "FFAFB9AF", rgb = {175, 175, 175}, decimals = {0.6863, 0.7255, 0.6863}}, --#AFB9AF
		[80] = {name = STRING_SCHOOL_SPELLFROST, formated = "|cFFC0C0FF"..STRING_SCHOOL_SPELLFROST.."|r", hex = "FFC0C0FF", rgb = {192, 255, 255}, decimals = {0.7529, 0.7529, 1.0000}},--#C0C0FF
		[96] = {name = STRING_SCHOOL_SPELLSHADOW, formated = "|cFFB980FF"..STRING_SCHOOL_SPELLSHADOW.."|r", hex = "FFB980FF", rgb = {185, 255, 255}, decimals = {0.7255, 0.5020, 1.0000}},--#B980FF

		[28] = {name = STRING_SCHOOL_ELEMENTAL, formated = "|cFF0070DE"..STRING_SCHOOL_ELEMENTAL.."|r", hex = "FF0070DE", rgb = {0, 222, 222}, decimals = {0.0000, 0.4392, 0.8706}},
		[124] = {name = STRING_SCHOOL_CHROMATIC, formated = "|cFFC0C0C0"..STRING_SCHOOL_CHROMATIC.."|r", hex = "FFC0C0C0", rgb = {192, 192, 192}, decimals = {0.7529, 0.7529, 0.7529}},
		[126] = {name = STRING_SCHOOL_MAGIC, formated = "|cFF1111FF"..STRING_SCHOOL_MAGIC.."|r", hex = "FF1111FF", rgb = {17, 255, 255}, decimals = {0.0667, 0.0667, 1.0000}},
		[127] = {name = STRING_SCHOOL_CHAOS, formated = "|cFFFF1111"..STRING_SCHOOL_CHAOS.."|r", hex = "FFFF1111", rgb = {255, 17, 17}, decimals = {1.0000, 0.0667, 0.0667}},
	}

	_detalhes.OverrideSpellSchool = {
		--[196917] = 126, --light of the martyr - from holy to fire
	}

	function _detalhes:GetSpellSchoolName(school)
		return _detalhes.spells_school[school] and _detalhes.spells_school[school].name or ""
	end

	function _detalhes:GetSpellSchoolFormatedName(school)
		return _detalhes.spells_school[school] and _detalhes.spells_school[school].formated or ""
	end

	local default_school_color = {145/255, 180/255, 228/255}
	function _detalhes:GetSpellSchoolColor(school)
		return unpack(_detalhes.spells_school[school] and _detalhes.spells_school[school].decimals or default_school_color)
	end

	function _detalhes:GetCooldownList(class)
		class = class or select(2, UnitClass("player"))
		return _detalhes.DefensiveCooldownSpells[class]
	end
end