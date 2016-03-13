--[[
version 1.0

ExRT.lib.AddShadowComment(self,hide,moduleName,userComment,userFontSize,userOutline)
ExRT.lib.CreateHoverHighlight(parent)
ExRT.lib.SetAlphas(alpha,...)
ExRT.lib.SetPoint(self,...)
ExRT.lib.ShowOrHide(self,bool)

ExRT.lib.CreateColorPickButton(parent,width,height,relativePoint,x,y,cR,cG,cB,cA)
ExRT.lib.CreateGraph(parent,width,height,relativePoint,x,y)
ExRT.lib.CreateHelpButton(parent,helpPlateArray,isTab)
ExRT.lib.CreateScrollCheckList(parent,relativePoint,x,y,width,linesNum,isModern)


version 2.0

All functions:
	:Point(...)		-> SetPoint(...)
	:Size(...)		-> SetSize(...)
	:NewPoint(...)		-> ClearAllPoints() + SetPoint(...)
	:Scale(...)		-> SetScale(...)
	:OnClick(func)		-> SetScript("OnClick",func)
	:Run(func,...)		-> func(self,...)

-> ELib:Shadow(parent,size,edgeSize)
-> ELib:Slider(parent,text,isVertical,template)
	:Range(min,max)		-> SetMinMaxValues(min,max)
	:SetTo(value)		-> SetValue(value)
	:OnChange(func)		-> SetScript("OnValueChanged",func)
	:Size(width)		-> SetWidth(width)
-> ELib:ScrollBar(parent,isOld)
	:Range(min,max)		-> SetMinMaxValues(min,max)
	:SetTo(value)		-> SetValue(value)
	:OnChange(func)		-> SetScript("OnValueChanged",func)
	:UpdateButtons()	-> [update up/down states]
	:ClickRange(i)		-> [set value range for clicks on buttons]
-> ELib:Tabs(parent,template,...)
	:SetTo(page)		-> [set page]
-> ELib:Text(parent,text,size,template)
	:Font(...)		-> SetFont(...)
	:Color(r,g,b)		-> SetTextColor(r,g,b)
	:Shadow(bool)		-> [false: add shadow; true: remove shadow]
	:Outline(bool)		-> [false: add outline; true: remove outline]
	:Left()			-> SetJustifyH("LEFT")
	:Center()		-> SetJustifyH("CENTER")
	:Right()		-> SetJustifyH("RIGHT")
	:Top()			-> SetJustifyV("TOP")
	:Middle()		-> SetJustifyV("MIDDLE")
	:Bottom()		-> SetJustifyV("BOTTOM")
	:FontSize(size)		-> SetFont(font,size)
-> ELib:Edit(parent,maxLetters,onlyNum,template)
	:Text(str)		-> SetText(str)
	:Tooltip(str)		-> [add tooltip]
	:OnChange(func)		-> SetScript("OnTextChanged",func)
-> ELib:ScrollFrame(parent,isOld)
	:Height(px)		-> [set heeight]
-> ELib:Button(parent,text,template)
	:Tooltip(str)		-> [add tooltip]
-> ELib:Icon(parent,textureIcon,size,isButton)
-> ELib:Check(parent,text,state,template)
	:Tooltip(str)		-> [add tooltip]
	:Left()			-> [move text to left side]
-> ELib:Radio(parent,text,checked,template)	
-> ELib:Popup(title,template)
-> ELib:OneTab(parent,text,isOld)
-> ELib:DropDown(parent,width,lines,template)
	:SetText(str)		-> [set text]
	:Tooltip(str)		-> [add tooltip]
	:Size(width)		-> SetWidth(width)
-> ELib:DropDownButton(parent,defText,dropDownWidth,lines,template)
	:Tooltip(str)		-> [add tooltip]
-> ELib:MultiEdit(parent)
	:OnChange(func)		-> SetScript("OnTextChanged",func)
	:Font(...)		-> SetFont(...)
	:Hyperlinks()		-> enable hyperlinks in text (spells,items,etc)
	:ToTop()		-> set scroll vaule to min
	:GetTextHighlight()	-> get highlight positions [start,end]
-> ELib:Frame(parent,template)
	:Texture(texture,layer)	-> create and/or set texture
	:Texture(cR,cG,cB,cA,layer) -> create and/or set texture
	:TexturePoint(...)	-> add point to texture
	:TextureSize(...)	-> set size to texture
-> ELib:SliderBox(parent,list)
	:SetTo(value)		-> [set value from list]
-> ELib:ScrollList(parent,list)
	:Update()		-> [update list]
	:FontSize(size)		-> SetFont(font,size)
-> ELib:ScrollTabsFrame(parent,...)
-> ELib:ListButton(parent,text,width,lines,template)
	:Left()			-> [move text to left side]
-> ELib:DebugBack(parent)
	
Tooltips:
-> ELib.Tooltip:Hide()
-> ELib.Tooltip:Std(anchorUser)			[based on self.tooltipText]
-> ELib.Tooltip:Link(data,...)			[hyperlinks eg: "item:9999","spell:774"]
-> ELib.Tooltip:Show(anchorUser,title,...)	[where ... - lines of tooltip]
-> ELib.Tooltip:Edit_Show(linkData,link)	[for tooltips in editboxes, simplehtmls]
-> ELib.Tooltip:Edit_Click(linkData,link,button)[click for links in editboxes, simplehtmls]
-> ELib.Tooltip:Add(link,data,enableMultiline,disableTitle)	[additional tooltips; data - table param]
-> ELib.Tooltip:HideAdd()			[hide all additional tooltips]

]]

local GlobalAddonName, ExRT = ...
if GlobalAddonName ~= "ExRT" then ExRT = GExRT or {} end

local libVersion = 20

if type(ELib)=='table' and type(ELib.V)=='number' and ELib.V > libVersion then return end

local ELib = {}
_G.ELib = ELib
ExRT.lib = ELib

ELib.V = libVersion


-- SetTexture doesnt work for numbers vaules, use SetColorTexture instead. Check builds when it will be fixed or rewrite addon
---- Quick alpha build fix
local CreateFrame = CreateFrame
if ExRT.is7 then
	local _CreateFrame = CreateFrame
	local function SetTexture(self,arg1,arg2,...)
		if arg2 and type(arg2)=='number' and arg2 <= 1 then	--GetSpellTexture now return spellid (number) with more than 1 arg
			return self:SetColorTexture(arg1,arg2,...)
		else
			return self:_SetTexture(arg1,arg2,...)
		end
	end
	local function CreateTexture(self,...)
		local ret1,ret2,ret3,ret4,ret5 = self:_CreateTexture(...)
		ret1._SetTexture = ret1.SetTexture
		ret1.SetTexture = SetTexture
		return ret1,ret2,ret3,ret4,ret5
	end
	function CreateFrame(...)
		local ret1,ret2,ret3,ret4,ret5 = _CreateFrame(...)
		ret1._CreateTexture = ret1.CreateTexture
		ret1.CreateTexture = CreateTexture 
		return ret1,ret2,ret3,ret4,ret5
	end
end

local GetNextGlobalName
do
	local GlobalIndexNow = 0
	function GetNextGlobalName()
		GlobalIndexNow = GlobalIndexNow + 1
		return "GExRTUIGlobal"..tostring(GlobalIndexNow)
	end
end

local Mod = nil
do
	local function Widget_SetPoint(self,arg1,arg2,arg3,...)
		if type(arg1) == 'table' or (arg1 == 'x' and not arg2) then
			if arg1 == 'x' then arg1 = self:GetParent() end
			self:SetAllPoints(arg1)
			return self
		end
		if arg1 == 'x' then arg1 = self:GetParent() end
		if arg2 == 'x' then arg2 = self:GetParent() end
		if type(arg1) == 'number' then
			arg2,arg3,arg1 = arg1,arg2,'TOPLEFT'
		end
		self:SetPoint(arg1,arg2,arg3,...)
		return self
	end
	local function Widget_SetSize(self,...)
		self:SetSize(...)
		return self
	end
	local function Widget_SetNewPoint(self,...)
		self:ClearAllPoints()
		self:Point(...)
		return self
	end
	local function Widget_SetScale(self,...)
		self:SetScale(...)
		return self
	end
	local function Widget_OnClick(self,func)
		self:SetScript("OnClick",func)
		return self
	end
	local function Widget_Run(self,func,...)
		func(self,...)
		return self
	end
	function Mod(self,...)
		self.Point = Widget_SetPoint
		self.Size = Widget_SetSize
		self.NewPoint = Widget_SetNewPoint
		self.Scale = Widget_SetScale
		self.OnClick = Widget_OnClick
		self.Run = Widget_Run
		
		self.SetNewPoint = Widget_SetNewPoint
		
		for i=1,select("#", ...) do
			if i % 2 == 1 then
				local funcName,func = select(i, ...)
				self[funcName] = func
			end
		end
	end
end

------------

function ELib.AddShadowComment(self,hide,moduleName,userComment,userFontSize,userOutline)
	if self.moduleNameString then
		if hide then
			self.moduleNameString:Hide()
		else
			local selfWidth = self:GetWidth()
			local selfHeight = self:GetHeight()
			self.moduleNameString:SetSize(selfWidth,selfHeight)
			self.moduleNameString:Show()
		end
	elseif not hide and moduleName then
		local selfWidth = self:GetWidth()
		local selfHeight = self:GetHeight()
		self.moduleNameString = ELib.CreateText(self,selfWidth,selfHeight,"BOTTOMRIGHT", -5, 4,"RIGHT","BOTTOM",ExRT.F.defFont, 18,moduleName or "",nil)
		self.moduleNameString:SetTextColor(1, 1, 1, 0.8)
	end

	if self.userCommentString then
		if hide then
			self.userCommentString:Hide()
		else
			local selfWidth = self:GetWidth()
			local selfHeight = self:GetHeight()
			self.userCommentString:SetSize(selfWidth,selfHeight)
			self.userCommentString:Show()
		end
	elseif not hide and userComment then
		local selfWidth = self:GetWidth()
		local selfHeight = self:GetHeight()
		self.userCommentString = ELib.CreateText(self,selfWidth,selfHeight,"BOTTOMRIGHT", -5, 20,"RIGHT","BOTTOM",ExRT.F.defFont, userFontSize or 18,userComment or "",nil,0,0,0,nil,userOutline)
		self.userCommentString:SetTextColor(0, 0, 0, 0.7)
	end
end

do
	function ELib:Shadow(parent,size,edgeSize)
		local self = CreateFrame("Frame",nil,parent)
		self:SetPoint("LEFT",-size,0)
		self:SetPoint("RIGHT",size,0)
		self:SetPoint("TOP",0,size)
		self:SetPoint("BOTTOM",0,-size)
		self:SetBackdrop({edgeFile="Interface/AddOns/ExRT/media/shadow.tga",edgeSize=edgeSize or 28,insets={left=size,right=size,top=size,bottom=size}})
		self:SetBackdropBorderColor(0,0,0,.45)
	
		return self
	end
	function ELib.CreateShadow(parent,size,edgeSize)
		return ELib:Shadow(parent,size,edgeSize)
	end
end

do
	local function SliderOnMouseWheel(self,delta)
		if tonumber(self:GetValue()) == nil then 
			return 
		end
		if self.isVertical then
			delta = -delta
		end
		self:SetValue(tonumber(self:GetValue())+delta)
	end
	local function SliderTooltipShow(self)
		local text = self.text:GetText()
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.tooltipText or "")
		GameTooltip:AddLine(text or "",1,1,1)
		GameTooltip:Show()
	end
	local function SliderTooltipReload(self)
		if GameTooltip:IsVisible() then
			self:tooltipHide()
			self:tooltipShow()
		end
	end
	local function Widget_Range(self,minVal,maxVal,hideRange)
		self.Low:SetText(minVal)
		self.High:SetText(maxVal)
		self:SetMinMaxValues(minVal, maxVal)
		if not self.isVertical then
			self.Low:SetShown(not hideRange)
			self.High:SetShown(not hideRange)
		end
		
		return self
	end
	local function Widget_Size(self,size)
		if self:GetOrientation() == "VERTICAL" then
			self:SetHeight(size)
		else
			self:SetWidth(size)
		end
		return self
	end
	local function Widget_SetTo(self,value)
		if not value then
			local min,max = self:GetMinMaxValues()
			value = max
		end
		self.tooltipText = value
		self:SetValue(value)
		return self
	end
	local function Widget_OnChange(self,func)
		self:SetScript("OnValueChanged",func)
		return self
	end	
	
	function ELib:Slider(parent,text,isVertical,template)
		if template == 0 then
			template = "ExRTSliderTemplate"
		elseif not template then
			template = isVertical and "ExRTSliderModernVerticalTemplate" or "ExRTSliderModernTemplate"
		end
		local self = CreateFrame("Slider",nil,parent,template)
		self.text = self.Text
		self.text:SetText(text or "")
		if isVertical then
			self.Low:Hide()
			self.High:Hide()
			self.text:Hide()			
			self.isVertical = true
		end
		self:SetOrientation(isVertical and "VERTICAL" or "HORIZONTAL")
		self:SetValueStep(1)
		
		self.isVertical = isVertical
		
		self:SetScript("OnMouseWheel", SliderOnMouseWheel)

		self.tooltipShow = SliderTooltipShow
		self.tooltipHide = GameTooltip_Hide
		self.tooltipReload = SliderTooltipReload
		self:SetScript("OnEnter", self.tooltipShow)
		self:SetScript("OnLeave", self.tooltipHide)
		
		Mod(self)
		self.Range = Widget_Range
		self.SetTo = Widget_SetTo
		self.OnChange = Widget_OnChange
		
		if template and template:find("^ExRTSliderModern") then
			self._Size = self.Size
			self.Size = Widget_Size
			
			self.text:SetFont(self.text:GetFont(),10)
			self.Low:SetFont(self.Low:GetFont(),10)
			self.High:SetFont(self.High:GetFont(),10)
		end

		return self
	end
	function ELib.CreateSlider(parent,width,height,x,y,minVal,maxVal,text,defVal,relativePoint,isVertical,isModern)
		return ELib:Slider(parent,text,isVertical,(not isModern) and 0):Size(width,height):Point(relativePoint or "TOPLEFT",x,y):Range(minVal,maxVal):SetTo(defVal or maxVal)
	end
end

