-- Copyright © 2008, 2009 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.
-- Current distribution permissions only include curse.com, wowui.worldofwar.net, wowinterface.com and their respective addon updaters

local SpellIDs = TotemTimers.SpellIDs
local SpellTextures = TotemTimers.SpellTextures
local SpellNames = TotemTimers.SpellNames
local AvailableSpells = TotemTimers.AvailableSpells
local FlameShockID = SpellIDs.FlameShock
local FlameShockName = SpellNames[SpellIDs.FlameShock]
local LightningShieldName = SpellNames[SpellIDs.LightningShield]
local FeralSpiritName = SpellNames[SpellIDs.FeralSpirit]
local UnleashFlameName = TotemTimers.BuffNames[TotemTimers.BuffIDs.UnleashFlame]

local cds = {}
--local spells = {SpellNames[SpellIDs.StormStrike], SpellNames[SpellIDs.EarthShock], SpellNames[SpellIDs.LavaLash], SpellNames[SpellIDs.FlameShock]}
local maelstrom = CreateFrame("StatusBar", "TotemTimers_MaelstromBar", UIParent, "XiTimersTimerBarTemplate, SecureActionButtonTemplate")
local maelstrombutton = CreateFrame("Button", "TotemTimers_MaelstromBarButton", TotemTimers_MaelstromBar, "ActionButtonTemplate, SecureActionButtonTemplate")
local settings = nil
local playerName = UnitName("player")
local role = 2

local num_CD_Spells = {[2]=10,[1]=11,[3]=7,}
TotemTimers.num_CD_Spells = num_CD_Spells

local function NoUpdate()
end

local ShieldName = SpellNames[SpellIDs.LightningShield]

local CD_Spells = {
    [2] = {
        [1] = SpellIDs.StormStrike,
        [2] = SpellIDs.EarthShock,
        [3] = SpellIDs.LavaLash,
        [4] = SpellIDs.FireNova,
        [5] = SpellIDs.Searing,
        [6] = SpellIDs.ShamanisticRage,
        [7] = SpellIDs.WindShear,
        [8] = SpellIDs.LightningShield,
        [9] = SpellIDs.UnleashElements,
        [10] = SpellIDs.SpiritwalkersGrace,
        [20] = SpellIDs.FeralSpirit,
        [21] = SpellIDs.FlameShock,
        [22] = SpellIDs.Maelstrom,
    },
    [1] = {
        [1] = SpellIDs.FlameShock,
        [2] = SpellIDs.LavaBurst,
        [3] = SpellIDs.ChainLightning,
        [4] = SpellIDs.Thunderstorm,
        [5] = SpellIDs.ElementalMastery,
        [6] = SpellIDs.Searing,
        [7] = SpellIDs.FireNova,
        [8] = SpellIDs.LightningShield,
        [9] = SpellIDs.WindShear,
        [10] = SpellIDs.UnleashElements,
        [11] = SpellIDs.SpiritwalkersGrace,
    },
    
    [3] = {
        [1] = SpellIDs.Riptide,
        [2] = SpellIDs.HealingRain,
        [3] = SpellIDs.WaterShield,
        [4] = SpellIDs.EarthShock,
        [5] = SpellIDs.WindShear,
        [6] = SpellIDs.UnleashElements,
        [7] = SpellIDs.SpiritwalkersGrace,
    },
}

TotemTimers.CD_Spells = CD_Spells

local function ActivateCD(self)
    XiTimers.activate(self)
end

   
local function ChangeCDOrder(self,spell)
    if InCombatLockdown() then return end
    if not spell then return end
    local _,spell1 = GetSpellBookItemInfo(spell, "BOOKTYPE_SPELL")
    local spell2 = self:GetAttribute("orderspell")    
    if not spell2 or not spell1 then return end
    local spellnum1, spellnum2 = nil,nil
    for i=1,num_CD_Spells[role] do
        if CD_Spells[role][i] == spell1 then spellnum1 = i end
        if CD_Spells[role][i] == spell2 then spellnum2 = i end        
    end
    if not spellnum1 or not spellnum2 then return end
    local order1, order2 = nil
    for i=1,#TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[role] do
        if TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[role][i] == spellnum1 then order1 = i end
        if TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[role][i] == spellnum2 then order2 = i end
    end
    if not order1 or not order2 then return end
    TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[role][order1], TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[role][order2] =
        TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[role][order2], TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[role][order1]
    TotemTimers.LayoutEnhanceCDs()
