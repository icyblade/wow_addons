--[[ File
NAME: TitanPanel.lua
DESC: Contains the basic routines of Titan. All the event handler routines, initialization routines, Titan menu routines, and select plugin handler routines.
--]]

-- Locals
local TPC = TITAN_PANEL_CONSTANTS -- shortcut
local TITAN_PANEL_BUTTONS_INIT_FLAG = nil;

local TITAN_PANEL_FROM_TOP = -25;
local TITAN_PANEL_FROM_BOTTOM = 25;
local TITAN_PANEL_FROM_BOTTOM_MAIN = 1;
local TITAN_PANEL_FROM_TOP_MAIN = 1;

local _G = getfenv(0);
local InCombatLockdown = _G.InCombatLockdown;
local IsTitanPanelReset = nil;
local numOfTextures = 0;
local numOfTexturesHider = 0;

-- Library references
local L = LibStub("AceLocale-3.0"):GetLocale(TITAN_ID, true)
local AceTimer = LibStub("AceTimer-3.0")
local media = LibStub("LibSharedMedia-3.0")

--------------------------------------------------------------
--
function TitanPanel_OkToReload()
	StaticPopupDialogs["TITAN_RESET_RELOAD"] = {
		text = TitanUtils_GetNormalText(L["TITAN_PANEL_MENU_TITLE"])
			.."\n\n"..L["TITAN_PANEL_RESET_WARNING"],
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function(self)
			ReloadUI()
		end,	
		showAlert = 1,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1
	};
	StaticPopup_Show("TITAN_RESET_RELOAD");
end

--[[ Titan
NAME: TitanPanel_ResetToDefault
DESC: Give the user a 'are you sure'. If the user accepts then reset current toon back to default Titan settings.
VAR:  None
OUT:  None
NOTE: 
- Even if the user was using global profiles they will not when this is done.
:NOTE
--]]
function TitanPanel_ResetToDefault()
	StaticPopupDialogs["TITAN_RESET_BAR"] = {
		text = TitanUtils_GetNormalText(L["TITAN_PANEL_MENU_TITLE"])
			.."\n\n"..L["TITAN_PANEL_RESET_WARNING"],
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function(self)
			TitanVariables_UseSettings(TitanSettings.Player, TITAN_PROFILE_RESET);
			IsTitanPanelReset = true;
--TitanPanel_OkToReload()
			ReloadUI()
		end,	
		showAlert = 1,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1
	};
	StaticPopup_Show("TITAN_RESET_BAR");
end

--[[ Titan
NAME: TitanPanel_SaveCustomProfile
DESC: The user wants to save a custom Titan profile. Show the user the dialog boxes to make it happen.
VAR:  None
OUT:  None
NOTE:
- The profile is written to the Titan saved variables. A reload of the UI is needed to ensure the profile is written to disk for the user to load later.
:NOTE
--]]
function TitanPanel_SaveCustomProfile()
   -- Create the dialog box code we'll need...
	
	-- helper to actually write the profile to the Titan saved vars
	local function Write_profile(name)
		local currentprofilevalue, _, _ = TitanUtils_GetPlayer()
		local profileName = TitanUtils_CreateName(name, TITAN_CUSTOM_PROFILE_POSTFIX)
		TitanSettings.Players[profileName] = 
			TitanSettings.Players[currentprofilevalue]
		TitanPrint(L["TITAN_PANEL_MENU_PROFILE_SAVE_PENDING"]
			.."'"..name.."'"
			, "info")
	end
	-- helper to ask the user to overwrite a profile
	local function Overwrite_profile(name)
		local dialogFrame = 
			StaticPopup_Show("TITAN_OVERWRITE_CUSTOM_PROFILE", name);
		if dialogFrame then
			dialogFrame.data = name;
		end
	end
	-- helper to handle getting the profile name from the user
	local function Get_profile_name(self)
		local rawprofileName = self.editBox:GetText();
		-- remove any spaces the user may have typed in the name
		local conc2profileName = string.gsub( rawprofileName, " ", "" );
		if conc2profileName == "" then return; end
		-- no '@' is allowed or it will mess with the Titan profile naming convention
		local concprofileName = string.gsub( conc2profileName, TITAN_AT, "-" );
		local profileName = TitanUtils_CreateName(concprofileName, TITAN_CUSTOM_PROFILE_POSTFIX)
		if TitanSettings.Players[profileName] then			
			-- Warn the user of an existing profile
			Overwrite_profile(rawprofileName)
			self:Hide();
			return;
		else
			-- Save the requested profile
			Write_profile(rawprofileName)
			self:Hide();
			StaticPopup_Show("TITAN_RELOADUI");
		end
	end
	-- Dialog box to warn the user that the UI will be reloaded
	-- This ensures the profile is written to disk
	StaticPopupDialogs["TITAN_RELOADUI"] = {
		text = TitanUtils_GetNormalText(L["TITAN_PANEL_MENU_TITLE"]).."\n\n"
			..L["TITAN_PANEL_MENU_PROFILE_RELOADUI"],
		button1 = TEXT(OKAY),
		OnAccept = function(self)
			ReloadUI(); -- ensure profile is written to disk
		end,
		showAlert = 1,
		whileDead = 1,
		timeout = 0,
	};
	
	-- Dialog box to warn the user that an existing profile will be overwritten.
	StaticPopupDialogs["TITAN_OVERWRITE_CUSTOM_PROFILE"] = {
		text = TitanUtils_GetNormalText(L["TITAN_PANEL_MENU_TITLE"]).."\n\n"
			..L["TITAN_PANEL_MENU_PROFILE_ALREADY_EXISTS"],
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function(self, data)
			Write_profile(data)
			self:Hide();
			StaticPopup_Show("TITAN_RELOADUI");
		end,
		showAlert = 1,
		whileDead = 1,
		timeout = 0,
		hideOnEscape = 1
	};
	
	-- Dialog box to save the profile.
	StaticPopupDialogs["TITAN_SAVE_CUSTOM_PROFILE"] = {
		text = TitanUtils_GetNormalText(L["TITAN_PANEL_MENU_TITLE"]).."\n\n"
			..L["TITAN_PANEL_MENU_PROFILE_SAVE_CUSTOM_TITLE"],
		button1 = ACCEPT,
		button2 = CANCEL,
		hasEditBox = 1,
		maxLetters = 20,
		OnAccept = function(self)
			-- self refers to this frame with the Accept button
			Get_profile_name(self)
		end,
		OnShow = function(self)
			self.editBox:SetFocus();
		end,
		OnHide = function(self)
			self.editBox:SetText("");
		end,
		EditBoxOnEnterPressed = function(self)
			-- We need to get the parent because self refers to the edit box.
			Get_profile_name(self:GetParent())
			end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
		end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1
	};

	StaticPopup_Show("TITAN_SAVE_CUSTOM_PROFILE");

	-- Can NOT cleanup. Execution does not stop when a dialog box is invoked!
--	StaticPopupDialogs["TITAN_RELOADUI"] = {}
--	StaticPopupDialogs["TITAN_OVERWRITE_CUSTOM_PROFILE"] = {}
--	StaticPopupDialogs["TITAN_SAVE_CUSTOM_PROFILE"] = {}
	
end

--[[ Titan
NAME: TitanSetPanelFont
DESC: Set or change the font and font size of text on the Titan bar. This affects ALL plugins.
VAR: fontname - The text name of the font to use. Defaults to Titan default if none given.
VAR: fontsize - The size of the font to use. Defaults to Titan default if none given.
OUT: None
NOTE:
- Each registered plugin will have its font updated. Then all plugins will be refreshed to show the new font.
:NOTE
--]]
function TitanSetPanelFont(fontname, fontsize)
	-- a couple of arg checks to avoid unpleasant things...
	if not fontname then fontname = TPC.FONT_NAME end
	if not fontsize then fontsize = TPC.FONT_SIZE end
	local index,id;
	local newfont = media:Fetch("font", fontname)
	for index, id in pairs(TitanPluginsIndex) do
		local button = TitanUtils_GetButton(id);
		local buttonText = _G[button:GetName()..TITAN_PANEL_TEXT];
		if buttonText then
			buttonText:SetFont(newfont, fontsize);
		end
		-- account for plugins with child buttons
		local childbuttons = {button:GetChildren()};
		for _, child in ipairs(childbuttons) do
			if child then
				local bname = _G[child:GetName()]
				if bname then
					local childbuttonText = _G[child:GetName()..TITAN_PANEL_TEXT];
					if childbuttonText then
						childbuttonText:SetFont(newfont, fontsize);
					end
				end
			end
		end
	end
	TitanPanel_RefreshPanelButtons();
end


--[[ not_used
local function TitanPanel_SetTransparent(frame, position)
	local frName = _G[frame];
	
	if (position == TITAN_PANEL_PLACE_TOP) then
		frName:ClearAllPoints();
		frName:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, 0);
		frName:SetPoint("BOTTOMRIGHT", "UIParent", "TOPRIGHT", 0, -TITAN_PANEL_BAR_HEIGHT);
	else
		frName:ClearAllPoints();
		frName:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, 0); 
		frName:SetPoint("TOPRIGHT", "UIParent", "BOTTOMRIGHT", 0, TITAN_PANEL_BAR_HEIGHT); 
	end
end
--]]

