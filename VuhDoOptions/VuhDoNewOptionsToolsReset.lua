local _;

-- Returns a "deep" copy of a table, not deleting existent elements in aDestTable
-- which means containing tables will be copies value-wise, not by reference
local function VUHDO_deepCopyTableTo(aTable, aDestTable)
	if (aDestTable == nil) then
		aDestTable = { };
	end

	for tKey, tValue in pairs(aTable) do
		if ("table" == type(tValue)) then
			aDestTable[tKey] = VUHDO_deepCopyTableTo(tValue, aDestTable[tKey]);
		else
			aDestTable[tKey] = tValue;
		end
	end

	for tKey, tValue in pairs(aDestTable) do
		local tIsBool = "boolean" == type(tValue) or ("number" == type(tValue) and (tValue == 0 or tValue == 1));

		if (tIsBool and not aTable[tKey]) then
			aDestTable[tKey] = aTable[tKey];
		end
	end

	return aDestTable;
end



--
function VUHDO_newOptionsToolsResetClassColorsClicked()
	VuhDoYesNoFrameText:SetText(VUHDO_I18N_RESET_CLASS_COLORS);
	VuhDoYesNoFrame:SetAttribute("callback",
		function(aDecision)
			if (VUHDO_YES == aDecision) then
				VUHDO_USER_CLASS_COLORS = nil;
				ReloadUI();
			end
		end
	);
	VuhDoYesNoFrame:Show();
end



--
function VUHDO_newOptionsToolsResetDebuffColorsClicked()
	VuhDoYesNoFrameText:SetText(VUHDO_I18N_RESET_DEBUFF_COLORS);
	VuhDoYesNoFrame:SetAttribute("callback",
		function(aDecision)
			if (VUHDO_YES == aDecision) then
				VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF0"] = nil;
				VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF1"] = nil;
				VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF2"] = nil;
				VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF3"] = nil;
				VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF4"] = nil;
				VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF6"] = nil;
				ReloadUI();
			end
		end
	);
	VuhDoYesNoFrame:Show();
end



--
function VUHDO_newOptionsToolsResetRaidIconColorsColorsClicked()
	VuhDoYesNoFrameText:SetText(VUHDO_I18N_RESET_RAID_ICON_COLORS);
	VuhDoYesNoFrame:SetAttribute("callback",
		function(aDecision)
			if (VUHDO_YES == aDecision) then
				VUHDO_PANEL_SETUP["BAR_COLORS"]["RAID_ICONS"] = nil;
				ReloadUI();
			end
		end
	);
	VuhDoYesNoFrame:Show();
end



--
function VUHDO_newOptionsToolsResetBuffWatchClicked()
	VuhDoYesNoFrameText:SetText(VUHDO_I18N_RESET_BUFF_WATCH);
	VuhDoYesNoFrame:SetAttribute("callback",
		function(aDecision)
			if (VUHDO_YES == aDecision) then
				VUHDO_BUFF_SETTINGS = nil;
				VUHDO_BUFF_ORDER = nil;
				ReloadUI();
			end
		end
	);
	VuhDoYesNoFrame:Show();
end



--
function VUHDO_newOptionsToolsResetCustomDebuffsClicked()
	VuhDoYesNoFrameText:SetText(VUHDO_I18N_RESET_CUSTOM_DEBUFFS);
	VuhDoYesNoFrame:SetAttribute("callback",
		function(aDecision)
			if (VUHDO_YES == aDecision) then
				VUHDO_CONFIG["CUSTOM_DEBUFF"] = nil;
				ReloadUI();
			end
		end
	);
	VuhDoYesNoFrame:Show();
end



--
function VUHDO_newOptionsToolsResetDefaultBouquetsClicked()
	VuhDoYesNoFrameText:SetText(VUHDO_I18N_RESET_DEFAULT_BOUQUETS);
	VuhDoYesNoFrame:SetAttribute("callback",
		function(aDecision)
			if (VUHDO_YES == aDecision) then
				VUHDO_DEFAULT_BOUQUETS = VUHDO_decompressIfCompressed(VUHDO_DEFAULT_BOUQUETS);
				for tName, _ in pairs(VUHDO_DEFAULT_BOUQUETS["STORED"]) do
					VUHDO_BOUQUETS["STORED"][tName] = nil;
				end

				VUHDO_BOUQUETS["STORED"] = VUHDO_deepCopyTableTo(VUHDO_DEFAULT_BOUQUETS["STORED"], VUHDO_BOUQUETS["STORED"]);
				VUHDO_BOUQUETS["VERSION"] = 1;
				ReloadUI();
			end
		end
	);
	VuhDoYesNoFrame:Show();
end



--
function VUHDO_newOptionsToolsResetIndicatorsClicked()
	VuhDoYesNoFrameText:SetText(VUHDO_I18N_RESET_INDICATORS);
	VuhDoYesNoFrame:SetAttribute("callback",
		function(aDecision)
			if (VUHDO_YES == aDecision) then
				VUHDO_INDICATOR_CONFIG = nil;
				ReloadUI();
			end
		end
	);
	VuhDoYesNoFrame:Show();
