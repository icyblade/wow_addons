local AddonName, TemplatePrivate = ...
local WeakAuras = WeakAuras
local L = WeakAuras.L
local GetSpellInfo, tinsert, GetItemInfo, GetSpellDescription = GetSpellInfo, tinsert, GetItemInfo, GetSpellDescription

-- The templates tables are created on demand
local templates =
  {
    class = { },
    race = {
      Human = {},
      NightElf = {},
      Dwarf = {},
      Gnome = {},
      Draenei = {},
      Worgen = {},
      Pandaren = {},
      Orc = {},
      Scourge = {},
      Tauren = {},
      Troll = {},
      BloodElf = {},
      Goblin = {},
    },
    general = {
      title = L["General"],
        icon = "Interface\\Icons\\spell_nature_wispsplode",
      args = {}
    },
    items = {
    },
  }

local powerTypes =
  {
    [0] = { name = MANA, icon = "Interface\\Icons\\inv_elemental_mote_mana" },
    [1] = { name = POWER_TYPE_RED_POWER, icon = "Interface\\Icons\\spell_misc_emotionangry"},
    [2] = { name = POWER_TYPE_FOCUS, icon = "Interface\\Icons\\ability_hunter_focusfire"},
    [3] = { name = POWER_TYPE_ENERGY, icon = "Interface\\Icons\\spell_shadow_shadowworddominate"},
    [4] = { name = COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT, icon = "Interface\\Icons\\inv_mace_2h_pvp410_c_01"},
    [6] = { name = RUNIC_POWER, icon = "Interface\\Icons\\inv_sword_62"},
    [7] = { name = SOUL_SHARDS_POWER, icon = "Interface\\Icons\\inv_misc_gem_amethyst_02"},
    [8] = { name = POWER_TYPE_SUN_POWER, icon = "Interface\\Icons\\ability_druid_eclipseorange"},
    [9] = { name = HOLY_POWER, icon = "Interface\\Icons\\achievement_bg_winsoa"},

    [12] = {name = CHI_POWER, icon = "Interface\\Icons\\ability_monk_healthsphere"},
    [13] = {name = SHADOW_ORBS, icon = "Interface\\Icons\\spell_priest_shadoworbs"},
    [14] = {name = BURNING_EMBERS, icon = "Interface\\Icons\\ability_warlock_burningembers"},
    [15] = {name = DEMONIC_FURY, icon = "Interface\\Icons\\Ability_Warlock_Eradication"},
    [99] = {name = L["Stagger"], icon = "Interface\\Icons\\monk_stance_drunkenox"}
  }

-- Collected by WeakAurasTemplateCollector:
--------------------------------------------------------------------------------
templates.class.WARRIOR = {
  [1] = { -- Arms
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 126700, type = "buff", unit = "player"}, -- Surge of Victory
        { spell = 12328, type = "buff", unit = "player"}, -- Sweeping Strikes
        { spell = 60503, type = "buff", unit = "player"}, -- Taste for Blood
        { spell = 114192, type = "buff", unit = "player"}, -- Mocking Banner
        { spell = 118038, type = "buff", unit = "player"}, -- Die by the Sword
        { spell = 6673, type = "buff", unit = "player", forceOwnOnly = true, ownOnly = nil}, -- Battle Shout
        { spell = 871, type = "buff", unit = "player"}, -- Shield Wall
        { spell = 114206, type = "buff", unit = "player"}, -- Skull Banner
        { spell = 23920, type = "buff", unit = "player"}, -- Spell Reflection
        { spell = 139958, type = "buff", unit = "player"}, -- Sudden Execute
        { spell = 469, type = "buff", unit = "player", forceOwnOnly = true, ownOnly = nil}, -- Commanding Shout
        { spell = 133278, type = "buff", unit = "player"}, -- Speed
        { spell = 32216, type = "buff", unit = "player"}, -- Victorious
        { spell = 12880, type = "buff", unit = "player"}, -- Enrage
        { spell = 1719, type = "buff", unit = "player"}, -- Recklessness
        { spell = 52437, type = "buff", unit = "player"}, -- Sudden Death
        { spell = 97463, type = "buff", unit = "player"}, -- Rallying Cry
        { spell = 32216, type = "buff", unit = "player"}, -- Victorious
        { spell = 55694, type = "buff", unit = "player", talent = 4}, -- Enraged Regeneration
        { spell = 46924, type = "buff", unit = "player", talent = 10}, -- Bladestorm
        { spell = 114028, type = "buff", unit = "player", talent = 13}, -- Mass Spell Reflection
        { spell = 46947, type = "buff", unit = "target", talent = 14}, -- Safeguard
        { spell = 114029, type = "buff", unit = "target", talent = 14}, -- Safeguard
        { spell = 114030, type = "buff", unit = "target", talent = 15}, -- Vigilance
        { spell = 107574, type = "buff", unit = "player", talent = 16}, -- Avatar
        { spell = 12292, type = "buff", unit = "player", talent = 17}, -- Bloodbath
      },
      icon = "Interface\\Icons\\Ability_warrior_battleshout"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 114205, type = "debuff", unit = "target"}, -- Demoralizing Banner
        { spell = 113746, type = "debuff", unit = "target"}, -- Weakened Armor
        { spell = 5246, type = "debuff", unit = "target"}, -- Intimidating Shout
        { spell = 81326, type = "debuff", unit = "target"}, -- Physical Vulnerability
        { spell = 115804, type = "debuff", unit = "target"}, -- Mortal Wounds
        { spell = 114198, type = "debuff", unit = "target"}, -- Mocking Banner
        { spell = 115798, type = "debuff", unit = "target"}, -- Weakened Blows
        { spell = 7922, type = "debuff", unit = "target"}, -- Charge Stun
        { spell = 132168, type = "debuff", unit = "target"}, -- Shockwave
        { spell = 115767, type = "debuff", unit = "target"}, -- Deep Wounds
        { spell = 676, type = "debuff", unit = "target"}, -- Disarm
        { spell = 1715, type = "debuff", unit = "target"}, -- Hamstring
        { spell = 355, type = "debuff", unit = "target"}, -- Taunt
        { spell = 64382, type = "debuff", unit = "target"}, -- Shattering Throw
        { spell = 86346, type = "debuff", unit = "target"}, -- Colossus Smash
        { spell = 107566, type = "debuff", unit = "target", talent = 7}, -- Staggering Shout
        { spell = 12323, type = "debuff", unit = "target", talent = 8}, -- Piercing Howl
        { spell = 118895, type = "debuff", unit = "target", talent = 12}, -- Dragon Roar
        { spell = 113344, type = "debuff", unit = "target", talent = 17}, -- Bloodbath
        { spell = 147531, type = "debuff", unit = "target", talent = 17}, -- Bloodbath
        { spell = 132169, type = "debuff", unit = "target", talent = 18}, -- Storm Bolt
      },
      icon = "Interface\\Icons\\Ability_warrior_warcry"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 1464, type = "ability", usable = true, requiresTarget = true }, -- Slam
        { spell = 12294, type = "ability", usable = true, requiresTarget = true }, -- Mortal Strike
        { spell = 7384, type = "ability", charges = true , usable = true, requiresTarget = true }, -- Overpower

        { spell = 86346, type = "ability", usable = true, requiresTarget = true }, -- Colossus Smash
        { spell = 118038, type = "ability", usable = true , buff = true }, -- Die by the Sword
        { spell = 1680, type = "ability", usable = true }, -- Whirlwind

        { spell = 78, type = "ability", usable = true, requiresTarget = true }, -- Heroic Strike
        { spell = 100, type = "ability", usable = true, requiresTarget = true }, -- Charge
        { spell = 355, type = "ability", usable = true, debuff = true, requiresTarget = true }, -- Taunt
        { spell = 469, type = "ability", usable = true , buff = true }, -- Commanding Shout
        { spell = 676, type = "ability", usable = true, debuff = true, requiresTarget = true }, -- Disarm
        { spell = 845, type = "ability", usable = true, requiresTarget = true }, -- Cleave
        { spell = 871, type = "ability", usable = true , buff = true }, -- Shield Wall
        { spell = 1715, type = "ability", usable = true, requiresTarget = true }, -- Hamstring
        { spell = 1719, type = "ability", usable = true , buff = true }, -- Recklessness
        { spell = 2457, type = "ability", usable = true }, -- Battle Stance
        { spell = 71, type = "ability", usable = true }, -- Defensive Stance
        { spell = 2458, type = "ability", usable = true }, -- Berserker Stance
        { spell = 3411, type = "ability", usable = true, requiresTarget = true }, -- Intervene
        { spell = 5246, type = "ability", usable = true }, -- Intimidating Shout
        { spell = 5308, type = "ability", usable = true, requiresTarget = true }, -- Execute
        { spell = 6343, type = "ability", usable = true }, -- Thunder Clap
        { spell = 6544, type = "ability", usable = true }, -- Heroic Leap
        { spell = 6673, type = "ability", usable = true , buff = true, requiresTarget = true }, -- Battle Shout
        { spell = 7386, type = "ability", usable = true, debuff = true }, -- Sunder Armor
        { spell = 18499, type = "ability", usable = true , buff = true }, -- Berserker Rage
        { spell = 23920, type = "ability", usable = true , buff = true }, -- Spell Reflection
        { spell = 57755, type = "ability", usable = true, requiresTarget = true }, -- Heroic Throw
        { spell = 64382, type = "ability", usable = true, requiresTarget = true }, -- Shattering Throw
        { spell = 97462, type = "ability", usable = true }, -- Rallying Cry
        { spell = 114192, type = "ability", usable = true , totem = true , buff = true }, -- Mocking Banner
        { spell = 114203, type = "ability", usable = true , totem = true }, -- Demoralizing Banner
        { spell = 114207, type = "ability", usable = true , totem = true }, -- Skull Banner
        { spell = 55694, type = "ability", usable = true , buff = true, talent = 4 }, -- Enraged Regeneration
        { spell = 103840, type = "ability", usable = true, talent = 6, requiresTarget = true }, -- Impending Victory
        { spell = 107566, type = "ability", usable = true, talent = 7 }, -- Staggering Shout
        { spell = 12323, type = "ability", usable = true, talent = 8 }, -- Piercing Howl
        { spell = 102060, type = "ability", usable = true, talent = 9 }, -- Disrupting Shout
        { spell = 46924, type = "ability", usable = true , buff = true, talent = 10 }, -- Bladestorm
        { spell = 46968, type = "ability", usable = true, talent = 11 }, -- Shockwave
        { spell = 118000, type = "ability", usable = true, talent = 12 }, -- Dragon Roar
        { spell = 114028, type = "ability", usable = true , buff = true, talent = 13 }, -- Mass Spell Reflection
        { spell = 114029, type = "ability", usable = true , debuff = true, talent = 14, requiresTarget = true }, -- Safeguard
        { spell = 114030, type = "ability", usable = true , debuff = true, talent = 15, requiresTarget = true }, -- Vigilance
        { spell = 107574, type = "ability", usable = true , buff = true, talent = 16 }, -- Avatar
        { spell = 12292, type = "ability", usable = true , buff = true, talent = 17 }, -- Bloodbath
        { spell = 107570, type = "ability", usable = true, talent = 18, requiresTarget = true }, -- Storm Bolt
      },
      icon = "Interface\\Icons\\Ability_warrior_savageblow"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\spell_misc_emotionangry",
    },
  },
  [2] = { -- Fury
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 85739, type = "buff", unit = "player"}, -- Meat Cleaver
        { spell = 12880, type = "buff", unit = "player"}, -- Enrage
        { spell = 12968, type = "buff", unit = "player"}, -- Flurry
        { spell = 46916, type = "buff", unit = "player"}, -- Bloodsurge
        { spell = 131116, type = "buff", unit = "player"}, -- Raging Blow!

        { spell = 114192, type = "buff", unit = "player"}, -- Mocking Banner
        { spell = 18499, type = "buff", unit = "player"}, -- Berserker Rage
        { spell = 1719, type = "buff", unit = "player"}, -- Recklessness
        { spell = 871, type = "buff", unit = "player"}, -- Shield Wall
        { spell = 97463, type = "buff", unit = "player"}, -- Rallying Cry
        { spell = 6673, type = "buff", unit = "player", forceOwnOnly = true, ownOnly = nil}, -- Battle Shout
        { spell = 114206, type = "buff", unit = "player"}, -- Skull Banner
        { spell = 469, type = "buff", unit = "player", forceOwnOnly = true, ownOnly = nil}, -- Commanding Shout
        { spell = 23920, type = "buff", unit = "player"}, -- Spell Reflection
        { spell = 147833, type = "buff", unit = "target"}, -- Intervene
        { spell = 32216, type = "buff", unit = "player"}, -- Victorious
        { spell = 55694, type = "buff", unit = "player", talent = 4}, -- Enraged Regeneration
        { spell = 46924, type = "buff", unit = "player", talent = 10}, -- Bladestorm
        { spell = 114028, type = "buff", unit = "player", talent = 13}, -- Mass Spell Reflection
        { spell = 46947, type = "buff", unit = "target", talent = 14}, -- Safeguard
        { spell = 114029, type = "buff", unit = "target", talent = 14}, -- Safeguard
        { spell = 114030, type = "buff", unit = "target", talent = 15}, -- Vigilance
        { spell = 107574, type = "buff", unit = "player", talent = 16}, -- Avatar
        { spell = 12292, type = "buff", unit = "player", talent = 17}, -- Bloodbath
      },
      icon = "Interface\\Icons\\Spell_shadow_unholyfrenzy"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 115767, type = "debuff", unit = "target"}, -- Deep Wounds
        { spell = 115804, type = "debuff", unit = "target"}, -- Mortal Wounds
        { spell = 114205, type = "debuff", unit = "target"}, -- Demoralizing Banner
        { spell = 113746, type = "debuff", unit = "target"}, -- Weakened Armor
        { spell = 5246, type = "debuff", unit = "target"}, -- Intimidating Shout
        { spell = 81326, type = "debuff", unit = "target"}, -- Physical Vulnerability
        { spell = 114198, type = "debuff", unit = "target"}, -- Mocking Banner
        { spell = 115798, type = "debuff", unit = "target"}, -- Weakened Blows
        { spell = 7922, type = "debuff", unit = "target"}, -- Charge Stun
        { spell = 132168, type = "debuff", unit = "target"}, -- Shockwave
        { spell = 676, type = "debuff", unit = "target"}, -- Disarm
        { spell = 1715, type = "debuff", unit = "target"}, -- Hamstring
        { spell = 355, type = "debuff", unit = "target"}, -- Taunt
        { spell = 64382, type = "debuff", unit = "target"}, -- Shattering Throw
        { spell = 86346, type = "debuff", unit = "target"}, -- Colossus Smash
        { spell = 107566, type = "debuff", unit = "target", talent = 7}, -- Staggering Shout
        { spell = 12323, type = "debuff", unit = "target", talent = 8}, -- Piercing Howl
        { spell = 118895, type = "debuff", unit = "target", talent = 12}, -- Dragon Roar
        { spell = 113344, type = "debuff", unit = "target", talent = 17}, -- Bloodbath
        { spell = 147531, type = "debuff", unit = "target", talent = 17}, -- Bloodbath
        { spell = 132169, type = "debuff", unit = "target", talent = 18}, -- Storm Bolt
      },
      icon = "Interface\\Icons\\Ability_golemthunderclap"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 23881, type = "ability", usable = true, requiresTarget = true }, -- Bloodthirst
        { spell = 85288, type = "ability", usable = true, requiresTarget = true }, -- Raging Blow
        { spell = 100130, type = "ability", usable = true, requiresTarget = true }, -- Wild Strike

        { spell = 86346, type = "ability", usable = true, requiresTarget = true }, -- Colossus Smash
        { spell = 118038, type = "ability", usable = true , buff = true }, -- Die by the Sword
        { spell = 1680, type = "ability", usable = true }, -- Whirlwind

        { spell = 78, type = "ability", usable = true, requiresTarget = true }, -- Heroic Strike
        { spell = 100, type = "ability", usable = true, requiresTarget = true }, -- Charge
        { spell = 355, type = "ability", usable = true, debuff = true, requiresTarget = true }, -- Taunt
        { spell = 469, type = "ability", usable = true , buff = true }, -- Commanding Shout
        { spell = 676, type = "ability", usable = true, debuff = true, requiresTarget = true }, -- Disarm
        { spell = 845, type = "ability", usable = true, requiresTarget = true }, -- Cleave
        { spell = 871, type = "ability", usable = true , buff = true }, -- Shield Wall
        { spell = 1715, type = "ability", usable = true, requiresTarget = true }, -- Hamstring
        { spell = 1719, type = "ability", usable = true , buff = true }, -- Recklessness
        { spell = 2457, type = "ability", usable = true }, -- Battle Stance
        { spell = 71, type = "ability", usable = true }, -- Defensive Stance
        { spell = 2458, type = "ability", usable = true }, -- Berserker Stance
        { spell = 3411, type = "ability", usable = true, requiresTarget = true }, -- Intervene
        { spell = 5246, type = "ability", usable = true }, -- Intimidating Shout
        { spell = 5308, type = "ability", usable = true, requiresTarget = true }, -- Execute
        { spell = 6343, type = "ability", usable = true }, -- Thunder Clap
        { spell = 6544, type = "ability", usable = true }, -- Heroic Leap
        { spell = 6673, type = "ability", usable = true , buff = true, requiresTarget = true }, -- Battle Shout
        { spell = 7386, type = "ability", usable = true, debuff = true }, -- Sunder Armor
        { spell = 18499, type = "ability", usable = true , buff = true }, -- Berserker Rage
        { spell = 23920, type = "ability", usable = true , buff = true }, -- Spell Reflection
        { spell = 57755, type = "ability", usable = true, requiresTarget = true }, -- Heroic Throw
        { spell = 64382, type = "ability", usable = true, requiresTarget = true }, -- Shattering Throw
        { spell = 97462, type = "ability", usable = true }, -- Rallying Cry
        { spell = 114192, type = "ability", usable = true , totem = true , buff = true }, -- Mocking Banner
        { spell = 114203, type = "ability", usable = true , totem = true }, -- Demoralizing Banner
        { spell = 114207, type = "ability", usable = true , totem = true }, -- Skull Banner
        { spell = 55694, type = "ability", usable = true , buff = true, talent = 4 }, -- Enraged Regeneration
        { spell = 103840, type = "ability", usable = true, talent = 6, requiresTarget = true }, -- Impending Victory
        { spell = 107566, type = "ability", usable = true, talent = 7 }, -- Staggering Shout
        { spell = 12323, type = "ability", usable = true, talent = 8 }, -- Piercing Howl
        { spell = 102060, type = "ability", usable = true, talent = 9 }, -- Disrupting Shout
        { spell = 46924, type = "ability", usable = true , buff = true, talent = 10 }, -- Bladestorm
        { spell = 46968, type = "ability", usable = true, talent = 11 }, -- Shockwave
        { spell = 118000, type = "ability", usable = true, talent = 12 }, -- Dragon Roar
        { spell = 114028, type = "ability", usable = true , buff = true, talent = 13 }, -- Mass Spell Reflection
        { spell = 114029, type = "ability", usable = true , debuff = true, talent = 14, requiresTarget = true }, -- Safeguard
        { spell = 114030, type = "ability", usable = true , debuff = true, talent = 15, requiresTarget = true }, -- Vigilance
        { spell = 107574, type = "ability", usable = true , buff = true, talent = 16 }, -- Avatar
        { spell = 12292, type = "ability", usable = true , buff = true, talent = 17 }, -- Bloodbath
        { spell = 107570, type = "ability", usable = true, talent = 18, requiresTarget = true }, -- Storm Bolt
      },
      icon = "Interface\\Icons\\Spell_nature_bloodlust"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\spell_misc_emotionangry",
    },
  },
  [3] = { -- Protection
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 12975, type = "buff", unit = "player"}, -- Last Stand
        { spell = 112048, type = "buff", unit = "player"}, -- Shield Barrier
        { spell = 125565, type = "buff", unit = "player"}, -- Demoralizing Shout
        { spell = 132404, type = "buff", unit = "player"}, -- Shield Block
        { spell = 145674, type = "buff", unit = "player"}, -- Riposte
        { spell = 132365, type = "buff", unit = "player"}, -- Vengeance
        { spell = 50227, type = "buff", unit = "player"}, -- Sword and Board

        { spell = 114192, type = "buff", unit = "player"}, -- Mocking Banner
        { spell = 18499, type = "buff", unit = "player"}, -- Berserker Rage
        { spell = 1719, type = "buff", unit = "player"}, -- Recklessness
        { spell = 871, type = "buff", unit = "player"}, -- Shield Wall
        { spell = 12880, type = "buff", unit = "player"}, -- Enrage
        { spell = 97463, type = "buff", unit = "player"}, -- Rallying Cry
        { spell = 6673, type = "buff", unit = "player", forceOwnOnly = true, ownOnly = nil}, -- Battle Shout
        { spell = 114206, type = "buff", unit = "player"}, -- Skull Banner
        { spell = 469, type = "buff", unit = "player", forceOwnOnly = true, ownOnly = nil}, -- Commanding Shout
        { spell = 23920, type = "buff", unit = "player"}, -- Spell Reflection
        { spell = 147833, type = "buff", unit = "target"}, -- Intervene
        { spell = 32216, type = "buff", unit = "player"}, -- Victorious
        { spell = 55694, type = "buff", unit = "player", talent = 4}, -- Enraged Regeneration
        { spell = 46924, type = "buff", unit = "player", talent = 10}, -- Bladestorm
        { spell = 114028, type = "buff", unit = "player", talent = 13}, -- Mass Spell Reflection
        { spell = 46947, type = "buff", unit = "target", talent = 14}, -- Safeguard
        { spell = 114029, type = "buff", unit = "target", talent = 14}, -- Safeguard
        { spell = 114030, type = "buff", unit = "target", talent = 15}, -- Vigilance
        { spell = 107574, type = "buff", unit = "player", talent = 16}, -- Avatar
        { spell = 12292, type = "buff", unit = "player", talent = 17}, -- Bloodbath
      },
      icon = "Interface\\Icons\\ability_warrior_shieldwall"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 115767, type = "debuff", unit = "target"}, -- Deep Wounds
        { spell = 1160, type = "debuff", unit = "target"}, -- Demoralizing Shout
        { spell = 115798, type = "debuff", unit = "target"}, -- Weakened Blows
        { spell = 1715, type = "debuff", unit = "target"}, -- Hamstring
        { spell = 113746, type = "debuff", unit = "target"}, -- Weakened Armor
        { spell = 355, type = "debuff", unit = "target"}, -- Taunt
        { spell = 64382, type = "debuff", unit = "target"}, -- Shattering Throw
        { spell = 5246, type = "debuff", unit = "target"}, -- Intimidating Shout
        { spell = 114205, type = "debuff", unit = "target"}, -- Demoralizing Banner
        { spell = 676, type = "debuff", unit = "target"}, -- Disarm
        { spell = 114198, type = "debuff", unit = "target"}, -- Mocking Banner
        { spell = 107566, type = "debuff", unit = "target", talent = 7}, -- Staggering Shout
        { spell = 12323, type = "debuff", unit = "target", talent = 8}, -- Piercing Howl
        { spell = 118895, type = "debuff", unit = "target", talent = 12}, -- Dragon Roar
        { spell = 113344, type = "debuff", unit = "target", talent = 17}, -- Bloodbath
        { spell = 147531, type = "debuff", unit = "target", talent = 17}, -- Bloodbath
        { spell = 132169, type = "debuff", unit = "target", talent = 18}, -- Storm Bolt
      },
      icon = "Interface\\Icons\\Ability_backstab"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 1160, type = "ability", usable = true }, -- Demoralizing Shout
        { spell = 6572, type = "ability", usable = true, requiresTarget = true }, -- Revenge
        { spell = 20243, type = "ability", usable = true, requiresTarget = true }, -- Devastate
        { spell = 12975, type = "ability", usable = true , buff = true }, -- Last Stand
        { spell = 23922, type = "ability", usable = true, requiresTarget = true }, -- Shield Slam
        { spell = 112048, type = "ability", usable = true , buff = true }, -- Shield Barrier
        { spell = 2565, type = "ability", charges = true , usable = true }, -- Shield Block

        { spell = 78, type = "ability", usable = true, requiresTarget = true }, -- Heroic Strike
        { spell = 100, type = "ability", usable = true, requiresTarget = true }, -- Charge
        { spell = 355, type = "ability", usable = true, debuff = true, requiresTarget = true }, -- Taunt
        { spell = 469, type = "ability", usable = true , buff = true }, -- Commanding Shout
        { spell = 676, type = "ability", usable = true, debuff = true, requiresTarget = true }, -- Disarm
        { spell = 845, type = "ability", usable = true, requiresTarget = true }, -- Cleave
        { spell = 871, type = "ability", usable = true , buff = true }, -- Shield Wall
        { spell = 1715, type = "ability", usable = true, requiresTarget = true }, -- Hamstring
        { spell = 1719, type = "ability", usable = true , buff = true }, -- Recklessness
        { spell = 2457, type = "ability", usable = true }, -- Battle Stance
        { spell = 71, type = "ability", usable = true }, -- Defensive Stance
        { spell = 2458, type = "ability", usable = true }, -- Berserker Stance
        { spell = 3411, type = "ability", usable = true, requiresTarget = true }, -- Intervene
        { spell = 5246, type = "ability", usable = true }, -- Intimidating Shout
        { spell = 5308, type = "ability", usable = true, requiresTarget = true }, -- Execute
        { spell = 6343, type = "ability", usable = true }, -- Thunder Clap
        { spell = 6544, type = "ability", usable = true }, -- Heroic Leap
        { spell = 6673, type = "ability", usable = true , buff = true, requiresTarget = true }, -- Battle Shout
        { spell = 7386, type = "ability", usable = true, debuff = true }, -- Sunder Armor
        { spell = 18499, type = "ability", usable = true , buff = true }, -- Berserker Rage
        { spell = 23920, type = "ability", usable = true , buff = true }, -- Spell Reflection
        { spell = 57755, type = "ability", usable = true, requiresTarget = true }, -- Heroic Throw
        { spell = 64382, type = "ability", usable = true, requiresTarget = true }, -- Shattering Throw
        { spell = 97462, type = "ability", usable = true }, -- Rallying Cry
        { spell = 114192, type = "ability", usable = true , totem = true , buff = true }, -- Mocking Banner
        { spell = 114203, type = "ability", usable = true , totem = true }, -- Demoralizing Banner
        { spell = 114207, type = "ability", usable = true , totem = true }, -- Skull Banner
        { spell = 55694, type = "ability", usable = true , buff = true, talent = 4 }, -- Enraged Regeneration
        { spell = 103840, type = "ability", usable = true, talent = 6, requiresTarget = true }, -- Impending Victory
        { spell = 107566, type = "ability", usable = true, talent = 7 }, -- Staggering Shout
        { spell = 12323, type = "ability", usable = true, talent = 8 }, -- Piercing Howl
        { spell = 102060, type = "ability", usable = true, talent = 9 }, -- Disrupting Shout
        { spell = 46924, type = "ability", usable = true , buff = true, talent = 10 }, -- Bladestorm
        { spell = 46968, type = "ability", usable = true, talent = 11 }, -- Shockwave
        { spell = 118000, type = "ability", usable = true, talent = 12 }, -- Dragon Roar
        { spell = 114028, type = "ability", usable = true , buff = true, talent = 13 }, -- Mass Spell Reflection
        { spell = 114029, type = "ability", usable = true , debuff = true, talent = 14, requiresTarget = true }, -- Safeguard
        { spell = 114030, type = "ability", usable = true , debuff = true, talent = 15, requiresTarget = true }, -- Vigilance
        { spell = 107574, type = "ability", usable = true , buff = true, talent = 16 }, -- Avatar
        { spell = 12292, type = "ability", usable = true , buff = true, talent = 17 }, -- Bloodbath
        { spell = 107570, type = "ability", usable = true, talent = 18, requiresTarget = true }, -- Storm Bolt
      },
      icon = "Interface\\Icons\\Inv_shield_05"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\spell_misc_emotionangry",
    }
  }
}

