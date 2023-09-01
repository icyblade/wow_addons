-- Copyright © 2008, 2009 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.
-- Current distribution permissions only include curse.com, wowui.worldofwar.net, wowinterface.com and their respective addon updaters

local TRACKER_START = 5
local TRACKER_END = 8
local Timers = XiTimers.timers

local SpellIDs = TotemTimers.SpellIDs
local SpellNames = TotemTimers.SpellNames
local AvailableSpells = TotemTimers.AvailableSpells

local TotemFrameScript = TotemFrame:GetScript("OnShow")

local LSM = LibStub:GetLibrary("LibSharedMedia-3.0", true)

local MultiCastBarParent = CreateFrame("Frame")
--local OldMultiCastBarParent = nil


local function SetMultiCastParent(self)
    --if self:GetParent() ~= MultiCastBarParent then
    --    OldMultiCastBarParent = self:GetParent()
        self:SetParent(MultiCastBarParent)
    --end
end



local TotemColors = {
    [AIR_TOTEM_SLOT] = {0.7,0.7,1.0},
    [WATER_TOTEM_SLOT] = {0.4,0.4,1.0},
    [FIRE_TOTEM_SLOT] = {1.0,0.1,0.1},
    [EARTH_TOTEM_SLOT] = {0.7,0.5,0.3},
}


function TotemTimers.ProcessSetting(setting)
    if SettingsFunctions[setting] then
        SettingsFunctions[setting](TotemTimers_Settings[setting], XiTimers.timers)
    end
end

function TotemTimers.ProcessSpecSetting(setting)
    if SettingsFunctions[setting] then
        SettingsFunctions[setting](TotemTimers.ActiveSpecSettings[setting], XiTimers.timers)
    end
end

function TotemTimers.ProcessAllSpecSettings()
    for k,v in pairs(TotemTimers.ActiveSpecSettings) do
        TotemTimers.ProcessSpecSetting(k)
    end
end

local OldMultiCastOnShow

