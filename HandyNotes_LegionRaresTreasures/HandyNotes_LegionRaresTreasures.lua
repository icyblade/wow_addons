LegionRaresTreasures = LibStub("AceAddon-3.0"):NewAddon("LegionRaresTreasures", "AceBucket-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)

if not HandyNotes then return end

local iconDefaults = {
    default = "Interface\\Icons\\TRADE_ARCHAEOLOGY_CHESTOFTINYGLASSANIMALS",
    unknown = "Interface\\Addons\\HandyNotes_LegionRaresTreasures\\Artwork\\chest_normal_daily.tga",
    swprare = "Interface\\Icons\\Trade_Archaeology_Fossil_SnailShell",
    shrine = "Interface\\Icons\\inv_misc_statue_02",
    glider = "Interface\\Icons\\inv_feather_04",
    rocket = "Interface\\Icons\\ability_mount_rocketmount",
    skull_blue = "Interface\\Addons\\HandyNotes_LegionRaresTreasures\\Artwork\\RareIconBlue.tga",
    skull_green = "Interface\\Addons\\HandyNotes_LegionRaresTreasures\\Artwork\\RareIconGreen.tga",
    skull_grey = "Interface\\Addons\\HandyNotes_LegionRaresTreasures\\Artwork\\RareIcon.tga",
    skull_orange = "Interface\\Addons\\HandyNotes_LegionRaresTreasures\\Artwork\\RareIconOrange.tga",
    skull_purple = "Interface\\Addons\\HandyNotes_LegionRaresTreasures\\Artwork\\RareIconPurple.tga",
    skull_red = "Interface\\Addons\\HandyNotes_LegionRaresTreasures\\Artwork\\RareIconRed.tga",
    skull_yellow = "Interface\\Addons\\HandyNotes_LegionRaresTreasures\\Artwork\\RareIconYellow.tga",
}

local PlayerFaction, _ = UnitFactionGroup("player")
LegionRaresTreasures.nodes = { }

local nodes = LegionRaresTreasures.nodes
local isTomTomloaded = false
local isDBMloaded = false

if (IsAddOnLoaded("TomTom")) then 
    isTomTomloaded = true
end

if (IsAddOnLoaded("DBM-Core")) then 
    isDBMloaded = true
end

-- ICY: Special thanks for 你才圆滚滚 who runs all these nodes below
nodes["HighMountain"] = {
    [49236224]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [42676171]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [53404869]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [49232711]={ "0", "Mellok, Son of Torok", "", "", "default", "rare","120209"},
    [50983880]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [52023241]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [50962570]={ "0", "Shara Felbreath", "", "", "default", "rare","120209"},
    [53063947]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [41327244]={ "0", "入口", "", "", "default", "entrance","134055"},
    [48952717]={ "0", "", "", "", "default", "rare","120209"},
    [38244557]={ "0", "Bristlemaul", "", "", "default", "rare","120209"},
    [47723025]={ "0", "Majestic Elderhorn", "", "", "default", "rare","120209"},
    [39297618]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [50013715]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [41974164]={ "0", "", "", "", "default", "rare","120209"},
    [46763991]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [45525593]={ "0", "Snarf", "", "", "default", "rare","120209"},
    [42203482]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [44097630]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [51473185]={ "0", "Skullhat", "", "", "default", "rare","120209"},
    [52556640]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [43394736]={ "0", "Dargok Thunderuin", "", "", "default", "rare","120209"},
    [42095270]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [39347427]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [53464356]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [37353381]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [46640742]={ "0", "Mrrklr", "", "", "default", "rare","120209"},
    [49297320]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [43981097]={ "0", "Tamed Coralback", "", "", "default", "rare","120209"},
    [42202730]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [50803504]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [51094814]={ "0", "Hartli the Snatcher", "", "", "default", "rare","120209"},
    [47536435]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [38376139]={ "0", "入口", "", "", "default", "entrance","134055"},
    [50983646]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [36626214]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [45135992]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [39386228]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [38215897]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [50665277]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [40955774]={ "0", "", "", "", "default", "rare","120209"},
    [47037268]={ "0", "箱子", "", "", "default", "treasure","9265"},
}
nodes["Valsharah"] = {
    [63037696]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [48607234]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [41557828]={ "0", "", "", "", "default", "rare","120209"},
    [51566789]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [58883398]={ "0", "Ironbranch", "", "", "default", "rare","120209"},
    [46458631]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [39584200]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [67494504]={ "0", "Filandras Mistcaller", "", "", "default", "rare","120209"},
    [43845322]={ "0", "Darkshade", "", "", "default", "rare","120209"},
    [56235730]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [49444885]={ "0", "Eileen the Raven", "", "", "default", "rare","120209"},
    [64695126]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [42675803]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [55137308]={ "0", "入口", "", "", "default", "entrance","134055"},
    [52808734]={ "0", "Shivering Ashmaw Cub", "", "", "default", "rare","120209"},
    [66623711]={ "0", "Wraithtalon", "", "", "default", "rare","120209"},
    [37965281]={ "0", "Theryssia", "", "", "default", "rare","120209"},
    [44204770]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [40514470]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [62624742]={ "0", "Thondrax", "", "", "default", "rare","120209"},
    [61832935]={ "0", "Lyrath Moonfeather", "", "", "default", "rare","120209"},
    [62697032]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [51878044]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [60304426]={ "0", "Dreadbog", "", "", "default", "rare","120209"},
    [55567762]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [61203504]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [64527665]={ "0", "", "", "", "default", "rare","120209"},
    [65775359]={ "0", "Grelda the Hag", "", "", "default", "rare","120209"},
    [56407356]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [37015722]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [53516862]={ "0", "Syndrelle", "", "", "default", "rare","120209"},
    [61066943]={ "0", "Perrexx", "", "", "default", "rare","120209"},
}
nodes["Stormheim"] = {
    [61424317]={ "0", "Tarben", "", "", "default", "rare","120209"},
    [67273986]={ "0", "The Nameless King", "", "", "default", "rare","120209"},
    [36415172]={ "0", "Whitewater Typhoon", "", "", "default", "rare","120209"},
    [49664726]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [57994504]={ "0", "Helmouth Captain", "", "", "default", "rare","120209"},
    [63092070]={ "0", "Eileen the Raven", "", "", "default", "rare","120209"},
    [31345610]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [41877580]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [64855181]={ "0", "Urgev the Flayer", "", "", "default", "rare","120209"},
    [45442255]={ "0", "Apothecary Perez", "", "", "default", "rare","120209"},
    [54782930]={ "0", "Starbuck", "", "", "default", "rare","120209"},
    [42457747]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [72525014]={ "0", "Mordvigbjorn", "", "", "default", "rare","120209"},
    [69064471]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [61404440]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [46838404]={ "0", "Fathnyr", "", "", "default", "rare","120209"},
    [37824090]={ "0", "Bloodstalker Alpha", "", "", "default", "rare","120209"},
    [43698010]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [62086047]={ "0", "Isel the Hammer", "", "", "default", "rare","120209"},
    [35725410]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [55014715]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [27355749]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [78646118]={ "0", "Grrvrgull the Conquerer", "", "", "default", "rare","120209"},
    [53323645]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [68974184]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [59816809]={ "0", "Ivory Sentinel", "", "", "default", "rare","120209"},
    [61044207]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [45797744]={ "0", "Bladesquall", "", "", "default", "rare","120209"},
    [41556658]={ "0", "Glimar Ironfist", "", "", "default", "rare","120209"},
    [42035763]={ "0", "Hook", "", "", "default", "rare","120209"},
    [49245108]={ "0", "Tiptog the Lost", "", "", "default", "rare","120209"},
    [41713397]={ "0", "Egyl the Enduring", "", "", "default", "rare","120209"},
    [49794486]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [49767799]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [49517176]={ "0", "Stormwing Matriarch", "", "", "default", "rare","120209"},
    [46778041]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [67985787]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [73394173]={ "0", "箱子", "", "", "default", "treasure","9265"},
}
nodes["MardumtheShatteredAbyss"] = {
    [41753760]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [80334818]={ "0", "入口", "", "", "default", "entrance","134055"},
    [63242243]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [64035845]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [42194918]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [70635399]={ "0", "入口", "", "", "default", "entrance","134055"},
    [63362312]={ "0", "Count Nefarious", "", "", "default", "rare","120209"},
    [66622380]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [74285454]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [81324145]={ "0", "Overseer Brutarg", "", "", "default", "rare","120209"},
    [44967811]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [78745044]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [68662741]={ "0", "General Volroth", "", "", "default", "rare","120209"},
    [74415734]={ "0", "King Voras", "", "", "default", "rare","120209"},
    [63435415]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [82085044]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [73484890]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [34857021]={ "0", "箱子", "", "", "default", "treasure","9265"},
}
nodes["VaultOfTheWardensDH"] = {
    [58683472]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [69002738]={ "0", "Wrath-Lord Lekos", "", "", "default", "rare","120209"},
    [41466354]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [24440985]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [32114815]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [49753275]={ "0", "Kethrazor", "", "", "default", "rare","120209"},
    [41443293]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [48365374]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [23238159]={ "0", "箱子", "", "", "default", "treasure","9265"},
}
nodes["Helheim"] = {
    [28626186]={ "0", "Soulthirster", "", "", "default", "rare","120209"},
    [60475362]={ "0", "箱子", "", "", "default", "treasure","9265"},
}
nodes["ThunderTotemInterior"] = {
    [62786785]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [47096132]={ "0", "箱子", "", "", "default", "treasure","9265"},
}
nodes["ThunderTotem"] = {
    [63515912]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [32394179]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [13685533]={ "0", "箱子", "", "", "default", "treasure","9265"},
    [50587542]={ "0", "箱子", "", "", "default", "treasure","9265"},
}

--[[
if (PlayerFaction == "Alliance") then
    -- nodes["ShadowmoonValleyDR"][29600620]={ "35281", "Bahameye", "Fire Ammonite", "", "skull_grey", "rare_smv","111666"}
end

if (PlayerFaction == "Horde") then
    -- nodes["Gorgrond"][60805400]={ "36503", "Biolante", "Quest Item for XP", "You must finish the quest before this element gets removed from the map", "skull_grey", "rare_gg","116160"}
end
]]

local function GetItem(ID)
    if (ID == "824" or ID == "823") then
        local currency, _, _ = GetCurrencyInfo(ID)

        if (currency ~= nil) then
            return currency
        else
            return "Error loading CurrencyID"
        end
    else
        local _, item, _, _, _, _, _, _, _, _ = GetItemInfo(ID)

        if (item ~= nil) then
            return item
        else
            return "Error loading ItemID"
        end
    end
end 

local function GetIcon(ID)
    if (ID == "824" or ID == "823") then
        local _, _, icon = GetCurrencyInfo(ID)

        if (icon ~= nil) then
            return icon
        else
            return "Interface\\Icons\\inv_misc_questionmark"
        end
    else
        local _, _, _, _, _, _, _, _, _, icon = GetItemInfo(ID)

        if (icon ~= nil) then
            return icon
        else
            return "Interface\\Icons\\inv_misc_questionmark"
        end
    end
end

function LegionRaresTreasures:OnEnter(mapFile, coord)
    if (not nodes[mapFile][coord]) then return end
    
    local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip

    if ( self:GetCenter() > UIParent:GetCenter() ) then
        tooltip:SetOwner(self, "ANCHOR_LEFT")
    else
        tooltip:SetOwner(self, "ANCHOR_RIGHT")
    end

    tooltip:SetText(nodes[mapFile][coord][2])
    if (nodes[mapFile][coord][3] ~= nil) and (LegionRaresTreasures.db.profile.show_loot == true) then
        if ((nodes[mapFile][coord][7] ~= nil) and (nodes[mapFile][coord][7] ~= "")) then
            tooltip:AddLine(("Loot: " .. GetItem(nodes[mapFile][coord][7])), nil, nil, nil, true)

            if ((nodes[mapFile][coord][3] ~= nil) and (nodes[mapFile][coord][3] ~= "")) then
                tooltip:AddLine(("Lootinfo: " .. nodes[mapFile][coord][3]), nil, nil, nil, true)
            end
        else
            tooltip:AddLine(("Loot: " .. nodes[mapFile][coord][3]), nil, nil, nil, true)
        end
    end

    if (nodes[mapFile][coord][4] ~= "") and (LegionRaresTreasures.db.profile.show_notes == true) then
     tooltip:AddLine(("Notes: " .. nodes[mapFile][coord][4]), nil, nil, nil, true)
    end

    tooltip:Show()
end

local isMoving = false
local info = {}
local clickedMapFile = nil
local clickedCoord = nil

local function generateMenu(button, level)
    if (not level) then return end

    for k in pairs(info) do info[k] = nil end

    if (level == 1) then
        info.isTitle = 1
        info.text = "LegionRaresTreasures"
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)
        
        info.disabled = nil
        info.isTitle = nil
        info.notCheckable = nil
        info.text = "Remove this Object from the Map"
        info.func = DisableTreasure
        info.arg1 = clickedMapFile
        info.arg2 = clickedCoord
        UIDropDownMenu_AddButton(info, level)
        
        if isTomTomloaded == true then
            info.text = "Add this location to TomTom waypoints"
            info.func = addtoTomTom
            info.arg1 = clickedMapFile
            info.arg2 = clickedCoord
            UIDropDownMenu_AddButton(info, level)
        end

        if isDBMloaded == true then
            info.text = "Add this treasure as DBM Arrow"
            info.func = AddDBMArrow
            info.arg1 = clickedMapFile
            info.arg2 = clickedCoord
            UIDropDownMenu_AddButton(info, level)
            
            info.text = "Hide DBM Arrow"
            info.func = HideDBMArrow
            UIDropDownMenu_AddButton(info, level)
        end

        info.text = CLOSE
        info.func = function() CloseDropDownMenus() end
        info.arg1 = nil
        info.arg2 = nil
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)

        info.text = "Restore Removed Objects"
        info.func = ResetDB
        info.arg1 = nil
        info.arg2 = nil
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)
        
    end
