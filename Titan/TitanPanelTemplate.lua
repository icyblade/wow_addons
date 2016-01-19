--[[ File
NAME: TitanPanelTemplate.lua
DESC: Contains the routines to handle a frame created as a Titan plugin.
--]]
--[[ API
NAME: TitanPanelTemplate overview
DESC: See TitanPanelButtonTemplate.xml also.

A Titan plugin is a frame created using one of the button types in TitanPanelButtonTemplate.xml which inherits TitanPanelButtonTemplate.
The available plugin types are:
TitanPanelTextTemplate - A frame that only displays text ("$parentText")
TitanPanelIconTemplate - A frame that only displays an icon ("$parentIcon")
TitanPanelComboTemplate - A frame that displays an icon then text ("$parentIcon"  "$parentText")

Most plugins use the combo template.

TitanPanelButtonTemplate.xml contains other templates available to be used.
TitanOptionsSliderTemplate - A frame that contains the basics of a slider control. See TitanVolume for an example.
TitanPanelChildButtonTemplate - A frame that allows a plugin within a plugin. The older version of TitanGold was an example. This may not be used anymore.

Each template contains:
- a frame to handle a menu invoked by a right mouse click ("$parentRightClickMenu")
- default event handlers for
			<OnLoad>
				TitanPanelButton_OnLoad(self);
			</OnLoad>
			<OnShow>
				TitanPanelButton_OnShow(self);
			</OnShow>
			<OnClick>
				TitanPanelButton_OnClick(self, button);
			</OnClick>
			<OnEnter>
				TitanPanelButton_OnEnter(self);
			</OnEnter>
			<OnLeave>
				TitanPanelButton_OnLeave(self);
			</OnLeave>					
If these events are overridden then the default routine needs to be included!
:DESC
--]]

-- Globals

-- Constants
local TITAN_PANEL_LABEL_SEPARATOR = "  "
local TITAN_PANEL_BUTTON_WIDTH_CHANGE_TOLERANCE = 10;
local TITAN_PANEL_BUTTON_TYPE_TEXT = 1;
local TITAN_PANEL_BUTTON_TYPE_ICON = 2;
local TITAN_PANEL_BUTTON_TYPE_COMBO = 3;
local TITAN_PANEL_BUTTON_TYPE_CUSTOM = 4;
local pluginOnEnter = nil;
local TITAN_PANEL_MOVE_ADDON = nil;
local TITAN_PANEL_DROPOFF_ADDON = nil;

-- Library instances
local LibQTip = nil
local _G = getfenv(0);
local InCombatLockdown	= _G.InCombatLockdown;
local media = LibStub("LibSharedMedia-3.0")

--[[ local
NAME: TitanTooltip_AddTooltipText
DESC: Helper to add a line of tooltip text to the tooltip.
VAR:  text - string
OUT:  None
NOTE:
- Append a "\n" to the end if there is not one already there
:NOTE
--]]
local function TitanTooltip_AddTooltipText(text)
	if ( text ) then
		-- Append a "\n" to the end 
		if ( string.sub(text, -1, -1) ~= "\n" ) then
			text = text.."\n";
		end
		
		-- See if the string is intended for a double column
		for text1, text2 in string.gmatch(text, "([^\t\n]*)\t?([^\t\n]*)\n") do
			if ( text2 ~= "" ) then
				-- Add as double wide
				GameTooltip:AddDoubleLine(text1, text2);
			elseif ( text1 ~= "" ) then
				-- Add single column line
				GameTooltip:AddLine(text1);
			else
				-- Assume a blank line
				GameTooltip:AddLine("\n");
			end			
		end
	end
end

--[[ local
NAME: TitanTooltip_SetOwnerPosition
DESC: Set both the parent and the position of GameTooltip for the plugin tooltip.
VAR: parent - reference to the frame to attach the tooltip to
VAR: anchorPoint - tooltip anchor location (side or corner) to use
VAR: relativeToFrame - string name name of the frame, usually the plugin), to attach the tooltip to
VAR: relativePoint - parent anchor location (side or corner) to use
VAR: xOffset - X offset from the anchor point
VAR: yOffset - Y offset from the anchor point
VAR: frame - reference to the tooltip
OUT:  None
--]]
local function TitanTooltip_SetOwnerPosition(parent, anchorPoint, relativeToFrame, relativePoint, xOffset, yOffset, frame)
	if not frame then
		frame = _G["GameTooltip"]
	end
	frame:SetOwner(parent, "ANCHOR_NONE");
	frame:SetPoint(anchorPoint, relativeToFrame, relativePoint, 
		xOffset, yOffset);
	-- set alpha (transparency) for the Game Tooltip
	local red, green, blue = frame:GetBackdropColor();
	local red2, green2, blue2 = frame:GetBackdropBorderColor();
	local tool_trans = TitanPanelGetVar("TooltipTrans")
	frame:SetBackdropColor(red,green,blue,tool_trans);
	frame:SetBackdropBorderColor(red2,green2,blue2,tool_trans);
	-- set font size for the Game Tooltip
	if not TitanPanelGetVar("DisableTooltipFont") then
		if TitanTooltipScaleSet < 1 then
		TitanTooltipOrigScale = frame:GetScale();
		TitanTooltipScaleSet = TitanTooltipScaleSet + 1;
		end
		frame:SetScale(TitanPanelGetVar("TooltipFont"));
	end
