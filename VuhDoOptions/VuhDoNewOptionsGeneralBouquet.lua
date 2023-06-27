VUHDO_BOUQET_COMBO_MODEL = { };
VUHDO_BOUQET_DETAILS_COMBO_MODEL = { };
VUHDO_BOUQUET_ICON_COMBO_MODEL = { };

local VUHDO_CURRENT_BOUQUET_CHOICE = nil;
local VUHDO_CURR_SELECTED_ITEM_INDEX = 0;
local VUHDO_BOUQUET_ITEMS = { };
local VUHDO_SUPPRESS_COMBO_FEEDBACK = false;
VUHDO_TEMP_BOUQUET_BUFF = nil;



local tCopy;
local function VUHDO_deepCopyColor(aColorTable)
	tCopy = VUHDO_deepCopyTable(aColorTable);
	tCopy.R = tCopy.R or 1;
	tCopy.G = tCopy.G or 1;
	tCopy.B = tCopy.B or 1;
	tCopy.O = tCopy.O or 1;
	tCopy.TR = tCopy.TR or 1;
	tCopy.TG = tCopy.TG or 1;
	tCopy.TB = tCopy.TB or 1;
	tCopy.TO = tCopy.TO or 1;
	tCopy.useText = true;
	tCopy.useBackground = true;
	tCopy.useOpacity = true;
	return tCopy;
end



