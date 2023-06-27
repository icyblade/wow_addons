--
local VUHDO_INDICATORS = {
	{ -- Outer Border
		["name"] = VUHDO_I18N_OUTER_BORDER,
		["model"] = "VUHDO_INDICATOR_CONFIG.BOUQUETS.BAR_BORDER",
		["icon"] = "Indicator_Outer",
		["custom"] = {
			{
				["name"] = VUHDO_I18N_BORDER_WIDTH,
				["type"] = VUHDO_MIN_MAX_CONSTRAINTS,
				["min"] = 1, ["max"] = 20, ["step"] = 1, ["unit"] = " Pt.",
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.BAR_BORDER.WIDTH",
				["tooltip"] = nil,
			},
			{
				["name"] = "Texture",
				["type"] = VUHDO_ENUMERATOR_CONSTRAINTS,
				["enumerator"] = VUHDO_BORDERS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.BAR_BORDER.FILE",
				["tooltip"] = nil,
			},
			{
				["name"] = "Adjust",
				["type"] = VUHDO_MIN_MAX_CONSTRAINTS,
				["min"] = -20, ["max"] = 0, ["step"] = 1, ["unit"] = "",
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.BAR_BORDER.ADJUST",
				["tooltip"] = nil,
			},
		},
	},

	{ -- Inner Border
		["name"] = VUHDO_I18N_INNER_BORDER,
		["model"] = "VUHDO_INDICATOR_CONFIG.BOUQUETS.CLUSTER_BORDER",
		["icon"] = "Indicator_Inner",
		["custom"] = {
			{
				["name"] = VUHDO_I18N_BORDER_WIDTH,
				["type"] = VUHDO_MIN_MAX_CONSTRAINTS,
				["min"] = 1, ["max"] = 20, ["step"] = 1, ["unit"] = " Pt.",
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.CLUSTER_BORDER.WIDTH",
				["tooltip"] = nil,
			},
			{
				["name"] = "Texture",
				["type"] = VUHDO_ENUMERATOR_CONSTRAINTS,
				["enumerator"] = VUHDO_BORDERS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.CLUSTER_BORDER.FILE",
				["tooltip"] = nil,
			},
		},
	},

	{ -- Swiftmend Indicator
		["name"] = VUHDO_I18N_SWIFTMEND_INDICATOR,
		["model"] = "VUHDO_INDICATOR_CONFIG.BOUQUETS.SWIFTMEND_INDICATOR",
		["icon"] = "Indicator_Swiftmend",
		["custom"] = {
			{
				["name"] = VUHDO_I18N_SCALE,
				["type"] = VUHDO_MIN_MAX_CONSTRAINTS,
				["min"] = 0.5, ["max"] = 4, ["step"] = 0.05, ["unit"] = " x",
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.SWIFTMEND_INDICATOR.SCALE",
				["tooltip"] = nil,
			},
		},
	},

	{ -- MouseoverHiglighter
		["name"] = VUHDO_I18N_MOUSEOVER_HIGHLIGHTER,
		["model"] = "VUHDO_INDICATOR_CONFIG.BOUQUETS.MOUSEOVER_HIGHLIGHT",
		["icon"] = "Indicator_BarHighlight",
		["custom"] = {
			{
				["name"] = VUHDO_I18N_BAR_TEXTURE,
				["type"] = VUHDO_ENUMERATOR_CONSTRAINTS,
				["enumerator"] = VUHDO_STATUS_BARS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.MOUSEOVER_HIGHLIGHT.TEXTURE",
				["tooltip"] = VUHDO_I18N_TT.K076,
			},
		},
	},

	{ -- Aggro Line
		["name"] = VUHDO_I18N_AGGRO_LINE,
		["model"] = "VUHDO_INDICATOR_CONFIG.BOUQUETS.AGGRO_BAR",
		["icon"] = "Indicator_Aggro",
		["custom"] = {
			{
				["name"] = VUHDO_I18N_BAR_TEXTURE,
				["type"] = VUHDO_ENUMERATOR_CONSTRAINTS,
				["enumerator"] = VUHDO_STATUS_BARS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.AGGRO_BAR.TEXTURE",
				["tooltip"] = VUHDO_I18N_TT.K076,
			},
		},
	},

	{ -- Threat Marks
		["name"] = VUHDO_I18N_THREAT_MARKS,
		["model"] = "VUHDO_INDICATOR_CONFIG.BOUQUETS.THREAT_MARK",
		["icon"] = "Indicator_AggroMark",
		["custom"] = { },
	},

	{ -- Threat Bar
		["name"] = VUHDO_I18N_THREAT_BAR,
		["model"] = "VUHDO_INDICATOR_CONFIG.BOUQUETS.THREAT_BAR",
		["icon"] = "Indicator_ThreatBar",
		["custom"] = {
			{
				["name"] = VUHDO_I18N_BAR_HEIGHT,
				["type"] = VUHDO_MIN_MAX_CONSTRAINTS,
				["min"] = 1, ["max"] = 20, ["step"] = 1, ["unit"] = "",
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.THREAT_BAR.HEIGHT",
				["tooltip"] = VUHDO_I18N_TT.K179,
			},
			{
				["name"] = VUHDO_I18N_BAR_TEXTURE,
				["type"] = VUHDO_ENUMERATOR_CONSTRAINTS,
				["enumerator"] = VUHDO_STATUS_BARS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.THREAT_BAR.TEXTURE",
				["tooltip"] = VUHDO_I18N_TT.K076,
			},
			{
				["name"] = VUHDO_I18N_INV_GROWTH,
				["type"] = VUHDO_BOOLEAN_CONSTRAINTS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.THREAT_BAR.invertGrowth",
				["tooltip"] = VUHDO_I18N_TT.K307,
			},
			{
				["name"] = VUHDO_I18N_TURN_AXIS,
				["type"] = VUHDO_BOOLEAN_CONSTRAINTS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.THREAT_BAR.turnAxis",
				["tooltip"] = VUHDO_I18N_TT.K471,
			},
		},
	},

	{ -- Mana Bar
		["name"] = VUHDO_I18N_MANA_BAR,
		["model"] = "VUHDO_INDICATOR_CONFIG.BOUQUETS.MANA_BAR",
		["icon"] = "Indicator_ManaBar",
		["custom"] = {
			{
				["name"] = VUHDO_I18N_BAR_TEXTURE,
				["type"] = VUHDO_ENUMERATOR_CONSTRAINTS,
				["enumerator"] = VUHDO_STATUS_BARS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.MANA_BAR.TEXTURE",
				["tooltip"] = VUHDO_I18N_TT.K076,
			},
			{
				["name"] = VUHDO_I18N_INV_GROWTH,
				["type"] = VUHDO_BOOLEAN_CONSTRAINTS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.MANA_BAR.invertGrowth",
				["tooltip"] = VUHDO_I18N_TT.K307,
			},
			{
				["name"] = VUHDO_I18N_TURN_AXIS,
				["type"] = VUHDO_BOOLEAN_CONSTRAINTS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.MANA_BAR.turnAxis",
				["tooltip"] = VUHDO_I18N_TT.K471,
			},
		},
	},

	{ -- Background Bar
		["name"] = VUHDO_I18N_BACKGROUND_BAR,
		["model"] = "VUHDO_INDICATOR_CONFIG.BOUQUETS.BACKGROUND_BAR",
		["icon"] = "Indicator_BackgroundBar",
		["custom"] = {
			{
				["name"] = VUHDO_I18N_BAR_TEXTURE,
				["type"] = VUHDO_ENUMERATOR_CONSTRAINTS,
				["enumerator"] = VUHDO_STATUS_BARS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.BACKGROUND_BAR.TEXTURE",
				["tooltip"] = VUHDO_I18N_TT.K076,
			},
		},
	},

	{ -- Health Bar
		["name"] = VUHDO_I18N_HEALTH_BAR,
		["model"] = "VUHDO_INDICATOR_CONFIG.BOUQUETS.HEALTH_BAR",
		["icon"] = "Indicator_HealthBar",
		["custom"] = {
			{
				["name"] = VUHDO_I18N_INV_GROWTH,
				["type"] = VUHDO_BOOLEAN_CONSTRAINTS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.HEALTH_BAR.invertGrowth",
				["tooltip"] = VUHDO_I18N_TT.K307,
			},
			{
				["name"] = VUHDO_I18N_VERTICAL,
				["type"] = VUHDO_BOOLEAN_CONSTRAINTS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.HEALTH_BAR.vertical",
				["tooltip"] = VUHDO_I18N_TT.K308,
			},
			{
				["name"] = VUHDO_I18N_TURN_AXIS,
				["type"] = VUHDO_BOOLEAN_CONSTRAINTS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.HEALTH_BAR.turnAxis",
				["tooltip"] = VUHDO_I18N_TT.K471,
			},
		},
	},

	{ -- Side Bar left
		["name"] = VUHDO_I18N_SIDE_BAR_LEFT,
		["model"] = "VUHDO_INDICATOR_CONFIG.BOUQUETS.SIDE_LEFT",
		["icon"] = "Indicator_LeftSide",
		["custom"] = {
			{
				["name"] = VUHDO_I18N_BAR_TEXTURE,
				["type"] = VUHDO_ENUMERATOR_CONSTRAINTS,
				["enumerator"] = VUHDO_STATUS_BARS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.SIDE_LEFT.TEXTURE",
				["tooltip"] = VUHDO_I18N_TT.K076,
			},
			{
				["name"] = VUHDO_I18N_INV_GROWTH,
				["type"] = VUHDO_BOOLEAN_CONSTRAINTS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.SIDE_LEFT.invertGrowth",
				["tooltip"] = VUHDO_I18N_TT.K307,
			},
			{
				["name"] = VUHDO_I18N_VERTICAL,
				["type"] = VUHDO_BOOLEAN_CONSTRAINTS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.SIDE_LEFT.vertical",
				["tooltip"] = VUHDO_I18N_TT.K308,
			},
			{
				["name"] = VUHDO_I18N_TURN_AXIS,
				["type"] = VUHDO_BOOLEAN_CONSTRAINTS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.SIDE_LEFT.turnAxis",
				["tooltip"] = VUHDO_I18N_TT.K471,
			},
		},
	},

	{ -- Side Bar Right
		["name"] = VUHDO_I18N_SIDE_BAR_RIGHT,
		["model"] = "VUHDO_INDICATOR_CONFIG.BOUQUETS.SIDE_RIGHT",
		["icon"] = "Indicator_RightSide",
		["custom"] = {
			{
				["name"] = VUHDO_I18N_BAR_TEXTURE,
				["type"] = VUHDO_ENUMERATOR_CONSTRAINTS,
				["enumerator"] = VUHDO_STATUS_BARS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.SIDE_RIGHT.TEXTURE",
				["tooltip"] = VUHDO_I18N_TT.K076,
			},
			{
				["name"] = VUHDO_I18N_INV_GROWTH,
				["type"] = VUHDO_BOOLEAN_CONSTRAINTS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.SIDE_RIGHT.invertGrowth",
				["tooltip"] = VUHDO_I18N_TT.K307,
			},
			{
				["name"] = VUHDO_I18N_VERTICAL,
				["type"] = VUHDO_BOOLEAN_CONSTRAINTS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.SIDE_RIGHT.vertical",
				["tooltip"] = VUHDO_I18N_TT.K308,
			},
			{
				["name"] = VUHDO_I18N_TURN_AXIS,
				["type"] = VUHDO_BOOLEAN_CONSTRAINTS,
				["model"] = "VUHDO_INDICATOR_CONFIG.CUSTOM.SIDE_RIGHT.turnAxis",
				["tooltip"] = VUHDO_I18N_TT.K471,
			},
		},
	},
}


