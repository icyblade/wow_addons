-- Part of ReforgeLite by d07.RiV (Iroared)
-- All rights reserved

local REFORGE_COEFF = 0.4
local REFORGE_CHEAT = 5

local _, playerClass = UnitClass ("player")
local _, playerRace = UnitRace ("player")
local missChance = (playerRace == "NIGHTELF" and 7 or 5)

local function DeepCopy (t, cache)
  if type (t) ~= "table" then
    return t
  end
  local copy = {}
  for i, v in pairs (t) do
    if type (v) ~= "table" then
      copy[i] = v
    else
      cache = cache or {}
      cache[t] = copy
      if cache[v] then
        copy[i] = cache[v]
      else
        copy[i] = DeepCopy (v, cache)
      end
    end
  end
  return copy
end

local L = ReforgeLiteLocale

---------------------------------------------------------------------------------------

function PlayerHasBuff (id)
  local i = 1
  while true do
    local spell = select (11, UnitAura ("player", i))
    if spell == nil then
      return false
    elseif spell == id then
      return true
    end
    i = i + 1
  end
end
function GetPlayerBuffs ()
  local kings = nil
  local strength = nil
  local flask = nil
  local food = nil
  local i = 1
  while true do
    local id = select (11, UnitAura ("player", i))
    if id == nil then
      return kings, strength, flask, food
    else
      if id == 79063 or id == 79061 or id == 90363 then
        kings = true
      elseif id == 57330 or id == 93435 or id == 8076 or id == 6673 then
        strength = true
      elseif id == 87554 then -- 90 dodge food
        food = 2
      elseif id == 87555 then -- 90 parry food
        food = 3
      elseif id == 87549 then -- 90 mastery food
        food = 1
      elseif id == 87545 then -- 90 strength food
        food = 4
      elseif id == 79472 then -- 300 strength flask
        flask = 1
      elseif id == 79635 then -- 225 mastery elixir
        flask = 2
      end
    end
    i = i + 1
  end
end
function AlchemyCanCraft (id)
  local prof1, prof2 = GetProfessions ()
  if prof2 and select (7, GetProfessionInfo (prof2)) == 171 then
    prof1 = prof2
  end
  if prof1 and select (7, GetProfessionInfo (prof1)) == 171 then
    return true
  end
  return false
end
function ReforgeLite:DiminishStat (rating, stat)
  return rating > 0 and 1 / (0.0152366 + 0.956 / (rating / self:RatingPerPoint (stat))) or 0
end
function ReforgeLite:GetMethodScore (method)
  local score = 0
  if method.tankingModel then
    score = method.stats.dodge * self.pdb.weights[self.STATS.DODGE] + method.stats.parry * self.pdb.weights[self.STATS.PARRY]
    if playerClass == "WARRIOR" then
      score = score + method.stats.block * self.pdb.weights[self.STATS.MASTERY] + method.stats.critBlock * self.pdb.weights[self.STATS.CRITBLOCK]
    elseif playerClass == "PALADIN" then
      score = score + method.stats.block * self.pdb.weights[self.STATS.MASTERY]
    else
      for i = 1, #self.itemStats do
        if i ~= self.STATS.DODGE and i ~= self.STATS.PARRY then
          score = score + method.stats[i] * self.pdb.weights[i]
        end
      end
    end
  else
    for i = 1, #self.itemStats do
      score = score + self:GetStatScore (i, method.stats[i])
    end
  end
  return score
end

local itemBonuses = {
         --   str  dod  par  mas
  [58180] = { 380,   0,   0,   0 }, -- License to Slay
  [68982] = {   0,   0,   0, 390 }, -- Necromantic Focus, lol
  [69139] = {   0,   0,   0, 440 }, -- Necromantic Focus H
  [77978] = {   0, 780,   0,   0 }, -- Resolve of Undying LFR
  [77201] = {   0, 880,   0,   0 }, -- Resolve of Undying
  [77998] = {   0, 990,   0,   0 }, -- Resolve of Undying H
  [77977] = { 780,   0,   0,   0 }, -- Eye of Unmaking LFR
  [77200] = { 880,   0,   0,   0 }, -- Eye of Unmaking
  [77997] = { 990,   0,   0,   0 }, -- Eye of Unmaking H
}

function ReforgeLite:GetBuffBonuses ()
  local cur_buffs = {GetPlayerBuffs ()}
  local cur_strength = UnitStat ("player", 1)
  local strength = cur_strength
  local extra_strength = 0
  local dodge_bonus = 0
  local parry_bonus = math.floor ((strength - cur_strength) * 0.27)
  local mastery_bonus = 0
  for i = 1, #self.itemData do
    local bonus = itemBonuses[GetInventoryItemID ("player", self.itemData[i].slotId)]
    if bonus then
      extra_strength = extra_strength + bonus[1]
      dodge_bonus = dodge_bonus + bonus[2]
      parry_bonus = parry_bonus + bonus[3]
      mastery_bonus = mastery_bonus + bonus[4]
    end
  end
  if self.pdb.buffs.strength and not cur_buffs[2] then
    extra_strength = extra_strength + 549
  end
  if self.pdb.buffs.flask == 1 and cur_buffs[3] ~= 1 then
    extra_strength = extra_strength + 300
    if AlchemyCanCraft () then
      extra_strength = extra_strength + 80
    end
  end
  if self.pdb.buffs.food == 4 and cur_buffs[4] ~= 4 then
    extra_strength = extra_strength + 90
  end
  if cur_buffs[1] then
    extra_strength = extra_strength * 1.05
  end
  strength = strength + extra_strength
  if self.pdb.buffs.kings and not cur_buffs[1] then
    strength = strength * 1.05
  end
  strength = math.floor (strength)
  parry_bonus = parry_bonus + math.floor ((strength - cur_strength) * 0.27)
  if self.pdb.buffs.flask == 2 and cur_buffs[3] ~= 2 then
    mastery_bonus = mastery_bonus + 225
    if AlchemyCanCraft () then
      mastery_bonus = mastery_bonus + 40
    end
  end
  if self.pdb.buffs.food == 1 and cur_buffs[4] ~= 1 then
    mastery_bonus = mastery_bonus + 90
  end
  if self.pdb.buffs.food == 2 and cur_buffs[4] ~= 2 then
    dodge_bonus = dodge_bonus + 90
  end
  if self.pdb.buffs.food == 3 and cur_buffs[4] ~= 3 then
    parry_bonus = parry_bonus + 90
  end
  return dodge_bonus, parry_bonus, mastery_bonus
