--[[ File
NAME: TitanVariables.lua
DESC: This file contains the routines to initialize, get, and set the basic data structures used by Titan. 
It also sets the global variables and constants used by Titan.

TitanSettings, TitanSkins, ServerTimeOffsets, ServerHourFormat are the structures saved to disk (listed in toc).
TitanSettings: is the table that holds the Titan variables by character and the plugins used by that character.
TitanSkins: is the table that holds the list of Titan and custom skins available to the user. It is assumed that the skins are in the proper folder on the hard drive. Blizzard does not allow addons to access the disk.
ServerTimeOffsets and ServerHourFormat: are the tables that hold the user selected hour offset and display format per realm (server).
:DESC
--]]
local L = LibStub("AceLocale-3.0"):GetLocale(TITAN_ID, true)
local _G = getfenv(0);
local media = LibStub("LibSharedMedia-3.0")

-- Global variables 
Titan__InitializedPEW = nil
Titan__Initialized_Settings = nil

TITAN_AT = "@"

TitanAll = nil;
TitanSettings = nil;
TitanPlayerSettings = nil
TitanPluginSettings = nil;  -- Used by plugins
TitanPanelSettings = nil;

TITAN_PANEL_UPDATE_BUTTON = 1;
TITAN_PANEL_UPDATE_TOOLTIP = 2;
TITAN_PANEL_UPDATE_ALL = 3;
TitanTooltipOrigScale = 1;
TitanTooltipScaleSet = 0;

-- Set Titan Version var for backwards compatibility
TITAN_VERSION = GetAddOnMetadata(TITAN_ID, "Version") or L["TITAN_NA"]

-- Various constants
TITAN_PANEL_PLACE_TOP = 1;
TITAN_PANEL_PLACE_BOTTOM = 2;
TITAN_PANEL_PLACE_BOTH = 3;
TITAN_PANEL_MOVING = 0;

TITAN_WOW_SCREEN_TOP = 768
TITAN_WOW_SCREEN_BOT = 0

TITAN_TOP = "Top"
TITAN_BOTTOM = "Bottom"
TITAN_RIGHT = "Right"
TITAN_LEFT = "Left"
TITAN_PANEL_BUTTONS_ALIGN_LEFT = 1;
TITAN_PANEL_BUTTONS_ALIGN_CENTER = 2;

TITAN_PANEL_CONTROL = "TitanPanelBarButton"
-- New bar vars
TITAN_PANEL_BAR_HEIGHT = 24
TITAN_PANEL_BAR_TEXTURE_HEIGHT = 30
TITAN_PANEL_AUTOHIDE_PREFIX = "TitanPanelAutoHide_"
TITAN_PANEL_AUTOHIDE_SUFFIX = "Button"
TITAN_PANEL_HIDE_PREFIX = "Titan_Bar__Hider_"
TITAN_PANEL_DISPLAY_PREFIX = "Titan_Bar__Display_"
TITAN_PANEL_DISPLAY_MENU = "Menu_"
--TITAN_PANEL_DISPLAY_ID = "Id_"
TITAN_PANEL_BACKGROUND_PREFIX = "TitanPanelBackground_"
TITAN_PANEL_TEXT = "Text"
TITAN_PANEL_BUTTON_TEXT = "Button"..TITAN_PANEL_TEXT
TITAN_PANEL_CONSTANTS = {
	FONT_SIZE = 10,
	FONT_NAME = "Friz Quadrata TT"
}
if (GetLocale() == "ruRU") then
    -- Special fix for Russian - "Friz Quadrata TT" does not seem to work
	TITAN_PANEL_CONSTANTS.FONT_NAME = "Arial Narrow"
end
local TPC = TITAN_PANEL_CONSTANTS -- shortcut

TITAN_CUSTOM_PROFILE_POSTFIX = "TitanCustomProfile"
TITAN_PROFILE_NONE = "<>"
TITAN_PROFILE_RESET = "<RESET>"
TITAN_PROFILE_USE = "<USE>"
TITAN_PROFILE_INIT = "<INIT>"

AUTOHIDE_PREFIX = "TitanPanelAutoHide_"
AUTOHIDE_SUFFIX = "Button"

TITAN_PANEL_BUTTONS_PLUGIN_CATEGORY = 
	{"Built-ins","General","Combat","Information","Interface","Profession"}