VUHDO_BOUQUET_SLOTS_COMBO_MODEL = { };

function VUHDO_initBouquetSlotsComboModel()
	table.wipe(VUHDO_BOUQUET_SLOTS_COMBO_MODEL);

	for tName, _ in pairs(VUHDO_BOUQUETS["STORED"]) do
		tinsert(VUHDO_BOUQUET_SLOTS_COMBO_MODEL, { tName, tName } );
	end

	table.sort(VUHDO_BOUQUET_SLOTS_COMBO_MODEL,
		function(anInfo, anotherInfo)
			return anInfo[2] < anotherInfo[2];
		end
	);

	tinsert(VUHDO_BOUQUET_SLOTS_COMBO_MODEL, 1, {"", " -- off / empty --" });
end



--
local tCombo;
local function VUHDO_setBouquetSelectorModel(aPanel, aText, aModel, aTexture)
	VUHDO_GLOBAL[aPanel:GetName() .. "SelectLabelLabel"]:SetText(aText);

	VUHDO_GLOBAL[aPanel:GetName() .. "SchemaTexture"]:SetTexture("Interface\\AddOns\\VuhDoOptions\\Images\\" .. aTexture);
	tCombo = VUHDO_GLOBAL[aPanel:GetName() .. "SelectComboBox"];
	VUHDO_setComboModel(tCombo, aModel, VUHDO_BOUQUET_SLOTS_COMBO_MODEL);
	VUHDO_lnfComboBoxInitFromModel(tCombo);