do
	local function ScrollBarButtonUpClick(self)
		local scrollBar = self:GetParent()
		if not scrollBar.GetMinMaxValues then scrollBar = scrollBar.slider end
		local min,max = scrollBar:GetMinMaxValues()
		local val = scrollBar:GetValue()
		local clickRange = self:GetParent().clickRange
		if (val - clickRange) < min then
			scrollBar:SetValue(min)
		else
			scrollBar:SetValue(val - clickRange)
		end
	end
	local function ScrollBarButtonDownClick(self)
		local scrollBar = self:GetParent()
		if not scrollBar.GetMinMaxValues then scrollBar = scrollBar.slider end
		local min,max = scrollBar:GetMinMaxValues()
		local val = scrollBar:GetValue()
		local clickRange = self:GetParent().clickRange
		if (val + clickRange) > max then
			scrollBar:SetValue(max)
		else
			scrollBar:SetValue(val + clickRange)
		end
	end
	local function ScrollBarButtonUpMouseHoldDown(self)
		local counter = 0
		self.ticker = C_Timer.NewTicker(.03,function()
			counter = counter + 1
			if counter > 10 then
				ScrollBarButtonUpClick(self)
			end
		end)
	end
	local function ScrollBarButtonUpMouseHoldUp(self)
 		if self.ticker then
 			self.ticker:Cancel()
 		end
	end
	local function ScrollBarButtonDownMouseHoldDown(self)
		local counter = 0
		self.ticker = C_Timer.NewTicker(.03,function()
			counter = counter + 1
			if counter > 10 then
				ScrollBarButtonDownClick(self)
			end
		end)
	end
	local function ScrollBarButtonDownMouseHoldUp(self)
 		if self.ticker then
 			self.ticker:Cancel()
 		end
	end
	
	local function Widget_Size(self, width, height)
		self:SetSize(width, height)
		self.thumb:SetWidth(width - 2)
		if self.isOld then self.thumb:SetSize(width + 10,width + 10) end
		self.slider:SetPoint("TOPLEFT",0,-width-2)
		self.slider:SetPoint("BOTTOMRIGHT",0,width+2)
		self.buttonUP:SetSize(width,width)
		self.buttonDown:SetSize(width,width)
		
		return self
	end
	local function Widget_Range(self,minVal,maxVal,clickRange,unchangedValue)
		self.slider:SetMinMaxValues(minVal, maxVal)
		self.clickRange = clickRange or self.clickRange or 1
		if not unchangedValue then
			self.slider:SetValue(minVal)
		end
		
		return self
	end
	local function Widget_SetValue(self,value)
		self.slider:SetValue(value)
		self:UpdateButtons()
		return self
	end
	local function Widget_GetValue(self)
		return self.slider:GetValue()
	end	
	local function Widget_GetMinMaxValues(self)
		return self.slider:GetMinMaxValues()
	end
	local function Widget_SetMinMaxValues(self,...)
		self.slider:SetMinMaxValues(...)
		self:UpdateButtons()
		return self
	end
	local function Widget_SetScript(self,...)
		self.slider:SetScript(...)
		return self
	end
	local function Widget_OnChange(self,func)
		self.slider:SetScript("OnValueChanged",func)
		return self
	end
	local function Widget_UpdateButtons(self)
		local slider = self.slider
		local value = ExRT.F.Round(slider:GetValue())
		local min,max = slider:GetMinMaxValues()
		if max == min then
			self.buttonUP:SetEnabled(false)	self.buttonDown:SetEnabled(false)
		elseif value <= min then
			self.buttonUP:SetEnabled(false)	self.buttonDown:SetEnabled(true)
		elseif value >= max then
			self.buttonUP:SetEnabled(true)	self.buttonDown:SetEnabled(false)
		else
			self.buttonUP:SetEnabled(true)	self.buttonDown:SetEnabled(true)
		end
		return self
	end
	local function Widget_Slider_UpdateButtons(self)
		self:GetParent():UpdateButtons()
		return self
	end
	local function Widget_ClickRange(self,value)
		self.clickRange = value or 1
		return self
	end
			
	function ELib:ScrollBar(parent,isOld)
		local self = CreateFrame("Frame", nil, parent)
	
		self.slider = CreateFrame("Slider", nil, self)
		self.slider:SetPoint("TOPLEFT",0,-18)
		self.slider:SetPoint("BOTTOMRIGHT",0,18)

		self.bg = self.slider:CreateTexture(nil, "BACKGROUND")
		self.bg:SetPoint("TOPLEFT",0,1)
		self.bg:SetPoint("BOTTOMRIGHT",0,-1)
		self.bg:SetTexture(0, 0, 0, 0.3)
		if not isOld then
			self.thumb = self.slider:CreateTexture(nil, "OVERLAY")
			self.thumb:SetTexture(0.44,0.45,0.50,.7)
			self.thumb:SetSize(14,30)
		else
			self.thumb = self.slider:CreateTexture(nil, "OVERLAY")
			self.thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
			self.thumb:SetSize(25, 25)
		end
		self.slider:SetThumbTexture(self.thumb)
		self.slider:SetOrientation("VERTICAL")
		self.slider:SetValue(2)
		
		if not isOld then
			self.borderLeft = self.slider:CreateTexture(nil, "BACKGROUND")
			self.borderLeft:SetPoint("TOPLEFT",-1,1)
			self.borderLeft:SetPoint("BOTTOMLEFT",-1,-1)
			self.borderLeft:SetWidth(1)
			self.borderLeft:SetTexture(0.24,0.25,0.30,1)
			
			self.borderRight = self.slider:CreateTexture(nil, "BACKGROUND")
			self.borderRight:SetPoint("TOPRIGHT",1,1)
			self.borderRight:SetPoint("BOTTOMRIGHT",1,-1)
			self.borderRight:SetWidth(1)
			self.borderRight:SetTexture(0.24,0.25,0.30,1)
		end
		
		self.buttonUP = CreateFrame("Button",nil,self,isOld and "UIPanelScrollUPButtonTemplate" or "ExRTButtonUpModernTemplate")
		self.buttonUP:SetSize(16,16)
		self.buttonUP:SetPoint("TOP",0,0) 
		self.buttonUP:SetScript("OnClick",ScrollBarButtonUpClick)
		self.buttonUP:SetScript("OnMouseDown",ScrollBarButtonUpMouseHoldDown)
		self.buttonUP:SetScript("OnMouseUp",ScrollBarButtonUpMouseHoldUp)
	
		self.buttonDown = CreateFrame("Button",nil,self,isOld and "UIPanelScrollDownButtonTemplate" or "ExRTButtonDownModernTemplate")
		self.buttonDown:SetPoint("BOTTOM",0,0) 
		self.buttonDown:SetSize(16,16)
		self.buttonDown:SetScript("OnClick",ScrollBarButtonDownClick)
		self.buttonDown:SetScript("OnMouseDown",ScrollBarButtonDownMouseHoldDown)
		self.buttonDown:SetScript("OnMouseUp",ScrollBarButtonDownMouseHoldUp)
		
		self.clickRange = 1
		self.isOld = isOld
		
		self._SetScript = self.SetScript
		Mod(self,
			'Range',Widget_Range,
			'SetValue',Widget_SetValue,
			'SetTo',Widget_SetValue,
			'GetValue',Widget_GetValue,
			'GetMinMaxValues',Widget_GetMinMaxValues,
			'SetMinMaxValues',Widget_SetMinMaxValues,
			'SetScript',Widget_SetScript,
			'OnChange',Widget_OnChange,
			'UpdateButtons',Widget_UpdateButtons,
			'ClickRange',Widget_ClickRange
		)
		self.Size = Widget_Size
		self.slider.UpdateButtons = Widget_Slider_UpdateButtons
		
		return self
	end
	function ELib.CreateScrollBarModern(parent,width,height,x,y,minVal,maxVal,relativePoint,clickRange)
		return ELib:ScrollBar(parent):Size(width,height):Point(relativePoint or "TOPLEFT",x,y):Range(minVal,maxVal):ClickRange(clickRange)
	end
	function ELib.CreateScrollBar(parent,width,height,x,y,minVal,maxVal,relativePoint,clickRange)
		return ELib:ScrollBar(parent,true):Size(width,height):Point(relativePoint or "TOPLEFT",x,y):Range(minVal,maxVal):ClickRange(clickRange)
	end
end

do
	local Tooltip = {}
	ELib.Tooltip = Tooltip

	function Tooltip:Hide()
		GameTooltip_Hide()
	end
	function Tooltip:Std(anchorUser)
		GameTooltip:SetOwner(self,anchorUser or "ANCHOR_RIGHT")
		GameTooltip:SetText(self.tooltipText or "", nil, nil, nil, nil, true)
		GameTooltip:Show()
	end
	function Tooltip:Link(data,...)
		if not data then return end
		local x = self:GetRight()
		if x >= ( GetScreenWidth() / 2 ) then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		else
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		end
		GameTooltip:SetHyperlink(data,...)
		GameTooltip:Show()
	end
	function Tooltip:Show(anchorUser,title,...)
		if not title then return end
		local x,y = 0,0
		if type(anchorUser) == "table" then
			x = anchorUser[2]
			y = anchorUser[3]
			anchorUser = anchorUser[1] or "ANCHOR_RIGHT"
		elseif not anchorUser then
			anchorUser = "ANCHOR_RIGHT"
		end
		GameTooltip:SetOwner(self,anchorUser or "ANCHOR_RIGHT",x,y)
		GameTooltip:SetText(title)
		for i=1,select("#", ...) do
			local line = select(i, ...)
			if type(line) == "table" then
				if not line.right then
					if line[1] then
						GameTooltip:AddLine(unpack(line))
					end
				else
					GameTooltip:AddDoubleLine(line[1], line.right, line[2],line[3],line[4], line[2],line[3],line[4])
				end
			else
				GameTooltip:AddLine(line)
			end
		end
		GameTooltip:Show()
	end
	function Tooltip:Edit_Show(linkData,link)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:SetHyperlink(linkData)
		GameTooltip:Show()
	end
	function Tooltip:Edit_Click(linkData,link,button)
		ExRT.F.LinkItem(nil,link)
	end
	
	--- additional tooltips
	
	local additionalTooltips = {}
	local additionalTooltipBackdrop = {bgFile="Interface/Buttons/WHITE8X8",edgeFile="Interface/Tooltips/UI-Tooltip-Border",tile=false,edgeSize=14,insets={left=2.5,right=2.5,top=2.5,bottom=2.5}}
	local function CreateAdditionalTooltip()
		local new = #additionalTooltips + 1
		local tip = CreateFrame("GameTooltip", "ExRTlibAdditionalTooltip"..new, UIParent, "GameTooltipTemplate")
		additionalTooltips[new] = tip
		
		tip:SetScript("OnLoad",nil)
		tip:SetScript("OnHide",nil)
	
		tip:SetBackdrop(additionalTooltipBackdrop)
		tip:SetBackdropColor(0,0,0,1)
		tip:SetBackdropBorderColor(0.3,0.3,0.4,1)
		
		tip.gradientTexture = tip:CreateTexture()
		tip.gradientTexture:SetTexture(1,1,1,1)
		tip.gradientTexture:SetGradientAlpha("VERTICAL",0,0,0,0,.8,.8,.8,.2)
		tip.gradientTexture:SetPoint("TOPLEFT",2.5,-2.5)
		tip.gradientTexture:SetPoint("BOTTOMRIGHT",-2.5,2.5)
		
		tip:Hide()
		
		return new
	end
	function Tooltip:Add(link,data,enableMultiline,disableTitle)
		local tooltipID = nil
		for i=1,#additionalTooltips do
			if not additionalTooltips[i]:IsShown() then
				tooltipID = i
				break
			end
		end
		if not tooltipID then
			tooltipID = CreateAdditionalTooltip()
		end
		local tooltip = additionalTooltips[tooltipID]
		local owner = nil
		if tooltipID == 1 then
			owner = GameTooltip
		else
			owner = additionalTooltips[tooltipID - 1]
		end
		tooltip:SetOwner(owner, "ANCHOR_NONE")
		if link then
			tooltip:SetHyperlink(link)
		else
			for i=1,#data do
				tooltip:AddLine(data[i], nil, nil, nil, enableMultiline and true)
			end
		end
		if disableTitle then
			local textObj = _G[tooltip:GetName().."TextLeft1"]
			local arg1,arg2,arg3,arg4,arg5 = textObj:GetFont()
			textObj:SetFont( arg1,select(2,_G[tooltip:GetName().."TextLeft2"]:GetFont()),arg3,arg4,arg5 )
			tooltip.titleDisabled = tooltip.titleDisabled or arg2
		elseif tooltip.titleDisabled then
			local textObj = _G[tooltip:GetName().."TextLeft1"]
			local arg1,arg2,arg3,arg4,arg5 = textObj:GetFont()
			textObj:SetFont( arg1,tooltip.titleDisabled,arg3,arg4,arg5 )
			tooltip.titleDisabled = nil
		end
		tooltip:ClearAllPoints()
		local isTop = false
		if tooltipID > 1 then
			local ownerPoint = owner:GetPoint()
			if ownerPoint == "BOTTOMRIGHT" then
				isTop = true
			end
		end
		if not isTop then
			tooltip:SetPoint("TOPRIGHT",owner,"BOTTOMRIGHT",0,0)
		else
			tooltip:SetPoint("BOTTOMRIGHT",owner,"TOPRIGHT",0,0)
		end
		tooltip:Show()
		if not isTop and tooltip:GetBottom() < 1 then
			owner = nil
			for i=1,(tooltipID-1) do
				local point = additionalTooltips[i]:GetPoint()
				if point ~= "TOPRIGHT" then
					owner = additionalTooltips[i]
				end
			end
			owner = owner or GameTooltip
			tooltip:ClearAllPoints()
			tooltip:SetPoint("BOTTOMRIGHT",owner,"TOPRIGHT",0,0)
		end
	end
	function Tooltip:HideAdd()
		for i=1,#additionalTooltips do
			additionalTooltips[i]:Hide()
			additionalTooltips[i]:ClearLines()
		end
	end
	
	-- Old
	function ELib.AdditionalTooltip(...)
		Tooltip:Add(...)
	end
	function ELib.HideAdditionalTooltips()
		Tooltip:HideAdd()
	end
	function ELib.TooltipHide()
		Tooltip:Hide()
	end
	function ELib.OnLeaveHyperLinkTooltip()
		Tooltip:Hide()
	end
	function ELib.EditBoxOnLeaveHyperLinkTooltip()
		Tooltip:Hide()
	end
	function ELib.OnLeaveTooltip()
		Tooltip:Hide()
	end
	function ELib.OnEnterHyperLinkTooltip(...)
		Tooltip.Link(...)
	end
	function ELib.EditBoxOnEnterHyperLinkTooltip(...)
		Tooltip.Edit_Show(...)
	end
	function ELib.EditBoxOnClickHyperLinkTooltip(...)
		Tooltip.Edit_Click(...)
	end
	function ELib.OnEnterTooltip(...)
		Tooltip.Std(...)
	end
	function ELib.TooltipShow(...)
		Tooltip.Show(...)
	end
end

function ELib.ShowOrHide(self,bool)
	if not self then return end
	if bool then
		self:Show()
	else
		self:Hide()
	end
end

function ELib.SetAlphas(alpha,...)
	for i=1,select("#", ...) do
		local self = select(i, ...)
		self:SetAlpha(alpha)
	end
end

