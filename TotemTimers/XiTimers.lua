-- Copyright © 2008, 2009 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.
-- Current distribution permissions only include curse.com, wowui.worldofwar.net, wowinterface.com and their respective addon updaters

local version = 100
if XiTimers and XiTimers.version > version then return end

XiTimers = {}
XiTimers.timers = {}
XiTimers.numtimers = 0
XiTimers.__index = XiTimers

local inActiveAlpha = 0.4


TotemTimers.timers = XiTimers


local Timers = XiTimers.timers
local _G = getfenv()

local incombat = false


local function FormatTime(frame, sec, format)
	local seconds = floor(sec)

 	if format == "blizz" then
		frame:SetFormattedText(SecondsToTimeAbbrev(sec))
    elseif format == "sec" then
        seconds = floor(sec+0.5)
        if seconds == 0 then seconds = "" end
        frame:SetFormattedText(tostring(seconds))
	else
		if(seconds <= 0) then
			frame:SetText("")
		elseif seconds < 600 then
			local d, h, m, s = ChatFrame_TimeBreakDown(seconds)
			frame:SetFormattedText("%01d:%02d", m, s)
		elseif(seconds < 3600) then
			local d, h, m, s = ChatFrame_TimeBreakDown(seconds);
			frame:SetFormattedText("%02d:%02d", m, s)
		else
			frame:SetText("1 hr+")
		end
	end
end


local function SetButtonTime(fontstring, sec)
    if sec > 600 then
        FormatTime(fontstring, sec, "blizz")
    elseif sec > 60 then
        FormatTime(fontstring, sec)
    else
        FormatTime(fontstring, sec, "sec")
    end
end

function XiTimers.UpdateTimers(self,elapsed) 
    for i=1,XiTimers.numtimers do
        if Timers[i].active then Timers[i]:update(elapsed) end
    end
end


