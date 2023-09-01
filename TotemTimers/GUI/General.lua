-- Copyright © 2008 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.

local nrfonts = 0

local L = LibStub("AceLocale-3.0"):GetLocale("TotemTimers_GUI", true)

local LSM = LibStub:GetLibrary("LibSharedMedia-3.0", true)

local function reset()
    TotemTimers_Settings = {}
    TotemTimers_SpecSettings = {}
    ReloadUI()
end

local function resetpos()
    TotemTimers_SpecSettings[1].TimerPositions = nil
    TotemTimers_SpecSettings[2].TimerPositions = nil
    TotemTimers_SpecSettings[1].FramePositions = nil
    TotemTimers_SpecSettings[2].FramePositions = nil
    ReloadUI()
    --[[TotemTimers_LoadDefaultSettings()
    TotemTimers.ProcessSetting("FramePositions")
    TotemTimers_OrderTimers()
    TotemTimers.PositionCastButtons()
    TotemTimers_OrderTrackers()
    for i=1,5 do
        XiTimers.timers[i]:SetTimerBarPos(XiTimers.timers[i].timerBarPos, true)
    end ]]   
end


TotemTimers.options = {
    type = "group",
    args = {
        general = {
            type = "group",
            name = "general",
            args = {
                version= {
                    order = 0,
                    type ="description",
                    name = L["Version"]..": "..tostring(GetAddOnMetadata("TotemTimers", "Version"))
                },
                lock = {
                    order = 1,
                    type = "toggle",
                    name = L["Lock"],
                    desc = L["Locks the position of TotemTimers"],
                    set = function(info, val) TotemTimers_Settings.Lock = val TotemTimers.ProcessSetting("Lock") end,
                    get = function(info) return TotemTimers_Settings.Lock end,
                },            
                flashred = {
                    order = 2,
                    type = "toggle",
                    name = L["Red Flash Color"],
                    desc = L["RedFlash Desc"],
                    set = function(info, val) TotemTimers_Settings.FlashRed = val TotemTimers.ProcessSetting("FlashRed") end,
                    get = function(info) return TotemTimers_Settings.FlashRed end,
                }, 
                stoppulse = {
                    order = 2,
                    type = "toggle",
                    name = L["Stop Pulse"],
                    desc = L["Stop Pulse Desc"],
                    set = function(info, val) TotemTimers_Settings.StopPulse = val TotemTimers.ProcessSetting("StopPulse") end,
                    get = function(info) return TotemTimers_Settings.StopPulse end,
                },
                showtimerbars = {
                    order = 2,
                    type = "toggle",
                    name = L["Show Timer Bars"],
                    desc = L["Displays timer bars underneath times"],
                    set = function(info, val) TotemTimers_Settings.ShowTimerBars = val TotemTimers.ProcessSetting("ShowTimerBars") end,
                    get = function(info) return TotemTimers_Settings.ShowTimerBars end,
                },
                timersonbuttons = {
                    order = 2,
                    type = "toggle",
                    name = L["Timers On Buttons"],
                    desc = L["Timers On Buttons Desc"],
                    set = function(info, val) 
                        TotemTimers_Settings.TimersOnButtons = val 
                        TotemTimers.ProcessSetting("TimersOnButtons")
                        for i=1,#XiTimers.timers do
                            XiTimers.timers[i]:SetTimerBarPos(XiTimers.timers[i].timerBarPos)
                        end
                    end,
                    get = function(info) return TotemTimers_Settings.TimersOnButtons end,
                },
                hideblizztimers = {
                    order = 3,
                    type = "toggle",
                    name = L["Hide Blizzard Timers"],
                    set = function(info, val) TotemTimers_Settings.HideBlizzTimers = val TotemTimers.ProcessSetting("HideBlizzTimers") end,
                    get = function(info) return TotemTimers_Settings.HideBlizzTimers end,
                },                  
                hidedefaulttotembar = {
                    order = 3,
                    type = "toggle",
                    name = L["Hide Default Totem Bar"],
                    desc = L["Hide Default Totem Bar Desc"],
                    set = function(info, val) TotemTimers_Settings.HideDefaultTotemBar = val
                            TotemTimers.ProcessSetting("HideDefaultTotemBar") end,
                    get = function(info) return TotemTimers_Settings.HideDefaultTotemBar  end,
                },                  
                tooltips = {
                    order = 3,
                    type = "toggle",
                    name = L["Show Tooltips"],
                    desc = L["Shows tooltips on timer and totem buttons"],
                    set = function(info, val) TotemTimers_Settings.Tooltips = val TotemTimers.ProcessSetting("Tooltips") end,
                    get = function(info) return TotemTimers_Settings.Tooltips end,
                },  
                tooltipsatbuttons = {
                    order = 3,
                    type = "toggle",
                    name = L["Tooltips At Buttons"],
                    desc = L["Tooltips At Buttons Desc"],
                    set = function(info, val) TotemTimers_Settings.TooltipsAtButtons = val end,
                    get = function(info) return TotemTimers_Settings.TooltipsAtButtons end,
                },
                HideInVehicle = {
                    order = 3,
                    type = "toggle",
                    name = L["Hide In Vehicles"],
                    desc = L["Hide In Vehicles Desc"],
                    set = function(info, val) TotemTimers_Settings.HideInVehicle = val TotemTimers.ProcessSetting("HideInVehicle") end,
                    get = function(info) return TotemTimers_Settings.HideInVehicle end,
                },                
                Keybinds = {
                     order = 4,
                   type = "toggle",
                    name = L["Show Key Bindings"],
                    desc = L["Shows key bindings on totem timers"],
                    set = function(info, val) TotemTimers_Settings.ShowKeybinds = val TotemTimers.ProcessSetting("ShowKeybinds") end,
                    get = function(info) return TotemTimers_Settings.ShowKeybinds end,
                },                  
                raidtotems = {
                    order = 55,
                    type = "select",
                    name = L["RaidTotems"],
                    desc = L["RaidTotems Desc"],
                    values = {  [0] = L["none"],                        
                                [66842] = GetSpellInfo(66842),
                                [66843] = GetSpellInfo(66843),
                                [66844] = GetSpellInfo(66844),
                            },
                    set = function(info, val)
                                TotemTimers_Settings.RaidTotemsToCall = val
                          end,
                    get = function(info) return TotemTimers_Settings.RaidTotemsToCall end,
                },
                bordertimers = {
                    order = 7,
                    type = "toggle",
                    name = L["Border Timers"],
                    desc = L["Border Timers Desc"],
                    set = function(info, val) TotemTimers_Settings.BorderTimers = val TotemTimers.ProcessSetting("BorderTimers")end,
                    get = function(info) return TotemTimers_Settings.BorderTimers end,
                },
                bordertimersize = {
                    order = 7,
                    type = "range",
                    name = L["Border Timer Size"],
                    desc = L["Border Timer Size Desc"],
                    min = 16,
                    max = 96,
                    step = 1,
                    bigStep = 2,
                    set = function(info, val)
                                TotemTimers_Settings.BorderTimerSize = val  TotemTimers.ProcessSetting("BorderTimerSize")	
                          end,
                    get = function(info) return TotemTimers_Settings.BorderTimerSize end,
                },
                h3 = {
                    order = 10,
                    type = "header",
                    name = "",
                },
                lavasurgeaura = {
                    order = 11,
                    type = "toggle",
                    name = L["Lava Surge Aura"],
                    desc = L["Lava Surge Aura Desc"],
                    set = function(info, val) TotemTimers.ActiveSpecSettings.LavaSurgeAura = val TotemTimers.ConfigAuras() end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.LavaSurgeAura end,
                },
                lavasurgeglow = {
                    order = 12,
                    type = "toggle",
                    name = L["Lava Surge Glow"],
                    desc = L["Lava Surge Glow Desc"],
                    set = function(info, val) TotemTimers.ActiveSpecSettings.LavaSurgeGlow = val TotemTimers.ConfigAuras() end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.LavaSurgeGlow end,
                },
                --[[fulminationaura = {
                    order = 11,
                    type = "toggle",
                    name = L["Fulmination Aura"],
                    desc = L["Fulmination Aura Desc"],
                    set = function(info, val) TotemTimers.ActiveSpecSettings.FulminationAura = val TotemTimers.ConfigAuras() end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.FulminationAura end,
                },
                fulminationglow = {
                    order = 12,
                    type = "toggle",
                    name = L["Fulmination Glow"],
                    desc = L["Fulmination Glow Desc"],
                    set = function(info, val) TotemTimers.ActiveSpecSettings.FulminationGlow = val TotemTimers.ConfigAuras() end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.FulminationGlow end,
                },]]
                h1 = {
                    order = 20,
                    type = "header",
                    name = "",
                },
                TimerBarTexture = {
                    order = 35,
                    type = "select",
                    name = L["Timer Bar Texture"],
                    values = AceGUIWidgetLSMlists.statusbar,
                    set = function(info, val) TotemTimers_Settings.TimerBarTexture = val TotemTimers.ProcessSetting("TimerBarTexture") end,
                    get = function(info) return TotemTimers_Settings.TimerBarTexture end,
                    dialogControl = "LSM30_Statusbar",
                },                
                TimeFont = {
                    order = 35,
                    type = "select",
                    name = L["Time Font"] ,
                    values = AceGUIWidgetLSMlists.font,
                    set = function(info, val) TotemTimers_Settings.TimeFont = val TotemTimers.ProcessSetting("TimeFont") end,
                    get = function(info) return TotemTimers_Settings.TimeFont end,
                    dialogControl = "LSM30_Font",
                }, 
                TimeColor = {
                    order = 36,
                    type = "color",
                    name = L["Time Color"],
                    set = function(info, r,g,b)
                        TotemTimers_Settings.TimeColor.r = r
                        TotemTimers_Settings.TimeColor.g = g
                        TotemTimers_Settings.TimeColor.b = b
                        TotemTimers.ProcessSetting("TimeColor")
                    end,
                    get = function(info) return TotemTimers_Settings.TimeColor.r,
                                                TotemTimers_Settings.TimeColor.g,
                                                TotemTimers_Settings.TimeColor.b,
                                                1
                          end,
                },
                TimerBarColor = {
                    order = 37,
                    type = "color",
                    name = L["Timer Bar Color"],
                    hasAlpha = true,
                    set = function(info, r,g,b,a)
                        TotemTimers_Settings.TimerBarColor.r = r
                        TotemTimers_Settings.TimerBarColor.g = g
                        TotemTimers_Settings.TimerBarColor.b = b
                        TotemTimers_Settings.TimerBarColor.a = a
                        TotemTimers.ProcessSetting("ColorTimerBars")
                    end,
                    get = function(info) return TotemTimers_Settings.TimerBarColor.r,
                                                TotemTimers_Settings.TimerBarColor.g,
                                                TotemTimers_Settings.TimerBarColor.b,
                                                TotemTimers_Settings.TimerBarColor.a
                          end,
                },
                RoundButtons = {
                    order = 38,
                    type = "toggle",
                    name = L["Round Buttons"],
                    desc = L["Round Buttons Desc"],
                    set = function(info, val) TotemTimers_Settings.RoundButtons = val TotemTimers.ProcessSetting("RoundButtons") end,
                    get = function(info) return TotemTimers_Settings.RoundButtons end,
                },
                h2 = {
                    order = 70,
                    type = "header",
                    name = "",
                },
                Debug = {
                    order = -1,
                    type = "execute",
                    name = L["Debug"] ,
                    func = function() HideUIPanel(InterfaceOptionsFrame) TotemTimers_DebugScrollFrame:Show() end
                },                
                Reset = {
                    order = -1,
                    type = "execute",
                    name = L["Reset All"] ,
                    func = reset,
                },                
                Resetpos = {
                    order = -1,
                    type = "execute",
                    name = L["Reset Positions"] ,
                    func = resetpos,
                },
            },
        },
    },
}

ACR =	LibStub("AceConfigRegistry-3.0")
ACR:RegisterOptionsTable("TotemTimers", TotemTimers.options)
local ACD = LibStub("AceConfigDialog-3.0")
local frame = ACD:AddToBlizOptions("TotemTimers", "TotemTimers", nil, "general")
frame:SetScript("OnEvent", function(self) InterfaceOptionsFrame:Hide() end)
frame:HookScript("OnShow", function(self) if InCombatLockdown() then InterfaceOptionsFrame:Hide() end TotemTimers.LastGUIPanel = self end)
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
TotemTimers.LastGUIPanel = frame



