VUHDO_FAST_ACCESS_ACTIONS = { };



-- BURST CACHE ---------------------------------------------------

local VUHDO_RAID_NAMES;
local VUHDO_RAID;
local VUHDO_BUFF_REMOVAL_SPELLS;
local VUHDO_SPELL_ASSIGNMENTS;
local VUHDO_CONFIG;

local VUHDO_buildMacroText;
local VUHDO_buildTargetButtonMacroText;
local VUHDO_buildTargetMacroText;
local VUHDO_buildFocusMacroText;
local VUHDO_buildAssistMacroText;
local VUHDO_getDebuffAbilities;
local VUHDO_replaceMacroTemplates;
local VUHDO_isActionValid;

local GetMacroIndexByName = GetMacroIndexByName;
local GetMacroInfo = GetMacroInfo;
local GetSpellBookItemTexture = GetSpellBookItemTexture;
local UnitIsDeadOrGhost = UnitIsDeadOrGhost;
local gsub = gsub;
local UnitBuff = UnitBuff;
local GetCursorInfo = GetCursorInfo;
local GetShapeshiftForm = GetShapeshiftForm;
local InCombatLockdown = InCombatLockdown;
local pairs = pairs;
local _;
local strlen = strlen;
local strlower = strlower;

local sIsCliqueCompat;

function VUHDO_keySetupInitBurst()
	VUHDO_RAID_NAMES = VUHDO_GLOBAL["VUHDO_RAID_NAMES"];
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];
	VUHDO_BUFF_REMOVAL_SPELLS = VUHDO_GLOBAL["VUHDO_BUFF_REMOVAL_SPELLS"];
	VUHDO_SPELL_ASSIGNMENTS = VUHDO_GLOBAL["VUHDO_SPELL_ASSIGNMENTS"];
	VUHDO_CONFIG = VUHDO_GLOBAL["VUHDO_CONFIG"];

	VUHDO_buildMacroText = VUHDO_GLOBAL["VUHDO_buildMacroText"];
	VUHDO_buildTargetButtonMacroText = VUHDO_GLOBAL["VUHDO_buildTargetButtonMacroText"];
	VUHDO_buildTargetMacroText = VUHDO_GLOBAL["VUHDO_buildTargetMacroText"];
	VUHDO_buildFocusMacroText = VUHDO_GLOBAL["VUHDO_buildFocusMacroText"];
	VUHDO_buildAssistMacroText = VUHDO_GLOBAL["VUHDO_buildAssistMacroText"];
	VUHDO_getDebuffAbilities = VUHDO_GLOBAL["VUHDO_getDebuffAbilities"];
	VUHDO_replaceMacroTemplates = VUHDO_GLOBAL["VUHDO_replaceMacroTemplates"];
	VUHDO_isActionValid = VUHDO_GLOBAL["VUHDO_isActionValid"];
	sIsCliqueCompat = VUHDO_CONFIG["IS_CLIQUE_COMPAT_MODE"];
end
----------------------------------------------------



local VUHDO_REZ_SPELLS_NAMES = {
	[VUHDO_SPELL_ID.REDEMPTION] = true,
	[VUHDO_SPELL_ID.ANCESTRAL_SPIRIT] = true,
	[VUHDO_SPELL_ID.REVIVE] = true,
	[VUHDO_SPELL_ID.REBIRTH] = true,
	[VUHDO_SPELL_ID.RESURRECTION] = true,
};



local sDropdown;
local tUnit, tInfo, tIdent;
local tButtonName;
local tMacroId, tMacroText;
local tActionLow;
local tInvalidGroup = { ["group"] = -1 };