function XiTimers:new(nroftimers, unclickable)
	local self = {}
	setmetatable(self, XiTimers)
	XiTimers.numtimers = XiTimers.numtimers + 1
    self.nr = XiTimers.numtimers
	self.active = false
    self.unclickable = unclickable
	if unclickable then
        self.button = CreateFrame("CheckButton", "XiTimers_Timer"..XiTimers.numtimers, UIParent, "XiTimersUnsecureTemplate")
    else
        self.button = CreateFrame("CheckButton", "XiTimers_Timer"..XiTimers.numtimers, UIParent, "XiTimersTemplate")
    end
	self.button:SetPoint("CENTER", UIParent, "CENTER")
	self.button.timer = self
	
	--for rActionButtonStyler
	self.button.action = 0 
    self.button:SetCheckedTexture(nil)
	self.button.SetCheckedTexture = function() end
    self.button.SetChecked = function() end
    self.button.GetChecked = function() return false end
    self.button.SetDisabledCheckedTexture = function() end
    
	if not IsAddOnLoaded("rActionButtonStyler") then
		self.button:SetNormalTexture(nil)
	else
		ActionButton_Update(self.button)
	end
	
	self.button.unclickable = unclickable
	self.button.element = XiTimers.numtimers
    
	
	self.numtimers = nroftimers
	self.timers = {}
    self.durations = {}
    for i=1, nroftimers do self.timers[i] = 0 end
    self.bordertimer = 0
    self.borderduration = 0
	self.timerbars = {}
	self.button.icons = {}
	self.button.flash = {}
	for i=1,nroftimers do
		self.timers[i] = 0
		self.timerbars[i] = CreateFrame("StatusBar", "XiTimers_TimerBar"..XiTimers.numtimers.."_"..i, self.button, "XiTimersTimerBarTemplate")
        self.timerbars[i].background = _G["XiTimers_TimerBar"..XiTimers.numtimers.."_"..i.."Background"]
        self.timerbars[i].time = _G["XiTimers_TimerBar"..XiTimers.numtimers.."_"..i.."Time"]
        self.timerbars[i].icon = _G["XiTimers_TimerBar"..XiTimers.numtimers.."_"..i.."Icon"]
        self.timerbars[i]:SetPoint("TOP", self.button, "BOTTOM")
		self.button.icons[i] = _G["XiTimers_Timer"..XiTimers.numtimers.."Icon"..((i>1) and i or "")]
		self.button.flash[i] = _G["XiTimers_Timer"..XiTimers.numtimers.."Flash"..((i>1) and i or "")]
        if self.button.flash[i] then
            local flash = self.button.flash[i]
            flash.Animation = self.button.flash[i]:CreateAnimationGroup()
            flash.Animation:SetLooping("NONE")
            flash.FlashAnim = flash.Animation:CreateAnimation()
            flash.FlashAnim:SetDuration(15)
            flash.FlashAnim.flash = flash
            flash.FlashAnim:SetScript("OnPlay", function(self) self.flash:Show() end)
            flash.FlashAnim:SetScript("OnFinished", function(self) self.flash:Hide() end)
            flash.FlashAnim:SetScript("OnStop", function(self) self.flash:Hide() end)
            flash.FlashAnim:SetScript("OnUpdate", function(self) self.flash:SetAlpha(BuffFrame.BuffAlphaValue) end)
        end
        if self.button.icons[i] then
            local flash = self.button.icons[i]
            flash.Animation = self.button.flash[i]:CreateAnimationGroup()
            flash.Animation:SetLooping("NONE")
            flash.FlashAnim = flash.Animation:CreateAnimation()
            flash.FlashAnim:SetDuration(15)
            flash.FlashAnim.flash = flash
            flash.FlashAnim:SetScript("OnPlay", function(self) self.flash:Show() end)
            flash.FlashAnim:SetScript("OnUpdate", function(self) self.flash:SetAlpha(BuffFrame.BuffAlphaValue) end)
        end
		self:SetIconAlpha(self.button.icons[i], 0.4)
	end
    self.timeColor = {r=1,g=1,b=1}
	self.button.icons[1]:Show()
	self.timerBarPos = "BOTTOM"
	self.timeSpacing = 0
	self.spacing = 5
	self.timeStyle = "mm:ss"
    self.OOCAlpha = 1
	self.warningMsgs = {}
    self.WarningSpells = {}
	self.expirationMsgs = {}
	self.earlyExpirationMsgs = {}
    self.WarningIcons = {}
	self.events = {}
	self.button.count = _G["XiTimers_Timer"..XiTimers.numtimers.."Count"]
	self.button.cooldown = _G["XiTimers_Timer"..XiTimers.numtimers.."Cooldown"]
	self.button.miniIcon = _G["XiTimers_Timer"..XiTimers.numtimers.."MiniIcon"]
    self.button.miniIconFrame = _G["XiTimers_Timer"..XiTimers.numtimers.."Mini"]
    self.button.bar = _G["XiTimers_Timer"..XiTimers.numtimers.."Bar"]
    self.button.hotkey = _G["XiTimers_Timer"..XiTimers.numtimers.."HotKey"]
    self.button.playerdot = _G["XiTimers_Timer"..XiTimers.numtimers.."PlayerBuff"]
    self.button.RangeCount = _G["XiTimers_Timer"..XiTimers.numtimers.."RangeCount"]
    self.button.BorderBar = _G["XiTimers_Timer"..XiTimers.numtimers.."BorderBar"]
    self.button.BorderBar:SetFrameLevel(0)
    local frame = CreateFrame("Frame", nil, self.button)
    frame:Show()
    frame:SetAllPoints(self.button)
    self.button.time = frame:CreateFontString(self.button:GetName().."Time", 'OVERLAY')
    self.button.time:SetPoint("CENTER",0,1)
    self.button.time:SetFont("Fonts\\FRIZQT__.TTF", 17, "OUTLINE")
    frame:SetFrameLevel(frame:GetFrameLevel()+10)
    self.button.time:Hide()
    --self.button.cooldown:SetFrameLevel(self.button.cooldown:GetFrameLevel()-1)
    self.button.cooldown.noCooldownCount = true
    self.button.cooldown.noOCC = true
    self.RangeCheckCount = 0
    self.ManaCheckCount = 0
    self.button.bar:Hide()
    
    self.Animation = XiTimersAnimations:new(self.button)
    
	self.anchors = {}
	self.anchorchilds = {}
	
	--self.button:SetScript("OnDragStart", XiTimers.StartMoving)
	self.button:SetScript("OnDragStop", XiTimers.StopMoving)
    self.button:SetAttribute("_ondragstart", [[control:CallMethod("StartMove")]])
    --self.button:SetAttribute("_ondragstop", [[control:CallMethod("StopMoving")]])
    self.button.StartMove = XiTimers.StartMoving
    self.button.StopMove = XiTimers.StopMoving
	self.button:RegisterForDrag("LeftButton")
    
	table.insert(Timers, self)

    self.button:SetAttribute("_onattributechanged", [[ 
        if name=="state-invehicle" then
            if value == "show" and self:GetAttribute("active") then
                self:Show()
            else
                self:Hide()
            end
        end
        ]])

    self.button:Hide()
	return self
