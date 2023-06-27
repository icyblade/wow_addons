local VUHDO_CUSTOM_DEBUFF_LIST = { };
local VUHDO_UNIT_CUSTOM_DEBUFFS = { };
local VUHDO_LAST_UNIT_DEBUFFS = { };
local VUHDO_CHOSEN_DEBUFF_INFO = { };
local VUHDO_DEBUFF_ABILITIES = { };
local VUHDO_UNIT_DEBUFF_SCHOOLS = { };
local VUHDO_PLAYER_ABILITIES = { };



local VUHDO_IGNORE_DEBUFFS_BY_CLASS = { };
local VUHDO_IGNORE_DEBUFF_NAMES = { };



--
local VUHDO_DEBUFF_TYPES = {
	["Magic"] = VUHDO_DEBUFF_TYPE_MAGIC,
	["Disease"] = VUHDO_DEBUFF_TYPE_DISEASE,
	["Poison"] = VUHDO_DEBUFF_TYPE_POISON,
	["Curse"] = VUHDO_DEBUFF_TYPE_CURSE
};




VUHDO_DEBUFF_BLACKLIST = {
	[GetSpellInfo(69127)] = true, -- Chill of the Throne (st„ndiger debuff)
	[GetSpellInfo(57724)] = true, -- Sated
	[GetSpellInfo(71328)] = true  -- Dungeon Cooldown
}



local VUHDO_CUSTOM_BUFF_BLACKLIST = {
	[GetSpellInfo(67847)] = true -- Expose Weakness ist ein Boss-Debuff und gleichzeitig ein Jäger-Buff
}



local VUHDO_INIT_UNIT_DEBUFF_SCHOOLS = {
	[VUHDO_DEBUFF_TYPE_POISON] = { },
	[VUHDO_DEBUFF_TYPE_DISEASE] = { },
	[VUHDO_DEBUFF_TYPE_MAGIC] = { },
	[VUHDO_DEBUFF_TYPE_CURSE] = { },
};


-- BURST CACHE ---------------------------------------------------

local VUHDO_CONFIG;
local VUHDO_RAID;
local VUHDO_PANEL_SETUP;
local VUHDO_DEBUFF_COLORS = { };

local VUHDO_shouldScanUnit;
local VUHDO_DEBUFF_BLACKLIST = { };

local UnitDebuff = UnitDebuff;
local UnitBuff = UnitBuff;
local table = table;
local GetTime = GetTime;
local PlaySoundFile = PlaySoundFile;
local InCombatLockdown = InCombatLockdown;
local twipe = table.wipe;
local pairs = pairs;
local _;
local tostring = tostring;

local sIsRemoveableOnly;
local sIsUseDebuffIcon;
local sIsUseDebuffIconBossOnly;
local sIsMiBuColorsInFight;
local sStdDebuffSound;

function VUHDO_debuffsInitBurst()
	VUHDO_CONFIG = VUHDO_GLOBAL["VUHDO_CONFIG"];
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];
	VUHDO_PANEL_SETUP = VUHDO_GLOBAL["VUHDO_PANEL_SETUP"];
	VUHDO_DEBUFF_BLACKLIST = VUHDO_GLOBAL["VUHDO_DEBUFF_BLACKLIST"];

	VUHDO_shouldScanUnit = VUHDO_GLOBAL["VUHDO_shouldScanUnit"];

	sIsRemoveableOnly = VUHDO_CONFIG["DETECT_DEBUFFS_REMOVABLE_ONLY"];
	sIsUseDebuffIcon = VUHDO_PANEL_SETUP["BAR_COLORS"]["useDebuffIcon"];
	sIsUseDebuffIconBossOnly = VUHDO_PANEL_SETUP["BAR_COLORS"]["useDebuffIconBossOnly"];
	sIsMiBuColorsInFight = VUHDO_BUFF_SETTINGS["CONFIG"]["BAR_COLORS_IN_FIGHT"];
	sStdDebuffSound = VUHDO_CONFIG["SOUND_DEBUFF"];
	sAllDebuffSettings = VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"];
	VUHDO_DEBUFF_COLORS = {
		[1] = VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF1"],
		[2] = VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF2"],
		[3] = VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF3"],
		[4] = VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF4"],
		[6] = VUHDO_PANEL_SETUP["BAR_COLORS"]["DEBUFF6"],
	};
