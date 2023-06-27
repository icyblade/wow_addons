local pairs = pairs;

VUHDO_GLOBAL_CONFIG = {
	["PROFILES_VERSION"] = 1;
};


--
local tHotCfg, tHotSlots, tCnt2;
function VUHDO_fixHotSettings()
	tHotSlots = VUHDO_PANEL_SETUP["HOTS"]["SLOTS"];
	tHotCfg = VUHDO_PANEL_SETUP["HOTS"]["SLOTCFG"];

	for tCnt2 = 1, 10 do
		if (not tHotCfg["" .. tCnt2]["mine"] and not tHotCfg["" .. tCnt2]["others"]) then
			if (tHotSlots[tCnt2] ~= nil) then
				tHotCfg["" .. tCnt2]["mine"] = true;
				tHotCfg["" .. tCnt2]["others"] = VUHDO_EXCLUSIVE_HOTS[tHotSlots[tCnt2]] ~= nil;
			end
		end
	end
end



--
local function VUHDO_getVarDescription(aVar)
	local tMessage = "";
	if (aVar == nil) then
		tMessage = "<nil>";
	elseif ("boolean" == type(aVar)) then
		if (aVar) then
			tMessage = "<true>";
		else
			tMessage = "<false>";
		end
	elseif("number" == type(aVar) or "string" == type(aVar)) then
		tMessage = aVar .. " (" .. type(aVar) .. ")";
	else
		tMessage = "(" .. type(aVar) .. ")";
	end

	return tMessage;
end



--
local tCreated, tRepaired;
local function _VUHDO_ensureSanity(aName, aValue, aSaneValue)
	if (aSaneValue ~= nil) then
		if (type(aSaneValue) == "table") then
			if (aValue ~= nil and type(aValue) == "table") then
				local tIndex;
				for tIndex, _ in pairs(aSaneValue) do
					aValue[tIndex] = _VUHDO_ensureSanity(aName, aValue[tIndex], aSaneValue[tIndex]);
				end
			else

				if (aValue ~= nil) then
					tRepaired = tRepaired + 1;
				else
					tCreated = tCreated + 1;
				end

				return VUHDO_deepCopyTable(aSaneValue);
			end
		else
			if (aValue == nil or type(aValue) ~= type(aSaneValue)) then
				if ((type(aSaneValue) ~= "boolean" or (aValue ~= 1 and aValue ~= 0 and aValue ~= nil))
				and (type(aSaneValue) ~= "number" or (aSaneValue ~= 1 and aSaneValue ~= 0))) then

					if (aValue ~= nil) then
						tRepaired = tRepaired + 1;
					else
						tCreated = tCreated + 1;
						--VUHDO_xMsg("+Flat:", aValue, aSaneValue);
					end

					return aSaneValue;
				end
			end

			if (aValue ~= nil and "string" == type(aValue)) then
				aValue = strtrim(aValue);
			end

		end
	end

	return aValue
end



--
local tRepairedArray;
function VUHDO_ensureSanity(aName, aValue, aSaneValue)
	tCreated = 0;
	tRepaired = 0;
	local tSaneValue = VUHDO_decompressIfCompressed(aSaneValue);
	tRepairedArray = _VUHDO_ensureSanity(aName, aValue, tSaneValue);

	if (tCreated + tRepaired > 0) then
		VUHDO_Msg("auto model sanity: " .. aName .. ": created " .. tCreated .. ", repaired " .. tRepaired .. " values.");
	end

	return tRepairedArray;
end



local VUHDO_DEFAULT_MODELS = {
	{ VUHDO_ID_GROUP_1, VUHDO_ID_GROUP_2, VUHDO_ID_GROUP_3, VUHDO_ID_GROUP_4, VUHDO_ID_GROUP_5, VUHDO_ID_GROUP_6, VUHDO_ID_GROUP_7, VUHDO_ID_GROUP_8 },
	{ VUHDO_ID_MAINTANKS },
	{ VUHDO_ID_PETS },
	{ VUHDO_ID_PRIVATE_TANKS },
};



local VUHDO_DEFAULT_RANGE_SPELLS = {
--	["WARRIOR"] = nil,
--	["ROGUE"] = nil,
--	["HUNTER"] = nil,
	["PALADIN"] = VUHDO_SPELL_ID.HOLY_LIGHT,
--	["MAGE"] = nil,
--	["WARLOCK"] = nil,
	["SHAMAN"] = VUHDO_SPELL_ID.HEALING_WAVE,
	["DRUID"] = VUHDO_SPELL_ID.REJUVENATION,
	["PRIEST"] = VUHDO_SPELL_ID.HEAL,
--	["DEATHKNIGHT"] = nil,
}



local VUHDO_DEFAULT_SPELL_ASSIGNMENT = nil;
local VUHDO_DEFAULT_HOSTILE_SPELL_ASSIGNMENT = nil;
local VUHDO_DEFAULT_SPELLS_KEYBOARD = nil;



local VUHDO_CLASS_DEFAULT_SPELL_ASSIGNMENT = {
	["PALADIN"] = {
		["1"] = {"", "1", VUHDO_SPELL_ID.FLASH_OF_LIGHT},
		["2"] = {"", "2", VUHDO_SPELL_ID.PALA_CLEANSE},
		["3"] = {"", "3", "menu"},
		["4"] = {"", "4", VUHDO_SPELL_ID.DIVINE_FAVOR},
		["5"] = {"", "5", VUHDO_SPELL_ID.DIVINE_ILLUMINATION},

		["alt1"] = {"alt-", "1", "target"},

		["ctrl1"] = {"ctrl-", "1", VUHDO_SPELL_ID.HOLY_LIGHT},
		["ctrl2"] = {"ctrl-", "2", VUHDO_SPELL_ID.HOLY_LIGHT},

		["shift1"] = {"shift-", "1", VUHDO_SPELL_ID.HOLY_SHOCK},
		["shift2"] = {"shift-", "2", VUHDO_SPELL_ID.LAY_ON_HANDS},
	},

	["SHAMAN"] = {
		["1"] = {"", "1", VUHDO_SPELL_ID.HEALING_WAVE},
		["2"] = {"", "2", VUHDO_SPELL_ID.CHAIN_HEAL},
		["3"] = {"", "3", "menu"},

		["alt1"] = {"alt-", "1", VUHDO_SPELL_ID.BUFF_EARTH_SHIELD},
		["alt2"] = {"alt-", "2", VUHDO_SPELL_ID.GIFT_OF_THE_NAARU},
		["alt3"] = {"alt-", "3", "menu"},

		["ctrl1"] = {"ctrl-", "1", "target"},
		["ctrl2"] = {"ctrl-", "2", "target"},
		["ctrl3"] = {"ctrl-", "3", "menu"},

		["shift1"] = {"shift-", "1", VUHDO_SPELL_ID.HEALING_WAVE},
		["shift2"] = {"shift-", "2", VUHDO_SPELL_ID.CHAIN_HEAL},
		["shift3"] = {"shift-", "3", "menu" },

		["altctrl1"] = {"alt-ctrl-", "1", VUHDO_SPELL_ID.PURGE},
		["altctrl2"] = {"alt-ctrl-", "2", VUHDO_SPELL_ID.PURGE},
	},

	["PRIEST"] = {
		["1"] = {"", "1", VUHDO_SPELL_ID.FLASH_HEAL},
		["2"] = {"", "2", VUHDO_SPELL_ID.GREATER_HEAL},
		["3"] = {"", "3", VUHDO_SPELL_ID.DESPERATE_PRAYER},
		["4"] = {"", "4", VUHDO_SPELL_ID.RENEW},
		["5"] = {"", "5", VUHDO_SPELL_ID.BINDING_HEAL},

		["alt1"] = {"alt-", "1", "target"},
		["alt2"] = {"alt-", "2", "focus"},
		["alt3"] = {"alt-", "3", VUHDO_SPELL_ID.POWERWORD_SHIELD},
		["alt4"] = {"alt-", "4", VUHDO_SPELL_ID.POWERWORD_SHIELD},
		["alt5"] = {"alt-", "5", VUHDO_SPELL_ID.POWERWORD_SHIELD},

		["ctrl1"] = {"ctrl-", "1", VUHDO_SPELL_ID.PRAYER_OF_HEALING},
		["ctrl2"] = {"ctrl-", "2", VUHDO_SPELL_ID.CIRCLE_OF_HEALING},
		["ctrl3"] = {"ctrl-", "3", "menu"},
		["ctrl4"] = {"ctrl-", "4", VUHDO_SPELL_ID.PRAYER_OF_MENDING},
		["ctrl5"] = {"ctrl-", "5", VUHDO_SPELL_ID.PRAYER_OF_MENDING},

		["shift2"] = {"shift-", "2", VUHDO_SPELL_ID.DISPEL_MAGIC},
		["shift3"] = {"shift-", "3", "menu"},
	},

	["DRUID"] = {
		["1"] = {"", "1", VUHDO_SPELL_ID.HEALING_TOUCH},
		["2"] = {"", "2", VUHDO_SPELL_ID.REJUVENATION},
		["3"] = {"", "3", "menu"},
		["4"] = {"", "4", VUHDO_SPELL_ID.INNERVATE},
		["5"] = {"", "5", VUHDO_SPELL_ID.INNERVATE},

		["alt1"] = {"alt-", "1", "target"},
		["alt2"] = {"alt-", "2", "focus"},
		["alt3"] = {"alt-", "3", "menu"},

		["ctrl1"] = {"ctrl-", "1", VUHDO_SPELL_ID.REGROWTH},
		["ctrl2"] = {"ctrl-", "2", VUHDO_SPELL_ID.LIFEBLOOM},
		["ctrl4"] = {"ctrl-", "4", VUHDO_SPELL_ID.TRANQUILITY},
		["ctrl5"] = {"ctrl-", "5", VUHDO_SPELL_ID.TRANQUILITY},

		["shift2"] = {"shift-", "2", VUHDO_SPELL_ID.REMOVE_CURSE},
	}
};