end

-- timer functions
local IsSpellInRange = IsSpellInRange
local IsUsableSpell = IsUsableSpell

function XiTimers:update(elapsed)
	local timers = self.timers
	for i=1,self.numtimers do
		if timers[i] > 0 then
			timers[i] = timers[i] - elapsed
			if timers[i] <= 0 then
				self:stop(i) 
			else
				if timers[i]<10 and self.warningMsgs[i] then
					self:PlayWarning(self.warningMsgs[i], self.WarningSpells[i], self.WarningIcons[i])
					self.warningMsgs[i] = nil
				end
                if i > 1 or not self.timerOnButton then
                    if timers[i] >= 600 then
                        FormatTime(self.timerbars[i].time, timers[i], "blizz")
                    else
                        FormatTime(self.timerbars[i].time, timers[i], self.timeStyle)
                    end
                else
                    SetButtonTime(self.button.time, timers[1])
                end
				if self.visibleTimerBars and (not self.timerOnButton or i>1) then
					self.timerbars[i]:SetValue(timers[i])
				end
                if i == 1 then
                    if not self.isAnimating and timers[i] <= 10 and timers[i] > 0 then
                        self.isAnimating = true
                        if not self.dontFlash then
                            if self.FlashRed and self.button.flash[i] then
                                self.button.flash[i].Animation:Play()
                            elseif self.button.icons[i] then
                                self.button.icons[i].Animation:Play()
                            end
                        end
                    end 
                    if self.nr < 8 and self.timers[1] <= 10 then self.button.time:SetTextColor(1,0,0) end
                    if self.ProcFlash and timers[1] > 0 and self.bar then
                        self.button.bar:SetValue(self.bar - mod(timers[1], self.bar))
                    end
                end
			end
		end
	end
    
    if self.bordertimer > 0 then
        self.bordertimer = self.bordertimer - elapsed
        self.button.BorderBar:SetValue(self.bordertimer/self.borderduration*100)
    end

    --self.button.icons[1]:SetVertexColor(1,1,1)
    --if not self.unclickable then self.button.miniIcon:SetVertexColor(1,1,1) end
    if self.RangeCheck then
        self.RangeCheckCount = self.RangeCheckCount + 1
        if self.RangeCheckCount > 8 then
            self.RangeCheckCount = 0
            self.outofrange = IsSpellInRange(self.RangeCheck) == 0
            if self.outofrange then
                self.button.icons[1]:SetVertexColor(1,0,0)
            else
                self.button.icons[1]:SetVertexColor(1,1,1)
            end
        end
    end
    if self.ManaCheck then
        self.ManaCheckCount = self.ManaCheckCount + 1
        if self.ManaCheckCount > 8 then
            self.ManaCheckCount = 0
            local _,nomana = IsUsableSpell(self.ManaCheck)
            if nomana then
                if self.ManaCheckMini then
                    self.button.miniIcon:SetVertexColor(0.5,0.5,1)
                else
                    self.button.icons[1]:SetVertexColor(0.5,0.5,1)
                end
            else
                if self.ManaCheckMini then
                    self.button.miniIcon:SetVertexColor(1,1,1)
                else
                    if self.outofrange then
                        self.button.icons[1]:SetVertexColor(1,0,0)
                    else
                        self.button.icons[1]:SetVertexColor(1,1,1)
                    end
                end
            end
        end
    end
