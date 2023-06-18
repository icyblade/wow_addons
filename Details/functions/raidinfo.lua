local LBB = LibStub("LibBabble-Boss-3.0"):GetLookupTable()
local LBZ = LibStub("LibBabble-Zone-3.0"):GetLookupTable()

local tinsert, select, EJ_SelectInstance, EJ_GetInstanceInfo, EJ_GetEncounterInfoByIndex, EJ_GetCreatureInfo =
tinsert, select, EJ_SelectInstance, EJ_GetInstanceInfo, EJ_GetEncounterInfoByIndex, EJ_GetCreatureInfo

local function BuildInstanceInfo(EJ_INSTANCEID)
	EJ_SelectInstance(EJ_INSTANCEID)
	local mapName, _, _, dungeonBG, backgroundEJ, mapID = EJ_GetInstanceInfo()

	local ENCOUNTERS = {}
	local BOSSNAMES = {}

	local bossIndex = 1
	local name, _, bossID = EJ_GetEncounterInfoByIndex(bossIndex)
	while bossID do
		local portrait = select(5, EJ_GetCreatureInfo(1, bossID))
		tinsert(NickTag.avatar_pool, { portrait, name })
		local encounterTable = {
			boss = name,
			portrait = portrait,
		}
		tinsert(ENCOUNTERS, encounterTable)
		tinsert(BOSSNAMES, name)

		bossIndex = bossIndex + 1
		name, _, bossID = EJ_GetEncounterInfoByIndex(bossIndex)
	end
	return mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES
end

-- BK
do --> data for Serpentshrine Cavern
	local INSTANCE_MAPID = 863
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "SerpentshrineCavern"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LOADSCREENCOILFANG", {0, 1, 285/1024, 875/1024}

	local ENCOUNTER_ID_CL = {
		21216, 21217, 21215, 21214, 21213, 21212,
		[21216] = 1, --Hydross the Unstable
		[21217] = 2, --The Lurker Below
		[21215] = 3, --Leotheras the Blind
		[21214] = 4, --Fathom-Lord Karathress
		[21213] = 5, --Morogrim Tidewalker
		[21212] = 6, --Lady Vashj
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Hydross the Unstable"],
		LBB["The Lurker Below"],
		LBB["Leotheras the Blind"],
		LBB["Fathom-Lord Karathress"],
		LBB["Morogrim Tidewalker"],
		LBB["Lady Vashj"],
	}

	local ENCOUNTERS = {}

	for i = 1, #BOSSNAMES do
		local encounterTable = {
			boss = BOSSNAMES[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Serpentshrine Cavern"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[21216] = 1, --Hydross the Unstable
			[21217] = 2, --The Lurker Below
			[21215] = 3, --Leotheras the Blind
			[21214] = 4, --Fathom-Lord Karathress
			[21213] = 5, --Morogrim Tidewalker
			[21212] = 6, --Lady Vashj
		},
	})
end

do --> data for Magtheridon's Lair
	local INSTANCE_MAPID = 866
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "MagtheridonLair"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LOADSCREENHELLFIRECITADELRAID", {0, 1, 285/1024, 875/1024}

	local ENCOUNTER_ID_CL = {
		17257,
		[17257] = 1, --Magtheridon
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Magtheridon"],
	}

	local ENCOUNTERS = {}

	for i = 1, #BOSSNAMES do
		local encounterTable = {
			boss = BOSSNAMES[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Magtheridon's Lair"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[17257] = 1, --Magtheridon
		},
	})
end

do --> data for Gruul's Lair
	local INSTANCE_MAPID = 865
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "GruulLair"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LOADSCREENGRUULSLAIR", {0, 1, 285/1024, 875/1024}

	local ENCOUNTER_ID_CL = {
		18831, 19044,
		[18831] = 1, --High King Maulgar
		[19044] = 2, --Gruul the Dragonkiller
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["High King Maulgar"],
		LBB["Gruul the Dragonkiller"],
	}

	local ENCOUNTERS = {}

	for i = 1, #BOSSNAMES do
		local encounterTable = {
			boss = BOSSNAMES[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Gruul's Lair"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[18831] = 1, --High King Maulgar
			[19044] = 2, --Gruul the Dragonkiller
		},
	})
end

do --> data for Magisters' Terrace
	local INSTANCE_MAPID = 798
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "MagistersTerrace"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenSunwell5Man", {0, 1, 285/1024, 875/1024}

	local ENCOUNTER_ID_CL = {
		24723,	-- Selin Fireheart
		24744,	-- Vexallus
		24560,	-- Priestess Delrissa
		24664,	-- Kael'thas Sunstrider
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	--> install the raid
	local BOSSNAMES = {
		LBB["Selin Fireheart"],
		LBB["Vexallus"],
		LBB["Priestess Delrissa"],
		LBB["Kael'thas Sunstrider"],
	}

	local ENCOUNTERS = {}

	for i = 1, #BOSSNAMES do
		local encounterTable = {
			boss = BOSSNAMES[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Magisters' Terrace"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		is_raid = false,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[24723]	= 1,	-- Selin Fireheart
			[24744]	= 2,	-- Vexallus
			[24560]	= 3,	-- Priestess Delrissa
			[24664]	= 4,	-- Kael'thas Sunstrider
		},
	})
end

do --> data for Karazhan
	local INSTANCE_EJID = 532
	local INSTANCE_MAPID = 868
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "Karazhan"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenKarazhan", {0, 1, 285/1024, 875/1024}

	local ENCOUNTER_ID_CL = {}
	local i = 1
	for bossId = 652, 662 do
		tinsert(ENCOUNTER_ID_CL, bossId)
		ENCOUNTER_ID_CL[bossId] = i
		i = i + 1
	end

	--> install the raid
	local BOSSNAMES = {
		LBB["Attumen the Huntsman"],
		LBB["Moroes"],
		LBB["Maiden of Virtue"],
		LBB["Opera Event"],
		LBB["The Curator"],
		LBB["Terestian Illhoof"],
		LBB["Shade of Aran"],
		LBB["Netherspite"],
		LBB["Chess Event"],
		LBB["Nightbane"],
		LBB["Prince Malchezaar"],
	}

	local ENCOUNTERS = {}

	for i = 1, #BOSSNAMES do
		local encounterTable = {
			boss = BOSSNAMES[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Karazhan"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
		},
	})
