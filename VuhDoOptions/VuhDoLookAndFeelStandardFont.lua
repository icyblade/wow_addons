local sPanelName = "VuhDoLnfIconTextDialogRootPane";
local sLastName = nil;
local sTable = nil;

--
function VUHDO_lnfStandardFontInitFromModel(aModel, aName)
	local tTable = VUHDO_lnfGetValueFrom(aModel);
	local tComponent;
	local sPanel = VuhDoLnfIconTextDialog;

	if (sPanel:IsShown() and aName == sLastName) then
		sPanel:Hide();
		return;
	end
	sLastName = aName;
	sTable = tTable;

	sPanel:Hide();

	tComponent = VUHDO_GLOBAL[sPanelName .. "TitleLabelLabel"];
	tComponent:SetText(VUHDO_I18N_ICON_TEXT_SETTINGS .. " |c00000099" .. (aName or "?") .. "|r");

	tComponent = VUHDO_GLOBAL[sPanelName .. "AnchorTextureTopLeftRadioButton"];
	VUHDO_lnfSetRadioModel(tComponent, aModel .. ".ANCHOR", "TOPLEFT");
	tComponent = VUHDO_GLOBAL[sPanelName .. "AnchorTextureTopRightRadioButton"];
	VUHDO_lnfSetRadioModel(tComponent, aModel .. ".ANCHOR", "TOPRIGHT");
	tComponent = VUHDO_GLOBAL[sPanelName .. "AnchorTextureBottomLeftRadioButton"];
	VUHDO_lnfSetRadioModel(tComponent, aModel .. ".ANCHOR", "BOTTOMLEFT");
	tComponent = VUHDO_GLOBAL[sPanelName .. "AnchorTextureBottomRightRadioButton"];
	VUHDO_lnfSetRadioModel(tComponent, aModel .. ".ANCHOR", "BOTTOMRIGHT");
	tComponent = VUHDO_GLOBAL[sPanelName .. "AnchorTextureCenterRadioButton"];
	VUHDO_lnfSetRadioModel(tComponent, aModel .. ".ANCHOR", "CENTER");

	tComponent = VUHDO_GLOBAL[sPanelName .. "XAdjustSlider"];
	VUHDO_lnfSetModel(tComponent, aModel .. ".X_ADJUST");
	tComponent = VUHDO_GLOBAL[sPanelName .. "YAdjustSlider"];
	VUHDO_lnfSetModel(tComponent, aModel .. ".Y_ADJUST");
	tComponent = VUHDO_GLOBAL[sPanelName .. "ScaleSlider"];
	VUHDO_lnfSetModel(tComponent, aModel .. ".SCALE");

	tComponent = VUHDO_GLOBAL[sPanelName .. "FontCombo"];
	VUHDO_setComboModel(tComponent, aModel .. ".FONT", VUHDO_FONTS);

	tComponent = VUHDO_GLOBAL[sPanelName .. "ColorTexture"];
	if (tTable["COLOR"] ~= nil) then
		VUHDO_lnfSetModel(tComponent, aModel .. ".COLOR");
		tComponent:Show();
	else
		VUHDO_lnfSetModel(tComponent, nil);
		tComponent:Hide();
	end

	tComponent = VUHDO_GLOBAL[sPanelName .. "MonoCheckButton"];
	VUHDO_lnfSetModel(tComponent, aModel .. ".USE_MONO");

	tComponent = VUHDO_GLOBAL[sPanelName .. "ShadowCheckButton"];
	VUHDO_lnfSetModel(tComponent, aModel .. ".USE_SHADOW");

	tComponent = VUHDO_GLOBAL[sPanelName .. "OutlineCheckButton"];
	VUHDO_lnfSetModel(tComponent, aModel .. ".USE_OUTLINE");

	sPanel:ClearAllPoints();
	sPanel:SetPoint("CENTER", "UIParent", "CENTER", 0, 0);
	sPanel:Show();
end



--
local tLabel;
local tTexture;
local tHeight;
local tShadowAlpha, tOutlineText;
local tLastTime = -1;
local tEmpty = { };
function VUHDO_lnfStandardFontUpdateDemoText()
	tLabel = VUHDO_GLOBAL[sPanelName .."AnchorTextureTitleString"];
	tTexture = VUHDO_GLOBAL[sPanelName .."AnchorTexture"];

	if (tLastTime + 1 < GetTime()) then
		tLastTime = GetTime();
	  tLabel:SetText(random(0, 15));
	end
	tLabel:ClearAllPoints();
	tHeight = tTexture:GetHeight();
	tLabel:SetPoint(sTable["ANCHOR"], tTexture:GetName(), sTable["ANCHOR"],
		tHeight * 0.01 * sTable["X_ADJUST"], tHeight * -0.01 * sTable["Y_ADJUST"]);

	if (sTable["USE_SHADOW"]) then
		tShadowAlpha = (sTable["COLOR"] or tEmpty)["O"];
	else
		tShadowAlpha = 0;
	end

	if (sTable["USE_OUTLINE"]) then
		tOutlineText = "OUTLINE|";
	else
		tOutlineText = "";
	end

	if (sTable["USE_MONO"]) then
		tOutlineText = tOutlineText .. "MONOCHROME";
	end

	tLabel:SetFont(sTable["FONT"], sTable["SCALE"] * 0.01 * 32, tOutlineText);

	if (sTable["COLOR"] ~= nil) then
		tLabel:SetShadowColor(sTable["COLOR"]["R"], sTable["COLOR"]["G"], sTable["COLOR"]["B"], tShadowAlpha);
	else
		tLabel:SetShadowColor(0, 0, 0, tShadowAlpha);
	end
	tLabel:SetShadowOffset(1, -1);

	if (sTable["COLOR"] ~= nil) then
		tLabel:SetTextColor(sTable["COLOR"]["TR"], sTable["COLOR"]["TG"], sTable["COLOR"]["TB"], sTable["COLOR"]["TO"]);
	else
		tLabel:SetTextColor(1, 1, 1, 1);
	end
end