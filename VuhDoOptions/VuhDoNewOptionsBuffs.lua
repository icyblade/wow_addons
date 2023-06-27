

--
local function VUHDO_hideAllPanels()
	VuhDoNewOptionsBuffsGeneric:Hide();
	VuhDoNewOptionsBuffsAppearance:Hide();
	VuhDoNewOptionsBuffsColors:Hide();
	VuhDoNewOptionsBuffsRebuff:Hide();
end



--
function VUHDO_newOptionsBuffsConfigClicked()
	VUHDO_hideAllPanels();
	VuhDoNewOptionsBuffsGeneric:Show();
end



--
function VUHDO_newOptionsBuffsGeneralClicked()
	VUHDO_hideAllPanels();
	VuhDoNewOptionsBuffsAppearance:Show();
end



--
function VUHDO_newOptionsBuffsColorsClicked()
	VUHDO_hideAllPanels();
	VuhDoNewOptionsBuffsColors:Show();
end



--
function VUHDO_newOptionsBuffsRebuffClicked()
	VUHDO_hideAllPanels();
	VuhDoNewOptionsBuffsRebuff:Show();
end