--[[ local
NAME: TitanPanel_CreateABar
DESC: Helper to create the Titan bar passed in.
VAR: frame - The frame name (string) of the Titan bar to create
OUT: None
NOTE:
- This also creates the hider bar in case the user want to use auto hide.
:NOTE
--]]
local function TitanPanel_CreateABar(frame)
	if not frame then return end
	local hide_name = TitanBarData[frame].hider
	local bar_name = TitanBarData[frame].name

	if hide_name and bar_name then
		-- Set script handlers for display
		_G[frame]:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		_G[frame]:SetScript("OnEnter", function(self) TitanPanelBarButton_OnEnter(self) end)
		_G[frame]:SetScript("OnLeave", function(self) TitanPanelBarButton_OnLeave(self) end)
		_G[frame]:SetScript("OnClick", function(self, button) TitanPanelBarButton_OnClick(self, button) end)

		-- Set script handlers for display
		_G[hide_name]:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		_G[hide_name]:SetScript("OnEnter", function(self) TitanPanelBarButtonHider_OnEnter(self) end)
		_G[hide_name]:SetScript("OnLeave", function(self) TitanPanelBarButtonHider_OnLeave(self) end)
		_G[hide_name]:SetScript("OnClick", function(self, button) TitanPanelBarButton_OnClick(self, button) end)
		
		_G[hide_name]:SetFrameStrata("BACKGROUND")
		_G[hide_name]:SetHeight(TITAN_PANEL_BAR_HEIGHT/2);
		_G[hide_name]:SetWidth(2560);
		
		-- Set the display bar
		local container = _G[frame]
		container:SetHeight(TITAN_PANEL_BAR_HEIGHT);
		-- Set local identifier
		local container_text = _G[frame.."_Text"]
		if container_text then -- was used for debug/creating of the independent bars
			container_text:SetText(tostring(bar_name))
			-- for now show it
			container:Show()
		end
	end
end

