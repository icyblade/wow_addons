-- Copyright © 2008 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.

local L = LibStub("AceLocale-3.0"):GetLocale("TotemTimers_GUI", true)

local Elementss = {
	[EARTH_TOTEM_SLOT] = "earth",
	[FIRE_TOTEM_SLOT] = "fire",
	[WATER_TOTEM_SLOT] = "water",
	[AIR_TOTEM_SLOT] = "air",
}

TotemTimers.options.args.totems = {
    type = "group",
    name = "totems",
    args = {
        [tostring(EARTH_TOTEM_SLOT)] = {
            order = 0,
            type = "group",
            name = L["Earth"],
            args = {
            },
        },  
        [tostring(FIRE_TOTEM_SLOT)] = {
            order = 1,
            type = "group",
            name = L["Fire"],
            args = {
            },
        },  
        [tostring(WATER_TOTEM_SLOT)] = {
            order = 2,
            type = "group",
            name = L["Water"],
            args = {
            },
        },  
        [tostring(AIR_TOTEM_SLOT)] = {
            order = 3,
            type = "group",
            name = L["Air"],
            args = {
            },
        },  
    },
}

for k,v in pairs(TotemData) do
    TotemTimers.options.args.totems.args[tostring(v.element)].args[tostring(k)] = {
        type="group",
        inline=true,
        name=TotemTimers.SpellNames[k],
        args={
            enable = {
                order = 0,
                type = "toggle",
                name = L["Enable"],
                set = function(info, val) TotemTimers.ActiveSpecSettings.HiddenTotems[k] = not val;
                    TotemTimers_SetCastButtonSpells()
                end,
                get = function(info) return not TotemTimers.ActiveSpecSettings.HiddenTotems[k] end,
            }, 
            castbutton1 = {
                order = 1,
                type = "select",
                name = L["Cast Button 1"],
                values = function()
                            local k = {}
                            k[0] = L["none"]
                            for n,t in pairs(TotemData) do
                                if t.element == v.element then
                                    k[n] = TotemTimers.SpellNames[n]                                    
                                end
                            end
                            return k
                         end,
                set = function(info, val)
                          if val == "-" then val = nil end
                          TotemTimers.ActiveSpecSettings.CastButtons[k] = TotemTimers.ActiveSpecSettings.CastButtons[k] or {}
                          TotemTimers.ActiveSpecSettings.CastButtons[k][1] = val
                          TotemTimers.ProcessSpecSetting("CastButtons")
                      end,
                get = function(info) 
                          if TotemTimers.ActiveSpecSettings.CastButtons[k] then return TotemTimers.ActiveSpecSettings.CastButtons[k][1] or 0 end
                          return 0
                      end,
            },
            castbutton2 = {
                order = 2,
                type = "select",
                name = L["Cast Button 2"],
                values = function()
                            local k = {}
                            k[0] = L["none"]
                            for n,t in pairs(TotemData) do
                                if t.element == v.element then
                                    k[n] = TotemTimers.SpellNames[n]
                                end
                            end
                            return k
                         end,
                set = function(info, val)
                          if val == "-" then val = nil end
                          TotemTimers.ActiveSpecSettings.CastButtons[k] = TotemTimers.ActiveSpecSettings.CastButtons[k] or {}
                          TotemTimers.ActiveSpecSettings.CastButtons[k][2] = val
                          TotemTimers.ProcessSpecSetting("CastButtons")
                      end,
                get = function(info) 
                          if TotemTimers.ActiveSpecSettings.CastButtons[k] then return TotemTimers.ActiveSpecSettings.CastButtons[k][2] or 0 end
                          return 0
                      end,
            },
        },
    }
end

local ACD = LibStub("AceConfigDialog-3.0")
local frame = ACD:AddToBlizOptions("TotemTimers", "Totems", "TotemTimers", "totems")
frame:SetScript("OnEvent", function(self) InterfaceOptionsFrame:Hide() end)
frame:HookScript("OnShow", function(self) if InCombatLockdown() then InterfaceOptionsFrame:Hide() end TotemTimers.LastGUIPanel = self end)
frame:RegisterEvent("PLAYER_REGEN_DISABLED")