templates.class.PALADIN = {
  [1] = { -- Holy
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 465, type = "buff", unit = "player"}, -- Devotion Aura
        { spell = 498, type = "buff", unit = "player"}, -- Divine Protection
        { spell = 642, type = "buff", unit = "player"}, -- Divine Shield
        { spell = 1022, type = "buff", unit = "group"}, -- Blessing of Protection
        { spell = 1044, type = "buff", unit = "group"}, -- Blessing of Freedom
        { spell = 6940, type = "buff", unit = "group"}, -- Blessing of Sacrifice
        { spell = 31821, type = "buff", unit = "player"}, -- Aura Mastery
        { spell = 31884, type = "buff", unit = "player"}, -- Avenging Wrath
        { spell = 32223, type = "buff", unit = "player"}, -- Crusader Aura
        { spell = 53563, type = "buff", unit = "group"}, -- Beacon of Light
        { spell = 54149, type = "buff", unit = "player"}, -- Infusion of Light
        { spell = 105809, type = "buff", unit = "player"}, -- Holy Avenger
        { spell = 156910, type = "buff", unit = "group", talent = 20}, -- Beacon of Faith
        { spell = 183435, type = "buff", unit = "player"}, -- Retribution Aura
        { spell = 200025, type = "buff", unit = "group", talent = 21}, -- Beacon of Virtue
        { spell = 214202, type = "buff", unit = "player"}, -- Rule of Law
        { spell = 216331, type = "buff", unit = "player", talent = 17}, -- Avenging Crusader
        { spell = 221885, type = "buff", unit = "player"}, -- Divine Steed
        { spell = 223306, type = "buff", unit = "target", talent = 2}, -- Bestow Faith
        { spell = 287280, type = "buff", unit = "group", talent = 19}, -- Glimmer of Light
        { spell = 317920, type = "buff", unit = "player"}, -- Concentration Aura
      },
      icon = "Interface\\Icons\\Spell_holy_sealofprotection"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 853, type = "debuff", unit = "target"}, -- Hammer of Justice
        { spell = 10326, type = "debuff", unit = "target"}, -- Turn Evil
        { spell = 62124, type = "debuff", unit = "target"}, -- Hammer of Justice
        { spell = 20066, type = "debuff", unit = "multi", talent = 8}, -- Repentance
        { spell = 105421, type = "debuff", unit = "target", talent = 9}, -- Blinding Light
        { spell = 196941, type = "debuff", unit = "target", talent = 5}, -- Judgment of Light
        { spell = 204242, type = "debuff", unit = "target"}, -- Consecration
        { spell = 214222, type = "debuff", unit = "target"}, -- Judgment
      },
      icon = "Interface\\Icons\\Spell_holy_removecurse"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 498, type = "ability", buff = true}, -- Divine Protection
        { spell = 633, type = "ability"}, -- Lay on Hands
        { spell = 642, type = "ability", buff = true}, -- Divine Shield
        { spell = 853, type = "ability", requiresTarget = true}, -- Hammer of Justice
        { spell = 1022, type = "ability"}, -- Blessing of Protection
        { spell = 1044, type = "ability"}, -- Blessing of Freedom
        { spell = 4987, type = "ability"}, -- Cleanse
        { spell = 6940, type = "ability"}, -- Blessing of Sacrifice
        { spell = 10326, type = "ability"}, -- Turn Evil
        { spell = 20066, type = "ability", requiresTarget = true, talent = 8}, -- Repentance
        { spell = 20271, type = "ability", requiresTarget = true}, -- Hammer of Wrath
        { spell = 20473, type = "ability", overlayGlow = true}, -- Holy Shock
        { spell = 24275, type = "ability"}, -- Hammer of Wrath
        { spell = 26573, type = "ability", totem = true}, -- Consecration
        { spell = 31821, type = "ability", buff = true}, -- Aura Mastery
        { spell = 31821, type = "ability"}, -- Aura Mastery
        { spell = 31884, type = "ability", buff = true, talent = {16, 18}}, -- Avenging Wrath
        { spell = 35395, type = "ability", charges = true, requiresTarget = true}, -- Crusader Strike
        { spell = 53600, type = "ability"}, -- Shield of the Righteous
        { spell = 62124, type = "ability"}, -- Hand of Reckoning
        { spell = 85222, type = "ability", overlayGlow = true}, -- Light of Dawn
        { spell = 85673, type = "ability"}, -- Word of Glory
        { spell = 105809, type = "ability", buff = true, talent = 14}, -- Holy Avenger
        { spell = 114158, type = "ability", talent = 3}, -- Light's Hammer
        { spell = 114165, type = "ability", talent = 6}, -- Holy Prism
        { spell = 115750, type = "ability", talent = 9}, -- Blinding Light
        { spell = 152262, type = "ability", buff = true, talent = 15}, -- Seraphim
        { spell = 183998, type = "ability"}, -- Light of the Martyr
        { spell = 190784, type = "ability"}, -- Divine Steed
        { spell = 200025, type = "ability", talent = 21}, -- Beacon of Virtue
        { spell = 214202, type = "ability", charges = true, buff = true, talent = 12}, -- Rule of Law
        { spell = 216331, type = "ability", buff = true, talent = 17}, -- Avenging Crusader
        { spell = 223306, type = "ability", talent = 2}, -- Bestow Faith
        { spell = 275773, type = "ability", debuff = true, requiresTarget = true}, -- Judgment
      },
      icon = "Interface\\Icons\\Spell_holy_searinglight"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\inv_elemental_mote_mana",
    },
  },
  [2] = { -- Protection
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 465, type = "buff", unit = "player"}, -- Devotion Aura
        { spell = 642, type = "buff", unit = "player"}, -- Divine Shield
        { spell = 1022, type = "buff", unit = "group"}, -- Blessing of Protection
        { spell = 1044, type = "buff", unit = "group"}, -- Blessing of Freedom
        { spell = 6940, type = "buff", unit = "group"}, -- Blessing of Sacrifice
        { spell = 31850, type = "buff", unit = "player"}, -- Ardent Defender
        { spell = 31884, type = "buff", unit = "player"}, -- Avenging Wrath
        { spell = 32223, type = "buff", unit = "player"}, -- Crusader Aura
        { spell = 86659, type = "buff", unit = "player"}, -- Guardian of Ancient Kings
        { spell = 132403, type = "buff", unit = "player"}, -- Shield of the Righteous
        { spell = 152262, type = "buff", unit = "player", talent = 15}, -- Seraphim
        { spell = 182104, type = "buff", unit = "player"}, -- Shining Light
        { spell = 188370, type = "buff", unit = "player"}, -- Consecration
        { spell = 183435, type = "buff", unit = "player"}, -- Retribution Aura
        { spell = 197561, type = "buff", unit = "player"}, -- Avenger's Valor
        { spell = 204018, type = "buff", unit = "player", talent = 12}, -- Blessing of Spellwarding
        { spell = 221883, type = "buff", unit = "player"}, -- Divine Steed
        { spell = 280375, type = "buff", unit = "player", talent = 2}, -- Redoubt
        { spell = 317920, type = "buff", unit = "player"}, -- Concentration Aura
        { spell = 327225, type = "buff", unit = "player", talent = 4}, -- First Avenger
      },
      icon = "Interface\\Icons\\Ability_paladin_shieldofvengeance"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 853, type = "debuff", unit = "target"}, -- Hammer of Justice
        { spell = 20066, type = "debuff", unit = "multi", talent = 8}, -- Repentance
        { spell = 31935, type = "debuff", unit = "target"}, -- Avenger's Shield
        { spell = 62124, type = "debuff", unit = "target"}, -- Hand of Reckoning
        { spell = 105421, type = "debuff", unit = "target", talent = 9}, -- Blinding Light
        { spell = 196941, type = "debuff", unit = "target", talent = 18}, -- Judgment of Light
        { spell = 204079, type = "debuff", unit = "target", talent = 21}, -- Final Stand
        { spell = 204242, type = "debuff", unit = "target"}, -- Consecration
        { spell = 204301, type = "debuff", unit = "target", talent = 3}, -- Blessed Hammer
      },
      icon = "Interface\\Icons\\Spell_holy_removecurse"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 498, type = "ability"}, -- Ardent Defender
        { spell = 633, type = "ability"}, -- Lay on Hands
        { spell = 642, type = "ability", buff = true}, -- Divine Shield
        { spell = 853, type = "ability", requiresTarget = true}, -- Hammer of Justice
        { spell = 1022, type = "ability", buff = true}, -- Blessing of Protection
        { spell = 1044, type = "ability", buff = true}, -- Blessing of Freedom
        { spell = 6940, type = "ability", debuff = true, requiresTarget = true, unit="player"}, -- Blessing of Sacrifice
        { spell = 10326, type = "ability"}, -- Turn Evil
        { spell = 20066, type = "ability", requiresTarget = true, talent = 8}, -- Repentance
        { spell = 20271, type = "ability"}, -- Judgment
        { spell = 24275, type = "ability"}, -- Hammer of Wrath
        { spell = 26573, type = "ability", buff = true}, -- Consecration
        { spell = 31850, type = "ability", buff = true}, -- Ardent Defender
        { spell = 31884, type = "ability", buff = true}, -- Avenging Wrath
        { spell = 31935, type = "ability", requiresTarget = true, overlayGlow = true}, -- Avenger's Shield
        { spell = 35395, type = "ability"}, -- Hammer of the Righteous
        { spell = 53600, type = "ability", charges = true, buff = true}, -- Shield of the Righteous
        { spell = 62124, type = "ability", debuff = true, requiresTarget = true}, -- Hand of Reckoning
        { spell = 85673, type = "ability"}, -- Word of Glory
        { spell = 86659, type = "ability", buff = true}, -- Guardian of Ancient Kings
        { spell = 96231, type = "ability", requiresTarget = true}, -- Rebuke
        { spell = 105809, type = "ability", talent = 14}, -- Holy Avenger
        { spell = 115750, type = "ability", talent = 9}, -- Blinding Light
        { spell = 152262, type = "ability", buff = true, talent = 15}, -- Seraphim
        { spell = 190784, type = "ability"}, -- Divine Steed
        { spell = 204018, type = "ability", talent = 12}, -- Blessing of Spellwarding
        { spell = 204019, type = "ability", charges = true, debuff = true, talent = 3}, -- Blessed Hammer
        { spell = 213644, type = "ability"}, -- Cleanse Toxins
        { spell = 275779, type = "ability", debuff = true, requiresTarget = true}, -- Judgment
        { spell = 327193, type = "ability", buff = true, talent = 6}, -- Moment of Glory
      },
      icon = "Interface\\Icons\\Spell_holy_avengersshield"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\inv_elemental_mote_mana",
    },
  },
  [3] = { -- Retribution
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 465, type = "buff", unit = "player"}, -- Devotion Aura
        { spell = 642, type = "buff", unit = "player"}, -- Divine Shield
        { spell = 1022, type = "buff", unit = "group"}, -- Blessing of Protection
        { spell = 1044, type = "buff", unit = "group"}, -- Blessing of Freedom
        { spell = 31884, type = "buff", unit = "player"}, -- Avenging Wrath
        { spell = 32223, type = "buff", unit = "player"}, -- Crusader Aura
        { spell = 114250, type = "buff", unit = "player", talent = 16}, -- Selfless Healer
        { spell = 183435, type = "buff", unit = "player"}, -- Retribution Aura
        { spell = 184662, type = "buff", unit = "player"}, -- Shield of Vengeance
        { spell = 205191, type = "buff", unit = "player", talent = 12}, -- Eye for an Eye
        { spell = 209785, type = "buff", unit = "player", talent = 4}, -- Fires of Justice
        { spell = 221883, type = "buff", unit = "player"}, -- Divine Steed
        { spell = 223819, type = "buff", unit = "player", talent = 13}, -- Divine Purpose
        { spell = 267611, type = "buff", unit = "player", talent = 2}, -- Righteous Verdict
        { spell = 269571, type = "buff", unit = "player", talent = 1}, -- Zeal
        { spell = 281178, type = "buff", unit = "player", talent = 5}, -- Blade of Wrath
        { spell = 317920, type = "buff", unit = "player"}, -- Concentration Aura
        { spell = 326733, type = "buff", unit = "player", talent = 6}, -- Empyrean Power
      },
      icon = "Interface\\Icons\\Spell_magic_greaterblessingofkings"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 853, type = "debuff", unit = "target"}, -- Hammer of Justice
        { spell = 20066, type = "debuff", unit = "multi", talent = 8}, -- Repentance
        { spell = 62124, type = "debuff", unit = "target"}, -- Hand of Reckoning
        { spell = 105421, type = "debuff", unit = "target"}, -- Blinding Light
        { spell = 183218, type = "debuff", unit = "target"}, -- Hand of Hindrance
        { spell = 197277, type = "debuff", unit = "target"}, -- Judgment
        { spell = 255937, type = "debuff", unit = "target"}, -- Wake of Ashes
        { spell = 343527, type = "debuff", unit = "target", talent = 3}, -- Execution Sentence
        { spell = 343724, type = "debuff", unit = "target", talent = 21}, -- Reckoning
      },
      icon = "Interface\\Icons\\Spell_holy_removecurse"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 633, type = "ability"}, -- Lay on Hands
        { spell = 642, type = "ability", buff = true}, -- Divine Shield
        { spell = 853, type = "ability", requiresTarget = true}, -- Hammer of Justice
        { spell = 1022, type = "ability", buff = true}, -- Blessing of Protection
        { spell = 1044, type = "ability", buff = true}, -- Blessing of Freedom
        { spell = 6940, type = "ability", buff = true}, -- Blessing of Sacrifice
        { spell = 10326, type = "ability"}, -- Turn Evil
        { spell = 20066, type = "ability", requiresTarget = true, talent = 8}, -- Repentance
        { spell = 20271, type = "ability", debuff = true, requiresTarget = true}, -- Judgment
        { spell = 24275, type = "ability"}, -- Hammer of Wrath
        { spell = 26573, type = "ability"}, -- Consecration
        { spell = 31884, type = "ability", buff = true}, -- Avenging Wrath
        { spell = 35395, type = "ability", charges = true, requiresTarget = true}, -- Crusader Strike
        { spell = 53600, type = "ability", buff = true, requiresTarget = true}, -- Shield of the Righteous
        { spell = 53385, type = "ability"}, -- Divine Storm
        { spell = 62124, type = "ability", debuff = true, requiresTarget = true}, -- Hand of Reckoning
        { spell = 85256, type = "ability"}, -- Templar's Verdict
        { spell = 85673, type = "ability"}, -- Word of Glory
        { spell = 96231, type = "ability", requiresTarget = true}, -- Rebuke
        { spell = 105809, type = "ability", talent = 14}, -- Holy Avenger
        { spell = 115750, type = "ability", talent = 9}, -- Blinding Light
        { spell = 152262, type = "ability", talent = 15, buff = true}, -- Seraphim
        { spell = 183218, type = "ability", debuff = true, requiresTarget = true}, -- Hand of Hindrance
        { spell = 184575, type = "ability", requiresTarget = true, overlayGlow = true}, -- Blade of Justice
        { spell = 184662, type = "ability", buff = true}, -- Shield of Vengeance
        { spell = 190784, type = "ability"}, -- Divine Steed
        { spell = 205191, type = "ability", buff = true, talent = 12}, -- Eye for an Eye
        { spell = 205228, type = "ability", totem = true}, -- Consecration
        { spell = 213644, type = "ability"}, -- Cleanse Toxins
        { spell = 215661, type = "ability", requiresTarget = true, talent = 17}, -- Justiciar's Vengeance
        { spell = 231895, type = "ability", buff = true, talent = 20}, -- Crusade
        { spell = 255937, type = "ability", debuff = true, requiresTarget = true}, -- Wake of Ashes
        { spell = 343527, type = "ability", debuff = true, requiresTarget = true, talent = 3}, -- Execution Sentence
      },
      icon = "Interface\\Icons\\Spell_holy_crusaderstrike"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\achievement_bg_winsoa",
    },
  },
}

templates.class.HUNTER = {
  [1] = { -- Beast Master
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 136, type = "buff", unit = "pet"}, -- Mend Pet
        { spell = 5384, type = "buff", unit = "player"}, -- Feign Death
        { spell = 6197, type = "buff", unit = "player"}, -- Eagle Eye
        { spell = 19574, type = "buff", unit = "player"}, -- Bestial Wrath
        { spell = 24450, type = "buff", unit = "pet"}, -- Prowl
        { spell = 35079, type = "buff", unit = "player"}, -- Misdirection
        { spell = 118922, type = "buff", unit = "player", talent = 14}, -- Posthaste
        { spell = 186258, type = "buff", unit = "player"}, -- Aspect of the Cheetah
        { spell = 186265, type = "buff", unit = "player"}, -- Aspect of the Turtle
        { spell = 193530, type = "buff", unit = "player"}, -- Aspect of the Wild
        { spell = 199483, type = "buff", unit = "player"}, -- Camouflage
        { spell = 231390, type = "buff", unit = "player", talent = 7}, -- Trailblazer
        { spell = 217200, type = "buff", unit = "player"}, -- Barbed Shot
        { spell = 257946, type = "buff", unit = "player", talent = 11}, -- Thrill of the Hunt
        { spell = 264663, type = "buff", unit = "player"}, -- Predator's Thirst
        { spell = 264667, type = "buff", unit = "player"}, -- Primal Rage
        { spell = 268877, type = "buff", unit = "player"}, -- Beast Cleave
        { spell = 272790, type = "buff", unit = "pet"}, -- Frenzy
        { spell = 281036, type = "buff", unit = "player", talent = 3}, -- Dire Beast
      },
      icon = "Interface\\Icons\\Ability_mount_jungletiger"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 2649, type = "debuff", unit = "target"}, -- Growl
        { spell = 3355, type = "debuff", unit = "multi"}, -- Freezing Trap
        { spell = 5116, type = "debuff", unit = "target"}, -- Concussive Shot
        { spell = 24394, type = "debuff", unit = "target"}, -- Intimidation
        { spell = 117405, type = "debuff", unit = "target", talent = 15}, -- Binding Shot
        { spell = 131894, type = "debuff", unit = "target"}, -- A Murder of Crows
        { spell = 135299, type = "debuff", unit = "target"}, -- Tar Trap
        { spell = 217200, type = "debuff", unit = "target"}, -- Barbed Shot
        { spell = 257284, type = "debuff", unit = "target"}, -- Hunter's Mark
      },
      icon = "Interface\\Icons\\Spell_frost_stun"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 781, type = "ability"}, -- Disengage
        { spell = 1513, type = "ability"}, -- Scare Beast
        { spell = 1543, type = "ability"}, -- Flare
        { spell = 2643, type = "ability", requiresTarget = true}, -- Multi-Shot
        { spell = 2649, type = "ability", requiresTarget = true, debuff = true}, -- Growl
        { spell = 5116, type = "ability", requiresTarget = true}, -- Concussive Shot
        { spell = 5384, type = "ability", buff = true}, -- Feign Death
        { spell = 6197, type = "ability", buff = true}, -- Eagle Eye
        { spell = 16827, type = "ability", requiresTarget = true}, -- Claw
        { spell = 19574, type = "ability", buff = true}, -- Bestial Wrath
        { spell = 19577, type = "ability", requiresTarget = true, debuff = true}, -- Intimidation
        { spell = 19801, type = "ability", requiresTarget = true}, -- Tranquilizing Shot
        { spell = 24450, type = "ability"}, -- Prowl
        { spell = 34026, type = "ability", requiresTarget = true}, -- Kill Command
        { spell = 34477, type = "ability", requiresTarget = true}, -- Misdirection
        { spell = 53209, type = "ability", requiresTarget = true, talent = 6}, -- Chimaera Shot
        { spell = 53351, type = "ability", requiresTarget = true}, -- Kill Shot
        { spell = 56641, type = "ability", requiresTarget = true}, -- Cobra Shot
        { spell = 58875, type = "ability",  unit = "pet", buff = true}, -- Spirit Walk
        { spell = 90361, type = "ability",  unit = "pet", buff = true}, -- Spirit Mend
        { spell = 109248, type = "ability", requiresTarget = true, talent = 15}, -- Binding Shot
        { spell = 109304, type = "ability"}, -- Exhilaration
        { spell = 120360, type = "ability", talent = 17}, -- Barrage
        { spell = 120679, type = "ability", requiresTarget = true, buff = true, talent = 3}, -- Dire Beast
        { spell = 131894, type = "ability", requiresTarget = true, talent = 12}, -- A Murder of Crows
        { spell = 147362, type = "ability", requiresTarget = true}, -- Counter Shot
        { spell = 185358, type = "ability"}, -- Arcane Shot
        { spell = 186257, type = "ability", buff = true}, -- Aspect of the Cheetah
        { spell = 186265, type = "ability", buff = true}, -- Aspect of the Turtle
        { spell = 187650, type = "ability"}, -- Freezing Trap
        { spell = 187698, type = "ability"}, -- Tar Trap
        { spell = 193530, type = "ability", buff = true}, -- Aspect of the Wild
        { spell = 195645, type = "ability", debuff = true}, -- Concussive Shot
        { spell = 199483, type = "ability", talent = 9}, -- Camouflage
        { spell = 201430, type = "ability", talent = 18}, -- Stampede
        { spell = 217200, type = "ability", charges = true, requiresTarget = true, overlayGlow = true}, -- Barbed Shot
        { spell = 272651, type = "ability"}, -- Command Pet Ability
        { spell = 257284, type = "ability", debuff = true, requiresTarget = true}, -- Hunter's Mark
        { spell = 264667, type = "ability", buff = true}, -- Primal Rage
        { spell = 264735, type = "ability", unit = "pet", buff = true}, -- Survival of the Fittest
        { spell = 321297, type = "ability", buff = true}, -- Eyes of the Beast
        { spell = 321530, type = "ability", debuff = true}, -- Bloodshedew
      },
      icon = "Interface\\Icons\\Inv_spear_07"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\ability_hunter_focusfire",
    },
  },
  [2] = { -- Marksmanship
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 136, type = "buff", unit = "pet"}, -- Mend Pet
        { spell = 5384, type = "buff", unit = "player"}, -- Feign Death
        { spell = 6197, type = "buff", unit = "player"}, -- Eagle Eye
        { spell = 24450, type = "buff", unit = "pet"}, -- Prowl
        { spell = 35079, type = "buff", unit = "player"}, -- Misdirection
        { spell = 118922, type = "buff", unit = "player", talent = 14}, -- Posthaste
        { spell = 164273, type = "buff", unit = "player"}, -- Lone Wolf
        { spell = 186258, type = "buff", unit = "player"}, -- Aspect of the Cheetah
        { spell = 186265, type = "buff", unit = "player"}, -- Aspect of the Turtle
        { spell = 193534, type = "buff", unit = "player", talent = 10}, -- Steady Focus
        { spell = 194594, type = "buff", unit = "player", talent = 20}, -- Lock and Load
        { spell = 199483, type = "buff", unit = "player", talent = 9}, -- Camouflage
        { spell = 231390, type = "buff", unit = "player", talent = 7}, -- Trailblazer
        { spell = 257044, type = "buff", unit = "player"}, -- Rapid Fire
        { spell = 257622, type = "buff", unit = "player"}, -- Trick Shots
        { spell = 260242, type = "buff", unit = "player"}, -- Precise Shots
        { spell = 260395, type = "buff", unit = "player", talent = 16}, -- Lethal Shots
        { spell = 260402, type = "buff", unit = "player", talent = 18}, -- Double Tap
        { spell = 264663, type = "buff", unit = "player"}, -- Predator's Thirst
        { spell = 264667, type = "buff", unit = "player"}, -- Primal Rage
        { spell = 264735, type = "ability", unit = "pet", buff = true}, -- Survival of the Fittest
        { spell = 288613, type = "buff", unit = "player"}, -- Trueshot
        { spell = 321461, type = "buff", unit = "player", talent = 17}, -- Dead Eye
      },
      icon = "Interface\\Icons\\Ability_hunter_focusfire"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 3355, type = "debuff", unit = "multi"}, -- Freezing Trap
        { spell = 5116, type = "debuff", unit = "target"}, -- Concussive Shot
        { spell = 131894, type = "debuff", unit = "target", talent = 3}, -- A Murder of Crows
        { spell = 135299, type = "debuff", unit = "target"}, -- Tar Trap
        { spell = 186387, type = "debuff", unit = "target"}, -- Bursting Shot
        { spell = 257284, type = "debuff", unit = "target", talent = 12}, -- Hunter's Mark
        { spell = 269576, type = "debuff", unit = "target", talent = 1}, -- Master Marksman
        { spell = 271788, type = "debuff", unit = "target", talent = 2}, -- Serpent Sting
        { spell = 321469, type = "debuff", unit = "target", talent = 15}, -- Binding Shackles
      },
      icon = "Interface\\Icons\\Ability_hunter_markedfordeath"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 781, type = "ability"}, -- Disengage
        { spell = 1513, type = "ability", debuff = true}, -- Scare Beast
        { spell = 1543, type = "ability"}, -- Flare
        { spell = 5116, type = "ability", requiresTarget = true}, -- Concussive Shot
        { spell = 5384, type = "ability", buff = true}, -- Feign Death
        { spell = 6197, type = "ability", buff = true}, -- Eagle Eye
        { spell = 19434, type = "ability", requiresTarget = true, charges = true, overlayGlow = true}, -- Aimed Shot
        { spell = 19801, type = "ability", requiresTarget = true}, -- Tranquilizing Shot
        { spell = 34477, type = "ability", requiresTarget = true}, -- Misdirection
        { spell = 53351, type = "ability", requiresTarget = true}, -- Kill Shot
        { spell = 56641, type = "ability", requiresTarget = true}, -- Steady Shot
        { spell = 109248, type = "ability", requiresTarget = true}, -- Binding Shot
        { spell = 109304, type = "ability"}, -- Exhilaration
        { spell = 120360, type = "ability", talent = 5}, -- Barrage
        { spell = 131894, type = "ability", talent = 3}, -- A Murder of Crows
        { spell = 147362, type = "ability", requiresTarget = true}, -- Counter Shot
        { spell = 185358, type = "ability", requiresTarget = true, overlayGlow = true}, -- Arcane Shot
        { spell = 186257, type = "ability", buff = true}, -- Aspect of the Cheetah
        { spell = 186265, type = "ability", buff = true}, -- Aspect of the Turtle
        { spell = 186387, type = "ability", debuff = true}, -- Bursting Shot
        { spell = 187650, type = "ability"}, -- Freezing Trap
        { spell = 187698, type = "ability"}, -- Tar Trap
        { spell = 195645, type = "ability", debuff = true}, -- Concussive Shot
        { spell = 199483, type = "ability", talent = 9}, -- Camouflage
        { spell = 212431, type = "ability", talent = 6}, -- Explosive Shot
        { spell = 257044, type = "ability", requiresTarget = true, overlayGlow = true}, -- Rapid Fire
        { spell = 257284, type = "ability", requiresTarget = true}, -- Hunter's Mark
        { spell = 257620, type = "ability", requiresTarget = true}, -- Multi-Shot
        { spell = 260243, type = "ability", talent = 21}, -- Volley
        { spell = 260402, type = "ability", buff = true, talent = 18}, -- Double Tap
        { spell = 264667, type = "ability", buff = true}, -- Primal Rage
        { spell = 264735, type = "ability", unit = "pet", buff = true}, -- Survival of the Fittest
        { spell = 271788, type = "ability", debuff = true, talent = 2}, -- Serpent Sting
        { spell = 272651, type = "ability"}, -- Command Pet Ability
        { spell = 288613, type = "ability", buff = true}, -- Trueshot
        { spell = 321297, type = "ability"}, -- Eyes of the Beast
        { spell = 342049, type = "ability", talent = 12}, -- Chimaera Shot
      },
      icon = "Interface\\Icons\\Ability_trueshot"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\ability_hunter_focusfire",
    },
  },
  [3] = { -- Survival
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 136, type = "buff", unit = "pet"}, -- Mend Pet
        { spell = 5384, type = "buff", unit = "player"}, -- Feign Death
        { spell = 6197, type = "buff", unit = "player"}, -- Eagle Eye
        { spell = 24450, type = "buff", unit = "pet"}, -- Prowl
        { spell = 35079, type = "buff", unit = "player"}, -- Misdirection
        { spell = 61684, type = "buff", unit = "pet"}, -- Dash
        { spell = 118922, type = "buff", unit = "player", talent = 14 }, -- Posthaste
        { spell = 186258, type = "buff", unit = "player"}, -- Aspect of the Cheetah
        { spell = 186265, type = "buff", unit = "player"}, -- Aspect of the Turtle
        { spell = 186289, type = "buff", unit = "player"}, -- Aspect of the Eagle
        { spell = 199483, type = "buff", unit = "player", talent = 9}, -- Camouflage
        { spell = 225788, type = "buff", unit = "player"}, -- Sign of the Emissary
        { spell = 231390, type = "buff", unit = "player", talent = 7 }, -- Trailblazer
        { spell = 259388, type = "buff", unit = "player", talent = 17 }, -- Mongoose Fury
        { spell = 260249, type = "buff", unit = "pet"}, -- Predator
        { spell = 260249, type = "buff", unit = "player"}, -- Predator
        { spell = 260286, type = "buff", unit = "player", talent = 16 }, -- Tip of the Spear
        { spell = 263892, type = "buff", unit = "pet"}, -- Catlike Reflexes
        { spell = 264663, type = "buff", unit = "pet"}, -- Predator's Thirst
        { spell = 264663, type = "buff", unit = "player"}, -- Predator's Thirst
        { spell = 264667, type = "buff", unit = "player"}, -- Primal Rage
        { spell = 265898, type = "buff", unit = "player", talent = 2 }, -- Terms of Engagement
        { spell = 266779, type = "buff", unit = "pet"}, -- Coordinated Assault
        { spell = 266779, type = "buff", unit = "player"}, -- Coordinated Assault
        { spell = 268552, type = "buff", unit = "player", talent = 1 }, -- Viper's Venom

      },
      icon = "Interface\\Icons\\ability_hunter_misdirection"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 2649, type = "debuff", unit = "target"}, -- Growl
        { spell = 3355, type = "debuff", unit = "multi"}, -- Freezing Trap
        { spell = 24394, type = "debuff", unit = "target"}, -- Intimidation
        { spell = 117405, type = "debuff", unit = "target", talent = 15 }, -- Binding Shot
        { spell = 131894, type = "debuff", unit = "target", talent = 12 }, -- A Murder of Crows
        { spell = 135299, type = "debuff", unit = "target"}, -- Tar Trap
        { spell = 162480, type = "debuff", unit = "target"}, -- Steel Trap
        { spell = 162487, type = "debuff", unit = "target", talent = 11 }, -- Steel Trap
        { spell = 190927, type = "debuff", unit = "target"}, -- Harpoon
        { spell = 195645, type = "debuff", unit = "target"}, -- Wing Clip
        { spell = 259277, type = "debuff", unit = "target", talent = 10 }, -- Kill Command
        { spell = 259491, type = "debuff", unit = "target"}, -- Serpent Sting
        { spell = 269747, type = "debuff", unit = "target"}, -- Wildfire Bomb
        { spell = 270332, type = "debuff", unit = "target", talent = 20 }, -- Pheromone Bomb
        { spell = 270339, type = "debuff", unit = "target", talent = 20 }, -- Shrapnel Bomb
        { spell = 270343, type = "debuff", unit = "target"}, -- Internal Bleeding
        { spell = 271049, type = "debuff", unit = "target"}, -- Volatile Bomb

      },
      icon = "Interface\\Icons\\Ability_rogue_trip"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 781, type = "ability"}, -- Disengage
        { spell = 1513, type = "ability", debuff = true}, -- Scare Beast
        { spell = 1543, type = "ability"}, -- Flare
        { spell = 2649, type = "ability", requiresTarget = true, debuff = true}, -- Growl
        { spell = 5384, type = "ability", buff = true}, -- Feign Death
        { spell = 6197, type = "ability", buff = true}, -- Eagle Eye
        { spell = 16827, type = "ability", requiresTarget = true}, -- Claw
        { spell = 19434, type = "ability", requiresTarget = true}, -- Aimed Shot
        { spell = 19577, type = "ability", requiresTarget = true, debuff = true}, -- Intimidation
        { spell = 19801, type = "ability", requiresTarget = true}, -- Tranquilizing Shot
        { spell = 24450, type = "ability"}, -- Prowl
        { spell = 34477, type = "ability", requiresTarget = true}, -- Misdirection
        { spell = 56641, type = "ability", requiresTarget = true}, -- Steady Shot
        { spell = 61684, type = "ability"}, -- Dash
        { spell = 109248, type = "ability"}, -- Binding Shot
        { spell = 109304, type = "ability"}, -- Exhilaration
        { spell = 131894, type = "ability", talent = 12}, -- A Murder of Crows
        { spell = 162488, type = "ability", talent = 11}, -- Steel Trap
        { spell = 185358, type = "ability"}, -- Arcane Shot
        { spell = 186257, type = "ability", buff = true}, -- Aspect of the Cheetah
        { spell = 186265, type = "ability", buff = true}, -- Aspect of the Turtle
        { spell = 186270, type = "ability"}, -- Raptor Strike
        { spell = 186289, type = "ability", buff = true}, -- Aspect of the Eagle
        { spell = 187650, type = "ability"}, -- Freezing Trap
        { spell = 187698, type = "ability"}, -- Tar Trap
        { spell = 187707, type = "ability", requiresTarget = true}, -- Muzzle
        { spell = 187708, type = "ability"}, -- Carve
        { spell = 190925, type = "ability", requiresTarget = true}, -- Harpoon
        { spell = 195645, type = "ability", requiresTarget = true}, -- Wing Clip
        { spell = 199483, type = "ability", talent = 9}, -- Camouflage
        { spell = 212436, type = "ability", charges = true, talent = 6 }, -- Butchery
        { spell = 257284, type = "ability", debuff = true}, -- Hunter's Mark
        { spell = 259391, type = "ability", requiresTarget = true, talent = 21 }, -- Chakrams
        { spell = 259489, type = "ability", requiresTarget = true, overlayGlow = true}, -- Kill Command
        { spell = 259491, type = "ability", requiresTarget = true, overlayGlow = true}, -- Serpent Sting
        { spell = 259495, type = "ability", requiresTarget = true}, -- Wildfire Bomb
        { spell = 263892, type = "ability"}, -- Catlike Reflexes
        { spell = 264667, type = "ability", buff = true}, -- Primal Rage
        { spell = 266779, type = "ability", buff = true}, -- Coordinated Assault
        { spell = 269751, type = "ability", requiresTarget = true, talent = 18 }, -- Flanking Strike
        { spell = 270323, type = "ability", talent = 20 }, -- Pheromone Bomb
        { spell = 270335, type = "ability", talent = 20}, -- Shrapnel Bomb
        { spell = 271045, type = "ability", talent = 20}, -- Volatile Bomb
        { spell = 272651, type = "ability"}, -- Command Pet
        { spell = 321297, type = "ability"}, -- Eyes of the Beast
        { spell = 320976, type = "ability", requiresTarget = true}, -- Kill Shot
      },
      icon = "Interface\\Icons\\Ability_hunter_invigeration"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\ability_hunter_focusfire",
    },
  },
}

