-- Copyright © 2008, 2009 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.
-- Current distribution permissions only include curse.com, wowui.worldofwar.net, wowinterface.com and their respective addon updaters

local mb  -- abrev for MulticastButton

local SpellNames = TotemTimers.SpellNames
local AvailableSpells = TotemTimers.AvailableSpells

local SpellIDs = TotemTimers.SpellIDs

local MiniIconPos = {
    ["horizontal"] = {{"BOTTOMRIGHT","TOP"}, {"BOTTOMLEFT", "TOP"}, {"TOPRIGHT", "BOTTOM"}, {"TOPLEFT", "BOTTOM"},},
    ["vertical"] = {{"BOTTOMRIGHT", "LEFT"}, {"BOTTOMLEFT", "RIGHT"}, {"TOPRIGHT", "LEFT"}, {"TOPLEFT", "RIGHT"},},
}

function TotemTimers.CreateMultiCastButtons()
    mb = CreateFrame("CheckButton", "TotemTimers_MultiSpell", UIParent, "ActionButtonTemplate, SecureActionButtonTemplate, SecureHandlerEnterLeaveTemplate, SecureHandlerAttributeTemplate")
    TotemTimers.MB = mb
    mb:SetWidth(36) mb:SetHeight(36) mb:SetScale(32/36)
    mb:SetPoint("CENTER", TotemTimers_MultiSpellFrame, "CENTER")
    mb.bar = TTActionBars:new(3, mb, nil, TotemTimers_MultiSpellFrame, "multicast")
    mb.icon = _G["TotemTimers_MultiSpellIcon"]
    mb:Hide()
    for k = 1,3 do
        local v = mb.bar.buttons[k]
        for i=1,4 do
            local b = v.MiniIcons[i]
            b:ClearAllPoints()
            b:SetWidth(16)
            b:SetHeight(16)
            if i == 1 then b:SetPoint("TOPLEFT", v)
            elseif i == 2 then b:SetPoint("TOPRIGHT", v)
            elseif i == 3 then b:SetPoint("BOTTOMLEFT", v)
            else b:SetPoint("BOTTOMRIGHT", v) end
            v.OnShow = function(self)
                local dir = self.bar.actualDirection
                if dir == "up" or dir == "down" then
                    dir = "vertical"
                else
                    dir = "horizontal"
                end
                for i = 1,4 do
                    self.MiniIcons[i]:ClearAllPoints()
                    self.MiniIcons[i]:SetPoint(MiniIconPos[dir][i][1], self:GetName(), MiniIconPos[dir][i][2])
                    self.MiniIcons[i]:SetTexture(GetActionTexture(TotemTimers.MultiCastActions[i][self:GetAttribute("*spell1")]))
                    self.MiniIcons[i]:Show()
                    end
                end
            --v.OnLeave = function(self) for i = 1,4 do self.MiniIcons[i]:Hide() end end
        end
    end
    
    --for rActionButtonStyler
    mb.action = 0 
    mb:SetCheckedTexture(nil)
    mb.SetCheckedTexture = function() end
    mb.SetChecked = function() end
    if not IsAddOnLoaded("rActionButtonStyler") then
        mb:SetNormalTexture(nil)
    else
        ActionButton_Update(mb)
    end
    mb.icon:Show()

    
    mb:SetAttribute("*type*", "spell")
    
    mb.UpdateTexture = function(self)
        local spell = self:GetAttribute("*spell1")
        if spell then
            local _,_,texture = GetSpellInfo(spell)
            if texture then
                self.icon:SetTexture(texture)
            end
        end
        TotemTimers_Settings.LastMultiCastSpell = spell
    end
    
    mb.HideTooltip = TotemTimers.HideTooltip
	mb:SetAttribute("_onenter", [[  if self:GetAttribute("OpenMenu") == "mouseover" then
                                        control:ChildUpdate("show", true)
                                    end ]])
	mb:SetAttribute("_onleave", [[ control:CallMethod("HideTooltip") ]])
	mb:SetAttribute("_onattributechanged", [[ if name=="hide" then
                                                  control:ChildUpdate("show", false)
                                              elseif name == "*spell1" then 
                                                  control:CallMethod("UpdateTexture")
                                                  control:ChildUpdate("mspell", value)
                                              elseif name == "state-invehicle" then
                                                if value == "show" and self:GetAttribute("active") then self:Show()
                                                else self:Hide()
                                                end
                                              end]])
	mb:WrapScript(mb, "OnClick", [[ if (button == self:GetAttribute("OpenMenu")
                                                        or (button == "Button4" and down)) then
                                                          local open = self:GetAttribute("open")
                                                          control:ChildUpdate("show", not open)
														  self:SetAttribute("open", not open)
                                                      end ]])
                                                      
    mb:SetScript("OnDragStart", function() if not InCombatLockdown() and not TotemTimers_Settings.Lock then TotemTimers_MultiSpellFrame:StartMoving() end end)
    mb:SetScript("OnDragStop", function(self) 
        TotemTimers_MultiSpellFrame:StopMovingOrSizing()
        TotemTimers.SaveFramePositions()
        TotemTimers.ProcessSetting("MultiSpellBarDirection")
        if not InCombatLockdown() then self:SetAttribute("hide", true) end
    end)
    mb:SetAttribute("OpenMenu", "mouseover")
    mb:SetAttribute("*spell2", SpellIDs.TotemicCall)
    mb:SetAttribute("*spell1", TotemTimers_Settings.LastMultiCastSpell or SpellIDs.CallofElements)
    mb:SetAttribute("*spell3", SpellIDs.TotemicCall)
   -- mb:RegisterForClicks("LeftButton, RightButton")
    mb:RegisterForDrag("LeftButton")
    mb:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp", "Button4Down")
end


function TotemTimers.MultiSpellActivate()
    if TotemTimers_Settings.EnableMultiSpellButton and AvailableSpells[SpellIDs.CallofElements] then
        for i=1,4 do
            XiTimers.timers[i].button:SetParent(mb)
        end
        mb:Show()
        TotemTimers.SetMultiCastSpells()
        mb.active = true
        mb:SetAttribute("active", true)
        TotemTimers.ProcessSetting("TimerSize")
    else
        for i=1,4 do
            XiTimers.timers[i].button:SetParent(UIParent)
        end
        mb:Hide()
        mb.active = false
        mb:SetAttribute("active", false)
        TotemTimers.ProcessSetting("TimerSize")
    end
end

function TotemTimers.SetMultiCastSpells()
    mb.bar:ResetSpells()
    if AvailableSpells[SpellIDs.CallofElements] then
        mb.bar:AddSpell(SpellIDs.CallofElements)
    end
    if AvailableSpells[SpellIDs.CallofAncestors] then
        mb.bar:AddSpell(SpellIDs.CallofAncestors)
    end
    if AvailableSpells[SpellIDs.CallofSpirits] then
        mb.bar:AddSpell(SpellIDs.CallofSpirits)
    end
end