end
   
function TotemTimers.CreateEnhanceCDs()
    for i = 1,11 do
        cds[i] = XiTimers:new(1)
        cds[i].events[1] = "SPELL_UPDATE_COOLDOWN"
        cds[i].dontFlash = true
        cds[i].timeStyle = "sec"
        cds[i].button.anchorframe = TotemTimers_EnhanceCDsFrame
        cds[i].button:SetAttribute("*type*", "spell")
        --cds[i].activate = ActivateCD
        cds[i].reverseAlpha = true
        --cds[i].dontAlpha = true
        cds[i].button.icons[1]:SetAlpha(1)
        cds[i].button:SetScript("OnEvent", TotemTimers.EnhanceCDEvents)
        cds[i].button:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp")
    end
    cds[8].prohibitCooldown = true
    cds[8].reverseAlpha = nil
    cds[12] = XiTimers:new(1, true)
    cds[12].button:Disable()
    cds[12].button.icons[1]:SetVertexColor(1,1,1)
    cds[13] = XiTimers:new(1,true)
    cds[13].button:Disable()
    cds[13].button.icons[1]:SetVertexColor(1,1,1)
    cds[13].hideInactive = true
    cds[13].timeStyle = "sec"
    cds[13].button:SetScript("OnEvent", TotemTimers.FeralSpiritEvent) 
    cds[13].button.cdspell = SpellIDs.FeralSpirit
    cds[13].button.icons[1]:SetTexture(SpellTextures[SpellIDs.FeralSpirit])
    cds[13].events[1] = "UNIT_SPELLCAST_SUCCEEDED"
    cds[1].button.BorderBar:SetStatusBarColor(0.9,0.2,0.2,1)
    cds[2].button.BorderBar:SetStatusBarColor(0.9,0.2,0.2,1)
    
    maelstrom.icon = getglobal("TotemTimers_MaelstromBarIcon")
    maelstrom.background = getglobal("TotemTimers_MaelstromBarBackground")
    maelstrom.icon:SetTexture(SpellTextures[SpellIDs.Maelstrom])
    maelstrom.icon:Show()
    maelstrom.icon:SetPoint("RIGHT", maelstrom, "LEFT")
    maelstrom.background:Show()
    maelstrom.background:SetValue(1)
    maelstrom.background:SetWidth(100)
    maelstrom.background:SetStatusBarColor(1, 0, 0, 0.1)
    maelstrom:SetWidth(100)
    maelstrom:SetScript("OnEvent", TotemTimers.MaelstromEvent)
    maelstrom:SetScript("OnUpdate", TotemTimers_MaelstromBarUpdate)
    maelstrom.text = getglobal("TotemTimers_MaelstromBarTime")
    TotemTimers.maelstrom = maelstrom
    TotemTimers.maelstrombutton = maelstrombutton
    maelstrombutton:SetWidth(100)
    maelstrombutton:SetHeight(maelstrom.background:GetHeight())
    maelstrombutton:SetPoint("CENTER", maelstrom, "CENTER")
    maelstrombutton:SetNormalTexture(nil)
    maelstrombutton:SetHighlightTexture("Interface\\AddOns\\TotemTimers\\MaelstromHilight")
    maelstrombutton:SetPushedTexture("Interface\\AddOns\\TotemTimers\\MaelstromPushed")
    maelstrombutton:SetAttribute("*type*", "spell")
    maelstrombutton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    maelstrombutton:SetAttribute("*spell1", SpellNames[SpellIDs.LightningBolt])
    maelstrombutton:SetAttribute("*spell2", SpellNames[SpellIDs.ChainLightning])   

    local fs = cds[12]
    fs.button.icons[1]:SetTexture(SpellTextures[SpellIDs.FlameShock])
    fs.button.anchorframe = TotemTimers_EnhanceCDsFrame
    fs.dontAlpha = true
    fs.dontFlash = true
    fs.timeStyle = "sec"
    fs.button:SetAttribute("*type1", "spell")
    fs.button:SetAttribute("*spell1", SpellNames[SpellIDs.FlameShock])
    fs.activate = ActivateCD
    fs.button.icons[1]:SetAlpha(1)
    -- fs.reverseAlpha = true
	fs.RangeCheck = SpellNames[SpellIDs.FlameShock]
	fs.ManaCheck = SpellNames[SpellIDs.FlameShock]
    fs:SetTimerBarPos("RIGHT")
    fs.button:SetScript("OnEvent", TotemTimers.FlameShockEvent)
    fs.events[1] = "COMBAT_LOG_EVENT_UNFILTERED"
    fs.events[2] = "UNIT_AURA"
    fs.events[3] = "PLAYER_REGEN_ENABLED"
    fs.events[4] = "PLAYER_REGEN_DISABLED"
    fs.events[5] = "PLAYER_TARGET_CHANGED"
    fs:SetTimerBarPos("RIGHT")
    fs:SetTimeWidth(100)
    fs:SetBarColor(1,0.5,0)

    for i=1,11 do
        cds[i].button:SetAttribute("_ondragstart",[[if IsShiftKeyDown() and self:GetAttribute("orderspell")~=0 then
                                                    return "spell", self:GetAttribute("orderspell")
                                              else control:CallMethod("StartMove") end]])
        cds[i].button:SetAttribute("_onreceivedrag",[[ if kind == "spell" then
                                                   control:CallMethod("ChangeCDOrder", value, ...)
                                                    return "clear"
                                              end]])
        cds[i].button.ChangeCDOrder = ChangeCDOrder
    end
    
    cds[1].hasBorderTimer = true
    cds[2].hasBorderTimer = true

