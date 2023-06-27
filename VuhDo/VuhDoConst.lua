VUHDO_VERSION = GetAddOnMetadata("VuhDo", "Version");
VUHDO_MIN_TOC_VERSION = 40300;
VUHDO_COMMS_PREFIX = "VUHDO";

VUHDO_YES = 1;
VUHDO_NO = 2;

VUHDO_MAX_PANELS = 10;        -- Maximum number of Panels, change in VuhDoPanel.XML accordingly
--VUHDO_MAX_BUTTONS_PANEL = 51; -- Maximum Number of Buttons per Panel
--VUHDO_MAX_GROUPS_PER_PANEL = 15; -- Maximum number of Models (Groups) per Panel
--VUHDO_MAX_HEADERS_PER_PANEL = 15; -- Maximum number of Headers per Panel

--VUHDO_MAX_MTS = 8;

-- Heal panel operation modes
VUHDO_MODE_NEUTRAL = 1;  -- bar colors are gradient
VUHDO_MODE_EMERGENCY_PERC = 2; -- Top emergency mode, least life percent left (standard raid healing)
VUHDO_MODE_EMERGENCY_MOST_MISSING = 3; -- Top emergency mode, least most life missing (for spamming greater heals, MTs preffered)
VUHDO_MODE_EMERGENCY_LEAST_LEFT = 4; -- Top emergency mode, least life left (for raid healing when cyclic ae damage on whole raid)

-- Group model types
VUHDO_ID_TYPE_UNDEFINED = 0;
VUHDO_ID_TYPE_CLASS = 1;
VUHDO_ID_TYPE_GROUP = 2;
VUHDO_ID_TYPE_SPECIAL = 3;


-- Group Model IDs
VUHDO_ID_UNDEFINED = 0;

VUHDO_ID_GROUP_1 = 1;
VUHDO_ID_GROUP_2 = 2;
VUHDO_ID_GROUP_3 = 3;
VUHDO_ID_GROUP_4 = 4;
VUHDO_ID_GROUP_5 = 5;
VUHDO_ID_GROUP_6 = 6;
VUHDO_ID_GROUP_7 = 7;
VUHDO_ID_GROUP_8 = 8;

VUHDO_ID_GROUP_OWN = 10;

VUHDO_ID_WARRIORS = 20;
VUHDO_ID_ROGUES = 21;
VUHDO_ID_HUNTERS = 22;
VUHDO_ID_PALADINS = 23;
VUHDO_ID_MAGES = 24;
VUHDO_ID_WARLOCKS = 25;
VUHDO_ID_SHAMANS = 26;
VUHDO_ID_DRUIDS = 27;
VUHDO_ID_PRIESTS = 28;
VUHDO_ID_DEATH_KNIGHT = 29;

VUHDO_ID_PETS = 40;
VUHDO_ID_MAINTANKS = 41;
VUHDO_ID_PRIVATE_TANKS = 42;
VUHDO_ID_MAIN_ASSISTS = 43;

VUHDO_ID_MELEE = 50;
VUHDO_ID_RANGED = 51;

VUHDO_ID_MELEE_TANK = 60;
VUHDO_ID_MELEE_DAMAGE = 61;
VUHDO_ID_RANGED_DAMAGE = 62;
VUHDO_ID_RANGED_HEAL = 63;

VUHDO_ID_VEHICLES = 70;

VUHDO_ID_SELF = 80;
VUHDO_ID_SELF_PET = 81;

VUHDO_ID_ALL = 999;


--
-- Members of member types
--
VUHDO_ID_TYPE_MEMBERS = {

	[VUHDO_ID_TYPE_UNDEFINED] = {
		VUHDO_ID_UNDEFINED
	},

	[VUHDO_ID_TYPE_GROUP] = {
		VUHDO_ID_GROUP_1,
		VUHDO_ID_GROUP_2,
		VUHDO_ID_GROUP_3,
		VUHDO_ID_GROUP_4,
		VUHDO_ID_GROUP_5,
		VUHDO_ID_GROUP_6,
		VUHDO_ID_GROUP_7,
		VUHDO_ID_GROUP_8,
		VUHDO_ID_GROUP_OWN
	},

	[VUHDO_ID_TYPE_CLASS] = {
		VUHDO_ID_WARRIORS,
		VUHDO_ID_ROGUES,
		VUHDO_ID_HUNTERS,
		VUHDO_ID_PALADINS,
		VUHDO_ID_MAGES,
		VUHDO_ID_WARLOCKS,
		VUHDO_ID_SHAMANS,
		VUHDO_ID_DRUIDS,
		VUHDO_ID_PRIESTS,
		VUHDO_ID_DEATH_KNIGHT
	},

	[VUHDO_ID_TYPE_SPECIAL] = {
		VUHDO_ID_MAINTANKS,
		VUHDO_ID_MAIN_ASSISTS,
		VUHDO_ID_PRIVATE_TANKS,
		VUHDO_ID_PETS,
		VUHDO_ID_VEHICLES,
		VUHDO_ID_MELEE,
		VUHDO_ID_RANGED,
		VUHDO_ID_MELEE_TANK,
		VUHDO_ID_MELEE_DAMAGE,
		VUHDO_ID_RANGED_DAMAGE,
		VUHDO_ID_RANGED_HEAL,
		VUHDO_ID_SELF,
		VUHDO_ID_SELF_PET,
	},

	[VUHDO_ID_ALL] = {
	},
};




