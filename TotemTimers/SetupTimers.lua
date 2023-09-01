-- Copyright © 2008, 2009 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.
-- Current distribution permissions only include curse.com, wowui.worldofwar.net, wowinterface.com and their respective addon updaters

local L = LibStub("AceLocale-3.0"):GetLocale("TotemTimers", true)

local timercount = {[AIR_TOTEM_SLOT] = 3, [FIRE_TOTEM_SLOT] = 3, [EARTH_TOTEM_SLOT] = 5, [WATER_TOTEM_SLOT] = 2}

local RaidMembers = {}

local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS

local BuffNames = TotemTimers.BuffNames
local SpellNames = TotemTimers.SpellNames
local TextureToName = TotemTimers.TextureToName
local NameToSpellID = TotemTimers.NameToSpellID
local SpellIDs = TotemTimers.SpellIDs

local MultiCastSpellIDs = {SpellIDs.CallofElements,SpellIDs.CallofAncestors,SpellIDs.CallofSpirits}

local MultiCastActions = {
    [FIRE_TOTEM_SLOT]  = {[SpellIDs.CallofElements]=133,[SpellIDs.CallofAncestors]=137,[SpellIDs.CallofSpirits]=141},
    [EARTH_TOTEM_SLOT] = {[SpellIDs.CallofElements]=134,[SpellIDs.CallofAncestors]=138,[SpellIDs.CallofSpirits]=142},
    [WATER_TOTEM_SLOT] = {[SpellIDs.CallofElements]=135,[SpellIDs.CallofAncestors]=139,[SpellIDs.CallofSpirits]=143},
    [AIR_TOTEM_SLOT]   = {[SpellIDs.CallofElements]=136,[SpellIDs.CallofAncestors]=140,[SpellIDs.CallofSpirits]=144},
}

TotemTimers.MultiCastActions = MultiCastActions
TotemTimers.MultiCastSpellIDs = MultiCastSpellIDs


