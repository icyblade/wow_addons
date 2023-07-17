local AceGUI = LibStub("AceGUI-3.0")

--------------------------
-- Slider  	            --
--------------------------
do
	local Type = "Slider"
	local Version = 5
	
	local function OnAcquire(self)
		self:SetDisabled(false)
		self:SetSliderValues(0,100,1)
		self:SetIsPercent(nil)
		self:SetValue(0)
	end
	
	local function OnRelease(self)
		self.frame:ClearAllPoints()
		self.frame:Hide()
		self.slider:EnableMouseWheel(false)
		self:SetDisabled(false)
	end

	local function Control_OnEnter(this)
		this.obj:Fire("OnEnter")
	end
	
	local function Control_OnLeave(this)
		this.obj:Fire("OnLeave")
	end
	
	local function UpdateText(self)
		if self.ispercent then
			self.editbox:SetText((math.floor(self.value*1000+0.5)/10)..'%')
		else
			self.editbox:SetText(math.floor(self.value*100+0.5)/100)
		end
	end
	
	local function Slider_OnValueChanged(this)
		local self = this.obj
		if not this.setup then
			local newvalue
			newvalue = this:GetValue()
			if newvalue ~= self.value and not self.disabled then
				self.value = newvalue
				self:Fire("OnValueChanged", newvalue)
			end
			if self.value then
				local value = self.value
				UpdateText(self)
			end
		end
	end
	
	local function Slider_OnMouseUp(this)
		local self = this.obj
		self:Fire("OnMouseUp",this:GetValue())
	end
	
	local function Slider_OnMouseWheel(this, v)
		local self = this.obj
		if not self.disabled then
			local value = self.value
			if v > 0 then
				value = math.min(value + (self.step or 1),self.max)
			else
				value = math.max(value - (self.step or 1), self.min)
			end
			self.slider:SetValue(value)
		end
	end
	
	local function SetDisabled(self, disabled)
		self.disabled = disabled
		if disabled then
			self.slider:EnableMouse(false)
			self.label:SetTextColor(.5,.5,.5)
			self.hightext:SetTextColor(.5,.5,.5)
			self.lowtext:SetTextColor(.5,.5,.5)
			--self.valuetext:SetTextColor(.5,.5,.5)
			self.editbox:SetTextColor(.5,.5,.5)
			self.editbox:EnableMouse(false)
			self.editbox:ClearFocus()
		else
			self.slider:EnableMouse(true)
			self.label:SetTextColor(1,.82,0)
			self.hightext:SetTextColor(1,1,1)
			self.lowtext:SetTextColor(1,1,1)
			--self.valuetext:SetTextColor(1,1,1)
			self.editbox:SetTextColor(1,1,1)
			self.editbox:EnableMouse(true)
		end
	end
	
	local function SetValue(self, value)
		self.slider.setup = true
		self.slider:SetValue(value)
		self.value = value
		UpdateText(self)
		self.slider.setup = nil
	end
	
	local function SetLabel(self, text)
		self.label:SetText(text)
	end
	
	local function SetSliderValues(self,min, max, step)
		local frame = self.slider
		frame.setup = true
		self.min = min
		self.max = max
		self.step = step
		frame:SetMinMaxValues(min or 0,max or 100)
		self.lowtext:SetText(min or 0)
		self.hightext:SetText(max or 100)
		frame:SetValueStep(step or 1)
		frame.setup = nil
	end
	
	local function EditBox_OnEscapePressed(this)
		this:ClearFocus()
	end
	
	local function EditBox_OnEnterPressed(this)
		local self = this.obj
		local value = this:GetText()
		if self.ispercent then
			value = value:gsub('%%','')
			value = tonumber(value) / 100
		else
			value = tonumber(value)
		end
		
		if value then
			self:Fire("OnMouseUp",value)
		end
	end
	
	local function SetIsPercent(self, value)
		self.ispercent = value
	end
	
	local function FrameOnMouseDown(this)
		this.obj.slider:EnableMouseWheel(true)
		AceGUI:ClearFocus()
	end
	
	local SliderBackdrop  = {
		bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
		edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
		tile = true, tileSize = 8, edgeSize = 8,
		insets = { left = 3, right = 3, top = 6, bottom = 6 }
	}
	
	local function Constructor()
		local frame = CreateFrame("Frame",nil,UIParent)
		local self = {}
		self.type = Type

		self.OnRelease = OnRelease
		self.OnAcquire = OnAcquire
		
		self.frame = frame
		frame.obj = self
		
		self.SetDisabled = SetDisabled
		self.SetValue = SetValue
		self.SetSliderValues = SetSliderValues
		self.SetLabel = SetLabel
		self.SetIsPercent = SetIsPercent
		
		self.alignoffset = 25
		
		frame:EnableMouse(true)
		frame:SetScript("OnMouseDown",FrameOnMouseDown)
		self.slider = CreateFrame("Slider",nil,frame)
		local slider = self.slider
		slider:SetScript("OnEnter",Control_OnEnter)
		slider:SetScript("OnLeave",Control_OnLeave)
		slider:SetScript("OnMouseUp", Slider_OnMouseUp)
		slider.obj = self
		slider:SetOrientation("HORIZONTAL")
		slider:SetHeight(15)
		slider:SetHitRectInsets(0,0,-10,0)
		slider:SetBackdrop(SliderBackdrop)
		--slider:EnableMouseWheel(true)
		slider:SetScript("OnMouseWheel", Slider_OnMouseWheel)
			
		local label = frame:CreateFontString(nil,"OVERLAY","GameFontNormal")
		label:SetPoint("TOPLEFT",frame,"TOPLEFT",0,0)
		label:SetPoint("TOPRIGHT",frame,"TOPRIGHT",0,0)
		label:SetJustifyH("CENTER")
		label:SetHeight(15)
		self.label = label
	
		self.lowtext = slider:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall")
		self.lowtext:SetPoint("TOPLEFT",slider,"BOTTOMLEFT",2,3)
	
		self.hightext = slider:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall")
		self.hightext:SetPoint("TOPRIGHT",slider,"BOTTOMRIGHT",-2,3)
	
	
		local editbox = CreateFrame("EditBox",nil,frame)
		editbox:SetAutoFocus(false)
		editbox:SetFontObject(GameFontHighlightSmall)
		editbox:SetPoint("TOP",slider,"BOTTOM",0,0)
		editbox:SetHeight(14)
		editbox:SetWidth(70)
		editbox:SetJustifyH("CENTER")
		editbox:EnableMouse(true)
		editbox:SetScript("OnEscapePressed",EditBox_OnEscapePressed)
		editbox:SetScript("OnEnterPressed",EditBox_OnEnterPressed)
		self.editbox = editbox
		editbox.obj = self
		
		local bg = editbox:CreateTexture(nil,"BACKGROUND")
		editbox.bg = bg
		bg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
		bg:SetVertexColor(0,0,0,0.25)
		bg:SetAllPoints(editbox)
		
		slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
	
		frame:SetWidth(200)
		frame:SetHeight(44)
		slider:SetPoint("TOP",label,"BOTTOM",0,0)
		slider:SetPoint("LEFT",frame,"LEFT",3,0)
		slider:SetPoint("RIGHT",frame,"RIGHT",-3,0)
	

		slider:SetValue(self.value or 0)
		slider:SetScript("OnValueChanged",Slider_OnValueChanged)
	
		AceGUI:RegisterAsWidget(self)
		return self
	end
	
	AceGUI:RegisterWidgetType(Type,Constructor,Version)
end