end

local HandyNotes_LegionRaresTreasuresDropdownMenu = CreateFrame("Frame", "HandyNotes_LegionRaresTreasuresDropdownMenu")
HandyNotes_LegionRaresTreasuresDropdownMenu.displayMode = "MENU"
HandyNotes_LegionRaresTreasuresDropdownMenu.initialize = generateMenu

function LegionRaresTreasures:OnClick(button, down, mapFile, coord)
    if button == "RightButton" and down then
        clickedMapFile = mapFile
        clickedCoord = coord
        ToggleDropDownMenu(1, nil, HandyNotes_LegionRaresTreasuresDropdownMenu, self, 0, 0)
    end
end

function LegionRaresTreasures:OnLeave(mapFile, coord)
    if self:GetParent() == WorldMapButton then
        WorldMapTooltip:Hide()
    else
        GameTooltip:Hide()
    end
end

local options = {
    type = "group",
    name = "LegionRaresTreasures",
    desc = "Locations of treasures in Draenor.",
    get = function(info) return LegionRaresTreasures.db.profile[info.arg] end,
    set = function(info, v) LegionRaresTreasures.db.profile[info.arg] = v; LegionRaresTreasures:Refresh() end,
    args = {
        desc = {
            name = "General Settings",
            type = "description",
            order = 0,
        },
        icon_scale_treasures = {
            type = "range",
            name = "Icon Scale for Treasures",
            desc = "The scale of the icons",
            min = 0.25, max = 3, step = 0.01,
            arg = "icon_scale_treasures",
            order = 1,
        },
        icon_scale_rares = {
            type = "range",
            name = "Icon Scale for Rares",
            desc = "The scale of the icons",
            min = 0.25, max = 3, step = 0.01,
            arg = "icon_scale_rares",
            order = 2,
        },
        icon_alpha = {
            type = "range",
            name = "Icon Alpha",
            desc = "The alpha transparency of the icons",
            min = 0, max = 1, step = 0.01,
            arg = "icon_alpha",
            order = 20,
        },
        VisibilityOptions = {
            type = "group",
            name = "Visibility Settings",
            desc = "Visibility Settings",
            args = {
                VisibilityGroup = {
                    type = "group",
                    order = 0,
                    name = "Select what to show:",
                    inline = true,
                    args = {
                        treasure = {
                            type = "toggle",
                            arg = "treasure",
                            name = "Treasures",
                            desc = "Treasures",
                            order = 1,
                            width = "half",
                        },
                        rare = {
                            type = "toggle",
                            arg = "rare",
                            name = "Rares",
                            desc = "Rares",
                            order = 2,
                            width = "half",
                        },
                        entrance = {
                            type = "toggle",
                            arg = "entrance",
                            name = "Entrance to somewhere",
                            desc = "Entrance to somewhere",
                            order = 3,
                            width = "half",
                        },
                    },
                },
                alwaysshowrares = {
                    type = "toggle",
                    arg = "alwaysshowrares",
                    name = "Also show already looted Rares",
                    desc = "Show every rare regardless of looted status",
                    order = 100,
                    width = "full",
                },
                alwaysshowtreasures = {
                    type = "toggle",
                    arg = "alwaysshowtreasures",
                    name = "Also show already looted Treasures",
                    desc = "Show every treasure regardless of looted status",
                    order = 101,
                    width = "full",
                },
                show_loot = {
                    type = "toggle",
                    arg = "show_loot",
                    name = "Show Loot",
                    desc = "Shows the Loot for each Treasure/Rare",
                    order = 102,
                },
                show_notes = {
                    type = "toggle",
                    arg = "show_notes",
                    name = "Show Notes",
                    desc = "Shows the notes each Treasure/Rare if available",
                    order = 103,
                },
            },
        },
    },
}

