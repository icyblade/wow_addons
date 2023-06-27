VUHDO_HOT_MODELS = { };
VUHDO_HOT_BAR_MODELS = { };

--
local tCnt, tName, tIndex, tModel;
local tSortTable = { };
function VUHDO_initHotComboModels()
	table.wipe(VUHDO_HOT_MODELS);

	VUHDO_HOT_MODELS[1] = { nil, "-- " .. VUHDO_I18N_EMPTY_HOTS .. " --" };
	VUHDO_HOT_MODELS[2] = { "OTHER", "|cff0000ff[s]|r " .. VUHDO_I18N_OTHER_HOTS};
	VUHDO_HOT_MODELS[3] = { "CLUSTER", "|cff0000ff[s]|r " .. VUHDO_I18N_CLUSTER_FINDER};

	for tCnt = 1, #VUHDO_PLAYER_HOTS do
		VUHDO_HOT_MODELS[tCnt + 3] = { VUHDO_PLAYER_HOTS[tCnt], "[h] " .. VUHDO_PLAYER_HOTS[tCnt] };
	end

	table.wipe(tSortTable);
	for tName, _ in pairs(VUHDO_BOUQUETS["STORED"]) do
		tinsert(tSortTable, {"BOUQUET_" .. tName, "|cff000000[b]|r " .. tName} );
	end

	table.sort(tSortTable,
		function(anInfo, anotherInfo)
			return anInfo[2] < anotherInfo[2];
		end
	);

	for _, tModel in ipairs(tSortTable) do
		tinsert(VUHDO_HOT_MODELS, tModel);
	end
end



--
local tSortTable = { };
function VUHDO_initHotBarComboModels()
	table.wipe(VUHDO_HOT_BAR_MODELS);

	VUHDO_HOT_BAR_MODELS[1] = { nil, "-- " .. VUHDO_I18N_EMPTY_HOTS .. " --" };
	for tCnt = 1, #VUHDO_PLAYER_HOTS do
		VUHDO_HOT_BAR_MODELS[tCnt + 1] = { VUHDO_PLAYER_HOTS[tCnt], VUHDO_PLAYER_HOTS[tCnt] };
	end

	table.wipe(tSortTable);
	for tName, _ in pairs(VUHDO_BOUQUETS["STORED"]) do
		tinsert(tSortTable, {"BOUQUET_" .. tName, "|cff000000[b]|r " .. tName} );
	end

	table.sort(tSortTable,
		function(anInfo, anotherInfo)
			return anInfo[2] < anotherInfo[2];
		end
	);

	for _, tModel in ipairs(tSortTable) do
		tinsert(VUHDO_HOT_BAR_MODELS, tModel);
	end
end



--
function VUHDO_squareDemoOnShow(aTexture)
	local tNum;
	tNum = VUHDO_getNumbersFromString(aTexture:GetName(), 1);
	VUHDO_GLOBAL[aTexture:GetName() .. "Label"]:SetText("" .. tNum[1]);
end



--
function VUHDO_notifyHotSelect(aComboBox, aValue)
	local tMineBox, tOthersBox, tEditButton;
	local tComboName = aComboBox:GetParent():GetName();

	tMineBox = VUHDO_GLOBAL[tComboName .. "MineCheckBox"];
	tOthersBox = VUHDO_GLOBAL[tComboName .. "OthersCheckBox"];
	tEditButton = VUHDO_GLOBAL[tComboName .. "EditButton"];
	if (aValue == nil or aValue == "CLUSTER" or aValue == "OTHER" or strsub(aValue, 1, 8) == "BOUQUET_") then
		tMineBox:Hide();
		tOthersBox:Hide();
		if (aValue ~= nil and strsub(aValue, 1, 8) == "BOUQUET_") then
			tEditButton:Show();
		else
			tEditButton:Hide();
		end
	else
		tMineBox:Show();
		tOthersBox:Show();
		tEditButton:Hide();
	end
end



--
function VUHDO_notifyBouquetUpdate()
	VUHDO_registerAllBouquets(false);
	VUHDO_initAllEventBouquets();
end



