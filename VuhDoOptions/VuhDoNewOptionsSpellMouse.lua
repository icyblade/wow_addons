VUHDO_CURR_SPELL_MODIFIER = "";


local tComponents = { };
local tNum;
local tModel;
local tPanel, tBox, tComp;
function VUHDO_newOptionsSpellSetModifier(aModifier)
	VUHDO_CURR_SPELL_MODIFIER = aModifier;

	table.wipe(tComponents);
	tComponents = { VuhDoNewOptionsSpellMouseKeyPanelScrollPanelChild:GetChildren() };

	for _, tPanel in pairs(tComponents) do
		local tNum = VUHDO_getNumbersFromString(tPanel:GetName(), 1)[1];
		if (tNum ~= nil) then
			tBox = VUHDO_GLOBAL[tPanel:GetName() .. "EditBox"];
			tModel = "VUHDO_SPELL_ASSIGNMENTS." .. aModifier .. tNum .. ".##3";
			tBox:SetAttribute("model", tModel);
			tBox:Hide();
			tBox:Show();
		end
	end

	table.wipe(tComponents);
	tComponents = { VuhDoNewOptionsSpellMouseWheelPanel:GetChildren() };

	for _, tComp in pairs(tComponents) do
		if (tComp:IsObjectType("EditBox")) then
			tNum = VUHDO_getComponentPanelNum(tComp);
			tModel = "VUHDO_SPELLS_KEYBOARD.WHEEL." .. aModifier .. tNum .. ".##3";
			tComp:SetAttribute("model", tModel);
			tComp:Hide();
			tComp:Show();
		end
	end

end



--
local tText, tLabel, tR, tG, tB;
function VUHDO_newOptionsSpellEditBoxCheckSpell(anEditBox, anIsCustom)
	tText, tR, tG, tB = VUHDO_isActionValid(anEditBox:GetText(), anIsCustom);
	tLabel = VUHDO_GLOBAL[anEditBox:GetName() .. "Hint"];
	if (tText ~= nil) then
		anEditBox:SetTextColor(1, 1, 1, 1);
		tLabel:SetText(tText);
		tLabel:SetTextColor(tR, tG, tB, 1);
	else
		anEditBox:SetTextColor(0.8, 0.8, 1, 1);
		tLabel:SetText("");
	end
end



--
local VUHDO_BUTTON_TEXTS = {
	VUHDO_I18N_LEFT_BUTTON,
	VUHDO_I18N_RIGHT_BUTTON,
	VUHDO_I18N_MIDDLE_BUTTON,
	VUHDO_I18N_BUTTON_4,
	VUHDO_I18N_BUTTON_5,
	VUHDO_I18N_BUTTON_6,
	VUHDO_I18N_BUTTON_7,
	VUHDO_I18N_BUTTON_8,
	VUHDO_I18N_BUTTON_9,
	VUHDO_I18N_BUTTON_10,
	VUHDO_I18N_BUTTON_11,
	VUHDO_I18N_BUTTON_12,
	VUHDO_I18N_BUTTON_13,
	VUHDO_I18N_BUTTON_14,
	VUHDO_I18N_BUTTON_15,
	VUHDO_I18N_BUTTON_16,
}



--
local function VUHDO_addSpellEditBox(aScrollPanel, anIndex)
	local tFrame = CreateFrame("Frame", aScrollPanel:GetName() .. "E" .. anIndex, aScrollPanel, "VuhDoNewOptionsSpellMouseEditBoxTemplate");
	tFrame:SetPoint("TOPLEFT", aScrollPanel:GetName(), "TOPLEFT", 23, -(anIndex - 1) * tFrame:GetHeight() - 7);
	VUHDO_GLOBAL[tFrame:GetName() .. "LabelLabel"]:SetText(VUHDO_BUTTON_TEXTS[anIndex] or "");
	return tFrame;
end



--
function VUHDO_newOptionsSpellMouseScrollPanelOnLoad(aScrollPanel)
	local tCnt;
	local tFrame;
	for tCnt = 1, VUHDO_NUM_MOUSE_BUTTONS do
		tFrame = VUHDO_addSpellEditBox(aScrollPanel, tCnt);
	end

	aScrollPanel:SetHeight(VUHDO_NUM_MOUSE_BUTTONS * tFrame:GetHeight() + 18);
end