--------------------------------------------------------------
--
-- Event registration
--_G[TITAN_PANEL_CONTROL]:RegisterEvent("ADDON_LOADED");
_G[TITAN_PANEL_CONTROL]:RegisterEvent("PLAYER_ENTERING_WORLD");
_G[TITAN_PANEL_CONTROL]:RegisterEvent("PLAYER_REGEN_DISABLED");
_G[TITAN_PANEL_CONTROL]:RegisterEvent("PLAYER_REGEN_ENABLED");
_G[TITAN_PANEL_CONTROL]:RegisterEvent("CVAR_UPDATE");
_G[TITAN_PANEL_CONTROL]:RegisterEvent("PLAYER_LOGOUT");
_G[TITAN_PANEL_CONTROL]:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
_G[TITAN_PANEL_CONTROL]:RegisterEvent("UNIT_ENTERED_VEHICLE");
_G[TITAN_PANEL_CONTROL]:RegisterEvent("UNIT_EXITED_VEHICLE");
_G[TITAN_PANEL_CONTROL]:SetScript("OnEvent", function(_, event, ...)
	_G[TITAN_PANEL_CONTROL][event](_G[TITAN_PANEL_CONTROL], ...)
end)
-- For the pet battle - for now we'll hide the Titan bars...
-- Cannot seem to move the 'top' part of the frame.
_G[TITAN_PANEL_CONTROL]:RegisterEvent("PET_BATTLE_OPENING_START");
_G[TITAN_PANEL_CONTROL]:RegisterEvent("PET_BATTLE_CLOSE");

	
--[[ Titan
NAME: TitanPanel_PlayerEnteringWorld
DESC: Do all the setup needed when a user logs in / reload UI / enter or leave an instance.
VAR:  None
OUT:  None
NOTE:
- This is called after the 'player entering world' event is fired by Blizz.
- This is also used when a LDB plugin is created after Titan runs the 'player entering world' code.
:NOTE
--]]
function TitanPanel_PlayerEnteringWorld()
	if Titan__InitializedPEW then
		-- Also sync the LDB object with the Tian plugin
		TitanLDBRefreshButton()
	else
		-- Get Profile and Saved Vars
		TitanVariables_InitTitanSettings();

		-- only do this sort of initialization on the first PEW event
		if not TitanAllGetVar("Silenced") then
			TitanPrint("", "header")
		end

		if not ServerTimeOffsets then
			ServerTimeOffsets = {};
		end
		if not ServerHourFormat then
			ServerHourFormat = {};
		end

		-- Set the two anchors in their default positions
		-- until the Titan bars are drawn
		TitanPanelTopAnchor:ClearAllPoints();
		TitanPanelTopAnchor:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, 0);
		TitanPanelBottomAnchor:ClearAllPoints();
		TitanPanelBottomAnchor:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, 0);

		-- Ensure the bars are created before the 
		-- plugins are registered. 
		for idx, v in pairs (TitanBarData) do
			TitanPanel_CreateABar(idx)
		end

		local realmName = GetRealmName()

		if ServerTimeOffsets[realmName] then
			TitanSetVar(TITAN_CLOCK_ID, "OffsetHour", ServerTimeOffsets[realmName])
		elseif TitanGetVar(TITAN_CLOCK_ID, "OffsetHour") then
			ServerTimeOffsets[realmName] = TitanGetVar(TITAN_CLOCK_ID, "OffsetHour")
		end
	
		if ServerHourFormat[realmName] then
			TitanSetVar(TITAN_CLOCK_ID, "Format", ServerHourFormat[realmName])
		elseif TitanGetVar(TITAN_CLOCK_ID, "Format") then
			ServerHourFormat[realmName] = TitanGetVar(TITAN_CLOCK_ID, "Format")
		end
	end
	local _ = nil
	TitanSettings.Player,_,_ = TitanUtils_GetPlayer()
	-- Some addons wait to create their LDB component or a Titan addon could
	-- create additional buttons as needed.
	-- So we need to sync their variables and set them up
	TitanUtils_RegisterPluginList()

	-- Init detailed settings only after plugins are registered!
	TitanVariables_UseSettings(nil, TITAN_PROFILE_INIT)
	
	-- all addons are loaded so update the config (options)
	-- some could have registered late...
	TitanUpdateConfig("init")

	-- Init panel font
	local isfontvalid = media:IsValid("font", TitanPanelGetVar("FontName"))
	if isfontvalid then
		TitanSetPanelFont(TitanPanelGetVar("FontName"), TitanPanelGetVar("FontSize"))
	else
	-- if the selected font is not valid, revert to default (Friz Quadrata TT)
		TitanPanelSetVar("FontName", TPC.FONT_NAME);
		TitanSetPanelFont(TPC.FONT_NAME, TitanPanelGetVar("FontSize"))
	end

	-- Init panel frame strata
	TitanVariables_SetPanelStrata(TitanPanelGetVar("FrameStrata"))

	-- Titan Panel has initialized its variables and registered plugins.
	-- Allow Titan - and others - to adjust the bars
	Titan__InitializedPEW = true

	-- Move frames
	TitanPanel_AdjustFrames(TITAN_PANEL_PLACE_BOTH, true)
	TitanMovable_SecureFrames()
	
	-- Secondary failsafe check for bottom frame adjustment
	--
	-- On longer game loads (log in, reload, instances, etc Titan will adjust
	-- then Blizz will adjust putting the action buttons over / under Titan
	-- if the user has aux 1/2 shown.
	TitanMovable_AdjustTimer("EnterWorld")
	
end

--------------------------------------------------------------
--
-- Event handlers
--
function TitanPanelBarButton:ADDON_LOADED(addon)
	if addon == TITAN_ID then
		-- Get Profile and Saved Vars
		TitanVariables_InitTitanSettings();			
		local VERSION = TitanPanel_GetVersion();
		local POS = strfind(VERSION," - ");
		VERSION = strsub(VERSION,1,POS-1);
		TitanPrint("", "header")

		if not ServerTimeOffsets then
			ServerTimeOffsets = {};
		end
		if not ServerHourFormat then
			ServerHourFormat = {};
		end
		-- Unregister event - saves a few event calls.
		self:UnregisterEvent("ADDON_LOADED");
		self.ADDON_LOADED = nil
	end
end

function TitanPanelBarButton:PLAYER_ENTERING_WORLD()
	local call_success = nil
	local ret_val = nil
	
	call_success, -- needed for pcall
	ret_val =  -- actual return values
		pcall (TitanPanel_PlayerEnteringWorld)
	-- pcall does not allow errors to propagate out. Any error
	-- is returned as text with the success / fail.
	-- Think of it as sort of a try - catch block
	if call_success then
		-- Titan initialized properly
	else
		-- something really bad occured...
		TitanPrint("Titan could not initialize!!!!  Cleaning up...", "error")
		TitanPrint("--"..ret_val, "error")
		-- Clean up best we can and tell the user to submit a ticket.
		-- This could be the 1st log in or a reload (reload, instance, boat, ...)
		
		-- Hide the bars. At times they are there but at 0% transparency.
		-- They can be over the Blizz action bars creating havoc.
		TitanPrint("-- Hiding Titan bars...", "warning")
		TitanPanelBarButton_HideAllBars()

		-- Remove the options pages
		TitanUpdateConfig("nuke")
		-- What else to clean up???
		
		-- raise the error to WoW for display, if display errors is set.
		-- This *must be* the last statement of the routine!
		error(ret_val, 1)
	end
end

function TitanPanelBarButton:CVAR_UPDATE(cvarname, cvarvalue)
	if cvarname == "USE_UISCALE" 
	or cvarname == "WINDOWED_MODE" 
	or cvarname == "uiScale" then
		if TitanPlayerSettings and TitanPanelGetVar("Scale") then
			Titan_AdjustScale()
			-- Adjust frame positions
			TitanPanel_AdjustFrames(TITAN_PANEL_PLACE_BOTH, true)
		end
	end
end

function TitanPanelBarButton:PLAYER_LOGOUT()
	if not IsTitanPanelReset then
		-- for debug
		if TitanPanelRegister then
			TitanPanelRegister.ToBe = TitanPluginToBeRegistered
			TitanPanelRegister.ToBeNum = TitanPluginToBeRegisteredNum
			TitanPanelRegister.TitanPlugins = TitanPlugins
			TitanPanelRegister.Extras = TitanPluginExtras
		end
	end
	Titan__InitializedPEW = nil
end

function TitanPanelBarButton:PLAYER_REGEN_DISABLED()
	-- If in combat close all control frames and menus
	TitanUtils_CloseAllControlFrames();
	TitanUtils_CloseRightClickMenu();
end

function TitanPanelBarButton:PLAYER_REGEN_ENABLED()
	-- Outside combat check to see if frames need correction
	TitanPanel_AdjustFrames(TITAN_PANEL_PLACE_BOTH, true)
end

function TitanPanelBarButton:ACTIVE_TALENT_GROUP_CHANGED()
	TitanMovable_AdjustTimer("DualSpec")
end

function TitanPanelBarButton:UNIT_ENTERED_VEHICLE(self, ...)
	TitanMovable_AdjustTimer("Vehicle")
end
function TitanPanelBarButton:UNIT_EXITED_VEHICLE(self, ...)
	TitanMovable_AdjustTimer("Vehicle")
end
--
function TitanPanelBarButton:PET_BATTLE_OPENING_START()
--	TitanDebug("Pet_battle start: ")
	-- Hide all bars and hiders
	TitanPanelBarButton_HideAllBars()
end
function TitanPanelBarButton:PET_BATTLE_CLOSE()
--	TitanDebug("Pet_battle end: ")
	-- Show the bars the user had selected
	TitanPanelBarButton_DisplayBarsWanted()
end
--
--

--[[ Titan
NAME: TitanPanelBarButton_OnClick
DESC: Handle the button clicks on any Titan bar.
VAR: self - expected to be a Titan bar
VAR: button - which mouse button was clicked
OUT:  None
NOTE:
- This only reacts to the right or left mouse click without modifiers.
- Used in the set script for the Titan display and hider frames
:NOTE
--]]
function TitanPanelBarButton_OnClick(self, button)
	-- ensure that the right-click menu will not appear on "hidden" bottom bar(s)
	local bar = self:GetName();
	if (button == "LeftButton") then
		TitanUtils_CloseAllControlFrames();
		TitanUtils_CloseRightClickMenu();	
	elseif (button == "RightButton") then
		TitanUtils_CloseAllControlFrames();			
		TitanPanelRightClickMenu_Close();
		-- Show RightClickMenu anyway
		TitanPanelDisplayRightClickMenu_Toggle(self)  -- self not used...
	end
end

--
-- Slash command handler
--
--[[ local
NAME: TitanPanel_ParseSlashCmd
DESC: Helper to parse the user commands.
VAR: cmd - user string from the command 'window'
OUT: table - table of 'words' the user typed in
NOTE:
- each 'word' in words table is made lower case for comparison simplicity
:NOTE
--]]
local function TitanPanel_ParseSlashCmd(cmd)
	local words = {}
	for w in string.gmatch (cmd, "%w+") do
		words [#words +  1] = (w and string.lower(w) or "?")
	end
--[[	
	local tmp = ""
	for idx,v in pairs (words) do
		tmp = tmp.."'"..words[idx].."' "
	end
	
	TitanDebug (tmp.." : "..#words)
--]]
	return words
end

--[[ local
NAME: handle_slash_help
DESC: Helper to tell the user the relevant Titan commands.
VAR:  cmd - string 'all' | 'reset' | 'gui'
OUT:  None
NOTE:
- Depending on cmd put to chat the appropriate help
:NOTE
--]]
local function handle_slash_help(cmd)
	cmd = cmd or "all"
	
	--	Give the user the general help if we can not figure out what they want
	TitanPrint("", "header")
		
	if cmd == "reset" then
		TitanPrint(L["TITAN_PANEL_SLASH_RESET_0"], "plain")
		TitanPrint(L["TITAN_PANEL_SLASH_RESET_1"], "plain")
		TitanPrint(L["TITAN_PANEL_SLASH_RESET_2"], "plain")
		TitanPrint(L["TITAN_PANEL_SLASH_RESET_3"], "plain")
		TitanPrint(L["TITAN_PANEL_SLASH_RESET_4"], "plain")
		TitanPrint(L["TITAN_PANEL_SLASH_RESET_5"], "plain")
	end
	if cmd == "gui" then 
		TitanPrint(L["TITAN_PANEL_SLASH_GUI_0"], "plain")
		TitanPrint(L["TITAN_PANEL_SLASH_GUI_1"], "plain")
		TitanPrint(L["TITAN_PANEL_SLASH_GUI_2"], "plain")
		TitanPrint(L["TITAN_PANEL_SLASH_GUI_3"], "plain")
	end
	if cmd == "profile" then
		TitanPrint(L["TITAN_PANEL_SLASH_PROFILE_0"], "plain")
		TitanPrint(L["TITAN_PANEL_SLASH_PROFILE_1"], "plain")
		TitanPrint(L["TITAN_PANEL_SLASH_PROFILE_2"], "plain")
		TitanPrint(L["TITAN_PANEL_SLASH_PROFILE_3"], "plain")
	end
	if cmd == "silent" then
		TitanPrint(L["TITAN_PANEL_SLASH_SILENT_0"], "plain")
		TitanPrint(L["TITAN_PANEL_SLASH_SILENT_1"], "plain")
	end
	if cmd == "help" then
		TitanPrint(L["TITAN_PANEL_SLASH_HELP_0"], "plain")
		TitanPrint(L["TITAN_PANEL_SLASH_HELP_1"], "plain")
	end
	if cmd == "all" then
		TitanPrint(L["TITAN_PANEL_SLASH_ALL_0"], "plain")
		TitanPrint(L["TITAN_PANEL_SLASH_ALL_1"], "plain")
	end
end

--[[ local
NAME: handle_reset_cmds
DESC: Helper to execute the various reset commands from the user.
VAR:  cmd_list - A table containing the list of 'words' the user typed in
OUT:  None
--]]
local function handle_reset_cmds(cmd_list)
	local cmd = cmd_list[1]
	local p1 = cmd_list[2] or nil
	-- sanity check
	if (not cmd == "reset") then
		return
	end
	
	if p1 == nil then
		TitanPanel_ResetToDefault();
	elseif p1 == "tipfont" then
		TitanPanelSetVar("TooltipFont", 1);
		GameTooltip:SetScale(TitanPanelGetVar("TooltipFont"));
		TitanPrint(L["TITAN_PANEL_SLASH_RESP1"], "info")
	elseif p1 == "tipalpha" then
		TitanPanelSetVar("TooltipTrans", 1);
		local red, green, blue, _ = GameTooltip:GetBackdropColor();
		local red2, green2, blue2, _ = GameTooltip:GetBackdropBorderColor();
		GameTooltip:SetBackdropColor(red,green,blue,TitanPanelGetVar("TooltipTrans"));
		GameTooltip:SetBackdropBorderColor(red2,green2,blue2,TitanPanelGetVar("TooltipTrans"));
		TitanPrint(L["TITAN_PANEL_SLASH_RESP2"], "info")
	elseif p1 == "panelscale" then
		if not InCombatLockdown() then
			TitanPanelSetVar("Scale", 1);
			-- Adjust panel scale
			Titan_AdjustScale()
			-- Adjust frame positions
			TitanPanel_AdjustFrames(TITAN_PANEL_PLACE_BOTH, true)
			TitanPrint(L["TITAN_PANEL_SLASH_RESP3"], "info")
		else
			TitanPrint(L["TITAN_PANEL_MENU_IN_COMBAT_LOCKDOWN"], "warning")
		end
	elseif p1 == "spacing" then
		TitanPanelSetVar("ButtonSpacing", 20);
		TitanPanel_InitPanelButtons();
		TitanPrint(L["TITAN_PANEL_SLASH_RESP4"], "info")
	else
		handle_slash_help("reset")
	end
end

--[[ local
NAME: handle_giu_cmds
DESC: Helper to execute the gui related commands from the user.
VAR: cmd_list - A table containing the list of 'words' the user typed in
OUT: None
--]]
local function handle_giu_cmds(cmd_list)
	local cmd = cmd_list[1]
	local p1 = cmd_list[2] or nil
	-- sanity check
	if (not cmd == "gui") then
		return
	end
	
	if p1 == "control" then
		InterfaceOptionsFrame_OpenToCategory(L["TITAN_UISCALE_MENU_TEXT_SHORT"])
	elseif p1 == "trans" then
		InterfaceOptionsFrame_OpenToCategory(L["TITAN_TRANS_MENU_TEXT_SHORT"])
	elseif p1 == "skin" then
		InterfaceOptionsFrame_OpenToCategory(L["TITAN_PANEL_MENU_TEXTURE_SETTINGS"])
	else
		handle_slash_help("gui")
	end
end

--[[ local
NAME: handle_profile_cmds
DESC: Helper to execute the profile related commands from the user.
VAR: cmd_list - A table containing the list of 'words' the user typed in
OUT: None
--]]
local function handle_profile_cmds(cmd_list)
	local cmd = cmd_list[1]
	local p1 = cmd_list[2] or nil
	local p2 = cmd_list[3] or nil
	local p3 = cmd_list[4] or nil
	-- sanity check
	if (not cmd == "profile") then
		return
	end
	
	if p1 == "use" and p2 and p3 then
		if TitanAllGetVar("GlobalProfileUse") then
			TitanPrint(L["TITAN_PANEL_GLOBAL_ERR_1"], "info")
		else
			TitanVariables_UseSettings(TitanUtils_CreateName(p2, p3), TITAN_PROFILE_USE)
		end
	else
		handle_slash_help("profile")
	end
end

--[[ local
NAME: handle_silent_cmds
DESC: Helper to execute the silent commands from the user.
VAR: cmd_list - A table containing the list of 'words' the user typed in
OUT: None
--]]
local function handle_silent_cmds(cmd_list)
	local cmd = cmd_list[1]
	local p1 = cmd_list[2] or nil
	-- sanity check
	if (not cmd == "silent") then
		return
	end
	
	if TitanAllGetVar("Silenced") then
		TitanAllSetVar("Silenced", false);
		TitanPrint(L["TITAN_PANEL_MENU_SILENT_LOAD"].." ".. L["TITAN_PANEL_MENU_DISABLED"], "info")
	else
		TitanAllSetVar("Silenced", true);
		TitanPrint(L["TITAN_PANEL_MENU_SILENT_LOAD"].." ".. L["TITAN_PANEL_MENU_ENABLED"], "info")
	end		
end

--[[ local
NAME: handle_help_cmds
DESC: Helper to execute the help commands from the user.
VAR: cmd_list - A table containing the list of 'words' the user typed in
OUT: None
--]]
local function handle_help_cmds(cmd_list)
	local cmd = cmd_list[1]
	local p1 = cmd_list[2] or nil
	-- sanity check
	if (not cmd == "help") then
		return
	end
	
	handle_slash_help(p1 or "all")
end

--[[ local
NAME: TitanPanel_RegisterSlashCmd
DESC: Helper to parse and execute all the Titan slash commands from the user.
VAR: cmd - The command (string) the user typed in
OUT: None
--]]
local function TitanPanel_RegisterSlashCmd(cmd_str)
	local cmd_list = {}
	-- parse what the user typed
	cmd_list = TitanPanel_ParseSlashCmd(cmd_str)
	local cmd = cmd_list[1] or ""
	local p1 = cmd_list[2] or ""
	local p2 = cmd_list[3] or ""
	local p3 = cmd_list[4] or ""
--
--	TitanDebug (cmd.." : "..p1.." "..p2.." "..p3.." "..#cmd_list)
	--
	if (cmd == "reset") then
		handle_reset_cmds(cmd_list)
	elseif (cmd == "gui") then
		handle_giu_cmds(cmd_list)
	elseif (cmd == "profile") then
		handle_profile_cmds(cmd_list)
	elseif (cmd == "silent") then
		handle_silent_cmds(p1)
	elseif (cmd == "help") then
		handle_slash_help(p1)
	else
		handle_slash_help("all")
	end
end

--------------------------------------------------------------
--
-- Register slash commands for Titan Panel
SlashCmdList["TitanPanel"] = TitanPanel_RegisterSlashCmd;
SLASH_TitanPanel1 = "/titanpanel";
SLASH_TitanPanel2 = "/titan";

--------------------------------------------------------------
--
-- Texture routines
--[[ Titan
NAME: TitanPanel_ClearAllBarTextures
DESC: Clear the current texture from all Titan bars.
VAR:  None
OUT:  None
--]]
function TitanPanel_ClearAllBarTextures()
	-- Clear textures if they already exist
	for idx,v in pairs (TitanBarData) do
		for i = 0, numOfTexturesHider do
			tex = TITAN_PANEL_BACKGROUND_PREFIX..TitanBarData[idx].name.."_"..i
			if _G[tex] then
				_G[tex]:SetTexture()
			end
		end
	end
end

--[[ Titan
NAME: TitanPanel_CreateBarTextures
DESC: Create empty texture frames for all Titan bars.
VAR:  None
OUT:  None
--]]
function TitanPanel_CreateBarTextures()
	-- Create the basic Titan bars (textures)
	local i, titanTexture
	local texture_path = TitanPanelGetVar("TexturePath")
	local bar_name
	local screenWidth
	local lastTextureWidth
	local tex, tex_pre
	
	-- loop through the bars to set the texture
	for idx,v in pairs (TitanBarData) do
		bar_name = TITAN_PANEL_DISPLAY_PREFIX..TitanBarData[idx].name
		screenWidth = ((_G[bar_name]:GetWidth() or GetScreenWidth()) + 1 ) --/ 2
		numOfTextures = floor(screenWidth / 256 )
		numOfTexturesHider = (numOfTextures * 2) + 1
		lastTextureWidth = screenWidth - (numOfTextures * 256)
		
		for i = 0, numOfTextures do
			-- Create textures if they don't exist
			tex = TITAN_PANEL_BACKGROUND_PREFIX..TitanBarData[idx].name.."_"..i
			tex_pre = TITAN_PANEL_BACKGROUND_PREFIX..TitanBarData[idx].name.."_"..i-1
			if not _G[tex] then
				titanTexture = _G[bar_name]:CreateTexture(tex, "BACKGROUND")
			else
				titanTexture = _G[tex]
			end
			titanTexture:SetHeight(TITAN_PANEL_BAR_TEXTURE_HEIGHT)
			if i == numOfTextures then
				titanTexture:SetWidth(lastTextureWidth)
			else
			  titanTexture:SetWidth(256)
			end
			titanTexture:ClearAllPoints()
			if i == 0 then
				titanTexture:SetPoint("TOPLEFT", bar_name, "TOPLEFT", 0, 0) --  -1, 0)
			else
				titanTexture:SetPoint("TOPLEFT", tex_pre, "TOPRIGHT")
			end
		end
		titanTexture:SetWidth(256)

		-- Handle Hider Textures
		for i = numOfTextures + 1, numOfTexturesHider do
			tex = TITAN_PANEL_BACKGROUND_PREFIX..TitanBarData[idx].name.."_"..i
			tex_pre = TITAN_PANEL_BACKGROUND_PREFIX..TitanBarData[idx].name.."_"..i-1
			if not _G[tex] then
				titanTexture = _G[bar_name]:CreateTexture(tex, "BACKGROUND")
			else
				titanTexture = _G[tex]
			end
			titanTexture:SetHeight(TITAN_PANEL_BAR_TEXTURE_HEIGHT)
			if i == numOfTexturesHider then
				titanTexture:SetWidth(lastTextureWidth)
			else
				titanTexture:SetWidth(256)
			end
			titanTexture:ClearAllPoints()
			titanTexture:SetPoint("TOPLEFT", tex_pre, "TOPRIGHT")
		end
	end
end

--[[ Titan
NAME: TitanPanel_SetTexture
DESC: Set texture frames for the given Titan bar with the user chosen texture (bar graphic).
VAR: frame - expected to be a Titan bar name (string)
VAR: position - not used
OUT:  None
NOTE:
- Assumes "TexturePath" contains the user selected texture.
:NOTE
--]]
function TitanPanel_SetTexture(frame, position)
	if frame and TitanBarData[frame] then
		-- proceed
	else
		return
	end
	-- Determine the bar that needs the texture applied.
	local bar = TitanBarData[frame].name
	local vert = TitanBarData[frame].vert
	local tex = "TitanPanelBackground"
	local tex_pre = tex.."_"..bar.."_"

	-- Create the path & file name to the texture
	local texture_file = TitanPanelGetVar("TexturePath")..tex..vert.."0"
	-- include the normal bar (numOfTextures) and hider textures (numOfTexturesHider)
	for i = 0, numOfTexturesHider do
		_G[tex_pre..i]:SetTexture(texture_file);			
	end
end

--------------------------------------------------------------
--
-- auto hide event handlers
--[[ Titan
NAME: TitanPanelBarButton_OnLeave
DESC: On leaving the display check if we have to hide the Titan bar. A timer is used - when it expires the bar is hid.
VAR: self - expected to be a Titan bar
OUT: None
--]]
function TitanPanelBarButton_OnLeave(self)
	local frame = (self and self:GetName() or nil)
	local bar = (TitanBarData[frame] and TitanBarData[frame].name or nil)
	
	-- if auto hide is active then let the timer hide the bar
	local hide = (bar and TitanPanelGetVar(bar.."_Hide") or nil)
	if hide then
		Titan_AutoHide_Timers(frame, "Leave")
	end
end

--[[ Titan
NAME: TitanPanelBarButton_OnEnter
DESC: No code - this is a place holder for the XML template.
VAR: self - expected to be a Titan bar
OUT: None
--]]
function TitanPanelBarButton_OnEnter(self)
	-- no work to do
end

--[[ Titan
NAME: TitanPanelBarButtonHider_OnLeave
DESC: No code - this is a place holder for the XML template.
VAR: self - expected to be a Titan bar
OUT: None
--]]
function TitanPanelBarButtonHider_OnLeave(self)
	-- no work to do
end

--[[ Titan
NAME: TitanPanelBarButtonHider_OnEnter
DESC: On entering the hider check if we need to show the display bar.
VAR: self - expected to be a Titan hider bar
OUT: None
NOTE:
- No action is taken if the user is on combat.
:NOTE
--]]
function TitanPanelBarButtonHider_OnEnter(self)
	-- make sure self is valid
	local index = self and self:GetName() or nil
	if not index then return end -- sanity check

	-- so the bar does not 'appear' when moused over in combat
	if TitanPanelGetVar("LockAutoHideInCombat") and InCombatLockdown() then return end 

	-- find the relevant bar data
	local frame = nil
	for idx,v in pairs (TitanBarData) do
		if index == TitanBarData[idx].hider then
			frame = idx
		end
	end
	-- Now process that bar
	if frame then
		Titan_AutoHide_Timers(frame, "Enter")
		TitanPanelBarButton_Show(frame)
	end
end

--------------------------------------------------------------
--
-- Titan features
--[[ Titan
NAME: TitanPanelBarButton_ToggleAlign
DESC: Align the buttons per the user's new choice.
VAR: align - left or center
OUT: None
--]]
function TitanPanelBarButton_ToggleAlign(align)
	-- toggle between left or center
	if ( TitanPanelGetVar(align) == TITAN_PANEL_BUTTONS_ALIGN_CENTER ) then
		TitanPanelSetVar(align, TITAN_PANEL_BUTTONS_ALIGN_LEFT);
	else
		TitanPanelSetVar(align, TITAN_PANEL_BUTTONS_ALIGN_CENTER);
	end
	
	-- Justify button position
	TitanPanelButton_Justify();
end

--[[ Titan
NAME: TitanPanelBarButton_ToggleAutoHide
DESC: Toggle the auto hide of the given Titan bar per the user's new choice.
VAR: frame - expected to be a Titan bar
OUT:  None
--]]
function TitanPanelBarButton_ToggleAutoHide(frame)
	local frName = _G[frame]
	local plugin = (TitanBarData[frame] and TitanBarData[frame].auto_hide_plugin or nil)

	if frName then
		Titan_AutoHide_ToggleAutoHide(_G[plugin])
	end
end

--[[ Titan
NAME: TitanPanelBarButton_ToggleScreenAdjust
DESC: Toggle whether Titan adjusts 'top' frames around Titan bars per the user's new choice.
VAR:  None
NOTE:
- Another addon can tell Titan to NOT adjust some or all frames.
:NOTE
--]]
function TitanPanelBarButton_ToggleScreenAdjust()
	-- Turn on / off adjusting of other frames around Titan
	TitanPanelToggleVar("ScreenAdjust");
	TitanPanel_AdjustFrames(TITAN_PANEL_PLACE_TOP, true)
end

--[[ Titan
NAME: TitanPanelBarButton_ToggleAuxScreenAdjust
DESC: Toggle whether Titan adjusts 'bottom' frames around Titan bars per the user's new choice.
VAR:  None
OUT:  None
NOTE:
- Another addon can tell Titan to NOT adjust some or all frames.
:NOTE
--]]
function TitanPanelBarButton_ToggleAuxScreenAdjust()
	-- turn on / off adjusting of frames at the bottom of the screen
	TitanPanelToggleVar("AuxScreenAdjust");
	TitanPanel_AdjustFrames(TITAN_PANEL_PLACE_BOTTOM, true)
end

--[[ Titan
NAME: TitanPanelBarButton_ForceLDBLaunchersRight
DESC: Force all plugins created from LDB addons, visible or not, to be on the right side of the Titan bar. Any visible plugin will be forced to the right side on the same bar it is currently on.
VAR:  None
OUT:  None
--]]
function TitanPanelBarButton_ForceLDBLaunchersRight()
	local plugin, index, id;
	for index, id in pairs(TitanPluginsIndex) do
		plugin = TitanUtils_GetPlugin(id);
		if plugin.ldb == "launcher" 
		and not TitanGetVar(id, "DisplayOnRightSide") then
			TitanToggleVar(id, "DisplayOnRightSide");
			local button = TitanUtils_GetButton(id);
			local buttonText = _G[button:GetName()..TITAN_PANEL_TEXT];
			if not TitanGetVar(id, "ShowIcon") then
				TitanToggleVar(id, "ShowIcon");	
			end
			TitanPanelButton_UpdateButton(id);
			if buttonText then
				buttonText:SetText("")
				button:SetWidth(16);
				TitanPlugins[id].buttonTextFunction = nil;
				_G["TitanPanel"..id..TITAN_PANEL_BUTTON_TEXT] = nil;
				if button:IsVisible() then
					local bar = TitanUtils_GetWhichBar(id)
					TitanPanel_RemoveButton(id);
					TitanUtils_AddButtonOnBar(bar, id)     
				end
			end
		end
	end
end

--[[ local
NAME: TitanAnchors
DESC: Helper to create the 'anchor' frames used by other addons that need to adjust so Titan can be visible. The anchor frames are adjusted depending on which Titan bars the user selects to show.
VAR:  None
OUT:  None
NOTE:
- TitanPanelTopAnchor - the frame at the bottom of the top bar(s) shown.
- TitanPanelBottomAnchor - the frame at the top of the bottom bar(s) shown.
:NOTE
--]]
local function TitanAnchors()
	local anchor_top = TitanMovable_GetPanelYOffset(TITAN_PANEL_PLACE_TOP)
	local anchor_bot = TitanMovable_GetPanelYOffset(TITAN_PANEL_PLACE_BOTTOM)
	anchor_top = anchor_top <= TITAN_WOW_SCREEN_TOP and anchor_top or TITAN_WOW_SCREEN_TOP
	anchor_bot = anchor_bot >= TITAN_WOW_SCREEN_BOT and anchor_bot or TITAN_WOW_SCREEN_BOT

	local top_point, top_rel_to, top_rel_point, top_x, top_y = TitanPanelTopAnchor:GetPoint(TitanPanelTopAnchor:GetNumPoints())
	local bot_point, bot_rel_to, bot_rel_point, bot_x, bot_y = TitanPanelBottomAnchor:GetPoint(TitanPanelBottomAnchor:GetNumPoints())
	top_y = floor(tonumber(top_y) + 0.5)
	bot_y = floor(tonumber(bot_y) + 0.5)
--[[
TitanDebug("Anc top: "..top_y.." bot: "..bot_y
.." a_top: "..anchor_top.." a_bot: "..anchor_bot
)
--]]
	if top_y ~= anchor_top then
		TitanPanelTopAnchor:ClearAllPoints()
		TitanPanelTopAnchor:SetPoint(top_point, top_rel_to, top_rel_point, top_x, anchor_top);
--TitanDebug("Anc top: "..top_y.." -> "..anchor_top)
	end
	if bot_y ~= anchor_bot then
		TitanPanelBottomAnchor:ClearAllPoints()
		TitanPanelBottomAnchor:SetPoint(bot_point, bot_rel_to, bot_rel_point, bot_x, anchor_bot)
--TitanDebug("Anc bot: "..bot_y.." -> "..anchor_bot)
	end
end

--[[ Titan
NAME: TitanPanelBarButton_DisplayBarsWanted
DESC: Show all the Titan bars the user has selected.
VAR:  None
OUT:  None
--]]
function TitanPanelBarButton_DisplayBarsWanted()
	-- Check all bars to see if the user has requested they be shown
	for idx,v in pairs (TitanBarData) do
		-- Show / hide plus kick auto hide, if needed
		Titan_AutoHide_Init((_G[TitanBarData[idx].auto_hide_plugin] or nil))
	end
	
	-- Set anchors for other addons to use.
	TitanAnchors()
	
	-- Adjust other frames because the bars shown / hidden may have changed
	TitanPanel_AdjustFrames(TITAN_PANEL_PLACE_BOTH, true)
end

--[[ Titan
NAME: TitanPanelBarButton_HideAllBars
DESC: This routine will hide all the Titan bars (and hiders) regardless of what the user has selected.  
VAR:  None
OUT:  None
NOTE: 
- For example when the pet battle is active. We cannot figure out how to move the pet battle frame so we are punting and hiding Titan...
- We only need to hide the bars (and hiders) - not adjust frames
:NOTE
--]]
function TitanPanelBarButton_HideAllBars()
	-- Check all bars to see if the user has requested they be shown
	for idx,v in pairs (TitanBarData) do
		local bar = TitanBarData[idx].name
		local hider = _G[TitanBarData[idx].hider]
		local hide = TitanBarData[idx].hide
--[[
TitanDebug("_HideAllBars: "
.."idx: "..(idx or "?").." "
.."bar: "..(bar or "?").." "
.."hider: "..(TitanBarData[idx].hider or "?").." "
)
--]]
		-- Hide the Titan bar. The hider bar MAY be hidden as well
		TitanPanelBarButton_Hide(idx)
		-- In case the user selected auto hide for this bar we need to hide it as well
		if (TitanPanelGetVar(bar.."_Show")) and (TitanPanelGetVar(bar.."_Hide")) then
			hider:ClearAllPoints();
			hider:SetPoint(hide.top.pt, hide.top.rel_fr, hide.top.rel_pt, hide.top.x, hide.top.y); 
			hider:SetPoint(hide.bot.pt, hide.bot.rel_fr, hide.bot.rel_pt, hide.bot.x, hide.bot.y);
		end
	end
end

--[[ Titan
NAME: TitanPanelBarButton_Show
DESC: Show / hide the given Titan bar based on the user selection.
VAR: frame - expected to be a Titan bar name (string)
OUT:  None
NOTE: 
- Hide moves rather than just 'not shown'. Otherwise the buttons will stay visible defeating the purpose of hide.
:NOTE
--]]
function TitanPanelBarButton_Show(frame)
	local display = _G[frame];
	local bar = (TitanBarData[frame].name or nil)
	local hide = TitanBarData[frame] and TitanBarData[frame].hide or nil
	local show = TitanBarData[frame] and TitanBarData[frame].show or nil
	local hider = _G[TitanBarData[frame].hider] or nil

	if bar and display and hider and show and hide 
	then
		-- Show the display bar if the user requested it
		if (TitanPanelGetVar(bar.."_Show")) then
			if hide and show then
				display:ClearAllPoints();
				display:SetPoint(show.top.pt, show.top.rel_fr, show.top.rel_pt, show.top.x, show.top.y); 
				display:SetPoint(show.bot.pt, show.bot.rel_fr, show.bot.rel_pt, show.bot.x, show.bot.y);
				
				hider:Hide()
			end
		else
			-- The user has not elected to show this bar
			display:ClearAllPoints();
			display:SetPoint(hide.top.pt, hide.top.rel_fr, hide.top.rel_pt, hide.top.x, hide.top.y); 
			display:SetPoint(hide.bot.pt, hide.bot.rel_fr, hide.bot.rel_pt, hide.bot.x, hide.bot.y);
			hider:ClearAllPoints();
			hider:SetPoint(hide.top.pt, hide.top.rel_fr, hide.top.rel_pt, hide.top.x, hide.top.y); 
			hider:SetPoint(hide.bot.pt, hide.bot.rel_fr, hide.bot.rel_pt, hide.bot.x, hide.bot.y);
		end
	end
end

--[[ Titan
NAME: TitanPanelBarButton_Hide
DESC: Hide the given Titan bar based on the user selection.
VAR: frame - expected to be a Titan bar name (string)
OUT:  None
NOTE: 
- Hide moves rather than just 'not shown'. Otherwise the buttons will stay visible defeating the purpose of hide.
- Also moves the hider bar if auto hide is not selected.
:NOTE
--]]
function TitanPanelBarButton_Hide(frame)
	if TITAN_PANEL_MOVING == 1 then return end

	local display = _G[frame]
	local data = TitanBarData[frame]
	local hider = _G[data.hider]
	local bar = (data.name or nil)
	local hide = data.hide or nil
	local show = data.show or nil

	if display and hider and bar and show and hide then
		-- This moves rather than hides. If we just hide then
		-- the plugins will still show.
		display:ClearAllPoints();
		display:SetPoint(hide.top.pt, hide.top.rel_fr, hide.top.rel_pt, hide.top.x, hide.top.y); 
		display:SetPoint(hide.bot.pt, hide.bot.rel_fr, hide.bot.rel_pt, hide.bot.x, hide.bot.y);
		if (TitanPanelGetVar(bar.."_Show")) and (TitanPanelGetVar(bar.."_Hide")) then
			-- Auto hide is requested so show the hider bar in the right place
			hider:ClearAllPoints();
			hider:SetPoint(show.top.pt, show.top.rel_fr, show.top.rel_pt, show.top.x, show.top.y); 
			hider:SetPoint(show.bot.pt, show.bot.rel_fr, show.bot.rel_pt, show.bot.x, show.bot.y);
			hider:Show()
		else
			-- The bar was not requested so also move the hider bar to the right place
			hider:ClearAllPoints();
			hider:SetPoint(hide.top.pt, hide.top.rel_fr, hide.top.rel_pt, hide.top.x, hide.top.y); 
			hider:SetPoint(hide.bot.pt, hide.bot.rel_fr, hide.bot.rel_pt, hide.bot.x, hide.bot.y);
		end
	end
end

--[[ Titan
NAME: TitanPanel_InitPanelBarButton
DESC: Set the scale, texture (graphic), and transparancy of all the Titan bars based on the user selection.
VAR:  None
OUT:  None
--]]
function TitanPanel_InitPanelBarButton()
	-- Set initial Panel Scale
	TitanPanel_SetScale();
	-- Create textures for the first time
	if numOfTextures == 0 then TitanPanel_CreateBarTextures() end

	-- Reposition textures if needed
	TitanPanel_CreateBarTextures()
	for idx,v in pairs (TitanBarData) do
		TitanPanel_SetTexture(TITAN_PANEL_DISPLAY_PREFIX..TitanBarData[idx].name, TITAN_PANEL_PLACE_TOP);
	end
	
	-- Set transparency of the bars
	local bar = ""
	local plugin = nil
	for idx,v in pairs (TitanBarData) do
		-- Set the transparency of each bar
		bar = TitanBarData[idx].name
		_G[idx]:SetAlpha(TitanPanelGetVar(bar.."_Transparency"))
	end
end

--[[ Titan
NAME: TitanPanel_InitPanelButtons
DESC: Show all user selected plugins on the Titan bar(s) then justify per the user selection.
VAR:  None
OUT:  None
--]]
function TitanPanel_InitPanelButtons()
	local button
	local r_prior = {}
	local l_prior = {}
	local scale = TitanPanelGetVar("Scale");
	local button_spacing = TitanPanelGetVar("ButtonSpacing") * scale
	local icon_spacing = TitanPanelGetVar("IconSpacing") * scale
--	
	local prior = {}
	-- set prior to the starting offsets
	-- The right side plugins are set here.
	-- Justify adjusts the left side start according to the user setting
	-- The effect is left side plugins has spacing on the right side and
	-- right side plugins have spacing on the left.
	for idx,v in pairs (TitanBarData) do
		local bar = TitanBarData[idx].name
		local y_off = TitanBarData[idx].plugin_y_offset
		prior[bar] = {
			right = { 
				button = TITAN_PANEL_DISPLAY_PREFIX..bar, 
				anchor = "RIGHT",
				x = 5, -- Offset of first plugin to right side of screen
				y = y_off,
				},
			left = {
				button = TITAN_PANEL_DISPLAY_PREFIX..bar, 
				anchor = "LEFT",
				x = 0, -- Justify adjusts - center or not
				y = y_off,
				},
			}
	end
--	
	TitanPanelBarButton_DisplayBarsWanted();

	-- Position all the buttons 
	for i = 1, table.maxn(TitanPanelSettings.Buttons) do 
	
		local id = TitanPanelSettings.Buttons[i];
		if ( TitanUtils_IsPluginRegistered(id) ) then
			local i = TitanPanel_GetButtonNumber(id);
			button = TitanUtils_GetButton(id);

			-- If the plugin has asked to be on the right
			if TitanUtils_ToRight(id) then	
				-- =========================
				-- position the plugin relative to the prior plugin 
				-- or the bar if it is the 1st
				r_prior = prior[TitanPanelSettings.Location[i]].right
				-- =========================
				button:ClearAllPoints();
				button:SetPoint("RIGHT", _G[r_prior.button]:GetName(), r_prior.anchor, (-(r_prior.x) * scale), r_prior.y); 

				-- =========================
				-- capture the button for the next plugin
				r_prior.button = "TitanPanel"..id.."Button"
				-- set prior[x] the anchor points and offsets for the next plugin
				r_prior.anchor = "LEFT"
				r_prior.x = icon_spacing
				r_prior.y = 0
				-- =========================
			else
				--  handle plugins on the left side of the bar
				--
				-- =========================
				-- position the plugin relative to the prior plugin 
				-- or the bar if it is the 1st
				l_prior = prior[TitanPanelSettings.Location[i]].left
				-- =========================
				--
				button:ClearAllPoints();
				button:SetPoint("LEFT", _G[l_prior.button]:GetName(), l_prior.anchor, l_prior.x * scale, l_prior.y);
					
				-- =========================
				-- capture the next plugin
				l_prior.button = "TitanPanel"..id.."Button"
				-- set prior[x] (anchor points and offsets) for the next plugin
				l_prior.anchor = "RIGHT"
				l_prior.x = (button_spacing)
				l_prior.y = 0
				-- =========================
			end
			button:Show();
		end
	end
	-- Set panel button init flag
	TITAN_PANEL_BUTTONS_INIT_FLAG = 1;
	TitanPanelButton_Justify();
end

--[[ Titan
NAME: TitanPanel_ReOrder
DESC: Reorder all the shown all user selected plugins on the Titan bar(s). Typically used after a button has been removed / hidden.
VAR: index - the index of the plugin removed so the list can be updated
OUT:  None
--]]
function TitanPanel_ReOrder(index)
	for i = index, table.getn(TitanPanelSettings.Buttons) do		
		TitanPanelSettings.Location[i] = TitanPanelSettings.Location[i+1]
	end
end

--[[ Titan
NAME: TitanPanel_RemoveButton
DESC: Remove a plugin then show all the shown all user selected plugins on the Titan bar(s).
VAR:  id - the plugin name (string)
OUT:  None
NOTE:
- This cancels all timers of name "TitanPanel"..id as a safeguard to destroy any active plugin timers based on a fixed naming convention : TitanPanel..id, eg. "TitanPanelClock" this prevents "rogue" timers being left behind by lack of an OnHide check
:NOTE
--]]
function TitanPanel_RemoveButton(id)
	if ( not TitanPanelSettings ) then
		return;
	end 

	local i = TitanPanel_GetButtonNumber(id)
	local currentButton = TitanUtils_GetButton(id);
	
	-- safeguard ...
	if id then AceTimer.CancelAllTimers("TitanPanel"..id) end

	TitanPanel_ReOrder(i);
	table.remove(TitanPanelSettings.Buttons, TitanUtils_GetCurrentIndex(TitanPanelSettings.Buttons, id));
--TitanDebug("_Remove: "..(id or "?").." "..(i or "?"))
	if currentButton then
		currentButton:Hide();
	end
	-- Show the existing buttons
	TitanPanel_InitPanelButtons();
end

--[[ Titan
NAME: TitanPanel_GetButtonNumber
DESC: Get the index of the given plugin from the Titan plugin displayed list.
VAR: id - the plugin name (string)
OUT: index of the plugin in the Titan plugin list or the end of the list. The routine returns +1 if not found so it is 'safe' to update / add to the Location
--]]
function TitanPanel_GetButtonNumber(id)
	if (TitanPanelSettings) then
		for i = 1, table.getn(TitanPanelSettings.Buttons) do		
			if(TitanPanelSettings.Buttons[i] == id) then
				return i;
			end	
		end
		return table.getn(TitanPanelSettings.Buttons)+1;
	else
		return 0;
	end
end

--[[ Titan
NAME: TitanPanel_RefreshPanelButtons
DESC: Update / refresh each plugin from the Titan plugin list. Used when a Titan option is changed that effects all plugins.
VAR:  None
OUT:  None
--]]
function TitanPanel_RefreshPanelButtons()
	if (TitanPanelSettings) then
		for i = 1, table.getn(TitanPanelSettings.Buttons) do		
			TitanPanelButton_UpdateButton(TitanPanelSettings.Buttons[i], 1);		
		end
	end
end

--[[ Titan
NAME: TitanPanelButton_Justify
DESC: Justify the plugins on each Titan bar. Used when the user changes the 'center' option on a Titan bar.
VAR:  None
OUT:  None
--]]
function TitanPanelButton_Justify()
	-- Only the left side buttons are justified.
	if ( not TITAN_PANEL_BUTTONS_INIT_FLAG or not TitanPanelSettings ) then
		return;
	end
	if InCombatLockdown() then
--TitanDebug("_Justify during combat!!!")
		return;
		-- Issue 856 where some taint is caused if the plugin size is updated during combat. Seems since Mists was released...
	end

	local bar
	local vert
	local y_offset
	local firstLeftButton
	local scale = TitanPanelGetVar("Scale");
	local button_spacing = TitanPanelGetVar("ButtonSpacing") * scale
	local icon_spacing = TitanPanelGetVar("IconSpacing") * scale
	local leftWidth = 0;
	local rightWidth = 0;
	local counter = 0;
	local align = 0;
	local center_offset = 0;

	-- Look at each bar for plugins.
	for idx,v in pairs (TitanBarData) do
		bar = TitanBarData[idx].name
		vert = TitanBarData[idx].vert
		y_offset = TitanBarData[idx].plugin_y_offset
		firstLeftButton = TitanUtils_GetButton(TitanPanelSettings.Buttons[TitanUtils_GetFirstButtonOnBar (bar, TITAN_LEFT)])
		align = TitanPanelGetVar(bar.."_Align")
		leftWidth = 0;
		rightWidth = 0;
		counter = 0;
		-- If there is a plugin on this bar then justify the first button.
		-- The other buttons are relative to the first.
		if ( firstLeftButton ) then
			if ( align == TITAN_PANEL_BUTTONS_ALIGN_LEFT ) then
				-- Now offset the plugins
				firstLeftButton:ClearAllPoints();
				firstLeftButton:SetPoint("LEFT", idx, "LEFT", 5, y_offset); 
			end
			-- Center if requested
			if ( align == TITAN_PANEL_BUTTONS_ALIGN_CENTER ) then
				leftWidth = 0;
				rightWidth = 0;
				counter = 0;
				-- Calc the total width of the icons so we know where to start
				for index, id in pairs(TitanPanelSettings.Buttons) do
					local button = TitanUtils_GetButton(id);
					if button and button:GetWidth() then
						if TitanUtils_GetWhichBar(id) == bar then
							if ( TitanPanelButton_IsIcon(id) 
							or (TitanGetVar(id, "DisplayOnRightSide")) ) then
								rightWidth = rightWidth 
									+ icon_spacing 
									+ button:GetWidth();
							else
								counter = counter + 1;
								leftWidth = leftWidth 
									+ button_spacing
									+ button:GetWidth()
							end
						end
					end
				end
				-- Now offset the plugins on the bar
				firstLeftButton:ClearAllPoints();
				-- remove the last spacing otherwise the buttons appear justified too far left
				center_offset = (0 - (leftWidth-button_spacing) / 2)
				firstLeftButton:SetPoint("LEFT", idx, "CENTER", center_offset, y_offset); 
			end
		end
	end
end

--[[ Titan
NAME: TitanPanel_SetScale
DESC: Set the scale of each plugin and each Titan bar.
VAR:  None
OUT:  None
--]]
function TitanPanel_SetScale()
	local scale = TitanPanelGetVar("Scale");

	-- Set all the Titan bars
	for idx,v in pairs (TitanBarData) do
		local bar_name = TITAN_PANEL_DISPLAY_PREFIX..TitanBarData[idx].name
		_G[bar_name]:SetScale(scale)
	end
	-- Set all the registered plugins
	for index, value in pairs(TitanPlugins) do
		if index then
			TitanUtils_GetButton(index):SetScale(scale);
		end
	end
end

--------------------------------------------------------------
--
-- Local routines for Titan menu creation
--[[ local
NAME: TitanPanelRightClickMenu_BarOnClick
DESC: Show / hide a plugin. Used by the Titan (right click) menu.
VAR: checked - true (show) or false (hide)
VAR: value - the plugin id
OUT:  None
--]]
local function TitanPanelRightClickMenu_BarOnClick(checked, value)
	-- we need to know which bar the user clicked to get the menu...
	local frame = TitanPanel_DropMenu:GetParent():GetName()
	local bar = TitanBarData[frame].name

	if checked then
		TitanPanel_RemoveButton(value);		
	else
		TitanUtils_AddButtonOnBar(bar, value)
	end
end

--[[ local
NAME: TitanPanel_MainMenu
DESC: Show main Titan (right click) menu.
VAR:  None
OUT:  None
--]]
local function TitanPanel_MainMenu()	
	local info = {};

	-----------------
	-- Menu title 
	TitanPanelRightClickMenu_AddTitle(L["TITAN_PANEL_MENU_TITLE"]);
	TitanPanelRightClickMenu_AddSpacer(UIDROPDOWNMENU_MENU_LEVEL);
	
	TitanPanelRightClickMenu_AddTitle(L["TITAN_PANEL_MENU_PLUGINS"]);

	-----------------
	-- Plugin Categories
	for index, id in pairs(L["TITAN_PANEL_MENU_CATEGORIES"]) do
		info = {};
		info.notCheckable = true
		info.text = L["TITAN_PANEL_MENU_CATEGORIES"][index];
		info.value = "Addons_" .. TITAN_PANEL_BUTTONS_PLUGIN_CATEGORY[index];
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info);
	end

	TitanPanelRightClickMenu_AddSpacer();

	-----------------
	-- Options - just one button to open the first Titan option screen
 	info = {};
	info.notCheckable = true
	info.text = L["TITAN_PANEL_MENU_CONFIGURATION"];
	info.value = "Bars";	
	info.func = function() 
		InterfaceOptionsFrame_OpenToCategory(L["TITAN_PANEL_MENU_TOP_BARS"]) 
	end
	UIDropDownMenu_AddButton(info);

	TitanPanelRightClickMenu_AddSpacer();
	
	-----------------
	-- Profiles
	TitanPanelRightClickMenu_AddTitle(L["TITAN_PANEL_MENU_PROFILES"]);
	
	-----------------
	-- Load/Delete
	info = {};
	info.notCheckable = true
	info.text = L["TITAN_PANEL_MENU_MANAGE_SETTINGS"];
	info.value = "Settings";
	info.hasArrow = 1;
	-- lock this menu in combat
	if InCombatLockdown() then
		info.disabled = 1;
		info.hasArrow = nil;
		info.text = info.text.." "
			.._G["GREEN_FONT_COLOR_CODE"]
			..L["TITAN_PANEL_MENU_IN_COMBAT_LOCKDOWN"];
		end
	UIDropDownMenu_AddButton(info);
	
	-----------------
	-- Save
	info = {};
	info.notCheckable = true
	info.text = L["TITAN_PANEL_MENU_SAVE_SETTINGS"];
	info.value = "SettingsCustom";
	info.func = TitanPanel_SaveCustomProfile;
	-- lock this menu in combat
	if InCombatLockdown() then
		info.disabled = 1;
		info.text = info.text.." "
			.._G["GREEN_FONT_COLOR_CODE"]
			..L["TITAN_PANEL_MENU_IN_COMBAT_LOCKDOWN"];
		end
	UIDropDownMenu_AddButton(info);

	local glob, name, player, server = TitanUtils_GetGlobalProfile()
	info = {};
	info.text = "Use Global Profile"
	info.value = "Use Global Profile"				
	info.func = function() 
		TitanUtils_SetGlobalProfile(not glob, toon)
		TitanVariables_UseSettings(nil, TITAN_PROFILE_USE)
	end;
	info.checked = glob --TitanAllGetVar("GlobalProfileUse")
	info.keepShownOnClick = nil
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	
	--local player, server = TitanUtils_ParseName(TitanAllGetVar("GlobalProfileName"))
	info = {};
	info.notCheckable = true
	info.text = "   "..TitanUtils_GetGreenText(server)
	info.value = "server";
	UIDropDownMenu_AddButton(info);

	info = {};
	info.notCheckable = true
	info.text = "      "..TitanUtils_GetGreenText(player)
	info.value = "player";
	UIDropDownMenu_AddButton(info);

end

--[[ local
NAME: TitanPanel_ServerSettingsMenu
DESC: Show list of servers / custom submenu off Profiles/Manage from the Titan (right click) menu.
VAR:  None
OUT:  None
--]]
local function TitanPanel_ServerSettingsMenu()
	local info = {};
	local servers = {};
	local player = nil;
	local server = nil;
	local s, e, ident;
	local setonce = 0;

	if ( UIDROPDOWNMENU_MENU_VALUE == "Settings" ) then
		TitanPanelRightClickMenu_AddTitle(L["TITAN_PANEL_MENU_PROFILE_SERVERS"],
			UIDROPDOWNMENU_MENU_LEVEL);
		-- Normal profile per toon
		for index, id in pairs(TitanSettings.Players) do
			player, server = TitanUtils_ParseName(index)
			
			if TitanUtils_GetCurrentIndex(servers, server) == nil then
				if server ~= TITAN_CUSTOM_PROFILE_POSTFIX then
					table.insert(servers, server);	
					info = {};
					info.notCheckable = true
					info.text = server;
					info.value = server;
					info.hasArrow = 1;
					UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
				end
			end
		end
		-- Custom profiles
		for index, id in pairs(TitanSettings.Players) do
			player, server = TitanUtils_ParseName(index)
			
			if TitanUtils_GetCurrentIndex(servers, server) == nil then
				if server == TITAN_CUSTOM_PROFILE_POSTFIX then
					if setonce and setonce == 0 then
						TitanPanelRightClickMenu_AddTitle("", UIDROPDOWNMENU_MENU_LEVEL);
						TitanPanelRightClickMenu_AddTitle(L["TITAN_PANEL_MENU_PROFILE_CUSTOM"], UIDROPDOWNMENU_MENU_LEVEL);
					setonce = 1;
					end
					info = {};
					info.notCheckable = true
					info.text = player;
					info.value = player;
					info.hasArrow = 1;
					UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
				end
			end
		end
	end
end

--[[ Titan
NAME: TitanPanel_PlayerSettingsMenu
DESC: Show list of toons submenu off Profiles/Manage/<server or custom> from the Titan (right click) menu.
VAR:  None
OUT:  None
NOTE:
- There are 2 level 3 menus possible
  1) Under profiles, then value could be the server of a saved toon
  2) Under plugins value could be the options of a plugin
:NOTE
--]]
local function TitanPanel_PlayerSettingsMenu()
	--
	local info = {};
	local player = nil;
	local server = nil;
	local s, e, ident;
	local plugin, profname;
	local setonce = 0;
	local off = nil

	-- 
	-- Handle the profiles
	--
	for index, id in pairs(TitanSettings.Players) do
		player, server = TitanUtils_ParseName(index)
		off = (index == TitanSettings.Player)
				or ((index == TitanAllGetVar("GlobalProfileUse")) and (TitanAllGetVar("GlobalProfileUse")))

		-- handle custom profiles here
		if server == TITAN_CUSTOM_PROFILE_POSTFIX 
		and player == UIDROPDOWNMENU_MENU_VALUE then
			info = {};
			info.notCheckable = true
			info.disabled = TitanAllGetVar("GlobalProfileUse")
			info.text = L["TITAN_PANEL_MENU_LOAD_SETTINGS"];
			info.value = index;
			info.func = function() 
				TitanVariables_UseSettings(index, TITAN_PROFILE_USE)
			end
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			
			info = {};
			info.notCheckable = true
			info.disabled = off
			info.text = L["TITAN_PANEL_MENU_DELETE_SETTINGS"];
			info.value = index;
			info.func = function()			  
				if TitanSettings.Players[info.value] then
					TitanSettings.Players[info.value] = nil;
					profname, _ = TitanUtils_ParseName(index)
					TitanPrint(
						L["TITAN_PANEL_MENU_PROFILE"]
						.." '"..profname.."' "
						..L["TITAN_PANEL_MENU_PROFILE_DELETED"]
						, "info")
					TitanPanelRightClickMenu_Close();
				end
			end
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
		end -- if server and player
		
		-- handle regular profiles here
		if server == UIDROPDOWNMENU_MENU_VALUE then
			-- Set the label once
			if setonce and setonce == 0 then
				TitanPanelRightClickMenu_AddTitle(L["TITAN_PANEL_MENU_PROFILE_CHARS"], UIDROPDOWNMENU_MENU_LEVEL);
				setonce = 1;
			end
			info = {};
			info.notCheckable = true
			info.text = player;
			info.value = index;
			info.hasArrow = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
		end		
	end -- for players
	
	-- 
	-- Handle the plugins
	--
	for index, id in pairs(TitanPluginsIndex) do
		plugin = TitanUtils_GetPlugin(id);
		if plugin.id and plugin.id == UIDROPDOWNMENU_MENU_VALUE then
			--title
			info = {};
			info.text = TitanPlugins[plugin.id].menuText;
			info.notCheckable = true
			info.notClickable = 1;
			info.isTitle = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			--ShowIcon
			if plugin.controlVariables.ShowIcon then
				info = {};
				info.text = L["TITAN_PANEL_MENU_SHOW_ICON"];
				info.value = {id, "ShowIcon", nil};
				info.func = function()
					TitanPanelRightClickMenu_ToggleVar({id, "ShowIcon", nil})
				end
				info.keepShownOnClick = 1;
				info.checked = TitanGetVar(id, "ShowIcon");
				info.disabled = nil;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end
			
			--ShowLabel
			if plugin.controlVariables.ShowLabelText then
				info = {};
				info.text = L["TITAN_PANEL_MENU_SHOW_LABEL_TEXT"];
				info.value = {id, "ShowLabelText", nil};
				info.func = function()
					TitanPanelRightClickMenu_ToggleVar({id, "ShowLabelText", nil})
				end
				info.keepShownOnClick = 1;
				info.checked = TitanGetVar(id, "ShowLabelText");
				info.disabled = nil;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end
			
			--ShowRegularText (LDB data sources only atm)
			if plugin.controlVariables.ShowRegularText then
				info = {};
				info.text = L["TITAN_PANEL_MENU_SHOW_PLUGIN_TEXT"]
				info.value = {id, "ShowRegularText", nil};
				info.func = function()
					TitanPanelRightClickMenu_ToggleVar({id, "ShowRegularText", nil})
				end
				info.keepShownOnClick = 1;
				info.checked = TitanGetVar(id, "ShowRegularText");
				info.disabled = nil;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end
			
			--ShowColoredText
			if plugin.controlVariables.ShowColoredText then
				info = {};
				info.text = L["TITAN_PANEL_MENU_SHOW_COLORED_TEXT"];
				info.value = {id, "ShowColoredText", nil};
				info.func = function()
					TitanPanelRightClickMenu_ToggleVar({id, "ShowColoredText", nil})
				end
				info.keepShownOnClick = 1;
				info.checked = TitanGetVar(id, "ShowColoredText");
				info.disabled = nil;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end

			-- Right-side plugin
			if plugin.controlVariables.DisplayOnRightSide then
				info = {};
				info.text = L["TITAN_PANEL_MENU_LDB_SIDE"];
				info.func = function () 
					TitanToggleVar(id, "DisplayOnRightSide")
					local bar = TitanUtils_GetWhichBar(id)
					TitanPanel_RemoveButton(id);
					TitanUtils_AddButtonOnBar(bar, id);     
				end
				info.checked = TitanGetVar(id, "DisplayOnRightSide");
				info.disabled = nil;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end
		end				
	end	
