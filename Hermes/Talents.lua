--[[
* Add timer to check for stale talents, make sure it handles name == UNKNOWN properly
* Add code for talent spec changes
]]--
local Hermes = LibStub("AceAddon-3.0"):GetAddon("Hermes")
if not Hermes then return end
local mod = Hermes:NewModule("HermesTalents", "AceEvent-3.0", "AceTimer-3.0")
if not mod then return end

local LTQ = LibStub("LibTalentQuery-1.0")

local roster = {}
local cantinspect = {}
local onupdate = nil
local onremove = nil
local onclasstalentsupdated = nil
local dbg = nil
local refreshTalentTimer = nil
local REFRESH_TALENT_TIME = 10

local SPEC_CHANGE_SPELLS = {}
for index, id in ipairs(_G.TALENT_ACTIVATION_SPELLS) do
	SPEC_CHANGE_SPELLS[GetSpellInfo(id)] = index
end

function mod:OnInitialize()
	
end

function mod:OnEnable()
	wipe(roster)
	wipe(cantinspect)
	LTQ.RegisterCallback(mod, "TalentQuery_Ready")
	LTQ.RegisterCallback(mod, "TalentQuery_Ready_Outsider")
	self:RegisterEvent("RAID_ROSTER_UPDATE")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED")
	self:RegisterEvent("UNIT_NAME_UPDATE")
	self:RegisterEvent("PLAYER_TALENT_UPDATE")
	self:RegisterEvent("UNIT_LEVEL")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:UpdateRosterChanges() --get the current roster situation on startup
	self:StartRefreshTalentTimer()
end

function mod:OnDisable()
	LTQ.UnregisterCallback(mod, "TalentQuery_Ready")
	LTQ.UnregisterCallback(mod, "TalentQuery_Ready_Outsider")
	self:UnregisterEvent("RAID_ROSTER_UPDATE")
	self:UnregisterEvent("PARTY_MEMBERS_CHANGED")
	self:UnregisterEvent("UNIT_NAME_UPDATE")
	self:UnregisterEvent("PLAYER_TALENT_UPDATE")
	self:UnregisterEvent("UNIT_LEVEL")
	self:UnregisterEvent("UNIT_AURA")
	self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:StopRefreshTalentTimer()
	wipe(roster)
	wipe(cantinspect)
end

function mod:SetProfile(profile)
	dbg = profile
end

function mod:RAID_ROSTER_UPDATE()
	self:UpdateRosterChanges()
end

function mod:PARTY_MEMBERS_CHANGED()
	self:UpdateRosterChanges()
end

function mod:PLAYER_TALENT_UPDATE()
	self:QueueTalentQuery("player")
end

function mod:UNIT_NAME_UPDATE(event, unit)
	local guid = UnitGUID(unit)
	
	if not guid then
		return
	end
	
	local r = roster[guid]
	
	if r then
		local needsUpdate = r.name == UNKNOWN
		r.name, _ = UnitName(unit)
		r.class = select(2, UnitClass(unit))
		r.level = UnitLevel(unit)
		if not r.specs and needsUpdate then
			self:QueueTalentQuery(unit)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(event, unit, spell)
	local spec = SPEC_CHANGE_SPELLS[spell]
	if (spec) then
		local guid = UnitGUID(unit)
		
		if not guid then
			return
		end

		local r = roster[guid]
		
		if r then
			--see if we know the spec already
			if r.specs and r.specs[spec] then
				--we know it
				r.activespec = spec
				onupdate(guid, unit, UnitName(unit))
			else
				--we don't know it, queue er up
				self:QueueTalentQuery(unit)
			end
		end
	end
end

function mod:UNIT_LEVEL(event, unit)
	if (UnitInParty(unit) or UnitInRaid(unit)) then
		local guid = UnitGUID(unit)
		
		if not guid then
			return
		end

		local r = roster[guid]

		if r then
			r.level = UnitLevel(unit)
			self:QueueTalentQuery(unit)
		end
	end
end

function mod:UNIT_AURA(event, unit) --the purpose of this is to expedite talent scans for those that we know are in range
	local guid = UnitGUID(unit)
		
	if not guid then
		return
	end

	local r = roster[guid]
	
	--auras can be gained or lost with this event, this essentially flags them as going out of inspect range
	--note that this will eventually get picked up via the inspect timer
	if r and not UnitIsVisible(unit) or not UnitIsConnected(unit) then
		cantinspect[guid] = true
	else
		if cantinspect[guid] then
			--requeue it now since we're probably in range to get the data
			self:QueueTalentQuery(unit)
		end
	end
