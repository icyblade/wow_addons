VUHDO_RESET_SIZES = false;

local VUHDO_GLOBAL = getfenv();
local strfind = strfind;
local floor = floor;
local type = type;
local tonumber = tonumber;
local pairs = pairs;
local ipairs = ipairs;



local VUHDO_ACTIVE_LABEL_COLOR = {
	["TR"] = 0.6,	["TG"] = 0.6,	["TB"] = 1,	["TO"] = 1,
};


local VUHDO_NORMAL_LABEL_COLOR = {
	["TR"] = 0.4,	["TG"] = 0.4,	["TB"] = 1,	["TO"] = 1,
};



local VUHDO_ACTIVE_LABEL_COLOR_DISA = {
	["TR"] = 0.3,	["TG"] = 0.3,	["TB"] = 0.7,	["TO"] = 1,
};



local VUHDO_NORMAL_LABEL_COLOR_DISA = {
	["TR"] = 0.2,	["TG"] = 0.2,	["TB"] = 0.6,	["TO"] = 1,
};



--
function VUHDO_lnfCheckButtonOnLoad(aCheckButton)
	if (aCheckButton:GetText() ~= nil) then
		local tTexts = VUHDO_splitString(aCheckButton:GetText(), "\n");
		VUHDO_GLOBAL[aCheckButton:GetName() .. "Label"]:SetText(tTexts[1]);

		if (tTexts[2] ~= nil and VUHDO_GLOBAL[aCheckButton:GetName() .. "Label2"] ~= nil) then
			VUHDO_GLOBAL[aCheckButton:GetName() .. "Label2"]:SetText(tTexts[2]);
		end
	end
end



--
function VUHDO_lnfTabCheckButtonOnLoad(aCheckButton)
	if (aCheckButton:GetText() ~= nil) then
		VUHDO_GLOBAL[aCheckButton:GetName() .. "TextureCheckMarkLabel"]:SetText(aCheckButton:GetText());
		VUHDO_GLOBAL[aCheckButton:GetName() .. "Label"]:SetText(aCheckButton:GetText());
	end
end



--
function VUHDO_lnfCheckButtonClicked(aCheckButton)
	if (aCheckButton:GetChecked()) then
		VUHDO_GLOBAL[aCheckButton:GetName() .. "TextureCheckMark"]:Show();
	else
		VUHDO_GLOBAL[aCheckButton:GetName() .. "TextureCheckMark"]:Hide();
	end
end
local VUHDO_lnfCheckButtonClicked = VUHDO_lnfCheckButtonClicked;



--
local tButton;
local tAllButtons = { };
local tPanel;
function VUHDO_lnfRadioButtonClicked(aCheckButton)

	tPanel = aCheckButton:GetParent();
	table.wipe(tAllButtons);
	tAllButtons = { tPanel:GetChildren() };

	for _, tButton in pairs(tAllButtons) do
		if (tButton:IsObjectType("CheckButton") and strfind(tButton:GetName(), "Radio", 1, true)) then
			tButton:SetChecked(aCheckButton == tButton);
			VUHDO_lnfCheckButtonClicked(tButton);
		end
	end
end



--
local tPanel;
local tAllButtons = { };
local tButton;
function VUHDO_lnfTabCheckButtonClicked(aCheckButton)
	tPanel = aCheckButton:GetParent();
	table.wipe(tAllButtons);
	tAllButtons = { tPanel:GetChildren() };

	for _, tButton in pairs(tAllButtons) do
		if (tButton:IsObjectType("CheckButton") and strfind(tButton:GetName(), "Radio", 1, true)) then
			if (aCheckButton == tButton) then
				tButton:SetChecked(true);
				VUHDO_lnfTabCheckButtonOnEnter(tButton);
			else
				tButton:SetChecked(false);
				VUHDO_lnfTabCheckButtonOnLeave(tButton);
			end

			VUHDO_lnfCheckButtonClicked(tButton);
		end
	end
end



--
local tName;
function VUHDO_lnfCheckButtonOnEnter(aCheckButton)
	tName = aCheckButton:GetName();
	VUHDO_GLOBAL[tName .. "TextureActiveSwatch"]:Show();

	if (VUHDO_GLOBAL[tName .. "Label"] ~= nil) then
		VUHDO_GLOBAL[tName .. "Label"]:SetTextColor(
			VUHDO_ACTIVE_LABEL_COLOR["TR"],
			VUHDO_ACTIVE_LABEL_COLOR["TG"],
			VUHDO_ACTIVE_LABEL_COLOR["TB"],
			VUHDO_ACTIVE_LABEL_COLOR["TO"]
		);
	end

	if (VUHDO_GLOBAL[tName .. "Label2"] ~= nil) then
		VUHDO_GLOBAL[tName .. "Label2"]:SetTextColor(
			VUHDO_ACTIVE_LABEL_COLOR["TR"],
			VUHDO_ACTIVE_LABEL_COLOR["TG"],
			VUHDO_ACTIVE_LABEL_COLOR["TB"],
			VUHDO_ACTIVE_LABEL_COLOR["TO"]
		);
	end
end



--
local tName;
function VUHDO_lnfCheckButtonOnLeave(aCheckButton)
	tName = aCheckButton:GetName();
	VUHDO_GLOBAL[tName .. "TextureActiveSwatch"]:Hide();

	if (VUHDO_GLOBAL[tName .. "Label"] ~= nil) then
		VUHDO_GLOBAL[tName .. "Label"]:SetTextColor(
			VUHDO_NORMAL_LABEL_COLOR["TR"],
			VUHDO_NORMAL_LABEL_COLOR["TG"],
			VUHDO_NORMAL_LABEL_COLOR["TB"],
			VUHDO_NORMAL_LABEL_COLOR["TO"]
		);
	end

	if (VUHDO_GLOBAL[tName .. "Label2"] ~= nil) then
		VUHDO_GLOBAL[tName .. "Label2"]:SetTextColor(
			VUHDO_NORMAL_LABEL_COLOR["TR"],
			VUHDO_NORMAL_LABEL_COLOR["TG"],
			VUHDO_NORMAL_LABEL_COLOR["TB"],
			VUHDO_NORMAL_LABEL_COLOR["TO"]
		);
	end