end
function ReforgeLite:UpdateMethodStats (method)
  method.stats = {}
  for i = 1, #self.itemStats do
    method.stats[i] = self.itemStats[i].getter ()
  end
  local oldspi = method.stats[self.STATS.SPIRIT]
  method.stats[self.STATS.SPIRIT] = method.stats[self.STATS.SPIRIT] / self.spiritBonus
  for i = 1, #method.items do
    local item = GetInventoryItemLink ("player", self.itemData[i].slotId)
    local stats = (item and GetItemStats (item) or {})
    local reforge = (item and self:GetReforgeID (item))
    if reforge then
      local src, dst = self.reforgeTable[reforge][1], self.reforgeTable[reforge][2]
      local amount = math.floor ((stats[self.itemStats[src].name] or 0) * REFORGE_COEFF)
      method.stats[src] = method.stats[src] + amount
      method.stats[dst] = method.stats[dst] - amount
    end
    if method.items[i].src and method.items[i].dst then
      method.items[i].amount = math.floor ((stats[self.itemStats[method.items[i].src].name] or 0) * REFORGE_COEFF)
      method.stats[method.items[i].src] = method.stats[method.items[i].src] - method.items[i].amount
      method.stats[method.items[i].dst] = method.stats[method.items[i].dst] + method.items[i].amount
    end
  end
  method.stats[self.STATS.SPIRIT] = math.floor (method.stats[self.STATS.SPIRIT] * self.spiritBonus + 0.5)
  if self.s2hFactor and self.s2hFactor > 0 then
    method.stats[self.STATS.HIT] = method.stats[self.STATS.HIT] +
      math.floor ((method.stats[self.STATS.SPIRIT] - oldspi) * self.s2hFactor / 100 + 0.5)
  end
  if method.tankingModel then
    local dodge_bonus, parry_bonus, mastery_bonus = self:GetBuffBonuses ()
    method.orig_stats = {}
    method.orig_stats[self.STATS.DODGE] = method.stats[self.STATS.DODGE]
    method.orig_stats[self.STATS.PARRY] = method.stats[self.STATS.PARRY]
    method.orig_stats[self.STATS.MASTERY] = method.stats[self.STATS.MASTERY]
    method.stats[self.STATS.DODGE] = method.stats[self.STATS.DODGE] + dodge_bonus
    method.stats[self.STATS.PARRY] = method.stats[self.STATS.PARRY] + parry_bonus
    method.stats[self.STATS.MASTERY] = method.stats[self.STATS.MASTERY] + mastery_bonus
    method.stats.dodge = GetDodgeChance () - self:DiminishStat (GetCombatRating (CR_DODGE), self.STATS.DODGE)
    method.stats.parry = GetParryChance () - self:DiminishStat (GetCombatRating (CR_PARRY), self.STATS.PARRY)
    method.stats.dodge = method.stats.dodge + self:DiminishStat (method.stats[self.STATS.DODGE], self.STATS.DODGE)
    method.stats.parry = method.stats.parry + self:DiminishStat (method.stats[self.STATS.PARRY], self.STATS.PARRY)
    if playerClass == "WARRIOR" then
      method.stats.critBlock = (8 + method.stats[self.STATS.MASTERY] / self:RatingPerPoint (self.STATS.MASTERY)) * 1.5
      method.stats.block = 20 + method.stats.critBlock
    elseif playerClass == "PALADIN" then
      method.stats.block = 5 + (8 + method.stats[self.STATS.MASTERY] / self:RatingPerPoint (self.STATS.MASTERY)) * 2.25
    end
    local unhit = 100 + 0.8 * max (0, self.pdb.targetLevel)
    method.stats.overcap = nil
    if method.stats.block and missChance + method.stats.dodge + method.stats.parry + method.stats.block > unhit then
      method.stats.overcap = missChance + method.stats.dodge + method.stats.parry + method.stats.block - unhit
      method.stats.block = unhit - missChance - method.stats.dodge - method.stats.parry
    end
  end
end
function ReforgeLite:FinalizeReforge (data)
  local method = data.method
  for i = 1, #method.items do
    method.items[i].reforge = nil
    if method.items[i].src and method.items[i].dst then
      local amount = math.floor (method.items[i].stats[method.items[i].src] * REFORGE_COEFF)
      for j = 1, #self.reforgeTable do
        if self.reforgeTable[j][1] == method.items[i].src and self.reforgeTable[j][2] == method.items[i].dst then
          method.items[i].reforge = j
          break
        end
      end
    end
    method.items[i].stats = nil
  end
  self:UpdateMethodStats (method)
end
function ReforgeLite:ResetMethod ()
  local method = {}
  method.items = {}
  for i = 1, #self.itemData do
    method.items[i] = {}
    local item = GetInventoryItemLink ("player", self.itemData[i].slotId)
    local stats = (item and GetItemStats (item) or {})
    local reforge = (item and self:GetReforgeID (item))
    if reforge then
      method.items[i].reforge = reforge
      method.items[i].src = self.reforgeTable[reforge][1]
      method.items[i].dst = self.reforgeTable[reforge][2]
    end
  end
  method.tankingModel = self.pdb.tankingModel
  self:UpdateMethodStats (method)
  self.pdb.method = method
  self:UpdateMethodCategory ()
