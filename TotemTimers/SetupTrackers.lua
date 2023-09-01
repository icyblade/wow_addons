-- Copyright © 2008, 2009 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.
-- Current distribution permissions only include curse.com, wowui.worldofwar.net, wowinterface.com and their respective addon updaters

local L = LibStub("AceLocale-3.0"):GetLocale("TotemTimers")

local Timers = XiTimers.timers
local SpellNames = TotemTimers.SpellNames
local SpellIDs = TotemTimers.SpellIDs
local SpellTextures = TotemTimers.SpellTextures
local AvailableSpells = TotemTimers.AvailableSpells


local WeaponBar

local mainHandWeapon, offHandWeapon, lastMhWeapon, lastOhWeapon
local earthShieldTarget = nil

local playerName = UnitName("player")
local earthShieldRecast = false
local changeEarthShieldRecast = false

local buttons = {"LeftButton", "RightButton", "MiddleButton", "Button4"}

function TotemTimers.SetNumWeaponTimers()
    local button = Timers[8].button
	local role = GetPrimaryTalentTree()
    TotemTimers.SetDoubleTexture(button, role == 2, true)
    Timers[8].numtimers = (role == 2) and 2 or 1
	Timers[8]:SetTimerBarPos(Timers[8].timerBarPos)
end


local function splitString(ustring)
    local c = 0
    local s = ""
    for uchar in string.gmatch(ustring, "([%z\1-\127\194-\244][\128-\191]*)") do
        c = c + 1
        s = s..uchar
        if c == 4 then break end
    end
    return s
end

