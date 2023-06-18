local VUHDO_COLOR_SWATCH;
local VUHDO_COLOR;
local VUHDO_PROHIBIT;
local sIsTextEdit;
local VUHDO_origColor;
local VUHDO_copyPasteColor = { };

--
local function VUHDO_mayEditText()
	return VUHDO_COLOR.TR ~= nil and not strfind(VUHDO_PROHIBIT, "T", 1, true);
end



--
local function VUHDO_mayEditBackground()
	return VUHDO_COLOR.R ~= nil and not strfind(VUHDO_PROHIBIT, "B", 1, true);
end



--
local function VUHDO_backOrTextColor(aColor, anIsText)
	if anIsText then return VUHDO_textColor(aColor);
	else return VUHDO_backColor(aColor); end
end



--
function VUHDO_setPickerColor(aPanel)
	local tR, tG, TB, tO = VUHDO_backOrTextColor(VUHDO_COLOR, sIsTextEdit);

	aPanel:SetColorRGB(tR, tG, TB);
	VuhDoColorPickerColorSwatchOld:SetTexture(tR, tG, TB);
	_G[aPanel:GetName() .. "OpacitySliderFrame"]:SetShown(tO ~= nil and not strfind(VUHDO_PROHIBIT, "O"));
	_G[aPanel:GetName() .. "OpacitySliderFrameSlider"]:SetValue(floor(tO * 100));
end



--
function VUHDO_newColorPickerOnShow(aPanel)
	local tDescription;

	VUHDO_COLOR_SWATCH = aPanel:GetAttribute("swatch");
	VUHDO_COLOR = VUHDO_lnfGetValueFromModel(VUHDO_COLOR_SWATCH);

	if (VUHDO_COLOR == nil) then
		VuhDoNewColorPicker:Hide();
		return;
	end

	VUHDO_origColor = VUHDO_deepCopyTable(VUHDO_COLOR);

	tDescription = VUHDO_COLOR_SWATCH:GetAttribute("description");
	VUHDO_PROHIBIT = VUHDO_COLOR_SWATCH:GetAttribute("prohibit");

	if (VUHDO_PROHIBIT == nil) then
		VUHDO_PROHIBIT = "";
	end

	if (tDescription ~= nil) then
		_G[aPanel:GetName() .. "TitleLabelLabel"]:SetText("Select " .. tDescription .. " [Drag here]");
	else
		_G[aPanel:GetName() .. "TitleLabelLabel"]:SetText("Color Select [Drag here]");
	end

	if (VUHDO_mayEditBackground() and VUHDO_mayEditText()) then
		_G[aPanel:GetName() .. "BackgroundRadioButton"]:SetChecked(true);
		VUHDO_lnfRadioButtonClicked(_G[aPanel:GetName() .. "BackgroundRadioButton"]);
		_G[aPanel:GetName() .. "TextRadioButton"]:Show();
		_G[aPanel:GetName() .. "BackgroundRadioButton"]:Show();
		sIsTextEdit = false;
	else
		_G[aPanel:GetName() .. "TextRadioButton"]:Hide();
		_G[aPanel:GetName() .. "BackgroundRadioButton"]:Hide();
		sIsTextEdit = VUHDO_mayEditText();
	end

	VUHDO_setPickerColor(aPanel);
end



--
function VUHDO_colorPickerOnColorSelect(anR, anG, anB)
	if (sIsTextEdit) then
		VUHDO_COLOR.TR = anR;
		VUHDO_COLOR.TG = anG;
		VUHDO_COLOR.TB = anB;
	else
		VUHDO_COLOR.R = anR;
		VUHDO_COLOR.G = anG;
		VUHDO_COLOR.B = anB;
	end
	VUHDO_lnfColorSwatchInitFromModel(VUHDO_COLOR_SWATCH);
	VUHDO_lnfUpdateVarFromModel(VUHDO_COLOR_SWATCH, VUHDO_COLOR);
end



--
function VUHDO_colorPickerOkay()
	VUHDO_lnfUpdateVarFromModel(VUHDO_COLOR_SWATCH, VUHDO_COLOR);
end



--
function VUHDO_colorPickerCancel()
	VUHDO_COLOR = VUHDO_origColor;
	VUHDO_lnfUpdateVarFromModel(VUHDO_COLOR_SWATCH, VUHDO_COLOR);
	VUHDO_lnfColorSwatchInitFromModel(VUHDO_COLOR_SWATCH);
end



--
function VUHDO_colorPickerBackgroundClicked(aPanel)
	sIsTextEdit = false;
	VUHDO_setPickerColor(aPanel);
end



--
function VUHDO_colorPickerTextClicked(aPanel)
	sIsTextEdit = true;
	VUHDO_setPickerColor(aPanel);
end



local function VUHDO_colorPickerSetColorCode()
	local tR, tG, tB, tO = VUHDO_backOrTextColor(VUHDO_COLOR, sIsTextEdit)
	VuhDoColorPickerColorCodeEditBox:SetText(
		format("%02x%02x%02x%02x", tO * 255, tR * 255, tG * 255, tB * 255));
end



--
function VUHDO_colorPickerOpacityValueChanged(aSlider)
	local tValue;
	if (VUHDO_COLOR ~= nil) then
		tValue = _G[aSlider:GetName() .. "Slider"]:GetValue() * 0.01;
		if (sIsTextEdit) then
			VUHDO_COLOR.TO = tValue;
		else
			VUHDO_COLOR.O = tValue;
		end
		VUHDO_lnfColorSwatchInitFromModel(VUHDO_COLOR_SWATCH);
		VUHDO_lnfUpdateVarFromModel(VUHDO_COLOR_SWATCH, VUHDO_COLOR);
		VUHDO_colorPickerSetColorCode();
	end
