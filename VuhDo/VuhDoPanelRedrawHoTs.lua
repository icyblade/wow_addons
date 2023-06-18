local GetSpellBookItemTexture = GetSpellBookItemTexture;

local VUHDO_getHealthBar;
local VUHDO_getBarIcon;
local VUHDO_getBarIconTimer;
local VUHDO_getBarIconCounter;
local VUHDO_getBarIconCharge;
local VUHDO_getOrCreateCooldown;
local VUHDO_strempty;

local sHotConfig;
local sHotPos;
local sBarsPos;
local sBarColors;
local sStacksRadio;
local sIcqqonRadio;
local sIconRadio;
local sHotBarConfig;
local sOrientation;

--
function VUHDO_panelRedrawHotsInitLocalOverrides()
	VUHDO_getHealthBar = _G["VUHDO_getHealthBar"];
	VUHDO_getBarIcon = _G["VUHDO_getBarIcon"];
	VUHDO_getBarIconTimer = _G["VUHDO_getBarIconTimer"];
	VUHDO_getBarIconCounter = _G["VUHDO_getBarIconCounter"];
	VUHDO_getBarIconCharge = _G["VUHDO_getBarIconCharge"];
	VUHDO_getOrCreateCooldown = _G["VUHDO_getOrCreateCooldown"];
	VUHDO_strempty = _G["VUHDO_strempty"];

	sHotConfig = VUHDO_PANEL_SETUP["HOTS"];
	sBarColors = VUHDO_PANEL_SETUP["BAR_COLORS"];
	sHotPos = sHotConfig["radioValue"];
	sBarsPos = sHotConfig["BARS"]["radioValue"];
	sStacksRadio = sHotConfig["stacksRadioValue"];
	sIconRadio = sHotConfig["iconRadioValue"];
	sHotBarConfig = VUHDO_INDICATOR_CONFIG["CUSTOM"]["HOT_BARS"];
	sOrientation = VUHDO_getStatusbarOrientationString("HOT_BARS");
end



--
local sBarScaling;
local sHotBarWidth;
local sHotIconSize;
local sHotBarWidth;
local sHotBarHeight;
function VUHDO_panelRedrwawHotsInitLocalVars(aPanelNum)
	sBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
	sHotIconSize = sBarScaling["barHeight"] * VUHDO_PANEL_SETUP[aPanelNum]["HOTS"]["size"] * 0.01;
	if sHotIconSize == 0 then sHotIconSize = 0.001; end

	if sHotBarConfig["vertical"] then
		sHotBarWidth = sBarScaling["barWidth"] * sHotConfig["BARS"]["width"] * 0.01;
		sHotBarHeight = VUHDO_getHealthBarHeight(aPanelNum);
	else
		sHotBarWidth = VUHDO_getHealthBarWidth(aPanelNum);
		sHotBarHeight = sBarScaling["barHeight"] * sHotConfig["BARS"]["width"] * 0.01;
	end

end



--
local sButton;
local sHealthBarName;
function VUHDO_initButtonStaticsHots(aButton, aPanelNum)
	sButton = aButton;
	sHealthBarName = VUHDO_getHealthBar(aButton, 1):GetName();
end



