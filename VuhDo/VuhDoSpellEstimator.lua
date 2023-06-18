VUHDO_ACTIVE_HOTS = { };
VUHDO_ACTIVE_HOTS_OTHERS = { };
VUHDO_PLAYER_HOTS = { };

VUHDO_SPELL_TYPE_HOT = 1;  -- Spell type heal over time


VUHDO_GCD_SPELLS = {
	["WARRIOR"] = GetSpellInfo(78), -- Heroic Strike
	["ROGUE"] = GetSpellInfo(1752), -- Sinister Strike
	["HUNTER"] = GetSpellInfo(1494), -- Track beasts
	["PALADIN"] = VUHDO_SPELL_ID.FLASH_OF_LIGHT,
	["MAGE"] = GetSpellInfo(133), -- Fire Ball
	["WARLOCK"] = GetSpellInfo(686), -- Shadow Bolt
	["SHAMAN"] = GetSpellInfo(8004), --  Healing Surge
	["DRUID"] = VUHDO_SPELL_ID.REJUVENATION, -- Regrowth
	["PRIEST"] = VUHDO_SPELL_ID.RENEW, -- mopok
	["DEATHKNIGHT"] = GetSpellInfo(48266), -- Blood Presence
	["MONK"] = GetSpellInfo(100780) -- Jab
};



local twipe = table.wipe;
local pairs = pairs;



--
VUHDO_SPELLS = {
	-- Paladin
	[VUHDO_SPELL_ID.BUFF_BEACON_OF_LIGHT] = { ["isHot"] = true, },
	[VUHDO_SPELL_ID.SACRED_SHIELD] = { ["isHot"] = true, },
	[VUHDO_SPELL_ID.ETERNAL_FLAME] = { ["isHot"] = true, },
	[VUHDO_SPELL_ID.ILLUMINATED_HEALING] = { ["isHot"] = true, },

	-- Priest
	[VUHDO_SPELL_ID.SPIRIT_SHELL] = { ["isHot"] = true },
	[VUHDO_SPELL_ID.RENEW] = { ["isHot"] = true },
	[VUHDO_SPELL_ID.POWERWORD_SHIELD] = { ["isHot"] = true },
	[VUHDO_SPELL_ID.PRAYER_OF_MENDING] = { ["isHot"] = true },
	[VUHDO_SPELL_ID.DIVINE_AEGIS] = { ["isHot"] = true, ["nodefault"] = true },
	[VUHDO_SPELL_ID.PAIN_SUPPRESSION] = { ["isHot"] = true, ["nodefault"] = true },
	[VUHDO_SPELL_ID.GRACE] = { ["isHot"] = true, ["nodefault"] = true },
	[VUHDO_SPELL_ID.GUARDIAN_SPIRIT] = { ["isHot"] = true, ["nohelp"] = true, ["noselftarget"] = true	},
	[VUHDO_SPELL_ID.ECHO_OF_LIGHT] = { ["isHot"] = true },
	[VUHDO_SPELL_ID.SERENDIPITY] = { ["isHot"] = true, ["nodefault"] = true	},

	-- Shaman
	[VUHDO_SPELL_ID.RIPTIDE] = { ["isHot"] = true	},
	[VUHDO_SPELL_ID.BUFF_EARTHLIVING_WEAPON] = { ["isHot"] = true },
	[VUHDO_SPELL_ID.GIFT_OF_THE_NAARU] = { ["isHot"] = true },
	[VUHDO_SPELL_ID.BUFF_EARTH_SHIELD] = { ["isHot"] = true },
	[VUHDO_SPELL_ID.BUFF_WATER_SHIELD] = { ["isHot"] = true },
	[VUHDO_SPELL_ID.TIDAL_WAVES] = { ["isHot"] = true, ["nodefault"] = true },

	-- Druid
	[VUHDO_SPELL_ID.REJUVENATION] = { ["isHot"] = true },
	[VUHDO_SPELL_ID.REGROWTH] = { ["isHot"] = true },
	[VUHDO_SPELL_ID.LIFEBLOOM] = { ["isHot"] = true },
	[VUHDO_SPELL_ID.WILD_GROWTH] = { ["isHot"] = true },
	[VUHDO_SPELL_ID.CENARION_WARD] = { ["isHot"] = true },

	-- Hunter
	[VUHDO_SPELL_ID.MEND_PET] = { ["isHot"] = true },

	-- Monk
	[VUHDO_SPELL_ID.SOOTHING_MIST] = { ["isHot"] = true },
	[VUHDO_SPELL_ID.ENVELOPING_MIST] = {["isHot"] = true },
	[VUHDO_SPELL_ID.RENEWING_MIST] = { ["isHot"] = true },
	[VUHDO_SPELL_ID.ZEN_SPHERE] = { ["isHot"] = true },
	[VUHDO_SPELL_ID.SERPENTS_ZEAL] = { ["isHot"] = true },

	-- Mage
	[VUHDO_SPELL_ID.ICE_BARRIER] = { ["isHot"] = true },
};
local VUHDO_SPELLS = VUHDO_SPELLS;



-- initializes some dynamic information into VUHDO_SPELLS
function VUHDO_initFromSpellbook()

	twipe(VUHDO_PLAYER_HOTS);

	for tSpellName, someParams in pairs(VUHDO_SPELLS) do
		if someParams["isHot"] and VUHDO_isSpellKnown(tSpellName) then
			VUHDO_PLAYER_HOTS[#VUHDO_PLAYER_HOTS + 1] = tSpellName;
		end
	end

	if "PRIEST" == VUHDO_PLAYER_CLASS then
		VUHDO_PLAYER_HOTS[#VUHDO_PLAYER_HOTS + 1] = VUHDO_SPELL_ID.ECHO_OF_LIGHT;
	end

	twipe(VUHDO_ACTIVE_HOTS);
	twipe(VUHDO_ACTIVE_HOTS_OTHERS);

	local tHotSlots = VUHDO_PANEL_SETUP["HOTS"]["SLOTS"];

	if tHotSlots["firstFlood"] then
		tHotSlots["firstFlood"] = nil;

		for tCnt = 1, #VUHDO_PLAYER_HOTS do
			if not (VUHDO_SPELLS[VUHDO_PLAYER_HOTS[tCnt]] or { })["nodefault"] then
				tinsert(tHotSlots, VUHDO_PLAYER_HOTS[tCnt]);
				if #tHotSlots == 10 then break; end
			end
		end
		tHotSlots[10] = "BOUQUET_" .. VUHDO_I18N_DEF_AOE_ADVICE;
	end

	local tHotCfg = VUHDO_PANEL_SETUP["HOTS"]["SLOTCFG"];
	if tHotCfg["firstFlood"] then
		for tCnt = 1, #tHotSlots do
			tHotCfg["" .. tCnt]["others"] = VUHDO_EXCLUSIVE_HOTS[tHotSlots[tCnt]];
		end
		tHotCfg["firstFlood"] = nil;
	end

	for tCnt, tHotName in pairs(tHotSlots) do
		if not VUHDO_strempty(tHotName) then
			VUHDO_ACTIVE_HOTS[tHotName] = true;
			if tHotCfg["" .. tCnt]["others"] then VUHDO_ACTIVE_HOTS_OTHERS[tHotName] = true; end
		end
	end
	VUHDO_setKnowsSwiftmend(VUHDO_isSpellKnown(VUHDO_SPELL_ID.SWIFTMEND));
end