templates.class.ROGUE = {
  [1] = { -- Assassination
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 1784, type = "buff", unit = "player"}, -- Stealth
        { spell = 1966, type = "buff", unit = "player"}, -- Feint
        { spell = 2823, type = "buff", unit = "player"}, -- Deadly Poison
        { spell = 2983, type = "buff", unit = "player"}, -- Sprint
        { spell = 3408, type = "buff", unit = "player"}, -- Crippling Poison
        { spell = 5277, type = "buff", unit = "player"}, -- Evasion
        { spell = 5761, type = "buff", unit = "player"}, -- Numbing Poison
        { spell = 8679, type = "buff", unit = "player"}, -- Wound Poison
        { spell = 11327, type = "buff", unit = "player"}, -- Vanish
        { spell = 31224, type = "buff", unit = "player"}, -- Cloak of Shadows
        { spell = 32645, type = "buff", unit = "player"}, -- Envenom
        { spell = 36554, type = "buff", unit = "player"}, -- Shadowstep
        { spell = 45182, type = "buff", unit = "player", talent = 11 }, -- Cheating Death
        { spell = 57934, type = "buff", unit = "player"}, -- Tricks of the Trade
        { spell = 108211, type = "buff", unit = "player", talent = 10}, -- Leeching Poison
        { spell = 114018, type = "buff", unit = "player"}, -- Shroud of Concealment
        { spell = 115192, type = "buff", unit = "player", talent = 5}, -- Subterfuge
        { spell = 121153, type = "buff", unit = "player", talent = 3}, -- Blindside
        { spell = 185311, type = "buff", unit = "player"}, -- Crimson Vial
        { spell = 193538, type = "buff", unit = "player", talent = 17}, -- Alacrity
        { spell = 193641, type = "buff", unit = "player", talent = 2}, -- Elaborate Planning
        { spell = 256735, type = "buff", unit = "player", talent = 6}, -- Master Assassin
        { spell = 270070, type = "buff", unit = "player", talent = 20}, -- Hidden Blades
        { spell = 315496, type = "buff"}, -- Slice and Dice
      },
      icon = "Interface\\Icons\\Ability_rogue_dualweild"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 408, type = "debuff", unit = "target"}, -- Kidney Shot
        { spell = 703, type = "debuff", unit = "target"}, -- Garrote
        { spell = 1330, type = "debuff", unit = "target"}, -- Garrote - Silence
        { spell = 1833, type = "debuff", unit = "target"}, -- Cheap Shot
        { spell = 1943, type = "debuff", unit = "target"}, -- Rupture
        { spell = 2094, type = "debuff", unit = "multi"}, -- Blind
        { spell = 2818, type = "debuff", unit = "target"}, -- Deadly Poison
        { spell = 3409, type = "debuff", unit = "target"}, -- Crippling Poison
        { spell = 6770, type = "debuff", unit = "multi"}, -- Sap
        { spell = 8680, type = "debuff", unit = "target"}, -- Wound Poison
        { spell = 45181, type = "debuff", unit = "player", talent = 11 }, -- Cheated Death
        { spell = 79140, type = "debuff", unit = "target"}, -- Vendetta
        { spell = 121411, type = "debuff", unit = "target", talent = 21}, -- Crimson Tempest
        { spell = 137619, type = "debuff", unit = "target", talent = 9}, -- Marked for Death
        { spell = 154953, type = "debuff", unit = "target", talent = 13}, -- Internal Bleeding
        { spell = 256148, type = "debuff", unit = "target", talent = 14}, -- Iron Wire
        { spell = 255909, type = "debuff", unit = "target", talent = 15}, -- Prey on the Weak
      },
      icon = "Interface\\Icons\\Ability_rogue_rupture"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 408, type = "ability", requiresTarget = true, usable = true, debuff = true}, -- Kidney Shot
        { spell = 703, type = "ability", requiresTarget = true, debuff = true}, -- Garrote
        { spell = 1725, type = "ability"}, -- Distract
        { spell = 1752, type = "ability", requiresTarget = true}, -- Sinister Strike / Mutilate
        { spell = 1766, type = "ability", requiresTarget = true}, -- Kick
        { spell = 1784, type = "ability", buff = true}, -- Stealth
        { spell = 1833, type = "ability", usable = true, requiresTarget = true, debuff = true}, -- Cheap Shot
        { spell = 1856, type = "ability", buff = true}, -- Vanish
        { spell = 1943, type = "ability", requiresTarget = true, usable = true, debuff = true}, -- Rupture
        { spell = 1966, type = "ability", buff = true}, -- Feint
        { spell = 2094, type = "ability", requiresTarget = true}, -- Blind
        { spell = 2983, type = "ability", buff = true}, -- Sprint
        { spell = 5277, type = "ability", buff = true}, -- Evasion
        { spell = 5938, type = "ability", requiresTarget = true}, -- Shiv
        { spell = 6770, type = "ability", usable = true, requiresTarget = true, debuff = true}, -- Sap
        { spell = 8676, type = "ability"}, -- Ambush
        { spell = 31224, type = "ability", buff = true}, -- Cloak of Shadows
        { spell = 36554, type = "ability", requiresTarget = true}, -- Shadowstep
        { spell = 51723, type = "ability"}, -- Fan of Knives
        { spell = 57934, type = "ability", requiresTarget = true}, -- Tricks of the Trade
        { spell = 79140, type = "ability", requiresTarget = true, debuff = true}, -- Vendetta
        { spell = 114018, type = "ability", usable = true, buff = true}, -- Shroud of Concealment
        { spell = 115191, type = "ability", buff = true}, -- Stealth
        { spell = 121411, type = "ability"}, -- Crimson Tempest
        { spell = 137619, type = "ability", requiresTarget = true, debuff = true, talent = 9}, -- Marked for Death
        { spell = 185311, type = "ability", buff = true}, -- Crimson Vial
        { spell = 185565, type = "ability"}, -- Poisoned Knife
        { spell = 196819, type = "ability", requiresTarget = true, usable = true, debuff = true}, -- Envenom
        { spell = 200806, type = "ability", requiresTarget = true, usable = true, talent = 18}, -- Exsanguinate
        { spell = 315496, type = "ability"}, -- Slice and Dice
      },
      icon = "Interface\\Icons\\Ability_warrior_punishingblow"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\inv_mace_2h_pvp410_c_01",
    },
  },
  [2] = { -- Combat
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 1784, type = "buff", unit = "player"}, -- Stealth
        { spell = 1966, type = "buff", unit = "player"}, -- Feint
        { spell = 2983, type = "buff", unit = "player"}, -- Sprint
        { spell = 3408, type = "buff", unit = "player"}, -- Crippling Poison
        { spell = 5277, type = "buff", unit = "player"}, -- Evasion
        { spell = 5761, type = "buff", unit = "player"}, -- Numbing Poison
        { spell = 8679, type = "buff", unit = "player"}, -- Wound Poison
        { spell = 11327, type = "buff", unit = "player"}, -- Vanish
        { spell = 13750, type = "buff", unit = "player"}, -- Adrenaline Rush
        { spell = 13877, type = "buff", unit = "player"}, -- Blade Flurry
        { spell = 31224, type = "buff", unit = "player"}, -- Cloak of Shadows
        { spell = 45182, type = "buff", unit = "player", talent = 11 }, -- Cheating Death
        { spell = 51690, type = "buff", unit = "player", talent = 21}, -- Killing Spree
        { spell = 57934, type = "buff", unit = "player"}, -- Tricks of the Trade
        { spell = 13750, type = "buff", unit = "player"}, -- Adrenaline Rush
        { spell = 114018, type = "buff", unit = "player"}, -- Shroud of Concealment
        { spell = 185311, type = "buff", unit = "player"}, -- Crimson Vial
        { spell = 193357, type = "buff", unit = "player"}, -- Ruthless Precision
        { spell = 193358, type = "buff", unit = "player"}, -- Grand Melee
        { spell = 193538, type = "buff", unit = "player", talent = 17}, -- Alacrity
        { spell = 193359, type = "buff", unit = "player"}, -- True Bearing
        { spell = 199600, type = "buff", unit = "player"}, -- Buried Treasure
        { spell = 199603, type = "buff", unit = "player"}, -- Skull and Crossbones
        { spell = 199754, type = "buff", unit = "player"}, -- Riposte
        { spell = 195627, type = "buff", unit = "player"}, -- Opportunity
        { spell = 193356, type = "buff", unit = "player"}, -- Broadside
        { spell = 271896, type = "buff", unit = "player", talent = 20}, -- Blade Rush
        { spell = 315496, type = "buff"}, -- Slice and Dice
        { spell = 315584, type = "buff", unit = "player"}, -- Instant Poison
      },
      icon = "Interface\\Icons\\Ability_warrior_punishingblow"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 408, type = "debuff", unit = "target"}, -- Kindney Shot
        { spell = 1776, type = "debuff", unit = "target"}, -- Gouge
        { spell = 1833, type = "debuff", unit = "target"}, -- Cheap Shot
        { spell = 2094, type = "debuff", unit = "multi"}, -- Blind
        { spell = 6770, type = "debuff", unit = "multi"}, -- Sap
        { spell = 45181, type = "debuff", unit = "player", talent = 11 }, -- Cheated Death
        { spell = 137619, type = "debuff", unit = "target", talent = 9}, -- Marked for Death
        { spell = 185763, type = "debuff", unit = "target"}, -- Pistol Shot
        { spell = 199804, type = "debuff", unit = "target"}, -- Between the Eyes
        { spell = 196937, type = "debuff", unit = "target", talent = 3}, -- Ghostly Strike
        { spell = 255909, type = "debuff", unit = "target", talent = 15}, -- Prey on the Weak
      },
      icon = "Interface\\Icons\\ability_cheapshot"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 408, type = "ability"}, -- Kindney Shot
        { spell = 1725, type = "ability"}, -- Distract
        { spell = 1752, type = "ability", requiresTarget = true}, -- Sinister Strike
        { spell = 1766, type = "ability", requiresTarget = true}, -- Kick
        { spell = 1776, type = "ability", requiresTarget = true, debuff = true}, -- Gouge
        { spell = 1784, type = "ability", buff = true}, -- Stealth
        { spell = 1833, type = "ability", debuff = true}, -- Cheap Shot
        { spell = 1856, type = "ability", buff = true}, -- Vanish
        { spell = 1966, type = "ability", buff = true}, -- Feint
        { spell = 2094, type = "ability", requiresTarget = true, debuff = true}, -- Blind
        { spell = 2098, type = "ability", requiresTarget = true, usable = true}, -- Dispatch
        { spell = 2983, type = "ability", buff = true }, -- Sprint
        { spell = 5277, type = "ability", buff = true }, -- Evasion
        { spell = 5938, type = "ability"}, -- Shiv
        { spell = 6770, type = "ability", debuff = true }, -- Sap
        { spell = 8676, type = "ability", requiresTarget = true, usable = true}, -- Ambush
        { spell = 13750, type = "ability", buff = true}, -- Adrenaline Rush
        { spell = 13877, type = "ability", buff = true, charges = true}, -- Blade Flurry
        { spell = 31224, type = "ability", buff = true}, -- Cloak of Shadows
        { spell = 51690, type = "ability", requiresTarget = true, talent = 21}, -- Killing Spree
        { spell = 57934, type = "ability", requiresTarget = true, debuff = true}, -- Tricks of the Trade
        { spell = 57934, type = "ability", requiresTarget = true}, -- Tricks of the Trade
        { spell = 79096, type = "ability"}, -- Restless Blades
        { spell = 114018, type = "ability", usable = true, buff = true}, -- Shroud of Concealment
        { spell = 137619, type = "ability", requiresTarget = true, debuff = true, talent = 9}, -- Marked for Death
        { spell = 185311, type = "ability", buff = true}, -- Crimson Vial
        { spell = 185763, type = "ability", requiresTarget = true}, -- Pistol Shot
        { spell = 195457, type = "ability", requiresTarget = true}, -- Grappling Hook
        { spell = 196937, type = "ability", requiresTarget = true, debuff = true, talent = 3}, -- Ghostly Strike
        { spell = 199754, type = "ability", buff = true}, -- Riposte
        { spell = 196819, type = "ability"}, -- Dispatch
        { spell = 199804, type = "ability", usable = true, requiresTarget = true}, -- Between the Eyes
        { spell = 271877, type = "ability", buff = true, talent = 20}, -- Blade Rush
        { spell = 315496, type = "ability", buff = true}, -- Slice and Dice
        { spell = 315341, type = "ability", debuff = true}, -- Between the Eyes
        { spell = 315508, type = "ability", requiresTarget = true, usable = true}, -- Roll the Bones
        { spell = 343142, type = "ability", requiresTarget = true}, -- Dreadblades
      },
      icon = "Interface\\Icons\\Inv_weapon_rifle_01"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\inv_mace_2h_pvp410_c_01",
    },
  },
  [3] = { -- Subtlety
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 1784, type = "buff", unit = "player"}, -- Stealth
        { spell = 1966, type = "buff", unit = "player"}, -- Feint
        { spell = 2983, type = "buff", unit = "player"}, -- Sprint
        { spell = 3408, type = "buff", unit = "player"}, -- Crippling Poison
        { spell = 5277, type = "buff", unit = "player"}, -- Evasion
        { spell = 5761, type = "buff", unit = "player"}, -- Numbing Poison
        { spell = 8679, type = "buff", unit = "player"}, -- Wound Poison
        { spell = 11327, type = "buff", unit = "player"}, -- Vanish
        { spell = 31224, type = "buff", unit = "player"}, -- Cloak of Shadows
        { spell = 45182, type = "buff", unit = "player", talent = 11 }, -- Cheating Death
        { spell = 57934, type = "buff", unit = "player"}, -- Tricks of the Trade
        { spell = 114018, type = "buff", unit = "player"}, -- Shroud of Concealment
        { spell = 115191, type = "buff", unit = "player"}, -- Stealth
        { spell = 115192, type = "buff", unit = "player", talent = 5}, -- Subterfuge
        { spell = 121471, type = "buff", unit = "player"}, -- Shadow Blades
        { spell = 185311, type = "buff", unit = "player"}, -- Crimson Vial
        { spell = 185422, type = "buff", unit = "player"}, -- Shadow Dance
        { spell = 196980, type = "buff", unit = "player", talent = 19}, -- Master of Shadows
        { spell = 212283, type = "buff", unit = "player"}, -- Symbols of Death
        { spell = 257506, type = "buff", unit = "player", talent = 13}, -- Shot in the Dark
        { spell = 277925, type = "buff", unit = "player", talent = 21}, -- Shuriken Tornado
        { spell = 193538, type = "buff", unit = "player", talent = 17}, -- Alacrity
        { spell = 245640, type = "buff", unit = "player"}, -- Shuriken Combo
        { spell = 315496, type = "buff", unit = "player"}, -- Slice and Dice
        { spell = 315584, type = "buff", unit = "player"}, -- Instant Poison
        { spell = 343173, type = "buff", unit = "player", talent = 2}, -- Premeditation
      },
      icon = "Interface\\Icons\\Inv_knife_1h_grimbatolraid_d_03"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 408, type = "debuff", unit = "target"}, -- Kidney Shot
        { spell = 1833, type = "debuff", unit = "target"}, -- Cheap Shot
        { spell = 2094, type = "debuff", unit = "multi"}, -- Blind
        { spell = 6770, type = "debuff", unit = "multi"}, -- Sap
        { spell = 45181, type = "debuff", unit = "player", talent = 11 }, -- Cheated Death
        { spell = 91021, type = "debuff", unit = "target"}, -- Find Weakness
        { spell = 137619, type = "debuff", unit = "target", talent = 9}, -- Marked for Death
        { spell = 195452, type = "debuff", unit = "target"}, -- Nightblade
        { spell = 206760, type = "debuff", unit = "target", talent = 14}, -- Shadow's Grasp
        { spell = 255909, type = "debuff", unit = "target", talent = 15}, -- Prey on the Weak
      },
      icon = "Interface\\Icons\\Spell_shadow_mindsteal"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 408, type = "ability", requiresTarget = true, usable = true, debuff = true}, -- Kidney Shot
        { spell = 1725, type = "ability"}, -- Distract
        { spell = 1752, type = "ability", requiresTarget = true}, -- Backstab
        { spell = 1766, type = "ability", requiresTarget = true}, -- Kick
        { spell = 1784, type = "ability", buff = true}, -- Stealth
        { spell = 1833, type = "ability", usable = true, requiresTarget = true, debuff = true}, -- Cheap Shot
        { spell = 1856, type = "ability", buff = true}, -- Vanish
        { spell = 1943, type = "ability", debuff = true}, -- Rupture
        { spell = 1966, type = "ability", buff = true}, -- Feint
        { spell = 2094, type = "ability", requiresTarget = true, debuff = true}, -- Blind
        { spell = 2983, type = "ability", buff = true}, -- Sprint
        { spell = 5277, type = "ability", buff = true}, -- Evasion
        { spell = 5938, type = "ability"}, -- Shiv
        { spell = 6770, type = "ability", requiresTarget = true, usable = true, debuff = true}, -- Sap
        { spell = 8676, type = "ability", requiresTarget = true, usable = true}, -- Shadowstrike
        { spell = 57934, type = "ability", requiresTarget = true}, -- Tricks of the Trade
        { spell = 57934, type = "ability", requiresTarget = true, debuff = true}, -- Tricks of the Trade
        { spell = 31224, type = "ability", buff = true}, -- Cloak of Shadows
        { spell = 36554, type = "ability", charges = true, requiresTarget = true}, -- Shadowstep
        { spell = 114014, type = "ability", requiresTarget = true}, -- Shuriken Toss
        { spell = 114018, type = "ability", usable = true, buff = true}, -- Shroud of Concealment
        { spell = 115191, type = "ability", buff = true}, -- Stealth
        { spell = 121471, type = "ability", buff = true}, -- Shadow Blades
        { spell = 137619, type = "ability", requiresTarget = true, debuff = true, talent = 9}, -- Marked for Death
        { spell = 185311, type = "ability", buff = true}, -- Crimson Vial
        { spell = 185313, type = "ability", charges = true, buff = true}, -- Shadow Dance
        { spell = 185438, type = "ability", requiresTarget = true, usable = true}, -- Kidney Shot
        { spell = 195452, type = "ability", usable = true, requiresTarget = true, debuff = true}, -- Nightblade
        { spell = 196819, type = "ability", usable = true, requiresTarget = true}, -- Eviscerate
        { spell = 197835, type = "ability"}, -- Shuriken Storm
        { spell = 200758, type = "ability"}, -- Gloomblade
        { spell = 212283, type = "ability", buff = true}, -- Symbols of Death
        { spell = 277925, type = "ability", buff = true, talent = 21}, -- Shuriken Tornado
        { spell = 280719, type = "ability", requiresTarget = true, usable = true, debuff = true, talent = 20}, -- Secret Technique
        { spell = 315496, type = "ability", buff = true}, -- Slice and Dice
        { spell = 319175, type = "ability", buff = true}, -- Shadow Vault
      },
      icon = "Interface\\Icons\\Ability_rogue_shadowdance"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\inv_mace_2h_pvp410_c_01",
    },
  },
}

templates.class.PRIEST = {
  [1] = { -- Discipline
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 17, type = "buff", unit = "target"}, -- Power Word: Shield
        { spell = 586, type = "buff", unit = "player"}, -- Fade
        { spell = 2096, type = "buff", unit = "player"}, -- Mind Vision
        { spell = 10060, type = "buff", unit = "player"}, -- Power Infusion
        { spell = 19236, type = "buff", unit = "player"}, -- Desperate Prayer
        { spell = 21562, type = "buff", unit = "player", forceOwnOnly = true, ownOnly = nil }, -- Power Word: Fortitude
        { spell = 33206, type = "buff", unit = "group"}, -- Pain Suppression
        { spell = 47536, type = "buff", unit = "player"}, -- Rapture
        { spell = 45243, type = "buff", unit = "player" }, -- Focused Will
        { spell = 65081, type = "buff", unit = "player", talent = 4}, -- Body and Soul
        { spell = 81782, type = "buff", unit = "target"}, -- Power Word: Barrier
        { spell = 109964, type = "buff", unit = "player"}, -- Spirit Shell
        { spell = 111759, type = "buff", unit = "player"}, -- Levitate
        { spell = 121557, type = "buff", unit = "player", talent = 6}, -- Angelic Feather
        { spell = 193065, type = "buff", unit = "player", talent = 5}, -- Masochism
        { spell = 194384, type = "buff", unit = "group"}, -- Atonement
        { spell = 198069, type = "buff", unit = "player"}, -- Power of the Dark Side
        { spell = 265258, type = "buff", unit = "player", talent = 2}, -- Twist of Fate
        { spell = 280398, type = "buff", unit = "player", talent = 13}, -- Sins of the Many
      },
      icon = "Interface\\Icons\\Spell_holy_powerwordshield"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 589, type = "debuff", unit = "target"}, -- Shadow Word: Pain
        { spell = 2096, type = "debuff", unit = "target"}, -- Mind Vision
        { spell = 8122, type = "debuff", unit = "target"}, -- Psychic Scream
        { spell = 9484, type = "debuff", unit = "multi" }, -- Shackle Undead
        { spell = 204263, type = "debuff", unit = "target", talent = 12}, -- Shining Force
        { spell = 208772, type = "debuff", unit = "target"}, -- Smite
        { spell = 204213, type = "debuff", unit = "target", talent = 16}, -- Purge the Wicked
        { spell = 214621, type = "debuff", unit = "target", talent = 3}, -- Schism
      },
      icon = "Interface\\Icons\\Spell_shadow_shadowwordpain"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 17, type = "ability"}, -- Power Word: Shield
        { spell = 453, type = "ability"}, -- Mind Soothe
        { spell = 527, type = "ability"}, -- Purify
        { spell = 528, type = "ability"}, -- Dispel Magic
        { spell = 585, type = "ability"}, -- Smite
        { spell = 586, type = "ability", buff = true}, -- Fade
        { spell = 605, type = "ability"}, -- Mind Control
        { spell = 1706, type = "ability", buff = true}, -- Levitate
        { spell = 2061, type = "ability", overlayGlow = true}, -- Shadow Mend
        { spell = 2096, type = "ability"}, -- Mind Vision
        { spell = 2006, type = "ability"}, -- Resurrection
        { spell = 8092, type = "ability", requiresTarget = true}, -- Mind Blast
        { spell = 8122, type = "ability"}, -- Psychic Scream
        { spell = 9484, type = "ability", debuff = true}, -- Shackle Undead
        { spell = 10060, type = "ability"}, -- Power Infusion
        { spell = 19236, type = "ability", buff = true}, -- Desperate Prayer
        { spell = 32375, type = "ability"}, -- Mass Dispel
        { spell = 32379, type = "ability", charges = true, usable = true, requiresTarget = true}, -- Shadow Word: Death
        { spell = 33206, type = "ability"}, -- Pain Suppression
        { spell = 34433, type = "ability", totem = true, requiresTarget = true}, -- Shadowfiend
        { spell = 47536, type = "ability", buff = true}, -- Rapture
        { spell = 47540, type = "ability", requiresTarget = true}, -- Penance
        { spell = 48045, type = "ability", requiresTarget = true}, -- Mind Sear
        { spell = 62618, type = "ability"}, -- Power Word: Barrier
        { spell = 73325, type = "ability"}, -- Leap of Faith
        { spell = 109964, type = "ability", buff = true, talent = 20}, -- Divine Star
        { spell = 110744, type = "ability", talent = 17}, -- Divine Star
        { spell = 120517, type = "ability", talent = 18}, -- Halo
        { spell = 121536, type = "ability", charges = true, buff = true, talent = 6}, -- Angelic Feather
        { spell = 123040, type = "ability", totem = true, requiresTarget = true, talent = 8}, -- Mindbender
        { spell = 129250, type = "ability", requiresTarget = true, talent = 9}, -- Power Word: Solace
        { spell = 132157, type = "ability"}, -- Holy Nova
        { spell = 194509, type = "ability", charges = true}, -- Power Word: Radiance
        { spell = 204197, type = "ability", talent = 16}, -- Purge the Wicked
        { spell = 204263, type = "ability", talent = 12}, -- Shining Force
        { spell = 212036, type = "ability"}, -- Mass Resurrection
        { spell = 214621, type = "ability", requiresTarget = true, debuff = true, talent = 3}, -- Schism
        { spell = 246287, type = "ability", talent = 21}, -- Evangelism
        { spell = 314867, type = "ability", talent = 15}, -- Shadow Covenant
      },
      icon = "Interface\\Icons\\Spell_shadow_unholyfrenzy"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\inv_elemental_mote_mana",
    },
  },
  [2] = { -- Holy
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 17, type = "buff", unit = "player"}, -- Power Word: Shield
        { spell = 139, type = "buff", unit = "target"}, -- Renew
        { spell = 586, type = "buff", unit = "player"}, -- Fade
        { spell = 2096, type = "buff", unit = "player"}, -- Mind Vision
        { spell = 10060, type = "buff", unit = "player"}, -- Power Infusion
        { spell = 19236, type = "buff", unit = "player"}, -- Desperate Prayer
        { spell = 21562, type = "buff", unit = "player", forceOwnOnly = true, ownOnly = nil }, -- Power Word: Fortitude
        { spell = 27827, type = "buff", unit = "player"}, -- Spirit of Redemption
        { spell = 41635, type = "buff", unit = "group"}, -- Prayer of Mending
        { spell = 45243, type = "buff", unit = "player" }, -- Focused Will
        { spell = 47788, type = "buff", unit = "target"}, -- Guardian Spirit
        { spell = 64843, type = "buff", unit = "player"}, -- Divine Hymn
        { spell = 64901, type = "buff", unit = "player"}, -- Symbol of Hope
        { spell = 65081, type = "buff", unit = "player"}, -- Body and Soul
        { spell = 77489, type = "buff", unit = "target"}, -- Echo of Light
        { spell = 111759, type = "buff", unit = "player"}, -- Levitate
        { spell = 114255, type = "buff", unit = "player", talent = 13}, -- Surge of Light
        { spell = 121557, type = "buff", unit = "player", talent = 6}, -- Angelic Feather
        { spell = 200183, type = "buff", unit = "player", talent = 20}, -- Apotheosis
        { spell = 321379, type = "buff", unit = "player", talent = 15}, -- Prayer Circle
      },
      icon = "Interface\\Icons\\Spell_holy_renew"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 589, type = "debuff", unit = "target"}, -- Shadow Word: Pain
        { spell = 2096, type = "debuff", unit = "target"}, -- Mind Vision
        { spell = 8122, type = "debuff", unit = "target"}, -- Psychic Scream
        { spell = 9484, type = "debuff", unit = "multi" }, -- Shackle Undead
        { spell = 14914, type = "debuff", unit = "target"}, -- Holy Fire
        { spell = 200200, type = "debuff", unit = "target"}, -- Holy Word: Chastise
        { spell = 200196, type = "debuff", unit = "target"}, -- Holy Word: Chastise
        { spell = 204263, type = "debuff", unit = "target"}, -- Shining Force
      },
      icon = "Interface\\Icons\\Spell_holy_searinglight"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 17, type = "ability"}, -- Power Word: Shield
        { spell = 139, type = "ability"}, -- Renew
        { spell = 527, type = "ability"}, -- Purify
        { spell = 453, type = "ability"}, -- Mind Soothe
        { spell = 528, type = "ability"}, -- Dispel Magic
        { spell = 585, type = "ability"}, -- Smite
        { spell = 586, type = "ability", buff = true}, -- Fade
        { spell = 589, type = "ability"}, -- Shadow Word: Pain
        { spell = 596, type = "ability"}, -- Prayer of Healing
        { spell = 605, type = "ability"}, -- Mind Control
        { spell = 1706, type = "ability"}, -- Levitate
        { spell = 2006, type = "ability"}, -- Resurrection
        { spell = 2050, type = "ability"}, -- Holy Word: Serenity
        { spell = 2060, type = "ability"}, -- Heal
        { spell = 2061, type = "ability"}, -- Flash Heal
        { spell = 2096, type = "ability"}, -- Mind Vision
        { spell = 8092, type = "ability", requiresTarget = true}, -- Holy Fire
        { spell = 8122, type = "ability"}, -- Psychic Scream
        { spell = 9484, type = "ability"}, -- Shackle Undead
        { spell = 10060, type = "ability", buff = true}, -- Power Infusion
        { spell = 14914, type = "ability", requiresTarget = true}, -- Holy Fire
        { spell = 19236, type = "ability", buff = true}, -- Desperate Prayer
        { spell = 32375, type = "ability"}, -- Mass Dispel
        { spell = 32379, type = "ability"}, -- Shadow Word: Death
        { spell = 32379, type = "ability", charges = true, usable = true, requiresTarget = true}, -- Shadow Word: Death
        { spell = 32546, type = "ability"}, -- Binding Heal
        { spell = 33076, type = "ability"}, -- Prayer of Mending
        { spell = 34861, type = "ability"}, -- Holy Word: Sanctify
        { spell = 47788, type = "ability"}, -- Guardian Spirit
        { spell = 64843, type = "ability", buff = true}, -- Divine Hymn
        { spell = 64901, type = "ability", buff = true}, -- Symbol of Hope
        { spell = 73325, type = "ability"}, -- Leap of Faith
        { spell = 88625, type = "ability", requiresTarget = true, debuff = true}, -- Holy Word: Chastise
        { spell = 110744, type = "ability", talent = 17}, -- Divine Star
        { spell = 120517, type = "ability", talent = 18}, -- Halo
        { spell = 121536, type = "ability", charges = true, buff = true, talent = 6}, -- Angelic Feather
        { spell = 132157, type = "ability"}, -- Holy Nova
        { spell = 200183, type = "ability", buff = true, talent = 20}, -- Apotheosis
        { spell = 204263, type = "ability", talent = 12}, -- Shining Force
        { spell = 204883, type = "ability"}, -- Circle of Healing
        { spell = 212036, type = "ability"}, -- Mass Resurrection
        { spell = 265202, type = "ability", talent = 21}, -- Holy Word: Salvation

      },
      icon = "Interface\\Icons\\Spell_holy_persuitofjustice"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\inv_elemental_mote_mana",
    },
  },
  [3] = { -- Shadow
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 17, type = "buff", unit = "player"}, -- Power Word: Shield
        { spell = 586, type = "buff", unit = "player"}, -- Fade
        { spell = 2096, type = "buff", unit = "player"}, -- Mind Vision
        { spell = 10060, type = "buff", unit = "player"}, -- Power Infusion
        { spell = 15286, type = "buff", unit = "player"}, -- Vampiric Embrace
        { spell = 19236, type = "buff", unit = "player"}, -- Desperate Prayer
        { spell = 21562, type = "buff", unit = "player", forceOwnOnly = true, ownOnly = nil }, -- Power Word: Fortitude
        { spell = 45243, type = "buff", unit = "player" }, -- Focused Will
        { spell = 47585, type = "buff", unit = "player"}, -- Dispersion
        { spell = 65081, type = "buff", unit = "player", talent = 4}, -- Body and Soul
        { spell = 111759, type = "buff", unit = "player"}, -- Levitate
        { spell = 124430, type = "buff", unit = "player", talent = 2}, -- Shadowy Insight
        { spell = 123254, type = "buff", unit = "player", talent = 7}, -- Twist of Fate
        { spell = 193223, type = "buff", unit = "player", talent = 21}, -- Surrender to Madness
        { spell = 194249, type = "buff", unit = "player"}, -- Voidform
        { spell = 197937, type = "buff", unit = "player", talent = 16}, -- Lingering Insanity
        { spell = 232698, type = "buff", unit = "player"}, -- Shadowform
        { spell = 263165, type = "buff", unit = "player", talent = 18}, -- Void Torrent
        { spell = 319952, type = "buff", unit = "player", talent = 21}, -- Surrender to Madness
        { spell = 321973, type = "buff", unit = "player", talent = 2}, -- Death and Madness
        { spell = 341207, type = "buff", unit = "player"}, -- Dark Thoughts
        { spell = 341282, type = "buff", unit = "player", talent = 3}, -- Unfurling Darkness
      },
      icon = "Interface\\Icons\\Spell_shadow_mindtwisting"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 589, type = "debuff", unit = "target"}, -- Shadow Word: Pain
        { spell = 2096, type = "debuff", unit = "target"}, -- Mind Vision
        { spell = 8122, type = "debuff", unit = "target"}, -- Psychic Scream
        { spell = 9484, type = "debuff", unit = "multi" }, -- Shackle Undead
        { spell = 15407, type = "debuff", unit = "target"}, -- Mind Flay
        { spell = 15487, type = "debuff", unit = "target"}, -- Silence
        { spell = 34914, type = "debuff", unit = "target"}, -- Vampiric Touch
        { spell = 48045, type = "debuff", unit = "target"}, -- Mind Sear
        { spell = 64044, type = "debuff", unit = "target"}, -- Psychic Horror
        { spell = 205369, type = "debuff", unit = "target", talent = 11}, -- Mind Bomb
        { spell = 226943, type = "debuff", unit = "target", talent = 11}, -- Mind Bomb
        { spell = 263165, type = "debuff", unit = "target", talent = 18}, -- Void Torrent
        { spell = 335467, type = "debuff", unit = "target"}, -- Devouring Plague
        { spell = 341291, type = "debuff", unit = "player", talent = 3}, -- Unfurling Darkness
      },
      icon = "Interface\\Icons\\Spell_shadow_shadowwordpain"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 17, type = "ability", buff = true}, -- Power Word: Shield
        { spell = 453, type = "ability"}, -- Mind Soothe
        { spell = 528, type = "ability"}, -- Dispel Magic
        { spell = 585, type = "ability"}, -- Mind Flay
        { spell = 586, type = "ability", buff = true}, -- Fade
        { spell = 589, type = "ability", debuff = true}, -- Shadow Word: Pain
        { spell = 605, type = "ability", buff = true}, -- Mind Control
        { spell = 1706, type = "ability", buff = true}, -- Levitate
        { spell = 2006, type = "ability"}, -- Resurrection
        { spell = 2096, type = "ability"}, -- Mind Vision
        { spell = 2061, type = "ability"}, -- Shadow Mend
        { spell = 8092, type = "ability", requiresTarget = true}, -- Mind Blast
        { spell = 8122, type = "ability"}, -- Psychic Scream
        { spell = 9484, type = "ability"}, -- Shackle Undead
        { spell = 10060, type = "ability", buff = true}, -- Power Infusion
        { spell = 15286, type = "ability", buff = true}, -- Vampiric Embrace
        { spell = 15487, type = "ability", requiresTarget = true}, -- Silence
        { spell = 19236, type = "ability", buff = true}, -- Desperate Prayer
        { spell = 32379, type = "ability"}, -- Shadow Word: Death
        { spell = 32375, type = "ability"}, -- Mass Dispel
        { spell = 34915, type = "ability", debuff = true}, -- Vampiric Touch
        { spell = 32379, type = "ability", charges = true, usable = true, requiresTarget = true}, -- Shadow Word: Death
        { spell = 34433, type = "ability", totem = true, requiresTarget = true}, -- Shadowfiend
        { spell = 47585, type = "ability", buff = true}, -- Dispersion
        { spell = 48045, type = "ability"}, -- Mind Sear
        { spell = 64044, type = "ability", requiresTarget = true, talent = 12}, -- Psychic Horror
        { spell = 73325, type = "ability"}, -- Leap of Faith
        { spell = 200174, type = "ability", totem = true, requiresTarget = true, talent = 17}, -- Mindbender
        { spell = 205351, type = "ability", charges = true, requiresTarget = true, talent = 3}, -- Shadow Word: Void
        { spell = 205369, type = "ability", requiresTarget = true, talent = 11}, -- Mind Bomb
        { spell = 205448, type = "ability", usable = true, requiresTarget = true}, -- Void Bolt
        { spell = 213634, type = "ability"}, -- Purify Disease
        { spell = 228260, type = "ability", requiresTarget = true}, -- Void Eruption
        { spell = 263165, type = "ability", requiresTarget = true, talent = 18}, -- Void Torrent
        { spell = 263346, type = "ability", requiresTarget = true, talent = 9}, -- Dark Void
        { spell = 319952, type = "ability", talent = 21}, -- Surrender to Madness
        { spell = 341374, type = "ability", talent = 16}, -- Damnation
        { spell = 341385, type = "ability", requiresTarget = true, usable = true, talent = 9}, -- Searing Nightmares
        { spell = 342834, type = "ability", talent = 15}, -- Shadow Crash
        { spell = 335467, type = "ability", requiresTarget = true, usable = true, debuff = true}, -- Devouring Plague
      },
      icon = "Interface\\Icons\\Spell_shadow_unsummonbuilding"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\spell_priest_shadoworbs",
    },
  },
}

