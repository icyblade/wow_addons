local _G = _G;
local pairs = pairs;
local format = format;
local CreateFrame = CreateFrame;
local _;

-- Fast caches
local VUHDO_BARS_PER_BUTTON = { };
local VUHDO_BUTTONS_PER_PANEL = { };
setmetatable(VUHDO_BUTTONS_PER_PANEL, VUHDO_META_NEW_ARRAY);
local VUHDO_BUFF_SWATCHES = { };
local VUHDO_BUFF_PANELS = { };
local VUHDO_HEALTH_BAR_TEXT = { };
local VUHDO_ACTION_PANELS = { };

local VUHDO_BAR_ICON_FRAMES = { };
local VUHDO_BAR_ICONS = { };
local VUHDO_BAR_ICON_TIMERS = { };
local VUHDO_BAR_ICON_COUNTERS = { };
local VUHDO_BAR_ICON_CLOCKS = { };
local VUHDO_BAR_ICON_CHARGES = { };
local VUHDO_BAR_ICON_NAMES = { };
local VUHDO_BAR_ICON_BUTTONS = { };


local VUHDO_STUB_COMPONENT = {
	["GetName"] = function() return "VuhDoDummyStub" end,
	["GetAttribute"] = function() return nil end,
	["SetAttribute"] = function() end,
  -- General
  ["SetAllPoints"] = function() end,
  ["SetAlpha"] = function(self, anAlpha) end,
  ["GetAlpha"] = function() return 1 end,
  ["Hide"] = function() end,
  ["IsVisible"] = function() return false end,
	-- Clock
  ["SetReverse"] = function() end,
  ["SetCooldown"] = function() end
};



VUHDO_BUTTON_CACHE = { };
local VUHDO_BUTTON_CACHE = VUHDO_BUTTON_CACHE;


--
function VUHDO_getBarRoleIcon(aButton, anIconNumber)
	return _G[format("%sBgBarIcBarHlBarIc%d", aButton:GetName(), anIconNumber)];
end



--
function VUHDO_getTargetBarRoleIcon(aButton, anIconNumber)
	return _G[format("%sBgBarHlBarIc%d", aButton:GetName(), anIconNumber)];
end



--
function VUHDO_getBarIconFrame(aButton, anIconNumber)
	return VUHDO_BAR_ICON_FRAMES[aButton][anIconNumber];
end



--
function VUHDO_getBarIcon(aButton, anIconNumber)
	return VUHDO_BAR_ICONS[aButton][anIconNumber];
end



--
function VUHDO_getOrCreateHotIcon(aButton, anIconNumber)
	if not VUHDO_BAR_ICONS[aButton][anIconNumber] then
		local tParentName = aButton:GetName() .. "BgBarIcBarHlBar";
		local tFrameName = tParentName .. "Ic" .. anIconNumber;
		VUHDO_BAR_ICON_FRAMES[aButton][anIconNumber] = CreateFrame("Button", tFrameName, _G[tParentName], "VuhDoHotIconTemplate");
		VUHDO_BAR_ICONS[aButton][anIconNumber] = _G[tFrameName .. "I"];
		VUHDO_BAR_ICON_TIMERS[aButton][anIconNumber] = _G[tFrameName .. "T"];
		VUHDO_BAR_ICON_COUNTERS[aButton][anIconNumber] = _G[tFrameName .. "C"];
		VUHDO_BAR_ICON_CHARGES[aButton][anIconNumber] = _G[tFrameName .. "A"];
	end

	return VUHDO_BAR_ICONS[aButton][anIconNumber];
end



