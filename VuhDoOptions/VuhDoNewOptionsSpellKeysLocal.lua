local selectedIdx = 1;
local tIsAssignmentPending = false;
local VUHDO_FRAMES = { };



--
local function VUHDO_setHint(aText)
	VuhDoNewOptionsSpellKeysLocalHintLabelLabel:SetText(aText or "");
end


--
function VUHDO_updateEditButton(aFrame)
	local tEditBox = VUHDO_GLOBAL[aFrame:GetName() .. "EditBox"];

	local tEditButton = VUHDO_GLOBAL[aFrame:GetName() .. "EditButton"];
	local _, _, _, _, tType = VUHDO_isActionValid(tEditBox:GetText(), true);
	if ("CUS" == tType) then
		tEditButton:Show();
	else
		tEditButton:Hide();
	end
end



local function VUHDO_setAssignButtonText(aButton, aBinding)
	if (aBinding ~= nil) then
		aButton:SetText(GetBindingText(aBinding, "KEY_"));
	else
		aButton:SetText(NOT_BOUND);
	end
end



--
local function VUHDO_addKeyboardMacroSlot(aScrollPanel, anIndex, someDefs)
	local tName = aScrollPanel:GetName() .. "E" .. anIndex;
	if (VUHDO_GLOBAL[tName] == nil) then
		tinsert(VUHDO_FRAMES, CreateFrame("Frame", tName, aScrollPanel, "VuhDoInternalMacroSlotContainer"));
	end
	local tFrame = VUHDO_GLOBAL[tName];
	tFrame:Show();
	tFrame:SetAttribute("list_index", anIndex);
	tFrame:SetPoint("TOPLEFT", aScrollPanel:GetName(), "TOPLEFT", 5, -(anIndex - 1) * tFrame:GetHeight() - 7);

	local tEditBox = VUHDO_GLOBAL[tFrame:GetName() .. "EditBox"];
	VUHDO_lnfSetModel(tEditBox, "VUHDO_SPELLS_KEYBOARD.INTERNAL.##" .. anIndex .. ".##1");
	VUHDO_lnfEditBoxInitFromModel(tEditBox);

	local tButton = VUHDO_GLOBAL[tFrame:GetName() .. "Assignment1Button"];
	local tBinding = VUHDO_SPELLS_KEYBOARD["INTERNAL"][anIndex][2];
	VUHDO_setAssignButtonText(tButton, tBinding)

	if (anIndex == selectedIdx) then
	  tFrame:SetBackdropColor(0.8, 0.8, 1, 1);
	  tEditBox:SetFocus();
	else
	  tFrame:SetBackdropColor(1, 1, 1, 1);
	end

	return tFrame;
end