VUHDO_ID_MEMBER_TYPES = {
	[VUHDO_ID_UNDEFINED] = VUHDO_ID_TYPE_UNDEFINED,

	[VUHDO_ID_GROUP_1] = VUHDO_ID_TYPE_GROUP,
	[VUHDO_ID_GROUP_2] = VUHDO_ID_TYPE_GROUP,
	[VUHDO_ID_GROUP_3] = VUHDO_ID_TYPE_GROUP,
	[VUHDO_ID_GROUP_4] = VUHDO_ID_TYPE_GROUP,
	[VUHDO_ID_GROUP_5] = VUHDO_ID_TYPE_GROUP,
	[VUHDO_ID_GROUP_6] = VUHDO_ID_TYPE_GROUP,
	[VUHDO_ID_GROUP_7] = VUHDO_ID_TYPE_GROUP,
	[VUHDO_ID_GROUP_8] = VUHDO_ID_TYPE_GROUP,
	[VUHDO_ID_GROUP_OWN] = VUHDO_ID_TYPE_GROUP,

	[VUHDO_ID_WARRIORS] = VUHDO_ID_TYPE_CLASS,
	[VUHDO_ID_ROGUES] = VUHDO_ID_TYPE_CLASS,
	[VUHDO_ID_HUNTERS] = VUHDO_ID_TYPE_CLASS,
	[VUHDO_ID_PALADINS] = VUHDO_ID_TYPE_CLASS,
	[VUHDO_ID_MAGES] = VUHDO_ID_TYPE_CLASS,
	[VUHDO_ID_WARLOCKS] = VUHDO_ID_TYPE_CLASS,
	[VUHDO_ID_SHAMANS] = VUHDO_ID_TYPE_CLASS,
	[VUHDO_ID_DRUIDS] = VUHDO_ID_TYPE_CLASS,
	[VUHDO_ID_PRIESTS] = VUHDO_ID_TYPE_CLASS,
	[VUHDO_ID_DEATH_KNIGHT] = VUHDO_ID_TYPE_CLASS,
};



-- Flags for panel ordering type
VUHDO_ORDERING_STRICT = 0;
VUHDO_ORDERING_LOOSE = 1;



-- sorting criterions within panel
VUHDO_SORT_RAID_UNITID = 0;
VUHDO_SORT_RAID_NAME = 1;
VUHDO_SORT_RAID_CLASS = 2;
VUHDO_SORT_RAID_MAX_HP = 3;
VUHDO_SORT_RAID_MODELS = 4;
VUHDO_SORT_TA_DD_HL = 5;
VUHDO_SORT_TA_HL_DD = 6;
VUHDO_SORT_HL_TA_DD = 7;


-- Class IDs by class name
VUHDO_CLASS_IDS = {
	["WARRIOR"] = VUHDO_ID_WARRIORS,
	["ROGUE"] = VUHDO_ID_ROGUES,
	["HUNTER"] = VUHDO_ID_HUNTERS,
	["PALADIN"] = VUHDO_ID_PALADINS,
	["MAGE"] = VUHDO_ID_MAGES,
	["WARLOCK"] = VUHDO_ID_WARLOCKS,
	["SHAMAN"] = VUHDO_ID_SHAMANS,
	["DRUID"] = VUHDO_ID_DRUIDS,
	["PRIEST"] = VUHDO_ID_PRIESTS,
	["DEATHKNIGHT"] = VUHDO_ID_DEATH_KNIGHT,
};



