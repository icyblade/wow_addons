local sink = LibStub("LibSink-2.0")
--[[if sink then
    TotemTimers.options.args.messages = sink.GetSinkAce3OptionsDataTable(TotemTimers)
else
    TotemTimers.options.args.messages = {}
end]]

--[[for k,v in pairs(TotemTimers.options.args.messages.args) do
    if v.order and v.order < 0 then v.order = v.order - 50 end
end]]

local L = LibStub("AceLocale-3.0"):GetLocale("TotemTimers_GUI", true)

TotemTimers.options.args.messages = {
    type = "group",
    name = "messages",
    args = {
        ActivateHiddenTimers = {
            order = 0,
            type = "toggle",
            name = L["Show warnings of disabled trackers"],
            desc = L["disabled warnings desc"],
            set = function(info, val)
                      TotemTimers_Settings.ActivateHiddenTimers = val
                      TotemTimers.ProcessSetting("ActivateHiddenTimers")
                  end,
            get = function(info) return TotemTimers_Settings.ActivateHiddenTimers end,
        },
        Messages = {
            order = 1,
            type = "group",
            name = L["Warnings"],
            args = {
                output = sink.GetSinkAce3OptionsDataTable(TotemTimers),
                TotemWarningMsg = {
                    order = 1,
                    type = "group",
                    name = L["Totem Expiration Warning"],
                    desc = L["Totem Warning Desc"],
                    args = {
                        enable = {
                            order = 0,
                            type = "toggle",
                            name = L["Enable"],
                            set = function(info, val) TotemTimers_Settings.Warnings.TotemWarning.enabled = val end,
                            get = function(info) return TotemTimers_Settings.Warnings.TotemWarning.enabled end,
                        },
                        color =  {
                            order = 1,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = false,
                            set = function(info, r,g,b)
                                TotemTimers_Settings.Warnings.TotemWarning.r = r
                                TotemTimers_Settings.Warnings.TotemWarning.g = g
                                TotemTimers_Settings.Warnings.TotemWarning.b = b
                            end,
                            get = function(info)
                                return TotemTimers_Settings.Warnings.TotemWarning.r,
                                       TotemTimers_Settings.Warnings.TotemWarning.g,
                                       TotemTimers_Settings.Warnings.TotemWarning.b, 1
                            end,
                        },
                        sound = {
                            order = 2,
                            type = "select",
                            name = L["Sound"],
                            values = AceGUIWidgetLSMlists.sound,
                            set = function(info, val) TotemTimers_Settings.Warnings.TotemWarning.sound = val end,
                            get = function(info) return TotemTimers_Settings.Warnings.TotemWarning.sound end,
                            dialogControl = "LSM30_Sound",
                        },
                        nosound = {
                            order = 3,
                            type = "execute", 
                            name = L["No Sound"],
                            func = function(info) TotemTimers_Settings.Warnings.TotemWarning.sound = "" end,
                        },
                    },
                },
                TotemExpirationMsg = {
                    order = 2,
                    type = "group",
                    name = L["Totem Expiration Message"],
                    desc = L["Totem Expiration Desc"],
                    args = {
                        enable = {
                            order = 0,
                            type = "toggle",
                            name = L["Enable"],
                            set = function(info, val) TotemTimers_Settings.Warnings.TotemExpiration.enabled = val end,
                            get = function(info) return TotemTimers_Settings.Warnings.TotemExpiration.enabled end,
                        },
                        color =  {
                            order = 1,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = false,
                            set = function(info, r,g,b)
                                TotemTimers_Settings.Warnings.TotemExpiration.r = r
                                TotemTimers_Settings.Warnings.TotemExpiration.g = g
                                TotemTimers_Settings.Warnings.TotemExpiration.b = b
                            end,
                            get = function(info)
                                return TotemTimers_Settings.Warnings.TotemExpiration.r,
                                       TotemTimers_Settings.Warnings.TotemExpiration.g,
                                       TotemTimers_Settings.Warnings.TotemExpiration.b, 1
                            end,
                        },
                        sound = {
                            order = 2,
                            type = "select",
                            name = L["Sound"],
                            values = AceGUIWidgetLSMlists.sound,
                            set = function(info, val) TotemTimers_Settings.Warnings.TotemExpiration.sound = val end,
                            get = function(info) return TotemTimers_Settings.Warnings.TotemExpiration.sound end,
                            dialogControl = "LSM30_Sound",
                        },
                        nosound = {
                            order = 3,
                            type = "execute", 
                            name = L["No Sound"],
                            func = function(info) TotemTimers_Settings.Warnings.TotemExpiration.sound = "" end,
                        },
                    },
                },
                TotemDestroyedMsg = {
                    order = 3,
                    type = "group",
                    name = L["Totem Destruction Message"],
                    desc = L["Totem Desctruction Desc"],
                    args = {
                        enable = {
                            order = 0,
                            type = "toggle",
                            name = L["Enable"],
                            set = function(info, val) TotemTimers_Settings.Warnings.TotemDestroyed.enabled = val end,
                            get = function(info) return TotemTimers_Settings.Warnings.TotemDestroyed.enabled end,
                        },
                        color =  {
                            order = 1,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = false,
                            set = function(info, r,g,b)
                                TotemTimers_Settings.Warnings.TotemDestroyed.r = r
                                TotemTimers_Settings.Warnings.TotemDestroyed.g = g
                                TotemTimers_Settings.Warnings.TotemDestroyed.b = b
                            end,
                            get = function(info)
                                return TotemTimers_Settings.Warnings.TotemDestroyed.r,
                                       TotemTimers_Settings.Warnings.TotemDestroyed.g,
                                       TotemTimers_Settings.Warnings.TotemDestroyed.b, 1
                            end,
                        },
                        sound = {
                            order = 2,
                            type = "select",
                            name = L["Sound"],
                            values = AceGUIWidgetLSMlists.sound,
                            set = function(info, val) TotemTimers_Settings.Warnings.TotemDestroyed.sound = val end,
                            get = function(info) return TotemTimers_Settings.Warnings.TotemDestroyed.sound end,
                            dialogControl = "LSM30_Sound",
                        },
                        nosound = {
                            order = 3,
                            type = "execute", 
                            name = L["No Sound"],
                            func = function(info) TotemTimers_Settings.Warnings.TotemDestroyed.sound = "" end,
                        },
                    },
                },
                ShieldMsg = {
                    order = 4,
                    type = "group",
                    name = L["Shield expiration warnings"],
                    args = {
                        enable = {
                            order = 0,
                            type = "toggle",
                            name = L["Enable"],
                            set = function(info, val) TotemTimers_Settings.Warnings.Shield.enabled = val end,
                            get = function(info) return TotemTimers_Settings.Warnings.Shield.enabled end,
                        },
                        color =  {
                            order = 1,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = false,
                            set = function(info, r,g,b, a) 
                                TotemTimers_Settings.Warnings.Shield.r = r
                                TotemTimers_Settings.Warnings.Shield.g = g
                                TotemTimers_Settings.Warnings.Shield.b = b
                            end,
                            get = function(info)
                                return TotemTimers_Settings.Warnings.Shield.r,
                                       TotemTimers_Settings.Warnings.Shield.g,
                                       TotemTimers_Settings.Warnings.Shield.b, 1
                            end,
                        },
                        sound = {
                            order = 2,
                            type = "select",
                            name = L["Sound"],
                            values = AceGUIWidgetLSMlists.sound,
                            set = function(info, val) TotemTimers_Settings.Warnings.Shield.sound = val end,
                            get = function(info) return TotemTimers_Settings.Warnings.Shield.sound end,
                            dialogControl = "LSM30_Sound",
                        },
                        nosound = {
                            order = 3,
                            type = "execute", 
                            name = L["No Sound"],
                            func = function(info) TotemTimers_Settings.Warnings.Shield.sound = "" end,
                        },
                    },
                },
                EarthShieldMsg = {
                    order = 5,
                    type = "group",
                    name = L["EarthShield warnings"],
                    args = {
                        enable = {
                            order = 0,
                            type = "toggle",
                            name = L["Enable"],
                            set = function(info, val) TotemTimers_Settings.Warnings.EarthShield.enabled = val end,
                            get = function(info) return TotemTimers_Settings.Warnings.EarthShield.enabled end,
                        },
                        color =  {
                            order = 1,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = false,
                            set = function(info, r,g,b)
                                TotemTimers_Settings.Warnings.EarthShield.r = r
                                TotemTimers_Settings.Warnings.EarthShield.g = g
                                TotemTimers_Settings.Warnings.EarthShield.b = b
                            end,
                            get = function(info)
                                return TotemTimers_Settings.Warnings.EarthShield.r,
                                       TotemTimers_Settings.Warnings.EarthShield.g,
                                       TotemTimers_Settings.Warnings.EarthShield.b, 1
                            end,
                        },
                        sound = {
                            order = 2,
                            type = "select",
                            name = L["Sound"],
                            values = AceGUIWidgetLSMlists.sound,
                            set = function(info, val) TotemTimers_Settings.Warnings.EarthShield.sound = val end,
                            get = function(info) return TotemTimers_Settings.Warnings.EarthShield.sound end,
                            dialogControl = "LSM30_Sound",
                        },
                        nosound = {
                            order = 3,
                            type = "execute", 
                            name = L["No Sound"],
                            func = function(info) TotemTimers_Settings.Warnings.EarthShield.sound = "" end,
                        },
                    },
                },
                WeaponMsg = {
                    order = 6,
                    type = "group",
                    name = L["Weapon buff warnings"],
                    args = {
                        enable = {
                            order = 0,
                            type = "toggle",
                            name = L["Enable"],
                            set = function(info, val) TotemTimers_Settings.Warnings.Weapon.enabled = val end,
                            get = function(info) return TotemTimers_Settings.Warnings.Weapon.enabled end,
                        },
                        color =  {
                            order = 1,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = false,
                            set = function(info, r,g,b)
                                TotemTimers_Settings.Warnings.Weapon.r = r
                                TotemTimers_Settings.Warnings.Weapon.g = g
                                TotemTimers_Settings.Warnings.Weapon.b = b
                            end,
                            get = function(info)
                                return TotemTimers_Settings.Warnings.Weapon.r,
                                       TotemTimers_Settings.Warnings.Weapon.g,
                                       TotemTimers_Settings.Warnings.Weapon.b, 1
                            end,
                        },
                        sound = {
                            order = 2,
                            type = "select",
                            name = L["Sound"],
                            values = AceGUIWidgetLSMlists.sound,
                            set = function(info, val) TotemTimers_Settings.Warnings.Weapon.sound = val end,
                            get = function(info) return TotemTimers_Settings.Warnings.Weapon.sound end,
                            dialogControl = "LSM30_Sound",
                        },
                        nosound = {
                            order = 3,
                            type = "execute", 
                            name = L["No Sound"],
                            func = function(info) TotemTimers_Settings.Warnings.Weapon.sound = "" end,
                        },
                    },
                },
                MaelstromMsg = {
                    order = 7,
                    type = "group",
                    name = L["Maelstrom notification"],
                    args = {
                        enable = {
                            order = 0,
                            type = "toggle",
                            name = L["Enable"],
                            set = function(info, val) TotemTimers_Settings.Warnings.Maelstrom.enabled = val end,
                            get = function(info) return TotemTimers_Settings.Warnings.Maelstrom.enabled end,
                        },
                        color =  {
                            order = 1,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = false,
                            set = function(info, r,g,b)
                                TotemTimers_Settings.Warnings.Maelstrom.r = r
                                TotemTimers_Settings.Warnings.Maelstrom.g = g
                                TotemTimers_Settings.Warnings.Maelstrom.b = b
                            end,
                            get = function(info)
                                return TotemTimers_Settings.Warnings.Maelstrom.r,
                                       TotemTimers_Settings.Warnings.Maelstrom.g,
                                       TotemTimers_Settings.Warnings.Maelstrom.b, 1
                            end,
                        },
                        sound = {
                            order = 2,
                            type = "select",
                            name = L["Sound"],
                            values = AceGUIWidgetLSMlists.sound,
                            set = function(info, val) TotemTimers_Settings.Warnings.Maelstrom.sound = val end,
                            get = function(info) return TotemTimers_Settings.Warnings.Maelstrom.sound end,
                            dialogControl = "LSM30_Sound",
                        },
                        nosound = {
                            order = 3,
                            type = "execute", 
                            name = L["No Sound"],
                            func = function(info) TotemTimers_Settings.Warnings.Maelstrom.sound = "" end,
                        },
                    },
                },
            },
        },
    },
}


local ACD = LibStub("AceConfigDialog-3.0")
local frame = ACD:AddToBlizOptions("TotemTimers", L["Warnings"], "TotemTimers", "messages")
frame:SetScript("OnEvent", function(self) InterfaceOptionsFrame:Hide() end)
frame:HookScript("OnShow", function(self) if InCombatLockdown() then InterfaceOptionsFrame:Hide() end TotemTimers.LastGUIPanel = self end)
frame:RegisterEvent("PLAYER_REGEN_DISABLED")