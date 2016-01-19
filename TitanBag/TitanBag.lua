-- **************************************************************************
-- * TitanBag.lua
-- *
-- * By: TitanMod, Dark Imakuni, Adsertor and the Titan Development Team
-- **************************************************************************

-- ******************************** Constants *******************************
local _G = getfenv(0);
local TITAN_BAG_ID = "Bag";
local TITAN_BAG_THRESHOLD_TABLE = {
	Values = { 0.5, 0.75 },
	Colors = { GREEN_FONT_COLOR, NORMAL_FONT_COLOR, RED_FONT_COLOR },
}
local updateTable = {TITAN_BAG_ID, TITAN_PANEL_UPDATE_BUTTON};
-- ******************************** Variables *******************************
local L = LibStub("AceLocale-3.0"):GetLocale("Titan", true)
local AceTimer = LibStub("AceTimer-3.0")
local BagTimer
-- ******************************** Functions *******************************

-- **************************************************************************
-- NAME : TitanPanelBagButton_OnLoad()
-- DESC : Registers the plugin upon it loading
-- **************************************************************************
function TitanPanelBagButton_OnLoad(self)
	self.registry = {
		id = TITAN_BAG_ID,
		category = "Built-ins",
		version = TITAN_VERSION,
		menuText = L["TITAN_BAG_MENU_TEXT"],
		buttonTextFunction = "TitanPanelBagButton_GetButtonText",
		tooltipTitle = L["TITAN_BAG_TOOLTIP"],
		tooltipTextFunction = "TitanPanelBagButton_GetTooltipText",
		icon = "Interface\\AddOns\\TitanBag\\TitanBag",
		iconWidth = 16,
		controlVariables = {
			ShowIcon = true,
			ShowLabelText = true,
			ShowRegularText = false,
			ShowColoredText = true,
			DisplayOnRightSide = false
		},
		savedVariables = {
			ShowUsedSlots = 1,
			ShowDetailedInfo = false,
			CountProfBagSlots = false,
			ShowIcon = 1,
			ShowLabelText = 1,
			ShowColoredText = 1,
		}
	};

	self:RegisterEvent("PLAYER_ENTERING_WORLD");
end

-- **************************************************************************
-- NAME : TitanPanelBagButton_OnEvent()
-- DESC : Parse events registered to plugin and act on them
-- **************************************************************************
function TitanPanelBagButton_OnEvent(self, event, ...)
	if (event == "PLAYER_ENTERING_WORLD") and (not self:IsEventRegistered("BAG_UPDATE")) then
		self:RegisterEvent("BAG_UPDATE");
	end

	if event == "BAG_UPDATE" then
		-- Create only when the event is active
		self:SetScript("OnUpdate", TitanPanelBagButton_OnUpdate)
	end
end

function TitanPanelBagButton_OnUpdate(self)
	-- update the button
	TitanPanelPluginHandle_OnUpdate(updateTable)
	-- remove until the next bag event
	self:SetScript("OnUpdate", nil)
end

-- **************************************************************************
-- NAME : TitanPanelBagButton_OnClick(button)
-- DESC : Opens all bags on a LeftClick
-- VARS : button = value of action
-- **************************************************************************
function TitanPanelBagButton_OnClick(self, button)
	if (button == "LeftButton") then
		ToggleAllBags();
	end
end

