-- Part of ReforgeLite by d07.RiV (Iroared)
-- All rights reserved

local L = ReforgeLiteLocale

----------------------------------------- CAP PRESETS ---------------------------------

function ReforgeLite:RatingPerPoint (stat, level)
  level = level or UnitLevel ("player")
  local factor
  if level <= 34 and (stat == self.STATS.DODGE or stat == self.STATS.PARRY) then
    factor = 0.5
  elseif level <= 10 then
    factor = 1 / 26
  elseif level <= 60 then
    factor = (level - 8) / 52
  elseif level <= 70 then
    factor = 82 / (262 - 3 * level)
  elseif level <= 80 then
    factor = (82 / 52) * math.pow (131 / 63, (level - 70) / 10)
  else
    factor = (82 / 52) * (131 / 63)
    if level == 81 then
      factor = factor * 1.31309
    elseif level == 82 then
      factor = factor * 1.72430
    elseif level == 83 then
      factor = factor * 2.26519
    elseif level == 84 then
      factor = factor * 2.97430
    elseif level == 85 then
      factor = factor * 3.90537
    end
  end
  if stat == self.STATS.DODGE or stat == self.STATS.PARRY then
    return factor * 13.8
  elseif stat == self.STATS.HIT then
    return factor * 9.37931
  elseif stat == self.STATS.SPELLHIT then
    return factor * 8
  elseif stat == self.STATS.HASTE then
    return factor * 10
  elseif stat == self.STATS.CRIT then
    return factor * 14
  elseif stat == self.STATS.EXP then
    return factor * 2.34483
  elseif stat == self.STATS.MASTERY then
    return factor * 14
  end
  return 0
end
function ReforgeLite:GetMeleeHitBonus ()
  return GetHitModifier () or 0
end
function ReforgeLite:GetSpellHitBonus ()
  return GetSpellHitModifier () or 0
end
function ReforgeLite:GetExpertiseBonus ()
  return GetExpertise () - math.floor (GetCombatRatingBonus (CR_EXPERTISE))
end
function ReforgeLite:GetNeededMeleeHit ()
  local diff = self.pdb.targetLevel
  if diff <= 2 then
    return math.max (0, 5 + 0.5 * diff)
  else
    return 2 + 2 * diff
  end
end
function ReforgeLite:GetNeededSpellHit ()
  local diff = self.pdb.targetLevel
  if diff <= 2 then
    return math.max (0, 4 + diff)
  else
    return 11 * diff - 16
  end
end
function ReforgeLite:GetNeededExpertiseSoft ()
  local diff = self.pdb.targetLevel
  return math.ceil (math.max (0, 5 + 0.5 * diff) / 0.25)
end
function ReforgeLite:GetNeededExpertiseHard ()
  local diff = self.pdb.targetLevel
  if diff <= 2 then
    return math.ceil (math.max (0, 5 + 0.5 * diff) / 0.25)
  else
    return math.ceil (14 / 0.25)
  end
end