--[[ Titan
NAME: Titan bar overview
DESC:
-- 3 buttons are used to create a Titan bar: 
-- the 'display' button, 
-- the 'hider', 
-- and the 'auto hide' plugin.
-- The display is where the plugins are displayed.
-- The hider is used if auto hide is requested. This button will cause the display to show when the mouse is enters.
-- The auto hide is the plugin that shows the auto hide 'pin'.
:DESC
--]]
--[[ Titan
NAME: TitanBarOrder table
DESC:
The values must match the 'name' in the TitanBarData table!!!
The values specify the order the options should be ordered in the options pulldown.
:DESC
--]]
TitanBarOrder = {"Bar", "Bar2", "AuxBar2", "AuxBar"}
--[[ Titan
NAME: TitanBarData table. 
DESC:
The index must match the 'button' names in the TitanPanel.xml!!!
The table holds:
 the name of each Titan bar (in the index)
 the short name of the bar 
 whether the bar is on top or bottom
 the order they should be in top to bottom
 show / hide give the values for the cooresponding SetPoint
 
The short name is used to build names of the various saved variables, frames,
 and buttons used by Titan.
:DESC
-]]
TitanBarData = {
	[TITAN_PANEL_DISPLAY_PREFIX.."Bar"] = {
		locale_name = L["TITAN_PANEL_MENU_TOP"],
		name = "Bar", vert = TITAN_TOP, order = 1,
		hider = TITAN_PANEL_HIDE_PREFIX.."Bar",
		auto_hide_plugin = AUTOHIDE_PREFIX.."Bar"..AUTOHIDE_SUFFIX,
		plugin_y_offset = 1,
		show = {
		top = {pt="TOPLEFT", rel_fr="UIParent", rel_pt="TOPLEFT", x=0, y=0},
		bot = {pt="BOTTOMRIGHT", rel_fr="UIParent", rel_pt="TOPRIGHT", x=0, y=-TITAN_PANEL_BAR_HEIGHT} },
		hide = {
		top = {pt="TOPLEFT", rel_fr="UIParent", rel_pt="TOPLEFT", x=0, y=TITAN_PANEL_BAR_HEIGHT*2},
		bot = {pt="BOTTOMRIGHT", rel_fr="UIParent", rel_pt="TOPRIGHT", x=0, y=TITAN_PANEL_BAR_HEIGHT*2} } 
	},
	[TITAN_PANEL_DISPLAY_PREFIX.."Bar2"] = {
		locale_name = L["TITAN_PANEL_MENU_TOP2"],
		name = "Bar2", vert = TITAN_TOP, order = 2,
		hider = TITAN_PANEL_HIDE_PREFIX.."Bar2",
		auto_hide_plugin = AUTOHIDE_PREFIX.."Bar2"..AUTOHIDE_SUFFIX,
		plugin_y_offset = 1,
		show = {
		top = {pt="TOPLEFT", rel_fr="UIParent", rel_pt="TOPLEFT", x=0, y=-TITAN_PANEL_BAR_HEIGHT},
		bot = {pt="BOTTOMRIGHT", rel_fr="UIParent", rel_pt="TOPRIGHT", x=0, y=-TITAN_PANEL_BAR_HEIGHT*2} },
		hide = {
		top = {pt="TOPLEFT", rel_fr="UIParent", rel_pt="TOPLEFT", x=0, y=TITAN_PANEL_BAR_HEIGHT*2},
		bot = {pt="BOTTOMRIGHT", rel_fr="UIParent", rel_pt="TOPRIGHT", x=0, y=TITAN_PANEL_BAR_HEIGHT*2} } 
	},
	-- no idea why -1 is needed for the bottom... seems anchoring to bottom is off a pixel
	[TITAN_PANEL_DISPLAY_PREFIX.."AuxBar2"] = {
		locale_name = L["TITAN_PANEL_MENU_BOTTOM2"],
		name = "AuxBar2",  vert = TITAN_BOTTOM, order = 3,
		hider = TITAN_PANEL_HIDE_PREFIX.."AuxBar2",
		auto_hide_plugin = AUTOHIDE_PREFIX.."AuxBar2"..AUTOHIDE_SUFFIX,
		plugin_y_offset = 1,
		show = {
		top = {pt="TOPRIGHT", rel_fr="UIParent", rel_pt="BOTTOMRIGHT", x=0, y=TITAN_PANEL_BAR_HEIGHT*2-1},
		bot = {pt="BOTTOMLEFT", rel_fr="UIParent", rel_pt="BOTTOMLEFT", x=0, y=TITAN_PANEL_BAR_HEIGHT-1} },
		hide = {
		top = {pt="TOPRIGHT", rel_fr="UIParent", rel_pt="BOTTOMRIGHT", x=0, y=-TITAN_PANEL_BAR_HEIGHT*2},
		bot = {pt="BOTTOMLEFT", rel_fr="UIParent", rel_pt="BOTTOMLEFT", x=0, y=-TITAN_PANEL_BAR_HEIGHT*2} } 
	},
	[TITAN_PANEL_DISPLAY_PREFIX.."AuxBar"] = {
		locale_name = L["TITAN_PANEL_MENU_BOTTOM"],
		name = "AuxBar",  vert = TITAN_BOTTOM, order = 4,
		hider = TITAN_PANEL_HIDE_PREFIX.."AuxBar",
		auto_hide_plugin = AUTOHIDE_PREFIX.."AuxBar"..AUTOHIDE_SUFFIX,
		plugin_y_offset = 1,
		show = {
		top = {pt="TOPRIGHT", rel_fr="UIParent", rel_pt="BOTTOMRIGHT", x=0, y=TITAN_PANEL_BAR_HEIGHT-1},
		bot = {pt="BOTTOMLEFT", rel_fr="UIParent", rel_pt="BOTTOMLEFT", x=0, y=0-1} },
		hide = {
		top = {pt="TOPRIGHT", rel_fr="UIParent", rel_pt="BOTTOMRIGHT", x=0, y=-TITAN_PANEL_BAR_HEIGHT*2},
		bot = {pt="BOTTOMLEFT", rel_fr="UIParent", rel_pt="BOTTOMLEFT", x=0, y=-TITAN_PANEL_BAR_HEIGHT*2} } 
	},
	}

