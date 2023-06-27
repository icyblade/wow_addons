local table = table;
local floor = floor;
local select = select;
local strfind = strfind;
local twipe = table.wipe;
local pairs = pairs;
local _ = _;
local sIsSuspended = false;
local tEmptyColor = { };

local VUHDO_MY_AND_OTHERS_HOTS = { };
local VUHDO_MY_HOTS = { };
local VUHDO_OTHER_HOTS = { };
local VUHDO_BOUQUETS = { };
local VUHDO_RAID = { };
local VUHDO_CONFIG = { };
local VUHDO_BOUQUET_BUFFS_SPECIAL = { };
local VUHDO_CUSTOM_ICONS;
local VUHDO_CUSTOM_INFO;

local VUHDO_CUSTOM_BOUQUETS = {
	VUHDO_I18N_DEF_BOUQUET_TARGET_HEALTH,
};


----------------------------------------------------------



function VUHDO_bouquetsInitBurst()
	VUHDO_MY_AND_OTHERS_HOTS = VUHDO_GLOBAL["VUHDO_MY_AND_OTHERS_HOTS"];
	VUHDO_MY_HOTS = VUHDO_GLOBAL["VUHDO_MY_HOTS"];
	VUHDO_OTHER_HOTS = VUHDO_GLOBAL["VUHDO_OTHER_HOTS"];
	VUHDO_BOUQUETS = VUHDO_GLOBAL["VUHDO_BOUQUETS"];
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];
	VUHDO_CONFIG = VUHDO_GLOBAL["VUHDO_CONFIG"];
	VUHDO_CUSTOM_ICONS = VUHDO_GLOBAL["VUHDO_CUSTOM_ICONS"];
	VUHDO_BOUQUET_BUFFS_SPECIAL = VUHDO_GLOBAL["VUHDO_BOUQUET_BUFFS_SPECIAL"];
	VUHDO_CUSTOM_INFO = VUHDO_GLOBAL["VUHDO_CUSTOM_INFO"];
end

----------------------------------------------------------



--
local tHash;
local function VUHDO_getColorHash(aColor)
	tHash =
			(aColor["R"] or 0) * 0.0001
		+ (aColor["G"] or 0) * 0.001
		+ (aColor["B"] or 0) * 0.01
		+ (aColor["O"] or 0) * 0.1
		+ (aColor["TR"] or 0)
		+ (aColor["TG"] or 0) * 10
		+ (aColor["TB"] or 0) * 100
		+ (aColor["TO"] or 0) * 1000;

	if aColor["useText"] then
		tHash = tHash + 10000;
	end
	if aColor["useBackground"] then
		tHash = tHash + 20000;
	end
	if aColor["useOpacity"] then
		tHash = tHash + 40000;
	end

	return tHash;
end



--
local VUHDO_LAST_EVALUATED_BOUQUETS = { };
local tHasChanged, tCnt, tLastTime, tArg;
local function VUHDO_hasBouquetChanged(aUnit, aBouquetName, ...)
	if (VUHDO_LAST_EVALUATED_BOUQUETS[aBouquetName] == nil) then
		VUHDO_LAST_EVALUATED_BOUQUETS[aBouquetName] = { };
	end

	tLastTime = VUHDO_LAST_EVALUATED_BOUQUETS[aBouquetName][aUnit];
	if (tLastTime == nil) then
		VUHDO_LAST_EVALUATED_BOUQUETS[aBouquetName][aUnit] = { };
		return true;
	end

	tHasChanged = false;
	for tCnt = 1, 10 do
		tArg = select(tCnt, ...);

		if (tLastTime[tCnt] ~= tArg) then
			tHasChanged = true;
			tLastTime[tCnt] = tArg;
		end
	end

	return tHasChanged;
end