--
function VUHDO_getOrCreateCuDeButton(aButton, anIconNumber)
	if not VUHDO_BAR_ICON_BUTTONS[aButton][anIconNumber] then
		local tParentName = aButton:GetName() .. "BgBarIcBarHlBar";
		local tFrameName = tParentName .. "Ic" .. anIconNumber;
		VUHDO_BAR_ICON_FRAMES[aButton][anIconNumber] = CreateFrame("Button", tFrameName, _G[tParentName], "VuhDoDebuffIconTemplate");
		VUHDO_BAR_ICON_BUTTONS[aButton][anIconNumber] = _G[tFrameName.. "B"];
		VUHDO_BAR_ICONS[aButton][anIconNumber] = _G[tFrameName .. "BI"];
		VUHDO_BAR_ICON_TIMERS[aButton][anIconNumber] = _G[tFrameName .. "BT"];
		VUHDO_BAR_ICON_COUNTERS[aButton][anIconNumber] = _G[tFrameName .. "BC"];
		VUHDO_BAR_ICON_CHARGES[aButton][anIconNumber] = _G[tFrameName .. "BA"];
		VUHDO_BAR_ICON_NAMES[aButton][anIconNumber] = _G[tFrameName .. "BN"];
	end

	return VUHDO_BAR_ICON_BUTTONS[aButton][anIconNumber];
end



--
function VUHDO_getBarIconTimer(aButton, anIconNumber)
	return VUHDO_BAR_ICON_TIMERS[aButton][anIconNumber];
end



--
function VUHDO_getBarIconCounter(aButton, anIconNumber)
	return VUHDO_BAR_ICON_COUNTERS[aButton][anIconNumber];
end



--
function VUHDO_getBarIconClockOrStub(aButton, anIconNumber, aCondition)
	return aCondition and VUHDO_BAR_ICON_CLOCKS[aButton][anIconNumber] or VUHDO_STUB_COMPONENT;
end


--
function VUHDO_getBarIconCharge(aButton, anIconNumber)
	return VUHDO_BAR_ICON_CHARGES[aButton][anIconNumber];
end



--
function VUHDO_getBarIconName(aButton, anIconNumber)
	return VUHDO_BAR_ICON_NAMES[aButton][anIconNumber];
end



--
function VUHDO_getBarIconButton(aButton, anIconNumber)
	return VUHDO_BAR_ICON_BUTTONS[aButton][anIconNumber];
end



--
function VUHDO_getRaidTargetTexture(aTargetBar)
	return _G[aTargetBar:GetName() .. "TgTxu"];
end



--
function VUHDO_getRaidTargetTextureFrame(aTargetBar)
	return _G[aTargetBar:GetName() .. "Tg"];
end



--
function VUHDO_getGroupOrderLabel2(aGroupOrderPanel)
	return _G[aGroupOrderPanel:GetName() .. "DrgLbl2Lbl"];
end



--
function VUHDO_getPanelNumLabel(aPanel)
	return _G[aPanel:GetName() .. "GrpLblLbl"];
end



--
function VUHDO_getGroupOrderPanel(aParentPanelNum, aPanelNum)
	return _G[format("Vd%dGrpOrd%d", aParentPanelNum, aPanelNum)];
end



--
function VUHDO_getGroupSelectPanel(aParentPanelNum, aPanelNum)
	return _G[format("Vd%dGrpSel%d", aParentPanelNum, aPanelNum)];
end



--
function VUHDO_getActionPanelOrStub(aPanelNum)
	return _G["Vd" .. aPanelNum] or VUHDO_STUB_COMPONENT;
end



--
function VUHDO_getActionPanel(aPanelNum)
	return _G["Vd" .. aPanelNum];
end



--
function VUHDO_getOrCreateActionPanel(aPanelNum)
	if not VUHDO_ACTION_PANELS[aPanelNum] then
		VUHDO_ACTION_PANELS[aPanelNum] = CreateFrame("Frame", format("Vd%d", aPanelNum), UIParent, "VuhDoHealPanelTemplate")
	end

	return VUHDO_ACTION_PANELS[aPanelNum];
end


function VUHDO_getAllActionPanels()
	return VUHDO_ACTION_PANELS;
end


--
function VUHDO_getHealthBar(aButton, aBarNumber)
	return VUHDO_BARS_PER_BUTTON[aButton][aBarNumber];