end

function TotemTimers.ConfigEnhanceCDs() 
    role = GetPrimaryTalentTree()
    if not role then role = 2 end
   
    
    for i=1,13 do
        cds[i]:deactivate()
    end
    
    maelstrom:UnregisterEvent("UNIT_AURA")
    maelstrom:UnregisterEvent("PLAYER_REGEN_ENABLED")
    maelstrom:UnregisterEvent("PLAYER_REGEN_DISABLED")
    maelstrom:Hide()
    
    if not TotemTimers.ActiveSpecSettings.EnhanceCDs then return end

    if TotemTimers.AvailableSpells[SpellIDs.StormStrike] then --if Stormstrike not available yet show Primal Strike
        CD_Spells[2][1] = SpellIDs.StormStrike
    else
        CD_Spells[2][1] = SpellIDs.PrimalStrike
    end
    
    for i=1,num_CD_Spells[role] do
        cds[i].button.cdspell = CD_Spells[role][i]
        cds[i].button.icons[1]:SetTexture(SpellTextures[CD_Spells[role][i]])
        cds[i].button:SetAttribute("*spell1", SpellNames[CD_Spells[role][i]])
        cds[i].RangeCheck = SpellNames[CD_Spells[role][i]]
        cds[i].ManaCheck = SpellNames[CD_Spells[role][i]]
        cds[i].button:SetScript("OnEvent", TotemTimers.EnhanceCDEvents)
        cds[i].update = nil
        cds[i].prohibitCooldown = false
        cds[i].button:SetAttribute("orderspell", CD_Spells[role][i])
        cds[i].events = {"SPELL_UPDATE_COOLDOWN"}
    end
    
    if role == 2 then
        local es = cds[2]
        es.button.icons[1]:SetTexture(SpellTextures[SpellIDs.EarthShock])
        es.button:SetAttribute("*spell1", SpellNames[SpellIDs.EarthShock])
        es.button:SetAttribute("*spell3", SpellNames[SpellIDs.FrostShock])
        es.button:SetAttribute("*spell2", SpellNames[SpellIDs.FlameShock])
        es.events[2] = "UNIT_AURA"
        es.button:SetScript("OnEvent", TotemTimers.UnleashFlameEvent)
    
        --Searing Totem Dur.
        cds[5].button:SetScript("OnEvent", TotemTimers.SearingTotemEvent)
        cds[5].events[2] = "PLAYER_TOTEM_UPDATE"  
        cds[8].update = NoUpdate
        cds[8].events[2] = "UNIT_AURA"
        cds[8].button:SetScript("OnEvent", TotemTimers.ShieldChargeEvent)
        cds[8].prohibitCooldown = true
        ShieldName = SpellNames[SpellIDs.LightningShield]        
        
    end
    
    if role == 1 then
    
        cds[1].events[2] = "UNIT_AURA"
        cds[1].button:SetScript("OnEvent", TotemTimers.UnleashFlameEvent)
    
        cds[5].update = TotemTimers.ElementalMasteryUpdate
        
        --Searing Totem Dur.
        cds[6].button:SetScript("OnEvent", TotemTimers.SearingTotemEvent)
        cds[6].events[4] = "PLAYER_TOTEM_UPDATE"
        
        cds[8].update = NoUpdate
        cds[8].button:SetScript("OnEvent", TotemTimers.ShieldChargeEvent)
        cds[8].events[2] = "UNIT_AURA"
        cds[8].prohibitCooldown = true
        ShieldName = SpellNames[SpellIDs.LightningShield]
    end
    
    if role == 3 then
        cds[3].button:SetScript("OnEvent", TotemTimers.ShieldChargeEvent)
        cds[3].events[2] = "UNIT_AURA"
        cds[3].update = NoUpdate
        cds[3].prohibitCooldown = true
        ShieldName = SpellNames[SpellIDs.WaterShield]
    end
    
    if role == 2 and TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][22] and TotemTimers.AvailableTalents.Maelstrom then
        maelstrom:RegisterEvent("UNIT_AURA")
        maelstrom:RegisterEvent("PLAYER_REGEN_ENABLED")
        maelstrom:RegisterEvent("PLAYER_REGEN_DISABLED")
        maelstrom:Show()
        if not InCombatLockdown() and TotemTimers.ActiveSpecSettings.HideEnhanceCDsOOC then 
            maelstrom:Hide()
        end
    end
    
    
    if AvailableSpells[SpellIDs.FlameShock]
        and ((role == 2 and TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[2][21])
          or (role == 1 and TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[1][20])
          or (role == 3 and TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[3][20]))
    then
        cds[12]:activate()
    end
    
    for i=1,num_CD_Spells[role] do
        if TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[role][i] and AvailableSpells[CD_Spells[role][TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[role][i]]] then
            cds[i]:activate()
        end
    end
    if role == 2 then
        if TotemTimers.ActiveSpecSettings.EnhanceCDs_Spells[role][20] and AvailableSpells[SpellIDs.FeralSpirit] then
            cds[13]:activate()
        end
    end