--
function VUHDO_initHotBars()
	local tHotBar;

	for tCnt = 6, 8 do
		tHotBar = VUHDO_getHealthBar(sButton, tCnt + 3);
		tHotBar:ClearAllPoints();

		if VUHDO_strempty(sHotConfig["SLOTS"][tCnt]) then
			tHotBar:Hide();
		else
			tHotBar:SetWidth(sHotBarWidth);
			tHotBar:SetHeight(sHotBarHeight);
			tHotBar:SetValue(0);
			tHotBar:SetVuhDoColor(sBarColors["HOT" .. tCnt]);
			tHotBar:SetOrientation(sOrientation);
			tHotBar:SetIsInverted(sHotBarConfig["invertGrowth"]);
			tHotBar:Show();
		end
	end

	if sHotBarConfig["vertical"] then
		if sBarsPos == 1 then -- edges
			VUHDO_getHealthBar(sButton, 9):SetPoint("LEFT", sHealthBarName, "LEFT", 0, 0);
			VUHDO_getHealthBar(sButton, 10):SetPoint("CENTER", sHealthBarName, "CENTER",  0, 0);
			VUHDO_getHealthBar(sButton, 11):SetPoint("RIGHT", sHealthBarName, "RIGHT",  0, 0);
		elseif sBarsPos == 2 then -- center
			VUHDO_getHealthBar(sButton, 9):SetPoint("CENTER", sHealthBarName, "CENTER", -sHotBarWidth, 0);
			VUHDO_getHealthBar(sButton, 10):SetPoint("CENTER", sHealthBarName, "CENTER",  0, 0);
			VUHDO_getHealthBar(sButton, 11):SetPoint("CENTER", sHealthBarName, "CENTER", sHotBarWidth, 0);
		elseif sBarsPos == 3 then -- top
			VUHDO_getHealthBar(sButton, 9):SetPoint("LEFT", sHealthBarName, "LEFT", 0, 0);
			VUHDO_getHealthBar(sButton, 10):SetPoint("LEFT", sHealthBarName, "LEFT", sHotBarWidth, 0);
			VUHDO_getHealthBar(sButton, 11):SetPoint("LEFT", sHealthBarName, "LEFT", 2 * sHotBarWidth, 0);
		else -- bottom
			VUHDO_getHealthBar(sButton, 9):SetPoint("RIGHT", sHealthBarName, "RIGHT", 0, 0);
			VUHDO_getHealthBar(sButton, 10):SetPoint("RIGHT", sHealthBarName, "RIGHT", -sHotBarWidth, 0);
			VUHDO_getHealthBar(sButton, 11):SetPoint("RIGHT", sHealthBarName, "RIGHT", -2 * sHotBarWidth, 0);
		end
	else
		if sBarsPos == 1 then -- edges
			VUHDO_getHealthBar(sButton, 9):SetPoint("TOP", sHealthBarName, "TOP", 0, 0);
			VUHDO_getHealthBar(sButton, 10):SetPoint("CENTER", sHealthBarName, "CENTER",  0, 0);
			VUHDO_getHealthBar(sButton, 11):SetPoint("BOTTOM", sHealthBarName, "BOTTOM",  0, 0);
		elseif sBarsPos == 2 then -- center
			VUHDO_getHealthBar(sButton, 9):SetPoint("CENTER", sHealthBarName, "CENTER", 0, sHotBarHeight);
			VUHDO_getHealthBar(sButton, 10):SetPoint("CENTER", sHealthBarName, "CENTER",  0, 0);
			VUHDO_getHealthBar(sButton, 11):SetPoint("CENTER", sHealthBarName, "CENTER",  0, -sHotBarHeight);
		elseif sBarsPos == 3 then -- top
			VUHDO_getHealthBar(sButton, 9):SetPoint("TOP", sHealthBarName, "TOP", 0, 0);
			VUHDO_getHealthBar(sButton, 10):SetPoint("TOP", sHealthBarName, "TOP",  0, -sHotBarHeight);
			VUHDO_getHealthBar(sButton, 11):SetPoint("TOP", sHealthBarName, "TOP",  0, -2 * sHotBarHeight);
		else -- bottom
			VUHDO_getHealthBar(sButton, 9):SetPoint("BOTTOM", sHealthBarName, "BOTTOM", 0, 0);
			VUHDO_getHealthBar(sButton, 10):SetPoint("BOTTOM", sHealthBarName, "BOTTOM",  0, sHotBarHeight);
			VUHDO_getHealthBar(sButton, 11):SetPoint("BOTTOM", sHealthBarName, "BOTTOM",  0, 2 * sHotBarHeight);
		end
	end

end