end

do --> data for The Eye
	local INSTANCE_MAPID = 862
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "TheEye"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LOADSCREENTEMPESTKEEP", {0, 1, 285/1024, 875/1024}
	-- TODO: Opera
	local ENCOUNTER_ID_CL = {
		19514, 19516, 18805, 19622,
		[19514] = 1, --Al'ar
		[19516] = 2, --Void Reaver
		[18805] = 3, --High Astromancer Solarian
		[19622] = 4, --Kael'thas Sunstrider
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Al'ar"],
		LBB["Void Reaver"],
		LBB["High Astromancer Solarian"],
		LBB["Kael'thas Sunstrider"],
	}

	local ENCOUNTERS = {}

	for i = 1, #BOSSNAMES do
		local encounterTable = {
			boss = BOSSNAMES[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["The Eye"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[19514] = 1, --Al'ar
			[19516] = 2, --Void Reaver
			[18805] = 3, --High Astromancer Solarian
			[19622] = 4, --Kael'thas Sunstrider
		},
	})
end

do --> data for The Black Temple
	local INSTANCE_MAPID = 796
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "BlackTemple"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenBlackTemple", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[22887]	= 1,	-- High Warlord Naj'entus
		[22898]	= 2,	-- Supremus
		[22841]	= 3,	-- Shade of Akama
		[22871]	= 4,	-- Teron Gorefiend
		[22948]	= 5,	-- Gurtogg Bloodboil
		[23420]	= 6,	-- Essence of Anger
		[23419]	= 6,	-- Essence of Desire
		[23418]	= 6,	-- Essence of Suffering
		[22947]	= 7,	-- Mother Shahraz
		[23426]	= 8,	-- Illidari Council
		[22949]	= 8,	-- Gathios the Shatterer
		[22950]	= 8,	-- High Nethermancer Zerevor
		[22951]	= 8,	-- Lady Malande
		[22952]	= 8,	-- Veras Darkshadow
		[22917]	= 9,	-- Illidan Stormrage
	}

	local ENCOUNTER_ID_CL = {
		22887,	-- High Warlord Naj'entus
		22898,	-- Supremus
		22841,	-- Shade of Akama
		22871,	-- Teron Gorefiend
		22948,	-- Gurtogg Bloodboil
		23418,	-- Essence of Suffering
		22947,	-- Mother Shahraz
		22952,	-- Veras Darkshadow
		22917,	-- Illidan Stormrage
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["High Warlord Naj'entus"],
		LBB["Supremus"],
		LBB["Shade of Akama"],
		LBB["Teron Gorefiend"],
		LBB["Gurtogg Bloodboil"],
		LBB["Reliquary of Souls"],
		LBB["Mother Shahraz"],
		LBB["The Illidari Council"],
		LBB["Illidan Stormrage"],
	}

	local ENCOUNTERS = {}

	for i = 1, #BOSSNAMES do
		local encounterTable = {
			boss = BOSSNAMES[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Black Temple"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

-- WotLK

do --> data for Onyxia's Lair
	local INSTANCE_MAPID = 14
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "OnyxiaLair"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenRaid", {0, 1, 285/1024, 875/1024}

	local ENCOUNTER_ID_CL = {
		10184,
		[10184] = 1, --Onyxia
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Onyxia"],
	}

	local ENCOUNTERS = {}

	for i = 1, #BOSSNAMES do
		local encounterTable = {
			boss = BOSSNAMES[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Onyxia's Lair"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[10184] = 1, --Onyxia
		},
	})
end

do --> data for The Ruby Sanctum
	local INSTANCE_MAPID = 610
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "TheRubySanctum"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenRubySanctum", {0, 1, 285/1024, 875/1024}

	local ENCOUNTER_ID_CL = {
		39863,
		[39863] = 1, --Halion
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Halion"],
	}

	local ENCOUNTERS = {}

	for i = 1, #BOSSNAMES do
		local encounterTable = {
			boss = BOSSNAMES[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["The Ruby Sanctum"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[39863] = 1, --Halion
		},
	})
end

do --> data for Icecrown Citadel
	local faction = UnitFactionGroup("player")

	local INSTANCE_MAPID = 605
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "IcecrownCitadel"..faction
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenIcecrownCitadel", {0, 1, 285/1024, 875/1024}

	local clID = 37540
	if faction == "Alliance" then
		clID = 37215
	end

	local ENCOUNTER_ID_CL = {
		36612, --Lord Marrowgar
		36855, --Lady Deathwhisper
		clID , --Icecrown Gunship Battle
		37813, --Deathbringer Saurfang
		36626, --Festergut
		36627, --Rotface
		36678, --Professor Putricide
		37970, --Blood Prince Council
		37955, --Blood-Queen Lana'thel
		36789, --Valithria Dreamwalker
		36853, --Sindragosa
		36597, --The Lich King
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	--> install the raid
	local BOSSNAMES = {
		LBB["Lord Marrowgar"],
		LBB["Lady Deathwhisper"],
		LBB["Icecrown Gunship Battle"],
		LBB["Deathbringer Saurfang"],
		LBB["Festergut"],
		LBB["Rotface"],
		LBB["Professor Putricide"],
		LBB["Blood Prince Council"],
		LBB["Blood-Queen Lana'thel"],
		LBB["Valithria Dreamwalker"],
		LBB["Sindragosa"],
		LBB["The Lich King"],
	}

	local ENCOUNTERS = {}

	for i = 1, #BOSSNAMES do
		local encounterTable = {
			boss = BOSSNAMES[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Icecrown Citadel"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[36612] = 1, --Lord Marrowgar
			[36855] = 2, --Lady Deathwhisper
			[37540] = 3, --Icecrown Gunship Battle
			[37215] = 3, --Icecrown Gunship Battle
			[37813] = 4, --Deathbringer Saurfang
			[36626] = 5, --Festergut
			[36627] = 6, --Rotface
			[36678] = 7, --Professor Putricide
			[37970] = 8, --Blood Prince Council
			[37955] = 9, --Blood-Queen Lana'thel
			[36789] = 10, --Valithria Dreamwalker
			[36853] = 11, --Sindragosa
			[36597] = 12, --The Lich King
		},
	})
end

do --> data for Trial of the Crusader
	local INSTANCE_MAPID = 544
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "TrialoftheCrusader"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenArgentRaid", {0, 1, 285/1024, 875/1024}

	local clID = 34467
	if UnitFactionGroup("player") == "Alliance" then
		clID = 34451
	end

	local ENCOUNTER_ID_CL = {
		34797,	--The Beasts of Northrend
		34780,	--Lord Jaraxxus
		clID,	--Faction Champions
		34497,	--The Twin Val'kyr
		34564,	--Anub'arak
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	--> install the raid
	local BOSSNAMES = {
		LBB["The Beasts of Northrend"],
		LBB["Lord Jaraxxus"],
		LBB["Faction Champions"],
		LBB["The Twin Val'kyr"],
		LBB["Anub'arak"],
	}

	local ENCOUNTERS = {}

	for i = 1, #BOSSNAMES do
		local encounterTable = {
			boss = BOSSNAMES[i]
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Trial of the Crusader"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[34796] = 1, --Gormok the Impaler
			[34799] = 1, --Dreadscale
			[34797] = 1, --Icehowl
			[35144] = 1, --Acidmaw
			[34780] = 2, --Lord Jaraxxus
			[34461] = 3, --Tyrius Duskblade <Death Knight>
			[34460] = 3, --Kavina Grovesong <Druid>
			[34469] = 3, --Melador Valestrider <Druid>
			[34467] = 3, --Alyssia Moonstalker <Hunter>
			[34468] = 3, --Noozle Whizzlestick <Mage>
			[34465] = 3, --Velanaa <Paladin>
			[34471] = 3, --Baelnor Lightbearer <Paladin>
			[34466] = 3, --Anthar Forgemender <Priest>
			[34473] = 3, --Brienna Nightfell <Priest>
			[34472] = 3, --Irieth Shadowstep <Rogue>
			[34470] = 3, --Saamul <Shaman>
			[34463] = 3, --Shaabad <Shaman>
			[34474] = 3, --Serissa Grimdabbler <Warlock>
			[34475] = 3, --Shocuul <Warrior>
			[34458] = 3, --Gorgrim Shadowcleave <Death Knight>
			[34451] = 3, --Birana Stormhoof <Druid>
			[34459] = 3, --Erin Misthoof <Druid>
			[34448] = 3, --Ruj'kah <Hunter>
			[34449] = 3, --Ginselle Blightslinger <Mage>
			[34445] = 3, --Liandra Suncaller <Paladin>
			[34456] = 3, --Malithas Brightblade <Paladin>
			[34447] = 3, --Caiphus the Stern <Priest>
			[34441] = 3, --Vivienne Blackwhisper <Priest>
			[34454] = 3, --Maz'dinah <Rogue>
			[34444] = 3, --Thrakgar	<Shaman>
			[34455] = 3, --Broln Stouthorn <Shaman>
			[34450] = 3, --Harkzog <Warlock>
			[34453] = 3, --Narrhok Steelbreaker <Warrior>
			[34497] = 4, --Fjola Lightbane
			[34496] = 4, --Eydis Darkbane
			[34564] = 5, --Anub'arak
		},
	})