templates.class.SHAMAN = {
  [1] = { -- Elemental
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 30823, type = "buff", unit = "player"}, -- Shamanistic Rage
        { spell = 324, type = "buff", unit = "player"}, -- Lightning Shield
        { spell = 6196, type = "buff", unit = "player"}, -- Far Sight
        { spell = 2825, type = "buff", unit = "player"}, -- Bloodlust
        { spell = 73683, type = "buff", unit = "player"}, -- Unleash Flame
        { spell = 2645, type = "buff", unit = "player"}, -- Ghost Wolf
        { spell = 16246, type = "buff", unit = "player"}, -- Clearcasting
        { spell = 77762, type = "buff", unit = "player"}, -- Lava Surge
        { spell = 73920, type = "buff", unit = "player"}, -- Healing Rain
        { spell = 8178, type = "buff", unit = "player"}, -- Grounding Totem Effect
        { spell = 120676, type = "buff", unit = "player"}, -- Stormlash Totem
        { spell = 114050, type = "buff", unit = "player"}, -- Ascendance
        { spell = 52127, type = "buff", unit = "player"}, -- Water Shield
        { spell = 79206, type = "buff", unit = "player"}, -- Spiritwalker's Grace
        { spell = 114893, type = "buff", unit = "player", talent = 2 }, -- Stone Bulwark
        { spell = 108271, type = "buff", unit = "player", talent = 3 }, -- Astral Shift
        { spell = 114896, type = "buff", unit = "player", talent = 6 }, -- Windwalk Totem
        { spell = 16166, type = "buff", unit = "player", talent = 10 }, -- Elemental Mastery
        { spell = 16188, type = "buff", unit = "player", talent = 11 }, -- Ancestral Swiftness
        { spell = 108281, type = "buff", unit = "player", talent = 14 }, -- Ancestral Guidance
        { spell = 118474, type = "buff", unit = "player", talent = 16 }, -- Unleashed Fury
        { spell = 118475, type = "buff", unit = "player", talent = 16 }, -- Unleashed Fury
        { spell = 118350, type = "buff", unit = "player", talent = 17 }, -- Empower
        { spell = 118347, type = "buff", unit = "player", talent = 17 }, -- Reinforce
        { spell = 118337, type = "buff", unit = "target", talent = 17 }, -- Harden Skin
        { spell = 118522, type = "buff", unit = "player", talent = 18 }, -- Elemental Blast
      },
      icon = "Interface\\Icons\\Spell_frost_windwalkon"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 77478, type = "debuff", unit = "target"}, -- Earthquake
        { spell = 115798, type = "debuff", unit = "target"}, -- Weakened Blows
        { spell = 8056, type = "debuff", unit = "target"}, -- Frost Shock
        { spell = 3600, type = "debuff", unit = "target"}, -- Earthbind
        { spell = 51490, type = "debuff", unit = "target"}, -- Thunderstorm
        { spell = 8034, type = "debuff", unit = "target"}, -- Frostbrand Attack
        { spell = 8050, type = "debuff", unit = "target"}, -- Flame Shock
        { spell = 61882, type = "debuff", unit = "target"}, -- Earthquake
        { spell = 76780, type = "debuff", unit = "target"}, -- Bind Elemental
        { spell = 73682, type = "debuff", unit = "target"}, -- Unleash Frost
        { spell = 73684, type = "debuff", unit = "target"}, -- Unleash Earth
        { spell = 51514, type = "debuff", unit = "target"}, -- Hex
        { spell = 63685, type = "debuff", unit = "target", talent = 4 }, -- Freeze
        { spell = 116947, type = "debuff", unit = "target", talent = 5 }, -- Earthbind
        { spell = 64695, type = "debuff", unit = "target", talent = 5 }, -- Earthgrab
        { spell = 118470, type = "debuff", unit = "target", talent = 16 }, -- Unleashed Fury
        { spell = 118297, type = "debuff", unit = "target", talent = 17 }, -- Immolate
        { spell = 118345, type = "debuff", unit = "target", talent = 17 }, -- Pulverize
      },
      icon = "Interface\\Icons\\Spell_fire_flameshock"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 370, type = "ability", usable = true, requiresTarget = true }, -- Purge
        { spell = 403, type = "ability", usable = true, requiresTarget = true }, -- Lightning Bolt
        { spell = 421, type = "ability", usable = true, requiresTarget = true }, -- Chain Lightning
        { spell = 546, type = "ability", usable = true }, -- Water Walking
        { spell = 556, type = "ability", usable = true }, -- Astral Recall
        { spell = 1064, type = "ability", usable = true }, -- Chain Heal
        { spell = 2008, type = "ability", usable = true, requiresTarget = true }, -- Ancestral Spirit
        { spell = 2645, type = "ability", usable = true , buff = true }, -- Ghost Wolf
        { spell = 2825, type = "ability", usable = true , buff = true }, -- Bloodlust
        { spell = 6196, type = "ability", usable = true , buff = true }, -- Far Sight
        { spell = 8004, type = "ability", usable = true }, -- Healing Surge
        { spell = 8042, type = "ability", usable = true, requiresTarget = true }, -- Earth Shock
        { spell = 8050, type = "ability", usable = true, requiresTarget = true }, -- Flame Shock
        { spell = 8056, type = "ability", usable = true, requiresTarget = true }, -- Frost Shock
        { spell = 30823, type = "ability", usable = true , buff = true }, -- Shamanistic Rage
        { spell = 51490, type = "ability", usable = true }, -- Thunderstorm
        { spell = 51505, type = "ability", usable = true, requiresTarget = true }, -- Lava Burst
        { spell = 51514, type = "ability", usable = true, requiresTarget = true }, -- Hex
        { spell = 51886, type = "ability", usable = true }, -- Cleanse Spirit
        { spell = 57994, type = "ability", usable = true, requiresTarget = true }, -- Wind Shear
        { spell = 61882, type = "ability", usable = true }, -- Earthquake
        { spell = 73680, type = "ability", usable = true, requiresTarget = true }, -- Unleash Elements
        { spell = 73899, type = "ability", usable = true, requiresTarget = true }, -- Primal Strike
        { spell = 73920, type = "ability", usable = true , buff = true }, -- Healing Rain
        { spell = 76780, type = "ability", usable = true, requiresTarget = true }, -- Bind Elemental
        { spell = 79206, type = "ability", usable = true , buff = true }, -- Spiritwalker's Grace
        { spell = 114049, type = "ability", usable = true }, -- Ascendance
        { spell = 2062, type = "ability", usable = true , totem = true }, -- Earth Elemental Totem
        { spell = 2484, type = "ability", usable = true , totem = true }, -- Earthbind Totem
        { spell = 2894, type = "ability", usable = true , totem = true }, -- Fire Elemental Totem
        { spell = 3599, type = "ability", usable = true , totem = true }, -- Searing Totem
        { spell = 5394, type = "ability", usable = true , totem = true }, -- Healing Stream Totem
        { spell = 8143, type = "ability", usable = true , totem = true }, -- Tremor Totem
        { spell = 8177, type = "ability", usable = true , totem = true }, -- Grounding Totem
        { spell = 8190, type = "ability", usable = true , totem = true }, -- Magma Totem
        { spell = 108280, type = "ability", usable = true , totem = true }, -- Healing Tide Totem
        { spell = 120668, type = "ability", usable = true , totem = true }, -- Stormlash Totem
        { spell = 108270, type = "ability", talent = 2 , usable = true , totem = true }, -- Stone Bulwark Totem
        { spell = 108271, type = "ability", talent = 3 , usable = true , buff = true }, -- Astral Shift
        { spell = 51485, type = "ability", talent = 5 , usable = true , totem = true }, -- Earthgrab Totem
        { spell = 108273, type = "ability", talent = 6, usable = true , totem = true }, -- Windwalk Totem
        { spell = 108285, type = "ability", talent = 7 , usable = true }, -- Call of the Elements
        { spell = 108287, type = "ability", talent = 9 , usable = true }, -- Totemic Projection
        { spell = 16166, type = "ability", talent = 10 , usable = true , buff = true }, -- Elemental Mastery
        { spell = 16188, type = "ability", talent = 11 , usable = true , buff = true }, -- Ancestral Swiftness
        { spell = 108281, type = "ability", talent = 14 , usable = true , buff = true }, -- Ancestral Guidance
        { spell = 117588, type = "ability", talent = 17 , usable = true }, -- Fire Nova
        { spell = 118297, type = "ability", talent = 17 , usable = true }, -- Immolate
        { spell = 118337, type = "ability", talent = 17 , usable = true , buff = true, unit = 'pet' , debuff = true }, -- Harden Skin
        { spell = 118345, type = "ability", talent = 17 , usable = true }, -- Pulverize
        { spell = 118347, type = "ability", talent = 17 , usable = true , buff = true }, -- Reinforce
        { spell = 118350, type = "ability", talent = 17 , usable = true , buff = true }, -- Empower
        { spell = 36213, type = "ability", talent = 17 , usable = true }, -- Angered Earth
        { spell = 57984, type = "ability", talent = 17 , usable = true }, -- Fire Blast
        { spell = 117014, type = "ability", talent = 18 , usable = true }, -- Elemental Blast
      },
      icon = "Interface\\Icons\\Spell_Nature_EarthShock"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\Spell_lightning_lightningbolt01"
    },
  },
  [2] = { -- Enhancement
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 79206, type = "buff", unit = "player"}, -- Spiritwalker's Grace
        { spell = 324, type = "buff", unit = "player"}, -- Lightning Shield
        { spell = 6196, type = "buff", unit = "player"}, -- Far Sight
        { spell = 73681, type = "buff", unit = "player"}, -- Unleash Wind
        { spell = 73683, type = "buff", unit = "player"}, -- Unleash Flame
        { spell = 546, type = "buff", unit = "player"}, -- Water Walking
        { spell = 114051, type = "buff", unit = "player"}, -- Ascendance
        { spell = 58875, type = "buff", unit = "player"}, -- Spirit Walk
        { spell = 126554, type = "buff", unit = "player"}, -- Agile
        { spell = 73920, type = "buff", unit = "player"}, -- Healing Rain
        { spell = 16278, type = "buff", unit = "player"}, -- Flurry
        { spell = 8178, type = "buff", unit = "player"}, -- Grounding Totem Effect
        { spell = 2825, type = "buff", unit = "player"}, -- Bloodlust
        { spell = 120676, type = "buff", unit = "player"}, -- Stormlash Totem
        { spell = 2645, type = "buff", unit = "player"}, -- Ghost Wolf
        { spell = 30823, type = "buff", unit = "player"}, -- Shamanistic Rage
        { spell = 52127, type = "buff", unit = "player"}, -- Water Shield
        { spell = 53817, type = "buff", unit = "player"}, -- Maelstrom Weapon
        { spell = 114893, type = "buff", unit = "player", talent = 2 }, -- Stone Bulwark
        { spell = 108271, type = "buff", unit = "player", talent = 3 }, -- Astral Shift
        { spell = 114896, type = "buff", unit = "player", talent = 6 }, -- Windwalk Totem
        { spell = 16166, type = "buff", unit = "player", talent = 10 }, -- Elemental Mastery
        { spell = 16188, type = "buff", unit = "player", talent = 11 }, -- Ancestral Swiftness
        { spell = 108281, type = "buff", unit = "player", talent = 14 }, -- Ancestral Guidance
        { spell = 118474, type = "buff", unit = "player", talent = 16 }, -- Unleashed Fury
        { spell = 118475, type = "buff", unit = "player", talent = 16 }, -- Unleashed Fury
        { spell = 118472, type = "buff", unit = "player", talent = 16 }, -- Unleashed Fury
        { spell = 118350, type = "buff", unit = "player", talent = 17 }, -- Empower
        { spell = 118347, type = "buff", unit = "player", talent = 17 }, -- Reinforce
        { spell = 118337, type = "buff", unit = "target", talent = 17 }, -- Harden Skin
        { spell = 118522, type = "buff", unit = "player", talent = 18 }, -- Elemental Blast

        -- Enchant
        -- { spell = 33757, type = "weaponenchant", enchant = 5401, weapon = "main"}, -- Windfury Weapon
        -- { spell = 318038, type = "weaponenchant", enchant = 5400, weapon = "off"}, -- Flametongue Weapon
      },
      icon = "Interface\\Icons\\spell_nature_spiritwolf"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 115356, type = "debuff", unit = "target"}, -- Stormblast
        { spell = 115798, type = "debuff", unit = "target"}, -- Weakened Blows
        { spell = 8056, type = "debuff", unit = "target"}, -- Frost Shock
        { spell = 3600, type = "debuff", unit = "target"}, -- Earthbind
        { spell = 17364, type = "debuff", unit = "target"}, -- Stormstrike
        { spell = 8034, type = "debuff", unit = "target"}, -- Frostbrand Attack
        { spell = 73684, type = "debuff", unit = "target"}, -- Unleash Earth
        { spell = 76780, type = "debuff", unit = "target"}, -- Bind Elemental
        { spell = 73682, type = "debuff", unit = "target"}, -- Unleash Frost
        { spell = 73684, type = "debuff", unit = "target"}, -- Unleash Earth
        { spell = 8050, type = "debuff", unit = "target"}, -- Flame Shock
        { spell = 51514, type = "debuff", unit = "target"}, -- Hex
        { spell = 63685, type = "debuff", unit = "target", talent = 4 }, -- Freeze
        { spell = 116947, type = "debuff", unit = "target", talent = 5 }, -- Earthbind
        { spell = 64695, type = "debuff", unit = "target", talent = 5 }, -- Earthgrab
        { spell = 118470, type = "debuff", unit = "target", talent = 16 }, -- Unleashed Fury
        { spell = 118297, type = "debuff", unit = "target", talent = 17 }, -- Immolate
        { spell = 118345, type = "debuff", unit = "target", talent = 17 }, -- Pulverize
      },
      icon = "Interface\\Icons\\spell_fire_flameshock"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 370, type = "ability", usable = true, requiresTarget = true }, -- Purge
        { spell = 403, type = "ability", usable = true, requiresTarget = true }, -- Lightning Bolt
        { spell = 421, type = "ability", usable = true, requiresTarget = true }, -- Chain Lightning
        { spell = 546, type = "ability", usable = true , buff = true }, -- Water Walking
        { spell = 556, type = "ability", usable = true }, -- Astral Recall
        { spell = 1064, type = "ability", usable = true }, -- Chain Heal
        { spell = 1535, type = "ability", usable = true }, -- Fire Nova
        { spell = 2008, type = "ability", usable = true, requiresTarget = true }, -- Ancestral Spirit
        { spell = 2645, type = "ability", usable = true , buff = true }, -- Ghost Wolf
        { spell = 2825, type = "ability", usable = true , buff = true }, -- Bloodlust
        { spell = 6196, type = "ability", usable = true , buff = true }, -- Far Sight
        { spell = 8004, type = "ability", usable = true }, -- Healing Surge
        { spell = 8042, type = "ability", usable = true, requiresTarget = true }, -- Earth Shock
        { spell = 8050, type = "ability", usable = true, requiresTarget = true }, -- Flame Shock
        { spell = 8056, type = "ability", usable = true, requiresTarget = true }, -- Frost Shock
        { spell = 17364, type = "ability", usable = true, requiresTarget = true }, -- Stormstrike
        { spell = 30823, type = "ability", usable = true , buff = true }, -- Shamanistic Rage
        { spell = 51514, type = "ability", usable = true, requiresTarget = true }, -- Hex
        { spell = 51533, type = "ability", usable = true }, -- Feral Spirit
        { spell = 51886, type = "ability", usable = true }, -- Cleanse Spirit
        { spell = 57994, type = "ability", usable = true, requiresTarget = true }, -- Wind Shear
        { spell = 58875, type = "ability", usable = true , buff = true }, -- Spirit Walk
        { spell = 60103, type = "ability", usable = true, requiresTarget = true }, -- Lava Lash
        { spell = 73680, type = "ability", usable = true, requiresTarget = true }, -- Unleash Elements
        { spell = 73920, type = "ability", usable = true , buff = true }, -- Healing Rain
        { spell = 76780, type = "ability", usable = true, requiresTarget = true }, -- Bind Elemental
        { spell = 79206, type = "ability", usable = true , buff = true }, -- Spiritwalker's Grace
        { spell = 114049, type = "ability", usable = true }, -- Ascendance
        { spell = 120668, type = "ability", usable = true }, -- Stormlash Totem
        { spell = 2062, type = "ability", usable = true , totem = true }, -- Earth Elemental Totem
        { spell = 2484, type = "ability", usable = true , totem = true }, -- Earthbind Totem
        { spell = 2894, type = "ability", usable = true , totem = true }, -- Fire Elemental Totem
        { spell = 3599, type = "ability", usable = true , totem = true }, -- Searing Totem
        { spell = 5394, type = "ability", usable = true , totem = true }, -- Healing Stream Totem
        { spell = 8143, type = "ability", usable = true , totem = true }, -- Tremor Totem
        { spell = 8177, type = "ability", usable = true , totem = true }, -- Grounding Totem
        { spell = 8190, type = "ability", usable = true , totem = true }, -- Magma Totem
        { spell = 108280, type = "ability", usable = true , totem = true }, -- Healing Tide Totem
        { spell = 120668, type = "ability", usable = true , totem = true }, -- Stormlash Totem
        { spell = 108270, type = "ability", talent = 2 , usable = true , totem = true }, -- Stone Bulwark Totem
        { spell = 108271, type = "ability", talent = 3 , usable = true , buff = true }, -- Astral Shift
        { spell = 51485, type = "ability", talent = 5 , usable = true , totem = true }, -- Earthgrab Totem
        { spell = 108273, type = "ability", talent = 6, usable = true , totem = true }, -- Windwalk Totem
        { spell = 108285, type = "ability", talent = 7 , usable = true }, -- Call of the Elements
        { spell = 108287, type = "ability", talent = 9 , usable = true }, -- Totemic Projection
        { spell = 16166, type = "ability", talent = 10 , usable = true , buff = true }, -- Elemental Mastery
        { spell = 16188, type = "ability", talent = 11 , usable = true , buff = true }, -- Ancestral Swiftness
        { spell = 108281, type = "ability", talent = 14 , usable = true , buff = true }, -- Ancestral Guidance
        { spell = 117588, type = "ability", talent = 17 , usable = true }, -- Fire Nova
        { spell = 118297, type = "ability", talent = 17 , usable = true }, -- Immolate
        { spell = 118337, type = "ability", talent = 17 , usable = true , buff = true, unit = 'pet' , debuff = true }, -- Harden Skin
        { spell = 118345, type = "ability", talent = 17 , usable = true }, -- Pulverize
        { spell = 118347, type = "ability", talent = 17 , usable = true , buff = true }, -- Reinforce
        { spell = 118350, type = "ability", talent = 17 , usable = true , buff = true }, -- Empower
        { spell = 36213, type = "ability", talent = 17 , usable = true }, -- Angered Earth
        { spell = 57984, type = "ability", talent = 17 , usable = true }, -- Fire Blast
        { spell = 117014, type = "ability", talent = 18 , usable = true }, -- Elemental Blast
      },
      icon = "Interface\\Icons\\ability_shaman_stormstrike"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\Spell_lightning_lightningbolt01"
    },
  },
  [3] = { -- Restoration
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 79206, type = "buff", unit = "player"}, -- Spiritwalker's Grace
        { spell = 114052, type = "buff", unit = "player"}, -- Ascendance
        { spell = 51945, type = "buff", unit = "player"}, -- Earthliving
        { spell = 6196, type = "buff", unit = "player"}, -- Far Sight
        { spell = 2825, type = "buff", unit = "player"}, -- Bloodlust
        { spell = 73685, type = "buff", unit = "player"}, -- Unleash Life
        { spell = 2645, type = "buff", unit = "player"}, -- Ghost Wolf
        { spell = 16191, type = "buff", unit = "player"}, -- Mana Tide
        { spell = 105284, type = "buff", unit = "player"}, -- Ancestral Vigor
        { spell = 61295, type = "buff", unit = "player"}, -- Riptide
        { spell = 53390, type = "buff", unit = "player"}, -- Tidal Waves
        { spell = 73920, type = "buff", unit = "player"}, -- Healing Rain
        { spell = 546, type = "buff", unit = "player"}, -- Water Walking
        { spell = 8178, type = "buff", unit = "player"}, -- Grounding Totem Effect
        { spell = 120676, type = "buff", unit = "player"}, -- Stormlash Totem
        { spell = 98007, type = "buff", unit = "player"}, -- Spirit Link Totem
        { spell = 974, type = "buff", unit = "player"}, -- Earth Shield
        { spell = 52127, type = "buff", unit = "player"}, -- Water Shield
        { spell = 324, type = "buff", unit = "player"}, -- Lightning Shield
        { spell = 114893, type = "buff", unit = "player", talent = 2 }, -- Stone Bulwark
        { spell = 108271, type = "buff", unit = "player", talent = 3 }, -- Astral Shift
        { spell = 114896, type = "buff", unit = "player", talent = 6 }, -- Windwalk Totem
        { spell = 16166, type = "buff", unit = "player", talent = 10 }, -- Elemental Mastery
        { spell = 16188, type = "buff", unit = "player", talent = 11 }, -- Ancestral Swiftness
        { spell = 108281, type = "buff", unit = "player", talent = 14 }, -- Ancestral Guidance
        { spell = 118474, type = "buff", unit = "player", talent = 16 }, -- Unleashed Fury
        { spell = 118475, type = "buff", unit = "player", talent = 16 }, -- Unleashed Fury
        { spell = 118473, type = "buff", unit = "player", talent = 16 }, -- Unleashed Fury
        { spell = 118350, type = "buff", unit = "player", talent = 17 }, -- Empower
        { spell = 118347, type = "buff", unit = "player", talent = 17 }, -- Reinforce
        { spell = 118337, type = "buff", unit = "target", talent = 17 }, -- Harden Skin
        { spell = 118522, type = "buff", unit = "player", talent = 18 }, -- Elemental Blast

        -- Enchant
        -- { spell = 318038, type = "weaponenchant", enchant = 5400, weapon = "main"}, -- Flametongue Weapon
      },
      icon = "Interface\\Icons\\Spell_nature_riptide"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 115798, type = "debuff", unit = "target"}, -- Weakened Blows
        { spell = 8056, type = "debuff", unit = "target"}, -- Frost Shock
        { spell = 3600, type = "debuff", unit = "target"}, -- Earthbind
        { spell = 8034, type = "debuff", unit = "target"}, -- Frostbrand Attack
        { spell = 8050, type = "debuff", unit = "target"}, -- Flame Shock
        { spell = 76780, type = "debuff", unit = "target"}, -- Bind Elemental
        { spell = 73682, type = "debuff", unit = "target"}, -- Unleash Frost
        { spell = 73684, type = "debuff", unit = "target"}, -- Unleash Earth
        { spell = 51514, type = "debuff", unit = "target"}, -- Hex
        { spell = 63685, type = "debuff", unit = "target", talent = 4 }, -- Freeze
        { spell = 116947, type = "debuff", unit = "target", talent = 5 }, -- Earthbind
        { spell = 64695, type = "debuff", unit = "target", talent = 5 }, -- Earthgrab
        { spell = 118470, type = "debuff", unit = "target", talent = 16 }, -- Unleashed Fury
        { spell = 118297, type = "debuff", unit = "target", talent = 17 }, -- Immolate
        { spell = 118345, type = "debuff", unit = "target", talent = 17 }, -- Pulverize
      },
      icon = "Interface\\Icons\\Spell_fire_flameshock"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 331, type = "ability", usable = true }, -- Healing Wave
        { spell = 370, type = "ability", usable = true, requiresTarget = true }, -- Purge
        { spell = 403, type = "ability", usable = true, requiresTarget = true }, -- Lightning Bolt
        { spell = 421, type = "ability", usable = true, requiresTarget = true }, -- Chain Lightning
        { spell = 546, type = "ability", usable = true , buff = true }, -- Water Walking
        { spell = 556, type = "ability", usable = true }, -- Astral Recall
        { spell = 974, type = "ability", usable = true , buff = true }, -- Earth Shield
        { spell = 1064, type = "ability", usable = true }, -- Chain Heal
        { spell = 2008, type = "ability", usable = true, requiresTarget = true }, -- Ancestral Spirit
        { spell = 2062, type = "ability", usable = true , totem = true }, -- Earth Elemental Totem
        { spell = 2484, type = "ability", usable = true , totem = true }, -- Earthbind Totem
        { spell = 2645, type = "ability", usable = true , buff = true }, -- Ghost Wolf
        { spell = 2825, type = "ability", usable = true , buff = true }, -- Bloodlust
        { spell = 2894, type = "ability", usable = true , totem = true }, -- Fire Elemental Totem
        { spell = 3599, type = "ability", usable = true , totem = true }, -- Searing Totem
        { spell = 5394, type = "ability", usable = true , totem = true }, -- Healing Stream Totem
        { spell = 6196, type = "ability", usable = true , buff = true }, -- Far Sight
        { spell = 8004, type = "ability", usable = true }, -- Healing Surge
        { spell = 8042, type = "ability", usable = true, requiresTarget = true }, -- Earth Shock
        { spell = 8050, type = "ability", usable = true, requiresTarget = true }, -- Flame Shock
        { spell = 8056, type = "ability", usable = true, requiresTarget = true }, -- Frost Shock
        { spell = 8143, type = "ability", usable = true , totem = true }, -- Tremor Totem
        { spell = 8177, type = "ability", usable = true , totem = true }, -- Grounding Totem
        { spell = 8190, type = "ability", usable = true , totem = true }, -- Magma Totem
        { spell = 16190, type = "ability", usable = true , totem = true }, -- Mana Tide Totem
        { spell = 51505, type = "ability", usable = true, requiresTarget = true }, -- Lava Burst
        { spell = 51514, type = "ability", usable = true, requiresTarget = true }, -- Hex
        { spell = 51730, type = "ability", usable = true }, -- Earthliving Weapon
        { spell = 57994, type = "ability", usable = true, requiresTarget = true }, -- Wind Shear
        { spell = 61295, type = "ability", usable = true , buff = true }, -- Riptide
        { spell = 73680, type = "ability", usable = true, requiresTarget = true }, -- Unleash Elements
        { spell = 73899, type = "ability", usable = true, requiresTarget = true }, -- Primal Strike
        { spell = 73920, type = "ability", usable = true , buff = true }, -- Healing Rain
        { spell = 76780, type = "ability", usable = true, requiresTarget = true }, -- Bind Elemental
        { spell = 77130, type = "ability", usable = true }, -- Purify Spirit
        { spell = 77472, type = "ability", usable = true }, -- Greater Healing Wave
        { spell = 79206, type = "ability", usable = true , buff = true }, -- Spiritwalker's Grace
        { spell = 98008, type = "ability", usable = true , totem = true }, -- Spirit Link Totem
        { spell = 108269, type = "ability", usable = true, totem = true }, -- Capacitor Totem
        { spell = 108280, type = "ability", usable = true , totem = true }, -- Healing Tide Totem
        { spell = 114049, type = "ability", usable = true }, -- Ascendance
        { spell = 120668, type = "ability", usable = true , totem = true }, -- Stormlash Totem
        { spell = 108270, type = "ability", talent = 2 , usable = true , totem = true }, -- Stone Bulwark Totem
        { spell = 108271, type = "ability", talent = 3 , usable = true , buff = true }, -- Astral Shift
        { spell = 51485, type = "ability", talent = 5 , usable = true , totem = true }, -- Earthgrab Totem
        { spell = 108273, type = "ability", talent = 6, usable = true , totem = true }, -- Windwalk Totem
        { spell = 108285, type = "ability", talent = 7 , usable = true }, -- Call of the Elements
        { spell = 108287, type = "ability", talent = 9 , usable = true }, -- Totemic Projection
        { spell = 16166, type = "ability", talent = 10 , usable = true , buff = true }, -- Elemental Mastery
        { spell = 16188, type = "ability", talent = 11 , usable = true , buff = true }, -- Ancestral Swiftness
        { spell = 108281, type = "ability", talent = 14 , usable = true , buff = true }, -- Ancestral Guidance
        { spell = 117588, type = "ability", talent = 17 , usable = true }, -- Fire Nova
        { spell = 118297, type = "ability", talent = 17 , usable = true }, -- Immolate
        { spell = 118337, type = "ability", talent = 17 , usable = true , buff = true, unit = 'pet' , debuff = true }, -- Harden Skin
        { spell = 118345, type = "ability", talent = 17 , usable = true }, -- Pulverize
        { spell = 118347, type = "ability", talent = 17 , usable = true , buff = true }, -- Reinforce
        { spell = 118350, type = "ability", talent = 17 , usable = true , buff = true }, -- Empower
        { spell = 36213, type = "ability", talent = 17 , usable = true }, -- Angered Earth
        { spell = 57984, type = "ability", talent = 17 , usable = true }, -- Fire Blast
        { spell = 117014, type = "ability", talent = 18 , usable = true }, -- Elemental Blast
      },
      icon = "Interface\\Icons\\Inv_spear_04"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\inv_elemental_mote_mana",
    },
  },
}

