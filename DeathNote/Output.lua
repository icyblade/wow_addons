local L = LibStub("AceLocale-3.0"):GetLocale("DeathNote")

local outputs = {}

function DeathNote:O_RegisterOutput(output)
	outputs[output.key] = output
end

function DeathNote:O_IsChatOutput(key)
	return (outputs[key] or outputs["CHATFRAME"]).is_chat
end

function DeathNote:O_Send(key, msg)
	local output = outputs[key]
	if output then
		output.func(msg, output.arg)
	end
end

function DeathNote:O_IterateOutputs()
	return pairs(outputs)
end

local function printmessage(msg)
	DeathNote:Print(msg)
end

local function chatmessage(msg, arg)
	local inInstance, instanceType = IsInInstance()
	if arg == "PARTY" and GetNumSubgroupMembers() > 0 then
		-- send the message to party or instance
		SendChatMessage(msg, IsPartyLFG() and "INSTANCE_CHAT" or "PARTY")
	elseif arg == "RAID" and GetNumGroupMembers() > 0 then
		-- send the message to raid or instance
		SendChatMessage(msg, IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
	elseif arg == "BATTLEGROUND" and instanceType == "pvp" then
		-- battleground was replaced by instance chat
		SendChatMessage(msg, "INSTANCE_CHAT")
	elseif arg == "RAID_WARNING" and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
		SendChatMessage(msg, "RAID_WARNING")
	end
end

local function groupmessage(msg)
	if IsInRaid() and GetNumGroupMembers() > 0 then
		SendChatMessage(msg, IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
	elseif not IsInRaid() and GetNumSubgroupMembers() > 0 then
		SendChatMessage(msg, IsPartyLFG() and "INSTANCE_CHAT" or "PARTY")
	end
end

local function whispermessage(msg)
	if UnitExists(msg[1]) then
		SendChatMessage(msg[2], "WHISPER", nil, msg[1])
	end
end

local function channelmessage(msg, arg)
	SendChatMessage(msg, "CHANNEL", nil, arg)
end

local function ArgsAsKeys(...)
   local t = {}
   for i = 1, select("#", ...) do
	  t[select(i, ...)] = true
   end
   return t
end

-- Note: this is used un UI.lua too
function DeathNote:O_GetPlayerChannels()
	local server_channels = ArgsAsKeys(EnumerateServerChannels())
	local channels = { GetChannelList() }
	local result = {}

	for i = 1, #channels, 2 do
	   local id = channels[i]
	   local name = channels[i+1]
	   if not server_channels[name] then
			tinsert(result, { id = id, name = name })
	   end
	end

	return result
end

function DeathNote:O_UpdateOutputs()
	outputs = {}
	
	self:O_RegisterOutput {
		key = "CHATFRAME",
		name = L["Chat frame"],
		func = printmessage
	}

	self:O_RegisterOutput {
		key = "SAY",
		name = L["Say"],
		is_chat = true,
		func = chatmessage,
		arg = "SAY",
	}

	self:O_RegisterOutput {
		key = "PARTY",
		name = L["Party"],
		is_chat = true,
		func = chatmessage,
		arg = "PARTY",
	}

	self:O_RegisterOutput {
		key = "RAID",
		name = L["Raid"],
		is_chat = true,
		func = chatmessage,
		arg = "RAID",
	}

	self:O_RegisterOutput {
		key = "BATTLEGROUND",
		name = L["Battleground"],
		is_chat = true,
		func = chatmessage,
		arg = "BATTLEGROUND",
	}

	self:O_RegisterOutput {
		key = "GROUP",
		name = L["Group (party or raid)"],
		is_chat = true,
		func = groupmessage,
	}

	self:O_RegisterOutput {
		key = "RW",
		name = L["Raid Warning"],
		is_chat = true,
		func = chatmessage,
		arg = "RAID_WARNING",
	}

	self:O_RegisterOutput {
		key = "GUILD",
		name = L["Guild"],
		is_chat = true,
		func = chatmessage,
		arg = "GUILD",
	}

	self:O_RegisterOutput {
		key = "OFFICER",
		name = L["Officer"],
		is_chat = true,
		func = chatmessage,
		arg = "OFFICER",
	}
	
	self:O_RegisterOutput {
		key = "WHISPER",
		name = L["Whisper"],
		is_chat = true,
		func = whispermessage,
	}
	
	for _, c in ipairs(self:O_GetPlayerChannels()) do
		self:O_RegisterOutput {
			key = "CHANNEL" .. c.id .. string.lower(c.name),
			name = string.format("%i. %s", c.id, c.name),
			is_chat = true,
			func = channelmessage,
			arg = c.id,
		}		
	end
end

function DeathNote:O_Initialize()
	self:O_UpdateOutputs()
end

function DeathNote:CHANNEL_UI_UPDATE()
	self:O_UpdateOutputs()
end