end

----------------------------------------------------



--
local tEmptyChosen = { nil, 0, 0, 0 };
function VUHDO_getChosenDebuffInfo(aUnit)
	return VUHDO_CHOSEN_DEBUFF_INFO[aUnit] or tEmptyChosen;
end



--
local tIdx = 0;
local tCopies = { };
local tIsRevolvInit = true;
local function VUHDO_copyColorRevolving()
	if (tIdx > 39) then
		tIdx = 1;
		tIsRevolvInit = false;
	else
		tIdx = tIdx + 1;
	end

	if (tIsRevolvInit) then
		tCopies[tIdx] = { };
	else
		twipe(tCopies[tIdx]);
	end

	return tCopies[tIdx];
end



--
local function VUHDO_formColor(aColor)
	if (aColor["useText"]) then
		aColor["TR"], aColor["TG"], aColor["TB"] = aColor["TR"] or 0, aColor["TG"] or 0, aColor["TB"] or 0;
	end
	if (aColor["useBackground"]) then
		aColor["R"], aColor["G"], aColor["B"] = aColor["R"] or 0, aColor["G"] or 0, aColor["B"] or 0;
	end

	aColor["TO"], aColor["O"] = aColor["TO"] or 1, aColor["O"] or 1;
	return aColor;
end



--
local function VUHDO_copyColorTo(aSource, aDest)
	aDest["R"], aDest["G"], aDest["B"] = aSource["R"], aSource["G"], aSource["B"];
	aDest["TR"], aDest["TG"], aDest["TB"] = aSource["TR"], aSource["TG"], aSource["TB"];
	aDest["O"], aDest["TO"] = aSource["O"], aSource["TO"];
	aDest["useText"], aDest["useBackground"], aDest["useOpacity"] = aSource["useText"], aSource["useBackground"], aSource["useOpacity"];
	return aDest;
end



--
local tSourceColor;
local tDebuffSettings;
local tDebuff;
local function _VUHDO_getDebuffColor(anInfo, aNewColor)
	tDebuff = anInfo["debuff"];

	if (anInfo["charmed"]) then
		return VUHDO_copyColorTo(VUHDO_PANEL_SETUP["BAR_COLORS"]["CHARMED"], aNewColor);
	elseif (anInfo["mibucateg"] == nil and (tDebuff or 0) == 0) then -- VUHDO_DEBUFF_TYPE_NONE
		return aNewColor;
	end

	tDebuffSettings = sAllDebuffSettings[anInfo["debuffName"]];

	if ((tDebuff or 6) ~= 6 and VUHDO_DEBUFF_COLORS[tDebuff] ~= nil) then -- VUHDO_DEBUFF_TYPE_CUSTOM
		return VUHDO_copyColorTo(VUHDO_DEBUFF_COLORS[tDebuff], aNewColor);
	elseif (tDebuff == 6 and tDebuffSettings ~= nil -- VUHDO_DEBUFF_TYPE_CUSTOM
		and tDebuffSettings["isColor"] and tDebuffSettings["color"] ~= nil) then
		tSourceColor = tDebuffSettings["color"];

		if (VUHDO_DEBUFF_COLORS[6]["useBackground"]) then
			aNewColor["useBackground"] = true;
			aNewColor["R"], aNewColor["G"], aNewColor["B"], aNewColor["O"] = tSourceColor["R"], tSourceColor["G"], tSourceColor["B"], tSourceColor["O"];
		end

		if (VUHDO_DEBUFF_COLORS[6]["useText"]) then
			aNewColor["useText"] = true;
			aNewColor["TR"], aNewColor["TG"], aNewColor["TB"], aNewColor["TO"] = tSourceColor["TR"], tSourceColor["TG"], tSourceColor["TB"], tSourceColor["TO"];
		end

		return aNewColor;
	end

	if (anInfo["mibucateg"] == nil or VUHDO_BUFF_SETTINGS[anInfo["mibucateg"]] == nil) then
		return aNewColor;
	end

	tSourceColor = VUHDO_BUFF_SETTINGS[anInfo["mibucateg"]]["missingColor"];
	if (VUHDO_BUFF_SETTINGS["CONFIG"]["BAR_COLORS_TEXT"]) then
		aNewColor["useText"] = true;
		aNewColor["TR"], aNewColor["TG"], aNewColor["TB"], aNewColor["TO"] = tSourceColor["TR"], tSourceColor["TG"], tSourceColor["TB"], tSourceColor["TO"];
	end

	if (VUHDO_BUFF_SETTINGS["CONFIG"]["BAR_COLORS_BACKGROUND"]) then
		aNewColor["useBackground"] = true;
		aNewColor["R"], aNewColor["G"], aNewColor["B"], aNewColor["O"] = tSourceColor["R"], tSourceColor["G"], tSourceColor["B"], tSourceColor["O"];
	end

	return aNewColor;