-- Timers used within Titan
TitanTimers = {}
--[[ Titan
NAME: AutoHideData table. 
DESC:
The index must match the hider 'button' names in the TitanPanel.xml!!!
The table holds:
 the name of each hider bar (in the index)
 the short name of the hider bar 
 whether the hider bar is on top or bottom
:DESC
--]]
AutoHideData = { -- This has to follow the convention for plugins...
	[AUTOHIDE_PREFIX.."Bar"..AUTOHIDE_SUFFIX] = {name = "Bar", vert = TITAN_TOP},
	[AUTOHIDE_PREFIX.."Bar2"..AUTOHIDE_SUFFIX] = {name = "Bar2", vert = TITAN_TOP},
	[AUTOHIDE_PREFIX.."AuxBar2"..AUTOHIDE_SUFFIX] = {name = "AuxBar2",  vert = TITAN_BOTTOM},
	[AUTOHIDE_PREFIX.."AuxBar"..AUTOHIDE_SUFFIX] = {name = "AuxBar",  vert = TITAN_BOTTOM},
	}

--[[ Titan
TitanPluginToBeRegistered table holds each plugin that is requesting to be a plugin.
TitanPluginToBeRegisteredNum is the number of plugins that have requested.
Each plugin in the table will be updated with the status of the registration and will be available in the Titan Attempted option.
--]]
TitanPluginToBeRegistered = {}
TitanPluginToBeRegisteredNum = 0

TitanPluginRegisteredNum = 0

--TitanPluginAttempted = {}
--TitanPluginAttemptedNum = 0

--[[ Titan
TitanPluginExtras table holds the plugin data for plugins that are in saved variables but not loaded on the current character.
TitanPluginExtrasNum is the number of plugins not loaded.
--]]
TitanPluginExtras = {}
TitanPluginExtrasNum = 0

-- Global to hold where the Titan menu orginated from...
TitanPanel_DropMenu = nil

local Default_Plugins = {
	{id = "Location", loc = "Bar"},
	{id = "XP", loc = "Bar"},
	{id = "Gold", loc = "Bar"},
	{id = "Clock", loc = "Bar"},
	{id = "Volume", loc = "Bar"},
	{id = "AutoHide_Bar", loc = "Bar"},
	{id = "Bag", loc = "Bar"},
	{id = "Repair", loc = "Bar"},
}
--[[ Titan
TITAN_PANEL_SAVED_VARIABLES table holds the Titan Panel Default SavedVars.
--]]
TITAN_PANEL_SAVED_VARIABLES = {
	Buttons = {},
	Location = {},
	TexturePath = "Interface\\AddOns\\Titan\\Artwork\\",
	Transparency = 0.7,
	AuxTransparency = 0.7,
	Scale = 1,
	ButtonSpacing = 20,
	IconSpacing = 0,
	TooltipTrans = 1,
	TooltipFont = 1,
	DisableTooltipFont = 1,
	FontName = TPC.FONT_NAME,
	FrameStrata = "DIALOG",
	FontSize = TPC.FONT_SIZE,
	ScreenAdjust = false,
	LogAdjust = false,
	MinimapAdjust = false,
	BagAdjust = 1,
	TicketAdjust = 1,
	Position = 1,
	ButtonAlign = 1,
	AuxScreenAdjust = false,
	LockButtons = false,
	LockAutoHideInCombat = false,
	VersionShown = 1,
	ToolTipsShown = 1,
	HideTipsInCombat = false,
	-- for the independent bars
	Bar_Show = true,
	Bar_Hide = false,
	Bar_Align = TITAN_PANEL_BUTTONS_ALIGN_LEFT,
	Bar_Transparency = 0.7,
	Bar2_Show = false,
	Bar2_Hide = false,
	Bar2_Transparency = 0.7,
	Bar2_Align = TITAN_PANEL_BUTTONS_ALIGN_LEFT,
	AuxBar_Show = false,
	AuxBar_Hide = false,
	AuxBar_Transparency = 0.7,
	AuxBar_Align = TITAN_PANEL_BUTTONS_ALIGN_LEFT,
	AuxBar2_Show = false,
	AuxBar2_Hide = false,
	AuxBar2_Transparency = 0.7,
	AuxBar2_Align = TITAN_PANEL_BUTTONS_ALIGN_LEFT,
};

--[[ Titan
TITAN_ALL_SAVED_VARIABLES table holds the Titan Panel Global SavedVars.
--]]
TITAN_ALL_SAVED_VARIABLES = {
	-- for timers in seconds
	TimerPEW = 4,
	TimerDualSpec = 2,
	TimerLDB = 2,
	TimerAdjust = 1,
	TimerVehicle = 1,
	-- Global profile
	GlobalProfileUse = false,
	GlobalProfileName = TITAN_PROFILE_NONE,
	-- Silent Load
	Silenced = false,
};