end

function ReforgeLite:CapAllows (cap, value)
  for i = 1, #cap.points do
    if cap.points[i].method == 1 and value < cap.points[i].value then
      return false
    elseif cap.points[i].method == 2 and value > cap.points[i].value then
      return false
    end
  end
  return true
end

function ReforgeLite:IsItemLocked (slot)
  if self.pdb.itemsLocked[slot] then return true end
  local item = GetInventoryItemLink ("player", self.itemData[slot].slotId)
  if not item then return true end
  local ilvl = select (4, GetItemInfo (item))
  return ilvl < 200
end

------------------------------------- CLASSIC REFORGE ------------------------------

function ReforgeLite:MakeReforgeOption (item, data, src, dst)
  local delta1, delta2, dscore = 0, 0, 0
  if src then
    local amount = math.floor (item.stats[src] * REFORGE_COEFF)
    if src == self.STATS.SPIRIT then
      amount = math.floor (amount * self.spiritBonus + math.random ())
    end
    if src == data.caps[1].stat then
      delta1 = delta1 - amount
    elseif src == data.caps[2].stat then
      delta2 = delta2 - amount
    elseif src == self.STATS.SPIRIT then
      dscore = dscore - data.weights[src] * amount
      if self.s2hFactor and self.s2hFactor > 0 then
        if data.caps[1].stat == self.STATS.HIT then
          delta1 = delta1 - math.floor (amount * self.s2hFactor / 100 + math.random ())
        elseif data.caps[2].stat == self.STATS.HIT then
          delta2 = delta2 - math.floor (amount * self.s2hFactor / 100 + math.random ())
        end
      end
    else
      dscore = dscore - data.weights[src] * amount
    end
  end
  if dst then
    local amount = math.floor (item.stats[src] * REFORGE_COEFF)
    if dst == self.STATS.SPIRIT then
      amount = math.floor (amount * self.spiritBonus + math.random ())
    end
    if dst == data.caps[1].stat then
      delta1 = delta1 + amount
    elseif dst == data.caps[2].stat then
      delta2 = delta2 + amount
    elseif dst == self.STATS.SPIRIT then
      dscore = dscore + data.weights[dst] * amount
      if self.s2hFactor and self.s2hFactor > 0 then
        if data.caps[1].stat == self.STATS.HIT then
          delta1 = delta1 + math.floor (amount * self.s2hFactor / 100 + math.random ())
        elseif data.caps[2].stat == self.STATS.HIT then
          delta2 = delta2 + math.floor (amount * self.s2hFactor / 100 + math.random ())
        end
      end
    else
      dscore = dscore + data.weights[dst] * amount
    end
  end
  local opt = {d1 = delta1, d2 = delta2, score = dscore}
  opt["src"] = src
  opt["dst"] = dst
  return opt
end
function ReforgeLite:GetItemReforgeOptions (item, data, slot)
  if self:IsItemLocked (slot) then
    local link = GetInventoryItemLink ("player", self.itemData[slot].slotId)
    local src, dst = nil, nil
    if link then
      local reforge = self:GetReforgeID (link)
      if reforge then
        src = self.reforgeTable[reforge][1]
        dst = self.reforgeTable[reforge][2]
      end
    end
    return { self:MakeReforgeOption (item, data, src, dst) }
  end
  local aopt = {}
  aopt[0] = self:MakeReforgeOption (item, data)
  for src = 1, #self.itemStats do
    if item.stats[src] > 0 then
      for dst = 1, #self.itemStats do
        if item.stats[dst] == 0 then
          local o = self:MakeReforgeOption (item, data, src, dst)
          local pos = o.d1 + o.d2 * 10000
          if not aopt[pos] or aopt[pos].score < o.score then
            aopt[pos] = o
          end
        end
      end
    end
  end
  local opt = {}
  for _, v in pairs (aopt) do
    table.insert (opt, v)
  end
-- good old method
--[[  local opt = {}
  local best = nil
  for i = 1, #self.itemStats do
    if item.stats[i] == 0 and i ~= data.caps[1].stat and i ~= data.caps[2].stat and (best == nil or data.weights[i] > data.weights[best]) then
      best = i
    end
  end
  if best then
    local worst = nil
    local worstScore = 0
    for i = 1, #self.itemStats do
      if item.stats[i] > 0 and i ~= data.caps[1].stat and i ~= data.caps[2].stat then
        local score = (data.weights[best] - data.weights[i]) * math.floor (item.stats[i] * REFORGE_COEFF)
        if score > worstScore then
          worstScore = score
          worst = i
        end
      end
    end
    if worst then
      table.insert (opt, {src = worst, dst = best, d1 = 0, d2 = 0, score = worstScore})
    else
      table.insert (opt, {d1 = 0, d2 = 0, score = 0})
    end
  else
    table.insert (opt, {d1 = 0, d2 = 0, score = 0})
  end
  for s = 1, 2 do
    if data.caps[s].stat > 0 then
      if item.stats[data.caps[s].stat] == 0 then
        for i = 1, #self.itemStats do
          if item.stats[i] > 0 then
            local amount = math.floor (item.stats[i] * REFORGE_COEFF)
            local srcweight = (i == data.caps[3 - s].stat and 0 or data.weights[i])
            table.insert (opt, {src = i, dst = data.caps[s].stat,
              ["d" .. s] = amount, ["d" .. (3 - s)] = (i == data.caps[3 - s].stat and -amount or 0), score = -amount * srcweight})
          end
        end
      end
      if item.stats[data.caps[s].stat] > 0 and best then
        local amount = math.floor (item.stats[data.caps[s].stat] * REFORGE_COEFF)
        table.insert (opt, {src = data.caps[s].stat, dst = best,
          d1 = (s == 1 and -amount or 0), d2 = (s == 2 and -amount or 0), score = data.weights[best] * amount})
      end
    end
  end]]
  return opt
