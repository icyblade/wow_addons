--[[
-- **************************************************************************
-- * Updates for the new TitanPanel: Titan Development Team
-- * 2010 Jul : Started from Titan Gold Tracker to create this Titan version
-- **************************************************************************
--]]

-- ******************************** Constants *******************************
local TITAN_GOLD_ID = "Gold";
local TITAN_GOLD_COUNT_FORMAT = "%d";
local TITAN_GOLD_VERSION = TITAN_VERSION;
local TITAN_GOLD_SPACERBAR = "--------------------";
local TITAN_GOLD_BLUE = {r=0.4,b=1,g=0.4};
local TITAN_GOLD_RED = {r=1,b=0,g=0};
local TITAN_GOLD_GREEN = {r=0,b=0,g=1};
local updateTable = {TITAN_GOLD_ID, TITAN_PANEL_UPDATE_TOOLTIP };
-- ******************************** Variables *******************************
local GOLD_INITIALIZED = false;
local GOLD_INDEX = "";
local GOLD_COLOR;
local GOLD_SESS_STATUS;
local GOLD_PERHOUR_STATUS;
local GOLD_STARTINGGOLD;
local GOLD_SESSIONSTART;
local L = LibStub("AceLocale-3.0"):GetLocale("Titan", true)
local TitanGold = LibStub("AceAddon-3.0"):NewAddon("TitanGold", "AceTimer-3.0")
local GoldTimer = nil;
local _G = getfenv(0);
local realmName = GetRealmName();
-- ******************************** Functions *******************************

--[[
Add commas or period in the value given as needed
--]]
local function comma_value(amount)
	local formatted = amount
	local k
	local sep = (TitanGetVar(TITAN_GOLD_ID, "UseSeperatorComma") and "UseComma" or "UsePeriod")
	while true do
		if sep == "UseComma" then formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2') end
		if sep == "UsePeriod" then formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2') end
		if (k==0) then
			break
		end
	end
	return formatted
end