-- The skins released with Titan
TitanSkinsDefaultPath = "Interface\\AddOns\\Titan\\Artwork\\"
TitanSkinsCustomPath = TitanSkinsDefaultPath.."Custom\\"
TitanSkinsPathEnd = "\\"
TitanSkinsDefault = {
	{ name = "Titan Default", titan=true, path = TitanSkinsDefaultPath},
	{ name = "BlackPlusOne", titan=true, path = TitanSkinsCustomPath.."BlackPlusOne Skin"..TitanSkinsPathEnd},
	{ name = "Christmas", titan=true, path = TitanSkinsCustomPath.."Christmas Skin"..TitanSkinsPathEnd},
	{ name = "Charcoal Metal", titan=true, path = TitanSkinsCustomPath.."Charcoal Metal"..TitanSkinsPathEnd},
	{ name = "Crusader", titan=true, path = TitanSkinsCustomPath.."Crusader Skin"..TitanSkinsPathEnd},
	{ name = "Cursed Orange", titan=true, path = TitanSkinsCustomPath.."Cursed Orange Skin"..TitanSkinsPathEnd},
	{ name = "Dark Wood", titan=true, path = TitanSkinsCustomPath.."Dark Wood Skin"..TitanSkinsPathEnd},
	{ name = "Deep Cave", titan=true, path = TitanSkinsCustomPath.."Deep Cave Skin"..TitanSkinsPathEnd},
	{ name = "Elfwood", titan=true, path = TitanSkinsCustomPath.."Elfwood Skin"..TitanSkinsPathEnd},
	{ name = "Engineer", titan=true, path = TitanSkinsCustomPath.."Engineer Skin"..TitanSkinsPathEnd},
	{ name = "Frozen Metal", titan=true, path = TitanSkinsCustomPath.."Frozen Metal Skin"..TitanSkinsPathEnd},
	{ name = "Graphic", titan=true, path = TitanSkinsCustomPath.."Graphic Skin"..TitanSkinsPathEnd},
	{ name = "Graveyard", titan=true, path = TitanSkinsCustomPath.."Graveyard Skin"..TitanSkinsPathEnd},
	{ name = "Hidden Leaf", titan=true, path = TitanSkinsCustomPath.."Hidden Leaf Skin"..TitanSkinsPathEnd},
	{ name = "Holy Warrior", titan=true, path = TitanSkinsCustomPath.."Holy Warrior Skin"..TitanSkinsPathEnd},
	{ name = "Nightlife", titan=true, path = TitanSkinsCustomPath.."Nightlife Skin"..TitanSkinsPathEnd},
	{ name = "Orgrimmar", titan=true, path = TitanSkinsCustomPath.."Orgrimmar Skin"..TitanSkinsPathEnd},
	{ name = "Plate", titan=true, path = TitanSkinsCustomPath.."Plate Skin"..TitanSkinsPathEnd},
	{ name = "Tribal", titan=true, path = TitanSkinsCustomPath.."Tribal Skin"..TitanSkinsPathEnd},
	{ name = "X-Perl", titan=true, path = TitanSkinsCustomPath.."X-Perl"..TitanSkinsPathEnd},
};
TitanSkins = {}

-- trim version if it exists
local fullversion = GetAddOnMetadata(TITAN_ID, "Version")
if fullversion then
	local pos = string.find(fullversion, " -", 1, true);
	if pos then
		TITAN_VERSION = string.sub(fullversion,1,pos-1);
	end
end

--[[ local
NAME: TitanRegisterExtra
DESC: Add the saved variable data of an unloaded plugin to the 'extra' list in case the user wants to delete the data via Tian Extras option.
VAR: id - the name of the plugin (string)
OUT:  None
--]]
local function TitanRegisterExtra(id) 
	TitanPluginExtrasNum = TitanPluginExtrasNum + 1
	TitanPluginExtras[TitanPluginExtrasNum] = 
		{num=TitanPluginExtrasNum, 
		id     = (id or "?"), 
		}
end

-- routines to sync toon data
local function CleanupProfile ()
	if TitanPanelSettings and TitanPanelSettings["Buttons"] then
		-- Hide the current set of plugins to prevent overlap (creates a very messy bar!)
		for index, id in pairs(TitanPanelSettings["Buttons"]) do
			local currentButton = 
				TitanUtils_GetButton(TitanPanelSettings["Buttons"][index]);
			-- safeguard
			if currentButton then
			currentButton:Hide();
			end	
		end
	end
	TitanPanelRightClickMenu_Close();
end

--[[ local
NAME: TitanVariables_SyncRegisterSavedVariables
DESC: Helper routine to sync two sets of toon data - Titan settings and loaded plugins.
VAR: registeredVariables - current loaded data (destination)
VAR: savedVariables - data to compare with (source)
OUT:  None
--]]
local function TitanVariables_SyncRegisterSavedVariables(registeredVariables, savedVariables)
	if (registeredVariables and savedVariables) then
		-- Init registeredVariables
		for index, value in pairs(registeredVariables) do
			if (not TitanUtils_TableContainsIndex(savedVariables, index)) then
				savedVariables[index] = value;
			end
		end
					
		-- Remove out-of-date savedVariables
		for index, value in pairs(savedVariables) do
			if (not TitanUtils_TableContainsIndex(registeredVariables, index)) then
				savedVariables[index] = nil;
			end
		end
	end
end

--[[ local
NAME: Plugin_settings
DESC: Give the curent profile the default plugins - if they are registered. 
VAR: reset - boolean
OUT: None
NOTE:
- It is assumed this is a plugin wipe of the given profile.
- Use the default Titan plugin list to display on the given bar.
- These will be saved on exit or reload in the given profile.
:NOTE
--]]
local function Plugin_settings(reset)
	local plugin_list = {}
	if reset then -- use the default install list
		plugin_list = Default_Plugins
	else -- use the current profile
		plugin_list = TitanPanelSettings.Buttons
	end
	
	-- Init each and every default plugin
	for idx, default_plugin in pairs(plugin_list) do
		local id = default_plugin.id
		local loc = default_plugin.loc
		local plugin = TitanUtils_GetPlugin(id)
--TitanDebug("Plugin: "..(id or "?").." "..(plugin and "T" or "F"))
		-- See if plugin is registered
		if (plugin) then
--TitanDebug("__Plugin: "..(id or "?").." "..(loc or "?"))
			-- Synchronize registered and saved variables
			TitanVariables_SyncRegisterSavedVariables(
				plugin.savedVariables, TitanPluginSettings[id])
			TitanUtils_AddButtonOnBar(loc, id)
			TitanPanelButton_UpdateButton(id)
		end
	end