end



--
function VUHDO_getHealthBarText(aButton, aBarNumber)
	return VUHDO_HEALTH_BAR_TEXT[aButton][aBarNumber];
end



--
function VUHDO_getHeaderBar(aButton)
	return _G[aButton:GetName() .. "Bar"];
end



--
function VUHDO_getPlayerTargetFrame(aButton)
	return _G[VUHDO_BARS_PER_BUTTON[aButton][1]:GetName() .. "PlTg"];
end


--
function VUHDO_getPlayerTargetFrameTarget(aButton)
	return _G[aButton:GetName() .. "TgPlTg"];
end



--
function VUHDO_getPlayerTargetFrameToT(aButton)
	return _G[aButton:GetName() .. "TotPlTg"];
end



--
function VUHDO_getClusterBorderFrame(aButton)
	return _G[VUHDO_BARS_PER_BUTTON[aButton][1]:GetName() .. "Clu"];
end



--
function VUHDO_getTargetButton(aButton)
	return _G[aButton:GetName() .. "Tg"];
end



--
function VUHDO_getTotButton(aButton)
	return _G[aButton:GetName() .. "Tot"];
end



--
function VUHDO_getHealButton(aButtonNum, aPanelNum)
	return VUHDO_BUTTONS_PER_PANEL[aPanelNum][aButtonNum];
end



--
function VUHDO_getTextPanel(aBar)
	return _G[aBar:GetName() .. "TxPnl"];
end



--
function VUHDO_getBarText(aBar)
	return _G[aBar:GetName() .. "TxPnlUnN"];
end



--
function VUHDO_getHeaderTextId(aHeader)
	return _G[aHeader:GetName() .. "BarUnN"];
end



--
function VUHDO_getLifeText(aBar)
	return _G[aBar:GetName() .. "TxPnlLife"];
end



--
function VUHDO_getOverhealPanel(aBar)
	return _G[aBar:GetName() .. "OvhPnl"];
end



--
function VUHDO_getOverhealText(aBar)
	return _G[aBar:GetName() .. "OvhPnlT"];
end



--
function VUHDO_getHeader(aHeaderNo, aPanelNum)
	return _G[format("Vd%dHd%d", aPanelNum, aHeaderNo)];
end



--
local tHeaderName;
function VUHDO_getOrCreateHeader(aHeaderNo, aPanelNum)
	tHeaderName = format("Vd%dHd%d", aPanelNum, aHeaderNo);

	if not _G[tHeaderName] then
		CreateFrame("Button", tHeaderName, _G["Vd" .. aPanelNum], "VuhDoGroupHeaderTemplate");
	end
	return _G[tHeaderName];
end


--
local tButton;
function VUHDO_getOrCreateBuffSwatch(aName, aParent)

	if not VUHDO_BUFF_SWATCHES[aName] then
		VUHDO_BUFF_SWATCHES[aName] = CreateFrame("Frame", aName, aParent, "VuhDoBuffSwatchPanelTemplate");
		tButton = _G[aName .. "GlassButton"];
		tButton:SetAttribute("_onleave", "self:ClearBindings();");
		tButton:SetAttribute("_onshow", "self:ClearBindings();");
		tButton:SetAttribute("_onhide", "self:ClearBindings();");
	else
		tButton = _G[aName .. "GlassButton"];
	end

	if (VUHDO_BUFF_SETTINGS["CONFIG"]["WHEEL_SMART_BUFF"]) then
		tButton:SetAttribute("_onenter", [=[
				self:ClearBindings();
				self:SetBindingClick(0, "MOUSEWHEELUP" , "VuhDoSmartCastGlassButton", "LeftButton");
				self:SetBindingClick(0, "MOUSEWHEELDOWN" , "VuhDoSmartCastGlassButton", "LeftButton");
		]=]);
	else
		tButton:SetAttribute("_onenter", "self:ClearBindings();");
	end

	return VUHDO_BUFF_SWATCHES[aName];
