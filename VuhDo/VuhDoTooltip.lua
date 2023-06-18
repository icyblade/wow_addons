local _;
local UnitLevel = UnitLevel;
local UnitRace = UnitRace;
local UnitCreatureType = UnitCreatureType;
local GetGuildInfo = GetGuildInfo;
local UnitIsGhost = UnitIsGhost;
local UnitIsDead = UnitIsDead;
local InCombatLockdown = InCombatLockdown;
local UnitPowerType = UnitPowerType;
local UnitPower = UnitPower;
local UnitPowerMax = UnitPowerMax;
local UnitHealth = UnitHealth;
local UnitHealthMax = UnitHealthMax;
local UnitIsConnected = UnitIsConnected;
local UnitIsAFK = UnitIsAFK;
local UnitIsDND = UnitIsDND;
local GetRealZoneText = GetRealZoneText;
local UnitExists = UnitExists;
local UnitClass = UnitClass;
local UnitName = UnitName;

local pairs = pairs;
local ipairs = ipairs;
local twipe = table.wipe;
local format = format;
local sEmpty = { };



--
local VUHDO_getClassColorByModelId;
local VUHDO_strempty;
function VUHDO_tooltipInitLocalOverrides()
	VUHDO_getClassColorByModelId = _G["VUHDO_getClassColorByModelId"];
	VUHDO_strempty = _G["VUHDO_strempty"];
end
--



local VUHDO_TOOLTIP_POS_CUSTOM = 1;
local VUHDO_TOOLTIP_POS_STANDARD = 2;
local VUHDO_TOOLTIP_POS_MOUSE = 3;

local sAktLineLeft;
local sAktLineRight;

local VUHDO_TEXT_SIZE_LEFT = { };


local VUHDO_TT_UNIT = nil;
local VUHDO_TT_PANEL_NUM = nil;
local VUHDO_TT_BUTTON = nil;
local VUHDO_TT_RESET = true;


local VUHDO_VALUE_COLOR = {	["TR"] = 1,	["TG"] = 0.898,	["TB"] = 0.4, ["TO"] = 1 };



--
local tLabel;
local function VUHDO_setTooltipLine(aText, anIsLeft, aLineNum, aColor, aTextSize)
	tLabel = _G[format("VuhDoTooltipText%s%d", anIsLeft and "L" or "R", aLineNum)];
	tLabel:SetText(aText);

	if aColor then tLabel:SetTextColor(VUHDO_textColor(aColor)); end

	if (aTextSize or 0) ~= 0 then
		tLabel:SetFont(GameFontNormal:GetFont(), aTextSize);
	end

	if anIsLeft then
		VUHDO_TEXT_SIZE_LEFT[aLineNum] = (aTextSize or 8) + 0.7;
		tLabel:SetHeight(VUHDO_TEXT_SIZE_LEFT[aLineNum]);
	else
		tLabel:SetHeight(VUHDO_TEXT_SIZE_LEFT[aLineNum] or 8.7);
	end

	tLabel:SetJustifyH(anIsLeft and "LEFT" or "RIGHT");
	tLabel:SetWidth(186);
	tLabel:Show();
	tLabel:SetNonSpaceWrap(false);
end



--
local function VUHDO_addTooltipLineLeft(aText, aColor, aTextSize)
	if sAktLineLeft < 16 then
		VUHDO_setTooltipLine(aText, true, sAktLineLeft, aColor, aTextSize)
		sAktLineLeft = sAktLineLeft + 1;
	end
end



--
local function VUHDO_addTooltipLineRight(aText, aColor, aTextSize)
	if sAktLineRight < 8 then
		VUHDO_setTooltipLine(aText, false, sAktLineRight, aColor, aTextSize)
		sAktLineRight = sAktLineRight + 1;
	end
end



