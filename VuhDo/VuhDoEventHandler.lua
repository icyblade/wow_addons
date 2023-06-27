VUHDO_INTERNAL_TOGGLES = { };
local VUHDO_INTERNAL_TOGGLES = VUHDO_INTERNAL_TOGGLES;

local VUHDO_DEBUFF_ANIMATION = 0;

--local VUHDO_EVENT_COUNT = 0;
--local VUHDO_LAST_TIME_NO_EVENT = GetTime();
local VUHDO_INSTANCE = nil;

-- BURST CACHE ---------------------------------------------------

local VUHDO_RAID;
local VUHDO_PANEL_SETUP;
VUHDO_RELOAD_UI_IS_LNF = false;

local VUHDO_parseAddonMessage;
local VUHDO_spellcastFailed;
local VUHDO_spellcastSucceeded;
local VUHDO_spellcastSent;
local VUHDO_parseCombatLogEvent;
local VUHDO_updateAllOutRaidTargetButtons;
local VUHDO_updateAllRaidTargetIndices;
local VUHDO_updateDirectionFrame;

local VUHDO_updateHealth;
local VUHDO_updateManaBars;
local VUHDO_updateTargetBars;
local VUHDO_updateAllRaidBars;
local VUHDO_updateHealthBarsFor;
local VUHDO_updateAllHoTs;
local VUHDO_updateAllCyclicBouquets;
local VUHDO_updateAllDebuffIcons;
local VUHDO_updateAllClusters;
local VUHDO_aoeUpdateAll;
local VUHDO_updateBouquetsForEvent = VUHDO_updateBouquetsForEvent;
local VUHDO_getUnitZoneName;
local VUHDO_updateClusterHighlights;
local VUHDO_updateCustomDebuffTooltip;
local VUHDO_getCurrentMouseOver;

local GetTime = GetTime;
local CheckInteractDistance = CheckInteractDistance;
local UnitInRange = UnitInRange;
local IsSpellInRange = IsSpellInRange;
local UnitDetailedThreatSituation = UnitDetailedThreatSituation;
local UnitIsCharmed = UnitIsCharmed;
local UnitCanAttack = UnitCanAttack;
local UnitName = UnitName;
local UnitIsEnemy = UnitIsEnemy;
local GetSpellCooldown = GetSpellCooldown;
local HasFullControl = HasFullControl;
local pairs = pairs;
local UnitThreatSituation = UnitThreatSituation;
local InCombatLockdown = InCombatLockdown;
local type = type;

local sRangeSpell, sIsRangeKnown, sIsHealerMode;
local sIsDirectionArrow = false;
local sShowShieldAbsorb = false;
local VuhDoGcdStatusBar;
local sHotToggleUpdateSecs = 1;
local sAggroRefreshSecs = 1;
local sRangeRefreshSecs = 1.1;
local sClusterRefreshSecs = 1.2;
local sAoeRefreshSecs = 1.3;
local sBuffsRefreshSecs;
local VuhDoDirectionFrame;


local function VUHDO_eventHandlerInitBurst()
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];
	VUHDO_PANEL_SETUP = VUHDO_GLOBAL["VUHDO_PANEL_SETUP"];

	VUHDO_updateHealth = VUHDO_GLOBAL["VUHDO_updateHealth"];
	VUHDO_updateManaBars = VUHDO_GLOBAL["VUHDO_updateManaBars"];
	VUHDO_updateTargetBars = VUHDO_GLOBAL["VUHDO_updateTargetBars"];
	VUHDO_updateAllRaidBars = VUHDO_GLOBAL["VUHDO_updateAllRaidBars"];
	VUHDO_updateAllOutRaidTargetButtons = VUHDO_GLOBAL["VUHDO_updateAllOutRaidTargetButtons"];
	VUHDO_parseAddonMessage = VUHDO_GLOBAL["VUHDO_parseAddonMessage"];
	VUHDO_spellcastFailed = VUHDO_GLOBAL["VUHDO_spellcastFailed"];
	VUHDO_spellcastSucceeded = VUHDO_GLOBAL["VUHDO_spellcastSucceeded"];
	VUHDO_spellcastSent = VUHDO_GLOBAL["VUHDO_spellcastSent"];
	VUHDO_parseCombatLogEvent = VUHDO_GLOBAL["VUHDO_parseCombatLogEvent"];
	VUHDO_updateHealthBarsFor = VUHDO_GLOBAL["VUHDO_updateHealthBarsFor"];
	VUHDO_updateAllHoTs = VUHDO_GLOBAL["VUHDO_updateAllHoTs"];
	VUHDO_updateAllCyclicBouquets = VUHDO_GLOBAL["VUHDO_updateAllCyclicBouquets"];
	VUHDO_updateAllDebuffIcons = VUHDO_GLOBAL["VUHDO_updateAllDebuffIcons"];
	VUHDO_updateAllRaidTargetIndices = VUHDO_GLOBAL["VUHDO_updateAllRaidTargetIndices"];
	VUHDO_updateAllClusters = VUHDO_GLOBAL["VUHDO_updateAllClusters"];
	VUHDO_aoeUpdateAll = VUHDO_GLOBAL["VUHDO_aoeUpdateAll"];
	--VUHDO_updateBouquetsForEvent = VUHDO_GLOBAL["VUHDO_updateBouquetsForEvent"];
	VuhDoGcdStatusBar = VUHDO_GLOBAL["VuhDoGcdStatusBar"];
	VuhDoDirectionFrame = VUHDO_GLOBAL["VuhDoDirectionFrame"];
	VUHDO_updateDirectionFrame = VUHDO_GLOBAL["VUHDO_updateDirectionFrame"];
	VUHDO_getUnitZoneName = VUHDO_GLOBAL["VUHDO_getUnitZoneName"];
	VUHDO_updateClusterHighlights = VUHDO_GLOBAL["VUHDO_updateClusterHighlights"];
	VUHDO_updateCustomDebuffTooltip = VUHDO_GLOBAL["VUHDO_updateCustomDebuffTooltip"];
	VUHDO_getCurrentMouseOver = VUHDO_GLOBAL["VUHDO_getCurrentMouseOver"];

	sRangeSpell = VUHDO_CONFIG["RANGE_SPELL"] or "*foo*";
	sIsHealerMode = not VUHDO_CONFIG["THREAT"]["IS_TANK_MODE"];
	sIsRangeKnown = not VUHDO_CONFIG["RANGE_PESSIMISTIC"] and GetSpellInfo(sRangeSpell) ~= nil;
	sIsDirectionArrow = VUHDO_CONFIG["DIRECTION"]["enable"];
	sShowShieldAbsorb = VUHDO_PANEL_SETUP["BAR_COLORS"]["HOTS"]["showShieldAbsorb"];

	sHotToggleUpdateSecs = VUHDO_CONFIG["UPDATE_HOTS_MS"] * 0.00033;
	sAggroRefreshSecs = VUHDO_CONFIG["THREAT"]["AGGRO_REFRESH_MS"] * 0.001;
	sRangeRefreshSecs = VUHDO_CONFIG["RANGE_CHECK_DELAY"] * 0.001;
	sClusterRefreshSecs = VUHDO_CONFIG["CLUSTER"]["REFRESH"] * 0.001;
	sAoeRefreshSecs = VUHDO_CONFIG["AOE_ADVISOR"]["refresh"] * 0.001;
	sBuffsRefreshSecs = VUHDO_BUFF_SETTINGS["CONFIG"]["REFRESH_SECS"]
end

----------------------------------------------------

local VUHDO_VARIABLES_LOADED = false;
local VUHDO_IS_RELOAD_BUFFS = false;
local VUHDO_LOST_CONTROL = false;
local VUHDO_RELOAD_AFTER_BATTLE = false;
local VUHDO_GCD_UPDATE = false;

local VUHDO_RELOAD_PANEL_NUM = nil;
local VUHDO_REFRESH_TOOLTIP_DELAY = 2.3;


