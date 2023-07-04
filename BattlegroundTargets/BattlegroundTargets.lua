-- -------------------------------------------------------------------------- --
-- BattlegroundTargets by kunda                                               --
-- -------------------------------------------------------------------------- --
--                                                                            --
-- BattlegroundTargets is a 'Enemy Unit Frame' for battlegrounds.             --
-- BattlegroundTargets is not a 'real' (Enemy) Unit Frame.                    --
-- BattlegroundTargets simply generates buttons with target macros.           --
--                                                                            --
-- Features:                                                                  --
-- # Shows all battleground enemies with role, class and name.                --
--   - Left-click : set target                                                --
--   - Right-click: set focus                                                 --
-- # Independent settings for '10 vs 10', '15 vs 15' and '40 vs 40'.          --
-- # Specialization                                                           --
-- # Target                                                                   --
-- # Main Assist Target                                                       --
-- # Focus                                                                    --
-- # Enemy Flag Carrier                                                       --
-- # Target Count                                                             --
-- # Health                                                                   --
-- # Range Check                                                              --
-- # Guild Groups                                                             --
--                                                                            --
-- -------------------------------------------------------------------------- --
--                                                                            --
-- These events are always registered:                                        --
-- - PLAYER_REGEN_DISABLED                                                    --
-- - PLAYER_REGEN_ENABLED                                                     --
-- - ZONE_CHANGED_NEW_AREA (to determine if current zone is a battleground)   --
-- - PLAYER_LEVEL_UP (only registered if player level < level cap)            --
--                                                                            --
-- In Battleground:                                                           --
-- # If enabled: ------------------------------------------------------------ --
--   - UPDATE_BATTLEFIELD_SCORE                                               --
--   - PLAYER_DEAD                                                            --
--   - PLAYER_UNGHOST                                                         --
--   - PLAYER_ALIVE                                                           --
--                                                                            --
-- # Range Check: --------------------------------------- VERY HIGH CPU USAGE --
--   - Events:                                                                --
--        1) Combat Log: --- COMBAT_LOG_EVENT_UNFILTERED                      --
--        2) Class: -------- PLAYER_TARGET_CHANGED                            --
--                         - UNIT_HEALTH_FREQUENT                             --
--                         - UPDATE_MOUSEOVER_UNIT                            --
--                         - UNIT_TARGET                                      --
--      3/4) Mix: ---------- COMBAT_LOG_EVENT_UNFILTERED                      --
--                         - PLAYER_TARGET_CHANGED                            --
--                         - UNIT_HEALTH_FREQUENT                             --
--                         - UPDATE_MOUSEOVER_UNIT                            --
--                         - UNIT_TARGET                                      --
--   - The data to determine the distance to an enemy is not always available.--
--     This is restricted by the WoW API.                                     --
--   - This feature is a compromise between CPU usage (FPS), lag/network      --
--     bandwidth (no SendAdd0nMessage), fast and easy visual recognition and  --
--     suitable data.                                                         --
--                                                                            --
-- # Health: ------------------------------------------------- HIGH CPU USAGE --
--   - Events:             - UNIT_TARGET                                      --
--                         - UNIT_HEALTH_FREQUENT                             --
--                         - UPDATE_MOUSEOVER_UNIT                            --
--   - The health from an enemy is not always available.                      --
--     This is restricted by the WoW API.                                     --
--   - A raidmember/raidpet MUST target(focus/mouseover) an enemy OR          --
--     you/yourpet MUST target/focus/mouseover an enemy to get the health.    --
--                                                                            --
-- # Target Count: ------------------------------------ HIGH MEDIUM CPU USAGE --
--   - Event:              - UNIT_TARGET                                      --
--                                                                            --
-- # Guild Groups: ----------------------------------------- MEDIUM CPU USAGE --
--   - Events:             - RAID_ROSTER_UPDATE                               --
--                         - UNIT_TARGET                                      --
--                                                                            --
-- # Main Assist Target: ------------------------------- LOW MEDIUM CPU USAGE --
--   - Events:             - RAID_ROSTER_UPDATE                               --
--                         - UNIT_TARGET                                      --
--                                                                            --
-- # Leader: ------------------------------------------- LOW MEDIUM CPU USAGE --
--   - Event:              - UNIT_TARGET                                      --
--                                                                            --
-- # Level: (only if player level < level cap) ---------------- LOW CPU USAGE --
--   - Event:              - UNIT_TARGET                                      --
--                                                                            --
-- # Target: -------------------------------------------------- LOW CPU USAGE --
--   - Event:              - PLAYER_TARGET_CHANGED                            --
--                                                                            --
-- # Focus: --------------------------------------------------- LOW CPU USAGE --
--   - Event:              - PLAYER_FOCUS_CHANGED                             --
--                                                                            --
-- # Enemy Flag Carrier: --------------------------------- VERY LOW CPU USAGE --
--   - Events:             - CHAT_MSG_BG_SYSTEM_HORDE                         --
--                         - CHAT_MSG_BG_SYSTEM_ALLIANCE                      --
--                         - CHAT_MSG_BG_SYSTEM_NEUTRAL                       --
--   Flag detection in case of disconnect, UI reload or mid-battle-joins:     --
--   (temporarily registered until each enemy is scanned)                     --
--                         - UNIT_TARGET                                      --
--                         - UPDATE_MOUSEOVER_UNIT                            --
--                         - PLAYER_TARGET_CHANGED                            --
--                                                                            --
-- # No SendAdd0nMessage(): ------------------------------------------------- --
--   This AddOn does not use/need SendAdd0nMessage(). SendAdd0nMessage()      --
--   increases the available data by transmitting information to other        --
--   players. This has certain pros and cons. I may include (opt-in) such     --
--   functionality in some future release. maybe. dontknow.                   --
--                                                                            --
-- -------------------------------------------------------------------------- --
--                                                                            --
-- slash commands: /bgt - /bgtargets - /battlegroundtargets                   --
--                                                                            --
-- -------------------------------------------------------------------------- --
--                                                                            --
-- Thanks to all who helped with the localization.                            --
--                                                                            --
-- Special thanks to Roma.                                                    --
--                                                                            --
-- -------------------------------------------------------------------------- --

-- ---------------------------------------------------------------------------------------------------------------------
BattlegroundTargets_Options = {} -- SavedVariable options table
local BattlegroundTargets = CreateFrame("Frame") -- container

local L   = BattlegroundTargets_Localization -- localization table
local TLT = BattlegroundTargets_Talents      -- localized talents
local BGN = BattlegroundTargets_BGNames      -- localized battleground names
local FLG = BattlegroundTargets_Flag         -- localized flag picked/dropped/captured/debuff
local RNA = BattlegroundTargets_RaceNames    -- localized race names

local GVAR = {}     -- UI Widgets
local TEMPLATE = {} -- Templates
local OPT = {}      -- local SavedVariable table (BattlegroundTargets_Options.Button*)

local AddonIcon = "Interface\\AddOns\\BattlegroundTargets\\BattlegroundTargets-texture-button"

local _, _, _, tocversion = GetBuildInfo() -- TODO_MoP
local RosterUpdate = "GROUP_ROSTER_UPDATE" if tocversion < 50000 then RosterUpdate = "RAID_ROSTER_UPDATE" end -- TODO_MoP

local _G                         = _G
local GetTime                    = _G.GetTime
local InCombatLockdown           = _G.InCombatLockdown
local IsInInstance               = _G.IsInInstance
local IsRatedBattleground        = _G.IsRatedBattleground
local GetBattlefieldArenaFaction = _G.GetBattlefieldArenaFaction
local GetRealZoneText            = _G.GetRealZoneText
local GetMaxBattlefieldID        = _G.GetMaxBattlefieldID
local GetBattlefieldStatus       = _G.GetBattlefieldStatus
local GetNumBattlefieldScores    = _G.GetNumBattlefieldScores
local GetBattlefieldScore        = _G.GetBattlefieldScore
local SetBattlefieldScoreFaction = _G.SetBattlefieldScoreFaction
local UnitName                   = _G.UnitName
local UnitLevel                  = _G.UnitLevel
local UnitHealthMax              = _G.UnitHealthMax
local UnitHealth                 = _G.UnitHealth
local UnitIsGroupLeader          = _G.UnitIsGroupLeader if tocversion < 50000 then UnitIsGroupLeader = _G.UnitIsPartyLeader end -- TODO_MoP
local UnitBuff                   = _G.UnitBuff
local UnitDebuff                 = _G.UnitDebuff
local UnitIsVisible              = _G.UnitIsVisible -- TODO_MoP - U.nitIsVisible is no longer necessary, needs check
local GetSpellInfo               = _G.GetSpellInfo
local IsSpellInRange             = _G.IsSpellInRange
local CheckInteractDistance      = _G.CheckInteractDistance
local GetNumGroupMembers         = _G.GetNumGroupMembers if tocversion < 50000 then GetNumGroupMembers = _G.GetNumRaidMembers end -- TODO_MoP
local GetRaidRosterInfo          = _G.GetRaidRosterInfo
local math_min                   = _G.math.min
local math_max                   = _G.math.max
local math_floor                 = _G.math.floor
local math_random                = _G.math.random
local string_find                = _G.string.find
local string_match               = _G.string.match
local string_format              = _G.string.format
local table_sort                 = _G.table.sort
local table_wipe                 = _G.table.wipe
local pairs                      = _G.pairs
local tonumber                   = _G.tonumber

local inWorld
local inBattleground
local inCombat
local reCheckBG
local reCheckScore
local reSizeCheck = 0 -- check bgname if normal bgname check fails (reason: sometimes GetBattlefieldStatus and GetRealZoneText returns nil)
local reSetLayout
local isConfig
local testDataLoaded
local isTarget = 0
local hasFlag
local isDeadUpdateStop
local isLeader
local isAssistName
local isAssistUnitId
local rangeSpellName, rangeMin, rangeMax -- for class-spell based range check
local flagDebuff = 0
local flags = 0
local isFlagBG = 0
local flagCHK
local flagflag
local groupMembers = 0
local groupMemChk = 0

-- THROTTLE (reduce CPU usage) -----------------------------------------------------------------------------------------
local scoreUpdateThrottle  = GetTime()      -- scoreupdate: B.attlefieldScoreUpdate()
local scoreUpdateFrequency = 1              -- scoreupdate: 0-20 updates = 1 second | 21+ updates = 5 seconds
local scoreUpdateCount     = 0              -- scoreupdate: (reason: later score updates are less relevant and 5 seconds is still very high)
local range_SPELL_Frequency     = 0.2       -- rangecheck: [class-spell]: the 0.2 second freq is per enemy (variable: ENEMY_Name2Range[enemyname])
local range_CL_Throttle         = 0         -- rangecheck: [combatlog] C.ombatLogRangeCheck()
local range_CL_Frequency        = 3         -- rangecheck: [combatlog] 50/50 or 66/33 or 75/25 (%Yes/%No) => 64/36 = 36% combatlog messages filtered (36% vs overhead: two variables, one addition, one number comparison and if filtered one math_random)
local range_CL_DisplayThrottle  = GetTime() -- rangecheck: [combatlog] display update
local range_CL_DisplayFrequency = 0.33      -- rangecheck: [combatlog] display update
local leaderThrottle  = 0                   -- leader: C.heckUnitTarget()
local leaderFrequency = 5                   -- leader: if isLeader is true then pause 5 times(events) until next check (reason: leader does not change often in a bg, irrelevant info anyway)
-- FORCE UPDATE (precise results) --------------------------------------------------------------------------------------
local assistForceUpdate = GetTime()         -- assist: C.heckUnitTarget()
local assistFrequency   = 0.5               -- assist: immediate assist target check (reason: target loss and I don't know why... -> brute force)
local targetCountForceUpdate = GetTime()    -- targetcount: C.heckUnitTarget()
local targetCountFrequency   = 30           -- targetcount: a complete raid/raidtarget check every 30 seconds (reason: target loss and I don't know why... -> brute force)
-- WARNING -------------------------------------------------------------------------------------------------------------
local latestScoreUpdate  = GetTime()        -- scoreupdate: B.attlefieldScoreUpdate()
local latestScoreWarning = 60               -- scoreupdate: inCombat-warning icon if latest score update is >= 60 seconds
-- MISC ----------------------------------------------------------------------------------------------------------------
local range_DisappearTime = 8               -- rangecheck: display update - clears range display if an enemy was not seen for 8 seconds

local playerLevel = UnitLevel("player") -- LVLCHK
local isLowLevel
local maxLevel = 90 if tocversion < 50000 then maxLevel = 85 end -- TODO_MoP

local playerName = UnitName("player")
local playerClass, playerClassEN = UnitClass("player")
local targetName, targetRealm
local focusName, focusRealm
local assistTargetName, assistTargetRealm

local playerFactionDEF   = 0 -- player faction (DEFAULT)
local oppositeFactionDEF = 0 -- opposite faction (DEFAULT)
local playerFactionBG    = 0 -- player faction (in battleground)
local oppositeFactionBG  = 0 -- opposite faction (in battleground)
local oppositeFactionREAL    -- real opposite faction

--local eventTest = {} -- TEST event order

local ENEMY_Data = {}           -- numerical | all data
local ENEMY_Names = {}          -- key/value | key = enemyName, value = count
local ENEMY_Names4Flag = {}     -- key/value | key = enemyName without realm, value = button number
local ENEMY_Name2Button = {}    -- key/value | key = enemyName, value = button number
local ENEMY_Name2Percent = {}   -- key/value | key = enemyName, value = health in percent
local ENEMY_Name2Range = {}     -- key/value | key = enemyName, value = time of last contact
local ENEMY_Name2Level = {}     -- key/value | key = enemyName, value = level
local ENEMY_FirstFlagCheck = {} -- key/value | key = enemyName, value = 1
local ENEMY_Guild = {}          -- key/value | key = enemyName, value = guild name
local ENEMY_GuildCount = {}     -- key/value | key = guildName, value = number of guild members
local ENEMY_GroupNum = {}       -- key/value | key = enemyName, value = number of guild group
local FRIEND_Names = {}         -- key/value | key = friendName, value = 1
local FRIEND_GuildCount = {}    -- key/value | key = guildName, value = number of guild members
local FRIEND_GuildName = {}     -- key/value | key = friendName, value = 1
local TARGET_Names = {}         -- key/value | key = friendName, value = enemyName
local SPELL_Range = {}          -- key/value | key = spellId, value = maxRange

local ENEMY_Roles = {0,0,0,0}
local FRIEND_Roles = {0,0,0,0}

local testSize = 10
local testIcon1 = 2
local testIcon2 = 5
local testIcon3 = 3
local testIcon4 = 4
local testHealth = {}
local testRange = {}
local testLeader = 4
local testGroupNum = {}

local healthBarWidth = 0.01

local sizeOffset    = 5
local sizeBarHeight = 14

local fontPath = _G["GameFontNormal"]:GetFont()

local currentSize = 10
local bgSize = {
	["Alterac Valley"] = 40,
	["Warsong Gulch"] = 10,
	["Arathi Basin"] = 15,
	["Eye of the Storm"] = 15,
	["Strand of the Ancients"] = 15,
	["Isle of Conquest"] = 40,
	["The Battle for Gilneas"] = 10,
	["Twin Peaks"] = 10,
}

local bgSizeINT = {
	[1] = 10,
	[2] = 15,
	[3] = 40,
}

local flagBG = {
	["Warsong Gulch"] = 1,
	["Eye of the Storm"] = 2,
	["Twin Peaks"] = 3,
}

local flagIDs = {
	 [23333] = 1, -- Horde Flag
	 [23335] = 1, -- Alliance Flag
	 [34976] = 1, -- Netherstorm Flag
	[100196] = 1, -- Netherstorm Flag?
}

local debuffIDs = {
	[46392] = 1, -- Focused Assault
	[46393] = 1, -- Brutal Assault
}

local sortBy = {
	[1] = ROLE.." / "..CLASS.."* / "..NAME,
	[2] = ROLE.." / "..NAME,
	[3] = CLASS.."* / "..ROLE.." / "..NAME,
	[4] = CLASS.."* / "..NAME,
	[5] = NAME,
}

local locale = GetLocale()
local sortDetail = {
	[1] = "*"..CLASS.." ("..locale..")",
	[2] = "*"..CLASS.." (english)",
	[3] = "*"..CLASS.." (Blizzard)",
}

local classcolors = {}
for class, color in pairs(RAID_CLASS_COLORS) do -- Constants.lua
	classcolors[class] = {r = color.r, g = color.g, b = color.b}
end

-- texture: Interface\\WorldStateFrame\\Icons-Classes
-- coords : 2 62 66 126 130 190 194 254
-- role   : 1 = HEAL | 2 = TANK | 3 = DAMAGE | 4 = UNKNOWN
local classes = {
	DEATHKNIGHT = {coords = {0.25781250, 0.49218750, 0.50781250, 0.74218750}, -- ( 66/256, 126/256, 130/256, 190/256)
	               spec   = {[1] = {role = 2, icon = "Interface\\Icons\\Spell_Deathknight_BloodPresence"},    -- Blood
	                         [2] = {role = 3, icon = "Interface\\Icons\\Spell_Deathknight_FrostPresence"},    -- Frost
	                         [3] = {role = 3, icon = "Interface\\Icons\\Spell_Deathknight_UnholyPresence"},   -- Unholy
	                         [4] = {role = 4, icon = nil}}},
	DRUID       = {coords = {0.75781250, 0.99218750, 0.00781250, 0.24218750}, -- (194/256, 254/256,   2/256,  62/256)
	               spec   = {[1] = {role = 3, icon = "Interface\\Icons\\Spell_Nature_StarFall"},              -- Balance
	                         [2] = {role = 2, icon = "Interface\\Icons\\Ability_Racial_BearForm"},            -- Feral Combat
	                         [3] = {role = 1, icon = "Interface\\Icons\\Spell_Nature_HealingTouch"},          -- Restoration
	                         [4] = {role = 4, icon = nil}}},
	HUNTER      = {coords = {0.00781250, 0.24218750, 0.25781250, 0.49218750}, -- (  2/256,  62/256,  66/256, 126/256)
	               spec   = {[1] = {role = 3, icon = "Interface\\Icons\\Ability_Hunter_BestialDiscipline"},   -- Beast Mastery
	                         [2] = {role = 3, icon = "Interface\\Icons\\Ability_Hunter_FocusedAim"},          -- Marksmanship
	                         [3] = {role = 3, icon = "Interface\\Icons\\Ability_Hunter_Camouflage"},          -- Survival
	                         [4] = {role = 4, icon = nil}}},
	MAGE        = {coords = {0.25781250, 0.49218750, 0.00781250, 0.24218750}, -- ( 66/256, 126/256,   2/256,  62/256)
	               spec   = {[1] = {role = 3, icon = "Interface\\Icons\\Spell_Holy_MagicalSentry"},           -- Arcane
	                         [2] = {role = 3, icon = "Interface\\Icons\\Spell_Fire_FireBolt02"},              -- Fire
	                         [3] = {role = 3, icon = "Interface\\Icons\\Spell_Frost_FrostBolt02"},            -- Frost
	                         [4] = {role = 4, icon = nil}}},
	MONK        = {coords = {0.50781250, 0.74218750, 0.50781250, 0.74218750}, -- (130/256, 190/256, 130/256, 190/256) -- TODO_MoP
	               spec   = {[1] = {role = 2, icon = "Interface\\Icons\\Spell_Monk_Brewmaster_Spec"},         -- Brewmaster
	                         [2] = {role = 1, icon = "Interface\\Icons\\Spell_Monk_Mistweaver_Spec"},         -- Mistweaver
	                         [3] = {role = 3, icon = "Interface\\Icons\\Spell_Monk_Windwalker_Spec"},         -- Windwalker
	                         [4] = {role = 4, icon = nil}}},
	PALADIN     = {coords = {0.00781250, 0.24218750, 0.50781250, 0.74218750}, -- (  2/256,  62/256, 130/256, 190/256)
	               spec   = {[1] = {role = 1, icon = "Interface\\Icons\\Spell_Holy_HolyBolt"},                -- Holy
	                         [2] = {role = 2, icon = "Interface\\Icons\\Ability_Paladin_ShieldoftheTemplar"}, -- Protection
	                         [3] = {role = 3, icon = "Interface\\Icons\\Spell_Holy_AuraOfLight"},             -- Retribution
	                         [4] = {role = 4, icon = nil}}},
	PRIEST      = {coords = {0.50781250, 0.74218750, 0.25781250, 0.49218750}, -- (130/256, 190/256,  66/256, 126/256)
	               spec   = {[1] = {role = 1, icon = "Interface\\Icons\\Spell_Holy_PowerWordShield"},         -- Discipline
	                         [2] = {role = 1, icon = "Interface\\Icons\\Spell_Holy_GuardianSpirit"},          -- Holy
	                         [3] = {role = 3, icon = "Interface\\Icons\\Spell_Shadow_ShadowWordPain"},        -- Shadow
	                         [4] = {role = 4, icon = nil}}},
	ROGUE       = {coords = {0.50781250, 0.74218750, 0.00781250, 0.24218750}, -- (130/256, 190/256,   2/256,  62/256)
	               spec   = {[1] = {role = 3, icon = "Interface\\Icons\\Ability_Rogue_Eviscerate"},           -- Assassination
	                         [2] = {role = 3, icon = "Interface\\Icons\\Ability_BackStab"},                   -- Combat
	                         [3] = {role = 3, icon = "Interface\\Icons\\Ability_Stealth"},                    -- Subtlety
	                         [4] = {role = 4, icon = nil}}},
	SHAMAN      = {coords = {0.25781250, 0.49218750, 0.25781250, 0.49218750}, -- ( 66/256, 126/256,  66/256, 126/256)
	               spec   = {[1] = {role = 3, icon = "Interface\\Icons\\Spell_Nature_Lightning"},             -- Elemental
	                         [2] = {role = 3, icon = "Interface\\Icons\\Spell_Nature_LightningShield"},       -- Enhancement
	                         [3] = {role = 1, icon = "Interface\\Icons\\Spell_Nature_MagicImmunity"},         -- Restoration
	                         [4] = {role = 4, icon = nil}}},
	WARLOCK     = {coords = {0.75781250, 0.99218750, 0.25781250, 0.49218750}, -- (194/256, 254/256,  66/256, 126/256)
	               spec   = {[1] = {role = 3, icon = "Interface\\Icons\\Spell_Shadow_DeathCoil"},             -- Affliction
	                         [2] = {role = 3, icon = "Interface\\Icons\\Spell_Shadow_Metamorphosis"},         -- Demonology
	                         [3] = {role = 3, icon = "Interface\\Icons\\Spell_Shadow_RainOfFire"},            -- Destruction
	                         [4] = {role = 4, icon = nil}}},
	WARRIOR     = {coords = {0.00781250, 0.24218750, 0.00781250, 0.24218750}, -- (  2/256,  62/256,   2/256,  62/256)
	               spec   = {[1] = {role = 3, icon = "Interface\\Icons\\Ability_Warrior_SavageBlow"},         -- Arms
	                         [2] = {role = 3, icon = "Interface\\Icons\\Ability_Warrior_InnerRage"},          -- Fury
	                         [3] = {role = 2, icon = "Interface\\Icons\\Ability_Warrior_DefensiveStance"},    -- Protection
	                         [4] = {role = 4, icon = nil}}},
	ZZZFAILURE  = {coords = {0, 0, 0, 0},
	               spec   = {[1] = {role = 4, icon = nil},   -- unknown
	                         [2] = {role = 4, icon = nil},   -- unknown
	                         [3] = {role = 4, icon = nil},   -- unknown
	                         [4] = {role = 4, icon = nil}}}, -- unknown
}

local class_LocaSort = {}
FillLocalizedClassList(class_LocaSort, false) -- Constants.lua

local class_BlizzSort = {}
for i = 1, #CLASS_SORT_ORDER do -- Constants.lua
	class_BlizzSort[ CLASS_SORT_ORDER[i] ] = i
end

local class_IntegerSort = { -- .cid .blizz .eng .loc
 [1] = {cid = "DEATHKNIGHT", blizz = class_BlizzSort.DEATHKNIGHT or  2, eng = "Death Knight", loc = class_LocaSort.DEATHKNIGHT or "Death Knight"},
 [2] = {cid = "DRUID",       blizz = class_BlizzSort.DRUID       or  7, eng = "Druid",        loc = class_LocaSort.DRUID or "Druid"},
 [3] = {cid = "HUNTER",      blizz = class_BlizzSort.HUNTER      or 11, eng = "Hunter",       loc = class_LocaSort.HUNTER or "Hunter"},
 [4] = {cid = "MAGE",        blizz = class_BlizzSort.MAGE        or  9, eng = "Mage",         loc = class_LocaSort.MAGE or "Mage"},
 [5] = {cid = "MONK",        blizz = class_BlizzSort.MONK        or  4, eng = "Monk",         loc = class_LocaSort.MONK or "Monk"}, -- TODO_MoP
 [6] = {cid = "PALADIN",     blizz = class_BlizzSort.PALADIN     or  3, eng = "Paladin",      loc = class_LocaSort.PALADIN or "Paladin"},
 [7] = {cid = "PRIEST",      blizz = class_BlizzSort.PRIEST      or  5, eng = "Priest",       loc = class_LocaSort.PRIEST or "Priest"},
 [8] = {cid = "ROGUE",       blizz = class_BlizzSort.ROGUE       or  8, eng = "Rogue",        loc = class_LocaSort.ROGUE or "Rogue"},
 [9] = {cid = "SHAMAN",      blizz = class_BlizzSort.SHAMAN      or  6, eng = "Shaman",       loc = class_LocaSort.SHAMAN or "Shaman"},
[10] = {cid = "WARLOCK",     blizz = class_BlizzSort.WARLOCK     or 10, eng = "Warlock",      loc = class_LocaSort.WARLOCK or "Warlock"},
[11] = {cid = "WARRIOR",     blizz = class_BlizzSort.WARRIOR     or  1, eng = "Warrior",      loc = class_LocaSort.WARRIOR or "Warrior"},
}

local ranges = {
	DEATHKNIGHT =  47541, -- Death Coil        (30yd/m) - Lvl 55
	DRUID       =   5176, -- Wrath             (40yd/m) - Lvl  1
	HUNTER      =     75, -- Auto Shot       (5-40yd/m) - Lvl  1
	MAGE        =    133, -- Fireball          (40yd/m) - Lvl  1
	MONK        = 115546, -- Provoke           (40yd/m) - Lvl 14 MON14 TODO_MoP ?warning req in MoP?
	PALADIN     =  62124, -- Hand of Reckoning (30yd/m) - Lvl 14 PAL14 TODO_MoP ?NO warning req in MoP? (Lvl 3)
	PRIEST      =    589, -- Shadow Word: Pain (40yd/m) - Lvl  4
	ROGUE       =   6770, -- Sap               (10yd/m) - Lvl 10 ROG12 TODO_MoP ?warning req in MoP? (Lvl 12)
	SHAMAN      =    403, -- Lightning Bolt    (30yd/m) - Lvl  1
	WARLOCK     =    686, -- Shadow Bolt       (40yd/m) - Lvl  1
	WARRIOR     =    100, -- Charge          (8-25yd/m) - Lvl  3
}
if tocversion >= 50000 then -- TODO_MoP
	ranges.MAGE    = 44614-- Frostfire Bolt    (40yd/m) - Lvl 1
	ranges.PALADIN = 20271-- Judgment          (30yd/m) - Lvl 3
end
--for k, v in pairs(ranges) do local name, _, _, _, _, _, _, min, max = GetSpellInfo(v) print(k, v, name, min, max) end -- TEST

local rangeTypeName = {
	[1] = "1) CombatLog |cffffff79(0-73)|r", -- 1) combatlog
	[2] = "2) ...",                          -- 2) class-spell based
	[3] = "3) ...",                          -- 3) mix 1 class-spell based + combatlog (range: 0-45)
	[4] = "4) ...",                          -- 4) mix 2 class-spell based + combatlog (range: class-spell dependent)
}

local rangeDisplay = { -- RANGE_DISP_LAY
	 [1] = "STD 100", -- STD = Standard
	 [2] = "STD 100 mono",
	 [3] = "STD 50",
	 [4] = "STD 50 mono",
	 [5] = "STD 10",
	 [6] = "STD 10 mono",
	 [7] = "X 100 mono", -- X = without block
	 [8] = "X 50 mono",
	 [9] = "X 10",
	[10] = "X 10 mono",
}

local function rt(H,E,M,P) return E,P,E,M,H,P,H,M end -- magical 180 degree texture cut center rotation

local Textures = {
	BattlegroundTargetsIcons = {path= "Interface\\AddOns\\BattlegroundTargets\\BattlegroundTargets-texture-icons.tga"}, -- Textures.BattlegroundTargetsIcons.path
	SliderKnob       = {coords     =    {19/64, 30/64,  1/64, 18/64}},
	SliderBG         = {coordsL    =    {19/64, 24/64, 27/64, 33/64},
	                    coordsM    =    {25/64, 26/64, 27/64, 33/64},
	                    coordsR    =    {26/64, 31/64, 27/64, 33/64},
	                    coordsLdis =    {19/64, 24/64, 19/64, 25/64},
	                    coordsMdis =    {25/64, 26/64, 19/64, 25/64},
	                    coordsRdis =    {26/64, 31/64, 19/64, 25/64}},
	Expand           = {coords     =    { 1/64, 18/64,  1/64, 18/64}},
	Collapse         = {coords     = {rt( 1/64, 18/64,  1/64, 18/64)}}, -- 180 degree rota
	Close            = {coords     =    { 1/64, 18/64, 19/64, 36/64}},
	RoleIcon         = {[1]        =    {32/64, 48/64, 16/64, 32/64},   -- HEAL
	                    [2]        =    {48/64, 64/64,  0/64, 16/64},   -- TANK
	                    [3]        =    {32/64, 48/64,  0/64, 16/64},   -- DAMAGE
	                    [4]        =    {48/64, 64/64, 16/64, 32/64}},  -- UNKNOWN
	l40_18           = {coords     =    {36/64, 41/64, 37/64, 51/64}, width =  5*2, height = 14*2},
	l40_24           = {coords     =    {27/64, 36/64, 37/64, 47/64}, width =  9*2, height = 10*2},
	l40_42           = {coords     =    {14/64, 27/64, 37/64, 44/64}, width = 13*2, height =  7*2},
	l40_81           = {coords     =    { 0/64, 14/64, 37/64, 42/64}, width = 14*2, height =  5*2},
	UpdateWarning    = {coords     =    { 0/64, 35/64, 47/64, 63/64}, width = 35/1.5, height = 16/1.5},
}

local guildGrpTex = { -- GRP_TEX
	[1] = {44/64, 53/64, 34/64, 43/64},
	[2] = {54/64, 63/64, 34/64, 43/64},
	[3] = {44/64, 53/64, 44/64, 53/64},
	[4] = {54/64, 63/64, 44/64, 53/64},
	[5] = {44/64, 53/64, 54/64, 63/64},
	[6] = {54/64, 63/64, 54/64, 63/64},
}

local guildGrpCol = {
	[1] = {1, 1, 1}, -- white
	[2] = {1, 0.75, 0}, -- yellow
	[3] = {0, 0.5, 0.75}, -- blue
	[4] = {1, 0, 0}, -- red
	[5] = {0, 0.75, 0}, -- green
}

local raidUnitID = {}
for i = 1, 40 do
	raidUnitID["raid"..i] = 1
	raidUnitID["raidpet"..i] = 1
end
local playerUnitID = {}
playerUnitID["target"] = 1
playerUnitID["pettarget"] = 1
playerUnitID["focus"] = 1
playerUnitID["mouseover"] = 1
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
local function Print(...)
	print("|cffffff7fBattlegroundTargets:|r", ...)
end

local function ClassHexColor(class)
	local hex
	if classcolors[class] then
		hex = string_format("%.2x%.2x%.2x", classcolors[class].r*255, classcolors[class].g*255, classcolors[class].b*255)
	end
	return hex or "cccccc"
end

local function NOOP() end

local function guildgroup_sortfunc(a, b)
	if a.count < b.count then return true end
end

local function ggTexCol(num)
	local tex = math_floor(num/6) -- #guildGrpTex
	if tex < 1 then
		tex = num
	else
		tex = num - (tex * 6)
		if tex == 0 then
			tex = ((tex+1) * 6)
		end
	end
	local col = math_floor(num/5) -- #guildGrpCol
	if col < 1 then
		col = num
	else
		col = num - (col * 5)
		if col == 0 then
			col = ((col+1) * 5)
		end
	end
	return tex, col
end

local function Desaturation(texture, desaturation)
	local shaderSupported = texture:SetDesaturated(desaturation)
	if not shaderSupported then
		if desaturation then
			texture:SetVertexColor(0.5, 0.5, 0.5)
		else
			texture:SetVertexColor(1.0, 1.0, 1.0)
		end
	end
end

local function SortByPullDownFunc(value) -- PDFUNC
	BattlegroundTargets_Options.ButtonSortBy[currentSize] = value
	                        OPT.ButtonSortBy[currentSize] = value
	BattlegroundTargets:EnableConfigMode()
end

local function SortDetailPullDownFunc(value) -- PDFUNC
	BattlegroundTargets_Options.ButtonSortDetail[currentSize] = value
	                        OPT.ButtonSortDetail[currentSize] = value
	BattlegroundTargets:EnableConfigMode()
end

local function RangeCheckTypePullDownFunc(value) -- PDFUNC
	BattlegroundTargets_Options.ButtonTypeRangeCheck[currentSize] = value
	                        OPT.ButtonTypeRangeCheck[currentSize] = value
end

local function RangeDisplayPullDownFunc(value) -- PDFUNC
	BattlegroundTargets_Options.ButtonRangeDisplay[currentSize] = value
	                        OPT.ButtonRangeDisplay[currentSize] = value
	BattlegroundTargets:EnableConfigMode()
end

local function Range_Display(state, GVAR_TargetButton, display) -- RANGE_DISP_LAY
	if state then
		GVAR_TargetButton.Background:SetAlpha(1)
		GVAR_TargetButton.TargetCountBackground:SetAlpha(1)
		GVAR_TargetButton.ClassColorBackground:SetAlpha(1)
		GVAR_TargetButton.RangeTexture:SetAlpha(1)
		GVAR_TargetButton.HealthBar:SetAlpha(1)
		GVAR_TargetButton.RoleTexture:SetAlpha(1)
		GVAR_TargetButton.SpecTexture:SetAlpha(1)
		GVAR_TargetButton.ClassTexture:SetAlpha(1)
		GVAR_TargetButton.ClassColorBackground:SetTexture(GVAR_TargetButton.colR5, GVAR_TargetButton.colG5, GVAR_TargetButton.colB5, 1)
		GVAR_TargetButton.HealthBar:SetTexture(GVAR_TargetButton.colR, GVAR_TargetButton.colG, GVAR_TargetButton.colB, 1)
	else
		if display == 1 then -- Default 100
			GVAR_TargetButton.Background:SetAlpha(1)
			GVAR_TargetButton.TargetCountBackground:SetAlpha(1)
			GVAR_TargetButton.ClassColorBackground:SetAlpha(1)
			GVAR_TargetButton.RangeTexture:SetAlpha(0)
			GVAR_TargetButton.HealthBar:SetAlpha(1)
			GVAR_TargetButton.RoleTexture:SetAlpha(1)
			GVAR_TargetButton.SpecTexture:SetAlpha(1)
			GVAR_TargetButton.ClassTexture:SetAlpha(1)
 		elseif display == 2 then -- Default 100 m
			GVAR_TargetButton.Background:SetAlpha(1)
			GVAR_TargetButton.TargetCountBackground:SetAlpha(1)
			GVAR_TargetButton.ClassColorBackground:SetAlpha(1)
			GVAR_TargetButton.RangeTexture:SetAlpha(0)
			GVAR_TargetButton.HealthBar:SetAlpha(1)
			GVAR_TargetButton.RoleTexture:SetAlpha(1)
			GVAR_TargetButton.SpecTexture:SetAlpha(1)
			GVAR_TargetButton.ClassTexture:SetAlpha(1)
			GVAR_TargetButton.ClassColorBackground:SetTexture(0.2, 0.2, 0.2, 1)
			GVAR_TargetButton.HealthBar:SetTexture(0.4, 0.4, 0.4, 1)
		elseif display == 3 then -- Default 50
			GVAR_TargetButton.Background:SetAlpha(0.5)
			GVAR_TargetButton.TargetCountBackground:SetAlpha(0.1)
			GVAR_TargetButton.ClassColorBackground:SetAlpha(0.5)
			GVAR_TargetButton.RangeTexture:SetAlpha(0)
			GVAR_TargetButton.HealthBar:SetAlpha(0.5)
			GVAR_TargetButton.RoleTexture:SetAlpha(0.5)
			GVAR_TargetButton.SpecTexture:SetAlpha(0.5)
			GVAR_TargetButton.ClassTexture:SetAlpha(0.5)
 		elseif display == 4 then -- Default 50 m
			GVAR_TargetButton.Background:SetAlpha(0.5)
			GVAR_TargetButton.TargetCountBackground:SetAlpha(0.1)
			GVAR_TargetButton.ClassColorBackground:SetAlpha(0.5)
			GVAR_TargetButton.RangeTexture:SetAlpha(0)
			GVAR_TargetButton.HealthBar:SetAlpha(0.5)
			GVAR_TargetButton.RoleTexture:SetAlpha(0.5)
			GVAR_TargetButton.SpecTexture:SetAlpha(0.5)
			GVAR_TargetButton.ClassTexture:SetAlpha(0.5)
			GVAR_TargetButton.ClassColorBackground:SetTexture(0.2, 0.2, 0.2, 1)
			GVAR_TargetButton.HealthBar:SetTexture(0.4, 0.4, 0.4, 1)
		elseif display == 5 then -- Default 10
			GVAR_TargetButton.Background:SetAlpha(0.3)
			GVAR_TargetButton.TargetCountBackground:SetAlpha(0.1)
			GVAR_TargetButton.ClassColorBackground:SetAlpha(0.25)
			GVAR_TargetButton.RangeTexture:SetAlpha(0)
			GVAR_TargetButton.HealthBar:SetAlpha(0.1)
			GVAR_TargetButton.RoleTexture:SetAlpha(0.25)
			GVAR_TargetButton.SpecTexture:SetAlpha(0.25)
			GVAR_TargetButton.ClassTexture:SetAlpha(0.25)
		elseif display == 6 then -- Default 10 m
			GVAR_TargetButton.Background:SetAlpha(0.3)
			GVAR_TargetButton.TargetCountBackground:SetAlpha(0.1)
			GVAR_TargetButton.ClassColorBackground:SetAlpha(0.25)
			GVAR_TargetButton.RangeTexture:SetAlpha(0)
			GVAR_TargetButton.HealthBar:SetAlpha(0.1)
			GVAR_TargetButton.RoleTexture:SetAlpha(0.25)
			GVAR_TargetButton.SpecTexture:SetAlpha(0.25)
			GVAR_TargetButton.ClassTexture:SetAlpha(0.25)
			GVAR_TargetButton.ClassColorBackground:SetTexture(0.2, 0.2, 0.2, 1)
			GVAR_TargetButton.HealthBar:SetTexture(0.4, 0.4, 0.4, 1)
 		elseif display == 7 then -- X 100 m
			GVAR_TargetButton.Background:SetAlpha(1)
			GVAR_TargetButton.TargetCountBackground:SetAlpha(1)
			GVAR_TargetButton.ClassColorBackground:SetAlpha(1)
			GVAR_TargetButton.RangeTexture:SetAlpha(0)
			GVAR_TargetButton.HealthBar:SetAlpha(1)
			GVAR_TargetButton.RoleTexture:SetAlpha(1)
			GVAR_TargetButton.SpecTexture:SetAlpha(1)
			GVAR_TargetButton.ClassTexture:SetAlpha(1)
			GVAR_TargetButton.ClassColorBackground:SetTexture(0.2, 0.2, 0.2, 1)
			GVAR_TargetButton.HealthBar:SetTexture(0.4, 0.4, 0.4, 1)
 		elseif display == 8 then -- X 50 m
			GVAR_TargetButton.Background:SetAlpha(0.5)
			GVAR_TargetButton.TargetCountBackground:SetAlpha(0.1)
			GVAR_TargetButton.ClassColorBackground:SetAlpha(0.5)
			GVAR_TargetButton.RangeTexture:SetAlpha(0)
			GVAR_TargetButton.HealthBar:SetAlpha(0.5)
			GVAR_TargetButton.RoleTexture:SetAlpha(0.5)
			GVAR_TargetButton.SpecTexture:SetAlpha(0.5)
			GVAR_TargetButton.ClassTexture:SetAlpha(0.5)
			GVAR_TargetButton.ClassColorBackground:SetTexture(0.2, 0.2, 0.2, 1)
			GVAR_TargetButton.HealthBar:SetTexture(0.4, 0.4, 0.4, 1)
		elseif display == 9 then -- X 10
			GVAR_TargetButton.Background:SetAlpha(0.3)
			GVAR_TargetButton.TargetCountBackground:SetAlpha(0.1)
			GVAR_TargetButton.ClassColorBackground:SetAlpha(0.25)
			GVAR_TargetButton.RangeTexture:SetAlpha(0)
			GVAR_TargetButton.HealthBar:SetAlpha(0.1)
			GVAR_TargetButton.RoleTexture:SetAlpha(0.25)
			GVAR_TargetButton.SpecTexture:SetAlpha(0.25)
			GVAR_TargetButton.ClassTexture:SetAlpha(0.25)
		else--if display == 10 then -- X 10 m
			GVAR_TargetButton.Background:SetAlpha(0.3)
			GVAR_TargetButton.TargetCountBackground:SetAlpha(0.1)
			GVAR_TargetButton.ClassColorBackground:SetAlpha(0.25)
			GVAR_TargetButton.RangeTexture:SetAlpha(0)
			GVAR_TargetButton.HealthBar:SetAlpha(0.1)
			GVAR_TargetButton.RoleTexture:SetAlpha(0.25)
			GVAR_TargetButton.SpecTexture:SetAlpha(0.25)
			GVAR_TargetButton.ClassTexture:SetAlpha(0.25)
			GVAR_TargetButton.ClassColorBackground:SetTexture(0.2, 0.2, 0.2, 1)
			GVAR_TargetButton.HealthBar:SetTexture(0.4, 0.4, 0.4, 1)
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
-- Template BorderTRBL START ----------------------------------------
TEMPLATE.BorderTRBL = function(frame) -- TRBL = Top-Right-Bottom-Left
	frame.FrameBorder = frame:CreateTexture(nil, "BORDER")
	frame.FrameBorder:SetPoint("TOPLEFT", 1, -1)
	frame.FrameBorder:SetPoint("BOTTOMRIGHT", -1, 1)
	frame.FrameBorder:SetTexture(0, 0, 0, 1)
	frame.FrameBackground = frame:CreateTexture(nil, "BACKGROUND")
	frame.FrameBackground:SetPoint("TOPLEFT", 0, 0)
	frame.FrameBackground:SetPoint("BOTTOMRIGHT", 0, 0)
	frame.FrameBackground:SetTexture(0.8, 0.2, 0.2, 1)
end
-- Template BorderTRBL END ----------------------------------------

-- Template TextButton START ----------------------------------------
TEMPLATE.DisableTextButton = function(button)
	button.Border:SetTexture(0.4, 0.4, 0.4, 1)
	button:Disable()
end

TEMPLATE.EnableTextButton = function(button, action)
	local buttoncolor
	if action == 1 then
		bordercolor = {0.73, 0.26, 0.21, 1}
	elseif action == 2 then
		bordercolor = {0.43, 0.32, 0.68, 1}
	elseif action == 3 then
		bordercolor = {0.24, 0.46, 0.21, 1}
	elseif action == 4 then
		bordercolor = {0.73, 0.26, 0.21, 1}
	else
		bordercolor = {1, 1, 1, 1}
	end
	button.Border:SetTexture(bordercolor[1], bordercolor[2], bordercolor[3], bordercolor[4])
	button:Enable()
end

TEMPLATE.TextButton = function(button, text, action)
	local buttoncolor
	local bordercolor
	if action == 1 then
		button:SetNormalFontObject("GameFontNormal")
		button:SetDisabledFontObject("GameFontDisable")
		buttoncolor = {0.38, 0, 0, 1}
		bordercolor = {0.73, 0.26, 0.21, 1}
	elseif action == 2 then
		button:SetNormalFontObject("GameFontNormalSmall")
		button:SetDisabledFontObject("GameFontDisableSmall")
		buttoncolor = {0, 0, 0.5, 1}
		bordercolor = {0.43, 0.32, 0.68, 1}
	elseif action == 3 then
		button:SetNormalFontObject("GameFontNormalSmall")
		button:SetDisabledFontObject("GameFontDisableSmall")
		buttoncolor = {0, 0.2, 0, 1}
		bordercolor = {0.24, 0.46, 0.21, 1}
	elseif action == 4 then
		button:SetNormalFontObject("GameFontNormalSmall")
		button:SetDisabledFontObject("GameFontDisableSmall")
		buttoncolor = {0.38, 0, 0, 1}
		bordercolor = {0.73, 0.26, 0.21, 1}
	else
		button:SetNormalFontObject("GameFontNormal")
		button:SetDisabledFontObject("GameFontDisable")
		buttoncolor = {0, 0, 0, 1}
		bordercolor = {1, 1, 1, 1}
	end

	button.Background = button:CreateTexture(nil, "BORDER")
	button.Background:SetPoint("TOPLEFT", 1, -1)
	button.Background:SetPoint("BOTTOMRIGHT", -1, 1)
	button.Background:SetTexture(0, 0, 0, 1)

	button.Border = button:CreateTexture(nil, "BACKGROUND")
	button.Border:SetPoint("TOPLEFT", 0, 0)
	button.Border:SetPoint("BOTTOMRIGHT", 0, 0)
	button.Border:SetTexture(bordercolor[1], bordercolor[2], bordercolor[3], bordercolor[4])

	button.Normal = button:CreateTexture(nil, "ARTWORK")
	button.Normal:SetPoint("TOPLEFT", 2, -2)
	button.Normal:SetPoint("BOTTOMRIGHT", -2, 2)
	button.Normal:SetTexture(buttoncolor[1], buttoncolor[2], buttoncolor[3], buttoncolor[4])
	button:SetNormalTexture(button.Normal)

	button.Disabled = button:CreateTexture(nil, "OVERLAY")
	button.Disabled:SetPoint("TOPLEFT", 3, -3)
	button.Disabled:SetPoint("BOTTOMRIGHT", -3, 3)
	button.Disabled:SetTexture(0.6, 0.6, 0.6, 0.2)
	button:SetDisabledTexture(button.Disabled)

	button.Highlight = button:CreateTexture(nil, "OVERLAY")
	button.Highlight:SetPoint("TOPLEFT", 3, -3)
	button.Highlight:SetPoint("BOTTOMRIGHT", -3, 3)
	button.Highlight:SetTexture(0.6, 0.6, 0.6, 0.2)
	button:SetHighlightTexture(button.Highlight)

	button:SetPushedTextOffset(1, -1)
	button:SetText(text)
end
-- Template TextButton END ----------------------------------------

-- Template IconButton START ----------------------------------------
--TEMPLATE.DisableIconButton = function(button)
--	button.Border:SetTexture(0.4, 0.4, 0.4, 1)
--	button:Disable()
--end

--TEMPLATE.EnableIconButton = function(button)
--	button.Border:SetTexture(0.8, 0.2, 0.2, 1)
--	button:Enable()
--end

TEMPLATE.IconButton = function(button, cut)
	button.Back = button:CreateTexture(nil, "BORDER")
	button.Back:SetPoint("TOPLEFT", 1, -1)
	button.Back:SetPoint("BOTTOMRIGHT", -1, 1)
	button.Back:SetTexture(0, 0, 0, 1)

	button.Border = button:CreateTexture(nil, "BACKGROUND")
	button.Border:SetPoint("TOPLEFT", 0, 0)
	button.Border:SetPoint("BOTTOMRIGHT", 0, 0)
	button.Border:SetTexture(0.8, 0.2, 0.2, 1)

	button.Highlight = button:CreateTexture(nil, "OVERLAY")
	button.Highlight:SetPoint("TOPLEFT", 3, -3)
	button.Highlight:SetPoint("BOTTOMRIGHT", -3, 3)
	button.Highlight:SetTexture(0.6, 0.6, 0.6, 0.2)
	button:SetHighlightTexture(button.Highlight)

	button.Normal = button:CreateTexture(nil, "ARTWORK")
	button.Normal:SetPoint("TOPLEFT", 3, -3)
	button.Normal:SetPoint("BOTTOMRIGHT", -3, 3)
	button.Normal:SetTexture(Textures.BattlegroundTargetsIcons.path)
	button.Normal:SetTexCoord(unpack(Textures.Close.coords))
	button:SetNormalTexture(button.Normal)

	button.Push = button:CreateTexture(nil, "ARTWORK")
	button.Push:SetPoint("TOPLEFT", 4, -4)
	button.Push:SetPoint("BOTTOMRIGHT", -4, 4)
	button.Push:SetTexture(Textures.BattlegroundTargetsIcons.path)
	button.Push:SetTexCoord(unpack(Textures.Close.coords))
	button:SetPushedTexture(button.Push)

	button.Disabled = button:CreateTexture(nil, "ARTWORK")
	button.Disabled:SetPoint("TOPLEFT", 3, -3)
	button.Disabled:SetPoint("BOTTOMRIGHT", -3, 3)
	button.Disabled:SetTexture(Textures.BattlegroundTargetsIcons.path)
	button.Disabled:SetTexCoord(unpack(Textures.Close.coords))
	button:SetDisabledTexture(button.Disabled)
	Desaturation(button.Disabled, true)
end
-- Template IconButton END ----------------------------------------

-- Template CheckButton START ----------------------------------------
TEMPLATE.DisableCheckButton = function(button)
	if button.Text then
		button.Text:SetTextColor(0.5, 0.5, 0.5)
	elseif button.Icon then
		Desaturation(button.Icon, true)
	end
	button.Border:SetTexture(0.4, 0.4, 0.4, 1)
	button:Disable()
end

TEMPLATE.EnableCheckButton = function(button)
	if button.Text then
		button.Text:SetTextColor(1, 1, 1)
	elseif button.Icon then
		Desaturation(button.Icon, false)
	end
	button.Border:SetTexture(0.8, 0.2, 0.2, 1)
	button:Enable()
end

TEMPLATE.CheckButton = function(button, size, space, text, icon)
	button.Border = button:CreateTexture(nil, "BACKGROUND")
	button.Border:SetWidth( size )
	button.Border:SetHeight( size )
	button.Border:SetPoint("LEFT", 0, 0)
	button.Border:SetTexture(0.4, 0.4, 0.4, 1)

	button.Background = button:CreateTexture(nil, "BORDER")
	button.Background:SetPoint("TOPLEFT", button.Border, "TOPLEFT", 1, -1)
	button.Background:SetPoint("BOTTOMRIGHT", button.Border, "BOTTOMRIGHT", -1, 1)
	button.Background:SetTexture(0, 0, 0, 1)

	button.Normal = button:CreateTexture(nil, "ARTWORK")
	button.Normal:SetPoint("TOPLEFT", button.Border, "TOPLEFT", 1, -1)
	button.Normal:SetPoint("BOTTOMRIGHT", button.Border, "BOTTOMRIGHT", -1, 1)
	button.Normal:SetTexture(0, 0, 0, 1)
	button:SetNormalTexture(button.Normal)

	button.Push = button:CreateTexture(nil, "ARTWORK")
	button.Push:SetPoint("TOPLEFT", button.Border, "TOPLEFT", 4, -4)
	button.Push:SetPoint("BOTTOMRIGHT", button.Border, "BOTTOMRIGHT", -4, 4)
	button.Push:SetTexture(0.4, 0.4, 0.4, 0.5)
	button:SetPushedTexture(button.Push)

	button.Disabled = button:CreateTexture(nil, "ARTWORK")
	button.Disabled:SetPoint("TOPLEFT", button.Border, "TOPLEFT", 3, -3)
	button.Disabled:SetPoint("BOTTOMRIGHT", button.Border, "BOTTOMRIGHT", -3, 3)
	button.Disabled:SetTexture(0.4, 0.4, 0.4, 0.5)
	button:SetDisabledTexture(button.Disabled)

	button.Checked = button:CreateTexture(nil, "ARTWORK")
	button.Checked:SetWidth( size )
	button.Checked:SetHeight( size )
	button.Checked:SetPoint("LEFT", 0, 0)
	button.Checked:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
	button:SetCheckedTexture(button.Checked)

	if icon then
		if icon == "default" then
			button.Icon = button:CreateTexture(nil, "BORDER")
			button.Icon:SetWidth(20)
			button.Icon:SetHeight(20)
			button.Icon:SetPoint("LEFT", button.Normal, "RIGHT", space, 0)
			button.Icon:SetTexture("Interface\\Minimap\\Tracking\\Target")
			button:SetWidth(size + space + 20 + space)
			button:SetHeight(size)
		elseif icon == "bgt" then
			button.Icon = button:CreateTexture(nil, "BORDER")
			button.Icon:SetWidth(20)
			button.Icon:SetHeight(20)
			button.Icon:SetPoint("LEFT", button.Normal, "RIGHT", space, 0)
			button.Icon:SetTexture(AddonIcon)
			button:SetWidth(size + space + 20 + space)
			button:SetHeight(size)
		else
			button.Icon = button:CreateTexture(nil, "BORDER")
			button.Icon:SetWidth(Textures[icon].width)
			button.Icon:SetHeight(Textures[icon].height)
			button.Icon:SetPoint("LEFT", button.Normal, "RIGHT", space, 0)
			button.Icon:SetTexture(Textures.BattlegroundTargetsIcons.path)
			button.Icon:SetTexCoord(unpack(Textures[icon].coords))
			button:SetWidth(size + space + Textures[icon].width + space)
			button:SetHeight(size)
		end
	else
		button.Text = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		button.Text:SetHeight( size )
		button.Text:SetPoint("LEFT", button.Normal, "RIGHT", space, 0)
		button.Text:SetJustifyH("LEFT")
		button.Text:SetText(text)
		button.Text:SetTextColor(1, 1, 1, 1)
		button:SetWidth(size + space + button.Text:GetStringWidth() + space)
		button:SetHeight(size)
	end

	button.Highlight = button:CreateTexture(nil, "OVERLAY")
	button.Highlight:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
	button.Highlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
	button.Highlight:SetTexture(1, 1, 1, 0.1)
	button.Highlight:Hide()

	button:SetScript("OnEnter", function() button.Highlight:Show() end)
	button:SetScript("OnLeave", function() button.Highlight:Hide() end)
end
-- Template CheckButton END ----------------------------------------

-- Template TabButton START ----------------------------------------
TEMPLATE.SetTabButton = function(button, show)
	if show then
		button.TextureBottom:SetTexture(0, 0, 0, 1)
		button.TextureBorder:SetTexture(0.8, 0.2, 0.2, 1)
		button.show = true
	else
		button.TextureBottom:SetTexture(0.8, 0.2, 0.2, 1)
		button.TextureBorder:SetTexture(0.4, 0.4, 0.4, 0.4)
		button.show = false
	end
end

TEMPLATE.DisableTabButton = function(button)
	if button.TabText then
		button.TabText:SetTextColor(0.5, 0.5, 0.5, 1)
	elseif button.TabTexture then
		Desaturation(button.TabTexture, true)
	end
	button:Disable()
end

TEMPLATE.EnableTabButton = function(button, active)
	if button.TabText then
		if active then
			button.TabText:SetTextColor(0, 0.75, 0, 1)
		else
			button.TabText:SetTextColor(1, 0, 0, 1)
		end
	elseif button.TabTexture then
		Desaturation(button.TabTexture, false)
	end
	button:Enable()
end

TEMPLATE.TabButton = function(button, text, active)
	button.Texture = button:CreateTexture(nil, "BORDER")
	button.Texture:SetPoint("TOPLEFT", 1, -1)
	button.Texture:SetPoint("BOTTOMRIGHT", -1, 1)
	button.Texture:SetTexture(0, 0, 0, 1)

	button.TextureBorder = button:CreateTexture(nil, "BACKGROUND")
	button.TextureBorder:SetPoint("TOPLEFT", 0, 0)
	button.TextureBorder:SetPoint("BOTTOMRIGHT", -1, 1)
	button.TextureBorder:SetPoint("TOPRIGHT" ,0, 0)
	button.TextureBorder:SetPoint("BOTTOMLEFT" ,1, 1)
	button.TextureBorder:SetTexture(0.8, 0.2, 0.2, 1)

	button.TextureBottom = button:CreateTexture(nil, "ARTWORK")
	button.TextureBottom:SetPoint("TOPLEFT", button, "BOTTOMLEFT" ,1, 2)
	button.TextureBottom:SetPoint("BOTTOMLEFT" ,1, 1)
	button.TextureBottom:SetPoint("TOPRIGHT", button, "BOTTOMRIGHT" ,-1, 2)
	button.TextureBottom:SetPoint("BOTTOMRIGHT" ,-1, 1)
	button.TextureBottom:SetTexture(0.8, 0.2, 0.2, 1)

	button.TextureHighlight = button:CreateTexture(nil, "ARTWORK")
	button.TextureHighlight:SetPoint("TOPLEFT", 3, -3)
	button.TextureHighlight:SetPoint("BOTTOMRIGHT", -3, 3)
	button.TextureHighlight:SetTexture(1, 1, 1, 0.1)
	button:SetHighlightTexture(button.TextureHighlight)

	if text then
		button.TabText = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		button.TabText:SetText(text)
		button.TabText:SetWidth( button.TabText:GetStringWidth()+10 )
		button.TabText:SetHeight(12)
		button.TabText:SetPoint("CENTER", button, "CENTER", 0, 0)
		button.TabText:SetJustifyH("CENTER")
		button.TabText:SetTextColor(1, 1, 1, 1)
		if active then
			button.TabText:SetTextColor(0, 0.75, 0, 1)
		else
			button.TabText:SetTextColor(1, 0, 0, 1)
		end
	else
		button.TabTexture = button:CreateTexture(nil, "OVERLAY")
		button.TabTexture:SetPoint("CENTER", 0, 0)
		button.TabTexture:SetWidth(17)
		button.TabTexture:SetHeight(17)
		button.TabTexture:SetTexture(AddonIcon)
	end

	button:SetScript("OnEnter", function() if not button.show then button.TextureBorder:SetTexture(0.4, 0.4, 0.4, 0.8) end end)
	button:SetScript("OnLeave", function() if not button.show then button.TextureBorder:SetTexture(0.4, 0.4, 0.4, 0.4) end end)
end
-- Template TabButton END ----------------------------------------

-- Template Slider START ----------------------------------------
TEMPLATE.DisableSlider = function(slider)
	slider.textMin:SetTextColor(0.5, 0.5, 0.5, 1)
	slider.textMax:SetTextColor(0.5, 0.5, 0.5, 1)
	slider.sliderBGL:SetTexCoord(unpack(Textures.SliderBG.coordsLdis))
	slider.sliderBGM:SetTexCoord(unpack(Textures.SliderBG.coordsMdis))
	slider.sliderBGR:SetTexCoord(unpack(Textures.SliderBG.coordsRdis))
	slider.thumb:SetTexCoord(0, 0, 0, 0)
	slider.Background:SetTexture(0, 0, 0, 0)
	slider:SetScript("OnEnter", NOOP)
	slider:SetScript("OnLeave", NOOP)
	slider:Disable()
end

TEMPLATE.EnableSlider = function(slider)
	slider.textMin:SetTextColor(0.8, 0.8, 0.8, 1)
	slider.textMax:SetTextColor(0.8, 0.8, 0.8, 1)
	slider.sliderBGL:SetTexCoord(unpack(Textures.SliderBG.coordsL))
	slider.sliderBGM:SetTexCoord(unpack(Textures.SliderBG.coordsM))
	slider.sliderBGR:SetTexCoord(unpack(Textures.SliderBG.coordsR))
	slider.thumb:SetTexCoord(unpack(Textures.SliderKnob.coords))
	slider:SetScript("OnEnter", function() slider.Background:SetTexture(1, 1, 1, 0.1) end)
	slider:SetScript("OnLeave", function() slider.Background:SetTexture(0, 0, 0, 0) end)
	slider:Enable()
end

TEMPLATE.Slider = function(slider, width, step, minVal, maxVal, curVal, func, measure)
	slider:SetWidth(width)
	slider:SetHeight(16)
	slider:SetValueStep(step)
	slider:SetMinMaxValues(minVal, maxVal)
	slider:SetValue(curVal)
	slider:SetOrientation("HORIZONTAL")

	slider.Background = slider:CreateTexture(nil, "BACKGROUND")
	slider.Background:SetWidth(width)
	slider.Background:SetHeight(16)
	slider.Background:SetPoint("LEFT", 0, 0)
	slider.Background:SetTexture(0, 0, 0, 0)

	slider.textMin = slider:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	slider.textMin:SetPoint("TOP", slider, "BOTTOM", 0, -1)
	slider.textMin:SetPoint("LEFT", slider, "LEFT", 0, 0)
	slider.textMin:SetJustifyH("CENTER")
	slider.textMin:SetTextColor(0.8, 0.8, 0.8, 1)
	if measure == "%" then
		slider.textMin:SetText(minVal.."%")
	elseif measure == "K" then
		slider.textMin:SetText((minVal/1000).."k")
	elseif measure == "H" then
		slider.textMin:SetText((minVal/100))
	elseif measure == "px" then
		slider.textMin:SetText(minVal.."px")
	elseif measure == "blank" then
		slider.textMin:SetText("")
	else
		slider.textMin:SetText(minVal)
	end
	slider.textMax = slider:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	slider.textMax:SetPoint("TOP", slider, "BOTTOM", 0, -1)
	slider.textMax:SetPoint("RIGHT", slider, "RIGHT", 0, 0)
	slider.textMax:SetJustifyH("CENTER")
	slider.textMax:SetTextColor(0.8, 0.8, 0.8, 1)
	if measure == "%" then
		slider.textMax:SetText(maxVal.."%")
	elseif measure == "K" then
		slider.textMax:SetText((maxVal/1000).."k")
	elseif measure == "H" then
		slider.textMax:SetText((maxVal/100))
	elseif measure == "px" then
		slider.textMax:SetText(maxVal.."px")
	elseif measure == "blank" then
		slider.textMax:SetText("")
	else
		slider.textMax:SetText(maxVal)
	end

	slider.sliderBGL = slider:CreateTexture(nil, "BACKGROUND")
	slider.sliderBGL:SetWidth(5)
	slider.sliderBGL:SetHeight(6)
	slider.sliderBGL:SetPoint("LEFT", slider, "LEFT", 0, 0)
	slider.sliderBGL:SetTexture(Textures.BattlegroundTargetsIcons.path)
	slider.sliderBGL:SetTexCoord(unpack(Textures.SliderBG.coordsL))
	slider.sliderBGM = slider:CreateTexture(nil, "BACKGROUND")
	slider.sliderBGM:SetWidth(width-5-5)
	slider.sliderBGM:SetHeight(6)
	slider.sliderBGM:SetPoint("LEFT", slider.sliderBGL, "RIGHT", 0, 0)
	slider.sliderBGM:SetTexture(Textures.BattlegroundTargetsIcons.path)
	slider.sliderBGM:SetTexCoord(unpack(Textures.SliderBG.coordsM))
	slider.sliderBGR = slider:CreateTexture(nil, "BACKGROUND")
	slider.sliderBGR:SetWidth(5)
	slider.sliderBGR:SetHeight(6)
	slider.sliderBGR:SetPoint("LEFT", slider.sliderBGM, "RIGHT", 0, 0)
	slider.sliderBGR:SetTexture(Textures.BattlegroundTargetsIcons.path)
	slider.sliderBGR:SetTexCoord(unpack(Textures.SliderBG.coordsR))

	slider.thumb = slider:CreateTexture(nil, "BORDER")
	slider.thumb:SetWidth(11)
	slider.thumb:SetHeight(17)
	slider.thumb:SetTexture(Textures.BattlegroundTargetsIcons.path)
	slider.thumb:SetTexCoord(unpack(Textures.SliderKnob.coords))
	slider:SetThumbTexture(slider.thumb)

	slider:SetScript("OnValueChanged", function(self, value)
		if not slider:IsEnabled() then return end
		if func then
			func(self, value)
		end
	end)

	slider:SetScript("OnEnter", function() slider.Background:SetTexture(1, 1, 1, 0.1) end)
	slider:SetScript("OnLeave", function() slider.Background:SetTexture(0, 0, 0, 0) end)
end
-- Template Slider END ----------------------------------------

-- Template PullDownMenu START ----------------------------------------
TEMPLATE.DisablePullDownMenu = function(button)
	button.PullDownMenu:Hide()
	button.PullDownButtonBorder:SetTexture(0.4, 0.4, 0.4, 1)
	button:Disable()
end

TEMPLATE.EnablePullDownMenu = function(button)
	button.PullDownButtonBorder:SetTexture(0.8, 0.2, 0.2, 1)
	button:Enable()
end

TEMPLATE.PullDownMenu = function(button, contentName, buttonText, pulldownWidth, contentNum, func)
	button.PullDownButtonBG = button:CreateTexture(nil, "BORDER")
	button.PullDownButtonBG:SetPoint("TOPLEFT", 1, -1)
	button.PullDownButtonBG:SetPoint("BOTTOMRIGHT", -1, 1)
	button.PullDownButtonBG:SetTexture(0, 0, 0, 1)

	button.PullDownButtonBorder = button:CreateTexture(nil, "BACKGROUND")
	button.PullDownButtonBorder:SetPoint("TOPLEFT", 0, 0)
	button.PullDownButtonBorder:SetPoint("BOTTOMRIGHT", 0, 0)
	button.PullDownButtonBorder:SetTexture(0.4, 0.4, 0.4, 1)

	button.PullDownButtonExpand = button:CreateTexture(nil, "OVERLAY")
	button.PullDownButtonExpand:SetHeight(14)
	button.PullDownButtonExpand:SetWidth(14)
	button.PullDownButtonExpand:SetPoint("RIGHT", button, "RIGHT", -2, 0)
	button.PullDownButtonExpand:SetTexture(Textures.BattlegroundTargetsIcons.path)
	button.PullDownButtonExpand:SetTexCoord(unpack(Textures.Expand.coords))
	button:SetNormalTexture(button.PullDownButtonExpand)

	button.PullDownButtonDisabled = button:CreateTexture(nil, "OVERLAY")
	button.PullDownButtonDisabled:SetPoint("TOPLEFT", 3, -3)
	button.PullDownButtonDisabled:SetPoint("BOTTOMRIGHT", -3, 3)
	button.PullDownButtonDisabled:SetTexture(0.6, 0.6, 0.6, 0.2)
	button:SetDisabledTexture(button.PullDownButtonDisabled)

	button.PullDownButtonHighlight = button:CreateTexture(nil, "OVERLAY")
	button.PullDownButtonHighlight:SetPoint("TOPLEFT", 1, -1)
	button.PullDownButtonHighlight:SetPoint("BOTTOMRIGHT", -1, 1)
	button.PullDownButtonHighlight:SetTexture(0.6, 0.6, 0.6, 0.2)
	button:SetHighlightTexture(button.PullDownButtonHighlight)

	button.PullDownButtonText = button:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	button.PullDownButtonText:SetHeight(sizeBarHeight)
	button.PullDownButtonText:SetPoint("LEFT", sizeOffset+2, 0)
	button.PullDownButtonText:SetJustifyH("LEFT")
	button.PullDownButtonText:SetText(buttonText)
	button.PullDownButtonText:SetTextColor(1, 1, 0.49, 1)

	button.PullDownMenu = CreateFrame("Frame", nil, button)
	TEMPLATE.BorderTRBL(button.PullDownMenu)
	button.PullDownMenu:EnableMouse(true)
	button.PullDownMenu:SetToplevel(true)
	button.PullDownMenu:SetHeight(sizeOffset+(contentNum*sizeBarHeight)+sizeOffset)
	button.PullDownMenu:SetPoint("TOPLEFT", button, "BOTTOMLEFT", 0, 1)
	button.PullDownMenu:Hide()

	local function OnLeave()
		if not button:IsMouseOver() and not button.PullDownMenu:IsMouseOver() then
			button.PullDownMenu:Hide()
			button.PullDownButtonExpand:SetTexCoord(unpack(Textures.Expand.coords))
		end
	end

	local autoWidth = 0
	for i = 1, contentNum do
		if not button.PullDownMenu.Button then button.PullDownMenu.Button = {} end
		button.PullDownMenu.Button[i] = CreateFrame("Button", nil, button.PullDownMenu)
		button.PullDownMenu.Button[i]:SetHeight(sizeBarHeight)
		button.PullDownMenu.Button[i]:SetFrameLevel( button.PullDownMenu:GetFrameLevel() + 5 )
		if i == 1 then
			button.PullDownMenu.Button[i]:SetPoint("TOPLEFT", button.PullDownMenu, "TOPLEFT", sizeOffset, -sizeOffset)
		else
			button.PullDownMenu.Button[i]:SetPoint("TOPLEFT", button.PullDownMenu.Button[(i-1)], "BOTTOMLEFT", 0, 0)
		end

		button.PullDownMenu.Button[i].Text = button.PullDownMenu.Button[i]:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		button.PullDownMenu.Button[i].Text:SetHeight(sizeBarHeight)
		button.PullDownMenu.Button[i].Text:SetPoint("LEFT", 2, 0)
		button.PullDownMenu.Button[i].Text:SetJustifyH("LEFT")
		button.PullDownMenu.Button[i].Text:SetTextColor(1, 1, 1, 1)

		button.PullDownMenu.Button[i]:SetScript("OnLeave", OnLeave)
		button.PullDownMenu.Button[i]:SetScript("OnClick", function()
			button.value1 = button.PullDownMenu.Button[i].value1
			button.PullDownButtonText:SetText( button.PullDownMenu.Button[i].Text:GetText() )
			button.PullDownMenu:Hide()
			button.PullDownButtonExpand:SetTexCoord(unpack(Textures.Expand.coords))
			if func then
				func(button.value1) -- PDFUNC
			end
		end)

		button.PullDownMenu.Button[i].Highlight = button.PullDownMenu.Button[i]:CreateTexture(nil, "ARTWORK")
		button.PullDownMenu.Button[i].Highlight:SetPoint("TOPLEFT", 0, 0)
		button.PullDownMenu.Button[i].Highlight:SetPoint("BOTTOMRIGHT", 0, 0)
		button.PullDownMenu.Button[i].Highlight:SetTexture(1, 1, 1, 0.2)
		button.PullDownMenu.Button[i]:SetHighlightTexture(button.PullDownMenu.Button[i].Highlight)

		if contentName == "SortBy" then
			button.PullDownMenu.Button[i].Text:SetText(sortBy[i])
			button.PullDownMenu.Button[i].value1 = i
		elseif contentName == "SortDetail" then
			button.PullDownMenu.Button[i].Text:SetText(sortDetail[i])
			button.PullDownMenu.Button[i].value1 = i
		elseif contentName == "RangeType" then
			button.PullDownMenu.Button[i].Text:SetText(rangeTypeName[i])
			button.PullDownMenu.Button[i].value1 = i
		elseif contentName == "RangeDisplay" then
			button.PullDownMenu.Button[i].Text:SetText(rangeDisplay[i])
			button.PullDownMenu.Button[i].value1 = i
		end
		button.PullDownMenu.Button[i]:Show()

		if pulldownWidth == 0 then
			local w = button.PullDownMenu.Button[i].Text:GetStringWidth()+15+18
			if w > autoWidth then
				autoWidth = w
			end
		end
	end

	local newWidth = pulldownWidth
	if pulldownWidth == 0 then
		newWidth = autoWidth
	end

	button.PullDownButtonText:SetWidth(newWidth-sizeOffset-sizeOffset)
	button.PullDownMenu:SetWidth(newWidth)
	for i = 1, contentNum do
		button.PullDownMenu.Button[i]:SetWidth(newWidth-sizeOffset-sizeOffset)
		button.PullDownMenu.Button[i].Text:SetWidth(newWidth-sizeOffset-sizeOffset)
	end
	button:SetWidth(newWidth)

	button.PullDownMenu:SetScript("OnLeave", OnLeave)
	button.PullDownMenu:SetScript("OnHide", function(self) self:Hide() end) -- for esc close

	button:SetScript("OnLeave", OnLeave)
	button:SetScript("OnClick", function()
		if button.PullDownMenu:IsShown() then
			button.PullDownMenu:Hide()
			button.PullDownButtonExpand:SetTexCoord(unpack(Textures.Expand.coords))
		else
			button.PullDownMenu:Show()
			button.PullDownButtonExpand:SetTexCoord(unpack(Textures.Collapse.coords))
		end
	end)
end
-- Template PullDownMenu END ----------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:InitOptions()
	SlashCmdList["BATTLEGROUNDTARGETS"] = function()
		BattlegroundTargets:Frame_Toggle(GVAR.OptionsFrame)
	end
	SLASH_BATTLEGROUNDTARGETS1 = "/bgt"
	SLASH_BATTLEGROUNDTARGETS2 = "/bgtargets"
	SLASH_BATTLEGROUNDTARGETS3 = "/battlegroundtargets"

	if BattlegroundTargets_Options.version == nil then
		BattlegroundTargets_Options.version = 14
	end

	if BattlegroundTargets_Options.version == 1 then
		if BattlegroundTargets_Options.ButtonFontSize then
			if BattlegroundTargets_Options.ButtonFontSize[10] then
				if     BattlegroundTargets_Options.ButtonFontSize[10] == 1 then BattlegroundTargets_Options.ButtonFontSize[10] =  9
				elseif BattlegroundTargets_Options.ButtonFontSize[10] == 2 then BattlegroundTargets_Options.ButtonFontSize[10] = 10
				elseif BattlegroundTargets_Options.ButtonFontSize[10] == 3 then BattlegroundTargets_Options.ButtonFontSize[10] = 12
				elseif BattlegroundTargets_Options.ButtonFontSize[10] == 4 then BattlegroundTargets_Options.ButtonFontSize[10] = 14
				elseif BattlegroundTargets_Options.ButtonFontSize[10] == 5 then BattlegroundTargets_Options.ButtonFontSize[10] = 16
				end
			end
			if BattlegroundTargets_Options.ButtonFontSize[15] then
				if     BattlegroundTargets_Options.ButtonFontSize[15] == 1 then BattlegroundTargets_Options.ButtonFontSize[15] =  9
				elseif BattlegroundTargets_Options.ButtonFontSize[15] == 2 then BattlegroundTargets_Options.ButtonFontSize[15] = 10
				elseif BattlegroundTargets_Options.ButtonFontSize[15] == 3 then BattlegroundTargets_Options.ButtonFontSize[15] = 12
				elseif BattlegroundTargets_Options.ButtonFontSize[15] == 4 then BattlegroundTargets_Options.ButtonFontSize[15] = 14
				elseif BattlegroundTargets_Options.ButtonFontSize[15] == 5 then BattlegroundTargets_Options.ButtonFontSize[15] = 16
				end
			end
			if BattlegroundTargets_Options.ButtonFontSize[40] then
				if     BattlegroundTargets_Options.ButtonFontSize[40] == 1 then BattlegroundTargets_Options.ButtonFontSize[40] =  9
				elseif BattlegroundTargets_Options.ButtonFontSize[40] == 2 then BattlegroundTargets_Options.ButtonFontSize[40] = 10
				elseif BattlegroundTargets_Options.ButtonFontSize[40] == 3 then BattlegroundTargets_Options.ButtonFontSize[40] = 12
				elseif BattlegroundTargets_Options.ButtonFontSize[40] == 4 then BattlegroundTargets_Options.ButtonFontSize[40] = 14
				elseif BattlegroundTargets_Options.ButtonFontSize[40] == 5 then BattlegroundTargets_Options.ButtonFontSize[40] = 16
				end
			end
			Print("Fontsize update! Please check Configuration.")
		end
		BattlegroundTargets_Options.version = 2
	end

	if BattlegroundTargets_Options.version == 2 then
		if BattlegroundTargets_Options.ButtonShowCrosshairs then -- rename ButtonShowCrosshairs to ButtonShowTargetIndicator
			BattlegroundTargets_Options.ButtonShowTargetIndicator = {}
			if BattlegroundTargets_Options.ButtonShowCrosshairs[10] then BattlegroundTargets_Options.ButtonShowTargetIndicator[10] = true else BattlegroundTargets_Options.ButtonShowTargetIndicator[10] = false end
			if BattlegroundTargets_Options.ButtonShowCrosshairs[15] then BattlegroundTargets_Options.ButtonShowTargetIndicator[15] = true else BattlegroundTargets_Options.ButtonShowTargetIndicator[15] = false end
			if BattlegroundTargets_Options.ButtonShowCrosshairs[40] then BattlegroundTargets_Options.ButtonShowTargetIndicator[40] = true else BattlegroundTargets_Options.ButtonShowTargetIndicator[40] = false end
			BattlegroundTargets_Options.ButtonShowCrosshairs = nil
		end
		BattlegroundTargets_Options.version = 3
	end

	if BattlegroundTargets_Options.version == 3 then
		if BattlegroundTargets_Options.ButtonShowTargetIndicator then -- rename ButtonShowTargetIndicator to ButtonShowTarget
			BattlegroundTargets_Options.ButtonShowTarget = {}
			if BattlegroundTargets_Options.ButtonShowTargetIndicator[10] then BattlegroundTargets_Options.ButtonShowTarget[10] = true else BattlegroundTargets_Options.ButtonShowTarget[10] = false end
			if BattlegroundTargets_Options.ButtonShowTargetIndicator[15] then BattlegroundTargets_Options.ButtonShowTarget[15] = true else BattlegroundTargets_Options.ButtonShowTarget[15] = false end
			if BattlegroundTargets_Options.ButtonShowTargetIndicator[40] then BattlegroundTargets_Options.ButtonShowTarget[40] = true else BattlegroundTargets_Options.ButtonShowTarget[40] = false end
			BattlegroundTargets_Options.ButtonShowTargetIndicator = nil
		end
		if BattlegroundTargets_Options.ButtonShowFocusIndicator then -- rename ButtonShowFocusIndicator to ButtonShowFocus
			BattlegroundTargets_Options.ButtonShowFocus = {}
			if BattlegroundTargets_Options.ButtonShowFocusIndicator[10] then BattlegroundTargets_Options.ButtonShowFocus[10] = true else BattlegroundTargets_Options.ButtonShowFocus[10] = false end
			if BattlegroundTargets_Options.ButtonShowFocusIndicator[15] then BattlegroundTargets_Options.ButtonShowFocus[15] = true else BattlegroundTargets_Options.ButtonShowFocus[15] = false end
			if BattlegroundTargets_Options.ButtonShowFocusIndicator[40] then BattlegroundTargets_Options.ButtonShowFocus[40] = true else BattlegroundTargets_Options.ButtonShowFocus[40] = false end
			BattlegroundTargets_Options.ButtonShowFocusIndicator = nil
		end
		BattlegroundTargets_Options.version = 4
	end

	if BattlegroundTargets_Options.version == 4 then
		if BattlegroundTargets_Options.ButtonShowRealm then -- rename ButtonShowRealm to ButtonHideRealm
			BattlegroundTargets_Options.ButtonHideRealm = {}
			if BattlegroundTargets_Options.ButtonShowRealm[10] then BattlegroundTargets_Options.ButtonHideRealm[10] = false else BattlegroundTargets_Options.ButtonHideRealm[10] = true end
			if BattlegroundTargets_Options.ButtonShowRealm[15] then BattlegroundTargets_Options.ButtonHideRealm[15] = false else BattlegroundTargets_Options.ButtonHideRealm[15] = true end
			if BattlegroundTargets_Options.ButtonShowRealm[40] then BattlegroundTargets_Options.ButtonHideRealm[40] = false else BattlegroundTargets_Options.ButtonHideRealm[40] = true end
			BattlegroundTargets_Options.ButtonShowRealm = nil
		end
		BattlegroundTargets_Options.version = 5
	end

	if BattlegroundTargets_Options.version == 5 then
		if BattlegroundTargets_Options.ButtonSortBySize then -- rename ButtonSortBySize to ButtonSortBy
			BattlegroundTargets_Options.ButtonSortBy = {}
			if BattlegroundTargets_Options.ButtonSortBySize[10] then BattlegroundTargets_Options.ButtonSortBy[10] = BattlegroundTargets_Options.ButtonSortBySize[10] end
			if BattlegroundTargets_Options.ButtonSortBySize[15] then BattlegroundTargets_Options.ButtonSortBy[15] = BattlegroundTargets_Options.ButtonSortBySize[15] end
			if BattlegroundTargets_Options.ButtonSortBySize[40] then BattlegroundTargets_Options.ButtonSortBy[40] = BattlegroundTargets_Options.ButtonSortBySize[40] end
			BattlegroundTargets_Options.ButtonSortBySize = nil
		end
		local x
		if BattlegroundTargets_Options.ButtonTargetScale then
			if BattlegroundTargets_Options.ButtonTargetScale[10] > 2 then x=1 BattlegroundTargets_Options.ButtonTargetScale[10] = 2 end
			if BattlegroundTargets_Options.ButtonTargetScale[15] > 2 then x=1 BattlegroundTargets_Options.ButtonTargetScale[15] = 2 end
			if BattlegroundTargets_Options.ButtonTargetScale[40] > 2 then x=1 BattlegroundTargets_Options.ButtonTargetScale[40] = 2 end
		end
		if BattlegroundTargets_Options.ButtonFocusScale then
			if BattlegroundTargets_Options.ButtonFocusScale[10] > 2 then x=1 BattlegroundTargets_Options.ButtonFocusScale[10] = 2 end
			if BattlegroundTargets_Options.ButtonFocusScale[15] > 2 then x=1 BattlegroundTargets_Options.ButtonFocusScale[15] = 2 end
			if BattlegroundTargets_Options.ButtonFocusScale[40] > 2 then x=1 BattlegroundTargets_Options.ButtonFocusScale[40] = 2 end
		end
		if BattlegroundTargets_Options.ButtonFlagScale then
			if BattlegroundTargets_Options.ButtonFlagScale[10] > 2 then x=1 BattlegroundTargets_Options.ButtonFlagScale[10] = 2 end
			if BattlegroundTargets_Options.ButtonFlagScale[15] > 2 then x=1 BattlegroundTargets_Options.ButtonFlagScale[15] = 2 end
			if BattlegroundTargets_Options.ButtonFlagScale[40] > 2 then x=1 BattlegroundTargets_Options.ButtonFlagScale[40] = 2 end
		end
		if BattlegroundTargets_Options.ButtonAssistScale then
			if BattlegroundTargets_Options.ButtonAssistScale[10] > 2 then x=1 BattlegroundTargets_Options.ButtonAssistScale[10] = 2 end
			if BattlegroundTargets_Options.ButtonAssistScale[15] > 2 then x=1 BattlegroundTargets_Options.ButtonAssistScale[15] = 2 end
			if BattlegroundTargets_Options.ButtonAssistScale[40] > 2 then x=1 BattlegroundTargets_Options.ButtonAssistScale[40] = 2 end
		end
		if x then
			Print("Icon scale update! 200% is now maximum. Please check Configuration.")
		end
		BattlegroundTargets_Options.version = 6
	end

	if BattlegroundTargets_Options.version == 6 then
		if BattlegroundTargets_Options.ButtonShowHealthBar then -- update for health bar and health text independence
			if BattlegroundTargets_Options.ButtonShowHealthText[10] == true and BattlegroundTargets_Options.ButtonShowHealthBar[10] == false then
				BattlegroundTargets_Options.ButtonShowHealthText[10] = false
			end
			if BattlegroundTargets_Options.ButtonShowHealthText[15] == true and BattlegroundTargets_Options.ButtonShowHealthBar[15] == false then
				BattlegroundTargets_Options.ButtonShowHealthText[15] = false
			end
			if BattlegroundTargets_Options.ButtonShowHealthText[40] == true and BattlegroundTargets_Options.ButtonShowHealthBar[40] == false then
				BattlegroundTargets_Options.ButtonShowHealthText[40] = false
			end
		end
		BattlegroundTargets_Options.version = 7
	end

	if BattlegroundTargets_Options.version == 7 then
		if BattlegroundTargets_Options.ButtonEnableBracket then -- rename ButtonEnableBracket to EnableBracket
			BattlegroundTargets_Options.EnableBracket = {}
			if BattlegroundTargets_Options.ButtonEnableBracket[10] == true then BattlegroundTargets_Options.EnableBracket[10] = true else BattlegroundTargets_Options.EnableBracket[10] = false end
			if BattlegroundTargets_Options.ButtonEnableBracket[15] == true then BattlegroundTargets_Options.EnableBracket[15] = true else BattlegroundTargets_Options.EnableBracket[15] = false end
			if BattlegroundTargets_Options.ButtonEnableBracket[40] == true then BattlegroundTargets_Options.EnableBracket[40] = true else BattlegroundTargets_Options.EnableBracket[40] = false end
			BattlegroundTargets_Options.ButtonEnableBracket = nil
		end
		BattlegroundTargets_Options.version = 8
	end

	if BattlegroundTargets_Options.version == 8 then
		if BattlegroundTargets_Options.EnableBracket and BattlegroundTargets_Options.EnableBracket[40] then -- new user: default | old user: old setting
			BattlegroundTargets_Options.Layout40 = 18
		end
		BattlegroundTargets_Options.version = 9
	end

	if BattlegroundTargets_Options.version == 9 then
		BattlegroundTargets_Options.ButtonRangeAlpha = nil
		BattlegroundTargets_Options.version = 10
	end

	if BattlegroundTargets_Options.version == 10 then
		BattlegroundTargets_Options.TargetIcon = "bgt"
		BattlegroundTargets_Options.version = 11
	end

	if BattlegroundTargets_Options.version == 11 then
		if BattlegroundTargets_Options.Layout40 then -- copy old 40s settings to the new variable
			BattlegroundTargets_Options.LayoutTH = {}
			BattlegroundTargets_Options.LayoutTH[40] = BattlegroundTargets_Options.Layout40
			BattlegroundTargets_Options.Layout40 = nil
		end
		if BattlegroundTargets_Options.Layout40space then -- copy old 40s settings to the new variable
			BattlegroundTargets_Options.LayoutSpace = {}
			BattlegroundTargets_Options.LayoutSpace[40] = BattlegroundTargets_Options.Layout40space
			BattlegroundTargets_Options.Layout40space = nil
		end
		if BattlegroundTargets_Options.Summary == true then -- new summary settings
			BattlegroundTargets_Options.Summary = {}
			BattlegroundTargets_Options.Summary[10] = true
			BattlegroundTargets_Options.Summary[15] = true
			BattlegroundTargets_Options.Summary[40] = true
		else
			BattlegroundTargets_Options.Summary = nil
		end
		if BattlegroundTargets_Options.SummaryScale then -- new summary settings
			BattlegroundTargets_Options.SummaryScaleRole = {}
			BattlegroundTargets_Options.SummaryScaleRole[10] = BattlegroundTargets_Options.SummaryScale
			BattlegroundTargets_Options.SummaryScaleRole[15] = BattlegroundTargets_Options.SummaryScale
			BattlegroundTargets_Options.SummaryScaleRole[40] = BattlegroundTargets_Options.SummaryScale
			BattlegroundTargets_Options.SummaryScale = nil
		end
		BattlegroundTargets_Options.version = 12
	end

	if BattlegroundTargets_Options.version == 12 then -- fix mess with .version 12 summary settings (r107 has no false check)
		if BattlegroundTargets_Options.Summary == true then
			BattlegroundTargets_Options.Summary = {}
			BattlegroundTargets_Options.Summary[10] = true
			BattlegroundTargets_Options.Summary[15] = true
			BattlegroundTargets_Options.Summary[40] = true
		else
			BattlegroundTargets_Options.Summary = nil
		end
		BattlegroundTargets_Options.version = 13
	end

	if BattlegroundTargets_Options.version == 13 then -- range check option change
		BattlegroundTargets_Options.ButtonTypeRangeCheck = {}
		if BattlegroundTargets_Options.ButtonAvgRangeCheck then
			if BattlegroundTargets_Options.ButtonAvgRangeCheck[10] == true then BattlegroundTargets_Options.ButtonTypeRangeCheck[10] = 1 else BattlegroundTargets_Options.ButtonTypeRangeCheck[10] = 2 end
			if BattlegroundTargets_Options.ButtonAvgRangeCheck[15] == true then BattlegroundTargets_Options.ButtonTypeRangeCheck[15] = 1 else BattlegroundTargets_Options.ButtonTypeRangeCheck[15] = 2 end
			if BattlegroundTargets_Options.ButtonAvgRangeCheck[40] == true then BattlegroundTargets_Options.ButtonTypeRangeCheck[40] = 1 else BattlegroundTargets_Options.ButtonTypeRangeCheck[40] = 2 end
		elseif BattlegroundTargets_Options.ButtonClassRangeCheck then
			if BattlegroundTargets_Options.ButtonClassRangeCheck[10] == true then BattlegroundTargets_Options.ButtonTypeRangeCheck[10] = 2 else BattlegroundTargets_Options.ButtonTypeRangeCheck[10] = 1 end
			if BattlegroundTargets_Options.ButtonClassRangeCheck[15] == true then BattlegroundTargets_Options.ButtonTypeRangeCheck[15] = 2 else BattlegroundTargets_Options.ButtonTypeRangeCheck[15] = 1 end
			if BattlegroundTargets_Options.ButtonClassRangeCheck[40] == true then BattlegroundTargets_Options.ButtonTypeRangeCheck[40] = 2 else BattlegroundTargets_Options.ButtonTypeRangeCheck[40] = 1 end
		end
		BattlegroundTargets_Options.ButtonAvgRangeCheck = nil
		BattlegroundTargets_Options.ButtonClassRangeCheck = nil
		BattlegroundTargets_Options.version = 14
	end

	if BattlegroundTargets_Options.pos                        == nil then BattlegroundTargets_Options.pos                        = {}    end
	if BattlegroundTargets_Options.MinimapButton              == nil then BattlegroundTargets_Options.MinimapButton              = false end
	if BattlegroundTargets_Options.MinimapButtonPos           == nil then BattlegroundTargets_Options.MinimapButtonPos           = -90   end

	if BattlegroundTargets_Options.TargetIcon                 == nil then BattlegroundTargets_Options.TargetIcon                 = "default" end

	if BattlegroundTargets_Options.EnableBracket              == nil then BattlegroundTargets_Options.EnableBracket              = {}    end
	if BattlegroundTargets_Options.EnableBracket[10]          == nil then BattlegroundTargets_Options.EnableBracket[10]          = false end
	if BattlegroundTargets_Options.EnableBracket[15]          == nil then BattlegroundTargets_Options.EnableBracket[15]          = false end
	if BattlegroundTargets_Options.EnableBracket[40]          == nil then BattlegroundTargets_Options.EnableBracket[40]          = false end

	if BattlegroundTargets_Options.IndependentPositioning     == nil then BattlegroundTargets_Options.IndependentPositioning     = {}    end
	if BattlegroundTargets_Options.IndependentPositioning[10] == nil then BattlegroundTargets_Options.IndependentPositioning[10] = false end
	if BattlegroundTargets_Options.IndependentPositioning[15] == nil then BattlegroundTargets_Options.IndependentPositioning[15] = false end
	if BattlegroundTargets_Options.IndependentPositioning[40] == nil then BattlegroundTargets_Options.IndependentPositioning[40] = false end

	if BattlegroundTargets_Options.LayoutTH                   == nil then BattlegroundTargets_Options.LayoutTH                   = {}    end
	if BattlegroundTargets_Options.LayoutTH[10]               == nil then BattlegroundTargets_Options.LayoutTH[10]               = 18    end
	if BattlegroundTargets_Options.LayoutTH[15]               == nil then BattlegroundTargets_Options.LayoutTH[15]               = 18    end
	if BattlegroundTargets_Options.LayoutTH[40]               == nil then BattlegroundTargets_Options.LayoutTH[40]               = 24    end
	if BattlegroundTargets_Options.LayoutSpace                == nil then BattlegroundTargets_Options.LayoutSpace                = {}    end
	if BattlegroundTargets_Options.LayoutSpace[10]            == nil then BattlegroundTargets_Options.LayoutSpace[10]            = 0     end
	if BattlegroundTargets_Options.LayoutSpace[15]            == nil then BattlegroundTargets_Options.LayoutSpace[15]            = 0     end
	if BattlegroundTargets_Options.LayoutSpace[40]            == nil then BattlegroundTargets_Options.LayoutSpace[40]            = 0     end
	if BattlegroundTargets_Options.LayoutButtonSpace          == nil then BattlegroundTargets_Options.LayoutButtonSpace          = {}    end
	if BattlegroundTargets_Options.LayoutButtonSpace[10]      == nil then BattlegroundTargets_Options.LayoutButtonSpace[10]      = 0     end
	if BattlegroundTargets_Options.LayoutButtonSpace[15]      == nil then BattlegroundTargets_Options.LayoutButtonSpace[15]      = 0     end
	if BattlegroundTargets_Options.LayoutButtonSpace[40]      == nil then BattlegroundTargets_Options.LayoutButtonSpace[40]      = 0     end

	if BattlegroundTargets_Options.Summary                    == nil then BattlegroundTargets_Options.Summary                    = {}    end
	if BattlegroundTargets_Options.Summary[10]                == nil then BattlegroundTargets_Options.Summary[10]                = false end
	if BattlegroundTargets_Options.Summary[15]                == nil then BattlegroundTargets_Options.Summary[15]                = false end
	if BattlegroundTargets_Options.Summary[40]                == nil then BattlegroundTargets_Options.Summary[40]                = false end
	if BattlegroundTargets_Options.SummaryScaleRole           == nil then BattlegroundTargets_Options.SummaryScaleRole           = {}    end
	if BattlegroundTargets_Options.SummaryScaleRole[10]       == nil then BattlegroundTargets_Options.SummaryScaleRole[10]       = 0.6   end
	if BattlegroundTargets_Options.SummaryScaleRole[15]       == nil then BattlegroundTargets_Options.SummaryScaleRole[15]       = 0.6   end
	if BattlegroundTargets_Options.SummaryScaleRole[40]       == nil then BattlegroundTargets_Options.SummaryScaleRole[40]       = 0.5   end
	if BattlegroundTargets_Options.SummaryScaleGuildGroup     == nil then BattlegroundTargets_Options.SummaryScaleGuildGroup     = {}    end
	if BattlegroundTargets_Options.SummaryScaleGuildGroup[10] == nil then BattlegroundTargets_Options.SummaryScaleGuildGroup[10] = 1.25  end
	if BattlegroundTargets_Options.SummaryScaleGuildGroup[15] == nil then BattlegroundTargets_Options.SummaryScaleGuildGroup[15] = 1.25  end
	if BattlegroundTargets_Options.SummaryScaleGuildGroup[40] == nil then BattlegroundTargets_Options.SummaryScaleGuildGroup[40] = 1.4   end

	if BattlegroundTargets_Options.ButtonShowRole               == nil then BattlegroundTargets_Options.ButtonShowRole               = {}    end
	if BattlegroundTargets_Options.ButtonShowSpec               == nil then BattlegroundTargets_Options.ButtonShowSpec               = {}    end
	if BattlegroundTargets_Options.ButtonClassIcon              == nil then BattlegroundTargets_Options.ButtonClassIcon              = {}    end
	if BattlegroundTargets_Options.ButtonHideRealm              == nil then BattlegroundTargets_Options.ButtonHideRealm              = {}    end
	if BattlegroundTargets_Options.ButtonShowLeader             == nil then BattlegroundTargets_Options.ButtonShowLeader             = {}    end
	if BattlegroundTargets_Options.ButtonShowGuildGroup         == nil then BattlegroundTargets_Options.ButtonShowGuildGroup         = {}    end
	if BattlegroundTargets_Options.ButtonGuildGroupPosition     == nil then BattlegroundTargets_Options.ButtonGuildGroupPosition     = {}    end
	if BattlegroundTargets_Options.ButtonShowTarget             == nil then BattlegroundTargets_Options.ButtonShowTarget             = {}    end
	if BattlegroundTargets_Options.ButtonTargetScale            == nil then BattlegroundTargets_Options.ButtonTargetScale            = {}    end
	if BattlegroundTargets_Options.ButtonTargetPosition         == nil then BattlegroundTargets_Options.ButtonTargetPosition         = {}    end
	if BattlegroundTargets_Options.ButtonShowAssist             == nil then BattlegroundTargets_Options.ButtonShowAssist             = {}    end
	if BattlegroundTargets_Options.ButtonAssistScale            == nil then BattlegroundTargets_Options.ButtonAssistScale            = {}    end
	if BattlegroundTargets_Options.ButtonAssistPosition         == nil then BattlegroundTargets_Options.ButtonAssistPosition         = {}    end
	if BattlegroundTargets_Options.ButtonShowFocus              == nil then BattlegroundTargets_Options.ButtonShowFocus              = {}    end
	if BattlegroundTargets_Options.ButtonFocusScale             == nil then BattlegroundTargets_Options.ButtonFocusScale             = {}    end
	if BattlegroundTargets_Options.ButtonFocusPosition          == nil then BattlegroundTargets_Options.ButtonFocusPosition          = {}    end
	if BattlegroundTargets_Options.ButtonShowFlag               == nil then BattlegroundTargets_Options.ButtonShowFlag               = {}    end
	if BattlegroundTargets_Options.ButtonFlagScale              == nil then BattlegroundTargets_Options.ButtonFlagScale              = {}    end
	if BattlegroundTargets_Options.ButtonFlagPosition           == nil then BattlegroundTargets_Options.ButtonFlagPosition           = {}    end
	if BattlegroundTargets_Options.ButtonShowTargetCount        == nil then BattlegroundTargets_Options.ButtonShowTargetCount        = {}    end
	if BattlegroundTargets_Options.ButtonShowHealthBar          == nil then BattlegroundTargets_Options.ButtonShowHealthBar          = {}    end
	if BattlegroundTargets_Options.ButtonShowHealthText         == nil then BattlegroundTargets_Options.ButtonShowHealthText         = {}    end
	if BattlegroundTargets_Options.ButtonRangeCheck             == nil then BattlegroundTargets_Options.ButtonRangeCheck             = {}    end
	if BattlegroundTargets_Options.ButtonTypeRangeCheck         == nil then BattlegroundTargets_Options.ButtonTypeRangeCheck         = {}    end
	if BattlegroundTargets_Options.ButtonRangeDisplay           == nil then BattlegroundTargets_Options.ButtonRangeDisplay           = {}    end
	if BattlegroundTargets_Options.ButtonSortBy                 == nil then BattlegroundTargets_Options.ButtonSortBy                 = {}    end
	if BattlegroundTargets_Options.ButtonSortDetail             == nil then BattlegroundTargets_Options.ButtonSortDetail             = {}    end
	if BattlegroundTargets_Options.ButtonFontSize               == nil then BattlegroundTargets_Options.ButtonFontSize               = {}    end
	if BattlegroundTargets_Options.ButtonScale                  == nil then BattlegroundTargets_Options.ButtonScale                  = {}    end
	if BattlegroundTargets_Options.ButtonWidth                  == nil then BattlegroundTargets_Options.ButtonWidth                  = {}    end
	if BattlegroundTargets_Options.ButtonHeight                 == nil then BattlegroundTargets_Options.ButtonHeight                 = {}    end

	if BattlegroundTargets_Options.ButtonShowRole[10]           == nil then BattlegroundTargets_Options.ButtonShowRole[10]           = true  end
	if BattlegroundTargets_Options.ButtonShowSpec[10]           == nil then BattlegroundTargets_Options.ButtonShowSpec[10]           = false end
	if BattlegroundTargets_Options.ButtonClassIcon[10]          == nil then BattlegroundTargets_Options.ButtonClassIcon[10]          = false end
	if BattlegroundTargets_Options.ButtonHideRealm[10]          == nil then BattlegroundTargets_Options.ButtonHideRealm[10]          = false end
	if BattlegroundTargets_Options.ButtonShowLeader[10]         == nil then BattlegroundTargets_Options.ButtonShowLeader[10]         = false end
	if BattlegroundTargets_Options.ButtonShowGuildGroup[10]     == nil then BattlegroundTargets_Options.ButtonShowGuildGroup[10]     = false end
	if BattlegroundTargets_Options.ButtonGuildGroupPosition[10] == nil then BattlegroundTargets_Options.ButtonGuildGroupPosition[10] = 4     end
	if BattlegroundTargets_Options.ButtonShowTarget[10]         == nil then BattlegroundTargets_Options.ButtonShowTarget[10]         = true  end
	if BattlegroundTargets_Options.ButtonTargetScale[10]        == nil then BattlegroundTargets_Options.ButtonTargetScale[10]        = 1.5   end
	if BattlegroundTargets_Options.ButtonTargetPosition[10]     == nil then BattlegroundTargets_Options.ButtonTargetPosition[10]     = 100   end
	if BattlegroundTargets_Options.ButtonShowAssist[10]         == nil then BattlegroundTargets_Options.ButtonShowAssist[10]         = false end
	if BattlegroundTargets_Options.ButtonAssistScale[10]        == nil then BattlegroundTargets_Options.ButtonAssistScale[10]        = 1.2   end
	if BattlegroundTargets_Options.ButtonAssistPosition[10]     == nil then BattlegroundTargets_Options.ButtonAssistPosition[10]     = 70    end
	if BattlegroundTargets_Options.ButtonShowFocus[10]          == nil then BattlegroundTargets_Options.ButtonShowFocus[10]          = false end
	if BattlegroundTargets_Options.ButtonFocusScale[10]         == nil then BattlegroundTargets_Options.ButtonFocusScale[10]         = 1     end
	if BattlegroundTargets_Options.ButtonFocusPosition[10]      == nil then BattlegroundTargets_Options.ButtonFocusPosition[10]      = 65    end
	if BattlegroundTargets_Options.ButtonShowFlag[10]           == nil then BattlegroundTargets_Options.ButtonShowFlag[10]           = true  end
	if BattlegroundTargets_Options.ButtonFlagScale[10]          == nil then BattlegroundTargets_Options.ButtonFlagScale[10]          = 1.2   end
	if BattlegroundTargets_Options.ButtonFlagPosition[10]       == nil then BattlegroundTargets_Options.ButtonFlagPosition[10]       = 55    end
	if BattlegroundTargets_Options.ButtonShowTargetCount[10]    == nil then BattlegroundTargets_Options.ButtonShowTargetCount[10]    = false end
	if BattlegroundTargets_Options.ButtonShowHealthBar[10]      == nil then BattlegroundTargets_Options.ButtonShowHealthBar[10]      = false end
	if BattlegroundTargets_Options.ButtonShowHealthText[10]     == nil then BattlegroundTargets_Options.ButtonShowHealthText[10]     = false end
	if BattlegroundTargets_Options.ButtonRangeCheck[10]         == nil then BattlegroundTargets_Options.ButtonRangeCheck[10]         = false end
	if BattlegroundTargets_Options.ButtonTypeRangeCheck[10]     == nil then BattlegroundTargets_Options.ButtonTypeRangeCheck[10]     = 2     end
	if BattlegroundTargets_Options.ButtonRangeDisplay[10]       == nil then BattlegroundTargets_Options.ButtonRangeDisplay[10]       = 1     end
	if BattlegroundTargets_Options.ButtonSortBy[10]             == nil then BattlegroundTargets_Options.ButtonSortBy[10]             = 1     end
	if BattlegroundTargets_Options.ButtonSortDetail[10]         == nil then BattlegroundTargets_Options.ButtonSortDetail[10]         = 3     end
	if BattlegroundTargets_Options.ButtonFontSize[10]           == nil then BattlegroundTargets_Options.ButtonFontSize[10]           = 10    end
	if BattlegroundTargets_Options.ButtonScale[10]              == nil then BattlegroundTargets_Options.ButtonScale[10]              = 1     end
	if BattlegroundTargets_Options.ButtonWidth[10]              == nil then BattlegroundTargets_Options.ButtonWidth[10]              = 150   end
	if BattlegroundTargets_Options.ButtonHeight[10]             == nil then BattlegroundTargets_Options.ButtonHeight[10]             = 18    end

	if BattlegroundTargets_Options.ButtonShowRole[15]           == nil then BattlegroundTargets_Options.ButtonShowRole[15]           = true  end
	if BattlegroundTargets_Options.ButtonShowSpec[15]           == nil then BattlegroundTargets_Options.ButtonShowSpec[15]           = false end
	if BattlegroundTargets_Options.ButtonClassIcon[15]          == nil then BattlegroundTargets_Options.ButtonClassIcon[15]          = false end
	if BattlegroundTargets_Options.ButtonHideRealm[15]          == nil then BattlegroundTargets_Options.ButtonHideRealm[15]          = false end
	if BattlegroundTargets_Options.ButtonShowLeader[15]         == nil then BattlegroundTargets_Options.ButtonShowLeader[15]         = false end
	if BattlegroundTargets_Options.ButtonShowGuildGroup[15]     == nil then BattlegroundTargets_Options.ButtonShowGuildGroup[15]     = false end
	if BattlegroundTargets_Options.ButtonGuildGroupPosition[15] == nil then BattlegroundTargets_Options.ButtonGuildGroupPosition[15] = 4     end
	if BattlegroundTargets_Options.ButtonShowTarget[15]         == nil then BattlegroundTargets_Options.ButtonShowTarget[15]         = true  end
	if BattlegroundTargets_Options.ButtonTargetScale[15]        == nil then BattlegroundTargets_Options.ButtonTargetScale[15]        = 1.5   end
	if BattlegroundTargets_Options.ButtonTargetPosition[15]     == nil then BattlegroundTargets_Options.ButtonTargetPosition[15]     = 70    end
	if BattlegroundTargets_Options.ButtonShowAssist[15]         == nil then BattlegroundTargets_Options.ButtonShowAssist[15]         = false end
	if BattlegroundTargets_Options.ButtonAssistScale[15]        == nil then BattlegroundTargets_Options.ButtonAssistScale[15]        = 1.2   end
	if BattlegroundTargets_Options.ButtonAssistPosition[15]     == nil then BattlegroundTargets_Options.ButtonAssistPosition[15]     = 100   end
	if BattlegroundTargets_Options.ButtonShowFocus[15]          == nil then BattlegroundTargets_Options.ButtonShowFocus[15]          = false end
	if BattlegroundTargets_Options.ButtonFocusScale[15]         == nil then BattlegroundTargets_Options.ButtonFocusScale[15]         = 1     end
	if BattlegroundTargets_Options.ButtonFocusPosition[15]      == nil then BattlegroundTargets_Options.ButtonFocusPosition[15]      = 65    end
	if BattlegroundTargets_Options.ButtonShowFlag[15]           == nil then BattlegroundTargets_Options.ButtonShowFlag[15]           = true  end
	if BattlegroundTargets_Options.ButtonFlagScale[15]          == nil then BattlegroundTargets_Options.ButtonFlagScale[15]          = 1.2   end
	if BattlegroundTargets_Options.ButtonFlagPosition[15]       == nil then BattlegroundTargets_Options.ButtonFlagPosition[15]       = 55    end
	if BattlegroundTargets_Options.ButtonShowTargetCount[15]    == nil then BattlegroundTargets_Options.ButtonShowTargetCount[15]    = false end
	if BattlegroundTargets_Options.ButtonShowHealthBar[15]      == nil then BattlegroundTargets_Options.ButtonShowHealthBar[15]      = false end
	if BattlegroundTargets_Options.ButtonShowHealthText[15]     == nil then BattlegroundTargets_Options.ButtonShowHealthText[15]     = false end
	if BattlegroundTargets_Options.ButtonRangeCheck[15]         == nil then BattlegroundTargets_Options.ButtonRangeCheck[15]         = false end
	if BattlegroundTargets_Options.ButtonTypeRangeCheck[15]     == nil then BattlegroundTargets_Options.ButtonTypeRangeCheck[15]     = 2     end
	if BattlegroundTargets_Options.ButtonRangeDisplay[15]       == nil then BattlegroundTargets_Options.ButtonRangeDisplay[15]       = 1     end
	if BattlegroundTargets_Options.ButtonSortBy[15]             == nil then BattlegroundTargets_Options.ButtonSortBy[15]             = 1     end
	if BattlegroundTargets_Options.ButtonSortDetail[15]         == nil then BattlegroundTargets_Options.ButtonSortDetail[15]         = 3     end
	if BattlegroundTargets_Options.ButtonFontSize[15]           == nil then BattlegroundTargets_Options.ButtonFontSize[15]           = 10    end
	if BattlegroundTargets_Options.ButtonScale[15]              == nil then BattlegroundTargets_Options.ButtonScale[15]              = 1     end
	if BattlegroundTargets_Options.ButtonWidth[15]              == nil then BattlegroundTargets_Options.ButtonWidth[15]              = 150   end
	if BattlegroundTargets_Options.ButtonHeight[15]             == nil then BattlegroundTargets_Options.ButtonHeight[15]             = 18    end

	if BattlegroundTargets_Options.ButtonShowRole[40]           == nil then BattlegroundTargets_Options.ButtonShowRole[40]           = true  end
	if BattlegroundTargets_Options.ButtonShowSpec[40]           == nil then BattlegroundTargets_Options.ButtonShowSpec[40]           = false end
	if BattlegroundTargets_Options.ButtonClassIcon[40]          == nil then BattlegroundTargets_Options.ButtonClassIcon[40]          = false end
	if BattlegroundTargets_Options.ButtonHideRealm[40]          == nil then BattlegroundTargets_Options.ButtonHideRealm[40]          = true  end
	if BattlegroundTargets_Options.ButtonShowLeader[40]         == nil then BattlegroundTargets_Options.ButtonShowLeader[40]         = false end
	if BattlegroundTargets_Options.ButtonShowGuildGroup[40]     == nil then BattlegroundTargets_Options.ButtonShowGuildGroup[40]     = false end
	if BattlegroundTargets_Options.ButtonGuildGroupPosition[40] == nil then BattlegroundTargets_Options.ButtonGuildGroupPosition[40] = 4     end
	if BattlegroundTargets_Options.ButtonShowTarget[40]         == nil then BattlegroundTargets_Options.ButtonShowTarget[40]         = true  end
	if BattlegroundTargets_Options.ButtonTargetScale[40]        == nil then BattlegroundTargets_Options.ButtonTargetScale[40]        = 1     end
	if BattlegroundTargets_Options.ButtonTargetPosition[40]     == nil then BattlegroundTargets_Options.ButtonTargetPosition[40]     = 85    end
	if BattlegroundTargets_Options.ButtonShowAssist[40]         == nil then BattlegroundTargets_Options.ButtonShowAssist[40]         = false end
	if BattlegroundTargets_Options.ButtonAssistScale[40]        == nil then BattlegroundTargets_Options.ButtonAssistScale[40]        = 1     end
	if BattlegroundTargets_Options.ButtonAssistPosition[40]     == nil then BattlegroundTargets_Options.ButtonAssistPosition[40]     = 70    end
	if BattlegroundTargets_Options.ButtonShowFocus[40]          == nil then BattlegroundTargets_Options.ButtonShowFocus[40]          = false end
	if BattlegroundTargets_Options.ButtonFocusScale[40]         == nil then BattlegroundTargets_Options.ButtonFocusScale[40]         = 1     end
	if BattlegroundTargets_Options.ButtonFocusPosition[40]      == nil then BattlegroundTargets_Options.ButtonFocusPosition[40]      = 55    end
	if BattlegroundTargets_Options.ButtonShowFlag[40]           == nil then BattlegroundTargets_Options.ButtonShowFlag[40]           = false end
	if BattlegroundTargets_Options.ButtonFlagScale[40]          == nil then BattlegroundTargets_Options.ButtonFlagScale[40]          = 1     end
	if BattlegroundTargets_Options.ButtonFlagPosition[40]       == nil then BattlegroundTargets_Options.ButtonFlagPosition[40]       = 100   end
	if BattlegroundTargets_Options.ButtonShowTargetCount[40]    == nil then BattlegroundTargets_Options.ButtonShowTargetCount[40]    = false end
	if BattlegroundTargets_Options.ButtonShowHealthBar[40]      == nil then BattlegroundTargets_Options.ButtonShowHealthBar[40]      = false end
	if BattlegroundTargets_Options.ButtonShowHealthText[40]     == nil then BattlegroundTargets_Options.ButtonShowHealthText[40]     = false end
	if BattlegroundTargets_Options.ButtonRangeCheck[40]         == nil then BattlegroundTargets_Options.ButtonRangeCheck[40]         = false end
	if BattlegroundTargets_Options.ButtonTypeRangeCheck[40]     == nil then BattlegroundTargets_Options.ButtonTypeRangeCheck[40]     = 2     end
	if BattlegroundTargets_Options.ButtonRangeDisplay[40]       == nil then BattlegroundTargets_Options.ButtonRangeDisplay[40]       = 9     end
	if BattlegroundTargets_Options.ButtonSortBy[40]             == nil then BattlegroundTargets_Options.ButtonSortBy[40]             = 1     end
	if BattlegroundTargets_Options.ButtonSortDetail[40]         == nil then BattlegroundTargets_Options.ButtonSortDetail[40]         = 3     end
	if BattlegroundTargets_Options.ButtonFontSize[40]           == nil then BattlegroundTargets_Options.ButtonFontSize[40]           = 10    end
	if BattlegroundTargets_Options.ButtonScale[40]              == nil then BattlegroundTargets_Options.ButtonScale[40]              = 1     end
	if BattlegroundTargets_Options.ButtonWidth[40]              == nil then BattlegroundTargets_Options.ButtonWidth[40]              = 100   end
	if BattlegroundTargets_Options.ButtonHeight[40]             == nil then BattlegroundTargets_Options.ButtonHeight[40]             = 16    end

	for i = 1, #bgSizeINT do
		local sz = bgSizeINT[i]
		if not OPT.ButtonShowRole           then OPT.ButtonShowRole           = {} end OPT.ButtonShowRole[sz]           = BattlegroundTargets_Options.ButtonShowRole[sz]
		if not OPT.ButtonShowSpec           then OPT.ButtonShowSpec           = {} end OPT.ButtonShowSpec[sz]           = BattlegroundTargets_Options.ButtonShowSpec[sz]
		if not OPT.ButtonClassIcon          then OPT.ButtonClassIcon          = {} end OPT.ButtonClassIcon[sz]          = BattlegroundTargets_Options.ButtonClassIcon[sz]
		if not OPT.ButtonHideRealm          then OPT.ButtonHideRealm          = {} end OPT.ButtonHideRealm[sz]          = BattlegroundTargets_Options.ButtonHideRealm[sz]
		if not OPT.ButtonShowLeader         then OPT.ButtonShowLeader         = {} end OPT.ButtonShowLeader[sz]         = BattlegroundTargets_Options.ButtonShowLeader[sz]
		if not OPT.ButtonShowGuildGroup     then OPT.ButtonShowGuildGroup     = {} end OPT.ButtonShowGuildGroup[sz]     = BattlegroundTargets_Options.ButtonShowGuildGroup[sz]
		if not OPT.ButtonGuildGroupPosition then OPT.ButtonGuildGroupPosition = {} end OPT.ButtonGuildGroupPosition[sz] = BattlegroundTargets_Options.ButtonGuildGroupPosition[sz]
		if not OPT.ButtonShowTarget         then OPT.ButtonShowTarget         = {} end OPT.ButtonShowTarget[sz]         = BattlegroundTargets_Options.ButtonShowTarget[sz]
		if not OPT.ButtonTargetScale        then OPT.ButtonTargetScale        = {} end OPT.ButtonTargetScale[sz]        = BattlegroundTargets_Options.ButtonTargetScale[sz]
		if not OPT.ButtonTargetPosition     then OPT.ButtonTargetPosition     = {} end OPT.ButtonTargetPosition[sz]     = BattlegroundTargets_Options.ButtonTargetPosition[sz]
		if not OPT.ButtonShowAssist         then OPT.ButtonShowAssist         = {} end OPT.ButtonShowAssist[sz]         = BattlegroundTargets_Options.ButtonShowAssist[sz]
		if not OPT.ButtonAssistScale        then OPT.ButtonAssistScale        = {} end OPT.ButtonAssistScale[sz]        = BattlegroundTargets_Options.ButtonAssistScale[sz]
		if not OPT.ButtonAssistPosition     then OPT.ButtonAssistPosition     = {} end OPT.ButtonAssistPosition[sz]     = BattlegroundTargets_Options.ButtonAssistPosition[sz]
		if not OPT.ButtonShowFocus          then OPT.ButtonShowFocus          = {} end OPT.ButtonShowFocus[sz]          = BattlegroundTargets_Options.ButtonShowFocus[sz]
		if not OPT.ButtonFocusScale         then OPT.ButtonFocusScale         = {} end OPT.ButtonFocusScale[sz]         = BattlegroundTargets_Options.ButtonFocusScale[sz]
		if not OPT.ButtonFocusPosition      then OPT.ButtonFocusPosition      = {} end OPT.ButtonFocusPosition[sz]      = BattlegroundTargets_Options.ButtonFocusPosition[sz]
		if not OPT.ButtonShowFlag           then OPT.ButtonShowFlag           = {} end OPT.ButtonShowFlag[sz]           = BattlegroundTargets_Options.ButtonShowFlag[sz]
		if not OPT.ButtonFlagScale          then OPT.ButtonFlagScale          = {} end OPT.ButtonFlagScale[sz]          = BattlegroundTargets_Options.ButtonFlagScale[sz]
		if not OPT.ButtonFlagPosition       then OPT.ButtonFlagPosition       = {} end OPT.ButtonFlagPosition[sz]       = BattlegroundTargets_Options.ButtonFlagPosition[sz]
		if not OPT.ButtonShowTargetCount    then OPT.ButtonShowTargetCount    = {} end OPT.ButtonShowTargetCount[sz]    = BattlegroundTargets_Options.ButtonShowTargetCount[sz]
		if not OPT.ButtonShowHealthBar      then OPT.ButtonShowHealthBar      = {} end OPT.ButtonShowHealthBar[sz]      = BattlegroundTargets_Options.ButtonShowHealthBar[sz]
		if not OPT.ButtonShowHealthText     then OPT.ButtonShowHealthText     = {} end OPT.ButtonShowHealthText[sz]     = BattlegroundTargets_Options.ButtonShowHealthText[sz]
		if not OPT.ButtonRangeCheck         then OPT.ButtonRangeCheck         = {} end OPT.ButtonRangeCheck[sz]         = BattlegroundTargets_Options.ButtonRangeCheck[sz]
		if not OPT.ButtonTypeRangeCheck     then OPT.ButtonTypeRangeCheck     = {} end OPT.ButtonTypeRangeCheck[sz]     = BattlegroundTargets_Options.ButtonTypeRangeCheck[sz]
		if not OPT.ButtonRangeDisplay       then OPT.ButtonRangeDisplay       = {} end OPT.ButtonRangeDisplay[sz]       = BattlegroundTargets_Options.ButtonRangeDisplay[sz]
		if not OPT.ButtonSortBy             then OPT.ButtonSortBy             = {} end OPT.ButtonSortBy[sz]             = BattlegroundTargets_Options.ButtonSortBy[sz]
		if not OPT.ButtonSortDetail         then OPT.ButtonSortDetail         = {} end OPT.ButtonSortDetail[sz]         = BattlegroundTargets_Options.ButtonSortDetail[sz]
		if not OPT.ButtonFontSize           then OPT.ButtonFontSize           = {} end OPT.ButtonFontSize[sz]           = BattlegroundTargets_Options.ButtonFontSize[sz]
		if not OPT.ButtonScale              then OPT.ButtonScale              = {} end OPT.ButtonScale[sz]              = BattlegroundTargets_Options.ButtonScale[sz]
		if not OPT.ButtonWidth              then OPT.ButtonWidth              = {} end OPT.ButtonWidth[sz]              = BattlegroundTargets_Options.ButtonWidth[sz]
		if not OPT.ButtonHeight             then OPT.ButtonHeight             = {} end OPT.ButtonHeight[sz]             = BattlegroundTargets_Options.ButtonHeight[sz]
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:LDBcheck()
	if LibStub and LibStub:GetLibrary("CallbackHandler-1.0", true) and LibStub:GetLibrary("LibDataBroker-1.1", true) then
		LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("BattlegroundTargets", {
			type = "launcher",
			icon = AddonIcon,
			OnClick = function(self, button)
				BattlegroundTargets:Frame_Toggle(GVAR.OptionsFrame)
			end,
		})
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CreateInterfaceOptions()
	GVAR.InterfaceOptions = CreateFrame("Frame", "BattlegroundTargets_InterfaceOptions")
	GVAR.InterfaceOptions.name = "BattlegroundTargets"

	GVAR.InterfaceOptions.Title = GVAR.InterfaceOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	GVAR.InterfaceOptions.Title:SetText("BattlegroundTargets")
	GVAR.InterfaceOptions.Title:SetJustifyH("LEFT")
	GVAR.InterfaceOptions.Title:SetJustifyV("TOP")
	GVAR.InterfaceOptions.Title:SetPoint("TOPLEFT", 16, -16)

	GVAR.InterfaceOptions.CONFIG = CreateFrame("Button", nil, GVAR.InterfaceOptions)
	TEMPLATE.TextButton(GVAR.InterfaceOptions.CONFIG, L["Open Configuration"], 1)
	GVAR.InterfaceOptions.CONFIG:SetWidth(180)
	GVAR.InterfaceOptions.CONFIG:SetHeight(22)
	GVAR.InterfaceOptions.CONFIG:SetPoint("TOPLEFT", GVAR.InterfaceOptions.Title, "BOTTOMLEFT", 0, -10)
	GVAR.InterfaceOptions.CONFIG:SetScript("OnClick", function()
		InterfaceOptionsFrame_Show()
		HideUIPanel(GameMenuFrame)
		BattlegroundTargets:Frame_Toggle(GVAR.OptionsFrame)
	end)

	GVAR.InterfaceOptions.SlashCommandText = GVAR.InterfaceOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.InterfaceOptions.SlashCommandText:SetText("/bgt - /bgtargets - /battlegroundtargets")
	GVAR.InterfaceOptions.SlashCommandText:SetNonSpaceWrap(true)
	GVAR.InterfaceOptions.SlashCommandText:SetPoint("LEFT", GVAR.InterfaceOptions.CONFIG, "RIGHT", 10, 0)
	GVAR.InterfaceOptions.SlashCommandText:SetTextColor(1, 1, 0.49, 1)

	InterfaceOptions_AddCategory(GVAR.InterfaceOptions)
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CreateFrames()
	GVAR.MainFrame = CreateFrame("Frame", "BattlegroundTargets_MainFrame", UIParent)
	TEMPLATE.BorderTRBL(GVAR.MainFrame)
	GVAR.MainFrame:EnableMouse(true)
	GVAR.MainFrame:SetMovable(true)
	GVAR.MainFrame:SetResizable(true)
	GVAR.MainFrame:SetToplevel(true)
	GVAR.MainFrame:SetClampedToScreen(true)
	GVAR.MainFrame:SetWidth(150)
	GVAR.MainFrame:SetHeight(20)
	GVAR.MainFrame:SetScript("OnShow", function() BattlegroundTargets:MainFrameShow() end)
	GVAR.MainFrame:SetScript("OnEnter", function() GVAR.MainFrame.Movetext:SetTextColor(1, 1, 1, 1) end)
	GVAR.MainFrame:SetScript("OnLeave", function() GVAR.MainFrame.Movetext:SetTextColor(0.3, 0.3, 0.3, 1) end)
	GVAR.MainFrame:SetScript("OnMouseDown", function()
		if inCombat or InCombatLockdown() then return end
		GVAR.MainFrame:StartMoving()
	end)
	GVAR.MainFrame:SetScript("OnMouseUp", function()
		if inCombat or InCombatLockdown() then return end
		GVAR.MainFrame:StopMovingOrSizing()
		BattlegroundTargets:Frame_SavePosition("BattlegroundTargets_MainFrame")
	end)
	GVAR.MainFrame:Hide()

	GVAR.MainFrame.Movetext = GVAR.MainFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.MainFrame.Movetext:SetWidth(150)
	GVAR.MainFrame.Movetext:SetHeight(20)
	GVAR.MainFrame.Movetext:SetPoint("CENTER", 0, 0)
	GVAR.MainFrame.Movetext:SetJustifyH("CENTER")
	GVAR.MainFrame.Movetext:SetText(L["click & move"])
	GVAR.MainFrame.Movetext:SetTextColor(0.3, 0.3, 0.3, 1)

	local function OnEnter(self)
		self.HighlightT:SetTexture(1, 1, 0.49, 1)
		self.HighlightR:SetTexture(1, 1, 0.49, 1)
		self.HighlightB:SetTexture(1, 1, 0.49, 1)
		self.HighlightL:SetTexture(1, 1, 0.49, 1)
	end
	local function OnLeave(self)
		if isTarget == self.buttonNum then
			self.HighlightT:SetTexture(0.5, 0.5, 0.5, 1)
			self.HighlightR:SetTexture(0.5, 0.5, 0.5, 1)
			self.HighlightB:SetTexture(0.5, 0.5, 0.5, 1)
			self.HighlightL:SetTexture(0.5, 0.5, 0.5, 1)
		else
			self.HighlightT:SetTexture(0, 0, 0, 1)
			self.HighlightR:SetTexture(0, 0, 0, 1)
			self.HighlightB:SetTexture(0, 0, 0, 1)
			self.HighlightL:SetTexture(0, 0, 0, 1)
		end
	end

	local buttonWidth = 150
	local buttonHeight = 20

	GVAR.TargetButton = {}
	for i = 1, 40 do
		GVAR.TargetButton[i] = CreateFrame("Button", nil, UIParent, "SecureActionButtonTemplate")

		local GVAR_TargetButton = GVAR.TargetButton[i]

		GVAR_TargetButton:SetWidth(buttonWidth)
		GVAR_TargetButton:SetHeight(buttonHeight)
		if i == 1 then
			GVAR_TargetButton:SetPoint("TOPLEFT", GVAR.MainFrame, "BOTTOMLEFT", 0, 0)
		else
			GVAR_TargetButton:SetPoint("TOPLEFT", GVAR.TargetButton[(i-1)], "BOTTOMLEFT", 0, 0)
		end
		GVAR_TargetButton:Hide()

		GVAR_TargetButton.colR  = 0
		GVAR_TargetButton.colG  = 0
		GVAR_TargetButton.colB  = 0
		GVAR_TargetButton.colR5 = 0
		GVAR_TargetButton.colG5 = 0
		GVAR_TargetButton.colB5 = 0

		GVAR_TargetButton.HighlightT = GVAR_TargetButton:CreateTexture(nil, "BACKGROUND")
		GVAR_TargetButton.HighlightT:SetWidth(buttonWidth)
		GVAR_TargetButton.HighlightT:SetHeight(1)
		GVAR_TargetButton.HighlightT:SetPoint("TOP", 0, 0)
		GVAR_TargetButton.HighlightT:SetTexture(0, 0, 0, 1)
		GVAR_TargetButton.HighlightR = GVAR_TargetButton:CreateTexture(nil, "BACKGROUND")
		GVAR_TargetButton.HighlightR:SetWidth(1)
		GVAR_TargetButton.HighlightR:SetHeight(buttonHeight)
		GVAR_TargetButton.HighlightR:SetPoint("RIGHT", 0, 0)
		GVAR_TargetButton.HighlightR:SetTexture(0, 0, 0, 1)
		GVAR_TargetButton.HighlightB = GVAR_TargetButton:CreateTexture(nil, "BACKGROUND")
		GVAR_TargetButton.HighlightB:SetWidth(buttonWidth)
		GVAR_TargetButton.HighlightB:SetHeight(1)
		GVAR_TargetButton.HighlightB:SetPoint("BOTTOM", 0, 0)
		GVAR_TargetButton.HighlightB:SetTexture(0, 0, 0, 1)
		GVAR_TargetButton.HighlightL = GVAR_TargetButton:CreateTexture(nil, "BACKGROUND")
		GVAR_TargetButton.HighlightL:SetWidth(1)
		GVAR_TargetButton.HighlightL:SetHeight(buttonHeight)
		GVAR_TargetButton.HighlightL:SetPoint("LEFT", 0, 0)
		GVAR_TargetButton.HighlightL:SetTexture(0, 0, 0, 1)

		GVAR_TargetButton.Background = GVAR_TargetButton:CreateTexture(nil, "BACKGROUND")
		GVAR_TargetButton.Background:SetWidth(buttonWidth-2)
		GVAR_TargetButton.Background:SetHeight(buttonHeight-2)
		GVAR_TargetButton.Background:SetPoint("TOPLEFT", 1, -1)
		GVAR_TargetButton.Background:SetTexture(0, 0, 0, 1)

		GVAR_TargetButton.RangeTexture = GVAR_TargetButton:CreateTexture(nil, "BORDER")
		GVAR_TargetButton.RangeTexture:SetWidth((buttonHeight-2)/2)
		GVAR_TargetButton.RangeTexture:SetHeight(buttonHeight-2)
		GVAR_TargetButton.RangeTexture:SetPoint("LEFT", GVAR_TargetButton, "LEFT", 1, 0)
		GVAR_TargetButton.RangeTexture:SetTexture(0, 0, 0, 0)

		GVAR_TargetButton.RoleTexture = GVAR_TargetButton:CreateTexture(nil, "BORDER")
		GVAR_TargetButton.RoleTexture:SetWidth(buttonHeight-2)
		GVAR_TargetButton.RoleTexture:SetHeight(buttonHeight-2)
		GVAR_TargetButton.RoleTexture:SetPoint("LEFT", GVAR_TargetButton.RangeTexture, "RIGHT", 0, 0)
		GVAR_TargetButton.RoleTexture:SetTexture(Textures.BattlegroundTargetsIcons.path)
		GVAR_TargetButton.RoleTexture:SetTexCoord(0, 0, 0, 0)

		GVAR_TargetButton.SpecTexture = GVAR_TargetButton:CreateTexture(nil, "BORDER")
		GVAR_TargetButton.SpecTexture:SetWidth(buttonHeight-2)
		GVAR_TargetButton.SpecTexture:SetHeight(buttonHeight-2)
		GVAR_TargetButton.SpecTexture:SetPoint("LEFT", GVAR_TargetButton.RoleTexture, "RIGHT", 0, 0)
		GVAR_TargetButton.SpecTexture:SetTexCoord(0.07812501, 0.92187499, 0.07812501, 0.92187499)--(5/64, 59/64, 5/64, 59/64)
		GVAR_TargetButton.SpecTexture:SetTexture(nil)

		GVAR_TargetButton.ClassTexture = GVAR_TargetButton:CreateTexture(nil, "BORDER")
		GVAR_TargetButton.ClassTexture:SetWidth(buttonHeight-2)
		GVAR_TargetButton.ClassTexture:SetHeight(buttonHeight-2)
		GVAR_TargetButton.ClassTexture:SetPoint("LEFT", GVAR_TargetButton.SpecTexture, "RIGHT", 0, 0)
		GVAR_TargetButton.ClassTexture:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
		GVAR_TargetButton.ClassTexture:SetTexCoord(0, 0, 0, 0)

		GVAR_TargetButton.LeaderTexture = GVAR_TargetButton:CreateTexture(nil, "ARTWORK")
		GVAR_TargetButton.LeaderTexture:SetWidth((buttonHeight-2)/1.5)
		GVAR_TargetButton.LeaderTexture:SetHeight((buttonHeight-2)/1.5)
		GVAR_TargetButton.LeaderTexture:SetPoint("RIGHT", GVAR_TargetButton, "LEFT", 0, 0)
		GVAR_TargetButton.LeaderTexture:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
		GVAR_TargetButton.LeaderTexture:SetAlpha(0)

		GVAR_TargetButton.GuildGroupButton = CreateFrame("Button", nil, GVAR_TargetButton) -- xBUT
		GVAR_TargetButton.GuildGroup = GVAR_TargetButton.GuildGroupButton:CreateTexture(nil, "OVERLAY") -- GLDGRP
		GVAR_TargetButton.GuildGroup:SetWidth((buttonHeight-2)*0.4)
		GVAR_TargetButton.GuildGroup:SetHeight((buttonHeight-2)*0.4)
		GVAR_TargetButton.GuildGroup:SetPoint("LEFT", GVAR_TargetButton, "RIGHT", 0, 0)
		GVAR_TargetButton.GuildGroup:SetTexture(Textures.BattlegroundTargetsIcons.path)
		GVAR_TargetButton.GuildGroup:SetTexCoord(0, 0, 0, 0)

		GVAR_TargetButton.ClassColorBackground = GVAR_TargetButton:CreateTexture(nil, "BORDER")
		GVAR_TargetButton.ClassColorBackground:SetWidth((buttonWidth-2) - (buttonHeight-2) - (buttonHeight-2))
		GVAR_TargetButton.ClassColorBackground:SetHeight(buttonHeight-2)
		GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton.ClassTexture, "RIGHT", 0, 0)
		GVAR_TargetButton.ClassColorBackground:SetTexture(0, 0, 0, 0)

		GVAR_TargetButton.HealthBar = GVAR_TargetButton:CreateTexture(nil, "ARTWORK")
		GVAR_TargetButton.HealthBar:SetWidth((buttonWidth-2) - (buttonHeight-2) - (buttonHeight-2))
		GVAR_TargetButton.HealthBar:SetHeight(buttonHeight-2)
		GVAR_TargetButton.HealthBar:SetPoint("LEFT", GVAR_TargetButton.ClassColorBackground, "LEFT", 0, 0)
		GVAR_TargetButton.HealthBar:SetTexture(0, 0, 0, 0)

		GVAR_TargetButton.HealthTextButton = CreateFrame("Button", nil, GVAR_TargetButton) -- xBUT
		GVAR_TargetButton.HealthText = GVAR_TargetButton.HealthTextButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		GVAR_TargetButton.HealthText:SetWidth((buttonWidth-2) - (buttonHeight-2) - (buttonHeight-2) -2)
		GVAR_TargetButton.HealthText:SetHeight(buttonHeight-2)
		GVAR_TargetButton.HealthText:SetPoint("RIGHT", GVAR_TargetButton.ClassColorBackground, "RIGHT", 0, 0)
		GVAR_TargetButton.HealthText:SetJustifyH("RIGHT")

		GVAR_TargetButton.Name = GVAR_TargetButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		GVAR_TargetButton.Name:SetWidth((buttonWidth-2) - (buttonHeight-2) - (buttonHeight-2) -2)
		GVAR_TargetButton.Name:SetHeight(buttonHeight-2)
		GVAR_TargetButton.Name:SetPoint("LEFT", GVAR_TargetButton.ClassColorBackground, "LEFT", 2, 0)
		GVAR_TargetButton.Name:SetJustifyH("LEFT")

		GVAR_TargetButton.TargetCountBackground = GVAR_TargetButton:CreateTexture(nil, "ARTWORK")
		GVAR_TargetButton.TargetCountBackground:SetWidth(20)
		GVAR_TargetButton.TargetCountBackground:SetHeight(buttonHeight-2)
		GVAR_TargetButton.TargetCountBackground:SetPoint("RIGHT", GVAR_TargetButton, "RIGHT", -1, 0)
		GVAR_TargetButton.TargetCountBackground:SetTexture(0, 0, 0, 1)
		GVAR_TargetButton.TargetCountBackground:SetAlpha(1)

		GVAR_TargetButton.TargetCount = GVAR_TargetButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		GVAR_TargetButton.TargetCount:SetWidth(20)
		GVAR_TargetButton.TargetCount:SetHeight(buttonHeight-4)
		GVAR_TargetButton.TargetCount:SetPoint("CENTER", GVAR_TargetButton.TargetCountBackground, "CENTER", 0, 0)
		GVAR_TargetButton.TargetCount:SetJustifyH("CENTER")

		GVAR_TargetButton.TargetTextureButton = CreateFrame("Button", nil, GVAR_TargetButton) -- xBUT
		GVAR_TargetButton.TargetTexture = GVAR_TargetButton.TargetTextureButton:CreateTexture(nil, "OVERLAY")
		GVAR_TargetButton.TargetTexture:SetWidth(buttonHeight-2)
		GVAR_TargetButton.TargetTexture:SetHeight(buttonHeight-2)
		GVAR_TargetButton.TargetTexture:SetPoint("LEFT", GVAR_TargetButton, "RIGHT", 0, 0)
		GVAR_TargetButton.TargetTexture:SetTexture(AddonIcon)
		GVAR_TargetButton.TargetTexture:SetAlpha(0)

		GVAR_TargetButton.FocusTextureButton = CreateFrame("Button", nil, GVAR_TargetButton) -- xBUT
		GVAR_TargetButton.FocusTexture = GVAR_TargetButton.FocusTextureButton:CreateTexture(nil, "OVERLAY")
		GVAR_TargetButton.FocusTexture:SetWidth(buttonHeight-2)
		GVAR_TargetButton.FocusTexture:SetHeight(buttonHeight-2)
		GVAR_TargetButton.FocusTexture:SetPoint("LEFT", GVAR_TargetButton, "RIGHT", 0, 0)
		GVAR_TargetButton.FocusTexture:SetTexture("Interface\\Minimap\\Tracking\\Focus")
		GVAR_TargetButton.FocusTexture:SetAlpha(0)

		GVAR_TargetButton.FlagTextureButton = CreateFrame("Button", nil, GVAR_TargetButton) -- xBUT
		GVAR_TargetButton.FlagTexture = GVAR_TargetButton.FlagTextureButton:CreateTexture(nil, "OVERLAY")
		GVAR_TargetButton.FlagTexture:SetWidth(buttonHeight-2)
		GVAR_TargetButton.FlagTexture:SetHeight(buttonHeight-2)
		GVAR_TargetButton.FlagTexture:SetPoint("LEFT", GVAR_TargetButton, "RIGHT", 0, 0)
		GVAR_TargetButton.FlagTexture:SetTexCoord(0.15625001, 0.84374999, 0.15625001, 0.84374999)--(5/32, 27/32, 5/32, 27/32)
		if playerFactionDEF == 0 then -- setup_flag_texture
			GVAR_TargetButton.FlagTexture:SetTexture("Interface\\WorldStateFrame\\HordeFlag")
		else
			GVAR_TargetButton.FlagTexture:SetTexture("Interface\\WorldStateFrame\\AllianceFlag")
		end
		GVAR_TargetButton.FlagTexture:SetAlpha(0)

		GVAR_TargetButton.FlagDebuffButton = CreateFrame("Button", nil, GVAR_TargetButton) -- xBUT -- FLAGDEBUFF
		GVAR_TargetButton.FlagDebuff = GVAR_TargetButton.FlagDebuffButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		GVAR_TargetButton.FlagDebuff:SetWidth(40)
		GVAR_TargetButton.FlagDebuff:SetHeight(buttonHeight-2)
		GVAR_TargetButton.FlagDebuff:SetPoint("CENTER", GVAR_TargetButton.FlagTexture, "CENTER", 0, 0)
		GVAR_TargetButton.FlagDebuff:SetJustifyH("CENTER")

		GVAR_TargetButton.AssistTextureButton = CreateFrame("Button", nil, GVAR_TargetButton) -- xBUT
		GVAR_TargetButton.AssistTexture = GVAR_TargetButton.AssistTextureButton:CreateTexture(nil, "OVERLAY")
		GVAR_TargetButton.AssistTexture:SetWidth(buttonHeight-2)
		GVAR_TargetButton.AssistTexture:SetHeight(buttonHeight-2)
		GVAR_TargetButton.AssistTexture:SetPoint("LEFT", GVAR_TargetButton, "RIGHT", 0, 0)
		GVAR_TargetButton.AssistTexture:SetTexCoord(0.07812501, 0.92187499, 0.07812501, 0.92187499)--(5/64, 59/64, 5/64, 59/64)
		GVAR_TargetButton.AssistTexture:SetTexture("Interface\\Icons\\Ability_Hunter_SniperShot")
		GVAR_TargetButton.AssistTexture:SetAlpha(0)

		GVAR_TargetButton:RegisterForClicks("AnyUp")
		GVAR_TargetButton:SetAttribute("type1", "macro")
		GVAR_TargetButton:SetAttribute("type2", "macro")
		GVAR_TargetButton:SetAttribute("macrotext1", "")
		GVAR_TargetButton:SetAttribute("macrotext2", "")
		GVAR_TargetButton:SetScript("OnEnter", OnEnter)
		GVAR_TargetButton:SetScript("OnLeave", OnLeave)
	end

	GVAR.ScoreUpdateTexture = GVAR.TargetButton[1]:CreateTexture(nil, "OVERLAY")
	GVAR.ScoreUpdateTexture:SetWidth(Textures.UpdateWarning.width)
	GVAR.ScoreUpdateTexture:SetHeight(Textures.UpdateWarning.height)
	GVAR.ScoreUpdateTexture:SetPoint("BOTTOMLEFT", GVAR.TargetButton[1], "TOPLEFT", 1, 1)
	GVAR.ScoreUpdateTexture:SetTexture(Textures.BattlegroundTargetsIcons.path)
	GVAR.ScoreUpdateTexture:SetTexCoord(unpack(Textures.UpdateWarning.coords))

	-- ----------------------------------------
	GVAR.Summary = CreateFrame("Frame", nil, GVAR.TargetButton[1]) -- SUMMARY
	GVAR.Summary:SetToplevel(true)
	GVAR.Summary:SetWidth(140)
	GVAR.Summary:SetHeight(60)

	GVAR.Summary.Healer = GVAR.Summary:CreateTexture(nil, "ARTWORK")
	GVAR.Summary.Healer:SetWidth(20)
	GVAR.Summary.Healer:SetHeight(20)
	GVAR.Summary.Healer:SetPoint("TOPLEFT", GVAR.Summary, "TOPLEFT", 60, 0)
	GVAR.Summary.Healer:SetTexture(Textures.BattlegroundTargetsIcons.path)
	GVAR.Summary.Healer:SetTexCoord(unpack(Textures.RoleIcon[1]))
	GVAR.Summary.Tank = GVAR.Summary:CreateTexture(nil, "ARTWORK")
	GVAR.Summary.Tank:SetWidth(20)
	GVAR.Summary.Tank:SetHeight(20)
	GVAR.Summary.Tank:SetPoint("TOP", GVAR.Summary.Healer, "BOTTOM", 0, 0)
	GVAR.Summary.Tank:SetTexture(Textures.BattlegroundTargetsIcons.path)
	GVAR.Summary.Tank:SetTexCoord(unpack(Textures.RoleIcon[2]))
	GVAR.Summary.Damage = GVAR.Summary:CreateTexture(nil, "ARTWORK")
	GVAR.Summary.Damage:SetWidth(20)
	GVAR.Summary.Damage:SetHeight(20)
	GVAR.Summary.Damage:SetPoint("TOP", GVAR.Summary.Tank, "BOTTOM", 0, 0)
	GVAR.Summary.Damage:SetTexture(Textures.BattlegroundTargetsIcons.path)
	GVAR.Summary.Damage:SetTexCoord(unpack(Textures.RoleIcon[3]))

	local function FONT_TEMPLATE(button)
		button:SetWidth(60)
		button:SetHeight(20)
		button:SetJustifyH("CENTER")
		button:SetFont(fontPath, 20, "OUTLINE")
		button:SetShadowOffset(0, 0)
		button:SetShadowColor(0, 0, 0, 0)
		button:SetTextColor(1, 1, 1, 1)
	end

	GVAR.Summary.HealerFriend = GVAR.Summary:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	GVAR.Summary.HealerFriend:SetPoint("RIGHT", GVAR.Summary.Healer, "LEFT", 15, 0)
	FONT_TEMPLATE(GVAR.Summary.HealerFriend)
	GVAR.Summary.HealerEnemy = GVAR.Summary:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	GVAR.Summary.HealerEnemy:SetPoint("LEFT", GVAR.Summary.Healer, "RIGHT", -15, 0)
	FONT_TEMPLATE(GVAR.Summary.HealerEnemy)

	GVAR.Summary.TankFriend = GVAR.Summary:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	GVAR.Summary.TankFriend:SetPoint("RIGHT", GVAR.Summary.Tank, "LEFT", 15, 0)
	FONT_TEMPLATE(GVAR.Summary.TankFriend)
	GVAR.Summary.TankEnemy = GVAR.Summary:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	GVAR.Summary.TankEnemy:SetPoint("LEFT", GVAR.Summary.Tank, "RIGHT", -15, 0)
	FONT_TEMPLATE(GVAR.Summary.TankEnemy)

	GVAR.Summary.DamageFriend = GVAR.Summary:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	GVAR.Summary.DamageFriend:SetPoint("RIGHT", GVAR.Summary.Damage, "LEFT", 15, 0)
	FONT_TEMPLATE(GVAR.Summary.DamageFriend)
	GVAR.Summary.DamageEnemy = GVAR.Summary:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	GVAR.Summary.DamageEnemy:SetPoint("LEFT", GVAR.Summary.Damage, "RIGHT", -15, 0)
	FONT_TEMPLATE(GVAR.Summary.DamageEnemy)

	GVAR.Summary.Logo1 = GVAR.Summary:CreateTexture(nil, "BACKGROUND")
	GVAR.Summary.Logo1:SetWidth(60)
	GVAR.Summary.Logo1:SetHeight(60)
	GVAR.Summary.Logo1:SetPoint("RIGHT", GVAR.Summary.Tank, "LEFT", 0, 0)
	GVAR.Summary.Logo1:SetAlpha(1)
	GVAR.Summary.Logo2 = GVAR.Summary:CreateTexture(nil, "BACKGROUND")
	GVAR.Summary.Logo2:SetWidth(60)
	GVAR.Summary.Logo2:SetHeight(60)
	GVAR.Summary.Logo2:SetPoint("LEFT", GVAR.Summary.Tank, "RIGHT", 0, 0)
	GVAR.Summary.Logo2:SetAlpha(1)

	if playerFactionDEF == 0 then -- summary_flag_texture
		GVAR.Summary.Logo1:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
		GVAR.Summary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
	else
		GVAR.Summary.Logo1:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
		GVAR.Summary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
	end
	-- ----------------------------------------

	-- ----------------------------------------
	GVAR.GuildGroupSummary = CreateFrame("Frame", nil, GVAR.Summary) -- SUMMARY
	GVAR.GuildGroupSummary:SetToplevel(true)

	local function FONT_TEMPLATE2(button, jus)
		button:SetWidth(50)
		button:SetHeight(10)
		button:SetJustifyH(jus)
		button:SetFont(fontPath, 12, "OUTLINE")
		button:SetShadowOffset(0, 0)
		button:SetShadowColor(0, 0, 0, 0)
		button:SetTextColor(1, 1, 1, 1)
	end

	GVAR.GuildGroupSummaryFriend = {} -- GLDGRP
	for i = 1, 7 do -- 7 is the max: | 2: 1x | 3: 1x | 4: 1x | 5: 1x | 6: 1x | 7: 1x | 8: 1x | = 35 another 9size group is not possible in 40s bg
		GVAR.GuildGroupSummaryFriend[i] = CreateFrame("Button", nil, GVAR.GuildGroupSummary)
		GVAR.GuildGroupSummaryFriend[i]:Show()

		GVAR.GuildGroupSummaryFriend[i].Text = GVAR.GuildGroupSummaryFriend[i]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		FONT_TEMPLATE2(GVAR.GuildGroupSummaryFriend[i].Text, "RIGHT")
		if i == 1 then
			GVAR.GuildGroupSummaryFriend[i].Text:SetPoint("TOPRIGHT", GVAR.Summary.Logo1, "TOPLEFT", 5, 0)
		else
			GVAR.GuildGroupSummaryFriend[i].Text:SetPoint("TOP", GVAR.GuildGroupSummaryFriend[(i-1)].Text, "BOTTOM", 0, 0)
		end
		-- GVAR.GuildGroupSummaryFriend[i].Text:SetText("") -- GG_CONFTXT
	end

	GVAR.GuildGroupSummaryEnemy = {}
	for i = 1, 7 do
		GVAR.GuildGroupSummaryEnemy[i] = CreateFrame("Button", nil, GVAR.GuildGroupSummary)
		GVAR.GuildGroupSummaryEnemy[i]:Show()

		GVAR.GuildGroupSummaryEnemy[i].Text = GVAR.GuildGroupSummaryEnemy[i]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		FONT_TEMPLATE2(GVAR.GuildGroupSummaryEnemy[i].Text, "LEFT")
		if i == 1 then
			GVAR.GuildGroupSummaryEnemy[i].Text:SetPoint("TOPLEFT", GVAR.Summary.Logo2, "TOPRIGHT", -5, 0)
		else
			GVAR.GuildGroupSummaryEnemy[i].Text:SetPoint("TOP", GVAR.GuildGroupSummaryEnemy[(i-1)].Text, "BOTTOM", 0, 0)
		end
		-- GVAR.GuildGroupSummaryEnemy[i].Text:SetText("") -- GG_CONFTXT
	end
	-- ----------------------------------------

	BattlegroundTargets:SummaryPosition()

	-- ----------------------------------------
	GVAR.WorldStateScoreWarning = CreateFrame("Frame", nil, WorldStateScoreFrame)
	TEMPLATE.BorderTRBL(GVAR.WorldStateScoreWarning)
	GVAR.WorldStateScoreWarning:SetToplevel(true)
	-- GVAR.WorldStateScoreWarning:SetWidth()
	GVAR.WorldStateScoreWarning:SetHeight(30)
	GVAR.WorldStateScoreWarning:SetPoint("BOTTOM", WorldStateScoreFrame, "TOP", 0, 10)
	GVAR.WorldStateScoreWarning:Hide()

	GVAR.WorldStateScoreWarning.Texture = GVAR.WorldStateScoreWarning:CreateTexture(nil, "ARTWORK")
	GVAR.WorldStateScoreWarning.Texture:SetWidth(20) -- 62
	GVAR.WorldStateScoreWarning.Texture:SetHeight(17.419) -- 54
	GVAR.WorldStateScoreWarning.Texture:SetPoint("LEFT", GVAR.WorldStateScoreWarning, "LEFT", 5, 0)
	GVAR.WorldStateScoreWarning.Texture:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew")
	GVAR.WorldStateScoreWarning.Texture:SetTexCoord(1/64, 63/64, 1/64, 55/64)

	GVAR.WorldStateScoreWarning.Text = GVAR.WorldStateScoreWarning:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	-- GVAR.WorldStateScoreWarning.Text:SetWidth()
	GVAR.WorldStateScoreWarning.Text:SetHeight(30)
	GVAR.WorldStateScoreWarning.Text:SetPoint("LEFT", GVAR.WorldStateScoreWarning.Texture, "RIGHT", 5, 0)
	GVAR.WorldStateScoreWarning.Text:SetJustifyH("CENTER")
	GVAR.WorldStateScoreWarning.Text:SetFont(fontPath, 10)
	GVAR.WorldStateScoreWarning.Text:SetText(L["BattlegroundTargets does not update if this Tab is opened."])

	GVAR.WorldStateScoreWarning.Close = CreateFrame("Button", nil, GVAR.WorldStateScoreWarning)
	TEMPLATE.IconButton(GVAR.WorldStateScoreWarning.Close, 1)
	GVAR.WorldStateScoreWarning.Close:SetWidth(20)
	GVAR.WorldStateScoreWarning.Close:SetHeight(20)
	GVAR.WorldStateScoreWarning.Close:SetPoint("TOPRIGHT", GVAR.WorldStateScoreWarning, "TOPRIGHT", 0, 0)
	GVAR.WorldStateScoreWarning.Close:SetScript("OnClick", function() GVAR.WorldStateScoreWarning:Hide() end)

	local w = GVAR.WorldStateScoreWarning.Text:GetStringWidth() + 20
	GVAR.WorldStateScoreWarning.Text:SetWidth(w)
	GVAR.WorldStateScoreWarning:SetWidth(30+w+30)
	-- ----------------------------------------
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:SummaryPosition() -- SUMMARY
	if BattlegroundTargets_Options.Summary[currentSize] then
		GVAR.Summary:ClearAllPoints()
		local LayoutTH = BattlegroundTargets_Options.LayoutTH[currentSize]
		if currentSize == 10 then
			if LayoutTH == 18 then
				GVAR.Summary:SetPoint("TOP", GVAR.TargetButton[10], "BOTTOM", 0, -10)
			elseif LayoutTH == 81 then
				GVAR.Summary:SetPoint("TOP", GVAR.TargetButton[5], "BOTTOM", 0, -10)
			end
		elseif currentSize == 15 then
			if LayoutTH == 18 then
				GVAR.Summary:SetPoint("TOP", GVAR.TargetButton[15], "BOTTOM", 0, -10)
			elseif LayoutTH == 81 then
				GVAR.Summary:SetPoint("TOP", GVAR.TargetButton[5], "BOTTOM", 0, -10)
			end
		elseif currentSize == 40 then
			if LayoutTH == 18 then
				GVAR.Summary:SetPoint("TOP", GVAR.TargetButton[40], "BOTTOM", 0, -10)
			elseif LayoutTH == 24 then
				GVAR.Summary:SetPoint("TOP", GVAR.TargetButton[20], "BOTTOM", 0, -10)
			elseif LayoutTH == 42 then
				GVAR.Summary:SetPoint("TOP", GVAR.TargetButton[10], "BOTTOM", 0, -10)
			elseif LayoutTH == 81 then
				GVAR.Summary:SetPoint("TOP", GVAR.TargetButton[5], "BOTTOM", 0, -10)
			end
		end
		GVAR.Summary:SetScale(BattlegroundTargets_Options.SummaryScaleRole[currentSize])
		GVAR.Summary:Show()

		if OPT.ButtonShowGuildGroup[currentSize] then
			GVAR.GuildGroupSummary:SetScale(BattlegroundTargets_Options.SummaryScaleGuildGroup[currentSize])
			GVAR.GuildGroupSummary:Show()
		else
			GVAR.GuildGroupSummary:Hide()
		end
	else
		GVAR.Summary:Hide()
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CreateOptionsFrame()
	BattlegroundTargets:DefaultShuffle()

	local heightBase = 58 -- 10+16+10+22
	local heightBracket = 497 -- 10+16+10  +1+  10+16 + 10+16 + 10+24+10 + (14*16) + (14*10)
	local heightTotal = heightBase + heightBracket + 30 + 10

	-- ####################################################################################################
	-- xMx OptionsFrame
	GVAR.OptionsFrame = CreateFrame("Frame", "BattlegroundTargets_OptionsFrame", UIParent)
	TEMPLATE.BorderTRBL(GVAR.OptionsFrame)
	GVAR.OptionsFrame:EnableMouse(true)
	GVAR.OptionsFrame:SetMovable(true)
	GVAR.OptionsFrame:SetToplevel(true)
	GVAR.OptionsFrame:SetClampedToScreen(true)
	-- BOOM GVAR.OptionsFrame:SetClampRectInsets()
	-- BOOM GVAR.OptionsFrame:SetWidth()
	GVAR.OptionsFrame:SetHeight(heightTotal)
	GVAR.OptionsFrame:SetScript("OnShow", function() if not inWorld then return end BattlegroundTargets:OptionsFrameShow() end)
	GVAR.OptionsFrame:SetScript("OnHide", function() if not inWorld then return end BattlegroundTargets:OptionsFrameHide() end)
	GVAR.OptionsFrame:SetScript("OnMouseWheel", NOOP)
	GVAR.OptionsFrame:Hide()

	-- close
	GVAR.OptionsFrame.CloseConfig = CreateFrame("Button", nil, GVAR.OptionsFrame)
	TEMPLATE.TextButton(GVAR.OptionsFrame.CloseConfig, L["Close Configuration"], 1)
	GVAR.OptionsFrame.CloseConfig:SetPoint("BOTTOM", GVAR.OptionsFrame, "BOTTOM", 0, 10)
	GVAR.OptionsFrame.CloseConfig:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	-- BOOM GVAR.OptionsFrame.CloseConfig:SetWidth()
	GVAR.OptionsFrame.CloseConfig:SetHeight(30)
	GVAR.OptionsFrame.CloseConfig:SetScript("OnClick", function() GVAR.OptionsFrame:Hide() end)
	-- ###
	-- ####################################################################################################



	-- ####################################################################################################
	-- xMx Base
	GVAR.OptionsFrame.Base = CreateFrame("Frame", nil, GVAR.OptionsFrame)
	TEMPLATE.BorderTRBL(GVAR.OptionsFrame.Base)
	-- BOOM GVAR.OptionsFrame.Base:SetWidth()
	GVAR.OptionsFrame.Base:SetHeight(heightBase)
	GVAR.OptionsFrame.Base:SetPoint("TOPLEFT", GVAR.OptionsFrame, "TOPLEFT", 0, 0)
	GVAR.OptionsFrame.Base:EnableMouse(true)

	GVAR.OptionsFrame.Title = GVAR.OptionsFrame.Base:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	-- BOOM GVAR.OptionsFrame.Title:SetWidth()
	GVAR.OptionsFrame.Title:SetPoint("TOPLEFT", GVAR.OptionsFrame.Base, "TOPLEFT", 0, -10)
	GVAR.OptionsFrame.Title:SetJustifyH("CENTER")
	GVAR.OptionsFrame.Title:SetText("BattlegroundTargets")

	-- tabs
	GVAR.OptionsFrame.TabGeneral = CreateFrame("Button", nil, GVAR.OptionsFrame.Base)
	TEMPLATE.TabButton(GVAR.OptionsFrame.TabGeneral, nil, BattlegroundTargets_Options.EnableBracket[10])
	-- BOOM GVAR.OptionsFrame.TabGeneral:SetWidth()
	GVAR.OptionsFrame.TabGeneral:SetHeight(22)
	-- BOOM GVAR.OptionsFrame.TabGeneral:SetPoint()
	GVAR.OptionsFrame.TabGeneral:SetScript("OnClick", function()
		if GVAR.OptionsFrame.ConfigGeneral:IsShown() then
			TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
			GVAR.OptionsFrame.ConfigGeneral:Hide()
			GVAR.OptionsFrame.ConfigBrackets:Show()
			GVAR.OptionsFrame["TabRaidSize"..testSize].TextureBottom:SetTexture(0, 0, 0, 1)
		else
			TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, true)
			GVAR.OptionsFrame.ConfigGeneral:Show()
			GVAR.OptionsFrame.ConfigBrackets:Hide()
			GVAR.OptionsFrame["TabRaidSize"..testSize].TextureBottom:SetTexture(0.8, 0.2, 0.2, 1)
		end
	end)

	GVAR.OptionsFrame.TabRaidSize10 = CreateFrame("Button", nil, GVAR.OptionsFrame.Base)
	TEMPLATE.TabButton(GVAR.OptionsFrame.TabRaidSize10, L["10 vs 10"], BattlegroundTargets_Options.EnableBracket[10])
	-- BOOM GVAR.OptionsFrame.TabRaidSize10:SetWidth()
	GVAR.OptionsFrame.TabRaidSize10:SetHeight(22)
	-- BOOM GVAR.OptionsFrame.TabRaidSize10:SetPoint()
	GVAR.OptionsFrame.TabRaidSize10:SetScript("OnClick", function()
		GVAR.OptionsFrame.ConfigGeneral:Hide()
		GVAR.OptionsFrame.ConfigBrackets:Show()
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, true)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, nil)
		if testSize == 10 then return end
		testSize = 10
		BattlegroundTargets:CheckForEnabledBracket(testSize)
		if BattlegroundTargets_Options.EnableBracket[testSize] then
			BattlegroundTargets:ShuffleSizeCheck(testSize)
			BattlegroundTargets:ConfigGuildGroupFriendUpdate(testSize)
			BattlegroundTargets:EnableConfigMode()
		else
			BattlegroundTargets:DisableConfigMode()
		end
	end)

	GVAR.OptionsFrame.TabRaidSize15 = CreateFrame("Button", nil, GVAR.OptionsFrame.Base)
	TEMPLATE.TabButton(GVAR.OptionsFrame.TabRaidSize15, L["15 vs 15"], BattlegroundTargets_Options.EnableBracket[15])
	-- BOOM GVAR.OptionsFrame.TabRaidSize15:SetWidth()
	GVAR.OptionsFrame.TabRaidSize15:SetHeight(22)
	-- BOOM GVAR.OptionsFrame.TabRaidSize15:SetPoint()
	GVAR.OptionsFrame.TabRaidSize15:SetScript("OnClick", function()
		GVAR.OptionsFrame.ConfigGeneral:Hide()
		GVAR.OptionsFrame.ConfigBrackets:Show()
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, true)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, nil)
		if testSize == 15 then return end
		testSize = 15
		BattlegroundTargets:CheckForEnabledBracket(testSize)
		if BattlegroundTargets_Options.EnableBracket[testSize] then
			BattlegroundTargets:ShuffleSizeCheck(testSize)
			BattlegroundTargets:ConfigGuildGroupFriendUpdate(testSize)
			BattlegroundTargets:EnableConfigMode()
		else
			BattlegroundTargets:DisableConfigMode()
		end
	end)

	GVAR.OptionsFrame.TabRaidSize40 = CreateFrame("Button", nil, GVAR.OptionsFrame.Base)
	TEMPLATE.TabButton(GVAR.OptionsFrame.TabRaidSize40, L["40 vs 40"], BattlegroundTargets_Options.EnableBracket[40])
	-- BOOM GVAR.OptionsFrame.TabRaidSize40:SetWidth()
	GVAR.OptionsFrame.TabRaidSize40:SetHeight(22)
	-- BOOM GVAR.OptionsFrame.TabRaidSize40:SetPoint()
	GVAR.OptionsFrame.TabRaidSize40:SetScript("OnClick", function()
		GVAR.OptionsFrame.ConfigGeneral:Hide()
		GVAR.OptionsFrame.ConfigBrackets:Show()
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, true)
		if testSize == 40 then return end
		testSize = 40
		BattlegroundTargets:CheckForEnabledBracket(testSize)
		if BattlegroundTargets_Options.EnableBracket[testSize] then
			BattlegroundTargets:ShuffleSizeCheck(testSize)
			BattlegroundTargets:ConfigGuildGroupFriendUpdate(testSize)
			BattlegroundTargets:EnableConfigMode()
		else
			BattlegroundTargets:DisableConfigMode()
		end
	end)

	if testSize == 10 then
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, true)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, nil)
	elseif testSize == 15 then
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, true)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, nil)
	elseif testSize == 40 then
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, true)
	end
	-- ###
	-- ####################################################################################################



	-- ####################################################################################################
	-- xMx ConfigBrackets
	GVAR.OptionsFrame.ConfigBrackets = CreateFrame("Frame", nil, GVAR.OptionsFrame)
	-- BOOM GVAR.OptionsFrame.ConfigBrackets:SetWidth()
	GVAR.OptionsFrame.ConfigBrackets:SetHeight(heightBracket)
	GVAR.OptionsFrame.ConfigBrackets:SetPoint("TOPLEFT", GVAR.OptionsFrame.Base, "BOTTOMLEFT", 0, 1)
	GVAR.OptionsFrame.ConfigBrackets:Hide()

	-- enable bracket
	GVAR.OptionsFrame.EnableBracket = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.EnableBracket, 16, 4, L["Enable"])
	GVAR.OptionsFrame.EnableBracket:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.EnableBracket:SetPoint("TOP", GVAR.OptionsFrame.Base, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.EnableBracket:SetChecked(BattlegroundTargets_Options.EnableBracket[currentSize])
	GVAR.OptionsFrame.EnableBracket:SetScript("OnClick", function()
		BattlegroundTargets_Options.EnableBracket[currentSize] = not BattlegroundTargets_Options.EnableBracket[currentSize]
		GVAR.OptionsFrame.EnableBracket:SetChecked(BattlegroundTargets_Options.EnableBracket[currentSize])
		BattlegroundTargets:CheckForEnabledBracket(currentSize)
		if BattlegroundTargets_Options.EnableBracket[currentSize] then
			BattlegroundTargets:ShuffleSizeCheck(currentSize)
			BattlegroundTargets:ConfigGuildGroupFriendUpdate(currentSize)
			BattlegroundTargets:EnableConfigMode()
		else
			BattlegroundTargets:DisableConfigMode()
		end
	end)

	-- independent positioning
	GVAR.OptionsFrame.IndependentPos = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.IndependentPos, 16, 4, L["Independent Positioning"])
	GVAR.OptionsFrame.IndependentPos:SetPoint("LEFT", GVAR.OptionsFrame.EnableBracket, "RIGHT", 50, 0)
	GVAR.OptionsFrame.IndependentPos:SetChecked(BattlegroundTargets_Options.IndependentPositioning[currentSize])
	GVAR.OptionsFrame.IndependentPos:SetScript("OnClick", function()
		BattlegroundTargets_Options.IndependentPositioning[currentSize] = not BattlegroundTargets_Options.IndependentPositioning[currentSize]
		GVAR.OptionsFrame.IndependentPos:SetChecked(BattlegroundTargets_Options.IndependentPositioning[currentSize])
		if not BattlegroundTargets_Options.IndependentPositioning[currentSize] then
			BattlegroundTargets_Options.pos["BattlegroundTargets_MainFrame"..currentSize.."_posX"] = nil
			BattlegroundTargets_Options.pos["BattlegroundTargets_MainFrame"..currentSize.."_posY"] = nil
			if inCombat or InCombatLockdown() then
				reCheckBG = true
				return
			end
			BattlegroundTargets:Frame_SetupPosition("BattlegroundTargets_MainFrame")
		end
	end)

	-- dummy 1
	GVAR.OptionsFrame.Dummy1 = CreateFrame("Frame", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.BorderTRBL(GVAR.OptionsFrame.Dummy1)
	-- BOOM GVAR.OptionsFrame.Dummy1:SetWidth()
	GVAR.OptionsFrame.Dummy1:SetHeight(1)
	GVAR.OptionsFrame.Dummy1:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 26, 0)
	GVAR.OptionsFrame.Dummy1:SetPoint("TOP", GVAR.OptionsFrame.IndependentPos, "BOTTOM", 0, -10)

	-- layout
	GVAR.OptionsFrame.LayoutTHText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.LayoutTHText:SetHeight(16)
	GVAR.OptionsFrame.LayoutTHText:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 30, 0)
	GVAR.OptionsFrame.LayoutTHText:SetPoint("TOP", GVAR.OptionsFrame.Dummy1, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.LayoutTHText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.LayoutTHText:SetText(L["Layout"]..":")
	GVAR.OptionsFrame.LayoutTHText:SetTextColor(1, 1, 1, 1)

	GVAR.OptionsFrame.LayoutTHx18 = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.LayoutTHx18, 16, 4, nil, "l40_18")
	GVAR.OptionsFrame.LayoutTHx18:SetPoint("LEFT", GVAR.OptionsFrame.LayoutTHText, "RIGHT", 10, 0)
	GVAR.OptionsFrame.LayoutTHx18:SetScript("OnClick", function()
		BattlegroundTargets_Options.LayoutTH[currentSize] = 18
		GVAR.OptionsFrame.LayoutTHx18:SetChecked(true)
		GVAR.OptionsFrame.LayoutTHx24:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx42:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx81:SetChecked(false)
		BattlegroundTargets:SetupLayout()
	end)
	GVAR.OptionsFrame.LayoutTHx24 = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.LayoutTHx24, 16, 4, nil, "l40_24")
	GVAR.OptionsFrame.LayoutTHx24:SetPoint("LEFT", GVAR.OptionsFrame.LayoutTHx18, "RIGHT", 0, 0)
	GVAR.OptionsFrame.LayoutTHx24:SetScript("OnClick", function()
		BattlegroundTargets_Options.LayoutTH[currentSize] = 24
		GVAR.OptionsFrame.LayoutTHx18:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx24:SetChecked(true)
		GVAR.OptionsFrame.LayoutTHx42:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx81:SetChecked(false)
		BattlegroundTargets:SetupLayout()
	end)
	GVAR.OptionsFrame.LayoutTHx42 = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.LayoutTHx42, 16, 4, nil, "l40_42")
	GVAR.OptionsFrame.LayoutTHx42:SetPoint("LEFT", GVAR.OptionsFrame.LayoutTHx24, "RIGHT", 0, 0)
	GVAR.OptionsFrame.LayoutTHx42:SetScript("OnClick", function()
		BattlegroundTargets_Options.LayoutTH[currentSize] = 42
		GVAR.OptionsFrame.LayoutTHx18:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx24:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx42:SetChecked(true)
		GVAR.OptionsFrame.LayoutTHx81:SetChecked(false)
		BattlegroundTargets:SetupLayout()
	end)
	GVAR.OptionsFrame.LayoutTHx81 = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.LayoutTHx81, 16, 4, nil, "l40_81")
	GVAR.OptionsFrame.LayoutTHx81:SetPoint("LEFT", GVAR.OptionsFrame.LayoutTHx42, "RIGHT", 0, 0)
	GVAR.OptionsFrame.LayoutTHx81:SetScript("OnClick", function()
		BattlegroundTargets_Options.LayoutTH[currentSize] = 81
		GVAR.OptionsFrame.LayoutTHx18:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx24:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx42:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx81:SetChecked(true)
		BattlegroundTargets:SetupLayout()
	end)
	GVAR.OptionsFrame.LayoutSpace = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.LayoutSpaceText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.LayoutSpace, 85, 1, 0, 20, BattlegroundTargets_Options.LayoutSpace[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options.LayoutSpace[currentSize] then return end
		BattlegroundTargets_Options.LayoutSpace[currentSize] = value
		GVAR.OptionsFrame.LayoutSpaceText:SetText(value)
		BattlegroundTargets:SetupLayout()
	end,
	"blank")
	GVAR.OptionsFrame.LayoutSpace:SetPoint("LEFT", GVAR.OptionsFrame.LayoutTHx81, "RIGHT", 0, 0)
	GVAR.OptionsFrame.LayoutSpaceText:SetHeight(20)
	GVAR.OptionsFrame.LayoutSpaceText:SetPoint("LEFT", GVAR.OptionsFrame.LayoutSpace, "RIGHT", 5, 0)
	GVAR.OptionsFrame.LayoutSpaceText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.LayoutSpaceText:SetText(BattlegroundTargets_Options.LayoutSpace[currentSize])
	GVAR.OptionsFrame.LayoutSpaceText:SetTextColor(1, 1, 0.49, 1)
	local layoutW = 30 + GVAR.OptionsFrame.LayoutTHText:GetStringWidth() + 10 +
	                     GVAR.OptionsFrame.LayoutTHx18:GetWidth() + 0 +
	                     GVAR.OptionsFrame.LayoutTHx24:GetWidth() + 0 +
	                     GVAR.OptionsFrame.LayoutTHx42:GetWidth() + 0 +
	                     GVAR.OptionsFrame.LayoutTHx81:GetWidth() + 0 +
	                     GVAR.OptionsFrame.LayoutSpace:GetWidth() + 50



	-- summary
	GVAR.OptionsFrame.SummaryText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.SummaryText:SetHeight(16)
	GVAR.OptionsFrame.SummaryText:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 30, 0)
	GVAR.OptionsFrame.SummaryText:SetPoint("TOP", GVAR.OptionsFrame.LayoutTHText, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.SummaryText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.SummaryText:SetText(L["Summary"]..":")
	GVAR.OptionsFrame.SummaryText:SetTextColor(1, 1, 1, 1)

	GVAR.OptionsFrame.Summary = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets) -- SUMMARY
	TEMPLATE.CheckButton(GVAR.OptionsFrame.Summary, 16, 0, "")
	GVAR.OptionsFrame.Summary:SetPoint("LEFT", GVAR.OptionsFrame.SummaryText, "RIGHT", 10, 0)
	GVAR.OptionsFrame.Summary:SetChecked(BattlegroundTargets_Options.Summary[currentSize])
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.Summary)
	GVAR.OptionsFrame.Summary:SetScript("OnClick", function()
		BattlegroundTargets_Options.Summary[currentSize] = not BattlegroundTargets_Options.Summary[currentSize]
		if BattlegroundTargets_Options.Summary[currentSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.SummaryScaleRole)
			if BattlegroundTargets_Options.ButtonShowGuildGroup[currentSize] then
				TEMPLATE.EnableSlider(GVAR.OptionsFrame.SummaryScaleGuildGroup)
			else
				TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScaleGuildGroup)
			end
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScaleRole)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScaleGuildGroup)
		end
		BattlegroundTargets:ShuffleSizeCheck(currentSize)
		BattlegroundTargets:ConfigGuildGroupFriendUpdate(currentSize)
		BattlegroundTargets:EnableConfigMode()
	end)

	GVAR.OptionsFrame.SummaryScaleRole = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.SummaryScaleRoleText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.SummaryScaleRole, 85, 5, 40, 150, BattlegroundTargets_Options.SummaryScaleRole[currentSize],
	function(self, value)
		local nvalue = value/100
		if nvalue == BattlegroundTargets_Options.SummaryScaleRole[currentSize] then return end
		BattlegroundTargets_Options.SummaryScaleRole[currentSize] = nvalue
		GVAR.OptionsFrame.SummaryScaleRoleText:SetText(value.."%")
		BattlegroundTargets:SummaryPosition()
	end,
	"blank")
	GVAR.OptionsFrame.SummaryScaleRole:SetPoint("LEFT", GVAR.OptionsFrame.Summary, "RIGHT", 10, 0)
	GVAR.OptionsFrame.SummaryScaleRoleText:SetHeight(16)
	GVAR.OptionsFrame.SummaryScaleRoleText:SetPoint("LEFT", GVAR.OptionsFrame.SummaryScaleRole, "RIGHT", 5, 0)
	GVAR.OptionsFrame.SummaryScaleRoleText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.SummaryScaleRoleText:SetText((BattlegroundTargets_Options.SummaryScaleRole[currentSize]*100).."%")
	GVAR.OptionsFrame.SummaryScaleRoleText:SetTextColor(1, 1, 0.49, 1)

	GVAR.OptionsFrame.SummaryScaleGuildGroup = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.SummaryScaleGuildGroupText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.SummaryScaleGuildGroup, 85, 5, 80, 200, BattlegroundTargets_Options.SummaryScaleGuildGroup[currentSize],
	function(self, value)
		local nvalue = value/100
		if nvalue == BattlegroundTargets_Options.SummaryScaleGuildGroup[currentSize] then return end
		BattlegroundTargets_Options.SummaryScaleGuildGroup[currentSize] = nvalue
		GVAR.OptionsFrame.SummaryScaleGuildGroupText:SetText(value.."%")
		BattlegroundTargets:SummaryPosition()
	end,
	"blank")
	GVAR.OptionsFrame.SummaryScaleGuildGroup:SetPoint("LEFT", GVAR.OptionsFrame.SummaryScaleRole, "RIGHT", 50, 0)
	GVAR.OptionsFrame.SummaryScaleGuildGroupText:SetHeight(16)
	GVAR.OptionsFrame.SummaryScaleGuildGroupText:SetPoint("LEFT", GVAR.OptionsFrame.SummaryScaleGuildGroup, "RIGHT", 5, 0)
	GVAR.OptionsFrame.SummaryScaleGuildGroupText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.SummaryScaleGuildGroupText:SetText((BattlegroundTargets_Options.SummaryScaleGuildGroup[currentSize]*100).."%")
	GVAR.OptionsFrame.SummaryScaleGuildGroupText:SetTextColor(1, 1, 0.49, 1)

	GVAR.OptionsFrame.SummaryScaleRole:SetValue(BattlegroundTargets_Options.SummaryScaleRole[currentSize]*100)
	GVAR.OptionsFrame.SummaryScaleGuildGroup:SetValue(BattlegroundTargets_Options.SummaryScaleGuildGroup[currentSize]*100)

	if BattlegroundTargets_Options.Summary[currentSize] then
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.SummaryScaleRole)
		if BattlegroundTargets_Options.ButtonShowGuildGroup[currentSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.SummaryScaleGuildGroup)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScaleGuildGroup)
		end
	else
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScaleRole)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScaleGuildGroup)
	end
	local summaryW = 30 + GVAR.OptionsFrame.SummaryText:GetStringWidth() + 10 +
	                      GVAR.OptionsFrame.Summary:GetWidth() + 10 +
	                      GVAR.OptionsFrame.SummaryScaleRole:GetWidth() + 50 +
	                      GVAR.OptionsFrame.SummaryScaleGuildGroup:GetWidth() + 50


	-- copy settings
	GVAR.OptionsFrame.CopySettings = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.TextButton(GVAR.OptionsFrame.CopySettings, string_format(L["Copy this settings to '%s'"], L["15 vs 15"]), 4)
	-- BOOM GVAR.OptionsFrame.CopySettings:SetPoint()
	GVAR.OptionsFrame.CopySettings:SetPoint("TOP", GVAR.OptionsFrame.Dummy1, "BOTTOM", 0, -62) -- 10+16+10+16+10
	GVAR.OptionsFrame.CopySettings:SetWidth(GVAR.OptionsFrame.CopySettings:GetTextWidth()+40)
	GVAR.OptionsFrame.CopySettings:SetHeight(24)
	GVAR.OptionsFrame.CopySettings:SetScript("OnClick", function() BattlegroundTargets:CopySettings(currentSize) end)
	GVAR.OptionsFrame.CopySettings:SetScript("OnEnter", function()
		GVAR.OptionsFrame.LayoutTHx18.Highlight:Show()
		GVAR.OptionsFrame.LayoutTHx24.Highlight:Show()
		GVAR.OptionsFrame.LayoutTHx42.Highlight:Show()
		GVAR.OptionsFrame.LayoutTHx81.Highlight:Show()
		GVAR.OptionsFrame.LayoutSpace.Background:SetTexture(1, 1, 1, 0.1)
		GVAR.OptionsFrame.Summary.Highlight:Show()
		GVAR.OptionsFrame.SummaryScaleRole.Background:SetTexture(1, 1, 1, 0.1)
		GVAR.OptionsFrame.SummaryScaleGuildGroup.Background:SetTexture(1, 1, 1, 0.1)----------
		GVAR.OptionsFrame.ShowRole.Highlight:Show()
		GVAR.OptionsFrame.ShowSpec.Highlight:Show()
		GVAR.OptionsFrame.ClassIcon.Highlight:Show()
		GVAR.OptionsFrame.ShowLeader.Highlight:Show()
		GVAR.OptionsFrame.ShowRealm.Highlight:Show()
		GVAR.OptionsFrame.ShowTargetCount.Highlight:Show()
		GVAR.OptionsFrame.ShowGuildGroup.Highlight:Show()
		GVAR.OptionsFrame.GuildGroupPosition.Background:SetTexture(1, 1, 1, 0.1)----------
		GVAR.OptionsFrame.ShowTargetIndicator.Highlight:Show()
		GVAR.OptionsFrame.TargetScaleSlider.Background:SetTexture(1, 1, 1, 0.1)
		GVAR.OptionsFrame.TargetPositionSlider.Background:SetTexture(1, 1, 1, 0.1)
		GVAR.OptionsFrame.ShowFocusIndicator.Highlight:Show()
		GVAR.OptionsFrame.FocusScaleSlider.Background:SetTexture(1, 1, 1, 0.1)
		GVAR.OptionsFrame.FocusPositionSlider.Background:SetTexture(1, 1, 1, 0.1)
		GVAR.OptionsFrame.ShowFlag.Highlight:Show()
		GVAR.OptionsFrame.FlagScaleSlider.Background:SetTexture(1, 1, 1, 0.1)
		GVAR.OptionsFrame.FlagPositionSlider.Background:SetTexture(1, 1, 1, 0.1)
		GVAR.OptionsFrame.ShowAssist.Highlight:Show()
		GVAR.OptionsFrame.AssistScaleSlider.Background:SetTexture(1, 1, 1, 0.1)
		GVAR.OptionsFrame.AssistPositionSlider.Background:SetTexture(1, 1, 1, 0.1)----------
		GVAR.OptionsFrame.ShowHealthBar.Highlight:Show()
		GVAR.OptionsFrame.ShowHealthText.Highlight:Show()
		GVAR.OptionsFrame.RangeCheck.Highlight:Show()
		GVAR.OptionsFrame.RangeCheckTypePullDown:LockHighlight()
		GVAR.OptionsFrame.RangeDisplayPullDown:LockHighlight()
		GVAR.OptionsFrame.SortByPullDown:LockHighlight()
		GVAR.OptionsFrame.SortDetailPullDown:LockHighlight()----------
		GVAR.OptionsFrame.FontSlider.Background:SetTexture(1, 1, 1, 0.1)
		GVAR.OptionsFrame.ScaleSlider.Background:SetTexture(1, 1, 1, 0.1)
		GVAR.OptionsFrame.WidthSlider.Background:SetTexture(1, 1, 1, 0.1)
		GVAR.OptionsFrame.HeightSlider.Background:SetTexture(1, 1, 1, 0.1)
	end)
	GVAR.OptionsFrame.CopySettings:SetScript("OnLeave", function()
		GVAR.OptionsFrame.LayoutTHx18.Highlight:Hide()
		GVAR.OptionsFrame.LayoutTHx24.Highlight:Hide()
		GVAR.OptionsFrame.LayoutTHx42.Highlight:Hide()
		GVAR.OptionsFrame.LayoutTHx81.Highlight:Hide()
		GVAR.OptionsFrame.LayoutSpace.Background:SetTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.Summary.Highlight:Hide()
		GVAR.OptionsFrame.SummaryScaleRole.Background:SetTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.SummaryScaleGuildGroup.Background:SetTexture(0, 0, 0, 0)----------
		GVAR.OptionsFrame.ShowRole.Highlight:Hide()
		GVAR.OptionsFrame.ShowSpec.Highlight:Hide()
		GVAR.OptionsFrame.ClassIcon.Highlight:Hide()
		GVAR.OptionsFrame.ShowLeader.Highlight:Hide()
		GVAR.OptionsFrame.ShowRealm.Highlight:Hide()
		GVAR.OptionsFrame.ShowTargetCount.Highlight:Hide()
		GVAR.OptionsFrame.ShowGuildGroup.Highlight:Hide()
		GVAR.OptionsFrame.GuildGroupPosition.Background:SetTexture(0, 0, 0, 0)----------
		GVAR.OptionsFrame.ShowTargetIndicator.Highlight:Hide()
		GVAR.OptionsFrame.TargetScaleSlider.Background:SetTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.TargetPositionSlider.Background:SetTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.ShowFocusIndicator.Highlight:Hide()
		GVAR.OptionsFrame.FocusScaleSlider.Background:SetTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.FocusPositionSlider.Background:SetTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.ShowFlag.Highlight:Hide()
		GVAR.OptionsFrame.FlagScaleSlider.Background:SetTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.FlagPositionSlider.Background:SetTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.ShowAssist.Highlight:Hide()
		GVAR.OptionsFrame.AssistScaleSlider.Background:SetTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.AssistPositionSlider.Background:SetTexture(0, 0, 0, 0)----------
		GVAR.OptionsFrame.ShowHealthBar.Highlight:Hide()
		GVAR.OptionsFrame.ShowHealthText.Highlight:Hide()
		GVAR.OptionsFrame.RangeCheck.Highlight:Hide()
		GVAR.OptionsFrame.RangeCheckTypePullDown:UnlockHighlight()
		GVAR.OptionsFrame.RangeDisplayPullDown:UnlockHighlight()
		GVAR.OptionsFrame.SortByPullDown:UnlockHighlight()
		GVAR.OptionsFrame.SortDetailPullDown:UnlockHighlight()----------
		GVAR.OptionsFrame.FontSlider.Background:SetTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.ScaleSlider.Background:SetTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.WidthSlider.Background:SetTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.HeightSlider.Background:SetTexture(0, 0, 0, 0)
	end)



	-- show role
	GVAR.OptionsFrame.ShowRole = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowRole, 16, 4, L["Show Role"])
	GVAR.OptionsFrame.ShowRole:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ShowRole:SetPoint("TOP", GVAR.OptionsFrame.CopySettings, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.ShowRole:SetChecked(OPT.ButtonShowRole[currentSize])
	GVAR.OptionsFrame.ShowRole:SetScript("OnClick", function()
		BattlegroundTargets_Options.ButtonShowRole[currentSize] = not BattlegroundTargets_Options.ButtonShowRole[currentSize]
		                        OPT.ButtonShowRole[currentSize] = not                         OPT.ButtonShowRole[currentSize]
		GVAR.OptionsFrame.ShowRole:SetChecked(OPT.ButtonShowRole[currentSize])
		BattlegroundTargets:EnableConfigMode()
	end)

	-- show spec
	GVAR.OptionsFrame.ShowSpec = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowSpec, 16, 4, L["Show Specialization"])
	GVAR.OptionsFrame.ShowSpec:SetPoint("LEFT", GVAR.OptionsFrame.ShowRole, "RIGHT", 20, 0)
	GVAR.OptionsFrame.ShowSpec:SetChecked(OPT.ButtonShowSpec[currentSize])
	GVAR.OptionsFrame.ShowSpec:SetScript("OnClick", function()
		BattlegroundTargets_Options.ButtonShowSpec[currentSize] = not BattlegroundTargets_Options.ButtonShowSpec[currentSize]
		                        OPT.ButtonShowSpec[currentSize] = not                         OPT.ButtonShowSpec[currentSize]
		GVAR.OptionsFrame.ShowSpec:SetChecked(OPT.ButtonShowSpec[currentSize])
		BattlegroundTargets:EnableConfigMode()
	end)

	-- class icon
	GVAR.OptionsFrame.ClassIcon = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ClassIcon, 16, 4, L["Show Class Icon"])
	GVAR.OptionsFrame.ClassIcon:SetPoint("LEFT", GVAR.OptionsFrame.ShowSpec, "RIGHT", 20, 0)
	GVAR.OptionsFrame.ClassIcon:SetChecked(OPT.ButtonClassIcon[currentSize])
	GVAR.OptionsFrame.ClassIcon:SetScript("OnClick", function()
		BattlegroundTargets_Options.ButtonClassIcon[currentSize] = not BattlegroundTargets_Options.ButtonClassIcon[currentSize]
		                        OPT.ButtonClassIcon[currentSize] = not                         OPT.ButtonClassIcon[currentSize]
		GVAR.OptionsFrame.ClassIcon:SetChecked(OPT.ButtonClassIcon[currentSize])
		BattlegroundTargets:EnableConfigMode()
	end)
	local generalIconW = 10 + GVAR.OptionsFrame.ShowRole:GetWidth() + 20 +
	                          GVAR.OptionsFrame.ShowSpec:GetWidth() + 20 +
	                          GVAR.OptionsFrame.ClassIcon:GetWidth() + 10

	-- show realm
	GVAR.OptionsFrame.ShowRealm = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowRealm, 16, 4, L["Hide Realm"])
	GVAR.OptionsFrame.ShowRealm:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ShowRealm:SetPoint("TOP", GVAR.OptionsFrame.ShowRole, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.ShowRealm:SetChecked(OPT.ButtonHideRealm[currentSize])
	GVAR.OptionsFrame.ShowRealm:SetScript("OnClick", function()
		BattlegroundTargets_Options.ButtonHideRealm[currentSize] = not BattlegroundTargets_Options.ButtonHideRealm[currentSize]
		                        OPT.ButtonHideRealm[currentSize] = not                         OPT.ButtonHideRealm[currentSize]
		GVAR.OptionsFrame.ShowRealm:SetChecked(OPT.ButtonHideRealm[currentSize])
		BattlegroundTargets:EnableConfigMode()
	end)

	-- show leader
	GVAR.OptionsFrame.ShowLeader = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowLeader, 16, 4, L["Show Leader"])
	-- BOOM GVAR.OptionsFrame.ShowLeader:SetPoint()
	GVAR.OptionsFrame.ShowLeader:SetPoint("TOP", GVAR.OptionsFrame.ShowRealm, "TOP", 0, 0)
	GVAR.OptionsFrame.ShowLeader:SetChecked(OPT.ButtonShowLeader[currentSize])
	GVAR.OptionsFrame.ShowLeader:SetScript("OnClick", function()
		BattlegroundTargets_Options.ButtonShowLeader[currentSize] = not BattlegroundTargets_Options.ButtonShowLeader[currentSize]
		                        OPT.ButtonShowLeader[currentSize] = not                         OPT.ButtonShowLeader[currentSize]
		GVAR.OptionsFrame.ShowLeader:SetChecked(OPT.ButtonShowLeader[currentSize])
		BattlegroundTargets:EnableConfigMode()
	end)

	-- show targetcount
	GVAR.OptionsFrame.ShowTargetCount = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowTargetCount, 16, 4, L["Show Target Count"])
	GVAR.OptionsFrame.ShowTargetCount:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ShowTargetCount:SetPoint("TOP", GVAR.OptionsFrame.ShowRealm, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.ShowTargetCount:SetChecked(OPT.ButtonShowTargetCount[currentSize])
	GVAR.OptionsFrame.ShowTargetCount:SetScript("OnClick", function()
		BattlegroundTargets_Options.ButtonShowTargetCount[currentSize] = not BattlegroundTargets_Options.ButtonShowTargetCount[currentSize]
		                        OPT.ButtonShowTargetCount[currentSize] = not                         OPT.ButtonShowTargetCount[currentSize]
		GVAR.OptionsFrame.ShowTargetCount:SetChecked(OPT.ButtonShowTargetCount[currentSize])
		BattlegroundTargets:EnableConfigMode()
	end)

	-- show guildgroup
	GVAR.OptionsFrame.ShowGuildGroup = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowGuildGroup, 16, 4, L["Show Guild Groups"])
	GVAR.OptionsFrame.ShowGuildGroup:SetPoint("LEFT", GVAR.OptionsFrame.ShowLeader, "LEFT", 0, 0)
	GVAR.OptionsFrame.ShowGuildGroup:SetPoint("TOP", GVAR.OptionsFrame.ShowRealm, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.ShowGuildGroup:SetChecked(OPT.ButtonShowGuildGroup[currentSize])
	GVAR.OptionsFrame.ShowGuildGroup:SetScript("OnClick", function()
		BattlegroundTargets_Options.ButtonShowGuildGroup[currentSize] = not BattlegroundTargets_Options.ButtonShowGuildGroup[currentSize]
		                        OPT.ButtonShowGuildGroup[currentSize] = not                         OPT.ButtonShowGuildGroup[currentSize]
		GVAR.OptionsFrame.ShowGuildGroup:SetChecked(OPT.ButtonShowGuildGroup[currentSize])
		if OPT.ButtonShowGuildGroup[currentSize] and
		   BattlegroundTargets_Options.Summary[currentSize]
		then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.SummaryScaleGuildGroup)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScaleGuildGroup)
		end
		if OPT.ButtonShowGuildGroup[currentSize] then
			BattlegroundTargets:ShuffleSizeCheck(currentSize)
			BattlegroundTargets:ConfigGuildGroupFriendUpdate(currentSize)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.GuildGroupPosition)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.GuildGroupPosition)
		end
		BattlegroundTargets:EnableConfigMode()
	end)

	GVAR.OptionsFrame.GuildGroupPosition = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.GuildGroupPositionText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.GuildGroupPosition, 50, 1, 1, 6, OPT.ButtonGuildGroupPosition[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options.ButtonGuildGroupPosition[currentSize] then return end
		BattlegroundTargets_Options.ButtonGuildGroupPosition[currentSize] = value
		                        OPT.ButtonGuildGroupPosition[currentSize] = value
		GVAR.OptionsFrame.GuildGroupPositionText:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.GuildGroupPosition:SetPoint("LEFT", GVAR.OptionsFrame.ShowGuildGroup, "RIGHT", 10, 0)
	GVAR.OptionsFrame.GuildGroupPositionText:SetHeight(16)
	GVAR.OptionsFrame.GuildGroupPositionText:SetPoint("LEFT", GVAR.OptionsFrame.GuildGroupPosition, "RIGHT", 5, 0)
	GVAR.OptionsFrame.GuildGroupPositionText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.GuildGroupPositionText:SetText(BattlegroundTargets_Options.ButtonGuildGroupPosition[currentSize])
	GVAR.OptionsFrame.GuildGroupPositionText:SetTextColor(1, 1, 0.49, 1)



	-- ----- icons ----------------------------------------
	local equalTextWidthIcons = 0
	-- show target indicator
	GVAR.OptionsFrame.ShowTargetIndicator = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowTargetIndicator, 16, 4, L["Show Target"])
	GVAR.OptionsFrame.ShowTargetIndicator:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ShowTargetIndicator:SetPoint("TOP", GVAR.OptionsFrame.ShowTargetCount, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.ShowTargetIndicator:SetChecked(OPT.ButtonShowTarget[currentSize])
	GVAR.OptionsFrame.ShowTargetIndicator:SetScript("OnClick", function()
		BattlegroundTargets_Options.ButtonShowTarget[currentSize] = not BattlegroundTargets_Options.ButtonShowTarget[currentSize]
		                        OPT.ButtonShowTarget[currentSize] = not                         OPT.ButtonShowTarget[currentSize]
		GVAR.OptionsFrame.ShowTargetIndicator:SetChecked(OPT.ButtonShowTarget[currentSize])
		if OPT.ButtonShowTarget[currentSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.TargetScaleSlider)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.TargetPositionSlider)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.TargetScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.TargetPositionSlider)
		end
		BattlegroundTargets:EnableConfigMode()
	end)
	local iw = GVAR.OptionsFrame.ShowTargetIndicator:GetWidth()
	if iw > equalTextWidthIcons then
		equalTextWidthIcons = iw
	end

	-- target indicator scale
	GVAR.OptionsFrame.TargetScaleSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.TargetScaleSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.TargetScaleSlider, 85, 10, 100, 200, OPT.ButtonTargetScale[currentSize]*100,
	function(self, value)
		local nvalue = value/100
		if nvalue == BattlegroundTargets_Options.ButtonTargetScale[currentSize] then return end
		BattlegroundTargets_Options.ButtonTargetScale[currentSize] = nvalue
		                        OPT.ButtonTargetScale[currentSize] = nvalue
		GVAR.OptionsFrame.TargetScaleSliderText:SetText(value.."%")
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.TargetScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ShowTargetIndicator, "RIGHT", 10, 0)
	GVAR.OptionsFrame.TargetScaleSliderText:SetHeight(20)
	GVAR.OptionsFrame.TargetScaleSliderText:SetPoint("LEFT", GVAR.OptionsFrame.TargetScaleSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.TargetScaleSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.TargetScaleSliderText:SetText((OPT.ButtonTargetScale[currentSize]*100).."%")
	GVAR.OptionsFrame.TargetScaleSliderText:SetTextColor(1, 1, 0.49, 1)

	-- target indicator position
	GVAR.OptionsFrame.TargetPositionSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.TargetPositionSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.TargetPositionSlider, 85, 5, 0, 100, OPT.ButtonTargetPosition[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options.ButtonTargetPosition[currentSize] then return end
		BattlegroundTargets_Options.ButtonTargetPosition[currentSize] = value
		                        OPT.ButtonTargetPosition[currentSize] = value
		GVAR.OptionsFrame.TargetPositionSliderText:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.TargetPositionSlider:SetPoint("LEFT", GVAR.OptionsFrame.TargetScaleSlider, "RIGHT", 50, 0)
	GVAR.OptionsFrame.TargetPositionSliderText:SetHeight(20)
	GVAR.OptionsFrame.TargetPositionSliderText:SetPoint("LEFT", GVAR.OptionsFrame.TargetPositionSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.TargetPositionSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.TargetPositionSliderText:SetText(OPT.ButtonTargetPosition[currentSize])
	GVAR.OptionsFrame.TargetPositionSliderText:SetTextColor(1, 1, 0.49, 1)

	-- show focus indicator
	GVAR.OptionsFrame.ShowFocusIndicator = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowFocusIndicator, 16, 4, L["Show Focus"])
	GVAR.OptionsFrame.ShowFocusIndicator:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ShowFocusIndicator:SetPoint("TOP", GVAR.OptionsFrame.ShowTargetIndicator, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.ShowFocusIndicator:SetChecked(OPT.ButtonShowFocus[currentSize])
	GVAR.OptionsFrame.ShowFocusIndicator:SetScript("OnClick", function()
		BattlegroundTargets_Options.ButtonShowFocus[currentSize] = not BattlegroundTargets_Options.ButtonShowFocus[currentSize]
		                        OPT.ButtonShowFocus[currentSize] = not                         OPT.ButtonShowFocus[currentSize]
		GVAR.OptionsFrame.ShowFocusIndicator:SetChecked(OPT.ButtonShowFocus[currentSize])
		if OPT.ButtonShowFocus[currentSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.FocusScaleSlider)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.FocusPositionSlider)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FocusScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FocusPositionSlider)
		end
		BattlegroundTargets:EnableConfigMode()
	end)
	local iw = GVAR.OptionsFrame.ShowFocusIndicator:GetWidth()
	if iw > equalTextWidthIcons then
		equalTextWidthIcons = iw
	end

	-- focus indicator scale
	GVAR.OptionsFrame.FocusScaleSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.FocusScaleSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.FocusScaleSlider, 85, 10, 100, 200, OPT.ButtonFocusScale[currentSize]*100,
	function(self, value)
		local nvalue = value/100
		if nvalue == BattlegroundTargets_Options.ButtonFocusScale[currentSize] then return end
		BattlegroundTargets_Options.ButtonFocusScale[currentSize] = nvalue
		                        OPT.ButtonFocusScale[currentSize] = nvalue
		GVAR.OptionsFrame.FocusScaleSliderText:SetText(value.."%")
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.FocusScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ShowFocusIndicator, "RIGHT", 10, 0)
	GVAR.OptionsFrame.FocusScaleSliderText:SetHeight(20)
	GVAR.OptionsFrame.FocusScaleSliderText:SetPoint("LEFT", GVAR.OptionsFrame.FocusScaleSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.FocusScaleSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.FocusScaleSliderText:SetText((OPT.ButtonFocusScale[currentSize]*100).."%")
	GVAR.OptionsFrame.FocusScaleSliderText:SetTextColor(1, 1, 0.49, 1)

	-- focus indicator position
	GVAR.OptionsFrame.FocusPositionSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.FocusPositionSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.FocusPositionSlider, 85, 5, 0, 100, OPT.ButtonFocusPosition[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options.ButtonFocusPosition[currentSize] then return end
		BattlegroundTargets_Options.ButtonFocusPosition[currentSize] = value
		                        OPT.ButtonFocusPosition[currentSize] = value
		GVAR.OptionsFrame.FocusPositionSliderText:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.FocusPositionSlider:SetPoint("LEFT", GVAR.OptionsFrame.FocusScaleSlider, "RIGHT", 50, 0)
	GVAR.OptionsFrame.FocusPositionSliderText:SetHeight(20)
	GVAR.OptionsFrame.FocusPositionSliderText:SetPoint("LEFT", GVAR.OptionsFrame.FocusPositionSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.FocusPositionSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.FocusPositionSliderText:SetText(OPT.ButtonFocusPosition[currentSize])
	GVAR.OptionsFrame.FocusPositionSliderText:SetTextColor(1, 1, 0.49, 1)

	-- show flag
	GVAR.OptionsFrame.ShowFlag = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowFlag, 16, 4, L["Show Flag Carrier"])
	GVAR.OptionsFrame.ShowFlag:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ShowFlag:SetPoint("TOP", GVAR.OptionsFrame.ShowFocusIndicator, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.ShowFlag:SetChecked(OPT.ButtonShowFlag[currentSize])
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowFlag)
	GVAR.OptionsFrame.ShowFlag:SetScript("OnClick", function()
		BattlegroundTargets_Options.ButtonShowFlag[currentSize] = not BattlegroundTargets_Options.ButtonShowFlag[currentSize]
		                        OPT.ButtonShowFlag[currentSize] = not                         OPT.ButtonShowFlag[currentSize]
		if OPT.ButtonShowFlag[currentSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.FlagScaleSlider)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.FlagPositionSlider)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagPositionSlider)
		end
		BattlegroundTargets:EnableConfigMode()
	end)
	local iw = GVAR.OptionsFrame.ShowFlag:GetWidth()
	if iw > equalTextWidthIcons then
		equalTextWidthIcons = iw
	end

	-- flag scale
	GVAR.OptionsFrame.FlagScaleSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.FlagScaleSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.FlagScaleSlider, 85, 10, 100, 200, OPT.ButtonFlagScale[currentSize]*100,
	function(self, value)
		local nvalue = value/100
		if nvalue == BattlegroundTargets_Options.ButtonFlagScale[currentSize] then return end
		BattlegroundTargets_Options.ButtonFlagScale[currentSize] = nvalue
		                        OPT.ButtonFlagScale[currentSize] = nvalue
		GVAR.OptionsFrame.FlagScaleSliderText:SetText(value.."%")
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.FlagScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ShowFlag, "RIGHT", 10, 0)
	GVAR.OptionsFrame.FlagScaleSliderText:SetHeight(20)
	GVAR.OptionsFrame.FlagScaleSliderText:SetPoint("LEFT", GVAR.OptionsFrame.FlagScaleSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.FlagScaleSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.FlagScaleSliderText:SetText((OPT.ButtonFlagScale[currentSize]*100).."%")
	GVAR.OptionsFrame.FlagScaleSliderText:SetTextColor(1, 1, 0.49, 1)

	-- flag position
	GVAR.OptionsFrame.FlagPositionSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.FlagPositionSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.FlagPositionSlider, 85, 5, 0, 100, OPT.ButtonFlagPosition[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options.ButtonFlagPosition[currentSize] then return end
		BattlegroundTargets_Options.ButtonFlagPosition[currentSize] = value
		                        OPT.ButtonFlagPosition[currentSize] = value
		GVAR.OptionsFrame.FlagPositionSliderText:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.FlagPositionSlider:SetPoint("LEFT", GVAR.OptionsFrame.FlagScaleSlider, "RIGHT", 50, 0)
	GVAR.OptionsFrame.FlagPositionSliderText:SetHeight(20)
	GVAR.OptionsFrame.FlagPositionSliderText:SetPoint("LEFT", GVAR.OptionsFrame.FlagPositionSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.FlagPositionSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.FlagPositionSliderText:SetText(OPT.ButtonFlagPosition[currentSize])
	GVAR.OptionsFrame.FlagPositionSliderText:SetTextColor(1, 1, 0.49, 1)

	-- show assist
	GVAR.OptionsFrame.ShowAssist = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowAssist, 16, 4, L["Show Main Assist Target"])
	GVAR.OptionsFrame.ShowAssist:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ShowAssist:SetPoint("TOP", GVAR.OptionsFrame.ShowFlag, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.ShowAssist:SetChecked(OPT.ButtonShowAssist[currentSize])
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowAssist)
	GVAR.OptionsFrame.ShowAssist:SetScript("OnClick", function()
		BattlegroundTargets_Options.ButtonShowAssist[currentSize] = not BattlegroundTargets_Options.ButtonShowAssist[currentSize]
		                        OPT.ButtonShowAssist[currentSize] = not                         OPT.ButtonShowAssist[currentSize]
		if OPT.ButtonShowAssist[currentSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.AssistScaleSlider)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.AssistPositionSlider)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.AssistScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.AssistPositionSlider)
		end
		BattlegroundTargets:EnableConfigMode()
	end)
	local iw = GVAR.OptionsFrame.ShowAssist:GetWidth()
	if iw > equalTextWidthIcons then
		equalTextWidthIcons = iw
	end

	-- assist scale
	GVAR.OptionsFrame.AssistScaleSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.AssistScaleSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.AssistScaleSlider, 85, 10, 100, 200, OPT.ButtonAssistScale[currentSize]*100,
	function(self, value)
		local nvalue = value/100
		if nvalue == BattlegroundTargets_Options.ButtonAssistScale[currentSize] then return end
		BattlegroundTargets_Options.ButtonAssistScale[currentSize] = nvalue
		                        OPT.ButtonAssistScale[currentSize] = nvalue
		GVAR.OptionsFrame.AssistScaleSliderText:SetText(value.."%")
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.AssistScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ShowAssist, "RIGHT", 10, 0)
	GVAR.OptionsFrame.AssistScaleSliderText:SetHeight(20)
	GVAR.OptionsFrame.AssistScaleSliderText:SetPoint("LEFT", GVAR.OptionsFrame.AssistScaleSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.AssistScaleSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.AssistScaleSliderText:SetText((OPT.ButtonAssistScale[currentSize]*100).."%")
	GVAR.OptionsFrame.AssistScaleSliderText:SetTextColor(1, 1, 0.49, 1)

	-- assist position
	GVAR.OptionsFrame.AssistPositionSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.AssistPositionSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.AssistPositionSlider, 85, 5, 0, 100, OPT.ButtonAssistPosition[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options.ButtonAssistPosition[currentSize] then return end
		BattlegroundTargets_Options.ButtonAssistPosition[currentSize] = value
		                        OPT.ButtonAssistPosition[currentSize] = value
		GVAR.OptionsFrame.AssistPositionSliderText:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.AssistPositionSlider:SetPoint("LEFT", GVAR.OptionsFrame.AssistScaleSlider, "RIGHT", 50, 0)
	GVAR.OptionsFrame.AssistPositionSliderText:SetHeight(20)
	GVAR.OptionsFrame.AssistPositionSliderText:SetPoint("LEFT", GVAR.OptionsFrame.AssistPositionSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.AssistPositionSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.AssistPositionSliderText:SetText(OPT.ButtonAssistPosition[currentSize])
	GVAR.OptionsFrame.AssistPositionSliderText:SetTextColor(1, 1, 0.49, 1)


	GVAR.OptionsFrame.TargetScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ShowTargetIndicator, "LEFT", equalTextWidthIcons+10, 0)
	GVAR.OptionsFrame.FocusScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ShowFocusIndicator, "LEFT", equalTextWidthIcons+10, 0)
	GVAR.OptionsFrame.FlagScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ShowFlag, "LEFT", equalTextWidthIcons+10, 0)
	GVAR.OptionsFrame.AssistScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ShowAssist, "LEFT", equalTextWidthIcons+10, 0)
	local iconW = 10 + equalTextWidthIcons + 10 + GVAR.OptionsFrame.TargetScaleSlider:GetWidth() + 50 + GVAR.OptionsFrame.TargetPositionSlider:GetWidth() + 50
	-- ----- icons ----------------------------------------



	-- show healt bar
	GVAR.OptionsFrame.ShowHealthBar = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowHealthBar, 16, 4, L["Show Health Bar"])
	GVAR.OptionsFrame.ShowHealthBar:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ShowHealthBar:SetPoint("TOP", GVAR.OptionsFrame.ShowAssist, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.ShowHealthBar:SetChecked(OPT.ButtonShowHealthBar[currentSize])
	GVAR.OptionsFrame.ShowHealthBar:SetScript("OnClick", function()
		BattlegroundTargets_Options.ButtonShowHealthBar[currentSize] = not BattlegroundTargets_Options.ButtonShowHealthBar[currentSize]
		                        OPT.ButtonShowHealthBar[currentSize] = not                         OPT.ButtonShowHealthBar[currentSize]
		GVAR.OptionsFrame.ShowHealthBar:SetChecked(OPT.ButtonShowHealthBar[currentSize])
		BattlegroundTargets:EnableConfigMode()
	end)

	-- show healt text
	GVAR.OptionsFrame.ShowHealthText = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowHealthText, 16, 4, L["Show Percent"])
	GVAR.OptionsFrame.ShowHealthText:SetPoint("LEFT", GVAR.OptionsFrame.ShowHealthBar.Text, "RIGHT", 20, 0)
	GVAR.OptionsFrame.ShowHealthText:SetChecked(OPT.ButtonShowHealthText[currentSize])
	GVAR.OptionsFrame.ShowHealthText:SetScript("OnClick", function()
		BattlegroundTargets_Options.ButtonShowHealthText[currentSize] = not BattlegroundTargets_Options.ButtonShowHealthText[currentSize]
		                        OPT.ButtonShowHealthText[currentSize] = not                         OPT.ButtonShowHealthText[currentSize]
		GVAR.OptionsFrame.ShowHealthText:SetChecked(OPT.ButtonShowHealthText[currentSize])
		BattlegroundTargets:EnableConfigMode()
	end)



	-- ----- range check ----------------------------------------
	local rangeW = 0
		----- text
		local minRange, maxRange
		if ranges[playerClassEN] then
			local _, _, _, _, _, _, _, minR, maxR = GetSpellInfo(ranges[playerClassEN])
			minRange = minR
			maxRange = maxR
		end
		minRange = minRange or "?"
		maxRange = maxRange or "?"
		rangeTypeName[2] = "2) "..CLASS.." |cffffff79("..minRange.."-"..maxRange..")|r"
		rangeTypeName[3] = "3) "..L["Mix"].." 1 |cffffff79("..minRange.."-"..maxRange..") + (0-45)|r"
		rangeTypeName[4] = "4) "..L["Mix"].." 2 |cffffff79("..minRange.."-"..maxRange..") + ("..minRange.."-"..maxRange..")|r"
		local buttonName = rangeTypeName[1]
		if OPT.ButtonTypeRangeCheck[currentSize] == 2 then
			buttonName = rangeTypeName[2]
		elseif OPT.ButtonTypeRangeCheck[currentSize] == 3 then
			buttonName = rangeTypeName[3]
		elseif OPT.ButtonTypeRangeCheck[currentSize] == 4 then
			buttonName = rangeTypeName[4]
		end
		local rangeInfoTxt = ""
		rangeInfoTxt = rangeInfoTxt..rangeTypeName[1]..":\n"
		rangeInfoTxt = rangeInfoTxt.."   |cffffffff"..L["This option uses the CombatLog to check range."].."|r\n\n\n"
		rangeInfoTxt = rangeInfoTxt..rangeTypeName[2]..":\n"
		rangeInfoTxt = rangeInfoTxt.."   |cffffffff"..L["This option uses a pre-defined spell to check range:"].."|r\n"
		table_sort(class_IntegerSort, function(a, b) if a.loc < b.loc then return true end end)
		local playerMClass = "?"
		for i = 1, #class_IntegerSort do
			local classEN = class_IntegerSort[i].cid
if tocversion < 50000 and classEN ~= "MONK" then -- TODO_MoP
			local name, _, _, _, _, _, _, minRange, maxRange = GetSpellInfo(ranges[classEN])
			local classStr = "|cff"..ClassHexColor(classEN)..class_IntegerSort[i].loc.."|r   "..(minRange or "?").."-"..(maxRange or "?").."   |cffffffff"..(name or UNKNOWN).."|r   |cffbbbbbb(spell ID = "..ranges[classEN]..")|r"
			if classEN == playerClassEN then
				playerMClass = "|cff"..ClassHexColor(classEN)..class_IntegerSort[i].loc.."|r"
				rangeInfoTxt = rangeInfoTxt..">>> "..classStr.." <<<"
			else
				rangeInfoTxt = rangeInfoTxt.."     "..classStr
			end
			rangeInfoTxt = rangeInfoTxt.."\n"
end -- TODO_MoP
		end
		rangeInfoTxt = rangeInfoTxt.."\n\n"..rangeTypeName[3]..":\n"
		rangeInfoTxt = rangeInfoTxt.."   |cffffffff"..CLASS..":|r |cffffff79("..minRange.."-"..maxRange..")|r "..playerMClass.."\n"
		rangeInfoTxt = rangeInfoTxt.."   |cffffffffCombatLog:|r |cffffff79(0-45)|r\n"
		rangeInfoTxt = rangeInfoTxt.."   |cffaaaaaa(CombatLog: "..L["if you are attacked only"]..")|r\n"
		rangeInfoTxt = rangeInfoTxt.."\n\n"..rangeTypeName[4]..":\n"
		rangeInfoTxt = rangeInfoTxt.."   |cffffffff"..CLASS..":|r |cffffff79("..minRange.."-"..maxRange..")|r "..playerMClass.."\n"
		rangeInfoTxt = rangeInfoTxt.."   |cffffffffCombatLog|r |cffaaaaaa"..L["(class dependent)"]..":|r |cffffff79("..minRange.."-"..maxRange..")|r "..playerMClass.."\n"
		rangeInfoTxt = rangeInfoTxt.."   |cffaaaaaa(CombatLog: "..L["if you are attacked only"]..")|r\n"
		rangeInfoTxt = rangeInfoTxt.."\n\n\n"
		rangeInfoTxt = rangeInfoTxt.."|TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:24|t"
		rangeInfoTxt = rangeInfoTxt.."|cffffffff "..L["Disable this option if you have CPU/FPS problems in combat."].." |r"
		rangeInfoTxt = rangeInfoTxt.."|TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:24|t"
		----- text
	-- range check
	GVAR.OptionsFrame.RangeCheck = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.RangeCheck, 16, 4, L["Show Range"])
	GVAR.OptionsFrame.RangeCheck:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.RangeCheck:SetPoint("TOP", GVAR.OptionsFrame.ShowHealthBar, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.RangeCheck:SetChecked(OPT.ButtonRangeCheck[currentSize])
	GVAR.OptionsFrame.RangeCheck:SetScript("OnClick", function()
		BattlegroundTargets_Options.ButtonRangeCheck[currentSize] = not BattlegroundTargets_Options.ButtonRangeCheck[currentSize]
		                        OPT.ButtonRangeCheck[currentSize] = not                         OPT.ButtonRangeCheck[currentSize]
		GVAR.OptionsFrame.RangeCheck:SetChecked(OPT.ButtonRangeCheck[currentSize])
		if OPT.ButtonRangeCheck[currentSize] then
			TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.RangeCheckTypePullDown)
			GVAR.OptionsFrame.RangeCheckInfo:Enable() Desaturation(GVAR.OptionsFrame.RangeCheckInfo.Texture, false)
			TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.RangeDisplayPullDown)
		else
			TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.RangeCheckTypePullDown)
			GVAR.OptionsFrame.RangeCheckInfo:Disable() Desaturation(GVAR.OptionsFrame.RangeCheckInfo.Texture, true)
			TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.RangeDisplayPullDown)
		end
		BattlegroundTargets:EnableConfigMode()
	end)
	rangeW = rangeW + 10 + GVAR.OptionsFrame.RangeCheck:GetWidth()

	-- range check info
	GVAR.OptionsFrame.RangeCheckInfo = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.RangeCheckInfo:SetWidth(16)
	GVAR.OptionsFrame.RangeCheckInfo:SetHeight(16)
	GVAR.OptionsFrame.RangeCheckInfo:SetPoint("LEFT", GVAR.OptionsFrame.RangeCheck, "RIGHT", 10, 0)
	GVAR.OptionsFrame.RangeCheckInfo.Texture = GVAR.OptionsFrame.RangeCheckInfo:CreateTexture(nil, "ARTWORK")
	GVAR.OptionsFrame.RangeCheckInfo.Texture:SetWidth(16)
	GVAR.OptionsFrame.RangeCheckInfo.Texture:SetHeight(16)
	GVAR.OptionsFrame.RangeCheckInfo.Texture:SetPoint("LEFT", 0, 0)
	GVAR.OptionsFrame.RangeCheckInfo.Texture:SetTexture("Interface\\FriendsFrame\\InformationIcon")
	GVAR.OptionsFrame.RangeCheckInfo.TextFrame = CreateFrame("Frame", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.BorderTRBL(GVAR.OptionsFrame.RangeCheckInfo.TextFrame)
	GVAR.OptionsFrame.RangeCheckInfo.TextFrame:SetToplevel(true)
	GVAR.OptionsFrame.RangeCheckInfo.TextFrame:SetPoint("BOTTOM", GVAR.OptionsFrame.RangeCheckInfo.Texture, "TOP", 0, 0)
	GVAR.OptionsFrame.RangeCheckInfo.TextFrame:Hide()
	GVAR.OptionsFrame.RangeCheckInfo.Text = GVAR.OptionsFrame.RangeCheckInfo.TextFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.RangeCheckInfo.Text:SetPoint("CENTER", 0, 0)
	GVAR.OptionsFrame.RangeCheckInfo.Text:SetJustifyH("LEFT")
	GVAR.OptionsFrame.RangeCheckInfo.Text:SetText(rangeInfoTxt)
	GVAR.OptionsFrame.RangeCheckInfo.Text:SetTextColor(1, 1, 0.49, 1)
	GVAR.OptionsFrame.RangeCheckInfo:SetScript("OnEnter", function() GVAR.OptionsFrame.RangeCheckInfo.TextFrame:Show() end)
	GVAR.OptionsFrame.RangeCheckInfo:SetScript("OnLeave", function() GVAR.OptionsFrame.RangeCheckInfo.TextFrame:Hide() end)
	rangeW = rangeW + 10 + 16
		-----
		local txtWidth = GVAR.OptionsFrame.RangeCheckInfo.Text:GetStringWidth()
		local txtHeight = GVAR.OptionsFrame.RangeCheckInfo.Text:GetStringHeight()
		GVAR.OptionsFrame.RangeCheckInfo.TextFrame:SetWidth(txtWidth+30)
		GVAR.OptionsFrame.RangeCheckInfo.TextFrame:SetHeight(txtHeight+30)
		GVAR.OptionsFrame.RangeCheckInfo.Text:SetWidth(txtWidth+10)
		GVAR.OptionsFrame.RangeCheckInfo.Text:SetHeight(txtHeight+10)
		-----

	-- range type
	GVAR.OptionsFrame.RangeCheckTypePullDown = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.PullDownMenu(
		GVAR.OptionsFrame.RangeCheckTypePullDown,
		"RangeType",
		buttonName,
		0,
		4,
		RangeCheckTypePullDownFunc
	)
	GVAR.OptionsFrame.RangeCheckTypePullDown:SetPoint("LEFT", GVAR.OptionsFrame.RangeCheckInfo, "RIGHT", 10, 0)
	GVAR.OptionsFrame.RangeCheckTypePullDown:SetHeight(18)
	TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.RangeCheckTypePullDown)
	rangeW = rangeW + 10 + GVAR.OptionsFrame.RangeCheckTypePullDown:GetWidth()

	-- range alpha
	GVAR.OptionsFrame.RangeDisplayPullDown = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.PullDownMenu(
		GVAR.OptionsFrame.RangeDisplayPullDown,
		"RangeDisplay",
		rangeDisplay[ BattlegroundTargets_Options.ButtonRangeDisplay[currentSize] ],
		0,
		#rangeDisplay,
		RangeDisplayPullDownFunc
	)
	GVAR.OptionsFrame.RangeDisplayPullDown:SetPoint("LEFT", GVAR.OptionsFrame.RangeCheckTypePullDown, "RIGHT", 10, 0)
	GVAR.OptionsFrame.RangeDisplayPullDown:SetHeight(18)
	TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.RangeDisplayPullDown)
	rangeW = rangeW + 10 + GVAR.OptionsFrame.RangeDisplayPullDown:GetWidth() + 10
	-- ----- range check ----------------------------------------



	-- sort by
	local sortW = 0
	GVAR.OptionsFrame.SortByTitle = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.SortByTitle:SetHeight(16)
	GVAR.OptionsFrame.SortByTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.SortByTitle:SetPoint("TOP", GVAR.OptionsFrame.RangeCheck, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.SortByTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.SortByTitle:SetText(L["Sort By"]..":")
	GVAR.OptionsFrame.SortByTitle:SetTextColor(1, 1, 1, 1)
	sortW = sortW + 10 + GVAR.OptionsFrame.SortByTitle:GetStringWidth()

	GVAR.OptionsFrame.SortByPullDown = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.PullDownMenu(
		GVAR.OptionsFrame.SortByPullDown,
		"SortBy",
		sortBy[ OPT.ButtonSortBy[currentSize] ],
		0,
		#sortBy,
		SortByPullDownFunc
	)
	GVAR.OptionsFrame.SortByPullDown:SetPoint("LEFT", GVAR.OptionsFrame.SortByTitle, "RIGHT", 10, 0)
	GVAR.OptionsFrame.SortByPullDown:SetHeight(18)
	TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.SortByPullDown)
	sortW = sortW + 10 + GVAR.OptionsFrame.SortByPullDown:GetWidth()

	-- sort detail
	GVAR.OptionsFrame.SortDetailPullDown = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.PullDownMenu(
		GVAR.OptionsFrame.SortDetailPullDown,
		"SortDetail",
		sortBy[ OPT.ButtonSortDetail[currentSize] ],
		0,
		#sortDetail,
		SortDetailPullDownFunc
	)
	GVAR.OptionsFrame.SortDetailPullDown:SetPoint("LEFT", GVAR.OptionsFrame.SortByPullDown, "RIGHT", 10, 0)
	GVAR.OptionsFrame.SortDetailPullDown:SetHeight(18)
	TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.SortDetailPullDown)
	sortW = sortW + 10 + GVAR.OptionsFrame.SortDetailPullDown:GetWidth()

	-- sort info
		----- text
		local infoTxt1 = sortDetail[1]..":\n"
		table_sort(class_IntegerSort, function(a, b) if a.loc < b.loc then return true end end)
		for i = 1, #class_IntegerSort do
if tocversion < 50000 and class_IntegerSort[i].cid ~= "MONK" then -- TODO_MoP
			infoTxt1 = infoTxt1.." |cff"..ClassHexColor(class_IntegerSort[i].cid)..class_IntegerSort[i].loc.."|r"
			if i <= #class_IntegerSort then
				infoTxt1 = infoTxt1.."\n"
			end
end -- TODO_MoP
		end
		local infoTxt2 = sortDetail[2]..":\n"
		table_sort(class_IntegerSort, function(a, b) if a.eng < b.eng then return true end end)
		for i = 1, #class_IntegerSort do
if tocversion < 50000 and class_IntegerSort[i].cid ~= "MONK" then -- TODO_MoP
			infoTxt2 = infoTxt2.." |cff"..ClassHexColor(class_IntegerSort[i].cid)..class_IntegerSort[i].eng.." ("..class_IntegerSort[i].loc..")|r"
			if i <= #class_IntegerSort then
				infoTxt2 = infoTxt2.."\n"
			end
end -- TODO_MoP
		end
		local infoTxt3 = sortDetail[3]..":\n"
		table_sort(class_IntegerSort, function(a, b) if a.blizz < b.blizz then return true end end)
		for i = 1, #class_IntegerSort do
if tocversion < 50000 and class_IntegerSort[i].cid ~= "MONK" then -- TODO_MoP
			infoTxt3 = infoTxt3.." |cff"..ClassHexColor(class_IntegerSort[i].cid)..class_IntegerSort[i].loc.."|r"
			if i <= #class_IntegerSort then
				infoTxt3 = infoTxt3.."\n"
			end
end -- TODO_MoP
		end
		----- text
	GVAR.OptionsFrame.SortInfo = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.SortInfo:SetWidth(16)
	GVAR.OptionsFrame.SortInfo:SetHeight(16)
	GVAR.OptionsFrame.SortInfo:SetPoint("LEFT", GVAR.OptionsFrame.SortDetailPullDown, "RIGHT", 10, 0)
	GVAR.OptionsFrame.SortInfo.Texture = GVAR.OptionsFrame.SortInfo:CreateTexture(nil, "ARTWORK")
	GVAR.OptionsFrame.SortInfo.Texture:SetWidth(16)
	GVAR.OptionsFrame.SortInfo.Texture:SetHeight(16)
	GVAR.OptionsFrame.SortInfo.Texture:SetPoint("LEFT", 0, 0)
	GVAR.OptionsFrame.SortInfo.Texture:SetTexture("Interface\\FriendsFrame\\InformationIcon")
	GVAR.OptionsFrame.SortInfo.TextFrame = CreateFrame("Frame", nil, GVAR.OptionsFrame.SortInfo)
	TEMPLATE.BorderTRBL(GVAR.OptionsFrame.SortInfo.TextFrame)
	GVAR.OptionsFrame.SortInfo.TextFrame:SetToplevel(true)
	GVAR.OptionsFrame.SortInfo.TextFrame:SetPoint("BOTTOM", GVAR.OptionsFrame.SortInfo.Texture, "TOP", 0, 0)
	GVAR.OptionsFrame.SortInfo.TextFrame:Hide()
	GVAR.OptionsFrame.SortInfo.Text1 = GVAR.OptionsFrame.SortInfo.TextFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.SortInfo.Text1:SetPoint("TOPLEFT", GVAR.OptionsFrame.SortInfo.TextFrame, "TOPLEFT", 10, -10)
	GVAR.OptionsFrame.SortInfo.Text1:SetJustifyH("LEFT")
	GVAR.OptionsFrame.SortInfo.Text1:SetText(infoTxt1)
	GVAR.OptionsFrame.SortInfo.Text1:SetTextColor(1, 1, 0.49, 1)
	GVAR.OptionsFrame.SortInfo.Text2 = GVAR.OptionsFrame.SortInfo.TextFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.SortInfo.Text2:SetPoint("LEFT", GVAR.OptionsFrame.SortInfo.Text1, "RIGHT", 0, 0)
	GVAR.OptionsFrame.SortInfo.Text2:SetJustifyH("LEFT")
	GVAR.OptionsFrame.SortInfo.Text2:SetText(infoTxt2)
	GVAR.OptionsFrame.SortInfo.Text2:SetTextColor(1, 1, 0.49, 1)
	GVAR.OptionsFrame.SortInfo.Text3 = GVAR.OptionsFrame.SortInfo.TextFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.SortInfo.Text3:SetPoint("LEFT", GVAR.OptionsFrame.SortInfo.Text2, "RIGHT", 0, 0)
	GVAR.OptionsFrame.SortInfo.Text3:SetJustifyH("LEFT")
	GVAR.OptionsFrame.SortInfo.Text3:SetText(infoTxt3)
	GVAR.OptionsFrame.SortInfo.Text3:SetTextColor(1, 1, 0.49, 1)
	GVAR.OptionsFrame.SortInfo:SetScript("OnEnter", function() GVAR.OptionsFrame.SortInfo.TextFrame:Show() end)
	GVAR.OptionsFrame.SortInfo:SetScript("OnLeave", function() GVAR.OptionsFrame.SortInfo.TextFrame:Hide() end)
		-----
		local txtWidth1 = GVAR.OptionsFrame.SortInfo.Text1:GetStringWidth()
		local txtWidth2 = GVAR.OptionsFrame.SortInfo.Text2:GetStringWidth()
		local txtWidth3 = GVAR.OptionsFrame.SortInfo.Text3:GetStringWidth()
		GVAR.OptionsFrame.SortInfo.Text1:SetWidth(txtWidth1+10)
		GVAR.OptionsFrame.SortInfo.Text2:SetWidth(txtWidth2+10)
		GVAR.OptionsFrame.SortInfo.Text3:SetWidth(txtWidth3+10)
		GVAR.OptionsFrame.SortInfo.TextFrame:SetWidth(10+ txtWidth1+10 + txtWidth2+10 + txtWidth3+10 +10)
		local txtHeight = GVAR.OptionsFrame.SortInfo.Text1:GetStringHeight()
		GVAR.OptionsFrame.SortInfo.Text1:SetHeight(txtHeight+10)
		GVAR.OptionsFrame.SortInfo.Text2:SetHeight(txtHeight+10)
		GVAR.OptionsFrame.SortInfo.Text3:SetHeight(txtHeight+10)
		GVAR.OptionsFrame.SortInfo.TextFrame:SetHeight(10+ txtHeight+10 +10)
		-----
	sortW = sortW + 10 + 16 +10



	-- ----- sliders ----------------------------------------
	local equalTextWidthSliders = 0
	-- fontsize
	GVAR.OptionsFrame.FontTitle = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.FontSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.FontValue = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.FontTitle:SetHeight(16)
	GVAR.OptionsFrame.FontTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.FontTitle:SetPoint("TOP", GVAR.OptionsFrame.SortByTitle, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.FontTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.FontTitle:SetText(L["Text Size"]..":")
	GVAR.OptionsFrame.FontTitle:SetTextColor(1, 1, 1, 1)
	TEMPLATE.Slider(GVAR.OptionsFrame.FontSlider, 150, 1, 5, 20, OPT.ButtonFontSize[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options.ButtonFontSize[currentSize] then return end
		BattlegroundTargets_Options.ButtonFontSize[currentSize] = value
		                        OPT.ButtonFontSize[currentSize] = value
		GVAR.OptionsFrame.FontValue:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.FontSlider:SetPoint("LEFT", GVAR.OptionsFrame.FontTitle, "RIGHT", 20, 0)
	GVAR.OptionsFrame.FontValue:SetHeight(20)
	GVAR.OptionsFrame.FontValue:SetPoint("LEFT", GVAR.OptionsFrame.FontSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.FontValue:SetJustifyH("LEFT")
	GVAR.OptionsFrame.FontValue:SetText(OPT.ButtonFontSize[currentSize])
	GVAR.OptionsFrame.FontValue:SetTextColor(1, 1, 0.49, 1)
	local sw = GVAR.OptionsFrame.FontTitle:GetStringWidth()
	if sw > equalTextWidthSliders then
		equalTextWidthSliders = sw
	end

	-- scale
	GVAR.OptionsFrame.ScaleTitle = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.ScaleSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.ScaleValue = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.ScaleTitle:SetHeight(16)
	GVAR.OptionsFrame.ScaleTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ScaleTitle:SetPoint("TOP", GVAR.OptionsFrame.FontSlider, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.ScaleTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.ScaleTitle:SetText(L["Scale"]..":")
	GVAR.OptionsFrame.ScaleTitle:SetTextColor(1, 1, 1, 1)
	TEMPLATE.Slider(GVAR.OptionsFrame.ScaleSlider, 180, 5, 50, 200, OPT.ButtonScale[currentSize]*100,
	function(self, value)
		local nvalue = value/100
		if nvalue == BattlegroundTargets_Options.ButtonScale[currentSize] then return end
		BattlegroundTargets_Options.ButtonScale[currentSize] = nvalue
		                        OPT.ButtonScale[currentSize] = nvalue
		GVAR.OptionsFrame.ScaleValue:SetText(value.."%")
		if inCombat or InCombatLockdown() then return end
		for i = 1, currentSize do
			GVAR.TargetButton[i]:SetScale(nvalue)
		end
	end,
	"blank")
	GVAR.OptionsFrame.ScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ScaleTitle, "RIGHT", 20, 0)
	GVAR.OptionsFrame.ScaleValue:SetHeight(20)
	GVAR.OptionsFrame.ScaleValue:SetPoint("LEFT", GVAR.OptionsFrame.ScaleSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.ScaleValue:SetJustifyH("LEFT")
	GVAR.OptionsFrame.ScaleValue:SetText((OPT.ButtonScale[currentSize]*100).."%")
	GVAR.OptionsFrame.ScaleValue:SetTextColor(1, 1, 0.49, 1)
	local sw = GVAR.OptionsFrame.ScaleTitle:GetStringWidth()
	if sw > equalTextWidthSliders then
		equalTextWidthSliders = sw
	end

	-- width
	GVAR.OptionsFrame.WidthTitle = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.WidthSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.WidthValue = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.WidthTitle:SetHeight(16)
	GVAR.OptionsFrame.WidthTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.WidthTitle:SetPoint("TOP", GVAR.OptionsFrame.ScaleSlider, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.WidthTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.WidthTitle:SetText(L["Width"]..":")
	GVAR.OptionsFrame.WidthTitle:SetTextColor(1, 1, 1, 1)
	TEMPLATE.Slider(GVAR.OptionsFrame.WidthSlider, 180, 5, 50, 300, OPT.ButtonWidth[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options.ButtonWidth[currentSize] then return end
		BattlegroundTargets_Options.ButtonWidth[currentSize] = value
		                        OPT.ButtonWidth[currentSize] = value
		GVAR.OptionsFrame.WidthValue:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.WidthSlider:SetPoint("LEFT", GVAR.OptionsFrame.WidthTitle, "RIGHT", 20, 0)
	GVAR.OptionsFrame.WidthValue:SetHeight(20)
	GVAR.OptionsFrame.WidthValue:SetPoint("LEFT", GVAR.OptionsFrame.WidthSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.WidthValue:SetJustifyH("LEFT")
	GVAR.OptionsFrame.WidthValue:SetText(OPT.ButtonWidth[currentSize])
	GVAR.OptionsFrame.WidthValue:SetTextColor(1, 1, 0.49, 1)
	local sw = GVAR.OptionsFrame.WidthTitle:GetStringWidth()
	if sw > equalTextWidthSliders then
		equalTextWidthSliders = sw
	end

	-- height
	GVAR.OptionsFrame.HeightTitle = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.HeightSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.HeightValue = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.HeightTitle:SetHeight(16)
	GVAR.OptionsFrame.HeightTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.HeightTitle:SetPoint("TOP", GVAR.OptionsFrame.WidthTitle, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.HeightTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.HeightTitle:SetText(L["Height"]..":")
	GVAR.OptionsFrame.HeightTitle:SetTextColor(1, 1, 1, 1)
	TEMPLATE.Slider(GVAR.OptionsFrame.HeightSlider, 180, 1, 10, 30, OPT.ButtonHeight[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options.ButtonHeight[currentSize] then return end
		BattlegroundTargets_Options.ButtonHeight[currentSize] = value
		                        OPT.ButtonHeight[currentSize] = value
		GVAR.OptionsFrame.HeightValue:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.HeightSlider:SetPoint("LEFT", GVAR.OptionsFrame.HeightTitle, "RIGHT", 20, 0)
	GVAR.OptionsFrame.HeightValue:SetHeight(20)
	GVAR.OptionsFrame.HeightValue:SetPoint("LEFT", GVAR.OptionsFrame.HeightSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.HeightValue:SetJustifyH("LEFT")
	GVAR.OptionsFrame.HeightValue:SetText(OPT.ButtonHeight[currentSize])
	GVAR.OptionsFrame.HeightValue:SetTextColor(1, 1, 0.49, 1)
	local sw = GVAR.OptionsFrame.HeightTitle:GetStringWidth()
	if sw > equalTextWidthSliders then
		equalTextWidthSliders = sw
	end

	GVAR.OptionsFrame.FontSlider:SetPoint("LEFT", GVAR.OptionsFrame.FontTitle, "LEFT", equalTextWidthSliders+10, 0)
	GVAR.OptionsFrame.ScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ScaleTitle, "LEFT", equalTextWidthSliders+10, 0)
	GVAR.OptionsFrame.WidthSlider:SetPoint("LEFT", GVAR.OptionsFrame.WidthTitle, "LEFT", equalTextWidthSliders+10, 0)
	GVAR.OptionsFrame.HeightSlider:SetPoint("LEFT", GVAR.OptionsFrame.HeightTitle, "LEFT", equalTextWidthSliders+10, 0)
		-- ----- sliders ----------------------------------------

	-- testshuffler
	GVAR.OptionsFrame.TestShuffler = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	BattlegroundTargets.shuffleStyle = true
	GVAR.OptionsFrame.TestShuffler:SetPoint("BOTTOM", GVAR.OptionsFrame.HeightSlider, "BOTTOM", 0, 0)
	GVAR.OptionsFrame.TestShuffler:SetPoint("RIGHT", GVAR.OptionsFrame, "RIGHT", -10, 0)
	GVAR.OptionsFrame.TestShuffler:SetWidth(32)
	GVAR.OptionsFrame.TestShuffler:SetHeight(32)
	GVAR.OptionsFrame.TestShuffler:Hide()
	GVAR.OptionsFrame.TestShuffler:SetScript("OnClick", function() BattlegroundTargets:ShufflerFunc("OnClick") end)
	GVAR.OptionsFrame.TestShuffler:SetScript("OnEnter", function() BattlegroundTargets:ShufflerFunc("OnEnter") end)
	GVAR.OptionsFrame.TestShuffler:SetScript("OnLeave", function() BattlegroundTargets:ShufflerFunc("OnLeave") end)
	GVAR.OptionsFrame.TestShuffler:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then BattlegroundTargets:ShufflerFunc("OnMouseDown") end
	end)
	GVAR.OptionsFrame.TestShuffler.Texture = GVAR.OptionsFrame.TestShuffler:CreateTexture(nil, "ARTWORK")
	GVAR.OptionsFrame.TestShuffler.Texture:SetWidth(32)
	GVAR.OptionsFrame.TestShuffler.Texture:SetHeight(32)
	GVAR.OptionsFrame.TestShuffler.Texture:SetPoint("CENTER", 0, 0)
	GVAR.OptionsFrame.TestShuffler.Texture:SetTexture("Interface\\Icons\\INV_Sigil_Thorim")
	GVAR.OptionsFrame.TestShuffler:SetNormalTexture(GVAR.OptionsFrame.TestShuffler.Texture)
	GVAR.OptionsFrame.TestShuffler.TextureHighlight = GVAR.OptionsFrame.TestShuffler:CreateTexture(nil, "OVERLAY")
	GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetWidth(32)
	GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetHeight(32)
	GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetPoint("CENTER", 0, 0)
	GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
	GVAR.OptionsFrame.TestShuffler:SetHighlightTexture(GVAR.OptionsFrame.TestShuffler.TextureHighlight)
	-- ###
	-- ####################################################################################################



	-- ####################################################################################################
	-- xMx ConfigGeneral
	GVAR.OptionsFrame.ConfigGeneral = CreateFrame("Frame", nil, GVAR.OptionsFrame)
	-- BOOM GVAR.OptionsFrame.ConfigGeneral:SetWidth()
	GVAR.OptionsFrame.ConfigGeneral:SetHeight(heightBracket)
	GVAR.OptionsFrame.ConfigGeneral:SetPoint("TOPLEFT", GVAR.OptionsFrame.Base, "BOTTOMLEFT", 0, 1)
	GVAR.OptionsFrame.ConfigGeneral:Hide()

	GVAR.OptionsFrame.GeneralTitle = GVAR.OptionsFrame.ConfigGeneral:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	GVAR.OptionsFrame.GeneralTitle:SetHeight(20)
	GVAR.OptionsFrame.GeneralTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.GeneralTitle:SetPoint("TOPLEFT", GVAR.OptionsFrame.ConfigGeneral, "TOPLEFT", 10, -10)
	GVAR.OptionsFrame.GeneralTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.GeneralTitle:SetText(L["General Settings"]..":")

	-- minimap button
	GVAR.OptionsFrame.Minimap = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigGeneral)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.Minimap, 16, 4, L["Show Minimap-Button"])
	GVAR.OptionsFrame.Minimap:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.Minimap:SetPoint("TOP", GVAR.OptionsFrame.GeneralTitle, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.Minimap:SetChecked(BattlegroundTargets_Options.MinimapButton)
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.Minimap)
	GVAR.OptionsFrame.Minimap:SetScript("OnClick", function()
		BattlegroundTargets_Options.MinimapButton = not BattlegroundTargets_Options.MinimapButton
		BattlegroundTargets:CreateMinimapButton()
	end)

	GVAR.OptionsFrame.TargetIconText = GVAR.OptionsFrame.ConfigGeneral:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.TargetIconText:SetHeight(20)
	GVAR.OptionsFrame.TargetIconText:SetPoint("LEFT", GVAR.OptionsFrame.ConfigGeneral, "LEFT", 10, 0)
	GVAR.OptionsFrame.TargetIconText:SetPoint("TOP", GVAR.OptionsFrame.Minimap, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.TargetIconText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.TargetIconText:SetText(TARGET..":")
	GVAR.OptionsFrame.TargetIconText:SetTextColor(1, 1, 1, 1)
	GVAR.OptionsFrame.TargetIcon1 = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigGeneral)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.TargetIcon1, 16, 4, nil, "default")
	GVAR.OptionsFrame.TargetIcon1:SetPoint("LEFT", GVAR.OptionsFrame.TargetIconText, "RIGHT", 5, 0)
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.TargetIcon1)
	GVAR.OptionsFrame.TargetIcon1:SetScript("OnClick", function()
		BattlegroundTargets_Options.TargetIcon = "default"
		GVAR.OptionsFrame.TargetIcon2:SetChecked(false)
		if BattlegroundTargets_Options.EnableBracket[currentSize] then
			BattlegroundTargets:EnableConfigMode()
		end
	end)
	GVAR.OptionsFrame.TargetIcon2 = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigGeneral)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.TargetIcon2, 16, 4, nil, "bgt")
	GVAR.OptionsFrame.TargetIcon2:SetPoint("LEFT", GVAR.OptionsFrame.TargetIcon1, "RIGHT", 5, 0)
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.TargetIcon2)
	GVAR.OptionsFrame.TargetIcon2:SetScript("OnClick", function()
		BattlegroundTargets_Options.TargetIcon = "bgt"
		GVAR.OptionsFrame.TargetIcon1:SetChecked(false)
		if BattlegroundTargets_Options.EnableBracket[currentSize] then
			BattlegroundTargets:EnableConfigMode()
		end
	end)
	if BattlegroundTargets_Options.TargetIcon == "default" then
		GVAR.OptionsFrame.TargetIcon1:SetChecked(true)
		GVAR.OptionsFrame.TargetIcon2:SetChecked(false)
	else
		GVAR.OptionsFrame.TargetIcon1:SetChecked(false)
		GVAR.OptionsFrame.TargetIcon2:SetChecked(true)
	end
	-- ###
	-- ####################################################################################################



	-- ####################################################################################################
	-- xMx Mover
	GVAR.OptionsFrame.MoverTop = CreateFrame("Frame", nil, GVAR.OptionsFrame)
	TEMPLATE.BorderTRBL(GVAR.OptionsFrame.MoverTop)
	-- BOOM GVAR.OptionsFrame.MoverTop:SetWidth()
	GVAR.OptionsFrame.MoverTop:SetHeight(20)
	GVAR.OptionsFrame.MoverTop:SetPoint("BOTTOM", GVAR.OptionsFrame, "TOP", 0, -1)
	GVAR.OptionsFrame.MoverTop:EnableMouse(true)
	GVAR.OptionsFrame.MoverTop:EnableMouseWheel(true)
	GVAR.OptionsFrame.MoverTop:SetScript("OnMouseWheel", NOOP)
	GVAR.OptionsFrame.MoverTopText = GVAR.OptionsFrame.MoverTop:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.MoverTopText:SetPoint("CENTER", GVAR.OptionsFrame.MoverTop, "CENTER", 0, 0)
	GVAR.OptionsFrame.MoverTopText:SetJustifyH("CENTER")
	GVAR.OptionsFrame.MoverTopText:SetTextColor(0.3, 0.3, 0.3, 1)
	GVAR.OptionsFrame.MoverTopText:SetText(L["click & move"])

	GVAR.OptionsFrame.Close = CreateFrame("Button", nil, GVAR.OptionsFrame.MoverTop)
	TEMPLATE.IconButton(GVAR.OptionsFrame.Close, 1)
	GVAR.OptionsFrame.Close:SetWidth(20)
	GVAR.OptionsFrame.Close:SetHeight(20)
	GVAR.OptionsFrame.Close:SetPoint("RIGHT", GVAR.OptionsFrame.MoverTop, "RIGHT", 0, 0)
	GVAR.OptionsFrame.Close:SetScript("OnClick", function() GVAR.OptionsFrame:Hide() end)

	GVAR.OptionsFrame.MoverBottom = CreateFrame("Frame", nil, GVAR.OptionsFrame)
	TEMPLATE.BorderTRBL(GVAR.OptionsFrame.MoverBottom)
	-- BOOM GVAR.OptionsFrame.MoverBottom:SetWidth()
	GVAR.OptionsFrame.MoverBottom:SetHeight(20)
	GVAR.OptionsFrame.MoverBottom:SetPoint("TOP", GVAR.OptionsFrame, "BOTTOM", 0, 1)
	GVAR.OptionsFrame.MoverBottom:EnableMouse(true)
	GVAR.OptionsFrame.MoverBottom:EnableMouseWheel(true)
	GVAR.OptionsFrame.MoverBottom:SetScript("OnMouseWheel", NOOP)
	GVAR.OptionsFrame.MoverBottomText = GVAR.OptionsFrame.MoverBottom:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.MoverBottomText:SetPoint("CENTER", GVAR.OptionsFrame.MoverBottom, "CENTER", 0, 0)
	GVAR.OptionsFrame.MoverBottomText:SetJustifyH("CENTER")
	GVAR.OptionsFrame.MoverBottomText:SetTextColor(0.3, 0.3, 0.3, 1)
	GVAR.OptionsFrame.MoverBottomText:SetText(L["click & move"])

	GVAR.OptionsFrame.MoverTop:SetScript("OnEnter", function() GVAR.OptionsFrame.MoverTopText:SetTextColor(1, 1, 1, 1) end)
	GVAR.OptionsFrame.MoverTop:SetScript("OnLeave", function() GVAR.OptionsFrame.MoverTopText:SetTextColor(0.3, 0.3, 0.3, 1) end)
	GVAR.OptionsFrame.MoverTop:SetScript("OnMouseDown", function() GVAR.OptionsFrame:StartMoving() end)
	GVAR.OptionsFrame.MoverTop:SetScript("OnMouseUp", function() GVAR.OptionsFrame:StopMovingOrSizing() BattlegroundTargets:Frame_SavePosition("BattlegroundTargets_OptionsFrame") end)

	GVAR.OptionsFrame.MoverBottom:SetScript("OnEnter", function() GVAR.OptionsFrame.MoverBottomText:SetTextColor(1, 1, 1, 1) end)
	GVAR.OptionsFrame.MoverBottom:SetScript("OnLeave", function() GVAR.OptionsFrame.MoverBottomText:SetTextColor(0.3, 0.3, 0.3, 1) end)
	GVAR.OptionsFrame.MoverBottom:SetScript("OnMouseDown", function() GVAR.OptionsFrame:StartMoving() end)
	GVAR.OptionsFrame.MoverBottom:SetScript("OnMouseUp", function() GVAR.OptionsFrame:StopMovingOrSizing() BattlegroundTargets:Frame_SavePosition("BattlegroundTargets_OptionsFrame") end)
	-- ###
	-- ####################################################################################################



	-- ####################################################################################################
	-- xMx width BOOM
	local frameWidth = 400
	if generalIconW > frameWidth then frameWidth = generalIconW end
	if layoutW > frameWidth then frameWidth = layoutW end
	if summaryW > frameWidth then frameWidth = summaryW end
	if iconW > frameWidth then frameWidth = iconW end
	if rangeW > frameWidth then frameWidth = rangeW end
	if sortW > frameWidth then frameWidth = sortW end
	if frameWidth < 400 then frameWidth = 400 end
	if frameWidth > 650 then frameWidth = 650 end
	-- OptionsFrame
	GVAR.OptionsFrame:SetClampRectInsets((frameWidth-50)/2, -((frameWidth-50)/2), -(heightTotal-35), heightTotal-35)
	GVAR.OptionsFrame:SetWidth(frameWidth)
	GVAR.OptionsFrame.CloseConfig:SetWidth(frameWidth-20)
	-- Base
	GVAR.OptionsFrame.Base:SetWidth(frameWidth)
	GVAR.OptionsFrame.Title:SetWidth(frameWidth)
	local spacer = 10
	local tabWidth1 = 36
	local tabWidth2 = math_floor( (frameWidth-tabWidth1-tabWidth1-(6*spacer)) / 3 )
	GVAR.OptionsFrame.TabGeneral:SetWidth(tabWidth1)
	GVAR.OptionsFrame.TabRaidSize10:SetWidth(tabWidth2)
	GVAR.OptionsFrame.TabRaidSize15:SetWidth(tabWidth2)
	GVAR.OptionsFrame.TabRaidSize40:SetWidth(tabWidth2)
	GVAR.OptionsFrame.TabGeneral:SetPoint("BOTTOMLEFT", GVAR.OptionsFrame.Base, "BOTTOMLEFT", spacer, -1)
	GVAR.OptionsFrame.TabRaidSize10:SetPoint("BOTTOMLEFT", GVAR.OptionsFrame.Base, "BOTTOMLEFT", spacer+tabWidth1+spacer, -1)
	GVAR.OptionsFrame.TabRaidSize15:SetPoint("BOTTOMLEFT", GVAR.OptionsFrame.Base, "BOTTOMLEFT", spacer+tabWidth1+spacer+((tabWidth2+spacer)*1), -1)
	GVAR.OptionsFrame.TabRaidSize40:SetPoint("BOTTOMLEFT", GVAR.OptionsFrame.Base, "BOTTOMLEFT", spacer+tabWidth1+spacer+((tabWidth2+spacer)*2), -1)
	GVAR.OptionsFrame.Dummy1:SetWidth(frameWidth-26-26)
	-- ConfigBrackets
	GVAR.OptionsFrame.ConfigBrackets:SetWidth(frameWidth)
	GVAR.OptionsFrame.ShowLeader:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", (frameWidth-10-10)/2, 0)
	-- ConfigGeneral
	GVAR.OptionsFrame.ConfigGeneral:SetWidth(frameWidth)
	-- Mover
	GVAR.OptionsFrame.MoverTop:SetWidth(frameWidth)
	GVAR.OptionsFrame.MoverBottom:SetWidth(frameWidth)
	-- ###
	-- ####################################################################################################
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:SetOptions()
	GVAR.OptionsFrame.EnableBracket:SetChecked(BattlegroundTargets_Options.EnableBracket[currentSize])
	GVAR.OptionsFrame.IndependentPos:SetChecked(BattlegroundTargets_Options.IndependentPositioning[currentSize])

	if currentSize == 10 then
		GVAR.OptionsFrame.CopySettings:SetText(string_format(L["Copy this settings to '%s'"], L["15 vs 15"]))
	elseif currentSize == 15 then
		GVAR.OptionsFrame.CopySettings:SetText(string_format(L["Copy this settings to '%s'"], L["10 vs 10"]))
	end

	local LayoutTH = BattlegroundTargets_Options.LayoutTH[currentSize]
	if LayoutTH == 18 then
		GVAR.OptionsFrame.LayoutTHx18:SetChecked(true)
		GVAR.OptionsFrame.LayoutTHx24:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx42:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx81:SetChecked(false)
	elseif LayoutTH == 24 then
		GVAR.OptionsFrame.LayoutTHx18:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx24:SetChecked(true)
		GVAR.OptionsFrame.LayoutTHx42:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx81:SetChecked(false)
	elseif LayoutTH == 42 then
		GVAR.OptionsFrame.LayoutTHx18:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx24:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx42:SetChecked(true)
		GVAR.OptionsFrame.LayoutTHx81:SetChecked(false)
	elseif LayoutTH == 81 then
		GVAR.OptionsFrame.LayoutTHx18:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx24:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx42:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx81:SetChecked(true)
	end
	GVAR.OptionsFrame.LayoutSpace:SetValue(BattlegroundTargets_Options.LayoutSpace[currentSize])
	GVAR.OptionsFrame.LayoutSpaceText:SetText(BattlegroundTargets_Options.LayoutSpace[currentSize])

	GVAR.OptionsFrame.Summary:SetChecked(BattlegroundTargets_Options.Summary[currentSize])
	GVAR.OptionsFrame.SummaryScaleRole:SetValue(BattlegroundTargets_Options.SummaryScaleRole[currentSize]*100)
	GVAR.OptionsFrame.SummaryScaleRoleText:SetText((BattlegroundTargets_Options.SummaryScaleRole[currentSize]*100).."%")
	GVAR.OptionsFrame.SummaryScaleGuildGroup:SetValue(BattlegroundTargets_Options.SummaryScaleGuildGroup[currentSize]*100)
	GVAR.OptionsFrame.SummaryScaleGuildGroupText:SetText((BattlegroundTargets_Options.SummaryScaleGuildGroup[currentSize]*100).."%")

	GVAR.OptionsFrame.ShowRole:SetChecked(OPT.ButtonShowRole[currentSize])
	GVAR.OptionsFrame.ShowSpec:SetChecked(OPT.ButtonShowSpec[currentSize])
	GVAR.OptionsFrame.ClassIcon:SetChecked(OPT.ButtonClassIcon[currentSize])
	GVAR.OptionsFrame.ShowLeader:SetChecked(OPT.ButtonShowLeader[currentSize])
	GVAR.OptionsFrame.ShowRealm:SetChecked(OPT.ButtonHideRealm[currentSize])
	GVAR.OptionsFrame.ShowGuildGroup:SetChecked(OPT.ButtonShowGuildGroup[currentSize])
	GVAR.OptionsFrame.GuildGroupPosition:SetValue(OPT.ButtonGuildGroupPosition[currentSize])
	GVAR.OptionsFrame.GuildGroupPositionText:SetText(OPT.ButtonGuildGroupPosition[currentSize])

	GVAR.OptionsFrame.ShowTargetIndicator:SetChecked(OPT.ButtonShowTarget[currentSize])
	GVAR.OptionsFrame.TargetScaleSlider:SetValue(OPT.ButtonTargetScale[currentSize]*100)
	GVAR.OptionsFrame.TargetScaleSliderText:SetText((OPT.ButtonTargetScale[currentSize]*100).."%")
	GVAR.OptionsFrame.TargetPositionSlider:SetValue(OPT.ButtonTargetPosition[currentSize])
	GVAR.OptionsFrame.TargetPositionSliderText:SetText(OPT.ButtonTargetPosition[currentSize])

	GVAR.OptionsFrame.ShowFocusIndicator:SetChecked(OPT.ButtonShowFocus[currentSize])
	GVAR.OptionsFrame.FocusScaleSlider:SetValue(OPT.ButtonFocusScale[currentSize]*100)
	GVAR.OptionsFrame.FocusScaleSliderText:SetText((OPT.ButtonFocusScale[currentSize]*100).."%")
	GVAR.OptionsFrame.FocusPositionSlider:SetValue(OPT.ButtonFocusPosition[currentSize])
	GVAR.OptionsFrame.FocusPositionSliderText:SetText(OPT.ButtonFocusPosition[currentSize])

	GVAR.OptionsFrame.ShowFlag:SetChecked(OPT.ButtonShowFlag[currentSize])
	GVAR.OptionsFrame.FlagScaleSlider:SetValue(OPT.ButtonFlagScale[currentSize]*100)
	GVAR.OptionsFrame.FlagScaleSliderText:SetText((OPT.ButtonFlagScale[currentSize]*100).."%")
	GVAR.OptionsFrame.FlagPositionSlider:SetValue(OPT.ButtonFlagPosition[currentSize])
	GVAR.OptionsFrame.FlagPositionSliderText:SetText(OPT.ButtonFlagPosition[currentSize])

	GVAR.OptionsFrame.ShowAssist:SetChecked(OPT.ButtonShowAssist[currentSize])
	GVAR.OptionsFrame.AssistScaleSlider:SetValue(OPT.ButtonAssistScale[currentSize]*100)
	GVAR.OptionsFrame.AssistScaleSliderText:SetText((OPT.ButtonAssistScale[currentSize]*100).."%")
	GVAR.OptionsFrame.AssistPositionSlider:SetValue(OPT.ButtonAssistPosition[currentSize])
	GVAR.OptionsFrame.AssistPositionSliderText:SetText(OPT.ButtonAssistPosition[currentSize])

	GVAR.OptionsFrame.ShowTargetCount:SetChecked(OPT.ButtonShowTargetCount[currentSize])

	GVAR.OptionsFrame.ShowHealthBar:SetChecked(OPT.ButtonShowHealthBar[currentSize])
	GVAR.OptionsFrame.ShowHealthText:SetChecked(OPT.ButtonShowHealthText[currentSize])

	GVAR.OptionsFrame.RangeCheck:SetChecked(OPT.ButtonRangeCheck[currentSize])
	GVAR.OptionsFrame.RangeCheckTypePullDown.PullDownButtonText:SetText(rangeTypeName[ OPT.ButtonTypeRangeCheck[currentSize] ])
	GVAR.OptionsFrame.RangeDisplayPullDown.PullDownButtonText:SetText(rangeDisplay[ OPT.ButtonRangeDisplay[currentSize] ])

	GVAR.OptionsFrame.SortByPullDown.PullDownButtonText:SetText(sortBy[ OPT.ButtonSortBy[currentSize] ])
	GVAR.OptionsFrame.SortDetailPullDown.PullDownButtonText:SetText(sortDetail[ OPT.ButtonSortDetail[currentSize] ])
	local ButtonSortBy = OPT.ButtonSortBy[currentSize]
	if ButtonSortBy == 1 or ButtonSortBy == 3 or ButtonSortBy == 4 then
		GVAR.OptionsFrame.SortDetailPullDown:Show()
		GVAR.OptionsFrame.SortInfo:Show()
	else
		GVAR.OptionsFrame.SortDetailPullDown:Hide()
		GVAR.OptionsFrame.SortInfo:Hide()
	end

	GVAR.OptionsFrame.FontSlider:SetValue(OPT.ButtonFontSize[currentSize])
	GVAR.OptionsFrame.FontValue:SetText(OPT.ButtonFontSize[currentSize])

	GVAR.OptionsFrame.ScaleSlider:SetValue(OPT.ButtonScale[currentSize]*100)
	GVAR.OptionsFrame.ScaleValue:SetText((OPT.ButtonScale[currentSize]*100).."%")

	GVAR.OptionsFrame.WidthSlider:SetValue(OPT.ButtonWidth[currentSize])
	GVAR.OptionsFrame.WidthValue:SetText(OPT.ButtonWidth[currentSize])

	GVAR.OptionsFrame.HeightSlider:SetValue(OPT.ButtonHeight[currentSize])
	GVAR.OptionsFrame.HeightValue:SetText(OPT.ButtonHeight[currentSize])
end

function BattlegroundTargets:CheckForEnabledBracket(bracketSize)
	if BattlegroundTargets_Options.EnableBracket[bracketSize] then
		if bracketSize == 10 then
			GVAR.OptionsFrame.TabRaidSize10.TabText:SetTextColor(0, 0.75, 0, 1)
		elseif bracketSize == 15 then
			GVAR.OptionsFrame.TabRaidSize15.TabText:SetTextColor(0, 0.75, 0, 1)
		elseif bracketSize == 40 then
			GVAR.OptionsFrame.TabRaidSize40.TabText:SetTextColor(0, 0.75, 0, 1)
		end

		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.IndependentPos)

		GVAR.OptionsFrame.LayoutTHText:SetTextColor(1, 1, 1, 1)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.LayoutTHx18)
		if bracketSize == 10 or bracketSize == 15 then
			TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx24)
			TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx42)
		else
			TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.LayoutTHx24)
			TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.LayoutTHx42)
		end
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.LayoutTHx81)
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.LayoutSpace)

		GVAR.OptionsFrame.SummaryText:SetTextColor(1, 1, 1, 1)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.Summary)
		if BattlegroundTargets_Options.Summary[bracketSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.SummaryScaleRole)
			if OPT.ButtonShowGuildGroup[bracketSize] then
				TEMPLATE.EnableSlider(GVAR.OptionsFrame.SummaryScaleGuildGroup)
			else
				TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScaleGuildGroup)
			end
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScaleRole)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScaleGuildGroup)
		end

		if bracketSize == 40 then
 			GVAR.OptionsFrame.CopySettings:Hide()
		else
			GVAR.OptionsFrame.CopySettings:Show()
			TEMPLATE.EnableTextButton(GVAR.OptionsFrame.CopySettings, 4)
		end

		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowRole)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowSpec)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ClassIcon)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowLeader)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowRealm)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowGuildGroup)
		if OPT.ButtonShowGuildGroup[bracketSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.GuildGroupPosition)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.GuildGroupPosition)
		end

		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowTargetIndicator)
		if OPT.ButtonShowTarget[bracketSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.TargetScaleSlider)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.TargetPositionSlider)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.TargetScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.TargetPositionSlider)
		end
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowFocusIndicator)
		if OPT.ButtonShowFocus[bracketSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.FocusScaleSlider)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.FocusPositionSlider)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FocusScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FocusPositionSlider)
		end
		if bracketSize == 40 then
			TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowFlag)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagPositionSlider)
		else
			TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowFlag)
			if OPT.ButtonShowFlag[bracketSize] then
				TEMPLATE.EnableSlider(GVAR.OptionsFrame.FlagScaleSlider)
				TEMPLATE.EnableSlider(GVAR.OptionsFrame.FlagPositionSlider)
			else
				TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagScaleSlider)
				TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagPositionSlider)
			end
		end
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowAssist)
		if OPT.ButtonShowAssist[bracketSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.AssistScaleSlider)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.AssistPositionSlider)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.AssistScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.AssistPositionSlider)
		end

		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowTargetCount)

		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowHealthBar)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowHealthText)

		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.RangeCheck)
		if OPT.ButtonRangeCheck[bracketSize] then
			TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.RangeCheckTypePullDown)
			GVAR.OptionsFrame.RangeCheckInfo:Enable() Desaturation(GVAR.OptionsFrame.RangeCheckInfo.Texture, false)
			TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.RangeDisplayPullDown)
		else
			TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.RangeCheckTypePullDown)
			GVAR.OptionsFrame.RangeCheckInfo:Disable() Desaturation(GVAR.OptionsFrame.RangeCheckInfo.Texture, true)
			TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.RangeDisplayPullDown)
		end

		TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.SortByPullDown)
		GVAR.OptionsFrame.SortByTitle:SetTextColor(1, 1, 1, 1)
		TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.SortDetailPullDown)
		GVAR.OptionsFrame.SortInfo:Enable() Desaturation(GVAR.OptionsFrame.SortInfo.Texture, false)

		TEMPLATE.EnableSlider(GVAR.OptionsFrame.FontSlider)
		GVAR.OptionsFrame.FontTitle:SetTextColor(1, 1, 1, 1)
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.ScaleSlider)
		GVAR.OptionsFrame.ScaleTitle:SetTextColor(1, 1, 1, 1)
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.WidthSlider)
		GVAR.OptionsFrame.WidthTitle:SetTextColor(1, 1, 1, 1)
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.HeightSlider)
		GVAR.OptionsFrame.HeightTitle:SetTextColor(1, 1, 1, 1)
		GVAR.OptionsFrame.TestShuffler:Show()
	else
		if bracketSize == 10 then
			GVAR.OptionsFrame.TabRaidSize10.TabText:SetTextColor(1, 0, 0, 1)
		elseif bracketSize == 15 then
			GVAR.OptionsFrame.TabRaidSize15.TabText:SetTextColor(1, 0, 0, 1)
		elseif bracketSize == 40 then
			GVAR.OptionsFrame.TabRaidSize40.TabText:SetTextColor(1, 0, 0, 1)
		end

		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.IndependentPos)

		GVAR.OptionsFrame.LayoutTHText:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx18)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx24)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx42)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx81)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.LayoutSpace)

		GVAR.OptionsFrame.SummaryText:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.Summary)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScaleRole)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScaleGuildGroup)

		if bracketSize == 40 then
 			GVAR.OptionsFrame.CopySettings:Hide()
		else
			GVAR.OptionsFrame.CopySettings:Show()
			TEMPLATE.DisableTextButton(GVAR.OptionsFrame.CopySettings, 4)
		end

		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowRole)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowSpec)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ClassIcon)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowLeader)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowRealm)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowGuildGroup)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.GuildGroupPosition)

		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowTargetIndicator)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.TargetScaleSlider)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.TargetPositionSlider)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowFocusIndicator)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.FocusScaleSlider)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.FocusPositionSlider)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowFlag)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagScaleSlider)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagPositionSlider)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowAssist)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.AssistScaleSlider)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.AssistPositionSlider)

		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowTargetCount)

		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowHealthBar)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowHealthText)

		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.RangeCheck)
		TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.RangeCheckTypePullDown)
		GVAR.OptionsFrame.RangeCheckInfo:Disable() Desaturation(GVAR.OptionsFrame.RangeCheckInfo.Texture, true)
		TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.RangeDisplayPullDown)

		TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.SortByPullDown)
		GVAR.OptionsFrame.SortByTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.SortDetailPullDown)
		GVAR.OptionsFrame.SortInfo:Disable() Desaturation(GVAR.OptionsFrame.SortInfo.Texture, true)

		TEMPLATE.DisableSlider(GVAR.OptionsFrame.FontSlider)
		GVAR.OptionsFrame.FontTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.ScaleSlider)
		GVAR.OptionsFrame.ScaleTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.WidthSlider)
		GVAR.OptionsFrame.WidthTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.HeightSlider)
		GVAR.OptionsFrame.HeightTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		GVAR.OptionsFrame.TestShuffler:Hide()
	end
end

function BattlegroundTargets:DisableInsecureConfigWidges()
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.Minimap)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.Summary)
	GVAR.OptionsFrame.TargetIconText:SetTextColor(0.5, 0.5, 0.5, 1)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.TargetIcon1)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.TargetIcon2)

	TEMPLATE.DisableTabButton(GVAR.OptionsFrame.TabGeneral)
	TEMPLATE.DisableTabButton(GVAR.OptionsFrame.TabRaidSize10)
	TEMPLATE.DisableTabButton(GVAR.OptionsFrame.TabRaidSize15)
	TEMPLATE.DisableTabButton(GVAR.OptionsFrame.TabRaidSize40)

	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.EnableBracket)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.IndependentPos)

	TEMPLATE.DisableTextButton(GVAR.OptionsFrame.CopySettings)

	GVAR.OptionsFrame.LayoutTHText:SetTextColor(0.5, 0.5, 0.5, 1)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx18)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx24)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx42)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx81)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.LayoutSpace)

	GVAR.OptionsFrame.SummaryText:SetTextColor(0.5, 0.5, 0.5, 1)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.Summary)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScaleRole)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScaleGuildGroup)

	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowRole)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowSpec)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ClassIcon)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowLeader)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowRealm)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowGuildGroup)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.GuildGroupPosition)

	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowTargetIndicator)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.TargetScaleSlider)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.TargetPositionSlider)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowFocusIndicator)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.FocusScaleSlider)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.FocusPositionSlider)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowFlag)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagScaleSlider)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagPositionSlider)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowAssist)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.AssistScaleSlider)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.AssistPositionSlider)

	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowTargetCount)

	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowHealthBar)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowHealthText)

	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.RangeCheck)
	TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.RangeCheckTypePullDown)
	GVAR.OptionsFrame.RangeCheckInfo:Disable() Desaturation(GVAR.OptionsFrame.RangeCheckInfo.Texture, true)
	TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.RangeDisplayPullDown)

	TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.SortByPullDown)
	GVAR.OptionsFrame.SortByTitle:SetTextColor(0.5, 0.5, 0.5, 1)
	TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.SortDetailPullDown)
	GVAR.OptionsFrame.SortInfo:Disable() Desaturation(GVAR.OptionsFrame.SortInfo.Texture, true)

	TEMPLATE.DisableSlider(GVAR.OptionsFrame.FontSlider)
	GVAR.OptionsFrame.FontTitle:SetTextColor(0.5, 0.5, 0.5, 1)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.ScaleSlider)
	GVAR.OptionsFrame.ScaleTitle:SetTextColor(0.5, 0.5, 0.5, 1)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.WidthSlider)
	GVAR.OptionsFrame.WidthTitle:SetTextColor(0.5, 0.5, 0.5, 1)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.HeightSlider)
	GVAR.OptionsFrame.HeightTitle:SetTextColor(0.5, 0.5, 0.5, 1)
	GVAR.OptionsFrame.TestShuffler:Hide()
end

function BattlegroundTargets:EnableInsecureConfigWidges()
	TEMPLATE.EnableTabButton(GVAR.OptionsFrame.TabGeneral, true)
	TEMPLATE.EnableTabButton(GVAR.OptionsFrame.TabRaidSize10, BattlegroundTargets_Options.EnableBracket[10])
	TEMPLATE.EnableTabButton(GVAR.OptionsFrame.TabRaidSize15, BattlegroundTargets_Options.EnableBracket[15])
	TEMPLATE.EnableTabButton(GVAR.OptionsFrame.TabRaidSize40, BattlegroundTargets_Options.EnableBracket[40])

	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.EnableBracket)
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.Minimap)

	GVAR.OptionsFrame.TargetIconText:SetTextColor(1, 1, 1, 1)
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.TargetIcon1)
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.TargetIcon2)

	BattlegroundTargets:CheckForEnabledBracket(testSize)
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CreateMinimapButton()
	if not BattlegroundTargets_Options.MinimapButton then
		if BattlegroundTargets_MinimapButton then
			BattlegroundTargets_MinimapButton:Hide()
		end
		return
	else
		if BattlegroundTargets_MinimapButton then
			BattlegroundTargets_MinimapButton:Show()
			return
		end
	end

	if BattlegroundTargets_MinimapButton then return end

	local function MoveMinimapButton()
		local xpos
		local ypos
		local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"
		if minimapShape == "SQUARE" then
			xpos = 110 * cos(BattlegroundTargets_Options.MinimapButtonPos or 0)
			ypos = 110 * sin(BattlegroundTargets_Options.MinimapButtonPos or 0)
			xpos = math.max(-82, math.min(xpos, 84))
			ypos = math.max(-86, math.min(ypos, 82))
		else
			xpos = 80 * cos(BattlegroundTargets_Options.MinimapButtonPos or 0)
			ypos = 80 * sin(BattlegroundTargets_Options.MinimapButtonPos or 0)
		end
		BattlegroundTargets_MinimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 54-xpos, ypos-54)
	end

	local function DragMinimapButton()
		local xpos, ypos = GetCursorPosition()
		local xmin, ymin = Minimap:GetLeft() or 400, Minimap:GetBottom() or 400
		local scale = Minimap:GetEffectiveScale()
		xpos = xmin-xpos/scale+70
		ypos = ypos/scale-ymin-70
		BattlegroundTargets_Options.MinimapButtonPos = math.deg(math.atan2(ypos, xpos))
		MoveMinimapButton()
	end

	local MinimapButton = CreateFrame("Button", "BattlegroundTargets_MinimapButton", Minimap)
	MinimapButton:EnableMouse(true)
	MinimapButton:SetMovable(true)
	MinimapButton:SetToplevel(true)
	MinimapButton:SetWidth(32)
	MinimapButton:SetHeight(32)
	MinimapButton:SetPoint("TOPLEFT")
	MinimapButton:SetFrameStrata("LOW")
	MinimapButton:RegisterForClicks("AnyUp")
	MinimapButton:RegisterForDrag("LeftButton")

	local texture = MinimapButton:CreateTexture(nil, "ARTWORK")
	texture:SetWidth(54)
	texture:SetHeight(54)
	texture:SetPoint("TOPLEFT")
	texture:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

	local texture = MinimapButton:CreateTexture(nil, "BACKGROUND")
	texture:SetWidth(24)
	texture:SetHeight(24)
	texture:SetPoint("TOPLEFT", 2, -4)
	texture:SetTexture("Interface\\Minimap\\UI-Minimap-Background")

	local NormalTexture = MinimapButton:CreateTexture(nil, "ARTWORK")
	NormalTexture:SetWidth(12)
	NormalTexture:SetHeight(14)
	NormalTexture:SetPoint("TOPLEFT", 10.5, -8.5)
	NormalTexture:SetTexture(AddonIcon)
	NormalTexture:SetTexCoord(2/16, 14/16, 1/16, 15/16)
	MinimapButton:SetNormalTexture(NormalTexture)

	local PushedTexture = MinimapButton:CreateTexture(nil, "ARTWORK")
	PushedTexture:SetWidth(10)
	PushedTexture:SetHeight(12)
	PushedTexture:SetPoint("TOPLEFT", 11.5, -9.5)
	PushedTexture:SetTexture(AddonIcon)
	PushedTexture:SetTexCoord(2/16, 14/16, 1/16, 15/16)
	MinimapButton:SetPushedTexture(PushedTexture)

	local HighlightTexture = MinimapButton:CreateTexture(nil, "ARTWORK")
	HighlightTexture:SetPoint("TOPLEFT", 0, 0)
	HighlightTexture:SetPoint("BOTTOMRIGHT", 0, 0)
	HighlightTexture:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	MinimapButton:SetHighlightTexture(HighlightTexture)

	MinimapButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine("BattlegroundTargets", 1, 0.82, 0, 1)
		GameTooltip:Show()
	end)
	MinimapButton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	MinimapButton:SetScript("OnClick", function(self, button) BattlegroundTargets:Frame_Toggle(GVAR.OptionsFrame) end)
	MinimapButton:SetScript("OnDragStart", function(self) self:LockHighlight() self:SetScript("OnUpdate", DragMinimapButton) end)
	MinimapButton:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) self:UnlockHighlight() end)

	MoveMinimapButton()
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:SetupLayout()
	if inCombat or InCombatLockdown() then
		reCheckBG = true
		reSetLayout = true
		return
	end

	local LayoutTH    = BattlegroundTargets_Options.LayoutTH[currentSize]
	local LayoutSpace = BattlegroundTargets_Options.LayoutSpace[currentSize]

	if currentSize == 10 then
		for i = 1, currentSize do
			if LayoutTH == 81 then
				if i == 6 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[1], "TOPRIGHT", LayoutSpace, 0)
				elseif i > 1 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[(i-1)], "BOTTOMLEFT", 0, 0)
				end
			elseif LayoutTH == 18 then
				if i > 1 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[(i-1)], "BOTTOMLEFT", 0, 0)
				end
			end
		end
	elseif currentSize == 15 then
		for i = 1, currentSize do
			if LayoutTH == 81 then
				if i == 6 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[1], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 11 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[6], "TOPRIGHT", LayoutSpace, 0)
				elseif i > 1 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[(i-1)], "BOTTOMLEFT", 0, 0)
				end
			elseif LayoutTH == 18 then
				if i > 1 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[(i-1)], "BOTTOMLEFT", 0, 0)
				end
			end
		end
	elseif currentSize == 40 then
		for i = 1, currentSize do
			if LayoutTH == 81 then
				if i == 6 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[1], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 11 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[6], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 16 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[11], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 21 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[16], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 26 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[21], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 31 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[26], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 36 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[31], "TOPRIGHT", LayoutSpace, 0)
				elseif i > 1 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[(i-1)], "BOTTOMLEFT", 0, 0)
				end
			elseif LayoutTH == 42 then
				if i == 11 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[1], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 21 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[11], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 31 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[21], "TOPRIGHT", LayoutSpace, 0)
				elseif i > 1 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[(i-1)], "BOTTOMLEFT", 0, 0)
				end
			elseif LayoutTH == 24 then
				if i == 21 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[1], "TOPRIGHT", LayoutSpace, 0)
				elseif i > 1 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[(i-1)], "BOTTOMLEFT", 0, 0)
				end
			elseif LayoutTH == 18 then
				if i > 1 then
					GVAR.TargetButton[i]:SetPoint("TOPLEFT", GVAR.TargetButton[(i-1)], "BOTTOMLEFT", 0, 0)
				end
			end
		end
	end
	BattlegroundTargets:SummaryPosition()
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:SetupButtonLayout()
	if inCombat or InCombatLockdown() then
		reCheckBG = true
		reSetLayout = true
		return
	end

	BattlegroundTargets:SetupLayout() -- TODO check if layout update is needed

	local ButtonScale              = OPT.ButtonScale[currentSize]
	local ButtonWidth              = OPT.ButtonWidth[currentSize]
	local ButtonHeight             = OPT.ButtonHeight[currentSize]
	local ButtonFontSize           = OPT.ButtonFontSize[currentSize]
	local ButtonShowRole           = OPT.ButtonShowRole[currentSize]
	local ButtonShowSpec           = OPT.ButtonShowSpec[currentSize]
	local ButtonClassIcon          = OPT.ButtonClassIcon[currentSize]
	local ButtonShowTargetCount    = OPT.ButtonShowTargetCount[currentSize]
	local ButtonShowTarget         = OPT.ButtonShowTarget[currentSize]
	local ButtonTargetScale        = OPT.ButtonTargetScale[currentSize]
	local ButtonTargetPosition     = OPT.ButtonTargetPosition[currentSize]
	local ButtonShowFocus          = OPT.ButtonShowFocus[currentSize]
	local ButtonFocusScale         = OPT.ButtonFocusScale[currentSize]
	local ButtonFocusPosition      = OPT.ButtonFocusPosition[currentSize]
	local ButtonShowFlag           = OPT.ButtonShowFlag[currentSize]
	local ButtonFlagScale          = OPT.ButtonFlagScale[currentSize]
	local ButtonFlagPosition       = OPT.ButtonFlagPosition[currentSize]
	local ButtonShowAssist         = OPT.ButtonShowAssist[currentSize]
	local ButtonAssistScale        = OPT.ButtonAssistScale[currentSize]
	local ButtonAssistPosition     = OPT.ButtonAssistPosition[currentSize]
	local ButtonRangeCheck         = OPT.ButtonRangeCheck[currentSize]
	local ButtonRangeDisplay       = OPT.ButtonRangeDisplay[currentSize]
	local ButtonShowGuildGroup     = OPT.ButtonShowGuildGroup[currentSize]
	local ButtonGuildGroupPosition = OPT.ButtonGuildGroupPosition[currentSize]

	local LayoutTH      = BattlegroundTargets_Options.LayoutTH[currentSize]
	local LayoutSpace   = BattlegroundTargets_Options.LayoutSpace[currentSize]

	local TargetIcon    = BattlegroundTargets_Options.TargetIcon

	local ButtonWidth_2  = ButtonWidth-2
	local ButtonHeight_2 = ButtonHeight-2

	local backfallFontSize = ButtonFontSize
	if ButtonHeight < ButtonFontSize then
		backfallFontSize = ButtonHeight
	end

	local withIconWidth
	local iconNum = 0
	if ButtonShowRole and ButtonShowSpec and ButtonClassIcon then
		iconNum = 3
	elseif (ButtonShowRole and ButtonShowSpec) or (ButtonShowRole and ButtonClassIcon) or (ButtonShowSpec and ButtonClassIcon) then
		iconNum = 2
	elseif ButtonShowRole or ButtonShowSpec or ButtonClassIcon then
		iconNum = 1
	end
	if ButtonRangeCheck and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
		withIconWidth = (ButtonWidth - ( (ButtonHeight_2*iconNum) + (ButtonHeight_2/2) ) ) - 2
	else
		withIconWidth = (ButtonWidth - (ButtonHeight_2*iconNum)) - 2
	end
	if ButtonShowGuildGroup and ButtonGuildGroupPosition == 3 then
		withIconWidth = withIconWidth - (ButtonHeight_2*0.4)
	end

	for i = 1, currentSize do
		local GVAR_TargetButton = GVAR.TargetButton[i]

		local lvl = GVAR_TargetButton:GetFrameLevel()
		GVAR_TargetButton.GuildGroupButton:SetFrameLevel(lvl+1) -- xBUT
		GVAR_TargetButton.HealthTextButton:SetFrameLevel(lvl+2)
		GVAR_TargetButton.TargetTextureButton:SetFrameLevel(lvl+3)
		GVAR_TargetButton.AssistTextureButton:SetFrameLevel(lvl+4)
		GVAR_TargetButton.FocusTextureButton:SetFrameLevel(lvl+5)
		GVAR_TargetButton.FlagTextureButton:SetFrameLevel(lvl+6)
		GVAR_TargetButton.FlagDebuffButton:SetFrameLevel(lvl+7)

		GVAR_TargetButton:SetScale(ButtonScale)

		GVAR_TargetButton:SetWidth(ButtonWidth)
		GVAR_TargetButton:SetHeight(ButtonHeight)
		GVAR_TargetButton.HighlightT:SetWidth(ButtonWidth)
		GVAR_TargetButton.HighlightR:SetHeight(ButtonHeight)
		GVAR_TargetButton.HighlightB:SetWidth(ButtonWidth)
		GVAR_TargetButton.HighlightL:SetHeight(ButtonHeight)
		GVAR_TargetButton.Background:SetWidth(ButtonWidth_2)
		GVAR_TargetButton.Background:SetHeight(ButtonHeight_2)

		if ButtonRangeCheck and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
			GVAR_TargetButton.RangeTexture:Show()
			GVAR_TargetButton.RangeTexture:SetWidth(ButtonHeight_2/2)
			GVAR_TargetButton.RangeTexture:SetHeight(ButtonHeight_2)
		else
			GVAR_TargetButton.RangeTexture:Hide()
		end
		GVAR_TargetButton.RoleTexture:SetWidth(ButtonHeight_2)
		GVAR_TargetButton.RoleTexture:SetHeight(ButtonHeight_2)
		GVAR_TargetButton.SpecTexture:SetWidth(ButtonHeight_2)
		GVAR_TargetButton.SpecTexture:SetHeight(ButtonHeight_2)
		GVAR_TargetButton.ClassTexture:SetWidth(ButtonHeight_2)
		GVAR_TargetButton.ClassTexture:SetHeight(ButtonHeight_2)

		GVAR_TargetButton.LeaderTexture:SetWidth(ButtonHeight_2/1.5)
		GVAR_TargetButton.LeaderTexture:SetHeight(ButtonHeight_2/1.5)
		if ButtonShowGuildGroup and ButtonGuildGroupPosition == 1 then
			GVAR_TargetButton.LeaderTexture:ClearAllPoints()
			GVAR_TargetButton.LeaderTexture:SetPoint("RIGHT", GVAR_TargetButton, "LEFT", 0, 0)
		else
			GVAR_TargetButton.LeaderTexture:ClearAllPoints()
			GVAR_TargetButton.LeaderTexture:SetPoint("LEFT", GVAR_TargetButton, "LEFT", -(ButtonHeight_2/1.5)/2, 0)
		end

		GVAR_TargetButton.GuildGroup:SetWidth(ButtonHeight_2*0.4)
		GVAR_TargetButton.GuildGroup:SetHeight(ButtonHeight_2*0.4)

		GVAR_TargetButton.ClassColorBackground:SetHeight(ButtonHeight_2)
		GVAR_TargetButton.HealthBar:SetHeight(ButtonHeight_2)

		if ButtonShowRole and ButtonShowSpec and ButtonClassIcon then
			GVAR_TargetButton.RoleTexture:Show()
			GVAR_TargetButton.SpecTexture:Show()
			GVAR_TargetButton.ClassTexture:Show()

			if ButtonRangeCheck and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
				GVAR_TargetButton.RoleTexture:SetPoint("LEFT", GVAR_TargetButton.RangeTexture, "RIGHT", 0, 0)
			else
				GVAR_TargetButton.RoleTexture:SetPoint("LEFT", GVAR_TargetButton, "LEFT", 1, 0)
			end
			GVAR_TargetButton.SpecTexture:SetPoint("LEFT", GVAR_TargetButton.RoleTexture, "RIGHT", 0, 0)
			GVAR_TargetButton.ClassTexture:SetPoint("LEFT", GVAR_TargetButton.SpecTexture, "RIGHT", 0, 0)

			if ButtonShowGuildGroup and ButtonGuildGroupPosition == 3 then
				GVAR_TargetButton.GuildGroup:ClearAllPoints()
				GVAR_TargetButton.GuildGroup:SetPoint("LEFT", GVAR_TargetButton.ClassTexture, "RIGHT", 0, 0)
				GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton.GuildGroup, "RIGHT", 0, 0)
			else
				GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton.ClassTexture, "RIGHT", 0, 0)
			end
		elseif ButtonShowRole and ButtonShowSpec then
			GVAR_TargetButton.RoleTexture:Show()
			GVAR_TargetButton.SpecTexture:Show()
			GVAR_TargetButton.ClassTexture:Hide()

			if ButtonRangeCheck and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
				GVAR_TargetButton.RoleTexture:SetPoint("LEFT", GVAR_TargetButton.RangeTexture, "RIGHT", 0, 0)
			else
				GVAR_TargetButton.RoleTexture:SetPoint("LEFT", GVAR_TargetButton, "LEFT", 1, 0)
			end
			GVAR_TargetButton.SpecTexture:SetPoint("LEFT", GVAR_TargetButton.RoleTexture, "RIGHT", 0, 0)

			if ButtonShowGuildGroup and ButtonGuildGroupPosition == 3 then
				GVAR_TargetButton.GuildGroup:ClearAllPoints()
				GVAR_TargetButton.GuildGroup:SetPoint("LEFT", GVAR_TargetButton.SpecTexture, "RIGHT", 0, 0)
				GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton.GuildGroup, "RIGHT", 0, 0)
			else
				GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton.SpecTexture, "RIGHT", 0, 0)
			end
		elseif ButtonShowRole and ButtonClassIcon then
			GVAR_TargetButton.RoleTexture:Show()
			GVAR_TargetButton.SpecTexture:Hide()
			GVAR_TargetButton.ClassTexture:Show()

			if ButtonRangeCheck and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
				GVAR_TargetButton.RoleTexture:SetPoint("LEFT", GVAR_TargetButton.RangeTexture, "RIGHT", 0, 0)
			else
				GVAR_TargetButton.RoleTexture:SetPoint("LEFT", GVAR_TargetButton, "LEFT", 1, 0)
			end
			GVAR_TargetButton.ClassTexture:SetPoint("LEFT", GVAR_TargetButton.RoleTexture, "RIGHT", 0, 0)

			if ButtonShowGuildGroup and ButtonGuildGroupPosition == 3 then
				GVAR_TargetButton.GuildGroup:ClearAllPoints()
				GVAR_TargetButton.GuildGroup:SetPoint("LEFT", GVAR_TargetButton.ClassTexture, "RIGHT", 0, 0)
				GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton.GuildGroup, "RIGHT", 0, 0)
			else
				GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton.ClassTexture, "RIGHT", 0, 0)
			end
		elseif ButtonShowSpec and ButtonClassIcon then
			GVAR_TargetButton.RoleTexture:Hide()
			GVAR_TargetButton.SpecTexture:Show()
			GVAR_TargetButton.ClassTexture:Show()

			if ButtonRangeCheck and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
				GVAR_TargetButton.SpecTexture:SetPoint("LEFT", GVAR_TargetButton.RangeTexture, "RIGHT", 0, 0)
			else
				GVAR_TargetButton.SpecTexture:SetPoint("LEFT", GVAR_TargetButton, "LEFT", 1, 0)
			end
			GVAR_TargetButton.ClassTexture:SetPoint("LEFT", GVAR_TargetButton.SpecTexture, "RIGHT", 0, 0)

			if ButtonShowGuildGroup and ButtonGuildGroupPosition == 3 then
				GVAR_TargetButton.GuildGroup:ClearAllPoints()
				GVAR_TargetButton.GuildGroup:SetPoint("LEFT", GVAR_TargetButton.ClassTexture, "RIGHT", 0, 0)
				GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton.GuildGroup, "RIGHT", 0, 0)
			else
				GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton.ClassTexture, "RIGHT", 0, 0)
			end
		elseif ButtonShowRole then
			GVAR_TargetButton.RoleTexture:Show()
			GVAR_TargetButton.SpecTexture:Hide()
			GVAR_TargetButton.ClassTexture:Hide()

			if ButtonRangeCheck and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
				GVAR_TargetButton.RoleTexture:SetPoint("LEFT", GVAR_TargetButton.RangeTexture, "RIGHT", 0, 0)
			else
				GVAR_TargetButton.RoleTexture:SetPoint("LEFT", GVAR_TargetButton, "LEFT", 1, 0)
			end

			if ButtonShowGuildGroup and ButtonGuildGroupPosition == 3 then
				GVAR_TargetButton.GuildGroup:ClearAllPoints()
				GVAR_TargetButton.GuildGroup:SetPoint("LEFT", GVAR_TargetButton.RoleTexture, "RIGHT", 0, 0)
				GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton.GuildGroup, "RIGHT", 0, 0)
			else
				GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton.RoleTexture, "RIGHT", 0, 0)
			end
		elseif ButtonShowSpec then
			GVAR_TargetButton.RoleTexture:Hide()
			GVAR_TargetButton.SpecTexture:Show()
			GVAR_TargetButton.ClassTexture:Hide()

			if ButtonRangeCheck and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
				GVAR_TargetButton.SpecTexture:SetPoint("LEFT", GVAR_TargetButton.RangeTexture, "RIGHT", 0, 0)
			else
				GVAR_TargetButton.SpecTexture:SetPoint("LEFT", GVAR_TargetButton, "LEFT", 1, 0)
			end

			if ButtonShowGuildGroup and ButtonGuildGroupPosition == 3 then
				GVAR_TargetButton.GuildGroup:ClearAllPoints()
				GVAR_TargetButton.GuildGroup:SetPoint("LEFT", GVAR_TargetButton.SpecTexture, "RIGHT", 0, 0)
				GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton.GuildGroup, "RIGHT", 0, 0)
			else
				GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton.SpecTexture, "RIGHT", 0, 0)
			end
		elseif ButtonClassIcon then
			GVAR_TargetButton.RoleTexture:Hide()
			GVAR_TargetButton.SpecTexture:Hide()
			GVAR_TargetButton.ClassTexture:Show()

			if ButtonRangeCheck and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
				GVAR_TargetButton.ClassTexture:SetPoint("LEFT", GVAR_TargetButton.RangeTexture, "RIGHT", 0, 0)
			else
				GVAR_TargetButton.ClassTexture:SetPoint("LEFT", GVAR_TargetButton, "LEFT", 1, 0)
			end

			if ButtonShowGuildGroup and ButtonGuildGroupPosition == 3 then
				GVAR_TargetButton.GuildGroup:ClearAllPoints()
				GVAR_TargetButton.GuildGroup:SetPoint("LEFT", GVAR_TargetButton.ClassTexture, "RIGHT", 0, 0)
				GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton.GuildGroup, "RIGHT", 0, 0)
			else
				GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton.ClassTexture, "RIGHT", 0, 0)
			end
		else
			GVAR_TargetButton.RoleTexture:Hide()
			GVAR_TargetButton.SpecTexture:Hide()
			GVAR_TargetButton.ClassTexture:Hide()

			if ButtonShowGuildGroup and ButtonGuildGroupPosition == 3 then
				if ButtonRangeCheck and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
					GVAR_TargetButton.GuildGroup:ClearAllPoints()
					GVAR_TargetButton.GuildGroup:SetPoint("LEFT", GVAR_TargetButton.RangeTexture, "RIGHT", 0, 0)
				else
					GVAR_TargetButton.GuildGroup:ClearAllPoints()
					GVAR_TargetButton.GuildGroup:SetPoint("LEFT", GVAR_TargetButton, "LEFT", 1, 0)
				end
				GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton.GuildGroup, "RIGHT", 0, 0)
			else
				if ButtonRangeCheck and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
					GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton.RangeTexture, "RIGHT", 0, 0)
				else
					GVAR_TargetButton.ClassColorBackground:SetPoint("LEFT", GVAR_TargetButton, "LEFT", 1, 0)
				end
			end
		end

		if ButtonShowGuildGroup then
			if ButtonGuildGroupPosition == 1 then
				GVAR_TargetButton.GuildGroup:ClearAllPoints()
				GVAR_TargetButton.GuildGroup:SetPoint("RIGHT", GVAR_TargetButton, "LEFT", (ButtonHeight_2*0.4)/2, 0)
			elseif ButtonGuildGroupPosition == 2 then
				GVAR_TargetButton.GuildGroup:ClearAllPoints()
				GVAR_TargetButton.GuildGroup:SetPoint("LEFT", GVAR_TargetButton.ClassColorBackground, "LEFT", -(ButtonHeight_2*0.4)/2, 0)
			elseif ButtonGuildGroupPosition == 5 then
				GVAR_TargetButton.GuildGroup:ClearAllPoints()
				GVAR_TargetButton.GuildGroup:SetPoint("RIGHT", GVAR_TargetButton.TargetCount, "LEFT", (ButtonHeight_2*0.4)/2, 0)
			elseif ButtonGuildGroupPosition == 6 then
				GVAR_TargetButton.GuildGroup:ClearAllPoints()
				GVAR_TargetButton.GuildGroup:SetPoint("RIGHT", GVAR_TargetButton, "RIGHT", (ButtonHeight_2*0.4)/2, 0)
			end
		end

		GVAR_TargetButton.Name:SetFont(fontPath, ButtonFontSize, "")
		GVAR_TargetButton.Name:SetShadowOffset(0, 0)
		GVAR_TargetButton.Name:SetShadowColor(0, 0, 0, 0)
		GVAR_TargetButton.Name:SetTextColor(0, 0, 0, 1)
		GVAR_TargetButton.Name:SetHeight(backfallFontSize)

		GVAR_TargetButton.HealthText:SetFont(fontPath, ButtonFontSize, "OUTLINE")
		GVAR_TargetButton.HealthText:SetShadowOffset(0, 0)
		GVAR_TargetButton.HealthText:SetShadowColor(0, 0, 0, 0)
		GVAR_TargetButton.HealthText:SetTextColor(1, 1, 1, 1)
		GVAR_TargetButton.HealthText:SetHeight(backfallFontSize)
		GVAR_TargetButton.HealthText:SetAlpha(0.6)

		if ButtonShowTargetCount then
			healthBarWidth = withIconWidth-20
			GVAR_TargetButton.ClassColorBackground:SetWidth(withIconWidth-20)
			GVAR_TargetButton.HealthBar:SetWidth(withIconWidth-20)
			if ButtonShowGuildGroup and ButtonGuildGroupPosition == 4 then
				GVAR_TargetButton.GuildGroup:ClearAllPoints()
				GVAR_TargetButton.GuildGroup:SetPoint("LEFT", GVAR_TargetButton.ClassColorBackground, "LEFT", 1, 0)
				GVAR_TargetButton.Name:SetPoint("LEFT", GVAR_TargetButton.ClassColorBackground, "LEFT", (ButtonHeight_2*0.4) + 2, 0)
				GVAR_TargetButton.Name:SetWidth(withIconWidth-20-2 - (ButtonHeight_2*0.4))
			else
				GVAR_TargetButton.Name:SetPoint("LEFT", GVAR_TargetButton.ClassColorBackground, "LEFT", 2, 0)
				GVAR_TargetButton.Name:SetWidth(withIconWidth-20-2)
			end
			GVAR_TargetButton.TargetCountBackground:SetHeight(ButtonHeight_2)
			GVAR_TargetButton.TargetCountBackground:Show()
			GVAR_TargetButton.TargetCount:SetFont(fontPath, ButtonFontSize, "")
			GVAR_TargetButton.TargetCount:SetShadowOffset(0, 0)
			GVAR_TargetButton.TargetCount:SetShadowColor(0, 0, 0, 0)
			GVAR_TargetButton.TargetCount:SetHeight(backfallFontSize)
			GVAR_TargetButton.TargetCount:SetTextColor(1, 1, 1, 1)
			GVAR_TargetButton.TargetCount:SetText("")
			GVAR_TargetButton.TargetCount:Show()
		else
			healthBarWidth = withIconWidth
			GVAR_TargetButton.ClassColorBackground:SetWidth(withIconWidth)
			GVAR_TargetButton.HealthBar:SetWidth(withIconWidth)
			if ButtonShowGuildGroup and ButtonGuildGroupPosition == 4 then
				GVAR_TargetButton.GuildGroup:ClearAllPoints()
				GVAR_TargetButton.GuildGroup:SetPoint("LEFT", GVAR_TargetButton.ClassColorBackground, "LEFT", 1, 0)
				GVAR_TargetButton.Name:SetPoint("LEFT", GVAR_TargetButton.ClassColorBackground, "LEFT", (ButtonHeight_2*0.4) + 2, 0)
				GVAR_TargetButton.Name:SetWidth(withIconWidth-2 - (ButtonHeight_2*0.4))
			else
				GVAR_TargetButton.Name:SetPoint("LEFT", GVAR_TargetButton.ClassColorBackground, "LEFT", 2, 0)
				GVAR_TargetButton.Name:SetWidth(withIconWidth-2)
			end
			GVAR_TargetButton.TargetCountBackground:Hide()
			GVAR_TargetButton.TargetCount:Hide()
		end

		if ButtonShowTarget then
			if TargetIcon == "default" then
				GVAR_TargetButton.TargetTexture:SetTexture("Interface\\Minimap\\Tracking\\Target")
			else
				GVAR_TargetButton.TargetTexture:SetTexture(AddonIcon)
			end
			local quad = ButtonHeight_2 * ButtonTargetScale
			local leftPos = -quad
			GVAR_TargetButton.TargetTexture:SetWidth(quad)
			GVAR_TargetButton.TargetTexture:SetHeight(quad)
			if ButtonTargetPosition >= 100 then
				leftPos = ButtonWidth
			elseif ButtonTargetPosition > 0 then
				leftPos = ( (quad + ButtonWidth) * (ButtonTargetPosition/100) ) - quad
			end
			GVAR_TargetButton.TargetTexture:SetPoint("LEFT", GVAR_TargetButton, "LEFT", leftPos, 0)
			GVAR_TargetButton.TargetTexture:Show()
		else
			GVAR_TargetButton.TargetTexture:Hide()
		end

		if ButtonShowFocus then
			local quad = ButtonHeight_2 * ButtonFocusScale
			local leftPos = -quad
			GVAR_TargetButton.FocusTexture:SetWidth(quad)
			GVAR_TargetButton.FocusTexture:SetHeight(quad)
			if ButtonFocusPosition >= 100 then
				leftPos = ButtonWidth
			elseif ButtonFocusPosition > 0 then
				leftPos = ( (quad + ButtonWidth) * (ButtonFocusPosition/100) ) - quad
			end
			GVAR_TargetButton.FocusTexture:SetPoint("LEFT", GVAR_TargetButton, "LEFT", leftPos, 0)
			GVAR_TargetButton.FocusTexture:Show()
		else
			GVAR_TargetButton.FocusTexture:Hide()
		end

		if ButtonShowFlag then
			local quad = ButtonHeight_2 * ButtonFlagScale
			local leftPos = -quad
			GVAR_TargetButton.FlagTexture:SetWidth(quad)
			GVAR_TargetButton.FlagTexture:SetHeight(quad)
			if ButtonFlagPosition >= 100 then
				leftPos = ButtonWidth
			elseif ButtonFlagPosition > 0 then
				leftPos = ( (quad + ButtonWidth) * (ButtonFlagPosition/100) ) - quad
			end
			GVAR_TargetButton.FlagTexture:SetPoint("LEFT", GVAR_TargetButton, "LEFT", leftPos, 0)
			GVAR_TargetButton.FlagTexture:Show()
			GVAR_TargetButton.FlagDebuff:SetFont(fontPath, ButtonFontSize, "OUTLINE")
			GVAR_TargetButton.FlagDebuff:SetShadowOffset(0, 0)
			GVAR_TargetButton.FlagDebuff:SetShadowColor(0, 0, 0, 0)
			GVAR_TargetButton.FlagDebuff:SetTextColor(1, 1, 1, 1)
			GVAR_TargetButton.FlagDebuff:SetHeight(backfallFontSize)
			GVAR_TargetButton.FlagDebuff:SetAlpha(1)
			GVAR_TargetButton.FlagDebuff:Show()
		else
			GVAR_TargetButton.FlagTexture:Hide()
			GVAR_TargetButton.FlagDebuff:Hide()
		end

		if ButtonShowAssist then
			local quad = ButtonHeight_2 * ButtonAssistScale
			local leftPos = -quad
			GVAR_TargetButton.AssistTexture:SetWidth(quad)
			GVAR_TargetButton.AssistTexture:SetHeight(quad)
			if ButtonAssistPosition >= 100 then
				leftPos = ButtonWidth
			elseif ButtonAssistPosition > 0 then
				leftPos = ( (quad + ButtonWidth) * (ButtonAssistPosition/100) ) - quad
			end
			GVAR_TargetButton.AssistTexture:SetPoint("LEFT", GVAR_TargetButton, "LEFT", leftPos, 0)
			GVAR_TargetButton.AssistTexture:Show()
		else
			GVAR_TargetButton.AssistTexture:Hide()
		end
	end
	reSetLayout = false
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:Frame_Toggle(frame, show)
	if show then
		frame:Show()
	else
		if frame:IsShown() then
			frame:Hide()
		else
			frame:Show()
		end
	end
end

function BattlegroundTargets:Frame_SetupPosition(frameName)
	if frameName == "BattlegroundTargets_MainFrame" then
		if BattlegroundTargets_Options.IndependentPositioning[currentSize] and BattlegroundTargets_Options.pos[frameName..currentSize.."_posX"] then
			_G[frameName]:ClearAllPoints()
			_G[frameName]:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", BattlegroundTargets_Options.pos[frameName..currentSize.."_posX"], BattlegroundTargets_Options.pos[frameName..currentSize.."_posY"])
		elseif BattlegroundTargets_Options.pos[frameName.."_posX"] then
			_G[frameName]:ClearAllPoints()
			_G[frameName]:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", BattlegroundTargets_Options.pos[frameName.."_posX"], BattlegroundTargets_Options.pos[frameName.."_posY"])
		else
			_G[frameName]:ClearAllPoints()
			_G[frameName]:SetPoint("TOPRIGHT", GVAR.OptionsFrame, "TOPLEFT", -80, 19)
			BattlegroundTargets_Options.pos[frameName.."_posX"] = _G[frameName]:GetLeft()
			BattlegroundTargets_Options.pos[frameName.."_posY"] = _G[frameName]:GetTop()
			_G[frameName]:ClearAllPoints()
			_G[frameName]:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", BattlegroundTargets_Options.pos[frameName.."_posX"], BattlegroundTargets_Options.pos[frameName.."_posY"])
		end
	elseif frameName == "BattlegroundTargets_OptionsFrame" then
		if BattlegroundTargets_Options.pos[frameName.."_posX"] then
			_G[frameName]:ClearAllPoints()
			_G[frameName]:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", BattlegroundTargets_Options.pos[frameName.."_posX"], BattlegroundTargets_Options.pos[frameName.."_posY"])
		else
			_G[frameName]:ClearAllPoints()
			_G[frameName]:SetPoint("CENTER", UIParent, "CENTER", 0, 50)
		end
	end
end

function BattlegroundTargets:Frame_SavePosition(frameName)
	local x,y
	if frameName == "BattlegroundTargets_MainFrame" and BattlegroundTargets_Options.IndependentPositioning[currentSize] then
		x = frameName..currentSize.."_posX"
		y = frameName..currentSize.."_posY"
	else
		x = frameName.."_posX"
		y = frameName.."_posY"
	end
	BattlegroundTargets_Options.pos[x] = _G[frameName]:GetLeft()
	BattlegroundTargets_Options.pos[y] = _G[frameName]:GetTop()
	_G[frameName]:ClearAllPoints()
	_G[frameName]:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", BattlegroundTargets_Options.pos[x], BattlegroundTargets_Options.pos[y])
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:MainFrameShow()
	if inCombat or InCombatLockdown() then return end
	BattlegroundTargets:Frame_SetupPosition("BattlegroundTargets_MainFrame")
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:OptionsFrameHide()
	PlaySound("igQuestListClose")
	isConfig = false
	testDataLoaded = false
	TEMPLATE.EnableTextButton(GVAR.InterfaceOptions.CONFIG, 1)
	BattlegroundTargets:DisableConfigMode()
end

function BattlegroundTargets:OptionsFrameShow()
	PlaySound("igQuestListOpen")
	isConfig = true
	TEMPLATE.DisableTextButton(GVAR.InterfaceOptions.CONFIG)
	BattlegroundTargets:Frame_SetupPosition("BattlegroundTargets_OptionsFrame")
	GVAR.OptionsFrame:StartMoving()
	GVAR.OptionsFrame:StopMovingOrSizing()

	if inBattleground then
		testSize = currentSize
	end

	GVAR.OptionsFrame.ConfigGeneral:Hide()
	GVAR.OptionsFrame.ConfigBrackets:Show()

	if testSize == 10 then
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, true)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, nil)
	elseif testSize == 15 then
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, true)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, nil)
	elseif testSize == 40 then
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, true)
	end

	if inCombat or InCombatLockdown() then
		BattlegroundTargets:DisableInsecureConfigWidges()
	else
		BattlegroundTargets:EnableInsecureConfigWidges()
	end

	if BattlegroundTargets_Options.EnableBracket[testSize] then
		BattlegroundTargets:ShuffleSizeCheck(testSize)
		BattlegroundTargets:ConfigGuildGroupFriendUpdate(testSize)
		BattlegroundTargets:EnableConfigMode()
	else
		BattlegroundTargets:DisableConfigMode()
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:EnableConfigMode()
	if inCombat or InCombatLockdown() then
		reCheckBG = true
		reSetLayout = true
		return
	end

	-- Test Data START
	if not testDataLoaded then
		table_wipe(ENEMY_Data)

		ENEMY_Data[1] = {}
		ENEMY_Data[1].name = TARGET.."_Aa-servername"
		ENEMY_Data[1].classToken = "DRUID"
		ENEMY_Data[1].talentSpec = TLT.DRUID[3]
		ENEMY_Data[2] = {}
		ENEMY_Data[2].name = TARGET.."_Bb-servername"
		ENEMY_Data[2].classToken = "PRIEST"
		ENEMY_Data[2].talentSpec = TLT.PRIEST[3]
		ENEMY_Data[3] = {}
		ENEMY_Data[3].name = TARGET.."_Cc-servername"
		ENEMY_Data[3].classToken = "WARLOCK" -- "MONK" TODO_MoP
		ENEMY_Data[3].talentSpec = TLT.WARLOCK[1] -- TLT.MONK[2]
		ENEMY_Data[4] = {}
		ENEMY_Data[4].name = TARGET.."_Dd-servername"
		ENEMY_Data[4].classToken = "HUNTER"
		ENEMY_Data[4].talentSpec = TLT.HUNTER[3]
		ENEMY_Data[5] = {}
		ENEMY_Data[5].name = TARGET.."_Ee-servername"
		ENEMY_Data[5].classToken = "WARRIOR"
		ENEMY_Data[5].talentSpec = TLT.WARRIOR[3]
		ENEMY_Data[6] = {}
		ENEMY_Data[6].name = TARGET.."_Ff-servername"
		ENEMY_Data[6].classToken = "ROGUE"
		ENEMY_Data[6].talentSpec = TLT.ROGUE[2]
		ENEMY_Data[7] = {}
		ENEMY_Data[7].name = TARGET.."_Gg-servername"
		ENEMY_Data[7].classToken = "SHAMAN"
		ENEMY_Data[7].talentSpec = TLT.SHAMAN[3]
		ENEMY_Data[8] = {}
		ENEMY_Data[8].name = TARGET.."_Hh-servername"
		ENEMY_Data[8].classToken = "PALADIN"
		ENEMY_Data[8].talentSpec = TLT.PALADIN[3]
		ENEMY_Data[9] = {}
		ENEMY_Data[9].name = TARGET.."_Ii-servername"
		ENEMY_Data[9].classToken = "MAGE"
		ENEMY_Data[9].talentSpec = TLT.MAGE[3]
		ENEMY_Data[10] = {}
		ENEMY_Data[10].name = TARGET.."_Jj-servername"
		ENEMY_Data[10].classToken = "DEATHKNIGHT"
		ENEMY_Data[10].talentSpec = TLT.DEATHKNIGHT[2]
		ENEMY_Data[11] = {}
		ENEMY_Data[11].name = TARGET.."_Kk-servername"
		ENEMY_Data[11].classToken = "DRUID"
		ENEMY_Data[11].talentSpec = TLT.DRUID[1]
		ENEMY_Data[12] = {}
		ENEMY_Data[12].name = TARGET.."_Ll-servername"
		ENEMY_Data[12].classToken = "DEATHKNIGHT"
		ENEMY_Data[12].talentSpec = TLT.DEATHKNIGHT[3]
		ENEMY_Data[13] = {}
		ENEMY_Data[13].name = TARGET.."_Mm-servername"
		ENEMY_Data[13].classToken = "PALADIN"
		ENEMY_Data[13].talentSpec = TLT.PALADIN[3]
		ENEMY_Data[14] = {}
		ENEMY_Data[14].name = TARGET.."_Nn-servername"
		ENEMY_Data[14].classToken = "MAGE"
		ENEMY_Data[14].talentSpec = TLT.MAGE[1]
		ENEMY_Data[15] = {}
		ENEMY_Data[15].name = TARGET.."_Oo-servername"
		ENEMY_Data[15].classToken = "SHAMAN"
		ENEMY_Data[15].talentSpec = TLT.SHAMAN[2]
		ENEMY_Data[16] = {}
		ENEMY_Data[16].name = TARGET.."_Pp-servername"
		ENEMY_Data[16].classToken = "ROGUE"
		ENEMY_Data[16].talentSpec = TLT.ROGUE[1]
		ENEMY_Data[17] = {}
		ENEMY_Data[17].name = TARGET.."_Qq-servername"
		ENEMY_Data[17].classToken = "WARLOCK"
		ENEMY_Data[17].talentSpec = TLT.WARLOCK[2]
		ENEMY_Data[18] = {}
		ENEMY_Data[18].name = TARGET.."_Rr-servername"
		ENEMY_Data[18].classToken = "PRIEST"
		ENEMY_Data[18].talentSpec = TLT.PRIEST[3]
		ENEMY_Data[19] = {}
		ENEMY_Data[19].name = TARGET.."_Ss-servername"
		ENEMY_Data[19].classToken = "WARRIOR"
		ENEMY_Data[19].talentSpec = TLT.WARRIOR[1]
		ENEMY_Data[20] = {}
		ENEMY_Data[20].name = TARGET.."_Tt-servername"
		ENEMY_Data[20].classToken = "DRUID"
		ENEMY_Data[20].talentSpec = TLT.DRUID[2]
		ENEMY_Data[21] = {}
		ENEMY_Data[21].name = TARGET.."_Uu-servername"
		ENEMY_Data[21].classToken = "PRIEST"
		ENEMY_Data[21].talentSpec = TLT.PRIEST[3]
		ENEMY_Data[22] = {}
		ENEMY_Data[22].name = TARGET.."_Vv-servername"
		ENEMY_Data[22].classToken = "WARRIOR" -- "MONK" TODO_MoP
		ENEMY_Data[22].talentSpec = TLT.WARRIOR[1] -- TLT.MONK[1]
		ENEMY_Data[23] = {}
		ENEMY_Data[23].name = TARGET.."_Ww-servername"
		ENEMY_Data[23].classToken = "SHAMAN"
		ENEMY_Data[23].talentSpec = TLT.SHAMAN[1]
		ENEMY_Data[24] = {}
		ENEMY_Data[24].name = TARGET.."_Xx-servername"
		ENEMY_Data[24].classToken = "HUNTER"
		ENEMY_Data[24].talentSpec = TLT.HUNTER[2]
		ENEMY_Data[25] = {}
		ENEMY_Data[25].name = TARGET.."_Yy-servername"
		ENEMY_Data[25].classToken = "SHAMAN"
		ENEMY_Data[25].talentSpec = TLT.SHAMAN[2]
		ENEMY_Data[26] = {}
		ENEMY_Data[26].name = TARGET.."_Zz-servername"
		ENEMY_Data[26].classToken = "WARLOCK"
		ENEMY_Data[26].talentSpec = TLT.WARLOCK[3]
		ENEMY_Data[27] = {}
		ENEMY_Data[27].name = TARGET.."_Ab-servername"
		ENEMY_Data[27].classToken = "PRIEST"
		ENEMY_Data[27].talentSpec = TLT.PRIEST[2]
		ENEMY_Data[28] = {}
		ENEMY_Data[28].name = TARGET.."_Cd-servername"
		ENEMY_Data[28].classToken = "MAGE" -- "MONK" TODO_MoP
		ENEMY_Data[28].talentSpec = TLT.MAGE[2] -- TLT.MONK[3]
		ENEMY_Data[29] = {}
		ENEMY_Data[29].name = TARGET.."_Ef-servername"
		ENEMY_Data[29].classToken = "ROGUE"
		ENEMY_Data[29].talentSpec = TLT.ROGUE[3]
		ENEMY_Data[30] = {}
		ENEMY_Data[30].name = TARGET.."_Gh-servername"
		ENEMY_Data[30].classToken = "DRUID"
		ENEMY_Data[30].talentSpec = TLT.DRUID[1]
		ENEMY_Data[31] = {}
		ENEMY_Data[31].name = TARGET.."_Ij-servername"
		ENEMY_Data[31].classToken = "HUNTER"
		ENEMY_Data[31].talentSpec = TLT.HUNTER[3]
		ENEMY_Data[32] = {}
		ENEMY_Data[32].name = TARGET.."_Kl-servername"
		ENEMY_Data[32].classToken = "WARRIOR"
		ENEMY_Data[32].talentSpec = TLT.WARRIOR[2]
		ENEMY_Data[33] = {}
		ENEMY_Data[33].name = TARGET.."_Mn-servername"
		ENEMY_Data[33].classToken = "PALADIN"
		ENEMY_Data[33].talentSpec = TLT.PALADIN[1]
		ENEMY_Data[34] = {}
		ENEMY_Data[34].name = TARGET.."_Op-servername"
		ENEMY_Data[34].classToken = "MAGE"
		ENEMY_Data[34].talentSpec = TLT.MAGE[3]
		ENEMY_Data[35] = {}
		ENEMY_Data[35].name = TARGET.."_Qr-servername"
		ENEMY_Data[35].classToken = "DEATHKNIGHT"
		ENEMY_Data[35].talentSpec = TLT.DEATHKNIGHT[3]
		ENEMY_Data[36] = {}
		ENEMY_Data[36].name = TARGET.."_St-servername"
		ENEMY_Data[36].classToken = "MAGE"
		ENEMY_Data[36].talentSpec = TLT.MAGE[2]
		ENEMY_Data[37] = {}
		ENEMY_Data[37].name = TARGET.."_Uv-servername"
		ENEMY_Data[37].classToken = "HUNTER"
		ENEMY_Data[37].talentSpec = TLT.HUNTER[2]
		ENEMY_Data[38] = {}
		ENEMY_Data[38].name = TARGET.."_Wx-servername"
		ENEMY_Data[38].classToken = "WARLOCK"
		ENEMY_Data[38].talentSpec = TLT.WARLOCK[1]
		ENEMY_Data[39] = {}
		ENEMY_Data[39].name = TARGET.."_Yz-servername"
		ENEMY_Data[39].classToken = "WARLOCK"
		ENEMY_Data[39].talentSpec = TLT.WARLOCK[2]
		ENEMY_Data[40] = {}
		ENEMY_Data[40].name = TARGET.."_Zz-servername"
		ENEMY_Data[40].classToken = "ROGUE"
		ENEMY_Data[40].talentSpec = nil

		if tocversion >= 50000 then -- TODO_MoP
			ENEMY_Data[3].classToken = "MONK"
			ENEMY_Data[3].talentSpec = nil--TLT.MONK[2] -- TODO_MoP
			ENEMY_Data[22].classToken = "MONK"
			ENEMY_Data[22].talentSpec = nil--TLT.MONK[1] -- TODO_MoP
			ENEMY_Data[28].classToken = "MONK"
			ENEMY_Data[28].talentSpec = nil--TLT.MONK[3] -- TODO_MoP
		end

		for i = 1, 40 do
			local role = 4
			local spec = 4

			local talentSpec = ENEMY_Data[i].talentSpec
			local classToken = ENEMY_Data[i].classToken

			if talentSpec and classToken then
				local token = TLT[classToken]
				if token then
					if talentSpec == token[1] then
						role = classes[classToken].spec[1].role
						spec = 1
					elseif talentSpec == token[2] then
						role = classes[classToken].spec[2].role
						spec = 2
					elseif talentSpec == token[3] then
						role = classes[classToken].spec[3].role
						spec = 3
					end
				end
			end
			ENEMY_Data[i].specNum = spec
			ENEMY_Data[i].talentSpec = role
		end

		testDataLoaded = true
	end
	-- Test Data END

	currentSize = testSize
	BattlegroundTargets:Frame_SetupPosition("BattlegroundTargets_MainFrame")
	BattlegroundTargets:SetOptions()

	GVAR.MainFrame:Show() -- HiDE
	GVAR.MainFrame:EnableMouse(true)
	GVAR.MainFrame:SetHeight(20)
	GVAR.MainFrame.Movetext:Show()
	GVAR.TargetButton[1]:SetPoint("TOPLEFT", GVAR.MainFrame, "BOTTOMLEFT", 0, 0)
	GVAR.ScoreUpdateTexture:Hide()

	BattlegroundTargets:ShufflerFunc("ShuffleCheck")
	BattlegroundTargets:SetupButtonLayout()
	BattlegroundTargets:MainDataUpdate()
	BattlegroundTargets:SetConfigButtonValues()

	for i = 1, 40 do
		if i < currentSize+1 then
			GVAR.TargetButton[i]:Show()
		else
			GVAR.TargetButton[i]:Hide()
		end
	end

	BattlegroundTargets:ScoreWarningCheck()
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:DisableConfigMode()
	if inCombat or InCombatLockdown() then
		reCheckBG = true
		reSetLayout = true
		return
	end

	currentSize = testSize
	BattlegroundTargets:SetOptions()

	GVAR.MainFrame:Hide()
	for i = 1, 40 do
		GVAR.TargetButton[i]:Hide()
	end
	isTarget = 0

	BattlegroundTargets:BattlefieldCheck()

	if not inBattleground then return end

	BattlegroundTargets:CheckPlayerTarget()
	BattlegroundTargets:CheckAssist()
	BattlegroundTargets:CheckPlayerFocus()

	if OPT.ButtonRangeCheck[currentSize] then
		BattlegroundTargets:UpdateRange(GetTime())
	end

	if OPT.ButtonShowGuildGroup[currentSize] then
		BattlegroundTargets:GuildGroupFriendUpdate()
		BattlegroundTargets:GuildGroupEnemyUpdate()
	end

	if OPT.ButtonShowFlag[currentSize] then
		if hasFlag then
			local Name2Button = ENEMY_Name2Button[hasFlag]
			if Name2Button then
				local GVAR_TargetButton = GVAR.TargetButton[Name2Button]
				if GVAR_TargetButton then
					GVAR_TargetButton.FlagTexture:SetAlpha(1)
					BattlegroundTargets:SetFlagDebuff(GVAR_TargetButton)
				end
			end
		end
	else
		BattlegroundTargets:CheckFlagCarrierEND()
	end

	if OPT.ButtonShowLeader[currentSize] then
		if isLeader then
			local Name2Button = ENEMY_Name2Button[isLeader]
			if Name2Button then
				local GVAR_TargetButton = GVAR.TargetButton[Name2Button]
				if GVAR_TargetButton then
					GVAR_TargetButton.LeaderTexture:SetAlpha(0.75)
				end
			end
		end
	end
	BattlegroundTargets:ScoreWarningCheck()
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:ScoreWarningCheck()
	if not inBattleground then return end
	local wssf = WorldStateScoreFrame
	if wssf and wssf:IsShown() then
		if BattlegroundTargets_Options.EnableBracket[currentSize] then
			if wssf.selectedTab and wssf.selectedTab > 1 then
				GVAR.WorldStateScoreWarning:Show()
			else
				GVAR.WorldStateScoreWarning:Hide()
			end
		else
			GVAR.WorldStateScoreWarning:Hide()
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:SetConfigButtonValues()
	local ButtonShowHealthBar   = OPT.ButtonShowHealthBar[currentSize]
	local ButtonShowHealthText  = OPT.ButtonShowHealthText[currentSize]
	local ButtonRangeCheck      = OPT.ButtonRangeCheck[currentSize]
	local ButtonRangeDisplay    = OPT.ButtonRangeDisplay[currentSize]
	local ButtonShowGuildGroup  = OPT.ButtonShowGuildGroup[currentSize]

	for i = 1, currentSize do
		local GVAR_TargetButton = GVAR.TargetButton[i]

		-- target, targetcount, focus, flag, assist, leader
		GVAR_TargetButton.TargetTexture:SetAlpha(0)
		GVAR_TargetButton.HighlightT:SetTexture(0, 0, 0, 1)
		GVAR_TargetButton.HighlightR:SetTexture(0, 0, 0, 1)
		GVAR_TargetButton.HighlightB:SetTexture(0, 0, 0, 1)
		GVAR_TargetButton.HighlightL:SetTexture(0, 0, 0, 1)
		GVAR_TargetButton.TargetCount:SetText("0")
		GVAR_TargetButton.FocusTexture:SetAlpha(0)
		GVAR_TargetButton.FlagTexture:SetAlpha(0)
		GVAR_TargetButton.FlagDebuff:SetText("")
		GVAR_TargetButton.AssistTexture:SetAlpha(0)
		GVAR_TargetButton.LeaderTexture:SetAlpha(0)

		-- health
		if ButtonShowHealthBar then
			local width = healthBarWidth * (testHealth[i] / 100)
			width = math_max(0.01, width)
			width = math_min(healthBarWidth, width)
			GVAR_TargetButton.HealthBar:SetWidth(width)
		else
			GVAR_TargetButton.HealthBar:SetWidth(healthBarWidth)
		end
		if ButtonShowHealthText then
			GVAR_TargetButton.HealthText:SetText(testHealth[i])
		else
			GVAR_TargetButton.HealthText:SetText("")
		end

		-- range
		if ButtonRangeCheck then
			if testRange[i] < 40 then
				Range_Display(true, GVAR_TargetButton, ButtonRangeDisplay)
			else
				Range_Display(false, GVAR_TargetButton, ButtonRangeDisplay)
			end
		else
			Range_Display(true, GVAR_TargetButton, ButtonRangeDisplay)
		end

		-- guild group
		if ButtonShowGuildGroup then
			if testGroupNum[i] then
				local texNum, colNum = ggTexCol(testGroupNum[i])
				local tex = guildGrpTex[texNum]
				local col = guildGrpCol[colNum]
				GVAR_TargetButton.GuildGroup:SetTexCoord(tex[1], tex[2], tex[3], tex[4]) -- GRP_TEX
				GVAR_TargetButton.GuildGroup:SetVertexColor(col[1], col[2], col[3])
			else
				GVAR_TargetButton.GuildGroup:SetTexCoord(0, 0, 0, 0)
			end
		else
			GVAR_TargetButton.GuildGroup:SetTexCoord(0, 0, 0, 0)
		end
	end

	-- leader, target, focus, flag, assist
	isTarget = 0
	if OPT.ButtonShowTarget[currentSize] then
		local GVAR_TargetButton = GVAR.TargetButton[testIcon1]
		GVAR_TargetButton.TargetTexture:SetAlpha(1)
		GVAR_TargetButton.HighlightT:SetTexture(0.5, 0.5, 0.5, 1)
		GVAR_TargetButton.HighlightR:SetTexture(0.5, 0.5, 0.5, 1)
		GVAR_TargetButton.HighlightB:SetTexture(0.5, 0.5, 0.5, 1)
		GVAR_TargetButton.HighlightL:SetTexture(0.5, 0.5, 0.5, 1)
		isTarget = testIcon1
	end
	if OPT.ButtonShowFocus[currentSize] then
		GVAR.TargetButton[testIcon2].FocusTexture:SetAlpha(1)
	end
	if OPT.ButtonShowFlag[currentSize] then
		if currentSize == 10 or currentSize == 15 then
			GVAR.TargetButton[testIcon3].FlagTexture:SetAlpha(1)
			GVAR.TargetButton[testIcon3].FlagDebuff:SetText(testLeader)
		end
	end
	if OPT.ButtonShowAssist[currentSize] then
		GVAR.TargetButton[testIcon4].AssistTexture:SetAlpha(1)
	end
	if OPT.ButtonShowLeader[currentSize] then
		GVAR.TargetButton[testLeader].LeaderTexture:SetAlpha(0.75)
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:ClearConfigButtonValues(GVAR_TargetButton, clearRange)
	GVAR_TargetButton.colR  = 0
	GVAR_TargetButton.colG  = 0
	GVAR_TargetButton.colB  = 0
	GVAR_TargetButton.colR5 = 0
	GVAR_TargetButton.colG5 = 0
	GVAR_TargetButton.colB5 = 0

	-- target, targetcount, focus, flag, assist, leader
	GVAR_TargetButton.TargetTexture:SetAlpha(0)
	GVAR_TargetButton.HighlightT:SetTexture(0, 0, 0, 1)
	GVAR_TargetButton.HighlightR:SetTexture(0, 0, 0, 1)
	GVAR_TargetButton.HighlightB:SetTexture(0, 0, 0, 1)
	GVAR_TargetButton.HighlightL:SetTexture(0, 0, 0, 1)
	GVAR_TargetButton.TargetCount:SetText("")
	GVAR_TargetButton.FocusTexture:SetAlpha(0)
	GVAR_TargetButton.FlagTexture:SetAlpha(0)
	GVAR_TargetButton.FlagDebuff:SetText("")
	GVAR_TargetButton.AssistTexture:SetAlpha(0)
	GVAR_TargetButton.LeaderTexture:SetAlpha(0)

	-- health
	GVAR_TargetButton.HealthBar:SetTexture(0, 0, 0, 0)
	GVAR_TargetButton.HealthBar:SetWidth(healthBarWidth)
	GVAR_TargetButton.HealthText:SetText("")

	-- range
	GVAR_TargetButton.RangeTexture:SetTexture(0, 0, 0, 0)

	-- guild group
	GVAR_TargetButton.GuildGroup:SetTexCoord(0, 0, 0, 0)

	-- basics
	GVAR_TargetButton.Name:SetText("")
	GVAR_TargetButton.RoleTexture:SetTexCoord(0, 0, 0, 0)
	GVAR_TargetButton.SpecTexture:SetTexture(nil)
	GVAR_TargetButton.ClassTexture:SetTexCoord(0, 0, 0, 0)
	GVAR_TargetButton.ClassColorBackground:SetTexture(0, 0, 0, 0)

	if clearRange then
		Range_Display(false, GVAR_TargetButton, OPT.ButtonRangeDisplay[currentSize])
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:DefaultShuffle()
	for i = 1, 40 do
		testHealth[i] = math_random(0,100)
		testRange[i]  = math_random(0,100)
	end
	testIcon1  = math_random(1,10)
	testIcon2  = math_random(1,10)
	testIcon3  = math_random(1,10)
	testIcon4  = math_random(1,10)
	testLeader = math_random(1,10)

	-- guild groups
	table_wipe(testGroupNum)

	local rndGG -- guild group count
	local r = math_random(0,100)
	if r > 96 then -- 4%
		rndGG = math_random(1,math_floor(currentSize/2))
	elseif r > 82 then -- 14%
		if     currentSize == 10 then rndGG = math_random(1,4)
		elseif currentSize == 15 then rndGG = math_random(1,5)
		elseif currentSize == 40 then rndGG = math_random(1,10)
		end
	elseif r > 60 then -- 22%
		if     currentSize == 10 then rndGG = math_random(1,3)
		elseif currentSize == 15 then rndGG = math_random(1,4)
		elseif currentSize == 40 then rndGG = math_random(1,5)
		end
	else -- 60%
		if     currentSize == 10 then rndGG = math_random(1,2)
		elseif currentSize == 15 then rndGG = math_random(1,2)
		elseif currentSize == 40 then rndGG = math_random(1,4)
		end
	end

	local memGG = {} -- value = member count
	local rem = currentSize - (rndGG * 2)
	for i = 1, rndGG do
		memGG[i] = 2 -- min. 2 members
		if rem > 0 then
			local n = 0 -- 45%
			local r = math_random(0,100)
			if r > 94 then -- 6%
				n = math_random(0,rem)
			elseif r > 75 then -- 19%
				n = math_random(0,1)
			elseif r > 45 then -- 30%
				n = 1
			end
			memGG[i] = memGG[i] + n
			rem = rem - n
		end
	end

	for i = 1, rndGG do
		for j = 1, memGG[i] do
			local r = math_random(1,currentSize)
			if not testGroupNum[r] then
				testGroupNum[r] = i
			else
				local n = r + 1
				if n <= currentSize and not testGroupNum[n] then
					testGroupNum[n] = i
				else
					for k = 1, currentSize do
						if not testGroupNum[k] then
							testGroupNum[k] = i
							break
						end
					end
				end
			end
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:ShufflerFunc(what)
	if what == "OnLeave" then
		GVAR.OptionsFrame:SetScript("OnUpdate", nil)
		GVAR.OptionsFrame.TestShuffler.Texture:SetWidth(32)
		GVAR.OptionsFrame.TestShuffler.Texture:SetHeight(32)
		GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetWidth(32)
		GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetHeight(32)
	elseif what == "OnEnter" then
		BattlegroundTargets.elapsed = 1
		BattlegroundTargets.progBit = true
		if not BattlegroundTargets.progNum then BattlegroundTargets.progNum = 0 end
		if not BattlegroundTargets.progMod then BattlegroundTargets.progMod = 0 end
		GVAR.OptionsFrame:SetScript("OnUpdate", function(self, elap)
			if inCombat then GVAR.OptionsFrame:SetScript("OnUpdate", nil) return end
			BattlegroundTargets.elapsed = BattlegroundTargets.elapsed + elap
			if BattlegroundTargets.elapsed < 0.4 then return end
			BattlegroundTargets.elapsed = 0
			BattlegroundTargets:Shuffle(BattlegroundTargets.shuffleStyle)
		end)
	elseif what == "OnClick" then
		GVAR.OptionsFrame.TestShuffler.Texture:SetWidth(32)
		GVAR.OptionsFrame.TestShuffler.Texture:SetHeight(32)
		GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetWidth(32)
		GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetHeight(32)
		BattlegroundTargets.shuffleStyle = not BattlegroundTargets.shuffleStyle
		if BattlegroundTargets.shuffleStyle then
			GVAR.OptionsFrame.TestShuffler.Texture:SetTexture("Interface\\Icons\\INV_Sigil_Thorim")
		else
			GVAR.OptionsFrame.TestShuffler.Texture:SetTexture("Interface\\Icons\\INV_Sigil_Mimiron")
		end
	elseif what == "OnMouseDown" then
		GVAR.OptionsFrame.TestShuffler.Texture:SetWidth(30)
		GVAR.OptionsFrame.TestShuffler.Texture:SetHeight(30)
		GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetWidth(30)
		GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetHeight(30)
	elseif what == "ShuffleCheck" then
		local num = 0
		if OPT.ButtonShowLeader[currentSize]     then num = num + 1 end
		if OPT.ButtonShowGuildGroup[currentSize] then num = num + 1 end
		if OPT.ButtonShowTarget[currentSize]     then num = num + 1 end
		if OPT.ButtonShowFocus[currentSize]      then num = num + 1 end
		if OPT.ButtonShowFlag[currentSize]       then num = num + 1 end
		if OPT.ButtonShowAssist[currentSize]     then num = num + 1 end
		if OPT.ButtonShowHealthBar[currentSize]  then num = num + 1 end
		if OPT.ButtonShowHealthText[currentSize] then num = num + 1 end
		if OPT.ButtonRangeCheck[currentSize]     then num = num + 1 end
		if num > 0 then
			GVAR.OptionsFrame.TestShuffler:Show()
		else
			GVAR.OptionsFrame.TestShuffler:Hide()
		end
	end
end

function BattlegroundTargets:Shuffle(shuffleStyle)
	BattlegroundTargets.progBit = not BattlegroundTargets.progBit
	if BattlegroundTargets.progBit then
		GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetAlpha(0)
	else
		GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetAlpha(0.5)
	end

	if shuffleStyle then
		BattlegroundTargets:DefaultShuffle()
	else
		if BattlegroundTargets.progMod == 0 then
			BattlegroundTargets.progNum = BattlegroundTargets.progNum + 1
		else
			BattlegroundTargets.progNum = BattlegroundTargets.progNum - 1
		end
		if BattlegroundTargets.progNum >= 10 then
			BattlegroundTargets.progNum = 10
			BattlegroundTargets.progMod = 1
		elseif BattlegroundTargets.progNum <= 1 then
			BattlegroundTargets.progNum = 1
			BattlegroundTargets.progMod = 0
		end
		testIcon1  = BattlegroundTargets.progNum
		testIcon2  = BattlegroundTargets.progNum
		testIcon3  = BattlegroundTargets.progNum
		testIcon4  = BattlegroundTargets.progNum
		testLeader = BattlegroundTargets.progNum
		local num = BattlegroundTargets.progNum*10
		for i = 1, 40 do
			testHealth[i] = num
			testRange[i] = 100
		end
		testRange[BattlegroundTargets.progNum] = 30
	end

	BattlegroundTargets:ConfigGuildGroupEnemyUpdate(currentSize)
	BattlegroundTargets:SetConfigButtonValues()
end

function BattlegroundTargets:ShuffleSizeCheck(bracketSize) -- guild groups
	if not OPT.ButtonShowGuildGroup[bracketSize] then return end

	-- build table from current bracketSize
	local coun0t = {}
	for i = 1, bracketSize do
		local grpNum = testGroupNum[i]
		if grpNum then
			if not coun0t[grpNum] then
				coun0t[grpNum] = 1
			else
				coun0t[grpNum] = coun0t[grpNum] + 1
			end
		end
	end

	-- delete keys where groupmembers is < 2 in current bracktSize (in case of bracket switch)
	for guildNum, guildCount in pairs(coun0t) do
		if guildCount < 2 then
			for k, v in pairs(testGroupNum) do
				if v == guildNum then
					testGroupNum[k] = nil
				end
			end
		end
	end
	BattlegroundTargets:ConfigGuildGroupEnemyUpdate(bracketSize)
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:ConfigGuildGroupFriendUpdate(bracketSize)
	if not OPT.ButtonShowGuildGroup[bracketSize] then return end
	if not BattlegroundTargets_Options.Summary[bracketSize] then return end

	if bracketSize == 10 then
		for i = 1, 7 do
			if i < 4 then
				GVAR.GuildGroupSummaryFriend[i].Text:SetText((i+1)..": 1x") -- GG_CONFTXT
			else
				GVAR.GuildGroupSummaryFriend[i].Text:SetText("")
			end
		end
	elseif bracketSize == 15 then
		for i = 1, 7 do
			if i < 5 then
				GVAR.GuildGroupSummaryFriend[i].Text:SetText((i+1)..": 1x") -- GG_CONFTXT
			else
				GVAR.GuildGroupSummaryFriend[i].Text:SetText("")
			end
		end
	elseif bracketSize == 40 then
		for i = 1, 7 do
			GVAR.GuildGroupSummaryFriend[i].Text:SetText((i+1)..": 1x") -- GG_CONFTXT
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:ConfigGuildGroupEnemyUpdate(bracketSize)
	if not OPT.ButtonShowGuildGroup[bracketSize] then return end
	if not BattlegroundTargets_Options.Summary[bracketSize] then return end

	-- build table from current bracketSize
	local coun0t = {}
	for i = 1, bracketSize do
		local grpNum = testGroupNum[i]
		if grpNum then
			if not coun0t[grpNum] then
				coun0t[grpNum] = 1
			else
				coun0t[grpNum] = coun0t[grpNum] + 1
			end
		end
	end

	-- build table with guildCount as key and number of groups with same membersize as value
	local count = {}
	for _, guildCount in pairs(coun0t) do
		if not count[guildCount] then
			count[guildCount] = 1
		else
			count[guildCount] = count[guildCount] + 1
		end
	end

	-- prepare table for sorting
	local i = 1
	local count2 = {}
	for guildCount, guildNum in pairs(count) do
		count2[i] = {}
		count2[i].count = guildCount
		count2[i].total = guildNum
		i = i + 1
	end

	-- sort
	table_sort(count2, guildgroup_sortfunc)

	-- display
	for i = 1, 7 do
		if count2[i] then
			GVAR.GuildGroupSummaryEnemy[i].Text:SetText(count2[i].count..": "..count2[i].total.."x")
		else
			GVAR.GuildGroupSummaryEnemy[i].Text:SetText("")
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CopySettings(sourceSize)
	local destinationSize = 10
	if sourceSize == 10 then
		destinationSize = 15
	end

	BattlegroundTargets_Options.LayoutTH[destinationSize]                 = BattlegroundTargets_Options.LayoutTH[sourceSize]
	BattlegroundTargets_Options.LayoutSpace[destinationSize]              = BattlegroundTargets_Options.LayoutSpace[sourceSize]
	BattlegroundTargets_Options.Summary[destinationSize]                  = BattlegroundTargets_Options.Summary[sourceSize]
	BattlegroundTargets_Options.SummaryScaleRole[destinationSize]         = BattlegroundTargets_Options.SummaryScaleRole[sourceSize]
	BattlegroundTargets_Options.SummaryScaleGuildGroup[destinationSize]   = BattlegroundTargets_Options.SummaryScaleGuildGroup[sourceSize]

	BattlegroundTargets_Options.ButtonShowRole[destinationSize]           = BattlegroundTargets_Options.ButtonShowRole[sourceSize]
	                        OPT.ButtonShowRole[destinationSize]           =                         OPT.ButtonShowRole[sourceSize]
	BattlegroundTargets_Options.ButtonShowSpec[destinationSize]           = BattlegroundTargets_Options.ButtonShowSpec[sourceSize]
	                        OPT.ButtonShowSpec[destinationSize]           =                         OPT.ButtonShowSpec[sourceSize]
	BattlegroundTargets_Options.ButtonClassIcon[destinationSize]          = BattlegroundTargets_Options.ButtonClassIcon[sourceSize]
	                        OPT.ButtonClassIcon[destinationSize]          =                         OPT.ButtonClassIcon[sourceSize]
	BattlegroundTargets_Options.ButtonShowLeader[destinationSize]         = BattlegroundTargets_Options.ButtonShowLeader[sourceSize]
	                        OPT.ButtonShowLeader[destinationSize]         =                         OPT.ButtonShowLeader[sourceSize]
	BattlegroundTargets_Options.ButtonHideRealm[destinationSize]          = BattlegroundTargets_Options.ButtonHideRealm[sourceSize]
	                        OPT.ButtonHideRealm[destinationSize]          =                         OPT.ButtonHideRealm[sourceSize]
	BattlegroundTargets_Options.ButtonShowGuildGroup[destinationSize]     = BattlegroundTargets_Options.ButtonShowGuildGroup[sourceSize]
	                        OPT.ButtonShowGuildGroup[destinationSize]     =                         OPT.ButtonShowGuildGroup[sourceSize]
	BattlegroundTargets_Options.ButtonGuildGroupPosition[destinationSize] = BattlegroundTargets_Options.ButtonGuildGroupPosition[sourceSize]
	                        OPT.ButtonGuildGroupPosition[destinationSize] =                         OPT.ButtonGuildGroupPosition[sourceSize]
	BattlegroundTargets_Options.ButtonShowTarget[destinationSize]         = BattlegroundTargets_Options.ButtonShowTarget[sourceSize]
	                        OPT.ButtonShowTarget[destinationSize]         =                         OPT.ButtonShowTarget[sourceSize]
	BattlegroundTargets_Options.ButtonTargetScale[destinationSize]        = BattlegroundTargets_Options.ButtonTargetScale[sourceSize]
	                        OPT.ButtonTargetScale[destinationSize]        =                         OPT.ButtonTargetScale[sourceSize]
	BattlegroundTargets_Options.ButtonTargetPosition[destinationSize]     = BattlegroundTargets_Options.ButtonTargetPosition[sourceSize]
	                        OPT.ButtonTargetPosition[destinationSize]     =                         OPT.ButtonTargetPosition[sourceSize]
	BattlegroundTargets_Options.ButtonShowTargetCount[destinationSize]    = BattlegroundTargets_Options.ButtonShowTargetCount[sourceSize]
	                        OPT.ButtonShowTargetCount[destinationSize]    =                         OPT.ButtonShowTargetCount[sourceSize]
	BattlegroundTargets_Options.ButtonShowFocus[destinationSize]          = BattlegroundTargets_Options.ButtonShowFocus[sourceSize]
	                        OPT.ButtonShowFocus[destinationSize]          =                         OPT.ButtonShowFocus[sourceSize]
	BattlegroundTargets_Options.ButtonFocusScale[destinationSize]         = BattlegroundTargets_Options.ButtonFocusScale[sourceSize]
	                        OPT.ButtonFocusScale[destinationSize]         =                         OPT.ButtonFocusScale[sourceSize]
	BattlegroundTargets_Options.ButtonFocusPosition[destinationSize]      = BattlegroundTargets_Options.ButtonFocusPosition[sourceSize]
	                        OPT.ButtonFocusPosition[destinationSize]      =                         OPT.ButtonFocusPosition[sourceSize]
	BattlegroundTargets_Options.ButtonShowFlag[destinationSize]           = BattlegroundTargets_Options.ButtonShowFlag[sourceSize]
	                        OPT.ButtonShowFlag[destinationSize]           =                         OPT.ButtonShowFlag[sourceSize]
	BattlegroundTargets_Options.ButtonFlagScale[destinationSize]          = BattlegroundTargets_Options.ButtonFlagScale[sourceSize]
	                        OPT.ButtonFlagScale[destinationSize]          =                         OPT.ButtonFlagScale[sourceSize]
	BattlegroundTargets_Options.ButtonFlagPosition[destinationSize]       = BattlegroundTargets_Options.ButtonFlagPosition[sourceSize]
	                        OPT.ButtonFlagPosition[destinationSize]       =                         OPT.ButtonFlagPosition[sourceSize]
	BattlegroundTargets_Options.ButtonShowAssist[destinationSize]         = BattlegroundTargets_Options.ButtonShowAssist[sourceSize]
	                        OPT.ButtonShowAssist[destinationSize]         =                         OPT.ButtonShowAssist[sourceSize]
	BattlegroundTargets_Options.ButtonAssistScale[destinationSize]        = BattlegroundTargets_Options.ButtonAssistScale[sourceSize]
	                        OPT.ButtonAssistScale[destinationSize]        =                         OPT.ButtonAssistScale[sourceSize]
	BattlegroundTargets_Options.ButtonAssistPosition[destinationSize]     = BattlegroundTargets_Options.ButtonAssistPosition[sourceSize]
	                        OPT.ButtonAssistPosition[destinationSize]     =                         OPT.ButtonAssistPosition[sourceSize]
	BattlegroundTargets_Options.ButtonShowHealthBar[destinationSize]      = BattlegroundTargets_Options.ButtonShowHealthBar[sourceSize]
	                        OPT.ButtonShowHealthBar[destinationSize]      =                         OPT.ButtonShowHealthBar[sourceSize]
	BattlegroundTargets_Options.ButtonShowHealthText[destinationSize]     = BattlegroundTargets_Options.ButtonShowHealthText[sourceSize]
	                        OPT.ButtonShowHealthText[destinationSize]     =                         OPT.ButtonShowHealthText[sourceSize]
	BattlegroundTargets_Options.ButtonRangeCheck[destinationSize]         = BattlegroundTargets_Options.ButtonRangeCheck[sourceSize]
	                        OPT.ButtonRangeCheck[destinationSize]         =                         OPT.ButtonRangeCheck[sourceSize]
	BattlegroundTargets_Options.ButtonTypeRangeCheck[destinationSize]     = BattlegroundTargets_Options.ButtonTypeRangeCheck[sourceSize]
	                        OPT.ButtonTypeRangeCheck[destinationSize]     =                         OPT.ButtonTypeRangeCheck[sourceSize]
	BattlegroundTargets_Options.ButtonRangeDisplay[destinationSize]       = BattlegroundTargets_Options.ButtonRangeDisplay[sourceSize]
	                        OPT.ButtonRangeDisplay[destinationSize]       =                         OPT.ButtonRangeDisplay[sourceSize]
	BattlegroundTargets_Options.ButtonSortBy[destinationSize]             = BattlegroundTargets_Options.ButtonSortBy[sourceSize]
	                        OPT.ButtonSortBy[destinationSize]             =                         OPT.ButtonSortBy[sourceSize]
	BattlegroundTargets_Options.ButtonSortDetail[destinationSize]         = BattlegroundTargets_Options.ButtonSortDetail[sourceSize]
	                        OPT.ButtonSortDetail[destinationSize]         =                         OPT.ButtonSortDetail[sourceSize]
	BattlegroundTargets_Options.ButtonFontSize[destinationSize]           = BattlegroundTargets_Options.ButtonFontSize[sourceSize]
	                        OPT.ButtonFontSize[destinationSize]           =                         OPT.ButtonFontSize[sourceSize]
	BattlegroundTargets_Options.ButtonScale[destinationSize]              = BattlegroundTargets_Options.ButtonScale[sourceSize]
	                        OPT.ButtonScale[destinationSize]              =                         OPT.ButtonScale[sourceSize]
	BattlegroundTargets_Options.ButtonWidth[destinationSize]              = BattlegroundTargets_Options.ButtonWidth[sourceSize]
	                        OPT.ButtonWidth[destinationSize]              =                         OPT.ButtonWidth[sourceSize]
	BattlegroundTargets_Options.ButtonHeight[destinationSize]             = BattlegroundTargets_Options.ButtonHeight[sourceSize]
	                        OPT.ButtonHeight[destinationSize]             =                         OPT.ButtonHeight[sourceSize]

	if destinationSize == 10 then
		testSize = 10
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, true)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, nil)
		BattlegroundTargets:CheckForEnabledBracket(testSize)
		if BattlegroundTargets_Options.EnableBracket[testSize] then
			BattlegroundTargets:ShuffleSizeCheck(testSize)
			BattlegroundTargets:ConfigGuildGroupFriendUpdate(testSize)
			BattlegroundTargets:EnableConfigMode()
		else
			BattlegroundTargets:DisableConfigMode()
		end
	else
		testSize = 15
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, true)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, nil)
		BattlegroundTargets:CheckForEnabledBracket(testSize)
		if BattlegroundTargets_Options.EnableBracket[testSize] then
			BattlegroundTargets:ShuffleSizeCheck(testSize)
			BattlegroundTargets:ConfigGuildGroupFriendUpdate(testSize)
			BattlegroundTargets:EnableConfigMode()
		else
			BattlegroundTargets:DisableConfigMode()
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
local sortfunc13 = function(a, b) -- ROLE / CLASS / NAME | 13
	if a.talentSpec == b.talentSpec then
		if class_BlizzSort[ a.classToken ] == class_BlizzSort[ b.classToken ] then
			if a.name < b.name then return true end
		elseif class_BlizzSort[ a.classToken ] < class_BlizzSort[ b.classToken ] then return true end
	elseif a.talentSpec < b.talentSpec then return true end
end
local sortfunc11 = function(a, b) -- ROLE / CLASS / NAME | 11
	if a.talentSpec == b.talentSpec then
		if class_LocaSort[ a.classToken ] == class_LocaSort[ b.classToken ] then
			if a.name < b.name then return true end
		elseif class_LocaSort[ a.classToken ] < class_LocaSort[ b.classToken ] then return true end
	elseif a.talentSpec < b.talentSpec then return true end
end
local sortfunc12 = function(a, b) -- ROLE / CLASS / NAME | 12
	if a.talentSpec == b.talentSpec then
		if a.classToken == b.classToken then
			if a.name < b.name then return true end
		elseif a.classToken < b.classToken then return true end
	elseif a.talentSpec < b.talentSpec then return true end
end
local sortfunc2 = function(a, b) -- ROLE / NAME | 2
	if a.talentSpec == b.talentSpec then
		if a.name < b.name then return true end
	elseif a.talentSpec < b.talentSpec then return true end
end
local sortfunc33 = function(a, b) -- CLASS / ROLE / NAME | 33
	if class_BlizzSort[ a.classToken ] == class_BlizzSort[ b.classToken ] then
		if a.talentSpec == b.talentSpec then
			if a.name < b.name then return true end
		elseif a.talentSpec < b.talentSpec then return true end
	elseif class_BlizzSort[ a.classToken ] < class_BlizzSort[ b.classToken ] then return true end
end
local sortfunc31 = function(a, b) -- CLASS / ROLE / NAME | 31
	if class_LocaSort[ a.classToken ] == class_LocaSort[ b.classToken ] then
		if a.talentSpec == b.talentSpec then
			if a.name < b.name then return true end
		elseif a.talentSpec < b.talentSpec then return true end
	elseif class_LocaSort[ a.classToken ] < class_LocaSort[ b.classToken ] then return true end
end
local sortfunc32 = function(a, b) -- CLASS / ROLE / NAME | 32
	if a.classToken == b.classToken then
		if a.talentSpec == b.talentSpec then
			if a.name < b.name then return true end
		elseif a.talentSpec < b.talentSpec then return true end
	elseif a.classToken < b.classToken then return true end
end
local sortfunc43 = function(a, b) -- CLASS / NAME | 43
	if class_BlizzSort[ a.classToken ] == class_BlizzSort[ b.classToken ] then
		if a.name < b.name then return true end
	elseif class_BlizzSort[ a.classToken ] < class_BlizzSort[ b.classToken ] then return true end
end
local sortfunc41 = function(a, b) -- CLASS / NAME | 41
	if class_LocaSort[ a.classToken ] == class_LocaSort[ b.classToken ] then
		if a.name < b.name then return true end
	elseif class_LocaSort[ a.classToken ] < class_LocaSort[ b.classToken ] then return true end
end
local sortfunc42 = function(a, b) -- CLASS / NAME | 42
	if a.classToken == b.classToken then
		if a.name < b.name then return true end
	elseif a.classToken < b.classToken then return true end
end
local sortfunc5 = function(a, b) -- NAME | 5
	if a.name < b.name then return true end
end

function BattlegroundTargets:MainDataUpdate()
	local ButtonSortBy = OPT.ButtonSortBy[currentSize]
	local ButtonSortDetail = OPT.ButtonSortDetail[currentSize]
	if ButtonSortBy == 1 then
		if ButtonSortDetail == 3 then
			table_sort(ENEMY_Data, sortfunc13) -- ROLE / CLASS / NAME | 13
		elseif ButtonSortDetail == 1 then
			table_sort(ENEMY_Data, sortfunc11) -- ROLE / CLASS / NAME | 11
		else
			table_sort(ENEMY_Data, sortfunc12) -- ROLE / CLASS / NAME | 12
		end
	elseif ButtonSortBy == 2 then
		table_sort(ENEMY_Data, sortfunc2) -- ROLE / NAME | 2
	elseif ButtonSortBy == 3 then
		if ButtonSortDetail == 3 then
			table_sort(ENEMY_Data, sortfunc33) -- CLASS / ROLE / NAME | 33
		elseif ButtonSortDetail == 1 then
			table_sort(ENEMY_Data, sortfunc31) -- CLASS / ROLE / NAME | 31
		else
			table_sort(ENEMY_Data, sortfunc32) -- CLASS / ROLE / NAME | 32
		end
	elseif ButtonSortBy == 4 then
		if ButtonSortDetail == 3 then
			table_sort(ENEMY_Data, sortfunc43) -- CLASS / NAME | 43
		elseif ButtonSortDetail == 1 then
			table_sort(ENEMY_Data, sortfunc41) -- CLASS / NAME | 41
		else
			table_sort(ENEMY_Data, sortfunc42) -- CLASS / NAME | 42
		end
	else
		table_sort(ENEMY_Data, sortfunc5) -- NAME | 5
	end

	local ButtonShowSpec        = OPT.ButtonShowSpec[currentSize]
	local ButtonClassIcon       = OPT.ButtonClassIcon[currentSize]
	local ButtonShowLeader      = OPT.ButtonShowLeader[currentSize]
	local ButtonHideRealm       = OPT.ButtonHideRealm[currentSize]
	local ButtonShowGuildGroup  = OPT.ButtonShowGuildGroup[currentSize]
	local ButtonShowTargetCount = OPT.ButtonShowTargetCount[currentSize]
	local ButtonShowHealthBar   = OPT.ButtonShowHealthBar[currentSize]
	local ButtonShowHealthText  = OPT.ButtonShowHealthText[currentSize]
	local ButtonShowTarget      = OPT.ButtonShowTarget[currentSize]
	local ButtonShowFocus       = OPT.ButtonShowFocus[currentSize]
	local ButtonShowFlag        = OPT.ButtonShowFlag[currentSize]
	local ButtonShowAssist      = OPT.ButtonShowAssist[currentSize]
	local ButtonRangeCheck      = OPT.ButtonRangeCheck[currentSize]

	table_wipe(ENEMY_Name2Button)
	table_wipe(ENEMY_Names4Flag)
	for i = 1, currentSize do
		if ENEMY_Data[i] then
			local GVAR_TargetButton = GVAR.TargetButton[i]

			local qname       = ENEMY_Data[i].name
			local qclassToken = ENEMY_Data[i].classToken
			local qspecNum    = ENEMY_Data[i].specNum
			local qtalentSpec = ENEMY_Data[i].talentSpec

			ENEMY_Name2Button[qname] = i
			GVAR_TargetButton.buttonNum = i

			local colR = classcolors[qclassToken].r
			local colG = classcolors[qclassToken].g
			local colB = classcolors[qclassToken].b
			GVAR_TargetButton.colR  = colR
			GVAR_TargetButton.colG  = colG
			GVAR_TargetButton.colB  = colB
			GVAR_TargetButton.colR5 = colR*0.5
			GVAR_TargetButton.colG5 = colG*0.5
			GVAR_TargetButton.colB5 = colB*0.5
			GVAR_TargetButton.ClassColorBackground:SetTexture(GVAR_TargetButton.colR5, GVAR_TargetButton.colG5, GVAR_TargetButton.colB5, 1)
			GVAR_TargetButton.HealthBar:SetTexture(colR, colG, colB, 1)

			GVAR_TargetButton.RoleTexture:SetTexCoord(Textures.RoleIcon[qtalentSpec][1], Textures.RoleIcon[qtalentSpec][2], Textures.RoleIcon[qtalentSpec][3], Textures.RoleIcon[qtalentSpec][4])

			local onlyname = qname
			if ButtonShowFlag or ButtonHideRealm then
				if string_find(qname, "-", 1, true) then
					onlyname = string_match(qname, "(.-)%-(.*)$")
				end
				ENEMY_Names4Flag[onlyname] = i
			end

			if ButtonHideRealm then
				if isLowLevel then -- LVLCHK
					GVAR_TargetButton.name4button = onlyname
				end
				if isLowLevel and ENEMY_Name2Level[qname] then
					GVAR_TargetButton.Name:SetText(ENEMY_Name2Level[qname].." "..onlyname)
				else
					GVAR_TargetButton.Name:SetText(onlyname)
				end
			else
				if isLowLevel then
					GVAR_TargetButton.name4button = qname
				end
				if isLowLevel and ENEMY_Name2Level[qname] then
					GVAR_TargetButton.Name:SetText(ENEMY_Name2Level[qname].." "..qname)
				else
					GVAR_TargetButton.Name:SetText(qname)
				end
			end

			if not inCombat or not InCombatLockdown() then
				GVAR_TargetButton:SetAttribute("macrotext1", "/targetexact "..qname)
				GVAR_TargetButton:SetAttribute("macrotext2", "/targetexact "..qname.."\n/focus\n/targetlasttarget")
			end

			if ButtonRangeCheck then
				GVAR_TargetButton.RangeTexture:SetTexture(colR, colG, colB, 1)
			end

			if ButtonShowSpec then
				GVAR_TargetButton.SpecTexture:SetTexture(classes[qclassToken].spec[qspecNum].icon)
			end

			if ButtonClassIcon then
				GVAR_TargetButton.ClassTexture:SetTexCoord(classes[qclassToken].coords[1], classes[qclassToken].coords[2], classes[qclassToken].coords[3], classes[qclassToken].coords[4])
			end

			local nameE = ENEMY_Names[qname]
			local percentE = ENEMY_Name2Percent[qname]

			if ButtonShowTargetCount then
				if nameE then
					GVAR_TargetButton.TargetCount:SetText(nameE)
				else
					GVAR_TargetButton.TargetCount:SetText("0")
				end
			end

			if ButtonShowHealthBar or ButtonShowHealthText then
				if nameE and percentE then
					if ButtonShowHealthBar then
						local width = healthBarWidth * (percentE / 100)
						width = math_max(0.01, width)
						width = math_min(healthBarWidth, width)
						GVAR_TargetButton.HealthBar:SetWidth(width)
					end
					if ButtonShowHealthText then
						GVAR_TargetButton.HealthText:SetText(percentE)
					end
				end
			end

			if ButtonShowTarget and targetName then
				if qname == targetName then
					GVAR_TargetButton.HighlightT:SetTexture(0.5, 0.5, 0.5, 1)
					GVAR_TargetButton.HighlightR:SetTexture(0.5, 0.5, 0.5, 1)
					GVAR_TargetButton.HighlightB:SetTexture(0.5, 0.5, 0.5, 1)
					GVAR_TargetButton.HighlightL:SetTexture(0.5, 0.5, 0.5, 1)
					GVAR_TargetButton.TargetTexture:SetAlpha(1)
				else
					GVAR_TargetButton.HighlightT:SetTexture(0, 0, 0, 1)
					GVAR_TargetButton.HighlightR:SetTexture(0, 0, 0, 1)
					GVAR_TargetButton.HighlightB:SetTexture(0, 0, 0, 1)
					GVAR_TargetButton.HighlightL:SetTexture(0, 0, 0, 1)
					GVAR_TargetButton.TargetTexture:SetAlpha(0)
				end
			end

			if ButtonShowFocus and focusName then
				if qname == focusName then
					GVAR_TargetButton.FocusTexture:SetAlpha(1)
				else
					GVAR_TargetButton.FocusTexture:SetAlpha(0)
				end
			end

			if ButtonShowFlag and hasFlag then
				if qname == hasFlag then
					GVAR_TargetButton.FlagTexture:SetAlpha(1)
					BattlegroundTargets:SetFlagDebuff(GVAR_TargetButton)
				else
					GVAR_TargetButton.FlagTexture:SetAlpha(0)
					GVAR_TargetButton.FlagDebuff:SetText("")
				end
			end

			if ButtonShowAssist and assistTargetName then
				if qname == assistTargetName then
					GVAR_TargetButton.AssistTexture:SetAlpha(1)
				else
					GVAR_TargetButton.AssistTexture:SetAlpha(0)
				end
			end

			if ButtonShowLeader and isLeader then
				if qname == isLeader then
					GVAR_TargetButton.LeaderTexture:SetAlpha(0.75)
				else
					GVAR_TargetButton.LeaderTexture:SetAlpha(0)
				end
			end

			if ButtonShowGuildGroup then -- GLDGRP
				local num = ENEMY_GroupNum[qname] or 0
				if num > 0 then
					local texNum, colNum = ggTexCol(num)
					local tex = guildGrpTex[texNum]
					local col = guildGrpCol[colNum]
					GVAR_TargetButton.GuildGroup:SetTexCoord(tex[1], tex[2], tex[3], tex[4]) -- GRP_TEX
					GVAR_TargetButton.GuildGroup:SetVertexColor(col[1], col[2], col[3])
				else
					GVAR_TargetButton.GuildGroup:SetTexCoord(0, 0, 0, 0)
				end
			end

		else
			local GVAR_TargetButton = GVAR.TargetButton[i]
			BattlegroundTargets:ClearConfigButtonValues(GVAR_TargetButton)
			if not inCombat or not InCombatLockdown() then
				GVAR_TargetButton:SetAttribute("macrotext1", "")
				GVAR_TargetButton:SetAttribute("macrotext2", "")
			end
		end
	end

	if isConfig then
		if BattlegroundTargets_Options.Summary[currentSize] then
			FRIEND_Roles = {0,0,0,0}
			ENEMY_Roles = {0,0,0,0}
			for i = 1, currentSize do
				if ENEMY_Data[i] then
					local role = ENEMY_Data[i].talentSpec
					ENEMY_Roles[role] = ENEMY_Roles[role] + 1
				end
			end
			GVAR.Summary.HealerFriend:SetText(FRIEND_Roles[1]) -- HEAL   FRIEND
			GVAR.Summary.TankFriend:SetText(FRIEND_Roles[2])   -- TANK   FRIEND
			GVAR.Summary.DamageFriend:SetText(FRIEND_Roles[3]) -- DAMAGE FRIEND
			GVAR.Summary.HealerEnemy:SetText(ENEMY_Roles[1])   -- HEAL   ENEMY
			GVAR.Summary.TankEnemy:SetText(ENEMY_Roles[2])     -- TANK   ENEMY
			GVAR.Summary.DamageEnemy:SetText(ENEMY_Roles[3])   -- DAMAGE ENEMY
		end
		if isLowLevel then -- LVLCHK
			for i = 1, currentSize do
				local GVAR_TargetButton = GVAR.TargetButton[i]
				GVAR_TargetButton.Name:SetText(playerLevel.." "..GVAR_TargetButton.name4button)
			end
		end
		return
	end

	if ButtonRangeCheck then
		local curTime = GetTime()
		if range_CL_DisplayThrottle + range_CL_DisplayFrequency > curTime then return end
		range_CL_DisplayThrottle = curTime
		BattlegroundTargets:UpdateRange(curTime)
	end

	-- GLDGRP
	if ButtonShowGuildGroup then
		-- check if a guild group member left battleground
		local doUpdate
		for enemyName, guildName in pairs(ENEMY_Guild) do
			if not ENEMY_Name2Button[enemyName] and ENEMY_GroupNum[enemyName] > 0 then
				ENEMY_GuildCount[guildName] = ENEMY_GuildCount[guildName] - 1
				doUpdate = true

				if ENEMY_GuildCount[guildName] < 2 then
					for enemyName2, guildName2 in pairs(ENEMY_Guild) do
						if guildName == guildName2 then
							ENEMY_GroupNum[enemyName2] = 0

							local ENEMY_Name2Button = ENEMY_Name2Button[enemyName2]
							if ENEMY_Name2Button then
								local GVAR_TargetButton = GVAR.TargetButton[ENEMY_Name2Button]
								if GVAR_TargetButton then
									GVAR_TargetButton.GuildGroup:SetTexCoord(0, 0, 0, 0)
								end
							end

						end
					end
				end

			end
		end
		if doUpdate then
			BattlegroundTargets:GuildGroupEnemyUpdate()
		end
		if groupMembers == 0 or groupMemChk < groupMembers then
			BattlegroundTargets:GuildGroupFriendUpdate()
		end
	end

	-- SUMMARY
	if BattlegroundTargets_Options.Summary[currentSize] then
		GVAR.Summary.HealerFriend:SetText(FRIEND_Roles[1]) -- HEAL   FRIEND
		GVAR.Summary.TankFriend:SetText(FRIEND_Roles[2])   -- TANK   FRIEND
		GVAR.Summary.DamageFriend:SetText(FRIEND_Roles[3]) -- DAMAGE FRIEND
		GVAR.Summary.HealerEnemy:SetText(ENEMY_Roles[1])   -- HEAL   ENEMY
		GVAR.Summary.TankEnemy:SetText(ENEMY_Roles[2])     -- TANK   ENEMY
		GVAR.Summary.DamageEnemy:SetText(ENEMY_Roles[3])   -- DAMAGE ENEMY
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:BattlefieldScoreUpdate(forceUpdate)
	local curTime = GetTime()
	if inCombat or InCombatLockdown() then
		if curTime - latestScoreUpdate >= latestScoreWarning then
			GVAR.ScoreUpdateTexture:Show()
		else
			GVAR.ScoreUpdateTexture:Hide()
		end
		reCheckScore = true
		return
	end

	if not forceUpdate then
		if scoreUpdateThrottle + scoreUpdateFrequency > curTime then return end
		scoreUpdateThrottle = curTime
	end

	local wssf = WorldStateScoreFrame -- WorldStateScoreFrameTab_OnClick (WorldStateFrame.lua) | PanelTemplates_SetTab (UIPanelTemplates.lua) | Button WorldStateScoreFrameTab1/2/3 (WorldStateFrame.xml)
	if wssf and wssf:IsShown() and wssf.selectedTab and wssf.selectedTab > 1 then return end

	scoreUpdateCount = scoreUpdateCount + 1
	if scoreUpdateCount > 20 then
		scoreUpdateFrequency = 5
	end
	reCheckScore = nil
	latestScoreUpdate = curTime
	GVAR.ScoreUpdateTexture:Hide()

	SetBattlefieldScoreFaction()

	table_wipe(ENEMY_Data)
	table_wipe(FRIEND_Names)
	ENEMY_Roles = {0,0,0,0} -- SUMMARY
	FRIEND_Roles = {0,0,0,0}

	local x = 1
	for index = 1, GetNumBattlefieldScores() do
		local name, _, _, _, _, faction, race, _, classToken, _, _, _, _, _, _, talentSpec = GetBattlefieldScore(index)
		if name then
			if faction == oppositeFactionBG then

				if oppositeFactionREAL == nil and race then
					local n = RNA[race]
					if n == 0 then -- summary_flag_texture
						GVAR.Summary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
						oppositeFactionREAL = n
					elseif n == 1 then
						GVAR.Summary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
						oppositeFactionREAL = n
					end
				end

				--if race then -- TEST
				--	if not BattlegroundTargets_Options.TesT then BattlegroundTargets_Options.TesT = {} end
				--	if not BattlegroundTargets_Options.TesT[locale] then BattlegroundTargets_Options.TesT[locale] = {} end
				--	if playerFactionDEF == 0 then
				--		BattlegroundTargets_Options.TesT[locale][race] = "ALLIANCE"
				--	else
				--		BattlegroundTargets_Options.TesT[locale][race] = "HORDE"
				--	end
				--end

				local role = 4
				local spec = 4
				local class = "ZZZFAILURE"
				if classToken then
					class = classToken
					if talentSpec then
						local token = TLT[classToken]
						if token then
							if talentSpec == token[1] then
								role = classes[classToken].spec[1].role
								spec = 1
							elseif talentSpec == token[2] then
								role = classes[classToken].spec[2].role
								spec = 2
							elseif talentSpec == token[3] then
								role = classes[classToken].spec[3].role
								spec = 3
							end
						end
					end
				end
				ENEMY_Roles[role] = ENEMY_Roles[role] + 1 -- SUMMARY

				ENEMY_Data[x] = {}
				ENEMY_Data[x].name = name
				ENEMY_Data[x].classToken = class
				ENEMY_Data[x].specNum = spec
				ENEMY_Data[x].talentSpec = role
				x = x + 1

				if not ENEMY_Names[name] then
					ENEMY_Names[name] = 0
				end

			else

				--if race then -- TEST
				--	if not BattlegroundTargets_Options.TesT then BattlegroundTargets_Options.TesT = {} end
				--	if not BattlegroundTargets_Options.TesT[locale] then BattlegroundTargets_Options.TesT[locale] = {} end
				--	if playerFactionDEF == 0 then
				--		BattlegroundTargets_Options.TesT[locale][race] = "zzHORDE"
				--	else
				--		BattlegroundTargets_Options.TesT[locale][race] = "zzALLIANCE"
				--	end
				--end

				FRIEND_Names[name] = 1

				local role = 4
				--local spec = 4
				local class = "ZZZFAILURE"
				if classToken then
					class = classToken
					if talentSpec then
						local token = TLT[classToken]
						if token then
							if talentSpec == token[1] then
								role = classes[classToken].spec[1].role
								--spec = 1
							elseif talentSpec == token[2] then
								role = classes[classToken].spec[2].role
								--spec = 2
							elseif talentSpec == token[3] then
								role = classes[classToken].spec[3].role
								--spec = 3
							end
						end
					end
				end
				FRIEND_Roles[role] = FRIEND_Roles[role] + 1 -- SUMMARY

			end
		end
	end

	if ENEMY_Data[1] then
		BattlegroundTargets:MainDataUpdate()

		if not flagflag and isFlagBG > 0 then
			if OPT.ButtonShowFlag[currentSize] then
				BattlegroundTargets:CheckFlagCarrierSTART()
			end
		end
	end

	if reSizeCheck >= 10 then return end

	local queueStatus, queueMapName, bgName
	for i=1, GetMaxBattlefieldID() do
		queueStatus, queueMapName = GetBattlefieldStatus(i)
		if queueStatus == "active" then
			bgName = queueMapName
			break
		end
	end

	if BGN[bgName] then
		BattlegroundTargets:BattlefieldCheck()
	else
		local zone = GetRealZoneText()
		if BGN[zone] then
			BattlegroundTargets:BattlefieldCheck()
		else
			reSizeCheck = reSizeCheck + 1
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckFlagCarrierCHECK(unit, targetName) -- FLAGSPY
	if not ENEMY_FirstFlagCheck[targetName] then return end

	-- enemy buff & debuff check
	for i = 1, 40 do
		local _, _, _, _, _, _, _, _, _, _, spellId = UnitBuff(unit, i) -- name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3 = UnitAura("unit", index or "name"[, "rank"[, "filter"]])
		if not spellId then break end
		if flagIDs[spellId] then
			hasFlag = targetName
			flagDebuff = 0
			flags = flags + 1

			for j = 1, 40 do
				local _, _, _, count, _, _, _, _, _, _, spellId = UnitDebuff(unit, j)
				if not spellId then break end
				if debuffIDs[spellId] then
					flagDebuff = count
				end
			end

			for j = 1, currentSize do
				local GVAR_TargetButton = GVAR.TargetButton[j]
				GVAR_TargetButton.FlagTexture:SetAlpha(0)
				GVAR_TargetButton.FlagDebuff:SetText("")
			end
			local button = ENEMY_Name2Button[targetName]
			if button then
				local GVAR_TargetButton = GVAR.TargetButton[button]
				if GVAR_TargetButton then
					GVAR_TargetButton.FlagTexture:SetAlpha(1)
					BattlegroundTargets:SetFlagDebuff(GVAR_TargetButton)
				end
			end

			BattlegroundTargets:CheckFlagCarrierEND()
			return
		end
	end

	ENEMY_FirstFlagCheck[targetName] = nil

	local x = 0
	for k in pairs(ENEMY_FirstFlagCheck) do
		x = x + 1
	end
	if x == 0 then
		BattlegroundTargets:CheckFlagCarrierEND()
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckFlagCarrierSTART() -- FLAGSPY
	flagCHK = true
	flagflag = true

	table_wipe(ENEMY_FirstFlagCheck)
	for i = 1, #ENEMY_Data do
		ENEMY_FirstFlagCheck[ENEMY_Data[i].name] = 1
	end

	-- friend buff & debuff check
	local function chk()
		for num = 1, GetNumGroupMembers() do -- TODO_MoP
			local unitID = "raid"..num
			for i = 1, 40 do
				local _, _, _, _, _, _, _, _, _, _, spellId = UnitBuff(unitID, i)
				if not spellId then break end
				if flagIDs[spellId] then
					flagDebuff = 0
					flags = 1
					for j = 1, 40 do
						local _, _, _, count, _, _, _, _, _, _, spellId = UnitDebuff(unitID, j)
						if not spellId then break end
						if debuffIDs[spellId] then
							flagDebuff = count
							return
						end
					end
					return
				end
			end
		end
	end
	chk()

	BattlegroundTargets:RegisterEvent("UNIT_TARGET")
	BattlegroundTargets:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	BattlegroundTargets:RegisterEvent("PLAYER_TARGET_CHANGED")
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckFlagCarrierEND() -- FLAGSPY
	flagCHK = nil
	flagflag = true
	table_wipe(ENEMY_FirstFlagCheck)
	if not OPT.ButtonShowHealthBar[currentSize] and
	   not OPT.ButtonShowHealthText[currentSize] and
	   not OPT.ButtonShowTargetCount[currentSize] and
	   not OPT.ButtonShowAssist[currentSize] and
	   not OPT.ButtonShowLeader[currentSize] and
	   not OPT.ButtonShowGuildGroup[currentSize] and
	   (not OPT.ButtonRangeCheck[currentSize] or (OPT.ButtonRangeCheck[currentSize] and not OPT.ButtonTypeRangeCheck[currentSize] >= 2)) and
	   not isLowLevel -- LVLCHK
	then
		BattlegroundTargets:UnregisterEvent("UNIT_TARGET")
	end
	if not OPT.ButtonShowHealthBar[currentSize] and
	   not OPT.ButtonShowHealthText[currentSize] and
	   (not OPT.ButtonRangeCheck[currentSize] or (OPT.ButtonRangeCheck[currentSize] and not OPT.ButtonTypeRangeCheck[currentSize] >= 2))
	then
		BattlegroundTargets:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	end
	if not OPT.ButtonShowTarget[currentSize] and
	   (not OPT.ButtonRangeCheck[currentSize] or (OPT.ButtonRangeCheck[currentSize] and not OPT.ButtonTypeRangeCheck[currentSize] >= 2))
	then
		BattlegroundTargets:UnregisterEvent("PLAYER_TARGET_CHANGED")
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:BattlefieldCheck()
	if not inWorld then return end
	local _, instanceType = IsInInstance()
	if instanceType == "pvp" then
		BattlegroundTargets:IsBattleground()
	else
		BattlegroundTargets:IsNotBattleground()
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:IsBattleground()
	inBattleground = true
	isFlagBG = 0

	local queueStatus, queueMapName, bgName
	for i=1, GetMaxBattlefieldID() do
		queueStatus, queueMapName = GetBattlefieldStatus(i)
		if queueStatus == "active" then
			bgName = queueMapName
			break
		end
	end

	if BGN[bgName] then
		currentSize = bgSize[ BGN[bgName] ]
		reSizeCheck = 10
		local flagBGnum = flagBG[ BGN[bgName] ]
		if flagBGnum then
			isFlagBG = flagBGnum
		end
	else
		local zone = GetRealZoneText()
		if BGN[zone] then
			currentSize = bgSize[ BGN[zone] ]
			reSizeCheck = 10
			local flagBGnum = flagBG[ BGN[zone] ]
			if flagBGnum then
				isFlagBG = flagBGnum
			end
		else
			if reSizeCheck >= 10 then
				Print("ERROR", "unknown battleground name", locale, bgName, zone)
			end
			currentSize = 10
			reSizeCheck = reSizeCheck + 1
		end
	end

	if IsRatedBattleground() or true then  -- Support cross faction BG
		currentSize = 10
		local faction = GetBattlefieldArenaFaction()
		if faction == 0 then
			playerFactionBG   = 0 -- Horde
			oppositeFactionBG = 1 -- Alliance
		elseif faction == 1 then
			playerFactionBG   = 1 -- Alliance
			oppositeFactionBG = 0 -- Horde
		else
			Print("ERROR", "unknown battleground faction", locale, faction)
		end
	end

	if playerLevel >= maxLevel then -- LVLCHK
		isLowLevel = nil
	else
		isLowLevel = true
	end

	if inCombat or InCombatLockdown() then
		reCheckBG = true
	else
		reCheckBG = false

		if BattlegroundTargets_Options.EnableBracket[currentSize] then

			GVAR.MainFrame:Show() -- HiDE
			GVAR.MainFrame:EnableMouse(false)
			GVAR.MainFrame:SetHeight(0.001)
			GVAR.MainFrame.Movetext:Hide()
			GVAR.TargetButton[1]:SetPoint("TOPLEFT", GVAR.MainFrame, "BOTTOMLEFT", 0, -(20 / OPT.ButtonScale[currentSize]))
			GVAR.ScoreUpdateTexture:Hide()

			for i = 1, 40 do
				local GVAR_TargetButton = GVAR.TargetButton[i]
				if i < currentSize+1 then
					BattlegroundTargets:ClearConfigButtonValues(GVAR_TargetButton, 1)
					GVAR_TargetButton:Show()
				else
					GVAR_TargetButton:Hide()
				end
			end
			BattlegroundTargets:SetupButtonLayout()

			if BattlegroundTargets_Options.Summary[currentSize] then
				GVAR.Summary.HealerFriend:SetText("0")
				GVAR.Summary.TankFriend:SetText("0")
				GVAR.Summary.DamageFriend:SetText("0")
				GVAR.Summary.HealerEnemy:SetText("0")
				GVAR.Summary.TankEnemy:SetText("0")
				GVAR.Summary.DamageEnemy:SetText("0")
				if OPT.ButtonShowGuildGroup[currentSize] then
					for i = 1, 7 do
						GVAR.GuildGroupSummaryEnemy[i].Text:SetText("")
						GVAR.GuildGroupSummaryFriend[i].Text:SetText("")
					end
				end
			end

			BattlegroundTargets:BattlefieldScoreUpdate(1)

			if OPT.ButtonShowFlag[currentSize] then
				if currentSize == 10 or currentSize == 15 then

					local flagIcon -- setup_flag_texture
					if playerFactionBG ~= playerFactionDEF then
						flagIcon = "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture2" -- neutral flag
					elseif playerFactionDEF == 0 then
						if isFlagBG == 2 then
							flagIcon = "Interface\\WorldStateFrame\\AllianceFlag"
						else
							flagIcon = "Interface\\WorldStateFrame\\HordeFlag"
						end
					else
						if isFlagBG == 2 then
							flagIcon = "Interface\\WorldStateFrame\\HordeFlag"
						else
							flagIcon = "Interface\\WorldStateFrame\\AllianceFlag"
						end
					end
					for i = 1, currentSize do
						GVAR.TargetButton[i].FlagTexture:SetTexture(flagIcon)
					end

				end
			end

		else

			GVAR.MainFrame:Hide()
			for i = 1, 40 do
				GVAR.TargetButton[i]:Hide()
			end

		end

	end

	BattlegroundTargets:UnregisterEvent("PLAYER_DEAD")
	BattlegroundTargets:UnregisterEvent("PLAYER_UNGHOST")
	BattlegroundTargets:UnregisterEvent("PLAYER_ALIVE")
	BattlegroundTargets:UnregisterEvent("UNIT_HEALTH_FREQUENT")
	BattlegroundTargets:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	BattlegroundTargets:UnregisterEvent("UNIT_TARGET")
	BattlegroundTargets:UnregisterEvent("PLAYER_TARGET_CHANGED")
	BattlegroundTargets:UnregisterEvent("PLAYER_FOCUS_CHANGED")
	BattlegroundTargets:UnregisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
	BattlegroundTargets:UnregisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
	BattlegroundTargets:UnregisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
	BattlegroundTargets:UnregisterEvent(RosterUpdate) -- TODO_MoP
	BattlegroundTargets:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	BattlegroundTargets:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE")

	if BattlegroundTargets_Options.EnableBracket[currentSize] then
		BattlegroundTargets:RegisterEvent("PLAYER_DEAD")
		BattlegroundTargets:RegisterEvent("PLAYER_UNGHOST")
		BattlegroundTargets:RegisterEvent("PLAYER_ALIVE")

		if isLowLevel then -- LVLCHK
			BattlegroundTargets:RegisterEvent("UNIT_TARGET")
		end

		if OPT.ButtonShowHealthBar[currentSize] or OPT.ButtonShowHealthText[currentSize] then
			BattlegroundTargets:RegisterEvent("UNIT_TARGET")
			BattlegroundTargets:RegisterEvent("UNIT_HEALTH_FREQUENT")
			BattlegroundTargets:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		end

		if OPT.ButtonShowTargetCount[currentSize] then
			BattlegroundTargets:RegisterEvent("UNIT_TARGET")
		end

		if OPT.ButtonShowTarget[currentSize] then
			BattlegroundTargets:RegisterEvent("PLAYER_TARGET_CHANGED")
		end

		if OPT.ButtonShowFocus[currentSize] then
			BattlegroundTargets:RegisterEvent("PLAYER_FOCUS_CHANGED")
		end

		if OPT.ButtonShowFlag[currentSize] then
			if currentSize == 10 or currentSize == 15 then
				BattlegroundTargets:RegisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
				BattlegroundTargets:RegisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
				BattlegroundTargets:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
			end
		end

		if OPT.ButtonShowAssist[currentSize] then
			BattlegroundTargets:RegisterEvent(RosterUpdate) -- TODO_MoP
			BattlegroundTargets:RegisterEvent("UNIT_TARGET")
		end

		if OPT.ButtonShowLeader[currentSize] then
			BattlegroundTargets:RegisterEvent("UNIT_TARGET")
		end

		if OPT.ButtonShowGuildGroup[currentSize] then
			BattlegroundTargets:RegisterEvent(RosterUpdate) -- TODO_MoP
			BattlegroundTargets:RegisterEvent("UNIT_TARGET")
		end

		rangeSpellName = nil
		rangeMin = nil
		rangeMax = nil
		if OPT.ButtonRangeCheck[currentSize] then
			if OPT.ButtonTypeRangeCheck[currentSize] == 1 then
				BattlegroundTargets:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			elseif OPT.ButtonTypeRangeCheck[currentSize] >= 2 then

				if ranges[playerClassEN] then
					if IsSpellKnown(ranges[playerClassEN]) then
						rangeSpellName, _, _, _, _, _, _, rangeMin, rangeMax = GetSpellInfo(ranges[playerClassEN])
						if not rangeSpellName then
							Print("ERROR", "unknown spell (rangecheck)", locale, playerClassEN, "id:", ranges[playerClassEN])
						elseif (not rangeMin or not rangeMax) or (rangeMin <= 0 and rangeMax <= 0) then
							Print("ERROR", "spell min/max fail (rangecheck)", locale, rangeSpellName, rangeMin, rangeMax)
						else
							BattlegroundTargets:RegisterEvent("UNIT_HEALTH_FREQUENT")
							BattlegroundTargets:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
							BattlegroundTargets:RegisterEvent("PLAYER_TARGET_CHANGED")
							BattlegroundTargets:RegisterEvent("UNIT_TARGET")
							if OPT.ButtonTypeRangeCheck[currentSize] >= 3 then
								BattlegroundTargets:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
							end
						end
					elseif tocversion < 50000 and playerClassEN == "PALADIN" and playerLevel < 14 then -- PAL14 TODO_MoP
						Print("WARNING", playerClassEN, "Required level for class-spell based rangecheck is 14.")
					elseif tocversion >= 50000 and playerClassEN == "MONK" and playerLevel < 14 then -- MON14 TODO_MoP
						Print("WARNING", playerClassEN, "Required level for class-spell based rangecheck is 14.")
					elseif tocversion >= 50000 and playerClassEN == "ROGUE" and playerLevel < 12 then -- ROG12 TODO_MoP
						Print("WARNING", playerClassEN, "Required level for class-spell based rangecheck is 12.")
					else
						Print("ERROR", "unknown spell (rangecheck)", locale, playerClassEN, "id:", ranges[playerClassEN])
					end
				else
					Print("ERROR", "unknown class (rangecheck)", locale, playerClassEN)
				end

			end
		end

		BattlegroundTargets:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:IsNotBattleground()
	if not inBattleground and not reCheckBG then return end

	--for k, v in pairs(eventTest) do print(k, v) end -- TEST

	inBattleground = false
	reSizeCheck = 0
	oppositeFactionREAL = nil
	flagDebuff = 0
	flags = 0
	isFlagBG = 0
	flagCHK = nil
	flagflag = nil
	scoreUpdateCount = 0
	isLeader = nil
	hasFlag = nil
	reCheckBG = nil
	reCheckScore = nil
	groupMembers = 0
	groupMemChk = 0

	BattlegroundTargets:CheckPlayerLevel() -- LVLCHK

	BattlegroundTargets:UnregisterEvent("PLAYER_DEAD")
	BattlegroundTargets:UnregisterEvent("PLAYER_UNGHOST")
	BattlegroundTargets:UnregisterEvent("PLAYER_ALIVE")
	BattlegroundTargets:UnregisterEvent("UNIT_HEALTH_FREQUENT")
	BattlegroundTargets:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	BattlegroundTargets:UnregisterEvent("UNIT_TARGET")
	BattlegroundTargets:UnregisterEvent("PLAYER_TARGET_CHANGED")
	BattlegroundTargets:UnregisterEvent("PLAYER_FOCUS_CHANGED")
	BattlegroundTargets:UnregisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
	BattlegroundTargets:UnregisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
	BattlegroundTargets:UnregisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
	BattlegroundTargets:UnregisterEvent(RosterUpdate) -- TODO_MoP
	BattlegroundTargets:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	BattlegroundTargets:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE")

	if not isConfig then
		table_wipe(ENEMY_Data)
	end
	table_wipe(ENEMY_Names)
	table_wipe(ENEMY_Names4Flag)
	table_wipe(ENEMY_Name2Button)
	table_wipe(ENEMY_Name2Percent)
	table_wipe(ENEMY_Name2Range)
	table_wipe(ENEMY_Name2Level)
	table_wipe(ENEMY_Guild)
	table_wipe(ENEMY_GuildCount)
	table_wipe(ENEMY_GroupNum)
	table_wipe(FRIEND_GuildCount)
	table_wipe(FRIEND_GuildName)
	table_wipe(TARGET_Names)

	if inCombat or InCombatLockdown() then
		reCheckBG = true
	else
		reCheckBG = false

		GVAR.MainFrame:Hide()
		local flagIcon = "Interface\\WorldStateFrame\\AllianceFlag" -- setup_flag_texture
		if playerFactionDEF == 0 then
			flagIcon = "Interface\\WorldStateFrame\\HordeFlag"
		end
		for i = 1, 40 do
			local GVAR_TargetButton = GVAR.TargetButton[i]
			GVAR_TargetButton.FlagTexture:SetTexture(flagIcon)
			GVAR_TargetButton:Hide()
		end
		if playerFactionDEF == 0 then -- summary_flag_texture
			GVAR.Summary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
		else
			GVAR.Summary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckPlayerTarget()
	if isConfig then return end

	targetName, targetRealm = UnitName("target")
	if targetRealm and targetRealm ~= "" then
		targetName = targetName.."-"..targetRealm
	end

	for i = 1, currentSize do
		local GVAR_TargetButton = GVAR.TargetButton[i]
		GVAR_TargetButton.TargetTexture:SetAlpha(0)
		GVAR_TargetButton.HighlightT:SetTexture(0, 0, 0, 1)
		GVAR_TargetButton.HighlightR:SetTexture(0, 0, 0, 1)
		GVAR_TargetButton.HighlightB:SetTexture(0, 0, 0, 1)
		GVAR_TargetButton.HighlightL:SetTexture(0, 0, 0, 1)
	end
	isTarget = 0

	if not targetName then return end
	local targetButton = ENEMY_Name2Button[targetName]
	if not targetButton then return end
	local GVAR_TargetButton = GVAR.TargetButton[targetButton]
	if not GVAR_TargetButton then return end

	-- target
	if OPT.ButtonShowTarget[currentSize] then
		GVAR_TargetButton.TargetTexture:SetAlpha(1)
		GVAR_TargetButton.HighlightT:SetTexture(0.5, 0.5, 0.5, 1)
		GVAR_TargetButton.HighlightR:SetTexture(0.5, 0.5, 0.5, 1)
		GVAR_TargetButton.HighlightB:SetTexture(0.5, 0.5, 0.5, 1)
		GVAR_TargetButton.HighlightL:SetTexture(0.5, 0.5, 0.5, 1)
		isTarget = targetButton
	end

	if isDeadUpdateStop then return end
	BattlegroundTargets:CheckUnitTarget("player", targetName)
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckAssist()
	if isConfig then return end

	isAssistUnitId = nil
	isAssistName = nil
	for i = 1, GetNumGroupMembers() do -- TODO_MoP
		local name, _, _, _, _, _, _, _, _, role = GetRaidRosterInfo(i)
		if name and role and role == "MAINASSIST" then
			isAssistName = name
			isAssistUnitId = "raid"..i.."target"
			break
		end
	end

	for i = 1, currentSize do
		GVAR.TargetButton[i].AssistTexture:SetAlpha(0)
	end

	if not isAssistName then return end

	assistTargetName, assistTargetRealm = UnitName(isAssistUnitId)
	if assistTargetRealm and assistTargetRealm ~= "" then
		assistTargetName = assistTargetName.."-"..assistTargetRealm
	end

	if not assistTargetName then return end
	local assistButton = ENEMY_Name2Button[assistTargetName]
	if not assistButton then return end
	if not GVAR.TargetButton[assistButton] then return end

	-- assist_
	if OPT.ButtonShowAssist[currentSize] then
		GVAR.TargetButton[assistButton].AssistTexture:SetAlpha(1)
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckPlayerFocus()
	if isConfig then return end

	focusName, focusRealm = UnitName("focus")
	if focusRealm and focusRealm ~= "" then
		focusName = focusName.."-"..focusRealm
	end

	for i = 1, currentSize do
		GVAR.TargetButton[i].FocusTexture:SetAlpha(0)
	end

	if not focusName then return end
	local focusButton = ENEMY_Name2Button[focusName]
	if not focusButton then return end
	local GVAR_TargetButton = GVAR.TargetButton[focusButton]
	if not GVAR_TargetButton then return end

	-- focus
	if OPT.ButtonShowFocus[currentSize] then
		GVAR_TargetButton.FocusTexture:SetAlpha(1)
	end

	-- class_range (Check Player Focus)
	if rangeSpellName and OPT.ButtonTypeRangeCheck[currentSize] >= 2 then
		local curTime = GetTime()
		local Name2Range = ENEMY_Name2Range[focusName]
		if Name2Range then
			if Name2Range + range_SPELL_Frequency > curTime then return end -- ATTENTION
		end
		if IsSpellInRange(rangeSpellName, "focus") == 1 then
			ENEMY_Name2Range[focusName] = curTime
			Range_Display(true, GVAR_TargetButton, OPT.ButtonRangeDisplay[currentSize])
		else
			ENEMY_Name2Range[focusName] = nil
			Range_Display(false, GVAR_TargetButton, OPT.ButtonRangeDisplay[currentSize])
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckUnitTarget(unitID, unitName)
	if isConfig then return end

	local friendName, friendRealm, enemyID, enemyName, enemyRealm
	if not unitName then
		enemyID = unitID.."target"
		friendName, friendRealm = UnitName(unitID)
		if friendRealm and friendRealm ~= "" then
			friendName = friendName.."-"..friendRealm
		end
		enemyName, enemyRealm = UnitName(enemyID)
		if enemyRealm and enemyRealm ~= "" then
			enemyName = enemyName.."-"..enemyRealm
		end
	else -- "player"
		enemyID = "target"
		friendName = playerName
		enemyName = unitName
	end

	local curTime = GetTime()

	-- FLAGSPY
	if flagCHK and isFlagBG > 0 then
		if OPT.ButtonShowFlag[currentSize] then
			BattlegroundTargets:CheckFlagCarrierCHECK(enemyID, enemyName)
		end
	end

	-- target count
	if OPT.ButtonShowTargetCount[currentSize] then
		if curTime > targetCountForceUpdate + targetCountFrequency then
			targetCountForceUpdate = curTime
			table_wipe(TARGET_Names)
			for num = 1, GetNumGroupMembers() do -- TODO_MoP
				local uID = "raid"..num
				local fName, fRealm = UnitName(uID)
				if fName then
					if fRealm and fRealm ~= "" then
						fName = fName.."-"..fRealm
					end
					local eName, eRealm = UnitName(uID.."target")
					if eName then
						if eRealm and eRealm ~= "" then
							eName = eName.."-"..eRealm
						end
						if ENEMY_Names[eName] then
							TARGET_Names[fName] = eName
						end
					end
				end
			end
		else
			if friendName then
				if ENEMY_Names[enemyName] then
					TARGET_Names[friendName] = enemyName
				else
					TARGET_Names[friendName] = nil
				end
			end
		end
		for eName in pairs(ENEMY_Names) do
			ENEMY_Names[eName] = 0
		end
		for _, eName in pairs(TARGET_Names) do
			if ENEMY_Names[eName] then
				ENEMY_Names[eName] = ENEMY_Names[eName] + 1
			end
		end
		for i = 1, currentSize do
			if ENEMY_Data[i] then
				local count = ENEMY_Names[ ENEMY_Data[i].name ]
				if count then
					GVAR.TargetButton[i].TargetCount:SetText(count)
				end
			else
				GVAR.TargetButton[i].TargetCount:SetText("")
			end
		end
	end

	if not ENEMY_Names[enemyName] then return end

	local GVAR_TargetButton
	if enemyName then
		local enemyButton = ENEMY_Name2Button[enemyName]
		if enemyButton then
			GVAR_TargetButton = GVAR.TargetButton[enemyButton]
		end
	end

	-- health
	if OPT.ButtonShowHealthBar[currentSize] or OPT.ButtonShowHealthText[currentSize] then
		if enemyID and enemyName then
			BattlegroundTargets:CheckUnitHealth(enemyID, enemyName, 1)
		end
	end

	-- assist_
	if isAssistName and OPT.ButtonShowAssist[currentSize] then
		if curTime > assistForceUpdate + assistFrequency then
			assistForceUpdate = curTime
			assistTargetName, assistTargetRealm = UnitName(isAssistUnitId)
			if assistTargetRealm and assistTargetRealm ~= "" then
				assistTargetName = assistTargetName.."-"..assistTargetRealm
			end
			for i = 1, currentSize do
				GVAR.TargetButton[i].AssistTexture:SetAlpha(0)
			end
			if assistTargetName then
				local assistButton = ENEMY_Name2Button[assistTargetName]
				if assistButton then
					local button = GVAR.TargetButton[assistButton]
					if button then
						button.AssistTexture:SetAlpha(1)
					end
				end
			end
		elseif friendName and isAssistName == friendName then
			for i = 1, currentSize do
				GVAR.TargetButton[i].AssistTexture:SetAlpha(0)
			end
			if GVAR_TargetButton then
				assistTargetName = enemyName
				GVAR_TargetButton.AssistTexture:SetAlpha(1)
			end
		end
	end

	-- leader
	if OPT.ButtonShowLeader[currentSize] then
		if GVAR_TargetButton then
			if isLeader then
				leaderThrottle = leaderThrottle + 1
				if leaderThrottle > leaderFrequency then
					leaderThrottle = 0
					if UnitIsGroupLeader(enemyID) then -- TODO_MoP
						isLeader = enemyName
						for i = 1, currentSize do
							GVAR.TargetButton[i].LeaderTexture:SetAlpha(0)
						end
						GVAR_TargetButton.LeaderTexture:SetAlpha(0.75)
					else
						GVAR_TargetButton.LeaderTexture:SetAlpha(0)
					end
				end
			else
				if UnitIsGroupLeader(enemyID) then -- TODO_MoP
					isLeader = enemyName
					for i = 1, currentSize do
						GVAR.TargetButton[i].LeaderTexture:SetAlpha(0)
					end
					GVAR_TargetButton.LeaderTexture:SetAlpha(0.75)
				else
					GVAR_TargetButton.LeaderTexture:SetAlpha(0)
				end
			end
		end
	end

	-- GLDGRP
	if OPT.ButtonShowGuildGroup[currentSize] then
		if not ENEMY_Guild[enemyName] then
			if UnitIsVisible(enemyID) then -- vis -- TODO_MoP - U.nitIsVisible is no longer necessary, needs check

				local guildName = GetGuildInfo(enemyID)
				if guildName and guildName ~= "" then
					ENEMY_Guild[enemyName] = guildName
					ENEMY_GroupNum[enemyName] = 0

					if not ENEMY_GuildCount[guildName] then
						ENEMY_GuildCount[guildName] = 1
					else
						ENEMY_GuildCount[guildName] = ENEMY_GuildCount[guildName] + 1
					end

					for i = 1, currentSize do
						GVAR.TargetButton[i].GuildGroup:SetTexCoord(0, 0, 0, 0)
					end

					local highestNum = 0
					for _, gNum in pairs(ENEMY_GroupNum) do
						if gNum > highestNum then
							highestNum = gNum
						end
					end

					-- ---------------
					local num = 1
					for gName, gCount in pairs(ENEMY_GuildCount) do
						if gCount > 1 then

							local num2 = 0
							for eName2, gName2 in pairs(ENEMY_Guild) do
								if gName == gName2 then
									local gldNum = ENEMY_GroupNum[eName2]
									if gldNum and gldNum > 0 then
										num2 = gldNum
										break
									end
								end
							end

							if num2 == 0 and highestNum > 0 then
								num = highestNum + 1
							elseif num2 > 0 then
								num = num2
							end

							for eName2, gName2 in pairs(ENEMY_Guild) do
								if gName == gName2 then
									ENEMY_GroupNum[eName2] = num

									local button1 = ENEMY_Name2Button[eName2]
									if button1 then
										local button2 = GVAR.TargetButton[button1]
										if button2 then
											local texNum, colNum = ggTexCol(num)
											local tex = guildGrpTex[texNum]
											local col = guildGrpCol[colNum]
											button2.GuildGroup:SetTexCoord(tex[1], tex[2], tex[3], tex[4]) -- GRP_TEX
											button2.GuildGroup:SetVertexColor(col[1], col[2], col[3])
										end
									end

								end
							end

						end
					end
					-- ---------------

					BattlegroundTargets:GuildGroupEnemyUpdate()

				end

			end -- vis -- TODO_MoP - U.nitIsVisible is no longer necessary, needs check
		end
	end

	-- level
	if isLowLevel then -- LVLCHK
		local level = UnitLevel(enemyID) or 0
		if level > 0 then
			ENEMY_Name2Level[enemyName] = level
			if GVAR_TargetButton then
				GVAR_TargetButton.Name:SetText(level.." "..GVAR_TargetButton.name4button)
			end
		end
	end

	-- class_range (Check Unit Target)
	if rangeSpellName and OPT.ButtonTypeRangeCheck[currentSize] >= 2 then
		if GVAR_TargetButton then
			local Name2Range = ENEMY_Name2Range[enemyName]
			if Name2Range then
				if Name2Range + range_SPELL_Frequency > curTime then return end -- ATTENTION
			end
			if IsSpellInRange(rangeSpellName, enemyID) == 1 then
				ENEMY_Name2Range[enemyName] = curTime
				Range_Display(true, GVAR_TargetButton, OPT.ButtonRangeDisplay[currentSize])
			else
				ENEMY_Name2Range[enemyName] = nil
				Range_Display(false, GVAR_TargetButton, OPT.ButtonRangeDisplay[currentSize])
			end
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckUnitHealth(unitID, unitName, healthonly)
	if isConfig then return end

	local targetID, targetName, targetRealm
	if not unitName then
		if raidUnitID[unitID] then
			targetID = unitID.."target"
		elseif playerUnitID[unitID] then
			targetID = unitID
		else
			return
		end
		targetName, targetRealm = UnitName(targetID)
		if targetRealm and targetRealm ~= "" then
			targetName = targetName.."-"..targetRealm
		end
	else
		targetID = unitID
		targetName = unitName
	end

	if not targetName then return end
	local targetButton = ENEMY_Name2Button[targetName]
	if not targetButton then return end
	local GVAR_TargetButton = GVAR.TargetButton[targetButton]
	if not GVAR_TargetButton then return end

	-- health
	local ButtonShowHealthBar  = OPT.ButtonShowHealthBar[currentSize]
	local ButtonShowHealthText = OPT.ButtonShowHealthText[currentSize]
	if ButtonShowHealthBar or ButtonShowHealthText then
		local maxHealth = UnitHealthMax(targetID)
		if maxHealth then
			local health = UnitHealth(targetID)
			if health then
				local width = 0.01
				local percent = 0
				if maxHealth > 0 and health > 0 then
					local hvalue = maxHealth / health
					width = healthBarWidth / hvalue
					width = math_max(0.01, width)
					width = math_min(healthBarWidth, width)
					percent = math_floor( (100/hvalue) + 0.5 )
					percent = math_max(0, percent)
					percent = math_min(100, percent)
				end
				ENEMY_Name2Percent[targetName] = percent
				if ButtonShowHealthBar then
					GVAR_TargetButton.HealthBar:SetWidth(width)
				end
				if ButtonShowHealthText then
					GVAR_TargetButton.HealthText:SetText(percent)
				end
			end
		end
	end

	if healthonly then return end

	-- FLAGSPY
	if flagCHK and isFlagBG > 0 then
		if OPT.ButtonShowFlag[currentSize] then
			BattlegroundTargets:CheckFlagCarrierCHECK(targetID, targetName)
		end
	end

	-- class_range (Check Unit Health)
	if rangeSpellName and OPT.ButtonTypeRangeCheck[currentSize] >= 2 then
		local curTime = GetTime()
		local Name2Range = ENEMY_Name2Range[targetName]
		if Name2Range then
			if Name2Range + range_SPELL_Frequency > curTime then return end -- ATTENTION
		end
		if IsSpellInRange(rangeSpellName, targetID) == 1 then
			ENEMY_Name2Range[targetName] = curTime
			Range_Display(true, GVAR_TargetButton, OPT.ButtonRangeDisplay[currentSize])
		else
			ENEMY_Name2Range[targetName] = nil
			Range_Display(false, GVAR_TargetButton, OPT.ButtonRangeDisplay[currentSize])
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:GuildGroupFriendUpdate() -- GLDGRP
	if isConfig then return end
	if not BattlegroundTargets_Options.Summary[currentSize] then return end

	-- scan each groupmember
	groupMembers = GetNumGroupMembers() -- TODO_MoP
	if groupMemChk > groupMembers then
		groupMemChk = groupMembers
	end

	--print("0---START -----", caller, GetTime()) -- TEST
	for num = 1, groupMembers do
		local unitID = "raid"..num
		if UnitIsVisible(unitID) then -- vis -- TODO_MoP - U.nitIsVisible is no longer necessary, needs check
			local name, realm = UnitName(unitID)
			if realm and realm ~= "" then
				name = name.."-"..realm
			end
			if name then
				-- do the guild name check 3 times. reason: sometimes GetGuildInfo() returns nil, even if a player is in a guild.
				if not FRIEND_GuildName[name] then

					FRIEND_GuildName[name] = 1
					local guildName = GetGuildInfo(unitID)
					if guildName and guildName ~= "" then
						FRIEND_GuildName[name] = 4
						groupMemChk = groupMemChk + 1
						if not FRIEND_GuildCount[guildName] then
							FRIEND_GuildCount[guildName] = 1
						else
							FRIEND_GuildCount[guildName] = FRIEND_GuildCount[guildName] + 1
						end
					end
					--print(num, groupMembers, unitID, "#", name, "->", guildName, "*1*", FRIEND_GuildName[name]) -- TEST

				elseif FRIEND_GuildName[name] < 3 then

					FRIEND_GuildName[name] = FRIEND_GuildName[name] + 1
					local guildName = GetGuildInfo(unitID)
					if guildName and guildName ~= "" then
						FRIEND_GuildName[name] = 4
						groupMemChk = groupMemChk + 1
						if not FRIEND_GuildCount[guildName] then
							FRIEND_GuildCount[guildName] = 1
						else
							FRIEND_GuildCount[guildName] = FRIEND_GuildCount[guildName] + 1
						end
					end
					--print(num, groupMembers, unitID, "#", name, "->", guildName, "*2*", FRIEND_GuildName[name]) -- TEST

				elseif FRIEND_GuildName[name] == 3 then

					FRIEND_GuildName[name] = 4
					groupMemChk = groupMemChk + 1
					local guildName = GetGuildInfo(unitID)
					if guildName and guildName ~= "" then
						if not FRIEND_GuildCount[guildName] then
							FRIEND_GuildCount[guildName] = 1
						else
							FRIEND_GuildCount[guildName] = FRIEND_GuildCount[guildName] + 1
						end
					end
					--print(num, groupMembers, unitID, "#", name, "->", guildName, "*3*", FRIEND_GuildName[name]) -- TEST

				end
			end
		end -- vis -- TODO_MoP - U.nitIsVisible is no longer necessary, needs check
	end

	-- build table with guildCount as key and number of groups with same membersize as value
	local count = {}
	for _, guildCount in pairs(FRIEND_GuildCount) do
		if guildCount > 1 then
			if not count[guildCount] then
				count[guildCount] = 1
			else
				count[guildCount] = count[guildCount] + 1
			end
		end
	end

	-- prepare table for sorting
	local i = 1
	local count2 = {}
	for guildCount, guildNum in pairs(count) do
		count2[i] = {}
		count2[i].count = guildCount
		count2[i].total = guildNum
		i = i + 1
	end

	-- sort
	table_sort(count2, guildgroup_sortfunc)

	-- display
	for i = 1, 7 do
		if count2[i] then
			GVAR.GuildGroupSummaryFriend[i].Text:SetText(count2[i].count..": "..count2[i].total.."x")
		else
			GVAR.GuildGroupSummaryFriend[i].Text:SetText("")
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:GuildGroupEnemyUpdate() -- GLDGRP
	if isConfig then return end
	if not BattlegroundTargets_Options.Summary[currentSize] then return end

	-- build table with guildCount as key and number of groups with same membersize as value
	local count = {}
	for _, guildCount in pairs(ENEMY_GuildCount) do
		if guildCount > 1 then
			if not count[guildCount] then
				count[guildCount] = 1
			else
				count[guildCount] = count[guildCount] + 1
			end
		end
	end

	-- prepare table for sorting
	local i = 1
	local count2 = {}
	for guildCount, guildNum in pairs(count) do
		count2[i] = {}
		count2[i].count = guildCount
		count2[i].total = guildNum
		i = i + 1
	end

	-- sort
	table_sort(count2, guildgroup_sortfunc)

	-- display
	for i = 1, 7 do
		if count2[i] then
			GVAR.GuildGroupSummaryEnemy[i].Text:SetText(count2[i].count..": "..count2[i].total.."x")
		else
			GVAR.GuildGroupSummaryEnemy[i].Text:SetText("")
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:SetFlagDebuff(GVAR_TargetButton)
	if flagDebuff > 0 then
		GVAR_TargetButton.FlagDebuff:SetText(flagDebuff)
	else
		GVAR_TargetButton.FlagDebuff:SetText("")
	end
end

function BattlegroundTargets:FlagDebuffCheck(message)
	if message == FLG["FLAG_DEBUFF1"] or message == FLG["FLAG_DEBUFF2"] then -- FLAGDEBUFF
		flagDebuff = flagDebuff + 1
		if hasFlag then
			local Name2Button = ENEMY_Name2Button[hasFlag]
			if Name2Button then
				local GVAR_TargetButton = GVAR.TargetButton[Name2Button]
				if GVAR_TargetButton then
					BattlegroundTargets:SetFlagDebuff(GVAR_TargetButton)
				end
			end
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:FlagCheck(message, messageFaction)
	if messageFaction == playerFactionBG then
		-- -----------------------------------------------------------------------------------------------------------------
		local fc = string_match(message, FLG["WSG_TP_REGEX_PICKED1"]) or -- Warsong Gulch & Twin Peaks: flag was picked
		           string_match(message, FLG["WSG_TP_REGEX_PICKED2"]) or -- Warsong Gulch & Twin Peaks: flag was picked
		           string_match(message, FLG["EOTS_REGEX_PICKED"])       -- Eye of the Storm          : flag was picked
		if fc then
			flags = flags + 1
		-- -----------------------------------------------------------------------------------------------------------------
		elseif string_match(message, FLG["WSG_TP_MATCH_CAPTURED"]) or -- Warsong Gulch & Twin Peaks: flag was captured
		       message == FLG["EOTS_STRING_CAPTURED_BY_ALLIANCE"] or  -- Eye of the Storm          : flag was captured
		       message == FLG["EOTS_STRING_CAPTURED_BY_HORDE"]        -- Eye of the Storm          : flag was captured
		then
			for i = 1, currentSize do
				local GVAR_TargetButton = GVAR.TargetButton[i]
				GVAR_TargetButton.FlagTexture:SetAlpha(0)
				GVAR_TargetButton.FlagDebuff:SetText("")
			end
			hasFlag = nil
			flagDebuff = 0
			flags = 0
			if flagCHK then
				BattlegroundTargets:CheckFlagCarrierEND()
			end
		-- -----------------------------------------------------------------------------------------------------------------
		elseif string_match(message, FLG["WSG_TP_MATCH_DROPPED"]) or -- Warsong Gulch & Twin Peaks: flag was dropped
		       message == FLG["EOTS_STRING_DROPPED"]                 -- Eye of the Storm          : flag was dropped
		then
			for i = 1, currentSize do
				local GVAR_TargetButton = GVAR.TargetButton[i]
				GVAR_TargetButton.FlagTexture:SetAlpha(0)
				GVAR_TargetButton.FlagDebuff:SetText("")
			end
			hasFlag = nil
			flags = flags - 1
			if flags <= 0 then
				flagDebuff = 0
				flags = 0
			end
		end
		-- -----------------------------------------------------------------------------------------------------------------
	else
		-- -----------------------------------------------------------------------------------------------------------------
		local efc = string_match(message, FLG["WSG_TP_REGEX_PICKED1"]) or -- Warsong Gulch & Twin Peaks: flag was picked
		            string_match(message, FLG["WSG_TP_REGEX_PICKED2"]) or -- Warsong Gulch & Twin Peaks: flag was picked
		            string_match(message, FLG["EOTS_REGEX_PICKED"])       -- Eye of the Storm          : flag was picked
		if efc then
			flags = flags + 1
			for i = 1, currentSize do
				local GVAR_TargetButton = GVAR.TargetButton[i]
				GVAR_TargetButton.FlagTexture:SetAlpha(0)
				GVAR_TargetButton.FlagDebuff:SetText("")
			end
			if flagCHK then
				BattlegroundTargets:CheckFlagCarrierEND()
			end
			for name, button in pairs(ENEMY_Names4Flag) do
				if name == efc then
					local GVAR_TargetButton = GVAR.TargetButton[button]
					if GVAR_TargetButton then
						GVAR_TargetButton.FlagTexture:SetAlpha(1)
						BattlegroundTargets:SetFlagDebuff(GVAR_TargetButton)
						for fullname, fullnameButton in pairs(ENEMY_Name2Button) do -- ENEMY_Name2Button and ENEMY_Names4Flag have same buttonID
							if button == fullnameButton then
								hasFlag = fullname
								return
							end
						end
					end
					return
				end
			end
		-- -----------------------------------------------------------------------------------------------------------------
		elseif string_match(message, FLG["WSG_TP_MATCH_CAPTURED"]) or -- Warsong Gulch & Twin Peaks: flag was captured
		       message == FLG["EOTS_STRING_CAPTURED_BY_ALLIANCE"] or  -- Eye of the Storm          : flag was captured
		       message == FLG["EOTS_STRING_CAPTURED_BY_HORDE"]        -- Eye of the Storm          : flag was captured
		then
			for i = 1, currentSize do
				local GVAR_TargetButton = GVAR.TargetButton[i]
				GVAR_TargetButton.FlagTexture:SetAlpha(0)
				GVAR_TargetButton.FlagDebuff:SetText("")
			end
			hasFlag = nil
			flagDebuff = 0
			flags = 0
			if flagCHK then
				BattlegroundTargets:CheckFlagCarrierEND()
			end
		-- -----------------------------------------------------------------------------------------------------------------
		elseif string_match(message, FLG["WSG_TP_MATCH_DROPPED"]) then -- Warsong Gulch & Twin Peaks: flag was dropped
			flags = flags - 1
			if flags <= 0 then
				flagDebuff = 0
				flags = 0
			end
		-- -----------------------------------------------------------------------------------------------------------------
		elseif message == FLG["EOTS_STRING_DROPPED"] then -- Eye of the Storm: flag was dropped
			for i = 1, currentSize do
				local GVAR_TargetButton = GVAR.TargetButton[i]
				GVAR_TargetButton.FlagTexture:SetAlpha(0)
				GVAR_TargetButton.FlagDebuff:SetText("")
			end
			hasFlag = nil
			flags = flags - 1
			if flags <= 0 then
				flagDebuff = 0
				flags = 0
			end
		end
		-- -----------------------------------------------------------------------------------------------------------------
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
local function CombatLogRangeCheck(sourceName, destName, spellId)
	if not SPELL_Range[spellId] then
		local _, _, _, _, _, _, _, _, maxRange = GetSpellInfo(spellId) -- local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(spellId)
		if not maxRange then return end
		SPELL_Range[spellId] = maxRange
	end

	if OPT.ButtonTypeRangeCheck[currentSize] == 4 then

		if SPELL_Range[spellId] > rangeMax then return end
		if SPELL_Range[spellId] < rangeMin then return end

		-- enemy attack player
		if ENEMY_Names[sourceName] then
			if destName == playerName then

				if ENEMY_Name2Percent[sourceName] == 0 then
					ENEMY_Name2Range[sourceName] = nil
					local sourceButton = ENEMY_Name2Button[sourceName]
					if sourceButton then
						local GVAR_TargetButton = GVAR.TargetButton[sourceButton]
						if GVAR_TargetButton then
							Range_Display(false, GVAR_TargetButton, OPT.ButtonRangeDisplay[currentSize])
						end
					end
					return
				end

				local curTime = GetTime()
				ENEMY_Name2Range[sourceName] = curTime
				local sourceButton = ENEMY_Name2Button[sourceName]
				if sourceButton then
					local GVAR_TargetButton = GVAR.TargetButton[sourceButton]
					if GVAR_TargetButton then
						Range_Display(true, GVAR_TargetButton, OPT.ButtonRangeDisplay[currentSize])
					end
				end
				if range_CL_DisplayThrottle + range_CL_DisplayFrequency > curTime then return end
				range_CL_DisplayThrottle = curTime
				BattlegroundTargets:UpdateRange(curTime)
			end
		end

	elseif OPT.ButtonTypeRangeCheck[currentSize] == 3 then

		if SPELL_Range[spellId] > 45 then return end

		-- enemy attack player
		if ENEMY_Names[sourceName] then
			if destName == playerName then

				if ENEMY_Name2Percent[sourceName] == 0 then
					ENEMY_Name2Range[sourceName] = nil
					local sourceButton = ENEMY_Name2Button[sourceName]
					if sourceButton then
						local GVAR_TargetButton = GVAR.TargetButton[sourceButton]
						if GVAR_TargetButton then
							Range_Display(false, GVAR_TargetButton, OPT.ButtonRangeDisplay[currentSize])
						end
					end
					return
				end

				local curTime = GetTime()
				ENEMY_Name2Range[sourceName] = curTime
				local sourceButton = ENEMY_Name2Button[sourceName]
				if sourceButton then
					local GVAR_TargetButton = GVAR.TargetButton[sourceButton]
					if GVAR_TargetButton then
						Range_Display(true, GVAR_TargetButton, OPT.ButtonRangeDisplay[currentSize])
					end
				end
				if range_CL_DisplayThrottle + range_CL_DisplayFrequency > curTime then return end
				range_CL_DisplayThrottle = curTime
				BattlegroundTargets:UpdateRange(curTime)
			end
		end

	else--if OPT.ButtonTypeRangeCheck[currentSize] == 1 then

		if SPELL_Range[spellId] > 45 then return end

		-- enemy attack friend
		if ENEMY_Names[sourceName] then
			if destName == playerName then
				ENEMY_Name2Range[sourceName] = GetTime()
				local sourceButton = ENEMY_Name2Button[sourceName]
				if sourceButton then
					local GVAR_TargetButton = GVAR.TargetButton[sourceButton]
					if GVAR_TargetButton then
						Range_Display(true, GVAR_TargetButton, OPT.ButtonRangeDisplay[currentSize])
					end
				end
			elseif FRIEND_Names[destName] then
				local curTime = GetTime()
				if CheckInteractDistance(destName, 1) then -- 1:Inspect=28
					ENEMY_Name2Range[sourceName] = curTime
				end
				if range_CL_DisplayThrottle + range_CL_DisplayFrequency > curTime then return end
				range_CL_DisplayThrottle = curTime
				BattlegroundTargets:UpdateRange(curTime)
			end
		-- friend attack enemy
		elseif ENEMY_Names[destName] then
			if sourceName == playerName then
				ENEMY_Name2Range[destName] = GetTime()
				local destButton = ENEMY_Name2Button[destName]
				if destButton then
					local GVAR_TargetButton = GVAR.TargetButton[destButton]
					if GVAR_TargetButton then
						Range_Display(true, GVAR_TargetButton, OPT.ButtonRangeDisplay[currentSize])
					end
				end
			elseif FRIEND_Names[sourceName] then
				local curTime = GetTime()
				if CheckInteractDistance(sourceName, 1) then -- 1:Inspect=28
					ENEMY_Name2Range[destName] = curTime
				end
				if range_CL_DisplayThrottle + range_CL_DisplayFrequency > curTime then return end
				range_CL_DisplayThrottle = curTime
				BattlegroundTargets:UpdateRange(curTime)
			end
		end

	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:UpdateRange(curTime)
	if isDeadUpdateStop then
		BattlegroundTargets:ClearRangeData()
		return
	end

	local ButtonRangeDisplay = OPT.ButtonRangeDisplay[currentSize]
	for i = 1, currentSize do
		Range_Display(false, GVAR.TargetButton[i], ButtonRangeDisplay)
	end

	for name, timeStamp in pairs(ENEMY_Name2Range) do
		local button = ENEMY_Name2Button[name]
		if not button then
			ENEMY_Name2Range[name] = nil
		elseif ENEMY_Name2Percent[name] == 0 then
			ENEMY_Name2Range[name] = nil
		elseif timeStamp + range_DisappearTime < curTime then
			ENEMY_Name2Range[name] = nil
		else
			local GVAR_TargetButton = GVAR.TargetButton[button]
			if GVAR_TargetButton then
				Range_Display(true, GVAR_TargetButton, ButtonRangeDisplay)
			end
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:ClearRangeData()
	if OPT.ButtonRangeCheck[currentSize] then
		table_wipe(ENEMY_Name2Range)
		local ButtonRangeDisplay = OPT.ButtonRangeDisplay[currentSize]
		for i = 1, currentSize do
			Range_Display(false, GVAR.TargetButton[i], ButtonRangeDisplay)
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckPlayerLevel() -- LVLCHK
	if playerLevel == maxLevel then
		isLowLevel = nil
		BattlegroundTargets:UnregisterEvent("PLAYER_LEVEL_UP")
	elseif playerLevel < maxLevel then
		isLowLevel = true
		BattlegroundTargets:RegisterEvent("PLAYER_LEVEL_UP")
	else--if playerLevel > maxLevel then
		isLowLevel = nil
		BattlegroundTargets:UnregisterEvent("PLAYER_LEVEL_UP")
		Print("ERROR", "wrong level", locale, playerLevel, maxLevel)
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckFaction()
	local faction = UnitFactionGroup("player")
	if faction == "Horde" then
		playerFactionDEF   = 0 -- Horde
		oppositeFactionDEF = 1 -- Alliance
	elseif faction == "Alliance" then
		playerFactionDEF   = 1 -- Alliance
		oppositeFactionDEF = 0 -- Horde
	elseif faction == "Neutral" then
		playerFactionDEF   = 1 -- Dummy
		oppositeFactionDEF = 0 -- Dummy
	else
		Print("ERROR", "unknown faction", locale, faction)
		playerFactionDEF   = 1 -- Dummy
		oppositeFactionDEF = 0 -- Dummy
	end
	playerFactionBG   = playerFactionDEF
	oppositeFactionBG = oppositeFactionDEF
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckIfPlayerIsGhost()
	if not inBattleground then return end
	if UnitIsGhost("player") then
		isDeadUpdateStop = true
		BattlegroundTargets:ClearRangeData()
	else
		isDeadUpdateStop = false
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
local function OnEvent(self, event, ...)
	--if not eventTest[event] then eventTest[event] = 1 else eventTest[event] = eventTest[event] + 1 end -- TEST
	if event == "PLAYER_REGEN_DISABLED" then
		inCombat = true
		if isConfig then
			if not inWorld then return end
			BattlegroundTargets:DisableInsecureConfigWidges()
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		inCombat = false
		if reCheckScore then
			if not inWorld then return end
			BattlegroundTargets:BattlefieldScoreUpdate(1)
		end
		if reCheckBG then
			if not inWorld then return end
			BattlegroundTargets:BattlefieldCheck()
		end
		if reSetLayout then
			if not inWorld then return end
			BattlegroundTargets:SetupButtonLayout()
		end
		if isConfig then
			if not inWorld then return end
			BattlegroundTargets:EnableInsecureConfigWidges()
			if BattlegroundTargets_Options.EnableBracket[currentSize] then
				BattlegroundTargets:ShuffleSizeCheck(currentSize)
				BattlegroundTargets:ConfigGuildGroupFriendUpdate(currentSize)
				BattlegroundTargets:EnableConfigMode()
			else
				BattlegroundTargets:DisableConfigMode()
			end
		end

	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if isConfig then return end
		if isDeadUpdateStop then return end

		local _, _, _, _, sourceName, _, _, _, destName, _, _, spellId = ... -- timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool = ...
		if not sourceName then return end
		if not destName then return end
		if sourceName == destName then return end
		if not spellId then return end

		range_CL_Throttle = range_CL_Throttle + 1
		if range_CL_Throttle > range_CL_Frequency then
			range_CL_Throttle = 0
			range_CL_Frequency = math_random(1,3)
			return
		end
		CombatLogRangeCheck(sourceName, destName, spellId)

	elseif event == "UNIT_HEALTH_FREQUENT" then
		if isDeadUpdateStop then return end
		local arg1 = ...
		BattlegroundTargets:CheckUnitHealth(arg1)
	elseif event == "UNIT_TARGET" then
		if isDeadUpdateStop then return end
		local arg1 = ...
		if not raidUnitID[arg1] then return end
		BattlegroundTargets:CheckUnitTarget(arg1)
	elseif event == "UPDATE_MOUSEOVER_UNIT" then
		if isDeadUpdateStop then return end
		BattlegroundTargets:CheckUnitHealth("mouseover")
	elseif event == "PLAYER_TARGET_CHANGED" then
		BattlegroundTargets:CheckPlayerTarget()
	elseif event == "PLAYER_FOCUS_CHANGED" then
		BattlegroundTargets:CheckPlayerFocus()

	elseif event == "UPDATE_BATTLEFIELD_SCORE" then
		if isConfig then return end
		BattlegroundTargets:BattlefieldScoreUpdate()

	elseif event == RosterUpdate then -- TODO_MoP
		if OPT.ButtonShowAssist[currentSize] then
			BattlegroundTargets:CheckAssist()
		end
		if OPT.ButtonShowGuildGroup[currentSize] then
			BattlegroundTargets:GuildGroupFriendUpdate()
		end

	elseif event == "CHAT_MSG_BG_SYSTEM_HORDE" then
		local arg1 = ...
		BattlegroundTargets:FlagCheck(arg1, 0) -- 'Horde'
	elseif event == "CHAT_MSG_BG_SYSTEM_ALLIANCE" then
		local arg1 = ...
		BattlegroundTargets:FlagCheck(arg1, 1) -- 'Alliance'
	elseif event == "CHAT_MSG_BG_SYSTEM_NEUTRAL" then
		local arg1 = ...
		BattlegroundTargets:FlagDebuffCheck(arg1) -- FLAGDEBUFF

	elseif event == "PLAYER_DEAD" then
		if not inBattleground then return end
		isDeadUpdateStop = false
	elseif event == "PLAYER_UNGHOST" then
		if not inBattleground then return end
		isDeadUpdateStop = false
	elseif event == "PLAYER_ALIVE" then
		BattlegroundTargets:CheckIfPlayerIsGhost()

	elseif event == "ZONE_CHANGED_NEW_AREA" then
		if not inWorld then return end
		if isConfig then return end
		BattlegroundTargets:BattlefieldCheck()

	elseif event == "PLAYER_LEVEL_UP" then -- LVLCHK
		local arg1 = ...
		if arg1 then
			playerLevel = arg1
			BattlegroundTargets:CheckPlayerLevel()
			if playerLevel == 10 then -- TODO_MoP
				BattlegroundTargets:CheckFaction()
			end
		end

	elseif event == "PLAYER_LOGIN" then
		BattlegroundTargets:CheckFaction()
		BattlegroundTargets:InitOptions()
		BattlegroundTargets:CreateInterfaceOptions()
		BattlegroundTargets:LDBcheck()
		BattlegroundTargets:CreateFrames()
		BattlegroundTargets:CreateOptionsFrame()

		hooksecurefunc("PanelTemplates_SetTab", function(frame)
			if frame and frame == WorldStateScoreFrame then
				BattlegroundTargets:ScoreWarningCheck()
			end
		end)

		table.insert(UISpecialFrames, "BattlegroundTargets_OptionsFrame")
		BattlegroundTargets:UnregisterEvent("PLAYER_LOGIN")
	elseif event == "PLAYER_ENTERING_WORLD" then
		inWorld = true
		BattlegroundTargets:CheckPlayerLevel() -- LVLCHK
		BattlegroundTargets:BattlefieldCheck()
		BattlegroundTargets:CheckIfPlayerIsGhost()
		BattlegroundTargets:CreateMinimapButton()

		if not BattlegroundTargets_Options.FirstRun then
			BattlegroundTargets:Frame_Toggle(GVAR.OptionsFrame)
			BattlegroundTargets_Options.FirstRun = true
		end

		BattlegroundTargets:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

BattlegroundTargets:RegisterEvent("PLAYER_REGEN_DISABLED")
BattlegroundTargets:RegisterEvent("PLAYER_REGEN_ENABLED")
BattlegroundTargets:RegisterEvent("ZONE_CHANGED_NEW_AREA")
BattlegroundTargets:RegisterEvent("PLAYER_LOGIN")
BattlegroundTargets:RegisterEvent("PLAYER_ENTERING_WORLD")
BattlegroundTargets:SetScript("OnEvent", OnEvent)