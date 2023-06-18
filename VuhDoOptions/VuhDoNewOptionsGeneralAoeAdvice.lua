--


function VUHDO_newOptionsAoeAdvicePopulate(aParent)
	local tFrameName, tFrame, tComponent;
	local tX, tY;
	local tIndex = 0;

	for tName, tSettings in pairs(VUHDO_CONFIG["AOE_ADVISOR"]["config"]) do
		if (VUHDO_AOE_SPELLS[tName] ~= nil) then
			tFrameName = aParent:GetName() .. tName;
			if (_G[tFrameName] == nil) then
				CreateFrame("Frame", tFrameName, aParent, "VuhDoAoeItemTemplate");
			end

			tFrame = _G[tFrameName];

			tX = floor(tIndex * 0.2) * (tFrame:GetWidth() + 10) + 20;
			tY = (tIndex % 5) * (tFrame:GetHeight() + 6) + 150;
			tIndex = tIndex + 1;

			tFrame:Hide();

			tComponent = _G[tFrameName .. "EnableCheckButton"];
			VUHDO_lnfSetModel(tComponent, "VUHDO_CONFIG.AOE_ADVISOR.config." .. tName .. ".enable");
			VUHDO_lnfCheckButtonInitFromModel(tComponent);

			tComponent = _G[tFrameName .. "HealedSlider"];
			VUHDO_lnfSetModel(tComponent, "VUHDO_CONFIG.AOE_ADVISOR.config." .. tName .. ".thresh");
			VUHDO_lnfSliderInitFromModel(tComponent);

			tComponent = _G[tFrameName .. "SpellTextureTexture"];
			tComponent:SetTexture(VUHDO_AOE_SPELLS[tName]["icon"]);

			tComponent = _G[tFrameName .. "SpellNameLabelLabel"];
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
end