VUHDO_TIMERS = {
	["RELOAD_UI"] = 0,
	["RELOAD_PANEL"] = 0,
	["CUSTOMIZE"] = 0,
	["CHECK_PROFILES"] = 6.2,
	["RELOAD_ZONES"] = 3.45,
	["UPDATE_CLUSTERS"] = 0,
	["REFRESH_INSPECT"] = 2.1,
	["REFRESH_TOOLTIP"] = VUHDO_REFRESH_TOOLTIP_DELAY,
	["UPDATE_AGGRO"] = 0,
	["UPDATE_RANGE"] = 1,
	["UPDATE_HOTS"] = 0.25,
	["REFRESH_TARGETS"] = 0.51,
	["RELOAD_RAID"] = 0,
	["RELOAD_ROSTER"] = 0,
	["REFRESH_DRAG"] = 0.05,
	["MIRROR_TO_MACRO"] = 8,
	["REFRESH_CUDE_TOOLTIP"] = 1,
	["UPDATE_AOE"] = 3,
	["BUFF_WATCH"] = 1,
};
local VUHDO_TIMERS = VUHDO_TIMERS;


local tUnit, tInfo;


VUHDO_CONFIG = nil;
VUHDO_PANEL_SETUP = nil;
VUHDO_SPELL_ASSIGNMENTS = nil;
VUHDO_SPELLS_KEYBOARD = nil;
VUHDO_SPELL_CONFIG = nil;

VUHDO_IS_RELOADING = false;
VUHDO_FONTS = { };
VUHDO_STATUS_BARS = { };
VUHDO_SOUNDS = { };
VUHDO_BORDERS = { };


VUHDO_MAINTANK_NAMES = { };
local VUHDO_FIRST_RELOAD_UI = false;


--
function VUHDO_isVariablesLoaded()
	return VUHDO_VARIABLES_LOADED;
end



--
function VUHDO_setTooltipDelay(aSecs)
	VUHDO_REFRESH_TOOLTIP_DELAY = aSecs;
end



--
function VUHDO_initBuffs()
	VUHDO_initBuffsFromSpellBook();
	VUHDO_reloadBuffPanel();
	VUHDO_resetHotBuffCache();
end



--
function VUHDO_initTooltipTimer()
	VUHDO_TIMERS["REFRESH_TOOLTIP"] = VUHDO_REFRESH_TOOLTIP_DELAY;
end



--
-- 3 = Tanking, all others less 100%
-- 2 = Tanking, others > 100%
-- 1 = Not Tanking, more than 100%
-- 0 = Not Tanking, less than 100%
local tInfo, tIsAggroed;
local tEmpty = {};
local function VUHDO_updateThreat(aUnit)
	tInfo = (VUHDO_RAID or tEmpty)[aUnit];
	if (tInfo ~= nil) then
		tInfo["threat"] = UnitThreatSituation(aUnit);

		if (VUHDO_INTERNAL_TOGGLES[17]) then -- VUHDO_UPDATE_THREAT_LEVEL
			VUHDO_updateBouquetsForEvent(aUnit, 17); -- VUHDO_UPDATE_THREAT_LEVEL
		end

		tIsAggroed = VUHDO_INTERNAL_TOGGLES[7] and (tInfo["threat"] or 0) >= 2; -- VUHDO_UPDATE_AGGRO

		if (tIsAggroed ~= tInfo["aggro"]) then
			tInfo["aggro"] = tIsAggroed;
			VUHDO_updateHealthBarsFor(aUnit, 7); -- VUHDO_UPDATE_AGGRO
		end
	end
end



--
function VUHDO_initAllBurstCaches()
	VUHDO_tooltipInitBurst();
	VUHDO_modelToolsInitBurst();
	VUHDO_toolboxInitBurst();
	VUHDO_guiToolboxInitBurst();
	VUHDO_vuhdoInitBurst();
	VUHDO_spellEventHandlerInitBurst();
	VUHDO_macroFactoryInitBurst();
	VUHDO_keySetupInitBurst();
	VUHDO_combatLogInitBurst();
	VUHDO_eventHandlerInitBurst();
	VUHDO_customHealthInitBurst();
	VUHDO_customManaInitBurst();
	VUHDO_customTargetInitBurst();
	VUHDO_customClustersInitBurst();
	VUHDO_panelInitBurst();
	VUHDO_panelRedrawInitBurst();
	VUHDO_panelRefreshInitBurst();
	VUHDO_roleCheckerInitBurst();
	VUHDO_sizeCalculatorInitBurst();
	VUHDO_customHotsInitBurst();
	VUHDO_customDebuffIconsInitBurst();
	VUHDO_debuffsInitBurst();
	VUHDO_healCommAdapterInitBurst();
	VUHDO_buffWatchInitBurst();
	VUHDO_clusterBuilderInitBurst();
	VUHDO_aoeAdvisorInitBurst();
	VUHDO_bouquetValidatorsInitBurst();
	VUHDO_bouquetsInitBurst();
	VUHDO_actionEventHandlerInitBurst();
	VUHDO_directionsInitBurst();
	VUHDO_dcShieldInitBurst();
	VUHDO_shieldAbsorbInitBurst();
	VUHDO_playerTargetEventHandlerInitBurst();
end



--
local function VUHDO_initOptions()
	if (VuhDoNewOptionsTabbedFrame ~= nil) then
		VUHDO_initHotComboModels();
		VUHDO_initHotBarComboModels();
		VUHDO_initDebuffIgnoreComboModel();
		VUHDO_initBouquetComboModel();
		VUHDO_initBouquetSlotsComboModel();
		VUHDO_bouquetsUpdateDefaultColors();
	end
end



--
local function VUHDO_loadDefaultProfile()
	local tName;

	if (VUHDO_CONFIG == nil) then
		return;
	end

	tName = VUHDO_CONFIG["CURRENT_PROFILE"];
	if ((tName or "") ~= "") then

		local _, tProfile = VUHDO_getProfileNamedCompressed(tName);

		if (tProfile ~= nil) then
			if (tProfile["LOCKED"]) then -- Nicht laden, Einstellungen wurden ja auch nicht automat. gespeichert
				VUHDO_Msg("Profile " .. tProfile["NAME"] .. " is currently locked and has NOT been loaded.");
				return;
			end

			VUHDO_loadProfileNoInit(tName);
		end
	end
end



--
local tLevel = 0;
local function VUHDO_init()
	if (tLevel == 0 or VUHDO_VARIABLES_LOADED) then
		tLevel = 1;
		return;
	end

	VUHDO_COMBAT_LOG_TRACE = {};

	if (VUHDO_RAID == nil) then
		VUHDO_RAID = { };
	end

	VUHDO_initButtonCache();
	VUHDO_loadDefaultProfile(); -- 1. Diese Reihenfolge scheint wichtig zu sein, erzeugt
	VUHDO_loadVariables(); -- 2. umgekehrt undefiniertes Verhalten (VUHDO_CONFIG ist nil etc.)
	VUHDO_initAllBurstCaches();
	VUHDO_initDefaultProfiles();
	VUHDO_VARIABLES_LOADED = true;

	VUHDO_initPanelModels();
	VUHDO_initFromSpellbook();
	VUHDO_initBuffs();
	VUHDO_initDebuffs(); -- Too soon obviously => ReloadUI
	VUHDO_clearUndefinedModelEntries();
	VUHDO_registerAllBouquets(true);
	VUHDO_reloadUI();
	VUHDO_getAutoProfile();
	VUHDO_initCliqueSupport(false);

	if (VuhDoNewOptionsTabbedFrame ~= nil) then
		VuhDoNewOptionsTabbedFrame:ClearAllPoints();
		VuhDoNewOptionsTabbedFrame:SetPoint("CENTER",  "UIParent", "CENTER",  0,  0);
	end

	VUHDO_initSharedMedia();
	VUHDO_initFuBar();
	VUHDO_initButtonFacade(VUHDO_INSTANCE);
	--VUHDO_checkForTroublesomeAddons();
	VUHDO_initHideBlizzFrames();
	if (not InCombatLockdown()) then
		VUHDO_initKeyboardMacros();
	end

	VUHDO_timeReloadUI(3);
	VUHDO_aoeUpdateTalents();
end