--
local VUHDO_TT_FIX_POINTS = {
	[50] = { "RIGHT", "LEFT" }, -- VUHDO_TOOLTIP_POS_LEFT
	[51] = { "TOPRIGHT", "TOPLEFT" }, -- VUHDO_TOOLTIP_POS_LEFT_UP
	[52] = { "BOTTOMRIGHT" , "BOTTOMLEFT" }, -- VUHDO_TOOLTIP_POS_LEFT_DOWN
	[60] = { "LEFT", "RIGHT" }, -- VUHDO_TOOLTIP_POS_RIGHT
	[61] = { "TOPLEFT", "TOPRIGHT" }, -- VUHDO_TOOLTIP_POS_RIGHT_UP
	[62] = { "BOTTOMLEFT", "BOTTOMRIGHT" }, -- VUHDO_TOOLTIP_POS_RIGHT_DOWN
	[70] = { "BOTTOM", "TOP" }, -- VUHDO_TOOLTIP_POS_UP
	[71] = { "BOTTOMLEFT", "TOPLEFT" }, -- VUHDO_TOOLTIP_POS_UP_LEFT
	[72] = { "BOTTOMRIGHT", "TOPRIGHT" }, -- VUHDO_TOOLTIP_POS_UP_RIGHT
	[80] = { "TOP", "BOTTOM" }, -- VUHDO_TOOLTIP_POS_DOWN
	[81] = { "TOPLEFT", "BOTTOMLEFT" }, -- VUHDO_TOOLTIP_POS_DOWN_LEFT
	[82] = { "TOPRIGHT", "BOTTOMRIGHT" }, -- VUHDO_TOOLTIP_POS_DOWN_RIGHT
};



--
local tConfig;
local tPos;
local tFixPos;
local function VUHDO_initTooltip()
	tConfig = VUHDO_PANEL_SETUP[VUHDO_TT_PANEL_NUM]["TOOLTIP"];
	tPos = tConfig["position"];

	twipe(VUHDO_TEXT_SIZE_LEFT);
	sAktLineLeft = 1;
	sAktLineRight = 1;

	tFixPos = VUHDO_TT_FIX_POINTS[tPos];
	if VUHDO_TT_RESET or tFixPos then
		VUHDO_TT_RESET = false;

		VuhDoTooltip:SetScale(tConfig["SCALE"]);
		VuhDoTooltip:SetBackdropColor(VUHDO_backColor(tConfig["BACKGROUND"]));
		VuhDoTooltip:SetBackdropBorderColor(VUHDO_backColor(tConfig["BORDER"]));

		VuhDoTooltip:ClearAllPoints();
		if tFixPos then
			VuhDoTooltip:SetPoint(tFixPos[1], VUHDO_getActionPanel(VUHDO_TT_PANEL_NUM):GetName(), tFixPos[2], 0, 0);
		elseif VUHDO_TOOLTIP_POS_CUSTOM == tPos then
			VuhDoTooltip:SetPoint(tConfig["point"], "UIParent", tConfig["relativePoint"], tConfig["x"], tConfig["y"]);
		elseif VUHDO_TOOLTIP_POS_STANDARD == tPos then
			if (not VUHDO_CONFIG["STANDARD_TOOLTIP"]) then
				GameTooltip:Hide();
			end

			VuhDoTooltip:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -CONTAINER_OFFSET_X - 13, CONTAINER_OFFSET_Y);
		end

		VuhDoTooltip:SetWidth(200);
	end

	if VUHDO_TOOLTIP_POS_MOUSE == tPos then
		if VUHDO_TT_BUTTON then
			VuhDoTooltip:ClearAllPoints();
			VuhDoTooltip:SetPoint("TOPLEFT", VUHDO_TT_BUTTON:GetName(), "BOTTOMRIGHT", 0, 0);
		else
			VuhDoTooltip:Hide();
			return;
		end
	end

	VuhDoTooltip:Show();
end



--
function VUHDO_resetTooltip()
	VUHDO_TT_RESET = true;
end



--
local tHeight;
local function VUHDO_finishTooltip()
	for tCnt = sAktLineLeft, 16 do
		_G[format("VuhDoTooltipTextL%d", tCnt)]:SetText("");
	end
	for tCnt = sAktLineRight, 8 do
		_G[format("VuhDoTooltipTextR%d", tCnt)]:SetText("");
	end

	tHeight = 28;
	for _, tTextHeight in pairs(VUHDO_TEXT_SIZE_LEFT) do
		tHeight = tHeight + tTextHeight + 1;
	end

	VuhDoTooltip:SetHeight(tHeight);
end



