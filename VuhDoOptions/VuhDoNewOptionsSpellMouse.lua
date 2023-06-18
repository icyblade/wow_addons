local _;
VUHDO_CURR_SPELL_MODIFIER = "";


function VUHDO_newOptionsSpellSetModifier(aModifier)
	local tComponents;
	local tNum;
	local tModel;
	local tBox;
	local tIndex;

	VUHDO_CURR_SPELL_MODIFIER = aModifier;

	tComponents = { VuhDoNewOptionsSpellMouseKeyPanelScrollPanelChild:GetChildren() };
	for _, tPanel in pairs(tComponents) do
		tNum = VUHDO_getNumbersFromString(tPanel:GetName(), 1)[1];
		if (tNum ~= nil) then
			tBox = _G[tPanel:GetName() .. "EditBox"];
			tIndex = aModifier .. tNum;
			if (VUHDO_SPELL_ASSIGNMENTS[tIndex] == nil) then
				VUHDO_SPELL_ASSIGNMENTS[tIndex] = { VUHDO_MODIFIER_KEYS[tIndex], tostring(tNum), "" };
			end
			tModel = "VUHDO_SPELL_ASSIGNMENTS." .. tIndex .. ".##3";
			tBox:SetAttribute("model", tModel);
			tBox:Hide();
			tBox:Show();
		end
	end

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
function VUHDO_newOptionsSpellEditBoxCheckSpell(anEditBox, anIsCustom)
	local tText, tR, tG, tB = VUHDO_isActionValid(anEditBox:GetText(), anIsCustom);
	local tLabel = _G[anEditBox:GetName() .. "Hint"];
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
local sButtonTitles = {
	VUHDO_I18N_LEFT_BUTTON,
	VUHDO_I18N_RIGHT_BUTTON,
	VUHDO_I18N_MIDDLE_BUTTON,
	VUHDO_I18N_BUTTON_4,
	VUHDO_I18N_BUTTON_5,
}



--
local function VUHDO_addSpellEditBox(aScrollPanel, anIndex)
	local tFrame = CreateFrame("Frame", aScrollPanel:GetName() .. "E" .. anIndex, aScrollPanel, "VuhDoNewOptionsSpellMouseEditBoxTemplate");
	tFrame:SetPoint("TOPLEFT", aScrollPanel:GetName(), "TOPLEFT", 23, -(anIndex - 1) * tFrame:GetHeight() - 7);
	_G[tFrame:GetName() .. "LabelLabel"]:SetText(sButtonTitles[anIndex] or (VUHDO_I18N_BUTTON .. " " .. anIndex));
	return tFrame;
end



--
function VUHDO_newOptionsSpellMouseScrollPanelOnLoad(aScrollPanel)
	local tFrame;
	for tCnt = 1, VUHDO_NUM_MOUSE_BUTTONS do
		tFrame = VUHDO_addSpellEditBox(aScrollPanel, tCnt);
	end

	aScrollPanel:SetHeight(VUHDO_NUM_MOUSE_BUTTONS * tFrame:GetHeight() + 18);
end