--
local function VUHDO_initHotIcon(anIndex)
	local tHotIcon = VUHDO_getBarIcon(sButton, anIndex);
	local tTimer = VUHDO_getBarIconTimer(sButton, anIndex);
	local tCounter = VUHDO_getBarIconCounter(sButton, anIndex);
	local tChargeIcon = VUHDO_getBarIconCharge(sButton, anIndex);
	local tHotColor = sBarColors["HOT" .. anIndex];

	tHotIcon:SetAlpha(0);

	if sIconRadio ~= 1 then
		tHotIcon:SetVertexColor(tHotColor["R"], tHotColor["G"], tHotColor["B"]);
	else
		tHotIcon:SetVertexColor(1, 1, 1);
	end

	tHotIcon:Show();
	tTimer:SetText("");
	tCounter:SetText("");
	tChargeIcon:Hide();

	if "CLUSTER" == sHotConfig["SLOTS"][anIndex] then
		VUHDO_customizeIconText(tHotIcon, tHotIcon:GetHeight(), tTimer, VUHDO_CONFIG["CLUSTER"]["TEXT"]);
		tTimer:Show();
		tCounter:Hide();
		tHotIcon:SetTexture("Interface\\AddOns\\VuhDo\\Images\\cluster2");
	else
		if sIconRadio == 3 then -- Flat
			tHotIcon:SetTexture("Interface\\AddOns\\VuhDo\\Images\\hot_flat_16_16");
		elseif sIconRadio == 2 then -- Glossy
			tHotIcon:SetTexture("Interface\\AddOns\\VuhDo\\Images\\icon_white_square");
		else
			local tHotName = sHotConfig["SLOTS"][anIndex];
			if VUHDO_CAST_ICON_DIFF[tHotName] then
				tHotIcon:SetTexture(VUHDO_CAST_ICON_DIFF[tHotName]);
			else
				local tTexture = GetSpellBookItemTexture(tHotName);
				if tTexture then
					tHotIcon:SetTexture(tTexture);
				end
			end
		end

		VUHDO_customizeIconText(tHotIcon, tHotIcon:GetHeight(), tTimer, VUHDO_PANEL_SETUP["HOTS"]["TIMER_TEXT"]);
		VUHDO_customizeIconText(tHotIcon, tHotIcon:GetHeight(), tCounter, VUHDO_PANEL_SETUP["HOTS"]["COUNTER_TEXT"]);

		if sStacksRadio == 2 then -- Counter text
			tHotIcon:SetVertexColor(1, 1, 1);
			tCounter:SetTextColor(tHotColor["TR"], tHotColor["TG"], tHotColor["TB"]);
			tCounter:Show();
		else
			tTimer:SetTextColor(VUHDO_textColor(tHotColor));
			tCounter:Hide();
		end

		tTimer:SetShown(tHotColor["countdownMode"] ~= 0);

		tChargeIcon:SetWidth(tHotIcon:GetWidth() + 4);
		tChargeIcon:SetHeight(tHotIcon:GetHeight() + 4);
		tChargeIcon:SetVertexColor(tHotColor["R"] * 2, tHotColor["G"] * 2, tHotColor["B"] * 2);
		tChargeIcon:SetPoint("TOPLEFT", tHotIcon:GetName(), "TOPLEFT", -2, 2);

		if tHotColor["isClock"] then
			local tCd = VUHDO_getOrCreateCooldown(VUHDO_getBarIconFrame(sButton, anIndex), sButton, anIndex);
			tCd:SetAllPoints(tHotIcon);
			tCd:SetReverse(true);
			tCd:SetCooldown(GetTime(), 0);
			tCd:SetAlpha(0);
		end
	end
end