end
function ReforgeLite:InitReforgeClassic ()
  local method = {}
  method.items = {}
  for i = 1, #self.itemData do
    method.items[i] = {}
    method.items[i].stats = {}
    local item = GetInventoryItemLink ("player", self.itemData[i].slotId)
    local stats = (item and GetItemStats (item) or {})
    for j = 1, #self.itemStats do
      method.items[i].stats[j] = (stats[self.itemStats[j].name] or 0)
    end
  end

  REFORGE_CHEAT = self.db.reforgeCheat

  local data = {}
  data.method = method
  data.weights = DeepCopy (self.pdb.weights)
  data.caps = DeepCopy (self.pdb.caps)
  data.caps[1].init = 0
  data.caps[2].init = 0
  data.initial = {}

  for i = 1, #self.itemStats do
    data.initial[i] = self.itemStats[i].getter ()
    if i == self.STATS.SPIRIT then
      data.initial[i] = data.initial[i] / self.spiritBonus
    end
    for j = 1, #data.method.items do
      data.initial[i] = data.initial[i] - data.method.items[j].stats[i]
    end
  end
  local reforgedSpirit = 0
  for i = 1, #data.method.items do
    local item = GetInventoryItemLink ("player", self.itemData[i].slotId)
    local reforge = (item and self:GetReforgeID (item))
    if reforge then
      local src, dst = self.reforgeTable[reforge][1], self.reforgeTable[reforge][2]
      local amount = math.floor (method.items[i].stats[src] * REFORGE_COEFF)
      data.initial[src] = data.initial[src] + amount
      data.initial[dst] = data.initial[dst] - amount
      if src == self.STATS.SPIRIT then
        reforgedSpirit = reforgedSpirit - amount
      elseif dst == self.STATS.SPIRIT then
        reforgedSpirit = reforgedSpirit + amount
      end
    end
  end
  if self.s2hFactor and self.s2hFactor > 0 then
    data.initial[self.STATS.HIT] = data.initial[self.STATS.HIT] - math.floor (reforgedSpirit * self.spiritBonus * self.s2hFactor / 100 + 0.5)
  end
  if data.caps[1].stat > 0 then
    data.caps[1].init = data.initial[data.caps[1].stat]
    for i = 1, #data.method.items do
      data.caps[1].init = data.caps[1].init + data.method.items[i].stats[data.caps[1].stat]
    end
  end
  if data.caps[2].stat > 0 then
    data.caps[2].init = data.initial[data.caps[2].stat]
    for i = 1, #data.method.items do
      data.caps[2].init = data.caps[2].init + data.method.items[i].stats[data.caps[2].stat]
    end
  end
  if data.caps[1].stat == 0 then
    data.caps[1], data.caps[2] = data.caps[2], data.caps[1]
  end
  if data.caps[2].stat == data.caps[1].stat then
    data.caps[2].stat = 0
    data.caps[2].init = 0
  end
  if data.caps[2].stat == 0 then
    REFORGE_CHEAT = 1
  end

  if self.s2hFactor and self.s2hFactor > 0 then
    if data.weights[self.STATS.SPIRIT] == 0 and (data.caps[1].stat == self.STATS.HIT or data.caps[2].stat == self.STATS.HIT) then
      data.weights[self.STATS.SPIRIT] = 1
    end
  end

  return data
end

function ReforgeLite:ChooseReforgeClassic (data, reforgeOptions, scores, codes)
  local bestCode = {nil, nil, nil, nil}
  local bestScore = {0, 0, 0, 0}
  for k, score in pairs (scores) do
    local s1 = data.caps[1].init
    local s2 = data.caps[2].init
    local code = codes[k]
    for i = 1, #code do
      local b = code:byte (i)
      s1 = s1 + reforgeOptions[i][b].d1
      s2 = s2 + reforgeOptions[i][b].d2
    end
    local a1, a2 = true, true
    if data.caps[1].stat > 0 then
      a1 = a1 and self:CapAllows (data.caps[1], s1)
      score = score + self:GetCapScore (data.caps[1], s1)
    end
    if data.caps[2].stat > 0 then
      a2 = a2 and self:CapAllows (data.caps[2], s2)
      score = score + self:GetCapScore (data.caps[2], s2)
    end
    local allow = a1 and (a2 and 1 or 2) or (a2 and 3 or 4)
    if bestCode[allow] == nil or score > bestScore[allow] then
      bestCode[allow] = code
      bestScore[allow] = score
    end
  end
  return bestCode[1] or bestCode[2] or bestCode[3] or bestCode[4]
end

----------------------------------- SPIRIT-TO-HIT REFORGE ------------------------------

