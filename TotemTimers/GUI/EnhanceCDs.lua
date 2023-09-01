local L = LibStub("AceLocale-3.0"):GetLocale("TotemTimers_GUI", true)

local SpellIDs = TotemTimers.SpellIDs


function TotemTimers.OrderCDs(role)
    for i = 1,#TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[tonumber(role)] do
        if TotemTimers.options.args.enhancecds.args[role].args[tostring(TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[tonumber(role)][i])] then
            TotemTimers.options.args.enhancecds.args[role].args[tostring(TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[tonumber(role)][i])].order = i+10
        end
    end
end

local function changeOrder(spell, dir, role)
    role = tonumber(role)
    for i=1,TotemTimers.num_CD_Spells[role] do
        if TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[role][i] == spell and i+dir>0 and i+dir<=TotemTimers.num_CD_Spells[role] then
            TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[role][i],TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[role][i+dir] =
                    TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[role][i+dir],TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[role][i]
            break
        end
    end
    TotemTimers.OrderCDs(tostring(role))
    TotemTimers.ProcessSpecSetting("EnhanceCDs")
end

TotemTimers.options.args.enhancecds = {
    type = "group",
    name = "enhancecds",
    args = {
        enable = {
            order = 0,
            type = "toggle",
            name = L["Enable"],
            set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
            get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs end,
        },
       --[[ header = {
            order = 10,
            type = "header",
            name = "",
        }, ]]   
        clickthrough = {
            order = 1,
            type = "toggle", 
            name = L["Clickthrough"],
            desc = L["Clickthrough Desc"],
            set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Clickthrough = val  TotemTimers.ProcessSpecSetting("EnhanceCDs_Clickthrough") end,
            get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Clickthrough end,
        },
        CDTimersOnButtons = {
            order = 11,
            type = "toggle",
            name = L["Timers On Buttons"],
            set = function(info, val) TotemTimers.ActiveSpecSettings.CDTimersOnButtons = val
                        TotemTimers.ProcessSpecSetting("TimersOnButtons") end,
            get = function(info) return TotemTimers.ActiveSpecSettings.CDTimersOnButtons end,
        },  
        HideEnhanceCDsOOC = {
            order = 12,
            type = "toggle",
            name = L["Hide out of combat"],
            desc = L["Hide OOC Desc"],
            set = function(info, val) TotemTimers.ActiveSpecSettings.HideEnhanceCDsOOC = val  TotemTimers.ProcessSpecSetting("HideEnhanceCDsOOC") end,
            get = function(info) return TotemTimers.ActiveSpecSettings.HideEnhanceCDsOOC end,
        }, 
        FlameShockOnTop = {
            order = 12,
            type = "toggle", 
            name = L["Flame Shock on top"],
            desc = L["Flame Shock on top desc"],
            set = function(info, val) TotemTimers.ActiveSpecSettings.FlameShockDurationOnTop = val  TotemTimers.LayoutEnhanceCDs() end,
            get = function(info) return TotemTimers.ActiveSpecSettings.FlameShockDurationOnTop end, 
        },
        OOCAlpha = {
            order = 13,
            type="range",
            min = 0,
            max = 1,
            step = 0.1,
            name = L["OOC Alpha"], 
            desc = L["OOC Alpha Desc"],
            set = function(info, val)
                        TotemTimers.ActiveSpecSettings.EnhanceCDsOOCAlpha = val  TotemTimers.ProcessSpecSetting("EnhanceCDsOOCAlpha")	
                  end,
            get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDsOOCAlpha end,
        },
        --[[scaling = {
            order = 20,
            type = "header",
            name = "Scaling",
        },]]
        ECDSize = {
            order = 21,
            type = "range",
            name = L["ECD Button Size"] ,
            min = 16,
            max = 96,
            step = 1,
            bigStep = 2,
            set = function(info, val)
                        TotemTimers.ActiveSpecSettings.EnhanceCDsSize = val  TotemTimers.ProcessSpecSetting("EnhanceCDsSize")	
                  end,
            get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDsSize end,
        },
        ECDfontSize = {
            order = 22,
            type = "range",
            name = L["ECD Font Size"],
            min = 6,
            max = 40,
            step = 1,
            set = function(info, val)
                        TotemTimers.ActiveSpecSettings.EnhanceCDsTimeHeight = val  TotemTimers.ProcessSpecSetting("EnhanceCDsTimeHeight")	
                  end,
            get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDsTimeHeight end,
        },
        maelstromheight = {
            order = 23,
            type = "range",
            name = L["Maelstrom Bar Height"],
            min = 6,
            max = 40,
            step = 1,
            set = function(info, val)
                        TotemTimers.ActiveSpecSettings.EnhanceCDsMaelstromHeight = val  TotemTimers.ProcessSpecSetting("EnhanceCDsMaelstromHeight")	
                  end,
            get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDsMaelstromHeight end,
        },
        ["2"] = {
            order = 30,
            type = "group",
            name = select(2,GetTalentTabInfo(2)),
            args = {
                stormstrike = {
                    order = 1,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.StormStrike),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][1] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][1] end,
                },
                earthshock = {
                    order = 2,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.EarthShock),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][2] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][2] end,
                },
                lavalash = {
                    order = 3,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.LavaLash),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][3] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][3] end,
                },
                firenova = {
                    order = 4,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.FireNova),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][4] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][4] end,
                },
                Searing = {
                    order = 5,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.Searing),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][5] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][5] end,
                },
                shamanisticrage = {
                    order = 6,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.ShamanisticRage),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][6] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][6] end,
                },
                windshear = {
                    order = 7,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.WindShear),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][7] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][7] end,
                },
                lightningshield = {
                    order = 8,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.LightningShield),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][8] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][8] end,
                },
                unleashelements = {
                    order = 9,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.UnleashElements),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][9] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][9] end,
                },
                spiritwalkersgrace = {
                    order = 10,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.SpiritwalkersGrace),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][10] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][10] end,
                },
                flameshock = {
                    order = 29,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.FlameShock).." ("..L["Duration"]..")",
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][21] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][21] end,
                }, 
                feralspirit = {
                    order = 30,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.FeralSpirit),
                    set = function(info, val)TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][20] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][20] end,
                }, 
                maelstrom = {
                    order = 31,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.Maelstrom),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][22] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][22] end,
                }, 
            },
        },
        ["1"] = {
            order = 40,
            type = "group",
            name = select(2,GetTalentTabInfo(1)),
            args = {
                flameshock = {
                    order = 1,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.FlameShock),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][1] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][1] end,
                },
                lavaburst = {
                    order = 2,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.LavaBurst),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][2] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][2] end,
                },
                chainlightning = {
                    order = 3,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.ChainLightning),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][3] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][3] end,
                },
                thunderstorm = {
                    order = 4,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.Thunderstorm),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][4] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][4] end,
                },
                elementalmastery = {
                    order = 5,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.ElementalMastery),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][5] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][5] end,
                },
                searing = {
                    order = 6,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.Searing),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][6] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][6] end,
                },
                firenova = {
                    order = 7,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.FireNova),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][7] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][7] end,
                },
                lightningshield = {
                    order = 8,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.LightningShield),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][8] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][8] end,
                },
                windshear = {
                    order = 9,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.WindShear),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][9] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][9] end,
                },
                unleashelements = {
                    order = 10,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.UnleashElements),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][10] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][10] end,
                },
                spiritwalkersgrace = {
                    order = 11,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.SpiritwalkersGrace),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][11] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][11] end,
                },
                flameshockduration = {
                    order = 30,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.FlameShock).." ("..L["Duration"]..")",
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][20] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][20] end,
                }, 
            },
        },
        ["3"] = {
            order = 50,
            type = "group",
            name = select(2,GetTalentTabInfo(3)),
            args = {
                riptide = {
                    order = 1,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.Riptide),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[3][1] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[3][1] end,
                },
                healingrain = {
                    order = 2,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.HealingRain),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[3][2] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[3][2] end,
                },
                lavalash = {
                    order = 3,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.WaterShield),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[3][3] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[3][3] end,
                },
                earthshock = {
                    order = 4,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.EarthShock),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[3][4] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[3][4] end,
                },
                windshear = {
                    order = 5,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.WindShear),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[3][5] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[3][5] end,
                },
                unleashelements = {
                    order = 6,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.UnleashElements),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[3][6] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[3][6] end,
                },
                spiritwalkersgrace = {
                    order = 7,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.SpiritwalkersGrace),
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[3][7] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[3][7] end,
                },
                flameshockduration = {
                    order = 30,
                    type = "toggle",
                    name = GetSpellInfo(SpellIDs.FlameShock).." ("..L["Duration"]..")",
                    set = function(info, val) TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[3][20] = val  TotemTimers.ProcessSpecSetting("EnhanceCDs") end,
                    get = function(info) return TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[3][20] end,
                }, 
            },
        },
    },
}
    
local ACD = LibStub("AceConfigDialog-3.0")
local frame = ACD:AddToBlizOptions("TotemTimers", L["EnhanceCDs"], "TotemTimers", "enhancecds")    
frame:SetScript("OnEvent", function(self) InterfaceOptionsFrame:Hide() end)
frame:HookScript("OnShow", function(self) if InCombatLockdown() then InterfaceOptionsFrame:Hide() end TotemTimers.LastGUIPanel = self end)
frame:RegisterEvent("PLAYER_REGEN_DISABLED")