end

--[[ local
NAME: TitanVariables_PluginSettingsInit
DESC: Give the curent profile the default plugins - if they are registered. 
VAR: None
OUT: None
NOTE:
- The saved variables of the given profile will be used.
- These will be saved on exit or reload in the given profile.
- The saved display list will be used but only the registered plugins will be displayed.
- The plugins that are not registered will NOT be removed from the saved list. This allows different a single saved display list to be used for toons that have different plugins enabled.
:NOTE
--]]
local function TitanVariables_PluginSettingsInit() 
	-- Loop through the user's displayed plugins and see what is
	-- actually registered
	for idx, display_plugin in pairs(TitanPanelSettings.Buttons) do
		local id = display_plugin
		local plugin = TitanUtils_GetPlugin(id)
		-- See if plugin is registered
		if (plugin) then
			-- Synchronize registered and saved variables
			TitanVariables_SyncRegisterSavedVariables(
				plugin.savedVariables, TitanPluginSettings[id])
			-- Button will be updated later
		else
			-- Do not display this plugin.
			-- Do NOT remove the button from the displayed list.
			-- This is an old 'feature' that people like...
		end
	end
end

--[[ local
NAME: TitanVariables_SyncSkins
DESC: Routine to sync two sets of skins data - Titan defaults and Titan saved vars.
VAR:  None
OUT:  None
NOTE:
- It is assumed that the list in Titan defaults or as input from the user are in the Titan skins folder. Blizz does not allow LUA to read the hard drive directly.
:NOTE
--]]
local function TitanVariables_SyncSkins()
	if (TitanSkinsDefault and TitanSkins) then
		local skins = {}
		-- insert all the Titan defaults
		for idx, v in pairs(TitanSkinsDefault) do
			table.insert (skins, TitanSkinsDefault[idx]) 
--			table.sort(skins, function(a, b)
--				return string.lower(skins[a] and skins[a].name or "") 
--					< string.lower(skins[b] and skins[b].name or "")
--			end)
		end

		-- search through the saved vars and compare against the defaults
		local found = nil
		for index, value in pairs(TitanSkins) do
			found = nil
			-- See if the skin is a default one
			for idx, v in pairs(TitanSkinsDefault) do
				if TitanSkinsDefault[idx].name == TitanSkins[index].name then
					found = idx
				end
			end
			if found then
				-- already inserted
			else -- could be user placed or old Titan
				if TitanSkins[index].titan then
					-- old Titan skin - let it drop
				else
					-- assume it is a user installed skin
					table.insert (skins, TitanSkins[index])
--					table.sort(skins, function(a, b)
--						return string.lower(skins[a] and skins[a].name or "") 
--							< string.lower(skins[b] and skins[b].name or "")
--					end)
				end
			end
		end
		return skins
	end
end

--[[ local
NAME: Sync_panel_settings
DESC: Routine to sync TitanPanelSettings - defaults to saved vars.
VAR: Setting - table to use as the default
OUT: None
--]]
local function Sync_panel_settings(settings) 
	-- Synchronize registered and saved variables
--TitanDebug("Sync_1: "..(settings.FontName or "?"))
	TitanVariables_SyncRegisterSavedVariables(settings, TitanPanelSettings)
--TitanDebug("Sync_2: "..(TitanPanelSettings.FontName or "?"))
end

--[[ local
NAME: Set_Timers
DESC: Routine to reset / sync Titan settings.
VAR:  None
OUT:  None
--]]
local function Set_Timers(reset) 
	-- Titan is loaded so set the timers we want to use
	TitanTimers = {
		["EnterWorld"] = {obj = "PEW", callback = TitanAdjustBottomFrames, delay = 4,},
		["DualSpec"] = {obj = "SpecSwitch", callback = Titan_ManageFramesNew, delay = 2,},
		["LDBRefresh"] = {obj = "LDB", callback = TitanLDBRefreshButton, delay = 2,},
		["Adjust"] = {obj = "MoveAdj", callback = Titan_ManageFramesNew, delay = 1,},
		["Vehicle"] = {obj = "Vehicle", callback = Titan_ManageFramesNew, delay = 1,},
	}
	
	if reset then
		TitanAllSetVar("TimerPEW", TitanTimers["EnterWorld"].delay)
		TitanAllSetVar("TimerDualSpec", TitanTimers["DualSpec"].delay)
		TitanAllSetVar("TimerLDB", TitanTimers["LDBRefresh"].delay)
		TitanAllSetVar("TimerAdjust", TitanTimers["Adjust"].delay)
		TitanAllSetVar("TimerVehicle", TitanTimers["Vehicle"].delay)
	else
		TitanTimers["EnterWorld"].delay = TitanAllGetVar("TimerPEW")
		TitanTimers["DualSpec"].delay = TitanAllGetVar("TimerDualSpec")
		TitanTimers["LDBRefresh"].delay = TitanAllGetVar("TimerLDB")
		TitanTimers["Adjust"].delay = TitanAllGetVar("TimerAdjust")
		TitanTimers["Vehicle"].delay = TitanAllGetVar("TimerVehicle")
	end
end

