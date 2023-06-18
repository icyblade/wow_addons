local pairs = pairs;
local UnitExists = UnitExists;
local UnitIsUnit = UnitIsUnit;
local _;


local VUHDO_RAID = { };
local VUHDO_INTERNAL_TOGGLES = { };

local VUHDO_updateBouquetsForEvent;
local VUHDO_clParserSetCurrentTarget;
local VUHDO_setHealth;
local VUHDO_removeHots;
local VUHDO_removeAllDebuffIcons;
local VUHDO_updateTargetBars;
local VUHDO_updateHealthBarsFor;
local VUHDO_getUnitButtonsSafe;
local VUHDO_getPlayerTargetFrame;

--
function VUHDO_playerTargetEventHandlerInitLocalOverrides()
	VUHDO_RAID = _G["VUHDO_RAID"];
	VUHDO_INTERNAL_TOGGLES = _G["VUHDO_INTERNAL_TOGGLES"];

	VUHDO_updateBouquetsForEvent = _G["VUHDO_updateBouquetsForEvent"];
	VUHDO_clParserSetCurrentTarget = _G["VUHDO_clParserSetCurrentTarget"];
	VUHDO_setHealth = _G["VUHDO_setHealth"];
	VUHDO_removeHots = _G["VUHDO_removeHots"];
	VUHDO_removeAllDebuffIcons = _G["VUHDO_removeAllDebuffIcons"];
	VUHDO_updateTargetBars = _G["VUHDO_updateTargetBars"];
	VUHDO_updateHealthBarsFor = _G["VUHDO_updateHealthBarsFor"];
	VUHDO_getUnitButtonsSafe = _G["VUHDO_getUnitButtonsSafe"];
	VUHDO_getPlayerTargetFrame = _G["VUHDO_getPlayerTargetFrame"];
end



--
local VUHDO_CURR_PLAYER_TARGET = nil;
local tTargetUnit;
local tOldTarget;
local tEmptyInfo = { };
function VUHDO_updatePlayerTarget()
	tTargetUnit = nil;
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if UnitIsUnit("target", tUnit) and tUnit ~= "focus" and tUnit ~= "target" then
			if tInfo["isPet"] and (VUHDO_RAID[tInfo["ownerUnit"]] or tEmptyInfo)["isVehicle"] then
				tTargetUnit = tInfo["ownerUnit"];
			else
				tTargetUnit = tUnit;
			end
			break;
		end
	end

	if VUHDO_RAID["target"] then
		VUHDO_determineIncHeal("target");
		VUHDO_updateHealth("target", 9); -- VUHDO_UPDATE_INC
	end

	tOldTarget = VUHDO_CURR_PLAYER_TARGET;
	VUHDO_CURR_PLAYER_TARGET = tTargetUnit; -- Wg. callback erst umkopieren
	VUHDO_updateBouquetsForEvent(tOldTarget, 8); -- VUHDO_UPDATE_TARGET
	VUHDO_updateBouquetsForEvent(tTargetUnit, 8); -- VUHDO_UPDATE_TARGET
	VUHDO_clParserSetCurrentTarget(tTargetUnit);

	if VUHDO_INTERNAL_TOGGLES[27] then -- VUHDO_UPDATE_PLAYER_TARGET
		if UnitExists("target") then
			VUHDO_setHealth("target", 1); -- VUHDO_UPDATE_ALL
		else
			VUHDO_removeHots("target");
			VUHDO_resetDebuffsFor("target");
			VUHDO_removeAllDebuffIcons("target");
			VUHDO_updateTargetBars("target");
			table.wipe(VUHDO_RAID["target"] or tEmptyInfo);
			VUHDO_RAID["target"] = nil;
		end

		VUHDO_updateHealthBarsFor("target", 1); -- VUHDO_UPDATE_ALL
		VUHDO_initEventBouquetsFor("target");
	end
end



--
local tBorder;
function VUHDO_barBorderBouquetCallback(aUnit, anIsActive, anIcon, aTimer, aCounter, aDuration, aColor, aBuffName, aBouquetName, anImpact)
	for _, tButton in pairs(VUHDO_getUnitButtonsSafe(aUnit)) do
		if aColor then
			tBorder = VUHDO_getPlayerTargetFrame(tButton);
			tBorder:SetFrameLevel(tButton:GetFrameLevel() + (anImpact or 0) + 2);
			tBorder:SetBackdropBorderColor(VUHDO_backColor(aColor));
			tBorder:Show();
		else
			VUHDO_getPlayerTargetFrame(tButton):Hide();
		end
	end
end



--
function VUHDO_getCurrentPlayerTarget()
	return VUHDO_CURR_PLAYER_TARGET;
end

