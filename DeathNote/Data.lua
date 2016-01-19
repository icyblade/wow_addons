-- Death iterator
local function DeathIterator(state)
	repeat
		local l = DeathNoteData.log[state.t]
		if l then
			if state.i == nil then
				state.i = #l
			end
			for i = state.i, 1, -1 do
				local entry = l[i]
				if entry.destGUID == state.guid and entry.timestamp <= state.death_time then
					if entry.event == "UNIT_DIED" then
						state.death_found = state.death_found + 1
						if state.death_found > 1 then
							return nil
						end
					end

					state.i = i - 1
					return entry
				end
			end
			state.i = nil
		end
		state.t = state.t - 1
	until state.t < state.endt

	return nil
end

function DeathNote:IterateDeath(death, maxt)
	local state = {
		guid = death.GUID,
		death_time = death.timestamp,
		t = floor(death.timestamp),
		endt = floor(death.timestamp) - maxt,
		death_found = 0,
	}

	return DeathIterator, state
end

-- Overkill readers
local function SpellDamageAmount(spellId, spellName, spellSchool, ...)
	return ...
end

local function SwingDamageAmount(...)
	return ...
end

local function EnvironmentalAmount(environmentalType, ...)
	return ...
end

local function SpellInstakillAmount()
	return -1
end

-- Heal readers
local function SpellHealAmount(spellId, spellName, spellSchool, ...)
	return ...
end

-- SpellId readers
local function SpellSpellId(spellId, spellName, spellSchool)
	return spellId, spellName, spellSchool
end

local function SwingSpellId(amount, overkill, school)
	return ACTION_SWING, ACTION_SWING, school
end

local function EnvironmentalSpellId(environmentalType, amount, overkill, school)
	return _G["STRING_ENVIRONMENTAL_DAMAGE_" .. string.upper(environmentalType)], _G["STRING_ENVIRONMENTAL_DAMAGE_" .. string.upper(environmentalType)], school
end

local function ExtraSpellId(spellId, spellName, spellSchool, extraSpellId, extraSpellName, extraSpellSchool)
	return extraSpellId, extraSpellName, extraSpellSchool
end

-- Aura readers
local function AuraApplied(spellId, spellName, spellSchool, auraType, amount)
	return true, auraType, amount, spellId, spellName, spellSchool, false
end

local function AuraRemoved(spellId, spellName, spellSchool, auraType, amount)
	return false, auraType, amount, spellId, spellName, spellSchool, false
end

local function AuraBrokenSpell(spellId, spellName, spellSchool, extraSpellId, extraSpellName, extraSpellSchool, auraType)
	return false, auraType, 0, spellId, spellName, spellSchool, true
end

local function AuraDispel(spellId, spellName, spellSchool, extraSpellId, extraSpellName, extraSpellSchool, auraType)
	return false, auraType, 0, extraSpellId, extraSpellName, extraSpellSchool, true
end

-- Type readers
local function TypeDamage()
	return "DAMAGE"
end

local function TypeMiss()
	return "MISS"
end

local function TypeHeal()
	return "HEAL"
end

local function TypeAura()
	return "AURA"
end

local function TypeInterrupt()
	return "INTERRUPT"
end

local function TypeInstakill()
	return "INSTAKILL"
end

local function TypeDeath()
	return "DEATH"
end

local function TypeCast()
	return "CAST"
end