-- **************************************************************************
-- NAME : TitanPanelBagButton_GetButtonText(id)
-- DESC : Calculate bag space logic then display data on button
-- VARS : id = button ID
-- **************************************************************************
function TitanPanelBagButton_GetButtonText(id)
	local button, id = TitanUtils_GetButton(id, true);
	local totalBagSlots, usedBagSlots, availableBagSlots, bag, bagText, bagRichText, color;
	local totalProfBagSlots = {0,0,0,0,0};
	local usedProfBagSlots = {0,0,0,0,0};
	local availableProfBagSlots = {0,0,0,0,0};
	local bagRichTextProf = {"","","","",""};

	totalBagSlots = 0;
	usedBagSlots = 0;
	for bag = 0, 4 do
		if not TitanBag_IsProfBag(GetBagName(bag)) then
			local size = GetContainerNumSlots(bag);
			if (size and size > 0) then
				totalBagSlots = totalBagSlots + size;
				for slot = 1, size do
					if (GetContainerItemInfo(bag, slot)) then
						usedBagSlots = usedBagSlots + 1;
					end
				end
			end
		end
		if TitanGetVar(TITAN_BAG_ID, "CountProfBagSlots") and TitanBag_IsProfBag(GetBagName(bag)) then
			local size = GetContainerNumSlots(bag);
			if (size and size > 0) then
				totalProfBagSlots[bag+1] = size;
				for slot = 1, size do
					if (GetContainerItemInfo(bag, slot)) then
						usedProfBagSlots[bag+1] = usedProfBagSlots[bag+1] + 1;
					end
				end
				availableProfBagSlots[bag+1] = totalProfBagSlots[bag+1] - usedProfBagSlots[bag+1];
			end
		end
	end
	availableBagSlots = totalBagSlots - usedBagSlots;

	if (TitanGetVar(TITAN_BAG_ID, "ShowUsedSlots")) then
		bagText = format(L["TITAN_BAG_FORMAT"], usedBagSlots, totalBagSlots);
	else
		bagText = format(L["TITAN_BAG_FORMAT"], availableBagSlots, totalBagSlots);
	end

	if ( TitanGetVar(TITAN_BAG_ID, "ShowColoredText") ) then
		color = TitanUtils_GetThresholdColor(TITAN_BAG_THRESHOLD_TABLE, usedBagSlots / totalBagSlots);
		bagRichText = TitanUtils_GetColoredText(bagText, color);
	else
		bagRichText = TitanUtils_GetHighlightText(bagText);
	end

	for bag = 1, 5 do
		if totalProfBagSlots[bag] > 0 then
			if (TitanGetVar(TITAN_BAG_ID, "ShowUsedSlots")) then
				bagText = "  [" .. format(L["TITAN_BAG_FORMAT"], usedProfBagSlots[bag], totalProfBagSlots[bag]) .. "]";
			else
				bagText = "  [" .. format(L["TITAN_BAG_FORMAT"], availableProfBagSlots[bag], totalProfBagSlots[bag]) .. "]";
			end
			if ( TitanGetVar(TITAN_BAG_ID, "ShowColoredText") ) then
				bagType, color = TitanBag_IsProfBag(GetBagName(bag-1));
				bagRichTextProf[bag] = TitanUtils_GetColoredText(bagText, color);
			else
				bagRichTextProf[bag] = TitanUtils_GetHighlightText(bagText);
			end
		end
	end
	bagRichText = bagRichText..bagRichTextProf[1]..bagRichTextProf[2]..bagRichTextProf[3]..bagRichTextProf[4]..bagRichTextProf[5];
	return L["TITAN_BAG_BUTTON_LABEL"], bagRichText;
end

