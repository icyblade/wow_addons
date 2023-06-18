local sPanelName = "VuhDoLnfIconTextDialogRootPane";
local sLastName = nil;
local sTable = nil;

--
function VUHDO_lnfStandardFontInitFromModel(aModel, aName, aParent)
	local tTable = VUHDO_lnfGetValueFrom(aModel);
	local tComponent;
	local tPanel = VuhDoLnfIconTextDialog;

	if (tPanel:IsShown() and aName == sLastName) then
		tPanel:Hide();
		return;
	end
	sLastName = aName;
	sTable = tTable;

	tPanel:Hide();

	tComponent = _G[sPanelName .. "AnchorTextureCenterBar"];
	tComponent:SetAlpha(0.75);


	tComponent = _G[sPanelName .. "TitleLabelLabel"];
	tComponent:SetText(VUHDO_I18N_ICON_TEXT_SETTINGS .. " |c00000099" .. (aName or "?") .. "|r");

	tComponent = _G[sPanelName .. "AnchorTextureLeftRadioButton"];
	VUHDO_lnfSetRadioModel(tComponent, aModel .. ".ANCHOR", "LEFT");
	tComponent = _G[sPanelName .. "AnchorTextureTopRadioButton"];
	VUHDO_lnfSetRadioModel(tComponent, aModel .. ".ANCHOR", "TOP");
	tComponent = _G[sPanelName .. "AnchorTextureTopLeftRadioButton"];
	VUHDO_lnfSetRadioModel(tComponent, aModel .. ".ANCHOR", "TOPLEFT");
	tComponent = _G[sPanelName .. "AnchorTextureTopRightRadioButton"];
	VUHDO_lnfSetRadioModel(tComponent, aModel .. ".ANCHOR", "TOPRIGHT");
	tComponent = _G[sPanelName .. "AnchorTextureBottomRadioButton"];
	VUHDO_lnfSetRadioModel(tComponent, aModel .. ".ANCHOR", "BOTTOM");
	tComponent = _G[sPanelName .. "AnchorTextureBottomLeftRadioButton"];
	VUHDO_lnfSetRadioModel(tComponent, aModel .. ".ANCHOR", "BOTTOMLEFT");
	tComponent = _G[sPanelName .. "AnchorTextureRightRadioButton"];
	VUHDO_lnfSetRadioModel(tComponent, aModel .. ".ANCHOR", "RIGHT");
	tComponent = _G[sPanelName .. "AnchorTextureBottomRightRadioButton"];
	VUHDO_lnfSetRadioModel(tComponent, aModel .. ".ANCHOR", "BOTTOMRIGHT");
	tComponent = _G[sPanelName .. "AnchorTextureCenterRadioButton"];
	VUHDO_lnfSetRadioModel(tComponent, aModel .. ".ANCHOR", "CENTER");

	tComponent = _G[sPanelName .. "XAdjustSlider"];
	VUHDO_lnfSetModel(tComponent, aModel .. ".X_ADJUST");
	tComponent = _G[sPanelName .. "YAdjustSlider"];
	VUHDO_lnfSetModel(tComponent, aModel .. ".Y_ADJUST");
	tComponent = _G[sPanelName .. "ScaleSlider"];
	VUHDO_lnfSetModel(tComponent, aModel .. ".SCALE");

	tComponent = _G[sPanelName .. "FontCombo"];
	VUHDO_setComboModel(tComponent, aModel .. ".FONT", VUHDO_FONTS);

	tComponent = _G[sPanelName .. "ColorTexture"];
	if (tTable["COLOR"] ~= nil) then
		VUHDO_lnfSetModel(tComponent, aModel .. ".COLOR");
		tComponent:Show();
	else
		VUHDO_lnfSetModel(tComponent, nil);
		tComponent:Hide();
	end

	tComponent = _G[sPanelName .. "MonoCheckButton"];
	VUHDO_lnfSetModel(tComponent, aModel .. ".USE_MONO");

	tComponent = _G[sPanelName .. "ShadowCheckButton"];
	VUHDO_lnfSetModel(tComponent, aModel .. ".USE_SHADOW");

	tComponent = _G[sPanelName .. "OutlineCheckButton"];
	VUHDO_lnfSetModel(tComponent, aModel .. ".USE_OUTLINE");

	tPanel:ClearAllPoints();
	--tPanel:SetPoint("CENTER", aParent:GetName(), "CENTER", 0, 0);
	tPanel:SetPoint("CENTER", "UIParent", "CENTER", 0, 0);
	tPanel:Show();
end



--
local tLabel;
local tTexture;
local tHeight;
local tShadowAlpha, tOutlineText;
local tLastTime = -1;
local tEmpty = { };
function VUHDO_lnfStandardFontUpdateDemoText()
	tLabel = _G[sPanelName .."AnchorTextureTitleString"];
	tTexture = _G[sPanelName .."AnchorTexture"];

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

	--[[if (sTable["USE_MONO"]) then -- -- Bugs out in MoP beta
		tOutlineText = tOutlineText .. "MONOCHROME";
	end]]

	tLabel:SetFont(sTable["FONT"], sTable["SCALE"] * 0.01 * 32, tOutlineText);

	if (sTable["COLOR"] ~= nil) then
		tLabel:SetShadowColor(sTable["COLOR"]["R"], sTable["COLOR"]["G"], sTable["COLOR"]["B"], tShadowAlpha);
	else
		tLabel:SetShadowColor(0, 0, 0, tShadowAlpha);
	end
	tLabel:SetShadowOffset(1, -1);

	if (sTable["COLOR"] ~= nil) then
		tLabel:SetTextColor(VUHDO_textColor(sTable["COLOR"]));
	else
		tLabel:SetTextColor(1, 1, 1, 1);
	end
end