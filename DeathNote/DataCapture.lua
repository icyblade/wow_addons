local L = LibStub("AceLocale-3.0"):GetLocale("DeathNote")

DeathNote.CurrentDataVersion = 1

DeathNote.EntryIndexInfo = {
	hp					= 1,
	hpMax				= 2,
	cleArgs				= 3,
	timestamp			= 3,
	event				= 4,
	hideCaster			= 5,
	sourceGUID			= 6,
	sourceName			= 7,
	sourceFlags			= 8,
	sourceRaidFlags		= 9,
	destGUID			= 10,
	destName			= 11,
	destFlags			= 12,
	destRaidFlags		= 13,
	eventArgs			= 14,
}

DeathNote.DeathIndexInfo = {
	timestamp			= 1,
	GUID				= 2,
	name				= 3,
	flags				= 4,
	raidFlags			= 5,
}


local eii = DeathNote.EntryIndexInfo
local dii = DeathNote.DeathIndexInfo

local entrymeta = {
	__index = function(self, idx)
		return rawget(self, eii[idx])
	end
}

local deathmeta = {
	__index = function(self, idx)
		return rawget(self, dii[idx])
	end
}


local tinsert, tremove = table.insert, table.remove
local floor, next, wipe, setmetatable, rawget = math.floor, next, wipe, setmetatable, rawget
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax
local UnitExists, UnitGUID = UnitExists, UnitGUID
local UnitIsFeignDeath = UnitIsFeignDeath
local GetTime = GetTime
local bit_bor, bit_band = bit.bor, bit.band

local log
local deaths

local unit_filters = {}

function DeathNote:AddDeath(timestamp, destGUID, destName, destFlags, destRaidFlags)
	local death = { timestamp, destGUID, destName, destFlags, destRaidFlags }
	setmetatable(death, deathmeta)
	tinsert(deaths, death)

	self:AnnounceDeath(death)

	-- UpdateNameList does nothing when the frame is hidden
	self:UpdateNameList()
end

local function UnitDiedFilter(timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags)
	if destName and not UnitIsFeignDeath(destName) then
		DeathNote:AddDeath(timestamp, destGUID, destName, destFlags, destRaidFlags)
	end
end

local DUEL_WINNER_KNOCKOUT_PATTERN = string.gsub(DUEL_WINNER_KNOCKOUT, "%%%d$s", "([%%S]*)")
local DUEL_WINNER_RETREAT_PATTERN = string.gsub(DUEL_WINNER_RETREAT, "%%%d$s", "([%%S]*)")

local function FindPlayerInfo(name)
	local now = floor(time())

	for t = now, now - 30, -1 do
		local logt = log[t]
		if logt then
			for i = #logt, 1, -1 do
				if logt[i].sourceName and string.gsub(logt[i].sourceName, "-.*", "") == name then
					return logt[i].sourceGUID, logt[i].sourceName, logt[i].sourceFlags, logt[i].sourceRaidFlags
				elseif logt[i].destName and string.gsub(logt[i].destName, "-.*", "") == name then
					return logt[i].destGUID, logt[i].destName, logt[i].destFlags, logt[i].destRaidFlags
				end
			end
		end
	end
end

function DeathNote:CHAT_MSG_SYSTEM(_, msg)
	local found, _, pwin, ploss
	found, _, pwin, ploss = string.find(msg, DUEL_WINNER_KNOCKOUT_PATTERN)
	
	if not found then
		found, _, ploss, pwin = string.find(msg, DUEL_WINNER_RETREAT_PATTERN)
	end

	if found then
		local destGUID, destName, destFlags, destRaidFlags = FindPlayerInfo(ploss)
		if destGUID then
			self:COMBAT_LOG_EVENT_UNFILTERED(
				"COMBAT_LOG_EVENT_UNFILTERED",	-- _
				time() + 5,						-- timestamp
				"UNIT_DIED",                 	-- event
				false,                          -- hideCaster
				destGUID,                     	-- destGUID
				destName,                     	-- destName
				destFlags,                    	-- destFlags
				destRaidFlags,					-- destRaidFlags
				destGUID,                     	-- destGUID
				destName,                     	-- destName
				destFlags,                    	-- destFlags
				destRaidFlags)					-- destRaidFlags
		else
			self:Debug(ploss, "not found")
		end
	end
end