--VUHDO_EVENT_TIMES = { };
--
local tUnit;
local tEmptyRaid = { };
function VUHDO_OnEvent(_, anEvent, anArg1, anArg2, anArg3, anArg4, anArg5, anArg6, anArg7, anArg8, anArg9, anArg10, anArg11, anArg12, anArg13, anArg14, anArg15, anArg16, anArg17)

	--[[if (VUHDO_EVENT_TIMES["all"] == nil) then
		VUHDO_EVENT_TIMES["all"] = 0;
	end
	if (VUHDO_EVENT_TIMES[anEvent] == nil) then
		VUHDO_EVENT_TIMES[anEvent] = { 0, 0, 0, 0, 0, 0 };
	end
	local tDuration = GetTime();]]

	if ("COMBAT_LOG_EVENT_UNFILTERED" == anEvent) then
		if (VUHDO_VARIABLES_LOADED) then
			--VUHDO_traceCombatLog(anArg1, anArg2, anArg3, anArg4, anArg5, anArg6, anArg7, anArg8, anArg9, anArg10, anArg11, anArg12, anArg13, anArg14, anArg15, anArg15);
			VUHDO_parseCombatLogEvent(anArg2, anArg8, anArg11, anArg13, anArg15);
			if (sShowShieldAbsorb) then
				VUHDO_parseCombatLogShieldAbsorb(anArg2, anArg4, anArg8, anArg13, anArg16, anArg12, anArg17);
			end
		end
	elseif ("UNIT_AURA" == anEvent) then
		if ((VUHDO_RAID or tEmptyRaid)[anArg1] ~= nil) then
			VUHDO_updateHealth(anArg1, 4); -- VUHDO_UPDATE_DEBUFF
		end
	elseif ("UNIT_HEALTH" == anEvent) then
		if ((VUHDO_RAID or tEmptyRaid)[anArg1] ~= nil) then
			VUHDO_updateHealth(anArg1, 2); -- VUHDO_UPDATE_HEALTH
		end
	elseif ("UNIT_HEAL_PREDICTION" == anEvent) then
		if ((VUHDO_RAID or tEmptyRaid)[anArg1] ~= nil) then -- auch target, focus
			VUHDO_updateHealth(anArg1, 9); -- VUHDO_UPDATE_INC
		end
	elseif ("UNIT_POWER" == anEvent) then
		if ((VUHDO_RAID or tEmptyRaid)[anArg1] ~= nil) then
			if ("HOLY_POWER" == anArg2) then
				if ("player" == anArg1) then
					VUHDO_updateBouquetsForEvent("player", 31); -- VUHDO_UPDATE_OWN_HOLY_POWER
				end
			elseif ("ALTERNATE" == anArg2) then
				VUHDO_updateBouquetsForEvent(anArg1, 30); -- VUHDO_UPDATE_ALT_POWER
			else
				VUHDO_updateManaBars(anArg1, 1);
			end
		end
	elseif ("UNIT_SPELLCAST_SUCCEEDED" == anEvent) then
		if ((VUHDO_RAID or tEmptyRaid)[anArg1] ~= nil) then
			VUHDO_spellcastSucceeded(anArg1, anArg2);
		end
	elseif ("UNIT_SPELLCAST_SENT" == anEvent) then
		if (VUHDO_VARIABLES_LOADED) then
			VUHDO_spellcastSent(anArg1, anArg2, anArg3, anArg4);
		end
	elseif ("UNIT_THREAT_SITUATION_UPDATE" == anEvent) then
	if (VUHDO_VARIABLES_LOADED) then
		VUHDO_updateThreat(anArg1);
	end

	elseif ("UNIT_MAXHEALTH" == anEvent) then
		if ((VUHDO_RAID or tEmptyRaid)[anArg1] ~= nil) then
			VUHDO_updateHealth(anArg1, VUHDO_UPDATE_HEALTH_MAX);
		end

	elseif ("UNIT_TARGET" == anEvent) then
		if (VUHDO_VARIABLES_LOADED and "player" ~= anArg1) then
			VUHDO_updateTargetBars(anArg1);
			VUHDO_updateBouquetsForEvent(anArg1, 22); -- VUHDO_UPDATE_UNIT_TARGET
			VUHDO_updatePanelVisibility();
		end

	elseif ("UNIT_DISPLAYPOWER" == anEvent) then
		if ((VUHDO_RAID or tEmptyRaid)[anArg1] ~= nil) then
			VUHDO_updateManaBars(anArg1, 3);
		end
	elseif ("UNIT_MAXPOWER" == anEvent) then
		if ((VUHDO_RAID or tEmptyRaid)[anArg1] ~= nil) then
			if ("ALTERNATE" == anArg2) then
				VUHDO_updateBouquetsForEvent(anArg1, 30); -- VUHDO_UPDATE_ALT_POWER
			else
				VUHDO_updateManaBars(anArg1, 2);
			end
		end

	elseif ("UNIT_PET" == anEvent) then
		if (VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_PETS] or not InCombatLockdown()) then
			VUHDO_REMOVE_HOTS = false;
			VUHDO_normalRaidReload();
		end

	elseif ("UNIT_ENTERED_VEHICLE" == anEvent
		or "UNIT_EXITED_VEHICLE" == anEvent
		or "UNIT_EXITING_VEHICLE" == anEvent ) then
		VUHDO_REMOVE_HOTS = false;
		VUHDO_normalRaidReload();
	elseif ("RAID_TARGET_UPDATE" == anEvent) then
		VUHDO_TIMERS["CUSTOMIZE"] = 0.1;
	elseif ("PARTY_MEMBERS_CHANGED" == anEvent
			 or "RAID_ROSTER_UPDATE" == anEvent) then
		if (VUHDO_FIRST_RELOAD_UI) then
			VUHDO_normalRaidReload(true);
			if (VUHDO_TIMERS["RELOAD_ROSTER"] < 0.4) then
				VUHDO_TIMERS["RELOAD_ROSTER"] = 0.6;
			end
		end
	elseif ("PLAYER_FOCUS_CHANGED" == anEvent) then
		VUHDO_removeAllDebuffIcons("focus");
		VUHDO_quickRaidReload();
		VUHDO_clParserSetCurrentFocus();
		VUHDO_updateBouquetsForEvent(anArg1, 23); -- VUHDO_UPDATE_PLAYER_FOCUS
		if (VUHDO_RAID["focus"] ~= nil) then
			VUHDO_determineIncHeal("focus");
			VUHDO_updateHealth("focus", 9); -- VUHDO_UPDATE_INC
		end
	elseif ("PARTY_MEMBER_ENABLE" == anEvent
			 or "PARTY_MEMBER_DISABLE" == anEvent) then
		VUHDO_TIMERS["CUSTOMIZE"] = 0.2;
	elseif ("PLAYER_FLAGS_CHANGED" == anEvent) then
		if ((VUHDO_RAID or tEmptyRaid)[anArg1] ~= nil) then
			VUHDO_updateHealth(anArg1, VUHDO_UPDATE_AFK);
			VUHDO_updateBouquetsForEvent(anArg1, VUHDO_UPDATE_AFK);
		end
	elseif ("PLAYER_ENTERING_WORLD" == anEvent) then
		VUHDO_init();
		VUHDO_initAddonMessages();
	elseif("UNIT_POWER_BAR_SHOW" == anEvent
	    or "UNIT_POWER_BAR_HIDE" == anEvent) then
		if ((VUHDO_RAID or tEmptyRaid)[anArg1] ~= nil) then
			VUHDO_RAID[anArg1]["isAltPower"] = VUHDO_isAltPowerActive(anArg1);
			VUHDO_updateBouquetsForEvent(anArg1, 30); -- VUHDO_UPDATE_ALT_POWER
		end

	elseif ("LEARNED_SPELL_IN_TAB" == anEvent) then
		if (VUHDO_VARIABLES_LOADED) then
			VUHDO_initFromSpellbook();
			VUHDO_registerAllBouquets(false);
			VUHDO_initBuffs();
			VUHDO_initDebuffs();
		end

	elseif ("VARIABLES_LOADED" == anEvent) then
		VUHDO_init();

	elseif ("UPDATE_BINDINGS" == anEvent) then
		if (not InCombatLockdown() and VUHDO_VARIABLES_LOADED) then
			VUHDO_initKeyboardMacros();
		end
	elseif ("PLAYER_TARGET_CHANGED" == anEvent) then
		VUHDO_updatePlayerTarget();
		VUHDO_updateTargetBars("player");
		VUHDO_updateBouquetsForEvent("player", 22); -- VUHDO_UPDATE_UNIT_TARGET
		VUHDO_updateTargetBars("target");
		VUHDO_updateBouquetsForEvent("target", 22); -- VUHDO_UPDATE_UNIT_TARGET
		VUHDO_updatePanelVisibility();
	elseif ("CHAT_MSG_ADDON" == anEvent) then
		if (VUHDO_VARIABLES_LOADED) then
			VUHDO_parseAddonMessage(anArg1, anArg2, anArg4);
		end
	elseif ("READY_CHECK" == anEvent) then
		if (VUHDO_RAID ~= nil and (VUHDO_getPlayerRank()) >= 1) then
			VUHDO_readyStartCheck(anArg1, anArg2);
		end
	elseif ("READY_CHECK_CONFIRM" == anEvent) then
		if (VUHDO_RAID ~= nil and (VUHDO_getPlayerRank()) >= 1) then
			VUHDO_readyCheckConfirm(anArg1, anArg2);
		end
	elseif ("READY_CHECK_FINISHED" == anEvent) then
		if (VUHDO_RAID ~= nil and (VUHDO_getPlayerRank()) >= 1) then
			VUHDO_readyCheckEnds();
		end
	elseif("CVAR_UPDATE" == anEvent) then
		VUHDO_IS_SFX_ENABLED = tonumber(GetCVar("Sound_EnableSFX")) == 1;
		if (VUHDO_VARIABLES_LOADED) then
			VUHDO_reloadUI();
		end
	elseif("INSPECT_READY" == anEvent) then
		VUHDO_inspectLockRole();
	elseif("UNIT_CONNECTION" == anEvent) then
		if ((VUHDO_RAID or tEmptyRaid)[anArg1] ~= nil) then
			VUHDO_updateHealth(anArg1, VUHDO_UPDATE_DC);
		end
	elseif("ROLE_CHANGED_INFORM" == anEvent) then
		if (VUHDO_RAID_NAMES[anArg1] ~= nil) then
			VUHDO_resetTalentScan(VUHDO_RAID_NAMES[anArg1]);
		end
	elseif("MODIFIER_STATE_CHANGED" == anEvent) then
		if (VuhDoTooltip:IsShown()) then
			VUHDO_updateTooltip();
		end
	elseif("ACTIONBAR_SLOT_CHANGED" == anEvent) then
		if ((anArg1 or 0) >= 133 and anArg1 <= 136 and "SHAMAN" == VUHDO_PLAYER_CLASS) then
			VUHDO_setTotemSlotTo(anArg1);
		end
	elseif("PLAYER_LOGOUT" == anEvent) then
		VUHDO_compressAllBouquets();
	elseif("UNIT_NAME_UPDATE" == anEvent) then
		if ((VUHDO_RAID or tEmptyRaid)[anArg1] ~= nil) then
			VUHDO_resetNameTextCache();
			VUHDO_updateHealthBarsFor(anArg1, 7); -- VUHDO_UPDATE_AGGRO
		end
	elseif("PLAYER_EQUIPMENT_CHANGED" == anEvent) then
		VUHDO_aoeUpdateSpellAverages();
	elseif("LFG_PROPOSAL_SHOW" == anEvent) then
		VUHDO_buildSafeParty();
	elseif("LFG_PROPOSAL_FAILED" == anEvent) then
		VUHDO_quickRaidReload();
	elseif("LFG_PROPOSAL_SUCCEEDED" == anEvent) then
		VUHDO_lateRaidReload();
	--elseif("UPDATE_MACROS" == anEvent) then
		--VUHDO_timeReloadUI(0.1); -- @WARNING Lädt wg. shield macro alle 8 sec.
	elseif("UNIT_FACTION" == anEvent) then
		if ((VUHDO_RAID or tEmptyRaid)[anArg1] ~= nil) then
			VUHDO_updateBouquetsForEvent(anArg1, VUHDO_UPDATE_MINOR_FLAGS);
		end
	elseif("INCOMING_RESURRECT_CHANGED" == anEvent) then
		if ((VUHDO_RAID or tEmptyRaid)[anArg1] ~= nil) then
			VUHDO_updateBouquetsForEvent(anArg1, VUHDO_UPDATE_RESURRECTION);
		end
	else
		VUHDO_xMsg("Error: Unexpected event: " .. anEvent, anArg1, anArg2, anArg3, anArg4, anArg5, anArg6, anArg7, anArg8, anArg9, anArg10, anArg11, anArg12, anArg13, anArg14, anArg15, anArg16);
	end

	--[[tDuration = GetTime() - tDuration;
	if (tDuration > VUHDO_EVENT_TIMES[anEvent][1]) then
		VUHDO_EVENT_TIMES[anEvent][1] = tDuration;
	end
	VUHDO_EVENT_TIMES[anEvent][2] = VUHDO_EVENT_TIMES[anEvent][2] + tDuration;
	VUHDO_EVENT_TIMES[anEvent][3] = VUHDO_EVENT_TIMES[anEvent][3] + 1;
	VUHDO_EVENT_TIMES["all"] = VUHDO_EVENT_TIMES["all"] + tDuration;]]