function LegionRaresTreasures:OnInitialize()
    local defaults = {
        profile = {
            icon_scale_treasures = 1.5,
            icon_scale_rares = 2.0,
            icon_alpha = 1.00,
            alwaysshowrares = false,
            alwaysshowtreasures = false,
            save = true,
            treasure_smv = true,
            treasure_ffr = true,
            treasure_ffr_bsf = true,
            treasure_gg = true,
            treasure_gg_b = true,
            treasure_gg_l = true,
            treasure_ng = true,
            treasure_soa = true,
            treasure_soa_a = true,
            treasure_td = true,
            treasure_tj = true,
            rare_smv = true,
            rare_ffr = true,
            rare_gg = true,
            rare_td = true,
            rare_soa = true,
            rare_ng = true,
            rare_h_gg = true,
            rare_h_ffr = true,
            rare_s_gg = true,
            rare_h_td = true,
            rare_h_soa = true,
            rare_h_ng = true,
            rare_h_tj = true,
            rare_s_gg = true,
            rare_s_ng = true,
            rare_a_tj = true,
            mount_tj = true,
            mount_pr = true,
            mount_go = true,
            mount_no = true,
            mount_po = true,
            mount_si = true,
            mount_na = true,
            mount_lu = true,
            mount_vt = true,
            world_bosses = true,
            show_loot = true,
            show_notes = true,
        },
    }

    self.db = LibStub("AceDB-3.0"):New("LegionRaresTreasuresDB", defaults, "Default")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "WorldEnter")