function ReforgeLite:GetItemReforgeOptionsS2H (item, data, slot)
  if self:IsItemLocked (slot) then
    local link = GetInventoryItemLink ("player", self.itemData[slot].slotId)
    local srcstat, dststat, delta1, delta2, dscore = nil, nil, 0, 0, 0
    if link then
      local reforge = self:GetReforgeID (link)
      if reforge then
        srcstat = self.reforgeTable[reforge][1]
        dststat = self.reforgeTable[reforge][2]
        local amount = math.floor (item.stats[srcstat] * REFORGE_COEFF)
        if srcstat == self.STATS.HIT then
          delta1 = delta1 - amount
        elseif srcstat == self.STATS.SPIRIT then
          delta2 = delta2 - amount
        else
          dscore = dscore - data.weights[srcstat] * amount
        end
        if dststat == self.STATS.HIT then
          delta1 = delta1 + amount
        elseif dststat == self.STATS.SPIRIT then
          delta2 = delta2 + amount
        else
          dscore = dscore + data.weights[dststat] * amount
        end
      end
    end
    return {{src = srcstat, dst = dststat, d1 = delta1, d2 = delta2, score = dscore}}
  end
  local opt = {}
  local best = nil
  for i = 1, #self.itemStats do
    if item.stats[i] == 0 and i ~= self.STATS.HIT and i ~= self.STATS.SPIRIT and (best == nil or data.weights[i] > data.weights[best]) then
      best = i
    end
  end
  if best then
    local worst = nil
    local worstScore = 0
    for i = 1, #self.itemStats do
      if item.stats[i] > 0 and i ~= self.STATS.HIT and i ~= self.STATS.SPIRIT then
        local score = (data.weights[best] - data.weights[i]) * math.floor (item.stats[i] * REFORGE_COEFF)
        if score > worstScore then
          worstScore = score
          worst = i
        end
      end
    end
    if worst then
      table.insert (opt, {src = worst, dst = best, d1 = 0, d2 = 0, score = worstScore})
    else
      table.insert (opt, {d1 = 0, d2 = 0, score = 0})
    end
  else
    table.insert (opt, {d1 = 0, d2 = 0, score = 0})
  end
  if item.stats[self.STATS.HIT] == 0 then
    for i = 1, #self.itemStats do
      if item.stats[i] > 0 then
        local amount = math.floor (item.stats[i] * REFORGE_COEFF)
        table.insert (opt, {src = i, dst = self.STATS.HIT, d1 = amount, d2 = (i == self.STATS.SPIRIT and -amount or 0),
          score = -amount * (i == self.STATS.SPIRIT and 0 or data.weights[i])})
      end
    end
  elseif best then
    local amount = math.floor (item.stats[self.STATS.HIT] * REFORGE_COEFF)
    table.insert (opt, {src = self.STATS.HIT, dst = best, d1 = -amount, d2 = 0, score = data.weights[best] * amount})
  end
  if item.stats[self.STATS.SPIRIT] == 0 then
    for i = 1, #self.itemStats do
      if item.stats[i] > 0 then
        local amount = math.floor (item.stats[i] * REFORGE_COEFF)
        table.insert (opt, {src = i, dst = self.STATS.SPIRIT, d1 = (i == self.STATS.HIT and -amount or 0), d2 = amount,
          score = -amount * (i == self.STATS.HIT and 0 or data.weights[i])})
      end
    end
  elseif best then
    local amount = math.floor (item.stats[self.STATS.SPIRIT] * REFORGE_COEFF)
    table.insert (opt, {src = self.STATS.SPIRIT, dst = best, d1 = 0, d2 = -amount, score = data.weights[best] * amount})
  end
  return opt
end
function ReforgeLite:InitReforgeS2H ()
  local method = {}
  method.items = {}
  for i = 1, #self.itemData do
    method.items[i] = {}
    method.items[i].stats = {}
    local item = GetInventoryItemLink ("player", self.itemData[i].slotId)
    local stats = (item and GetItemStats (item) or {})
    for j = 1, #self.itemStats do
      method.items[i].stats[j] = (stats[self.itemStats[j].name] or 0)
    end
  end

  REFORGE_CHEAT = self.db.reforgeCheat

  local usecap = 1
  if self.pdb.caps[1].stat == 0 then
    usecap = 2
  end
  local data = {}
  data.method = method
  data.weights = DeepCopy (self.pdb.weights)
  if data.weights[self.STATS.SPIRIT] == 0 then
    data.weights[self.STATS.SPIRIT] = 1
  end
  data.cap = {stat = self.STATS.HIT, points = DeepCopy (self.pdb.caps[usecap].points), init = 0}
  data.initial = {}
  for i = 1, #self.itemStats do
    data.initial[i] = self.itemStats[i].getter ()
    if i == self.STATS.SPIRIT then
      data.initial[i] = data.initial[i] / self.spiritBonus
    end
    for j = 1, #data.method.items do
      data.initial[i] = data.initial[i] - data.method.items[j].stats[i]
    end
  end
  for i = 1, #data.method.items do
    local item = GetInventoryItemLink ("player", self.itemData[i].slotId)
    local reforge = (item and self:GetReforgeID (item))
    if reforge then
      local src, dst = self.reforgeTable[reforge][1], self.reforgeTable[reforge][2]
      local amount = math.floor (method.items[i].stats[src] * REFORGE_COEFF)
      data.initial[src] = data.initial[src] + amount
      data.initial[dst] = data.initial[dst] - amount
    end
  end
  data.initial[self.STATS.HIT] = data.initial[self.STATS.HIT] - math.floor (self.itemStats[self.STATS.SPIRIT].getter () * self.s2hFactor / 100 + 0.5)
  data.cap.init = data.initial[self.STATS.HIT]
  data.spi = math.floor (data.initial[self.STATS.SPIRIT] + 0.5)
  for i = 1, #data.method.items do
    data.cap.init = data.cap.init + data.method.items[i].stats[self.STATS.HIT]
    data.spi = data.spi + data.method.items[i].stats[self.STATS.SPIRIT]
  end
  data.initial[self.STATS.SPIRIT] = math.floor (data.initial[self.STATS.SPIRIT] * self.spiritBonus + 0.5)
  
  data.caps = {{stat = self.STATS.HIT, init = data.cap.init}, {stat = self.STATS.SPIRIT, init = data.spi}}

  return data
end

function ReforgeLite:ChooseReforgeS2H (data, reforgeOptions, scores, codes)
  local bestCode = {nil, nil}
  local bestScore = {0, 0}
  for k, score in pairs (scores) do
    local code = codes[k]
    local hit = data.cap.init
    local spi = data.spi
    for i = 1, #code do
      local b = code:byte (i)
      hit = hit + reforgeOptions[i][b].d1
      spi = spi + reforgeOptions[i][b].d2
    end
    spi = math.floor (spi * self.spiritBonus + 0.5)
    hit = hit + math.floor (spi * self.s2hFactor / 100 + 0.5)
    local allow = self:CapAllows (data.cap, hit) and 1 or 2
    score = score + self:GetCapScore (data.cap, hit) + data.weights[self.STATS.SPIRIT] * spi
    if bestCode[allow] == nil or score > bestScore[allow] then
      bestCode[allow] = code
      bestScore[allow] = score
    end
  end
  return bestCode[1] or bestCode[2]