end


function XiTimers:activate()
	self.active = true
	for _,event in pairs(self.events) do
		self.button:RegisterEvent(event)
	end
	if not self.hideInactive and (not self.HideOOC or InCombatLockdown()) and not self.ActiveWhileHidden then
        self.button:Show()
        self.button:SetAttribute("active", true)
    end
    if self.ActiveWhileHidden then self.button:Hide() self.button:SetAttribute("active", false) end
end

function XiTimers:deactivate()
	self.active = false
	for _,event in pairs(self.events) do
		self.button:UnregisterEvent(event)
	end
	self.button:Hide()
    self.button:SetAttribute("active", false)
end

function XiTimers:start(timer, time, duration)
	duration = duration or time
    self.durations[timer] = duration
	local timerbar = self.timerbars[timer]
	self.timers[timer] = time
	FormatTime(timerbar.time, time, self.timeStyle)
    FormatTime(self.button.time, time, self.timeStyle)
	timerbar:SetMinMaxValues(0, duration)
    if (timer > 1 and (not self.nobars or (self.nobars and not self.timerOnButton))) then
        self:ShowTimerBar(timer)
    else
        self:HideTimerBar(timer)
    end        
        
	if self.visibleTimerBars and (timer>1 or not self.timerOnButton) then
		timerbar:SetValue(time)
	end
	if not self.dontAlpha then self:SetIconAlpha(self.button.icons[timer], 1) end
    if self.reverseAlpha then self:SetIconAlpha(self.button.icons[timer], 0.4) end
    if timer == 1 then
        if not self.timerOnButton then
            self.button.time:Hide()
            self:ShowTimerBar(timer)
        else
            self:HideTimerBar(timer)
            self.button.time:Show()
            self.button.time:SetTextColor(self.timeColor.r,self.timeColor.g,self.timeColor.b)
        end
        if (self.showCooldown or self.timerOnButton) and not self.prohibitCooldown then
            CooldownFrame_SetTimer(self.button.cooldown, GetTime()-duration+time, duration, 1)
        else
            self.button.cooldown:Hide()
        end
        if self.ProcFlash then
            self.button.bar:Show()
            self.button.bar:SetValue(0)
        end
    end
    if self.button.flash[timer] then self.button.flash[timer].Animation:Stop() end
    self.isAnimating = false
    self.FlashRed = TotemTimers_Settings.FlashRed
    self.button.bar:SetValue(0)
    self:SetTimerBarPos(self.timerBarPos, true)
    if timer == 1 and self.hideInactive then
        self.button:Show()
    end
end

function XiTimers:startborder(time, duration)
    self.borderduration = duration or time
    self.bordertimer = time
    self.button.BorderBar:SetValue(time/duration*100)
end

function XiTimers:stopborder()
    self.bordertimer = 0
    self.button.BorderBar:SetValue(0)
end

function XiTimers:stop(timer)
	local timerbar = self.timerbars[timer]
    if not self.StopQuiet then
        if self.timers[timer]>1 then
            if self.earlyExpirationMsgs[timer] then
                self:PlayWarning(self.earlyExpirationMsgs[timer], self.WarningSpells[timer], self.WarningIcons[timer])
                self.earlyExpirationMsgs[timer] = nil
            end
        elseif self.expirationMsgs[timer] then
            self:PlayWarning(self.expirationMsgs[timer], self.WarningSpells[timer], self.WarningIcons[timer])
            self.expirationMsgs[timer] = nil
        end
        if self.StopPulse and timer == 1 then
            self.Animation:SetTexture(self.button.icons[1]:GetTexture())
            self.Animation:Play()
        end
    end
    self.StopQuiet = false
	self.timers[timer] = 0
	timerbar.time:SetText("")
	if self.visibleTimerBars then		
		timerbar:SetValue(0)
	end
    self:HideTimerBar(timer)
    if timer == 1 then
        self.button.time:Hide()
        self.button.cooldown:Hide()
        self.button.bar:Hide()
    end
    if not self.dontAlpha then self:SetIconAlpha(self.button.icons[timer], 0.4) end
    if self.reverseAlpha then self:SetIconAlpha(self.button.icons[timer],1) end
    if self.ProcFlash and timer == 1 then 
        self.bar = nil
        self.button.bar:SetValue(0)
    end
    self.button.playerdot:Hide()
    self:SetTimerBarPos(self.timerBarPos, true)
    if timer == 1 and self.hideInactive then
        self.button:Hide()
    end