local function _VUHDO_setupHealButtonAttributes(aModiKey, aButtonId, anAction, aButton, anIsTgButton, anIndex)

	tUnit = aButton["raidid"];

	tActionLow = strlower(anAction);

	if ("assist" == tActionLow) then
		aButton:SetAttribute(aModiKey .. "type" .. aButtonId, "macro");
		aButton:SetAttribute(aModiKey .. "macrotext" .. aButtonId, VUHDO_buildAssistMacroText(tUnit));

	elseif ("focus" == tActionLow) then
		aButton:SetAttribute(aModiKey .. "type" .. aButtonId, "macro");
		aButton:SetAttribute(aModiKey .. "macrotext" .. aButtonId, VUHDO_buildFocusMacroText(tUnit));

	elseif ("target" == tActionLow) then
		aButton:SetAttribute(aModiKey .. "type" .. aButtonId, "macro");
		aButton:SetAttribute(aModiKey .. "macrotext" .. aButtonId, VUHDO_buildTargetMacroText(tUnit));

	elseif ("menu" == tActionLow or "tell" == tActionLow) then
		aButton:SetAttribute(aModiKey .. "type" .. aButtonId, nil);

	elseif ("dropdown" == tActionLow) then
		aButton:SetAttribute(aModiKey .."type" .. aButtonId, "VUHDO_contextMenu");

		VUHDO_contextMenu = function()
			sDropdown = nil;
			local tUnit = aButton["raidid"];
			if (tUnit == "player") then
				sDropdown = PlayerFrameDropDown;
			elseif (UnitIsUnit(tUnit, "target")) then
				sDropdown = TargetFrameDropDown;
			--[[elseif (UnitIsUnit(tUnit, "focus")) then
				sDropdown = FocusFrameDropDown;]] -- Problem, wenn Fokus löschen
			elseif (UnitIsUnit(tUnit, "pet")) then
				sDropdown = PetFrameDropDown;
			else
				tInfo = VUHDO_RAID[tUnit];

				if (tInfo ~= nil) then
					if ((VUHDO_RAID["player"] or tInvalidGroup)["group"] == tInfo["group"]) then
						sDropdown = VUHDO_GLOBAL['PartyMemberFrame' .. tInfo["number"] .. 'DropDown']
					else
						tIdent = tInfo["number"];
						FriendsDropDown["name"] = tInfo["name"];
						FriendsDropDown["id"] = tIdent;
						FriendsDropDown["unit"] = tUnit;
						FriendsDropDown["initialize"] = RaidFrameDropDown_Initialize;
						FriendsDropDown["displayMode"] = "MENU";
						sDropdown = FriendsDropDown;
					end
				end
			end

			if (sDropdown ~= nil) then
				ToggleDropDownMenu(1, nil, sDropdown, "cursor", 0, 0);
			end
		end

		aButton["VUHDO_contextMenu"] = VUHDO_contextMenu;
	else
		if (GetSpellBookItemTexture(anAction) ~= nil or VUHDO_IN_COMBAT_RELOG) then -- Spells may not be initialized yet
			-- Dead players do not trigger "help/noharm" conditionals
			if (VUHDO_REZ_SPELLS_NAMES[anAction] ~= nil) then
				aButton:SetAttribute(aModiKey .. "type" .. aButtonId, "macro");
				aButton:SetAttribute(aModiKey .. "macrotext" .. aButtonId,
					VUHDO_buildRezMacroText(anAction, tUnit));
				return;
			-- Cleansing charmed players is an offensive thing to do
			elseif (VUHDO_BUFF_REMOVAL_SPELLS[anAction] ~= nil) then
				aButton:SetAttribute(aModiKey .. "type" .. aButtonId, "macro");
				aButton:SetAttribute(aModiKey .. "macrotext" .. aButtonId,
					VUHDO_buildPurgeMacroText(anAction, tUnit));
				return;
			else
				-- build a spell macro
				aButton:SetAttribute(aModiKey .. "type" .. aButtonId, "macro");
				aButton:SetAttribute(aModiKey .. "macrotext" .. aButtonId,
					VUHDO_buildMacroText(anAction, false, tUnit));
			end
		else -- try to use item
			tMacroId = GetMacroIndexByName(anAction);
			if (tMacroId ~= 0) then
				_, _, tMacroText = GetMacroInfo(tMacroId);
				tMacroText = VUHDO_replaceMacroTemplates(tMacroText, tUnit);
				aButton:SetAttribute(aModiKey .. "type" .. aButtonId, "macro");
				aButton:SetAttribute(aModiKey .. "macrotext" .. aButtonId, tMacroText);
			else
				aButton:SetAttribute(aModiKey .. "type" .. aButtonId, "item");
				aButton:SetAttribute(aModiKey .. "item" .. aButtonId, anAction);
			end
		end
	end
end



--
local tUnit;
local tHostSpell;
local function VUHDO_setupHealButtonAttributes(aModiKey, aButtonId, anAction, aButton, anIsTgButton, anIndex)

	tUnit = aButton["raidid"];

	if (anIsTgButton or tUnit == "focus" or (tUnit == "target" and "dropdown" ~= anAction)) then
		if (anIndex == nil) then
			tHostSpell = VUHDO_HOSTILE_SPELL_ASSIGNMENTS[gsub(aModiKey, "-", "") .. aButtonId][3];
		else
			tHostSpell = VUHDO_SPELLS_KEYBOARD["HOSTILE_WHEEL"][anIndex][3];
		end
		aButton:SetAttribute(aModiKey .. "type" .. aButtonId, "macro");
		if ((tHostSpell or "") ~= "" or (anAction or "") ~= "") then
			aButton:SetAttribute(aModiKey .. "macrotext" .. aButtonId,
				VUHDO_buildTargetButtonMacroText(tUnit, anAction, tHostSpell));
		else
			aButton:SetAttribute(aModiKey .. "macrotext" .. aButtonId, nil);
		end
		return;
	end

	if ((anAction or "") == "") then
		aButton:SetAttribute(aModiKey .. "type" .. aButtonId, nil);
		return;
	else
		_VUHDO_setupHealButtonAttributes(aModiKey, aButtonId, anAction, aButton, anIsTgButton, anIndex);
	end