end

local active_cds = {}

local function ConvertCoords(frame1, frame2)
    return frame1:GetEffectiveScale()/frame2:GetEffectiveScale()
end


function TotemTimers.LayoutEnhanceCDs()
    wipe(active_cds)
    for i=1,num_CD_Spells[role] do
        if cds[TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[role][i]].active then
            table.insert(active_cds,cds[TotemTimers.ActiveSpecSettings.EnhanceCDs_Order[role][i]])
        end
    end
    for i=1,13 do 
        cds[i]:ClearAnchors()
        cds[i].button:ClearAllPoints()
    end
    maelstrom:ClearAllPoints()
    local xmove, xmovebottom = 0, 0
    local fsreltop = nil
    local fsrelbottom = nil
    if #active_cds == 0 then
        if cds[9].active then
            cds[9].button:SetPoint("TOPRIGHT", TotemTimers_EnhanceCDsFrame)
        else
            cds[9].button:SetPoint("BOTTOMRIGHT", TotemTimers_EnhanceCDsFrame)
        end
        if cds[10].active then
            cds[10].button:SetPoint("BOTTOM", TotemTimers_EnhanceCDsFrame)
        end
    elseif #active_cds == 1 then
        active_cds[1].button:SetPoint("CENTER", TotemTimers_EnhanceCDsFrame)
        fsreltop = active_cds[1].button
        fsrelbottom = active_cds[1].button
        xmovetop = -(TotemTimers.ActiveSpecSettings.EnhanceCDsSize*3.5+5)
        xmovebottom = -(TotemTimers.ActiveSpecSettings.EnhanceCDsSize*3.5+5)
    elseif #active_cds == 2 then
        active_cds[1].button:SetPoint("RIGHT", TotemTimers_EnhanceCDsFrame, "CENTER", -3, 0)
        active_cds[2]:Anchor(active_cds[1], "LEFT")
        fsreltop = active_cds[1].button
        fsrelbottom = active_cds[1].button
        xmovetop = -(TotemTimers.ActiveSpecSettings.EnhanceCDsSize*2.5+5)
        xmovebottom = -(TotemTimers.ActiveSpecSettings.EnhanceCDsSize*2.5+5)
    elseif #active_cds == 3 then
        active_cds[2].button:SetPoint("CENTER", TotemTimers_EnhanceCDsFrame)
        active_cds[1]:Anchor(active_cds[2], "RIGHT")
        active_cds[3]:Anchor(active_cds[2], "LEFT")
        fsreltop = active_cds[1].button
        fsrelbottom = active_cds[1].button
        xmovebottom = 0
        xmovetop = 0
    elseif #active_cds == 4 then 
        active_cds[2].button:SetPoint("RIGHT", TotemTimers_EnhanceCDsFrame, -3, 0)
        active_cds[1]:Anchor(active_cds[2], "RIGHT")
        active_cds[3]:Anchor(active_cds[2], "LEFT")
        active_cds[4]:Anchor(active_cds[3], "LEFT")
        xmovebottom = (TotemTimers.ActiveSpecSettings.EnhanceCDsSize*0.5+5)
        xmovetop = 0
        fsreltop = cds[1].button
        fsrelbottom = cds[1].button
    elseif #active_cds == 5 then
        active_cds[1].button:SetPoint("RIGHT", TotemTimers_EnhanceCDsFrame, "CENTER", -3, 0)
        active_cds[2]:Anchor(active_cds[1], "LEFT")
        active_cds[3]:Anchor(active_cds[1], "TOPRIGHT", "BOTTOM", true)
        active_cds[4]:Anchor(active_cds[3], "LEFT")
        active_cds[5]:Anchor(active_cds[4], "LEFT")
        fsreltop = cds[1].button
        fsrelbottom = cds[3].button
        xmovebottom = 0
        xmovetop = 0
    elseif #active_cds == 6 then
        active_cds[2].button:SetPoint("CENTER", TotemTimers_EnhanceCDsFrame)
        active_cds[1]:Anchor(active_cds[2], "RIGHT")
        active_cds[3]:Anchor(active_cds[2], "LEFT")
        active_cds[5]:Anchor(active_cds[2], "TOP", "BOTTOM")
        active_cds[4]:Anchor(active_cds[5],"RIGHT")
        active_cds[6]:Anchor(active_cds[5],"LEFT")
        fsreltop = cds[1].button
        fsrelbottom = cds[3].button
        xmovebottom = 0
        xmovetop = 0
    elseif #active_cds == 7 then
        active_cds[2].button:SetPoint("CENTER", TotemTimers_EnhanceCDsFrame)
        active_cds[1]:Anchor(active_cds[2], "RIGHT")
        active_cds[3]:Anchor(active_cds[2], "LEFT")
        active_cds[5]:Anchor(active_cds[2], "TOPRIGHT", "BOTTOM", true)
        active_cds[4]:Anchor(active_cds[5], "RIGHT")
        active_cds[6]:Anchor(active_cds[5], "LEFT")
        active_cds[7]:Anchor(active_cds[6], "LEFT")
        fsreltop = cds[1].button
        fsrelbottom = cds[3].button
        xmovebottom = 0
        xmovetop = 0
    elseif #active_cds == 8 then
        active_cds[2].button:SetPoint("RIGHT", TotemTimers_EnhanceCDsFrame, -3, 0)
        active_cds[1]:Anchor(active_cds[2], "RIGHT")
        active_cds[3]:Anchor(active_cds[2], "LEFT")
        active_cds[4]:Anchor(active_cds[3], "LEFT")
        active_cds[5]:Anchor(active_cds[1], "TOP", "BOTTOM")
        active_cds[6]:Anchor(active_cds[2], "TOP", "BOTTOM")
        active_cds[7]:Anchor(active_cds[3], "TOP", "BOTTOM")
        active_cds[8]:Anchor(active_cds[4], "TOP", "BOTTOM")
        fsreltop = cds[1].button
        fsrelbottom = cds[3].button
        xmovebottom = 0
        xmovetop = 0
    elseif #active_cds == 9 then
        active_cds[2].button:SetPoint("RIGHT", TotemTimers_EnhanceCDsFrame, -3, 0)
        active_cds[1]:Anchor(active_cds[2], "RIGHT")
        active_cds[3]:Anchor(active_cds[2], "LEFT")
        active_cds[4]:Anchor(active_cds[3], "LEFT")
        active_cds[6]:Anchor(active_cds[2], "TOPRIGHT", "BOTTOM", true)
        active_cds[5]:Anchor(active_cds[6], "RIGHT")
        active_cds[7]:Anchor(active_cds[6], "LEFT")
        active_cds[8]:Anchor(active_cds[7], "LEFT")
        active_cds[9]:Anchor(active_cds[8], "LEFT")
        fsreltop = cds[1].button
        fsrelbottom = cds[3].button
        xmovebottom = 0
        xmovetop = 0
    elseif #active_cds == 10 then
        active_cds[3].button:SetPoint("CENTER", TotemTimers_EnhanceCDsFrame)
        active_cds[2]:Anchor(active_cds[3], "RIGHT")
        active_cds[1]:Anchor(active_cds[2], "RIGHT")
        active_cds[4]:Anchor(active_cds[3], "LEFT")
        active_cds[5]:Anchor(active_cds[4], "LEFT")
        active_cds[6]:Anchor(active_cds[1], "TOP", "BOTTOM")
        active_cds[7]:Anchor(active_cds[2], "TOP", "BOTTOM")
        active_cds[8]:Anchor(active_cds[3], "TOP", "BOTTOM")
        active_cds[9]:Anchor(active_cds[4], "TOP", "BOTTOM")
        active_cds[10]:Anchor(active_cds[5], "TOP", "BOTTOM")
        fsreltop = cds[1].button
        fsrelbottom = cds[3].button
        xmovebottom = 0
        xmovetop = 0
    elseif #active_cds == 11 then
        active_cds[3].button:SetPoint("CENTER", TotemTimers_EnhanceCDsFrame)
        active_cds[2]:Anchor(active_cds[3], "RIGHT")
        active_cds[1]:Anchor(active_cds[2], "RIGHT")
        active_cds[4]:Anchor(active_cds[3], "LEFT")
        active_cds[5]:Anchor(active_cds[4], "LEFT")
        active_cds[6]:Anchor(active_cds[1], "TOPRIGHT", "BOTTOM", true)
        active_cds[7]:Anchor(active_cds[6], "LEFT")
        active_cds[8]:Anchor(active_cds[7], "LEFT")
        active_cds[9]:Anchor(active_cds[8], "LEFT")
        active_cds[10]:Anchor(active_cds[9], "LEFT")
        active_cds[11]:Anchor(active_cds[10], "LEFT")
        fsreltop = cds[1].button
        fsrelbottom = cds[3].button
        xmovebottom = 0
        xmovetop = 0
    end
    local vertdist = not (TotemTimers.ActiveSpecSettings.FlameShockDurationOnTop or TotemTimers_Settings.TimersOnButtons or
            TotemTimers.ActiveSpecSettings.CDTimersOnButtons) and TotemTimers.ActiveSpecSettings.EnhanceCDsTimeHeight or 0
    if #active_cds > 4 then vertdist = vertdist*2 end
    vertdist = vertdist*ConvertCoords(cds[9].timerbars[1], cds[12].button)
    vertdist = vertdist+0.5*cds[9].button:GetHeight()*ConvertCoords(cds[9].button,cds[12].button)
    if #active_cds > 4 and not TotemTimers.ActiveSpecSettings.FlameShockDurationOnTop then vertdist = vertdist+(5+cds[9].button:GetHeight())*ConvertCoords(cds[9].button,cds[12].button) end
    vertdist = vertdist+5*ConvertCoords(cds[9].button, cds[12].button)
    if not TotemTimers.ActiveSpecSettings.FlameShockDurationOnTop then vertdist = -vertdist end
    
    if not TotemTimers.ActiveSpecSettings.FlameShockDurationOnTop then 
        cds[12].button:SetPoint("TOPRIGHT", TotemTimers_EnhanceCDsFrame, "CENTER", -(TotemTimers.ActiveSpecSettings.EnhanceCDsSize*3.5+5), vertdist)
    else
        cds[12].button:SetPoint("BOTTOMRIGHT", TotemTimers_EnhanceCDsFrame, "CENTER", -(TotemTimers.ActiveSpecSettings.EnhanceCDsSize*3.5+5), vertdist)
    end
    
    
    vertdist = 0
    if cds[12].active then
        vertdist = vertdist+(cds[12].button:GetHeight()+5)*ConvertCoords(cds[12].button, maelstrom)
    end
    if not TotemTimers.ActiveSpecSettings.FlameShockDurationOnTop then
        maelstrom:SetPoint("TOPLEFT", cds[12].button, "TOPRIGHT", 0, -vertdist)
    else
        maelstrom:SetPoint("BOTTOMLEFT", cds[12].button, "BOTTOMRIGHT", 0, vertdist)
    end
    if active_cds[1] then cds[13]:Anchor(active_cds[1], "RIGHT") end
    --maelstrom:SetPoint("TOPLEFT", cds[12].button, "BOTTOMRIGHT", 0, -5)