end

--[[ local
NAME: TitanTooltip_SetGameTooltip
DESC: Helper to set the tooltip of the given Titan plugin.
First check for a custom function. If no function then use the plugin tooltip title and text.
VAR: self - frame reference of the plugin
OUT:  None
NOTE:
- If a custom function is given pcall (protected call) is used in case the function errors out. Currently the error is allowed to occur silently because it could generate a lot of text to chat.
:NOTE
--]]
local function TitanTooltip_SetGameTooltip(self)
	if ( self.tooltipCustomFunction ) then
--[
		local tmp_txt = ""
		local call_success
		call_success, -- for pcall
			tmp_txt = pcall (self.tooltipCustomFunction)
--]]
--		self.tooltipCustomFunction();
	elseif ( self.tooltipTitle ) then
		GameTooltip:SetText(self.tooltipTitle, 
			HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);	
		if ( self.tooltipText ) then
			TitanTooltip_AddTooltipText(self.tooltipText);
		end
	end

	GameTooltip:Show();
end

--[[ local
NAME: TitanTooltip_SetPanelTooltip
DESC: Helper to set the screen position of the tooltip of the given Titan plugin.
VAR: self - frame reference of the plugin
VAR: id - string name of the plugin
VAR: frame - reference to the tooltip
OUT:  None
--]]
local function TitanTooltip_SetPanelTooltip(self, id, frame)
	-- sanity checks
	if not TitanPanelGetVar("ToolTipsShown") 
	or (TitanPanelGetVar("HideTipsInCombat") and InCombatLockdown()) then return end

	if not self.tooltipCustomFunction and not self.tooltipTitle then return end

	-- Set GameTooltip
	local button = TitanUtils_GetButton(id);
	local scale = TitanPanelGetVar("Scale");	
	local offscreenX, offscreenY;
	local i = TitanPanel_GetButtonNumber(id);
	local bar = TITAN_PANEL_DISPLAY_PREFIX..TitanUtils_GetWhichBar(id)
	local vert = TitanBarData[bar].vert
	-- Get TOP or BOTTOM for the anchor and relative anchor
	local rel_pt, pt
	if vert == TITAN_TOP then
		pt = "TOP"
		rel_pt = "BOTTOM"
	else
		pt = "BOTTOM"
		rel_pt = "TOP"
	end

	TitanTooltip_SetOwnerPosition(button, pt.."LEFT", 
		button:GetName(), rel_pt.."LEFT", -10, 0, frame) --4 * scale);
	TitanTooltip_SetGameTooltip(self);

	-- Adjust GameTooltip position if it's off the screen
	offscreenX, offscreenY = TitanUtils_GetOffscreen(GameTooltip);
	if ( offscreenX == -1 ) then
		TitanTooltip_SetOwnerPosition(button, pt.."LEFT", bar, 
			rel_pt.."LEFT", 0, 0, frame)
		TitanTooltip_SetGameTooltip(self);	
	elseif ( offscreenX == 1 ) then
		TitanTooltip_SetOwnerPosition(button, pt.."RIGHT", bar, 
			rel_pt.."RIGHT", 0, 0, frame)
		TitanTooltip_SetGameTooltip(self);	
	end
end

--[[ local
NAME: TitanPanelButton_SetTooltip
DESC: Set the tooltip of the given Titan plugin.
VAR: self - frame reference of the plugin
VAR: id - string name of the plugin
--]]
local function TitanPanelButton_SetTooltip(self, id)
	-- ensure that the 'self' passed is a valid frame reference
	if not self:GetName() then return end

	self.tooltipCustomFunction = nil;
	if (id and TitanUtils_IsPluginRegistered(id)) then
		local plugin = TitanUtils_GetPlugin(id);		
		if ( plugin.tooltipCustomFunction ) then
			self.tooltipCustomFunction = plugin.tooltipCustomFunction;
			TitanTooltip_SetPanelTooltip(self, id);
		elseif ( plugin.tooltipTitle ) then
			self.tooltipTitle = plugin.tooltipTitle;			
			local tooltipTextFunc = _G[plugin.tooltipTextFunction];
			if ( tooltipTextFunc ) then
				local tmp_txt = ""
				local call_success, -- for pcall
					tmp_txt = pcall (tooltipTextFunc);
				self.tooltipText = tmp_txt
--				self.tooltipText = tooltipTextFunc();
			end
			TitanTooltip_SetPanelTooltip(self, id);
		end
	end
end

--[[ local
NAME: TitanPanelButton_IsText
DESC: Is the given Titan plugin of type text?
VAR: id - string name of the plugin
OUT: boolean
--]]
local function TitanPanelButton_IsText(id)
	if (TitanPanelButton_GetType(id) == TITAN_PANEL_BUTTON_TYPE_TEXT) then
		return 1;
	end
end

