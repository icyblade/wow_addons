--[[
]]--
local AddonName, Hermes = ...

local LIB_AceAddon = LibStub("AceAddon-3.0") or error("Required library AceAddon-3.0 not found")
_G[AddonName] = LIB_AceAddon:NewAddon(Hermes, AddonName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0")
local L = LibStub('AceLocale-3.0'):GetLocale('Hermes')
local LIB_AceConfigRegistry = LibStub("AceConfigRegistry-3.0") or error("Required library AceConfigRegistry-3.0 not found")
local LIB_AceConfig = LibStub("AceConfig-3.0") or error("Required library AceConfig-3.0 not found")
local LIB_AceDB = LibStub("AceDB-3.0") or error("Required library AceDB-3.0 not found")
local LIB_AceConfigDialog = LibStub("AceConfigDialog-3.0")  or error("Required library AceConfigDialog-3.0 not found")
local LIB_LibSharedMedia = LibStub("LibSharedMedia-3.0") or error("Required library LibSharedMedia-3.0 not found")
local HERMES_VERSION = GetAddOnMetadata(AddonName, "X-Curse-Packaged-Version") or "(dev)"
local HERMES_VERSION_STRING = AddonName.." "..HERMES_VERSION
Hermes.HERMES_VERSION_STRING = HERMES_VERSION_STRING

--global to local performance improvements
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local GetTime = GetTime
local ceil, abs, format = ceil, abs, format
local tinsert, tremove, pairs, ipairs, wipe, type, tonumber, sort, tostring = tinsert, tremove, pairs, ipairs, wipe, type, tonumber, sort, tostring
local GetInventorySlotInfo, GetInventoryItemID, GetInventoryItemCooldown, GetItemCooldown = GetInventorySlotInfo, GetInventoryItemID, GetInventoryItemCooldown, GetItemCooldown
local GetNumRaidMembers, GetNumPartyMembers = GetNumRaidMembers, GetNumPartyMembers
local UnitIsVisible, UnitInRaid, GetRaidRosterInfo, UnitIsConnected, UnitInParty, UnitIsDead, UnitIsGhost, UnitClass, UnitLevel, UnitRace = UnitIsVisible, UnitInRaid, GetRaidRosterInfo, UnitIsConnected, UnitInParty, UnitIsDead, UnitIsGhost, UnitClass, UnitLevel, UnitRace
local FindSpellBookSlotBySpellID, GetSpellBookItemInfo, GetItemInfo, GetItemIcon, GetSpellInfo = FindSpellBookSlotBySpellID, GetSpellBookItemInfo, GetItemInfo, GetItemIcon, GetSpellInfo
local GetPlayerInfoByGUID = GetPlayerInfoByGUID

--default all modules to disabled
Hermes:SetDefaultModuleState(false)
local MOD_Reincarnation = nil
local MOD_Talents = nil

local dbp

local core = {}

local Player = {}
local Senders = {}
local Abilities = {}
local AbilityInstances = {}
local Plugins = {}
local Events = {}
local Players = {}						-- used while monitoring combat log to keep track of all player abilities

local INVALIDATE_TIME_THRESHOLD = 2		-- number of seconds to use in determining whether saved values using GetTime() are no longer reliable

local PLAYER_IS_WARLOCK = false

local REQUIREMENT_KEYS = {
	--note that class isn't a requirement because it's specified by the spell
	PLAYER_LEVEL	= 10,
	PLAYER_NAMES	= 15,
	PLAYER_RACE		= 20,
	TALENT_NAME		= 25,
	TALENT_SPEC		= 30,
}

local REQUIREMENT_VALUES = {
	["PLAYER_LEVEL"]	= L["Player Level"],
	["PLAYER_RACE"]		= L["Player Race"],
	["PLAYER_NAMES"]	= L["Player Names"],
	["TALENT_NAME"]		= L["Talent Name"],
	["TALENT_SPEC"]		= L["Talent Spec"],
}

local ADJUSTMENT_KEYS = {
	PLAYER_NAME		= 5,
	PLAYER_LEVEL	= 10,
	TALENT_NAME		= 25,
	TALENT_SPEC		= 30,
}

local ADJUSTMENT_VALUES = {
	["PLAYER_NAME"]		= L["Player Name"],
	["PLAYER_LEVEL"]	= L["Player Level"],
	["TALENT_NAME"]		= L["Talent Name"],
	["TALENT_SPEC"]		= L["Talent Spec"],
}

local SCAN_FREQUENCY = 0.06
local DELTA_THRESHOLD_FOR_REMAINING_CHANGE = 3

local MAX_PLAYER_LEVEL = GetMaxPlayerLevel()
local MAX_TALENT_RANK = 5
local SPELL_AUTOSET_THRESHOLD = 30		-- ignore any cooldowns happening earlier than this many seconds from the time the sender registered itself

--local independent class lookup, used mostly to keep message size down when sending messages.
local CLASS_ENUM = {
	[1]		= "ANY",
	[2]		= "DEATHKNIGHT",
	[3]		= "DRUID",
	[4]		= "HUNTER",
	[5]		= "MAGE",
	[6]		= "PALADIN",
	[7]		= "PRIEST",
	[8]		= "ROGUE",
	[9]		= "SHAMAN",
	[10]	= "WARLOCK",
	[11]	= "WARRIOR",
}

local MESSAGE_ENUM = {
	[1]		= "INITIALIZE_SENDER",
	[2]		= "INITIALIZE_RECEIVER",
	[3]		= "REQUEST_SPELLS",
	[4]		= "UPDATE_SPELLS",
}

local HERMES_SEND_COMM = "HermesS1"
local HERMES_RECEIVE_COMM = "HermesR1"

local Sender = nil
local Receiving = false

local ITEM_NAME_TIMER = nil
local ITEM_NAME_THROTTLE = 20									--how often to scan server for itme name info, three times a minute currently

local COOLDOWN_SCAN_TIMER = nil
local COOLDOWN_SCAN_FREQUENCY_INITIAL = 10						--Used the throttle oneself when first starting up sending.
																--This is to allow time for all the receivers in the raid to request their spells.
																--This results in fewer SPELL_UPDATES being sent when first starting up
local COOLDOWN_SCAN_FREQUENCY = 1
local COOLDOWN_DELTA_THRESHOLD = COOLDOWN_SCAN_FREQUENCY * 5	--used to avoid sending messages for cooldowns that have expired normally
																--and used to determine whether cooldowns have decreased unexpectedly
																--(such as from tier set bonusus or anything else that might reduce a cooldown)
local ITEM_NOT_IN_IVENTORY_OR_EQUIPPED = -50000				--arbritrary value to indicate when a sender doesn't have an item

local LOCALIZED_CLASS_NAMES = {}
FillLocalizedClassList(LOCALIZED_CLASS_NAMES)

--specila handling for soulstone
local SPELLID_SOULSTONERESURRECTION = 20707
local SPELLID_SOULSTONERESURRECTION_WHENDEAD = 95750
local ITEMID_SOULSTONE = -5232
local STARTTIME_SOULSTONERESURRECTION = nil

local DEFAULT_SPELLS = {
	{"ANY",			59752,	nil},					--Every Man for Himself
	{"ANY",			20594,	nil},					--Stoneform: this is the spell in the spellbook
	--{"ANY",			65116,	nil},				--Stoneform: this is the buff spell effect
	
	{"DRUID",		22812,	nil},					--Barkskin
	{"DRUID",		22842,	nil},					--Frenzied Regeneration
	{"DRUID",		29166,	nil},					--Innervate
	{"DRUID",		20484,	nil},					--Rebirth
	{"DRUID",		61336,	nil},					--Survival Instincts
	{"DRUID",		740,	nil},					--Tranquility
	{"DRUID",		33891,	nil},					--Tree of Life
	{"DRUID",		5211,	nil},					--Bash				--new
	
	{"HUNTER",		34477,	nil},					--Misdirection
	
	{"MAGE",		45438,	nil},					--Ice Block
	{"MAGE",		31687,	nil},					--Summon Water Elemental
	{"MAGE",		80353,	nil},					--Time Warp
	{"MAGE",		2139,	nil},					--Counterspell		--new
	
	{"PALADIN",		31850,	nil},					--Ardent Defender
	{"PALADIN",		31821,	nil},					--Aura Mastery
	{"PALADIN",		70940,	nil},					--Divine Guardian
	{"PALADIN",		498,	nil},					--Divine Protection
	{"PALADIN",		642,	nil},					--Divine Shield
	{"PALADIN",		1044,	nil},					--Hand of Freedom
	{"PALADIN",		1022,	nil},					--Hand of Protection
	{"PALADIN",		6940,	nil},					--Hand of Sacrifice
	{"PALADIN",		1038,	nil},					--Hand of Salvation
	{"PALADIN",		633,	nil},					--Lay on Hands
	{"PALADIN",		20066,	nil},					--Repentance
	{"PALADIN",		86150,	nil},					--Guardian of Ancient Kings
	{"PALADIN",		96231,	nil},					--Rebuke				--new
	{"PALADIN",		853,	nil},					--Hammer of Justice		--new
	
	{"PRIEST",		64843,	nil},					--Divine Hymn
	{"PRIEST",		47788,	nil},					--Guardian Spirit
	{"PRIEST",		64901,	nil},					--Hymn of Hope
	{"PRIEST",		33206,	nil},					--Pain Suppression
	{"PRIEST",		73325,	nil},					--Leap of Faith
	{"PRIEST",		62618,	nil},					--Power Word:Barrier
	
	{"ROGUE",		2094,	nil},					--Blind
	{"ROGUE",		31224,	nil},					--Cloak of Shadows
	{"ROGUE",		57934,	nil},					--Tricks of the Trade
	{"ROGUE",		1766,	nil},					--Kick					--new
	
	{"SHAMAN",		2825,	"Horde"},				--Bloodlust
	{"SHAMAN",		32182,	"Alliance"},			--Heroism
	{"SHAMAN",		20608,	nil},					--Reincarnation
	{"SHAMAN",		16190,	nil},					--Mana Tide Totem
	{"SHAMAN",		98008,	nil},					--Spirit Link Totem
	{"SHAMAN",		57994,	nil},					--Wind Shear			--new
	
	{"WARLOCK",		698,	nil},					--Ritual of Summoning
	{"WARLOCK",		29893,	nil},					--Ritual of Souls
	{"WARLOCK",		20707,	nil},					--Soulstone Resurrection
	
	{"WARRIOR",		1161,	nil},					--Challenging Shout
	{"WARRIOR",		871,	nil},					--Shield Wall
	{"WARRIOR",		64382,	nil},					--Shattering Throw
	{"WARRIOR",		12975,	nil},					--Last Stand
	{"WARRIOR",		97462,	nil},					--Rallying Cry
	{"WARRIOR",		6552,	nil},					--Pummel				--new
	
	{"DEATHKNIGHT",	49576,	nil},					--Death Grip
	{"DEATHKNIGHT",	48792,	nil},					--Icebound Fortitude
	{"DEATHKNIGHT",	48707,	nil},					--Anti-Magic Shell
	{"DEATHKNIGHT",	61999,	nil},					--Raise Ally
	{"DEATHKNIGHT",	42650,	nil},					--Army of the Dead
	{"DEATHKNIGHT",	49222,	nil},					--Bone Shield
	{"DEATHKNIGHT",	55233,	nil},					--Vampiric Blood
	{"DEATHKNIGHT",	46584,	nil},					--Raise Dead
	{"DEATHKNIGHT",	51052,	nil},					--Anti-Magic Zone
	{"DEATHKNIGHT",	47528,	nil},					--Mind Freeze			--new
	{"DEATHKNIGHT",	47476,	nil},					--Strangulate			--new
}

local DEFAULT_ITEMS = {
	{"ANY",		62471,	"Alliance"},				--Mirror of Broken Images
	{"ANY",		62466,	"Horde"},					--Mirror of Broken Images
}

local EQUIPPABLE_SLOTS = {
	"AmmoSlot",
	"BackSlot",
	"ChestSlot",
	"FeetSlot",
	"Finger0Slot",
	"Finger1Slot",
	"HandsSlot",
	"HeadSlot",
	"LegsSlot",
	"MainHandSlot",
	"NeckSlot",
	"RangedSlot",
	"SecondaryHandSlot",
	"ShirtSlot",
	"ShoulderSlot",
	"TabardSlot",
	"Trinket0Slot",
	"Trinket1Slot",
	"WaistSlot",
	"WristSlot",
}

local SHARED_COOLDOWNS = {
	--this table holds cooldowns for abilities that are shared with other abilities such as Last Stand and Rallying Cry.
	--It's only needed for Spell Monitor users so only used with VirtualInstances
	[12975] = 97462,	--Last Stand			-->		Rallying Cry
	[97462] = 12975,	--Rallying Cry			-->		Last Stand
}

local COMBAT_LOGGING_INSTRUCTIONS = L["COMBAT_LOGGING_INSTRUCTIONS"]

local function _tableIndex(tbl, item)
	for index, i in ipairs(tbl) do
		if(i == item) then
			return index
		end
	end

	return nil
end

local function _deleteIndexedTable(tbl, item)
	local index = _tableIndex(tbl, item) 
	if not index then error("failed to locate item in table") end
	tremove(tbl, index)
end

local function _deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

local function _tableCount(tbl)
	local cnt = 0
	for k, v in pairs(tbl) do
		cnt = cnt + 1
	end
	return cnt
end

local function _tableMerge(t1, t2)
	for k,v in pairs(t2) do
		if type(v) == "table" then
			if type(t1[k] or false) == "table" then
				_tableMerge(t1[k] or {}, t2[k] or {})
			else
				t1[k] = v
			end
		else
			t1[k] = v
		end
	end
	return t1
end

--------------------------------------------------------------------
-- API
--------------------------------------------------------------------
function Hermes:RegisterHermesPlugin(name, OnEnableCallback, OnDisableCallback, OnSetProfileCallback, OnGetBlizzOptionsTable)
	--make sure that plugins table is created
	if not name then
		error("plugin name cannot be nil")
	end
	
	--check to make sure it's not already registered
	if Plugins[name] then
		error("plugin already registered: "..tostring(name))
	end
	
	--update the plugin state in the profile, default is enabled
	if dbp.pluginState[name] == nil then
		dbp.pluginState[name] = true
	end
	
	--register the plugin
	Plugins[name] = {
		OnEnableCallback = OnEnableCallback,
		OnDisableCallback = OnDisableCallback,
		OnSetProfileCallback = OnSetProfileCallback,
		OnGetBlizzOptionsTable = OnGetBlizzOptionsTable,
	}
end

function Hermes:IsSenderAvailable(sender)
	--don't count visibility if sender is also player
	if Player.name ~= sender.name then
		if sender.visible and sender.online == true and sender.dead == false then
			return true
		end
	else
		--if you're here, then you're connected and in range :P
		if sender.dead == false then
			return true
		end
	end
	
	return false
end

function Hermes:GetPlayerStatus()
	return Player.name, Player.class, Player.raid, Player.party, Player.battleground
end

function Hermes:GetAbilityStats(ability)
	local min_available_time = nil
	local instances_total = 0
	local instances_oncooldown = 0
	local instances_available = 0
	local instances_unavailable = 0
	local is_available = 0
	
	for _, instance in ipairs(AbilityInstances) do
		if instance.ability == ability then
			local senderAvailable = Hermes:IsSenderAvailable(instance.sender) --does not take ability being on cooldown into account, just whether they're alive, online, and visible
			
			--set instances_total
			instances_total = instances_total + 1
			
			--instances_unavailable
			if not senderAvailable then
				instances_unavailable = instances_unavailable + 1
			end
			
			--update min_available_time, but only if the sender is available and there is a remaining time
			if senderAvailable and instance.remaining then
				if not min_available_time then
					min_available_time = instance.remaining
				else
					if instance.remaining < min_available_time then
						min_available_time = instance.remaining
					end
				end
			end
			
			if senderAvailable and not instance.remaining then
				instances_available = instances_available + 1
			end
			
			if senderAvailable and instance.remaining then
				instances_oncooldown = instances_oncooldown + 1
			end
			
		end
	end

	return min_available_time, instances_total, instances_oncooldown, instances_available, instances_unavailable
end

function Hermes:UnregisterHermesEvent(event, key)
	--check for valid key
	if not key then
		error("hermes event key cannot be nil")
	end
	
	if Events[event][key] then
		Events[event][key] = nil
	end
end

function Hermes:RegisterHermesEvent(event, key, handler)
	--check for valid key
	if not key then
		error("hermes event key cannot be nil")
	end
	
	--check for valid event
	if not Events[event] then
		error("unknown hermes event: "..tostring(event))
	end
	
	--if nil handler, act like an unregister
	if not handler then
		Hermes:UnregisterHermesEvent(event, key)
		return
	end
	
	--register the event, replaces any other registrations for the given ekey
	Events[event][key] = handler
end

function Hermes:GetClassColorRGB(class)
	local number = tonumber(class)
	if(number) then --they used the enum number
		local classColorRGB
		if(class == 1) then
			classColorRGB = RAID_CLASS_COLORS["PRIEST"] --white
		else
			classColorRGB = RAID_CLASS_COLORS[CLASS_ENUM[class]]
		end
		return classColorRGB
	else --they used the enum value
		local classColorRGB
		if(class == "ANY") then
			classColorRGB = RAID_CLASS_COLORS["PRIEST"] --white
		else
			classColorRGB = RAID_CLASS_COLORS[class]
		end
		return classColorRGB
	end
end

function Hermes:GetClassColorHEX(class)
	local number = tonumber(class)
	if(number) then --they used the enum number
		local classColorRGB
		if(class == 1) then
			classColorRGB = RAID_CLASS_COLORS["PRIEST"] --white
		else
			classColorRGB = RAID_CLASS_COLORS[CLASS_ENUM[class]]
		end
		local classColorHex = format("FF%02x%02x%02x", 
			classColorRGB.r * 255,
			classColorRGB.g * 255,
			classColorRGB.b * 255)
		return classColorHex
	else --they used the enum value
		local classColorRGB
		if(class == "ANY") then
			classColorRGB = RAID_CLASS_COLORS["PRIEST"] --white
		else
			classColorRGB = RAID_CLASS_COLORS[class]
		end
		local classColorHex = format("FF%02x%02x%02x", 
			classColorRGB.r * 255,
			classColorRGB.g * 255,
			classColorRGB.b * 255)
		return classColorHex
	end
end

function Hermes:GetClassColorString(text, class)
	return "|c"..Hermes:GetClassColorHEX(class)..text.."|r"
end

function Hermes:AbilityIdToBlizzId(id)
	if(id >= 0) then
		return id, "spell"
	elseif(id < 0) then
		return abs(id), "item"
	end
end

function Hermes:IsSending()
	return Sender ~= nil
end

function Hermes:IsReceiving()
	return Receiving
end

function Hermes:ReloadBlizzPluginOptions()
	core:BlizOptionsTable_Plugins()
end

function Hermes:GetInventoryList()
	local inventory = {}
	for _, i in ipairs(dbp.spells) do
		inventory[i.id] = i.enabled
	end
	for _, i in ipairs(dbp.items) do
		inventory[i.id] = i.enabled
	end
	
	return inventory
end

function Hermes:GetInventoryDetail(id)
	--prevent hermes lua errors from bad plugins
	if not id then
		return nil
	end
	
	local _, t = self:AbilityIdToBlizzId(id)
	
	if t == "spell" then
		for index, spell in ipairs(dbp.spells) do
			if spell.id == id then
				return spell.id, spell.name, spell.class, spell.icon, spell.enabled
			end
		end
	elseif t == "item" then
		for index, item in ipairs(dbp.items) do
			if item.id == id then
				return item.id, item.name, item.class, item.icon, item.enabled
			end
		end
	else
		error("unknown type")
	end
end

function Hermes:GetAbilityMetaDataValue(id, key)
	if dbg.spellmetadata then
		local metadata = dbg.spellmetadata[id]
		if metadata then
			return metadata[key]
		end
	end
	
	return nil
end

do
--communication
Events["OnStartSending"] = {}
Events["OnStopSending"] = {}
Events["OnStartReceiving"] = {}
Events["OnStopReceiving"] = {}
		
--senders
Events["OnSenderAdded"] = {}
Events["OnSenderRemoved"] = {}
Events["OnSenderVisibilityChanged"] = {}
Events["OnSenderOnlineChanged"] = {}
Events["OnSenderDeadChanged"] = {}
Events["OnSenderAvailabilityChanged"] = {}
		
--player
Events["OnPlayerGroupStatusChanged"] = {}
		
--abilities
Events["OnAbilityAdded"] = {}
Events["OnAbilityRemoved"] = {}
Events["OnAbilityAvailableSendersChanged"] = {}
Events["OnAbilityTotalSendersChanged"] = {}
		
--ability instances
Events["OnAbilityInstanceAdded"] = {}
Events["OnAbilityInstanceRemoved"] = {}
Events["OnAbilityInstanceStartCooldown"] = {}
Events["OnAbilityInstanceUpdateCooldown"] = {}
Events["OnAbilityInstanceStopCooldown"] = {}
Events["OnAbilityInstanceAvailabilityChanged"] = {}

--inventory
Events["OnInventorySpellAdded"] = {}
Events["OnInventoryItemAdded"] = {}
Events["OnInventorySpellRemoved"] = {}
Events["OnInventoryItemRemoved"] = {}
Events["OnInventorySpellChanged"] = {}
Events["OnInventoryItemChanged"] = {}

end
	
--------------------------------------------------------------------
-- HERMES
--------------------------------------------------------------------
local PLAYER_ENTERED_WORLD = nil
function Hermes:PLAYER_ENTERING_WORLD()				--used only for one time player initialization that has to happen after player is logged in.
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	--initialize static properties for player
	core:InitializePlayer()
	
	PLAYER_ENTERED_WORLD = true
	
	--New changes required to support patch 4.1 and RegisterAddonMessagePrefix
	--this code should be updated sometime after 4.1 ships
	if RegisterAddonMessagePrefix then
		if RegisterAddonMessagePrefix(HERMES_SEND_COMM) == false then
			--register failed for some reason
			local message = L["|cFFFF0000Hermes Warning|r"].." ".."Failed to register addon prefix: "..HERMES_SEND_COMM
			print(message)
		end
		
		if RegisterAddonMessagePrefix(HERMES_RECEIVE_COMM) == false then
			--register failed for some reason
			local message = L["|cFFFF0000Hermes Warning|r"].." ".."Failed to register addon prefix: "..HERMES_RECEIVE_COMM
			print(message)
		end
	end
	
	if(dbp.configMode == true and dbp.enabled == true) then
		--show the warning message, but only if we're not in a part or raid
		if GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0 then
			core:ShowHermesTestModeMessage()
			core:StartTestMode()
		else
			dbp.configMode = false
			core:UpdateCommunicationsStatus()
		end
	else
		core:UpdateCommunicationsStatus()
	end
end

function Hermes:RAID_ROSTER_UPDATE()
	core:UpdateCommunicationsStatus()
end

function Hermes:PARTY_MEMBERS_CHANGED()
	core:UpdateCommunicationsStatus()
end

function Hermes:ACTIVE_TALENT_GROUP_CHANGED()
	--force a hard reboot
	core:Shutdown()
	core:Startup()
end

local REINCARNATION = 20608
function core:OnReincarnationUsed(unit, name, guid)
	--don't process yourself
	if (name == Player.name) then
		return
	end
	
	local dataExists = dbg.durations[REINCARNATION]
	
	if dataExists and dataExists ~= false then
		local player = Players[guid]
		if not player then
			return
		end
		
		local duration = player.spellcache[REINCARNATION]
		if not duration then
			return
		end

		--update the cooldowns table for the player and ability
		core:SetPlayerCooldown(player, REINCARNATION, duration)

		local sender = core:FindSenderByName(name)
		local ability = core:FindTrackedAbilityById(REINCARNATION)
		if sender and sender.virtual and core:CanCreateVirtualInstance(ability) then
			core:AddVirtualInstance(player.name, player.class, REINCARNATION, duration)
		end
	end
end

--There are some spells such as Stoneform that only trigger a SPELL_AURA_APPLIED event.
--And there are some spells such as Every Man for Himself that trigger an a SPELL_AURA_APPLIED followed by a SPELL_CAST_SUCCESS event, or possibly vice vers
--This value is used to remember that we created an instance for SPELL_AURA_APPLIED and to make sure we don't fire an additonal one for a subsequent SPELL_CAST_SUCCESS
--The assumption is that since we're only allowing these two events that we'll over ever get two in a row (maybe three for SPELL_RESURRECT)
-- but once see the first one we fire the virtual instance, and we don't fire any more until we get a different spell id.
local _lastSpell = nil
local _lastPlayer = nil

local function ConvertSpellIdIfSoulstone(spellID)
	if spellID == SPELLID_SOULSTONERESURRECTION or spellID == SPELLID_SOULSTONERESURRECTION_WHENDEAD then
		return SPELLID_SOULSTONERESURRECTION
	else
		return spellID
	end
end

local is42 = tonumber((select(4, GetBuildInfo()))) > 40100
if is42 then
	function Hermes:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, _, sourceGUID, sourceName, _, _, _, _, _, _, spellID, ...)
		core:ProcessCombatLogEvent(event, sourceGUID, sourceName, spellID)
	end