end


function XiTimers:StartMoving()
    if self.timer.locked then return end
	if self.anchorframe and not self.timer.savePos then
		self.anchorframe:StartMoving()
	else
		self:StartMoving() 
	end
end

function XiTimers:StopMoving()
	if self.anchorframe and not self.timer.savePos then
		self.anchorframe:StopMovingOrSizing()
	else
		self:StopMovingOrSizing()
	end
    if XiTimers.SaveFramePositions then XiTimers.SaveFramePositions() end
    self.timer:SetTimerBarPos(self.timer.timerBarPos, true)
end

function XiTimers:SetIconAlpha(icon, alpha)
    if icon then
        icon:SetAlpha(alpha)
    end
end

function XiTimers:SetAlpha(alpha)
    self.button:SetAlpha(alpha)
end

function XiTimers:HideTimerBar(nr)
	self.timerbars[nr].background:Hide()
    self.timerbars[nr].background:SetValue(0)
    ---self.timerbars[nr].icon:Hide()
    self.timerbars[nr]:Hide()
end

function XiTimers:ShowTimerBar(nr)
    self.timerbars[nr]:Show()
	if self.visibleTimerBars then
        self.timerbars[nr].background:Show()
        self.timerbars[nr].background:SetValue(1)
    end
end

-- display functions