function TotemTimers_CreateTimers()
	for e = 1,4 do
		local tt = XiTimers:new(timercount[e])

        tt.ManaCheckMini = true
		tt.button:SetScript("OnEvent", TotemTimers.TotemEvent)
		tt.spacing = TotemTimers_Settings.TimerSpacing
		tt.events[1] = "PLAYER_TOTEM_UPDATE"
        tt.events[2] = "SPELL_UPDATE_COOLDOWN"
        tt.events[3] = "PLAYER_ENTERING_WORLD"
        tt.events[4] = "UNIT_SPELLCAST_SUCCEEDED"
        tt.events[5] = "PLAYER_REGEN_ENABLED"
        --tt.events[6] = "UNIT_AURA"
        --tt.events[7] = "RAID_ROSTER_UPDATE"
        
		tt.button.anchorframe = TotemTimersFrame
		tt.button:RegisterForClicks("AnyDown")
		tt.button:SetAttribute("*type2", "macro")
		tt.button:SetAttribute("*type3", "macro")
		tt.button:SetAttribute("*macrotext2", "/script DestroyTotem("..e..")")		
		tt.button:SetAttribute("*type1", "spell")
		tt.button.UpdateMiniIcon = function(self)
                local spell = self:GetAttribute("*spell1")
                if spell and spell ~= 0 then
                    local _,_,t = GetSpellInfo(self:GetAttribute("*spell1"))
                    self.miniIcon:SetTexture(t)
                    TotemTimers.TotemEvent(self, "SPELL_UPDATE_COOLDOWN", self.timer.nr)
                    self.timer.ManaCheck = t
                    TotemTimers.SetEmptyTexCoord(self.miniIcon)
                else
					self.miniIcon:SetTexture(TotemTimers.emptyTotem)
                    TotemTimers.SetEmptyTexCoord(self.miniIcon, self.element)
				end
                local c = self.timer.Cast1:GetAttribute("spell1")
                if c then
                    self.timer.Cast1.Icon:SetTexture(GetSpellTexture(c))
                end
                local c = self.timer.Cast2:GetAttribute("spell1")
                if c then
                    self.timer.Cast2.Icon:SetTexture(GetSpellTexture(c))
                end
			end
        tt.button.ShowTooltip = TotemTimers.TimerTooltip
        tt.button.HideTooltip = function(self) GameTooltip:Hide() end
		tt.button:SetAttribute("_onenter", [[ control:CallMethod("ShowTooltip")
                                              if self:GetAttribute("OpenMenu") == "mouseover" then
                                                  control:ChildUpdate("show", true)
                                              end ]])
		tt.button:SetAttribute("_onleave", [[ control:CallMethod("HideTooltip")]])
		tt.button:SetAttribute("_onattributechanged", [[ if name=="hide" then
                                                             control:ChildUpdate("show", false)
                                                         elseif name == "*spell1" then 
                                                            local mspell = self:GetAttribute("mspell")
                                                            if mspell then
                                                                self:SetAttribute("mspell"..mspell,self:GetAttribute("*spell1"))
                                                            end
                                                            if value then
                                                                local c = self:GetAttribute("Cast1-"..value)
                                                                local f = self:GetFrameRef("Cast1")
                                                                if c and c~= 0 then
                                                                    f:SetAttribute("spell1", c)
                                                                    f:Show()
                                                                else
                                                                    f:SetAttribute("spell1", nil)
                                                                    f:Hide()
                                                                end
                                                                local f = self:GetFrameRef("Cast2")
                                                                c = self:GetAttribute("Cast2-"..value)
                                                                if c and c~= 0 then
                                                                    f:SetAttribute("spell1", c)
                                                                    f:Show()
                                                                else
                                                                    f:SetAttribute("spell1", nil)
                                                                    f:Hide()
                                                                end
                                                            end
                                                            control:CallMethod("UpdateMiniIcon")
                                                         elseif name == "state-invehicle" then
                                                            if value == "show" and self:GetAttribute("active") then
                                                                self:Show()
                                                                local s = self:GetAttribute("*spell1")
                                                                if s then self:SetAttribute("*spell1", s) end
                                                            else
                                                                self:Hide()
                                                            end
                                                         end]])
        tt.button:WrapScript(tt.button, "OnClick", [[ if (button == self:GetAttribute("OpenMenu")
                                                        or (button == "Button4")) then
                                                          local open = self:GetAttribute("open")
                                                          control:ChildUpdate("show", not open)
														  self:SetAttribute("open", not open)
                                                      end ]])
        tt.button:SetAttribute("_childupdate-mspell", [[  self:SetAttribute("mspell", tostring(message))
                                                          self:SetAttribute("*spell1", self:GetAttribute("mspell"..message) or 0)
                                                          for i = 1,8 do
                                                              local f = self:GetFrameRef("f"..i)
                                                              if f then 
                                                                  f:SetAttribute("*action*", self:GetAttribute("action"..message))
                                                              end
                                                          end
                                                      ]])        
        tt.activate = function(self)
            XiTimers.activate(self)
            TotemTimers.TotemEvent(self.button, "PLAYER_TOTEM_UPDATE", self.nr)
            TotemTimers.TotemEvent(self.button, "SPELL_UPDATE_COOLDOWN", self.nr)
        end
        
        tt.update = function(self, elapsed)
            XiTimers.update(self, elapsed)
            if self.timers[1] > 0 then
                if not TotemTimers.GetPlayerRange(self.button.element) then
                    self.button.playerdot:Show()
                else
                    self.button.playerdot:Hide()
                end
                local count = TotemTimers.GetOutOfRange(self.button.element)
                if count > 0 then
                    self.button.RangeCount:SetText(count)
                else
                    self.button.RangeCount:SetText("")
                end
            end
        end
        
        for i = 1,2 do
            tt["Cast"..i] = CreateFrame("Button", tt.button:GetName().."Cast"..i, tt.button, "ActionButtonTemplate, SecureActionButtonTemplate")
            tt.button:SetFrameRef("Cast"..i, tt["Cast"..i])
            tt["Cast"..i]:SetScale(0.5)            
            tt["Cast"..i]:Hide()
            tt["Cast"..i]:SetAttribute("type1", "spell")
            tt["Cast"..i].Icon = _G[tt["Cast"..i]:GetName().."Icon"]
            tt["Cast"..i].Icon:SetTexture(GetSpellTexture("Lightning Shield"))
            --for rActionButtonStyler
            tt["Cast"..i].action = 0 
            tt["Cast"..i].SetCheckedTexture = function() end
            if not IsAddOnLoaded("rActionButtonStyler") then
                tt["Cast"..i]:SetNormalTexture(nil)
            else
                ActionButton_Update(tt["Cast"..i])
            end
            --
        end
        tt.Cast1:SetPoint("RIGHT", tt.button, "LEFT")
        
        tt.button:UpdateMiniIcon()
        tt.button:SetScript("OnDragStop", function(self)
                XiTimers.StopMoving(self)
                if not InCombatLockdown() then TotemTimers.PositionCastButtons() end
                if not InCombatLockdown() then self:SetAttribute("hide", true) end
            end)
        for k,v in pairs(MultiCastActions[e]) do
            tt.button:SetAttribute("multi"..k,v)
        end

	end
	TotemTimers_CreateCastButtons()