function TotemTimers_CreateTrackers()
	-- ankh tracker
	local ankh = XiTimers:new(1)
	ankh.button:SetScript("OnEvent", TotemTimers.AnkhEvent)
	ankh.button.icons[1]:SetTexture(SpellTextures[SpellIDs.Ankh])
	ankh.events[1] = "BAG_UPDATE"
	ankh.events[2] = "SPELL_UPDATE_COOLDOWN"
	ankh.button.anchorframe = TotemTimers_TrackerFrame
	ankh.showCooldown = true
	ankh.dontAlpha = true
	ankh.button.icons[1]:SetAlpha(1)
	ankh.timeStyle = "blizz"
	ankh.activate = function(self) 
        XiTimers.activate(self) 
        TotemTimers.AnkhEvent(ankh.button, "SPELL_UPDATE_COOLDOWN")
        TotemTimers.ProcessSetting("TimerSize")
    end
	ankh.button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    ankh.deactivate = function(self)
        XiTimers.deactivate(self)
        TotemTimers.ProcessSetting("TimerSize")
    end
    ankh.button.cooldown.noCooldownCount = true
    ankh.button.cooldown.noOCC = true
		
	local shield = XiTimers:new(1)
	shield.button.icons[1]:SetTexture(SpellTextures[SpellIDs.LightningShield])
	shield.button.anchorframe = TotemTimers_TrackerFrame
	shield.button:SetScript("OnEvent", TotemTimers.ShieldEvent)
	shield.events[1] = "UNIT_SPELLCAST_SUCCEEDED"
	shield.events[2] = "UNIT_AURA"
	shield.timeStyle = "blizz"
	shield.activate = function(self)
        XiTimers.activate(self)
        TotemTimers.ShieldEvent(self.button, "UNIT_AURA")
        if not TotemTimers.ActiveSpecSettings.ShieldTracker then
            self.button:Hide()
        end
      end
	shield.button:SetAttribute("*type*", "spell")
    shield.button:SetAttribute("*unit*", "player")
	shield.button:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp")
	
	local earthshield = XiTimers:new(1)
	earthshield.button.icons[1]:SetTexture(SpellTextures[SpellIDs.EarthShield])
	earthshield.button.anchorframe = TotemTimers_TrackerFrame
	earthshield.button:SetScript("OnEvent", TotemTimers.EarthShieldEvent)
	earthshield.events[1] = "UNIT_SPELLCAST_SUCCEEDED"
	earthshield.events[2] = "COMBAT_LOG_EVENT_UNFILTERED"
	earthshield.events[3] = "UNIT_AURA"
	earthshield.events[4] = "PARTY_MEMBER_CHANGED"
	earthshield.events[5] = "RAID_ROSTER_UPDATE"
	earthshield.events[6] = "PLAYER_REGEN_ENABLED"
    earthshield.events[7] = "PARTY_LEADER_CHANGED"
    earthshield.events[8] = "PLAYER_ENTERING_WORLD"
	earthshield.timeStyle = "blizz"
	earthshield.button:SetAttribute("*type*", "spell")
	earthshield.activate = function(self)
        XiTimers.activate(self)
        self.button:SetAttribute("*spell*", SpellNames[SpellIDs.EarthShield])
        if not TotemTimers_Settings.EarthShieldTracker then self.button:Hide() end
      end
	earthshield.button:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp", "Button4Up")
    earthshield.ManaCheck = SpellNames[SpellIDs.EarthShield]
    earthshield.nameframe = CreateFrame("Frame", earthshield.button)
    earthshield.nameframe:SetParent(earthshield.button)
    earthshield.nameframe:SetPoint("TOPLEFT", earthshield.button)
    earthshield.nameframe:SetPoint("BOTTOMRIGHT", earthshield.button)
    earthshield.name = earthshield.nameframe:CreateFontString("TotemTimers_EarthShieldName")
    earthshield.name:SetPoint("TOP", earthshield.nameframe)
    earthshield.name:SetFont(earthshield.button.hotkey:GetFont())
    earthshield.nameframe:SetFrameLevel(10)
    
    
    earthshield.stop = function(self,nr)
        XiTimers.stop(self,nr)
        if earthShieldTarget then
            self.name:SetText(splitString(earthShieldTarget))
        end
    end

    earthshield.start = function(self,nr, time, duration)
        XiTimers.start(self,nr, time, duration)
        if earthShieldTarget then
            self.name:SetText(splitString(earthShieldTarget))
        end
    end
    
   --earthshield.button.hotkey.SetText = function(self, text) print("SetText: "..tostring(text)) if not text or text == "" then print(debugstack()) end end
	
	local weapon = XiTimers:new(2)
	weapon.button.icons[1]:SetTexture(SpellTextures[SpellIDs.FlametongueWeapon])
	weapon.button.icons[2]:SetTexture(SpellTextures[SpellIDs.FlametongueWeapon])
	weapon.button.anchorframe = TotemTimers_TrackerFrame
	weapon.button:SetScript("OnEvent", TotemTimers.WeaponEvent)
	weapon.events[1] = "COMBAT_LOG_EVENT_UNFILTERED"
	weapon.events[2] = "UNIT_INVENTORY_CHANGED"
	weapon.events[3] = "CHARACTER_POINTS_CHANGED"
    weapon.events[5] = "UNIT_SPELLCAST_SUCCEEDED"
    weapon.events[6] = "UNIT_AURA"
	weapon.events[7] = "PLAYER_TALENT_UPDATE"
	weapon.timeStyle = "blizz"
	weapon.button:SetAttribute("*type*", "spell")
    weapon.button:SetAttribute("ctrl-spell1", ATTRIBUTE_NOOP)
    weapon.button:RegisterEvent("PLAYER_ALIVE")
	weapon.update = TotemTimers.WeaponUpdate
	weapon.button:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp")
    weapon.timerbars[1]:SetMinMaxValues(0,1800)
    weapon.timerbars[2]:SetMinMaxValues(0,1800)
	TotemTimers.SetNumWeaponTimers()
    weapon.flashall = true
    weapon.activate = function(self)
        XiTimers.activate(self)
        if not TotemTimers_Settings.WeaponTracker then self.button:Hide() end
      end
      
    weapon.button.HideTooltip =  TotemTimers.HideTooltip
    WeaponBar = TTActionBars:new(7, weapon.button, nil, TotemTimers_TrackerFrame, "weapontimer")
    weapon.bar = WeaponBar
    weapon.button.ShowTooltip = TotemTimers.WeaponButtonTooltip
    weapon.button.SaveLastEnchant = function(self, name)
                                        if name == "spell1" then TotemTimers.ActiveSpecSettings.LastWeaponEnchant = self:GetAttribute("spell1") 
                                        elseif name == "spell2" or name == "spell3" then 
                                            TotemTimers.ActiveSpecSettings.LastWeaponEnchant2 = self:GetAttribute("spell2") or self:GetAttribute("spell3")
                                        elseif name == "doublespell2" then
                                            local ds2 = self:GetAttribute("doublespell2")
                                            if ds2 then
                                                if ds2 == SpellNames[SpellIDs.FlametongueWeapon] then 
                                                    TotemTimers.ActiveSpecSettings.LastWeaponEnchant = 5
                                                elseif ds2 == SpellNames[SpellIDs.FrostbrandWeapon] then
                                                    TotemTimers.ActiveSpecSettings.LastWeaponEnchant = 6
                                                end
                                            end
                                        end
                                    end
    weapon.button:SetAttribute("_onattributechanged", [[ if name=="hide" then
                                                             control:ChildUpdate("show", false)
                                                             control:CallMethod("HideTooltip")
                                                         elseif name == "spell1" or name == "doublespell1" or name == "doublespell2" or name == "spell2" or name == "spell3"then
                                                             control:CallMethod("SaveLastEnchant", name)
                                                         elseif name == "state-invehicle" then
                                                            if value == "show" and self:GetAttribute("active") then
                                                                self:Show()
                                                            else
                                                                self:Hide()
                                                            end
                                                         end]])
    weapon.button:SetAttribute("_onenter", [[ if self:GetAttribute("tooltip") then control:CallMethod("ShowTooltip") end
                                              if self:GetAttribute("OpenMenu") == "mouseover" then
                                                  control:ChildUpdate("show", true)
                                              end ]])
	weapon.button:SetAttribute("_onleave", [[ control:CallMethod("HideTooltip") ]])
	weapon.button:WrapScript(weapon.button, "OnClick", [[ if button == self:GetAttribute("OpenMenu") then
                                                              local open = self:GetAttribute("open") 
                                                              control:ChildUpdate("show", not open)
															  self:SetAttribute("open", not open)
                                                          end]])
	weapon.button:WrapScript(weapon.button, "PostClick", [[ if button == "LeftButton" then
                                                                local ds1 = self:GetAttribute("doublespell1")
                                                                if ds1 then
                                                                    if IsControlKeyDown() or self:GetAttribute("ds") ~= 1 then
                                                                        self:SetAttribute("macrotext", "/cast "..ds1.."\n/use 16")
																		self:SetAttribute("ds",1)
                                                                    else
                                                                        self:SetAttribute("macrotext", "/cast "..self:GetAttribute("doublespell2").."\n/use 17")
																		self:SetAttribute("ds",2)
                                                                    end
                                                                end
                                                           end]])

    weapon.button:SetAttribute("ctrl-type1", "cancelaura")
    weapon.button:SetAttribute("ctrl-target-slot1", GetInventorySlotInfo("MainHandSlot"))
    weapon.button:SetAttribute("ctrl-type2", "cancelaura")
    weapon.button:SetAttribute("ctrl-target-slot2", GetInventorySlotInfo("SecondaryHandSlot"))
	weapon.button:SetScript("OnDragStop", function(self)
            XiTimers.StopMoving(self)
            if not InCombatLockdown() then self:SetAttribute("hide", true) end
            TotemTimers.ProcessSetting("WeaponBarDirection")
        end)
    weapon.nobars = true
    weapon.stop = function(self,timer)
        XiTimers.stop(self,timer)
        self.button.bar:Show()
    end
    weapon.button.bar:Show()
    
    --create maintank bar for es
    earthshield.bar = TTActionBars:new(4, earthshield.button, nil, TotemTimers_TrackerFrame)
    earthshield.button:SetAttribute("_onenter", [[ 
                                              if self:GetAttribute("OpenMenu") == "mouseover" then
                                                  control:ChildUpdate("show", true)
                                              end ]])
    earthshield.button:WrapScript(earthshield.button, "OnClick", [[ if button == self:GetAttribute("OpenMenu") then
                                                              local open = self:GetAttribute("open")
                                                              control:ChildUpdate("show", not open)
															  self:SetAttribute("open", not open)
                                                          end]])
                                                          
    earthshield.button:SetAttribute("_onattributechanged", [[ if name=="hide" then
                                                                 control:ChildUpdate("show", false)
                                                             elseif name == "state-invehicle" then
                                                                if value == "show" and self:GetAttribute("active") then
                                                                    self:Show()
                                                                else
                                                                    self:Hide()
                                                                end
                                                             end]])
    for i = 1,4 do
        earthshield.button:WrapScript(earthshield.bar.buttons[i], "PostClick", [[
                local p = self:GetParent()
                local nr = p:GetAttribute("RecastButton")
                if nr then
                    p:SetAttribute("*unit"..nr, self:GetAttribute("*unit1"))
                    control:CallMethod("UpdateESName")
                end
        ]])
    end
    earthshield.button.UpdateESName = function(self)
        if self.timer.timers[1]<=0 then
            local button = self:GetAttribute("RecastButton")
            if button then
                local unit = self:GetAttribute("*unit"..button)
                if unit and UnitExists(unit) then
                    self.timer.name:SetText(splitString(UnitName(unit)))
                end
            end
        end
    end
    
    TotemTimers.SetEarthShieldMainTankList()
    
    earthshield.button:SetScript("OnDragStop", function(self)
        XiTimers.StopMoving(self)
        TotemTimers.ProcessSetting("ESMainTankMenuDirection")
        TotemTimers.ProcessSetting("WeaponBarDirection")
        if not InCombatLockdown() then weapon.button:SetAttribute("hide", true) end
        if not InCombatLockdown() then earthshield.button:SetAttribute("hide", true) end
    end)
    weapon.button:SetScript("OnDragStop", earthshield.button:GetScript("OnDragStop"))
    shield.button:SetScript("OnDragStop", earthshield.button:GetScript("OnDragStop"))
    ankh.button:SetScript("OnDragStop", earthshield.button:GetScript("OnDragStop"))
