-- **************************************************************************
-- * TitanLootType.lua
-- *
-- * By: TitanMod, Dark Imakuni, Adsertor and the Titan Development Team
-- **************************************************************************

-- ******************************** Constants *******************************
local TITAN_LOOTTYPE_ID = "LootType";
local _G = getfenv(0);
local L = LibStub("AceLocale-3.0"):GetLocale("Titan", true)
local TitanLootMethod = {};
local updateTable = {TITAN_LOOTTYPE_ID, TITAN_PANEL_UPDATE_ALL};
TitanLootMethod["freeforall"] = {text = L["TITAN_LOOTTYPE_FREE_FOR_ALL"]};
TitanLootMethod["roundrobin"] = {text = L["TITAN_LOOTTYPE_ROUND_ROBIN"]};
TitanLootMethod["master"] = {text = L["TITAN_LOOTTYPE_MASTER_LOOTER"]};
TitanLootMethod["group"] = {text = L["TITAN_LOOTTYPE_GROUP_LOOT"]};
TitanLootMethod["needbeforegreed"] = {text = L["TITAN_LOOTTYPE_NEED_BEFORE_GREED"]};
TitanLootMethod["personalloot"] = {text = L["TITAN_LOOTTYPE_PERSONAL"]};

-- ******************************** Variables *******************************

-- ******************************** Functions *******************************

-- **************************************************************************
-- NAME : TitanPanelLootTypeButton_OnLoad()
-- DESC : Registers the plugin upon it loading
-- **************************************************************************
function TitanPanelLootTypeButton_OnLoad(self)
	self.registry = {
		id = TITAN_LOOTTYPE_ID,
		category = "Built-ins",
		version = TITAN_VERSION,
		menuText = L["TITAN_LOOTTYPE_MENU_TEXT"],
		buttonTextFunction = "TitanPanelLootTypeButton_GetButtonText",
		tooltipTitle = L["TITAN_LOOTTYPE_TOOLTIP"],
		tooltipTextFunction = "TitanPanelLootTypeButton_GetTooltipText",
		icon = "Interface\\AddOns\\TitanLootType\\TitanLootType",
		iconWidth = 16,
		controlVariables = {
			ShowIcon = true,
			ShowLabelText = true,
			ShowRegularText = false,
			ShowColoredText = false,
			DisplayOnRightSide = false
		},
		savedVariables = {
			ShowIcon = 1,
			ShowLabelText = 1,
			RandomRoll = 100,
			ShowDungeonDiff = false,
			DungeonDiffType = "AUTO",
		}
	};

	self:RegisterEvent("PARTY_MEMBERS_CHANGED");
	self:RegisterEvent("RAID_ROSTER_UPDATE");
	self:RegisterEvent("PARTY_LOOT_METHOD_CHANGED");
	self:RegisterEvent("CHAT_MSG_SYSTEM");
end

function TitanPanelLootTypeButton_GetDungeonDifficultyIDText(isRaid, withpar)
	local par1, par2 = "", ""
	if withpar then par1, par2 = "(", ")" end
	local diffstr = "|cffffff9a"..par1.._G["UNKNOWN"]..par2.."|r"
	if isRaid then
		-- raids
		local diff = GetRaidDifficultyID()
		if not diff then return diffstr end
		local name, groupType, isHeroic, isChallengeMode, displayHeroic, displayMythic, toggleDifficultyID = GetDifficultyInfo(diff)
		-- remove () chars from difficulty
		local tmpstr = string.gsub(name, "%(", "")
		tmpstr = string.gsub(tmpstr, "%)", "")
		if diff == 3 or diff == 4 then
			diffstr = _G["ORANGE_FONT_COLOR_CODE"]..par1..tmpstr..par2.."|r"
		else
			diffstr = _G["RED_FONT_COLOR_CODE"]..par1..tmpstr..par2.."|r"
		end
	else
		-- dungeons
		local diff = GetDungeonDifficultyID()
		if not diff then return diffstr end
		local name, groupType, isHeroic, isChallengeMode, displayHeroic, displayMythic, toggleDifficultyID = GetDifficultyInfo(diff)
		-- remove () chars from difficulty
		local tmpstr = string.gsub(name, "%(", "")
		tmpstr = string.gsub(tmpstr, "%)", "")
		diffstr = _G["GREEN_FONT_COLOR_CODE"]..par1..tmpstr..par2.."|r"
		if diff == 2 then
			diffstr = _G["ORANGE_FONT_COLOR_CODE"]..par1..tmpstr..par2.."|r"
		elseif diff == 8 then
			diffstr = _G["RED_FONT_COLOR_CODE"]..par1..tmpstr..par2.."|r"
		end
	end
	return diffstr
