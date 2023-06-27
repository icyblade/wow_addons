local UnitLevel = UnitLevel;
local UnitRace = UnitRace;
local UnitCreatureType = UnitCreatureType;
local GetGuildInfo = GetGuildInfo;
local UnitIsGhost = UnitIsGhost;
local UnitIsDead = UnitIsDead;
local IsAltKeyDown = IsAltKeyDown;
local IsControlKeyDown = IsControlKeyDown;
local IsShiftKeyDown = IsShiftKeyDown;
local InCombatLockdown = InCombatLockdown;
local UnitIsEnemy = UnitIsEnemy;
local pairs = pairs;
local ipairs = ipairs;
local twipe = table.wipe;
local format = format;



--
local VUHDO_getMouseCoords;
local VUHDO_getClassColor;
function VUHDO_tooltipInitBurst()
	VUHDO_getMouseCoords = VUHDO_GLOBAL["VUHDO_getMouseCoords"];
	VUHDO_getClassColor = VUHDO_GLOBAL["VUHDO_getClassColor"];
end
--



local VUHDO_TOOLTIP_POS_CUSTOM = 1;
local VUHDO_TOOLTIP_POS_STANDARD = 2;
local VUHDO_TOOLTIP_POS_MOUSE = 3;
local VUHDO_TOOLTIP_POS_LEFT = 50;
local VUHDO_TOOLTIP_POS_LEFT_UP = 51;
local VUHDO_TOOLTIP_POS_LEFT_DOWN = 52;
local VUHDO_TOOLTIP_POS_RIGHT = 60;
local VUHDO_TOOLTIP_POS_RIGHT_UP = 61;
local VUHDO_TOOLTIP_POS_RIGHT_DOWN = 62;
local VUHDO_TOOLTIP_POS_UP = 70;
local VUHDO_TOOLTIP_POS_UP_LEFT = 71;
local VUHDO_TOOLTIP_POS_UP_RIGHT = 72;
local VUHDO_TOOLTIP_POS_DOWN = 80;
local VUHDO_TOOLTIP_POS_DOWN_LEFT = 81;
local VUHDO_TOOLTIP_POS_DOWN_RIGHT = 82;


local sMaxLinesRight = 8;
local sMaxLinesLeft = 16;

local sAktLineLeft = 1;
local sAktLineRight = 1;

local VUHDO_TEXT_SIZE_LEFT = { };


local VUHDO_TT_UNIT = nil;
local VUHDO_TT_PANEL_NUM = nil;
local VUHDO_TT_RESET = true;


local VUHDO_VALUE_COLOR = {	["TR"] = 1,	["TG"] = 0.898,	["TB"] = 0.4 };



--
local tCnt;
local function VUHDO_clearTooltipLines()
	sAktLineLeft = 1;
	sAktLineRight = 1;
	twipe(VUHDO_TEXT_SIZE_LEFT);
	for tCnt = 1, sMaxLinesLeft do
		VUHDO_GLOBAL[format("VuhDoTooltipTextL%d", tCnt)]:SetText("");
	end
	for tCnt = 1, sMaxLinesRight do
		VUHDO_GLOBAL[format("VuhDoTooltipTextR%d", tCnt)]:SetText("");
	end
end



--
local tLabel;
local function VUHDO_setTooltipLine(aText, anIsLeft, aLineNum, aColor, aTextSize)
	tLabel = anIsLeft
	  and VUHDO_GLOBAL[format("VuhDoTooltipTextL%d", aLineNum)]
		or  VUHDO_GLOBAL[format("VuhDoTooltipTextR%d", aLineNum)];

	tLabel:SetText(aText);

	if (aColor ~= nil) then
		tLabel:SetTextColor(aColor["TR"], aColor["TG"], aColor["TB"], 1);
	end

	if ((aTextSize or 0) ~= 0) then
		tLabel:SetFont(GameFontNormal:GetFont(), aTextSize);
	end

	if (anIsLeft) then
		VUHDO_TEXT_SIZE_LEFT[aLineNum] = aTextSize or 8;
		VUHDO_TEXT_SIZE_LEFT[aLineNum] = VUHDO_TEXT_SIZE_LEFT[aLineNum] + 0.7;
	elseif (VUHDO_TEXT_SIZE_LEFT[aLineNum] > 0) then
		tLabel:SetHeight(VUHDO_TEXT_SIZE_LEFT[aLineNum]);
	end

	tLabel:Show();