end


function TotemTimers.SetEarthShieldButtons()
    local Settings = TotemTimers_Settings
    local recastbutton = nil
    local menubutton = nil
    earthShieldRecast = false
    Timers[7].button:SetAttribute("OpenMenu", nil)
    Timers[7].button:SetAttribute("RecastButton", nil)
    
    if Settings.EarthShieldLeftButton == "recast" then
        recastbutton = 1
        earthShieldRecast = true
        Timers[7].button:SetAttribute("*spell1", SpellIDs.EarthShield)
    elseif Settings.EarthShieldLeftButton == "menu" and not menubutton then
        menubutton = 1
        Timers[7].button:SetAttribute("*spell1", nil)
    else
        Timers[7].button:SetAttribute("*unit1", Settings.EarthShieldLeftButton)
        Timers[7].button:SetAttribute("*spell1", SpellIDs.EarthShield)
    end  
    
    if Settings.EarthShieldRightButton == "recast" then
        recastbutton = recastbutton or 2
        earthShieldRecast = true
        Timers[7].button:SetAttribute("*spell2", SpellIDs.EarthShield)
    elseif Settings.EarthShieldRightButton == "menu" and not menubutton then
        menubutton = menubutton or 2
        Timers[7].button:SetAttribute("*spell2", nil)
    else
        Timers[7].button:SetAttribute("*unit2", Settings.EarthShieldRightButton)
        Timers[7].button:SetAttribute("*spell2", SpellIDs.EarthShield)
    end
    
    if Settings.EarthShieldMiddleButton == "recast" then
        recastbutton = recastbutton or 3
        earthShieldRecast = true
        Timers[7].button:SetAttribute("*spell3", SpellIDs.EarthShield)
    elseif Settings.EarthShieldMiddleButton == "menu" and not menubutton then
        menubutton = menubutton or 3
        Timers[7].button:SetAttribute("*spell3", nil)
    else
        Timers[7].button:SetAttribute("*unit3", Settings.EarthShieldMiddleButton)
        Timers[7].button:SetAttribute("*spell3", SpellIDs.EarthShield)
    end
    
    if Settings.EarthShieldButton4 == "recast" then
        recastbutton = recastbutton or 4
        earthShieldRecast = true
        Timers[7].button:SetAttribute("*spell4", SpellIDs.EarthShield)
    elseif Settings.EarthShieldButton4 == "menu" and not menubutton then
        menubutton = menubutton or 4
        Timers[7].button:SetAttribute("*spell4", nil)
    else
        Timers[7].button:SetAttribute("*unit4", Settings.EarthShieldButton4)
        Timers[7].button:SetAttribute("*spell4", SpellIDs.EarthShield)
    end
    
    if not menubutton and Settings.ESMainTankMenu then
        Timers[7].button:SetAttribute("OpenMenu", "mouseover")
    end
    if menubutton then
        Timers[7].button:SetAttribute("OpenMenu", buttons[menubutton])
    end
    Timers[7].button:SetAttribute("RecastButton", recastbutton)
