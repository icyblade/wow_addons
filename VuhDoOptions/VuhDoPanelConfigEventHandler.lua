local _;

VUHDO_DRAG_PANEL = nil;
DESIGN_MISC_PANEL_NUM = nil;
INTERNAL_MODEL_CURRENT_TYPE_COMBO = VUHDO_ID_TYPE_GROUP;
INTERNAL_MODEL_CURRENT_VALUE_COMBO = nil;
local VUHDO_CURRENT_GROUP_ID;



--
function VUHDO_panelSetupRemoveGroupOnClick(aPanel)
	local tPanelNum, tModelNum = VUHDO_getComponentPanelNumModelNum(aPanel)
	VUHDO_removeFromModel(tPanelNum, tModelNum);
	VUHDO_redrawAllPanels(false);
end



--
function VUHDO_panelSetupChooseGroupOnClick(aButton)
	local tGroupOrderPanel = aButton:GetParent();
	local tPanelNum, tModelNum = VUHDO_getComponentPanelNumModelNum(tGroupOrderPanel);
	local tGroupSelectPanel = VUHDO_getGroupSelectPanel(tPanelNum, tModelNum);

	tGroupOrderPanel:Hide();
	tGroupSelectPanel:Show();
end



--
function VUHDO_groupSelectOkayOnClick(aButton)
	local tGroupSelectPanel = aButton:GetParent();
	local tPanelNum, tModelNum = VUHDO_getComponentPanelNumModelNum(tGroupSelectPanel);
	local tGroupOrderPanel = VUHDO_getGroupOrderPanel(tPanelNum, tModelNum);

	tGroupSelectPanel:Hide();
	VUHDO_redrawPanel(tPanelNum, false);

	tGroupOrderPanel:Show();
	VUHDO_reloadUI(false);
end



local function VUHDO_getComboModelAndType(aComboBox)
	local tPanelNum, tModelNum = VUHDO_getComponentPanelNumModelNum(aComboBox:GetParent());
	local tModel = VUHDO_PANEL_MODELS[tPanelNum][tModelNum];
	local tType = VUHDO_ID_MEMBER_TYPES[tModel] or VUHDO_ID_TYPE_SPECIAL;
	return tType, tModel;
end



--
function VUHDO_groupSelectTypeComboSetModel(aTypeCombo)
	INTERNAL_MODEL_CURRENT_TYPE_COMBO, _ = VUHDO_getComboModelAndType(aTypeCombo);
end



--
local tComboModels = { };
local function getOrCreateComboModelForType(aType)
	if not tComboModels[aType] then
		tComboModels[aType] = { };

		for _, tModel in ipairs(VUHDO_ID_TYPE_MEMBERS[aType]) do
			tinsert(tComboModels[aType], { tModel, VUHDO_HEADER_TEXTS[tModel] });
		end
	end

	return tComboModels[aType];
end


function VUHDO_groupSelectValueComboSetModel(aValueCombo)
	local tType, tModel = VUHDO_getComboModelAndType(aValueCombo);

	local tComboModel = getOrCreateComboModelForType(tType);

	INTERNAL_MODEL_CURRENT_VALUE_COMBO = tModel;
	VUHDO_setComboModel(aValueCombo, "INTERNAL_MODEL_CURRENT_VALUE_COMBO", tComboModel);
end



function VUHDO_panelConfigNotifyTypeSelect(aPanel, aValue)
	local tPanelNum, tModelNum = VUHDO_getComponentPanelNumModelNum(aPanel);
	local tCurrentValue = VUHDO_PANEL_MODELS[tPanelNum][tModelNum];
	local tCurrentType = VUHDO_ID_MEMBER_TYPES[tCurrentValue] or VUHDO_ID_TYPE_SPECIAL;

	if tCurrentType ~= aValue then
		VUHDO_PANEL_MODELS[tPanelNum][tModelNum] = VUHDO_ID_TYPE_MEMBERS[aValue][1];
		local tValueCombo = _G[aPanel:GetName() .. "VlCombo"];
		VUHDO_groupSelectValueComboSetModel(tValueCombo);
		VUHDO_lnfComboBoxInitFromModel(tValueCombo);
	end
end



function VUHDO_panelConfigNotifyValueSelect(aPanel, aValue)
	local tPanelNum, tModelNum = VUHDO_getComponentPanelNumModelNum(aPanel);
	VUHDO_PANEL_MODELS[tPanelNum][tModelNum] = aValue;
end


--
function VUHDO_PanelSetupGroupOrderSetStandard(aPanel)
		VUHDO_getGroupOrderLabel2(aPanel):SetText(VUHDO_I18N_ME);
end



--
function VUHDO_PanelSetupGroupOrderSetDragging(aPanel)
	local tPanelNum, tModelNum = VUHDO_getComponentPanelNumModelNum(aPanel);
	local tText = VUHDO_getHeaderText(VUHDO_PANEL_MODELS[tPanelNum][tModelNum]);

	VUHDO_getGroupOrderLabel2(aPanel):SetText(tText);
end



--
function VUHDO_panelSetupGroupDragOnMouseDown(aDragArea)
	local tGroupPanel = aDragArea:GetParent();

	VUHDO_PanelSetupGroupOrderSetDragging(tGroupPanel);
	tGroupPanel:StartMoving();
	VUHDO_DRAG_PANEL = tGroupPanel;
end



--
function VUHDO_panelSetupGroupDragOnMouseUp(aDragArea)
	local tGroupPanel = aDragArea:GetParent();
	tGroupPanel:StopMovingOrSizing();
	VUHDO_DRAG_PANEL = nil;
	VUHDO_PanelSetupGroupOrderSetStandard(tGroupPanel);
	VUHDO_reorderGroupsAfterDragged(tGroupPanel);
end

