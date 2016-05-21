--[[
ToDo:
    - 
]]

local L = LibStub("AceLocale-3.0"):GetLocale("SimpleILevel", true);
SIL_Soc = LibStub("AceAddon-3.0"):NewAddon('SIL_Soc');
SIL_Soc.eventNames = {}; -- [event] = name;

function SIL_Soc:OnInitialize()
    SIL:Print(L.social.load, GetAddOnMetadata("SimpleILevel_Social", "Version"));
    
    self.db = LibStub("AceDB-3.0"):New("SIL_Social", SILSoc_Defaults, true);
    SIL.aceConfig:RegisterOptionsTable(L.social.nameShort, SILSoc_Options, {"sis", "silsoc", "simpleilevelsocial"});
    SIL.aceConfigDialog:AddToBlizOptions(L.social.nameShort, "Social", L.core.name);
    
    -- Build the event name table
    for event,enabled in pairs(self.db.global.chatEvents) do 
        self.eventNames[event] = _G[event];
    end
    
    self:ChatHook();
end

function SIL_Soc:ChatHook()
	for event,enabled in pairs(self.db.global.chatEvents) do
        if enabled then
            self:ChatHookEvent(event);
        end
	end
end

function SIL_Soc:ChatUnhook()
	for event,enabled in pairs(self.db.global.chatEvents) do
        if not enabled then
            self:ChatUnhookEvent(event);
        end
	end
end

function SIL_Soc:ChatHookEvent(event) ChatFrame_AddMessageEventFilter(event, SILSoc_ChatFilter); end
function SIL_Soc:ChatUnhookEvent(event) ChatFrame_RemoveMessageEventFilter(event, SILSoc_ChatFilter); end

function SIL_Soc:ChatFilter(s, event, msg, name,...)
    local score, age, items = SIL:GetScoreName(name);
    
    if score then
        local formated = SIL:FormatScore(score, items, self:GetColorScore());
        local newMsg = '('..formated..') '..msg;
        
        return false, newMsg, name, ...;
    else
        return false, msg, name, ...;
    end
end

-- Static version for chat hooks
SILSoc_ChatFilter = function(...) return SIL_Soc:ChatFilter(...); end;

--[[
    Setters, Getters and Togglers
]]
function SIL_Soc:SetColorScore(v) self.db.global.color = v; end

function SIL_Soc:GetColorScore() return self.db.global.color; end
function SIL_Soc:GetChatEvent(e) return self.db.global.chatEvents[e]; end

function SIL_Soc:ToggleColorScore() self:SetColorScore(not self:GetColorScore()); end
function SIL_Soc:ToggleChatEvent(e) self:SetChatEvent(e, not self:GetChatEvent(e)); end

-- More advanced ones
function SIL_Soc:SetChatEvent(e, v) 
    self.db.global.chatEvents[e] = v; 
    
    if v then
        self:ChatHookEvent(e);
    else
        self:ChatUnhookEvent(e);
    end
end

SILSoc_Options = {
	name = L.social.options.name,
	type = "group",
	args = {
        color = {
            name = L.social.options.color,
            desc = L.social.options.colorDesc,
            type = "toggle",
            set = function(i,v) SIL_Soc:SetColorScore(v); end,
            get = function(i) return SIL_Soc:GetColorScore(); end,
            order = 5,
        },
        
        chatEvents = {
            name = L.social.options.chatEvents,
            type = 'multiselect',
            values = function() return SIL_Soc.eventNames; end;
            get = function(s,e) return SIL_Soc:GetChatEvent(e) end;
            set = function(s,e,v) return SIL_Soc:SetChatEvent(e, v) end;
            order = 100,
        },
    }
}

SILSoc_Defaults = {
    global = {
        color = true,	-- Color the score in the chat frame
        chatEvents = {  -- Event and the status
            CHAT_MSG_PARTY                  = true,
            CHAT_MSG_PARTY_LEADER           = true,
            CHAT_MSG_RAID                   = true,
            CHAT_MSG_RAID_LEADER            = true,
            CHAT_MSG_INSTANCE_CHAT          = true,
            CHAT_MSG_INSTANCE_CHAT_LEADER   = true,
            CHAT_MSG_BATTLEGROUND           = true,
            CHAT_MSG_BATTLEGROUND_LEADER    = true,
            CHAT_MSG_GUILD                  = true,
            CHAT_MSG_OFFICER                = false,
            CHAT_MSG_CHANNEL                = false,
            CHAT_MSG_SAY                    = false,
            CHAT_MSG_YELL                   = false,
            CHAT_MSG_WHISPER                = false,

        },
    },
};