end

do --> data for Naxxramas
	local INSTANCE_MAPID = 536
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "Naxxramas"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenNaxxramas", {0, 1, 285/1024, 875/1024}

	local ENCOUNTER_ID_CL = {
		15956, --Anub'Rekhan
		15953, --Grand Widow Faerlina
		15952, --Maexxna
		15954, --Noth the Plaguebringer
		15936, --Heigan the Unclean
		16011, --Loatheb
		16061, --Instructor Razuvious
		16060, --Gothik the Harvester
		30549, --The Four Horsemen
		16028, --Patchwerk
		15931, --Grobbulus
		15932, --Gluth
		15928, --Thaddius
		15989, --Sapphiron
		15990, --Kel'Thuzad
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	--> install the raid
	local BOSSNAMES = {
		LBB["Anub'Rekhan"],
		LBB["Grand Widow Faerlina"],
		LBB["Maexxna"],
		LBB["Noth the Plaguebringer"],
		LBB["Heigan the Unclean"],
		LBB["Loatheb"],
		LBB["Instructor Razuvious"],
		LBB["Gothik the Harvester"],
		LBB["The Four Horsemen"],
		LBB["Patchwerk"],
		LBB["Grobbulus"],
		LBB["Gluth"],
		LBB["Thaddius"],
		LBB["Sapphiron"],
		LBB["Kel'Thuzad"],
	}

	local ENCOUNTERS = {}

	for i = 1, #BOSSNAMES do
		local encounterTable = {
			boss = BOSSNAMES[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Naxxramas"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[15956] = 1, --Anub'Rekhan
			[15953] = 2, --Grand Widow Faerlina
			[15952] = 3, --Maexxna
			[15954] = 4, --Noth the Plaguebringer
			[15936] = 5, --Heigan the Unclean
			[16011] = 6, --Loatheb
			[16061] = 7, --Instructor Razuvious
			[16060] = 8, --Gothik the Harvester
			[30549] = 9, --Baron Rivendare
			[16065] = 9, --Lady Blaumeux
			[16064] = 9, --Thane Korth'azz
			[16062] = 9, --Highlord Mograine
			[16063] = 9, --Sir Zeliek
			[16028] = 10, --Patchwerk
			[15931] = 11, --Grobbulus
			[15932] = 12, --Gluth
			[15928] = 13, --Thaddius
			[15989] = 14, --Sapphiron
			[15990] = 15, --Kel'Thuzad
		},
	})