--
local function VUHDO_initHotPosOffset(anIndex)
	local tHotIcon = VUHDO_getBarIcon(sButton, anIndex);
	local tOffset = (anIndex - (anIndex < 9 and 1 or 4)) * sHotIconSize;

	tHotIcon:ClearAllPoints();
	if sHotPos == 2 then tHotIcon:SetPoint("LEFT", sHealthBarName, "LEFT", tOffset,  0); -- li
	elseif sHotPos == 3 then tHotIcon:SetPoint("RIGHT",  sHealthBarName, "RIGHT",  -tOffset, 0); --  ri
	elseif sHotPos == 1 then tHotIcon:SetPoint("RIGHT",  sButton:GetName(), "LEFT", -tOffset, 0); -- lo
	elseif sHotPos == 4 then tHotIcon:SetPoint("LEFT", sButton:GetName(), "RIGHT", tOffset, 0); --  ro
	elseif sHotPos == 5 then tHotIcon:SetPoint("TOPLEFT",  sHealthBarName, "BOTTOMLEFT", tOffset, sHotIconSize * 0.5); -- lb
	elseif sHotPos == 6 then tHotIcon:SetPoint("TOPRIGHT", sHealthBarName, "BOTTOMRIGHT", -tOffset,  sHotIconSize * 0.5); -- rb
	elseif sHotPos == 7 then tHotIcon:SetPoint("TOPLEFT",  sButton:GetName(), "BOTTOMLEFT", tOffset, 0); -- lu
	elseif sHotPos == 8 then tHotIcon:SetPoint("TOPRIGHT", sButton:GetName(), "BOTTOMRIGHT", -tOffset,  0); -- ru
	elseif sHotPos == 9 then tHotIcon:SetPoint("TOPLEFT",  sHealthBarName, "TOPLEFT",  tOffset,  sBarScaling["barHeight"] / 3); -- la
	elseif sHotPos == 10 then tHotIcon:SetPoint("TOPLEFT",  sHealthBarName, "TOPLEFT", tOffset,  0); -- lu corner
	elseif sHotPos == 12 then tHotIcon:SetPoint("BOTTOMLEFT", sHealthBarName, "BOTTOMLEFT",  tOffset, 0);  -- lb corner
	elseif sHotPos == 11 then tHotIcon:SetPoint("BOTTOMRIGHT", sHealthBarName, "BOTTOMRIGHT", -tOffset, 0);  -- rb corner
	elseif sHotPos == 13 then tHotIcon:SetPoint("BOTTOMLEFT",  sButton:GetName(), "BOTTOMLEFT", tOffset, 0); -- lb
	elseif sHotPos == 14 then tHotIcon:SetPoint("BOTTOMRIGHT", sButton:GetName(), "BOTTOMRIGHT", -tOffset,  0); -- rb
	end

	tHotIcon:SetWidth(sHotIconSize);
	tHotIcon:SetHeight(sHotIconSize);
	VUHDO_getBarIconFrame(sButton, anIndex):SetScale(1);
end



--
local function VUHDO_initHotPosSides(anIndex)
	local tHotIcon = VUHDO_getBarIcon(sButton, anIndex);
	local tIsBothBottom = sHotConfig["SLOTS"][4] ~= nil	and sHotConfig["SLOTS"][5] ~= nil;
	local tIsBothTop = sHotConfig["SLOTS"][2] ~= nil	and sHotConfig["SLOTS"][9] ~= nil;
	tHotIcon:ClearAllPoints();

	if anIndex == 1 then
		tHotIcon:SetPoint("LEFT", sHealthBarName, "LEFT", 0, 0);
	elseif anIndex  == 2 then
		if tIsBothTop then tHotIcon:SetPoint("TOP",  sHealthBarName, "TOP",  -sBarScaling["barWidth"] * 0.2, 0);
		else tHotIcon:SetPoint("TOP",  sHealthBarName, "TOP",  0, 0); end
	elseif anIndex == 9 then
		if tIsBothTop then tHotIcon:SetPoint("TOP",  sHealthBarName, "TOP",  sBarScaling["barWidth"] * 0.2, 0);
		else tHotIcon:SetPoint("TOP",  sHealthBarName, "TOP",  0, 0); end
	elseif anIndex == 3 then
		tHotIcon:SetPoint("RIGHT",  sHealthBarName, "RIGHT",  0, 0);
	elseif anIndex  == 4 then
		if tIsBothBottom then tHotIcon:SetPoint("BOTTOM", sHealthBarName, "BOTTOM", sBarScaling["barWidth"] * 0.2, 0);
		else tHotIcon:SetPoint("BOTTOM", sHealthBarName, "BOTTOM", 0, 0); end
	elseif anIndex == 5 then
		if tIsBothBottom then tHotIcon:SetPoint("BOTTOM", sHealthBarName, "BOTTOM", -sBarScaling["barWidth"] * 0.2, 0);
		else tHotIcon:SetPoint("BOTTOM", sHealthBarName, "BOTTOM", 0, 0); end
	elseif anIndex == 10 then
		tHotIcon:SetPoint("CENTER", sHealthBarName, "CENTER", 0, 0);
	end

	tHotIcon:SetWidth(sHotIconSize  * 0.5);
	tHotIcon:SetHeight(sHotIconSize * 0.5);
	VUHDO_getBarIconFrame(sButton, anIndex):SetScale(VUHDO_PANEL_SETUP["HOTS"]["SLOTCFG"]["" .. anIndex]["scale"] or 1);
