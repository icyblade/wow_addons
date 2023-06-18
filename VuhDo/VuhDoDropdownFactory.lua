local _;
VUHDO_MM_SETTINGS = { };
local VUHDO_MENU_UNIT = nil;



--
function VUHDO_playerTargetDropdownOnLoad()
	UIDropDownMenu_Initialize(VuhDoPlayerTargetDropDown, VUHDO_playerTargetDropDown_Initialize, "MENU", 1);
end



--
function VUHDO_setMenuUnit(aButton)
	VUHDO_MENU_UNIT = aButton:GetAttribute("unit");
end



--
local function VUHDO_ptBuffSelected(_, aName, aCategName)
	VUHDO_Msg(VUHDO_I18N_BUFF_ASSIGN_1 .. aCategName .. VUHDO_I18N_BUFF_ASSIGN_2 .. aName .. VUHDO_I18N_BUFF_ASSIGN_3);
	VUHDO_BUFF_SETTINGS[aCategName].name = aName;
	VUHDO_reloadBuffPanel();
end



--
local function VUHDO_roleOverrideSelected(_, aModelId, aName)
	VUHDO_MANUAL_ROLES[aName] = aModelId;
	VUHDO_reloadUI(false);
end



--
local function VUHDO_disableMenu(anInfo, aCondition)
	anInfo["disabled"] = aCondition;
	anInfo["colorCode"] = aCondition and "|cff808080" or "|cffffffff";
end



--
local function VUHDO_playerTargetAddTitle(aTitleText)
	local tInfo = UIDropDownMenu_CreateInfo();
	tInfo["text"] = aTitleText or "";
	tInfo["isTitle"] = true;
	tInfo["notCheckable"] = true;
	UIDropDownMenu_AddButton(tInfo);
end



--
local function VUHDO_playerTargetAddSetting(aText, anIsChecked, anArg1, anArg2, aFunction, anIsNotCheckable, anIsDisable, aColorCode)
	local tInfo = UIDropDownMenu_CreateInfo();
	tInfo["text"] = aText;
	tInfo["checked"] = anIsChecked;
	tInfo["arg1"] = anArg1;
	tInfo["arg2"] = anArg2;
	tInfo["func"] = aFunction;
	tInfo["notCheckable"] = anIsNotCheckable;
	tInfo["colorCode"] = aColorCode;
	VUHDO_disableMenu(tInfo, anIsDisable);
	UIDropDownMenu_AddButton(tInfo);
end



--
local function VUHDO_privateTanksItemSelected(_, aUnit)
	local tName = VUHDO_RAID[aUnit]["name"];
	if VUHDO_PLAYER_TARGETS[tName] then
		VUHDO_PLAYER_TARGETS[tName] = nil;
	else
		VUHDO_PLAYER_TARGETS[tName] = true;
	end

	-- Reload private tanks group
	VUHDO_quickRaidReload();
end



--
local function VUHDO_unitRoleItemSelected(_, aCommand, aUnit)
	if "LEAD" == aCommand then
		PromoteToLeader(aUnit);
	elseif "+A" == aCommand then
		PromoteToAssistant(aUnit);
		VUHDO_Msg(VUHDO_I18N_PROMOTE_ASSIST_MSG_1 .. UnitName(aUnit) .. VUHDO_I18N_PROMOTE_ASSIST_MSG_2);
	elseif "-A" == aCommand then
		DemoteAssistant(aUnit);
		VUHDO_Msg(VUHDO_I18N_DEMOTE_ASSIST_MSG_1 .. UnitName(aUnit) .. VUHDO_I18N_DEMOTE_ASSIST_MSG_2);
	elseif "ML" == aCommand then
		SetLootMethod("master", UnitName(aUnit));
	end
end



--
local function VUHDO_mainTankItemSelected(_, aMtPos, aUnit)
	local tName = VUHDO_RAID[aUnit]["name"];

	-- remove Maintankt?
	if VUHDO_MAINTANK_NAMES[aMtPos] == tName then
		VUHDO_sendCtraMessage("R " .. tName);
	else
		if VUHDO_MAINTANK_NAMES[aMtPos] then
			VUHDO_sendCtraMessage("R " .. VUHDO_MAINTANK_NAMES[aMtPos]);
		end

		VUHDO_sendCtraMessage("SET " .. aMtPos .. " " .. tName);
	end

	VUHDO_reloadUI(false);
end