end

do --> data for Vault of Archavon
	local INSTANCE_MAPID = 533
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "VaultofArchavon"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenWintergrasp", {0, 1, 285/1024, 875/1024}

	local ENCOUNTER_ID_CL = {
		31125, 33993, 35013, 38433,
		[31125] = 1, --Archavon the Stone Watcher
		[33993] = 2, --Emalon the Storm Watcher
		[35013] = 3, --Koralon the Flame Watcher
		[38433] = 4, --Toravon the Ice Watcher
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Archavon the Stone Watcher"],
		LBB["Emalon the Storm Watcher"],
		LBB["Koralon the Flame Watcher"],
		LBB["Toravon the Ice Watcher"],
	}

	local ENCOUNTERS = {}

	for i = 1, #BOSSNAMES do
		local encounterTable = {
			boss = BOSSNAMES[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Vault of Archavon"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[31125] = 1, --Archavon the Stone Watcher
			[33993] = 2, --Emalon the Storm Watcher
			[35013] = 3, --Koralon the Flame Watcher
			[38433] = 4, --Toravon the Ice Watcher
		},
	})
end

do --> data for The Obsidian Sanctum
	local INSTANCE_MAPID = 532
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "TheObsidianSanctum"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenChamberBlack", {0, 1, 285/1024, 875/1024}

	local ENCOUNTER_ID_CL = {
		28860,
		[28860] = 1, --Sartharion
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Sartharion"],
	}

	local ENCOUNTERS = {}

	for i = 1, #BOSSNAMES do
		local encounterTable = {
			boss = BOSSNAMES[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["The Obsidian Sanctum"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[28860] = 1, --Sartharion
		},
	})
end

