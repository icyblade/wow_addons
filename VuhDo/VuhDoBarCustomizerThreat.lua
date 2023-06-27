
local sAllButtons;
local sButton;
local tTexture;


function VUHDO_threatIndicatorsBouquetCallback(aUnit, anIsActive, anIcon, aTimer, aCounter, aDuration, aColor, aBuffName, aBouquetName)
	sAllButtons = VUHDO_getUnitButtons(aUnit);
	if (sAllButtons ~= nil) then
		for _, sButton in pairs(sAllButtons) do
			tTexture = VUHDO_getAggroTexture(VUHDO_getHealthBar(sButton, 1));
			if (anIsActive) then
				tTexture:SetVertexColor(VUHDO_backColor(aColor));
				tTexture:Show();
				UIFrameFlash(tTexture, 0.2, 0.5, 3.2, true, 0, 0);
			else
				UIFrameFlashStop(tTexture);
				tTexture:Hide();
			end
		end
	end
end



--
local tBar;
local tQuota;
function VUHDO_threatBarBouquetCallback(aUnit, anIsActive, anIcon, aCurrValue, aCounter, aMaxValue, aColor, aBuffName, aBouquetName)
	sAllButtons = VUHDO_getUnitButtons(aUnit);
	if (sAllButtons ~= nil) then

		tQuota = (aCurrValue == 0 and aMaxValue == 0) and 0
			or (aMaxValue or 0) > 1 and aCurrValue / aMaxValue
			or 0;

		for _, sButton in pairs(sAllButtons) do
			if (tQuota > 0) then
				tBar = VUHDO_getHealthBar(sButton, 7);
				tBar:SetValue(tQuota);
				tBar:SetVuhDoColor(aColor);
			else
				VUHDO_getHealthBar(sButton, 7):SetValue(0);
			end
		end
	end
end

