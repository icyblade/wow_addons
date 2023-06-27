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


function VUHDO_spellEventHandlerInitBurst()
	VUHDO_updateAllHoTs = VUHDO_GLOBAL["VUHDO_updateAllHoTs"];
	VUHDO_updateAllCyclicBouquets = VUHDO_GLOBAL["VUHDO_updateAllCyclicBouquets"];
	VUHDO_initGcd = VUHDO_GLOBAL["VUHDO_initGcd"];

	VUHDO_ACTIVE_HOTS = VUHDO_GLOBAL["VUHDO_ACTIVE_HOTS"];
	VUHDO_RAID_NAMES = VUHDO_GLOBAL["VUHDO_RAID_NAMES"];
	VUHDO_CONFIG = VUHDO_GLOBAL["VUHDO_CONFIG"];

	sIsShowGcd = VUHDO_CONFIG["IS_SHOW_GCD"];

	table.wipe(sUniqueSpells);
	local tSpellName;
	local tUnique, tUniqueCategs = VUHDO_getAllUniqueSpells();
	for _, tSpellName in pairs(tUnique) do
		sUniqueSpells[tSpellName] = tUniqueCategs[tSpellName];
	end

	sFirstRes, sSecondRes = VUHDO_getResurrectionSpells();
end



--
local function VUHDO_activateSpellForSpec(aSpecId)
	local tName = VUHDO_SPEC_LAYOUTS[aSpecId];
	if (not VUHDO_strempty(tName)) then
		if (VUHDO_SPELL_LAYOUTS[tName] ~= nil) then
			VUHDO_activateLayout(tName);
		else
			VUHDO_Msg(format(VUHDO_I18N_SPELL_LAYOUT_NOT_EXIST, tName), 1, 0.4, 0.4);
		end
	end
end



--
local function VUHDO_activateSpecc(aSpecNum)
	VUHDO_activateSpellForSpec(aSpecNum);
	local tProfile = VUHDO_getBestProfileAfterSpecChange();
	if (tProfile ~= nil) then
		VUHDO_loadProfile(tProfile);
	end
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
	if (VUHDO_TALENT_CHANGE_SPELLS[aSpellName]) then
		VUHDO_resetTalentScan(aUnit);
		VUHDO_initDebuffs(); -- Talentabhängige Debuff-Fähigkeiten neu initialisieren.
		VUHDO_timeReloadUI(1);
	end

	if ("player" ~= aUnit and VUHDO_PLAYER_RAID_ID ~= aUnit) then
		return;
	end

	if (VUHDO_ACTIVE_HOTS[aSpellName]) then
		VUHDO_updateAllHoTs();
		VUHDO_updateAllCyclicBouquets("player");
	end

	if (VUHDO_SPELL_ID.ACTIVATE_FIRST_TALENT == aSpellName) then
		VUHDO_activateSpecc("1");
	elseif (VUHDO_SPELL_ID.ACTIVATE_SECOND_TALENT == aSpellName) then
		VUHDO_activateSpecc("2");
	end

	VUHDO_aoeUpdateAll();
end



--
local tTargetUnit;
local tCateg;
function VUHDO_spellcastSent(aUnit, aSpellName, aSpellRank, aTargetName)
	if ("player" ~= aUnit or aTargetName == nil) then
		return;
	end

	if (sIsShowGcd) then
		VUHDO_initGcd();
	end

	aTargetName = smatch(aTargetName, "^[^-]*");
	tTargetUnit = VUHDO_RAID_NAMES[aTargetName];

	-- Resurrection?
	if ((aSpellName == sFirstRes or aSpellName == sSecondRes)
		and aTargetName ~= nil and tTargetUnit ~= nil) then

		if (VUHDO_CONFIG["RES_IS_SHOW_TEXT"]) then
			local tText = gsub(VUHDO_CONFIG["RES_ANNOUNCE_TEXT"], "[Vv][Uu][Hh][Dd][Oo]", aTargetName);

			if (GetNumRaidMembers() > 0) then
				SendChatMessage(tText, "RAID", nil, nil);
			elseif (GetNumPartyMembers() > 0) then
				SendChatMessage(tText, "PARTY", nil, nil);
			else
				SendChatMessage(tText, "WHISPER", nil, aTargetName);
			end
		end
		return;
	end

	tCateg = sUniqueSpells[aSpellName];
	if (tCateg ~= nil and tTargetUnit ~= nil and not InCombatLockdown()) then
		if (VUHDO_BUFF_SETTINGS ~= nil and VUHDO_BUFF_SETTINGS[tCateg] ~= nil and aTargetName ~= VUHDO_BUFF_SETTINGS[tCateg]["name"]) then
			VUHDO_BUFF_SETTINGS[tCateg]["name"] = aTargetName;
			VUHDO_reloadBuffPanel();
		end
	end
end
