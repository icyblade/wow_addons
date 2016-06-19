local GlobalAddonName, ExRT = ...

local max = max
local ceil = ceil
local UnitCombatlogname = ExRT.F.UnitCombatlogname
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitGUID = UnitGUID
local UnitName = UnitName
local UnitAura = UnitAura
local AntiSpam = ExRT.F.AntiSpam
local GetUnitInfoByUnitFlag = ExRT.F.GetUnitInfoByUnitFlag
local UnitInRaid = UnitInRaid
local UnitIsPlayerOrPet = ExRT.F.UnitIsPlayerOrPet
local GUIDtoID = ExRT.F.GUIDtoID
local GetUnitTypeByGUID = ExRT.F.GetUnitTypeByGUID
local UnitIsFeignDeath = UnitIsFeignDeath
local pairs = pairs
local GetTime = GetTime
local UnitIsFriendlyByUnitFlag = ExRT.F.UnitIsFriendlyByUnitFlag
local wipe = wipe
local UnitPosition = UnitPosition
local bit_band = bit.band
local tremove = tremove
local strsplit = strsplit
local dtime = ExRT.F.dtime

local VExRT = nil

local module = ExRT.mod:New("BossWatcher",ExRT.L.BossWatcher)
local ELib,L = ExRT.lib,ExRT.L

local is6 = not ExRT.is7

module.db.data = {
	{
		guids = {},
		reaction = {},
		fight = {},
		pets = {},
		encounterName = nil,
		encounterStartGlobal = time(),
		encounterStart = GetTime(),
		encounterEnd = GetTime()+1,
		isEnded = true,
		graphData = {},
		positionsData = {},
		fightID = 0,
	},
}
module.db.nowData = {}
module.db.nowNum = 1
local fightData,guidData,graphData,reactionData,positionsData = nil

module.db.lastFightID = 0
module.db.timeFix = nil

module.db.spellsSchool = {}
local spellsSchool = module.db.spellsSchool

local deathLog = {}
module.db.deathLog = deathLog

local raidGUIDs = {}

local damageTakenLog = {}
module.db.damageTakenLog = damageTakenLog

local spellFix_LotM = {}

module.db.buffsFilters = {
[1] = {[-1]=L.BossWatcherFilterOnlyBuffs,}, --> Only buffs
[2] = {[-1]=L.BossWatcherFilterOnlyDebuffs,}, --> Only debuffs
[3] = {[-1]=L.BossWatcherFilterBySpellID,}, --> By spellID
[4] = {[-1]=L.BossWatcherFilterBySpellName,}, --> By spellName
[5] = {
	[-1]=L.BossWatcherFilterTaunts,
	[-2]={62124,130793,17735,97827,56222,51399,49560,6795,355,115546,116189},
},
[6] = {
	[-1]=L.BossWatcherFilterStun,
	[-2]={853,105593,91797,408,119381,89766,118345,46968,107570,5211,44572,119392,122057,113656,108200,108194,30283,118905,20549,119072,115750},
},
[7] = {
	[-1]=L.BossWatcherFilterPersonal,
	[-2]={148467,31224,110788,55694,47585,31850,115610,122783,642,5277,118038,104773,115176,48707,1966,61336,120954,871,106922,30823,6229,22812,498},
},
[8] = {
	[-1]=L.BossWatcherFilterRaidSaves,
	[-2]={145629,114192,114198,81782,108281,97463,31821,15286,115213,44203,64843,76577},
},
[9] = {
	[-1]=L.BossWatcherFilterPotions,
	[-2]={105702,105697,105706,105701,105707,105698,125282,
		156426,156423,156428,156432,156430},
},
[10] = {
	[-1]=L.BossWatcherFilterPandaria,
	[-2]={148010,146194,146198,146200,137593,137596,137590,137288,137323,137326,137247,137331},
},
[11] = {
	[-1]=L.BossWatcherFilterTier16,
	[-2]={143524,143460,143459,143198,143434,143023,143840,143564,143959,146022,144452,144351,144358,146594,144359,144364,145215,144574,144683,144684,144636,146822,147029,147068,146899,
		144467,144459,146325,144330,144089,143494,143638,143480,143882,143589,143594,143593,143536,142990,143919,142913,143385,144236,143856,144466,145987,145747,143442,143411,143445,
		143791,146589,142534,142532,142533,142671,142948,143337,143701,143735,145213,147235,147209,144762,148994,148983,144817,145171,145065,147324},
},
[12] = {
	[-1]=L.RaidLootT17Highmaul,
	[-2]={
		159178,159113,159947,158986,
		156151,156152,156160,
		162346,162475,
		163242,159280,163663,159253,159426,
		158241,159709,155569,167200,163372,163297,158200,157943,
		162184,162186,172813,161345,162185,161242,156803,160734,
		157763,156225,164004,164005,164006,164176,164178,
	},
},
[13] = {
	[-1]=L.RaidLootT17BF,
	[-2]={
		-- Gruul: ???
		173471,155900,156834,
		155236,154960,155061,154981,
		154952,154932,
		-- Hans'gar and Franzok: ???
		159481,
		155196,155225,155192,174716,
		157059,161923,161839,
		156006,
		156653,156096,
	}
},
}
module.db.buffsFilterStatus = {}

module.db.autoSegmentEvents = {"UNIT_SPELLCAST_SUCCEEDED","SPELL_AURA_REMOVED","SPELL_AURA_APPLIED","UNIT_DIED","CHAT_MSG_RAID_BOSS_EMOTE"}
module.db.autoSegmentEventsL = {
	["UNIT_SPELLCAST_SUCCEEDED"] = L.BossWatcherSegmentEventsUSS,
	["SPELL_AURA_REMOVED"] = L.BossWatcherSegmentEventsSAR,
	["SPELL_AURA_APPLIED"] = L.BossWatcherSegmentEventsSAA,
	["UNIT_DIED"] = L.BossWatcherSegmentEventsUD,
	["CHAT_MSG_RAID_BOSS_EMOTE"] = L.BossWatcherSegmentEventsCMRBE,
}
module.db.autoSegments = {
	["UNIT_DIED"] = {},
	["SPELL_AURA_APPLIED"] = {},
	["SPELL_AURA_REMOVED"] = {},
	["UNIT_SPELLCAST_SUCCEEDED"] = {},
	["CHAT_MSG_RAID_BOSS_EMOTE"] = {},
}
local autoSegmentsUPValue = module.db.autoSegments

module.db.segmentsLNames = {
	["UNIT_SPELLCAST_SUCCEEDED"] = L.BossWatcherSegmentNamesUSS,
	["SPELL_AURA_REMOVED"] = L.BossWatcherSegmentNamesSAR,
	["SPELL_AURA_APPLIED"] = L.BossWatcherSegmentNamesSAA,
	["UNIT_DIED"] = L.BossWatcherSegmentNamesUD,
	['ENCOUNTER_START'] = L.BossWatcherSegmentNamesES,
	["SLASH"] = L.BossWatcherSegmentNamesSC,
	["CHAT_MSG_RAID_BOSS_EMOTE"] = L.BossWatcherSegmentNamesCMRBE,
}
module.db.registerOtherEvents = {}

module.db.raidTargets = {0x1,0x2,0x4,0x8,0x10,0x20,0x40,0x80}
module.db.energyLocale = is6 and {
	[0] = "|cff69ccf0"..L.BossWatcherEnergyType0,
	[1] = "|cffedc294"..L.BossWatcherEnergyType1,
	[2] = "|cffd1fa99"..L.BossWatcherEnergyType2,
	[3] = "|cffffff8f"..L.BossWatcherEnergyType3,
	[4] = "|cfffff569"..L.BossWatcherEnergyType4,
	[5] = "|cffeb4561"..L.BossWatcherEnergyType5,
	[6] = "|cffeb4561"..L.BossWatcherEnergyType6,
	[7] = "|cff9482c9"..L.BossWatcherEnergyType7,
	[8] = "|cffffa330"..L.BossWatcherEnergyType8,
	[9] = "|cffffb3e0"..L.BossWatcherEnergyType9,
	[10] = "|cffffffff"..L.BossWatcherEnergyType10,
	[12] = "|cff4DbB98"..L.BossWatcherEnergyType12,
	[13] = "|cffd9d9d9"..L.BossWatcherEnergyType13,
	[14] = "|cffeb4561"..L.BossWatcherEnergyType14,
	[15] = "|cff9482c9"..L.BossWatcherEnergyType15,
} or {
	[0] = "|cff69ccf0"..L.BossWatcherEnergyType0,
	[1] = "|cffedc294"..L.BossWatcherEnergyType1,
	[2] = "|cffd1fa99"..L.BossWatcherEnergyType2,
	[3] = "|cffffff8f"..L.BossWatcherEnergyType3,
	[4] = "|cfffff569"..L.BossWatcherEnergyType4,
	[5] = "|cffeb4561"..L.BossWatcherEnergyType5,
	[6] = "|cffeb4561"..L.BossWatcherEnergyType6,
	[7] = "|cff9482c9"..L.BossWatcherEnergyType7,
	[8] = "|cff"..format("%02x%02x%02x",113,0,197)..L.BossWatcherEnergyType8,
	[9] = "|cffffb3e0"..L.BossWatcherEnergyType9,
	[10] = "|cffffffff"..L.BossWatcherEnergyType10,
	[11] = "|cff"..format("%02x%02x%02x",0,143,255)..L.BossWatcherEnergyType11,
	[12] = "|cff4DbB98"..L.BossWatcherEnergyType12,
	[13] = "|cff"..format("%02x%02x%02x",51,0,102)..L.BossWatcherEnergyType13,
	[16] = "|cff"..format("%02x%02x%02x",0,255,255)..L.BossWatcherEnergyType16,
	[17] = "|cff"..format("%02x%02x%02x",209,76,223)..L.BossWatcherEnergyType17,
	[18] = "|cff"..format("%02x%02x%02x",255,147,0)..L.BossWatcherEnergyType18,
}

module.db.energyPerClass = {
	--class		--for all	--for player
	["WARRIOR"] = 	{{1,10},	{1,10}},
	["PALADIN"] = 	{{0,10},	{0,9,10}},
	["HUNTER"] = 	{{2,10},	{2,10}},
	["ROGUE"] = 	{{3,10},	{2,4,10}},
	["PRIEST"] = 	{{0,10},	{0,10,13}},
	["DEATHKNIGHT"]={{6,10},	{5,6,10}},
	["SHAMAN"] = 	{{0,10},	{0,10,11}},
	["MAGE"] = 	{{0,10},	{0,10,16}},
	["WARLOCK"] = 	{{0,10},	{0,10,7,14,15}},
	["MONK"] = 	{{0,3,10},	{0,3,10,12}},
	["DRUID"] = 	{{0,1,3,10},	{0,3,4,8,10}},
	["DEMONHUNTER"]={{0,17,18,10},	{0,17,18,10}},
	["NO"] = 	{{0,1,2,3,6,10},{0,1,2,3,6,10,5,7,8,9,11,12,13,14,15,16,17,18}},
}

module.db.schoolsDefault = {0x1,0x2,0x4,0x8,0x10,0x20,0x40}
module.db.schoolsColors = {
	[SCHOOL_MASK_NONE]	= {r=.8,g=.8,b=.8},
	[SCHOOL_MASK_PHYSICAL]	= {r=1,g=.64,b=.19},
	[SCHOOL_MASK_HOLY] 	= {r=1,g=1,b=.56},
	[SCHOOL_MASK_FIRE] 	= {r=.92,g=.27,b=.38},
	[SCHOOL_MASK_NATURE] 	= {r=.6,g=1,b=.4},	--r=.82,g=.98,b=.6
	[SCHOOL_MASK_FROST] 	= {r=.29,g=.50,b=1},
	[SCHOOL_MASK_SHADOW] 	= {r=.72,g=.66,b=.94},
	[SCHOOL_MASK_ARCANE] 	= {r=.56,g=.95,b=1},
	
	[0x1C] = {r=1,g=.3,b=1},	--Elemental
	[0x7C] = {r=.6,g=0,b=0},	--Chromatic
	[0x7E] = {r=1,g=0,b=0},		--Magic
	[0x7F] = {r=.25,g=.25,b=.25},	--Chaos
}
module.db.schoolsNames = {
	[SCHOOL_MASK_NONE]	= L.BossWatcherSchoolUnknown,
	[SCHOOL_MASK_PHYSICAL]	= L.BossWatcherSchoolPhysical,
	[SCHOOL_MASK_HOLY] 	= L.BossWatcherSchoolHoly,
	[SCHOOL_MASK_FIRE] 	= L.BossWatcherSchoolFire,
	[SCHOOL_MASK_NATURE] 	= L.BossWatcherSchoolNature,
	[SCHOOL_MASK_FROST] 	= L.BossWatcherSchoolFrost,
	[SCHOOL_MASK_SHADOW] 	= L.BossWatcherSchoolShadow,
	[SCHOOL_MASK_ARCANE] 	= L.BossWatcherSchoolArcane,
	
	[0x1C] = L.BossWatcherSchoolElemental,	--Elemental
	[0x7C] = L.BossWatcherSchoolChromatic,	--Chromatic
	[0x7E] = L.BossWatcherSchoolMagic,		--Magic
	[0x7F] = L.BossWatcherSchoolChaos,		--Chaos
}

local ReductionAurasFunctions = {
	physical = 1,
	magic = 2,
	feintCheck = 3,
	dampenHarmCheck = 4,
}
module.db.reductionAuras = {
	--Paladin
	[115668] = 0.9,		--Glyph of Templar's Verdict
	[6940] = 0.7,		--Hand of Sacrifice
	[498] = {0.6,ReductionAurasFunctions.magic,function(physical,magic) if magic == 0 then return 0.6,ReductionAurasFunctions.magic else return 0.8 end end},	--Divine Protection
	[31821] = 0.8,		--Devotion Aura
	[31850] = 0.8,		--Ardent Defender
	[86659] = 0.5,		--Guardian of Ancient Kings
	[114039] = 0.85,	--Hand of Purity
	[132403] = {1,ReductionAurasFunctions.physical,function(auraVar) return (100+auraVar)/100,ReductionAurasFunctions.physical end},	--Shield of the Righteous
	
	--Warrior
	[71] = 0.8,		--Defensive Stance
	[118038] = 0.7,		--Die by the Sword
	[114030] = 0.7,		--Vigilance
	[871] = {0.6,nil,function(auraVar) return (100+auraVar)/100 end},		--Shield Wall
	
	--Hunter
	[148467] = {0.7,nil,function(_,_,_,_,auraVar) return (100+auraVar)/100 end},	--Deterrence
	[51755] = {1,nil,function(_,_,_,auraVar) return (100+auraVar)/100 end},		--Camouflage
	
	--Priest
	[45242] = 0.7,		--Focused Will
	[33206] = 0.6,		--Pain Suppression
	[81782] = 0.75,		--Power Word: Barrier
	[47585] = 0.1,		--Dispersion
	[586] = {1,nil,function(_,auraVar) return (100+auraVar)/100 end},		--Fade
	
	--DK
	[48792] = {0.8,nil,function(_,_,auraVar) return (100+auraVar)/100 end},		--Icebound Fortitude
	[49222] = 0.8,		--Bone Shield
	[171049] = 0.6,		--Rune Tap
	[145629] = {0.8,ReductionAurasFunctions.magic},		--Anti-Magic Zone
	[48263] = 0.9,		--Blood Presence
	
	--Shaman
	[30823] = 0.7,		--Shamanistic Rage
	[142912] = 0.9,		--Glyph of Lightning Shield
	[108271] = 0.6,		--Astral Shift
	[118347] = 0.8,		--Reinforce
	
	--Mage
	[113862] = 0.1,		--Greater Invisibility
	[110960] = 0.1,		--Greater Invisibility
	
	--Rouge
	[1966] = {0.5,ReductionAurasFunctions.feintCheck},		--Feint
	[31224] = {1,nil,function(_,_,auraVar) return (100+auraVar)/100,ReductionAurasFunctions.physical end},	--Cloak of Shadows
	
	--Warlock
	[104773] = {0.6,nil,function(_,_,auraVar) return (100+auraVar)/100 end},		--Unending Resolve
	
	--Monk
	[122278] = {0.5,ReductionAurasFunctions.dampenHarmCheck},	--Dampen Harm		Note: for HP ~363k (700 gear); may work incorrect: hit for 56k will be reducted to 28k and doesn't counting, so only big hits will be recorded
	[120954] = {0.8,nil,function(_,auraVar) return (100+auraVar)/100 end},		--Fortifying Brew
	[122783] = {0.1,ReductionAurasFunctions.magic},		--Diffuse Magic
	[115176] = 0.1,		--Zen Meditation
	
	--Druid
	[22812] = 0.8,		--Barkskin
	[102342] = 0.8,		--Ironbark
	[155835] = 0.6,		--Bristling Fur
	[61336] = 0.5,		--Survival Instincts
	[768] = 1,		--Cat Form
	
	--Other
	[65116] = {0.9,ReductionAurasFunctions.physical},	--Stoneform
	[185103] = {0.94,nil,function(auraVar) return (100+auraVar)/100 end},	--Priest Archimonde trinket
}
module.db.reductionBySpec = {
	[63] = {16931,	0.94,	ReductionAurasFunctions.physical,	0x4},	--Mage fire
	[66] = {105805,	0.9},		--Paladin prot
	[104] = {16931,	0.9},		--Druid bear
	[268] = {115069,0.85,	ReductionAurasFunctions.magic},		--Monk brew
	--[105] = {16931,	0.9},	--Test on myself
}
module.db.reductionCurrent = {}
module.db.reductionPowerWordBarrierCaster = nil

module.db.reductionIsNotAoe = {	--Spells list from BRF,HC that isnot aoe (Rouge Feint check)
	-- Note: I'm so lazy to update this after creating: too much work for func that is super rare usable
	[6603]=true, 	[156888]=true, 	[156203]=true,	[156879]=true,	[175020]=true,	[163284]=true,
	[155314]=true,	[162322]=true,	[156772]=true,	[155611]=true,	[155657]=true,	[162498]=true,
	[156297]=true,	[156823]=true,	[173471]=true,	[158140]=true,	[175013]=true,	[155923]=true,
	[165298]=true,	[156938]=true,	[156646]=true,	[156824]=true,	[173192]=true,	[162277]=true,
	[156604]=true,	[155030]=true,	[156825]=true,	[156617]=true,	[161570]=true,	[155900]=true,
	[162976]=true,	[159044]=true,	[156401]=true,	[179201]=true,	[164380]=true,	[165195]=true,
	[163754]=true,	[155921]=true,	[156270]=true,	[156310]=true,	[155701]=true,	[156669]=true,
	[155841]=true,	[158601]=true,	[158080]=true,	[158321]=true,	[156280]=true,	[158709]=true,
	[160436]=true,	[158009]=true,	[158686]=true,	[158710]=true,	[156214]=true,	[157059]=true,
	[173939]=true,	[157247]=true,	[155242]=true,	[158246]=true,	[176133]=true,	[155223]=true,
	[155743]=true,	[155201]=true,	[156932]=true,
	
	[182074]=true,	[179897]=true,	[182159]=true,	[180389]=true,	[180199]=true,	[184396]=true,
	[180618]=true,	[184874]=true,	[182600]=true,	[185239]=true,	[182325]=true,	[181832]=true,
	[181295]=true,	[179995]=true,	[185053]=true,	[185189]=true,	[182601]=true,	[186770]=true,
	[187815]=true,	[179428]=true,	[181653]=true,	[185426]=true,	[187819]=true,	[180270]=true,
	[181345]=true,	[185519]=true,	[185521]=true,	[186559]=true,	[186560]=true,	[187169]=true,
	[181305]=true,	[181082]=true,	[184990]=true,	[180569]=true,	[180252]=true,	[180604]=true,
	[180533]=true,	[180600]=true,	[182218]=true,	[184239]=true,	[185066]=true,	[185065]=true,
	[184652]=true,	[184847]=true,	[186993]=true,	[184681]=true,	[184675]=true,	[183226]=true,
	[184676]=true,	[181122]=true,	[181358]=true,	[181359]=true,	[183610]=true,	[182171]=true,
	[181276]=true,	[184252]=true,	[181841]=true,	[182088]=true,	[185826]=true,	[182031]=true,
	[188208]=true,	[186073]=true,	[186448]=true,	[186500]=true,	[186063]=true,	[186785]=true,
	[186271]=true,	[186547]=true,	[186292]=true,	[183586]=true,	[183828]=true,	[184964]=true,
	[190049]=true,	[187047]=true,	[189891]=true,	[187255]=true,	[183864]=true,	[188796]=true,
}

module.db.def_trackingDamageSpells = {
	[181913]=1788,	--Shadow-Lord Iskar: Focused Blast
	[190194]=1800,	--Xhul'horac: Empowered Chains of Fel
	[186549]=1800,	--Xhul'horac: Singularity
	[189781]=1800,	--Xhul'horac: Empowered Singularity
	[185656]=1800,	--Xhul'horac: Shadowfel Annihilation
	[180161]=1784,	--Tyrant Velhari: Edict of Condemnation
	[181617]=1795,	--Mannoroth: Mannoroth's Gaze
	[182011]=1795,	--Mannoroth: Empowered Mannoroth's Gaze
	[185008]=1799,	--Archimonde: Unleashed Torment
	[190399]=1799,	--Archimonde: Mark of the Legion
	--[2812]=true,	--Test
	[198099]=1841,	--Ursoc: Barreling Momentum
	[199237]=1841,	--Ursoc: Barreling Momentum > Crushing Impact
	[210074]=1849,	--Crystal Scorpion: Shockwave
	[204733]=1849,	--Crystal Scorpion: Volatile Chitin
	[211073]=1877,	--Cenarius: Desiccating Stomp
	[210619]=1877,	--Cenarius: Destructive Nightmares
	[209471]=1873,	--Il'gynoth: Nightmare Explosion
}

local var_reductionAuras,var_reductionCurrent = module.db.reductionAuras,module.db.reductionCurrent
local var_trackingDamageSpells = nil

local encounterSpecial = {}

local AddSegmentToData = nil
local StartSegment = nil
local UpdateCLEUfunctionsByEncounter = nil
local _graphSectionTimer,_graphSectionTimerRounded,_graphRaidSnapshot = 0,0,{}
local _positionsTimer,_positionsTimerRounded,_positionsRaidSnapshot = 0,0,{}
local _graphRaidEnergy = {}

local _BW_Start,_BW_End = nil

local fightData_damage,fightData_damage_seen,fightData_heal,fightData_healFrom,fightData_switch,fightData_cast,fightData_auras,fightData_power,fightData_deathLog,fightData_maxHP,fightData_reduction

local function UpdateNewSegmentEvents(clear)
	wipe(module.db.autoSegments.UNIT_DIED)
	wipe(module.db.autoSegments.SPELL_AURA_APPLIED)
	wipe(module.db.autoSegments.SPELL_AURA_REMOVED)
	wipe(module.db.autoSegments.UNIT_SPELLCAST_SUCCEEDED)
	wipe(module.db.autoSegments.CHAT_MSG_RAID_BOSS_EMOTE)
	wipe(module.db.registerOtherEvents)
	if clear then
		return
	end
	for i=1,10 do
		if VExRT.BossWatcher.autoSegments[i] and VExRT.BossWatcher.autoSegments[i][1] and VExRT.BossWatcher.autoSegments[i][2] then
			module.db.autoSegments[ VExRT.BossWatcher.autoSegments[i][2] ][ VExRT.BossWatcher.autoSegments[i][1] ] = true
			if VExRT.BossWatcher.autoSegments[i][2] == 'UNIT_SPELLCAST_SUCCEEDED' then
				module.db.registerOtherEvents['UNIT_SPELLCAST_SUCCEEDED'] = true
			end
			if VExRT.BossWatcher.autoSegments[i][2] == 'CHAT_MSG_RAID_BOSS_EMOTE' then
				module.db.registerOtherEvents['CHAT_MSG_RAID_BOSS_EMOTE'] = true
			end
		end
	end
end

do
	local function CheckForCombat()
		if UnitAffectingCombat("player") or IsEncounterInProgress() then
			_BW_Start()
		end
	end
	
	function module:Enable()
		VExRT.BossWatcher.enabled = true
		
		module:RegisterEvents('ZONE_CHANGED_NEW_AREA','PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED','ENCOUNTER_START','ENCOUNTER_END','CHALLENGE_MODE_START','CHALLENGE_MODE_COMPLETED','CHALLENGE_MODE_RESET')
		module.main:ZONE_CHANGED_NEW_AREA()
		module:RegisterSlash()
		
		UpdateNewSegmentEvents()
		
		if UnitAffectingCombat("player") then
			_BW_Start()
		else
			ExRT.F.Timer(CheckForCombat,3)
		end
	end
end

function module:Disable()
	VExRT.BossWatcher.enabled = nil
	
	if fightData then
		_BW_End()
	end
	
	module.main:UnregisterAllEvents()
	module:UnregisterSlash()
end

local BWInterfaceFrame = nil
local BWInterfaceFrameLoad,isBWInterfaceFrameLoaded,BWInterfaceFrameLoadFunc = nil
do
	local isAdded = nil
	function BWInterfaceFrameLoadFunc()
		if not isBWInterfaceFrameLoaded then
			BWInterfaceFrameLoad()
		end
		if isBWInterfaceFrameLoaded then
			InterfaceOptionsFrame:Hide()
			BWInterfaceFrame:Show()
		end
		CloseDropDownMenus() 
	end
	function module:miniMapMenu()
		if isAdded then
			return
		end
		local subMenu = {
			{text = L.BossWatcher, func = BWInterfaceFrameLoadFunc, notCheckable = true},
			{text = L.BossWatcherTabMobs, func = ExRT.F.FightLog_OpenTab, arg1 = 1, notCheckable = true},
			{text = L.BossWatcherTabHeal, func = ExRT.F.FightLog_OpenTab, arg1 = 2, notCheckable = true},
			{text = L.BossWatcherTabBuffsAndDebuffs, func = ExRT.F.FightLog_OpenTab, arg1 = 3, notCheckable = true},
			{text = L.BossWatcherTabEnemy, func = ExRT.F.FightLog_OpenTab, arg1 = 4, notCheckable = true},
			{text = L.BossWatcherTabPlayersSpells, func = ExRT.F.FightLog_OpenTab, arg1 = 5, notCheckable = true},
			{text = L.BossWatcherTabEnergy, func = ExRT.F.FightLog_OpenTab, arg1 = 6, notCheckable = true},
			{text = L.BossWatcherTabInterruptAndDispel, func = ExRT.F.FightLog_OpenTab, arg1 = 7, notCheckable = true},
			{text = TRACKING, func = ExRT.F.FightLog_OpenTab, arg1 = 8, notCheckable = true},
			{text = L.BossWatcherDeath, func = ExRT.F.FightLog_OpenTab, arg1 = 9, notCheckable = true},
			{text = L.BossWatcherPositions, func = ExRT.F.FightLog_OpenTab, arg1 = 10, notCheckable = true},
		}
		ExRT.F.MinimapMenuAdd(L.BossWatcher, BWInterfaceFrameLoadFunc, 1, "FightLog_Navigation", subMenu)
	end
	module:RegisterMiniMapMenu()
end
ExRT.F.FightLog_Open = BWInterfaceFrameLoadFunc

function ExRT.F:FightLog_OpenTab(tabID)
	if not isBWInterfaceFrameLoaded then
		BWInterfaceFrameLoad()
	end
	BWInterfaceFrame.tab:SelectTab(tabID)
	BWInterfaceFrame:Show()
	
	CloseDropDownMenus()
end

function module.options:Load()
	self:CreateTilte()

	self.checkEnabled = ELib:Check(self,L.senable,VExRT.BossWatcher.enabled):Point(15,-35):OnClick(function(self) 
		if self:GetChecked() then
			module:Enable()
		else
			module:Disable()
		end
	end)
	self.checkImproved = ELib:Check(self,L.BossWatcherOptionImproved,VExRT.BossWatcher.Improved):Point(15,-60):Tooltip(L.BossWatcherOptionImprovedTooltip):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.BossWatcher.Improved = true
		else
			VExRT.BossWatcher.Improved = nil
		end
	end)
	
	self.checkShowGUIDs = ELib:Check(self,L.BossWatcherChkShowGUIDs,VExRT.BossWatcher.GUIDs):Point(15,-85):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.BossWatcher.GUIDs = true
		else
			VExRT.BossWatcher.GUIDs = nil
		end
	end)
	
	self.sliderNum = ELib:Slider(self,L.BossWatcherOptionsFightsSave):Size(300):Point(20,-125):Range(1,15):SetTo(VExRT.BossWatcher.fightsNum or 1):OnChange(function(self,event) 
		event = ExRT.F.Round(event)
		VExRT.BossWatcher.fightsNum = event
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	self.warningText = ELib:Text(self,L.BossWatcherOptionsFightsWarning,12):Size(570,25):Point(15,-150):Top():Color():Shadow()
	
	if ExRT.T == "Dev" then
		self.saveVariables = ELib:Check(self,L.BossWatcherSaveVariables):Point(260,-35):Tooltip(L.BossWatcherSaveVariablesWarring):OnClick(function(self) 
			VExRT.BossWatcher.saveVariables = true
			VExRT.BossWatcher.SAVED_DATA = module.db.data
			print('Saved')
		end)
	end
	
	self.showButton = ELib:Button(self,L.BossWatcherGoToBossWatcher):Size(550,20):Point("TOP",0,-200):OnClick(function ()
		InterfaceOptionsFrame:Hide()
		ExRT.Options.Frame:Hide()
		BWInterfaceFrameLoadFunc()
	end)
	self.buttonChecker = CreateFrame("Frame",nil,self)
	self.buttonChecker:SetScript("OnShow",function (self)
		if not ExRT.Options.Frame:IsShown() then
			module.options.showButton:Hide()
		else
			module.options.showButton:Show()
		end
	end)
	
	self.chatText = ELib:Text(self,L.BossWatcherOptionsHelp,12):Size(600,250):Point(15,-235):Top():Color():Shadow()
	
	self.checkHideMageT100 = ELib:Check(self,L.BossWatcherHidePrismatic,not VExRT.BossWatcher.showPrismatic):Point(15,-350):Tooltip(L.BossWatcherHidePrismaticTooltip):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.BossWatcher.showPrismatic = nil
		else
			VExRT.BossWatcher.showPrismatic = true
		end
		module.db.lastFightID = module.db.lastFightID + 1
		module.db.data[module.db.nowNum].fightID = module.db.lastFightID
		if BWInterfaceFrame then
			BWInterfaceFrame.nowFightID = module.db.lastFightID
		end
	end)
	self.checkDivisionByZeroMageT100 = ELib:Check(self,L.BossWatcherDisablePrismatic,VExRT.BossWatcher.divisionPrismatic):Point(15,-375):Tooltip(L.BossWatcherDisablePrismaticTooltip):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.BossWatcher.divisionPrismatic = true
		else
			VExRT.BossWatcher.divisionPrismatic = nil
		end
		module.db.lastFightID = module.db.lastFightID + 1
		module.db.data[module.db.nowNum].fightID = module.db.lastFightID
		if BWInterfaceFrame then
			BWInterfaceFrame.nowFightID = module.db.lastFightID
		end
	end)
	
	function module.options:AdditionalOnShow()
		if ExRT.Options.Frame:IsShown() then
			module.options:SetParent(ExRT.Options.Frame)
			module.options:ClearAllPoints()
			module.options:SetPoint("TOPLEFT",195,-25)
		end
	end
end

local function UpdateTrackingDamageSpellsTable()
	var_trackingDamageSpells = ExRT.F.table_copy2(module.db.def_trackingDamageSpells)
	for spellID,_ in pairs(VExRT.BossWatcher.trackingDamageSpells) do
		var_trackingDamageSpells[spellID] = true
	end
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.BossWatcher = VExRT.BossWatcher or {
		optionsDamageGraph = true,
		optionsHealingGraph = true,
		optionsPositionsDist = true,
		fightsNum = 2,
	}
	VExRT.BossWatcher.autoSegments = VExRT.BossWatcher.autoSegments or {}
	
	if VExRT.BossWatcher.enabled then
		module:Enable(true)
	end
	VExRT.BossWatcher.fightsNum = VExRT.BossWatcher.fightsNum or 2
	
	VExRT.BossWatcher.trackingDamageSpells = VExRT.BossWatcher.trackingDamageSpells or {}
	UpdateTrackingDamageSpellsTable()
	
	if VExRT.BossWatcher.saveVariables and VExRT.BossWatcher.SAVED_DATA then
		module.db.data = VExRT.BossWatcher.SAVED_DATA
		for i=1,#module.db.data do
			if module.db.data[i] then
				module.db.data[i].fightID = -i
			end
		end
	else
		VExRT.BossWatcher.SAVED_DATA = nil
	end
	
	VExRT.BossWatcher.saveVariables = nil
	
	if VExRT.Addon.Version < 3596 then
		VExRT.BossWatcher.optionsDamageGraph = true
		VExRT.BossWatcher.optionsHealingGraph = true
		VExRT.BossWatcher.optionsPositionsDist = true
	end
end


--[[
Death type:
1: damage
2: heal
3: death
]]
local deathMaxEvents = 50

local function addDeath(destGUID,timestamp)
	local destData = deathLog[destGUID]
	if not destData then
		destData = {}
		for i=1,deathMaxEvents do
			destData[i] = {}
		end
		destData.c = 0
		deathLog[destGUID] = destData
	end
	local destTable = {
		{3,destGUID,timestamp},
	}
	local destTableLen = 1
	fightData_deathLog[#fightData_deathLog + 1] = destTable
	for i=destData.c,1,-1 do
		destTableLen = destTableLen + 1
		local copyTable = destData[i]
		destTable[destTableLen] = {
			copyTable.t,
			copyTable.s,
			copyTable.ti,
			copyTable.sp,
			copyTable.a,
			copyTable.o,
			copyTable.sc,
			copyTable.b,
			copyTable.ab,
			copyTable.c,
			copyTable.m,
			copyTable.h,
			copyTable.hm,
			copyTable.ia,
		}
		copyTable.t = nil
		copyTable.s = nil
		copyTable.ti = nil
		copyTable.sp = nil
		copyTable.a = nil
		copyTable.o = nil
		copyTable.sc = nil
		copyTable.b = nil
		copyTable.ab = nil
		copyTable.c = nil
		copyTable.m = nil
		copyTable.h = nil
		copyTable.hm = nil
		copyTable.ia = nil
	end
	for i=deathMaxEvents,destData.c+1,-1 do
		destTableLen = destTableLen + 1
		local copyTable = destData[i]
		destTable[destTableLen] = {
			copyTable.t,
			copyTable.s,
			copyTable.ti,
			copyTable.sp,
			copyTable.a,
			copyTable.o,
			copyTable.sc,
			copyTable.b,
			copyTable.ab,
			copyTable.c,
			copyTable.m,
			copyTable.h,
			copyTable.hm,
			copyTable.ia,
		}
		copyTable.t = nil
		copyTable.s = nil
		copyTable.ti = nil
		copyTable.sp = nil
		copyTable.a = nil
		copyTable.o = nil
		copyTable.sc = nil
		copyTable.b = nil
		copyTable.ab = nil
		copyTable.c = nil
		copyTable.m = nil
		copyTable.h = nil
		copyTable.hm = nil
		copyTable.ia = nil
	end
	destData.c = 0
end

local function addDamage(_,timestamp,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,_,_,amount,overkill,school,resisted,blocked,absorbed,critical,glancing,crushing,isOffHand,multistrike,missType)
	--Note, missType param added by myself for tracking function
	
	--------------> Add damage
	local destTable = fightData_damage[destGUID]
	if not destTable then
		fightData_damage_seen[destGUID] = timestamp
		destTable = {}
		fightData_damage[destGUID] = destTable
	end
	local sourceTable = destTable[sourceGUID]
	if not sourceTable then
		sourceTable = {}
		destTable[sourceGUID] = sourceTable
	end
	local spellTable = sourceTable[spellID]
	if not spellTable then
		spellTable = {
			amount = 0,
			count = 0,
			overkill = 0,
			blocked = 0,
			absorbed = 0,
			crit = 0,
			critcount = 0,
			critmax = 0,
			ms = 0,
			mscount = 0,
			msmax = 0,
			hitmax = 0,
			parry = 0,
			dodge = 0,
			miss = 0,
		}
		sourceTable[spellID] = spellTable
		if school then
			spellsSchool[spellID] = school
		end
	end
	spellTable.amount = spellTable.amount + amount
	spellTable.count = spellTable.count + 1
	if overkill > 0 then
		spellTable.overkill = spellTable.overkill + overkill
	end
	if blocked then
		spellTable.blocked = spellTable.blocked + blocked
	end
	if absorbed then
		spellTable.absorbed = spellTable.absorbed + absorbed
	end
	if critical and not multistrike then
		spellTable.crit = spellTable.crit + amount
		spellTable.critcount = spellTable.critcount + 1
		if spellTable.critmax < amount then
			spellTable.critmax = amount
		end
	elseif multistrike then
		spellTable.ms = spellTable.ms + amount
		spellTable.mscount = spellTable.mscount + 1
		if spellTable.msmax < amount then
			spellTable.msmax = amount
		end
	elseif not critical and not multistrike and spellTable.hitmax < amount then
		spellTable.hitmax = amount
	end
	
	
	
	--------------> Add death
	local destData = deathLog[destGUID]
	if not destData then
		destData = {}
		for i=1,deathMaxEvents do
			destData[i] = {}
		end
		destData.c = 0
		deathLog[destGUID] = destData
	end
	local pos = destData.c
	pos = pos + 1
	if pos > deathMaxEvents then
		pos = 1
	end
	local deathLine = destData[pos]
	deathLine.t = 1
	deathLine.s = sourceGUID
	deathLine.ti = timestamp
	deathLine.sp = spellID
	deathLine.a = amount
	deathLine.o = overkill
	deathLine.sc = school
	deathLine.b = blocked
	deathLine.ab = absorbed
	deathLine.c = critical
	deathLine.m = multistrike
	deathLine.ia = nil
	local player = raidGUIDs[ destGUID ]
	if player then
		deathLine.h = UnitHealth( player )
		deathLine.hm = UnitHealthMax( player )
	end
	destData.c = pos
	
	
	
	--------------> Add reduction
	local reductuionTable = var_reductionCurrent[destGUID]
	if reductuionTable then
		local reduction = fightData_reduction[destGUID]
		if not reduction then
			reduction = {}
			fightData_reduction[destGUID] = reduction
		end
		local reduction2 = reduction[sourceGUID]
		if not reduction2 then
			reduction2 = {}
			reduction[sourceGUID] = reduction2
		end
		reduction = reduction2[spellID]
		if not reduction then
			reduction = {}
			reduction2[spellID] = reduction
		end
		for i=1,#reductuionTable do
			local reductionSubtable = reductuionTable[i]
		
			local amount2 = amount+(absorbed or 0)+(blocked or 0)+overkill
			
			local isCheck = reductionSubtable.f
			if not isCheck then
				isCheck = true
			elseif isCheck == 1 then --physical
				isCheck = school == 1
			elseif isCheck == 2 then --magic
				isCheck = bit_band(school or 0,1) == 0
			elseif isCheck == 3 then --feintCheck
				isCheck = module.db.reductionIsNotAoe[spellID]
			elseif isCheck == 4 then --dampenHarmCheck
				local unitHealthMax = UnitHealthMax(destName or "?")
				unitHealthMax = unitHealthMax == 0 and 363000 or unitHealthMax
				isCheck = (amount2 / unitHealthMax) > 0.1499 
			end		
			
			if isCheck then
				local reductionGUID = reductionSubtable.g
				reduction2 = reduction[reductionGUID]
				if not reduction2 then
					reduction2 = {}
					reduction[reductionGUID] = reduction2
				end
				local reductionSpell = reductionSubtable.s
				
				local amount = amount2 * reductionSubtable.c
				
				reduction2[reductionSpell] = (reduction2[reductionSpell] or 0)+amount
			end
		end
	end



	--------------> Add switch
	local targetTable = fightData_switch[destGUID]
	if not targetTable then
		targetTable = {
			[1]={},	--cast
			[2]={},	--target
		}
		fightData_switch[destGUID] = targetTable
	end
	local targetCastTable = targetTable[1]
	if not targetCastTable[sourceGUID] then
		targetCastTable[sourceGUID] = {timestamp,spellID}
	end
	
	
	
	
	--------------> Add healing from
	if bit_band(destFlags,0x00000040) == 0 and amount > 0 then	--COMBATLOG_OBJECT_REACTION_HOSTILE
		local healingFromData = damageTakenLog[destGUID]
		if not healingFromData then
			healingFromData = {}
			damageTakenLog[destGUID] = healingFromData
		end
		local healingFromDataSize = #healingFromData
		if healingFromData[healingFromDataSize - 1] == spellID then
			healingFromData[healingFromDataSize] = healingFromData[healingFromDataSize] + amount
		else
			healingFromData[healingFromDataSize + 1] = spellID
			healingFromData[healingFromDataSize + 2] = amount
		end
	end
	
	
	
	--------------> Add special spells [tracking]
	if var_trackingDamageSpells[spellID] then
		if not fightData.tracking then
			fightData.tracking = {}
		end
		fightData.tracking[#fightData.tracking + 1] = {timestamp,sourceGUID,sourceFlags2,destGUID,destFlags2,spellID,amount,overkill,school,blocked,absorbed,critical,multistrike,missType}
	end
	
	
	
	
	--------------> Other
	if spellID == 196917 then	-- Light of the Martyr: effective healing fix
		local lotmData = spellFix_LotM[sourceGUID]
		if lotmData then
			local damageTaken = amount + overkill + (absorbed or 0)
			if damageTaken < (lotmData[1] + lotmData[2]) and (timestamp - lotmData[5]) < 0.2 then
				local spellTable = lotmData[3]
				if lotmData[2] == 0 then
					spellTable.amount = spellTable.amount - damageTaken
				elseif lotmData[2] >= damageTaken then
					spellTable.absorbed = spellTable.absorbed - damageTaken
				else
					spellTable.absorbed = spellTable.absorbed - lotmData[2]
					spellTable.amount = spellTable.amount - damageTaken + lotmData[2]
				end
				if lotmData[4] then
					spellTable.crit = spellTable.crit - damageTaken
				end
			end
		end
	end
end

local function AddMiss(_,timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,_,school,missType,isOffHand,multistrike,amountMissed)
	if missType == "ABSORB" then
		addDamage(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,spellID,nil,nil,0,0,school,nil,nil,amountMissed,nil,nil,nil,isOffHand,multistrike)
	elseif missType == "BLOCK" then
		addDamage(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,spellID,nil,nil,0,0,school,nil,amountMissed,nil,nil,nil,nil,isOffHand,multistrike)
	elseif missType == "PARRY" then
		addDamage(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,spellID,nil,nil,0,0,school,nil,nil,nil,nil,nil,nil,isOffHand,multistrike,missType)
		local spellTable = fightData_damage[destGUID][sourceGUID][spellID]
		spellTable.parry = spellTable.parry + 1
	elseif missType == "DODGE" then
		addDamage(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,spellID,nil,nil,0,0,school,nil,nil,nil,nil,nil,nil,isOffHand,multistrike,missType)
		local spellTable = fightData_damage[destGUID][sourceGUID][spellID]
		spellTable.dodge = spellTable.dodge + 1
	else
		addDamage(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,spellID,nil,nil,0,0,school,nil,nil,nil,nil,nil,nil,isOffHand,multistrike,missType)
		local spellTable = fightData_damage[destGUID][sourceGUID][spellID]
		spellTable.miss = spellTable.miss + 1	
	end
end
if ExRT.is7 then
	function AddMiss(_,timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,_,school,missType,isOffHand,amountMissed)
		if missType == "ABSORB" then
			addDamage(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,spellID,nil,nil,0,0,school,nil,nil,amountMissed,nil,nil,nil,isOffHand)
		elseif missType == "BLOCK" then
			addDamage(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,spellID,nil,nil,0,0,school,nil,amountMissed,nil,nil,nil,nil,isOffHand)
		elseif missType == "PARRY" then
			addDamage(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,spellID,nil,nil,0,0,school,nil,nil,nil,nil,nil,nil,isOffHand,nil,missType)
			local spellTable = fightData_damage[destGUID][sourceGUID][spellID]
			spellTable.parry = spellTable.parry + 1
		elseif missType == "DODGE" then
			addDamage(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,spellID,nil,nil,0,0,school,nil,nil,nil,nil,nil,nil,isOffHand,nil,missType)
			local spellTable = fightData_damage[destGUID][sourceGUID][spellID]
			spellTable.dodge = spellTable.dodge + 1
		else
			addDamage(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,spellID,nil,nil,0,0,school,nil,nil,nil,nil,nil,nil,isOffHand,nil,missType)
			local spellTable = fightData_damage[destGUID][sourceGUID][spellID]
			spellTable.miss = spellTable.miss + 1	
		end
	end
end

local AddEnvironmentalDamage = nil
do
	local EnvironmentalTypeToSpellID = {
		["Falling"] = 110122,
		["Drowning"] = 68730,
		["Fatigue"] = 125024,
		["Fire"] = 103795,
		["Lava"] = 119741,
		["Slime"] = 16456,
		-- UnkEnvDamage = 48360,
	}
	AddEnvironmentalDamage = function(_,timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,environmentalType,amount,overkill,school,resisted,blocked,absorbed,critical,glancing,crushing,isOffHand,multistrike)
		local environmentalSpellID = environmentalType and EnvironmentalTypeToSpellID[environmentalType] or 48360
		addDamage(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,environmentalSpellID,nil,nil,amount,overkill,school,resisted,blocked,absorbed,critical,glancing,crushing,isOffHand,multistrike)
	end
end

--[[
Note about healing:
amount = healing + overhealing
absorbed = if spell absorbed by ability (ex. DK's egg, Koragh shadow phase)
absorbs = if spell is absorb (ex. PW:S, HPally mastery, BloodDK mastery)
]]

local function addHeal(_,timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,_,school,amount,overhealing,absorbed,critical,multistrike)
	--------------> Add heal
	local sourceTable = fightData_heal[sourceGUID]
	if not sourceTable then
		sourceTable = {}
		fightData_heal[sourceGUID] = sourceTable
	end
	local destTable = sourceTable[destGUID]
	if not destTable then
		destTable = {}
		sourceTable[destGUID] = destTable
	end
	local spellTable = destTable[spellID]
	if not spellTable then
		spellTable = {
			amount = 0,
			over = 0,
			absorbed = 0,
			count = 0,
			crit = 0,
			critcount = 0,
			critmax = 0,
			critover = 0,
			ms = 0,
			mscount = 0,
			msmax = 0,
			msover = 0,
			hitmax = 0,
			absorbs = 0,
		}
		destTable[spellID] = spellTable
		spellsSchool[spellID] = school
	end
	spellTable.amount = spellTable.amount + amount
	spellTable.over = spellTable.over + overhealing
	spellTable.absorbed = spellTable.absorbed + absorbed
	spellTable.count = spellTable.count + 1
	if critical and not multistrike then
		spellTable.crit = spellTable.crit + amount + absorbed
		spellTable.critcount = spellTable.critcount + 1
		if spellTable.critmax < amount then
			spellTable.critmax = amount
		end
		spellTable.critover = spellTable.critover + overhealing
	elseif multistrike then
		spellTable.ms = spellTable.ms + amount + absorbed
		spellTable.mscount = spellTable.mscount + 1
		if spellTable.msmax < amount then
			spellTable.msmax = amount
		end
		spellTable.msover = spellTable.msover + overhealing		
	elseif not critical and not multistrike and spellTable.hitmax < amount then
		spellTable.hitmax = amount
	end
	


	--------------> Add death
	local destData = deathLog[destGUID]
	if not destData then
		destData = {}
		for i=1,deathMaxEvents do
			destData[i] = {}
		end
		destData.c = 0
		deathLog[destGUID] = destData
	end
	local pos = destData.c
	pos = pos + 1
	if pos > deathMaxEvents then
		pos = 1
	end
	local deathLine = destData[pos]
	deathLine.t = 2
	deathLine.s = sourceGUID
	deathLine.ti = timestamp
	deathLine.sp = spellID
	deathLine.a = amount
	deathLine.o = overhealing
	deathLine.sc = school
	deathLine.b = nil
	deathLine.ab = absorbed
	deathLine.c = critical
	deathLine.m = multistrike
	deathLine.ia = nil
	local player = raidGUIDs[ destGUID ]
	if player then
		deathLine.h = UnitHealth( player )
		deathLine.hm = UnitHealthMax( player )
	end
	destData.c = pos
	
	
	
	
	--------------> Add healing from
	local healingFromAmount = amount - overhealing
	if healingFromAmount > 0 then
		local healingFromData = damageTakenLog[destGUID]
		if healingFromData then
			local healingFromDataSize = #healingFromData
			if healingFromDataSize > 0 then
				local healingFromTable = fightData_healFrom[sourceGUID]
				if not healingFromTable then
					healingFromTable = {}
					fightData_healFrom[sourceGUID] = healingFromTable
				end
				local healingFromDestTable = healingFromTable[destGUID]
				if not healingFromDestTable then
					healingFromDestTable = {}
					healingFromTable[destGUID] = healingFromDestTable
				end
				local healingFromSpellTable = healingFromDestTable[spellID]
				if not healingFromSpellTable then
					healingFromSpellTable = {}
					healingFromDestTable[spellID] = healingFromSpellTable
				end
				for i=(healingFromDataSize - 1),1,-2 do
					local damageTaken = healingFromData[i+1]
					if healingFromAmount > damageTaken then
						healingFromAmount = healingFromAmount - damageTaken
						
						local fromSpellID = healingFromData[i]
						if not healingFromSpellTable[fromSpellID] then
							healingFromSpellTable[fromSpellID] = 0
						end
						healingFromSpellTable[fromSpellID] = healingFromSpellTable[fromSpellID]+damageTaken
						
						healingFromData[i+1] = nil
						healingFromData[i] = nil
					else
						local fromSpellID = healingFromData[i]
						if not healingFromSpellTable[fromSpellID] then
							healingFromSpellTable[fromSpellID] = 0
						end
						healingFromSpellTable[fromSpellID] = healingFromSpellTable[fromSpellID]+healingFromAmount
						
						healingFromData[i+1] = healingFromData[i+1] - healingFromAmount
						if healingFromData[i+1] == 0 then
							healingFromData[i+1] = nil
							healingFromData[i] = nil
						end
						
						break
					end
				end
			end
		end
	end
	
	
	
	--------------> Other
	if spellID == 183998 then	--Light of the Martyr: effective healing fix
		local lotmData = spellFix_LotM[sourceGUID]
		if not lotmData then
			lotmData = {}
			spellFix_LotM[sourceGUID] = lotmData
		end
		lotmData[1] = amount - overhealing
		lotmData[2] = absorbed
		lotmData[3] = spellTable
		lotmData[4] = critical
		lotmData[5] = timestamp
	end
end

local function addHeal_TyrantVelhari(_,timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,_,school,amount,overhealing,absorbed,critical)
	if absorbed > 0 and destGUID and (not encounterSpecial[destGUID] or (type(encounterSpecial[destGUID])=='number' and absorbed ~= encounterSpecial[destGUID])) then
		amount = amount + absorbed
		overhealing = overhealing + absorbed
		absorbed = 0
	end
	addHeal(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,spellID,nil,school,amount,overhealing,absorbed,critical)
end

--[[
SPELL_ABSORBED event info:
	for SWING
timestamp,attackerGUID,attackerName,attackerFlags,attackerFlags2,destGUID,destName,destFlags,destFlags2,sourceGUID,sourceName,sourceFlags,sourceFlags2,spellID,spellName,school,amount
	OR for SPELL
timestamp,attackerGUID,attackerName,attackerFlags,attackerFlags2,destGUID,destName,destFlags,destFlags2,attackerSpellId,attackerSpellName,attackerSchool,sourceGUID,sourceName,sourceFlags,sourceFlags2,spellID,spellName,school,amount
]]

local function addAbsorbs(_,timestamp,attackerGUID,attackerName,attackerFlags,attackerFlags2,destGUID,destName,destFlags,destFlags2,...)
	local attackerSpellId,attackerSpellName,attackerSchool,sourceGUID,sourceName,sourceFlags,sourceFlags2,spellID,spellName,school,amount = ...
	if not amount then
		sourceGUID,sourceName,sourceFlags,sourceFlags2,spellID,spellName,school,amount = ...
		attackerSpellId = 6603
	end
	if spellID == 20711 or spellID == 115069 or spellID == 157533 then	--Not real absorbs spells
		return
	end
	
	
	--------------> Add heal
	local sourceTable = fightData_heal[sourceGUID]
	if not sourceTable then
		sourceTable = {}
		fightData_heal[sourceGUID] = sourceTable
	end
	local destTable = sourceTable[destGUID]
	if not destTable then
		destTable = {}
		sourceTable[destGUID] = destTable
	end
	local spellTable = destTable[spellID]
	if not spellTable then
		spellTable = {
			amount = 0,
			over = 0,
			absorbed = 0,
			count = 0,
			crit = 0,
			critcount = 0,
			critmax = 0,
			critover = 0,
			ms = 0,
			mscount = 0,
			msmax = 0,
			msover = 0,
			hitmax = 0,
			absorbs = 0,
		}
		destTable[spellID] = spellTable
		spellsSchool[spellID] = school
	end
	spellTable.amount = spellTable.amount + amount
	spellTable.absorbs = spellTable.absorbs + amount
	spellTable.count = spellTable.count + 1
	if spellTable.hitmax < amount then
		spellTable.hitmax = amount
	end
	
	
	
	--------------> Add death
	local destData = deathLog[destGUID]
	if not destData then
		destData = {}
		for i=1,deathMaxEvents do
			destData[i] = {}
		end
		destData.c = 0
		deathLog[destGUID] = destData
	end
	local pos = destData.c
	pos = pos + 1
	if pos > deathMaxEvents then
		pos = 1
	end
	local deathLine = destData[pos]
	deathLine.t = 2
	deathLine.s = sourceGUID
	deathLine.ti = timestamp
	deathLine.sp = spellID
	deathLine.a = amount
	deathLine.o = 0
	deathLine.sc = school
	deathLine.b = nil
	deathLine.ab = nil
	deathLine.c = nil
	deathLine.m = nil
	deathLine.ia = amount
	local player = raidGUIDs[ destGUID ]
	if player then
		deathLine.h = UnitHealth( player )
		deathLine.hm = UnitHealthMax( player )
	end
	destData.c = pos
	
	
	
	
	--------------> Add healing from
	local healingFromTable = fightData_healFrom[sourceGUID]
	if not healingFromTable then
		healingFromTable = {}
		fightData_healFrom[sourceGUID] = healingFromTable
	end
	local healingFromDestTable = healingFromTable[destGUID]
	if not healingFromDestTable then
		healingFromDestTable = {}
		healingFromTable[destGUID] = healingFromDestTable
	end
	local healingFromSpellTable = healingFromDestTable[spellID]
	if not healingFromSpellTable then
		healingFromSpellTable = {}
		healingFromDestTable[spellID] = healingFromSpellTable
	end
	if not healingFromSpellTable[attackerSpellId] then
		healingFromSpellTable[attackerSpellId] = 0
	end
	healingFromSpellTable[attackerSpellId] = healingFromSpellTable[attackerSpellId]+amount

end

local function debug_CurrentReductionToChat(destData)
	print(GetTime(),'New data:')
	for i=1,#destData do
		local link = GetSpellLink(destData[i].s)
		print( link,destData[i].r,destData[i].c )
	end
end

local function addAura(_,timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,spellName,school,auraType,amount)
	if autoSegmentsUPValue.SPELL_AURA_APPLIED[spellID] then
		StartSegment("SPELL_AURA_APPLIED",spellID)
	end
	
	fightData_auras[ #fightData_auras + 1 ] = {timestamp,sourceGUID,destGUID,UnitIsFriendlyByUnitFlag(sourceFlags),UnitIsFriendlyByUnitFlag(destFlags),spellID,auraType,1,1}
	
	
	--------------> Add reduction
	local reduction = var_reductionAuras[spellID]
	if reduction then
		if spellID == 81782 then
			sourceGUID = module.db.reductionPowerWordBarrierCaster or sourceGUID
		end
		if spellID == 114030 and sourceGUID == destGUID then return end	--Vigilance fix
	
		local destData = var_reductionCurrent[ destGUID ]
		if not destData then
			destData = {}
			var_reductionCurrent[ destGUID ] = destData
		end
		local destCount = #destData
		
		local func,funcAura,reductionTable = nil
		if type(reduction)=="table" then
			reductionTable = reduction
			funcAura = reduction[3]
			func = reduction[2]
			reduction = reduction[1]
		end
		
		if spellID == 1966 then		--Feint additional talent 30%
			local _,_,_,_,_,_,_,_,_,_,_,_,_,_,val1,val2,val3,val4,val5 = UnitAura(destName or "?",spellName or "?")
			if val2 == -30 then
				local from = 1
				for i=1,destCount do
					from = from * destData[i].r
				end
				local feintAdditionalReduction = 1 / (1 - (from - from * 0.7))
				destData[destCount + 1] = {
					s = spellID,
					r = 0.7,
					c = (feintAdditionalReduction - 1),
					g = sourceGUID,
				}
				destCount = destCount + 1
			end
		end

		if funcAura then
			local _,_,_,_,_,_,_,_,_,_,_,_,_,_,val1,val2,val3,val4,val5 = UnitAura(destName or "?",spellName or "?")
			if val1 then
				reduction, func = funcAura(val1,val2,val3,val4,val5)
				if not reduction then
					reduction = reductionTable[1]
					func = reductionTable[2]
					funcAura = nil
				end
				--ExRT.F.dprint(format("%s > %s: %s [%d%%]",sourceName,destName,spellName,(reduction or 0)*100))
			else
				funcAura = nil
			end
		end
		
		--Second check: some spells doesn't return number of reduction in aura (ex. Shamanistic Rage,Rune Tap)
		
		if not funcAura and (spellID == 498 or spellID == 48792 or spellID == 171049 or spellID == 51755 or spellID == 104773 or spellID == 120954 or spellID == 586 or spellID == 30823 or spellID == 871 or spellID == 71 or spellID == 768) then
			local inspectData = ExRT.A.ExCD2 and ExRT.A.ExCD2.db and ExRT.A.ExCD2.db.inspectDB
			if inspectData then
				for name,nameData in pairs(inspectData) do
					if nameData.GUID == sourceGUID then
						if spellID == 498 then	--Divine Protection
							for i=8,13 do
								if nameData[i] == 54924 then
									func = nil
									reduction = 0.8
									break
								end
							end
						elseif spellID == 48792 then	--Icebound Fortitude
							if nameData.spec == 250 then
								reduction = 0.5
							end
						elseif spellID == 171049 then	--Rune Tap
							for i=8,13 do
								if nameData[i] == 159428 then
									reduction = 0.8
									break
								end
							end
						elseif spellID == 51755 then	--Camouflage
							for i=8,13 do
								if nameData[i] == 148475 then
									reduction = 0.9
									break
								end
							end
						elseif spellID == 104773 then	--Unending Resolve
							for i=8,13 do
								if nameData[i] == 146964 then
									reduction = 0.8
									break
								end
							end
						elseif spellID == 120954 then	--Fortifying Brew
							for i=8,13 do
								if nameData[i] == 124997 then
									reduction = 0.75
									break
								end
							end
						elseif spellID == 586 then		--Fade
							for i=8,13 do
								if nameData[i] == 55684 then
									reduction = 0.9
									break
								end
							end
						elseif spellID == 30823 then	--Shamanistic Rage
							for i=8,13 do
								if nameData[i] == 159648 then
									reduction = 0.4
									break
								end
							end
						elseif spellID == 871 then		--Shield Wall
							for i=8,13 do
								if nameData[i] == 63329 then
									reduction = 0.4
									break
								end
							end
						elseif spellID == 71 then		--Defensive Stance
							if nameData.spec == 73 then
								reduction = reduction - 0.05 --Improved Defensive Stance
							end
							if nameData[7] == 3 then
								reduction = reduction - 0.05 --Gladiator's Resolve
							end
						elseif spellID == 768 then		--Cat Form
							for i=8,13 do
								if nameData[i] == 159444 then
									reduction = 0.9
									break
								end
							end
						end
						break
					end
				end
			end
		end
		
		if reduction == 1 then
			return
		end
		
		local from = 1
		if func == ReductionAurasFunctions.magic then
			for i=1,destCount do
				if destData[i].f ~= ReductionAurasFunctions.physical then
					from = from * destData[i].r
				end
			end
		elseif func == ReductionAurasFunctions.physical then
			for i=1,destCount do
				if destData[i].f ~= ReductionAurasFunctions.magic then
					from = from * destData[i].r
				end
			end
		else
			for i=1,destCount do
				from = from * destData[i].r
			end
		end
		
		local currReduction = 1 / (1 - (from - from * reduction))
		destData[destCount + 1] = {
			s = spellID,
			r = reduction,
			c = (currReduction - 1),
			g = sourceGUID,
			f = func,
		}
		
		--debug_CurrentReductionToChat(destData)
		
		if school then
			spellsSchool[spellID] = school
		end
	end
end

local function addAura_TyrantVelhari(_,timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,spellName,school,auraType,amount)
	if spellID == 185237 or spellID == 185238 or spellID == 180164 or spellID == 180166 then
		encounterSpecial[destGUID or "nil"] = true
	end
	
	addAura(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,spellID,spellName,school,auraType,amount)
end


local function removeAura(_,timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,_,school,auraType,amount)
	if autoSegmentsUPValue.SPELL_AURA_REMOVED[spellID] then
		StartSegment("SPELL_AURA_REMOVED",spellID)
	end
	
	fightData_auras[ #fightData_auras + 1 ] = {timestamp,sourceGUID,destGUID,UnitIsFriendlyByUnitFlag(sourceFlags),UnitIsFriendlyByUnitFlag(destFlags),spellID,auraType,2,1}
	
	if amount and amount > 0 then
		addHeal(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,spellID,nil,school,amount,amount,0)
	end
		


	--------------> Add reduction
	local reduction = var_reductionAuras[spellID]
	if reduction then
		local destData = var_reductionCurrent[ destGUID ]
		if not destData then
			return
		end
		for i=1,#destData do
			if destData[i] and destData[i].s == spellID and (destData[i].g == sourceGUID or spellID == 81782) then
				tremove(destData,i)
			end
		end
		
		local from,fromPhysical,fromMagic = 1,1,1
		for i=1,#destData do
			local spellData = destData[i]
			local currReduction = nil
			if spellData.f == ReductionAurasFunctions.magic then
				currReduction = 1 / (1 - (fromMagic - fromMagic * spellData.r))
				fromMagic = fromMagic * spellData.r
			elseif spellData.f == ReductionAurasFunctions.physical then
				currReduction = 1 / (1 - (fromPhysical - fromPhysical * spellData.r))
				fromPhysical = fromPhysical * spellData.r
			else
				currReduction = 1 / (1 - (from - from * spellData.r))
				fromPhysical = fromPhysical * spellData.r
				fromMagic = fromMagic * spellData.r
			end
			from = from * spellData.r
			spellData.c = currReduction - 1
		end
		
		--debug_CurrentReductionToChat(destData)
	end
end

local function removeAura_TyrantVelhari(_,timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,_,school,auraType,amount)
	if spellID == 185237 or spellID == 185238 or spellID == 180164 or spellID == 180166 then
		encounterSpecial[destGUID or "nil"] = amount and floor(amount)
		C_Timer.NewTicker(0.03,function()
			encounterSpecial[destGUID or "nil"] = nil
		end,1)
	end
	
	removeAura(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,spellID,nil,school,auraType,amount)
end

local function addCastStarted(_,timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID)
	
	--------------> Add cast
	local sourceTable = fightData_cast[sourceGUID]
	if not sourceTable then
		sourceTable = {}
		fightData_cast[sourceGUID] = sourceTable
	end
	sourceTable[ #sourceTable + 1 ] = {timestamp,spellID,2,destGUID}
	
	
	
	--------------> Add switch
	if sourceName and GetUnitInfoByUnitFlag(sourceFlags,1) == 1024 then
		local unitID = UnitInRaid(sourceName)
		if unitID then
			unitID = "raid"..unitID
			local targetGUID = UnitGUID(unitID.."target")
			if targetGUID and not UnitIsPlayerOrPet(targetGUID) then
				-- Switch code
				local targetTable = fightData_switch[targetGUID]
				if not targetTable then
					targetTable = {
						[1]={},	--cast
						[2]={},	--target
					}
					fightData_switch[targetGUID] = targetTable
				end
				if not targetTable[1][sourceGUID] then
					targetTable[1][sourceGUID] = {timestamp,spellID}
				end
				-- / Switch code
			end
		end
	end
end

local function addCastEnded(_,timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID)

	--------------> Add cast
	local sourceTable = fightData_cast[sourceGUID]
	if not sourceTable then
		sourceTable = {}
		fightData_cast[sourceGUID] = sourceTable
	end
	sourceTable[ #sourceTable + 1 ] = {timestamp,spellID,1,destGUID}



	--------------> Add switch
	local targetTable = fightData_switch[destGUID]
	if not targetTable then
		targetTable = {
			[1]={},	--cast
			[2]={},	--target
		}
		fightData_switch[destGUID] = targetTable
	end
	targetTable = targetTable[1]
	if not targetTable[sourceGUID] then
		targetTable[sourceGUID] = {timestamp,spellID}
	end
	
	
	--------------> Other
	if spellID == 62618 then	--PW:B caster fix
		module.db.reductionPowerWordBarrierCaster = sourceGUID
	end
end


local function addSwitch(sourceGUID,targetGUID,timestamp,_type,spellID)
	local targetTable = fightData_switch[targetGUID]
	if not targetTable then
		targetTable = {
			[1]={},	--cast
			[2]={},	--target
		}
		fightData_switch[targetGUID] = targetTable
	end
	if not targetTable[_type][sourceGUID] then
		targetTable[_type][sourceGUID] = {timestamp,spellID}
	end
end

local function addGUID(GUID,name)
	if not guidData[GUID] then
		guidData[GUID] = name or "nil"
	end
end

local function addPower(_,timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,_,_,amount,powerType)
	local sourceData = fightData_power[sourceGUID]
	if not sourceData then
		sourceData = {}
		fightData_power[sourceGUID] = sourceData
	end
	local powerData = sourceData[powerType]
	if not powerData then
		powerData = {}
		sourceData[powerType] = powerData
	end
	local spellData = powerData[spellID]
	if not spellData then
		spellData = {0,0}
		powerData[spellID] = spellData
	end
	spellData[1] = spellData[1] + amount
	spellData[2] = spellData[2] + 1
end

local function addReductionOnPull(unit,destGUID)
	--------------> Add passive reductions
	--- Note: this is first reduction check ever and I must don't care about any existens data
	local unitInspectData = ExRT.A.ExCD2 and ExRT.A.ExCD2.db and ExRT.A.ExCD2.db.inspectDB and ExRT.A.ExCD2.db.inspectDB[unit]
	local specID = unitInspectData and unitInspectData.spec or 0
	local reductionSpec = module.db.reductionBySpec[ specID ]
	if reductionSpec then
		var_reductionCurrent[ destGUID ] = {
			{
				s = reductionSpec[1],
				r = reductionSpec[2],
				c = (1 / reductionSpec[2] - 1),
				g = destGUID,
				f = reductionSpec[3],
			}
		}
		spellsSchool[ reductionSpec[1] ] = reductionSpec[4] or 0x1
	end
	
	-- Note: warlocks & hunters must have not passive reduction cuz it will be overwritten
	if unitInspectData and unitInspectData.class == "WARLOCK" then
		for i=8,13 do
			if unitInspectData[i] == 148683 then
				var_reductionCurrent[ destGUID ] = {
					{
						s = 148688,
						r = 0.9,
						c = (1 / 0.9 - 1),
						g = destGUID,
					}
				}
				spellsSchool[ 148688 ] = 0x20
			end
		end
	elseif unitInspectData and unitInspectData.class == "HUNTER" then
		if unitInspectData[3] == 2 then
			var_reductionCurrent[ destGUID ] = {
				{
					s = 109260,
					r = 0.9,
					c = (1 / 0.9 - 1),
					g = destGUID,
				}
			}
			spellsSchool[ 109260 ] = 0x8
		end
	end
	
	
	
	--------------> Add active reductions from current auras
	for i=1,40 do
		local _,_,_,stacksCount,_,_,_,casterUnit,_,_,spellID,_,_,_,val1,val2,val3,val4,val5 = UnitAura(unit,i)
		
		if not spellID then
			return
		end
	
		--------------> Add reduction
		local reduction = var_reductionAuras[spellID]
		if reduction then
			local sourceGUID = nil
			if casterUnit then
				sourceGUID = UnitGUID(casterUnit)
			end
			sourceGUID = sourceGUID or ""
		
			if not (spellID == 114030 and sourceGUID == destGUID) then --Vigilance fix
				local destData = var_reductionCurrent[ destGUID ]
				if not destData then
					destData = {}
					var_reductionCurrent[ destGUID ] = destData
				end
				local destCount = #destData
				
				local func,funcAura,reductionTable = nil
				if type(reduction)=="table" then
					reductionTable = reduction
					funcAura = reduction[3]
					func = reduction[2]
					reduction = reduction[1]
				end
				
				if spellID == 1966 and val2 == -30 then		--Feint additional talent 30%
					local from = 1
					for i=1,destCount do
						from = from * destData[i].r
					end
					local feintAdditionalReduction = 1 / (1 - (from - from * 0.7))
					destData[destCount + 1] = {
						s = spellID,
						r = 0.7,
						c = (feintAdditionalReduction - 1),
						g = sourceGUID,
					}
					destCount = destCount + 1
				end
		
				if funcAura then
					if val1 then
						reduction, func = funcAura(val1,val2,val3,val4,val5)
						if not reduction then
							reduction = reductionTable[1]
							func = reductionTable[2]
							funcAura = nil
						end
						--ExRT.F.dprint(format("%s > %s: %s [%d%%]",sourceName,destName,spellName,(reduction or 0)*100))
					else
						funcAura = nil
					end
				end
				
				--Second check: some spells doesn't return number of reduction in aura (ex. Shamanistic Rage,Rune Tap)
				
				if unitInspectData and not funcAura and (spellID == 498 or spellID == 48792 or spellID == 171049 or spellID == 51755 or spellID == 104773 or spellID == 120954 or spellID == 586 or spellID == 30823 or spellID == 871 or spellID == 71 or spellID == 768) then
					local nameData = unitInspectData
					if spellID == 498 then	--Divine Protection
						for i=8,13 do
							if nameData[i] == 54924 then
								func = nil
								reduction = 0.8
								break
							end
						end
					elseif spellID == 48792 then	--Icebound Fortitude
						if nameData.spec == 250 then
							reduction = 0.5
						end
					elseif spellID == 171049 then	--Rune Tap
						for i=8,13 do
							if nameData[i] == 159428 then
								reduction = 0.8
								break
							end
						end
					elseif spellID == 51755 then	--Camouflage
						for i=8,13 do
							if nameData[i] == 148475 then
								reduction = 0.9
								break
							end
						end
					elseif spellID == 104773 then	--Unending Resolve
						for i=8,13 do
							if nameData[i] == 146964 then
								reduction = 0.8
								break
							end
						end
					elseif spellID == 120954 then	--Fortifying Brew
						for i=8,13 do
							if nameData[i] == 124997 then
								reduction = 0.75
								break
							end
						end
					elseif spellID == 586 then		--Fade
						for i=8,13 do
							if nameData[i] == 55684 then
								reduction = 0.9
								break
							end
						end
					elseif spellID == 30823 then	--Shamanistic Rage
						for i=8,13 do
							if nameData[i] == 159648 then
								reduction = 0.4
								break
							end
						end
					elseif spellID == 871 then		--Shield Wall
						for i=8,13 do
							if nameData[i] == 63329 then
								reduction = 0.4
								break
							end
						end
					elseif spellID == 71 then		--Defensive Stance
						if nameData.spec == 73 then
							reduction = reduction - 0.05 --Improved Defensive Stance
						end
						if nameData[7] == 3 then
							reduction = reduction - 0.05 --Gladiator's Resolve
						end
					elseif spellID == 768 then		--Cat Form
						for i=8,13 do
							if nameData[i] == 159444 then
								reduction = 0.9
								break
							end
						end
					end
				end
				
				if reduction ~= 1 then
					local from = 1
					if func == ReductionAurasFunctions.magic then
						for i=1,destCount do
							if destData[i].f ~= ReductionAurasFunctions.physical then
								from = from * destData[i].r
							end
						end
					elseif func == ReductionAurasFunctions.physical then
						for i=1,destCount do
							if destData[i].f ~= ReductionAurasFunctions.magic then
								from = from * destData[i].r
							end
						end
					else
						for i=1,destCount do
							from = from * destData[i].r
						end
					end
				
					local currReduction = 1 / (1 - (from - from * reduction))
					destData[destCount + 1] = {
						s = spellID,
						r = reduction,
						c = (currReduction - 1),
						g = sourceGUID,
						f = func,
					}
					
					if not spellsSchool[spellID] then
						spellsSchool[spellID] = 0x1
					end
				end
			end
		end
	end
end


function AddSegmentToData(seg)
	local segmentData = module.db.data[module.db.nowNum].fight[seg]
	for destGUID,destData in pairs(segmentData.damage) do
		local _now = module.db.nowData.damage[destGUID]
		if not _now then
			_now = {}
			module.db.nowData.damage[destGUID] = _now
		end
		for sourceGUID,sourceData in pairs(destData) do
			local _source = _now[sourceGUID]
			if not _source then
				_source = {}
				_now[sourceGUID] = _source
			end
			for spellID,spellData in pairs(sourceData) do
				local _spell = _source[spellID]
				if not _spell then
					_spell = {
						amount = 0,
						count = 0,
						overkill = 0,
						blocked = 0,
						absorbed = 0,
						crit = 0,
						critcount = 0,
						critmax = 0,
						ms = 0,
						mscount = 0,
						msmax = 0,
						hitmax = 0,
						parry = 0,
						dodge = 0,
						miss = 0,
					}
					_source[spellID] = _spell
				end
				for dataName,dataAmount in pairs(spellData) do
					if dataName:find("max") then
						_spell[dataName] = max(_spell[dataName],dataAmount)
					else
						_spell[dataName] = _spell[dataName] + dataAmount
					end				
				end
			end
		end		
	end
	for destGUID,seen in pairs(segmentData.damage_seen) do
		if module.db.nowData.damage_seen[destGUID] then
			module.db.nowData.damage_seen[destGUID] = min(module.db.nowData.damage_seen[destGUID],seen)
		else
			module.db.nowData.damage_seen[destGUID] = seen
		end
	end
	for sourceGUID,sourceData in pairs(segmentData.heal) do
		local _source = module.db.nowData.heal[sourceGUID]
		if not _source then
			_source = {}
			module.db.nowData.heal[sourceGUID] = _source
		end
		for destGUID,destData in pairs(sourceData) do
			local _dest = _source[destGUID]
			if not _dest then
				_dest = {}
				_source[destGUID] = _dest
			end
			for spellID,spellData in pairs(destData) do
				local _spell = _dest[spellID]
				if not _spell then
					_spell = {
						amount = 0,
						over = 0,
						absorbed = 0,
						count = 0,
						crit = 0,
						critcount = 0,
						critmax = 0,
						critover = 0,
						ms = 0,
						mscount = 0,
						msmax = 0,
						msover = 0,
						hitmax = 0,
						absorbs = 0,
					}
					_dest[spellID] = _spell
				end
				for dataName,dataAmount in pairs(spellData) do
					if dataName:find("max") then
						_spell[dataName] = max(_spell[dataName],dataAmount)
					else
						_spell[dataName] = _spell[dataName] + dataAmount
					end				
				end
			end
		end
	end
	for targetGUID,destData in pairs(segmentData.switch) do
		if not module.db.nowData.switch[targetGUID] then
			module.db.nowData.switch[targetGUID] = {
				[1]={},	--cast
				[2]={},	--target
			}
		end
		for _type=1,2 do
			for unitN,t in pairs(destData[_type]) do
				if not module.db.nowData.switch[targetGUID][_type][unitN] then
					module.db.nowData.switch[targetGUID][_type][unitN] = {t[1],t[2]}
				end
				if t[1] < module.db.nowData.switch[targetGUID][_type][unitN][1] then
					module.db.nowData.switch[targetGUID][_type][unitN][1] = t[1]
					module.db.nowData.switch[targetGUID][_type][unitN][2] = t[2]
				end
			end
		end
	end
	for sourceGUID,destData in pairs(segmentData.cast) do
		if not module.db.nowData.cast[sourceGUID] then
			module.db.nowData.cast[sourceGUID] = {}
		end
		for i=1,#destData do
			module.db.nowData.cast[sourceGUID][ #module.db.nowData.cast[sourceGUID]+1 ] = destData[i]
		end
	end
	for i=1,#segmentData.auras do
		module.db.nowData.auras[ #module.db.nowData.auras + 1 ] = segmentData.auras[i]
	end
	if segmentData.dies then
		for i=1,#segmentData.dies do
			module.db.nowData.dies[ #module.db.nowData.dies + 1 ] = segmentData.dies[i]
		end
	end
	if segmentData.dispels then
		for i=1,#segmentData.dispels do
			module.db.nowData.dispels[ #module.db.nowData.dispels + 1 ] = segmentData.dispels[i]
		end
	end
	if segmentData.interrupts then
		for i=1,#segmentData.interrupts do
			module.db.nowData.interrupts[ #module.db.nowData.interrupts + 1 ] = segmentData.interrupts[i]
		end
	end
	if segmentData.chat then
		for i=1,#segmentData.chat do
			module.db.nowData.chat[ #module.db.nowData.chat + 1 ] = segmentData.chat[i]
		end
	end
	for sourceGUID,sourceData in pairs(segmentData.power) do
		local _sourceGUID = module.db.nowData.power[sourceGUID]
		if not _sourceGUID then
			_sourceGUID = {}
			module.db.nowData.power[sourceGUID] = _sourceGUID
		end
		for powerType,powerData in pairs(sourceData) do
			local _powerType = _sourceGUID[powerType]
			if not _powerType then
				_powerType = {}
				_sourceGUID[powerType] = _powerType
			end
			for spellID,spellData in pairs(powerData) do
				local _spellData = _powerType[spellID]
				if not _spellData then
					_spellData = {0,0}
					_powerType[spellID] = _spellData
				end
				_spellData[1] = _spellData[1] + spellData[1]
				_spellData[2] = _spellData[2] + spellData[2]
			end			
		end
	end
	for i=1,#segmentData.deathLog do
		local added_index = #module.db.nowData.deathLog + 1
		module.db.nowData.deathLog[added_index] = {}
		for j=1,#segmentData.deathLog[i] do
			module.db.nowData.deathLog[added_index][j] = segmentData.deathLog[i][j]
		end
	end
	for sourceGUID,sourceHP in pairs(segmentData.maxHP) do
		module.db.nowData.maxHP[sourceGUID] = sourceHP
	end
	
	for destGUID,destData in pairs(segmentData.reduction) do
		local _now = module.db.nowData.reduction[destGUID]
		if not _now then
			_now = {}
			module.db.nowData.reduction[destGUID] = _now
		end
		for sourceGUID,sourceData in pairs(destData) do
			local _source = _now[sourceGUID]
			if not _source then
				_source = {}
				_now[sourceGUID] = _source
			end
			for spellID,spellData in pairs(sourceData) do
				local _spell = _source[spellID]
				if not _spell then
					_spell = {}
					_source[spellID] = _spell
				end
				for reductorGUID,reductorData in pairs(spellData) do
					local _reductor = _spell[reductorGUID]
					if not _reductor then
						_reductor = {}
						_spell[reductorGUID] = _reductor
					end
					for spellID,amount in pairs(reductorData) do
						_reductor[spellID] = (_reductor[spellID] or 0) + amount
					end
				end
			end
		end
	end
	for sourceGUID,sourceData in pairs(segmentData.healFrom) do
		local _source = module.db.nowData.healFrom[sourceGUID]
		if not _source then
			_source = {}
			module.db.nowData.healFrom[sourceGUID] = _source
		end
		for destGUID,destData in pairs(sourceData) do
			local _dest = _source[destGUID]
			if not _dest then
				_dest = {}
				_source[destGUID] = _dest
			end
			for spellID,spellData in pairs(destData) do
				local _spell = _dest[spellID]
				if not _spell then
					_spell = {}
					_dest[spellID] = _spell
				end
				for fromSpellID,fromSpellAmount in pairs(spellData) do
					_spell[fromSpellID] = (_spell[fromSpellID] or 0) + fromSpellAmount
				end
			end
		end
	end
	if segmentData.summons then
		for i=1,#segmentData.summons do
			module.db.nowData.summons[ #module.db.nowData.summons + 1 ] = segmentData.summons[i]
		end
	end
	if segmentData.aurabroken then
		for i=1,#segmentData.aurabroken do
			module.db.nowData.aurabroken[ #module.db.nowData.aurabroken + 1 ] = segmentData.aurabroken[i]
		end
	end
	if segmentData.resurrests then
		for i=1,#segmentData.resurrests do
			module.db.nowData.resurrests[ #module.db.nowData.resurrests + 1 ] = segmentData.resurrests[i]
		end
	end
	if segmentData.tracking then
		for i=1,#segmentData.tracking do
			module.db.nowData.tracking[ #module.db.nowData.tracking + 1 ] = segmentData.tracking[i]
		end
	end
end

function StartSegment(name,subEvent)
	fightData_damage = {}
	fightData_damage_seen = {}
	fightData_heal = {}
	fightData_healFrom = {}
	fightData_switch = {}
	fightData_cast = {}
	fightData_auras = {}
	fightData_power = {}
	fightData_deathLog = {}
	fightData_maxHP = {}
	fightData_reduction = {}

	fightData = {
		damage = fightData_damage,
		damage_seen = fightData_damage_seen,
		heal = fightData_heal,
		healFrom = fightData_healFrom,
		switch = fightData_switch,
		cast = fightData_cast,
		--interrupts = {},	--Creating directly in event
		--dispels = {},		--Creating directly in event
		auras = fightData_auras,
		power = fightData_power,
		--dies = {},		--Creating directly in event
		--chat = {},		--Creating directly in event
		--resurrests = {},	--Creating directly in event
		--summons = {},		--Creating directly in event
		--aurabroken = {},	--Creating directly in event
		deathLog = fightData_deathLog,
		maxHP = fightData_maxHP,
		reduction = fightData_reduction,
		--tracking = {},	--Creating directly in event
		time = time(),
		timeEx = GetTime(),
		name = name,
		subEvent = subEvent,
	}
	module.db.data[1].fight[ #module.db.data[1].fight + 1 ] = fightData
end

local timers_improved_enabled = nil
local timers_improved_timer = 0.01
local timers_improved_segment = 1

local freezeFix = nil

function _BW_Start(encounterID,encounterName)
	module.db.lastFightID = module.db.lastFightID + 1
	
	freezeFix = nil

	local maxFights = (VExRT.BossWatcher.fightsNum or 10)
	for i=maxFights,2,-1 do
		if not freezeFix then
			freezeFix = module.db.data[i]
		end
		module.db.data[i] = module.db.data[i-1]
	end
	for i=(maxFights+1),25 do
		module.db.data[i] = nil
	end
	module.db.data[1] = {
		guids = {},
		raidguids = {},
		reaction = {},
		fight = {},
		pets = {},
		encounterName = encounterName,
		encounterID = encounterID,
		encounterStartGlobal = time(),
		encounterStart = GetTime(),
		encounterEnd = 0,
		graphData = {},
		positionsData = {},
		fightID = module.db.lastFightID,
	}
	
	wipe(deathLog)
	wipe(damageTakenLog)
	
	raidGUIDs = module.db.data[1].raidguids
	
	timers_improved_enabled = nil
	
	guidData = module.db.data[1].guids
	graphData = module.db.data[1].graphData
	reactionData = module.db.data[1].reaction
	positionsData = module.db.data[1].positionsData
	if VExRT.BossWatcher.Improved then
		UpdateNewSegmentEvents(true)
		module.db.data[1].improved = true
		timers_improved_enabled = true
		StartSegment()
		timers_improved_timer = 0.01
		timers_improved_segment = 1
	else
		StartSegment("ENCOUNTER_START")
	end	
	
	for event,_ in pairs(module.db.registerOtherEvents) do
		module:RegisterEvents(event)
	end
	module:RegisterEvents('COMBAT_LOG_EVENT_UNFILTERED','UNIT_TARGET','RAID_BOSS_EMOTE','RAID_BOSS_WHISPER','UPDATE_MOUSEOVER_UNIT')
	
	_graphSectionTimer = 0
	_graphSectionTimerRounded = 0
	_graphRaidSnapshot = {"boss1","boss2","boss3","boss4","boss5","target","focus"}
	_graphRaidEnergy = {
		module.db.energyPerClass["NO"][1],
		module.db.energyPerClass["NO"][1],
		module.db.energyPerClass["NO"][1],
		module.db.energyPerClass["NO"][1],
		module.db.energyPerClass["NO"][1],
		module.db.energyPerClass["NO"][1],
		module.db.energyPerClass["NO"][1],
	}
	
	_positionsTimer = 0.01
	_positionsTimerRounded = 0
	_positionsRaidSnapshot = {}
	
	wipe(var_reductionCurrent)

	module:RegisterTimer()
	if IsInRaid() then
		local gMax = ExRT.F.GetRaidDiffMaxGroup()
		for i=1,40 do
			local name,_,subgroup,_,_,class = GetRaidRosterInfo(i)
			if name and subgroup <= gMax then
				_graphRaidSnapshot[#_graphRaidSnapshot + 1] = name
				_positionsRaidSnapshot[#_positionsRaidSnapshot + 1] = name
				local energy = module.db.energyPerClass[class or "NO"]
				if name == ExRT.SDB.charName then
					energy = energy and energy[2]
				else
					energy = energy and energy[1]
				end
				_graphRaidEnergy[#_graphRaidSnapshot] = energy or module.db.energyPerClass["NO"][1]
				
				local guid = UnitGUID(name)
				if guid then
					raidGUIDs[ guid ] = name
					
					addReductionOnPull(name,guid)
				end				
			end
		end
	else
		for i=1,5 do
			local unit = i==5 and "player" or "party"..i
			local name = UnitCombatlogname(unit)
			if name then
				_graphRaidSnapshot[#_graphRaidSnapshot + 1] = name
				_positionsRaidSnapshot[#_positionsRaidSnapshot + 1] = name
				
				local _,class = UnitClass(unit)
				local energy = module.db.energyPerClass[class or "NO"]
				if i == 5 then
					energy = energy and energy[2]
				else
					energy = energy and energy[1]
				end
				_graphRaidEnergy[#_graphRaidSnapshot] = energy or module.db.energyPerClass["NO"][1]
				
				local guid = UnitGUID(name)
				if guid then
					raidGUIDs[ guid ] = name
					
					addReductionOnPull(name,guid)
				end
			end
		end
	end
	
	if encounterID == 1784 then
		wipe(encounterSpecial)
		UpdateCLEUfunctionsByEncounter(1784)
	end
	
	local isPlayerOnMap = GetPlayerMapPosition'player'
	if isPlayerOnMap ~= 0 then
		local mapName = GetMapInfo()
		local dungeonLevel,xR,yB,xL,yT = GetCurrentMapDungeonLevel()
		if not xR then
			local _,MxL,MyT,MxR,MyB = GetCurrentMapZone()
			xR,yB,xL,yT = MxR,MyB,MxL,MyT
		end
		if DungeonUsesTerrainMap() then
			dungeonLevel = dungeonLevel - 1
		end
		if not (dungeonLevel > 0) then
			dungeonLevel = nil
		end
		positionsData.mapInfo = {
			map = mapName,
			level = dungeonLevel,
			xL = xL,
			xR = xR,
			yT = yT,
			yB = yB,
		}
	end
end

local function GetCurrentZoneID()
	local zoneID = 0
	local zoneName, zoneType, difficulty, _, _, _, _, mapID = GetInstanceInfo()
	if difficulty == 8 then
		zoneID = 3
	elseif zoneType == 'raid' and ((tonumber(mapID) and mapID >= 603) or mapID == 533) then
		zoneID = 1
	elseif zoneType == 'arena' or zoneType == 'pvp' then
		zoneID = 2
	end
	return zoneID, zoneName
end

function module.main:ENCOUNTER_START(encounterID,encounterName)
	local zoneID = GetCurrentZoneID()
	if zoneID == 1 then
		_BW_Start(encounterID,encounterName)
	end
end
function module.main:PLAYER_REGEN_DISABLED()
	local zoneID = GetCurrentZoneID()
	if zoneID == 0 then
		_BW_Start()
	end
end
function module.main:CHALLENGE_MODE_START()
	local _,zoneName = GetCurrentZoneID()
	_BW_Start(nil,zoneName)
end

function _BW_End(encounterID)
	if fightData then
		module.db.data[1].encounterEnd = GetTime()
		module.db.data[1].timeFix = module.db.timeFix
		module.db.data[1].ExRTver = ExRT.V
		module.db.data[1].isEnded = true
		
		if not module.db.data[1].encounterName then
			local minSeen,minGUID = nil
			for GUID,seen in pairs(module.db.data[1].fight[1].damage_seen) do
				if (not minSeen or minSeen > seen) and ExRT.F.GetUnitInfoByUnitFlag(module.db.data[1].reaction[GUID],3) == 64 then
					minGUID = GUID
					minSeen = seen
				end
			end
			if minGUID and module.db.data[1].guids[minGUID] and module.db.data[1].guids[minGUID] ~= "nil" then
				module.db.data[1].encounterName = module.db.data[1].guids[minGUID]
			end
		end
		
		local GLOBALpets = ExRT.F.Pets:getPetsDB()
		for GUID,name in pairs(module.db.data[1].guids) do
			local petData = GLOBALpets[GUID]
			if petData then
				module.db.data[1].pets[GUID] = petData
			end
		end
	end
	if VExRT.BossWatcher.Improved then
		wipe(encounterSpecial)
		UpdateNewSegmentEvents()
	end
	
	if encounterID == 1784 then
		UpdateCLEUfunctionsByEncounter()
	end

	module:UnregisterEvents('COMBAT_LOG_EVENT_UNFILTERED','UNIT_TARGET','RAID_BOSS_EMOTE','RAID_BOSS_WHISPER','UPDATE_MOUSEOVER_UNIT')
	for event,_ in pairs(module.db.registerOtherEvents) do
		module:UnregisterEvents(event)
	end
	module:UnregisterTimer()
	fightData = nil
	guidData = nil
	graphData = nil
	reactionData = nil
	
	wipe(deathLog)
	wipe(var_reductionCurrent)
	wipe(damageTakenLog)
	
	if freezeFix then
		wipe(freezeFix)
		freezeFix = nil
	end
	
	fightData_damage = nil
	fightData_damage_seen = nil
	fightData_heal = nil
	fightData_healFrom = nil
	fightData_switch = nil
	fightData_cast = nil
	fightData_auras = nil
	fightData_power = nil
	fightData_deathLog = nil
	fightData_maxHP = nil
	fightData_reduction = nil
end
function module.main:ENCOUNTER_END(encounterID)
	local zoneID = GetCurrentZoneID()
	if zoneID == 1 then
		_BW_End(encounterID)
	end
end
function module.main:PLAYER_REGEN_ENABLED()
	local zoneID = GetCurrentZoneID()
	if zoneID == 0 then
		_BW_End()
	end
end
function module.main:CHALLENGE_MODE_RESET()
	if fightData then
		_BW_End()
	end
end
module.main.CHALLENGE_MODE_COMPLETED = module.main.CHALLENGE_MODE_RESET

do
	local function ZoneCheck()
		local zoneID, zoneName = GetCurrentZoneID()
		if zoneID == 2 then
			_BW_Start(nil,zoneName)
		end
	end
	function module.main:ZONE_CHANGED_NEW_AREA()
		if fightData then
			_BW_End()
		end
		ExRT.F.ScheduleTimer(ZoneCheck,2)
	end
end


do
	function module:timer(elapsed)
		--------------> Graphs
		do
			_graphSectionTimer = _graphSectionTimer + elapsed
			local nowTimer = ceil(_graphSectionTimer)
			if _graphSectionTimerRounded ~= nowTimer then
				_graphSectionTimerRounded = nowTimer
				local data = {}
				graphData[_graphSectionTimerRounded] = data
				for i=1,#_graphRaidSnapshot do
					local name = _graphRaidSnapshot[i]
					local _name = i <= 7 and UnitCombatlogname(name)
					if i > 7 or _name then
						local health = UnitHealth(name)
						local hpmax = UnitHealthMax(name)
						local absorbs = UnitGetTotalAbsorbs(name)
						
						local currData = {
							name = _name or nil,
							health = health ~= 0 and health or nil,
							hpmax = hpmax ~= 0 and hpmax or nil,
							absorbs = absorbs ~= 0 and absorbs or nil,
						}
						data[name] = currData

						local energy = _graphRaidEnergy[i]
						for j=1,#energy do
							local powerID = energy[j]
							local power = UnitPower(name,powerID)
							if power ~= 0 then
								currData[powerID] = power
							end
						end
					end
				end
			end
		end
		
		--------------> Improved mode: starting new segments
		if timers_improved_enabled then
			timers_improved_timer = timers_improved_timer + elapsed
			local nowTimer = ceil(timers_improved_timer)
			if timers_improved_segment ~= nowTimer then
				timers_improved_segment = nowTimer
				StartSegment()
			end
		end
		
		--------------> Positions
		do
			_positionsTimer = _positionsTimer + elapsed
			local nowTimer = ceil(_positionsTimer * 2)
			if _positionsTimerRounded ~= nowTimer then
				_positionsTimerRounded = nowTimer
				local data = {}
				positionsData[_positionsTimerRounded] = data
				for i=1,#_positionsRaidSnapshot do
					local name = _positionsRaidSnapshot[i]
					local y,x,z,map = UnitPosition(name)
					data[name] = {x,y,map}
				end
			end
		end
	end
end


function module.main:SWING_DAMAGE(timestamp,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,amount,overkill,school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand, multistrike)
	addDamage(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,6603,nil,nil,amount,overkill,school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand, multistrike)
end

function module.main:SPELL_INSTAKILL(timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,_,school)
	addDamage(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,spellID,nil,nil,9999999,9999999,school)
end

function module.main:SPELL_AURA_APPLIED_DOSE(timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,_,_,type,stack)
	fightData_auras[ #fightData_auras + 1 ] = {timestamp,sourceGUID,destGUID,UnitIsFriendlyByUnitFlag(sourceFlags),UnitIsFriendlyByUnitFlag(destFlags),spellID,type,3,stack}
end

function module.main:SPELL_AURA_REMOVED_DOSE(timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,_,_,type,stack)
	fightData_auras[ #fightData_auras + 1 ] = {timestamp,sourceGUID,destGUID,UnitIsFriendlyByUnitFlag(sourceFlags),UnitIsFriendlyByUnitFlag(destFlags),spellID,type,4,stack}
end

function module.main:UNIT_DIED(timestamp,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID)
	if destName and UnitIsFeignDeath(destName) then
		return
	end
	
	if not fightData.dies then
		fightData.dies = {}
	end

	fightData.dies[#fightData.dies+1] = {destGUID,destFlags,timestamp,destFlags2}
	
	addDeath(destGUID,timestamp)
	
	
	--------------> Add healing from
	local healingFromData = damageTakenLog[destGUID]
	if healingFromData then
		wipe(healingFromData)
	end
	
	local uID = GUIDtoID(destGUID)
	if autoSegmentsUPValue.UNIT_DIED[ uID ] then
		StartSegment("UNIT_DIED",uID)
	end
end

function module.main:SPELL_INTERRUPT(timestamp,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,_,_,destSpell)
	if not fightData.interrupts then
		fightData.interrupts = {}
	end
	fightData.interrupts[#fightData.interrupts+1]={sourceGUID,destGUID,spellID,destSpell,timestamp}
end

function module.main:SPELL_DISPEL(timestamp,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,_,_,destSpell)
	if not fightData.dispels then
		fightData.dispels = {}
	end
	fightData.dispels[#fightData.dispels+1]={sourceGUID,destGUID,spellID,destSpell,timestamp}
end

function module.main:SPELL_RESURRECT(timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID)
	if not fightData.resurrests then
		fightData.resurrests = {}
	end
	fightData.resurrests[#fightData.resurrests+1]={sourceGUID,destGUID,spellID,timestamp}
end

function module.main:SWING_MISSED(timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,missType,isOffHand,multistrike,amountMissed)
	AddMiss(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,6603,nil,0x1,missType,isOffHand,multistrike,amountMissed)
end
if ExRT.is7 then
	function module.main:SWING_MISSED(timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,missType,isOffHand,amountMissed)
		AddMiss(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,6603,nil,0x1,missType,isOffHand,amountMissed)
	end
end

function module.main:SPELL_SUMMON(timestamp,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID)
	if not fightData.summons then
		fightData.summons = {}
	end
	fightData.summons[#fightData.summons+1]={sourceGUID,destGUID,spellID,timestamp}
end

function module.main:SPELL_DRAIN(timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,_,_,amount,powerType,extraAmount)
	addPower(nil,timestamp,destGUID,destName,destFlags,nil,sourceGUID,sourceName,sourceFlags,nil,spellID,nil,nil,-amount,powerType)
end
function module.main:SPELL_LEECH(timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,_,_,amount,powerType,extraAmount)
	addPower(nil,timestamp,destGUID,destName,destFlags,nil,sourceGUID,sourceName,sourceFlags,nil,spellID,nil,nil,-amount,powerType)
	if extraAmount then
		addPower(nil,timestamp,sourceGUID,sourceName,sourceFlags,nil,destGUID,destName,destFlags,nil,spellID,nil,nil,extraAmount,powerType)
	end
end
function module.main:SPELL_AURA_BROKEN(timestamp,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,_,_,extraSpellId,_,_,auraType)
	if not auraType then
		auraType = extraSpellId		--SPELL_AURA_BROKEN instead SPELL_AURA_BROKEN_SPELL
		extraSpellId = 6603
	end
	if not fightData.aurabroken then
		fightData.aurabroken = {}
	end
	fightData.aurabroken[#fightData.aurabroken+1]={sourceGUID,destGUID,spellID,extraSpellId,timestamp,auraType}
end

local CLEUEvents = {
	SPELL_HEAL = addHeal,
	SPELL_PERIODIC_HEAL = addHeal,
	SPELL_ABSORBED = addAbsorbs,
	SPELL_DAMAGE = addDamage,
	SPELL_PERIODIC_DAMAGE = addDamage,
	RANGE_DAMAGE = addDamage,
	SWING_DAMAGE = module.main.SWING_DAMAGE,
	SPELL_INSTAKILL = module.main.SPELL_INSTAKILL,
	SPELL_MISSED = AddMiss,
	SPELL_PERIODIC_MISSED = AddMiss,
	RANGE_MISSED = AddMiss,
	SWING_MISSED = module.main.SWING_MISSED,
	SPELL_AURA_APPLIED = addAura,
	SPELL_AURA_REMOVED = removeAura,
	SPELL_AURA_APPLIED_DOSE = module.main.SPELL_AURA_APPLIED_DOSE,
	SPELL_AURA_REMOVED_DOSE = module.main.SPELL_AURA_REMOVED_DOSE,
	SPELL_CAST_SUCCESS = addCastEnded,
	SPELL_CAST_START = addCastStarted,
	UNIT_DIED = module.main.UNIT_DIED,
	UNIT_DESTROYED = module.main.UNIT_DIED,
	SPELL_INTERRUPT = module.main.SPELL_INTERRUPT,
	SPELL_DISPEL = module.main.SPELL_DISPEL,
	SPELL_STOLEN = module.main.SPELL_DISPEL,
	SPELL_RESURRECT = module.main.SPELL_RESURRECT,
	SPELL_ENERGIZE = addPower,
	SPELL_PERIODIC_ENERGIZE = addPower,
	SPELL_DRAIN = module.main.SPELL_DRAIN,
	SPELL_PERIODIC_DRAIN = module.main.SPELL_DRAIN,
	SPELL_LEECH = module.main.SPELL_LEECH,
	SPELL_PERIODIC_LEECH = module.main.SPELL_LEECH,
	ENVIRONMENTAL_DAMAGE = AddEnvironmentalDamage,
	SPELL_CREATE = module.main.SPELL_SUMMON,
	SPELL_SUMMON = module.main.SPELL_SUMMON,
	DAMAGE_SPLIT = addDamage,
	SPELL_AURA_BROKEN = module.main.SPELL_AURA_BROKEN,
	SPELL_AURA_BROKEN_SPELL = module.main.SPELL_AURA_BROKEN,
	-- DAMAGE_SHIELD
	-- DAMAGE_SHIELD_MISSED
	-- UNIT_DISSIPATES
	-- SPELL_BUILDING_DAMAGE
	-- SPELL_BUILDING_HEAL
}

--[[
local debugTimeByEvents = {}
local debugprofilestop = debugprofilestop
function ExRT_BW_Debug_TimeByEvents()
	local q={}
	for w,e in pairs(debugTimeByEvents) do
		q[#q+1]={w,e[1]/e[2]}
	end
	sort(q,function(a,b)return a[2]>b[2] end)
	for i=1,#q do
		print(q[i][1],q[i][2])
	end
end
]]

local function CLEUafterTimeFix(self,_,timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,...)
	--local t = debugprofilestop()
	local eventFunc = CLEUEvents[event]
	if eventFunc then
		eventFunc(self,timestamp,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,...)
	end
	
	if not guidData[sourceGUID] then guidData[sourceGUID] = sourceName or "nil" end
	if not guidData[destGUID] then guidData[destGUID] = destName or "nil" end
	
	reactionData[sourceGUID] = sourceFlags
	reactionData[destGUID] = destFlags
	
	--t = debugprofilestop() - t
	--debugTimeByEvents[event] = debugTimeByEvents[event] or {0,0}
	--debugTimeByEvents[event][1] = debugTimeByEvents[event][1] + t
	--debugTimeByEvents[event][2] = debugTimeByEvents[event][2] + 1
end

function module.main:COMBAT_LOG_EVENT_UNFILTERED(_,timestamp,...)
	if not module.db.timeFix then
		module.db.timeFix = {GetTime(),timestamp}
	end
	module.main.COMBAT_LOG_EVENT_UNFILTERED = CLEUafterTimeFix
	CLEUafterTimeFix(self,nil,timestamp,...)
	module:RegisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
end

function UpdateCLEUfunctionsByEncounter(encounterID)
	if encounterID == 1784 then	-- "Tyrant Velhari"
		CLEUEvents.SPELL_HEAL = addHeal_TyrantVelhari
		CLEUEvents.SPELL_PERIODIC_HEAL = addHeal_TyrantVelhari
		CLEUEvents.SPELL_AURA_APPLIED = addAura_TyrantVelhari
		CLEUEvents.SPELL_AURA_REMOVED = removeAura_TyrantVelhari
	else
		CLEUEvents.SPELL_HEAL = addHeal
		CLEUEvents.SPELL_PERIODIC_HEAL = addHeal
		CLEUEvents.SPELL_AURA_APPLIED = addAura
		CLEUEvents.SPELL_AURA_REMOVED = removeAura
	end
end


function module.main:UNIT_SPELLCAST_SUCCEEDED(unitID,_,_,_,spellID)
	if autoSegmentsUPValue.UNIT_SPELLCAST_SUCCEEDED[spellID] then
		local guid = UnitGUID(unitID)
		if AntiSpam("BossWatcherUSS"..(guid or "0x0")..(spellID or "0"),0.5) then
			StartSegment("UNIT_SPELLCAST_SUCCEEDED",spellID)
		end
	end
end
if ExRT.is7 then
	function module.main:UNIT_SPELLCAST_SUCCEEDED(unitID,_,_,spellLine)
		local unitType,_,serverID,instanceID,zoneUID,spellID,spawnID = strsplit("-", spellLine or "")
		spellID = tonumber(spellID or 0) or 0
		if autoSegmentsUPValue.UNIT_SPELLCAST_SUCCEEDED[spellID] then
			local guid = UnitGUID(unitID)
			if AntiSpam("BossWatcherUSS"..(guid or "0x0")..(spellID or "0"),0.5) then
				StartSegment("UNIT_SPELLCAST_SUCCEEDED",spellID)
			end
		end
	end
end

function module.main:CHAT_MSG_RAID_BOSS_EMOTE(msg,sender)
	for emote,_ in pairs(autoSegmentsUPValue.CHAT_MSG_RAID_BOSS_EMOTE) do
		if msg:find(emote, nil, true) or msg:find(emote) then
			StartSegment("CHAT_MSG_RAID_BOSS_EMOTE",emote)
		end
	end
end

function module.main:RAID_BOSS_EMOTE(msg,sender)
	local spellID = msg:match("spell:(%d+)")
	if spellID then
		if not fightData.chat then
			fightData.chat = {}
		end
		fightData.chat[ #fightData.chat + 1 ] = {sender,msg,spellID,GetTime()}
	end
end
module.main.RAID_BOSS_WHISPER = module.main.RAID_BOSS_EMOTE

function module.main:UNIT_TARGET(unitID)
	local targetGUID = UnitGUID(unitID.."target")
	if targetGUID and not UnitIsPlayerOrPet(targetGUID) then
		local sourceGUID = UnitGUID(unitID)
		if GetUnitTypeByGUID(sourceGUID) == 0 then
			addSwitch(sourceGUID,targetGUID,GetTime(),2)
		end
		if not fightData_maxHP[targetGUID] then
			fightData_maxHP[targetGUID] = UnitHealthMax(unitID.."target")
		end
	end
end

function module.main:UPDATE_MOUSEOVER_UNIT()
	local sourceGUID = UnitGUID("mouseover")
	if sourceGUID and not fightData_maxHP[sourceGUID] then
		fightData_maxHP[sourceGUID] = UnitHealthMax("mouseover")
		addGUID(sourceGUID,UnitName("mouseover"))
	end
end

local function GlobalRecordStart()
	if not VExRT.BossWatcher.enabled then
		return
	end
	module:UnregisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED','ENCOUNTER_START','ENCOUNTER_END')
	if fightData then
		_BW_End()
	end
	_BW_Start()
	
	print(L.BossWatcherRecordStart)
end

local function GlobalRecordEnd()
	if not VExRT.BossWatcher.enabled then
		return
	end
	_BW_End()
	module:RegisterEvents('PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED','ENCOUNTER_START','ENCOUNTER_END')
	print(L.BossWatcherRecordStop)
end

function module:slash(arg)
	if arg == "seg" then
		if not fightData or not VExRT.BossWatcher.enabled or VExRT.BossWatcher.Improved then
			return
		end
		StartSegment("SLASH")
		print("New segment")
	elseif arg == "bw s" or arg == "bw start" or arg == "fl s" or arg == "fl start" then
		GlobalRecordStart()
		print( ExRT.F.CreateChatLink("BWGlobalRecordEnd",GlobalRecordEnd,L.BossWatcherStopRecord), L.BossWatcherStopRecord2 )
	elseif arg == "bw e" or arg == "bw end" or arg == "fl e" or arg == "fl end" then
		GlobalRecordEnd()
	elseif arg == "bw" or arg == "fl" then
		BWInterfaceFrameLoadFunc()
	elseif arg == "bw clear" or arg == "fl clear" or arg == "bw c" or arg == "fl c" then
		module:ClearData()
		print('Cleared')
	elseif arg == "bw reset" or arg == "fl reset" then
		VExRT.BossWatcher.SAVED_DATA = nil
		print('Cleared')
	elseif arg == "bw save" or arg == "fl save" then
		VExRT.BossWatcher.saveVariables = true
		VExRT.BossWatcher.SAVED_DATA = module.db.data
		print('Saved')
	elseif arg:find("^bw maxhp ") or arg:find("^fl maxhp ") then
		local unitname = arg:match("^bw maxhp (.+)")
		if not unitname then
			unitname = arg:match("^fl maxhp (.+)")
		end
		if unitname then
			unitname = unitname:lower()
			for GUID,GUIDname in pairs(module.db.data[module.db.nowNum].guids) do
				if GUIDname:lower():find(unitname) then
					local maxhp = module.db.nowData.maxHP[GUID]
					if maxhp then
						print(format("%s's max hp: %d",GUIDname,maxhp))
					end
				end
			end
		end
	end
end
ExRT.F.BWNS = StartSegment

function module:ClearData()
	module.db.lastFightID = module.db.lastFightID + 1
	module.db.nowNum = 1
	module.db.data = {
		{
			guids = {},
			reaction = {},
			fight = {},
			pets = {},
			encounterName = nil,
			encounterStartGlobal = time(),
			encounterStart = GetTime(),
			encounterEnd = GetTime()+1,
			isEnded = true,
			graphData = {},
			positionsData = {},
			fightID = module.db.lastFightID,
		},
	}
	ExRT.F.ScheduleTimer(collectgarbage, 1, "collect")
	if BWInterfaceFrame and BWInterfaceFrame:IsShown() then
		BWInterfaceFrame:Hide()
		BWInterfaceFrame:Show()
	end
end

function BWInterfaceFrameLoad()
	if InCombatLockdown() then
		print(L.SetErrorInCombat)
		return
	end
	isBWInterfaceFrameLoaded = true
	
	-- Some upvaules
	local ipairs,pairs,tonumber,tostring,format,date,min,sort,table = ipairs,pairs,tonumber,tostring,format,date,min,sort,table
	local GetSpellInfo = GetSpellInfo
	
	local BWInterfaceFrame_Name = 'GExRTBWInterfaceFrame'
	BWInterfaceFrame = ELib:Template("ExRTBWInterfaceFrame",UIParent)
	_G[BWInterfaceFrame_Name] = BWInterfaceFrame
	BWInterfaceFrame:SetPoint("CENTER",0,0)
	BWInterfaceFrame.HeaderText:SetText(L.BossWatcher)
	BWInterfaceFrame.backToInterface:SetText("<<")
	BWInterfaceFrame:SetMovable(true)
	BWInterfaceFrame:RegisterForDrag("LeftButton")
	BWInterfaceFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
	BWInterfaceFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	BWInterfaceFrame:SetDontSavePosition(true)
		
	ELib:ShadowInside(BWInterfaceFrame)
	
	module.options.SecondFrame = BWInterfaceFrame

	BWInterfaceFrame.border = ELib:Shadow(BWInterfaceFrame,20)

	BWInterfaceFrame.DecorationLine = ELib:Frame(BWInterfaceFrame):Point("TOPLEFT",BWInterfaceFrame,0,-40):Point("BOTTOMRIGHT",BWInterfaceFrame,"TOPRIGHT",0,-60):Texture(1,1,1,1):TexturePoint('x')
	BWInterfaceFrame.DecorationLine.texture:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)
				
	BWInterfaceFrame.backToInterface.tooltipText = L.BossWatcherBackToInterface
	BWInterfaceFrame.buttonClose.tooltipText = L.BossWatcherButtonClose
	
	BWInterfaceFrame:Hide()
	
	BWInterfaceFrame.bossButton:SetText(L.BossWatcherLastFight)
	BWInterfaceFrame.bossButton:SetWidth(BWInterfaceFrame.bossButton:GetTextWidth()+30)
	
	local reportData = {{},{},{},{ {},{},{} },{},{},{},{},{}}
	local reportOptions = {}
	BWInterfaceFrame.report = ELib:Button(BWInterfaceFrame,L.BossWatcherCreateReport):Size(150,18):Point("TOPRIGHT",BWInterfaceFrame,"TOPRIGHT",-4,-18):Tooltip(L.BossWatcherCreateReportTooltip):OnClick(function ()
		local activeTab = BWInterfaceFrame.tab.selected	
			
		---Tab with mobs fix
		if activeTab == 4 then
			local activeTabOnPage = BWInterfaceFrame.tab.tabs[4].infoTabs.selected
			ExRT.F:ToChatWindow(reportData[4][activeTabOnPage])
			return		
		end
		
		ExRT.F:ToChatWindow(reportData[activeTab],nil,reportOptions[activeTab])
	end)
	BWInterfaceFrame.report:Hide()
	
	
	---- Some updates
	for i=5,#module.db.buffsFilters do
		for _,sID in ipairs(module.db.buffsFilters[i][-2]) do
			module.db.buffsFilters[i][sID] = true
		end
	end
	
	
	---- Helpful functions
	local function GetGUID(GUID)
		if GUID and module.db.data[module.db.nowNum].guids[GUID] and module.db.data[module.db.nowNum].guids[GUID] ~= "nil" then
			return module.db.data[module.db.nowNum].guids[GUID]
		else
			return L.BossWatcherUnknown
		end
	end
	
	local function GetPetsDB()
		return module.db.data[module.db.nowNum].pets
	end
	
	local function CloseDropDownMenus_fix()
		CloseDropDownMenus()
	end
	
	local function timestampToFightTime(time)
		if not time then
			return 0
		end
		local fixTable = module.db.data[module.db.nowNum].timeFix
		if not fixTable and module.db.timeFix then
			fixTable = module.db.timeFix
		elseif not fixTable and not module.db.timeFix then
			return 0
		end
		local res = time - (fixTable[2] - fixTable[1] + module.db.data[module.db.nowNum].encounterStart) 
		return max(res,0)
	end
	
	local function GUIDtoText(patt,GUID)
		if VExRT.BossWatcher.GUIDs and GUID and GUID ~= "" then
			patt = patt or "%s"
			local _type = ExRT.F.GetUnitTypeByGUID(GUID)
			if _type == 0 then
				return ""
			elseif _type == 3 or _type == 5 then
				local mobSpawnID = nil
				local spawnID = GUID:match("%-([^%-]+)$")
				if spawnID then
					mobSpawnID = tonumber(spawnID, 16)
				end
				if mobSpawnID then
					return format(patt,tostring(mobSpawnID))
				else
					return format(patt,GUID)
				end
			else
				return format(patt,GUID)
			end
		else
			return ""
		end
	end
	
	local function SetSchoolColorsToLine(self,school)
		local isNotGradient = ExRT.F.table_find(module.db.schoolsDefault,school) or school == 0
		if isNotGradient and module.db.schoolsColors[school] then
			self:SetVertexColor(module.db.schoolsColors[school].r,module.db.schoolsColors[school].g,module.db.schoolsColors[school].b, 1)
		else
			local school1,school2 = nil
			for i=1,#module.db.schoolsDefault do
				local isSchool = bit.band(school,module.db.schoolsDefault[i]) > 0
				if isSchool and not school1 then
					school1 = module.db.schoolsDefault[i]
				elseif isSchool and not school2 then
					school2 = module.db.schoolsDefault[i]
				end
			end
			if school1 and school2 then
				self:SetVertexColor(1,1,1,1)
				self:SetGradientAlpha("HORIZONTAL", module.db.schoolsColors[school1].r,module.db.schoolsColors[school1].g,module.db.schoolsColors[school1].b,1,module.db.schoolsColors[school2].r,module.db.schoolsColors[school2].g,module.db.schoolsColors[school2].b,1)
			elseif school1 and not school2 then
				self:SetVertexColor(module.db.schoolsColors[school1].r,module.db.schoolsColors[school1].g,module.db.schoolsColors[school1].b, 1)
			else
				self:SetVertexColor(0.8,0.8,0.8, 1)
			end
		end
	end
	local function GetSchoolName(school)
		if not school or module.db.schoolsNames[school]	then
			return  module.db.schoolsNames[school or 0]
		else
			local school1,school2 = nil
			for i=1,#module.db.schoolsDefault do
				local isSchool = bit.band(school,module.db.schoolsDefault[i]) > 0
				if isSchool and not school1 then
					school1 = module.db.schoolsDefault[i]
				elseif isSchool and not school2 then
					school2 = module.db.schoolsDefault[i]
				end
			end
			if school1 and school2 then
				return module.db.schoolsNames[school1] .. "-" .. module.db.schoolsNames[school2]
			elseif school1 and not school2 then
				return module.db.schoolsNames[school1]
			else
				return module.db.schoolsNames[0]
			end
		end
	end
	local function GetUnitInfoByUnitFlagFix(unitFlag,infoType)
		if not unitFlag then
			return
		end
		return GetUnitInfoByUnitFlag(unitFlag,infoType)
	end
	local function GetFightLength()
		local currFight = module.db.data[module.db.nowNum]
		if BWInterfaceFrame.nowFightID ~= BWInterfaceFrame.tab.tabs[11].lastFightID then
			if not currFight.isEnded then
				return GetTime() - currFight.encounterStart
			end
			return (currFight.encounterEnd - currFight.encounterStart)
		end
		local length = 0
		for i=1,#currFight.fight do
			if BWInterfaceFrame.tab.tabs[11].segmentsList.C[i] then
				length = length + ( currFight.fight[i+1] and currFight.fight[i+1].timeEx or currFight.encounterEnd ) - currFight.fight[i].timeEx
			end
		end
		return length
	end
	local function SubUTF8String(str,len)
		local strlen = ExRT.F:utf8len(str)
		if strlen > len then
			str = ExRT.F:utf8sub(str,1,len) .. "..."
		end
		return str
	end

	
	---- Bugfix functions
	local _GetSpellLink = GetSpellLink
	local function GetSpellLink(spellID)
		local link = _GetSpellLink(spellID)
		if link then
			return link
		end
		local spellName = GetSpellInfo(spellID)
		return spellName or "Unk"
	end
	
	---- Update functions
	local function ClearAndReloadData(isSegmentReload)
		module.db.nowData = {
			damage = {},
			damage_seen = {},
			heal = {},
			healFrom = {},
			switch = {},
			cast = {},
			interrupts = {},
			dispels = {},
			auras = {},
			power = {},
			dies = {},
			chat = {},
			resurrests = {},
			summons = {},
			aurabroken = {},
			deathLog = {},
			maxHP = {},
			reduction = {},
			tracking = {},
		}
		if not module.db.data[module.db.nowNum] or isSegmentReload then
			return
		end
		for i=1,#module.db.data[module.db.nowNum].fight do
			AddSegmentToData(i)
		end
	end
	
	BWInterfaceFrame:SetScript("OnShow",function (self)
		local fightData = module.db.data[module.db.nowNum]
		if self.nowFightID ~= fightData.fightID then
			local isInRecording = not fightData.isEnded
			if isInRecording then
				print(L.BossWatcherCombatError)
				--return
			end
			ClearAndReloadData()
			self.nowFightID = fightData.fightID
			local _time = ((isInRecording and GetTime() or fightData.encounterEnd) - fightData.encounterStart)
			self.bossButton:SetText( (fightData.encounterName or L.BossWatcherLastFight)..date(": %H:%M - ", fightData.encounterStartGlobal )..date("%H:%M", fightData.encounterStartGlobal + _time )..format(" (%dm%02ds)",floor(_time/60),_time%60 )..(isInRecording and " *" or "") )
			self.bossButton:SetWidth(self.bossButton:GetTextWidth()+30)
			for i=1,#reportData do
				if i ~= 4 then
					wipe(reportData[i])
				else
					wipe(reportData[4][1])
					wipe(reportData[4][2])
					wipe(reportData[4][3])
				end
			end
			--self:Hide()
			--self:Show()
		end
		BWInterfaceFrame.tab:Show()
	end)
	BWInterfaceFrame:SetScript("OnHide",function (self)
		BWInterfaceFrame.tab:Hide()
	end)
	
	BWInterfaceFrame.bossButtonDropDown = CreateFrame("Frame", BWInterfaceFrame_Name.."BossButtonDropDown", nil, "UIDropDownMenuTemplate")
	BWInterfaceFrame.bossButton:SetScript("OnClick",function (self)
		local fightsList = {
			{
				text = L.BossWatcherSelectFight, 
				isTitle = true, 
				notCheckable = true, 
				notClickable = true 
			},
		}
		for i=1,#module.db.data do
			local colorCode = ""
			if i == module.db.nowNum then
				colorCode = "|cff00ff00"
			end
			local fightData = module.db.data[i]
			local _time = (fightData.isEnded and fightData.encounterEnd or GetTime()) - fightData.encounterStart
			fightsList[#fightsList + 1] = {
				text = i..". "..colorCode..(fightData.encounterName or L.BossWatcherLastFight)..date(": %H:%M - ", fightData.encounterStartGlobal )..date("%H:%M", fightData.encounterStartGlobal + _time )..format(" (%dm%02ds)",floor(_time/60),_time%60 )..(fightData.isEnded and "" or " *"),
				notCheckable = true,
				func = function() 
					module.db.nowNum = i
					self:SetText( (fightData.encounterName or L.BossWatcherLastFight)..date(": %H:%M - ", fightData.encounterStartGlobal )..date("%H:%M", fightData.encounterStartGlobal + _time )..format(" (%dm%02ds)",floor(_time/60),_time%60 )..(fightData.isEnded and "" or " *") )
					self:SetWidth(self:GetTextWidth()+30)
					if not fightData.isEnded then
						BWInterfaceFrame.nowFightID = -1
					end
					BWInterfaceFrame:Hide()
					BWInterfaceFrame:Show()
				end,
			}
		end
		fightsList[#fightsList + 1] = {
			text = L.cd2HistoryClear,
			notCheckable = true,
			func = function()
				StaticPopupDialogs["EXRT_FIGHTLOG_CLEAR"] = {
					text = L.cd2HistoryClear,
					button1 = L.YesText,
					button2 = L.NoText,
					OnAccept = function()
						module:ClearData()
					end,
					timeout = 0,
					whileDead = true,
					hideOnEscape = true,
					preferredIndex = 3,
				}
				StaticPopup_Show("EXRT_FIGHTLOG_CLEAR")
			end,
		}
		fightsList[#fightsList + 1] = {
			text = L.BossWatcherSelectFightClose,
			notCheckable = true,
			func = CloseDropDownMenus_fix,
		}
		EasyMenu(fightsList, BWInterfaceFrame.bossButtonDropDown, "cursor", 10 , -15, "MENU")
	end)
	BWInterfaceFrame.bossButton.tooltipText = L.BossWatcherSelectFight
	
	
	---- Tabs
	BWInterfaceFrame.tab = ELib:Tabs(BWInterfaceFrame,0,
		L.BossWatcherTabMobs,
		L.BossWatcherTabHeal,
		L.BossWatcherTabBuffsAndDebuffs,
		L.BossWatcherTabEnemy,
		L.BossWatcherTabPlayersSpells,
		L.BossWatcherTabEnergy,
		L.BossWatcherTabInterruptAndDispelShort,
		TRACKING,
		L.BossWatcherDeath,
		L.BossWatcherPositions,
		L.BossWatcherSegments,
		L.BossWatcherTabSettings
	):Size(865,600):Point("TOP",0,-60):SetTo(1)

	BWInterfaceFrame.tab.tabs[7].button.tooltip = L.BossWatcherTabInterruptAndDispel
	BWInterfaceFrame.tab:SetBackdropBorderColor(0,0,0,0)
	BWInterfaceFrame.tab:SetBackdropColor(0,0,0,0)
	
	for i=1,#BWInterfaceFrame.tab.tabs do
		BWInterfaceFrame.tab.tabs[i].button.Left:SetWidth(9)
		BWInterfaceFrame.tab.tabs[i].button.Right:SetWidth(9)
	end
	
	
	---- Settings tab-button
	BWInterfaceFrame.tab.tabs[12]:SetScript("OnShow",function (self)
		if not module.options.isLoaded then
			if InCombatLockdown() then
				print(L.SetErrorInCombat)
				return
			end
			module.options:Load()
			module.options:SetScript("OnShow",nil)
			module.options.isLoaded = true
		end
		module.options:SetParent(self)
		module.options:ClearAllPoints()
		module.options:SetAllPoints(self)
		module.options:Show()
	end)
	
	---- Locals for functions in code below
	local SegmentsPage_ImprovedSelect,SegmentsPage_UpdateTextures,SegmentsPage_IsSegmentEnabled,SpellsPage_GetCastsNumber,AurasPage_IsAuraOn = nil
	
		

	---- TimeLine Frame
	BWInterfaceFrame.timeLineFrame = CreateFrame('Frame',nil,BWInterfaceFrame.tab)
	BWInterfaceFrame.timeLineFrame.width = 858
	BWInterfaceFrame.timeLineFrame:SetSize(BWInterfaceFrame.timeLineFrame.width,60)
	
	local TimeLine_Pieces = 60
	local function TimeLinePieceOnEnter(self)
		if self.tooltip and #self.tooltip > 0 then
			ELib.Tooltip.Show(self,"ANCHOR_RIGHT",L.BossWatcherTimeLineTooltipTitle..":",unpack(self.tooltip))
		end
	end
	local UpdateTimeLine, TimeLineFrame_ImprovedSelectSegment_GetSelected, TimeLineFrame_ImprovedSelectSegment_OnUpdate, TimeLineFrame_ImprovedSelectSegment_OnUpdate_Passive = nil
	do
		local TLframe = CreateFrame("Frame",nil,BWInterfaceFrame.timeLineFrame)
		BWInterfaceFrame.timeLineFrame.timeLine = TLframe
		TLframe:SetSize(BWInterfaceFrame.timeLineFrame.width,30)
		TLframe:SetPoint("TOP",0,0)
		do
			local tlWidth = BWInterfaceFrame.timeLineFrame.width/TimeLine_Pieces
			for i=1,TimeLine_Pieces do
				TLframe[i] = CreateFrame("Frame","ExRT_FightLog_TimeLine"..i,TLframe)	--FrameStack Fix
				TLframe[i]:SetSize(tlWidth,30)
				TLframe[i]:SetPoint("TOPLEFT",(i-1)*tlWidth,0)
				TLframe[i]:SetScript("OnEnter",TimeLinePieceOnEnter)
				TLframe[i]:SetScript("OnLeave",ELib.Tooltip.Hide)
			end
		end
		TLframe.texture = TLframe:CreateTexture(nil, "BACKGROUND",nil,0)
		--TLframe.texture:SetTexture("Interface\\AddOns\\ExRT\\media\\bar9.tga")
		--TLframe.texture:SetVertexColor(0.3, 1, 0.3, 1)
		TLframe.texture:SetColorTexture(1, 1, 1, 1)
		TLframe.texture:SetGradientAlpha("VERTICAL",1,0.82,0,.7,0.95,0.65,0,.7)
		TLframe.texture:SetAllPoints()
		
		TLframe.textLeft = ELib:Text(TLframe,"",12):Size(200,16):Point("BOTTOMLEFT",TLframe,"BOTTOMLEFT", 2, 2):Top():Color():Shadow()
		TLframe.textCenter = ELib:Text(TLframe,"",12):Size(200,16):Point("BOTTOM",TLframe,"BOTTOM", 0, 2):Top():Center():Color():Shadow()
		TLframe.textRight = ELib:Text(TLframe,"",12):Size(200,16):Point("BOTTOMRIGHT",TLframe,"BOTTOMRIGHT", -2, 2):Top():Right():Color():Shadow()
		
		TLframe.lifeUnderLine = TLframe:CreateTexture(nil, "BACKGROUND")
		TLframe.lifeUnderLine:SetColorTexture(1,1,1,1)
		TLframe.lifeUnderLine:SetGradientAlpha("VERTICAL", 1,0.2,0.2, 0, 1,0.2,0.2, 0.7)
		TLframe.lifeUnderLine._SetPoint = TLframe.lifeUnderLine.SetPoint
		TLframe.lifeUnderLine.SetPoint = function(self,start,_end)
			self:ClearAllPoints()
			self:_SetPoint("TOPLEFT",self:GetParent(),"BOTTOMLEFT",start*BWInterfaceFrame.timeLineFrame.width,0)
			self:SetSize((_end-start)*BWInterfaceFrame.timeLineFrame.width,16)
			self:Show()
		end
		
		TLframe.arrow = TLframe:CreateTexture(nil, "BACKGROUND")
		TLframe.arrow:SetTexture("Interface\\CURSOR\\Quest")
		TLframe.arrow:Hide()
	
		TLframe.arrowNow = TLframe:CreateTexture(nil, "BACKGROUND")
		TLframe.arrowNow:SetTexture("Interface\\CURSOR\\Inspect")	
		TLframe.arrowNow:Hide()
		
		TLframe.labels = {}
		function TLframe:AddLabel(i,pos,type)
			local label = TLframe.labels[i]
			if not label then
				label = TLframe:CreateTexture(nil, "BACKGROUND")
				TLframe.labels[i] = label
				label:SetSize(3,25)
			end
			label:SetPoint("TOP",TLframe,"BOTTOMLEFT",BWInterfaceFrame.timeLineFrame.width*pos,0)
			if not type then
				label:SetColorTexture(.35,.38,1,.7)
			elseif type == 1 then
				label:SetColorTexture(.2,1,0,1)
			elseif type == 2 then
				label:SetColorTexture(1,.25,.3,.7)
			end
			label:Show()
		end
		function TLframe:HideLabels()
			for i=1,#TLframe.labels do
				TLframe.labels[i]:Hide()
			end
		end
		
		local EncountersPhases = {
			[1785] = {
				cast = {
					[182055] = {phase = -11394},
					[182066] = {phase = -11393},
				},
			},	--"Iron Reaver"
			[1787] = {
				chat = {
					[181293] = {phase = -11119},
					[181297] = {phase = -11120},
					[181300] = {phase = -11122},
				},
			},	--"Kormrok"
			[1783] = {
				cast = {
					[181973] = {phase = -11542},
				},
				aura = {
					[181973] = {phase = 1, isFade = true,},
				},
			},	--"Gorefiend"
			[1788] = {
				cast = {
					[181873] = {phase = 2, next = {
						isCastStart = true,
						time = 40,
						phase = 1,
					}},
				},
			},	--"Shadow-Lord Iskar"
			[1794] = {
				cast = {
					[183023] = {phase = -11451},
				},
			},	--"Socrethar the Eternal"
			[1777] = {
				cast = {
					[179681] = {phase = -11107},
					[179668] = {phase = -11840, next = {
						time = 35,
						phase = -11095,
					}},
				},			
			},	--"Fel Lord Zakuun"
			[1784] = {
				cast = {
					[181718] = {phase = -11151},
					[179986] = {phase = -11158},
					[179991] = {phase = -11166},
				},
			},	--"Tyrant Velhari"
			[1800] = {
				hp = {
					{hp = 0.205,phase = -11741,},
				},
			},	--"Xhul'horac"
			[1795] = {
				hp = {
					{hp = 0.999,phase = -11207,},
					{hp = 0.655,phase = -11219,},
					{hp = 0.355,phase = -11245,},
				},
			},	--"Mannoroth"
			[1799] = {
				hp = {
					{hp = 0.705,phase = -11590,},
					{hp = 0.405,phase = -11599,},
				},
			},	--"Archimonde"
			
			--Emerald
			
			[1853] = {
				cast = {
					[203552] = {phase = -12744, isCastStart = true,},
				},
				aura = {
					[203552] = {phase = 1, isFade = true,},
				},
			},	--"Plague Dragon": <Nythendra>
			[1841] = {
				aura = {
					[198388] = {phase = -12740,},
				},
			},	--"Ursoc"
			[1873] = {
				cast = {
					[210781] = {phase = -13192, isCastStart = true,},
					[209915] = {phase = -13184,},
				},
			},	--"Il'gynoth, The Heart of Corruption"
			[1854] = {
				hp = {
					{hp = 0.705,phase = 2,},
					{hp = 0.405,phase = 3,},
				},
			},	--"Dragons of Nightmare"
			[1876] = nil,	--"Elerethe Renferal"
			[1877] = {
				cast = {
					[212726] = {phase = -13487,},
				},
			},	--"Cenarius"
			[1864] = nil,	--"Xavius"
			
			--Suramar
			
			[1849] = {
				cast = {
					[204448] = {phase = -12822, isCastStart = true,},
				},
				aura = {
					[204448] = {phase = 1,},
				},
			},	--"Skorpyron"
			[1867] = {
				cast = {
					[207630] = {phase = -13011, next = {
						time = 16,
						phase = 1,
					}}
				}
			},	--"Trilliax"
			[1865] = nil,	--"Anomaly"
			[1842] = nil,	--"Krosus"
			[1862] = nil,	--"Tichondrius"
			[1871] = nil,	--"Spellblade Aluriel"
			[1886] = nil,	--"High Botanist Tel'arn"
			[1863] = nil,	--"Star Augur Etraeus"
			[1872] = nil,	--"Grand Magistrix Elisande"
			[1866] = nil,	--"Gul'dan"			

		}
		
		TLframe.redLine = {}
		local function CreateRedLine(i)
			TLframe.redLine[i] = TLframe:CreateTexture(nil, "BACKGROUND",nil,3)
			TLframe.redLine[i]:SetColorTexture(0.7, 0.1, 0.1, 0.5)
			TLframe.redLine[i]:SetSize(2,30)
		end
		
		TLframe.blueLine = {}
		local function CreateBlueLine(i)
			TLframe.blueLine[i] = TLframe:CreateTexture(nil, "BACKGROUND",nil,4)
			TLframe.blueLine[i]:SetColorTexture(0.1, 0.1, 0.7, 0.5)
			TLframe.blueLine[i]:SetSize(3,30)
		end
		
		TLframe.phaseMarker = {}
		TLframe.phaseMarkerNum = 0
		TLframe.phaseMarkerMax = 0
		
		local function AddPhase(pos,phase)
			local currNum = TLframe.phaseMarkerNum + 1
			TLframe.phaseMarkerNum = currNum
			
			local l,l2,t = TLframe.phaseMarker[currNum],TLframe.phaseMarker[currNum+0.5],TLframe.phaseMarker[-currNum]
			if not l then
				l = TLframe:CreateTexture(nil, "BACKGROUND",nil,5)
				TLframe.phaseMarker[currNum] = l
				l:SetSize(2,30)
				l:SetColorTexture(1, 1, 1, 0.8)
				
				l2 = TLframe:CreateTexture(nil, "BACKGROUND",nil,5)
				TLframe.phaseMarker[currNum+0.5] = l2
				l2:SetSize(1,30)
				l2:SetColorTexture(0, 0, 0, 0.8)
				l2:SetPoint("TOPLEFT",l,"TOPRIGHT",0,0)
				
				t = ELib:Text(TLframe,"",10):Point("TOPLEFT",l,"TOPRIGHT",2,-1):Point("TOPRIGHT",TLframe,"TOPRIGHT",0,-1):Color(1,1,1,1)
				t:SetHeight(12)
				TLframe.phaseMarker[-currNum] = t
				
				TLframe.phaseMarkerMax = max(currNum,TLframe.phaseMarkerMax)
			end
			l:SetPoint("TOPLEFT",BWInterfaceFrame.timeLineFrame.width * pos,0)
			local phaseText = nil
			if phase < 0 then
				local name = EJ_GetSectionInfo(-phase)
				if name then
					phaseText = name
				end
			end
			t:SetText(phaseText or (L.BossWatcherPhase.." "..phase))
			l:Show()
			l2:Show()
			t:Show()
		end
		
		function UpdateTimeLine()
			local currFight = module.db.data[module.db.nowNum]
			local fight_dur = currFight.encounterEnd - currFight.encounterStart
			if fightData and fight_dur < 1.5 then
				local fight_dur = GetTime() - currFight.encounterStart
			end
			TLframe.textLeft:SetText( date("%H:%M:%S", currFight.encounterStartGlobal) )
			TLframe.textRight:SetText( date("%M:%S", fight_dur) )
			TLframe.textCenter:SetText( date("%M:%S", fight_dur / 2) )
			
			if currFight.improved then
				TLframe.ImprovedSelectSegment:Show()
				for i=1,TimeLine_Pieces do
					TLframe[i]:Hide()
				end
			else
				TLframe.ImprovedSelectSegment:Hide()
				for i=1,TimeLine_Pieces do
					TLframe[i]:Show()
				end
			end
			
			TLframe.phaseMarkerNum = 0
			for i=1,TLframe.phaseMarkerMax do
				TLframe.phaseMarker[i]:Hide()
				TLframe.phaseMarker[i+0.5]:Hide()
				TLframe.phaseMarker[-i]:Hide()
			end
			local CurrentEncountersPhases = currFight.encounterID and EncountersPhases[currFight.encounterID] or ExRT.NULL
	
			local redLineNum = 0
			for i=1,TimeLine_Pieces do
				if not TLframe[i].tooltip then
					TLframe[i].tooltip = {}
				end
				wipe(TLframe[i].tooltip)
			end
			
			if CurrentEncountersPhases.aura then
				local phasesAuras = CurrentEncountersPhases.aura
				for i,data in ipairs(module.db.nowData.auras) do
					if phasesAuras[ data[6] ] then
						local phaseData = phasesAuras[ data[6] ]
						if (phaseData.isFade and data[8] == 2) or (not phaseData.isFade and data[8] == 1) then
							local _time = timestampToFightTime(data[1])
							AddPhase(_time / fight_dur,phaseData.phase)
						end
					end
				end
			end
			
			local addToToolipTable = {}
			local bossHpPerSegment = {}
			if module.db.data[module.db.nowNum].graphData then
				local phaseHpStart = 1
				for sec,data in ipairs(module.db.data[module.db.nowNum].graphData) do
					local boss1 = data["boss1"]
					if boss1 then
						local hpMax = boss1.hpmax
						if hpMax ~= 0 and boss1.health then
							local tooltipIndex = sec / fight_dur
							tooltipIndex = min( floor( (TimeLine_Pieces - 0.01)*tooltipIndex + 1 ) , TimeLine_Pieces)
							
							local hp = boss1.health/hpMax
							if not bossHpPerSegment[tooltipIndex] then
								bossHpPerSegment[tooltipIndex] = (boss1.name or "boss1").."'s hp: "..format("%.1f%%",hp*100)
							end
							if CurrentEncountersPhases.hp then
								for i=phaseHpStart,#CurrentEncountersPhases.hp do
									local data = CurrentEncountersPhases.hp[i]
									if hp <= data.hp then
										AddPhase(sec / fight_dur,data.phase)
										phaseHpStart = i+1
										break
									end
								end
							end
						end
					end
				end
			end
			for mobGUID,mobData in pairs(module.db.nowData.cast) do
				local unitFlag = currFight.reaction[mobGUID]
				if unitFlag and ExRT.F.GetUnitInfoByUnitFlag(unitFlag,3) == 64 then
					for i=1,#mobData do
						local castData = mobData[i]
						local _time = timestampToFightTime(castData[1])
						
						local tooltipIndex = _time / fight_dur
						
						if CurrentEncountersPhases.cast then
							local phaseData = CurrentEncountersPhases.cast[ castData[2] ]
							if phaseData and ((phaseData.isCastStart and castData[3] == 2) or (not phaseData.isCastStart and castData[3] == 1)) then
								AddPhase(tooltipIndex,phaseData.phase)
							end
							if phaseData and phaseData.next and ((phaseData.next.isCastStart and castData[3] == 2) or (not phaseData.next.isCastStart and castData[3] == 1)) then
								local newTime = _time + phaseData.next.time
								if newTime < fight_dur then
									AddPhase(newTime / fight_dur,phaseData.next.phase)
								end
							end
						end
						
						redLineNum = redLineNum + 1
						if not TLframe.redLine[redLineNum] then
							CreateRedLine(redLineNum)
						end
						TLframe.redLine[redLineNum]:SetPoint("TOPLEFT",TLframe,"TOPLEFT",BWInterfaceFrame.timeLineFrame.width*tooltipIndex,0)
						TLframe.redLine[redLineNum]:Show()
						
						tooltipIndex = min( floor( (TimeLine_Pieces - 0.01)*tooltipIndex + 1 ) , TimeLine_Pieces)
						
						local spellName,_,spellTexture = GetSpellInfo(castData[2])
						
						local targetInfo = ""
						if castData[4] and castData[4] ~= "" then
							targetInfo = " "..L.BossWatcherTimeLineOnText.." |c"..ExRT.F.classColorByGUID(castData[4])..GetGUID(castData[4]).."|r"
						end
						
						addToToolipTable[#addToToolipTable + 1] = {tooltipIndex,_time,"[" .. date("%M:%S", _time )  .. "] |c"..ExRT.F.classColorByGUID(mobGUID) .. GetGUID(mobGUID) .."|r" .. GUIDtoText("(%s)",mobGUID) .. ( castData[3] == 1 and " "..L.BossWatcherTimeLineCast.." " or " "..L.BossWatcherTimeLineCastStart.." " ) .. format("%s%s%s",spellTexture and "|T"..spellTexture..":0|t " or "",spellName or "???"," ["..castData[2].."]") .. targetInfo }
					end
				end
			end
			for _,chatData in ipairs(module.db.nowData.chat) do
				local _time = min( max(chatData[4] - currFight.encounterStart,0) , currFight.encounterEnd)
				
				local tooltipIndex = _time / fight_dur
				
				if CurrentEncountersPhases.chat then
					local phaseData = CurrentEncountersPhases.chat[ chatData[3] ]
					if phaseData then
						AddPhase(tooltipIndex,phaseData.phase)
					end
				end				
				
				redLineNum = redLineNum + 1
				if not TLframe.redLine[redLineNum] then
					CreateRedLine(redLineNum)
				end
				TLframe.redLine[redLineNum]:SetPoint("TOPLEFT",TLframe,"TOPLEFT",BWInterfaceFrame.timeLineFrame.width*tooltipIndex,0)
				TLframe.redLine[redLineNum]:Show()
				
				tooltipIndex = min( floor( (TimeLine_Pieces - 0.01)*tooltipIndex + 1 ) , TimeLine_Pieces)
				
				local spellName,_,spellTexture = GetSpellInfo(chatData[3])
							
				addToToolipTable[#addToToolipTable + 1] = {tooltipIndex,_time,"[" .. date("%M:%S", _time )  .. "] "..  L.BossWatcherChatSpellMsg .. " " .. format("%s%s%s",spellTexture and "|T"..spellTexture..":0|t " or "",spellName or "???"," ["..chatData[3].."]") }
			end
			for _,resData in ipairs(module.db.nowData.resurrests) do
				local _time = timestampToFightTime(resData[4])
				
				local tooltipIndex = _time / fight_dur
				redLineNum = redLineNum + 1
				if not TLframe.redLine[redLineNum] then
					CreateRedLine(redLineNum)
				end
				TLframe.redLine[redLineNum]:SetPoint("TOPLEFT",TLframe,"TOPLEFT",BWInterfaceFrame.timeLineFrame.width*tooltipIndex,0)
				TLframe.redLine[redLineNum]:Show()
				
				tooltipIndex = min( floor( (TimeLine_Pieces - 0.01)*tooltipIndex + 1 ) , TimeLine_Pieces)
				local spellName,_,spellTexture = GetSpellInfo(resData[3])
				
				addToToolipTable[#addToToolipTable + 1] = {tooltipIndex,_time,"[" .. date("%M:%S", _time )  .. "] |c"..ExRT.F.classColorByGUID(resData[1]) .. GetGUID(resData[1]) .."|r" ..  GUIDtoText("(%s)",resData[1]) .. " ".. L.BossWatcherTimeLineCast.. " " .. format("%s%s%s",spellTexture and "|T"..spellTexture..":0|t " or "",spellName or "???"," ["..resData[3].."]") .. " "..L.BossWatcherTimeLineOnText.." |c"..ExRT.F.classColorByGUID(resData[2])..GetGUID(resData[2]).."|r" }
			end
			for i=(redLineNum+1),#TLframe.redLine do
				TLframe.redLine[i]:Hide()
			end
			
			local blueLineNum = 0
			for i=1,#module.db.nowData.dies do
				if ExRT.F.GetUnitInfoByUnitFlag(module.db.nowData.dies[i][2],1) == 1024 then
					local _time = timestampToFightTime(module.db.nowData.dies[i][3])
					
					local tooltipIndex = _time / fight_dur
					
					blueLineNum = blueLineNum + 1
					if not TLframe.blueLine[blueLineNum] then
						CreateBlueLine(blueLineNum)
					end
					TLframe.blueLine[blueLineNum]:SetPoint("TOPLEFT",TLframe,"TOPLEFT",BWInterfaceFrame.timeLineFrame.width*tooltipIndex,0)
					TLframe.blueLine[blueLineNum]:Show()
					
					tooltipIndex = min ( floor( (TimeLine_Pieces - 0.01)*tooltipIndex + 1 ) , TimeLine_Pieces)
					
					addToToolipTable[#addToToolipTable + 1] = {tooltipIndex,_time,"[" .. date("%M:%S", _time )  .. "] |cffee5555" .. GetGUID(module.db.nowData.dies[i][1]) .. GUIDtoText("(%s)",module.db.nowData.dies[i][1])  .. " "..L.BossWatcherTimeLineDies.."|r"}
				end
			end
			for i=(blueLineNum+1),#TLframe.blueLine do
				TLframe.blueLine[i]:Hide()
			end
			
			for i=1,TimeLine_Pieces do
				if bossHpPerSegment[i] then
					table.insert(TLframe[i].tooltip,{bossHpPerSegment[i],1,1,1})
				end
			end
			table.sort(addToToolipTable,function (a,b) return a[2] < b[2] end)
			for i=1,#addToToolipTable do
				table.insert(TLframe[ addToToolipTable[i][1] ].tooltip,{addToToolipTable[i][3],1,1,1})
			end
			
			SegmentsPage_UpdateTextures()
		end
		
		TLframe.ImprovedSelectSegment = CreateFrame("Button",nil,TLframe)
		TLframe.ImprovedSelectSegment:SetAllPoints()
		TLframe.ImprovedSelectSegment:Hide()
		
		TLframe.ImprovedSelectSegment.ResetZoom = CreateFrame("Button",nil,TLframe.ImprovedSelectSegment)
		TLframe.ImprovedSelectSegment.ResetZoom:SetSize(200,13)
		TLframe.ImprovedSelectSegment.ResetZoom:SetPoint("TOPRIGHT",TLframe.ImprovedSelectSegment,"BOTTOMRIGHT",-1,4)
		TLframe.ImprovedSelectSegment.ResetZoom.Text = ELib:Text(TLframe.ImprovedSelectSegment.ResetZoom,"["..L.BossWatcherGraphZoomReset.."]",11):Size(200,13):Point("RIGHT",0,0):Right():Top():Color():Outline()
		TLframe.ImprovedSelectSegment.ResetZoom:SetWidth( TLframe.ImprovedSelectSegment.ResetZoom.Text:GetStringWidth() )
		TLframe.ImprovedSelectSegment.ResetZoom:SetScript("OnClick",function (self)
			SegmentsPage_ImprovedSelect()
			self:Hide()
		end)
		TLframe.ImprovedSelectSegment.ResetZoom:Hide()
		
		TLframe.ImprovedSelectSegment.hoverTime = ELib:Text(TLframe.ImprovedSelectSegment,"",11):Size(200,16):Center():Top():Color():Outline()
		
		TLframe.ImprovedSelectSegment.Texture = TLframe:CreateTexture(nil, "BACKGROUND",nil,2)
		--TLframe.ImprovedSelectSegment.Texture:SetTexture("Interface\\AddOns\\ExRT\\media\\bar9.tga")
		--TLframe.ImprovedSelectSegment.Texture:SetVertexColor(0, 0.65, 0.9, .7)
		TLframe.ImprovedSelectSegment.Texture:SetColorTexture(1, 1, 1, 1)
		TLframe.ImprovedSelectSegment.Texture:SetGradientAlpha("VERTICAL",0.3,0.75,0.90,.7,0,0.62,0.90,.7)
		TLframe.ImprovedSelectSegment.Texture:SetHeight(30)
		TLframe.ImprovedSelectSegment.Texture:Hide()
		
		function TimeLineFrame_ImprovedSelectSegment_GetSelected(self)
			local fightDuration = (module.db.data[module.db.nowNum].encounterEnd - module.db.data[module.db.nowNum].encounterStart)
			local timeLineWidth = self:GetWidth()
			local start = self.mouseDowned / timeLineWidth
			local ending = ExRT.F.GetCursorPos(self) / timeLineWidth
			if ending > start then
				ending = min(ending,1)
				start = max(start,0)
			else
				start = min(start,1)
				ending = max(ending,0)
			end
			
			start = ExRT.F.Round(start * fightDuration)
			ending = ExRT.F.Round(ending * fightDuration)
			
			return start,ending
		end
		function TimeLineFrame_ImprovedSelectSegment_OnUpdate(self)
			local x = ExRT.F.GetCursorPos(self)
			local width = x - self.mouseDowned
			if width > 0 then
				width = min(width,self:GetWidth()-self.mouseDowned)
				self.Texture:SetWidth(width)
				self.Texture:SetPoint("TOPLEFT",TLframe,"TOPLEFT", self.mouseDowned ,0)
				
				local start,ending = TimeLineFrame_ImprovedSelectSegment_GetSelected(self)
				
				ELib.Tooltip.Show(self,"ANCHOR_CURSOR",format("%d:%02d - %d:%02d",start / 60,start % 60,ending / 60,ending % 60))
			elseif width < 0 then
				width = -width
				width = min(width,self.mouseDowned)
				self.Texture:SetWidth(width)
				self.Texture:SetPoint("TOPLEFT",TLframe,"TOPLEFT", self.mouseDowned-width,0)
				
				local start,ending = TimeLineFrame_ImprovedSelectSegment_GetSelected(self)
				ELib.Tooltip.Show(self,"ANCHOR_CURSOR",format("%d:%02d - %d:%02d",ending / 60,ending % 60,start / 60,start % 60))
			else
				self.Texture:SetWidth(1)
				ELib.Tooltip:Hide()
			end
		end
		TLframe.ImprovedSelectSegment:SetScript("OnMouseDown",function (self)
			self.mouseDowned = ExRT.F.GetCursorPos(self)
			self.Texture:SetPoint("TOPLEFT",TLframe,"TOPLEFT", self.mouseDowned ,0)
			self.Texture:SetWidth(1)
			self.Texture:Show()
			self:SetScript("OnUpdate",TimeLineFrame_ImprovedSelectSegment_OnUpdate)
			self.hoverTime:Hide()
		end)
		TLframe.ImprovedSelectSegment:SetScript("OnMouseUp",function (self)
			self:SetScript("OnUpdate",nil)
			self.Texture:Hide()
			ELib.Tooltip:Hide()
			if not self.mouseDowned then
				return
			end
			local start,ending = TimeLineFrame_ImprovedSelectSegment_GetSelected(self)
			self.mouseDowned = nil
			if ending < start then
				start,ending = ending,start
			end
			start = start + 1
			ending = ending + 1
			SegmentsPage_ImprovedSelect(start,ending,nil,IsShiftKeyDown())
		end)
		
		function TimeLineFrame_ImprovedSelectSegment_OnUpdate_Passive(self)
			local timeLineWidth = self:GetWidth()
			local fightDuration = (module.db.data[module.db.nowNum].encounterEnd - module.db.data[module.db.nowNum].encounterStart)
			local x = ExRT.F.GetCursorPos(self)
			local time = ExRT.F.Round(x / timeLineWidth * fightDuration)
			self.hoverTime:SetFormattedText("%d:%02d",time / 60,time % 60)
			self.hoverTime:SetPoint("TOP",self,"TOPLEFT",x,-2)
			self.hoverTime:Show()
			local segmentNow = ceil(x / timeLineWidth * 60  + 0.01)
			if segmentNow ~= self.lastSegment then
				self.lastSegment = segmentNow
				ELib.Tooltip:Hide()
			else
				return
			end
			local frame = TLframe[segmentNow]
			if frame then
				TimeLinePieceOnEnter(frame)
			end
		end
		TLframe.ImprovedSelectSegment:SetScript("OnEnter",function (self)
			if self.mouseDowned then 
				return
			end
			self.lastSegment = nil
			self:SetScript("OnUpdate",TimeLineFrame_ImprovedSelectSegment_OnUpdate_Passive)
		end)
		TLframe.ImprovedSelectSegment:SetScript("OnLeave",function (self)
			self.hoverTime:Hide()
			if self.mouseDowned then
				return
			end
			ELib.Tooltip:Hide()
			self:SetScript("OnUpdate",nil)
		end)
	end
			
	BWInterfaceFrame.timeLineFrame:SetScript("OnShow",function (self)
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			UpdateTimeLine()
			self.lastFightID = BWInterfaceFrame.nowFightID
		end
	end)
	
	---- Graph Frame
	BWInterfaceFrame.GraphFrame = CreateFrame('Frame',nil,BWInterfaceFrame.tab)
	BWInterfaceFrame.GraphFrame:SetSize(860,200)
	BWInterfaceFrame.GraphFrame:SetPoint("TOP",0,-80)
	BWInterfaceFrame.GraphFrame:Hide()
	BWInterfaceFrame.GraphFrame.G = ExRT.lib.CreateGraph(BWInterfaceFrame.GraphFrame,790,180,"TOPLEFT",50,-5,true)
	BWInterfaceFrame.GraphFrame.G.fixMissclickZoom = true
	BWInterfaceFrame.GraphFrame.G.backgroundHighlight = {}
	BWInterfaceFrame.GraphFrame.G.ResetZoom:Point("TOPRIGHT",-100,10)

	BWInterfaceFrame.GraphFrame.G.highlightHideButton = ELib:Button(BWInterfaceFrame.GraphFrame.G,"",1)
	BWInterfaceFrame.GraphFrame.G.highlightHideButton:SetSize(16,16)
	BWInterfaceFrame.GraphFrame.G.highlightHideButton.background = BWInterfaceFrame.GraphFrame.G.highlightHideButton:CreateTexture(nil, "BACKGROUND")
	BWInterfaceFrame.GraphFrame.G.highlightHideButton.background:SetAllPoints()
	BWInterfaceFrame.GraphFrame.G.highlightHideButton.background:SetTexture("Interface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128")
	BWInterfaceFrame.GraphFrame.G.highlightHideButton.background:SetTexCoord(0.5,0.5625,0.5,0.625)
	BWInterfaceFrame.GraphFrame.G.highlightHideButton:SetScript("OnEnter",function(self)
		self.background:SetVertexColor(.7,0,0,1)
	end)
	BWInterfaceFrame.GraphFrame.G.highlightHideButton:SetScript("OnLeave",function(self)
		self.background:SetVertexColor(1,1,1,.7)
	end)
	BWInterfaceFrame.GraphFrame.G.highlightHideButton:SetScript("OnClick",function(self)
		local parent = self:GetParent()
		parent.highlight = nil
		parent:OnAfterReload()
	end)
	BWInterfaceFrame.GraphFrame.G.highlightHideButton:Hide()
	
	function BWInterfaceFrame.GraphFrame.G:OnBeforeReload()
		if not self.data[1] then
			return
		end
		local tooltipX = {}
		for i=1,#self.data[1] do
			tooltipX[i] = format("%d:%02d",i / 60,i % 60)
		end
		self.data.tooltipX = tooltipX
	end
	function BWInterfaceFrame.GraphFrame.G:OnAfterReload()
		if not self.highlight or not self.range or not self.range.maxX then
			for i=1,#self.backgroundHighlight do
				self.backgroundHighlight[i]:Hide()
			end
			self.highlightHideButton:Hide()
			return
		end
		local count = 0
		for i=1,#self.highlight,2 do
			local posStart,posEnd = self.highlight[i],self.highlight[i+1]
			if not (posStart > self.range.maxX or posEnd < self.range.minX) then
				if posStart < self.range.minX then
					posStart = self.range.minX
				end
				if posEnd > self.range.maxX then
					posEnd = self.range.maxX
				end
				count = count + 1
				local background = self.backgroundHighlight[count]
				if not background then
					background = self:CreateTexture(nil, "BACKGROUND",nil,2)
					self.backgroundHighlight[count] = background
					background:SetPoint("TOP",0,0)
					background:SetPoint("BOTTOM",0,0)
					background:SetColorTexture(0.7, 0.65, 0.9, .3)
					if count == 1 then
						self.highlightHideButton:SetPoint("TOPRIGHT",background,2,-2)
					end
				end
				local posX = (posStart - self.range.minX) / (self.range.maxX - self.range.minX) * self:GetWidth()
				local width = (posEnd - posStart) / (self.range.maxX - self.range.minX) * self:GetWidth()
				background:SetPoint("LEFT",posX,0)
				background:SetWidth(width)
				background:Show()
				if count == 1 then
					self.highlightHideButton:Show()
				end
			end
		end
		for i=count+1,#self.backgroundHighlight do
			self.backgroundHighlight[i]:Hide()
		end
		if count == 0 then
			self.highlightHideButton:Hide()
		end
	end
	function BWInterfaceFrame.GraphFrame.G:Zoom(start,ending)
		if ending == start then
			self.ZoomMinX = nil
			self.ZoomMaxX = nil
		else
			self.ZoomMinX = start
			self.ZoomMaxX = ending
		end
		if module.db.data[module.db.nowNum].improved then
			if self.ZoomSecondUpdate_1 then
				self:ZoomSecondUpdate_1()
				BWInterfaceFrame.tab.tabs[ BWInterfaceFrame.tab.selected ].lastFightID = module.db.lastFightID + 1
			end
			SegmentsPage_ImprovedSelect(start,ending)
			if self.ZoomSecondUpdate_2 then
				self:ZoomSecondUpdate_2()
			end
		end
		self:Reload()
	end
	function BWInterfaceFrame.GraphFrame.G:OnResetZoom()
		if self.ZoomSecondUpdate_1 then
			self:ZoomSecondUpdate_1()
			BWInterfaceFrame.tab.tabs[ BWInterfaceFrame.tab.selected ].lastFightID = module.db.lastFightID + 1
		end
		SegmentsPage_ImprovedSelect()
		if self.ZoomSecondUpdate_2 then
			self:ZoomSecondUpdate_2()
		end
	end
	BWInterfaceFrame.GraphFrame.stepSlider = ELib:Slider(BWInterfaceFrame.GraphFrame,"",true):Point("BOTTOMRIGHT",BWInterfaceFrame.GraphFrame.G,"BOTTOMLEFT",-10,20):Size(100):Range(1,10):SetTo(1):OnChange(function(self)
		local graph = self:GetParent().G
		self:Tooltip(L.BossWatcherGraphicsStep.."\n"..floor(self:GetValue() + 0.5))
		self:tooltipReload()
		self:GetParent().G.step = floor(self:GetValue() + 0.5)
		self:GetParent().G:Reload()
	end):Tooltip(L.BossWatcherGraphicsStep.."\n1")
	
		
	
	local tab,tabName = nil
	---- Damage Tab
	tab = BWInterfaceFrame.tab.tabs[1]
	tabName = BWInterfaceFrame_Name.."DamageTab"
	
	local sourceVar,destVar = {},{}
	local DamageTab_SetLine = nil
	
	local DamageTab_Variables = {
		Last_Func = nil,
		Last_doEnemy = nil,
		ShowAll = false,
		Back_Func = nil,
		Back_destVar = nil,
		Back_sourceVar = nil,
	}
	
	local function DamageTab_GetGUIDsReport(list,isDest)
		local result = ""
		for GUID,_ in pairs(list) do
			if result ~= "" then
				result = result..", "
			end
			local time = ""
			if isDest and ExRT.F.GetUnitTypeByGUID(GUID) ~= 0 and module.db.nowData.damage_seen[GUID] then
				time = date(" (%M:%S)", timestampToFightTime( module.db.nowData.damage_seen[GUID] ))
			end
			result = result .. GetGUID(GUID) .. time
		end
		if result ~= "" then
			return result
		end
	end
	local function DamageTab_UpdateDropDown(arr,dropDown)
		local count = ExRT.F.table_len(arr)
		if count == 0 then
			dropDown:SetText(L.BossWatcherAll)
		elseif count == 1 then
			local GUID = nil
			for g,_ in pairs(arr) do
				GUID = g
			end
			local name = GetGUID(GUID)
			local flags = module.db.data[module.db.nowNum].reaction[GUID]
			local isPlayer = GetUnitInfoByUnitFlagFix(flags,1) == 1024
			local isNPC = GetUnitInfoByUnitFlagFix(flags,2) == 512
			if isPlayer then
				name = "|c"..ExRT.F.classColorByGUID(GUID)..name
			elseif isNPC then
				name = name .. date(" %M:%S", timestampToFightTime( module.db.nowData.damage_seen[GUID] )) .. GUIDtoText(" [%s]",GUID)
			end
			dropDown:SetText(name)
		else
			dropDown:SetText(L.BossWatcherSeveral)
		end
	end
	
	local function DamageTab_UpdateDropDownSource()
		DamageTab_UpdateDropDown(sourceVar,BWInterfaceFrame.tab.tabs[1].sourceDropDown)
	end
	local function DamageTab_UpdateDropDownDest()
		DamageTab_UpdateDropDown(destVar,BWInterfaceFrame.tab.tabs[1].targetDropDown)
	end

	local DamageTab_UpdateDropDownType = nil
	do
		local dropDownNames = {
			{L.BossWatcherDamageDamageDone,L.BossWatcherDamageDamageTakenByEnemy,L.BossWatcherDamageDamageDoneBySpell,L.BossWatcherDamageDamageSpellToHostile},
			{L.BossWatcherDamageDamageTaken,L.BossWatcherDamageDamageTakenByPlayers,L.BossWatcherDamageDamageTakenBySpell,L.BossWatcherDamageDamageSpellToFriendly},
		}
		function DamageTab_UpdateDropDownType(type,doEnemy)
			local isEnemy = doEnemy and 1 or 2
			BWInterfaceFrame.tab.tabs[1].typeDropDown:SetText(dropDownNames[isEnemy][type])
		end
	end
	local function DamageTab_Temp_SortingBy2Param(a,b)
		return a[2] > b[2]
	end
	
	local function DamageTab_ReloadGraph(data,fightLength,linesData,isSpell)
		local graphData = {}
		for key,spellData in pairs(data) do
			local newData
			if isSpell then
				local spellID = key
				local isPet = 1
				if spellID < -1 then
					isPet = -1
					spellID = -spellID
				end
				local spellName,_,spellIcon = GetSpellInfo(spellID)
				if spellID == -1 then
					spellName = L.BossWatcherReportTotal
				elseif spellName then
					spellName = "|T"..spellIcon..":0|t "..spellName
				else
					spellName = spellID
				end
				newData = {
					info_spellID = spellID*isPet,
					name = spellName,
					total_damage = 0,
					hide = true,
				}
			else
				local sourceGUID = key
				local name,r,g,b = nil
				if sourceGUID == -1 then
					name = L.BossWatcherReportTotal
				else
					local class
					name = GetGUID(sourceGUID)
					if sourceGUID ~= "" then
						class = select(2,GetPlayerInfoByGUID(sourceGUID))
					end
					name = "|c".. ExRT.F.classColor(class) .. name .. "|r"
					if class then
						local classColorArray = type(CUSTOM_CLASS_COLORS)=="table" and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
						r,g,b = classColorArray.r,classColorArray.g,classColorArray.b
					end
				end
				newData = {
					info_spellID = sourceGUID,
					name = name,
					total_damage = 0,
					hide = true,
					r = r,
					g = g,
					b = b,
				}
			end
			graphData[#graphData+1] = newData
			local total_damage = 0
			for i=1,fightLength do
				newData[i] = {i,spellData[i] or 0}
				total_damage = total_damage + (spellData[i] or 0)
			end
			newData.total_damage = total_damage
		end
		sort(graphData,function(a,b) return a.total_damage>b.total_damage end)
		local findPos = ExRT.F.table_find(graphData,-1,'info_spellID')
		if findPos then
			graphData[ findPos ].hide = nil
			graphData[ findPos ].specialLine = true
		end
		for i=1,3 do
			if linesData[i] then
				findPos = ExRT.F.table_find(graphData,linesData[i][1],'info_spellID')
				if findPos then
					graphData[ findPos ].hide = nil
				end
			end
		end
		BWInterfaceFrame.GraphFrame.G.data = graphData
		BWInterfaceFrame.GraphFrame.G:Reload()
	end
			
	local function DamageTab_UpdateLinesPlayers(doEnemy)
		DamageTab_UpdateDropDownSource()
		DamageTab_UpdateDropDownDest()
		DamageTab_UpdateDropDownType(1,doEnemy)
		DamageTab_Variables.Last_Func = DamageTab_UpdateLinesPlayers
		DamageTab_Variables.Last_doEnemy = doEnemy
		DamageTab_Variables.Back_Func = DamageTab_UpdateLinesPlayers
		DamageTab_Variables.Back_sourceVar = nil
		DamageTab_Variables.Back_destVar = nil
		local damage = {}
		local total = 0
		local totalOver = 0
		for destGUID,destData in pairs(module.db.nowData.damage) do
			if ExRT.F.table_len(destVar) == 0 or destVar[destGUID] then
				local isEnemy = false
				if GetUnitInfoByUnitFlagFix(module.db.data[module.db.nowNum].reaction[destGUID],2) == 512 then
					isEnemy = true
				end
				local mobID = ExRT.F.GUIDtoID(destGUID)
				for sourceGUID,sourceData in pairs(destData) do
					local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
					if owner then
						sourceGUID = owner
					end
					if ExRT.F.table_len(sourceVar) == 0 or sourceVar[sourceGUID] then
						if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
							local inDamagePos = ExRT.F.table_find(damage,sourceGUID,1)
							if not inDamagePos then
								inDamagePos = #damage + 1
								damage[inDamagePos] = {sourceGUID,0,0,0,0,0,0,{}}
							end
							local destPos = ExRT.F.table_find(damage[inDamagePos][8],destGUID,1)
							if not destPos then
								destPos = #damage[inDamagePos][8] + 1
								damage[inDamagePos][8][destPos] = {destGUID,0}
							end
							destPos = damage[inDamagePos][8][destPos]
							for spellID,spellAmount in pairs(sourceData) do
								damage[inDamagePos][2] = damage[inDamagePos][2] + spellAmount.amount - spellAmount.overkill
								damage[inDamagePos][3] = damage[inDamagePos][3] + spellAmount.overkill	--overkill
								damage[inDamagePos][4] = damage[inDamagePos][4] + spellAmount.blocked	--blocked
								damage[inDamagePos][5] = damage[inDamagePos][5] + spellAmount.absorbed	--absorbed
								damage[inDamagePos][6] = damage[inDamagePos][6] + spellAmount.crit	--crit
								damage[inDamagePos][7] = damage[inDamagePos][7] + spellAmount.ms	--ms
								total = total + spellAmount.amount - spellAmount.overkill
								totalOver = totalOver + spellAmount.overkill + spellAmount.blocked + spellAmount.absorbed
								
								destPos[2] = destPos[2] + spellAmount.amount + (DamageTab_Variables.ShowAll and (spellAmount.blocked+spellAmount.absorbed) or -spellAmount.overkill)
								
								if mobID == 76933 then	--Mage T100 fix
									local multiplier = VExRT.BossWatcher.divisionPrismatic and 0 or 1
									damage[inDamagePos][2] = damage[inDamagePos][2] - spellAmount.amount
									damage[inDamagePos][3] = damage[inDamagePos][3] + (spellAmount.amount * multiplier)
									total = total - spellAmount.amount
									totalOver = totalOver + (spellAmount.amount * multiplier)
								end
							end
						end
					end
				end
			end
		end
		local totalIsFull = 1
		total = max(total,1)
		if total == 1 and #damage == 0 then
			total = 0
			totalIsFull = 0
		end
		
		local _max = nil
		reportOptions[1] = L.BossWatcherReportDPS
		wipe(reportData[1])
		reportData[1][1] = (DamageTab_GetGUIDsReport(sourceVar) or L.BossWatcherAllSources).." > "..(DamageTab_GetGUIDsReport(destVar,true) or L.BossWatcherAllTargets)
		local activeFightLength = GetFightLength()
		
		if DamageTab_Variables.ShowAll then
			total = total + totalOver
			sort(damage,function(a,b) return (a[2]+a[3]+a[4]+a[5])>(b[2]+b[3]+b[4]+b[5]) end)
			_max = damage[1] and (damage[1][2]+damage[1][3]+damage[1][4]+damage[1][5]) or 0
		else
			sort(damage,function(a,b) return a[2]>b[2] end)
			_max = damage[1] and damage[1][2] or 0
		end
		reportData[1][2] = L.BossWatcherReportTotal.." - "..ExRT.F.shortNumber(total).."@1@ ("..floor(total / activeFightLength)..")@1#"
		DamageTab_SetLine({
			line = 1,
			name = L.BossWatcherReportTotal,
			num = total,
			total = total,
			max = total,
			alpha = DamageTab_Variables.ShowAll and totalOver,
			dps = total / activeFightLength,
			spellID = -1,
			check = BWInterfaceFrame.GraphFrame:IsShown(),
			checkState = true,
		})
		for i=1,#damage do
			local class = nil
			if damage[i][1] and damage[i][1] ~= "" then
				class = select(2,GetPlayerInfoByGUID(damage[i][1]))
			end
			local icon = ""
			if class and CLASS_ICON_TCOORDS[class] then
				icon = {"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",unpack(CLASS_ICON_TCOORDS[class])}
			end
			local tooltipData = {GetGUID(damage[i][1]),
				{L.BossWatcherDamageTooltipOverkill,ExRT.F.shortNumber(damage[i][3])},
				{L.BossWatcherDamageTooltipBlocked,ExRT.F.shortNumber(damage[i][4])},
				{L.BossWatcherDamageTooltipAbsorbed,ExRT.F.shortNumber(damage[i][5])},
				{L.BossWatcherDamageTooltipTotal,ExRT.F.shortNumber(damage[i][2]+damage[i][3]+damage[i][4]+damage[i][5])},
				{" "," "},
				{L.BossWatcherDamageTooltipFromCrit,format("%s (%.1f%%)",ExRT.F.shortNumber(damage[i][6]),max(damage[i][6]/max(1,damage[i][2]+damage[i][3])*100))},
				{L.BossWatcherDamageTooltipFromMs,format("%s (%.1f%%)",ExRT.F.shortNumber(damage[i][7]),max(damage[i][7]/max(1,damage[i][2]+damage[i][3])*100))},
			}
			sort(damage[i][8],DamageTab_Temp_SortingBy2Param)
			if #damage[i][8] > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherDamageTooltipTargets," "}
			end
			for j=1,min(5,#damage[i][8]) do
				tooltipData[#tooltipData + 1] = {SubUTF8String(GetGUID(damage[i][8][j][1]),20)..GUIDtoText(" [%s]",damage[i][8][j][1]),format("%s (%.1f%%)",ExRT.F.shortNumber(damage[i][8][j][2]),min(damage[i][8][j][2] / max(1,damage[i][2]+(DamageTab_Variables.ShowAll and (damage[i][3]+damage[i][4]+damage[i][5]) or 0))*100,100))}
			end
			
			local currDamage = damage[i][2] + (DamageTab_Variables.ShowAll and (damage[i][3]+damage[i][4]+damage[i][5]) or 0)
			local dps = currDamage/activeFightLength
			DamageTab_SetLine({
				line = i+1,
				icon = icon,
				name = GetGUID(damage[i][1])..GUIDtoText(" [%s]",damage[i][1]),
				num = currDamage,
				alpha = DamageTab_Variables.ShowAll and (damage[i][3]+damage[i][4]+damage[i][5]),
				total = total,
				max = _max,
				dps = dps,
				class = class,
				sourceGUID = damage[i][1],
				doEnemy = doEnemy,
				tooltip = tooltipData,
				check = BWInterfaceFrame.GraphFrame:IsShown(),
				checkState = i <= 3,
			})
			reportData[1][#reportData[1]+1] = i..". "..GetGUID(damage[i][1]).." - "..ExRT.F.shortNumber(currDamage).."@1@ ("..floor(dps)..")@1#"			
		end
		for i=#damage+2,#BWInterfaceFrame.tab.tabs[1].lines do
			BWInterfaceFrame.tab.tabs[1].lines[i]:Hide()
		end
		BWInterfaceFrame.tab.tabs[1].scroll:Height((#damage+1) * 20)
		
		if not BWInterfaceFrame.GraphFrame:IsShown() then
			return
		end
		local graph = {[-1]={}}
		local currFight = module.db.data[module.db.nowNum]
		local maxFight = #module.db.data[module.db.nowNum].fight
		for seg=1,maxFight do
			for destGUID,destData in pairs(currFight.fight[seg].damage) do
				if ExRT.F.table_len(destVar) == 0 or destVar[destGUID] then
					local isEnemy = false
					if GetUnitInfoByUnitFlagFix(currFight.reaction[destGUID],2) == 512 then
						isEnemy = true
					end
					local mobID = ExRT.F.GUIDtoID(destGUID)
					for sourceGUID,sourceData in pairs(destData) do
						local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
						if owner then
							sourceGUID = owner
						end
						if ExRT.F.table_len(sourceVar) == 0 or sourceVar[sourceGUID] then
							if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
								if not graph[ sourceGUID ] then
									graph[ sourceGUID ] = {}
								end
								if not graph[ sourceGUID ][seg] then
									graph[ sourceGUID ][seg] = 0
								end
								if not graph[ -1 ][seg] then
									graph[ -1 ][seg] = 0
								end
								for spellID,spellAmount in pairs(sourceData) do
									local damgeCount = spellAmount.amount + (DamageTab_Variables.ShowAll and (spellAmount.blocked+spellAmount.absorbed) or -spellAmount.overkill)
									if mobID == 76933 then	--Mage T100 fix
										damgeCount = 0
									end
									graph[ sourceGUID ][seg] = graph[ sourceGUID ][seg] + damgeCount
									graph[ -1 ][seg] = graph[ -1 ][seg] + damgeCount
								end
							end
						end
					end
				end
			end
		end
		DamageTab_ReloadGraph(graph,maxFight,damage,false)
	end
	local function DamageTab_UpdateLinesSpells(doEnemy)
		DamageTab_UpdateDropDownSource()
		DamageTab_UpdateDropDownDest()
		DamageTab_UpdateDropDownType(3,doEnemy)
		DamageTab_Variables.Last_Func = DamageTab_UpdateLinesSpells
		DamageTab_Variables.Last_doEnemy = doEnemy
		DamageTab_Variables.Back_Func = DamageTab_UpdateLinesSpells
		DamageTab_Variables.Back_sourceVar = nil
		DamageTab_Variables.Back_destVar = nil
		local damage = {}
		local total = 0
		local totalOver = 0
		for destGUID,destData in pairs(module.db.nowData.damage) do
			if ExRT.F.table_len(destVar) == 0 or destVar[destGUID] then
				local isEnemy = false
				if GetUnitInfoByUnitFlagFix(module.db.data[module.db.nowNum].reaction[destGUID],2) == 512 then
					isEnemy = true
				end
				local mobID = ExRT.F.GUIDtoID(destGUID)
				for sourceGUID,sourceData in pairs(destData) do
					local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
					if owner then
						sourceGUID = owner
					end
					if ExRT.F.table_len(sourceVar) == 0 or sourceVar[sourceGUID] then
						if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
							for spellID,spellAmount in pairs(sourceData) do
								if owner then
									spellID = -spellID
								end
								local inDamagePos = ExRT.F.table_find(damage,spellID,1)
								if not inDamagePos then
									inDamagePos = #damage + 1
									damage[inDamagePos] = {spellID,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,{}}
								end
								
								local destPos = ExRT.F.table_find(damage[inDamagePos][17],destGUID,1)
								if not destPos then
									destPos = #damage[inDamagePos][17] + 1
									damage[inDamagePos][17][destPos] = {destGUID,0}
								end
								destPos = damage[inDamagePos][17][destPos]
								
								damage[inDamagePos][2] = damage[inDamagePos][2] + spellAmount.amount - spellAmount.overkill	--amount
								damage[inDamagePos][3] = damage[inDamagePos][3] + spellAmount.count	--count
								damage[inDamagePos][4] = damage[inDamagePos][4] + spellAmount.overkill	--overkill
								damage[inDamagePos][5] = damage[inDamagePos][5] + spellAmount.blocked	--blocked
								damage[inDamagePos][6] = damage[inDamagePos][6] + spellAmount.absorbed	--absorbed
								damage[inDamagePos][7] = damage[inDamagePos][7] + spellAmount.crit	--crit
								damage[inDamagePos][8] = damage[inDamagePos][8] + spellAmount.critcount	--crit count
								damage[inDamagePos][9] = max(damage[inDamagePos][9],spellAmount.critmax)--crit max
								damage[inDamagePos][10] = damage[inDamagePos][10] + spellAmount.ms	--ms
								damage[inDamagePos][11] = damage[inDamagePos][11] + spellAmount.mscount	--ms count
								damage[inDamagePos][12] = max(damage[inDamagePos][12],spellAmount.msmax)--ms max
								damage[inDamagePos][13] = max(damage[inDamagePos][13],spellAmount.hitmax)--hit max
								damage[inDamagePos][14] = damage[inDamagePos][14] + spellAmount.parry	--parry
								damage[inDamagePos][15] = damage[inDamagePos][15] + spellAmount.dodge	--dodge
								damage[inDamagePos][16] = damage[inDamagePos][16] + spellAmount.miss	--other miss
								total = total + spellAmount.amount - spellAmount.overkill
								totalOver = totalOver + spellAmount.overkill + spellAmount.blocked + spellAmount.absorbed
								
								destPos[2] = destPos[2] + spellAmount.amount + (DamageTab_Variables.ShowAll and (spellAmount.blocked+spellAmount.absorbed) or -spellAmount.overkill)
								
								if mobID == 76933 then	--Mage T100 fix
									local multiplier = VExRT.BossWatcher.divisionPrismatic and 0 or 1
									damage[inDamagePos][2] = damage[inDamagePos][2] - spellAmount.amount
									damage[inDamagePos][4] = damage[inDamagePos][4] + (spellAmount.amount * multiplier)
									total = total - spellAmount.amount
									totalOver = totalOver + (spellAmount.amount * multiplier)
								end
							end
						end
					end
				end
			end
		end
		local totalIsFull = 1
		total = max(total,1)
		if total == 1 and #damage == 0 then
			total = 0
			totalIsFull = 0
		end
		local _max = nil
		reportOptions[1] = L.BossWatcherReportDPS
		wipe(reportData[1])
		reportData[1][1] = (DamageTab_GetGUIDsReport(sourceVar) or L.BossWatcherAllSources).." > "..(DamageTab_GetGUIDsReport(destVar,true) or L.BossWatcherAllTargets)
		local activeFightLength = GetFightLength()
		if DamageTab_Variables.ShowAll then
			total = total + totalOver
			sort(damage,function(a,b) return (a[2]+a[4]+a[5]+a[6])>(b[2]+b[4]+b[5]+b[6]) end)
			_max = damage[1] and (damage[1][2]+damage[1][4]+damage[1][5]+damage[1][6]) or 0
		else
			sort(damage,function(a,b) return a[2]>b[2] end)
			_max = damage[1] and damage[1][2] or 0
		end
		reportData[1][2] = L.BossWatcherReportTotal.." - "..ExRT.F.shortNumber(total).."@1@ ("..floor(total / activeFightLength)..")@1#"
		DamageTab_SetLine({
			line = 1,
			name = L.BossWatcherReportTotal,
			num = total,
			total = total,
			max = total,
			alpha = DamageTab_Variables.ShowAll and totalOver,
			dps = total / activeFightLength,
			spellID = -1,
			check = BWInterfaceFrame.GraphFrame:IsShown(),
			checkState = true,
		})
		for i=1,#damage do
			local isPetAbility = damage[i][1] < 0
			if isPetAbility then
				damage[i][1] = -damage[i][1]
			end
			local spellName,_,spellIcon = GetSpellInfo(damage[i][1])
			if isPetAbility then
				spellName = L.BossWatcherPetText..": "..spellName
			end
			local school = module.db.spellsSchool[ damage[i][1] ] or 0
			local tooltipData = {
				{spellName,spellIcon},
				{L.BossWatcherDamageTooltipCount,damage[i][3]-damage[i][11]},
				{L.BossWatcherDamageTooltipMaxHit,damage[i][13]},
				{L.BossWatcherDamageTooltipMidHit,ExRT.F.Round((damage[i][2]-damage[i][7]-damage[i][10]+damage[i][4])/max(damage[i][3]-damage[i][8]-damage[i][11],1))},
				{L.BossWatcherDamageTooltiCritCount,format("%d (%.1f%%)",damage[i][8],damage[i][8]/damage[i][3]*100)},
				{L.BossWatcherDamageTooltiCritAmount,ExRT.F.shortNumber(damage[i][7])},
				{L.BossWatcherDamageTooltiMaxCrit,damage[i][9]},
				{L.BossWatcherDamageTooltiMidCrit,ExRT.F.Round(damage[i][7]/max(damage[i][8],1))},
				{L.BossWatcherDamageTooltiMsCount,format("%d (%.1f%%)",damage[i][11],damage[i][11]/damage[i][3]*100)},
				{L.BossWatcherDamageTooltiMsAmount,ExRT.F.shortNumber(damage[i][10])},
				{L.BossWatcherDamageTooltiMaxMs,damage[i][12]},				
				{L.BossWatcherDamageTooltiMidMs,ExRT.F.Round(damage[i][10]/max(damage[i][11],1))},
				{L.BossWatcherDamageTooltipParry,format("%d (%.1f%%)",damage[i][14],damage[i][14]/damage[i][3]*100)},
				{L.BossWatcherDamageTooltipDodge,format("%d (%.1f%%)",damage[i][15],damage[i][15]/damage[i][3]*100)},
				{L.BossWatcherDamageTooltipMiss,format("%d (%.1f%%)",damage[i][16],damage[i][16]/damage[i][3]*100)},
				{L.BossWatcherDamageTooltipOverkill,ExRT.F.shortNumber(damage[i][4])},
				{L.BossWatcherDamageTooltipBlocked,ExRT.F.shortNumber(damage[i][5])},
				{L.BossWatcherDamageTooltipAbsorbed,ExRT.F.shortNumber(damage[i][6])},
				{L.BossWatcherDamageTooltipTotal,ExRT.F.shortNumber(damage[i][4]+damage[i][5]+damage[i][6]+damage[i][2])},
				{L.BossWatcherSchool,GetSchoolName(school)},
			}
			local castsCount = SpellsPage_GetCastsNumber(ExRT.F.table_len(sourceVar) > 0 and sourceVar,damage[i][1])
			if castsCount > 0 then
				tinsert(tooltipData,2,{L.BossWatcherDamageTooltipCastsCount,castsCount})
			end
			
			sort(damage[i][17],DamageTab_Temp_SortingBy2Param)
			if #damage[i][17] > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherDamageTooltipTargets," "}
			end
			for j=1,min(5,#damage[i][17]) do
				tooltipData[#tooltipData + 1] = {SubUTF8String(GetGUID(damage[i][17][j][1]),20)..GUIDtoText(" [%s]",damage[i][17][j][1]),format("%s (%.1f%%)",ExRT.F.shortNumber(damage[i][17][j][2]),min(damage[i][17][j][2] / max(1,damage[i][2]+(DamageTab_Variables.ShowAll and (damage[i][4]+damage[i][5]+damage[i][6]) or 0))*100,100))}
			end
			
			local currDamage = damage[i][2]+(DamageTab_Variables.ShowAll and (damage[i][4]+damage[i][5]+damage[i][6]) or 0)
			local dps = currDamage/activeFightLength
			DamageTab_SetLine({
				line = i+1,
				icon = spellIcon,
				name = spellName,
				num = currDamage,
				alpha = DamageTab_Variables.ShowAll and (damage[i][4]+damage[i][5]+damage[i][6]),
				total = total,
				max = _max,
				dps = dps,
				spellID = damage[i][1],
				doEnemy = doEnemy,
				school = school,
				tooltip = tooltipData,
				isPet = isPetAbility,
				check = BWInterfaceFrame.GraphFrame:IsShown(),
				checkState = i <= 3,
			})
			reportData[1][#reportData[1]+1] = i..". "..(isPetAbility and L.BossWatcherPetText..": " or "")..GetSpellLink(damage[i][1]).." - "..ExRT.F.shortNumber(currDamage).."@1@ ("..floor(dps)..")@1#"
			
			if isPetAbility then
				damage[i][1] = -damage[i][1]
			end
		end
		for i=#damage+2,#BWInterfaceFrame.tab.tabs[1].lines do
			BWInterfaceFrame.tab.tabs[1].lines[i]:Hide()
		end
		BWInterfaceFrame.tab.tabs[1].scroll:Height((#damage+1) * 20)
		
		
		if not BWInterfaceFrame.GraphFrame:IsShown() then
			return
		end
		local graph = {[-1]={}}
		local currFight = module.db.data[module.db.nowNum]
		local maxFight = #module.db.data[module.db.nowNum].fight
		for seg=1,maxFight do
			for destGUID,destData in pairs(currFight.fight[seg].damage) do
				if ExRT.F.table_len(destVar) == 0 or destVar[destGUID] then
					local isEnemy = false
					if GetUnitInfoByUnitFlagFix(currFight.reaction[destGUID],2) == 512 then
						isEnemy = true
					end
					local mobID = ExRT.F.GUIDtoID(destGUID)
					for sourceGUID,sourceData in pairs(destData) do
						local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
						if owner then
							sourceGUID = owner
						end
						if ExRT.F.table_len(sourceVar) == 0 or sourceVar[sourceGUID] then
							if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
								for spellID,spellAmount in pairs(sourceData) do
									if owner then
										spellID = -spellID
									end
									if not graph[ spellID ] then
										graph[ spellID ] = {}
									end
									if not graph[ spellID ][seg] then
										graph[ spellID ][seg] = 0
									end
									if not graph[ -1 ][seg] then
										graph[ -1 ][seg] = 0
									end
								
									local damgeCount = spellAmount.amount + (DamageTab_Variables.ShowAll and (spellAmount.blocked+spellAmount.absorbed) or -spellAmount.overkill)
									if mobID == 76933 then	--Mage T100 fix
										damgeCount = 0
									end
									graph[ spellID ][seg] = graph[ spellID ][seg] + damgeCount
									graph[ -1 ][seg] = graph[ -1 ][seg] + damgeCount
								end
							end
						end
					end
				end
			end
		end
		DamageTab_ReloadGraph(graph,maxFight,damage,true)
	end
	local function DamageTab_UpdateLinesTargets(doEnemy)
		DamageTab_UpdateDropDownSource()
		DamageTab_UpdateDropDownDest()
		DamageTab_UpdateDropDownType(2,doEnemy)
		DamageTab_Variables.Last_Func = DamageTab_UpdateLinesTargets
		DamageTab_Variables.Last_doEnemy = doEnemy
		DamageTab_Variables.Back_Func = DamageTab_UpdateLinesTargets
		DamageTab_Variables.Back_sourceVar = nil
		DamageTab_Variables.Back_destVar = nil
		local damage = {}
		local total = 0
		local totalOver = 0
		for destGUID,destData in pairs(module.db.nowData.damage) do
			local isEnemy = GetUnitInfoByUnitFlagFix(module.db.data[module.db.nowNum].reaction[destGUID],2) == 512
			local mobID = ExRT.F.GUIDtoID(destGUID)
			if (ExRT.F.table_len(destVar) == 0 or destVar[destGUID]) and ((doEnemy and isEnemy) or (not doEnemy and not isEnemy)) then
				for sourceGUID,sourceData in pairs(destData) do
					local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
					if owner then
						sourceGUID = owner
					end
					if ExRT.F.table_len(sourceVar) == 0 or sourceVar[sourceGUID] then
						local inDamagePos = ExRT.F.table_find(damage,destGUID,1)
						if not inDamagePos then
							inDamagePos = #damage + 1
							damage[inDamagePos] = {destGUID,0,0,0,0,0,0,{}}
						end
						
						local sourcePos = ExRT.F.table_find(damage[inDamagePos][8],sourceGUID,1)
						if not sourcePos then
							sourcePos = #damage[inDamagePos][8] + 1
							damage[inDamagePos][8][sourcePos] = {sourceGUID,0}
						end
						sourcePos = damage[inDamagePos][8][sourcePos]
						
						for spellID,spellAmount in pairs(sourceData) do
							damage[inDamagePos][2] = damage[inDamagePos][2] + spellAmount.amount - spellAmount.overkill
							damage[inDamagePos][3] = damage[inDamagePos][3] + spellAmount.overkill	--overkill
							damage[inDamagePos][4] = damage[inDamagePos][4] + spellAmount.blocked	--blocked
							damage[inDamagePos][5] = damage[inDamagePos][5] + spellAmount.absorbed	--absorbed
							damage[inDamagePos][6] = damage[inDamagePos][6] + spellAmount.crit	--crit
							damage[inDamagePos][7] = damage[inDamagePos][7] + spellAmount.ms	--ms
							total = total + spellAmount.amount - spellAmount.overkill
							totalOver = totalOver + spellAmount.overkill + spellAmount.blocked + spellAmount.absorbed
							
							sourcePos[2] = sourcePos[2] + spellAmount.amount + (DamageTab_Variables.ShowAll and (spellAmount.blocked+spellAmount.absorbed) or -spellAmount.overkill)
							
							if mobID == 76933 then	--Mage T100 fix
								local multiplier = VExRT.BossWatcher.divisionPrismatic and 0 or 1
								damage[inDamagePos][2] = damage[inDamagePos][2] - spellAmount.amount
								damage[inDamagePos][3] = damage[inDamagePos][3] + (spellAmount.amount * multiplier)
								total = total - spellAmount.amount
								totalOver = totalOver + (spellAmount.amount * multiplier)
							end
						end
					end
				end
			end
		end
		local totalIsFull = 1
		total = max(total,1)
		if total == 1 and #damage == 0 then
			total = 0
			totalIsFull = 0
		end
		local _max = nil
		reportOptions[1] = L.BossWatcherReportDPS
		wipe(reportData[1])
		reportData[1][1] = (DamageTab_GetGUIDsReport(sourceVar) or L.BossWatcherAllSources).." > "..(DamageTab_GetGUIDsReport(destVar,true) or L.BossWatcherAllTargets)
		local activeFightLength = GetFightLength()
		
		if DamageTab_Variables.ShowAll then
			total = total + totalOver
			sort(damage,function(a,b) return (a[2]+a[3]+a[4]+a[5])>(b[2]+b[3]+b[4]+b[5]) end)
			_max = damage[1] and (damage[1][2]+damage[1][3]+damage[1][4]+damage[1][5]) or 0
		else
			sort(damage,function(a,b) return a[2]>b[2] end)
			_max = damage[1] and damage[1][2] or 0
		end
		reportData[1][2] = L.BossWatcherReportTotal.." - "..ExRT.F.shortNumber(total).."@1@ ("..floor(total / activeFightLength)..")@1#"
		DamageTab_SetLine({
			line = 1,
			name = L.BossWatcherReportTotal,
			num = total,
			total = total,
			max = total,
			alpha = DamageTab_Variables.ShowAll and totalOver,
			dps = total / activeFightLength,
			spellID = -1,
			check = BWInterfaceFrame.GraphFrame:IsShown(),
			checkState = true,
		})
		for i=1,#damage do
			local class = nil
			if damage[i][1] and damage[i][1] ~= "" then
				class = select(2,GetPlayerInfoByGUID(damage[i][1]))
			end
			local icon = ""
			if class and CLASS_ICON_TCOORDS[class] then
				icon = {"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",unpack(CLASS_ICON_TCOORDS[class])}
			end
			local tooltipData = {GetGUID(damage[i][1]),
				{L.BossWatcherDamageTooltipOverkill,ExRT.F.shortNumber(damage[i][3])},
				{L.BossWatcherDamageTooltipBlocked,ExRT.F.shortNumber(damage[i][4])},
				{L.BossWatcherDamageTooltipAbsorbed,ExRT.F.shortNumber(damage[i][5])},
				{L.BossWatcherDamageTooltipTotal,ExRT.F.shortNumber(damage[i][2]+damage[i][3]+damage[i][4]+damage[i][5])},
				{" "," "},
				{L.BossWatcherDamageTooltipFromCrit,format("%s (%.1f%%)",ExRT.F.shortNumber(damage[i][6]),max(100,damage[i][6]/max(1,damage[i][2]+damage[i][3])*100))},
				{L.BossWatcherDamageTooltipFromMs,format("%s (%.1f%%)",ExRT.F.shortNumber(damage[i][7]),max(100,damage[i][7]/max(1,damage[i][2]+damage[i][3])*100))},
			}
			sort(damage[i][8],DamageTab_Temp_SortingBy2Param)
			if #damage[i][8] > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherDamageTooltipSources," "}
			end
			for j=1,min(5,#damage[i][8]) do
				tooltipData[#tooltipData + 1] = {SubUTF8String(GetGUID(damage[i][8][j][1]),20)..GUIDtoText(" [%s]",damage[i][8][j][1]),format("%s (%.1f%%)",ExRT.F.shortNumber(damage[i][8][j][2]),min(damage[i][8][j][2] / max(1,damage[i][2]+(DamageTab_Variables.ShowAll and (damage[i][3]+damage[i][4]+damage[i][5]) or 0))*100,100))}
			end
			
			local currDamage = damage[i][2]+(DamageTab_Variables.ShowAll and (damage[i][3]+damage[i][4]+damage[i][5]) or 0)
			local dps = currDamage/activeFightLength
			DamageTab_SetLine({
				line = i+1,
				icon = icon,
				name = GetGUID(damage[i][1])..GUIDtoText(" [%s]",damage[i][1]),
				num = currDamage,
				alpha = DamageTab_Variables.ShowAll and (damage[i][3]+damage[i][4]+damage[i][5]),
				total = total,
				max = _max,
				dps = dps,
				class = class,
				sourceGUID = damage[i][1],
				doEnemy = doEnemy,
				isTargetLine = true,
				tooltip = tooltipData,
				check = BWInterfaceFrame.GraphFrame:IsShown(),
				checkState = i <= 3,
			})
			reportData[1][#reportData[1]+1] = i..". "..GetGUID(damage[i][1]).." - "..ExRT.F.shortNumber(currDamage).."@1@ ("..floor(dps)..")@1#"			
		end
		for i=#damage+2,#BWInterfaceFrame.tab.tabs[1].lines do
			BWInterfaceFrame.tab.tabs[1].lines[i]:Hide()
		end
		BWInterfaceFrame.tab.tabs[1].scroll:Height((#damage+1) * 20)
		
		
		if not BWInterfaceFrame.GraphFrame:IsShown() then
			return
		end
		local graph = {[-1]={}}
		local currFight = module.db.data[module.db.nowNum]
		local maxFight = #module.db.data[module.db.nowNum].fight
		for seg=1,maxFight do
			for destGUID,destData in pairs(currFight.fight[seg].damage) do
				if ExRT.F.table_len(destVar) == 0 or destVar[destGUID] then
					local isEnemy = false
					if GetUnitInfoByUnitFlagFix(currFight.reaction[destGUID],2) == 512 then
						isEnemy = true
					end
					local mobID = ExRT.F.GUIDtoID(destGUID)
					for sourceGUID,sourceData in pairs(destData) do
						local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
						if owner then
							sourceGUID = owner
						end
						if ExRT.F.table_len(sourceVar) == 0 or sourceVar[sourceGUID] then
							if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
								if not graph[ destGUID ] then
									graph[ destGUID ] = {}
								end
								if not graph[ destGUID ][seg] then
									graph[ destGUID ][seg] = 0
								end
								if not graph[ -1 ][seg] then
									graph[ -1 ][seg] = 0
								end
								for spellID,spellAmount in pairs(sourceData) do
									local damgeCount = spellAmount.amount + (DamageTab_Variables.ShowAll and (spellAmount.blocked+spellAmount.absorbed) or -spellAmount.overkill)
									if mobID == 76933 then	--Mage T100 fix
										damgeCount = 0
									end
									graph[ destGUID ][seg] = graph[ destGUID ][seg] + damgeCount
									graph[ -1 ][seg] = graph[ -1 ][seg] + damgeCount
								end
							end
						end
					end
				end
			end
		end
		DamageTab_ReloadGraph(graph,maxFight,damage,false)
	end
	
	local function DamageTab_UpdateLinesSpellToTargets(doEnemy)
		local spellIDnow,spellIDnow_Name = nil,""
		for spellID,_ in pairs(sourceVar) do
			spellIDnow = spellID
		end
		if spellIDnow then
			spellIDnow_Name = GetSpellInfo(spellIDnow) or ""
			BWInterfaceFrame.tab.tabs[1].sourceDropDown:SetText(spellIDnow_Name)
		else
			BWInterfaceFrame.tab.tabs[1].sourceDropDown:SetText(L.BossWatcherSelect)
		end
		DamageTab_UpdateDropDownDest()
		DamageTab_UpdateDropDownType(4,doEnemy)
		DamageTab_Variables.Last_Func = DamageTab_UpdateLinesSpellToTargets
		DamageTab_Variables.Last_doEnemy = doEnemy
		DamageTab_Variables.Back_Func = nil
		DamageTab_Variables.Back_sourceVar = nil
		DamageTab_Variables.Back_destVar = nil
		local damage = {}
		local total = 0
		local totalOver = 0
		local totalCount = 0
		for destGUID,destData in pairs(module.db.nowData.damage) do
			local isEnemy = GetUnitInfoByUnitFlagFix(module.db.data[module.db.nowNum].reaction[destGUID],2) == 512
			local mobID = ExRT.F.GUIDtoID(destGUID)
			if (doEnemy and isEnemy) or (not doEnemy and not isEnemy) then
				for sourceGUID,sourceData in pairs(destData) do
					for spellID,spellAmount in pairs(sourceData) do
						if sourceVar[spellID] then
							local inDamagePos = ExRT.F.table_find(damage,destGUID,1)
							if not inDamagePos then
								inDamagePos = #damage + 1
								damage[inDamagePos] = {destGUID,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
							end
							damage[inDamagePos][2] = damage[inDamagePos][2] + spellAmount.amount - spellAmount.overkill	--amount
							damage[inDamagePos][3] = damage[inDamagePos][3] + spellAmount.count	--count
							damage[inDamagePos][4] = damage[inDamagePos][4] + spellAmount.overkill	--overkill
							damage[inDamagePos][5] = damage[inDamagePos][5] + spellAmount.blocked	--blocked
							damage[inDamagePos][6] = damage[inDamagePos][6] + spellAmount.absorbed	--absorbed
							damage[inDamagePos][7] = damage[inDamagePos][7] + spellAmount.crit	--crit
							damage[inDamagePos][8] = damage[inDamagePos][8] + spellAmount.critcount	--crit count
							damage[inDamagePos][9] = max(damage[inDamagePos][9],spellAmount.critmax)--crit max
							damage[inDamagePos][10] = damage[inDamagePos][10] + spellAmount.ms	--ms
							damage[inDamagePos][11] = damage[inDamagePos][11] + spellAmount.mscount	--ms count
							damage[inDamagePos][12] = max(damage[inDamagePos][12],spellAmount.msmax)--ms max
							damage[inDamagePos][13] = max(damage[inDamagePos][13],spellAmount.hitmax)--hit max
							damage[inDamagePos][14] = damage[inDamagePos][14] + spellAmount.parry	--parry
							damage[inDamagePos][15] = damage[inDamagePos][15] + spellAmount.dodge	--dodge
							damage[inDamagePos][16] = damage[inDamagePos][16] + spellAmount.miss	--other miss
							total = total + spellAmount.amount - spellAmount.overkill
							totalOver = totalOver + spellAmount.overkill + spellAmount.blocked + spellAmount.absorbed
							totalCount = totalCount + spellAmount.count - spellAmount.mscount
							
							if mobID == 76933 then	--Mage T100 fix
								local multiplier = VExRT.BossWatcher.divisionPrismatic and 0 or 1
								damage[inDamagePos][2] = damage[inDamagePos][2] - spellAmount.amount
								damage[inDamagePos][4] = damage[inDamagePos][4] + (spellAmount.amount * multiplier)
								total = total - spellAmount.amount
								totalOver = totalOver + (spellAmount.amount * multiplier)
							end
						end
					end
				end
			end
		end
		local totalIsFull = 1
		total = max(total,1)
		if total == 1 and #damage == 0 then
			total = 0
			totalIsFull = 0
		end
		local _max = nil
		reportOptions[1] = L.BossWatcherReportCount
		wipe(reportData[1])
		reportData[1][1] = GetSpellLink(spellIDnow).." > "..L.BossWatcherAllTargets
		
		if DamageTab_Variables.ShowAll then
			total = total + totalOver
			sort(damage,function(a,b) return (a[2]+a[4]+a[5]+a[6])>(b[2]+b[4]+b[5]+b[6]) end)
			_max = damage[1] and (damage[1][2]+damage[1][4]+damage[1][5]+damage[1][6]) or 0
		else
			sort(damage,function(a,b) return a[2]>b[2] end)
			_max = damage[1] and damage[1][2] or 0
		end
		reportData[1][2] = L.BossWatcherReportTotal.." - "..ExRT.F.shortNumber(total).."@1@ ("..floor(totalCount)..")@1#"
		DamageTab_SetLine({
			line = 1,
			name = L.BossWatcherReportTotal,
			num = total,
			total = total,
			max = total,
			alpha = DamageTab_Variables.ShowAll and totalOver,
			dps = totalCount,
			spellID = -1,
			check = BWInterfaceFrame.GraphFrame:IsShown(),
			checkState = true,
		})
		for i=1,#damage do
			local class = nil
			if damage[i][1] and damage[i][1] ~= "" then
				class = select(2,GetPlayerInfoByGUID(damage[i][1]))
			end
			local icon = ""
			if class and CLASS_ICON_TCOORDS[class] then
				icon = {"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",unpack(CLASS_ICON_TCOORDS[class])}
			end
			local tooltipData = {GetGUID(damage[i][1]),
				{L.BossWatcherDamageTooltipCount,damage[i][3]-damage[i][11]},
				{L.BossWatcherDamageTooltipMaxHit,damage[i][13]},
				{L.BossWatcherDamageTooltipMidHit,ExRT.F.Round((damage[i][2]-damage[i][7]-damage[i][10]+damage[i][4])/max(damage[i][3]-damage[i][8]-damage[i][11],1))},
				{L.BossWatcherDamageTooltiCritCount,format("%d (%.1f%%)",damage[i][8],damage[i][8]/damage[i][3]*100)},
				{L.BossWatcherDamageTooltiCritAmount,ExRT.F.shortNumber(damage[i][7])},
				{L.BossWatcherDamageTooltiMaxCrit,damage[i][9]},
				{L.BossWatcherDamageTooltiMidCrit,ExRT.F.Round(damage[i][7]/max(damage[i][8],1))},
				{L.BossWatcherDamageTooltiMsCount,format("%d (%.1f%%)",damage[i][11],damage[i][11]/damage[i][3]*100)},
				{L.BossWatcherDamageTooltiMsAmount,ExRT.F.shortNumber(damage[i][10])},
				{L.BossWatcherDamageTooltiMaxMs,damage[i][12]},				
				{L.BossWatcherDamageTooltiMidMs,ExRT.F.Round(damage[i][10]/max(damage[i][11],1))},
				{L.BossWatcherDamageTooltipParry,format("%d (%.1f%%)",damage[i][14],damage[i][14]/damage[i][3]*100)},
				{L.BossWatcherDamageTooltipDodge,format("%d (%.1f%%)",damage[i][15],damage[i][15]/damage[i][3]*100)},
				{L.BossWatcherDamageTooltipMiss,format("%d (%.1f%%)",damage[i][16],damage[i][16]/damage[i][3]*100)},
				{L.BossWatcherDamageTooltipOverkill,ExRT.F.shortNumber(damage[i][4])},
				{L.BossWatcherDamageTooltipBlocked,ExRT.F.shortNumber(damage[i][5])},
				{L.BossWatcherDamageTooltipAbsorbed,ExRT.F.shortNumber(damage[i][6])},
				{L.BossWatcherDamageTooltipTotal,ExRT.F.shortNumber(damage[i][4]+damage[i][5]+damage[i][6]+damage[i][2])},
			}
			
			local currDamage = damage[i][2]+(DamageTab_Variables.ShowAll and (damage[i][4]+damage[i][5]+damage[i][6]) or 0)
			DamageTab_SetLine({
				line = i+1,
				icon = icon,
				name = GetGUID(damage[i][1])..GUIDtoText(" [%s]",damage[i][1]),
				num = currDamage,
				alpha = DamageTab_Variables.ShowAll and (damage[i][4]+damage[i][5]+damage[i][6]),
				total = total,
				max = _max,
				dps = damage[i][3]-damage[i][11],
				class = class,
				sourceGUID = damage[i][1],
				doEnemy = doEnemy,
				tooltip = tooltipData,
				check = BWInterfaceFrame.GraphFrame:IsShown(),
				checkState = i <= 3,
			})
			reportData[1][#reportData[1]+1] = i..". "..GetGUID(damage[i][1]).." - "..ExRT.F.shortNumber(currDamage).."@1@ ("..(damage[i][3]-damage[i][11])..")@1#"
		end
		for i=#damage+2,#BWInterfaceFrame.tab.tabs[1].lines do
			BWInterfaceFrame.tab.tabs[1].lines[i]:Hide()
		end
		BWInterfaceFrame.tab.tabs[1].scroll:Height((#damage+1) * 20)
		
		
		if not BWInterfaceFrame.GraphFrame:IsShown() then
			return
		end
		local graph = {[-1]={}}
		local currFight = module.db.data[module.db.nowNum]
		local maxFight = #module.db.data[module.db.nowNum].fight
		for seg=1,maxFight do
			for destGUID,destData in pairs(currFight.fight[seg].damage) do
				local isEnemy = false
				if GetUnitInfoByUnitFlagFix(currFight.reaction[destGUID],2) == 512 then
					isEnemy = true
				end
				local mobID = ExRT.F.GUIDtoID(destGUID)
				for sourceGUID,sourceData in pairs(destData) do
					local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
					if owner then
						sourceGUID = owner
					end
					if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
						for spellID,spellAmount in pairs(sourceData) do
							if sourceVar[spellID] then
								if not graph[ destGUID ] then
									graph[ destGUID ] = {}
								end
								if not graph[ destGUID ][seg] then
									graph[ destGUID ][seg] = 0
								end
								if not graph[ -1 ][seg] then
									graph[ -1 ][seg] = 0
								end
							
								local damgeCount = spellAmount.count - spellAmount.mscount
								if mobID == 76933 then	--Mage T100 fix
									damgeCount = 0
								end
								graph[ destGUID ][seg] = graph[ destGUID ][seg] + damgeCount
								graph[ -1 ][seg] = graph[ -1 ][seg] + damgeCount
							end
						end
					end
				end
			end
		end
		DamageTab_ReloadGraph(graph,maxFight,damage,false)
	end
	
	local function DamageTab_ShowDamageToTarget(GUID)
		local button = BWInterfaceFrame.tab.tabs[1].button
		local func = button:GetScript("OnClick")
		func(button)
		wipe(sourceVar)
		wipe(destVar)
		destVar[GUID] = true
		DamageTab_UpdateLinesPlayers(true)
	end
	
	local function DamageTab_DPS_SelectDropDownSource(self,arg,doEnemy,doSpells)
		local Back_destVar = ExRT.F.table_copy2(destVar)
		local Back_sourceVar = ExRT.F.table_copy2(sourceVar)
		wipe(sourceVar)
		if arg then
			sourceVar[arg] = true
			
			if IsShiftKeyDown() then
				local name = module.db.data[module.db.nowNum].guids[arg]
				if name then
					for GUID,GUIDname in pairs(module.db.data[module.db.nowNum].guids) do
						if GUIDname == name then
							sourceVar[GUID] = true
						end
					end
				end
			end
		end
		if not doSpells then
			if ExRT.F.table_len(destVar) == 0 then
				if ExRT.F.table_len(sourceVar) ~= 0 then
					DamageTab_UpdateLinesTargets(doEnemy)
				else
					DamageTab_UpdateLinesPlayers(doEnemy)
				end
			else
				if ExRT.F.table_len(sourceVar) ~= 0 then
					DamageTab_UpdateLinesSpells(doEnemy)
				else
					DamageTab_UpdateLinesPlayers(doEnemy)
				end
			end
		else
			DamageTab_UpdateLinesSpells(doEnemy)
		end
		DamageTab_Variables.Back_destVar = Back_destVar
		DamageTab_Variables.Back_sourceVar = Back_sourceVar
		ELib:DropDownClose()
	end
	local function DamageTab_DPS_SelectDropDownDest(self,arg,doEnemy,doSpells)
		local Back_destVar = ExRT.F.table_copy2(destVar)
		local Back_sourceVar = ExRT.F.table_copy2(sourceVar)
		wipe(destVar)
		if arg then
			destVar[arg] = true
			
			if IsShiftKeyDown() then
				local name = module.db.data[module.db.nowNum].guids[arg]
				if name then
					for GUID,GUIDname in pairs(module.db.data[module.db.nowNum].guids) do
						if GUIDname == name then
							destVar[GUID] = true
						end
					end
				end
			end
		end
		if not doSpells then
			if ExRT.F.table_len(sourceVar) == 0 then
				DamageTab_UpdateLinesPlayers(doEnemy)
			else
				if ExRT.F.table_len(destVar) == 0 then
					DamageTab_UpdateLinesTargets(doEnemy)
				else
					DamageTab_UpdateLinesSpells(doEnemy)
				end
			end
		else
			DamageTab_UpdateLinesSpells(doEnemy)
		end
		DamageTab_Variables.Back_destVar = Back_destVar
		DamageTab_Variables.Back_sourceVar = Back_sourceVar
		ELib:DropDownClose()
	end
	
	local function DamageTab_DPS_SelectDropDownSource_Spell(self,spellID,doEnemy)
		wipe(sourceVar)
		sourceVar[spellID] = true
		DamageTab_UpdateLinesSpellToTargets(doEnemy)
		ELib:DropDownClose()
	end

	local function DamageTab_DPS_CheckDropDownSource(self,checked)
		if checked then
			sourceVar[self.arg1] = true
		else
			sourceVar[self.arg1] = nil
		end
		DamageTab_Variables.Last_Func(self.arg2)
	end
	local function DamageTab_DPS_CheckDropDownDest(self,checked)
		if checked then
			destVar[self.arg1] = true
		else
			destVar[self.arg1] = nil
		end
		DamageTab_Variables.Last_Func(self.arg2)
	end
	
	local function DamageTab_HideArrow()
		BWInterfaceFrame.timeLineFrame.timeLine.arrow:Hide()
	end
	local function DamageTab_ShowArrow(self,pos)
		if pos then
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:SetPoint("TOPLEFT",BWInterfaceFrame.timeLineFrame.timeLine,"BOTTOMLEFT",BWInterfaceFrame.timeLineFrame.width*pos,0)
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:Show()
		end
	end
	
	local function DamageTab_HoverDropDownSpell(self,spellID)
		if not spellID then
			return
		end
		ELib.Tooltip.Link(self,"spell:"..spellID)
	end

	local function DamageTab_DPS(doEnemy,doSpells,doNotUpdateLines,isBySpellDamage)
		local reaction = 512 
		if not doEnemy then 
			reaction = 256 
		end
		
		if not module.db.nowData.damage then	--First load fix
			return
		end
	
		local sourceTable = {}
		local destTable = {}
		for destGUID,destData in pairs(module.db.nowData.damage) do
			local mobID = ExRT.F.GUIDtoID(destGUID)
			if GetUnitInfoByUnitFlagFix(module.db.data[module.db.nowNum].reaction[destGUID],2) == reaction and (mobID ~= 76933 or VExRT.BossWatcher.showPrismatic) then
				destTable[#destTable + 1] = {destGUID,module.db.nowData.damage_seen[destGUID] or 0}
				for sourceGUID,sourceData in pairs(destData) do
					local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
					if owner then
						sourceGUID = owner
					end
					if not isBySpellDamage then
						if not ExRT.F.table_find(sourceTable,sourceGUID,1) then
							sourceTable[#sourceTable + 1] = {sourceGUID,GetGUID(sourceGUID)}
						end
					else
						for spellID,spellAmount in pairs(sourceData) do
							if not ExRT.F.table_find(sourceTable,spellID,1) then
								local spellName,_,spellIcon = GetSpellInfo(spellID)
								sourceTable[#sourceTable + 1] = {spellID,spellName,spellIcon}
							end
						end
					end
				end
			end
		end
		sort(sourceTable,function(a,b) return a[2]<b[2] end)
		sort(destTable,function(a,b) return a[2]<b[2] end)
		wipe(BWInterfaceFrame.tab.tabs[1].sourceDropDown.List)
		wipe(BWInterfaceFrame.tab.tabs[1].targetDropDown.List)
		if not isBySpellDamage then
			BWInterfaceFrame.tab.tabs[1].sourceDropDown.List[1] = {text = L.BossWatcherAll,func = DamageTab_DPS_SelectDropDownSource,arg2=doEnemy,arg3=doSpells,padding = 16}
			BWInterfaceFrame.tab.tabs[1].targetDropDown.List[1] = {text = L.BossWatcherAll,func = DamageTab_DPS_SelectDropDownDest,arg2=doEnemy,arg3=doSpells,padding = 16}
			for i=1,#sourceTable do
				local isPlayer = ExRT.F.GetUnitTypeByGUID(sourceTable[i][1]) == 0
				local classColor = ""
				if isPlayer then
					classColor = "|c"..ExRT.F.classColorByGUID(sourceTable[i][1])
				end
				BWInterfaceFrame.tab.tabs[1].sourceDropDown.List[i+1] = {
					text = classColor..sourceTable[i][2]..GUIDtoText(" [%s]",sourceTable[i][1]),
					arg1 = sourceTable[i][1],
					arg2 = doEnemy,
					arg3 = doSpells,
					func = DamageTab_DPS_SelectDropDownSource,
					checkFunc = DamageTab_DPS_CheckDropDownSource,
					checkable = true,
				}
			end
		else
			for i=1,#sourceTable do
				local spellColorTable = module.db.schoolsColors[ module.db.spellsSchool[ sourceTable[i][1] ] or 0 ] or module.db.schoolsColors[0]
				local spellColor = "|cff"..format("%02x%02x%02x",spellColorTable.r*255,spellColorTable.g*255,spellColorTable.b*255)
				BWInterfaceFrame.tab.tabs[1].sourceDropDown.List[i] = {
					text = spellColor..sourceTable[i][2],
					arg1 = sourceTable[i][1],
					arg2 = doEnemy,
					func = DamageTab_DPS_SelectDropDownSource_Spell,
					icon = sourceTable[i][3],
					hoverFunc = DamageTab_HoverDropDownSpell,
					hoverArg = sourceTable[i][1],
					leaveFunc = GameTooltip_Hide,
				}
			end
			wipe(sourceVar)
			wipe(destVar)
			DamageTab_UpdateLinesSpellToTargets(doEnemy)
			return
		end
		for i=1,#destTable do
			local isPlayer = ExRT.F.GetUnitTypeByGUID(destTable[i][1]) == 0
			local classColor = ""
			if isPlayer then
				classColor = "|c"..ExRT.F.classColorByGUID(destTable[i][1])
			end
			BWInterfaceFrame.tab.tabs[1].targetDropDown.List[i+1] = {
				text = classColor.. date("%M:%S ", timestampToFightTime( module.db.nowData.damage_seen[destTable[i][1]] ))..GetGUID(destTable[i][1])..GUIDtoText(" [%s]",destTable[i][1]),
				arg1 = destTable[i][1],
				arg2 = doEnemy,
				arg3 = doSpells,
				func = DamageTab_DPS_SelectDropDownDest,
				hoverFunc = DamageTab_ShowArrow,
				leaveFunc = DamageTab_HideArrow,
				hoverArg = timestampToFightTime( module.db.nowData.damage_seen[destTable[i][1]] ) / ( module.db.data[module.db.nowNum].encounterEnd - module.db.data[module.db.nowNum].encounterStart ),
				checkFunc = DamageTab_DPS_CheckDropDownDest,
				checkable = true,
			}
		end
		wipe(sourceVar)
		wipe(destVar)
		if not doNotUpdateLines then
			if doSpells then
				DamageTab_UpdateLinesSpells(doEnemy)		
			else
				DamageTab_UpdateLinesPlayers(doEnemy)
			end
		end
	end
	
	local function DamageTab_UpdatePage(_,doEnemy,doSpells,doNotUpdateLines,isBySpellDamage)
		--[[
			--doEnemy,doSpells,doNotUpdateLines,isBySpellDamage
			true,false,false,false		Damage by source: friendly
			false,false,false,false		Damage by source: hostile
			true,false,true,false		Damage to target: friendly
			false,false,true,false		Damage to target: hostile
			true,true,false,false		Damage by spell: friendly
			false,true,false,false		Damage by spell: hostile
			true,false,false,true		Damage from spell: friendly
			false,false,false,true		Damage from spell: hostile
		]]
		DamageTab_Variables.Back_Func = nil
		
		DamageTab_DPS(doEnemy,doSpells,doNotUpdateLines,isBySpellDamage)
		if doNotUpdateLines then
			DamageTab_UpdateLinesTargets(doEnemy)
		end
		ELib:DropDownClose()
	end
	
	tab.typeDropDown = ELib:DropDown(tab,200,10):Size(195):Point(70,-75):SetText(L.BossWatcherDamageDamageDone)
	tab.typeText = ELib:Text(tab,L.BossWatcherType..":",12):Size(100,20):Point("RIGHT",tab.typeDropDown,"LEFT",-6,0):Right():Color():Shadow()
	tab.typeDropDown.List = {
		{text = L.BossWatcherHealFriendly,isTitle = true},
		{text = L.BossWatcherBySource,func = DamageTab_UpdatePage,				arg1=true,							},
		{text = L.BossWatcherByTarget,func = DamageTab_UpdatePage,				arg1=true,			arg3=true,			},
		{text = L.BossWatcherBySpell,func = DamageTab_UpdatePage,				arg1=true,	arg2=true,					},
		{text = L.BossWatcherDamageDamageSpellToHostile,func = DamageTab_UpdatePage,		arg1=true,					arg4=true,	},
		{text = L.BossWatcherHealHostile,isTitle = true},
		{text = L.BossWatcherBySource,func = DamageTab_UpdatePage,				arg1=false,							},
		{text = L.BossWatcherByTarget,func = DamageTab_UpdatePage,				arg1=false,			arg3=true,			},
		{text = L.BossWatcherBySpell,func = DamageTab_UpdatePage,				arg1=false,	arg2=true,					},
		{text = L.BossWatcherDamageDamageSpellToFriendly,func = DamageTab_UpdatePage,		arg1=false,					arg4=true,	},
	}
	
	tab.sourceDropDown = ELib:DropDown(tab,250,20):Size(195):Point(365,-75):SetText(L.BossWatcherAll):Tooltip(L.BossWatcherDropdownsHoldShiftSource)
	tab.sourceText = ELib:Text(tab,L.BossWatcherSource..":",12):Size(100,20):Point("RIGHT",tab.sourceDropDown,"LEFT",-6,0):Right():Color():Shadow()

	tab.targetDropDown = ELib:DropDown(tab,250,20):Size(195):Point(630,-75):SetText(L.BossWatcherAll):Tooltip(L.BossWatcherDropdownsHoldShiftDest)
	tab.targetText = ELib:Text(tab,L.BossWatcherTarget..":",12):Size(100,20):Point("TOPRIGHT",tab.targetDropDown,"TOPLEFT",-6,0):Right():Color():Shadow()

	
	function tab.sourceDropDown:additionalToggle()
		for i=2,#self.List do
			self.List[i].checkState = sourceVar[ self.List[i].arg1 ]
		end
	end
	function tab.targetDropDown:additionalToggle()
		for i=2,#self.List do
			self.List[i].checkState = destVar[ self.List[i].arg1 ]
		end
	end
	
	tab.showOverallChk = ELib:Check(tab):Point(833,-75):Tooltip(L.BossWatcherDamageShowOver):OnClick(function (self)
		if self:GetChecked() then
			DamageTab_Variables.ShowAll = true
		else
			DamageTab_Variables.ShowAll = false
		end
		DamageTab_Variables.Last_Func(DamageTab_Variables.Last_doEnemy)
	end)
	
	tab.showGraphChk = ELib:Check(tab,"|cffffffff"..L.BossWatcherTabGraphics.." ",VExRT.BossWatcher.optionsDamageGraph):Point(833,-100):Left():OnClick(function (self)
		local tab1 = BWInterfaceFrame.tab.tabs[1]
		if self:GetChecked() then
			tab1.scroll:Point("TOP",0,-305)
			BWInterfaceFrame.GraphFrame:Show()
		else
			tab1.scroll:Point("TOP",0,-125)
			BWInterfaceFrame.GraphFrame:Hide()
		end
		VExRT.BossWatcher.optionsDamageGraph = self:GetChecked()
		DamageTab_Variables.Last_Func(DamageTab_Variables.Last_doEnemy)
	end)
	
	tab.scroll = ELib:ScrollFrame(tab):Point("TOP",0,VExRT.BossWatcher.optionsDamageGraph and -305 or -125):Point("BOTTOM",0,10):Height(600)
	tab.scroll:SetWidth(835)
	tab.scroll.C:SetWidth(835)
	tab.lines = {}

	local function DamageTab_RightClick_BackFunction()
		if not DamageTab_Variables.Back_Func then
			return
		end
		if DamageTab_Variables.Back_sourceVar then
			sourceVar = DamageTab_Variables.Back_sourceVar
		else
			wipe(sourceVar)
		end
		if DamageTab_Variables.Back_destVar then
			destVar = DamageTab_Variables.Back_destVar
		else
			wipe(destVar)
		end
		DamageTab_Variables.Back_Func(DamageTab_Variables.Last_doEnemy)
	end
	
	tab.scroll:SetScript("OnMouseUp",function(self,button)
		if button == "RightButton" then
			DamageTab_RightClick_BackFunction()
		end
	end)
	
	local function DamageTab_Line_Check_OnClick(self)
		local spellID = self:GetParent().spellID or self:GetParent().sourceGUID
		if not spellID then
			return
		end
		local graphData = BWInterfaceFrame.GraphFrame.G.data
		if self:GetParent().isPet and type(spellID) == 'number' then
			spellID = -spellID
		end
		local findPos = ExRT.F.table_find(graphData,spellID,'info_spellID')
		if findPos then
			graphData[ findPos ].hide = not self:GetChecked()
		end
		BWInterfaceFrame.GraphFrame.G:Reload()
	end
	local function DamageTab_Line_OnClick(self,button)
		if button == "RightButton" then
			DamageTab_RightClick_BackFunction()
			return
		end
		local x,y = ExRT.F.GetCursorPos(self)
		if (self.check and self.check:IsShown() or (self:GetParent().check and self:GetParent().check:IsShown())) and x <= 30 then
			return
		end
		local GUID = self.sourceGUID
		local doEnemy = self.doEnemy
		local tooltip = self.spellLink
		local isTargetLine = self.isTargetLine
		
		local parent = self:GetParent()
		if parent.isMain then
			GUID = parent.sourceGUID
			doEnemy = parent.doEnemy
			tooltip = parent.spellLink
			isTargetLine = parent.isTargetLine
		end
		if parent.isMain and IsShiftKeyDown() and tooltip and tooltip:find("spell:") then
			local spellID = tooltip:match("%d+")
			if spellID then
				ExRT.F.LinkSpell(spellID)
				return
			end
		end
		if GUID then
			local Back_destVar = ExRT.F.table_copy2(destVar)
			local Back_sourceVar = ExRT.F.table_copy2(sourceVar)
			if isTargetLine then
				wipe(destVar)
				destVar[GUID] = true
				DamageTab_UpdateLinesSpells(doEnemy)
				DamageTab_Variables.Back_Func = DamageTab_UpdateLinesTargets
			else
				wipe(sourceVar)
				sourceVar[GUID] = true
				DamageTab_UpdateLinesSpells(doEnemy)
				DamageTab_Variables.Back_Func = DamageTab_UpdateLinesPlayers
			end
			DamageTab_Variables.Back_destVar = Back_destVar
			DamageTab_Variables.Back_sourceVar = Back_sourceVar
		end
	end
	local function DamageTab_LineOnEnter(self)
		if self.tooltip then
			GameTooltip:SetOwner(self,"ANCHOR_LEFT")
			local firstLine = self.tooltip[1]
			if type(firstLine) == "table" then
				firstLine = (firstLine[2] and "|T"..firstLine[2]..":18|t " or "")..firstLine[1]
			end
			GameTooltip:SetText(firstLine)
			for i=2,#self.tooltip do
				if type(self.tooltip[i]) == "table" then
					GameTooltip:AddDoubleLine(self.tooltip[i][1],self.tooltip[i][2],1,1,1,1,1,1,1,1)
				else
					GameTooltip:AddLine(self.tooltip[i])
				end
			end
			GameTooltip:Show()
		end
	end
	local function DamageTab_Line_OnEnter(self)
		local parent = self:GetParent()
		if parent.spellLink then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetHyperlink(parent.spellLink)
			GameTooltip:Show()
		elseif parent.name:IsTruncated() then
			GameTooltip:SetOwner(self,"ANCHOR_LEFT")
			GameTooltip:SetText(parent.name:GetText())
			GameTooltip:Show()	
		elseif parent.tooltip then
			DamageTab_LineOnEnter(parent)
		end
	end
	function DamageTab_SetLine(dataTable)
		local i,icon,name,overall_num,overall,total,dps,class,sourceGUID,doEnemy,spellLink,tooltip,school,overall_black,isTargetLine,showCheck,checkState,spellID,isPet
		
		i = dataTable.line
		icon = dataTable.icon or ""
		name = dataTable.name
		total = dataTable.num
		overall_num = dataTable.num / max(dataTable.total,1)
		overall = dataTable.num / max(dataTable.max,1)
		if dataTable.alpha then
			overall_black = dataTable.alpha / max(dataTable.num,1)
		end
		dps = dataTable.dps
		class = dataTable.class
		sourceGUID = dataTable.sourceGUID
		doEnemy = dataTable.doEnemy
		if dataTable.spellID and dataTable.spellID ~= -1 then
			spellLink = "spell:"..dataTable.spellID
		end
		tooltip = dataTable.tooltip
		school = dataTable.school
		isTargetLine = dataTable.isTargetLine
		showCheck = dataTable.check
		checkState = dataTable.checkState
		spellID = dataTable.spellID
		isPet = dataTable.isPet
		
		local line = BWInterfaceFrame.tab.tabs[1].lines[i]
		if not line then
			line = CreateFrame("Button",nil,BWInterfaceFrame.tab.tabs[1].scroll.C)
			BWInterfaceFrame.tab.tabs[1].lines[i] = line
			line:SetSize(815,20)
			line:SetPoint("TOPLEFT",0,-(i-1)*20)
			
			line.leftSide = CreateFrame("Frame",nil,line)
			line.leftSide:SetSize(1,20)
			line.leftSide:SetPoint("LEFT",5,0)
			
			line.check = ELib:Check(line,""):Point("TOPLEFT",5,-2)
			line.check:SetSize(16,16)
			line.check:SetScript("OnClick",DamageTab_Line_Check_OnClick)
			
			line.overall_num = ELib:Text(line,"45.76%",12):Size(70,20):Point(250,0):Right():Color():Shadow()

			line.icon = ELib:Icon(line,nil,18):Point("TOPLEFT",line.leftSide,0,-1)
			line.name = ELib:Text(line,"name",12):Size(0,20):Point("TOPLEFT",line.leftSide,25,0):Point("TOPRIGHT",line.overall_num,"TOPLEFT",0,0):Color():Shadow()
			line.name:SetMaxLines(1)
			
			line.name_tooltip = CreateFrame('Button',nil,line)
			line.name_tooltip:SetAllPoints(line.name)
			line.overall = line:CreateTexture(nil, "BACKGROUND")
			line.overall:SetTexture("Interface\\AddOns\\ExRT\\media\\bar24.tga")
			line.overall:SetSize(300,16)
			line.overall:SetPoint("TOPLEFT",325,-2)
			line.overall_black = line:CreateTexture(nil, "BACKGROUND")
			line.overall_black:SetTexture("Interface\\AddOns\\ExRT\\media\\bar24b.tga")
			line.overall_black:SetSize(300,16)
			line.overall_black:SetPoint("LEFT",line.overall,"RIGHT",0,0)
			
			line.total = ELib:Text(line,"125.46M",12):Size(95,20):Point(630,0):Color():Shadow()
			line.dps = ELib:Text(line,"34576.43",12):Size(100,20):Point(725,0):Color():Shadow()
			
			line.back = line:CreateTexture(nil, "BACKGROUND")
			line.back:SetAllPoints()
			if i%2 == 0 then
				line.back:SetColorTexture(0.3, 0.3, 0.3, 0.1)
			end
			line.name_tooltip:SetScript("OnClick",DamageTab_Line_OnClick)
			line.name_tooltip:SetScript("OnEnter",DamageTab_Line_OnEnter)
			line.name_tooltip:SetScript("OnLeave",GameTooltip_Hide)
			line:SetScript("OnClick",DamageTab_Line_OnClick)
			line:SetScript("OnEnter",DamageTab_LineOnEnter)
			line:SetScript("OnLeave",GameTooltip_Hide)
			line:RegisterForClicks("AnyUp")
			
			line.isMain = true
		end
		if type(icon) == "table" then
			line.icon.texture:SetTexture(icon[1] or "Interface\\Icons\\INV_MISC_QUESTIONMARK")
			line.icon.texture:SetTexCoord(unpack(icon,2,5))
		else
			line.icon.texture:SetTexture(icon or "Interface\\Icons\\INV_MISC_QUESTIONMARK")
			line.icon.texture:SetTexCoord(0,1,0,1)
		end
		line.name:SetText(name or "")
		line.overall_num:SetFormattedText("%.2f%%",overall_num and overall_num * 100 or 0)
		if overall_black and overall_black > 0 then
			local width = 300*(overall or 1)
			local normal_width = width * (1 - overall_black)
			line.overall:SetWidth(max(normal_width,1))
			line.overall_black:SetWidth(max(width-normal_width,1))
			line.overall_black:Show()
			if normal_width == 0 then
				line.overall:Hide()
				line.overall_black:SetPoint("TOPLEFT",325,-2)
			else
				line.overall:Show()
				line.overall_black:ClearAllPoints()
				line.overall_black:SetPoint("LEFT",line.overall,"RIGHT",0,0)
			end
		else
			line.overall:Show()
			line.overall_black:Hide()
			line.overall:SetWidth(max(300*(overall or 1),1))
		end
		line.total:SetText(total and ExRT.F.shortNumber(total) or "")
		line.dps:SetFormattedText("%.2f",dps or 0)
		line.overall:SetGradientAlpha("HORIZONTAL", 0,0,0,0,0,0,0,0)
		line.overall_black:SetGradientAlpha("HORIZONTAL", 0,0,0,0,0,0,0,0)
		if class then
			local classColorArray = type(CUSTOM_CLASS_COLORS)=="table" and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
			if classColorArray then
				line.overall:SetVertexColor(classColorArray.r,classColorArray.g,classColorArray.b, 1)
				line.overall_black:SetVertexColor(classColorArray.r,classColorArray.g,classColorArray.b, 1)
			else
				line.overall:SetVertexColor(0.8,0.8,0.8, 1)
				line.overall_black:SetVertexColor(0.8,0.8,0.8, 1)
			end
		else
			line.overall:SetVertexColor(0.8,0.8,0.8, 1)
			line.overall_black:SetVertexColor(0.8,0.8,0.8, 1)
		end
		if school then
			SetSchoolColorsToLine(line.overall,school)
			SetSchoolColorsToLine(line.overall_black,school)
		end
		if showCheck then
			line.leftSide:SetPoint("LEFT",25,0)
			line.check:SetChecked(checkState)
			line.check:Show()
		else
			line.leftSide:SetPoint("LEFT",5,0)
			line.check:Hide()
		end
		line.sourceGUID = sourceGUID
		line.spellID = spellID
		line.doEnemy = doEnemy
		line.spellLink = spellLink
		line.tooltip = tooltip
		line.isTargetLine = isTargetLine
		line.isPet = isPet
		line:Show()
	end
	
	local function DamageTab_Graph_ZoomSecondUpdate_1(self)
		self.ZoomSecondUpdate_arg1 = DamageTab_Variables.Last_Func
		self.ZoomSecondUpdate_arg2 = DamageTab_Variables.Last_doEnemy
	end
	local function DamageTab_Graph_ZoomSecondUpdate_2(self)
		if self.ZoomSecondUpdate_arg1 then
			self.ZoomSecondUpdate_arg1(self.ZoomSecondUpdate_arg2)
		end
	end
		
	tab:SetScript("OnShow",function (self)
		BWInterfaceFrame.timeLineFrame:ClearAllPoints()
		BWInterfaceFrame.timeLineFrame:SetPoint("TOP",self,"TOP",0,-10)
		BWInterfaceFrame.timeLineFrame:Show()
		
		BWInterfaceFrame.report:Show()
		
		BWInterfaceFrame.GraphFrame.G.ZoomSecondUpdate_1 = DamageTab_Graph_ZoomSecondUpdate_1
		BWInterfaceFrame.GraphFrame.G.ZoomSecondUpdate_2 = DamageTab_Graph_ZoomSecondUpdate_2
		BWInterfaceFrame.GraphFrame:SetPoint("TOP",0,-105)
		if BWInterfaceFrame.tab.tabs[1].showGraphChk:GetChecked() then
			BWInterfaceFrame.GraphFrame:Show()
			if DamageTab_Variables.Last_Func then
				DamageTab_Variables.Last_Func(DamageTab_Variables.Last_doEnemy)
			end
		end
		
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			DamageTab_UpdatePage(nil,true)
			self.lastFightID = BWInterfaceFrame.nowFightID
		end
	end)
	tab:SetScript("OnHide",function (self)
		BWInterfaceFrame.timeLineFrame:Hide()
		BWInterfaceFrame.report:Hide()
		BWInterfaceFrame.GraphFrame:Hide()
	end)
	
	
	
	
	---- Auras Tab
	tab = BWInterfaceFrame.tab.tabs[3]
	tabName = BWInterfaceFrame_Name.."AurasTab"
	
	tab.timeLine = {}
	
	local AurasTab_Variables = {
		FilterSource = 0x0111,
		FilterSourceGUID = {},
		FilterDest = 0x0111,
		FilterDestGUID = {},
		NameWidth = 188,
		WorkWidth = 650,
		TotalLines = 30,
	}
	AurasTab_Variables.TotalWidth = AurasTab_Variables.NameWidth + AurasTab_Variables.WorkWidth
	--[[
	0x0001 - hostile
	0x0010 - friendly
	0x0100 - pets & guards
	0x1000 - by GUID
	]]
	
	for i=1,11 do
		tab.timeLine[i] = CreateFrame("Frame",nil,tab)
		tab.timeLine[i]:SetPoint("TOPLEFT",AurasTab_Variables.NameWidth+(i-1)*(AurasTab_Variables.WorkWidth/10)-1,-42)
		tab.timeLine[i]:SetSize(2,AurasTab_Variables.TotalLines * 18 + 14)
		
		tab.timeLine[i].texture = tab.timeLine[i]:CreateTexture(nil, "BACKGROUND")
		tab.timeLine[i].texture:SetColorTexture(1, 1, 1, 0.3)
		tab.timeLine[i].texture:SetAllPoints()		
		
		tab.timeLine[i].timeText = ELib:Text(tab.timeLine[i],"",11):Size(200,12):Point("TOPRIGHT",tab.timeLine[i],"TOPLEFT",-1,-1):Right():Top():Color()
	end
	
	tab.redDeathLine = {}
	local function CreateRedDeathLine(i)
		if not BWInterfaceFrame.tab.tabs[3].redDeathLine[i] then
			BWInterfaceFrame.tab.tabs[3].redDeathLine[i] = BWInterfaceFrame.tab.tabs[3]:CreateTexture(nil, "BACKGROUND",0,-4)
			BWInterfaceFrame.tab.tabs[3].redDeathLine[i]:SetColorTexture(1, 0.3, 0.3, 1)
			BWInterfaceFrame.tab.tabs[3].redDeathLine[i]:SetSize(2,AurasTab_Variables.TotalLines * 18 + 14)
			BWInterfaceFrame.tab.tabs[3].redDeathLine[i]:Hide()
		end
	end
	
	tab.linesRightClickMenu = {
		{ text = "Spell", isTitle = true, notCheckable = true, notClickable = true },
		{ text = L.BossWatcherSendToChat, func = function() 
			if BWInterfaceFrame.tab.tabs[3].linesRightClickMenuData then
				local chat_type = ExRT.F.chatType(true)
				SendChatMessage(BWInterfaceFrame.tab.tabs[3].linesRightClickMenuData[1],chat_type)
				for i=2,#BWInterfaceFrame.tab.tabs[3].linesRightClickMenuData do
					SendChatMessage(ExRT.F.clearTextTag(BWInterfaceFrame.tab.tabs[3].linesRightClickMenuData[i]),chat_type)
				end
			end
			CloseDropDownMenus()
		end, notCheckable = true },
		{ text = L.BossWatcherAddToGraph, func = function() 
			CloseDropDownMenus()
			local buffData = BWInterfaceFrame.tab.tabs[3].linesRightClickLineData
			if not buffData then
				return
			end
			local table1 = {}
			for i=1,#buffData[5] do
				table1[#table1+1] = buffData[5][i][3]
				table1[#table1+1] = buffData[5][i][4]
			end
			local len = #table1
			for i=1,len,2 do
				local time_start,time_end = table1[i],table1[i+1]
				if time_start then
					for j=i+2,len,2 do
						local new_start,new_end = table1[j],table1[j+1]
						if new_start then
							if new_start <= time_start and new_end > time_start then
								time_start = new_start
								time_end = max(time_end,new_end)
								
								table1[j] = nil
								table1[j+1] = nil
							elseif new_start > time_start and new_start <= time_end then
								time_end = max(time_end,new_end)
								
								table1[j] = nil
								table1[j+1] = nil
							end
						end
					end
					table1[i] = time_start
					table1[i+1] = time_end
				end
			end
			local table2 = {}
			for i=1,len,2 do
				if table1[i] then
					table2[#table2 + 1] = table1[i]
					table2[#table2 + 1] = table1[i + 1]
				end
			end
			BWInterfaceFrame.GraphFrame.G.highlight = table2
		end, notCheckable = true },
		{ text = L.BossWatcherAurasMoreInfoText, func = function() 
			if BWInterfaceFrame.tab.tabs[3].linesRightClickMoreInfoData then
				BWInterfaceFrame.tab.tabs[3].linesRightClickMoreInfo:Update()
				BWInterfaceFrame.tab.tabs[3].linesRightClickMoreInfo:ShowClick()
			end
			CloseDropDownMenus()
		end, notCheckable = true },
		{ text = L.minimapmenuclose, func = function() CloseDropDownMenus() end, notCheckable = true },
	}
	tab.linesRightClickMenuDropDown = CreateFrame("Frame", tabName.."LinesRightClickMenuDropDown", nil, "UIDropDownMenuTemplate")
	
	tab.linesRightClickMoreInfo = ELib:Popup(L.BossWatcherAurasMoreInfoText):Size(300,375)
	tab.linesRightClickMoreInfo.ScrollFrame = ELib:ScrollFrame(tab.linesRightClickMoreInfo):Size(285,320):Point("TOP",0,-25):Height(400)
	--tab.linesRightClickMoreInfo.ScrollFrame.backdrop:Hide()
	tab.linesRightClickMoreInfo.lines = {}
	tab.linesRightClickMoreInfo.anchor = "TOPRIGHT"
	tab.linesRightClickMoreInfo.reportButton = ELib:Button(tab.linesRightClickMoreInfo,L.BossWatcherCreateReport):Size(292,20):Point("BOTTOM",0,5):Tooltip(L.BossWatcherCreateReportTooltip):OnClick(function (self)
		ExRT.F:ToChatWindow(BWInterfaceFrame.tab.tabs[3].linesRightClickMoreInfo.report)
		BWInterfaceFrame.tab.tabs[3].linesRightClickMoreInfo:Hide()
	end)
	do
		local function LineOnEnter(self)
			if self.name:IsTruncated() then
				GameTooltip:SetOwner(self,"ANCHOR_LEFT")
				GameTooltip:SetText(self.name:GetText())
				GameTooltip:Show()
 			end
		end
		local function SetLine(i,name,count)
			if not BWInterfaceFrame.tab.tabs[3].linesRightClickMoreInfo.lines[i] then
				local line = CreateFrame("Button",nil,BWInterfaceFrame.tab.tabs[3].linesRightClickMoreInfo.ScrollFrame.C)
				BWInterfaceFrame.tab.tabs[3].linesRightClickMoreInfo.lines[i] = line
				line:SetSize(270,20)
				line:SetPoint("TOPLEFT",0,-(i-1)*20)
				
				line.name = ELib:Text(line,"name",11):Size(210,20):Point(10,0):Color():Shadow()
				line.count = ELib:Text(line,"name",12):Size(40,20):Point(220,0):Center():Color():Shadow()
				
				line.back = line:CreateTexture(nil, "BACKGROUND")
				line.back:SetAllPoints()
				if i%2==0 then
					line.back:SetColorTexture(0.3, 0.3, 0.3, 0.1)
				end
				
				line:SetScript("OnEnter",LineOnEnter)
				line:SetScript("OnLeave",GameTooltip_Hide)
			end
			BWInterfaceFrame.tab.tabs[3].linesRightClickMoreInfo.lines[i].name:SetText(i..". "..name)
			BWInterfaceFrame.tab.tabs[3].linesRightClickMoreInfo.lines[i].count:SetText(count)
			
			BWInterfaceFrame.tab.tabs[3].linesRightClickMoreInfo.lines[i]:Show()
		end
		tab.linesRightClickMoreInfo.Update = function(self)
			local spellID = BWInterfaceFrame.tab.tabs[3].linesRightClickMoreInfoData
			self.title:SetText(GetSpellInfo(spellID) or "?")
			local data = {}
			for i,sourceData in ipairs(module.db.nowData.auras) do
				if sourceData[6] == spellID and (sourceData[8] == 1 or sourceData[8] == 3) and (not BWInterfaceFrame.tab.tabs[3].filterS or (BWInterfaceFrame.tab.tabs[3].filterS == 1 and sourceData[4]) or (BWInterfaceFrame.tab.tabs[3].filterS == 2 and not sourceData[4]) or BWInterfaceFrame.tab.tabs[3].filterS == sourceData[2]) then
					local inPos = ExRT.F.table_find(data,sourceData[3],1)
					if not inPos then
						inPos = #data + 1
						data[inPos] = {sourceData[3],0,0}
					end
					data[inPos][2] = data[inPos][2] + 1
				end
			end
			for destGUID,destData in pairs(module.db.nowData.damage) do
				for sourceGUID,sourceData in pairs(destData) do
					if not BWInterfaceFrame.tab.tabs[3].filterS or BWInterfaceFrame.tab.tabs[3].filterS == sourceGUID then
						if sourceData[spellID] then
							local missed = sourceData[spellID].parry + sourceData[spellID].dodge + sourceData[spellID].miss
							if missed > 0 then
								local inPos = ExRT.F.table_find(data,destGUID,1)
								if not inPos then
									inPos = #data + 1
									data[inPos] = {destGUID,0,0}
								end
								data[inPos][3] = data[inPos][3] + 1
							end
						end
					end
				end
			end
			sort(data,function(a,b)return a[2]>b[2]end)
			local report = {}
			BWInterfaceFrame.tab.tabs[3].linesRightClickMoreInfo.report = report
			report[1] = GetSpellLink(spellID)
			for i=1,#data do
				local isPlayer = ExRT.F.GetUnitTypeByGUID(data[i][1]) == 0
				local classColor = ""
				if isPlayer then
					classColor = "|c"..ExRT.F.classColorByGUID(data[i][1])
				end
				SetLine(i,classColor..GetGUID(data[i][1])..GUIDtoText(" [%s]",data[i][1]),data[i][2]..(data[i][3] > 0 and "+"..data[i][3] or ""))
				report[#report+1] = i..". "..GetGUID(data[i][1]).." - "..data[i][2]..(data[i][3] > 0 and "+"..data[i][3] or "")
			end
			for i=#data+1,#BWInterfaceFrame.tab.tabs[3].linesRightClickMoreInfo.lines do
				BWInterfaceFrame.tab.tabs[3].linesRightClickMoreInfo.lines[i]:Hide()
			end
			BWInterfaceFrame.tab.tabs[3].linesRightClickMoreInfo.ScrollFrame:SetNewHeight(#data * 20)
		end
	end
	
	local BuffsLineUptimeTempTable = {}
	local function BuffsLinesOnUpdate(self)
		local x,y = ExRT.F.GetCursorPos(self)
		if ExRT.F.IsInFocus(self,x,y) then
			for j=1,AurasTab_Variables.TotalLines do
				if BWInterfaceFrame.tab.tabs[3].lines[j] ~= self then
					BWInterfaceFrame.tab.tabs[3].lines[j].hl:Hide()
				end
			end
			self.hl:Show()
			if x <= AurasTab_Variables.NameWidth then
				if GameTooltip:IsShown() then
					local _,_,spellID = GameTooltip:GetSpell()
					if spellID == self.spellID then
						return
					end
				end
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -AurasTab_Variables.WorkWidth, 0)
				GameTooltip:SetHyperlink(self.spellLink)
				
				local greenCount = #self.greenTooltips
				for i=1,greenCount do
					BuffsLineUptimeTempTable[(i-1)*2+1] = self.greenTooltips[i][1]
					BuffsLineUptimeTempTable[(i-1)*2+2] = self.greenTooltips[i][2]
				end
				for i=1,greenCount do
					local iPos = (i-1)*2+1
					if BuffsLineUptimeTempTable[iPos] then
						for j=1,greenCount do
							local jPos = (j-1)*2+1
							if i~=j and BuffsLineUptimeTempTable[jPos] then
								if BuffsLineUptimeTempTable[jPos] <= BuffsLineUptimeTempTable[iPos] and BuffsLineUptimeTempTable[jPos+1] > BuffsLineUptimeTempTable[iPos] then
									BuffsLineUptimeTempTable[iPos] = BuffsLineUptimeTempTable[jPos]
									BuffsLineUptimeTempTable[iPos+1] = max(BuffsLineUptimeTempTable[jPos+1],BuffsLineUptimeTempTable[iPos+1])
									BuffsLineUptimeTempTable[jPos] = nil
									BuffsLineUptimeTempTable[jPos+1] = nil
								end
								if BuffsLineUptimeTempTable[jPos] and BuffsLineUptimeTempTable[jPos+1] >= BuffsLineUptimeTempTable[iPos+1] and BuffsLineUptimeTempTable[jPos] < BuffsLineUptimeTempTable[iPos+1] then
									BuffsLineUptimeTempTable[iPos] = min(BuffsLineUptimeTempTable[jPos],BuffsLineUptimeTempTable[iPos])
									BuffsLineUptimeTempTable[iPos+1] = BuffsLineUptimeTempTable[jPos+1]
									BuffsLineUptimeTempTable[jPos] = nil
									BuffsLineUptimeTempTable[jPos+1] = nil
								end
							end
						end
					end
				end
				local uptime = 0
				for i=1,greenCount do
					local iPos = (i-1)*2+1
					if BuffsLineUptimeTempTable[iPos] then
						uptime = uptime + (BuffsLineUptimeTempTable[iPos+1] - BuffsLineUptimeTempTable[iPos])
					end
				end
				uptime = uptime / AurasTab_Variables.WorkWidth
				
				GameTooltip:AddLine(L.BossWatcherBuffsAndDebuffsTooltipUptimeText..": "..format("%.2f%% (%.1f %s)",uptime*100,uptime*(module.db.data[module.db.nowNum].encounterEnd - module.db.data[module.db.nowNum].encounterStart),L.BossWatcherBuffsAndDebuffsSecondsText))
				GameTooltip:AddLine(L.BossWatcherBuffsAndDebuffsTooltipCountText..": "..(self.greenCount or 0))
				GameTooltip:Show()
			else
				if not self.tooltip then
					self.tooltip = {}
				end
				table.wipe(self.tooltip)
				local owner = nil
				local _min,_max = AurasTab_Variables.NameWidth+AurasTab_Variables.WorkWidth,AurasTab_Variables.NameWidth
				for j = 1,#self.greenTooltips do
					local rightPos = self.greenTooltips[j][2]
					local leftPos = self.greenTooltips[j][1]
					if rightPos - leftPos < 2 then
						rightPos = leftPos + 2
					end
					if x >= leftPos and x <= rightPos then
						local sourceClass = ExRT.F.classColorByGUID(self.greenTooltips[j][5])
						local destClass = ExRT.F.classColorByGUID(self.greenTooltips[j][6])
						local duration = (self.greenTooltips[j][4] - self.greenTooltips[j][3])
						table.insert(self.tooltip, date("[%M:%S", self.greenTooltips[j][3] ) .. format(".%03d",(self.greenTooltips[j][3]*1000)%1000).. " - "..date("%M:%S", self.greenTooltips[j][3]+duration ).. format(".%03d",((self.greenTooltips[j][3]+duration)*1000)%1000).."] " .. "|c" .. sourceClass .. GetGUID(self.greenTooltips[j][5])..GUIDtoText(" (%s)",self.greenTooltips[j][5]).."|r "..L.BossWatcherBuffsAndDebuffsTextOn.." |c".. destClass .. GetGUID(self.greenTooltips[j][6])..GUIDtoText(" (%s)",self.greenTooltips[j][6]).."|r")
						if self.greenTooltips[j][7] and self.greenTooltips[j][7] ~= 1 then
							self.tooltip[#self.tooltip] = self.tooltip[#self.tooltip] .. " (".. self.greenTooltips[j][7] ..")"
						end
						self.tooltip[#self.tooltip] = self.tooltip[#self.tooltip] .. format(" <%.1f%s>",duration,L.BossWatcherBuffsAndDebuffsSecondsText)
						owner = self.greenTooltips[j][1]
						
						_min = min(_min,leftPos)
						_max = max(_max,rightPos)
					end
				end
				if #self.tooltip > 0 then
					table.sort(self.tooltip,function(a,b) return a < b end)
					ELib.Tooltip.Show(self,{"ANCHOR_LEFT",owner or 0,0},L.BossWatcherBuffsAndDebuffsTooltipTitle..":",unpack(self.tooltip))
				else
					GameTooltip_Hide()
				end
			end
		end
	end
	local function BuffsLinesOnLeave(self)
		GameTooltip_Hide()
		self.hl:Hide()
	end
	local function BuffsLinesOnClick(self,button)
		local x,y = ExRT.F.GetCursorPos(self)
		if x > 0 and x < AurasTab_Variables.TotalWidth and y > 0 and y < 18 then
			if x <= AurasTab_Variables.NameWidth then
				ExRT.F.LinkSpell(nil,self.spellLink)
			elseif button == "RightButton" then
				if GameTooltip:IsShown() then
					if BWInterfaceFrame.tab.tabs[3].linesRightClickMenuData then
						wipe(BWInterfaceFrame.tab.tabs[3].linesRightClickMenuData)
					else
						BWInterfaceFrame.tab.tabs[3].linesRightClickMenuData = {}
					end
					table.insert(BWInterfaceFrame.tab.tabs[3].linesRightClickMenuData , self.spellLink)
					for j=2, GameTooltip:NumLines() do
						table.insert(BWInterfaceFrame.tab.tabs[3].linesRightClickMenuData , _G["GameTooltipTextLeft"..j]:GetText())
					end
					BWInterfaceFrame.tab.tabs[3].linesRightClickMenu[1].text = self.spellName
				else
					BWInterfaceFrame.tab.tabs[3].linesRightClickMenuData = nil
				end
				BWInterfaceFrame.tab.tabs[3].linesRightClickMoreInfoData = self.spellID
				BWInterfaceFrame.tab.tabs[3].linesRightClickLineData = self.lineData
				EasyMenu(BWInterfaceFrame.tab.tabs[3].linesRightClickMenu, BWInterfaceFrame.tab.tabs[3].linesRightClickMenuDropDown, "cursor", 10 , -15, "MENU")
			end
		end
	end
			
	tab.lines = {}
	for i=1,AurasTab_Variables.TotalLines do
		tab.lines[i] = CreateFrame("Button",nil,tab)
		tab.lines[i]:SetSize(AurasTab_Variables.TotalWidth,18)
		tab.lines[i]:SetPoint("TOPLEFT", 0, -18*(i-1)-54)
		
		tab.lines[i].spellIcon = tab.lines[i]:CreateTexture(nil, "BACKGROUND")
		tab.lines[i].spellIcon:SetSize(16,16)
		tab.lines[i].spellIcon:SetPoint("TOPLEFT", 5, -1)
		
		tab.lines[i].spellText = ELib:Text(tab.lines[i],"",11):Size(AurasTab_Variables.NameWidth-23,18):Point(23,0):Color()
		
		tab.lines[i].green = {}
		tab.lines[i].greenFrame = {}
		tab.lines[i].greenCount = 0
		
		tab.lines[i].greenTooltips = {}
		
		ExRT.lib.CreateHoverHighlight(tab.lines[i])
		tab.lines[i].hl:SetAlpha(.5)
		
		tab.lines[i]:SetScript("OnUpdate", BuffsLinesOnUpdate) 
		tab.lines[i]:SetScript("OnLeave", BuffsLinesOnLeave)
		tab.lines[i]:RegisterForClicks("RightButtonUp","LeftButtonUp")
		tab.lines[i]:SetScript("OnClick", BuffsLinesOnClick)
	end
	
	tab.scrollBar = ELib:ScrollBar(tab):Size(16,AurasTab_Variables.TotalLines*18):Point("TOPRIGHT",-4,-54):Range(1,2)
	
	local function CreateBuffGreen(i,j)
		BWInterfaceFrame.tab.tabs[3].lines[i].green[j] = BWInterfaceFrame.tab.tabs[3].lines[i]:CreateTexture(nil, "BACKGROUND",nil,5)
		--BWInterfaceFrame.tab.tabs[3].lines[i].green[j]:SetColorTexture(0.1, 0.7, 0.1, 0.7)
		BWInterfaceFrame.tab.tabs[3].lines[i].green[j]:SetColorTexture(1, 0.82, 0, 0.7)	
		BWInterfaceFrame.tab.tabs[3].lines[i].greenFrame[j] = CreateFrame("Frame",nil,BWInterfaceFrame.tab.tabs[3].lines[i])
	end
	
	local function buffsFunc_GetNamesFromArray(arr)
		local str = ""
		for GUID,_ in pairs(arr) do
			if str ~= "" then
				str = str .. ", "
			end
			str = str .. GetGUID(GUID)
		end
		return str
	end
	
	local function CreateFilterText()
		local result = L.BossWatcherBuffsAndDebuffsFilterSource..": "
		if bit.band(AurasTab_Variables.FilterSource,0xF000) > 0 then
			result = result .. (buffsFunc_GetNamesFromArray(AurasTab_Variables.FilterSourceGUID))
		elseif bit.band(AurasTab_Variables.FilterSource,0x0FFF) == 0x111 then
			result = result .. L.BossWatcherBuffsAndDebuffsFilterAll
		else
			local petsOff = false
			if not (bit.band(AurasTab_Variables.FilterSource,0x0F00) > 0) then
				result = result .. L.BossWatcherBuffsAndDebuffsFilterPetsFilterText 
				petsOff = true
			end
			if not (bit.band(AurasTab_Variables.FilterSource,0x00FF) == 0x0011) then
				result = result .. (petsOff and "," or "")
				if bit.band(AurasTab_Variables.FilterSource,0x00F0) > 0 then
					result = result .. L.BossWatcherBuffsAndDebuffsFilterFriendly
				elseif bit.band(AurasTab_Variables.FilterSource,0x000F) > 0 then
					result = result .. L.BossWatcherBuffsAndDebuffsFilterHostile
				else
					result = result .. L.BossWatcherBuffsAndDebuffsFilterNothing
				end
			end
		end
			
		result = result .. "; "..L.BossWatcherBuffsAndDebuffsFilterTarget..": "
		if bit.band(AurasTab_Variables.FilterDest,0xF000) > 0 then
			result = result .. (buffsFunc_GetNamesFromArray(AurasTab_Variables.FilterDestGUID))
		elseif bit.band(AurasTab_Variables.FilterDest,0x0FFF) == 0x111 then
			result = result .. L.BossWatcherBuffsAndDebuffsFilterAll
		else
			local petsOff = false
			if not (bit.band(AurasTab_Variables.FilterDest,0x0F00) > 0) then
				result = result .. L.BossWatcherBuffsAndDebuffsFilterPetsFilterText
				petsOff = true
			end
			if not (bit.band(AurasTab_Variables.FilterDest,0x00FF) == 0x0011) then
				result = result .. (petsOff and "," or "")
				if bit.band(AurasTab_Variables.FilterDest,0x00F0) > 0 then
					result = result .. L.BossWatcherBuffsAndDebuffsFilterFriendly
				elseif bit.band(AurasTab_Variables.FilterDest,0x000F) > 0 then
					result = result .. L.BossWatcherBuffsAndDebuffsFilterHostile
				else
					result = result .. L.BossWatcherBuffsAndDebuffsFilterNothing
				end
			end
		end		
		result = result .. ";"
		
		local isSpecial = nil
		for i=1,#module.db.buffsFilters do
			if module.db.buffsFilterStatus[i] then
				isSpecial = true
				break
			end
		end
		if isSpecial then
			result = result .. " "..L.BossWatcherBuffsAndDebuffsFilterSpecial..":"
			for i=1,#module.db.buffsFilters do
				if module.db.buffsFilterStatus[i] then
					result = result .. " " .. strlower(module.db.buffsFilters[i][-1]) .. ";"
				end
			end
		end
		BWInterfaceFrame.tab.tabs[3].filterText:SetText(result)
	end
	
	local function buffsFunc_isPetOrGuard(flag)
		if not flag then
			return false
		end
		local res = ExRT.F.GetUnitInfoByUnitFlag(flag,1)
		if res == 4096 or res == 8192 then
			return true
		end
	end
	local function buffsFunc_findStringInArray(array,str)
		for array_str,_ in pairs(array) do
			if type(array_str) == "string" and (array_str == str or str:find(array_str)) then
				return true
			end
		end
	end
	
	local function UpdateBuffPageDB()
		--upvaules
		local currFight = module.db.data[module.db.nowNum]
		local buffsFilterStatus = module.db.buffsFilterStatus
		
		local fightDuration = ((currFight.isEnded and currFight.encounterEnd or GetTime()) - currFight.encounterStart)
		for i=1,10 do
			BWInterfaceFrame.tab.tabs[3].timeLine[i+1].timeText:SetText( date("%M:%S", fightDuration*(i/10) ) )
		end
		
		local _F_sourceGUID = bit.band(AurasTab_Variables.FilterSource,0xF000) > 0
		local _F_sourceFriendly = bit.band(AurasTab_Variables.FilterSource,0x00F0) > 0
		local _F_sourceHostile = bit.band(AurasTab_Variables.FilterSource,0x000F) > 0
		local _F_sourcePets = bit.band(AurasTab_Variables.FilterSource,0x0F00) > 0
		
		local _F_destGUID = bit.band(AurasTab_Variables.FilterDest,0xF000) > 0
		local _F_destFriendly = bit.band(AurasTab_Variables.FilterDest,0x00F0) > 0
		local _F_destHostile = bit.band(AurasTab_Variables.FilterDest,0x000F) > 0
		local _F_destPets = bit.band(AurasTab_Variables.FilterDest,0x0F00) > 0
		
		local buffTable = {}
		for i,sourceData in ipairs(module.db.nowData.auras) do 
			local spellID = sourceData[6]
			local spellName,_,spellTexture = GetSpellInfo(spellID)
			local filterStatus = true
			for j=5,#module.db.buffsFilters do
				filterStatus = filterStatus and (not buffsFilterStatus[j] or module.db.buffsFilters[j][spellID])
			end
			if ((not _F_sourceGUID and ((_F_sourcePets or not buffsFunc_isPetOrGuard(currFight.reaction[ sourceData[2] ])) and ((_F_sourceFriendly and sourceData[4]) or (_F_sourceHostile and not sourceData[4])))) or (sourceData[2] and AurasTab_Variables.FilterSourceGUID[ sourceData[2] ])) and
				((not _F_destGUID and ((_F_destPets or not buffsFunc_isPetOrGuard(currFight.reaction[ sourceData[3] ])) and ((_F_destFriendly and sourceData[5]) or (_F_destHostile and not sourceData[5])))) or (sourceData[3] and AurasTab_Variables.FilterDestGUID[ sourceData[3] ])) and
				(not buffsFilterStatus[1] or sourceData[7] == 'BUFF') and
				(not buffsFilterStatus[2] or sourceData[7] == 'DEBUFF') and
				(not buffsFilterStatus[3] or module.db.buffsFilters[3][spellID]) and
				(not buffsFilterStatus[4] or buffsFunc_findStringInArray(module.db.buffsFilters[4],strlower(spellName))) and
				filterStatus then
				
				local time_ = timestampToFightTime( sourceData[1] )
				local time_postion = time_ / fightDuration
				local type_ = sourceData[8]
				
				local buffTablePos
				for j=1,#buffTable do
					if buffTable[j][1] == spellID then
						buffTablePos = j
						break
					end
				end
				if not buffTablePos then
					buffTablePos = #buffTable + 1
					buffTable[buffTablePos] = {spellID,spellName,spellTexture,{},{}}
				end
				
				local sourceGUID = sourceData[2] or 0
				local destGUID = sourceData[3] or 0
				local sourceDest = sourceGUID .. destGUID
				local buffTableBuffPos
				for j=1,#buffTable[buffTablePos][4] do
					if buffTable[buffTablePos][4][j][1] == sourceDest then
						buffTableBuffPos = j
						break
					end
				end
				if not buffTableBuffPos then
					buffTableBuffPos = #buffTable[buffTablePos][4] + 1
					buffTable[buffTablePos][4][buffTableBuffPos] = {sourceDest,sourceGUID,destGUID,{}}
				end
				
				local eventPos = #buffTable[buffTablePos][4][buffTableBuffPos][4] + 1
				
				if type_ == 3 or type_ == 4 then
					buffTable[buffTablePos][4][buffTableBuffPos][4][eventPos] = {0,time_,time_postion,sourceData[9] or 1}
					type_ = 1
					eventPos = eventPos + 1
				end
				buffTable[buffTablePos][4][buffTableBuffPos][4][eventPos] = {type_ % 2,time_,time_postion,sourceData[9] or 1}
			end
		end
		
		sort(buffTable,function(a,b) return a[2] < b[2] end)
		
		for i=1,#buffTable do 
			local buffTableI = buffTable[i]
			
			for j=1,#buffTableI[4] do
				local buffTableJ = buffTableI[4][j]
				
				local maxEvents = #buffTableJ[4]
				if maxEvents > 0 and buffTableJ[4][1][1] == 0 then
					local newLine = #buffTableI[5] + 1
					buffTableI[5][newLine] = {
						AurasTab_Variables.NameWidth,
						AurasTab_Variables.NameWidth+AurasTab_Variables.WorkWidth*buffTableJ[4][1][3],
						0,
						buffTableJ[4][1][2],
						buffTableJ[2],
						buffTableJ[3],
						1,
					}
				end
				for k=1,maxEvents do
					if buffTableJ[4][k][1] == 1 then
						local endOfTime = nil
						for n=(k+1),maxEvents do
							if buffTableJ[4][n][1] == 0 and not endOfTime then
								endOfTime = n
								--break
							end
						end
						local newLine = #buffTableI[5] + 1
						buffTableI[5][newLine] = {
							AurasTab_Variables.NameWidth+AurasTab_Variables.WorkWidth*buffTableJ[4][k][3],
							AurasTab_Variables.NameWidth+AurasTab_Variables.WorkWidth*(endOfTime and buffTableJ[4][endOfTime][3] or 1),
							buffTableJ[4][k][2],
							endOfTime and buffTableJ[4][endOfTime][2] or fightDuration,
							buffTableJ[2],
							buffTableJ[3],
							buffTableJ[4][k][4],
						}
						--startPos,endPos,startTime,endTime,sourceGUID,destGUID,stacks
					end
				end
			end
		end
		
		--> Death Line
		for i=1,#BWInterfaceFrame.tab.tabs[3].redDeathLine do
			BWInterfaceFrame.tab.tabs[3].redDeathLine[i]:Hide()
		end
		if _F_destGUID and ExRT.F.table_len(AurasTab_Variables.FilterDestGUID) > 0 then
			local j = 0
			for i=1,#module.db.nowData.dies do
				if AurasTab_Variables.FilterDestGUID[ module.db.nowData.dies[i][1] ] then
					j = j + 1
					CreateRedDeathLine(j)
					local time_ = timestampToFightTime( module.db.nowData.dies[i][3] )
					local pos = AurasTab_Variables.NameWidth + time_/fightDuration*AurasTab_Variables.WorkWidth - 1
					BWInterfaceFrame.tab.tabs[3].redDeathLine[j]:SetPoint("TOPLEFT",pos,-42)
					BWInterfaceFrame.tab.tabs[3].redDeathLine[j]:Show()
				end
			end
		end
		
		BWInterfaceFrame.tab.tabs[3].scrollBar:Range(1,max(#buffTable-AurasTab_Variables.TotalLines+1,1))		
		BWInterfaceFrame.tab.tabs[3].db = buffTable
		
		--ExRT.F.ScheduleTimer(collectgarbage, 1, "collect")
	end
	
	local function UpdateBuffsPage()
		CreateFilterText()
		local currTab = BWInterfaceFrame.tab.tabs[3]
		if not currTab.db then
			return
		end
		
		local minVal = ExRT.F.Round(currTab.scrollBar:GetValue())
		local buffTable2 = currTab.db
		
		local linesCount = 0
		for i=1,AurasTab_Variables.TotalLines do
			for j=1,currTab.lines[i].greenCount do
				currTab.lines[i].green[j]:Hide()
			end
			currTab.lines[i].greenCount = 0
			table.wipe(currTab.lines[i].greenTooltips)
		end
		for i=minVal,#buffTable2 do
			local data = buffTable2[i]
			linesCount = linesCount + 1
			local Line = currTab.lines[linesCount]
			Line.spellIcon:SetTexture(data[3])
			Line.spellText:SetText(data[2] or "???")
			Line.spellLink = GetSpellLink(data[1])
			Line.spellName = data[2] or "Spell"
			Line.spellID = data[1]
			Line.lineData = data
			
			for j=1,#data[5] do
				Line.greenCount = Line.greenCount + 1
				local n = Line.greenCount

				if not Line.green[n] then
					CreateBuffGreen(linesCount,n)
				end
				
				Line.green[n]:SetPoint("TOPLEFT",data[5][j][1],0)
				Line.green[n]:SetSize(max(data[5][j][2]-data[5][j][1],0.1),18)
				Line.green[n]:Show()
				
				Line.greenTooltips[#Line.greenTooltips+1] = data[5][j]
			end

			Line:Show()
			if linesCount >= AurasTab_Variables.TotalLines then
				break
			end
		end
		for i=(linesCount+1),AurasTab_Variables.TotalLines do
			local line = currTab.lines[i]
			line:Hide()
			line.lineData = nil
		end
		currTab.scrollBar:UpdateButtons()
	end

	tab.scrollBar:SetScript("OnValueChanged",UpdateBuffsPage)
	tab:SetScript("OnMouseWheel",function (self,delta)
		if delta > 0 then
			BWInterfaceFrame.tab.tabs[3].scrollBar.buttonUP:Click("LeftButton")
		else
			BWInterfaceFrame.tab.tabs[3].scrollBar.buttonDown:Click("LeftButton")
		end
	end)
	
	function AurasPage_IsAuraOn(destGUID,auraSpellID,fightTime)
		local isOnNow = false
		for i=1,#module.db.data[module.db.nowNum].fight do
			local aurasTable = module.db.data[module.db.nowNum].fight[i].auras
			for j=1,#aurasTable do
				if aurasTable[j][6] == auraSpellID and aurasTable[j][3] == destGUID then
					if aurasTable[j][8] == 1 or aurasTable[j][8] == 2 then
						isOnNow = true
					else
						isOnNow = false
					end
				end
				local thisTime = timestampToFightTime( aurasTable[j][1] )
				if thisTime > fightTime then
					return isOnNow
				end
			end
		end
		return isOnNow
	end

	tab.filterFrame = ELib:Popup(L.BossWatcherBuffsAndDebuffsFilterFilter):Size(570,465)
	
	tab.filterFrame.HelpButton = ExRT.lib.CreateHelpButton(tab.filterFrame,{
		FramePos = { x = 0, y = 0 },FrameSize = { width = 570, height = 465 },
		[1] = { ButtonPos = { x = 260,	y = -35 },  	HighLightBox = { x = 0, y = 0, width = 570, height = 465 },		ToolTipDir = "DOWN",	ToolTipText = L.cd2FilterWindowHelp },
	})
	
	local function UpdateTargetsList(self,isSourceFrame,friendly,hostile,pets)
		table.wipe(self.L)
		table.wipe(self.LGUID)
		if isSourceFrame then
			isSourceFrame = 4
		else
			isSourceFrame = 5
		end
		local list = {}
		for i=1,#module.db.nowData.auras do
			local sourceData = module.db.nowData.auras[i]
			local sourceGUID
			if isSourceFrame == 4 then
				sourceGUID = (friendly and sourceData[isSourceFrame] and sourceData[2]) or (hostile and not sourceData[isSourceFrame] and sourceData[2])
			elseif isSourceFrame == 5 then
				sourceGUID = (friendly and sourceData[isSourceFrame] and sourceData[3]) or (hostile and not sourceData[isSourceFrame] and sourceData[3])
			end
			if sourceGUID and (pets or not buffsFunc_isPetOrGuard(module.db.data[module.db.nowNum].reaction[ sourceGUID ])) then
				local inList = nil
				for j=1,#list do
					if list[j][1] == sourceGUID then
						inList = true
						break
					end
				end
				if not inList then
					list[#list+1] = {sourceGUID,GetGUID(sourceGUID),"|c"..ExRT.F.classColorByGUID(sourceGUID)}
				end
			end
		end

		table.sort(list,function(a,b) 
			if a[2] == b[2] then
				return a[1] < b[1]
			else
				return a[2] < b[2] 
			end
		end)
		
		for i=1,#list do
			self.L[i] = list[i][3] .. list[i][2] 
			self.LGUID[i] = list[i][1]
		end
		self:Update()
	end
	
	tab.filterFrame:SetScript("OnShow",function()
		UpdateTargetsList(BWInterfaceFrame.tab.tabs[3].filterFrame.sourceScroll,true,BWInterfaceFrame.tab.tabs[3].filterFrame.sourceFriendly:GetChecked(),BWInterfaceFrame.tab.tabs[3].filterFrame.sourceHostile:GetChecked(),BWInterfaceFrame.tab.tabs[3].filterFrame.sourcePets:GetChecked())
		UpdateTargetsList(BWInterfaceFrame.tab.tabs[3].filterFrame.targetScroll,nil,BWInterfaceFrame.tab.tabs[3].filterFrame.targetFriendly:GetChecked(),BWInterfaceFrame.tab.tabs[3].filterFrame.targetHostile:GetChecked(),BWInterfaceFrame.tab.tabs[3].filterFrame.targetPets:GetChecked())
	end)
	
	tab.filterFrame.sourceScroll = ELib:ScrollList(tab.filterFrame):Size(186,320):Point(12,-57)
	tab.filterFrame.sourceScroll.LGUID = {}
	tab.filterFrame.sourceScroll.dontDisable = true
	
	tab.filterFrame.sourceClear = ELib:Button(tab.filterFrame,L.BossWatcherBuffsAndDebuffsFilterClear):Size(190,20):Point(10,-20):OnClick(function ()
		wipe(AurasTab_Variables.FilterSourceGUID)
		AurasTab_Variables.FilterSource = 0x0111
		BWInterfaceFrame.tab.tabs[3].filterFrame.sourceFriendly:SetChecked(true)
		BWInterfaceFrame.tab.tabs[3].filterFrame.sourceHostile:SetChecked(true)
		BWInterfaceFrame.tab.tabs[3].filterFrame.sourcePets:SetChecked(true)
		UpdateTargetsList(BWInterfaceFrame.tab.tabs[3].filterFrame.sourceScroll,true,BWInterfaceFrame.tab.tabs[3].filterFrame.sourceFriendly:GetChecked(),BWInterfaceFrame.tab.tabs[3].filterFrame.sourceHostile:GetChecked(),BWInterfaceFrame.tab.tabs[3].filterFrame.sourcePets:GetChecked())
		BWInterfaceFrame.tab.tabs[3].filterFrame.sourceText:SetText(L.BossWatcherBuffsAndDebuffsFilterNone)
		UpdateBuffPageDB()
		UpdateBuffsPage()
	end)
	tab.filterFrame.sourceText = ELib:Text(tab.filterFrame,L.BossWatcherBuffsAndDebuffsFilterNone,11):Size(180,16):Point(15,-40):Color()
	
	tab.filterFrame.sourceFriendly = ELib:Check(tab.filterFrame,L.BossWatcherBuffsAndDebuffsFilterFriendly,true):Point("TOPLEFT",tab.filterFrame.sourceScroll,"BOTTOMLEFT",-1,-6)
	tab.filterFrame.sourceHostile = ELib:Check(tab.filterFrame,L.BossWatcherBuffsAndDebuffsFilterHostile,true):Point("TOPLEFT",tab.filterFrame.sourceFriendly,"BOTTOMLEFT",0,-5)
	tab.filterFrame.sourcePets = ELib:Check(tab.filterFrame,L.BossWatcherBuffsAndDebuffsFilterPets,true):Point("TOPLEFT",tab.filterFrame.sourceHostile,"BOTTOMLEFT",0,-5)
	tab.filterFrame.sourceFriendly:SetScript("OnClick",function ()
		UpdateTargetsList(BWInterfaceFrame.tab.tabs[3].filterFrame.sourceScroll,true,BWInterfaceFrame.tab.tabs[3].filterFrame.sourceFriendly:GetChecked(),BWInterfaceFrame.tab.tabs[3].filterFrame.sourceHostile:GetChecked(),BWInterfaceFrame.tab.tabs[3].filterFrame.sourcePets:GetChecked())
		if BWInterfaceFrame.tab.tabs[3].filterFrame.sourceFriendly:GetChecked() then
			AurasTab_Variables.FilterSource = bit.bor(AurasTab_Variables.FilterSource,0x0010)
		else
			AurasTab_Variables.FilterSource = bit.band(AurasTab_Variables.FilterSource,0xFF0F)
		end
		if BWInterfaceFrame.tab.tabs[3].filterFrame.sourceHostile:GetChecked() then
			AurasTab_Variables.FilterSource = bit.bor(AurasTab_Variables.FilterSource,0x0001)
		else
			AurasTab_Variables.FilterSource = bit.band(AurasTab_Variables.FilterSource,0xFFF0)
		end
		if BWInterfaceFrame.tab.tabs[3].filterFrame.sourcePets:GetChecked() then
			AurasTab_Variables.FilterSource = bit.bor(AurasTab_Variables.FilterSource,0x0100)
		else
			AurasTab_Variables.FilterSource = bit.band(AurasTab_Variables.FilterSource,0xF0FF)
		end
		UpdateBuffPageDB()
		UpdateBuffsPage()
	end)
	tab.filterFrame.sourceHostile:SetScript("OnClick",tab.filterFrame.sourceFriendly:GetScript("OnClick"))
	tab.filterFrame.sourcePets:SetScript("OnClick",tab.filterFrame.sourceFriendly:GetScript("OnClick"))
	
	function tab.filterFrame.sourceScroll:SetListValue(index)
		if not IsShiftKeyDown() then
			AurasTab_Variables.FilterSourceGUID = {}
		end
		AurasTab_Variables.FilterSourceGUID[ self.LGUID[index] ] = true
		AurasTab_Variables.FilterSource = bit.bor(AurasTab_Variables.FilterSource,0x1000)
		BWInterfaceFrame.tab.tabs[3].filterFrame.sourceText:SetText(buffsFunc_GetNamesFromArray(AurasTab_Variables.FilterSourceGUID))
		UpdateBuffPageDB()
		UpdateBuffsPage()
	end
	
	function tab.filterFrame.sourceScroll:HoverListValue(isHover,index)
		if not isHover then
			GameTooltip_Hide()
		else
			local owner,ownerGUID,thisGUID
			if ExRT.F.Pets then
				owner = ExRT.F.Pets:getOwnerNameByGUID(self.LGUID[index],GetPetsDB())
			end		
			if VExRT.BossWatcher.GUIDs then
				thisGUID = self.LGUID[index]
				if ExRT.F.Pets then
					ownerGUID = ExRT.F.Pets:getOwnerGUID(self.LGUID[index],GetPetsDB())
				end
			end
			if owner or thisGUID then
				GameTooltip:SetOwner(self,"ANCHOR_CURSOR")
				if thisGUID then
					GameTooltip:AddLine(GUIDtoText("%s",thisGUID))
				end
				if owner then
					GameTooltip:AddLine( format(L.BossWatcherPetOwner,owner) .. GUIDtoText(" (%s)",ownerGUID) )
				end
				GameTooltip:Show()
			end
		end
	end

	tab.filterFrame.targetScroll = ELib:ScrollList(tab.filterFrame):Size(186,320):Point(212,-57)
	tab.filterFrame.targetScroll.LGUID = {}
	tab.filterFrame.targetScroll.dontDisable = true
	
	tab.filterFrame.targetClear = ELib:Button(tab.filterFrame,L.BossWatcherBuffsAndDebuffsFilterClear):Size(190,20):Point(210,-20):OnClick(function ()
		wipe(AurasTab_Variables.FilterDestGUID)
		AurasTab_Variables.FilterDest = 0x0111
		BWInterfaceFrame.tab.tabs[3].filterFrame.targetFriendly:SetChecked(true)
		BWInterfaceFrame.tab.tabs[3].filterFrame.targetHostile:SetChecked(true)
		BWInterfaceFrame.tab.tabs[3].filterFrame.targetPets:SetChecked(true)
		UpdateTargetsList(BWInterfaceFrame.tab.tabs[3].filterFrame.targetScroll,nil,BWInterfaceFrame.tab.tabs[3].filterFrame.targetFriendly:GetChecked(),BWInterfaceFrame.tab.tabs[3].filterFrame.targetHostile:GetChecked(),BWInterfaceFrame.tab.tabs[3].filterFrame.targetPets:GetChecked())
		BWInterfaceFrame.tab.tabs[3].filterFrame.targetText:SetText(L.BossWatcherBuffsAndDebuffsFilterNone)
		UpdateBuffPageDB()
		UpdateBuffsPage()
	end)
	tab.filterFrame.targetText = ELib:Text(tab.filterFrame,L.BossWatcherBuffsAndDebuffsFilterNone,11):Size(180,16):Point(215,-40):Color()
	
	tab.filterFrame.targetFriendly = ELib:Check(tab.filterFrame,L.BossWatcherBuffsAndDebuffsFilterFriendly,true):Point("TOPLEFT",tab.filterFrame.targetScroll,"BOTTOMLEFT",-1,-6)
	tab.filterFrame.targetHostile = ELib:Check(tab.filterFrame,L.BossWatcherBuffsAndDebuffsFilterHostile,true):Point("TOPLEFT",tab.filterFrame.targetFriendly,"BOTTOMLEFT",0,-5)
	tab.filterFrame.targetPets = ELib:Check(tab.filterFrame,L.BossWatcherBuffsAndDebuffsFilterPets,true):Point("TOPLEFT",tab.filterFrame.targetHostile,"BOTTOMLEFT",0,-5)
	tab.filterFrame.targetFriendly:SetScript("OnClick",function ()
		UpdateTargetsList(BWInterfaceFrame.tab.tabs[3].filterFrame.targetScroll,nil,BWInterfaceFrame.tab.tabs[3].filterFrame.targetFriendly:GetChecked(),BWInterfaceFrame.tab.tabs[3].filterFrame.targetHostile:GetChecked(),BWInterfaceFrame.tab.tabs[3].filterFrame.targetPets:GetChecked())
		if BWInterfaceFrame.tab.tabs[3].filterFrame.targetFriendly:GetChecked() then
			AurasTab_Variables.FilterDest = bit.bor(AurasTab_Variables.FilterDest,0x0010)
		else
			AurasTab_Variables.FilterDest = bit.band(AurasTab_Variables.FilterDest,0xFF0F)
		end
		if BWInterfaceFrame.tab.tabs[3].filterFrame.targetHostile:GetChecked() then
			AurasTab_Variables.FilterDest = bit.bor(AurasTab_Variables.FilterDest,0x0001)
		else
			AurasTab_Variables.FilterDest = bit.band(AurasTab_Variables.FilterDest,0xFFF0)
		end
		if BWInterfaceFrame.tab.tabs[3].filterFrame.targetPets:GetChecked() then
			AurasTab_Variables.FilterDest = bit.bor(AurasTab_Variables.FilterDest,0x0100)
		else
			AurasTab_Variables.FilterDest = bit.band(AurasTab_Variables.FilterDest,0xF0FF)
		end
		UpdateBuffPageDB()
		UpdateBuffsPage()
	end)
	tab.filterFrame.targetHostile:SetScript("OnClick",tab.filterFrame.targetFriendly:GetScript("OnClick"))
	tab.filterFrame.targetPets:SetScript("OnClick",tab.filterFrame.targetFriendly:GetScript("OnClick"))

	function tab.filterFrame.targetScroll:SetListValue(index)
		if not IsShiftKeyDown() then
			AurasTab_Variables.FilterDestGUID = {}
		end
		AurasTab_Variables.FilterDestGUID[ self.LGUID[index] ] = true
		AurasTab_Variables.FilterDest = bit.bor(AurasTab_Variables.FilterDest,0x1000)
		BWInterfaceFrame.tab.tabs[3].filterFrame.targetText:SetText(buffsFunc_GetNamesFromArray(AurasTab_Variables.FilterDestGUID))
		UpdateBuffPageDB()
		UpdateBuffsPage()
	end
	
 	tab.filterFrame.targetScroll.HoverListValue = tab.filterFrame.sourceScroll.HoverListValue
	
	local function BuffsFilterFrameChkHover(self)
		local i = self.frameNum
		if i == 4 then
			return
		end
		local sList = module.db.buffsFilters[i][-2]
		if not sList then
			sList = {}
			for sid,_ in pairs(module.db.buffsFilters[i]) do
				if sid > 0 then
					sList[#sList + 1] = sid
				end
			end
		end
		if #sList == 0 then
			return
		end
		local sList2 = {}
		if #sList <= 35 then
			for j=1,#sList do
				local sID,_,sT=GetSpellInfo(sList[j])
				if sID then
					sList2[#sList2 + 1] = "|T"..sT..":0|t |cffffffff"..sID.."|r"
				end
			end
		else
			local count = 1
			for j=1,#sList do
				local sID,_,sT=GetSpellInfo(sList[j])
				if sID then
					if not sList2[count] then
						sList2[count] = {"|T"..sT..":0|t |cffffffff"..sID.."|r"}
					elseif not sList2[count].right then
						sList2[count].right = "|cffffffff"..sID.."|r |T"..sT..":0|t"
						count = count + 1
					end
				end
			end
		end
		ELib.Tooltip.Show(self,"ANCHOR_LEFT",L.BossWatcherFilterTooltip..":",unpack(sList2))
	end
	local function BuffsFilterFrameResetEditBoxBuff(i)
		local resetTable = {}
		for sID,_ in pairs(module.db.buffsFilters[i]) do
			if sID > 0 then
				resetTable[#resetTable + 1] = sID
			end
		end
		for _,sID in ipairs(resetTable) do
			module.db.buffsFilters[i][sID] = nil
		end
	end
	
	local function BuffsFilterFrameChkSpecialClick(self)
		if self:GetChecked() then
			module.db.buffsFilterStatus[self._i] = true
		else
			module.db.buffsFilterStatus[self._i] = nil
		end
		UpdateBuffPageDB()
		UpdateBuffsPage()
	end
	
	tab.filterFrame.chkSpecial = {}
	for i=1,#module.db.buffsFilters do
		local topPosFix = -20-(i-1)*25
		if i > 4 then
			topPosFix = -20-(i+3)*25 
		elseif i > 3 then
			topPosFix = -20-(i+1)*25
		end
		tab.filterFrame.chkSpecial[i] = ELib:Check(tab.filterFrame,module.db.buffsFilters[i][-1]):Point(410,topPosFix)
		tab.filterFrame.chkSpecial[i]._i = i
		tab.filterFrame.chkSpecial[i]:SetScript("OnClick",BuffsFilterFrameChkSpecialClick)
		tab.filterFrame.chkSpecial[i].hover = CreateFrame("Frame",nil,tab.filterFrame)
		tab.filterFrame.chkSpecial[i].hover:SetPoint("TOPLEFT",430,topPosFix)
		tab.filterFrame.chkSpecial[i].hover:SetSize(125,25)
		tab.filterFrame.chkSpecial[i].hover:SetScript("OnEnter",BuffsFilterFrameChkHover)
		tab.filterFrame.chkSpecial[i].hover:SetScript("OnLeave",GameTooltip_Hide)
		tab.filterFrame.chkSpecial[i].hover.frameNum = i

		tab.filterFrame.chkSpecial[i].text:SetWidth(130)
		tab.filterFrame.chkSpecial[i].text:SetJustifyH("LEFT")
	end
	
	local BuffsFilterFrameSceludedUpdateDB = nil
	local function BuffsFilterFrameSceludedUpdateDBFunc()
		BuffsFilterFrameSceludedUpdateDB = nil
		UpdateBuffPageDB()
		UpdateBuffsPage()
	end
	
	tab.filterFrame.chkSpecial[3].ebox = ELib:MultiEdit(tab.filterFrame.chkSpecial[3]):Size(145,42):Point("TOPLEFT",tab.filterFrame.chkSpecial[3],"BOTTOMLEFT",3,-6):OnChange(function (self,isUser)
		local text = self:GetText()
		if isUser then
			if text:match("[^0-9\n]") then
				text = string.gsub(text,"[^0-9\n]","")
			end
			self:SetText(text)
		else
			return
		end
		BuffsFilterFrameResetEditBoxBuff(3)
		local lines = {strsplit("\n", text)}
		local isExists = nil
		for i=1,#lines do
			lines[i] = tonumber(lines[i]) or 0
			module.db.buffsFilters[3][ lines[i] ] = true
			isExists = true
		end		
		if isExists then
			if BWInterfaceFrame.tab.tabs[3].filterFrame.chkSpecial[3]:GetChecked() then
				BuffsFilterFrameSceludedUpdateDB = ExRT.F.ScheduleETimer(BuffsFilterFrameSceludedUpdateDB, BuffsFilterFrameSceludedUpdateDBFunc, 0.8)
			end
		end
	end)
	tab.filterFrame.chkSpecial[3].ebox.ScrollBar:Hide()
	local function BuffsFilterFrameEditBoxOnEnter(self)
		GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
		GameTooltip:SetText(L.BossWatcherBuffsAndDebuffsFilterEditBoxTooltip)
		GameTooltip:Show()
	end
	tab.filterFrame.chkSpecial[3].ebox.EditBox:SetScript("OnEnter",BuffsFilterFrameEditBoxOnEnter)
	tab.filterFrame.chkSpecial[3].ebox.EditBox:SetScript("OnLeave",GameTooltip_Hide)
	
	tab.filterFrame.chkSpecial[4].ebox = ELib:MultiEdit(tab.filterFrame.chkSpecial[4]):Size(145,42):Point("TOPLEFT",tab.filterFrame.chkSpecial[4],"BOTTOMLEFT",3,-6):OnChange(function (self,isUser)
		local text = self:GetText()
		for key,val in pairs(module.db.buffsFilters[4]) do
			if key ~= -1 then
				module.db.buffsFilters[4][key] = nil
			end
		end
		local lines = {strsplit("\n", text)}
		for i=1,#lines do
			if lines[i] ~= "" then
				module.db.buffsFilters[4][ strlower(lines[i]) ] = true
			end
		end		
		if BWInterfaceFrame.tab.tabs[3].filterFrame.chkSpecial[4]:GetChecked() then
			BuffsFilterFrameSceludedUpdateDB = ExRT.F.ScheduleETimer(BuffsFilterFrameSceludedUpdateDB, BuffsFilterFrameSceludedUpdateDBFunc, 0.8)
		end
	end)
	tab.filterFrame.chkSpecial[4].ebox.ScrollBar:Hide()
	tab.filterFrame.chkSpecial[4].ebox.EditBox:SetScript("OnEnter",BuffsFilterFrameEditBoxOnEnter)
	tab.filterFrame.chkSpecial[4].ebox.EditBox:SetScript("OnLeave",GameTooltip_Hide)
	
	tab.filterButton = ELib:Button(tab,L.BossWatcherBuffsAndDebuffsFilterFilter):Size(100,20):Point(10,-8):OnClick(function ()
		BWInterfaceFrame.tab.tabs[3].filterFrame:Show()
	end)
	
	tab.filterText = ELib:Text(tab):Size(700,20):Point("LEFT",tab.filterButton,"RIGHT",10,0):Color():Shadow()
	CreateFilterText()
	
	tab.filterTextHoverFrame = CreateFrame("Frame",nil,tab)
	tab.filterTextHoverFrame:SetPoint("LEFT",tab.filterButton,"RIGHT",10,0)
	tab.filterTextHoverFrame:SetSize(700,20)
	tab.filterTextHoverFrame:SetScript("OnEnter",function (self)
		local textRegion = BWInterfaceFrame.tab.tabs[3].filterText
		if not textRegion:IsTruncated() then
			return
		end
		GameTooltip:SetOwner(self,"ANCHOR_LEFT")
		GameTooltip:SetText(textRegion:GetText(), nil, nil, nil, nil, true)
		GameTooltip:Show()
	end)
	tab.filterTextHoverFrame:SetScript("OnLeave",function (self)
		GameTooltip_Hide()
	end)

	tab:SetScript("OnShow",function (self)
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			UpdateBuffPageDB()
			self.lastFightID = BWInterfaceFrame.nowFightID
		end
		UpdateBuffsPage()
	end)
	
	
	
	
	
	---- Mobs Info & Switch
	tab = BWInterfaceFrame.tab.tabs[4]
	tabName = BWInterfaceFrame_Name.."MobsTab"
	
	local Enemy_GUIDnow = nil
	
	tab.targetsList = ELib:ScrollList(tab):Point(14,-76):Size(282,513)
	tab.targetsList.GUIDs = {}
	
	tab.DecorationLine = CreateFrame("Frame",nil,tab)
	tab.DecorationLine:SetPoint("TOPLEFT",tab.targetsList,"TOPRIGHT",0,2)
	tab.DecorationLine:SetPoint("RIGHT",tab,-5,0)
	tab.DecorationLine:SetHeight(37)
	tab.DecorationLine.texture = tab.DecorationLine:CreateTexture(nil, "BACKGROUND")
	tab.DecorationLine.texture:SetAllPoints()
	tab.DecorationLine.texture:SetColorTexture(1,1,1,1)
	tab.DecorationLine.texture:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)
	
	tab.selectedMob = ELib:Text(tab.DecorationLine,"",11):Size(530,12):Point(5,-5):Color():Top()
	tab.infoTabs = ELib:Tabs(tab,0,
		L.BossWatcherSwitchBySpell,
		L.BossWatcherSwitchByTarget,
		L.BossWatcherDamageSwitchTabInfo
	):Size(530,465):Point(295,-111):SetTo(1)
	tab.infoTabs:SetBackdropBorderColor(0,0,0,0)
	tab.infoTabs:SetBackdropColor(0,0,0,0)
	
	tab.switchSpellBox = ELib:MultiEdit(tab.infoTabs.tabs[1]):Size(540,440):Point(13,-10):Hyperlinks()
	tab.switchTargetBox = ELib:MultiEdit(tab.infoTabs.tabs[2]):Size(540,440):Point(13,-10)
	tab.infoBoxText = ELib:Text(tab.infoTabs.tabs[3],L.BossWatcherDamageSwitchTabInfoNoInfo,12):Size(540,440):Point(13,-13):Top():Color()
	
	tab.toDamageButton = ELib:Button(tab.infoTabs,L.BossWatcherShowDamageToTarget):Size(548,20):Point("BOTTOMLEFT",tab.targetsList,"BOTTOMRIGHT",8,-2):OnClick(function (self)
		if not Enemy_GUIDnow then
			return
		end
		DamageTab_ShowDamageToTarget(Enemy_GUIDnow)
	end)
	
	function tab.targetsList:SetListValue(index)
		local destGUID = self.GUIDs[index]
		
		Enemy_GUIDnow = destGUID
		BWInterfaceFrame.tab.tabs[4].toDamageButton:SetEnabled(true)
		
		wipe(reportData[4][1])
		wipe(reportData[4][2])
		wipe(reportData[4][3])
		
		local _time = timestampToFightTime(module.db.nowData.damage_seen[destGUID])
		local fight_dur = module.db.data[module.db.nowNum].encounterEnd - module.db.data[module.db.nowNum].encounterStart
		
		BWInterfaceFrame.tab.tabs[4].selectedMob:SetText(GetGUID(destGUID).." "..date("%M:%S", _time )..GUIDtoText(" (%s)",destGUID))
		
		_time = _time / fight_dur
		
		local textResult = ""
		local textResult2 = ""
		if module.db.nowData.switch[destGUID] then
			local switchTable = {}

			for sourceGUID,sourceData in pairs(module.db.nowData.switch[destGUID][1]) do
				if ExRT.F.GetUnitTypeByGUID(sourceGUID) == 0 then
					table.insert(switchTable,{GetGUID(sourceGUID),timestampToFightTime(sourceData[1]),sourceGUID,sourceData[2]})
				end
			end
			table.sort(switchTable,function(a,b) return a[2] < b[2] end)
			if #switchTable > 0 then
				textResult = L.BossWatcherReportCast.." [" .. date("%M:%S", switchTable[1][2] ) .."]:|n"
				reportData[4][1][1] = GetGUID(destGUID).." > ".. L.BossWatcherReportCast.." [" .. date("%M:%S", switchTable[1][2] ) .."]:"
				for i=1,#switchTable do
					local spellName = GetSpellInfo(switchTable[i][4] or 0)
					textResult = textResult ..i..". ".."|c".. ExRT.F.classColorByGUID(switchTable[i][3]).. switchTable[i][1] .. GUIDtoText(" <%s>",switchTable[i][3]) .. "|r (".. format("%.3f",switchTable[i][2]-switchTable[1][2])..", |Hspell:"..(switchTable[i][4] or 0).."|h"..(spellName or "?").."|h)"
					reportData[4][1][#reportData[4][1]+1] = i..". "..switchTable[i][1] .. "(" .. format("%.3f",switchTable[i][2]-switchTable[1][2])..", "..GetSpellLink(switchTable[i][4] or 0)..")"
					if i ~= #switchTable then
						textResult = textResult .. "|n"
					end
				end
				textResult = textResult .. "\n\n"
			end
			
			wipe(switchTable)
			for sourceGUID,sourceData in pairs(module.db.nowData.switch[destGUID][2]) do
				if ExRT.F.GetUnitTypeByGUID(sourceGUID) == 0 then
					table.insert(switchTable,{GetGUID(sourceGUID),sourceData[1] - module.db.data[module.db.nowNum].encounterStart,sourceGUID,sourceData[2]})
				end
			end
			table.sort(switchTable,function(a,b) return a[2] < b[2] end)
			if #switchTable > 0 then
				textResult2 = textResult2 .. L.BossWatcherReportSwitch.." [" .. date("%M:%S", switchTable[1][2] ) .."]:|n"
				reportData[4][2][1] = GetGUID(destGUID).." > ".. L.BossWatcherReportSwitch.." [" .. date("%M:%S", switchTable[1][2] ) .."]:"
				for i=1,#switchTable do
					textResult2 = textResult2 ..i..". ".. "|c".. ExRT.F.classColorByGUID(switchTable[i][3]).. switchTable[i][1] .. GUIDtoText(" <%s>",switchTable[i][3]) .. "|r (".. format("%.3f",switchTable[i][2]-switchTable[1][2])..")"
					reportData[4][2][#reportData[4][2]+1] = i..". ".. switchTable[i][1].."(" .. format("%.3f",switchTable[i][2]-switchTable[1][2])..")"
					if i ~= #switchTable then
						textResult2 = textResult2 .. "|n"
					end
				end
			end
		end		
		BWInterfaceFrame.tab.tabs[4].switchSpellBox:SetText(textResult):ToTop()
		BWInterfaceFrame.tab.tabs[4].switchTargetBox:SetText(textResult2):ToTop()
		
		--> Other Info
		textResult = ""
		reportData[4][3][1] = GetGUID(destGUID)..":"
		for i=1,#module.db.nowData.dies do
			if module.db.nowData.dies[i][1]==destGUID then
				textResult = textResult .. L.BossWatcherDamageSwitchTabInfoRIP..": ".. date("%M:%S", timestampToFightTime(module.db.nowData.dies[i][3]) ) .. date(" (%H:%M:%S)", module.db.nowData.dies[i][3] ) .. "\n"
				reportData[4][3][#reportData[4][3]+1] = L.BossWatcherDamageSwitchTabInfoRIP..": ".. date("%M:%S", timestampToFightTime(module.db.nowData.dies[i][3]) ) .. date(" (%H:%M:%S)", module.db.nowData.dies[i][3] )
				for j=1,#module.db.raidTargets do
					if module.db.raidTargets[j] == module.db.nowData.dies[i][4] then
						textResult = textResult .. L.BossWatcherMarkOnDeath..": |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_".. j  ..":0|t ".. string.gsub( L["raidtargeticon"..j] , "[{}]", "" ) .."\n"
						reportData[4][3][#reportData[4][3]+1] = L.BossWatcherMarkOnDeath..": "..string.gsub( L["raidtargeticon"..j] , "[{}]", "" )
						break
					end
				end
			end
		end
		local mobID = ExRT.F.GUIDtoID(destGUID)
		local mobSpawnID = 0
		do
			local spawnString = destGUID:match("%-([^%-]+)$") or "0"
			mobSpawnID = tonumber(spawnString, 16) or 0
		end
		textResult = textResult .. "Mob ID: ".. mobID .. "\n"
		textResult = textResult .. "Spawn ID: ".. mobSpawnID .. "\n"
		textResult = textResult .. "GUID: ".. destGUID .. "\n"
		reportData[4][3][#reportData[4][3]+1] = "Mob ID: ".. mobID
		reportData[4][3][#reportData[4][3]+1] = "Spawn ID: ".. mobSpawnID
		reportData[4][3][#reportData[4][3]+1] = "GUID: ".. destGUID
		
		if module.db.nowData.maxHP[destGUID] then
			textResult = textResult .. "Max Health: ".. module.db.nowData.maxHP[destGUID] .. "\n"
			reportData[4][3][#reportData[4][3]+1] = "Max Health:: ".. module.db.nowData.maxHP[destGUID]
		end
		
		BWInterfaceFrame.tab.tabs[4].infoBoxText:SetText(textResult)
	end
	
	function tab.targetsList:HoverListValue(isHover,index,hoveredObj)
		if not isHover then
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:Hide()
			BWInterfaceFrame.timeLineFrame.timeLine.lifeUnderLine:Hide()
			GameTooltip_Hide()
		else
			local mobGUID = self.GUIDs[index]
			local mobSeen = timestampToFightTime( module.db.nowData.damage_seen[mobGUID] )
			local fight_dur = module.db.data[module.db.nowNum].encounterEnd - module.db.data[module.db.nowNum].encounterStart
			local _time = mobSeen / fight_dur
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:SetPoint("TOPLEFT",BWInterfaceFrame.timeLineFrame.timeLine,"BOTTOMLEFT",BWInterfaceFrame.timeLineFrame.width*_time,0)
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:Show()
			
			local dieTime = 1
			for i=1,#module.db.nowData.dies do
				if module.db.nowData.dies[i][1]==mobGUID then
					dieTime = timestampToFightTime(module.db.nowData.dies[i][3]) / fight_dur
					break
				end
			end
			BWInterfaceFrame.timeLineFrame.timeLine.lifeUnderLine:SetPoint(_time,dieTime)
			
			GameTooltip:SetOwner(self,"ANCHOR_CURSOR")
			if VExRT.BossWatcher.GUIDs then
				GameTooltip:AddLine(GUIDtoText("%s",mobGUID))
			end

			if hoveredObj.text:IsTruncated() then
				GameTooltip:AddLine(GetGUID(mobGUID) .. date(" %M:%S", mobSeen) )
			end
			GameTooltip:Show()
		end
	end

	local function UpdateMobsPage()
		table.wipe(BWInterfaceFrame.tab.tabs[4].targetsList.L)
		table.wipe(BWInterfaceFrame.tab.tabs[4].targetsList.GUIDs)
		
		wipe(reportData[4][1])
		wipe(reportData[4][2])
		wipe(reportData[4][3])
		
		local mobsList = {}
		for mobGUID,mobData in pairs(module.db.nowData.damage) do
			local mobID = ExRT.F.GUIDtoID(mobGUID)
			if ExRT.F.GetUnitInfoByUnitFlag(module.db.data[module.db.nowNum].reaction[mobGUID],2) == 512 and (mobID ~= 76933 or VExRT.BossWatcher.showPrismatic) then	--76933 = Mage T100 talent Prismatic Crystal fix
				mobsList[#mobsList+1] = {GetGUID(mobGUID),module.db.nowData.damage_seen[mobGUID],mobGUID}
			end
		end
		table.sort(mobsList,function(a,b) return a[2] < b[2] end)
		for i=1,#mobsList do
			BWInterfaceFrame.tab.tabs[4].targetsList.L[i] =  date("%M:%S ", timestampToFightTime(mobsList[i][2]))..mobsList[i][1]
			BWInterfaceFrame.tab.tabs[4].targetsList.GUIDs[i] = mobsList[i][3]
		end
		BWInterfaceFrame.tab.tabs[4].targetsList:Update()
		
		Enemy_GUIDnow = nil
		BWInterfaceFrame.tab.tabs[4].toDamageButton:SetEnabled(false)
	end

	tab:SetScript("OnShow",function (self)
		BWInterfaceFrame.timeLineFrame:ClearAllPoints()
		BWInterfaceFrame.timeLineFrame:SetPoint("TOP",self,"TOP",0,-10)
		BWInterfaceFrame.timeLineFrame:Show()
		
		BWInterfaceFrame.report:Show()
		
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			self.targetsList.selected = nil
			UpdateMobsPage()
			self.lastFightID = BWInterfaceFrame.nowFightID
		end
	end)
	tab:SetScript("OnHide",function (self)
		BWInterfaceFrame.timeLineFrame:Hide()
		BWInterfaceFrame.report:Hide()
	end)
	
	
	
	
	---- Spells
	tab = BWInterfaceFrame.tab.tabs[5]
	tabName = BWInterfaceFrame_Name.."SpellsTab"
	
	local SpellsTab_Variables = {
		Type = 1,	--1 - friendly 2 - hostile 3 - spells count, 4 - summons
		Filter = {},
		FilterByTarget = {},
	}
	local tab5 = BWInterfaceFrame.tab.tabs[5]

	tab.playersList = ELib:ScrollList(tab):Size(190,449):Point(14,-140)
	tab.playersCastsList = ELib:ScrollList(tab):Size(637,494):Point(214,-95)
	tab.playersList.IndexToGUID = {}
	tab.playersCastsList.IndexToGUID = {}
	
	local function SpellsTab_ReloadSpells()
		local selected = tab5.playersList.selected
		if selected then
			tab5.playersList:SetListValue(selected)
		end
	end
	
	local SpellsTab_UpdateFilterHeader = nil
	local function SpellsTab_UpdateFilter(text)
		SpellsTab_UpdateFilterHeader = nil
		wipe(SpellsTab_Variables.Filter)
		wipe(SpellsTab_Variables.FilterByTarget)
		if text:find("^target!?[=~]") or text:find("^!?[=~]") then
			text = text:gsub("^target","")
			local filterType = 1
			if text:find("^!=") then
				filterType = 3
			elseif text:find("^!~") then
				filterType = 4
			elseif text:find("^~") then
				filterType = 2
			end
			local targetsStr = text:match("^!?[=~](.+)")
			if targetsStr then
				local targets = {strsplit(";",targetsStr)}
				for i=1,#targets do
					SpellsTab_Variables.FilterByTarget[ targets[i] ] = filterType
				end
			end
			SpellsTab_ReloadSpells()		
			return
		end
		local spells = {strsplit(";",text)}
		for i=1,#spells do
			if tonumber(spells[i]) then
				spells[i] = tonumber(spells[i])
			end
			SpellsTab_Variables.Filter[spells[i]] = true
		end
		SpellsTab_ReloadSpells()
	end
	tab.filterEditBox = ELib:Edit(tab):Size(639,16):Point(213,-73):Tooltip(L.BossWatcherSpellsFilterTooltip..'|n'..L.BossWatcherBySpell..': "|cffffffff774;Multi-shot;105809|r" '..OR_CAPS:lower()..' "|cffffffffFlash Heal|r"|n'..L.BossWatcherByTarget..': "|cfffffffftarget=Ragnaros;The Lich King;Lei Shen|r" '..OR_CAPS:lower()..' "|cffffffff=Garrosh|r" '..OR_CAPS:lower()..' "|cffffffff~illi|r"'):OnChange(function (self)
		local text = self:GetText()
		if text == "" then
			ExRT.F.CancelTimer(SpellsTab_UpdateFilterHeader)
			wipe(SpellsTab_Variables.Filter)
			wipe(SpellsTab_Variables.FilterByTarget)
			SpellsTab_ReloadSpells()
			return
		end
		SpellsTab_UpdateFilterHeader = ExRT.F.ScheduleETimer(SpellsTab_UpdateFilterHeader,SpellsTab_UpdateFilter,0.8,text)
	end)
	
	function tab.playersList:HoverListValue(isHover,index)
		if not isHover then
			GameTooltip_Hide()
		else
			GameTooltip:SetOwner(self,"ANCHOR_CURSOR")
			if VExRT.BossWatcher.GUIDs then
				GameTooltip:AddLine(GUIDtoText("%s",self.IndexToGUID[index]))
			end
			GameTooltip:Show()
		end
	end
	function tab.playersCastsList:HoverListValue(isHover,index,hoveredObj)
		if not isHover then
			GameTooltip_Hide()
			ELib.Tooltip:HideAdd()
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:Hide()
			BWInterfaceFrame.timeLineFrame.timeLine:HideLabels()
		else
			local data = self.IndexToGUID[index]
			GameTooltip:SetOwner(hoveredObj or self,"ANCHOR_BOTTOMLEFT")
			GameTooltip:SetHyperlink(data[1])
			GameTooltip:Show()
			
			if hoveredObj.text:IsTruncated() then
				ELib.Tooltip:Add(nil,{hoveredObj.text:GetText()},false,true)
			end
			
			if data[2] then
				if not data[5] then
					BWInterfaceFrame.timeLineFrame.timeLine.arrow:SetPoint("TOPLEFT",BWInterfaceFrame.timeLineFrame.timeLine,"BOTTOMLEFT",BWInterfaceFrame.timeLineFrame.width*data[2],0)
					BWInterfaceFrame.timeLineFrame.timeLine.arrow:Show()
				else
					local count = 0
					for i=1,#data[5] do
						local pos = data[5][i]
						if pos < 0 and data[6] then
							pos = -pos
							count = count + 1
							BWInterfaceFrame.timeLineFrame.timeLine:AddLabel(count,pos,data[2] == pos and 1 or 2)
						elseif pos >= 0 then
							count = count + 1
							BWInterfaceFrame.timeLineFrame.timeLine:AddLabel(count,pos,data[2] == pos and 1 or nil)
						end
					end
				end
			end
			
			if self.redTime and data[4] then
				local diff = data[4] - self.redTime
				local isNegative = diff < 0 and -diff
				ELib.Tooltip:Add(nil,{format("%s%d:%06.3f (%.3f %s)",isNegative and "-" or "",(isNegative or diff) / 60,(isNegative or diff) % 60,diff,SECONDS)},false,true)
			end
		end
	end
	
	local function SpellsTab_FindInWord(haystack,needle)
		if not haystack or not needle then
			return
		end
		needle = needle:lower()
		haystack = haystack:lower()
		if haystack:find(needle) then
			return true
		end
		return false
	end
	
	function tab.playersList:SetListValue(index)
		local playersCastsList = tab5.playersCastsList
		
		table.wipe(playersCastsList.L)
		table.wipe(playersCastsList.IndexToGUID)
		
		local selfGUID = self.IndexToGUID[index]
		local fight_dur = module.db.data[module.db.nowNum].encounterEnd - module.db.data[module.db.nowNum].encounterStart
		
		local SpellsTab_isFriendly = SpellsTab_Variables.Type == 1
		
		if SpellsTab_Variables.Type == 4 then
			for i,data in ipairs(module.db.nowData.summons) do
				if not selfGUID or selfGUID == data[1] then
					local spellName,_,spellTexture = GetSpellInfo(data[3])
					local time_ = timestampToFightTime(data[4])
					local sourceName= "|c"..ExRT.F.classColorByGUID(data[1])..GetGUID( data[1] )..GUIDtoText(" <%s>",data[1]).."|r "
					local destName= "|c"..ExRT.F.classColorByGUID(data[2])..GetGUID( data[2] )..GUIDtoText(" <%s>",data[2]).."|r "
					
					playersCastsList.L[#playersCastsList.L + 1] = format("[%02d:%06.3f] ",time_ / 60,time_ % 60)..sourceName.." "..ACTION_SPELL_SUMMON.." "..destName..L.BossWatcherByText..format(" %s%s",spellTexture and "|T"..spellTexture..":0|t " or "",spellName or "???")
					playersCastsList.IndexToGUID[#playersCastsList.IndexToGUID + 1] = {"spell:"..data[3],time_ / fight_dur,data[3],time_}
				end
			end
		elseif SpellsTab_Variables.Type ~= 3 then
			local spells = {}
			if selfGUID then
				for i,PlayerCastData in ipairs(module.db.nowData.cast[selfGUID]) do
					spells[#spells + 1] = {PlayerCastData[1],PlayerCastData[2],PlayerCastData[3],PlayerCastData[4]}
				end
			else
				local reaction = SpellsTab_isFriendly and 256 or 512
				for GUID,dataGUID in pairs(module.db.nowData.cast) do
					if ExRT.F.GetUnitInfoByUnitFlag(module.db.data[module.db.nowNum].reaction[GUID],2) == reaction then
						for i,PlayerCastData in ipairs(dataGUID) do
							spells[#spells + 1] = {PlayerCastData[1],PlayerCastData[2],PlayerCastData[3],PlayerCastData[4],GUID}
						end
					end
				end
				sort(spells,function(a,b) return a[1]<b[1] end)
			end
			local spellToTime = {}
	
			local isSpellsFilterEnabled = ExRT.F.table_len(SpellsTab_Variables.Filter) > 0
			local isTargetsFilterEnabled = ExRT.F.table_len(SpellsTab_Variables.FilterByTarget) > 0
			for i,data in ipairs(spells) do
				local spellID = data[2]
				local spellName,_,spellTexture = GetSpellInfo(spellID)
				local time_ = timestampToFightTime(data[1])
				local isCast = ""
				if data[3] == 2 then
					isCast = L.BossWatcherBeginCasting.." "
				end
				local sourceName = ""
				if data[5] then
					sourceName = "|c"..ExRT.F.classColorByGUID(data[5])..GetGUID( data[5] )..GUIDtoText(" <%s>",data[5]).."|r "
				end
				
				local isMustBeAdded = true
				if isSpellsFilterEnabled then
					isMustBeAdded = false
					for filterSource,_ in pairs(SpellsTab_Variables.Filter) do
						if (type(filterSource) == "number" and filterSource == spellID) or
						   (type(filterSource) ~= "number" and spellName and string.find(strlower(spellName),strlower(filterSource))) then
							isMustBeAdded = true
							break
						end
					end
				elseif isTargetsFilterEnabled then
					isMustBeAdded = false
					for filterSource,filterType in pairs(SpellsTab_Variables.FilterByTarget) do
						if (filterType == 2 and SpellsTab_FindInWord( GetGUID( data[4] ),filterSource )) or 
							(filterType == 3 and not (GetGUID( data[4] ) == filterSource)) or 
							(filterType == 4 and not SpellsTab_FindInWord( GetGUID( data[4] ),filterSource )) or 
							(filterType == 1 and (GetGUID( data[4] ) == filterSource)) then
							isMustBeAdded = true
							break
						end
					end
				end
				if isMustBeAdded then
					spellToTime[spellID] = spellToTime[spellID] or {}
					spellToTime[spellID][#spellToTime[spellID] + 1] = time_ / fight_dur * (data[3] == 2 and -1 or 1)

					playersCastsList.L[#playersCastsList.L + 1] = format("[%02d:%06.3f] ",time_ / 60,time_ % 60)..sourceName..isCast..format("%s%s",spellTexture and "|T"..spellTexture..":0|t " or "",spellName or "???")
					playersCastsList.IndexToGUID[#playersCastsList.IndexToGUID + 1] = {"spell:"..spellID,time_ / fight_dur,spellID,time_,spellToTime[spellID],data[3] == 2}
					
					if data[4] and data[4] ~= "" then
						playersCastsList.L[#playersCastsList.L] = playersCastsList.L[#playersCastsList.L] .. " > |c"..ExRT.F.classColorByGUID(data[4])..GetGUID( data[4] )..GUIDtoText(" <%s>",data[4]).."|r"
					end
					
				end
			end
		else
			local spells = {}
			for GUID,dataGUID in pairs(module.db.nowData.cast) do
				if not selfGUID or selfGUID == GUID then
					for i,PlayerCastData in ipairs(module.db.nowData.cast[GUID]) do
						if PlayerCastData[3] ~= 2 then
							local spellID = PlayerCastData[2]
							local inTable = ExRT.F.table_find(spells,spellID,1)
							if not inTable then
								inTable = #spells + 1
								spells[inTable] = {spellID,0}
							end
							spells[inTable][2] = spells[inTable][2] + 1
						end
					end
				end
			end
			sort(spells,function(a,b)return a[2]>b[2] end)
			for i,data in ipairs(spells) do
				local spellName,_,spellTexture = GetSpellInfo(data[1])
				
				playersCastsList.L[#playersCastsList.L + 1] = data[2].." "..format("%s%s",spellTexture and "|T"..spellTexture..":0|t " or "",spellName or "???")
				playersCastsList.IndexToGUID[#playersCastsList.IndexToGUID + 1] = {"spell:"..data[1],nil,data[1]}
			end
		end
		
		playersCastsList:Update()		
	end
	function tab.playersCastsList:SetListValue(index,button)
		self.selected = nil
		if button == "RightButton" then
			if self.redTime or not self.IndexToGUID[index][4] then
				self.redTime = nil
				self.redIndex = nil
			else
				self.redTime = self.IndexToGUID[index][4]
				self.redIndex = index
			end
			self:Update()
			return
		end
		self.redTime = nil
		self.redIndex = nil
		
		local sID = self.IndexToGUID[index][3]
		if self.redSpell == sID then
			self.redSpell = nil
		else
			self.redSpell = sID
		end
		self:Update()
	end
	function tab.playersCastsList:UpdateAdditional(scrollPos)
		for j=1,#self.List do
			local index = self.List[j].index
			if self.redSpell and index and self.IndexToGUID[index] and self.IndexToGUID[index][3] == self.redSpell then
				self.List[j].text:SetTextColor(1,0.2,0.2,1)
			elseif self.redIndex and self.redIndex == index then
				self.List[j].text:SetTextColor(0.6,1,0.2,1)
			else
				self.List[j].text:SetTextColor(1,1,1,1)
			end
		end
	end	
	
	local function UpdateSpellsPage()
		table.wipe(tab5.playersList.L)
		table.wipe(tab5.playersList.IndexToGUID)
		table.wipe(tab5.playersCastsList.L)
		table.wipe(tab5.playersCastsList.IndexToGUID)
		local playersListTable = {}
		if SpellsTab_Variables.Type ~= 4 then
			local SpellsTab_isFriendly = SpellsTab_Variables.Type == 1
			for sourceGUID,sourceData in pairs(module.db.nowData.cast) do
				if not ExRT.F.table_find(playersListTable,sourceGUID,1) and (SpellsTab_Variables.Type == 3 or (SpellsTab_isFriendly and ExRT.F.GetUnitInfoByUnitFlag(module.db.data[module.db.nowNum].reaction[sourceGUID],1) == 1024) or (not SpellsTab_isFriendly and ExRT.F.GetUnitInfoByUnitFlag(module.db.data[module.db.nowNum].reaction[sourceGUID],2) == 512)) then
					playersListTable[#playersListTable + 1] = {sourceGUID,GetGUID( sourceGUID ),"|c"..ExRT.F.classColorByGUID(sourceGUID)}
				end
			end
		else
			for _,data in pairs(module.db.nowData.summons) do
				local sourceGUID = data[1]
				if not ExRT.F.table_find(playersListTable,sourceGUID,1) then
					playersListTable[#playersListTable + 1] = {sourceGUID,GetGUID( sourceGUID ),"|c"..ExRT.F.classColorByGUID(sourceGUID)}
				end 
			end
		end
		table.sort(playersListTable,function (a,b) return a[2] < b[2] end)
		tab5.playersList.L[1] = L.BossWatcherAll
		for i,playersListTableData in ipairs(playersListTable) do
			tab5.playersList.L[i+1] = playersListTableData[3]..playersListTableData[2]
			tab5.playersList.IndexToGUID[i+1] = playersListTableData[1]
		end
		
		tab5.playersList.selected = 1
		
		tab5.playersCastsList.redTime = nil
		tab5.playersCastsList.redIndex = nil
		
		tab5.playersList:Update()
		tab5.playersList:SetListValue(1)
		--tab5.playersCastsList:Update()
	end
	
	tab.chkFriendly = ELib:Radio(tab,L.BossWatcherFriendly,true):Point(15,-75):OnClick(function(self) 
		self:SetChecked(true)
		tab5.chkEnemy:SetChecked(false)
		tab5.chkSpellsCount:SetChecked(false)
		tab5.chkSpellsSummons:SetChecked(false)
		SpellsTab_Variables.Type = 1
		UpdateSpellsPage()
	end)
	tab.chkEnemy = ELib:Radio(tab,L.BossWatcherHostile):Point(15,-90):OnClick(function(self) 
		self:SetChecked(true)
		tab5.chkFriendly:SetChecked(false)
		tab5.chkSpellsCount:SetChecked(false)
		tab5.chkSpellsSummons:SetChecked(false)
		SpellsTab_Variables.Type = 2
		UpdateSpellsPage()
	end)
	tab.chkSpellsCount = ELib:Radio(tab,L.BossWatcherSpellsCount):Point(15,-105):OnClick(function(self) 
		self:SetChecked(true)
		tab5.chkFriendly:SetChecked(false)
		tab5.chkEnemy:SetChecked(false)
		tab5.chkSpellsSummons:SetChecked(false)
		SpellsTab_Variables.Type = 3
		UpdateSpellsPage()
	end)
	tab.chkSpellsSummons = ELib:Radio(tab,SUMMONS):Point(15,-120):OnClick(function(self) 
		self:SetChecked(true)
		tab5.chkFriendly:SetChecked(false)
		tab5.chkEnemy:SetChecked(false)
		tab5.chkSpellsCount:SetChecked(false)
		SpellsTab_Variables.Type = 4
		UpdateSpellsPage()
	end)
	
	
	function SpellsPage_GetCastsNumber(guidsTable,spellID)
		local count = 0
		local spellName = GetSpellInfo(spellID)
		for GUID,dataGUID in pairs(module.db.nowData.cast) do
			if not guidsTable or guidsTable[GUID] then
				for i,PlayerCastData in ipairs(dataGUID) do
					if PlayerCastData[3] ~= 2 and (PlayerCastData[2] == spellID or (spellName and spellName == GetSpellInfo(PlayerCastData[2]))) then
						count = count + 1
					end
				end
			end
		end
		return count
	end

	tab:SetScript("OnShow",function (self)
		BWInterfaceFrame.timeLineFrame:ClearAllPoints()
		BWInterfaceFrame.timeLineFrame:SetPoint("TOP",self,"TOP",0,-10)
		BWInterfaceFrame.timeLineFrame:Show()
		
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			UpdateSpellsPage()
			self.lastFightID = BWInterfaceFrame.nowFightID
		end
	end)
	tab:SetScript("OnHide",function (self)
		BWInterfaceFrame.timeLineFrame:Hide()
	end)
	
	
	
	
	---- Power; HP, Powers Graphs
	tab = BWInterfaceFrame.tab.tabs[6]
	tabName = BWInterfaceFrame_Name.."PowerTab"
	
	local PowerTab_isFriendly = true
	local GraphsTab_Variables = {
		DestTable = {},
		LastGUID = nil,
		LastDoEnemy = nil,
		LastDoSpell = nil,
		PowerTypeNow = 0,
		PowerLastName = nil,
		HealthTypeNow = 1,
		HealthLastName = nil,
	}
	
	
	tab.DecorationLine = CreateFrame("Frame",nil,tab)
	tab.DecorationLine:SetPoint("TOPLEFT",tab,"TOPLEFT",3,-9)
	tab.DecorationLine:SetPoint("RIGHT",tab,-3,0)
	tab.DecorationLine:SetHeight(20)
	tab.DecorationLine.texture = tab.DecorationLine:CreateTexture(nil, "BACKGROUND")
	tab.DecorationLine.texture:SetAllPoints()
	tab.DecorationLine.texture:SetColorTexture(1,1,1,1)
	tab.DecorationLine.texture:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)
	
	tab.graphicsTab = ELib:Tabs(tab,0,
		POWER_GAINS,
		L.BossWatcherTabGraphics..": "..L.BossWatcherGraphicsHealth,
		L.BossWatcherTabGraphics..": "..L.BossWatcherGraphicsPower
	):Size(850,555):Point("TOP",0,-29):SetTo(1)
	tab.graphicsTab:SetBackdropBorderColor(0,0,0,0)
	tab.graphicsTab:SetBackdropColor(0,0,0,0)
	
	function tab.graphicsTab:buttonAdditionalFunc()
		local tab = BWInterfaceFrame.tab.tabs[6]
		if self.selected == 1 then
			tab.graphicsTab.dropDown:Hide()
			tab.graph:Hide()
			tab.graphicsTab.powerDropDown:Hide()
			tab.graphicsTab.healthDropDown:Hide()
			tab.graphicsTab.bySpellDropDown:Hide()
			tab.graphicsTab.byTargetDropDown:Hide()
			tab.graphicsTab.stepSlider:Hide()
		else
			tab.graphicsTab.dropDown:Show()
			tab.graph:Show()
			tab.graphicsTab.stepSlider:Show()
		end
	end
	
	tab.graphicsTab.dropDown = ELib:DropDown(tab.graphicsTab,220,10):Size(220):Point(15,-10)
	tab.graph = ExRT.lib.CreateGraph(tab.graphicsTab,760,485,"TOP",0,-50,true)
	tab.graph.axisXisTime = true

	tab.graphicsTab.powerDropDown = ELib:DropDown(tab.graphicsTab,200,ExRT.F.table_len(module.db.energyLocale)):Size(220):Point(560,-10):SetText(L.BossWatcherSelectPower..module.db.energyLocale[0])
	tab.graphicsTab.healthDropDown = ELib:DropDown(tab.graphicsTab,200,2):Size(220):Point(560,-10):SetText(L.BossWatcherSelectPower..(HEALTH or "Health"))
	tab.graphicsTab.bySpellDropDown = ELib:DropDown(tab.graphicsTab,250,10):Size(145):Point(540,-10):SetText(L.BossWatcherTabPlayersSpells):Tooltip(L.BossWatcherGraphicsHoldShift)
	tab.graphicsTab.byTargetDropDown = ELib:DropDown(tab.graphicsTab,250,10):Size(145):Point(695,-10):SetText(L.BossWatcherGraphicsTargets)

	tab.graphicsTab.stepSlider = ELib:Slider(tab.graphicsTab,L.BossWatcherGraphicsStep):Size(250):Point(270,-15):Range(1,1):OnChange(function (self,value)
		value = ExRT.F.Round(value)
		self.tooltipText = value
		self:tooltipReload(self)
		if self.disableUpdateFix then
			return
		end
		BWInterfaceFrame.tab.tabs[6].graph.step = value
		BWInterfaceFrame.tab.tabs[6].graph:Reload()
	end)
	tab.graphicsTab.stepSlider:SetScript("OnMinMaxChanged",function (self)
		local _min,_max = self:GetMinMaxValues()
		self.Low:SetText(_min)
		self.High:SetText(_max)
	end)
	
	tab.graph:SetScript("OnLeave",function ()
		GameTooltip_Hide()
	end)
	
	tab.graphZoomDropDown = CreateFrame("Frame", BWInterfaceFrame_Name.."GraphZoomDropDown", nil, "UIDropDownMenuTemplate")
	function tab.graph:Zoom(start,ending)
		local zoomList = {
			{
				text = L.BossWatcherGraphZoom, 
				isTitle = true, 
				notCheckable = true, 
				notClickable = true 
			},
			{
				text = L.BossWatcherGraphZoomOnlyGraph,
				notCheckable = true,
				func = function()
					self.ZoomMinX = start
					self.ZoomMaxX = ending
					self:Reload()
				end,
			},
		}
		if module.db.data[module.db.nowNum].improved then
			zoomList[#zoomList + 1] = {
				text = L.BossWatcherGraphZoomGlobal,
				notCheckable = true,
				func = function()
					self.ZoomMinX = start
					self.ZoomMaxX = ending
					self:Reload()
					SegmentsPage_ImprovedSelect(start,ending,true)
				end,
			}
		end
		zoomList[#zoomList + 1] = {
			text = L.BossWatcherSelectFightClose,
			notCheckable = true,
			func = CloseDropDownMenus_fix,
		}
		EasyMenu(zoomList, BWInterfaceFrame.tab.tabs[6].graphZoomDropDown, "cursor", 10 , -15, "MENU")
	end
	
	local function GraphGetFightMax()
		local i = 0
		for sec,data in pairs(module.db.data[module.db.nowNum].graphData) do
			i=max(sec,i)
		end
		return i
	end
	local function GraphHealthSelect(_,name)
		GraphsTab_Variables.HealthLastName = name
		
		local currTab = BWInterfaceFrame.tab.tabs[6]
		
		local graphTypeName = GraphsTab_Variables.HealthTypeNow == 1 and "health" or "absorbs"
	
		local myGraphData = {}
		local maxFight = GraphGetFightMax()
		for sec,data in pairs(module.db.data[module.db.nowNum].graphData) do
			local health = data[name] and data[name][graphTypeName] or 0
			local maxHP = data[name] and data[name].hpmax or 0
			local maxHPtext = ""
			if maxHP > 0 then
				maxHPtext = format(" [%.1f%%]",(health or 0) / maxHP * 100)
			end
			local comment = (data[name] and data[name].name or "") .. maxHPtext
			if comment == "" then
				comment = nil
			end
			health = health or 0
			myGraphData[#myGraphData + 1] = {sec,health,format("%d:%02d",sec/60,sec%60),nil,comment}
		end
		table.sort(myGraphData,function(a,b)return a[1]<b[1] end)
		myGraphData.name = name
		if IsShiftKeyDown() and type(currTab.graph.data) == "table" and #currTab.graph.data > 0 then
			currTab.graph.data[#currTab.graph.data + 1] = myGraphData
		else
			currTab.graph.data = {myGraphData}
		end
		currTab.graph:Reload()
		
		currTab.graphicsTab.stepSlider:SetMinMaxValues(1,max(1,maxFight))
		currTab.graphicsTab.dropDown:SetText(name)	
		ELib:DropDownClose()
	end
	local function GraphPowerSelect(_,name)
		GraphsTab_Variables.PowerLastName = name
		
		local currTab = BWInterfaceFrame.tab.tabs[6]
	
		local myGraphData = {}
		local maxFight = GraphGetFightMax()
		for sec,data in pairs(module.db.data[module.db.nowNum].graphData) do
			local dataPower = data[name]
			if dataPower and dataPower[GraphsTab_Variables.PowerTypeNow] then
				myGraphData[#myGraphData + 1] = {sec,dataPower[GraphsTab_Variables.PowerTypeNow],format("%d:%02d",sec/60,sec%60),nil,data[name].name}
			else
				myGraphData[#myGraphData + 1] = {sec,0,format("%d:%02d",sec/60,sec%60),nil,dataPower and dataPower.name}
			end
		end
		table.sort(myGraphData,function(a,b)return a[1]<b[1] end)
		myGraphData.name = name
		if IsShiftKeyDown() and type(currTab.graph.data) == "table" and #currTab.graph.data > 0 then
			currTab.graph.data[#currTab.graph.data + 1] = myGraphData
		else
			currTab.graph.data = {myGraphData}
		end
		currTab.graph:Reload()
		
		currTab.graphicsTab.stepSlider:SetMinMaxValues(1,max(1,maxFight))
		currTab.graphicsTab.dropDown:SetText(name)	
		ELib:DropDownClose()
	end

	function tab.graphicsTab.byTargetDropDown.additionalToggle(self)
		local tabNow = BWInterfaceFrame.tab.tabs[6].graphicsTab.selected
		for i=2,#self.List do
			self.List[i].checkState = GraphsTab_Variables.DestTable[self.List[i].arg1]
			if tabNow == 1 then
				self.List[i].isHidden = (self.List[i].isEnemy and GraphsTab_Variables.LastDoEnemy) or (not self.List[i].isEnemy and not GraphsTab_Variables.LastDoEnemy)
			end
		end
	end

	local function GraphTabLoad()
		ELib:DropDownClose()
		local currTab = BWInterfaceFrame.tab.tabs[6]
		currTab.graph.data = {}
		currTab.graph:Reload()
		currTab.graphicsTab.dropDown:SetText(L.BossWatcherGraphicsSelect)	
		table.wipe(currTab.graphicsTab.dropDown.List)
		currTab.graphicsTab.stepSlider:SetMinMaxValues(1,1)
		currTab.graphicsTab.stepSlider:SetValue(1)
		currTab.graphicsTab.dropDown.Lines = 10
		currTab.graphicsTab.dropDown.tooltip = L.BossWatcherGraphicsHoldShift
		
		currTab.graphicsTab.powerDropDown:Hide()
		currTab.graphicsTab.healthDropDown:Hide()
		currTab.graphicsTab.bySpellDropDown:Hide()
		currTab.graphicsTab.byTargetDropDown:Hide()
		
		GraphsTab_Variables.LastGUID = nil
		GraphsTab_Variables.LastDoEnemy = nil
		GraphsTab_Variables.LastDoSpell = nil
	end
	local GraphTab_SpecialUnits = {
		["_total"] = "*1",
		["boss1"] = "*2",
		["boss2"] = "*3",
		["boss3"] = "*4",
		["boss4"] = "*5",
		["boss5"] = "*6",
		["target"] = "*7",
		["focus"] = "*8",
	}
	tab.graphicsTab.tabs[2]:SetScript("OnShow",function (self)
		GraphTabLoad()
		BWInterfaceFrame.tab.tabs[6].graphicsTab.healthDropDown:Show()
		if not module.db.data[module.db.nowNum].graphData then
			return
		end
		local units = {}
		for i,data in pairs(module.db.data[module.db.nowNum].graphData) do
			for sourceName,_ in pairs(data) do
				if not ExRT.F.table_find(units,sourceName) then
					units[#units+1] = sourceName
				end
			end
		end
		for i=1,#units do
			local info = {}
			BWInterfaceFrame.tab.tabs[6].graphicsTab.dropDown.List[i] = info
			local unitGUID = ExRT.F.table_find2(module.db.data[module.db.nowNum].raidguids,units[i])
			info.text = (unitGUID and "|c"..ExRT.F.classColorByGUID(unitGUID) or "")..units[i]
			info.arg1 = units[i]
			info.func = GraphHealthSelect
			info.justifyH = "CENTER" 
			info._sort = GraphTab_SpecialUnits[ units[i] ] or units[i]
		end
		table.sort(BWInterfaceFrame.tab.tabs[6].graphicsTab.dropDown.List,function(a,b)return a._sort < b._sort end)
	end)
	tab.graphicsTab.tabs[3]:SetScript("OnShow",function (self)
		GraphTabLoad()
		BWInterfaceFrame.tab.tabs[6].graphicsTab.powerDropDown:Show()
		if not module.db.data[module.db.nowNum].graphData then
			return
		end
		local units = {}
		for i,data in pairs(module.db.data[module.db.nowNum].graphData) do
			for sourceName,_ in pairs(data) do
				if not ExRT.F.table_find(units,sourceName) then
					units[#units+1] = sourceName
				end
			end
		end
		for i=1,#units do
			local info = {}
			BWInterfaceFrame.tab.tabs[6].graphicsTab.dropDown.List[i] = info
			local unitGUID = ExRT.F.table_find2(module.db.data[module.db.nowNum].raidguids,units[i])
			info.text = (unitGUID and "|c"..ExRT.F.classColorByGUID(unitGUID) or "")..units[i]
			info.arg1 = units[i]
			info.func = GraphPowerSelect
			info.justifyH = "CENTER" 
			info._sort = GraphTab_SpecialUnits[ units[i] ] or units[i]
		end
		table.sort(BWInterfaceFrame.tab.tabs[6].graphicsTab.dropDown.List,function(a,b)return a._sort < b._sort end)
	end)
	
	local function GraphPowerSelectPowerType(_,powerID,powerName)
		GraphsTab_Variables.PowerTypeNow = powerID
		if GraphsTab_Variables.PowerLastName then
			GraphPowerSelect(nil,GraphsTab_Variables.PowerLastName)
		end
		BWInterfaceFrame.tab.tabs[6].graphicsTab.powerDropDown:SetText(L.BossWatcherSelectPower..module.db.energyLocale[powerID])
		ELib:DropDownClose()
	end
	
	for powerID,powerName in pairs(module.db.energyLocale) do
		local info = {}
		BWInterfaceFrame.tab.tabs[6].graphicsTab.powerDropDown.List[ #BWInterfaceFrame.tab.tabs[6].graphicsTab.powerDropDown.List + 1 ] = info
		info.text = powerName
		info.arg1 = powerID
		info.arg2 = powerName
		info.func = GraphPowerSelectPowerType
	end
	table.sort(BWInterfaceFrame.tab.tabs[6].graphicsTab.powerDropDown.List,function(a,b)return a.arg1 < b.arg1 end)
	
	local function GraphPowerSelectHealthType(_,arg)
		GraphsTab_Variables.HealthTypeNow = arg
		if GraphsTab_Variables.HealthLastName then
			GraphHealthSelect(nil,GraphsTab_Variables.HealthLastName)
		end
		local text
		if arg == 1 then
			text = HEALTH
		else
			text = ACTION_SPELL_MISSED_ABSORB
		end
		BWInterfaceFrame.tab.tabs[6].graphicsTab.healthDropDown:SetText(L.BossWatcherSelectPower..text)
		ELib:DropDownClose()
	end	
	tab.graphicsTab.healthDropDown.List[1] = {text = HEALTH,arg1 = 1,func = GraphPowerSelectHealthType}
	tab.graphicsTab.healthDropDown.List[2] = {text = ACTION_SPELL_MISSED_ABSORB,arg1 = 2,func = GraphPowerSelectHealthType}
	
	tab.graphicsTab:buttonAdditionalFunc()
	
	
	
	tab.sourceList = ELib:ScrollList(tab.graphicsTab.tabs[1]):Size(190,365):Point(14,-45)
	tab.powerTypeList = ELib:ScrollList(tab.graphicsTab.tabs[1]):Size(190,136):Point("TOPLEFT",tab.sourceList,"BOTTOMLEFT",0,-8)
	tab.sourceList.IndexToGUID = {}
	tab.powerTypeList.IndexToGUID = {}
	
	local function EnergyLineOnEnter(self)
		if self.spellID then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetHyperlink("spell:"..self.spellID)
			GameTooltip:Show()
		end
	end
	
	tab.spells = {}
	for i=1,20 do
		tab.spells[i] = CreateFrame("Frame",nil,tab.graphicsTab.tabs[1])
		tab.spells[i]:SetPoint("TOPLEFT",220,-10-28*(i-1))
		tab.spells[i]:SetSize(420,28)
		
		tab.spells[i].texture = tab.spells[i]:CreateTexture(nil,"BACKGROUND")
		tab.spells[i].texture:SetSize(24,24)
		tab.spells[i].texture:SetPoint("TOPLEFT",0,-2)
		
		tab.spells[i].spellName = ELib:Text(tab.spells[i],"",13):Size(225,28):Point(26,0):Color():Shadow()
		tab.spells[i].amount = ELib:Text(tab.spells[i],"",12):Size(90,28):Point(250,0):Color():Shadow()
		tab.spells[i].count = ELib:Text(tab.spells[i],"",12):Size(80,28):Point(340,0):Color():Shadow()
		
		tab.spells[i]:SetScript("OnEnter",EnergyLineOnEnter)
		tab.spells[i]:SetScript("OnLeave",GameTooltip_Hide)
	end
	
	local function EnergyClearLines()
		for i=1,#BWInterfaceFrame.tab.tabs[6].spells do
			BWInterfaceFrame.tab.tabs[6].spells[i]:Hide()
		end
	end
	
	function tab.sourceList:SetListValue(index)
		local tab6 = BWInterfaceFrame.tab.tabs[6]
		table.wipe(tab6.powerTypeList.L)
		table.wipe(tab6.powerTypeList.IndexToGUID)

		local sourceGUID = tab6.sourceList.IndexToGUID[index]
		tab6.sourceGUID = sourceGUID
		local powerList = {}
		for powerType,powerData in pairs(module.db.nowData.power[sourceGUID]) do
			powerList[#powerList + 1] = {powerType,module.db.energyLocale[ powerType ] or L.BossWatcherEnergyTypeUnknown..powerType}
		end
		table.sort(powerList,function (a,b) return a[1] < b[1] end)
		for i,powerData in ipairs(powerList) do
			tab6.powerTypeList.L[i] = powerData[2]
			tab6.powerTypeList.IndexToGUID[i] = powerData[1]
		end
		
		--EnergyClearLines()
		tab6.powerTypeList.selected = 1
		tab6.powerTypeList:Update()
		tab6.powerTypeList:SetListValue(1)
	end
	function tab.powerTypeList:SetListValue(index)
		local powerType = BWInterfaceFrame.tab.tabs[6].powerTypeList.IndexToGUID[index]
		local sourceGUID = BWInterfaceFrame.tab.tabs[6].sourceGUID
		
		local spellList = {
			{nil,L.BossWatcherReportTotal,"",0,0},
		}
		for spellID,spellData in pairs(module.db.nowData.power[sourceGUID][powerType]) do
			local spellName,_,spellTexture = GetSpellInfo(spellID)
			spellList[#spellList + 1] = {spellID,spellName,spellTexture,spellData[1],spellData[2]}
			spellList[1][4] = spellList[1][4] + spellData[1]
			spellList[1][5] = spellList[1][5] + spellData[2]
		end
		table.sort(spellList,function (a,b) return a[4] > b[4] end)
		EnergyClearLines()
		if #spellList > 1 then
			for i,spellData in ipairs(spellList) do
				local line = BWInterfaceFrame.tab.tabs[6].spells[i]
				if line then
					line.texture:SetTexture(spellData[3])
					line.spellName:SetText(spellData[2])
					line.amount:SetText(spellData[4])
					line.count:SetText(spellData[5].." |4"..L.BossWatcherEnergyOnce1..":"..L.BossWatcherEnergyOnce2..":"..L.BossWatcherEnergyOnce1)
					line.spellID = spellData[1]
					line:Show()
				end
			end
		end
	end

	local function UpdatePowerPage()
		table.wipe(BWInterfaceFrame.tab.tabs[6].sourceList.L)
		table.wipe(BWInterfaceFrame.tab.tabs[6].sourceList.IndexToGUID)
		table.wipe(BWInterfaceFrame.tab.tabs[6].powerTypeList.L)
		table.wipe(BWInterfaceFrame.tab.tabs[6].powerTypeList.IndexToGUID)
		local sourceListTable = {}
		for sourceGUID,sourceData in pairs(module.db.nowData.power) do
			if (PowerTab_isFriendly and ExRT.F.GetUnitInfoByUnitFlag(module.db.data[module.db.nowNum].reaction[sourceGUID],1) == 1024) or (not PowerTab_isFriendly and ExRT.F.GetUnitInfoByUnitFlag(module.db.data[module.db.nowNum].reaction[sourceGUID],2) == 512) then
				sourceListTable[#sourceListTable + 1] = {sourceGUID,GetGUID( sourceGUID ),"|c"..ExRT.F.classColorByGUID(sourceGUID)}
			end
		end
		table.sort(sourceListTable,function (a,b) return a[2] < b[2] end)
		for i,sourceData in ipairs(sourceListTable) do
			BWInterfaceFrame.tab.tabs[6].sourceList.L[i] = sourceData[3]..sourceData[2]
			BWInterfaceFrame.tab.tabs[6].sourceList.IndexToGUID[i] = sourceData[1]
		end
		
		BWInterfaceFrame.tab.tabs[6].sourceList.selected = nil
		BWInterfaceFrame.tab.tabs[6].powerTypeList.selected = nil
		
		BWInterfaceFrame.tab.tabs[6].sourceList:Update()
		BWInterfaceFrame.tab.tabs[6].powerTypeList:Update()
		EnergyClearLines()
	end
	
	tab.chkFriendly = ELib:Radio(tab.graphicsTab.tabs[1],L.BossWatcherFriendly,true):Point(15,-10):OnClick(function(self) 
		self:SetChecked(true)
		BWInterfaceFrame.tab.tabs[6].chkEnemy:SetChecked(false)
		PowerTab_isFriendly = true
		UpdatePowerPage()
	end)
	tab.chkEnemy = ELib:Radio(tab.graphicsTab.tabs[1],L.BossWatcherHostile):Point(15,-25):OnClick(function(self) 
		self:SetChecked(true)
		BWInterfaceFrame.tab.tabs[6].chkFriendly:SetChecked(false)
		PowerTab_isFriendly = nil
		UpdatePowerPage()
	end)

	tab:SetScript("OnShow",function (self)
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			GraphsTab_Variables.PowerLastName = nil
			GraphsTab_Variables.HealthLastName = nil
			self.lastFightID = BWInterfaceFrame.nowFightID
			UpdatePowerPage()
		end
	end)
	
	
	
	
	---- Tracking
	tab = BWInterfaceFrame.tab.tabs[8]
	tabName = BWInterfaceFrame_Name.."TrackingTab"
	
	local TrackingTab_Variables = {
		EncounterOrder = {
			1778,1785,1787,1798,1786,1783,1788,1794,1777,1800,1784,1795,1799,
			1841,
			1849,
		},
		EncounterNames = {
			[1778] = L.RaidLootT18HCBoss1,	--"Hellfire Assault"
			[1785] = L.RaidLootT18HCBoss2,	--"Iron Reaver"
			[1783] = L.RaidLootT18HCBoss6,	--"Gorefiend"
			[1798] = L.RaidLootT18HCBoss4,	--"Hellfire High Council"
			[1787] = L.RaidLootT18HCBoss3,	--"Kormrok"
			[1786] = L.RaidLootT18HCBoss5,	--"Kilrogg Deadeye"
			[1788] = L.RaidLootT18HCBoss7,	--"Shadow-Lord Iskar"
			[1777] = L.RaidLootT18HCBoss9,	--"Fel Lord Zakuun"
			[1800] = L.RaidLootT18HCBoss10,	--"Xhul'horac"
			[1794] = L.RaidLootT18HCBoss8,	--"Socrethar the Eternal"
			[1784] = L.RaidLootT18HCBoss11,	--"Tyrant Velhari"
			[1795] = L.RaidLootT18HCBoss12,	--"Mannoroth"
			[1799] = L.RaidLootT18HCBoss13,	--"Archimonde"
			
			[1841] = L.S_BossT19N2,	--"Ursoc"
			[1849] = L.S_BossT19S1,	--"Crystal Scorpion"
		},
	}
	
	tab.DecorationLine = CreateFrame("Frame",nil,tab)
	tab.DecorationLine:SetPoint("TOPLEFT",tab,"TOPLEFT",3,-9)
	tab.DecorationLine:SetPoint("RIGHT",tab,-3,0)
	tab.DecorationLine:SetHeight(20)
	tab.DecorationLine.texture = tab.DecorationLine:CreateTexture(nil, "BACKGROUND")
	tab.DecorationLine.texture:SetAllPoints()
	tab.DecorationLine.texture:SetColorTexture(1,1,1,1)
	tab.DecorationLine.texture:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)

	tab.headerTab = ELib:Tabs(tab,0,
		L.BossWatcherTabPlayersSpells,
		L.BossWatcherTabSettings
	):Size(850,555):Point("TOP",0,-29):SetTo(1)
	tab.headerTab:SetBackdropBorderColor(0,0,0,0)
	tab.headerTab:SetBackdropColor(0,0,0,0)
	
	tab.spellsList = ELib:ScrollList(tab.headerTab.tabs[1]):Size(190,540):Point(10,-15)
	tab.targetsList = ELib:ScrollTableList(tab.headerTab.tabs[1],80,0):Size(625,540):Point("TOPLEFT",tab.spellsList,"TOPRIGHT",10,0)
	
	tab.spellsList.D = {}
	
	function tab.spellsList:SetListValue(index)
		wipe(BWInterfaceFrame.tab.tabs[8].targetsList.L)
		
		local L = BWInterfaceFrame.tab.tabs[8].targetsList.L
		
		local prevTime,prevTimeRow = nil
		
		local spellID = self.D[index]
		for i,trackingData in ipairs(module.db.nowData.tracking) do
			if trackingData[6] == spellID then
				local time = timestampToFightTime(trackingData[1])
				local sourceGUID,destGUID = trackingData[2],trackingData[4]
				local sourceRaidTarget,destRaidTarget = nil
				
				if spellID == 185008 then	--Archimonde: Unleashed Torment
					for _,auraData in ipairs(module.db.nowData.auras) do
						if auraData[2] == sourceGUID and auraData[6] == 184964 then
							sourceGUID = auraData[3]
							break
						end 
					end
				elseif spellID == 190399 then	--Archimonde: Mark of the Legion
					for _,auraData in ipairs(module.db.nowData.auras) do
						if auraData[6] == 187050 and auraData[8] == 2 and abs(trackingData[1]-auraData[1])<0.4 then
							sourceGUID = auraData[3]
							break
						end 
					end
				elseif spellID == 182011 then	--Mannoroth: Empowered Mannoroth's Gaze
					local newSourceGUID = nil
					for _,auraData in ipairs(module.db.nowData.auras) do
						if auraData[6] == 182006 and auraData[8] == 2 and auraData[1]>trackingData[1] then
							break
						elseif auraData[6] == 182006 and auraData[8] == 2 and auraData[1]<=trackingData[1] then
							newSourceGUID = auraData[3]
						end
					end
					sourceGUID = newSourceGUID or sourceGUID
				elseif spellID == 181617 then	--Mannoroth: Mannoroth's Gaze
					local newSourceGUID = nil
					for _,auraData in ipairs(module.db.nowData.auras) do
						if auraData[6] == 181597 and auraData[8] == 2 and auraData[1]>trackingData[1] then
							break
						elseif auraData[6] == 181597 and auraData[8] == 2 and auraData[1]<=trackingData[1] then
							newSourceGUID = auraData[3]
						end
					end
					sourceGUID = newSourceGUID or sourceGUID
				elseif spellID == 180161 then	--Tyrant Velhari: Edict of Condemnation
					local newSourceGUID = nil
					for _,auraData in ipairs(module.db.nowData.auras) do
						if auraData[6] == 185241 and auraData[8] == 1 and auraData[1]<=trackingData[1] then
							newSourceGUID = auraData[3]
						elseif auraData[6] == 185241 and auraData[8] == 1 and auraData[1]>trackingData[1] then
							break
						end
					end
					sourceGUID = newSourceGUID or sourceGUID
				elseif spellID == 198099 then	--Ursoc: Barreling Momentum
					local newSourceGUID = nil
					for _,auraData in ipairs(module.db.nowData.auras) do
						if auraData[6] == 198006 and auraData[8] == 1 and auraData[1]<=trackingData[1] then
							newSourceGUID = auraData[3]
						elseif auraData[1]>trackingData[1] then
							break
						end
					end
					sourceGUID = newSourceGUID or sourceGUID
				end
				
				for j=1,#module.db.raidTargets do
					if module.db.raidTargets[j] == trackingData[3] then
						sourceRaidTarget = j
					end
					if module.db.raidTargets[j] == trackingData[5] then
						destRaidTarget = j
					end
				end
			
				local diff = prevTime and (time-prevTime) or 999
				if diff <= 0.05 then
					prevTimeRow = prevTimeRow or prevTime
				else
					if prevTimeRow then
						for j=#L,1,-1 do
							if L[j][3] and L[j][3] < prevTimeRow then
								tinsert(L,j+1,{" "," "})
								break
							elseif L[j][1] == " " then
								break
							end
						end
						L[#L+1] = {" "," "}
					end
					prevTimeRow = nil
				end
				prevTime = time
				
				--{timestamp,sourceGUID,sourceFlags2,destGUID,destFlags2,spellID,amount,overkill,school,blocked,absorbed,critical,multistrike,missType}
				local amountString
				if not trackingData[14] then
					local overkill = trackingData[8] and trackingData[8] > 0 and " ("..ExRT.L.BossWatcherDeathOverKill..": "..ExRT.F.shortNumber(trackingData[8])..") " or ""
					local blocked = trackingData[10] and trackingData[10] > 0 and " ("..ExRT.L.BossWatcherDeathBlocked..": "..ExRT.F.shortNumber(trackingData[10])..") " or ""
					local absorbed = trackingData[11] and trackingData[11] > 0 and " ("..ExRT.L.BossWatcherDeathAbsorbed..": "..ExRT.F.shortNumber(trackingData[11])..") " or ""
					
					amountString = (trackingData[12] and "*" or "")..ExRT.F.shortNumber(trackingData[7] - trackingData[8])..(trackingData[12] and "*" or "")..(trackingData[13] and " ("..ExRT.L.BossWatcherDeathMultistrike..")" or "").." "..overkill..blocked..absorbed
					amountString = strtrim(amountString)
				else
					amountString = "~"..trackingData[14].."~"
				end
				
				L[#L+1] = {date("%M:%S.", time)..format("%03d",time%1*1000),(sourceRaidTarget and ("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_"..sourceRaidTarget..":0|t") or "").."|c".. ExRT.F.classColorByGUID(sourceGUID)..GetGUID(sourceGUID)..GUIDtoText(" [%s]",sourceGUID).."|r > "..(destRaidTarget and ("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_"..destRaidTarget..":0|t") or "").."|c".. ExRT.F.classColorByGUID(destGUID)..GetGUID(destGUID)..GUIDtoText(" [%s]",destGUID).."|r: "..amountString,time}
			end
		end
		local prevTimeText = nil
		for i=1,#L do
			if L[i][1] == prevTimeText then
				prevTimeText = L[i][1]
				L[i][1] = ""
			else
				prevTimeText = L[i][1]
			end
		end
		
		BWInterfaceFrame.tab.tabs[8].targetsList:Update()
	end
	
	function tab.targetsList:HoverListValue(isHover,index,hoveredObj)
		if not isHover then
			GameTooltip_Hide()
		else
			if hoveredObj.text2:IsTruncated() then
				GameTooltip:SetOwner(self,"ANCHOR_CURSOR")
				GameTooltip:AddLine(hoveredObj.text2:GetText() )
				GameTooltip:Show()
			end
		end
	end
	
	local function UpdateTrackingPage()
		wipe(BWInterfaceFrame.tab.tabs[8].targetsList.L)
		wipe(BWInterfaceFrame.tab.tabs[8].spellsList.L)
		wipe(BWInterfaceFrame.tab.tabs[8].spellsList.D)
		local L,D = BWInterfaceFrame.tab.tabs[8].spellsList.L,BWInterfaceFrame.tab.tabs[8].spellsList.D

		for i,trackingData in ipairs(module.db.nowData.tracking) do
			if not ExRT.F.table_find(D,trackingData[6]) then
				D[#D+1] = trackingData[6]
			end
		end
		
		for i=1,#D do
			local spellName,_,spellTexture = GetSpellInfo(D[i])
			L[i] = "|T"..spellTexture..":0|t "..spellName
		end 
		
		BWInterfaceFrame.tab.tabs[8].spellsList:Update()
		BWInterfaceFrame.tab.tabs[8].targetsList:Update()
	end
	
	tab.optionsSpellsList = ELib:ScrollTableList(tab.headerTab.tabs[2],80,20,0,20):Size(650,400):Point(10,-15)
	
	local function UpdateTrackingOptionsPage()
		wipe(BWInterfaceFrame.tab.tabs[8].optionsSpellsList.L)
		local L = BWInterfaceFrame.tab.tabs[8].optionsSpellsList.L
		for spellID,encounterID in pairs(var_trackingDamageSpells) do
			if ExRT.is7 or spellID <= 191000 then				--Remove spells from Legion content at live version
				local spellName,_,spellTexture = GetSpellInfo(spellID)
				spellName = spellName or '???'
				spellTexture = spellTexture or "Interface\\Icons\\INV_MISC_QUESTIONMARK"
				local encounterName = nil
				if type(encounterID)=='number' then
					encounterName = TrackingTab_Variables.EncounterNames[encounterID]
				end
				L[#L+1] = {spellID,"|T"..spellTexture..":0|t",(encounterName and encounterName..": " or "")..spellName,module.db.def_trackingDamageSpells[spellID] and "" or "|TInterface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128:16:16:0:0:256:128:128:144:64:80|t",type(encounterID)=='number' and ExRT.F.table_find(TrackingTab_Variables.EncounterOrder,encounterID) or -1}
			end
		end
		sort(L,function(a,b) if a[5]==b[5] then return a[1]<b[1] else return a[5]>b[5] end end)
		BWInterfaceFrame.tab.tabs[8].optionsSpellsList:Update()
	end
	function tab.optionsSpellsList:AdditionalLineClick()
		local x,y = ExRT.F.GetCursorPos(self)
		local pos = self:GetWidth()-x
		if pos <= 25 and pos > 7 then
			local parent = self.mainFrame
			local i = parent.selected
			if parent.L[i][4] ~= "" then
				local spellID = parent.L[i][1]
				VExRT.BossWatcher.trackingDamageSpells[ spellID ] = nil
				UpdateTrackingDamageSpellsTable()
				UpdateTrackingOptionsPage()
			end
		end
	end
	UpdateTrackingOptionsPage()
	
	tab.optionsEditAddSpell = ELib:Edit(tab.headerTab.tabs[2],6,true):Size(200,20):Point("TOPLEFT",tab.optionsSpellsList,"BOTTOMLEFT",0,-5)
	tab.optionsButtonAddSpell = ELib:Button(tab.headerTab.tabs[2],L.cd2TextAdd):Size(150,20):Point("LEFT",tab.optionsEditAddSpell,"RIGHT",5,0):OnClick(function()
		local tab = BWInterfaceFrame.tab.tabs[8]
		local spellID = tonumber(tab.optionsEditAddSpell:GetText())
		if not spellID then
			return
		end
		tab.optionsEditAddSpell:SetText("")
		
		VExRT.BossWatcher.trackingDamageSpells[ spellID ] = true
		
		UpdateTrackingDamageSpellsTable()
		UpdateTrackingOptionsPage()
	end)
	
	
	tab:SetScript("OnShow",function (self)
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			self.lastFightID = BWInterfaceFrame.nowFightID
			UpdateTrackingPage()
		end
	end)
	
	
	
	
	
	---- Segments
	tab = BWInterfaceFrame.tab.tabs[11]
	tabName = BWInterfaceFrame_Name.."SegmentsTab"

	BWInterfaceFrame.tab.tabs[3].timeSegments = {}
	BWInterfaceFrame.timeLineFrame.timeLine.timeSegments = {}
	local function CreateBuffSegmentBack(i)
		if not BWInterfaceFrame.tab.tabs[3].timeSegments[i] then
		  	BWInterfaceFrame.tab.tabs[3].timeSegments[i] = CreateFrame("Frame",nil,BWInterfaceFrame.tab.tabs[3])
			BWInterfaceFrame.tab.tabs[3].timeSegments[i].texture = BWInterfaceFrame.tab.tabs[3].timeSegments[i]:CreateTexture(nil, "BACKGROUND",0,-5)
			BWInterfaceFrame.tab.tabs[3].timeSegments[i].texture:SetColorTexture(1, 1, 0.5, 0.2)
			BWInterfaceFrame.tab.tabs[3].timeSegments[i].texture:SetAllPoints()
		end
		if not BWInterfaceFrame.timeLineFrame.timeLine.timeSegments[i] then
			BWInterfaceFrame.timeLineFrame.timeLine.timeSegments[i] = BWInterfaceFrame.timeLineFrame.timeLine:CreateTexture(nil, "BACKGROUND",nil,1)
			BWInterfaceFrame.timeLineFrame.timeLine.timeSegments[i]:SetTexture("Interface\\AddOns\\ExRT\\media\\bar9.tga")
			BWInterfaceFrame.timeLineFrame.timeLine.timeSegments[i]:SetVertexColor(0.8, 0.8, 0.8, 1)
		end
	end
	
	local function Segments_UpdateBuffAndTimeLine()
		local count = 0
		for i=1,#BWInterfaceFrame.tab.tabs[11].segmentsList.L do
			if BWInterfaceFrame.tab.tabs[11].segmentsList.C[i] then
				count = count + 1
			end
		end

		if count == #BWInterfaceFrame.tab.tabs[11].segmentsList.L then
			for i=1,#BWInterfaceFrame.tab.tabs[3].timeSegments do
				BWInterfaceFrame.tab.tabs[3].timeSegments[i]:Hide()
			end
			for i=1,#BWInterfaceFrame.timeLineFrame.timeLine.timeSegments do
				BWInterfaceFrame.timeLineFrame.timeLine.timeSegments[i]:Hide()
			end
		else
			local fightDuration = (module.db.data[module.db.nowNum].encounterEnd - module.db.data[module.db.nowNum].encounterStart)
			for i=1,#BWInterfaceFrame.tab.tabs[11].segmentsList.L do
				CreateBuffSegmentBack(i)
				if BWInterfaceFrame.tab.tabs[11].segmentsList.C[i] then
					local timeStart = max(module.db.data[module.db.nowNum].fight[i].timeEx - module.db.data[module.db.nowNum].encounterStart,0)
					local timeEnd = max(module.db.data[module.db.nowNum].fight[i+1] and (module.db.data[module.db.nowNum].fight[i+1].timeEx - module.db.data[module.db.nowNum].encounterStart) or fightDuration,0)
					local startPos = AurasTab_Variables.NameWidth+timeStart/fightDuration*AurasTab_Variables.WorkWidth
					local endPos = AurasTab_Variables.NameWidth+timeEnd/fightDuration*AurasTab_Variables.WorkWidth
					BWInterfaceFrame.tab.tabs[3].timeSegments[i]:SetPoint("TOPLEFT",startPos,-42)
					BWInterfaceFrame.tab.tabs[3].timeSegments[i]:SetSize(max(endPos-startPos,0.5),AurasTab_Variables.TotalLines * 18 + 14)
					BWInterfaceFrame.tab.tabs[3].timeSegments[i]:Show()
					
					BWInterfaceFrame.timeLineFrame.timeLine.timeSegments[i]:Hide()
				else
					BWInterfaceFrame.tab.tabs[3].timeSegments[i]:Hide()
					
					local timeStart = max(module.db.data[module.db.nowNum].fight[i].timeEx - module.db.data[module.db.nowNum].encounterStart,0)
					local timeEnd = max(module.db.data[module.db.nowNum].fight[i+1] and (module.db.data[module.db.nowNum].fight[i+1].timeEx - module.db.data[module.db.nowNum].encounterStart) or fightDuration,0)
					local tlWidth = BWInterfaceFrame.timeLineFrame.timeLine:GetWidth()
					local startPos = timeStart/fightDuration*tlWidth
					local endPos = timeEnd/fightDuration*tlWidth
					BWInterfaceFrame.timeLineFrame.timeLine.timeSegments[i]:SetPoint("TOPLEFT",startPos,0)
					BWInterfaceFrame.timeLineFrame.timeLine.timeSegments[i]:SetSize(max(endPos-startPos,0.5),BWInterfaceFrame.timeLineFrame.timeLine:GetHeight())
					BWInterfaceFrame.timeLineFrame.timeLine.timeSegments[i]:Show()
				end
			end
			for i=(#BWInterfaceFrame.tab.tabs[11].segmentsList.L + 1),#BWInterfaceFrame.tab.tabs[3].timeSegments do
				BWInterfaceFrame.tab.tabs[3].timeSegments[i]:Hide()
			end
			for i=(#BWInterfaceFrame.tab.tabs[11].segmentsList.L + 1),#BWInterfaceFrame.timeLineFrame.timeLine.timeSegments do
				BWInterfaceFrame.timeLineFrame.timeLine.timeSegments[i]:Hide()
			end
		end
	end
	
	function SegmentsPage_UpdateTextures()
		if BWInterfaceFrame.tab.tabs[11].lastFightID ~= module.db.data[module.db.nowNum].fightID then
			for i=1,#BWInterfaceFrame.tab.tabs[3].timeSegments do
				BWInterfaceFrame.tab.tabs[3].timeSegments[i]:Hide()
			end
			for i=1,#BWInterfaceFrame.timeLineFrame.timeLine.timeSegments do
				BWInterfaceFrame.timeLineFrame.timeLine.timeSegments[i]:Hide()
			end
			BWInterfaceFrame.timeLineFrame.timeLine.ImprovedSelectSegment.ResetZoom:Hide()
		end
	end
	
	tab.segmentsText = ELib:Text(tab,L.BossWatcherSegments..":",11):Size(240,15):Point(25,-53):Top():Color():Shadow()
	tab.segmentsList = ExRT.lib.CreateScrollCheckList(tab,nil,15,-70,340,10,true)
	tab.segmentsList:Update()
	function tab.segmentsList:ValueChanged()
		ClearAndReloadData(true)
		local count = 0
		for i=1,#self.L do
			if self.C[i] then
				AddSegmentToData(i)
				count = count + 1
			end
		end
		module.db.lastFightID = module.db.lastFightID + 1
		module.db.data[module.db.nowNum].fightID = module.db.lastFightID
		BWInterfaceFrame.nowFightID = module.db.lastFightID
		BWInterfaceFrame.tab.tabs[11].lastFightID = module.db.lastFightID
		Segments_UpdateBuffAndTimeLine()
	end
	function tab.segmentsList:HoverListValue(isHover,index,obj)
		if not isHover then
			GameTooltip_Hide()
		else
			local textObj = obj.text
			if textObj:IsTruncated() then
				GameTooltip:SetOwner(self,"ANCHOR_CURSOR")
				GameTooltip:AddLine( textObj:GetText() )
				GameTooltip:Show()
			end
		end
	end	
	
	tab.segmentsButtonAll = ELib:Button(tab,L.BossWatcherSegmentSelectAll):Size(130,20):Point(88,-48):OnClick(function ()
		for i=1,#BWInterfaceFrame.tab.tabs[11].segmentsList.L do
			BWInterfaceFrame.tab.tabs[11].segmentsList.C[i] = true
		end
		BWInterfaceFrame.tab.tabs[11].segmentsList:Update()
		BWInterfaceFrame.tab.tabs[11].segmentsList:ValueChanged()
	end)
	tab.segmentsButtonAll = ELib:Button(tab,L.BossWatcherSegmentSelectNothing):Size(130,20):Point(224,-48):OnClick(function ()
		for i=1,#BWInterfaceFrame.tab.tabs[11].segmentsList.L do
			BWInterfaceFrame.tab.tabs[11].segmentsList.C[i] = nil
		end
		BWInterfaceFrame.tab.tabs[11].segmentsList:Update()
		BWInterfaceFrame.tab.tabs[11].segmentsList:ValueChanged()
	end)
	
	tab.segmentsTooltip = ELib:Text(tab,L.BossWatcherSegmentsTooltip,12):Size(465,250):Point(365,-50):Top():Shadow()
	
	tab.segmentsPreSetList = {
		{L.BossWatcherSegmentClear,},
		{L.sooitemst16.." - "..L.sooitemssooboss1,143469,"CHAT_MSG_RAID_BOSS_EMOTE"},
		{L.sooitemst16.." - "..L.sooitemssooboss2,143546,"SPELL_AURA_APPLIED",143546,"SPELL_AURA_REMOVED",143812,"SPELL_AURA_APPLIED",143812,"SPELL_AURA_REMOVED",143955,"SPELL_AURA_APPLIED",143955,"SPELL_AURA_REMOVED"},
		{L.sooitemst16.." - "..L.sooitemssooboss4,144832,"UNIT_SPELLCAST_SUCCEEDED"},
		{L.sooitemst16.." - "..L.sooitemssooboss6,144483,"SPELL_AURA_APPLIED",144483,"SPELL_AURA_REMOVED"},
		{L.sooitemst16.." - "..L.sooitemssooboss7,144302,"UNIT_SPELLCAST_SUCCEEDED",},
		{L.sooitemst16.." - "..L.sooitemssooboss8,143593,"SPELL_AURA_APPLIED",143589,"SPELL_AURA_APPLIED",143594,"SPELL_AURA_APPLIED"},
		{L.sooitemst16.." - "..L.sooitemssooboss9,142842,"UNIT_SPELLCAST_SUCCEEDED",142879,"SPELL_AURA_APPLIED",142879,"SPELL_AURA_REMOVED"},
		{L.sooitemst16.." - "..L.sooitemssooboss11,143440,"SPELL_AURA_APPLIED",143440,"SPELL_AURA_REMOVED"},
		{L.sooitemst16.." - "..L.sooitemssooboss13,71161,"UNIT_DIED",71157,"UNIT_DIED",71156,"UNIT_DIED",71155,"UNIT_DIED",71160,"UNIT_DIED",71154,"UNIT_DIED",71152,"UNIT_DIED",71158,"UNIT_DIED",71153,"UNIT_DIED"},
		{L.sooitemst16.." - "..L.sooitemssooboss14,145235,"UNIT_SPELLCAST_SUCCEEDED",144956,"UNIT_SPELLCAST_SUCCEEDED",146984,"UNIT_SPELLCAST_SUCCEEDED"},

		{L.RaidLootT17Highmaul.." - "..L.RaidLootHighmaulBoss2,156172,"UNIT_SPELLCAST_SUCCEEDED"},
		{L.RaidLootT17Highmaul.." - "..L.RaidLootHighmaulBoss4,159996,"UNIT_SPELLCAST_SUCCEEDED"},			
		{L.RaidLootT17Highmaul.." - "..L.RaidLootHighmaulBoss5,163297,"SPELL_AURA_APPLIED"},			
		{L.RaidLootT17Highmaul.." - "..L.RaidLootHighmaulBoss6,160734,"SPELL_AURA_APPLIED",160734,"SPELL_AURA_REMOVED"},
		{L.RaidLootT17Highmaul.." - "..L.RaidLootHighmaulBoss7,158013,"SPELL_AURA_APPLIED",174057,"SPELL_AURA_APPLIED",158012,"SPELL_AURA_APPLIED",157289,"SPELL_AURA_APPLIED",157964,"SPELL_AURA_APPLIED"},
		{L.RaidLootT17BF.." - "..L.RaidLootBFBoss1,155539,"SPELL_AURA_APPLIED",155539,"SPELL_AURA_REMOVED"},
		{L.RaidLootT17BF.." - "..L.RaidLootBFBoss2,165127,"UNIT_SPELLCAST_SUCCEEDED"},
		{L.RaidLootT17BF.." - "..L.RaidLootBFBoss3,155460,"SPELL_AURA_APPLIED",155458,"SPELL_AURA_APPLIED",155459,"SPELL_AURA_APPLIED"},
		{L.RaidLootT17BF.." - "..L.RaidLootBFBoss4,155493,"SPELL_AURA_REMOVED"},
		{L.RaidLootT17BF.." - "..L.RaidLootBFBoss5,156938,"UNIT_SPELLCAST_SUCCEEDED"},
		{L.RaidLootT17BF.." - "..L.RaidLootBFBoss7,163532,"SPELL_AURA_APPLIED",163532,"SPELL_AURA_REMOVED"},
		{L.RaidLootT17BF.." - "..L.RaidLootBFBoss8,157060,"SPELL_AURA_APPLIED"},
		{L.RaidLootT17BF.." - "..L.RaidLootBFBoss9,156601,"SPELL_AURA_APPLIED"},
		{L.RaidLootT17BF.." - "..L.RaidLootBFBoss10,161346,"UNIT_SPELLCAST_SUCCEEDED"},
	}
	
	local function SegmentsSetPreSet(self,id)
		for i=2,27,2 do
			local j = i / 2
			VExRT.BossWatcher.autoSegments[j] = VExRT.BossWatcher.autoSegments[j] or {}
		
			BWInterfaceFrame.tab.tabs[11].autoSegments[j]:SetText( BWInterfaceFrame.tab.tabs[11].segmentsPreSetList[id][i] or "" )
			VExRT.BossWatcher.autoSegments[j][1] = tonumber( BWInterfaceFrame.tab.tabs[11].segmentsPreSetList[id][i] or "" )
			
			local event = BWInterfaceFrame.tab.tabs[11].segmentsPreSetList[id][i+1]
			VExRT.BossWatcher.autoSegments[j][2] = event
			event = event or "UNIT_SPELLCAST_SUCCEEDED"
			local slider = BWInterfaceFrame.tab.tabs[11].autoSegments[j].slider
			local inList = ExRT.F.table_find(slider.List,event,2)
			slider.text:SetText( slider.List[inList][1] )
			slider.tooltipText = slider.List[inList][2]
			slider.selected = inList
		end
		UpdateNewSegmentEvents()
		ELib:DropDownClose()
	end
	local function SegmentsPreSetButtonEnter(self,tooltip)
		ELib.Tooltip.Show(self,"ANCHOR_LEFT",unpack(tooltip))
	end
	local function SegmentsSetPreSet2(self)
		local list = BWInterfaceFrame.tab.tabs[11].segmentsPreSetList
		for i=1,#list do
			local tooltip = {list[i][1]}
			for j=2,21,2 do
				local spellID = list[i][j]
				local event = list[i][j+1]
				if spellID and event then
					local spellName,_,spellTexture = GetSpellInfo(spellID)
					if event == "UNIT_DIED" then
						tooltip[#tooltip + 1] = "|cffffffff"..module.db.autoSegmentEventsL[event].." "..spellID.."|r"
					elseif spellName then
						tooltip[#tooltip + 1] = "|cffffffff"..module.db.autoSegmentEventsL[event].." |T"..spellTexture..":0|t |cffffffff"..spellName.."|r"
					end
				end
			end
			self.List[i] = {
				text = list[i][1],
				arg1 = i,
				func = SegmentsSetPreSet,
				hoverFunc = SegmentsPreSetButtonEnter,
				leaveFunc = ELib.Tooltip.Hide,
				hoverArg = tooltip,
				justifyH = "CENTER",
			}
		end
		self.OnClick = nil
	end	
	tab.segmentsPreSet = ELib:ListButton(tab,L.BossWatcherSegmentPreSet..":",350,#tab.segmentsPreSetList):Point(826,-225):Left():OnClick(SegmentsSetPreSet2)

	local Segments_SliderList = {}
	for i,event in ipairs(module.db.autoSegmentEvents) do
		Segments_SliderList[i] = {module.db.autoSegmentEventsL[event],event}
	end
	
	local function Segments_SliderBoxFunc(self)
		local i = self._i
		local selected = self.selected
		if not VExRT.BossWatcher.autoSegments[i] then
			VExRT.BossWatcher.autoSegments[i] = {}
		end
		VExRT.BossWatcher.autoSegments[i][2] = Segments_SliderList[selected][2]	
		UpdateNewSegmentEvents()  
	end
	
	local function EditSliderBoxOnEnterEditBox(self)
		local i = self._i
		local sID = self:GetText()
		sID = tonumber(sID)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(L.BossWatcherSegmentsSpellTooltip)
		if VExRT.BossWatcher.autoSegments[i] and VExRT.BossWatcher.autoSegments[i][2] ~= "UNIT_DIED" and sID and GetSpellInfo(sID) then
			GameTooltip:AddLine(L.BossWatcherSegmentNowTooltip)
			GameTooltip:AddSpellByID(sID)
		end			
		GameTooltip:Show()
	end
	
	local function AutoSegmentsEditBoxOnTextChanged(self,isUser)
		if not isUser then
			return
		end
		VExRT.BossWatcher.autoSegments[self._i] = VExRT.BossWatcher.autoSegments[self._i] or {}
		VExRT.BossWatcher.autoSegments[self._i][1] = tonumber(self:GetText())
		VExRT.BossWatcher.autoSegments[self._i][2] = VExRT.BossWatcher.autoSegments[self._i][2] or "UNIT_SPELLCAST_SUCCEEDED" 
		UpdateNewSegmentEvents()
	end

	tab.autoSegments = {}
	for i=1,14 do
		tab.autoSegments[i] = ELib:Edit(tab,6,true,1):Size(339,24):Point(15,-250-(i-1)*24):Tooltip(L.BossWatcherSegmentsSpellTooltip):Text(VExRT.BossWatcher.autoSegments[i] and VExRT.BossWatcher.autoSegments[i][1] or ""):OnChange(AutoSegmentsEditBoxOnTextChanged)
		tab.autoSegments[i]._i = i
		tab.autoSegments[i]:SetScript("OnEnter",EditSliderBoxOnEnterEditBox)
		
		tab.autoSegments[i]:SetBackdropBorderColor(0.24,0.25,0.30,1)

		local selected = 1
		if VExRT.BossWatcher.autoSegments[i] and VExRT.BossWatcher.autoSegments[i][2] then
			selected = ExRT.F.table_find(module.db.autoSegmentEvents,VExRT.BossWatcher.autoSegments[i][2]) or 1
		end
		tab.autoSegments[i].slider = ELib:SliderBox(tab,Segments_SliderList):Size(483,24):Point(364,-250-(i-1)*24):SetTo(selected)
		tab.autoSegments[i].slider.func = Segments_SliderBoxFunc
		tab.autoSegments[i].slider._i = i
		

		tab.autoSegments[i].slider.middle:SetBackdropBorderColor(0.24,0.25,0.30,1)
		tab.autoSegments[i].slider.left:SetBackdropBorderColor(0.24,0.25,0.30,1)
		tab.autoSegments[i].slider.right:SetBackdropBorderColor(0.24,0.25,0.30,1)
	end
	
	local function UpdateSegmentsPage()
		wipe(BWInterfaceFrame.tab.tabs[11].segmentsList.L)
		wipe(BWInterfaceFrame.tab.tabs[11].segmentsList.C)
		for i=1,#module.db.data[module.db.nowNum].fight do
			local time = module.db.data[module.db.nowNum].fight[i].time - module.db.data[module.db.nowNum].encounterStartGlobal
			local name = module.db.data[module.db.nowNum].fight[i].name
			local subEvent = module.db.data[module.db.nowNum].fight[i].subEvent
			if name then
				local event = name
				name = " "..(module.db.segmentsLNames[name] or name)
				if subEvent then
					name = name.." <"..subEvent..">"
					if (event == "UNIT_SPELLCAST_SUCCEEDED" or event == "SPELL_AURA_REMOVED" or event == "SPELL_AURA_APPLIED") and tonumber(subEvent) then
						local spellName = GetSpellInfo( tonumber(subEvent) )
						if spellName then
							name = name .. ": " ..spellName
						end
					elseif event == "UNIT_DIED" and tonumber(subEvent) then
						local mobID = tonumber(subEvent)
						for guid,mobName in pairs(module.db.data[module.db.nowNum].guids) do
							if string.len(guid) > 3 then
								local thisID = ExRT.F.GUIDtoID(guid)
								if thisID == mobID and mobName then
									name = name .. ": " ..mobName
									break
								end
							end
						end
					end
				end
			end
			BWInterfaceFrame.tab.tabs[11].segmentsList.L[i] = date("%M:%S", max(time,0)) .. (name or "")
			BWInterfaceFrame.tab.tabs[11].segmentsList.C[i] = true
		end
		BWInterfaceFrame.tab.tabs[11].segmentsList:Update()
		BWInterfaceFrame.tab.tabs[11].lastFightID = module.db.data[module.db.nowNum].fightID
	end
	
	function SegmentsPage_IsSegmentEnabled(seg)
		if BWInterfaceFrame.tab.tabs[11].lastFightID ~= module.db.data[module.db.nowNum].fightID then
			return true
		else
			return BWInterfaceFrame.tab.tabs[11].segmentsList.C[seg]
		end
	end
	
	function SegmentsPage_ImprovedSelect(from,to,disableReloadPage,isAdd)
		if BWInterfaceFrame.tab.tabs[11].lastFightID ~= module.db.data[module.db.nowNum].fightID then
			isAdd = nil
		end
		if not isAdd then
			UpdateSegmentsPage()
		end
		if not from then
			BWInterfaceFrame.GraphFrame.G.ZoomMinX = nil
			BWInterfaceFrame.GraphFrame.G.ZoomMaxX = nil		
		end
		if isAdd and from and to then
			for i=1,#module.db.data[module.db.nowNum].fight do
				if (i>=from and i<=to) then
					BWInterfaceFrame.tab.tabs[11].segmentsList.C[i] = true
				end
			end
		else
			for i=1,#module.db.data[module.db.nowNum].fight do
				BWInterfaceFrame.tab.tabs[11].segmentsList.C[i] = not from or not to or (i>=from and i<=to)
			end
		end
		BWInterfaceFrame.tab.tabs[11].segmentsList:Update()
		BWInterfaceFrame.tab.tabs[11].segmentsList:ValueChanged()
		
		if not disableReloadPage then
			local selectedTab = BWInterfaceFrame.tab.selected
			BWInterfaceFrame.tab.tabs[selectedTab]:Hide()
			BWInterfaceFrame.tab.tabs[selectedTab]:Show()
		end
		
		if from and to then
			BWInterfaceFrame.timeLineFrame.timeLine.ImprovedSelectSegment.ResetZoom:Show()
		end
	end
	
	tab:SetScript("OnShow",function (self)
		BWInterfaceFrame.timeLineFrame:ClearAllPoints()
		BWInterfaceFrame.timeLineFrame:SetPoint("TOP",self,"TOP",0,-10)
		BWInterfaceFrame.timeLineFrame:Show()
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			UpdateSegmentsPage()
			self.lastFightID = BWInterfaceFrame.nowFightID
		end
		if VExRT.BossWatcher.Improved then
			self.segmentsPreSet:Hide()
			for i=1,#self.autoSegments do
				self.autoSegments[i]:Hide()
				self.autoSegments[i].slider:Hide()
			end
		else
			self.segmentsPreSet:Show()
			for i=1,#self.autoSegments do
				self.autoSegments[i]:Show()
				self.autoSegments[i].slider:Show()
			end
		end
	end)
	tab:SetScript("OnHide",function (self)
		BWInterfaceFrame.timeLineFrame:Hide()
	end)
	
	
	
	
	---- Interrupt & dispels
	tab = BWInterfaceFrame.tab.tabs[7]
	tabName = BWInterfaceFrame_Name.."InterruptTab"
	
	tab.DecorationLine = CreateFrame("Frame",nil,tab)
	tab.DecorationLine:SetPoint("TOPLEFT",tab,"TOPLEFT",3,-80)
	tab.DecorationLine:SetPoint("RIGHT",tab,-3,0)
	tab.DecorationLine:SetHeight(20)
	tab.DecorationLine.texture = tab.DecorationLine:CreateTexture(nil, "BACKGROUND")
	tab.DecorationLine.texture:SetAllPoints()
	tab.DecorationLine.texture:SetColorTexture(1,1,1,1)
	tab.DecorationLine.texture:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)

	do
		local broke = ACTION_SPELL_AURA_BROKEN
		broke = (ExRT.F:utf8sub(broke,1,1):upper())..ExRT.F:utf8sub(broke,2,-1)
		tab.tabs = ELib:Tabs(tab,0,
			L.BossWatcherInterrupts,
			L.BossWatcherDispels,
			broke
		):Size(845,485):Point("TOP",0,-100)
	end
	tab.tabs.tabs[3].button.tooltip = L.BossWatcherBrokeTooltip
	tab.tabs:SetBackdropBorderColor(0,0,0,0)
	tab.tabs:SetBackdropColor(0,0,0,0)
	
	local Intterupt_Type = 1
	local UpdateInterruptPage = nil
	
	function tab.tabs:buttonAdditionalFunc()
		UpdateInterruptPage()
	end
	
	tab.bySource = ELib:Radio(tab.tabs,L.BossWatcherBySource,true):Point(10,-3):OnClick(function(self) 
		self:SetChecked(true)
		BWInterfaceFrame.tab.tabs[7].byTarget:SetChecked(false)
		BWInterfaceFrame.tab.tabs[7].bySpell:SetChecked(false)
		Intterupt_Type = 1
		UpdateInterruptPage()
	end)
	tab.byTarget = ELib:Radio(tab.tabs,L.BossWatcherByTarget):Point(10,-18):OnClick(function(self) 
		self:SetChecked(true)
		BWInterfaceFrame.tab.tabs[7].bySource:SetChecked(false)
		BWInterfaceFrame.tab.tabs[7].bySpell:SetChecked(false)
		Intterupt_Type = 2
		UpdateInterruptPage()
	end)
	tab.bySpell = ELib:Radio(tab.tabs,L.BossWatcherBySpell):Point(10,-33):OnClick(function(self) 
		self:SetChecked(true)
		BWInterfaceFrame.tab.tabs[7].byTarget:SetChecked(false)
		BWInterfaceFrame.tab.tabs[7].bySource:SetChecked(false)
		Intterupt_Type = 3
		UpdateInterruptPage()
	end)
	
	tab.list = ELib:ScrollList(tab):Size(190,434):Point(14,-155)
	tab.list.GUIDs = {}
	
	tab.events = ELib:ScrollList(tab):Size(637,481):Point(214,-108)
	tab.events.DATA = {}
	
	function tab.list:SetListValue(index)
		local currTab = BWInterfaceFrame.tab.tabs[7]
		local filter = currTab.list.GUIDs[index]
		local isInterrupt = currTab.tabs.selected == 1
		local isBroke = currTab.tabs.selected == 3
		local workTable = module.db.nowData.interrupts
		if isBroke then
			workTable = module.db.nowData.aurabroken
		elseif not isInterrupt then
			workTable = module.db.nowData.dispels
		end
		table.wipe(currTab.events.L)
		table.wipe(currTab.events.DATA)
		if index == 2 then
			local data = {}
			for i,line in ipairs(workTable) do
				local toAdd = nil
				if Intterupt_Type == 1 then
					toAdd = line[1]
				elseif Intterupt_Type == 2 then
					toAdd = line[2]
				elseif Intterupt_Type == 3 then
					toAdd = line[4]
				end
				if toAdd then
					local pos = ExRT.F.table_find(data,toAdd,1)
					if pos then
						data[pos][2] = data[pos][2] + 1
					else
						data[#data + 1] = {toAdd,1,line}
					end
				end
			end
			sort(data,function(a,b) return a[2]>b[2] end)
			for i=1,#data do
				local name = data[i][1]
				if Intterupt_Type == 3 then
					local spellName,_,spellTexture = GetSpellInfo(name)
					name = "|T"..spellTexture..":0|t ".. spellName
				else
					name = "|c".. ExRT.F.classColorByGUID(name) .. GetGUID(name) .. GUIDtoText(" (%s)",name).."|r"
				end
				currTab.events.L[#currTab.events.L + 1] = name .. ": " ..data[i][2]
				currTab.events.DATA[#currTab.events.L] = data[i][3]
			end
		else
			for i,line in ipairs(workTable) do
				local isOkay = false
				if (Intterupt_Type == 1 and (not filter or line[1] == filter)) or
				   (Intterupt_Type == 2 and (not filter or line[2] == filter)) or
				   (Intterupt_Type == 3 and (not filter or line[4] == filter)) then
					isOkay = true
				end
				if isOkay then
					local spellSourceName,_,spellSourceTexture = GetSpellInfo(line[3])
					local spellDestName,_,spellDestTexture = GetSpellInfo(line[4])
					local dispelOrInterrupt = L.BossWatcherDispelText
					local brokeType = nil
					if isInterrupt then
						dispelOrInterrupt = L.BossWatcherInterruptText
					elseif isBroke then
						dispelOrInterrupt = ACTION_SPELL_AURA_BROKEN
						brokeType = line[6] and " ("..line[6]:lower()..")"
						spellSourceName,spellSourceTexture,spellDestName,spellDestTexture = spellDestName,spellDestTexture,spellSourceName,spellSourceTexture
					end
					currTab.events.L[#currTab.events.L + 1] = "[".. date("%M:%S", timestampToFightTime(line[5])).."] |c".. ExRT.F.classColorByGUID(line[1]) .. GetGUID(line[1]) .. GUIDtoText(" (%s)",line[1]) .. "|r "..dispelOrInterrupt.." |c" ..  ExRT.F.classColorByGUID(line[2]).. GetGUID(line[2]) .. "'s" .. GUIDtoText(" (%s)",line[2]) .. "|r |Hspell:" .. (line[4] or 0) .. "|h" .. format("%s%s",spellDestTexture and "|T"..spellDestTexture..":0|t " or "",spellDestName or "???") .. "|h"..(brokeType or "").." "..L.BossWatcherByText.." |Hspell:" .. (line[3] or 0) .. "|h" .. format("%s%s",spellSourceTexture and "|T"..spellSourceTexture..":0|t " or "",spellSourceName or "???") .. "|h"
					currTab.events.DATA[#currTab.events.L] = line
				end
			end
		end
		currTab.events:Update()
	end
	function tab.events:SetListValue(index)
		self.selected = nil
		self:Update()
	end
	function tab.events:HoverListValue(isHover,index,hoveredObj)
		if not isHover then
			GameTooltip_Hide()
			ELib.Tooltip:HideAdd()
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:Hide()
		else
			local this = hoveredObj
			local line = BWInterfaceFrame.tab.tabs[7].events.DATA[index]
			
			GameTooltip:SetOwner(this or self,"ANCHOR_BOTTOMLEFT")
			GameTooltip:SetHyperlink("spell:"..line[4])
			GameTooltip:Show()
			
			ELib.Tooltip:Add("spell:"..line[3])
			
			if this.text:IsTruncated() then
				ELib.Tooltip:Add(nil,{this.text:GetText()},false,true)
			end
			
			local _time = timestampToFightTime(line[5]) / ( module.db.data[module.db.nowNum].encounterEnd - module.db.data[module.db.nowNum].encounterStart )
			
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:SetPoint("TOPLEFT",BWInterfaceFrame.timeLineFrame.timeLine,"BOTTOMLEFT",BWInterfaceFrame.timeLineFrame.width*_time,0)
			BWInterfaceFrame.timeLineFrame.timeLine.arrow:Show()
		end
	end

	function UpdateInterruptPage()
		local currTab = BWInterfaceFrame.tab.tabs[7]
		table.wipe(currTab.list.L)
		table.wipe(currTab.list.GUIDs)
		table.wipe(currTab.events.L)
		
		local workTable = module.db.nowData.interrupts
		if currTab.tabs.selected == 2 then
			workTable = module.db.nowData.dispels
		elseif currTab.tabs.selected == 3 then
			workTable = module.db.nowData.aurabroken
		end
		local data = {}
		for i,line in ipairs(workTable) do
			if Intterupt_Type == 1 then
				if not ExRT.F.table_find(data,line[1]) then
					data[#data + 1] = line[1]
				end
			elseif Intterupt_Type == 2 then
				if not ExRT.F.table_find(data,line[2]) then
					data[#data + 1] = line[2]
				end
			else
				if not ExRT.F.table_find(data,line[4]) then
					data[#data + 1] = line[4]
				end
			end
		end
		local data2 = {}
		for i=1,#data do
			if Intterupt_Type ~= 3 then
				data2[i] = {data[i],GetGUID(data[i]),"|c"..ExRT.F.classColorByGUID(data[i])}
			else
				local spellName = GetSpellInfo(data[i])
				data2[i] = {data[i],spellName}
			end
		end
		sort(data2,function(a,b)return a[2]<b[2] end)
		for i=1,#data2 do
			currTab.list.L[i+2] = (data2[i][3] or "")..data2[i][2]
			currTab.list.GUIDs[i+2] = data2[i][1]
		end
		currTab.list.L[1] = L.BossWatcherAll
		currTab.list.L[2] = L.BossWatcherSpellsCount
		
		currTab.list.selected = 1
		
		currTab.list:Update()
		currTab.list:SetListValue(1)
		--currTab.events:Update()
	end

	tab:SetScript("OnShow",function (self)
		BWInterfaceFrame.timeLineFrame:ClearAllPoints()
		BWInterfaceFrame.timeLineFrame:SetPoint("TOP",self,"TOP",0,-10)
		BWInterfaceFrame.timeLineFrame:Show()
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			UpdateInterruptPage()
			self.lastFightID = BWInterfaceFrame.nowFightID
		end
	end)
	tab:SetScript("OnHide",function (self)
		BWInterfaceFrame.timeLineFrame:Hide()
	end)


	
	
	---- Heal
	tab = BWInterfaceFrame.tab.tabs[2]
	tabName = BWInterfaceFrame_Name.."HealingTab"
	
	local HsourceVar,HdestVar = {},{}
	local HealingTab_SetLine = nil
	local HealingTab_Variables = {
		Last_Func = nil,
		Last_doEnemy = nil,
		Last_doReduction = nil,
		ShowOverheal = false,
		Back_Func = nil,
		Back_destVar = nil,
		Back_sourceVar = nil,
		NULLSpellAmount = {
			amount = 0,
			over = 0,
			absorbed = 0,
			count = 0,
			crit = 0,
			critcount = 0,
			critmax = 0,
			critover = 0,
			ms = 0,
			mscount = 0,
			msmax = 0,
			msover = 0,
			hitmax = 0,
			absorbs = 0,
		}
	}
	
	local function HealingTab_UpdateDropDown(arr,dropDown)
		local count = ExRT.F.table_len(arr)
		if count == 0 then
			dropDown:SetText(L.BossWatcherAll)
		elseif count == 1 then
			local GUID = nil
			for g,_ in pairs(arr) do
				GUID = g
			end
			local name = GetGUID(GUID)
			local flags = module.db.data[module.db.nowNum].reaction[GUID]
			local isPlayer = ExRT.F.GetUnitInfoByUnitFlag(flags,1) == 1024
			local isNPC = ExRT.F.GetUnitInfoByUnitFlag(flags,2) == 512
			if isPlayer then
				name = "|c"..ExRT.F.classColorByGUID(GUID)..name
			elseif isNPC then
				name = name .. GUIDtoText(" [%s]",GUID)
			end
			dropDown:SetText(name)
		else
			dropDown:SetText(L.BossWatcherSeveral)
		end
	end
	
	local function HealingTab_UpdateDropDownSource()
		HealingTab_UpdateDropDown(HsourceVar,BWInterfaceFrame.tab.tabs[2].sourceDropDown)
	end
	local function HealingTab_UpdateDropDownDest()
		HealingTab_UpdateDropDown(HdestVar,BWInterfaceFrame.tab.tabs[2].targetDropDown)
	end
	
	local HealingTab_UpdateDropDownType = nil
	do
		local dropDownNames = {
			{L.BossWatcherHealFriendly..": "..L.BossWatcherBySource,L.BossWatcherHealFriendly..": "..L.BossWatcherByTarget,L.BossWatcherHealFriendly..": "..L.BossWatcherBySpell,L.BossWatcherHealReduction,L.BossWatcherHealReductionPlusHealing,L.BossWatcherFromSpells},
			{L.BossWatcherHealHostile..": "..L.BossWatcherBySource,L.BossWatcherHealHostile..": "..L.BossWatcherByTarget,L.BossWatcherHealHostile..": "..L.BossWatcherBySpell,L.BossWatcherHealReductionSpells,L.BossWatcherHealReductionPlusHealingSpells,""},
		}
		function HealingTab_UpdateDropDownType(type,doEnemy)
			local isEnemy = doEnemy and 2 or 1
			BWInterfaceFrame.tab.tabs[2].typeDropDown:SetText(dropDownNames[isEnemy][type])
			
			BWInterfaceFrame.tab.tabs[2].showOverhealChk.tooltipText = L.BossWatcherHealShowOver
		end
	end
	
	local function HealingTab_ReloadGraph(data,fightLength,linesData,isSpell)
		local graphData = {}
		for key,spellData in pairs(data) do
			local newData
			if isSpell then
				local spellID = key
				local isPet = 1
				if spellID < -1 then
					isPet = -1
					spellID = -spellID
				end
				local spellName,_,spellIcon = GetSpellInfo(spellID)
				if spellID == -1 then
					spellName = L.BossWatcherReportTotal
				elseif spellName then
					spellName = "|T"..spellIcon..":0|t "..spellName
				else
					spellName = spellID
				end
				newData = {
					info_spellID = spellID*isPet,
					name = spellName,
					total_healing = 0,
					hide = true,
				}
			else
				local sourceGUID = key
				local name,r,g,b = nil
				if sourceGUID == -1 then
					name = L.BossWatcherReportTotal
				else
					local class
					name = GetGUID(sourceGUID)
					if sourceGUID ~= "" then
						class = select(2,GetPlayerInfoByGUID(sourceGUID))
					end
					name = "|c".. ExRT.F.classColor(class) .. name .. "|r"
					if class then
						local classColorArray = type(CUSTOM_CLASS_COLORS)=="table" and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
						r,g,b = classColorArray.r,classColorArray.g,classColorArray.b
					end
				end
				newData = {
					info_spellID = sourceGUID,
					name = name,
					total_healing = 0,
					hide = true,
					r = r,
					g = g,
					b = b,
				}
			end
			graphData[#graphData+1] = newData
			local totalHealing = 0
			for i=1,fightLength do
				newData[i] = {i,spellData[i] or 0}
				totalHealing = totalHealing + (spellData[i] or 0)
			end
			newData.total_healing = totalHealing
		end
		sort(graphData,function(a,b) return a.total_healing>b.total_healing end)
		local findPos = ExRT.F.table_find(graphData,-1,'info_spellID')
		if findPos then
			graphData[ findPos ].hide = nil
			graphData[ findPos ].specialLine = true
		end
		for i=1,3 do
			if linesData[i] then
				findPos = ExRT.F.table_find(graphData,linesData[i][1],'info_spellID')
				if findPos then
					graphData[ findPos ].hide = nil
				end
			end
		end
		BWInterfaceFrame.GraphFrame.G.data = graphData
		BWInterfaceFrame.GraphFrame.G:Reload()
	end
	
	local function HealingTab_UpdateLinesPlayers(doEnemy,doReduction)
		HealingTab_UpdateDropDownSource()
		HealingTab_UpdateDropDownDest()
		HealingTab_UpdateDropDownType(1+(doReduction and 4 or 0),doEnemy)
		HealingTab_Variables.Last_Func = HealingTab_UpdateLinesPlayers
		HealingTab_Variables.Last_doEnemy = doEnemy
		HealingTab_Variables.Last_doReduction = doReduction
		HealingTab_Variables.Back_Func = HealingTab_UpdateLinesPlayers
		HealingTab_Variables.Back_sourceVar = nil
		HealingTab_Variables.Back_destVar = nil
		local heal = {}
		local total = 0
		local totalOver = 0
		for sourceGUID,sourceData in pairs(module.db.nowData.heal) do
			local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
			if owner then
				sourceGUID = owner
			end
			if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[sourceGUID] then
				for destGUID,destData in pairs(sourceData) do
					local isEnemy = not ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[destGUID])
					if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
						if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
							local inDamagePos = ExRT.F.table_find(heal,sourceGUID,1)
							if not inDamagePos then
								inDamagePos = #heal + 1
								heal[inDamagePos] = {sourceGUID,0,0,0,0,0,0,{},0,{}}
							end
							local destPos = ExRT.F.table_find(heal[inDamagePos][8],destGUID,1)
							if not destPos then
								destPos = #heal[inDamagePos][8] + 1
								heal[inDamagePos][8][destPos] = {destGUID,0}
							end
							destPos = heal[inDamagePos][8][destPos]
							
							for spellID,spellAmount in pairs(destData) do
								if spellID == 98021 then	--Spirit Link
									spellAmount = HealingTab_Variables.NULLSpellAmount
								end
								heal[inDamagePos][2] = heal[inDamagePos][2] + spellAmount.amount - spellAmount.over + spellAmount.absorbed
								heal[inDamagePos][3] = heal[inDamagePos][3] + spellAmount.amount 						--total
								heal[inDamagePos][4] = heal[inDamagePos][4] + spellAmount.over 							--overheal
								heal[inDamagePos][5] = heal[inDamagePos][5] + spellAmount.absorbed 						--absorbed
								if HealingTab_Variables.ShowOverheal then
									heal[inDamagePos][6] = heal[inDamagePos][6] + spellAmount.crit
									heal[inDamagePos][7] = heal[inDamagePos][7] + spellAmount.ms
								else
									heal[inDamagePos][6] = heal[inDamagePos][6] + spellAmount.crit - spellAmount.critover
									heal[inDamagePos][7] = heal[inDamagePos][7] + spellAmount.ms - spellAmount.msover					
								end
								heal[inDamagePos][9] = heal[inDamagePos][9] + spellAmount.absorbs						--absorbs
								total = total + spellAmount.amount - spellAmount.over + spellAmount.absorbed
								totalOver = totalOver + spellAmount.over
								
								destPos[2] = destPos[2] + spellAmount.amount + spellAmount.absorbed + (HealingTab_Variables.ShowOverheal and 0 or -spellAmount.over)
							end
						end
					end
				end
			end
		end
		if doReduction and not doEnemy then
			for destGUID,destData in pairs(module.db.nowData.reduction) do
				if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
					for sourceGUID,sourceData in pairs(destData) do
						for spellID,spellData in pairs(sourceData) do
							for reductorGUID,reductorData in pairs(spellData) do
								local owner = ExRT.F.Pets:getOwnerGUID(reductorGUID,GetPetsDB())
								if owner then
									reductorGUID = owner
								end
								if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[reductorGUID] then
									local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[reductorGUID])
									if isFriendly then
										local inDamagePos = ExRT.F.table_find(heal,reductorGUID,1)
										if not inDamagePos then
											inDamagePos = #heal + 1
											heal[inDamagePos] = {reductorGUID,0,0,0,0,0,0,{},0,{}}
										end
										
										local destPos = ExRT.F.table_find(heal[inDamagePos][8],destGUID,1)
										if not destPos then
											destPos = #heal[inDamagePos][8] + 1
											heal[inDamagePos][8][destPos] = {destGUID,0}
										end
										destPos = heal[inDamagePos][8][destPos]
										
										for reductionSpellID,reductionSpellAmount in pairs(reductorData) do
											heal[inDamagePos][2] = heal[inDamagePos][2] + reductionSpellAmount
											heal[inDamagePos][3] = heal[inDamagePos][3] + reductionSpellAmount
											heal[inDamagePos][9] = heal[inDamagePos][9] + reductionSpellAmount
											
											total = total + reductionSpellAmount
											
											destPos[2] = destPos[2] + reductionSpellAmount
										end
									end
								end
							end
						end
					end
				end
			end
		end
		for _,healData in pairs(heal) do
			for sourceGUID,sourceData in pairs(module.db.nowData.healFrom) do
				if healData[1] == sourceGUID or ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB()) == healData[1] then
					for destGUID,destData in pairs(sourceData) do
						local isEnemy = not ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[destGUID])
						if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
							if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
								for spellID,spellData in pairs(destData) do
									for fromSpellID,fromSpellAmount in pairs(spellData) do
										local destPos = ExRT.F.table_find(healData[10],fromSpellID,1)
										if not destPos then
											destPos = #healData[10] + 1
											healData[10][destPos] = {fromSpellID,0}
										end
										destPos = healData[10][destPos]
										
										destPos[2] = destPos[2] + fromSpellAmount
									end
								end
							end
						end
					end
				end
			end
		end
		
		local totalIsFull = 1
		total = max(total,1)
		if total == 1 and #heal == 0 then
			total = 0
			totalIsFull = 0
		end
		local _max = nil
		reportOptions[2] = L.BossWatcherReportHPS
		wipe(reportData[2])
		reportData[2][1] = (DamageTab_GetGUIDsReport(HsourceVar) or L.BossWatcherAllSources).." > "..(DamageTab_GetGUIDsReport(HdestVar) or L.BossWatcherAllTargets)
		local activeFightLength = GetFightLength()
		
		if HealingTab_Variables.ShowOverheal then
			total = total + totalOver
			sort(heal,function(a,b) return (a[2]+a[4])>(b[2]+b[4]) end)
			_max = heal[1] and (heal[1][2]+heal[1][4]) or 0
		else
			sort(heal,function(a,b) return a[2]>b[2] end)
			_max = heal[1] and heal[1][2] or 0
		end
		reportData[2][2] = L.BossWatcherReportTotal.." - "..ExRT.F.shortNumber(total).."@1@ ("..floor(total / activeFightLength)..")@1#"
		HealingTab_SetLine({
			line = 1,
			name = L.BossWatcherReportTotal,
			num = total,
			total = total,
			max = total,
			alpha = HealingTab_Variables.ShowOverheal and totalOver,
			dps = total / activeFightLength,
			spellID = -1,
			check = BWInterfaceFrame.GraphFrame:IsShown(),
			checkState = true,
		})
		for i=1,#heal do
			local class = nil
			if heal[i][1] and heal[i][1] ~= "" then
				class = select(2,GetPlayerInfoByGUID(heal[i][1]))
			end
			local icon = ""
			if class and CLASS_ICON_TCOORDS[class] then
				icon = {"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",unpack(CLASS_ICON_TCOORDS[class])}
			end
			local tooltipData = {GetGUID(heal[i][1]),
				{L.BossWatcherHealTooltipOver,format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][4]),heal[i][4]/max(heal[i][2]+heal[i][4],1)*100)},
				{L.BossWatcherHealTooltipAbsorbed,ExRT.F.shortNumber(heal[i][5])},
				{L.BossWatcherHealTooltipTotal,ExRT.F.shortNumber(heal[i][3])},
				{" "," "},
				{L.BossWatcherHealTooltipFromCrit,format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][6]),heal[i][6]/max(1,heal[i][2]+(HealingTab_Variables.ShowOverheal and heal[i][4] or 0))*100)},
				{L.BossWatcherHealTooltipFromMs,format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][7]),heal[i][7]/max(1,heal[i][2]+(HealingTab_Variables.ShowOverheal and heal[i][4] or 0))*100)},
				{ACTION_SPELL_MISSED_ABSORB,format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][9]),heal[i][9]/max(heal[i][2]+(HealingTab_Variables.ShowOverheal and heal[i][4] or 0),1)*100)},
			}
			sort(heal[i][8],DamageTab_Temp_SortingBy2Param)
			if #heal[i][8] > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherHealTooltipTargets," "}
			end
			for j=1,min(5,#heal[i][8]) do
				tooltipData[#tooltipData + 1] = {SubUTF8String(GetGUID(heal[i][8][j][1]),20)..GUIDtoText(" [%s]",heal[i][8][j][1]),format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][8][j][2]),min(heal[i][8][j][2] / max(1,heal[i][2]+(HealingTab_Variables.ShowOverheal and (heal[i][4]) or 0))*100,100))}
			end
			sort(heal[i][10],DamageTab_Temp_SortingBy2Param)
			if #heal[i][10] > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherFromSpells," "}
			end
			for j=1,min(5,#heal[i][10]) do
				local spellName,_,spellTexture = GetSpellInfo(heal[i][10][j][1])
				tooltipData[#tooltipData + 1] = {(spellTexture and "|T"..spellTexture..":0|t" or "")..(spellName or "spell:"..spellName),ExRT.F.shortNumber(heal[i][10][j][2])}
			end
			
			local currHealing = heal[i][2]+(HealingTab_Variables.ShowOverheal and heal[i][4] or 0)
			local hps = currHealing/activeFightLength
			HealingTab_SetLine({
				line = i+1,
				icon = icon,
				name = GetGUID(heal[i][1])..GUIDtoText(" [%s]",heal[i][1]),
				num = currHealing,
				total = total,
				max = _max,
				alpha = HealingTab_Variables.ShowOverheal and heal[i][4] or heal[i][9],
				dps = hps,
				class = class,
				sourceGUID = heal[i][1],
				doEnemy = doEnemy,
				tooltip = tooltipData,
				isReduction = doReduction and 2,
				check = BWInterfaceFrame.GraphFrame:IsShown(),
				checkState = i <= 3,
			})
			reportData[2][#reportData[2]+1] = i..". "..GetGUID(heal[i][1]).." - "..ExRT.F.shortNumber(currHealing).."@1@ ("..floor(hps)..")@1#"
		end
		for i=#heal+2,#BWInterfaceFrame.tab.tabs[2].lines do
			BWInterfaceFrame.tab.tabs[2].lines[i]:Hide()
		end
		BWInterfaceFrame.tab.tabs[2].scroll:Height((#heal+1) * 20)
		
		
		if not BWInterfaceFrame.GraphFrame:IsShown() then
			return
		end
		local graph = {[-1]={}}
		local currFight = module.db.data[module.db.nowNum]
		local maxFight = #module.db.data[module.db.nowNum].fight
		for seg=1,maxFight do
			for sourceGUID,sourceData in pairs(currFight.fight[seg].heal) do
				local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
				if owner then
					sourceGUID = owner
				end
				if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[sourceGUID] then
					for destGUID,destData in pairs(sourceData) do
						local isEnemy = not ExRT.F.UnitIsFriendlyByUnitFlag2(currFight.reaction[destGUID])
						if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
							if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
								if not graph[ sourceGUID ] then
									graph[ sourceGUID ] = {}
								end
								if not graph[ sourceGUID ][seg] then
									graph[ sourceGUID ][seg] = 0
								end
								if not graph[ -1 ][seg] then
									graph[ -1 ][seg] = 0
								end
								for spellID,spellAmount in pairs(destData) do
									if spellID == 98021 then	--Spirit Link
										spellAmount = HealingTab_Variables.NULLSpellAmount
									end
									local healCount = spellAmount.amount - (HealingTab_Variables.ShowOverheal and 0 or spellAmount.over) + spellAmount.absorbed
									graph[ sourceGUID ][seg] = graph[ sourceGUID ][seg] + healCount
									graph[ -1 ][seg] = graph[ -1 ][seg] + healCount
								end
							end
						end
					end
				end
			end
			if doReduction and not doEnemy then
				for destGUID,destData in pairs(currFight.fight[seg].reduction) do
					if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
						for sourceGUID,sourceData in pairs(destData) do
							for spellID,spellData in pairs(sourceData) do
								for reductorGUID,reductorData in pairs(spellData) do
									local owner = ExRT.F.Pets:getOwnerGUID(reductorGUID,GetPetsDB())
									if owner then
										reductorGUID = owner
									end
									if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[reductorGUID] then
										local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(currFight.reaction[reductorGUID])
										if isFriendly then
											if not graph[ reductorGUID ] then
												graph[ reductorGUID ] = {}
											end
											if not graph[ reductorGUID ][seg] then
												graph[ reductorGUID ][seg] = 0
											end
											if not graph[ -1 ][seg] then
												graph[ -1 ][seg] = 0
											end
											for reductionSpellID,reductionSpellAmount in pairs(reductorData) do
												graph[ reductorGUID ][seg] = graph[ reductorGUID ][seg] + reductionSpellAmount
												graph[ -1 ][seg] = graph[ -1 ][seg] + reductionSpellAmount
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		HealingTab_ReloadGraph(graph,maxFight,heal,false)
	end
	local function HealingTab_UpdateLinesSpell(doEnemy,doReduction)
		HealingTab_UpdateDropDownSource()
		HealingTab_UpdateDropDownDest()
		HealingTab_UpdateDropDownType(3+(doReduction and 2 or 0),doEnemy or doReduction)
		HealingTab_Variables.Last_Func = HealingTab_UpdateLinesSpell
		HealingTab_Variables.Last_doEnemy = doEnemy
		HealingTab_Variables.Last_doReduction = doReduction
		HealingTab_Variables.Back_Func = HealingTab_UpdateLinesSpell
		HealingTab_Variables.Back_sourceVar = nil
		HealingTab_Variables.Back_destVar = nil
		local heal = {}
		local total = 0
		local totalOver = 0
		for sourceGUID,sourceData in pairs(module.db.nowData.heal) do
			local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
			if owner then
				sourceGUID = owner
			end
			if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[sourceGUID] then
				for destGUID,destData in pairs(sourceData) do
					local isEnemy = not ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[destGUID])
					if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
						if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
							for spellID,spellAmount in pairs(destData) do
								if spellID == 98021 then	--Spirit Link
									spellAmount = HealingTab_Variables.NULLSpellAmount
								end
								if owner then
									spellID = -spellID
								end							
								local inDamagePos = ExRT.F.table_find(heal,spellID,1)
								if not inDamagePos then
									inDamagePos = #heal + 1
									heal[inDamagePos] = {spellID,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,{}}
								end
								
								local destPos = ExRT.F.table_find(heal[inDamagePos][17],destGUID,1)
								if not destPos then
									destPos = #heal[inDamagePos][17] + 1
									heal[inDamagePos][17][destPos] = {destGUID,0}
								end
								destPos = heal[inDamagePos][17][destPos]
								
								heal[inDamagePos][2] = heal[inDamagePos][2] + spellAmount.amount - spellAmount.over + spellAmount.absorbed	--ef
								heal[inDamagePos][3] = heal[inDamagePos][3] + spellAmount.amount 						--total
								heal[inDamagePos][4] = heal[inDamagePos][4] + spellAmount.over 							--overheal
								heal[inDamagePos][5] = heal[inDamagePos][5] + spellAmount.absorbed 						--absorbed
								heal[inDamagePos][6] = heal[inDamagePos][6] + spellAmount.count 						--count
								heal[inDamagePos][7] = heal[inDamagePos][7] + spellAmount.crit 							--crit
								heal[inDamagePos][8] = heal[inDamagePos][8] + spellAmount.critcount						--crit-count
								heal[inDamagePos][9] = max(heal[inDamagePos][9],spellAmount.critmax)						--crit-max
								heal[inDamagePos][10] = heal[inDamagePos][10] + spellAmount.ms							--ms
								heal[inDamagePos][11] = heal[inDamagePos][11] + spellAmount.mscount						--ms-count
								heal[inDamagePos][12] = max(heal[inDamagePos][12],spellAmount.msmax) 						--ms-max
								heal[inDamagePos][13] = max(heal[inDamagePos][13],spellAmount.hitmax)						--hit-max
								heal[inDamagePos][14] = heal[inDamagePos][14] + spellAmount.critover						--crit overheal
								heal[inDamagePos][15] = heal[inDamagePos][15] + spellAmount.msover						--ms overheal
								heal[inDamagePos][16] = heal[inDamagePos][16] + spellAmount.absorbs						--absorbs
								total = total + spellAmount.amount - spellAmount.over + spellAmount.absorbed
								totalOver = totalOver + spellAmount.over
								
								destPos[2] = destPos[2] + spellAmount.amount + spellAmount.absorbed + (HealingTab_Variables.ShowOverheal and 0 or -spellAmount.over)
							end
						end
					end
				end
			end
		end
		if doReduction and not doEnemy then
			for destGUID,destData in pairs(module.db.nowData.reduction) do
				if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
					for sourceGUID,sourceData in pairs(destData) do
						for spellID,spellData in pairs(sourceData) do
							for reductorGUID,reductorData in pairs(spellData) do
								local owner = ExRT.F.Pets:getOwnerGUID(reductorGUID,GetPetsDB())
								if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[reductorGUID] then
									local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[reductorGUID])
									if isFriendly then
										for reductionSpellID,reductionSpellAmount in pairs(reductorData) do
											if owner then
												reductionSpellID = -reductionSpellID
											end
										
											local inDamagePos = ExRT.F.table_find(heal,reductionSpellID,1)
											if not inDamagePos then
												inDamagePos = #heal + 1
												heal[inDamagePos] = {reductionSpellID,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,{}}
											end
											
											local destPos = ExRT.F.table_find(heal[inDamagePos][17],destGUID,1)
											if not destPos then
												destPos = #heal[inDamagePos][17] + 1
												heal[inDamagePos][17][destPos] = {destGUID,0}
											end
											destPos = heal[inDamagePos][17][destPos]
										
											heal[inDamagePos][2] = heal[inDamagePos][2] + reductionSpellAmount
											heal[inDamagePos][3] = heal[inDamagePos][3] + reductionSpellAmount
											heal[inDamagePos][16] = heal[inDamagePos][16] + reductionSpellAmount
											total = total + reductionSpellAmount
											destPos[2] = destPos[2] + reductionSpellAmount
										end
									end
								end
							end
						end
					end
				end
			end
		end
		
		local totalIsFull = 1
		total = max(total,1)
		if total == 1 and #heal == 0 then
			total = 0
			totalIsFull = 0
		end
		local _max = nil
		reportOptions[2] = L.BossWatcherReportHPS
		wipe(reportData[2])
		reportData[2][1] = (DamageTab_GetGUIDsReport(HsourceVar) or L.BossWatcherAllSources).." > "..(DamageTab_GetGUIDsReport(HdestVar) or L.BossWatcherAllTargets)
		local activeFightLength = GetFightLength()
		if HealingTab_Variables.ShowOverheal then
			total = total + totalOver
			sort(heal,function(a,b) return (a[2]+a[4])>(b[2]+b[4]) end)
			_max = heal[1] and (heal[1][2]+heal[1][4]) or 0
		else
			sort(heal,function(a,b) return a[2]>b[2] end)
			_max = heal[1] and heal[1][2] or 0
		end
		reportData[2][2] = L.BossWatcherReportTotal.." - "..ExRT.F.shortNumber(total).."@1@ ("..floor(total / activeFightLength)..")@1#"
		HealingTab_SetLine({
			line = 1,
			name = L.BossWatcherReportTotal,
			total = total,
			num = total,
			max = total,
			dps = total / activeFightLength,
			spellID = -1,
			alpha = HealingTab_Variables.ShowOverheal and totalOver,
			check = BWInterfaceFrame.GraphFrame:IsShown(),
			checkState = true,
		})
		_max = max(_max,1)
		for i=1,#heal do
			local isPetAbility = heal[i][1] < 0
			if isPetAbility then
				heal[i][1] = -heal[i][1]
			end
			local spellName,_,spellIcon = GetSpellInfo(heal[i][1])
			if isPetAbility then
				spellName = L.BossWatcherPetText..": "..spellName
			end
			local school = module.db.spellsSchool[ heal[i][1] ] or 0
			local tooltipData = {
				{spellName,spellIcon},
				{L.BossWatcherHealTooltipCount,heal[i][6]-heal[i][11]},
				{L.BossWatcherHealTooltipHitMax,floor(heal[i][13])},
				{L.BossWatcherHealTooltipHitMid,ExRT.F.Round(max(heal[i][3]-heal[i][10]-heal[i][7]-(heal[i][4]-heal[i][14]-heal[i][15]),0)/max(heal[i][6]-heal[i][8]-heal[i][11],1))},
				{L.BossWatcherHealTooltipCritCount,format("%d (%.1f%%)",heal[i][8],heal[i][8]/heal[i][6]*100)},
				{L.BossWatcherHealTooltipCritAmount,ExRT.F.shortNumber(heal[i][7]-heal[i][14])},
				{L.BossWatcherHealTooltipCritMax,heal[i][9]},
				{L.BossWatcherHealTooltipCritMid,ExRT.F.Round((heal[i][7]-heal[i][14])/max(heal[i][8],1))},
				{L.BossWatcherHealTooltipMsCount,format("%d (%.1f%%)",heal[i][11],heal[i][11]/heal[i][6]*100)},
				{L.BossWatcherHealTooltipMsAmount,ExRT.F.shortNumber(heal[i][10]-heal[i][15])},
				{L.BossWatcherHealTooltipMsMax,heal[i][12]},
				{L.BossWatcherHealTooltipMsMid,ExRT.F.Round((heal[i][10]-heal[i][15])/max(heal[i][11],1))},
				{L.BossWatcherHealTooltipOver,format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][4]),heal[i][4]/max(heal[i][2]+heal[i][4],1)*100)},
				{L.BossWatcherHealTooltipAbsorbed,ExRT.F.shortNumber(heal[i][5])},
				{L.BossWatcherHealTooltipTotal,ExRT.F.shortNumber(heal[i][3])},
				{L.BossWatcherSchool,GetSchoolName(school)},
			}
			local castsCount = SpellsPage_GetCastsNumber(ExRT.F.table_len(HsourceVar) > 0 and HsourceVar,heal[i][1])
			if castsCount > 0 then
				tinsert(tooltipData,2,{L.BossWatcherDamageTooltipCastsCount,castsCount})
			end
			
			sort(heal[i][17],DamageTab_Temp_SortingBy2Param)
			if #heal[i][17] > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherHealTooltipTargets," "}
			end
			for j=1,min(5,#heal[i][17]) do
				tooltipData[#tooltipData + 1] = {SubUTF8String(GetGUID(heal[i][17][j][1]),20)..GUIDtoText(" [%s]",heal[i][17][j][1]),format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][17][j][2]),min(heal[i][17][j][2] / max(1,heal[i][2]+(HealingTab_Variables.ShowOverheal and (heal[i][4]) or 0))*100,100))}
			end
			
			local currHealing = heal[i][2]+(HealingTab_Variables.ShowOverheal and heal[i][4] or 0)
			local hps = currHealing/activeFightLength
			HealingTab_SetLine({
				line = i+1,
				icon = spellIcon,
				name = spellName,
				total = total,
				num = currHealing,
				alpha = HealingTab_Variables.ShowOverheal and heal[i][4] or heal[i][16],
				max = _max,
				dps = hps,
				spellID = heal[i][1],
				tooltip = tooltipData,
				school = school,
				isPet = isPetAbility,
				check = BWInterfaceFrame.GraphFrame:IsShown(),
				checkState = i <= 3,
			})
			reportData[2][#reportData[2]+1] = i..". "..(isPetAbility and L.BossWatcherPetText..": " or "")..GetSpellLink(heal[i][1]).." - "..ExRT.F.shortNumber(currHealing).."@1@ ("..floor(hps)..")@1#"
			if isPetAbility then
				heal[i][1] = -heal[i][1]
			end
		end
		for i=#heal+2,#BWInterfaceFrame.tab.tabs[2].lines do
			BWInterfaceFrame.tab.tabs[2].lines[i]:Hide()
		end
		BWInterfaceFrame.tab.tabs[2].scroll:Height((#heal+1) * 20)
		
		
		if not BWInterfaceFrame.GraphFrame:IsShown() then
			return
		end

		local graph = {[-1]={}}
		local currFight = module.db.data[module.db.nowNum]
		local maxFight = #module.db.data[module.db.nowNum].fight
		for seg=1,maxFight do
			for sourceGUID,sourceData in pairs(currFight.fight[seg].heal) do
				local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
				if owner then
					sourceGUID = owner
				end
				if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[sourceGUID] then
					for destGUID,destData in pairs(sourceData) do
						local isEnemy = not ExRT.F.UnitIsFriendlyByUnitFlag2(currFight.reaction[destGUID])
						if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
							if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
								for spellID,spellAmount in pairs(destData) do
									if spellID == 98021 then	--Spirit Link
										spellAmount = HealingTab_Variables.NULLSpellAmount
									end
									if owner then
										spellID = -spellID
									end
									if not graph[ spellID ] then
										graph[ spellID ] = {}
									end
									if not graph[ spellID ][seg] then
										graph[ spellID ][seg] = 0
									end
									if not graph[ -1 ][seg] then
										graph[ -1 ][seg] = 0
									end
									local healCount = spellAmount.amount - (HealingTab_Variables.ShowOverheal and 0 or spellAmount.over) + spellAmount.absorbed
									
									if spellID == 98021 then	--Shaman: SLT
										healCount = HealingTab_Variables.ShowOverheal and spellAmount.amount or 0
									end
									
									graph[ spellID ][seg] = graph[ spellID ][seg] + healCount
									graph[ -1 ][seg] = graph[ -1 ][seg] + healCount
								end
							end
						end
					end
				end
			end
			if doReduction and not doEnemy then
				for destGUID,destData in pairs(currFight.fight[seg].reduction) do
					if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
						for sourceGUID,sourceData in pairs(destData) do
							for spellID,spellData in pairs(sourceData) do
								for reductorGUID,reductorData in pairs(spellData) do
									local owner = ExRT.F.Pets:getOwnerGUID(reductorGUID,GetPetsDB())
									if owner then
										reductorGUID = owner
									end
									if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[reductorGUID] then
										local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(currFight.reaction[reductorGUID])
										if isFriendly then
											for reductionSpellID,reductionSpellAmount in pairs(reductorData) do
												if owner then
													reductionSpellID = -reductionSpellID
												end
												if not graph[ reductionSpellID ] then
													graph[ reductionSpellID ] = {}
												end
												if not graph[ reductionSpellID ][seg] then
													graph[ reductionSpellID ][seg] = 0
												end
												if not graph[ -1 ][seg] then
													graph[ -1 ][seg] = 0
												end
												graph[ reductionSpellID ][seg] = graph[ reductionSpellID ][seg] + reductionSpellAmount
												graph[ -1 ][seg] = graph[ -1 ][seg] + reductionSpellAmount
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		HealingTab_ReloadGraph(graph,maxFight,heal,true)
	end
	local function HealingTab_UpdateLinesTargets(doEnemy)
		HealingTab_UpdateDropDownSource()
		HealingTab_UpdateDropDownDest()
		HealingTab_UpdateDropDownType(2,doEnemy)
		HealingTab_Variables.Last_Func = HealingTab_UpdateLinesTargets
		HealingTab_Variables.Last_doEnemy = doEnemy
		HealingTab_Variables.Back_Func = HealingTab_UpdateLinesTargets
		HealingTab_Variables.Back_sourceVar = nil
		HealingTab_Variables.Back_destVar = nil
		local heal = {}
		local total = 0
		local totalOver = 0
		for sourceGUID,sourceData in pairs(module.db.nowData.heal) do
			local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
			if owner then
				sourceGUID = owner
			end
			if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[sourceGUID] then
				for destGUID,destData in pairs(sourceData) do
					local isEnemy = not ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[destGUID])
					if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
						if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
							local inDamagePos = ExRT.F.table_find(heal,destGUID,1)
							if not inDamagePos then
								inDamagePos = #heal + 1
								heal[inDamagePos] = {destGUID,0,0,0,0,0,0,0,{}}
							end
							local sourcePos = ExRT.F.table_find(heal[inDamagePos][9],sourceGUID,1)
							if not sourcePos then
								sourcePos = #heal[inDamagePos][9] + 1
								heal[inDamagePos][9][sourcePos] = {sourceGUID,0}
							end
							sourcePos = heal[inDamagePos][9][sourcePos]

							for spellID,spellAmount in pairs(destData) do
								if spellID == 98021 then	--Spirit Link
									spellAmount = HealingTab_Variables.NULLSpellAmount
								end
								heal[inDamagePos][2] = heal[inDamagePos][2] + spellAmount.amount - spellAmount.over + spellAmount.absorbed
								heal[inDamagePos][3] = heal[inDamagePos][3] + spellAmount.amount 						--total
								heal[inDamagePos][4] = heal[inDamagePos][4] + spellAmount.over 							--overheal
								heal[inDamagePos][5] = heal[inDamagePos][5] + spellAmount.absorbed 						--absorbed
								if HealingTab_Variables.ShowOverheal then
									heal[inDamagePos][6] = heal[inDamagePos][6] + spellAmount.crit
									heal[inDamagePos][7] = heal[inDamagePos][7] + spellAmount.ms
								else
									heal[inDamagePos][6] = heal[inDamagePos][6] + spellAmount.crit - spellAmount.critover
									heal[inDamagePos][7] = heal[inDamagePos][7] + spellAmount.ms - spellAmount.msover					
								end
								heal[inDamagePos][8] = heal[inDamagePos][8] + spellAmount.absorbs						--absorbs
								total = total + spellAmount.amount - spellAmount.over + spellAmount.absorbed
								totalOver = totalOver + spellAmount.over
								
								sourcePos[2] = sourcePos[2] + spellAmount.amount + spellAmount.absorbed + (HealingTab_Variables.ShowOverheal and 0 or -spellAmount.over)
							end
						end
					end
				end
			end
		end
		local totalIsFull = 1
		total = max(total,1)
		if total == 1 and #heal == 0 then
			total = 0
			totalIsFull = 0
		end
		local _max = nil
		reportOptions[2] = L.BossWatcherReportHPS
		wipe(reportData[2])
		reportData[2][1] = (DamageTab_GetGUIDsReport(HsourceVar) or L.BossWatcherAllSources).." > "..(DamageTab_GetGUIDsReport(HdestVar) or L.BossWatcherAllTargets)
		
		local activeFightLength = GetFightLength()
		if HealingTab_Variables.ShowOverheal then
			total = total + totalOver
			sort(heal,function(a,b) return (a[2]+a[4])>(b[2]+b[4]) end)
			_max = heal[1] and (heal[1][2]+heal[1][4]) or 0
		else
			sort(heal,function(a,b) return a[2]>b[2] end)
			_max = heal[1] and heal[1][2] or 0
		end
		reportData[2][2] = L.BossWatcherReportTotal.." - "..ExRT.F.shortNumber(total).."@1@ ("..floor(total / activeFightLength)..")@1#"
		HealingTab_SetLine({
			line = 1,
			name = L.BossWatcherReportTotal,
			num = total,
			total = total,
			max = total,
			alpha = HealingTab_Variables.ShowOverheal and totalOver,
			dps = total / activeFightLength,
			spellID = -1,
			check = BWInterfaceFrame.GraphFrame:IsShown(),
			checkState = true,
		})
		for i=1,#heal do
			local class = nil
			if heal[i][1] and heal[i][1] ~= "" then
				class = select(2,GetPlayerInfoByGUID(heal[i][1]))
			end
			local icon = ""
			if class and CLASS_ICON_TCOORDS[class] then
				icon = {"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",unpack(CLASS_ICON_TCOORDS[class])}
			end
			local tooltipData = {GetGUID(heal[i][1]),
				{L.BossWatcherHealTooltipOver,format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][4]),heal[i][4]/max(heal[i][2]+heal[i][4],1)*100)},
				{L.BossWatcherHealTooltipAbsorbed,ExRT.F.shortNumber(heal[i][5])},
				{L.BossWatcherHealTooltipTotal,ExRT.F.shortNumber(heal[i][3])},
				{" "," "},
				{L.BossWatcherHealTooltipFromCrit,format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][6]),heal[i][6]/max(1,heal[i][2]+(HealingTab_Variables.ShowOverheal and heal[i][4] or 0))*100)},
				{L.BossWatcherHealTooltipFromMs,format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][7]),heal[i][7]/max(1,heal[i][2]+(HealingTab_Variables.ShowOverheal and heal[i][4] or 0))*100)},
				{ACTION_SPELL_MISSED_ABSORB,format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][8]),heal[i][8]/max(heal[i][2]+(HealingTab_Variables.ShowOverheal and heal[i][4] or 0),1)*100)},
			}
			sort(heal[i][9],DamageTab_Temp_SortingBy2Param)
			if #heal[i][9] > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherHealTooltipSources," "}
			end
			for j=1,min(5,#heal[i][9]) do
				tooltipData[#tooltipData + 1] = {SubUTF8String(GetGUID(heal[i][9][j][1]),20)..GUIDtoText(" [%s]",heal[i][9][j][1]),format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][9][j][2]),min(heal[i][9][j][2] / max(1,heal[i][2]+(HealingTab_Variables.ShowOverheal and (heal[i][4]) or 0))*100,100))}
			end
			
			local currHealing = heal[i][2]+(HealingTab_Variables.ShowOverheal and heal[i][4] or 0)
			local hps = currHealing/activeFightLength
			HealingTab_SetLine({
				line = i+1,
				icon = icon,
				name = GetGUID(heal[i][1])..GUIDtoText(" [%s]",heal[i][1]),
				num = currHealing,
				total = total,
				max = _max,
				alpha = HealingTab_Variables.ShowOverheal and heal[i][4] or heal[i][8],
				dps = hps,
				class = class,
				sourceGUID = heal[i][1],
				doEnemy = doEnemy,
				isTargetLine = true,
				tooltip = tooltipData,
				check = BWInterfaceFrame.GraphFrame:IsShown(),
				checkState = i <= 3,
			})
			reportData[2][#reportData[2]+1] = i..". "..GetGUID(heal[i][1]).." - "..ExRT.F.shortNumber(currHealing).."@1@ ("..floor(hps)..")@1#"
		end
		for i=#heal+2,#BWInterfaceFrame.tab.tabs[2].lines do
			BWInterfaceFrame.tab.tabs[2].lines[i]:Hide()
		end
		BWInterfaceFrame.tab.tabs[2].scroll:Height((#heal+1) * 20)
		
		
		if not BWInterfaceFrame.GraphFrame:IsShown() then
			return
		end
		local graph = {[-1]={}}
		local currFight = module.db.data[module.db.nowNum]
		local maxFight = #module.db.data[module.db.nowNum].fight
		for seg=1,maxFight do
			for sourceGUID,sourceData in pairs(currFight.fight[seg].heal) do
				local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
				if owner then
					sourceGUID = owner
				end
				if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[sourceGUID] then
					for destGUID,destData in pairs(sourceData) do
						local isEnemy = not ExRT.F.UnitIsFriendlyByUnitFlag2(currFight.reaction[destGUID])
						if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
							if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
								if not graph[ destGUID ] then
									graph[ destGUID ] = {}
								end
								if not graph[ destGUID ][seg] then
									graph[ destGUID ][seg] = 0
								end
								if not graph[ -1 ][seg] then
									graph[ -1 ][seg] = 0
								end
								for spellID,spellAmount in pairs(destData) do
									if spellID == 98021 then	--Spirit Link
										spellAmount = HealingTab_Variables.NULLSpellAmount
									end
									local healCount = spellAmount.amount - (HealingTab_Variables.ShowOverheal and 0 or spellAmount.over) + spellAmount.absorbed
									graph[ destGUID ][seg] = graph[ destGUID ][seg] + healCount
									graph[ -1 ][seg] = graph[ -1 ][seg] + healCount
								end
							end
						end
					end
				end
			end
		end
		HealingTab_ReloadGraph(graph,maxFight,heal,false)
	end
	local function HealingTab_UpdateLinesFromSpells()
		HealingTab_UpdateDropDownSource()
		HealingTab_UpdateDropDownDest()
		HealingTab_UpdateDropDownType(6)
		HealingTab_Variables.Last_Func = HealingTab_UpdateLinesFromSpells
		HealingTab_Variables.Back_Func = HealingTab_UpdateLinesFromSpells
		HealingTab_Variables.Back_sourceVar = nil
		HealingTab_Variables.Back_destVar = nil
		local doEnemy = nil
		
		local heal = {}
		local total = 0
		for sourceGUID,sourceData in pairs(module.db.nowData.healFrom) do
			local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
			if owner then
				sourceGUID = owner
			end
			if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[sourceGUID] then
				for destGUID,destData in pairs(sourceData) do
					local isEnemy = not ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[destGUID])
					if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
						if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
							for spellID,spellData in pairs(destData) do
								for fromSpellID,fromSpellAmount in pairs(spellData) do
									local inDamagePos = ExRT.F.table_find(heal,fromSpellID,1)
									if not inDamagePos then
										inDamagePos = #heal + 1
										heal[inDamagePos] = {fromSpellID,0,{},{}}
									end
									local destPos = ExRT.F.table_find(heal[inDamagePos][3],destGUID,1)
									if not destPos then
										destPos = #heal[inDamagePos][3] + 1
										heal[inDamagePos][3][destPos] = {destGUID,0}
									end
									destPos = heal[inDamagePos][3][destPos]
									
									local sourcePos = ExRT.F.table_find(heal[inDamagePos][4],sourceGUID,1)
									if not sourcePos then
										sourcePos = #heal[inDamagePos][4] + 1
										heal[inDamagePos][4][sourcePos] = {sourceGUID,0}
									end
									sourcePos = heal[inDamagePos][4][sourcePos]
									
									heal[inDamagePos][2] = heal[inDamagePos][2] + fromSpellAmount
									total = total + fromSpellAmount
									destPos[2] = destPos[2] + fromSpellAmount
									sourcePos[2] = sourcePos[2] + fromSpellAmount
								end
							end
						end
					end
				end
			end
		end
		
		local totalIsFull = 1
		total = max(total,1)
		if total == 1 and #heal == 0 then
			total = 0
			totalIsFull = 0
		end
		local _max = nil
		reportOptions[2] = L.BossWatcherReportHPS
		wipe(reportData[2])
		reportData[2][1] = (DamageTab_GetGUIDsReport(HsourceVar) or L.BossWatcherAllSources).." > "..(DamageTab_GetGUIDsReport(HdestVar) or L.BossWatcherAllTargets)
		local activeFightLength = GetFightLength()
		do
			local hps = total / activeFightLength
			reportData[2][2] = L.BossWatcherReportTotal.." - "..ExRT.F.shortNumber(total).."@1@ ("..floor(hps)..")@1#"
			sort(heal,function(a,b) return a[2]>b[2] end)
			_max = heal[1] and heal[1][2] or 0
			HealingTab_SetLine({
				line = 1,
				name = L.BossWatcherReportTotal,
				num = total,
				total = total,
				max = total,
				dps = hps,
				spellID = -1,
				check = BWInterfaceFrame.GraphFrame:IsShown(),
				checkState = true,
			})
		end
		for i=1,#heal do
			local spellName,_,spellIcon = GetSpellInfo(heal[i][1])
			local school = module.db.spellsSchool[ heal[i][1] ] or 0
			local tooltipData = {
				{spellName,spellIcon},
				{L.BossWatcherHealTooltipTotal,ExRT.F.shortNumber(heal[i][2])},
				{L.BossWatcherSchool,GetSchoolName(school)},
			}
			sort(heal[i][3],DamageTab_Temp_SortingBy2Param)
			if #heal[i][3] > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherHealTooltipTargets," "}
			end
			for j=1,min(5,#heal[i][3]) do
				tooltipData[#tooltipData + 1] = {SubUTF8String(GetGUID(heal[i][3][j][1]),20)..GUIDtoText(" [%s]",heal[i][3][j][1]),format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][3][j][2]),min(heal[i][3][j][2] / max(1,heal[i][2])*100,100))}
			end
			sort(heal[i][4],DamageTab_Temp_SortingBy2Param)
			if #heal[i][4] > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherHealTooltipSources," "}
			end
			for j=1,min(5,#heal[i][4]) do
				tooltipData[#tooltipData + 1] = {SubUTF8String(GetGUID(heal[i][4][j][1]),20)..GUIDtoText(" [%s]",heal[i][4][j][1]),format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][4][j][2]),min(heal[i][4][j][2] / max(1,heal[i][2])*100,100))}
			end
			do
				local hps = heal[i][2]/activeFightLength
				HealingTab_SetLine({
					line = i+1,
					icon = spellIcon,
					name = spellName,
					total = total,
					num = heal[i][2],
					max = _max,
					dps = hps,
					spellID = heal[i][1],
					tooltip = tooltipData,
					school = school,
					check = BWInterfaceFrame.GraphFrame:IsShown(),
					checkState = i <= 3,
				})
				reportData[2][#reportData[2]+1] = i..". "..GetSpellLink(heal[i][1]).." - "..ExRT.F.shortNumber(heal[i][2]).."@1@ ("..floor(hps)..")@1#"
			end
		end
		for i=#heal+2,#BWInterfaceFrame.tab.tabs[2].lines do
			BWInterfaceFrame.tab.tabs[2].lines[i]:Hide()
		end
		BWInterfaceFrame.tab.tabs[2].scroll:Height((#heal+1) * 20)
		
		
		if not BWInterfaceFrame.GraphFrame:IsShown() then
			return
		end

		local graph = {[-1]={}}
		local currFight = module.db.data[module.db.nowNum]
		local maxFight = #module.db.data[module.db.nowNum].fight
		for seg=1,maxFight do
			for sourceGUID,sourceData in pairs(currFight.fight[seg].healFrom) do
				local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
				if owner then
					sourceGUID = owner
				end
				if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[sourceGUID] then
					for destGUID,destData in pairs(sourceData) do
						local isEnemy = not ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[destGUID])
						if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
							if (isEnemy and doEnemy) or (not isEnemy and not doEnemy) then
								for spellID,spellData in pairs(destData) do
									for fromSpellID,fromSpellAmount in pairs(spellData) do
										if owner then
											fromSpellID = -fromSpellID
										end
										if not graph[ fromSpellID ] then
											graph[ fromSpellID ] = {}
										end
										if not graph[ fromSpellID ][seg] then
											graph[ fromSpellID ][seg] = 0
										end
										if not graph[ -1 ][seg] then
											graph[ -1 ][seg] = 0
										end

										graph[ fromSpellID ][seg] = graph[ fromSpellID ][seg] + fromSpellAmount
										graph[ -1 ][seg] = graph[ -1 ][seg] + fromSpellAmount
									end
								end
							end
						end
					end
				end
			end
		end
		HealingTab_ReloadGraph(graph,maxFight,heal,true)
	end
	
	
	local function HealingTab_UpdateLinesReductions()
		HealingTab_UpdateDropDownSource()
		HealingTab_UpdateDropDownDest()
		HealingTab_UpdateDropDownType(4)
		HealingTab_Variables.Last_Func = HealingTab_UpdateLinesReductions
		HealingTab_Variables.Back_Func = HealingTab_UpdateLinesReductions
		HealingTab_Variables.Back_sourceVar = nil
		HealingTab_Variables.Back_destVar = nil
		BWInterfaceFrame.tab.tabs[2].showOverhealChk.tooltipText = L.BossWatcherHealReductionChkTooltip
		local heal = {}
		local total = 0
		local totalOver = 0
		for destGUID,destData in pairs(module.db.nowData.reduction) do
			if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
				for sourceGUID,sourceData in pairs(destData) do
					for spellID,spellData in pairs(sourceData) do
						for reductorGUID,reductorData in pairs(spellData) do
							local owner = ExRT.F.Pets:getOwnerGUID(reductorGUID,GetPetsDB())
							if owner then
								reductorGUID = owner
							end
							if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[reductorGUID] then
								local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[reductorGUID])
								if isFriendly then
									local inDamagePos = ExRT.F.table_find(heal,reductorGUID,1)
									if not inDamagePos then
										inDamagePos = #heal + 1
										heal[inDamagePos] = {reductorGUID,0,{},0,{}}
									end
									
									local destPos = ExRT.F.table_find(heal[inDamagePos][3],destGUID,1)
									if not destPos then
										destPos = #heal[inDamagePos][3] + 1
										heal[inDamagePos][3][destPos] = {destGUID,0}
									end
									destPos = heal[inDamagePos][3][destPos]
									
									local fromSpellPos = ExRT.F.table_find(heal[inDamagePos][5],spellID,1)
									if not fromSpellPos then
										fromSpellPos = #heal[inDamagePos][5] + 1
										heal[inDamagePos][5][fromSpellPos] = {spellID,0}
									end
									fromSpellPos = heal[inDamagePos][5][fromSpellPos]
									
									for reductionSpellID,reductionSpellAmount in pairs(reductorData) do
										heal[inDamagePos][2] = heal[inDamagePos][2] + reductionSpellAmount
										total = total + reductionSpellAmount
										destPos[2] = destPos[2] + reductionSpellAmount
										fromSpellPos[2] = fromSpellPos[2] + reductionSpellAmount
									end
								end
							end
						end
					end
				end
			end
		end
		
		if HealingTab_Variables.ShowOverheal then
			local missData = {}
			local avgDamage = {}
			for destGUID,destData in pairs(module.db.nowData.damage) do
				for sourceGUID,sourceData in pairs(destData) do
					local avgData = avgDamage[sourceGUID]
					if not avgData then
						avgData = {}
						avgDamage[sourceGUID] = avgData
					end
					for spellID,spellAmount in pairs(sourceData) do
						local avgSpell = avgData[spellID]
						if not avgSpell then
							avgSpell = {0,0}
							avgData[spellID] = avgSpell
						end
						
						avgSpell[1] = avgSpell[1] + spellAmount.count
						avgSpell[2] = avgSpell[2] + spellAmount.amount + spellAmount.blocked + spellAmount.absorbed
						
						if spellAmount.parry > 0 or spellAmount.dodge > 0 or spellAmount.miss > 0 then
							local missDestData = missData[destGUID]
							if not missDestData then
								missDestData = {}
								missData[destGUID] = missDestData
							end
							local missSpell = missDestData[sourceGUID]
							if not missSpell then
								missSpell = {}
								missDestData[sourceGUID] = missSpell
							end
							missSpell[spellID] = {
								parry = spellAmount.parry,
								dodge = spellAmount.dodge,
								miss = spellAmount.miss,
							}
						end
					end
				end
			end
			for destGUID,destData in pairs(missData) do
				local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[destGUID] or 0)
				if isFriendly and (ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[destGUID]) then
					for sourceGUID,sourceData in pairs(destData) do
						for spellID,spellAmount in pairs(sourceData) do
							local avgData = avgDamage[ sourceGUID ][ spellID ]
							local avg = avgData[3]
							if not avg then
								if avgData[1] > 0 then
									avg = avgData[2] / avgData[1]
								else
									avg = 0
								end
								avgData[3] = avg
							end
							if avg > 0 then
								local inDamagePos = ExRT.F.table_find(heal,destGUID,1)
								if not inDamagePos then
									inDamagePos = #heal + 1
									heal[inDamagePos] = {destGUID,0,{},0,{}}
								end
								
								local destPos = ExRT.F.table_find(heal[inDamagePos][3],destGUID,1)
								if not destPos then
									destPos = #heal[inDamagePos][3] + 1
									heal[inDamagePos][3][destPos] = {destGUID,0}
								end
								destPos = heal[inDamagePos][3][destPos]
								
								local fromSpellPos = ExRT.F.table_find(heal[inDamagePos][5],spellID,1)
								if not fromSpellPos then
									fromSpellPos = #heal[inDamagePos][5] + 1
									heal[inDamagePos][5][fromSpellPos] = {spellID,0}
								end
								fromSpellPos = heal[inDamagePos][5][fromSpellPos]
								
								local amount = avg * (spellAmount.dodge + spellAmount.parry + spellAmount.miss)
							
								heal[inDamagePos][2] = heal[inDamagePos][2] + amount
								heal[inDamagePos][4] = heal[inDamagePos][4] + amount
								total = total + amount
								destPos[2] = destPos[2] + amount
								fromSpellPos[2] = fromSpellPos[2] + amount
							end
						end
					end
				end
			end
		end
		
		local totalIsFull = 1
		total = max(total,1)
		if total == 1 and #heal == 0 then
			total = 0
			totalIsFull = 0
		end
		local _max = nil
		reportOptions[2] = L.BossWatcherReportHPS
		wipe(reportData[2])
		reportData[2][1] = (DamageTab_GetGUIDsReport(HsourceVar) or L.BossWatcherAllSources).." > "..(DamageTab_GetGUIDsReport(HdestVar) or L.BossWatcherAllTargets)
		local activeFightLength = GetFightLength()
		
		local hps = total / activeFightLength
		reportData[2][2] = L.BossWatcherReportTotal.." - "..ExRT.F.shortNumber(total).."@1@ ("..floor(hps)..")@1#"
		sort(heal,function(a,b) return a[2]>b[2] end)
		_max = heal[1] and heal[1][2] or 0
		HealingTab_SetLine({
			line = 1,
			name = L.BossWatcherReportTotal,
			num = total,
			total = total,
			max = total,
			dps = hps,
			spellID = -1,
			check = BWInterfaceFrame.GraphFrame:IsShown(),
			checkState = true,
		})
		
		for i=1,#heal do
			local class = nil
			if heal[i][1] and heal[i][1] ~= "" then
				class = select(2,GetPlayerInfoByGUID(heal[i][1]))
			end
			local icon = ""
			if class and CLASS_ICON_TCOORDS[class] then
				icon = {"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",unpack(CLASS_ICON_TCOORDS[class])}
			end
			local tooltipData = {GetGUID(heal[i][1])}
			sort(heal[i][3],DamageTab_Temp_SortingBy2Param)
			if #heal[i][3] > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherHealTooltipTargets," "}
			end
			for j=1,min(5,#heal[i][3]) do
				tooltipData[#tooltipData + 1] = {SubUTF8String(GetGUID(heal[i][3][j][1]),20)..GUIDtoText(" [%s]",heal[i][3][j][1]),format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][3][j][2]),min(heal[i][3][j][2] / max(1,heal[i][2])*100,100))}
			end
			sort(heal[i][5],DamageTab_Temp_SortingBy2Param)
			if #heal[i][5] > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherFromSpells..":"," "}
			end
			for j=1,min(5,#heal[i][5]) do
				local spellName,_,spellTexture = GetSpellInfo(heal[i][5][j][1])
				tooltipData[#tooltipData + 1] = {(spellTexture and "|T"..spellTexture..":0|t" or "")..(spellName or "spell:"..spellName),format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][5][j][2]),min(heal[i][5][j][2] / max(1,heal[i][2])*100,100))}
			end
			local hps = heal[i][2]/activeFightLength
			HealingTab_SetLine({
				line = i+1,
				icon = icon,
				name = GetGUID(heal[i][1])..GUIDtoText(" [%s]",heal[i][1]),
				num = heal[i][2],
				total = total,
				max = _max,
				alpha = HealingTab_Variables.ShowOverheal and heal[i][4],
				dps = hps,
				class = class,
				sourceGUID = heal[i][1],
				tooltip = tooltipData,
				isReduction = true,
				check = BWInterfaceFrame.GraphFrame:IsShown(),
				checkState = i <= 3,
			})
			reportData[2][#reportData[2]+1] = i..". "..GetGUID(heal[i][1]).." - "..ExRT.F.shortNumber(heal[i][2]).."@1@ ("..floor(hps)..")@1#"
		end
		for i=#heal+2,#BWInterfaceFrame.tab.tabs[2].lines do
			BWInterfaceFrame.tab.tabs[2].lines[i]:Hide()
		end
		BWInterfaceFrame.tab.tabs[2].scroll:Height((#heal+1) * 20)
		
		if not BWInterfaceFrame.GraphFrame:IsShown() then
			return
		end

		local graph = {[-1]={}}
		local currFight = module.db.data[module.db.nowNum]
		local maxFight = #module.db.data[module.db.nowNum].fight
		for seg=1,maxFight do
			for destGUID,destData in pairs(currFight.fight[seg].reduction) do
				if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
					for sourceGUID,sourceData in pairs(destData) do
						for spellID,spellData in pairs(sourceData) do
							for reductorGUID,reductorData in pairs(spellData) do
								local owner = ExRT.F.Pets:getOwnerGUID(reductorGUID,GetPetsDB())
								if owner then
									reductorGUID = owner
								end
								if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[reductorGUID] then
									local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(currFight.reaction[reductorGUID])
									if isFriendly then
										if not graph[ reductorGUID ] then
											graph[ reductorGUID ] = {}
										end
										if not graph[ reductorGUID ][seg] then
											graph[ reductorGUID ][seg] = 0
										end
										if not graph[ -1 ][seg] then
											graph[ -1 ][seg] = 0
										end
										for reductionSpellID,reductionSpellAmount in pairs(reductorData) do
											graph[ reductorGUID ][seg] = graph[ reductorGUID ][seg] + reductionSpellAmount
											graph[ -1 ][seg] = graph[ -1 ][seg] + reductionSpellAmount
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if HealingTab_Variables.ShowOverheal then
			local missData = {}
			local avgDamage = {}
			for seg=1,maxFight do
				for destGUID,destData in pairs(currFight.fight[seg].damage) do
					for sourceGUID,sourceData in pairs(destData) do
						local avgData = avgDamage[sourceGUID]
						if not avgData then
							avgData = {}
							avgDamage[sourceGUID] = avgData
						end
						for spellID,spellAmount in pairs(sourceData) do
							local avgSpell = avgData[spellID]
							if not avgSpell then
								avgSpell = {0,0}
								avgData[spellID] = avgSpell
							end
							
							avgSpell[1] = avgSpell[1] + spellAmount.count
							avgSpell[2] = avgSpell[2] + spellAmount.amount + spellAmount.blocked + spellAmount.absorbed
							
							if spellAmount.parry > 0 or spellAmount.dodge > 0 or spellAmount.miss > 0 then
								local missDestData = missData[destGUID]
								if not missDestData then
									missDestData = {}
									missData[destGUID] = missDestData
								end
								local missSpell = missDestData[sourceGUID]
								if not missSpell then
									missSpell = {}
									missDestData[sourceGUID] = missSpell
								end
								local missSeg = missSpell[spellID]
								if not missSeg then
									missSeg = {}
									missSpell[spellID] = missSeg
								end
								missSeg[seg] = {
									parry = spellAmount.parry,
									dodge = spellAmount.dodge,
									miss = spellAmount.miss,
								}
							end
						end
					end
				end
			end
			local reductionMissToSpell = {
				dodge = 81,
				parry = 82243,
				miss = 154592,
			}
			for destGUID,destData in pairs(missData) do
				local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[destGUID] or 0)
				if isFriendly and (ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[destGUID]) then
					for sourceGUID,sourceData in pairs(destData) do
						for spellID,spellSegments in pairs(sourceData) do
							local avgData = avgDamage[ sourceGUID ][ spellID ]
							local avg = avgData[3]
							if not avg then
								if avgData[1] > 0 then
									avg = avgData[2] / avgData[1]
								else
									avg = 0
								end
								avgData[3] = avg
							end
							if avg > 0 then
								for reductionName,reductionSpellID in pairs(reductionMissToSpell) do
									for seg=1,maxFight do
										if spellSegments[seg] and spellSegments[seg][reductionName] > 0 then
											local amount = avg * spellSegments[seg][reductionName]
										
											if not graph[ destGUID ] then
												graph[ destGUID ] = {}
											end
											if not graph[ destGUID ][seg] then
												graph[ destGUID ][seg] = 0
											end
											if not graph[ -1 ][seg] then
												graph[ -1 ][seg] = 0
											end
											graph[ destGUID ][seg] = graph[ destGUID ][seg] + amount
											graph[ -1 ][seg] = graph[ -1 ][seg] + amount
										end
									end
								end
							end
						end
					end
				end
			end
		end
		
		HealingTab_ReloadGraph(graph,maxFight,heal,false)
	end
	local function HealingTab_UpdateLinesReductionsSpells()
		HealingTab_UpdateDropDownSource()
		HealingTab_UpdateDropDownDest()
		HealingTab_UpdateDropDownType(4,true)
		HealingTab_Variables.Last_Func = HealingTab_UpdateLinesReductionsSpells
		HealingTab_Variables.Back_Func = HealingTab_UpdateLinesReductionsSpells
		HealingTab_Variables.Back_sourceVar = nil
		HealingTab_Variables.Back_destVar = nil
		BWInterfaceFrame.tab.tabs[2].showOverhealChk.tooltipText = L.BossWatcherHealReductionChkTooltip
		local heal = {}
		local total = 0
		local totalOver = 0
		for destGUID,destData in pairs(module.db.nowData.reduction) do
			if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
				for sourceGUID,sourceData in pairs(destData) do
					for spellID,spellData in pairs(sourceData) do
						for reductorGUID,reductorData in pairs(spellData) do
							local owner = ExRT.F.Pets:getOwnerGUID(reductorGUID,GetPetsDB())
							if owner then
								reductorGUID = owner
							end
							if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[reductorGUID] then
								local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[reductorGUID])
								if isFriendly then
									for reductionSpellID,reductionSpellAmount in pairs(reductorData) do
										if owner then
											reductionSpellID = -reductionSpellID
										end
									
										local inDamagePos = ExRT.F.table_find(heal,reductionSpellID,1)
										if not inDamagePos then
											inDamagePos = #heal + 1
											heal[inDamagePos] = {reductionSpellID,0,{},0,{}}
										end
										
										local destPos = ExRT.F.table_find(heal[inDamagePos][3],destGUID,1)
										if not destPos then
											destPos = #heal[inDamagePos][3] + 1
											heal[inDamagePos][3][destPos] = {destGUID,0}
										end
										destPos = heal[inDamagePos][3][destPos]
										
										local fromSpellPos = ExRT.F.table_find(heal[inDamagePos][5],spellID,1)
										if not fromSpellPos then
											fromSpellPos = #heal[inDamagePos][5] + 1
											heal[inDamagePos][5][fromSpellPos] = {spellID,0}
										end
										fromSpellPos = heal[inDamagePos][5][fromSpellPos]
									
										heal[inDamagePos][2] = heal[inDamagePos][2] + reductionSpellAmount
										total = total + reductionSpellAmount
										destPos[2] = destPos[2] + reductionSpellAmount
										fromSpellPos[2] = fromSpellPos[2] + reductionSpellAmount
									end
								end
							end
						end
					end
				end
			end
		end
		
		if HealingTab_Variables.ShowOverheal then
			local missData = {}
			local avgDamage = {}
			for destGUID,destData in pairs(module.db.nowData.damage) do
				for sourceGUID,sourceData in pairs(destData) do
					local avgData = avgDamage[sourceGUID]
					if not avgData then
						avgData = {}
						avgDamage[sourceGUID] = avgData
					end
					for spellID,spellAmount in pairs(sourceData) do
						local avgSpell = avgData[spellID]
						if not avgSpell then
							avgSpell = {0,0}
							avgData[spellID] = avgSpell
						end
						
						avgSpell[1] = avgSpell[1] + spellAmount.count
						avgSpell[2] = avgSpell[2] + spellAmount.amount + spellAmount.blocked + spellAmount.absorbed
						
						if spellAmount.parry > 0 or spellAmount.dodge > 0 or spellAmount.miss > 0 then
							local missDestData = missData[destGUID]
							if not missDestData then
								missDestData = {}
								missData[destGUID] = missDestData
							end
							local missSpell = missDestData[sourceGUID]
							if not missSpell then
								missSpell = {}
								missDestData[sourceGUID] = missSpell
							end
							missSpell[spellID] = {
								parry = spellAmount.parry,
								dodge = spellAmount.dodge,
								miss = spellAmount.miss,
							}
						end
					end
				end
			end
			local reductionMissToSpell = {
				dodge = 81,
				parry = 82243,
				miss = 154592,
			}
			for destGUID,destData in pairs(missData) do
				local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[destGUID] or 0)
				if isFriendly and (ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[destGUID]) then
					for sourceGUID,sourceData in pairs(destData) do
						for spellID,spellAmount in pairs(sourceData) do
							local avgData = avgDamage[ sourceGUID ][ spellID ]
							local avg = avgData[3]
							if not avg then
								if avgData[1] > 0 then
									avg = avgData[2] / avgData[1]
								else
									avg = 0
								end
								avgData[3] = avg
							end
							if avg > 0 then
								for reductionName,reductionSpellID in pairs(reductionMissToSpell) do
									if spellAmount[reductionName] > 0 then
										local inDamagePos = ExRT.F.table_find(heal,reductionSpellID,1)
										if not inDamagePos then
											inDamagePos = #heal + 1
											heal[inDamagePos] = {reductionSpellID,0,{},0,{}}
										end
										
										local destPos = ExRT.F.table_find(heal[inDamagePos][3],destGUID,1)
										if not destPos then
											destPos = #heal[inDamagePos][3] + 1
											heal[inDamagePos][3][destPos] = {destGUID,0}
										end
										destPos = heal[inDamagePos][3][destPos]
										
										local fromSpellPos = ExRT.F.table_find(heal[inDamagePos][5],spellID,1)
										if not fromSpellPos then
											fromSpellPos = #heal[inDamagePos][5] + 1
											heal[inDamagePos][5][fromSpellPos] = {spellID,0}
										end
										fromSpellPos = heal[inDamagePos][5][fromSpellPos]
									
										local amount = avg * spellAmount[reductionName]
									
										heal[inDamagePos][2] = heal[inDamagePos][2] + amount
										heal[inDamagePos][4] = heal[inDamagePos][4] + amount
										total = total + amount
										destPos[2] = destPos[2] + amount
										fromSpellPos[2] = fromSpellPos[2] + amount
									end
								end
							end
						end
					end
				end
			end
		end
		
		local totalIsFull = 1
		total = max(total,1)
		if total == 1 and #heal == 0 then
			total = 0
			totalIsFull = 0
		end
		local _max = nil
		reportOptions[2] = L.BossWatcherReportHPS
		wipe(reportData[2])
		reportData[2][1] = (DamageTab_GetGUIDsReport(HsourceVar) or L.BossWatcherAllSources).." > "..(DamageTab_GetGUIDsReport(HdestVar) or L.BossWatcherAllTargets)
		local activeFightLength = GetFightLength()
		
		local hps = total / activeFightLength
		reportData[2][2] = L.BossWatcherReportTotal.." - "..ExRT.F.shortNumber(total).."@1@ ("..floor(hps)..")@1#"
		sort(heal,function(a,b) return a[2]>b[2] end)
		_max = heal[1] and heal[1][2] or 0
		HealingTab_SetLine({
			line = 1,
			name = L.BossWatcherReportTotal,
			total = total,
			num = total,
			max = total,
			dps = hps,
			spellID = -1,
			check = BWInterfaceFrame.GraphFrame:IsShown(),
			checkState = true,
		})
		
		for i=1,#heal do
			local isPetAbility = heal[i][1] < 0
			if isPetAbility then
				heal[i][1] = -heal[i][1]
			end
			local spellName,_,spellIcon = GetSpellInfo(heal[i][1])
			if isPetAbility then
				spellName = L.BossWatcherPetText..": "..spellName
			end
			local school = module.db.spellsSchool[ heal[i][1] ] or 0
			local tooltipData = {
				{spellName,spellIcon},
				{L.BossWatcherSchool,GetSchoolName(school)},
			}
			
			sort(heal[i][3],DamageTab_Temp_SortingBy2Param)
			if #heal[i][3] > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherHealTooltipTargets," "}
			end
			for j=1,min(5,#heal[i][3]) do
				tooltipData[#tooltipData + 1] = {SubUTF8String(GetGUID(heal[i][3][j][1]),20)..GUIDtoText(" [%s]",heal[i][3][j][1]),format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][3][j][2]),min(heal[i][3][j][2] / max(1,heal[i][2])*100,100))}
			end
			sort(heal[i][5],DamageTab_Temp_SortingBy2Param)
			if #heal[i][5] > 0 then
				tooltipData[#tooltipData + 1] = {" "," "}
				tooltipData[#tooltipData + 1] = {L.BossWatcherFromSpells..":"," "}
			end
			for j=1,min(5,#heal[i][5]) do
				local spellName,_,spellTexture = GetSpellInfo(heal[i][5][j][1])
				tooltipData[#tooltipData + 1] = {(spellTexture and "|T"..spellTexture..":0|t" or "")..(spellName or "spell:"..spellName),format("%s (%.1f%%)",ExRT.F.shortNumber(heal[i][5][j][2]),min(heal[i][5][j][2] / max(1,heal[i][2])*100,100))}
			end
			local hps = heal[i][2]/activeFightLength
			HealingTab_SetLine({
				line = i+1,
				icon = spellIcon,
				name = spellName,
				total = total,
				num = heal[i][2],
				alpha = HealingTab_Variables.ShowOverheal and heal[i][4],
				max = _max,
				dps = hps,
				spellID = heal[i][1],
				tooltip = tooltipData,
				school = school,
				isPet = isPetAbility,
				check = BWInterfaceFrame.GraphFrame:IsShown(),
				checkState = i <= 3,
			})
			reportData[2][#reportData[2]+1] = i..". "..(isPetAbility and L.BossWatcherPetText..": " or "")..GetSpellLink(heal[i][1]).." - "..ExRT.F.shortNumber(heal[i][2]).."@1@ ("..floor(hps)..")@1#"

			if isPetAbility then
				heal[i][1] = -heal[i][1]
			end
		end
		for i=#heal+2,#BWInterfaceFrame.tab.tabs[2].lines do
			BWInterfaceFrame.tab.tabs[2].lines[i]:Hide()
		end
		BWInterfaceFrame.tab.tabs[2].scroll:Height((#heal+1) * 20)
		
		if not BWInterfaceFrame.GraphFrame:IsShown() then
			return
		end

		local graph = {[-1]={}}
		local currFight = module.db.data[module.db.nowNum]
		local maxFight = #module.db.data[module.db.nowNum].fight
		for seg=1,maxFight do
			for destGUID,destData in pairs(currFight.fight[seg].reduction) do
				if ExRT.F.table_len(HdestVar) == 0 or HdestVar[destGUID] then
					for sourceGUID,sourceData in pairs(destData) do
						for spellID,spellData in pairs(sourceData) do
							for reductorGUID,reductorData in pairs(spellData) do
								local owner = ExRT.F.Pets:getOwnerGUID(reductorGUID,GetPetsDB())
								if owner then
									reductorGUID = owner
								end
								if ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[reductorGUID] then
									local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(currFight.reaction[reductorGUID])
									if isFriendly then
										for reductionSpellID,reductionSpellAmount in pairs(reductorData) do
											if owner then
												reductionSpellID = -reductionSpellID
											end
											if not graph[ reductionSpellID ] then
												graph[ reductionSpellID ] = {}
											end
											if not graph[ reductionSpellID ][seg] then
												graph[ reductionSpellID ][seg] = 0
											end
											if not graph[ -1 ][seg] then
												graph[ -1 ][seg] = 0
											end
											graph[ reductionSpellID ][seg] = graph[ reductionSpellID ][seg] + reductionSpellAmount
											graph[ -1 ][seg] = graph[ -1 ][seg] + reductionSpellAmount
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if HealingTab_Variables.ShowOverheal then
			local missData = {}
			local avgDamage = {}
			for seg=1,maxFight do
				for destGUID,destData in pairs(currFight.fight[seg].damage) do
					for sourceGUID,sourceData in pairs(destData) do
						local avgData = avgDamage[sourceGUID]
						if not avgData then
							avgData = {}
							avgDamage[sourceGUID] = avgData
						end
						for spellID,spellAmount in pairs(sourceData) do
							local avgSpell = avgData[spellID]
							if not avgSpell then
								avgSpell = {0,0}
								avgData[spellID] = avgSpell
							end
							
							avgSpell[1] = avgSpell[1] + spellAmount.count
							avgSpell[2] = avgSpell[2] + spellAmount.amount + spellAmount.blocked + spellAmount.absorbed
							
							if spellAmount.parry > 0 or spellAmount.dodge > 0 or spellAmount.miss > 0 then
								local missDestData = missData[destGUID]
								if not missDestData then
									missDestData = {}
									missData[destGUID] = missDestData
								end
								local missSpell = missDestData[sourceGUID]
								if not missSpell then
									missSpell = {}
									missDestData[sourceGUID] = missSpell
								end
								local missSeg = missSpell[spellID]
								if not missSeg then
									missSeg = {}
									missSpell[spellID] = missSeg
								end
								missSeg[seg] = {
									parry = spellAmount.parry,
									dodge = spellAmount.dodge,
									miss = spellAmount.miss,
								}
							end
						end
					end
				end
			end
			local reductionMissToSpell = {
				dodge = 81,
				parry = 82243,
				miss = 154592,
			}
			for destGUID,destData in pairs(missData) do
				local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[destGUID] or 0)
				if isFriendly and (ExRT.F.table_len(HsourceVar) == 0 or HsourceVar[destGUID]) then
					for sourceGUID,sourceData in pairs(destData) do
						for spellID,spellSegments in pairs(sourceData) do
							local avgData = avgDamage[ sourceGUID ][ spellID ]
							local avg = avgData[3]
							if not avg then
								if avgData[1] > 0 then
									avg = avgData[2] / avgData[1]
								else
									avg = 0
								end
								avgData[3] = avg
							end
							if avg > 0 then
								for reductionName,reductionSpellID in pairs(reductionMissToSpell) do
									for seg=1,maxFight do
										if spellSegments[seg] and spellSegments[seg][reductionName] > 0 then
											local amount = avg * spellSegments[seg][reductionName]
										
											if not graph[ reductionSpellID ] then
												graph[ reductionSpellID ] = {}
											end
											if not graph[ reductionSpellID ][seg] then
												graph[ reductionSpellID ][seg] = 0
											end
											if not graph[ -1 ][seg] then
												graph[ -1 ][seg] = 0
											end
											graph[ reductionSpellID ][seg] = graph[ reductionSpellID ][seg] + amount
											graph[ -1 ][seg] = graph[ -1 ][seg] + amount
										end
									end
								end
							end
						end
					end
				end
			end
		end
		HealingTab_ReloadGraph(graph,maxFight,heal,true)
	end

	
	local function HealingTab_SelectDropDownSource(self,arg,doEnemy,doSpells,isReduction_isFromSpells)
		local Back_destVar = ExRT.F.table_copy2(HdestVar)
		local Back_sourceVar = ExRT.F.table_copy2(HsourceVar)
		wipe(HsourceVar)
		ELib:DropDownClose()
		if arg then
			HsourceVar[arg] = true
			
			if IsShiftKeyDown() then
				local name = module.db.data[module.db.nowNum].guids[arg]
				if name then
					for GUID,GUIDname in pairs(module.db.data[module.db.nowNum].guids) do
						if GUIDname == name then
							HsourceVar[GUID] = true
						end
					end
				end
			end
		end
		if isReduction_isFromSpells == -1 then
			HealingTab_UpdateLinesFromSpells()
			HealingTab_Variables.Back_destVar = Back_destVar
			HealingTab_Variables.Back_sourceVar = Back_sourceVar
			return
		end
		if isReduction_isFromSpells then
			if not doSpells then
				if isReduction_isFromSpells == 2 then
					HealingTab_UpdateLinesPlayers(false,true)
				else
					HealingTab_UpdateLinesReductions()
				end
			else
				if isReduction_isFromSpells == 2 then
					HealingTab_UpdateLinesSpell(false,true)
				else
					HealingTab_UpdateLinesReductionsSpells()
				end
			end
			HealingTab_Variables.Back_destVar = Back_destVar
			HealingTab_Variables.Back_sourceVar = Back_sourceVar
			return
		end
		if not doSpells then
			if ExRT.F.table_len(HdestVar) == 0 then
				if ExRT.F.table_len(HsourceVar) ~= 0 then
					HealingTab_UpdateLinesTargets(doEnemy)
				else
					HealingTab_UpdateLinesPlayers(doEnemy)
				end
			else
				if ExRT.F.table_len(HsourceVar) ~= 0 then
					HealingTab_UpdateLinesSpell(doEnemy)
				else
					HealingTab_UpdateLinesPlayers(doEnemy)
				end
			end
		else
			HealingTab_UpdateLinesSpell(doEnemy)
		end
		HealingTab_Variables.Back_destVar = Back_destVar
		HealingTab_Variables.Back_sourceVar = Back_sourceVar
	end
	local function HealingTab_SelectDropDownDest(self,arg,doEnemy,doSpells,isReduction_isFromSpells)
		ELib:DropDownClose()
		local Back_destVar = ExRT.F.table_copy2(HdestVar)
		local Back_sourceVar = ExRT.F.table_copy2(HsourceVar)
		wipe(HdestVar)
		if arg then
			HdestVar[arg] = true
			
			if IsShiftKeyDown() then
				local name = module.db.data[module.db.nowNum].guids[arg]
				if name then
					for GUID,GUIDname in pairs(module.db.data[module.db.nowNum].guids) do
						if GUIDname == name then
							HdestVar[GUID] = true
						end
					end
				end
			end
		end
		if isReduction_isFromSpells == -1 then
			HealingTab_UpdateLinesFromSpells()
			HealingTab_Variables.Back_destVar = Back_destVar
			HealingTab_Variables.Back_sourceVar = Back_sourceVar
			return
		end
		if isReduction_isFromSpells then
			if not doSpells then
				if isReduction_isFromSpells == 2 then
					HealingTab_UpdateLinesPlayers(false,true)
				else
					HealingTab_UpdateLinesReductions()
				end
			else
				if isReduction_isFromSpells == 2 then
					HealingTab_UpdateLinesSpell(false,true)
				else
					HealingTab_UpdateLinesReductionsSpells()
				end
			end
			HealingTab_Variables.Back_destVar = Back_destVar
			HealingTab_Variables.Back_sourceVar = Back_sourceVar
			return
		end
		if not doSpells then
			HealingTab_UpdateLinesPlayers(doEnemy)
			if ExRT.F.table_len(HsourceVar) == 0 then
				HealingTab_UpdateLinesPlayers(doEnemy)
			else
				if ExRT.F.table_len(HdestVar) ~= 0 then
					HealingTab_UpdateLinesSpell(doEnemy)
				else
					HealingTab_UpdateLinesTargets(doEnemy)
				end
			end
		else
			HealingTab_UpdateLinesSpell(doEnemy)
		end
		HealingTab_Variables.Back_destVar = Back_destVar
		HealingTab_Variables.Back_sourceVar = Back_sourceVar
	end
	
	local function HealingTab_CheckDropDownSource(self,checked)
		if checked then
			HsourceVar[self.arg1] = true
		else
			HsourceVar[self.arg1] = nil
		end
		HealingTab_Variables.Last_Func(self.arg2)
	end
	local function HealingTab_CheckDropDownDest(self,checked)
		if checked then
			HdestVar[self.arg1] = true
		else
			HdestVar[self.arg1] = nil
		end
		HealingTab_Variables.Last_Func(self.arg2)
	end

	local function HealingTab_HPS(doEnemy,doSpells,doNotUpdateLines,isFromSpells)		
		local sourceTable = {}
		local destTable = {}
		for sourceGUID,sourceData in pairs(module.db.nowData.heal) do	
			local owner = ExRT.F.Pets:getOwnerGUID(sourceGUID,GetPetsDB())
			if owner then
				sourceGUID = owner
			end
			for destGUID,destData in pairs(sourceData) do
				local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[destGUID])
				if (isFriendly and not doEnemy) or (not isFriendly and doEnemy) then
					if not ExRT.F.table_find(destTable,destGUID,1) then
						destTable[#destTable + 1] = {destGUID,GetGUID(destGUID)}
					end
					if not ExRT.F.table_find(sourceTable,sourceGUID,1) then
						sourceTable[#sourceTable + 1] = {sourceGUID,GetGUID(sourceGUID)}
					end
				end
			end
		end
		sort(sourceTable,function(a,b) return a[2]<b[2] end)
		sort(destTable,function(a,b) return a[2]<b[2] end)
		wipe(BWInterfaceFrame.tab.tabs[2].sourceDropDown.List)
		wipe(BWInterfaceFrame.tab.tabs[2].targetDropDown.List)
		BWInterfaceFrame.tab.tabs[2].sourceDropDown.List[1] = {text = L.BossWatcherAll,func = HealingTab_SelectDropDownSource,arg2 = doEnemy,arg3=doSpells,arg4=isFromSpells and -1,padding = 16}
		BWInterfaceFrame.tab.tabs[2].targetDropDown.List[1] = {text = L.BossWatcherAll,func = HealingTab_SelectDropDownDest,arg2 = doEnemy,arg3=doSpells,arg4=isFromSpells and -1,padding = 16}
		for i=1,#sourceTable do
			local isPlayer = ExRT.F.GetUnitTypeByGUID(sourceTable[i][1]) == 0
			local classColor = ""
			if isPlayer then
				classColor = "|c"..ExRT.F.classColorByGUID(sourceTable[i][1])
			end
			BWInterfaceFrame.tab.tabs[2].sourceDropDown.List[i+1] = {
				text = classColor..sourceTable[i][2]..GUIDtoText(" [%s]",sourceTable[i][1]),
				arg1 = sourceTable[i][1],
				arg2 = doEnemy,
				arg3 = doSpells,
				arg4 = isFromSpells and -1,
				func = HealingTab_SelectDropDownSource,
				checkFunc = HealingTab_CheckDropDownSource,
				checkable = true,
			}
		end
		for i=1,#destTable do
			local isPlayer = ExRT.F.GetUnitTypeByGUID(destTable[i][1]) == 0
			local classColor = ""
			if isPlayer then
				classColor = "|c"..ExRT.F.classColorByGUID(destTable[i][1])
			end
			BWInterfaceFrame.tab.tabs[2].targetDropDown.List[i+1] = {
				text = classColor..destTable[i][2]..GUIDtoText(" [%s]",destTable[i][1]),
				arg1 = destTable[i][1],
				arg2 = doEnemy,
				arg3 = doSpells,
				arg4 = isFromSpells and -1,
				func = HealingTab_SelectDropDownDest,
				checkFunc = HealingTab_CheckDropDownDest,
				checkable = true,
			}
		end
		wipe(HsourceVar)
		wipe(HdestVar)
		if not doNotUpdateLines then
			if doSpells then
				HealingTab_UpdateLinesSpell(doEnemy)		
			else
				HealingTab_UpdateLinesPlayers(doEnemy)
			end
		end
	end
	
	local function HealingTab_RPS(doSpells,doNormalHealing)		
		local sourceTable = {}
		local destTable = {}
		for destGUID,destData in pairs(module.db.nowData.reduction) do	
			for sourceGUID,sourceData in pairs(destData) do
				for spellID,spellData in pairs(sourceData) do
					for reductorGUID,reductorData in pairs(spellData) do
						local owner = ExRT.F.Pets:getOwnerGUID(reductorGUID,GetPetsDB())
						if owner then
							reductorGUID = owner
						end
						local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[reductorGUID])
						if isFriendly then
							if not ExRT.F.table_find(destTable,destGUID,1) then
								destTable[#destTable + 1] = {destGUID,GetGUID(destGUID)}
							end
							if not ExRT.F.table_find(sourceTable,reductorGUID,1) then
								sourceTable[#sourceTable + 1] = {reductorGUID,GetGUID(reductorGUID)}
							end
						end
					end
				end
			end
		end
		sort(sourceTable,function(a,b) return a[2]<b[2] end)
		sort(destTable,function(a,b) return a[2]<b[2] end)
		wipe(BWInterfaceFrame.tab.tabs[2].sourceDropDown.List)
		wipe(BWInterfaceFrame.tab.tabs[2].targetDropDown.List)
		BWInterfaceFrame.tab.tabs[2].sourceDropDown.List[1] = {text = L.BossWatcherAll,func = HealingTab_SelectDropDownSource,arg3=doSpells,arg4=doNormalHealing and 2 or 1,padding = 16}
		BWInterfaceFrame.tab.tabs[2].targetDropDown.List[1] = {text = L.BossWatcherAll,func = HealingTab_SelectDropDownDest,arg3=doSpells,arg4=doNormalHealing and 2 or 1,padding = 16}
		for i=1,#sourceTable do
			local isPlayer = ExRT.F.GetUnitTypeByGUID(sourceTable[i][1]) == 0
			local classColor = ""
			if isPlayer then
				classColor = "|c"..ExRT.F.classColorByGUID(sourceTable[i][1])
			end
			BWInterfaceFrame.tab.tabs[2].sourceDropDown.List[i+1] = {
				text = classColor..sourceTable[i][2]..GUIDtoText(" [%s]",sourceTable[i][1]),
				arg1 = sourceTable[i][1],
				arg3 = doSpells,
				arg4 = doNormalHealing and 2 or 1,
				func = HealingTab_SelectDropDownSource,
				checkFunc = HealingTab_CheckDropDownSource,
				checkable = true,
			}
		end
		for i=1,#destTable do
			local isPlayer = ExRT.F.GetUnitTypeByGUID(destTable[i][1]) == 0
			local classColor = ""
			if isPlayer then
				classColor = "|c"..ExRT.F.classColorByGUID(destTable[i][1])
			end
			BWInterfaceFrame.tab.tabs[2].targetDropDown.List[i+1] = {
				text = classColor..destTable[i][2]..GUIDtoText(" [%s]",destTable[i][1]),
				arg1 = destTable[i][1],
				arg3 = doSpells,
				arg4 = doNormalHealing and 2 or 1,
				func = HealingTab_SelectDropDownDest,
				checkFunc = HealingTab_CheckDropDownDest,
				checkable = true,
			}
		end
		wipe(HsourceVar)
		wipe(HdestVar)

		if doSpells then
			if doNormalHealing then
				HealingTab_UpdateLinesSpell(false,true)
			else
				HealingTab_UpdateLinesReductionsSpells()
			end
		else
			if doNormalHealing then
				HealingTab_UpdateLinesPlayers(false,true)
			else
				HealingTab_UpdateLinesReductions()
			end
		end		
	end

	
	local function HealingTab_UpdatePage(_,doEnemy,doSpells,byTarget,byTargetDoEnemy)
		--[[
			false,false,false,false		by Source: friendly
			true,false,false,false		by Source: enemy
			
			false,false,true,false		by Target: friendly
			false,false,true,true		by Target: friendly
			
			false,true,false,false		by Spell: friendly
			true,true,false,false		by Spell: enemy
		]]
		HealingTab_HPS(doEnemy,doSpells,byTarget)
		if byTarget then
			HealingTab_UpdateLinesTargets(byTargetDoEnemy)
		end
		ELib:DropDownClose()
	end
	
	local function HealingTab_UpdatePageReduction(_,doSpells,doNormalHealing)
		HealingTab_RPS(doSpells,doNormalHealing)
		ELib:DropDownClose()
	end
	
	local function HealingTab_UpdatePageFromSpells()
		HealingTab_HPS(false,false,true,true)
		HealingTab_UpdateLinesFromSpells()
		ELib:DropDownClose()
	end

	
	tab.typeDropDown = ELib:DropDown(tab,200,13):Size(195):Point(70,-50):SetText(L.BossWatcherHealFriendly)
	tab.typeText = ELib:Text(tab,L.BossWatcherType..":",12):Size(100,20):Point("TOPRIGHT",tab.typeDropDown,"TOPLEFT",-6,0):Right():Color():Shadow()
	tab.typeDropDown.List = {
		{text = L.BossWatcherHealFriendly,isTitle = true},
		{text = L.BossWatcherBySource,func = HealingTab_UpdatePage,			arg1=false,	arg2=false,					},
		{text = L.BossWatcherByTarget,func = HealingTab_UpdatePage,			arg1=false,	arg2=false,	arg3=true,	arg4=false,	},
		{text = L.BossWatcherBySpell,func = HealingTab_UpdatePage,				arg1=false,	arg2=true,					},
		{text = L.BossWatcherFromSpells,func = HealingTab_UpdatePageFromSpells,										},
		{text = L.BossWatcherHealReduction,func = HealingTab_UpdatePageReduction,		arg1=false,	arg2=false,					},
		{text = L.BossWatcherHealReductionSpells,func = HealingTab_UpdatePageReduction,	arg1=true,	arg2=false,					},
		{text = L.BossWatcherHealReductionPlusHealing,func = HealingTab_UpdatePageReduction,arg1=false,	arg2=true,					},
		{text = L.BossWatcherHealReductionPlusHealingSpells,func = HealingTab_UpdatePageReduction,arg1=true,arg2=true,					},
		{text = L.BossWatcherHealHostile,isTitle = true},
		{text = L.BossWatcherBySource,func = HealingTab_UpdatePage,			arg1=true,	arg2=false,					},
		{text = L.BossWatcherByTarget,func = HealingTab_UpdatePage,			arg1=false,	arg2=false,	arg3=true,	arg4=true,	},
		{text = L.BossWatcherBySpell,func = HealingTab_UpdatePage,				arg1=true,	arg2=true,					},
	}
	
	tab.sourceDropDown = ELib:DropDown(tab,250,20):Size(195):Point(365,-50):SetText(L.BossWatcherAll)
	tab.sourceText = ELib:Text(tab,L.BossWatcherSource..":",12):Size(100,20):Point("TOPRIGHT",tab.sourceDropDown,"TOPLEFT",-6,0):Right():Color():Shadow()

	tab.targetDropDown = ELib:DropDown(tab,250,20):Size(195):Point(630,-50):SetText(L.BossWatcherAll)
	tab.targetText = ELib:Text(tab,L.BossWatcherTarget..":",12):Size(100,20):Point("TOPRIGHT",tab.targetDropDown,"TOPLEFT",-6,0):Right():Color():Shadow()
	
	function tab.sourceDropDown.additionalToggle(self)
		for i=2,#self.List do
			self.List[i].checkState = HsourceVar[self.List[i].arg1]
		end
	end
	function tab.targetDropDown.additionalToggle(self)
		for i=2,#self.List do
			self.List[i].checkState = HdestVar[self.List[i].arg1]
		end
	end
	
	tab.showOverhealChk = ELib:Check(tab,""):Point(833,-50):Tooltip(L.BossWatcherHealShowOver):OnClick(function (self)
		if self:GetChecked() then
			HealingTab_Variables.ShowOverheal = true
		else
			HealingTab_Variables.ShowOverheal = false
		end
		HealingTab_Variables.Last_Func(HealingTab_Variables.Last_doEnemy,HealingTab_Variables.Last_doReduction)
	end)
	
	tab.showGraphChk = ELib:Check(tab,"|cffffffff"..L.BossWatcherTabGraphics.." ",VExRT.BossWatcher.optionsHealingGraph):Point(833,-75):Left():OnClick(function (self)
		local tab2 = BWInterfaceFrame.tab.tabs[2]
		if self:GetChecked() then
			tab2.scroll:Point("TOP",0,-280)
			BWInterfaceFrame.GraphFrame:Show()
		else
			tab2.scroll:Point("TOP",0,-100)
			BWInterfaceFrame.GraphFrame:Hide()
		end
		VExRT.BossWatcher.optionsHealingGraph = self:GetChecked()
		HealingTab_Variables.Last_Func(HealingTab_Variables.Last_doEnemy,HealingTab_Variables.Last_doReduction)
	end)
	
	tab.scroll = ELib:ScrollFrame(tab):Point("TOP",0,VExRT.BossWatcher.optionsHealingGraph and -280 or -100):Point("BOTTOM",0,10):Height(600)
	tab.scroll:SetWidth(835)
	tab.scroll.C:SetWidth(835)
	tab.lines = {}
	
	local function HealingTab_RightClick_BackFunction()
		if not HealingTab_Variables.Back_Func then
			return
		end
		if HealingTab_Variables.Back_sourceVar then
			HsourceVar = HealingTab_Variables.Back_sourceVar
		else
			wipe(HsourceVar)
		end
		if HealingTab_Variables.Back_destVar then
			HdestVar = HealingTab_Variables.Back_destVar
		else
			wipe(HdestVar)
		end
		HealingTab_Variables.Back_Func(HealingTab_Variables.Last_doEnemy,HealingTab_Variables.Last_doReduction)
	end
	
	tab.scroll:SetScript("OnMouseUp",function(self,button)
		if button == "RightButton" then
			HealingTab_RightClick_BackFunction()
		end
	end)
	
	local function HealingTab_Line_Check_OnClick(self)
		local spellID = self:GetParent().spellID or self:GetParent().sourceGUID
		if not spellID then
			return
		end
		if self:GetParent().isPet and type(spellID) == 'number' then
			spellID = -spellID
		end
		local graphData = BWInterfaceFrame.GraphFrame.G.data
		local findPos = ExRT.F.table_find(graphData,spellID,'info_spellID')
		if findPos then
			graphData[ findPos ].hide = not self:GetChecked()
		end
		BWInterfaceFrame.GraphFrame.G:Reload()
	end
	local function HealingTab_Line_OnClick(self,button)
		if button == "RightButton" then
			HealingTab_RightClick_BackFunction()
			return
		end
		local x,y = ExRT.F.GetCursorPos(self)
		if (self.check and self.check:IsShown() or (self:GetParent().check and self:GetParent().check:IsShown())) and x <= 30 then
			return
		end
		local GUID = self.sourceGUID
		local doEnemy = self.doEnemy
		local tooltip = self.spellLink
		local isTargetLine = self.isTargetLine
		local isReduction = self.isReduction
		
		local parent = self:GetParent()
		if parent.isMain then
			GUID = parent.sourceGUID
			doEnemy = parent.doEnemy
			tooltip = parent.spellLink
			isTargetLine = parent.isTargetLine
		end
		if parent.isMain and IsShiftKeyDown() and tooltip and tooltip:find("spell:") then
			local spellID = tooltip:match("%d+")
			if spellID then
				ExRT.F.LinkSpell(spellID)
				return
			end
		end
		if GUID then
			if isReduction then
				wipe(HsourceVar)
				HsourceVar[GUID] = true
				local lastFunc = HealingTab_Variables.Last_Func
				if isReduction == 2 then
					HealingTab_UpdateLinesSpell(false,true)
				else
					HealingTab_UpdateLinesReductionsSpells()
				end
				HealingTab_Variables.Back_Func = lastFunc
				return
			end
			local Back_destVar = ExRT.F.table_copy2(HdestVar)
			local Back_sourceVar = ExRT.F.table_copy2(HsourceVar)
			local lastFunc = HealingTab_Variables.Last_Func
			if isTargetLine then
				wipe(HdestVar)
				HdestVar[GUID] = true
			else
				wipe(HsourceVar)
				HsourceVar[GUID] = true
			end
			HealingTab_UpdateLinesSpell(doEnemy)
			HealingTab_Variables.Back_Func = lastFunc
			HealingTab_Variables.Back_destVar = Back_destVar
			HealingTab_Variables.Back_sourceVar = Back_sourceVar
		end
	end
	local function HealingTab_LineOnEnter(self)
		if self.tooltip then
			GameTooltip:SetOwner(self,"ANCHOR_LEFT")
			local firstLine = self.tooltip[1]
			if type(firstLine) == "table" then
				firstLine = (firstLine[2] and "|T"..firstLine[2]..":18|t " or "")..firstLine[1]
			end
			GameTooltip:SetText(firstLine)
			for i=2,#self.tooltip do
				if type(self.tooltip[i]) == "table" then
					GameTooltip:AddDoubleLine(self.tooltip[i][1],self.tooltip[i][2],1,1,1,1,1,1,1,1)
				else
					GameTooltip:AddLine(self.tooltip[i])
				end
			end
			GameTooltip:Show()
		end
	end
	local function HealingTab_Line_OnEnter(self)
		local parent = self:GetParent()
		if parent.spellLink then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetHyperlink(parent.spellLink)
			GameTooltip:Show()
		elseif parent.name:IsTruncated() then
			GameTooltip:SetOwner(self,"ANCHOR_LEFT")
			GameTooltip:SetText(parent.name:GetText())
			GameTooltip:Show()	
		elseif parent.tooltip then
			HealingTab_LineOnEnter(parent)
		end
	end
	function HealingTab_SetLine(dataTable)
		local i,icon,name,overall_num,overall,total,dps,class,sourceGUID,doEnemy,spellLink,tooltip,school,overall_black,isTargetLine,isReduction
		local showCheck,checkState,spellID,isPet

		i = dataTable.line
		icon = dataTable.icon or ""
		name = dataTable.name
		total = dataTable.num
		overall_num = dataTable.num / max(dataTable.total,1)
		overall = dataTable.num / max(dataTable.max,1)
		if dataTable.alpha then
			overall_black = dataTable.alpha / max(dataTable.num,1)
		end
		dps = dataTable.dps
		class = dataTable.class
		sourceGUID = dataTable.sourceGUID
		doEnemy = dataTable.doEnemy
		if dataTable.spellID and dataTable.spellID ~= -1 then
			spellLink = "spell:"..dataTable.spellID
		end
		tooltip = dataTable.tooltip
		school = dataTable.school
		isTargetLine = dataTable.isTargetLine
		isReduction = dataTable.isReduction
		showCheck = dataTable.check
		checkState = dataTable.checkState
		spellID = dataTable.spellID
		isPet = dataTable.isPet

		if not BWInterfaceFrame.tab.tabs[2].lines[i] then
			local line = CreateFrame("Button",nil,BWInterfaceFrame.tab.tabs[2].scroll.C)
			BWInterfaceFrame.tab.tabs[2].lines[i] = line
			line:SetSize(815,20)
			line:SetPoint("TOPLEFT",0,-(i-1)*20)
			
			line.leftSide = CreateFrame("Frame",nil,line)
			line.leftSide:SetSize(1,20)
			line.leftSide:SetPoint("LEFT",5,0)
			
			line.check = ELib:Check(line,""):Point("TOPLEFT",5,-2)
			line.check:SetSize(16,16)
			line.check:SetScript("OnClick",HealingTab_Line_Check_OnClick)
			
			line.overall_num = ELib:Text(line,"45.76%",12):Size(70,20):Point(250,0):Right():Color():Shadow()

			line.icon = ELib:Icon(line,nil,18):Point("TOPLEFT",line.leftSide,0,-1)
			line.name = ELib:Text(line,"name",12):Size(0,20):Point("TOPLEFT",line.leftSide,25,0):Point("TOPRIGHT",line.overall_num,"TOPLEFT",0,0):Color():Shadow()
			line.name:SetMaxLines(1)
			
			line.name_tooltip = CreateFrame('Button',nil,line)
			line.name_tooltip:SetAllPoints(line.name)
			line.overall = line:CreateTexture(nil, "BACKGROUND")
			--line.overall:SetColorTexture(0.7, 0.1, 0.1, 1)
			line.overall:SetTexture("Interface\\AddOns\\ExRT\\media\\bar24.tga")
			line.overall:SetSize(300,16)
			line.overall:SetPoint("TOPLEFT",325,-2)
			line.overall_black = line:CreateTexture(nil, "BACKGROUND")
			line.overall_black:SetTexture("Interface\\AddOns\\ExRT\\media\\bar24b.tga")
			line.overall_black:SetSize(300,16)
			line.overall_black:SetPoint("LEFT",line.overall,"RIGHT",0,0)

			line.total = ELib:Text(line,"125.46M",12):Size(95,20):Point(630,0):Color():Shadow()
			line.dps = ELib:Text(line,"34576.43",12):Size(100,20):Point(725,0):Color():Shadow()
			
			line.back = line:CreateTexture(nil, "BACKGROUND")
			line.back:SetAllPoints()
			if i%2==0 then
				line.back:SetColorTexture(0.3, 0.3, 0.3, 0.1)
			end
			line.name_tooltip:SetScript("OnClick",HealingTab_Line_OnClick)
			line.name_tooltip:SetScript("OnEnter",HealingTab_Line_OnEnter)
			line.name_tooltip:SetScript("OnLeave",GameTooltip_Hide)
			line:SetScript("OnClick",HealingTab_Line_OnClick)
			line:SetScript("OnEnter",HealingTab_LineOnEnter)
			line:SetScript("OnLeave",GameTooltip_Hide)
			line:RegisterForClicks("AnyUp")
			
			line.isMain = true
		end
		local line = BWInterfaceFrame.tab.tabs[2].lines[i]
		if type(icon) == "table" then
			line.icon.texture:SetTexture(icon[1] or "Interface\\Icons\\INV_MISC_QUESTIONMARK")
			line.icon.texture:SetTexCoord(unpack(icon,2,5))
		else
			line.icon.texture:SetTexture(icon or "Interface\\Icons\\INV_MISC_QUESTIONMARK")
			line.icon.texture:SetTexCoord(0,1,0,1)
		end
		line.name:SetText(name or "")
		line.overall_num:SetFormattedText("%.2f%%",overall_num and overall_num * 100 or 0)
		if overall_black and overall_black > 0 then
			local width = 300*(overall or 1)
			local normal_width = width * (1 - overall_black)
			line.overall:SetWidth(max(normal_width,1))
			line.overall_black:SetWidth(max(width-normal_width,1))
			line.overall_black:Show()
			if normal_width == 0 then
				line.overall:Hide()
				line.overall_black:SetPoint("TOPLEFT",325,-2)
			else
				line.overall:Show()
				line.overall_black:ClearAllPoints()
				line.overall_black:SetPoint("LEFT",line.overall,"RIGHT",0,0)
			end
		else
			line.overall:Show()
			line.overall_black:Hide()
			line.overall:SetWidth(max(300*(overall or 1),1))
		end
		line.total:SetText(total and ExRT.F.shortNumber(total) or "")
		line.dps:SetFormattedText("%.2f",dps or 0)
		line.overall:SetGradientAlpha("HORIZONTAL", 0,0,0,0,0,0,0,0)
		line.overall_black:SetGradientAlpha("HORIZONTAL", 0,0,0,0,0,0,0,0)
		if class then
			local classColorArray = type(CUSTOM_CLASS_COLORS)=="table" and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
			if classColorArray then
				line.overall:SetVertexColor(classColorArray.r,classColorArray.g,classColorArray.b, 1)
				line.overall_black:SetVertexColor(classColorArray.r,classColorArray.g,classColorArray.b, 1)
			else
				line.overall:SetVertexColor(0.8,0.8,0.8, 1)
				line.overall_black:SetVertexColor(0.8,0.8,0.8, 1)
			end
		else
			line.overall:SetVertexColor(0.8,0.8,0.8, 1)
			line.overall_black:SetVertexColor(0.8,0.8,0.8, 1)
		end
		if school then
			SetSchoolColorsToLine(line.overall,school)
			SetSchoolColorsToLine(line.overall_black,school)
		end
		if showCheck then
			line.leftSide:SetPoint("LEFT",25,0)
			line.check:SetChecked(checkState)
			line.check:Show()
		else
			line.leftSide:SetPoint("LEFT",5,0)
			line.check:Hide()
		end
		line.sourceGUID = sourceGUID
		line.spellID = spellID
		line.doEnemy = doEnemy
		line.spellLink = spellLink
		line.tooltip = tooltip
		line.isTargetLine = isTargetLine
		line.isReduction = isReduction
		line.isPet = isPet
		line:Show()
	end
	
	local function HealingTab_AddSpecialInfo(text)
		local infoFrame = BWInterfaceFrame.tab.tabs[2].specialInfoFrame
		if not text then
			if infoFrame then
				infoFrame:Hide()
			end
			return
		end
		if not infoFrame then
			local sframe = CreateFrame("Frame",nil,BWInterfaceFrame.tab.tabs[2].scroll)
			BWInterfaceFrame.tab.tabs[2].specialInfoFrame = sframe
			sframe:SetSize(24,24)
			sframe:SetPoint("CENTER",BWInterfaceFrame.tab.tabs[2].scroll,"TOPLEFT",0,0)
			
			sframe.text = ELib:Text(sframe,"?",22):Size(24,24):Point("CENTER",0,0):Center():Color():Shadow()
			sframe.text:SetShadowColor(0,0,0,0)
			
			local circle = sframe:CreateTexture(nil, "OVERLAY")
			circle:SetPoint("CENTER",-1,2)
			circle:SetSize(26,26)
			circle:SetTexture([[Interface\Addons\ExRT\media\radioModern]])
			circle:SetTexCoord(0,0.25,0,1)
			
			sframe:SetScript("OnEnter",function(self)
				self.text:SetShadowColor(1,1,1,1)
				ELib.Tooltip.Show(self,nil,self.tooltip)
			end)
			sframe:SetScript("OnLeave",function(self)
				self.text:SetShadowColor(1,1,1,0)
				ELib.Tooltip:Hide()
			end)
			
			infoFrame = sframe
		end
		infoFrame.tooltip = text
		infoFrame:Show()
	end
	
	local function HealingTab_Graph_ZoomSecondUpdate_1(self)
		self.ZoomSecondUpdate_arg1 = HealingTab_Variables.Last_Func
		self.ZoomSecondUpdate_arg2 = HealingTab_Variables.Last_doEnemy
		self.ZoomSecondUpdate_arg3 = HealingTab_Variables.Last_doReduction
	end
	local function HealingTab_Graph_ZoomSecondUpdate_2(self)
		if self.ZoomSecondUpdate_arg1 then
			self.ZoomSecondUpdate_arg1(self.ZoomSecondUpdate_arg2,self.ZoomSecondUpdate_arg3)
		end
	end
	
	tab:SetScript("OnShow",function (self)
		BWInterfaceFrame.timeLineFrame:ClearAllPoints()
		BWInterfaceFrame.timeLineFrame:SetPoint("TOP",self,"TOP",0,-10)
		BWInterfaceFrame.timeLineFrame:Show()
		
		BWInterfaceFrame.GraphFrame:SetPoint("TOP",0,-80)
		BWInterfaceFrame.GraphFrame.G.ZoomSecondUpdate_1 = HealingTab_Graph_ZoomSecondUpdate_1
		BWInterfaceFrame.GraphFrame.G.ZoomSecondUpdate_2 = HealingTab_Graph_ZoomSecondUpdate_2
		if BWInterfaceFrame.tab.tabs[2].showGraphChk:GetChecked() then
			BWInterfaceFrame.GraphFrame:Show()
		end
	
		BWInterfaceFrame.report:Show()
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			HealingTab_UpdatePage()
			self.lastFightID = BWInterfaceFrame.nowFightID
			
			if module.db.data[module.db.nowNum].encounterID == 1784 then	--Tyrant Velhari
				HealingTab_AddSpecialInfo(L.BossWatcherHealingTabTyrantVelhari)
			else
				HealingTab_AddSpecialInfo()
			end
		elseif BWInterfaceFrame.tab.tabs[2].showGraphChk:GetChecked() and HealingTab_Variables.Last_Func then
			HealingTab_Variables.Last_Func(HealingTab_Variables.Last_doEnemy,HealingTab_Variables.Last_doReduction)
		end
	end)
	tab:SetScript("OnHide",function (self)
		BWInterfaceFrame.timeLineFrame:Hide()
		BWInterfaceFrame.report:Hide()
		BWInterfaceFrame.GraphFrame:Hide()
	end)
	
	
	
	
	---- Death Tab
	tab = BWInterfaceFrame.tab.tabs[9]
	tabName = BWInterfaceFrame_Name.."DeathTab"
	
	local DeathTab_Variables = {	--Use this because limit 200 local vars
		isEnemy = false,
		isBuffs = false,
		isDebuffs = false,
		isBlack = false,
		SetDeath_Last_Arg = nil,
		SetDeath_Last_Arg2 = nil,
		aurasBlackList = {
			[116956]=true,
			[167188]=true,
			[113742]=true,
			[6673]=true,
			[19740]=true,
			[109773]=true,
			[1126]=true,
			[21562]=true,
			[24907]=true,
			[166928]=true,
			[1459]=true,
			[93435]=true,
			[19506]=true,
			[167187]=true,
			[166916]=true,
			[166646]=true,
			[77747]=true,
			[67330]=true,
			[116781]=true,
			[24604]=true,
			[115921]=true,
			[51470]=true,
			[24932]=true,
			[117666]=true,
			[128432]=true,
			[155522]=true,
			[20217]=true,
			[469]=true,
			[57330]=true,
		}
	}
	
	local DeathTab_SetLine = nil
		
	local function DeathTab_ClearPage()
		for i=1,#BWInterfaceFrame.tab.tabs[9].lines do
			BWInterfaceFrame.tab.tabs[9].lines[i]:Hide()
		end
		BWInterfaceFrame.tab.tabs[9].scroll:SetNewHeight(0)
		BWInterfaceFrame.tab.tabs[9].sourceDropDown:SetText(L.BossWatcherSelect)
	end
	
	local function DeathTab_SetDeath(_,arg,arg2)
		DeathTab_Variables.SetDeath_Last_Arg = arg
		DeathTab_Variables.SetDeath_Last_Arg2 = arg2
		ELib:DropDownClose()
		DeathTab_ClearPage()
		BWInterfaceFrame.tab.tabs[9].sourceDropDown:SetText( arg2 )
		local _data = module.db.nowData.deathLog[arg]
		local data = {}
		local minTime,maxTime = _data[1][3]-20,_data[1][3]
		local GUID = _data[1][2]
		local deathTime = nil
		wipe(reportData[9])
		reportData[9][1] = date("%H:%M:%S",_data[1][3])..date(" %Mm%Ss",timestampToFightTime(_data[1][3])).." "..GetGUID(_data[1][2])
		for i=1,#_data do
			if _data[i][3] then
				_data[i].P = i
				data[#data + 1] = _data[i]
				minTime = min(minTime,_data[i][3])
			end
		end
		if DeathTab_Variables.isBuffs or DeathTab_Variables.isDebuffs then
			local DataDefLen = #_data
			for i,auraData in ipairs(module.db.nowData.auras) do
				if auraData[3] == GUID and auraData[1] >= minTime and auraData[1] <= maxTime and ((DeathTab_Variables.isBuffs and auraData[7]=='BUFF') or (DeathTab_Variables.isDebuffs and auraData[7]=='DEBUFF')) and (not DeathTab_Variables.isBlack or not DeathTab_Variables.aurasBlackList[ auraData[6] ]) then
					data[#data + 1] = {4,auraData[2],auraData[1],auraData[6],auraData[8],P=(DataDefLen + i)}
				end
			end
			sort(data,function(a,b) if a[3]==b[3] then return a.P<b.P else return a[3]>b[3] end end)
		end
		for i=1,#data do
			if data[i][1] then
				local _time = timestampToFightTime(data[i][3])
				local diffTime = deathTime and format("%.2f",_time - deathTime) or ""
				if diffTime == "0.00" then diffTime = "-0.00" end
				local timeText = date("%M:%S.",_time)..format("%03d",_time * 1000 % 1000)..(diffTime~="" and "  " or "")..diffTime
				if data[i][1] == 3 then
					local text = GetGUID(data[i][2])..GUIDtoText(" [%s]",data[i][2]) .. " ".. L.BossWatcherDeathDeath
					
					DeathTab_SetLine(i,timeText,text,0,0,0,data[i][4])
					
					reportData[9][#reportData[9] + 1] = "-0.0s "..L.BossWatcherDeathDeath
					
					deathTime = _time
				elseif data[i][1] == 1 then
					local spellName,_,spellTexture = GetSpellInfo(data[i][4])
					local name = GetGUID(data[i][2])..GUIDtoText(" [%s]",data[i][2])
					local overkill = data[i][6] and data[i][6] > 0 and " ("..L.BossWatcherDeathOverKill..":"..data[i][6]..")" or ""
					local blocked = data[i][8] and data[i][8] > 0 and " ("..L.BossWatcherDeathBlocked..":"..data[i][8]..")" or ""
					local absorbed = data[i][9] and data[i][9] > 0 and " ("..L.BossWatcherDeathAbsorbed..":"..data[i][9]..")" or ""
					local isCrit = data[i][10] and "*" or ""
					local isMs = data[i][11] and " ("..L.BossWatcherDeathMultistrike..")" or ""
					local school = " ("..GetSchoolName(data[i][7])..")"
					local amount = data[i][5] - (data[i][6] or 0)
					local HP = ""
					if data[i][12] and data[i][13]~=0 then
						HP = format("%d%% ",data[i][12]/data[i][13]*100)
						--HP = format("%d%% > %d%% ",min((data[i][12]+amount)/data[i][13],1)*100,data[i][12]/data[i][13]*100)
					end
					
					if ExRT.F.GetUnitTypeByGUID(data[i][2]) == 0 then
						name = "|c"..ExRT.F.classColorByGUID(data[i][2])..name.."|r"
					end
					
					local text = HP..name.." "..L.BossWatcherDeathDamage.." |T"..spellTexture..":0|t"..spellName.." "..L.BossWatcherDeathOn.." "..isCrit..amount..isCrit .. isMs .. blocked .. absorbed .. overkill .. school
					
					DeathTab_SetLine(i,timeText,text,1,0,0,data[i][4])
					
					reportData[9][#reportData[9] + 1] = diffTime.."s."..HP.." -"..isCrit..amount..isCrit .. isMs..blocked .. absorbed .. overkill .." ["..GetGUID(data[i][2]).." - "..GetSpellLink(data[i][4]).."]"
				elseif data[i][1] == 2 then
					local spellName,_,spellTexture = GetSpellInfo(data[i][4])
					local name = GetGUID(data[i][2])..GUIDtoText(" [%s]",data[i][2])
					local overheal = data[i][6] and data[i][6] > 0 and " ("..L.BossWatcherDeathOverHeal..":"..data[i][6]..")" or ""
					local absorbed = data[i][9] and data[i][9] > 0 and " ("..L.BossWatcherDeathAbsorbed..":"..data[i][9]..")" or ""
					local isCrit = data[i][10] and "*" or ""
					local isMs = data[i][11] and " ("..L.BossWatcherDeathMultistrike..")" or ""
					local school = " ("..GetSchoolName(data[i][7])..")"
					local amount = data[i][5] - (data[i][6] or 0)
					local HP = ""
					if data[i][12] and data[i][13]~=0 then
						HP = format("%d%% ",data[i][12]/data[i][13]*100)
						--if not data[i][14] then HP = format("%d%% > ",(data[i][12]-amount)/data[i][13]*100) .. HP end
					end
					
					if ExRT.F.GetUnitTypeByGUID(data[i][2]) == 0 then
						name = "|c"..ExRT.F.classColorByGUID(data[i][2])..name.."|r"
					end
					
					local text = HP .. name.." "..L.BossWatcherDeathHeal..(data[i][14] and (" ("..(ACTION_SPELL_MISSED_ABSORB and strlower(ACTION_SPELL_MISSED_ABSORB) or "absorbed")..")") or "").." |T"..spellTexture..":0|t"..spellName.." "..L.BossWatcherDeathOn.." "..isCrit..amount..isCrit .. isMs .. absorbed .. overheal .. school
					
					DeathTab_SetLine(i,timeText,text,0,1,0,data[i][4])
					
					reportData[9][#reportData[9] + 1] = diffTime.."s."..HP.." +"..isCrit..amount..isCrit .. isMs.. absorbed .. overheal .." ["..GetGUID(data[i][2]).." - "..GetSpellLink(data[i][4]).."]"
				elseif data[i][1] == 4 then
					local spellName,_,spellTexture = GetSpellInfo(data[i][4])
					local name = GetGUID(data[i][2])..GUIDtoText(" [%s]",data[i][2])
					local isApplied = (data[i][5]==1 or data[i][5]==3)
					
					if ExRT.F.GetUnitTypeByGUID(data[i][2]) == 0 then
						name = "|c"..ExRT.F.classColorByGUID(data[i][2])..name.."|r"
					end
					
					local text = name.." "..(isApplied and L.BossWatcherDeathAuraAdd or L.BossWatcherDeathAuraRemove).." |T"..spellTexture..":0|t"..spellName
					
					DeathTab_SetLine(i,timeText,text,1,1,0,data[i][4])
				
					reportData[9][#reportData[9] + 1] = diffTime.."s. ["..GetGUID(data[i][2]).." "..(isApplied and "+" or "-")..GetSpellLink(data[i][4]).."]"					
				end
				BWInterfaceFrame.tab.tabs[9].lines[i]:Show()
			end
		end
		BWInterfaceFrame.tab.tabs[9].scroll:SetNewHeight(#data * 18)
	end
	
	local function DeathTab_SetDeathList()
		local counter = 0
		for i,deathData in ipairs(module.db.nowData.deathLog) do
			local GUID = deathData[1][2]
			local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[GUID])
			if ((isFriendly and not DeathTab_Variables.isEnemy) or (not isFriendly and DeathTab_Variables.isEnemy)) and (deathData[2] and deathData[2][1]) then
				counter = counter + 1
				local classColor = "|cffbbbbbb"
				local isPlayer = ExRT.F.GetUnitTypeByGUID(GUID) == 0
				if isPlayer then
					classColor = "|c"..ExRT.F.classColorByGUID(GUID)
				end
				local text = classColor..GetGUID(GUID)..GUIDtoText(" [%s]",GUID).."|r"
				local spellID = nil
				for j=2,#deathData do
					if deathData[j][1] == 1 and deathData[j][6] > 0 then
						local sourceColor = "|cffbbbbbb"
						if ExRT.F.GetUnitTypeByGUID(deathData[j][2]) == 0 then
							sourceColor = "|c"..ExRT.F.classColorByGUID(deathData[j][2])
						end
						local spellName,_,spellTexture = GetSpellInfo(deathData[j][4])
						text = text .." < " ..sourceColor .. GetGUID(deathData[j][2])..GUIDtoText(" [%s]",deathData[j][2]).."|r (|T"..spellTexture..":0|t"..spellName..")"
						spellID = deathData[j][4]
						break
					end
				end
				
				local _time = timestampToFightTime( deathData[1][3] )
				local timeText = date("%M:%S.",_time)..format("%03d",_time * 1000 % 1000)
				DeathTab_SetLine(counter,timeText,text,0,0,0,spellID,i)
				BWInterfaceFrame.tab.tabs[9].lines[counter]:Show()
			end
		end
		BWInterfaceFrame.tab.tabs[9].scroll:SetNewHeight(counter * 18)
	end
	
	local function DeathTab_UpdatePage()
		wipe(BWInterfaceFrame.tab.tabs[9].sourceDropDown.List)
		local list = BWInterfaceFrame.tab.tabs[9].sourceDropDown.List
		for i,deathData in ipairs(module.db.nowData.deathLog) do	
			local GUID = deathData[1][2]
			local isFriendly = ExRT.F.UnitIsFriendlyByUnitFlag2(module.db.data[module.db.nowNum].reaction[GUID])
			if ((isFriendly and not DeathTab_Variables.isEnemy) or (not isFriendly and DeathTab_Variables.isEnemy)) and (deathData[2] and deathData[2][1]) then
				local classColor = ""
				local isPlayer = ExRT.F.GetUnitTypeByGUID(GUID) == 0
				if isPlayer then
					classColor = "|c"..ExRT.F.classColorByGUID(GUID)
				elseif isFriendly then
					classColor = "|cffbbbbbb"
				end
				local text = date("%M:%S ",timestampToFightTime(deathData[1][3]))..classColor..GetGUID(GUID)..GUIDtoText(" [%s]",GUID)
				list[#list+1] = {
					text = text,
					arg1 = i,
					arg2 = text,
					func = DeathTab_SetDeath,
					hoverFunc = DamageTab_ShowArrow,
					leaveFunc = DamageTab_HideArrow,
					hoverArg = timestampToFightTime( deathData[1][3] ) / ( module.db.data[module.db.nowNum].encounterEnd - module.db.data[module.db.nowNum].encounterStart ),
				}
			end
		end
	end
	
	local function DeathTab_SetType(self,arg)
		DeathTab_Variables.isEnemy = arg
		BWInterfaceFrame.tab.tabs[9].typeDropDown:SetText(arg and L.BossWatcherHostile or L.BossWatcherFriendly)
		ELib:DropDownClose()
		DeathTab_UpdatePage()
		DeathTab_ClearPage()
		DeathTab_SetDeathList()
		DeathTab_Variables.SetDeath_Last_Arg = nil
	end
	
	tab.typeDropDown = ELib:DropDown(tab,200,2):Size(180):Point(70,-75):SetText(L.BossWatcherFriendly)
	tab.typeText = ELib:Text(tab,L.BossWatcherType..":",12):Size(100,20):Point("TOPRIGHT",tab.typeDropDown,"TOPLEFT",-6,0):Right():Color():Shadow()
	tab.typeDropDown.List = {
		{text = L.BossWatcherFriendly,func = DeathTab_SetType},
		{text = L.BossWatcherHostile,func = DeathTab_SetType,arg1 = true},
	}
	
	tab.sourceDropDown = ELib:DropDown(tab,250,20):Size(180):Point(335,-75):SetText(L.BossWatcherSelect)
	tab.sourceText = ELib:Text(tab,L.BossWatcherTarget..":",12):Size(100,20):Point("TOPRIGHT",tab.sourceDropDown,"TOPLEFT",-6,0):Right():Color():Shadow()
	
	tab.showBuffsChk = ELib:Check(tab,L.BossWatcherDeathBuffsShow):Point(530,-75):OnClick(function (self)
		if self:GetChecked() then
			DeathTab_Variables.isBuffs = true
		else
			DeathTab_Variables.isBuffs = false
		end
		if DeathTab_Variables.SetDeath_Last_Arg then
			DeathTab_SetDeath(nil,DeathTab_Variables.SetDeath_Last_Arg,DeathTab_Variables.SetDeath_Last_Arg2)
		end
	end)

	tab.showDebuffsChk = ELib:Check(tab,L.BossWatcherDeathDebuffsShow):Point(680,-75):OnClick(function (self)
		if self:GetChecked() then
			DeathTab_Variables.isDebuffs = true
		else
			DeathTab_Variables.isDebuffs = false
		end
		if DeathTab_Variables.SetDeath_Last_Arg then
			DeathTab_SetDeath(nil,DeathTab_Variables.SetDeath_Last_Arg,DeathTab_Variables.SetDeath_Last_Arg2)
		end
	end)
	
	tab.buffsblacklistChk = ELib:Check(tab,""):Point(833,-75):Tooltip(L.BossWatcherDeathBlacklist):OnClick(function (self)
		if self:GetChecked() then
			DeathTab_Variables.isBlack = true
		else
			DeathTab_Variables.isBlack = false
		end
		if DeathTab_Variables.SetDeath_Last_Arg then
			DeathTab_SetDeath(nil,DeathTab_Variables.SetDeath_Last_Arg,DeathTab_Variables.SetDeath_Last_Arg2)
		end
	end)
	
	local function DeathTab_LineOnEnter(self)
		if self.spellLink then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT",120,0)
			GameTooltip:SetHyperlink(self.spellLink)
			GameTooltip:Show()
		end
		if self.text:IsTruncated() then
			ELib.Tooltip:Add(nil,{self.text:GetText()},false,true)
		end
	end
	local function DeathTab_LineOnLeave(self)
		GameTooltip_Hide()
		ELib.Tooltip:HideAdd()
	end
	local function DeathTab_LineOnClick(self,button)
		if not self.clickToLog then
			if button == "RightButton" then
				DeathTab_SetType(nil,DeathTab_Variables.isEnemy)
			end
			return
		end
		if button == "RightButton" then
			return
		end
		local name = self.text:GetText()
		DeathTab_SetDeath(nil,self.clickToLog,name:match("(.-)|r"),nil)
	end
	tab.scroll = ELib:ScrollFrame(tab):Size(835,483):Point("TOP",0,-105)
	tab.lines = {}
	function DeathTab_SetLine(i,textTime,textText,gradientR,gradientG,gradientB,spellID,clickToLog)
		local line = BWInterfaceFrame.tab.tabs[9].lines[i]
		if not line then
			line = CreateFrame("Button",nil,BWInterfaceFrame.tab.tabs[9].scroll.C)
			BWInterfaceFrame.tab.tabs[9].lines[i] = line
			line:SetPoint("TOP",0,-(i-1)*18)
			line:SetSize(810,18)
			
			line.time = ELib:Text(line,"00:02."..format("%02d",i),12):Size(150,16):Point("LEFT",10,0):Color():Shadow()
			line.text = ELib:Text(line,"00:02."..format("%02d",i),12):Size(810-125-20,16):Point("LEFT",125,0):Color():Shadow()
			
			line.back = line:CreateTexture(nil, "BACKGROUND")
			line.back:SetAllPoints()
			line.back:SetColorTexture( 1, 1, 1, 1)
			line.back:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0, 0, 0, 0, 0)
			
			line:SetScript("OnEnter",DeathTab_LineOnEnter)
			line:SetScript("OnLeave",DeathTab_LineOnLeave)
			line:SetScript("OnClick",DeathTab_LineOnClick)
			
			line:RegisterForClicks("LeftButtonDown","RightButtonDown")
		end
		line.time:SetText(textTime)
		line.text:SetText(textText)
		line.back:SetGradientAlpha("HORIZONTAL", gradientR,gradientG,gradientB, 0.3, gradientR,gradientG,gradientB, 0)
		line.spellLink = spellID and "spell:"..spellID
		line.clickToLog = clickToLog
		line:Show()
	end
	
	tab:SetScript("OnShow",function (self)
		BWInterfaceFrame.timeLineFrame:ClearAllPoints()
		BWInterfaceFrame.timeLineFrame:SetPoint("TOP",self,"TOP",0,-10)
		BWInterfaceFrame.timeLineFrame:Show()
		
		BWInterfaceFrame.report:Show()
		
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			DeathTab_Variables.SetDeath_Last_Arg = nil
			DeathTab_ClearPage()
			DeathTab_UpdatePage()
			DeathTab_SetDeathList()
			self.lastFightID = BWInterfaceFrame.nowFightID
		end
	end)
	tab:SetScript("OnHide",function (self)
		BWInterfaceFrame.timeLineFrame:Hide()
		BWInterfaceFrame.report:Hide()
	end)
	
	
	
	
	
	---- Positions Tab
	tab = BWInterfaceFrame.tab.tabs[10]
	tabName = BWInterfaceFrame_Name.."PositionsTab"
	
	--[[
		Note:
		
		minX is higher then maxX in UnitPosition coords
		minY is higher then maxY in UnitPosition coords
		
		GetAreaMapInfo(zoneID) retruns terrainMapID (same as 4th param in UnitPosition)
		
		Funcs:
		GetCurrentMapDungeonLevel()	--> coords
		GetCurrentMapZone()		--> coords
		GetMapInfo()			--> map Name
		
	]]
	local PositionsTab_UpdatePage = nil
	local PositionsTab_Variables = {	--Use this because limit 200 local vars
		DisableMap = nil,
		SelectedMap = nil,
		NamesToDots = {},
		Maps = {
			-----> Dungeons
			[1279] = { type = "dungeon", content = 6,
				{2354.1669921875,956.25,935.4169921875,10.416015625,"OvergrownOutpost"},
				{-1018.7474365234,1160.4200439453,-1475.0025634766,856.25,"OvergrownOutpost",1},
			},
			[1358] = { type = "dungeon", content = 6,
				{10.586999893188,304.39801025391,-876.25201416016,-286.82800292969,"UpperBlackrockSpire",1},
				{10.586999893188,304.39801025391,-876.25201416016,-286.82800292969,"UpperBlackrockSpire",2},
				{10.586999893188,304.39801025391,-876.25201416016,-286.82800292969,"UpperBlackrockSpire",3},
			},
			[1208] = { type = "dungeon", content = 6,
				{1784.3800048828,1806.25,1465.6300048828,1593.75,"BlackrockTrainDepotDungeon",1},
				{1784.3800048828,1806.25,1465.6300048828,1593.75,"BlackrockTrainDepotDungeon",2},
				{1775,1740,1505,1560,"BlackrockTrainDepotDungeon",3},
				{2035,1748.3333740234,1740,1551.6666259766,"BlackrockTrainDepotDungeon",4},
			},
			[1209] = { type = "dungeon", content = 6,
				{2227.1235351563,1367.9899902344,1434.6165771484,839.65197753906,"SpiresofArakDungeon",1},
				{1945.8707275391,1166.3199462891,1608.3692626953,941.31896972656,"SpiresofArakDungeon",2},
			},
			[1195] = { type = "dungeon", content = 6,
				{100,7533.3330078125,-1700,6333.3330078125,"IronDocks",1},
			},
			[1182] = { type = "dungeon", content = 6,
				{4633.3330078125,2733.3330078125,1233.3330078125,466.666015625,"DraenorAuchindoun",1},
			},
			[1176] = { type = "dungeon", content = 6,
				{318.99398803711,2019.5833740234,-339.75601196289,1580.4166259766,"ShadowmoonDungeon",1},
				{-200,2117.5,-1025,1567.5,"ShadowmoonDungeon",2},
				{-700,1790.8333740234,-950,1624.1666259766,"ShadowmoonDungeon",3},
			},
			[1175] = { type = "dungeon", content = 6,
				{439.583984375,2600,-847.916015625,1741.6669921875,"OgreMines",1},
			},
			[595] = { type = "dungeon", content = 3,
				{2152.0832519531,2297.9165039063,327.08331298828,1081.25,"CoTStratholme"},
				{1856.3599853516,2641.9599609375,731.05999755859,1891.7600097656,"CoTStratholme",1},
			},
			[619] = { type = "dungeon", content = 3,
				{-233.33332824707,849.99993896484,-1206.25,202.08332824707,"Ahnkahet",1},
			},
			[574] = { type = "dungeon", content = 3,
				{424.17498779297,515.38800048828,-310.40600585938,25.666500091553,"UtgardeKeep",1},
				{242.92500305176,304.3869934082,-238.15600585938,-16.333299636841,"UtgardeKeep",2},
				{225.67500305176,415.72100830078,-510.90600585938,-75.333503723145,"UtgardeKeep",3},
			},
			[575] = { type = "dungeon", content = 3,
				{-148.62300109863,552.87701416016,-697.55902099609,186.91999816895,"UtgardePinnacle",1},
				{8.6219596862793,661.9580078125,-747.55798339844,157.8390045166,"UtgardePinnacle",2},
			},
			[602] = { type = "dungeon", content = 3,
				{283.68600463867,1534.5400390625,-282.54901123047,1157.0500488281,"HallsofLightning",1},
				{169.68800354004,1431.8800048828,-538.54901123047,959.71997070313,"HallsofLightning",2},
			},
			[599] = { type = "dungeon", content = 3,
				{2766.6665039063,2200,-633.33331298828,-66.666664123535,"Ulduar77",1},
			},
			[578] = { type = "dungeon", content = 3,
				{1301.9599609375,1220.2099609375,787.25299072266,877.07098388672,"Nexus80",1},
				{1376.9599609375,1370.2099609375,712.25299072266,927.07098388672,"Nexus80",2},
				{1301.9599609375,1270.2099609375,787.25299072266,927.07098388672,"Nexus80",3},
				{1191.9599609375,1186.8701171875,897.25897216797,990.40283203125,"Nexus80",4},
			},
			[604] = { type = "dungeon", content = 3,
				{1310.4166259766,2122.9165039063,166.66665649414,1360.4166259766,"Gundrak",1},
			},
			[601] = { type = "dungeon", content = 3,
				{722.97399902344,794.125,-30,292.14199829102,"AzjolNerub",1},
				{692.97399902344,645.78997802734,400,450.47399902344,"AzjolNerub",2},
				{829.625,640,462.125,395,"AzjolNerub",3},
			},
			[600] = { type = "dungeon", content = 3,
				{-307.06900024414,-182.5659942627,-927.01000976563,-595.85998535156,"DrakTharonKeep",1},
				{-382.06900024414,-182.5659942627,-1002.0100097656,-595.85998535156,"DrakTharonKeep",2},
			},
			[608] = { type = "dungeon", content = 3,
				{983.33331298828,2006.2498779297,600,1749.9998779297,"VioletHold",1},
			},
			[650] = { type = "dungeon", content = 3,
				{2100,2200,-499.99996948242,466.66665649414,"TheArgentColiseum",1},
			},
			[632] = { type = "dungeon", content = 3,
				{7033.3330078125,6466.6665039063,-4366.6665039063,-1133.3332519531,"TheForgeofSouls",1},
			},
			[658] = { type = "dungeon", content = 3,
				{839.58331298828,1256.25,-693.75,233.33332824707,"PitofSaron"},
			},
			[668] = { type = "dungeon", content = 3,
				{7033.3330078125,6466.6665039063,-5966.6665039063,-2200,"HallsofReflection",1},
			},
			[558] = { type = "dungeon", content = 2,
				{327.55722045898,354.95098876953,-414.98321533203,-140.07600402832,"AuchenaiCrypts",1},
				{215.05725097656,334.95098876953,-602.48321533203,-210.07600402832,"AuchenaiCrypts",2},
			},
			[556] = { type = "dungeon", content = 2,
				{515.79724121094,173.65400695801,-187.6982421875,-295.34298706055,"SethekkHalls",1},
				{515.79724121094,173.65400695801,-187.6982421875,-295.34298706055,"SethekkHalls",2},
			},
			[555] = { type = "dungeon", content = 2,
				{185.07917785645,62.796901702881,-656.44317626953,-498.21798706055,"ShadowLabyrinth",1},
			},
			[542] = { type = "dungeon", content = 2,
				{498.98901367188,603.13598632813,-504.5299987793,-65.87670135498,"TheBloodFurnace",1},
			},
			[546] = { type = "dungeon", content = 2,
				{240.97700500488,423.73516845703,-653.94299316406,-172.87818908691,"TheUnderbog",1},
			},
			[547] = { type = "dungeon", content = 2,
				{53.934101104736,201.72003173828,-836.1240234375,-391.65203857422,"TheSlavePens",1},
			},
			[553] = { type = "dungeon", content = 2,
				{649.75323486328,248.02499389648,-107.64924621582,-256.91000366211,"TheBotanica",1},
			},
			[557] = { type = "dungeon", content = 2,
				{276.93408203125,90.07080078125,-546.35107421875,-458.78601074219,"ManaTombs",1},
			},
			[545] = { type = "dungeon", content = 2,
				{160.02200317383,158.56721496582,-716.74200439453,-425.94219970703,"TheSteamvault",1},
				{160.02200317383,158.56721496582,-716.74200439453,-425.94219970703,"TheSteamvault",2},
			},
			[554] = { type = "dungeon", content = 2,
				{334.4580078125,349.98620605469,-341.7799987793,-100.83919525146,"TheMechanar",1},
				{334.4580078125,412.98602294922,-341.7799987793,-37.839344024658,"TheMechanar",2},
			},
			[552] = { type = "dungeon", content = 2,
				{284.57901000977,384.36502075195,-405.10501098633,-75.424331665039,"TheArcatraz",1},
				{300.7610168457,408.03201293945,-245.28703308105,44,"TheArcatraz",2},
				{214.07899475098,575.28900146484,-422.60501098633,150.83297729492,"TheArcatraz",3},
			},
			[269] = { type = "dungeon", content = 2,
				{7649.9995117188,-1500,6562.4995117188,-2225,"CoTTheBlackMorass"},
			},
			[560] = { type = "dungeon", content = 2,
				{1854.1666259766,3127.0832519531,-477.08331298828,1572.9166259766,"CoTHillsbradFoothills"},
			},
			
			-----> PvP
			[1116] = { type = "pvp",
				{-2672.919921875,5577.080078125,-5795.830078125,3495.830078125,"Ashran"},
			},
			[1105] = { type = "pvp",
				{1068.75,189.583984375,-14.583984375,-533.333984375,"GoldRush"},
			},
			[1035] = { type = "pvp",
				{1743.75,2083.3330078125,904.1669921875,1522.9169921875,"ValleyOfPowerScenario"},
			},
			[727] = { type = "pvp",
				{1320.8330078125,1495.8330078125,-929.166015625,-4.166015625,"STVDiamondMineBG",1},
			},
			[761] = { type = "pvp",
				{1745.8332519531,1604.1666259766,443.74996948242,735.41662597656,"GilneasBattleground2"},
			},
			[566] = { type = "pvp",
				{2660.4165039063,2918.75,389.58331298828,1404.1666259766,"NetherstormArena"},
			},
			[30] = { type = "pvp",
				{1781.2498779297,1085.4166259766,-2456.25,-1739.5832519531,"AlteracValley"},
			},
			[489] = { type = "pvp",
				{2041.6666259766,1627.0832519531,895.83331298828,862.49993896484,"WarsongGulch"},
			},
			[529] = { type = "pvp",
				{1858.3332519531,1508.3332519531,102.08332824707,337.5,"ArathiBasin"},
			},
			[607] = { type = "pvp",
				{787.5,1883.3332519531,-956.24993896484,720.83331298828,"StrandoftheAncients"},
			},
		
			-----> Debug
			[1153] = { type = "other",
				{4885.416015625,5814.5830078125,4183.3330078125,5345.8330078125,"garrisonffhorde_tier3"},
			},
			
			-----> Raids
			[996] = { type = "raid", content = 5,
				{-2497.916015625,-789.583984375,-3200,-1258.333984375,"TerraceOfEndlessSpring"},
			},
			[1009] = { type = "raid", content = 5,
				{700,-1966.6667480469,0,-2433.3334960938,"HeartofFear",1},
				{1430.0100097656,-1769.9985351563,-9.9943704605103,-2730.0014648438,"HeartofFear",2},
			},
			[1008] = { type = "raid", content = 5,
				{1562.5003662109,4194.169921875,874.99060058594,3735.830078125,"MogushanVaults",1},
				{1677.5048828125,4376.669921875,1244.9951171875,4088.330078125,"MogushanVaults",2},
				{2065,4280,1315,3780,"MogushanVaults",3},
			},
			[967] = { type = "raid", content = 4,
				{-833.5927734375,-565.0927734375,-3940.3012695313,-2628.1579589844,"DragonSoul"},
				{-1716.25,-1625,-2113.75,-1890,"DragonSoul",1},
				{-2834.5,-1625,-3262,-1910,"DragonSoul",2},
				{13709.099609375,13651.733398438,13523.900390625,13528.266601563,"DragonSoul",3},
				{1.25,1,-0.25,0,"DragonSoul",4},
				{1.25,1,-0.25,0,"DragonSoul",5},
				{12535.42578125,-11516,11427.07421875,-12254.900390625,"DragonSoul",6},
			},
			[720] = { type = "raid", content = 4,
				{718.75,424.99996948242,-868.74993896484,-633.33331298828,"Firelands"},
				{677.0830078125,593.75,302.0830078125,343.75,"Firelands",1},
				{670,1225,-770,265,"Firelands",2},
			},
			[671] = { type = "raid", content = 4,
				{-106.43550872803,-180.95700073242,-1184.7705078125,-899.84698486328,"TheBastionofTwilight",1},
				{-256.42700195313,-770.95501708984,-1034.7700195313,-1289.8499755859,"TheBastionofTwilight",2},
				{-224.92799377441,-707.95501708984,-1267.2700195313,-1402.8499755859,"TheBastionofTwilight",3},
			},
			[669] = { type = "raid", content = 4,
				{174.10899353027,-0.99963402748108,-675.58502197266,-567.46197509766,"BlackwingDescent",1},
				{249.10899353027,359,-750.583984375,-307.46200561523,"BlackwingDescent",2},
			},
			[754] = { type = "raid", content = 4,
				{2100,600,-499.99996948242,-1133.3332519531,"ThroneoftheFourWinds",1},
			},
			[757] = { type = "raid", content = 4,
				{2633.3332519531,1133.3332519531,33.333332061768,-600,"BaradinHold"},
			},
			[631] = { type = "raid", content = 3,
				{2739.8000488281,138.80700683594,1384.3299560547,-764.84002685547,"IcecrownCitadel",1},
				{2698,-43.333301544189,1631,-754.6669921875,"IcecrownCitadel",2},
				{2311.8000488281,-449.99798583984,2116.330078125,-580.31298828125,"IcecrownCitadel",3},
				{2767.2800292969,4528.2202148438,1993.5699462891,4012.4099121094,"IcecrownCitadel",4},
				{3364.8000488281,4768.2299804688,2216.0600585938,4002.4099121094,"IcecrownCitadel",5},
				{2960.2800292969,4704.8798828125,2586.5700683594,4455.75,"IcecrownCitadel",6},
				{-1978.2900390625,605.79901123047,-2271.5500488281,410.2919921875,"IcecrownCitadel",7},
				{-2400.330078125,579.39599609375,-2648.2600097656,414.10800170898,"IcecrownCitadel",8},
			},
			[603] = { type = "raid", content = 3,
				{1583.3332519531,1168.75,-1704.1666259766,-1022.9166259766,"Ulduar"},
				{224.21600341797,1839.0100097656,-445.23498535156,1392.7099609375,"Ulduar",1},
				{653.72100830078,2564.6799316406,-674.73999023438,1679.0400390625,"Ulduar",2},
				{594.75,2219,-315.75,1612,"Ulduar",3},
				{3254.4499511719,3168.830078125,1684.9899902344,2122.5300292969,"Ulduar",4},
				{309.45498657227,2247.75,-310.01400756836,1834.7700195313,"Ulduar",5},
			},
			[724] = { type = "raid", content = 3,
				{902.08331298828,3429.1665039063,150,2927.0832519531,"TheRubySanctum"},
			},
			[615] = { type = "raid", content = 3,
				{1133.3332519531,3616.6665039063,-29.166666030884,2841.6665039063,"TheObsidianSanctum"},
			},
			[624] = { type = "raid", content = 3,
				{1033.3332519531,600,-1566.6666259766,-1133.3332519531,"VaultofArchavon",1},
			},
			[616] = { type = "raid", content = 3,
				{2766.6665039063,2200,-633.33331298828,-66.666664123535,"TheEyeofEternity",1},
			},
			[533] = { type = "raid", content = 3,
				{-2640.2700195313,3615.830078125,-3734.1000976563,2886.6101074219,"Naxxramas",1},
				{-3140.2700195313,3615.830078125,-4234.1000976563,2886.6101074219,"Naxxramas",2},
				{-2587,3136,-3787,2336,"Naxxramas",3},
				{-3087.0200195313,3136.830078125,-4287.3500976563,2336.6101074219,"Naxxramas",4},
				{-2330.2800292969,3691.2199707031,-4400.08984375,2311.3400878906,"Naxxramas",5},
				{-4866.3500976563,3816.5400390625,-5522.2900390625,3379.25,"Naxxramas",6},
			},
			[649] = { type = "raid", content = 3,
				{328.73098754883,693.01898193359,-41.255199432373,446.36099243164,"TheArgentColiseum",1},
				{528.73602294922,926.35400390625,-211.25999450684,433.02398681641,"TheArgentColiseum",2},
			},
			[1136] = { type = "raid", content = 5,
				{1239.5830078125,1310.4169921875,481.25,806.25,"OrgrimmarRaid"},
				{1150.0100097656,1729.1716308594,199.99499511719,1095.8283691406,"OrgrimmarRaid",1},
				{1278.75,1000,716.25,625,"OrgrimmarRaid",2},
				{-4020.830078125,1654.5166015625,-5162.5,893.40338134766,"OrgrimmarRaid",3},
				{-3789.583984375,2125,-5000,1318.75,"OrgrimmarRaid",4},
				{-4163.9702148438,1932.2716064453,-4526.0600585938,1690.8784179688,"OrgrimmarRaid",5},
				{-4237.5,1900,-4837.5,1500,"OrgrimmarRaid",6},
				{-4582.5,2165,-5467.5,1575,"OrgrimmarRaid",7},
				{-4490,1865.8333740234,-5700,1059.1666259766,"OrgrimmarRaid",8},
				{-5230,2157.080078125,-5875,1727.0799560547,"OrgrimmarRaid",9},
				{-5082.5,1790,-5967.5,1200,"OrgrimmarRaid",10},
				{-5403.75,1275,-5876.25,960,"OrgrimmarRaid",11},
				{-5179.9970703125,1204.1700439453,-6010.0029296875,650.8330078125,"OrgrimmarRaid",12},
				{-5222.5,1215,-5567.5,985,"OrgrimmarRaid",13},
				{-5709.1298828125,1150,-5971.6298828125,975,"OrgrimmarRaid",14},
			},
			[1098] = { type = "raid", content = 5,
				{7027.5,6113.3334960938,5742.5,5256.6665039063,"ThunderKingRaid",1},
				{6175.0048828125,6246.669921875,4624.9951171875,5213.330078125,"ThunderKingRaid",2},
				{5245,6605.8334960938,4215,5919.1665039063,"ThunderKingRaid",3},
				{4609.6401367188,6312.8735351563,4018.3601074219,5918.6865234375,"ThunderKingRaid",4},
				{5245,6128.3334960938,4215,5441.6665039063,"ThunderKingRaid",5},
				{4950,6402.8334960938,4040,5796.1665039063,"ThunderKingRaid",6},
				{4505,5985,3695,5445,"ThunderKingRaid",7},
				{4978.75,5733.3334960938,4361.25,5321.6665039063,"ThunderKingRaid",8},
			},
			[1205] = { type = "raid", content = 6,
				{3938.75,611.3330078125,3001,-13.833630561829,"FoundryRaid",1},
				{3901.25,485,3098.75,-50,"FoundryRaid",2},
				{3659.75,455,3097.25,80,"FoundryRaid",3},
				{3628.1303710938,682.08697509766,2939.3696289063,222.91299438477,"FoundryRaid",4},
				{3713.810546875,674.58197021484,3263.189453125,374.16799926758,"FoundryRaid",5},
			},
			[1228] = { type = "raid", content = 6,
				{8468.75,4254.1669921875,7062.5,3316.6669921875,"HighmaulRaid"},
				{7693.75,3545,7446.25,3380,"HighmaulRaid",1},
				{7775,3603.3332519531,7375,3336.6667480469,"HighmaulRaid",2},
				{8855.3095703125,4195,8195.3095703125,3755,"HighmaulRaid",3},
				{8993.75,4350,8056.25,3725,"HighmaulRaid",4},
				{8981.25,4350,8118.75,3775,"HighmaulRaid",5},
			},
			[1448] = { type = "raid", content = 6,
				{-264.58401489258,4183.330078125,-977.083984375,3708.330078125,"HellfireRaid"},
				{-24.99760055542,4099.794921875,-530.00201416016,3763.1252441406,"HellfireRaid",1},
				{-175.99499511719,4218.0034179688,-490,4008.6665039063,"HellfireRaid",2},
				{-70.831558227539,4437.5,-508.33645629883,4145.830078125,"HellfireRaid",3},
				{25,3880,-485,3540,"HellfireRaid",4},
				{2805,4340,2220,3950,"HellfireRaid",5},
				{2361.25,4275,1963.75,4010,"HellfireRaid",6},
				{2750.0048828125,4054.169921875,2024.9951171875,3570.830078125,"HellfireRaid",7},
				{-84.807403564453,-2869.9997558594,-489.19299316406,-3139.5903320313,"HellfireRaid",8},
				{-1900,4275.0014648438,-2493.75,3879.1682128906,"HellfireRaid",9},
			},
		},
		SelectedDot = nil,
		DebuffsBlackList = {
			[160029] = not ExRT.is7,	--Resurrecting; haven't CLEU event for removing
		},
	}
	--[[
		Dump maps func:
		function DumpCurrentMapToFightLogFormat(mapID)
			if mapID then
				SetMapByID(mapID)
			else
				mapID = GetCurrentMapAreaID()
			end
			local mapName = GetMapInfo()
			local _,MxL,MyT,MxR,MyB = GetCurrentMapZone()
			local numLevels,firstLevel = GetNumDungeonMapLevels()
			local mapNameLevelFix = 0
			local terrainMapID = GetAreaMapInfo(mapID)
			JJBox(format("[%d] = {",terrainMapID or -1))
			if numLevels == 0 and firstLevel == 0 then
				JJBox("{"..MxL..","..MyT..","..MxR..","..MyB..","..'"'..mapName..'"},')
				JJBox("},")
				return
			end
			if numLevels and firstLevel then
				for i=firstLevel,numLevels do
					SetDungeonMapLevel(i)
					local num,xR,yB,xL,yT = GetCurrentMapDungeonLevel()
					if DungeonUsesTerrainMap() then
						num = num - 1
					end
					if num == 0 and not xR then
						JJBox("{"..MxL..","..MyT..","..MxR..","..MyB..","..'"'..mapName..'"},')
						--mapNameLevelFix = 1
					elseif xR and yB and xL and yT then
						JJBox("{"..xL..","..yT..","..xR..","..yB..","..'"'..mapName..'",'..(num-mapNameLevelFix).."},")
					end
				end
			end
			JJBox("},")
		end
	]]
	
	PositionsTab_Variables.BossToMap = {
		[1721] = PositionsTab_Variables.Maps[1228][3],	--"Kargath Bladefist"
		[1706] = PositionsTab_Variables.Maps[1228][1],	--"The Butcher"
		[1720] = PositionsTab_Variables.Maps[1228][1],	--"Brackenspore"
		[1722] = PositionsTab_Variables.Maps[1228][1],	--"Tectus, The Living Mountain"
		[1719] = PositionsTab_Variables.Maps[1228][4],	--"Twin Ogron"
		[1723] = PositionsTab_Variables.Maps[1228][4],	--"Ko'ragh"
		[1705] = PositionsTab_Variables.Maps[1228][6],	--"Imperator Mar'gok"
	
		[1694] = PositionsTab_Variables.Maps[1205][4],	--"Дармак Повелитель Зверей"
		[1692] = PositionsTab_Variables.Maps[1205][4],	--"Оператор Тогар"
		[1695] = PositionsTab_Variables.Maps[1205][1],	--"Железные леди"
		[1691] = PositionsTab_Variables.Maps[1205][2],	--"Груул"
		[1696] = PositionsTab_Variables.Maps[1205][2],	--"Рудожуй Пожиратель"
		[1690] = PositionsTab_Variables.Maps[1205][2],	--"Горнило"
		[1693] = PositionsTab_Variables.Maps[1205][1],	--"Ганс'гар и Франзок"
		[1689] = PositionsTab_Variables.Maps[1205][1],	--"Ка'граз Пламенная"
		[1713] = PositionsTab_Variables.Maps[1205][1],	--"Кромог, Легенда Горы"
		[1704] = PositionsTab_Variables.Maps[1205][5],	--"Чернорук"
		
		[1778] = PositionsTab_Variables.Maps[1448][1],	--"Hellfire Assault"
		[1785] = PositionsTab_Variables.Maps[1448][1],	--"Iron Reaver"
		[1783] = PositionsTab_Variables.Maps[1448][2],	--"Gorefiend"
		[1798] = PositionsTab_Variables.Maps[1448][5],	--"Hellfire High Council"
		[1787] = PositionsTab_Variables.Maps[1448][4],	--"Kormrok"
		[1786] = PositionsTab_Variables.Maps[1448][5],	--"Kilrogg Deadeye"
		[1788] = PositionsTab_Variables.Maps[1448][6],	--"Shadow-Lord Iskar"
		[1777] = PositionsTab_Variables.Maps[1448][6],	--"Fel Lord Zakuun"
		[1800] = PositionsTab_Variables.Maps[1448][7],	--"Xhul'horac"
		[1794] = PositionsTab_Variables.Maps[1448][8],	--"Socrethar the Eternal"
		[1784] = PositionsTab_Variables.Maps[1448][8],	--"Tyrant Velhari"
		[1795] = PositionsTab_Variables.Maps[1448][9],	--"Mannoroth"
		[1799] = PositionsTab_Variables.Maps[1448][10],	--"Archimonde"
		
		[1841] = nil,	--"Ursoc"
		[1853] = nil,	--"Plague Dragon": <Nythendra>
		[1873] = nil,	--"Il'gynoth, The Heart of Corruption"
		[1854] = nil,	--"Dragons of Nightmare"
		[1864] = nil,	--"Xavius"
		[1876] = nil,	--"Elerethe Renferal"
		[1877] = nil,	--"Cenarius"
		
		[1849] = nil,	--"Skorpyron"
		[1865] = nil,	--"Anomaly"
		[1867] = nil,	--"Trilliax"
		[1842] = nil,	--"Krosus"
		[1862] = nil,	--"Tichondrius"
		[1871] = nil,	--"Spellblade Aluriel"
		[1886] = nil,	--"High Botanist Tel'arn"
		[1863] = nil,	--"Star Augur Etraeus"
		[1872] = nil,	--"Grand Magistrix Elisande"
		[1866] = nil,	--"Gul'dan"
	}
	
	local function PositionsTab_UpdatePositions(segment)
		local positionsData = module.db.data[module.db.nowNum].positionsData[segment]
		local tab = BWInterfaceFrame.tab.tabs[10]
		if not positionsData or not tab.minX or not tab.maxX or not tab.minY or not tab.maxY then
			return
		end
		for name,data in pairs(positionsData) do
			local dot = PositionsTab_Variables.NamesToDots[name]
			if dot then
				local x,y = data[1],data[2]
				if x and y then
					dot.posX = x
					dot.posY = y
					x = (tab.minX - x) / (tab.minX - tab.maxX) * tab.scroll.C:GetWidth()
					y = (tab.minY - y) / (tab.minY - tab.maxY) * tab.scroll.C:GetHeight()
					dot:SetPoint("CENTER",tab.scroll.C,"TOPLEFT",x,-y)
					dot:Show()
				else
					dot:Hide()
				end
			end
		end
		
		local time = ceil(segment / 2)
		for i=1,40 do
			tab.raidFrames[i]:Update(segment)
		end
		for i=1,5 do
			tab.unitFrames[i]:Update(time)
		end
	end
	local function PositionsTab_UpdateDistanceEarned(segment,segmentsData)
		local tab = BWInterfaceFrame.tab.tabs[10]
		local result = L.BossWatcherDistanceEarned..": "
		if segmentsData[segment] then
			local tmp = {}
			local total = 0
			for name,dist in pairs(segmentsData[segment]) do
				local unitGUID = ExRT.F.table_find2(module.db.data[module.db.nowNum].raidguids,name)
				local colorStr
				if unitGUID then
					local _,class = GetPlayerInfoByGUID(unitGUID)
					if class then
						colorStr = ExRT.F.classColor(class)
					end
				end
				if name:find("%-") then
					name = name:match("^([^%-]+)%-")
				end
				tmp[#tmp+1] = {"|c"..(colorStr or "ffbbbbbb")..name.."|r",dist}
				total = total + dist
			end
			result = result .. format("%dy",total) .. "|n"
			sort(tmp,function(a,b) return a[2]>b[2] end)
			for i=1,#tmp do
				result = result .. tmp[i][1] .. ": ".. format("%dy",tmp[i][2]) .. (i < #tmp and "|n" or "")
			end
			tab.EarnedFrame:SetHeight(10*(#tmp+1))
			if #tmp == 0 then
				result = " -- "
			end
		end
		tab.EarnedFrame.text:SetText(result)
		local w = tab.EarnedFrame.text:GetStringWidth()
		tab.EarnedFrame:SetWidth(w)
	end
	
	tab.timeSlider = ELib:Slider(tab,L.BossWatcherPositionsSlider):Size(780):Point("TOP",-10,-20):Range(1,1):OnChange(function (self,value)
		value = ExRT.F.Round(value)
		
		PositionsTab_UpdateDistanceEarned(value,self.distanceEarned)
		
		local time = floor(value / 2)
		self.tooltipText = format("%d:%02d",time / 60,time % 60)
		self:tooltipReload(self)
		
		PositionsTab_UpdatePositions(value)
	end)
	tab.timeSlider.tooltipText = "0:00"
	tab.timeSlider:SetScript("OnMinMaxChanged",function (self)
		local _min,_max = self:GetMinMaxValues()
		self.Low:SetText("0:00")
		_max = max(1,_max / 2)
		self.High:SetText(format("%d:%02d",_max / 60,_max % 60))
	end)
	tab.timeSlider:SetObeyStepOnDrag(true)
	
	tab.hideMapChk = ELib:Check(tab,""):Point(833,-16):Tooltip(L.BossWatcherPositionsHideMap):OnClick(function (self)
		local backgrounds = BWInterfaceFrame.tab.tabs[10].scroll.C.backgrounds
		if self:GetChecked() then
			for i=1,#backgrounds do
				backgrounds[i]:Hide()
			end
			PositionsTab_Variables.DisableMap = true
		else
			for i=1,#backgrounds do
				backgrounds[i]:Show()
			end
			PositionsTab_Variables.DisableMap = nil
		end
		PositionsTab_UpdatePage()
	end)
		
	tab.scroll = ELib:ScrollFrame(tab):Size(835,540):Point("TOP",0,-50):Height(540)
	tab.scroll.ScrollBar:Hide()
	tab.scroll.C:SetWidth( tab.scroll:GetWidth() - 4 )
	
	tab.scroll.C.backgrounds = {}
	local PositionsTab_BackgroundsWidth = tab.scroll:GetWidth() * 256 / 1002
	local PositionsTab_BackgroundsHeight = tab.scroll:GetHeight() * 256 / 668
	
	for i=1,4 do
		for j=0,2 do
			tab.scroll.C.backgrounds[ j * 4 + i ] = tab.scroll.C:CreateTexture(nil, "BACKGROUND",nil,-7)
			tab.scroll.C.backgrounds[ j * 4 + i ]:SetSize(PositionsTab_BackgroundsWidth,PositionsTab_BackgroundsHeight)
			tab.scroll.C.backgrounds[ j * 4 + i ]:SetPoint("TOPLEFT",PositionsTab_BackgroundsWidth * (i-1),-j*PositionsTab_BackgroundsHeight)
		end
	end
	
	tab.scroll.scrollH = 0
	tab.scroll.scrollV = 0
	tab.scroll:SetScript("OnMouseWheel",function (self,delta)
		local x,y = ExRT.F.GetCursorPos(self)
	
		local oldScale = self.C:GetScale()
		local newScale = oldScale + delta * 0.25
		if newScale < 1 then
			newScale = 1
		elseif newScale > 7 then
			newScale = 7
		end
		self.C:SetScale( newScale )
		
		self.scrollH = self:GetWidth() - self:GetWidth() / newScale
		self.scrollV = self:GetHeight() - self:GetHeight() / newScale
		
		local scrollNowH = self:GetHorizontalScroll()
		local scrollNowV = self:GetVerticalScroll()

		scrollNowH = scrollNowH + x / oldScale - x / newScale
		scrollNowV = scrollNowV + y / oldScale - y / newScale
		
		if scrollNowH > self.scrollH then scrollNowH = self.scrollH end
		if scrollNowH < 0 then scrollNowH = 0 end
		if scrollNowV > self.scrollV then scrollNowV = self.scrollV end
		if scrollNowV < 0 then scrollNowV = 0 end
		
		self:SetHorizontalScroll(scrollNowH)
		self:SetVerticalScroll(scrollNowV)
		
		for i=1,#BWInterfaceFrame.tab.tabs[10].player do
			BWInterfaceFrame.tab.tabs[10].player[i].SubDot:SetScale(1 / newScale)
		end
	end)
	tab.scroll:SetScript("OnMouseDown",function (self)
		local x, y = GetCursorPosition()
		self.cursorX = x
		self.cursorY = y
		self.scrollNowH = self:GetHorizontalScroll()
		self.scrollNowV = self:GetVerticalScroll()
		self.move = true
		GameTooltip_Hide()
	end)
	tab.scroll:SetScript("OnMouseUP",function (self)
		self.move = nil
	end)
		
	tab.scroll.tooltipShown = {}
	tab.scroll:SetScript("OnUpdate",function (self)
		if not self.move then
			if not MouseIsOver(self) then
				return
			end
			if self.disableTooltip then
				return
			end
			local tooltip = nil
			for i=1,#self.player do
				self.tooltipShown[i] = nil
				local frame = self.player[i].SubDot
				if frame:IsVisible() and MouseIsOver(frame) then
					tooltip = true
					self.tooltipShown[i] = true
				end
			end
			if not tooltip then
				GameTooltip_Hide()
			else
				GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
				GameTooltip:SetText(TUTORIAL_TITLE19)
				for i=1,#self.player do
					if self.tooltipShown[i] then
						local distText = nil
						if PositionsTab_Variables.SelectedDot then
							local dot1,dot2 = PositionsTab_Variables.SelectedDot,self.player[i]
							if dot1.posX and dot2.posX then
								local dX = dot1.posX - dot2.posX
								local dY = dot1.posY - dot2.posY
								distText = " |cff999999(dist: ".. floor( sqrt(dX * dX + dY * dY) + 0.5 ).."y)"
							end
						end
						GameTooltip:AddLine(self.player[i].playerName..(distText or ""),1,1,1)
					end
				end
				GameTooltip:Show()
			end
			return
		end
		local x, y = GetCursorPosition()
		x,y = self.cursorX - x,self.cursorY - y
		
		local setH = self.scrollNowH + (x / self.C:GetScale())
		if setH < 0 then
			setH = 0
		elseif setH > self.scrollH then
			setH = self.scrollH
		end
		
		local setV = self.scrollNowV - (y / self.C:GetScale())
		if setV < 0 then
			setV = 0
		elseif setV > self.scrollV then
			setV = self.scrollV
		end
		
		self:SetHorizontalScroll(setH)
		self:SetVerticalScroll(setV)
	end)
	
	tab.player = {}
	tab.scroll.player = tab.player
	
	tab.SelectMapDropDown = ELib:DropDown(tab.scroll,205,5):Size(100):Point("BOTTOMRIGHT",-5,5):SetText("Select Map...")
	local function PositionsTab_SelectMapDropDown_SetValue(_,arg)
		PositionsTab_Variables.SelectedMap = arg
		PositionsTab_UpdatePage()
		if IsShiftKeyDown() then
			BWInterfaceFrame.tab.tabs[10].SelectMapDropDown:Hide()
		end
		ELib:DropDownClose()
	end
	do
		local contentTitles = {
			[0] = "WoW",
			[1] = "Classic",
			[2] = "BC",
			[3] = "WotLK",
			[4] = "Cataclysm",
			[5] = "MoP",
			[6] = "WoD",
			[7] = "Brave new world",
		}
	
		tab.SelectMapDropDown.List[1] = {text = "Raids", subMenu = {}, Lines = 15}
		tab.SelectMapDropDown.List.raid = tab.SelectMapDropDown.List[1].subMenu

		tab.SelectMapDropDown.List[2] = {text = "Dungeons", subMenu = {}, Lines = 15}
		tab.SelectMapDropDown.List.dungeon = tab.SelectMapDropDown.List[2].subMenu
		
		tab.SelectMapDropDown.List[3] = {text = "PvP", subMenu = {}, Lines = 15}
		tab.SelectMapDropDown.List.pvp = tab.SelectMapDropDown.List[3].subMenu

		tab.SelectMapDropDown.List[4] = {text = "Other", subMenu = {}, Lines = 15}
		tab.SelectMapDropDown.List.other = tab.SelectMapDropDown.List[4].subMenu
		
		for mapID,maps in pairs(PositionsTab_Variables.Maps) do
			local subMenu = tab.SelectMapDropDown.List[ maps.type or "other" ]
			if subMenu then
				for i=1,#maps do
					subMenu[#subMenu + 1] = {
						text = maps[i][5]..(maps[i][6] or ""),
						func = PositionsTab_SelectMapDropDown_SetValue,
						arg1 = maps[i],
						_sort = (maps.content or 0) * 1000000 + mapID * 100 + 99 - i,
						content = (maps.content or 0),
					}
				end
			end
		end
		for i=1,#tab.SelectMapDropDown.List do
			local subMenu = tab.SelectMapDropDown.List[i].subMenu
			sort(subMenu,function(a,b) return a._sort > b._sort end)
			local listLen = #subMenu
			if listLen > 0 then
				local contentNow = subMenu[listLen].content
				for j=(listLen-1),1,-1 do
					local content = subMenu[j].content
					if content ~= contentNow then
						if contentNow ~= 0 then
							tinsert(subMenu,j+1,{text = contentTitles[contentNow], isTitle = true})
						end
						contentNow = content
					end
				end
				if contentNow ~= 0 then
					tinsert(subMenu,1,{text = contentTitles[contentNow], isTitle = true})
				end
			end
		end
		tab.SelectMapDropDown.List[#tab.SelectMapDropDown.List + 1] = {
			text = "None",
			func = PositionsTab_SelectMapDropDown_SetValue,
		}
	end
	
	tab.EarnedFrame = CreateFrame("Frame",nil,tab.scroll)
	tab.EarnedFrame:SetWidth(150)
	tab.EarnedFrame:SetPoint("BOTTOMRIGHT",tab.SelectMapDropDown,"TOPRIGHT",0,5)
	tab.EarnedFrame.background = ELib:Texture(tab.EarnedFrame,0.05,0.05,0.07,.7):Point('x')
	ELib:Border(tab.EarnedFrame,1,0,0,0,1)
	tab.EarnedFrame.text = ELib:Text(tab.EarnedFrame,"",10):Point('x'):Left():Top():Color()
	
	tab.EarnedFrame.close = ELib:Button(tab.EarnedFrame,"",1):Point("BOTTOMRIGHT",tab.EarnedFrame,"TOPRIGHT",0,0):Size(14,14):OnClick(function(self)
		local parent = self:GetParent()
		parent.EarnedFrameExploreButton:Show()
		parent:Hide()
		VExRT.BossWatcher.optionsPositionsDist = nil
	end)
	tab.EarnedFrame.close:SetHighlightTexture( ELib:Texture(tab.EarnedFrame.close,"Interface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128"):Point('x'):Color(1,0,0,1):TexCoord(0.5,0.5625,0.5,0.625) )
	tab.EarnedFrame.close:SetNormalTexture( ELib:Texture(tab.EarnedFrame.close,"Interface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128"):Point('x'):Color(1,1,1,.7):TexCoord(0.5,0.5625,0.5,0.625) )
	
	tab.EarnedFrameExploreButton = ELib:Button(tab.scroll,"",1):Point("BOTTOMRIGHT",tab.SelectMapDropDown,"TOPRIGHT",-2,5):Size(16,16):Tooltip(L.BossWatcherDistanceEarned):OnClick(function(self)
		self:Hide()
		self.EarnedFrame:Show()
		VExRT.BossWatcher.optionsPositionsDist = true
	end)
	tab.EarnedFrameExploreButton.EarnedFrame = tab.EarnedFrame
	tab.EarnedFrame.EarnedFrameExploreButton = tab.EarnedFrameExploreButton
	ELib:Border(tab.EarnedFrameExploreButton,1,0.24,0.25,0.30,1)
	tab.EarnedFrameExploreButton.background = ELib:Texture(tab.EarnedFrameExploreButton,0,0,0,.3):Point('x')

	tab.EarnedFrameExploreButton:SetHighlightTexture( ELib:Texture(tab.EarnedFrameExploreButton,"Interface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128"):Point("TOPLEFT",-5,2):Point("BOTTOMRIGHT",5,-2):Color(1,1,1,1):TexCoord(0.25,0.3125,0.625,0.5) )
	tab.EarnedFrameExploreButton:SetNormalTexture( ELib:Texture(tab.EarnedFrameExploreButton,"Interface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128"):Point("TOPLEFT",-5,2):Point("BOTTOMRIGHT",5,-2):Color(1,1,1,.7):TexCoord(0.25,0.3125,0.625,0.5) )
	
	if VExRT.BossWatcher.optionsPositionsDist then
		tab.EarnedFrameExploreButton:Hide()
	else
		tab.EarnedFrame:Hide()
	end

	local function PositionsTab_RaidFrame_UpdateHP(self,segment)
		if not self.Unit then
			self:Hide()
			return
		end
		local sec = ceil(segment / 2)
		local data = module.db.data[module.db.nowNum].graphData[sec]
		if not data then
			self:Hide()
			return
		end
		self:Show()
		
		local hpNow = data[self.Unit] and data[self.Unit].health or 0
		local hpMax = data[self.Unit] and data[self.Unit].hpmax or 0
		if hpMax == 0 or hpNow == 0 then
			self.hp:Hide()
		else
			self.hp:Show()
			self.hp:SetWidth(max(hpNow / hpMax * 50,1))
		end
		
		local data = self.debuffsData and self.debuffsData[segment]
		if not data then
			for i=1,#self.debuffs do
				self.debuffs[i]:Hide()
			end
		else
			for i=1,#data do
				if i > #self.debuffs then
					break
				end
				local spellID = floor( data[i] )
				local texture = GetSpellTexture(data[i])
				self.debuffs[i]:Texture(texture)
				self.debuffs[i].spellID = spellID
				local timeLeft = (data[i] % 1) * 1000
				self.debuffs[i].timeLeft = floor(timeLeft)
				self.debuffs[i]:Show()
			end
			for i=#data+1,#self.debuffs do
				self.debuffs[i]:Hide()
			end
		end
	end
	local function PositionsTab_UnitFrame_UpdateHP(self,sec)
		if not self.Unit then
			self:Hide()
			return
		end
		local data = module.db.data[module.db.nowNum].graphData[sec]
		if not data then
			self:Hide()
			return
		end
		
		self.text:SetText(data[self.Unit] and data[self.Unit].name or self.Unit)
		local hpNow = data[self.Unit] and data[self.Unit].health or 0
		local hpMax = data[self.Unit] and data[self.Unit].hpmax or 0
		if hpMax == 0 then
			self:Hide()
			return
		end
		self:Show()
		if hpMax == 0 or hpNow == 0 then
			self.hp:Hide()
			return
		end
		self.hp:Show()
		self.hp:SetWidth(max(hpNow / hpMax * 95,1))
		
		self.hp_text:SetFormattedText("%.1f",hpNow / hpMax * 100)
	end
	
	local function PositionsTab_RaidFrame_DebuffOnEnter(self)
		BWInterfaceFrame.tab.tabs[10].scroll.disableTooltip = true
		if self.spellID then
			ELib.Tooltip.Link(self,"spell:"..self.spellID)
			if self.stacks then
				GameTooltip:AddLine(L.BossWatcherBuffsAndDebuffsTooltipCountText..": "..self.stacks)
				GameTooltip:Show()
			end
			if self.timeLeft then
				GameTooltip:AddLine(format(PET_TIME_LEFT_SECONDS,self.timeLeft + 1))
				GameTooltip:Show()
			end
		end
	end
	local function PositionsTab_RaidFrame_DebuffOnLeave(self)
		BWInterfaceFrame.tab.tabs[10].scroll.disableTooltip = nil
		ELib.Tooltip:Hide()
	end
		
	tab.raidFrames = {}
	for i=1,8 do
		for j=1,5 do
			local frame = CreateFrame("Button",nil,tab.scroll)
			tab.raidFrames[(i-1)*5+j] = frame
			frame:SetSize(50,16)
			frame:SetPoint("BOTTOMLEFT",tab.scroll,5+(i-1)*53,5+(j-1)*19)
			frame.text = ELib:Text(frame,UnitName('player'),10):Size(50,14):Point(0,0):Center():Color()
			frame.text:SetDrawLayer("ARTWORK", 0)
			
			frame.bordertop = frame:CreateTexture(nil, "BORDER")
			frame.borderbottom = frame:CreateTexture(nil, "BORDER")
			frame.borderleft = frame:CreateTexture(nil, "BORDER")
			frame.borderright = frame:CreateTexture(nil, "BORDER")
			
			frame.bordertop:SetPoint("TOPLEFT",frame,"TOPLEFT",-1,1)
			frame.bordertop:SetPoint("BOTTOMRIGHT",frame,"TOPRIGHT",1,0)
		
			frame.borderbottom:SetPoint("BOTTOMLEFT",frame,"BOTTOMLEFT",-1,-1)
			frame.borderbottom:SetPoint("TOPRIGHT",frame,"BOTTOMRIGHT",1,0)
		
			frame.borderleft:SetPoint("TOPLEFT",frame,"TOPLEFT",-1,0)
			frame.borderleft:SetPoint("BOTTOMRIGHT",frame,"BOTTOMLEFT",0,0)
		
			frame.borderright:SetPoint("TOPLEFT",frame,"TOPRIGHT",0,0)
			frame.borderright:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT",1,0)
		
			frame.bordertop:SetColorTexture(0,0,0,1)
			frame.borderbottom:SetColorTexture(0,0,0,1)
			frame.borderleft:SetColorTexture(0,0,0,1)
			frame.borderright:SetColorTexture(0,0,0,1)
			
			frame.back = frame:CreateTexture(nil, "BACKGROUND",nil,-5)
			frame.back:SetSize(50,16)
			frame.back:SetPoint("LEFT",0,0)
			frame.back:SetColorTexture(.05,.05,.05,1)

			frame.hp = frame:CreateTexture(nil, "BACKGROUND",nil,0)
			frame.hp:SetSize(50,16)
			frame.hp:SetPoint("LEFT",0,0)
			frame.hp:SetColorTexture(.3,.3,.3,1)
			
			frame.Update = PositionsTab_RaidFrame_UpdateHP
			
			frame.debuffs = {}
			for i=1,5 do
				frame.debuffs[i] = ELib:Frame(frame):Point("CENTER",frame,"TOPLEFT",4 + (i-1)*9,-2):Size(8,8):Texture(GetSpellTexture(25771),nil):TexturePoint('x')
				frame.debuffs[i]:SetScript("OnEnter",PositionsTab_RaidFrame_DebuffOnEnter)
				frame.debuffs[i]:SetScript("OnLeave",PositionsTab_RaidFrame_DebuffOnLeave)
			end
			frame:Hide()
		end
	end
	
	tab.unitFrames = {}
	for i=1,5 do
		local frame = CreateFrame("Button",nil,tab.scroll)
		tab.unitFrames[i] = frame
		frame:SetSize(95,20)
		frame:SetPoint("TOPLEFT",tab.scroll,5,-200-(i-1)*23)	
		frame.text = ELib:Text(frame,UnitName('player'),10):Size(55,20):Point(2,0):Color()
		frame.text:SetDrawLayer("ARTWORK", 0)

		frame.hp_text = ELib:Text(frame,"99.9%",10):Size(36,20):Point(57,0):Right():Color()
		frame.hp_text:SetDrawLayer("ARTWORK", 0)
		
		frame.bordertop = frame:CreateTexture(nil, "BORDER")
		frame.borderbottom = frame:CreateTexture(nil, "BORDER")
		frame.borderleft = frame:CreateTexture(nil, "BORDER")
		frame.borderright = frame:CreateTexture(nil, "BORDER")
		
		frame.bordertop:SetPoint("TOPLEFT",frame,"TOPLEFT",-1,1)
		frame.bordertop:SetPoint("BOTTOMRIGHT",frame,"TOPRIGHT",1,0)
	
		frame.borderbottom:SetPoint("BOTTOMLEFT",frame,"BOTTOMLEFT",-1,-1)
		frame.borderbottom:SetPoint("TOPRIGHT",frame,"BOTTOMRIGHT",1,0)
	
		frame.borderleft:SetPoint("TOPLEFT",frame,"TOPLEFT",-1,0)
		frame.borderleft:SetPoint("BOTTOMRIGHT",frame,"BOTTOMLEFT",0,0)
	
		frame.borderright:SetPoint("TOPLEFT",frame,"TOPRIGHT",0,0)
		frame.borderright:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT",1,0)
	
		frame.bordertop:SetColorTexture(0,0,0,1)
		frame.borderbottom:SetColorTexture(0,0,0,1)
		frame.borderleft:SetColorTexture(0,0,0,1)
		frame.borderright:SetColorTexture(0,0,0,1)
		
		frame.back = frame:CreateTexture(nil, "BACKGROUND",nil,-5)
		frame.back:SetSize(95,20)
		frame.back:SetPoint("LEFT",0,0)
		frame.back:SetColorTexture(.05,.05,.05,1)

		frame.hp = frame:CreateTexture(nil, "BACKGROUND",nil,0)
		frame.hp:SetSize(95,20)
		frame.hp:SetPoint("LEFT",0,0)
		frame.hp:SetColorTexture(.3,.3,.3,1)
		
		frame.Update = PositionsTab_UnitFrame_UpdateHP
		
		frame:Hide()
	end
	
	local function PositionsTab_DotOnUpdate(self,elapsed)
		self.anim = self.anim + elapsed
		if self.anim > 0.4 then
			self.anim = self.anim - 0.4
		end
		local alpha = self.anim
		if alpha > 0.2 then
			alpha = alpha - 0.2
			if alpha > 0.2 then
				alpha = 0.2
			end
			self:SetAlpha(0.5 + alpha * 2.5)
		else
			self:SetAlpha(1 - alpha * 2.5)
		end
		
	end
	local function PositionsTab_DotOnClick(self)
		self.anim = 0
		local tab = BWInterfaceFrame.tab.tabs[10]
		local isAnimOn = self.animOn
		for i=1,#tab.player do
			if tab.player[i].SubDot.animOn then
				tab.player[i].SubDot:SetScript("OnUpdate",nil)
				tab.player[i].SubDot.animOn = nil
				tab.player[i].SubDot:SetAlpha(1)
			end
		end
		PositionsTab_Variables.SelectedDot = nil
		if not isAnimOn then
			self:SetScript("OnUpdate",PositionsTab_DotOnUpdate)
			self.animOn = true
			PositionsTab_Variables.SelectedDot = self:GetParent()
		end
	end
		
	function PositionsTab_UpdatePage()
		local tab = BWInterfaceFrame.tab.tabs[10]
		local positionsData = module.db.data[module.db.nowNum].positionsData
		local minX,maxX,minY,maxY
		local knownMap = nil
		local distanceEarned = {[1]={}}
		
		local encounterID = module.db.data[module.db.nowNum].encounterID
		if encounterID and PositionsTab_Variables.BossToMap[encounterID] then
			knownMap = PositionsTab_Variables.BossToMap[encounterID]
		end
		knownMap = PositionsTab_Variables.SelectedMap or knownMap
		
		for _,posData in ipairs(positionsData) do
			for name,data in pairs(posData) do
				if data[1] and data[2] and data[1] ~= 0 and data[2] ~= 0 then
					minX = minX and max(minX,data[1]) or data[1]
					maxX = maxX and min(maxX,data[1]) or data[1]
					minY = minY and max(minY,data[2]) or data[2]
					maxY = maxY and min(maxY,data[2]) or data[2]
					
					if not knownMap and data[3] and PositionsTab_Variables.Maps[ data[3] ] then
						local compareMap = PositionsTab_Variables.Maps[ data[3] ]
						for i=1,#compareMap do
							if data[1] < compareMap[i][1] and data[1] > compareMap[i][3] and data[2] < compareMap[i][2] and data[2] > compareMap[i][4] then
								knownMap = compareMap[i]
								break
							end
						end
					end
				end
			end
			
		end
		if knownMap and not PositionsTab_Variables.DisableMap then
			tab.minX = knownMap[1]
			tab.maxX = knownMap[3]
			tab.minY = knownMap[2]
			tab.maxY = knownMap[4]
			for i=1,12 do
				tab.scroll.C.backgrounds[i]:SetTexture("Interface\\WorldMap\\"..knownMap[5].."\\"..(knownMap[6] and knownMap[5]..knownMap[6].."_"..i or knownMap[5]..i))
			end
		elseif positionsData.mapInfo and not PositionsTab_Variables.DisableMap then
			local mapInfo = positionsData.mapInfo
			tab.minX = mapInfo.xL
			tab.maxX = mapInfo.xR
			tab.minY = mapInfo.yT
			tab.maxY = mapInfo.yB
			for i=1,12 do
				tab.scroll.C.backgrounds[i]:SetTexture("Interface\\WorldMap\\"..mapInfo.map.."\\"..mapInfo.map..(mapInfo.level and mapInfo.level.."_" or "")..i)
			end
		else
			tab.minX = minX
			tab.maxX = maxX
			tab.minY = minY
			tab.maxY = maxY
			for i=1,12 do
				tab.scroll.C.backgrounds[i]:SetTexture("")
			end
		end
		for i=1,#tab.player do
			tab.player[i]:Hide()
		end
		wipe(PositionsTab_Variables.NamesToDots)
		local dotCount = 0
		local raidFrames = {}
		if positionsData[1] then
			for name,data in pairs(positionsData[1]) do
				dotCount = dotCount + 1
				if not tab.player[dotCount] then
					local dot = CreateFrame("Frame",nil,tab.scroll.C)
					tab.player[dotCount] = dot
					dot:SetSize(18,18)
					dot.SubDot = CreateFrame("Button",nil,dot)
					dot.SubDot:SetPoint("CENTER",0,0)
					dot.SubDot:SetSize(18,18)
					dot.SubDot:SetScript("OnClick",PositionsTab_DotOnClick)
					dot.texture = dot.SubDot:CreateTexture(nil, "ARTWORK")
					dot.texture:SetAllPoints(dot.SubDot)
					dot.texture:SetTexture("Interface\\AddOns\\ExRT\\media\\blip.tga")
				end
				PositionsTab_Variables.NamesToDots[ name ] = tab.player[dotCount]
				
				local unitGUID = ExRT.F.table_find2(module.db.data[module.db.nowNum].raidguids,name)
				local cR,cG,cB = .8,.8,.8
				if unitGUID then
					local class = select(2,GetPlayerInfoByGUID(unitGUID))
					if class then
						cR,cG,cB = ExRT.F.classColorNum(class)
					end
				end
				tab.player[dotCount].texture:SetVertexColor(cR,cG,cB,1)
				tab.player[dotCount].playerName = name
				
				raidFrames[#raidFrames + 1] = {name,cR,cG,cB}
			end
		end
		sort(raidFrames,function(a,b) return a[1]<b[1] end)
		if module.db.data[module.db.nowNum].graphData and module.db.data[module.db.nowNum].graphData[1] then
			for i=1,#raidFrames do
				tab.raidFrames[i].Unit = raidFrames[i][1]
				tab.raidFrames[i].text:SetTextColor(raidFrames[i][2],raidFrames[i][3],raidFrames[i][4],1)
				tab.raidFrames[i].text:SetText(raidFrames[i][1])
				tab.raidFrames[i]:Update(1)
				
				--- debuffs list
				local debuffsData = {}
				tab.raidFrames[i].debuffsData = debuffsData
				local guid = nil
				for guidNow,nameNow in pairs(module.db.data[module.db.nowNum].raidguids) do
					if nameNow == raidFrames[i][1] then
						guid = guidNow
						break
					end
				end
				if guid then
					local current = {}
					local currFight = module.db.data[module.db.nowNum].fight
					for j=1,#currFight do
						local aurasData = currFight[j].auras
						for k=1,#aurasData do
							local aurasLine = aurasData[k]
							if aurasLine[3] == guid and aurasLine[7] == 'DEBUFF' then
								local time_ = floor( timestampToFightTime( aurasLine[1] ) * 2 ) + 1
								local spellID = aurasLine[6]
								if not PositionsTab_Variables.DebuffsBlackList[ spellID ] then
									if aurasLine[8] ~= 2 then
										current[ spellID ] = current[ spellID ] or time_
									elseif aurasLine[8] == 2 then
										local start = current[ spellID ] or 1
										for l = start, time_ do
											debuffsData[l] = debuffsData[l] or {}
											tinsert(debuffsData[l],spellID+((time_ - l)%1000)/1000)
										end
										current[ spellID ] = nil
									end
								end
							end
						end
					end
					local positionsData_len = #positionsData
					for spellID,start in pairs(current) do
						for j=start, positionsData_len do
							debuffsData[j] = debuffsData[j] or {}
							tinsert(debuffsData[j],spellID+((positionsData_len - j)%1000)/1000)
						end
					end
					
					tab.raidFrames[i]:Update(1)
				end
			end
			for i=#raidFrames+1,40 do
				tab.raidFrames[i].Unit = nil
				tab.raidFrames[i]:Update()
			end
			for i=1,5 do
				tab.unitFrames[i].Unit = "boss"..i
				tab.unitFrames[i]:Update(1)
			end
		else
			for i=1,40 do
				tab.raidFrames[i].Unit = nil
				tab.raidFrames[i]:Update()
			end
			for i=1,5 do
				tab.unitFrames[i].Unit = nil
				tab.unitFrames[i]:Update()
			end
		end
		
		for i=2,#positionsData do
			distanceEarned[i] = {}
			for name,data in pairs(positionsData[i]) do
				distanceEarned[1][name] = 0
				local prevData = positionsData[i-1] and positionsData[i-1][name]
				if prevData then
					distanceEarned[i][name] = 0
				
					local prevX,prevY = prevData[1],prevData[2]
					local currX,currY = data[1],data[2]
					
					if currX and currY then
						local dX = prevX - currX
						local dY = prevY - currY
						local dist = sqrt(dX * dX + dY * dY)
						
						distanceEarned[i][name] = dist + (distanceEarned[i-1] and distanceEarned[i-1][name] or 0)
					end
				end
			end
		end
		
		tab.timeSlider:SetMinMaxValues(1,max(1,#positionsData))
		tab.timeSlider.distanceEarned = distanceEarned
		
		tab.scroll.C:SetScale(1)
		tab.scroll.scrollH = 0
		tab.scroll.scrollV = 0		
		tab.scroll:SetHorizontalScroll(0)
		tab.scroll:SetVerticalScroll(0)
		for i=1,#tab.player do
			tab.player[i].SubDot:SetScale(1)
		end
		
		tab.timeSlider:SetValue(1)
		PositionsTab_UpdatePositions(1)
	end
	
	tab:SetScript("OnShow",function (self)
		if BWInterfaceFrame.nowFightID ~= self.lastFightID then
			PositionsTab_UpdatePage()
			self.lastFightID = BWInterfaceFrame.nowFightID
		end
		
		if IsShiftKeyDown() then
			BWInterfaceFrame.tab.tabs[10].SelectMapDropDown:Hide()
		else
			BWInterfaceFrame.tab.tabs[10].SelectMapDropDown:Show()
		end
	end)

end