--[[
Take the 'amount' of gold and make it into a nice, colorful string of g s c (gold silver copper)
--]]
local function NiceCash(value, show_zero, show_neg)
	local neg1 = ""
	local neg2 = ""
	local agold = 10000;
	local asilver = 100;
	local outstr = "";
	local gold = 0;
	local gold_str = ""
	local gc = "|cFFFFFF00"
	local silver = 0;
	local silver_str = ""
	local sc = "|cFFCCCCCC"
	local copper = 0;
	local copper_str = ""
	local cc = "|cFFFF6600"
	local amount = (value or 0)
	local cash = (amount or 0)
	local font_size = TitanPanelGetVar("FontSize")
	local icon_pre = "|TInterface\\MoneyFrame\\"
	local icon_post = ":"..font_size..":"..font_size..":2:0|t"
	local g_icon = icon_pre.."UI-GoldIcon"..icon_post
	local s_icon = icon_pre.."UI-SilverIcon"..icon_post
	local c_icon = icon_pre.."UI-CopperIcon"..icon_post
	-- build the coin label strings based on the user selections
	local show_labels = TitanGetVar(TITAN_GOLD_ID, "ShowCoinLabels")
	local show_icons = TitanGetVar(TITAN_GOLD_ID, "ShowCoinIcons")
	local c_lab = (show_labels and L["TITAN_GOLD_COPPER"]) or (show_icons and c_icon) or ""
	local s_lab = (show_labels and L["TITAN_GOLD_SILVER"]) or (show_icons and s_icon) or ""
	local g_lab = (show_labels and L["TITAN_GOLD_GOLD"]) or (show_icons and g_icon) or ""

	-- show the money in highlight or coin color based on user selection
	if TitanGetVar(TITAN_GOLD_ID, "ShowColoredText") then
		gc = "|cFFFFFF00"
		sc = "|cFFCCCCCC"
		cc = "|cFFFF6600"
	else
		gc = _G["HIGHLIGHT_FONT_COLOR_CODE"]
		sc = _G["HIGHLIGHT_FONT_COLOR_CODE"]
		cc = _G["HIGHLIGHT_FONT_COLOR_CODE"]
	end

	if show_neg then
		if amount < 0 then
			neg1 = "|cFFFF6600" .."("..FONT_COLOR_CODE_CLOSE
			neg2 = "|cFFFF6600" ..")"..FONT_COLOR_CODE_CLOSE
		else
			neg2 = " " -- need to pad for other negative numbers
		end
	end
	if amount < 0 then
		amount = amount * -1
	end
	
	if amount == 0 then
		if show_zero then
			copper_str = cc..(amount or "?")..c_lab..""..FONT_COLOR_CODE_CLOSE
		end
	elseif amount > 0 then
		-- figure out the gold - silver - copper components
		gold = (math.floor(amount / agold) or 0)
		amount = amount - (gold * agold);
		silver = (math.floor(amount / asilver) or 0)
		copper = amount - (silver * asilver)
		-- now make the coin strings
		if gold > 0 then
			gold_str = gc..(comma_value(gold) or "?")..g_lab.." "..FONT_COLOR_CODE_CLOSE
			silver_str = sc..(string.format("%02d", silver) or "?")..s_lab.." "..FONT_COLOR_CODE_CLOSE
			copper_str = cc..(string.format("%02d", copper) or "?")..c_lab..""..FONT_COLOR_CODE_CLOSE
		elseif (silver > 0) then
			silver_str = sc..(silver or "?")..s_lab.." "..FONT_COLOR_CODE_CLOSE
			copper_str = cc..(string.format("%02d", copper) or "?")..c_lab..""..FONT_COLOR_CODE_CLOSE
		elseif (copper > 0) then
			copper_str = cc..(copper or "?")..c_lab..""..FONT_COLOR_CODE_CLOSE
		end
	end
	
	if TitanGetVar(TITAN_GOLD_ID, "ShowGoldOnly") then
		silver_str = ""
		copper_str = ""
		-- special case for those who want to show only gold
		if gold == 0 then
			if show_zero then
				gold_str = gc.."0"..g_lab.." "..FONT_COLOR_CODE_CLOSE
			end
		end
	end

	-- build the return string
	outstr = outstr
		..neg1
		..gold_str
		..silver_str
		..copper_str
		..neg2
--[[
SC.Print("Acc cash:"
..(gold or "?").."g "
..(silver or "?").."s "
..(copper or "?").."c "
..(outstr or "?")
);
--]]
	return outstr, cash, gold, silver, copper
end

-- **************************************************************************
-- NAME : TitanPanelGoldButton_OnLoad()
-- DESC : Registers the add on upon it loading
-- **************************************************************************
function TitanPanelGoldButton_OnLoad(self)
	self.registry = {
		id = TITAN_GOLD_ID,
		category = "Built-ins",
		version = TITAN_GOLD_VERSION,
		menuText = L["TITAN_GOLD_MENU_TEXT"],
		tooltipTitle = L["TITAN_GOLD_TOOLTIP"],
		tooltipTextFunction = "TitanPanelGoldButton_GetTooltipText",
		buttonTextFunction = "TitanPanelGoldButton_FindGold",
		icon = "Interface\\AddOns\\TitanGold\\Artwork\\TitanGold",
		iconWidth = 16,
		controlVariables = {
			ShowIcon = true,
			ShowLabelText =true,
			ShowRegularText = false,
			ShowColoredText = false,
			DisplayOnRightSide = false
		},
		savedVariables = {
			Initialized = true,
			DisplayGoldPerHour = true,
			ShowCoinNone = false,
			ShowCoinLabels = true,
			ShowCoinIcons = false,
			ShowGoldOnly = false,
			SortByName = true,
			ViewAll = true,
			ShowIcon = true,
			ShowLabelText = false,
			ShowColoredText = true, 
			UseSeperatorComma = true, 
			UseSeperatorPeriod = false, 
			gold = { total = "112233", neg = false },
		}
	};

	self:RegisterEvent("PLAYER_MONEY");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");

	if (not GoldSave) then
		GoldSave={};
	end
	GOLD_INDEX = UnitName("player").."_"..realmName.."::"..UnitFactionGroup("Player");
