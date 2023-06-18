local _;
local _G = _G;

local VUHDO_BUFF_RAID = { };
local VUHDO_BUFF_RAID_FILTERED = { };

local VUHDO_PLAYER_GROUP = { "player" };

local VUHDO_BS_COLOR_EMPTY = 1;
local VUHDO_BS_COLOR_CD = 2;
local VUHDO_BS_COLOR_LOW = 3;
local VUHDO_BS_COLOR_MISSING = 4;
local VUHDO_BS_COLOR_OKAY = 5;


local VUHDO_NUM_LOWS = { };

local VUHDO_LAST_COLORS = { };

--
VUHDO_BUFFS = { };
local VUHDO_BUFFS = VUHDO_BUFFS;
VUHDO_BUFF_SETTINGS = { };
--local VUHDO_BUFF_SETTINGS = VUHDO_BUFF_SETTINGS;

local VUHDO_CLICKED_BUFF = nil;
local VUHDO_CLICKED_TARGET = nil;
local VUHDO_IS_USED_SMART_BUFF;

VUHDO_BUFF_ORDER = { };
local sEmpty = { };
local sCooldownAliases = { };




-- BURST CACHE ---------------------------------------------------

local VUHDO_RAID;
local VUHDO_RAID_NAMES;

local VUHDO_tableUniqueAdd;
local VUHDO_isInSameZone;
local VUHDO_isInBattleground;
local VUHDO_brightenTextColor;
local VUHDO_isConfigDemoUsers;

local UnitBuff = UnitBuff;
local GetTotemInfo = GetTotemInfo;
local table = table;
local strsub = strsub;
local GetTime = GetTime;
local GetSpellCooldown = GetSpellCooldown;
local GetSpellBookItemName = GetSpellBookItemName;
local GetSpellInfo = GetSpellInfo;
local InCombatLockdown = InCombatLockdown;
local GetWeaponEnchantInfo = GetWeaponEnchantInfo;
local UnitOnTaxi = UnitOnTaxi;
local IsSpellInRange = IsSpellInRange;
local GetShapeshiftFormInfo = GetShapeshiftFormInfo;

local tonumber = tonumber;
local pairs = pairs;
local ipairs = ipairs;
local twipe = table.wipe;
local format = format;

local sConfig = { };
local sRebuffSecs;
local sRebuffPerc;
local sGermanOrEnglish = GetLocale() == "deDE" or GetLocale() == "enGB" or GetLocale() == "enUS";

-----------------------------------------------------------------------------
function VUHDO_buffWatchInitLocalOverrides()
	VUHDO_RAID = _G["VUHDO_RAID"];
	VUHDO_RAID_NAMES = _G["VUHDO_RAID_NAMES"];

	VUHDO_tableUniqueAdd = _G["VUHDO_tableUniqueAdd"];
	VUHDO_isInSameZone = _G["VUHDO_isInSameZone"];
	VUHDO_isInBattleground = _G["VUHDO_isInBattleground"];
	VUHDO_brightenTextColor = _G["VUHDO_brightenTextColor"];
	VUHDO_isConfigDemoUsers = _G["VUHDO_isConfigDemoUsers"];

	sConfig = VUHDO_BUFF_SETTINGS["CONFIG"];
	sRebuffSecs = sConfig["REBUFF_MIN_MINUTES"] * 60;
	sRebuffPerc = sConfig["REBUFF_AT_PERCENT"] * 0.01;
end

----------------------------------------------------



--
function VUHDO_buffWatchOnMouseDown(aPanel)
	if VUHDO_mayMoveHealPanels() then aPanel:StartMoving(); end
end



--
function VUHDO_buffWatchOnMouseUp(aPanel)
	if VUHDO_mayMoveHealPanels() then
		aPanel:StopMovingOrSizing();

		local tCoords = VUHDO_BUFF_SETTINGS["CONFIG"]["POSITION"];
		tCoords["point"], _, tCoords["relativePoint"], tCoords["x"], tCoords["y"] = aPanel:GetPoint();
	end
end



--
local tCopy = { };
local function VUHDO_copyColor(aColor)
	tCopy["R"], tCopy["G"], tCopy["B"], tCopy["O"] = aColor["R"], aColor["G"], aColor["B"], aColor["O"];
	tCopy["TR"], tCopy["TG"], tCopy["TB"], tCopy["TO"] = aColor["TR"], aColor["TG"], aColor["TB"], aColor["TO"];
	tCopy["useBackground"], tCopy["useText"], tCopy["useOpacity"] = aColor["useBackground"], aColor["useText"], aColor["useOpacity"];
	return tCopy;
end



--
function VUHDO_isUseSingleBuff(aSwatch)
	if VUHDO_BUFF_TARGET_SINGLE ~= aSwatch:GetAttribute("buff")[2] then	return false;
	elseif aSwatch:GetAttribute("lowtarget") == nil or InCombatLockdown() then return 2;
	else return true; end
end