templates.class.MAGE = {
  [1] = { -- Arcane
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 30482, type = "buff", unit = "player"}, -- Molten Armor
        { spell = 45438, type = "buff", unit = "player"}, -- Ice Block
        { spell = 66, type = "buff", unit = "player"}, -- Invisibility
        { spell = 1459, type = "buff", unit = "player"}, -- Arcane Brilliance
        { spell = 32612, type = "buff", unit = "player"}, -- Invisibility
        { spell = 79683, type = "buff", unit = "player"}, -- Arcane Missiles!
        { spell = 130, type = "buff", unit = "player"}, -- Slow Fall
        { spell = 80353, type = "buff", unit = "player"}, -- Time Warp
        { spell = 12051, type = "buff", unit = "player"}, -- Evocation
        { spell = 110909, type = "buff", unit = "player"}, -- Alter Time
        { spell = 12042, type = "buff", unit = "player"}, -- Arcane Power
        { spell = 6117, type = "buff", unit = "player"}, -- Mage Armor
        { spell = 7302, type = "buff", unit = "player"}, -- Frost Armor
        { spell = 12043, type = "buff", unit = "player", talent = 1 }, -- Presence of Mind
        { spell = 108843, type = "buff", unit = "player", talent = 2 }, -- Blazing Speed
        { spell = 108839, type = "buff", unit = "player", talent = 3 }, -- Ice Floes
        { spell = 115610, type = "buff", unit = "player", talent = 4 }, -- Temporal Shield
        { spell = 11426, type = "buff", unit = "player", talent = 6 }, -- Ice Barrier
        { spell = 111264, type = "buff", unit = "player", talent = 8 }, -- Ice Ward
        { spell = 110960, type = "buff", unit = "player", talent = 10 }, -- Greater Invisibility
        { spell = 113862, type = "buff", unit = "player", talent = 10 }, -- Greater Invisibility
        { spell = 116257, type = "buff", unit = "player", talent = 16 }, -- Invoker's Energy
        { spell = 116014, type = "buff", unit = "player", talent = 17 }, -- Rune of Power
        { spell = 1463, type = "buff", unit = "player", talent = 18 }, -- Incanter's Ward
        { spell = 116267, type = "buff", unit = "player", talent = 18 }, -- Incanter's Absorption
      },
      icon = "Interface\\Icons\\spell_arcane_focusedpower"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 118, type = "debuff", unit = "target"}, -- Polymorph
        { spell = 120, type = "debuff", unit = "target"}, -- Cone of Cold
        { spell = 122, type = "debuff", unit = "target"}, -- Frost Nova
        { spell = 44572, type = "debuff", unit = "target"}, -- Deep Freeze
        { spell = 55021, type = "debuff", unit = "target"}, -- Silenced - Improved Counterspell
        { spell = 31589, type = "debuff", unit = "target"}, -- Slow
        { spell = 12486, type = "debuff", unit = "target"}, -- Chilled
        { spell = 2120, type = "debuff", unit = "target"}, -- Flamestrike
        { spell = 44614, type = "debuff", unit = "target"}, -- Frostfire Bolt
        { spell = 7321, type = "debuff", unit = "target"}, -- Chilled
        { spell = 82691, type = "debuff", unit = "target", talent = 7 }, -- Ring of Frost
        { spell = 111340, type = "debuff", unit = "target", talent = 8 }, -- Ice Ward
        { spell = 102051, type = "debuff", unit = "target", talent = 9 }, -- Frostjaw
        { spell = 114923, type = "debuff", unit = "target", talent = 13 }, -- Nether Tempest
        { spell = 44457, type = "debuff", unit = "target", talent = 14 }, -- Living Bomb
        { spell = 113092, type = "debuff", unit = "target", talent = 15 }, -- Frost Bomb
        { spell = 112948, type = "debuff", unit = "target", talent = 15 }, -- Frost Bomb
      },
      icon = "Interface\\Icons\\Spell_frost_frostnova"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 44425, type = "ability", usable = true }, -- Arcane Barrage
        { spell = 5143, type = "ability", charges = true, requiresTarget = true }, -- Arcane Missiles
        { spell = 12042, type = "ability", usable = true , buff = true }, -- Arcane Power
        { spell = 31589, type = "ability", usable = true, requiresTarget = true }, -- Slow
        { spell = 10, type = "ability", usable = true }, -- Blizzard
        { spell = 66, type = "ability", usable = true , buff = true }, -- Invisibility
        { spell = 118, type = "ability", usable = true, requiresTarget = true }, -- Polymorph
        { spell = 120, type = "ability", usable = true }, -- Cone of Cold
        { spell = 122, type = "ability", usable = true }, -- Frost Nova
        { spell = 130, type = "ability", usable = true , buff = true }, -- Slow Fall
        { spell = 475, type = "ability", usable = true, requiresTarget = true }, -- Remove Curse
        { spell = 759, type = "ability", usable = true }, -- Conjure Mana Gem
        { spell = 1449, type = "ability", usable = true }, -- Arcane Explosion
        { spell = 1459, type = "ability", usable = true , buff = true }, -- Arcane Brilliance
        { spell = 1953, type = "ability", usable = true }, -- Blink
        { spell = 2120, type = "ability", usable = true }, -- Flamestrike
        { spell = 2136, type = "ability", usable = true, requiresTarget = true }, -- Fire Blast
        { spell = 2139, type = "ability", usable = true, requiresTarget = true }, -- Counterspell
        { spell = 6117, type = "ability", usable = true , buff = true }, -- Mage Armor
        { spell = 7302, type = "ability", usable = true , buff = true }, -- Frost Armor
        { spell = 11417, type = "ability", usable = true }, -- Portal: Orgrimmar
        { spell = 12051, type = "ability", usable = true , buff = true }, -- Evocation
        { spell = 30449, type = "ability", usable = true, requiresTarget = true }, -- Spellsteal
        { spell = 30455, type = "ability", usable = true, requiresTarget = true }, -- Ice Lance
        { spell = 30482, type = "ability", usable = true , buff = true }, -- Molten Armor
        { spell = 31589, type = "ability", usable = true, requiresTarget = true }, -- Slow
        { spell = 42955, type = "ability", usable = true }, -- Conjure Refreshment
        { spell = 43987, type = "ability", usable = true }, -- Conjure Refreshment Table
        { spell = 44572, type = "ability", usable = true, requiresTarget = true }, -- Deep Freeze
        { spell = 44614, type = "ability", usable = true, requiresTarget = true }, -- Frostfire Bolt
        { spell = 45438, type = "ability", usable = true , buff = true }, -- Ice Block
        { spell = 55342, type = "ability", usable = true }, -- Mirror Image
        { spell = 80353, type = "ability", usable = true , buff = true }, -- Time Warp
        { spell = 108978, type = "ability", usable = true , buff = true }, -- Alter Time
        { spell = 12043, type = "ability", talent = 1 , usable = true , buff = true }, -- Presence of Mind
        { spell = 108843, type = "ability", talent = 2 , usable = true , buff = true }, -- Blazing Speed
        { spell = 108839, type = "ability", talent = 3 , charges = true , usable = true , buff = true }, -- Ice Floes
        { spell = 115610, type = "ability", talent = 4 , usable = true , buff = true }, -- Temporal Shield
        { spell = 11426, type = "ability", talent = 6 , usable = true , buff = true }, -- Ice Barrier
        { spell = 113724, type = "ability", talent = 7 , usable = true }, -- Ring of Frost
        { spell = 111264, type = "ability", talent = 8 , usable = true , buff = true }, -- Ice Ward
        { spell = 102051, type = "ability", talent = 9 , usable = true, requiresTarget = true }, -- Frostjaw
        { spell = 110959, type = "ability", talent = 10 , usable = true }, -- Greater Invisibility
        { spell = 11958, type = "ability", talent = 12 , usable = true }, -- Cold Snap
        { spell = 114923, type = "ability", talent = 13 , usable = true, requiresTarget = true }, -- Nether Tempest
        { spell = 44457, type = "ability", talent = 14 , usable = true, requiresTarget = true }, -- Living Bomb
        { spell = 112948, type = "ability", talent = 15 , usable = true, requiresTarget = true }, -- Frost Bomb
        { spell = 116011, type = "ability", talent = 17 , usable = true }, -- Rune of Power
        { spell = 1463, type = "ability", talent = 18 , usable = true , buff = true }, -- Incanter's Ward
      },
      icon = "Interface\\Icons\\ability_mage_arcanebarrage"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\spell_arcane_arcane01",
    },
  },
  [2] = { -- Fire
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 48107, type = "buff", unit = "player"}, -- Heating Up
        { spell = 48108, type = "buff", unit = "player"}, -- Pyroblast!
        { spell = 30482, type = "buff", unit = "player"}, -- Molten Armor
        { spell = 45438, type = "buff", unit = "player"}, -- Ice Block
        { spell = 66, type = "buff", unit = "player"}, -- Invisibility
        { spell = 1459, type = "buff", unit = "player", forceOwnOnly = true, ownOnly = nil}, -- Arcane Brilliance
        { spell = 32612, type = "buff", unit = "player"}, -- Invisibility
        { spell = 130, type = "buff", unit = "player"}, -- Slow Fall
        { spell = 80353, type = "buff", unit = "player"}, -- Time Warp
        { spell = 12051, type = "buff", unit = "player"}, -- Evocation
        { spell = 110909, type = "buff", unit = "player"}, -- Alter Time
        { spell = 6117, type = "buff", unit = "player"}, -- Mage Armor
        { spell = 7302, type = "buff", unit = "player"}, -- Frost Armor
        { spell = 12043, type = "buff", unit = "player", talent = 1 }, -- Presence of Mind
        { spell = 108843, type = "buff", unit = "player", talent = 2 }, -- Blazing Speed
        { spell = 108839, type = "buff", unit = "player", talent = 3 }, -- Ice Floes
        { spell = 115610, type = "buff", unit = "player", talent = 4 }, -- Temporal Shield
        { spell = 11426, type = "buff", unit = "player", talent = 6 }, -- Ice Barrier
        { spell = 111264, type = "buff", unit = "player", talent = 8 }, -- Ice Ward
        { spell = 110960, type = "buff", unit = "player", talent = 10 }, -- Greater Invisibility
        { spell = 113862, type = "buff", unit = "player", talent = 10 }, -- Greater Invisibility
        { spell = 116257, type = "buff", unit = "player", talent = 16 }, -- Invoker's Energy
        { spell = 116014, type = "buff", unit = "player", talent = 17 }, -- Rune of Power
        { spell = 1463, type = "buff", unit = "player", talent = 18 }, -- Incanter's Ward
        { spell = 116267, type = "buff", unit = "player", talent = 18 }, -- Incanter's Absorption
      },
      icon = "Interface\\Icons\\spell_arcane_focusedpower"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 31661, type = "debuff", unit = "target"}, -- Dragon's Breath
        { spell = 83853, type = "debuff", unit = "target"}, -- Combustion
        { spell = 118271, type = "debuff", unit = "target"}, -- Combustion Impact
        { spell = 12654, type = "debuff", unit = "target"}, -- Ignite
        { spell = 132210, type = "debuff", unit = "target"}, -- Pyromaniac
        { spell = 11366, type = "debuff", unit = "target"}, -- Pyroblast
        { spell = 118, type = "debuff", unit = "target"}, -- Polymorph
        { spell = 120, type = "debuff", unit = "target"}, -- Cone of Cold
        { spell = 122, type = "debuff", unit = "target"}, -- Frost Nova
        { spell = 44572, type = "debuff", unit = "target"}, -- Deep Freeze
        { spell = 55021, type = "debuff", unit = "target"}, -- Silenced - Improved Counterspell
        { spell = 12486, type = "debuff", unit = "target"}, -- Chilled
        { spell = 2120, type = "debuff", unit = "target"}, -- Flamestrike
        { spell = 44614, type = "debuff", unit = "target"}, -- Frostfire Bolt
        { spell = 7321, type = "debuff", unit = "target"}, -- Chilled
        { spell = 82691, type = "debuff", unit = "target", talent = 7 }, -- Ring of Frost
        { spell = 111340, type = "debuff", unit = "target", talent = 8 }, -- Ice Ward
        { spell = 102051, type = "debuff", unit = "target", talent = 9 }, -- Frostjaw
        { spell = 114923, type = "debuff", unit = "target", talent = 13 }, -- Nether Tempest
        { spell = 44457, type = "debuff", unit = "target", talent = 14 }, -- Living Bomb
        { spell = 113092, type = "debuff", unit = "target", talent = 15 }, -- Frost Bomb
        { spell = 112948, type = "debuff", unit = "target", talent = 15 }, -- Frost Bomb
      },
      icon = "Interface\\Icons\\Spell_frost_frostnova"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 133, type = "ability", usable = true }, -- Fireball
        { spell = 11129, type = "ability", usable = true }, -- Combustion
        { spell = 11366, type = "ability", usable = true }, -- Pyroblast
        { spell = 31661, type = "ability", usable = true }, -- Dragon's Breath
        { spell = 108853, type = "ability", usable = true }, -- Inferno Blast
        { spell = 10, type = "ability", usable = true }, -- Blizzard
        { spell = 66, type = "ability", usable = true , buff = true }, -- Invisibility
        { spell = 118, type = "ability", usable = true, requiresTarget = true }, -- Polymorph
        { spell = 120, type = "ability", usable = true }, -- Cone of Cold
        { spell = 122, type = "ability", usable = true }, -- Frost Nova
        { spell = 130, type = "ability", usable = true , buff = true }, -- Slow Fall
        { spell = 475, type = "ability", usable = true, requiresTarget = true }, -- Remove Curse
        { spell = 759, type = "ability", usable = true }, -- Conjure Mana Gem
        { spell = 1449, type = "ability", usable = true }, -- Arcane Explosion
        { spell = 1459, type = "ability", usable = true , buff = true }, -- Arcane Brilliance
        { spell = 1953, type = "ability", usable = true }, -- Blink
        { spell = 2120, type = "ability", usable = true }, -- Flamestrike
        { spell = 2136, type = "ability", usable = true, requiresTarget = true }, -- Fire Blast
        { spell = 2139, type = "ability", usable = true, requiresTarget = true }, -- Counterspell
        { spell = 6117, type = "ability", usable = true , buff = true }, -- Mage Armor
        { spell = 7302, type = "ability", usable = true , buff = true }, -- Frost Armor
        { spell = 11417, type = "ability", usable = true }, -- Portal: Orgrimmar
        { spell = 12051, type = "ability", usable = true , buff = true }, -- Evocation
        { spell = 30449, type = "ability", usable = true, requiresTarget = true }, -- Spellsteal
        { spell = 30455, type = "ability", usable = true, requiresTarget = true }, -- Ice Lance
        { spell = 30482, type = "ability", usable = true , buff = true }, -- Molten Armor
        { spell = 31589, type = "ability", usable = true, requiresTarget = true }, -- Slow
        { spell = 42955, type = "ability", usable = true }, -- Conjure Refreshment
        { spell = 43987, type = "ability", usable = true }, -- Conjure Refreshment Table
        { spell = 44572, type = "ability", usable = true, requiresTarget = true }, -- Deep Freeze
        { spell = 44614, type = "ability", usable = true, requiresTarget = true }, -- Frostfire Bolt
        { spell = 45438, type = "ability", usable = true , buff = true }, -- Ice Block
        { spell = 55342, type = "ability", usable = true }, -- Mirror Image
        { spell = 80353, type = "ability", usable = true , buff = true }, -- Time Warp
        { spell = 108978, type = "ability", usable = true , buff = true }, -- Alter Time
        { spell = 12043, type = "ability", talent = 1 , usable = true , buff = true }, -- Presence of Mind
        { spell = 108843, type = "ability", talent = 2 , usable = true , buff = true }, -- Blazing Speed
        { spell = 108839, type = "ability", talent = 3 , charges = true , usable = true , buff = true }, -- Ice Floes
        { spell = 115610, type = "ability", talent = 4 , usable = true , buff = true }, -- Temporal Shield
        { spell = 11426, type = "ability", talent = 6 , usable = true , buff = true }, -- Ice Barrier
        { spell = 113724, type = "ability", talent = 7 , usable = true }, -- Ring of Frost
        { spell = 111264, type = "ability", talent = 8 , usable = true , buff = true }, -- Ice Ward
        { spell = 102051, type = "ability", talent = 9 , usable = true, requiresTarget = true }, -- Frostjaw
        { spell = 110959, type = "ability", talent = 10 , usable = true }, -- Greater Invisibility
        { spell = 11958, type = "ability", talent = 12 , usable = true }, -- Cold Snap
        { spell = 114923, type = "ability", talent = 13 , usable = true, requiresTarget = true }, -- Nether Tempest
        { spell = 44457, type = "ability", talent = 14 , usable = true, requiresTarget = true }, -- Living Bomb
        { spell = 112948, type = "ability", talent = 15 , usable = true, requiresTarget = true }, -- Frost Bomb
        { spell = 116011, type = "ability", talent = 17 , usable = true }, -- Rune of Power
        { spell = 1463, type = "ability", talent = 18 , usable = true , buff = true }, -- Incanter's Ward
      },
      icon = "Interface\\Icons\\ability_mage_arcanebarrage"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\inv_elemental_mote_mana",
    },
  },
  [3] = { -- Frost
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 57761, type = "buff", unit = "player"}, -- Brain Freeze
        { spell = 12472, type = "buff", unit = "player"}, -- Icy Veins
        { spell = 44544, type = "buff", unit = "player"}, -- Fingers of Frost
        { spell = 30482, type = "buff", unit = "player"}, -- Molten Armor
        { spell = 45438, type = "buff", unit = "player"}, -- Ice Block
        { spell = 66, type = "buff", unit = "player"}, -- Invisibility
        { spell = 1459, type = "buff", unit = "player", forceOwnOnly = true, ownOnly = nil}, -- Arcane Brilliance
        { spell = 32612, type = "buff", unit = "player"}, -- Invisibility
        { spell = 130, type = "buff", unit = "player"}, -- Slow Fall
        { spell = 80353, type = "buff", unit = "player"}, -- Time Warp
        { spell = 12051, type = "buff", unit = "player"}, -- Evocation
        { spell = 110909, type = "buff", unit = "player"}, -- Alter Time
        { spell = 6117, type = "buff", unit = "player"}, -- Mage Armor
        { spell = 7302, type = "buff", unit = "player"}, -- Frost Armor
        { spell = 12043, type = "buff", unit = "player", talent = 1 }, -- Presence of Mind
        { spell = 108843, type = "buff", unit = "player", talent = 2 }, -- Blazing Speed
        { spell = 108839, type = "buff", unit = "player", talent = 3 }, -- Ice Floes
        { spell = 115610, type = "buff", unit = "player", talent = 4 }, -- Temporal Shield
        { spell = 11426, type = "buff", unit = "player", talent = 6 }, -- Ice Barrier
        { spell = 111264, type = "buff", unit = "player", talent = 8 }, -- Ice Ward
        { spell = 110960, type = "buff", unit = "player", talent = 10 }, -- Greater Invisibility
        { spell = 113862, type = "buff", unit = "player", talent = 10 }, -- Greater Invisibility
        { spell = 116257, type = "buff", unit = "player", talent = 16 }, -- Invoker's Energy
        { spell = 116014, type = "buff", unit = "player", talent = 17 }, -- Rune of Power
        { spell = 1463, type = "buff", unit = "player", talent = 18 }, -- Incanter's Ward
        { spell = 116267, type = "buff", unit = "player", talent = 18 }, -- Incanter's Absorption
      },
      icon = "Interface\\Icons\\spell_arcane_focusedpower"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 84721, type = "debuff", unit = "target"}, -- Frozen Orb
        { spell = 33395, type = "debuff", unit = "target"}, -- Freeze
        { spell = 44572, type = "debuff", unit = "target"}, -- Deep Freeze
        { spell = 118, type = "debuff", unit = "target"}, -- Polymorph
        { spell = 120, type = "debuff", unit = "target"}, -- Cone of Cold
        { spell = 122, type = "debuff", unit = "target"}, -- Frost Nova
        { spell = 44572, type = "debuff", unit = "target"}, -- Deep Freeze
        { spell = 55021, type = "debuff", unit = "target"}, -- Silenced - Improved Counterspell
        { spell = 12486, type = "debuff", unit = "target"}, -- Chilled
        { spell = 2120, type = "debuff", unit = "target"}, -- Flamestrike
        { spell = 44614, type = "debuff", unit = "target"}, -- Frostfire Bolt
        { spell = 7321, type = "debuff", unit = "target"}, -- Chilled
        { spell = 82691, type = "debuff", unit = "target", talent = 7 }, -- Ring of Frost
        { spell = 111340, type = "debuff", unit = "target", talent = 8 }, -- Ice Ward
        { spell = 102051, type = "debuff", unit = "target", talent = 9 }, -- Frostjaw
        { spell = 114923, type = "debuff", unit = "target", talent = 13 }, -- Nether Tempest
        { spell = 44457, type = "debuff", unit = "target", talent = 14 }, -- Living Bomb
        { spell = 113092, type = "debuff", unit = "target", talent = 15 }, -- Frost Bomb
        { spell = 112948, type = "debuff", unit = "target", talent = 15 }, -- Frost Bomb
      },
      icon = "Interface\\Icons\\Spell_frost_frostnova"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 116, type = "ability", usable = true, requiresTarget = true }, -- Frostbolt
        { spell = 12472, type = "ability", usable = true , buff = true }, -- Icy Veins
        { spell = 31687, type = "ability", usable = true }, -- Summon Water Elemental
        { spell = 31707, type = "ability", usable = true }, -- Waterbolt
        { spell = 33395, type = "ability", usable = true }, -- Freeze
        { spell = 10, type = "ability", usable = true }, -- Blizzard
        { spell = 66, type = "ability", usable = true , buff = true }, -- Invisibility
        { spell = 118, type = "ability", usable = true, requiresTarget = true }, -- Polymorph
        { spell = 120, type = "ability", usable = true }, -- Cone of Cold
        { spell = 122, type = "ability", usable = true }, -- Frost Nova
        { spell = 130, type = "ability", usable = true , buff = true }, -- Slow Fall
        { spell = 475, type = "ability", usable = true, requiresTarget = true }, -- Remove Curse
        { spell = 759, type = "ability", usable = true }, -- Conjure Mana Gem
        { spell = 1449, type = "ability", usable = true }, -- Arcane Explosion
        { spell = 1459, type = "ability", usable = true , buff = true }, -- Arcane Brilliance
        { spell = 1953, type = "ability", usable = true }, -- Blink
        { spell = 2120, type = "ability", usable = true }, -- Flamestrike
        { spell = 2136, type = "ability", usable = true, requiresTarget = true }, -- Fire Blast
        { spell = 2139, type = "ability", usable = true, requiresTarget = true }, -- Counterspell
        { spell = 6117, type = "ability", usable = true , buff = true }, -- Mage Armor
        { spell = 7302, type = "ability", usable = true , buff = true }, -- Frost Armor
        { spell = 11417, type = "ability", usable = true }, -- Portal: Orgrimmar
        { spell = 12051, type = "ability", usable = true , buff = true }, -- Evocation
        { spell = 30449, type = "ability", usable = true, requiresTarget = true }, -- Spellsteal
        { spell = 30455, type = "ability", usable = true, requiresTarget = true }, -- Ice Lance
        { spell = 30482, type = "ability", usable = true , buff = true }, -- Molten Armor
        { spell = 31589, type = "ability", usable = true, requiresTarget = true }, -- Slow
        { spell = 42955, type = "ability", usable = true }, -- Conjure Refreshment
        { spell = 43987, type = "ability", usable = true }, -- Conjure Refreshment Table
        { spell = 44572, type = "ability", usable = true, requiresTarget = true }, -- Deep Freeze
        { spell = 44614, type = "ability", usable = true, requiresTarget = true }, -- Frostfire Bolt
        { spell = 45438, type = "ability", usable = true , buff = true }, -- Ice Block
        { spell = 55342, type = "ability", usable = true }, -- Mirror Image
        { spell = 80353, type = "ability", usable = true , buff = true }, -- Time Warp
        { spell = 108978, type = "ability", usable = true , buff = true }, -- Alter Time
        { spell = 12043, type = "ability", talent = 1 , usable = true , buff = true }, -- Presence of Mind
        { spell = 108843, type = "ability", talent = 2 , usable = true , buff = true }, -- Blazing Speed
        { spell = 108839, type = "ability", talent = 3 , charges = true , usable = true , buff = true }, -- Ice Floes
        { spell = 115610, type = "ability", talent = 4 , usable = true , buff = true }, -- Temporal Shield
        { spell = 11426, type = "ability", talent = 6 , usable = true , buff = true }, -- Ice Barrier
        { spell = 113724, type = "ability", talent = 7 , usable = true }, -- Ring of Frost
        { spell = 111264, type = "ability", talent = 8 , usable = true , buff = true }, -- Ice Ward
        { spell = 102051, type = "ability", talent = 9 , usable = true, requiresTarget = true }, -- Frostjaw
        { spell = 110959, type = "ability", talent = 10 , usable = true }, -- Greater Invisibility
        { spell = 11958, type = "ability", talent = 12 , usable = true }, -- Cold Snap
        { spell = 114923, type = "ability", talent = 13 , usable = true, requiresTarget = true }, -- Nether Tempest
        { spell = 44457, type = "ability", talent = 14 , usable = true, requiresTarget = true }, -- Living Bomb
        { spell = 112948, type = "ability", talent = 15 , usable = true, requiresTarget = true }, -- Frost Bomb
        { spell = 116011, type = "ability", talent = 17 , usable = true }, -- Rune of Power
        { spell = 1463, type = "ability", talent = 18 , usable = true , buff = true }, -- Incanter's Ward
      },
      icon = "Interface\\Icons\\ability_mage_arcanebarrage"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\inv_elemental_mote_mana",
    },
  },
}

templates.class.WARLOCK = {
  [1] = { -- Affliction
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 126, type = "buff", unit = "player"}, -- Eye of Kilrogg
        { spell = 755, type = "buff", unit = "pet"}, -- Health Funnel
        { spell = 5697, type = "buff", unit = "player"}, -- Unending Breath
        { spell = 7870, type = "buff", unit = "pet"}, -- Lesser Invisibility
        { spell = 17767, type = "buff", unit = "pet"}, -- Shadow Bulwark
        { spell = 20707, type = "buff", unit = "group"}, -- Soulstone
        { spell = 48018, type = "buff", unit = "player"}, -- Demonic Circle
        { spell = 104773, type = "buff", unit = "player"}, -- Unending Resolve
        { spell = 108366, type = "buff", unit = "player"}, -- Soul Leech
        { spell = 108416, type = "buff", unit = "player", talent = 9 }, -- Dark Pact
        { spell = 112042, type = "buff", unit = "pet"}, -- Threatening Presence
        { spell = 113860, type = "buff", unit = "player", talent = 21 }, -- Dark Soul: Misery
        { spell = 111400, type = "buff", unit = "player", talent = 8 }, -- Burning Rush
        { spell = 196099, type = "buff", unit = "player", talent = 18 }, -- Grimoire of Sacrifice
        { spell = 264571, type = "buff", unit = "player", talent = 1 }, -- Nightfall
        { spell = 334320, type = "buff", unit = "player", talent = 2 }, -- Inevitable Demise
      },
      icon = "Interface\\Icons\\Spell_shadow_soulgem"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 702, type = "debuff", unit = "target"}, -- Curse of Weakness
        { spell = 710, type = "debuff", unit = "multi"}, -- Banish
        { spell = 980, type = "debuff", unit = "target"}, -- Agony
        { spell = 1098, type = "debuff", unit = "multi"}, -- Enslave Demon
        { spell = 1714, type = "debuff", unit = "target"}, -- Curse of Tongues
        { spell = 6358, type = "debuff", unit = "target"}, -- Seduction
        { spell = 6360, type = "debuff", unit = "target"}, -- Whiplash
        { spell = 6789, type = "debuff", unit = "target", talent = 14 }, -- Mortal Coil
        { spell = 17735, type = "debuff", unit = "target"}, -- Suffering
        { spell = 27243, type = "debuff", unit = "target"}, -- Seed of Corruption
        { spell = 30283, type = "debuff", unit = "target"}, -- Shadowfury
        { spell = 48181, type = "debuff", unit = "target", talent = 17 }, -- Haunt
        { spell = 63106, type = "debuff", unit = "target", talent = 6 }, -- Siphon Life
        { spell = 118699, type = "debuff", unit = "target"}, -- Fear
        { spell = 146739, type = "debuff", unit = "target"}, -- Corruption
        { spell = 198590, type = "debuff", unit = "target", talent = 2 }, -- Drain Soul
        { spell = 205179, type = "debuff", unit = "target", talent = 11 }, -- Phantom Singularity
        { spell = 234153, type = "debuff", unit = "target"}, -- Drain Life
        { spell = 233490, type = "debuff", unit = "target"}, -- Unstable Affliction
        { spell = 278350, type = "debuff", unit = "target", talent = 12 }, -- Vile Taint
        { spell = 334275, type = "debuff", unit = "target"}, -- Curse of Exhaustion
      },
      icon = "Interface\\Icons\\Spell_shadow_curseofsargeras"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 126, type = "ability"}, -- Eye of Kilrogg
        { spell = 172, type = "ability", requiresTarget = true, debuff = true}, -- Corruption
        { spell = 686, type = "ability", requiresTarget = true}, -- Shadow Bolt
        { spell = 698, type = "ability"}, -- Ritual of Summoning
        { spell = 702, type = "ability", requiresTarget = true, debuff = true}, -- Curse of Weakness
        { spell = 710, type = "ability", requiresTarget = true, debuff = true}, -- Banish
        { spell = 755, type = "ability"}, -- Health Funnel
        { spell = 980, type = "ability", requiresTarget = true, debuff = true}, -- Agony
        { spell = 1714, type = "ability", requiresTarget = true, debuff = true}, -- Curse of Tongues
        { spell = 3110, type = "ability", requiresTarget = true}, -- Firebolt
        { spell = 3716, type = "ability", requiresTarget = true}, -- Consuming Shadows
        { spell = 5484, type = "ability"}, -- Howl of Terror
        { spell = 5782, type = "ability", requiresTarget = true, debuff = true}, -- Fear
        { spell = 6358, type = "ability", requiresTarget = true}, -- Seduction
        { spell = 6360, type = "ability", requiresTarget = true}, -- Whiplash
        { spell = 6789, type = "ability", requiresTarget = true, talent = 14 }, -- Mortal Coil
        { spell = 7814, type = "ability", requiresTarget = true}, -- Lash of Pain
        { spell = 7870, type = "ability"}, -- Lesser Invisibility
        { spell = 17735, type = "ability", requiresTarget = true, debuff = true}, -- Suffering
        { spell = 17767, type = "ability"}, -- Shadow Bulwark
        { spell = 19505, type = "ability", requiresTarget = true}, -- Devour Magic
        { spell = 19647, type = "ability", requiresTarget = true}, -- Spell Lock
        { spell = 20707, type = "ability"}, -- Soulstone
        { spell = 27243, type = "ability", requiresTarget = true}, -- Seed of Corruption
        { spell = 29893, type = "ability"}, -- Create Soulwell
        { spell = 30108, type = "ability", requiresTarget = true}, -- Unstable Affliction
        { spell = 30283, type = "ability"}, -- Shadowfury
        { spell = 48018, type = "ability"}, -- Demonic Circle
        { spell = 48020, type = "ability", usable = true }, -- Demonic Circle: Teleport
        { spell = 48181, type = "ability", requiresTarget = true, debuff = true, talent = 17 }, -- Haunt
        { spell = 54049, type = "ability", requiresTarget = true}, -- Shadow Bite
        { spell = 63106, type = "ability", requiresTarget = true, debuff = true, talent = 6}, -- Siphon Life
        { spell = 89792, type = "ability" }, -- Flee
        { spell = 89808, type = "ability"}, -- Singe Magic
        { spell = 104773, type = "ability", buff = true}, -- Unending Resolve
        { spell = 108416, type = "ability", buff = true, talent = 9 }, -- Dark Pact
        { spell = 108503, type = "ability", talent = 18 }, -- Grimoire of Sacrifice
        { spell = 111771, type = "ability"}, -- Demonic Gateway
        { spell = 112042, type = "ability"}, -- Threatening Presence
        { spell = 113860, type = "ability", buff = true, talent = 21 }, -- Dark Soul: Misery
        { spell = 119910, type = "ability", requiresTarget = true}, -- Command Demon
        { spell = 198590, type = "ability", requiresTarget = true}, -- Drain Soul
        { spell = 205179, type = "ability", requiresTarget = true, debuff = true, talent = 11 }, -- Phantom Singularity
        { spell = 205180, type = "ability", totem = true}, -- Summon Darkglare
        { spell = 232670, type = "ability", requiresTarget = true, overlayGlow = true}, -- Shadow Bolt
        { spell = 234153, type = "ability", requiresTarget = true}, -- Drain Life
        { spell = 264106, type = "ability", requiresTarget = true, talent = 3 }, -- Deathbolt
        { spell = 264993, type = "ability"}, -- Shadow Shield
        { spell = 278350, type = "ability", requiresTarget = true, talent = 12 }, -- Vile Taint
        { spell = 316099, type = "ability", requiresTarget = true }, -- Unstable Affliction
        { spell = 333889, type = "ability" }, -- Fel Domination
        { spell = 334275, type = "ability", debuff = true, requiresTarget = true }, -- Curse of Exhaustion
        { spell = 342601, type = "ability" }, -- Ritual of Doom
        { spell = 324536, type = "ability" }, -- Malefic Rapture
      },
      icon = "Interface\\Icons\\Spell_fire_fireball02"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\inv_misc_gem_amethyst_02",
    },
  },
  [2] = { -- Demonology
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 126, type = "buff", unit = "player"}, -- Eye of Kilrogg
        { spell = 755, type = "buff", unit = "pet"}, -- Health Funnel
        { spell = 5697, type = "buff", unit = "player"}, -- Unending Breath
        { spell = 17767, type = "buff", unit = "pet"}, -- Shadow Bulwark
        { spell = 20707, type = "buff", unit = "group"}, -- Soulstone
        { spell = 30151, type = "buff", unit = "pet"}, -- Pursuit
        { spell = 48018, type = "buff", unit = "player"}, -- Demonic Circle
        { spell = 89751, type = "buff", unit = "pet"}, -- Felstorm
        { spell = 104773, type = "buff", unit = "player"}, -- Unending Resolve
        { spell = 108366, type = "buff", unit = "player"}, -- Soul Leech
        { spell = 108416, type = "buff", unit = "player", talent = 9 }, -- Dark Pact
        { spell = 111400, type = "buff", unit = "player", talent = 8 }, -- Burning Rush
        { spell = 134477, type = "buff", unit = "pet"}, -- Threatening Presence
        { spell = 205146, type = "buff", unit = "player", talent = 4 }, -- Demonic Calling
        { spell = 265273, type = "buff", unit = "player"}, -- Demonic Power
        { spell = 267218, type = "buff", unit = "player", talent = 21 }, -- Nether Portal
        { spell = 264173, type = "buff", unit = "player"}, -- Demonic Core
        { spell = 267171, type = "buff", unit = "pet", talent = 3 }, -- Demonic Strength
      },
      icon = "Interface\\Icons\\Spell_shadow_soulgem"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 603, type = "debuff", unit = "target"}, -- Doom
        { spell = 702, type = "debuff", unit = "target"}, -- Curse of Weakness
        { spell = 710, type = "debuff", unit = "multi"}, -- Banish
        { spell = 1098, type = "debuff", unit = "multi"}, -- Enslave Demon
        { spell = 1714, type = "debuff", unit = "target"}, -- Curse of Tongues
        { spell = 6358, type = "debuff", unit = "target"}, -- Seduction
        { spell = 6360, type = "debuff", unit = "target"}, -- Whiplash
        { spell = 6789, type = "debuff", unit = "target", talent = 14 }, -- Mortal Coil
        { spell = 17735, type = "debuff", unit = "target"}, -- Suffering
        { spell = 30213, type = "debuff", unit = "target"}, -- Legion Strike
        { spell = 30283, type = "debuff", unit = "target"}, -- Shadowfury
        { spell = 89766, type = "debuff", unit = "target"}, -- Axe Toss
        { spell = 118699, type = "debuff", unit = "target"}, -- Fear
        { spell = 146739, type = "debuff", unit = "target"}, -- Corruption
        { spell = 267997, type = "debuff", unit = "target", talent = 2 }, -- Bile Spit
        { spell = 270569, type = "debuff", unit = "target", talent = 10 }, -- From the Shadows
        { spell = 234153, type = "debuff", unit = "target"}, -- Drain Life
        { spell = 265412, type = "debuff", unit = "target", talent = 6 }, -- Doom
        { spell = 334275, type = "debuff", unit = "target"}, -- Curse of Exhaustion
      },
      icon = "Interface\\Icons\\Spell_shadow_auraofdarkness"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 126, type = "ability" }, -- Eyew of Kilrogg
        { spell = 172, type = "ability" }, -- Corruption
        { spell = 603, type = "ability", requiresTarget = true, debuff = true, talent = 6}, -- Doom
        { spell = 686, type = "ability", requiresTarget = true}, -- Shadow Bolt
        { spell = 698, type = "ability"}, -- Ritual of Summoning
        { spell = 702, type = "ability", requiresTarget = true, debuff = true}, -- Curse of Weakness
        { spell = 710, type = "ability", requiresTarget = true, debuff = true}, -- Banish
        { spell = 755, type = "ability"}, -- Health Funnel
        { spell = 1098, type = "ability"}, -- Subjugate Demon
        { spell = 1714, type = "ability", requiresTarget = true, debuff = true}, -- Curse of Tongues
        { spell = 3716, type = "ability", requiresTarget = true}, -- Consuming Shadows
        { spell = 5484, type = "ability", debuff = true, talent = 15}, -- Howl of Terror
        { spell = 5782, type = "ability", requiresTarget = true, debuff = true}, -- Fear
        { spell = 6358, type = "ability", requiresTarget = true}, -- Seduction
        { spell = 6360, type = "ability", requiresTarget = true}, -- Whiplash
        { spell = 6789, type = "ability", requiresTarget = true, talent = 14 }, -- Mortal Coil
        { spell = 7814, type = "ability", requiresTarget = true}, -- Lash of Pain
        { spell = 7870, type = "ability"}, -- Lesser Invisibility
        { spell = 17735, type = "ability", requiresTarget = true, debuff = true}, -- Suffering
        { spell = 17767, type = "ability"}, -- Shadow Bulwark
        { spell = 19505, type = "ability", requiresTarget = true}, -- Devour Magic
        { spell = 19647, type = "ability", requiresTarget = true}, -- Spell Lock
        { spell = 20707, type = "ability"}, -- Soulstone
        { spell = 29893, type = "ability"}, -- Create Soulwell
        { spell = 30151, type = "ability", requiresTarget = true}, -- Pursuit
        { spell = 30213, type = "ability", requiresTarget = true}, -- Legion Strike
        { spell = 30283, type = "ability"}, -- Shadowfury
        { spell = 48018, type = "ability" }, -- Demonic Circle
        { spell = 48020, type = "ability" }, -- Demonic Circle: Teleport
        { spell = 54049, type = "ability", requiresTarget = true}, -- Shadow Bite
        { spell = 89751, type = "ability"}, -- Felstorm
        { spell = 89766, type = "ability", requiresTarget = true, debuff = true}, -- Axe Toss
        { spell = 89792, type = "ability"}, -- Flee
        { spell = 89808, type = "ability"}, -- Singe Magic
        { spell = 104316, type = "ability", requiresTarget = true, overlayGlow = true}, -- Call Dreadstalkers
        { spell = 104773, type = "ability", buff = true}, -- Unending Resolve
        { spell = 105174, type = "ability", requiresTarget = true}, -- Hand of Gul'dan
        { spell = 108416, type = "ability", buff = true, talent = 9 }, -- Dark Pact
        { spell = 111771, type = "ability"}, -- Demonic Gateway
        { spell = 111898, type = "ability", requiresTarget = true, talent = 18 }, -- Grimoire: Felguard
        { spell = 112042, type = "ability"}, -- Threatening Presence
        { spell = 119898, type = "ability" }, -- Command Demon
        { spell = 196277, type = "ability" }, -- Implosion
        { spell = 234153, type = "ability", requiresTarget = true }, -- Drain Life
        { spell = 264057, type = "ability", requiresTarget = true, talent = 11 }, -- Soul Strike
        { spell = 264119, type = "ability", talent = 12 }, -- Summon Vilefiend
        { spell = 264130, type = "ability", usable = true, talent = 5 }, -- Power Siphon
        { spell = 264178, type = "ability", requiresTarget = true, overlayGlow = true}, -- Demonbolt
        { spell = 264993, type = "ability"}, -- Shadow Shield
        { spell = 265187, type = "ability"}, -- Summon Demonic Tyrant
        { spell = 265412, type = "ability", requiresTarget = true, debuff = true, talent = 6}, -- Doom
        { spell = 267171, type = "ability", requiresTarget = true, talent = 3 }, -- Demonic Strength
        { spell = 267211, type = "ability", talent = 2 }, -- Bilescourge Bombers
        { spell = 267217, type = "ability", buff = true, talent = 21 }, -- Nether Portal
        { spell = 333889, type = "ability" }, -- Fel Domination
        { spell = 334275, type = "ability", debuff = true }, -- Curse of Exhaustion
        { spell = 342601, type = "ability" }, -- Ritual of Doom
      },
      icon = "Interface\\Icons\\ability_warlock_handofguldan"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\inv_misc_gem_amethyst_02",
    },
  },
  [3] = { -- Destruction
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 126, type = "buff", unit = "player"}, -- Eye of Kilrogg
        { spell = 755, type = "buff", unit = "pet"}, -- Health Funnel
        { spell = 5697, type = "buff", unit = "player"}, -- Unending Breath
        { spell = 7870, type = "buff", unit = "pet"}, -- Lesser Invisibility
        { spell = 17767, type = "buff", unit = "pet"}, -- Shadow Bulwark
        { spell = 20707, type = "buff", unit = "group"}, -- Soulstone
        { spell = 48018, type = "buff", unit = "player"}, -- Demonic Circle
        { spell = 104773, type = "buff", unit = "player"}, -- Unending Resolve
        { spell = 108366, type = "buff", unit = "player"}, -- Soul Leech
        { spell = 108366, type = "buff", unit = "pet"}, -- Soul Leech
        { spell = 108416, type = "buff", unit = "player", talent = 9 }, -- Dark Pact
        { spell = 111400, type = "buff", unit = "player", talent = 8 }, -- Burning Rush
        { spell = 112042, type = "buff", unit = "pet"}, -- Threatening Presence
        { spell = 113858, type = "buff", unit = "player", talent = 21 }, -- Dark Soul: Instability
        { spell = 117828, type = "buff", unit = "player"}, -- Backdraft
        { spell = 196099, type = "buff", unit = "player", talent = 18 }, -- Grimoire of Sacrifice
        { spell = 266030, type = "buff", unit = "player", talent = 4 }, -- Reverse Entropy
      },
      icon = "Interface\\Icons\\Spell_shadow_demonictactics"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 172, type = "debuff", unit = "target"}, -- Coruption
        { spell = 348, type = "debuff", unit = "target"}, -- Immolate
        { spell = 702, type = "debuff", unit = "target"}, -- Curse of Weakness
        { spell = 710, type = "debuff", unit = "multi"}, -- Banish
        { spell = 1714, type = "debuff", unit = "target"}, -- Curse of Tongues
        { spell = 1098, type = "debuff", unit = "multi"}, -- Enslave Demon
        { spell = 5782, type = "debuff", unit = "target"}, -- Fear
        { spell = 6358, type = "debuff", unit = "target"}, -- Seduction
        { spell = 6360, type = "debuff", unit = "target"}, -- Whiplash
        { spell = 6789, type = "debuff", unit = "target", talent = 14 }, -- Mortal Coil
        { spell = 17735, type = "debuff", unit = "target"}, -- Suffering
        { spell = 22703, type = "debuff", unit = "target"}, -- Infernal Awakening
        { spell = 30283, type = "debuff", unit = "target"}, -- Shadowfury
        { spell = 80240, type = "debuff", unit = "target"}, -- Havoc
        { spell = 118699, type = "debuff", unit = "target"}, -- Fear
        { spell = 157736, type = "debuff", unit = "target"}, -- Immolate
        { spell = 196414, type = "debuff", unit = "target", talent = 2 }, -- Eradication
        { spell = 234153, type = "debuff", unit = "target"}, -- Drain Life
        { spell = 265931, type = "debuff", unit = "target"}, -- Conflagrate
        { spell = 334275, type = "debuff", unit = "target"}, -- Curse of Exhaustion
      },
      icon = "Interface\\Icons\\Spell_fire_immolation"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 126, type = "ability"}, -- Eye of Kilrogg
        { spell = 172, type = "ability", requiresTarget = true, debuff = true}, -- Corruption
        { spell = 348, type = "ability", requiresTarget = true, debuff = true}, -- Immolate
        { spell = 686, type = "ability"}, -- Incinerate
        { spell = 698, type = "ability"}, -- Ritual of Summoning
        { spell = 702, type = "ability", requiresTarget = true, debuff = true}, -- Curse of Weakness
        { spell = 710, type = "ability", requiresTarget = true, debuff = true}, -- Banish
        { spell = 1098, type = "ability"}, -- Subjugate Demon
        { spell = 1122, type = "ability", duration = 30}, -- Summon Infernal
        { spell = 1714, type = "ability", requiresTarget = true, debuff = true}, -- Curse of Tongues
        { spell = 3110, type = "ability", requiresTarget = true}, -- Firebolt
        { spell = 3716, type = "ability", requiresTarget = true}, -- Consuming Shadows
        { spell = 5484, type = "ability"}, -- Howl of Terror
        { spell = 5740, type = "ability"}, -- Rain of Fire
        { spell = 5782, type = "ability", requiresTarget = true, debuff = true}, -- Fear
        { spell = 6353, type = "ability", talent = 3 }, -- Soul Fire
        { spell = 6358, type = "ability", requiresTarget = true}, -- Seduction
        { spell = 6360, type = "ability", requiresTarget = true}, -- Whiplash
        { spell = 6789, type = "ability", requiresTarget = true, talent = 14 }, -- Mortal Coil
        { spell = 7814, type = "ability", requiresTarget = true}, -- Lash of Pain
        { spell = 7870, type = "ability"}, -- Lesser Invisibility
        { spell = 17735, type = "ability", requiresTarget = true, debuff = true}, -- Suffering
        { spell = 17767, type = "ability"}, -- Shadow Bulwark
        { spell = 17877, type = "ability", requiresTarget = true, charges = true, talent = 6 }, -- Shadowburn
        { spell = 17962, type = "ability", requiresTarget = true, charges = true}, -- Conflagrate
        { spell = 19647, type = "ability", requiresTarget = true}, -- Spell Lock
        { spell = 20707, type = "ability"}, -- Soulstone
        { spell = 29722, type = "ability", requiresTarget = true}, -- Incinerate
        { spell = 29893, type = "ability"}, -- Create Soulwell
        { spell = 30283, type = "ability"}, -- Shadowfury
        { spell = 48018, type = "ability"}, -- Demonic Circle
        { spell = 48020, type = "ability"}, -- Demonic Circle: Teleport
        { spell = 54049, type = "ability", requiresTarget = true}, -- Shadow Bite
        { spell = 80240, type = "ability", requiresTarget = true, debuff = true}, -- Havoc
        { spell = 89792, type = "ability"}, -- Flee
        { spell = 89808, type = "ability"}, -- Singe Magic
        { spell = 104773, type = "ability", buff = true}, -- Unending Resolve
        { spell = 108416, type = "ability", buff = true, talent = 9 }, -- Dark Pact
        { spell = 108503, type = "ability", talent = 18 }, -- Grimoire of Sacrifice
        { spell = 111771, type = "ability"}, -- Demonic Gateway
        { spell = 112042, type = "ability"}, -- Threatening Presence
        { spell = 113858, type = "ability", buff = true, talent = 21 }, -- Dark Soul: Instability
        { spell = 116858, type = "ability" }, -- Chaos Bolt
        { spell = 119898, type = "ability" }, -- Dark Command Demon
        { spell = 152108, type = "ability", talent = 12 }, -- Cataclysm
        { spell = 116858, type = "ability", requiresTarget = true}, -- Chaos Bolt
        { spell = 196447, type = "ability", usable = true, talent = 20 }, -- Channel Demonfire
        { spell = 234153, type = "ability", requiresTarget = true}, -- Drain Life
        { spell = 264993, type = "ability"}, -- Shadow Shield
        { spell = 333889, type = "ability" }, -- Fel Domination
        { spell = 334275, type = "ability", debuff = true, requiresTarget = true }, -- Curse of Exhaustion
      },
      icon = "Interface\\Icons\\Spell_fire_fireball"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\inv_misc_gem_amethyst_02",
    },
  },
}