end

function LegionRaresTreasures:WorldEnter()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:ScheduleTimer("QuestCheck", 5)
    self:ScheduleTimer("RegisterWithHandyNotes", 8)
end

function LegionRaresTreasures:QuestCheck()
    return
    --[[
    do
        if ((IsQuestFlaggedCompleted(36386) == false) or (IsQuestFlaggedCompleted(36390) == false) or (IsQuestFlaggedCompleted(36389) == false) or (IsQuestFlaggedCompleted(36392) == false) or (IsQuestFlaggedCompleted(36388) == false) or (IsQuestFlaggedCompleted(36381) == false)) then
            nodes["SpiresOfArak"][43901500]={ "36395", "Elixir of Shadow Sight 1", "Elixir of Shadow Sight", "Elixir can be used at Shrine of Terrok for 1 of 6 i585 Weapons (see Gift of Anzu) Object will be removed as soon as you loot all Gifts of Anzu", "default", "treasure_soa","115463"}
            nodes["SpiresOfArak"][43802470]={ "36397", "Elixir of Shadow Sight 2", "Elixir of Shadow Sight", "Elixir can be used at Shrine of Terrok for 1 of 6 i585 Weapons (see Gift of Anzu) Object will be removed as soon as you loot all Gifts of Anzu", "default", "treasure_soa","115463"}
            nodes["SpiresOfArak"][69204330]={ "36398", "Elixir of Shadow Sight 3", "Elixir of Shadow Sight", "Elixir can be used at Shrine of Terrok for 1 of 6 i585 Weapons (see Gift of Anzu) Object will be removed as soon as you loot all Gifts of Anzu", "default", "treasure_soa","115463"}
            nodes["SpiresOfArak"][48906250]={ "36399", "Elixir of Shadow Sight 4", "Elixir of Shadow Sight", "Elixir can be used at Shrine of Terrok for 1 of 6 i585 Weapons (see Gift of Anzu) Object will be removed as soon as you loot all Gifts of Anzu", "default", "treasure_soa","115463"}
            nodes["SpiresOfArak"][55602200]={ "36400", "Elixir of Shadow Sight 5", "Elixir of Shadow Sight", "Elixir can be used at Shrine of Terrok for 1 of 6 i585 Weapons (see Gift of Anzu) Object will be removed as soon as you loot all Gifts of Anzu", "default", "treasure_soa","115463"}
            nodes["SpiresOfArak"][53108450]={ "36401", "Elixir of Shadow Sight 6", "Elixir of Shadow Sight", "Elixir can be used at Shrine of Terrok for 1 of 6 i585 Weapons (see Gift of Anzu) Object will be removed as soon as you loot all Gifts of Anzu", "default", "treasure_soa","115463"}
        end
        if (IsQuestFlaggedCompleted(36249) or IsQuestFlaggedCompleted(36250)) then
            --Gorgrond Lumber Mill is active if either of these Quest IDs are true
            nodes["Gorgrond"][49074846]={ "950000", "Aged Stone Container", "", "QuestID is missing, will stay active until manually disabled", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][42345477]={ "36003", "Aged Stone Container", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][47514363]={ "36717", "Aged Stone Container", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][53354679]={ "35701", "Ancient Titan Chest", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][50155376]={ "35984", "Ancient Titan Chest", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][42084607]={ "36720", "Ancient Titan Chest", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][41988155]={ "35982", "Botani Essence Seed", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][49657883]={ "35968", "Forgotten Ogre Cache", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][47016905]={ "35971", "Forgotten Skull Cache", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][45808931]={ "36019", "Forgotten Skull Cache", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][39335627]={ "36716", "Forgotten Skull Cache", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][56745727]={ "35965", "Mysterious Petrified Pod", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][41147726]={ "35980", "Mysterious Petrified Pod", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][60507276]={ "36015", "Mysterious Petrified Pod", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][63285719]={ "36430", "Mysterious Petrified Pod", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][47647679]={ "36714", "Mysterious Petrified Pod", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][51756909]={ "36715", "Mysterious Petrified Pod", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][40956732]={ "35979", "Obsidian Crystal Formation", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][45969357]={ "35975", "Remains of Explorer Engineer Toldirk Ashlamp", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][51806148]={ "35966", "Remains of Grimnir Ashpick", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][51647226]={ "35967", "Unknown Petrified Egg", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][45318195]={ "35981", "Unknown Petrified Egg", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][42914350]={ "36001", "Unknown Petrified Egg", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][53007906]={ "36713", "Unknown Petrified Egg", "", "", "default", "treasure_gg_l","824"}
            nodes["Gorgrond"][47245180]={ "36718", "Unknown Petrified Egg", "", "", "default", "treasure_gg_l","824"}
        end
        if (IsQuestFlaggedCompleted(36251) or IsQuestFlaggedCompleted(36252)) then
            --Gorgrond Sparring Arena is active if either of these Quest IDs are true
            nodes["Gorgrond"][45634931]={ "36722", "Aged Stone Container", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][43224574]={ "36723", "Aged Stone Container", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][41764527]={ "36726", "Aged Stone Container", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][48115516]={ "36730", "Aged Stone Container", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][51334055]={ "36734", "Aged Stone Container", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][46056305]={ "36736", "Aged Stone Container", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][58125146]={ "36739", "Aged Stone Container", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][59567275]={ "36781", "Aged Stone Container", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][45748821]={ "36784", "Aged Stone Container", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][45544298]={ "36733", "Ancient Ogre Cache", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][45076993]={ "36737", "Ancient Ogre Cache", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][61555855]={ "36740", "Ancient Ogre Cache", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][54257313]={ "36782", "Ancient Ogre Cache", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][42179308]={ "36787", "Ancient Ogre Cache", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][41528652]={ "36789", "Ancient Ogre Cache", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][49425084]={ "36710", "Ancient Titan Chest", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][42195203]={ "36727", "Ancient Titan Chest", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][43365169]={ "36731", "Ancient Titan Chest", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][47923998]={ "36735", "Ancient Titan Chest", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][50326658]={ "36738", "Ancient Titan Chest", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][49128248]={ "36783", "Ancient Titan Chest", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][48114638]={ "36721", "Obsidian Crystal Formation", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][41855889]={ "36728", "Obsidian Crystal Formation", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][42056429]={ "36729", "Obsidian Crystal Formation", "", "", "default", "treasure_gg_b","824"}
            nodes["Gorgrond"][44184665]={ "36732", "Obsidian Crystal Formation", "", "", "default", "treasure_gg_b","824"}
        end
    end]]