end

-- **************************************************************************
-- NAME : TitanPanelGoldButton_OnShow()
-- DESC : Create repeating timer when plugin is visible
-- **************************************************************************
function TitanPanelGoldButton_OnShow()
	if not GoldTimer and GoldSave and TitanGetVar(TITAN_GOLD_ID, "DisplayGoldPerHour") then
		GoldTimer = TitanGold:ScheduleRepeatingTimer(TitanPanelPluginHandle_OnUpdate, 1, updateTable)
	end
end

-- **************************************************************************
-- NAME : TitanPanelGoldButton_OnHide()
-- DESC : Destroy repeating timer when plugin is hidden
-- **************************************************************************
function TitanPanelGoldButton_OnHide()
	TitanGold:CancelTimer(GoldTimer, true)
	GoldTimer = nil;
end

-- **************************************************************************
-- NAME : TitanGold_OnEvent()
-- DESC : This section will grab the events registered to the add on and act on them
-- **************************************************************************
function TitanGold_OnEvent(self, event, ...)
	if (event == "PLAYER_MONEY") then
		if (GOLD_INITIALIZED) then
			GoldSave[GOLD_INDEX].gold = GetMoney("player")
			TitanPanelButton_UpdateButton(TITAN_GOLD_ID)
		end
		return;
	end

	if (event == "PLAYER_ENTERING_WORLD") then
		if (not GOLD_INITIALIZED) then
			TitanPanelGoldButton_Initialize_Array(self);
		end
		return;
	end
end