ReforgeLite.capPresets = {
  {
    value = 1,
    name = L["Manual"],
    getter = nil
  },
  {
    value = 2,
    name = L["Melee hit cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.HIT) * (ReforgeLite:GetNeededMeleeHit () - ReforgeLite:GetMeleeHitBonus ())
    end
  },
  {
    value = 3,
    name = L["Spell hit cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.SPELLHIT) * (ReforgeLite:GetNeededSpellHit () - ReforgeLite:GetSpellHitBonus ())
    end
  },
  {
    value = 4,
    name = L["Melee DW hit cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.HIT) * (ReforgeLite:GetNeededMeleeHit () + 19 - ReforgeLite:GetMeleeHitBonus ())
    end
  },
  {
    value = 5,
    name = L["Expertise soft cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.EXP) * (ReforgeLite:GetNeededExpertiseSoft () - ReforgeLite:GetExpertiseBonus ())
    end
  },
  {
    value = 6,
    name = L["Expertise hard cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.EXP) * (ReforgeLite:GetNeededExpertiseHard () - ReforgeLite:GetExpertiseBonus ())
    end
  },
}

----------------------------------------- WEIGHT PRESETS ------------------------------

local StatSpirit = 1
local StatDodge = 2
local StatParry = 3
local StatHit = 4
local StatCrit = 5
local StatHaste = 6
local StatExp = 7
local StatMastery = 8
local MeleeHitCap = 2
local SpellHitCap = 3
local MeleeDWHitCap = 4
local ExpSoftCap = 5
local ExpHardCap = 6
local AtLeast = 1
local AtMost = 2

local MeleeCaps = {
  {
    stat = StatHit,
    points = {
      {
        method = AtLeast,
        preset = MeleeHitCap
      }
    }
  },
  {
    stat = StatExp,
    points = {
      {
        method = AtLeast,
        preset = ExpSoftCap
      }
    }
  }
}
local RangedCaps = {
  {
    stat = StatHit,
    points = {
      {
        method = AtLeast,
        preset = MeleeHitCap
      }
    }
  }
}
local CasterCaps = {
  {
    stat = StatHit,
    points = {
      {
        method = AtLeast,
        preset = SpellHitCap
      }
    }
  }
}

ReforgeLite.presets = {
  ["DEATHKNIGHT"] = {
    ["Blood"] = {
      tanking = true,
      weights = {
        0, 100 * 200, 100 * 200, 20, 0, 0, 40, 150
      },
    },
    ["Frost"] = {
      ["2H Weapon"] = {
        weights = {
          0, 0, 0, 201, 115, 129, 163, 126
        },
        caps = MeleeCaps,
      },
      ["Dual Wielding"] = {
        weights = {
          0, 0, 0, 229, 116, 147, 164, 144
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = MeleeHitCap,
                after = 106,
              },
              {
                preset = MeleeDWHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                method = AtLeast,
                preset = ExpSoftCap,
              },
            },
          },
        },
      },
    },
    ["Unholy"] = {
      weights = {
        0, 0, 0, 200, 110, 160, 130, 150
      },
      caps = MeleeCaps,
    },
  },
  ["DRUID"] = {
    ["Balance"] = {
      weights = {
        0, 0, 0, 200, 100, 150, 0, 130
      },
      caps = CasterCaps,
    },
    ["Feral Combat"] = {
      ["Bear"] = {
        weights = {
          0, 150, 0, 40, 60, 10, 60, 90
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                preset = MeleeHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                preset = ExpSoftCap,
                after = 30,
              },
              {
                preset = ExpHardCap,
              },
            },
          },
        },
      },
      ["Cat"] = {
        weights = {
          0, 0, 0, 115, 110, 110, 115, 110
        },
        tip = "All stats are nearly equal for cats, don't rely on this too much",
        caps = {
          {
            stat = StatHit,
            points = {
              {
                preset = MeleeHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                preset = ExpSoftCap,
              },
            },
          },
        },
      },
    },
    ["Restoration"] = {
      weights = {
        150, 0, 0, 0, 130, 160, 0, 140
      },
      tip = "Feel free to change the value of spirit if needed",
      caps = {
        {
          stat = StatHaste,
          points = {
            {
              preset = 1,
              value = 2005,
              after = 135,
            },
          },
        },
      },
    },
  },
  ["HUNTER"] = {
    ["Beast Mastery"] = {
      weights = {
        0, 0, 0, 200, 150, 100, 0, 100
      },
      caps = RangedCaps,
    },
    ["Marksmanship (Arcane Shot)"] = {
      weights = {
        0, 0, 0, 200, 150, 140, 0, 110
      },
      caps = RangedCaps,
    },
    ["Marksmanship (Aimed Shot)"] = {
      weights = {
        0, 0, 0, 200, 140, 150, 0, 110
      },
      caps = RangedCaps,
    },
    ["Survival"] = {
      weights = {
        0, 0, 0, 200, 140, 130, 0, 120
      },
      caps = RangedCaps,
    },
  },
  ["MAGE"] = {
    ["Arcane"] = {
      weights = {
        0, 0, 0, 200, 130, 150, 0, 140
      },
      caps = {
        {
          stat = StatHit,
          points = {
            {
              method = AtLeast,
              preset = SpellHitCap,
            },
          },
        },
        {
          stat = StatHaste,
          points = {
            {
              preset = 1,
              value = 1767,
              after = 120,
            },
          },
        },
      },
    },
    ["Fire"] = {
      weights = {
        0, 0, 0, 200, 150, 145, 0, 120
      },
      caps = CasterCaps,
    },
    ["Frost"] = {
      weights = {
        0, 0, 0, 200, 180, 140, 0, 130
      },
      caps = CasterCaps,
    },
  },
  ["PALADIN"] = {
    ["Holy"] = {
      weights = {
        150, 0, 0, 0, 100, 120, 0, 110
      },
    },
    ["Protection"] = {
      tanking = true,
      weights = {
        0, 100, 100, 0, 0, 0, 0, 80
      },
    },
    ["Retribution"] = {
      weights = {
        0, 0, 0, 200, 135, 110, 180, 150
      },
      caps = MeleeCaps,
    },
  },
  ["PRIEST"] = {
    ["Discipline"] = {
      weights = {
        150, 0, 0, 0, 80, 100, 0, 120
      },
    },
    ["Holy"] = {
      weights = {
        150, 0, 0, 0, 80, 120, 0, 100
      },
    },
    ["Shadow"] = {
      weights = {
        0, 0, 0, 200, 100, 140, 0, 130
      },
      caps = CasterCaps
    },
  },
  ["ROGUE"] = {
    ["Tier 12"] = {
      ["Assassination"] = {
        weights = {
          0, 0, 0, 200, 120, 130, 120, 140
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = MeleeHitCap,
                after = 160,
              },
              {
                preset = SpellHitCap,
                after = 82,
              },
              {
                preset = MeleeDWHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                preset = ExpSoftCap,
              },
            },
          },
        },
      },
      ["Combat"] = {
        weights = {
          0, 0, 0, 215, 125, 170, 185, 150
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = MeleeHitCap,
                after = 150,
              },
              {
                preset = SpellHitCap,
                after = 120,
              },
              {
                preset = MeleeDWHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                method = AtLeast,
                preset = ExpSoftCap,
              },
            },
          },
        },
      },
      ["Subtlety"] = {
        weights = {
          0, 0, 0, 155, 145, 155, 130, 90
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = MeleeHitCap,
                after = 110,
              },
              {
                preset = SpellHitCap,
                after = 80,
              },
              {
                preset = MeleeDWHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                preset = ExpSoftCap,
              },
            },
          },
        },
      },
    },
    ["Tier 13"] = {
      ["Assassination"] = {
        weights = {
          0, 0, 0, 225, 120, 140, 140, 160
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = MeleeHitCap,
                after = 170,
              },
              {
                preset = SpellHitCap,
                after = 90,
              },
              {
                preset = MeleeDWHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                preset = ExpSoftCap,
              },
            },
          },
        },
      },
      ["Combat"] = {
        weights = {
          0, 0, 0, 240, 120, 190, 210, 150
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = MeleeHitCap,
                after = 170,
              },
              {
                preset = SpellHitCap,
                after = 135,
              },
              {
                preset = MeleeDWHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                method = AtLeast,
                preset = ExpSoftCap,
              },
            },
          },
        },
      },
      ["Subtlety"] = {
        weights = {
          0, 0, 0, 180, 150, 175, 155, 95
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = MeleeHitCap,
                after = 115,
              },
              {
                preset = SpellHitCap,
                after = 90,
              },
              {
                preset = MeleeDWHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                preset = ExpSoftCap,
              },
            },
          },
        },
      },
    },
  },
  ["SHAMAN"] = {
    ["Elemental"] = {
      weights = {
        0, 0, 0, 200, 80, 140, 0, 120
      },
      caps = CasterCaps,
    },
    ["Enhancement"] = {
      weights = {
        0, 0, 0, 250, 120, 80, 190, 150
      },
      caps = {
        {
          stat = StatHit,
          points = {
            {
              method = AtLeast,
              preset = MeleeHitCap,
              after = 200,
            },
            {
              method = AtLeast,
              preset = SpellHitCap,
              after = 100,
            },
            {
              preset = MeleeDWHitCap,
            },
          },
        },
        {
          stat = StatExp,
          points = {
            {
              method = AtLeast,
              preset = ExpSoftCap,
            },
          },
        },
      },
    },
    ["Restoration"] = {
      weights = {
        130, 0, 0, 0, 100, 100, 0, 100
      },
    },
  },
  ["WARLOCK"] = {
    ["Affliction"] = {
      weights = {
        0, 0, 0, 200, 140, 160, 0, 120
      },
      caps = CasterCaps,
    },
    ["Demonology"] = {
      weights = {
        0, 0, 0, 200, 120, 140, 0, 160
      },
      caps = CasterCaps,
    },
    ["Destruction"] = {
      weights = {
        0, 0, 0, 200, 140, 160, 0, 120
      },
      caps = CasterCaps,
    },
  },
  ["WARRIOR"] = {
    ["Arms"] = {
      weights = {
        0, 0, 0, 200, 150, 100, 130, 120
      },
      caps = {
        {
          stat = StatHit,
          points = {
            {
              method = AtLeast,
              preset = MeleeHitCap,
            },
          },
        },
        {
          stat = StatExp,
          points = {
            {
              preset = ExpSoftCap,
            },
          },
        },
      },
    },
    ["Fury"] = {
      ["Titan's Grip"] = {
        weights = {
          0, 0, 0, 200, 150, 100, 180, 130
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = MeleeHitCap,
                after = 140,
              },
              {
                value = 1300,
                preset = 1,
                after = 125
              },
              {
                preset = MeleeDWHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                method = AtLeast,
                preset = ExpSoftCap,
              },
            },
          },
        },
      },
      ["Single-Minded Fury"] = {
        weights = {
          0, 0, 0, 200, 150, 100, 180, 130
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = MeleeHitCap,
                after = 140,
              },
              {
                value = 1300,
                preset = 1,
                after = 125
              },
              {
                preset = MeleeDWHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                method = AtLeast,
                preset = ExpSoftCap,
              },
            },
          },
        },
      },
    },
    ["Protection"] = {
      tanking = true,
      weights = {
        40, 100, 100, 0, 0, 0, 0, 40
      },
    },
  },