do --> data for The Eye of Eternity
	local INSTANCE_MAPID = 528
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "TheEyeofEternity"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenMalygos", {0, 1, 285/1024, 875/1024}

	local ENCOUNTER_ID_CL = {
		28859,
		[28859] = 1, --Malygos
	}

	--> install the raid
	local BOSSNAMES = {
		LBB["Malygos"],
	}

	local ENCOUNTERS = {}

	for i = 1, #BOSSNAMES do
		local encounterTable = {
			boss = BOSSNAMES[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["The Eye of Eternity"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {
			[28859] = 1, --Malygos
		},
	})
end

do --> data for Ulduar
	local INSTANCE_MAPID = 530
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "Ulduar"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenUlduarRaid", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[33113] = 1, --Flame Leviathan
		[33118] = 2, --Ignis the Furnace Master
		[33186] = 3, --Razorscale
		[33293] = 4, --XT-002 Deconstructor
		[32867] = 5, --Steelbreaker
		[32927] = 5, --Runemaster Molgeim
		[32857] = 5, --Stormcaller Brundir
		[32930] = 6, --Kologarn
		[32933] = 6, --Left Arm
		[32934] = 6, --Right Arm
		[33515] = 7, --Auriaya
		[32845] = 8, --Hodir
		[32865] = 9, --Thorim
		[32882] = 9, --Jormungar Behemoth
		[32906] = 10, --Freya
		[33350] = 11, --Mimiron
		[33271] = 12, --General Vezax
		[33136] = 13, --Guardian of Yogg-Saron
		[33288] = 13, --Yogg-Saron
		[32871] = 14, --Algalon the Observer
	}

	local ENCOUNTER_ID_CL = {
		33113, --Flame Leviathan
		33118, --Ignis the Furnace Master
		33186, --Razorscale
		33293, --XT-002 Deconstructor
		32867, --Assembly of Iron
		32930, --Kologarn
		33515, --Auriaya
		32845, --Hodir
		32865, --Thorim
		32906, --Freya
		33350, --Mimiron
		33271, --General Vezax
		33136, --Yogg-Saron
		32871, --Algalon the Observer
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	--> install the raid
	local BOSSNAMES = {
		LBB["Flame Leviathan"],
		LBB["Ignis the Furnace Master"],
		LBB["Razorscale"],
		LBB["XT-002 Deconstructor"],
		LBB["Assembly of Iron"],
		LBB["Kologarn"],
		LBB["Auriaya"],
		LBB["Hodir"],
		LBB["Thorim"],
		LBB["Freya"],
		LBB["Mimiron"],
		LBB["General Vezax"],
		LBB["Yogg-Saron"],
		LBB["Algalon the Observer"],
	}

	local ENCOUNTERS = {}

	for i = 1, #BOSSNAMES do
		local encounterTable = {
			boss = BOSSNAMES[i],
		}
		tinsert(ENCOUNTERS, encounterTable)
	end

	_detalhes:InstallEncounter({
		id = INSTANCE_MAPID, --map id
		name = LBZ["Ulduar"],
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Throne of the Tides
	local EJ_INSTANCEID = 65
	local HDIMAGESPATH = "Details\\images\\dungeon"
	local HDFILEPREFIX = "ThroneoftheTides"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenThroneoftheTides", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[40586]	= 1,	-- Lady Naz'jar
		[49079] = 1,	-- Lady Naz'jar
		[40765]	= 2,	-- Commander Ulthok
		[49064]	= 2,	-- Commander Ulthok
		[40825]	= 3,	-- Erunak Stonespeaker
		[49072]	= 3,	-- Erunak Stonespeaker
		[40788]	= 3,	-- Mindbender Ghur'sha
		[49082]	= 3,	-- Mindbender Ghur'sha
		[49097]	= 4,	-- Ozumat
		[44566] = 4,	-- Ozumat
	}

	local ENCOUNTER_ID_CL = {
		49079,	-- Lady Naz'jar
		49064,	-- Commander Ulthok
		49082,	-- Mindbender Ghur'sha
		44566,	-- Ozumat
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = false,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Halls of Origination
	local EJ_INSTANCEID = 70
	local HDIMAGESPATH = "Details\\images\\dungeon"
	local HDFILEPREFIX = "HallsofOrigination"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenHallsofOrigination", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[39425]	= 1,	-- Temple Guardian Anhuur
		[49262] = 1,	-- Temple Guardian Anhuur
		[39428]	= 2,	-- Earthrager Ptah
		[48714]	= 2,	-- Earthrager Ptah
		[39788]	= 3,	-- Anraphet
		[48902]	= 3,	-- Anraphet
		[39587]	= 4,	-- Isiset
		[48710]	= 4,	-- Isiset
		[39731]	= 5,	-- Ammunae
		[48715]	= 5,	-- Ammunae
		[39732]	= 6,	-- Setesh
		[48776]	= 6,	-- Setesh
		[39378]	= 7,	-- Rajh
		[48815]	= 7,	-- Rajh
	}

	local ENCOUNTER_ID_CL = {
		39425,	-- Temple Guardian Anhuur
		39428,	-- Earthrager Ptah
		39788,	-- Anraphet
		39587,	-- Isiset
		39731,	-- Ammunae
		39732,	-- Setesh
		39378,	-- Rajh
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = false,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Blackrock Caverns
	local EJ_INSTANCEID = 66
	local HDIMAGESPATH = "Details\\images\\dungeon"
	local HDFILEPREFIX = "BlackrockCaverns"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenBlackrockCaverns", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[39665]	= 1,	-- Rom'ogg Bonecrusher
		[39666]	= 1,	-- Rom'ogg Bonecrusher
		[39679]	= 2,	-- Corla, Herald of Twilight
		[39680]	= 2,	-- Corla, Herald of Twilight
		[39698]	= 3,	-- Karsh Steelbender
		[39699]	= 3,	-- Karsh Steelbender
		[39700]	= 4,	-- Beauty
		[39701]	= 4,	-- Beauty
		[39705]	= 5,	-- Ascendant Lord Obsidius
		[39706]	= 5,	-- Ascendant Lord Obsidius
	}
	
	local ENCOUNTER_ID_CL = {
		39665,	-- Rom'ogg Bonecrusher
		39679,	-- Corla, Herald of Twilight
		39698,	-- Karsh Steelbender
		39700,	-- Beauty
		39705,	-- Ascendant Lord Obsidius
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = false,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Vortex Pinnacle
	local EJ_INSTANCEID = 68
	local HDIMAGESPATH = "Details\\images\\dungeon"
	local HDFILEPREFIX = "TheVortexPinnacle"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenSkywall", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[43878]	= 1,	-- Grand Vizier Ertan
		[43879]	= 1,	-- Grand Vizier Ertan
		[43873]	= 2,	-- Altairus
		[43874]	= 2,	-- Altairus
		[43875]	= 3,	-- Asaad
		[43876]	= 3,	-- Asaad
	}
	
	local ENCOUNTER_ID_CL = {
		43878,	-- Grand Vizier Ertan
		43873,	-- Altairus
		43875,	-- Asaad
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = false,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Grim Batol
	local EJ_INSTANCEID = 71
	local HDIMAGESPATH = "Details\\images\\dungeon"
	local HDFILEPREFIX = "GrimBatol"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LOADSCREENGRIMBATOL", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[39625]	= 1,	-- General Umbriss
		[48337]	= 1,	-- General Umbriss
		[40177]	= 2,	-- Forgemaster Throngus
		[48702]	= 2,	-- Forgemaster Throngus
		[40319]	= 3,	-- Drahga Shadowburner
		[48784]	= 3,	-- Drahga Shadowburner
		[40484]	= 4,	-- Erudax
		[48822]	= 4,	-- Erudax
	}
	
	local ENCOUNTER_ID_CL = {
		39625,	-- General Umbriss
		40177,	-- Forgemaster Throngus
		40319,	-- Drahga Shadowburner
		40484,	-- Erudax
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = false,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Stonecore
	local EJ_INSTANCEID = 67
	local HDIMAGESPATH = "Details\\images\\dungeon"
	local HDFILEPREFIX = "TheStonecore"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LOADSCREENDEEPHOLMDUNGEON", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[43438]	= 1,	-- Corborus
		[49642]	= 1,	-- Corborus
		[43214]	= 2,	-- Slabhide
		[49538]	= 2,	-- Slabhide
		[42188]	= 3,	-- Ozruk
		[49654]	= 3,	-- Ozruk
		[42333]	= 4,	-- High Priestess Azil
		[49624]	= 4,	-- High Priestess Azil
	}
	
	local ENCOUNTER_ID_CL = {
		43438,	-- Corborus
		43214,	-- Slabhide
		42188,	-- Ozruk
		42333,	-- High Priestess Azil
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = false,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Lost City of the Tol'Vir
	local EJ_INSTANCEID = 69
	local HDIMAGESPATH = "Details\\images\\dungeon"
	local HDFILEPREFIX = "LostCityofTolvir"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenLostCityofTolvir", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[44577]	= 1,	-- General Husam
		[48932]	= 1,	-- General Husam
		[43614]	= 2,	-- Lockmaw
		[49043]	= 2,	-- Lockmaw
		[49045]	= 3,	-- Augh
		[43612]	= 4,	-- High Prophet Barim
		[48951]	= 4,	-- High Prophet Barim
		[44819]	= 5,	-- Siamat
		[51088]	= 5,	-- Siamat
	}
	
	local ENCOUNTER_ID_CL = {
		44577,	-- General Husam
		43614,	-- Lockmaw
		49045,	-- Augh
		43612,	-- High Prophet Barim
		44819,	-- Siamat
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = false,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Zul'Aman
	local EJ_INSTANCEID = 77
	local HDIMAGESPATH = "Details\\images\\dungeon"
	local HDFILEPREFIX = "ZulAman"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenZulAman2", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[23574]	= 1,	-- Akil'zon
		[29024]	= 2,	-- Nalorakk
		[28514]	= 2,	-- Nalorakk
		[23576]	= 2,	-- Nalorakk
		[23578]	= 3,	-- Jan'alai
		[28515]	= 3,	-- Jan'alai
		[29023]	= 3,	-- Jan'alai
		[23577]	= 4,	-- Halazzi
		[28517]	= 4,	-- Halazzi
		[29022]	= 4,	-- Halazzi
		[24239]	= 5,	-- Malacrass
		[23863]	= 6,	-- Daakara
	}

	local ENCOUNTER_ID_CL = {
		23574, --Akil'zon
		23576, --Nalorakk
		23578, --Jan'alai
		23577, --Halazzi
		24239, --Malacrass
		23863, --Zul'jin
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = false,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Zul'Gurub
	local EJ_INSTANCEID = 76
	local HDIMAGESPATH = "Details\\images\\dungeon"
	local HDFILEPREFIX = "ZulGurub"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenZulGurub", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[52155]	= 1,	-- High Priest Venoxis
		[52151]	= 2,	-- Bloodlord Mandokir
		[52269]	= 3,	-- Renataki
		[52258]	= 4,	-- Gri'lek
		[52271]	= 5,	-- Hazza'rah
		[52286]	= 6,	-- Wushoolay
		[52059]	= 7,	-- High Priestess Kilnara
		[52053]	= 8,	-- Zanzil
		[52148]	= 9,	-- Jin'do the Godbreaker
	}
	
	local ENCOUNTER_ID_CL = {
		52155,	-- High Priest Venoxis
		52151,	-- Bloodlord Mandokir
		52269,	-- Renataki
		52258,	-- Gri'lek
		52271,	-- Hazza'rah
		52286,	-- Wushoolay
		52059,	-- High Priestess Kilnara
		52053,	-- Zanzil
		52148,	-- Jin'do the Godbreaker
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = false,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Baradin Hold
	local EJ_INSTANCEID = 75
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "BaradinHold"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenBaradinHold", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[47120]	= 1,	-- Argaloth
		[52363]	= 2,	-- Occu'thar
		[55869]	= 3,	-- Alizabal
	}

	local ENCOUNTER_ID_CL = {
		47120,	-- Argaloth
		52363,	-- Occu'thar
		55869,	-- Alizabal
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Blackwing Descent
	local EJ_INSTANCEID = 73
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "BlackwingDescent"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenBlackwingDescentRaid", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[42166]	= 1,	-- Arcanotron
		[49056]	= 1,	-- Arcanotron
		[49057]	= 1,	-- Arcanotron
		[49058]	= 1,	-- Arcanotron
		[42178]	= 1,	-- Magmatron
		[49053]	= 1,	-- Magmatron
		[49054]	= 1,	-- Magmatron
		[49055]	= 1,	-- Magmatron
		[42179]	= 1,	-- Electron
		[49047]	= 1,	-- Electron
		[49048]	= 1,	-- Electron
		[49049]	= 1,	-- Electron
		[42180]	= 1,	-- Toxitron
		[49050]	= 1,	-- Toxitron
		[49051]	= 1,	-- Toxitron
		[49052]	= 1,	-- Toxitron
		[41570]	= 2,	-- Magmaw
		[51101]	= 2,	-- Magmaw
		[51102]	= 2,	-- Magmaw
		[51103]	= 2,	-- Magmaw
		[41442]	= 3,	-- Atramedes
		[49583]	= 3,	-- Atramedes
		[49584]	= 3,	-- Atramedes
		[49585]	= 3,	-- Atramedes
		[43296]	= 4,	-- Chimaeron
		[47774]	= 4,	-- Chimaeron
		[47775]	= 4,	-- Chimaeron
		[47776]	= 4,	-- Chimaeron
		[41378]	= 5,	-- Maloriak
		[49974]	= 5,	-- Maloriak
		[49980]	= 5,	-- Maloriak
		[49986]	= 5,	-- Maloriak
		[41270] = 6,	-- Onyxia
		[51116] = 6,	-- Onyxia
		[51117] = 6,	-- Onyxia
		[51118] = 6,	-- Onyxia
		[41376]	= 6,	-- Nefarian
		[51104]	= 6,	-- Nefarian
		[51105]	= 6,	-- Nefarian
		[51106]	= 6,	-- Nefarian
	}

	local ENCOUNTER_ID_CL = {
		42178,	-- Magmatron
		41570,	-- Magmaw
		41442,	-- Atramedes
		43296,	-- Chimaeron
		41378,	-- Maloriak
		41376,	-- Nefarian
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Bastion of Twilight
	local EJ_INSTANCEID = 72
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "GrimBatolRaid"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenGrimBatolRaid", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[44600]	= 1,	-- Halfus Wyrmbreaker
		[46209]	= 1,	-- Halfus Wyrmbreaker
		[46210]	= 1,	-- Halfus Wyrmbreaker
		[46211]	= 1,	-- Halfus Wyrmbreaker
		[45992]	= 2,	-- Valiona
		[49897]	= 2,	-- Valiona
		[49898]	= 2,	-- Valiona
		[49899]	= 2,	-- Valiona
		[45993]	= 2,	-- Theralion
		[49903]	= 2,	-- Theralion
		[49904]	= 2,	-- Theralion
		[49905]	= 2,	-- Theralion
		[43686]	= 3,	-- Ignacious
		[49615]	= 3,	-- Ignacious
		[49616]	= 3,	-- Ignacious
		[49617]	= 3,	-- Ignacious
		[43687]	= 3,	-- Feludius
		[49612]	= 3,	-- Feludius
		[49613]	= 3,	-- Feludius
		[49614]	= 3,	-- Feludius
		[43688]	= 3,	-- Arion
		[43688]	= 3,	-- Arion
		[43688]	= 3,	-- Arion
		[43688]	= 3,	-- Arion
		[43689]	= 3,	-- Terrastra
		[49606]	= 3,	-- Terrastra
		[49607]	= 3,	-- Terrastra
		[49608]	= 3,	-- Terrastra
		[43735]	= 3,	-- Elementium Monstrosity
		[49619]	= 3,	-- Elementium Monstrosity
		[49620]	= 3,	-- Elementium Monstrosity
		[49621]	= 3,	-- Elementium Monstrosity
		[43324]	= 4, 	-- Cho'gall
		[50131]	= 4, 	-- Cho'gall
		[50132]	= 4, 	-- Cho'gall
		[50133]	= 4, 	-- Cho'gall
		[45213]	= 5,	-- Sinestra
		[49744]	= 5,	-- Sinestra
	}

	local ENCOUNTER_ID_CL = {
		44600,	-- Halfus
		45992,	-- Valiona
		43735,	-- Elementium Monstrosity
		43324,	-- Cho'gall
		45213,	-- Sinestra
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Throne of the Four Winds
	local EJ_INSTANCEID = 74
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "SkywallRaid"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenSkywallRaid", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[45870]	= 1,	-- Anshal
		[50103]	= 1,	-- Anshal
		[50113]	= 1,	-- Anshal
		[50123]	= 1,	-- Anshal
		[45871]	= 1,	-- Nezir
		[50098]	= 1,	-- Nezir
		[50108]	= 1,	-- Nezir
		[50118]	= 1,	-- Nezir
		[45872]	= 1,	-- Rohash
		[50095]	= 1,	-- Rohash
		[50105]	= 1,	-- Rohash
		[50115]	= 1,	-- Rohash
		[46753]	= 2,	-- Al'Akir
		[50203]	= 2,	-- Al'Akir
		[50217]	= 2,	-- Al'Akir
		[50231]	= 2,	-- Al'Akir
	}

	local ENCOUNTER_ID_CL = {
		45871,	-- Nezir
		46753,	-- Al'Akir
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Firelands
	local EJ_INSTANCEID = 78
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "Firelands"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenFirelandsRaid", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[52498]	= 1,	-- Bethtilac
		[53576]	= 1,	-- Bethtilac
		[53577]	= 1,	-- Bethtilac
		[53578]	= 1,	-- Bethtilac
		[52558]	= 2,	-- Rhyolith
		[52559]	= 2,	-- Rhyolith
		[52560]	= 2,	-- Rhyolith
		[52561]	= 2,	-- Rhyolith
		[52530]	= 3,	-- Alysrazor
		[54044]	= 3,	-- Alysrazor
		[54045]	= 3,	-- Alysrazor
		[54046]	= 3,	-- Alysrazor
		[53691]	= 4,	-- Shannox
		[53979]	= 4,	-- Shannox
		[54079]	= 4,	-- Shannox
		[54080]	= 4,	-- Shannox
		[53494]	= 5,	-- Baleroc
		[53587]	= 5,	-- Baleroc
		[53588]	= 5,	-- Baleroc
		[53589]	= 5,	-- Baleroc
		[52571]	= 6,	-- FandralStaghelm
		[53856]	= 6,	-- FandralStaghelm
		[53857]	= 6,	-- FandralStaghelm
		[53858]	= 6,	-- FandralStaghelm
		[52409]	= 7,	-- Ragnaros
		[53797]	= 7,	-- Ragnaros
		[53798]	= 7,	-- Ragnaros
		[53799]	= 7,	-- Ragnaros
	}

	local ENCOUNTER_ID_CL = {
		52498,	-- Bethtilac
		52558,	-- Rhyolith
		52530,	-- Alysrazor
		53691,	-- Shannox
		53494,	-- Baleroc
		52571,	-- FandralStaghelm
		52409,	-- Ragnaros
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for End Time
	local EJ_INSTANCEID = 184
	local HDIMAGESPATH = "Details\\images\\dungeon"
	local HDFILEPREFIX = "EndTime"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenEndTime", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[54431]	= 1,	-- Echo of Baine
		[54445] = 2,	-- Echo of Jaina
		[54123] = 3,	-- Echo of Sylvanas
		[54544] = 4,	-- Echo of Tyrande
		[54432] = 5,	-- Murozond
	}

	local ENCOUNTER_ID_CL = {
		54431,	-- Echo of Baine
		54445,	-- Echo of Jaina
		54123,	-- Echo of Sylvanas
		54544,	-- Echo of Tyrande
		54432,	-- Murozond
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = false,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Well of Eternity
	local EJ_INSTANCEID = 185
	local HDIMAGESPATH = "Details\\images\\dungeon"
	local HDFILEPREFIX = "WellOfEternity"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenWellofEternity", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[55085]	= 1,	-- Peroth'arn
		[54853]	= 2,	-- Queen Azshara
		[54969]	= 3,	-- Mannoroth
		[55419]	= 3,	-- Varo'then
	}

	local ENCOUNTER_ID_CL = {
		55085,	-- Peroth'arn
		54853,	-- Queen Azshara
		54969,	-- Mannoroth
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = false,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Hour of Twilight
	local EJ_INSTANCEID = 186
	local HDIMAGESPATH = "Details\\images\\dungeon"
	local HDFILEPREFIX = "HourOfTwilight"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenHourofTwilight", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[54590]	= 1,	-- Arcurion
		[54968]	= 2,	-- Asira Dawnslayer
		[54938]	= 3,	-- Archbishop Benedictus
	}

	local ENCOUNTER_ID_CL = {
		54590,	-- Arcurion
		54968,	-- Asira Dawnslayer
		54938,	-- Archbishop Benedictus
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = false,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Dragon Soul
	local EJ_INSTANCEID = 187
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "Dragon Soul"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenDeathwingRaid", {0, 1, 285/1024, 875/1024}

	local BOSS_IDS = {
		[55265]	= 1,	-- Morchok
		[57409]	= 1,	-- Morchok
		[57771]	= 1,	-- Morchok
		[57772]	= 1,	-- Morchok
		[57773]	= 1,	-- Kohcrom
		[55308]	= 2,	-- Warlord Zonozz
		[55309]	= 2,	-- Warlord Zonozz
		[55310]	= 2,	-- Warlord Zonozz
		[55311]	= 2,	-- Warlord Zonozz
		[55312]	= 3,	-- Yor'sahj the Unsleeping
		[55313]	= 3,	-- Yor'sahj the Unsleeping
		[55314]	= 3,	-- Yor'sahj the Unsleeping
		[55315]	= 3,	-- Yor'sahj the Unsleeping
		[55689]	= 4,	-- Hagara the Binder
		[57462]	= 4,	-- Hagara the Binder
		[57955]	= 4,	-- Hagara the Binder
		[57956]	= 4,	-- Hagara the Binder
		[55294]	= 5,	-- Ultraxion
		[56576]	= 5,	-- Ultraxion
		[56577]	= 5,	-- Ultraxion
		[56578]	= 5,	-- Ultraxion
		[56427]	= 6,	-- Warmaster Blackhorn
		[56855]	= 6,	-- Warmaster Blackhorn
		[56587]	= 6,	-- Warmaster Blackhorn
		[56923]	= 6,	-- Warmaster Blackhorn
		[56854]	= 6,	-- Warmaster Blackhorn
		[56848]	= 6,	-- Warmaster Blackhorn
		[56848]	= 6,	-- Warmaster Blackhorn
		[53891] = 7,	-- Corruption
		[57879] = 7,	-- Corruption
		[57880] = 7,	-- Corruption
		[57881] = 7,	-- Corruption
		[56161] = 7,	-- Corruption
		[57901] = 7,	-- Corruption
		[57902] = 7,	-- Corruption
		[57903] = 7,	-- Corruption
		[56162] = 7,	-- Corruption
		[57904] = 7,	-- Corruption
		[57905] = 7,	-- Corruption
		[57906] = 7,	-- Corruption
		[56575] = 7,	-- Burning Tendons
		[57887] = 7,	-- Burning Tendons
		[57888] = 7,	-- Burning Tendons
		[57889] = 7,	-- Burning Tendons
		[56341] = 7,	-- Burning Tendons
		[57884] = 7,	-- Burning Tendons
		[57885] = 7,	-- Burning Tendons
		[57886] = 7,	-- Burning Tendons
		[53879]	= 7,	-- Spine Deathwing
		[56168] = 8,	-- Wing Tentacle
		[57972] = 8,	-- Wing Tentacle
		[58129] = 8,	-- Wing Tentacle
		[58130] = 8,	-- Wing Tentacle
		[58131] = 8,	-- Arm Tentacle
		[58133] = 8,	-- Arm Tentacle
		[58132] = 8,	-- Arm Tentacle
		[58134] = 8,	-- Arm Tentacle
		[56167] = 8,	-- Arm Tentacle
		[56846] = 8,	-- Arm Tentacle
		[57973] = 8,	-- Arm Tentacle
		[57974] = 8,	-- Arm Tentacle
		[56173]	= 8,	-- Madness Deathwing
		[57969]	= 8,	-- Madness Deathwing
		[58000]	= 8,	-- Madness Deathwing
		[58001]	= 8,	-- Madness Deathwing
	}

	local ENCOUNTER_ID_CL = {
		55265,	-- Morchok
		55308,	-- Warlord Zonozz
		55312,	-- Yor'sahj the Unsleeping
		55689,	-- Hagara the Binder
		55294,	-- Ultraxion
		56427,	-- Warmaster Blackhorn
		53879,	-- Spine Deathwing
		56173,	-- Madness Deathwing
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = BOSS_IDS,
	})
end

do --> data for Mogushan Vaults
	local EJ_INSTANCEID = 317
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "MogushanVaults"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenMogushanVaults", {0, 1, 285/1024, 875/1024}

	local ENCOUNTER_ID_CL = {
		1395,	-- Stone Guardians
		1390,	-- Feng the Accursed
		1434,	-- Gara'jal
		1436,	-- Spirit Kings
		1500,	-- Elegon
		1407,	-- Will of the Emperor
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {},
	})
end

do --> data for Terrace of Endless SPrings
	local EJ_INSTANCEID = 320
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "TerraceOfEndlessSprings"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenTerraceofEndlessSprings", {0, 1, 285/1024, 875/1024}

	local ENCOUNTER_ID_CL = {
		1409,	-- Protectors
		1505,	-- Tsulong
		1506,	-- LeiShi
		1431,   -- Sha of Fear
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {},
	})