-- **************************************************************************
-- NAME : TitanPanelBagButton_GetTooltipText()
-- DESC : Display tooltip text
-- **************************************************************************
function TitanPanelBagButton_GetTooltipText()
	local totalSlots, usedSlots, availableSlots;
	local returnstring = "";

	if TitanGetVar(TITAN_BAG_ID, "ShowDetailedInfo") then
		returnstring = "\n";
		if TitanGetVar(TITAN_BAG_ID, "ShowUsedSlots") then
			returnstring = returnstring..TitanUtils_GetNormalText(L["TITAN_BAG_MENU_TEXT"])
				..":\t"..TitanUtils_GetNormalText(L["TITAN_BAG_USED_SLOTS"])..":\n";
		else
			returnstring = returnstring..TitanUtils_GetNormalText(L["TITAN_BAG_MENU_TEXT"])
				..":\t"..TitanUtils_GetNormalText(L["TITAN_BAG_FREE_SLOTS"])..":\n";
		end

		for bag = 0, 4 do
			totalSlots = GetContainerNumSlots(bag) or 0;
			availableSlots = GetContainerNumFreeSlots(bag) or 0;
			usedSlots = totalSlots - availableSlots;
			local itemlink  = bag > 0 and GetInventoryItemLink("player", ContainerIDToInventoryID(bag)) 
				or TitanUtils_GetHighlightText(L["TITAN_BAG_BACKPACK"]).. FONT_COLOR_CODE_CLOSE;

			if itemlink then
				itemlink = string.gsub( itemlink, "%[", "" );
				itemlink = string.gsub( itemlink, "%]", "" );
			end

			if bag > 0 and not GetInventoryItemLink("player", ContainerIDToInventoryID(bag)) then
				itemlink = nil;
			end

			local bagText, bagRichText, color;
			if (TitanGetVar(TITAN_BAG_ID, "ShowUsedSlots")) then
				bagText = format(L["TITAN_BAG_FORMAT"], usedSlots, totalSlots);
			else
				bagText = format(L["TITAN_BAG_FORMAT"], availableSlots, totalSlots);
			end

			if ( TitanGetVar(TITAN_BAG_ID, "ShowColoredText") ) then
				if totalSlots == 0 then
					color = TitanUtils_GetThresholdColor(TITAN_BAG_THRESHOLD_TABLE, 1 );
				else
					color = TitanUtils_GetThresholdColor(TITAN_BAG_THRESHOLD_TABLE, usedSlots / totalSlots);
				end
				bagRichText = TitanUtils_GetColoredText(bagText, color);
			else
				bagRichText = TitanUtils_GetHighlightText(bagText);
			end

			if itemlink then
				returnstring = returnstring..itemlink.."\t"..bagRichText.."\n";
			end
		end
		returnstring = returnstring.."\n";
	end
	return returnstring..TitanUtils_GetGreenText(L["TITAN_BAG_TOOLTIP_HINTS"]);
end