templates.class.MONK = {
  [1] = { -- Brewmaster
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 101643, type = "buff", unit = "player"}, -- Transcendence
        { spell = 115176, type = "buff", unit = "player"}, -- Zen Meditation
        { spell = 116841, type = "buff", unit = "player", talent = 6 }, -- Tiger's Lust
        { spell = 116847, type = "buff", unit = "player", talent = 17 }, -- Rushing Jade Wind
        { spell = 119085, type = "buff", unit = "player", talent = 5 }, -- Chi Torpedo
        { spell = 120954, type = "buff", unit = "player"}, -- Fortifying Brew
        { spell = 122278, type = "buff", unit = "player", talent = 15 }, -- Dampen Harm
        { spell = 132578, type = "buff", unit = "player" }, -- Invoke Niuzao, the Black Ox
        { spell = 195630, type = "buff", unit = "player"}, -- Elusive Brawler
        { spell = 196608, type = "buff", unit = "player", talent = 1 }, -- Eye of the Tiger
        { spell = 215479, type = "buff", unit = "player" }, -- Shuffle
        { spell = 228563, type = "buff", unit = "player", talent = 21 }, -- Blackout Combo
        { spell = 325190, type = "buff", unit = "player"}, -- Celestial Flames
      },
      icon = "Interface\\Icons\\Ability_monk_fortifyingale"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 113746, type = "debuff", unit = "target", forceOwnOnly = true, ownOnly = nil}, -- Mystic Touch
        { spell = 115078, type = "debuff", unit = "multi"}, -- Paralysis
        { spell = 116189, type = "debuff", unit = "target"}, -- Provoke
        { spell = 117952, type = "debuff", unit = "target"}, -- Crackling Jade Lightning
        { spell = 121253, type = "debuff", unit = "target"}, -- Keg Smash
        { spell = 124273, type = "debuff", unit = "player" }, -- Heavy Stagger
        { spell = 124274, type = "debuff", unit = "player" }, -- Moderate Stagger
        { spell = 124275, type = "debuff", unit = "player" }, -- Light Stagger
        { spell = 119381, type = "debuff", unit = "target"}, -- Leg Sweep
        { spell = 196608, type = "debuff", unit = "target", talent = 1 }, -- Eye of the Tiger
        { spell = 325153, type = "debuff", unit = "target"}, -- Exploding Keg
      },
      icon = "Interface\\Icons\\Monk_stance_drunkenox"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 100780, type = "ability"}, -- Tiger Palm
        { spell = 100784, type = "ability"}, -- Blackout Kick
        { spell = 101546, type = "ability"}, -- Spinning Crane Kick
        { spell = 101643, type = "ability"}, -- Transcendence
        { spell = 107079, type = "ability"}, -- Quaking Palm
        { spell = 109132, type = "ability", charges = true}, -- Roll
        { spell = 115008, type = "ability", charges = true, talent = 5 }, -- Chi Torpedo
        { spell = 115078, type = "ability", requiresTarget = true}, -- Paralysis
        { spell = 115098, type = "ability", talent = 2 }, -- Chi Wave
        { spell = 115176, type = "ability", buff = true}, -- Zen Meditation
        { spell = 115181, type = "ability", debuff = true, overlayGlow = true}, -- Breath of Fire
        { spell = 115203, type = "ability", buff = true}, -- Fortifying Brew
        { spell = 115315, type = "ability", totem = true, totemNumber = 1, talent = 11 }, -- Summon Black Ox Statue
        { spell = 115399, type = "ability", talent = 9 }, -- Blackw Ox Brew
        { spell = 115546, type = "ability", debuff = true, requiresTarget = true}, -- Provoke
        { spell = 116670, type = "ability"}, -- Vivify
        { spell = 116705, type = "ability"}, -- Spear Hand Strike
        { spell = 116841, type = "ability", talent = 6 }, -- Tiger's Lust
        { spell = 116844, type = "ability", talent = 12 }, -- Ring of Peace
        { spell = 116847, type = "ability", buff = true, talent = 17 }, -- Rushing Jade Wind
        { spell = 117952, type = "ability"}, -- Crackling Jade Lightning
        { spell = 119381, type = "ability"}, -- Leg Sweep
        { spell = 119582, type = "ability", charges = true}, -- Purifying Brew
        { spell = 119996, type = "ability"}, -- Transcendence: Transfer
        { spell = 121253, type = "ability", requiresTarget = true, debuff = true}, -- Keg Smash
        { spell = 122278, type = "ability", buff = true, talent = 15 }, -- Dampen Harm
        { spell = 122281, type = "ability", charges = true, buff = true, talent = 14 }, -- Healing Elixir
        { spell = 123986, tyqpe = "ability", talent = 3 }, -- Chi Burst
        { spell = 126892, type = "ability"}, -- Zen Pilgrimage
        { spell = 132578, type = "ability", buff = true, requiresTarget = true }, -- Invoke Niuzao, the Black Ox
        { spell = 205523, type = "ability", requiresTarget = true}, -- Blackout Strike
        { spell = 218164, type = "ability"}, -- Detox
        { spell = 322101, type = "ability"}, -- Expel Harm
        { spell = 322109, type = "ability"}, -- Touch of Death
        { spell = 325153, type = "ability", debuff = true}, -- Exploding Keg
        { spell = 322507, type = "ability", buff = true}, -- Celestial Brew
        { spell = 324312, type = "ability"}, -- Clash

      },
      icon = "Interface\\Icons\\Inv_misc_beer_06"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\monk_stance_drunkenox",
    },
  },
  [2] = { -- Mistweaver
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 101643, type = "buff", unit = "player"}, -- Transcendence
        { spell = 116680, type = "buff", unit = "player"}, -- Thunder Focus Tea
        { spell = 115175, type = "buff", unit = "target"}, -- Soothing Mist
        { spell = 116841, type = "buff", unit = "player", talent = 6 }, -- Tiger's Lust
        { spell = 116849, type = "buff", unit = "target"}, -- Life Cocoon
        { spell = 119085, type = "buff", unit = "player", talent = 5 }, -- Chi Torpedo
        { spell = 119611, type = "buff", unit = "target"}, -- Renewing Mist
        { spell = 122278, type = "buff", unit = "player", talent = 15 }, -- Dampen Harm
        { spell = 122783, type = "buff", unit = "player", talent = 14 }, -- Diffuse Magic
        { spell = 124682, type = "buff", unit = "target"}, -- Enveloping Mist
        { spell = 191840, type = "buff", unit = "player"}, -- Essence Font
        { spell = 196725, type = "buff", unit = "player", talent = 17 }, -- Refreshing Jade Wind
        { spell = 197908, type = "buff", unit = "player", talent = 9 }, -- Mana Tea
        { spell = 197916, type = "buff", unit = "player", talent = 7 }, -- Lifecycles (Vivify)
        { spell = 197919, type = "buff", unit = "player", talent = 7 }, -- Lifecycles (Enveloping Mist)
        { spell = 243435, type = "buff", unit = "player"}, -- Fortifying Brew
        { spell = 202090, type = "buff", unit = "player"}, -- Teachings of the Monastery

      },
      icon = "Interface\\Icons\\Ability_monk_renewingmists"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 113746, type = "debuff", unit = "target", forceOwnOnly = true, ownOnly = nil}, -- Mystic Touch
        { spell = 115078, type = "debuff", unit = "multi"}, -- Paralysis
        { spell = 116189, type = "debuff", unit = "target"}, -- Provoke
        { spell = 117952, type = "debuff", unit = "target"}, -- Crackling Jade Lightning
        { spell = 119381, type = "debuff", unit = "target"}, -- Leg Sweep
        { spell = 198909, type = "debuff", unit = "target", talent = 11}, -- Song of Chi-Ji
      },
      icon = "Interface\\Icons\\Ability_monk_paralysis"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 100780, type = "ability", requiresTarget = true}, -- Tiger Palm
        { spell = 100784, type = "ability", requiresTarget = true}, -- Blackout Kick
        { spell = 101546, type = "ability"}, -- Spinning Crane Kick
        { spell = 101643, type = "ability"}, -- Transcendence
        { spell = 107079, type = "ability"}, -- Quaking Palm
        { spell = 107428, type = "ability", requiresTarget = true}, -- Rising Sun Kick
        { spell = 109132, type = "ability", charges = true}, -- Roll
        { spell = 115008, type = "ability", charges = true, talent = 5 }, -- Chi Torpedo
        { spell = 115078, type = "ability", requiresTarget = true}, -- Paralysis
        { spell = 115098, type = "ability", talent = 2 }, -- Chi Wave
        { spell = 115175, type = "ability"}, -- Soothing Mist
        { spell = 115203, type = "ability", buff = true}, -- Fortifying Brew
        { spell = 115151, type = "ability", charges = true, buff = true}, -- Renewing Mist
        { spell = 115310, type = "ability"}, -- Revival
        { spell = 115313, type = "ability", totem = true, totemNumber = 1, talent = 16 }, -- Summon Jade Serpent Statue
        { spell = 115540, type = "ability"}, -- Detox
        { spell = 115546, type = "ability", debuff = true, requiresTarget = true}, -- Provoke
        { spell = 116670, type = "ability"}, -- Vivify
        { spell = 116680, type = "ability", buff = true, charges = true}, -- Thunder Focus Tea
        { spell = 116841, type = "ability", talent = 6 }, -- Tiger's Lust
        { spell = 116844, type = "ability", talent = 12 }, -- Ring of Peace
        { spell = 116849, type = "ability", buff = true, requiresTarget = true}, -- Life Cocoon
        { spell = 117952, type = "ability"}, -- Crackling Jade Lightning
        { spell = 119381, type = "ability", debuff = true}, -- Leg Sweep
        { spell = 119996, type = "ability"}, -- Transcendence: Transfer
        { spell = 122278, type = "ability", buff = true, talent = 15 }, -- Dampen Harm
        { spell = 122281, type = "ability", charges = true, buff = true, talent = 13 }, -- Healing Elixir
        { spell = 122783, type = "ability", buff = true, talent = 14 }, -- Diffuse Magic
        { spell = 123986, type = "ability", talent = 3 }, -- Chi Burst
        { spell = 124682, type = "ability", buff = true, requiresTarget = true }, -- Enveloping Mist
        { spell = 126892, type = "ability"}, -- Zen Pilgrimage
        { spell = 191837, type = "ability"}, -- Essence Font
        { spell = 196725, type = "ability", buff = true, talent = 17 }, -- Refreshing Jade Wind
        { spell = 197908, type = "ability", buff = true, talent = 9 }, -- Mana Tea
        { spell = 198898, type = "ability", talent = 11 }, -- Song of Chi-Ji
        { spell = 218164, type = "ability"}, -- Detox
        { spell = 243435, type = "ability", buff = true}, -- Fortifying Brew
        { spell = 322101, type = "ability"}, -- Expel Harm
        { spell = 322109, type = "ability", usable = true}, -- Touch of Death
        { spell = 322118, type = "ability", duration = 25}, -- Invoke Yu'lon, the Jade Serpent
        { spell = 325197, type = "ability", talent = 18 }, -- Invoke Chi-Ji, the Red Crane
      },
      icon = "Interface\\Icons\\Ability_monk_chicocoon"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\inv_elemental_mote_mana",
    },
  },
  [3] = { -- Windwalker
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 101643, type = "buff", unit = "player"}, -- Transcendence
        { spell = 115288, type = "buff", unit = "player", talent = 9}, -- Energizing Brew
        { spell = 116768, type = "buff", unit = "player"}, -- Blackout Kick!
        { spell = 116841, type = "buff", unit = "player", talent = 6 }, -- Tiger's Lust
        { spell = 119085, type = "buff", unit = "player", talent = 5 }, -- Chi Torpedo
        { spell = 122783, type = "buff", unit = "player", talent = 14 }, -- Diffuse Magic
        { spell = 122278, type = "buff", unit = "player", talent = 15 }, -- Dampen Harm
        { spell = 125174, type = "buff", unit = "player"}, -- Touch of Karma
        { spell = 137639, type = "buff", unit = "player"}, -- Storm, Earth, and Fire
        { spell = 152173, type = "buff", unit = "player", talent = 21 }, -- Serenity
        { spell = 166646, type = "buff", unit = "player" }, -- Windwalking
        { spell = 196608, type = "buff", unit = "player", talent = 1 }, -- Eye of the Tiger
        { spell = 196741, type = "buff", unit = "player", talent = 16 }, -- Hit Combo
        { spell = 243435, type = "buff", unit = "player" }, -- Fortifying Brew
        { spell = 261715, type = "buff", unit = "player", talent = 17 }, -- Rushing Jade Wind
        { spell = 261769, type = "buff", unit = "player", talent = 13 }, -- Inner Strength
        { spell = 325202, type = "buff", unit = "player", talent = 18 }, -- Dance of Chi-Ji
      },
      icon = "Interface\\Icons\\Monk_stance_whitetiger"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 113746, type = "debuff", unit = "target", forceOwnOnly = true, ownOnly = nil}, -- Mystic Touch
        { spell = 115078, type = "debuff", unit = "multi"}, -- Paralysis
        { spell = 115080, type = "debuff", unit = "target"}, -- Touch of Death
        { spell = 115804, type = "debuff", unit = "target"}, -- Mortal Wounds
        { spell = 116189, type = "debuff", unit = "target"}, -- Provoke
        { spell = 116706, type = "debuff", unit = "target"}, -- Disable
        { spell = 117952, type = "debuff", unit = "target"}, -- Crackling Jade Lightning
        { spell = 119381, type = "debuff", unit = "target"}, -- Leg Sweep
        { spell = 122470, type = "debuff", unit = "target"}, -- Touch of Karma
        { spell = 123586, type = "debuff", unit = "target"}, -- Flying Serpent Kick
        { spell = 196608, type = "debuff", unit = "target", talent = 1 }, -- Eye of the Tiger
        { spell = 228287, type = "debuff", unit = "target"}, -- Mark of the Crane

      },
      icon = "Interface\\Icons\\Ability_monk_paralysis"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 100780, type = "ability", requiresTarget = true}, -- Tiger Palm
        { spell = 100784, type = "ability", requiresTarget = true, overlayGlow = true}, -- Blackout Kick
        { spell = 101545, type = "ability"}, -- Flying Serpent Kick
        { spell = 101546, type = "ability", overlayGlow = true}, -- Spinning Crane Kick
        { spell = 101643, type = "ability"}, -- Transcendence
        { spell = 107428, type = "ability", requiresTarget = true}, -- Rising Sun Kick
        { spell = 109132, type = "ability", charges = true}, -- Roll
        { spell = 113656, type = "ability", requiresTarget = true}, -- Fists of Fury
        { spell = 115008, type = "ability", charges = true, talent = 5 }, -- Chi Torpedo
        { spell = 115078, type = "ability", requiresTarget = true}, -- Paralysis
        { spell = 115098, type = "ability", talent = 2 }, -- Chi Wave
        { spell = 115203, type = "ability", buff = true }, -- Fortifying Brew
        { spell = 115288, type = "ability", talent = 9 }, -- Energizing Elixir
        { spell = 115546, type = "ability", debuff = true, requiresTarget = true}, -- Provoke
        { spell = 116095, type = "ability", requiresTarget = true}, -- Disable
        { spell = 116705, type = "ability", requiresTarget = true}, -- Spear Hand Strike
        { spell = 116670, type = "ability"}, -- Vivify
        { spell = 116841, type = "ability", talent = 6 }, -- Tiger's Lust
        { spell = 116844, type = "ability", talent = 12 }, -- Ring of Peace
        { spell = 116847, type = "ability", talent = 17 }, -- Rushing Jade Wind
        { spell = 117952, type = "ability"}, -- Crackling Jade Lightning
        { spell = 119381, type = "ability"}, -- Leg Sweep
        { spell = 119996, type = "ability"}, -- Transcendence: Transfer
        { spell = 122278, type = "ability", buff = true, talent = 15 }, -- Dampen Harm
        { spell = 122470, type = "ability", debuff = true, requiresTarget = true}, -- Touch of Karma
        { spell = 122783, type = "ability", buff = true, talent = 14 }, -- Diffuse Magic
        { spell = 123904, type = "ability", requiresTarget = true }, -- Invoke Xuen, the White Tiger
        { spell = 123986, type = "ability", talent = 3 }, -- Chi Burst
        { spell = 126892, type = "ability"}, -- Zen Pilgrimage
        { spell = 137639, type = "ability", charges = true, buff = true}, -- Storm, Earth, and Fire
        { spell = 152173, type = "ability", buff = true, talent = 21 }, -- Serenity
        { spell = 152175, type = "ability", usable = true, talent = 20 }, -- Whirling Dragon Punch
        { spell = 218164, type = "ability"}, -- Detox
        { spell = 261715, type = "ability", buff = true, talent = 17 }, -- Rushing Jade Wind
        { spell = 261947, type = "ability", talent = 8 }, -- Fist of the White Tiger
        { spell = 322101, type = "ability"}, -- Expel Harm
        { spell = 322109, type = "ability", usable = true, requiresTarget = true}, -- Touch of Death
      },
      icon = "Interface\\Icons\\Monk_ability_fistoffury"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\ability_monk_healthsphere",
    },
  },
}