--
local VUHDO_GLOBAL_DEFAULT_SPELL_ASSIGNMENT = {
	["1"] = {"", "1", "target"},
	["2"] = {"", "2", "assist"},
	["3"] = {"", "3", "focus"},
	["4"] = {"", "4", "menu"},
	["5"] = {"", "5", "menu"},
};



--
VUHDO_DEFAULT_SPELL_CONFIG = {
	["IS_AUTO_FIRE"] = true,
	["IS_FIRE_HOT"] = false,
	["IS_FIRE_OUT_FIGHT"] = false,
	["IS_KEEP_STANCE"] = false,
	["IS_AUTO_TARGET"] = false,
	["IS_CANCEL_CURRENT"] = false,
	["IS_FIRE_TRINKET_1"] = false,
	["IS_FIRE_TRINKET_2"] = false,
	["IS_FIRE_GLOVES"] = false,
	["IS_FIRE_CUSTOM_1"] = false,
	["FIRE_CUSTOM_1_SPELL"] = "",
	["IS_FIRE_CUSTOM_2"] = false,
	["FIRE_CUSTOM_2_SPELL"] = "",
	["IS_TOOLTIP_INFO"] = false,
	["IS_LOAD_HOTS"] = false,
	["smartCastModi"] = "all",
	["autoBattleRez"] = true,
}



--
local function VUHDO_initDefaultSpellAssignments()
	local tNoMinus, tWithMinus;
	local tCnt;
	local tKey, tValue;

	VUHDO_DEFAULT_SPELL_ASSIGNMENT = {};
	VUHDO_DEFAULT_HOSTILE_SPELL_ASSIGNMENT = {};
	for tNoMinus, tWithMinus in pairs(VUHDO_MODIFIER_KEYS_LOW) do
		for tCnt = 1, VUHDO_NUM_MOUSE_BUTTONS do
			tKey = tNoMinus .. tCnt;

			if (VUHDO_GLOBAL_DEFAULT_SPELL_ASSIGNMENT[tKey] ~= nil) then
				tValue = VUHDO_GLOBAL_DEFAULT_SPELL_ASSIGNMENT[tKey];
			else
				tValue = { tWithMinus, tostring(tCnt), "" };
			end
			VUHDO_DEFAULT_SPELL_ASSIGNMENT[tKey] = tValue;
			VUHDO_DEFAULT_HOSTILE_SPELL_ASSIGNMENT[tKey] = { tWithMinus, tostring(tCnt), "" };
		end
	end

	VUHDO_DEFAULT_SPELLS_KEYBOARD = { ["version"] = 2 };

	for tCnt = 1, VUHDO_NUM_KEYBOARD_KEYS do
		VUHDO_DEFAULT_SPELLS_KEYBOARD["SPELL" .. tCnt] = "";
	end

	VUHDO_DEFAULT_SPELLS_KEYBOARD["INTERNAL"] = {
	};

	VUHDO_DEFAULT_SPELLS_KEYBOARD["WHEEL"] = {

		["1"] = {"", "-w1", ""},
		["2"] = {"", "-w2", ""},

		["alt1"] = {"ALT-", "-w3", ""},
		["alt2"] = {"ALT-", "-w4", ""},

		["ctrl1"] = {"CTRL-", "-w5", ""},
		["ctrl2"] = {"CTRL-", "-w6", ""},

		["shift1"] = {"SHIFT-", "-w7", ""},
		["shift2"] = {"SHIFT-", "-w8", ""},

		["altctrl1"] = {"ALT-CTRL-", "-w9", ""},
		["altctrl2"] = {"ALT-CTRL-", "-w10", ""},

		["altshift1"] = {"ALT-SHIFT-", "-w11", ""},
		["altshift2"] = {"ALT-SHIFT-", "-w12", ""},

		["ctrlshift1"] = {"CTRL-SHIFT-", "-w13", ""},
		["ctrlshift2"] = {"CTRL-SHIFT-", "-w14", ""},

		["altctrlshift1"] = {"ALT-CTRL-SHIFT-", "-w15", ""},
		["altctrlshift2"] = {"ALT-CTRL-SHIFT-", "-w16", ""},
	};

	VUHDO_DEFAULT_SPELLS_KEYBOARD["HOSTILE_WHEEL"] = {
		["1"] = {"", "-w1", ""},
		["2"] = {"", "-w2", ""},

		["alt1"] = {"ALT-", "-w3", ""},
		["alt2"] = {"ALT-", "-w4", ""},

		["ctrl1"] = {"CTRL-", "-w5", ""},
		["ctrl2"] = {"CTRL-", "-w6", ""},

		["shift1"] = {"SHIFT-", "-w7", ""},
		["shift2"] = {"SHIFT-", "-w8", ""},

		["altctrl1"] = {"ALT-CTRL-", "-w9", ""},
		["altctrl2"] = {"ALT-CTRL-", "-w10", ""},

		["altshift1"] = {"ALT-SHIFT-", "-w11", ""},
		["altshift2"] = {"ALT-SHIFT-", "-w12", ""},

		["ctrlshift1"] = {"CTRL-SHIFT-", "-w13", ""},
		["ctrlshift2"] = {"CTRL-SHIFT-", "-w14", ""},

		["altctrlshift1"] = {"ALT-CTRL-SHIFT-", "-w15", ""},
		["altctrlshift2"] = {"ALT-CTRL-SHIFT-", "-w16", ""},
	};

end



--
local function VUHDO_assignDefaultSpells()
	local tClass;

	_, tClass = UnitClass("player");

	if ((VUHDO_CLASS_DEFAULT_SPELL_ASSIGNMENT or {})[tClass] ~= nil) then
		VUHDO_SPELL_ASSIGNMENTS = VUHDO_deepCopyTable(VUHDO_CLASS_DEFAULT_SPELL_ASSIGNMENT[tClass]);
		local tKey, tValue;

		for tKey, tValue in pairs(VUHDO_DEFAULT_SPELL_ASSIGNMENT) do
			if (VUHDO_SPELL_ASSIGNMENTS[tKey] == nil) then
				VUHDO_SPELL_ASSIGNMENTS[tKey] = tValue;
			end
		end
	else
		VUHDO_SPELL_ASSIGNMENTS = VUHDO_deepCopyTable(VUHDO_DEFAULT_SPELL_ASSIGNMENT);
	end

	VUHDO_CLASS_DEFAULT_SPELL_ASSIGNMENT = nil;
end



--
function VUHDO_loadSpellArray()
	VUHDO_initDefaultSpellAssignments();
	-- Maus freundlich
	if (VUHDO_SPELL_ASSIGNMENTS == nil) then
		VUHDO_assignDefaultSpells();
	end
	VUHDO_SPELL_ASSIGNMENTS = VUHDO_ensureSanity("VUHDO_SPELL_ASSIGNMENTS", VUHDO_SPELL_ASSIGNMENTS, VUHDO_DEFAULT_SPELL_ASSIGNMENT);

	-- Maus gegnerisch
	if (VUHDO_HOSTILE_SPELL_ASSIGNMENTS == nil) then
		VUHDO_HOSTILE_SPELL_ASSIGNMENTS = VUHDO_deepCopyTable(VUHDO_DEFAULT_HOSTILE_SPELL_ASSIGNMENT);
	end
	VUHDO_HOSTILE_SPELL_ASSIGNMENTS = VUHDO_ensureSanity("VUHDO_HOSTILE_SPELL_ASSIGNMENTS", VUHDO_HOSTILE_SPELL_ASSIGNMENTS, VUHDO_DEFAULT_HOSTILE_SPELL_ASSIGNMENT);
	-- Tastatur
	if (VUHDO_SPELLS_KEYBOARD == nil) then
		VUHDO_SPELLS_KEYBOARD = VUHDO_deepCopyTable(VUHDO_DEFAULT_SPELLS_KEYBOARD);
	end
	VUHDO_SPELLS_KEYBOARD = VUHDO_ensureSanity("VUHDO_SPELLS_KEYBOARD", VUHDO_SPELLS_KEYBOARD, VUHDO_DEFAULT_SPELLS_KEYBOARD);
	-- Konfiguration
	if (VUHDO_SPELL_CONFIG == nil) then
		VUHDO_SPELL_CONFIG = VUHDO_deepCopyTable(VUHDO_DEFAULT_SPELL_CONFIG);
	end
	VUHDO_SPELL_CONFIG = VUHDO_ensureSanity("VUHDO_SPELL_CONFIG", VUHDO_SPELL_CONFIG, VUHDO_DEFAULT_SPELL_CONFIG);

	if (VUHDO_SPELL_LAYOUTS == nil) then
		VUHDO_SPELL_LAYOUTS = { };
	end

	if (VUHDO_SPEC_LAYOUTS == nil) then
		VUHDO_SPEC_LAYOUTS = {
			["selected"] = "",
			["1"] = "";
			["2"] = "";
		}
	end

	VUHDO_DEFAULT_SPELL_ASSIGNMENT = nil;
	VUHDO_DEFAULT_HOSTILE_SPELL_ASSIGNMENT = nil;
	VUHDO_DEFAULT_SPELLS_KEYBOARD = nil;
end



