-- Copyright © 2008, 2009 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.
-- Current distribution permissions only include curse.com, wowui.worldofwar.net, wowinterface.com and their respective addon updaters

local L = LibStub("AceLocale-3.0"):GetLocale("TotemTimers", true)

local SpellNames = TotemTimers.SpellNames

local r = 0
local g = 0.9
local b = 1


local function SetTooltipSpellID(id)
    if GetCVar("UberTooltips") == "1" then
         GameTooltip:SetSpellByID(id)
    else
        GameTooltip:ClearLines()
        GameTooltip:AddLine(SpellNames[id],1,1,1)
    end
end

function TotemTimers.PositionTooltip(self)
    if not TotemTimers_Settings.TooltipsAtButtons then 
        GameTooltip_SetDefaultAnchor(GameTooltip, self)
    else
        local left = self:GetLeft()
        if left<UIParent:GetWidth()/2 then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        else			
            GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        end
    end
end

function TotemTimers.HideTooltip(self)
    GameTooltip:Hide()
end

function TotemTimers.TimerTooltip(self)
    if self.timer and self.element and not IsModifierKeyDown() and TotemTimers_Settings.ShowRaidRangeTooltip then
        if self.timer.timers[1] <= 0 then return end
        local count = TotemTimers.GetOutOfRange(self.element)
        if count <= 0 then return end
        local missingBuffGUIDs, names, classes = TotemTimers.GetOutOfRangePlayers(self.element)
        GameTooltip:ClearLines()
        TotemTimers.PositionTooltip(self)
        for guid,_ in pairs(missingBuffGUIDs) do
            GameTooltip:AddLine(names[guid], RAID_CLASS_COLORS[classes[guid]].r, RAID_CLASS_COLORS[classes[guid]].g, RAID_CLASS_COLORS[classes[guid]].b)
        end
        GameTooltip:Show()
    elseif self:GetAttribute("tooltip") then
        local spell = self:GetAttribute("*spell1")
        if spell and spell > 0 then
            TotemTimers.PositionTooltip(self)
            SetTooltipSpellID(spell)
        end
    end
end



function TotemTimers.WeaponBarTooltip(self)
    TotemTimers.PositionTooltip(self)
    local spell = self:GetAttribute("*spell1")
    if spell and type(spell) == "string" then spell = TotemTimers.MaxSpellIDs[spell] end
    local ds1, ds2
    if spell and spell > 0 then
        SetTooltipSpellID(spell)
    else
        ds1 = self:GetAttribute("doublespell1")
        ds2 = self:GetAttribute("doublespell2")
        if ds1 and ds2 then
            if type(ds1) == "number" then
                ds1 = GetSpellInfo(ds1)
                ds2 = GetSpellInfo(ds2)
            end
        end
        GameTooltip:ClearLines()
        GameTooltip:SetText(ds1.." + \n"..ds2,nil,nil,nil,nil,1)
    end
    GameTooltip:AddLine(" ")
    if ds1 and ds2 then
        GameTooltip:AddLine(format(L["Rightclick to assign both %s and %s to leftclick"], ds1, ds2),r,g,b,1)
    else
        GameTooltip:AddLine(L["Leftclick to cast spell"],r,g,b,1)
        GameTooltip:AddLine(L["Rightclick to assign spell to leftclick"],r,g,b,1)
        if self:GetParent():GetAttribute("OpenMenu") == "RightButton" then
            GameTooltip:AddLine(L["Shift-Rightclick to assign spell to middleclick"],r,g,b,1)
        else
            GameTooltip:AddLine(L["Shift-Rightclick to assign spell to rightclick"],r,g,b,1)
        end
    end
    GameTooltip:Show()
end