templates.class.DRUID = {
  [1] = { -- Balance
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 768, type = "buff", unit = "player"}, -- Cat Form
        { spell = 774, type = "buff", unit = "player", talent = 9 }, -- Rejuvenation
        { spell = 783, type = "buff", unit = "player"}, -- Travel Form
        { spell = 1850, type = "buff", unit = "player"}, -- Dash
        { spell = 5215, type = "buff", unit = "player"}, -- Prowl
        { spell = 5487, type = "buff", unit = "player"}, -- Bear Form
        { spell = 8936, type = "buff", unit = "player"}, -- Regrowth
        { spell = 22812, type = "buff", unit = "player"}, -- Barkskin
        { spell = 22842, type = "buff", unit = "player", talent = 8 }, -- Frenzied Regeneration
        { spell = 24858, type = "buff", unit = "player"}, -- Moonkin Form
        { spell = 29166, type = "buff", unit = "group"}, -- Innervate
        { spell = 48517, type = "buff", unit = "player" }, -- Eclipse (Solar)
        { spell = 48438, type = "buff", unit = "player", talent = 9 }, -- Wild Growth
        { spell = 48518, type = "buff", unit = "player" }, -- Eclipse (Lunar)
        { spell = 102560, type = "buff", unit = "player", talent = 15 }, -- Incarnation: Chosen of Elune
        { spell = 106898, type = "buff", unit = "player" }, -- Stampeding Roar
        { spell = 108294, type = "buff", unit = "player", talent = 12 }, -- Heart of the Wild
        { spell = 191034, type = "buff", unit = "player"}, -- Starfall
        { spell = 192081, type = "buff", unit = "player" }, -- Ironfur
        { spell = 194223, type = "buff", unit = "player"}, -- Celestial Alignment
        { spell = 202425, type = "buff", unit = "player", talent = 2 }, -- Warrior of Elune
        { spell = 202461, type = "buff", unit = "player", talent = 16 }, -- Stellar Drift
        { spell = 252216, type = "buff", unit = "player", talent = 4 }, -- Tiger Dash
        { spell = 279709, type = "buff", unit = "player", talent = 14 }, -- Starlord
      },
      icon = "Interface\\Icons\\Spell_nature_stoneclawtotem"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 339, type = "debuff", unit = "multi"}, -- Entangling Roots
        { spell = 1079, type = "debuff", unit = "target", talent = 7 }, -- Rip
        { spell = 2637, type = "debuff", unit = "multi"}, -- Hibernate
        { spell = 5211, type = "debuff", unit = "target", talent = 10 }, -- Mighty Bash
        { spell = 6795, type = "debuff", unit = "target"}, -- Growl
        { spell = 33786, type = "debuff", unit = "target"}, -- Cyclone
        { spell = 61391, type = "debuff", unit = "target"}, -- Typhoon
        { spell = 81261, type = "debuff", unit = "target"}, -- Solar Beam
        { spell = 102359, type = "debuff", unit = "target", talent = 11 }, -- Mass Entanglement
        { spell = 155722, type = "debuff", unit = "target", talent = 7 }, -- Rake
        { spell = 164812, type = "debuff", unit = "target"}, -- Moonfire
        { spell = 164815, type = "debuff", unit = "target"}, -- Sunfire
        { spell = 192090, type = "debuff", unit = "target", talent = 8 }, -- Thrash
        { spell = 202347, type = "debuff", unit = "target", talent = 18 }, -- Stellar Flare
        { spell = 205644, type = "debuff", unit = "target", talent = 3 }, -- Force of Nature
      },
      icon = "Interface\\Icons\\ability_vehicle_sonicshockwave"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 99, type = "ability", talent = 8}, -- Incapacitating Roar
        { spell = 339, type = "ability", debuff = true}, -- Entangling Roots
        { spell = 768, type = "ability"}, -- Cat Form
        { spell = 783, type = "ability"}, -- Travel Form
        { spell = 1079, type = "ability", talent = 7}, -- Rip
        { spell = 1822, type = "ability", debuff = true, talent = 7}, -- Rake
        { spell = 1850, type = "ability", buff = true}, -- Dash
        { spell = 2782, type = "ability"}, -- Remove Corruption
        { spell = 2908, type = "ability", requiresTarget = true}, -- Soothe
        { spell = 5176, type = "ability", requiresTarget = true }, -- Wrath
        { spell = 5211, type = "ability", requiresTarget = true, talent = 10 }, -- Mighty Bash
        { spell = 5215, type = "ability", buff = true}, -- Prowl
        { spell = 5221, type = "ability"}, -- Shred
        { spell = 5487, type = "ability"}, -- Bear Form
        { spell = 6795, type = "ability", debuff = true, requiresTarget = true}, -- Growl
        { spell = 8921, type = "ability", requiresTarget = true, debuff = true}, -- Moonfire
        { spell = 8936, type = "ability"}, -- Regrowth
        { spell = 16979, type = "ability", requiresTarget = true, talent = 6 }, -- Wild Charge
        { spell = 18562, type = "ability", talent = 9 }, -- Swiftmend
        { spell = 20484, type = "ability"}, -- Rebirth
        { spell = 22568, type = "ability", requiresTarget = true}, -- Ferocious Bite
        { spell = 22570, type = "ability", requiresTarget = true, talent = 7}, -- Maim
        { spell = 22812, type = "ability", buff = true}, -- Barkskin
        { spell = 22842, type = "ability", buff = true, talent = 8 }, -- Frenzied Regeneration
        { spell = 24858, type = "ability"}, -- Moonkin Form
        { spell = 29166, type = "ability"}, -- Innervate
        { spell = 33917, type = "ability", requiresTarget = true}, -- Mangle
        { spell = 33786, type = "ability", requiresTarget = true, debuff = true}, -- Cyclone
        { spell = 48438, type = "ability", talent = 9 }, -- Wild Growth
        { spell = 49376, type = "ability", requiresTarget = true, talent = 6 }, -- Wild Charge
        { spell = 77758, type = "ability", talent = 8 }, -- Thrash
        { spell = 78674, type = "ability", requiresTarget = true}, -- Starsurge
        { spell = 78675, type = "ability", requiresTarget = true}, -- Solar Beam
        { spell = 93402, type = "ability", requiresTarget = true, debuff = true}, -- Sunfire
        { spell = 102359, type = "ability", requiresTarget = true, talent = 11 }, -- Mass Entanglement
        { spell = 102383, type = "ability", talent = 6 }, -- Wild Charge
        { spell = 102401, type = "ability", talent = 6 }, -- Wild Charge
        { spell = 102560, type = "ability", buff = true, talent = 15 }, -- Incarnation: Chosen of Elune
        { spell = 102793, type = "ability", talent = 9 }, -- Ursol's Vortex
        { spell = 106832, type = "ability", talent = 8 }, -- Thrash
        { spell = 106898, type = "ability" }, -- Stampeding Roar
        { spell = 108238, type = "ability", talent = 5 }, -- Renewal
        { spell = 132469, type = "ability"}, -- Typhoon
        { spell = 190984, type = "ability", requiresTarget = true, overlayGlow = true}, -- Solar Wrath
        { spell = 191034, type = "ability", buff = true}, -- Starfall
        { spell = 192081, type = "ability", buff = true }, -- Ironfur
        { spell = 194153, type = "ability", requiresTarget = true, overlayGlow = true}, -- Starfire
        { spell = 194223, type = "ability", buff = true}, -- Celestial Alignment
        { spell = 202347, type = "ability", requiresTarget = true, debuff = true, talent = 18}, -- Stellar Flare
        { spell = 202425, type = "ability", buff = true, talent = 2 }, -- Warrior of Elune
        { spell = 202770, type = "ability", talent = 20 }, -- Fury of Elune
        { spell = 205636, type = "ability", duration = 10, talent = 3 }, -- Force of Nature
        { spell = 213764, type = "ability", talent = 7 }, -- Swipe
        { spell = 252216, type = "ability", buff = true, talent = 4 }, -- Tiger Dash
        { spell = 274281, type = "ability", requiresTarget = true, charges = true, talent = 21 }, -- New Moon
        { spell = 319454, type = "ability", buff = true, talent = 12}, -- Heart of the Wild
      },
      icon = "Interface\\Icons\\Ability_druid_bash"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources and Shapeshift Form"],
      args = {
      },
      icon = "Interface\\Icons\\ability_druid_eclipseorange",
    },
  },
  [2] = { -- Feral
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 768, type = "buff", unit = "player"}, -- Cat Form
        { spell = 774, type = "buff", unit = "player", talent = 9 }, -- Rejuvenation
        { spell = 783, type = "buff", unit = "player"}, -- Travel Form
        { spell = 1850, type = "buff", unit = "player"}, -- Dash
        { spell = 5215, type = "buff", unit = "player"}, -- Prowl
        { spell = 5217, type = "buff", unit = "player"}, -- Tiger's Fury
        { spell = 5487, type = "buff", unit = "player"}, -- Bear Form
        { spell = 8936, type = "buff", unit = "player"}, -- Regrowth
        { spell = 22812, type = "buff", unit = "player" }, -- Barkskin
        { spell = 22842, type = "buff", unit = "player", talent = 8 }, -- Frenzied Regeneration
        { spell = 48438, type = "buff", unit = "player", talent = 9 }, -- Wild Growth
        { spell = 52610, type = "buff", unit = "player", talent = 14 }, -- Savage Roar
        { spell = 61336, type = "buff", unit = "player"}, -- Survival Instincts
        { spell = 69369, type = "buff", unit = "player"}, -- Predatory Swiftness
        { spell = 102543, type = "buff", unit = "player", talent = 15 }, -- Incarnation: King of the Jungle
        { spell = 106898, type = "buff", unit = "player"}, -- Stampeding Roar
        { spell = 106951, type = "buff", unit = "player"}, -- Berserk
        { spell = 108294, type = "buff", unit = "player"}, -- Hearth of the Wild
        { spell = 135700, type = "buff", unit = "player"}, -- Clearcastingp
        { spell = 145152, type = "buff", unit = "player", talent = 20 }, -- Bloodtalons
        { spell = 192081, type = "buff", unit = "player" }, -- Ironfur
        { spell = 197625, type = "buff", unit = "player", talent = 7 }, -- Moonkin Form
        { spell = 252071, type = "buff", unit = "player", talent = 15 }, -- Jungle Stalker
        { spell = 252216, type = "buff", unit = "player", talent = 4 }, -- Tiger Dash
        { spell = 285646, type = "buff", unit = "player", talent = 16 }, -- Scent of Blood
      },
      icon = "Interface\\Icons\\Spell_nature_stoneclawtotem"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 339, type = "debuff", unit = "multi"}, -- Entangling Roots
        { spell = 1079, type = "debuff", unit = "target"}, -- Rip
        { spell = 2637, type = "debuff", unit = "multi"}, -- Hibernate
        { spell = 5211, type = "debuff", unit = "target", talent = 10 }, -- Mighty Bash
        { spell = 6795, type = "debuff", unit = "target"}, -- Growl
        { spell = 33786, type = "debuff", unit = "target"}, -- Cyclone
        { spell = 58180, type = "debuff", unit = "target"}, -- Infected Wounds
        { spell = 61391, type = "debuff", unit = "target", talent = 7 }, -- Typhoon
        { spell = 102359, type = "debuff", unit = "target", talent = 11 }, -- Mass Entanglement
        { spell = 106830, type = "debuff", unit = "target"}, -- Thrash
        { spell = 155625, type = "debuff", unit = "target"}, -- Moonfire
        { spell = 155722, type = "debuff", unit = "target"}, -- Rake
        { spell = 164815, type = "debuff", unit = "target", talent = 7 }, -- Sunfire
        { spell = 164812, type = "debuff", unit = "target"}, -- Moonfire
        { spell = 203123, type = "debuff", unit = "target"}, -- Maim
        { spell = 274838, type = "debuff", unit = "target", talent = 21 }, -- Feral Frenzy
      },
      icon = "Interface\\Icons\\ability_vehicle_sonicshockwave"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 99, type = "ability", talent = 8}, -- Incapacitating Roar
        { spell = 339, type = "ability", requiresTarget = true, overlayGlow = true}, -- Entangling Roots
        { spell = 768, type = "ability"}, -- Cat Form
        { spell = 774, type = "ability", buff = true, talent = 9}, -- Rejuvenation
        { spell = 783, type = "ability"}, -- Travel Form
        { spell = 1079, type = "ability", debuff = true, requiresTarget = true}, -- Rip
        { spell = 1822, type = "ability", debuff = true, requiresTarget = true}, -- Rake
        { spell = 1850, type = "ability", buff = true}, -- Dash
        { spell = 2637, type = "ability"}, -- Hibernate
        { spell = 2782, type = "ability"}, -- Remove Corruption
        { spell = 2908, type = "ability", requiresTarget = true}, -- Soothe
        { spell = 5176, type = "ability", requiresTarget = true }, -- Wrath
        { spell = 5211, type = "ability", requiresTarget = true, talent = 10 }, -- Mighty Bash
        { spell = 5215, type = "ability", buff = true}, -- Prowl
        { spell = 5217, type = "ability", buff = true}, -- Tiger's Fury
        { spell = 5221, type = "ability", requiresTarget = true, overlayGlow = true}, -- Shred
        { spell = 5487, type = "ability"}, -- Bear Form
        { spell = 6795, type = "ability", debuff = true, requiresTarget = true}, -- Growl
        { spell = 8921, type = "ability", debuff = true, requiresTarget = true}, -- Moonfire
        { spell = 8936, type = "ability", overlayGlow = true}, -- Regrowth
        { spell = 16979, type = "ability", requiresTarget = true, talent = 6 }, -- Wild Charge
        { spell = 18562, type = "ability", talent = 9, usable = true }, -- Swiftmend
        { spell = 20484, type = "ability"}, -- Rebirth
        { spell = 22568, type = "ability", requiresTarget = true}, -- Ferocious Bite
        { spell = 22570, type = "ability", requiresTarget = true, debuff = true}, -- Maim
        { spell = 22812, type = "ability", buff = true }, -- Barkskin
        { spell = 22842, type = "ability", buff = true, talent = 8 }, -- Frenzied Regeneration
        { spell = 33786, type = "ability", requiresTarget = true, debuff = true}, -- Cyclone
        { spell = 33917, type = "ability", requiresTarget = true}, -- Mangle
        { spell = 48438, type = "ability", talent = 9 }, -- Wild Growth
        { spell = 49376, type = "ability", requiresTarget = true, talent = 6 }, -- Wild Charge
        { spell = 52610, type = "ability", buff = true, talent = 14}, -- Savage Roar
        { spell = 61336, type = "ability", charges = true, buff = true}, -- Survival Instincts
        { spell = 102359, type = "ability", requiresTarget = true, talent = 11 }, -- Mass Entanglement
        { spell = 102401, type = "ability", talent = 6 }, -- Wild Charge
        { spell = 102543, type = "ability", buff = true, talent = 15 }, -- Incarnation: King of the Jungle
        { spell = 102793, type = "ability", talent = 9 }, -- Ursol's Vortex
        { spell = 106832, type = "ability", overlayGlow = true}, -- Thrash
        { spell = 106839, type = "ability", requiresTarget = true}, -- Skull Bash
        { spell = 106898, type = "ability", buff = true}, -- Stampeding Roar
        { spell = 106951, type = "ability"}, -- Berserk
        { spell = 108238, type = "ability", talent = 5 }, -- Renewal
        { spell = 132469, type = "ability", talent = 7 }, -- Typhoon
        { spell = 192081, type = "ability", buff = true }, -- Ironfur
        { spell = 197625, type = "ability", talent = 7 }, -- Moonkin Form
        { spell = 197626, type = "ability", requiresTarget = true, talent = 7 }, -- Starsurge
        { spell = 197628, type = "ability", requiresTarget = true, talent = 7 }, -- Starfire
        { spell = 197630, type = "ability", debuff = true, requiresTarget = true, talent = 7 }, -- Sunfire
        { spell = 202028, type = "ability", charges = true, overlayGlow = true, talent = 17 }, -- Brutal Slash
        { spell = 213764, type = "ability", overlayGlow = true}, -- Swipe
        { spell = 252216, type = "ability", buff = true, talent = 4 }, -- Tiger Dash
        { spell = 274837, type = "ability", requiresTarget = true, talent = 21 }, -- Feral Frenzy
        { spell = 285381, type = "ability", talent = 18 }, -- Primal Wrath
        { spell = 319454, type = "ability", talent = 12 }, -- Heart of the Wild
      },
      icon = "Interface\\Icons\\Ability_druid_bash"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources and Shapeshift Form"],
      args = {
      },
      icon = "Interface\\Icons\\inv_mace_2h_pvp410_c_01",
    },
  },
  [3] = { -- Guardian
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 774, type = "buff", unit = "player", talent = 9 }, -- Rejuvenation
        { spell = 768, type = "buff", unit = "player"}, -- Cat Form
        { spell = 783, type = "buff", unit = "player"}, -- Travel Form
        { spell = 1850, type = "buff", unit = "player"}, -- Dash
        { spell = 5215, type = "buff", unit = "player"}, -- Prowl
        { spell = 5487, type = "buff", unit = "player"}, -- Bear Form
        { spell = 8936, type = "buff", unit = "player"}, -- Regrowth
        { spell = 22812, type = "buff", unit = "player"}, -- Barkskin
        { spell = 22842, type = "buff", unit = "player"}, -- Frenzied Regeneration
        { spell = 48438, type = "buff", unit = "player", talent = 9 }, -- Wild Growth
        { spell = 50334, type = "buff", unit = "player" }, -- Berserk
        { spell = 61336, type = "buff", unit = "player"}, -- Survival Instincts
        { spell = 93622, type = "buff", unit = "player"}, -- Gore
        { spell = 102558, type = "buff", unit = "player", talent = 15 }, -- Incarnation: Guardian of Ursoc
        { spell = 106898, type = "buff", unit = "player"}, -- Stampeding Roarew
        { spell = 135286, type = "buff", unit = "player", talent = 20 }, -- Tooth and Claw
        { spell = 155835, type = "buff", unit = "player", talent = 3 }, -- Bristling Fur
        { spell = 192081, type = "buff", unit = "player"}, -- Ironfur
        { spell = 197625, type = "buff", unit = "player", talent = 7 }, -- Moonkin Form
        { spell = 203975, type = "buff", unit = "player", talent = 16 }, -- Earthwarden
        { spell = 213680, type = "buff", unit = "player", talent = 18 }, -- Guardian of Elune
        { spell = 213708, type = "buff", unit = "player", talent = 14 }, -- Galactic Guardian
        { spell = 252216, type = "buff", unit = "player", talent = 4 }, -- Tiger Dash
      },
      icon = "Interface\\Icons\\Spell_nature_stoneclawtotem"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 99, type = "debuff", unit = "target"}, -- Incapacitating Roar
        { spell = 339, type = "debuff", unit = "multi"}, -- Entangling Roots
        { spell = 1079, type = "debuff", unit = "target", talent = 8 }, -- Rip
        { spell = 2637, type = "debuff", unit = "multi"}, -- Hibernate
        { spell = 5211, type = "debuff", unit = "target", talent = 10 }, -- Mighty Bash
        { spell = 6795, type = "debuff", unit = "target"}, -- Growl
        { spell = 33786, type = "debuff", unit = "target"}, -- Cyclone
        { spell = 45334, type = "debuff", unit = "target", talent = 6 }, -- Immobilized
        { spell = 61391, type = "debuff", unit = "target", talent = 12 }, -- Typhoon
        { spell = 80313, type = "debuff", unit = "target", talent = 21 }, -- Pulverize
        { spell = 102359, type = "debuff", unit = "target", talent = 11 }, -- Mass Entanglement
        { spell = 155722, type = "debuff", unit = "target", talent = 8 }, -- Rake
        { spell = 164812, type = "debuff", unit = "target"}, -- Moonfire
        { spell = 164815, type = "debuff", unit = "target", talent = 7 }, -- Sunfire
        { spell = 192090, type = "debuff", unit = "target"}, -- Thrash
        { spell = 236748, type = "debuff", unit = "target", talent = 5 }, -- Intimidating Roar
        { spell = 345208, type = "debuff", unit = "target" }, -- Infected Wounds
      },
      icon = "Interface\\Icons\\ability_vehicle_sonicshockwave"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 99, type = "ability"}, -- Incapacitating Roar
        { spell = 339, type = "ability"}, -- Entangling Roots
        { spell = 768, type = "ability"}, -- Cat Form
        { spell = 774, type = "ability", buff = true, talent = 9}, -- Rejuvenation
        { spell = 783, type = "ability"}, -- Travel Form
        { spell = 1079, type = "ability", debuff = true, talent = 8}, -- Rip
        { spell = 1850, type = "ability", buff = true}, -- Dash
        { spell = 2782, type = "ability"}, -- Remove Corruption
        { spell = 2908, type = "ability", requiresTarget = true}, -- Soothe
        { spell = 5211, type = "ability", requiresTarget = true, talent = 10 }, -- Mighty Bash
        { spell = 5215, type = "ability", buff = true}, -- Prowl
        { spell = 5221, type = "ability"}, -- Shred
        { spell = 5487, type = "ability"}, -- Bear Form
        { spell = 6795, type = "ability", debuff = true, requiresTarget = true}, -- Growl
        { spell = 6807, type = "ability", requiresTarget = true}, -- Maul
        { spell = 8921, type = "ability", debuff = true, requiresTarget = true, overlayGlow = true}, -- Moonfire
        { spell = 8936, type = "ability"}, -- Regrowth
        { spell = 16979, type = "ability", requiresTarget = true, talent = 6 }, -- Wild Charge
        { spell = 18562, type = "ability", talent = 9, usable = true }, -- Swiftmend
        { spell = 20484, type = "ability"}, -- Rebirth
        { spell = 22812, type = "ability", buff = true}, -- Barkskin
        { spell = 22842, type = "ability", charges = true, buff = true}, -- Frenzied Regeneration
        { spell = 22568, type = "ability"}, -- Ferocious Bite
        { spell = 22570, type = "ability", talent = 8}, -- Maim
        { spell = 33786, type = "ability", requiresTarget = true, debuff = true}, -- Cyclone
        { spell = 33917, type = "ability", requiresTarget = true, overlayGlow = true}, -- Mangle
        { spell = 48438, type = "ability", talent = 9 }, -- Wild Growth
        { spell = 49376, type = "ability", requiresTarget = true, talent = 6 }, -- Wild Charge
        { spell = 50334, type = "ability", buff = true}, -- Berserk
        { spell = 61336, type = "ability", charges = true, buff = true}, -- Survival Instincts
        { spell = 77758, type = "ability"}, -- Thrash
        { spell = 77761, type = "ability", buff = true}, -- Stampeding Roar
        { spell = 80313, type = "ability", buff = true, requiresTarget = true, usable = true, talent = 21}, -- Pulverize
        { spell = 102359, type = "ability", requiresTarget = true, talent = 11 }, -- Mass Entanglement
        { spell = 102383, type = "ability", talent = 6 }, -- Wild Charge
        { spell = 102401, type = "ability", talent = 6 }, -- Wild Charge
        { spell = 102558, type = "ability", buff = true, talent = 15 }, -- Incarnation: Guardian of Ursoc
        { spell = 102359, type = "ability", requiresTarget = true, talent = 11}, -- Mass Entanglement
        { spell = 102793, type = "ability", talent = 9 }, -- Ursol's Vortex
        { spell = 106832, type = "ability", requiresTarget = true}, -- Thrash
        { spell = 106839, type = "ability", requiresTarget = true}, -- Skull Bash
        { spell = 106898, type = "ability"}, -- Stampeding Roar
        { spell = 108238, type = "ability"}, -- Renewal
        { spell = 132469, type = "ability", talent = 7 }, -- Typhoon
        { spell = 155835, type = "ability", buff = true, talent = 3 }, -- Bristling Fur
        { spell = 192081, type = "ability", buff = true}, -- Ironfur
        { spell = 197626, type = "ability", requiresTarget = true, talent = 7 }, -- Starsurge
        { spell = 197628, type = "ability", requiresTarget = true, talent = 7 }, -- Starfire
        { spell = 197630, type = "ability", requiresTarget = true, talent = 7 }, -- Sunfire
        { spell = 204066, type = "ability", talent = 20 }, -- Lunar Beam
        { spell = 213764, type = "ability" }, -- Swipe
        { spell = 236748, type = "ability", talent = 5 }, -- Intimidating Roar
        { spell = 252216, type = "ability", buff = true, talent = 4 }, -- Tiger Dash
        { spell = 319454, type = "ability", buff = true, talent = 12 }, -- Heart of the Wild
      },
      icon = "Interface\\Icons\\Ability_druid_bash"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources and Shapeshift Form"],
      args = {
      },
      icon = "Interface\\Icons\\spell_misc_emotionangry",
    },
  },
  [4] = { -- Restoration
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 768, type = "buff", unit = "player"}, -- Cat Form
        { spell = 774, type = "buff", unit = "target"}, -- Rejuvenation
        { spell = 783, type = "buff", unit = "player"}, -- Travel Form
        { spell = 1850, type = "buff", unit = "player"}, -- Dash
        { spell = 5215, type = "buff", unit = "player"}, -- Prowl
        { spell = 5487, type = "buff", unit = "player"}, -- Bear Form
        { spell = 8936, type = "buff", unit = "target"}, -- Regrowth
        { spell = 16870, type = "buff", unit = "player"}, -- Clearcasting
        { spell = 22812, type = "buff", unit = "target"}, -- Barkskin
        { spell = 22842, type = "buff", unit = "player", talent = 9 }, -- Frenzied Regeneration
        { spell = 33891, type = "buff", unit = "player", talent = 15 }, -- Incarnation: Tree of Life
        { spell = 29166, type = "buff", unit = "player"}, -- Innervate
        { spell = 33763, type = "buff", unit = "target"}, -- Lifebloom
        { spell = 48438, type = "buff", unit = "player"}, -- Wild Growth
        { spell = 102351, type = "buff", unit = "player", talent = 3 }, -- Cenarion Ward
        { spell = 102342, type = "buff", unit = "player"}, -- Ironbark
        { spell = 102401, type = "buff", unit = "player", talent = 6 }, -- Wild Charge
        { spell = 106898, type = "buff", unit = "player" }, -- Stampeding Roar
        { spell = 114108, type = "buff", unit = "player", talent = 13 }, -- Soul of the Forest
        { spell = 117679, type = "buff", unit = "player", talent = 15 }, -- Incarnation
        { spell = 155777, type = "buff", unit = "target", talent = 20 }, -- Rejuvenation (Germination)
        { spell = 157982, type = "buff", unit = "player"}, -- Tranquility
        { spell = 192081, type = "buff", unit = "player" }, -- Ironfur
        { spell = 197625, type = "buff", unit = "player", talent = 7 }, -- Moonkin Form
        { spell = 197721, type = "buff", unit = "target", talent = 21 }, -- Flourish
        { spell = 200389, type = "buff", unit = "player", talent = 14 }, -- Cultivation
        { spell = 207640, type = "buff", unit = "player", talent = 1 }, -- Abundance
        { spell = 207386, type = "buff", unit = "target", talent = 17 }, -- Spring Blossoms
        { spell = 252216, type = "buff", unit = "player", talent = 4 }, -- Tiger Dash

      },
      icon = "Interface\\Icons\\Spell_nature_stoneclawtotem"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 339, type = "debuff", unit = "multi"}, -- Entangling Roots
        { spell = 1079, type = "debuff", unit = "target", talent = 8 }, -- Rip
        { spell = 1822, type = "debuff", unit = "target", talent = 8 }, -- Rake
        { spell = 2637, type = "debuff", unit = "multi"}, -- Hibernate
        { spell = 5211, type = "debuff", unit = "target", talent = 10 }, -- Mighty Bash
        { spell = 6795, type = "debuff", unit = "target"}, -- Growl
        { spell = 61391, type = "debuff", unit = "target", talent = 12 }, -- Typhoon
        { spell = 33786, type = "debuff", unit = "target"}, -- Cyclone
        { spell = 102359, type = "debuff", unit = "target", talent = 11 }, -- Mass Entanglement
        { spell = 127797, type = "debuff", unit = "target"}, -- Ursol's Vortex
        { spell = 155722, type = "debuff", unit = "target", talent = 8 }, -- Rake
        { spell = 164812, type = "debuff", unit = "target"}, -- Moonfire
        { spell = 164815, type = "debuff", unit = "target", talent = 7}, -- Sunfire
        { spell = 192090, type = "debuff", unit = "target", talent = 9 }, -- Thrash
      },
      icon = "Interface\\Icons\\ability_vehicle_sonicshockwave"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 99, type = "ability", debuff = true, talent = 9}, -- Incapacitating Roar
        { spell = 339, type = "ability", debuff = true}, -- Entangling Roots
        { spell = 740, type = "ability"}, -- Tranquility
        { spell = 768, type = "ability"}, -- Cat Form
        { spell = 774, type = "ability"}, -- Rejuvenation
        { spell = 783, type = "ability"}, -- Travel Form
        { spell = 1079, type = "ability", debuff = true, talent = 8}, -- Rip
        { spell = 1822, type = "ability", debuff = true, talent = 8}, -- Rake
        { spell = 1850, type = "ability", buff = true}, -- Dash
        { spell = 2637, type = "ability", requiresTarget = true}, -- Hibernate
        { spell = 2908, type = "ability", requiresTarget = true}, -- Soothe
        { spell = 5176, type = "ability"}, -- Wrath
        { spell = 5211, type = "ability", requiresTarget = true, talent = 10 }, -- Mighty Bash
        { spell = 5215, type = "ability", buff = true}, -- Prowl
        { spell = 5221, type = "ability"}, -- Shred
        { spell = 5487, type = "ability"}, -- Bear Form
        { spell = 6795, type = "ability", debuff = true, requiresTarget = true}, -- Growl
        { spell = 8921, type = "ability", requiresTarget = true, debuff = true}, -- Moonfire
        { spell = 8936, type = "ability"}, -- Regrowth
        { spell = 18562, type = "ability", usable = true}, -- Swiftmend
        { spell = 20484, type = "ability"}, -- Rebirth
        { spell = 22568, type = "ability", requiresTarget = true}, -- Ferocious Bite
        { spell = 22570, type = "ability", requiresTarget = true, talent = 8}, -- Maim
        { spell = 22812, type = "ability", buff = true}, -- Barkskin
        { spell = 22842, type = "ability", buff = true, talent = 9 }, -- Frenzied Regeneration
        { spell = 29166, type = "ability", buff = true}, -- Innervate
        { spell = 33786, type = "ability", requiresTarget = true, debuff = true}, -- Cyclone
        { spell = 33891, type = "ability", buff = true, talent = 15 }, -- Incarnation: Tree of Life
        { spell = 33917, type = "ability", requiresTarget = true}, -- Mangle
        { spell = 48438, type = "ability"}, -- Wild Growth
        { spell = 50464, type = "ability", talent = 2}, -- Nourish
        { spell = 77758, type = "ability", talent = 9 }, -- Thrash
        { spell = 88423, type = "ability"}, -- Nature's Cure
        { spell = 93402, type = "ability", requiresTarget = true, talent = 7 }, -- Sunfire
        { spell = 102342, type = "ability"}, -- Ironbark
        { spell = 102351, type = "ability", talent = 3 }, -- Cenarion Ward
        { spell = 102359, type = "ability", requiresTarget = true, talent = 11 }, -- Mass Entanglement
        { spell = 102401, type = "ability", talent = 6 }, -- Wild Charge
        { spell = 102793, type = "ability"}, -- Ursol's Vortex
        { spell = 106832, type = "ability", debuff = true, talent = 9 }, -- Thrash
        { spell = 106898, type = "ability" }, -- Stampeding Roar
        { spell = 108238, type = "ability", talent = 5 }, -- Renewal
        { spell = 108293, type = "buff", unit = "player", talent = 12 }, -- Heart of the Wild
        { spell = 132158, type = "ability" }, -- Nature's Swiftness
        { spell = 132469, type = "ability", talent = 7 }, -- Typhoon
        { spell = 192081, type = "ability", buff = true }, -- Ironfur
        { spell = 197625, type = "ability", talent = 7 }, -- Moonkin Form
        { spell = 197626, type = "ability", requiresTarget = true, talent = 7 }, -- Starsurge
        { spell = 197628, type = "ability", requiresTarget = true, talent = 7 }, -- Starfire
        { spell = 197721, type = "ability", talent = 21 }, -- Flourish
        { spell = 203651, type = "ability", talent = 18 }, -- Overgrowth
        { spell = 213764, type = "ability", talent = 8}, -- Swipe
        { spell = 252216, type = "ability", buff = true, talent = 4 }, -- Tiger Dash
        { spell = 319454, type = "ability", buff = true, talent = 12}, -- Heart of the Wild
      },
      icon = "Interface\\Icons\\Ability_druid_bash"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources and Shapeshift Form"],
      args = {
      },
      icon = "Interface\\Icons\\inv_elemental_mote_mana",
    },
  },
}

