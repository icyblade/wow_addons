local _;
--
local smatch = string.match;

local InCombatLockdown = InCombatLockdown;

local VUHDO_updateAllHoTs;
local VUHDO_updateAllCyclicBouquets;
local VUHDO_initGcd;

local VUHDO_ACTIVE_HOTS;
local VUHDO_RAID_NAMES;
local VUHDO_CONFIG = { };

local sIsShowGcd;
local sUniqueSpells = { };
local sFirstRes, sSecondRes;
local sEmpty = { };


function VUHDO_spellEventHandlerInitLocalOverrides()
	VUHDO_updateAllHoTs = _G["VUHDO_updateAllHoTs"];
	VUHDO_updateAllCyclicBouquets = _G["VUHDO_updateAllCyclicBouquets"];
	VUHDO_initGcd = _G["VUHDO_initGcd"];

	VUHDO_ACTIVE_HOTS = _G["VUHDO_ACTIVE_HOTS"];
	VUHDO_RAID_NAMES = _G["VUHDO_RAID_NAMES"];
	VUHDO_CONFIG = _G["VUHDO_CONFIG"];

	sIsShowGcd = VUHDO_isShowGcd();

	table.wipe(sUniqueSpells);
	local tUnique, tUniqueCategs = VUHDO_getAllUniqueSpells();
	for _, tSpellName in pairs(tUnique) do
		sUniqueSpells[tSpellName] = tUniqueCategs[tSpellName];
	end

	sFirstRes, sSecondRes = VUHDO_getResurrectionSpells();
end



--
local function VUHDO_activateSpellForSpec(aSpecId)
	local tName = VUHDO_SPEC_LAYOUTS[aSpecId];
	if not VUHDO_strempty(tName) then
		if VUHDO_SPELL_LAYOUTS[tName] then VUHDO_activateLayout(tName);
		else VUHDO_Msg(format(VUHDO_I18N_SPELL_LAYOUT_NOT_EXIST, tName), 1, 0.4, 0.4); end
	end
end



--
local function VUHDO_activateSpecc(aSpecNum)
	VUHDO_activateSpellForSpec(aSpecNum);
	local tProfile = VUHDO_getBestProfileAfterSpecChange();
	if tProfile then VUHDO_loadProfile(tProfile); end
	VUHDO_aoeUpdateTalents();
end



--
local VUHDO_TALENT_CHANGE_SPELLS = {
	[VUHDO_SPELL_ID.ACTIVATE_FIRST_TALENT] = true,
	[VUHDO_SPELL_ID.ACTIVATE_SECOND_TALENT] = true,
	[VUHDO_SPELL_ID.BUFF_FROST_PRESENCE] = true,
	[VUHDO_SPELL_ID.BUFF_BLOOD_PRESENCE] = true,
	[VUHDO_SPELL_ID.BUFF_UNHOLY_PRESENCE] = true,
}



--
function VUHDO_spellcastSucceeded(aUnit, aSpellName)
	if VUHDO_TALENT_CHANGE_SPELLS[aSpellName] then
		VUHDO_resetTalentScan(aUnit);
		VUHDO_initDebuffs(); -- Talentabhängige Debuff-Fähigkeiten neu initialisieren.
		VUHDO_timeReloadUI(1);
	end

	if "player" ~= aUnit and VUHDO_PLAYER_RAID_ID ~= aUnit then return; end

	if VUHDO_ACTIVE_HOTS[aSpellName] then
		VUHDO_updateAllHoTs();
		VUHDO_updateAllCyclicBouquets(true);
	end

	if VUHDO_SPELL_ID.ACTIVATE_FIRST_TALENT == aSpellName then VUHDO_activateSpecc("1");
	elseif (VUHDO_SPELL_ID.ACTIVATE_SECOND_TALENT == aSpellName) then VUHDO_activateSpecc("2"); end

	VUHDO_aoeUpdateAll();
end



--
local tTargetUnit;
local tCateg;
function VUHDO_spellcastSent(aUnit, aSpellName, aSpellRank, aTargetName)
	if "player" ~= aUnit or not aTargetName then return; end

	if sIsShowGcd then VUHDO_initGcd(); end

	aTargetName = smatch(aTargetName, "^[^-]*");
	tTargetUnit = VUHDO_RAID_NAMES[aTargetName];

	if not tTargetUnit then return end;

	-- Resurrection?
	if aSpellName == sFirstRes or aSpellName == sSecondRes then

		if VUHDO_CONFIG["RES_IS_SHOW_TEXT"] then

			local tChannel = (UnitInBattleground("player") or HasLFGRestrictions()) and "INSTANCE_CHAT"
				or IsInRaid() and "RAID" or IsInGroup() and "PARTY" or nil;

			if tChannel then
				SendChatMessage((gsub(VUHDO_CONFIG["RES_ANNOUNCE_TEXT"], "[Vv][Uu][Hh][Dd][Oo]", aTargetName)), tChannel);
			end

		end
		return;
	end

	tCateg = sUniqueSpells[aSpellName];
	if tCateg and not InCombatLockdown()
		and (VUHDO_BUFF_SETTINGS or sEmpty)[tCateg] and aTargetName ~= VUHDO_BUFF_SETTINGS[tCateg]["name"] then

		VUHDO_BUFF_SETTINGS[tCateg]["name"] = aTargetName;
		VUHDO_reloadBuffPanel();
	end
end