end



--
local tColor;
function VUHDO_getDebuffColor(anInfo)
	return VUHDO_formColor(_VUHDO_getDebuffColor(anInfo, VUHDO_copyColorRevolving()));
end



--
local tEmpty = { };
local function VUHDO_isDebuffRelevant(aDebuffName, aClass)
	return not VUHDO_IGNORE_DEBUFF_NAMES[aDebuffName]
		and not (VUHDO_IGNORE_DEBUFFS_BY_CLASS[aClass or ""] or tEmpty)[aDebuffName];
end



--
local tNextSoundTime = 0;
local function VUHDO_playDebuffSound(aSound)
	if ((aSound or "") == "" or GetTime() < tNextSoundTime) then
		return;
	end

	PlaySoundFile(aSound);
	tNextSoundTime = GetTime() + 2;
end



--
local tSetColor, tSetIcon;
local tIconsSet = { };
local tDebuffInfo;
local tInfo;
local tDebuffName, tSoundDebuff;
local tSound;
local tIsStandardDebuff;
local tChosenInfo;
local tCnt;
local tRemaining;
local tSchool, tAllSchools;
local tEmptyCustomDebuf = { };
local tAbility;
local tType;
local tChosen;
local tName, tIcon, tStacks, tTypeString, tDuration, tExpiry, tSpellId, tIsBossDebuff;
local tCustomDebuff;
local tIsRelevant;
local tNow;
function VUHDO_determineDebuff(aUnit)
	tInfo = (VUHDO_RAID or tEmptyCustomDebuf)[aUnit];
	if (tInfo == nil) then
		return 0, ""; -- VUHDO_DEBUFF_TYPE_NONE
	elseif (VUHDO_CONFIG_SHOW_RAID) then
		return tInfo["debuff"], tInfo["debuffName"];
	end

	if (VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit] == nil) then
		VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit] = { };
	end

	if (VUHDO_CHOSEN_DEBUFF_INFO[aUnit] == nil) then
		VUHDO_CHOSEN_DEBUFF_INFO[aUnit] = { nil, 0, 0, 0 };
		tChosenInfo = VUHDO_CHOSEN_DEBUFF_INFO[aUnit];
	else
		tChosenInfo = VUHDO_CHOSEN_DEBUFF_INFO[aUnit];
		tChosenInfo[1], tChosenInfo[2], tChosenInfo[3], tChosenInfo[4] = nil, nil, 0, 0;
	end

	if (VUHDO_UNIT_DEBUFF_SCHOOLS[aUnit] == nil) then
		VUHDO_UNIT_DEBUFF_SCHOOLS[aUnit] = { [1] = { }, [2] = { }, [3] = { }, [4] = { } }; -- VUHDO_DEBUFF_TYPE_POISON, VUHDO_DEBUFF_TYPE_DISEASE, VUHDO_DEBUFF_TYPE_MAGIC, VUHDO_DEBUFF_TYPE_CURSE
		tAllSchools = VUHDO_UNIT_DEBUFF_SCHOOLS[aUnit];
	else
		tAllSchools = VUHDO_UNIT_DEBUFF_SCHOOLS[aUnit];
		tAllSchools[1][2], tAllSchools[2][2], tAllSchools[3][2], tAllSchools[4][2] = nil, nil, nil, nil;
	end

	tDebuffName = "";
	twipe(tIconsSet);
	tChosen = 0; --VUHDO_DEBUFF_TYPE_NONE

	if (VUHDO_shouldScanUnit(aUnit)) then
		tSoundDebuff = nil;
		tIsStandardDebuff = false;
		tNow = GetTime();

		for tCnt = 1, 255 do
			tName, _, tIcon, tStacks, tTypeString, tDuration, tExpiry, _, _, _, tSpellId, _, tIsBossDebuff, _ = UnitDebuff(aUnit, tCnt, false);

			--[[tName = "Blah";
			tTypeString = "Magic";
			tIcon = "interface\\characterframe\\temporaryportrait-female-draenei";
			tStacks = 1;
			tDuration = 10;
			tExpiry = GetTime() + 10;
			tAbsorb = 28000;
			tSpellId = 999999999;]]

			if (tIcon == nil) then
				break;
			end

			tStacks = tStacks or 0;
			if ((tExpiry or 0) == 0) then
				tExpiry = (tIconsSet[tName] or {})[2] or 0;
			end

			-- Custom Debuff?
			tCustomDebuff = VUHDO_CUSTOM_DEBUFF_LIST[tName] or VUHDO_CUSTOM_DEBUFF_LIST[tostring(tSpellId or -1)] or tEmptyCustomDebuf;
			if (tCustomDebuff[1]) then -- Farbe?
				tChosen = 6; --VUHDO_DEBUFF_TYPE_CUSTOM
				tDebuffName = tName;
				tSoundDebuff = tName;
			end

			tRemaining = floor((tExpiry or tNow) - tNow);

			if (tIconsSet[tName] ~= nil) then
				tStacks = tStacks + tIconsSet[tName][3];
			end

			if (tCustomDebuff[2]) then -- Icon?
				tIconsSet[tName] = { tIcon, tExpiry, tStacks, false };
				tSoundDebuff = tName;
			end

			tType = VUHDO_DEBUFF_TYPES[tTypeString];
			tAbility = VUHDO_PLAYER_ABILITIES[tType];
			tIsRelevant = VUHDO_isDebuffRelevant(tName, tInfo["class"]);

			if (tType ~= nil and tIsRelevant) then
				tSchool = tAllSchools[tType];
				if ((tSchool[2] or 0) < tRemaining) then
					tSchool[1], tSchool[2], tSchool[3], tSchool[4] = tIcon, tRemaining, tStacks, tDuration;
				end
			end

			if ((not sIsRemoveableOnly
					or (tAbility == "I" and "player" == aUnit)
					or (tAbility or "I") ~= "I")
				and tChosen ~= 6
				and not VUHDO_DEBUFF_BLACKLIST[tName]) then --VUHDO_DEBUFF_TYPE_CUSTOM

				if (sIsUseDebuffIcon and (tIsBossDebuff or not sIsUseDebuffIconBossOnly)) then
					tIconsSet[tName] = { tIcon, tExpiry, tStacks, tDuration, false };
					tIsStandardDebuff = true;
				end

				if (tType ~= nil and tIsRelevant and (tAbility ~= nil or tChosen == 0)) then --VUHDO_DEBUFF_TYPE_NONE
					tChosen = tType;
					tChosenInfo[1], tChosenInfo[2], tChosenInfo[3], tChosenInfo[4] = tIcon, tRemaining, tStacks, tDuration;
				end
			end
		end

		for tCnt = 1, 255 do
			tName, _, tIcon, tStacks, _, tDuration, tExpiry, _, _, _, tSpellId = UnitBuff(aUnit, tCnt);

			if (tIcon == nil) then
				break;
			end

			if (not VUHDO_CUSTOM_BUFF_BLACKLIST[tName]) then
				tCustomDebuff = VUHDO_CUSTOM_DEBUFF_LIST[tName] or VUHDO_CUSTOM_DEBUFF_LIST[tostring(tSpellId or -1)] or tEmptyCustomDebuf;
				tSetColor, tSetIcon = tCustomDebuff[1], tCustomDebuff[2];
			else
				tSetColor, tSetIcon = false, false;
			end

			if (tSetColor) then
				tChosen = 6; --VUHDO_DEBUFF_TYPE_CUSTOM
				tDebuffName = tName;
				tSoundDebuff = tName;
			end

			if (tSetIcon) then
				tIconsSet[tName] = { tIcon, tExpiry, tStacks or 0, tDuration, true };
				tSoundDebuff = tName;
			end
		end

		-- Gained new custom debuff?
		for tName, tDebuffInfo in pairs(tIconsSet) do
			if (VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName] == nil) then
				VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName] = { tDebuffInfo[2], tDebuffInfo[3] };
				VUHDO_addDebuffIcon(aUnit, tDebuffInfo[1], tName, tDebuffInfo[2], tDebuffInfo[3], tDebuffInfo[4], tDebuffInfo[5]);

				if (not VUHDO_IS_CONFIG and VUHDO_MAY_DEBUFF_ANIM and tSoundDebuff ~= nil) then
					if (sAllDebuffSettings[tSoundDebuff] ~= nil) then -- Spezieller custom debuff sound?
						VUHDO_playDebuffSound(sAllDebuffSettings[tSoundDebuff]["SOUND"]);
					elseif (VUHDO_CONFIG["CUSTOM_DEBUFF"]["SOUND"] ~= nil) then -- Allgemeiner custom debuff sound?
						VUHDO_playDebuffSound(VUHDO_CONFIG["CUSTOM_DEBUFF"]["SOUND"]);
					end
				end

				VUHDO_updateBouquetsForEvent(aUnit, 29); -- VUHDO_UPDATE_CUSTOM_DEBUFF
			-- update number of stacks?
			elseif(VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][1] ~= tDebuffInfo[2]
				or VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName][2] ~= tDebuffInfo[3]) then

				twipe(VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName]);
				VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName] = { tDebuffInfo[2], tDebuffInfo[3] };
				VUHDO_updateDebuffIcon(aUnit, tDebuffInfo[1], tName, tDebuffInfo[2], tDebuffInfo[3], tDebuffInfo[4]);
				VUHDO_updateBouquetsForEvent(aUnit, 29); -- VUHDO_UPDATE_CUSTOM_DEBUFF
			end
		end

		-- Play standard debuff sound?
		if (sStdDebuffSound ~= nil
			and (tChosen ~= 0 or tIsStandardDebuff) -- VUHDO_DEBUFF_TYPE_NONE
			and tChosen ~= 6 and tChosen ~= 7 -- VUHDO_DEBUFF_TYPE_CUSTOM || VUHDO_DEBUFF_TYPE_MISSING_BUFF
			and VUHDO_LAST_UNIT_DEBUFFS[aUnit] ~= tChosen
			and tInfo["range"]) then

				VUHDO_playDebuffSound(sStdDebuffSound);
				VUHDO_LAST_UNIT_DEBUFFS[aUnit] = tChosen;
		end
	end -- shouldScanUnit

	-- Lost old custom debuff?
	for tName, _ in pairs(VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit]) do
		if (tIconsSet[tName] == nil) then
			twipe(VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName]);
			VUHDO_UNIT_CUSTOM_DEBUFFS[aUnit][tName] = nil;
			VUHDO_removeDebuffIcon(aUnit, tName);
			VUHDO_updateBouquetsForEvent(aUnit, 29); -- VUHDO_UPDATE_CUSTOM_DEBUFF
		end
	end

	if (tChosen == 0 and tInfo["missbuff"] ~= nil and (sIsMiBuColorsInFight or not InCombatLockdown())) then --VUHDO_DEBUFF_TYPE_NONE
		tChosen = 7; --VUHDO_DEBUFF_TYPE_MISSING_BUFF
	end

	return tChosen, tDebuffName;