end

do --> data for Heart of Fear
	local EJ_INSTANCEID = 330
	local HDIMAGESPATH = "Details\\images\\raid"
	local HDFILEPREFIX = "HeartOfFear"
	local LOADINGSCREEN_FILE, LOADINGSCREEN_COORDS = "LoadScreenHeartOfFear", {0, 1, 285/1024, 875/1024}

	local ENCOUNTER_ID_CL = {
		1507,	-- Imperial Vizier Zor'lok
		1504,	-- Blade Lord Ta'yak
		1463,	-- Garalon
		1498,   -- Wind Lord Mel'jarak
		1499,		-- Amber-Shaper Un'sok
		1501,		-- Grand Empress Shek'zeer
	}

	for i = 1, #ENCOUNTER_ID_CL do
		ENCOUNTER_ID_CL[ENCOUNTER_ID_CL[i]] = i
	end

	local mapName, mapID, dungeonBG, backgroundEJ, ENCOUNTERS, BOSSNAMES = BuildInstanceInfo(EJ_INSTANCEID)

	_detalhes:InstallEncounter({
		id = mapID,
		name = mapName,
		icons = "Interface\\AddOns\\"..HDIMAGESPATH.."\\"..HDFILEPREFIX.."_BossFaces",
		icon = dungeonBG,
		is_raid = true,
		backgroundFile = {file = "Interface\\Glues\\LOADINGSCREENS\\"..LOADINGSCREEN_FILE, coords = LOADINGSCREEN_COORDS},
		backgroundEJ = backgroundEJ,

		encounter_ids2 = ENCOUNTER_ID_CL,
		boss_names = BOSSNAMES,
		encounters = ENCOUNTERS,

		boss_ids = {},
	})
end