end



--
function VUHDO_getOrCreateBuffPanel(aName)
	if not VUHDO_BUFF_PANELS[aName] then
		VUHDO_BUFF_PANELS[aName] = CreateFrame("Frame", aName, VuhDoBuffWatchMainFrame, "VuhDoBuffWatchBuffTemplate");
	end

	return VUHDO_BUFF_PANELS[aName];
end



--
function VUHDO_getOrCreateCooldown(aFrame, aButton, anIndex)
	if not VUHDO_BAR_ICON_CLOCKS[aButton][anIndex] then
		VUHDO_BAR_ICON_CLOCKS[aButton][anIndex] = CreateFrame("Cooldown", aFrame:GetName() .. "O", aFrame, "VuhDoHotCooldown");
	end

	return VUHDO_BAR_ICON_CLOCKS[aButton][anIndex];
end



--
function VUHDO_resetAllBuffPanels()
	for _, tPanel in pairs(VUHDO_BUFF_SWATCHES) do
		tPanel:Hide();
	end

	for _, tPanel in pairs(VUHDO_BUFF_PANELS) do
		tPanel:Hide();
	end
end



--
function VUHDO_getAllBuffSwatches()
	return VUHDO_BUFF_SWATCHES;
end



--
local function VUHDO_buffWatchSorter(aSwatch, anotherSwatch)
	return VUHDO_BUFF_ORDER[aSwatch:GetAttribute("buffname")]
		< VUHDO_BUFF_ORDER[anotherSwatch:GetAttribute("buffname")];
end



--
local tOrderedSwatches = { };
function VUHDO_getAllBuffSwatchesOrdered()
	table.wipe(tOrderedSwatches);

	for _, tSwatch in pairs(VUHDO_BUFF_SWATCHES) do
		tinsert(tOrderedSwatches, tSwatch);
	end

	table.sort(tOrderedSwatches, VUHDO_buffWatchSorter);
	return tOrderedSwatches;
end



--
function VUHDO_getAggroTexture(aHealthBar)
	return _G[aHealthBar:GetName() .. "Aggro"];
end



--
local VUHDO_STATUSBAR_LEFT_TO_RIGHT = 1;
local VUHDO_STATUSBAR_RIGHT_TO_LEFT = 2;
local VUHDO_STATUSBAR_BOTTOM_TO_TOP = 3;
local VUHDO_STATUSBAR_TOP_TO_BOTTOM = 4;
local tWidth;
local tHeight;
local tValue;