end

local VUHDO_determineDebuff = VUHDO_determineDebuff;



--
local tUnit, tInfo;
function VUHDO_updateAllCustomDebuffs(anIsEnableAnim)
	twipe(VUHDO_UNIT_CUSTOM_DEBUFFS);
	VUHDO_MAY_DEBUFF_ANIM = false;
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		VUHDO_removeAllDebuffIcons(tUnit);
		tInfo["debuff"], tInfo["debuffName"] = VUHDO_determineDebuff(tUnit);
	end
	VUHDO_MAY_DEBUFF_ANIM = anIsEnableAnim;
end



-- Remove debuffing abilities individually not known to the player
function VUHDO_initDebuffs()
	local tDebuffType;
	local tDebuffName;
	local tAbility;

	twipe(VUHDO_DEBUFF_ABILITIES);
	VUHDO_DEBUFF_ABILITIES = VUHDO_deepCopyTable(VUHDO_INIT_DEBUFF_ABILITIES);
	local _, tClass = UnitClass("player");

	for tDebuffType, tAbility in pairs(VUHDO_DEBUFF_ABILITIES[tClass] or { }) do
		if (not VUHDO_isSpellKnown(tAbility) and tAbility ~= "*" and tAbility ~= "I") then
			VUHDO_DEBUFF_ABILITIES[tClass][tDebuffType] = nil;
		end
	end

	if ("DRUID" == tClass) then -- Kein Nature's cure?
		local _, _, _, _, tRank, _, _, _ = GetTalentInfo(3, 17, false, false, nil);
		if ((tRank or 0) == 0) then
			VUHDO_DEBUFF_ABILITIES[tClass][VUHDO_DEBUFF_TYPE_MAGIC] = nil;
		end
	elseif ("SHAMAN" == tClass) then -- Kein improved cleanse spirit?
		local _, _, _, _, tRank, _, _, _ = GetTalentInfo(3, 12, false, false, nil);
		if ((tRank or 0) == 0) then
			VUHDO_DEBUFF_ABILITIES[tClass][VUHDO_DEBUFF_TYPE_MAGIC] = nil;
		end
	elseif ("PALADIN" == tClass) then -- Keine heilige Läuterung?
		local tName, _, _, _, tRank, _, _, _ = GetTalentInfo(1, 14, false, false, nil);
		if ((tRank or 0) == 0) then
			VUHDO_DEBUFF_ABILITIES[tClass][VUHDO_DEBUFF_TYPE_MAGIC] = nil;
		end
	elseif ("PRIEST" == tClass) then -- Kein Body & Soul?
		local _, _, _, _, tRank, _, _, _ = GetTalentInfo(2, 13, false, false, nil);
		if ((tRank or 0) == 0) then
			VUHDO_DEBUFF_ABILITIES[tClass][VUHDO_DEBUFF_TYPE_POISON] = nil;
		end
	end

	VUHDO_PLAYER_ABILITIES = VUHDO_DEBUFF_ABILITIES[tClass];

	twipe(VUHDO_CUSTOM_DEBUFF_LIST);
	if (VUHDO_CONFIG == nil) then
		VUHDO_CONFIG = VUHDO_GLOBAL["VUHDO_CONFIG"];
	end
	for _, tDebuffName in pairs(VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED"]) do
		VUHDO_CUSTOM_DEBUFF_LIST[tDebuffName] = {
			VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][tDebuffName]["isColor"],
			VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][tDebuffName]["isIcon"]
		};
	end

	twipe(VUHDO_IGNORE_DEBUFF_NAMES);

	if (VUHDO_CONFIG["DETECT_DEBUFFS_IGNORE_NO_HARM"]) then
		VUHDO_IGNORE_DEBUFFS_BY_CLASS = VUHDO_deepCopyTable(VUHDO_INIT_IGNORE_DEBUFFS_BY_CLASS);
		VUHDO_tableAddAllKeys(VUHDO_IGNORE_DEBUFF_NAMES, VUHDO_INIT_IGNORE_DEBUFFS_NO_HARM);
	else
		VUHDO_IGNORE_DEBUFFS_BY_CLASS = {};
	end

	if (VUHDO_CONFIG["DETECT_DEBUFFS_IGNORE_MOVEMENT"]) then
		VUHDO_tableAddAllKeys(VUHDO_IGNORE_DEBUFF_NAMES, VUHDO_INIT_IGNORE_DEBUFFS_MOVEMENT);
	end

	if (VUHDO_CONFIG["DETECT_DEBUFFS_IGNORE_DURATION"]) then
		VUHDO_tableAddAllKeys(VUHDO_IGNORE_DEBUFF_NAMES, VUHDO_INIT_IGNORE_DEBUFFS_DURATION);
	end
end



--
function VUHDO_getDebuffAbilities(aClass)
	return VUHDO_DEBUFF_ABILITIES[aClass];
end



--
local tEmptySchoolInfo = { };
function VUHDO_getUnitDebuffSchoolInfos(aUnit, aDebuffSchool)
	return (VUHDO_UNIT_DEBUFF_SCHOOLS[aUnit] or VUHDO_INIT_UNIT_DEBUFF_SCHOOLS)[aDebuffSchool] or tEmptySchoolInfo;
end
