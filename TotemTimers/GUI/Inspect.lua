-- Copyright © 2008 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.

local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS

local TalentTreesToTTClasses = {
    ["SHAMAN"]  = {3,5,4},
    ["PRIEST"]  = {4,4,3},
    ["DRUID"]   = {3,1,4},
    ["PALADIN"] = {4,1,1},
}

local fontStrings = {}
local ddmenus = {}

for i=1,15 do
    ddmenus[i] = CreateFrame("Button", "TotemTimers_InspectDD"..i, TotemTimers_GUI_Inspect, "UIDropDownMenuTemplate")
    ddmenus[i]:ClearAllPoints()
    ddmenus[i]:SetPoint("TOPLEFT", TotemTimers_GUI_Inspect, "TOPLEFT", 75, -5-(i-1)*27)
    UIDropDownMenu_SetWidth(ddmenus[i], 90, 0)
    fontStrings[i] = TotemTimers_GUI_Inspect:CreateFontString("TotemTimers_GUI_InspectText"..i, "ARTWORK", "GameFontNormalSmall")
    fontStrings[i]:ClearAllPoints()
    fontStrings[i]:SetPoint("TOPLEFT", TotemTimers_GUI_Inspect, "TOPLEFT", 10, -14-(i-1)*27)
    fontStrings[i]:SetWidth(80)
    fontStrings[i]:SetHeight(10)
    fontStrings[i]:SetNonSpaceWrap(false)
end
for i=1,15 do
    ddmenus[i+15] = CreateFrame("Button", "TotemTimers_InspectDD"..(i+15), TotemTimers_GUI_Inspect, "UIDropDownMenuTemplate")
    ddmenus[i+15]:ClearAllPoints()
    ddmenus[i+15]:SetPoint("TOPLEFT", TotemTimers_GUI_Inspect, "TOPLEFT", 280, -5-(i-1)*27)
    UIDropDownMenu_SetWidth(ddmenus[i+15], 90, 0)
    fontStrings[i+15] = TotemTimers_GUI_Inspect:CreateFontString("TotemTimers_GUI_InspectText"..(i+15), "ARTWORK", "GameFontNormalSmall")
    fontStrings[i+15]:ClearAllPoints()
    fontStrings[i+15]:SetPoint("TOPLEFT", TotemTimers_GUI_Inspect, "TOPLEFT", 215, -12-(i-1)*27)
    fontStrings[i+15]:SetWidth(80)
    fontStrings[i+15]:SetHeight(10)
end


function TotemTimers_GUI_UpdateInspects()
    local classes, wowclasses = TotemTimers.GetRaidClasses()
    for i=1,30 do
        ddmenus[i]:Hide()
        fontStrings[i]:Hide()
    end
    local c = 0
    for name, class in pairs(classes) do
        if wowclasses[name] == "DRUID" or wowclasses[name] == "PALADIN" or wowclasses[name] == "PRIEST" or wowclasses[name] == "SHAMAN" then
            c = c + 1
            if c > 30 then break end
            fontStrings[c]:Show()
            ddmenus[c]:Show()
            fontStrings[c]:SetText(name)
            if RAID_CLASS_COLORS[wowclasses[name]] then
                fontStrings[c]:SetTextColor(RAID_CLASS_COLORS[wowclasses[name]].r,RAID_CLASS_COLORS[wowclasses[name]].g,RAID_CLASS_COLORS[wowclasses[name]].b)
            end
            UIDropDownMenu_SetText(ddmenus[c], TT_GUI_ROLE_NAMES[class])
            ddmenus[c].member = name
        end
    end
end

local function TotemTimers_GUI_InspectDropdown_OnClick(self, class, ddmenu)
    TotemTimers.SetRaidClass(ddmenu.member, class)
    TotemTimers_GUI_Inspect:Hide()
    TotemTimers_GUI_Inspect:Show()
end

local function TotemTimers_GUI_InitInspectDropdown(self)
    --[[local info = {}
    info.func = TotemTimers_GUI_InspectDropdown_OnClick
    for i=0,5 do
		info.text = TT_GUI_ROLE_NAMES[i]
    	info.arg1 = i
        info.arg2 = self
		UIDropDownMenu_AddButton(info)
    end]]
end

for i=1,30 do
    UIDropDownMenu_Initialize(ddmenus[i], TotemTimers_GUI_InitInspectDropdown)
end