end



--
local function VUHDO_setPanelsVisible(anIsVisible)
	if (not InCombatLockdown()) then
		VUHDO_CONFIG["SHOW_PANELS"] = anIsVisible;
		if (anIsVisible) then
			VUHDO_Msg(VUHDO_I18N_PANELS_SHOWN);
		else
			VUHDO_Msg(VUHDO_I18N_PANELS_HIDDEN);
		end
		VUHDO_redrawAllPanels();
		VUHDO_saveCurrentProfile();
	else
		VUHDO_Msg("Not possible during combat!");
	end
end



--
function VUHDO_slashCmd(aCommand)
	local tParsedTexts = VUHDO_textParse(aCommand);
	local tCommandWord = strlower(tParsedTexts[1]);

	if (strfind(tCommandWord, "opt")) then
		if (VuhDoNewOptionsTabbedFrame ~= nil) then
			if (InCombatLockdown() and not VuhDoNewOptionsTabbedFrame:IsShown()) then
				VUHDO_Msg("Options not available in combat!", 1, 0.4, 0.4);
			else
				VUHDO_CURR_LAYOUT = VUHDO_SPEC_LAYOUTS["selected"];
				VUHDO_CURRENT_PROFILE = VUHDO_CONFIG["CURRENT_PROFILE"];
				VUHDO_toggleMenu(VuhDoNewOptionsTabbedFrame);
			end
		else
			VUHDO_Msg(VUHDO_I18N_OPTIONS_NOT_LOADED, 1, 0.4, 0.4);
		end
	elseif (tCommandWord == "pt") then
		local tUnit, tName;

		if (tParsedTexts[2] ~= nil) then
			local tTokens = VUHDO_splitString(tParsedTexts[2], ",");
			if ("clear" == tTokens[1]) then
				table.wipe(VUHDO_PLAYER_TARGETS);
				VUHDO_quickRaidReload();
			else
				for _, tName in ipairs(tTokens) do
					tName = strtrim(tName);
					if (VUHDO_RAID_NAMES[tName] ~= nil and not InCombatLockdown()) then
						VUHDO_PLAYER_TARGETS[tName] = true;
					end
				end
				VUHDO_quickRaidReload();
			end
		else
			tUnit = VUHDO_RAID_NAMES[UnitName("target")];
			tName = (VUHDO_RAID[tUnit] or {})["name"];
			if (not InCombatLockdown() and tName ~= nil) then
				if (VUHDO_PLAYER_TARGETS[tName] ~= nil) then
					VUHDO_PLAYER_TARGETS[tName] = nil;
				else
					VUHDO_PLAYER_TARGETS[tName] = true;
				end
				VUHDO_quickRaidReload();
			end
		end

	elseif (tCommandWord == "load" and tParsedTexts[2] ~= nil) then
		local tTokens = VUHDO_splitString(tParsedTexts[2] .. (tParsedTexts[3] or ""), ",");
		if (#tTokens >= 2 and strlen(strtrim(tTokens[2])) > 0) then
			local tName = strtrim(tTokens[2]);
			if (VUHDO_SPELL_LAYOUTS[tName] ~= nil) then
				VUHDO_activateLayout(tName);
			else
				VUHDO_Msg(VUHDO_I18N_SPELL_LAYOUT_NOT_EXIST_1 .. tName .. VUHDO_I18N_SPELL_LAYOUT_NOT_EXIST_2, 1, 0.4, 0.4);
			end
		end
		if (#tTokens >= 1 and strlen(strtrim(tTokens[1])) > 0) then
			VUHDO_loadProfile(strtrim(tTokens[1]));
		end
	elseif (strfind(tCommandWord, "res")) then
		local tPanelNum;
		for tPanelNum = 1, VUHDO_MAX_PANELS do
			VUHDO_PANEL_SETUP[tPanelNum]["POSITION"] = nil;
		end
		VUHDO_BUFF_SETTINGS["CONFIG"]["POSITION"] = {
			["x"] = 100,
			["y"] = -100,
			["point"] = "TOPLEFT",
			["relativePoint"] = "TOPLEFT",
		};
		VUHDO_loadDefaultPanelSetup();
		VUHDO_reloadUI();
		VUHDO_Msg(VUHDO_I18N_PANELS_RESET);

	elseif (tCommandWord == "lock") then
		VUHDO_CONFIG["LOCK_PANELS"] = not VUHDO_CONFIG["LOCK_PANELS"];
		if (VUHDO_CONFIG["LOCK_PANELS"]) then
			VUHDO_Msg(VUHDO_I18N_LOCK_PANELS_PRE .. VUHDO_I18N_LOCK_PANELS_LOCKED);
		else
			VUHDO_Msg(VUHDO_I18N_LOCK_PANELS_PRE .. VUHDO_I18N_LOCK_PANELS_UNLOCKED);
		end
		VUHDO_saveCurrentProfile();

	elseif (tCommandWord == "show") then
		VUHDO_setPanelsVisible(true);

	elseif (tCommandWord == "hide") then
		VUHDO_setPanelsVisible(false);

	elseif (tCommandWord == "toggle") then
		VUHDO_setPanelsVisible(not VUHDO_CONFIG["SHOW_PANELS"]);

	elseif (strfind(tCommandWord, "cast") or strfind(tCommandWord, "mt")) then
		VUHDO_ctraBroadCastMaintanks();
		VUHDO_Msg(VUHDO_I18N_MTS_BROADCASTED);

	--[[elseif (tCommandWord == "pron") then
		SetCVar("scriptProfile", "1");
		ReloadUI();]]
	elseif (tCommandWord == "proff") then
		SetCVar("scriptProfile", "0");
		ReloadUI();
	--[[elseif (strfind(tCommandWord, "chkvars")) then
		for tFName, tData in pairs(VUHDO_GLOBAL) do
			if(strsub(tFName, 1, 1) == "t") then
				VUHDO_Msg("Emerging local variable " .. tFName);
			end
		end]]
	elseif (strfind(tCommandWord, "mm")
		or strfind(tCommandWord, "map")) then

		VUHDO_CONFIG["SHOW_MINIMAP"] = not VUHDO_CONFIG["SHOW_MINIMAP"];
		VUHDO_initShowMinimap();
		if (VUHDO_CONFIG["SHOW_MINIMAP"]) then
			VUHDO_Msg(VUHDO_I18N_MM_ICON .. VUHDO_I18N_CHAT_SHOWN);
		else
			VUHDO_Msg(VUHDO_I18N_MM_ICON .. VUHDO_I18N_CHAT_HIDDEN);
		end
	elseif (tCommandWord == "ui") then
		VUHDO_reloadUI();
	elseif (strfind(tCommandWord, "role")) then
		VUHDO_Msg("Roles have been reset.");
		table.wipe(VUHDO_MANUAL_ROLES);
		VUHDO_reloadUI();
	--[[elseif (tCommandWord == "test") then
		VUHDO_initProfiler();
		local tCnt;
		for tCnt = 1, 1000000 do
			VUHDO_updateAllDebuffIcons(false);
		end
		VUHDO_seeProfiler();]]
	--[[elseif (strfind(tCommandWord, "lfg1")) then
		VUHDO_OnEvent(_, "LFG_PROPOSAL_SHOW");
	elseif (strfind(tCommandWord, "lfg2")) then
		VUHDO_OnEvent(_, "LFG_PROPOSAL_FAILED");
	elseif (strfind(tCommandWord, "lfg3")) then
		VUHDO_OnEvent(_, "LFG_PROPOSAL_SUCCEEDED");]]
	--[[elseif (strfind(tCommandWord, "debug")) then
		VUHDO_DEBUG_AUTO_PROFILE = tonumber(tParsedTexts[2]);]]
	--elseif (strfind(tCommandWord, "test")) then
	--[[ elseif (tCommandWord == "find") then
		local tCnt;
		local tName = gsub(tParsedTexts[2], "_", " ");
		for tCnt = 1, 100000 do
			if (GetSpellInfo(tCnt) == tName) then
				VUHDO_Msg(GetSpellInfo(tCnt) .. ": " .. tCnt);
			end
		end
	]]
	elseif (aCommand == "?"
		or strfind(tCommandWord, "help")
		or aCommand == "") then
		local tLines = VUHDO_splitString(VUHDO_I18N_COMMAND_LIST, "§");
		local tCurLine;
		for _, tCurLine in ipairs(tLines) do
			VUHDO_MsgC(tCurLine);
		end
	else
		VUHDO_Msg(VUHDO_I18N_BAD_COMMAND, 1, 0.4, 0.4);
	end
end



--
function VUHDO_updateGlobalToggles()
	if (VUHDO_INSTANCE == nil) then
		return;
	end

	VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_THREAT_LEVEL] = VUHDO_isAnyoneInterstedIn(VUHDO_UPDATE_THREAT_LEVEL);
	if (VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_THREAT_LEVEL] or VUHDO_isAnyoneInterstedIn(VUHDO_UPDATE_AGGRO)) then
		VUHDO_INSTANCE:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE");
	else
		VUHDO_INSTANCE:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE");
	end

	VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_THREAT_PERC] = VUHDO_isAnyoneInterstedIn(VUHDO_UPDATE_THREAT_PERC);
	VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_AGGRO] = VUHDO_isAnyoneInterstedIn(VUHDO_UPDATE_AGGRO);

	if (not VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_THREAT_PERC] and not VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_AGGRO]) then
		VUHDO_TIMERS["UPDATE_AGGRO"] = -1;
	else
		VUHDO_TIMERS["UPDATE_AGGRO"] = 1;
	end

	VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_NUM_CLUSTER] = VUHDO_isAnyoneInterstedIn(VUHDO_UPDATE_NUM_CLUSTER);
	VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_MOUSEOVER_CLUSTER] = VUHDO_isAnyoneInterstedIn(VUHDO_UPDATE_MOUSEOVER_CLUSTER);
	VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_AOE_ADVICE] = VUHDO_isAnyoneInterstedIn(VUHDO_UPDATE_AOE_ADVICE);

	if (VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_NUM_CLUSTER]
	 or VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_MOUSEOVER_CLUSTER]
	 or VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_AOE_ADVICE]
	 or (VUHDO_CONFIG["DIRECTION"]["enable"] and VUHDO_CONFIG["DIRECTION"]["isDistanceText"])) then
		VUHDO_TIMERS["UPDATE_CLUSTERS"] = 1;

		if (VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_AOE_ADVICE]) then
			VUHDO_TIMERS["UPDATE_AOE"] = 1;
		else
			VUHDO_TIMERS["UPDATE_AOE"] = -1;
		end
	else
		VUHDO_TIMERS["UPDATE_CLUSTERS"] = -1;
		VUHDO_TIMERS["UPDATE_AOE"] = -1;
	end

	VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_MOUSEOVER] = VUHDO_isAnyoneInterstedIn(VUHDO_UPDATE_MOUSEOVER);
	VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_MOUSEOVER_GROUP] = VUHDO_isAnyoneInterstedIn(VUHDO_UPDATE_MOUSEOVER_GROUP);

	if (VUHDO_isAnyoneInterstedIn(VUHDO_UPDATE_MANA)
	 or VUHDO_isAnyoneInterstedIn(VUHDO_UPDATE_OTHER_POWERS)
	 or VUHDO_isAnyoneInterstedIn(VUHDO_UPDATE_ALT_POWER)) then
		VUHDO_INSTANCE:RegisterEvent("UNIT_DISPLAYPOWER");
		VUHDO_INSTANCE:RegisterEvent("UNIT_MAXPOWER");
		VUHDO_INSTANCE:RegisterEvent("UNIT_POWER");
	else
		VUHDO_INSTANCE:UnregisterEvent("UNIT_DISPLAYPOWER");
		VUHDO_INSTANCE:UnregisterEvent("UNIT_MAXPOWER");
		VUHDO_INSTANCE:UnregisterEvent("UNIT_POWER");
	end

	if (VUHDO_isAnyoneInterstedIn(VUHDO_UPDATE_UNIT_TARGET)) then
		VUHDO_INSTANCE:RegisterEvent("UNIT_TARGET");
		VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_UNIT_TARGET] = true;
		VUHDO_TIMERS["REFRESH_TARGETS"] = 1;
	else
		VUHDO_INSTANCE:UnregisterEvent("UNIT_TARGET");
		VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_UNIT_TARGET] = false;
		VUHDO_TIMERS["REFRESH_TARGETS"] = -1;
	end

	if (VUHDO_isAnyoneInterstedIn(VUHDO_UPDATE_ALT_POWER)) then
		VUHDO_INSTANCE:RegisterEvent("UNIT_POWER_BAR_SHOW");
		VUHDO_INSTANCE:RegisterEvent("UNIT_POWER_BAR_HIDE");
	else
		VUHDO_INSTANCE:UnregisterEvent("UNIT_POWER_BAR_SHOW");
		VUHDO_INSTANCE:UnregisterEvent("UNIT_POWER_BAR_HIDE");
	end

	if (VUHDO_CONFIG["IS_SCAN_TALENTS"]) then
		VUHDO_TIMERS["REFRESH_INSPECT"] = 1;
	else
		VUHDO_TIMERS["REFRESH_INSPECT"] = -1;
	end

	VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_PETS]
		= VUHDO_isModelConfigured(VUHDO_ID_PETS)
		or VUHDO_isModelConfigured(VUHDO_ID_SELF_PET); -- Event nicht deregistrieren => Problem mit manchen Vehikeln

	if (VUHDO_isModelConfigured(VUHDO_ID_PRIVATE_TANKS) and not VUHDO_CONFIG["OMIT_TARGET"]) then
		VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_PLAYER_TARGET] = true;
	else
		VUHDO_INTERNAL_TOGGLES[VUHDO_UPDATE_PLAYER_TARGET] = false;
	end

	if (VUHDO_CONFIG["SHOW_INCOMING"] or VUHDO_CONFIG["SHOW_OWN_INCOMING"]) then
		VUHDO_INSTANCE:RegisterEvent("UNIT_HEAL_PREDICTION");
	else
		VUHDO_INSTANCE:UnregisterEvent("UNIT_HEAL_PREDICTION");
	end

	if (VUHDO_CONFIG["PARSE_COMBAT_LOG"]) then
		VUHDO_INSTANCE:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	else
		VUHDO_INSTANCE:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	end

	if (VUHDO_CONFIG["IS_READY_CHECK_DISABLED"]) then
		VUHDO_INSTANCE:UnregisterEvent("READY_CHECK");
		VUHDO_INSTANCE:UnregisterEvent("READY_CHECK_CONFIRM");
		VUHDO_INSTANCE:UnregisterEvent("READY_CHECK_FINISHED");
	else
		VUHDO_INSTANCE:RegisterEvent("READY_CHECK");
		VUHDO_INSTANCE:RegisterEvent("READY_CHECK_CONFIRM");
		VUHDO_INSTANCE:RegisterEvent("READY_CHECK_FINISHED");
	end

