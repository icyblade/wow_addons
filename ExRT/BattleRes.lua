local GlobalAddonName, ExRT = ...

local VExRT = nil

local GetSpellCharges, GetTime, floor = GetSpellCharges, GetTime, floor

local module = ExRT.mod:New("BattleRes",ExRT.L.BattleRes,nil,true)
local ELib,L = ExRT.lib,ExRT.L

function module.options:Load()
	self:CreateTilte()

	self.enableChk = ELib:Check(self,L.senable,VExRT.BattleRes.enabled):Point(5,-30):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.BattleRes.enabled = true
			module:Enable()
		else
			VExRT.BattleRes.enabled = nil
			module:Disable()
		end
	end)
	
	self.fixChk = ELib:Check(self,L.BattleResFix,VExRT.BattleRes.fix):Point(5,-55):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.BattleRes.fix = true
			module.frame:Hide()
			module.frame:SetMovable(false)
		else
			VExRT.BattleRes.fix = nil
			if VExRT.BattleRes.enabled then
				module.frame:Show()
			end
			module.frame:SetMovable(true)
		end
	end)
	
	self.SliderScale = ELib:Slider(self,L.BattleResScale):Size(640):Point("TOP",0,-95):Range(5,200):SetTo(VExRT.BattleRes.Scale or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.BattleRes.Scale = event
		ExRT.F.SetScaleFix(module.frame,event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	self.SliderAlpha = ELib:Slider(self,L.BattleResAlpha):Size(640):Point("TOP",0,-130):Range(0,100):SetTo(VExRT.BattleRes.Alpha or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.BattleRes.Alpha = event
		module.frame:SetAlpha(event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	self.shtml1 = ELib:Text(self,L.BattleResHelp,12):Size(650,0):Point("TOP",0,-165):Top()
	
	self.hideTimerChk = ELib:Check(self,L.BattleResHideTime,VExRT.BattleRes.HideTimer):Point(5,-185):Tooltip(L.BattleResHideTimeTooltip):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.BattleRes.HideTimer = true
			module.frame.time:Hide()
		else
			VExRT.BattleRes.HideTimer = nil
			module.frame.time:Show()
		end
	end)
end

function module:Enable()
	module:RegisterTimer()
	if not VExRT.BattleRes.fix then
		module.frame:Show()
		module.frame:SetMovable(true)
	end
end
function module:Disable()
	module:UnregisterTimer()
	module.frame:Hide()
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.BattleRes = VExRT.BattleRes or {}

	if VExRT.BattleRes.Left and VExRT.BattleRes.Top then
		module.frame:ClearAllPoints()
		module.frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.BattleRes.Left,VExRT.BattleRes.Top)
	end
	if VExRT.BattleRes.Alpha then module.frame:SetAlpha(VExRT.BattleRes.Alpha/100) end
	if VExRT.BattleRes.Scale then module.frame:SetScale(VExRT.BattleRes.Scale/100) end
	
	if VExRT.BattleRes.HideTimer then
		module.frame.time:Hide()
	end
	
	if VExRT.BattleRes.enabled then
		module:Enable()
	end
end

function module:timer(elapsed)
	local charges, maxCharges, started, duration = GetSpellCharges(20484)
	if not charges then
		if VExRT.BattleRes.fix then
			module.frame:Hide()
		end
		module.frame.time:SetText("")
		module.frame.charge:SetText("")
		module.frame.cooldown:Hide()
		return
	else
		module.frame:Show()
		module.frame.cooldown:Show()
	end
	local time = duration - (GetTime() - started)

	module.frame.time:SetFormattedText("%d:%02d", floor(time/60), time%60)
	module.frame.charge:SetText(charges)
	module.frame.cooldown:SetCooldown(started,duration)
	if charges == 0 then
		module.frame.charge:SetTextColor(1,0,0,1)
	else
		module.frame.charge:SetTextColor(1,1,1,1)
	end
end

module.frame = CreateFrame("Frame",nil,UIParent)
module.frame:SetSize(64,64)
module.frame:SetPoint("TOP", 0,-200)
module.frame:SetFrameStrata("HIGH")
module.frame:EnableMouse(true)
module.frame:SetMovable(true)
module.frame:SetClampedToScreen(true)
module.frame:RegisterForDrag("LeftButton")
module.frame:SetScript("OnDragStart", function(self) 
	if self:IsMovable() then 
		self:StartMoving() 
	end 
end)
module.frame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	VExRT.BattleRes.Left = self:GetLeft()
	VExRT.BattleRes.Top = self:GetTop()
end)

module.frame.texture = module.frame:CreateTexture(nil, "BACKGROUND")
module.frame.texture:SetTexture(GetSpellTexture(20484))
module.frame.texture:SetAllPoints()
module.frame.cooldown = CreateFrame("Cooldown", nil, module.frame, "CooldownFrameTemplate")
module.frame.cooldown:SetHideCountdownNumbers(true)
module.frame.cooldown:SetAllPoints()
module.frame.cooldown:SetDrawEdge(false)
module.frame.cooldown:SetFrameLevel(40)
module.frame.texts = CreateFrame("Frame",nil,module.frame)
module.frame.texts:SetAllPoints()
module.frame.texts:SetFrameLevel(50)
module.frame.time = module.frame.texts:CreateFontString(nil,"ARTWORK","ExRTFontNormal")
module.frame.time:SetAllPoints()
module.frame.time:SetJustifyH("CENTER")
module.frame.time:SetJustifyV("MIDDLE")
do
	local filename = module.frame.time:GetFont()
	module.frame.time:SetFont(filename,18,"OUTLINE")
end
module.frame.time:SetTextColor(1,1,1,1)
module.frame.charge = module.frame.texts:CreateFontString(nil,"ARTWORK","ExRTFontNormal")
module.frame.charge:SetAllPoints()
module.frame.charge:SetJustifyH("RIGHT")
module.frame.charge:SetJustifyV("BOTTOM")
do
	local filename = module.frame.charge:GetFont()
	module.frame.charge:SetFont(filename,16,"OUTLINE")
end
module.frame.charge:SetShadowOffset(1,-1)
module.frame.charge:SetTextColor(1,1,1,1)

--[[
module.frame.time:SetText("14:14")
module.frame.charge:SetText("2")
module.frame.cooldown:SetCooldown(GetTime()-30,300)
]]

module.frame:Hide()