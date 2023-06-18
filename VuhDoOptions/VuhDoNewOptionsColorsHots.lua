


--
function VUHDO_initHotTimerRadioButton(aButton, aMode)
	VUHDO_lnfSetRadioModel(aButton, "VUHDO_PANEL_SETUP.BAR_COLORS.HOT"
		.. VUHDO_getNumbersFromString(aButton:GetName(), 1)[1]
		.. ".countdownMode", aMode);
end



--
function VUHDO_initHotTimerCheckButton(aButton)
	VUHDO_lnfSetModel(aButton, "VUHDO_PANEL_SETUP.BAR_COLORS.HOT"
		.. VUHDO_getNumbersFromString(aButton:GetName(), 1)[1]
		.. ".isFullDuration");
end



--
function VUHDO_initHotClockCheckButton(aButton)
	VUHDO_lnfSetModel(aButton, "VUHDO_PANEL_SETUP.BAR_COLORS.HOT"
		.. VUHDO_getNumbersFromString(aButton:GetName(), 1)[1]
		.. ".isClock");
end



--
function	VUHDO_colorsHotsSetSwatchHotName(aTexture, aHotNum)
	tHotName = VUHDO_PANEL_SETUP["HOTS"]["SLOTS"][aHotNum] or "";

	if (not VUHDO_strempty(tHotName)) then
		_G[aTexture:GetName() .. "TitleString"]:SetText(gsub(tHotName, "BOUQUET_", ""));
	end
end