end



--
local function VUHDO_addTooltipLineLeft(aText, aColor, aTextSize)
	if (sAktLineLeft < sMaxLinesLeft) then
		VUHDO_setTooltipLine(aText, true, sAktLineLeft, aColor, aTextSize)
		sAktLineLeft = sAktLineLeft + 1;
	end
end



--
local function VUHDO_addTooltipLineRight(aText, aColor, aTextSize)
	if (sAktLineRight < sMaxLinesRight) then
		VUHDO_setTooltipLine(aText, false, sAktLineRight, aColor, aTextSize)
		sAktLineRight = sAktLineRight + 1;
	end
end



--
local VUHDO_TT_FIX_POINTS = {
	[VUHDO_TOOLTIP_POS_LEFT] = { "RIGHT", "LEFT" },
	[VUHDO_TOOLTIP_POS_LEFT_UP] = { "TOPRIGHT", "TOPLEFT" },
	[VUHDO_TOOLTIP_POS_LEFT_DOWN] = { "BOTTOMRIGHT" , "BOTTOMLEFT" },
	[VUHDO_TOOLTIP_POS_RIGHT] = { "LEFT", "RIGHT" },
	[VUHDO_TOOLTIP_POS_RIGHT_UP] = { "TOPLEFT", "TOPRIGHT" },
	[VUHDO_TOOLTIP_POS_RIGHT_DOWN] = { "BOTTOMLEFT", "BOTTOMRIGHT" },
	[VUHDO_TOOLTIP_POS_UP] = { "BOTTOM", "TOP" },
	[VUHDO_TOOLTIP_POS_UP_LEFT] = { "BOTTOMLEFT", "TOPLEFT" },
	[VUHDO_TOOLTIP_POS_UP_RIGHT] = { "BOTTOMRIGHT", "TOPRIGHT" },
	[VUHDO_TOOLTIP_POS_DOWN] = { "TOP", "BOTTOM" },
	[VUHDO_TOOLTIP_POS_DOWN_LEFT] = { "TOPLEFT", "BOTTOMLEFT" },
	[VUHDO_TOOLTIP_POS_DOWN_RIGHT] = { "TOPRIGHT", "BOTTOMRIGHT" },
};