end


local MainTankUpdateTimer = 5
local MainTankListUpdateFrame = CreateFrame("Frame")
MainTankListUpdateFrame:Hide()
MainTankListUpdateFrame:SetScript("OnShow", function(self) MainTankUpdateTimer = 5 end)
MainTankListUpdateFrame:SetScript("OnUpdate", function(self,elapsed)
                                                MainTankUpdateTimer = MainTankUpdateTimer-elapsed
                                                if MainTankUpdateTimer <= 0 then
                                                    if InCombatLockdown() then 
                                                        MainTankUpdateTimer = 5
                                                    else
                                                        self:Hide()
                                                        TotemTimers.SetEarthShieldMainTankList()
                                                    end
                                                end
                                              end)


local function SetUnit(unit,button)
    button:SetAttribute("*unit1", unit)
    button.hotkey:SetText(splitString(UnitName(unit)))
    local _, class = UnitClass(unit)
    if class then 
        if RAID_CLASS_COLORS[class] then button.hotkey:SetTextColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b ) end
        button.icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
        button.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]))
    else
        MainTankListUpdateFrame:Show()
    end
end


function TotemTimers.SetEarthShieldMainTankList()
    local es = XiTimers.timers[7]
    es.bar:ResetSpells()
   -- es.bar:AddSpell(SpellIDs.EarthShield)
    --SetUnit("player",es.bar.buttons[1])
    if GetNumRaidMembers()>0 then
        local b = 0
        for i = 1,25 do
            local unit = "raid"..i
            if UnitExists(unit) then
                if (GetPartyAssignment("MAINTANK", unit) or UnitGroupRolesAssigned(unit) == "TANK") and b<4 then
                    b = b + 1
                    es.bar:AddSpell(SpellIDs.EarthShield)
                    SetUnit(unit, es.bar.buttons[b])
                end
            end
        end
        if b < 4 then
            es.bar:AddSpell(SpellIDs.EarthShield)
            SetUnit("player", es.bar.buttons[b+1]) 
        end
    elseif GetNumPartyMembers() > 0 then
        local b = 0
        for i = 1,4 do
            local unit = "party"..i
            if UnitGroupRolesAssigned(unit) == "TANK" then
                b = b+1
                es.bar:AddSpell(SpellIDs.EarthShield)
                SetUnit(unit, es.bar.buttons[i])
                break
            end
        end
        es.bar:AddSpell(SpellIDs.EarthShield)
        SetUnit("player", es.bar.buttons[b+1])        
    else
        es.bar:AddSpell(SpellIDs.EarthShield)
        SetUnit("player", es.bar.buttons[1])
    end