--
function VUHDO_playerTargetDropDown_Initialize(aFrame, aLevel)
	local tInfo;

	if not VUHDO_MENU_UNIT or not VUHDO_RAID[VUHDO_MENU_UNIT] then
		return;
	end

	local tName = VUHDO_RAID[VUHDO_MENU_UNIT]["name"];
	local tUniqueBuffs, _ = VUHDO_getAllUniqueSpells();

	if aLevel > 1 then
		for _, tBuffName in pairs(tUniqueBuffs) do
			local tCategory = VUHDO_getBuffCategoryName(tBuffName, VUHDO_BUFF_TARGET_UNIQUE);
			tInfo = UIDropDownMenu_CreateInfo();
			tInfo["text"] = tBuffName;
			tInfo["arg1"] = tName;
			tInfo["arg2"] = tCategory;
			tInfo["icon"] = VUHDO_BUFFS[tBuffName]["icon"];
			tInfo["func"] = VUHDO_ptBuffSelected;
			tInfo["checked"] = VUHDO_BUFF_SETTINGS[tCategory]["name"] == tName;
			tInfo["level"] = 2;
			UIDropDownMenu_AddButton(tInfo, 2);
		end

		return;
	end

	VUHDO_playerTargetAddTitle(VUHDO_I18N_ROLE .. " (" .. tName .. ")");
	VUHDO_playerTargetAddTitle();

	local tUnitRank, tUnitIsMl = VUHDO_getUnitRank(VUHDO_MENU_UNIT);
	local tPlayerRank, tPlayerIsMl = VUHDO_getPlayerRank();

	-- Raid leader
	VUHDO_playerTargetAddSetting(VUHDO_I18N_PROMOTE_RAID_LEADER, tUnitRank == 2, "LEAD", VUHDO_MENU_UNIT,
		VUHDO_unitRoleItemSelected, true, tPlayerRank < 2);

	if tUnitRank == 0 then
		-- + assist
		VUHDO_playerTargetAddSetting(VUHDO_I18N_PROMOTE_ASSISTANT, false, "+A", VUHDO_MENU_UNIT,
			VUHDO_unitRoleItemSelected, true, tPlayerRank < 2);
	end

	if tUnitRank == 1 then
		-- - assist
		VUHDO_playerTargetAddSetting(VUHDO_I18N_DEMOTE_ASSISTANT, false, "-A", VUHDO_MENU_UNIT,
			VUHDO_unitRoleItemSelected, true, tPlayerRank < 2);
	end

	-- Master looter
	VUHDO_playerTargetAddSetting(VUHDO_I18N_PROMOTE_MASTER_LOOTER, tUnitIsMl, "ML", VUHDO_MENU_UNIT,
		VUHDO_unitRoleItemSelected, true, tPlayerRank < 2 and not tPlayerIsMl);

	-- Private Tanks
	VUHDO_playerTargetAddTitle();

	local tIsChecked = false;
	if VUHDO_MENU_UNIT and VUHDO_RAID[VUHDO_MENU_UNIT] ~= nil then
		tIsChecked = VUHDO_PLAYER_TARGETS[tName] ~= nil;
	end

	VUHDO_playerTargetAddSetting(VUHDO_I18N_PRIVATE_TANK, tIsChecked, VUHDO_MENU_UNIT, nil,
		VUHDO_privateTanksItemSelected, false, false);

	VUHDO_playerTargetAddTitle();

	-- Main Tanks
	for tCnt = 1, 8 do -- VUHDO_MAX_MTS
		local tText, tColor;

		if VUHDO_MAINTANK_NAMES[tCnt] == tName then
			tText = VUHDO_I18N_MT_NUMBER .. tCnt .. " (" .. VUHDO_MAINTANK_NAMES[tCnt] .. ")";
			tColor = "|cffffe466";
		elseif not VUHDO_MAINTANK_NAMES[tCnt] then
			tText = VUHDO_I18N_MT_NUMBER .. tCnt;
			tColor = "|cffcccccc";
		else
			tText = VUHDO_I18N_MT_NUMBER .. tCnt .. " (" .. VUHDO_MAINTANK_NAMES[tCnt] .. ")";
			tColor = "|cffffb233";
		end

		VUHDO_playerTargetAddSetting(tText, VUHDO_MAINTANK_NAMES[tCnt] == tName, tCnt, VUHDO_MENU_UNIT,
			VUHDO_mainTankItemSelected, false, VUHDO_getPlayerRank() < 1, tColor);
	end

	-- Unique Spells
	if #tUniqueBuffs > 0 then
		VUHDO_playerTargetAddTitle();

		tInfo = UIDropDownMenu_CreateInfo();
		tInfo["text"] = VUHDO_I18N_SET_BUFF;
		tInfo["hasArrow"] = true;
		tInfo["disabled"] = false;
		tInfo["notCheckable"] = true;
		UIDropDownMenu_AddButton(tInfo);
	end

	-- Role override
	VUHDO_playerTargetAddTitle();
	VUHDO_playerTargetAddTitle(VUHDO_I18N_ROLE_OVERRIDE);

	VUHDO_playerTargetAddSetting(VUHDO_I18N_MELEE_TANK, VUHDO_MANUAL_ROLES[tName] == VUHDO_ID_MELEE_TANK, VUHDO_ID_MELEE_TANK, tName,
		VUHDO_roleOverrideSelected, false, false, nil);

	VUHDO_playerTargetAddSetting(VUHDO_I18N_MELEE_DPS, VUHDO_MANUAL_ROLES[tName] == VUHDO_ID_MELEE_DAMAGE, VUHDO_ID_MELEE_DAMAGE, tName,
		VUHDO_roleOverrideSelected, false, false, nil);

	VUHDO_playerTargetAddSetting(VUHDO_I18N_RANGED_DPS, VUHDO_MANUAL_ROLES[tName] == VUHDO_ID_RANGED_DAMAGE, VUHDO_ID_RANGED_DAMAGE, tName,
		VUHDO_roleOverrideSelected, false, false, nil);

	VUHDO_playerTargetAddSetting(VUHDO_I18N_RANGED_HEALERS, VUHDO_MANUAL_ROLES[tName] == VUHDO_ID_RANGED_HEAL, VUHDO_ID_RANGED_HEAL, tName,
		VUHDO_roleOverrideSelected, false, false, nil);

	VUHDO_playerTargetAddSetting(VUHDO_I18N_AUTO_DETECT, VUHDO_MANUAL_ROLES[tName] == nil, nil, tName,
		VUHDO_roleOverrideSelected, false, false, nil);
