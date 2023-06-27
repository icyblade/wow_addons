--
VUHDO_DEBUFF_TYPE_NONE = 0;
VUHDO_DEBUFF_TYPE_POISON = 1;
VUHDO_DEBUFF_TYPE_DISEASE = 2;
VUHDO_DEBUFF_TYPE_MAGIC = 3;
VUHDO_DEBUFF_TYPE_CURSE = 4;
VUHDO_DEBUFF_TYPE_CUSTOM = 6;
VUHDO_DEBUFF_TYPE_MISSING_BUFF = 7;



--
VUHDO_INIT_DEBUFF_ABILITIES = {
	["WARRIOR"] = {
	},
	["ROGUE"] = {
	},
	["HUNTER"] = {
	},
	["MAGE"] = {
		[VUHDO_DEBUFF_TYPE_CURSE] = VUHDO_SPELL_ID.REMOVE_CURSE,
	},
	["DRUID"] = {
		[VUHDO_DEBUFF_TYPE_POISON] = VUHDO_SPELL_ID.REMOVE_CORRUPTION,
		[VUHDO_DEBUFF_TYPE_CURSE] = VUHDO_SPELL_ID.REMOVE_CORRUPTION,
		[VUHDO_DEBUFF_TYPE_MAGIC] = VUHDO_SPELL_ID.REMOVE_CORRUPTION,
	},
	["PALADIN"] = {
		[VUHDO_DEBUFF_TYPE_POISON] = VUHDO_SPELL_ID.PALA_CLEANSE,
		[VUHDO_DEBUFF_TYPE_DISEASE] = VUHDO_SPELL_ID.PALA_CLEANSE,
		[VUHDO_DEBUFF_TYPE_MAGIC] = VUHDO_SPELL_ID.PALA_CLEANSE,
	},
	["PRIEST"] = {
		[VUHDO_DEBUFF_TYPE_DISEASE] = VUHDO_SPELL_ID.CURE_DISEASE,
		[VUHDO_DEBUFF_TYPE_MAGIC] = VUHDO_SPELL_ID.DISPEL_MAGIC,
		[VUHDO_DEBUFF_TYPE_POISON] = "I",
	},
	["SHAMAN"] = {
		[VUHDO_DEBUFF_TYPE_CURSE] = VUHDO_SPELL_ID.CLEANSE_SPIRIT,
		[VUHDO_DEBUFF_TYPE_MAGIC] = VUHDO_SPELL_ID.CLEANSE_SPIRIT,
	},
	["WARLOCK"] = {
		[VUHDO_DEBUFF_TYPE_MAGIC] = "*",
	},
	["DEATHKNIGHT"] = {
	},
};



