--[[
Name: LibTalentQuery-1.0
Revision: $Rev: 86 $
Author: Rich Martel (richmartel@gmail.com)
Documentation: http://wowace.com/wiki/LibTalentQuery-1.0
SVN: svn://svn.wowace.com/wow/libtalentquery-1-0/mainline/trunk
Description: Library to help with querying unit talents
Dependancies: LibStub, CallbackHandler-1.0
License: LGPL v2.1

Example Usage:
	local TalentQuery = LibStub:GetLibrary("LibTalentQuery-1.0")
	TalentQuery.RegisterCallback(self, "TalentQuery_Ready")

	local raidTalents = {}
	...
	TalentQuery:Query(unit)
	...
	function MyAddon:TalentQuery_Ready(e, name, realm, unitid)
		local isnotplayer = not UnitIsUnit(unitid, "player")
		local spec = {}
		for tab = 1, GetNumTalentTabs(isnotplayer) do
			local _, _, _, _, _, pointsspent = GetTalentTabInfo(tab, isnotplayer)
			tinsert(spec, pointsspent)
		end
		raidTalents[UnitGUID(unitid)] = spec
	end
]]

local MAJOR, MINOR = "LibTalentQuery-1.0", 90000 + tonumber(("$Rev: 86 $"):match("(%d+)"))

local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

local INSPECTDELAY = 2
local INSPECTTIMEOUT = 5
if not lib.events then
	lib.events = LibStub("CallbackHandler-1.0"):New(lib)
end

local enteredWorld = IsLoggedIn()
local frame = lib.frame
if not frame then
	frame = CreateFrame("Frame", MAJOR .. "_Frame")
	lib.frame = frame
end
frame:UnregisterAllEvents()
frame:RegisterEvent("INSPECT_READY")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_LEAVING_WORLD")
frame:SetScript("OnEvent", function(this, event, ...)
	return lib[event](lib, ...)
end)

do
	local lastUpdateTime = 0
	frame:SetScript("OnUpdate", function(this, elapsed)
		lastUpdateTime = lastUpdateTime + elapsed
		if lastUpdateTime > INSPECTDELAY then
			lib:CheckInspectQueue()
			lastUpdateTime = 0
		end
	end)
	frame:Hide()
end

local inspectQueue = lib.inspectQueue or {}
lib.inspectQueue = inspectQueue
local garbageQueue = lib.garbageQueue or {}	-- Added a second queue to things. Inspects that initially fail are now
lib.garbageQueue = garbageQueue				-- thrown into second queue will will be processed once main queue is empty

if next(inspectQueue) then
	frame:Show()
end

local UnitIsPlayer = _G.UnitIsPlayer
local UnitName = _G.UnitName
local UnitExists = _G.UnitExists
local UnitGUID = _G.UnitGUID
local GetNumRaidMembers = _G.GetNumRaidMembers
local GetNumPartyMembers = _G.GetNumPartyMembers
local UnitIsVisible = _G.UnitIsVisible
local UnitIsConnected = _G.UnitIsConnected
local UnitCanAttack = _G.UnitCanAttack
local CanInspect = _G.CanInspect

local function UnitFullName(unit)
	local name, realm = UnitName(unit)
	local namerealm = realm and realm ~= "" and name .. "-" .. realm or name
	return namerealm
end

-- GuidToUnitID
local function GuidToUnitID(guid)
	local prefix, min, max = "raid", 1, GetNumRaidMembers()
	if max == 0 then
		prefix, min, max = "party", 0, GetNumPartyMembers()
	end

	-- Prioritise getting direct units first because other players targets
	-- can change between notify and event which can bugger things up
	for i = min, max do
		local unit = i == 0 and "player" or prefix .. i
		if (UnitGUID(unit) == guid) then
			return unit
		end
	end

	-- This properly detects target units
	if (UnitGUID("target") == guid) then
        return "target"
	elseif (UnitGUID("focus") == guid) then
		return "focus"
	elseif (UnitGUID("mouseover") == guid) then
		return "mouseover"
    end

	for i = min, max + 3 do
		local unit
		if i == 0 then
			unit = "player"
		elseif i == max + 1 then
			unit = "target"
		elseif i == max + 2 then
			unit = "focus"
		elseif i == max + 3 then
			unit = "mouseover"
		else
			unit = prefix .. i
		end
		if (UnitGUID(unit .. "target") == guid) then
			return unit .. "target"
		elseif (i <= max and UnitGUID(unit.."pettarget") == guid) then
			return unit .. "pettarget"
		end
	end
	return nil
end

-- Query
function lib:Query(unit)
	if (UnitLevel(unit) < 10 or UnitName(unit) == UNKNOWN) then
		return
	end

	self.lastQueuedInspectReceived = nil
	if UnitIsUnit(unit, "player") then
		self.events:Fire("TalentQuery_Ready", UnitName("player"), nil, "player", UnitGUID("player"))
	else
		if type(unit) ~= "string" then
			error(("Bad argument #2 to 'Query'. Expected %q, received %q (%s)"):format("string", type(unit), tostring(unit)), 2)
		elseif not UnitExists(unit) or not UnitIsPlayer(unit) then
			error(("Bad argument #2 to 'Query'. %q is not a valid player unit"):format(tostring(unit)), 2)
		else
			local name = UnitFullName(unit)
			if (not inspectQueue[name]) then
				inspectQueue[name] = UnitGUID(unit)
				garbageQueue[name] = nil
			end
			frame:Show()
		end
	end