end

function LegionRaresTreasures:RegisterWithHandyNotes()
    do
        local function iter(t, prestate)
            if not t then return nil end

            local state, value = next(t, prestate)

            while state do
                if (value[1] and self.db.profile[value[6]] and not LegionRaresTreasures:HasBeenLooted(value)) and (value[6] == "rare_h_tj") then
                    if (self.db.profile.TanaanHundredAchievement) then
                        if ((value[8] ~= nil) and (value[8] ~= "")) then
                            local _, _, completed, _, _, _, _, _, _, _, _ = GetAchievementCriteriaInfoByID(10070, value[8])

                            if (completed == false) then
                                if ((value[7] ~= nil) and (value[7] ~= "")) then
                                    GetIcon(value[7]) --this should precache the Item, so that the loot is correctly returned
                                end

                                if ((value[5] == "default") or (value[5] == "unknown")) then
                                    if ((value[7] ~= nil) and (value[7] ~= "")) then
                                        return state, nil, GetIcon(value[7]), LegionRaresTreasures.db.profile.icon_scale_treasures, LegionRaresTreasures.db.profile.icon_alpha
                                    else
                                        return state, nil, iconDefaults[value[5]], LegionRaresTreasures.db.profile.icon_scale_treasures, LegionRaresTreasures.db.profile.icon_alpha
                                    end
                                end

                                return state, nil, iconDefaults[value[5]], LegionRaresTreasures.db.profile.icon_scale_rares, LegionRaresTreasures.db.profile.icon_alpha
                            end
                        end
                    else
                        if ((value[7] ~= nil) and (value[7] ~= "")) then
                            GetIcon(value[7]) --this should precache the Item, so that the loot is correctly returned
                        end

                        if ((value[5] == "default") or (value[5] == "unknown")) then
                            if ((value[7] ~= nil) and (value[7] ~= "")) then
                                return state, nil, GetIcon(value[7]), LegionRaresTreasures.db.profile.icon_scale_treasures, LegionRaresTreasures.db.profile.icon_alpha
                            else
                                return state, nil, iconDefaults[value[5]], LegionRaresTreasures.db.profile.icon_scale_treasures, LegionRaresTreasures.db.profile.icon_alpha
                            end
                        end

                        return state, nil, iconDefaults[value[5]], LegionRaresTreasures.db.profile.icon_scale_rares, LegionRaresTreasures.db.profile.icon_alpha 
                    end
                end

                -- QuestID[1], Name[2], Loot[3], Notes[4], Icon[5], Tag[6], ItemID[7]
                if (value[1] and self.db.profile[value[6]] and not LegionRaresTreasures:HasBeenLooted(value)) and (value[6] ~= "rare_h_tj") then
                    if ((value[7] ~= nil) and (value[7] ~= "")) then
                        GetIcon(value[7]) --this should precache the Item, so that the loot is correctly returned
                    end

                    if ((value[5] == "default") or (value[5] == "unknown")) then
                        if ((value[7] ~= nil) and (value[7] ~= "")) then
                            return state, nil, GetIcon(value[7]), LegionRaresTreasures.db.profile.icon_scale_treasures, LegionRaresTreasures.db.profile.icon_alpha
                        else
                            return state, nil, iconDefaults[value[5]], LegionRaresTreasures.db.profile.icon_scale_treasures, LegionRaresTreasures.db.profile.icon_alpha
                        end
                    end

                    return state, nil, iconDefaults[value[5]], LegionRaresTreasures.db.profile.icon_scale_rares, LegionRaresTreasures.db.profile.icon_alpha
                end

                state, value = next(t, state)
            end
        end

        function LegionRaresTreasures:GetNodes(mapFile, isMinimapUpdate, dungeonLevel)
            return iter, nodes[mapFile], nil
        end
    end

    HandyNotes:RegisterPluginDB("LegionRaresTreasures", self, options)
    self:RegisterBucketEvent({ "LOOT_CLOSED" }, 2, "Refresh")
    self:Refresh()
