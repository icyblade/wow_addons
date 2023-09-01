-- Copyright © 2008-2011 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.
-- Current distribution permissions only include curse.com, wowui.worldofwar.net, wowinterface.com and their respective addon updaters

local L = LibStub("AceLocale-3.0"):GetLocale("TotemTimers", true)

local SpellIDs = TotemTimers.SpellIDs
local SpellTextures = TotemTimers.SpellTextures
local SpellNames = TotemTimers.SpellNames


local ccs = {}

local player = UnitName("player")


function TotemTimers.CreateCrowdControl()
    ccs[1] = XiTimers:new(1)
    ccs[2] = XiTimers:new(1)
    ccs[1].button.anchorframe = TotemTimers_CrowdControlFrame
    ccs[2].button.anchorframe = TotemTimers_CrowdControlFrame
    ccs[1].button.icons[1]:SetTexture(SpellTextures[SpellIDs.Hex])
    ccs[2].button.icons[1]:SetTexture(SpellTextures[SpellIDs.BindElemental])
    ccs[1].button.SpellID = SpellIDs.Hex
    ccs[2].button.SpellID = SpellIDs.BindElemental
    ccs[1].button.MaxDuration = 60
    ccs[2].button.MaxDuration = 50
    ccs[1].events[1] = "COMBAT_LOG_EVENT_UNFILTERED"
    ccs[1].events[2] = "SPELL_UPDATE_COOLDOWN"
	ccs[2].events[1] = "COMBAT_LOG_EVENT_UNFILTERED"
    ccs[2].events[2] = "SPELL_UPDATE_COOLDOWN"
    ccs[1].button:SetScript("OnEvent", TotemTimers.CrowdControlEvent)
    ccs[2].button:SetScript("OnEvent", TotemTimers.CrowdControlEvent)
    ccs[1].button.BorderBar:SetAlpha(0.4)
    ccs[2].button.BorderBar:SetAlpha(0.4)
    
    ccs[1].button:SetAttribute("*type1", "spell")
    ccs[1].button:SetAttribute("*unit1", "target")
    ccs[1].button:SetAttribute("*spell1", SpellIDs.Hex)
    ccs[1].button:SetAttribute("*type2", "spell")
    ccs[1].button:SetAttribute("*unit2", "focus")
    ccs[1].button:SetAttribute("*spell2", SpellIDs.Hex)
    ccs[1].button:SetAttribute("*type3", "focus")
    ccs[1].button:SetAttribute("*unit3", "target")
 
    ccs[2].button:SetAttribute("*type1", "spell")
    ccs[2].button:SetAttribute("*unit1", "target")
    ccs[2].button:SetAttribute("*spell1", SpellIDs.BindElemental)
    ccs[2].button:SetAttribute("*type2", "spell")
    ccs[2].button:SetAttribute("*unit2", "focus")
    ccs[2].button:SetAttribute("*spell2", SpellIDs.BindElemental)
    ccs[2].button:SetAttribute("*type3", "focus")
    ccs[2].button:SetAttribute("*unit3", "target")
    
    ccs[1].RangeCheck = SpellNames[SpellIDs.Hex]
    ccs[1].ManaCheck = SpellNames[SpellIDs.Hex]
    ccs[2].RangeCheck = SpellNames[SpellIDs.BindElemental]
    ccs[2].ManaCheck = SpellNames[SpellIDs.BindElemental]
    
    ccs[1].button:RegisterForClicks("LeftButtonDown", "RightButtonDown", "MiddleButtonDown")
    ccs[2].button:RegisterForClicks("LeftButtonDown", "RightButtonDown", "MiddleButtonDown")
    
    ccs[1].hasBorderTimer = true
    
    --ccs[1]:activate()
    --ccs[2]:activate()
end

function TotemTimers.LayoutCrowdControl()
    ccs[1].button:ClearAllPoints()
    ccs[2].button:ClearAllPoints()
    ccs[1].button:SetPoint("CENTER", TotemTimers_CrowdControlFrame, "CENTER")
    if TotemTimers_Settings.CrowdControlArrange == "horizontal" then
        ccs[2]:Anchor(ccs[1], "LEFT")
    else
        ccs[2]:Anchor(ccs[1], "TOP")
    end
end

function TotemTimers.CrowdControlEvent(self, event, _, cevent, _, _, source, _, _, dest, _, _, _, spell)
    if event == "SPELL_UPDATE_COOLDOWN" then
        local start, duration, enable = GetSpellCooldown(self.SpellID)
        if (not start and not duration) or (duration <= 2) then
            self.timer:stopborder()
        else
            self.timer:startborder(start+duration-floor(GetTime()), duration)
        end
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        if cevent == "SPELL_AURA_APPLIED" or cevent == "SPELL_AURA_REFRESH" then
            if source == player and self.SpellID == spell then
                self.Dest = dest
                self.timer:start(1, self.MaxDuration)
                self.timer.button.BorderBar:SetAlpha(1)
            end
        elseif self.timer.timers[1] > 0 and dest == self.Dest and 
          (cevent == "SPELL_AURA_REMOVED" or cevent == "SPELL_AURA_BROKEN" or cevent == "SPELL_AURA_BROKEN_SPELL") and spell == self.SpellID then
            self.timer:stop(1)
            self.timer.button.BorderBar:SetAlpha(0.4)
        end
    end
end