--
local tMouseX, tMouseY;
local tConfig;
local tPos;
local tFactorScale;
local tFixPos;
local function VUHDO_initTooltip()
	tConfig = VUHDO_PANEL_SETUP[VUHDO_TT_PANEL_NUM]["TOOLTIP"];
	tPos = tConfig["position"];

	if (VUHDO_TT_RESET) then
		VUHDO_TT_RESET = false;

		VuhDoTooltip:SetScale(tConfig["SCALE"]);

		VuhDoTooltip:SetBackdropColor(
			tConfig["BACKGROUND"]["R"],
			tConfig["BACKGROUND"]["G"],
			tConfig["BACKGROUND"]["B"],
			tConfig["BACKGROUND"]["O"]
		);

		VuhDoTooltip:SetBackdropBorderColor(
			tConfig["BORDER"]["R"],
			tConfig["BORDER"]["G"],
			tConfig["BORDER"]["B"],
			tConfig["BORDER"]["O"]
		);

		VuhDoTooltip:ClearAllPoints();
		tFixPos = VUHDO_TT_FIX_POINTS[tPos];
		if (tFixPos ~= nil) then
			VuhDoTooltip:SetPoint(tFixPos[1], VUHDO_getActionPanel(VUHDO_TT_PANEL_NUM):GetName(), tFixPos[2], 0, 0);
		elseif (VUHDO_TOOLTIP_POS_CUSTOM == tPos) then
			VuhDoTooltip:SetPoint(tConfig["point"], "UIParent", tConfig["relativePoint"], tConfig["x"], tConfig["y"]);
		elseif (VUHDO_TOOLTIP_POS_STANDARD == tPos) then
			if (not VUHDO_CONFIG["STANDARD_TOOLTIP"]) then
				GameTooltip:Hide();
			end

			VuhDoTooltip:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -CONTAINER_OFFSET_X - 13, CONTAINER_OFFSET_Y);
		end

		if (VUHDO_TOOLTIP_POS_MOUSE == tPos) then
			VUHDO_setTooltipDelay(0.01);
		else
			VUHDO_setTooltipDelay(2.3);
		end
		VuhDoTooltip:SetWidth(200);
	end

	if (VUHDO_TOOLTIP_POS_MOUSE == tPos) then
		tMouseX, tMouseY = VUHDO_getMouseCoords();
		tFactorScale = VuhDoTooltip:GetScale();
		VuhDoTooltip:ClearAllPoints();
		VuhDoTooltip:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", (tMouseX  +  16) / tFactorScale, (tMouseY - 16) / tFactorScale);
	end
end



--
function VUHDO_resetTooltip()
	VUHDO_TT_RESET = true;
end



--
local tHeight;
local tTextHeight;
local function VUHDO_finishTooltip()
	tHeight = 28;
	for _, tTextHeight in pairs(VUHDO_TEXT_SIZE_LEFT) do
		tHeight = tHeight + tTextHeight + 1;
	end

	VuhDoTooltip:SetHeight(tHeight);
	VuhDoTooltip:Show();
end



--
local tSpellName;
local tButtonId;
local function VUHDO_getSpellTooltip(aModifier, aButtonNum, anInfo)

	if (UnitIsEnemy("player", anInfo["unit"])) then
		if (aButtonNum < 6) then
			tButtonId = format("%s%d", aModifier, aButtonNum);
			if (VUHDO_SPELL_ASSIGNMENTS[tButtonId][3] ~= nil) then
				tSpellName = VUHDO_HOSTILE_SPELL_ASSIGNMENTS[tButtonId][3];
			end
		else
			tButtonId = format("%s%d", aModifier, aButtonNum - 5);
			if (VUHDO_SPELL_ASSIGNMENTS[tButtonId][3] ~= nil) then
				tSpellName = VUHDO_SPELLS_KEYBOARD["HOSTILE_WHEEL"][tButtonId][3];
			end
		end
	else
		if (aButtonNum < 6) then
			tButtonId = format("%s%d", aModifier, aButtonNum);
			if (VUHDO_SPELL_ASSIGNMENTS[tButtonId][3] ~= nil) then
				tSpellName = VUHDO_SPELL_ASSIGNMENTS[tButtonId][3];
			end
		else
			tButtonId = format("%s%d", aModifier, aButtonNum - 5);
			if (VUHDO_SPELL_ASSIGNMENTS[tButtonId][3] ~= nil) then
				tSpellName = VUHDO_SPELLS_KEYBOARD["WHEEL"][tButtonId][3];
			end
		end
	end
	if (strlen(tSpellName or "") ~= 0) then
		return format("|cffffffff%s|r", tSpellName);
	else
		return "";
	end

end



--
local function VUHDO_getKiloText(aNumber)
	if (aNumber < 10000) then
		return aNumber;
	else
		return format("%.1fk", aNumber * 0.001);
	end
end