end



--
local tString, tAssignIdx, tFriendSpell, tHostSpell;
local function VUHDO_getWheelDefString()
	tString = "";
	for tIndex, tValue in pairs(VUHDO_WHEEL_BINDINGS) do
		tAssignIdx = VUHDO_WHEEL_INDEX_BINDING[tIndex];
		tFriendSpell = VUHDO_SPELLS_KEYBOARD["HOSTILE_WHEEL"][tAssignIdx][3];
		tHostSpell = VUHDO_SPELLS_KEYBOARD["WHEEL"][tAssignIdx][3];

		if (strlen(tFriendSpell) > 0 or strlen(tHostSpell) > 0) then
			tString = format("%sself:SetBindingClick(0, \"%s\", self:GetName(), \"w%d\");", tString, tValue, tIndex);
		end
	end
	return tString;
end



--
local tString;
local tIndex, tEntries;
local function VUHDO_getInternalKeyString()
	tString = "";
	for tIndex, tEntries in pairs(VUHDO_SPELLS_KEYBOARD["INTERNAL"]) do
		tString = format("%sself:SetBindingClick(0, \"%s\", self:GetName(), \"ik%d\");", tString, tEntries[2] == "\\" and "\\\\" or tEntries[2] or "", tIndex);
	end
	return tString;
end



-- Parse and interpret action-type
local tPreAction;
local tTarget;
local tIndex;
local tSpellDescr;
local tIsWheel;
local tHostSpell;
local tWheelDefString;
local tEntries;
local tCnt;
local tFrame;
function VUHDO_setupAllHealButtonAttributes(aButton, aUnit, anIsDisable, aForceTarget, anIsTgButton, anIsIcButton)

	if (aUnit ~= nil) then
		aButton:SetAttribute("unit", aUnit);
		aButton["raidid"] = aUnit;
	end

	if (aButton:GetAttribute("vd_tt_hook") == nil and not anIsTgButton) then
		if (anIsIcButton) then
			aButton:HookScript("OnEnter", function(self) VUHDO_showDebuffTooltip(self); VuhDoActionOnEnter(self:GetParent():GetParent():GetParent():GetParent()) end);
			aButton:HookScript("OnLeave", function(self) VUHDO_hideDebuffTooltip(); VuhDoActionOnLeave(self:GetParent():GetParent():GetParent():GetParent()) end);
		else
			aButton:HookScript("OnEnter",	function(self) VuhDoActionOnEnter(self); end);
			aButton:HookScript("OnLeave",	function(self) VuhDoActionOnLeave(self); end);
		end
		aButton:SetAttribute("vd_tt_hook", true);
	end

	if (sIsCliqueCompat) then
		aButton:EnableMouseWheel(1);
		return;
	end

	if (anIsDisable) then
		tPreAction = "";
	elseif (aForceTarget) then
		tPreAction = "target";
	else
		tPreAction = nil;
	end

	if (tPreAction ~= nil) then
		for _, tSpellDescr in pairs(VUHDO_SPELL_ASSIGNMENTS) do
			VUHDO_setupHealButtonAttributes(tSpellDescr[1], tSpellDescr[2], tPreAction, aButton, anIsTgButton);
		end

	else
		for _, tSpellDescr in pairs(VUHDO_SPELL_ASSIGNMENTS) do
			VUHDO_setupHealButtonAttributes(tSpellDescr[1], tSpellDescr[2], tSpellDescr[3], aButton, anIsTgButton);
		end
	end

	tIsWheel = false;
	for tIndex, tSpellDescr in pairs(VUHDO_SPELLS_KEYBOARD["WHEEL"]) do
		tHostSpell = VUHDO_SPELLS_KEYBOARD["HOSTILE_WHEEL"][tIndex][3];
		if (strlen(tSpellDescr[3]) > 0 or strlen(tHostSpell) > 0) then
			tIsWheel = true;
			VUHDO_setupHealButtonAttributes("", tSpellDescr[2], tSpellDescr[3], aButton, anIsTgButton, tIndex);
		end
	end

	for tIndex, tEntries in pairs(VUHDO_SPELLS_KEYBOARD["INTERNAL"]) do
		if (VUHDO_isActionValid(tEntries[1], false)) then
			_VUHDO_setupHealButtonAttributes("",  "-ik" .. tIndex, tEntries[1], aButton, anIsTgButton, tIndex);
		else
			aButton:SetAttribute("type-ik" .. tIndex, "macro");
			aButton:SetAttribute("macrotext-ik" .. tIndex, VUHDO_replaceMacroTemplates(tEntries[3] or "", aUnit));
		end
	end

	-- Tooltips and stuff for raid members only (not: target buttons)
	if (VUHDO_BUTTON_CACHE[aButton] or VUHDO_BUTTON_CACHE[aButton:GetParent():GetParent():GetParent():GetParent()] ~= nil) then
		tWheelDefString = "self:ClearBindings();";

		if (tIsWheel) then
			tWheelDefString = tWheelDefString .. VUHDO_getWheelDefString();
		end

		tWheelDefString = tWheelDefString .. VUHDO_getInternalKeyString();

		aButton:SetAttribute("_onenter", tWheelDefString);
		aButton:SetAttribute("_onleave", "self:ClearBindings();");
		aButton:SetAttribute("_onshow", "self:ClearBindings();");
		aButton:SetAttribute("_onhide", "self:ClearBindings();");
	end