--
local function VUHDO_customDebuffsAddDefaultSettings(aBuffName)
	if (VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"] == nil) then
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"] = { };
	end

	if (VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName] == nil) then
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]	= {
			["isIcon"] = VUHDO_CONFIG["CUSTOM_DEBUFF"]["isIcon"],
			["isColor"] = false,
			["animate"] = VUHDO_CONFIG["CUSTOM_DEBUFF"]["animate"],
			["timer"] = VUHDO_CONFIG["CUSTOM_DEBUFF"]["timer"],
			["isStacks"] = VUHDO_CONFIG["CUSTOM_DEBUFF"]["isStacks"],
		}

		-- Wrack
		if (select(1, GetSpellInfo(92956)) == aBuffName) then
			VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["isAliveTime"] = true;
			VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["isFullDuration"] = true;
		end
	end

	if (not VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["isColor"]) then
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["color"] = nil;
	elseif (VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["color"] == nil) then
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][aBuffName]["color"] = {
			["R"] = 0.6, ["G"] = 0.3, ["B"] = 0, ["O"] = 1,
			["TR"] = 0.8,	["TG"] = 0.5,	["TB"] = 0,	["TO"] = 1,
			["useText"] = true,	["useBackground"] = true,  ["useOpacity"] = true,
		};
	end
end