function XiTimers:SetTimerBarPos(side, notReanchor)
	self.timerBarPos = side
	
	local timerbars = self.timerbars
	local numtimers = self.numtimers
		
	for i=1, numtimers do
		timerbars[i]:ClearAllPoints()
        timerbars[i].icon:ClearAllPoints()
	end
    if side == "RIGHT" then
        for i=2,numtimers do
            timerbars[i].icon:SetPoint("LEFT", timerbars[i], "RIGHT", -4, 0)
        end
    else
        for i=2,numtimers do
            timerbars[i].icon:SetPoint("RIGHT", timerbars[i], "LEFT", 4, 0)
        end
    end
    local activetimers = 1
	if side == "LEFT" then
        local lastactive = 1
		for i=2,numtimers do
            timerbars[i]:SetPoint("TOP", timerbars[lastactive], "BOTTOM") -- set all, but only active ones will be seen so they can lay atop one another
            if self.timers[i] > 0 then
                lastactive = i
                activetimers = activetimers + 1
            end
		end
		timerbars[1]:SetPoint("RIGHT", self.button, "LEFT", -self.timeSpacing, timerbars[1]:GetHeight()*timerbars[1]:GetEffectiveScale()/2*(activetimers-1))
	elseif side == "RIGHT" then
        local lastactive = 1
		for i=2,numtimers do
            timerbars[i]:SetPoint("TOP", timerbars[lastactive], "BOTTOM")
            if self.timers[i] > 0 then
                lastactive = i
                activetimers = activetimers + 1
            end
		end
		timerbars[1]:SetPoint("LEFT", self.button, "RIGHT", self.timeSpacing, timerbars[1]:GetHeight()*timerbars[1]:GetEffectiveScale()/2*(activetimers-1))
	elseif side == "TOP" then
        if TotemTimers_Settings.ShowCooldowns and self.nr < 5 and (TotemTimers_Settings.Arrange == "vertical" or TotemTimers_Settings.Arrange == "box") then
            timerbars[1]:SetPoint("BOTTOM", self.button, "TOP", 0, self.timeSpacing)
            local active = 0
            local firstactive = 0
            for i = 2, numtimers do
                if self.timers[i] > 0 then
                    active = active + 1
                    if firstactive == 0 then firstactive = i end
                end
            end
            if active > 0 then
                local left = self.button:GetLeft() < WorldFrame:GetWidth()/2
                if TotemTimers_Settings.Arrange == "box" and self.actnr then
                    left = self.actnr == 2 or self.actnr == 4
                end
                for i=2, numtimers do
                    timerbars[i].icon:ClearAllPoints()
                    if left then
                        timerbars[i].icon:SetPoint("LEFT", timerbars[i], "RIGHT", -4, 0)
                    else
                        timerbars[i].icon:SetPoint("RIGHT", timerbars[i], "LEFT", 4, 0)
                    end
                end
                if left then
                    timerbars[firstactive]:SetPoint("LEFT", self.button, "RIGHT", 
                        self.timeSpacing, timerbars[firstactive]:GetHeight()*timerbars[firstactive]:GetEffectiveScale()/2*(active-1))
                else
                    timerbars[firstactive]:SetPoint("RIGHT", self.button, "LEFT",
                        -self.timeSpacing, timerbars[firstactive]:GetHeight()*timerbars[firstactive]:GetEffectiveScale()/2*(active-1))
                end
                local last = firstactive
                for i = firstactive+1, numtimers do
                    timerbars[i]:SetPoint("TOP", timerbars[last], "BOTTOM")
                    if self.timers[i] > 0 then                        
                        last = i
                    end
                end
                for i = 2, firstactive-1 do
                    timerbars[i]:SetPoint("TOP", self.button, "BOTTOM")
                end
            end
        else
            local lastactive = 1
    		timerbars[1]:SetPoint("BOTTOM", self.button, "TOP", 0, self.timeSpacing)
    		for i=2, numtimers do
                timerbars[i]:SetPoint("BOTTOM", timerbars[lastactive], "TOP")
                if self.timers[i] > 0 then
                    lastactive = i
                end
    		end
        end
	elseif side == "BOTTOM" then
        if TotemTimers_Settings.ShowCooldowns and self.nr < 5 and (TotemTimers_Settings.Arrange == "vertical" or TotemTimers_Settings.Arrange == "box") then
            timerbars[1]:SetPoint("TOP", self.button, "BOTTOM", 0, -self.timeSpacing)
            local active = 0
            local firstactive = 0
            for i = 2, numtimers do
                if self.timers[i] > 0 then
                    active = active + 1
                    if firstactive == 0 then firstactive = i end
                end
            end
            if active > 0 then
                local left = self.button:GetLeft() < WorldFrame:GetWidth()/2
                if TotemTimers_Settings.Arrange == "box" and self.actnr then
                    left = self.actnr == 2 or self.actnr == 4
                end
                for i=2, numtimers do
                    timerbars[i].icon:ClearAllPoints()
                    if left then
                        timerbars[i].icon:SetPoint("LEFT", timerbars[i], "RIGHT", -4, 0)
                    else
                        timerbars[i].icon:SetPoint("RIGHT", timerbars[i], "LEFT", 4, 0)
                    end
                end
                if left then
                    timerbars[firstactive]:SetPoint("LEFT", self.button, "RIGHT", 
                        self.timeSpacing, timerbars[firstactive]:GetHeight()*timerbars[firstactive]:GetEffectiveScale()/2*(active-1))
                else
                    timerbars[firstactive]:SetPoint("RIGHT", self.button, "LEFT",
                        -self.timeSpacing, timerbars[firstactive]:GetHeight()*timerbars[firstactive]:GetEffectiveScale()/2*(active-1))
                end
                local last = firstactive
                for i = firstactive+1, numtimers do
                    timerbars[i]:SetPoint("TOP", timerbars[last], "BOTTOM")
                    if self.timers[i] > 0 then
                        last = i
                    end
                end
                for i = 2, firstactive-1 do
                    timerbars[i]:SetPoint("TOP", self.button, "BOTTOM")
                end
             end
        else
            local lastactive = 1
    		timerbars[1]:SetPoint("TOP", self.button, "BOTTOM", 0, -self.timeSpacing)
    		for i=2, numtimers do
                timerbars[i]:SetPoint("TOP", timerbars[lastactive], "BOTTOM")
                if self.timers[i] > 0 then
                    lastactive = i
                end
    		end
        end
	end
	if not InCombatLockdown() and not notReanchor then self:Reanchor() end
