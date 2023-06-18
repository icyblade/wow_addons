local _;
VUHDO_KEY_LAYOUT_COMBO_MODEL = { };
VUHDO_CURR_LAYOUT = "";



--
function VUHDO_initKeyLayoutComboModel()
	table.wipe(VUHDO_KEY_LAYOUT_COMBO_MODEL);

	for tName, _ in pairs(VUHDO_SPELL_LAYOUTS) do
		tinsert(VUHDO_KEY_LAYOUT_COMBO_MODEL, { tName, tName });
	end

	table.sort(VUHDO_KEY_LAYOUT_COMBO_MODEL,
		function(anInfo, anotherInfo)
			return anInfo[1] < anotherInfo[1];
		end
	);

	tinsert(VUHDO_KEY_LAYOUT_COMBO_MODEL, 1, {"", " -- " .. VUHDO_I18N_KEY_NONE .. " --" });
end



--
function VUHDO_keyLayoutComboChanged(aComboBox, aValue)
	local tParentName = aComboBox:GetParent():GetName();

	local tSpec1CheckButton = _G[tParentName .. "Spec1CheckButton"];
	tSpec1CheckButton:SetChecked(aValue == VUHDO_SPEC_LAYOUTS["1"]);
	VUHDO_lnfCheckButtonClicked(tSpec1CheckButton);

	local tSpec2CheckButton =  _G[tParentName .. "Spec2CheckButton"];
	tSpec2CheckButton:SetChecked(aValue == VUHDO_SPEC_LAYOUTS["2"]);
	VUHDO_lnfCheckButtonClicked(tSpec2CheckButton);
end



--
function VUHDO_keyLayoutSpecOnClick(aCheckButton, aSpecId)
	if (not VUHDO_strempty(VUHDO_CURR_LAYOUT)) then
		VUHDO_SPEC_LAYOUTS[aSpecId] = aCheckButton:GetChecked() and VUHDO_CURR_LAYOUT or "";
	else
		VUHDO_Msg(VUHDO_I18N_SELECT_KEY_LAYOUT_FIRST, 1, 0.4, 0.4);
	end
end



--
function VUHDO_deleteKeyLayoutCallback(aDecision)
	if (VUHDO_YES == aDecision) then
		VUHDO_Msg(format(VUHDO_I18N_DELETED_KEY_LAYOUT, VUHDO_CURR_LAYOUT));
		VUHDO_SPELL_LAYOUTS[VUHDO_CURR_LAYOUT] = nil;
		if (VUHDO_CURR_LAYOUT == VUHDO_SPEC_LAYOUTS["selected"]) then
			VUHDO_SPEC_LAYOUTS["selected"] = "";
			VUHDO_CURR_LAYOUT = "";
		else
			VUHDO_CURR_LAYOUT = VUHDO_SPEC_LAYOUTS["selected"];
		end

		VUHDO_initKeyLayoutComboModel();
		VuhDoNewOptionsToolsKeyLayouts:Hide();
		VuhDoNewOptionsToolsKeyLayouts:Show();
	end
end



--
function VUHDO_keyLayoutDeleteOnClick(aButton)
	if (VUHDO_CURR_LAYOUT ~= nil and VUHDO_CURR_LAYOUT ~= "") then
		VuhDoYesNoFrameText:SetText(format(VUHDO_I18N_DELETE_KEY_LAYOUT_QUESTION, VUHDO_CURR_LAYOUT));
		VuhDoYesNoFrame:SetAttribute("callback", VUHDO_deleteKeyLayoutCallback);
		VuhDoYesNoFrame:Show();
	else
		VUHDO_Msg(VUHDO_I18N_SELECT_KEY_LAYOUT_FIRST, 1, 0.4, 0.4);
	end
end



--
function VUHDO_applyKeyLayoutCallback(aDecision)
	if (VUHDO_YES == aDecision) then
		VUHDO_SPEC_LAYOUTS["selected"] = VUHDO_CURR_LAYOUT;
		VUHDO_activateLayout(VUHDO_CURR_LAYOUT);
	end
end



