local _;
VUHDO_RESET_SIZES = false;

local _G = _G;
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
	if aCheckButton:GetText() then
		local tTexts = VUHDO_splitString(aCheckButton:GetText(), "\n");
		_G[aCheckButton:GetName() .. "Label"]:SetText(tTexts[1]);

		if tTexts[2] and _G[aCheckButton:GetName() .. "Label2"] then
			_G[aCheckButton:GetName() .. "Label2"]:SetText(tTexts[2]);
		end
	end
end



--
function VUHDO_lnfTabCheckButtonOnLoad(aCheckButton)
	if aCheckButton:GetText() then
		_G[aCheckButton:GetName() .. "TextureCheckMarkLabel"]:SetText(aCheckButton:GetText());
		_G[aCheckButton:GetName() .. "Label"]:SetText(aCheckButton:GetText());
	end
end



--
function VUHDO_lnfCheckButtonClicked(aCheckButton)
	_G[aCheckButton:GetName() .. "TextureCheckMark"]:SetShown(aCheckButton:GetChecked());
end
local VUHDO_lnfCheckButtonClicked = VUHDO_lnfCheckButtonClicked;



--
function VUHDO_lnfRadioButtonClicked(aCheckButton)
	local tButton;

	for tCnt = 1, select("#", aCheckButton:GetParent():GetChildren()) do
		tButton = select(tCnt, aCheckButton:GetParent():GetChildren());
		if tButton:IsObjectType("CheckButton") and strfind(tButton:GetName(), "Radio", 1, true) then
			tButton:SetChecked(aCheckButton == tButton);
			VUHDO_lnfCheckButtonClicked(tButton);
		end
	end
end



--
function VUHDO_lnfTabRadioButtonClicked(aCheckButton)
	local tButton;
	VUHDO_lnfRadioButtonClicked(aCheckButton);

  -- Achtung: Zuerst verstecken dann erst anzeigen, damit OnShow/OnHide in der richtigen Reihenfolge kommt
	for tCnt = 1, select("#", aCheckButton:GetParent():GetChildren()) do
		tButton = select(tCnt, aCheckButton:GetParent():GetChildren());

		if tButton:IsObjectType("CheckButton")
			and strfind(tButton:GetName(), "Radio", 1, true)
			and tButton["tabPanel"] ~= nil
			and tButton["tabPanel"] ~= aCheckButton["tabPanel"] then
				 	_G[tButton["tabPanel"]]:Hide();
		end
	end

	_G[aCheckButton["tabPanel"]]:Show();
end



--
function VUHDO_lnfTabCheckButtonClicked(aCheckButton)
	local tButton;
	for tCnt = 1, select("#", aCheckButton:GetParent():GetChildren()) do
		tButton = select(tCnt, aCheckButton:GetParent():GetChildren());
		if tButton:IsObjectType("CheckButton") and strfind(tButton:GetName(), "Radio", 1, true) then
			if aCheckButton == tButton then
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
function VUHDO_lnfCheckButtonOnEnter(aCheckButton)
	local tName = aCheckButton:GetName();
	_G[tName .. "TextureActiveSwatch"]:Show();

	if _G[tName .. "Label"] then
		_G[tName .. "Label"]:SetTextColor(VUHDO_textColor(VUHDO_ACTIVE_LABEL_COLOR));
	end

	if _G[tName .. "Label2"] then
		_G[tName .. "Label2"]:SetTextColor(VUHDO_textColor(VUHDO_ACTIVE_LABEL_COLOR));
	end
end



--
function VUHDO_lnfCheckButtonOnLeave(aCheckButton)
	local tName = aCheckButton:GetName();
	_G[tName .. "TextureActiveSwatch"]:Hide();

	if _G[tName .. "Label"] then
		_G[tName .. "Label"]:SetTextColor(VUHDO_textColor(VUHDO_NORMAL_LABEL_COLOR));
	end

	if _G[tName .. "Label2"] then
		_G[tName .. "Label2"]:SetTextColor(VUHDO_textColor(VUHDO_NORMAL_LABEL_COLOR));
	end
end



--
function VUHDO_lnfRadioBoxOnEnter(aCheckButton)
	_G[aCheckButton:GetName() .. "TextureActiveSwatch"]:Show();
end



--
function VUHDO_lnfRadioBoxOnLeave(aCheckButton)
	_G[aCheckButton:GetName() .. "TextureActiveSwatch"]:Hide();