end

function XiTimers:GetBorder(side)
	local timerBarPos = self.timerBarPos
	if side == "TOP" and timerBarPos == "TOP" or side == "BOTTOM" and timerBarPos == "BOTTOM" then
        local height = self.timerbars[1]:GetHeight()*self.timerbars[1]:GetEffectiveScale()        
        if self.nr > 5 or TotemTimers_Settings.Arrange == "horizontal" then
            height = height * self.numtimers
        end        
		return self.timerOnButton and 0 or self.timeSpacing + height
	elseif ((side == "LEFT" and timerBarPos == "LEFT" or side == "RIGHT" and timerBarPos == "RIGHT") and ((self.numtimers>1 and TotemTimers_Settings.ShowCooldowns) or not self.timerOnButton))
        or (self.nr < 5 and TotemTimers_Settings.ShowCooldowns and TotemTimers_Settings.Arrange == "vertical" and self.numtimers > 1 and 
            ((side == "LEFT" and self.numtimers > 1 and TotemTimersFrame:GetLeft() > WorldFrame:GetWidth()/2)
            or (side == "RIGHT" and self.numtimers > 1 and TotemTimersFrame:GetLeft() < WorldFrame:GetWidth()/2)))
    then
		return (self.timeSpacing + self.timerbars[1]:GetWidth()*self.timerbars[1]:GetEffectiveScale())
	end
	return 0
end


function XiTimers:SetWidth(width)
	self.button:SetWidth(width)
end

function XiTimers:SetHeight(height)
	self.button:SetHeight(height)
end

function XiTimers:SetFont(font)
    for _,timerbar in pairs(self.timerbars) do
        local _,height = timerbar.time:GetFont()
        timerbar.time:SetFont(font, height)
    end
    local _,height = self.button.time:GetFont()
    self.button.time:SetFont(font, height, "OUTLINE")
end

function XiTimers:SetTimeHeight(height)
	for _,timerbar in pairs(self.timerbars) do
		timerbar:SetHeight(height)
        local font = timerbar.time:GetFont()
		timerbar.time:SetFont(font, height)
	end
	self:Reanchor()
end

function XiTimers:SetTimeWidth(width)
	for _,timerbar in pairs(self.timerbars) do
		timerbar:SetWidth(width)
		timerbar.time:SetWidth(width)
	end
	self:Reanchor()
end

function XiTimers:SetScale(scale)
	self.button:SetScale(scale)
	self:SetTimerBarPos(self.timerBarPos)
	--self:Reanchor()
end

function XiTimers:SetBarTexture(texture)
    for _,bar in pairs(self.timerbars) do
        bar:SetStatusBarTexture(texture)
        bar.background:SetStatusBarTexture(texture)
    end
end

function XiTimers:SetBarColor(r,g,b)
    for _,bar in pairs(self.timerbars) do
        bar:SetStatusBarColor(r,g,b, 1.0)
        bar.background:SetStatusBarColor(r,g,b,0.4)
    end
end

--allowed position combinations are: CENTER/CENTER, LEFT/RIGHT, RIGHT/LEFT, TOP/BOTTOM, BOTTOM/TOP

local CounterPositions = {
	CENTER = "CENTER",
	LEFT = "RIGHT",
	RIGHT = "LEFT",
	TOP = "BOTTOM", 
	BOTTOM = "TOP",
    TOPLEFT = "BOTTOM",
    TOPRIGHT = "BOTTOM",
}