local event_handler_table = {
	["SPELL_DAMAGE"] 			= true,
	["SPELL_PERIODIC_DAMAGE"] 	= true,
	["SPELL_BUILDING_DAMAGE"] 	= true,
	["RANGE_DAMAGE"] 			= true,
	["DAMAGE_SHIELD"] 			= true,
	["DAMAGE_SPLIT"] 			= true,

	["SPELL_MISSED"] 			= true,
	["SPELL_PERIODIC_MISSED"] 	= true,
	["SPELL_BUILDING_MISSED"] 	= true,
	["DAMAGE_SHIELD_MISSED"] 	= true,

	["SWING_DAMAGE"] 			= true,

	["SWING_MISSED"] 			= true,

	["ENVIRONMENTAL_DAMAGE"] 	= true,

	["SPELL_HEAL"] 				= true,
	["SPELL_PERIODIC_HEAL"] 	= true,
	["SPELL_BUILDING_HEAL"] 	= true,

	["SPELL_AURA_APPLIED"]		= true,
	["SPELL_AURA_REMOVED"]		= true,
	["SPELL_AURA_APPLIED_DOSE"]	= true,
	["SPELL_AURA_REMOVED_DOSE"]	= true,
	["SPELL_AURA_REFRESH"]		= true,
	["SPELL_AURA_BROKEN"]		= true,
	["SPELL_AURA_BROKEN_SPELL"]	= true,

	["SPELL_DISPEL"]			= true,
	["SPELL_DISPEL_FAILED"]		= true,
	["SPELL_STOLEN"]			= true,

	["SPELL_INTERRUPT"] 		= true,

	["SPELL_INSTAKILL"]			= true,

	["SPELL_CAST_START"]		= true,
	["SPELL_CAST_SUCCESS"]		= true,

	["UNIT_DIED"] 				= UnitDiedFilter,
}

function DeathNote:DataCapture_Initialize()
	if not DeathNoteData or (DeathNoteData and (not DeathNoteData.v or DeathNoteData.v < self.CurrentDataVersion)) then
		DeathNoteData = {
			v = self.CurrentDataVersion,
			log = {},
			deaths = {},
		}
	end

	log = DeathNoteData.log
	deaths = DeathNoteData.deaths
	
	-- Restore metatables
	local count = 0
	local t = next(log)
	while t do
		local logt = log[t]
		for i = 1, #logt do
			setmetatable(logt[i], entrymeta)
			count = count + 1
		end
		t = next(log, t)
	end

	for i = 1, #deaths do
		setmetatable(deaths[i], deathmeta)
	end
	
	self:UpdateUnitFilters()
end

function DeathNote:ResetData(silent)
	wipe(log)
	wipe(deaths)
	self:UpdateNameList()

	if not silent then
		self:Print(L["Data has been reset"])
		collectgarbage("collect")
	end
end

local last_clean
local keep_guid, keep_all = {}, {}
function DeathNote:CleanData(manual)
	if manual or self.settings.debugging then debugprofilestart() end

	if not self.frame or not self.frame:IsShown() then
		local count = #deaths - self.settings.max_deaths
		for i = 1, count do
			tremove(deaths, 1)
		end

		self:UpdateNameList()
	end

	-- limits number of automatic cleans over time
	if not manual and last_clean then
		if GetTime() < (last_clean + 60) then
			return
		end
	end
	last_clean = GetTime()

	local death_time = self.settings.death_time
	local others_death_time = self.settings.others_death_time
	local min_time = deaths[1] and (deaths[1].timestamp - death_time) or 0
	local max_time = time() - death_time

	wipe(keep_guid)
	wipe(keep_all)

	for i = 1, #deaths do
		local deathsi = deaths[i]
		local timestamp = floor(deathsi.timestamp)
		local guid = deathsi.GUID
		for t = timestamp - death_time, timestamp - others_death_time do
			if not keep_guid[t] then
				keep_guid[t] = {}
			end
			keep_guid[t][guid] = true
		end

		for t = timestamp - others_death_time + 1, timestamp do
			keep_all[t] = true
		end
	end

	local t = next(log)
	while t do
		local logt = log[t]
		local del = false
		if logt then
			if t < min_time then
				del = true
			elseif t < max_time and not keep_all[t] then
				local keep_guidt = keep_guid[t]
				if not keep_guidt then
					del = true
				else
					for i = #logt, 1, -1 do
						-- index is destGUID. Referenced directly by array index for performance reasons
						if not keep_guidt[logt[i][10]] then
							tremove(logt, i)
						end
					end
					if #logt == 0 then
						del = true
					end
				end
			end
		end
		
		local t2 = next(log, t)
		if del then
			log[t] = nil
		end
		t = t2
	end

	if manual or self.settings.debugging then self:Print(string.format(L["Data optimization done in %.02f ms"], debugprofilestop())) end
end

function DeathNote:SetUnitFilter(filter, value)
	self.settings.unit_filters[filter] = value
	self:UpdateUnitFilters()
end