--
function VUHDO_bouquetsUpdateDefaultColors()
	VUHDO_BOUQUET_BUFFS_SPECIAL["AGGRO"]["defaultColor"] = VUHDO_deepCopyColor({ ["R"] = 1, ["G"] = 0, ["B"] = 0 });
	VUHDO_BOUQUET_BUFFS_SPECIAL["NO_RANGE"]["defaultColor"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["OUTRANGED"]);
	VUHDO_BOUQUET_BUFFS_SPECIAL["IN_RANGE"]["defaultColor"] = VUHDO_deepCopyColor({});
	VUHDO_BOUQUET_BUFFS_SPECIAL["YARDS_RANGE"]["defaultColor"] = VUHDO_deepCopyColor({ ["R"] = 1, ["G"] = 0.5, ["B"] = 0 });
	VUHDO_BOUQUET_BUFFS_SPECIAL["OTHER"]["defaultColor"] = VUHDO_deepCopyColor({});
	--VUHDO_BOUQUET_BUFFS_SPECIAL["DEBUFF_DISPELLABLE"]["defaultColor"] = VUHDO_deepCopyColor({});
	VUHDO_BOUQUET_BUFFS_SPECIAL["DEBUFF_MAGIC"]["defaultColor"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF" .. VUHDO_DEBUFF_TYPE_MAGIC]);
	VUHDO_BOUQUET_BUFFS_SPECIAL["DEBUFF_DISEASE"]["defaultColor"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF" .. VUHDO_DEBUFF_TYPE_DISEASE]);
	VUHDO_BOUQUET_BUFFS_SPECIAL["DEBUFF_POISON"]["defaultColor"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF" .. VUHDO_DEBUFF_TYPE_POISON]);
	VUHDO_BOUQUET_BUFFS_SPECIAL["DEBUFF_CURSE"]["defaultColor"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF" .. VUHDO_DEBUFF_TYPE_CURSE]);
	VUHDO_BOUQUET_BUFFS_SPECIAL["DEBUFF_CHARMED"]["defaultColor"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["CHARMED"]);
	VUHDO_BOUQUET_BUFFS_SPECIAL["DEAD"]["defaultColor"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["DEAD"]);
	VUHDO_BOUQUET_BUFFS_SPECIAL["DISCONNECTED"]["defaultColor"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["OFFLINE"]);
	VUHDO_BOUQUET_BUFFS_SPECIAL["AFK"]["defaultColor"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["OFFLINE"]);
	VUHDO_BOUQUET_BUFFS_SPECIAL["PLAYER_TARGET"]["defaultColor"] = VUHDO_deepCopyColor({ ["R"] = 0.7, ["G"] = 0.7, ["B"] = 0.7 });
	VUHDO_BOUQUET_BUFFS_SPECIAL["MOUSE_TARGET"]["defaultColor"] = VUHDO_deepCopyColor({ ["R"] = 0.4, ["G"] = 0.4, ["B"] = 0.4 });
	VUHDO_BOUQUET_BUFFS_SPECIAL["MOUSE_GROUP"]["defaultColor"] = VUHDO_deepCopyColor({ ["R"] = 0.2, ["G"] = 0.2, ["B"] = 0.2 });
	VUHDO_BOUQUET_BUFFS_SPECIAL["HEALTH_BELOW"]["defaultColor"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["LIFE_LEFT"]["LOW"]);
	VUHDO_BOUQUET_BUFFS_SPECIAL["MANA_BELOW"]["defaultColor"] = VUHDO_deepCopyColor(VUHDO_POWER_TYPE_COLORS[VUHDO_UNIT_POWER_MANA]);
	VUHDO_BOUQUET_BUFFS_SPECIAL["THREAT_ABOVE"]["defaultColor"] = VUHDO_deepCopyColor({ ["R"] = 1, ["G"] = 0, ["B"] = 1 });
	VUHDO_BOUQUET_BUFFS_SPECIAL["NUM_CLUSTER"]["defaultColor"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["CLUSTER_GOOD"]);
	VUHDO_BOUQUET_BUFFS_SPECIAL["MOUSE_CLUSTER"]["defaultColor"] = VUHDO_deepCopyColor({ ["R"] = 1, ["G"] = 0.5, ["B"] = 0 });
	VUHDO_BOUQUET_BUFFS_SPECIAL["THREAT_LEVEL_MEDIUM"]["defaultColor"] = VUHDO_deepCopyColor({ ["R"] = 1, ["G"] = 0.5, ["B"] = 0 });
	VUHDO_BOUQUET_BUFFS_SPECIAL["THREAT_LEVEL_HIGH"]["defaultColor"] = VUHDO_deepCopyColor({ ["R"] = 1, ["G"] = 0, ["B"] = 0 });
	VUHDO_BOUQUET_BUFFS_SPECIAL["ALWAYS"]["defaultColor"] = VUHDO_deepCopyColor({});
end





--
local tInfo;
local function VUHDO_getBouquetItemDisplayText(aName)
	if (VUHDO_BOUQUET_BUFFS_SPECIAL[aName] ~= nil) then
		return "[" .. VUHDO_BOUQUET_BUFFS_SPECIAL[aName]["displayName"] .. "]";
	end
	return nil;
end



--
local tBouquetName;
local function VUHDO_getCurrentBouquetName()
	tBouquetName = VUHDO_BOUQUETS["SELECTED"];
	if (tBouquetName == nil or strlen(tBouquetName) == 0) then
		return nil;
	end

	return tBouquetName;
end



--
local tName;
local function VUHDO_getCurrentBouquet()
	tName = VUHDO_getCurrentBouquetName();
	if (tName == nil) then
		return nil;
	end
	VUHDO_BOUQUETS["STORED"][tName] = VUHDO_decompressIfCompressed(VUHDO_BOUQUETS["STORED"][tName]);
	return VUHDO_BOUQUETS["STORED"][tName];
end



--
local tBouquet;
function VUHDO_getCurrentBouquetItem()
	tBouquet = VUHDO_getCurrentBouquet();
	if (tBouquet == nil or VUHDO_CURR_SELECTED_ITEM_INDEX == 0) then
		return nil;
	end

	return tBouquet[VUHDO_CURR_SELECTED_ITEM_INDEX];
end



--
local tName, tInfo, tIndex;
function VUHDO_initBouquetComboModel()
	table.wipe(VUHDO_BOUQET_COMBO_MODEL);
	for tName, _ in pairs(VUHDO_BOUQUETS["STORED"]) do
		tinsert(VUHDO_BOUQET_COMBO_MODEL, { tName, tName } );
	end

	table.sort(VUHDO_BOUQET_COMBO_MODEL,
		function(anInfo, anotherInfo)
			return anInfo[1] < anotherInfo[1];
		end
	);

	table.wipe(VUHDO_BOUQET_DETAILS_COMBO_MODEL);
	for tName, tInfo in pairs(VUHDO_BOUQUET_BUFFS_SPECIAL) do
		tinsert(VUHDO_BOUQET_DETAILS_COMBO_MODEL, { tName, tInfo["displayName"] });
	end

	table.sort(VUHDO_BOUQET_DETAILS_COMBO_MODEL,
		function(anInfo, anotherInfo)
			return anInfo[2] < anotherInfo[2];
		end
	);

	table.wipe(VUHDO_BOUQUET_ICON_COMBO_MODEL);
	for tIndex, tInfo in ipairs(VUHDO_CUSTOM_ICONS) do
		tinsert(VUHDO_BOUQUET_ICON_COMBO_MODEL, { tIndex, tInfo[1] });
	end
end



--
local tFirst, tSecond;
function VUHDO_swapTable(aTable, anIndex, anotherIndex)
	tFirst = aTable[anIndex];
	tSecond = aTable[anotherIndex];

	aTable[anIndex] = tSecond;
	aTable[anotherIndex] = tFirst;
end



--
local function VUHDO_getOrCreateBouqetItem(anIndex, aPanel)
	if (VUHDO_BOUQUET_ITEMS[anIndex] == nil) then
		VUHDO_BOUQUET_ITEMS[anIndex] = CreateFrame("Button", "VuhDoBouquetItem" .. anIndex, aPanel, "VuhDoBouquetIconTemplate");
		VUHDO_BOUQUET_ITEMS[anIndex].buffIdx = anIndex;
	end

	return VUHDO_BOUQUET_ITEMS[anIndex];
end



--
local tName, tTexture;
local function VUHDO_initBouquetItem(aParent, anItemPanel, aBouquetName, aBuffIndex, aBuffInfo)
	tName = VUHDO_getBouquetItemDisplayText(aBuffInfo["name"]) or aBuffInfo["name"];
	anItemPanel:ClearAllPoints();
	anItemPanel:SetPoint("TOPLEFT", aParent:GetName(), 5, -(aBuffIndex - 1) * anItemPanel:GetHeight());
	VUHDO_GLOBAL[anItemPanel:GetName() .. "TitleLabelLabel"]:SetText("" .. aBuffIndex);
	VUHDO_GLOBAL[anItemPanel:GetName() .. "NameLabelLabel"]:SetText(tName);

	if (aBuffInfo["icon"] == 1) then
		tTexture = VUHDO_getGlobalIcon(tName);
	else
		tTexture = nil;
	end
	VUHDO_GLOBAL[anItemPanel:GetName() .. "DemoTextureBar"]:SetVertexColor(1, 1, 1, 1);
	if ((tTexture or "") ~= "") then
		VUHDO_GLOBAL[anItemPanel:GetName() .. "DemoTextureBar"]:SetTexture(tTexture);
		VUHDO_GLOBAL[anItemPanel:GetName() .. "DemoTextureIcon"]:Hide();
		VUHDO_GLOBAL[anItemPanel:GetName() .. "DemoTextureLabel"]:SetTextColor(1, 1, 1, 1);
	else
		VUHDO_GLOBAL[anItemPanel:GetName() .. "DemoTextureBar"]:SetTexture("Interface\\AddOns\\VuhDo\\Images\\bar15");
		VUHDO_GLOBAL[anItemPanel:GetName() .. "DemoTextureIcon"]:SetVertexColor(1, 1, 1);
		VUHDO_GLOBAL[anItemPanel:GetName() .. "DemoTextureIcon"]:SetTexture(VUHDO_CUSTOM_ICONS[aBuffInfo["icon"]][2] or "Interface\\AddOns\\VuhDo\\Images\\white_square_16_16");
		if (aBuffInfo["color"].useBackground) then
			VUHDO_GLOBAL[anItemPanel:GetName() .. "DemoTextureIcon"]:SetVertexColor(aBuffInfo["color"].R, aBuffInfo["color"].G, aBuffInfo["color"].B, aBuffInfo["color"].O);
		else
			VUHDO_GLOBAL[anItemPanel:GetName() .. "DemoTextureIcon"]:SetVertexColor(1, 1, 1, aBuffInfo["color"].O);
		end
		VUHDO_GLOBAL[anItemPanel:GetName() .. "DemoTextureIcon"]:Show();
		if (aBuffInfo["color"].useText) then
			VUHDO_GLOBAL[anItemPanel:GetName() .. "DemoTextureLabel"]:SetTextColor(aBuffInfo["color"].TR, aBuffInfo["color"].TG, aBuffInfo["color"].TB, aBuffInfo["color"].TO);
		else
			VUHDO_GLOBAL[anItemPanel:GetName() .. "DemoTextureLabel"]:SetTextColor(1, 1, 1, 0.3);
		end
	end
	VUHDO_GLOBAL[anItemPanel:GetName() .. "DemoTextureLabel"]:SetText("" .. aBuffIndex);

	anItemPanel:Show();
end



--
local tItem;
function VUHDO_setColorManuallyChanged()
	tItem = VUHDO_getCurrentBouquetItem();
	if (tItem ~= nil) then
		tItem["color"]["isManuallySet"] = true;
	end
end



--
local tCombo, tEditBox, tModel, tIsTempModel, tSwatch, tCheckBox, tCustomPanel, tBuffName;
local tPanel, tSubPanel, tSlider;
local tIndex, tSpecialName;
local tBouquetName, tBouquet, tInfo, tCurrentItem;
local tInnerPanel, tRadioButton, tSlider;
function VUHDO_rebuildBouquetContextEditors(anIndex)

	if (anIndex ~= nil) then
		tIndex = anIndex;
	elseif (tIndex == nil) then
		return;
	end

	VUHDO_SUPPRESS_COMBO_FEEDBACK = true;
	tIsTempModel = false;
	tBouquetName = VUHDO_getCurrentBouquetName();

	if (tBouquetName == nil or anIndex == 0) then -- Kein Bouquet gew„hlt
		tIsTempModel = true;
	else
		tBouquet = VUHDO_getCurrentBouquet(); -- Bouquetname ungespeichert
		if (tBouquet == nil or #tBouquet == 0) then
			tIsTempModel = true;
		else
			tInfo = VUHDO_getCurrentBouquetItem(); -- Keine Items im Bouquet
			if (tInfo == nil) then
				tIsTempModel = true;
			end
		end
	end

	VUHDO_BOUQUETS["STORED"][tBouquetName] = VUHDO_decompressIfCompressed(VUHDO_BOUQUETS["STORED"][tBouquetName]);

	tPanel = VuhDoNewOptionsGeneralBouquetBuffPanel;
	if (tIsTempModel) then
		tModel = "VUHDO_TEMP_BOUQUET_BUFF";
	else
		tModel = "VUHDO_BOUQUETS.STORED." .. tBouquetName .. ".##" .. tIndex;
	end

	tCombo = VUHDO_GLOBAL[tPanel:GetName() .. "NameComboBox"];
	VUHDO_setComboModel(tCombo, tModel .. ".name", VUHDO_BOUQET_DETAILS_COMBO_MODEL);
	VUHDO_lnfComboBoxInitFromModel(tCombo);

	tEditBox = VUHDO_GLOBAL[tPanel:GetName() .. "NameEditBox"];
	VUHDO_lnfSetModel(tEditBox, tModel .. ".name");
	VUHDO_lnfEditBoxInitFromModel(tEditBox);

	tCombo = VUHDO_GLOBAL[tPanel:GetName() .. "BuffOrIndicatorFrameIconComboBox"];
	VUHDO_setComboModel(tCombo, tModel .. ".icon", VUHDO_BOUQUET_ICON_COMBO_MODEL);
	VUHDO_lnfComboBoxInitFromModel(tCombo);

	tCurrentItem = VUHDO_getCurrentBouquetItem();
	if (tCurrentItem ~= nil and not tIsTempModel and not tCurrentItem["color"]["isManuallySet"]) then
		if (VUHDO_BOUQUET_BUFFS_SPECIAL[tCurrentItem["name"]] ~= nil and VUHDO_BOUQUET_BUFFS_SPECIAL[tCurrentItem["name"]]["defaultColor"] ~= nil) then
			tCurrentItem["color"] = VUHDO_deepCopyTable(VUHDO_BOUQUET_BUFFS_SPECIAL[tCurrentItem["name"]]["defaultColor"]);
		else
			tCurrentItem["color"] = VUHDO_deepCopyTable(VUHDO_SANE_BOUQUET_ITEM["color"]);
		end
	end

	tSwatch = VUHDO_GLOBAL[tPanel:GetName() .. "BuffOrIndicatorFrameColorTexture"];
	VUHDO_lnfSetModel(tSwatch, tModel .. ".color");
	VUHDO_lnfColorSwatchInitFromModel(tSwatch);

	tCheckBox = VUHDO_GLOBAL[tPanel:GetName() .. "BuffOrIndicatorFrameTextCheckBox"];
	VUHDO_lnfSetModel(tCheckBox, tModel .. ".color.useText");
	VUHDO_lnfCheckButtonInitFromModel(tCheckBox);

	tCheckBox = VUHDO_GLOBAL[tPanel:GetName() .. "BuffOrIndicatorFrameBackgroundCheckBox"];
	VUHDO_lnfSetModel(tCheckBox, tModel .. ".color.useBackground");
	VUHDO_lnfCheckButtonInitFromModel(tCheckBox);

	tCheckBox = VUHDO_GLOBAL[tPanel:GetName() .. "BuffOrIndicatorFrameOpacityCheckBox"];
	VUHDO_lnfSetModel(tCheckBox, tModel .. ".color.useOpacity");
	VUHDO_lnfCheckButtonInitFromModel(tCheckBox);

	VUHDO_GLOBAL[tPanel:GetName() .. "BuffOrIndicatorFrameMineOthersFrame"]:Hide();
	VUHDO_GLOBAL[tPanel:GetName() .. "BuffOrIndicatorFramePercentFrame"]:Hide();

	tBuffName = VUHDO_lnfGetValueFrom(tModel .. ".name");

	if (VUHDO_BOUQUET_BUFFS_SPECIAL[tBuffName] ~= nil
		and VUHDO_BOUQUET_BUFFS_SPECIAL[tBuffName]["custom_type"] == VUHDO_BOUQUET_CUSTOM_TYPE_STATUSBAR) then

		tInnerPanel = VUHDO_GLOBAL[tPanel:GetName() .. "StatusbarFrame"];

		tRadioButton = VUHDO_GLOBAL[tInnerPanel:GetName() .. "SolidRadioButton"];
		VUHDO_lnfSetRadioModel(tRadioButton, tModel .. ".custom.radio", 1);
		VUHDO_lnfRadioButtonInitFromModel(tRadioButton);

		tRadioButton = VUHDO_GLOBAL[tInnerPanel:GetName() .. "ClassColorRadioButton"];
		VUHDO_lnfSetRadioModel(tRadioButton, tModel .. ".custom.radio", 2);
		VUHDO_lnfRadioButtonInitFromModel(tRadioButton);

		tRadioButton = VUHDO_GLOBAL[tInnerPanel:GetName() .. "GradientRadioButton"];
		VUHDO_lnfSetRadioModel(tRadioButton, tModel .. ".custom.radio", 3);
		VUHDO_lnfRadioButtonInitFromModel(tRadioButton);

		tSlider = VUHDO_GLOBAL[tInnerPanel:GetName() .. "ClassColorBrightnessSlider"];
		VUHDO_lnfSetModel(tSlider, tModel .. ".custom.bright");
		VUHDO_lnfSliderOnLoad(tSlider, VUHDO_I18N_BRIGHTNESS, 0, 4, "x", 0.05);

		tSwatch = VUHDO_GLOBAL[tInnerPanel:GetName() .. "ColorTexture"];
		VUHDO_lnfSetModel(tSwatch, tModel .. ".color");
		VUHDO_lnfColorSwatchInitFromModel(tSwatch);

		if (tCurrentItem["custom"]["radio"] == 3) then

			if (tCurrentItem["custom"]["grad_low"] == nil) then
				tCurrentItem["custom"]["grad_low"] = {
					["R"] = 0.3, ["G"] = 0.3, ["B"] = 0.3, ["O"] = 1,
					["TR"] = 0.3, ["TG"] = 0.3, ["TB"] = 0.3, ["TO"] = 1,
					["useText"] = false, ["useBackground"] = true, ["useOpacity"] = true,
				};
			end

			if (tCurrentItem["custom"]["grad_med"] == nil) then
				tCurrentItem["custom"]["grad_med"]  = {
					["R"] = 0.6, ["G"] = 0.6, ["B"] = 0.6, ["O"] = 1,
					["TR"] = 0.6, ["TG"] = 0.6, ["TB"] = 0.6, ["TO"] = 1,
					["useText"] = false, ["useBackground"] = true, ["useOpacity"] = true,
				};
			end

			tSwatch = VUHDO_GLOBAL[tInnerPanel:GetName() .. "LowColorTexture"];
			tSwatch:Show();
			VUHDO_lnfSetModel(tSwatch, tModel .. ".custom.grad_low");
			VUHDO_lnfColorSwatchInitFromModel(tSwatch);

			tSwatch = VUHDO_GLOBAL[tInnerPanel:GetName() .. "FairColorTexture"];
			tSwatch:Show();
			VUHDO_lnfSetModel(tSwatch, tModel .. ".custom.grad_med");
			VUHDO_lnfColorSwatchInitFromModel(tSwatch);

			tSwatch = VUHDO_GLOBAL[tInnerPanel:GetName() .. "GoodColorTexture"];
			tSwatch:Show();
			VUHDO_lnfSetModel(tSwatch, tModel .. ".color");
			VUHDO_lnfColorSwatchInitFromModel(tSwatch);
		else
			tSwatch = VUHDO_GLOBAL[tInnerPanel:GetName() .. "LowColorTexture"];
			VUHDO_lnfSetModel(tSwatch, nil);
			tSwatch:Hide();

			tSwatch = VUHDO_GLOBAL[tInnerPanel:GetName() .. "FairColorTexture"];
			VUHDO_lnfSetModel(tSwatch, nil);
			tSwatch:Hide();

			tSwatch = VUHDO_GLOBAL[tInnerPanel:GetName() .. "GoodColorTexture"];
			VUHDO_lnfSetModel(tSwatch, nil);
			tSwatch:Hide();
		end

		if (VUHDO_BOUQUET_BUFFS_SPECIAL[tBuffName]["no_color"]) then
			tInnerPanel:Hide();
		else
			tInnerPanel:Show();
		end
		VUHDO_GLOBAL[tPanel:GetName() .. "BuffOrIndicatorFrame"]:Hide();
	else
		tInnerPanel = VUHDO_GLOBAL[tPanel:GetName() .. "BuffOrIndicatorFrame"];

		if (VUHDO_BOUQUET_BUFFS_SPECIAL[tBuffName] ~= nil) then
			if (VUHDO_BOUQUET_BUFFS_SPECIAL[tBuffName]["custom_type"] == VUHDO_BOUQUET_CUSTOM_TYPE_BRIGHTNESS) then
				tSubPanel = VUHDO_GLOBAL[tInnerPanel:GetName() .. "PercentFrame"];
				tSlider = VUHDO_GLOBAL[tSubPanel:GetName() .. "Slider"];
				VUHDO_lnfSetModel(tSlider, tModel .. ".custom.bright");
				VUHDO_lnfSliderOnLoad(tSlider, VUHDO_I18N_BRIGHTNESS, 0, 4, "x", 0.1);
				tSubPanel:Show();
			elseif (VUHDO_BOUQUET_BUFFS_SPECIAL[tBuffName]["custom_type"] == VUHDO_BOUQUET_CUSTOM_TYPE_PERCENT) then
				tSubPanel = VUHDO_GLOBAL[tInnerPanel:GetName() .. "PercentFrame"];
				tSlider = VUHDO_GLOBAL[tSubPanel:GetName() .. "Slider"];
				VUHDO_lnfSetModel(tSlider, tModel .. ".custom.##1");
				tSpecialName = VUHDO_BOUQUETS["STORED"][tBouquetName][tIndex]["name"];
				VUHDO_lnfSliderOnLoad(tSlider, VUHDO_BOUQUET_BUFFS_SPECIAL[tSpecialName]["displayName"], 0, 100, "");
				tSubPanel:Show();
			elseif (VUHDO_BOUQUET_BUFFS_SPECIAL[tBuffName]["custom_type"] == VUHDO_BOUQUET_CUSTOM_TYPE_HEALTH) then
				tSubPanel = VUHDO_GLOBAL[tInnerPanel:GetName() .. "PercentFrame"];
				tSlider = VUHDO_GLOBAL[tSubPanel:GetName() .. "Slider"];
				VUHDO_lnfSetModel(tSlider, tModel .. ".custom.##1");
				tSpecialName = VUHDO_BOUQUETS["STORED"][tBouquetName][tIndex]["name"];
				VUHDO_lnfSliderOnLoad(tSlider, VUHDO_BOUQUET_BUFFS_SPECIAL[tSpecialName]["displayName"], 0, 200, "k");
				tSubPanel:Show();
			elseif (VUHDO_BOUQUET_BUFFS_SPECIAL[tBuffName]["custom_type"] == VUHDO_BOUQUET_CUSTOM_TYPE_PLAYERS) then
				tSubPanel = VUHDO_GLOBAL[tInnerPanel:GetName() .. "PercentFrame"];
				tSlider = VUHDO_GLOBAL[tSubPanel:GetName() .. "Slider"];
				VUHDO_lnfSetModel(tSlider, tModel .. ".custom.##1");
				tSpecialName = VUHDO_BOUQUETS["STORED"][tBouquetName][tIndex]["name"];
				VUHDO_lnfSliderOnLoad(tSlider, VUHDO_BOUQUET_BUFFS_SPECIAL[tSpecialName]["displayName"], 0, 40, "");
				tSubPanel:Show();
			elseif (VUHDO_BOUQUET_BUFFS_SPECIAL[tBuffName]["custom_type"] == VUHDO_BOUQUET_CUSTOM_TYPE_HOLY_POWER) then
				tSubPanel = VUHDO_GLOBAL[tInnerPanel:GetName() .. "PercentFrame"];
				tSlider = VUHDO_GLOBAL[tSubPanel:GetName() .. "Slider"];
				VUHDO_lnfSetModel(tSlider, tModel .. ".custom.##1");
				tSpecialName = VUHDO_BOUQUETS["STORED"][tBouquetName][tIndex]["name"];
				VUHDO_lnfSliderOnLoad(tSlider, VUHDO_BOUQUET_BUFFS_SPECIAL[tSpecialName]["displayName"], 0, 3, "");
				tSubPanel:Show();
			elseif (VUHDO_BOUQUET_BUFFS_SPECIAL[tBuffName]["custom_type"] == VUHDO_BOUQUET_CUSTOM_TYPE_SECONDS) then
				tSubPanel = VUHDO_GLOBAL[tInnerPanel:GetName() .. "PercentFrame"];
				tSlider = VUHDO_GLOBAL[tSubPanel:GetName() .. "Slider"];
				VUHDO_lnfSetModel(tSlider, tModel .. ".custom.##1");
				tSpecialName = VUHDO_BOUQUETS["STORED"][tBouquetName][tIndex]["name"];
				VUHDO_lnfSliderOnLoad(tSlider, VUHDO_BOUQUET_BUFFS_SPECIAL[tSpecialName]["displayName"], 0, 100, " sec");
				tSubPanel:Show();
			elseif (VUHDO_BOUQUET_BUFFS_SPECIAL[tBuffName]["custom_type"] == VUHDO_BOUQUET_CUSTOM_TYPE_STACKS) then
				tSubPanel = VUHDO_GLOBAL[tInnerPanel:GetName() .. "PercentFrame"];
				tSlider = VUHDO_GLOBAL[tSubPanel:GetName() .. "Slider"];
				VUHDO_lnfSetModel(tSlider, tModel .. ".custom.##1");
				tSpecialName = VUHDO_BOUQUETS["STORED"][tBouquetName][tIndex]["name"];
				VUHDO_lnfSliderOnLoad(tSlider, VUHDO_BOUQUET_BUFFS_SPECIAL[tSpecialName]["displayName"], 0, 50, "#");
				tSubPanel:Show();
			else
				VUHDO_GLOBAL[tInnerPanel:GetName() .. "PercentFrame"]:Hide();
			end

			if (VUHDO_BOUQUET_BUFFS_SPECIAL[tBuffName]["no_color"]) then
				tSwatch = VUHDO_GLOBAL[tInnerPanel:GetName() .. "ColorTexture"];
				tSwatch:Hide();
				VUHDO_lnfSetModel(tSwatch, nil);
			else
				VUHDO_GLOBAL[tInnerPanel:GetName() .. "ColorTexture"]:Show();
			end
		else
			tInnerPanel = VUHDO_GLOBAL[tPanel:GetName() .. "BuffOrIndicatorFrame"];
			tSwatch = VUHDO_GLOBAL[tInnerPanel:GetName() .. "ColorTexture"];
			tSwatch:Show();

			tSubPanel = VUHDO_GLOBAL[tInnerPanel:GetName() .. "MineOthersFrame"];

			tCheckBox = VUHDO_GLOBAL[tSubPanel:GetName() .. "MineCheckButton"];
			VUHDO_lnfSetModel(tCheckBox, tModel .. ".mine");
			VUHDO_lnfCheckButtonInitFromModel(tCheckBox);

			tCheckBox = VUHDO_GLOBAL[tSubPanel:GetName() .. "OthersCheckButton"];
			VUHDO_lnfSetModel(tCheckBox, tModel .. ".others");
			VUHDO_lnfCheckButtonInitFromModel(tCheckBox);

			tCheckBox = VUHDO_GLOBAL[tSubPanel:GetName() .. "AliveTimeCheckButton"];
			VUHDO_lnfSetModel(tCheckBox, tModel .. ".alive");
			VUHDO_lnfCheckButtonInitFromModel(tCheckBox);

			tSubPanel:Show();
		end

		tInnerPanel:Show();
		VUHDO_GLOBAL[tPanel:GetName() .. "StatusbarFrame"]:Hide();
	end

	VUHDO_SUPPRESS_COMBO_FEEDBACK = false;
end



--
local tCurrentItemPanel = nil;
local tNewPanel;
local function VUHDO_setSelectedBouquetItem(anIndex)
	if (tCurrentItemPanel ~= nil) then
		tCurrentItemPanel:SetBackdropColor(1, 1, 1, 1);
	end

	if (anIndex > 0) then
		tNewPanel = VUHDO_getOrCreateBouqetItem(anIndex);
		tNewPanel:SetBackdropColor(0.8, 0.8, 1, 1);
		tCurrentItemPanel = tNewPanel;
	else
		tCurrentItemPanel = nil;
	end

	VUHDO_rebuildBouquetContextEditors(anIndex);
	VUHDO_CURR_SELECTED_ITEM_INDEX = anIndex;
end



--
local tPanel;
local tIndex, tName, tBouquet;
local tBuffInfo;
local tParent;
function VUHDO_rebuildAllBouquetItems(aParent, aCursorPos)
	-- Erstmal alles verstecken
	for _, tPanel in pairs(VUHDO_BOUQUET_ITEMS) do
		tPanel:Hide();
	end

	if (aParent ~= nil) then
		tParent = aParent;
	elseif(tParent == nil) then
		return;
	end

	tName = VUHDO_getCurrentBouquetName();
	VUHDO_CURRENT_BOUQUET_CHOICE = tName;
	if (tName ~= nil) then
		tBouquet = VUHDO_getCurrentBouquet();

		if (tBouquet ~= nil) then
			for tIndex, tBuffInfo in ipairs(tBouquet) do
				tPanel = VUHDO_getOrCreateBouqetItem(tIndex, tParent);
			end

			if (aCursorPos > 0) then
				VUHDO_setSelectedBouquetItem(aCursorPos);
			end

			for tIndex, tBuffInfo in ipairs(tBouquet) do
				tPanel = VUHDO_getOrCreateBouqetItem(tIndex, tParent);
				VUHDO_initBouquetItem(tParent, tPanel, tName, tIndex, tBuffInfo);
			end

			if (#tBouquet > 0) then
				tParent:SetHeight(#tBouquet * tPanel:GetHeight());
			end

		end
	end

	VUHDO_bouqetsChanged();
end



--
local tBouquet;
local tNewPos;
function VUHDO_bouquetItemButtonUpOnClick()
	tBouquet = VUHDO_getCurrentBouquet();

	if (VUHDO_CURR_SELECTED_ITEM_INDEX > 1) then
		tNewPos = VUHDO_CURR_SELECTED_ITEM_INDEX - 1
		VUHDO_swapTable(tBouquet, VUHDO_CURR_SELECTED_ITEM_INDEX, tNewPos);
		VUHDO_rebuildAllBouquetItems(nil, tNewPos);
	end
end



--
local tBouquet;
local tNewPos;
function VUHDO_bouquetItemButtonDownOnClick()
	tBouquet = VUHDO_getCurrentBouquet();

	if (VUHDO_CURR_SELECTED_ITEM_INDEX < #tBouquet and VUHDO_CURR_SELECTED_ITEM_INDEX > 0) then
		tNewPos = VUHDO_CURR_SELECTED_ITEM_INDEX + 1;
		VUHDO_swapTable(tBouquet, VUHDO_CURR_SELECTED_ITEM_INDEX, tNewPos);
		VUHDO_rebuildAllBouquetItems(nil, tNewPos);
	end
end



--
function VUHDO_bouquetItemButtonOnClick(aPanel)
	VUHDO_rebuildAllBouquetItems(nil, aPanel.buffIdx);
end


local VUHDO_GENERIC_BOUQUETS = {
	[VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH] = true,
	[VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH_CLASS_COLOR] = true,
	[VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH_SOLID] = true,
	[VUHDO_I18N_DEF_BOUQUET_TARGET_HEALTH] = true,
}



--
local tBouquet;
local tSelectLabel;
local tPanelName;
function VUHDO_bouquetsComboValueChanged(aParent, aValue)
	tBouquet = VUHDO_getCurrentBouquet();
	if (tBouquet ~= nil and #tBouquet > 0) then
		VUHDO_rebuildAllBouquetItems(nil, 1);
	else
		VUHDO_rebuildAllBouquetItems(nil, 0);
	end

	tPanelName = aParent:GetParent():GetName();
	tSelectLabel = VUHDO_GLOBAL[aParent:GetName() .. "SelectLabelLabel"];
	if (VUHDO_GENERIC_BOUQUETS[aValue]) then
		tSelectLabel:SetText(VUHDO_I18N_DO_NOT_EDIT_BOUQUET);
		tSelectLabel:SetTextColor(1, 0.3, 0.3, 1);
		VUHDO_GLOBAL[aParent:GetName() .. "DeleteButton"]:Hide();
		VUHDO_GLOBAL[tPanelName .. "DetailsPanelUpButton"]:Hide();
		VUHDO_GLOBAL[tPanelName .. "DetailsPanelDownButton"]:Hide();
		VUHDO_GLOBAL[tPanelName .. "DetailsPanelAddButton"]:Hide();
		VUHDO_GLOBAL[tPanelName .. "DetailsPanelRemoveButton"]:Hide();
	else
		tSelectLabel:SetText(VUHDO_I18N_SELECT_OR_ENTER_BOUQUET);
		tSelectLabel:SetTextColor(0.4, 0.4, 1, 1);
		VUHDO_GLOBAL[aParent:GetName() .. "DeleteButton"]:Show();
		VUHDO_GLOBAL[tPanelName .. "DetailsPanelUpButton"]:Show();
		VUHDO_GLOBAL[tPanelName .. "DetailsPanelDownButton"]:Show();
		VUHDO_GLOBAL[tPanelName .. "DetailsPanelAddButton"]:Show();
		VUHDO_GLOBAL[tPanelName .. "DetailsPanelRemoveButton"]:Show();
	end
end



--
local tBouquet;
function VUHDO_bouquetItemsOnShow(aParent)
	tBouquet = VUHDO_getCurrentBouquet();
	if (tBouquet ~= nil and #tBouquet > 0) then
		VUHDO_rebuildAllBouquetItems(aParent, 1);
	else
		VUHDO_rebuildAllBouquetItems(aParent, 0);
	end

end


--
function VUHDO_bouquetsBuffComboValueChanged(aComboBox, aValue)
	if (not VUHDO_SUPPRESS_COMBO_FEEDBACK) then
		VUHDO_rebuildAllBouquetItems(nil, VUHDO_CURR_SELECTED_ITEM_INDEX);
	end
end



--
local tName;
local tEditBox;
local tEditText;
function VUHDO_bouquetSaveButtonClicked(aPanel)
	tName = VUHDO_getCurrentBouquetName();
	tEditBox = VUHDO_GLOBAL[aPanel:GetName() .. "BouquetNameEditBox"];
	tEditText = tEditBox:GetText();
	if (tEditText ~= nil and strlen(tEditText) > 0 and tName ~= nil) then
		if (VUHDO_CURRENT_BOUQUET_CHOICE ~= nil and VUHDO_BOUQUETS["STORED"][VUHDO_CURRENT_BOUQUET_CHOICE] ~= nil) then

			if (tEditText ~= VUHDO_CURRENT_BOUQUET_CHOICE) then
				VUHDO_BOUQUETS["STORED"][tEditText] = VUHDO_deepCopyTable(VUHDO_BOUQUETS["STORED"][VUHDO_CURRENT_BOUQUET_CHOICE]);
				VUHDO_Msg(VUHDO_I18N_COPIED_BOUQUET .. VUHDO_CURRENT_BOUQUET_CHOICE .. " => " .. tEditText);
				VUHDO_BOUQUETS["SELECTED"] = tEditText;
			else
				VUHDO_Msg(tEditText .. VUHDO_I18N_BOUQUET_ALREADY_EXISTS);
			end
		else
			VUHDO_BOUQUETS["STORED"][tEditText] = { };
			VUHDO_Msg(VUHDO_I18N_CREATED_NEW_BOUQUET .. tEditText);
		end

		VUHDO_initBouquetComboModel();
		aPanel:Hide();
		aPanel:Show();
	else
		VUHDO_Msg(VUHDO_CURRENT_BOUQUET_CHOICE .. VUHDO_I18N_BOUQUET_NOT_FOUND);
	end
end



--
local tName;
function VUHDO_bouquetDeleteButtonClicked(aPanel)
	tName = VUHDO_getCurrentBouquetName();
	if (tName ~= nil) then
		if (VUHDO_BOUQUETS["STORED"][tName] ~= nil) then
			VUHDO_BOUQUETS["STORED"][tName] = nil;
			VUHDO_BOUQUETS["SELECTED"] = nil;
			VUHDO_initBouquetComboModel();
			aPanel:Hide();
			aPanel:Show();
			VUHDO_Msg(VUHDO_I18N_DELETED_BOUQUET .. tName);
		else
			VUHDO_Msg(VUHDO_BOUQUETS["SELECTED"] .. VUHDO_I18N_BOUQUET_NOT_FOUND);
		end
	end
end



--
local tName;
local tEditBox;
local tEditText;
function VUHDO_bouquetNewButtonClicked(aPanel)
	tName = VUHDO_getCurrentBouquetName();
	tEditBox = VUHDO_GLOBAL[aPanel:GetName() .. "BouquetNameEditBox"];
	tEditText = tEditBox:GetText();
	if (VUHDO_BOUQUETS["STORED"][tEditText] == nil and tEditText ~= nil and strlen(tEditText) > 0) then
		VUHDO_BOUQUETS["STORED"][tEditText] = { };
		VUHDO_BOUQUETS["SELECTED"] = tEditText;
		VUHDO_bouquetsComboValueChanged(aPanel, tEditText);
		VUHDO_initBouquetComboModel();
		aPanel:Hide();
		aPanel:Show();
		VUHDO_rebuildAllBouquetItems(nil, 0);
		VUHDO_Msg(VUHDO_I18N_CREATED_NEW_BOUQUET .. tEditText);
	elseif (tEditText ~= nil and strlen(tEditText) > 0) then
		VUHDO_Msg(tName .. VUHDO_I18N_BOUQUET_ALREADY_EXISTS);
	else
		VUHDO_Msg(VUHDO_I18N_SELECT_STORE_BOUQUET_FIRST);
	end
end



--
local tBouquet;
function VUHDO_bouquetItemAddClicked()
	tBouquet = VUHDO_getCurrentBouquet();
	if (tBouquet == nil) then
		VUHDO_Msg(VUHDO_I18N_SELECT_STORE_BOUQUET_FIRST);
		return;
	end

	tinsert(tBouquet, VUHDO_deepCopyTable(VUHDO_SANE_BOUQUET_ITEM));
	VUHDO_rebuildAllBouquetItems(nil, #tBouquet);
end



--
local tBouquet;
function VUHDO_bouquetItemRemoveClicked()
	tBouquet = VUHDO_getCurrentBouquet();
	if (tBouquet == nil) then
		VUHDO_Msg(VUHDO_I18N_SELECT_STORE_BOUQUET_FIRST);
		return;
	end

	if (VUHDO_CURR_SELECTED_ITEM_INDEX == 0) then
		return;
	end

	tremove(tBouquet, VUHDO_CURR_SELECTED_ITEM_INDEX);
	if (#tBouquet == 0) then
		VUHDO_rebuildBouquetContextEditors(0);
	end
	VUHDO_rebuildAllBouquetItems(nil, #tBouquet);
end



--
function VUHDO_trimAllBouquetItems()
	VUHDO_ensureAllBouquetItemsSanity();
end



--
function VUHDO_generalBouquetBackButtonClicked(aPanel)
	if (VUHDO_MENU_RETURN_TARGET_MAIN ~= nil) then
		VUHDO_newOptionsTabbedClickedClicked(VUHDO_MENU_RETURN_TARGET_MAIN);
		VUHDO_lnfRadioButtonClicked(VUHDO_MENU_RETURN_TARGET_MAIN);
		VUHDO_MENU_RETURN_TARGET_MAIN = nil;
	end

	if (VUHDO_MENU_RETURN_TARGET ~= nil) then
		VUHDO_lnfRadioButtonClicked(VUHDO_MENU_RETURN_TARGET);
		VUHDO_MENU_RETURN_FUNC(VUHDO_MENU_RETURN_TARGET);
		VUHDO_MENU_RETURN_TARGET = nil;
	end
end


function VUHDO_bouquetsBuffColorChanged()
	VUHDO_rebuildAllBouquetItems(nil, 0);
end
