-- Copyright © 2008 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.

local L = LibStub("AceLocale-3.0"):GetLocale("TotemTimers_GUI", true)


TotemTimers.options.args.multispell = {
    type = "group",
    name = "multispell",
    args = {
        show = {
            order = 0,
            type = "toggle",
            name = L["Enable"],
            set = function(info, val) TotemTimers_Settings.EnableMultiSpellButton = val
                    TotemTimers.ProcessSetting("EnableMultiSpellButton") end,
            get = function(info) return TotemTimers_Settings.EnableMultiSpellButton end,
        },  
        h1 = {
            order = 1,
            type = "header",
            name = "",
        },
        menudirection = {
            order = 7,
            type = "select",
            name = L["Menu Direction"],
            values = {["sameastimers"] = L["Same as totem menus"],
                      ["sameastrackers"] = L["Same as weapon buff menu"],
                      ["auto"] = L["Automatic"],
                      ["up"] = L["Up"],
                      ["down"] = L["Down"],
                      ["left"] = L["Left"],
                      ["right"] = L["Right"],
                    },
            set = function(info, val)
                        TotemTimers_Settings.MultiSpellBarDirection = val
                        TotemTimers.ProcessSetting("MultiSpellBarDirection")
                  end,
            get = function(info) return TotemTimers_Settings.MultiSpellBarDirection end,
        },
        size = {
            order = 11,
            type = "range",
            name = L["Button Size"],
            min = 16,
            max = 96,
            step = 1,
            bigStep = 2,
            set = function(info, val)
                        TotemTimers_Settings.MultiSpellSize = val  TotemTimers.ProcessSetting("MultiSpellSize")	
                  end,
            get = function(info) return TotemTimers_Settings.MultiSpellSize end,
        },
        openright = {
            order = 31,
            type = "toggle",
            name = L["Open On Rightclick"],
            set = function(info, val) TotemTimers_Settings.MultiSpellBarOnRightclick = val  TotemTimers.ProcessSetting("MultiSpellBarOnRightclick") end,
            get = function(info) return TotemTimers_Settings.MultiSpellBarOnRightclick end,
        },            
        keybinds = {
            order = 33,
            type = "toggle",
            name = L["Menu Key Bindings"],
            desc = L["MultiCast Keybinds Desc"],
            set = function(info, val) TotemTimers_Settings.MultiSpellBarBinds = val end,
            get = function(info) return TotemTimers_Settings.MultiSpellBarBinds end,
        },            
        reversekeybinds = {
            order = 34,
            type = "toggle",
            name = L["Reverse Key Bindings"],
            desc = L["MultiCast Reverse Keybinds Desc"],
            set = function(info, val) TotemTimers_Settings.MultiSpellReverseBarBinds = val end,
            get = function(info) return TotemTimers_Settings.MultiSpellReverseBarBinds end,
        },            
    },
}

local ACD = LibStub("AceConfigDialog-3.0")
local frame = ACD:AddToBlizOptions("TotemTimers", L["Multicast Button"], "TotemTimers", "multispell")
frame:SetScript("OnEvent", function(self) InterfaceOptionsFrame:Hide() end)
frame:HookScript("OnShow", function(self) if InCombatLockdown() then InterfaceOptionsFrame:Hide() end TotemTimers.LastGUIPanel = self end)
frame:RegisterEvent("PLAYER_REGEN_DISABLED")