else
	function Hermes:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, _, sourceGUID, sourceName, _, _, _, _, spellID, ...)
		core:ProcessCombatLogEvent(event, sourceGUID, sourceName, spellID)
	end
end

function core:ProcessCombatLogSpell(spellID, sourceGUID, sourceName, shared)
	local dataExists = dbg.durations[spellID]
	
	--this is a spell that we have an autoset value or numerical duration for
	if dataExists and dataExists ~= false then
		--find the player
		local player = Players[sourceGUID]
		
		if player then
			--see if this player qualifies for this spell, and get the duration
			local duration = player.spellcache[spellID]
			if duration then
				--update the cooldowns table for the player and ability
				core:SetPlayerCooldown(player, spellID, duration)

				local sender = core:FindSenderByName(sourceName)
				local ability = core:FindTrackedAbilityById(spellID)
				
				if sender and sender.virtual and core:CanCreateVirtualInstance(ability) then
					--prevent from adding the same spell for the same player more than once
					if _lastSpell ~= spellID or _lastPlayer ~= sourceName then
						core:AddVirtualInstance(player.name, player.class, spellID, duration)
					end
			
					--store the last spell and player captured
					if not shared then
						_lastSpell = spellID
						_lastPlayer = sourceName
					end
				end
			else
				_lastSpell = nil
				_lastPlayer = nil
			end
		else
			_lastSpell = nil
			_lastPlayer = nil
		end
	end
	
	--now process any shared cooldowns as well
	if not shared then
		--look for any shared cooldowns and add that if necessary too
		local sharedId = SHARED_COOLDOWNS[spellID]
		if sharedId then
			core:ProcessCombatLogSpell(sharedId, sourceGUID, sourceName, true)
		end
	end
end

function core:ProcessCombatLogEvent(event, sourceGUID, sourceName, spellID)
	--print(tostring(event)..", "..tostring(sourceGUID)..", "..tostring(sourceName)..", "..tostring(spellID))
	if event ~= "SPELL_RESURRECT" and event ~= "SPELL_CAST_SUCCESS" and event ~= "SPELL_AURA_APPLIED" then
		_lastSpell = nil
		_lastPlayer = nil
		return
	end
	--ignore weird stuff that we don't know can happen or not
	if not sourceName or not spellID or not sourceGUID then
		_lastSpell = nil
		_lastPlayer = nil
		return
	end

	--special case for soulstone tracking on the addon runners end.
	if PLAYER_IS_WARLOCK and sourceName == Player.name and ((spellID == SPELLID_SOULSTONERESURRECTION and event == "SPELL_AURA_APPLIED") or (spellID == SPELLID_SOULSTONERESURRECTION_WHENDEAD and event == "SPELL_RESURRECT")) then
		STARTTIME_SOULSTONERESURRECTION = GetTime() --remember when the spell was cast
	end
	
	--don't process yourself
	if (sourceName == Player.name) then
		_lastSpell = nil
		_lastPlayer = nil
		return
	end
	
	--this function will convert, if necessary, the spell if from 20707 or 95750 to 20707 which is what Hermes uses to track Soulstones.
	--Note that 20707 is the spell that's cast via SPELL_AURA_APPLIED when warlock puts SS on player that is alive.
	--Note that 95750 is the spell that's cast via SPELL_RESURRECT when warlock puts SS on player that is dead (battle res).
	spellID = ConvertSpellIdIfSoulstone(spellID)
	
	self:ProcessCombatLogSpell(spellID, sourceGUID, sourceName)
end

function Hermes:OnEnable()
	core:Startup()
end

function Hermes:OnDisable()
	core:Shutdown()
end