--
function VUHDO_keyboardlocalSpellsScrollPanelOnShow(aScrollPanel)

	local tFrame = nil;
	local tIndex, tDefs;

	for _, tFrame in pairs(VUHDO_FRAMES) do
		tFrame:ClearAllPoints();
		tFrame:Hide();
	end

	for tIndex, tDefs in ipairs(VUHDO_SPELLS_KEYBOARD["INTERNAL"]) do
		tFrame = VUHDO_addKeyboardMacroSlot(aScrollPanel, tIndex, tDefs);
	end

	if (tFrame ~= nil) then
		aScrollPanel:SetHeight((#VUHDO_SPELLS_KEYBOARD["INTERNAL"] + 1) * tFrame:GetHeight() + 18);
	end

	VUHDO_setHint("");
end



--
function VUHDO_newOptionsKeyLocalSelectItem(aFrame)
	if (not tIsAssignmentPending) then
		selectedIdx = aFrame:GetAttribute("list_index");
		VUHDO_keyboardlocalSpellsScrollPanelOnShow(aFrame:GetParent());
	end
end


--------------------------------------------------------------------------



--
function VUHDO_setOriginalType(aFrame)
	local tEditBox = VUHDO_GLOBAL[aFrame:GetName() .. "EditBox"];
	aFrame["originalName"] = tEditBox:GetText();
end




local tOldFrame = nil;



local function VUHDO_yesNoDeleteCustomMacroCallback(aDecision)
	local tIndex = tOldFrame:GetAttribute("list_index");
	if (VUHDO_YES == aDecision) then
		VUHDO_SPELLS_KEYBOARD["INTERNAL"][tIndex][3] = nil;
		VUHDO_setHint(VUHDO_I18N_LKA_CUSTOM_MACRO_DISCARDED);
	else
		VUHDO_SPELLS_KEYBOARD["INTERNAL"][tIndex][1] = tOldFrame["originalName"];
		local tEditBox = VUHDO_GLOBAL[tOldFrame:GetName() .. "EditBox"];
		VUHDO_lnfEditBoxInitFromModel(tEditBox);
		VUHDO_setHint(VUHDO_I18N_NAME_CHANGE_DISCARDED);
	end
	tOldFrame = nil;
end


--
function VUHDO_checkTypeChange(aFrame)
	local _, _, _, _, tOrigType = VUHDO_isActionValid(aFrame["originalName"], true);
	tIndex = aFrame:GetAttribute("list_index");
	if ("CUS" == tOrigType and (VUHDO_SPELLS_KEYBOARD["INTERNAL"][tIndex] ~= nil and VUHDO_SPELLS_KEYBOARD["INTERNAL"][tIndex][3] or "") ~= "") then
		local tEditBox = VUHDO_GLOBAL[aFrame:GetName() .. "EditBox"];
		local _, _, _, _, tNewType = VUHDO_isActionValid(tEditBox:GetText(), true);
		if (tNewType ~= "CUS") then
			if (tOldFrame == nil) then
				tOldFrame = aFrame;
			end
			VuhDoYesNoFrameText:SetText(VUHDO_I18N_LKA_TYPE_CHANGED);
			VuhDoYesNoFrame:SetAttribute("callback", VUHDO_yesNoDeleteCustomMacroCallback);
			VuhDoYesNoFrame:Show();
		end
	end
end


local tAssignIndex;
local tAssignButton = nil;



--
function VUHDO_spellsKeysLocalStopAssignment()
	if (tAssignButton ~= nil) then
		UIFrameFlashStop(tAssignButton);
	end
	tIsAssignmentPending = false;
	VuhDoNewOptionsSpellKeysLocalPanelClearBindingButton:SetAlpha(0.5);
end



--
function VUHDO_spellsKeysLocalStartAssignment(aButton)
	if (tIsAssignmentPending) then
		VUHDO_spellsKeysLocalStopAssignment();
		VUHDO_setHint(VUHDO_I18N_ASSIGN_ABORTED);
		return;
	end

	VUHDO_spellsKeysLocalStopAssignment();

	tIsAssignmentPending = true;
	tAssignButton = aButton;
	tAssignIndex = aButton:GetParent():GetAttribute("list_index");
	UIFrameFlash(aButton, 0.3, 0.3, 10000, true, 0.2, 0);
	VuhDoNewOptionsSpellKeysLocalPanelClearBindingButton:SetAlpha(1);
	VUHDO_setHint(VUHDO_I18N_LKA_PRESS_ASSIGN_KEY);
end



--
local function VUHDO_removeKeyFromList(aKey)
	local tResult = nil;
	local tIndex, tEntries;
	for tIndex, tEntries in pairs(VUHDO_SPELLS_KEYBOARD["INTERNAL"]) do
		if (tEntries[2] == aKey) then
			tEntries[2] = nil;
			tResult = tEntries[1];
		end
	end

	local tFrame, tButton;
	for _, tFrame in pairs(VUHDO_FRAMES) do
		tButton = VUHDO_GLOBAL[tFrame:GetName() .. "Assignment1Button"];
		if (tButton:GetText() == GetBindingText(aKey, "KEY_")) then
			VUHDO_setAssignButtonText(tButton, nil);
		end
	end

	return tResult;
end



--
function VUHDO_spellsKeysLocalAssignKey(self, aKey)

	if (not tIsAssignmentPending) then
		return;
	end

	if (aKey == "LSHIFT" or aKey == "RSHIFT"
		or aKey == "LCTRL" or	aKey == "RCTRL"
		or aKey == "LALT" or aKey == "RALT"
		or aKey == "UNKNOWN") then

		return;
	end
	if (IsShiftKeyDown()) then
		aKey = "SHIFT-"..aKey;
	end

	if (IsControlKeyDown()) then
		aKey = "CTRL-" .. aKey;
	end

	if (IsAltKeyDown()) then
		aKey = "ALT-" .. aKey;
	end

	local tIsSameKey = VUHDO_SPELLS_KEYBOARD["INTERNAL"][tAssignIndex][2] == aKey;
	local tFormerName = VUHDO_removeKeyFromList(aKey);
	if (tFormerName == nil or tIsSameKey) then
		VUHDO_setHint(VUHDO_I18N_LKA_SUCCESS_ASSIGNED);
	else
		VUHDO_setHint(format(VUHDO_I18N_LKA_ASSIGNED_CLEARED, tFormerName));
	end

	VUHDO_SPELLS_KEYBOARD["INTERNAL"][tAssignIndex][2] = aKey;
	VUHDO_setAssignButtonText(tAssignButton, aKey);
	VUHDO_spellsKeysLocalStopAssignment();
end



--
function VUHDO_spellsKeysLocalClearBindingClicked()
	if (not tIsAssignmentPending) then
		return;
	end

	if (VUHDO_SPELLS_KEYBOARD["INTERNAL"][tAssignIndex][2] ~= nil) then
		VUHDO_setHint(VUHDO_I18N_LKA_BIND_CLEARED);
		VUHDO_SPELLS_KEYBOARD["INTERNAL"][tAssignIndex][2] = nil;
		VUHDO_setAssignButtonText(tAssignButton, nil);
	end
	VUHDO_spellsKeysLocalStopAssignment();
end



--
function VUHDO_spellsKeysLocalAddClicked(aButton)
	tinsert(VUHDO_SPELLS_KEYBOARD["INTERNAL"], { VUHDO_I18N_LKA_NEW_BIND, nil, nil });
	selectedIdx = #VUHDO_SPELLS_KEYBOARD["INTERNAL"];

	local tScroll = VUHDO_GLOBAL[aButton:GetParent():GetName() .. "ScrollPanel"];
	local tChild = VUHDO_GLOBAL[tScroll:GetName() .. "Child"];
	VUHDO_keyboardlocalSpellsScrollPanelOnShow(tChild);
	if (#VUHDO_SPELLS_KEYBOARD["INTERNAL"] > 6) then
		tScroll:SetVerticalScroll(#VUHDO_SPELLS_KEYBOARD["INTERNAL"] * 45 + 18);
	end
end


--
function VUHDO_spellsKeysLocalRemoveClicked(aButton)
	local tScroll = VUHDO_GLOBAL[aButton:GetParent():GetName() .. "ScrollPanel"];
	local tChild = VUHDO_GLOBAL[tScroll:GetName() .. "Child"];
	tremove(VUHDO_SPELLS_KEYBOARD["INTERNAL"], selectedIdx);

	if (selectedIdx > 1 and selectedIdx > #VUHDO_SPELLS_KEYBOARD["INTERNAL"]) then
		selectedIdx = selectedIdx - 1;
	end
	VUHDO_keyboardlocalSpellsScrollPanelOnShow(tChild);
end


-------------------------------------------------------------------------------------------
-- Macro editor
-------------------------------------------------------------------------------------------

local tMacroEditor;
local tMacroPanel;
local tMultiLine;
local tMacroEntry;



--
function VUHDO_spellKeysLocalEditMacroClicked(aFrame)
	local tIndex = aFrame:GetAttribute("list_index");

	tMacroEntry = VUHDO_SPELLS_KEYBOARD["INTERNAL"][tIndex];
	if (tMacroEntry[3] == nil) then
		tMacroEntry[3] = "";
	end

	VuhDoNewOptionsSpellKeysLocal:Hide();
	tMacroEditor = VuhDoNewOptionsSpellKeysLocalMacroEdit;
	tMacroPanel = VuhDoNewOptionsSpellKeysLocalMacroPanel;
	tMacroEditor:Show();
	VUHDO_GLOBAL[tMacroPanel:GetName() .. "FileLabelLabel"]:SetText(VUHDO_I18N_LKA_EDITED_MACRO .. tMacroEntry[1]);

	tMultiLine = VUHDO_GLOBAL[tMacroPanel:GetName() .. "ScrollFrameEditBox"];
	tMultiLine:SetTextInsets(10,10,10,10);
	tMultiLine:SetText(tMacroEntry[3]);
end



--
function VUHDO_spellsKeysLocalAcceptMacroClicked()
	tMacroEntry[3] = tMultiLine:GetText();
	tMacroEditor:Hide();
	VuhDoNewOptionsSpellKeysLocal:Show();
end


function VUHDO_spellsKeysLocalDiscardMacroClicked()
	tMacroEditor:Hide();
	VuhDoNewOptionsSpellKeysLocal:Show();
end