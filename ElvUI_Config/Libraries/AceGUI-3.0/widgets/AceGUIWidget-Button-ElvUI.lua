--[[-----------------------------------------------------------------------------
Button Widget (Modified to change text color on SetDisabled method)
Graphical Button.
-------------------------------------------------------------------------------]]
local Type, Version = "Button-ElvUI", 2
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs = pairs

-- WoW APIs
local _G = _G
local PlaySound, CreateFrame, UIParent = PlaySound, CreateFrame, UIParent
local IsShiftKeyDown = IsShiftKeyDown
local PlaySoundKitID = PlaySoundKitID
-- GLOBALS: GameTooltip, ElvUI

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local dragdropButton
local function lockTooltip()
	GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
	GameTooltip:SetText(" ")
	GameTooltip:Show()
end
local function dragdrop_OnMouseDown(frame, ...)
	if frame.obj.dragOnMouseDown then
		dragdropButton.mouseDownFrame = frame
		dragdropButton:SetText(frame.obj.value or "Unknown")
		dragdropButton:SetSize(frame:GetSize())
		frame.obj.dragOnMouseDown(frame, ...)
	end
end
local function dragdrop_OnMouseUp(frame, ...)
	if frame.obj.dragOnMouseUp then
		frame:SetAlpha(1)
		GameTooltip:Hide()
		dragdropButton:Hide()
		if dragdropButton.enteredFrame and dragdropButton.enteredFrame ~= frame and dragdropButton.enteredFrame:IsMouseOver() then
			frame.obj.dragOnMouseUp(frame, ...)
			frame.obj.ActivateMultiControl(frame.obj, ...)
		end
		dragdropButton.enteredFrame = nil
		dragdropButton.mouseDownFrame = nil
	end
end
local function dragdrop_OnLeave(frame, ...)
	if frame.obj.dragOnLeave then
		if dragdropButton.mouseDownFrame then
			lockTooltip()
		end
		if frame == dragdropButton.mouseDownFrame then
			frame:SetAlpha(0)
			dragdropButton:Show()
			frame.obj.dragOnLeave(frame, ...)
		end
	end
end
local function dragdrop_OnEnter(frame, ...)
	if frame.obj.dragOnEnter and dragdropButton:IsShown() then
		dragdropButton.enteredFrame = frame
		lockTooltip()
		frame.obj.dragOnEnter(frame, ...)
	end
end
local function dragdrop_OnClick(frame, ...)
	local button = ...
	if frame.obj.dragOnClick and button == "RightButton" then
		frame.obj.dragOnClick(frame, ...)
		frame.obj.ActivateMultiControl(frame.obj, ...)
	elseif frame.obj.stateSwitchOnClick and (button == "LeftButton") and IsShiftKeyDown() then
		frame.obj.stateSwitchOnClick(frame, ...)
		frame.obj.ActivateMultiControl(frame.obj, ...)
	end
end

local function Button_OnClick(frame, ...)
	AceGUI:ClearFocus()
	PlaySound(PlaySoundKitID and "igMainMenuOption" or 852) -- SOUNDKIT.IG_MAINMENU_OPTION
	frame.obj:Fire("OnClick", ...)
end

local function Control_OnEnter(frame)
	frame.obj:Fire("OnEnter")
end

local function Control_OnLeave(frame)
	frame.obj:Fire("OnLeave")
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		-- restore default values
		self:SetHeight(24)
		self:SetWidth(200)
		self:SetDisabled(false)
		self:SetAutoWidth(false)
		self:SetText()
	end,

	-- ["OnRelease"] = nil,

	["SetText"] = function(self, text)
		self.text:SetText(text)
		if self.autoWidth then
			self:SetWidth(self.text:GetStringWidth() + 30)
		end
	end,
	
	["SetAutoWidth"] = function(self, autoWidth)
		self.autoWidth = autoWidth
		if self.autoWidth then
			self:SetWidth(self.text:GetStringWidth() + 30)
		end
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.frame:Disable()
			self.text:SetTextColor(0.4, 0.4, 0.4)
		else
			self.frame:Enable()
			self.text:SetTextColor(1, 0.82, 0)
		end
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local name = "AceGUI30Button" .. AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Button", name, UIParent, "UIPanelButtonTemplate")
	frame:Hide()
	frame:EnableMouse(true)
	frame:RegisterForClicks("AnyUp")
	frame:SetScript("OnClick", Button_OnClick)
	frame:SetScript("OnEnter", Control_OnEnter)
	frame:SetScript("OnLeave", Control_OnLeave)

	-- dragdrop
	if not dragdropButton then
		dragdropButton = CreateFrame("Button", "ElvUIAceGUI30DragDropButton", UIParent, "UIPanelButtonTemplate")
		dragdropButton:SetFrameStrata("TOOLTIP")
		dragdropButton:SetFrameLevel(5)
		dragdropButton:SetPoint('BOTTOM', GameTooltip, "BOTTOM", 0, 10)
		dragdropButton:Hide()
		ElvUI[1]:GetModule('Skins'):HandleButton(dragdropButton)
	end
	frame:HookScript("OnClick", dragdrop_OnClick)
	frame:HookScript("OnEnter", dragdrop_OnEnter)
	frame:HookScript("OnLeave", dragdrop_OnLeave)
	frame:HookScript("OnMouseUp", dragdrop_OnMouseUp)
	frame:HookScript("OnMouseDown", dragdrop_OnMouseDown)

	local text = frame:GetFontString()
	text:ClearAllPoints()
	text:SetPoint("TOPLEFT", 15, -1)
	text:SetPoint("BOTTOMRIGHT", -15, 1)
	text:SetJustifyV("MIDDLE")

	local widget = {
		text  = text,
		frame = frame,
		type  = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