end

-- **************************************************************************
-- NAME : TitanPanelLootTypeButton_OnEvent()
-- DESC : Parse events registered to plugin and act on them
-- **************************************************************************
function TitanPanelLootTypeButton_OnEvent(self, event, ...)
	local arg1 = ...;
	if event == "CHAT_MSG_SYSTEM" then
		-- Match difficulty system message to alert addon for possible update
		-- dungeons
		local strm1 = format( _G["ERR_DUNGEON_DIFFICULTY_CHANGED_S"], _G["DUNGEON_DIFFICULTY1"]) -- 5 Player
		local strm2 = format( _G["ERR_DUNGEON_DIFFICULTY_CHANGED_S"], _G["DUNGEON_DIFFICULTY2"]) -- 10 Player
		local strm3 = format( _G["ERR_DUNGEON_DIFFICULTY_CHANGED_S"], _G["DUNGEON_DIFFICULTY3"]) -- Epic (Unused)

		-- raids
		local strm4 = format( _G["ERR_RAID_DIFFICULTY_CHANGED_S"], _G["RAID_DIFFICULTY1"]) -- 10 Player
		local strm5 = format( _G["ERR_RAID_DIFFICULTY_CHANGED_S"], _G["RAID_DIFFICULTY2"]) -- 25 Player
		local strm6 = format( _G["ERR_RAID_DIFFICULTY_CHANGED_S"], _G["RAID_DIFFICULTY3"]) -- 10 Player (Heroic)
		local strm7 = format( _G["ERR_RAID_DIFFICULTY_CHANGED_S"], _G["RAID_DIFFICULTY4"]) -- 25 Player (Heroic)

		-- legacy raid
--		local strm7 = format( _G["ERR_RAID_DIFFICULTY_CHANGED_S"], _G["LEGACY_RAID_DIFFICULTY1"])
--		local strm8 = format( _G["ERR_RAID_DIFFICULTY_CHANGED_S"], _G["LEGACY_RAID_DIFFICULTY2"])

		if (arg1 == strm1 or arg1 == strm2 or arg1 == strm3 or arg1 == strm4 or arg1 == strm5 or arg1 == strm6 or arg1 == strm7) and TitanGetVar(TITAN_LOOTTYPE_ID, "ShowDungeonDiff") then
			TitanPanelPluginHandle_OnUpdate(updateTable)
		end
		return;
	end
	TitanPanelPluginHandle_OnUpdate(updateTable)
end