-- Class names by class ID
VUHDO_ID_CLASSES = {
	[VUHDO_ID_WARRIORS] = "WARRIOR",
	[VUHDO_ID_ROGUES] = "ROGUE",
	[VUHDO_ID_HUNTERS] = "HUNTER",
	[VUHDO_ID_PALADINS] = "PALADIN",
	[VUHDO_ID_MAGES] = "MAGE",
	[VUHDO_ID_WARLOCKS] = "WARLOCK",
	[VUHDO_ID_SHAMANS] = "SHAMAN",
	[VUHDO_ID_DRUIDS] = "DRUID",
	[VUHDO_ID_PRIESTS] = "PRIEST",
	[VUHDO_ID_DEATH_KNIGHT] = "DEATHKNIGHT",
};



-- Class IDs by class name
--[[VUHDO_CLASS_NAMES_ORDERED = {
	"WARRIOR",
	"ROGUE",
	"HUNTER",
	"PALADIN",
	"MAGE",
	"WARLOCK",
	"SHAMAN",
	"DRUID",
	"PRIEST",
	"DEATHKNIGHT"
};]]



-- Action button assignent constant values
VUHDO_SPELL_KEY_ASSIST = "assist";
VUHDO_SPELL_KEY_FOCUS = "focus";
VUHDO_SPELL_KEY_TARGET = "target";
VUHDO_SPELL_KEY_MENU = "menu";
VUHDO_SPELL_KEY_TELL = "tell";
VUHDO_SPELL_KEY_DROPDOWN = "dropdown";



-- Types of updating unit status by event
VUHDO_UPDATE_ALL = 1;
VUHDO_UPDATE_HEALTH = 2;
VUHDO_UPDATE_HEALTH_MAX = 3;
VUHDO_UPDATE_DEBUFF = 4;
VUHDO_UPDATE_RANGE = 5;
VUHDO_UPDATE_AFK = 6;
VUHDO_UPDATE_AGGRO = 7;
VUHDO_UPDATE_TARGET = 8;
VUHDO_UPDATE_INC = 9;
VUHDO_UPDATE_ALIVE = 10;
VUHDO_UPDATE_EMERGENCY = 11;
-- nur für bouquets
VUHDO_UPDATE_MANA = 13;
VUHDO_UPDATE_THREAT_PERC = 14;
VUHDO_UPDATE_MOUSEOVER = 15;
VUHDO_UPDATE_NUM_CLUSTER = 16;
VUHDO_UPDATE_THREAT_LEVEL = 17;
VUHDO_UPDATE_MOUSEOVER_CLUSTER = 18;
VUHDO_UPDATE_DC = 19;
VUHDO_UPDATE_MOUSEOVER_GROUP = 20;
VUHDO_UPDATE_OTHER_POWERS = 21;
VUHDO_UPDATE_UNIT_TARGET = 22;
VUHDO_UPDATE_PLAYER_FOCUS = 23;
VUHDO_UPDATE_RAID_TARGET = 24;
VUHDO_UPDATE_RESURRECTION = 25;
VUHDO_UPDATE_PETS = 26;
VUHDO_UPDATE_PLAYER_TARGET = 27;
VUHDO_UPDATE_ROLE = 28;
VUHDO_UPDATE_CUSTOM_DEBUFF = 29;
VUHDO_UPDATE_ALT_POWER = 30;
VUHDO_UPDATE_OWN_HOLY_POWER = 31;
VUHDO_UPDATE_AOE_ADVICE = 32;
VUHDO_UPDATE_RAID_ROSTER = 33;
VUHDO_UPDATE_MINOR_FLAGS = 34;


-- Unit power types (== Blizzard defined types)
VUHDO_UNIT_POWER_MANA = 0;
VUHDO_UNIT_POWER_RAGE = 1;
VUHDO_UNIT_POWER_FOCUS = 2;
VUHDO_UNIT_POWER_ENERGY = 3;
VUHDO_UNIT_POWER_HAPPINESS = 4;
VUHDO_UNIT_POWER_RUNES = 6;



-- Resurection spells by class
VUHDO_RESURRECTION_SPELLS = {
	["PALADIN"] = { VUHDO_SPELL_ID.REDEMPTION },
	["SHAMAN"] = { VUHDO_SPELL_ID.ANCESTRAL_SPIRIT },
	["DRUID"] = { VUHDO_SPELL_ID.REVIVE, VUHDO_SPELL_ID.REBIRTH },
	["PRIEST"] = { VUHDO_SPELL_ID.RESURRECTION },
	["DEATHKNIGHT"] = { VUHDO_SPELL_ID.RAISE_ALLY },
};



VUHDO_LT_MODE_PERCENT = 1;
VUHDO_LT_MODE_LEFT = 2;
VUHDO_LT_MODE_MISSING = 3;