--
local tColor, tMode;
local tModi, tInvModi;
local tR1, tG1, tB1;
local tR2, tG2, tB2;
local tTR1, tTG1, tTB1, tO1;
local tTR2, tTG2, tTB2, tO2;
local tGood, tFair, tLow;
local tDestColor = { ["useBackground"] = true, ["useOpacity"] = true };
local tRadio;
local function VUHDO_getBouquetStatusBarColor(anEntry, anInfo, aValue, aMaxValue)
	tRadio = anEntry["custom"]["radio"];
	if (1 == tRadio) then -- solid
		return anEntry["color"];
	elseif (2 == tRadio) then -- class color
		tColor = VUHDO_USER_CLASS_COLORS[anInfo["classId"]] or anEntry["color"];
		tFactor = anEntry["custom"]["bright"];
		tDestColor["R"], tDestColor["G"], tDestColor["B"], tDestColor["O"]
			= tColor["R"] * tFactor, tColor["G"] * tFactor, tColor["B"] * tFactor, tColor["O"];
		return tDestColor;
	elseif (aMaxValue ~= 0) then -- 3 == gradient
		tModi = ((aValue / aMaxValue) ^ 1.7) * 2;
		tFair = anEntry["custom"]["grad_med"];
		if (tModi > 1) then
			tGood = anEntry["color"];
			tR1, tG1, tB1, tO1 = tGood["R"], tGood["G"], tGood["B"], tGood["O"];
			tR2, tG2, tB2, tO2 = tFair["R"], tFair["G"], tFair["B"], tFair["O"];
			tModi = tModi - 1;
		else
			tLow = anEntry["custom"]["grad_low"];
			tR1, tG1, tB1, tO1 = tFair["R"], tFair["G"], tFair["B"], tFair["O"];
			tR2, tG2, tB2, tO2 = tLow["R"], tLow["G"], tLow["B"], tLow["O"];
		end

		tInvModi = 1 - tModi;
		tDestColor["R"] = tR2 * tInvModi + tR1 * tModi;
		tDestColor["G"] = tG2 * tInvModi + tG1 * tModi;
		tDestColor["B"] = tB2 * tInvModi + tB1 * tModi;
		tDestColor["O"] = tO2 * tInvModi + tO1 * tModi;
		return tDestColor;
	else
		return anEntry["color"];
	end
end