function TotemTimers.WeaponButtonTooltip(self)
    if not TotemTimers_Settings.Tooltips then return end
    GameTooltip:ClearLines()
    TotemTimers.PositionTooltip(self)
    local text = "-"
    if self.timer.timers[1]>0 and TotemTimers_Settings.LastMainEnchants[TotemTimers.MainHand] then
        text = TotemTimers_Settings.LastMainEnchants[TotemTimers.MainHand][1] or "?"
    end
    if self.timer.numtimers == 2 and self.timer.timers[2] > 0 and TotemTimers_Settings.LastOffEnchants[TotemTimers.OffHand] then
        text = text..", "..(TotemTimers_Settings.LastOffEnchants[TotemTimers.OffHand][1])
    elseif self.timer.numtimers > 1 then
        text = text..", ?"
    end
    if not text then text = " " end
    GameTooltip:AddLine(text)
    local s = self:GetAttribute("spell1")
    if s and not self:GetAttribute("doublespell1") then
        local n = GetSpellInfo(s)
        text = format(L["Leftclick to cast %s"], n)
        GameTooltip:AddLine(text,r,g,b,1)
    else
        local ds = self:GetAttribute("ds")
        if ds then
            local ds1 = self:GetAttribute("doublespell1")
            local ds2 = self:GetAttribute("doublespell2")
            if ds == 2 then ds1, ds2 = ds2, ds1 end
            if ds1 and ds2 then
                GameTooltip:AddLine(format(L["Leftclick to cast %s"], ds1),r,g,b,1)
                GameTooltip:AddLine(format(L["Next leftclick casts %s"], ds2),r,g,b,1)
            end
        end
    end
    s = self:GetAttribute("spell2")
    if s then GameTooltip:AddLine(format(L["Rightclick to cast %s"],s),r,g,b,1)
    else
        s = self:GetAttribute("spell3")
        GameTooltip:AddLine(format(L["Middleclick to cast %s"],s),r,g,b,1)
    end
    GameTooltip:AddLine(L["Ctrl-Leftclick to remove weapon buffs"],r,g,b,1)
    GameTooltip:Show()
end


function TotemTimers.TotemTooltip(self)
    local spell = self:GetAttribute("*spell1")
    if spell and type(spell) == "string" then spell = TotemTimers.MaxSpellIDs[spell] end
    TotemTimers.PositionTooltip(self)
    if spell and spell > 0 then
        SetTooltipSpellID(spell)
    end

    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L["Leftclick to cast spell"],r,g,b,1)
    local button = L["Fire Button"]
    if self.bar.order == 2 then button = L["Earth Button"]
    elseif self.bar.order == 3 then button = L["Water Button"]
    elseif self.bar.order == 4 then button = L["Air Button"] end
    GameTooltip:AddLine(string.format(L["Rightclick to assign totem to %s and %s"],
                                      SpellNames[TotemTimers.MB:GetAttribute("*spell1")],button),r,g,b,1)
    GameTooltip:Show()
end


function TotemTimers.SetTooltip(self)
    if not TotemTimers_Settings.Tooltips then return end
    TotemTimers.PositionTooltip(self)
    GameTooltip:AddLine(L["Leftclick to open totem set menu"],r,g,b,1)
    GameTooltip:AddLine(L["Rightclick to save active totem configuration as set"],r,g,b,1)
    GameTooltip:Show()
end

function TotemTimers.SetButtonTooltip(self)
    TotemTimers.PositionTooltip(self)
    GameTooltip:AddLine(string.format(L["Leftclick to load totem set to %s"], SpellNames[TotemTimers.MB:GetAttribute("*spell1")]),r,g,b,1)
    GameTooltip:AddLine(L["Rightclick to delete totem set"],r,g,b,1)
    GameTooltip:Show()
end

function TotemTimers.MultiSpellButtonTooltip(self)
    local spell = self:GetAttribute("*spell1")
    TotemTimers.PositionTooltip(self)
    if spell and spell > 0 then
        SetTooltipSpellID(spell)
    end
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(string.format(L["Leftclick to cast %s"],SpellNames[spell]),r,g,b,1)
    GameTooltip:AddLine(string.format(L["Rightclick to set %s as active multicast spell"], SpellNames[TotemTimers.MB:GetAttribute("*spell1")]),r,g,b,1)
    GameTooltip:Show()
end