end



--
function VUHDO_newOptionsToolsResetEverythingClicked()
	VuhDoYesNoFrameText:SetText(VUHDO_I18N_RESET_ALL);
	VuhDoYesNoFrame:SetAttribute("callback",
		function(aDecision)
			if (VUHDO_YES == aDecision) then
				VUHDO_CONFIG = nil;
				VUHDO_PANEL_SETUP = nil;
				VUHDO_SPELL_ASSIGNMENTS = nil;
				VUHDO_HOSTILE_SPELL_ASSIGNMENTS = nil;
				VUHDO_MM_SETTINGS = nil;
				VUHDO_PLAYER_TARGETS = nil;
				VUHDO_MAINTANK_NAMES = nil;
				VUHDO_BUFF_SETTINGS = nil;
				VUHDO_POWER_TYPE_COLORS = nil;
				VUHDO_SPELLS_KEYBOARD = nil;
				VUHDO_SPELL_CONFIG = nil;
				VUHDO_BUFF_ORDER = nil;
				VUHDO_SPEC_LAYOUTS = nil;
				VUHDO_LAST_AUTO_ARRANG = nil;
				VUHDO_RAID = nil;
				VUHDO_INDICATOR_CONFIG = nil;
				VUHDO_EVENT_TIMES = nil;
				VUHDO_SKINS = nil;
				VUHDO_ARRANGEMENTS = nil;
				VUHDO_PROFILES = nil;
				VUHDO_MANUAL_ROLES = nil;
				VUHDO_SPELL_LAYOUTS = nil;
				VUHDO_USER_CLASS_COLORS = nil;
				VUHDO_DEBUFF_BLACKLIST = nil;
				VUHDO_BOUQUETS = nil;
				VUHDO_GLOBAL_CONFIG = nil;
				ReloadUI();
			end
		end
	);
	VuhDoYesNoFrame:Show();
end



--
function VUHDO_newOptionsToolsResetLanguageClicked()
	VuhDoYesNoFrameText:SetText(VUHDO_I18N_RESET_LANGUAGE);
	VuhDoYesNoFrame:SetAttribute("callback",
		function(aDecision)
			if (VUHDO_YES == aDecision) then
				VUHDO_BOUQUETS = nil;
				VUHDO_INDICATOR_CONFIG = nil;
				VUHDO_CONFIG["CUSTOM_DEBUFF"] = nil;
				VUHDO_PANEL_SETUP["HOTS"] = nil;
				VUHDO_CONFIG["RANGE_SPELL"] = nil;
				VUHDO_SPELL_ASSIGNMENTS = nil;
				VUHDO_HOSTILE_SPELL_ASSIGNMENTS = nil;
				VUHDO_SPELL_CONFIG = nil;
				VUHDO_SPELLS_KEYBOARD = nil;
				VUHDO_SPELL_LAYOUTS = nil;
				VUHDO_BUFF_SETTINGS = nil;
				VUHDO_BUFF_ORDER = nil;
				VUHDO_PROFILES = nil;
				VUHDO_DEBUFF_BLACKLIST = nil;
				VUHDO_GLOBAL_CONFIG = nil;
				ReloadUI();
			end
		end
	);
	VuhDoYesNoFrame:Show();
end



--
function VUHDO_newOptionsToolsResetPanelPositionsClicked()
	VuhDoYesNoFrameText:SetText(VUHDO_I18N_RESET_PANEL_POSITIONS);
	VuhDoYesNoFrame:SetAttribute("callback",
		function(aDecision)
			if (VUHDO_YES == aDecision) then
				VUHDO_slashCmd("res");
			end
		end
	);
	VuhDoYesNoFrame:Show();
end



--
function VUHDO_newOptionsToolsResetPerPanelClicked()
	VuhDoYesNoFrameText:SetText(VUHDO_I18N_RESET_PER_PANEL_SETTINGS);
	VuhDoYesNoFrame:SetAttribute("callback",
		function(aDecision)
			if (VUHDO_YES == aDecision) then
				for tPanelNum = 1, VUHDO_MAX_PANELS do
					VUHDO_PANEL_SETUP[tPanelNum] = nil;
				end

				ReloadUI();
			end
		end
	);
	VuhDoYesNoFrame:Show();
end



--
function VUHDO_newOptionsToolsResetSpellsClicked()
	VuhDoYesNoFrameText:SetText(VUHDO_I18N_RESET_PER_KEY_LAYOUTS);
	VuhDoYesNoFrame:SetAttribute("callback",
		function(aDecision)
			if (VUHDO_YES == aDecision) then
				VUHDO_SPELL_ASSIGNMENTS = nil
				VUHDO_HOSTILE_SPELL_ASSIGNMENTS = nil;
				VUHDO_SPELLS_KEYBOARD = nil;
				VUHDO_SPEC_LAYOUTS = nil;
				VUHDO_SPELL_LAYOUTS = nil;
				VUHDO_SPELL_CONFIG = nil;
				ReloadUI();
			end
		end
	);
	VuhDoYesNoFrame:Show();
end
