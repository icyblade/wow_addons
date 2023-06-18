VUHDO_MENU_RETURN_TARGET = nil;
VUHDO_MENU_RETURN_TARGET_MAIN = nil;


local _;
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
local function VUHDO_countTableDiffs(aTable, anotherTable)
	local tCount = 0;

	if (aTable == nil or anotherTable == nil) then
		return 0;
	end

	aTable = VUHDO_decompressIfCompressed(aTable);
	anotherTable = VUHDO_decompressIfCompressed(anotherTable);

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
	VUHDO_trimSpellAssignments(VUHDO_SPELL_ASSIGNMENTS);
	VUHDO_trimSpellAssignments(VUHDO_HOSTILE_SPELL_ASSIGNMENTS);
	VUHDO_reloadUI(true);

	VUHDO_MAY_DEBUFF_ANIM = true;
	VuhDoNewOptionsTabbedFrame:Hide();
end



--
function VUHDO_tabbedPanelCancelClicked()
	VUHDO_newOptionsRestoreVars();
	VUHDO_initKeyboardMacros();
	VUHDO_MAY_DEBUFF_ANIM = true;
end



local tAllPanels = {
	{ "VuhDoNewOptionsGeneral", "General" },
	{ "VuhDoNewOptionsSpell", "Spell" },
	{ "VuhDoNewOptionsPanelPanel", "Panels" },
	{ "VuhDoNewOptionsColors", "Colors" },
	{ "VuhDoNewOptionsMove", "Move" },
	{ "VuhDoNewOptionsBuffs", "Buffs" },
	{ "VuhDoNewOptionsDebuffs", "Debuffs" },
	{ "VuhDoNewOptionsTools", "Tools" },
}


--
function VUHDO_newOptionsTabbedClickedClicked(aTabRadio)
	local tName = aTabRadio:GetName();

	for _, tPanelInfo in pairs(tAllPanels) do
		_G[tPanelInfo[1]]:SetShown(strfind(tName, tPanelInfo[2]));
	end
end



--
function VUHDO_newOptionsBufferVars()
	if (VUHDO_B_CONFIG == nil) then
		VUHDO_B_CONFIG = VUHDO_compressTable(VUHDO_CONFIG);
		VUHDO_B_INDICATOR_CONFIG = VUHDO_compressTable(VUHDO_INDICATOR_CONFIG);
		VUHDO_B_PANEL_SETUP = VUHDO_compressTable(VUHDO_PANEL_SETUP);
		VUHDO_B_SPELL_ASSIGNMENTS = VUHDO_compressTable(VUHDO_SPELL_ASSIGNMENTS);
		VUHDO_B_BUFF_SETTINGS = VUHDO_compressTable(VUHDO_BUFF_SETTINGS);
		VUHDO_B_SPELL_CONFIG = VUHDO_compressTable(VUHDO_SPELL_CONFIG);
		VUHDO_B_SPELLS_KEYBOARD = VUHDO_compressTable(VUHDO_SPELLS_KEYBOARD);
		VUHDO_B_BOUQUETS = VUHDO_compressTable(VUHDO_BOUQUETS);
	end
end



--
function VUHDO_yesNoDiscardChangesCallback(aDecision)
	if (VUHDO_YES == aDecision) then

		VUHDO_CONFIG = VUHDO_decompressIfCompressed(VUHDO_B_CONFIG);
		VUHDO_INDICATOR_CONFIG = VUHDO_decompressIfCompressed(VUHDO_B_INDICATOR_CONFIG);
		VUHDO_PANEL_SETUP = VUHDO_decompressIfCompressed(VUHDO_B_PANEL_SETUP);
		VUHDO_SPELL_ASSIGNMENTS = VUHDO_decompressIfCompressed(VUHDO_B_SPELL_ASSIGNMENTS);
		VUHDO_BUFF_SETTINGS = VUHDO_decompressIfCompressed(VUHDO_B_BUFF_SETTINGS);
		VUHDO_SPELL_CONFIG = VUHDO_decompressIfCompressed(VUHDO_B_SPELL_CONFIG);
		VUHDO_SPELLS_KEYBOARD = VUHDO_decompressIfCompressed(VUHDO_B_SPELLS_KEYBOARD);
		VUHDO_BOUQUETS = VUHDO_decompressIfCompressed(VUHDO_B_BOUQUETS);

		VUHDO_initAllBurstCaches();
		VUHDO_initBouquetComboModel();
		VUHDO_reloadUI(true);
		VUHDO_B_CONFIG = nil;
		VUHDO_B_INDICATOR_CONFIG = nil;
		VUHDO_B_PANEL_SETUP = nil;
		VUHDO_B_SPELL_ASSIGNMENTS = nil;
		VUHDO_B_BUFF_SETTINGS = nil;
		VUHDO_B_SPELL_CONFIG = nil;
		VUHDO_B_SPELLS_KEYBOARD = nil;
		VUHDO_B_BOUQUETS = nil;

		VuhDoNewOptionsTabbedFrame:Hide();
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



--
function VUHDO_initOptionsSettings()
	if (VUHDO_OPTIONS_SETTINGS == nil) then
		VUHDO_OPTIONS_SETTINGS = {
			["scale"] = 1;
		};
	end
end
