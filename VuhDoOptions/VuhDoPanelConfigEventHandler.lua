VUHDO_GROUP_ORDER_IS_DRAGGING = false;
VUHDO_DRAG_PANEL = nil;
DESIGN_MISC_PANEL_NUM = nil;
local VUHDO_CURRENT_GROUPS_COMBO;
local VUHDO_CURRENT_GROUP_ID;



local VUHDO_ID_TYPE_NAMES = {
	[VUHDO_ID_TYPE_UNDEFINED] = VUHDO_I18N_UNDEFINED,
	[VUHDO_ID_TYPE_CLASS] = VUHDO_I18N_CLASS,
	[VUHDO_ID_TYPE_GROUP] = VUHDO_I18N_GROUP,
	[VUHDO_ID_TYPE_SPECIAL] = VUHDO_I18N_SPECIAL
};



--
function VUHDO_panelSetupRemoveGroupOnClick(aPanel)
	local tPanelNum, tModelNum;

	tPanelNum, tModelNum = VUHDO_getComponentPanelNumModelNum(aPanel)
	VUHDO_removeFromModel(tPanelNum, tModelNum);
	VUHDO_PANEL_MODEL_GUESSED[tPanelNum] = { };
	VUHDO_redrawAllPanels();
end



--
function VUHDO_panelSetupChooseGroupOnClick(aButton)
	local tPanelNum, tModelNum;
	local tGroupOrderPanel = aButton:GetParent();
	tPanelNum, tModelNum = VUHDO_getComponentPanelNumModelNum(tGroupOrderPanel);
	local tGroupSelectPanel = VUHDO_getGroupSelectPanel(tPanelNum, tModelNum);

	tGroupOrderPanel:Hide();
	tGroupSelectPanel:Show();
end



--
function VUHDO_groupSelectOkayOnClick(aButton)
	local tPanelNum, tModelNum;
	local tGroupSelectPanel = aButton:GetParent();
	tPanelNum, tModelNum = VUHDO_getComponentPanelNumModelNum(tGroupSelectPanel);
	local tGroupOrderPanel = VUHDO_getGroupOrderPanel(tPanelNum, tModelNum);

	tGroupSelectPanel:Hide();
	VUHDO_redrawPanel(tPanelNum);

	VUHDO_setGuessedModel(tPanelNum, tModelNum, false);
	VUHDO_guessUndefinedEntries(tPanelNum);
	tGroupOrderPanel:Show();
	VUHDO_reloadUI();
end



--
function VUHDO_PanelSetupGroupSelectOnShow(aGroupSelectPanel)
	aGroupSelectPanel:SetBackdropColor(0, 0, 0, 1);
	aGroupSelectPanel:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
end



--
function VUHDO_groupSelectTypeComboOnShow(aComboBox)
	local tPanelNum, tModelNum;
	tPanelNum, tModelNum = VUHDO_getComponentPanelNumModelNum(aComboBox:GetParent());

	local tModelId = VUHDO_PANEL_MODELS[tPanelNum][tModelNum];
	local tOkayButton = VUHDO_GLOBAL[aComboBox:GetParent():GetName() .. "OkayButton"];

	if (tModelId ~= VUHDO_ID_UNDEFINED) then
		tOkayButton:Enable();
	else
		tOkayButton:Disable();
	end

	local tType = VUHDO_getModelType(tModelId);
	UIDropDownMenu_SetSelectedValue(aComboBox, tType);
	VUHDO_configFillGroupsCombo(aComboBox:GetParent(), tModelId);

	local tName = VUHDO_ID_TYPE_NAMES[tType];
	VUHDO_GLOBAL[aComboBox:GetName() .. "Text"]:SetText(tName);
end



--
function VUHDO_groupSelectTypeOnSelectionChanged(anEntry)
	local tText = VUHDO_ID_TYPE_NAMES[anEntry.value];
	local tPanel = anEntry.owner:GetParent();
	local tPanelNum, tModelNum;

	UIDropDownMenu_SetSelectedValue(anEntry.owner, anEntry.value, true);

	VUHDO_GLOBAL[anEntry.owner:GetName() .. "Text"]:SetText(tText);

	tPanelNum, tModelNum = VUHDO_getComponentPanelNumModelNum(tPanel);

	local tModelId;
	if (anEntry.value == VUHDO_ID_TYPE_GROUP) then
		 tModelId = VUHDO_ID_GROUP_1;
	elseif (anEntry.value == VUHDO_ID_TYPE_CLASS) then
		tModelId = VUHDO_ID_WARRIORS;
	else
		tModelId = VUHDO_ID_PETS;
	end

	VUHDO_PANEL_MODELS[tPanelNum][tModelNum] = tModelId;
	VUHDO_configFillGroupsCombo(tPanel, tModelId);

	local tOkayButton = VUHDO_GLOBAL[tPanel:GetName() .. "OkayButton"];
	tOkayButton:Enable();
end