VUHDO_LT_POS_RIGHT = 1;
VUHDO_LT_POS_LEFT = 2;
VUHDO_LT_POS_ABOVE = 3;
VUHDO_LT_POS_BELOW = 4;


VUHDO_HEALING_HOTS = {
-- Priest
	[VUHDO_SPELL_ID.RENEW] = true,
	[VUHDO_SPELL_ID.PRAYER_OF_MENDING] = true,
	[VUHDO_SPELL_ID.POWERWORD_SHIELD] = true,
	[VUHDO_SPELL_ID.PAIN_SUPPRESSION] = true,
	[VUHDO_SPELL_ID.ECHO_OF_LIGHT] = true,
-- Druid
	[VUHDO_SPELL_ID.REJUVENATION] = true,
	[VUHDO_SPELL_ID.REGROWTH] = true,
	[VUHDO_SPELL_ID.LIFEBLOOM] = true,
	[VUHDO_SPELL_ID.WILD_GROWTH] = true,
-- Shaman
	[VUHDO_SPELL_ID.RIPTIDE] = true,
	[VUHDO_SPELL_ID.EARTHLIVING] = true,
	[VUHDO_SPELL_ID.GIFT_OF_THE_NAARU] = true,
-- Paladin
	[VUHDO_SPELL_ID.BUFF_BEACON_OF_LIGHT] = true,
	[VUHDO_SPELL_ID.FLASH_OF_LIGHT] = true,
-- Hunter
	[VUHDO_SPELL_ID.MEND_PET] = true,
};



--
VUHDO_EXCLUSIVE_HOTS = {
	[VUHDO_SPELL_ID.PRAYER_OF_MENDING] = true,
	[VUHDO_SPELL_ID.POWERWORD_SHIELD] = true,
	[VUHDO_SPELL_ID.BUFF_EARTH_SHIELD] = true,
	[VUHDO_SPELL_ID.GUARDIAN_SPIRIT] = true,
	[VUHDO_SPELL_ID.PAIN_SUPPRESSION] = true,
};



--
VUHDO_BUFF_REMOVAL_SPELLS = {
	[VUHDO_SPELL_ID.SPELLSTEAL] = true,
	[VUHDO_SPELL_ID.PURGE] = true,
	[VUHDO_SPELL_ID.DISPEL_MAGIC] = true,
	[VUHDO_SPELL_ID.CLEANSE_SPIRIT] = true,
	[VUHDO_SPELL_ID.CYCLONE] = true,
	[VUHDO_SPELL_ID.REMOVE_CORRUPTION] = true,
	[VUHDO_SPELL_ID.WIND_SHEAR] = true,
};



VUHDO_MIN_MAX_CONSTRAINTS = 1;
VUHDO_ENUMERATOR_CONSTRAINTS = 2;
VUHDO_BOOLEAN_CONSTRAINTS = 3;


VUHDO_NUM_MOUSE_BUTTONS = 16;
VUHDO_NUM_KEYBOARD_KEYS = 16;
VUHDO_MODIFIER_KEYS_LOW = {
	[""] = "",
	["alt"] = "alt-",
	["ctrl"] = "ctrl-",
	["shift"] = "shift-",
	["altctrl"] = "alt-ctrl-",
	["altshift"] = "alt-shift-",
	["ctrlshift"] = "ctrl-shift-",
	["altctrlshift"] = "alt-ctrl-shift-",
};



VUHDO_MOUSE_BUTTONS = {
	VUHDO_I18N_TT_LEFT,
	VUHDO_I18N_TT_RIGHT,
	VUHDO_I18N_TT_MIDDLE,
	VUHDO_I18N_TT_BTN_4,
	VUHDO_I18N_TT_BTN_5,
	VUHDO_I18N_TT_WHEEL_UP,
	VUHDO_I18N_TT_WHEEL_DOWN,
};



VUHDO_WHEEL_BINDINGS = {
	"MOUSEWHEELUP",
	"MOUSEWHEELDOWN",
	"ALT-MOUSEWHEELUP",
	"ALT-MOUSEWHEELDOWN",
	"CTRL-MOUSEWHEELUP",
	"CTRL-MOUSEWHEELDOWN",
	"SHIFT-MOUSEWHEELUP",
	"SHIFT-MOUSEWHEELDOWN",
	"ALT-CTRL-MOUSEWHEELUP",
	"ALT-CTRL-MOUSEWHEELDOWN",
	"ALT-SHIFT-MOUSEWHEELUP",
	"ALT-SHIFT-MOUSEWHEELDOWN",
	"CTRL-SHIFT-MOUSEWHEELUP",
	"CTRL-SHIFT-MOUSEWHEELDOWN",
	"ALT-CTRL-SHIFT-MOUSEWHEELUP",
	"ALT-CTRL-SHIFT-MOUSEWHEELDOWN",
};


