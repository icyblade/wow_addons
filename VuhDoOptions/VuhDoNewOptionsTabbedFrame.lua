local VUHDO_B_CONFIG = nil;
local VUHDO_B_INDICATOR_CONFIG = nil;
local VUHDO_B_PANEL_SETUP = nil;
local VUHDO_B_SPELL_ASSIGNMENTS = nil;
local VUHDO_B_BUFF_SETTINGS = nil;
local VUHDO_B_SPELL_CONFIG = nil;
local VUHDO_B_SPELLS_KEYBOARD = nil;
local VUHDO_B_BOUQUETS = nil;
VUHDO_OPTIONS_SETTINGS = nil;

VUHDO_IS_CONFIG = false;

--
function VUHDO_tabbedFrameOnMouseDown(aPanel)
	aPanel:StartMoving();
end



--
function VUHDO_tabbedFrameOnMouseUp(aPanel)
	aPanel:StopMovingOrSizing();
end



--
local function VUHDO_getMainPanel(aComponent)
	while (aComponent:GetParent():GetName() ~= "UIParent") do
		aComponent = aComponent:GetParent();
	end

	return aComponent;
end



--
local function VUHDO_countTableDiffs(aTable, anotherTable)
	local tCount = 0;
	local tKey, tValue;

	if (aTable == nil or anotherTable == nil) then
		return 0;
	end

	for tKey, tValue in pairs(aTable) do
		if ("table" == type(tValue)) then
			tCount = tCount + VUHDO_countTableDiffs(tValue, anotherTable[tKey]);
		else
			if (aTable[tKey] ~= anotherTable[tKey]) then
				tCount = tCount + 1;
			end
		end
	end

	for tKey, tValue in pairs(anotherTable) do
		if ("table" == type(tValue)) then
		else
			if (aTable[tKey] == nil and tValue ~= aTable[tKey]) then
				tCount = tCount + 1;
			end
		end
	end

	return tCount;
end



--
function VUHDO_tabbedPanelOkayClicked(aButton)
	VUHDO_getMainPanel(aButton):Hide();

	VUHDO_B_CONFIG = nil;
	VUHDO_B_INDICATOR_CONFIG = nil;
	VUHDO_B_PANEL_SETUP = nil;
	VUHDO_B_SPELL_ASSIGNMENTS = nil;
	VUHDO_B_BUFF_SETTINGS = nil;
	VUHDO_B_SPELL_CONFIG = nil;
	VUHDO_B_SPELLS_KEYBOARD = nil;
	VUHDO_B_BOUQUETS = nil;

	VUHDO_initKeyboardMacros();
	VUHDO_fixHotSettings();
	VUHDO_initFromSpellbook();
	VUHDO_registerAllBouquets(false);

  if (VUHDO_CURR_LAYOUT == "") then
  	VUHDO_SPEC_LAYOUTS["selected"] = "";
	elseif ((VUHDO_SPEC_LAYOUTS["selected"] or "") ~= "") then
		VUHDO_CURR_LAYOUT = VUHDO_SPEC_LAYOUTS["selected"];
		VUHDO_saveKeyLayoutCallback(VUHDO_YES);
	end

	local _, tProfile = VUHDO_getProfileNamedCompressed(VUHDO_CONFIG["CURRENT_PROFILE"]);
	if (VUHDO_CURRENT_PROFILE == "") then
		VUHDO_CONFIG["CURRENT_PROFILE"] = "";
	elseif (tProfile ~= nil and tProfile["LOCKED"]) then
		VUHDO_Msg("Profile locked: Settings have NOT been saved to " .. tProfile["NAME"]);
	else
		VUHDO_saveCurrentProfile();
		VUHDO_CURRENT_PROFILE = VUHDO_CONFIG["CURRENT_PROFILE"];
	end

	VUHDO_initAllBurstCaches();
	VUHDO_reloadUI();

	VUHDO_MAY_DEBUFF_ANIM = true;
end



--
function VUHDO_tabbedPanelCancelClicked()
	VUHDO_newOptionsRestoreVars();
	VUHDO_initKeyboardMacros();
	VUHDO_MAY_DEBUFF_ANIM = true;
end



--
local function VUHDO_newOptionsHideAllTabPanels()
	VuhDoNewOptionsGeneral:Hide();
	VuhDoNewOptionsPanelPanel:Hide();
	VuhDoNewOptionsSpell:Hide();
	VuhDoNewOptionsColors:Hide();
	VuhDoNewOptionsMove:Hide();
	VuhDoNewOptionsBuffs:Hide();
	VuhDoNewOptionsDebuffs:Hide();
	VuhDoNewOptionsTools:Hide();
end



--
local tName;
function VUHDO_newOptionsTabbedClickedClicked(aTabRadio)
	tName = aTabRadio:GetName();

	VUHDO_newOptionsHideAllTabPanels();

	if (strfind(tName, "General")) then
		VuhDoNewOptionsGeneral:Show();
	elseif(strfind(tName, "Spell")) then
		VuhDoNewOptionsSpell:Show();
	elseif(strfind(tName, "Panels")) then
		VuhDoNewOptionsPanelPanel:Show();
	elseif(strfind(tName, "Colors")) then
		VuhDoNewOptionsColors:Show();
	elseif(strfind(tName, "Move")) then
		VuhDoNewOptionsMove:Show();
	elseif(strfind(tName, "Buffs")) then
		VuhDoNewOptionsBuffs:Show();
	elseif(strfind(tName, "Debuffs")) then
		VuhDoNewOptionsDebuffs:Show();
	elseif(strfind(tName, "Tools")) then
		VuhDoNewOptionsTools:Show();
	end