local function VUHDO_getWeaponEnchantMacroText(anEnchantName, aTargetType)
	return format("/use [@none] %s\n/use %d\n/click StaticPopup1Button1",
		anEnchantName, VUHDO_BUFF_TARGET_ENCHANT == aTargetType and 16 or 17);
end



--
local function VUHDO_setupBuffButtonAttributes(aModifierKey, aButtonId, anActionName, aButton, aTargetType)
	if not VUHDO_strempty(anActionName) then
		if VUHDO_BUFF_TARGET_ENCHANT == aTargetType or VUHDO_BUFF_TARGET_ENCHANT_OFF == aTargetType then
			aButton:SetAttribute(aModifierKey .. "type" .. aButtonId, "macro");
			aButton:SetAttribute(aModifierKey .. "macrotext" .. aButtonId, VUHDO_getWeaponEnchantMacroText(anActionName, aTargetType));
		else
			aButton:SetAttribute(aModifierKey .. "type" .. aButtonId, "spell");
			aButton:SetAttribute(aModifierKey .. "spell" .. aButtonId, anActionName);
		end
	else
		aButton:SetAttribute(aModifierKey .. "type" .. aButtonId, "");
	end
end



--
function VUHDO_setupAllBuffButtonUnits(aButton, aUnit)
	if not InCombatLockdown() then
		aButton:SetAttribute("unit", aUnit or "_foo");
	end
end



--
--local tModiKey, tButtonId;
function VUHDO_setupAllBuffButtonsTo(aButton, aBuffName, aUnit, aTargetType)
	if InCombatLockdown() then return; end

	VUHDO_setupAllBuffButtonUnits(aButton, aUnit);
	for _, tWithMinus in pairs(VUHDO_MODIFIER_KEYS) do
		for tCnt = 1, VUHDO_NUM_MOUSE_BUTTONS do
			VUHDO_setupBuffButtonAttributes(tWithMinus, tCnt, tCnt ~= 2 and aBuffName or nil, aButton, aTargetType);
		end
	end
end



--
function VUHDO_buffSelectDropdownOnLoad()
	UIDropDownMenu_Initialize(VuhDoBuffSelectDropdown, VUHDO_buffSelectDropdown_Initialize, "MENU", 1);
end



--
function VUHDO_buffSelectDropdown_Initialize(_, _)
	if VUHDO_CLICKED_BUFF == nil or VUHDO_CLICKED_TARGET == nil or InCombatLockdown() then
		return;
	end

	local tCategName = VUHDO_getBuffCategoryName(VUHDO_CLICKED_BUFF[1], VUHDO_CLICKED_BUFF[2]);
	local tCateg = VUHDO_getPlayerClassBuffs()[tCategName];
	local tSettings = VUHDO_BUFF_SETTINGS[tCategName];
	local tTargetType = tCateg[1][2];

	if #tCateg > 1 then
		local tInfo;

		for _, tCategBuff in ipairs(tCateg) do
			local tBuffName = tCategBuff[1];

			if VUHDO_BUFFS[tBuffName] then
				tInfo = UIDropDownMenu_CreateInfo();
				tInfo["text"] = tBuffName;
				tInfo["keepShownOnClick"] = false;
				tInfo["icon"] = VUHDO_BUFFS[tBuffName]["icon"];
				tInfo["arg1"] = tCategName;
				tInfo["func"] = VUHDO_buffSelectDropdownBuffSelected;
				tInfo["arg2"] = tBuffName;

				tInfo["checked"] = tSettings["buff"] == tBuffName;
				UIDropDownMenu_AddButton(tInfo);
			end

		end

	elseif VUHDO_BUFF_TARGET_RAID == tTargetType or VUHDO_BUFF_TARGET_SINGLE == tTargetType then
		local tInfo;
		local tText;
		tInfo = UIDropDownMenu_CreateInfo();
		tInfo["text"] = VUHDO_I18N_TRACK_BUFFS_FOR;
		tInfo["isTitle"] = true;
		tInfo["notCheckable"] = true;
		UIDropDownMenu_AddButton(tInfo);

		for _, tFilter in pairs(VUHDO_BUFF_FILTER_COMBO_TABLE) do
			tInfo = UIDropDownMenu_CreateInfo();
			tText = tFilter[2];
			tInfo["text"] = tText;
			tInfo["checked"] = VUHDO_BUFF_SETTINGS[tCategName]["filter"][tFilter[1]];
			tInfo["arg1"] = tCategName;
			tInfo["arg2"] = tFilter[1];
			tInfo["func"] = VUHDO_buffSelectDropdownFilterSelected;
			tInfo["isTitle"] = false;
			tInfo["disabled"] = false;

			UIDropDownMenu_AddButton(tInfo);
		end

	else
		VuhDoBuffSelectDropdown:Hide();

		local tTargetType = strsub(VUHDO_CLICKED_TARGET, 1, 1);
		if tTargetType == "N" then
			local tSelName = nil;
			local tNextSel = false;
			if VUHDO_RAID_NAMES[tSettings["name"]] then
				for tName, _ in pairs(VUHDO_RAID_NAMES) do
					if tName ~= "player" then
						if tSelName == nil or tNextSel then
							tSelName = tName;
							if tNextSel then break; end
						end
						if tName == tSettings["name"] then tNextSel = true; end
					end
				end

				tSettings["name"] = tSelName;
				VUHDO_reloadBuffPanel();
			else
				tSettings["name"] = VUHDO_PLAYER_NAME;
			end
		end
	end