end

function TotemTimers_ActivateEnhanceCDs()
    TotemTimers.ConfigEnhanceCDs()
    TotemTimers.LayoutEnhanceCDs()
end

function TotemTimers_DeactivateEnhanceCDs()
    for k,v in pairs(cds) do
        v:deactivate()
    end
    maelstrom:UnregisterEvent("UNIT_AURA")
    maelstrom:UnregisterEvent("PLAYER_REGEN_ENABLED")
    maelstrom:UnregisterEvent("PLAYER_REGEN_DISABLED")
    maelstrom:Hide()
end

function TotemTimers.EnhanceCDEvents(self, event, ...)
    local settings = TotemTimers.ActiveSpecSettings
    if event == "SPELL_UPDATE_COOLDOWN" and AvailableSpells[self.cdspell] then 
        local start, duration, enable = GetSpellCooldown(self.cdspell)
        if (not start and not duration) or (duration <= 1.5 and not InCombatLockdown()) then
            self.timer:stop(1)					
        else
            if duration == 0 then
                self.timer:stop(1)
            elseif duration > 2 and self.timer.timers[1]<=0 then
                self.timer:start(1,start+duration-floor(GetTime()),duration)
            end
            CooldownFrame_SetTimer(self.cooldown, start, duration, enable)
        end 
    end