end

----------------------------------- TANKING REFORGE ------------------------------

function ReforgeLite:GetItemReforgeOptionsTank (item, data, slot)
  if self:IsItemLocked (slot) then
    local link = GetInventoryItemLink ("player", self.itemData[slot].slotId)
    local srcstat, dststat, delta1, delta2, dscore = nil, nil, 0, 0, 0
    if link then
      local reforge = self:GetReforgeID (link)
      if reforge then
        srcstat = self.reforgeTable[reforge][1]
        dststat = self.reforgeTable[reforge][2]
        local amount = math.floor (item.stats[srcstat] * REFORGE_COEFF)
        if srcstat == self.STATS.DODGE then
          delta1 = delta1 - amount
        elseif srcstat == self.STATS.PARRY then
          delta2 = delta2 - amount
        else
          dscore = dscore - data.weights[srcstat] * amount
        end
        if dststat == self.STATS.DODGE then
          delta1 = delta1 + amount
        elseif dststat == self.STATS.PARRY then
          delta2 = delta2 + amount
        else
          dscore = dscore + data.weights[dststat] * amount
        end
      end
    end
    return {{src = srcstat, dst = dststat, d1 = delta1, d2 = delta2, score = dscore}}
  end
  local opt = {}
  local best = nil
  for i = 1, #self.itemStats do
    if item.stats[i] == 0 and i ~= self.STATS.DODGE and i ~= self.STATS.PARRY and (best == nil or data.weights[i] > data.weights[best]) then
      best = i
    end
  end
  if best then
    local worst = nil
    local worstScore = 0
    for i = 1, #self.itemStats do
      if item.stats[i] > 0 and i ~= self.STATS.DODGE and i ~= self.STATS.PARRY then
        local score = (data.weights[best] - data.weights[i]) * math.floor (item.stats[i] * REFORGE_COEFF)
        if score > worstScore then
          worstScore = score
          worst = i
        end
      end
    end
    if worst then
      table.insert (opt, {src = worst, dst = best, d1 = 0, d2 = 0, score = worstScore})
    else
      table.insert (opt, {d1 = 0, d2 = 0, score = 0})
    end
  else
    table.insert (opt, {d1 = 0, d2 = 0, score = 0})
  end
  if item.stats[self.STATS.DODGE] == 0 then
    for i = 1, #self.itemStats do
      if item.stats[i] > 0 then
        local amount = math.floor (item.stats[i] * REFORGE_COEFF)
        table.insert (opt, {src = i, dst = self.STATS.DODGE, d1 = amount, d2 = (i == self.STATS.PARRY and -amount or 0),
          score = -amount * (i == self.STATS.PARRY and 0 or data.weights[i])})
      end
    end
  elseif best then
    local amount = math.floor (item.stats[self.STATS.DODGE] * REFORGE_COEFF)
    table.insert (opt, {src = self.STATS.DODGE, dst = best, d1 = -amount, d2 = 0, score = data.weights[best] * amount})
  end
  if item.stats[self.STATS.PARRY] == 0 then
    for i = 1, #self.itemStats do
      if item.stats[i] > 0 then
        local amount = math.floor (item.stats[i] * REFORGE_COEFF)
        table.insert (opt, {src = i, dst = self.STATS.PARRY, d1 = (i == self.STATS.DODGE and -amount or 0), d2 = amount,
          score = -amount * (i == self.STATS.DODGE and 0 or data.weights[i])})
      end
    end
  elseif best then
    local amount = math.floor (item.stats[self.STATS.PARRY] * REFORGE_COEFF)
    table.insert (opt, {src = self.STATS.PARRY, dst = best, d1 = 0, d2 = -amount, score = data.weights[best] * amount})
  end
  return opt
end
function ReforgeLite:InitReforgeTank ()
  local method = {}
  method.items = {}
  for i = 1, #self.itemData do
    method.items[i] = {}
    method.items[i].stats = {}
    local item = GetInventoryItemLink ("player", self.itemData[i].slotId)
    local stats = (item and GetItemStats (item) or {})
    for j = 1, #self.itemStats do
      method.items[i].stats[j] = (stats[self.itemStats[j].name] or 0)
    end
  end
  method.tankingModel = self.pdb.tankingModel

  REFORGE_CHEAT = self.db.reforgeCheat

  local data = {}
  data.method = method
  if playerClass == "WARRIOR" or playerClass == "PALADIN" then
    data.weights = {}
    for i = 1, #self.itemStats do
      data.weights[i] = 0
    end
    data.weights[self.STATS.MASTERY] = 1
  else
    data.weights = DeepCopy (self.pdb.weights)
  end
  data.initial = {}
  for i = 1, #self.itemStats do
    data.initial[i] = self.itemStats[i].getter ()
    for j = 1, #data.method.items do
      data.initial[i] = data.initial[i] - data.method.items[j].stats[i]
    end
  end
  for i = 1, #data.method.items do
    local item = GetInventoryItemLink ("player", self.itemData[i].slotId)
    local reforge = (item and self:GetReforgeID (item))
    if reforge then
      local src, dst = self.reforgeTable[reforge][1], self.reforgeTable[reforge][2]
      local amount = math.floor (method.items[i].stats[src] * REFORGE_COEFF)
      data.initial[src] = data.initial[src] + amount
      data.initial[dst] = data.initial[dst] - amount
    end
  end
  data.init = {}
  data.init.dodge = data.initial[self.STATS.DODGE]
  data.init.parry = data.initial[self.STATS.PARRY]
  data.init.mastery = data.initial[self.STATS.MASTERY]
  for i = 1, #data.method.items do
    data.init.dodge = data.init.dodge + data.method.items[i].stats[self.STATS.DODGE]
    data.init.mastery = data.init.mastery + data.method.items[i].stats[self.STATS.MASTERY]
    data.init.parry = data.init.parry + data.method.items[i].stats[self.STATS.PARRY]
  end
  local dodge_bonus, parry_bonus, mastery_bonus = self:GetBuffBonuses ()
  data.init.dodge = data.init.dodge + dodge_bonus
  data.init.parry = data.init.parry + parry_bonus
  data.init.mastery = data.init.mastery + mastery_bonus

  local dodgeRating = GetCombatRating (CR_DODGE)
  data.baseDodge = GetDodgeChance () - self:DiminishStat (dodgeRating, self.STATS.DODGE)
  local parryRating = GetCombatRating (CR_PARRY)
  data.baseParry = GetParryChance () - self:DiminishStat (parryRating, self.STATS.PARRY)
  data.unhit = 100 + 0.8 * max (0, self.pdb.targetLevel)
  
  data.caps = {{stat = self.STATS.DODGE, init = data.init.dodge}, {stat = self.STATS.PARRY, init = data.init.parry}}

  return data