--[[ Titan
NAME: TitanVariables_SyncPluginSettings
DESC: Routine to sync plugin datas - current loaded (lua file) to any plugin saved vars (last save to disk).
VAR:  None
OUT:  None
--]]
function TitanVariables_SyncPluginSettings() -- one plugin uses this
	-- Init each and every plugin
	for id, plugin in pairs(TitanPlugins) do
		if (plugin and plugin.savedVariables) then
			-- Init savedVariables table
			if (not TitanPluginSettings[id]) then
				TitanPluginSettings[id] = {};
			end					
			
			-- Synchronize registered and saved variables
			TitanVariables_SyncRegisterSavedVariables(
				plugin.savedVariables, TitanPluginSettings[id]);			
		else
			-- Remove plugin savedVariables table if there's one
			if (TitanPluginSettings[id]) then
				TitanPluginSettings[id] = nil;
			end								
		end
	end
end

--[[ Titan
NAME: TitanVariables_ExtraPluginSettings
DESC: Routine to mark plugin data that is not loaded (no lua file) but has plugin saved vars (last save to disk).
VAR:  None
OUT:  None
NOTE: This data is made available in case the user wants to delete the data via Tian Extras option.
:NOTE
--]]
function TitanVariables_ExtraPluginSettings()
	TitanPluginExtrasNum = 0
	TitanPluginExtras = {}
	-- Get the saved plugins that are not loaded
	for id, plugin in pairs(TitanPluginSettings) do
		if (id and TitanUtils_IsPluginRegistered(id)) then
		else
			TitanRegisterExtra(id)
		end
	end
end

--[[ Titan
NAME: TitanVariables_InitTitanSettings
DESC: Ensure TitanSettings (one of the saved vars in the toc) exists and set the Titan version.
VAR:  None
OUT:  None
NOTE:
- Called when Titan is loaded (ADDON_LOADED event)
:NOTE
--]]
function TitanVariables_InitTitanSettings()
	if (TitanSettings) then
		-- all is good
	else
		TitanSettings = {}
	end
	-- check for player list per issue #745
	if TitanSettings.Players then
		-- all is good
	else
		-- Create the table so profile(s) can be added
		TitanSettings.Players = {}
	end
--[[
TitanDumpPlayerList()
--]]
	Sync_panel_settings(TITAN_PANEL_SAVED_VARIABLES)
	
	if (TitanAll) then
	else
		TitanAll = {};
	end
	TitanVariables_SyncRegisterSavedVariables(TITAN_ALL_SAVED_VARIABLES, TitanAll)
	
	TitanSettings.Version = TITAN_VERSION;
end

--[[ local
NAME: Init_player_settings
DESC: Use the Titan settings, the plugin settings, the 'extras' data of the given profile. Create the "to" profile if it does not exist.
VAR:  from_profile - nil or profile to switch from (string)
VAR:  to_profile - the toon to use (string)
OUT:  None
NOTE:
- Called at PLAYER_ENTERING_WORLD event after we know Titan has registered plugins.
- There are 3 actions: USE, RESET, and INIT
- USE:
 From: the user chosen profile
 To: Player or Global profile
- RESET:
 From: Titan defaults
 To: Player or Global profile
- INIT:
 From: saved variables of that profile
 To: Player or Global profile
:NOTE
--]]
local function Init_player_settings(from_profile, to_profile, action)
	local old_player = {}
	local old_panel = {}
	local old_plugins = {}
	local reset = (action == TITAN_PROFILE_RESET)
--[[
TitanDebug("_UseSettings "
.."from: "..(from_profile or "?").." "
.."to_profile: "..(to_profile or "?").." "
.."action: "..action.." "
)
--]]

	CleanupProfile () -- hide currently shown plugins
	-- Ensure the requested profile is at least an empty stub
	if (not TitanSettings.Players[to_profile]) or reset then
		TitanSettings.Players[to_profile] = {}
		TitanSettings.Players[to_profile].Plugins = {}
		TitanSettings.Players[to_profile].Panel = {}
		TitanSettings.Players[to_profile].Panel.Buttons = {}
		TitanSettings.Players[to_profile].Panel.Location = {}
		TitanPlayerSettings = {}
		TitanPlayerSettings["Plugins"] = {}
		TitanPlayerSettings["Panel"] = {}
		TitanPlayerSettings["Register"] = {}
	end	
	-- Set global variables
	TitanPlayerSettings = TitanSettings.Players[to_profile];
	TitanPluginSettings = TitanPlayerSettings["Plugins"];
	TitanPanelSettings = TitanPlayerSettings["Panel"];
	Sync_panel_settings(TITAN_PANEL_SAVED_VARIABLES);
	
	if action == TITAN_PROFILE_RESET then
		-- default is global profile OFF
		TitanAll = {}
		TitanVariables_SyncRegisterSavedVariables(TITAN_ALL_SAVED_VARIABLES, TitanAll)
	elseif action == TITAN_PROFILE_INIT then
		--	
	elseif action == TITAN_PROFILE_USE then
		-- The requested profile at least exists so we can copy to it
		-- Copy from the from_profile to profile - not anything in saved vars
		if from_profile and TitanSettings.Players[from_profile] then
			old_player = TitanSettings.Players[from_profile]
		else
		end
		if old_player and old_player["Panel"] then
			old_panel = old_player["Panel"]
		end
		if old_player and old_player["Plugins"] then
			old_plugins = old_player["Plugins"]
		end
		-- Copy the panel settings
		for index, id in pairs(old_panel) do
			TitanPanelSetVar(index, old_panel[index]);		
		end
		-- Copy the plugin settings
		for plugin, i in pairs(old_plugins) do
			for var, id in pairs(old_plugins[plugin]) do		
				TitanSetVar(plugin, var, old_plugins[plugin][var])
			end
		end
	end

	if (TitanPlayerSettings) then
		-- Synchronize plugin settings with plugins that were registered
		TitanVariables_SyncPluginSettings()
		-- Display the plugins the user selected AND are registered
		if reset then
			Plugin_settings(reset)
		else
			TitanVariables_PluginSettingsInit()
		end
		TitanVariables_ExtraPluginSettings()
	end
	
	TitanSkins = TitanVariables_SyncSkins()

	Set_Timers(reset)
	-- for debug if a user needs to send in the Titan saved vars
	TitanPlayerSettings["Register"] = {}
	TitanPanelRegister = TitanPlayerSettings["Register"]
	
	TitanSettings.Profile = to_profile