end

--[[ Titan
NAME: TitanPanel_SettingsSelectionMenu
DESC: Show save / load submenu off Profiles/Manage/<server or custom>/<profile> from the Titan (right click) menu.
VAR:  None
OUT:  None
--]]
local function TitanPanel_SettingsSelectionMenu()
	local info = {};
	
	info = {};
	info.notCheckable = true
	info.disabled = TitanAllGetVar("GlobalProfileUse")
	info.text = L["TITAN_PANEL_MENU_LOAD_SETTINGS"];
	info.value = UIDROPDOWNMENU_MENU_VALUE;
	info.func = function() 
		TitanVariables_UseSettings(UIDROPDOWNMENU_MENU_VALUE, TITAN_PROFILE_USE)
	end
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	
	info = {};
	info.notCheckable = true
	info.disabled = (UIDROPDOWNMENU_MENU_VALUE == TitanSettings.Player)
		or ((UIDROPDOWNMENU_MENU_VALUE == TitanAllGetVar("GlobalProfileName")) 
			and (TitanAllGetVar("GlobalProfileUse")))
	info.text = L["TITAN_PANEL_MENU_DELETE_SETTINGS"];
	info.value = UIDROPDOWNMENU_MENU_VALUE;
	info.func = function()
		-- do not delete if current profile - .disabled