end



--
function VUHDO_newOptionsBufferVars()
	if (VUHDO_B_CONFIG == nil) then
		VUHDO_B_CONFIG = VUHDO_deepCopyTable(VUHDO_CONFIG);
		VUHDO_B_INDICATOR_CONFIG = VUHDO_deepCopyTable(VUHDO_INDICATOR_CONFIG);
		VUHDO_B_PANEL_SETUP = VUHDO_deepCopyTable(VUHDO_PANEL_SETUP);
		VUHDO_B_SPELL_ASSIGNMENTS = VUHDO_deepCopyTable(VUHDO_SPELL_ASSIGNMENTS);
		VUHDO_B_BUFF_SETTINGS = VUHDO_deepCopyTable(VUHDO_BUFF_SETTINGS);
		VUHDO_B_SPELL_CONFIG = VUHDO_deepCopyTable(VUHDO_SPELL_CONFIG);
		VUHDO_B_SPELLS_KEYBOARD = VUHDO_deepCopyTable(VUHDO_SPELLS_KEYBOARD);
		VUHDO_B_BOUQUETS = VUHDO_deepCopyTable(VUHDO_BOUQUETS);
	end
end



--
function VUHDO_yesNoDiscardChangesCallback(aDecision)
	if (VUHDO_YES == aDecision) then
		VuhDoNewOptionsTabbedFrame:Hide();

		VUHDO_CONFIG = VUHDO_deepCopyTable(VUHDO_B_CONFIG);
		VUHDO_INDICATOR_CONFIG = VUHDO_deepCopyTable(VUHDO_B_INDICATOR_CONFIG);
		VUHDO_PANEL_SETUP = VUHDO_deepCopyTable(VUHDO_B_PANEL_SETUP);
		VUHDO_SPELL_ASSIGNMENTS = VUHDO_deepCopyTable(VUHDO_B_SPELL_ASSIGNMENTS);
		VUHDO_BUFF_SETTINGS = VUHDO_deepCopyTable(VUHDO_B_BUFF_SETTINGS);
		VUHDO_SPELL_CONFIG = VUHDO_deepCopyTable(VUHDO_B_SPELL_CONFIG);
		VUHDO_SPELLS_KEYBOARD = VUHDO_deepCopyTable(VUHDO_B_SPELLS_KEYBOARD);
		VUHDO_BOUQUETS = VUHDO_deepCopyTable(VUHDO_B_BOUQUETS);

		VUHDO_B_CONFIG = nil;
		VUHDO_B_INDICATOR_CONFIG = nil;
		VUHDO_B_PANEL_SETUP = nil;
		VUHDO_B_SPELL_ASSIGNMENTS = nil;
		VUHDO_B_BUFF_SETTINGS = nil;
		VUHDO_B_SPELL_CONFIG = nil;
		VUHDO_B_SPELLS_KEYBOARD = nil;
		VUHDO_B_BOUQUETS = nil;

		VUHDO_initAllBurstCaches();
		VUHDO_initBouquetComboModel();
		VUHDO_reloadUI();
	end
end



--
local tChanges;
function VUHDO_newOptionsRestoreVars()
	tChanges =
		VUHDO_countTableDiffs(VUHDO_CONFIG, VUHDO_B_CONFIG)
		+ VUHDO_countTableDiffs(VUHDO_INDICATOR_CONFIG, VUHDO_B_INDICATOR_CONFIG)
		+ VUHDO_countTableDiffs(VUHDO_PANEL_SETUP, VUHDO_B_PANEL_SETUP)
		+ VUHDO_countTableDiffs(VUHDO_SPELL_ASSIGNMENTS, VUHDO_B_SPELL_ASSIGNMENTS)
		+ VUHDO_countTableDiffs(VUHDO_BUFF_SETTINGS, VUHDO_B_BUFF_SETTINGS)
		+ VUHDO_countTableDiffs(VUHDO_SPELL_CONFIG, VUHDO_B_SPELL_CONFIG)
		+ VUHDO_countTableDiffs(VUHDO_SPELLS_KEYBOARD, VUHDO_B_SPELLS_KEYBOARD);

	if (tChanges > 0) then
		VuhDoYesNoFrameText:SetText(format(VUHDO_I18N_DISCARD_CHANGES_CONFIRM, tChanges));
		VuhDoYesNoFrame:SetAttribute("callback", VUHDO_yesNoDiscardChangesCallback);
		VuhDoYesNoFrame:Show();
	else
		VUHDO_yesNoDiscardChangesCallback(VUHDO_YES);
	end
end





local VUHDO_INIT_OPTIONS_SETTINGS = {
	["scale"] = 1;
}


--
function VUHDO_initOptionsSettings()
	if (VUHDO_OPTIONS_SETTINGS == nil) then
		VUHDO_OPTIONS_SETTINGS = VUHDO_deepCopyTable(VUHDO_INIT_OPTIONS_SETTINGS);
	end
end