-- **************************************************************************
-- NAME : TitanPanelRightClickMenu_PrepareBagMenu()
-- DESC : Display rightclick menu options
-- **************************************************************************
function TitanPanelRightClickMenu_PrepareBagMenu()
	local info
	-- level 2
	if _G["UIDROPDOWNMENU_MENU_LEVEL"] == 2 then
		if _G["UIDROPDOWNMENU_MENU_VALUE"] == "Options" then
			TitanPanelRightClickMenu_AddTitle(L["TITAN_PANEL_OPTIONS"], _G["UIDROPDOWNMENU_MENU_LEVEL"])
			info = {};
			info.text = L["TITAN_BAG_MENU_SHOW_USED_SLOTS"];
			info.func = TitanPanelBagButton_ShowUsedSlots;
			info.checked = TitanGetVar(TITAN_BAG_ID, "ShowUsedSlots");
			UIDropDownMenu_AddButton(info, _G["UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["TITAN_BAG_MENU_SHOW_AVAILABLE_SLOTS"];
			info.func = TitanPanelBagButton_ShowAvailableSlots;
			info.checked = TitanUtils_Toggle(TitanGetVar(TITAN_BAG_ID, "ShowUsedSlots"));
			UIDropDownMenu_AddButton(info, _G["UIDROPDOWNMENU_MENU_LEVEL"]);

			info = {};
			info.text = L["TITAN_BAG_MENU_SHOW_DETAILED"];
			info.func = TitanPanelBagButton_ShowDetailedInfo;
			info.checked = TitanGetVar(TITAN_BAG_ID, "ShowDetailedInfo");
			UIDropDownMenu_AddButton(info, _G["UIDROPDOWNMENU_MENU_LEVEL"]);
		end
		return
	end
	
	-- level 1
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_BAG_ID].menuText);

	info = {};
	info.notCheckable = true
	info.text = L["TITAN_PANEL_OPTIONS"];
	info.value = "Options"
	info.hasArrow = 1;
	UIDropDownMenu_AddButton(info);

	TitanPanelRightClickMenu_AddSpacer();
	info = {};
	info.text = L["TITAN_BAG_MENU_IGNORE_PROF_BAGS_SLOTS"];
	info.func = TitanPanelBagButton_ToggleIgnoreProfBagSlots;
	info.checked = TitanUtils_Toggle(TitanGetVar(TITAN_BAG_ID, "CountProfBagSlots"));
	UIDropDownMenu_AddButton(info, _G["UIDROPDOWNMENU_MENU_LEVEL"]);

	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddToggleIcon(TITAN_BAG_ID);
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_BAG_ID);
	TitanPanelRightClickMenu_AddToggleColoredText(TITAN_BAG_ID);
	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddCommand(L["TITAN_PANEL_MENU_HIDE"], TITAN_BAG_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end

-- **************************************************************************
-- NAME : TitanPanelBagButton_ShowUsedSlots()
-- DESC : Set option to show used slots
-- **************************************************************************
function TitanPanelBagButton_ShowUsedSlots()
	TitanSetVar(TITAN_BAG_ID, "ShowUsedSlots", 1);
	TitanPanelButton_UpdateButton(TITAN_BAG_ID);
end

-- **************************************************************************
-- NAME : TitanPanelBagButton_ShowAvailableSlots()
-- DESC : Set option to show available slots
-- **************************************************************************
function TitanPanelBagButton_ShowAvailableSlots()
	TitanSetVar(TITAN_BAG_ID, "ShowUsedSlots", nil);
	TitanPanelButton_UpdateButton(TITAN_BAG_ID);
end

-- **************************************************************************
-- NAME : TitanPanelBagButton_ToggleIgnoreProfBagSlots()
-- DESC : Set option to count profession bag slots
-- **************************************************************************
function TitanPanelBagButton_ToggleIgnoreProfBagSlots()
	TitanToggleVar(TITAN_BAG_ID, "CountProfBagSlots");
	TitanPanelButton_UpdateButton(TITAN_BAG_ID);
end

function TitanPanelBagButton_ShowDetailedInfo()
	TitanToggleVar(TITAN_BAG_ID, "ShowDetailedInfo");
end

-- **************************************************************************
-- NAME : TitanBag_IsProfBag(name)
-- DESC : est to see if bag is a profession bag
-- VARS : name = item name
-- OUT  : bagType = type of profession matching bag name
--        color = the color associated with the profession
-- **************************************************************************
function TitanBag_IsProfBag(name)
	local bagType, color;
	if (name) then
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_ENCHANTING"]) do
			if (string.find(name, value, 1, true)) then
				bagType = "ENCHANTING";
				color = {r=0,g=0,b=1}; -- BLUE
				return bagType, color;
			end
		end
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_ENGINEERING"]) do
			if (string.find(name, value, 1, true)) then
				bagType = "ENGINEERING";
				color = {r=1,g=0.49,b=0.04}; -- ORANGE
				return bagType, color;
			end
		end
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_HERBALISM"]) do
			if (string.find(name, value, 1, true)) then
				bagType = "HERBALISM";
				color = {r=0,g=1,b=0}; -- GREEN
				return bagType, color;
			end
		end
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_INSCRIPTION"]) do
			if (string.find(name, value, 1, true)) then
				bagType = "INSCRIPTION";
				color = {r=0.58,g=0.51,b=0.79}; -- PURPLE
				return bagType, color;
			end
		end
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_JEWELCRAFTING"]) do
			if (string.find(name, value, 1, true)) then
				bagType = "JEWELCRAFTING";
				color = {r=1,g=0,b=0}; -- RED
				return bagType, color;
			end
		end
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_LEATHERWORKING"]) do
			if (string.find(name, value, 1, true)) then
				bagType = "LEATHERWORKING";
				color = {r=0.78,g=0.61,b=0.43}; -- TAN
				return bagType, color;
			end
		end
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_MINING"]) do
			if (string.find(name, value, 1, true)) then
				bagType = "MINING";
				color = {r=1,g=1,b=1}; -- WHITE
				return bagType, color;
			end
		end
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_FISHING"]) do
			if (string.find(name, value, 1, true)) then
				bagType = "FISHING";
				color = {r=0.41,g=0.8,b=0.94}; -- LIGHT_BLUE
				return bagType, color;
			end
		end
		for index, value in pairs(L["TITAN_BAG_PROF_BAG_COOKING"]) do
			if (string.find(name, value, 1, true)) then
				bagType = "COOKING";
				color = {r=0.96,g=0.55,b=0.73}; -- PINK
				return bagType, color;
			end
		end
	end
	return false;
end