--[[
		local profilevalue, _, _ = TitanUtils_GetPlayer()
		if info.value == profilevalue then
			TitanPrint(L["TITAN_PANEL_ERROR_PROF_DELCURRENT"], "info")
			TitanPanelRightClickMenu_Close();
			return;
		end
--]]
		if TitanSettings.Players[info.value] then
			TitanSettings.Players[info.value] = nil;
			TitanPrint(
				L["TITAN_PANEL_MENU_PROFILE"]
				.." '"..info.value.."' "
				..L["TITAN_PANEL_MENU_PROFILE_DELETED"]
				, "info")
			TitanPanelRightClickMenu_Close();
		end
	end
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
end

--[[ Titan
NAME: TitanPanel_BuildOtherPluginsMenu
DESC: Show the submenu with list of plugin off the category from the Titan (right click) menu.
VAR:  None
OUT:  None
--]]
local function TitanPanel_BuildOtherPluginsMenu(frame)
	local info = {};
	local plugin;

	for index, id in pairs(TitanPluginsIndex) do
		plugin = TitanUtils_GetPlugin(id);
		if not plugin.category then
			plugin.category = "General";
		end
		if ( UIDROPDOWNMENU_MENU_VALUE == "Addons_" .. plugin.category ) then
			if not TitanGetVar(id, "ForceBar") 
				or (TitanGetVar(id, "ForceBar") == TitanBarData[frame].name) then
				info = {};
				if plugin.version ~= nil and TitanPanelGetVar("VersionShown") then
					info.text = plugin.menuText
						..TitanUtils_GetGreenText(" (v"..plugin.version..")")
				else
					info.text = plugin.menuText;
				end
				if plugin.controlVariables then
					info.hasArrow = 1;
				end
				info.value = id;				
				info.func = function() 
						local checked = TitanPanel_IsPluginShown(id) or nil;
						TitanPanelRightClickMenu_BarOnClick(checked, id) 
					end;
				info.checked = TitanPanel_IsPluginShown(id) or nil
				info.keepShownOnClick = 1;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end
		end
	end