function VUHDO_refactorStatusbar(tBar)
	tBar["texture"] = tBar:CreateTexture(nil, "ARTWORK");
	tBar["txOrient"] = VUHDO_STATUSBAR_LEFT_TO_RIGHT;
	tBar["isInverted"] = false;



	tBar["SetStatusBarColor"] = function(self, r, g, b, a)
		self["texture"]:SetVertexColor(r, g, b, a);
	end



	tBar["SetVuhDoColor"] = function(self, aColor)
		self["texture"]:SetVertexColor(aColor["R"], aColor["G"], aColor["B"], aColor["O"]);
	end



	tBar["GetStatusBarColor"] = function(self)
		return self["texture"]:GetVertexColor();
	end



	tBar["SetAlpha"] = function(self, a)
		self["texture"]:SetAlpha(a);
	end



	tBar["SetValue"] = function(self, aValue)
		if (aValue or -1) < 0 then aValue = 0;
		elseif aValue > 1 then aValue = 1; end

		if self["isInverted"] then aValue = 1 - aValue; end

		if 1 == self["txOrient"] then -- VUHDO_STATUSBAR_LEFT_TO_RIGHT
			self["texture"]:SetTexCoord(0, aValue, 0, 1);
			self["texture"]:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", (aValue - 1) * self:GetWidth(), 0);

		elseif 2 == self["txOrient"] then -- VUHDO_STATUSBAR_RIGHT_TO_LEFT
			self["texture"]:SetTexCoord(1 - aValue, 1, 0, 1);
			self["texture"]:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", (1 - aValue) * self:GetWidth(), 0);

		elseif 3 == self["txOrient"] then -- VUHDO_STATUSBAR_BOTTOM_TO_TOP
			self["texture"]:SetTexCoord(0, 1, 1 - aValue, 1);
			self["texture"]:SetPoint("TOPLEFT", self, "TOPLEFT", 0, (aValue - 1) * self:GetHeight());

		else --if (VUHDO_STATUSBAR_TOP_TO_BOTTOM == self["txOrient"]) then
			self["texture"]:SetTexCoord(0, 1, 0, aValue);
			self["texture"]:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, (1 - aValue) * self:GetHeight());
		end
	end



	tBar["SetValueRange"] = function(self, aMinValue, aMaxValue)

		if (aMinValue or -1) < 0 then aMinValue = 0;
		elseif aMinValue > 1 then aMinValue = 1; end

		if (aMaxValue or -1) < 0 then aMaxValue = 0;
		elseif (aMaxValue > 1) then aMaxValue = 1; end

		tValue = aMaxValue - aMinValue;
		if tValue < 0 then tValue = 0; end

		if self["isInverted"] then
			tValue = 1 - tValue;
			aMinValue, aMaxValue = 1 - aMaxValue, 1 - aMinValue;
		end

		if 1 == self["txOrient"] then -- VUHDO_STATUSBAR_LEFT_TO_RIGHT
			tWidth = self:GetWidth();
			self["texture"]:SetTexCoord(0, tValue, 0, 1);
			self["texture"]:SetPoint("TOPLEFT", self, "TOPLEFT", aMinValue * tWidth, 0);
			self["texture"]:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", (aMaxValue - 1) * tWidth, 0);

		elseif 2 == self["txOrient"] then -- VUHDO_STATUSBAR_RIGHT_TO_LEFT
			tWidth = self:GetWidth();
			self["texture"]:SetTexCoord(1 - tValue, 1, 0, 1);
			self["texture"]:SetPoint("TOPRIGHT", self, "TOPRIGHT", -aMinValue * tWidth, 0);
			self["texture"]:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", (1 - aMaxValue) * tWidth, 0);

		elseif 3 == self["txOrient"] then -- VUHDO_STATUSBAR_BOTTOM_TO_TOP
			tHeight = self:GetHeight();
			self["texture"]:SetTexCoord(0, 1, 1 - tValue, 1);
			self["texture"]:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, aMinValue * tHeight);
			self["texture"]:SetPoint("TOPLEFT", self, "TOPLEFT", 0, (aMaxValue - 1) * tHeight);

		else --if (VUHDO_STATUSBAR_TOP_TO_BOTTOM == self["txOrient"]) then
			tHeight = self:GetHeight();
			self["texture"]:SetTexCoord(0, 1, 0, tValue);
			self["texture"]:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, -aMinValue * tHeight);
			self["texture"]:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, (1 - aMaxValue) * tHeight);
		end
	end



	tBar["SetStatusBarTexture"] = function(self, aTexture)
		self["texture"]:SetTexture(aTexture);
	end



	tBar["SetOrientation"] = function(self, anOrientation)
		self["texture"]:ClearAllPoints();

		if ("HORIZONTAL" == anOrientation) then
			self["texture"]:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0);
			self["txOrient"] = VUHDO_STATUSBAR_LEFT_TO_RIGHT;
		elseif ("HORIZONTAL_INV" == anOrientation) then
			self["texture"]:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0);
			self["txOrient"] = VUHDO_STATUSBAR_RIGHT_TO_LEFT;
		elseif ("VERTICAL" == anOrientation) then
			self["texture"]:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0);
			self["txOrient"] = VUHDO_STATUSBAR_BOTTOM_TO_TOP;
		else -- VERTICAL_INV
			self["texture"]:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0);
			self["txOrient"] = VUHDO_STATUSBAR_TOP_TO_BOTTOM;
		end
		self:SetValue(0); -- Wichtig, wenn Units nicht existieren und keine bouquets gecheckt werden
	end



	tBar["SetIsInverted"] = function(self, anIsInverted)
		self["isInverted"] = anIsInverted;
	end



	tBar["SetOrientation"](tBar, "HORIZONTAL");
	return tBar;