function Hermes:OnInitialize() -- Only called once, do all one time init stuff here
	--load the absolute bare essentials for options. These merge with options saved already
	core:LoadDefaultOptions()
	
	--create a reference to the profile table
	dbp = self.db.profile
	dbg = self.db.global

	self:UpgradeDatabase()
	
	--initialize option tables
	core:LoadBlizOptions()

	--if the time is unreliable, then wipe out all cooldowns from db
	if core:SyncServerTimeToClient() then
		core:WipeAllCooldowns()
	end
	
	--create the frame which uses OnUpdate event to manage spell durations and OnUpdate events
	core:InitializeAbilityInstanceFrame()
	
	--setup profile events
	self.db.RegisterCallback(self, "OnNewProfile", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	
	--initialize Reincarnation module
	MOD_Reincarnation = self:GetModule("HermesReincarnation")
	MOD_Reincarnation:SetCallback(function(unit, name, guid) core:OnReincarnationUsed(unit, name, guid) end)
	
	MOD_Talents = self:GetModule("HermesTalents")
	MOD_Talents:SetProfile(dbg)
	MOD_Talents:SetOnRemove(function(guid, unit, name) core:TalentRemove(guid, unit, name) end)
	MOD_Talents:SetOnUpdate(function(guid, unit, name) core:TalentUpdate(guid, unit, name) end)
	MOD_Talents:SetOnClassTalentsUpdated(function(class) core:UpdateSMSClass(class, nil) end)
	
	--dbg.schema = core:GenerateSchemaTable()
	--dbg.schema = nil
end

function Hermes:UpgradeDatabase()
	--------------------------
	-- v2.2 to v2.3 changes
	--------------------------
	--add new spellmetadata table
	if not dbg.spellmetadata then
		dbg.spellmetadata = {}
	end
	--convert cooldowns using autoduration, autduration feature has been removed
	for id, duration in pairs(dbg.durations) do
		--autodurations table may have already been removed
		if dbg.autodurations and duration == true and dbg.autodurations[id] then
			dbg.durations[id] = dbg.autodurations[id]
		elseif dbg.autodurations and duration == false or duration == true then
			dbg.durations[id] = nil --test the crap out of this!!!
		end
	end
	--remove the autodurations table
	dbg.autodurations = nil
	--fix the bug in 40200-2 where DG cooldown was wrong
	local paladin = dbg.classes["PALADIN"]
	if paladin then
		if paladin.schema == 40200 and paladin.revision < 3 then
			core:UpdateSMSClass("PALADIN", 1)
		end
	end
end

function Hermes:OnProfileChanged()
	dbp = self.db.profile
	dbg = self.db.global
	
	self:UpgradeDatabase()
	
	MOD_Talents:SetProfile(dbg)
	
	self:Disable()
	
	core:UpdateBlizOptionsTableReferences() --update table references, otherwise they'll be pointing to old tables for the prior profile

	self:Enable()
	
	if dbp.configMode == true then
		core:ShowHermesTestModeMessage()
	end
end

function Hermes:OnReceiverComm(prefix, serialized, channel, sender)
	if(prefix == HERMES_RECEIVE_COMM) then
	
		--when toggling config mode, it's possible to get stale messages from players after having already set config mode.
		--So if in config mode, make sure that the message if a message from yourself, sent to the whisper channel
		if dbp.configMode  == true and channel ~= "WHISPER" and sender ~= Player.name then
			--ignore the message
			return
		end
		
		local success, msg = self:Deserialize(serialized)
		if(success) then
			local msgEnum = msg[1]
			local msgContent = msg[2]
			local msgName = MESSAGE_ENUM[msgEnum]
			
			if(msgName and msgName == "INITIALIZE_SENDER") then
				local classEnum = msgContent
				core:ProcessMessage_INITIALIZE_SENDER(sender, classEnum, channel)
				
			elseif(msgName and msgName == "UPDATE_SPELLS") then
				local classEnum = msgContent[1]
				local trackerUpdates = msgContent[2]
				core:ProcessMessage_UPDATE_SPELLS(sender, classEnum, trackerUpdates, channel)
			end
		else
			error("Error deserializing message")
		end
	end
end

function Hermes:OnSenderComm(prefix, serialized, channel, sender)
	if(prefix == HERMES_SEND_COMM) then
		--when toggling config mode, it's possible to get stale messages from players after having already set config mode.
		--So if in config mode, make sure that the message if a message from yourself, sent to the whisper channel
		if dbp.configMode == true and channel ~= "WHISPER" and sender ~= Player.name then
			--ignore the message
			return
		end
		
		local success, msg = self:Deserialize(serialized)
		if(success) then
			local msgEnum = msg[1]
			local msgContent = msg[2]
			local msgName = MESSAGE_ENUM[msgEnum]
			
			if(msgName and msgName == "REQUEST_SPELLS") then
				local trackerRequests = msgContent[1]
				core:ProcessMessage_REQUEST_SPELLS(sender, trackerRequests, channel)

			elseif(msgName and msgName == "INITIALIZE_RECEIVER") then
				core:ProcessMessage_INITIALIZE_RECEIVER(sender, channel)
			end
		else
			error("Error deserializing message")
		end
	end
end

function Hermes:OnUpdateSenderCooldowns(delay)
	if(Sender and Sender.Trackers) then
		
		--first update all of the cooldowns and populate list with spells that need to be sent
		local trackerUpdates = nil
		for i, tracker in ipairs(Sender.Trackers) do
			--if...
			--	1. There are dirty receivers
			--	2. Dirty receiver count is equal to total sender count.
			--	3. Dirty receiver count is greater than zero.
			--	4. Message needs to be sent due to cooldown change...
			-- The point of this is to avoid sending a message to everyone when there is only one receiver interested in the spell, in which case a single message will be sent to the user
			if(core:UpdateSenderCooldown(tracker) == true or ((	tracker.dirtyReceivers and _tableCount(tracker.receivers) == #tracker.dirtyReceivers) and (tracker.dirtyReceivers and #tracker.dirtyReceivers > 1) )) then
				if(not trackerUpdates) then
					trackerUpdates = {}
				end
				tinsert(trackerUpdates, {tracker.id, tracker.duration})
				
				--wipe out dirty receivers since a global send is going to be done
				tracker.dirtyReceivers = nil
			end
		end
		
		--There is more than one receiver interested in this spell that also requires an update, fire it off globally
		if(trackerUpdates and #trackerUpdates > 0) then
			core:SendMessage_UPDATE_SPELLS(nil, trackerUpdates)
		end
		
		--cleanup table
		local trackerUpdates = nil
		
		local dirtyUpdates = nil
		--loop again looking for any trackers that have dirty receivers, if a global message was sent above then this won't find anything
		for i, tracker in ipairs(Sender.Trackers) do
			if(tracker.dirtyReceivers) then
				for _, receiverName in ipairs(tracker.dirtyReceivers) do
					--create dirty table if not already exists
					if(not dirtyUpdates) then dirtyUpdates = {}	end
				
					--add receiver if not already added
					if(not dirtyUpdates[receiverName]) then
						dirtyUpdates[receiverName] = {}
					end
				
					--add the update to the receiver record
					tinsert(dirtyUpdates[receiverName], {tracker.id, tracker.duration})
				end
				
				--wipe out dirty receivers for this tracker
				tracker.dirtyReceivers = nil
			end
		end
		
		-- these individual receivers still need an update, a message is sent to each instead of spammed to everyone.
		-- the performance boost here is that the sender and a few receivers take the hit instead of all the receivers (perhaps 25 of them!)
		if(dirtyUpdates) then
			for receiverName, trackerUpdates in pairs(dirtyUpdates) do
				core:SendMessage_UPDATE_SPELLS(receiverName, trackerUpdates)
			end
		end
		
		--wipe out table if exists
		dirtyUpdates = nil
	end
	
	--if this was the initial scan from just starting up, then restart the timer with the regular scan rate
	if(delay == COOLDOWN_SCAN_FREQUENCY_INITIAL) then
		core:KillCooldownScanTimer()
		core:StartCooldownScanTimer(COOLDOWN_SCAN_FREQUENCY)
		print("|cFF00FF00Hermes|r: "..L["now sending"])
	end
end

function Hermes:OnUpdateItemNameTimer(currentId)
	core:KillItemNameTimer() 
	--see if the client knows the name now
	local id, name, icon = core:GetItemInfoFromPlayerCache(Hermes:AbilityIdToBlizzId(currentId), nil)
	if(id and name and icon) then
		--client knows the item now, update it
		for _, item in ipairs(dbp.items) do
			if(item.id == currentId) then
				item.caching = nil
				item.name = name
				item.icon = icon
				core:FireEvent("OnInventoryItemChanged", item.id)
			end
		end
		
		--resort the items to account for new name
		sort(dbp.items, function(a, b) return core:SortProfileItems(a, b) end)
		
		--update blizz options table with the new info
		LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
		core:BlizOptionsTable_Items()
	end
	
	--now let's see if we need to kick off another timer
	local nextId = core:GetNextItemIdToCache(currentId)
	if(nextId) then
		ITEM_NAME_TIMER = self:ScheduleTimer("OnUpdateItemNameTimer", ITEM_NAME_THROTTLE, nextId)
	end
end

function Hermes:OnSenderStatusTimer()
	if(Senders) then
		for _, sender in ipairs(Senders) do
			core:UpdateSenderStatus(sender, true)
		end
	end
end

--------------------------------------------------------------------
-- CORE
--------------------------------------------------------------------
function core:OnSpellMonitorStatusChanged()
	if dbp.enabled == true and dbp.combatLogging == true and Player.battleground == false then
		if not MOD_Reincarnation:IsEnabled() then
			MOD_Reincarnation:Enable()
		end
		
		if not MOD_Talents:IsEnabled() then
			MOD_Talents:Enable()
		end
	else
		if MOD_Reincarnation:IsEnabled() then
			MOD_Reincarnation:Disable()
		end
		
		if MOD_Talents:IsEnabled() then
			MOD_Talents:Disable()
		end
	end
end

function core:CanCreateVirtualInstance(ability)
	return Hermes:IsReceiving() and dbp.combatLogging and dbp.combatLogging == true and ability
end

function core:CanCreateVirtualSender(sender)
	return Hermes:IsReceiving() and dbp.combatLogging and dbp.combatLogging == true and sender and sender.virtual
end

function core:UpdateCommunicationsStatus()
	local wasInRaid = Player.raid
	local wasInParty = Player.party
	local wasInBattleground = Player.battleground
	
	core:UpdatePlayerGroupStatus()
	
	--this will enable/disable spell monitor mods as needed. Should be called after UpdatePlayerGroupStatus due to battleground status
	self:OnSpellMonitorStatusChanged()
		
	--if we're in a battleground, then we need to now allow Hermes to run at all, regardless of anything else
	--we also want to shutdown SpellMonitor support so as not to pick up tons of player talent info
	if Player.battleground == true then
		if(Hermes:IsSending() == true ) then
			core:StopSending()
		end
		if(Hermes:IsReceiving() == true ) then
			core:StopReceiving()
		end

		return --EXIT NOW!
	end
	
	--kill config mode if we just joined a party or raid and are already in config mode
	if dbp.configMode == true and ((Player.raid == true and wasInRaid == false) or (Player.party == true and wasInParty == false)) then
		dbp.configMode = false
		
		if(Hermes:IsSending() == true ) then
			core:StopSending()
		end
		if(Hermes:IsReceiving() == true ) then
			core:StopReceiving()
		end
	end
	
	local initSelfSender = false
	--this is a special case required so that whenever we go from a party to a raid, or vice verse, that we reset sending and receiving.
	--we can just stop it here if that's the case, and allow the code below to restart it if necessary
	--if((wasInRaid == true and self.PlayerInRaid == false) or (wasInParty == true and self.PlayerInParty == false)) then
	if(	(wasInParty == true and wasInRaid == false and Player.raid == true) 			--we just converted from a party to a raid
		or 
		(wasInRaid == true and Player.raid == false and Player.party == true) ) then	--we just converted from a raid to a party
		
		if(Hermes:IsSending() == true ) then
			core:StopSending()
		end
		if(Hermes:IsReceiving() == true ) then
			core:StopReceiving()
		end
	end

	--start sending if needed
	if( dbp.enabled == true and ((dbp.sender.enabled == true and ((Player.party == true and dbp.enableparty == true) or Player.raid == true)) or dbp.configMode == true) ) then
		if(Hermes:IsSending() == false) then
			initSelfSender = true
			core:StartSending()
		end
	else
		if(Hermes:IsSending() == true ) then
			core:StopSending()
		end
	end
	
	--start receiving if needed
	if(dbp.enabled == true and ((dbp.receiver.enabled == true and ((Player.party == true and dbp.enableparty == true) or Player.raid == true)) or dbp.configMode == true) ) then
		if(Hermes:IsReceiving() == false) then
			core:StartReceiving()
		end
	else
		if(Hermes:IsReceiving() == true ) then
			core:StopReceiving()
		end
	end
	
	----------------------------------------------------------------------------------------
	-- It's very important that we add ourself after initializing BOTH sending and receiving
	----------------------------------------------------------------------------------------
	if initSelfSender == true then
		--add yourself as a sender
		core:AddSender(Player.name, Player.class)
		
		--advertise self to receivers
		core:SendMessage_INITIALIZE_SENDER(nil)

		if dbp.configMode == false then
			print(format("|cFF00FF00Hermes|r: "..L["queuing requests for %s seconds..."], tostring(COOLDOWN_SCAN_FREQUENCY_INITIAL)))
			core:StartCooldownScanTimer(COOLDOWN_SCAN_FREQUENCY_INITIAL)
		else
			core:StartCooldownScanTimer(COOLDOWN_SCAN_FREQUENCY)
		end
	end
end

function core:StartReceiving()
	Receiving = true
	
	--give display stuff time to initialize itself before dumping abilities at it
	core:FireEvent("OnStartReceiving")
	
	--build up spellRequests so that we can sent them all in one fat message
	local requests = {}
	
	--initialize Ability list, it should already be empty
	for i, spell in ipairs(dbp.spells) do
		if(spell.enabled and spell.enabled == true) then
			core:StartTrackingAbility(spell, true) --true indicates to not send a message
			tinsert(requests, spell.id)
		end
	end
	
	for i, item in ipairs(dbp.items) do
		if(item.enabled and item.enabled == true) then
			core:StartTrackingAbility(item, true) --true indicates to not send a message
			tinsert(requests, item.id)
		end
	end

	--only send message if we're tracking spells
	if(#requests > 0) then
		core:SendMessage_REQUEST_SPELLS(nil, requests)
	end
	
	--create all the non hermes users
	core:ResetNonHermesPlayers()
	
	core:StartSenderStatusTimer()
	
	--be ready for messages before sending requests
	Hermes:RegisterComm(HERMES_RECEIVE_COMM, "OnReceiverComm")

	--advertise receiver
	core:SendMessage_INITIALIZE_RECEIVER(nil)
end

function core:StopReceiving()
	--stop getting messages
	Hermes:UnregisterComm(HERMES_RECEIVE_COMM)
	
	core:StopSenderStatusTimer()
	core:RemoveAllSenders()
	core:StopTrackingAllAbilities()
	
	Receiving = false
	
	--initialize display stuff
	core:FireEvent("OnStopReceiving")
end

function core:RequestAbilityUpdate(id)
	local trackerRequests = {}
	tinsert(trackerRequests, id)
	core:SendMessage_REQUEST_SPELLS(nil, trackerRequests)
end

function core:HandleRemoteSender(senderName, classEnum, resetIfExists)
	--see if we know the sender
	local sender = core:FindSenderByName(senderName)
	
	--this chunk of code is how we allow Hermes to realize that what used to be a virtual sender,
	--is now a real hermes sender and to trash the old table for the sender.
	if sender and sender.virtual then
		core:RemoveSender(sender)
		sender = nil
	end
	
	if(sender) then
		if not resetIfExists then
			return
		else
			--causes virtual senders to be completely refreshed if it went from being virtual to non-virtual
			core:RemoveSender(sender)
			sender = nil
		end
	end
	
	if(not sender) then
		core:AddSender(senderName, classEnum)
	end
	
	--build up spellRequests
	local requests = {}
	for _, ability in ipairs(Abilities) do
		--only add spells that apply to the class
		if(core:GetClassEnum(ability.class) == classEnum or ability.class == "ANY") then
			tinsert(requests, ability.id)
		end
	end
	
	--only send message if there are spells requested for the senders class
	if(#requests > 0) then
		core:SendMessage_REQUEST_SPELLS(senderName, requests)
	end
end

function core:ProcessMessage_INITIALIZE_SENDER(senderName, classEnum, channel)
	if senderName and senderName == Player.name then
		--print("INITIALIZE_SENDER caught from self, ignoring")
	else
		core:HandleRemoteSender(senderName, classEnum, channel ~= "WHISPER")
	end
end

function core:HandleTrackerUpdates(senderName, classEnum, trackerUpdates)
	core:HandleRemoteSender(senderName, classEnum, false) --adds the sender if it wasn't already known
	
	for _, trackerUpdate in ipairs(trackerUpdates) do
		local ability = nil
		for _, a in ipairs(Abilities) do
			if(a.id == trackerUpdate[1] and (core:GetClassEnum(a.class) == classEnum or a.class == "ANY")) then
				ability = a --we're tracking it
				break
			end
		end
			
		if(ability) then
			--now update it
			local duration = trackerUpdate[2]

			--find the sender
			local sender = core:FindSenderByName(senderName)
			
			if(duration ~= ITEM_NOT_IN_IVENTORY_OR_EQUIPPED) then
				--duration changed and the item is a spell or in the players inventory
				core:SetAbilityInstance(ability, sender, duration)
			else
				--the item is no longer, or never was, in the senders inventory
				local instance = core:FindAbilityInstance(ability, sender)
				if instance then
					core:RemoveAbilityInstance(instance)
				end
			end
		end
	end
end

function core:ProcessMessage_UPDATE_SPELLS(senderName, classEnum, trackerUpdates, channel)
	core:HandleTrackerUpdates(senderName, classEnum, trackerUpdates)
end

function core:StartSending()
	--init Sender
	Sender = {}
	Sender.Trackers = {}

	--initialize display stuff
	core:FireEvent("OnStartSending")
	
	--be ready for messages before start sending
	Hermes:RegisterComm(HERMES_SEND_COMM, "OnSenderComm")

	--register for other wow events
	Hermes:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
end

function core:StopSending()
	--cleanup sender state
	if(Sender) then
		wipe(Sender)
		Sender = nil
	end
	
	--stop getting messages
	Hermes:UnregisterComm(HERMES_SEND_COMM)
	
	--unregister for other wow events
	Hermes:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		
	core:KillCooldownScanTimer()
	
	--initialize display stuff
	core:FireEvent("OnStopSending")
end

function core:HandleTrackerRequests(receiverName, trackerRequests)
	for _, tid in ipairs(trackerRequests) do
		if(core:SenderHasTracker(tid)) then
			local tracker = nil
			--see if we know the tracker
			for _, t in ipairs(Sender.Trackers) do
				if(t.id == tid) then
					--we know the tracker, see if we know the receiver
					local receiver = t.receivers[receiverName]
					--we don't know this receiver yet, add it
					if(not receiver) then
						t.receivers[receiverName] = {}
					end
					
					--mark this receiver as dirty
					if(not t.dirtyReceivers) then
						t.dirtyReceivers = {}
					end
					tinsert(t.dirtyReceivers, receiverName)
					
					tracker = t --mark spell for below...
					break
				end
			end
			
			--we're not tracking this spell yet
			if(not tracker) then
				tracker = {
					id = tid,
					duration = nil,
					receivers = {}
				}
				tracker.receivers[receiverName] = {} --add the receiver to the spell
				tinsert(Sender.Trackers, tracker) --add the spell
				
				--mark this receiver as dirty
				tracker.dirtyReceivers = {}
				tinsert(tracker.dirtyReceivers, receiverName)
			end
		end
	end
end

function core:ProcessMessage_REQUEST_SPELLS(receiverName, TrackerRequests, channel)
	core:HandleTrackerRequests(receiverName, TrackerRequests)
end

function core:ProcessMessage_INITIALIZE_RECEIVER(receiverName, channel)
	if receiverName and receiverName == Player.name then
		--print("INITIALIZE_RECEIVER caught from self, ignoring")
	else
		core:SendMessage_INITIALIZE_SENDER(receiverName)
	end
end

function core:Startup()
	--reset player status so that it detects as changed
	Player.raid = false
	Player.party = false
	Player.battleground = false
	
	--create default spells and items for new profile
	if not dbp.welcome then
		dbp.welcome = true
		core:SetupNewProfileAbilities() --create list of default spells
	end
	
	--create default spells and items for new profile
	if not dbg.welcome then
		dbg.welcome = true
		core:SetupNewProfileAbilities() --update list of default spells so that we add Soulstone Resurrection to the list
	end

	--enable all registered plugins so that they can start hooking events
	core:EnablePlugins()
	
	--update the entire option tables, we have to call this after enabling plugins so they they can setup their option tables
	core:UpdateBlizOptionsTableReferences()
		
	--start Sending and Receiving as needed
	if(PLAYER_ENTERED_WORLD) then
		--go right into config mode if so configured, make sure to do this before calling UpdateCommunicationsStatus so that we go into test mode before any other mode.
		if(dbp.configMode == true and dbp.enabled == true) then
			core:StartTestMode()
		else
			core:UpdateCommunicationsStatus()
		end
	else
		Hermes:RegisterEvent("PLAYER_ENTERING_WORLD")
	end

	Hermes:RegisterEvent("RAID_ROSTER_UPDATE")
	Hermes:RegisterEvent("PARTY_MEMBERS_CHANGED")
	
	--start capturing spell casts
	Hermes:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
	--fire off any item name timers
	for _, item in ipairs(dbp.items) do
		if(item.caching) then
			core:StartItemNameTimer(item.id) --fire off timer for getting item names
		end
	end
end

function core:Shutdown()
	Hermes:UnregisterEvent("RAID_ROSTER_UPDATE")
	Hermes:UnregisterEvent("PARTY_MEMBERS_CHANGED")
	
	--stop remembering spell casts
	Hermes:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
	core:StopSending()
	core:StopReceiving()
	
	--disable plugins before we stop receiving, very important because they may need to unhook events
	core:DisablePlugins()
	
	core:KillItemNameTimer()
	
	--wipe out players table
	for _, player in pairs(Players) do
		player = nil
	end
end

function core:SetupNewProfileAbilities()
	core:SetupNewProfileSpells()
	core:SetupNewProfileItems()
end

function core:SetupNewProfileSpells()
	local playerAlliance = select(1, UnitFactionGroup("player"))
	
	for i, default in ipairs(DEFAULT_SPELLS) do
		local class = default[1]
		local spellid = default[2]
		local alliance = default[3]
		
		if(not alliance or (alliance and alliance == playerAlliance)) then
			--make sure spell isn't already added
			local exists = false
			for _, s in ipairs(dbp.spells) do
				if(s.id == spellid) then
					exists = true
					break
				end
			end
			
			if(exists == false) then
				local spell = core:FindSpellName(class, spellid)
				if(spell) then
					--add to db
					spell.enabled = false
					tinsert(dbp.spells, spell)
					--sort the spells
					sort(dbp.spells, function(a, b) return core:SortProfileSpells(a, b) end)
					--update spell monitor related data if available for this spell
					self:UpdateSMSSpellCooldown(spell.id, nil)
					self:UpdateSMSSpellMetadata(spell.id, nil)
					self:UpdateSMSSpellRequirements(spell.id, spell.class, nil)
					self:UpdateSMSSpellAdjustments(spell.id, spell.class, nil)
					core:FireEvent("OnInventorySpellAdded", spell.id)
				end
			end
		end
	end
	
	--update blizzard options
	core:BlizOptionsTable_Spells()
end

function core:SetupNewProfileItems()
	local playerAlliance = select(1, UnitFactionGroup("player"))
	
	for i, default in ipairs(DEFAULT_ITEMS) do
		local class = default[1]
		local id = default[2]
		local alliance = default[3]
		
		if(not alliance or (alliance and alliance == playerAlliance)) then
			--make sure item isn't already added
			local exists = false
			for _, s in ipairs(dbp.items) do
				if(s.id == core:EncodeAbilityId(id, "item")) then
					exists = true
					break
				end
			end
			
			if(exists == false) then
				local itemid, itemname, itemicon = core:GetItemInfo(id, nil)
				
				if(itemicon and itemid) then
					itemid = core:EncodeAbilityId(itemid, "item")
					--we may need to cache the item
					local caching = nil
					if(not itemname) then
						caching = 1
						itemname = "..."..L["searching"].." ("..tostring(Hermes:AbilityIdToBlizzId(tonumber(itemid)))..")"
					end
				
					local item = {
						class = class,
						id = itemid,
						name = itemname,
						icon = itemicon,
						enabled = false,
						caching = caching
					}
				
					--add to db
					tinsert(dbp.items, item)
				
					--sort the items
					sort(dbp.items, function(a, b) return core:SortProfileItems(a, b) end)
				
					core:FireEvent("OnInventoryItemAdded", item.id)
					
					--fire off the name cache timer if needed
					if(caching) then
						core:StartItemNameTimer(item.id)
					end
				end
			end
		end
	end
	
	--update blizzard options
	core:BlizOptionsTable_Items()
end

function core:FindSpellName(class, spellid)
	--see if the spell exists
	local name
	local icon
	name, _, icon, _, _, _, _, _, _ = GetSpellInfo(spellid)
	
	if(not name or not icon) then
		return nil
	end
	
	local spell = {
		class = class,
		id = spellid,
		name = name,
		icon = icon,
		enabled = false,
	}

	return spell
end

function core:SendMessageToReceivers(recipientName, msgEnum, msgContent)
	local msg = Hermes:Serialize({msgEnum, msgContent})
	local channel, recipient = core:GetAppropriateMessageChannelAndRecipient(recipientName)
	--print("Sender to Receiver: "..channel..","..tostring(recipient)..","..tostring(MESSAGE_ENUM[msgEnum]))
	Hermes:SendCommMessage(HERMES_RECEIVE_COMM, msg, channel, recipient, "NORMAL", nil, nil)
end

function core:GetAppropriateMessageChannelAndRecipient(recipientName)
	if(dbp.configMode == true) then
		return "WHISPER", Player.name --in test mode, only send whispers to yourself
	elseif(recipientName) then
		return "WHISPER", recipientName
	elseif(Player.battleground == true) then
		return "BATTLEGROUND", recipientName
	elseif(Player.raid == true) then
		return "RAID", recipientName
	elseif(Player.party == true) then
		return "PARTY", recipientName
	else
		error("Unable to determine message channel")
	end
end

function core:SendMessageToSenders(recipientName, msgEnum, msgContent)
	local msg = Hermes:Serialize({msgEnum, msgContent})
	local channel, recipient = core:GetAppropriateMessageChannelAndRecipient(recipientName)
	--print("Receiver to Sender: "..channel..","..tostring(recipient)..","..tostring(MESSAGE_ENUM[msgEnum]))
	Hermes:SendCommMessage(HERMES_SEND_COMM, msg, channel, recipient, "NORMAL", nil, nil)
end

function core:SendMessage_REQUEST_SPELLS(recipientName, trackerRequests)
	core:SendMessageToSenders(recipientName, core:GetMessageEnum("REQUEST_SPELLS"),
		{
			trackerRequests
		}
	)
end

function core:SendMessage_INITIALIZE_SENDER(recipientName)
	core:SendMessageToReceivers(recipientName, core:GetMessageEnum("INITIALIZE_SENDER"),
		Player.class
	)
end

function core:SendMessage_INITIALIZE_RECEIVER(recipientName)
	core:SendMessageToSenders(recipientName, core:GetMessageEnum("INITIALIZE_RECEIVER"),
		nil
	)
end

function core:SendMessage_UPDATE_SPELLS(recipientName, trackerUpdates)
	core:SendMessageToReceivers(recipientName, core:GetMessageEnum("UPDATE_SPELLS"),
		{
			Player.class,
			trackerUpdates,
		}
	)
end

function core:SenderHasTracker(identifier)
	local id, idtype = Hermes:AbilityIdToBlizzId(identifier)
	
	if(idtype == "spell") then
		return core:IsSpellKnown(id)
	else
		--always return trueThis is because for all we know they might have changed gear, gone to the bank, etc.
		--TODO: On the next version of the protocol, make sure that the receiver sends the class of the spell when talking to senders
		--return self:IsItemKnown(id)
		return true
	end
end

function core:IsSpellKnown(spellid)
	-- Special catch for warlock soulstone tracking. Soulstone Resurrection doesn't show up in the spell book
	if(spellid == SPELLID_SOULSTONERESURRECTION and Player.class == core:GetClassEnum("WARLOCK")) then
		return true
	end
	
	local slot = FindSpellBookSlotBySpellID(spellid)
	if slot and slot <= MAX_SPELLS then
		local slotType, id = GetSpellBookItemInfo(slot, BOOKTYPE_SPELL)
		return id == spellid and slotType ~= 'FUTURESPELL'
	end
	
	
end

function core:IsItemKnown(itemid)
	--50620 Coldwraith Links
	--50364 Sindragosa's Flawless Fang
	
	if(IsEquippableItem(itemid)) then --figure out whether it's something that's supposed to be equipped or which sits in inventory
		local itemCount = GetItemCount(itemid, nil, nil) --see if they have the item at all (not including bank)
		if(itemCount > 0) then --the person has the item, see if it's equipped
			for _, slot in ipairs(EQUIPPABLE_SLOTS) do
				local slotid = GetInventorySlotInfo(slot)
				local inventoryid = GetInventoryItemID("player", slotid)
				if(inventoryid == itemid) then --item found
					return true
				end
			end
		end
	else
		local itemCount = GetItemCount(itemid, nil, nil) --see if they have the item
		if(itemCount > 0) then --the person has the item, no need to check for equipped
			return true
		end
	end
	
	--item not found
	return false
end

function core:UpdateSenderCooldown(tracker)
	local send = false

	--get latest cooldown info
	local priorCooldown = tracker.duration
	tracker.duration = core:GetLatestCooldown(tracker.id)
		
	--[[
	If the spell being tracked is determined to be one which uses runes and which also has an actual cooldown,
	then set tracker.duration and priorCooldown to nil. This fools Hermes into thinking that the cooldown
	has ended "naturally" and that no messages will need to be sent as updates, or in the case that it was forced above, it will
	be sent as being available.
	]]--
	if(Player.class == core:GetClassEnum("DEATHKNIGHT")) then
		if(core:AdjustForRunes(tracker)) then
			tracker.duration = nil
			priorCooldown = nil
		end
	end	

	--special handling for warlock soulstones
	if(Player.class == core:GetClassEnum("WARLOCK")) then
		--see if this is the soulstone tracker
		if tracker.id == SPELLID_SOULSTONERESURRECTION then
			--try to find a soulstone in their inventory
			local soulstone = core:GetLatestCooldown(ITEMID_SOULSTONE)
			local maxDuration = 15 * 60 --15 minutes
			if soulstone == ITEM_NOT_IN_IVENTORY_OR_EQUIPPED then
				--no soulstone in inventory, let's try looking at STARTTIME_SOULSTONERESURRECTION instead
				if STARTTIME_SOULSTONERESURRECTION ~= nil then
					--UNIT_SPELLCAST_SUCCEEDED was caught at some point, let's see if it's expired yet
					local duration = ceil(STARTTIME_SOULSTONERESURRECTION - (GetTime() - maxDuration))

					if duration < 0 then
						--we're here because two things have happened:
						--1) The user has no soulstone in their inventory
						--2) The soulstone resurrection timer was running, but it just expired
						--Net result is that the spell is known to be available now
						tracker.duration = nil
						--reset the resurrection time
						STARTTIME_SOULSTONERESURRECTION = nil
					else
						--we're here because two things have happened:
						--1) The user has no soulstone in their inventory
						--2) The soulstone resurrection timer is still running
						--Net result is that the spell is on cooldown
						tracker.duration = duration
					end
				else
					--Both Soulstone item and Soulstone Resurrection times are nil.
					--We have no idea if the spell is actually available or not so just assume it's available
					--As soon as the warlock creates a soulstone it'll update so this is the best bet.
					tracker.duration = nil
				end
			else
				if soulstone ~= nil then
					--We're here because there is in fact a soulstone in their inventory
					--Let's go ahead and set STARTTIME_SOULSTONERESURRECTION to an appropriate value
					STARTTIME_SOULSTONERESURRECTION = GetTime() + (soulstone - maxDuration)
					tracker.duration = soulstone
				else
					--soulstone in inventory and the spell is available, don't need to do anything as tracker.duration will already be correct (nil)
				end
			end
		end
	end
	
	--determine whether we need to send any global messages
	if(priorCooldown ~= tracker.duration) then
		--if it wasn't on cooldown last but it is now
		if(priorCooldown == nil and tracker.duration ~= nil) then
			send = true

			--if it was on cooldown but now it's not.
		elseif(priorCooldown ~= nil and tracker.duration == nil) then
			--only send message if the last cooldown value is greater than the threshold, this is to prevent sending messages for spells that went off cooldown naturally
			if(priorCooldown == ITEM_NOT_IN_IVENTORY_OR_EQUIPPED or priorCooldown > COOLDOWN_DELTA_THRESHOLD) then
				send = true
			end
				
		elseif(priorCooldown ~= nil and tracker.duration ~= nil) then
			--if for some reason the cooldown is larger than it was last time we checked
			if(tracker.duration > priorCooldown) then
				send = true
			end
			--if for some reason the cooldown is unexpectedly smaller than last time we checked
			if((priorCooldown - tracker.duration) > COOLDOWN_DELTA_THRESHOLD) then
				send = true
			end
		end
	end

	return send
end

function core:GetLatestCooldown(identifier)
	local id, idtype = Hermes:AbilityIdToBlizzId(identifier)
	local cooldown = nil
	if(idtype == "spell") then
		local start, duration, _ = GetSpellCooldown(id)
		--note that GetSpellCooldown returns the GCD if active when called. By calling > 2 I hope to filter out any GCD's at the expense of not reporting cooldowns actually only having 2 seconds or less on them.
		if(duration > 2) then
			cooldown = ceil(duration - (GetTime() - start)) --spell on cooldown
		else
			cooldown = nil
		end
		return cooldown
	else
		if(IsEquippableItem(id)) then
			-- The item is intended to be equipped, like a trinket. See if they have the item at all (not including bank)
			local itemCount = GetItemCount(id, nil, nil)
			if(itemCount > 0) then
				--They have the item, but is it equipped?
				for _, slot in ipairs(EQUIPPABLE_SLOTS) do
					local slotid = GetInventorySlotInfo(slot)
					local inventoryid = GetInventoryItemID("player", slotid)
					if(inventoryid == id) then --item found
						local start, duration, enable = GetInventoryItemCooldown("player", slotid)
						if(duration > 2) then
							cooldown = ceil(duration - (GetTime() - start)) --spell on cooldown
						else
							cooldown = nil
						end
						--return the cooldown based on it being equipped
						return cooldown
					end
				end
				
				--if we made it here, then it means they have the item, but it's not equipped.
				return ITEM_NOT_IN_IVENTORY_OR_EQUIPPED
			else
				--if we made it here, then they don't have the item at all.
				return ITEM_NOT_IN_IVENTORY_OR_EQUIPPED
			end
		else
			-- The item is NOT intended to be equipped, like a potion
			local itemCount = GetItemCount(id, nil, nil) --see if they have the item
			if(itemCount > 0) then --the person has the item, no need to check for equipped
				local start, duration, enable = GetItemCooldown(id)
				if(duration > 2) then
					cooldown = ceil(duration - (GetTime() - start)) --spell on cooldown
				else
					cooldown = nil
				end
				return cooldown
			else
				return ITEM_NOT_IN_IVENTORY_OR_EQUIPPED
			end
		end
	end
end

function core:FireEvent(event, ...)
	--check for valid event
	if not Events[event] then
		error("unknown hermes event: "..tostring(event))
	end
	
	--fire the events for each registered handler
	for key, handler in pairs(Events[event]) do
		handler(...)
	end
end

--------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------
function core:GetItemInfoFromPlayerCache(itemId, itemName)
	local id, name, icon
	
	if(itemId) then
		name = GetItemInfo(itemId)
		id = itemId
		icon = GetItemIcon(itemId)
		
	elseif(itemName) then
		name, link = GetItemInfo(itemName)
		if(name) then
			--borrowed expressions from ItemId, thank you
			local justItemId = string.gsub(link, ".-\124H([^\124]*)\124h.*", "%1");
			local type, itemid, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId = strsplit(":",justItemId);
			id = tonumber(itemid) --todo, extract id from link
			icon = GetItemIcon(id)
		end
	end
	
	return id, name, icon
end

function core:GetItemInfo(requestid, requestname)
	local id, name, icon
	if(requestid) then
		--this method will always return a value if the id exists
		icon = GetItemIcon(requestid)
		--the item by that id exists, but it's not in the local or server cache, try to query again later.
		if(icon) then --try to lookup item again
			--item exists, see if we have the name in cache, could return nil
			id, name, _ = core:GetItemInfoFromPlayerCache(requestid, nil)
		end
	else
		id, name, icon = core:GetItemInfoFromPlayerCache(nil, requestname)
	end
	
	return id, name, icon
end

function core:GetClassEnum(classFileName)
	for i, class in ipairs(CLASS_ENUM) do
		if(class == classFileName) then
			return i
		end
	end
	error("Failed to locate class enum")
end

function core:GetMessageEnum(messageName)
	for i, msg in ipairs(MESSAGE_ENUM) do
		if(msg == messageName) then
			return i
		end
	end
	error("Failed to locate message enum")
end

function core:KillCooldownScanTimer()
	if(COOLDOWN_SCAN_TIMER) then
		Hermes:CancelTimer(COOLDOWN_SCAN_TIMER, true)
		COOLDOWN_SCAN_TIMER = Hermes:ScheduleTimer("OnUpdateSenderCooldowns", 0.1, nil) --convert to one shot timer
		Hermes:CancelTimer(COOLDOWN_SCAN_TIMER, true) --cancel again, we don't care if it ran or not
		COOLDOWN_SCAN_TIMER = nil
	end
end

function core:StartCooldownScanTimer(delay)
	COOLDOWN_SCAN_TIMER = Hermes:ScheduleRepeatingTimer("OnUpdateSenderCooldowns", delay, delay)
end

function core:GetLocalizedClassName(classToken)
	local localizedClassName
	if(classToken == "ANY") then
		return L["Any"]
	else
		return LOCALIZED_CLASS_NAMES[classToken]
	end
end

function core:SortProfileSpells(a, b)
	return a.name < b.name
end

function core:SortProfileItems(a, b)
	return a.name < b.name
end

function core:GetSpellID(spell)
	local matches = {}
	for i = 1, 100000 do
		name, rank, icon, powerCost, _, powerType, castingTime, minRange, maxRange = GetSpellInfo(i)
		if name == spell then
			tinsert(matches, i)
		end
	end
	
	return matches
end

function core:EncodeAbilityId(id, trackertype)	--spells have positive id's, items have negative id's, returns the type and a positive id
	if(trackertype == "spell") then
		return abs(id)
	elseif(trackertype == "item") then
		return abs(id) * -1
	else
		error("unknown encode type")
	end
end

function core:GetNextItemIdToCache(currentId)
	local lastIndex = nil
	local nextIndex = nil
	for i, item in ipairs(dbp.items) do
		if(lastIndex and item.caching) then
			nextIndex = i
			break
		end
		if(item.id == currentId) then
			lastIndex = i
		end
	end
	
	--it's possible there weren't any items needing caching ocurring after the last item,
	--so start from beginning and take the first match. This will also restart the current item if it's the first one
	if(lastIndex and not nextIndex) then
		for i, item in ipairs(dbp.items) do
			if(item.caching) then
				nextIndex = i
				break
			end
		end
	end
	
	if(nextIndex) then
		return dbp.items[nextIndex].id
	end
end

function core:KillItemNameTimer()
	if(ITEM_NAME_TIMER) then
		Hermes:CancelTimer(ITEM_NAME_TIMER, true)
		ITEM_NAME_TIMER = nil
	end
end

function core:StartItemNameTimer(id)
	--don't kick off the timer if it's already running, it's smart enough to restart itself
	if(ITEM_NAME_TIMER == nil) then
		--if it wasn't already running, then make the first one 10 seconds for quicker initial response of a new item
		ITEM_NAME_TIMER = Hermes:ScheduleTimer("OnUpdateItemNameTimer", 5, id)
	end
end

--------------------------------------------------------------------
-- Special Handling for DK Rune Cooldowns
-- Only spells using runes that actually have a cooldown need to be listed
-- This algorithm will only work properly so long as all cooldowns using
-- runes are greater than the rune duration of 10 (or 9 depending on talents) seconds.
--------------------------------------------------------------------
local runeSpells = {
	[51052] = 0, -- Anti-Magic Zone -- 2 min
	[42650] = 0, -- Army of the Dead -- 10 min
	[49222] = 0, -- Bone Shield -- 1 min
	[43265] = 0, -- Death and Decay -- 30 sec
	[50977] = 0, -- Death Gate 1 min
	[51271] = 0, -- Pillar of Frost -- 1 min
	[48982] = 0, -- Rune Tap -- 30 sec
	[47476] = 0, -- Strangulate -- 2 min
}

function core:AdjustForRunes(tracker)
	local runeSpell = runeSpells[tracker.id]
	if (runeSpell and tracker.duration and tracker.duration <= 10) then --10 seconds is good enough. Checking for talents and 9 is not worth the trouble
		return true
	end
	
	return false
end

------------------------------------------------------------------
-- GENERAL HELPERS
------------------------------------------------------------------
function core:ShowHermesTestModeMessage()
	local message = "|cff19FF19Hermes: "..L["Config Mode"].."|r\n\n"
	message = message ..L["Hermes is running in Config Mode."].."\r\n"..L["Toggle it on or off in the 'General' settings tab."].."\n\n"
	StaticPopupDialogs["HermesConfigMode"] = {
		text = message, 
		button1 = L["Edit Settings"],
		button2 = L["Close"],
		timeout = 0,
		whileDead = 1, 
		hideOnEscape = 1, 
		OnAccept = function() core:OpenConfigWindow() end,
		OnCancel = function() end
	}
	StaticPopup_Show("HermesConfigMode")
	dbp.welcome = true
end

function core:ShowMessageBox(text)
	StaticPopupDialogs["HermesMessageBox"] = {
		text = text, 
		button1 = L["Close"],
		timeout = 0,
		whileDead = 1, 
		hideOnEscape = 1, 
		OnAccept = function() end
	}
	StaticPopup_Show("HermesMessageBox")
end

function core:StartTestMode()
	--set the test mode bit
	dbp.configMode = true
	
	--we may already be a raid or party or some such, stop sending and receiving if we are so they we start with a clean slate
	if Hermes:IsSending() == true then
		core:StopSending()
	end
	if Hermes:IsReceiving() == true  then
		core:StopReceiving()
	end
	
	--force sending and receiving to start in test mode
	core:UpdateCommunicationsStatus()
end

function core:StopTestMode()
	--set the test mode bit
	dbp.configMode = false
	
	--make sure we completely reset the sending/receiving state
	core:StopSending()
	core:StopReceiving()
	
	--force sending and receiving to start (if applicable)
	core:UpdateCommunicationsStatus()
end

------------------------------------------------------------------
-- PLUGIN API
------------------------------------------------------------------
function core:EnablePlugins()
	for name, plugin in pairs(Plugins) do
		--only startup plugins that are enabled or don't exist in the profile (assumes they're new)
		if dbp.pluginState[name] == nil then
			dbp.pluginState[name] = true
		end
		if dbp.pluginState[name] == true then
			core:EnablePlugin(name)
		end
	end
end

function core:EnablePlugin(name)
	local plugin = Plugins[name]
	if plugin.OnSetProfileCallback then
		plugin.OnSetProfileCallback(dbp.plugins)
	end
	if plugin.OnEnableCallback then
		plugin.OnEnableCallback()
	end
end

function core:DisablePlugins()
	for name, plugin in pairs(Plugins) do
		core:DisablePlugin(name)
	end
end

function core:DisablePlugin(name)
	local plugin = Plugins[name]
	--only stop plugins that are enabled.
	--note that if the profile was reset, then dbp.pluginState[name] will be nil which means we need to shutdown any prior instances
	if (dbp.pluginState[name] == nil or dbp.pluginState[name] == true) and plugin.OnDisableCallback then
		plugin.OnDisableCallback()
	end
end

------------------------------------------------------------------
-- SENDERS
------------------------------------------------------------------
local SenderStatusTimer = nil
local SENDER_STATUS_UPDATE_FREQUENCY = 1

function core:RemoveAllSenders()
	while #Senders > 0 do
		core:RemoveSender(Senders[1])
	end
end

function core:FindSenderByName(name)
	for _, sender in ipairs(Senders) do
		if(name == sender.name) then
			return sender
		end
	end
	
	return nil
end

function core:AddSender(name, class, virtual)
	sender = {
		name = name,
		class = class,
		online = true, --assume online
		dead = false, --assume alive
		created = GetTime(), --tracks the time the sender was first created
		virtual = virtual, --tracks if external sender
		visible = nil,
	}
	
	tinsert(Senders, sender)
	
	--update sender but do not allow events to be sent
	core:UpdateSenderStatus(sender, nil)
	
	--now call the event
	core:FireEvent("OnSenderAdded", sender)
end

function core:RemoveSender(sender)
	--first remove all instances of the sender in abilities
	core:RemoveAbilityInstancesForSender(sender)
	
	--call the event
	core:FireEvent("OnSenderRemoved", sender)
	
	--now delete from table
	_deleteIndexedTable(Senders, sender)
end

function core:StopSenderStatusTimer()
	if(SenderStatusTimer) then
		Hermes:CancelTimer(SenderStatusTimer, true)
		SenderStatusTimer = Hermes:ScheduleTimer("OnSenderStatusTimer", 0.1, nil) --convert to one shot timer
		Hermes:CancelTimer(SenderStatusTimer, true) --cancel again, we don't care if it ran or not
		SenderStatusTimer = nil
	end
end

function core:StartSenderStatusTimer()
	SenderStatusTimer = Hermes:ScheduleRepeatingTimer("OnSenderStatusTimer", SENDER_STATUS_UPDATE_FREQUENCY, nil)
end

function core:UpdateSenderStatus(sender, allowEvents)
	local _wasAvailable = nil
	local _isAvailable = nil
	local _oldOnline = nil
	local _oldDead = nil
	local _oldVisible = nil

	if allowEvents then
		--remember sender state for events later
		_oldOnline = sender.online
		_oldDead = sender.dead
		_oldVisible = sender.visible
		_wasAvailable = Hermes:IsSenderAvailable(sender)
	end
	
	--update sender properties
	if Player.raid then
		local raidId = UnitInRaid(sender.name)
		if raidId then
			local name, _, _, _, _, _, _, online, dead, _, _ = GetRaidRosterInfo(raidId)
			if(name == sender.name) then
				sender.online = online == 1
				sender.dead = dead == 1
			else
				error("Unexpected sender status during UpdateSenderStatus")
			end
		else
			--sender dropped from raid
			core:RemoveSender(sender)
			return --don't send any more events
		end
		
	elseif Player.party then
		if UnitInParty(sender.name) then
			--sender.online = true
			sender.online = UnitIsConnected(sender.name) == 1
			sender.dead = UnitIsDead(sender.name) == 1 or UnitIsGhost(sender.name) == 1
		else
			--sender dropped from party
			core:RemoveSender(sender)
			return --don't send any more events
		end
	else
		--config mode
		sender.online = true
		sender.dead = UnitIsDead(sender.name) == 1 or UnitIsGhost(sender.name) == 1
	end
	
	--bugfix for v2.3. UnitIsVisible will return nil for self on PLAYER_LOGIN, but not PLAYER_ENTERED_WORLD
	--if when you login Hermes is sending.
	if sender.name ~= Player.name then
		sender.visible = UnitIsVisible(sender.name)
	else
		sender.visible = 1
	end
	
	--see if sender is available again
	_isAvailable = Hermes:IsSenderAvailable(sender)
	
	--update visibility changes, but don't update if yourself
	if allowEvents and _oldVisible ~= sender.visible and Player.name ~= sender.name then
		core:FireEvent("OnSenderVisibilityChanged", sender)
	end
		
	--update online changes	
	if allowEvents and _oldOnline ~= sender.online then
		core:FireEvent("OnSenderOnlineChanged", sender)
	end
		
	--update dead changes
	if allowEvents and _oldDead ~= sender.dead then
		core:FireEvent("OnSenderDeadChanged", sender)
	end
		
	--update availability changes
	if _wasAvailable ~= _isAvailable then
		--fire event about the sender status changing
		if allowEvents then
			core:FireEvent("OnSenderAvailabilityChanged", sender)
		end
			
		--now fire events for any ability and ability instances being tracked that belong to this sender
		if allowEvents then
			for _, instance in ipairs(AbilityInstances) do
				if(instance.sender == sender) then
					--fire event on instance
					if allowEvents then
						core:FireEvent("OnAbilityAvailableSendersChanged", instance.ability)
						core:FireEvent("OnAbilityInstanceAvailabilityChanged", instance)
					end
				end
			end
		end
	end
end

------------------------------------------------------------------
-- PLAYER
------------------------------------------------------------------
function core:InitializePlayer()
	Player.name = UnitName("player")
	Player.class = core:GetClassEnum(select(2, UnitClass("player")))
	Player.raid = false
	Player.party = false
	Player.battleground = false
	PLAYER_IS_WARLOCK = Player.class == core:GetClassEnum("WARLOCK")
end

function core:UpdatePlayerGroupStatus()
	local wasInGroup = Player.raid == true or Player.party == true or Player.battleground == true
	
	if(GetNumRaidMembers() > 0) then
		Player.raid = true
	else
		Player.raid = false
	end
	
	if(GetNumPartyMembers() > 0) then
		Player.party = true
	else
		Player.party = false
	end
	
	if(UnitInBattleground("player") ~= nil) then
		Player.battleground = true
	else
		Player.battleground = false
	end
	
	local isInGroup = Player.party == true or Player.raid == true or Player.battleground == true
	
	if (wasInGroup == true and isInGroup == false) or (wasInGroup == false and isInGroup == true) then
		core:FireEvent("OnPlayerGroupStatusChanged", isInGroup)
	end
end

------------------------------------------------------------------
-- ABILITIES
------------------------------------------------------------------
function core:StopTrackingAllAbilities()
	if Hermes:IsReceiving() == true then --prevent endless loop in case I'm an idiot
		while #Abilities > 0 do
			core:StopTrackingAbility(Abilities[1].dbp)
		end
	end
end

function core:FindTrackedAbility(dbability)
	for _, ability in ipairs(Abilities) do
		if ability.dbp == dbability then
			return ability
		end
	end
	
	return nil
end

function core:FindTrackedAbilityById(id)
	for _, ability in ipairs(Abilities) do
		if ability.id == id then
			return ability
		end
	end
	
	return nil
end

function core:StartTrackingAbility(dbability, nosend) --message will only be sent if nosend is not supplied
	if not dbability then error("null ability") end
									
	--tinsert(Abilities, ability)
	
	--call events
	--core:FireEvent("OnAbilityAdded", ability)
	
	--if receiving, then request update from senders and also look for virtual users
	if Hermes:IsReceiving() == true then
		ability = {
			id = dbability.id,
			name = dbability.name,
			class = dbability.class,
			icon = dbability.icon,
			dbp = dbability,
			created = GetTime(), --track when this ability was created
		}

		tinsert(Abilities, ability)
		core:FireEvent("OnAbilityAdded", ability)
		
		if not nosend then
			core:RequestAbilityUpdate(ability.id)
		end
		if core:CanCreateVirtualInstance(ability) then
			core:ResetVirtualInstancesForAbility(ability.id)
		end
	end
end

function core:StopTrackingAbility(dbability)
	if not dbability then error("null dbp") end
	
	if Hermes:IsReceiving() == true then
		local ability = core:FindTrackedAbility(dbability)
		
		if not ability then error("null ability") end
		
		--first remove any ability instances
		core:RemoveAbilityInstancesForAbility(ability)
		
		--call events
		core:FireEvent("OnAbilityRemoved", ability)
		
		--now delete from table
		_deleteIndexedTable(Abilities, ability)
	end
end

function core:AddSpell(newSpellId, newSpellName, newSpellClass)
	--see if the spell exists
	local name
	local icon
	if(newSpellId) then
		name, _, icon, _, _, _, _, _, _ = GetSpellInfo(newSpellId)
	else
		--try to find the spell id for the given spell name
		local matches = core:GetSpellID(newSpellName)
		
		if(matches and #matches > 0) then
			--still need the icon
			newSpellId = matches[1]
			name, _, icon, _, _, _, _, _, _ = GetSpellInfo(newSpellId)
			if(#matches > 1) then
				--there are more than one spellid from the name given, ask the user which they want to use
				local message = L["|cFFFF0000Hermes Warning|r"].." "..L["multiple id's were found. The first id was chosen"]
				print(message)
			end
		end
	end
	
	if(name and icon) then
		--make sure we're not already tracking this spell
		local id = core:EncodeAbilityId(newSpellId, "spell")
		for i, spell in ipairs(dbp.spells) do
			if(spell.id == id) then
				local message = L["|cFFFF0000Hermes Warning|r"].." "..L["spell has already been added"]
				print(message)
				return nil
			end
		end
		
		local spell = {
			class = newSpellClass,
			id = tonumber(id),
			name = name,
			icon = icon,
			enabled = true, --assume they want to track right away
		}
		
		--add to db
		tinsert(dbp.spells, spell)
		
		--sort the spells
		sort(dbp.spells, function(a, b) return core:SortProfileSpells(a, b) end)

		--update any spell monitor data if it exists but this spell hasn't been added before
		self:UpdateSMSSpellCooldown(spell.id, nil)
		self:UpdateSMSSpellRequirements(spell.id, spell.class, nil)
		self:UpdateSMSSpellAdjustments(spell.id, spell.class, nil)
					
		core:FireEvent("OnInventorySpellAdded", spell.id)
					
		--enable tracking
		--NEW CHANGE
		if Hermes:IsReceiving() == true then
			core:StartTrackingAbility(spell)
		end
		
		return 1
	else
		local message = L["|cFFFF0000Hermes Warning|r"].." "..L["spell name or id not found"]
		print(message)
		return nil
	end
end

function core:DeleteSpell(spell)
	--stop tracking it if needed
	local ability = core:FindTrackedAbility(spell)
	if ability then
		core:StopTrackingAbility(spell)
	end
	
	--delete from profile
	_deleteIndexedTable(dbp.spells, spell)
	
	core:FireEvent("OnInventorySpellRemoved", spell.id)
end

function core:AddItem(newItemId, newItemName, newItemClass)
	local id, name, icon = core:GetItemInfo(newItemId, newItemName)
	if(not icon) then
		local message = L["|cFFFF0000Hermes Warning|r"].." "..L["Item name or id not found. If you're confident the id or name is correct, try having someone link the item or putting the item in your inventory and adding again."]
		print(message)
		return nil
	end
	
	if(icon and id) then
		id = core:EncodeAbilityId(tonumber(id), "item")
		--make sure we're not already tracking this item
		for i, item in ipairs(dbp.items) do
			if(item.id == tonumber(id)) then
				local message = L["|cFFFF0000Hermes Warning|r"].." "..L["Item has already been added"]
				print(message)
				return nil
			end
		end
		
		--we need to cache the item
		local caching = nil
		if(not name) then
			caching = 1
			name  = "..."..L["searching"].." ("..tostring(Hermes:AbilityIdToBlizzId(tonumber(id)))..")"
		end
		
		local item = {
			class = newItemClass,
			id = tonumber(id),
			name = name,
			icon = icon,
			enabled = true,
			caching = caching
		}
		
		--add to db
		tinsert(dbp.items, item)
		
		--sort the spells
		sort(dbp.items, function(a, b) return core:SortProfileItems(a, b) end)

		core:FireEvent("OnInventoryItemAdded", item.id)
		
		--enable tracking
		core:StartTrackingAbility(item)
		
		--fire off the name cache timer if needed
		if(caching) then
			core:StartItemNameTimer(item.id)
		end
		
		return 1
	end
	
	return nil
end

function core:DeleteItem(item)
	--stop tracking it if needed
	local ability = core:FindTrackedAbility(item)
	if ability then
		core:StopTrackingAbility(item)
	end
	
	--delete from profile
	_deleteIndexedTable(dbp.items, item)
	
	core:FireEvent("OnInventoryItemRemoved", item.id)
end

------------------------------------------------------------------
-- ABILITY INSTANCES
------------------------------------------------------------------
local _keepRunning = false
local function OnAbilityInstanceFrameUpdate(frame, elapsed)
	frame.LastScan = frame.LastScan + elapsed;
	while (frame.LastScan > SCAN_FREQUENCY) do
		_keepRunning = false
		frame.LastScan = frame.LastScan - SCAN_FREQUENCY
		for _, instance in ipairs(AbilityInstances) do
			if not instance.remaining then
				--do nothing, it's not on cooldown
			else
				--update remaining time
				instance.remaining = instance.initialDuration - (GetTime()- instance.initialTimeStamp)
			
				if instance.remaining <= 0 then
					--item just went off cooldown
					instance.remaining = nil
					instance.initialDuration = nil
					instance.initialTimeStamp = nil
					
					core:FireEvent("OnAbilityAvailableSendersChanged", instance.ability) -- ADDED
					core:FireEvent("OnAbilityInstanceStopCooldown", instance)
				else
					--item still on cooldown
					core:FireEvent("OnAbilityInstanceUpdateCooldown", instance)
					
					--allow the OnUpdate script to continue running
					_keepRunning = true
				end
			end
		end
		
		--if there's nothing with a remaining time, then kill the script
		if _keepRunning == false then
			core:StopTrackingAbilityInstances()
		end
	end
end

function core:InitializeAbilityInstanceFrame()
	--this frame manages all OnUpdate callbacks
	core.AbilityInstanceFrame = CreateFrame("Frame", nil, UIParent)
	core.AbilityInstanceFrame:ClearAllPoints()
	core.AbilityInstanceFrame:EnableMouse(false)
	core.AbilityInstanceFrame:SetMovable(false)
	core.AbilityInstanceFrame:SetToplevel(false)
end

function core:StartTrackingAbilityInstances()
	core.AbilityInstanceFrame.LastScan = 0
	core.AbilityInstanceFrame:SetScript("OnUpdate", OnAbilityInstanceFrameUpdate)
end

function core:StopTrackingAbilityInstances()
	core.AbilityInstanceFrame:SetScript("OnUpdate", nil)
end

function core:RemoveAllAbilityInstances()
	while #AbilityInstances > 0 do
		core:RemoveAbilityInstances(AbilityInstances[1])
	end
end

function core:AddVirtualInstance(senderName, classEnum, spellid, duration, shared)
	local ability = nil
	for _, a in ipairs(Abilities) do
		if a.id == spellid and (a.class == classEnum or a.class == "ANY") then
			ability = a --we're tracking it
			break
		end
	end

	--ignore virtual abilities if they're not being tracked
	if(ability) then
		--find the sender
		local sender = core:FindSenderByName(senderName)
		--only support virtual senders
		if sender and sender.virtual then
			core:SetAbilityInstance(ability, sender, duration)
		end
	end
	
	if not shared then
		--look for any shared cooldowns and add that if necessary too
		local sharedId = SHARED_COOLDOWNS[spellid]
		if sharedId then
			core:AddVirtualInstance(senderName, classEnum, sharedId, duration, true)
		end
	end
end

function core:SetAbilityInstance(ability, sender, duration)
	--first see if one already exists
	local instance = core:FindAbilityInstance(ability, sender)
	local timeStamp = nil
	
	--only set a timestamp if there is an actual duration
	if duration then
		timeStamp = GetTime()
	end
	
	if not instance then
		--new instance, set it as though it's available initially, if it's not, another message will be sent with appropriate data
		instance = {
			ability = ability,
			sender = sender,
			initialDuration = nil,
			initialTimeStamp = nil,
			remaining = nil,
			created = GetTime(), --remember when the instance was created
		}
		
		tinsert(AbilityInstances, instance)

		--fire off an added event since it's new
		core:FireEvent("OnAbilityTotalSendersChanged", instance.ability) -- ADDED
		core:FireEvent("OnAbilityAvailableSendersChanged", instance.ability) -- ADDED
		core:FireEvent("OnAbilityInstanceAdded", instance)
		
		--if it's on cooldown, then start it
		if duration then
			instance.initialDuration = duration
			instance.initialTimeStamp = timeStamp
			instance.remaining = duration
			core:FireEvent("OnAbilityAvailableSendersChanged", instance.ability) -- ADDED
			core:FireEvent("OnAbilityInstanceStartCooldown", instance)
		end
	else
		--existing instance, update it to reflect changes
		local lastRemaining = instance.remaining
		
		instance.initialDuration = duration
		instance.initialTimeStamp = timeStamp
		instance.remaining = duration

		--if it's on cooldown, then possibly start it
		if duration then
			--only start it if it wasn't on cooldown preivously, or if the difference in the previous cooldown value and the new one is greater than the specified threshold.
			--this helps cleanup events that can fire due to the Hermes handshaking that goes on
			if not lastRemaining or (lastRemaining and abs(lastRemaining - duration) > DELTA_THRESHOLD_FOR_REMAINING_CHANGE) then
				core:FireEvent("OnAbilityAvailableSendersChanged", instance.ability) -- ADDED
				core:FireEvent("OnAbilityInstanceStartCooldown", instance)
			end
		end
		
		--if it's not on cooldown, and it was on cooldown the last time we updated it, then fire off stop message.
		--otherwise there's no need to fire any events since status didn't change
		if not duration and lastRemaining then
			core:FireEvent("OnAbilityAvailableSendersChanged", instance.ability) -- ADDED
			core:FireEvent("OnAbilityInstanceStopCooldown", instance)
		end
	end
		
	--start OnUpdate script if not already running and this instance has a duration
	if duration and not core.AbilityInstanceFrame:GetScript("OnUpdate") then
		core:StartTrackingAbilityInstances()
	end
end

function core:FindAbilityInstance(ability, sender)
	for _, instance in ipairs(AbilityInstances) do
		if(instance.ability == ability and instance.sender == sender) then
			return instance
		end
	end
	
	return nil
end

function core:RemoveAbilityInstance(instance)
	--now delete from table
	_deleteIndexedTable(AbilityInstances, instance)
	--call the events AFTER we removed the values, otherwise calls such as GetAbilityStats will return an incorrect number of senders
	core:FireEvent("OnAbilityAvailableSendersChanged", instance.ability) -- ADDED
	core:FireEvent("OnAbilityTotalSendersChanged", instance.ability) -- ADDED
	core:FireEvent("OnAbilityInstanceRemoved", instance)
	
	--stop OnUpdate script if nothing to track
	if #AbilityInstances == 0 and core.AbilityInstanceFrame:GetScript("OnUpdate") then
		core:StopTrackingAbilityInstances()
	end
end

function core:RemoveAbilityInstancesForAbility(ability)
	local items = {}
	
	--first find all the matches
	for _, instance in ipairs(AbilityInstances) do
		if instance.ability == ability then
			tinsert(items, instance)
		end
	end
	
	--now remove each match
	for _, instance in ipairs(items) do
		core:RemoveAbilityInstance(instance)
	end
end

function core:RemoveAbilityInstancesForSender(sender)
	local items = {}
	
	--first find all the matches
	for _, instance in ipairs(AbilityInstances) do
		if instance.sender == sender then
			tinsert(items, instance)
		end
	end
	
	--now remove each match
	for _, instance in ipairs(items) do
		core:RemoveAbilityInstance(instance)
	end
end

------------------------------------------------------------------
-- COMBAT LOG STUFF
------------------------------------------------------------------
function core:ProcessRace(playerName)
	local race, nlrace = UnitRace(playerName)
	--todo, update spell monitor stuff?
	if race and nlrace then
		if not dbg.races[nlrace] then
			dbg.races[nlrace] = race
		end
	end
end

function core:ProcessPlayer(guid, name, class, talents)
	local isnew = nil
	
	if not Players[guid] then
		Players[guid] = {
			
		}
		isnew = 1
	end
	
	local player = Players[guid]
	
	player.name = name
	player.class = class
	
	return player, isnew
end

-------------------------------------------------------------------
-- DURATION ENGINE
-------------------------------------------------------------------
function core:ResetVirtualInstancesForAbility(id)
	for playerGuid, player in pairs(Players) do
		local sender = core:FindSenderByName(player.name)
		if sender and sender.virtual then
			--now go ahead and fire off a virtual instance for each spell if applicable
			local duration = player.spellcache[id]
			-- if the player qualifies for this spell
			if duration then
				--update cooldown values, some may have expired or duration needs to be updated.
				core:ResyncCooldowns(player)
				local remaining = core:GetPlayerCooldown(player, id)
				core:AddVirtualInstance(player.name, player.class, id, remaining)
			end
		end
	end
end

function core:ResetNonHermesPlayers()
	--some sanity checks for debugging
	if Hermes:IsReceiving() then
		--we need to kill our virtual senders
		for _, sender in ipairs(Senders) do
			if sender.virtual then
				self:RemoveSender(sender)
			end
		end
	end
	
	--rebuild cache and look for potential non virtual senders to create
	for playerGuid, player in pairs(Players) do
		--rebuild spell cache for each player
		self:BuildPlayerSpellCache(player)
		--clear any cooldowns that are no longer reliable
		self:ResyncCooldowns(player) -- NOTE: This is absolutely required, otherwise the cooldown gets out of sync
		if Hermes:IsReceiving() then
			local sender = core:FindSenderByName(player.name)
			if not sender then
				core:AddSender(player.name, core:GetClassEnum(player.class), 1)
				--now go ahead and fire off a virtual instance for each spell
				for id, duration in pairs(player.spellcache) do
					local ability = core:FindTrackedAbilityById(id)
					if core:CanCreateVirtualInstance(ability) then
						local remaining = core:GetPlayerCooldown(player, id)
						core:AddVirtualInstance(player.name, player.class, id, remaining)
					end
				end
			end
		end
	end
end

function core:GetPlayerCooldown(player, id)
	local guid = core:GetKeyForTable(Players, player)	--find the guid of the player
	local cooldowns = dbg.cooldowns[guid]				--see if there are any values for this player
	
	if cooldowns then
		if cooldowns[id] then
			return cooldowns[id][2]
		end
	end

	return nil
end

function core:SetPlayerCooldown(player, id, duration)
	local guid = core:GetKeyForTable(Players, player)	--find the guid of the player
	local cd = dbg.cooldowns[guid]
	
	--if duration is nil, then we want to remove the cooldown
	if not duration then
		if cd then
			cd[id] = nil
			--see if we need to remove the entry for the player completely
			if _tableCount(cd) == 0 then
				dbg.cooldowns[guid] = nil
			end
		end
	else
		if not cd then
			--create new table
			dbg.cooldowns[guid] = {}
			cd = dbg.cooldowns[guid]
		end
		cd[id] = { GetTime(), duration }
	end
end

function core:SyncServerTimeToClient()
	if not dbg.serverTime or not dbg.clientTime then
		dbg.serverTime = time()
		dbg.clientTime = GetTime()
		return 1 --we need to refresh all GetTime values
	else
		--handle any odd server behavior, who knows
		if dbg.serverTime > time() then
			--maybe the server's time clock got jacked?
			return 1
		end
		
		local deltaOld = dbg.serverTime - dbg.clientTime
		
		dbg.serverTime = time()
		dbg.clientTime = GetTime()
		
		local deltaNew = dbg.serverTime - dbg.clientTime
		local deltaNow = abs(deltaOld - deltaNew)
		
		return deltaNow >= INVALIDATE_TIME_THRESHOLD
	end
end

function core:WipeAllCooldowns()
	if dbg.cooldowns then wipe(dbg.cooldowns) end dbg.cooldowns = {}
end

function core:GetKeyForTable(tbl, item)
	for k, v in pairs(tbl) do
		if v == item then
			return k
		end
	end
	
	return nil
end

function core:ResyncCooldowns(player)
	local guid = core:GetKeyForTable(Players, player)	--find the guid of the player
	local cooldowns = dbg.cooldowns[guid]			--see if there are any values for this player
	
	if cooldowns then
		for id, v in pairs(cooldowns) do
			if not player.spellcache[id] then
				--spell isn't known/valid for this player anymore, remove it
				cooldowns[id] = nil
			else
				--update the timestamp and cooldown values
				local now = GetTime()
				local delta = now - v[1]
				v[1] = now
				v[2] = v[2] - delta

				--see if the cooldown is still valid
				if v[2] <= 0 then
					--the spell has long since become available again.
					--since we have no way to know if they've used it came off cooldown, remove it
					cooldowns[id] = nil
				else
					--print("spell is still on cooldown, keeping!")
				end
			end
		end
	end
end

function core:GetUnitFromName(name)
	--it's very annoying but a lot of blizzard functions that return
	--data I'm interested in operate on the unit level, and unit functions
	--don't always accept a player's name as a valid value. So I need to loop
	--through party or raid members to get their current unit id (which also
	--changes of course so I can't just store it)
	if name == UnitName("player") then return "player" end
	
	local numRaidMembers = GetNumRaidMembers()
	local numPartyMembers = GetNumPartyMembers()
	
	if numRaidMembers > 0 then
		for i = 1, numRaidMembers do
			local unit = "raid"..i
			if UnitName(unit) == name then
				return unit
			end
		end
	elseif numPartyMembers > 0 then
		for i = 1, numPartyMembers do
			local unit = "party"..i
			if UnitName(unit) == name then
				return unit
			end
		end
	else
		--error("this function wasn't supposed to be called while not in a group. Please report to author")
	end
	
	--error("failed to locate unit for player. Please report to author")
	
	return nil
end

function core:CheckName(unit, name)
	return UnitName(unit) == name
end

function core:CheckNames(unit, names)
	if not names then return true end
	if string.len(names) == 0 then return true end
	
	for v in string.gmatch(names, "[^ ]+") do
		if core:CheckName(unit, v) == true then
			return true
		end
	end
	
	return false
end

function core:CheckLevel(unit, level)
	return UnitLevel(unit) >= level
end

function core:CheckRace(unit, race)
	return UnitRace(unit) == race
end

function core:CheckTalentName(unit, talent, rank)
	local r = MOD_Talents:GetUnitTalentRank(unit, talent)
	return r and r >= rank
end

function core:CheckTalentSpec(unit, spec)
	local s = MOD_Talents:GetUnitPrimaryTree(unit) --returns the name of the primary talent tree
	return s == spec
end

function core:CheckRequirement(unit, requirement)
	if requirement.k == REQUIREMENT_KEYS.PLAYER_LEVEL then
		return core:CheckLevel(unit, requirement.level)
		
	elseif requirement.k == REQUIREMENT_KEYS.PLAYER_RACE then
		return core:CheckRace(unit, requirement.race)
	
	elseif requirement.k == REQUIREMENT_KEYS.PLAYER_NAMES then
		return core:CheckNames(unit, requirement.names)
		
	elseif requirement.k == REQUIREMENT_KEYS.TALENT_NAME then
		return core:CheckTalentName(unit, requirement.talname, requirement.talrank)
		
	elseif requirement.k == REQUIREMENT_KEYS.TALENT_SPEC then
		return core:CheckTalentSpec(unit, requirement.talspec)
		
	end
end

function core:CheckSpellRequirements(unit, spellid)
	--if we make it through all of the requirements without one returning nil, then return success
	for reqSpellId, reqs in pairs(dbg.requirements) do
		if reqSpellId == spellid then
			--loop through the requirements of this spell
			for reqindex, req in ipairs(reqs) do
				if not core:CheckRequirement(unit, req) then
					return nil
				end
			end
		end
	end

	return 1
end

function core:GetAdjustmentOffset(unit, adjustment)

	if adjustment.k == ADJUSTMENT_KEYS.PLAYER_NAME then
		if core:CheckName(unit, adjustment.name) == true then
			return adjustment.o
		end
		
	elseif adjustment.k == ADJUSTMENT_KEYS.PLAYER_LEVEL then
		if core:CheckLevel(unit, adjustment.level) == true then
			return adjustment.o
		end
		
	elseif adjustment.k == ADJUSTMENT_KEYS.TALENT_NAME then
		if core:CheckTalentName(unit, adjustment.talname, adjustment.talrank) == true then
			return adjustment.o
		end
		
	elseif adjustment.k == ADJUSTMENT_KEYS.TALENT_SPEC then
		if core:CheckTalentSpec(unit, adjustment.talspec) == true then
			return adjustment.o
		end
	end
	
	return nil --no offset
end

function core:GetAdjustedDuration(unit, spellid, duration)
	local adjusted = duration
	--if we make it through all of the requirements without one returning nil, then return success
	for adjSpellId, adjs in pairs(dbg.adjustments) do
		if adjSpellId == spellid then
			--loop through the adjustments of this spell
			for adjindex, adj in ipairs(adjs) do
				local offset = core:GetAdjustmentOffset(unit, adj)
				if offset then
					adjusted = adjusted + offset
				end
			end
		end
	end

	return adjusted
end

function core:BuildPlayerSpellCache(player)
	if player.spellcache then wipe(player.spellcache) end player.spellcache = {}
	
	local unit = core:GetUnitFromName(player.name)
	if not unit then
		--error("GetUnitFromName returned nil")
		return nil --something wrong happened, just return as though they didn't meet requirement. I've seen this before after reloading UI while in a raid
	end 
	
	for _, spell in ipairs(dbp.spells) do
		if (spell.class == "ANY" or spell.class == player.class) and core:CheckSpellRequirements(unit, spell.id) then
			--spells without a base duration are NOT followed through with
			local cds = dbg.durations[spell.id]
			if cds and dbg.classes[player.class] then
				local duration = core:GetAdjustedDuration(unit, spell.id, cds)
				player.spellcache[spell.id] = duration
			end
		end
	end
end

------------------------------------------------------------------
-- OPTIONS
------------------------------------------------------------------
local optionTables = nil

local newSpellTemplate = {
	class = L["-- Select --"],
	id = nil,
	name = nil,
}

local newItemTemplate = {
	class = L["-- Select --"],
	id = nil,
	name = nil,
}

function core:OpenConfigWindow()
	LIB_AceConfigDialog:Open(HERMES_VERSION_STRING)
end

local slashCommands = {
	name = "Hermes Command Line",
	handler = Hermes,
	type = 'group',
	args = {
		config = {
			type = "execute",
			name = L["Open Configuration"],
			order = 0,
			func = function(info) core:OpenConfigWindow() end,
		},
    },
}

function core:LoadDefaultOptions()
	local defaults = {
		global = {
			races = {},
			durations = {},
			cooldowns = {},		--remembers cooldown state for non hermes users
			requirements = {},
			adjustments = {},
			spellmetadata = {}, --used to store generic key/value pairs used by plugins
			classes = {},
		},
		profile = {
			combatLogging = true,
			enabled = true,
			enableparty = false,
			configMode = true,
			sender = { enabled = true },
			receiver = { enabled = true },
			spells = {},
			items = {},
			plugins = {},
			pluginState = { --stores which plugins are enabled or disabled
				["HermesUI"] = true --make the built in UI enabled by default
			},
		},
	}
	
	Hermes.db = LIB_AceDB:New("HermesDB2", defaults)
end

--remember which spell we're configuring and what mode
local CONFIGURE_SETTINGS = {
	mode = "list",
	spell = nil,
	spellid = nil,
}

local newRequirementTemplate = {
	type = nil,
	race = nil,
	level = MAX_PLAYER_LEVEL,
	names = nil,
	talentSpec = nil,
	talentName = nil,
	talentMinRank = 1,
	talentMaxRank = 5,
	talentRank = 1,
}

local function ResetRequirementTemplate()
	newRequirementTemplate.type = nil
	newRequirementTemplate.race = nil
	newRequirementTemplate.level = MAX_PLAYER_LEVEL
	newRequirementTemplate.names = nil
	newRequirementTemplate.talentSpec = nil
	newRequirementTemplate.talentName = nil
	newRequirementTemplate.talentMinRank = 1
	newRequirementTemplate.talentMaxRank = 5
	newRequirementTemplate.talentRank = 1
end

function core:IsRequirementTemplateComplete()
	local key = REQUIREMENT_KEYS[newRequirementTemplate.type]
	if key == REQUIREMENT_KEYS.PLAYER_RACE then
		return newRequirementTemplate.race ~= nil
	elseif key == REQUIREMENT_KEYS.PLAYER_LEVEL then
		return true
	elseif key == REQUIREMENT_KEYS.PLAYER_NAMES then
		return newRequirementTemplate.names ~= nil
	elseif key == REQUIREMENT_KEYS.TALENT_SPEC then
		return newRequirementTemplate.talentSpec ~= nil
	elseif key == REQUIREMENT_KEYS.TALENT_NAME then
		return newRequirementTemplate.talentName ~= nil
	elseif key == nil then
		return false
	else
		error("unknown key")
	end
end

local _lastClass = nil
local _talentSpecs = {}
local _talentNameKeys = {}
local _talentNameValues = {}
--only rebuild talent tree data when needed
local function refreshTalentLookups(class)
	if not _lastClass or _lastClass ~= class then
		_lastClass = class
		
		--build up talentSpec values
		_talentSpecs = {}
		_talentNameKeys = {}			--the keys in this table match the keys in the values table
		_talentNameValues = {}
		
		if dbg.classes then
			talentRoot = dbg.classes[class]
			if talentRoot then
				_talentSpecs[1] = talentRoot.trees[1]
				_talentSpecs[2] = talentRoot.trees[2]
				_talentSpecs[3] = talentRoot.trees[3]
				
				if talentRoot.tree and talentRoot.name and talentRoot.rank then
					for i, name in ipairs(talentRoot.name) do
						_talentNameKeys[i] = name
						_talentNameValues[i] = {
							index = i,
							name = name,
							rank = talentRoot.rank[i],
						}
					end
				end
			end
		end
		
		--sort the values and keys by name
		sort(_talentNameValues, function(a, b)
			return a.name < b.name
		end)
		
		sort(_talentNameKeys, function(a, b)
			return a < b
		end)
	end
end

function core:BlizOptionsTable_SpellConfig()
	local spellId = CONFIGURE_SETTINGS.spellid
	local spell = CONFIGURE_SETTINGS.spell
	local talentsexist = spell.class == "ANY" or dbg.classes[spell.class] ~= nil
	local clEnabled = dbp.combatLogging and dbp.combatLogging == true
	local spellMonitorDescription = L["Configure spell data for detection of non Hermes users."]
	local spellMonitorButtonName = L["Spell Monitor"].." |T"..""..":-0:-0:-0:-0|t" --forces a gap the same size as any other icon
	
	if not talentsexist then
		spellMonitorDescription = L["Spell Monitor is disabled until talents for this class are cached."]
	end
	
	if dbg.durations[spell.id] and talentsexist then
		spellMonitorButtonName = L["Spell Monitor"].." |T".."Interface\\RAIDFRAME\\ReadyCheck-Ready"..":0:0:0:0|t"
	end
			
	optionTables.args.Spells.args.listButton = {
		type = "execute",
		name = "<< "..L["List"],
		width = "normal",
		order = 5,
		func = function()
			CONFIGURE_SETTINGS.mode = "list"
			CONFIGURE_SETTINGS.spell = nil
			CONFIGURE_SETTINGS.spellid = nil
			LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
			self:BlizOptionsTable_Spells()
		end,
	}
	
	optionTables.args.Spells.args[tostring(spellId)] = {
		type = "group",
		inline = true,
		name = "|T"..spell.icon..":0:0:0:0|t "..spell.name.." "..L["Configuration"],
		order = 15,
		args = {
			spellmonitor = {
				type = "execute",
				--hidden = clEnabled == false,
				name = spellMonitorButtonName,
				width = "normal",
				order = 5,
				desc = spell.name,
				disabled = clEnabled == false or not talentsexist,
				func = function()
					CONFIGURE_SETTINGS.mode = "spellmonitor"
					CONFIGURE_SETTINGS.spell = spell
					CONFIGURE_SETTINGS.spellid = spell.id

					LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
					self:BlizOptionsTable_Spells()
				end,
			},
			spacer1 = {
				type = "description",
				width = "double",
				order = 10,
				name = spellMonitorDescription,
			},
			spacer1A = {
				type = "description",
				width = "full",
				order = 12,
				name = "",
			},
			metadata = {
				type = "execute",
				name = L["Metadata"],
				width = "normal",
				order = 15,
				func = function()
					CONFIGURE_SETTINGS.mode = "metadata"
					CONFIGURE_SETTINGS.spell = spell
					CONFIGURE_SETTINGS.spellid = spell.id
					LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
					self:BlizOptionsTable_Spells()
				end,
			},
			spacer2 = {
				type = "description",
				width = "double",
				order = 20,
				name = L["Configure spell metadata (advanced users only)."],
			},
			spacer2A = {
				type = "description",
				width = "full",
				order = 23,
				name = "",
			},
			delete = {
				type = "execute",
				name = L["Delete"],
				width = "normal",
				order = 25,
				desc = spell.name,
				func = function()
					core:DeleteSpell(spell)
					CONFIGURE_SETTINGS.mode = "list"
					CONFIGURE_SETTINGS.spell = nil
					CONFIGURE_SETTINGS.spellid = nil
					LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
					core:BlizOptionsTable_Spells()
					core:BlizOptionsTable_Maintenance()
				end,
				confirm = function() return L["Spell will be deleted. Continue?"] end,
			},
		},
	}
end

function core:BlizOptionsTable_SpellMetadata()
	local spellId = CONFIGURE_SETTINGS.spellid
	local spell = CONFIGURE_SETTINGS.spell
	
	optionTables.args.Spells.args.listButton = {
		type = "execute",
		name = "<< "..L["List"],
		width = "normal",
		order = 1,
		func = function()
			CONFIGURE_SETTINGS.mode = "list"
			CONFIGURE_SETTINGS.spell = nil
			CONFIGURE_SETTINGS.spellid = nil
			LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
			core:BlizOptionsTable_Spells()
		end,
	}
	
	optionTables.args.Spells.args.configButton = {
		type = "execute",
		name = "<< "..L["Configure"],
		width = "normal",
		order = 2,
		func = function()
			CONFIGURE_SETTINGS.mode = "config"
			LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
			core:BlizOptionsTable_Spells()
		end,
	}
	
	optionTables.args.Spells.args[tostring(spellId)] = {
		type = "group",
		inline = true,
		name = "|T"..spell.icon..":0:0:0:0|t "..spell.name.." "..L["Metadata"],
		order = 5,
		args = {
			instructions = {
				type = "description",
				width = "full",
				order = 5,
				name = L["Each row represents a key/value pair. Provide a key in the last row to create a new entry. Delete an existing entry by clearing the key. The data provided here can be used by other addons leveraging Hermes API."],
				fontSize = "medium",
			},
		},
	}
	
	--load up existing key values
	local count = 0
	local keyvalues = dbg.spellmetadata[spellId]
	if keyvalues then
		for k, v in pairs(keyvalues) do
			count = count + 1
			local keytext, valuetext = "", ""
			if count == 1 then
				--keytext = L["Key"]
				--valuetext = L["Value"]
			end
			optionTables.args.Spells.args[tostring(spellId)].args[tostring(count)] = {
				type = "group",
				inline = true,
				name = "",
				--order = 10,
				args = {
					key = {
						type = "input",
						name = keytext,
						order = 5,
						width = "normal",
						get = function(info) return k end,
						validate = function(info, value)
							local key = strtrim(value)
							--only if a key was entered should we validate
							if string.len(key) > 0 then
								--make sure key doesn't already exist
								if keyvalues[key] and key ~= k then
									return "Key already exists."
								else
									return true
								end
							end
							
							return true
						end,
						set = function(info, value)
							local key = strtrim(value)
							if string.len(key) > 0 then
								
								
								keyvalues[k] = nil --delete old
								keyvalues[key] = v --create new, using prior value
							else
								keyvalues[k] = nil --delete
							end
							self:BlizOptionsTable_Spells()
						end,
					},
					value = {
						type = "input",
						name = valuetext,
						order = 10,
						width = "normal",
						get = function(info) return v end,
						set = function(info, value)
							keyvalues[k] = value -- value changed
							self:BlizOptionsTable_Spells()
						end,
					},
				},
			}
		end
	end
	
	--create a new row
	optionTables.args.Spells.args[tostring(spellId)].args.new = {
		type = "group",
		inline = true,
		name = "",
		order = -1,
		args = {
			key = {
				type = "input",
				name = "",
				order = 5,
				width = "normal",
				get = function(info) return k end,
				validate = function(info, value)
					--make sure metadata table exists for this spell
					local key = strtrim(value)
					local data = dbg.spellmetadata[spellId]
					if not data then
						return true
					end
					
					if string.len(key) > 0 then					
						--make sure key doesn't alredy exist
						if data[key] then
							return "Key already exists."
						else
							return true
						end
					end
					
					return "Key value required."
				end,
				set = function(info, key)
				
					if string.len(key) > 0 then
						--make sure metadata table exists for this spell
						local data = dbg.spellmetadata[spellId]
						if not data then
							--create new table
							dbg.spellmetadata[spellId] = {}
							data = dbg.spellmetadata[spellId]
						end
						
						data[key] = "" --create new key
						
						self:BlizOptionsTable_Spells()
					end
				end,
			},
		},
	}
end

function core:BlizOptionsTable_SpellRequirements()
	local spellId = CONFIGURE_SETTINGS.spellid
	local spell = CONFIGURE_SETTINGS.spell
	
	local SPELLHASBASEDURATION = dbg.durations[spellId]
	
	refreshTalentLookups(spell.class)
	
	optionTables.args.Spells.args.listButton = {
		type = "execute",
		name = "<< "..L["List"],
		width = "normal",
		order = 1,
		func = function()
			CONFIGURE_SETTINGS.mode = "list"
			CONFIGURE_SETTINGS.spell = nil
			CONFIGURE_SETTINGS.spellid = nil
			LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
			core:BlizOptionsTable_Spells()
		end,
	}
	
	optionTables.args.Spells.args.configButton = {
		type = "execute",
		name = "<< "..L["Configure"],
		width = "normal",
		order = 2,
		func = function()
			CONFIGURE_SETTINGS.mode = "config"
			LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
			core:BlizOptionsTable_Spells()
		end,
	}
	
	optionTables.args.Spells.args.spellMonitorButton = {
		type = "execute",
		name = "<< "..L["Back"],
		width = "normal",
		order = 5,
		func = function()
			CONFIGURE_SETTINGS.mode = "spellmonitor"
			LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
			core:BlizOptionsTable_Spells()
		end,
	}

	optionTables.args.Spells.args.Create = {
		type="group",
		name= L["Add Requirement"],
		inline = true,
		order = 15,
		disabled = SPELLHASBASEDURATION == nil,
		args = {
		
			---------------------
			-- RACE 
			---------------------
			type = {
				type = "select",
				name = L["Type"],
				order = 5,
				style = "dropdown",
				width = "normal",
				values = function()
					--TALENT_SPEC and TALENT_NAME are not applicable if spell class is "ANY".
					-- Because of this, we need to filter out types that aren't allowed from the list
					local types = _deepcopy(REQUIREMENT_VALUES)
					if spell.class == "ANY" then
						types["TALENT_SPEC"] = nil
						types["TALENT_NAME"] = nil
					end
					return types
				end,
				get = function(info) return newRequirementTemplate.type end,
				set = function(info, value)
					newRequirementTemplate.type = value
					LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
					core:BlizOptionsTable_Spells()
				end,
			},
			spacer1A = {
				type = "description",
				name = "",
				width = "full",
				order = 10,
			},
			raceDropDown = {
				type = "select",
				name = L["Race"],
				order = 15,
				style = "dropdown",
				width = "normal",
				hidden = REQUIREMENT_KEYS[newRequirementTemplate.type] ~= REQUIREMENT_KEYS.PLAYER_RACE,
				values = function()
					return dbg.races
				end,
				get = function(info) return newRequirementTemplate.race end,
				set = function(info, value)
					newRequirementTemplate.race = dbg.races[value]
					self:BlizOptionsTable_Spells()
				end,
			},
			---------------------
			-- PLAYERNAMES
			---------------------
			playerNames = {
				type = "input",
				name = L["Player Names"],
				order = 15,
				width = "normal",
				hidden = REQUIREMENT_KEYS[newRequirementTemplate.type] ~= REQUIREMENT_KEYS.PLAYER_NAMES,
				get = function(info) return newRequirementTemplate.names end,
				set = function(info, value)
					local playerNames = strtrim(value)
					if string.len(playerNames) > 0 then
						newRequirementTemplate.names = playerNames
					else
						newRequirementTemplate.names = nil
					end
					self:BlizOptionsTable_Spells()
				end,
			},
			spacer1B = {
				type = "description",
				name = "|TInterface\\BUTTONS\\UI-GuildButton-PublicNote-Up:0:0:0:0|t"..L["If provided, only these players are monitored for this spell."],
				width = "double",
				order = 18,
				fontSize = "medium",
				hidden = REQUIREMENT_KEYS[newRequirementTemplate.type] ~= REQUIREMENT_KEYS.PLAYER_NAMES,
			},
			---------------------
			-- LEVEL
			---------------------
			level = {
				type = "range",
				min = 10, max = 85, step = 1,
				name = L["Level"],
				order = 15,
				width = "normal",
				hidden = REQUIREMENT_KEYS[newRequirementTemplate.type] ~= REQUIREMENT_KEYS.PLAYER_LEVEL,
				get = function(info) return newRequirementTemplate.level end,
				set = function(info, value)
					newRequirementTemplate.level = value
					self:BlizOptionsTable_Spells()
				end,
			},
			
			---------------------
			-- TALENT SPEC
			---------------------
			talentSpecDropDown = {
				type = "select",
				name = L["Primary Tree"],
				order = 15,
				style = "dropdown",
				width = "normal",
				hidden = REQUIREMENT_KEYS[newRequirementTemplate.type] ~= REQUIREMENT_KEYS.TALENT_SPEC,
				values = _talentSpecs,
				get = function(info) return newRequirementTemplate.talentSpec end,
				set = function(info, value)
					newRequirementTemplate.talentSpec = value
					self:BlizOptionsTable_Spells()
				end,
			},
			spacer1C = {
				type = "description",
				name = "|TInterface\\BUTTONS\\UI-GuildButton-PublicNote-Up:0:0:0:0|t "..L["|cFFFF3333Missing Talents:|r Hermes has yet to inspect a player of this class for talent information. Try again later when this class is in your group."],
				width = "double",
				order = 18,
				fontSize = "medium",
				hidden = not (#_talentSpecs == 0 and REQUIREMENT_KEYS[newRequirementTemplate.type] == REQUIREMENT_KEYS.TALENT_SPEC),
			},
			
			---------------------
			-- TALENT NAME
			---------------------
			talentNameDropDown = {
				type = "select",
				name = L["Talent Name"],
				order = 15,
				style = "dropdown",
				width = "normal",
				hidden = REQUIREMENT_KEYS[newRequirementTemplate.type] ~= REQUIREMENT_KEYS.TALENT_NAME,
				values = _talentNameKeys,
				get = function(info)
					return newRequirementTemplate.talentName
				end,
				set = function(info, value)
					newRequirementTemplate.talentName = value
					local index = _talentNameValues[value].index
					local rank = _talentNameValues[value].rank
					newRequirementTemplate.talentMaxRank = rank
					--set the rank back to 1
					newRequirementTemplate.talentRank = 1
					self:BlizOptionsTable_Spells()
				end,
			},
			spacer2A = {
				type = "description",
				name = "|TInterface\\BUTTONS\\UI-GuildButton-PublicNote-Up:0:0:0:0|t "..L["|cFFFF3333Missing Talents:|r Hermes has yet to inspect a player of this class for talent information. Try again later when this class is in your group."],
				width = "double",
				order = 18,
				fontSize = "medium",
				hidden = not (#_talentNameKeys == 0 and REQUIREMENT_KEYS[newRequirementTemplate.type] == REQUIREMENT_KEYS.TALENT_NAME),
			},
			spacer2B = {
				type = "description",
				name = "",
				width = "full",
				order = 20,
			},
			rank = {
				type = "range",
				min = newRequirementTemplate.talentMinRank, max = newRequirementTemplate.talentMaxRank, step = 1,
				name = L["Rank"],
				order = 25,
				width = "normal",
				hidden = REQUIREMENT_KEYS[newRequirementTemplate.type] ~= REQUIREMENT_KEYS.TALENT_NAME,
				disabled = newRequirementTemplate.talentName == nil or SPELLHASBASEDURATION == nil,
				get = function(info) return newRequirementTemplate.talentRank end,
				set = function(info, value)
					newRequirementTemplate.talentRank = value
					self:BlizOptionsTable_Spells()
				end,
			},
			---------------------
			-- ADD BUTTON
			---------------------
			spacerLast = {
				type = "description",
				name = "",
				width = "full",
				order = 99,
			},
			add = {
				type = "execute",
				name = L["Add"],
				width = "normal",
				order = 100,
				disabled = core:IsRequirementTemplateComplete() == false,
				func = function()
					--create the requirement
					local key = REQUIREMENT_KEYS[newRequirementTemplate.type]
					
					local requirement = {
						k = key,
					}
					
					if key == REQUIREMENT_KEYS.PLAYER_RACE then
						requirement.race = newRequirementTemplate.race
					elseif key == REQUIREMENT_KEYS.PLAYER_LEVEL then
						requirement.level = newRequirementTemplate.level
					elseif key == REQUIREMENT_KEYS.PLAYER_NAMES then
						requirement.names = newRequirementTemplate.names
					elseif key == REQUIREMENT_KEYS.TALENT_SPEC then
						requirement.talspec = _talentSpecs[newRequirementTemplate.talentSpec]
					elseif key == REQUIREMENT_KEYS.TALENT_NAME then
						requirement.talname = _talentNameKeys[newRequirementTemplate.talentName]
						requirement.talrank = newRequirementTemplate.talentRank
					else
						error("unknown key")
					end
	
					-- make sure a table exists for this spell
					if not dbg.requirements[spellId] then
						dbg.requirements[spellId] = {}
					end
					
					--store the requirement
					tinsert(dbg.requirements[spellId], requirement)
					
					--reset the template
					ResetRequirementTemplate()
					
					--update everything
					self:ResetNonHermesPlayers()
					
					--update display
					LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
					self:BlizOptionsTable_Spells()
				end,
			},
		},
	}
	
	optionTables.args.Spells.args[tostring(spellId)] = {
		type = "group",
		inline = true,
		name = "|T"..spell.icon..":0:0:0:0|t "..spell.name.." "..L["Requirements"],
		order = 20,
		args = {

		},
	}
	
	for id, s in pairs(dbg.requirements) do
		if id == spellId then
			for index, requirement in ipairs(s) do
				--process the name
				local requirementName
				local key = requirement.k

				if key == REQUIREMENT_KEYS.PLAYER_RACE then
					requirementName = format(L["Player is |cFF00FF00%s|r"], tostring(requirement.race))
				elseif key == REQUIREMENT_KEYS.PLAYER_LEVEL then
					requirementName = format(L["Player is at least level |cFF00FF00%s|r"], tostring(requirement.level))
				elseif key == REQUIREMENT_KEYS.PLAYER_NAMES then
					requirementName = format(L["Player name in |cFF00FF00%s|r"], tostring(requirement.names))
				elseif key == REQUIREMENT_KEYS.TALENT_SPEC then
					requirementName = format(L["Player is specced |cFF00FF00%s|r"], tostring(requirement.talspec))
				elseif key == REQUIREMENT_KEYS.TALENT_NAME then
					requirementName = format(L["Player has |cFF00FF00%s|r or more points in |cFF00FF00%s|r"], tostring(requirement.talrank), tostring(requirement.talname))
				else
					error("unknown key")
				end
	
				optionTables.args.Spells.args[tostring(spellId)].args[tostring(index)] = {
					type = "group",
					inline = true,
					name = "",
					order = 5,
					disabled = SPELLHASBASEDURATION == nil,
					args = {
						name = {
							type = "description",
							name = requirementName,
							order = 5,
							width = "normal",
							desc = tostring(spellId),
						},
						delete = {
							type = "execute",
							name = L["Delete"],
							width = "normal",
							order = 15,
							desc = requirementName,
							func = function()
								tremove(s, index)
								--update everything
								self:ResetNonHermesPlayers()
								LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
								self:BlizOptionsTable_Spells()
							end,
						},
					},
				}
			end
		end
	end
end

local newAdjustmentTemplate = {
	type = nil,
	playerName = nil,
	level = MAX_PLAYER_LEVEL,
	talentSpec = nil,
	talentName = nil,
	talentMinRank = 1,
	talentMaxRank = 5,
	talentRank = 1,
	offset = nil,
}

local function ResetAdjustmentTemplate()
	newAdjustmentTemplate.type = nil
	newAdjustmentTemplate.playerName = nil
	newAdjustmentTemplate.level = MAX_PLAYER_LEVEL
	newAdjustmentTemplate.talentSpec = nil
	newAdjustmentTemplate.talentName = nil
	newAdjustmentTemplate.talentMinRank = 1
	newAdjustmentTemplate.talentMaxRank = 5
	newAdjustmentTemplate.talentRank = 1
	newAdjustmentTemplate.offset = nil
end

function core:IsAdjustmentTemplateComplete()
	local key = REQUIREMENT_KEYS[newAdjustmentTemplate.type]
	
	if not newAdjustmentTemplate.offset then
		return false
	end
	
	if key == REQUIREMENT_KEYS.PLAYER_NAME then
		return newAdjustmentTemplate.playerName ~= nil
	elseif key == REQUIREMENT_KEYS.PLAYER_LEVEL then
		return true
	elseif key == REQUIREMENT_KEYS.TALENT_SPEC then
		return newAdjustmentTemplate.talentSpec ~= nil
	elseif key == REQUIREMENT_KEYS.TALENT_NAME then
		return newAdjustmentTemplate.talentName ~= nil
	elseif key == nil then
		return false
	else
		error("unknown key")
	end
end

function core:BlizOptionsTable_SpellAdjustments()
	local spellId = CONFIGURE_SETTINGS.spellid
	local spell = CONFIGURE_SETTINGS.spell

	local SPELLHASBASEDURATION = dbg.durations[spellId]
	
	refreshTalentLookups(spell.class)
	
	optionTables.args.Spells.args.listButton = {
		type = "execute",
		name = "<< "..L["List"],
		width = "normal",
		order = 1,
		func = function()
			CONFIGURE_SETTINGS.mode = "list"
			CONFIGURE_SETTINGS.spell = nil
			CONFIGURE_SETTINGS.spellid = nil
			LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
			core:BlizOptionsTable_Spells()
		end,
	}
	
	optionTables.args.Spells.args.configButton = {
		type = "execute",
		name = "<< "..L["Configure"],
		width = "normal",
		order = 3,
		func = function()
			CONFIGURE_SETTINGS.mode = "config"
			LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
			core:BlizOptionsTable_Spells()
		end,
	}
	
	optionTables.args.Spells.args.spellMonitorButton = {
		type = "execute",
		name = "<< "..L["Back"],
		width = "normal",
		order = 5,
		func = function()
			CONFIGURE_SETTINGS.mode = "spellmonitor"
			LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
			core:BlizOptionsTable_Spells()
		end,
	}

	optionTables.args.Spells.args.Create = {
		type="group",
		name= L["Add Adjustment"],
		inline = true,
		order = 15,
		disabled = SPELLHASBASEDURATION == nil,
		args = {
		
			type = {
				type = "select",
				name = L["Type"],
				order = 5,
				style = "dropdown",
				width = "normal",
				values = function()
					--TALENT_SPEC and TALENT_NAME are not applicable if spell class is "ANY".
					-- Because of this, we need to filter out types that aren't allowed from the list
					local types = _deepcopy(ADJUSTMENT_VALUES)
					if spell.class == "ANY" then
						types["PLAYER_LEVEL"] = nil
						types["TALENT_SPEC"] = nil
						types["TALENT_NAME"] = nil
					end
					return types
				end,
				get = function(info) return newAdjustmentTemplate.type end,
				set = function(info, value)
					newAdjustmentTemplate.type = value
					core:BlizOptionsTable_Spells()
				end,
			},
			spacer1A = {
				type = "description",
				name = "",
				width = "full",
				order = 10,
			},
		
			---------------------
			-- PLAYERNAME
			---------------------
			playerName = {
				type = "input",
				name = L["Player Name"],
				order = 15,
				width = "normal",
				hidden = ADJUSTMENT_KEYS[newAdjustmentTemplate.type] ~= ADJUSTMENT_KEYS.PLAYER_NAME,
				get = function(info) return newAdjustmentTemplate.playerName end,
				set = function(info, value)
					local playerName = strtrim(value)
					if string.len(playerName) > 0 then
						newAdjustmentTemplate.playerName = playerName
					else
						newAdjustmentTemplate.playerName = nil
					end
					self:BlizOptionsTable_Spells()
				end,
			},
			---------------------
			-- LEVEL
			---------------------
			level = {
				type = "range",
				min = 10, max = 85, step = 1,
				name = L["Level"],
				order = 15,
				width = "normal",
				hidden = ADJUSTMENT_KEYS[newAdjustmentTemplate.type] ~= ADJUSTMENT_KEYS.PLAYER_LEVEL,
				get = function(info) return newAdjustmentTemplate.level end,
				set = function(info, value)
					newAdjustmentTemplate.level = value
					self:BlizOptionsTable_Spells()
				end,
			},
			
			---------------------
			-- TALENT SPEC
			---------------------
			talentSpecDropDown = {
				type = "select",
				name = L["Primary Tree"],
				order = 15,
				style = "dropdown",
				width = "normal",
				hidden = ADJUSTMENT_KEYS[newAdjustmentTemplate.type] ~= ADJUSTMENT_KEYS.TALENT_SPEC,
				values = _talentSpecs,
				get = function(info) return newAdjustmentTemplate.talentSpec end,
				set = function(info, value)
					newAdjustmentTemplate.talentSpec = value
					self:BlizOptionsTable_Spells()
				end,
			},
			spacer1B = {
				type = "description",
				name = "|TInterface\\BUTTONS\\UI-GuildButton-PublicNote-Up:0:0:0:0|t "..L["|cFFFF3333Missing Talents:|r Hermes has yet to inspect a player of this class for talent information. Try again later when this class is in your group."],
				width = "double",
				order = 18,
				fontSize = "medium",
				hidden = not (#_talentSpecs == 0 and ADJUSTMENT_KEYS[newAdjustmentTemplate.type] == ADJUSTMENT_KEYS.TALENT_SPEC),
			},
			---------------------
			-- TALENT NAME
			---------------------
			talentNameDropDown = {
				type = "select",
				name = L["Talent Name"],
				order = 15,
				style = "dropdown",
				width = "normal",
				hidden = ADJUSTMENT_KEYS[newAdjustmentTemplate.type] ~= ADJUSTMENT_KEYS.TALENT_NAME,
				values = _talentNameKeys,
				get = function(info)
					return newAdjustmentTemplate.talentName
				end,
				set = function(info, value)
					newAdjustmentTemplate.talentName = value
					local index = _talentNameValues[value].index
					local rank = _talentNameValues[value].rank
					newAdjustmentTemplate.talentMaxRank = rank
					--set the rank back to 1
					newAdjustmentTemplate.talentRank = 1
					self:BlizOptionsTable_Spells()
				end,
			},
			spacer2A = {
				type = "description",
				name = "|TInterface\\BUTTONS\\UI-GuildButton-PublicNote-Up:0:0:0:0|t "..L["|cFFFF3333Missing Talents:|r Hermes has yet to inspect a player of this class for talent information. Try again later when this class is in your group."],
				width = "double",
				order = 18,
				fontSize = "medium",
				hidden = not (#_talentNameKeys == 0 and ADJUSTMENT_KEYS[newAdjustmentTemplate.type] == ADJUSTMENT_KEYS.TALENT_NAME),
			},
			spacer2B = {
				type = "description",
				name = "",
				width = "full",
				order = 20,
			},
			rank = {
				type = "range",
				min = newAdjustmentTemplate.talentMinRank, max = newAdjustmentTemplate.talentMaxRank, step = 1,
				name = L["Rank"],
				order = 25,
				width = "normal",
				hidden = ADJUSTMENT_KEYS[newAdjustmentTemplate.type] ~= ADJUSTMENT_KEYS.TALENT_NAME,
				disabled = newAdjustmentTemplate.talentName == nil or SPELLHASBASEDURATION == nil,
				get = function(info) return newAdjustmentTemplate.talentRank end,
				set = function(info, value)
					newAdjustmentTemplate.talentRank = value
					self:BlizOptionsTable_Spells()
				end,
			},
			
			---------------------
			-- OFFSET
			---------------------
			spacer5A = {
				type = "description",
				name = "",
				width = "full",
				order = 30,
			},
			offset = {
				type = "input",
				name = L["Cooldown Offset"],
				order = 50,
				width = "normal",
				get = function(info)
					if(newAdjustmentTemplate.offset ~= nil) then
						return format("%.0f", newAdjustmentTemplate.offset)
					else
						return ""
					end
				end,
				hidden = newAdjustmentTemplate.type == nil,
				set = function(info, value)
					local n = tonumber(value, 10)
					
					if n then --go ahead and allow offset's of zero
						newAdjustmentTemplate.offset = n
					else
						newAdjustmentTemplate.offset = n
					end
					self:BlizOptionsTable_Spells()
				end,
			},
			
			spacerFinal = {
				type = "description",
				name = "",
				width = "full",
				order = 99,
			},
			---------------------
			-- ADD BUTTON
			---------------------
			add = {
				type = "execute",
				name = L["Add"],
				width = "normal",
				order = 100,
				disabled = core:IsAdjustmentTemplateComplete() == false,
				func = function()
					--create the requirement
					local key = ADJUSTMENT_KEYS[newAdjustmentTemplate.type]
					
					local adjustment = {
						k = key,
						o = newAdjustmentTemplate.offset,
					}
					
					if key == ADJUSTMENT_KEYS.PLAYER_NAME then
						adjustment.name = newAdjustmentTemplate.playerName
					elseif key == ADJUSTMENT_KEYS.PLAYER_LEVEL then
						adjustment.level = newAdjustmentTemplate.level
					elseif key == ADJUSTMENT_KEYS.TALENT_SPEC then
						adjustment.talspec = _talentSpecs[newAdjustmentTemplate.talentSpec]
					elseif key == ADJUSTMENT_KEYS.TALENT_NAME then
						adjustment.talname = _talentNameKeys[newAdjustmentTemplate.talentName]
						adjustment.talrank = newAdjustmentTemplate.talentRank
					else
						error("unknown key")
					end
	
					-- make sure a table exists for this spell
					if not dbg.adjustments[spellId] then
						dbg.adjustments[spellId] = {}
					end
					
					--store the adjustment
					tinsert(dbg.adjustments[spellId], adjustment)
					
					--reset the template
					ResetAdjustmentTemplate()
					
					--update everything
					self:ResetNonHermesPlayers()
					
					--update display
					LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
					self:BlizOptionsTable_Spells()
				end,
			},
		},
	}
	
	optionTables.args.Spells.args[tostring(spellId)] = {
		type = "group",
		inline = true,
		name = "|T"..spell.icon..":0:0:0:0|t "..spell.name.." "..L["Adjustments"],
		order = 15,
		args = {

		},
	}
	
	for id, a in pairs(dbg.adjustments) do
		if id == spellId then
			for index, adjustment in ipairs(a) do
				--process the name
				local adjustmentName
				local key = adjustment.k

				if key == ADJUSTMENT_KEYS.PLAYER_NAME then
					adjustmentName = format(L["Offset cooldown by |cFF00FF00%s|r if player name is |cFF00FF00%s|r"], tostring(adjustment.o), tostring(adjustment.name))
				elseif key == ADJUSTMENT_KEYS.PLAYER_LEVEL then
					adjustmentName = format(L["Offset cooldown by |cFF00FF00%s|r if player level is at least |cFF00FF00%s|r"], tostring(adjustment.o), tostring(adjustment.level))
				elseif key == ADJUSTMENT_KEYS.TALENT_SPEC then
					adjustmentName = format(L["Offset cooldown by |cFF00FF00%s|r if player specced |cFF00FF00%s|r"], tostring(adjustment.o), tostring(adjustment.talspec))
				elseif key == ADJUSTMENT_KEYS.TALENT_NAME then
					adjustmentName = format(L["Offset cooldown by |cFF00FF00%s|r if player has |cFF00FF00%s|r or more points in |cFF00FF00"]..tostring(adjustment.talname).."|r", tostring(adjustment.o), tostring(adjustment.talrank))
				else
					error("unknown key")
				end
	
				optionTables.args.Spells.args[tostring(spellId)].args[tostring(index)] = {
					type = "group",
					inline = true,
					name = "",
					order = 5,
					args = {
						name = {
							type = "description",
							name = adjustmentName,
							order = 5,
							width = "normal",
							desc = tostring(spellId),
						},
						delete = {
							type = "execute",
							name = L["Delete"],
							width = "normal",
							order = 15,
							desc = adjustmentName,
							func = function()
								tremove(a, index)
								--update everything
								self:ResetNonHermesPlayers()
								LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
								self:BlizOptionsTable_Spells()
							end,
						},
					},
				}
			end
		end
	end
end

local _showingInstructions
function core:LoadBlizOptions()
	optionTables = {
		handler = core,
		type="group",
		childGroups = "tab",
		name = HERMES_VERSION_STRING,
		args = {
			General = {
				name = L["General"],
				type="group",
				order = 0,
				args = { },
			},
			Spells = {
				name=L["Spells"],
				type="group",
				childGroups="tab",
				order = 1,
				disabled = function() return dbp.enabled == false end,
				args = { }
			},
			Items = {
				name=L["Items"],
				type="group",
				childGroups="tab",
				order = 2,
				disabled = function() return dbp.enabled == false end,
				args = { }
			},
			Maintenance = {
				name=L["Maintenance"],
				type="group",
				childGroups="tab",
				order = 99,
				disabled = function() return dbp.enabled == false end,
				args = { }
			},
		},
	}
	
	core:BlizOptionsTable_General()
	core:BlizOptionsTable_Maintenance()
	LIB_AceConfig:RegisterOptionsTable(HERMES_VERSION_STRING, optionTables)
	LIB_AceConfig:RegisterOptionsTable(AddonName.." ".."Command Line", slashCommands, {"hermes"})
	core.blizzOptionsFrame = LIB_AceConfigDialog:AddToBlizOptions(HERMES_VERSION_STRING, HERMES_VERSION_STRING)
	optionTables.args.Profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(Hermes.db)
	optionTables.args.Profiles.order = -1
	LIB_AceConfigDialog:SetDefaultSize(HERMES_VERSION_STRING, 800, 550)
end

function core:UpdateBlizOptionsTableReferences()
	--core:BlizOptionsTable_General()
	core:BlizOptionsTable_Spells()
	core:BlizOptionsTable_Items()
	core:BlizOptionsTable_PluginList()
	core:BlizOptionsTable_Plugins()
end

function core:BlizOptionsTable_General()
	if(optionTables.args.General.args) then
		wipe(optionTables.args.General.args)
		optionTables.args.General.args = {}
	end
	
	local instructionsText = L["Instructions"].." >>"
	if _showingInstructions then
		instructionsText = "<< "..L["Instructions"]
	end
	
	optionTables.args.General.args["General"] = {
		type = "group",
		name = L["General"],
		inline = true,
		order = 0,
		args = {
			EnableHermes = {
				type = "toggle",
				name = L["Enable Hermes"],
				width = "normal",
				get = function(info) return dbp.enabled end,
				order = 0,
				set = "OnSetEnabled",
			},
			ConfigMode = {
				type = "toggle",
				name = L["Config Mode"],
				width = "normal",
				disabled = function() return dbp.enabled == false end,
				get = function(info) return dbp.configMode end,
				order = 5,
				set = "OnSetTestMode",
			},
		}
	}
	
	optionTables.args.General.args["Communication"] = {
		type = "group",
		name = L["Communication"],
		inline = true,
		order = 1,
		disabled = function() return dbp.enabled == false end,
		args = {
			EnableSender = {
				type = "toggle",
				name = L["Enable Sending"],
				width = "normal",
				get = function(info) return dbp.sender.enabled end,
				disabled = function() return dbp.configMode == true or dbp.enabled == false end,
				order = 20,
				set = "OnSetEnableSender",
			},
			Spacer2A = {
				type = "description",
				name = "",
				width = "double",
				order = 25,
			},
			Spacer2B = {
				type = "description",
				name = "",
				width = "full",
				order = 30,
			},
			EnableReceiver = {
				type = "toggle",
				name = L["Enable Receiving"],
				width = "normal",
				get = function(info) return dbp.receiver.enabled end,
				disabled = function() return dbp.configMode == true or dbp.enabled == false end,
				order = 35,
				set = "OnSetEnableReceiver",
			},
			Spacer3A = {
				type = "description",
				name = "",
				width = "double",
				order = 40,
			},
			Spacer3B = {
				type = "description",
				name = "",
				width = "full",
				order = 45,
			},
			EnableParty = {
				type = "toggle",
				name = L["Enable Party Support"],
				get = function(info) return dbp.enableparty end,
				disabled = function() return dbp.configMode == true or dbp.enabled == false end,
				order = 50,
				set = "OnSetEnablePartySupport",
			},
			Spacer4A = {
				type = "description",
				name = "",
				width = "double",
				order = 55,
			},
			Spacer4B = {
				type = "description",
				name = "",
				width = "full",
				order = 60,
			},
		},
	}
	
	optionTables.args.General.args["CombatLogging"] = {
		type = "group",
		name = L["Spell Monitor"],
		inline = true,
		order = 2,
		disabled = function() return dbp.enabled == false end,
		args = {
			Spacer1A = {
				type = "description",
				name = L["Capture spell cooldowns for players without Hermes"],
				width = "full",
				order = 1,
				fontSize = "medium",
			},
			Spacer1B = {
				type = "description",
				name = "",
				width = "full",
				order = 2,
			},
			enabled = {
				type = "toggle",
				name = L["Enabled"],
				desc = L["Capture spell cooldowns for players without Hermes"],
				width = "normal",
				get = function(info) return dbp.combatLogging end,
				disabled = function() return dbp.enabled == false end,
				order = 5,
				set = function(info, value)
					--fire up or stop combat logging
					dbp.combatLogging = value
					
					if value == false then
						--prevent the user from drilling into the spell monitor detail pages, this just reset the state
						CONFIGURE_SETTINGS.mode = "list"
						CONFIGURE_SETTINGS.spell = nil
						CONFIGURE_SETTINGS.spellid = nil
					end
					
					LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
					self:BlizOptionsTable_Spells()
					core:ResetNonHermesPlayers()
					core:OnSpellMonitorStatusChanged() --make sure the appropriate mods are running for spell monitor to work
				end,
			},
			InstructionsButton = {
				type = "execute",
				name = instructionsText,
				width = "normal",
				order = 15,
				desc = "",
				func = function()
					if _showingInstructions then
						_showingInstructions = nil
					else
						_showingInstructions = 1
					end
					--LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
					core:BlizOptionsTable_General()
				end,
			},
			SpacerB = {
				type = "header",
				name = "",
				width = "double",
				order = 20,
				hidden = _showingInstructions == nil,
			},
			SpacerC = {
				type = "description",
				name = COMBAT_LOGGING_INSTRUCTIONS,
				width = "full",
				order = 25,
				fontSize = "medium",
				hidden = _showingInstructions == nil,
			},
		},
	}
	
	optionTables.args.General.args["PluginList"] = {
		name = L["Registered Plugins"],
		type = "group",
		inline = true,
		order = 4,
		disabled = function() return dbp.enabled == false end,
		args = {
		},
	}

	core:BlizOptionsTable_PluginList()
end

function core:CreateMissingSpellList()
	local result = {}
	--create a list of missing spells
	local playerAlliance = select(1, UnitFactionGroup("player"))
	for i, default in ipairs(DEFAULT_SPELLS) do
		local class = default[1]
		local spellid = default[2]
		local alliance = default[3]
		
		if(not alliance or (alliance and alliance == playerAlliance)) then
			--see if spell exists
			local exists = false
			for _, s in ipairs(dbp.spells) do
				if(s.id == spellid) then
					exists = true
					break
				end
			end
			
			if(exists == false) then
				local spell = core:FindSpellName(class, spellid)
				if(spell) then
					tinsert(result, spell)
				end
			end
		end
	end
	
	return result
end

local _expandMissingSpells = false
local _expandTalentStatus = false

function core:BlizOptionsTable_Maintenance()
	if(optionTables.args.Maintenance.args) then
		wipe(optionTables.args.Maintenance.args)
		optionTables.args.Maintenance.args = {}
	end
	
	if _expandMissingSpells == false then
		optionTables.args.Maintenance.args["UpgradeOptions"] = {
			name = L["Default Spells"],
			type = "group",
			inline = true,
			order = 5,
			args = {
				expand = {
					type = "execute",
					name = L["Show"].." >>",
					width = "normal",
					order = 5,
					disabled = function() return dbp.enabled == false end,
					func = function()
						_expandMissingSpells = true
						core:BlizOptionsTable_Maintenance()
					end,
				},
				spacer1 = {
					type = "description",
					name = L["List any default spells not in your inventory."],
					order = 10,
					width = "double",
				},
				spacer2 = {
					type = "description",
					name = "",
					order = 15,
					width = "full",
				},
			},
		}
	else
		optionTables.args.Maintenance.args["UpgradeOptions"] = {
			name = L["Default Spells"],
			type = "group",
			inline = true,
			order = 5,
			args = {
				expand = {
					type = "execute",
					name = "<< "..L["Hide"],
					width = "normal",
					order = 5,
					disabled = function() return dbp.enabled == false end,
					func = function()
						_expandMissingSpells = false
						core:BlizOptionsTable_Maintenance()
					end,
				},
				spacer1 = {
					type = "description",
					name = L["List any default spells not in your inventory."],
					order = 10,
					width = "double",
				},
				spacer2 = {
					type = "description",
					name = "",
					order = 15,
					width = "full",
				},
				list = {
					name = "",
					type = "group",
					inline = true,
					order = 20,
					args = {},
				},
			},
		}
		
		local spells = self:CreateMissingSpellList()
		local list = optionTables.args.Maintenance.args.UpgradeOptions.args.list.args
		for _, spell in ipairs(spells) do
			local item = {
				name = "",
				type = "group",
				inline = true,
				order = 20,
				args = {
					name = {
						type = "description",
						name = Hermes:GetClassColorString(spell.name, spell.class),
						order = 5,
						width = "normal",
						fontSize = "medium",
					},
					add = {
						type = "execute",
						name = L["Add"],
						width = "normal",
						order = 10,
						func = function()
							--add to db
							spell.enabled = false
							tinsert(dbp.spells, spell)
							--sort the spells
							sort(dbp.spells, function(a, b) return core:SortProfileSpells(a, b) end)
							--update spell monitor related data if available for this spell
							self:UpdateSMSSpellCooldown(spell.id, nil)
							self:UpdateSMSSpellMetadata(spell.id, nil)
							self:UpdateSMSSpellRequirements(spell.id, spell.class, nil)
							self:UpdateSMSSpellAdjustments(spell.id, spell.class, nil)
							core:FireEvent("OnInventorySpellAdded", spell.id)
							core:BlizOptionsTable_SpellList()
							core:BlizOptionsTable_Maintenance()
						end,
					},
				},
			}
			tinsert(list, item)
		end
	end
	
	optionTables.args.Maintenance.args.md = {
		name = L["Spell Metadata"],
		type = "group",
		inline = true,
		order = 15,
		args = {
			md = {
				type = "execute",
				name = L["Update Metadata"],
				width = "normal",
				order = 10,
				disabled = function() return dbp.enabled == false end,
				func = function()
					--refresh all the spells in case it's stale
					for _, spell in ipairs(dbp.spells) do
						core:UpdateSMSSpellMetadata(spell.id, 1)
					end
					core:ShowMessageBox(L["Done!"])
				end,
			},
			spacer3 = {
				type = "description",
				name = L["Updates the metadata for the spells in your inventory with the latest values."],
				order = 15,
				width = "double",
			},
			spacer4 = {
				type = "description",
				name = "",
				order = 20,
				width = "full",
			},
		},
	}

	if _expandTalentStatus == false then
		optionTables.args.Maintenance.args["SpellMonitor"] = {
			type = "group",
			name = L["Spell Monitor"].." ( |cFF00FF00"..L["latest version"].." "..tostring(Hermes.SPELL_MONITOR_SCHEMA.schema).."-"..tostring(Hermes.SPELL_MONITOR_SCHEMA.revision).."|r )",
			order = 10,
			inline = true,
			args = {
				expand = {
					type = "execute",
					name = L["Show"].." >>",
					width = "normal",
					order = 5,
					disabled = function() return dbp.enabled == false end,
					func = function()
						_expandTalentStatus = true
						core:BlizOptionsTable_Maintenance()
					end,
				},
				spacer1 = {
					type = "description",
					name = L["Show spell monitor status for each class."],
					order = 10,
					width = "double",
				},
				spacer2 = {
					type = "description",
					name = "",
					order = 12,
					width = "full",
				},
			},
		}
	else
		optionTables.args.Maintenance.args["SpellMonitor"] = {
			type = "group",
			name = L["Spell Monitor"].." ( |cFF00FF00"..L["latest version"].." "..tostring(Hermes.SPELL_MONITOR_SCHEMA.schema).."-"..tostring(Hermes.SPELL_MONITOR_SCHEMA.revision).."|r )",
			order = 10,
			inline = true,
			args = {
				expand = {
					type = "execute",
					name = "<< "..L["Hide"],
					width = "normal",
					order = 5,
					disabled = function() return dbp.enabled == false end,
					func = function()
						_expandTalentStatus = false
						core:BlizOptionsTable_Maintenance()
					end,
				},
				spacer1 = {
					type = "description",
					name = L["Show spell monitor status for each class."],
					order = 10,
					width = "double",
				},
				spacer2 = {
					type = "description",
					name = "",
					order = 12,
					width = "full",
				},
				status = {
					type = "group",
					name = "",
					order = 15,
					inline = true,
					args = {
						
					},
				},
				header = {
					type = "header",
					name = "",
					order = 20,
					width = "full",
				},
				description = {
					type = "description",
					name = L["A full reset clears all cached talents, races, cooldowns, requirements and adjustments. Useful if Blizzard changes talents for any classes. Hermes will automatically rebuild talents and races while in a party or raid, and apply the latest cooldowns, requirements and adjustments."],
					order = 25,
					width = "double",
				},
				spacer3 = {
					type = "description",
					name = "",
					order = 30,
					width = "full",
				},
				clearcache = {
					type = "execute",
					name = L["Full Reset"],
					width = "double",
					order = 35,
					disabled = function() return dbp.enabled == false end,
					confirm = function() return L["All talents, races, cooldowns, requirements, and adjustment will be reset."] end,
					func = function()
						--wipe all the tables
						if dbg.races then dbg.races = {} end
						if dbg.classes then dbg.classes = {} end
						if dbg.adjustments then dbg.adjustments = {} end
						if dbg.requirements then dbg.requirements = {} end
						if dbg.cooldowns then dbg.cooldowns = {} end
						--done!
						core:ShowMessageBox(L["Done!"])
						--go ahead and manually queue up a talent update for yourself, so you at least get your own spells
						MOD_Talents:QueueTalentQuery("player") --one class is better than none!
						--update options
						core:BlizOptionsTable_Maintenance()
					end,
				},
			},
		}
		
		local status = optionTables.args.Maintenance.args.SpellMonitor.args.status.args
		for key, class in pairs(LOCALIZED_CLASS_NAMES) do
			local schemaname
			local talents = dbg.classes[key]
			local disabled = false
			if talents then
				if not talents.schema then
					schemaname = "|cFFFF0000"..L["Requires update"].."|r"
				else
					if talents.schema == Hermes.SPELL_MONITOR_SCHEMA.schema then
						if talents.revision == Hermes.SPELL_MONITOR_SCHEMA.revision then
							schemaname = "|cFF00FF00"..tostring(talents.schema).."-"..tostring(talents.revision).."|r"
						else
							schemaname = "|cFFFFA000"..tostring(talents.schema).."-"..tostring(talents.revision).."|r"
						end
					else
						schemaname = "|cFFFF0000"..tostring(talents.schema).."-"..tostring(talents.revision).."|r"
					end
				end
			else
				schemaname = L["No Talent Cache"]
				disabled = true
			end
			
			local item = {
				type = "group",
				name = "",
				inline = true,
				args = {
					class = {
						type = "description",
						name = Hermes:GetClassColorString(class, key),
						order = 5,
						width = "normal",
						fontSize = "medium",
					},
					updateclassschema = {
						type = "execute",
						name = schemaname,
						width = "normal",
						order = 10,
						desc = L["Click to replace talent related cooldowns, requirements and adjustments with the latest version."],
						disabled = disabled,
						func = function()
							self:UpdateSMSClass(key, 1) --force it
							--update options
							core:BlizOptionsTable_Maintenance()
							core:ShowMessageBox(L["Done!"])
						end,
					},
				},
			}
			
			tinsert(status, item)
		end
	end
end

function core:BlizOptionsTable_Spells()
	if(optionTables.args.Spells.args) then
		wipe(optionTables.args.Spells.args)
		optionTables.args.Spells.args = {}
	end
	
	--if Spell Scanning got disabled, then reset mode back to list since no details pages are supported
	--if not dbp.combatLogging or dbp.combatLogging and dbp.combatLogging == false then
	--	CONFIGURE_SETTINGS.mode = "list"
	--	CONFIGURE_SETTINGS.spell = nil
	--	CONFIGURE_SETTINGS.spellid = nil
	--end
	
	if CONFIGURE_SETTINGS.mode == "spellmonitor" then
		core:BlizOptionsTable_SpellDetail()
	elseif CONFIGURE_SETTINGS.mode == "config" then
		core:BlizOptionsTable_SpellConfig()
	elseif CONFIGURE_SETTINGS.mode == "metadata" then
		core:BlizOptionsTable_SpellMetadata()
	elseif CONFIGURE_SETTINGS.mode == "list" then
		core:BlizOptionsTable_SpellList()
	elseif CONFIGURE_SETTINGS.mode == "requirements" then
		core:BlizOptionsTable_SpellRequirements()
	elseif CONFIGURE_SETTINGS.mode == "adjustments" then
		core:BlizOptionsTable_SpellAdjustments()
	else
		core:BlizOptionsTable_SpellList()
	end
end

function core:BlizOptionsTable_SpellList()
	if(optionTables.args.Spells.args) then
		wipe(optionTables.args.Spells.args)
	end

	--setup basic class structure
	for classEnum, className in ipairs(CLASS_ENUM) do
		
		local classGroup = {
			type = "group",
			inline = true,
			name = Hermes:GetClassColorString(core:GetLocalizedClassName(className), className),
			order = classEnum,
			args = { }
		}
		
		local groupHasSpells = false
		for i, spell in ipairs(dbp.spells) do
			local BASECOOLDOWN = dbg.durations[spell.id]
			local configureButtonName = L["Spell Monitor"].." |T"..""..":-0:-0:-0:-0|t" --forces a gap the same size as any other icon
			if BASECOOLDOWN ~= nil then
				configureButtonName = L["Spell Monitor"].." |T".."Interface\\RAIDFRAME\\ReadyCheck-Ready"..":0:0:0:0|t"
			end
			
			if(spell.class == className) then
				groupHasSpells = true
				classGroup.args[tostring(spell.id)] = {
					type = "group",
					inline = true,
					name = "",
					order = i,
					args = {
						name = {
							type = "toggle",
							name = "|T"..spell.icon..":0:0:0:0|t "..spell.name,
							order = 0,
							width = "double",
							desc = tostring(spell.id),
							get = function() return spell.enabled end,
							set = function(info, value)
								if(spell.enabled) then
									spell.enabled = false
									core:FireEvent("OnInventorySpellChanged", spell.id)
									if(Receiving == true) then
										core:StopTrackingAbility(spell)
									end
								else
									spell.enabled = true
									core:FireEvent("OnInventorySpellChanged", spell.id)
									if(Receiving == true) then
										core:StartTrackingAbility(spell)
									end
								end
							end,
						},
						configure = {
							type = "execute",
							name = "Configure",
							width = "normal",
							order = 10,
							desc = spell.name,
							func = function()
								CONFIGURE_SETTINGS.mode = "config"
								CONFIGURE_SETTINGS.spell = spell
								CONFIGURE_SETTINGS.spellid = spell.id

								LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
								self:BlizOptionsTable_Spells()
							end,
						},
					}
				}
			end
		end
		
		if(groupHasSpells) then
			optionTables.args.Spells.args[className] = classGroup
		end
	end
	
	optionTables.args.Spells.args.Create = {
		type="group",
		name= L["Add Spell"],
		inline = true,
		order = 0,
		args = {
			ClassSelect = {
				type = "select",
				name = L["Class"],
				order = 1,
				style = "dropdown",
				width = "normal",
				values = function()
					local values = {}
					values[L["-- Select --"]] = L["-- Select --"]
					for i, classFileName in ipairs(CLASS_ENUM) do
						values[classFileName] = Hermes:GetClassColorString(core:GetLocalizedClassName(classFileName), classFileName)
					end
					return values
				end,
				get = function(info) return newSpellTemplate.class end,
				set = function(info, value) newSpellTemplate.class = value end,
			},
			SpellNameOrId = {
				type = "input",
				name = L["Name or ID"],
				order = 2,
				width = "normal",
				get = function(info)
					if(newSpellTemplate.name ~= nil) then
						return newSpellTemplate.name
					elseif(newSpellTemplate.id ~= nil) then
						return format("%.0f", newSpellTemplate.id)
					else
						return ""
					end
				end,
				set = function(info, value)
					local n = tonumber(strtrim(value))
					local s = strtrim(value)
					if(strlen(s) == 0) then s = nil end
					if(n and n ~= 0) then
						newSpellTemplate.id = n
						newSpellTemplate.name = nil
					else
						newSpellTemplate.id = nil
						newSpellTemplate.name = s
					end
				end,
			},
			AddSpellButton = {
				type = "execute",
				name = L["Add Spell"],
				width = "normal",
				order = 3,
				func = function()
					if core:AddSpell(tonumber(newSpellTemplate.id), newSpellTemplate.name, newSpellTemplate.class) then
						--reset the entered data
						newSpellTemplate.id = nil
						newSpellTemplate.name = nil
						
						--force the config window to update with latest spell info
						LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
						core:BlizOptionsTable_Spells()
						core:BlizOptionsTable_Maintenance()
					end
				end,
				disabled = function()
					--ensure that a class is selected and that spell evaluates to a spell id or name
					return newSpellTemplate.class == L["-- Select --"] or (not newSpellTemplate.name and not newSpellTemplate.id)
				end,
			},
		}
	}
end

function core:BlizOptionsTable_SpellDetail()
	local spellId = CONFIGURE_SETTINGS.spellid
	local spell = CONFIGURE_SETTINGS.spell

	local BASECOOLDOWN = dbg.durations[spellId]
	
	optionTables.args.Spells.args.listButton = {
		type = "execute",
		name = "<< "..L["List"],
		width = "normal",
		order = 5,
		func = function()
			CONFIGURE_SETTINGS.mode = "list"
			CONFIGURE_SETTINGS.spell = nil
			CONFIGURE_SETTINGS.spellid = nil
			LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
			self:BlizOptionsTable_Spells()
		end,
	}

	optionTables.args.Spells.args.configButton = {
		type = "execute",
		name = "<< "..L["Configure"],
		width = "normal",
		order = 6,
		func = function()
			CONFIGURE_SETTINGS.mode = "config"
			LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
			core:BlizOptionsTable_Spells()
		end,
	}
	
	optionTables.args.Spells.args[tostring(spellId)] = {
		type = "group",
		inline = true,
		name = "|T"..spell.icon..":0:0:0:0|t "..spell.name.." "..L["Details"],
		order = 15,
		args = {
			duration = {
				type = "input",
				name = L["Base Cooldown"],
				order = 5,
				width = "normal",
				get = function(info)
					if BASECOOLDOWN == nil then
						return ""
					else
						return format("%.0f", BASECOOLDOWN)
					end
				end,
				set = function(info, value)
					local n = tonumber(value)
					if n and n > 0 then --don't allow negative numbers here
						--user entered a real number
						dbg.durations[spellId] = n
					else
						dbg.durations[spellId] = nil
					end

					LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
					self:BlizOptionsTable_Spells()
					self:ResetNonHermesPlayers()
				end,
			},
			spacer1A = {
				type = "description",
				name = "",
				width = "full",
				order = 8,
			},
			spacer1B = {
				type = "description",
				name = "",
				width = "full",
				order = 15,
			},
			requirements = {
				type = "execute",
				name = L["Requirements"].." >>",
				width = "normal",
				order = 20,
				disabled = BASECOOLDOWN == nil,
				func = function()
					CONFIGURE_SETTINGS.mode = "requirements"
					LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
					self:BlizOptionsTable_Spells()
				end,
			},
			spacer2A = {
				type = "description",
				name = "",
				width = "full",
				order = 25,
			},
			adjustments = {
				type = "execute",
				name = L["Adjustments"].." >>",
				width = "normal",
				disabled = BASECOOLDOWN == nil,
				order = 30,
				func = function()
					CONFIGURE_SETTINGS.mode = "adjustments"
					LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
					self:BlizOptionsTable_Spells()
				end,
			},
			spacer3A = {
				type = "description",
				name = "",
				width = "full",
				order = 35,
			},
		},
	}

	optionTables.args.Spells.args.status = {
		type = "group",
		inline = true,
		name = "Status",
		order = 20,
		args = {
			noBaseCooldown = {
				type = "description",
				name = L["|cFFFF2200Base Cooldown Required:|r A Base Cooldown is required to enable Spell Monitor support."],
				width = "full",
				order = 10,
				fontSize = "medium",
				hidden = function()
					return BASECOOLDOWN ~= nil
				end,
			},
			tracking = {
				type = "description",
				name = L["|cFF00FF00Spell Monitor Enabled!"],
				width = "full",
				order = 20,
				fontSize = "medium",
				hidden = function()
					return BASECOOLDOWN == nil
				end,
			},
		},
	}
end

function core:BlizOptionsTable_Items()
	if(optionTables.args.Items.args) then
		wipe(optionTables.args.Items.args)
	end

	--setup basic class structure
	for classEnum, className in ipairs(CLASS_ENUM) do
		
		local classGroup = {
			type = "group",
			inline = true,
			name = Hermes:GetClassColorString(core:GetLocalizedClassName(className), className),
			order = classEnum,
			args = { }
		}
		
		local groupHasItems = false
		for i, item in ipairs(dbp.items) do
			if(item.class == className) then
				groupHasItems = true
				classGroup.args[tostring(item.id)] = {
					type = "group",
					inline = true,
					name = "",
					order = i,
					args = {
						name = {
							type = "toggle",
							name = "|T"..item.icon..":0:0:0:0|t "..item.name,
							order = 0,
							width = "double",
							desc = tostring(Hermes:AbilityIdToBlizzId(item.id)),
							get = function() return item.enabled end,
							set = function(info, value)
								if(item.enabled) then
									item.enabled = false
									core:FireEvent("OnInventoryItemChanged", item.id)
									if(Receiving == true) then
										core:StopTrackingAbility(item)
									end
								else
									item.enabled = true
									core:FireEvent("OnInventoryItemChanged", item.id)
									if(Receiving == true) then
										core:StartTrackingAbility(item)
									end
								end
							end,
						},
						DeleteButton = {
							type = "execute",
							name = L["Delete"],
							width = "normal",
							order = 2,
							desc = item.name,
							func = function()
								core:DeleteItem(item)
								LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
								core:BlizOptionsTable_Items()
							end,
							confirm = function() return L["Item will be deleted. Continue?"] end,
						}
					}
				}
			end
		end
		
		if(groupHasItems) then
			optionTables.args.Items.args[className] = classGroup
		end
	end
	
	optionTables.args.Items.args.Create = {
		type ="group",
		name = L["Add Item"],
		inline = true,
		order = 0,
		args = {
			ClassSelect = {
				type = "select",
				name = L["Class"],
				order = 1,
				style = "dropdown",
				width = "normal",
				values = function()
					local values = {}
					values[L["-- Select --"]] = L["-- Select --"]
					for i, classFileName in ipairs(CLASS_ENUM) do
						values[classFileName] = Hermes:GetClassColorString(core:GetLocalizedClassName(classFileName), classFileName)
					end
					return values
				end,
				get = function(info) return newItemTemplate.class end,
				set = function(info, value) newItemTemplate.class = value end,
			},
			ItemNameOrId = {
				type = "input",
				name = L["Name or ID"],
				order = 2,
				width = "normal",
				get = function(info)
					if(newItemTemplate.name ~= nil) then
						return newItemTemplate.name
					elseif(newItemTemplate.id ~= nil) then
						return format("%.0f", newItemTemplate.id)
					else
						return ""
					end
				end,
				set = function(info, value)
					local n = tonumber(strtrim(value))
					local s = strtrim(value)
					if(strlen(s) == 0) then s = nil end
					if(n and n ~= 0) then
						newItemTemplate.id = n
						newItemTemplate.name = nil
					else
						newItemTemplate.id = nil
						newItemTemplate.name = s
					end
				end,
			},
			AddItemButton = {
				type = "execute",
				name = L["Add Item"],
				width = "normal",
				order = 3,
				func = function()
					if core:AddItem(tonumber(newItemTemplate.id), newItemTemplate.name, newItemTemplate.class) then
						--reset the entered data
						newItemTemplate.id = nil
						newItemTemplate.name = nil
						
						--force the config window to update with latest spell info
						LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
						core:BlizOptionsTable_Items()
					end
				end,
				disabled = function()
					--ensure that a class is selected and that spell evaluates to a spell id or name
					return newItemTemplate.class == L["-- Select --"] or (not newItemTemplate.name and not newItemTemplate.id)
				end,
			}
		}
	}
end

function core:BlizOptionsTable_PluginList()
	if optionTables.args.General.args.PluginList.args then
		wipe(optionTables.args.General.args.PluginList.args)
	end
	
	for name, _ in pairs(Plugins) do
		optionTables.args.General.args.PluginList.args[name] = {
			type = "toggle",
			name = name,
			width = "full",
			get = function(info)
				return dbp.pluginState[name] == true
			end,
			order = 5,
			set = function(info, value)
				--start or stop the plugin based on change in state
				if value == false then
					core:DisablePlugin(name)
					dbp.pluginState[name] = false
					--reload the options
					LIB_AceConfigRegistry:NotifyChange(HERMES_VERSION_STRING)
					core:BlizOptionsTable_Plugins()
				else
					--for now, just restart hermes until I figure out a better solution to handle an addon being enabled while hermes is already running
					core:Shutdown()
					dbp.pluginState[name] = true
					core:Startup()
				end
			end,
		}
	end
end

function core:BlizOptionsTable_Plugins() --NOTE, DefaultUI addon is calling this directly, need to make into API
	local index = 5
	for name, plugin in pairs(Plugins) do
		--reset prior table if it existed
		if optionTables.args[name] then
			optionTables.args[name] = nil
		end
				
		if dbp.pluginState[name] == true then
			--the selected plugin is enabled
			local pluginOptions = nil
			--see if it has an options callback
			if plugin.OnGetBlizzOptionsTable then
				pluginOptions = plugin.OnGetBlizzOptionsTable()
			end
				
			--see if the options callback returned a table
			if pluginOptions then
				--manually control how to disable it
				pluginOptions.disabled = function() return dbp.enabled == false end
				optionTables.args[name] = pluginOptions
				optionTables.args[name].order = index
			end
			
			index = index + 1
		end
	end
end

function core:OnSetEnabled(info, value)
	dbp.enabled = value
	if(value == true) then
		core:Startup()
	else
		core:Shutdown()
	end
end

function core:OnSetTestMode(info, value)
	dbp.configMode = value
	
	if dbp.configMode == true then
		core:StartTestMode()
	else
		core:StopTestMode()
	end
end

function core:OnSetEnablePartySupport(info, value)
	dbp.enableparty = value
	core:UpdateCommunicationsStatus()
end

function core:OnSetEnableSender(info, value)
	dbp.sender.enabled = value
	core:UpdateCommunicationsStatus()
end

function core:OnSetEnableReceiver(info, value)
	dbp.receiver.enabled = value
	core:UpdateCommunicationsStatus()
end

-------------------------------------------------------------------
-- Talents
-------------------------------------------------------------------
function core:TalentUpdate(guid, unit, name)
	local _, class, _, _, _, name, _, unknown = GetPlayerInfoByGUID(guid)
	--only process players when we know everything we need to know
	if name and class and not unknown then
		--update races table if missing, we want this even if unit is player
		core:ProcessRace(name)
		--see if this class needs spell monitor defaults
		--core:UpdateSMSClass(class, nil) --don't force an update
		
		--don't add yourself to Players or try to do any processing on it
		if not UnitIsUnit(unit, "player") then
			--process the player changes
			local player = core:ProcessPlayer(guid, name, class)
			--rebuild the spell duration table for the player
			core:BuildPlayerSpellCache(player)
			--clear any cooldowns that are no longer reliable
			core:ResyncCooldowns(player)
			--if we're receiving, then we may need to reset this sender
			local sender = core:FindSenderByName(player.name)
			if Hermes:IsReceiving() and sender and sender.virtual then
				--the sender exists if this is true
				core:RemoveSender(sender)
			end
			
			if Hermes:IsReceiving() then
				local sender = core:FindSenderByName(player.name)
				if not sender then
					core:AddSender(player.name, core:GetClassEnum(player.class), 1)
					--now go ahead and fire off a virtual instance for each spell
					for id, duration in pairs(player.spellcache) do
						local ability = core:FindTrackedAbilityById(id)
						if core:CanCreateVirtualInstance(ability) then
							local remaining = core:GetPlayerCooldown(player, id)
							core:AddVirtualInstance(player.name, player.class, id, remaining)
						end
					end
				end
			end
		end
	end
end

function core:TalentRemove(guid, unit, name)
	--remove from Players if it exists
	Players[guid] = nil
end

-------------------------------------------------------------------
-- Spell Monitor Schema
-------------------------------------------------------------------
function core:UpdateSMSSpellCooldown(id, replace)
	--------------------------
	--update cooldowns
	--------------------------
	local exists = dbg.durations[id]
	local cd = Hermes.SPELL_MONITOR_SCHEMA.cooldowns[id]
	if cd and (replace or not exists) then
		dbg.durations[id] = cd --update cooldown for this spell belonging to this class
	end
end

function core:UpdateSMSSpellMetadata(id, replace)
	--------------------------
	--update metadata
	--------------------------
	local schemametadata = Hermes.SPELL_MONITOR_SCHEMA.spellmetadata[id]
	
	if schemametadata then
		--make sure table exists
		local metadata = dbg.spellmetadata[id]
		if not metadata then
			dbg.spellmetadata[id] = {}
			metadata = dbg.spellmetadata[id]
		end
		
		--create/update as needed
		for schemakey, schemavalue in pairs(schemametadata) do
			--look for match
			local exists = nil
			for key, value in pairs(metadata) do
				if key == schemakey then
					exists = 1
				end
			end
			
			if not exists or replace then
				metadata[schemakey] = schemavalue
			end
		end
	end
end

function core:UpdateSMSSpellRequirements(id, class, replace)
	--------------------------
	--update requirements
	--------------------------
	local schemareqs = Hermes.SPELL_MONITOR_SCHEMA.requirements[id]
	
	if schemareqs then
		local requirements = dbg.requirements[id]
		if not requirements then
			dbg.requirements[id] = {}
			requirements = dbg.requirements[id]
		end
		
		--look for requirements set to PLAYER_LEVEL, TALENT_NAME, or TALENT_SPEC
		local exists = nil
		for _, r in ipairs(requirements) do
			if r.k == REQUIREMENT_KEYS.PLAYER_LEVEL or r.k == REQUIREMENT_KEYS.TALENT_NAME or r.k == REQUIREMENT_KEYS.TALENT_SPEC then
				exists = 1
				break
			end
		end
		
		--if they don't exist, or we are going to replace them
		if not exists or replace then
			--remove existing
			if exists then
				local i = 1
				while i <= #requirements do
					local key = requirements[i].k
					if key == REQUIREMENT_KEYS.PLAYER_LEVEL or key == REQUIREMENT_KEYS.TALENT_NAME or key == REQUIREMENT_KEYS.TALENT_SPEC then
						tremove(requirements, i)
					else
						i = i + 1
					end
				end
			end
			
			--create new
			for _, schemareq in ipairs(schemareqs) do
				local k = schemareq.k
				if k == REQUIREMENT_KEYS.PLAYER_LEVEL then
					tinsert(requirements, { k = k, level = schemareq.level })
				elseif k == REQUIREMENT_KEYS.TALENT_NAME then
					local talents = dbg.classes[class]
					if talents then --will be nil for "ALL" class
						local talname = talents.name[schemareq.talname] --find the name of the talent by index
						if talname then
							tinsert(requirements, { k = k, talname = talname, talrank = schemareq.talrank })
						end
					end
				elseif k == REQUIREMENT_KEYS.TALENT_SPEC then
					local talents = dbg.classes[class]
					if talents then --will be nil for "ALL" class
						local talspec = talents.trees[schemareq.talspec] --find the name of the tree by index
						if talspec then
							tinsert(requirements, { k = k, talspec = talspec })
						end
					end
				end
			end
		end
	end
end

function core:UpdateSMSSpellAdjustments(id, class, replace)
	local schemaadjs = Hermes.SPELL_MONITOR_SCHEMA.adjustments[id]

	--if there are adjustments in the schema, then they are guaranteed to be any of PLAYER_LEVEL, TALENT_NAME, and TALENT_SPEC
	if schemaadjs then
		local adjustments = dbg.adjustments[id]
		if not adjustments then
			dbg.adjustments[id] = {}
			adjustments = dbg.adjustments[id]
		end
		
		--look for adjustments set to PLAYER_LEVEL, TALENT_NAME, or TALENT_SPEC
		local exists
		for _, a in ipairs(adjustments) do
			if a.k == ADJUSTMENT_KEYS.PLAYER_LEVEL or a.k == ADJUSTMENT_KEYS.TALENT_NAME or a.k == ADJUSTMENT_KEYS.TALENT_SPEC then
				exists = 1
				break
			end
		end
		
		--if they don't exist, or we are going to replace them
		if not exists or replace then
			--remove existing
			if exists then
				local i = 1
				while i <= #adjustments do
					local key = adjustments[i].k
					if key == ADJUSTMENT_KEYS.PLAYER_LEVEL or key == ADJUSTMENT_KEYS.TALENT_NAME or key == ADJUSTMENT_KEYS.TALENT_SPEC then
						tremove(adjustments, i)
					else
						i = i + 1
					end
				end
			end
			
			--create new
			for _, schemaadj in ipairs(schemaadjs) do
				local k = schemaadj.k
				if k == ADJUSTMENT_KEYS.PLAYER_LEVEL then
					tinsert(adjustments, { k = k, level = schemaadj.level, o = schemaadj.o })
				elseif k == ADJUSTMENT_KEYS.TALENT_NAME then
					local talents = dbg.classes[class]
					if talents then --will be nil for "ALL" class
						local talname = talents.name[schemaadj.talname] --find the name of the talent by index
						if talname then
							tinsert(adjustments, { k = k, talname = talname, talrank = schemaadj.talrank, o = schemaadj.o })
						end
					end
				elseif k == ADJUSTMENT_KEYS.TALENT_SPEC then
					local talents = dbg.classes[class]
					if talents then --will be nil for "ALL" class
						local talspec = talents.trees[schemaadj.talspec] --find the name of the tree by index
						if talspec then
							tinsert(adjustments, { k = k, talspec = talspec, o = schemaadj.o })
						end
					end
				end
			end
		end
	end
end

function core:UpdateSMSClass(class, replace)
	--note that unless I start calling this method from outside TalentUpdate, class will never actually be "ANY".
	--also not sure how I'm going to handle spells belinging to the ANY class like racials. Maybe I just won't support them for now.
	if class and class ~= "ANY" then --class talents must be available and not set to "ANY"
		local talents = dbg.classes[class] --don't assume talents exist
		if talents then
			--only update if no schema set, always let the user choose when to update SMS, never do it for them.
			if not talents.schema or replace then
				--loop through all spell in inventory
				for _, spell in ipairs(dbp.spells) do
					--only process if the class of the spell matches the class of the scanned talents
					if spell.class == class then
						self:UpdateSMSSpellCooldown(spell.id, replace)
						core:UpdateSMSSpellMetadata(spell.id, replace)
						self:UpdateSMSSpellRequirements(spell.id, class, replace)
						self:UpdateSMSSpellAdjustments(spell.id, class, replace)
					end
				end
				
				--last step is to set the applied schema
				talents.schema = Hermes.SPELL_MONITOR_SCHEMA.schema
				talents.revision = Hermes.SPELL_MONITOR_SCHEMA.revision
				
				--now update the options table so it sees the new changes
				if optionTables then
					core:BlizOptionsTable_Maintenance()
				end
			end
		end
	end
end

----------------------------------------------------------
-- This method returns a table when talent and spec names
-- converted to indexes. It's used to generate the spell
-- monitor defaults that ship with Hermes
----------------------------------------------------------
--[[
function core:GenerateSchemaTable()
	local _, _, _, schema = GetBuildInfo()
	local t = {
		schema = schema,
		revision = 1,
		requirements = {},
		adjustments = {},
		cooldowns = {}, --note that I have poorly named the cooldown table hermes uses as durations
	}
	
	--loop through each requirement table
	for spell, requirements in pairs(dbg.requirements) do
		local class = select(3, Hermes:GetInventoryDetail(spell))
		
		if class then
			for _, r in ipairs(requirements) do
				local k = r.k
				
				if k == REQUIREMENT_KEYS.PLAYER_LEVEL then
					if not t.requirements[spell] then t.requirements[spell] = {} end
					tinsert(t.requirements[spell],	{ k = k, level = r.level })
					
				elseif k == REQUIREMENT_KEYS.TALENT_NAME then
					local talents = dbg.classes[class]
					if talents then --we can't support defaults for "ALL" class
						if not t.requirements[spell] then t.requirements[spell] = {} end
						local i_talname = _tableIndex(talents.name, r.talname)
						if i_talname then
							tinsert(t.requirements[spell],	{ k = k, talname = i_talname, talrank = r.talrank })
						end
					end
					
				elseif k == REQUIREMENT_KEYS.TALENT_SPEC then
					local talents = dbg.classes[class]
					if talents then --we can't support defaults for "ALL" class
						if not t.requirements[spell] then t.requirements[spell] = {} end
						local i_talspec = _tableIndex(talents.trees, r.talspec)
						if i_talspec then
							tinsert(t.requirements[spell], { k = k, talspec = i_talspec })
						end
					end
				end
			end
		end
	end
	
	--loop through each adjustment table
	for spell, adjustments in pairs(dbg.adjustments) do
		local class = select(3, Hermes:GetInventoryDetail(spell))
		
		if class then
			for _, r in ipairs(adjustments) do
				local k = r.k
				if k == ADJUSTMENT_KEYS.PLAYER_LEVEL then
					if not t.adjustments[spell] then t.adjustments[spell] = {} end
					tinsert(t.adjustments[spell],	{ k = k, level = r.level, o = r.o })
					
				elseif k == ADJUSTMENT_KEYS.TALENT_NAME then
					local talents = dbg.classes[class]
					if talents then --we can't support defaults for "ALL" class
						if not t.adjustments[spell] then t.adjustments[spell] = {} end
						local i_talname = _tableIndex(talents.name, r.talname)
						if i_talname then
							tinsert(t.adjustments[spell],	{ k = k, talname = i_talname, talrank = r.talrank, o = r.o })
						end
					end
					
				elseif k == ADJUSTMENT_KEYS.TALENT_SPEC then
					local talents = dbg.classes[class]
					if talents then --we can't support defaults for "ALL" class
						if not t.adjustments[spell] then t.adjustments[spell] = {} end
						local i_talspec = _tableIndex(talents.trees, r.talspec)
						if i_talspec then
							tinsert(t.adjustments[spell], { k = k, talspec = i_talspec, o = r.o })
						end
					end
				end
			end
		end
	end
	
	--loop through each cooldown value
	for spell, cooldown in pairs(dbg.durations) do
		t.cooldowns[spell] = cooldown
	end
	
	--make a copy of the metadata
	if dbg.spellmetadata then
		t.spellmetadata = _deepcopy(dbg.spellmetadata)
	else
		t.spellmetadata = {}
	end
	
	return t
end
]]--