end



--
function VUHDO_lnfTabCheckButtonOnEnter(aCheckButton)
	local tName = aCheckButton:GetName();
	_G[tName .. "TextureActiveSwatch"]:Show();

	if aCheckButton:GetChecked() then
		_G[tName .. "TextureCheckMarkLabel"]:SetTextColor(VUHDO_textColor(VUHDO_ACTIVE_LABEL_COLOR));
	else
		_G[tName .. "Label"]:SetTextColor(VUHDO_textColor(VUHDO_ACTIVE_LABEL_COLOR_DISA));
	end
end



--
function VUHDO_lnfTabCheckButtonOnLeave(aCheckButton)
	local tName = aCheckButton:GetName();
	_G[tName .. "TextureActiveSwatch"]:Hide();

	if aCheckButton:GetChecked() then
		_G[aCheckButton:GetName() .. "TextureCheckMarkLabel"]:SetTextColor(VUHDO_textColor(VUHDO_NORMAL_LABEL_COLOR));
	else
		_G[aCheckButton:GetName() .. "Label"]:SetTextColor(VUHDO_textColor(VUHDO_NORMAL_LABEL_COLOR_DISA));
	end
end



--
local tText;
local tUnit;
function VUHDO_lnfSliderOnValueChanged(aSlider)
	if _G[aSlider:GetName() .. "SliderValue"] then
		tText = "" .. floor((_G[aSlider:GetName() .. "Slider"]:GetValue() + 0.005) * 100) * 0.01;
		tUnit = aSlider:GetAttribute("unit");

		if not VUHDO_strempty(tUnit) then tText = tText .. tUnit; end

		_G[aSlider:GetName() .. "SliderValue"]:SetText(tText);
	end
end



--
function VUHDO_lnfSliderOnLoad(aSlider, aText, aMinValue, aMaxValue, aUnitName, aValueStep)
	_G[aSlider:GetName() .. "SliderTitle"]:SetText(aText);
	aSlider:SetAttribute("unit", aUnitName);
	_G[aSlider:GetName() .. "Slider"]:SetMinMaxValues(aMinValue, aMaxValue);
	_G[aSlider:GetName() .. "Slider"]:SetValueStep(aValueStep or 1);
	VUHDO_lnfSliderOnValueChanged(aSlider);
end



--
local sLastComboItem = nil;

function VUHDO_lnfSetLastComboItem(anItem)
	sLastComboItem = anItem:GetName();
end



--
function VUHDO_lnfIsLastComboIten()
	local tFocus = GetMouseFocus();
	return tFocus ~= nil and tFocus:GetName() == sLastComboItem;
end



--
function VUHDO_lnfRadioButtonOnShow(aRadioButton)
	if aRadioButton:GetChecked() then
		VUHDO_lnfRadioButtonClicked(aRadioButton);
	end
end



--
function VUHDO_lnfComboItemOnEnter(aComboItem)
	local tComboBox = aComboItem.parentCombo;
	if IsMouseButtonDown() and not tComboBox["isMulti"] then
		VUHDO_lnfComboSetSelectedValue(tComboBox, aComboItem:GetAttribute("value"));
	end
	aComboItem:SetBackdropColor(0.8, 0.8, 1, 1);

	if not tComboBox["isMulti"] then
		_G[aComboItem:GetName() .. "Icon"]:SetScale(2);
		_G[aComboItem:GetName() .. "Icon"]:SetPoint("RIGHT", aComboItem:GetName(), "RIGHT", -10, 0);
	end
end



--
function VUHDO_lnfComboItemOnLeave(aComboItem)
	if aComboItem.parentCombo["isScrollable"] then aComboItem:SetBackdropColor(0, 0, 0, 0);
	else aComboItem:SetBackdropColor(1, 1, 1, 1); end

	tComboBox = aComboItem.parentCombo;
	if not tComboBox["isMulti"] then
		_G[aComboItem:GetName() .. "Icon"]:SetScale(1);
		_G[aComboItem:GetName() .. "Icon"]:SetPoint("RIGHT", aComboItem:GetName(), "RIGHT", -6, 0);
	end
end