end

--[[ Titan
NAME: TitanPanelRightClickMenu_PrepareBarMenu
DESC: This is the controller to show the proper level of the Titan (right click) menu.
VAR: self - expected to be the Tian bar that was right clicked
OUT: None
--]]
function TitanPanelRightClickMenu_PrepareBarMenu(self)
	-- Determine which bar was clicked on
	-- This MUST match the convention used in TitanPanel.xml to declare
	-- the dropdown menu. ($parentRightClickMenu)
	local s, e, frame = string.find(self:GetName(), "(.*)RightClickMenu");

	-- Level 2
	if ( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
		TitanPanel_BuildOtherPluginsMenu(frame);
		TitanPanel_ServerSettingsMenu();
		return;
	end
	
	-- Level 3
	if ( UIDROPDOWNMENU_MENU_LEVEL == 3 ) then
		TitanPanel_PlayerSettingsMenu();
		return;
	end
	
	-- Level 4
	if ( UIDROPDOWNMENU_MENU_LEVEL == 4 ) then
		TitanPanel_SettingsSelectionMenu();
		return;
	end

	-- Level 1
	TitanPanel_MainMenu()
end

--[[ Titan
NAME: TitanPanel_IsPluginShown
DESC: Determine if the given plugin is shown on a Titan bar. The Titan bar could be not shown or on auto hide and the plugin will still be 'shown'.
VAR: id - plugin name (string)
OUT: int - index of the plugin or nil
--]]
function TitanPanel_IsPluginShown(id)
	if ( id and TitanPanelSettings ) then
		return TitanUtils_TableContainsValue(TitanPanelSettings.Buttons, id);
	end
end

--[[ Titan
NAME: TitanPanel_GetPluginSide
DESC: Determine if the given plugin is or would be on right or left of a Titan bar. This returns right or left regardless of whether the plugin is 'shown'.
VAR: id - plugin name (string)
OUT: string - "Right" or "Left"
--]]
function TitanPanel_GetPluginSide(id)
	if ( TitanGetVar(id, "DisplayOnRightSide") ) then
		return TITAN_RIGHT;
	elseif ( TitanPanelButton_IsIcon(id) ) then
		return TITAN_RIGHT;
	else
		return TITAN_LEFT;
	end
end

-- Below are deprecated routines.
-- They will be here for a couple releases then deleted.

--[[ Titan
NAME: TitanPanel_LoadError
DESC: Display a 'loading' error. Does not appear to be used.
VAR: ErrorMsg - message to display
OUT:  None
--]]
function TitanPanel_LoadError(ErrorMsg) 
	StaticPopupDialogs["LOADING_ERROR"] = {
		text = ErrorMsg,
		button1 = TEXT(OKAY),
		showAlert = 1,
		timeout = 0,
	};
	StaticPopup_Show("LOADING_ERROR");
end

--[[

--]]