end



--
function VUHDO_lnfRadioBoxOnEnter(aCheckButton)
	VUHDO_GLOBAL[aCheckButton:GetName() .. "TextureActiveSwatch"]:Show();
end



--
function VUHDO_lnfRadioBoxOnLeave(aCheckButton)
	VUHDO_GLOBAL[aCheckButton:GetName() .. "TextureActiveSwatch"]:Hide();
end



--
local tName;
function VUHDO_lnfTabCheckButtonOnEnter(aCheckButton)
	tName = aCheckButton:GetName();
	VUHDO_GLOBAL[tName .. "TextureActiveSwatch"]:Show();

	if (aCheckButton:GetChecked()) then
		VUHDO_GLOBAL[tName .. "TextureCheckMarkLabel"]:SetTextColor(
			VUHDO_ACTIVE_LABEL_COLOR.TR,
			VUHDO_ACTIVE_LABEL_COLOR.TG,
			VUHDO_ACTIVE_LABEL_COLOR.TB,
			VUHDO_ACTIVE_LABEL_COLOR.TO
		);
	else
		VUHDO_GLOBAL[tName .. "Label"]:SetTextColor(
			VUHDO_ACTIVE_LABEL_COLOR_DISA.TR,
			VUHDO_ACTIVE_LABEL_COLOR_DISA.TG,
			VUHDO_ACTIVE_LABEL_COLOR_DISA.TB,
			VUHDO_ACTIVE_LABEL_COLOR_DISA.TO
		);
	end
end



--
local tName;
function VUHDO_lnfTabCheckButtonOnLeave(aCheckButton)
	tName = aCheckButton:GetName();
	VUHDO_GLOBAL[tName .. "TextureActiveSwatch"]:Hide();

	if (aCheckButton:GetChecked()) then
		VUHDO_GLOBAL[aCheckButton:GetName() .. "TextureCheckMarkLabel"]:SetTextColor(
			VUHDO_NORMAL_LABEL_COLOR.TR,
			VUHDO_NORMAL_LABEL_COLOR.TG,
			VUHDO_NORMAL_LABEL_COLOR.TB,
			VUHDO_NORMAL_LABEL_COLOR.TO
		);
	else
		VUHDO_GLOBAL[aCheckButton:GetName() .. "Label"]:SetTextColor(
			VUHDO_NORMAL_LABEL_COLOR_DISA.TR,
			VUHDO_NORMAL_LABEL_COLOR_DISA.TG,
			VUHDO_NORMAL_LABEL_COLOR_DISA.TB,
			VUHDO_NORMAL_LABEL_COLOR_DISA.TO
		);
	end
end



--
local tText;
local tUnit;
function VUHDO_lnfSliderOnValueChanged(aSlider)
	if (VUHDO_GLOBAL[aSlider:GetName() .. "SliderValue"] ~= nil) then
		tText = "" .. floor((VUHDO_GLOBAL[aSlider:GetName() .. "Slider"]:GetValue() + 0.005) * 100) * 0.01;
		tUnit = aSlider:GetAttribute("unit");
		if (tUnit ~= nil) then
			tText = tText .. tUnit;
		end

		VUHDO_GLOBAL[aSlider:GetName() .. "SliderValue"]:SetText(tText);
	end
end



--
function VUHDO_lnfSliderOnLoad(aSlider, aText, aMinValue, aMaxValue, aUnitName, aValueStep)
	VUHDO_GLOBAL[aSlider:GetName() .. "SliderTitle"]:SetText(aText);
	aSlider:SetAttribute("unit", aUnitName);
	VUHDO_GLOBAL[aSlider:GetName() .. "Slider"]:SetMinMaxValues(aMinValue, aMaxValue);

	VUHDO_GLOBAL[aSlider:GetName() .. "Slider"]:SetValueStep(aValueStep or 1);
	VUHDO_lnfSliderOnValueChanged(aSlider);
end



--
local sLastComboItem = nil;

function VUHDO_lnfSetLastComboItem(anItem)
	sLastComboItem = anItem:GetName();
end



--
local tFocus;
function VUHDO_lnfIsLastComboIten()
	tFocus = GetMouseFocus();
	return tFocus ~= nil and tFocus:GetName() == sLastComboItem;
end



--
function VUHDO_lnfRadioButtonOnShow(aRadioButton)
	if (aRadioButton:GetChecked()) then
		VUHDO_lnfRadioButtonClicked(aRadioButton);
	end
end



--
local tComboBox;
function VUHDO_lnfComboItemOnEnter(aComboItem)
	tComboBox = aComboItem.parentCombo;
	if (IsMouseButtonDown() and not tComboBox.isMulti) then
		VUHDO_lnfComboSetSelectedValue(tComboBox, aComboItem:GetAttribute("value"));
	end
	aComboItem:SetBackdropColor(0.8, 0.8, 1, 1);

	if (not tComboBox["isMulti"]) then
		VUHDO_GLOBAL[aComboItem:GetName() .. "Icon"]:SetScale(2);
		VUHDO_GLOBAL[aComboItem:GetName() .. "Icon"]:SetPoint("RIGHT", aComboItem:GetName(), "RIGHT", -10, 0);
	end