--
local function VUHDO_hideAllComponentExtensions(aComponent)
	local tRootPane = aComponent:GetParent():GetParent();
	local tSubPanel, tComponent;

	for tCnt = 1, select("#", tRootPane:GetChildren()) do
		tSubPanel = select(tCnt, tRootPane:GetChildren());
		for tCnt2 = 1, select("#", tSubPanel:GetChildren()) do
			tComponent = select(tCnt2, tSubPanel:GetChildren());
			if aComponent ~= tComponent then
				-- 1. Combo-Flyouts
				if strfind(tComponent:GetName(), "Combo") then
					tSelectPanel = _G[tComponent:GetName() .. "ScrollPanel"] or _G[tComponent:GetName() .. "SelectPanel"];
					if tSelectPanel then
						tSelectPanel:Hide();
					end
				end

			end
		end
	end
end



--
function VUHDO_lnfComboButtonClicked(aButton)
	local tComboBox = aButton:GetParent();
	local tSelectPanel = _G[tComboBox:GetName() .. "ScrollPanel"] or _G[tComboBox:GetName() .. "SelectPanel"];

	if tSelectPanel:IsShown() then
		tSelectPanel:Hide();
	else
		if not tComboBox["prohibitCloseExtensions"] then
			VUHDO_hideAllComponentExtensions(tComboBox);
		end
		tSelectPanel:Show();
	end
end


--
function VUHDO_lnfComboSelectHide(aComboBox)
	if aComboBox["isScrollable"] then _G[aComboBox:GetName() .. "ScrollPanel"]:Hide();
	else _G[aComboBox:GetName() .. "SelectPanel"]:Hide(); end
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

	if _G[aComponent:GetName() .. "EditBox"] then
		VUHDO_lnfSetModel(_G[aComponent:GetName() .. "EditBox"], aModel);
	end
end



