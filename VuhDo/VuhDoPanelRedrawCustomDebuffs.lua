
local sDebuffConfig;
local VUHDO_getBarIcon;
local VUHDO_getBarIconTimer;
local VUHDO_getBarIconCounter;
local VUHDO_getBarIconName;
local VUHDO_customizeIconText;
local sSign;
local sMaxNum;
local sPoint;

function VUHDO_panelRedrawCustomDebuffsInitBurst()
	VUHDO_getBarIcon = VUHDO_GLOBAL["VUHDO_getBarIcon"];
	VUHDO_getBarIconTimer = VUHDO_GLOBAL["VUHDO_getBarIconTimer"];
	VUHDO_getBarIconCounter = VUHDO_GLOBAL["VUHDO_getBarIconCounter"];
	VUHDO_getBarIconName = VUHDO_GLOBAL["VUHDO_getBarIconName"];
	VUHDO_customizeIconText = VUHDO_GLOBAL["VUHDO_customizeIconText"];

	sDebuffConfig = VUHDO_CONFIG["CUSTOM_DEBUFF"];

	if ("TOPLEFT" == sDebuffConfig["point"] or "BOTTOMLEFT" == sDebuffConfig["point"]) then
		sSign = 1;
	else
		sSign = -1;
	end

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
end


local sButton;
local sHealthBar;
function VUHDO_initButtonStaticsCustomDebuffs(aButton, aPanelNum)
	sButton = aButton;
	sHealthBar = VUHDO_getHealthBar(aButton, 1);
end




--
local tFrame;
local tIcon, tCounter, tName, tTimer;
local tCnt;
local tIconIdx;
local tIconName;
local tButton;
function VUHDO_initCustomDebuffs()
	for tCnt = 0, sMaxNum - 1 do
		tIconIdx = 40 + tCnt;

		tFrame = VUHDO_getBarIconFrame(sButton, tIconIdx);
		tFrame:ClearAllPoints();
		tFrame:SetPoint(sPoint, sHealthBar:GetName(), sPoint,
			 sXOffset + (tCnt * sStep), sYOffset); -- center
		if (VUHDO_CONFIG["DEBUFF_TOOLTIP"]) then
			tFrame:SetWidth(sHeight);
			tFrame:SetHeight(sHeight);
		else
			tFrame:SetWidth(0.001);
			tFrame:SetHeight(0.001);
		end
		tFrame:SetAlpha(0);
		tFrame:SetScale(VUHDO_CONFIG["CUSTOM_DEBUFF"]["scale"] * 0.7);
		tFrame:Show();

		tButton = VUHDO_getBarIconButton(sButton, tIconIdx);
		--tButton:SetPoint("CENTER", tFrame:GetName(), "CENTER", 0, 0);
		tButton:ClearAllPoints();
		tButton:SetPoint(sPoint, sHealthBar:GetName(), sPoint,
			 sXOffset + (tCnt * sStep), sYOffset); -- center
		tButton:SetWidth(sHeight);
		tButton:SetHeight(sHeight);
		tButton:SetScale(1);

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

	for tCnt = sMaxNum + 40, 44 do
		tFrame = VUHDO_getBarIconFrame(sButton, tCnt);
		tFrame:ClearAllPoints();
		tFrame:Hide();
	end
end