end



--
function VUHDO_lnfComboItemOnLeave(aComboItem)
	if (aComboItem.parentCombo.isScrollable) then
		aComboItem:SetBackdropColor(0, 0, 0, 0);
	else
		aComboItem:SetBackdropColor(1, 1, 1, 1);
	end

	tComboBox = aComboItem.parentCombo;
	if (not tComboBox.isMulti) then
		VUHDO_GLOBAL[aComboItem:GetName() .. "Icon"]:SetScale(1);
		VUHDO_GLOBAL[aComboItem:GetName() .. "Icon"]:SetPoint("RIGHT", aComboItem:GetName(), "RIGHT", -6, 0);
	end
end



local function VUHDO_hideAllComponentExtensions(aComponent)
	local tRootPane = aComponent:GetParent():GetParent();
	local tAllSubPanes = { tRootPane:GetChildren() };
	local tSubPanel;
	local tAllComponents;
	local tComponent;
	local tSelectPanel;

	for _, tSubPanel in pairs(tAllSubPanes) do
		tAllComponents = { tSubPanel:GetChildren() } or { };
		for _, tComponent in pairs(tAllComponents) do
			if (aComponent ~= tComponent) then

				-- 1. Combo-Flyouts
				if (strfind(tComponent:GetName(), "Combo")) then
					tSelectPanel = VUHDO_GLOBAL[tComponent:GetName() .. "ScrollPanel"] or VUHDO_GLOBAL[tComponent:GetName() .. "SelectPanel"];
					if (tSelectPanel ~= nil) then
						tSelectPanel:Hide();
					end
				end

			end
		end
	end
end


--
local tComboBox;
local tSelectPanel;
function VUHDO_lnfComboButtonClicked(aButton)
	tComboBox = aButton:GetParent();
	tSelectPanel = VUHDO_GLOBAL[tComboBox:GetName() .. "ScrollPanel"] or VUHDO_GLOBAL[tComboBox:GetName() .. "SelectPanel"];

	if (tSelectPanel:IsShown()) then
		tSelectPanel:Hide();
	else
		if (not tComboBox.prohibitCloseExtensions) then
			VUHDO_hideAllComponentExtensions(tComboBox);
		end
		tSelectPanel:Show();
	end
end


--
function VUHDO_lnfComboSelectHide(aComboBox)
	if (aComboBox.isScrollable) then
		VUHDO_GLOBAL[aComboBox:GetName() .. "ScrollPanel"]:Hide();
	else
		VUHDO_GLOBAL[aComboBox:GetName() .. "SelectPanel"]:Hide();
	end
end


--
--
--
-- Model changing
--
--
--



--
local VUHDO_NUM_TEMPLATE = "#PNUM#";
local VUHDO_VAL_TEMPLATE = "##";

function VUHDO_lnfSetModel(aComponent, aModel)
	aComponent:SetAttribute("model", aModel);
end



--
function VUHDO_lnfSetRadioModel(aComponent, aModel, aValue)
	aComponent:SetAttribute("model", aModel);
	aComponent:SetAttribute("radio_value", aValue);
end



--
function VUHDO_setComboModel(aComponent, aModel, anEntryTable, aTitle)
	aComponent:SetAttribute("model", aModel);
	aComponent:SetAttribute("combo_table", anEntryTable);
	aComponent:SetAttribute("title", aTitle);

	if (VUHDO_GLOBAL[aComponent:GetName() .. "EditBox"] ~= nil) then
		VUHDO_lnfSetModel(VUHDO_GLOBAL[aComponent:GetName() .. "EditBox"], aModel);
	end
end



--
local VUHDO_lnfOnUpdate = false;
local tCurrModel;
local tPanel;
local tAllComps = { };
local tComp;
local tModel;
local function VUHDO_lnfUpdateAllModelControls(aComponent, aValue)
	tCurrModel = aComponent:GetAttribute("model");
	if (VUHDO_lnfOnUpdate or tCurrModel == nil) then
		return;
	end

	tPanel = aComponent:GetParent();
	if (tPanel == nil) then
		return;
	end

	VUHDO_lnfOnUpdate = true;

	table.wipe(tAllComps);
	tAllComps = { tPanel:GetChildren() };

	for _, tComp in pairs(tAllComps) do
		tModel = tComp:GetAttribute("model");
		if (tModel ~= nil and strfind(tCurrModel, tModel , 1, true)  and aComponent ~= tComp) then
			if (tComp:IsShown()) then
				tComp:Hide();
				tComp:Show();
			end
		end
	end

	VUHDO_lnfOnUpdate = false;
end



