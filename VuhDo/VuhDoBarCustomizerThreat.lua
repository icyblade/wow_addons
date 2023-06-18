


--
local tTexture;
function VUHDO_threatIndicatorsBouquetCallback(aUnit, anIsActive, anIcon, aTimer, aCounter, aDuration, aColor, aBuffName, aBouquetName)
	for _, sButton in pairs(VUHDO_getUnitButtonsSafe(aUnit)) do
		tTexture = VUHDO_getAggroTexture(VUHDO_getHealthBar(sButton, 1));
		if anIsActive then
			tTexture:SetVertexColor(VUHDO_backColor(aColor));
			tTexture:Show();
			VUHDO_UIFrameFlash(tTexture, 0.2, 0.5, 3.2, true, 0, 0);
		else
			VUHDO_UIFrameFlashStop(tTexture);
			tTexture:Hide();
		end
	end
end



--
local tBar;
local tQuota;
function VUHDO_threatBarBouquetCallback(aUnit, anIsActive, anIcon, aCurrValue, aCounter, aMaxValue, aColor, aBuffName, aBouquetName)
	tQuota = (aCurrValue == 0 and aMaxValue == 0) and 0
		or (aMaxValue or 0) > 1 and aCurrValue / aMaxValue
		or 0;

	for _, sButton in pairs(VUHDO_getUnitButtonsSafe(aUnit)) do
		if tQuota > 0 then
			tBar = VUHDO_getHealthBar(sButton, 7);
			tBar:SetValue(tQuota);
			tBar:SetVuhDoColor(aColor);
		else
			VUHDO_getHealthBar(sButton, 7):SetValue(0);
		end
	end
end



function VUHDO_threatBarTextCallback(...)
	VUHDO_indicatorTextCallback(7, ...);
end