--
local tInfo;
local tLevel;
local tRace;
local tClassColor;
local tLeftText;
local tRightText;
local tModifier;
local tKey;
local tGuildName, tGuildRank;
local tRole;
local tGuild;
local tDistance;
local tIndex, tButtonName, tBinding;
function VUHDO_updateTooltip()
	tInfo = VUHDO_RAID[VUHDO_TT_UNIT];

	if (tInfo == nil) then
		return;
	end

	VUHDO_initTooltip();
	VUHDO_clearTooltipLines();

	-- Name, Role
	tClassColor = VUHDO_getClassColor(tInfo);
	if (tClassColor == nil) then
		tClassColor = VUHDO_PANEL_SETUP[VUHDO_TT_PANEL_NUM]["PANEL_COLOR"]["TEXT"];
	end

	tRole = tInfo["role"] ~= nil and format("(%s)", VUHDO_HEADER_TEXTS[tInfo["role"]]) or "";

	VUHDO_addTooltipLineLeft(tInfo["fullName"], tClassColor, 10);
	VUHDO_addTooltipLineRight(tRole, tClassColor, 8);

	-- Level, Klasse, Rasse
	tLevel = UnitLevel(VUHDO_TT_UNIT) or "";
	VUHDO_addTooltipLineLeft(format("%s%d %s", VUHDO_I18N_TT_LEVEL, tLevel, (tInfo["className"] or "?")), tClassColor, 9);

	tRace = UnitRace(VUHDO_TT_UNIT) or UnitCreatureType(VUHDO_TT_UNIT) or " ";
	VUHDO_addTooltipLineRight(tRace, tClassColor, 9);

	-- Guild
	tGuildName, tGuildRank, _ = GetGuildInfo(VUHDO_TT_UNIT);
	if (tGuildName ~= nil) then
		tGuildRank = tGuildRank or " ";
		tGuild = format("%s %s <%s>", tGuildRank, VUHDO_I18N_TT_OF, tGuildName);
	else
		tGuild = " ";
	end
	VUHDO_addTooltipLineLeft(tGuild, tClassColor, 9);
	VUHDO_addTooltipLineRight(" ", tClassColor, 9);

	-- Distance
	tDistance = VUHDO_getDistanceText(VUHDO_TT_UNIT);
	VUHDO_addTooltipLineLeft(VUHDO_I18N_TT_DISTANCE);
	VUHDO_addTooltipLineRight(tDistance, VUHDO_VALUE_COLOR);

	-- Position
	VUHDO_addTooltipLineLeft(VUHDO_I18N_TT_POSITION);
	VUHDO_addTooltipLineRight(tInfo["zone"] or " ", VUHDO_VALUE_COLOR);

	if (UnitIsGhost(VUHDO_TT_UNIT)) then
		tLeftText = VUHDO_I18N_TT_GHOST;
	elseif (UnitIsDead(VUHDO_TT_UNIT)) then
		tLeftText = VUHDO_I18N_TT_DEAD;
	else
		tLeftText = " ";
	end

	tRightText = " ";
	if (not tInfo["connected"]) then
		tRightText = VUHDO_getDurationTextSince(VUHDO_getAfkDcTime(VUHDO_TT_UNIT));
	elseif (tInfo["afk"]) then
		tRightText = format("%s %s", VUHDO_I18N_TT_AFK, VUHDO_getDurationTextSince(VUHDO_getAfkDcTime(VUHDO_TT_UNIT)));
	elseif(UnitIsDND(VUHDO_TT_UNIT)) then
		tRightText = VUHDO_I18N_TT_DND;
	end

	if (tLeftText ~= " " or tRightText ~= " ") then
		VUHDO_addTooltipLineLeft(tLeftText, VUHDO_VALUE_COLOR);
		VUHDO_addTooltipLineRight(tRightText, VUHDO_VALUE_COLOR);
	end

	tLeftText = format("%s%s/%s", VUHDO_I18N_TT_LIFE, VUHDO_getKiloText(tInfo["health"]), VUHDO_getKiloText(tInfo["healthmax"]));
	tRightText = VUHDO_UNIT_POWER_MANA == tInfo["powertype"]
		and format("%s%s/%s", VUHDO_I18N_TT_MANA, VUHDO_getKiloText(tInfo["power"]), VUHDO_getKiloText(tInfo["powermax"]))
		or "";

	VUHDO_addTooltipLineLeft(tLeftText, VUHDO_VALUE_COLOR, 8);
	VUHDO_addTooltipLineRight(tRightText, VUHDO_VALUE_COLOR, 8);

	if (VUHDO_SPELL_CONFIG["IS_TOOLTIP_INFO"]) then
		tModifier = "";
		if (IsAltKeyDown()) then
			tModifier = tModifier .. "alt";
		end

		if (IsControlKeyDown()) then
			tModifier = tModifier .. "ctrl";
		end

		if (IsShiftKeyDown()) then
			tModifier = tModifier .. "shift";
		end

		for tIndex, tButtonName in ipairs(VUHDO_MOUSE_BUTTONS) do
			tBinding = VUHDO_getSpellTooltip(tModifier, tIndex, tInfo);
			if (strlen(tBinding) ~= 0) then
				VUHDO_addTooltipLineLeft(format("%s%s%s", tModifier, tButtonName, tBinding), VUHDO_VALUE_COLOR, 8);
			end
		end
	end

	VUHDO_finishTooltip();