end

function ReforgeLite:ChooseReforgeTank (data, reforgeOptions, scores, codes)
  local bestCode = {nil, nil}
  local bestScore = {0, 0}
  for k, score in pairs (scores) do
    local code = codes[k]
    local dodge_rating = data.init.dodge
    local parry_rating = data.init.parry
    for i = 1, #code do
      local b = code:byte (i)
      dodge_rating = dodge_rating + reforgeOptions[i][b].d1
      parry_rating = parry_rating + reforgeOptions[i][b].d2
    end
    local dodge = data.baseDodge + self:DiminishStat (dodge_rating, self.STATS.DODGE)
    local parry = data.baseParry + self:DiminishStat (parry_rating, self.STATS.PARRY)
    local valid = 1
    if playerClass == "WARRIOR" then
      local mastery = data.init.mastery + score
      local critBlock = (8 + mastery / self:RatingPerPoint (self.STATS.MASTERY)) * 1.5
      local block = 20 + critBlock
      if missChance + dodge + parry + block > data.unhit then
        block = data.unhit - missChance - dodge - parry
      end
      score = dodge * self.pdb.weights[self.STATS.DODGE] + parry * self.pdb.weights[self.STATS.PARRY]
      score = score + block * self.pdb.weights[self.STATS.MASTERY] + critBlock * self.pdb.weights[self.STATS.CRITBLOCK]
    elseif playerClass == "PALADIN" then
      local mastery = data.init.mastery + score
      local block = missChance + (8 + mastery / self:RatingPerPoint (self.STATS.MASTERY)) * 2.25
      if missChance + dodge + parry + block >= data.unhit then
        block = data.unhit - missChance - dodge - parry
      else
        valid = 2
      end
      score = dodge * self.pdb.weights[self.STATS.DODGE] + parry * self.pdb.weights[self.STATS.PARRY] + block * self.pdb.weights[self.STATS.MASTERY]
    else
      score = score + dodge * data.weights[self.STATS.DODGE] + parry * data.weights[self.STATS.PARRY]
    end
    if bestCode[valid] == nil or score > bestScore[valid] then
      bestCode[valid] = code
      bestScore[valid] = score
    end
  end
  return bestCode[1] or bestCode[2]
end

-----------------------------------------------------------------------------

local function FormatValue (value, prefix)
  if type (value) == "table" then
    local result = "{\n"
    prefix = prefix or ""
    local newprefix = prefix .. "  "
    for k, v in pairs (value) do
      result = result .. newprefix .. tostring (k) .. " = " .. FormatValue (v, newprefix) .. "\n"
    end
    return result .. prefix .. "}"
  else
    return tostring (value)
  end
end

StaticPopupDialogs["REFORGELITE_COMPUTEERROR"] = {
  text = L["ReforgeLite failed to compute your optimal reforge. Try increasing the speed by moving the speed slider.\nError message: %s"],
  button1 = OKAY,
  button2 = nil,
  OnAccept = function ()
  end,
  timeout = 0,
  whileDead = 1,
  hideOnEscape = 1
}

function ReforgeLite:ComputeReforgeCore (data, reforgeOptions)
  local TABLE_SIZE = 10000
  local scores, codes = {}, {}
  local linit = math.floor (data.caps[1].init / REFORGE_CHEAT + math.random ()) + math.floor (data.caps[2].init / REFORGE_CHEAT + math.random ()) * TABLE_SIZE
  scores[linit] = 0
  codes[linit] = ""
  for i = 1, #self.itemData do
    local newscores, newcodes = {}, {}
    local opt = reforgeOptions[i]
    local count = 0
    for k, score in pairs (scores) do
      local code = codes[k]
      local s1 = k % TABLE_SIZE
      local s2 = math.floor (k / TABLE_SIZE)
      for j = 1, #opt do
        local o = opt[j]
        local nscore = score + o.score
        local nk = s1 + math.floor (o.d1 / REFORGE_CHEAT + math.random ()) + (s2 + math.floor (o.d2 / REFORGE_CHEAT + math.random ())) * TABLE_SIZE
        if newscores[nk] == nil or nscore > newscores[nk] then
          if newscores[nk] == nil then
            count = count + 1
          end
          newscores[nk] = nscore
          newcodes[nk] = code .. string.char (j)
        end
      end
    end
    scores, codes = newscores, newcodes
  end
  return scores, codes