end



--
function VUHDO_loadVariables()
	_, VUHDO_PLAYER_CLASS = UnitClass("player");
	VUHDO_PLAYER_NAME = UnitName("player");

	VUHDO_loadDefaultConfig();
	VUHDO_loadSpellArray();
	VUHDO_loadDefaultPanelSetup();
	VUHDO_initBuffSettings();
	VUHDO_initMinimap();
	VUHDO_loadDefaultBouquets();
	VUHDO_initClassColors();

	VUHDO_lnfPatchFont(VuhDoOptionsTooltipText, "Text");
end



--
local tOldAggro = { };
local tOldThreat = { };
local tTarget;
local tAggroUnit;
local tThreatPerc;
local tUnit, tInfo;
function VUHDO_updateAllAggro()
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		tOldAggro[tUnit] = tInfo["aggro"];
		tOldThreat[tUnit] = tInfo["threatPerc"];
		tInfo["aggro"] = false;
		tInfo["threatPerc"] = 0;
	end

	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if (tInfo["connected"] and not tInfo["dead"]) then
			if (VUHDO_INTERNAL_TOGGLES[7] and (tInfo["threat"] or 0) >= 2) then -- VUHDO_UPDATE_AGGRO
				tInfo["aggro"] = true;
			end
			tTarget = tInfo["targetUnit"];
			if (UnitIsEnemy(tUnit, tTarget)) then
				if (VUHDO_INTERNAL_TOGGLES[14]) then -- VUHDO_UPDATE_AGGRO
					_, _, tThreatPerc = UnitDetailedThreatSituation(tUnit, tTarget);
					tInfo["threatPerc"] = tThreatPerc or 0;
				end

				tAggroUnit = VUHDO_RAID_NAMES[UnitName(tTarget .. "target")];

				if (tAggroUnit ~= nil) then
					if (VUHDO_INTERNAL_TOGGLES[14]) then -- VUHDO_UPDATE_AGGRO
						_, _, tThreatPerc = UnitDetailedThreatSituation(tAggroUnit, tTarget);
						VUHDO_RAID[tAggroUnit]["threatPerc"] = tThreatPerc or 0;
					end

					if (sIsHealerMode and VUHDO_INTERNAL_TOGGLES[7]) then -- VUHDO_UPDATE_AGGRO
						VUHDO_RAID[tAggroUnit]["aggro"] = true;
					end
				end
			end
		else
			tInfo["aggro"] = false;
		end
	end

	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if (tInfo["aggro"] ~= tOldAggro[tUnit]) then
			VUHDO_updateHealthBarsFor(tUnit, 7); -- VUHDO_UPDATE_AGGRO
		end

		if (tInfo["threatPerc"] ~= tOldThreat[tUnit]) then
			VUHDO_updateBouquetsForEvent(tUnit, 14); -- VUHDO_UPDATE_THREAT_PERC
		end
	end