-- *******************************************************************************************
-- NAME: TitanPanelGoldButton_GetTooltipText()
-- DESC: Gets our tool-tip text, what appears when we hover over our item on the Titan bar.
-- *******************************************************************************************
function TitanPanelGoldButton_GetTooltipText()
	-- the following code will parse the database and then display all members from the same faction/server
	-- to the user

	local server = realmName.."::"..UnitFactionGroup("Player");
	GoldSave[GOLD_INDEX].gold = GetMoney("player")
	local currentMoneyRichText = ""; -- initialize the variable to hold the array
	local coin_str = ""
	local character, charserver = "", ""
	local ttlgold = 0
	local show_labels = (TitanGetVar(TITAN_GOLD_ID, "ShowCoinLabels")
		or TitanGetVar(TITAN_GOLD_ID, "ShowCoinIcons"))

	-- This next section will sort the array based on user preference 
	-- either by name, or by gold amount decending.

	local GoldSaveSorted = {};
	for index, money in pairs(GoldSave) do
		character, charserver = string.match(index, '(.*)_(.*)');
		if (character) then
			if (charserver == server) then
				table.insert(GoldSaveSorted, index); -- insert all keys from hash into the array
			end
		end
	end

	if TitanGetVar(TITAN_GOLD_ID, "SortByName") then
		table.sort(GoldSaveSorted, function (key1, key2) return GoldSave[key1].name < GoldSave[key2].name end)
	else
		table.sort(GoldSaveSorted, function (key1, key2) return GoldSave[key1].gold > GoldSave[key2].gold end)
	end

	for i = 1, getn(GoldSaveSorted) do 
		character, charserver = string.match(GoldSaveSorted[i], '(.*)_(.*)');
		if (character) then
			if (charserver == server) then
				if (GoldSave[GoldSaveSorted[i]].show) then
					coin_str = NiceCash(GoldSave[GoldSaveSorted[i]].gold, false, false)

					currentMoneyRichText = currentMoneyRichText.."\n"..character.."\t"..coin_str
				end
			end
		end
	end

	coin_str = NiceCash(TitanPanelGoldButton_TotalGold(), false, false)
	currentMoneyRichText = currentMoneyRichText.."\n"
		..TITAN_GOLD_SPACERBAR.."\n"
		..L["TITAN_GOLD_TTL_GOLD"].."\t"..coin_str

	-- find session earnings and earning per hour
	local sesstotal = GetMoney("player") - GOLD_STARTINGGOLD;
	local negative = false;
	if (sesstotal < 0) then
		sesstotal = math.abs(sesstotal);
		negative = true;
	end

	local sesslength = GetTime() - GOLD_SESSIONSTART;
	local perhour = math.floor(sesstotal / sesslength * 3600);

	coin_str = NiceCash(GOLD_STARTINGGOLD, false, false)
	local sessionMoneyRichText = "\n\n"..TitanUtils_GetHighlightText(L["TITAN_GOLD_STATS_TITLE"])
		.."\n"..L["TITAN_GOLD_START_GOLD"].."\t"..coin_str.."\n"

	if (negative) then
		GOLD_COLOR = TITAN_GOLD_RED;
		GOLD_SESS_STATUS = L["TITAN_GOLD_SESS_LOST"];
		GOLD_PERHOUR_STATUS = L["TITAN_GOLD_PERHOUR_LOST"];
	else
		GOLD_COLOR = TITAN_GOLD_GREEN;
		GOLD_SESS_STATUS = L["TITAN_GOLD_SESS_EARNED"];
		GOLD_PERHOUR_STATUS = L["TITAN_GOLD_PERHOUR_EARNED"];
	end

	coin_str = NiceCash(sesstotal, true, true)
	sessionMoneyRichText = sessionMoneyRichText
		..TitanUtils_GetColoredText(GOLD_SESS_STATUS,GOLD_COLOR)
		.."\t"..coin_str.."\n";

	if TitanGetVar(TITAN_GOLD_ID, "DisplayGoldPerHour") then
		coin_str = NiceCash(perhour, true, true)
		sessionMoneyRichText = sessionMoneyRichText
			..TitanUtils_GetColoredText(GOLD_PERHOUR_STATUS,GOLD_COLOR)
			.."\t"..coin_str.."\n";
	end

	local final_tooltip = L["TITAN_GOLD_TOOLTIPTEXT"].." : "
		..realmName.." : "..select(2,UnitFactionGroup("Player"));
	if (UnitFactionGroup("Player")=="Alliance") then
		GOLD_COLOR = TITAN_GOLD_GREEN;
	else
		GOLD_COLOR = TITAN_GOLD_RED;
	end

	return ""..TitanUtils_GetColoredText(final_tooltip,GOLD_COLOR)..FONT_COLOR_CODE_CLOSE
		..currentMoneyRichText
		..sessionMoneyRichText
--		.."\n\nName: "..(TitanGetVar(TITAN_GOLD_ID, "SortByName") and "T" or "F")
end

-- *******************************************************************************************
-- NAME: TitanPanelGoldButton_FindGold()
-- DESC: This routines determines which gold total the ui wants (server or player) then calls it and returns it
-- *******************************************************************************************
function TitanPanelGoldButton_FindGold()
	if (not GOLD_INITIALIZED) then
		-- in case there is no db entry for this toon, return blank.
		-- When Gold is ready it will init
		return ""
	end

	local server = realmName.."::"..UnitFactionGroup("Player");
	local ret_str = ""
	local ttlgold = 0;

	GoldSave[GOLD_INDEX].gold = GetMoney("player")

	if TitanGetVar(TITAN_GOLD_ID, "ViewAll") then
		ttlgold = TitanPanelGoldButton_TotalGold()
	else
		ttlgold = GetMoney("player");
	end

	ret_str = NiceCash(ttlgold, true, false)
	
	return L["TITAN_GOLD_MENU_TEXT"]..": "..FONT_COLOR_CODE_CLOSE, ret_str
end

