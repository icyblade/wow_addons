-- Copyright © 2008, 2009 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.
-- Current distribution permissions only include curse.com, wowui.worldofwar.net, wowinterface.com and their respective addon updaters

local SpellIDs = TotemTimers.SpellIDs
local SpellTextures = TotemTimers.SpellTextures
local SpellNames = TotemTimers.SpellNames
local NameToSpellID = TotemTimers.NameToSpellID
local AvailableSpells = TotemTimers.AvailableSpells
local AvailableTalents = TotemTimers.AvailableTalents
local LightningShieldName = SpellNames[SpellIDs.LightningShield]
local LavaBurstName = SpellNames[SpellIDs.LavaBurst]
local TotemTimers = TotemTimers
local EarthShockID = SpellIDs.EarthShock
local VolcanoID = TotemTimers.BuffIDs.Volcano



local AuraSpells = {SpellIDs.LavaBurst}--, SpellIDs.EarthShock}
local AuraActionButtons = {}

for k,v in pairs(AuraSpells) do
    AuraActionButtons[k] = {}
end

local function TestButtonForAura(self)
    if not self then return end
    local actiontype, id
    if not self.action or self.action == 0 then
        actiontype = self:GetAttribute("type")
        if actiontype == "action" then
            id = self:GetAttribute("action")
            if id then
                actiontype, id = GetActionInfo(id)
            else
                return
            end
        elseif actiontype == "spell" then
            id = self:GetAttribute("spell")
            if id then
                if type(id) ~= number then
                    if not NameToSpellID[id] then
                        return
                    else
                        id = NameToSpellID[id]
                    end
                end
            else
                return 
            end
        elseif actiontype == "macro" then
            id = self:GetAttribute("macro")
        else
            return
        end
    else
        actiontype, id = GetActionInfo(self.action)
    end
    
    for k,v in pairs(AuraSpells) do
        if actiontype == "spell" then
            if id == v then
                table.insert(AuraActionButtons[k],self)                    
            end
        elseif actiontype == "macro" then
            local macrotext = GetMacroBody(id)
            if macrotext and string.find(macrotext, SpellNames[v]) then
                table.insert(AuraActionButtons[k],self)
            end
        end
    end
end


local AuraFrame = CreateFrame("Frame", "TotemTimers_AuraFrame")
--AuraFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
AuraFrame:RegisterEvent("ACTIONBAR_HIDEGRID")
AuraFrame:RegisterEvent("ACTIONBAR_SHOWGRID")


local BlizzButtonNames = {"ActionButton", "MultiBarLeftButton", "MultiBarRightButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton"}

local LavaBurstTimer = XiTimers.timers[10]
local ShockTimer = XiTimers.timers[9]
local LavaSurgeAura = false
local LavaSurgeGlow = false
local FulminationAura = false
local FulminationGlow = false

local playerName = UnitName("player")
local LavaSurgeID = SpellIDs.LavaSurge
local LavaBurstID = SpellIDs.LavaBurst
local LavaSurgeDuration = 0
local LavaSurgeShowing = false
local LavaBurstEndCD = 0


local LavaBurstSA = { -- Data for SpellActivation frame
		id = SpellIDs.LavaSurge,
		texture = "TEXTURES\\SPELLACTIVATIONOVERLAYS\\IMP_EMPOWERMENT.BLP",
		positions = "Left + Right (Flipped)",
		scale = 1.5,
		r = 255, g = 185, b = 185,
	}
    
local FulminationSA = {
		id = SpellIDs.EarthShock,
		texture = "TEXTURES\\SPELLACTIVATIONOVERLAYS\\MAELSTROM_WEAPON.BLP",
		positions = "Top",
		scale = 1,
		r = 180, g = 255, b = 50,
	}
    

local LastCharges = 0
    