end
local VUHDO_updateAllAggro = VUHDO_updateAllAggro;



--
local tUnit, tInfo;
local tIsInRange, tIsCharmed;
local function VUHDO_updateAllRange()
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		tInfo["baseRange"] = UnitInRange(tUnit);
		tInfo["visible"] = UnitIsVisible(tUnit);

		-- Check if unit is charmed
		tIsCharmed = UnitIsCharmed(tUnit) and UnitCanAttack("player", tUnit) and not tInfo["dead"];
		if (tInfo["charmed"] ~= tIsCharmed) then
			tInfo["charmed"] = tIsCharmed;
			VUHDO_updateHealthBarsFor(tUnit, 4); -- VUHDO_UPDATE_DEBUFF
		end

		-- Check if unit is in range
		if (sIsRangeKnown) then
			tIsInRange
				= tInfo["connected"]
				 and (1 == IsSpellInRange(sRangeSpell, tUnit)
							or ((tInfo["dead"] or tInfo["charmed"]) and tInfo["baseRange"])
							or "player" == tUnit
							or ((tUnit == "focus" or tUnit == "target") and CheckInteractDistance(tUnit, 1))
						 );
		else
			tIsInRange
				= tInfo["connected"]
				 and (tInfo["baseRange"]
							or "player" == tUnit
							or ((tUnit == "focus" or tUnit == "target") and CheckInteractDistance(tUnit, 1))
						 );
		end

		if (tInfo["range"] ~= tIsInRange) then
			tInfo["range"] = tIsInRange;
			VUHDO_updateHealthBarsFor(tUnit, 5); -- VUHDO_UPDATE_RANGE
			if (sIsDirectionArrow and VUHDO_getCurrentMouseOver() == tUnit
				and (VuhDoDirectionFrame["shown"] or (not tIsInRange or VUHDO_CONFIG["DIRECTION"]["isAlways"]))) then

				VUHDO_updateDirectionFrame();
			end
		end

	end
end



--
function VUHDO_normalRaidReload(anIsReloadBuffs)
	if (VUHDO_isConfigPanelShowing()) then
		return;
	end
	VUHDO_TIMERS["RELOAD_RAID"] = 2.3;
	if (anIsReloadBuffs ~= nil) then
		VUHDO_IS_RELOAD_BUFFS = true;
	end
end



--
function VUHDO_quickRaidReload()
	VUHDO_TIMERS["RELOAD_RAID"] = 0.3;
end