--
local function VUHDO_addCustomSpellIds(aVersion, ...)
	if ((VUHDO_CONFIG["CUSTOM_DEBUFF"].version or 0) < aVersion) then
		VUHDO_CONFIG["CUSTOM_DEBUFF"].version = aVersion;

		local tCnt;
		local tArg;

		for tCnt = 1, select("#", ...) do
			tArg = select(tCnt, ...);
			if (type(tArg) == "number") then
				tArg = select(1, GetSpellInfo(tArg));
			end
			VUHDO_tableUniqueAdd(VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED"], tArg);
		end
	end
end



--
local VUHDO_DEFAULT_CONFIG = {
	["VERSION"] = 4,

	["SHOW_PANELS"] = true,
	["HIDE_PANELS_SOLO"] = false,
	["HIDE_PANELS_PARTY"] = false,
	["LOCK_PANELS"] = false,
	["LOCK_CLICKS_THROUGH"] = false,
	["LOCK_IN_FIGHT"] = true,
	["SHOW_MINIMAP"] = true,
	["PARSE_COMBAT_LOG"] = true,
	["HIDE_EMPTY_BUTTONS"] = false,

	["MODE"] = VUHDO_MODE_NEUTRAL,
	["EMERGENCY_TRIGGER"] = 100,
	["MAX_EMERGENCIES"] = 5,
	["SHOW_INCOMING"] = true,
	["SHOW_OVERHEAL"] = true,
	["SHOW_OWN_INCOMING"] = true,
	["SHOW_TEXT_OVERHEAL"] = true,

	["RANGE_CHECK_DELAY"] = 260,

	["SOUND_DEBUFF"] = nil,
	["DETECT_DEBUFFS_REMOVABLE_ONLY"] = true,
	["DETECT_DEBUFFS_IGNORE_BY_CLASS"] = true,
	["DETECT_DEBUFFS_IGNORE_NO_HARM"] = true,
	["DETECT_DEBUFFS_IGNORE_MOVEMENT"] = true,
	["DETECT_DEBUFFS_IGNORE_DURATION"] = true,

	["SMARTCAST_RESURRECT"] = true,
	["SMARTCAST_CLEANSE"] = true,
	["SMARTCAST_BUFF"] = false,

	["SHOW_PLAYER_TAGS"] = true,
	["OMIT_MAIN_TANKS"] = false,
	["OMIT_MAIN_ASSIST"] = false,
	["OMIT_PLAYER_TARGETS"] = false,
	["OMIT_OWN_GROUP"] = false,
	["OMIT_FOCUS"] = false,
	["OMIT_TARGET"] = false,
	["OMIT_SELF"] = false,
	["OMIT_DFT_MTS"] = false,
	["BLIZZ_UI_HIDE_PLAYER"] = false,
	["BLIZZ_UI_HIDE_PARTY"] = false,
	["BLIZZ_UI_HIDE_TARGET"] = false,
	["BLIZZ_UI_HIDE_PET"] = false,
	["BLIZZ_UI_HIDE_FOCUS"] = false,
	["BLIZZ_UI_HIDE_RAID"] = false,
	["BLIZZ_UI_HIDE_RAID_MGR"] = false,

	["CURRENT_PROFILE"] = "",
	["IS_ALWAYS_OVERWRITE_PROFILE"] = false,
	["HIDE_EMPTY_PANELS"] = false,
	["ON_MOUSE_UP"] = false,

	["STANDARD_TOOLTIP"] = false,
	["DEBUFF_TOOLTIP"] = true,

	["AUTO_PROFILES"] = {
		["1"] = nil,
		["5"] = nil,
		["10"] = nil,
		["15"] = nil,
		["25"] = nil,
		["40"] = nil,

		["SPEC_1"] = nil,
		["SPEC_2"] = nil,

		["SPEC_1_1"] = nil,
		["SPEC_1_5"] = nil,
		["SPEC_1_10"] = nil,
		["SPEC_1_15"] = nil,
		["SPEC_1_25"] = nil,
		["SPEC_1_40"] = nil,

		["SPEC_2_1"] = nil,
		["SPEC_2_5"] = nil,
		["SPEC_2_10"] = nil,
		["SPEC_2_15"] = nil,
		["SPEC_2_25"] = nil,
		["SPEC_2_40"] = nil,
	},

	["RES_ANNOUNCE_TEXT"] = VUHDO_I18N_DEFAULT_RES_ANNOUNCE,
	["RES_IS_SHOW_TEXT"] = false,

	["CUSTOM_DEBUFF"] = {
		["scale"] = 0.8,
		["animate"] = true,
		["timer"] = true,
		["max_num"] = 3,
		["isIcon"] = true,
		["isColor"] = false,
		["isStacks"] = false,
		["isName"] = false,
		["selected"] = "",
		["point"] = "TOPRIGHT",
		["xAdjust"] = -2,
		["yAdjust"] = -34,
		["STORED"] = { },

		["TIMER_TEXT"] = {
			["ANCHOR"] = "BOTTOMRIGHT",
			["X_ADJUST"] = 20,
			["Y_ADJUST"] = 26,
			["SCALE"] = 85,
			["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
			["COLOR"] = {
				["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 1,
				["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
			},
			["USE_SHADOW"] = true,
			["USE_OUTLINE"] = false,
			["USE_MONO"] = false,
		},

		["COUNTER_TEXT"] = {
			["ANCHOR"] = "TOPLEFT",
			["X_ADJUST"] = -10,
			["Y_ADJUST"] = -15,
			["SCALE"] = 70,
			["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
			["COLOR"] = {
				["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 1,
				["TR"] = 0, ["TG"] = 1, ["TB"] = 0, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
			},
			["USE_SHADOW"] = true,
			["USE_OUTLINE"] = false,
			["USE_MONO"] = false,
		},
	},

	["THREAT"] = {
		["AGGRO_REFRESH_MS"] = 300,
		["AGGRO_TEXT_LEFT"] = ">>",
		["AGGRO_TEXT_RIGHT"] = "<<",
		["AGGRO_USE_TEXT"] = false,
		["IS_TANK_MODE"] = false,
	},

	["CLUSTER"] = {
		["REFRESH"] = 180,
		["RANGE"] = 30,
		["BELOW_HEALTH_PERC"] = 85,
		["THRESH_FAIR"] = 3,
		["THRESH_GOOD"] = 5,
		["DISPLAY_SOURCE"] = 2, -- 1=Mine, 2=all
		["DISPLAY_DESTINATION"] = 2, -- 1=Party, 2=Raid
		["MODE"] = 1, -- 1=radial, 2=chained
		["IS_NUMBER"] = true,
		["CHAIN_MAX_JUMP"] = 3,
		["COOLDOWN_SPELL"] = "",
		["CONE_DEGREES"] = 360,

		["TEXT"] = {
			["ANCHOR"] = "BOTTOMRIGHT",
			["X_ADJUST"] = 40,
			["Y_ADJUST"] = 22,
			["SCALE"] = 85,
			["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
			["COLOR"] = {
				["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 1,
				["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
			},
			["USE_SHADOW"] = false,
			["USE_OUTLINE"] = true,
			["USE_MONO"] = false,
		},
	},

	["UPDATE_HOTS_MS"] = 250,
	["SCAN_RANGE"] = "2", -- 0=all, 2=100 yards, 3=40 yards

	["RANGE_SPELL"] = "",
	["RANGE_PESSIMISTIC"] = true,

	["IS_SHOW_GCD"] = false,
	["IS_SCAN_TALENTS"] = true,
	["IS_CLIQUE_COMPAT_MODE"] = false,
	["DIRECTION"] = {
		["enable"] = true,
		["isDistanceText"] = false,
		["isDeadOnly"] = false,
		["isAlways"] = false,
		["scale"] = 75,
	},

	["AOE_ADVISOR"] = {
		["knownOnly"] = true,
		["subInc"] = true,
		["subIncOnlyCastTime"] = true,
		["isCooldown"] = true,
		["animate"] = true,
		["isGroupWise"] = false,
		["refresh"] = 800,

		["config"] = {
			["coh"] = {
				["enable"] = true,
				["thresh"] = 15000,
			},
			["poh"] = {
				["enable"] = true,
				["thresh"] = 20000,
			},
			["ch"] = {
				["enable"] = true,
				["thresh"] = 15000,
			},
			["wg"] = {
				["enable"] = true,
				["thresh"] = 15000,
			},
			["tq"] = {
				["enable"] = true,
				["thresh"] = 15000,
			},
			["lod"] = {
				["enable"] = true,
				["thresh"] = 8000,
			},
			["ef"] = {
				["enable"] = true,
				["thresh"] = 8000,
			},
			["hr"] = {
				["enable"] = false,
				["thresh"] = 10000,
			},
		},

	},

	["IS_DC_SHIELD_DISABLED"] = false,
	["IS_USE_BUTTON_FACADE"] = false,
	["IS_SHARE"] = true,
	["IS_READY_CHECK_DISABLED"] = false,
};



local VUHDO_DEFAULT_CU_DE_STORED_SETTINGS = {
	["isIcon"] = true,
	["isColor"] = false,
--	["SOUND"] = "",
	["animate"] = true,
	["timer"] = true,
	["isStacks"] = true,
	["isAliveTime"] = false,
	["isFullDuration"] = false,

--	["color"] = {
--		["R"] = 0.6,
--		["G"] = 0.3,
--		["B"] = 0,
--		["O"] = 1,
--		["TR"] = 0.8,
--		["TG"] = 0.5,
--		["TB"] = 0,
--		["TO"] = 1,
--		["useText"] = true,
--		["useBackground"] = true,
--		["useOpacity"] = true,
--	},
};



VUHDO_DEFAULT_POWER_TYPE_COLORS = {
	[VUHDO_UNIT_POWER_MANA] = { ["R"] = 0, ["G"] = 0, ["B"] = 1, ["O"] = 1, ["TR"] = 0, ["TG"] = 0, ["TB"] = 1, ["TO"] = 1, ["useBackground"] = true, ["useOpacity"] = true, ["useText"] = true },
	[VUHDO_UNIT_POWER_RAGE] = { ["R"] = 1, ["G"] = 0, ["B"] = 0, ["O"] = 1, ["TR"] = 1, ["TG"] = 0, ["TB"] = 0, ["TO"] = 1, ["useBackground"] = true, ["useOpacity"] = true, ["useText"] = true  },
	[VUHDO_UNIT_POWER_FOCUS] = { ["R"] = 1, ["G"] = 0.5, ["B"] = 0.25, ["O"] = 1, ["TR"] = 1, ["TG"] = 0.5, ["TB"] = 0.25, ["TO"] = 1, ["useBackground"] = true, ["useOpacity"] = true, ["useText"] = true  },
	[VUHDO_UNIT_POWER_ENERGY] = { ["R"] = 1, ["G"] = 1, ["B"] = 0, ["O"] = 1,["TR"] = 1, ["TG"] = 1, ["TB"] = 0, ["TO"] = 1,  ["useBackground"] = true, ["useOpacity"] = true, ["useText"] = true  },
	[VUHDO_UNIT_POWER_HAPPINESS] = { ["R"] = 0, ["G"] = 1, ["B"] = 1, ["O"] = 1, ["TR"] = 0, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1, ["useBackground"] = true, ["useOpacity"] = true, ["useText"] = true  },
	[VUHDO_UNIT_POWER_RUNES] = { ["R"] = 0.5, ["G"] = 0.5, ["B"] = 0.5, ["O"] = 1, ["TR"] = 0.5, ["TG"] = 0.5, ["TB"] = 0.5, ["TO"] = 1, ["useBackground"] = true, ["useOpacity"] = true, ["useText"] = true  },
};


--
function VUHDO_loadDefaultConfig()
	local tClass;
	 _, tClass = UnitClass("player");

	if (VUHDO_CONFIG == nil) then
		VUHDO_CONFIG = VUHDO_decompressOrCopy(VUHDO_DEFAULT_CONFIG);

		if (VUHDO_DEFAULT_RANGE_SPELLS[tClass] ~= nil) then
			VUHDO_CONFIG["RANGE_SPELL"] = VUHDO_DEFAULT_RANGE_SPELLS[tClass];
			VUHDO_CONFIG["RANGE_PESSIMISTIC"] = false;
		end
	end

	VUHDO_CONFIG = VUHDO_ensureSanity("VUHDO_CONFIG", VUHDO_CONFIG, VUHDO_DEFAULT_CONFIG);
	VUHDO_DEFAULT_CONFIG = VUHDO_compressTable(VUHDO_DEFAULT_CONFIG);

	if ((VUHDO_CONFIG["VERSION"] or 1) < 4) then
		VUHDO_CONFIG["IS_SHARE"] = true;
		VUHDO_CONFIG["VERSION"] = 4;
	end

	VUHDO_addCustomSpellIds(14,
		-- 4.1 raid
		95173, -- Consuming Darkness
		91911, -- Constricting Chains
		94679, -- Parasitic Infection
		94617, -- Mangle
		79835, -- Poison Soaked Shell
		91433, -- Lightning Conductor
		91521, -- Incineration Security Measure
		77699, -- Flash Freeze
		77760, -- Biting Chill
		92423, -- Searing Flame
		92485, -- Roaring Flame
		92407, -- Sonic Breath
		82881, -- Break
		89084, -- Low Health
		92878, -- Blackout
		86840, -- Devouring Flames
		95639, -- Engulfing Magic
		39171, -- Malevolent Strikes
		92511, -- Hydro Lance
		82762, -- Waterlogged
		92505, -- Frozen
		92518, -- Flame Torrent
		83099, -- Lightning Rod
		92075, -- Gravity Core
		92488, -- Gravity Crush
		86028, -- Cho's Blast
		86029, -- Gall's Blast
		93131, -- Ice Patch
		86206, -- Soothing Breeze
		93122, -- Toxic Spores
		93058, -- Slicing Gale
		93260, -- Ice Storm
		93295,  -- Lightning Rod
		81836 -- Corruption: Accelerated
	);


	VUHDO_addCustomSpellIds(16,
		-----
		-- ZA
		-----
		--Akilzon:
		43648, -- Electrical Storm
		97318, -- Plucked?
		--Daakara
		97639, -- Throw?
		--Halazzi
		97490, -- Shock?
		--Janalai
		43140, -- Flame Breath
		--Malacrass
		43501, -- Siphon Soul
		--Nalorak
		--?
		-----
		-- ZG
		-----
		-- Jindo
		97198, -- Body Slam?
		-- Kilnara
		96958, -- Lash?
		96592, -- Ravage?
		-- Mandokir
		96684, -- Decapitate?
		96776, -- Bloodletting?
		--Venoxis
		96466, -- Whisper Hetiss?
		96477, -- Toxic Link?
		--Zanzil
		96342  -- Gaze?
	);


	VUHDO_addCustomSpellIds(17,
		96328, -- Toxic Torment
		96326, -- Burning Blood
		96325  -- Frostburn Formula
	);


	VUHDO_addCustomSpellIds(18,
		92956, -- Sinestra: Wrack

		-- Firelands
		99506, -- Widows Kiss
		--Alysrazor
		101296, -- Fiero Blast
		100723, -- Gushing Wound
		--Shannox
		99837, -- Crystal Prison
		99937, -- Jagged Tear
		--Baleroc
		--99403, -- Tormented
		99256, -- Torment
		99252, -- Blaze of Glory
		--Lord Rhyolith
		--Majordomo Staghelm
		98450, -- Searing Seeds
		--Ragnaros
		99399, -- Burning Wound
		--Trash
		99532  -- Melt Armor
	);

	-- 4.3 Dragon Soul
	VUHDO_addCustomSpellIds(19,
		-- Morchok
		103687, -- Crush Armor
		--Hagara the Stormbinder
		104451, -- Ice Tomb
		105259, -- Watery Entrenchment
		105289, -- Shattered Ice
		-- Warmaster Blackhorn
		109204, -- Twilight Barrage
		108046, -- Shockwave
		108043, -- Devastate
		107567, -- Brutal strike
		107558, -- Degeneration
		--108045, -- Vengeance
		-- Ultraxion
		106108, -- Heroic will
		106369, -- Twilight shift
		106415, -- Twilight burst
		105927, -- Faded Into Twilight
		110068, -- Fading light (not sure, maybe must be removed)
		-- Yor'sahj the Unsleeping
		--104849, -- Void bolt
		109389, -- Deep Corruption
		-- Warlord Zon'ozz
		103434, -- Disrupting shadows
		110306, -- Black Blood of Go'rath
		--104543, -- Focused anger
		--106836, -- Void diffusion
		-- Spine of Deathwing
		105563, -- Grasping Tendrils
		105490, -- Fiery Grip
		105479, -- Searing Plasma
		106199, -- Blood corruption: death
		106200, -- Blood corruption: earth
		106005, -- Degradation
		-- Madness of Deathwing
		105841, -- Degenerative bite
		105445, -- Blistering heat
		109603  -- Tetanus
		--109632, -- Impale
		--109592, -- Corrupted blood
	);

	--[[local tUpdateStacks = false;
	if (VUHDO_CONFIG["CUSTOM_DEBUFF"].version < 20) then
		VUHDO_tableRemoveValue(VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED"], select(1, GetSpellInfo(109389)));
		VUHDO_addCustomSpellIds(20,
			"108220",
			"105171",
			"103628",
			"109389",
			"108349",
			"108348",
			"108347",
			"105173",
			"109390"
		);
		tUpdateStacks = true;
	end]]


	local tName;
	for _, tName in pairs(VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED"]) do
		VUHDO_customDebuffsAddDefaultSettings(tName);
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][tName] = VUHDO_ensureSanity(
			"CUSTOM_DEBUFF.STORED_SETTINGS",
			VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][tName],
			VUHDO_DEFAULT_CU_DE_STORED_SETTINGS
		);
	end

	--[[if (tUpdateStacks) then
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"]["108220"]["isStacks"] = true;
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"]["105171"]["isStacks"] = true;
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"]["103628"]["isStacks"] = true;
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"]["109389"]["isStacks"] = true;
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"]["108349"]["isStacks"] = true;
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"]["108348"]["isStacks"] = true;
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"]["108347"]["isStacks"] = true;
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"]["105171"]["isStacks"] = true;
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"]["109390"]["isStacks"] = true;
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][select(1, GetSpellInfo(109389))] = nil;
	end]]

	if (VUHDO_POWER_TYPE_COLORS == nil) then
		VUHDO_POWER_TYPE_COLORS = VUHDO_decompressOrCopy(VUHDO_DEFAULT_POWER_TYPE_COLORS);
	end
	VUHDO_POWER_TYPE_COLORS = VUHDO_ensureSanity("VUHDO_POWER_TYPE_COLORS", VUHDO_POWER_TYPE_COLORS, VUHDO_DEFAULT_POWER_TYPE_COLORS);
	VUHDO_DEFAULT_POWER_TYPE_COLORS = VUHDO_compressTable(VUHDO_DEFAULT_POWER_TYPE_COLORS);
end



local VUHDO_DEFAULT_PANEL_SETUP = {
	["RAID_ICON_FILTER"] = {
		[1] = true,
		[2] = true,
		[3] = true,
		[4] = true,
		[5] = true,
		[6] = true,
		[7] = true,
		[8] = true
	},

	["HOTS"] = {
		["radioValue"] = 20,
		["iconRadioValue"] = 2,
		["stacksRadioValue"] = 2,

		["TIMER_TEXT"] = {
			["ANCHOR"] = "BOTTOMRIGHT",
			["X_ADJUST"] = 25,
			["Y_ADJUST"] = 0,
			["SCALE"] = 60,
			["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
			["USE_SHADOW"] = false,
			["USE_OUTLINE"] = true,
			["USE_MONO"] = false,
		},

		["COUNTER_TEXT"] = {
			["ANCHOR"] = "TOPLEFT",
			["X_ADJUST"] = -25,
			["Y_ADJUST"] = 0,
			["SCALE"] = 66,
			["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
			["USE_SHADOW"] = false,
			["USE_OUTLINE"] = true,
			["USE_MONO"] = false,
		},

		["SLOTS"] = {
			["firstFlood"] = true,
		},

		["SLOTCFG"] = {
			["firstFlood"] = true,
			["1"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["2"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["3"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["4"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["5"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["6"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["7"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["8"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["9"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1 },
			["10"] = { ["mine"] = true, ["others"] = false, ["scale"] = 1.5 },
		},

		["BARS"] = {
			["radioValue"] = 1,
			["width"] = 25,
		},
	},

	["PANEL_COLOR"] = {
		["TEXT"] = {
			["TR"] = 1, ["TG"] = 0.82, ["TB"] = 0, ["TO"] = 1,
			["useText"] = true,
		},
		["HEALTH_TEXT"] = {
			["useText"] = false,
			["TR"] = 1, ["TG"] = 0, ["TB"] = 0, ["TO"] = 1,
		},
		["BARS"] = {
			["R"] = 0.7, ["G"] = 0.7, ["B"] = 0.7, ["O"] = 1,
			["useBackground"] = true, ["useOpacity"] = true,
		},
		["classColorsName"] = false,
	},

	["BAR_COLORS"] = {

		["TARGET"] = {
			["TR"] = 1,	["TG"] = 1,	["TB"] = 1,	["TO"] = 1,
			["R"] = 0,	["G"] = 1,	["B"] = 0,	["O"] = 1,
			["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
			["modeText"] = 2; -- 1=enemy, 2=solid, 3=class color, 4=gradient
			["modeBack"] = 1;
		},

		["IRRELEVANT"] =  {
			["R"] = 0, ["G"] = 0, ["B"] = 0.4, ["O"] = 0.2,
			["TR"] = 1, ["TG"] = 0.82, ["TB"] = 0, ["TO"] = 1,
			["useText"] = false, ["useBackground"] = false, ["useOpacity"] = true,
		},

		["INCOMING"] = {
			["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.33,
			["TR"] = 1, ["TG"] = 0.82, ["TB"] = 0, ["TO"] = 1,
			["useText"] = false, ["useBackground"] = false,	["useOpacity"] = true,
		},

		["EMERGENCY"] = {
			["R"] = 1, ["G"] = 0, ["B"] = 0, ["O"] = 1,
			["TR"] = 1, ["TG"] = 0.82, ["TB"] = 0, ["TO"] = 1,
			["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
		},

		["NO_EMERGENCY"] = {
			["R"] = 0, ["G"] = 0, ["B"] = 0.4, ["O"] = 1,
			["TR"] = 1, ["TG"] = 0.82, ["TB"] = 0, ["TO"] = 1,
			["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
		},

		["OFFLINE"] = {
			["R"] = 0.298, ["G"] = 0.298, ["B"] = 0.298, ["O"] = 0.21,
			["TR"] = 0.576, ["TG"] = 0.576, ["TB"] = 0.576,
			["TO"] = 0.58, ["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
		},

		["DEAD"] = {
			["R"] = 0.3, ["G"] = 0.3, ["B"] = 0.3, ["O"] = 0.5,
			["TR"] = 0.5, ["TG"] = 0.5, ["TB"] = 0.5, ["TO"] = 1,
			["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
		},

		["OUTRANGED"] = {
			["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.25,
			["TR"] = 0, ["TG"] = 0, ["TB"] = 0, ["TO"] = 0.5,
			["useText"] = false, ["useBackground"] = false, ["useOpacity"] = true,
		},

		["TAPPED"] = {
			["R"] = 0.4, ["G"] = 0.4, ["B"] = 0.4, ["O"] = 1,
			["TR"] = 0.4, ["TG"] = 0.4, ["TB"] = 0.4, ["TO"] = 1,
			["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
		},

		["TARGET_FRIEND"] = {
			["R"] = 0, ["G"] = 1, ["B"] = 0, ["O"] = 1,
			["TR"] = 0, ["TG"] = 1, ["TB"] = 0, ["TO"] = 1,
			["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
		},

		["TARGET_NEUTRAL"] = {
			["R"] = 1, ["G"] = 1, ["B"] = 0, ["O"] = 1,
			["TR"] = 1, ["TG"] = 1, ["TB"] = 0, ["TO"] = 1,
			["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
		},

		["TARGET_ENEMY"] = {
			["R"] = 1, ["G"] = 0, ["B"] = 0, ["O"] = 1,
			["TR"] = 1, ["TG"] = 0, ["TB"] = 0, ["TO"] = 1,
			["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
		},

		["DEBUFF" .. VUHDO_DEBUFF_TYPE_NONE] =  {
			["useText"] = false, ["useBackground"] = false, ["useOpacity"] = false,
		},

		["DEBUFF" .. VUHDO_DEBUFF_TYPE_POISON] = {
			["R"] = 0, ["G"] = 0.592, ["B"] = 0.8, ["O"] = 1,
			["TR"] = 0, ["TG"] = 1, ["TB"] = 0.686, ["TO"] = 1,
			["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
		},

		["DEBUFF" .. VUHDO_DEBUFF_TYPE_DISEASE] = {
			["R"] = 0.8, ["G"] = 0.4, ["B"] = 0.4, ["O"] = 1,
			["TR"] = 1, ["TG"] = 0, ["TB"] = 0, ["TO"] = 1,
			["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
		},

		["DEBUFF" .. VUHDO_DEBUFF_TYPE_CURSE] = {
			["R"] = 0.7, ["G"] = 0, ["B"] = 0.7, ["O"] = 1,
			["TR"] = 1, ["TG"] = 0, ["TB"] = 1, ["TO"] = 1,
			["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
		},

		["DEBUFF" .. VUHDO_DEBUFF_TYPE_MAGIC] = {
			["R"] = 0.4, ["G"] = 0.4, ["B"] = 0.8, ["O"] = 1,
			["TR"] = 0.329, ["TG"] = 0.957, ["TB"] = 1, ["TO"] = 1,
			["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
		},

		["DEBUFF" .. VUHDO_DEBUFF_TYPE_CUSTOM] = {
			["R"] = 0.6, ["G"] = 0.3, ["B"] = 0, ["O"] = 1,
			["TR"] = 0.8, ["TG"] = 0.5, ["TB"] = 0, ["TO"] = 1,
			["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
		},

		["CHARMED"] = {
			["R"] = 0.51, ["G"] = 0.082, ["B"] = 0.263, ["O"] = 1,
			["TR"] = 1, ["TG"] = 0.31, ["TB"] = 0.31, ["TO"] = 1,
			["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
		},

		["BAR_FRAMES"] = {
			["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.7,
			["useBackground"] = true, ["useOpacity"] = true,
		},

		["OVERHEAL_TEXT"] = {
			["TR"] = 0.8, ["TG"] = 1, ["TB"] = 0.8, ["TO"] = 1,
			["useText"] = true, ["useOpacity"] = true,
		},

		["HOTS"] = {
			["useColorText"] = true,
			["useColorBack"] = true,
			["isFadeOut"] = false,
			["isFlashWhenLow"] = false,
			["showShieldAbsorb"] = true,
			["isPumpDivineAegis"] = false,
			["WARNING"] = {
				["R"] = 0.5, ["G"] = 0.2,	["B"] = 0.2, ["O"] = 1,
				["TR"] = 1,	["TG"] = 0.6,	["TB"] = 0.6,	["TO"] = 1,
				["useText"] = true,	["useBackground"] = true,
				["lowSecs"] = 3, ["enabled"] = false,
			},
		},

		["HOT1"] = {
			["R"] = 1, ["G"] = 0.3, ["B"] = 0.3, ["O"] = 1,
			["TR"] = 1, ["TG"] = 0.6, ["TB"] = 0.6, ["TO"] = 1,
			["useBackground"] = true, ["useText"] = true,
			["isFullDuration"] = false, ["isClock"] = false, ["countdownMode"] = 1,
		},

		["HOT2"] = {
			["R"] = 1, ["G"] = 1, ["B"] = 0.3, ["O"] = 1,
			["TR"] = 1, ["TG"] = 1, ["TB"] = 0.6, ["TO"] = 1,
			["useBackground"] = true, ["useText"] = true,
			["isFullDuration"] = false, ["isClock"] = false,	["countdownMode"] = 1,
		},

		["HOT3"] = {
			["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
			["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
			["useBackground"] = true, ["useText"] = true,
			["isFullDuration"] = false, ["isClock"] = false, ["countdownMode"] = 1,
		},

		["HOT4"] = {
			["R"] = 0.3, ["G"] = 0.3, ["B"] = 1, ["O"] = 1,
			["TR"] = 0.6, ["TG"] = 0.6, ["TB"] = 1, ["TO"] = 1,
			["useBackground"] = true, ["useText"] = true,
			["isFullDuration"] = false, ["isClock"] = false, ["countdownMode"] = 1,
		},

		["HOT5"] = {
			["R"] = 1, ["G"] = 0.3, ["B"] = 1, ["O"] = 1,
			["TR"] = 1, ["TG"] = 0.6, ["TB"] = 1, ["TO"] = 1,
			["useBackground"] = true, ["useText"] = true,
			["isFullDuration"] = false, ["isClock"] = false, ["countdownMode"] = 1,
		},

		["HOT6"] = {
			["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 0.75,
			["useBackground"] = true,
		},

		["HOT7"] = {
			["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 0.75,
			["useBackground"] = true,
		},

		["HOT8"] = {
			["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 0.75,
			["useBackground"] = true,
		},

		["HOT9"] = {
			["R"] = 0.3, ["G"] = 1, ["B"] = 1, ["O"] = 1,
			["TR"] = 0.6, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
			["useBackground"] = true,	["useText"] = true,
			["isFullDuration"] = false, ["isClock"] = false,	["countdownMode"] = 1,
		},

		["HOT10"] = {
			["R"] = 0.3, ["G"] = 1, ["B"] = 0.3, ["O"] = 1,
			["TR"] = 0.6, ["TG"] = 1, ["TB"] = 0.3, ["TO"] = 1,
			["useBackground"] = true,	["useText"] = true,
			["isFullDuration"] = false, ["isClock"] = false,	["countdownMode"] = 1,
		},

		["HOT_CHARGE_2"] = {
			["R"] = 1, ["G"] = 1, ["B"] = 0.3, ["O"] = 1,
			["TR"] = 1, ["TG"] = 1, ["TB"] = 0.6, ["TO"] = 1,
			["useBackground"] = true, ["useText"] = true,
		},

		["HOT_CHARGE_3"] = {
			["R"] = 0.3, ["G"] = 1, ["B"] = 0.3, ["O"] = 1,
			["TR"] = 0.6, ["TG"] = 1, ["TB"] = 0.6, ["TO"] = 1,
			["useBackground"] = true, ["useText"] = true,
		},

		["HOT_CHARGE_4"] = {
			["R"] = 0.8, ["G"] = 0.8, ["B"] = 0.8, ["O"] = 1,
			["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
			["useBackground"] = true, ["useText"] = true,
		},

		["useDebuffIcon"] = false,
		["useDebuffIconBossOnly"] = true,

		["RAID_ICONS"] = {
			["enable"] = false,
			["filterOnly"] = false,

			["1"] = {
				["R"] = 1, ["G"] = 0.976,	["B"] = 0.305, ["O"] = 1,
				["TR"] = 0.980,	["TG"] = 1,	["TB"] = 0.607,	["TO"] = 1,
				["useBackground"] = true,	["useText"] = true,
			},
			["2"] = {
				["R"] = 1, ["G"] = 0.513,	["B"] = 0.039, ["O"] = 1,
				["TR"] = 1,	["TG"] = 0.827,	["TB"] = 0.419,	["TO"] = 1,
				["useBackground"] = true,	["useText"] = true,
			},
			["3"] = {
				["R"] = 0.788, ["G"] = 0.290,	["B"] = 0.8, ["O"] = 1,
				["TR"] = 1,	["TG"] = 0.674,	["TB"] = 0.921,	["TO"] = 1,
				["useBackground"] = true,	["useText"] = true,
			},
			["4"] = {
				["R"] = 0, ["G"] = 0.8,	["B"] = 0.015, ["O"] = 1,
				["TR"] = 0.698,	["TG"] = 1,	["TB"] = 0.698,	["TO"] = 1,
				["useBackground"] = true,	["useText"] = true,
			},
			["5"] = {
				["R"] = 0.466, ["G"] = 0.717,	["B"] = 0.8, ["O"] = 1,
				["TR"] = 0.725,	["TG"] = 0.870,	["TB"] = 1,	["TO"] = 1,
				["useBackground"] = true,	["useText"] = true,
			},
			["6"] = {
				["R"] = 0.121, ["G"] = 0.690,	["B"] = 0.972, ["O"] = 1,
				["TR"] = 0.662,	["TG"] = 0.831,	["TB"] = 1,	["TO"] = 1,
				["useBackground"] = true,	["useText"] = true,
			},
			["7"] = {
				["R"] = 0.8, ["G"] = 0.184,	["B"] = 0.129, ["O"] = 1,
				["TR"] = 1, ["TG"] = 0.627,	["TB"] = 0.619,	["TO"] = 1,
				["useBackground"] = true,	["useText"] = true,
			},
			["8"] = {
				["R"] = 0.847, ["G"] = 0.866,	["B"] = 0.890, ["O"] = 1,
				["TR"] = 0.231,	["TG"] = 0.231,	["TB"] = 0.231, ["TO"] = 1,
				["useBackground"] = true,	["useText"] = true,
			},
		},

		["CLUSTER_FAIR"] = {
			["R"] = 0.8, ["G"] = 0.8, ["B"] = 0, ["O"] = 1,
			["TR"] = 1, ["TG"] = 1, ["TB"] = 0, ["TO"] = 1,
			["useBackground"] = true, ["useText"] = true,
		},

		["CLUSTER_GOOD"] = {
			["R"] = 0, ["G"] = 0.8, ["B"] = 0, ["O"] = 1,
			["TR"] = 0, ["TG"] = 1, ["TB"] = 0, ["TO"] = 1,
			["useBackground"] = true, ["useText"] = true,
		},

		["GCD_BAR"] = {
			["R"] = 0.4, ["G"] = 0.4, ["B"] = 0.4, ["O"] = 0.5,
			["useBackground"] = true,
		},

		["LIFE_LEFT"] = {
			["LOW"] = {
				["R"] = 1, ["G"] = 0, ["B"] = 0, ["O"] = 1,
				["useBackground"] = true,
			},
			["FAIR"] = {
				["R"] = 1, ["G"] = 1, ["B"] = 0, ["O"] = 1,
				["useBackground"] = true,
			},
			["GOOD"] = {
				["R"] = 0, ["G"] = 1, ["B"] = 0, ["O"] = 1,
				["useBackground"] = true,
			},
		},

		["THREAT"] = {
			["HIGH"] = {
				["R"] = 1, ["G"] = 0, ["B"] = 1, ["O"] = 1,
				["useBackground"] = true,
			},
			["LOW"] = {
				["R"] = 0, ["G"] = 1, ["B"] = 1, ["O"] = 1,
				["useBackground"] = true,
			},
		},
	}, -- BAR_COLORS
};



local VUHDO_DEFAULT_PER_PANEL_SETUP = {
	["HOTS"] = {
		["size"] = 76,
	},
	["MODEL"] = {
		["ordering"] = VUHDO_ORDERING_STRICT,
		["sort"] = VUHDO_SORT_RAID_UNITID,
		["isReverse"] = false,
	},

	["POSITION"] = {
		["x"] = 100,
		["y"] = 668,
		["relativePoint"] = "BOTTOMLEFT",
		["orientation"] = "TOPLEFT",
		["growth"] = "TOPLEFT",
		["width"] = 200,
		["height"] = 200,
		["scale"] = 1,
	};

	["SCALING"] = {
		["columnSpacing"] = 5,
		["rowSpacing"] = 2,

		["borderGapX"] = 5,
		["borderGapY"] = 5,

		["barWidth"] = 75,
		["barHeight"] = 25,

		["showHeaders"] = true,
		["headerHeight"] = 16,
		["headerWidth"] = 100,
		["headerSpacing"] = 5,

		["manaBarHeight"] = 3,
		["sideLeftWidth"] = 6,
		["sideRightWidth"] = 6,

		["maxColumnsWhenStructured"] = 8,
		["maxRowsWhenLoose"] = 6,
		["ommitEmptyWhenStructured"] = false,
		["isPlayerOnTop"] = true,

		["showTarget"] = false,
		["targetSpacing"] = 3,
		["targetWidth"] = 30,

		["showTot"] = false,
		["totSpacing"] = 3,
		["totWidth"] = 30,
		["targetOrientation"] = 1;

		["isTarClassColText"] = true,
		["isTarClassColBack"] = false,

		["arrangeHorizontal"] = false,
		["alignBottom"] = false,

		["scale"] = 1,

		["isDamFlash"] = true,
		["damFlashFactor"] = 0.75,
	},

	["LIFE_TEXT"] = {
		["show"] = true,
		["mode"] = VUHDO_LT_MODE_PERCENT,
		["position"] = VUHDO_LT_POS_ABOVE,
		["verbose"] = false,
		["hideIrrelevant"] = false,
		["showTotalHp"] = false;
	},

	["ID_TEXT"] = {
		["showName"] = true,
		["showClass"] = false,
		["showTags"] = true,
		["showPetOwners"] = true,
		["position"] = "BOTTOMRIGHT+BOTTOMRIGHT",
		["xAdjust"] = 0.000001,
		["yAdjust"] = 0.000001,
	},

	["PANEL_COLOR"] = {
		["barTexture"] = "VuhDo - Polished Wood",

		["BACK"] = {
			["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.4,
			["useBackground"] = true, ["useOpacity"] = true,
		},

		["BORDER"] = {
			["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.46,
			["useBackground"] = true, ["useOpacity"] = true,
			["file"] = "Interface\\Tooltips\\UI-Tooltip-Border",
			["edgeSize"] = 8,
			["insets"] = 1,
		},

		["TEXT"] = {
			["useText"] = true, ["useOpacity"] = true,
			["textSize"] = 10,
			["textSizeLife"] = 8,
			["maxChars"] = 0,
			["outline"] = false,
			["USE_SHADOW"] = true,
			["USE_MONO"] = false,
		},

		["HEADER"] = {
			["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 0.4,
			["TR"] = 1, ["TG"] = 0.859, ["TB"] = 0.38, ["TO"] = 1,
			["useText"] = true, ["useBackground"] = true,
			["barTexture"] = "LiteStepLite",
			["textSize"] = 10,
		},
	},

	["TOOLTIP"] = {
		["show"] = true,
		["position"] = 2, -- Standard-Pos
		["inFight"] = false,
		["showBuffs"] = false,
		["x"] = 100,
		["y"] = -100,
		["point"] = "TOPLEFT",
		["relativePoint"] = "TOPLEFT",
		["SCALE"] = 1,

		["BACKGROUND"] = {
			["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 1,
			["useBackground"] = true, ["useOpacity"] = true,
		},

		["BORDER"] = {
			["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 1,
			["useBackground"] = true, ["useOpacity"] = true,
		},
	},

	["RAID_ICON"] = {
		["show"] = true,
		["scale"] = 1,
		["point"] = "TOP",
		["xAdjust"] = 0,
		["yAdjust"] = -20,
	},

	["OVERHEAL_TEXT"] = {
		["show"] = true,
		["scale"] = 1,
		["point"] = "LEFT",
		["xAdjust"] = 0,
		["yAdjust"] = 0,
	},

	["frameStrata"] = "MEDIUM",
}



--
function VUHDO_loadDefaultPanelSetup()
	local tPanelNum;
	local tAktPanel;

	if (VUHDO_PANEL_SETUP == nil) then
		VUHDO_PANEL_SETUP = VUHDO_decompressOrCopy(VUHDO_DEFAULT_PANEL_SETUP);
	end

	for tPanelNum = 1, 10 do -- VUHDO_MAX_PANELS
		if (VUHDO_PANEL_SETUP[tPanelNum] == nil) then
			VUHDO_PANEL_SETUP[tPanelNum] = VUHDO_decompressOrCopy(VUHDO_DEFAULT_PER_PANEL_SETUP);

			tAktPanel = VUHDO_PANEL_SETUP[tPanelNum];
			tAktPanel["MODEL"]["groups"] = VUHDO_DEFAULT_MODELS[tPanelNum];

			if (VUHDO_DEFAULT_MODELS[tPanelNum] ~= nil and VUHDO_ID_MAINTANKS == VUHDO_DEFAULT_MODELS[tPanelNum][1]) then
				tAktPanel["SCALING"]["barWidth"] = 100;
				tAktPanel["SCALING"]["barHeight"] = 26;
				tAktPanel["SCALING"]["showTarget"] = true;
			else
				if (VUHDO_DEFAULT_MODELS[tPanelNum] ~= nil and VUHDO_ID_PETS == VUHDO_DEFAULT_MODELS[tPanelNum][1]) then
					tAktPanel["MODEL"]["ordering"] = VUHDO_ORDERING_LOOSE;
				elseif (VUHDO_DEFAULT_MODELS[tPanelNum] ~= nil and VUHDO_ID_PRIVATE_TANKS == VUHDO_DEFAULT_MODELS[tPanelNum][1]) then
					tAktPanel["SCALING"]["showTarget"] = true;
				else
					tAktPanel["SCALING"]["ommitEmptyWhenStructured"] = true;
				end
			end

			if (GetLocale() == "zhCN" or GetLocale() == "zhTW" or GetLocale() == "koKR") then
				tAktPanel["PANEL_COLOR"]["TEXT"]["font"] = "";
				tAktPanel["PANEL_COLOR"]["HEADER"]["font"] = "";
			else
				tAktPanel["PANEL_COLOR"]["TEXT"]["font"] = VUHDO_LibSharedMedia:Fetch('font', "Emblem");
				tAktPanel["PANEL_COLOR"]["HEADER"]["font"] = VUHDO_LibSharedMedia:Fetch('font', "Emblem");
			end

			if (VUHDO_DEFAULT_MODELS[tPanelNum] ~= nil and VUHDO_ID_MAINTANKS == VUHDO_DEFAULT_MODELS[tPanelNum][1]) then
				tAktPanel["PANEL_COLOR"]["TEXT"]["textSize"] = 12;
			end
		end

		if (VUHDO_PANEL_SETUP[tPanelNum]["PANEL_COLOR"]["TEXT"]["USE_SHADOW"] == nil) then
			VUHDO_PANEL_SETUP[tPanelNum]["PANEL_COLOR"]["TEXT"]["USE_SHADOW"] = not VUHDO_PANEL_SETUP[tPanelNum]["PANEL_COLOR"]["TEXT"]["outline"];
		end
	end

	for tPanelNum = 1, 10 do -- VUHDO_MAX_PANELS
		if (VUHDO_PANEL_SETUP[tPanelNum]["POSITION"] == nil) then
			VUHDO_PANEL_SETUP[tPanelNum]["POSITION"] = {
				["x"] = 100 + 30 * tPanelNum,
				["y"] = 668 - 30 * tPanelNum,
				["relativePoint"] = "BOTTOMLEFT",
				["orientation"] = "TOPLEFT",
				["growth"] = "TOPLEFT",
				["width"] = 200,
				["height"] = 200,
				["scale"] = 1,
			};
		end

		VUHDO_PANEL_SETUP[tPanelNum] = VUHDO_ensureSanity("VUHDO_PANEL_SETUP[" .. tPanelNum .. "]", VUHDO_PANEL_SETUP[tPanelNum], VUHDO_DEFAULT_PER_PANEL_SETUP);
	end

	VUHDO_PANEL_SETUP = VUHDO_ensureSanity("VUHDO_PANEL_SETUP", VUHDO_PANEL_SETUP, VUHDO_DEFAULT_PANEL_SETUP);
	VUHDO_DEFAULT_PANEL_SETUP = VUHDO_compressTable(VUHDO_DEFAULT_PANEL_SETUP);
	VUHDO_DEFAULT_PER_PANEL_SETUP = VUHDO_compressTable(VUHDO_DEFAULT_PER_PANEL_SETUP);

	VUHDO_fixHotSettings();
end



local VUHDO_DEFAULT_BUFF_CONFIG = {
  ["VERSION"] = 3,
	["SHOW"] = true,
	["COMPACT"] = true,
	["SHOW_LABEL"] = false,
	["BAR_COLORS_TEXT"] = true,
	["BAR_COLORS_BACKGROUND"] = true,
	["BAR_COLORS_IN_FIGHT"] = false,
	["HIDE_CHARGES"] = false,
	["REFRESH_SECS"] = 1,
	["POSITION"] = {
		["x"] = 100,
		["y"] = -100,
		["point"] = "TOPLEFT",
		["relativePoint"] = "TOPLEFT",
	},
	["SCALE"] = 1,
	["PANEL_MAX_BUFFS"] = 5,
	["PANEL_BG_COLOR"] = {
		["R"] = 0, ["G"] = 0,	["B"] = 0, ["O"] = 0.5,
		["useText"] = false, ["useBackground"] = true, ["useOpacity"] = false,
	},
	["PANEL_BORDER_COLOR"] = {
		["R"] = 0, ["G"] = 0,	["B"] = 0, ["O"] = 0.5,
		["useText"] = false, ["useBackground"] = true, ["useOpacity"] = false,
	},
	["SWATCH_BG_COLOR"] = {
		["R"] = 0, ["G"] = 0,	["B"] = 0, ["O"] = 1,
		["useText"] = false, ["useBackground"] = true, ["useOpacity"] = false,
	},
	["SWATCH_BORDER_COLOR"] = {
		["R"] = 0.8, ["G"] = 0.8,	["B"] = 0.8, ["O"] = 0,
		["useText"] = false, ["useBackground"] = true, ["useOpacity"] = false,
	},
	["REBUFF_AT_PERCENT"] = 25,
	["REBUFF_MIN_MINUTES"] = 3,
	["HIGHLIGHT_COOLDOWN"] = true,
	["WHEEL_SMART_BUFF"] = false,
	["USE_COMBINED"] = true,

	["SWATCH_COLOR_BUFF_OKAY"] = {
		["R"] = 0, ["G"] = 0,	["B"] = 0,
		["TR"] = 0, ["TG"] = 0.8,	["TB"] = 0,
		["O"] = 1, ["TO"] = 1,
		["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
	},
	["SWATCH_COLOR_BUFF_LOW"] = {
		["R"] = 0, ["G"] = 0,	["B"] = 0,
		["TR"] = 1.0, ["TG"] = 0.7,	["TB"] = 0,
		["O"] = 1, ["TO"] = 1,
		["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
	},
	["SWATCH_COLOR_BUFF_OUT"] = {
		["R"] = 0, ["G"] = 0,	["B"] = 0,
		["TR"] = 0.8, ["TG"] = 0,	["TB"] = 0,
		["O"] = 1, ["TO"] = 1,
		["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
	},
	["SWATCH_COLOR_BUFF_COOLDOWN"] = {
		["R"] = 0.3, ["G"] = 0.3,	["B"] = 0.3,
		["TR"] = 0.6, ["TG"] = 0.6,	["TB"] = 0.6,
		["O"] = 1, ["TO"] = 1,
		["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
	},
}



VUHDO_DEFAULT_USER_CLASS_COLORS = {
	[VUHDO_ID_DRUIDS] =       { ["R"]  = 1,    ["G"]  = 0.49, ["B"]  = 0.04, ["O"] = 1, ["useBackground"] = true, ["useOpacity"] = true,
															["TR"] = 1,    ["TG"] = 0.6,  ["TB"] = 0.04, ["TO"] = 1, ["useText"] = true },

	[VUHDO_ID_HUNTERS] =      { ["R"]  = 0.67, ["G"]  = 0.83, ["B"]  = 0.45, ["O"] = 1, ["useBackground"] = true, ["useOpacity"] = true,
															["TR"] = 0.77, ["TG"] = 0.93, ["TB"] = 0.55, ["TO"] = 1, ["useText"] = true 	},

	[VUHDO_ID_MAGES] =        { ["R"]  = 0.41, ["G"]  = 0.8,  ["B"]  = 0.94, ["O"] = 1, ["useBackground"] = true, ["useOpacity"] = true,
															["TR"] = 0.51, ["TG"] = 0.9,  ["TB"] = 1,    ["TO"] = 1, ["useText"] = true  },

	[VUHDO_ID_PALADINS] =     { ["R"]  = 0.96, ["G"]  = 0.55, ["B"]  = 0.73, ["O"] = 1, ["useBackground"] = true, ["useOpacity"] = true,
															["TR"] = 1   , ["TG"] = 0.65, ["TB"] = 0.83, ["TO"] = 1, ["useText"] = true  },

	[VUHDO_ID_PRIESTS] =      { ["R"]  = 0.9,  ["G"]  = 0.9,  ["B"]  = 0.9,  ["O"] = 1, ["useBackground"] = true, ["useOpacity"] = true,
															["TR"] = 1,    ["TG"] = 1,    ["TB"] = 1,    ["TO"] = 1, ["useText"] = true  },

	[VUHDO_ID_ROGUES] =       { ["R"]  = 1,    ["G"]  = 0.96, ["B"]  = 0.41, ["O"] = 1, ["useBackground"] = true, ["useOpacity"] = true,
															["TR"] = 1,    ["TG"] = 1,    ["TB"] = 0.51, ["TO"] = 1, ["useText"] = true  },

	[VUHDO_ID_SHAMANS] =      { ["R"]  = 0.14, ["G"]  = 0.35, ["B"]  = 1,    ["O"] = 1, ["useBackground"] = true, ["useOpacity"] = true,
															["TR"] = 0.24, ["TG"] = 0.45, ["TB"] = 1,    ["TO"] = 1, ["useText"] = true  },

	[VUHDO_ID_WARLOCKS] =     { ["R"]  = 0.58, ["G"]  = 0.51, ["B"]  = 0.79, ["O"] = 1, ["useBackground"] = true, ["useOpacity"] = true,
															["TR"] = 0.68, ["TG"] = 0.61, ["TB"] = 0.89, ["TO"] = 1, ["useText"] = true  },

	[VUHDO_ID_WARRIORS] =     { ["R"]  = 0.78, ["G"]  = 0.61, ["B"]  = 0.43, ["O"] = 1, ["useBackground"] = true, ["useOpacity"] = true,
															["TR"] = 0.88, ["TG"] = 0.71, ["TB"] = 0.53, ["TO"] = 1, ["useText"] = true  },

	[VUHDO_ID_DEATH_KNIGHT] = { ["R"]  = 0.77, ["G"]  = 0.12, ["B"]  = 0.23, ["O"] = 1, ["useBackground"] = true, ["useOpacity"] = true,
															["TR"] = 0.87, ["TG"] = 0.22, ["TB"] = 0.33, ["TO"] = 1, ["useText"] = true  },

	[VUHDO_ID_PETS] =         { ["R"]  = 0.4,  ["G"]  = 0.6,  ["B"]  = 0.4,    ["O"] = 1, ["useBackground"] = true, ["useOpacity"] = true,
															["TR"] = 0.5,    ["TG"] = 0.9,    ["TB"] = 0.5,    ["TO"] = 1, ["useText"] = true  },

	["petClassColor"] = false,
}



--
function VUHDO_initClassColors()
	if (VUHDO_USER_CLASS_COLORS == nil) then
		VUHDO_USER_CLASS_COLORS = VUHDO_decompressOrCopy(VUHDO_DEFAULT_USER_CLASS_COLORS);
	end
	VUHDO_USER_CLASS_COLORS = VUHDO_ensureSanity("VUHDO_USER_CLASS_COLORS", VUHDO_USER_CLASS_COLORS, VUHDO_DEFAULT_USER_CLASS_COLORS);
	VUHDO_DEFAULT_USER_CLASS_COLORS = VUHDO_compressTable(VUHDO_DEFAULT_USER_CLASS_COLORS);
end



--
function VUHDO_initBuffSettings()
	if (VUHDO_BUFF_SETTINGS["CONFIG"] == nil) then
		VUHDO_BUFF_SETTINGS["CONFIG"] = VUHDO_decompressOrCopy(VUHDO_DEFAULT_BUFF_CONFIG);
	end
	VUHDO_BUFF_SETTINGS["CONFIG"] = VUHDO_ensureSanity("VUHDO_BUFF_SETTINGS.CONFIG", VUHDO_BUFF_SETTINGS["CONFIG"], VUHDO_DEFAULT_BUFF_CONFIG);
	VUHDO_DEFAULT_BUFF_CONFIG = VUHDO_compressTable(VUHDO_DEFAULT_BUFF_CONFIG);

	local _, tPlayerClass = UnitClass("player");
	local tAllClassBuffs = VUHDO_CLASS_BUFFS[tPlayerClass];
	local tCategSepc, tCategName;
	if (tAllClassBuffs ~= nil) then
		for tCategSpec, _ in pairs(tAllClassBuffs) do

			tCategName = strsub(tCategSpec, 3);

			if (VUHDO_BUFF_SETTINGS[tCategName] == nil) then
				VUHDO_BUFF_SETTINGS[tCategName] = {
					["enabled"] = false,
					["missingColor"] = {
						["show"] = false,
						["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
						["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
						["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					}
				};
			end

			if (VUHDO_BUFF_SETTINGS[tCategName]["filter"] == nil) then
				VUHDO_BUFF_SETTINGS[tCategName]["filter"] = { [VUHDO_ID_ALL] = true };
			end
		end
	end

	local tAllBuffs = VUHDO_CLASS_BUFFS[VUHDO_PLAYER_CLASS];
	if (tAllBuffs ~= nil) then
		local tCategoryName, tAllCategoryBuffs;
		for tCategoryName, tAllCategoryBuffs in pairs(tAllBuffs) do
			if (VUHDO_BUFF_ORDER[tCategoryName] == nil) then
				local tNumber = tonumber(strsub(tCategoryName, 1, 2));
				VUHDO_BUFF_ORDER[tCategoryName] = tNumber;
			end
		end
	end

end



--
--[[function VUHDO_initCompressTables()

	local tProfile, tLayout;
	for _, tProfile in pairs(VUHDO_PROFILES) do
		tProfile["CONFIG"] = VUHDO_compressTable(tProfile["CONFIG"]);
		tProfile["PANEL_SETUP"] = VUHDO_compressTable(tProfile["PANEL_SETUP"]);
		tProfile["POWER_TYPE_COLORS"] = VUHDO_compressTable(tProfile["POWER_TYPE_COLORS"]);
		tProfile["SPELL_CONFIG"] = VUHDO_compressTable(tProfile["SPELL_CONFIG"]);
		tProfile["BUFF_SETTINGS"] = VUHDO_compressTable(tProfile["BUFF_SETTINGS"]);
		tProfile["BUFF_ORDER"] = VUHDO_compressTable(tProfile["BUFF_ORDER"]);
		tProfile["INDICATOR_CONFIG"] = VUHDO_compressTable(tProfile["INDICATOR_CONFIG"]);
	end

	for _, tLayout in pairs(VUHDO_SPELL_LAYOUTS) do
		tLayout["MOUSE"] = VUHDO_compressTable(tLayout["MOUSE"]);
		tLayout["HOSTILE_MOUSE"] = VUHDO_compressTable(tLayout["HOSTILE_MOUSE"]);
		tLayout["KEYS"] = VUHDO_compressTable(tLayout["KEYS"]);
		tLayout["HOTS"] = VUHDO_compressTable(tLayout["HOTS"]);
	end
end
]]