--[[ Titan
NAME: TitanPanelButton_IsIcon
DESC: Is the given Titan plugin of type icon?
VAR: id - string name of the plugin
OUT: boolean
--]]
function TitanPanelButton_IsIcon(id)
	if (TitanPanelButton_GetType(id) == TITAN_PANEL_BUTTON_TYPE_ICON) then
		return 1;
	end
end

--[[ local
NAME: TitanPanelButton_IsCombo
DESC: Is the given Titan plugin of type combo?
VAR:  id - string name of the plugin
OUT: boolean
--]]
local function TitanPanelButton_IsCombo(id)
	if (TitanPanelButton_GetType(id) == TITAN_PANEL_BUTTON_TYPE_COMBO) then
		return 1;
	end
end

--[[ local
NAME: TitanPanelButton_IsCustom
DESC: Is the given Titan plugin of type custom?
VAR: id - string name of the plugin
OUT: boolean
--]]
local function TitanPanelButton_IsCustom(id)
	if (TitanPanelButton_GetType(id) == TITAN_PANEL_BUTTON_TYPE_CUSTOM) then
		return 1;
	end
end

--[[ local
NAME: TitanPanelButton_OnDragStart
DESC: Handle the OnDragStart event of the given Titan plugin.
VAR:  self - frame reference of the plugin
VAR: ChildButton - boolean
OUT:  None
NOTE:
- Do nothing if the user has locked plugins or if in combat.
- Set the .isMoving of the plugin (frame) so other routine can check it.
- Set TITAN_PANEL_MOVING so any Titan routine will know a 'drag & drop' is in progress.
- Set TITAN_PANEL_MOVE_ADDON so sanity checks can be done on the 'drop'.
:NOTE
--]]
local function TitanPanelButton_OnDragStart(self, ChildButton)
	if TitanPanelGetVar("LockButtons") or InCombatLockdown() then return end
	
	local frname = self;
	if ChildButton then	  
		frname = self:GetParent();
	end

	-- Clear button positions or we'll grab the button and all buttons 'after'
	local i,j;
	for i, j in pairs(TitanPanelSettings.Buttons) do
		local pluginid = _G["TitanPanel"..TitanPanelSettings.Buttons[i].."Button"];
		if pluginid then 
			pluginid:ClearAllPoints() 
		end
	end

	-- Start the drag; close any tooltips and open control frames
	frname:StartMoving();
	frname.isMoving = true;		
	TitanUtils_CloseAllControlFrames();
	TitanPanelRightClickMenu_Close();
	if AceLibrary then
		if AceLibrary:HasInstance("Dewdrop-2.0") then 
			AceLibrary("Dewdrop-2.0"):Close() 
		end
		if AceLibrary:HasInstance("Tablet-2.0") then 
			AceLibrary("Tablet-2.0"):Close() 
		end
	end
	GameTooltip:Hide();
	-- LibQTip-1.0 support code
	LibQTip = LibStub("LibQTip-1.0", true)
	if LibQTip then
		local key, tip
		for key, tip in LibQTip:IterateTooltips() do
			if tip then
				local _, relativeTo = tip:GetPoint()
					if relativeTo and relativeTo:GetName() == self:GetName() then
						tip:Hide()
						break
					end
			end
		end
	end
	-- /LibQTip-1.0 support code
	
	-- Hold the plugin id so we can do checks on the drop
	TITAN_PANEL_MOVE_ADDON = TitanUtils_GetButtonID(self:GetName());
	if ChildButton then
		TITAN_PANEL_MOVE_ADDON = 
			TitanUtils_GetButtonID(self:GetParent():GetName());
	end
	-- Tell Titan that a drag & drop is in process
	TITAN_PANEL_MOVING = 1;
	-- Store the OnEnter handler so the tooltip does not show - or other oddities
	pluginOnEnter = self:GetScript("OnEnter")
	self:SetScript("OnEnter", nil)
end

