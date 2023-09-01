-- Copyright © 2008 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.

local SpellNames = TotemTimers.SpellNames
local SpellIDs = TotemTimers.SpellIDs

local L = LibStub("AceLocale-3.0"):GetLocale("TotemTimers_GUI", true)


TotemTimers.options.args.trackers = {
    type = "group",
    name = "trackers",
    args = {
        clickthrough = {
            order = 1,
            type = "toggle", 
            name = L["Clickthrough"],
            desc = L["Clickthrough Desc"],
            set = function(info, val) TotemTimers_Settings.Tracker_Clickthrough = val  TotemTimers.ProcessSetting("Tracker_Clickthrough") end,
            get = function(info) return TotemTimers_Settings.Tracker_Clickthrough end,
        },
        TrackerArrange = {
            order = 2,
            type = "select",
            name = L["Arrangement"],
            values ={vertical = L["vertical"], horizontal = L["horizontal"], free = L["loose"],},
            set = function(info, val) 
                TotemTimers_Settings.TrackerArrange = val
                TotemTimers_OrderTrackers()
                XiTimers.timers[5]:SetTimerBarPos(XiTimers.timers[5].timerBarPos, true)
                TotemTimers.ProcessSetting("WeaponBarDirection")
            end,
            get = function(info) return TotemTimers_Settings.TrackerArrange end,
        },  
        trackertimepos = {
            order = 9,
            type = "select",
            name = L["Timer Bar Position"],
            desc = L["Timer Bar Position Desc"],
            values = {	["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["TOP"] = L["Top"], ["BOTTOM"] = L["Bottom"],},
            set = function(info, val)
                        TotemTimers_Settings.TrackerTimePos = val  TotemTimers.ProcessSetting("TrackerTimePos")	
                  end,
            get = function(info) return TotemTimers_Settings.TrackerTimePos end,
        },
        trackerSize = {
            order = 11,
            type = "range",
            name = L["Button Size"],
            desc = L["Scales the timer buttons"],
            min = 16,
            max = 96,
            step = 1,
            bigStep = 2,
            set = function(info, val)
                        TotemTimers_Settings.TrackerSize = val  TotemTimers.ProcessSetting("TrackerSize")	
                  end,
            get = function(info) return TotemTimers_Settings.TrackerSize end,
        },
        trackerTimeHeight = {
            order = 12,
            type = "range",
            name = L["Time Size"],
            desc = L["Sets the font size of time strings"],
            min = 6,
            max = 40,
            step = 1,
            set = function(info, val)
                        TotemTimers_Settings.TrackerTimeHeight = val  TotemTimers.ProcessSetting("TrackerTimeHeight")	
                  end,
            get = function(info) return TotemTimers_Settings.TrackerTimeHeight end,
        },
        trackertimespacing = {
            order = 13,
            type = "range",
            name = L["Spacing"] ,
            desc = L["Sets the space between timer buttons"],
            min = 0,
            max = 20,
            step = 1,
            set = function(info, val)
                        TotemTimers_Settings.TrackerSpacing = val  TotemTimers.ProcessSetting("TrackerSpacing")	
                  end,
            get = function(info) return TotemTimers_Settings.TrackerSpacing end,
        },
        trackerSpacing = {
            order = 14,
            type = "range",
            name = L["Time Spacing"],
            desc = L["Sets the space between timer buttons and timer bars"],
            min = 0,
            max = 20,
            step = 1,
            set = function(info, val)
                        TotemTimers_Settings.TrackerTimeSpacing = val  TotemTimers.ProcessSetting("TrackerTimeSpacing")	
                  end,
            get = function(info) return TotemTimers_Settings.TrackerTimeSpacing end,
        },
        trackertimerBarWidth = {
            order = 15,
            type = "range",
            name = L["Timer Bar Width"],
            desc = L["Timer Bar Width Desc"],
            min = 36,
            max = 300,
            step = 4,
            set = function(info, val)
                        TotemTimers_Settings.TrackerTimerBarWidth = val  TotemTimers.ProcessSetting("TrackerTimerBarWidth")	
                  end,
            get = function(info) return TotemTimers_Settings.TrackerTimerBarWidth end,
        },
        individual = {
            name = L["Trackers"] ,
            type = "group",
            order = 30,
            args = {
                ankh = {
                    order = 1,
                    name = L["Ankh Tracker"],
                    desc = L["Ankh Tracker Desc"],
                    type = "group",
                    args = {
                        enable = {
                            order = 0,
                            type = "toggle",
                            name = L["Enable"],
                            set = function(info, val) TotemTimers_Settings.AnkhTracker = val  TotemTimers.ProcessSetting("AnkhTracker") end,
                            get = function(info) return TotemTimers_Settings.AnkhTracker end,
                        },  
                    },
                },
                shield = {
                    order = 2,
                    name = L["Shield Tracker"],
                    type = "group",
                    args = {
                        enable = {
                            order = 0,
                            type = "toggle",
                            name = L["Enable"],
                            set = function(info, val) TotemTimers.ActiveSpecSettings.ShieldTracker = val  TotemTimers.ProcessSpecSetting("ShieldTracker") end,
                            get = function(info) return TotemTimers.ActiveSpecSettings.ShieldTracker end,
                        },  
                        LeftButton = {
                            order = 2,
                            type = "select",
                            name = L["Leftclick"],
                            values = { [SpellNames[SpellIDs.LightningShield]] = SpellNames[SpellIDs.LightningShield],
                                       [SpellNames[SpellIDs.WaterShield]] = SpellNames[SpellIDs.WaterShield],
                                       [SpellNames[SpellIDs.EarthShield]] = SpellNames[SpellIDs.EarthShield],
                                       [SpellNames[SpellIDs.TotemicCall]] = SpellNames[SpellIDs.TotemicCall],
                                     },
                            set = function(info, val) TotemTimers_Settings.ShieldLeftButton = val  
                                     TotemTimers.ProcessSetting("ShieldLeftButton") end,
                            get = function(info) return TotemTimers_Settings.ShieldLeftButton end,
                        },  
                        RightButton = {
                            order = 3,
                            type = "select",
                            name = L["Rightclick"],
                            values = { [SpellNames[SpellIDs.LightningShield]] = SpellNames[SpellIDs.LightningShield],
                                       [SpellNames[SpellIDs.WaterShield]] = SpellNames[SpellIDs.WaterShield],
                                       [SpellNames[SpellIDs.EarthShield]] = SpellNames[SpellIDs.EarthShield],
                                       [SpellNames[SpellIDs.TotemicCall]] = SpellNames[SpellIDs.TotemicCall],
                                     },
                            set = function(info, val) TotemTimers_Settings.ShieldRightButton = val  
                                     TotemTimers.ProcessSetting("ShieldRightButton") end,
                            get = function(info) return TotemTimers_Settings.ShieldRightButton end,
                        },  
                        MiddleButton = {
                            order = 4,
                            type = "select",
                            name = L["Middle Button"],
                            values = { [SpellNames[SpellIDs.LightningShield]] = SpellNames[SpellIDs.LightningShield],
                                       [SpellNames[SpellIDs.WaterShield]] = SpellNames[SpellIDs.WaterShield],
                                       [SpellNames[SpellIDs.EarthShield]] = SpellNames[SpellIDs.EarthShield],
                                       [SpellNames[SpellIDs.TotemicCall]] = SpellNames[SpellIDs.TotemicCall],
                                     },
                            set = function(info, val) TotemTimers_Settings.ShieldMiddleButton = val  
                                     TotemTimers.ProcessSetting("ShieldMiddleButton") end,
                            get = function(info) return TotemTimers_Settings.ShieldMiddleButton end,
                        },  
                    },
                },                
                earthshield = {
                    order = 3,
                    name = L["Earth Shield Tracker"],
                    desc = L["EarthShieldDesc"],
                    type = "group",
                    args = {
                        enable = {
                            order = 0,
                            type = "toggle",
                            name = L["Enable"],
                            set = function(info, val) TotemTimers_Settings.EarthShieldTracker = val 
                                    TotemTimers.ProcessSetting("EarthShieldTracker") end,
                            get = function(info) return TotemTimers_Settings.EarthShieldTracker end,
                        },  
                        LeftButton = {
                            order = 2,
                            type = "select",
                            name = L["Leftclick"],
                            desc = L["EarthShieldOptionsDesc"],
                            values = { focus = "focus",
                                       target = "target",
                                       targettarget = "targettarget",
                                       player = "player",
                                       recast = L["esrecast"],
                                       menu = L["ES Main Tank menu"],
                                     },
                            set = function(info, val) TotemTimers_Settings.EarthShieldLeftButton = val  
                                     TotemTimers.SetEarthShieldButtons() end,
                            get = function(info) return TotemTimers_Settings.EarthShieldLeftButton end,
                        },  
                        RightButton = {
                            order = 3,
                            type = "select",
                            name = L["Rightclick"],
                            desc = L["EarthShieldOptionsDesc"],
                            values = { focus = "focus",
                                       target = "target",
                                       targettarget = "targettarget",
                                       player = "player",
                                       recast = L["esrecast"],
                                       menu = L["ES Main Tank menu"],
                                     },
                            set = function(info, val) TotemTimers_Settings.EarthShieldRightButton = val  
                                     TotemTimers.SetEarthShieldButtons() end,
                            get = function(info) return TotemTimers_Settings.EarthShieldRightButton end,
                        },  
                        MiddleButton = {
                            order = 4,
                            type = "select",
                            name = L["Middle Button"],
                            desc = L["EarthShieldOptionsDesc"],
                            values = { focus = "focus",
                                       target = "target",
                                       targettarget = "targettarget",
                                       player = "player",
                                       recast = L["esrecast"],
                                       menu = L["ES Main Tank menu"],
                                     },
                            set = function(info, val) TotemTimers_Settings.EarthShieldMiddleButton = val  
                                     TotemTimers.SetEarthShieldButtons() end,
                            get = function(info) return TotemTimers_Settings.EarthShieldMiddleButton end,
                        },
                        Button4 = {
                            order = 5,
                            type = "select",
                            name = L["Button 4"],
                            desc = L["EarthShieldOptionsDesc"],
                            values = { focus = "focus",
                                       target = "target",
                                       targettarget = "targettarget",
                                       player = "player",
                                       recast = L["esrecast"],
                                       menu = L["ES Main Tank menu"],
                                     },
                            set = function(info, val) TotemTimers_Settings.EarthShieldButton4 = val  
                                     TotemTimers.SetEarthShieldButtons() end,
                            get = function(info) return TotemTimers_Settings.EarthShieldButton4 end, 
                        },                         
                        targetname = {
                            order = 10,
                            type = "toggle",
                            name = L["ES Target Name"],
                            set = function(info, val) TotemTimers_Settings.EarthShieldTargetName = val
                                    TotemTimers.ProcessSetting("EarthShieldTargetName") end,
                            get = function(info) return TotemTimers_Settings.EarthShieldTargetName end,
                        }, 
                        chargesonly = {
                            order = 10,
                            type = "toggle",
                            name = L["ES Charges only"],
                            desc = L["ES Charges only desc"],
                            set = function(info, val) TotemTimers_Settings.ESChargesOnly = val
                                    TotemTimers.ProcessSetting("ESChargesOnly") end,
                            get = function(info) return TotemTimers_Settings.ESChargesOnly end,
                        }, 
                        maintankmenu = {
                            order = 11,
                            type = "toggle",
                            name = L["ES Main Tank Menu"],
                            desc = L["ES Main Tank Desc"],
                            set = function(info, val) TotemTimers_Settings.ESMainTankMenu = val
                                     TotemTimers.SetEarthShieldButtons() end,
                            get = function(info) return TotemTimers_Settings.ESMainTankMenu end,
                        },
                        menudirection = {
                            order = 12,
                            type = "select",
                            name = L["Menu Direction"],
                            values = function()
                                        if TotemTimers_Settings.TrackerArrange == "horizontal" then
                                            return {auto=L["Automatic"], up=L["Up"], down=L["Down"],}
                                        elseif TotemTimers_Settings.TrackerArrange == "vertical" then
                                            return {auto=L["Automatic"], left=L["Left"], right=L["Right"],}
                                        else
                                            return {auto=L["Automatic"], left=L["Left"], right=L["Right"], up=L["Up"], down=L["Down"],}
                                        end
                                     end,
                            set = function(info, val)
                                        TotemTimers_Settings.ESMainTankMenuDirection = val  TotemTimers.ProcessSetting("ESMainTankMenuDirection")	
                                  end,
                            get = function(info) return TotemTimers_Settings.ESMainTankMenuDirection end,
                        },
                    },
                },
                weapons = {
                    order = 4,
                    name = L["Weapon Buff Tracker"],
                    desc = L["WeaponDesc"],
                    type = "group",
                    args = {
                        enable = {
                            order = 0,
                            type = "toggle",
                            name = L["Enable"],
                            set = function(info, val) TotemTimers_Settings.WeaponTracker = val 
                                    TotemTimers.ProcessSetting("WeaponTracker") end,
                            get = function(info) return TotemTimers_Settings.WeaponTracker end,
                        },
                         openright = {
                            order = 4,
                            type = "toggle",
                            name = L["Open On Rightclick"],
                            set = function(info, val)
                                    TotemTimers_Settings.WeaponMenuOnRightclick = val  TotemTimers.ProcessSetting("WeaponMenuOnRightclick")
                                     TotemTimers_InitializeBindings()
                                end,
                            get = function(info) return TotemTimers_Settings.WeaponMenuOnRightclick end,
                        },  
                        menudirection = {
                            order = 5,
                            type = "select",
                            name = L["Menu Direction"],
                            values = function()
                                        if TotemTimers_Settings.TrackerArrange == "horizontal" then
                                            return {auto=L["Automatic"], up=L["Up"], down=L["Down"],}
                                        elseif TotemTimers_Settings.TrackerArrange == "vertical" then
                                            return {auto=L["Automatic"], left=L["Left"], right=L["Right"],}
                                        else
                                            return {auto=L["Automatic"], left=L["Left"], right=L["Right"], up=L["Up"], down=L["Down"],}
                                        end
                                     end,
                            set = function(info, val)
                                        TotemTimers_Settings.WeaponBarDirection = val  TotemTimers.ProcessSetting("WeaponBarDirection")	
                                  end,
                            get = function(info) return TotemTimers_Settings.WeaponBarDirection end,
                        },  
                    },
                },
            },
        },
    },
}

local ACD = LibStub("AceConfigDialog-3.0")
local frame = ACD:AddToBlizOptions("TotemTimers", L["Trackers"], "TotemTimers", "trackers")
frame:SetScript("OnEvent", function(self) InterfaceOptionsFrame:Hide() end)
frame:HookScript("OnShow", function(self) if InCombatLockdown() then InterfaceOptionsFrame:Hide() end TotemTimers.LastGUIPanel = self end)
frame:RegisterEvent("PLAYER_REGEN_DISABLED")