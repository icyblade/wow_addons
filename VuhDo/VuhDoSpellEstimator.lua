VUHDO_ACTIVE_HOTS = { };
VUHDO_ACTIVE_HOTS_OTHERS = { };
VUHDO_PLAYER_HOTS = { };

VUHDO_SPELL_TYPE_HOT = 1;  -- Spell type heal over time


VUHDO_GCD_SPELLS = {
	["WARRIOR"] = GetSpellInfo(78), -- Heroic Strike
	["ROGUE"] = GetSpellInfo(1752), -- Sinister Strike
	["HUNTER"] = GetSpellInfo(1494), -- Track beasts
	["PALADIN"] = VUHDO_SPELL_ID.HOLY_LIGHT, -- Holy Light
	["MAGE"] = GetSpellInfo(133), -- Fire Ball
	["WARLOCK"] = GetSpellInfo(686), -- Shadow Bolt
	["SHAMAN"] = VUHDO_SPELL_ID.HEALING_WAVE, --  Healing Wave
	["DRUID"] = VUHDO_SPELL_ID.REGROWTH, -- Regrowth
	["PRIEST"] = VUHDO_SPELL_ID.HEAL, -- Heal
	["DEATHKNIGHT"] = GetSpellInfo(48266), -- Blood Presence
}



local twipe = table.wipe;
local GetSpellBookItemName = GetSpellBookItemName;
local GetSpellInfo = GetSpellInfo;
local pairs = pairs;
local strlen = strlen;
local BOOKTYPE_SPELL = BOOKTYPE_SPELL;



-- All healing spells and their ranks we will take notice of
VUHDO_SPELLS = {
	-- Paladin
	[VUHDO_SPELL_ID.BUFF_BEACON_OF_LIGHT] = {
		["isHot"] = true,
	},

	-- Priest
	[VUHDO_SPELL_ID.BUFF_FEAR_WARD] = {
		["nostance"] = true,
	},
	[VUHDO_SPELL_ID.BUFF_LEVITATE] = {
		["nostance"] = true,
	},
	[VUHDO_SPELL_ID.BUFF_SHADOW_PROTECTION] = {
		["nostance"] = true,
	},
	[VUHDO_SPELL_ID.BUFF_POWER_WORD_FORTITUDE] = {
		["nostance"] = true,
	},


	[VUHDO_SPELL_ID.RENEW] = {
		["isHot"] = true,
	},
	[VUHDO_SPELL_ID.POWERWORD_SHIELD] = {
		["isHot"] = true,
		["nostance"] = true,
	},
	[VUHDO_SPELL_ID.PRAYER_OF_MENDING] = {
		["isHot"] = true,
	},
	[VUHDO_SPELL_ID.DIVINE_AEGIS] = {
		["isHot"] = true,
		["nodefault"] = true,
	},
	[VUHDO_SPELL_ID.PAIN_SUPPRESSION] = {
		["isHot"] = true,
		["nodefault"] = true,
		["nostance"] = true,
	},
	[VUHDO_SPELL_ID.GRACE] = {
		["isHot"] = true,
		["nodefault"] = true,
	},
	[VUHDO_SPELL_ID.GUARDIAN_SPIRIT] = {
		["isHot"] = true,
		["nohelp"] = true,
		["noselftarget"] = true,
	},
	[VUHDO_SPELL_ID.RENEWED_HOPE] = {
		["isHot"] = true,
		["nodefault"] = true,
	},
	[VUHDO_SPELL_ID.INSPIRATION] = {
		["isHot"] = true,
		["nodefault"] = true,
	},
	[VUHDO_SPELL_ID.BLESSED_HEALING] = {
		["isHot"] = true,
		["nodefault"] = true,
	},
	[VUHDO_SPELL_ID.HOLY_WORD_CHASTISE] = {
		["nohelp"] = true,
	},
	[VUHDO_SPELL_ID.HOLY_WORD_SANCTUARY] = {
		["nohelp"] = true,
	},
	[VUHDO_SPELL_ID.HOLY_WORD_SERENITY] = {
		["nohelp"] = true,
	},
	[VUHDO_SPELL_ID.ECHO_OF_LIGHT] = {
		["isHot"] = true,
	},
	[VUHDO_SPELL_ID.SERENDIPITY] = {
		["isHot"] = true,
		["nodefault"] = true,
	},

	-- Shaman
	[VUHDO_SPELL_ID.RIPTIDE] = {
		["isHot"] = true,
	},
	[VUHDO_SPELL_ID.BUFF_EARTHLIVING_WEAPON] = {
		["isHot"] = true,
	},
	[VUHDO_SPELL_ID.GIFT_OF_THE_NAARU] = {
		["isHot"] = true,
	},
	[VUHDO_SPELL_ID.BUFF_EARTH_SHIELD] = {
		["isHot"] = true,
		["target"] = VUHDO_BUFF_TARGET_UNIQUE,
	},
	[VUHDO_SPELL_ID.ANCESTRAL_HEALING] = {
		["isHot"] = true,
		["buff"] = VUHDO_SPELL_ID.ANCESTRAL_FORTITUDE,
	},
	[VUHDO_SPELL_ID.BUFF_WATER_SHIELD] = {
		["isHot"] = true,
	},
	[VUHDO_SPELL_ID.TIDAL_WAVES] = {
		["isHot"] = true,
		["nodefault"] = true,
	},

	-- Druid

	-- Dornen, Pflege, Rasche Heilung, Heilende Berührung, Anregen, Wiedergeburt, Wiederbelebung
	[VUHDO_SPELL_ID.REJUVENATION] = {
		["isHot"] = true,
	},
	[VUHDO_SPELL_ID.REGROWTH] = {
		["isHot"] = true,
	},
	[VUHDO_SPELL_ID.LIFEBLOOM] = {
		["isHot"] = true,
	},
	[VUHDO_SPELL_ID.WILD_GROWTH] = {
		["isHot"] = true,
	},

	-- Hunter
	[VUHDO_SPELL_ID.MEND_PET] = {
		["isHot"] = true,
	},
};
local VUHDO_SPELLS = VUHDO_SPELLS;