end


function TotemTimers.SearingTotemEvent(self,event,...)
    local element = ...
    if event == "PLAYER_TOTEM_UPDATE" then
        if element == 1 then
            local _, totem, startTime, duration, icon = GetTotemInfo(1)
            if icon == SpellTextures[SpellIDs.Searing] and duration > 0 then
                self.timer:start(1, duration)
            elseif self.timer.timers[1] > 0 then 
                self.timer:stop(1)
            end
        end
    elseif event ~= "SPELL_UPDATE_COOLDOWN" then
        TotemTimers.EnhanceCDEvents(self,event,...)
    end
end


function TotemTimers.ElementalMasteryUpdate(self,elapsed)
    XiTimers.update(self,elapsed)
    if self.timers[1] > 0 then
        local start, duration, enable = GetSpellCooldown(self.button.cdspell)
        if (not start and not duration) then
            self:stop(1)					
        else
            if duration == 0 then
                self:stop(1)
            elseif (start+duration-floor(GetTime())) < self.timers[1]-1 then
                self.timers[1] = start+duration-floor(GetTime())
            end
        end
    end        
end


function TotemTimers.ShieldChargeEvent(self, event, ...)
	if event == "UNIT_AURA" and select(1,...) =="player" then
		local name,_,texture,count,_,duration,endtime = UnitAura("player", ShieldName)

		if name then
			self.timer:start(1, count, 9)
            --self.timer.expirationMsgs[1] = TotemTimers_Settings.ShieldMsg and string.format(L["Shield removed"], name) or nil
			--self.timer.earlyExpirationMsgs[1] = TotemTimers_Settings.ShieldMsg and string.format(L["Shield removed"], name) or nil
		elseif self.timer.timers[1]>0 then
			self.timer:stop(1)
		end
	elseif event ~= "SPELL_UPDATE_COOLDOWN" then
        TotemTimers.EnhanceCDEvents(self,event,...)
    end