end

--[[ API
NAME: TitanGetVar
DESC: Get the value of the requested plugin variable.
VAR: id - the plugin name (string)
VAR: var - the name (string) of the variable
OUT:  None
NOTE:
- 'var' is from the plugin <button>.registry.savedVariables table as created in the plugin lua.
:NOTE
--]]
function TitanGetVar(id, var)
	if (id and var and TitanPluginSettings and TitanPluginSettings[id]) then		
		-- compatibility check
		if TitanPluginSettings[id][var] == "Titan Nil" then 
			TitanPluginSettings[id][var] = false 
		end
		return TitanUtils_Ternary(TitanPluginSettings[id][var] == false, nil, TitanPluginSettings[id][var]);
	end
end

--[[ API
NAME: TitanVarExists
DESC: Determine if requested plugin variable exists.
VAR: id - the plugin name (string)
VAR: var - the name (string) of the variable
OUT:  None
NOTE:
- 'var' is from the plugin <button>.registry.savedVariables table as created in the plugin lua.
- This checks existence NOT false!
:NOTE
--]]
function TitanVarExists(id, var)
	-- We need to check for existance not true!
	-- If the value is nil then it will not exist...
	if (id and var and TitanPluginSettings and TitanPluginSettings[id] 
	and (TitanPluginSettings[id][var] 
		or TitanPluginSettings[id][var] == false) ) 
	then
		return true
	else
		return false
	end
end

--[[ API
NAME: TitanSetVar
DESC: Get the value of the requested plugin variable to the given value.
VAR: id - the plugin name (string)
VAR: var - the name (string) of the variable
VAR: value - new value of var
OUT:  None
NOTE:
- 'var' is from the plugin <button>.registry.savedVariables table as created in the plugin lua.
:NOTE
--]]
function TitanSetVar(id, var, value)
	if (id and var and TitanPluginSettings and TitanPluginSettings[id]) then		
		TitanPluginSettings[id][var] = TitanUtils_Ternary(value, value, false);		
	end
end

--[[ API
NAME: TitanToggleVar
DESC: Toggle the value of the requested plugin variable. This assumes var value represents a boolean
VAR: id - the plugin name (string)
VAR: var - the name (string) of the variable
OUT:  None
NOTE:
- Boolean in this case could be true / false or non zero / zero or nil.
:NOTE
--]]
function TitanToggleVar(id, var)
	if (id and var and TitanPluginSettings and TitanPluginSettings[id]) then
		TitanSetVar(id, var, TitanUtils_Toggle(TitanGetVar(id, var)));
	end
end

--[[ API
NAME: TitanPanelGetVar
DESC: Get the value of the requested Titan variable.
VAR: var - the name (string) of the variable
OUT: value of the requested Titan variable
NOTE:
- 'var' is from the TitanPanelSettings[var].
:NOTE
--]]
function TitanPanelGetVar(var)
	if (var and TitanPanelSettings) then
		if TitanPanelSettings[var] == "Titan Nil" then 
			TitanPanelSettings[var] = false 
		end		
		return TitanUtils_Ternary(TitanPanelSettings[var] == false, nil, TitanPanelSettings[var]);
	end
end

--[[ API
NAME: TitanPanelSetVar
DESC: Set the value of the requested Titan variable.
VAR: var - the name (string) of the variable
VAR: value - new value of var
OUT:  None
NOTE:
- 'var' is from the TitanPanelSettings[var].
:NOTE
--]]
function TitanPanelSetVar(var, value)
	if (var and TitanPanelSettings) then		
		TitanPanelSettings[var] = TitanUtils_Ternary(value, value, false);
	end
end

--[[ API
NAME: TitanPanelToggleVar
DESC: Toggle the value of the requested Titan variable. This assumes var value represents a boolean
VAR:  var - the name (string) of the variable
OUT:  None
NOTE:
- Boolean in this case could be true / false or non zero / zero or nil.
:NOTE
--]]
function TitanPanelToggleVar(var)
	if (var and TitanPanelSettings) then
		TitanPanelSetVar(var, TitanUtils_Toggle(TitanPanelGetVar(var)));
	end
end

--[[ API
NAME: TitanAllGetVar
DESC: Get the value of the requested Titan global variable.
VAR: var - the name (string) of the variable
OUT: None
NOTE:
- 'var' is from the TitanAll[var].
:NOTE
--]]
function TitanAllGetVar(var)
	if (var and TitanAll) then
		if TitanAll[var] == "Titan Nil" then 
			TitanAll[var] = false 
		end
		return TitanUtils_Ternary(TitanAll[var] == false, nil, TitanAll[var]);
	end
end

