local _;
VUHDO_DEBUFF_IGNORE_COMBO_MODEL = { };
VUHDO_SELECTED_DEBUFF_IGNORE = "";



--
function VUHDO_initDebuffIgnoreComboModel()
	table.wipe(VUHDO_DEBUFF_IGNORE_COMBO_MODEL);
	for tName, _ in pairs(VUHDO_DEBUFF_BLACKLIST) do
		tinsert(VUHDO_DEBUFF_IGNORE_COMBO_MODEL, { tName, tName });
	end
end



--
local tText;
function VUHDO_saveDebuffIgnoreClicked(aButton)
	local tText = _G[aButton:GetParent():GetName() .. "IgnoreComboBoxEditBox"]:GetText();
	if (tText ~= nil) then
		VUHDO_DEBUFF_BLACKLIST[strtrim(tText)] = true;
		VUHDO_initDebuffIgnoreComboModel();
		_G[aButton:GetParent():GetName() .. "IgnoreComboBox"]:Hide();
		_G[aButton:GetParent():GetName() .. "IgnoreComboBox"]:Show();
	end
end



--
function VUHDO_deleteDebuffIgnoreClicked(aButton)
	local tText = _G[aButton:GetParent():GetName() .. "IgnoreComboBoxEditBox"]:GetText();
	if (tText ~= nil) then
		VUHDO_DEBUFF_BLACKLIST[strtrim(tText)] = nil;
		VUHDO_initDebuffIgnoreComboModel();
		_G[aButton:GetParent():GetName() .. "IgnoreComboBox"]:Hide();
		_G[aButton:GetParent():GetName() .. "IgnoreComboBox"]:Show();
	end
end