end



--
function VUHDO_notifyBouquetSelect()
	VUHDO_registerAllBouquets(false);
	VUHDO_initAllEventBouquets();
end



--
local tCombo;
function VUHDO_generalIndicatorsEditButtonClicked(aButton)
	tCombo = VUHDO_GLOBAL[aButton:GetParent():GetName() .. "SelectComboBox"];
	VUHDO_BOUQUETS["SELECTED"] = VUHDO_lnfGetValueFromModel(tCombo);

	VUHDO_MENU_RETURN_FUNC = VUHDO_newOptionsGeneralIndicatorsClicked;
	VUHDO_MENU_RETURN_TARGET = VuhDoNewOptionsGeneralRadioPanelIndicatorsRadioButton;
	VUHDO_MENU_RETURN_TARGET_MAIN = nil;

	VUHDO_newOptionsGeneralBouquetClicked(VuhDoNewOptionsGeneralRadioPanelBouquetRadioButton);
	VUHDO_lnfRadioButtonClicked(VuhDoNewOptionsGeneralRadioPanelBouquetRadioButton);
end



--
local tName;
local tSlider;
local function VUHDO_createSliderForComponent(anIndex, tElement, aParent)
	tName = "VuhDoIndicatorOptionsSlider" .. aParent:GetName() .. anIndex;
	tSlider = VUHDO_GLOBAL[tName];
	if (tSlider == nil) then
		tSlider = CreateFrame("Frame", tName, aParent, "VuhDoHSliderTemplate");
	end

	tSlider:SetWidth(150);
	tSlider:SetHeight(32);

	VUHDO_lnfSliderOnLoad(tSlider, tElement["name"], tElement["min"], tElement["max"], tElement["unit"], tElement["step"]);
	VUHDO_lnfSetModel(tSlider, tElement["model"]);
	VUHDO_lnfSliderInitFromModel(tSlider);
	VUHDO_lnfSetTooltip(tSlider, tElement["tooltip"]);

	return tSlider;