--
local tSpellName;
local tButtonId;
local function VUHDO_getSpellTooltip(aModifier, aButtonNum, aUnit)
	tSpellName = nil;

	if not UnitIsFriend("player", aUnit) then
		if aButtonNum < 6 then
			tButtonId = format("%s%d", aModifier, aButtonNum);
			if (VUHDO_HOSTILE_SPELL_ASSIGNMENTS[tButtonId] or sEmpty)[3] then
				tSpellName = VUHDO_HOSTILE_SPELL_ASSIGNMENTS[tButtonId][3];
			end
		else
			tButtonId = format("%s%d", aModifier, aButtonNum - 5);
			if (VUHDO_SPELLS_KEYBOARD["HOSTILE_WHEEL"][tButtonId] or sEmpty)[3] then
				tSpellName = VUHDO_SPELLS_KEYBOARD["HOSTILE_WHEEL"][tButtonId][3];
			end
		end
	else
		if aButtonNum < 6 then
			tButtonId = format("%s%d", aModifier, aButtonNum);
			if (VUHDO_SPELL_ASSIGNMENTS[tButtonId] or sEmpty)[3] then
				tSpellName = VUHDO_SPELL_ASSIGNMENTS[tButtonId][3];
			end
		else
			tButtonId = format("%s%d", aModifier, aButtonNum - 5);
			if (VUHDO_SPELLS_KEYBOARD["WHEEL"][tButtonId] or sEmpty)[3] then
				tSpellName = VUHDO_SPELLS_KEYBOARD["WHEEL"][tButtonId][3];
			end
		end
	end

	return not VUHDO_strempty(tSpellName) and format("|cffffffff%s|r", tSpellName) or "";
end



--
local function VUHDO_getKiloText(aNumber)
	return aNumber > 99500 and format("%dk", aNumber * 0.001)
		or aNumber > 9500 and format("%.1fk", aNumber * 0.001)
		or aNumber;
end



--
local tUnit, tInfo;
local tClassColor;
local tLeftText;
local tRightText;
local tModifier;
local tGuildName, tGuildRank;
local tBinding;
local tClassName, tClassNameLoc;
function VUHDO_updateTooltip()
	if not UnitExists(VUHDO_TT_UNIT) then	return;	end

	tInfo = VUHDO_RAID[VUHDO_RAID_NAMES[UnitName(VUHDO_TT_UNIT)]] or VUHDO_RAID[VUHDO_TT_UNIT];
	if not tInfo then
		tUnit = VUHDO_TT_UNIT;
		tInfo = sEmpty;
	else
		tUnit = tInfo["unit"];
	end

	VUHDO_initTooltip();

	-- Name, Role
	tClassNameLoc, tClassName = UnitClass(tUnit);
	tClassColor = VUHDO_getClassColorByModelId(VUHDO_CLASS_IDS[tClassName] or "*");
	if not tClassColor then
		tClassColor = VUHDO_PANEL_SETUP[VUHDO_TT_PANEL_NUM]["PANEL_COLOR"]["TEXT"];
	end

	VUHDO_addTooltipLineLeft(tInfo["fullName"] or UnitName(tUnit), tClassColor, 10);
	VUHDO_addTooltipLineRight(tInfo["role"] ~= nil and format("(%s)", VUHDO_HEADER_TEXTS[tInfo["role"]]) or "", tClassColor, 8);

	-- Level, Klasse, Rasse
	VUHDO_addTooltipLineLeft(format("%s%d %s", VUHDO_I18N_TT_LEVEL, UnitLevel(tUnit) or "", tClassNameLoc or "?"), tClassColor, 9);
	VUHDO_addTooltipLineRight(UnitRace(tUnit) or UnitCreatureType(tUnit) or " ", tClassColor, 9);

	-- Guild
	tGuildName, tGuildRank = GetGuildInfo(tUnit);
	tLeftText = tGuildName ~= nil and format("%s %s <%s>", tGuildRank or " ", VUHDO_I18N_TT_OF, tGuildName) or " ";
	VUHDO_addTooltipLineLeft(tLeftText, tClassColor, 9);
	VUHDO_addTooltipLineRight(" ", tClassColor, 9);

	-- Distance
	VUHDO_addTooltipLineLeft(VUHDO_I18N_TT_DISTANCE);
	VUHDO_addTooltipLineRight(VUHDO_getDistanceText(tUnit), VUHDO_VALUE_COLOR);

	-- Position
	VUHDO_addTooltipLineLeft(VUHDO_I18N_TT_POSITION);
	VUHDO_addTooltipLineRight(tInfo["zone"] or GetRealZoneText() or " ", VUHDO_VALUE_COLOR);

	tLeftText =
		UnitIsGhost(tUnit) and VUHDO_I18N_TT_GHOST
		or UnitIsDead(tUnit) and VUHDO_I18N_TT_DEAD or " ";

	tRightText =
		not UnitIsConnected(tUnit) and VUHDO_getDurationTextSince(VUHDO_getAfkDcTime(tUnit))
		or UnitIsAFK(tUnit) and format("%s %s", VUHDO_I18N_TT_AFK, VUHDO_getDurationTextSince(VUHDO_getAfkDcTime(tUnit)))
		or UnitIsDND(tUnit) and VUHDO_I18N_TT_DND or " ";

	if tLeftText ~= " " or tRightText ~= " " then
		VUHDO_addTooltipLineLeft(tLeftText, VUHDO_VALUE_COLOR);
		VUHDO_addTooltipLineRight(tRightText, VUHDO_VALUE_COLOR);
	end

	tLeftText = format("%s%s/%s",
		VUHDO_I18N_TT_LIFE, VUHDO_getKiloText(UnitHealth(tUnit)), VUHDO_getKiloText(UnitHealthMax(tUnit)));

	tRightText = tonumber(UnitPowerType(tUnit) or "0") == VUHDO_UNIT_POWER_MANA
		and format("%s%s/%s", VUHDO_I18N_TT_MANA, VUHDO_getKiloText(UnitPower(tUnit)), VUHDO_getKiloText(UnitPowerMax(tUnit)))
		or " ";

	VUHDO_addTooltipLineLeft(tLeftText, VUHDO_VALUE_COLOR, 8);
	VUHDO_addTooltipLineRight(tRightText, VUHDO_VALUE_COLOR, 8);

	if VUHDO_SPELL_CONFIG["IS_TOOLTIP_INFO"] then
		tModifier = VUHDO_getCurrentKeyModifierString();

		for tIndex, tButtonName in ipairs(VUHDO_MOUSE_BUTTONS) do
			tBinding = VUHDO_getSpellTooltip(tModifier, tIndex, tUnit);
			if #tBinding ~= 0 then
				VUHDO_addTooltipLineLeft(format("%s%s%s", tModifier, tButtonName, tBinding), VUHDO_VALUE_COLOR, 8);
			end
		end
	end

	VUHDO_finishTooltip();