end



--
local function VUHDO_initHotPosEdges(anIndex)
	local tHotIcon = VUHDO_getBarIcon(sButton, anIndex);
	tHotIcon:ClearAllPoints();

	if anIndex == 1 then tHotIcon:SetPoint("TOPLEFT",  sHealthBarName, "TOPLEFT",  0, 0);
	elseif anIndex == 2 then tHotIcon:SetPoint("TOPRIGHT", sHealthBarName, "TOPRIGHT", 0, 0);
	elseif anIndex == 3 then tHotIcon:SetPoint("BOTTOMLEFT", sHealthBarName, "BOTTOMLEFT", 0, 0);
	elseif anIndex == 4 then tHotIcon:SetPoint("BOTTOMRIGHT",  sHealthBarName, "BOTTOMRIGHT",  0, 0);
	elseif anIndex == 5 then tHotIcon:SetPoint("BOTTOM", sHealthBarName, "BOTTOM", 0, 0);
	elseif anIndex == 9 then tHotIcon:SetPoint("TOP", sHealthBarName, "TOP", 0, 0);
	elseif anIndex == 10 then tHotIcon:SetPoint("CENTER", sHealthBarName, "CENTER", 0, 0);
	end

	tHotIcon:SetWidth(sHotIconSize  * 0.5);
	tHotIcon:SetHeight(sHotIconSize * 0.5);
	VUHDO_getBarIconFrame(sButton, anIndex):SetScale(VUHDO_PANEL_SETUP["HOTS"]["SLOTCFG"]["" .. anIndex]["scale"] or 1);
end



--
local tBarIcon;
local function VUHDO_initAndPosHotIcon(anIndex, aPosFunction)
	if not VUHDO_strempty(sHotConfig["SLOTS"][anIndex]) and sHotIconSize > 1 then
		VUHDO_getOrCreateHotIcon(sButton, anIndex);
		aPosFunction(anIndex);
		VUHDO_initHotIcon(anIndex);
	else
		tBarIcon = VUHDO_getBarIcon(sButton, anIndex);
		if tBarIcon then
			tBarIcon:Hide();
			VUHDO_getBarIconTimer(sButton, anIndex):Hide();
			VUHDO_getBarIconCounter(sButton, anIndex):Hide();
		end
	end
end



--
function VUHDO_initAllHotIcons()
	local tPosFunction;

	tPosFunction = 20 == sHotPos and VUHDO_initHotPosSides
		or 21 == sHotPos and VUHDO_initHotPosEdges or VUHDO_initHotPosOffset;

	for tCnt = 1, 5 do
		VUHDO_initAndPosHotIcon(tCnt, tPosFunction);
	end
	for tCnt = 9, 10 do
		VUHDO_initAndPosHotIcon(tCnt, tPosFunction);
	end
end