end



--
function VUHDO_minimapDropdownOnLoad()
	UIDropDownMenu_Initialize(VuhDoMinimapDropDown, VUHDO_miniMapDropDown_Initialize, "MENU", 1);
end



--
local function VUHDO_createMinimapToggle(aName, anArg1, anIsChecked)
	local tInfo = UIDropDownMenu_CreateInfo();
	tInfo["text"] = aName;
	tInfo["keepShownOnClick"] = true;
	tInfo["arg1"] = anArg1;
	tInfo["func"] = VUHDO_minimapItemSelected;
	tInfo["checked"] = anIsChecked;
	UIDropDownMenu_AddButton(tInfo);
end



--
local function VUHDO_createEmptyLine()
	local tInfo = UIDropDownMenu_CreateInfo();
	tInfo["text"] = "";
	tInfo["isTitle"] = true;
	tInfo["notCheckable"] = true;
	UIDropDownMenu_AddButton(tInfo);
end



--
function VUHDO_miniMapDropDown_Initialize(aFrame, aLevel)
	if not VUHDO_CONFIG then return; end

	local tInfo;

	if aLevel > 1 then
		if "S" == UIDROPDOWNMENU_MENU_VALUE then
			for _, tSetup in ipairs(VUHDO_PROFILES) do
				tInfo = UIDropDownMenu_CreateInfo();
				tInfo["text"] = tSetup["NAME"];
				tInfo["arg1"] = tSetup["NAME"];
				tInfo["func"] = function(_, aName) VUHDO_loadProfile(aName) end;
				tInfo["checked"] = tSetup["NAME"] == VUHDO_CONFIG["CURRENT_PROFILE"];
				tInfo["level"] = 2;
				UIDropDownMenu_AddButton(tInfo, 2);
			end
		elseif "K" == UIDROPDOWNMENU_MENU_VALUE then
			for tName, _ in pairs(VUHDO_SPELL_LAYOUTS) do
				tInfo = UIDropDownMenu_CreateInfo();
				tInfo["text"] = tName;
				tInfo["arg1"] = tName;
				tInfo["func"] = function(_, aName) VUHDO_activateLayout(aName) end;
				tInfo["checked"] = tName == VUHDO_SPEC_LAYOUTS["selected"];
				tInfo["level"] = 2;
				UIDropDownMenu_AddButton(tInfo, 2);
			end
		end
		return;
	end

	tInfo = UIDropDownMenu_CreateInfo();
	tInfo["text"] = VUHDO_I18N_VUHDO_OPTIONS;
	tInfo["isTitle"] = true;
	tInfo["notCheckable"] = true;
	UIDropDownMenu_AddButton(tInfo);

	tInfo = UIDropDownMenu_CreateInfo();
	tInfo["text"] = VUHDO_I18N_PANEL_SETUP;
	tInfo["func"] = VUHDO_minimapItemSelected;
	tInfo["arg1"] = "1";
	tInfo["notCheckable"] = true;
	UIDropDownMenu_AddButton(tInfo);

	VUHDO_createEmptyLine();

	tInfo = UIDropDownMenu_CreateInfo();
	tInfo["text"] = VUHDO_I18N_BROADCAST_MTS;
	tInfo["func"] = VUHDO_minimapItemSelected;
	tInfo["arg1"] = "BROAD";
	tInfo["notClickable"] = VUHDO_getPlayerRank() < 1;
	tInfo["notCheckable"] = true;
	UIDropDownMenu_AddButton(tInfo);

	tInfo = UIDropDownMenu_CreateInfo();
	tInfo["text"] = VUHDO_I18N_RESET_ROLES;
	tInfo["func"] = VUHDO_minimapItemSelected;
	tInfo["arg1"] = "ROLES";
	tInfo["notCheckable"] = true;
	UIDropDownMenu_AddButton(tInfo);

	VUHDO_createEmptyLine();

	tInfo = UIDropDownMenu_CreateInfo();
	tInfo["text"] = VUHDO_I18N_LOAD_PROFILE;
	tInfo["hasArrow"] = true;
	tInfo["value"] = "S";
	tInfo["notCheckable"] = true;
	UIDropDownMenu_AddButton(tInfo);

	tInfo = UIDropDownMenu_CreateInfo();
	tInfo["text"] = VUHDO_I18N_LOAD_KEY_SETUP;
	tInfo["hasArrow"] = true;
	tInfo["value"] = "K";
	tInfo["notCheckable"] = true;
	UIDropDownMenu_AddButton(tInfo);

	VUHDO_createEmptyLine();

	tInfo = UIDropDownMenu_CreateInfo();
	tInfo["text"] = VUHDO_I18N_TOGGLES;
	tInfo["isTitle"] = true;
	tInfo["notCheckable"] = true;
	UIDropDownMenu_AddButton(tInfo);

	VUHDO_createMinimapToggle(VUHDO_I18N_LOCK_PANELS, "LOCK", VUHDO_CONFIG["LOCK_PANELS"]);
	VUHDO_createMinimapToggle(VUHDO_I18N_SHOW_PANELS, "SHOW", VUHDO_CONFIG["SHOW_PANELS"]);
	VUHDO_createMinimapToggle(VUHDO_I18N_SHOW_BUFF_WATCH, "BUFF", VUHDO_BUFF_SETTINGS["CONFIG"]["SHOW"]);
	VUHDO_createMinimapToggle(VUHDO_I18N_MM_BUTTON, "MINIMAP", VUHDO_CONFIG["SHOW_MINIMAP"]);

	VUHDO_createEmptyLine();

	tInfo = UIDropDownMenu_CreateInfo();
	tInfo["text"] = VUHDO_I18N_CLOSE;
	tInfo["notCheckable"] = true;
	UIDropDownMenu_AddButton(tInfo);
end



--
function VUHDO_minimapItemSelected(_, anId)
	local tCmd;
	if "LOCK" == anId then tCmd = "lock";
	elseif "MINIMAP" == anId then tCmd = "minimap";
	elseif "SHOW" == anId then tCmd = "toggle";
	elseif "BROAD" == anId then tCmd = "cast";
	elseif "1" == anId then tCmd = "opt";
	elseif "BUFF" == anId then
		VUHDO_BUFF_SETTINGS["CONFIG"]["SHOW"] = not VUHDO_BUFF_SETTINGS["CONFIG"]["SHOW"];
		VUHDO_reloadBuffPanel();
		VUHDO_saveCurrentProfile();
		return;
	elseif "ROLES" == anId then
		table.wipe(VUHDO_MANUAL_ROLES);
		VUHDO_reloadUI(false);
		return;
	end

	VUHDO_slashCmd(tCmd);
end



--
function VUHDO_initMinimap()
	VuhDoMinimap:Create(VUHDO_MM_SETTINGS, VUHDO_MM_LAYOUT);
	VUHDO_initShowMinimap();
end



--
function VUHDO_initShowMinimap()
	VuhDoMinimapButton:SetShown(VUHDO_CONFIG["SHOW_MINIMAP"]);
end