end

-- CheckInspectQueue
-- Originally, it would wait until no pending NotifyInspect() were expected, and then do its own.
-- It was also only bother looking at ready results if it had triggered the Notify for that occasion.
-- For the changes I've done, no assumption is made about which mod is performing NotifyInspect().
-- We note the name, unit, time of any inspects done whether from this queue or any other source,
-- we remove from our queue any we were expecting, and use a seperate event in case extra talent
-- info is any time wanted (opportunistic refreshes etc) - Zeksie, 20th May 2009
function lib:CheckInspectQueue()
	if (_G.InspectFrame and _G.InspectFrame:IsShown()) then
		return
	end

	if (not self.lastInspectTime or self.lastInspectTime < GetTime() - INSPECTTIMEOUT) then
		self.lastInspectPending = 0
	end

	if (self.lastInspectPending > 0 or not enteredWorld) then
		return
	end

	if (self.lastQueuedInspectReceived and self.lastQueuedInspectReceived < GetTime() - 60) then
		-- No queued results received for a minute, so purge the queue as invalid and move on with our lives
		self.lastQueuedInspectReceived = nil
		inspectQueue = {}
		lib.inspectQueue = inspectQueue
		garbageQueue = {}
		lib.garbageQueue = garbageQueue
		frame:Hide()
		return
	end

	for name,guid in pairs(inspectQueue) do
		local unit = GuidToUnitID(guid)
		if (not unit) then
			inspectQueue[name] = nil
		else
			if (UnitIsVisible(unit) and UnitIsConnected(unit) and not UnitCanAttack("player", unit) and not UnitCanAttack(unit, "player") and CanInspect(unit) and UnitClass(unit)) then
				NotifyInspect(unit)
				break
			else
				garbageQueue[name] = guid	-- Not available, throw into secondary queue and continue
				inspectQueue[name] = nil
			end
		end
	end

	if (not next(inspectQueue)) then
		if (next(garbageQueue)) then
			-- Retry initially failed inspects
			lib.inspectQueue = garbageQueue
			inspectQueue = lib.inspectQueue
			lib.garbageQueue = {}
			garbageQueue = lib.garbageQueue
		else
			frame:Hide()
		end
	end
end

-- NotifyInspect
if not lib.NotifyInspect then -- don't hook twice
	hooksecurefunc("NotifyInspect", function(...) return lib:NotifyInspect(...) end)
end
function lib:NotifyInspect(unit)
	if (not (UnitExists(unit) and UnitIsVisible(unit) and UnitIsConnected(unit) and CheckInteractDistance(unit, 4))) then
		return
	end
	self.lastInspectTime = GetTime()
	self.lastInspectPending = self.lastInspectPending + 1
end

-- Reset
function lib:Reset()
	self.lastInspectPending = 0
	self.lastInspectTime = nil
end

-- INSPECT_READY
function lib:INSPECT_READY(guid)
	self.lastInspectPending = self.lastInspectPending - 1

	local unit = GuidToUnitID(guid)
	local name = unit and UnitFullName(unit) or nil
	if unit and name then
		local shortname, realm = UnitName(unit)
		local isnotplayer = not UnitIsUnit("player", unit)
		local group = GetActiveTalentGroup(isnotplayer)
		local _, _, _, _, spent1 = GetTalentTabInfo(1, isnotplayer, nil, group)
		local _, _, _, _, spent2 = GetTalentTabInfo(2, isnotplayer, nil, group)
		local _, _, _, _, spent3 = GetTalentTabInfo(3, isnotplayer, nil, group)
		if ((spent1 or 0) + (spent2 or 0) + (spent3 or 0) > 0) then
			if inspectQueue[name] then
				inspectQueue[name] = nil
				self.lastQueuedInspectReceived = GetTime()
				self.events:Fire("TalentQuery_Ready", shortname, realm, unit, guid)
			else
				self.events:Fire("TalentQuery_Ready_Outsider", shortname, realm, unit, guid)
			end
		elseif inspectQueue[name] then -- we got back a bad result, put it in the garbageQueue to try again
			garbageQueue[name] = guid
		end  -- if none of the above conditions were met, we got a bad result for someone not in our queue, so just ignore it
	end

	if self.lastInspectPending == 0 then
		self:Reset()
		self:CheckInspectQueue()
	end
end

function lib:PLAYER_ENTERING_WORLD()
	-- We can't inspect other's talents until now
	-- We just get 0/0/0 back even though we get an INSPECT_READY event
	enteredWorld = true
end

function lib:PLAYER_LEAVING_WORLD()
	enteredWorld = nil
end

lib:Reset()