-- For Buffs/Debuffs vertex color is white
local tDefaultBouquetColor = {
	["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
	["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
	["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
};



--
local txActive;
function VUHDO_getIsCurrentBouquetActive()
	return txActive;
end



--
local txColor;
function VUHDO_getCurrentBouquetColor()
	if (txColor == nil) then
		twipe(tEmptyColor);
		txColor = tEmptyColor;
	end
	return txColor;
end



--
local txCounter;
function VUHDO_getCurrentBouquetStacks()
	return txCounter;
end



--
local txTimer;
function VUHDO_getCurrentBouquetTimer()
	return txTimer;
end



--
local tBouquet;
local tInfos;
local tName;
local tSpecial;
local tIsActive;
local tIcon;
local tTimer;
local tCounter;
local tDuration;
local tBuffInfo;
local tHasChanged;
local tColor;
local tTimer2
local tClipL, tClipR, tClipT, tClipB;
local tType, tBuffTimer, tBuffDuration, tBuffIsActive;
local tCnt, tAnzInfos;
local tColor, tIcon;
local tEmpty = { };
local txIcon;
local txDuration;
local txName;
local txLevel;
local txTimer2;
local txClipL, txClipR, txClipT, txClipB;
local tDestColor = { };
local tFactor;
local tInfo, tUnit;
local tEmptyInfo = { };

local function VUHDO_evaluateBouquet(aUnit, aBouquetName, anInfo)

	if ((VUHDO_RAID[aUnit] or tEmptyInfo)["isVehicle"]) then
		tUnit = VUHDO_RAID[aUnit]["petUnit"];
	else
		tUnit = aUnit
	end
	tInfo = anInfo or VUHDO_RAID[tUnit];

	if (tInfo == nil) then
		tHasChanged = VUHDO_hasBouquetChanged(aUnit, aBouquetName, false, nil, nil, nil, nil, nil);
		return false, nil, nil, nil, nil, nil, nil, tHasChanged, 0;
	end

	txActive = false;
	txIcon, txColor, txName = nil, nil, nil;
	txCounter, txTimer, txDuration, txTimer2, txLevel = 0, 0, 0, 0, 0;

	tBouquet = VUHDO_BOUQUETS["STORED"][aBouquetName];
	tAnzInfos = #tBouquet;

	for tCnt = tAnzInfos, 1, -1  do
		tInfos = tBouquet[tCnt];
		tSpecial = VUHDO_BOUQUET_BUFFS_SPECIAL[tInfos["name"]];
		if (tSpecial ~= nil) then
			tName = nil;
			tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tTimer2, tClipL, tClipR, tClipT, tClipB = tSpecial["validator"](tInfo, tInfos);

			if (tIsActive) then
				if (tInfos["icon"] ~= 1) then
					tIcon = VUHDO_CUSTOM_ICONS[tInfos["icon"]][2];
				end

				if (tColor == nil) then
					if (3 == tSpecial["custom_type"]) then -- VUHDO_BOUQUET_CUSTOM_TYPE_STATUSBAR
						tColor = VUHDO_getBouquetStatusBarColor(tInfos, tInfo, tTimer, tDuration);
					else
						tColor = tInfos["color"];
					end
				elseif (4 == tSpecial["custom_type"]) then -- VUHDO_BOUQUET_CUSTOM_TYPE_BRIGHTNESS
					tFactor = tInfos["custom"]["bright"];
					if (tColor["useBackground"]) then
						tColor["R"], tColor["G"], tColor["B"] = tColor["R"] * tFactor, tColor["G"] * tFactor, tColor["B"] * tFactor;
					end
					if (tColor["useText"]) then
						tColor["TR"], tColor["TG"], tColor["TB"] = tColor["TR"] * tFactor, tColor["TG"] * tFactor, tColor["TB"] * tFactor;
					end
				end

				if (tColor["useText"]) then
					tColor["useText"] = tInfos["color"]["useText"];
				end
				if (tColor["useBackground"]) then
					tColor["useBackground"] = tInfos["color"]["useBackground"];
				end
				if (tColor["useOpacity"]) then
					tColor["useOpacity"] = tInfos["color"]["useOpacity"];
				end
			end
		else -- Buff/Debuff
			tName = tInfos["name"];
			if (tInfos["mine"] and tInfos["others"]) then
				tBuffInfo = (VUHDO_MY_AND_OTHERS_HOTS[tUnit] or tEmpty)[tName];
			elseif (tInfos["mine"]) then
				tBuffInfo = (VUHDO_MY_HOTS[tUnit] or tEmpty)[tName];
			elseif (tInfos["others"]) then
				tBuffInfo = (VUHDO_OTHER_HOTS[tUnit] or tEmpty)[tName];
			else
				tBuffInfo = nil;
			end
			tIsActive = tBuffInfo ~= nil;
			if (tIsActive) then
				if (tInfos["alive"]) then
					tIcon, tTimer, tCounter, tDuration = tBuffInfo[3], tBuffInfo[5], tBuffInfo[2], tBuffInfo[4];
				else
					tIcon, tTimer, tCounter, tDuration = tBuffInfo[3], tBuffInfo[1], tBuffInfo[2], tBuffInfo[4];
				end
				if (tTimer ~= nil) then
					tTimer = floor(tTimer * 10) * 0.1;
				end
				tColor = tInfos["color"];
				if (tInfos["icon"] ~= 1) then
					tIcon = VUHDO_CUSTOM_ICONS[tInfos["icon"]][2];
				else
					tColor["isDefault"] = true;
				end
			end
			tTimer2, tClipL, tClipR, tClipT, tClipB = nil, nil, nil, nil, nil;
		end

		if (tIsActive) then
			txActive = true;
			txName = tName;
			txLevel = tCnt;
			-- Icon
			if (tInfos["icon"] ~= 1) then
				tIcon = VUHDO_CUSTOM_ICONS[tInfos["icon"]][2];
				txClipL, txClipR, txClipT, txClipB = nil, nil, nil, nil;
			elseif (tIcon ~= nil) then
				txClipL, txClipR, txClipT, txClipB = tClipL, tClipR, tClipT, tClipB;
			end

			if (tIcon ~= nil) then
				txIcon = tIcon;
			end
			-- Color
			if (tColor ~= nil) then
				if (txColor == nil) then
					twipe(tEmptyColor);
					txColor = tEmptyColor;
				end
				if (tColor["useText"]) then
					txColor["useText"] = true;
					txColor["TR"], txColor["TG"], txColor["TB"], txColor["TO"]
						= tColor["TR"], tColor["TG"], tColor["TB"], tColor["TO"];
				end

				if (tColor["useBackground"]) then
					txColor["useBackground"] = true;
					txColor["R"], txColor["G"], txColor["B"], txColor["O"]
						= tColor["R"], tColor["G"], tColor["B"], tColor["O"];
				end

				if (tColor["useOpacity"]) then
					txColor["useOpacity"] = true;
					if (tColor["TO"] ~= nil) then
						txColor["TO"]	= (txColor["TO"] or 1) * tColor["TO"];
					end
					if (tColor["O"] ~= nil) then
						txColor["O"] = (txColor["O"] or 1) * tColor["O"];
					end
				end

				txColor["isDefault"] = tColor["isDefault"];
			else
				txColor = nil;
			end
			-- Stacks
			tCounter = tCounter or 0;
			if (tCounter >= 0) then
				txCounter = tCounter;
			end
			tTimer = tTimer or 0;
			tTimer2 = tTimer2 or 0;
			tDuration = tDuration or 0;
			if (tDuration >= 0) then
				if (tTimer >= 0) then
					txTimer, txDuration = tTimer, tDuration;
				end
				if (tTimer2 >= 0) then
					txTimer2 = tTimer2;
				end
			end
		end
	end

	if (txActive) then
		if (txColor == nil) then
			txColor = tDefaultBouquetColor;
		elseif (not txColor["useOpacity"]) then
			txColor["TO"], txColor["O"] = 1, 1;
		end

		tHasChanged = VUHDO_hasBouquetChanged(aUnit, aBouquetName, true, txIcon, txTimer, txCounter, txDuration, VUHDO_getColorHash(txColor), txClipL, txClipR, txClipT, txClipB);
		return true, txIcon, txTimer, txCounter, txDuration, txColor, txName, tHasChanged, tAnzInfos - txLevel, txTimer2, txClipL, txClipR, txClipT, txClipB;
	else
		tHasChanged = VUHDO_hasBouquetChanged(aUnit, aBouquetName, false, nil, nil, nil, nil, nil, nil, nil, nil, nil);
		return false, nil, nil, nil, nil, nil, nil, tHasChanged, tAnzInfos - txLevel, txTimer2, nil, nil, nil, nil;
	end

end



local VUHDO_REGISTERED_BOUQUETS = { };
local VUHDO_ACTIVE_BOUQUETS = { };



--
local function VUHDO_unregisterAllBouquetListeners()
	twipe(VUHDO_REGISTERED_BOUQUETS);
end



--
local tBouquet;
local tInfos;
local tName;
local function VUHDO_activateBuffsInScanner(aBouquetName)
	tBouquet = VUHDO_BOUQUETS["STORED"][aBouquetName];

	for _, tInfos in pairs(tBouquet) do
		tName = tInfos["name"];
		if (not VUHDO_BOUQUET_BUFFS_SPECIAL[tName]) then
			VUHDO_ACTIVE_HOTS[tName] = true;

			if (tInfos["others"]) then
				VUHDO_ACTIVE_HOTS_OTHERS[tName] = true;
			end
		end
	end
end



--
local tUnit;
local function VUHDO_registerForBouquet(aBouquetName, anOwnerName, aFunction)
	if ((aBouquetName or "") == "") then
		return;
	end

	if (VUHDO_BOUQUETS["STORED"][aBouquetName] == nil) then
		VUHDO_Msg(format(VUHDO_I18N_ERR_NO_BOUQUET, anOwnerName, aBouquetName), 1, 0.4, 0.4);
		return;
	end

	VUHDO_BOUQUETS["STORED"][aBouquetName] = VUHDO_decompressIfCompressed(VUHDO_BOUQUETS["STORED"][aBouquetName]);

	if (VUHDO_REGISTERED_BOUQUETS[aBouquetName] == nil) then
		VUHDO_REGISTERED_BOUQUETS[aBouquetName] = { };
	end
	VUHDO_REGISTERED_BOUQUETS[aBouquetName][anOwnerName] = aFunction;
	VUHDO_activateBuffsInScanner(aBouquetName);

	for tUnit, _ in pairs(VUHDO_RAID) do
		aFunction(tUnit, false, nil, 0, 0, 0, nil, nil, nil);
	end

end



--
local tCnt, tHotName, tHotSlots, tIndex, tBouquetName;
local tAlreadyRegistered = { };
function VUHDO_registerAllBouquets(aDoCompress)
	VUHDO_unregisterAllBouquetListeners();

	if (VUHDO_BOUQUETS["STORED"] == nil) then
		return;
	end

	if (aDoCompress) then
		VUHDO_compressAllBouquets();
	end

	-- Hot Icons+Bars
	tHotSlots = VUHDO_PANEL_SETUP["HOTS"]["SLOTS"];

	for tIndex, tHotName in pairs(tHotSlots) do
		if (tHotName ~= nil and "BOUQUET_" == strsub(tHotName, 1, 8)) then
			VUHDO_registerForBouquet(strsub(tHotName, 9), "HoT " .. tIndex, VUHDO_hotBouquetCallback);
		end
	end

	-- Bar (=Outer) Border
	VUHDO_registerForBouquet(VUHDO_INDICATOR_CONFIG["BOUQUETS"]["BAR_BORDER"], "Outer Border", VUHDO_barBorderBouquetCallback);
	-- Cluster (=Inner) Border
	VUHDO_registerForBouquet(VUHDO_INDICATOR_CONFIG["BOUQUETS"]["CLUSTER_BORDER"], "Inner Border", VUHDO_clusterBorderBouquetCallback);
	-- Swiftmend Indicator
	VUHDO_registerForBouquet(VUHDO_INDICATOR_CONFIG["BOUQUETS"]["SWIFTMEND_INDICATOR"], "Special Dot", VUHDO_swiftmendIndicatorBouquetCallback);
	-- Aggro Line
	VUHDO_registerForBouquet(VUHDO_INDICATOR_CONFIG["BOUQUETS"]["AGGRO_BAR"], "Aggro Bar", VUHDO_aggroBarBouquetCallback);
	-- Mouseover Highlighter
	VUHDO_registerForBouquet(VUHDO_INDICATOR_CONFIG["BOUQUETS"]["MOUSEOVER_HIGHLIGHT"], "Mouseover Highlight", VUHDO_highlighterBouquetCallback);
	-- Threat Marks
	VUHDO_registerForBouquet(VUHDO_INDICATOR_CONFIG["BOUQUETS"]["THREAT_MARK"], "Threat Indicators", VUHDO_threatIndicatorsBouquetCallback);
	-- Threat Bar
	VUHDO_registerForBouquet(VUHDO_INDICATOR_CONFIG["BOUQUETS"]["THREAT_BAR"], "Threat Bar", VUHDO_threatBarBouquetCallback);
	-- Mana Bar
	VUHDO_registerForBouquet(VUHDO_INDICATOR_CONFIG["BOUQUETS"]["MANA_BAR"], "Mana Bar", VUHDO_manaBarBouquetCallback);
	-- Background Bar
	VUHDO_registerForBouquet(VUHDO_INDICATOR_CONFIG["BOUQUETS"]["BACKGROUND_BAR"], "Background Bar", VUHDO_backgroundBarBouquetCallback);
	-- Health Bar
	VUHDO_registerForBouquet(VUHDO_INDICATOR_CONFIG["BOUQUETS"]["HEALTH_BAR"], "Health Bar", VUHDO_healthBarBouquetCallback);
	-- Side bar left
	VUHDO_registerForBouquet(VUHDO_INDICATOR_CONFIG["BOUQUETS"]["SIDE_LEFT"], "Side Bar Left", VUHDO_sideBarLeftBouquetCallback);
	-- Side bar right
	VUHDO_registerForBouquet(VUHDO_INDICATOR_CONFIG["BOUQUETS"]["SIDE_RIGHT"], "Side Bar Right", VUHDO_sideBarRightBouquetCallback);
	-- Per panel Health Bars
	twipe(tAlreadyRegistered);
	for tCnt = 1, VUHDO_MAX_PANELS do
		tBouquetName = VUHDO_INDICATOR_CONFIG["BOUQUETS"]["HEALTH_BAR_PANEL"][tCnt];
		if (VUHDO_PANEL_MODELS[tCnt] ~= nil and tBouquetName ~= ""	and not tAlreadyRegistered[tBouquetName]) then
			VUHDO_registerForBouquet(tBouquetName, "Health Bar " .. tCnt, VUHDO_healthBarBouquetCallbackCustom);
			tAlreadyRegistered[tBouquetName] = true;
		end
	end

	for _, tBouquetName in pairs(VUHDO_CUSTOM_BOUQUETS) do
		VUHDO_BOUQUETS["STORED"][tBouquetName] = VUHDO_decompressIfCompressed(VUHDO_BOUQUETS["STORED"][tBouquetName]);
	end

	VUHDO_updateGlobalToggles();
	VUHDO_initAllEventBouquets();
end



--
local VUHDO_EVENT_BOUQUETS = { };
local tItem, tName, tInterest;
local function VUHDO_isBouquetInterestedInEvent(aBouquetName, anEventType)
	if (VUHDO_EVENT_BOUQUETS[aBouquetName] == nil) then
		VUHDO_EVENT_BOUQUETS[aBouquetName] = { };
	end

	if (VUHDO_EVENT_BOUQUETS[aBouquetName][anEventType] == nil) then
		VUHDO_EVENT_BOUQUETS[aBouquetName][anEventType] = 0;

		for _, tItem in pairs(VUHDO_BOUQUETS["STORED"][aBouquetName]) do
			tName = tItem["name"];
			if (VUHDO_BOUQUET_BUFFS_SPECIAL[tName] ~= nil) then

				for _, tInterest in pairs(VUHDO_BOUQUET_BUFFS_SPECIAL[tName]["interests"]) do
					if (tInterest == anEventType) then
						VUHDO_EVENT_BOUQUETS[aBouquetName][anEventType] = 1;
						break;
					end
				end

			end
		end
	end

	return 1 == VUHDO_EVENT_BOUQUETS[aBouquetName][anEventType] or 1 == anEventType; -- VUHDO_UPDATE_ALL
end



--
local tAllListeners;
local tOwner, tDelegate;
local tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, tHasChanged, tImpact, tTimer2;
local tClipL, tClipR, tClipT, tClipB;
local function VUHDO_updateEventBouquet(aUnit, aBouquetName)

	tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName,
		tHasChanged, tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB
		= VUHDO_evaluateBouquet(aUnit, aBouquetName, nil);

	if (not tHasChanged) then
		return;
	end

	if (VUHDO_ACTIVE_BOUQUETS[aUnit] == nil) then
		VUHDO_ACTIVE_BOUQUETS[aUnit] = { };
	end

	if (tIsActive) then
		tAllListeners = VUHDO_REGISTERED_BOUQUETS[aBouquetName];
		for tOwner, tDelegate in pairs(tAllListeners) do
			tDelegate(aUnit, tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, aBouquetName,
				tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB);
		end
		VUHDO_ACTIVE_BOUQUETS[aUnit][aBouquetName] = true;
	else
		if (VUHDO_ACTIVE_BOUQUETS[aUnit][aBouquetName]) then
			tAllListeners = VUHDO_REGISTERED_BOUQUETS[aBouquetName];
			for tOwner, tDelegate in pairs(tAllListeners) do
				tDelegate(aUnit, tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, aBouquetName,
					tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB);
			end
			VUHDO_ACTIVE_BOUQUETS[aUnit][aBouquetName] = false;
		end
	end
end



--
local tOwner;
local tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, _, tImpact, tTimer2;
local tClipL, tClipR, tClipT, tClipB;
function VUHDO_invokeCustomBouquet(aButton, aUnit, anInfo, aBouquetName, aDelegate)
	tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName,
		_, tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB
		= VUHDO_evaluateBouquet(aUnit, aBouquetName, anInfo);

	-- Do not check "hasChanged" because this is button-wise
	if (VUHDO_ACTIVE_BOUQUETS[aUnit] == nil) then
		VUHDO_ACTIVE_BOUQUETS[aUnit] = { };
	end

	if (tIsActive) then
		aDelegate(aButton, aUnit, tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, aBouquetName,
			tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB);
		VUHDO_ACTIVE_BOUQUETS[aUnit][aBouquetName] = true;
	else
		if (VUHDO_ACTIVE_BOUQUETS[aUnit][aBouquetName]) then
			aDelegate(aButton, aUnit, tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, aBouquetName,
				tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB);
			VUHDO_ACTIVE_BOUQUETS[aUnit][aBouquetName] = false;
		end
	end
end



--
local tName;
local function VUHDO_isAnyBouquetInterstedIn(anUpdateMode)
	for tName, _ in pairs(VUHDO_REGISTERED_BOUQUETS) do
		if (VUHDO_isBouquetInterestedInEvent(tName, anUpdateMode)) then
			return true;
		end
	end

	return false;
end



--
local tInfo;
local tAllListeners;
local tOwner, tDelegate;
local tName;
function VUHDO_updateBouquetsForEvent(aUnit, anEventType)
	tInfo = VUHDO_RAID[aUnit];

	for tName, _ in pairs(VUHDO_REGISTERED_BOUQUETS) do
		if (VUHDO_isBouquetInterestedInEvent(tName, anEventType)) then
			if (tInfo ~= nil) then
				VUHDO_updateEventBouquet(aUnit, tName);
			elseif (aUnit ~= nil) then -- focus / n/a
				tAllListeners = VUHDO_REGISTERED_BOUQUETS[tName];
				for tOwner, tDelegate in pairs(tAllListeners) do
					tDelegate(aUnit, true, nil, 100, 0, 100, VUHDO_PANEL_SETUP["BAR_COLORS"]["OFFLINE"], nil, nil, 0);
				end
			end
		end
	end
end
local VUHDO_updateBouquetsForEvent = VUHDO_updateBouquetsForEvent;



-- Bei Panel-Redraw aufzurufen
local tUnit;
function VUHDO_initAllEventBouquets()
	twipe(VUHDO_LAST_EVALUATED_BOUQUETS);
	for tUnit, _ in pairs(VUHDO_RAID) do
		VUHDO_updateBouquetsForEvent(tUnit, 1); -- VUHDO_UPDATE_ALL
	end

	VUHDO_updateBouquetsForEvent("focus", 19); -- VUHDO_UPDATE_DC
	VUHDO_updateBouquetsForEvent("target", 19); -- VUHDO_UPDATE_DC
end



--
local VUHDO_CYCLIC_BOUQUETS = { };
local tItem, tName;
local function VUHDO_hasCyclic(aBouquetName)
	if (VUHDO_CYCLIC_BOUQUETS[aBouquetName] == nil) then
		VUHDO_CYCLIC_BOUQUETS[aBouquetName] = 0;

		for _, tItem in pairs(VUHDO_BOUQUETS["STORED"][aBouquetName]) do
			tName = tItem["name"];
			if (VUHDO_BOUQUET_BUFFS_SPECIAL[tName] == nil or VUHDO_BOUQUET_BUFFS_SPECIAL[tName]["updateCyclic"]) then
				VUHDO_CYCLIC_BOUQUETS[aBouquetName] = 1;
				break;
			end
		end

	end

	return VUHDO_CYCLIC_BOUQUETS[aBouquetName] == 1;
end



--
local tAllListeners, tUnit, tOwner, tDelegate;
local tIsActive, tIcon, tTimer, tCounter, tDuration, tBuffName, tInfo, tHasChanged, tImpact;
local tClipL, tClipR, tClipT, tClipB;
local function VUHDO_updateCyclicBouquet(aBouquetName, aUnit)
	tAllListeners = VUHDO_REGISTERED_BOUQUETS[aBouquetName];

	if (aUnit == nil) then
		for tUnit, tInfo in pairs(VUHDO_RAID) do
			if (VUHDO_ACTIVE_BOUQUETS[tUnit] == nil) then
				VUHDO_ACTIVE_BOUQUETS[tUnit] = { };
			end

			tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, tHasChanged,
				tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB = VUHDO_evaluateBouquet(tUnit, aBouquetName, nil);

			if (tHasChanged) then

				if (tIsActive) then
					for tOwner, tDelegate in pairs(tAllListeners) do
						tDelegate(tUnit, tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, aBouquetName,
							tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB);
					end
					VUHDO_ACTIVE_BOUQUETS[tUnit][aBouquetName] = true;
				else
					if (VUHDO_ACTIVE_BOUQUETS[tUnit][aBouquetName]) then
						for tOwner, tDelegate in pairs(tAllListeners) do
							tDelegate(tUnit, tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, aBouquetName,
								tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB);
						end
						VUHDO_ACTIVE_BOUQUETS[tUnit][aBouquetName] = nil;
					end
				end
			end
		end
	else

		if (VUHDO_ACTIVE_BOUQUETS[aUnit] == nil) then
			VUHDO_ACTIVE_BOUQUETS[aUnit] = { };
		end

		tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, tHasChanged,
			tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB = VUHDO_evaluateBouquet(aUnit, aBouquetName, nil);

		if (tHasChanged) then

			if (tIsActive) then
				for tOwner, tDelegate in pairs(tAllListeners) do
					tDelegate(aUnit, tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, aBouquetName,
						tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB);
				end
				VUHDO_ACTIVE_BOUQUETS[aUnit][aBouquetName] = true;
			else
				if (VUHDO_ACTIVE_BOUQUETS[aUnit][aBouquetName]) then
					for tOwner, tDelegate in pairs(tAllListeners) do
						tDelegate(aUnit, tIsActive, tIcon, tTimer, tCounter, tDuration, tColor, tBuffName, aBouquetName,
							tImpact, tTimer2, tClipL, tClipR, tClipT, tClipB);
					end
					VUHDO_ACTIVE_BOUQUETS[aUnit][aBouquetName] = nil;
				end
			end
		end
	end
end



--
local tName;
function VUHDO_updateAllCyclicBouquets(aUnit)
	for tName, _ in pairs(VUHDO_REGISTERED_BOUQUETS) do
		if (VUHDO_hasCyclic(tName)) then
			VUHDO_updateCyclicBouquet(tName, aUnit);
		end
	end
end



--
function VUHDO_bouqetsChanged()
	twipe(VUHDO_EVENT_BOUQUETS);
	twipe(VUHDO_CYCLIC_BOUQUETS);
	twipe(VUHDO_LAST_EVALUATED_BOUQUETS);
	VUHDO_initFromSpellbook();
	VUHDO_registerAllBouquets(false);
	VUHDO_resetHotBuffCache();
end



--
local tSlotNum;
local function VUHDO_isInAnyHotSlot(aHotName)
	for tSlotNum = 1, 10 do
		if (VUHDO_PANEL_SETUP["HOTS"]["SLOTS"][tSlotNum] == aHotName) then
			return true;
		end
	end

	return false;
end



--
local tCnt;
function VUHDO_isAnyoneInterstedIn(anUpdateMode)

	if (VUHDO_isAnyBouquetInterstedIn(anUpdateMode)) then
		return true;
	else
		if (5 == anUpdateMode) then -- VUHDO_UPDATE_RANGE
			return true;
		elseif (7 == anUpdateMode) then -- VUHDO_UPDATE_AGGRO
			return VUHDO_CONFIG["THREAT"]["AGGRO_USE_TEXT"];
		elseif (16 == anUpdateMode) then -- VUHDO_UPDATE_NUM_CLUSTER
			return VUHDO_isInAnyHotSlot("CLUSTER");
		elseif (22 == anUpdateMode) then -- VUHDO_UPDATE_UNIT_TARGET
			for tCnt = 1, 10 do -- VUHDO_MAX_PANELS
				if (VUHDO_PANEL_MODELS[tCnt] ~= nil) then
					if (VUHDO_PANEL_SETUP[tCnt]["SCALING"]["showTarget"] or VUHDO_PANEL_SETUP[tCnt]["SCALING"]["showTot"]) then
						return true;
					end
				end
			end
		end

		return false;
	end
end