--
function VUHDO_keyLayoutApplyOnClick(aButton)
	if (VUHDO_CURR_LAYOUT ~= nil and VUHDO_CURR_LAYOUT ~= "") then
		VuhDoYesNoFrameText:SetText(VUHDO_I18N_OVERWRITE_CURR_KEY_LAYOUT_QUESTION);
		VuhDoYesNoFrame:SetAttribute("callback", VUHDO_applyKeyLayoutCallback);
		VuhDoYesNoFrame:Show();
	else
		VUHDO_Msg(VUHDO_I18N_SELECT_KEY_LAYOUT_FIRST, 1, 0.4, 0.4);
	end
end


--
function VUHDO_saveKeyLayoutCallback(aDecision)
	if (VUHDO_YES == aDecision) then
		VUHDO_SPELL_LAYOUTS[VUHDO_CURR_LAYOUT] = {
			["MOUSE"] = VUHDO_compressTable(VUHDO_SPELL_ASSIGNMENTS),
			["HOSTILE_MOUSE"] = VUHDO_compressTable(VUHDO_HOSTILE_SPELL_ASSIGNMENTS),
			["KEYS"] = VUHDO_compressTable(VUHDO_SPELLS_KEYBOARD),
			["FIRE"] = {
				["T1"] = VUHDO_SPELL_CONFIG["IS_FIRE_TRINKET_1"],
				["T2"] = VUHDO_SPELL_CONFIG["IS_FIRE_TRINKET_2"],
				["I1"] = VUHDO_SPELL_CONFIG["IS_FIRE_CUSTOM_1"],
				["I2"] = VUHDO_SPELL_CONFIG["IS_FIRE_CUSTOM_2"],
				["I1N"] = VUHDO_SPELL_CONFIG["FIRE_CUSTOM_1_SPELL"],
				["I2N"] = VUHDO_SPELL_CONFIG["FIRE_CUSTOM_2_SPELL"],
				["T3"] = VUHDO_SPELL_CONFIG["IS_FIRE_GLOVES"],
			},
			["HOTS"] = VUHDO_compressTable(VUHDO_PANEL_SETUP["HOTS"]),
		};

		VUHDO_SPEC_LAYOUTS["selected"] = VUHDO_CURR_LAYOUT;

		VUHDO_Msg(format(VUHDO_I18N_KEY_LAYOUT_SAVED, VUHDO_CURR_LAYOUT));
		VUHDO_initKeyLayoutComboModel();
		VUHDO_lnfComboBoxInitFromModel(VuhDoNewOptionsToolsKeyLayoutsStorePanelLayoutCombo);
	end
end



--
function VUHDO_saveKeyLayoutOnClick(aButton)
	local tEditBox = _G[aButton:GetParent():GetName() .. "SaveAsEditBox"];
	VUHDO_CURR_LAYOUT = strtrim(tEditBox:GetText());

	if #VUHDO_CURR_LAYOUT == 0 then
		VUHDO_Msg(VUHDO_I18N_ENTER_KEY_LAYOUT_NAME, 1, 0.4, 0.4);
		return;
	end

	if VUHDO_SPELL_LAYOUTS[VUHDO_CURR_LAYOUT] then
		VuhDoYesNoFrameText:SetText(format(VUHDO_I18N_OVERWRITE_KEY_LAYOUT_QUESTION, VUHDO_CURR_LAYOUT));
		VuhDoYesNoFrame:SetAttribute("callback", VUHDO_saveKeyLayoutCallback);
		VuhDoYesNoFrame:Show();
	else
		VUHDO_saveKeyLayoutCallback(VUHDO_YES);
	end
end



--
function VUHDO_shareCurrentKeyLayout(aUnitName, aKeyLayoutName)
	local tLayout = VUHDO_SPELL_LAYOUTS[aKeyLayoutName];
	if not tLayout then
		VUHDO_Msg("There is no key layout named \"" .. (aKeyLayoutName or "") .. "\"", 1, 0.4, 0.4);
		return;
	end

	local tQuestion = VUHDO_PLAYER_NAME .. " requests to transmit\nKey Layout " .. aKeyLayoutName .. " to you.\nProceed?"
	VUHDO_startShare(aUnitName, { aKeyLayoutName, tLayout }, sCmdKeyLayoutDataChunk, sCmdKeyLayoutDataEnd, tQuestion);
end