end



--
function VUHDO_buffSelectDropdownBuffSelected(_, aCategoryName, aBuffName)
	if aCategoryName then
		VUHDO_BUFF_SETTINGS[aCategoryName]["buff"] = aBuffName;
		VUHDO_reloadBuffPanel();
	end
end



--
function VUHDO_buffSelectDropdownFilterSelected(_, aCategName, aFilterValue)
	if aCategName then
		local tAllFilters = VUHDO_BUFF_SETTINGS[aCategName]["filter"];
		if VUHDO_ID_ALL == aFilterValue then
			twipe(tAllFilters);
			tAllFilters[VUHDO_ID_ALL] = true;
		else
			if tAllFilters[aFilterValue] then tAllFilters[aFilterValue] = nil;
			else tAllFilters[aFilterValue] = true; end

			tAllFilters[VUHDO_ID_ALL] = nil;
		end

		VUHDO_updateBuffFilters();
	end
end



--
function VuhDoBuffPreClick(aButton, aMouseButton)
	local tSwatch = aButton:GetParent();
	local tVariant = tSwatch:GetAttribute("buff");

	if "RightButton" == aMouseButton then
		VUHDO_CLICKED_BUFF = tVariant;
		VUHDO_CLICKED_TARGET = tSwatch:GetAttribute("target");
		ToggleDropDownMenu(1, nil, VuhDoBuffSelectDropdown, aButton:GetName(), 0, -5);
	end

	VUHDO_IS_USED_SMART_BUFF = VUHDO_isUseSingleBuff(tSwatch);
	local tBuff = tVariant[1];

	if 2 == VUHDO_IS_USED_SMART_BUFF and aMouseButton == "LeftButton" then
		UIErrorsFrame:AddMessage(VUHDO_I18N_SMARTBUFF_ERR_2 .. tBuff, 1, 0.1, 0.1, 1);
		VUHDO_setupAllBuffButtonsTo(aButton, "", "", nil);
		return;
	end

	local tTarget = VUHDO_IS_USED_SMART_BUFF
		and tSwatch:GetAttribute("lowtarget") or tSwatch:GetAttribute("goodtarget");

	VUHDO_setupAllBuffButtonsTo(aButton, tBuff, tTarget, tVariant[2]);

	if not tTarget and aMouseButton ~= "RightButton" then
		UIErrorsFrame:AddMessage(VUHDO_I18N_SMARTBUFF_ERR_2 .. tBuff, 1, 0.1, 0.1, 1);
	end
end



--
function VuhDoBuffPostClick(aButton, aMouseButton)
	if VUHDO_IS_USED_SMART_BUFF then
		local tVariant = aButton:GetParent():GetAttribute("buff");
		VUHDO_setupAllBuffButtonsTo(aButton, tVariant[1], aButton:GetParent():GetAttribute("goodtarget"), tVariant[2]);
	end
end



