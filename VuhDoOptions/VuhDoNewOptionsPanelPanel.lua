--
local function VUHDO_hideAllPanel()
	VuhDoNewOptionsPanelBasic:Hide();
	VuhDoNewOptionsPanelSize:Hide();
	VuhDoNewOptionsPanelBars:Hide();
	VuhDoNewOptionsPanelHeader:Hide();
	VuhDoNewOptionsPanelTarget:Hide();
	VuhDoNewOptionsPanelText:Hide();
	VuhDoNewOptionsPanelTooltip:Hide();
	VuhDoNewOptionsPanelHots:Hide();
	VuhDoNewOptionsPanelHotBars:Hide();
	VuhDoNewOptionsPanelMisc:Hide();
	collectgarbage('collect');
end


--
function VUHDO_newOptionsPanelHeaderClicked(aCheckButton)
	VUHDO_hideAllPanel();
	VuhDoNewOptionsPanelHeader:Show();
end



--
function VUHDO_newOptionsPanelBasicClicked(aCheckButton)
	VUHDO_hideAllPanel();
	VuhDoNewOptionsPanelBasic:Show();
end



--
function VUHDO_newOptionsPanelTooltipClicked(aCheckButton)
	VUHDO_hideAllPanel();
	VuhDoNewOptionsPanelTooltip:Show();
end



--
function VUHDO_newOptionsPanelTextClicked(aCheckButton)
	VUHDO_hideAllPanel();
	VuhDoNewOptionsPanelText:Show();
end



--
function VUHDO_newOptionsPanelTargetClicked(aCheckButton)
	VUHDO_hideAllPanel();
	VuhDoNewOptionsPanelTarget:Show();
end



--
function VUHDO_newOptionsPanelSizeClicked(aCheckButton)
	VUHDO_hideAllPanel();
	VuhDoNewOptionsPanelSize:Show();
end



--
function VUHDO_newOptionsPanelBarsClicked(aCheckButton)
	VUHDO_hideAllPanel();
	VuhDoNewOptionsPanelBars:Show();
end



--
local tCnt;
local tMaxModels;
function VUHDO_newOptionsPanelFindDefaultPanel()
	tMaxModels = -1;
	DESIGN_MISC_PANEL_NUM = 1;

	for tCnt = 1, VUHDO_MAX_PANELS do
		if (VUHDO_PANEL_MODELS[tCnt] ~= nil and #VUHDO_PANEL_MODELS[tCnt] > tMaxModels) then
			DESIGN_MISC_PANEL_NUM = tCnt;
			tMaxModels = #VUHDO_PANEL_MODELS[tCnt];
		end
	end
end



--
function VUHDO_newOptionsPanelHotsClicked()
	VUHDO_hideAllPanel();
	VuhDoNewOptionsPanelHots:Show();
end



--
function VUHDO_newOptionsPanelHotBarsClicked()
	VUHDO_hideAllPanel();
	VuhDoNewOptionsPanelHotBars:Show();
end



--
function VUHDO_newOptionsPanelMiscClicked()
	VUHDO_hideAllPanel();
	VuhDoNewOptionsPanelMisc:Show();
end



--
local tActivePanel;
local tRefreshModels;
local tContentPane;
local tAllPanels;
local tAktPanel;
local tAktSubComp;
local tSubModel;
local tSubComps;
local tAktComp;
local tSubSubComps;
local tModel;
local tSubPanels;
local tAktSub;
local tCnt;
local tValue;
function VUHDO_newOptionsApplyToAllOnClick()
	tActivePanel = nil;
	tRefreshModels = { };
	tContentPane = VUHDO_GLOBAL["VuhDoNewOptionsPanelPanelContentPanel"];
	tAllPanels = { tContentPane:GetChildren() };

	for _, tAktPanel in pairs(tAllPanels) do
		if (tAktPanel:IsObjectType("Frame") and tAktPanel:IsShown()) then
			tActivePanel = tAktPanel;
		end
	end

	if (tActivePanel == nil) then
		return;
	end

	tSubPanels = { tActivePanel:GetChildren() };

	for _, tAktSub in pairs(tSubPanels)	do
		if (tAktSub:IsObjectType("Frame")) then
			tSubComps =  { tAktSub:GetChildren() };
			for _, tAktComp in pairs(tSubComps) do
				tModel = tAktComp:GetAttribute("model");
				if (tModel ~= nil) then
					tRefreshModels[tModel] = true;
				end

				tSubSubComps = { tAktComp:GetChildren() };
				for _, tAktSubComp in pairs(tSubSubComps) do
					tSubModel = tAktSubComp:GetAttribute("model");
					if (tSubModel ~= nil) then
						tRefreshModels[tSubModel] = true;
					end
				end

			end
		end
	end

	if (tActivePanel:GetName() == "VuhDoNewOptionsPanelTooltip") then
		tRefreshModels["VUHDO_PANEL_SETUP.#PNUM#.TOOLTIP.x"] = true;
		tRefreshModels["VUHDO_PANEL_SETUP.#PNUM#.TOOLTIP.y"] = true;
		tRefreshModels["VUHDO_PANEL_SETUP.#PNUM#.TOOLTIP.point"] = true;
		tRefreshModels["VUHDO_PANEL_SETUP.#PNUM#.TOOLTIP.relativePoint"] = true;
	end

	for tModel, _ in pairs(tRefreshModels) do
		tValue = VUHDO_lnfGetValueFrom(tModel);
		for tCnt = 1, VUHDO_MAX_PANELS do
			if (tCnt ~= DESIGN_MISC_PANEL_NUM) then
				VUHDO_lnfUpdateVar(tModel, tValue, tCnt);
			end
		end
	end

	VUHDO_reloadUI();
end


--
function VUHDO_newOptionsShowHeadersEnableClicked(aCheckButton)
	if (aCheckButton:GetChecked()) then
		VUHDO_PANEL_SETUP[DESIGN_MISC_PANEL_NUM]["MODEL"].ordering = 0;
	end
end



--
function VUHDO_newOptionsLooseRadioButtonClicked(aRadioButton)
	if (aRadioButton:GetChecked()) then
		VUHDO_PANEL_SETUP[DESIGN_MISC_PANEL_NUM]["SCALING"].showHeaders = false;
	end
end



--
function VUHDO_newOptionsStrictRadioButtonClicked(aRadioButton)
	if (aRadioButton:GetChecked()) then
		VUHDO_PANEL_SETUP[DESIGN_MISC_PANEL_NUM]["SCALING"].showHeaders = true;
	end
end