VUHDO_INIT_IGNORE_DEBUFFS_BY_CLASS = {
	["WARRIOR"] = {
		[VUHDO_SPELL_ID.DEBUFF_ANCIENT_HYSTERIA] = true,
		[VUHDO_SPELL_ID.DEBUFF_IGNITE_MANA] = true,
		[VUHDO_SPELL_ID.DEBUFF_TAINTED_MIND] = true,
		[VUHDO_SPELL_ID.DEBUFF_VIPER_STING] = true,
		[VUHDO_SPELL_ID.DEBUFF_IMPOTENCE] = true,
		[VUHDO_SPELL_ID.DEBUFF_DECAYED_INT] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
	["ROGUE"] = {
		[VUHDO_SPELL_ID.DEBUFF_SILENCE] = true,
		[VUHDO_SPELL_ID.DEBUFF_ANCIENT_HYSTERIA] = true,
		[VUHDO_SPELL_ID.DEBUFF_IGNITE_MANA] = true,
		[VUHDO_SPELL_ID.DEBUFF_TAINTED_MIND] = true,
		[VUHDO_SPELL_ID.DEBUFF_VIPER_STING] = true,
		[VUHDO_SPELL_ID.DEBUFF_IMPOTENCE] = true,
		[VUHDO_SPELL_ID.DEBUFF_DECAYED_INT] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
		[VUHDO_SPELL_ID.DEBUFF_SONIC_BURST] = true,
	},
	["HUNTER"] = {
		[VUHDO_SPELL_ID.DEBUFF_MAGMA_SHACKLES] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
		[VUHDO_SPELL_ID.DEBUFF_SONIC_BURST] = true,
	},
	["MAGE"] = {
		[VUHDO_SPELL_ID.DEBUFF_MAGMA_SHACKLES] = true,
		[VUHDO_SPELL_ID.DEBUFF_DECAYED_STR] = true,
		[VUHDO_SPELL_ID.DEBUFF_CRIPPLE] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
		[(GetSpellInfo(87923))] = true, -- Windschlag
	},
	["DRUID"] = {
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
	["PALADIN"] = {
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
	["PRIEST"] = {
		[VUHDO_SPELL_ID.DEBUFF_DECAYED_STR] = true,
		[VUHDO_SPELL_ID.DEBUFF_CRIPPLE] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
		[(GetSpellInfo(87923))] = true, -- Windschlag
	},
	["SHAMAN"] = {
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
	["WARLOCK"] = {
		[VUHDO_SPELL_ID.DEBUFF_DECAYED_STR] = true,
		[VUHDO_SPELL_ID.DEBUFF_CRIPPLE] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
		[(GetSpellInfo(87923))] = true, -- Windschlag
	},
	["DEATHKNIGHT"] = {
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
};



--
VUHDO_INIT_IGNORE_DEBUFFS_MOVEMENT = {
	[VUHDO_SPELL_ID.DEBUFF_FROSTBOLT] = true,
	[VUHDO_SPELL_ID.DEBUFF_MAGMA_SHACKLES] = true,
	[VUHDO_SPELL_ID.DEBUFF_SLOW] = true,
	[VUHDO_SPELL_ID.DEBUFF_CHILLED] = true,
	[VUHDO_SPELL_ID.DEBUFF_CONEOFCOLD] = true,
	[VUHDO_SPELL_ID.DEBUFF_CONCUSSIVESHOT] = true,
	[VUHDO_SPELL_ID.DEBUFF_THUNDERCLAP] = true,
	[VUHDO_SPELL_ID.DEBUFF_DAZED] = true,
	[VUHDO_SPELL_ID.DEBUFF_FROST_SHOCK] = true,
	[VUHDO_SPELL_ID.FROSTBOLT_VOLLEY] = true,
	[(GetSpellInfo(92642))] = true, -- Frostblitzsalve
	[(GetSpellInfo(88184))] = true, -- Lethargisches Gift
	[(GetSpellInfo(87759))] = true, -- Schockwelle
	[(GetSpellInfo(88075))] = true, -- Taifun
	[(GetSpellInfo(90938))] = true, -- Blutgeschoss
	[(GetSpellInfo(92007))] = true, -- Dampf
	[(GetSpellInfo(88169))] = true, -- Frostblüte
	[(GetSpellInfo(87861))] = true, -- Frostfäuste
	[(GetSpellInfo(83776))] = true, -- Drachenodem
	[(GetSpellInfo(7964))] = true, -- Rauchbombe
	[(GetSpellInfo(89989))] = true, -- Paralysierender Blasrohrpfeil
	[(GetSpellInfo(83785))] = true, -- Schockwelle
	[(GetSpellInfo(81630))] = true, -- Zähflüssiges Gift
	[(GetSpellInfo(82764))] = true, -- Zurechtstutzen
	[(GetSpellInfo(76825))] = true, -- Eisschlag
	[(GetSpellInfo(73963))] = true, -- Blendendes Gift
	[(GetSpellInfo(90006))] = true, -- Fluch der Erschöpfung
	[(GetSpellInfo(76508))] = true, -- Frostblitz
	[(GetSpellInfo(76682))] = true, -- Frostbombe
	[(GetSpellInfo(12611))] = true, -- Kältekegel
	[(GetSpellInfo(76094))] = true, -- Fluch der Ermüdung
	[(GetSpellInfo(76604))] = true, -- Leerenreißen
};



--
VUHDO_INIT_IGNORE_DEBUFFS_DURATION = {
	[VUHDO_SPELL_ID.DEBUFF_PSYCHIC_HORROR] = true,
	[VUHDO_SPELL_ID.DEBUFF_CHILLED] = true,
	[VUHDO_SPELL_ID.DEBUFF_CONEOFCOLD] = true,
	[VUHDO_SPELL_ID.DEBUFF_CONCUSSIVESHOT] = true,
	[VUHDO_SPELL_ID.DEBUFF_FALTER] = true,
	[(GetSpellInfo(92642))] = true, -- Frostblitzsalve
	[(GetSpellInfo(87759))] = true, -- Schockwelle
	[(GetSpellInfo(90938))] = true, -- Blutgeschoss
	[(GetSpellInfo(92007))] = true, -- Dampf
	[(GetSpellInfo(83776))] = true, -- Drachenodem
	[(GetSpellInfo(7964))] = true, -- Rauchbombe
	[(GetSpellInfo(83785))] = true, -- Schockwelle
	[(GetSpellInfo(81630))] = true, -- Zähflüssiges Gift
	[(GetSpellInfo(82670))] = true, -- Schädelkracher
	[(GetSpellInfo(73963))] = true, -- Blendendes Gift
	[(GetSpellInfo(76508))] = true, -- Frostblitz
	[(GetSpellInfo(76185))] = true, -- Steinschlag
};



VUHDO_INIT_IGNORE_DEBUFFS_NO_HARM = {
	[VUHDO_SPELL_ID.DEBUFF_HUNTERS_MARK] = true,
	[VUHDO_SPELL_ID.DEBUFF_ARCANE_BLAST] = true,
	[VUHDO_SPELL_ID.DEBUFF_MAJOR_DREAMLESS] = true,
	[VUHDO_SPELL_ID.DEBUFF_GREATER_DREAMLESS] = true,
	[VUHDO_SPELL_ID.DEBUFF_DREAMLESS_SLEEP] = true,
	[VUHDO_SPELL_ID.MISDIRECTION] = true,
	[VUHDO_SPELL_ID.DEBUFF_DELUSIONS_OF_JINDO] = true,
	[VUHDO_SPELL_ID.DEBUFF_MIND_VISION] = true,
	[VUHDO_SPELL_ID.DEBUFF_MUTATING_INJECTION] = true,
	[VUHDO_SPELL_ID.DEBUFF_BANISH] = true,
	[VUHDO_SPELL_ID.DEBUFF_PHASE_SHIFT] = true
};