end

function TotemTimers.SetWeaponTrackerSpells()
    WeaponBar:ResetSpells()
    if  AvailableSpells[SpellIDs.WindfuryWeapon] then
        WeaponBar:AddSpell(SpellIDs.WindfuryWeapon)
    end
    if  AvailableSpells[SpellIDs.FlametongueWeapon] then
        WeaponBar:AddSpell(SpellIDs.FlametongueWeapon)
    end
    if  AvailableSpells[SpellIDs.EarthlivingWeapon] then
        WeaponBar:AddSpell(SpellIDs.EarthlivingWeapon)
    end
    if  AvailableSpells[SpellIDs.FrostbrandWeapon] then
        WeaponBar:AddSpell(SpellIDs.FrostbrandWeapon)
    end
    if AvailableSpells[SpellIDs.RockbiterWeapon] then
        WeaponBar:AddSpell(SpellIDs.RockbiterWeapon)
    end
    if  AvailableSpells[SpellIDs.WindfuryWeapon] and AvailableSpells[SpellIDs.FlametongueWeapon] then
        WeaponBar:AddDoubleSpell(SpellNames[SpellIDs.WindfuryWeapon],SpellNames[SpellIDs.FlametongueWeapon])       
    end    
    if  AvailableSpells[SpellIDs.WindfuryWeapon] and AvailableSpells[SpellIDs.FrostbrandWeapon] then
        WeaponBar:AddDoubleSpell(SpellNames[SpellIDs.WindfuryWeapon],SpellNames[SpellIDs.FrostbrandWeapon])        
    end    
end



local AnkhName = SpellNames[SpellIDs.Ankh]
local AnkhID = SpellIDs.Ankh

function TotemTimers.AnkhEvent(self, event)
	if not AvailableSpells[SpellIDs.Ankh] then return end
	if event=="BAG_UPDATE" then
		local ankhs = GetItemCount(17030)
		self.count:SetText(ankhs)
		if ankhs == 0 then
			self.icons[1]:SetVertexColor(0.5,0.5,1.0)
		else
			self.icons[1]:SetVertexColor(1.0,1.0,1.0)
		end
	else
		local start, duration, enable = GetSpellCooldown(AnkhID)
		if duration == 0 then
			self.timer:stop(1)
		elseif self.timer.timers[1]<=0 and duration>2 then
			self.timer:start(1,start+duration-floor(GetTime()),1800)
		end
	end
end

local shieldtable = {SpellNames[SpellIDs.LightningShield], SpellNames[SpellIDs.WaterShield], SpellNames[SpellIDs.EarthShield]}

