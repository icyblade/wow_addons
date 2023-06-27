local sIsChecking = false;



--
local function VUHDO_placeReadyIcon(aButton)
	local tInfo = VUHDO_RAID[aButton:GetAttribute("unit")];
	local tIcon = VUHDO_getBarRoleIcon(aButton, 20);

	if (tInfo == nil or tInfo["isPet"]) then
		tIcon:Hide();
	else
		UIFrameFlashStop(tIcon);
		tIcon:SetTexture("Interface\\AddOns\\VuhDo\\Images\\icon_info");
		tIcon:ClearAllPoints();
		tIcon:SetPoint("LEFT", aButton:GetName(), "LEFT", -5, 0);
		tIcon:SetWidth(16);
		tIcon:SetHeight(16);
		tIcon:Show();
	end
end



--
local function VUHDO_placeAllReadyIcons()
	local tPanelNum;
	local tAllButtons;
	local tButton;

	for tPanelNum = 1, VUHDO_MAX_PANELS do
		tAllButtons = VUHDO_getPanelButtons(tPanelNum);

		for _, tButton in pairs(tAllButtons) do
			if (tButton:GetAttribute("unit") ~= nil) then
				VUHDO_placeReadyIcon(tButton);
			else
				break;
			end
		end
	end
end



--
local function VUHDO_hideAllReadyIcons()
	local tPanelNum;
	local tAllButtons;
	local tButton;

	for tPanelNum = 1, VUHDO_MAX_PANELS do
		tAllButtons = VUHDO_getPanelButtons(tPanelNum);

		for _, tButton in pairs(tAllButtons) do
			if (tButton:GetAttribute("unit") ~= nil) then
				UIFrameFlash(VUHDO_getBarRoleIcon(tButton, 20), 0, 2, 10, false, 0, 8);
			else
				break;
			end
		end
	end
end



--
function VUHDO_readyCheckStarted()
	sIsChecking = true;
	VUHDO_hideAllPlayerIcons();
	VUHDO_placeAllReadyIcons();
end



-- Status true = ready, nil = not ready
local function VUHDO_updateReadyIcon(aUnit, anIsReady)
	local tAllButtons = VUHDO_getUnitButtons(aUnit) or { };

	local tTexture = anIsReady
		and "Interface\\AddOns\\VuhDo\\Images\\icon_check_2"
		or "Interface\\AddOns\\VuhDo\\Images\\icon_cancel_1";

	local tButton;
	for _, tButton in pairs(tAllButtons) do
		VUHDO_getBarRoleIcon(tButton, 20):SetTexture(tTexture);
	end
end



--
function VUHDO_readyCheckConfirm(aUnit, anIsReady)
	if (VUHDO_RAID[aUnit] == nil) then
		return;
	end

	if (not sIsChecking) then
		VUHDO_readyCheckStarted();
	end

	VUHDO_updateReadyIcon(aUnit, anIsReady);
end



--
function VUHDO_readyStartCheck(aName, aDuration)
	if (VUHDO_RAID_NAMES[aName] ~= nil) then
		VUHDO_readyCheckConfirm(VUHDO_RAID_NAMES[aName], true); -- Originator is always ready
	end
end



--
function VUHDO_readyCheckEnds()
	if (sIsChecking) then -- Client send READY_CHECK_ENDS on startup
		VUHDO_hideAllReadyIcons();
		sIsChecking = false;
	end
end