end
 
function LegionRaresTreasures:Refresh()
    self:SendMessage("HandyNotes_NotifyUpdate", "LegionRaresTreasures")
end

function ResetDB()
    table.wipe(LegionRaresTreasures.db.char)
    LegionRaresTreasures:Refresh()
end

function LegionRaresTreasures:HasBeenLooted(value)
    if (self.db.profile.alwaysshowtreasures and (string.find(value[6], "Treasures") ~= nil)) then return false end
    if (self.db.profile.alwaysshowrares and (string.find(value[6], "Treasures") == nil)) then return false end
    if (LegionRaresTreasures.db.char[value[1]] and self.db.profile.save) then return true end
    if (IsQuestFlaggedCompleted(value[1])) then
        return true
    end

    return false
end

function DisableTreasure(button, mapFile, coord)
    if (nodes[mapFile][coord][1] ~= nil) then
        LegionRaresTreasures.db.char[nodes[mapFile][coord][1]] = true;
    end

    LegionRaresTreasures:Refresh()
end

function addtoTomTom(button, mapFile, coord)
    if isTomTomloaded == true then
        local mapId = HandyNotes:GetMapFiletoMapID(mapFile)
        local x, y = HandyNotes:getXY(coord)
        local desc = nodes[mapFile][coord][2];

        if (nodes[mapFile][coord][3] ~= nil) and (LegionRaresTreasures.db.profile.show_loot == true) then
            if ((nodes[mapFile][coord][7] ~= nil) and (nodes[mapFile][coord][7] ~= "")) then
                desc = desc.."\nLoot: " .. GetItem(nodes[mapFile][coord][7]);
                desc = desc.."\nLoot Info: " .. nodes[mapFile][coord][3];
            else
                desc = desc.."\nLoot: " .. nodes[mapFile][coord][3];
            end
        end

        if (nodes[mapFile][coord][4] ~= "") and (LegionRaresTreasures.db.profile.show_notes == true) then
            desc = desc.."\nNotes: " .. nodes[mapFile][coord][4]
        end

        TomTom:AddMFWaypoint(mapId, nil, x, y, {
            title = desc,
            persistent = nil,
            minimap = true,
            world = true
        })
    end