SettingsFunctions = {
    ShowTimerBars = 
        function(value, Timers) 
            for _,timer in pairs(Timers) do
                timer.visibleTimerBars = value
                for n,t in pairs(timer.timers) do
                    if t>0 and value then
                        timer:ShowTimerBar(n)
                    else
                        timer.timerbars[n].background:Hide()
                        timer.timerbars[n]:SetValue(0)
                    end					
                end
            end
            Timers[20].visibleTimerBars = true
            if Timers[20].timers[1]>0 then
                Timers[20]:ShowTimerBar(n)
            end
        end,

    FlashRed = 
        function(value, Timers)
        	for _,timer in pairs(Timers) do
                timer.FlashRed = value
            end
        end,
        
    TimerSize = 
        function(value, Timers)
            local v = value
            if TotemTimers_MultiSpell.active then v = v / (TotemTimers_Settings.MultiSpellSize/36) end
    		for e=1,4 do
    			Timers[e]:SetScale(v/36)
    		end
        end,
        
    CastButtonSize = 
        function(value, Timers)
            for i = 1,4 do
                Timers[i].Cast1:SetScale(value)
                Timers[i].Cast2:SetScale(value)
            end    		
        end,
        
    TrackerSize = 
        function(value, Timers)
    		for e=TRACKER_START, TRACKER_END do
    			Timers[e]:SetScale(value/36)
    		end
        end,

    TimerTimeHeight =
        function(value, Timers)
    		for e=1,4 do
    			Timers[e]:SetTimeHeight(value)
                Timers[e].button.time:SetFont(Timers[e].button.time:GetFont(),value+5,"OUTLINE")
    		end        
        end,
        
    TrackerTimeHeight =
        function(value, Timers)
    		for e=TRACKER_START, TRACKER_END do
    			Timers[e]:SetTimeHeight(value)
                Timers[e].button.time:SetFont(Timers[e].button.time:GetFont(),value+5,"OUTLINE")
    		end
    		for e=22, 23 do
    			Timers[e]:SetTimeHeight(value)
                Timers[e].button.time:SetFont(Timers[e].button.time:GetFont(),value+5,"OUTLINE")
    		end
        end,
        
    TimerSpacing = 
        function(value, Timers)
    		for e=1,4 do
    			Timers[e]:SetSpacing(value)
    		end
        end,
        
    TrackerSpacing =
        function(value, Timers)
    		for e=TRACKER_START, TRACKER_END do
    			Timers[e]:SetSpacing(value)
    		end
    		for e=22, 23 do
    			Timers[e]:SetSpacing(value)
    		end
    end,
        
    TimerTimeSpacing = 
        function(value, Timers)
    		for e=1,4 do
    			Timers[e]:SetTimeSpacing(value)
    		end
        end,
        
    TrackerTimeSpacing =
        function(value, Timers)
    		for e=TRACKER_START, TRACKER_END do
    			Timers[e]:SetTimeSpacing(value)
    		end
            for e=22, 23 do
    			Timers[e]:SetTimeSpacing(value)
    		end
        end,
        
    TimerTimePos = 
        function(value, Timers)
    		for e=1,4 do
    			Timers[e]:SetTimerBarPos(value)
    		end  
        end,
        
    TrackerTimePos =
        function(value, Timers)
    		for e=TRACKER_START, TRACKER_END do
    			Timers[e]:SetTimerBarPos(value)
    		end
        end,
    
    AnkhTracker = 
        function(value, Timers)
    		if value and AvailableSpells[SpellIDs.Ankh] then
    			Timers[5]:activate()
    		else
    			Timers[5]:deactivate()
    		end
    		TotemTimers_OrderTrackers()
        end,
        
    ShieldTracker =
        function(value, Timers)
            Timers[6].ActiveWhileHidden = TotemTimers_Settings.ActivateHiddenTimers and not value
    		if (value or TotemTimers_Settings.ActivateHiddenTimers) and AvailableSpells[SpellIDs.LightningShield] then
    			Timers[6]:activate()
    		else
    			Timers[6]:deactivate()
    		end            
    		TotemTimers_OrderTrackers()		
        end,
        
    EarthShieldTracker = 
        function(value, Timers)
            Timers[7].ActiveWhileHidden = TotemTimers_Settings.ActivateHiddenTimers and not value
    		if (value or TotemTimers_Settings.ActivateHiddenTimers) and AvailableSpells[SpellIDs.EarthShield] then
    			Timers[7]:activate()
    		else
    			Timers[7]:deactivate()
    		end
    		TotemTimers_OrderTrackers()
        end,
        
    WeaponTracker =
        function(value, Timers)
            Timers[8].ActiveWhileHidden = TotemTimers_Settings.ActivateHiddenTimers and not value
    		if (value or TotemTimers_Settings.ActivateHiddenTimers) and AvailableSpells[SpellIDs.FlametongueWeapon] then
    			Timers[8]:activate()
    		else
    			Timers[8]:deactivate()
    		end
    		TotemTimers_OrderTrackers()
        end,
        
     
    HideBlizzTimers = 
        function(value)
            if value then
                TotemFrame:UnregisterEvent("PLAYER_TOTEM_UPDATE")
                TotemFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
                TotemFrame:SetScript("OnShow", function() TotemFrame:Hide() end)
                TotemFrame:Hide()
            else
                TotemFrame:RegisterEvent("PLAYER_TOTEM_UPDATE")
                TotemFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
                TotemFrame:Show()
                TotemFrame:SetScript("OnShow", TotemFrameScript)
            end
        end,
            
    ShieldLeftButton =
        function(value, Timers)
    		Timers[6].button:SetAttribute("*spell1",value)
        end,
        
    ShieldRightButton =
        function(value, Timers)
    		Timers[6].button:SetAttribute("*spell2", value)
        end,
            
    ShieldMiddleButton =
        function(value, Timers)
    		Timers[6].button:SetAttribute("*spell3", value)
        end,

        
    LastWeaponEnchant =  
        function(value, Timers)
            if value == 5 then
				Timers[8].button:SetAttribute("type1", "macro")
                Timers[8].button:SetAttribute("macrotext", "/cast "..SpellNames[SpellIDs.WindfuryWeapon].."\n/use 16")
                Timers[8].button:SetAttribute("doublespell1", SpellNames[SpellIDs.WindfuryWeapon])
                Timers[8].button:SetAttribute("doublespell2", SpellNames[SpellIDs.FlametongueWeapon])
				Timers[8].button:SetAttribute("ds", 1)
            elseif value == 6 then
				Timers[8].button:SetAttribute("type1", "macro")
                Timers[8].button:SetAttribute("macrotext", "/cast "..SpellNames[SpellIDs.WindfuryWeapon].."\n/use 16")
                Timers[8].button:SetAttribute("*spell1", SpellNames[SpellIDs.WindfuryWeapon])
                Timers[8].button:SetAttribute("doublespell1", SpellNames[SpellIDs.WindfuryWeapon])
                Timers[8].button:SetAttribute("doublespell2", SpellNames[SpellIDs.FrostbrandWeapon])
				Timers[8].button:SetAttribute("ds", 1)
            else 
				Timers[8].button:SetAttribute("type1", "spell")
                Timers[8].button:SetAttribute("spell1", value)
            end
        end,
        
    LastWeaponEnchant2 =  
        function(value, Timers)
            local b,nb = 2,3
            if TotemTimers_Settings.WeaponMenuOnRightclick then
                b,nb = 3,2
            end
            Timers[8].button:SetAttribute("spell"..nb, nil)
            Timers[8].button:SetAttribute("spell"..b, value)
        end,        
        
    Order =
        function(value, Timers)
    		for i=1,4 do Timers[i] = _G["XiTimers_Timer"..value[i]].timer end            
    		TotemTimers_OrderTimers()
        end,
    
    OpenOnRightclick =
        function(value, Timers)
            for i = 1,4 do
                if value and not TotemTimers_Settings.MenusAlwaysVisible then 
                    Timers[i].button:SetAttribute("OpenMenu", "RightButton")
                    Timers[i].button:SetAttribute("*macrotext3", "/script XiTimers.timers["..i.."].StopQuiet = true DestroyTotem("..Timers[i].nr..")")
                    Timers[i].button:SetAttribute("*macrotext2", "")
                else
                    Timers[i].button:SetAttribute("OpenMenu", "mouseover")
                    Timers[i].button:SetAttribute("*macrotext3", "")
                    Timers[i].button:SetAttribute("*macrotext2", "/script XiTimers.timers["..i.."].StopQuiet = true DestroyTotem("..Timers[i].nr..")")
                end
            end
        end,
    
    MenusAlwaysVisible =
        function(value, Timers)
            if value then
                for i=1,4 do
                    Timers[i].button:SetAttribute("OpenMenu", "always")
                end
            end
            for i=1,4 do
                TTActionBars.bars[i]:SetAlwaysVisible(value)
            end
        end,
     
    MiniIcons =
        function(value, Timers)
            for e=1,4 do
                if value then
                    Timers[e].button.miniIconFrame:Show()
                else
                    Timers[e].button.miniIconFrame:Hide()
                end
            end
        end,
        
    Lock =
        function(value, Timers)
            for k,v in pairs(Timers) do
                v.locked = value
            end
        end,
        
    Show =
        function(value, Timers)
            if value then
                for i=1,4 do
                    if GetMultiCastTotemSpells(Timers[i].nr) then
                        Timers[i]:activate()
                    end
                end
                --TotemTimersFrame:Show()
                TotemTimers_OrderTimers()
            else
                for i=1,4 do
                    Timers[i]:deactivate()
                end
                --TotemTimersFrame:Hide()
            end
        end,
     
    ProcFlash =
        function(value, Timers)
            for i=1,4 do
                Timers[i].ProcFlash = value
            end
        end,
     
    TimeFont =
        function(value, Timers)
            local font = LSM:Fetch("font", value)
            if font then
                for _,timer in pairs(Timers) do
                    timer:SetFont(font)
                end
            end
        end,
        
    TimerBarTexture =
        function(value, Timers) 
            local texture = LSM:Fetch("statusbar", value)
            if texture then
                for _,timer in pairs(Timers) do
                    timer:SetBarTexture(texture)
                end
            end
        end,
        
    ColorTimerBars =
        function(value, Timers)
            for i=1,#Timers do
                if value and i<5 then
                    Timers[i]:SetBarColor(TotemColors[Timers[i].nr][1], TotemColors[Timers[i].nr][2], TotemColors[Timers[i].nr][3],1)
                elseif i ~= 17 then
                    Timers[i]:SetBarColor(TotemTimers_Settings.TimerBarColor.r,TotemTimers_Settings.TimerBarColor.g,
                                          TotemTimers_Settings.TimerBarColor.b,TotemTimers_Settings.TimerBarColor.a)
                end
            end
        end,
        
    ShowCooldowns =
        function(value, Timers)
            if TotemTimers_IsSetUp then
                TotemTimers_OrderTimers()
                for i = 1,4 do TotemTimers.TotemEvent(Timers[i].button,"SPELL_UPDATE_COOLDOWN", i) end
            end
        end,
        
    BarBindings =
        function(value, Timers)
            for i=1,4 do
                for j=1,7 do
                    local key = GetBindingKey("TOTEMTIMERSCAST"..i..j)
                    if TotemTimers_Settings.BarBindings and not TotemTimers_Settings.MenusAlwaysVisible then
                        if TotemTimers_Settings.ReverseBarBindings then
                            getglobal("TT_ActionButton"..i..j.."HotKey"):SetText(key or tostring(10-j))
                            getglobal("TT_ActionButton"..i..j):SetAttribute("binding", tostring(10-j))
                        else
                            getglobal("TT_ActionButton"..i..j.."HotKey"):SetText(key or tostring(j))
                            getglobal("TT_ActionButton"..i..j):SetAttribute("binding", tostring(j))
                        end
                    else
                        getglobal("TT_ActionButton"..i..j.."HotKey"):SetText(key or "")
                        getglobal("TT_ActionButton"..i..j):SetAttribute("binding", nil)
                    end
                end
            end
        end,
        
   
    EnhanceCDs = 
        function(value)
            if value then
                TotemTimers_ActivateEnhanceCDs() 
            else
                TotemTimers_DeactivateEnhanceCDs()
            end
        end,
        
    EnhanceCDsSize =
        function(value, Timers)
            for i=9,21 do
                if i~= 20 then
                    Timers[i]:SetScale(value/36)
                end
            end
            TotemTimers.maelstrom.background:SetWidth(value*3+10)
            TotemTimers.maelstrom:SetWidth(value*3+10)
            TotemTimers.maelstrombutton:SetWidth(value*3+10)
            Timers[20]:SetTimeWidth(value*3+10)
            TotemTimers.LayoutEnhanceCDs()
        end,
        
    EnhanceCDsTimeHeight = 
         function(value, Timers)
    		for e=9,21 do
                if e~= 20 then
                    Timers[e]:SetTimeHeight(value)
                    local font, _ = Timers[e].button.time:GetFont()
                    Timers[e].button.time:SetFont(font, value+5, "OUTLINE")
                end
    		end 
            TotemTimers.LayoutEnhanceCDs()
        end,
        
    EnhanceCDsMaelstromHeight = 
        function(value, Timers)
            TotemTimers.maelstrom:SetHeight(value)
            TotemTimers.maelstrom.background:SetHeight(value)
            TotemTimers.maelstrombutton:SetHeight(value)
            TotemTimers.maelstrom.icon:SetWidth(value)
            TotemTimers.maelstrom.icon:SetHeight(value)
            Timers[20]:SetScale(value/36)
            Timers[20]:SetTimeHeight(value)
            Timers[20].timerbars[1]:SetScale(36/value)
            local font = TotemTimers.maelstrom.text:GetFont()
            local outline
            if Timers[9].timerOnButton then outline = "OUTLINE" end
    		TotemTimers.maelstrom.text:SetFont(font, value, outline)
            local font, value = _G["XiTimers_TimerBar17_1Time"]:GetFont()
            _G["XiTimers_TimerBar17_1Time"]:SetFont(font, value, outline)
            TotemTimers.LayoutEnhanceCDs()
        end,
        
    Tooltips =  
        function(value, Timers)
            for i=1,8 do
                Timers[i].button:SetAttribute("tooltip", value)
            end
            for i=1,TTActionBars.numbars do
                TTActionBars.bars[i]:SetTooltip(value)
            end
        end,
        
    TotemTimerBarWidth =
        function(value, Timers)
            for i=1,4 do
                for j=1,Timers[i].numtimers do
                    Timers[i].timerbars[j]:SetWidth(value)
                end
            end
        end,
        
    TrackerTimerBarWidth =
        function(value, Timers)
            for i=5,8 do
                for j=1,Timers[i].numtimers do
                    Timers[i].timerbars[j]:SetWidth(value)
                end
            end
            for i=22,23 do
                for j=1,Timers[i].numtimers do
                    Timers[i].timerbars[j]:SetWidth(value)
                end
            end
        end,
        
    ActivateHiddenTimers =
        function(value, Timers)
            TotemTimers.ProcessSpecSetting("ShieldTracker")
            TotemTimers.ProcessSetting("EarthShieldTracker")
            TotemTimers.ProcessSetting("WeaponTracker")
        end,
        
    ShowKeybinds =
        function(value, Timers)
            for _,t in pairs(Timers) do
                if value then
                    t.button.hotkey:Show()
                else
                    t.button.hotkey:Hide()
                end
            end
            if value then TotemTimers_MultiSpellHotKey:Show()
            else TotemTimers_MultiSpellHotKey:Hide() end
        end,
        
    FramePositions = 
        function(value, Timers)
            for name, pos in pairs(value) do
                if pos and pos[1] then
                    _G[name]:ClearAllPoints()
                    _G[name]:SetPoint(pos[1],pos[2],pos[3],pos[4],pos[5])
                end
            end
        end,
        
    WeaponBarDirection = 
        function(value, Timers)
            TTActionBars.bars[5]:SetDirection(value, TotemTimers_Settings.TrackerArrange)
            if #TTActionBars.bars > 5 then TotemTimers.ProcessSetting("MultiSpellBarDirection") end
        end,
        
    ESMainTankMenuDirection =
        function(value, Timers)
            TTActionBars.bars[6]:SetDirection(value, TotemTimers_Settings.TrackerArrange)
            if #TTActionBars.bars > 5 then TotemTimers.ProcessSetting("MultiSpellBarDirection") end
        end,   
        
    WeaponMenuOnRightclick =
        function(value, Timers)
            if value then 
                XiTimers.timers[8].button:SetAttribute("OpenMenu", "RightButton")
            else
                XiTimers.timers[8].button:SetAttribute("OpenMenu", "mouseover")
            end
            TotemTimers.ProcessSpecSetting("LastWeaponEnchant2")
        end,
        
    EnableMultiSpellButton = 
        function(value, TimerS)
            TotemTimers.MultiSpellActivate()
        end,
        
    MultiSpellBarOnRightclick =
        function(value, Timers)
            if value then 
                TotemTimers_MultiSpell:SetAttribute("OpenMenu", "RightButton")
                TotemTimers_MultiSpell:SetAttribute("*spell2", nil)
                TotemTimers_MultiSpell:SetAttribute("*spell3", SpellIDs.TotemicCall)
            else
                TotemTimers_MultiSpell:SetAttribute("OpenMenu", "mouseover")
                TotemTimers_MultiSpell:SetAttribute("*spell2", SpellIDs.TotemicCall)
                TotemTimers_MultiSpell:SetAttribute("*spell3", nil)
            end
        end,
    
    MultiSpellSize = 
        function(value, Timers)
   			TotemTimers_MultiSpell:SetScale(value/36)
            TotemTimers.ProcessSetting("TimerSize")
        end,
        
    MultiSpellBarDirection = 
        function(value, Timers)
            local v = value
            if v == "sameastimers" then
                v = TTActionBars.bars[1]:CalcDirection(TTActionBars.bars[1].direction, TTActionBars.bars[1].parentdirection)
            elseif v == "sameastrackers" then
                v = TTActionBars.bars[1]:CalcDirection(TTActionBars.bars[5].direction, TTActionBars.bars[5].parentdirection)
            end
            TTActionBars.bars[7]:SetDirection(v, "free", true)
        end,
        
    HideDefaultTotemBar =
        function(value, Timers)
            if value then
               --[[ MultiCastActionBarFrame:UnregisterAllEvents()
                --MultiCastActionBarFrame:Hide()
                for i=1,3 do
                    _G["MultiCastActionPage"..i]:Hide()
                end
                MultiCastRecallSpellButton:Hide()
                MultiCastSummonSpellButton:Hide()
                for i=1,4 do
                    _G["MultiCastSlotButton"..i]:Hide()
                end]]
                MultiCastActionBarFrame:HookScript("OnUpdate", SetMultiCastParent)
                MultiCastBarParent:Hide()
            else
                --[[MultiCastActionBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
                MultiCastActionBarFrame:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR")
                _G["MultiCastActionPage"..MultiCastActionBarFrame.currentPage]:Show()
                MultiCastActionBarFrame_Update(MultiCastActionBarFrame)]]
                --if OldMultiCastBarParent then MultiCastActionBarFrame:SetParent(OldMultiCastBarParent) end
                MultiCastBarParent:Show()
            end
        end,
        
    MultiSpellBarBinds =
        function(value, Timers)
            for i=1,3 do
                if value then
                    if TotemTimers_Settings.MultiSpellReverseBarBinds then
                        getglobal("TT_ActionButton7"..i.."HotKey"):SetText(tostring(10-i))
                        getglobal("TT_ActionButton7"..i):SetAttribute("binding", tostring(10-i))
                    else
                        getglobal("TT_ActionButton7"..i.."HotKey"):SetText(tostring(i))
                        getglobal("TT_ActionButton7"..i):SetAttribute("binding", tostring(i))
                    end
                else
                    getglobal("TT_ActionButton7"..i.."HotKey"):SetText("")
                    getglobal("TT_ActionButton7"..i):SetAttribute("binding", nil)
                end
            end
        end,
        
    EnhanceCDsOOCAlpha = 
        function(value, Timers)
            for i = 9,21 do
                Timers[i].OOCAlpha = value
            end
            TotemTimers.maelstrom:SetAlpha(value)
            XiTimers.invokeOOCFader()
        end,
        
    TimersOnButtons = 
        function(value, Timers)
            for i=1,#Timers do
                if i ~= 20 then
                    Timers[i].timerOnButton = value
                    if not value and i > 8 and TotemTimers.ActiveSpecSettings.CDTimersOnButtons then Timers[i].timerOnButton = true end
                    if Timers[i].timers[1] > 0 then Timers[i]:start(1, Timers[i].timers[1], Timers[i].durations[1]) end
                    if Timers[i].numtimers > 1 and Timers[i].timers[2] > 0 then Timers[i]:start(2, Timers[i].timers[2], Timers[i].durations[1]) end
                end
            end
            TotemTimers.ProcessSpecSetting("EnhanceCDsMaelstromHeight")
        end,
    
    TimeColor = 
        function(value, Timers)
            for i=1,#Timers do
                Timers[i].button.time:SetTextColor(value.r, value.g, value.b, 1)
                Timers[1].timeColor = value
                for j=1,#Timers[i].timerbars do
                    Timers[i].timerbars[j].time:SetTextColor(value.r,value.g,value.b,1)
                end
            end
        end,
        
    CastButtons = function() TotemTimers.SetupTotemCastButtons() end,
    
    HideInVehicle = 
        function(value, Timers)
            if value then
                for k,v in pairs(Timers) do
                    RegisterStateDriver(v.button,"invehicle","[bonusbar:5]hide;show")
                end
                RegisterStateDriver(TotemTimers.MB,"invehicle","[bonusbar:5]hide;show")
            else
                for k,v in pairs(Timers) do
                    UnregisterStateDriver(v.button,"invehicle")
                end
                UnregisterStateDriver(TotemTimers.MB,"invehicle")
            end
        end,
   
    StopPulse =
        function(value, Timers)
            for i = 1,4 do
                Timers[i].StopPulse = value
            end
            for i = 6,8 do
                Timers[i].StopPulse = value
            end
        end,
        
    HideEnhanceCDsOOC =
        function(value, Timers)
            for i = 9,21 do
                Timers[i].HideOOC = value
            end
            TotemTimers.ConfigEnhanceCDs()
        end,
        
        
    EarthShieldTargetName =
        function(value, Timers)
            if value then
                Timers[7].nameframe:Show()
            else
                Timers[7].nameframe:Hide()
            end
        end,
        
    EnhanceCDs_Clickthrough =
        function(value, Timers)
            for i = 9,21 do
                Timers[i].button:EnableMouse(not value)
            end
            TotemTimers.maelstrom:EnableMouse(not value)
            TotemTimers.maelstrombutton:EnableMouse(not value)
        end,
        
    Timer_Clickthrough = 
        function(value, Timers)
            for i = 1,4 do
                Timers[i].button:EnableMouse(not value)
            end
        end,
        
    Tracker_Clickthrough = 
        function(value, Timers)
            for i = 5,8 do
                Timers[i].button:EnableMouse(not value)
            end
        end,
        
    ESChargesOnly = 
        function(value, Timers)
            TotemTimers.SetEarthShieldUpdate()
        end,
        
    CrowdControlSize = 
        function(value, Timers)
    		for e=22, 23 do
    			Timers[e]:SetScale(value/36)
    		end
        end,
        
    CrowdControlTimePos =
        function(value, Timers)
    		for e=22, 23 do
    			Timers[e]:SetTimerBarPos(value)
    		end
        end,
        
    CrowdControlClickthrough = 
        function(value, Timers)
            for i = 22,23 do
                Timers[i].button:EnableMouse(not value)
            end
        end,
        
    BorderTimerSize =
        function(value, Timers)
            for _,t in pairs(Timers) do
                t.button.BorderBar:SetWidth(value)
            end
        end,
        
    RoundButtons = 
        function(value, Timers)
            for _,t in pairs(Timers) do
                if value then
                    t.button.BorderBar:SetStatusBarTexture("Interface\\AddOns\\TotemTimers\\dot")
                else
                    t.button.BorderBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
                end
            end
        end,

    BorderTimers = 
        function(value, Timers)
            for _,t in pairs(Timers) do
                if value and t.hasBorderTimer then
                    t.button.BorderBar:Show()
                else
                    t.button.BorderBar:Hide()
                end
            end
        end,
        
    CrowdControlEnable =
        function(value, Timers)
            if not value then
                Timers[22]:deactivate()
                Timers[23]:deactivate()
                TotemTimers_CrowdControlFrame:Hide()
            else
                Timers[22]:activate()
                Timers[23]:activate()
                TotemTimers_CrowdControlFrame:Show() 
            end
        end,                
        
}

SettingsFunctions.ReverseBarBindings = SettingsFunctions.BarBindings
SettingsFunctions.ReversMultiSpellBarBinds = SettingsFunctions.MultiSpellBarBinds