end



local AuraGUID = nil
local FSEv, FSSource, FSTarget, FSSpell, FSBuffType, FSDuration, FSExpires, FSID = nil

local function CheckFSBuff(self, unit)
    if --[[(unit == "target" or unit == "focus") and]] UnitGUID(unit) == AuraGUID then
        _,_,_,_,_,FSDuration,FSExpires,FSSource,_,_,FSID = UnitDebuff(unit, FlameShockName)
        if FSID == FlameShockID and FSDuration and FSSource == "player" then 
            self.timer:start(1, -1 * GetTime() + FSExpires, FSDuration)
        elseif not FSID then
            self.timer:stop(1)
        end
    end
end

function TotemTimers.FlameShockEvent(self,event,...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        _, FSEv, _, _, FSSource, _, _, FSTarget, _, _, _, FSSpell = ...
        if FSEv == "SPELL_DAMAGE" then
            if FSSource == playerName and FSSpell == FlameShockID then 
                AuraGUID = FSTarget
                TotemTimers.FlameShockEvent(self, "UNIT_AURA", "target")
            end
        elseif FSEv == "UNIT_DIED" then
            if AuraGUID and FSTarget == AuraGUID then
                self.timer:stop(1)
                AuraGUID = nil
            end
        end
    elseif event == "PLAYER_TARGET_CHANGED" and UnitExists("target") then
        AuraGUID = UnitGUID("target")
        CheckFSBuff(self, "target")
    elseif event == "UNIT_AURA" then
        local unit = ...
        CheckFSBuff(self, unit)
    end
end


function TotemTimers.FeralSpiritEvent(self,event,unit, spell)
    if event == "UNIT_SPELLCAST_SUCCEEDED" and unit == "player" and spell == FeralSpiritName then
        self.timer:start(1,30)
    end
end


local maelstromname = SpellNames[SpellIDs.Maelstrom]

function TotemTimers.MaelstromEvent(self, event, unit) 
    if event == "UNIT_AURA" and unit == "player"  then
        local name,_,_,count,_,duration,endtime = UnitBuff("player", maelstromname)
        self:SetValue(count or 0)
        self.text:SetText(tostring(count or ""))
        self.count = count
        if count then
            self:SetStatusBarColor(5-count, -0.33+count*0.33, 0, 1.0)
            self.background:SetStatusBarColor(1-count*0.2, count*0.2, 0, 0.1)
        else
            self:SetStatusBarColor(1, 0, 0, 1.0)
            self.background:SetStatusBarColor(1, 0, 0, 0.1)
        end
	elseif event == "PLAYER_REGEN_ENABLED" then
        if TotemTimers.ActiveSpecSettings.HideEnhanceCDsOOC then
            self:Hide()
        end
        self:SetAlpha(TotemTimers.ActiveSpecSettings.EnhanceCDsOOCAlpha)
    elseif event == "PLAYER_REGEN_DISABLED" then
        if not self:IsVisible() then
            self:Show()
        end
       self:SetAlpha(1)
    end
end

function TotemTimers_MaelstromBarUpdate(self, ...)
    if self.count == 5 then
        self:SetStatusBarColor(1-BuffFrame.BuffAlphaValue, BuffFrame.BuffAlphaValue, 0, 1)
    end
end


function TotemTimers.UnleashFlameEvent(self, event, unit, ...)
    if event == "UNIT_AURA" and unit == "player" then
        local name,_,_,_,_,duration,endtime = UnitAura("player", UnleashFlameName)
		if name then
            local timeleft = endtime - GetTime()
			self.timer:startborder(timeleft, duration)
		elseif self.timer.bordertimer>0 then
			self.timer:stopborder(1) 
        end
    else
        TotemTimers.EnhanceCDEvents(self, event, unit, ...)
    end
end