end



--
local tName;
local tCheckButton;
local function VUHDO_createCheckBoxForComponent(anIndex, tElement, aParent)
	tName = "VuhDoIndicatorOptions" .. aParent:GetName() .. anIndex .. "CheckButton";
	tCheckButton = VUHDO_GLOBAL[tName];
	if (tCheckButton == nil) then
		tCheckButton = CreateFrame("CheckButton", tName, aParent, "VuhDoCheckButtonTemplate");
	end
	tCheckButton:SetText(tElement["name"]);
	VUHDO_lnfCheckButtonOnLoad(tCheckButton);
	VUHDO_lnfSetModel(tCheckButton, tElement["model"]);
	VUHDO_lnfCheckButtonInitFromModel(tCheckButton);
	VUHDO_lnfSetTooltip(tCheckButton, tElement["tooltip"]);

	return tCheckButton;
end



--
local tName;
local tPanel, tCombo, tTexture;
local function VUHDO_createComboBoxForComponent(anIndex, tElement, aParent)
	tName = "VuhDoIndicatorOptionsComboPanel" .. aParent:GetName() .. anIndex;
	tPanel = VUHDO_GLOBAL[tName];
	if (tPanel == nil) then
		tPanel = CreateFrame("Frame", tName, aParent, "VuhDoMoreButtonsTexturePanel");
	end

	tPanel:SetWidth(150);
	tPanel:SetHeight(70);

	tCombo = VUHDO_GLOBAL[tName .. "Combo"];
	VUHDO_setComboModel(tCombo, tElement["model"], tElement["enumerator"]);
	VUHDO_lnfComboBoxInitFromModel(tCombo);
	VUHDO_lnfSetTooltip(tCombo, tElement["tooltip"]);

	tTexture = VUHDO_GLOBAL[tName .. "Texture"];
	if (strfind(tElement["model"], "TEXTURE")) then
		VUHDO_lnfSetModel(tTexture, tElement["model"]);
		VUHDO_lnfTextureSwatchInitFromModel(tTexture);
		VUHDO_GLOBAL[tTexture:GetName() .. "TitleString"]:SetText(tElement["name"]);
		tTexture:Show();
	else
		tTexture:Hide();
	end
	return tPanel;