end

function mod:StopRefreshTalentTimer()
	if(refreshTalentTimer) then
		refreshTalentTimer = self:ScheduleTimer("OnUpdateTalentTimer", REFRESH_TALENT_TIME) --this is a bug fix, soemtimes timer doesn't stop as expected unless you convert to a one-shot timer first
		self:CancelTimer(refreshTalentTimer, true)
		refreshTalentTimer = nil
	end
end

function mod:StartRefreshTalentTimer()
	if(refreshTalentTimer == nil) then
		refreshTalentTimer = mod:ScheduleRepeatingTimer("OnUpdateTalentTimer", REFRESH_TALENT_TIME)
	end
end

function mod:OnUpdateTalentTimer()
	self:CheckForNeededTalents()
end

function mod:CheckForNeededTalents()
	for guid, r in pairs(roster) do
		local tryAgain = false
		--look for people who were not able to be scanned before and queue them up again as needed
		--note that LibTalentQuery won't let us add an identical queue name. So this is currently perfectly safe
		--to add the same name a million times over if it already exists in the queue

		if UnitIsConnected(r.unit) and UnitIsVisible(r.unit) then
			--if they were previously marked as unable to inspect, then try again
			if cantinspect[guid] then
				tryAgain = true
			end
		else
			--mark the player as unable to inspect due to connection or range
			--we'll want to update them when we can because who knows what they
			--did with their spec while out of range
			cantinspect[guid] = true
		end
		
		--now just look for anyone without a spec
		if not r.specs and not cantinspect[guid] then
			tryAgain = true
		end
		
		if tryAgain then
			self:QueueTalentQuery(r.unit)
		end
	end
end

function mod:UpdateRosterChanges()
	local prefix = "none"
	local members = nil
	--only support raid and party, no BG's
	if (GetNumRaidMembers() > 0) then
		--player in raid
		prefix = "raid"
		members = GetNumRaidMembers()
	elseif (GetNumPartyMembers() > 0) then
		--player in party
		prefix = "party"
		members = GetNumPartyMembers()
	end
	
	--first mark everyone as not active
	for guid, r in pairs(roster) do
		r.active = nil
	end
	
	--now loop through the roster if we're in a raid or party
	if prefix ~= "none" then
		for i = 1, members do
			local unit = prefix..tostring(i)
			local guid = UnitGUID(unit)
			if guid then
				local r = roster[guid]
				if not r then
					--new player
					r = {
						name = UnitName(unit),
						class = select(2, UnitClass(unit)),
						requery = 1,
					}
					--add to roster
					roster[guid] = r
					cantinspect[guid] = nil --make sure they're still not in the cantinspect queue
				end
				--always update these values
				r.level = UnitLevel(unit)
				r.unit = unit
				r.active = 1
			end
		end
	end
	
	--special handling for party situations since player isn't a part of the party by default (but they are in raids)
	if prefix == "party" then
		--make sure we add ourselves if in a party
		local guid = UnitGUID("player")
		local r = roster[guid]
		if not r then
			--add ourselves to the roster
			r = {
				name = UnitName("player"),
				class = select(2, UnitClass("player")),
				requery = 1,
			}
			--add to roster
			roster[guid] = r
			cantinspect[guid] = nil --make sure they're still not in the cantinspect queue
		end
		--always update these values
		r.level = UnitLevel("player")
		r.unit = "player"
		r.active = 1
	end
	
	--remove inactive members
	for guid, r in pairs(roster) do
		if not r.active then
			roster[guid] = nil
			cantinspect[guid] = nil --make sure they're still not in the cantinspect queue
			onremove(guid, unit, r.name)
		end
	end
	
	--requery players who need it, don't worry about UNKNOWN names though, we'll handle those when UNIT_NAME_UPDATE gets called
	for guid, r in pairs(roster) do
		if r.requery and r.name ~= UNKNOWN then
			mod:QueueTalentQuery(r.unit)
		end
	end
end

function mod:QueueTalentQuery(unit)
	if unit then
		if (UnitInRaid(unit) or UnitInParty(unit)) and UnitIsConnected(unit) then
			LTQ:Query(unit)
		else
			local guid = UnitGUID(unit)
			if guid then
				cantinspect[guid] = true
			end
		end
	end
end