function TotemTimers.ShieldEvent(self, event, unit)
	if event=="UNIT_SPELLCAST_SUCCEEDED" and unit=="player" then
		local start, duration, enable = GetSpellCooldown(SpellIDs.LightningShield)
		if start and duration and (not self.timer.timerOnButton or self.timer.timers[1]<=0) then
            CooldownFrame_SetTimer(self.cooldown, start, duration, enable)
        end
	elseif unit=="player" then
		self.count:SetText("")
		local name, texture, count, duration, endtime
		for _, shield in pairs(shieldtable) do
			if not name then
				name,_,texture,count,_,duration,endtime = UnitBuff("player", shield)
			end
		end	
		if name then
			local timeleft = endtime - GetTime()
			if name ~= self.shield or timeleft>self.timer.timers[1] then
				self.icons[1]:SetTexture(texture)
				self.timer:start(1, timeleft, duration)
				self.timer.expirationMsgs[1] = "Shield"
				self.timer.earlyExpirationMsgs[1] = "Shield"
                self.timer.WarningIcons[1] = texture
                self.timer.WarningSpells[1] = name
                self.shield = name
			end
			self.count:SetText(count)
		elseif self.timer.timers[1]>0 then
			self.timer:stop(1)
		end
	end  
end

local ButtonPositions = {
	["box"] = {{"CENTER",0,"CENTER"},{"LEFT",1,"RIGHT"},{"TOP",2,"BOTTOM"},{"LEFT",1,"RIGHT"}},
	["horizontal"] = {{"CENTER",0,"CENTER"},{"LEFT",1,"RIGHT"},{"LEFT",1,"RIGHT"},{"LEFT",1,"RIGHT"}},
	["vertical"] = {{"CENTER",0,"CENTER"},{"TOP",1,"BOTTOM"},{"TOP",1,"BOTTOM"},{"TOP",1,"BOTTOM"}}	
}

local TrackerOptions = {
    [5] = "AnkhTracker",
    [6] = "ShieldTracker",
    [7] = "EarthShieldTracker",
    [8] = "WeaponTracker",
}

function TotemTimers_OrderTrackers()
	local arrange = TotemTimers_Settings.TrackerArrange
    for e=5,8 do
		Timers[e]:ClearAnchors()
		Timers[e].button:ClearAllPoints()
	end
    if arrange == "free" then
        for i=5,8 do
            Timers[i].savePos = true
            local pos = TotemTimers.ActiveSpecSettings.TimerPositions[i]            
            if not pos or not pos[1] then pos = {"CENTER", "UIParent", "CENTER", 0,0} end
            Timers[i].button:ClearAllPoints()
            Timers[i].button:SetPoint(pos[1], pos[2], pos[3], pos[4], pos[5])
        end
    else
    	local counter = 0
    	local buttons = {}
    	for i=5,8 do
            Timers[i].savePos = false
    		--if Timers[i].active then
            if Timers[i].button:IsVisible() then
    			counter = counter + 1
    			if counter == 1 then
    				Timers[i]:SetPoint(ButtonPositions[arrange][1][1], TotemTimers_TrackerFrame, ButtonPositions[arrange][1][3])
    			else
    				Timers[i]:Anchor(buttons[counter-ButtonPositions[arrange][counter][2]], ButtonPositions[arrange][counter][1])	
    			end
    			buttons[counter] = Timers[i]
    		end
    	end
    end
	TotemTimers.ProcessSetting("WeaponBarDirection")
end


function TotemTimers.ChangeEarthShieldTarget()
    for k,v in pairs(buttons) do
		if TotemTimers_Settings["EarthShield"..v] == "recast" then
            Timers[7].button:SetAttribute("*unit"..k, earthShieldTarget)
            --[[if earthShieldTarget == playerName then
                Timers[7].button:SetAttribute("*unit"..k, "player")
                break
            end
			for i = 1,4 do               
				if UnitExists("party"..i) then
                    local n,s = UnitName("party"..i)
                    if s and s~= "" then n = n.."-"..s end
                    if n == earthShieldTarget then
                        Timers[7].button:SetAttribute("*unit"..k, "party"..i)
                        break
                    end
				end
			end
			for i = 1,GetNumRaidMembers() do
				local n,s = UnitName("raid"..i)
                if s and s~= "" then n = n.."-"..s end
                if n == earthShieldTarget then
					Timers[7].button:SetAttribute("*unit"..k, "raid"..i)
					break
				end
			end
			break]]
		end
	end
end


local EarthShieldSpellName = SpellNames[SpellIDs.EarthShield]

local ESChargesOnly = false

