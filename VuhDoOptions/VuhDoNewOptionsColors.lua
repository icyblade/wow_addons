local function VUHDO_hideAllPanel()
	VuhDoNewOptionsColorsModes:Hide();
	VuhDoNewOptionsColorsStates:Hide();
	VuhDoNewOptionsColorsPowers:Hide();
	VuhDoNewOptionsColorsHots:Hide();
	VuhDoNewOptionsColorsHotCharges:Hide();
	VuhDoNewOptionsColorsClasses:Hide();
	VuhDoNewOptionsColorsRaidIcons:Hide();
	VuhDoNewOptionsColorsTargets:Hide();
	collectgarbage('collect');
end



--
function VUHDO_newOptionsColorsStatesClicked()
	VUHDO_hideAllPanel();
	VuhDoNewOptionsColorsStates:Show();
end



--
function VUHDO_newOptionsColorsModesClicked()
	VUHDO_hideAllPanel();
	VuhDoNewOptionsColorsModes:Show();
end



--
function VUHDO_newOptionsColorsPowersClicked(elf)
	VUHDO_hideAllPanel();
	VuhDoNewOptionsColorsPowers:Show();
end



--
function VUHDO_newOptionsColorsHotsClicked()
	VUHDO_hideAllPanel();
	VuhDoNewOptionsColorsHots:Show();
end



--
function VUHDO_newOptionsColorsHotChargesClicked()
	VUHDO_hideAllPanel();
	VuhDoNewOptionsColorsHotCharges:Show();
end



--
function VUHDO_newOptionsColorsClassesClicked()
	VUHDO_hideAllPanel();
	VuhDoNewOptionsColorsClasses:Show();
end



--
function VUHDO_newOptionsColorsRaidIconsClicked()
	VUHDO_hideAllPanel();
	VuhDoNewOptionsColorsRaidIcons:Show();
end


--
function VUHDO_newOptionsColorsTargetsClicked()
	VUHDO_hideAllPanel();
	VuhDoNewOptionsColorsTargets:Show();
end