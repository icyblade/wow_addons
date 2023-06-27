local pairs = pairs;
local UnitExists = UnitExists;
local UnitIsUnit = UnitIsUnit;


local VUHDO_RAID = { };
local VUHDO_INTERNAL_TOGGLES = { };

local VUHDO_updateBouquetsForEvent;
local VUHDO_clParserSetCurrentTarget;
local VUHDO_setHealth;
local VUHDO_removeHots;
local VUHDO_removeAllDebuffIcons;
local VUHDO_updateTargetBars;
local VUHDO_updateHealthBarsFor;
local VUHDO_updateAllRaidBars;
local VUHDO_initAllEventBouquets;
local VUHDO_getUnitButtons;
local VUHDO_getPlayerTargetFrame;


--
function VUHDO_playerTargetEventHandlerInitBurst()
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];
	VUHDO_INTERNAL_TOGGLES = VUHDO_GLOBAL["VUHDO_INTERNAL_TOGGLES"];

	VUHDO_updateBouquetsForEvent = VUHDO_GLOBAL["VUHDO_updateBouquetsForEvent"];
	VUHDO_clParserSetCurrentTarget = VUHDO_GLOBAL["VUHDO_clParserSetCurrentTarget"];
	VUHDO_setHealth = VUHDO_GLOBAL["VUHDO_setHealth"];
	VUHDO_removeHots = VUHDO_GLOBAL["VUHDO_removeHots"];
	VUHDO_removeAllDebuffIcons = VUHDO_GLOBAL["VUHDO_removeAllDebuffIcons"];
	VUHDO_updateTargetBars = VUHDO_GLOBAL["VUHDO_updateTargetBars"];
	VUHDO_updateHealthBarsFor = VUHDO_GLOBAL["VUHDO_updateHealthBarsFor"];
	VUHDO_updateAllRaidBars = VUHDO_GLOBAL["VUHDO_updateAllRaidBars"];
	VUHDO_initAllEventBouquets = VUHDO_GLOBAL["VUHDO_initAllEventBouquets"];
	VUHDO_getUnitButtons = VUHDO_GLOBAL["VUHDO_getUnitButtons"];
	VUHDO_getPlayerTargetFrame = VUHDO_GLOBAL["VUHDO_getPlayerTargetFrame"];
end



--
local VUHDO_CURR_PLAYER_TARGET = nil;
local tTargetUnit, tUnit;
local tOldTarget;
local tInfo;
local tEmptyInfo = { };
function VUHDO_updatePlayerTarget()
	tTargetUnit = nil;
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if (UnitIsUnit("target", tUnit) and tUnit ~= "focus" and tUnit ~= "target") then
			if (tInfo["isPet"] and (VUHDO_RAID[tInfo["ownerUnit"]] or tEmptyInfo)["isVehicle"]) then
				tTargetUnit = tInfo["ownerUnit"];
			else
				tTargetUnit = tUnit;
			end
			break;
		end
	end

	if (VUHDO_RAID["target"] ~= nil) then
		VUHDO_determineIncHeal("target");
		VUHDO_updateHealth("target", 9); -- VUHDO_UPDATE_INC
	end

	tOldTarget = VUHDO_CURR_PLAYER_TARGET;
	VUHDO_CURR_PLAYER_TARGET = tTargetUnit; -- Wg. callback erst umkopieren
	VUHDO_updateBouquetsForEvent(tOldTarget, 8); -- VUHDO_UPDATE_TARGET
	VUHDO_updateBouquetsForEvent(tTargetUnit, 8); -- VUHDO_UPDATE_TARGET
	VUHDO_clParserSetCurrentTarget(tTargetUnit);

	if (VUHDO_INTERNAL_TOGGLES[27]) then -- VUHDO_UPDATE_PLAYER_TARGET
		if (UnitExists("target")) then
			VUHDO_setHealth("target", 1); -- VUHDO_UPDATE_ALL
		else
			VUHDO_removeHots("target");
			VUHDO_removeAllDebuffIcons("target");
			VUHDO_updateTargetBars("target");
			VUHDO_RAID["target"] = nil;
		end

		VUHDO_updateHealthBarsFor("target", 1); -- VUHDO_UPDATE_ALL
		VUHDO_REMOVE_HOTS = false;
		VUHDO_updateAllRaidBars();
		VUHDO_initAllEventBouquets();
	end
end



--
local tAllButtons, tButton, tBorder;
function VUHDO_barBorderBouquetCallback(aUnit, anIsActive, anIcon, aTimer, aCounter, aDuration, aColor, aBuffName, aBouquetName, anImpact)
	tAllButtons =  VUHDO_getUnitButtons(aUnit);
	if (tAllButtons ~= nil) then
		for _, tButton in pairs(tAllButtons) do
			tBorder = VUHDO_getPlayerTargetFrame(tButton);
			if (aColor ~= nil) then
				tBorder:SetFrameLevel(tButton:GetFrameLevel() + (anImpact or 0) + 2);
				tBorder:SetBackdropBorderColor(aColor["R"], aColor["G"], aColor["B"], aColor["O"]);
				tBorder:Show();
			else
				tBorder:Hide();
			end
		end
	end
end



--
function VUHDO_getCurrentPlayerTarget()
	return VUHDO_CURR_PLAYER_TARGET;
end