end



--
function VUHDO_colorPickerCopy()
	table.wipe(VUHDO_copyPasteColor);

	if (VUHDO_mayEditText()) then
		VUHDO_copyPasteColor.TR = VUHDO_COLOR.TR;
		VUHDO_copyPasteColor.TG = VUHDO_COLOR.TG;
		VUHDO_copyPasteColor.TB = VUHDO_COLOR.TB;
		if (not strfind(VUHDO_PROHIBIT, "O") and VUHDO_COLOR.TO ~= nil) then
			VUHDO_copyPasteColor.TO = VUHDO_COLOR.TO;
		end
	end

	if (VUHDO_mayEditBackground()) then
		VUHDO_copyPasteColor.R = VUHDO_COLOR.R;
		VUHDO_copyPasteColor.G = VUHDO_COLOR.G;
		VUHDO_copyPasteColor.B = VUHDO_COLOR.B;
		if (not strfind(VUHDO_PROHIBIT, "O") and VUHDO_COLOR.TO ~= nil) then
			VUHDO_copyPasteColor.O = VUHDO_COLOR.O;
		end
	end
end



--
function VUHDO_colorPickerPaste(aPanel)
	if (VUHDO_tableCount(VUHDO_copyPasteColor) == 0) then
		return;
	end

	if (VUHDO_mayEditText()) then
		VUHDO_COLOR.TR = VUHDO_copyPasteColor.TR or VUHDO_COLOR.TR;
		VUHDO_COLOR.TG = VUHDO_copyPasteColor.TG or VUHDO_COLOR.TG;
		VUHDO_COLOR.TB = VUHDO_copyPasteColor.TB or VUHDO_COLOR.TB;
		if (not strfind(VUHDO_PROHIBIT, "O") and VUHDO_COLOR.TO ~= nil) then
			VUHDO_COLOR.TO = VUHDO_copyPasteColor.TO or VUHDO_COLOR.TO;
		end
	end

	if (VUHDO_mayEditBackground()) then
		VUHDO_COLOR.R = VUHDO_copyPasteColor.R or VUHDO_COLOR.R;
		VUHDO_COLOR.G = VUHDO_copyPasteColor.G or VUHDO_COLOR.G;
		VUHDO_COLOR.B = VUHDO_copyPasteColor.B or VUHDO_COLOR.B;
		if (not strfind(VUHDO_PROHIBIT, "O") and VUHDO_COLOR.TO ~= nil) then
			VUHDO_COLOR.O = VUHDO_copyPasteColor.O or VUHDO_COLOR.O;
		end
	end

	VUHDO_setPickerColor(aPanel);
	VUHDO_lnfColorSwatchInitFromModel(VUHDO_COLOR_SWATCH);
	VUHDO_lnfUpdateVarFromModel(VUHDO_COLOR_SWATCH, VUHDO_COLOR);
end



--
function VUHDO_colorPickerColorSelectCallback(anInstance, aR, aG, aB)
	VuhDoColorPickerColorSwatchNew:SetTexture(aR, aG, aB);
	VUHDO_colorPickerOnColorSelect(aR, aG, aB);
	VUHDO_colorPickerSetColorCode();
	VUHDO_setColorCodeTextColor();
end



--
function VUHDO_setColorCodeTextColor()
	if (strmatch(VuhDoColorPickerColorCodeEditBox:GetText(),
		"^[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]$")) then
		VuhDoColorPickerColorCodeEditBox:SetTextColor(0.8, 0.8, 1, 1);
		return true;
	else
		VuhDoColorPickerColorCodeEditBox:SetTextColor(1,0,0,1);
		return false;
	end
end



--
local function VUHDO_hexToInt(aHexString)
	local tValue = 0;
	local tByte;

	for tCnt = 1, #aHexString do
		tValue = tValue * 16;
		tByte = strbyte(aHexString, tCnt);

		if (tByte >= 48 and tByte <= 57) then
			tByte = tByte - 48;
		elseif (tByte >= 97 and tByte <= 102) then
			tByte = tByte - 87;
		end

		tValue = tValue + tByte;
	end

	return tValue;
end



--
function VUHDO_updateColorByCode(aPanel)
	if (VUHDO_setColorCodeTextColor()) then
		local tText = strlower(VuhDoColorPickerColorCodeEditBox:GetText());

		local tO = VUHDO_hexToInt(strsub(tText, 1, 2)) / 255;
		local tR = VUHDO_hexToInt(strsub(tText, 3, 4)) / 255;
		local tG = VUHDO_hexToInt(strsub(tText, 5, 6)) / 255;
		local tB = VUHDO_hexToInt(strsub(tText, 7, 8)) / 255;

		if (sIsTextEdit) then
			VUHDO_COLOR.TR = tR;
			VUHDO_COLOR.TG = tG;
			VUHDO_COLOR.TB = tB;
			if (not strfind(VUHDO_PROHIBIT, "O") and VUHDO_COLOR.TO ~= nil) then
				VUHDO_COLOR.TO = tO;
			end
		else
			VUHDO_COLOR.R = tR;
			VUHDO_COLOR.G = tG;
			VUHDO_COLOR.B = tB;
			if (not strfind(VUHDO_PROHIBIT, "O") and VUHDO_COLOR.O ~= nil) then
				VUHDO_COLOR.O = tO;
			end
		end

		VUHDO_setPickerColor(aPanel);
		VUHDO_lnfColorSwatchInitFromModel(VUHDO_COLOR_SWATCH);
		VUHDO_lnfUpdateVarFromModel(VUHDO_COLOR_SWATCH, VUHDO_COLOR);
	end
end
