local VUHDO_1_DIV_2_PI_MUL_108 = 108 / math.pi / 2;
local UnitIsUnit = UnitIsUnit;
local floor = floor;
local tOldButton, tOldDistance;
local sIsDeadOnly;
local sIsAlways;
local sIsDistanceText;
local sScale;
local VuhDoDirectionFrame;
local VuhDoDirectionFrameArrow;
local VuhDoDirectionFrameText;
local VUHDO_setMapToCurrentZone;
local VUHDO_getDistanceBetween;
local VUHDO_getUnitDirection;

local VUHDO_RAID = { };
function VUHDO_directionsInitBurst()
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];
	sIsDeadOnly = VUHDO_CONFIG["DIRECTION"]["isDeadOnly"];
	sIsAlways = VUHDO_CONFIG["DIRECTION"]["isAlways"];
	sIsDistanceText = VUHDO_CONFIG["DIRECTION"]["isDistanceText"];
	sScale = VUHDO_CONFIG["DIRECTION"]["scale"] * 0.01;
	VuhDoDirectionFrame = VUHDO_GLOBAL["VuhDoDirectionFrame"];
	VuhDoDirectionFrameArrow = VUHDO_GLOBAL["VuhDoDirectionFrameArrow"];
	VuhDoDirectionFrameText = VUHDO_GLOBAL["VuhDoDirectionFrameText"];
	VUHDO_setMapToCurrentZone = VUHDO_GLOBAL["VUHDO_setMapToCurrentZone"];
	VUHDO_getDistanceBetween = VUHDO_GLOBAL["VUHDO_getDistanceBetween"];
	VUHDO_getUnitDirection = VUHDO_GLOBAL["VUHDO_getUnitDirection"];
	tOldButton = nil;
	tOldDistance = nil;
end



--
function VUHDO_getCellForDirection(aDirection)
	return floor(aDirection * VUHDO_1_DIV_2_PI_MUL_108 + 0.5) % 108
end
local VUHDO_getCellForDirection = VUHDO_getCellForDirection;



--
local tStartX, tStartY;
function VUHDO_getTexCoordsForCell(aCell)
	tStartX = (aCell % 9) * 0.109375;
	tStartY = floor(aCell / 9) * 0.08203125;
	return tStartX, tStartX + 0.109375, tStartY, tStartY + 0.08203125;
end
local VUHDO_getTexCoordsForCell = VUHDO_getTexCoordsForCell;



--
local tQuota;
local tR1, tG2;
local tInvModi;
function VUHDO_getRedGreenForDistance(aDistance)
	tQuota = 2 - (aDistance - 40) * 0.05;

	if (tQuota > 2) then
		tQuota = 2;
	elseif (tQuota < 0) then
		tQuota = 0;
	end

	if (tQuota > 1) then
		tR1, tG2 = 0, 1;
		tQuota = tQuota - 1;
	else
		tR1, tG2 = 1, 0;
	end

	tInvModi = 1 - tQuota;
	return tInvModi + tR1 * tQuota, tG2 * tInvModi + tQuota;
end
local VUHDO_getRedGreenForDistance = VUHDO_getRedGreenForDistance;



--
local tInfo;
function VUHDO_shouldDisplayArrow(aUnit)
	tInfo = VUHDO_RAID[aUnit];

	if (UnitIsUnit("player", aUnit)
		or tInfo == nil
		or (tInfo["range"] and not sIsAlways)
		or (sIsDeadOnly and not tInfo["dead"])
		or not tInfo["connected"]
		or tInfo["isPet"]) then

		return false;
	else
		return true;
	end
end
local VUHDO_shouldDisplayArrow = VUHDO_shouldDisplayArrow;



--
local tUnit;
local tCell;
local sLastCell = nil;
local tButton = nil;
local tHeight;
local tDistance;
local tHeight;
local tDestR, tDestG;
function VUHDO_updateDirectionFrame(aButton)
	if (aButton ~= nil) then
		tButton = aButton;
	elseif (tButton == nil) then
		return;
	end

	tUnit = tButton:GetAttribute("unit");

	if (not VUHDO_shouldDisplayArrow(tUnit)) then
		VuhDoDirectionFrame["shown"] = false;
		VuhDoDirectionFrame:Hide();
		return;
	end

	tDirection = VUHDO_getUnitDirection(tUnit);
	if (tDirection == nil) then
		VuhDoDirectionFrame["shown"] = false;
		VuhDoDirectionFrame:Hide();
		return;
	end

	tCell = VUHDO_getCellForDirection(tDirection);
	if (tCell ~= sLastCell) then
		sLastCell = tCell;
		VuhDoDirectionFrameArrow:SetTexCoord(VUHDO_getTexCoordsForCell(tCell));
	end

	if (sIsDistanceText) then
		tDistance = VUHDO_getDistanceBetween("player", tUnit);
		if ((tDistance or 0) > 0) then
			tDistance = floor(tDistance + 0.5);

			if (tDistance ~= tOldDistance) then
				tOldDistance = tDistance;

				VuhDoDirectionFrameText:SetText(tDistance);

				tDestR, tDestG = VUHDO_getRedGreenForDistance(tDistance);
				VuhDoDirectionFrameText:SetTextColor(tDestR, tDestG, 0.2, 0.8);
				VuhDoDirectionFrameArrow:SetVertexColor(tDestR, tDestG, 0);
			end
		else
			VuhDoDirectionFrameText:SetText("");
		end
	end

	if (tOldButton ~= tButton) then
		tOldButton = tButton;
		tHeight = tButton:GetHeight() * sScale * tButton:GetEffectiveScale();
		VuhDoDirectionFrame:SetPoint("CENTER", tButton:GetName(), "CENTER", 0, 0);
		VuhDoDirectionFrame:SetWidth(tHeight);
		VuhDoDirectionFrame:SetHeight(tHeight);
	end
	VuhDoDirectionFrame:Show();
	VuhDoDirectionFrame["shown"] = true;
end
