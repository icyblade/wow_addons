--[[ File
NAME:TitanAutoHide.lua
DESC: Contains the routines of AutoHide Titan plugin to auto hide a Titan bar.

Auto hide uses a data driven approach. Rather than seperate routines for each bar, auto hide is implemented in a general manner. 
The tables TitanBarData & AutoHideData hold relevant data needed to control auto hide. 
The index into AutoHideData is the plugin button name given in TitanPanel.xml.

If auto hide is turned on these routines will show / hide the proper bar (and plugins on the bar).
These routines control the 'push pin' on each bar, if shown.
:DESC
--]]
local AceTimer = LibStub("AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Titan", true)
local Dewdrop = nil
if AceLibrary and AceLibrary:HasInstance("Dewdrop-2.0") then Dewdrop = AceLibrary("Dewdrop-2.0") end

-- local routines
--[[ local
NAME: Titan_AutoHide_SetIcon
DESC: Set the icon for the plugin.
VAR: self - The bar
OUT: None
--]]
local function Titan_AutoHide_SetIcon(self)
	local frame = self:GetName()
	local bar = AutoHideData[frame].name

	-- Get the icon of the icon template
	local icon = _G[frame.."Icon"]
	if (TitanPanelGetVar(bar.."_Hide")) then
		icon:SetTexture("Interface\\AddOns\\Titan\\Artwork\\TitanPanelPushpinOut")
	else
		icon:SetTexture("Interface\\AddOns\\Titan\\Artwork\\TitanPanelPushpinIn")
	end	
end

-- Event handlers
--[[ Titan
NAME: Titan_AutoHide_OnLoad
DESC: Setup the plugin on the given bar.
VAR: self - The bar
OUT: None
--]]
function Titan_AutoHide_OnLoad(self)
	local frame = self:GetName()
	local bar = AutoHideData[frame].name

	self.registry = {
		id = "AutoHide_"..bar,
		category = "Built-ins",
		version = TITAN_VERSION,
		menuText = "AutoHide_"..bar,
		tooltipTitle = L["TITAN_AUTOHIDE_TOOLTIP"],
		savedVariables = {
			DisplayOnRightSide = 1,
			ForceBar = bar,
		}
	};
end

--[[ Titan
NAME: Titan_AutoHide_OnShow
DESC: Show the plugin on the given bar.
VAR: self - The bar
OUT: None
--]]
function Titan_AutoHide_OnShow(self)
	Titan_AutoHide_SetIcon(self)	
end

--[[ Titan
NAME: Titan_AutoHide_OnClick
DESC: Handle button clicks on the given bar.
VAR: self - The bar
VAR: button - The mouse button clicked
OUT:  None
--]]
function Titan_AutoHide_OnClick(self, button)
	if (button == "LeftButton") then
		Titan_AutoHide_ToggleAutoHide(self);
	end
end

-- Auto hide routines
--[[ Titan
NAME: Titan_AutoHide_Timers
DESC: This routine accepts the display bar frame and whether the cursor is entering or leaving. On enter kill the timers that are looking to hide the bar. On leave start the timer to hide the bar.
VAR: frame - The bar
VAR: action - "Enter" | "Leave"
OUT:  None
--]]
function Titan_AutoHide_Timers(frame, action)
	if not frame or not action then
		return
	end
	local bar = (TitanBarData[frame] and TitanBarData[frame].name or nil)
	local hide = (bar and TitanPanelGetVar(bar.."_Hide") or nil)
	
	if bar and hide then
		if (action == "Enter") then
				AceTimer.CancelAllTimers(frame)
		end
		if (action == "Leave") then
			-- pass the bar as an arg so we can get it back
			AceTimer.ScheduleRepeatingTimer(frame, Handle_OnUpdateAutoHide, 0.5, frame)
		end
	end
end

--[[ Titan
NAME: Titan_AutoHide_Init
DESC: Show / hide the given bar per the user requested settings
VAR: self - The bar
OUT: None
--]]
function Titan_AutoHide_Init(self)
	if not self then return end -- sanity check
	
	local frame = self:GetName()
	if frame then -- sanity check
		local bar = AutoHideData[frame].name

		-- Make sure the bar should be processed
		if (TitanPanelGetVar(bar.."_Show")) then
			-- Hide / show the bar the plugin is on
			if (TitanPanelGetVar(bar.."_Hide")) then
				TitanPanelBarButton_Hide(TITAN_PANEL_DISPLAY_PREFIX..bar);
			else
				TitanPanelBarButton_Show(TITAN_PANEL_DISPLAY_PREFIX..bar);
			end
		else
			TitanPanelBarButton_Hide(TITAN_PANEL_DISPLAY_PREFIX..bar);
		end
		Titan_AutoHide_SetIcon(self)
	end
end

--[[ Titan
NAME: Titan_AutoHide_ToggleAutoHide
DESC: Toggle the user requested show / hide setting then show / hide given bar
VAR: self - The bar
OUT: None
--]]
function Titan_AutoHide_ToggleAutoHide(self)
	local frame = self:GetName()
	local bar = AutoHideData[frame].name

	-- toggle the correct auto hide variable
	TitanPanelToggleVar(bar.."_Hide")
	-- Hide / show the requested bar
	Titan_AutoHide_Init(self)
end

--[[ Titan
NAME: Handle_OnUpdateAutoHide
DESC: Hide the bar if the user has auto hide after the cursor leaves the display bar.
VAR: frame - The bar
OUT: None
--]]
function Handle_OnUpdateAutoHide(frame)
	if TitanPanelRightClickMenu_IsVisible() 
	or (Tablet20Frame and Tablet20Frame:IsVisible()) 
	or (Dewdrop and Dewdrop:IsOpen())then
		return
	end
	
	local data = TitanBarData[frame] or nil
	if not data then -- sanity check
		return
	end
	local bar = (data.name or nil)
	
	local hide = TitanPanelGetVar(bar.."_Hide")
	-- 
	if hide then
		AceTimer.CancelAllTimers(frame)
		TitanPanelBarButton_Hide(frame)
	end
end