end



--
local tPanelNum;
local tTipConfig;
function VUHDO_showTooltip(aButton)
	tPanelNum = VUHDO_BUTTON_CACHE[aButton];
	tTipConfig = VUHDO_PANEL_SETUP[tPanelNum]["TOOLTIP"];

	if not tTipConfig["show"]	or VUHDO_IS_PANEL_CONFIG or (InCombatLockdown() and not tTipConfig["inFight"]) then
		return;
	end

	if VUHDO_CONFIG["STANDARD_TOOLTIP"] then
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
		GameTooltip:SetUnit(aButton:GetAttribute("unit"));
		GameTooltip:Show();
	else
		VUHDO_TT_UNIT = aButton:GetAttribute("unit");
		VUHDO_TT_PANEL_NUM = tPanelNum;
		VUHDO_TT_BUTTON = aButton;
		VUHDO_updateTooltip();
	end
end



--
function VUHDO_demoTooltip(aPanelNum)
	if not VUHDO_PANEL_SETUP[aPanelNum]["TOOLTIP"]["show"] then return; end

	VUHDO_TT_UNIT = "player";
	VUHDO_TT_PANEL_NUM = aPanelNum;
	VUHDO_TT_RESET = true;
	local tButton = VUHDO_getHealButton(1, aPanelNum);
	VUHDO_TT_BUTTON = (tButton ~= nil and tButton:IsShown()) and tButton or nil;
	VUHDO_updateTooltip();
end



--
function VUHDO_hideTooltip()
	if not VUHDO_IS_PANEL_CONFIG then
		if VUHDO_CONFIG["STANDARD_TOOLTIP"] then GameTooltip:Hide();
		else VuhDoTooltip:Hide();	end
	end
end


--
function VuhDoTooltipOnMouseDown(aTooltip)
	if VUHDO_IS_PANEL_CONFIG
		and VUHDO_PANEL_SETUP[DESIGN_MISC_PANEL_NUM]["TOOLTIP"]["position"] == VUHDO_TOOLTIP_POS_CUSTOM then

		aTooltip:StartMoving();
	end
end



--
function VuhDoTooltipOnMouseUp(aTooltip)
	aTooltip:StopMovingOrSizing();

	local tX, tY, tRelative, tOrientation;
	local tPosition = VUHDO_PANEL_SETUP[DESIGN_MISC_PANEL_NUM]["TOOLTIP"];
	local tOrientation, _, tRelative, tX, tY = aTooltip:GetPoint();

	tPosition["x"], tPosition["y"], tPosition["point"], tPosition["relativePoint"]
		= tX, tY, tOrientation, tRelative;

	VUHDO_initTooltipTimer();
end