local function checkESBuff(self)
    local name,_,_,count,_,duration,endtime = UnitBuff(earthShieldTarget, EarthShieldSpellName)
    if count then
        local timeleft = endtime - GetTime()
        if not ESChargesOnly then self.count:SetText(count) end
        if timeleft-self.timer.timers[1] > 0.1  then
            if not ESChargesOnly then
                self.timer:start(1, timeleft, duration)
                self.timer.expirationMsgs[1] = "EarthShield"
                self.timer.earlyExpirationMsgs[1] = "EarthShield"
                self.timer.WarningIcons[1] = SpellTextures[SpellIDs.EarthShield]
                self.timer.WarningSpells[1] = SpellNames[SpellIDs.EarthShield]
            else
                self.timer:start(1,count,9)
            end
        end
    elseif self.timer.timers[1] > 0 then
        self.timer:stop(1)
        self.count:SetText("")
    end
end


function TotemTimers.EarthShieldEvent(self, event, ...)
	if not AvailableSpells[SpellIDs.EarthShield] then return end
	local unit,spellcast,_,_,caster,_,_,_,target,_,_,_,spell = ...
	if event == "COMBAT_LOG_EVENT_UNFILTERED" and spellcast=="SPELL_CAST_SUCCESS" and caster == playerName and spell == EarthShieldSpellName then
        earthShieldTarget = target
        if earthShieldRecast then
            if not InCombatLockdown() then
                TotemTimers.ChangeEarthShieldTarget()
            else
                changeEarthShieldRecast = true
            end
        end
        checkESBuff(self)
	elseif event=="UNIT_SPELLCAST_SUCCEEDED" and select(1,...) == "player" then
		local start, duration, enable = GetSpellCooldown(EarthShieldSpellName)
		if start and duration and (not self.timer.timerOnButton or self.timer.timers[1]<=0) then
            CooldownFrame_SetTimer(self.cooldown, start, duration, enable)
        end
	elseif event == "UNIT_AURA" and earthShieldTarget then
        local t,s = UnitName(unit, true)
        if s and s ~= "" then t = t.."-"..s end
        if t == earthShieldTarget then
            checkESBuff(self)
        end
	elseif event == "PLAYER_REGEN_ENABLED" and earthShieldRecast and changeEarthShieldRecast then
		TotemTimers.ChangeEarthShieldTarget()
	elseif (event == "PARTY_MEMBERS_CHANGED" or event == "RAID_ROSTER_UPDATE" or event == "PARTY_LEADER_CHANGED" or event == "PLAYER_ENTERING_WORLD") then
        if earthShieldRecast and earthShieldTarget then
            if InCombatLockdown() then
                changeEarthShieldTarget = true
            else
                TotemTimers.ChangeEarthShieldTarget()
            end
        end
        if not InCombatLockdown() then
            TotemTimers.SetEarthShieldMainTankList()
        else
            MainTankListUpdateFrame:Show()
        end
	end
end

local function EmptyESUpdate()
end

function TotemTimers.SetEarthShieldUpdate()
    ESChargesOnly = TotemTimers_Settings.ESChargesOnly
    if TotemTimers_Settings.ESChargesOnly then
        Timers[7].update = EmptyESUpdate
        Timers[7].prohibitCooldown = true
        Timers[7].timeStyle = "sec"
    else
        Timers[7].update = nil
        Timers[7].prohibitCooldown = false
        Timers[7].timeStyle = "blizz"
    end
end

local mainMsg = ""
local offMsg = ""

local GetWeaponEnchantInfo = GetWeaponEnchantInfo

local Enchanted, CastEnchant, CastTexture


local function SetWeaponEnchantTextureAndMsg(self, enchant, texture, nr)
    if nr == 1 then TotemTimers_Settings.LastMainEnchants[mainHandWeapon] = {enchant, texture}
    else TotemTimers_Settings.LastOffEnchants[offHandWeapon] = {enchant, texture} end
    self.icons[nr]:SetTexture(texture)
    self.timer.WarningIcons[nr] = texture
    self.timer.WarningSpells[nr] = enchant
    self.timer.expirationMsgs[nr] = "Weapon"
end

function TotemTimers.WeaponUpdate(self, elapsed)
	local enchant, expiration, _, oenchant, oexpiration = GetWeaponEnchantInfo()
    if enchant then
        if expiration/1000 > self.timers[1] then
            self:start(1, expiration/1000, 1800)
            if Enchanted then
                Enchanted = nil
                SetWeaponEnchantTextureAndMsg(self.button, CastEnchant, CastTexture, 1)
            end
        end
        if expiration == 0 then
            self:stop(1)
        else
            self.timers[1] = expiration/1000
        end
    elseif self.timers[1] > 0 then
        self:stop(1)
    end
    if oenchant then
        if oexpiration/1000 > self.timers[2] then
            self:start(2, oexpiration/1000, 1800)
            if Enchanted then
                Enchanted = nil
                SetWeaponEnchantTextureAndMsg(self.button, CastEnchant, CastTexture, 2)
            end
        end
        self.timers[2] = oexpiration/1000
        if oexpiration == 0 then
            self:stop(2)
        end
    elseif self.timers[2] > 0 then
        self:stop(2)
    end
    XiTimers.update(self, 0)