--[[ local
NAME: TitanPanelButton_OnDragStop
DESC: Handle the OnDragStop event of the given Titan plugin.
VAR: self - frame reference of the plugin
VAR: ChildButton - boolean
OUT:  None
NOTE:
- Clear the .isMoving of the plugin (frame).
- Clear TITAN_PANEL_MOVING.
- Clear TITAN_PANEL_MOVE_ADDON.
:NOTE
--]]
local function TitanPanelButton_OnDragStop(self, ChildButton)
	if TitanPanelGetVar("LockButtons") then 
		return
	end
	local ok_to_move = true
	local nonmovableFrom = false;
	local nonmovableTo = false;
	local frname = self;
	if ChildButton then	  
		frname = self:GetParent();
	end
	if TITAN_PANEL_MOVING == 1 then
		frname:StopMovingOrSizing();
		frname.isMoving = false;
		TITAN_PANEL_MOVING = 0;
		
		-- See if the plugin is supposed to stay on the bar it is on
		if TitanGetVar(TITAN_PANEL_MOVE_ADDON, "ForceBar") then
			ok_to_move = false
		end
		
		-- eventually there could be several reasons to not allow
		-- the plugin to move
		if ok_to_move then
			local i,j;
			for i, j in pairs(TitanPanelSettings.Buttons) do
				local pluginid = 
					_G["TitanPanel"..TitanPanelSettings.Buttons[i].."Button"];
				if (pluginid and MouseIsOver(pluginid)) and frname ~= pluginid then
					TITAN_PANEL_DROPOFF_ADDON = TitanPanelSettings.Buttons[i];	  		
				end
			end

			-- switching sides is not allowed
			nonmovableFrom = TitanUtils_ToRight(TITAN_PANEL_MOVE_ADDON)
			nonmovableTo = TitanUtils_ToRight(TITAN_PANEL_DROPOFF_ADDON)
			if nonmovableTo ~= nonmovableFrom then
				TITAN_PANEL_DROPOFF_ADDON = nil;
			end
			
			if TITAN_PANEL_DROPOFF_ADDON == nil then
				-- See if the plugin was dropped on a bar rather than
				-- another plugin.
				local bar
				local tbar = nil
				-- Find which bar it was dropped on
				for idx,v in pairs(TitanBarData) do
					bar = idx
					if (bar and MouseIsOver(_G[bar])) then
						tbar = bar
					end
				end

				if tbar then
					TitanPanel_RemoveButton(TITAN_PANEL_MOVE_ADDON)
					TitanUtils_AddButtonOnBar(TitanBarData[tbar].name, TITAN_PANEL_MOVE_ADDON)
				else
					-- not sure what the user did...
				end
			else
				-- plugin was dropped on another plugin - swap (for now)
				local dropoff = TitanUtils_GetCurrentIndex(TitanPanelSettings.Buttons
					,TITAN_PANEL_DROPOFF_ADDON);
				local pickup = TitanUtils_GetCurrentIndex(TitanPanelSettings.Buttons
					,TITAN_PANEL_MOVE_ADDON);
				local dropoffbar = TitanUtils_GetWhichBar(TITAN_PANEL_DROPOFF_ADDON);
				local pickupbar = TitanUtils_GetWhichBar(TITAN_PANEL_MOVE_ADDON);

				if dropoff ~= nil and dropoff ~= "" then
		-- TODO: Change to 'insert' rather than swap
					TitanPanelSettings.Buttons[dropoff] = TITAN_PANEL_MOVE_ADDON;
					TitanPanelSettings.Location[dropoff] = dropoffbar;
					TitanPanelSettings.Buttons[pickup] = TITAN_PANEL_DROPOFF_ADDON;
					TitanPanelSettings.Location[pickup] = pickupbar;
				end	
			end
		end

		-- This is important! The start drag cleared the button positions so
		-- the buttons need to be put back properly.
		TitanPanel_InitPanelButtons();
		TITAN_PANEL_MOVE_ADDON = nil;
		TITAN_PANEL_DROPOFF_ADDON = nil;
		-- Restore the OnEnter script handler
		if pluginOnEnter then self:SetScript("OnEnter", pluginOnEnter) end
		pluginOnEnter = nil;
	end
end

--[[ local
NAME: TitanTooltip_SetOwnerPosition
DESC: Set both the parent and the position of GameTooltip for the plugin tooltip.
VAR: parent - reference to the frame to attach the tooltip to
VAR: anchorPoint - tooltip anchor location (side or corner) to use
VAR: relativeToFrame - string name name of the frame, usually the plugin), to attach the tooltip to
VAR: relativePoint - parent anchor location (side or corner) to use
VAR: xOffset - X offset from the anchor point
VAR: yOffset - Y offset from the anchor point
VAR: frame - reference to the tooltip
OUT:  None
--]]
local function TitanTooltip_SetOwnerPosition(parent, anchorPoint, relativeToFrame, relativePoint, xOffset, yOffset, frame)
	if not frame then
		frame = _G["GameTooltip"]
	end
	frame:SetOwner(parent, "ANCHOR_NONE");
	frame:SetPoint(anchorPoint, relativeToFrame, relativePoint, 
		xOffset, yOffset);
	-- set alpha (transparency) for the Game Tooltip
	local red, green, blue = frame:GetBackdropColor();
	local red2, green2, blue2 = frame:GetBackdropBorderColor();
	local tool_trans = TitanPanelGetVar("TooltipTrans")
	frame:SetBackdropColor(red,green,blue,tool_trans);
	frame:SetBackdropBorderColor(red2,green2,blue2,tool_trans);
	-- set font size for the Game Tooltip
	if not TitanPanelGetVar("DisableTooltipFont") then
		if TitanTooltipScaleSet < 1 then
		TitanTooltipOrigScale = frame:GetScale();
		TitanTooltipScaleSet = TitanTooltipScaleSet + 1;
		end
		frame:SetScale(TitanPanelGetVar("TooltipFont"));
	end
end

--[[ API
NAME: TitanOptionSlider_TooltipText
DESC: Set the color of the tooltip text to normal (white) with the value in green.
VAR: text - the label for value
VAR: value - the value
OUT: string - encoded color string of text and value
--]]
function TitanOptionSlider_TooltipText(text, value) 
	return text .. GREEN_FONT_COLOR_CODE .. value .. FONT_COLOR_CODE_CLOSE;
end