-- type, damage, heal, spell, aura
local event_reader_table = {
	["SPELL_DAMAGE"] 			= { TypeDamage, SpellDamageAmount, nil, SpellSpellId },
	["SPELL_PERIODIC_DAMAGE"] 	= { TypeDamage, SpellDamageAmount, nil, SpellSpellId },
	["SPELL_BUILDING_DAMAGE"] 	= { TypeDamage, SpellDamageAmount, nil, SpellSpellId },
	["RANGE_DAMAGE"] 			= { TypeDamage, SpellDamageAmount, nil, SpellSpellId },
	["DAMAGE_SHIELD"] 			= { TypeDamage, SpellDamageAmount, nil, SpellSpellId },
	["DAMAGE_SPLIT"] 			= { TypeDamage, SpellDamageAmount, nil, SpellSpellId },

	["SPELL_MISSED"] 			= { TypeMiss, nil, nil, SpellSpellId, nil },
	["SPELL_PERIODIC_MISSED"] 	= { TypeMiss, nil, nil, SpellSpellId, nil },
	["SPELL_BUILDING_MISSED"] 	= { TypeMiss, nil, nil, SpellSpellId, nil },
	["DAMAGE_SHIELD_MISSED"] 	= { TypeMiss, nil, nil, SpellSpellId, nil },

	["SWING_DAMAGE"] 			= { TypeDamage, SwingDamageAmount, nil, SwingSpellId },

	["SWING_MISSED"] 			= { TypeMiss, nil, nil, SwingSpellId, nil },

	["ENVIRONMENTAL_DAMAGE"] 	= { TypeDamage, EnvironmentalAmount, nil, EnvironmentalSpellId },

	["SPELL_HEAL"] 				= { TypeHeal, nil, SpellHealAmount, SpellSpellId },
	["SPELL_PERIODIC_HEAL"] 	= { TypeHeal, nil, SpellHealAmount, SpellSpellId },
	["SPELL_BUILDING_HEAL"] 	= { TypeHeal, nil, SpellHealAmount, SpellSpellId },

	["SPELL_AURA_APPLIED"]		= { TypeAura, nil, nil, SpellSpellId, AuraApplied },
	["SPELL_AURA_REMOVED"]		= { TypeAura, nil, nil, SpellSpellId, AuraRemoved },
	["SPELL_AURA_APPLIED_DOSE"]	= { TypeAura, nil, nil, SpellSpellId, AuraApplied },
	["SPELL_AURA_REMOVED_DOSE"]	= { TypeAura, nil, nil, SpellSpellId, AuraRemoved },
	["SPELL_AURA_REFRESH"]		= { TypeAura, nil, nil, SpellSpellId, AuraApplied },
	["SPELL_AURA_BROKEN"]		= { TypeAura, nil, nil, SpellSpellId, AuraRemoved },
	["SPELL_AURA_BROKEN_SPELL"]	= { TypeAura, nil, nil, SpellSpellId, AuraBrokenSpell },

	["SPELL_DISPEL"]			= { TypeAura, nil, nil, ExtraSpellId, AuraDispel },
	-- ["SPELL_DISPEL_FAILED"]		= true,
	["SPELL_STOLEN"]			= { TypeAura, nil, nil, ExtraSpellId, AuraDispel },

	["SPELL_INTERRUPT"] 		= { TypeInterrupt, nil, nil, ExtraSpellId },

	["SPELL_CAST_START"]		= { TypeCast },
	["SPELL_CAST_SUCCESS"]		= { TypeCast },

	["SPELL_INSTAKILL"]			= { TypeInstakill, SpellInstakillAmount, nil, SpellSpellId },

	["UNIT_DIED"] 				= { TypeDeath },
}

local function GetEntryReader(entry, nreader)
	local reader = event_reader_table[entry.event] and event_reader_table[entry.event][nreader]

	if reader then
		return reader(unpack(entry, DeathNote.EntryIndexInfo.eventArgs))
	end
end

function DeathNote:GetEntryType(entry)
	return GetEntryReader(entry, 1)
end

function DeathNote:GetEntryDamage(entry)
	return GetEntryReader(entry, 2)
end

function DeathNote:GetEntryHeal(entry)
	return GetEntryReader(entry, 3)
end

function DeathNote:GetEntrySpell(entry)
	return GetEntryReader(entry, 4)
end

function DeathNote:GetEntryAura(entry)
	return GetEntryReader(entry, 5)
end

function DeathNote:GetKillingBlow(death)
	for entry in self:IterateDeath(death, 20) do
		local damage, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = self:GetEntryDamage(entry)
		if overkill and overkill > 0 then
			return entry, damage, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing
		end
	end

	-- if no overkill is found just return the last damage event
	for entry in self:IterateDeath(death, 20) do
		local damage, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = self:GetEntryDamage(entry)
		if damage and damage > 0 or damage == -1 or absorbed and absorbed > 0 then
			return entry, damage, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing
		end
	end

	return nil
end

function DeathNote:IsEntryGroup(entry)
	return not not entry.type
end

function DeathNote:IsEntryOverThreshold(entry)
	if self:IsEntryGroup(entry) then
		return self:IsGroupOverThreshold(entry)
	end

	if self.settings.display_filters.damage_threshold > 0 then
		local damage = self:GetEntryDamage(entry)
		if damage and damage < self.settings.display_filters.damage_threshold then
			return false
		end
	end

	if self.settings.display_filters.heal_threshold > 0 then
		local heal = self:GetEntryHeal(entry)
		if heal and heal < self.settings.display_filters.heal_threshold then
			return false
		end
	end

	return true