--
function VUHDO_getAllUniqueSpells()
	local tUniqueBuffs = { };
	local tUniqueCategs = { };

	for tCategName, tCategBuffs in pairs(VUHDO_getPlayerClassBuffs()) do
		local tSpellName = tCategBuffs[1][1];
		if VUHDO_BUFFS[tSpellName] and VUHDO_BUFF_TARGET_UNIQUE == tCategBuffs[1][2] then
			tUniqueBuffs[#tUniqueBuffs + 1] = tSpellName;
			tUniqueCategs[tSpellName] = tCategName;
		end
	end

	return tUniqueBuffs, tUniqueCategs;
end



--
function VUHDO_initBuffsFromSpellBook()

	local tSpellName, tSpellId, tIcon;

	if "HUNTER" == VUHDO_PLAYER_CLASS then
		VUHDO_BUFFS[VUHDO_SPELL_ID.BUFF_ASPECT_OF_THE_IRON_HAWK] = {
			["icon"] = select(3, GetSpellInfo(109260)),
			["id"] = 109260,
		};

		tinsert(VUHDO_getPlayerClassBuffs()[VUHDO_I18N_BUFFC_ASPECT],
			{ VUHDO_SPELL_ID.BUFF_ASPECT_OF_THE_IRON_HAWK, VUHDO_BUFF_TARGET_SELF }
		);
	end

	for _, tCateg in pairs(VUHDO_getPlayerClassBuffs()) do
		for _, tCategSpells in pairs(tCateg) do
			tSpellName = tCategSpells[1];
			_, tSpellId = GetSpellBookItemInfo(tSpellName);
			if tSpellId then
				_, _, tIcon = GetSpellInfo(tSpellId);
				VUHDO_BUFFS[tSpellName] = {
					["icon"] = tIcon,
					["id"] = tSpellId
				};
			end
		end
	end

	for tClassName, _ in pairs(VUHDO_CLASS_BUFFS) do
		if VUHDO_PLAYER_CLASS ~= tClassName then
			VUHDO_CLASS_BUFFS[tClassName] = nil;
		end
	end

end



--
function VUHDO_getBuffCategoryName(aBuffName, aTargetType)
	for tCategName, tCategBuffs in pairs(VUHDO_getPlayerClassBuffs()) do
		for _, tBuffVariant in pairs(tCategBuffs) do
			if aBuffName == tBuffVariant[1] and aTargetType == tBuffVariant[2] then
				return tCategName;
			end
		end
	end

	return nil;
end



--
local tInfo;
local function VUHDO_setUnitMissBuff(aUnit, aCategSpec, someVariants, aCategName)
	if not (VUHDO_BUFF_SETTINGS[aCategName]["missingColor"] or sEmpty)["show"] then return; end

	tInfo = VUHDO_RAID[aUnit];
	if tInfo then
		-- Don't show missing buffs on vehicles
		if tInfo["isPet"] and VUHDO_RAID[tInfo["ownerUnit"]] and VUHDO_RAID[tInfo["ownerUnit"]]["isVehicle"] then
			return;
		end

		if not tInfo["missbuff"] or tInfo["missbuff"] > VUHDO_BUFF_ORDER[aCategSpec] then
			tInfo["missbuff"] = VUHDO_BUFF_ORDER[aCategSpec];
			tInfo["mibucateg"] = aCategName;
			tInfo["mibuvariants"] = someVariants;
		end
	end
end



--
local tTexture, tStart, tRest, tDuration;
local tMissGroup = { };
local tLowGroup = { };
local tOkayGroup = { };
local tOorGroup = { };
local tGoodTarget;
local tLowestRest;
local tLowestUnit;
local tTotemFound, tStart;
local tNow;
local tInRange;
local tCount;
local tMaxCount;
local tIsWatchUnit;
local tInfo;
local tCategName;
local tIsAvailable;
local tIsNotInBattleground;
local tBuffGroup;
local function VUHDO_getMissingBuffs(aBuffInfo, someUnits, aCategSpec)
	tCategName = aCategSpec;
	twipe(tMissGroup);
	twipe(tLowGroup);
	twipe(tOkayGroup);
	twipe(tOorGroup);
	tGoodTarget = nil;
	tLowestRest = nil;
	tLowestUnit = nil;
	tNow = GetTime();
	tMaxCount = 0;

	if UnitOnTaxi("player") and VUHDO_BUFF_TARGET_SELF ~= aBuffInfo[2] then
		return tMissGroup, tLowGroup, tGoodTarget, tLowestRest, tLowestUnit, tOkayGroup, tOorGroup, tMaxCount;
	end

	tIsNotInBattleground = not VUHDO_isInBattleground();
	for _, tUnit in pairs(someUnits) do
		tInfo = VUHDO_RAID[tUnit];

		if "focus" == tUnit or "target" == tUnit or tInfo == nil or tInfo["isPet"] then
			tIsWatchUnit = false;
		elseif "player" == tUnit then
			tIsWatchUnit = true;
		elseif VUHDO_isInSameZone(tUnit) and (tInfo["visible"] or tIsNotInBattleground) then
			tIsWatchUnit = true;
		else
			tIsWatchUnit = false;
		end

		if tIsWatchUnit then
			tInRange = (IsSpellInRange(aBuffInfo[1], tUnit) == 1) or tInfo["baseRange"];
			tIsAvailable = tInfo["connected"] and not tInfo["dead"];

			_, _, tTexture, tCount, _, tStart, tRest, _, _ = UnitBuff(tUnit, aBuffInfo[1]);

			if not tTexture then
				for tCnt = 3, 10 do
					tBuffGroup = aBuffInfo[tCnt];
					if not tBuffGroup then break; end

					for _, tSameGroupBuff in pairs(tBuffGroup) do
						_, _, tTexture, tCount, _, tStart, tRest, _, _ = UnitBuff(tUnit, tSameGroupBuff);
						if tTexture then break; end
					end

					if not tTexture then break; end -- Kein Buff in einer der Gruppen? => Raus, nachbuffen
				end
			end

			if tTexture then
				tStart = tStart or 0;
				tRest = tRest and tRest - tNow or 0;
				tCount = tCount or 0

				if tCount > tMaxCount then tMaxCount = tCount; end

				if (tRest < sRebuffSecs or tRest / tStart < sRebuffPerc) and tRest > 0 then
					tLowGroup[#tLowGroup + 1] = tUnit;
					if not tInRange and tIsAvailable then
						tOorGroup[#tOorGroup + 1] = tUnit;
					end
				else
					tOkayGroup[#tOkayGroup + 1] = tUnit;
				end

				if tLowestRest == nil or tRest < tLowestRest then
					tLowestRest = tRest;
					if tInRange then tLowestUnit = tUnit; end
				end
			end

			if tIsAvailable then
				if not tTexture then
					tMissGroup[#tMissGroup + 1] = tUnit;
					if not tInRange and tIsAvailable then
						tOorGroup[#tOorGroup + 1] = tUnit;
					end
					VUHDO_setUnitMissBuff(tUnit, aCategSpec, aBuffInfo, tCategName);
					if tInRange then
						tLowestUnit = tUnit;
						tLowestRest = 0;
					end
				end

				if 10 == aBuffInfo[2] then tGoodTarget = "player"; -- VUHDO_BUFF_TARGET_RAID
				elseif 9 == aBuffInfo[2] then tGoodTarget = "target"; -- VUHDO_BUFF_TARGET_HOSTILE
				elseif 3 == aBuffInfo[2] or tInRange then tGoodTarget = tUnit; -- VUHDO_BUFF_TARGET_UNIQUE
				end
			end

		end
	end

	return tMissGroup, tLowGroup, tGoodTarget, tLowestRest, tLowestUnit, tOkayGroup, tOorGroup, tMaxCount;
end



--
local tFilters;
local tIsPetArray = { ["isPet"] = true };
local function VUHDO_updateFilter(aCategName)
	tFilters = VUHDO_BUFF_SETTINGS[aCategName]["filter"];

	if tFilters[VUHDO_ID_ALL] then
		VUHDO_BUFF_RAID_FILTERED[aCategName] = VUHDO_BUFF_RAID;
	else
		VUHDO_BUFF_RAID_FILTERED[aCategName] = { };

		for tModelId, _ in pairs(tFilters) do
			for _, tUnit in pairs(VUHDO_GROUPS[tModelId]) do
				if not (VUHDO_RAID[tUnit] or tIsPetArray)["isPet"] then
					VUHDO_tableUniqueAdd(VUHDO_BUFF_RAID_FILTERED[aCategName], tUnit);
				end
			end
		end
	end
end



--
function VUHDO_updateBuffFilters()
	for tCategSpec, _ in pairs(VUHDO_getPlayerClassBuffs()) do
		VUHDO_updateFilter(tCategSpec);
	end
end



--
function VUHDO_updateBuffRaidGroup()
	twipe(VUHDO_BUFF_RAID);
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if "focus" ~= tUnit and "target" ~= tUnit and not tInfo["isPet"] then
			VUHDO_BUFF_RAID[#VUHDO_BUFF_RAID + 1] = tUnit;
		end
	end

	VUHDO_updateBuffFilters();
end



--
local tDestGroup;
local tPlayerGroup;
local tTargetType;
local tEnchantDuration;
local tHasEnchant;
local tCategName;
local tNameGroup = { };
local tIsActive;
local tRest, tName, tTotemNum, tTexture;
local function VUHDO_getMissingBuffsForCode(aTargetCode, aBuffInfo, aCategSpec)

	if "N" == strsub(aTargetCode, 1, 1) then
		tNameGroup[1] = VUHDO_RAID_NAMES[strsub(aTargetCode, 2)];
		tDestGroup = tNameGroup;
	else
		tTargetType = aBuffInfo[2];

		if VUHDO_BUFF_TARGET_RAID == tTargetType or VUHDO_BUFF_TARGET_SINGLE == tTargetType then
			tCategName = aCategSpec;
			if VUHDO_BUFF_RAID_FILTERED[tCategName] then
				tDestGroup = VUHDO_BUFF_RAID_FILTERED[tCategName];
			else
				tDestGroup = VUHDO_BUFF_RAID;
			end

		elseif VUHDO_BUFF_TARGET_OWN_GROUP == tTargetType then
			tDestGroup = VUHDO_GROUPS[(VUHDO_RAID["player"] or {})["group"] or 1];

		elseif VUHDO_BUFF_TARGET_STANCE == tTargetType then
			for tCnt = 1, NUM_STANCE_SLOTS do
				_, tName, tIsActive = GetShapeshiftFormInfo(tCnt);
				if tIsActive and tName == aBuffInfo[1] then
					return sEmpty, sEmpty, "player", 0, "player", VUHDO_PLAYER_GROUP, sEmpty, 0;
				end
			end

			VUHDO_setUnitMissBuff("player", aCategSpec, aBuffInfo, aCategSpec);
			return VUHDO_PLAYER_GROUP, sEmpty, "player", 0, "player", sEmpty, sEmpty, 0;

		elseif VUHDO_BUFF_TARGET_ENCHANT == tTargetType then
			tHasEnchant, tEnchantDuration = GetWeaponEnchantInfo();
			if tHasEnchant and (not sGermanOrEnglish or strfind(aBuffInfo[1], VUHDO_getWeaponEnchantName(16), 1, true)) then
				return sEmpty, sEmpty, "player", tEnchantDuration * 0.001, "player", VUHDO_PLAYER_GROUP, sEmpty, 0;
			end

			VUHDO_setUnitMissBuff("player", aCategSpec, aBuffInfo, aCategSpec);
			return VUHDO_PLAYER_GROUP, sEmpty, "player", 0, "player", sEmpty, sEmpty, 0;

		elseif VUHDO_BUFF_TARGET_ENCHANT_OFF == tTargetType then
			_, _, _, tHasEnchant, tEnchantDuration = GetWeaponEnchantInfo();

			if tHasEnchant and (not sGermanOrEnglish or strfind(aBuffInfo[1], VUHDO_getWeaponEnchantName(17), 1, true)) then
				return sEmpty, sEmpty, "player", tEnchantDuration * 0.001, "player", VUHDO_PLAYER_GROUP, sEmpty, 0;
			end

			VUHDO_setUnitMissBuff("player", aCategSpec, aBuffInfo, aCategSpec);
			return VUHDO_PLAYER_GROUP, sEmpty, "player", 0, "player", sEmpty, sEmpty, 0;

		elseif VUHDO_BUFF_TARGET_TOTEM == tTargetType then
			for tTotemNum = 1, 4 do
				_, tName, tStart, tDuration, tTexture = GetTotemInfo(tTotemNum);
				if tTexture == VUHDO_BUFFS[aBuffInfo[1]]["icon"] then
					if tName ~= aBuffInfo[1] then
						sCooldownAliases[aBuffInfo[1]] = tName;
					end
					tRest = tDuration - (GetTime() - tStart);
					if tRest < 0 then tRest = 0; end

					return sEmpty, sEmpty, "player", tRest, "player", VUHDO_PLAYER_GROUP, sEmpty, 0;
				end
			end

			VUHDO_setUnitMissBuff("player", aCategSpec, aBuffInfo, aCategSpec);
			return VUHDO_PLAYER_GROUP, sEmpty, "player", 0, "player", sEmpty, sEmpty, 0;
		else
			-- If self we only care if buff isn't on player
			tDestGroup = VUHDO_PLAYER_GROUP;
		end
	end

	return VUHDO_getMissingBuffs(aBuffInfo, tDestGroup or sEmpty, aCategSpec);
end



--
local function VUHDO_setBuffSwatchColor(aSwatch, aColorInfo, aColorType)
	if VUHDO_LAST_COLORS[aSwatch:GetName()] == aColorType then return; end

	local tColor = VUHDO_getDiffColor(VUHDO_copyColor(sConfig["SWATCH_BG_COLOR"]), aColorInfo);
	aSwatch:SetBackdropColor(VUHDO_backColor(tColor));
	local tName = aSwatch:GetName();

	if tColor["useText"] then
		_G[tName .. "MessageLabelLabel"]:SetTextColor(VUHDO_textColor(tColor));
		_G[tName .. "TimerLabelLabel"]:SetTextColor(VUHDO_textColor(tColor));
		_G[tName .. "CounterLabelLabel"]:SetTextColor(VUHDO_textColor(tColor));
		tColor = VUHDO_brightenTextColor(VUHDO_copyColor(aColorInfo), 0.2);
		_G[tName .. "GroupLabelLabel"]:SetTextColor(VUHDO_textColor(tColor));
	end

	VUHDO_LAST_COLORS[tName] = aColorType;
end



--
local function VUHDO_setBuffSwatchInfo(aSwatchName, anInfoText)
	_G[aSwatchName .. "MessageLabelLabel"]:SetText(anInfoText);
end



--
local function VUHDO_setBuffSwatchCount(aSwatchName, aText)
	_G[aSwatchName .. "CounterLabelLabel"]:SetText(aText);
end



--
local tCountStr;
local function VUHDO_setBuffSwatchTimer(aSwatchName, aSecsNum, aCount)
	if (aSecsNum or -1) >= 0 then
		tCountStr = ((aCount or 0) > 0 and not VUHDO_BUFF_SETTINGS["CONFIG"]["HIDE_CHARGES"])
			and format("|cffffffff%dx |r", aCount) or "";
		_G[aSwatchName .. "TimerLabelLabel"]:SetText(format("%s%d:%02d", tCountStr, aSecsNum / 60, aSecsNum % 60));
	else
		_G[aSwatchName .. "TimerLabelLabel"]:SetText("");
	end
end



--
local tStart, tDuration;
local function VUHDO_getSpellCooldown(aSpellName)
	if sCooldownAliases[aSpellName] then
		tStart, tDuration = GetSpellCooldown(sCooldownAliases[aSpellName], BOOKTYPE_SPELL);
	else
		tStart, tDuration = GetSpellCooldown(VUHDO_BUFFS[aSpellName]["id"]);
	end

	if (tDuration or 0) == 0 then return 0, 0;
	else return (tStart or 0) + tDuration - GetTime(), tDuration; end
end



--
local tMissGroup;
local tLowGroup;
local tGoodTarget;
local tLowestRest;
local tLowestUnit;
local tOkayGroup;
local tOorGroup;
local tCooldown, tTotalCd;
local tRefSpell;
local tSwatchName;
local tMaxCount;
local tCategSpec;
local tVariant;
local tTargetCode;
function VUHDO_updateBuffSwatch(aSwatch)
	tSwatchName = aSwatch:GetName();
	tVariant = aSwatch:GetAttribute("buff");
	tTargetCode = aSwatch:GetAttribute("target");
	tCategSpec = aSwatch:GetAttribute("buffName");

	if not tTargetCode or not tVariant then return; end
	tLowestUnit, tGoodTarget = nil, nil;

	tRefSpell = tVariant[1];

	if not VUHDO_BUFFS[tRefSpell] or not VUHDO_BUFFS[tRefSpell]["id"] then return; end

	tCooldown, tTotalCd = VUHDO_getSpellCooldown(tRefSpell);

	if tCooldown > 1.5 then
		VUHDO_setBuffSwatchColor(aSwatch, sConfig["SWATCH_COLOR_BUFF_COOLDOWN"], VUHDO_BS_COLOR_CD);
		VUHDO_setBuffSwatchInfo(tSwatchName, VUHDO_I18N_BW_CD);
		VUHDO_setBuffSwatchCount(tSwatchName, "");
		VUHDO_setBuffSwatchTimer(tSwatchName, tCooldown, nil);
		if tTotalCd > 59 then VUHDO_BUFFS[tRefSpell]["wasOnCd"] = true; end
	else
		if VUHDO_BUFFS[tRefSpell]["wasOnCd"] and VUHDO_BUFF_SETTINGS["CONFIG"]["HIGHLIGHT_COOLDOWN"] then
			VUHDO_UIFrameFlash(aSwatch, 0.3, 0.3, 5, true, 0, 0.3);
			VUHDO_BUFFS[tRefSpell]["wasOnCd"] = false;
		end

		tMissGroup, tLowGroup, tGoodTarget, tLowestRest, tLowestUnit, tOkayGroup, tOorGroup, tMaxCount
			= VUHDO_getMissingBuffsForCode(tTargetCode, tVariant, tCategSpec);

		if #tMissGroup > 0 then
			VUHDO_setBuffSwatchColor(aSwatch, sConfig["SWATCH_COLOR_BUFF_OUT"], VUHDO_BS_COLOR_MISSING);

			if not tGoodTarget or #tMissGroup + #tLowGroup - #tOorGroup == 0 then
				VUHDO_setBuffSwatchInfo(tSwatchName, VUHDO_I18N_BW_RNG_YELLOW);
				VUHDO_setBuffSwatchCount(tSwatchName, "" .. #tOorGroup);
				VUHDO_setBuffSwatchTimer(tSwatchName, 0, nil, tMaxCount);
			else
				VUHDO_setBuffSwatchInfo(tSwatchName, VUHDO_I18N_BW_GO);
				if #tOorGroup > 0 then
					VUHDO_setBuffSwatchCount(tSwatchName, format("%d/%d", #tMissGroup + #tLowGroup - #tOorGroup, #tMissGroup + #tLowGroup));
				else
					VUHDO_setBuffSwatchCount(tSwatchName, format("%d", #tMissGroup + #tLowGroup));
				end
				VUHDO_setBuffSwatchTimer(tSwatchName, 0, nil);
			end

		elseif #tLowGroup > 0 then
			VUHDO_setBuffSwatchColor(aSwatch, sConfig["SWATCH_COLOR_BUFF_LOW"], VUHDO_BS_COLOR_LOW);
			VUHDO_setBuffSwatchInfo(tSwatchName, tGoodTarget and VUHDO_I18N_BW_LOW or VUHDO_I18N_BW_RNG_RED);

			if #tOorGroup > 0 then
				VUHDO_setBuffSwatchCount(tSwatchName, format("%d/%d", #tLowGroup - #tOorGroup, #tLowGroup));
			else
				VUHDO_setBuffSwatchCount(tSwatchName, format("%d", #tLowGroup));
			end
			VUHDO_setBuffSwatchTimer(tSwatchName, tLowestRest, tMaxCount);
		else
			VUHDO_setBuffSwatchColor(aSwatch, sConfig["SWATCH_COLOR_BUFF_OKAY"], VUHDO_BS_COLOR_OKAY);

			if #tOkayGroup == 0 then
				VUHDO_setBuffSwatchInfo(tSwatchName, VUHDO_I18N_BW_N_A);
			elseif not tGoodTarget then
				VUHDO_setBuffSwatchInfo(tSwatchName, VUHDO_I18N_BW_RNG_RED);
			else
				VUHDO_setBuffSwatchInfo(tSwatchName, VUHDO_I18N_BW_OK);
			end

			VUHDO_setBuffSwatchCount(tSwatchName, #tOkayGroup);
			if tLowestRest == 0 then
				VUHDO_setBuffSwatchTimer(tSwatchName, nil);
			else
				VUHDO_setBuffSwatchTimer(tSwatchName, tLowestRest, tMaxCount);
			end
		end
	end

	if not InCombatLockdown() then
		aSwatch:SetAttribute("lowtarget", tLowestUnit);
		aSwatch:SetAttribute("goodtarget", tGoodTarget);
	end

	VUHDO_NUM_LOWS[tSwatchName] = #(tLowGroup or sEmpty) + #(tMissGroup or sEmpty);
end



--
local tAllSwatches;
local tOldMissBuffs = { };
function VUHDO_updateBuffPanel()
	if VUHDO_isConfigDemoUsers() then return; end

	for tUnit, tInfo in pairs(VUHDO_RAID) do
		tOldMissBuffs[tUnit] = tInfo["missbuff"];
		tInfo["missbuff"] = nil;
	end

	tAllSwatches = VUHDO_getAllBuffSwatches();
	for _, tUpdSwatch in pairs(tAllSwatches) do
		if tUpdSwatch:IsShown() then VUHDO_updateBuffSwatch(tUpdSwatch); end
	end

	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if tOldMissBuffs[tUnit] ~= tInfo["missbuff"] then
			tInfo["debuff"], tInfo["debuffName"] = VUHDO_determineDebuff(tUnit);
			VUHDO_updateHealthBarsFor(tUnit, VUHDO_UPDATE_DEBUFF);
		end
	end

	twipe(tOldMissBuffs);
end



--
function VUHDO_execSmartBuffPre(self)
	if InCombatLockdown() then
		UIErrorsFrame:AddMessage(VUHDO_I18N_SMARTBUFF_ERR_1, 1, 0.1, 0.1, 1);
		return false;
	end

	local tAllSwatches = VUHDO_getAllBuffSwatchesOrdered();
	local tVariants = nil;
	local tTargetCode = nil;
	local tRefSpell = nil;
	local tMaxLow = 0;
	local tMaxLowSpell = nil;
	local tMaxLowTarget = nil;
	local tCategSpec;
	local tMissGroup, tLowGroup, tGoodTarget, tLowestUnit, tOorGroup;
	local tNumLow, tCooldown, tTotalCd;
	local tCooldown, tTotalCd;

	for _, tCheckSwatch in ipairs(tAllSwatches) do
		if tCheckSwatch:IsShown() then
			tVariants = tCheckSwatch:GetAttribute("buff");
			tTargetCode = tCheckSwatch:GetAttribute("target");
			tCategSpec = tCheckSwatch:GetAttribute("buffname");
			tRefSpell = tVariants[1];

			tMissGroup, tLowGroup, tGoodTarget,	_, tLowestUnit, _,	tOorGroup, _
					= VUHDO_getMissingBuffsForCode(tTargetCode, tVariants, tCategSpec);

			tNumLow = #tMissGroup + #tLowGroup;
			if not VUHDO_BUFFS[tRefSpell] or not VUHDO_BUFFS[tRefSpell]["id"] then
				tCooldown, tTotalCd = 0, 0;
			else
				tCooldown, tTotalCd = VUHDO_getSpellCooldown(tRefSpell);
			end

			if tNumLow > tMaxLow and tCooldown <= 1.5 and VUHDO_BUFF_TARGET_HOSTILE ~= tVariants[2] then
				if (tGoodTarget == nil) then
					UIErrorsFrame:AddMessage(VUHDO_I18N_SMARTBUFF_ERR_2 .. tRefSpell, 1, 0.1, 0.1, 1);
				elseif #tOorGroup > 0 then
					UIErrorsFrame:AddMessage("VuhDo: " .. #tOorGroup .. VUHDO_I18N_SMARTBUFF_ERR_3 .. tRefSpell, 1, 0.1, 0.1, 1);
				else
					tMaxLow = tNumLow;
					tMaxLowTarget = VUHDO_isUseSingleBuff(tCheckSwatch)	and tLowestUnit or tGoodTarget;
					tMaxLowSpell = tVariants[1];
				end
			end
		end
	end

	if not tMaxLowSpell then
		UIErrorsFrame:AddMessage(VUHDO_I18N_SMARTBUFF_ERR_4, 1, 1, 0.1, 1);
		return;
	end

	if not VUHDO_BUFFS[tMaxLowSpell] or not VUHDO_BUFFS[tMaxLowSpell]["id"] then
		tCooldown, tTotalCd = 0, 0;
	else
		tCooldown, tTotalCd = VUHDO_getSpellCooldown(tMaxLowSpell);
	end

	if tCooldown > 0 then return; end

	local tName = VUHDO_RAID_NAMES[tMaxLowTarget] or VUHDO_RAID[tMaxLowTarget]["name"];

	UIErrorsFrame:AddMessage(VUHDO_I18N_SMARTBUFF_OKAY_1 .. tMaxLowSpell .. VUHDO_I18N_SMARTBUFF_OKAY_2 .. tName, 0.1, 1, 0.1, 1);
	VuhDoSmartCastGlassButton:SetAttribute("unit", tMaxLowTarget);
	VuhDoSmartCastGlassButton:SetAttribute("type1", "spell");
	VuhDoSmartCastGlassButton:SetAttribute("spell1", tMaxLowSpell);
end



--
function VUHDO_execSmartBuffPost()
	VuhDoSmartCastGlassButton:SetAttribute("unit", nil);
	VuhDoSmartCastGlassButton:SetAttribute("type1", nil);
end



--
function VUHDO_resetBuffSwatchInfos()
	twipe(VUHDO_LAST_COLORS);
end