--
function VUHDO_configGroupSelectButtonOnMouseDown(aButton)
	local tPanelNum, tModelNum;

	local tComboBox = aButton:GetParent();
	tPanelNum, tModelNum = VUHDO_getComponentPanelNumModelNum(tComboBox:GetParent());

	local tModelId = VUHDO_PANEL_MODELS[tPanelNum][tModelNum];
	local tType = VUHDO_getModelType(tModelId);

	VUHDO_CURRENT_GROUPS_COMBO = tComboBox;
	VUHDO_CURRENT_GROUP_TYPE_ID = tType;
end



--
function VUHDO_groupSelectGroupOnSelectionChanged(anEntry)
	local tPanelNum, tModelNum;

	local tGroupSelectPanel = anEntry.owner:GetParent();
	tPanelNum, tModelNum = VUHDO_getComponentPanelNumModelNum(tGroupSelectPanel);

	VUHDO_configFillGroupsCombo(tGroupSelectPanel, anEntry.value);
	VUHDO_PANEL_MODELS[tPanelNum][tModelNum] = anEntry.value;
end



--
local function VUHDO_createComboBoxInfo(aComboBox, aText, aValue, aCheckedValue)
	local tInfo = { };

	tInfo.text = aText;
	tInfo.value = aValue;
	tInfo.func = nil;
	tInfo.owner = aComboBox;
	if (aValue == aCheckedValue) then
		tInfo.checked = true;
	else
		tInfo.checked = nil;
	end
	tInfo.icon = nil;

	return tInfo;
end



--
function VUHDO_configInitGroupsCombo()
	local tIndex, tId;
	local tName;
	local tInfo;
	local tType = VUHDO_getModelType(VUHDO_CURRENT_GROUP_ID);

	for tIndex, tId in ipairs(VUHDO_ID_TYPE_MEMBERS[tType]) do
		tName = VUHDO_HEADER_TEXTS[tId];
		local tInfo = VUHDO_createComboBoxInfo(VUHDO_CURRENT_GROUPS_COMBO, tName, tId, VUHDO_CURRENT_GROUP_ID);
		tInfo.func = function() VUHDO_groupSelectGroupOnSelectionChanged(tInfo) end
		UIDropDownMenu_AddButton(tInfo);
	end

	local tText = VUHDO_HEADER_TEXTS[VUHDO_CURRENT_GROUP_ID];
	VUHDO_GLOBAL[VUHDO_CURRENT_GROUPS_COMBO:GetName() .. "Text"]:SetText(tText);
end



--
function VUHDO_refreshGroupsCombo(aGroupsCombo, aModelId)
	VUHDO_CURRENT_GROUPS_COMBO = aGroupsCombo;
	VUHDO_CURRENT_GROUP_ID = aModelId;

	UIDropDownMenu_Initialize(aGroupsCombo, VUHDO_configInitGroupsCombo);
end



--
function VUHDO_configFillGroupsCombo(aGroupSelectPanel, aModelId)
	local tGroupsCombo = VUHDO_GLOBAL[aGroupSelectPanel:GetName() .. "VlCmb"];

	UIDropDownMenu_ClearAll(tGroupsCombo);
	VUHDO_refreshGroupsCombo(tGroupsCombo, aModelId);
end



--
function VUHDO_PanelSetupGroupOrderOnShow(aGroupOrderPanel)
	VUHDO_PanelSetupGroupOrderSetStandard(aGroupOrderPanel);
end



--
function VUHDO_PanelSetupGroupOrderSetStandard(aPanel)
	aPanel:SetBackdropColor(0, 0, 0, 1);
	aPanel:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
	aPanel:SetToplevel(false);
	VUHDO_getGroupOrderLabel2(aPanel):SetText(VUHDO_I18N_ME);
end



--
function VUHDO_PanelSetupGroupOrderSetDragging(aPanel)
	local tText;
	local tPanelNum, tModelNum;

	aPanel:SetBackdropColor(0, 0, 0, 1);
	aPanel:SetBackdropBorderColor(1, 0, 0, 1);
	aPanel:SetToplevel(true);
	tPanelNum, tModelNum = VUHDO_getComponentPanelNumModelNum(aPanel);
	tText = VUHDO_getHeaderText(VUHDO_PANEL_MODELS[tPanelNum][tModelNum]);

	VUHDO_getGroupOrderLabel2(aPanel):SetText(tText);
end



--
function VUHDO_panelSetupGroupDragOnMouseDown(aDragArea)
	local tGroupPanel = aDragArea:GetParent();

	VUHDO_PanelSetupGroupOrderSetDragging(tGroupPanel);
	tGroupPanel:StartMoving();
	VUHDO_GROUP_ORDER_IS_DRAGGING = true;
	VUHDO_DRAG_PANEL = tGroupPanel;
end



--
function VUHDO_panelSetupGroupDragOnMouseUp(aDragArea)
	local tGroupPanel = aDragArea:GetParent();
	tGroupPanel:StopMovingOrSizing();
	VUHDO_GROUP_ORDER_IS_DRAGGING = false;
	VUHDO_DRAG_PANEL = nil;
	VUHDO_PanelSetupGroupOrderSetStandard(tGroupPanel);
	VUHDO_reorderGroupsAfterDragged(tGroupPanel);
end