--
local VUHDO_lnfOnUpdate = false;
local function VUHDO_lnfUpdateAllModelControls(aComponent, aValue)
	local tModel;
	local tComp;
	local tCurrModel = aComponent:GetAttribute("model");

	if VUHDO_lnfOnUpdate or not tCurrModel then return; end

	local tPanel = aComponent:GetParent();
	if not tPanel then return; end

	VUHDO_lnfOnUpdate = true;

	for tCnt = 1, select("#", tPanel:GetChildren()) do
		tComp = select(tCnt, tPanel:GetChildren());

		tModel = tComp:GetAttribute("model");
		if tModel and strfind(tCurrModel, tModel , 1, true) and aComponent ~= tComp then
			if tComp:IsShown() then
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
local tIndex;
local tLastIndex;
local tEnd;
function VUHDO_lnfUpdateVar(aModel, aValue, aPanelNum)
	tPanelNum = nil;

	if not aPanelNum then aPanelNum = DESIGN_MISC_PANEL_NUM; end

	if VUHDO_isVariablesLoaded() and aModel then

		tTableIndices = VUHDO_splitString(aModel, ".");
		tGlobal = _G[tTableIndices[1]];
		tLastField = tGlobal;
		tEnd = #tTableIndices - 1;

		for tCnt = 2, tEnd do
			tIndex = tTableIndices[tCnt];
			if VUHDO_NUM_TEMPLATE == tIndex then
				tIndex = aPanelNum;
				tPanelNum = aPanelNum;
			elseif strfind(tIndex, VUHDO_VAL_TEMPLATE, 1, true) then
				tIndex = VUHDO_getNumbersFromString(tIndex, 1)[1];
			end

			tLastField = tLastField[tIndex];
		end
		tLastIndex = tTableIndices[#tTableIndices];
		if VUHDO_NUM_TEMPLATE == tLastIndex then
			tLastIndex = aPanelNum;
			tPanelNum = aPanelNum;
		elseif strfind(tLastIndex, VUHDO_VAL_TEMPLATE, 1, true) then
			tLastIndex = VUHDO_getNumbersFromString(tLastIndex, 1)[1];
		end

		if "table" == type(tLastField) then
			tLastField[tLastIndex] = aValue;
		else
			_G[tTableIndices[1]] = aValue;
		end

		if not InCombatLockdown() then
			if VUHDO_RESET_SIZES then resetSizeCalcCaches(); end

			if strfind(aModel, "VUHDO_OPTIONS_SETTINGS.", 1, true)
				or strfind(aModel, "INTERNAL_MODEL_", 1, true) then

			elseif tPanelNum then
				if (strfind(aModel, "TOOLTIP", 1, true) ~= nil) then
					VUHDO_demoTooltip(aPanelNum);
				else
					VUHDO_initDynamicPanelModels();
					VUHDO_timeRedrawPanel(tPanelNum, 0.3);
				end

			elseif strfind(aModel, "_BUFF_", 1, true) then
				VUHDO_reloadBuffPanel();

			elseif strfind(aModel, "BLIZZ_UI", 1, true) then
				VUHDO_initBlizzFrames();

			else
				if strfind(aModel, "VUHDO_CONFIG.", 1, true) then
					VUHDO_demoSetupResetUsers();
				end

				VUHDO_initDebuffs();
				VUHDO_customHealthInitLocalOverrides(); -- For life left colors
				VUHDO_timeReloadUI(0.3, true);
			end
		end
		VUHDO_toolboxInitLocalOverrides();
	end
end
local VUHDO_lnfUpdateVar = VUHDO_lnfUpdateVar;



--
local tModel, tFunction;
function VUHDO_lnfUpdateVarFromModel(aComponent, aValue, aPanelNum)
	tModel = aComponent:GetAttribute("model");
	if not tModel then return; end

	VUHDO_lnfUpdateVar(tModel, aValue, aPanelNum);
	VUHDO_lnfUpdateAllModelControls(aComponent, aValue);
	VUHDO_lnfUpdateComponentsByConstraints(aComponent);

	tFunction = aComponent:GetAttribute("custom_function_post");
	if tFunction then
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
local tIndex;
local tLastIndex;
function VUHDO_lnfGetValueFrom(aModel)
	if VUHDO_isVariablesLoaded() and aModel then
		tTableIndices = VUHDO_splitString(aModel, ".");
		tGlobal = _G[tTableIndices[1]];
		tLastField = tGlobal;

		for tCnt = 2, #tTableIndices - 1 do
			tIndex = tTableIndices[tCnt];

			if VUHDO_NUM_TEMPLATE == tIndex then
				tIndex = DESIGN_MISC_PANEL_NUM;

			elseif strfind(tIndex, VUHDO_VAL_TEMPLATE, 1, true) then
				tIndex = VUHDO_getNumbersFromString(tIndex, 1)[1];
			end

			tLastField = tLastField[tIndex];
		end

		tLastIndex = tTableIndices[#tTableIndices];
		if VUHDO_NUM_TEMPLATE == tLastIndex then
			tLastIndex = DESIGN_MISC_PANEL_NUM;

		elseif strfind(tLastIndex, VUHDO_VAL_TEMPLATE, 1, true) then
			tLastIndex = VUHDO_getNumbersFromString(tLastIndex, 1)[1];
		end

		if type(tLastField) == "table" then
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
	if tModel and strfind(tModel, "barTexture", 1, true) then
		if VUHDO_STATUS_BARS[tValue] then
			tValue = VUHDO_STATUS_BARS[tValue][1];
		end
	end


	--[[if tModel and strfind(tModel, "SOUND", 1, true) and VUHDO_SOUNDS[tValue] then
		tValue = VUHDO_SOUNDS[tValue][1];
		if tValue then PlaySoundFile(tValue); end
	end]]

	VUHDO_lnfUpdateVarFromModel(aSlider:GetParent(), tValue);
end



--
local tValue;
local tModel;
function VUHDO_lnfSliderInitFromModel(aSlider)
	tValue = VUHDO_lnfGetValueFromModel(aSlider:GetParent());
	tModel = aSlider:GetParent():GetAttribute("model");

	if tModel and strfind(tModel, "barTexture", 1, true) then
		local tIndex, tInfo;
		for tIndex, tInfo in pairs(VUHDO_STATUS_BARS) do
			if tInfo[1] == tValue then
				tValue = tIndex;
				break;
			end
		end
	end

	if tModel and strfind(tModel, "SOUND", 1, true) then
		for tIndex, tInfo in pairs(VUHDO_SOUNDS) do
			if tInfo[1] == tValue then
				tValue = tIndex;
				break;
			end
		end
	end

	if tValue and tonumber(tValue) then
		aSlider:SetValue(tonumber(tValue));
	end
end



-- Check Button
--
function VUHDO_lnfCheckButtonUpdateModel(aCheckButton)
	local tIsChecked = aCheckButton:GetChecked();

	if tIsChecked == nil or tIsChecked == 0 then
		tIsChecked = false;

	elseif tIsChecked == 1 then
		tIsChecked = true;
	end

	VUHDO_lnfUpdateVarFromModel(aCheckButton, tIsChecked);
end



--
function VUHDO_lnfInverseCheckButtonUpdateModel(aCheckButton)
	local tIsChecked = aCheckButton:GetChecked();

	if tIsChecked == nil or tIsChecked == 0 then
		tIsChecked = false;

	elseif tIsChecked == 1 then
		tIsChecked = true;
	end
	VUHDO_lnfUpdateVarFromModel(aCheckButton, not tIsChecked);
end


--
function VUHDO_lnfCheckButtonInitFromModel(aCheckButton)
	aCheckButton:SetChecked(VUHDO_lnfGetValueFromModel(aCheckButton));
	VUHDO_lnfCheckButtonClicked(aCheckButton);
	VUHDO_lnfCheckButtonOnLoad(aCheckButton);
end



--
function VUHDO_lnfInverseCheckButtonInitFromModel(aCheckButton)
	aCheckButton:SetChecked(not VUHDO_lnfGetValueFromModel(aCheckButton));
	VUHDO_lnfCheckButtonClicked(aCheckButton);
	VUHDO_lnfCheckButtonOnLoad(aCheckButton);
end



--
local function VUHDO_triStateSetSelected(aCheckButton)
	local tValue = VUHDO_lnfGetValueFromModel(aCheckButton);
	local tTexture = _G[aCheckButton:GetName() .. "TextureCheckMark"];
	local tLabel = _G[aCheckButton:GetName() .. "Label2"];

	tTexture:ClearAllPoints();

	if 3 == tValue then
		tTexture:SetPoint("BOTTOMLEFT", aCheckButton:GetName(), "BOTTOMLEFT", 5, 0);
		_G[tTexture:GetName() .. "Texture"]:SetVertexColor(1, 0.4, 0.4, 1);
		tLabel:SetTextColor(0.6, 0, 0, 1);

	elseif 2 == tValue then
		tTexture:SetPoint("LEFT", aCheckButton:GetName(), "LEFT", 5, 0);
		_G[tTexture:GetName() .. "Texture"]:SetVertexColor(1, 1, 0.4, 1);
		tLabel:SetTextColor(0, 0, 0.6, 1);

	else
		tTexture:SetPoint("TOPLEFT", aCheckButton:GetName(), "TOPLEFT", 5, 0);
		_G[tTexture:GetName() .. "Texture"]:SetVertexColor(0.4, 1, 0.4, 1);
		tLabel:SetTextColor(0, 0.6, 0, 1);
	end

	tLabel:SetText(aCheckButton:GetAttribute("radio_value")[tValue]);
end



--
function VUHDO_lnfTriStateCheckButtonUpdateModel(aCheckButton)
	local tValue = VUHDO_lnfGetValueFromModel(aCheckButton);
	tValue = (tValue % 3) + 1;
	VUHDO_lnfUpdateVarFromModel(aCheckButton, tValue);
	VUHDO_triStateSetSelected(aCheckButton);
end



--
function VUHDO_lnfTriStateCheckButtonInitFromModel(aCheckButton)
	VUHDO_lnfCheckButtonOnLoad(aCheckButton);
	VUHDO_triStateSetSelected(aCheckButton);
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
	if not aRadioButton:GetAttribute("model") then return; end

	tRadioValue = aRadioButton:GetAttribute("radio_value");
	tModelValue = VUHDO_lnfGetValueFromModel(aRadioButton);

	if tModelValue == nil then tModelValue = false; end

	aRadioButton:SetChecked(tModelValue == tRadioValue);
	VUHDO_lnfRadioButtonOnShow(aRadioButton);
	VUHDO_lnfCheckButtonOnLoad(aRadioButton);
end



-- Edit Box
--
local tTable;
local tFunction;
function VUHDO_lnfEditBoxUpdateModel(anEditBox)
	tTable = anEditBox:GetParent():GetAttribute("combo_table");

	if tTable then
		for _, tValues in pairs(tTable) do
			if tValues[2] == anEditBox:GetText() then
				VUHDO_lnfUpdateVarFromModel(anEditBox, tValues[1]);
				return;
			end
		end
	end

	tFunction = anEditBox:GetParent():GetAttribute("custom_function");
	if tFunction and anEditBox:GetParent():GetAttribute("derive_custom") then
		tIsInCustomFunction = true;
		tFunction(anEditBox:GetParent(), anEditBox:GetText());
		tIsInCustomFunction = false;
	end

	VUHDO_lnfUpdateVarFromModel(anEditBox, anEditBox:GetText());

	tFunction = anEditBox:GetParent():GetAttribute("custom_function_post");
	if tFunction and anEditBox:GetParent():GetAttribute("derive_custom") then
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
local tCnt;
local tItemPanel;
local tDropdownBox, tItemContainer;
local tXIdx;
local tYIdx;
local tMaxY;
local tHeight;
local tSpellId;
function VUHDO_lnfComboInitItems(aComboBox)
	tTable = aComboBox:GetAttribute("combo_table");

	if not tTable then return; end

	tXIdx = 0;
	tYIdx = 0;
	tMaxY = 0;

	if aComboBox["isScrollable"] then
		tDropdownBox = _G[aComboBox:GetName() .. "ScrollPanel"];
		tItemContainer = _G[aComboBox:GetName() .. "ScrollPanelSelectPanel"];
	else
		tDropdownBox = _G[aComboBox:GetName() .. "SelectPanel"];
		tItemContainer = _G[aComboBox:GetName() .. "SelectPanel"];
	end

	tCnt = 1;
	for tIndex, tInfo in ipairs(tTable) do
		if aComboBox["isScrollable"] then
			tItemName = aComboBox:GetName() .. "ScrollPanelSelectPanelItem" .. tIndex;
		else
			tItemName = aComboBox:GetName() .. "SelectPanelItem" .. tIndex;
		end

		if not _G[tItemName] then
			tItemPanel = CreateFrame("Frame", tItemName, tItemContainer, "VuhdoComboItemTemplate");
			if aComboBox["isMulti"] then
				_G[tItemName .. "CheckTextureTexture"]:SetTexture("Interface\\AddOns\\VuhDoOptions\\Images\\icon_check");
			else
				_G[tItemName .. "CheckTextureTexture"]:SetTexture("Interface\\AddOns\\VuhDo\\Images\\icon_red");
			end

			tItemPanel["parentCombo"] = aComboBox;
			tItemPanel["dropwdownBox"] = tDropdownBox;
		else
			tItemPanel = _G[tItemName];
		end

		tItemPanel:ClearAllPoints();
		if (type(tInfo[2]) == "string") then
			tSpellId = VUHDO_getNumbersFromString(tInfo[2], 1)[1];
			if tSpellId then tSpellId = tostring(tSpellId); end

			_G[tItemPanel:GetName() .. "IconTexture"]:SetTexture(VUHDO_getGlobalIcon(tSpellId or tInfo[2]));
			_G[tItemPanel:GetName() .. "IconTexture"]:SetTexCoord(0, 1, 0, 1);
			_G[tItemPanel:GetName() .. "LabelLabel"]:SetText(tInfo[2]);
			VUHDO_COMBO_ITEM_HEIGHT = 16;
			VUHDO_COMBO_ITEM_WIDTH = 220;
			VUHDO_COMBO_ITEMS_PER_COL = 25;
		else
			_G[tItemPanel:GetName() .. "IconTexture"]:SetTexture(_G[tInfo[2]:GetName() .. "I"]:GetTexture());
			_G[tItemPanel:GetName() .. "IconTexture"]:SetTexCoord(_G[tInfo[2]:GetName() .. "I"]:GetTexCoord());
			_G[tItemPanel:GetName() .. "Icon"]:SetWidth(30);
			_G[tItemPanel:GetName() .. "Icon"]:SetHeight(30);
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
		if tCnt > VUHDO_COMBO_MAX_ENTRIES and not aComboBox["isScrollable"] then
			break;
		end

		tYIdx = tYIdx + 1;
		if tYIdx > tMaxY then tMaxY = tYIdx; end

		if tYIdx > VUHDO_COMBO_ITEMS_PER_COL and not aComboBox["isScrollable"] then
			tYIdx = 0;
			tXIdx = tXIdx + 1;
		end
	end

	if (tYIdx == 0 and tXIdx > 0) then
		tXIdx = tXIdx - 1;
	end

	for tCnt2 = tCnt, VUHDO_COMBO_MAX_ENTRIES do
		if aComboBox["isScrollable"] then
			tItemName = aComboBox:GetName() .. "ScrollPanelSelectPanelItem" .. tCnt2;
		else
			tItemName = aComboBox:GetName() .. "SelectPanelItem" .. tCnt2;
		end

		if _G[tItemName] then _G[tItemName]:Hide();
		else break; end
	end

	if tMaxY == 0 then tMaxY = 1; end

	tDropdownBox:SetWidth((tXIdx + 1) * VUHDO_COMBO_ITEM_WIDTH + 6);
	tItemContainer:SetHeight(tMaxY * VUHDO_COMBO_ITEM_HEIGHT + 6);

	if aComboBox["isScrollable"] then
		tItemContainer:SetWidth(10); -- Doesn't matter

		tHeight = tMaxY * VUHDO_COMBO_ITEM_HEIGHT + 6;
		if tHeight > 300 then tHeight = 300; end

		tDropdownBox:SetHeight(tHeight);
		tItemContainer:SetBackdropColor(0, 0, 0, 0);
	end
end



--
local tTexture;
local tTable;
local tFunction;
local tArrayModel;
local tIsInCustomFunction = false;
function VUHDO_lnfComboSetSelectedValue(aComboBox, aValue, anIsEditBox)
	tTable = aComboBox:GetAttribute("combo_table");
	if not tTable then return; end

	if aComboBox["isMulti"] then
		tArrayModel = VUHDO_lnfGetValueFromModel(aComboBox);

		if aValue then
			if tArrayModel[aValue] then tArrayModel[aValue] = nil;
			else tArrayModel[aValue] = true; end
		end
	else
		tArrayModel = nil;
	end

	if not tArrayModel and _G[aComboBox:GetName() .. "EditBox"] ~= nil and aValue ~= nil and not anIsEditBox then
		_G[aComboBox:GetName() .. "EditBox"]:SetText(aValue);
	end

	if not _G[aComboBox:GetName() .. "EditBox"] then
		_G[aComboBox:GetName() .. "Text"]:SetText(VUHDO_I18N_SELECT);
	end

	for tIndex, tInfo in ipairs(tTable) do
		if (aComboBox.isScrollable) then
			tTexture = _G[aComboBox:GetName() .. "ScrollPanelSelectPanelItem" .. tIndex .. "CheckTexture"];
		elseif (tIndex > 100) then
			break;
		else
			tTexture = _G[aComboBox:GetName() .. "SelectPanelItem" .. tIndex .. "CheckTexture"];
		end

		if tArrayModel then
			if tArrayModel[tInfo[1]] then tTexture:Show();
			else tTexture:Hide(); end
		else
			if aValue == tInfo[1] then
				if _G[aComboBox:GetName() .. "EditBox"] then
					_G[aComboBox:GetName() .. "EditBox"]:SetText(tInfo[2]);
				else
					_G[aComboBox:GetName() .. "Text"]:SetText(tInfo[2]);
				end
				tTexture:Show();
			else
				tTexture:Hide();
			end
		end
	end

	if tIsInCustomFunction then return; end

	tFunction = aComboBox:GetAttribute("custom_function");
	if tFunction then
		tIsInCustomFunction = true;
		tFunction(aComboBox, aValue, tArrayModel);
		tIsInCustomFunction = false;
	end

	if tArrayModel then
		VUHDO_lnfUpdateVarFromModel(aComboBox, tArrayModel, nil);
	else
		VUHDO_lnfUpdateVarFromModel(aComboBox, aValue, nil);
	end
end



--
local tValue;
local tTitle;
function VUHDO_lnfComboBoxInitFromModel(aComboBox)
	aComboBox.isScrollable = _G[aComboBox:GetName() .. "ScrollPanel"] ~= nil;

	if not aComboBox:GetAttribute("model") then return; end

	tValue = VUHDO_lnfGetValueFromModel(aComboBox);
	aComboBox["isMulti"] = "table" == type(tValue);
	VUHDO_lnfComboInitItems(aComboBox);

	tTitle = aComboBox:GetAttribute("title");
	if tTitle then _G[aComboBox:GetName() .. "Text"]:SetText(tTitle); end


	if aComboBox["isMulti"] then
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

	if not tValue then return; end

	if tValue.R and tValue.useBackground then
		_G[aColorSwatch:GetName() .. "Texture"]:SetVertexColor(tValue["R"], tValue["G"], tValue["B"]);
	else
		_G[aColorSwatch:GetName() .. "Texture"]:SetVertexColor(1, 1, 1);
	end

	if tValue.O and tValue.useOpacity then
		_G[aColorSwatch:GetName() .. "Texture"]:SetAlpha(tValue["O"]);
	else
		_G[aColorSwatch:GetName() .. "Texture"]:SetAlpha(1);
	end

	if tValue.TR and tValue.useText then
		_G[aColorSwatch:GetName() .. "TitleString"]:SetTextColor(tValue["TR"], tValue["TG"], tValue["TB"]);
	else
		_G[aColorSwatch:GetName() .. "TitleString"]:SetTextColor(1, 1, 1);
	end

	if tValue.TO and tValue.useOpacity then
		_G[aColorSwatch:GetName() .. "TitleString"]:SetAlpha(tValue["TO"]);
	else
		_G[aColorSwatch:GetName() .. "TitleString"]:SetAlpha(1);
	end

	if tValue.textSize and tValue.font then
		local tFont = VUHDO_getFont(tValue["font"]);
		_G[aColorSwatch:GetName() .. "TitleString"]:SetFont(tFont, tValue["textSize"]);
	end
end



--
local tValue;
local tStatusFile;
function VUHDO_lnfTextureSwatchInitFromModel(aTexture)
	tValue = VUHDO_lnfGetValueFromModel(aTexture);

	if tValue then
		tStatusFile = VUHDO_LibSharedMedia:Fetch('statusbar', tValue);
		if tStatusFile then
			_G[aTexture:GetName() .. "Texture"]:SetTexture(tStatusFile);
		end
	end
end



--
function VUHDO_lnfInitColorSwatch(aColorSwatch, aText, aDescription, aProhibitColors)
	_G[aColorSwatch:GetName() .. "TitleString"]:SetText(aText);
	aColorSwatch:SetAttribute("description", aDescription);
	aColorSwatch:SetAttribute("prohibit", aProhibitColors);
end



--
function VUHDO_lnfColorSwatchShowColorPicker(aColorSwatch, aMouseButton)
	if not aColorSwatch:GetAttribute("model") then return; end

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

	if "item" == tType then
		tName = GetItemInfo(tId) ;
	elseif "spell" == tType then
		tName = GetSpellBookItemName(tId, tId2);
	elseif "macro" == tType then
		tName = GetMacroInfo(tId);
	end

	if tName then anEditBox:SetText(tName); end
	ClearCursor();
end



--
function VUHDO_lnfScrollFrameOnLoad(aFrame)
	local tScrollBar = _G[aFrame:GetName() .. "ScrollBar"];
	_G[tScrollBar:GetName() .. "ScrollUpButton"]:Hide();
	_G[tScrollBar:GetName() .. "ScrollDownButton"]:Hide();
	local tThumbTexture = _G[tScrollBar:GetName() .. "ThumbTexture"];
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
	if not VUHDO_MODEL_CONSTRAINTS[aModel] then
		VUHDO_MODEL_CONSTRAINTS[aModel] = { };
	end
	tinsert(VUHDO_MODEL_CONSTRAINTS[aModel], { ["COMPONENT"] = aComponent, ["TYPE"] = aType });

	if not VUHDO_COMPONENT_CONSTRAINTS[aComponent] then
		VUHDO_COMPONENT_CONSTRAINTS[aComponent] = { };
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

		if VUHDO_LF_CONSTRAINT_DISABLE == tConstraint["TYPE"] then
			tValue = VUHDO_lnfGetValueFrom(tConstraint["MODEL"]);
			if tValue == tConstraint["TRIGGER"] then
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
		if VUHDO_LF_CONSTRAINT_DISABLE == tConstraint["TYPE"] then

			if VUHDO_lnfIsDisabledByConstraint(tConstraint["COMPONENT"]) then
				tConstraint["COMPONENT"]:SetAlpha(0.5);
			else
				tConstraint["COMPONENT"]:SetAlpha(1);
			end
		end
	end
end



--
function VUHDO_lnfFontButtonClicked(aButton)
	VUHDO_lnfStandardFontInitFromModel(aButton:GetAttribute("model"), aButton:GetText(), aButton);
end



--
function VUHDO_lnfShareButtonClicked(aButton)
	if VuhDoLnfShareDialog:IsShown() then
		VuhDoLnfShareDialog:Hide();
	else
		VUHDO_lnfSetModel(VuhDoLnfShareDialog, aButton:GetAttribute("model"));
		VuhDoLnfShareDialog:Show();
	end
end