--
local tPanelNum;
local tTableIndices;
local tGlobal;
local tLastField;
local tCnt;
local tIndex;
local tLastIndex;
local tEnd;
function VUHDO_lnfUpdateVar(aModel, aValue, aPanelNum)
	tPanelNum = nil;

	if (aPanelNum == nil) then
		aPanelNum = DESIGN_MISC_PANEL_NUM;
	end

	if (VUHDO_isVariablesLoaded() and aModel ~= nil) then
		tTableIndices = VUHDO_splitString(aModel, ".");
		tGlobal = VUHDO_GLOBAL[tTableIndices[1]];
		tLastField = tGlobal;
		tEnd = #tTableIndices - 1;

		for tCnt = 2, tEnd do
			tIndex = tTableIndices[tCnt];
			if (VUHDO_NUM_TEMPLATE == tIndex) then
				tIndex = aPanelNum;
				tPanelNum = aPanelNum;
			elseif (strfind(tIndex, VUHDO_VAL_TEMPLATE, 1, true)) then
				tIndex = VUHDO_getNumbersFromString(tIndex, 1)[1];
			end

			tLastField = tLastField[tIndex];
		end
		tLastIndex = tTableIndices[#tTableIndices];
		if (VUHDO_NUM_TEMPLATE == tLastIndex) then
			tLastIndex = aPanelNum;
			tPanelNum = aPanelNum;
		elseif (strfind(tLastIndex, VUHDO_VAL_TEMPLATE, 1, true)) then
			tLastIndex = VUHDO_getNumbersFromString(tLastIndex, 1)[1];
		end

		if ("table" == type(tLastField)) then
			tLastField[tLastIndex] = aValue;
		else
			VUHDO_GLOBAL[tTableIndices[1]] = aValue;
		end

		if (not InCombatLockdown()) then
			if (VUHDO_RESET_SIZES) then
				resetSizeCalcCaches();
			end
			if (strfind(aModel, "VUHDO_OPTIONS_SETTINGS.", 1, true) ~= nil) then
			elseif (tPanelNum ~= nil) then
				if (strfind(aModel, "TOOLTIP", 1, true) ~= nil) then
					VUHDO_demoTooltip(aPanelNum);
				else
					VUHDO_initDynamicPanelModels();
					VUHDO_timeRedrawPanel(tPanelNum, 0.3);
				end
			elseif (strfind(aModel, "_BUFF_", 1, true) ~= nil) then
				VUHDO_reloadBuffPanel();
			elseif (strfind(aModel, "BLIZZ_UI", 1, true) ~= nil) then
				VUHDO_initBlizzFrames();
			else
				if (strfind(aModel, "VUHDO_CONFIG.", 1, true) ~= nil) then
					VUHDO_demoSetupResetUsers();
				end
				VUHDO_initDebuffs();
				VUHDO_customHealthInitBurst(); -- For life left colors
				VUHDO_timeReloadUI(0.3, true);
			end
		end
		VUHDO_toolboxInitBurst();
	end
end
local VUHDO_lnfUpdateVar = VUHDO_lnfUpdateVar;



--
local tModel, tFunction;
function VUHDO_lnfUpdateVarFromModel(aComponent, aValue, aPanelNum)
	tModel = aComponent:GetAttribute("model");
	if (tModel == nil) then
		return;
	end

	VUHDO_lnfUpdateVar(tModel, aValue, aPanelNum);
	VUHDO_lnfUpdateAllModelControls(aComponent, aValue);
	VUHDO_lnfUpdateComponentsByConstraints(aComponent);

	tFunction = aComponent:GetAttribute("custom_function_post");
	if (tFunction ~= nil) then
		tIsInCustomFunction = true;
		tFunction(aComponent:GetParent(), aValue);
		tIsInCustomFunction = false;
	end
end
local VUHDO_lnfUpdateVarFromModel = VUHDO_lnfUpdateVarFromModel;



--
local tTableIndices;
local tGlobal;
local tLastField;
local tCnt;
local tIndex;
local tLastIndex;
function VUHDO_lnfGetValueFrom(aModel)
	if (VUHDO_isVariablesLoaded() and aModel ~= nil) then
		tTableIndices = VUHDO_splitString(aModel, ".");
		tGlobal = VUHDO_GLOBAL[tTableIndices[1]];
		tLastField = tGlobal;

		for tCnt = 2, #tTableIndices - 1 do
			tIndex = tTableIndices[tCnt];
			if (VUHDO_NUM_TEMPLATE == tIndex) then
				tIndex = DESIGN_MISC_PANEL_NUM;
			elseif (strfind(tIndex, VUHDO_VAL_TEMPLATE, 1, true)) then
				tIndex = VUHDO_getNumbersFromString(tIndex, 1)[1];
			end
			tLastField = tLastField[tIndex];
		end

		tLastIndex = tTableIndices[#tTableIndices];
		if (VUHDO_NUM_TEMPLATE == tLastIndex) then
			tLastIndex = DESIGN_MISC_PANEL_NUM;
		elseif (strfind(tLastIndex, VUHDO_VAL_TEMPLATE, 1, true)) then
			tLastIndex = VUHDO_getNumbersFromString(tLastIndex, 1)[1];
		end

		if (type(tLastField) == "table") then
			return tLastField[tLastIndex];
		else
			return tLastField;
		end
	else
		return nil;
	end
end
local VUHDO_lnfGetValueFrom = VUHDO_lnfGetValueFrom;



--
function VUHDO_lnfGetValueFromModel(aComponent)
	VUHDO_lnfUpdateComponentsByConstraints(aComponent);
	return VUHDO_lnfGetValueFrom(aComponent:GetAttribute("model"));
end
local VUHDO_lnfGetValueFromModel = VUHDO_lnfGetValueFromModel;



-- Slider
--
local tValue;
local tModel;
function VUHDO_lnfSliderUpdateModel(aSlider)
	tValue = tonumber(aSlider:GetValue());
	tModel = aSlider:GetParent():GetAttribute("model");
	if (tModel ~= nil and strfind(tModel, "barTexture", 1, true)) then
		if (VUHDO_STATUS_BARS[tValue] ~= nil) then
			tValue = VUHDO_STATUS_BARS[tValue][1];
		end
	end

	if (tModel ~= nil and strfind(tModel, "SOUND", 1, true)) then
		if (VUHDO_SOUNDS[tValue] ~= nil) then
			tValue = VUHDO_SOUNDS[tValue][1];
			if (tValue ~= nil) then
				PlaySoundFile(tValue);
			end
		end
	end

	VUHDO_lnfUpdateVarFromModel(aSlider:GetParent(), tValue);
end



--
local tValue;
local tModel;
local tIndex, tInfo;
function VUHDO_lnfSliderInitFromModel(aSlider)
	tValue = VUHDO_lnfGetValueFromModel(aSlider:GetParent());
	tModel = aSlider:GetParent():GetAttribute("model");

	if (tModel ~= nil and strfind(tModel, "barTexture", 1, true)) then
		local tIndex, tInfo;
		for tIndex, tInfo in pairs(VUHDO_STATUS_BARS) do
			if (tInfo[1] == tValue) then
				tValue = tIndex;
				break;
			end
		end
	end

	if (tModel ~= nil and strfind(tModel, "SOUND", 1, true)) then
		for tIndex, tInfo in pairs(VUHDO_SOUNDS) do
			if (tInfo[1] == tValue) then
				tValue = tIndex;
				break;
			end
		end
	end

	if (tValue ~= nil and tonumber(tValue) ~= nil) then
		aSlider:SetValue(tonumber(tValue));
	end
end



-- Check Button
--
local tIsChecked;
function VUHDO_lnfCheckButtonUpdateModel(aCheckButton)
	tIsChecked = aCheckButton:GetChecked();
	if (tIsChecked == nil or tIsChecked == 0) then
		tIsChecked = false;
	elseif(tIsChecked == 1) then
		tIsChecked = true;
	end
	VUHDO_lnfUpdateVarFromModel(aCheckButton, tIsChecked);
end



--
function VUHDO_lnfCheckButtonInitFromModel(aCheckButton)
	aCheckButton:SetChecked(VUHDO_lnfGetValueFromModel(aCheckButton));
	VUHDO_lnfCheckButtonClicked(aCheckButton);
	VUHDO_lnfCheckButtonOnLoad(aCheckButton);
end



-- Radio Button
--
function VUHDO_lnfRadioButtonUpdateModel(aRadioButton)
	VUHDO_lnfUpdateVarFromModel(aRadioButton, aRadioButton:GetAttribute("radio_value"));
end



--
local tRadioValue;
local tModelValue;
function VUHDO_lnfRadioButtonInitFromModel(aRadioButton)
	if (aRadioButton:GetAttribute("model") == nil) then
		return;
	end
	tRadioValue = aRadioButton:GetAttribute("radio_value");
	tModelValue = VUHDO_lnfGetValueFromModel(aRadioButton);
	if (tModelValue == nil) then
		tModelValue = false;
	end
	aRadioButton:SetChecked(tModelValue == tRadioValue);
	VUHDO_lnfRadioButtonOnShow(aRadioButton);
	VUHDO_lnfCheckButtonOnLoad(aRadioButton);
end



-- Edit Box
--
local tTable;
local tValues;
local tFunction;
function VUHDO_lnfEditBoxUpdateModel(anEditBox)
	tTable = anEditBox:GetParent():GetAttribute("combo_table");
	if (tTable ~= nil) then
		for _, tValues in pairs(tTable) do
			if (tValues[2] == anEditBox:GetText()) then
				VUHDO_lnfUpdateVarFromModel(anEditBox, tValues[1]);
				return;
			end
		end
	end

	tFunction = anEditBox:GetParent():GetAttribute("custom_function");
	if (tFunction ~= nil and anEditBox:GetParent():GetAttribute("derive_custom")) then
		tIsInCustomFunction = true;
		tFunction(anEditBox:GetParent(), anEditBox:GetText());
		tIsInCustomFunction = false;
	end

	VUHDO_lnfUpdateVarFromModel(anEditBox, anEditBox:GetText());

	tFunction = anEditBox:GetParent():GetAttribute("custom_function_post");
	if (tFunction ~= nil and anEditBox:GetParent():GetAttribute("derive_custom")) then
		tIsInCustomFunction = true;
		tFunction(anEditBox:GetParent(), anEditBox:GetText());
		tIsInCustomFunction = false;
	end

end



--
function VUHDO_lnfEditBoxInitFromModel(anEditBox)
	anEditBox:SetText(VUHDO_lnfGetValueFromModel(anEditBox) or "");
end



-- ComboBox
--
-- tInfo = { Value, Text/Texture }
local VUHDO_COMBO_ITEM_WIDTH;
local VUHDO_COMBO_ITEM_HEIGHT;
local VUHDO_COMBO_ITEMS_PER_COL;

local tTable;
local tItemName;
local tIndex, tCnt, tCnt2, tInfo;
local tItemPanel;
local tDropdownBox, tItemContainer;
local tXIdx;
local tYIdx;
local tMaxY;
local tHeight;
local tSpellId;
function VUHDO_lnfComboInitItems(aComboBox)
	tTable = aComboBox:GetAttribute("combo_table");

	if (tTable == nil) then
		return;
	end

	tXIdx = 0;
	tYIdx = 0;
	tMaxY = 0;

	if (aComboBox.isScrollable) then
		tDropdownBox = VUHDO_GLOBAL[aComboBox:GetName() .. "ScrollPanel"];
		tItemContainer = VUHDO_GLOBAL[aComboBox:GetName() .. "ScrollPanelSelectPanel"];
	else
		tDropdownBox = VUHDO_GLOBAL[aComboBox:GetName() .. "SelectPanel"];
		tItemContainer = VUHDO_GLOBAL[aComboBox:GetName() .. "SelectPanel"];
	end

	tCnt = 1;
	for tIndex, tInfo in ipairs(tTable) do
		if (aComboBox.isScrollable) then
			tItemName = aComboBox:GetName() .. "ScrollPanelSelectPanelItem" .. tIndex;
		else
			tItemName = aComboBox:GetName() .. "SelectPanelItem" .. tIndex;
		end

		if (VUHDO_GLOBAL[tItemName] == nil) then
			tItemPanel = CreateFrame("Frame", tItemName, tItemContainer, "VuhdoComboItemTemplate");
			if (aComboBox.isMulti) then
				VUHDO_GLOBAL[tItemName .. "CheckTextureTexture"]:SetTexture("Interface\\AddOns\\VuhDoOptions\\Images\\icon_check");
			else
				VUHDO_GLOBAL[tItemName .. "CheckTextureTexture"]:SetTexture("Interface\\AddOns\\VuhDo\\Images\\icon_red");
			end

			tItemPanel.parentCombo = aComboBox;
			tItemPanel.dropwdownBox = tDropdownBox;
		else
			tItemPanel = VUHDO_GLOBAL[tItemName];
		end

		tItemPanel:ClearAllPoints();
		if (type(tInfo[2]) == "string") then
			tSpellId = VUHDO_getNumbersFromString(tInfo[2], 1)[1];
			if (tSpellId) then
				tSpellId = tostring(tSpellId);
			end
			VUHDO_GLOBAL[tItemPanel:GetName() .. "IconTexture"]:SetTexture(VUHDO_getGlobalIcon(tSpellId or tInfo[2]));
			VUHDO_GLOBAL[tItemPanel:GetName() .. "IconTexture"]:SetTexCoord(0, 1, 0, 1);
			VUHDO_GLOBAL[tItemPanel:GetName() .. "LabelLabel"]:SetText(tInfo[2]);
			VUHDO_COMBO_ITEM_HEIGHT = 16;
			VUHDO_COMBO_ITEM_WIDTH = 220;
			VUHDO_COMBO_ITEMS_PER_COL = 25;
		else
			VUHDO_GLOBAL[tItemPanel:GetName() .. "IconTexture"]:SetTexture(VUHDO_GLOBAL[tInfo[2]:GetName() .. "I"]:GetTexture());
			VUHDO_GLOBAL[tItemPanel:GetName() .. "IconTexture"]:SetTexCoord(VUHDO_GLOBAL[tInfo[2]:GetName() .. "I"]:GetTexCoord());
			VUHDO_GLOBAL[tItemPanel:GetName() .. "Icon"]:SetWidth(30);
			VUHDO_GLOBAL[tItemPanel:GetName() .. "Icon"]:SetHeight(30);
			VUHDO_COMBO_ITEM_HEIGHT = 34;
			VUHDO_COMBO_ITEM_WIDTH = 50;
			VUHDO_COMBO_ITEMS_PER_COL = 3;
		end

		tItemPanel:SetPoint("TOPLEFT", tItemContainer:GetName(), "TOPLEFT", 3 + tXIdx * VUHDO_COMBO_ITEM_WIDTH, - (3 + tYIdx * VUHDO_COMBO_ITEM_HEIGHT));
		tItemPanel:SetWidth(VUHDO_COMBO_ITEM_WIDTH);
		tItemPanel:SetHeight(VUHDO_COMBO_ITEM_HEIGHT);
		tItemPanel:Show();
		tItemPanel:SetAttribute("value", tInfo[1]);
		if (aComboBox.isScrollable) then
			tItemPanel:SetBackdropColor(0, 0, 0, 0);
		end
		tCnt = tCnt + 1;
		if (tCnt > VUHDO_COMBO_MAX_ENTRIES and not aComboBox.isScrollable) then
			break;
		end

		tYIdx = tYIdx + 1;
		if (tYIdx > tMaxY) then
			tMaxY = tYIdx;
		end

		if (tYIdx > VUHDO_COMBO_ITEMS_PER_COL and not aComboBox.isScrollable) then
			tYIdx = 0;
			tXIdx = tXIdx + 1;
		end
	end

	if (tYIdx == 0 and tXIdx > 0) then
		tXIdx = tXIdx - 1;
	end

	for tCnt2 = tCnt, VUHDO_COMBO_MAX_ENTRIES do
		if (aComboBox.isScrollable) then
			tItemName = aComboBox:GetName() .. "ScrollPanelSelectPanelItem" .. tCnt2;
		else
			tItemName = aComboBox:GetName() .. "SelectPanelItem" .. tCnt2;
		end

		if (VUHDO_GLOBAL[tItemName] ~= nil) then
			VUHDO_GLOBAL[tItemName]:Hide();
		else
			break;
		end
	end

	if (tMaxY == 0)  then
		tMaxY = 1;
	end

	tDropdownBox:SetWidth((tXIdx + 1) * VUHDO_COMBO_ITEM_WIDTH + 6);
	tItemContainer:SetHeight(tMaxY * VUHDO_COMBO_ITEM_HEIGHT + 6);

	if (aComboBox.isScrollable) then
		tItemContainer:SetWidth(10); -- Doesn't matter

		tHeight = tMaxY * VUHDO_COMBO_ITEM_HEIGHT + 6;
		if (tHeight > 300) then
			tHeight = 300;
		end
		tDropdownBox:SetHeight(tHeight);
		tItemContainer:SetBackdropColor(0, 0, 0, 0);
	end
end



--
local tIndex, tInfo;
local tTexture;
local tTable;
local tFunction;
local tArrayModel;
local tIsInCustomFunction = false;
function VUHDO_lnfComboSetSelectedValue(aComboBox, aValue, anIsEditBox)
	tTable = aComboBox:GetAttribute("combo_table");
	if (tTable == nil) then
		return;
	end
	if (aComboBox.isMulti) then
		tArrayModel = VUHDO_lnfGetValueFromModel(aComboBox);

		if (aValue ~= nil) then
			if (tArrayModel[aValue]) then
				tArrayModel[aValue] = nil;
			else
				tArrayModel[aValue] = true;
			end
		end
	else
		tArrayModel = nil;
	end

	if (tArrayModel == nil and VUHDO_GLOBAL[aComboBox:GetName() .. "EditBox"] ~= nil and aValue ~= nil and not anIsEditBox) then
		VUHDO_GLOBAL[aComboBox:GetName() .. "EditBox"]:SetText(aValue);
	end

	if (VUHDO_GLOBAL[aComboBox:GetName() .. "EditBox"] == nil) then
		VUHDO_GLOBAL[aComboBox:GetName() .. "Text"]:SetText(VUHDO_I18N_SELECT);
	end

	for tIndex, tInfo in ipairs(tTable) do
		if (aComboBox.isScrollable) then
			tTexture = VUHDO_GLOBAL[aComboBox:GetName() .. "ScrollPanelSelectPanelItem" .. tIndex .. "CheckTexture"];
		elseif (tIndex > 100) then
			break;
		else
			tTexture = VUHDO_GLOBAL[aComboBox:GetName() .. "SelectPanelItem" .. tIndex .. "CheckTexture"];
		end

		if (tArrayModel ~= nil) then
			if (tArrayModel[tInfo[1]]) then
				tTexture:Show();
			else
				tTexture:Hide();
			end
		else
			if (aValue == tInfo[1]) then
				if (VUHDO_GLOBAL[aComboBox:GetName() .. "EditBox"] ~= nil) then
					VUHDO_GLOBAL[aComboBox:GetName() .. "EditBox"]:SetText(tInfo[2]);
				else
					VUHDO_GLOBAL[aComboBox:GetName() .. "Text"]:SetText(tInfo[2]);
				end
				tTexture:Show();
			else
				tTexture:Hide();
			end
		end
	end

	if (tIsInCustomFunction) then
		return;
	end

	tFunction = aComboBox:GetAttribute("custom_function");
	if (tFunction ~= nil) then
		tIsInCustomFunction = true;
		tFunction(aComboBox, aValue, tArrayModel);
		tIsInCustomFunction = false;
	end

	if (tArrayModel ~= nil) then
		VUHDO_lnfUpdateVarFromModel(aComboBox, tArrayModel, nil);
	else
		VUHDO_lnfUpdateVarFromModel(aComboBox, aValue, nil);
	end
end



--
local tValue;
local tTitle;
function VUHDO_lnfComboBoxInitFromModel(aComboBox)
	aComboBox.isScrollable = VUHDO_GLOBAL[aComboBox:GetName() .. "ScrollPanel"] ~= nil;

	if (aComboBox:GetAttribute("model") == nil) then
		return;
	end

	tValue = VUHDO_lnfGetValueFromModel(aComboBox);
	aComboBox.isMulti = "table" == type(tValue);
	VUHDO_lnfComboInitItems(aComboBox);

	tTitle = aComboBox:GetAttribute("title");
	if (tTitle ~= nil) then
		VUHDO_GLOBAL[aComboBox:GetName() .. "Text"]:SetText(tTitle);
	end


	if (aComboBox.isMulti) then
		VUHDO_lnfComboSetSelectedValue(aComboBox, nil);
	else
		VUHDO_lnfComboSetSelectedValue(aComboBox, tValue);
	end
end



-- Color Swatch
--
local tValue;
local tFont;
function VUHDO_lnfColorSwatchInitFromModel(aColorSwatch)
	tValue = VUHDO_lnfGetValueFromModel(aColorSwatch);

	if (tValue == nil) then
		return;
	end

	if (tValue.R ~= nil and tValue.useBackground) then
		VUHDO_GLOBAL[aColorSwatch:GetName() .. "Texture"]:SetVertexColor(tValue["R"], tValue["G"], tValue["B"]);
	else
		VUHDO_GLOBAL[aColorSwatch:GetName() .. "Texture"]:SetVertexColor(1, 1, 1);
	end

	if (tValue.O ~= nil and tValue.useOpacity) then
		VUHDO_GLOBAL[aColorSwatch:GetName() .. "Texture"]:SetAlpha(tValue["O"]);
	else
		VUHDO_GLOBAL[aColorSwatch:GetName() .. "Texture"]:SetAlpha(1);
	end

	if (tValue.TR ~= nil and tValue.useText) then
		VUHDO_GLOBAL[aColorSwatch:GetName() .. "TitleString"]:SetTextColor(tValue["TR"], tValue["TG"], tValue["TB"]);
	else
		VUHDO_GLOBAL[aColorSwatch:GetName() .. "TitleString"]:SetTextColor(1, 1, 1);
	end

	if (tValue.TO ~= nil and tValue.useOpacity) then
		VUHDO_GLOBAL[aColorSwatch:GetName() .. "TitleString"]:SetAlpha(tValue["TO"]);
	else
		VUHDO_GLOBAL[aColorSwatch:GetName() .. "TitleString"]:SetAlpha(1);
	end

	if (tValue.textSize ~= nil and tValue.font ~= nil) then
		local tFont = VUHDO_getFont(tValue["font"]);
		VUHDO_GLOBAL[aColorSwatch:GetName() .. "TitleString"]:SetFont(tFont, tValue["textSize"]);
	end
end



--
local tValue;
local tStatusFile;
function VUHDO_lnfTextureSwatchInitFromModel(aTexture)
	tValue = VUHDO_lnfGetValueFromModel(aTexture);

	if (tValue ~= nil) then
		tStatusFile = VUHDO_LibSharedMedia:Fetch('statusbar', tValue);
		if (tStatusFile ~= nil) then
			VUHDO_GLOBAL[aTexture:GetName() .. "Texture"]:SetTexture(tStatusFile);
		end
	end
end



--
function VUHDO_lnfInitColorSwatch(aColorSwatch, aText, aDescription, aProhibitColors)
	VUHDO_GLOBAL[aColorSwatch:GetName() .. "TitleString"]:SetText(aText);
	aColorSwatch:SetAttribute("description", aDescription);
	aColorSwatch:SetAttribute("prohibit", aProhibitColors);
end



--
function VUHDO_lnfColorSwatchShowColorPicker(aColorSwatch, aMouseButton)
	if (aColorSwatch:GetAttribute("model") == nil) then
		return;
	end
	VuhDoNewColorPicker:SetAttribute("swatch", aColorSwatch);
	VuhDoNewColorPicker:Show();
end



--
function VUHDO_lnfSetTooltip(aComponent, aText)
	aComponent:SetAttribute("tooltip", aText);
end



--
local tTooltip;
function VUHDO_lnfShowTooltip(aComponent)
	tTooltip = aComponent:GetAttribute("tooltip");
	if (tTooltip ~= nil) then
		VuhDoOptionsTooltipTextText:SetText(tTooltip);
		VuhDoOptionsTooltip:SetHeight(VuhDoOptionsTooltipTextText:GetHeight() + 10);
		VuhDoOptionsTooltip:ClearAllPoints();
		VuhDoOptionsTooltip:SetPoint("LEFT", aComponent:GetName(), "RIGHT", 3, 0);
		VuhDoOptionsTooltip:Show();
	end
end



--
function VUHDO_lnfHideTooltip(aComponent)
	VuhDoOptionsTooltip:Hide();
end



--
function VUHDO_lnfEditboxReceivedDrag(anEditBox)
	local tName = nil;
	local tType, tId, tId2 = GetCursorInfo();

	if ("item" == tType) then
		tName = GetItemInfo(tId) ;
	elseif ("spell" == tType) then
		tName = GetSpellBookItemName(tId, tId2);
	elseif("macro" == tType) then
		tName = GetMacroInfo(tId);
	end

	if (tName ~= nil) then
		anEditBox:SetText(tName);
	end

	ClearCursor();
end



--
function VUHDO_lnfScrollFrameOnLoad(aFrame)
	local tScrollBar = VUHDO_GLOBAL[aFrame:GetName() .. "ScrollBar"];
	VUHDO_GLOBAL[tScrollBar:GetName() .. "ScrollUpButton"]:Hide();
	VUHDO_GLOBAL[tScrollBar:GetName() .. "ScrollDownButton"]:Hide();
	local tThumbTexture = VUHDO_GLOBAL[tScrollBar:GetName() .. "ThumbTexture"];
	tThumbTexture:SetTexture("Interface\\AddOns\\VuhDoOptions\\Images\\slider_thumb_v");
	tThumbTexture:SetWidth(18);
	tThumbTexture:SetHeight(18);
	tThumbTexture:SetTexCoord(0, 1, 0, 1);
end


-------------------------------------------


VUHDO_LF_CONSTRAINT_DISABLE = 1;

local VUHDO_MODEL_CONSTRAINTS = { };
local VUHDO_COMPONENT_CONSTRAINTS = { };


--
function VUHDO_lnfAddConstraint(aComponent, aType, aModel, aTriggerValue)
	if (VUHDO_MODEL_CONSTRAINTS[aModel] == nil) then
		VUHDO_MODEL_CONSTRAINTS[aModel] = { };
	end
	tinsert(VUHDO_MODEL_CONSTRAINTS[aModel], { ["COMPONENT"] = aComponent, ["TYPE"] = aType });

	if (VUHDO_COMPONENT_CONSTRAINTS[aComponent] == nil) then
		VUHDO_COMPONENT_CONSTRAINTS[aComponent] = { }
	end

	tinsert(VUHDO_COMPONENT_CONSTRAINTS[aComponent], { ["MODEL"] = aModel, ["TYPE"] = aType, ["TRIGGER"] = aTriggerValue });
end



--
local tConstraints;
local tIsDisabled;
local tValue;
local function VUHDO_lnfIsDisabledByConstraint(aComponent)
	tConstraints = VUHDO_COMPONENT_CONSTRAINTS[aComponent] or {};

	tIsDisabled = false;
	for _, tConstraint in pairs(tConstraints) do
		if (VUHDO_LF_CONSTRAINT_DISABLE == tConstraint["TYPE"]) then
			tValue = VUHDO_lnfGetValueFrom(tConstraint["MODEL"]);
			if (tValue == tConstraint["TRIGGER"]) then
				tIsDisabled = true;
				break;
			end
		end
	end

	return tIsDisabled;
end



--
local tModel;
local tTriggerValue;
local tConstraints;
function VUHDO_lnfUpdateComponentsByConstraints(aChangedComponent)
	tModel = aChangedComponent:GetAttribute("model");
	tTriggerValue = VUHDO_lnfGetValueFrom(tModel);

	tConstraints = VUHDO_MODEL_CONSTRAINTS[tModel] or {};

	for _, tConstraint in pairs(tConstraints) do
		if (VUHDO_LF_CONSTRAINT_DISABLE == tConstraint["TYPE"]) then
			if (VUHDO_lnfIsDisabledByConstraint(tConstraint["COMPONENT"])) then
				tConstraint["COMPONENT"]:SetAlpha(0.5);
			else
				tConstraint["COMPONENT"]:SetAlpha(1);
			end
		end
	end
end



--
function VUHDO_lnfFontButtonClicked(aButton)
	VUHDO_lnfStandardFontInitFromModel(aButton:GetAttribute("model"), aButton:GetText());
end



--
function VUHDO_lnfShareButtonClicked(aButton)
	if (VuhDoLnfShareDialog:IsShown()) then
		VuhDoLnfShareDialog:Hide();
	else
		VUHDO_lnfSetModel(VuhDoLnfShareDialog, aButton:GetAttribute("model"));
		VuhDoLnfShareDialog:Show();
	end
end