VUHDO_WHEEL_INDEX_BINDING = {
	"1",
	"2",
	"alt1",
	"alt2",
	"ctrl1",
	"ctrl2",
	"shift1",
	"shift2",
	"altctrl1",
	"altctrl2",
	"altshift1",
	"altshift2",
	"ctrlshift1",
	"ctrlshift2",
	"altctrlshift1",
	"altctrlshift2",
}


VUHDO_ASSIGNMENT_SPELL = 1;
VUHDO_ASSIGNMENT_MACRO_TEXT = 2;
VUHDO_ASSIGNMENT_MACRO_ID = 3;


VUHDO_PET_2_OWNER = {
	["pet"] = "player",

	["partypet1"] = "party1",
	["partypet2"] = "party2",
	["partypet3"] = "party3",
	["partypet4"] = "party4",
	["partypet5"] = "party5",

	["raidpet1"] = "raid1",
	["raidpet2"] = "raid2",
	["raidpet3"] = "raid3",
	["raidpet4"] = "raid4",
	["raidpet5"] = "raid5",
	["raidpet6"] = "raid6",
	["raidpet7"] = "raid7",
	["raidpet8"] = "raid8",
	["raidpet9"] = "raid9",
	["raidpet10"] = "raid10",

	["raidpet11"] = "raid11",
	["raidpet12"] = "raid12",
	["raidpet13"] = "raid13",
	["raidpet14"] = "raid14",
	["raidpet15"] = "raid15",
	["raidpet16"] = "raid16",
	["raidpet17"] = "raid17",
	["raidpet18"] = "raid18",
	["raidpet19"] = "raid19",
	["raidpet20"] = "raid20",

	["raidpet21"] = "raid21",
	["raidpet22"] = "raid22",
	["raidpet23"] = "raid23",
	["raidpet24"] = "raid24",
	["raidpet25"] = "raid25",
	["raidpet26"] = "raid26",
	["raidpet27"] = "raid27",
	["raidpet28"] = "raid28",
	["raidpet29"] = "raid29",
	["raidpet30"] = "raid30",

	["raidpet31"] = "raid31",
	["raidpet32"] = "raid32",
	["raidpet33"] = "raid33",
	["raidpet34"] = "raid34",
	["raidpet35"] = "raid35",
	["raidpet36"] = "raid36",
	["raidpet37"] = "raid37",
	["raidpet38"] = "raid38",
	["raidpet39"] = "raid39",
	["raidpet40"] = "raid40",
};



VUHDO_OWNER_2_PET = {
	["player"] = "pet",

	["party1"] = "partypet1",
	["party2"] = "partypet2",
	["party3"] = "partypet3",
	["party4"] = "partypet4",
	["party5"] = "partypet5",

	["raid1"] = "raidpet1",
	["raid2"] = "raidpet2",
	["raid3"] = "raidpet3",
	["raid4"] = "raidpet4",
	["raid5"] = "raidpet5",
	["raid6"] = "raidpet6",
	["raid7"] = "raidpet7",
	["raid8"] = "raidpet8",
	["raid9"] = "raidpet9",
	["raid10"] = "raidpet10",

	["raid11"] = "raidpet11",
	["raid12"] = "raidpet12",
	["raid13"] = "raidpet13",
	["raid14"] = "raidpet14",
	["raid15"] = "raidpet15",
	["raid16"] = "raidpet16",
	["raid17"] = "raidpet17",
	["raid18"] = "raidpet18",
	["raid19"] = "raidpet19",
	["raid20"] = "raidpet20",

	["raid21"] = "raidpet21",
	["raid22"] = "raidpet22",
	["raid23"] = "raidpet23",
	["raid24"] = "raidpet24",
	["raid25"] = "raidpet25",
	["raid26"] = "raidpet26",
	["raid27"] = "raidpet27",
	["raid28"] = "raidpet28",
	["raid29"] = "raidpet29",
	["raid30"] = "raidpet30",

	["raid31"] = "raidpet31",
	["raid32"] = "raidpet32",
	["raid33"] = "raidpet33",
	["raid34"] = "raidpet34",
	["raid35"] = "raidpet35",
	["raid36"] = "raidpet36",
	["raid37"] = "raidpet37",
	["raid38"] = "raidpet38",
	["raid39"] = "raidpet39",
	["raid40"] = "raidpet40",
};