-- Spells from talents only, not in spellbook
local function VUHDO_addTalentHots(someHots)
	if (VUHDO_PLAYER_CLASS == "SHAMAN") then
		someHots[VUHDO_SPELL_ID.ANCESTRAL_HEALING] = true;
	elseif (VUHDO_PLAYER_CLASS == "PRIEST") then
		someHots[VUHDO_SPELL_ID.GRACE] = true;
		someHots[VUHDO_SPELL_ID.DIVINE_AEGIS] = true;
		someHots[VUHDO_SPELL_ID.RENEWED_HOPE] = true;
		someHots[VUHDO_SPELL_ID.INSPIRATION] = true;
		someHots[VUHDO_SPELL_ID.BLESSED_HEALING] = true;
		someHots[VUHDO_SPELL_ID.ECHO_OF_LIGHT] = true;
		someHots[VUHDO_SPELL_ID.SERENDIPITY] = true;
	end
end



-- initializes some dynamic information into VUHDO_SPELLS
function VUHDO_initFromSpellbook()
	local tIndex = 1;
	local tSpellName;
	local tPresentHots = { };
	local tEmpty = {};

	while (true) do
		tSpellName = GetSpellBookItemName(tIndex, BOOKTYPE_SPELL);
		if (tSpellName == nil) then
			break;
		end

		if ((VUHDO_SPELLS[tSpellName] or tEmpty)["isHot"]) then
			tPresentHots[tSpellName] = true;
		end

		tIndex = tIndex + 1;
	end

	VUHDO_addTalentHots(tPresentHots);

	twipe(VUHDO_PLAYER_HOTS);
	for tSpellName, _ in pairs(tPresentHots) do
		if (VUHDO_SPELLS[tSpellName]["buff"] ~= nil) then
			tinsert(VUHDO_PLAYER_HOTS, VUHDO_SPELLS[tSpellName]["buff"]);
		else
			tinsert(VUHDO_PLAYER_HOTS, tSpellName);
		end
	end

	local tSlotsUsed = 0;
	twipe(VUHDO_ACTIVE_HOTS);
	twipe(VUHDO_ACTIVE_HOTS_OTHERS);

	local tHotSlots = VUHDO_PANEL_SETUP["HOTS"]["SLOTS"];
	local tCnt;

	if (tIndex > 1) then -- False if no spell infos yet loaded on early load

		if (tHotSlots["firstFlood"]) then
			for tCnt = 1, #VUHDO_PLAYER_HOTS do
				if (not (VUHDO_SPELLS[VUHDO_PLAYER_HOTS[tCnt]] or tEmpty)["nodefault"]) then
					tinsert(tHotSlots, VUHDO_PLAYER_HOTS[tCnt]);
					tSlotsUsed = tSlotsUsed + 1;
					if (tSlotsUsed == 10) then
						break;
					end
				end
			end
			tHotSlots[10] = "BOUQUET_" .. VUHDO_I18N_DEF_AOE_ADVICE;
			tHotSlots["firstFlood"] = nil;
		end

		local tHotCfg = VUHDO_PANEL_SETUP["HOTS"]["SLOTCFG"];
		for tCnt = 1, 10 do
			if (tHotCfg["firstFlood"] and tHotSlots[tCnt] ~= nil and tHotCfg["" .. tCnt] == nil) then
				tHotCfg["" .. tCnt]["others"] = VUHDO_EXCLUSIVE_HOTS[tHotSlots[tCnt]] ~= nil;
			end
			if (tHotCfg["" .. tCnt]["scale"] == nil) then
				tHotCfg["" .. tCnt]["scale"] = 1;
			end
		end
		tHotCfg["firstFlood"] = nil;

		local tHotName;
		for tCnt, tHotName in pairs(tHotSlots) do
			if (tHotName ~= nil and strlen(tHotName) > 0) then
				VUHDO_ACTIVE_HOTS[tHotName] = true;

				if (tHotCfg["" .. tCnt]["others"]) then
					VUHDO_ACTIVE_HOTS_OTHERS[tHotName] = true;
				end
			end
		end
		VUHDO_setKnowsSwiftmend(VUHDO_isSpellKnown(VUHDO_SPELL_ID.SWIFTMEND));
	end
end