local DirectionXMult = {
	CENTER = 0,
	LEFT = 1,
	RIGHT = -1,
	TOP = 0,
	BOTTOM = 0,
    TOPRIGHT = -1,
    TOPLEFT = 1,
}

local DirectionYMult = {
	CENTER = 0,
	LEFT = 0,
	RIGHT = 0,
	TOP = -1,
	BOTTOM = -1,
    TOPRIGHT = -1,
    TOPLEFT = -1,
}


function XiTimers:SetPoint(pos, relframe, relpos, halfspace)
	local relborder = 0
	if relframe.button then 
		if not relpos then relborder = relframe:GetBorder(CounterPositions[pos])
        else relborder = relframe:GetBorder(relpos) end
		relframe = relframe.button
	end
	local borderx = self:GetBorder(pos)+relborder
    local bordery = borderx
    --hack for anchoring TOPRIGHT or TOPLEFT to BOTTOM, maybe change it account for all anchors someday if needed
    if relpos == "BOTTOM" then borderx = 0 end
	self.button:ClearAllPoints()
    if not relpos then relpos = CounterPositions[pos] end
    local spacingx = self.spacing
    if halfspace then spacingx = spacingx / 2 end
    local spacingy = self.spacing
	self.button:SetPoint(pos, relframe, relpos, (spacingx+borderx)*DirectionXMult[pos], (spacingy+bordery)*DirectionYMult[pos])
end

-- anchors this timer to another
function XiTimers:Anchor(timer, point, relpoint, halfspace)
	table.insert(self.anchors, {timer = timer, point = point, relpoint = relpoint, halfspace = halfspace})
	table.insert(timer.anchorchilds, self)
	self:SetPoint(point, timer, relpoint, halfspace) 
end

-- updates the positions of all frames anchored to this timer
function XiTimers:Reanchor()
	for _, anchor in pairs(self.anchors) do
		self:SetPoint(anchor.point, anchor.timer, anchor.relpoint)
	end
	for _, anchorchild in pairs(self.anchorchilds) do
		anchorchild:Reanchor()
	end
end

function XiTimers:ClearAnchors()
	self.anchors = {}
	self.anchorchilds = {}
end

function XiTimers:SetSpacing(spacing)
	self.spacing = spacing
	self:Reanchor()
end

function XiTimers:SetTimeSpacing(spacing)
	self.timeSpacing = spacing
	self:SetTimerBarPos(self.timerBarPos)
	--self:Reanchor()
end


function XiTimers:Show()
    self.button:Show()
    for i=1,self.numtimers do
        if self.timers[i] > 0 then
            self:ShowTimerBar(i)
        end
    end
end

function XiTimers:Hide()
    self.button:Hide()
    for i=1,self.numtimers do
        if self.timers[i] > 0 then
            self:HideTimerBar(i)
        end
    end
end


--Out-of-combat-Fader

local oocframe = CreateFrame("Frame", "XiTimersOOCFaderFrame")
oocframe:RegisterEvent("PLAYER_REGEN_ENABLED")
oocframe:RegisterEvent("PLAYER_REGEN_DISABLED")

function XiTimers.invokeOOCFader()
    XiTimers.OOCFaderEvent(nil, (InCombatLockdown() and "PLAYER_REGEN_DISABLED") or "PLAYER_REGEN_ENABLED")
end

XiTimers.OOCFaderEvent = function(self, event)
    if event == "PLAYER_REGEN_ENABLED" then
        incombat = false
        for _,timer in pairs(XiTimers.timers) do
            if timer.active and timer.HideOOC then
                timer:Hide()
            end
            timer.button:SetAlpha(timer.OOCAlpha, false)
        end
    elseif event == "PLAYER_REGEN_DISABLED" then
        incombat = true
        for _,timer in pairs(XiTimers.timers, true) do
            if timer.active and timer.HideOOC and not timer.ActiveWhileHidden and not timer.hideInactive then
                timer:Show()
            end
            timer.button:SetAlpha(1)
        end        
    end
end

oocframe:SetScript("OnEvent", XiTimers.OOCFaderEvent)