--[[ API
NAME: TitanPanelButton_OnLoad
DESC: Handle the OnLoad event of the requested Titan plugin. Ensure the plugin is set to be registered.
VAR: isChildButton - boolean
NOTE:
- This is called from the Titan plugin frame in the OnLoad event - usually as the frame is created.
- This starts the plugin registration process. See TitanUtils for more details on plugin registration.
- The plugin registration is a two step process because not all addons create Titan plugins in the frame create. The Titan feature of converting LDB addons to Titan plugins is an example.
:NOTE
--]]
function TitanPanelButton_OnLoad(self, isChildButton) -- Used by plugins
	TitanUtils_PluginToRegister(self, isChildButton)
end

--[[ API
NAME: TitanPanelPluginHandle_OnUpdate
DESC: A method to refresh the display of a Titan plugin.
VAR: table - the frame of the plugin
VAR: oldarg - nil or command
NOTE:
- This is used by some plugins. It is not used within Titan.
- The expected usage is either:
1) Table contains {<plugin id>, <update command>}
2) table = <plugin id> and oldarg = <update command>
- oldarg - nil or command
1 = refresh button
2 = refresh tooltip
3 = refresh button and tooltip
:NOTE
--]]
function TitanPanelPluginHandle_OnUpdate(table, oldarg) -- Used by plugins
	local id, updateType = nil, nil
	-- set the id and updateType
	-- old method
	if table and type(table) == "string" and oldarg then
		id = table
		updateType = oldarg
	end
	-- new method
	if table and type(table) == "table" then
		if table[1] then id = table[1] end
		if table[2] then updateType = table[2] end
	end

	-- id is required
	if id then
		if updateType == TITAN_PANEL_UPDATE_BUTTON 
		or updateType == TITAN_PANEL_UPDATE_ALL then
			TitanPanelButton_UpdateButton(id)
		end

		if (updateType == TITAN_PANEL_UPDATE_TOOLTIP 
		or updateType == TITAN_PANEL_UPDATE_ALL) 
		and MouseIsOver(_G["TitanPanel"..id.."Button"]) then			
			if TitanPanelRightClickMenu_IsVisible() or TITAN_PANEL_MOVING == 1 then
				return 
			end
			TitanPanelButton_SetTooltip(_G["TitanPanel"..id.."Button"], id)   			
		end
	end
end

--[[ API
NAME: TitanPanelDetectPluginMethod
DESC: Poorly named routine that sets the OnDragStart & OnDragStop scripts of a Titan plugin.
VAR: id - the string name of the plugin
VAR: isChildButton - boolean
--]]
function TitanPanelDetectPluginMethod(id, isChildButton)
	-- Ensure the id is not nil
	if not id then return end
	local TitanPluginframe = _G["TitanPanel"..id.."Button"];
	if isChildButton then
		TitanPluginframe = _G[id];
	end
	-- Ensure the frame is valid
	if not TitanPluginframe and TitanPluginframe:GetName() then return end -- sanity check...
	
	-- Set the OnDragStart script
	TitanPluginframe:SetScript("OnDragStart", function(self)
		if not IsShiftKeyDown() 
		and not IsControlKeyDown() 
		and not IsAltKeyDown() then			
			if isChildButton then
				TitanPanelButton_OnDragStart(self, true);
			else
				TitanPanelButton_OnDragStart(self);
			end
		end
	end)
	
	-- Set the OnDragStop script
	TitanPluginframe:SetScript("OnDragStop", function(self)		
		if isChildButton then
			TitanPanelButton_OnDragStop(self, true)
		else    	 		    	 		
			TitanPanelButton_OnDragStop(self);
		end		
	end)
end

--[[ API
NAME: TitanPanelButton_OnShow
DESC: Handle the OnShow event of the requested Titan plugin.
VAR:self - frame reference of the plugin
--]]
function TitanPanelButton_OnShow(self) -- Used by plugins
	local id = nil;
	-- ensure that the 'self' passed is a valid frame reference
	if self and self:GetName() then
		id = TitanUtils_GetButtonID(self:GetName());
	end
	-- ensure that id is a valid Titan plugin
	if (id) then		
		TitanPanelButton_UpdateButton(id, 1);
	end 
end