function mod:TalentQuery_Ready(e, name, realm, unit)
	self:StoreClassTalents(unit)

	local guid = UnitGUID(unit)
	
	if not guid then
		return
	end
	
	local r = roster[guid]
	
	if not r then
		return
	end
	
	--drop the player from the can't inspect queue if it exists
	cantinspect[guid] = nil
	
	local isnotplayer = not UnitIsUnit(unit, "player")

	--remember the old talents as a string for comparison later
	local oldvalue = self:GetTalentString(r, r.activespec)
	
	if (GetTalentTabInfo(1, isnotplayer, nil, nil)) then --returns nil is less than level 10?
		r.activespec = GetActiveTalentGroup(isnotplayer) --current spec
		r.primarytree = GetPrimaryTalentTree(isnotplayer, nil, nil)
		local totalSpecs = GetNumTalentGroups(isnotplayer) --dual spec or not
		local specs = {}
		for spec = 1, totalSpecs do
			local numTabs = GetNumTalentTabs(isnotplayer) -- should be 3
			local data = {
				rank = {},
				tree = {},
			}
			for tab = 1, numTabs do
				for i = 1, GetNumTalents(tab, isnotplayer) do
					local _, _, _, _, rank, _ = GetTalentInfo(tab, i, isnotplayer, nil, spec)
					tinsert(data.rank, rank)
					tinsert(data.tree, tab)
				end
			end
			tinsert(specs, data)
		end
		
		--free memory, it's a large table potentially
		if r.specs then
			wipe(r.specs)
		end
		
		--update the table
		r.specs = specs
		
		--get the new talents as a string
		local newvalue = self:GetTalentString(r, r.activespec)
		
		--if the talents changed, then we need to send a notification
		if oldvalue ~= newvalue then
			onupdate(guid, unit, name)
		end
	end
end

function mod:GetTalentString(r, specindex)
	if not r.specs then return nil end
	local spec = r.specs[specindex]
	
	local result = ""
	local lastTree = 1
	for index, tree in ipairs(spec.tree) do -- loop through tabs
		if tree ~= lastTree then
			result = string.format("%s|", result)
		end
		result = string.format("%s%s", result, spec.rank[index])
		lastTree = tree
	end
	
	return result
end

function mod:TalentQuery_Ready_Outsider(e, name, realm, unit)
	--self:TalentQuery_Ready(e, name, realm, unit)
end

function mod:StoreClassTalents(unit)
	
	if not dbg.classes then
		dbg.classes = {}
	end
	local isnotplayer = not UnitIsUnit("player", unit)
	if GetNumTalentTabs(isnotplayer) > 0 then --will return zero if less than level 10?
		local _, class = UnitClass(unit)
		if class then
			--only update data if we don't already have it
			if not dbg.classes[class] then
				dbg.classes[class] = {
					trees = {},
					tree = {},
					name = {},
					rank = {},
				}
				local dbclass = dbg.classes[class]
				
				for tab = 1, GetNumTalentTabs(isnotplayer, nil) do
					local treeName = select(2, GetTalentTabInfo(tab, isnotplayer, nil, nil))
					tinsert(dbclass.trees, treeName)
					for i = 1, GetNumTalents(tab, isnotplayer) do
						local name, _, _, _, _, maxrank = GetTalentInfo(tab, i, isnotplayer, nil, nil)
						if name then --bug fix, mage arcane talent tree returns nil at index 15 for name and it throws everything out of sync (inserting nil in name table but not teh other two)
							tinsert(dbclass.tree, tab)
							tinsert(dbclass.name, name)
							tinsert(dbclass.rank, maxrank)
						end
					end
				end
				onclasstalentsupdated(class)
			end
		end
	end
end

function mod:SetOnUpdate(func)
	onupdate = func
end

function mod:SetOnRemove(func)
	onremove = func
end

function mod:SetOnClassTalentsUpdated(func)
	onclasstalentsupdated = func
end

function mod:GetUnitTalentRank(unit, talent)
	local guid = UnitGUID(unit)
	
	if not guid then
		return
	end
	
	local r = roster[guid]
	if not r then
		return
	end

	local spec = r.specs[r.activespec]
	
	if spec then
		--search through all the talent names until we find the one that matches
		local class = dbg.classes[r.class]
		if class then
			for index, name in ipairs(class.name) do
				if name == talent then
					--we found a matching talent name, now we know the index we can use that for the actual player rank
					return spec.rank[index]
				end
			end
		end
	end
end

function mod:GetUnitPrimaryTree(unit)
	local guid = UnitGUID(unit)
	
	if not guid then
		return
	end
	
	local r = roster[guid]
	if not r then
		return
	end

	local class = dbg.classes[r.class]
	if class then
		return class.trees[r.primarytree]
	end
end