end



--
local function VUHDO_fastCacheInitButton(aPanelNum, aButtonNum)
	local tButtonName = format("Vd%dH%d", aPanelNum, aButtonNum);
	local tButton = _G[tButtonName];
	local tTargetButton = _G[tButtonName .. "Tg"];
	local tTotButton = _G[tButtonName .. "Tot"];

	VUHDO_BARS_PER_BUTTON[tButton] = { };
	VUHDO_BARS_PER_BUTTON[tTargetButton] = { };
	VUHDO_BARS_PER_BUTTON[tTotButton] = { };

	--Health
	VUHDO_BARS_PER_BUTTON[tButton][1] = _G[tButtonName .. "BgBarIcBarHlBar"];
	-- Mana
	VUHDO_BARS_PER_BUTTON[tButton][2] = _G[tButtonName .. "BgBarIcBarHlBarMaBar"];
	-- Background
	VUHDO_BARS_PER_BUTTON[tButton][3] = _G[tButtonName .. "BgBar"];
	-- Aggro
	VUHDO_BARS_PER_BUTTON[tButton][4] = _G[tButtonName .. "BgBarIcBarHlBarAgBar"];
	-- Target Health
	VUHDO_BARS_PER_BUTTON[tButton][5] = _G[tButtonName .. "TgBgBarHlBar"];
	VUHDO_BARS_PER_BUTTON[tTargetButton][1] = _G[tButtonName .. "TgBgBarHlBar"];
	-- Incoming
	VUHDO_BARS_PER_BUTTON[tButton][6] = _G[tButtonName .. "BgBarIcBar"];
	VUHDO_BARS_PER_BUTTON[tTargetButton][6] = VuhDoDummyStatusBar;
	VUHDO_BARS_PER_BUTTON[tTotButton][6] = VuhDoDummyStatusBar;
	-- Threat
	VUHDO_BARS_PER_BUTTON[tButton][7] = _G[tButtonName .. "ThBar"];
	-- Group Highlight
	VUHDO_BARS_PER_BUTTON[tButton][8] = _G[tButtonName .. "BgBarIcBarHlBarHiBar"];
	VUHDO_BARS_PER_BUTTON[tTargetButton][8] = VuhDoDummyStatusBar;
	VUHDO_BARS_PER_BUTTON[tTotButton][8] = VuhDoDummyStatusBar;
	-- HoT 1
	VUHDO_BARS_PER_BUTTON[tButton][9] = _G[tButtonName .. "BgBarIcBarHlBarHotBar1"];
	-- HoT 2
	VUHDO_BARS_PER_BUTTON[tButton][10] = _G[tButtonName .. "BgBarIcBarHlBarHotBar2"];
	-- HoT 3
	VUHDO_BARS_PER_BUTTON[tButton][11] = _G[tButtonName .. "BgBarIcBarHlBarHotBar3"];

	-- Target Background
	VUHDO_BARS_PER_BUTTON[tButton][12] = _G[tButtonName .. "TgBgBar"];
	VUHDO_BARS_PER_BUTTON[tTargetButton][3] = _G[tButtonName .. "TgBgBar"];
	-- Target Mana
	VUHDO_BARS_PER_BUTTON[tButton][13] = _G[tButtonName .. "TgBgBarHlBarMaBar"];
	VUHDO_BARS_PER_BUTTON[tTargetButton][2] = _G[tButtonName .. "TgBgBarHlBarMaBar"];

	-- Tot Health
	VUHDO_BARS_PER_BUTTON[tButton][14] = _G[tButtonName .. "TotBgBarHlBar"];
	VUHDO_BARS_PER_BUTTON[tTotButton][1] = _G[tButtonName .. "TotBgBarHlBar"];
	-- Tot Background
	VUHDO_BARS_PER_BUTTON[tButton][15] = _G[tButtonName .. "TotBgBar"];
	VUHDO_BARS_PER_BUTTON[tTotButton][3] = _G[tButtonName .. "TotBgBar"];
	-- Tot Mana
	VUHDO_BARS_PER_BUTTON[tButton][16] = _G[tButtonName .. "TotBgBarHlBarMaBar"];
	VUHDO_BARS_PER_BUTTON[tTotButton][2] = _G[tButtonName .. "TotBgBarHlBarMaBar"];
  -- Left side bar
	VUHDO_BARS_PER_BUTTON[tButton][17] = _G[tButtonName .. "BgBarIcBarHlBarLsBar"];
  -- Right side bar
	VUHDO_BARS_PER_BUTTON[tButton][18] = _G[tButtonName .. "BgBarIcBarHlBarRsBar"];
	-- Shield bar
	VUHDO_BARS_PER_BUTTON[tButton][19] = _G[tButtonName .. "BgBarShBar"];
	VUHDO_BARS_PER_BUTTON[tTargetButton][19] = VuhDoDummyStatusBar;
	VUHDO_BARS_PER_BUTTON[tTotButton][19] = VuhDoDummyStatusBar;


	VUHDO_HEALTH_BAR_TEXT[tButton] = { };
	for tIndex, tBar in pairs(VUHDO_BARS_PER_BUTTON[tButton]) do
		VUHDO_HEALTH_BAR_TEXT[tButton][tIndex] = _G[tBar:GetName() .. "LabelLabel"];
	end

	VUHDO_BUTTONS_PER_PANEL[aPanelNum][aButtonNum] = tButton;
	VUHDO_BUTTON_CACHE[tButton] = aPanelNum;
	VUHDO_BUTTON_CACHE[tTargetButton] = aPanelNum;
	VUHDO_BUTTON_CACHE[tTotButton] = aPanelNum;

	VUHDO_BAR_ICON_FRAMES[tButton] = { };
	VUHDO_BAR_ICON_BUTTONS[tButton] = { };
	VUHDO_BAR_ICONS[tButton] = { };
	VUHDO_BAR_ICON_TIMERS[tButton] = { };
	VUHDO_BAR_ICON_COUNTERS[tButton] = { };
	VUHDO_BAR_ICON_CLOCKS[tButton] = { };
	VUHDO_BAR_ICON_CHARGES[tButton] = { };
	VUHDO_BAR_ICON_NAMES[tButton] = { };
end



--
function VUHDO_getOrCreateHealButton(aButtonNum, aPanelNum)
	if not VUHDO_BUTTONS_PER_PANEL[aPanelNum][aButtonNum] then
		local tNewButton = CreateFrame("Button",
			format("Vd%dH%d", aPanelNum, aButtonNum),
			_G[format("Vd%d", aPanelNum)], "VuhDoButtonSecureTemplate");
		VUHDO_fastCacheInitButton(aPanelNum, aButtonNum);
		VUHDO_initLocalVars(aPanelNum);
		VUHDO_initHealButton(tNewButton, aPanelNum);
		VUHDO_positionHealButton(tNewButton);
		local tFunc = (VUHDO_CONFIG["HIDE_EMPTY_BUTTONS"] and not VUHDO_IS_PANEL_CONFIG and not VUHDO_isConfigDemoUsers())
			 and RegisterUnitWatch or UnregisterUnitWatch;
		tFunc(tNewButton);
	end

	return VUHDO_BUTTONS_PER_PANEL[aPanelNum][aButtonNum];
end



--
function VUHDO_getPanelButtons(aPanelNum)
	return VUHDO_BUTTONS_PER_PANEL[aPanelNum];
end