--  ["PvP (Arena)"] = {
--  },
}

function ReforgeLite:InitPresets ()
  self.presets["Custom"] = self.db.customPresets
  
  if PawnVersion then
    local PawnMap = {
      Spirit = true,
      DodgeRating = true,
      ParryRating
    }
    self.presets["Pawn scales"] = function ()
      if PawnCommon == nil or PawnCommon.Scales == nil then return {} end
      local result = {}
      for k, v in pairs (PawnCommon.Scales) do
        local preset = {leaf = "import"}
        preset.weights = {}
        local raw = v.Values or {}
        preset.weights[self.STATS.SPIRIT] = raw["Spirit"] or 0
        preset.weights[self.STATS.DODGE] = raw["DodgeRating"] or 0
        preset.weights[self.STATS.PARRY] = raw["ParryRating"] or 0
        preset.weights[self.STATS.HIT] = raw["HitRating"] or 0
        preset.weights[self.STATS.CRIT] = raw["CritRating"] or 0
        preset.weights[self.STATS.HASTE] = raw["HasteRating"] or 0
        preset.weights[self.STATS.EXP] = raw["ExpertiseRating"] or 0
        preset.weights[self.STATS.MASTERY] = raw["MasteryRating"] or 0
        local total = 0
        local average = 0
        for i = 1, #self.itemStats do
          if preset.weights[i] ~= 0 then
            total = total + 1
            average = average + preset.weights[i]
          end
        end
        if total > 0 and average > 0 then
          local factor = 1
          while factor * average / total < 10 do
            factor = factor * 100
          end
          while factor * average / total > 1000 do
            factor = factor / 10
          end
          for i = 1, #self.itemStats do
            preset.weights[i] = preset.weights[i] * factor
          end
          result[v.LocalizedName or k] = preset
        end
      end
      return result
    end
  end

  self.presetMenu = CreateFrame ("Frame", "ReforgeLitePresetMenu")
  self.presetMenu.info = {}
  self.presetMenu.initialize = function (menu, level)
    if not level then return end
    local info = menu.info
    wipe (info)
    local list = self.presets
    if level > 1 then
      list = UIDROPDOWNMENU_MENU_VALUE
    end
    info.notCheckable = true

    for k, v in pairs (list) do
      if type (v) == "function" then
        v = v ()
      end
      info.text = ((list == self.db.customPresets or v.leaf == "import") and k or L[k])
      info.value = v
      if v.caps or v.weights or v.leaf then
        info.func = function ()
          CloseDropDownMenus ()
          if v.leaf == "import" then
            self:SetStatWeights (v.weights, v.caps)
          else
            self:SetStatWeights (v.weights, v.caps or {})
          end
          self:SetTankingModel (v.tanking)
        end
        info.hasArrow = nil
        info.keepShownOnClick = nil
      else
        info.func = nil
        if next (v) then
          info.hasArrow = true
        else
          info.hasArrow = nil
        end
        info.keepShownOnClick = true
      end
      UIDropDownMenu_AddButton (info, level)
    end
  end

  self.presetDelMenu = CreateFrame ("Frame", "ReforgeLitePresetDelMenu")
  self.presetDelMenu.info = {}
  self.presetDelMenu.initialize = function (menu, level)
    if level ~= 1 then return end
    local info = menu.info
    wipe (info)
    info.notCheckable = true
    for k, v in pairs (self.db.customPresets) do
      info.text = k
      info.func = function ()
        self.db.customPresets[k] = nil
        if next (self.db.customPresets) == nil then
          self.deletePresetButton:Disable ()
        end
      end
      UIDropDownMenu_AddButton (info, level)
    end
  end
end
