

--
local function VUHDO_hideAllPanel()
	VuhDoNewOptionsDebuffsStandard:Hide();
	VuhDoNewOptionsDebuffsCustom:Hide();
	VuhDoNewOptionsDebuffsCustomVisuals:Hide();
	collectgarbage('collect');
end



--
function VUHDO_newOptionsDebuffsCustomClicked()
	VUHDO_hideAllPanel();
	VuhDoNewOptionsDebuffsCustom:Show();
end



--
function VUHDO_newOptionsDebuffsStandardClicked()
	VUHDO_hideAllPanel();
	VuhDoNewOptionsDebuffsStandard:Show();
end



--
function VUHDO_newOptionsDebuffsCustomVisualsClicked()
	VUHDO_hideAllPanel();
	VuhDoNewOptionsDebuffsCustomVisuals:Show();
end