function DeathNote:UpdateUnitFilters()
	local f = self.settings.unit_filters

	wipe(unit_filters)

	if f.group then
		tinsert(unit_filters, bit_bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_TYPE_PLAYER))
		tinsert(unit_filters, bit_bor(COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_TYPE_PLAYER))
		tinsert(unit_filters, bit_bor(COMBATLOG_OBJECT_AFFILIATION_RAID, COMBATLOG_OBJECT_TYPE_PLAYER))
	end

	if f.my_pet then
		tinsert(unit_filters, bit_bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_TYPE_PET))
	end

	if f.friendly_players then
		tinsert(unit_filters, bit_bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_REACTION_FRIENDLY))
	end

	if f.enemy_players then
		tinsert(unit_filters, bit_bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_REACTION_HOSTILE))
	end

	if f.friendly_npcs then
		tinsert(unit_filters, bit_bor(COMBATLOG_OBJECT_TYPE_NPC, COMBATLOG_OBJECT_REACTION_FRIENDLY))
	end

	if f.enemy_npcs then
		tinsert(unit_filters, bit_bor(COMBATLOG_OBJECT_TYPE_NPC, COMBATLOG_OBJECT_REACTION_HOSTILE))
	end

	if f.other_pets then
		if f.friendly_players then
			tinsert(unit_filters, bit_bor(COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PET))
		end

		if f.enemy_players then
			tinsert(unit_filters, bit_bor(COMBATLOG_OBJECT_REACTION_HOSTILE, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PET))
		end

		if f.friendly_npcs then
			tinsert(unit_filters, bit_bor(COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_NPC, COMBATLOG_OBJECT_TYPE_PET))
		end

		if f.enemy_npcs then
			tinsert(unit_filters, bit_bor(COMBATLOG_OBJECT_REACTION_HOSTILE, COMBATLOG_OBJECT_CONTROL_NPC, COMBATLOG_OBJECT_TYPE_PET))
		end
	end
end

function DeathNote:PLAYER_REGEN_DISABLED()
	self:CancelTimer(self.clean_timer, true)
end

function DeathNote:PLAYER_REGEN_ENABLED()
	self.clean_timer = self:ScheduleTimer("CleanData", 15)
end

function DeathNote:PLAYER_FLAGS_CHANGED(_, unitid)
	if unitid == "player" and UnitIsAFK("player") then
		self:CleanData()
	end
end

function DeathNote:PLAYER_LEAVING_WORLD()
	self:CleanData()
end

function DeathNote:OnDatabaseShutdown()
	if self.settings.keep_data then
		self:CleanData()
	else
		self:ResetData(true)
	end
end

local function IsFiltered(sourceFlags, destFlags)
	for i = 1, #unit_filters do
		local f = unit_filters[i]
		if bit_band(f, sourceFlags) == f or bit_band(f, destFlags) == f then
			return true
		end
	end

	return false
end

local function build_tuple_constructor(n)
	local t = {}
	for i = 1, n do
		t[i] = "a" .. i
	end
	local arglist = table.concat(t, ',')

	local t2 = {}
	for i = 1, n do
		local v = "a" .. i
		t2[i] = v .. " ~= nil and " .. v .. " or false"
	end
	local arglist2 = table.concat(t2, ',')

	local src = "return function(" .. arglist .. ") return { " .. arglist2 .. " } end"

	return loadstring(src)()
end

local tuple_constructors = setmetatable({}, {__index=function(self, n)
	local constructor = build_tuple_constructor(n)
	rawset(self, n, constructor)
	return constructor
end})

local function tuple(...)
	local construct = tuple_constructors[select('#', ...)]
	return construct(...)
end

local testids = { "target", "focus", "targettarget", "focustarget", "arena1", "arena2", "arena3", "arena4", "arena5" }

local function GetUnitHealth(name, guid)
	if not name then
		return 0, 0
	end

	local hpmax = UnitHealthMax(name)

	if hpmax == 0 then
		for i = 1, #testids do
			local id = testids[i]
			if UnitExists(id) and UnitGUID(id) == guid then
				return UnitHealth(id), UnitHealthMax(id)
			end
		end

		return 0, 0
	else
		return UnitHealth(name), hpmax
	end
end

function DeathNote:COMBAT_LOG_EVENT_UNFILTERED(_, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	local handler = event_handler_table[event]
	if handler and IsFiltered(sourceFlags, destFlags) then
		-- local hp, hpmax = destName and UnitHealth(destName) or 0, destName and UnitHealthMax(destName) or 0
		local hp, hpmax = GetUnitHealth(destName, destGUID)
		local entry = tuple(hp, hpmax, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
		
		setmetatable(entry, entrymeta)

		local t = floor(timestamp)

		if not log[t] then
			log[t] = {}
		end

		tinsert(log[t], entry)

		if handler ~= true then
			handler(timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
		end
	end
end
