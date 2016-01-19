------------------------------------------------------------
-- Core.lua
--
-- Abin
-- 2012/1/03
------------------------------------------------------------

local _G = _G
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local tostring = tostring
local tonumber = tonumber
local type = type
local format = format
local pcall = pcall
local wipe = wipe
local pairs = pairs
local InCombatLockdown = InCombatLockdown
local select = select
local tinsert = tinsert
local ipairs = ipairs
local tremove = tremove
local GetRealmName = GetRealmName
local UnitName = UnitName
local GetActiveSpecGroup = GetActiveSpecGroup
local GetNumGroupMembers = GetNumGroupMembers
local IsInRaid = IsInRaid
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsRaidOfficer = UnitIsRaidOfficer
local _

local addonName, addon = ...
_G["CompactRaid"] = addon
addon.version = GetAddOnMetadata(addonName, "Version") or "3.0"
addon.numericVersion = tonumber(addon.version) or 3.0
addon.name = "CompactRaid"

addon.db = {}
addon.chardb = {}

local L = addon.L

function addon:Print(msg, r, g, b)
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff78CompactRaid:|r "..tostring(msg), r or 0.5, g or 0.75, b or 1)
end

function addon:CheckVersion(version, errorTitle)
	if type(version) == "string" then
		version = tonumber(version)
	end

	if type(version) ~= "number" or version <= addon.numericVersion then
		return 1 -- Passed
	end

	if errorTitle then
		addon:Print(format(L["version error"], tostring(errorTitle), tostring(version), addon.version), 1, 0, 0)
	end
end

function addon:IsDebugMode()
	return self.db.debugmode
end

function addon:SetDebugMode(debug)
	self.db.debugmode = debug and 1 or nil
	if addon:IsDebugMode() then
		addon:Print(L["debug mode"].."  |cffff0000ON|r")
	else
		addon:Print(L["debug mode"].." |cff00ff00OFF|r")
	end
end

function addon:pcall(func, ...)
	if addon:IsDebugMode() then
		-- debug mode: captures errors normally
		func(...)
		return 1
	else
		-- release mode: prints errors on ChatFrame1 and let go
		local valid, err = pcall(func, ...)
		if not valid then
			self:Print(err, 1, 0, 0)
		end
		return valid, err
	end
end

function addon._EnumFrames(list, object, func, ...)
	local enumType
	if type(object) == "function" then
		enumType = 1 -- Direct call
	elseif type(object) == "table" and type(func) == "string" then
		enumType = 2 -- Call the object's member method, object:func(frame, ...)
	elseif type(object) == "string" then
		enumType = 3 -- Call frame method, frame:func(...)
	end

	local count = 0
	local frame
	for _, frame in pairs(list) do
		count = count + 1
		if enumType == 1 then
			object(frame, func, ...)
		elseif enumType == 2 then
			object[func](object, frame, ...)
		elseif enumType == 3 then
			frame[object](frame, func, ...)
		end
	end

	return count
end

local initDone
function addon:Initialized()
	return initDone
end

function addon:GetGroupStats()
	local num = GetNumGroupMembers()
	local group, leadship
	if IsInRaid() then
		group = "raid"
		if UnitIsGroupLeader("player") then
			leadship = "leader"
		elseif UnitIsRaidOfficer("player") then
			leadship = "officer"
		end
	elseif num > 0 then
		group = "party"
		if UnitIsGroupLeader("player") then
			leadship = "leader"
		end
	end

	return group, leadship, num
end

function addon:GetCurProfileName()
	local name = UnitName("player")
	local realm = GetRealmName()
	if name and realm then
		return name.." - "..realm
	end
end

------------------------------------------------------------
-- Internal event process
------------------------------------------------------------

local dbOldVer = 0
local chardbOldVer = 0

function addon:GetOriginalVersion(char)
	if char then
		return dbOldVer
	else
		return chardbOldVer
	end
end

EmbedEventObject(addon)
addon:RegisterEvent("ADDON_LOADED")

local profileName

local function InitProfile(profiles)
	profileName = addon:GetCurProfileName()
	if not profileName then
		return
	end

	if type(profiles[profileName]) ~= "table" then
		if type(CompactRaidCharDB) == "table" then
			profiles[profileName] = addon:CloneTable(CompactRaidCharDB)
			CompactRaidCharDB = nil
		else
			profiles[profileName] = {}
		end
	end

	addon.chardb = profiles[profileName]

	chardbOldVer = tonumber(addon.chardb.version or 0) or 0
	addon.chardb.version = addon.numericVersion

	if type(addon.chardb.modules) ~= "table" then
		addon.chardb.modules = {}
	end
end

function addon:ADDON_LOADED(arg1)
	if arg1 ~= addonName then
		return
	end

	if type(CompactRaidDB) ~= "table" then
		CompactRaidDB = {}
	end
	self.db = CompactRaidDB

	if type(self.db.profiles) ~= "table" then
		self.db.profiles = {}
	end

	InitProfile(self.db.profiles)

	dbOldVer = tonumber(self.db.version or 0) or 0
	self.db.version = addon.numericVersion

	if type(self.db.modules) ~= "table" then
		self.db.modules = {}
	end

	self:RegisterEvent("PLAYER_LOGIN")

	-- Sometimes funny things happen that GetRealmName and UnitName aren't accessable until PLAYER_LOGIN fires
	if profileName then
		initDone = 1
		self:BroadcastEvent("OnInitialize", self.db, self.chardb)
	end

	self:Print(format(L["load prompt"], self.version))
	if self:IsDebugMode() then
		self:Print(L["debug mode"].."  |cffff0000ON|r")
	end
end

function addon:PLAYER_LOGIN()
	if not profileName then
		InitProfile(self.db.profiles)
		initDone = 1
		self:BroadcastEvent("OnInitialize", self.db, self.chardb)
	end

	self:BroadcastEvent("OnPlayerLogin", self.db, self.chardb)
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_LOGOUT")
end

function addon:PLAYER_LOGOUT()
	self:BroadcastEvent("OnPlayerLogout", self.db, self.chardb)
end

function addon:ACTIVE_TALENT_GROUP_CHANGED()
	self:BroadcastEvent("OnTalentSwitch", GetActiveSpecGroup())
end

function addon:PLAYER_REGEN_ENABLED()
	self:BroadcastEvent("OnLeaveCombat")
end

function addon:PLAYER_REGEN_DISABLED()
	self:BroadcastEvent("OnEnterCombat")
end