do
	local function TabFrame_DeselectTab(self)
		self.Left:Show()
		self.Middle:Show()
		self.Right:Show()

		self:Enable()
		local offsetX = self.Icon and 8 or 0
		self.Text:SetPoint("CENTER", self, "CENTER", offsetX, -3)
		
		self.LeftDisabled:Hide()
		self.MiddleDisabled:Hide()
		self.RightDisabled:Hide()
		
		self.ButtonState = false
	end
	--PanelTemplates_SelectTab
	local function TabFrame_SelectTab(self)
		self.Left:Hide()
		self.Middle:Hide()
		self.Right:Hide()

		self:Disable()
		local offsetX = self.Icon and 8 or 0
		--self:SetDisabledFontObject(GameFontHighlightSmall)
		self.Text:SetPoint("CENTER", self, "CENTER", offsetX, -2)
		
		self.LeftDisabled:Show()
		self.MiddleDisabled:Show()
		self.RightDisabled:Show()
		
		self.ButtonState = true
	end
	--PanelTemplates_DeselectTab
	local function TabFrame_ResizeTab(self, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)	
		local buttonMiddle = self.Middle
		local buttonMiddleDisabled = self.MiddleDisabled
		
		if self.Icon then
			if maxWidth then
				maxWidth = maxWidth + 18
			end
			if absoluteTextSize then
				absoluteTextSize = absoluteTextSize + 18
			end
		end
		
		local sideWidths = 2 * self.Left:GetWidth()
		local tabText = self.Text
		local width, tabWidth
		local textWidth
		if ( absoluteTextSize ) then
			textWidth = absoluteTextSize
		else
			tabText:SetWidth(0)
			textWidth = tabText:GetWidth()
		end
		-- If there's an absolute size specified then use it
		if ( absoluteSize ) then
			if ( absoluteSize < sideWidths) then
				width = 1
				tabWidth = sideWidths
			else
				width = absoluteSize - sideWidths
				tabWidth = absoluteSize
			end
			tabText:SetWidth(width)
		else
			-- Otherwise try to use padding
			if ( padding ) then
				width = textWidth + padding
			else
				width = textWidth + 24
			end
			-- If greater than the maxWidth then cap it
			if ( maxWidth and width > maxWidth ) then
				if ( padding ) then
					width = maxWidth + padding
				else
					width = maxWidth + 24
				end
				tabText:SetWidth(width)
			else
				tabText:SetWidth(0)
			end
			if (minWidth and width < minWidth) then
				width = minWidth
			end
			tabWidth = width + sideWidths
		end
		
		do
			local offsetX = self.Icon and 18 or 0
			local offsetY = self.ButtonState and -2 or -3
			self.Text:SetPoint("CENTER", self, "CENTER", offsetX, offsetY)
		end
		
		if ( buttonMiddle ) then
			buttonMiddle:SetWidth(width)
		end
		if ( buttonMiddleDisabled ) then
			buttonMiddleDisabled:SetWidth(width)
		end
		
		self:SetWidth(tabWidth)
		local highlightTexture = self.HighlightTexture
		if ( highlightTexture ) then
			highlightTexture:SetWidth(tabWidth)
		end
	end
	--PanelTemplates_TabResize
	local function TabFrame_SetTabIcon(self,icon)
		if not icon then
			self.Icon = nil
			if self.icon then
				self.icon:Hide()
			end
			self:Resize(0, nil, nil, self:GetFontString():GetStringWidth(), self:GetFontString():GetStringWidth())
			return
		end
		if not self.icon then
			self.icon = self:CreateTexture(nil,"BACKGROUND")
			self.icon:SetSize(16,16)
			self.icon:SetPoint("LEFT",12,-3)
		end
		self.Icon = icon
		self.icon:SetTexture(icon)
		self.icon:Show()
		self:Resize(0, nil, nil, self:GetFontString():GetStringWidth(), self:GetFontString():GetStringWidth())
	end
	local function TabFrameUpdateTabs(self)
		for i=1,self.tabCount do
			if i == self.selected then
				TabFrame_SelectTab(self.tabs[i].button)
			else
				TabFrame_DeselectTab(self.tabs[i].button)
			end
			self.tabs[i]:Hide()
			
			if self.tabs[i].disabled then
				PanelTemplates_SetDisabledTabState(self.tabs[i].button)
			end
		end
		if self.selected and self.tabs[self.selected] then
			self.tabs[self.selected]:Show()
		end
		if self.navigation then
			if self.disabled then
				self.navigation:SetEnabled(nil)
			else
				self.navigation:SetEnabled(true)
			end
		end
	end
	local function TabFrameButtonClick(self)
		local tabFrame = self.mainFrame
		tabFrame.selected = self.id
		tabFrame.UpdateTabs(tabFrame)
		
		if tabFrame.buttonAdditionalFunc then
			tabFrame:buttonAdditionalFunc()
		end
		if self.additionalFunc then
			self:additionalFunc()
		end
	end
	local function TabFrameSelectTab(self,ID)
		self.selected = ID
		self:UpdateTabs()
	end
	local function TabFrameButtonOnEnter(self)
		if self.tooltip and self.tooltip ~= "" then
			ELib.Tooltip.Show(self,nil,self:GetText(),{self.tooltip,1,1,1})
		end
	end
	local function TabFrameButtonOnLeave(self)
		GameTooltip_Hide()
	end
	local function TabFrameToggleNavigation(self)
		local parent = self.parent
		local dropDownList = {}
		for i=self.max + 1,#parent.tabs do
			dropDownList[#dropDownList+1] = {
				text = parent.tabs[i].button:GetText(),
				notCheckable = true,
				func = function ()
					TabFrameButtonClick(parent.tabs[i].button)
				end
			}
		end
		dropDownList[#dropDownList + 1] = {
			text = ExRT.L.BossWatcherSelectFightClose,
			notCheckable = true,
			func = function() 
				CloseDropDownMenus() 
			end,
		}
		EasyMenu(dropDownList, self.dropDown, "cursor", 10 , -15, "MENU")
	end	
	
	local function Widget_SetSize(self,width,height)
		self:SetSize(width,height)
		for i=1,self.tabCount do
			self.tabs[i]:SetSize(width,height)
		end
		return self
	end
	local function Widget_SetTo(self,activeTabNum)
		TabFrame_SelectTab(self.tabs[activeTabNum or 1].button)
		return self
	end
	
	function ELib:Tabs(parent,template,...)
		template = template == 0 and "ExRTTabButtonTransparentTemplate" or template or "ExRTTabButtonTemplate"
			
		local self = CreateFrame("Frame",nil,parent)
		self:SetBackdrop({bgFile = "Interface/DialogFrame/UI-DialogBox-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border",tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }})
		self:SetBackdropColor(0,0,0,0.5)
		
		self.resizeFunc = TabFrame_ResizeTab
		self.selectFunc = TabFrame_SelectTab
		self.deselectFunc = TabFrame_DeselectTab
		
		self.tabs = {}
		local tabCount = select('#', ...)
		for i=1,tabCount do
			self.tabs[i] = CreateFrame("Frame",nil,self)
			self.tabs[i]:SetPoint("TOPLEFT", 0,0)
	
			self.tabs[i].button = CreateFrame("Button", nil, self, template)
			self.tabs[i].button:SetText(select(i, ...) or i)
			TabFrame_ResizeTab(self.tabs[i].button, 0, nil, nil, self.tabs[i].button:GetFontString():GetStringWidth(), self.tabs[i].button:GetFontString():GetStringWidth())
			
			self.tabs[i].button.id = i
			self.tabs[i].button.mainFrame = self
			self.tabs[i].button:SetScript("OnClick", TabFrameButtonClick)
			
			self.tabs[i].button:SetScript("OnEnter", TabFrameButtonOnEnter)
			self.tabs[i].button:SetScript("OnLeave", TabFrameButtonOnLeave)
	
			if i == 1 then
				self.tabs[i].button:SetPoint("TOPLEFT", 10, 24)
			else
				self.tabs[i].button:SetPoint("LEFT", self.tabs[i-1].button, "RIGHT", template ~= "ExRTTabButtonTemplate" and 0 or -16, 0)
				self.tabs[i]:Hide()
			end
			TabFrame_DeselectTab(self.tabs[i].button)
			
			self.tabs[i].button.Resize = TabFrame_ResizeTab
			self.tabs[i].button.SetIcon = TabFrame_SetTabIcon
			self.tabs[i].button.Select = TabFrame_SelectTab
			self.tabs[i].button.Deselect = TabFrame_DeselectTab
		end
		TabFrame_SelectTab(self.tabs[1].button)
	
		self.tabCount = tabCount
		self.selected = 1
		self.UpdateTabs = TabFrameUpdateTabs
		self.SelectTab = TabFrameSelectTab
		
		Mod(self,
			'SetTo',Widget_SetTo
		)
		self._Size = self.Size	self.Size = Widget_SetSize
	
		return self
	end
	function ELib.CreateTabFrameTemplate(parent,width,height,x,y,template,tabNum,activeTabNum,...)
		return ELib:Tabs(parent,template,...):Size(width,height):Point(x,y):SetTo(activeTabNum)
	end
	function ELib.CreateTabFrame(...)
		return ELib.CreateTabFrameTemplate(...)
	end
end

do
	local function Widget_SetFont(self,...)
		self:SetFont(...)
		return self
	end
	local function Widget_Color(self,colR,colG,colB)
		self:SetTextColor(colR or 1,colG or 1,colB or 1,1)
		return self
	end
	local function Widget_Left(self) self:SetJustifyH("LEFT") return self end
	local function Widget_Center(self) self:SetJustifyH("CENTER") return self end
	local function Widget_Right(self) self:SetJustifyH("RIGHT") return self end
	local function Widget_Top(self) self:SetJustifyV("TOP") return self end
	local function Widget_Middle(self) self:SetJustifyV("MIDDLE") return self end
	local function Widget_Bottom(self) self:SetJustifyV("BOTTOM") return self end
	local function Widget_Shadow(self,disable)
		self:SetShadowColor(0,0,0,disable and 0 or 1)
		self:SetShadowOffset(1,-1)
		return self
	end
	local function Widget_Outline(self,disable)
		local filename,fontSize = self:GetFont()
		self:SetFont(filename,fontSize,(not disable) and "OUTLINE")
		return self
	end
	local function Widget_FontSize(self,size)
		local filename,fontSize,fontParam1,fontParam2,fontParam3 = self:GetFont()
		self:SetFont(filename,size,fontParam1,fontParam2,fontParam3)
		return self
	end
	
	function ELib:Text(parent,text,size,template)
		if template == 0 then 
			template = nil 
		elseif not template then
			template = "ExRTFontNormal"
		end
		local self = parent:CreateFontString(nil,"ARTWORK",template)
		if template and size then
			local filename = self:GetFont()
			if filename then
				self:SetFont(filename,size)
			end
		end
		self:SetJustifyH("LEFT")
		self:SetJustifyV("MIDDLE")
		if template then
			self:SetText(text or "")
		end
		
		Mod(self,
			'Font',Widget_SetFont,
			'Color',Widget_Color,
			'Left',Widget_Left,
			'Center',Widget_Center,
			'Right',Widget_Right,
			'Top',Widget_Top,
			'Middle',Widget_Middle,
			'Bottom',Widget_Bottom,
			'Shadow',Widget_Shadow,
			'Outline',Widget_Outline,
			'FontSize',Widget_FontSize
		)
		
		return self
	end
	
	function ELib.CreateText(parent,width,height,relativePoint,x,y,hor,ver,font,fontSize,text,tem,colR,colG,colB,shadow,outline,doNotUseTemplate)
		if doNotUseTemplate then tem = 0 end
		local self = ELib:Text(parent,text,fontSize,tem):Size(width,height):Point(relativePoint or "TOPLEFT", x,y)
		if hor then self:SetJustifyH(hor) end
		if ver then self:SetJustifyV(ver) end
		if font then self:Font(font,fontSize) end
		if shadow then self:Shadow() end
		if outline then self:Outline() end
		if colR then self:Color(colR,colG,colB) end
		return self
	end
end

do
	local function EditBoxEscapePressed(self)
		self:ClearFocus()
	end
	local function Widget_SetText(self,text)
		self:SetText(text or "")
		self:SetCursorPosition(0)
		return self
	end
	local function Widget_Tooltip(self,text)
		self:SetScript("OnEnter",ELib.Tooltip.Std)
		self:SetScript("OnLeave",ELib.Tooltip.Hide)
		self.tooltipText = text
		return self
	end
	local function Widget_OnChange(self,func)
		self:SetScript("OnTextChanged",func)
		return self
	end
	
	function ELib:Edit(parent,maxLetters,onlyNum,template)
		if template == 0 then
			template = "ExRTInputBoxTemplate"
		elseif template == 1 then
			template = nil
		elseif not template then
			template = "ExRTInputBoxModernTemplate"
		end
		local self = CreateFrame("EditBox",nil,parent,template)
		if not template then
			local GameFontNormal_Font = GameFontNormal:GetFont()
			self:SetFont(GameFontNormal_Font,12)
			self:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8",edgeFile = ExRT.F.defBorder,edgeSize = 8,tileSize = 0,insets = {left = 2.5,right = 2.5,top = 2.5,bottom = 2.5}})
			self:SetBackdropColor(0, 0, 0, 0.8) 
			self:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
			self:SetTextInsets(10,10,0,0)
		end
		self:SetAutoFocus( false )
		if maxLetters then
			self:SetMaxLetters(maxLetters)
		end
		if onlyNum then
			self:SetNumeric(true)
		end
		self:SetScript("OnEscapePressed",EditBoxEscapePressed)
		
		Mod(self,
			'Text',Widget_SetText,
			'Tooltip',Widget_Tooltip,
			'OnChange',Widget_OnChange
		)

		return self
	end
	function ELib.CreateEditBox(parent,width,height,relativePoint,x,y,tooltip,maxLetters,onlyNum,doNotUseTemplate,defText)
		local self = ELib:Edit(parent,maxLetters,onlyNum,doNotUseTemplate == true and 1 or type(doNotUseTemplate) == "string" and doNotUseTemplate):Size(width,height):Point(relativePoint or "TOPLEFT",x,y)
		if defText then self:Text(defText) end
		if tooltip then self:Tooltip(tooltip) end
		return self
	end
end

do
	local function Widget_SetSize(self,width,height)
		self:SetSize(width,height)
		self.content:SetWidth(width-16-(self.isModern and 4 or 0))
		self.ScrollBar:Size(16,height)
		
		if self.isModern and height < 65 then
			self.ScrollBar.IsThumbSmalled = true
			self.ScrollBar.thumb:SetHeight(5)
		elseif self.ScrollBar.IsThumbSmalled then
			self.ScrollBar.IsThumbSmalled = nil
			self.ScrollBar.thumb:SetHeight(30)
		end
		
		return self
	end
	local function ScrollFrameMouseWheel(self,delta)
		delta = delta * 20
		local min,max = self.ScrollBar.slider:GetMinMaxValues()
		local val = self.ScrollBar:GetValue()
		if (val - delta) < min then
			self.ScrollBar:SetValue(min)
		elseif (val - delta) > max then
			self.ScrollBar:SetValue(max)
		else
			self.ScrollBar:SetValue(val - delta)
		end
	end
	local function ScrollFrameScrollBarValueChanged(self,value)
		local parent = self:GetParent():GetParent()
		parent:SetVerticalScroll(value) 
		self:UpdateButtons()
	end
	local function ScrollFrameChangeHeight(self,newHeight)
		self.content:SetHeight(newHeight)
		self.ScrollBar:Range(0,max(newHeight-self:GetHeight(),0),nil,true)
		self.ScrollBar:UpdateButtons()
		
		return self
	end
	local ScrollFrameBackdrop = {bgFile = "Interface/DialogFrame/UI-DialogBox-Background", edgeFile = "",tile = true, tileSize = 0, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 }}
	local ScrollFrameBackdropBorder = {bgFile = "Interface/DialogFrame/UI-DialogBox-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border",tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }}
	local ScrollFrameBackdropBorderModern = {edgeFile = "Interface/AddOns/ExRT/media/border.tga", edgeSize = 16}
	
	function ELib:ScrollFrame(parent,isOld)
		local self = CreateFrame("ScrollFrame", nil, parent)
		
		self:SetBackdrop(ScrollFrameBackdrop)
		self:SetBackdropColor(0,0,0,0)
		self:SetBackdropBorderColor(0,0,0,0)
		
		self.backdrop = CreateFrame("Frame", nil, self)
		self.backdrop:SetPoint("TOPLEFT",self,-5,5)
		self.backdrop:SetPoint("BOTTOMRIGHT",self,5,-5)
		if not isOld then
			self.backdrop:SetBackdrop(ScrollFrameBackdropBorderModern)
			self.backdrop:SetBackdropBorderColor(.24,.25,.30,1)
		else
			self.backdrop:SetBackdrop(ScrollFrameBackdropBorder)
			self.backdrop:SetBackdropColor(0,0,0,0)
		end
		
		self.content = CreateFrame("Frame", nil, self) 
		self:SetScrollChild(self.content)
		
		self.isModern = not isOld
		
		self.C = self.content
		
		if not isOld then
			self.ScrollBar = ELib:ScrollBar(self):Size(16,100):Point("TOPRIGHT",0,0):Range(0,1):SetTo(0):ClickRange(20)
		else
			self.ScrollBar = ELib.CreateScrollBar(self,16,100,0,0,0,1,"TOPRIGHT")
		end
		self.ScrollBar.slider:SetScript("OnValueChanged", ScrollFrameScrollBarValueChanged)
		self.ScrollBar:UpdateButtons()
		
		self:SetScript("OnMouseWheel", ScrollFrameMouseWheel)
		
		self.SetNewHeight = ScrollFrameChangeHeight
		self.Height = ScrollFrameChangeHeight
		
		Mod(self)
		self._Size = self.Size
		self.Size = Widget_SetSize
		
		return self
	end
	function ELib.CreateScrollFrame(parent,width,height,relativePoint,x,y,verticalHeight,isModern)
		return ELib:ScrollFrame(parent,not isModern):Size(width,height):Point(relativePoint or "TOPLEFT",x,y):Height(verticalHeight)
	end
end