--
function VUHDO_panelsHotsEditButtonClicked(aButton)
	local tCombo = VUHDO_GLOBAL[aButton:GetParent():GetName() .. "SelectComboBox"];
	VUHDO_BOUQUETS["SELECTED"] = strsub(VUHDO_lnfGetValueFromModel(tCombo), 9);

	VUHDO_MENU_RETURN_FUNC = nil;
	VUHDO_MENU_RETURN_TARGET = nil;
	VUHDO_MENU_RETURN_TARGET_MAIN = VuhDoNewOptionsTabbedFrameTabsPanelPanelsRadioButton;

	VUHDO_newOptionsTabbedClickedClicked(VuhDoNewOptionsTabbedFrameTabsPanelGeneralRadioButton);
	VUHDO_lnfRadioButtonClicked(VuhDoNewOptionsTabbedFrameTabsPanelGeneralRadioButton);

	VUHDO_newOptionsGeneralBouquetClicked(VuhDoNewOptionsGeneralRadioPanelBouquetRadioButton);
	VUHDO_lnfRadioButtonClicked(VuhDoNewOptionsGeneralRadioPanelBouquetRadioButton);
end



--
local VUHDO_SLOT_NO_FROM_HOT_NO = {
	1, 2, 3, 4, 5, 1, 2, 3, 6, 7,
}

--
function VUHDO_hotSlotContainerOnLoad(aContainer)
	local tContainerName = aContainer:GetName();
	local tHotSlotNum = VUHDO_getNumbersFromString(tContainerName, 1)[1];
	local tContainerNum = VUHDO_SLOT_NO_FROM_HOT_NO[tHotSlotNum] or "";

	local tLabel = VUHDO_GLOBAL[tContainerName .. "TitleLabelLabel"];
	tLabel:SetText(VUHDO_I18N_SLOT .. " " .. tContainerNum);

	local tCombo = VUHDO_GLOBAL[tContainerName .. "SelectComboBox"];
	VUHDO_setComboModel(tCombo, "VUHDO_PANEL_SETUP.HOTS.SLOTS.##" .. tHotSlotNum, VUHDO_HOT_MODELS);

	local tMineBox = VUHDO_GLOBAL[tContainerName .. "MineCheckBox"];
	VUHDO_lnfSetModel(tMineBox, "VUHDO_PANEL_SETUP.HOTS.SLOTCFG." .. tHotSlotNum .. ".mine");

	local tOthersBox = VUHDO_GLOBAL[tContainerName .. "OthersCheckBox"];
	VUHDO_lnfSetModel(tOthersBox, "VUHDO_PANEL_SETUP.HOTS.SLOTCFG." .. tHotSlotNum .. ".others");
end



--
function VUHDO_hotMoreSlotContainerOnLoad(aContainer)
	local tContainerName = aContainer:GetName();
	local tHotSlotNum = VUHDO_getNumbersFromString(tContainerName, 1)[1];
	local tContainerNum = VUHDO_SLOT_NO_FROM_HOT_NO[tHotSlotNum] or "";

	local tLabel = VUHDO_GLOBAL[tContainerName .. "TitleLabelLabel"];
	tLabel:SetText(VUHDO_I18N_SLOT .. " " .. tContainerNum);

	local tSlider = VUHDO_GLOBAL[tContainerName .. "ScaleSlider"];
	VUHDO_lnfSetModel(tSlider, "VUHDO_PANEL_SETUP.HOTS.SLOTCFG." .. tHotSlotNum .. ".scale");
	VUHDO_lnfSliderOnLoad(tSlider, "", 0.5, 2, "", 0.05);
	VUHDO_lnfSetTooltip(tSlider, VUHDO_I18N_TT.K545);
end



--
function VUHDO_optionsHotsToggleMorePanel(aPanel)
	local tBasicPanel = VUHDO_GLOBAL[aPanel:GetParent():GetName() .. "HotOrderPanel"];
	local tMorePanel = VUHDO_GLOBAL[aPanel:GetParent():GetName() .. "MoreHotOrderPanel"];

	if (tBasicPanel:IsShown()) then
		tBasicPanel:Hide();
		tMorePanel:Show();
	else
		tMorePanel:Hide();
		tBasicPanel:Show();
	end

end