--[[ API
NAME: TitanPanelButton_OnClick
DESC: Handle the OnClick mouse event of the requested Titan plugin.
VAR: self - frame reference of the plugin
VAR: button - mouse button that was clicked
VAR: isChildButton - boolean
NOTE:
- Only the left and right mouse buttons are handled by Titan.
:NOTE
--]]
function TitanPanelButton_OnClick(self, button, isChildButton) -- Used by plugins
	local id
	-- ensure that the 'self' passed is a valid frame reference
	if self and self:GetName() then
		id = TitanUtils_Ternary(isChildButton, 
			TitanUtils_GetParentButtonID(self:GetName()), 
			TitanUtils_GetButtonID(self:GetName()));
	end
	
	if id then
		local controlFrame = TitanUtils_GetControlFrame(id);
		local rightClickMenu = _G["TitanPanelRightClickMenu"];
	
		if (button == "LeftButton") then
			local isControlFrameShown;
			if (not controlFrame) then
				isControlFrameShown = false;
			elseif (controlFrame:IsVisible()) then
				isControlFrameShown = false;
			else
				isControlFrameShown = true;
			end
			
			TitanUtils_CloseAllControlFrames();	
			TitanPanelRightClickMenu_Close();	
		
			local position = TitanUtils_GetWhichBar(id)
			local scale = TitanPanelGetVar("Scale");
			if (isControlFrameShown) then
				local buttonCenter = (self:GetLeft() + self:GetRight()) / 2 * scale;
				local controlFrameRight = buttonCenter + controlFrame:GetWidth() / 2;
				local y_off = TITAN_PANEL_BAR_HEIGHT * scale
				if ( position == TITAN_PANEL_PLACE_TOP ) then 
					controlFrame:ClearAllPoints();
					controlFrame:SetPoint("TOP", "UIParent", "TOPLEFT", buttonCenter, -y_off);	
					
					-- Adjust control frame position if it's off the screen
					local offscreenX, offscreenY = TitanUtils_GetOffscreen(controlFrame);
					if ( offscreenX == -1 ) then
						controlFrame:ClearAllPoints();
						controlFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, -y_off);	
					elseif ( offscreenX == 1 ) then
						controlFrame:ClearAllPoints();
						controlFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", 0, -y_off);	
					end							
				else
					controlFrame:ClearAllPoints();
					controlFrame:SetPoint("BOTTOM", "UIParent", "BOTTOMLEFT", buttonCenter, y_off); 

					-- Adjust control frame position if it's off the screen
					local offscreenX, offscreenY = TitanUtils_GetOffscreen(controlFrame);
					if ( offscreenX == -1 ) then
						controlFrame:ClearAllPoints();
						controlFrame:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, y_off);	
					elseif ( offscreenX == 1 ) then
						controlFrame:ClearAllPoints();
						controlFrame:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", 0, y_off);	
					end							
				end
				
				controlFrame:Show();
			end	
		elseif (button == "RightButton") then
			TitanUtils_CloseAllControlFrames();	
			-- Show RightClickMenu anyway
			TitanPanelRightClickMenu_Close();
			TitanPanelRightClickMenu_Toggle(self, isChildButton);
		end

		GameTooltip:Hide();
	end
end

--[[ API
NAME: TitanPanelButton_OnEnter
DESC: Handle the OnEnter cursor event of the requested Titan plugin.
VAR: self - frame reference of the plugin
VAR: isChildButton - boolean
NOTE:
- The cursor has moved over the plugin so show the plugin tooltip.
- Save same hassle by doing nothing if the tooltip is already shown or if the cursor is moving.
- If the "is moving" is set the user is dragging this plugin around so do nothing here.
:NOTE
--]]
function TitanPanelButton_OnEnter(self, isChildButton) -- Used by plugins
	local id = nil;
	-- ensure that the 'self' passed is a valid frame reference
	if self and self:GetName() then
		id = TitanUtils_Ternary(isChildButton, 
			TitanUtils_GetParentButtonID(self:GetName()), 
			TitanUtils_GetButtonID(self:GetName()));
	end
	
	if (id) then
		local controlFrame = TitanUtils_GetControlFrame(id);
		if (controlFrame and controlFrame:IsVisible()) then
			return;
		elseif (TitanPanelRightClickMenu_IsVisible()) then
			return;
		else			
			if TITAN_PANEL_MOVING == 0 then
				TitanPanelButton_SetTooltip(self, id);
			end
			if self.isMoving then
				GameTooltip:Hide();				
			end
		end	
	end
end

--[[ API
NAME: TitanPanelButton_OnLeave
DESC: Handle the OnLeave cursor event of the requested Titan plugin.
VAR: self - frame reference of the plugin
VAR: isChildButton - boolean
NOTE:
- The cursor has moved off the plugin so hide the plugin tooltip.
:NOTE
--]]
function TitanPanelButton_OnLeave(self, isChildButton)
	local id = nil;
	-- ensure that the 'self' passed is a valid frame reference
	if self and self:GetName() then
		id = TitanUtils_Ternary(isChildButton, 
			TitanUtils_GetParentButtonID(self:GetName()), 
			TitanUtils_GetButtonID(self:GetName()));
	end
	
	if (id) then
		GameTooltip:Hide();		
	end

	if not TitanPanelGetVar("DisableTooltipFont") then
		-- reset original Tooltip Scale
		GameTooltip:SetScale(TitanTooltipOrigScale);
		TitanTooltipScaleSet = 0;
	end		 
end