-- *******************************************************************************************
-- NAME: TitanPanelGoldButton_TotalGold()
-- DESC: Calculates total gold for display per user selections
-- *******************************************************************************************
function TitanPanelGoldButton_TotalGold()
	local server = realmName.."::"..UnitFactionGroup("Player");
	GoldSave[GOLD_INDEX].gold = GetMoney("player")
	local ttlgold = 0;

	for index, money in pairs(GoldSave) do
		local character, charserver = string.match(index, '(.*)_(.*)');
		if (character) then
			if (charserver == server) then
				if GoldSave[index].show then
					ttlgold = ttlgold + GoldSave[index].gold;
				end
			end
		end
	end

	return ttlgold;
end

local function ShowMenuButtons(faction)
	local info = {};
	local name = GetUnitName("player");
	local server = realmName;
	for index, money in pairs(GoldSave) do
		local character, charserver = string.match(index, "(.*)_(.*)::"..faction);
		if character then
			info.text = character.." - "..charserver;
			info.value = character;
			info.keepShownOnClick = true;
			info.checked = function()
				local rementry = character.."_"..charserver.."::"..faction;
				return GoldSave[rementry].show
			end
			info.func = function()
				local rementry = character.."_"..charserver.."::"..faction;
				GoldSave[rementry].show = not GoldSave[rementry].show;
				TitanPanelButton_UpdateButton(TITAN_GOLD_ID)
			end
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
		end
	end
end

local function DeleteMenuButtons(faction)
	local info = {};
	local name = GetUnitName("player");
	local server = realmName;
	for index, money in pairs(GoldSave) do
		local character, charserver = string.match(index, "(.*)_(.*)::"..faction);
		info.notCheckable = true
		if character then
			info.text = character.." - "..charserver;
			info.value = character;
			info.func = function()
				local rementry = character.."_"..charserver.."::"..faction;
				GoldSave[rementry] = nil;
				TitanPanelButton_UpdateButton(TITAN_GOLD_ID)
			end
			-- cannot delete current character
			if name == character and server == charserver then
				info.disabled = 1;
			else
				info.disabled = nil;
			end
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
		end
	end
end

local function ShowProperLabels(chosen)
	if chosen == "ShowCoinNone" then
		TitanSetVar(TITAN_GOLD_ID, "ShowCoinNone", true);
		TitanSetVar(TITAN_GOLD_ID, "ShowCoinLabels", false);
		TitanSetVar(TITAN_GOLD_ID, "ShowCoinIcons", false);
	end
	if chosen == "ShowCoinLabels" then
		TitanSetVar(TITAN_GOLD_ID, "ShowCoinNone", false);
		TitanSetVar(TITAN_GOLD_ID, "ShowCoinLabels", true);
		TitanSetVar(TITAN_GOLD_ID, "ShowCoinIcons", false);
	end
	if chosen == "ShowCoinIcons" then
		TitanSetVar(TITAN_GOLD_ID, "ShowCoinNone", false);
		TitanSetVar(TITAN_GOLD_ID, "ShowCoinLabels", false);
		TitanSetVar(TITAN_GOLD_ID, "ShowCoinIcons", true);
	end
	TitanPanelButton_UpdateButton(TITAN_GOLD_ID);
end

local function Seperator(chosen)
--[[
TitanDebug("Sep: "
..(chosen or "?").." "
)
--]]
	if chosen == "UseSeperatorComma" then
		TitanSetVar(TITAN_GOLD_ID, "UseSeperatorComma", true);
		TitanSetVar(TITAN_GOLD_ID, "UseSeperatorPeriod", false);
	end
	if chosen == "UseSeperatorPeriod" then
		TitanSetVar(TITAN_GOLD_ID, "UseSeperatorComma", false);
		TitanSetVar(TITAN_GOLD_ID, "UseSeperatorPeriod", true);
	end
	TitanPanelButton_UpdateButton(TITAN_GOLD_ID);
end