end

if isDBMloaded == true then
    local ArrowDesc = DBMArrow:CreateFontString(nil, "OVERLAY", "GameTooltipText")
    ArrowDesc:SetWidth(400)
    ArrowDesc:SetHeight(100)
    ArrowDesc:SetPoint("CENTER", DBMArrow, "CENTER", 0, -35)
    ArrowDesc:SetTextColor(1, 1, 1, 1)
    ArrowDesc:SetJustifyH("CENTER")
    DBMArrow.Desc = ArrowDesc
end

function AddDBMArrow(button, mapFile, coord)
    if isDBMloaded == true then
        local mapId = HandyNotes:GetMapFiletoMapID(mapFile)
        local x, y = HandyNotes:getXY(coord)
        local desc = nodes[mapFile][coord][2];

        if (nodes[mapFile][coord][3] ~= nil) and (LegionRaresTreasures.db.profile.show_loot == true) then
            if ((nodes[mapFile][coord][7] ~= nil) and (nodes[mapFile][coord][7] ~= "")) then
                desc = desc.."\nLoot: " .. GetItem(nodes[mapFile][coord][7]);
                desc = desc.."\nLootinfo: " .. nodes[mapFile][coord][3];
            else
                desc = desc.."\nLoot: " .. nodes[mapFile][coord][3];
            end
        end

        if (nodes[mapFile][coord][4] ~= "") and (LegionRaresTreasures.db.profile.show_notes == true) then
            desc = desc.."\nNotes: " .. nodes[mapFile][coord][4]
        end

        if not DBMArrow.Desc:IsShown() then
            DBMArrow.Desc:Show()
        end

        x = x*100
        y = y*100
        DBMArrow.Desc:SetText(desc)
        DBM.Arrow:ShowRunTo(x, y, nil, nil, true)
    end
end

function HideDBMArrow()
    DBM.Arrow:Hide(true)
end