do
	local SliderBackdropTable = {bgFile = "Interface\\Buttons\\WHITE8X8",edgeFile = ExRT.F.defBorder,edgeSize = 8,tileSize = 0,insets = {left = 2.5,right = 2.5,top = 2.5,bottom = 2.5}}
	local function SliderButtonClick(self)
		local parent = self.parent
		parent.selected = parent.selected + self.diff
		local list = parent.List
		if parent.selected > #list then
			parent.selected = 1
		end
		if parent.selected < 1 then
			parent.selected = #list
		end
		parent:SetTo(parent.selected)
		
		if parent.func then
			parent.func(parent)
		end
	end
	local function SliderBoxCreateButton(parent,text,diff)
		local self = CreateFrame("Button",nil,parent)
		self:SetBackdrop(SliderBackdropTable)
		self:SetBackdropColor(0, 0, 0, 0.8) 
		self:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
		self.text = self:CreateFontString(nil,"ARTWORK","GameFontNormal")
		self.text:SetAllPoints()
		self.text:SetJustifyH("CENTER")
		self.text:SetJustifyV("MIDDLE")
		self.text:SetTextColor(1,1,1,1)
		self.text:SetText(text)
		self:SetScript("OnClick",SliderButtonClick)
		self.diff = diff
		self.parent = parent
		
		return self
	end
	local function Widget_SetSize(self,width,height)
		self:SetSize(width,height)
		self.left:SetSize(height,height)
		self.right:SetSize(height,height)
		
		return self
	end
	local function Widget_SetTo(self,selected)
		self.selected = selected
		if type(self.List[selected]) == "table" then
			self.text:SetText(self.List[selected][1] or "")
			self.tooltipText = self.List[selected][2]
		else
			self.text:SetText(self.List[selected] or "")
			self.tooltipText = nil
		end

		return self
	end
	function ELib:SliderBox(parent,list)
		local self = CreateFrame("Frame",nil,parent)
		self.middle = CreateFrame("Frame",nil,self)
		self.middle:SetBackdrop(SliderBackdropTable)
		self.middle:SetBackdropColor(0, 0, 0, 0.8) 
		self.middle:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
	
		self.middle:SetScript("OnEnter",ELib.Tooltip.Std)
		self.middle:SetScript("OnLeave",ELib.Tooltip.Hide)
	
		list = list or {}
		self.selected = 1
		self.List = list
	
		self.text = ELib:Text(self.middle,nil,nil,"GameFontNormal"):Point('x'):Center():Color()
	
		self.left = SliderBoxCreateButton(self,"<",-1)
		self.left:SetPoint("LEFT",0,0)
		
		self.right = SliderBoxCreateButton(self,">",1)
		self.right:SetPoint("RIGHT",0,0)
		
		self.middle:SetPoint("TOPLEFT",self.left,"TOPRIGHT",0,0)
		self.middle:SetPoint("BOTTOMRIGHT",self.right,"BOTTOMLEFT",0,0)
		
		Mod(self)
		self.Size = Widget_SetSize
		self.SetTo = Widget_SetTo
			
		return self
	end
	function ELib.CreateSliderBox(parent,width,height,x,y,list,selected)
		return ELib:SliderBox(parent,list):Point(x,y):Size(width,height):SetTo(selected)
	end
end

do
	local function ButtonOnEnter(self)
		ELib.Tooltip.Show(self,"ANCHOR_TOP",self.tooltip,{self.tooltipText,1,1,1,true}) 
	end
	local function Widget_Tooltip(self,text)
		self.tooltip = self:GetText()
		if self.tooltip == "" then self.tooltip = " " end
		self.tooltipText = text
		self:SetScript("OnEnter",ButtonOnEnter)
		self:SetScript("OnLeave",ELib.Tooltip.Hide)
		return self
	end
	local function Widget_Disable(self)
		self:_Disable()
		return self
	end
		
	function ELib:Button(parent,text,template)
		if template == 0 then
			template = "UIPanelButtonTemplate"
		elseif template == 1 then
			template = nil
		elseif not template then
			template = "ExRTButtonModernTemplate"
		end
		local self = CreateFrame("Button",nil,parent,template)
		self:SetText(text)
		
		Mod(self,
			'Tooltip',Widget_Tooltip
		)
		self._Disable = self.Disable	self.Disable = Widget_Disable
		
		return self
	end
	function ELib.CreateButton(parent,width,height,relativePoint,x,y,text,isDisabled,tooltip,template)
		local self = ELib:Button(parent,text,template or 0):Size(width,height):Point(relativePoint or "TOPLEFT",x,y) 
		if tooltip then self:Tooltip(tooltip) end
		if isDisabled then self:Disable() end
		return self
	end
end

do
	function ELib:Icon(parent,textureIcon,size,isButton)
		local self = CreateFrame(isButton and "Button" or "Frame",nil,parent)
		self:SetSize(size,size)
		self.texture = self:CreateTexture(nil, "BACKGROUND")
		self.texture:SetAllPoints()
		self.texture:SetTexture(textureIcon or "Interface\\Icons\\INV_MISC_QUESTIONMARK")
		if isButton then
	 		self:EnableMouse(true)
			self:RegisterForClicks("LeftButtonDown")
		end
		
		Mod(self)
		
		return self
	end
	function ELib.CreateIcon(parent,size,relativePoint,x,y,textureIcon,isButton)
		return ELib:Icon(parent,textureIcon,size,isButton):Point(relativePoint or "TOPLEFT", x,y)
	end	
end

do
	local function CheckBoxOnEnter(self)
		local tooltipTitle = self.text:GetText()
		local tooltipText = self.tooltipText
		if tooltipTitle == "" or not tooltipTitle then
			tooltipTitle = tooltipText
			tooltipText = nil
		end
		ELib.Tooltip.Show(self,"ANCHOR_TOP",tooltipTitle,{tooltipText,1,1,1,true})
	end
	local function CheckBoxClick(self)
		if self:GetChecked() then
			self:On()
		else
			self:Off()
		end
	end
	local function Widget_Tooltip(self,text)
		self.tooltipText = text
		return self
	end
	local function Widget_Left(self)
		self.text:ClearAllPoints()
		self.text:SetPoint("RIGHT",self,"LEFT",-2,0)
		return self
	end
			
	function ELib:Check(parent,text,state,template)
		if template == 0 then
			template = "UICheckButtonTemplate"
		elseif not template then
			template = "ExRTCheckButtonModernTemplate"
		end
		local self = CreateFrame("CheckButton",nil,parent,template)  
		self.text:SetText(text or "")
		self:SetChecked(state and true or false)
		self:SetScript("OnEnter",CheckBoxOnEnter)
		self:SetScript("OnLeave",ELib.Tooltip.Hide)
		self:SetScript("OnClick", CheckBoxClick)
		
		Mod(self)
		self.Tooltip = Widget_Tooltip
		self.Left = Widget_Left
		
		return self
	end
	function ELib.CreateCheckBox(parent,relativePoint,x,y,text,checked,tooltip,textLeft,template)
		local self = ELib:Check(parent,text,checked,template or 0):Point(relativePoint or "TOPLEFT",x,y):Tooltip(tooltip)
		if textLeft then self:Left() end
		return self
	end	
end

do
	function ELib:Radio(parent,text,checked,template)
		if template == 0 then
			template = "UIRadioButtonTemplate"
		elseif not template then
			template = "ExRTRadioButtonModernTemplate"
		end
		
		local self = CreateFrame("CheckButton",nil,parent,template)  
		self.text:SetText(text or "")
		self:SetChecked(checked and true or false)
		
		Mod(self)
		
		return self
	end
	function ELib.CreateRadioButton(parent,relativePoint,x,y,text,checked,isModern)
		return ELib:Radio(parent,text,checked,isModern and "ExRTRadioButtonModernTemplate" or "UIRadioButtonTemplate"):Point(relativePoint or "TOPLEFT",x,y)
	end
end

function ELib.CreateHoverHighlight(parent)
	parent.hl = parent:CreateTexture(nil, "BACKGROUND")
	parent.hl:SetPoint("TOPLEFT", 0, 0)
	parent.hl:SetPoint("BOTTOMRIGHT", 0, 0)
	parent.hl:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
	parent.hl:SetBlendMode("ADD")
	parent.hl:Hide()
end

do
	function ELib:DebugBack(parent)
		local frame = parent.CreateTexture and parent or parent:GetParent()
		local self = frame:CreateTexture(nil, "OVERLAY")
		self:SetAllPoints(parent)
		self:SetTexture(1, 0, 0, 0.3)
		
		return self
	end
	function ELib.CreateBackTextureForDebug(parent)
		return ELib:DebugBack(parent)
	end
end

do
	local HELPstratas = {}
	local HELPlevels = {}
	local HelpPlateTooltipStrata = nil
	local HelpPlateTooltipLevel = nil
	local function HideFunc(self,isUser)
		HelpPlate_Hide(isUser)
		self:SetFrameStrata(self.strata)
		self:SetFrameLevel(self.level)
		
		if self.shitInterface then
			for i=1,#HELP_PLATE_BUTTONS do
				if HELPstratas[i] then
					HELP_PLATE_BUTTONS[i]:SetFrameStrata(HELPstratas[i])
					HELP_PLATE_BUTTONS[i]:SetFrameLevel(HELPlevels[i])
				end
			end
			if HelpPlateTooltipStrata then
				HelpPlateTooltip:SetFrameStrata(HelpPlateTooltipStrata)
				HelpPlateTooltip:SetFrameLevel(HelpPlateTooltipLevel)
			end
			self:SetFrameStrata( self.shitStrata )
			self:SetFrameLevel( 119 )
		end
	end
	local function HelpButtonOnClick(self)
		local helpPlate = nil
		if self.isTab then
			helpPlate = self.helpPlateArray[self.isTab.selected]
		else
			helpPlate = self.helpPlateArray
		end
		if helpPlate and not HelpPlate_IsShowing(helpPlate) then
			HelpPlate_Show(helpPlate, self.parent, self, true)
			self:SetFrameStrata( HelpPlate:GetFrameStrata() )
			self:SetFrameLevel( HelpPlate:GetFrameLevel() + 1 )
			
			if self.shitInterface then
				for i=1,#HELP_PLATE_BUTTONS do
					HELPstratas[i] = HELP_PLATE_BUTTONS[i]:GetFrameStrata()
					HELPlevels[i] = HELP_PLATE_BUTTONS[i]:GetFrameLevel()
					HELP_PLATE_BUTTONS[i]:SetFrameStrata(self.shitStrata)
					HELP_PLATE_BUTTONS[i].box:SetFrameStrata(self.shitStrata)
					HELP_PLATE_BUTTONS[i].boxHighlight:SetFrameStrata(self.shitStrata)
					HELP_PLATE_BUTTONS[i]:SetFrameLevel(120)
					HELP_PLATE_BUTTONS[i].box:SetFrameLevel(120)
					HELP_PLATE_BUTTONS[i].boxHighlight:SetFrameLevel(120)
				end
				HelpPlateTooltipStrata = HelpPlateTooltip:GetFrameStrata()
				HelpPlateTooltipLevel = HelpPlateTooltip:GetFrameLevel()
				HelpPlateTooltip:SetFrameStrata(self.shitStrata)
				HelpPlateTooltip:SetFrameLevel(122)
				self:SetFrameStrata( self.shitStrata )
				self:SetFrameLevel( 121 )
			end
		else
			HideFunc(self,true)
		end
		if self.Click2 then
			self:Click2()
		end

	end
	local function HelpButtonOnHide(self)
		HideFunc(self,false)
	end
	function ELib.CreateHelpButton(parent,helpPlateArray,isTab)
		local self = CreateFrame("Button",nil,parent,"MainHelpPlateButton")	-- После использования кнопки не дает юзать спелл дизенчант. лень искать решение, не юзайте кнопку часто [5.4]
		self:SetPoint("CENTER",parent,"TOPLEFT",0,0) 
		self:SetScale(0.8)
		local interfaceStrata = InterfaceOptionsFrame:GetFrameStrata()
		interfaceStrata = "FULLSCREEN_DIALOG"
		self:SetFrameStrata(interfaceStrata)
		if interfaceStrata == "FULLSCREEN" or interfaceStrata == "FULLSCREEN_DIALOG" or interfaceStrata == "TOOLTIP" then
			self.shitInterface = true
			self.shitStrata = interfaceStrata
		end
		
		self.helpPlateArray = helpPlateArray
		self.isTab = isTab
		self.parent = parent
		
		self:SetScript("OnClick",HelpButtonOnClick)
		self:SetScript("OnHide",HelpButtonOnHide)
		self.strata = self:GetFrameStrata()
		self.level = self:GetFrameLevel()
		
		return self
	end
end