-- *******************************************************************************************
-- NAME: TitanPanelRightClickMenu_PrepareGoldMenu
-- DESC: Builds the right click config menu
-- *******************************************************************************************
function TitanPanelRightClickMenu_PrepareGoldMenu()
	if UIDROPDOWNMENU_MENU_LEVEL == 1 then
		-- Menu title
		TitanPanelRightClickMenu_AddTitle(L["TITAN_GOLD_ITEMNAME"]);

		-- Function to toggle button gold view
		if TitanGetVar(TITAN_GOLD_ID, "ViewAll") then
			TitanPanelRightClickMenu_AddCommand(L["TITAN_GOLD_TOGGLE_PLAYER_TEXT"], TITAN_GOLD_ID,"TitanPanelGoldButton_Toggle");
		else
			TitanPanelRightClickMenu_AddCommand(L["TITAN_GOLD_TOGGLE_ALL_TEXT"], TITAN_GOLD_ID,"TitanPanelGoldButton_Toggle");
		end

		-- Function to toggle display sort
		if TitanGetVar(TITAN_GOLD_ID, "SortByName") then
			TitanPanelRightClickMenu_AddCommand(L["TITAN_GOLD_TOGGLE_SORT_GOLD"], TITAN_GOLD_ID,"TitanPanelGoldSort_Toggle");
		else
			TitanPanelRightClickMenu_AddCommand(L["TITAN_GOLD_TOGGLE_SORT_NAME"], TITAN_GOLD_ID,"TitanPanelGoldSort_Toggle");
		end

		-- Function to toggle gold per hour sort
		if TitanGetVar(TITAN_GOLD_ID, "DisplayGoldPerHour") then
			TitanPanelRightClickMenu_AddCommand(L["TITAN_GOLD_TOGGLE_GPH_HIDE"], TITAN_GOLD_ID,"TitanPanelGoldGPH_Toggle");
		else
			TitanPanelRightClickMenu_AddCommand(L["TITAN_GOLD_TOGGLE_GPH_SHOW"], TITAN_GOLD_ID,"TitanPanelGoldGPH_Toggle");
		end

		-- A blank line in the menu
		TitanPanelRightClickMenu_AddSpacer();

		local info = {};
		info.text = L["TITAN_GOLD_COIN_NONE"];
		info.checked = TitanGetVar(TITAN_GOLD_ID, "ShowCoinNone");
		info.func = function()
			ShowProperLabels("ShowCoinNone")
		end
		UIDropDownMenu_AddButton(info, _G["UIDROPDOWNMENU_MENU_LEVEL"]);
		local info = {};
		info.text = L["TITAN_GOLD_COIN_LABELS"];
		info.checked = TitanGetVar(TITAN_GOLD_ID, "ShowCoinLabels");
		info.func = function()
			ShowProperLabels("ShowCoinLabels")
		end
		UIDropDownMenu_AddButton(info, _G["UIDROPDOWNMENU_MENU_LEVEL"]);
		local info = {};
		info.text = L["TITAN_GOLD_COIN_ICONS"];
		info.checked = TitanGetVar(TITAN_GOLD_ID, "ShowCoinIcons");
		info.func = function()
			ShowProperLabels("ShowCoinIcons")
		end
		UIDropDownMenu_AddButton(info, _G["UIDROPDOWNMENU_MENU_LEVEL"]);

		TitanPanelRightClickMenu_AddSpacer();

		local info = {};
		info.text = L["TITAN_USE_COMMA"];
		info.checked = TitanGetVar(TITAN_GOLD_ID, "UseSeperatorComma");
		info.func = function()
			Seperator("UseSeperatorComma")
		end
		UIDropDownMenu_AddButton(info, _G["UIDROPDOWNMENU_MENU_LEVEL"]);
		local info = {};
		info.text = L["TITAN_USE_PERIOD"];
		info.checked = TitanGetVar(TITAN_GOLD_ID, "UseSeperatorPeriod");
		info.func = function()
			Seperator("UseSeperatorPeriod")
		end
		UIDropDownMenu_AddButton(info, _G["UIDROPDOWNMENU_MENU_LEVEL"]);

		TitanPanelRightClickMenu_AddSpacer();

		info = {};
		info.text = L["TITAN_GOLD_ONLY"];
		info.checked = TitanGetVar(TITAN_GOLD_ID, "ShowGoldOnly");
		info.func = function()
			TitanToggleVar(TITAN_GOLD_ID, "ShowGoldOnly");
			TitanPanelButton_UpdateButton(TITAN_GOLD_ID);
		end
		UIDropDownMenu_AddButton(info, _G["UIDROPDOWNMENU_MENU_LEVEL"]);

		-- A blank line in the menu
		TitanPanelRightClickMenu_AddSpacer();

		-- Show toon
		info = {};
		info.notCheckable = true
		info.text = L["TITAN_GOLD_SHOW_PLAYER"];
		info.value = "ToonShow";
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info);

		-- Delete toon
		info = {};
		info.notCheckable = true
		info.text = L["TITAN_GOLD_DELETE_PLAYER"];
		info.value = "ToonDelete";
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info);

		-- A blank line in the menu
		TitanPanelRightClickMenu_AddSpacer();

		-- Function to clear the enter database
		info = {};
		info.notCheckable = true
		info.text = L["TITAN_GOLD_CLEAR_DATA_TEXT"];
		info.func = TitanGold_ClearDB;
		UIDropDownMenu_AddButton(info);

		TitanPanelRightClickMenu_AddCommand(L["TITAN_GOLD_RESET_SESS_TEXT"], TITAN_GOLD_ID, "TitanPanelGoldButton_ResetSession");

		-- A blank line in the menu
		TitanPanelRightClickMenu_AddSpacer();
		TitanPanelRightClickMenu_AddToggleIcon(TITAN_GOLD_ID);
		TitanPanelRightClickMenu_AddToggleLabelText(TITAN_GOLD_ID);
		TitanPanelRightClickMenu_AddToggleColoredText(TITAN_GOLD_ID);
		TitanPanelRightClickMenu_AddSpacer();

		-- Generic function to toggle and hide
		TitanPanelRightClickMenu_AddCommand(L["TITAN_PANEL_MENU_HIDE"], TITAN_GOLD_ID, TITAN_PANEL_MENU_FUNC_HIDE);
	end

	if UIDROPDOWNMENU_MENU_LEVEL == 2 and UIDROPDOWNMENU_MENU_VALUE == "ToonDelete" then
		local info = {};
		info.notCheckable = true
		info.text = L["TITAN_GOLD_FACTION_PLAYER_ALLY"];
		info.value = "DeleteAlliance";
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

		info.text = L["TITAN_GOLD_FACTION_PLAYER_HORDE"];
		info.value = "DeleteHorde";
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	elseif UIDROPDOWNMENU_MENU_LEVEL == 2 and UIDROPDOWNMENU_MENU_VALUE == "ToonShow" then
		local info = {};
		info.notCheckable = true
		info.text = L["TITAN_GOLD_FACTION_PLAYER_ALLY"];
		info.value = "ShowAlliance";
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

		info.text = L["TITAN_GOLD_FACTION_PLAYER_HORDE"];
		info.value = "ShowHorde";
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	end
		
	if UIDROPDOWNMENU_MENU_LEVEL == 3 and UIDROPDOWNMENU_MENU_VALUE == "DeleteAlliance" then
		DeleteMenuButtons("Alliance")
	elseif UIDROPDOWNMENU_MENU_LEVEL == 3 and UIDROPDOWNMENU_MENU_VALUE == "DeleteHorde" then
		DeleteMenuButtons("Horde")
	elseif UIDROPDOWNMENU_MENU_LEVEL == 3 and UIDROPDOWNMENU_MENU_VALUE == "ShowAlliance" then
		ShowMenuButtons("Alliance")
	elseif UIDROPDOWNMENU_MENU_LEVEL == 3 and UIDROPDOWNMENU_MENU_VALUE == "ShowHorde" then
		ShowMenuButtons("Horde")
	end
