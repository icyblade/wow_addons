

--
local function VUHDO_toolsHideAllPanels()
	VuhDoNewOptionsToolsSkins:Hide();
	VuhDoNewOptionsToolsKeyLayouts:Hide();
	VuhDoNewOptionsToolsExport:Hide();
	VuhDoNewOptionsToolsWizard:Hide();
	VuhDoNewOptionsToolsReset:Hide();
	VuhDoNewOptionsToolsShare:Hide();
	collectgarbage('collect');
end



--
function VUHDO_newOptionsToolsWizardClicked()
	VUHDO_toolsHideAllPanels();
	VuhDoNewOptionsToolsWizard:Show();
end



--
function VUHDO_newOptionsToolsSkinsClicked()
	VUHDO_toolsHideAllPanels();
	VuhDoNewOptionsToolsSkins:Show();
end



--
function VUHDO_newOptionsToolsResetClicked()
	VUHDO_toolsHideAllPanels();
	VuhDoNewOptionsToolsReset:Show();
end



--
function VUHDO_newOptionsToolsKeyLayoutsClicked()
	VUHDO_toolsHideAllPanels();
	VuhDoNewOptionsToolsKeyLayouts:Show();
end



--
function VUHDO_newOptionsToolsExportClicked()
	VUHDO_toolsHideAllPanels();
	VuhDoNewOptionsToolsExport:Show();
end



--
function VUHDO_newOptionsToolsShareClicked()
	VUHDO_toolsHideAllPanels();
	VuhDoNewOptionsToolsShare:Show();
end