function TotemTimers.AuraFrameOnEvent(self,event,...)
    if event == "ACTIONBAR_HIDEGRID" or event == "ACTIONBAR_SHOWGRID" then
        self:RegisterEvent("ACTIONBAR_SLOT_CHANGED") 
    elseif event == "ACTIONBAR_SLOT_CHANGED" then
        self:UnregisterEvent("ACTIONBAR_SLOT_CHANGED")
        for k,v in pairs(AuraActionButtons) do wipe(v) end
        if Bartender4 then
            local i = 1
            local b = _G["BT4Button1"]
            repeat
                TestButtonForAura(b)
                i = i + 1
                b = _G["BT4Button"..i]
            until b == nil
        else
            for k,v in pairs(BlizzButtonNames) do
                for i = 1,12 do
                    TestButtonForAura(_G[v..i])                    
                end
            end
            if Dominos then
                local b
                for i = -12,100 do
                    TestButtonForAura(_G["DominosActionButton"..i])                    
                end
            end
        end 
    elseif event == "SPELL_UPDATE_COOLDOWN" then
        local start, duration, enable = GetSpellCooldown(LavaBurstID)
        LavaBurstEndCD = start+duration  
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _,eventtype,_,_,name,_,_,_,_,_,_,spellid = ...         
        if name == playerName then 
            if eventtype == "SPELL_CAST_SUCCESS" then 
                if spellid == LavaSurgeID then
                    LavaSurgeDuration = LavaBurstEndCD-GetTime()
                    LavaBurstTimer:stop(1)
                    if LavaSurgeAura or LavaSurgeGlow then
                        LavaSurgeShowing = true
                        if LavaSurgeGlow then
                            ActionButton_ShowOverlayGlow(LavaBurstTimer.button)
                            for k,v in pairs(AuraActionButtons[1]) do
                                ActionButton_ShowOverlayGlow(v)
                            end
                        end
                        if LavaSurgeAura then                
                            SpellActivationOverlay_ShowAllOverlays(SpellActivationOverlayFrame, LavaBurstSA.id, LavaBurstSA.texture, LavaBurstSA.positions, LavaBurstSA.scale,
                                LavaBurstSA.r, LavaBurstSA.g, LavaBurstSA.b)
                        end
                        AuraFrame:Show()
                    end
                end
            elseif (eventtype == "SPELL_CAST_START" and spellid == LavaBurstID) or (eventtype == "SPELL_AURA_REMOVED" and spellid == VolcanoID) then
                LavaSurgeShowing = false
                SpellActivationOverlay_HideOverlays(SpellActivationOverlayFrame, LavaBurstSA.id)
                ActionButton_HideOverlayGlow(LavaBurstTimer.button)
                for k,v in pairs(AuraActionButtons[1]) do
                    ActionButton_HideOverlayGlow(v)
                end
            end
        end
    --[[elseif event == "UNIT_AURA" and select(1,...) == "player" then
        local _,_,_,count = UnitBuff("player", LightningShieldName)
        if count then
            if count == 9 and LastCharges < 9 then
                if FulminationAura then
                    SpellActivationOverlay_ShowAllOverlays(SpellActivationOverlayFrame, FulminationSA.id, FulminationSA.texture, FulminationSA.positions, FulminationSA.scale,
                        FulminationSA.r, FulminationSA.g, FulminationSA.b)
                 end
                 if FulminationGlow then
                    ActionButton_ShowOverlayGlow(ShockTimer.button)
                    for k,v in pairs(AuraActionButtons[2]) do
                        ActionButton_ShowOverlayGlow(v)
                    end
                 end
                 LastCharges = 9
            elseif count < 9 and LastCharges == 9 then
                SpellActivationOverlay_HideOverlays(SpellActivationOverlayFrame, FulminationSA.id)
                ActionButton_HideOverlayGlow(ShockTimer.button)
                for k,v in pairs(AuraActionButtons[2]) do
                    ActionButton_HideOverlayGlow(v)
                end
                LastCharges = count
            else            
                LastCharges = count
            end
        else
            if LastCharges == 9 then
                SpellActivationOverlay_HideOverlays(SpellActivationOverlayFrame, FulminationSA.id)
                ActionButton_HideOverlayGlow(ShockTimer.button)
                for k,v in pairs(AuraActionButtons[2]) do
                    ActionButton_HideOverlayGlow(v)
                end
            end
            LastCharges = 0
        end]]
    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
        if select(1,...) == EarthShockID then
            ActionButton_ShowOverlayGlow(ShockTimer.button)
        end    
    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
        if select(1,...) == EarthShockID then
            ActionButton_HideOverlayGlow(ShockTimer.button)
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        --SpellActivationOverlay_HideOverlays(SpellActivationOverlayFrame, FulminationSA.id)
        SpellActivationOverlay_HideOverlays(SpellActivationOverlayFrame, LavaBurstSA.id)
        --ActionButton_HideOverlayGlow(ShockTimer.button)
        ActionButton_HideOverlayGlow(LavaBurstTimer.button)
        for i=1,#AuraActionButtons do
            for j=1,#AuraActionButtons[i] do
                ActionButton_HideOverlayGlow(AuraActionButtons[i][j])
            end
        end
        AuraFrame:Hide()
    end
end

function TotemTimers.AuraFrameOnUpdate(self,elapsed)
    if LavaSurgeShowing then
        LavaSurgeDuration = LavaSurgeDuration - elapsed
        if LavaSurgeDuration <= 0 then
            LavaSurgeShowing = false
            ActionButton_HideOverlayGlow(LavaBurstTimer.button)
            SpellActivationOverlay_HideOverlays(SpellActivationOverlayFrame, LavaBurstSA.id)
            for k,v in pairs(AuraActionButtons[1]) do
                ActionButton_HideOverlayGlow(v)
            end
            self:Hide()
        end
    end
end

AuraFrame:SetScript("OnEvent", TotemTimers.AuraFrameOnEvent)
AuraFrame:Hide()
AuraFrame:SetScript("OnUpdate", TotemTimers.AuraFrameOnUpdate)

function TotemTimers.ConfigAuras()
    LavaBurstTimer = XiTimers.timers[10]
    ShockTimer = XiTimers.timers[9]
    AuraFrame:UnregisterAllEvents()
    AuraFrame:RegisterEvent("ACTIONBAR_HIDEGRID")
    AuraFrame:RegisterEvent("ACTIONBAR_SHOWGRID")
    AuraFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    if (AvailableSpells[SpellIDs.LavaBurst] and AvailableTalents.LavaSurge) and (LavaBurstTimer.active or TotemTimers.ActiveSpecSettings.LavaSurgeAura or TotemTimers.ActiveSpecSettings.LavaSurgeGlow) then
        AuraFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        AuraFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
        LavaSurgeAura = TotemTimers.ActiveSpecSettings.LavaSurgeAura
        LavaSurgeGlow = TotemTimers.ActiveSpecSettings.LavaSurgeGlow
    end
    if (AvailableSpells[SpellIDs.EarthShock] and AvailableTalents.Fulmination) then --and (TotemTimers.ActiveSpecSettings.FulminationAura or TotemTimers.ActiveSpecSettings.FulminationGlow) then
        --AuraFrame:RegisterEvent("UNIT_AURA")
        AuraFrame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
		AuraFrame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
        --FulminationAura = TotemTimers.ActiveSpecSettings.FulminationAura
        --FulminationGlow = TotemTimers.ActiveSpecSettings.FulminationGlow
    end
end