--[[ API
NAME: TitanAllSetVar
DESC: Set the value of the requested Titan global variable.
VAR: var - the name (string) of the variable
VAR: value - new value of var
OUT:  None
NOTE:
- 'var' is from the TitanPanelSettings[var].
:NOTE
--]]
function TitanAllSetVar(var, value)
	if (var and TitanAll) then
		TitanAll[var] = TitanUtils_Ternary(value, value, false);
	end
end

--[[ API
NAME: TitanAllToggleVar
DESC: Toggle the value of the requested Titan global variable. This assumes var value represents a boolean
VAR: var - the name (string) of the variable
OUT: None
NOTE:
- Boolean in this case could be true / false or non zero / zero or nil.
:NOTE
--]]
function TitanAllToggleVar(var)
	if (var and TitanAll) then
		TitanAllSetVar(var, TitanUtils_Toggle(TitanAllGetVar(var)));
	end
end

--[[ API
NAME: TitanVariables_GetPanelStrata
DESC: Return the strata and the next highest strata of the given value
VAR: value - the name (string) of the strata to look up
OUT: string - Next highest strata
OUT: string - passed in strata
--]]
function TitanVariables_GetPanelStrata(value)
	-- obligatory check
	if not value then value = "DIALOG" end

	local index;
	local indexpos = 5 -- DIALOG
	local StrataTypes = {"BACKGROUND", "LOW", "MEDIUM", "HIGH", 
		"DIALOG", "FULLSCREEN", "FULLSCREEN_DIALOG"}

	for index in ipairs(StrataTypes) do
		if value == StrataTypes[index] then
			indexpos = index
			break
		end
	end
	
	return StrataTypes[indexpos + 1], StrataTypes[indexpos]
end

--[[ API
NAME: TitanVariables_SetPanelStrata
DESC: Set the Titan bars to the given strata and the plugins to the next highest strata.
VAR: value - strata name (string)
OUT: None
--]]
function TitanVariables_SetPanelStrata(value)
	local plugins, bars = TitanVariables_GetPanelStrata(value)
	local idx, v
	-- Set all the Titan bars
	for idx,v in pairs (TitanBarData) do
		local bar_name = TITAN_PANEL_DISPLAY_PREFIX..TitanBarData[idx].name
		_G[bar_name]:SetFrameStrata(bars)
	end
	-- Set all the registered plugins
	for idx, v in pairs(TitanPluginsIndex) do
		local button = TitanUtils_GetButton(v);
		button:SetFrameStrata(plugins)
	end
end

--[[ Titan
NAME: TitanVariables_UseSettings
DESC: Set the Titan variables and plugin variables to the passed in profile.
VAR: profile - profile to use for this toon : <name>@<server>
OUT: None
NOTE:
- Called from the Titan right click menu
- profile is compared as 'lower' so the case of profile does not matter 
:NOTE
--]]
function TitanVariables_UseSettings(profile, action)
--[[
TitanDebug("_UseSettings "
.."profile: "..(profile or "?").." "
.."action: "..action.." "
)
--]]
	-- sanity checks to ensure the base tables are set
	if (TitanSettings) then
		-- all is good
	else
		TitanSettings = {}
	end
	-- check for player list per issue #745
	if TitanSettings.Players then
		-- all is good
	else
		-- Create the table so profile(s) can be added
		TitanSettings.Players = {}
	end
	if (TitanAll) then
		-- all is good
	else
		TitanAll = {};
	end
	TitanVariables_SyncRegisterSavedVariables(TITAN_ALL_SAVED_VARIABLES, TitanAll)
	
	TitanSettings.Version = TITAN_VERSION;
	
	local from_profile = nil
	if action == TITAN_PROFILE_USE then
		-- Grab the old profile currently in use
		from_profile = profile or nil
	end
	
	local _ = nil
	local glob, name, player, server = TitanUtils_GetGlobalProfile()
	-- Get the profile according to the user settings
	if glob then
		profile = name -- Use global toon
	else
		profile, _, _ = TitanUtils_GetPlayer() -- Use current toon
	end

	-- Find the profile in a case insensitive manner
	local new_profile = ""
	profile = string.lower(profile)
	for index, id in pairs(TitanSettings.Players) do
		if profile == string.lower(index) then
			new_profile = index
		end
	end
	if new_profile == "" then
		-- Assume we need the current player
		new_profile = TitanUtils_GetPlayer() --TitanSettings.Player
		-- And it needs to be created
		action = TITAN_PROFILE_RESET
	end
	
	-- Now that we know what profile to use - act on the data
	Init_player_settings(from_profile, new_profile, action)
	
	-- set strata in case it has changed
	TitanVariables_SetPanelStrata(TitanPanelGetVar("FrameStrata"))

	-- show the new profile
	TitanPanel_InitPanelBarButton();
	TitanPanel_InitPanelButtons();
end

-- decrecated routines
--[[

function TitanGetVarTable(id, var, position)
	if (id and var and TitanPluginSettings and TitanPluginSettings[id]) then		
		-- compatibility check
		if TitanPluginSettings[id][var][position] == "Titan Nil" then TitanPluginSettings[id][var][position] = false end
		return TitanUtils_Ternary(TitanPluginSettings[id][var][position] == false, nil, TitanPluginSettings[id][var][position]);
	end
end

function TitanSetVarTable(id, var, position, value)
	if (id and var and TitanPluginSettings and TitanPluginSettings[id]) then		
		TitanPluginSettings[id][var][position] = TitanUtils_Ternary(value, value, false);
	end
end

--]]