-- **************************************************************************
-- NAME : TitanPanelLootTypeButton_GetButtonText(id)
-- DESC : Calculate loottype and then display data on button
-- VARS : id = button ID
-- **************************************************************************
function TitanPanelLootTypeButton_GetButtonText(id)
	local lootTypeText, lootThreshold, color, dungeondiff;
	dungeondiff = "";
	if (GetNumSubgroupMembers() > 0) or (GetNumGroupMembers() > 0) then
		lootTypeText = TitanLootMethod[GetLootMethod()].text;
		lootThreshold = GetLootThreshold();
		color = _G["ITEM_QUALITY_COLORS"][lootThreshold];
	else
		lootTypeText = _G["SOLO"];
		color = _G["GRAY_FONT_COLOR"];
	end
	if TitanGetVar(TITAN_LOOTTYPE_ID, "ShowDungeonDiff") then
		if TitanGetVar(TITAN_LOOTTYPE_ID, "DungeonDiffType") == "DUNGEON" then
			-- Dungeon
			dungeondiff = dungeondiff.." "..TitanPanelLootTypeButton_GetDungeonDifficultyIDText(false, true)
		elseif TitanGetVar(TITAN_LOOTTYPE_ID, "DungeonDiffType") == "RAID" then
			-- Raid
			dungeondiff = dungeondiff.." "..TitanPanelLootTypeButton_GetDungeonDifficultyIDText(true, true)
		elseif TitanGetVar(TITAN_LOOTTYPE_ID, "DungeonDiffType") == "AUTO" then
			-- Auto
			if UnitExists("party1") and (GetNumGroupMembers() == 0 or GetNumGroupMembers() < 0) then dungeondiff = dungeondiff.." "..TitanPanelLootTypeButton_GetDungeonDifficultyIDText(false, true) end
			if GetNumGroupMembers() > 0 then dungeondiff = dungeondiff.." "..TitanPanelLootTypeButton_GetDungeonDifficultyIDText(true, true) end
		end
	end
	return L["TITAN_LOOTTYPE_BUTTON_LABEL"], TitanUtils_GetColoredText(lootTypeText, color)..dungeondiff;
end

-- **************************************************************************
-- NAME : TitanPanelLootTypeButton_GetTooltipText()
-- DESC : Display tooltip text
-- **************************************************************************
function TitanPanelLootTypeButton_GetTooltipText()
	if (GetNumSubgroupMembers() > 0) or (GetNumGroupMembers() > 0) then
		local lootTypeText = TitanLootMethod[GetLootMethod()].text;
		local lootThreshold = GetLootThreshold();
		local itemQualityDesc = _G["ITEM_QUALITY"..lootThreshold.."_DESC"];
		local color = _G["ITEM_QUALITY_COLORS"][lootThreshold];
		return ""..
			L["TITAN_LOOTTYPE_DUNGEONDIFF_LABEL"]..": \t"..TitanPanelLootTypeButton_GetDungeonDifficultyIDText().."\n"..
			L["TITAN_LOOTTYPE_DUNGEONDIFF_LABEL2"]..": \t"..TitanPanelLootTypeButton_GetDungeonDifficultyIDText(true).."\n"..
			_G["LOOT_METHOD"]..": \t"..TitanUtils_GetHighlightText(lootTypeText).."\n"..
			_G["LOOT_THRESHOLD"]..": \t"..TitanUtils_GetColoredText(itemQualityDesc, color).."\n"..
			TitanUtils_GetGreenText(L["TITAN_LOOTTYPE_TOOLTIP_HINT1"]).."\n"..
			TitanUtils_GetGreenText(L["TITAN_LOOTTYPE_TOOLTIP_HINT2"]);
	else
		return L["TITAN_LOOTTYPE_DUNGEONDIFF_LABEL"]..": \t"..TitanPanelLootTypeButton_GetDungeonDifficultyIDText().."\n"..
			L["TITAN_LOOTTYPE_DUNGEONDIFF_LABEL2"]..": \t"..TitanPanelLootTypeButton_GetDungeonDifficultyIDText(true).."\n"..
			TitanUtils_GetNormalText(_G["ERR_NOT_IN_GROUP"]).."\n"..
			TitanUtils_GetGreenText(L["TITAN_LOOTTYPE_TOOLTIP_HINT1"]).."\n"..
			TitanUtils_GetGreenText(L["TITAN_LOOTTYPE_TOOLTIP_HINT2"]);
	end
end

-- **************************************************************************
-- NAME : TitanPanelLootType_Random100()
-- DESC : Define random 100 loottype
-- **************************************************************************
function TitanPanelLootType_Random100()
	TitanSetVar(TITAN_LOOTTYPE_ID, "RandomRoll", 100);
end

-- **************************************************************************
-- NAME : TitanPanelLootType_Random1000()
-- DESC : Define random 1000 loottype
-- **************************************************************************
function TitanPanelLootType_Random1000()
	TitanSetVar(TITAN_LOOTTYPE_ID, "RandomRoll", 1000);
end

