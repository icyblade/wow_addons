-- Copyright © 2008, 2009 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.
-- Current distribution permissions only include curse.com, wowui.worldofwar.net, wowinterface.com and their respective addon updaters

local L = LibStub("AceLocale-3.0"):GetLocale("TotemTimers", true)

local buttonlocations = {
	{"BOTTOM", "TOP"},
	{"BOTTOMLEFT", "TOPRIGHT"},
	{"LEFT", "RIGHT"},
	{"TOPLEFT", "BOTTOMRIGHT"},
	{"TOP", "BOTTOM"},
	{"TOPRIGHT", "BOTTOMLEFT"},
	{"RIGHT", "LEFT"},
	{"BOTTOMRIGHT", "TOPLEFT"},
}

function TotemTimers_InitSetButtons()
    ankh = XiTimers.timers[5].button 
    ankh:SetScript("OnClick", TotemTimers_SetAnchor_OnClick)
    TotemTimers_ProgramSetButtons()
    ankh:WrapScript(XiTimers.timers[5].button, "OnClick",
                                                            [[ if button == "LeftButton" then
                                                                local open = self:GetAttribute("open")
                                                                control:ChildUpdate("show", not open)
																self:SetAttribute("open", not open)
                                                            end ]])
    ankh.HideTooltip = TotemTimers.HideTooltip
    ankh.ShowTooltip = TotemTimers.SetTooltip
    ankh:SetAttribute("_onleave", [[ control:CallMethod("HideTooltip") ]])
    ankh:SetAttribute("_onenter", [[ if self:GetAttribute("tooltip") then control:CallMethod("ShowTooltip") end ]])
    ankh:SetAttribute("_onattributechanged", [[ if name=="hide" then
                                                    control:ChildUpdate("show", false)
                                                    self:SetAttribute("open", false)
                                                elseif name=="state-invehicle" then
                                                    if value == "show" and self:GetAttribute("active") then
                                                        self:Show()
                                                    else
                                                        self:Hide()
                                                    end
                                                end]])
end

function TotemTimers_ProgramSetButtons()
    local Sets = TotemTimers_Settings.TotemSets
	local nr = 0
	for i=1,8 do
        local b = _G["TotemTimers_SetButton"..i]
        if not b then
            b = CreateFrame("Button", "TotemTimers_SetButton"..i, XiTimers.timers[5].button, "TotemTimers_SetButtonTemplate")
            b:SetAttribute("_childupdate-show", [[ if message and not self:GetAttribute("inactive") then self:Show() else self:Hide() end ]])
            b:SetAttribute("_onleave", [[ control:CallMethod("HideTooltip")  ]]) 
            b:SetAttribute("_onenter", [[ control:CallMethod("ShowTooltip") ]])
            b.nr = i
            b.HideTooltip = TotemTimers.HideTooltip
            b.ShowTooltip = TotemTimers.SetButtonTooltip
            b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
            b:SetParent(XiTimers.timers[5].button)
        end
        b:ClearAllPoints()
        b:SetPoint(buttonlocations[i][1], XiTimers.timers[5].button, buttonlocations[i][2])
        if Sets[i] then
            for k = 1,4 do
                local icon = _G[b:GetName().."Icon"..k]
                if Sets[i][k] > 0 then
                    local _,_,texture = GetSpellInfo(Sets[i][k])				
                    TotemTimers.SetEmptyTexCoord(icon)
                    icon:SetTexture(texture)
                else
                    TotemTimers.SetEmptyTexCoord(icon,k)
                    icon:SetTexture(TotemTimers.emptyTotem)
                end     
            end
            b:SetAttribute("inactive", false)            
        else
            b:SetAttribute("inactive", true)
            b:Hide()
        end
	end
end

function TotemTimers_SetAnchor_OnClick(self, button)
    if InCombatLockdown() then return end
	if button == "RightButton" then
		if #TotemTimers_Settings.TotemSets >= 8 then return end
        local set = {}
		for i=1,4 do
            local nr = XiTimers.timers[i].nr
            local spell = XiTimers.timers[i].button:GetAttribute("*spell1")
            if not spell then spell = 0 end
			set[nr] = spell
		end
        table.insert(TotemTimers_Settings.TotemSets, set)
		TotemTimers_ProgramSetButtons()
    end
end

function TotemTimers_SetButton_OnClick(self, button)
    if InCombatLockdown() then return end
    XiTimers.timers[5].button:SetAttribute("hide", true)
	if button == "RightButton" then
		local popup = StaticPopup_Show("TOTEMTIMERS_DELETESET", self.nr)
		popup.data = self.nr
    elseif button == "LeftButton" then
        local ms = TotemTimers_MultiSpell:GetAttribute("*spell1")
        local set = TotemTimers_Settings.TotemSets[self.nr]
        if set and ms then 
            for i=1,4 do
                SetMultiCastSpell(TotemTimers.MultiCastActions[i][ms], set[i])
            end
            TotemTimers.SetupTotemButtons()
        end
	end
end

local function TotemTimers_DeleteSet(self, nr)
	if not InCombatLockdown() then
		table.remove(TotemTimers_Settings.TotemSets,nr)
		TotemTimers_ProgramSetButtons()
	end
end

StaticPopupDialogs["TOTEMTIMERS_DELETESET"] = {
  text = L["Delete Set"],
  button1 = TEXT(OKAY),
  button2 = TEXT(CANCEL),
  whileDead = 1,
  hideOnEscape = 1,
  timeout = 0,
  OnAccept = TotemTimers_DeleteSet,
}