--
function VUHDO_lateRaidReload()
	if (not VUHDO_isReloadPending()) then
		VUHDO_TIMERS["RELOAD_RAID"] = 5;
	end
end


--
function VUHDO_isReloadPending()
	return VUHDO_TIMERS["RELOAD_RAID"] > 0
		or VUHDO_TIMERS["RELOAD_UI"] > 0
		or VUHDO_IS_RELOADING;
end



--
function VUHDO_timeReloadUI(someSecs, anIsLnf)
	VUHDO_TIMERS["RELOAD_UI"] = someSecs;
	VUHDO_RELOAD_UI_IS_LNF = anIsLnf;
end



--
function VUHDO_timeRedrawPanel(aPanelNum, someSecs)
	VUHDO_RELOAD_PANEL_NUM = aPanelNum;
	VUHDO_TIMERS["RELOAD_PANEL"] = someSecs;
end



--
function VUHDO_setDebuffAnimation(aTimeSecs)
	VUHDO_DEBUFF_ANIMATION = aTimeSecs;
end



--
function VUHDO_initGcd()
	VUHDO_GCD_UPDATE = true;
end



--
local function VUHDO_doReloadRoster(anIsQuick)
	if (not VUHDO_isConfigPanelShowing()) then
		if (VUHDO_IS_RELOADING) then
			VUHDO_quickRaidReload();
		else
			VUHDO_rebuildTargets();

			if (InCombatLockdown()) then
				VUHDO_RELOAD_AFTER_BATTLE = true;

				VUHDO_IS_RELOADING = true;
				VUHDO_updateAllRaidBars();
				VUHDO_initAllEventBouquets();

				VUHDO_refreshRaidMembers();

				VUHDO_updateAllRaidBars();
				VUHDO_initAllEventBouquets();
				VUHDO_updatePanelVisibility();
				VUHDO_IS_RELOADING = false;
			else
				VUHDO_refreshUI();

				if (VUHDO_IS_RELOAD_BUFFS and not anIsQuick) then
					VUHDO_reloadBuffPanel();
					VUHDO_IS_RELOAD_BUFFS = false;
				end

				VUHDO_initHideBlizzRaid(); -- Scheint bei betreten eines Raids von aussen getriggert zu werden.
			end
		end

		VUHDO_initDebuffs(); -- Verzögerung nach Taltentwechsel-Spell?
	end
end



--
local sTimerDelta;
local function VUHDO_setTimerDelta(aTimeDelta)
	sTimerDelta = aTimeDelta;
end



--
local function VUHDO_checkResetTimer(aTimerName, aNextTick)

	if VUHDO_TIMERS[aTimerName] > 0 then
		VUHDO_TIMERS[aTimerName] = VUHDO_TIMERS[aTimerName] - sTimerDelta;
		if VUHDO_TIMERS[aTimerName] <= 0 then
			VUHDO_TIMERS[aTimerName] = aNextTick;
			return true;
		end
	end

	return false;
end


--
local function VUHDO_checkTimer(aTimerName)

	if VUHDO_TIMERS[aTimerName] > 0 then
		VUHDO_TIMERS[aTimerName] = VUHDO_TIMERS[aTimerName] - sTimerDelta;
		return VUHDO_TIMERS[aTimerName] <= 0;
	end

	return false;
end



--
local tTimeDelta = 0;
local tSlowDelta = 0;
local tAutoProfile;
local tUnit, tInfo;
local tGcdStart, tGcdDuration;
local tHotDebuffToggle = 1;
function VUHDO_OnUpdate(_, aTimeDelta)
	-----------------------------------------------------
	-- These need to update very frequenly to not stutter
	-- --------------------------------------------------

	-- Update custom debuff animation
	if (VUHDO_DEBUFF_ANIMATION > 0) then
		VUHDO_updateAllDebuffIcons(true);
		VUHDO_DEBUFF_ANIMATION = VUHDO_DEBUFF_ANIMATION - aTimeDelta;
	end

	-- Update GCD-Bar
	if (VUHDO_GCD_UPDATE and VUHDO_GCD_SPELLS[VUHDO_PLAYER_CLASS] ~= nil) then
		tGcdStart, tGcdDuration = GetSpellCooldown(VUHDO_GCD_SPELLS[VUHDO_PLAYER_CLASS]);
		if ((tGcdDuration or 0) == 0) then
			VuhDoGcdStatusBar:SetValue(0);
			VUHDO_GCD_UPDATE = false;
		else
			VuhDoGcdStatusBar:SetValue((tGcdDuration - (GetTime() - tGcdStart)) / tGcdDuration);
		end
	end

	-- Direction Arrow
	if (sIsDirectionArrow and VuhDoDirectionFrame["shown"]) then
		VUHDO_updateDirectionFrame();
	end

	---------------------------------------------------------
	-- From here 0.08 (80 msec) sec tick should be sufficient
	---------------------------------------------------------

	if (tTimeDelta < 0.08) then
		tTimeDelta = tTimeDelta + aTimeDelta;
		tSlowDelta = tSlowDelta + aTimeDelta;
		return;
	else
		VUHDO_setTimerDelta(aTimeDelta + tTimeDelta);
		tTimeDelta = 0;
	end

	-- reload UI?
	if (VUHDO_checkTimer("RELOAD_UI")) then
		if (VUHDO_IS_RELOADING or InCombatLockdown()) then
			VUHDO_TIMERS["RELOAD_UI"] = 0.3;
		else
			if (VUHDO_RELOAD_UI_IS_LNF) then
				VUHDO_lnfReloadUI();
			else
				VUHDO_reloadUI();
			end
			VUHDO_initOptions();
			VUHDO_FIRST_RELOAD_UI = true;
		end
	end

	-- redraw single panel?
	if (VUHDO_checkTimer("RELOAD_PANEL")) then
		if (VUHDO_IS_RELOADING or InCombatLockdown()) then
			VUHDO_TIMERS["RELOAD_PANEL"] = 0.3;
		else
			VUHDO_PROHIBIT_REPOS = true;
			VUHDO_initAllBurstCaches();
			VUHDO_redrawPanel(VUHDO_RELOAD_PANEL_NUM);
			VUHDO_updateAllPanelBars(VUHDO_RELOAD_PANEL_NUM);
			VUHDO_buildGenericHealthBarBouquet();
			VUHDO_buildGenericTargetHealthBouquet();
			collectgarbage('collect');
			VUHDO_registerAllBouquets(false);
			VUHDO_initAllEventBouquets();
			VUHDO_PROHIBIT_REPOS = false;
		end
	end

	---------------------------------------------------
	------------------------- below only if vars loaded
	---------------------------------------------------

	if (not VUHDO_VARIABLES_LOADED) then
		return;
	end

	-- Reload raid roster?
	if (VUHDO_checkTimer("RELOAD_RAID")) then
		VUHDO_doReloadRoster(false);
	end

	-- Quick update after raid roster change?
	if (VUHDO_checkTimer("RELOAD_ROSTER")) then
		VUHDO_doReloadRoster(true);
	end

	-- refresh HoTs, cyclic bouquets and customs debuffs?
	if (VUHDO_checkResetTimer("UPDATE_HOTS", sHotToggleUpdateSecs)) then
		if (tHotDebuffToggle == 1) then
			VUHDO_updateAllHoTs();
			if (VUHDO_INTERNAL_TOGGLES[18]) then -- VUHDO_UPDATE_MOUSEOVER_CLUSTER
				VUHDO_updateClusterHighlights();
			end
		elseif (tHotDebuffToggle == 2) then
			VUHDO_updateAllCyclicBouquets();
		else
			VUHDO_updateAllDebuffIcons(false);

			-- Reload after player gained control
			if (not HasFullControl()) then
				VUHDO_LOST_CONTROL = true;
			else
				if (VUHDO_LOST_CONTROL) then
					if (VUHDO_TIMERS["RELOAD_RAID"] <= 0) then
						VUHDO_TIMERS["CUSTOMIZE"] = 0.3;
					end
					VUHDO_LOST_CONTROL = false;
				end
			end
		end

		tHotDebuffToggle = tHotDebuffToggle + 1;
		if (tHotDebuffToggle > 3) then
			tHotDebuffToggle = 1;
		end
	end

	-- track dragged panel coords
	if (VUHDO_DRAG_PANEL ~= nil) then
		if (VUHDO_checkResetTimer("REFRESH_DRAG", 0.05)) then
			VUHDO_refreshDragTarget(VUHDO_DRAG_PANEL);
		end
	end

	-- Set Button colors without repositioning
	if (VUHDO_checkTimer("CUSTOMIZE")) then
		VUHDO_updateAllRaidTargetIndices();
		VUHDO_updateAllRaidBars();
		VUHDO_initAllEventBouquets();
	end

	-- Refresh Tooltip
	if (VUHDO_checkResetTimer("REFRESH_TOOLTIP", VUHDO_REFRESH_TOOLTIP_DELAY)) then
		if (VuhDoTooltip:IsShown()) then
			VUHDO_updateTooltip();
		end
	end

	-- Refresh custom debuff Tooltip
	if (VUHDO_checkResetTimer("REFRESH_CUDE_TOOLTIP", 1)) then
		VUHDO_updateCustomDebuffTooltip();
	end

	-- Refresh Buff Watch
	if (VUHDO_checkResetTimer("BUFF_WATCH", sBuffsRefreshSecs)) then
		VUHDO_updateBuffPanel();
	end

	-- Refresh Inspect, check timeout
	if (VUHDO_NEXT_INSPECT_UNIT ~= nil and GetTime() > VUHDO_NEXT_INSPECT_TIME_OUT) then
		VUHDO_setRoleUndefined(VUHDO_NEXT_INSPECT_UNIT);
		VUHDO_NEXT_INSPECT_UNIT = nil;
	end

	-- Refresh targets not in raid
	if (VUHDO_checkResetTimer("REFRESH_TARGETS", 0.51)) then
		VUHDO_updateAllOutRaidTargetButtons();
	end

	-----------------------------------------------------------------------------------------

	if (VUHDO_CONFIG_SHOW_RAID) then
		return;
	end


	-- refresh aggro?
	if (VUHDO_checkResetTimer("UPDATE_AGGRO", sAggroRefreshSecs)) then
		VUHDO_updateAllAggro();
	end

	-- refresh range?
	if (VUHDO_checkResetTimer("UPDATE_RANGE", sRangeRefreshSecs)) then
		VUHDO_updateAllRange();
	end

	-- Refresh Clusters
	if (VUHDO_checkResetTimer("UPDATE_CLUSTERS", sClusterRefreshSecs)) then
		VUHDO_updateAllClusters();
	end

	-- AoE advice
	if (VUHDO_checkResetTimer("UPDATE_AOE", sAoeRefreshSecs)) then
		VUHDO_aoeUpdateAll();
	end

	----------------------------------------------------
	------------------------- below only very slow tasks
	----------------------------------------------------
	if (tSlowDelta < 1.2) then
		tSlowDelta = tSlowDelta + aTimeDelta;
		return;
	else
		VUHDO_setTimerDelta(aTimeDelta + tSlowDelta);
		tSlowDelta = 0;
	end

	-- reload after battle
	if (VUHDO_RELOAD_AFTER_BATTLE and not InCombatLockdown()) then
		VUHDO_RELOAD_AFTER_BATTLE = false;

		if (VUHDO_TIMERS["RELOAD_RAID"] <= 0) then
			VUHDO_quickRaidReload();
			if (VUHDO_IS_RELOAD_BUFFS) then
				VUHDO_reloadBuffPanel();
				VUHDO_IS_RELOAD_BUFFS = false;
			end
		end
	end
	-- automatic profiles, shield cleanup, hide generic blizz party
	if (VUHDO_checkResetTimer("CHECK_PROFILES", 3.1)) then
		if (not InCombatLockdown()) then
			tAutoProfile, tTrigger = VUHDO_getAutoProfile();
			if (tAutoProfile ~= nil and not VUHDO_IS_CONFIG) then
				VUHDO_Msg(VUHDO_I18N_AUTO_ARRANG_1 .. tTrigger .. VUHDO_I18N_AUTO_ARRANG_2 .. "|cffffffff" .. tAutoProfile .. "|r\"");
				VUHDO_loadProfile(tAutoProfile);
			end
		end

		VUHDO_hideBlizzCompactPartyFrame();
		VUHDO_removeObsoleteShields();
	end

	-- Unit Zones
	if (VUHDO_checkResetTimer("RELOAD_ZONES", 3.45)) then
		for tUnit, tInfo in pairs(VUHDO_RAID) do
			tInfo["zone"], tInfo["map"] = VUHDO_getUnitZoneName(tUnit);
		end
	end

	if (VUHDO_NEXT_INSPECT_UNIT == nil and not InCombatLockdown()
		and VUHDO_checkResetTimer("REFRESH_INSPECT", 2.1)) then
		VUHDO_tryInspectNext();
	end

	-- Refresh d/c shield macros?
	if (VUHDO_checkTimer("MIRROR_TO_MACRO")) then
		if (InCombatLockdown()) then
			VUHDO_TIMERS["MIRROR_TO_MACRO"] = 2;
		else
			VUHDO_mirrorToMacro();
		end
	end