end
local VUHDO_setupAllHealButtonAttributes = VUHDO_setupAllHealButtonAttributes;



--
local tProhibitSmartCastOn = {
	["target"] = true,
	["assist"] = true,
	["focus"] = true,
	["menu"] = true,
	["dropdown"] = true,
	["tell"] = true,
};

local tSpellDescr;
local function VUHDO_setupAllButtonsTo(aButton, aSpellName)
	for _, tSpellDescr in pairs(VUHDO_SPELL_ASSIGNMENTS) do
		if (not tProhibitSmartCastOn[tSpellDescr[3]]) then
			VUHDO_setupHealButtonAttributes(tSpellDescr[1], tSpellDescr[2], aSpellName, aButton, false);
		end
	end
end



--
function VUHDO_setupAllTargetButtonAttributes(aButton, aUnit)
	VUHDO_setupAllHealButtonAttributes(aButton, aUnit .. "target", false, false, true, false);
end



--
function VUHDO_setupAllTotButtonAttributes(aButton, aUnit)
	VUHDO_setupAllHealButtonAttributes(aButton, aUnit .. "targettarget", false, false, true, false);
end



--
local tCnt;
function VUHDO_disableActions(aButton)
	VUHDO_setupAllHealButtonAttributes(aButton, nil, true, false, false, false);

	aButton:Hide(); -- For clearing mouse-wheel click bindings
	aButton:Show();
end



--
local tIsShadowFrom;
local function VUHDO_isShadowForm()
	_, _, tIsShadowFrom = UnitBuff("player", VUHDO_SPELL_ID.SHADOWFORM);
	return tIsShadowFrom;
end



--
local tCursorItemType;
local tAbilities;
local tUnit;
local tInfo;
local tBuff;
function VUHDO_setupSmartCast(aButton)
	if (InCombatLockdown() or UnitIsDeadOrGhost("player")
		or (VUHDO_PLAYER_CLASS == "PRIEST" and GetShapeshiftForm() ~= 0 and not VUHDO_isShadowForm())) then -- Engelchen?
		return false;
	end

	tUnit = aButton["raidid"];
	tInfo = VUHDO_RAID[tUnit];

	if (tInfo == nil) then
		return false;
	end

	-- Resurrect?
	if (VUHDO_CONFIG["SMARTCAST_RESURRECT"] and tInfo["dead"]) then
		local tMainRes, _ = VUHDO_getResurrectionSpells();
		if (tMainRes ~= nil) then
			VUHDO_setupAllButtonsTo(aButton, tMainRes);
			return true;
		end
	end

	if (not tInfo["baseRange"]) then
		return false;
	end

	-- Trade?
	tCursorItemType, _, _ = GetCursorInfo();
	if ("item" == tCursorItemType or "money" == tCursorItemType) then
		DropItemOnUnit(tUnit);
		VUHDO_disableActions(aButton);
		return true;
	end

	-- Cleanse?
	if (VUHDO_CONFIG["SMARTCAST_CLEANSE"] and not tInfo["dead"]) then
		if (VUHDO_DEBUFF_TYPE_NONE ~= tInfo["debuff"]) then
			tAbilities = VUHDO_getDebuffAbilities(VUHDO_PLAYER_CLASS);
			if (tAbilities[tInfo["debuff"]] ~= nil) then
				VUHDO_setupAllButtonsTo(aButton, tAbilities[tInfo["debuff"]]);
				return true;
			end
		end
	end

	-- Buff?
	if (VUHDO_CONFIG["SMARTCAST_BUFF"] and tInfo["missbuff"] ~= nil and not tInfo["dead"]) then
		tBuff = tInfo["mibuvariants"];
		VUHDO_setupAllButtonsTo(aButton, tBuff[1]);
		VUHDO_setupHealButtonAttributes("", "2", tBuff[1], aButton, false);
		return true;
	end

	return false;
end