end

local function getWeapons()
	lastMhWeapon = mainHandWeapon
	lastOhWeapon = offHandWeapon
	mainHandWeapon = GetInventoryItemLink("player", 16)
	offHandWeapon = GetInventoryItemLink("player", 17)
	if mainHandWeapon then  mainHandWeapon = tonumber(select(3,string.find(mainHandWeapon, "item:(%d+):"))) else mainHandWeapon = 0 end
	if offHandWeapon then offHandWeapon = tonumber(select(3,string.find(offHandWeapon, "item:(%d+):"))) else offHandWeapon = 0 end
    TotemTimers.MainHand = mainHandWeapon
    TotemTimers.OffHand = offHandWeapon
end


local lastMaelstromCount = 0
local WeaponBuffs = {SpellNames[SpellIDs.WindfuryWeapon], SpellNames[SpellIDs.RockbiterWeapon],
    SpellNames[SpellIDs.FlametongueWeapon], SpellNames[SpellIDs.FrostbrandWeapon], SpellNames[SpellIDs.EarthlivingWeapon]}
local lastWeaponBuffCast

function TotemTimers.WeaponEvent(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _,eventtype,_,_,_,_,_,_,name,_,_,enchant,weapon = ...
		if eventtype == "ENCHANT_APPLIED" and name == playerName and enchant then
			getWeapons() 
            CastEnchant = enchant
            if lastWeaponBuffCast then
                CastTexture = GetSpellTexture(lastWeaponBuffCast)
            end
            lastWeaponBuffCast = nil
			if not CastTexture then
				CastTexture = select(10,GetItemInfo(enchant))
				if not CastTexture then CastTexture = select(10, GetItemInfo(weapon)) end
			end
            Enchanted = true
		end
	elseif event == "UNIT_INVENTORY_CHANGED" then
		getWeapons()
		if mainHandWeapon ~= lastMhWeapon and mainHandWeapon ~= 0 then
			local enchant, texture 
			if not TotemTimers_Settings.LastMainEnchants[mainHandWeapon] then
				enchant = ""
                texture = SpellTextures[SpellIDs.FlametongueWeapon]
			else
                enchant = TotemTimers_Settings.LastMainEnchants[mainHandWeapon][1]
                texture = TotemTimers_Settings.LastMainEnchants[mainHandWeapon][2]
            end
            SetWeaponEnchantTextureAndMsg(self, enchant, texture, 1)
		end
		if offHandWeapon ~= lastOhWeapon and offHandWeapon ~= 0 then
			local enchant, texture 
			if not TotemTimers_Settings.LastOffEnchants[offHandWeapon] then
				enchant = ""
                texture = SpellTextures[SpellIDs.FlametongueWeapon]
			else
                enchant = TotemTimers_Settings.LastOffEnchants[offHandWeapon][1]
                texture = TotemTimers_Settings.LastOffEnchants[offHandWeapon][2]
            end
            SetWeaponEnchantTextureAndMsg(self, enchant, texture, 2)
        end
	elseif event == "CHARACTER_POINTS_CHANGED" or event == "PLAYER_ALIVE" or event == "PLAYER_TALENT_UPDATE" then
		TotemTimers.SetNumWeaponTimers()
        if event == "PLAYER_ALIVE" then
            Timers[8].button:UnregisterEvent("PLAYER_ALIVE")
        end
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" and select(1,...) == "player" then
        local spell = select(2, ...)
        for k,v in pairs(WeaponBuffs) do
            if v == spell then
                lastWeaponBuffCast = v
            end
        end
        local start, duration, enable = GetSpellCooldown(SpellNames[SpellIDs.WindfuryWeapon])
		if start and duration and (not self.timer.timerOnButton or self.timer.timers[1]<=0) then
            CooldownFrame_SetTimer(self.cooldown, start, duration, enable) 
        end
    elseif event == "UNIT_AURA" and select(1,...) == "player" then
        local name,_,_,count,_,duration,endtime = UnitBuff("player", SpellNames[SpellIDs.Maelstrom])
        self.bar:SetValue(count or 0)
        self.count:SetText(tostring(count or ""))
        if count == 5 and lastMaelstromCount ~= 5 then
            self.timer:PlayWarning("Maelstrom")
        end
        lastMaelstromCount = count or lastMaelstromCount
	end
end