end
function ReforgeLite:ComputeReforge (initFunc, optionFunc, chooseFunc)
  local data = self[initFunc] (self)
  local reforgeOptions = {}
  for i = 1, #self.itemData do
    reforgeOptions[i] = self[optionFunc] (self, data.method.items[i], data, i)
  end

  local success, scores, codes = pcall (self.ComputeReforgeCore, self, data, reforgeOptions)

  self.methodDebug = "<no data>" 
  if success then
    local code = self[chooseFunc] (self, data, reforgeOptions, scores, codes)
    scores, codes = nil, nil
    collectgarbage ("collect")
    for i = 1, #data.method.items do
      local opt = reforgeOptions[i][code:byte (i)]
      if self.s2hFactor == 100 then
        if opt.dst == self.STATS.HIT and data.method.items[i].stats[self.STATS.SPIRIT] == 0 then
          opt.dst = self.STATS.SPIRIT
        end
      end
      data.method.items[i].src = opt.src
      data.method.items[i].dst = opt.dst
    end
    self.methodDebug = "data = " .. FormatValue (data) .. "\n\n"
    self:FinalizeReforge (data)
    self.methodDebug = self.methodDebug .. "method = " .. FormatValue (data.method)
    return data.method
  else
    self.methodDebug = "data = " .. FormatValue (data)
    StaticPopup_Show ("REFORGELITE_COMPUTEERROR", scores)
    return nil
  end
end

function ReforgeLite:Compute ()
  self.spiritBonus = self.spiritBonus or 1
  if self.pdb.tankingModel then
    return self:ComputeReforge ("InitReforgeTank", "GetItemReforgeOptionsTank", "ChooseReforgeTank")
  elseif self.s2hFactor and self.s2hFactor > 0 and ((self.pdb.caps[1].stat == self.STATS.HIT and self.pdb.caps[2].stat == 0) or
                                                    (self.pdb.caps[2].stat == self.STATS.HIT and self.pdb.caps[1].stat == 0)) then
    return self:ComputeReforge ("InitReforgeS2H", "GetItemReforgeOptionsS2H", "ChooseReforgeS2H")
  else
    return self:ComputeReforge ("InitReforgeClassic", "GetItemReforgeOptions", "ChooseReforgeClassic")
  end
end

local ErrorFrame = CreateFrame ("Frame", "ReforgeLiteErrorFrame", UIParent)
ErrorFrame:Hide ()
ErrorFrame:SetPoint ("CENTER")
ErrorFrame:SetFrameStrata ("TOOLTIP")
ErrorFrame:SetWidth (320)
ErrorFrame:SetHeight (400)
ErrorFrame:SetBackdrop ({
  bgFile = "Interface\\Tooltips\\ChatBubble-Background",
  edgeFile = "Interface\\Tooltips\\ChatBubble-BackDrop",
  tile = true, tileSize = 32, edgeSize = 32,
  insets = {left = 32, right = 32, top = 32, bottom = 32}
})
ErrorFrame:SetBackdropColor (0, 0, 0, 1)
ErrorFrame:SetMovable (true)
ErrorFrame:SetClampedToScreen (true)
ErrorFrame:EnableMouse (true)
ErrorFrame:SetScript ("OnMouseDown", function () ErrorFrame:StartMoving () end)
ErrorFrame:SetScript ("OnMouseUp", function () ErrorFrame:StopMovingOrSizing () end)

ErrorFrame.ok = CreateFrame ("Button", "ReforgeLiteErrorFrameOk", ErrorFrame, "UIPanelButtonTemplate")
ErrorFrame.ok:SetSize (112, 22)
ErrorFrame.ok:SetText (ACCEPT)
ErrorFrame.ok:SetPoint ("BOTTOM", 0, 10)
ErrorFrame.ok:SetScript ("OnClick", function () ErrorFrame:Hide () end)
ErrorFrame.message = ErrorFrame:CreateFontString (nil, "OVERLAY", "GameFontNormal")
ErrorFrame.message:SetPoint ("TOPLEFT", 15, -15)
ErrorFrame.message:SetPoint ("TOPRIGHT", -15, -15)
ErrorFrame.message:SetJustifyH ("LEFT")
ErrorFrame.message:SetTextColor (1, 1, 1)
ErrorFrame.message:SetText ("")
ErrorFrame.scroll = CreateFrame ("ScrollFrame", "ReforgeLiteErrorFrameScroll", ErrorFrame, "UIPanelScrollFrameTemplate")
ErrorFrame.scroll:SetPoint ("TOPLEFT", ErrorFrame.message, "BOTTOMLEFT", 0, -10)
ErrorFrame.scroll:SetPoint ("TOPRIGHT", ErrorFrame.message, "BOTTOMRIGHT", -16, -10)
ErrorFrame.scroll:SetPoint ("BOTTOM", ErrorFrame.ok, "TOP", 0, 10)
ErrorFrame.text = CreateFrame ("EditBox", "ReforgeLiteErrorFrameText", ErrorFrame.scroll)
ErrorFrame.scroll:SetScrollChild (ErrorFrame.text)
ErrorFrame.text:SetWidth (274)
ErrorFrame.text:SetHeight (100)
ErrorFrame.text:SetMultiLine (true)
ErrorFrame.text:SetAutoFocus (false)
ErrorFrame.text:SetFontObject (GameFontHighlight)
ErrorFrame.text:SetScript ("OnEscapePressed", function () ErrorFrame:Hide () end)
ErrorFrame.updateText = function ()
  ErrorFrame.text:SetText (ErrorFrame.err)
  ErrorFrame.scroll:UpdateScrollChildRect ()
  ErrorFrame.text:ClearFocus ()
end
ErrorFrame.text:SetScript ("OnTextChanged", ErrorFrame.updateText)
ErrorFrame.text:SetScript ("OnEditFocusGained", function ()
  ErrorFrame.text:HighlightText ()
end)
function ErrorFrame:DisplayError (message, err)
  ErrorFrame.message:SetText (message)
  ErrorFrame.err = err
  ErrorFrame.updateText ()
  ErrorFrame:Show ()
end

function ReforgeLite:DebugMethod ()
  ErrorFrame:DisplayError ("E-mail: d07.riv@gmail.com", self.methodDebug or "<no data>")
end