end


function TotemTimers.SetupTotemButtons()
    for i = 1,4 do
        local button = XiTimers.timers[i].button
        local nr = XiTimers.timers[i].nr
        for ms, a in pairs(MultiCastActions[nr]) do
            local _,spell,_ = GetActionInfo(a)
            button:SetAttribute("mspell"..ms, spell or 0)
            button:SetAttribute("action"..ms, a)
            if ms == TotemTimers_Settings.LastMultiCastSpell then
                local texture = TotemTimers.emptyTotem
                if spell then _,_,texture = GetSpellInfo(spell) end
                if spell and not button.icons[1]:GetTexture() then button.icons[1]:SetTexture(texture) end
                if not spell and not button.icons[1]:GetTexture() then TotemTimers.SetEmptyIcon(button.icons[1], nr) end
                button:SetAttribute("*spell1", spell)
            end
        end
        button:SetAttribute("mspell", TotemTimers_Settings.LastMultiCastSpell or SpellIDs.CallofElements)
    end    
end

function TotemTimers.SetupTotemCastButtons()
    for id,totem in pairs(TotemData) do
        if TotemTimers.ActiveSpecSettings.CastButtons[id] then
            for nr = 1,2 do
                if TotemTimers.AvailableSpells[id] then
                    for i=1,4 do
                        XiTimers.timers[i].button:SetAttribute("Cast"..nr.."-"..id, TotemTimers.ActiveSpecSettings.CastButtons[id][nr])
                    end
                end
            end
        end
    end
    for i=1,4 do  --this part seems unnecessary (setting the same spells), but it is used to invoke the _onattributechanged part of the secure timer buttons
        local spell = XiTimers.timers[i].button:GetAttribute("*spell1")
        if spell then 
            XiTimers.timers[i].button:SetAttribute("*spell1", spell)
        end
    end
end

local Cooldowns = {
    [EARTH_TOTEM_SLOT] = {
        [2] = TotemTimers.SpellIDs.EarthBind,
        [3] = TotemTimers.SpellIDs.StoneClaw,
        [4] = TotemTimers.SpellIDs.Tremor,
        [5] = TotemTimers.SpellIDs.EarthElemental,
    },
    [WATER_TOTEM_SLOT] = {
        [2] = TotemTimers.SpellIDs.ManaTide,
    },
    [FIRE_TOTEM_SLOT] = {
        [2] = TotemTimers.SpellIDs.FireElemental,
    },
    [AIR_TOTEM_SLOT] = {
        [2] = TotemTimers.SpellIDs.Grounding,
        [3] = TotemTimers.SpellIDs.SpiritLink,
    },
}

local TotemicCall = TotemTimers.SpellNames[TotemTimers.SpellIDs.TotemicCall]
local LightningBolt = TotemTimers.SpellNames[TotemTimers.SpellIDs.LightningBolt]
local FireElemental = TotemTimers.SpellNames[TotemTimers.SpellIDs.FireElemental]