-- **************************************************************************
-- NAME : TitanPanelLootType_GetRoll(num)
-- DESC : Confirm loottype is random roll
-- **************************************************************************
function TitanPanelLootType_GetRoll(num)
	local temp = TitanGetVar(TITAN_LOOTTYPE_ID, "RandomRoll");
	if temp == num then
		return 1;
	end
	return nil;
end

-- **************************************************************************
-- NAME : TitanPanelRightClickMenu_PrepareLootTypeMenu()
-- DESC : Display rightclick menu options
-- **************************************************************************
function TitanPanelRightClickMenu_PrepareLootTypeMenu()
	local info = {};
	if _G["UIDROPDOWNMENU_MENU_LEVEL"] == 2 and _G["UIDROPDOWNMENU_MENU_VALUE"] == "RandomRoll" then
		info = {}; 
		info.text = "100";
		info.value = 100;
		info.func = TitanPanelLootType_Random100;
		info.checked = TitanPanelLootType_GetRoll(info.value);
		UIDropDownMenu_AddButton(info,_G["UIDROPDOWNMENU_MENU_LEVEL"]);
		info = {};
		info.text = "1000";
		info.value = 1000;
		info.func = TitanPanelLootType_Random1000;
		info.checked = TitanPanelLootType_GetRoll(info.value);
		UIDropDownMenu_AddButton(info,_G["UIDROPDOWNMENU_MENU_LEVEL"]);
	elseif _G["UIDROPDOWNMENU_MENU_LEVEL"] == 2 and _G["UIDROPDOWNMENU_MENU_VALUE"] == "ShowDungeonDiffMenu" then
		info = {};
		info.text = _G["LFG_TYPE_DUNGEON"];
		info.func = function() TitanSetVar(TITAN_LOOTTYPE_ID, "DungeonDiffType", "DUNGEON"); TitanPanelButton_UpdateButton(TITAN_LOOTTYPE_ID) end
		info.checked = function() if TitanGetVar(TITAN_LOOTTYPE_ID, "DungeonDiffType") == "DUNGEON" then return true end return false end
		UIDropDownMenu_AddButton(info,_G["UIDROPDOWNMENU_MENU_LEVEL"]);
		info = {};
		info.text = _G["LFG_TYPE_RAID"];
		info.func = function() TitanSetVar(TITAN_LOOTTYPE_ID, "DungeonDiffType", "RAID"); TitanPanelButton_UpdateButton(TITAN_LOOTTYPE_ID) end
		info.checked = function() if TitanGetVar(TITAN_LOOTTYPE_ID, "DungeonDiffType") == "RAID" then return true end return false end
		UIDropDownMenu_AddButton(info,_G["UIDROPDOWNMENU_MENU_LEVEL"]);
		info = {};
		info.text = L["TITAN_LOOTTYPE_AUTODIFF_LABEL"];
		info.func = function() TitanSetVar(TITAN_LOOTTYPE_ID, "DungeonDiffType", "AUTO"); TitanPanelButton_UpdateButton(TITAN_LOOTTYPE_ID) end
		info.checked = function() if TitanGetVar(TITAN_LOOTTYPE_ID, "DungeonDiffType") == "AUTO" then return true end return false end
		UIDropDownMenu_AddButton(info,_G["UIDROPDOWNMENU_MENU_LEVEL"]);
	elseif _G["UIDROPDOWNMENU_MENU_LEVEL"] == 2 and _G["UIDROPDOWNMENU_MENU_VALUE"] == "SetDungeonDiff" then
		info = {};
		info.text = _G["GREEN_FONT_COLOR_CODE"].._G["DUNGEON_DIFFICULTY1"].."|r";
		info.func = function() SetDungeonDifficultyID(1) end
		info.checked = function() if GetDungeonDifficultyID() == 1 then return true end return false end
		local inParty = false;
		if (UnitExists("party1") or GetNumGroupMembers() > 0) then
			inParty = true;
		end
		local isLeader = false;
		if (UnitIsGroupLeader("player")) then
			isLeader = true;
		end
		local inInstance = IsInInstance()
		local playerlevel = UnitLevel("player")
		if inInstance or (inParty == 1 and isLeader == 0) or (playerlevel < 90 and GetDungeonDifficultyID() == 1) then
			info.disabled = true
		else
			info.disabled = false
		end
		UIDropDownMenu_AddButton(info,_G["UIDROPDOWNMENU_MENU_LEVEL"]);

		info = {}
		info.text = _G["RED_FONT_COLOR_CODE"].._G["DUNGEON_DIFFICULTY2"].."|r";
		info.func = function() SetDungeonDifficultyID(2) end
		info.checked = function() if GetDungeonDifficultyID() == 2 then return true end return false end
		local inParty = false;
		if (UnitExists("party1") or GetNumGroupMembers() > 0) then
			inParty = true;
		end
		local isLeader = false;
		if (UnitIsGroupLeader("player")) then
			isLeader = true;
		end
		local inInstance = IsInInstance()
		local playerlevel = UnitLevel("player")
		if inInstance or (inParty == 1 and isLeader == 0) or (playerlevel < 100 and GetDungeonDifficultyID() == 2) then
			info.disabled = true
		else
			info.disabled = false
		end
		UIDropDownMenu_AddButton(info,_G["UIDROPDOWNMENU_MENU_LEVEL"]);

		info = {}
		info.text = _G["RED_FONT_COLOR_CODE"].._G["DUNGEON_DIFFICULTY3"].."|r";
		info.func = function() SetDungeonDifficultyID(8) end
		info.checked = function() if GetDungeonDifficultyID() == 2 then return true end return false end
		local inParty = false;
		if (UnitExists("party1") or GetNumGroupMembers() > 0) then
			inParty = true;
		end
		local isLeader = false;
		if (UnitIsGroupLeader("player")) then
			isLeader = true;
		end
		local inInstance = IsInInstance()
		local playerlevel = UnitLevel("player")
		if inInstance or (inParty == 1 and isLeader == 0) or (playerlevel < 100 and GetDungeonDifficultyID() == 8) then
			info.disabled = true
		else
			info.disabled = false
		end
		UIDropDownMenu_AddButton(info,_G["UIDROPDOWNMENU_MENU_LEVEL"]);

	elseif _G["UIDROPDOWNMENU_MENU_LEVEL"] == 2  and _G["UIDROPDOWNMENU_MENU_VALUE"] == "SetRaidDiff" then
		info = {};
		info.text = _G["GREEN_FONT_COLOR_CODE"].._G["RAID_DIFFICULTY1"].."|r";
		info.func = function() SetRaidDifficultyID(1) end
		info.checked = function() if GetRaidDifficultyID() == 1 then return true end return false end
		local inParty = 0;
		if (UnitExists("party1") or GetNumGroupMembers() > 0) then
			inParty = 1;
		end
		local isLeader = 0;
		if (UnitIsGroupLeader("player")) then
			isLeader = 1;
		end
		local inInstance = IsInInstance()
		local playerlevel = UnitLevel("player")
		if inInstance or (inParty == 1 and isLeader == 0) or (playerlevel < 65 and GetRaidDifficultyID() == 1) then
			info.disabled = 1
		else
			info.disabled = false
		end
		UIDropDownMenu_AddButton(info,_G["UIDROPDOWNMENU_MENU_LEVEL"]);

		info = {};
		info.text = _G["GREEN_FONT_COLOR_CODE"].._G["RAID_DIFFICULTY2"].."|r";
		info.func = function() SetRaidDifficultyID(2) end
		info.checked = function() if GetRaidDifficultyID() == 2 then return true end return false end
		local inParty = 0;
		if (UnitExists("party1") or GetNumGroupMembers() > 0) then
			inParty = 1;
		end
		local isLeader = 0;
		if (UnitIsGroupLeader("player")) then
			isLeader = 1;
		end
		local inInstance = IsInInstance()
		local playerlevel = UnitLevel("player")
		if inInstance or (inParty == 1 and isLeader == 0) or (playerlevel < 65 and GetRaidDifficultyID() == 1) then
			info.disabled = 1
		else
			info.disabled = false
		end
		UIDropDownMenu_AddButton(info,_G["UIDROPDOWNMENU_MENU_LEVEL"]);

		info = {};
		info.text = _G["RED_FONT_COLOR_CODE"].._G["RAID_DIFFICULTY3"].."|r";
		info.func = function() SetRaidDifficultyID(3) end
		info.checked = function() if GetRaidDifficultyID() == 3 then return true end return false end
		local inParty = 0;
		if (UnitExists("party1") or GetNumGroupMembers() > 0) then
			inParty = 1;
		end
		local isLeader = 0;
		if (UnitIsGroupLeader("player")) then
			isLeader = 1;
		end
		local inInstance = IsInInstance()
		local playerlevel = UnitLevel("player")
		if inInstance or (inParty == 1 and isLeader == 0) or (playerlevel < 65 and GetRaidDifficultyID() == 1) then
			info.disabled = 1
		else
			info.disabled = false
		end
		UIDropDownMenu_AddButton(info,_G["UIDROPDOWNMENU_MENU_LEVEL"]);

		info = {};
		info.text = _G["RED_FONT_COLOR_CODE"].._G["RAID_DIFFICULTY4"].."|r";
		info.func = function() SetRaidDifficultyID(4) end
		info.checked = function() if GetRaidDifficultyID() == 4 then return true end return false end
		local inParty = 0;
		if (UnitExists("party1") or GetNumGroupMembers() > 0) then
			inParty = 1;
		end
		local isLeader = 0;
		if (UnitIsGroupLeader("player")) then
			isLeader = 1;
		end
		local inInstance = IsInInstance()
		local playerlevel = UnitLevel("player")
		if inInstance or (inParty == 1 and isLeader == 0) or (playerlevel < 65 and GetRaidDifficultyID() == 1) then
			info.disabled = 1
		else
			info.disabled = false
		end
		UIDropDownMenu_AddButton(info,_G["UIDROPDOWNMENU_MENU_LEVEL"]);

	else
		TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_LOOTTYPE_ID].menuText);
		info = {};
		info.notCheckable = true
		info.text = L["TITAN_LOOTTYPE_SHOWDUNGEONDIFF_LABEL"]
		info.value = "ShowDungeonDiffMenu"
		info.func = function() TitanPanelRightClickMenu_ToggleVar({TITAN_LOOTTYPE_ID, "ShowDungeonDiff"}) end
		info.checked = TitanGetVar(TITAN_LOOTTYPE_ID, "ShowDungeonDiff");
		info.keepShownOnClick = 1;
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info);
		info = {}
		info.notCheckable = true
		info.text = L["TITAN_LOOTTYPE_SETDUNGEONDIFF_LABEL"];
		info.value = "SetDungeonDiff";
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info);
		info = {}
		info.notCheckable = true
		info.text = L["TITAN_LOOTTYPE_SETRAIDDIFF_LABEL"];
		info.value = "SetRaidDiff";
		info.hasArrow = 1;     
		UIDropDownMenu_AddButton(info);     
		info = {};
		info.notCheckable = true
		info.text = L["TITAN_LOOTTYPE_RANDOM_ROLL_LABEL"];
		info.value = "RandomRoll";
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info);
		TitanPanelRightClickMenu_AddSpacer();
		TitanPanelRightClickMenu_AddToggleIcon(TITAN_LOOTTYPE_ID);
		TitanPanelRightClickMenu_AddToggleLabelText(TITAN_LOOTTYPE_ID);

		TitanPanelRightClickMenu_AddSpacer();
		TitanPanelRightClickMenu_AddCommand(L["TITAN_PANEL_MENU_HIDE"], TITAN_LOOTTYPE_ID, TITAN_PANEL_MENU_FUNC_HIDE);
	end
end

-- **************************************************************************
-- NAME : TitanPanelBagButton_OnClick(button)
-- DESC : Generate random roll on leftclick of button
-- **************************************************************************
function TitanPanelLootTypeButton_OnClick(self, button)
	if button == "LeftButton" then
		RandomRoll(1, TitanGetVar(TITAN_LOOTTYPE_ID, "RandomRoll"));
	end
end
