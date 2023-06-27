VUHDO_CONFIG_TEST_USERS = -1;

--
function VUHDO_newOptionsMoveOnShow()
	VuhDoNewOptionsTabbedFrame:SetHeight(110);
	VUHDO_IS_PANEL_CONFIG = true;
	VUHDO_CONFIG_SHOW_RAID = false;
	VUHDO_initDynamicPanelModels();
	VUHDO_redrawAllPanels();
end



--
function VUHDO_newOptionsMoveOnHide()
	VuhDoNewOptionsTabbedFrame:SetHeight(420);
	VUHDO_IS_PANEL_CONFIG = false;
	VUHDO_CONFIG_SHOW_RAID = true;
	VUHDO_clearUndefinedModelEntries();
	VUHDO_newOptionsPanelFindDefaultPanel();
	VUHDO_rewritePanelModels();
	VUHDO_initDynamicPanelModels();
	VUHDO_redrawAllPanels();
end



--
local tCnt;
function VUHDO_newOptionsAddPanelOnclick()
	for tCnt = 1, VUHDO_MAX_PANELS do
		if (VUHDO_PANEL_MODELS[tCnt] == nil) then
			VUHDO_PANEL_MODELS[tCnt] = { };
			VUHDO_initDynamicPanelModels();
			VUHDO_redrawAllPanels();
			break;
		end
	end
end



--
local tDesignPanel;
local tPanelNum;
function VUHDO_newOptionsAddModelOnClick(aButton)
	tDesignPanel = aButton:GetParent();
	tPanelNum = VUHDO_getComponentPanelNum(tDesignPanel);

	if (#VUHDO_PANEL_MODELS[tPanelNum] >= 15) then -- VUHDO_MAX_GROUPS_PER_PANEL
		return;
	end;

	VUHDO_CONFIG_SHOW_RAID = false;
	VUHDO_initDynamicPanelModels();
	table.insert(VUHDO_PANEL_MODELS[tPanelNum], VUHDO_ID_UNDEFINED);
	VUHDO_guessUndefinedEntries(tPanelNum);
	VUHDO_redrawAllPanels();
end



--
local tDesignPanel;
local tPanelNum;
function VUHDO_newOptionsDeleteModelOnClick(aButton)
	tDesignPanel = aButton:GetParent();
	tPanelNum = VUHDO_getComponentPanelNum(tDesignPanel);

	if (#VUHDO_PANEL_MODELS[tPanelNum] > 0) then
		DESIGN_MISC_PANEL_NUM = VUHDO_getComponentPanelNum(tDesignPanel);
		VuhDoYesNoFrameText:SetText(VUHDO_I18N_CLEAR_PANELS_CONFIRM);
		VuhDoYesNoFrame:SetAttribute("callback", VUHDO_newOptionsYesNoDecidedClearPanel);
		VuhDoYesNoFrame:Show();
	else
		VUHDO_rewritePanelModels();
		VUHDO_PANEL_SETUP[tPanelNum]["MODEL"].groups = nil;
		VUHDO_newOptionsPanelFindDefaultPanel();
		VUHDO_initPanelModels();
		VUHDO_initDynamicPanelModels();
		VUHDO_redrawAllPanels();
	end
end



--
function VUHDO_newOptionsYesNoDecidedClearPanel(aDecision)
	if (VUHDO_YES == aDecision) then
		VUHDO_rewritePanelModels();
		VUHDO_PANEL_SETUP[DESIGN_MISC_PANEL_NUM]["MODEL"].groups = { };
		VUHDO_initPanelModels();
		VUHDO_initDynamicPanelModels();
		VUHDO_redrawAllPanels();
	end
end



--
function VUHDO_newOptionsMoveSetTestData(aNumTestUsers)
	VUHDO_CONFIG_TEST_USERS = aNumTestUsers;
end

