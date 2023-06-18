
local sDebuffConfig;
local VUHDO_getBarIcon;
local VUHDO_getBarIconTimer;
local VUHDO_getBarIconCounter;
local VUHDO_getBarIconName;
local VUHDO_customizeIconText;
local sSign;
local sMaxNum;
local sPoint;
local sColSpacing;
local sTopSpacing;
local sBottomSpacing;
local sIsTooltipCache = { };

function VUHDO_panelRedrawCustomDebuffsInitLocalOverrides()
	VUHDO_getBarIcon = _G["VUHDO_getBarIcon"];
	VUHDO_getBarIconTimer = _G["VUHDO_getBarIconTimer"];
	VUHDO_getBarIconCounter = _G["VUHDO_getBarIconCounter"];
	VUHDO_getBarIconName = _G["VUHDO_getBarIconName"];
	VUHDO_customizeIconText = _G["VUHDO_customizeIconText"];

	sDebuffConfig = VUHDO_CONFIG["CUSTOM_DEBUFF"];
	sSign = ("TOPLEFT" == sDebuffConfig["point"] or "BOTTOMLEFT" == sDebuffConfig["point"]) and 1 or -1;
	sMaxNum = sDebuffConfig["max_num"];
	sPoint = sDebuffConfig["point"];
end



--
local sBarScaling;
local sXOffset, sYOffset;
local sHeight;
local sStep;
function VUHDO_panelRedrwawCustomDebuffsInitLocalVars(aPanelNum)
	sBarScaling = VUHDO_PANEL_SETUP[aPanelNum]["SCALING"];
	sXOffset = sDebuffConfig["xAdjust"] * sBarScaling["barWidth"] * 0.01;
	sYOffset = -sDebuffConfig["yAdjust"] * sBarScaling["barHeight"] * 0.01;
	sHeight = sBarScaling["barHeight"];
	sStep = sSign * sHeight;
	table.wipe(sIsTooltipCache);
	sColSpacing = sBarScaling["columnSpacing"];
	sTopSpacing = sBarScaling["rowSpacing"] + VUHDO_getAdditionalTopHeight(aPanelNum);
	sBottomSpacing = sBarScaling["rowSpacing"] + VUHDO_getAdditionalBottomHeight(aPanelNum);
end


local sButton;
local sHealthBar;
function VUHDO_initButtonStaticsCustomDebuffs(aButton, aPanelNum)
	sButton = aButton;
	sHealthBar = VUHDO_getHealthBar(aButton, 1);
end



--
local tMaxDiff, tMaxDiffTop, tMaxDiffBottom, tMaxDiffX, tRScale, tPScale;
local function VUHDO_isMostlyInBounds(aRegion, aParent, aMaxDiffFactor)

	if not aRegion:GetTop() or not aParent:GetTop() then return nil; end

	tRScale, tPScale = aRegion:GetEffectiveScale() or 1, aParent:GetEffectiveScale() or 1;

	tMaxDiff = (aRegion:GetWidth() or 0) * aMaxDiffFactor * tRScale;
	tMaxDiffX = tMaxDiff + sColSpacing * tPScale;
	--tMaxDiffY = tMaxDiff + sRowSpacing * tPScale;
	tMaxDiffTop = tMaxDiff + sTopSpacing * tPScale
	tMaxDiffBottom = tMaxDiff + sBottomSpacing * tPScale;

	--VUHDO_xMsg(floor(tMaxDiffX + 0.5), floor(tMaxDiffY + 0.5));

	return ((aRegion:GetLeft()   or 0) * tRScale >= (aParent:GetLeft()   or 0) * tPScale - tMaxDiffX
		  and (aRegion:GetTop()    or 0) * tRScale <= (aParent:GetTop()    or 0) * tPScale + tMaxDiffTop
		  and (aRegion:GetRight()  or 0) * tRScale <= (aParent:GetRight()  or 0) * tPScale + tMaxDiffX
		  and (aRegion:GetBottom() or 0) * tRScale >= (aParent:GetBottom() or 0) * tPScale - tMaxDiffBottom) and 1 or 0;

end


--
local tFrame;
local tIcon, tCounter, tName, tTimer;
local tIconIdx;
local tIconName;
local tButton;
function VUHDO_initCustomDebuffs()
	-- Wir brauchen mind. 1 für LastCustomDebuffBouquet
	if sMaxNum == 0 then VUHDO_getOrCreateCuDeButton(sButton, 40);
	else
		for tCnt = 0, sMaxNum - 1 do
			tIconIdx = 40 + tCnt;

			tButton = VUHDO_getOrCreateCuDeButton(sButton, tIconIdx);
			tButton:ClearAllPoints();
			tButton:SetPoint(sPoint, sHealthBar:GetName(), sPoint, sXOffset + (tCnt * sStep), sYOffset); -- center
			tButton:SetWidth(sHeight);
			tButton:SetHeight(sHeight);
			tButton:SetScale(1);

			tFrame = VUHDO_getBarIconFrame(sButton, tIconIdx);
			tFrame:ClearAllPoints();
			tFrame:SetPoint(sPoint, sHealthBar:GetName(), sPoint, sXOffset + (tCnt * sStep), sYOffset); -- center

			if not sIsTooltipCache[tIconIdx] then
				sIsTooltipCache[tIconIdx] = VUHDO_isMostlyInBounds(tButton, sButton, 0.33);
			end

			if VUHDO_CONFIG["DEBUFF_TOOLTIP"] and sIsTooltipCache[tIconIdx] == 1 then
				tFrame:SetWidth(sHeight);
				tFrame:SetHeight(sHeight);
			else
				tFrame:SetWidth(0.001);
				tFrame:SetHeight(0.001);
				--VUHDO_Msg("Removing " .. (tCnt + 1));
			end
			tFrame:SetAlpha(0);
			tFrame:SetScale(VUHDO_CONFIG["CUSTOM_DEBUFF"]["scale"] * 0.7);
			tFrame:Show();

			tIcon = VUHDO_getBarIcon(sButton, tIconIdx);
			tIcon:SetAllPoints();
			tIconName = tIcon:GetName();

			tTimer = VUHDO_getBarIconTimer(sButton, tIconIdx);
			VUHDO_customizeIconText(tIcon, sHeight, tTimer, VUHDO_CONFIG["CUSTOM_DEBUFF"]["TIMER_TEXT"]);
			tTimer:Show();

			tCounter = VUHDO_getBarIconCounter(sButton, tIconIdx);
			VUHDO_customizeIconText(tIcon, sHeight, tCounter, VUHDO_CONFIG["CUSTOM_DEBUFF"]["COUNTER_TEXT"]);
			tCounter:Show();

			tName = VUHDO_getBarIconName(sButton, tIconIdx);
			tName:SetPoint("BOTTOM", tIconName, "TOP", 0, 0);
			tName:SetFont(GameFontNormalSmall:GetFont(), 12, "OUTLINE", "");
			tName:SetShadowColor(0, 0, 0, 0);
			tName:SetTextColor(1, 1, 1, 1);
			tName:SetText("");
			tName:Show();
		end
	end

	for tCnt = sMaxNum + 40, 44 do
		tFrame = VUHDO_getBarIconFrame(sButton, tCnt);
		if tFrame then
			tFrame:ClearAllPoints();
			tFrame:Hide();
		end
	end
end