-- local routines for Update Button
--[[ local
NAME: TitanPanelButton_SetButtonText
DESC: Set / update the text of the given Titan plugin.
VAR: id - string name of the plugin
NOTE:
- The plugin is expected to tell Titan what routine is to be called in <self>.registry.buttonTextFunction.
- The text routine is called in protected mode (pcall) to ensure the Titan main routines still run.
:NOTE
--]]
local function TitanPanelButton_SetButtonText(id) 
	if (id and TitanUtils_IsPluginRegistered(id)) then
		local button = TitanUtils_GetButton(id);
		local buttonText = _G[button:GetName()..TITAN_PANEL_TEXT];
		local buttonTextFunction = _G[TitanUtils_GetPlugin(id).buttonTextFunction];
		if (buttonTextFunction) then
			-- We'll be paranoid here and call the button text in protected mode.
			-- In case the button text fails it will not take Titan with it...
			local call_success, -- for pcall
				label1, value1, label2, value2, label3, value3, label4, value4 = 
					pcall (buttonTextFunction, id);
			if call_success then
				local text = "";
				if ( label1 and 
				not (label2 or label3 or label4 
					or value1 or value2 or value3 or value4) ) then
					text = label1;
				elseif (TitanGetVar(id, "ShowLabelText")) then
					if (label1 or value1) then
						text = TitanUtils_ToString(label1)
							..TitanUtils_ToString(value1);
						if (label2 or value2) then
							text = text..TITAN_PANEL_LABEL_SEPARATOR
								..TitanUtils_ToString(label2)
								..TitanUtils_ToString(value2);
							if (label3 or value3) then
								text = text..TITAN_PANEL_LABEL_SEPARATOR
									..TitanUtils_ToString(label3)
									..TitanUtils_ToString(value3);
								if (label4 or value4) then
									text = text..TITAN_PANEL_LABEL_SEPARATOR
										..TitanUtils_ToString(label4)
										..TitanUtils_ToString(value4);
								end
							end
						end
					end
				else
					if (value1) then
						text = TitanUtils_ToString(value1);
						if (value2) then
							text = text..TITAN_PANEL_LABEL_SEPARATOR
								..TitanUtils_ToString(value2);
							if (value3) then
								text = text..TITAN_PANEL_LABEL_SEPARATOR
									..TitanUtils_ToString(value3);
								if (value4) then
									text = text..TITAN_PANEL_LABEL_SEPARATOR
										..TitanUtils_ToString(value4);
								end
							end
						end
					end
				end
				buttonText:SetText(text);
			else
				-- Output something...
				buttonText:SetText("<?>");
--[[
				-- This could generate a lot of output...
				TitanDebug("Set button text error "
				..(id or "?").." "
				.."| "..label1 -- the error
				)
--]]
			end
				local isfontvalid = media:IsValid("font", TitanPanelGetVar("FontName"))
				if isfontvalid then
					local newfont = media:Fetch("font", TitanPanelGetVar("FontName"))
					buttonText:SetFont(newfont, TitanPanelGetVar("FontSize"))
				end
		end	
	end
end

--[[ local
NAME: TitanPanelButton_SetTextButtonWidth
DESC: Set the text width of the given Titan plugin that is text only.
VAR: id - string name of the plugin
VAR: setButtonWidth - new width
NOTE:
- Titan uses a tolerance setting to prevent endless updating of the text width. 
:NOTE
--]]
local function TitanPanelButton_SetTextButtonWidth(id, setButtonWidth) 
	if (id) then
		local button = TitanUtils_GetButton(id);
		local text = _G[button:GetName()..TITAN_PANEL_TEXT];
		if ( setButtonWidth 
		or button:GetWidth() == 0 
		or button:GetWidth() - text:GetWidth() > TITAN_PANEL_BUTTON_WIDTH_CHANGE_TOLERANCE 
		or button:GetWidth() - text:GetWidth() < -TITAN_PANEL_BUTTON_WIDTH_CHANGE_TOLERANCE ) then
			button:SetWidth(text:GetWidth());
			TitanPanelButton_Justify();
		end
	end
end

--[[ local
NAME: TitanPanelButton_SetIconButtonWidth
DESC: Set the icon width of the given Titan plugin that is icon only.
VAR: id - string name of the plugin
NOTE:
- The plugin is expected to tell Titan what the icon width is in <self>.registry.iconButtonWidth.
:NOTE
--]]
local function TitanPanelButton_SetIconButtonWidth(id) 
	if (id) then
		local button = TitanUtils_GetButton(id);
		if ( TitanUtils_GetPlugin(id).iconButtonWidth ) then
			button:SetWidth(TitanUtils_GetPlugin(id).iconButtonWidth);
		end		
	end
end

--[[ local
NAME: TitanPanelButton_SetComboButtonWidth
DESC: Set the icon width of the given Titan plugin that is a combo - icon & text.
VAR: id - string name of the plugin
VAR: setButtonWidth - new width
NOTE:
- The plugin is expected to tell Titan what the icon width is in <self>.registry.iconButtonWidth.
:NOTE
--]]
local function TitanPanelButton_SetComboButtonWidth(id, setButtonWidth) 
	if (id) then
		local button = TitanUtils_GetButton(id)
		if not button then return end -- sanity check

		local text = _G[button:GetName()..TITAN_PANEL_TEXT];
		local icon = _G[button:GetName().."Icon"];
		local iconWidth, iconButtonWidth, newButtonWidth;
		
		-- Get icon button width
		iconButtonWidth = 0;
		if ( TitanUtils_GetPlugin(id).iconButtonWidth ) then
			iconButtonWidth = TitanUtils_GetPlugin(id).iconButtonWidth;
		elseif ( icon:GetWidth() ) then
			iconButtonWidth = icon:GetWidth();
		end

		if ( TitanGetVar(id, "ShowIcon") and ( iconButtonWidth ~= 0 ) ) then
			icon:Show();
			text:ClearAllPoints();
			text:SetPoint("LEFT", icon:GetName(), "RIGHT", 2, 1);
			
			newButtonWidth = text:GetWidth() + iconButtonWidth;
		else
			icon:Hide();
			text:ClearAllPoints();
			text:SetPoint("LEFT", button:GetName(), "LEFT", 0, 1);
			
			newButtonWidth = text:GetWidth();
		end
		
		if ( setButtonWidth 
		or button:GetWidth() == 0 
		or button:GetWidth() - newButtonWidth > TITAN_PANEL_BUTTON_WIDTH_CHANGE_TOLERANCE 
		or button:GetWidth() - newButtonWidth < -TITAN_PANEL_BUTTON_WIDTH_CHANGE_TOLERANCE ) 
		then
			button:SetWidth(newButtonWidth);
			TitanPanelButton_Justify();
		end			
	end