end

-- **************************************************************************
-- NAME : TitanPanelGoldButton_ClearData()
-- DESC : This will allow the user to clear all the data and rebuild the array
-- **************************************************************************
function TitanPanelGoldButton_ClearData(self)
	GOLD_INITIALIZED = false;

	GoldSave = {};
	TitanPanelGoldButton_Initialize_Array(self);

	DEFAULT_CHAT_FRAME:AddMessage(TitanUtils_GetGreenText(L["TITAN_GOLD_DB_CLEARED"]));
end

-- **************************************************************************
-- NAME : TitanPanelGoldButton_Initialize_Array()
-- DESC : Build the gold array for the server/faction
-- **************************************************************************
function TitanPanelGoldButton_Initialize_Array(self)
	if (GOLD_INITIALIZED) then return; end

	self:UnregisterEvent("VARIABLES_LOADED");

	if (GoldSave[GOLD_INDEX] == nil) then
		GoldSave[GOLD_INDEX] = {}
	end
	GoldSave[GOLD_INDEX] = {gold = GetMoney("player"), show = true, name = UnitName("player")}

	GOLD_STARTINGGOLD = GetMoney("player");
	GOLD_SESSIONSTART = GetTime();
	GOLD_INITIALIZED = true;

	-- AFTER we say init is done or we'll never show the gold!
	TitanPanelButton_UpdateButton(TITAN_GOLD_ID)