end



--
local tIndex, tElement, tComponent, tYCompOfs, tHeight;
local function VUHDO_buildCustomComponents(aPanel, someCustomElements)
	tYCompOfs = -10;
	for tIndex, tElement in ipairs(someCustomElements) do
		if (VUHDO_MIN_MAX_CONSTRAINTS == tElement["type"]) then
			tComponent = VUHDO_createSliderForComponent(tIndex, tElement, aPanel);
			tHeight = tComponent:GetHeight() + 10;
		elseif(VUHDO_ENUMERATOR_CONSTRAINTS == tElement["type"]) then
			tComponent = VUHDO_createComboBoxForComponent(tIndex, tElement, aPanel);
			tHeight = tComponent:GetHeight() + 10;
		elseif(VUHDO_BOOLEAN_CONSTRAINTS == tElement["type"]) then
			tComponent = VUHDO_createCheckBoxForComponent(tIndex, tElement, aPanel);
			tHeight = tComponent:GetHeight() + 10;
		end

		if (tComponent ~= nil) then
			tComponent:ClearAllPoints();
			tComponent:SetPoint("TOP", aPanel:GetName(), "TOP", 0, tYCompOfs);
			tYCompOfs = tYCompOfs - tHeight;
		end
	end

	return -tYCompOfs;
end



--
local tIndex, tIndicator;
local tBouqetSlotName, tBouquetSlot, tXOfs, tYOfs, tOffset, tMorePanel, tHeight;
function VUHDO_newOptionsIndicatorsBuildScrollChild(aScrollChild)
	tXOfs = 10;
	tYOfs = 0;
	tYIndex = 0;
	for tIndex, tIndicator in ipairs(VUHDO_INDICATORS) do
		tBouqetSlotName = "VuhDoBouqetSlotItem" .. tIndex;

		if (VUHDO_GLOBAL[tBouqetSlotName] == nil) then
			tBouquetSlot = CreateFrame("ScrollFrame", tBouqetSlotName, aScrollChild, "VuhDoBouquetSlotTemplate");
		else
			tBouquetSlot = VUHDO_GLOBAL[tBouqetSlotName];
		end

		tBouquetSlot:ClearAllPoints();
		tBouquetSlot:SetPoint("TOPLEFT", aScrollChild:GetName(), "TOPLEFT", tXOfs, - tYIndex * tBouquetSlot:GetHeight() - 3);
		VUHDO_setBouquetSelectorModel(tBouquetSlot, tIndicator["name"], tIndicator["model"], tIndicator["icon"]);

		if (#tIndicator["custom"] > 0) then
			tMorePanel = VUHDO_GLOBAL[tBouqetSlotName .. "MorePanel"];
			tHeight = VUHDO_buildCustomComponents(tMorePanel, tIndicator["custom"]);
			tMorePanel:SetHeight(tHeight + 30);
		else
			VUHDO_GLOBAL[tBouqetSlotName .. "MoreButton"]:Hide();
		end

		tYIndex = tYIndex + 1;
		if (tYIndex >= 6) then
			tXOfs = 10 + 10 + tBouquetSlot:GetWidth() + 100;
			tYIndex = 0;
		end
	end
end

