-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Broadcast")
if not plugin then return end

--XXX MoP temp
local UnitIsGroupLeader = UnitIsGroupLeader or IsRaidLeader
local UnitIsGroupAssistant = UnitIsGroupAssistant or IsRaidOfficer
local GetNumSubgroupMembers = GetNumSubgroupMembers or GetRealNumPartyMembers
local GetNumGroupMembers = GetNumGroupMembers or GetRealNumRaidMembers

-------------------------------------------------------------------------------
-- Locals
--

local output = "*** %s ***"
local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_Message")
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_Message(event, module, key, msg, color, nobroadcast)
	if not msg or nobroadcast or not BigWigs.db.profile.broadcast then return end

	-- only allowed to broadcast if we're in a party or raidleader/assistant
	local inRaid = GetNumGroupMembers(1) > 0
	if not inRaid and GetNumSubgroupMembers(1) == 0 then
		return
	elseif inRaid and not UnitIsGroupLeader("player") and not UnitIsGroupAssistant("player") then
		return
	end

	local clean = msg:gsub("(|c%x%x%x%x%x%x%x%x)", ""):gsub("(|r)", "")
	local o = output:format(clean)
	if BigWigs.db.profile.useraidchannel or not inRaid then
		SendChatMessage(o, inRaid and "RAID" or "PARTY")
	else
		SendChatMessage(o, "RAID_WARNING")
	end
end