end

-- *******************************************************************************************
-- NAME: TitanPanelGoldButton_Toggle()
-- DESC: This toggles whether or not the player wants to view total gold on the button, or player gold.
-- *******************************************************************************************
function TitanPanelGoldButton_Toggle()
	TitanToggleVar(TITAN_GOLD_ID, "ViewAll")
	TitanPanelButton_UpdateButton(TITAN_GOLD_ID)
end

-- *******************************************************************************************
-- NAME: TitanPanelGoldSort_Toggle()
-- DESC: This toggles how the player wants the display to be sorted - by name or gold amount
-- *******************************************************************************************
function TitanPanelGoldSort_Toggle()
	TitanToggleVar(TITAN_GOLD_ID, "SortByName")
end

-- *******************************************************************************************
-- NAME: TitanPanelGoldGPH_Toggle()
-- DESC: This toggles if the player wants to see the gold/hour stats
-- *******************************************************************************************
function TitanPanelGoldGPH_Toggle()
	TitanToggleVar(TITAN_GOLD_ID, "DisplayGoldPerHour")

	if not GoldTimer and TitanGetVar(TITAN_GOLD_ID, "DisplayGoldPerHour") then
		GoldTimer = TitanGold:ScheduleRepeatingTimer(TitanPanelPluginHandle_OnUpdate, 1, updateTable)
	elseif GoldTimer and not TitanGetVar(TITAN_GOLD_ID, "DisplayGoldPerHour") then
		TitanGold:CancelTimer(GoldTimer, true)
		GoldTimer = nil;
	end
end

-- *******************************************************************************************
-- NAME: TitanPanelGoldButton_ResetSession()
-- DESC: Resets the current session
-- *******************************************************************************************
function TitanPanelGoldButton_ResetSession()
	GOLD_STARTINGGOLD = GetMoney("player");
	GOLD_SESSIONSTART = GetTime();
	DEFAULT_CHAT_FRAME:AddMessage(TitanUtils_GetGreenText(L["TITAN_GOLD_SESSION_RESET"]));
end

function TitanGold_ClearDB()
	StaticPopupDialogs["TITANGOLD_CLEAR_DATABASE"] = {
		text = TitanUtils_GetNormalText(L["TITAN_PANEL_MENU_TITLE"].." "
			..L["TITAN_GOLD_MENU_TEXT"]).."\n\n"..L["TITAN_GOLD_CLEAR_DATA_WARNING"],
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function(self)
			local frame = _G["TitanPanelGoldButton"]
			TitanPanelGoldButton_ClearData(frame)
		end,	
		showAlert = 1,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1
	};
	StaticPopup_Show("TITANGOLD_CLEAR_DATABASE");
end