end



--
local tPanelNum;
local tTipConfig;
local tUnit;
function VUHDO_showTooltip(aButton)
	tPanelNum = VUHDO_BUTTON_CACHE[aButton];
	tTipConfig = VUHDO_PANEL_SETUP[tPanelNum]["TOOLTIP"];

	if (not tTipConfig["show"]
		or VUHDO_IS_PANEL_CONFIG
		or (InCombatLockdown() and not tTipConfig["inFight"])) then
		return;
	end

	tUnit = aButton:GetAttribute("unit");

	if (VUHDO_RAID[tUnit] == nil) then
		-- Must not happen
		return;
	end

	if (VUHDO_CONFIG["STANDARD_TOOLTIP"]) then
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
		GameTooltip:SetUnit(tUnit);
		GameTooltip:Show();
		return;
	end

	VUHDO_TT_UNIT = tUnit;
	VUHDO_TT_PANEL_NUM = tPanelNum;
	VUHDO_updateTooltip();
end



--
function VUHDO_demoTooltip(aPanelNum)
	if (not VUHDO_PANEL_SETUP[aPanelNum]["TOOLTIP"]["show"]) then
		return;
	end

	VUHDO_TT_UNIT = "player";
	VUHDO_TT_PANEL_NUM = aPanelNum;
	VUHDO_TT_RESET = true;
	VUHDO_updateTooltip();
end



--
function VUHDO_hideTooltip()
	if (not VUHDO_IS_PANEL_CONFIG) then
		if (VUHDO_CONFIG["STANDARD_TOOLTIP"]) then
			GameTooltip:Hide();
		else
			VuhDoTooltip:Hide();
		end
	end
end


--
function VuhDoTooltipOnMouseDown(aTooltip)
	if (VUHDO_IS_PANEL_CONFIG and VUHDO_PANEL_SETUP[DESIGN_MISC_PANEL_NUM]["TOOLTIP"]["position"] == VUHDO_TOOLTIP_POS_CUSTOM) then
		VUHDO_REFRESH_TOOLTIP_TIMER = 0;
		aTooltip:StartMoving();
	end
end



--
local tPosition;
function VuhDoTooltipOnMouseUp(aTooltip)
	aTooltip:StopMovingOrSizing();

	local tSetup;
	local tConfig;
	local tX, tY, tRelative, tOrientation;

	tPosition = VUHDO_PANEL_SETUP[DESIGN_MISC_PANEL_NUM]["TOOLTIP"];
	tOrientation, _, tRelative, tX, tY = aTooltip:GetPoint(0);

	tPosition["x"] = tX;
	tPosition["y"] = tY;
	tPosition["point"] = tOrientation;
	tPosition["relativePoint"] = tRelative;

	VUHDO_initTooltipTimer();
end