do
	local function ScrollListMouseWheel(self,delta)
		if delta > 0 then
			self.Frame.ScrollBar.buttonUP:Click("LeftButton")
		else
			self.Frame.ScrollBar.buttonDown:Click("LeftButton")
		end
	end
	local function ScrollListListEnter(self)
		if self.mainFrame.HoverListValue then
			self.mainFrame:HoverListValue(true,self.index,self)
		end
	end
	local function ScrollListListLeave(self)
		if self.mainFrame.HoverListValue then
			self.mainFrame:HoverListValue(false,self.index,self)
		end
	end
	local ScrollListBackdrop = {bgFile = "", edgeFile = "Interface/Tooltips/UI-Tooltip-Border",tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }}
	local ScrollListBackdropModern = {edgeFile = "Interface/AddOns/ExRT/media/border.tga", edgeSize = 16}
	
	local function ScrollList_Line_Click(self,...)
		local parent = self.mainFrame
		parent.selected = self.index
		parent:Update()
		if parent.SetListValue then
			parent:SetListValue(self.index,...)
		end
	end
	local function ScrollList_AddLine(self,i)
		local line = CreateFrame("Button",nil,self.Frame.C)
		self.List[i] = line
		line:SetPoint("TOPLEFT",0,-(i-1)*16)
		line:SetPoint("BOTTOMRIGHT",self.Frame.C,"TOPRIGHT",0,-i*16)
		
		line.text = ELib:Text(line,"List"..tostring(i),self.fontSize or 12):Point("TOPLEFT",3,0):Point("TOPRIGHT",-3,0):Size(0,16):Color():Shadow()
		
		line.HighlightTexture = line:CreateTexture()
		line.HighlightTexture:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
		line.HighlightTexture:SetBlendMode("ADD")
		line.HighlightTexture:SetPoint("LEFT",0,0)
		line.HighlightTexture:SetPoint("RIGHT",0,0)
		line.HighlightTexture:SetHeight(15)
		line.HighlightTexture:SetVertexColor(1,1,1,1)		
		line:SetHighlightTexture(line.HighlightTexture)
		
		line.PushedTexture = line:CreateTexture()
		line.PushedTexture:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
		line.PushedTexture:SetBlendMode("ADD")
		line.PushedTexture:SetPoint("LEFT",0,0)
		line.PushedTexture:SetPoint("RIGHT",0,0)
		line.PushedTexture:SetHeight(15)
		line.PushedTexture:SetVertexColor(1,1,0,1)
		line:SetDisabledTexture(line.PushedTexture)
		
		line:SetFontString(line.text)
		line:SetPushedTextOffset(2, -1)
		
		line.mainFrame = self
		line.id = i
		line:SetScript("OnClick",ScrollList_Line_Click)
		line:SetScript("OnEnter",ScrollListListEnter)
		line:SetScript("OnLeave",ScrollListListLeave)
		line:RegisterForClicks("LeftButtonUp","RightButtonUp")
	end
	local function ScrollList_ScrollBar_OnValueChanged(self,value)
		local parent = self:GetParent():GetParent()
		parent:SetVerticalScroll(value % 16) 
		self:UpdateButtons()
		
		parent:GetParent():Update()
	end
	local function Widget_Update(self)
		local val = floor(self.Frame.ScrollBar:GetValue() / 16) + 1
		local j = 0
		for i=val,#self.L do
			j = j + 1
			if not self.List[j] then ScrollList_AddLine(self,j) end
			self.List[j]:SetText(self.L[i])
			if not self.dontDisable then
				if i ~= self.selected then
					self.List[j]:SetEnabled(true)
				else
					self.List[j]:SetEnabled(nil)
				end
			end
			self.List[j]:Show()
			self.List[j].index = i
			if (j >= #self.L) or (j >= self.linesPerPage) then
				break
			end
		end
		for i=(j+1),#self.List do
			self.List[i]:Hide()
		end
		self.Frame.ScrollBar:Range(0,max(0,#self.L * 16 - 1 - self:GetHeight()),16,true):UpdateButtons()
		
		if (self:GetHeight() / 16 - #self.L) > 0 then
			self.Frame.ScrollBar:Hide()
			self.Frame.C:SetWidth( self.Frame:GetWidth() )
		else
			self.Frame.ScrollBar:Show()
			self.Frame.C:SetWidth( self.Frame:GetWidth() - 16 )
		end
		
		if self.UpdateAdditional then
			self.UpdateAdditional(self,val)
		end
		
		return self
	end
	local function Widget_SetSize(self,width,height)
		self:_Size(width,height)
		self.Frame:Size(width,height):Height(height+16)
		self.linesPerPage = height / 16 + 1
		
		self.Frame.ScrollBar:Range(0,max(0,#self.L * 16 - 1 - height)):UpdateButtons()
		self:Update()
		
		return self
	end
	local function Widget_FontSize(self,size)
		self.fontSize = size
		for i=1,#self.List do
			self.List[i].text:SetFont(self.List[i].text:GetFont(),size)
		end
		return self
	end
	function ELib:ScrollList(parent,list)
		local self = CreateFrame("Frame",nil,parent)
		self.Frame = ELib:ScrollFrame(self):Point(0,0)
		
		self:SetBackdrop(ScrollListBackdropModern)
		self:SetBackdropBorderColor(.24,.25,.30,0)
		self.Frame.backdrop:SetBackdropBorderColor(.24,.25,.30,0)
		ELib:Border(self,2,.24,.25,.30,1)
		ELib:Border(self,1,0,0,0,1,2,1)

		self.linesPerPage = 1
		self.List = {}
		self.L = list or {}
		
		Mod(self,
			'Update',Widget_Update,
			'FontSize',Widget_FontSize
		)
		self._Size = self.Size	self.Size = Widget_SetSize
		
		self.Frame.ScrollBar:SetScript("OnValueChanged",ScrollList_ScrollBar_OnValueChanged)
		self:SetScript("OnShow",self.Update)
		self:SetScript("OnMouseWheel",ScrollListMouseWheel)

		self:Update()
		
		return self
	end
	function ELib.CreateScrollList(parent,relativePoint,x,y,width,linesNum,isModern)
		return ELib:ScrollList(parent,nil,not isModern):Point(relativePoint or "TOPLEFT",x + 5,y - 5):Size(width-10,linesNum * 16 - 2)
	end
end

do
	local function ScrollCheckListUpdate(self)
		local val = ExRT.F.Round(self.ScrollBar:GetValue())
		local j = 0
		for i=val,#self.L do
			j = j + 1
			self.List[j]:SetText(self.L[i])
			self.List[j].chk:SetChecked(self.C[i])
			self.List[j]:Show()
			self.List[j].index = i
			if j >= self.linesNum then
				break
			end
		end
		for i=(j+1),self.linesNum do
			self.List[i]:Hide()
		end
		self.ScrollBar:SetMinMaxValues(1,max(#self.L-self.linesNum+1,1))
		self.ScrollBar:UpdateButtons()
	end
	local function ScrollCheckListScrollBarOnValueChanged(self)
		local parent = self:GetParent():GetParent()
		parent:Update()
	end
	local function ScrollCheckListMouseWheel(self, delta)
		if delta > 0 then
			self.ScrollBar.buttonUP:Click("LeftButton")
		else
			self.ScrollBar.buttonDown:Click("LeftButton")
		end
	end
	local function ScrollCheckListListCheckClick(self)
		local listParent = self:GetParent()
		local parent = listParent.mainFrame
		if self:GetChecked() then
			parent.C[listParent.index] = true
		else
			parent.C[listParent.index] = nil
		end
		parent.ValueChanged(parent)
	end
	local function ScrollCheckListListClick(self)
		local parent = self.mainFrame
		parent.C[self.index] = not parent.C[self.index]
		parent.List[self.id].chk:SetChecked(parent.C[self.index])
		
		parent.ValueChanged(parent)
	end	
	local function ScrollCheckListListEnter(self)
		if self.mainFrame.HoverListValue then
			self.mainFrame:HoverListValue(true,self.index)
		end
	end
	local function ScrollCheckListListLeave(self)
		if self.mainFrame.HoverListValue then
			self.mainFrame:HoverListValue(false,self.index)
		end
	end
	local ScrollCheckListBackdrop = {bgFile = "", edgeFile = "Interface/Tooltips/UI-Tooltip-Border",tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }}
	local ScrollCheckListBackdropModern = {edgeFile = "Interface/AddOns/ExRT/media/border.tga", edgeSize = 16}
	function ELib.CreateScrollCheckList(parent,relativePoint,x,y,width,linesNum,isModern)
		local self = CreateFrame("Frame",nil,parent)
		local height = linesNum * 16 + 8
		self:SetSize(width,height)
		self:SetPoint(relativePoint or "TOPLEFT",x,y)
		if isModern then
			self:SetBackdrop(ScrollCheckListBackdropModern)
			self:SetBackdropBorderColor(.24,.25,.30,1)
			self.ScrollBar = ELib.CreateScrollBarModern(self,16,height-8,-3,-4,1,10,"TOPRIGHT")
		else
			self:SetBackdrop(ScrollCheckListBackdrop)
			self.ScrollBar = ELib.CreateScrollBar(self,16,height-8,-3,-4,1,10,"TOPRIGHT")
		end
		
		
		self.linesNum = linesNum
		
		self.List = {}
		for i=1,linesNum do
			self.List[i] = CreateFrame("Button",nil,self)
			self.List[i]:SetSize(width - 22,16)
			self.List[i]:SetPoint("TOPLEFT",3,-(i-1)*16-4)
			
			self.List[i]:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight","ADD")
			
			self.List[i].text = ELib.CreateText(self.List[i],width - 50,16,nil,24,0,"LEFT","MIDDLE",nil,12,"List"..tostring(i),nil,1,1,1,1)
			
			self.List[i].mainFrame = self
			self.List[i].id = i
			
			if isModern then
				self.List[i].chk = CreateFrame("CheckButton",nil,self.List[i],"ExRTCheckButtonModernTemplate")  
				self.List[i].chk:SetSize(14,14)
				self.List[i].chk:SetPoint("LEFT",4,0)
			else
				self.List[i].chk = CreateFrame("CheckButton",nil,self.List[i],"UICheckButtonTemplate")  
				self.List[i].chk:SetScale(0.75)
				self.List[i].chk:SetPoint("TOPLEFT",0,5)
			end
			self.List[i].chk:SetScript("OnClick", ScrollCheckListListCheckClick)
			
			self.List[i].PushedTexture = self.List[i]:CreateTexture()
			self.List[i].PushedTexture:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
			self.List[i].PushedTexture:SetBlendMode("ADD")
			self.List[i].PushedTexture:SetAllPoints()
			self.List[i].PushedTexture:SetVertexColor(1,1,0,1)
			
			self.List[i]:SetDisabledTexture(self.List[i].PushedTexture)
			
			self.List[i]:SetFontString(self.List[i].text)
			self.List[i]:SetPushedTextOffset(2, -1)
			
 			self.List[i]:SetScript("OnClick", ScrollCheckListListClick)
			
			self.List[i]:SetScript("OnEnter", ScrollCheckListListEnter)
			self.List[i]:SetScript("OnLeave", ScrollCheckListListLeave)		
		end
		
		self.L = {}
		self.C = {}
		self.Update = ScrollCheckListUpdate
		
		self:SetScript("OnMouseWheel", ScrollCheckListMouseWheel)
		
		self:SetScript("OnShow",self.Update)
		self.ScrollBar:SetScript("OnValueChanged",ScrollCheckListScrollBarOnValueChanged)
		
		return self
	end
end

do
	local function PopupFrameShow(self,anchor,notResetPosIfShown)
		if self:IsShown() and notResetPosIfShown then
			return
		end
		local x, y = GetCursorPosition()
		local Es = self:GetEffectiveScale()
		x, y = x/Es, y/Es
		self:ClearAllPoints()
		self:SetPoint(anchor or self.anchor or "BOTTOMLEFT",UIParent,"BOTTOMLEFT",x,y)
		self:Show()
	end
	local function PopupFrameOnShow(self)
		local interfaceStrata = InterfaceOptionsFrame:GetFrameStrata()
		if interfaceStrata == "FULLSCREEN" or interfaceStrata == "FULLSCREEN_DIALOG" or interfaceStrata == "TOOLTIP" then
			self:SetFrameStrata(interfaceStrata)
		end
		self:SetFrameLevel(120)
		if self.OnShow then
			self:OnShow()
		end
	end
	function ELib:Popup(title,template)
		if template == 0 then
			template = "ExRTDialogTemplate"
		elseif not template then
			template = "ExRTDialogModernTemplate"
		end
		local self = CreateFrame("Frame",nil,UIParent,template)
		self:SetPoint("CENTER")
		self:SetFrameStrata("DIALOG")
		self:SetClampedToScreen(true)
		self:EnableMouse(true)
		self:SetMovable(true)
		self:RegisterForDrag("LeftButton")
		self:SetDontSavePosition(true)
		self:SetScript("OnDragStart", function(self) 
			self:StartMoving() 
		end)
		self:SetScript("OnDragStop", function(self) 
			self:StopMovingOrSizing() 
		end)
		self:Hide()
		self:SetScript("OnShow", PopupFrameOnShow)
		
		self.ShowClick = PopupFrameShow
		if template == "ExRTDialogModernTemplate" then
			self.border = ELib:Shadow(self,20)
		else
			self.title:SetTextColor(1,1,1,1)
		end
		self.title:SetText(title or "")
						
		Mod(self)
		
		return self
	end
	function ELib.CreatePopupFrame(width,height,title,isModern)
		return ELib:Popup(title,(not isModern) and 0):Size(width,height)
	end
end

do
	function ELib:OneTab(parent,text,isOld)
		local self = CreateFrame("Frame",nil,parent)
		if isOld then
			self:SetBackdrop({bgFile = "Interface/DialogFrame/UI-DialogBox-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border",tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }})
			self:SetBackdropColor(0,0,0,0.5)
		else
			self:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 8})
			self:SetBackdropColor(0,0,0,0.3)
			self:SetBackdropBorderColor(.24,.25,.30,1)
		end
		self.name = ELib:Text(self,text,nil,"GameFontNormal"):Size(0,20):Point("TOPLEFT",10,17)
		
		Mod(self)
		
		return self
	end
	
	function ELib.CreateOneTab(parent,width,height,relativePoint,x,y,text,isModern)
		return ELib:OneTab(parent,text,not isModern):Size(width,height):Point(relativePoint or "TOPLEFT",x,y)
	end
end

do
	function ELib.CreateColorPickButton(parent,width,height,relativePoint,x,y,cR,cG,cB,cA)
		local self = CreateFrame("Button",nil,parent)
		self:SetPoint(relativePoint or "TOPLEFT",x,y)
		self:SetSize(width,height)
		self:SetBackdrop({edgeFile = ExRT.F.defBorder, edgeSize = 8})
		
		self:SetScript("OnEnter",function ()
			self:SetBackdropBorderColor(0.5,1,0,5,1)
		end)
		self:SetScript("OnLeave",function ()
		  	self:SetBackdropBorderColor(1,1,1,1)
		end)
		
		self.color = self:CreateTexture(nil, "BACKGROUND")
		self.color:SetTexture(cR or 0, cG or 0, cB or 0, cA or 1)
		self.color:SetAllPoints()
		
		return self
	end
end

do
	local function Widget_SetSize(self,width,height)
		self.list:Size(190,height-6)
		self:SetSize(width,height)
		return self
	end
	function ELib:ScrollTabsFrame(parent,...)
		local self = CreateFrame("Frame",nil,parent)

		self.list = ELib:ScrollList(self):Point("TOPLEFT",3,-3)
		self.tab = {}
		self.listCount = select("#", ...)
		for i=1,self.listCount do
			self.list.L[i] = select(i, ...)
			self.tab[i] = ELib:OneTab(self):Point("TOPLEFT",self.list,"TOPRIGHT",8,0):Point("BOTTOMRIGHT",self,-3,3)
			self.tab[i]:SetBackdropColor(0,0,0,0)
			self.tab[i]:SetBackdropBorderColor(0,0,0,0)
			ELib:Border(self.tab[i],2,.24,.25,.30,1)
			ELib:Border(self.tab[i],1,0,0,0,1,2,1)
		end
		self.list:Update()
		
		local this = self
		function self.list:SetListValue(index)
			for i=1,this.listCount do
				ELib.ShowOrHide(this.tab[i],i == index)
			end
		end
		self.list.selected = 1
		self.list:SetListValue(1)
		
		Mod(self)
		self._Size = self.Size	self.Size = Widget_SetSize
	
		return self
	end
	function ELib.CreateScrollTabsFrame(parent,relativePoint,x,y,width,height,noSelfBorder,isModern,...)
		return ELib:ScrollTabsFrame(parent,...):Point(relativePoint or "TOPLEFT",x,y):Size(width,height)
	end
end

do
	local function DropDown_OnEnter(self)
		if self.tooltip then
			ELib.Tooltip.Show(self,nil,self.tooltip,self.Text:IsTruncated() and self.Text:GetText())
		elseif self.Text:IsTruncated() then
			ELib.Tooltip.Show(self,nil,self.Text:GetText())
		end
	end
	local function DropDown_OnLeave(self)
		GameTooltip_Hide()
	end
	local function ScrollDropDownOnHide(self)
		ELib:DropDownClose()
	end
	local function Widget_SetSize(self,width)
		if self.Middle then
			self.Middle:SetWidth(width)
			local defaultPadding = 25
			self:_SetWidth(width + defaultPadding + defaultPadding)
			self.Text:SetWidth(width - defaultPadding)
		else
			self:_SetWidth(width)
		end
		self.noResize = true
		return self
	end
	local function Widget_SetText(self,text)
		self.Text:SetText(text)
		return self
	end
	local function Widget_SetTooltip(self,text)
		self.tooltip = text
		self:SetScript("OnEnter",DropDown_OnEnter)
		self:SetScript("OnLeave",DropDown_OnLeave)
		
		return self
	end	
		
	function ELib:DropDown(parent,width,lines,template)
		template = template == 0 and "ExRTDropDownMenuTemplate" or template or "ExRTDropDownMenuModernTemplate"
		local self = CreateFrame("Frame", nil, parent, template)

		self.Button:SetScript("OnClick",ELib.ScrollDropDown.ClickButton)
		self:SetScript("OnHide",ScrollDropDownOnHide)
		
		self.List = {}
		self.Width = width
		self.Lines = lines or 10
		
		if template == "ExRTDropDownMenuModernTemplate" then
			self.isModern = true
		end
		
		self.relativeTo = self.Left

		Mod(self,
			'SetText',Widget_SetText,
			'Tooltip',Widget_SetTooltip
		)
		
		self._Size = self.Size
		self.Size = Widget_SetSize

		self._SetWidth = self.SetWidth		
		self.SetWidth = Widget_SetSize
		
		return self
	end
	function ELib.CreateScrollDropDown(parent,relativePoint,x,y,width,dropDownWidth,lines,defText,tooltip,template)
		return ELib:DropDown(parent,dropDownWidth,lines,template):Size(width):Point(relativePoint or "TOPLEFT",x,y):SetText(defText or ""):Tooltip(tooltip)
	end

	function ELib:DropDownButton(parent,defText,dropDownWidth,lines,template)
		local self = ELib:Button(parent,defText,template)
		
		self:SetScript("OnClick",ELib.ScrollDropDown.ClickButton)
		self:SetScript("OnHide",ScrollDropDownOnHide)
		
		self.List = {}
		self.Width = dropDownWidth
		self.Lines = lines or 10
		
		self.isButton = true
	
		return self
	end
	function ELib.CreateScrollDropDownButton(parent,relativePoint,x,y,width,height,dropDownWidth,lines,defText,tooltip,template)
		return ELib:DropDownButton(parent,defText,dropDownWidth,lines,template):Size(width,height):Point(relativePoint or "TOPLEFT",x,y):Tooltip(tooltip)
	end
end


ELib.ScrollDropDown = {}
ELib.ScrollDropDown.List = {}
local ScrollDropDown_Blizzard,ScrollDropDown_Modern = {},{}

for i=1,2 do
	ScrollDropDown_Modern[i] = CreateFrame("Frame","ExRTDropDownListModern",UIParent,"ExRTDropDownListModernTemplate")
	ScrollDropDown_Modern[i]:SetClampedToScreen(true)
	ScrollDropDown_Modern[i].border = ELib:Shadow(ScrollDropDown_Modern[i],20)
	ScrollDropDown_Modern[i].Buttons = {}
	ScrollDropDown_Modern[i].MaxLines = 0
	ScrollDropDown_Modern[i].isModern = true
	do
		ScrollDropDown_Modern[i].Animation = ScrollDropDown_Modern[i]:CreateAnimationGroup()
		ScrollDropDown_Modern[i].Animation:SetScript("OnFinished", function(self) 
			self:GetParent().border:SetBackdropBorderColor(0,0,0,.45)
			self:Play()
		end)
		local fade1 = ScrollDropDown_Modern[i].Animation:CreateAnimation()
		fade1:SetDuration(1)
		fade1:SetOrder(1)
		fade1.parent = ScrollDropDown_Modern[i]
		fade1:SetScript("OnUpdate",function (self)
			local color =  self:GetProgress() / 2
			self.parent.BorderTop:SetTexture(color,color,color,1)
			self.parent.BorderLeft:SetTexture(color,color,color,1)
			self.parent.BorderBottom:SetTexture(color,color,color,1)
			self.parent.BorderRight:SetTexture(color,color,color,1)
		end)
		local pause = ScrollDropDown_Modern[i].Animation:CreateAnimation()
		pause:SetDuration(.5)
		pause:SetOrder(2)
		pause:SetScript("OnUpdate",function (self)
		
		end)
		local fade2 = ScrollDropDown_Modern[i].Animation:CreateAnimation()
		fade2:SetDuration(1)
		fade2:SetOrder(3)
		fade2.parent = ScrollDropDown_Modern[i]
		fade2:SetScript("OnUpdate",function (self)
			local color = (1 - self:GetProgress()) / 2
			self.parent.BorderTop:SetTexture(color,color,color,1)
			self.parent.BorderLeft:SetTexture(color,color,color,1)
			self.parent.BorderBottom:SetTexture(color,color,color,1)
			self.parent.BorderRight:SetTexture(color,color,color,1)
		end)
		local ScrollDropDown_Modern_i = ScrollDropDown_Modern[i]
		function ScrollDropDown_Modern_i:OnShow()
			self.Animation:Play()
		end
	end
	
	ScrollDropDown_Modern[i].Slider = ELib.CreateSlider(ScrollDropDown_Modern[i],10,170,-8,-8,1,10,"Text",1,"TOPRIGHT",true,true)
	ScrollDropDown_Modern[i].Slider:SetScript("OnValueChanged",function (self,value)
		value = ExRT.F.Round(value)
		self:GetParent().Position = value
		ELib.ScrollDropDown:Reload()
	end)
	ScrollDropDown_Modern[i].Slider:SetScript("OnEnter",function(self) UIDropDownMenu_StopCounting(self:GetParent()) end)
	ScrollDropDown_Modern[i].Slider:SetScript("OnLeave",function(self) UIDropDownMenu_StartCounting(self:GetParent()) end)
	
	ScrollDropDown_Modern[i]:SetScript("OnMouseWheel",function (self,delta)
		local min,max = self.Slider:GetMinMaxValues()
		local val = self.Slider:GetValue()
		if (val - delta) < min then
			self.Slider:SetValue(min)
		elseif (val - delta) > max then
			self.Slider:SetValue(max)
		else
			self.Slider:SetValue(val - delta)
		end
	end)
end

for i=1,2 do
	ScrollDropDown_Blizzard[i] = CreateFrame("Frame","ExRTDropDownList",UIParent,"ExRTDropDownListTemplate")
	ScrollDropDown_Blizzard[i].Buttons = {}
	ScrollDropDown_Blizzard[i].MaxLines = 0
	
	ScrollDropDown_Blizzard[i].Slider = ELib.CreateSlider(ScrollDropDown_Blizzard[i],10,170,-15,-11,1,10,"Text",1,"TOPRIGHT",true)
	ScrollDropDown_Blizzard[i].Slider:SetScript("OnValueChanged",function (self,value)
		value = ExRT.F.Round(value)
		self:GetParent().Position = value
		ELib.ScrollDropDown:Reload()
	end)
	ScrollDropDown_Blizzard[i].Slider:SetScript("OnEnter",function(self) UIDropDownMenu_StopCounting(self:GetParent()) end)
	ScrollDropDown_Blizzard[i].Slider:SetScript("OnLeave",function(self) UIDropDownMenu_StartCounting(self:GetParent()) end)
	
	ScrollDropDown_Blizzard[i]:SetScript("OnMouseWheel",function (self,delta)
		local min,max = self.Slider:GetMinMaxValues()
		local val = self.Slider:GetValue()
		if (val - delta) < min then
			self.Slider:SetValue(min)
		elseif (val - delta) > max then
			self.Slider:SetValue(max)
		else
			self.Slider:SetValue(val - delta)
		end
	end)
end

ELib.ScrollDropDown.DropDownList = ScrollDropDown_Blizzard

do
	local function CheckButtonClick(self)
		local parent = self:GetParent()
		self:GetParent():GetParent().List[parent.id].checkState = self:GetChecked()
		if parent.checkFunc then
			parent.checkFunc(parent,self:GetChecked())
		end
	end
	local function CheckButtonOnEnter(self)
		UIDropDownMenu_StopCounting(self:GetParent():GetParent())
	end
	local function CheckButtonOnLeave(self)
		UIDropDownMenu_StartCounting(self:GetParent():GetParent())
	end
	function ELib.ScrollDropDown.CreateButton(i,level)
		level = level or 1
		local dropDown = ELib.ScrollDropDown.DropDownList[level]
		if dropDown.Buttons[i] then
			return
		end
		dropDown.Buttons[i] = CreateFrame("Button",nil,dropDown,"ExRTDropDownMenuButtonTemplate")
		if dropDown.isModern then
			dropDown.Buttons[i]:SetPoint("TOPLEFT",8,-8 - (i-1) * 16)
		else
			dropDown.Buttons[i]:SetPoint("TOPLEFT",18,-16 - (i-1) * 16)
		end
		dropDown.Buttons[i].NormalText:SetMaxLines(1) 
		
		if dropDown.isModern then
			dropDown.Buttons[i].checkButton = CreateFrame("CheckButton",nil,dropDown.Buttons[i],"ExRTCheckButtonModernTemplate")
			dropDown.Buttons[i].checkButton:SetPoint("LEFT",1,0)
			dropDown.Buttons[i].checkButton:SetSize(12,12)
			
			dropDown.Buttons[i].radioButton = CreateFrame("CheckButton",nil,dropDown.Buttons[i],"ExRTRadioButtonModernTemplate")
			dropDown.Buttons[i].radioButton:SetPoint("LEFT",1,0)
			dropDown.Buttons[i].radioButton:SetSize(12,12)
			dropDown.Buttons[i].radioButton:EnableMouse(false)
		else
			dropDown.Buttons[i].checkButton = CreateFrame("CheckButton",nil,dropDown.Buttons[i],"UICheckButtonTemplate")
			dropDown.Buttons[i].checkButton:SetPoint("LEFT",-7,0)
			dropDown.Buttons[i].checkButton:SetScale(.6)
			
			dropDown.Buttons[i].radioButton = CreateFrame("CheckButton",nil,dropDown.Buttons[i])	-- Do not used in blizzard style
		end
		dropDown.Buttons[i].checkButton:SetScript("OnClick",CheckButtonClick)
		dropDown.Buttons[i].checkButton:SetScript("OnEnter",CheckButtonOnEnter)
		dropDown.Buttons[i].checkButton:SetScript("OnLeave",CheckButtonOnLeave)
		dropDown.Buttons[i].checkButton:Hide()
		dropDown.Buttons[i].radioButton:Hide()
		
		dropDown.Buttons[i].Level = level
	end
end

function ELib.ScrollDropDown.ClickButton(self)
	if ELib.ScrollDropDown.DropDownList[1]:IsShown() then
		ELib:DropDownClose()
		return
	end
	local dropDown = nil
	if self.isButton then
		dropDown = self
	else
		dropDown = self:GetParent()
	end
	ELib.ScrollDropDown.ToggleDropDownMenu(dropDown)
	PlaySound("igMainMenuOptionCheckBoxOn")
end

function ELib.ScrollDropDown:Reload(level)
	for j=1,#ELib.ScrollDropDown.DropDownList do
		if ELib.ScrollDropDown.DropDownList[j]:IsShown() or level == j then
			local val = ELib.ScrollDropDown.DropDownList[j].Position
			local count = #ELib.ScrollDropDown.DropDownList[j].List
			local now = 0
			for i=val,count do
				local data = ELib.ScrollDropDown.DropDownList[j].List[i]
				
				if not data.isHidden then
					now = now + 1
					local button = ELib.ScrollDropDown.DropDownList[j].Buttons[now]
					local text = button.NormalText
					local icon = button.Icon
					local paddingLeft = data.padding or 0
					
					if data.icon then
						icon:SetTexture(data.icon)
						paddingLeft = paddingLeft + 18
						icon:Show()
					else
						icon:Hide()
					end
					
					if data.font and now <= 10 then
						local fontObject = _G["ExRTDropDownListFont"..now]
						fontObject:SetFont(data.font,12)
						fontObject:SetShadowOffset(1,-1)
						button:SetNormalFontObject(fontObject)
						button:SetHighlightFontObject(fontObject)
					else
						button:SetNormalFontObject(GameFontHighlightSmallLeft)
						button:SetHighlightFontObject(GameFontHighlightSmallLeft)
					end
					
					if data.colorCode then
						text:SetText( data.colorCode .. (data.text or "") .. "|r" )
					else
						text:SetText( data.text or "" )
					end
					
					text:ClearAllPoints()
					if data.checkable or data.radio then
						text:SetPoint("LEFT", paddingLeft + 16, 0)
					else
						text:SetPoint("LEFT", paddingLeft, 0)
					end
					text:SetPoint("RIGHT", button, "RIGHT", 0, 0)
					text:SetJustifyH(data.justifyH or "LEFT")
					
					if data.checkable then
						button.checkButton:SetChecked(data.checkState)
						button.checkButton:Show()
					else
						button.checkButton:Hide()
					end
					if data.radio then
						button.radioButton:SetChecked(data.checkState)
						button.radioButton:Show()
					else
						button.radioButton:Hide()
					end
					
					local texture = button.Texture
					if data.texture then
						texture:SetTexture(data.texture)
						texture:Show()
					else
						texture:Hide()
					end
					
					if data.subMenu then
						button.Arrow:Show()
					else
						button.Arrow:Hide()
					end
					
					if data.isTitle then
						button:SetEnabled(false)
					else
						button:SetEnabled(true)
					end
					
					button.id = i
					button.arg1 = data.arg1
					button.arg2 = data.arg2
					button.arg3 = data.arg3
					button.arg4 = data.arg4
					button.func = data.func
					button.hoverFunc = data.hoverFunc
					button.leaveFunc = data.leaveFunc
					button.hoverArg = data.hoverArg
					button.checkFunc = data.checkFunc
					
					button.subMenu = data.subMenu
					button.Lines = data.Lines --Max lines for second level
					
					button.data = data
				
					button:Show()
					
					if now >= ELib.ScrollDropDown.DropDownList[j].LinesNow then
						break
					end
				end
			end
			for i=(now+1),ELib.ScrollDropDown.DropDownList[j].MaxLines do
				ELib.ScrollDropDown.DropDownList[j].Buttons[i]:Hide()
			end
		end
	end
end


function ELib.ScrollDropDown.Update(self, elapsed)
	if ( not self.showTimer or not self.isCounting ) then
		return
	elseif ( self.showTimer < 0 ) then
		self:Hide()
		self.showTimer = nil
		self.isCounting = nil
	else
		self.showTimer = self.showTimer - elapsed
	end
end

function ELib.ScrollDropDown.OnClick(self, button, down)
	local func = self.func
	if func then
		func(self, self.arg1, self.arg2, self.arg3, self.arg4)
	end
end
function ELib.ScrollDropDown.OnButtonEnter(self)
	local func = self.hoverFunc
	if func then
		func(self,self.hoverArg)
	end
	ELib.ScrollDropDown:CloseSecondLevel(self.Level)
	if self.subMenu then
		ELib.ScrollDropDown.ToggleDropDownMenu(self,2)
	end
end
function ELib.ScrollDropDown.OnButtonLeave(self)
	local func = self.leaveFunc
	if func then
		func(self)
	end
end

function ELib.ScrollDropDown.ToggleDropDownMenu(self,level)
	level = level or 1
	if self.ToggleUpadte then
		self:ToggleUpadte()
	end
	
	if level == 1 then
		if self.isModern then
			ELib.ScrollDropDown.DropDownList = ScrollDropDown_Modern
		else
			ELib.ScrollDropDown.DropDownList = ScrollDropDown_Blizzard
		end
	end
	for i=level+1,#ELib.ScrollDropDown.DropDownList do
		ELib.ScrollDropDown.DropDownList[i]:Hide()
	end
	local dropDown = ELib.ScrollDropDown.DropDownList[level]

	local dropDownWidth = self.Width
	local isModern = self.isModern
	if level > 1 then
		local parent = ELib.ScrollDropDown.DropDownList[1].parent
		dropDownWidth = parent.Width
		isModern = parent.isModern
	end


	dropDown.List = self.subMenu or self.List
	
	local count = #dropDown.List
	
	local maxLinesNow = self.Lines or count
	
	for i=(dropDown.MaxLines+1),maxLinesNow do
		ELib.ScrollDropDown.CreateButton(i,level)
	end
	dropDown.MaxLines = max(dropDown.MaxLines,maxLinesNow)
	
	local isSliderHidden = max(count-maxLinesNow+1,1) == 1
	if isModern then 
		for i=1,maxLinesNow do
			dropDown.Buttons[i]:SetSize(dropDownWidth - 16 - (isSliderHidden and 0 or 12),16)
		end
	else
		for i=1,maxLinesNow do
			dropDown.Buttons[i]:SetSize(dropDownWidth - 22 + (isSliderHidden and 16 or 0),16)
		end
	end
	dropDown.Position = 1
	dropDown.LinesNow = maxLinesNow
	dropDown.Slider:SetValue(1)
	if self.additionalToggle then
		self.additionalToggle(self)
	end
	dropDown:SetPoint("TOPRIGHT",self,"BOTTOMRIGHT",-16,0)
	dropDown.Slider:SetMinMaxValues(1,max(count-maxLinesNow+1,1))
	if isModern then 
		dropDown:SetSize(dropDownWidth,16 + 16 * maxLinesNow)
		dropDown.Slider:SetHeight(maxLinesNow * 16)
	else
		dropDown:SetSize(dropDownWidth + 32,32 + 16 * maxLinesNow)
		dropDown.Slider:SetHeight(maxLinesNow * 16 + 10)	
	end
	if isSliderHidden then
		dropDown.Slider:Hide()
	else
		dropDown.Slider:Show()
	end
	dropDown:ClearAllPoints()
	if level > 1 then
		dropDown:SetPoint("TOPLEFT",self,"TOPRIGHT",level > 1 and ELib.ScrollDropDown.DropDownList[level-1].Slider:IsShown() and 24 or 12,isModern and 8 or 16)
	else
		local toggleX = self.toggleX or -16
		local toggleY = self.toggleY or 0
		dropDown:SetPoint("TOPRIGHT",self,"BOTTOMRIGHT",toggleX,toggleY)
	end
	
	dropDown.parent = self
	
	dropDown:Show()
	dropDown:SetFrameLevel(0)
	
	ELib.ScrollDropDown:Reload()
end

function ELib.ScrollDropDown.CreateInfo(self,info)
	if info then
		self.List[#self.List + 1] = info
	end
	self.List[#self.List + 1] = {}
	return self.List[#self.List]
end

function ELib.ScrollDropDown.ClearData(self)
	table.wipe(self.List)
	return self.List
end

function ELib.ScrollDropDown.Close()
	ELib.ScrollDropDown.DropDownList[1]:Hide()
	ELib.ScrollDropDown:CloseSecondLevel()
end
function ELib.ScrollDropDown:CloseSecondLevel(level)
	level = level or 1
	for i=(level+1),#ELib.ScrollDropDown.DropDownList do
		ELib.ScrollDropDown.DropDownList[i]:Hide()
	end
end
ELib.DropDownClose = ELib.ScrollDropDown.Close

---> End Scroll Drop Down


do
	local function ListFrameToggleButton(self)
		if self.OnClick then
			self:OnClick()
		end
		ELib.ScrollDropDown.ClickButton(self)
	end
	local function ListFrameOnHide(self)
		ELib:DropDownClose()
	end	
	local function Widget_OnClick(self,func)
		self.OnClick = func
		return self
	end
	local function Widget_Left(self)
		self.text:NewPoint("TOPRIGHT",self,"TOPLEFT",-2,0):Point("BOTTOMRIGHT",self,"BOTTOMLEFT",-2,0)
		return self
	end
	function ELib:ListButton(parent,text,width,lines,template)
		if template == 0 then
			template = "ExRTUIChatDownButtonTemplate"
		elseif not template then
			template = "ExRTUIChatDownButtonModernTemplate"
		end
		local self = CreateFrame("Button",nil,parent,template)
		self.isButton = true
		self.text = ELib:Text(self,text,12):Point("TOPLEFT",self,"TOPRIGHT",2,0):Point("BOTTOMLEFT",self,"BOTTOMRIGHT",2,0):Color():Shadow()
		self:SetScript("OnClick",ListFrameToggleButton)
		self:SetScript("OnHide",ListFrameOnHide)
		self.List = {}
		self.Lines = lines
		self.Width = width
		self.isModern = template == "ExRTUIChatDownButtonModernTemplate"
		
		Mod(self,
			'Left',Widget_Left
		)
		self._OnClick = self.OnClick	self.OnClick = Widget_OnClick
				
		return self
	end
	
	function ELib.CreateListFrame(parent,width,buttonsNum,buttonPos,relativePoint,x,y,buttonText,listClickFunc,isModern)
		local self = ELib:ListButton(parent,buttonText,width,buttonsNum,not isModern and 0):Point(relativePoint or "TOPLEFT",x,y):OnClick(listClickFunc)
		if buttonPos == "RIGHT" then self:Left() end
		return self
	end
end

function ELib.SetPoint(self,...)
	self:ClearAllPoints()
	self:SetPoint(...)
end


--- Graph
do
	local Graph_DefColors = {
		{r = .6, g = 1, b = .6, a = 1},
		{r = 1, g = 1, b = 1, a = 1},
		{r = .82, g = .2, b = .2, a = 1},
		{r = .50, g = .20, b = .82, a = 1},
		{r = .38, g = .39, b = .82, a = 1},
		{r = .82, g = .60, b = .28, a = 1},
		{r = .41, g = .82, b = .77, a = 1},
		{r = 1, g = 1, b = 1, a = 1},
		{r = .82, g = .25, b = .51, a = 1},
		{r = .10, g = .58, b = 0, a = 1},
		{r = .58, g = 0, b = 0, a = 1},
		{r = 0, g = .22, b = .40, a = 1},
	}
	local function GraphGetNode(self,i)
		if not self.graph[i] then
			self.graph[i] = self:CreateTexture(nil, "BACKGROUND")
			self.graph[i]:SetTexture(0.6, 1, 0.6, 1)
		end
		return self.graph[i]
	end
	local function GraphSetDot(self,i,x,y)
		if not self.dots[i] then
			self.dots[i] = self:CreateTexture(nil, "BACKGROUND")
			self.dots[i]:SetTexture("Interface\\AddOns\\ExRT\\media\\blip")
			self.dots[i]:SetSize(2,2)
			self.dots[i]:SetTexture(0.6, 1, 0.6, 1)
		end
		self.dots[i]:SetPoint("TOPLEFT", x, y - self.height)
		self.dots[i]:Show()
	end
	local GraphSetLine = nil
	do
		local cos, sin = math.cos, math.sin
		local function RotateCoordPair(x,y,ox,oy,a,asp)
			y=y/asp
			oy=oy/asp
			return ox + (x-ox)*cos(a) - (y-oy)*sin(a),(oy + (y-oy)*cos(a) + (x-ox)*sin(a))*asp
		end
		local function RotateTexture(self,angle,xT,yT,xB,yB,xC,yC,userAspect)
			local aspect = userAspect or (xT-xB)/(yT-yB)
			local g1,g2 = RotateCoordPair(xT,yT,xC,yC,angle,aspect)
			local g3,g4 = RotateCoordPair(xT,yB,xC,yC,angle,aspect)
			local g5,g6 = RotateCoordPair(xB,yT,xC,yC,angle,aspect)
			local g7,g8 = RotateCoordPair(xB,yB,xC,yC,angle,aspect)
		
			self:SetTexCoord(g1,g2,g3,g4,g5,g6,g7,g8)
		end
		function GraphSetLine(self,i,fX,fY,tX,tY)
			if not self.lines[i] then
				self.lines[i] = self:CreateTexture(nil, "BACKGROUND")
				self.lines[i]:SetTexture("Interface\\AddOns\\ExRT\\media\\line2px")
				self.lines[i]:SetSize(256,256)
				self.lines[i]:SetVertexColor(0.6, 1, 0.6, 1)
			end
			local toDown = tY < fY
			if toDown then
				tY,fY = fY,tY
			end
			local size = max(tX-fX,tY-fY)
			local changeSize = (1 - (size / 256)) / 2
			local min,max = changeSize,1 - changeSize
			local angle
			if tX-fX == 0 then
				angle = 90
			else
				angle = atan( (tY-fY)/(tX-fX) )
			end
			if toDown then
				angle = -angle
			end
			self.lines[i]:SetSize(size,size)
			RotateTexture(self.lines[i],(PI/180)*angle,min,min,max,max,.5,.5)
			
			self.lines[i]:SetPoint("CENTER",self,"BOTTOMLEFT",fX + (tX - fX)/2, fY + (tY - fY)/2)
			self.lines[i]:Show()
		end
	end
	local function GraphSetColor(self,i,r,g,b,a)
		if self.isDots then
			self.dots[i]:SetTexture(r,g,b,a)
		elseif self.isLines then
			self.lines[i]:SetVertexColor(r,g,b,a)
		else
			self.graph[i]:SetTexture(r,g,b,a)
		end
	end
	local function GraphSetVLine(self,i,X)
		if not self.vlines[i] then
			self.vlines[i] = self:CreateTexture(nil, "BACKGROUND")
			self.vlines[i]:SetTexture(1, 0.6, 0.6, .5)
			self.vlines[i]:SetSize(1,self.height)
		end
		self.vlines[i]:SetPoint("BOTTOM",self,"BOTTOMLEFT",X, 0)
		self.vlines[i]:Show()
	end
	
	local function GraphReload_BuildNodes(self,minX,minY,maxX,maxY,axixXstep,enableNodes)
		local nodeNow,Xnow,Ynow = 0,minX,minY
		self.tooltipsData = {}
		for i=1,#self.graph do
			self.graph[i]:Hide()
			self.graph[i]:ClearAllPoints()
		end
		for i=1,#self.dots do
			self.dots[i]:Hide()
		end
		for i=1,#self.lines do
			self.lines[i]:Hide()
		end
		for k=1,#self.data do
			Xnow,Ynow = minX,minY
			local colorR,colorG,colorB,colorA = self.data[k].r,self.data[k].g,self.data[k].b,self.data[k].a or 1
			if not colorR or not colorG or not colorB then
				local def = Graph_DefColors[k]
				if def then
					colorR,colorG,colorB,colorA = def.r,def.g,def.b,def.a
				else
					colorR,colorG,colorB,colorA = 1,1,1,.3
				end
			end
			self.tooltipsData[k] = {}
			for i=1,#self.data[k],self.step do
				local x = self.data[k][i][1]
				local steps = 1
				for j=1,(self.step-1) do
					if self.data[k][i+j] then
						x=x+self.data[k][i+j][1]
						steps = steps + 1
					end
				end
				x = x / steps
				if x >= minX and x <= maxX then
					if (not self.isDots and not self.isLines) or enableNodes then
						if x ~= Xnow then
							nodeNow = nodeNow + 1
							local node = GraphGetNode(self,nodeNow)
							node:SetPoint("BOTTOMLEFT",self,"BOTTOMLEFT",(Xnow - minX)/(maxX - minX)*self.width,(Ynow - minY)/(maxY - minY)*self.height)
							node:SetSize( (x - Xnow)/(maxX - minX)*self.width , 2 )
							node:Show()
							
							Xnow = x
						end
					end
					
					local y = self.data[k][i][2]
					steps = 1
					for j=1,(self.step-1) do
						if self.data[k][i+j] then
							y=y+self.data[k][i+j][2]
							steps = steps + 1
						end
					end
					y = y / steps
					if (not self.isDots and not self.isLines) or enableNodes then
						if y ~= Ynow then
							nodeNow = nodeNow + 1
							local node = GraphGetNode(self,nodeNow)
							local relativePoint = (Ynow > y) and "TOPLEFT" or "BOTTOMLEFT"
							local heightFix = (Ynow > y) and 2 or 0
							node:SetPoint(relativePoint,self,"BOTTOMLEFT",(Xnow - minX)/(maxX - minX)*self.width,(Ynow - minY)/(maxY - minY)*self.height + heightFix)
							node:SetSize( 2, abs(y - Ynow)/(maxY - minY)*self.height )
							node:Show()
							
							Ynow = y
						end
					end
					if self.isDots and not enableNodes then
						local fX,fY = (Xnow - minX)/(maxX - minX)*self.width,(Ynow - minY)/(maxY - minY)*self.height
						local tX,tY = (x - minX)/(maxX - minX)*self.width,(y - minY)/(maxY - minY)*self.height
						local a = (tY - fY) / (tX - fX)
						nodeNow = nodeNow + 1
						GraphSetDot(self,nodeNow,fX,fY > self.height and self.height or fY)
						local lastX,lastY = fX,fY
						for X=fX,tX,axixXstep do
							local Y = (X-fX)*a + fY
							if Y > self.height then	Y = self.height	end
							if abs(X-lastX) > 1.5 or abs(Y-lastY) > 1.5 then
								nodeNow = nodeNow + 1
								GraphSetDot(self,nodeNow,X,Y)
								lastX = X
								lastY = Y
								
								if nodeNow > 10000 then
									ExRT.F.dprint("Graph: Error: Too much nodes")
									return
								end
							end
						end
						nodeNow = nodeNow + 1
						GraphSetDot(self,nodeNow,tX,tY > self.height and self.height or tY)
						
						Xnow = x
						Ynow = y
					end
					if self.isLines and not enableNodes then
						if x ~= Xnow or y ~= Ynow then
							local fX,fY = (Xnow - minX)/(maxX - minX)*self.width,(Ynow - minY)/(maxY - minY)*self.height
							local tX,tY = (x - minX)/(maxX - minX)*self.width,(y - minY)/(maxY - minY)*self.height
							
							tY = tY > self.height and self.height or tY
							fY = fY > self.height and self.height or fY
							
							nodeNow = nodeNow + 1
							GraphSetLine(self,nodeNow,fX,fY,tX,tY)
							GraphSetColor(self,nodeNow,colorR,colorG,colorB,colorA)
							Xnow = x
							Ynow = y
						end
					end
					self.tooltipsData[k][#self.tooltipsData[k] + 1] = {(Xnow - minX)/(maxX - minX)*self.width,Ynow,i,(maxY - Ynow)/(maxY - minY)*self.height,self.data[k][i][3],self.data[k][i][4],self.data[k][i][5]}
				end
			end
		end
		for i=1,#self.vlines do
			self.vlines[i]:Hide()
		end
		local vlines_count = 0
		if self.vertical_data then
			for i=1,#self.vertical_data do
				local x = self.vertical_data[i]
				if x >= minX and x <= maxX then
					local X = (x - minX)/(maxX - minX)*self.width
					
					vlines_count = vlines_count + 1
					GraphSetVLine(self,vlines_count,X)
				end
			end
		end
		ExRT.F.dprint("Graph: Nodes count:",nodeNow)
		return true
	end
	local function GraphReload(self)
		local minX,maxX,minY,maxY = nil
		local isZoom = self.ZoomMinX and self.ZoomMaxX
		for k=1,#self.data do
			for i=1,#self.data[k],self.step do
				local x = self.data[k][i][1]
				local steps = 1
				for j=1,(self.step-1) do
					if self.data[k][i+j] then
						x=x+self.data[k][i+j][1]
						steps = steps + 1
					end
				end
				x = x / steps
				if not minX then
					minX = x
					maxX = x
				else
					minX = min(minX,x)
					maxX = max(maxX,x)
				end
				local y = self.data[k][i][2]
				steps = 1
				for j=1,(self.step-1) do
					if self.data[k][i+j] then
						y=y+self.data[k][i+j][2]
						steps = steps + 1
					end
				end
				y = y / steps
				if not isZoom or (x >= self.ZoomMinX and x <= self.ZoomMaxX) then
					if not minY then
						minY = y
						maxY = y
					else
						minY = min(minY,y)
						maxY = max(maxY,y)
					end
				end
			end
		end
		
		if self.isZeroMin then
			minX = min(minX or 0,0)
			minY = min(minY or 0,0)
		end
		
		if minY == maxY then
			maxY = minY + 1
		end
		if minX == maxX then
			maxX = minX + 1
		end
		if self.ZoomMinX and self.ZoomMaxX and maxX then
			minX = max(minX,self.ZoomMinX)
			maxX = min(maxX,self.ZoomMaxX)
		end
		
		if self.ZoomMaxY and maxY then
			maxY = self.ZoomMaxY
		end
		
		self.range = {
			minX = minX,
			maxX = maxX,
			minY = minY,
			maxY = maxY,		
		}
		ExRT.F.dprint("Graph: minX,maxX,minY,maxY:",minX,maxX,minY,maxY)
		
		if maxY then
			if not self.IsYIsTime then
				self.MaxTextY:SetText(maxY < 1000 and (maxY % 1 == 0 and tostring(maxY) or format("%.1f",maxY)) or ExRT.F.shortNumber(maxY))
			else
				self.MaxTextY:SetFormattedText("%d:%02d",maxY / 60,maxY % 60)
			end
			self.MaxTextYButton:SetWidth(self.MaxTextY:GetStringWidth())
			self.MaxTextYButton:Show()
		else
			self.MaxTextY:SetText("")
			self.MaxTextYButton:Hide()
		end
		
		local result = GraphReload_BuildNodes(self,minX,minY,maxX,maxY,0.02)
		if not result then
			result = GraphReload_BuildNodes(self,minX,minY,maxX,maxY,0.04)			--Lower x step
		end
		if not result then
			result = GraphReload_BuildNodes(self,minX,minY,maxX,maxY,0.08,true)		--Stop using dots
		end
		if not result then
			print("|cffff0000Exorsus Raid Tools:|r Graph probably shows incorrect")
		end
		
		if self.ResetZoom then
			if self.ZoomMinX and self.ZoomMaxX then
				self.ResetZoom:Show()
			else
				self.ResetZoom:Hide()
			end
			self.ZoomMaxY = nil
		end
		
		if self.AddedOordLines then
			self:AddOordLines(self.AddedOordLines)
		end
	end
	local function GraphOnUpdate(self,elapsed)
		local x,y = ExRT.F.GetCursorPos(self)
		if ExRT.F.IsInFocus(self,x,y) then
			if #self.tooltipsData == 1 then
				local Y,X,_posY,xText,yText,comment = nil
				for k=1,#self.tooltipsData do
					for i=#self.tooltipsData[k],1,-1 do
						if self.tooltipsData[k][i][1] < x then
							Y = self.tooltipsData[k][i][2]
							X = self.tooltipsData[k][i][3]
							_posY = self.tooltipsData[k][i][4]
							xText = self.tooltipsData[k][i][5]
							yText = self.tooltipsData[k][i][6]
							comment = self.tooltipsData[k][i][7]
							break
						end
					end
				end
				if Y then
					_posY = -_posY
					if _posY > 0 then
						_posY = 0
					end
					GameTooltip:SetOwner(self, "ANCHOR_LEFT",x,_posY)
					GameTooltip:SetText(xText or ExRT.F.Round(X))
					GameTooltip:AddLine((self.data[1].name and self.data[1].name..": " or "")..(yText or ExRT.F.Round(Y)))
					if comment then
						GameTooltip:AddLine(comment)
					end
					GameTooltip:Show()
					if self.OnUpdateTooltip then
						self:OnUpdateTooltip(true,X,Y)
					end
				else
					GameTooltip_Hide()
					if self.OnUpdateTooltip then
						self:OnUpdateTooltip(false,X,Y)
					end
				end
			else
				GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
				local lines = false
				local isXadded = false
				for k=1,#self.tooltipsData do
					for i=#self.tooltipsData[k],1,-1 do
						if self.tooltipsData[k][i][1] < x then
							local y = self.tooltipsData[k][i][2]
							local x = self.tooltipsData[k][i][3]
							local xText = self.tooltipsData[k][i][5]
							local yText = self.tooltipsData[k][i][6]
							local comment = self.tooltipsData[k][i][7]
							if not isXadded then
								GameTooltip:AddLine(xText or ExRT.F.Round(x))
								isXadded = true
							end
							
							GameTooltip:AddLine((self.data[k].name and self.data[k].name..": " or "")..(yText or ExRT.F.Round(y))..(comment and " ("..comment..")" or ""),self.data[k].r or Graph_DefColors[k] and Graph_DefColors[k].r,self.data[k].g or Graph_DefColors[k] and Graph_DefColors[k].g,self.data[k].b or Graph_DefColors[k] and Graph_DefColors[k].b)
							
							lines = true
							break
						end
					end
				end
				
				if lines then
					GameTooltip:Show()
				else
					GameTooltip_Hide()
				end
			end
		end
		if self.mouseDowned then
			local width = x - self.mouseDowned
			if width > 0 then
				width = min(width,self:GetWidth()-self.mouseDowned)
				self.selectingTexture:SetWidth(width)
				self.selectingTexture:SetPoint("TOPLEFT",self,"TOPLEFT", self.mouseDowned ,0)
			elseif width < 0 then
				width = -width
				width = min(width,self.mouseDowned)
				self.selectingTexture:SetWidth(width)
				self.selectingTexture:SetPoint("TOPLEFT",self,"TOPLEFT", self.mouseDowned-width,0)
			else
				self.selectingTexture:SetWidth(1)
			end
		end
	end
	local function GraphOnMouseDown(self)
		if not self.range or not self.range.maxX then
			return
		end
		self.mouseDowned = ExRT.F.GetCursorPos(self)
		self.selectingTexture:SetPoint("TOPLEFT",self,"TOPLEFT", self.mouseDowned ,0)
		self.selectingTexture:SetWidth(1)
		self.selectingTexture:Show()
	end
	local function GraphOnMouseUp(self,isLeave)
		if isLeave == "LEAVE" then
			if self.selectingTexture then
				self.selectingTexture:Hide()
			end
			self.mouseDowned = nil
			return
		end
		if not self.mouseDowned then
			return
		end
		local x = ExRT.F.GetCursorPos(self)
		if x < self.mouseDowned then
			x , self.mouseDowned = self.mouseDowned , x
		end
		
		local xLen = self.range.maxX - self.range.minX
		local width = self:GetWidth()
		local start = ExRT.F.Round(self.mouseDowned / width * xLen + self.range.minX)
		local ending = ExRT.F.Round(x / width * xLen + self.range.minX)
		
		if self.selectingTexture then
			self.selectingTexture:Hide()
		end
		self.mouseDowned = nil
		
		if self.Zoom then
			self:Zoom(start,ending)
		end
	end
	local function GraphResetZoom(self)
		local parent = self:GetParent()
		parent.ZoomMinX = nil
		parent.ZoomMaxX = nil
		parent:Reload()
	end
	local function GraphZoom(self,start,ending)
		if ending == start then
			self.ZoomMinX = nil
			self.ZoomMaxX = nil
		else
			self.ZoomMinX = start
			self.ZoomMaxX = ending
		end
		self:Reload()
	end	
	local function GraphCreateZoom(self)
		self.selectingTexture = self:CreateTexture(nil, "BACKGROUND",nil,2)
		self.selectingTexture:SetTexture(0, 0.65, 0.9, .7)
		self.selectingTexture:SetHeight(self:GetHeight())
		self.selectingTexture:Hide()
		
		self.ResetZoom = ELib.CreateButton(self,170,20,"TOPRIGHT",-2,-2,ExRT.L.BossWatcherGraphZoomReset,nil,nil,"ExRTButtonModernTemplate")
		self.ResetZoom:SetScript("OnClick",GraphResetZoom)
		self.ResetZoom:Hide()
		
		self.Zoom = GraphZoom
		
		self:SetScript("OnMouseDown",GraphOnMouseDown)
		self:SetScript("OnMouseUp",GraphOnMouseUp)
	end
	local function GraphOnLeave(self)
		GameTooltip_Hide()
		GraphOnMouseUp(self,"LEAVE")
		self:SetScript("OnUpdate",nil)
	end
	local function GraphOnEnter(self)
		self:SetScript("OnUpdate",GraphOnUpdate)
	end
	local function GraphSetMaxY(self,y)
		self.ZoomMaxY = nil
		if y then
			self.ZoomMaxY = tonumber(y)
			if self.ZoomMaxY == 0 then
				self.ZoomMaxY = nil
			end
		end
		self:Reload()
	end
	local function GraphTextYButtonOnClick(self)
		local parent = self:GetParent()
		ExRT.F.ShowInput("Set Max Y",GraphSetMaxY,parent,true)
	end
	local function GraphTextYButtonOnEnter(self)
		local parent = self:GetParent()
	  	parent.MaxTextY:SetTextColor(1,.5,.5,1)
	end
	local function GraphTextYButtonOnLeave(self)
	  	local parent = self:GetParent()
	  	parent.MaxTextY:SetTextColor(1,1,1,1)
	end
	local function GraphAddOordLines(self,num)
		self.axisYlines = self.axisYlines or {}
		for i=1,#self.axisYlines do
			self.axisYlines[i].text:Hide()
			self.axisYlines[i].line:Hide()
		end
		if not self.range then return end
		local minY,maxY = self.range.minY,self.range.maxY
		if not minY or not maxY then return end
		local diff = (maxY - minY) / (num + 1)
		for i=1,num do
			local lineFrame = self.axisYlines[i]
			if not lineFrame then
				lineFrame = {}
				self.axisYlines[i] = lineFrame
				
				lineFrame.text = ELib.CreateText(self,0,0,nil,0,0,"RIGHT","TOP",nil,10,"",nil,1,1,1)
				lineFrame.line = self:CreateTexture(nil, "BACKGROUND",nil,-1)
				lineFrame.line:SetSize(self.width,1)
				lineFrame.line:SetTexture(0.6, 0.6, 1, 1)
				
				lineFrame.text:SetNewPoint("TOPRIGHT",lineFrame.line,"TOPLEFT",-2,-2)
			end
			
			local posY = diff * i / (maxY - minY) * self.height
			
			if not self.IsYIsTime then
				lineFrame.text:SetText( floor(minY + diff * i + .5) )
			else
				local t = minY + diff * i
				lineFrame.text:SetFormattedText( "%d:%02d", t / 60, t % 60)
			end
			lineFrame.line:SetPoint("LEFT",self,"BOTTOMLEFT",0,posY)
			lineFrame.text:Show()
			lineFrame.line:Show()
		end
		
		self.AddedOordLines = num
	end
	
	function ELib.CreateGraph(parent,width,height,relativePoint,x,y,enableZoom)
		local self = CreateFrame(enableZoom and "Button" or "Frame",nil,parent)
		self:SetPoint(relativePoint or "TOPLEFT",parent, x, y)
		self:SetSize(width,height)
		
		self.width = width
		self.height = height
		self.step = 1
		self.isZeroMin = true
		
		self.axisX = self:CreateTexture(nil, "BACKGROUND")
		self.axisX:SetSize(width,2)
		self.axisX:SetPoint("TOPLEFT",self,"BOTTOMLEFT",0,0)
		self.axisX:SetTexture(0.6, 0.6, 1, 1)
		
		self.axisY = self:CreateTexture(nil, "BACKGROUND")
		self.axisY:SetSize(2,height)
		self.axisY:SetPoint("BOTTOMLEFT",self,"BOTTOMLEFT",0,0)
		self.axisY:SetTexture(0.6, 0.6, 1, 1)
		
		self.MaxTextY = ELib.CreateText(self,0,0,nil,0,0,"RIGHT","TOP",nil,10,"",nil,1,1,1)
		self.MaxTextY:SetNewPoint("TOPRIGHT",self.axisY,"TOPLEFT",-2,-2)
		
		self.MaxTextYButton = CreateFrame("Button",nil,self)
		self.MaxTextYButton:SetPoint("TOPRIGHT",self.axisY,"TOPLEFT",-2,-2)
		self.MaxTextYButton:SetHeight(10)
		self.MaxTextYButton:SetScript("OnClick",GraphTextYButtonOnClick)
		self.MaxTextYButton:SetScript("OnEnter",GraphTextYButtonOnEnter)
		self.MaxTextYButton:SetScript("OnLeave",GraphTextYButtonOnLeave)
		self.MaxTextYButton:Hide()
		
		self.graph = {}
		self.dots = {}
		self.lines = {}
		self.vlines = {}
		self.isDots = false
		self.isLines = true
		self.tooltipsData = {}
		self.Reload = GraphReload
		--self:SetScript("OnUpdate",GraphOnUpdate)
		self:SetScript("OnEnter",GraphOnEnter)
		self:SetScript("OnLeave",GraphOnLeave)
		
		if enableZoom then
			GraphCreateZoom(self)
		end
		
		self.AddOordLines = GraphAddOordLines
			
		return self
	end
end

do
	local function MultilineEditBoxOnTextChanged(self,...)
		local parent = self.Parent
		local height = self:GetHeight()
		
		local prevMin,prevMax = parent.ScrollBar:GetMinMaxValues()
		local changeToMax = parent.ScrollBar:GetValue() >= prevMax
		
		parent:SetNewHeight( max( height,parent:GetHeight() ) )
		if changeToMax then
			local min,max = parent.ScrollBar:GetMinMaxValues()
			parent.ScrollBar:SetValue(max)
		end
		if parent.OnTextChanged then
			parent.OnTextChanged(self,...)
		elseif self.OnTextChanged then
			self:OnTextChanged(...)
		end
	end
	local function MultilineEditBoxGetTextHighlight(self)
		local text,cursor = self:GetText(),self:GetCursorPosition()
		self:Insert("")
		local textNew, cursorNew = self:GetText(), self:GetCursorPosition()
		self:SetText( text )
		self:SetCursorPosition( cursor )
		local Start, End = cursorNew, #text - ( #textNew - cursorNew )
		self:HighlightText( Start, End )
		return Start, End
	end
	local function MultilineEditBoxOnFrameClick(self)
		self:GetParent().EditBox:SetFocus()
	end
	local function Widget_Font(self,font,size,...)
		if font == 'x' then
			font = self.EditBox:GetFont() or ExRT.F.defFont
		end
		self.EditBox:SetFont(font,size,...)
		return self
	end
	local function Widget_OnChange(self,func)
		self.EditBox.OnTextChanged = func
		return self
	end
	local function Widget_Hyperlinks(self)
		self.EditBox:SetHyperlinksEnabled(true)
		self.EditBox:SetScript("OnHyperlinkEnter",ELib.Tooltip.Edit_Show)
		self.EditBox:SetScript("OnHyperlinkLeave",ELib.Tooltip.Hide)
		self.EditBox:SetScript("OnHyperlinkClick",ELib.Tooltip.Edit_Click)
		return self
	end
	local function Widget_MouseWheel(self,delta)
		local min,max = self.ScrollBar:GetMinMaxValues()
		delta = delta * (self.wheelRange or 20)
		local val = self.ScrollBar:GetValue()
		if (val - delta) < min then
			self.ScrollBar:SetValue(min)
		elseif (val - delta) > max then
			self.ScrollBar:SetValue(max)
		else
			self.ScrollBar:SetValue(val - delta)
		end
	end	
	local function Widget_ToTop(self)
		self.EditBox:SetCursorPosition(0)
		return self
	end	
	local function Widget_SetText(self,text)
		self.EditBox:SetText(text)
		return self
	end
	local function Widget_GetTextHighlight(self)
		return MultilineEditBoxGetTextHighlight(self.EditBox)
	end
	
	local function MultilineEditBox_OnCursorChanged(self, x, y, width, height)
		local parent = self.Parent
		y = abs(y)
		local scrollNow = parent:GetVerticalScroll()
		local heightNow = parent:GetHeight()
		if y < scrollNow then
			parent.ScrollBar:SetValue(max(floor(y),0))
		elseif (y + height) > (scrollNow + heightNow) then
			local _,scrollMax = parent.ScrollBar:GetMinMaxValues()
			parent.ScrollBar:SetValue(min(ceil( y + height - heightNow ),scrollMax))
		end
	end
	
	function ELib:MultiEdit(parent)
		local self = ELib:ScrollFrame(parent)
		self:SetBackdropColor(0,0,0,.8)
		
		self.EditBox = ELib:Edit(self.C,nil,nil,1):Point("TOPLEFT",self.C,0,0):Point("TOPRIGHT",self.C,0,0):OnChange(MultilineEditBoxOnTextChanged)
		
		self.EditBox.Parent = self
		self.EditBox:SetMultiLine(true) 
		self.EditBox:SetBackdropColor(0, 0, 0, 0)
		self.EditBox:SetBackdropBorderColor(0, 0, 0, 0)
		self.EditBox:SetTextInsets(5,5,2,2)
		self.EditBox:SetScript("OnCursorChanged",MultilineEditBox_OnCursorChanged)
		
		self.C:SetScript("OnMouseDown",MultilineEditBoxOnFrameClick)
		self:SetScript("OnMouseWheel",Widget_MouseWheel)
		
		self.EditBox.GetTextHighlight = MultilineEditBoxGetTextHighlight
		
		self.Font = Widget_Font
		self.OnChange = Widget_OnChange
		self.Hyperlinks = Widget_Hyperlinks
		self.ToTop = Widget_ToTop
		self.SetText = Widget_SetText
		self.GetTextHighlight = Widget_GetTextHighlight
		
		return self
	end
	function ELib.CreateMultilineEditBox(parent,width,height,relativePoint,x,y)	--Old
		return ELib:MultiEdit(parent):Size(width,height):Point(relativePoint or "TOPLEFT",x,y)
	end
	
	local function MultilineEditBox2OnTextChanged(self,...)
		local parent = self.Parent
		local height = self:GetHeight()
		
		parent:SetNewHeight( max( height,parent:GetHeight() ) )
		if parent.OnTextChanged then
			parent.OnTextChanged(self,...)
		elseif self.OnTextChanged then
			self:OnTextChanged(...)
		end
	end
	local function ScrollFrameChangeHeight(self,newHeight)
		self.content:SetHeight(newHeight)
		return self
	end
	function ELib:MultiEdit2(parent)
		local self = ELib:MultiEdit(parent)
		self.EditBox:OnChange(MultilineEditBox2OnTextChanged)
		self.EditBox:SetScript("OnCursorChanged",nil)
		self.SetNewHeight = ScrollFrameChangeHeight
		self.Height = ScrollFrameChangeHeight
		return self
	end
end

do
	local function Widget_Texture(self,texture,layer,cB,cA,altLayer)
		if not self.texture then
			self.texture = self:CreateTexture(nil, altLayer or (type(layer)~='number' and layer) or "BACKGROUND")
			Mod(self.texture)
		end
		if type(texture)=='number' then
			self.texture:SetTexture(texture,layer,cB,cA)
		else
			self.texture:SetTexture(texture or "")
		end
		return self
	end
	local function Widget_TexturePoint(self,...)
		self.texture:Point(...)
		return self
	end
	local function Widget_TextureSize(self,...)
		self.texture:Size(...)
		return self
	end
	function ELib:Frame(parent,template)
		local self = CreateFrame('Frame',nil,parent or UIParent,template)
		Mod(self,
			'Texture',Widget_Texture,
			'TexturePoint',Widget_TexturePoint,
			'TextureSize',Widget_TextureSize
		)
		return self
	end
end

do
	function ELib:Border(parent,size,colorR,colorG,colorB,colorA,outside,layerCounter)
		outside = outside or 0
		layerCounter = layerCounter or ""
		if size == 0 then
			if parent["border_top"..layerCounter] then
				parent["border_top"..layerCounter]:Hide()
				parent["border_bottom"..layerCounter]:Hide()
				parent["border_left"..layerCounter]:Hide()
				parent["border_right"..layerCounter]:Hide()
			end
			return
		end
		
		local top = parent["border_top"..layerCounter] or parent:CreateTexture(nil, "BORDER")
		local bottom = parent["border_bottom"..layerCounter] or parent:CreateTexture(nil, "BORDER")
		local left = parent["border_left"..layerCounter] or parent:CreateTexture(nil, "BORDER")
		local right = parent["border_right"..layerCounter] or parent:CreateTexture(nil, "BORDER")

		parent["border_top"..layerCounter] = top
		parent["border_bottom"..layerCounter] = bottom
		parent["border_left"..layerCounter] = left
		parent["border_right"..layerCounter] = right
	
		top:ClearAllPoints()
		bottom:ClearAllPoints()
		left:ClearAllPoints()
		right:ClearAllPoints()
		
		top:SetPoint("TOPLEFT",parent,"TOPLEFT",-size-outside,size+outside)
		top:SetPoint("BOTTOMRIGHT",parent,"TOPRIGHT",size+outside,outside)
	
		bottom:SetPoint("BOTTOMLEFT",parent,"BOTTOMLEFT",-size-outside,-size-outside)
		bottom:SetPoint("TOPRIGHT",parent,"BOTTOMRIGHT",size+outside,-outside)
	
		left:SetPoint("TOPLEFT",parent,"TOPLEFT",-size-outside,outside)
		left:SetPoint("BOTTOMRIGHT",parent,"BOTTOMLEFT",-outside,-outside)
	
		right:SetPoint("TOPLEFT",parent,"TOPRIGHT",outside,outside)
		right:SetPoint("BOTTOMRIGHT",parent,"BOTTOMRIGHT",size+outside,-outside)
	
		top:SetTexture(colorR,colorG,colorB,colorA)
		bottom:SetTexture(colorR,colorG,colorB,colorA)
		left:SetTexture(colorR,colorG,colorB,colorA)
		right:SetTexture(colorR,colorG,colorB,colorA)
	
		top:Show()
		bottom:Show()
		left:Show()
		right:Show()
	end
end