end

-- returns function, critical arg position
function DeathNote:GetAmountFunc(type)
	if type == "DAMAGE" then
		return self.GetEntryDamage, 7
	elseif type == "HEAL" then
		return self.GetEntryHeal, 4
	end
end

function DeathNote:GetGroupAmount(group)
	local func, critpos = self:GetAmountFunc(group.type)

	if func then
		local amount = 0
		local crit = false
		local over = 0

		for i = 1, #group do
			local data = { func(self, group[i]) }
			amount = amount + data[1]
			
			crit = (data[critpos] == 1) or crit
			over = over + (data[2] or 0)
		end

		return amount, crit, over
	end
end

function DeathNote:GetTypeThreshold(type)
	if type == "DAMAGE" then
		return self.settings.display_filters.damage_threshold
	elseif type == "HEAL" then
		return self.settings.display_filters.heal_threshold
	end
end

function DeathNote:IsGroupOverThreshold(group)
	if group.type == "DAMAGE" and self.settings.display_filters.damage_threshold > 0 then
		if self:GetGroupAmount(group) < self.settings.display_filters.damage_threshold then
			return false
		end
	end

	if group.type == "HEAL" and self.settings.display_filters.heal_threshold > 0 then
		if self:GetGroupAmount(group) < self.settings.display_filters.heal_threshold then
			return false
		end
	end

	return true
end

local auras_broken = {} -- dispel, steal, break
local survival_stack = {}
function DeathNote:ResetFiltering()
	wipe(auras_broken)
	wipe(survival_stack)
end

local function prio_insert(survival_stack, spellid)
	local myprio = DeathNote.SurvivalIDs[spellid].priority
	local pos

	for i = 1, #survival_stack do
		local thisprio = DeathNote.SurvivalIDs[survival_stack[i]].priority
		if thisprio >= myprio then
			pos = i
			break
		end
	end

	if pos then
		table.insert(survival_stack, pos, spellid)
	else
		table.insert(survival_stack, spellid)
	end
end

function DeathNote:IsEntryFiltered(entry)
	-- hack to remove obnoxious events that will never be shown unless a filter is added for them
	local event = entry.event
	if event == "SPELL_AURA_REFRESH" or event == "SPELL_CAST_START" or event == "SPELL_CAST_SUCCESS" then
		return false
	end

	local timestamp = entry.timestamp
	local auraGain, auraType, _, auraSpellId, _, _, auraBroken = self:GetEntryAura(entry)

	if next(self.settings.display_filters.spell_filter) then
		local _, spellname = self:GetEntrySpell(entry)
		if self.settings.display_filters.spell_filter[string.lower(spellname or "")] then
			return false
		end
	end

	if next(self.settings.display_filters.source_filter) then
		if self.settings.display_filters.source_filter[string.lower(entry.sourceName or "")] then
			return false
		end
	end

	if self.settings.display_filters.hide_misses then
		if self:GetEntryType(entry) == "MISS" then
			return false
		end
	end

	-- Remove fades when a break is detected
	if auraBroken then
		auras_broken[auraSpellId] = timestamp
	elseif auraSpellId and auras_broken[auraSpellId] then
		local aurat = auras_broken[auraSpellId]
		auras_broken[auraSpellId] = nil
		if (aurat - timestamp) < 1 then
			return false
		end
	end

	-- Survival highlighting
	local this_survivalid = survival_stack[1]

	if self.settings.display_filters.highlight_survival then
		if self.SurvivalIDs[auraSpellId] then
			if auraGain then
				for i = 1, #survival_stack do
					if survival_stack[i] == auraSpellId then
						table.remove(survival_stack, i)
						break
					end
				end
			else
				prio_insert(survival_stack, auraSpellId)
				this_survivalid = survival_stack[1]
			end
		end
	end

	if self.settings.display_filters.survival_buffs then
		if self.SurvivalIDs[auraSpellId] then
			return true, this_survivalid
		end
	end

	if not self.settings.display_filters.buff_gains then
		if auraGain and auraType == "BUFF" then
			return false
		end
	end

	if not self.settings.display_filters.buff_fades then
		if not auraGain and auraType == "BUFF" then
			return false
		end
	end

	if not self.settings.display_filters.debuff_gains then
		if auraGain and auraType == "DEBUFF" then
			return false
		end
	end

	if not self.settings.display_filters.debuff_fades then
		if not auraGain and auraType == "DEBUFF" then
			return false
		end
	end

	return true, this_survivalid
end