end

--[[ API
NAME: TitanPanelButton_UpdateButton
DESC: Update the display of the given Titan plugin.
VAR: id - string name of the plugin
VAR: setButtonWidth - new width
--]]
function TitanPanelButton_UpdateButton(id, setButtonWidth)  -- Used by plugins
	local button, id = TitanUtils_GetButton(id);
	local plugin = TitanUtils_GetPlugin(id)
	-- safeguard to avoid errors
	if not TitanUtils_IsPluginRegistered(id) then return end
	
	if ( TitanPanelButton_IsText(id) ) then
		-- Update textButton
		TitanPanelButton_SetButtonText(id);
		TitanPanelButton_SetTextButtonWidth(id, setButtonWidth);	
		
	elseif ( TitanPanelButton_IsIcon(id) ) then
		-- Update iconButton
		TitanPanelButton_SetButtonIcon(id, (plugin.iconCoords or nil),
			(plugin.iconR or nil),(plugin.iconG or nil),(plugin.iconB or nil)
			);
		TitanPanelButton_SetIconButtonWidth(id);	
		
	elseif ( TitanPanelButton_IsCombo(id) ) then
		-- Update comboButton
		TitanPanelButton_SetButtonText(id);
		TitanPanelButton_SetButtonIcon(id, (plugin.iconCoords or nil),
			(plugin.iconR or nil),(plugin.iconG or nil),(plugin.iconB or nil)
			);
		TitanPanelButton_SetComboButtonWidth(id, setButtonWidth);
	end
end

--[[ API
NAME: TitanPanelButton_UpdateTooltip
DESC: Update the tooltip of the given Titan plugin.
VAR: self - frame reference of the plugin
--]]
function TitanPanelButton_UpdateTooltip(self) -- Used by plugins
	if not self then return end
	if (GameTooltip:IsOwned(self)) then
		local id = TitanUtils_GetButtonID(self:GetName());
		TitanPanelButton_SetTooltip(self, id);
	end
end

--[[ API
NAME: TitanPanelButton_SetButtonIcon
DESC: Set the icon of the given Titan plugin.
VAR: id - string name of the plugin
VAR: iconCoords - if given, this is the placing of the icon within the plugin
VAR: iconR - if given, this is the Red (RBG) setting of the icon
VAR: iconG - if given, this is the Green (RBG) setting of the icon
VAR: iconB - if given, this is the Blue (RBG) setting of the icon
--]]
function TitanPanelButton_SetButtonIcon(id, iconCoords, iconR, iconG, iconB) 	
	if (id and TitanUtils_IsPluginRegistered(id)) then
		local button = TitanUtils_GetButton(id);
		local icon = _G[button:GetName().."Icon"];
		local iconTexture = TitanUtils_GetPlugin(id).icon;
		local iconWidth = TitanUtils_GetPlugin(id).iconWidth;
		
		if (iconTexture) and icon then
			icon:SetTexture(iconTexture);
		end
		if (iconWidth) and icon then
			icon:SetWidth(iconWidth);
		end
		
		-- support for iconCoords, iconR, iconG, iconB attributes
		if iconCoords and icon then
			icon:SetTexCoord(unpack(iconCoords))
		end		
		if iconR and iconG and iconB and icon then
			icon:SetVertexColor(iconR, iconG, iconB)
		end
	end
end

--[[ Titan
NAME: TitanPanelButton_GetType
DESC: Get the type of the given Titan plugin.
VAR: id - string name of the plugin
OUT: type - The type of the plugin (text, icon, combo (default))
NOTE:
- This assumes that the developer is playing nice and is using the Titan templates as is...
:NOTE
--]]
function TitanPanelButton_GetType(id)
	-- id is required
	if (not id) then
		return;
	end
	
	local button = TitanUtils_GetButton(id);
	local type;
	if button then
		local text = _G[button:GetName()..TITAN_PANEL_TEXT];
		local icon = _G[button:GetName().."Icon"];

		if (text and icon) then
			type = TITAN_PANEL_BUTTON_TYPE_COMBO;
		elseif (text and not icon) then
			type = TITAN_PANEL_BUTTON_TYPE_TEXT;
		elseif (not text and icon) then
			type = TITAN_PANEL_BUTTON_TYPE_ICON;
		elseif (not text and not icon) then
			type = TITAN_PANEL_BUTTON_TYPE_CUSTOM;
		end
	else
		type = TITAN_PANEL_BUTTON_TYPE_COMBO;
	end
	
	return type;
end

