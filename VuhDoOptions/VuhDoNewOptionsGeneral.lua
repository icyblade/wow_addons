VUHDO_MENU_RETURN_TARGET = nil;
VUHDO_MENU_RETURN_TARGET_MAIN = nil;


local function VUHDO_hideAllPanel()
	VuhDoNewOptionsGeneralBasic:Hide();
	VuhDoNewOptionsGeneralScan:Hide();
	VuhDoNewOptionsGeneralAoeAdvice:Hide();
	VuhDoNewOptionsGeneralThreat:Hide();
	VuhDoNewOptionsGeneralMisc:Hide();
	VuhDoNewOptionsGeneralCluster:Hide();
	VuhDoNewOptionsGeneralBouquet:Hide();
	VuhDoNewOptionsGeneralIndicators:Hide();
	collectgarbage('collect');
end



--
function VUHDO_newOptionsGeneralBasicClicked(self)
	VUHDO_hideAllPanel();
	VuhDoNewOptionsGeneralBasic:Show();
end



--
function VUHDO_newOptionsGeneralScannersClicked(self)
	VUHDO_hideAllPanel();
	VuhDoNewOptionsGeneralScan:Show();
end



--
function VUHDO_newOptionsGeneralAoeAdviceClicked(self)
	VUHDO_hideAllPanel();
	VuhDoNewOptionsGeneralAoeAdvice:Show();
end



--
function VUHDO_newOptionsGeneralThreatClicked(self)
	VUHDO_hideAllPanel();
	VuhDoNewOptionsGeneralThreat:Show();
end



--
function VUHDO_newOptionsGeneralMiscClicked(self)
	VUHDO_hideAllPanel();
	VuhDoNewOptionsGeneralMisc:Show();
end



--
function VUHDO_newOptionsGeneralIndicatorsClicked(self)
	VUHDO_hideAllPanel();
	VUHDO_MENU_RETURN_TARGET = nil;
	VUHDO_MENU_RETURN_TARGET_MAIN = nil;
	VuhDoNewOptionsGeneralIndicators:Show();
end



--
function VUHDO_newOptionsGeneralClusterClicked(self)
	VUHDO_hideAllPanel();
	VuhDoNewOptionsGeneralCluster:Show()
end



--
function VUHDO_newOptionsGeneralBouquetClicked(self)
	VUHDO_hideAllPanel();
	VuhDoNewOptionsGeneralBouquet:Show();
end