end



local VUHDO_ALL_EVENTS = {
	"VARIABLES_LOADED",	"PLAYER_ENTERING_WORLD",
	"UNIT_HEALTH", "UNIT_MAXHEALTH",
	"UNIT_AURA",
	"UNIT_TARGET",
	"RAID_ROSTER_UPDATE",
	"PARTY_MEMBERS_CHANGED",
	"UNIT_PET",
	"UNIT_ENTERED_VEHICLE", "UNIT_EXITED_VEHICLE", "UNIT_EXITING_VEHICLE",
	"CHAT_MSG_ADDON",
	"RAID_TARGET_UPDATE",
	"LEARNED_SPELL_IN_TAB",
	"PLAYER_FLAGS_CHANGED",
	"PLAYER_LOGOUT",
	"UNIT_DISPLAYPOWER", "UNIT_MAXPOWER", "UNIT_POWER",
	"UNIT_SPELLCAST_SENT", "UNIT_SPELLCAST_SUCCEEDED",
	"PARTY_MEMBER_ENABLE", "PARTY_MEMBER_DISABLE",
	"COMBAT_LOG_EVENT_UNFILTERED",
	"UNIT_THREAT_SITUATION_UPDATE",
	"UPDATE_BINDINGS",
	"PLAYER_TARGET_CHANGED", "PLAYER_FOCUS_CHANGED",
	"PLAYER_EQUIPMENT_CHANGED",
	"READY_CHECK", "READY_CHECK_CONFIRM", "READY_CHECK_FINISHED",
	"ROLE_CHANGED_INFORM",
	"CVAR_UPDATE",
	"INSPECT_READY",
	"MODIFIER_STATE_CHANGED",
	"UNIT_CONNECTION",
	"UNIT_HEAL_PREDICTION",
	"ACTIONBAR_SLOT_CHANGED",
	"UNIT_POWER_BAR_SHOW","UNIT_POWER_BAR_HIDE",
	"UNIT_NAME_UPDATE",
	"LFG_PROPOSAL_SHOW", "LFG_PROPOSAL_FAILED", "LFG_PROPOSAL_SUCCEEDED",
	--"UPDATE_MACROS",
	"UNIT_FACTION",
	"INCOMING_RESURRECT_CHANGED"
};



--
function VUHDO_OnLoad(anInstance)
	local _, _, _, tTocVersion = GetBuildInfo();

	if (tonumber(tTocVersion or 999999) < VUHDO_MIN_TOC_VERSION) then
		VUHDO_Msg(format(VUHDO_I18N_DISABLE_BY_VERSION, VUHDO_MIN_TOC_VERSION));
		return;
	end

	VUHDO_INSTANCE = anInstance;

	local tEvent;
	for _, tEvent in pairs(VUHDO_ALL_EVENTS) do
		anInstance:RegisterEvent(tEvent);
	end
	VUHDO_ALL_EVENTS = nil;

	SLASH_VUHDO1 = "/vuhdo";
	SLASH_VUHDO2 = "/vd";
	SlashCmdList["VUHDO"] = function(aMessage)
		VUHDO_slashCmd(aMessage);
	end

	anInstance:SetScript("OnEvent", VUHDO_OnEvent);
	anInstance:SetScript("OnUpdate", VUHDO_OnUpdate);

	VUHDO_Msg("VuhDo |cffffe566['vu:du:]|r v".. VUHDO_VERSION .. ". by Iza(ak)@Gilneas, dedicated to Vuh (use /vd)");
end