function TotemTimers:TotemEvent(event, arg1, arg2)
    local settings = TotemTimers_Settings
    if event == "PLAYER_TOTEM_UPDATE" then
    	if self.element == arg1 then
    		local _, totem, startTime, duration, icon = GetTotemInfo(arg1)
            totem = NameToSpellID[totem]
    		if duration > 0 and totem and TotemData[totem] then
    			self.icons[1]:SetTexture(icon)
                TotemTimers.SetEmptyIcon(self.icons[1])
                self.timer.activeTotem = totem
    			self.timer.warningMsgs[1] = "TotemWarning"
    			self.timer.expirationMsgs[1] = "TotemExpiration"
    			self.timer.earlyExpirationMsgs[1] = "TotemDestroyed"
                self.timer.WarningIcons[1] = icon
                self.timer.WarningSpells[1] = SpellNames[totem]
                if TotemData[totem].flashInterval then
                    self.bar:SetMinMaxValues(0,TotemData[totem].flashInterval)
                    self.timer.bar = TotemData[totem].flashInterval
                else
                    self.timer.bar = nil
                end
    			self.timer:start(1, startTime+duration-GetTime())
                TotemTimers.SetTotemPosition(self.element)
                TotemTimers.ResetRange(self.element)
                if TotemData[totem].noRangeCheck then
                    self.RangeCount:SetText("")
                    self.playerdot:Hide()
               --[[ else
                    if settings.CheckPlayerRange then TotemTimers.TotemEvent(self, "UNIT_AURA", "player") end
                    TotemTimers.ResetRange(self.element)
                    local count = TotemTimers_GetMissingBuffs(self.element)
                    self.RangeCount:SetText("")]]
                end
            else
                TotemTimers.ResetRange(self.element)
                self.RangeCount:SetText("")
                if self.timer.timers[1] > 0 then 
                    self.timer:stop(1)
                end
    		end
    	end
    elseif event == "SPELL_UPDATE_COOLDOWN" then -- SPELL_UPDATE_COOLDOWN
        local spell = self:GetAttribute("*spell1")
        if spell and (not self.timer.timerOnButton or self.timer.timers[1] <= 0) then
            local start, duration, enable = GetSpellCooldown(spell)
            if start and duration then CooldownFrame_SetTimer(self.cooldown, GetSpellCooldown(spell)) end
        end
        if settings.ShowCooldowns then
            for nr, spell in pairs(Cooldowns[self.timer.nr]) do
                if TotemTimers.AvailableSpells[spell] then
                    local start, duration, enable = GetSpellCooldown(spell)
					if not start and not duration then
						self.timer:stop(nr)
						return
			        end
                    if duration == 0 then
                        self.timer:stop(nr)
                    elseif duration > 2 then --and self.timer.timers[nr]<=0 then  -- update running cooldown timers for Ele T12-2pc
                        self.timer:start(nr,start+duration-floor(GetTime()),duration)
                        self.timer.timerbars[nr].icon:SetTexture(TotemTimers.SpellTextures[spell])
                    end
                elseif self.timer.timers[nr] > 0 then
                    self.timer:stop(nr)
                end 
            end
        else
            for i = 2, self.timer.numtimers do
                self.timer:stop(i)
            end
        end
    elseif (event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player" and arg2 == TotemicCall)
        or event == "PLAYER_ENTERING_WORLD" then
        self.timer.StopQuiet = true
        self.timer:stop(1)
        self.RangeCount:SetText("")
    end
end


local ButtonPositions = {
	["box"] = {{"CENTER",0,"CENTER"},{"LEFT",1,"RIGHT"},{"TOP",2,"BOTTOM"},{"LEFT",1,"RIGHT"}},
	["horizontal"] = {{"CENTER",0,"CENTER"},{"LEFT",1,"RIGHT"},{"LEFT",1,"RIGHT"},{"LEFT",1,"RIGHT"}},
	["vertical"] = {{"CENTER",0,"CENTER"},{"TOP",1,"BOTTOM"},{"TOP",1,"BOTTOM"},{"TOP",1,"BOTTOM"}}	
}


function TotemTimers_OrderTimers()
	if InCombatLockdown() then return end
	local Timers = XiTimers.timers
	local Settings = TotemTimers_Settings
	for e=1,4 do
		Timers[e]:ClearAnchors()
		Timers[e].button:ClearAllPoints()
	end
    local c = 0
    local pos = {}
	for e=1,4 do
        if Timers[e].active then
            c = c + 1
            Timers[e].actnr = c
            local arrange = Settings.Arrange
            if arrange ~= "free" then
                if c == 1 then
                    Timers[e]:SetPoint(ButtonPositions[arrange][1][1], TotemTimersFrame, ButtonPositions[arrange][1][3])
                else
                    Timers[e]:Anchor(pos[c-ButtonPositions[arrange][c][2]], ButtonPositions[arrange][c][1])
                end
                Timers[e].savePos = false
            else
                local pos = TotemTimers.ActiveSpecSettings.TimerPositions[Timers[e].nr]
                if not pos or not pos[1] then pos = {"CENTER", "UIParent", "CENTER", 0,0} end
                Timers[e].button:ClearAllPoints()
                Timers[e].button:SetPoint(pos[1], pos[2], pos[3], pos[4], pos[5])
                Timers[e].savePos = true
            end
            pos[c] = Timers[e]
		end
	end
end


local BarMiniIconPos = {
    ["horizontal"] = {{"BOTTOMLEFT","TOPLEFT"}, {"BOTTOM", "TOP"}, {"BOTTOMRIGHT", "TOPRIGHT"},},
    ["vertical"] = {{"TOPRIGHT", "TOPLEFT"}, {"RIGHT", "LEFT"}, {"BOTTOMRIGHT", "BOTTOMLEFT"},},
}


function TotemTimers_CreateCastButtons()
    for i = 1,4 do 
        TTActionBars:new(8, XiTimers.timers[i].button, _G["TotemTimers_CastBar"..i], TotemTimersFrame)
        for j = 1,8 do
            local button = _G["TT_ActionButton"..i..j]
            XiTimers.timers[i].button:SetFrameRef("f"..j, button)
            button:SetAttribute("*action*", MultiCastActions[i][TotemTimers_Settings.LastMultiCastSpell])
            button:SetAttribute("*type2", "multispell")
            button.ChangeTotemOrder = function(self,totem1)
                    if InCombatLockdown() then return end
                    _, totem1 = GetSpellBookItemInfo(totem1, BOOKTYPE_SPELL)
                    local totem2 = self:GetAttribute("*spell1")
                    local nr = self:GetParent().element
                    if nr and totem1 and totem2 then
                        local Order = TotemTimers_Settings.TotemOrder[nr]
                        local pos1, pos2 = 0,0
                        for i=1,#TotemTimers_Settings.TotemOrder[nr] do
                            if Order[i] == totem1 then pos1 = i end
                            if Order[i] == totem2 then pos2 = i end
                        end
                        if pos1 > 0 and pos2 > 0 then
                            Order[pos1],Order[pos2] = Order[pos2],Order[pos1]
                            TotemTimers_SetCastButtonSpells()
                        end
                    end
                end

            button:SetAttribute("_ondragstart",[[ if IsShiftKeyDown() and self:GetAttribute("*spell1")~=0 then
                                                                            return "spell", self:GetAttribute("*spell1")
                                                                       else control:CallMethod("StartBarDrag") end]])
            button:SetAttribute("_onreceivedrag",[[ if kind == "spell" then
                                                                            control:CallMethod("ChangeTotemOrder", value, ...)
                                                                            return "clear"
                                                                       end]])
            for k = 1,4 do
                button.MiniIcons[k]:SetWidth(12)
                button.MiniIcons[k]:SetHeight(12)
                button.MiniIcons[k]:Hide()
            end
            
            button.MiniIcons[1]:SetTexture(GetSpellTexture(SpellNames[SpellIDs.CallofElements]))
            button.MiniIcons[2]:SetTexture(GetSpellTexture(SpellNames[SpellIDs.CallofAncestors]))
            button.MiniIcons[3]:SetTexture(GetSpellTexture(SpellNames[SpellIDs.CallofSpirits]))
            
            button.slots = {MultiCastActions[i][SpellIDs.CallofElements], MultiCastActions[i][SpellIDs.CallofAncestors], MultiCastActions[i][SpellIDs.CallofSpirits]}
            
            button.OnShow = function(self)
                local dir = self.bar.actualDirection
                if dir == "up" or dir == "down" then
                    dir = "vertical"
                else
                    dir = "horizontal"
                end
                for i = 1,3 do
                    self.MiniIcons[i]:ClearAllPoints()
                    self.MiniIcons[i]:SetPoint(BarMiniIconPos[dir][i][1], self:GetName(), BarMiniIconPos[dir][i][2])                    
                    local _,id = GetActionInfo(self.slots[i])
                    if id == self:GetAttribute("*spell1") then
                        self.MiniIcons[i]:Show()
                    else
                        self.MiniIcons[i]:Hide()
                    end
                end
            end
        end
    end
    TotemTimers.PositionCastButtons()
    TotemTimers_SetCastButtonSpells()
end


local TotemCastPositions = {
    ["LEFT"] = {[1] = "BOTTOMRIGHT", [2] = "TOPRIGHT"},
    ["RIGHT"] = {[1] = "BOTTOMLEFT", [2] = "TOPLEFT"},
    ["TOP"] = {[1] = "BOTTOMRIGHT", [2] = "BOTTOMLEFT"},
    ["BOTTOM"] = {[1] = "TOPRIGHT", [2] = "TOPLEFT"},
}

function TotemTimers.PositionCastButtons()
    for i = 1,4 do
        TTActionBars.bars[i]:SetDirection(TotemTimers_Settings.CastBarDirection, TotemTimers_Settings.Arrange)
    end
    if #TTActionBars.bars > 5 then TotemTimers.ProcessSetting("MultiSpellBarDirection") end
    
    -- and position totem cast buttons
    local pos = TotemTimers_Settings.CastButtonPosition
    if TotemTimers_Settings.Arrange == "horizontal" then
        if pos ~= "TOP" and pos ~= "BOTTOM" then
            local dir = TTActionBars.bars[1]:CalcDirection(TotemTimers_Settings.CastBarDirection, TotemTimers_Settings.Arrange)
            if dir == "down" then
                pos = "TOP"
            else
                pos = "BOTTOM"
            end
        end
        for i = 1,4 do
            XiTimers.timers[i].Cast1:ClearAllPoints()
            XiTimers.timers[i].Cast1:SetPoint(TotemCastPositions[pos][1], XiTimers.timers[i].button, pos)
            XiTimers.timers[i].Cast2:ClearAllPoints()
            XiTimers.timers[i].Cast2:SetPoint(TotemCastPositions[pos][2], XiTimers.timers[i].button, pos)
        end
    elseif TotemTimers_Settings.Arrange == "vertical" then        
        if pos ~= "LEFT" and pos ~= "RIGHT" then
            local dir = TTActionBars.bars[1]:CalcDirection(TotemTimers_Settings.CastBarDirection, TotemTimers_Settings.Arrange)
            if dir == "left" then
                pos = "RIGHT"
            else
                pos = "LEFT"
            end
        end
        for i = 1,4 do
            XiTimers.timers[i].Cast1:ClearAllPoints()
            XiTimers.timers[i].Cast1:SetPoint(TotemCastPositions[pos][1], XiTimers.timers[i].button, pos)
            XiTimers.timers[i].Cast2:ClearAllPoints()
            XiTimers.timers[i].Cast2:SetPoint(TotemCastPositions[pos][2], XiTimers.timers[i].button, pos)
        end
    else
        for i = 1,4 do
            XiTimers.timers[i].Cast1:ClearAllPoints()
            XiTimers.timers[i].Cast1:SetPoint("BOTTOM", UIParent, "TOP", 0, 50)
            XiTimers.timers[i].Cast2:ClearAllPoints()
            XiTimers.timers[i].Cast2:SetPoint("BOTTOM", UIParent, "TOP", 0, 50)
        end
    end
end



local SpellArray = {}


function TotemTimers_SetCastButtonSpells()
	for i = 1,4 do
        local timer = XiTimers.timers[i]
        wipe(SpellArray)
        for k,v in pairs(TotemTimers_Settings.TotemOrder[timer.nr]) do
            if TotemTimers.AvailableSpells[v] and not TotemTimers.ActiveSpecSettings.HiddenTotems[v] then
                table.insert(SpellArray, v)
            end
        end
        table.insert(SpellArray,0)
        TTActionBars.bars[timer.nr]:SetSpells(SpellArray)
	end
end
