--


function VUHDO_newOptionsAoeAdvicePopulate(aParent)
	local tName, tSettings;
	local tFrameName, tFrame, tComponent;
	local tX, tY;
	local tIndex = 0;

	for tName, tSettings in pairs(VUHDO_CONFIG["AOE_ADVISOR"]["config"]) do
		tFrameName = aParent:GetName() .. tName;
		if (VUHDO_GLOBAL[tFrameName] == nil) then
			CreateFrame("Frame", tFrameName, aParent, "VuhDoAoeItemTemplate");
		end

		tFrame = VUHDO_GLOBAL[tFrameName];

		tX = floor(tIndex * 0.2) * (tFrame:GetWidth() + 10) + 20;
		tY = (tIndex % 5) * (tFrame:GetHeight() + 6) + 150;
		tIndex = tIndex + 1;

		tFrame:Hide();

		tComponent = VUHDO_GLOBAL[tFrameName .. "EnableCheckButton"];
		VUHDO_lnfSetModel(tComponent, "VUHDO_CONFIG.AOE_ADVISOR.config." .. tName .. ".enable");
		VUHDO_lnfCheckButtonInitFromModel(tComponent);

		tComponent = VUHDO_GLOBAL[tFrameName .. "HealedSlider"];
		VUHDO_lnfSetModel(tComponent, "VUHDO_CONFIG.AOE_ADVISOR.config." .. tName .. ".thresh");
		VUHDO_lnfSliderInitFromModel(tComponent);

		tComponent = VUHDO_GLOBAL[tFrameName .. "SpellTextureTexture"];
		tComponent:SetTexture(VUHDO_AOE_SPELLS[tName]["icon"]);

		tComponent = VUHDO_GLOBAL[tFrameName .. "SpellNameLabelLabel"];
		tComponent:SetText(VUHDO_AOE_SPELLS[tName]["name"]);

		tFrame:SetPoint("TOPLEFT", aParent:GetName(), "TOPLEFT", tX, -tY);

		if (VUHDO_CONFIG["AOE_ADVISOR"]["knownOnly"] and not VUHDO_isSpellKnown(VUHDO_AOE_SPELLS[tName]["name"])) then
			tFrame:SetAlpha(0.5);
		else
			tFrame:SetAlpha(1);
		end

		tFrame:Show();


	end
end