templates.class.DEATHKNIGHT = {
  [1] = { -- Blood
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 81162, type = "buff", unit = "player"}, -- Will of the Necropolis
        { spell = 49222, type = "buff", unit = "player"}, -- Bone Shield
        { spell = 81256, type = "buff", unit = "player"}, -- Dancing Rune Weapon
        { spell = 55233, type = "buff", unit = "player"}, -- Vampiric Blood
        { spell = 81141, type = "buff", unit = "player"}, -- Crimson Scourge
        { spell = 145677, type = "buff", unit = "player"}, -- Riposte
        { spell = 96171, type = "buff", unit = "player"}, -- Will of the Necropolis
        { spell = 132365, type = "buff", unit = "player"}, -- Vengeance
        { spell = 50421, type = "buff", unit = "player"}, -- Scent of Blood
        { spell = 126582, type = "buff", unit = "player"}, -- Unwavering Might
        { spell = 42650, type = "buff", unit = "player"}, -- Army of the Dead
        { spell = 48263, type = "buff", unit = "player"}, -- Blood Presence
        { spell = 48792, type = "buff", unit = "player"}, -- Icebound Fortitude
        { spell = 48266, type = "buff", unit = "player"}, -- Frost Presence
        { spell = 48707, type = "buff", unit = "player"}, -- Anti-Magic Shell
        { spell = 57330, type = "buff", unit = "player"}, -- Horn of Winter
        { spell = 48265, type = "buff", unit = "player"}, -- Unholy Presence
        { spell = 3714, type = "buff", unit = "player" }, -- Path of Frost
        { spell = 115989, type = "buff", unit = "player", talent = 3 }, -- Unholy Blight
        { spell = 49039, type = "buff", unit = "player", talent = 4 }, -- Lichborne
        { spell = 145629, type = "buff", unit = "player", talent = 5 }, -- Anti-Magic Zone
        { spell = 96268, type = "buff", unit = "player", talent = 7 }, -- Death's Advance
        { spell = 119975, type = "buff", unit = "player", talent = 12 }, -- Conversion
        { spell = 114851, type = "buff", unit = "player", talent = 13 }, -- Blood Charge
        { spell = 51460, type = "buff", unit = "player", talent = 15 }, -- Runic Corruption
        { spell = 108200, type = "buff", unit = "player", talent = 17 }, -- Remorseless Winter
        { spell = 115018, type = "buff", unit = "player", talent = 18 }, -- Desecrated Ground
      },
      icon = "Interface\\Icons\\spell_deathknight_iceboundfortitude"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 114866, type = "debuff", unit = "target"}, -- Soul Reaper
        { spell = 115798, type = "debuff", unit = "target"}, -- Weakened Blows
        { spell = 56222, type = "debuff", unit = "target"}, -- Dark Command
        { spell = 49560, type = "debuff", unit = "target"}, -- Death Grip
        { spell = 47476, type = "debuff", unit = "target"}, -- Strangulate
        { spell = 55095, type = "debuff", unit = "target"}, -- Frost Fever
        { spell = 43265, type = "debuff", unit = "target"}, -- Death and Decay
        { spell = 77606, type = "debuff", unit = "target"}, -- Dark Simulacrum
        { spell = 55078, type = "debuff", unit = "target"}, -- Blood Plague
        { spell = 45524, type = "debuff", unit = "target" }, -- Chains of Ice
        { spell = 96294, type = "debuff", unit = "target", talent = 8 }, -- Chains of Ice
        { spell = 50435, type = "debuff", unit = "target", talent = 8 }, -- Chilblains
        { spell = 108194, type = "debuff", unit = "target", talent = 9 }, -- Asphyxiate
        { spell = 73975, type = "debuff", unit = "target", talent = 13 }, -- Necrotic Strike
        { spell = 115001, type = "debuff", unit = "target", talent = 17 }, -- Remorseless Winter
        { spell = 115000, type = "debuff", unit = "target", talent = 17 }, -- Remorseless Winter
      },
      icon = "Interface\\Icons\\Spell_deathknight_frostfever"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 48982, type = "ability", usable = true }, -- Rune Tap
        { spell = 49028, type = "ability", usable = true }, -- Dancing Rune Weapon
        { spell = 49222, type = "ability", usable = true , buff = true }, -- Bone Shield
        { spell = 55050, type = "ability", usable = true, requiresTarget = true }, -- Heart Strike
        { spell = 55233, type = "ability", usable = true , buff = true }, -- Vampiric Blood
        { spell = 56222, type = "ability", usable = true, requiresTarget = true }, -- Dark Command
        { spell = 56815, type = "ability", usable = true, requiresTarget = true }, -- Rune Strike
        { spell = 114866, type = "ability", usable = true, requiresTarget = true }, -- Soul Reaper
        { spell = 3714, type = "ability", usable = true , buff = true }, -- Path of Frost
        { spell = 42650, type = "ability", usable = true , buff = true }, -- Army of the Dead
        { spell = 43265, type = "ability", usable = true }, -- Death and Decay
        { spell = 46584, type = "ability", usable = true }, -- Raise Dead
        { spell = 47476, type = "ability", usable = true, requiresTarget = true }, -- Strangulate
        { spell = 47528, type = "ability", usable = true, requiresTarget = true }, -- Mind Freeze
        { spell = 47541, type = "ability", usable = true, requiresTarget = true }, -- Death Coil
        { spell = 47568, type = "ability", usable = true }, -- Empower Rune Weapon
        { spell = 48707, type = "ability", usable = true , buff = true }, -- Anti-Magic Shell
        { spell = 45902, type = "ability", usable = true, requiresTarget = true }, -- Blood Strike
        { spell = 45477, type = "ability", usable = true, requiresTarget = true }, -- Icy Touch
        { spell = 45524, type = "ability", usable = true, requiresTarget = true }, -- Chains of Ice
        { spell = 48792, type = "ability", usable = true , buff = true }, -- Icebound Fortitude
        { spell = 49576, type = "ability", usable = true, requiresTarget = true }, -- Death Grip
        { spell = 50842, type = "ability", usable = true, requiresTarget = true }, -- Pestilence
        { spell = 73975, type = "ability", usable = true, requiresTarget = true }, -- Necrotic Strike
        { spell = 50977, type = "ability", usable = true, requiresTarget = true }, -- Death Gate
        { spell = 57330, type = "ability", usable = true , buff = true }, -- Horn of Winter
        { spell = 61999, type = "ability", usable = true }, -- Raise Ally
        { spell = 77575, type = "ability", usable = true, requiresTarget = true }, -- Outbreak
        { spell = 77606, type = "ability", usable = true, requiresTarget = true }, -- Dark Simulacrum
        { spell = 48721, type = "ability" , usable = true }, -- Blood Boil
        { spell = 111673, type = "ability", usable = true, requiresTarget = true }, -- Control Undead
        { spell = 123693, type = "ability", talent = 2 , usable = true, requiresTarget = true }, -- Plague Leech
        { spell = 115989, type = "ability", talent = 3 , usable = true , buff = true }, -- Unholy Blight
        { spell = 49039, type = "ability", talent = 4 , usable = true , buff = true }, -- Lichborne
        { spell = 51052, type = "ability", talent = 5 , usable = true }, -- Anti-Magic Zone
        { spell = 96268, type = "ability", talent = 7 , usable = true , buff = true }, -- Death's Advance
        { spell = 49998, type = "ability", talent = 8 , usable = true, requiresTarget = true }, -- Death Strike
        { spell = 108194, type = "ability", talent = 9 , usable = true, requiresTarget = true }, -- Asphyxiate
        { spell = 48743, type = "ability", talent = 10 , usable = true }, -- Death Pact
        { spell = 108196, type = "ability", talent = 11 , usable = true, requiresTarget = true }, -- Death Siphon
        { spell = 119975, type = "ability", talent = 12 , usable = true , buff = true }, -- Conversion
        { spell = 45529, type = "ability", talent = 13 , charges = true }, -- Blood Tap
        { spell = 108199, type = "ability", talent = 16 , usable = true, requiresTarget = true }, -- Gorefiend's Grasp
        { spell = 108200, type = "ability", talent = 17 , usable = true , buff = true }, -- Remorseless Winter
        { spell = 108201, type = "ability", talent = 18 , usable = true }, -- Desecrated Ground
      },
      icon = "Interface\\Icons\\Spell_shadow_antimagicshell"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\INV_Misc_Rune_10",
    },
  },
  [2] = { -- Frost
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 51124, type = "buff", unit = "player"}, -- Killing Machine
        { spell = 59052, type = "buff", unit = "player"}, -- Freezing Fog
        { spell = 51271, type = "buff", unit = "player"}, -- Pillar of Frost
        { spell = 126582, type = "buff", unit = "player"}, -- Unwavering Might
        { spell = 42650, type = "buff", unit = "player"}, -- Army of the Dead
        { spell = 48263, type = "buff", unit = "player"}, -- Blood Presence
        { spell = 48792, type = "buff", unit = "player"}, -- Icebound Fortitude
        { spell = 48266, type = "buff", unit = "player"}, -- Frost Presence
        { spell = 48707, type = "buff", unit = "player"}, -- Anti-Magic Shell
        { spell = 57330, type = "buff", unit = "player"}, -- Horn of Winter
        { spell = 48265, type = "buff", unit = "player"}, -- Unholy Presence
        { spell = 3714, type = "buff", unit = "player" }, -- Path of Frost
        { spell = 115989, type = "buff", unit = "player", talent = 3 }, -- Unholy Blight
        { spell = 49039, type = "buff", unit = "player", talent = 4 }, -- Lichborne
        { spell = 145629, type = "buff", unit = "player", talent = 5 }, -- Anti-Magic Zone
        { spell = 96268, type = "buff", unit = "player", talent = 7 }, -- Death's Advance
        { spell = 119975, type = "buff", unit = "player", talent = 12 }, -- Conversion
        { spell = 114851, type = "buff", unit = "player", talent = 13 }, -- Blood Charge
        { spell = 51460, type = "buff", unit = "player", talent = 15 }, -- Runic Corruption
        { spell = 108200, type = "buff", unit = "player", talent = 17 }, -- Remorseless Winter
        { spell = 115018, type = "buff", unit = "player", talent = 18 }, -- Desecrated Ground
      },
      icon = "Interface\\Icons\\spell_deathknight_iceboundfortitude"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 130735, type = "debuff", unit = "target"}, -- Soul Reaper
        { spell = 81326, type = "debuff", unit = "target"}, -- Physical Vulnerability
        { spell = 49560, type = "debuff", unit = "target"}, -- Death Grip
        { spell = 47476, type = "debuff", unit = "target"}, -- Strangulate
        { spell = 55095, type = "debuff", unit = "target"}, -- Frost Fever
        { spell = 43265, type = "debuff", unit = "target"}, -- Death and Decay
        { spell = 77606, type = "debuff", unit = "target"}, -- Dark Simulacrum
        { spell = 55078, type = "debuff", unit = "target"}, -- Blood Plague
        { spell = 45524, type = "debuff", unit = "target" }, -- Chains of Ice
        { spell = 96294, type = "debuff", unit = "target", talent = 8 }, -- Chains of Ice
        { spell = 50435, type = "debuff", unit = "target", talent = 8 }, -- Chilblains
        { spell = 108194, type = "debuff", unit = "target", talent = 9 }, -- Asphyxiate
        { spell = 73975, type = "debuff", unit = "target", talent = 13 }, -- Necrotic Strike
        { spell = 115001, type = "debuff", unit = "target", talent = 17 }, -- Remorseless Winter
        { spell = 115000, type = "debuff", unit = "target", talent = 17 }, -- Remorseless Winter

      },
      icon = "Interface\\Icons\\Spell_deathknight_frostfever"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 130735, type = "ability", usable = true, requiresTarget = true }, -- Soul Reaper
        { spell = 49020, type = "ability", usable = true, requiresTarget = true }, -- Obliterate
        { spell = 49143, type = "ability", usable = true, requiresTarget = true }, -- Frost Strike
        { spell = 51271, type = "ability", usable = true , buff = true }, -- Pillar of Frost
        { spell = 49184, type = "ability", usable = true, requiresTarget = true }, -- Howling Blast
        { spell = 3714, type = "ability", usable = true , buff = true }, -- Path of Frost
        { spell = 42650, type = "ability", usable = true , buff = true }, -- Army of the Dead
        { spell = 43265, type = "ability", usable = true }, -- Death and Decay
        { spell = 46584, type = "ability", usable = true }, -- Raise Dead
        { spell = 47476, type = "ability", usable = true, requiresTarget = true }, -- Strangulate
        { spell = 47528, type = "ability", usable = true, requiresTarget = true }, -- Mind Freeze
        { spell = 47541, type = "ability", usable = true, requiresTarget = true }, -- Death Coil
        { spell = 47568, type = "ability", usable = true }, -- Empower Rune Weapon
        { spell = 48707, type = "ability", usable = true , buff = true }, -- Anti-Magic Shell
        { spell = 45902, type = "ability", usable = true, requiresTarget = true }, -- Blood Strike
        { spell = 45477, type = "ability", usable = true, requiresTarget = true }, -- Icy Touch
        { spell = 45524, type = "ability", usable = true, requiresTarget = true }, -- Chains of Ice
        { spell = 48792, type = "ability", usable = true , buff = true }, -- Icebound Fortitude
        { spell = 49576, type = "ability", usable = true, requiresTarget = true }, -- Death Grip
        { spell = 50842, type = "ability", usable = true, requiresTarget = true }, -- Pestilence
        { spell = 73975, type = "ability", usable = true, requiresTarget = true }, -- Necrotic Strike
        { spell = 50977, type = "ability", usable = true }, -- Death Gate
        { spell = 57330, type = "ability", usable = true , buff = true }, -- Horn of Winter
        { spell = 61999, type = "ability", usable = true }, -- Raise Ally
        { spell = 77575, type = "ability", usable = true, requiresTarget = true }, -- Outbreak
        { spell = 77606, type = "ability", usable = true, requiresTarget = true }, -- Dark Simulacrum
        { spell = 48721, type = "ability" , usable = true }, -- Blood Boil
        { spell = 123693, type = "ability", talent = 2 , usable = true, requiresTarget = true }, -- Plague Leech
        { spell = 115989, type = "ability", talent = 3 , usable = true , buff = true }, -- Unholy Blight
        { spell = 49039, type = "ability", talent = 4 , usable = true , buff = true }, -- Lichborne
        { spell = 51052, type = "ability", talent = 5 , usable = true }, -- Anti-Magic Zone
        { spell = 96268, type = "ability", talent = 7 , usable = true , buff = true }, -- Death's Advance
        { spell = 49998, type = "ability", talent = 8 , usable = true, requiresTarget = true }, -- Death Strike
        { spell = 108194, type = "ability", talent = 9 , usable = true, requiresTarget = true }, -- Asphyxiate
        { spell = 48743, type = "ability", talent = 10 , usable = true }, -- Death Pact
        { spell = 108196, type = "ability", talent = 11 , usable = true, requiresTarget = true }, -- Death Siphon
        { spell = 119975, type = "ability", talent = 12 , usable = true , buff = true }, -- Conversion
        { spell = 45529, type = "ability", talent = 13 , charges = true }, -- Blood Tap
        { spell = 108199, type = "ability", talent = 16 , usable = true, requiresTarget = true }, -- Gorefiend's Grasp
        { spell = 108200, type = "ability", talent = 17 , usable = true , buff = true }, -- Remorseless Winter
        { spell = 108201, type = "ability", talent = 18 , usable = true }, -- Desecrated Ground
      },
      icon = "Interface\\Icons\\Inv_sword_62"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\INV_Misc_Rune_10",
    },
  },
  [3] = { -- Unholy
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 49016, type = "buff", unit = "player"}, -- Unholy Frenzy
        { spell = 81340, type = "buff", unit = "player"}, -- Sudden Doom
        { spell = 91342, type = "buff", unit = "player"}, -- Shadow Infusion
        { spell = 63560, type = "buff", unit = "target"}, -- Dark Transformation
        { spell = 63560, type = "buff", unit = "pet"}, -- Dark Transformation
        { spell = 91342, type = "buff", unit = "pet"}, -- Shadow Infusion
        { spell = 91837, type = "buff", unit = "pet"}, -- Putrid Bulwark
        { spell = 126582, type = "buff", unit = "player"}, -- Unwavering Might
        { spell = 42650, type = "buff", unit = "player"}, -- Army of the Dead
        { spell = 48263, type = "buff", unit = "player"}, -- Blood Presence
        { spell = 48792, type = "buff", unit = "player"}, -- Icebound Fortitude
        { spell = 48266, type = "buff", unit = "player"}, -- Frost Presence
        { spell = 48707, type = "buff", unit = "player"}, -- Anti-Magic Shell
        { spell = 57330, type = "buff", unit = "player"}, -- Horn of Winter
        { spell = 48265, type = "buff", unit = "player"}, -- Unholy Presence
        { spell = 3714, type = "buff", unit = "player" }, -- Path of Frost
        { spell = 115989, type = "buff", unit = "player", talent = 3 }, -- Unholy Blight
        { spell = 49039, type = "buff", unit = "player", talent = 4 }, -- Lichborne
        { spell = 145629, type = "buff", unit = "player", talent = 5 }, -- Anti-Magic Zone
        { spell = 96268, type = "buff", unit = "player", talent = 7 }, -- Death's Advance
        { spell = 119975, type = "buff", unit = "player", talent = 12 }, -- Conversion
        { spell = 114851, type = "buff", unit = "player", talent = 13 }, -- Blood Charge
        { spell = 51460, type = "buff", unit = "player", talent = 15 }, -- Runic Corruption
        { spell = 108200, type = "buff", unit = "player", talent = 17 }, -- Remorseless Winter
        { spell = 115018, type = "buff", unit = "player", talent = 18 }, -- Desecrated Ground
      },
      icon = "Interface\\Icons\\spell_deathknight_iceboundfortitude"
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 81326, type = "debuff", unit = "target"}, -- Physical Vulnerability
        { spell = 49206, type = "debuff", unit = "target"}, -- Summon Gargoyle
        { spell = 130736, type = "debuff", unit = "target"}, -- Soul Reaper
        { spell = 49560, type = "debuff", unit = "target"}, -- Death Grip
        { spell = 47476, type = "debuff", unit = "target"}, -- Strangulate
        { spell = 55095, type = "debuff", unit = "target"}, -- Frost Fever
        { spell = 43265, type = "debuff", unit = "target"}, -- Death and Decay
        { spell = 77606, type = "debuff", unit = "target"}, -- Dark Simulacrum
        { spell = 55078, type = "debuff", unit = "target"}, -- Blood Plague
        { spell = 45524, type = "debuff", unit = "target" }, -- Chains of Ice
        { spell = 96294, type = "debuff", unit = "target", talent = 8 }, -- Chains of Ice
        { spell = 50435, type = "debuff", unit = "target", talent = 8 }, -- Chilblains
        { spell = 108194, type = "debuff", unit = "target", talent = 9 }, -- Asphyxiate
        { spell = 73975, type = "debuff", unit = "target", talent = 13 }, -- Necrotic Strike
        { spell = 115001, type = "debuff", unit = "target", talent = 17 }, -- Remorseless Winter
        { spell = 115000, type = "debuff", unit = "target", talent = 17 }, -- Remorseless Winter
      },
      icon = "Interface\\Icons\\Spell_deathknight_frostfever"
    },
    [3] = {
      title = L["Abilities"],
      args = {
        { spell = 47468, type = "ability", usable = true }, -- Claw
        { spell = 47481, type = "ability", usable = true }, -- Gnaw
        { spell = 47482, type = "ability", usable = true }, -- Leap
        { spell = 47484, type = "ability", usable = true }, -- Huddle
        { spell = 49016, type = "ability", usable = true , buff = true }, -- Unholy Frenzy
        { spell = 49206, type = "ability", usable = true }, -- Summon Gargoyle
        { spell = 55090, type = "ability", usable = true, requiresTarget = true }, -- Scourge Strike
        { spell = 63560, type = "ability", charges = true , usable = true , buff = true, unit = 'pet' , debuff = true }, -- Dark Transformation
        { spell = 85948, type = "ability", usable = true, requiresTarget = true }, -- Festering Strike
        { spell = 130736, type = "ability", usable = true, requiresTarget = true }, -- Soul Reaper
        { spell = 3714, type = "ability", usable = true , buff = true }, -- Path of Frost
        { spell = 42650, type = "ability", usable = true , buff = true }, -- Army of the Dead
        { spell = 43265, type = "ability", usable = true }, -- Death and Decay
        { spell = 46584, type = "ability", usable = true }, -- Raise Dead
        { spell = 47476, type = "ability", usable = true, requiresTarget = true }, -- Strangulate
        { spell = 47528, type = "ability", usable = true, requiresTarget = true }, -- Mind Freeze
        { spell = 47541, type = "ability", usable = true, requiresTarget = true }, -- Death Coil
        { spell = 47568, type = "ability", usable = true }, -- Empower Rune Weapon
        { spell = 48707, type = "ability", usable = true , buff = true }, -- Anti-Magic Shell
        { spell = 45902, type = "ability", usable = true, requiresTarget = true }, -- Blood Strike
        { spell = 45477, type = "ability", usable = true, requiresTarget = true }, -- Icy Touch
        { spell = 45524, type = "ability", usable = true, requiresTarget = true }, -- Chains of Ice
        { spell = 48792, type = "ability", usable = true , buff = true }, -- Icebound Fortitude
        { spell = 49576, type = "ability", usable = true, requiresTarget = true }, -- Death Grip
        { spell = 50842, type = "ability", usable = true, requiresTarget = true }, -- Pestilence
        { spell = 73975, type = "ability", usable = true, requiresTarget = true }, -- Necrotic Strike
        { spell = 50977, type = "ability", usable = true }, -- Death Gate
        { spell = 57330, type = "ability", usable = true , buff = true }, -- Horn of Winter
        { spell = 61999, type = "ability", usable = true }, -- Raise Ally
        { spell = 77575, type = "ability", usable = true, requiresTarget = true }, -- Outbreak
        { spell = 77606, type = "ability", usable = true, requiresTarget = true }, -- Dark Simulacrum
        { spell = 48721, type = "ability" , usable = true }, -- Blood Boil
        { spell = 111673, type = "ability", usable = true, requiresTarget = true }, -- Control Undead
        { spell = 123693, type = "ability", talent = 2 , usable = true, requiresTarget = true }, -- Plague Leech
        { spell = 115989, type = "ability", talent = 3 , usable = true , buff = true }, -- Unholy Blight
        { spell = 49039, type = "ability", talent = 4 , usable = true , buff = true }, -- Lichborne
        { spell = 51052, type = "ability", talent = 5 , usable = true }, -- Anti-Magic Zone
        { spell = 96268, type = "ability", talent = 7 , usable = true , buff = true }, -- Death's Advance
        { spell = 49998, type = "ability", talent = 8 , usable = true, requiresTarget = true }, -- Death Strike
        { spell = 108194, type = "ability", talent = 9 , usable = true, requiresTarget = true }, -- Asphyxiate
        { spell = 48743, type = "ability", talent = 10 , usable = true }, -- Death Pact
        { spell = 108196, type = "ability", talent = 11 , usable = true, requiresTarget = true }, -- Death Siphon
        { spell = 119975, type = "ability", talent = 12 , usable = true , buff = true }, -- Conversion
        { spell = 45529, type = "ability", talent = 13 , charges = true }, -- Blood Tap
        { spell = 108199, type = "ability", talent = 16 , usable = true, requiresTarget = true }, -- Gorefiend's Grasp
        { spell = 108200, type = "ability", talent = 17 , usable = true , buff = true }, -- Remorseless Winter
        { spell = 108201, type = "ability", talent = 18 , usable = true }, -- Desecrated Ground
      },
      icon = "Interface\\Icons\\Spell_shadow_deathanddecay"
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\INV_Misc_Rune_10",
    },
  },
}

-- Items section
templates.items[1] = {
  title = L["Enchants"],
  args = {
    -- Windsong
    { spell = 104423, type = "buff", unit = "player"}, -- Haste
    { spell = 104509, type = "buff", unit = "player"}, -- Crit
    { spell = 104510, type = "buff", unit = "player"}, -- Mastery

    -- Dancing Steel
    { spell = 118334, type = "buff", unit = "player"}, -- Agility
    { spell = 118335, type = "buff", unit = "player"}, -- Strength
    { spell = 120032, type = "buff", unit = "player"}, -- Str + Agi
    { spell = 142530, type = "buff", unit = "player"}, -- Bloody (PvP) Str + Agi

    -- Others
    { spell = 116631, type = "buff", unit = "player"}, -- Colossus
    { spell = 142535, type = "buff", unit = "player"}, -- Spirit of Conquest
    { spell = 116660, type = "buff", unit = "player"}, -- River's Song
    { spell = 104993, type = "buff", unit = "player"}, -- Jade Spirit

    { spell = 126734, type = "buff", unit = "player"}, -- Synapse Springs
  }
}

templates.items[2] = {
  title = L["On Use Trinkets (Aura)"],
  args = {
    -- Tier 14
    -- Tier 15
    -- Tier 16
  }
}

templates.items[3] = {
  title = L["On Use Trinkets (CD)"],
  args = {
    -- Tier 14
    -- Tier 15
    -- Tier 16
  }
}

templates.items[4] = {
  title = L["On Procc Trinkets (Aura)"],
  args = {
    -- Tier 14
    -- Tier 15
    -- Tier 16
  }
}

templates.items[5] = {
  title = L["PVP Trinkets (Aura)"],
  args = {

  }
}

templates.items[6] = {
  title = L["PVP Trinkets (CD)"],
  args = {

  }
}


-- General Section
tinsert(templates.general.args, {
  title = L["Health"],
  icon = "Interface\\Icons\\trade_alchemy_potiona2",
  type = "health"
});
tinsert(templates.general.args, {
  title = L["Cast"],
  icon = "Interface\\Icons\\Spell_Shadow_SoothingKiss",
  type = "cast"
});
tinsert(templates.general.args, {
  title = L["Always Active"],
  icon = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura78",
  triggers = {[1] = { trigger = {
    type = WeakAuras.GetTriggerCategoryFor("Conditions"),
    event = "Conditions",
    use_alwaystrue = true}}}
});

tinsert(templates.general.args, {
  title = L["Pet alive"],
  icon = "Interface\\Icons\\ability_hunter_pet_raptor",
  triggers = {[1] = { trigger = {
    type = WeakAuras.GetTriggerCategoryFor("Conditions"),
    event = "Conditions",
    use_HasPet = true}}}
});

tinsert(templates.general.args, {
  title = L["Pet Behavior"],
  icon = "Interface\\Icons\\Ability_hunter_pet_assist",
  triggers = {[1] = { trigger = {
    type = WeakAuras.GetTriggerCategoryFor("Pet Behavior"),
    event = "Pet Behavior",
    use_behavior = true,
    behavior = "assist"}}}
});

tinsert(templates.general.args, {
  spell = 2825, type = "buff", unit = "player",
  forceOwnOnly = true,
  ownOnly = nil,
  overideTitle = L["Bloodlust/Heroism"],
  spellIds = {2825, 32182, 80353, 90355}}
);

-- Meta template for Power triggers
local function createSimplePowerTemplate(powertype)
  local power = {
    title = powerTypes[powertype].name,
    icon = powerTypes[powertype].icon,
    type = "power",
    powertype = powertype,
  }
  return power;
end

-------------------------------
-- Hardcoded trigger templates
-------------------------------
local resourceSection = 7
-- Warrior
for i = 1, 3 do
  tinsert(templates.class.WARRIOR[i][resourceSection].args, createSimplePowerTemplate(1));
end

-- Paladin
for i = 1, 3 do
  tinsert(templates.class.PALADIN[i][resourceSection].args, createSimplePowerTemplate(9));
  tinsert(templates.class.PALADIN[i][resourceSection].args, createSimplePowerTemplate(0));
end

-- Hunter
for i = 1, 3 do
  tinsert(templates.class.HUNTER[i][resourceSection].args, createSimplePowerTemplate(2));
end

-- Rogue
for i = 1, 3 do
  tinsert(templates.class.ROGUE[i][resourceSection].args, createSimplePowerTemplate(3));
  tinsert(templates.class.ROGUE[i][resourceSection].args, createSimplePowerTemplate(4));
end

-- Priest
for i = 1, 3 do
  tinsert(templates.class.PRIEST[i][resourceSection].args, createSimplePowerTemplate(0));
end
tinsert(templates.class.PRIEST[3][resourceSection].args, createSimplePowerTemplate(13));

-- Shaman
for i = 1, 3 do
  tinsert(templates.class.SHAMAN[i][resourceSection].args, createSimplePowerTemplate(0));
end

-- Mage
for i = 1, 3 do
  tinsert(templates.class.MAGE[i][resourceSection].args, createSimplePowerTemplate(0));
end

-- Warlock
for i = 1, 3 do
  tinsert(templates.class.WARLOCK[i][resourceSection].args, createSimplePowerTemplate(0));
  tinsert(templates.class.WARLOCK[i][resourceSection].args, createSimplePowerTemplate(7));
end

-- Monk
tinsert(templates.class.MONK[1][resourceSection].args, createSimplePowerTemplate(3));
tinsert(templates.class.MONK[2][resourceSection].args, createSimplePowerTemplate(0));
tinsert(templates.class.MONK[3][resourceSection].args, createSimplePowerTemplate(3));
tinsert(templates.class.MONK[3][resourceSection].args, createSimplePowerTemplate(12));

templates.class.MONK[1][9] = {
  title = L["Ability Charges"],
  args = {
    { spell = 115072, type = "ability", charges = true}, -- Expel Harm
  },
  icon = "Interface\\Icons\\Ability_monk_expelharm"
};

templates.class.MONK[2][9] = {
  title = L["Ability Charges"],
  args = {
  },
  icon = "Interface\\Icons\\ability_monk_soothingmists"
};

templates.class.MONK[3][9] = {
  title = L["Ability Charges"],
  args = {
  },
  icon = "Interface\\Icons\\Ability_monk_cranekick_new"
};

-- Druid
for i = 1, 4 do
  -- Shapeshift Form
  tinsert(templates.class.DRUID[i][resourceSection].args, {
    title = L["Shapeshift Form"],
    icon = "Interface\\Icons\\Ability_racial_bearform",
    triggers = {[1] = { trigger = {
      type = WeakAuras.GetTriggerCategoryFor("Stance/Form/Aura"),
      event = "Stance/Form/Aura"}}}
  });
end

for j, id in ipairs({5487, 768, 783, 1066, 24858, 40120}) do
  local title, _, icon = GetSpellInfo(id)
  if title then
    for i = 1, 4 do
      tinsert(templates.class.DRUID[i][resourceSection].args, {
        title = title,
        icon = icon,
        triggers = {
          [1] = {
            trigger = {
              type = WeakAuras.GetTriggerCategoryFor("Stance/Form/Aura"),
              event = "Stance/Form/Aura",
              use_form = true,
              form = { single = j }
            }
          }
        }
      });
    end
  end
end

-- Astral Power
tinsert(templates.class.DRUID[1][resourceSection].args, createSimplePowerTemplate(8));

for i = 1, 4 do
  tinsert(templates.class.DRUID[i][resourceSection].args, createSimplePowerTemplate(0)); -- Mana
  tinsert(templates.class.DRUID[i][resourceSection].args, createSimplePowerTemplate(1)); -- Rage
  tinsert(templates.class.DRUID[i][resourceSection].args, createSimplePowerTemplate(3)); -- Energy
  tinsert(templates.class.DRUID[i][resourceSection].args, createSimplePowerTemplate(4)); -- Combo Points
end

-- Efflorescence aka Mushroom
tinsert(templates.class.DRUID[4][3].args,  {spell = 145205, type = "totem"});

-- Death Knight
for i = 1, 3 do
  tinsert(templates.class.DEATHKNIGHT[i][resourceSection].args, createSimplePowerTemplate(6));

  tinsert(templates.class.DEATHKNIGHT[i][resourceSection].args, {
    title = L["Runes"],
    icon = "Interface\\Icons\\spell_deathknight_frozenruneweapon",
    triggers = {[1] = { trigger = { type = "status", event = "Death Knight Rune", unevent = "auto"}}}
  });
end


------------------------------
-- Hardcoded race templates
-------------------------------

-- Every Man for Himself
tinsert(templates.race.Human, { spell = 59752, type = "ability" });
-- Stoneform
tinsert(templates.race.Dwarf, { spell = 20594, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Dwarf, { spell = 65116, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- Shadow Meld
tinsert(templates.race.NightElf, { spell = 58984, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.NightElf, { spell = 58984, type = "buff", titleSuffix = L["buff"]});
-- Escape Artist
tinsert(templates.race.Gnome, { spell = 20589, type = "ability" });
-- Gift of the Naaru
tinsert(templates.race.Draenei, { spell = 28880, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Draenei, { spell = 28880, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- Dark Flight
tinsert(templates.race.Worgen, { spell = 68992, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Worgen, { spell = 68992, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- Quaking Palm
tinsert(templates.race.Pandaren, { spell = 107079, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Pandaren, { spell = 107079, type = "buff", titleSuffix = L["buff"]});
-- Blood Fury
tinsert(templates.race.Orc, { spell = 20572, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Orc, { spell = 20572, type = "buff", unit = "player", titleSuffix = L["buff"]});
--Cannibalize
tinsert(templates.race.Scourge, { spell = 20577, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Scourge, { spell = 20578, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- War Stomp
tinsert(templates.race.Tauren, { spell = 20549, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Tauren, { spell = 20549, type = "buff", titleSuffix = L["buff"]});
--Beserking
tinsert(templates.race.Troll, { spell = 26297, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Troll, { spell = 26297, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- Arcane Torment
tinsert(templates.race.BloodElf, { spell = 69179, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.BloodElf, { spell = 69179, type = "buff", titleSuffix = L["buff"]});
-- Pack Hobgoblin
tinsert(templates.race.Goblin, { spell = 69046, type = "ability" });
-- Rocket Barrage
tinsert(templates.race.Goblin, { spell = 69041, type = "ability" });


------------------------------
-- Helper code for options
-------------------------------

-- Enrich items from spell, set title
local function handleItem(item)
  local waitingForItemInfo = false;
  if type(item) == "number" then
    print(item)
  end
  if (item.spell) then
    local name, icon, _;
    if (item.type == "item") then
      name, _, _, _, _, _, _, _, _, icon = GetItemInfo(item.spell);
      if (name == nil) then
        name = L["Unknown Item"] .. " " .. tostring(item.spell);
        waitingForItemInfo = true;
      end
    else
      name, _, icon = GetSpellInfo(item.spell);
      if (name == nil) then
        name = L["Unknown Spell"] .. " " .. tostring(item.spell);
      end
    end
    if (icon and not item.icon) then
      item.icon = icon;
    end

    item.title = item.overideTitle or name or "";
    if (item.titleSuffix) then
      item.title = item.title .. " " .. item.titleSuffix;
    end
    if (item.titlePrefix) then
      item.title = item.titlePrefix .. item.title;
    end
    if (item.titleItemPrefix) then
      local prefix = GetItemInfo(item.titleItemPrefix);
      if (prefix) then
        item.title = prefix .. "-" .. item.title;
      else
        waitingForItemInfo = true;
      end
    end
    if (item.type ~= "item") then
      -- local spell = Spell:CreateFromSpellID(item.spell);
      -- if (not spell:IsSpellEmpty()) then
      --   spell:ContinueOnSpellLoad(function()
      --     item.description = GetSpellDescription(spell:GetSpellID());
      --   end);
      -- end
      item.description = GetSpellDescription(item.spell);
    end
  end
  if (item.talent) then
    item.load = item.load or {};
    if type(item.talent) == "table" then
      item.load.talent = { multi = {} };
      for _,v in pairs(item.talent) do
        item.load.talent.multi[v] = true;
      end
      item.load.use_talent = false;
    else
      item.load.talent = {
        single = item.talent;
        multi = {};
      };
      item.load.use_talent = true;
    end
  end
  if (item.pvptalent) then
    item.load = item.load or {};
    item.load.use_pvptalent = true;
    item.load.pvptalent = {
      single = item.pvptalent;
      multi = {};
    }
  end
  -- form field is lazy handled by a usable condition
  if item.form then
    item.usable = true
  end
  return waitingForItemInfo;
end

local function addLoadCondition(item, loadCondition)
  -- No need to deep copy here, templates are read-only
  item.load = item.load or {};
  for k, v in pairs(loadCondition) do
    item.load[k] = v;
  end
end

local delayedEnrichDatabase = false;
local itemInfoReceived = CreateFrame("frame")

local enrichTries = 0;
local function enrichDatabase()
  if (enrichTries > 3) then
    return;
  end
  enrichTries = enrichTries + 1;

  local waitingForItemInfo = false;
  for className, class in pairs(templates.class) do
    for specIndex, spec in pairs(class) do
      for _, section in pairs(spec) do
        local loadCondition = {
          use_class = true, class = { single = className, multi = {} },
          use_spec = true, spec = { single = specIndex, multi = {}}
        };
        if WeakAuras.IsClassic() then
          loadCondition.use_spec = nil
          loadCondition.spec = nil
        end
        for itemIndex, item in pairs(section.args or {}) do
          local handle = handleItem(item)
          if(handle) then
            waitingForItemInfo = true;
          end
          addLoadCondition(item, loadCondition);
        end
      end
    end
  end

  for raceName, race in pairs(templates.race) do
    local loadCondition = {
      use_race = true, race = { single = raceName, multi = {} }
    };
    for _, item in pairs(race) do
      local handle = handleItem(item)
      if handle then
        waitingForItemInfo = true;
      end
      if handle ~= nil then
        addLoadCondition(item, loadCondition);
      end
    end
  end

  for _, item in pairs(templates.general.args) do
    if (handleItem(item)) then
      waitingForItemInfo = true;
    end
  end

  for _, section in pairs(templates.items) do
    for _, item in pairs(section.args) do
      if (handleItem(item)) then
        waitingForItemInfo = true;
      end
    end
  end

  if (waitingForItemInfo) then
    itemInfoReceived:RegisterEvent("GET_ITEM_INFO_RECEIVED");
  else
    itemInfoReceived:UnregisterEvent("GET_ITEM_INFO_RECEIVED");
  end
end

if not WeakAuras.IsClassic() then
  local function fixupIcons()
    for className, class in pairs(templates.class) do
      for specIndex, spec in pairs(class) do
        for _, section in pairs(spec) do
          if section.args then
            for _, item in pairs(section.args) do
              if (item.spell and (not item.type ~= "item")) then
                local icon = select(3, GetSpellInfo(item.spell));
                if (icon) then
                  item.icon = icon;
                end
              end
            end
          end
        end
      end
    end
  end

  local fixupIconsFrame = CreateFrame("frame");
  fixupIconsFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
  fixupIconsFrame:SetScript("OnEvent", fixupIcons);
end

enrichDatabase();

itemInfoReceived:SetScript("OnEvent", function()
  if (not delayedEnrichDatabase) then
    delayedEnrichDatabase = true;
    -- C_Timer.After(2, function()
      enrichDatabase();
      delayedEnrichDatabase = false;
    -- end)
  end
end);


-- Enrich Display templates with default values
for regionType, regionData in pairs(WeakAuras.regionOptions) do
  if (regionData.templates) then
    for _, item in ipairs(regionData.templates) do
      for k, v in pairs(WeakAuras.regionTypes[regionType].default) do
        if (item.data[k] == nil) then
          item.data[k] = v;
        end
      end
    end
  end
end

WeakAuras.triggerTemplates = templates;
