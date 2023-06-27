-- $Id: loottables.lua 3697 2012-01-31 15:17:37Z lag123 $
--[[
loottables.en.lua
This file assigns a title to every loot table.  The primary use of this table
is in the search function, as when iterating through the loot tables there is no
inherant title to the loot table, given the origins of the mod as an Atlas plugin.
]]

-- Invoke libraries
local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");
local BabbleBoss = AtlasLoot_GetLocaleLibBabble("LibBabble-Boss-3.0")
local BabbleInventory = AtlasLoot_GetLocaleLibBabble("LibBabble-Inventory-3.0")
local BabbleFaction = AtlasLoot_GetLocaleLibBabble("LibBabble-Faction-3.0")
local BabbleZone = AtlasLoot_GetLocaleLibBabble("LibBabble-Zone-3.0")

-- Using alchemy skill to get localized rank
local JOURNEYMAN = select(2, GetSpellInfo(3101));
local EXPERT = select(2, GetSpellInfo(3464));
local ARTISAN = select(2, GetSpellInfo(11611));
local MASTER = select(2, GetSpellInfo(28596));

local ALCHEMY, APPRENTICE = GetSpellInfo(2259);
local BLACKSMITHING = GetSpellInfo(2018);
local ARMORSMITH = GetSpellInfo(9788);
local WEAPONSMITH = GetSpellInfo(9787);
local AXESMITH = GetSpellInfo(17041);
local HAMMERSMITH = GetSpellInfo(17040);
local SWORDSMITH = GetSpellInfo(17039);
local COOKING = GetSpellInfo(2550);
local ENCHANTING = GetSpellInfo(7411);
local ENGINEERING = GetSpellInfo(4036);
local GNOMISH = GetSpellInfo(20220);
local GOBLIN = GetSpellInfo(20221);
local FIRSTAID = GetSpellInfo(3273);
local FISHING = GetSpellInfo(63275);
local INSCRIPTION = GetSpellInfo(45357);
local JEWELCRAFTING = GetSpellInfo(25229);
local LEATHERWORKING = GetSpellInfo(2108);
local DRAGONSCALE = GetSpellInfo(10656);
local ELEMENTAL = GetSpellInfo(10658);
local TRIBAL = GetSpellInfo(10660);
local MINING = GetSpellInfo(2575);
local TAILORING = GetSpellInfo(3908);
local MOONCLOTH = GetSpellInfo(26798);
local SHADOWEAVE = GetSpellInfo(26801);
local SPELLFIRE = GetSpellInfo(26797);

AtlasLoot_LootTableRegister = {
	["Instances"] = {

---------------------------
--- Cataclysm Instances ---
---------------------------

	---- Dungeons
		["BlackrockCaverns"] = {
			["Bosses"] = {
				{ "BlackrockCavernsRomogg", 2, EncounterJournalID = 105 },
				{ "BlackrockCavernsCorla", 3, EncounterJournalID = 106 },
				{ "BlackrockCavernsSteelbender", 4, EncounterJournalID = 107 },
				{ "BlackrockCavernsBeauty", 5, EncounterJournalID = 108 },
				{ "BlackrockCavernsLordObsidius", 6, EncounterJournalID = 109 },
				{ "BlackrockCavernsTrash", 11 },
			},
			["Info"] = { BabbleZone["Blackrock Caverns"], "AtlasLootCataclysm", mapname = "BlackrockCaverns", EncounterJournalID = 66 },
		},

		["CoTEndTime"] = {
			["Bosses"] = {
				{ "EndtimeEchoes", {3,4,5,6}, EncounterJournalID = 340 },
				{ "EndtimeMurozond", 7, EncounterJournalID = 289 },
				{ "EndtimeTrash", 10 },
			},
			["Info"] = { BabbleZone["End Time"], "AtlasLootCataclysm", mapname = "EndTime", EncounterJournalID = 184 },
		},

		["CoTHourOfTwilight"] = {
			["Bosses"] = {
				{ "HoTArcurion", 3, EncounterJournalID = 322 },
				{ "HoTDawnslayer", 4, EncounterJournalID = 342 },
				{ "HoTBenedictus", 5, EncounterJournalID = 341 },
				{ "HoTTrash", 8 },
			},
			["Info"] = { BabbleZone["Hour of Twilight"], "AtlasLootCataclysm", mapname = "HourofTwilight", EncounterJournalID = 186 },
		},

		["CoTWellOfEternity"] = {
			["Bosses"] = {
				{ "WoEPerotharn", 3, EncounterJournalID = 290 },
				{ "WoEAzshara", 4, EncounterJournalID = 291 },
				{ "WoEMannoroth", 5, EncounterJournalID = 292 },
				{ "WoETrash", 8 },
			},
			["Info"] = { BabbleZone["Well of Eternity"], "AtlasLootCataclysm", mapname = "WellOfEternity", EncounterJournalID = 185 },
		},

		["GrimBatol"] = {
			["Bosses"] = {
				{ "GBUmbriss", 2, EncounterJournalID = 131 },
				{ "GBThrongus", 3, EncounterJournalID = 132 },
				{ "GBDrahga", 4, EncounterJournalID = 133 },
				{ "GBErudax", 5, EncounterJournalID = 134 },
				{ "GBTrash", 10 },
			},
			["Info"] = { BabbleZone["Grim Batol"], "AtlasLootCataclysm", mapname = "GrimBatol", EncounterJournalID = 71 },
		},

		["HallsOfOrigination"] = {
			["Bosses"] = {
				{ "HoOAnhuur", 2, EncounterJournalID = 124 },
				{ "HoOPtah", 3, EncounterJournalID = 125 },
				{ "HoOAnraphet", 4, EncounterJournalID = 126 },
				{ "HoOIsiset", 5, EncounterJournalID = 127 },
				{ "HoOAmmunae", 6, EncounterJournalID = 128 },
				{ "HoOSetesh", 7, EncounterJournalID = 129 },
				{ "HoORajh", 8, EncounterJournalID = 130 },
				{ "HoOTrash", 13 },
			},
			["Info"] = { BabbleZone["Halls of Origination"], "AtlasLootCataclysm", mapname = "HallsOfOrigination", EncounterJournalID = 70 },
		},

		["LostCityOfTolvir"] = {
			["Bosses"] = {
				{ "LostCityHusam", 3, EncounterJournalID = 117 },
				{ "LostCityLockmaw", {4,5}, EncounterJournalID = 118 },
				{ "LostCityBarim", 6, EncounterJournalID = 119 },
				{ "LostCitySiamat", 7, EncounterJournalID = 122 },
				{ "LostCityTrash", 10 },
			},
			["Info"] = { BabbleZone["Lost City of the Tol'vir"], "AtlasLootCataclysm", mapname = "LostCityofTolvir", EncounterJournalID = 69 },
		},

		["TheStonecore"] = {
			["Bosses"] = {
				{ "StonecoreCorborus", 4, EncounterJournalID = 110 },
				{ "StonecoreSlabhide", 5, EncounterJournalID = 111 },
				{ "StonecoreOzruk", 6, EncounterJournalID = 112 },
				{ "StonecoreAzil", 7, EncounterJournalID = 113 },
				{ "StonecoreTrash", 10 },
			},
			["Info"] = { BabbleZone["The Stonecore"], "AtlasLootCataclysm", mapname = "TheStonecore", EncounterJournalID = 67 },
		},

		["TheVortexPinnacle"] = {
			["Bosses"] = {
				{ "VPErtan", 3, EncounterJournalID = 114 },
				{ "VPAltairus", 4 , EncounterJournalID = 115},
				{ "VPAsaad", 5, EncounterJournalID = 116 },
				{ "VPTrash", 9 },
			},
			["Info"] = { BabbleZone["The Vortex Pinnacle"], "AtlasLootCataclysm", mapname = "SkywallDungeon", EncounterJournalID = 68 },
		},

		["ThroneOfTheTides"] = {
			["Bosses"] = {
				{ "ToTNazjar", 5, EncounterJournalID = 101 },
				{ "ToTUlthok",  6, EncounterJournalID = 102 },
				{ "ToTMindbender", 7, EncounterJournalID = 103 },
				{ "ToTOzumat", 8, EncounterJournalID = 104 },
				{ "ToTTrash", 12 },
			},
			["Info"] = { BabbleZone["Throne of the Tides"], "AtlasLootCataclysm", mapname = "ThroneOfTheTides", EncounterJournalID = 65 },
		},

		["ZulAman"] = {
			["Bosses"] = {
				{ "ZAAkilZon", 6, EncounterJournalID = 186 },
				{ "ZANalorakk", 8, EncounterJournalID = 187 },
				{ "ZAJanAlai", 11, EncounterJournalID = 188 },
				{ "ZAHalazzi", 13, EncounterJournalID = 189 },
				{ "ZAMalacrass", 15, EncounterJournalID = 190 },
				{ "ZADaakara", 24, EncounterJournalID = 191 },
				{ "ZATimedChest", 40 },
				{ "ZATrash", 41 },
			},
			["Info"] = { BabbleZone["Zul'Aman"].." ", "AtlasLootCataclysm", mapname = "ZulAman", EncounterJournalID = 77 },
		},

		["ZulGurub"] = {
			["Bosses"] = {
				{ "ZGVenoxis", 17, EncounterJournalID = 175 },
				{ "ZGMandokir", 22, EncounterJournalID = 176 },
				{ "ZGMadness", 26, EncounterJournalID = { 177, 178, 179, 180 } },
				{ "ZGKilnara", 34, EncounterJournalID = 181 },
				{ "ZGZanzil", 36, EncounterJournalID = 184 },
				{ "ZGJindo", 40, EncounterJournalID = 185 },
				{ "ZGTrash", 42 },
			},
			["Info"] = { BabbleZone["Zul'Gurub"], "AtlasLootCataclysm", mapname = "ZulGurub", EncounterJournalID = 76 },
		},

	---- Raids

		["BlackwingDescent"] = {
			["Bosses"] = {
				{ "BDMagmaw", 2, EncounterJournalID = 170 },
				{ "BDOmnotron", 3, EncounterJournalID = 169 },
				{ "BDChimaeron", 4, EncounterJournalID = 172 },
				{ "BDMaloriak", 5, EncounterJournalID = 173 },
				{ "BDAtramedes", 6, EncounterJournalID = 171 },
				{ "BDNefarian", 7, EncounterJournalID = 174 },
				{ "BDTrash", 9 },
			},
			["Info"] = { BabbleZone["Blackwing Descent"], "AtlasLootCataclysm", mapname = "BlackwingDescent", raid = true, EncounterJournalID = 73 },
		},

		["BaradinHold"] = {
			["Bosses"] = {
				{ "BaradinsWardens", 1, hide = true },
				{ "HellscreamsReach", 2, hide = true },
				{ "ARGALOTH", 4, EncounterJournalID = 139 },
				{ "OCCUTHAR", 5, EncounterJournalID = 140 },
				{ "ALIZABAL", 6, EncounterJournalID = 339 },
			},
			["Info"] = { BabbleZone["Baradin Hold"], "AtlasLootCataclysm", mapname = "Baradinhold", raid = true, disableCompare = true, EncounterJournalID = 75 },
		},

		["CoTDragonSoulA"] = "CoTDragonSoul",
		["CoTDragonSoulB"] = "CoTDragonSoul",
		["CoTDragonSoulC"] = "CoTDragonSoul",
		["CoTDragonSoul"] = {
			["CoTDragonSoulA"] = {
				{ "DragonSoulMorchok", 3, EncounterJournalID = 311 },
				{ "DragonSoulUltraxion", 4, EncounterJournalID = 331, hide = true },
				{ "DragonSoulShared", 6, hide = true },
				{ "DragonSoulTrash", 7, hide = true },
				{ "DragonSoulPatterns", 8, hide = true },
			},
			["CoTDragonSoulB"] = {
				{ "DragonSoulZonozz", 2, EncounterJournalID = 324 },
				{ "DragonSoulYorsahj", 3, EncounterJournalID = 325 },
				{ "DragonSoulHagara", 4, EncounterJournalID = 317 },
				{ "DragonSoulUltraxion", EncounterJournalID = 331 },
				{ "DragonSoulShared", 6, hide = true },
				{ "DragonSoulTrash", 7, hide = true },
				{ "DragonSoulPatterns", 8, hide = true },
			},
			["CoTDragonSoulC"] = {
				{ "DragonSoulBlackhorn", 1, EncounterJournalID = 332 },
				{ "DragonSoulDeathwingSpine", 2, EncounterJournalID = 318 },
				{ "DragonSoulDeathwingMadness", 3, EncounterJournalID = 333 },
				{ "DragonSoulShared", 5 },
				{ "DragonSoulTrash", 6 },
				{ "DragonSoulPatterns", 7 },
			},
			["Info"] = { BabbleZone["Dragon Soul"], "AtlasLootCataclysm", mapname = "DragonSoul", sortOrder = { "CoTDragonSoulA", "CoTDragonSoulB", "CoTDragonSoulC" }, raid = true, EncounterJournalID = 187 },
		},

		["Firelands"] = {
			["Bosses"] = {
				{ "AvengersHyjal", {1,4}, hide = true },
				{ "FirelandsBethtilac", 6, EncounterJournalID = 192 },
				{ "FirelandsRhyolith", 7, EncounterJournalID = 193 },
				{ "FirelandsAlysrazor", 8, EncounterJournalID = 194 },
				{ "FirelandsShannox", 9, EncounterJournalID = 195 },
				{ "FirelandsBaleroc", 10, EncounterJournalID = 196 },
				{ "FirelandsStaghelm", 11, EncounterJournalID = 197 },
				{ "FirelandsRagnaros", 12, EncounterJournalID = 198 },
				{ "FirelandsShared", 15 },
				{ "FirelandsTrash", 16 },
				{ "FirelandsPatterns", 17 },
				{ "FirelandsFirestone", 3 },
			},
			["Info"] = { BabbleZone["Firelands"], "AtlasLootCataclysm", mapname = "Firelands", raid = true, EncounterJournalID = 78 },
		},

		["TheBastionOfTwilight"] = {
			["Bosses"] = {
				{ "BoTWyrmbreaker", 3, EncounterJournalID = 156 },
				{ "BoTValionaTheralion", 4, EncounterJournalID = 157 },
				{ "BoTCouncil", 6, EncounterJournalID = 158 },
				{ "BoTChogall", 8, EncounterJournalID = 167 },
				{ "BoTSinestra", 9, EncounterJournalID = 168 },
				{ "BoTTrash", 12 },
			},
			["Info"] = { BabbleZone["The Bastion of Twilight"], "AtlasLootCataclysm", mapname = "TheBastionofTwilight", raid = true, EncounterJournalID = 72 },
		},

		["ThroneOfTheFourWinds"] = {
			["Bosses"] = {
				{ "TFWConclave", 2, EncounterJournalID = 154 },
				{ "TFWAlAkir", 6, EncounterJournalID = 155 },
			},
			["Info"] = { BabbleZone["Throne of the Four Winds"], "AtlasLootCataclysm", mapname = "Throneofthefourwinds", raid = true, EncounterJournalID = 74 },
		},

-----------------------
--- WotLK Instances ---
-----------------------

	---- Dungeons

		["AhnKahet"] = {
			["Bosses"] = {
				{ "AhnkahetNadox", 3 },
				{ "AhnkahetTaldaram", 4 },
				{ "AhnkahetAmanitar", 5 },
				{ "AhnkahetJedoga", 6 },
				{ "AhnkahetVolazj", 7 },
				{ "AhnkahetTrash", 10 },
			},
			["Info"] = { BabbleZone["Ahn'kahet: The Old Kingdom"], "AtlasLootWotLK", mapname = "Ahnkahet" },
		},

		["AzjolNerub"] = {
			["Bosses"] = {
				{ "AzjolNerubKrikthir", 4 },
				{ "AzjolNerubHadronox", 8 },
				{ "AzjolNerubAnubarak", 9 },
				{ "LunarFestival", 10, hide = true },
				{ "AzjolNerubTrash", 12 },
			},
			["Info"] = { BabbleZone["Azjol-Nerub"], "AtlasLootWotLK", mapname = "AzjolNerub" },
		},

		["CoTOldStratholme"] = {
			["Bosses"] = {
				{ "CoTStratholmeMeathook", 5 },
				{ "CoTStratholmeSalramm", 6 },
				{ "CoTStratholmeEpoch", 7 },
				{ "CoTStratholmeTrash", 8, hide = true },
				{ "CoTStratholmeMalGanis", 10 },
				{ "CoTStratholmeTrash", 14 },
			},
			["Info"] = { BabbleZone["Old Stratholme"], "AtlasLootWotLK", mapname = "CoTStratholme" },
		},

		["DrakTharonKeep"] = {
			["Bosses"] = {
				{ "DrakTharonKeepTrollgore", 3 },
				{ "DrakTharonKeepNovos", 4 },
				{ "DrakTharonKeepKingDred", 5 },
				{ "DrakTharonKeepTharonja", 6 },
				{ "LunarFestival", 8, hide = true },
				{ "DrakTharonKeepTrash", 11 },
			},
			["Info"] = { BabbleZone["Drak'Tharon Keep"], "AtlasLootWotLK", mapname = "DrakTharonKeep" },
		},

		["FHTheForgeOfSouls"] = {
			["Bosses"] = {
				{ "FoSBronjahm", 3 },
				{ "FoSDevourer", 4 },
				{ "FHTrashMobs", 12 },
			},
			["Info"] = { BabbleZone["The Forge of Souls"], "AtlasLootWotLK", mapname = "TheForgeofSouls" },
		},

		["FHHallsOfReflection"] = {
			["Bosses"] = {
				{ "HoRFalric", 4 },
				{ "HoRMarwyn", 5 },
				{ "HoRLichKing", {6,7} },
				{ "FHTrashMobs", 13 },
			},
			["Info"] = { BabbleZone["Halls of Reflection"], "AtlasLootWotLK", mapname = "HallsofReflection" },
		},

		["FHPitOfSaron"] = {
			["Bosses"] = {
				{ "PoSGarfrost", 4 },
				{ "PoSKrickIck", 7 },
				{ "PoSTyrannus", 8 },
				{ "FHTrashMobs", 17 },
			},
			["Info"] = { BabbleZone["Pit of Saron"], "AtlasLootWotLK", mapname = "PitofSaron" },
		},

		["Gundrak"] = {
			["Bosses"] = {
				{ "GundrakSladran", 3 },
				{ "GundrakColossus", 4 },
				{ "GundrakMoorabi", 5 },
				{ "GundrakEck", 6 },
				{ "GundrakGaldarah", 7 },
				{ "LunarFestival", 8, hide = true },
				{ "GundrakTrash", 10 },
			},
			["Info"] = { BabbleZone["Gundrak"], "AtlasLootWotLK", mapname = "Gundrak" },
		},

		["TheNexus"] = {
			["Bosses"] = {
				{ "TheNexusKolurgStoutbeard", {2,3} },
				{ "TheNexusTelestra", 5 },
				{ "TheNexusAnomalus", 6 },
				{ "TheNexusOrmorok", 7 },
				{ "TheNexusKeristrasza", 8 },
				{ "LunarFestival", 9, hide = true },
			},
			["Info"] = { BabbleZone["The Nexus"], "AtlasLootWotLK", mapname = "TheNexus" },
		},

		["TheOculus"] = {
			["Bosses"] = {
				{ "OcuDrakos", 3 },
				{ "OcuCloudstrider", 4 },
				{ "OcuUrom", 5 },
				{ "OcuEregos", {6,8} },
				{ "OcuTrash", 10 },
			},
			["Info"] = { BabbleZone["The Oculus"], "AtlasLootWotLK", mapname = "Nexus80" },
		},

		["TrialOfTheChampion"] = {
			["Bosses"] = {
				{ "TrialoftheChampionChampions", 2 },
				{ "TrialoftheChampionEadricthePure", 15 },
				{ "TrialoftheChampionConfessorPaletress", 16 },
				{ "TrialoftheChampionBlackKnight", 17 },
			},
			["Info"] = { BabbleZone["Trial of the Champion"], "AtlasLootWotLK", mapname = "TheArgentColiseum" },
		},

		["UlduarHallsofStone"] = {
			["Bosses"] = {
				{ "HallsofStoneKrystallus", 2 },
				{ "HallsofStoneMaiden", 3 },
				{ "HallsofStoneTribunal", {4,5} },
				{ "HallsofStoneSjonnir", 6 },
				{ "LunarFestival", 7, hide = true },
				{ "HallsofStoneTrash", 10 },
			},
			["Info"] = { BabbleZone["Halls of Stone"], "AtlasLootWotLK", mapname = "Ulduar77" },
		},

		["UlduarHallsofLightning"] = {
			["Bosses"] = {
				{ "HallsofLightningBjarngrim", 2 },
				{ "HallsofLightningVolkhan", 3 },
				{ "HallsofLightningIonar", 4 },
				{ "HallsofLightningLoken", 5 },
				{ "HallsofLightningTrash", 7 },
			},
			["Info"] = { BabbleZone["Halls of Lightning"], "AtlasLootWotLK", mapname = "HallsofLightning" },
		},

		["UtgardeKeep"] = {
			["Bosses"] = {
				{ "UtgardeKeepKeleseth", 4 },
				{ "UtgardeKeepSkarvald", {5,6} },
				{ "UtgardeKeepIngvar", 7 },
				{ "LunarFestival", 8, hide = true },
				{ "UtgardeKeepTrash", 10 },
			},
			["Info"] = { BabbleZone["Utgarde Keep"], "AtlasLootWotLK", mapname = "UtgardeKeep" },
		},

		["UtgardePinnacle"] = {
			["Bosses"] = {
				{ "UPSorrowgrave", 3 },
				{ "UPPalehoof", 4 },
				{ "UPSkadi", 5 },
				{ "UPYmiron", 6 },
				{ "LunarFestival", 7, hide = true },
				{ "UPTrash", 9 },
			},
			["Info"] = { BabbleZone["Utgarde Pinnacle"], "AtlasLootWotLK", mapname = "UtgardePinnacle" },
		},

		["VioletHold"] = {
			["Bosses"] = {
				{ "VioletHoldErekem", 2 },
				{ "VioletHoldZuramat", 3 },
				{ "VioletHoldXevozz", 4 },
				{ "VioletHoldIchoron", 5 },
				{ "VioletHoldMoragg", 6 },
				{ "VioletHoldLavanthor", 7 },
				{ "VioletHoldCyanigosa", 8 },
				{ "VioletHoldTrash", 10 },
			},
			["Info"] = { BabbleZone["The Violet Hold"], "AtlasLootWotLK", mapname = "VioletHold" },
		},

	---- Raids

		["IcecrownCitadelA"] = "IcecrownCitadel",
		["IcecrownCitadelB"] = "IcecrownCitadel",
		["IcecrownCitadelC"] = "IcecrownCitadel",
		["IcecrownCitadel"] = {
			["IcecrownCitadelA"] = {
				{ "TheAshenVerdict", 1, hide = true},
				{ "ICCLordMarrowgar", 5},
				{ "ICCLadyDeathwhisper", 6},
				{ "ICCGunshipBattle", {7,8}},
				{ "ICCSaurfang", 9},
				{ "ICCTrash", 15, hide = true},
			},
			["IcecrownCitadelB"] = {
				{ "TheAshenVerdict", 1, hide = true},
				{ "ICCFestergut", 7},
				{ "ICCRotface", 8},
				{ "ICCPutricide", 9},
				{ "ICCCouncil", {10,11,12,13} },
				{ "ICCLanathel", 14},
				{ "ICCValithria", 16},
				{ "ICCSindragosa", 17},
				{ "ICCTrash", 23, hide = true},
			},
			["IcecrownCitadelC"] = {
				{ "TheAshenVerdict", 1, hide = true},
				{ "ICCLichKing", 3},
				{ "ICCTrash", 5},
			},
			["Info"] = { BabbleZone["Icecrown Citadel"], "AtlasLootWotLK", sortOrder = { "IcecrownCitadelA", "IcecrownCitadelB", "IcecrownCitadelC" }, mapname = "IcecrownCitadel", raid = true },
		},

		["Naxxramas"] = {
			["Bosses"] = {
				{ "Naxx80Patchwerk", 4 },
				{ "Naxx80Grobbulus", 5 },
				{ "Naxx80Gluth", 6 },
				{ "Naxx80Thaddius", 7 },
				{ "Naxx80AnubRekhan", 11 },
				{ "Naxx80Faerlina", 12 },
				{ "Naxx80Maexxna", 13 },
				{ "Naxx80Razuvious", 15 },
				{ "Naxx80Gothik", 16 },
				{ "Naxx80FourHorsemen", {17,22} },
				{ "Naxx80Noth", 24 },
				{ "Naxx80Heigan", 25 },
				{ "Naxx80Loatheb", 26 },
				{ "Naxx80Sapphiron", 28 },
				{ "Naxx80KelThuzad", 29 },
				{ "Naxx80Trash", 33 },
				{ "T7T8SET", 34, hide = true },
			},
			["Info"] = { BabbleZone["Naxxramas"], "AtlasLootWotLK", mapname = "IcecrownCitadel", mapname = "Naxxramas", raid = true },
		},

		["ObsidianSanctum"] = {
			["Bosses"] = {
				{ "Sartharion", 6 },
			},
			["Info"] = { BabbleZone["The Obsidian Sanctum"], "AtlasLootWotLK", mapname = "TheObsidianSanctum", raid = true },
		},

		["OnyxiasLair"] = {
			["Bosses"] = {
				{ "Onyxia", 2 },
			},
			["Info"] = { BabbleZone["Onyxia's Lair"], "AtlasLootWotLK", mapname = "OnyxiasLair", raid = true },
		},

		["RubySanctum"] = {
			["Bosses"] = {
				{ "Halion", 6 },
			},
			["Info"] = { BabbleZone["The Ruby Sanctum"], "AtlasLootWotLK", mapname = "TheRubySanctum", raid = true },
		},

		["TheEyeOfEternity"] = {
			["Bosses"] = {
				{ "Malygos", 2 },
			},
			["Info"] = { BabbleZone["The Eye of Eternity"], "AtlasLootWotLK", mapname = "TheEyeOfEternity", raid = true },
		},

		["TrialOfTheCrusader"] = {
			["Bosses"] = {
				{ "TrialoftheCrusaderNorthrendBeasts", 4 },
				{ "TrialoftheCrusaderLordJaraxxus", 9 },
				{ "TrialoftheCrusaderFactionChampions", 10 },
				{ "TrialoftheCrusaderTwinValkyrs", 11 },
				{ "TrialoftheCrusaderAnubarak", 14 },
				{ "TrialoftheCrusaderPatterns", 16 },
			},
			["Info"] = { BabbleZone["Trial of the Crusader"], "AtlasLootWotLK", mapname = "TheArgentColiseum", raid = true },
		},

		["UlduarA"] = "Ulduar",
		["UlduarB"] = "Ulduar",
		["UlduarC"] = "Ulduar",
		["UlduarD"] = "Ulduar",
		["UlduarE"] = "Ulduar",
		["Ulduar"] = {
			["UlduarA"] = {
				{ "UlduarLeviathan", 7 },
				{ "UlduarRazorscale", 8},
				{ "UlduarIgnis", 9 },
				{ "UlduarDeconstructor", 10 },
				{ "UlduarTrash", 16, hide = true},
				{ "UlduarPatterns", 17, hide = true},
				{ "T7T8SET", 18 , hide = true},
			},
			["UlduarB"] = {
				{ "UlduarIronCouncil", 3 },
				{ "UlduarKologarn", 7 },
				{ "UlduarAlgalon", 8 },
				{ "UlduarTrash", 13, hide = true },
				{ "UlduarPatterns", 14, hide = true },
				{ "T7T8SET", 15, hide = true },
			},
			["UlduarC"] = {
				{ "UlduarAuriaya", 4 },
				{ "UlduarHodir", 5 },
				{ "UlduarThorim", 6 },
				{ "UlduarFreya", 8 },
				{ "UlduarTrash", 15, hide = true },
				{ "UlduarPatterns", 16, hide = true },
				{ "T7T8SET", 17, hide = true },
			},
			["UlduarD"] = {
				{ "UlduarMimiron", 2 },
				{ "UlduarTrash", 5, hide = true },
				{ "UlduarPatterns", 6, hide = true },
				{ "T7T8SET", 7, hide = true },
			},
			["UlduarE"] = {
				{ "UlduarVezax", 2 },
				{ "UlduarYoggSaron", 3 },
				{ "UlduarTrash", 7 },
				{ "UlduarPatterns", 8 },
				{ "T7T8SET", 9, hide = true },
			},
			["Info"] = { BabbleZone["Ulduar"], "AtlasLootWotLK", sortOrder = { "UlduarA", "UlduarB", "UlduarC", "UlduarD", "UlduarE" }, mapname = "Ulduar", raid = true },
		},

		["VaultOfArchavon"] = {
			["Bosses"] = {
				{ "ARCHAVON", 2 },
				{ "EMALON", 3 },
				{ "KORALON", 4 },
				{ "TORAVON", 5 },
			},
			["Info"] = { BabbleZone["Vault of Archavon"], "AtlasLootWotLK", mapname = "VaultofArchavon", raid = true, disableCompare = true },
		},

--------------------
--- BC Instances ---
--------------------

	---- Dungeons

		["AuchAuchenaiCrypts"] = {
			["Bosses"] = {
				{ "LowerCity", 1, hide = true },
				{ "AuchCryptsShirrak", 3 },
				{ "AuchCryptsExarch", 4 },
				{ "AuchCryptsAvatar", 5 },
				{ "AuchTrash", 8 },
			},
			["Info"] = { BabbleZone["Auchenai Crypts"], "AtlasLootBurningCrusade" },
		},

		["AuchManaTombs"] = {
			["Bosses"] = {
				{ "Consortium", 1, hide = true },
				{ "AuchManaPandemonius", 4 },
				{ "AuchManaTavarok", 6 },
				{ "AuchManaNexusPrince", 7 },
				{ "AuchManaYor", 8 },
				{ "AuchTrash", 13 },
			},
			["Info"] = { BabbleZone["Mana-Tombs"], "AtlasLootBurningCrusade", mapname = "ManaTombs1" },
		},

		["AuchSethekkHalls"] = {
			["Bosses"] = {
				{ "LowerCity", 1, hide = true },
				{ "AuchSethekkDarkweaver", 3 },
				{ "AuchSethekkRavenGod", 5 },
				{ "AuchTrash", 6, hide = true },
				{ "AuchSethekkTalonKing", 7 },
				{ "AuchTrash", 9 },
			},
			["Info"] = { BabbleZone["Sethekk Halls"], "AtlasLootBurningCrusade" },
		},

		["AuchShadowLabyrinth"] = {
			["Bosses"] = {
				{ "LowerCity", 1, hide = true },
				{ "AuchShadowHellmaw", 3 },
				{ "AuchShadowBlackheart", 4 },
				{ "AuchShadowGrandmaster", 5 },
				{ "AuchShadowMurmur", 7 },
				{ "AuchTrash", 9, hide = true },
				{ "AuchTrash", 12 },
			},
			["Info"] = { BabbleZone["Shadow Labyrinth"], "AtlasLootBurningCrusade", mapname = "ShadowLabyrinth1" },
		},

		["CoTOldHillsbrad"] = {
			["Bosses"] = {
				{ "KeepersofTime", 3, hide = true },
				{ "CoTHillsbradDrake", 10 },
				{ "CoTHillsbradSkarloc", 12 },
				{ "CoTHillsbradHunter", 15 },
				{ "CoTTrash", {18,20,21}, hide = true },
				{ "CoTTrash", 25 },
			},
			["Info"] = { BabbleZone["Old Hillsbrad Foothills"], "AtlasLootBurningCrusade" },
		},

		["CoTBlackMorass"] = {
			["Bosses"] = {
				{ "KeepersofTime", 3, hide = true },
				{ "CoTMorassDeja", 7 },
				{ "CoTMorassTemporus", 8 },
				{ "CoTMorassAeonus", 9 },
				{ "CoTTrash", 13 },	
			},
			["Info"] = { BabbleZone["The Black Morass"], "AtlasLootBurningCrusade" },
		},

		["CFRTheSlavePens"] = {
			["Bosses"] = {
				{ "CExpedition", 1, hide = true },
				{ "CFRSlaveMennu", 3 },
				{ "CFRSlaveRokmar", 4 },
				{ "CFRSlaveQuagmirran", 5 },
				{ "LordAhune", 6, hide = true },
			},
			["Info"] = { BabbleZone["The Slave Pens"], "AtlasLootBurningCrusade" },
		},

		["CFRTheSteamvault"] = {
			["Bosses"] = {
				{ "CExpedition", 1, hide = true },
				{ "CFRSteamThespia", 3 },
				{ "CFRSteamSteamrigger", 5 },
				{ "CFRSteamWarlord", 7 },
				{ "CFRSteamTrash", 9, hide = true },
				{ "CFRSteamTrash", 11 },
			},
			["Info"] = { BabbleZone["The Steamvault"], "AtlasLootBurningCrusade" },
		},

		["CFRTheUnderbog"] = {
			["Bosses"] = {
				{ "CExpedition", 1, hide = true },
				{ "CFRUnderHungarfen", 3 },
				{ "CFRUnderGhazan", 5 },
				{ "CFRUnderSwamplord", 6 },
				{ "CFRUnderStalker", 8 },
			},
			["Info"] = { BabbleZone["The Underbog"], "AtlasLootBurningCrusade" },
		},
		
		["HCHellfireRamparts"] = {
			["Bosses"] = {
				{ "HonorHold", 1, hide = true },
				{ "Thrallmar", 2, hide = true },
				{ "HCRampWatchkeeper", 4 },
				{ "HCRampOmor", 5 },
				{ "HCRampVazruden", {6,8} },
			},
			["Info"] = { BabbleZone["Hellfire Ramparts"], "AtlasLootBurningCrusade" },
		},

		["HCBloodFurnace"] = {
			["Bosses"] = {
				{ "HonorHold", 1, hide = true },
				{ "Thrallmar", 2, hide = true },
				{ "HCFurnaceMaker", 4 },
				{ "HCFurnaceBroggok", 5 },
				{ "HCFurnaceBreaker", 6 },
			},
			["Info"] = { BabbleZone["The Blood Furnace"], "AtlasLootBurningCrusade" },
		},

		["HCTheShatteredHalls"] = {
			["Bosses"] = {
				{ "HonorHold", 1, hide = true },
				{ "Thrallmar", 2, hide = true },
				{ "HCHallsNethekurse", 4 },
				{ "HCHallsPorung", 5 },
				{ "HCHallsOmrogg", 6 },
				{ "HCHallsKargath", 7 },
				{ "HCHallsTrash", 8, hide = true },
				{ "HCHallsTrash", 18 },
			},
			["Info"] = { BabbleZone["The Shattered Halls"], "AtlasLootBurningCrusade" },
		},

		["MagistersTerrace"] = {
			["Bosses"] = {
				{ "SunOffensive", 1, hide = true },
				{ "SMTFireheart", 4 },
				{ "SMTVexallus", 6 },
				{ "SMTDelrissa", 7 },
				{ "SMTKaelthas", 18 },
				{ "SMTTrash", 23 },
			},
			["Info"] = { BabbleZone["Magisters' Terrace"], "AtlasLootBurningCrusade" },
		},

		["TempestKeepArcatraz"] = {
			["Bosses"] = {
				{ "Shatar", 1, hide = true },
				{ "TKArcUnbound", 3 },
				{ "TKArcDalliah", 4 },
				{ "TKArcScryer", 5 },
				{ "TKArcHarbinger", 6 },
				{ "TKTrash", 10, hide = true },
				{ "TKTrash", 13 },
			},
			["Info"] = { BabbleZone["The Arcatraz"], "AtlasLootBurningCrusade" },
		},

		["TempestKeepBotanica"] = {
			["Bosses"] = {
				{ "Shatar", 1, hide = true },
				{ "TKBotSarannis", 4 },
				{ "TKBotFreywinn", 5 },
				{ "TKBotThorngrin", 6 },
				{ "TKBotLaj", 7 },
				{ "TKBotSplinter", 8 },
				{ "TKTrash", 10 },
			},
			["Info"] = { BabbleZone["The Botanica"], "AtlasLootBurningCrusade" },
		},

		["TempestKeepMechanar"] = {
			["Bosses"] = {
				{ "Shatar", 1, hide = true },
				{ "TKMechCapacitus", 6 },
				{ "TKTrash", 7, hide = true },
				{ "TKMechSepethrea", 8 },
				{ "TKMechCalc", 9 },
				{ "TKMechCacheoftheLegion", 10 },
				{ "TKTrash", 12 },
			},
			["Info"] = { BabbleZone["The Mechanar"], "AtlasLootBurningCrusade" },
		},

	---- Raids

		["BlackTempleStart"] = "BlackTemple",
		["BlackTempleBasement"] = "BlackTemple",
		["BlackTempleTop"] = "BlackTemple",
		["BlackTemple"] = {
			["BlackTempleStart"] = {
				{ "Ashtongue", 1, hide = true },
				{ "BTNajentus", 6 },
				{ "BTSupremus", 7 },
				{ "BTAkama", 8 },
				{ "BTTrash", 15, hide = true },
				{ "BTPatterns", 16, hide = true },
			},
			["BlackTempleBasement"] = {
				{ "Ashtongue", 1, hide = true },
				{ "BTBloodboil", 4 },
				{ "BTReliquaryofSouls", 5 },
				{ "BTGorefiend", 9 },
				{ "BTTrash", 11, hide = true },
				{ "BTPatterns", 12, hide = true },
			},
			["BlackTempleTop"] = {
				{ "Ashtongue", 1, hide = true },
				{ "BTShahraz", 4 },
				{ "BTCouncil", 5 },
				{ "BTIllidanStormrage", 10 },
				{ "BTTrash", 12 },
				{ "BTPatterns", 13 },
			},
			["Info"] = { BabbleZone["Black Temple"], "AtlasLootBurningCrusade", sortOrder = { "BlackTempleStart", "BlackTempleBasement", "BlackTempleTop" }, raid = true },
		},

		["CoTHyjalEnt"] = "CoTHyjalEaI",
		["CoTHyjal"] = "CoTHyjalEaI",
		["CoTHyjalEaI"] = {
			["CoTHyjalEnt"] = {
				{ "ScaleSands", 2, hide = true },
			},
			["CoTHyjal"] = {
				{ "ScaleSands", 2, hide = true },
				{ "MountHyjalWinterchill", 9 },
				{ "MountHyjalAnetheron", 10 },
				{ "MountHyjalKazrogal", 11 },
				{ "MountHyjalAzgalor", 12 },
				{ "MountHyjalArchimonde", 13 },
				{ "MountHyjalTrash", 15 },
			},
			["Info"] = { BabbleZone["Hyjal"], "AtlasLootBurningCrusade", sortOrder = { "CoTHyjalEnt", "CoTHyjal" }, raid = true },
		},

		["CFRSerpentshrineCavern"] = {
			["Bosses"] = {
				{ "CExpedition", 1, hide = true },
				{ "CFRSerpentHydross", 3 },
				{ "CFRSerpentLurker", 4 },
				{ "CFRSerpentLeotheras", 5 },
				{ "CFRSerpentKarathress", 6 },
				{ "CFRSerpentMorogrim", 8 },
				{ "CFRSerpentVashj", 9 },
				{ "CFRSerpentTrash", 11 },
			},
			["Info"] = { BabbleZone["Serpentshrine Cavern"], "AtlasLootBurningCrusade", raid = true },
		},

		["GruulsLair"] = {
			["Bosses"] = {
				{ "GruulsLairHighKingMaulgar", 2 },
				{ "GruulGruul", 7 },
			},
			["Info"] = { BabbleZone["Gruul's Lair"], "AtlasLootBurningCrusade", raid = true },
		},

		["HCMagtheridonsLair"] = {
			["Bosses"] = {
				{ "HCMagtheridon", 2 },
			},
			["Info"] = { BabbleZone["Magtheridon's Lair"], "AtlasLootBurningCrusade", raid = true },
		},

		["KarazhanEnt"] = "KarazhanEaI",
		["KarazhanStart"] = "KarazhanEaI",
		["KarazhanEnd"] = "KarazhanEaI",
		["KarazhanEaI"] = {
			["KarazhanEnt"] = {
				{ "KaraCharredBoneFragment", 8, hide = true },
			},
			["KarazhanStart"] = {
				{ "VioletEye", 1, hide = true },
				{ "KaraAttumen", 4 },
				{ "KaraMoroes", 6 },
				{ "KaraMaiden", 13 },
				{ "KaraOperaEvent", 14 },
				{ "KaraNightbane", 27 },
				{ "KaraNamed", {29,30,31,32} },
				{ "KaraTrash", 38, hide = true },
				{ "KaraTrash", 43, hide = true },
			},
			["KarazhanEnd"] = {
				{ "VioletEye", 1, hide = true },
				{ "KaraCurator", 10 },
				{ "KaraIllhoof", 11 },
				{ "KaraAran", 13 },
				{ "KaraNetherspite", 14 },
				{ "KaraChess", {15,16} },
				{ "KaraPrince", 17 },
				{ "KaraTrash", 24 },
			},
			["Info"] = { BabbleZone["Karazhan"], "AtlasLootBurningCrusade", sortOrder = { "KarazhanEnt", "KarazhanStart", "KarazhanEnd" }, raid = true },
		},

		["SunwellPlateau"] = {
			["Bosses"] = {
				{ "SPKalecgos", 2 },
				{ "SPBrutallus", 4 },
				{ "SPFelmyst", 5 },
				{ "SPEredarTwins", 7 },
				{ "SPMuru", 10 },
				{ "SPKiljaeden", 12 },
				{ "SPTrash", 14 },
				{ "SPPatterns", 15 },
			},
			["Info"] = { BabbleZone["Sunwell Plateau"], "AtlasLootBurningCrusade", raid = true },
		},

		["TempestKeepTheEye"] = {
			["Bosses"] = {
				{ "Shatar", 1, hide = true },
				{ "TKEyeAlar", 3 },
				{ "TKEyeVoidReaver", 4 },
				{ "TKEyeSolarian", 5 },
				{ "TKEyeKaelthas", 6 },
				{ "TKEyeTrash", 12 },
			},
			["Info"] = { BabbleZone["The Eye"], "AtlasLootBurningCrusade", raid = true },
		},

-------------------------
--- Classic Instances ---
-------------------------

		["BlackfathomDeeps"] = {
			["Bosses"] = {
				{ "Blackfathom#1", {3,4,5,7,8,11} },
				{ "Blackfathom#2", {9,12,19}, hide = true },
			},
			["Info"] = { BabbleZone["Blackfathom Deeps"], "AtlasLootClassicWoW", mapname = "BlackFathomDeeps" },
		},

		["BlackrockDepths"] = {
			["Bosses"] = {
				{ "BRDHighInterrogatorGerstahn", 6 },
				{ "BRDLordRoccor", 7 },
				{ "BRDHoundmaster", 8 },
				{ "BRDBaelGar", 9 },
				{ "BRDLordIncendius", 10 },
				{ "BRDFineousDarkvire", 12 },
				{ "BRDTheVault", 13 },
				{ "BRDWarderStilgiss", 14 },
				{ "BRDVerek", 15 },
				{ "BRDPyromantLoregrain", 17 },
				{ "BRDArena", {18,20,21,22,23,24,25} },
				{ "LunarFestival", 26, hide = true },
				{ "BRDGeneralAngerforge", 27 },
				{ "BRDGolemLordArgelmach", 28 },
				{ "BRDBSPlans", {30,59}, hide = true },
				{ "BRDGuzzler", {31,33,34,35} },
				{ "CorenDirebrew", 32, hide = true },
				{ "BRDFlamelash", 38 },
				{ "BRDTomb", 39 },
				{ "BRDMagmus", 40 },
				{ "BRDImperatorDagranThaurissan", 41 },
				{ "BRDPrincess", 42 },
				{ "BRDPanzor", 44 },
				{ "BRDQuestItems", {69,70}, hide = true },
				{ "BRDTrash", 72 },
				{ "VWOWSets#1", 73, hide = true },
			},
			["Info"] = { BabbleZone["Blackrock Depths"], "AtlasLootClassicWoW", mapname = "BlackrockDepths" },
		},

		["BlackrockMountainEnt"] = {
			["Bosses"] = {
				{ "BlackrockMountainEntLoot", {12,13,14}, hide = true },
			},
			["Info"] = { BabbleZone["Blackrock Mountain"], "AtlasLootClassicWoW" },
		},

		["BlackrockSpireLower"] = {
			["Bosses"] = {
				{ "LBRSOmokk", 4 },
				{ "LBRSVosh", 5 },
				{ "LBRSVoone", 6 },
				{ "LBRSSmolderweb", 7 },
				{ "LBRSDoomhowl", 8 },
				{ "LBRSZigris", 10 },
				{ "LBRSHalycon", 11 },
				{ "LBRSSlavener", 12 },
				{ "LBRSWyrmthalak", 13 },
				{ "LBRSFelguard", 14 },
				{ "LBRSSpirestoneButcher", 15 },
				{ "LBRSGrimaxe", 16 },
				{ "LBRSCrystalFang", 17 },
				{ "LBRSSpirestoneLord", 18 },
				{ "LBRSLordMagus", 19 },
				{ "LBRSBashguud", 20 },
				{ "LunarFestival", 22, hide = true },
				{ "LBRSQuestItems", 23, hide = true },
				{ "LBRSTrash", 25 },
				{ "T0SET", 26, hide = true },
				{ "VWOWSets#3", 27, hide = true },
			},
			["Info"] = { BabbleZone["Lower Blackrock Spire"], "AtlasLootClassicWoW", mapname = "BlackrockSpire" },
		},

		["BlackrockSpireUpper"] = {
			["Bosses"] = {
				{ "UBRSEmberseer", 5 },
				{ "UBRSSolakar", 6 },
				{ "UBRSAnvilcrack", 7 },
				{ "UBRSRend", 8 },
				{ "UBRSGyth", 9 },
				{ "UBRSBeast", 10 },
				{ "UBRSDrakkisath", 12 },
				{ "UBRSRunewatcher", 14 },
				{ "UBRSFLAME", 16 },
				{ "UBRSTrash", 18 },
				{ "T0SET", 19, hide = true },
				{ "VWOWSets#3", 20, hide = true },
			},
			["Info"] = { BabbleZone["Upper Blackrock Spire"], "AtlasLootClassicWoW", mapname = "BlackrockSpire" },
		},	

		["BlackwingLair"] = {
			["Bosses"] = {
				{ "BWLRazorgore", 6 },
				{ "BWLVaelastrasz", 7 },
				{ "BWLLashlayer", 8 },
				{ "BWLFiremaw", 9 },
				{ "BWLEbonroc", 10 },
				{ "BWLTrashMobs",  11, hide = true },
				{ "BWLFlamegor", 12 },
				{ "BWLChromaggus", 13 },
				{ "BWLNefarian", 14 },
				{ "BWLTrashMobs",  17 },
				{ "T1T2T3SET", 18, hide = true },
			},
			["Info"] = { BabbleZone["Blackwing Lair"], "AtlasLootClassicWoW", mapname = "BlackwingLair", raid = true },
		},

		["DireMaulEnt"] = {
			["Bosses"] = {
				{ "LunarFestival", 7, hide = true },
			},
			["Info"] = { BabbleZone["Dire Maul"], "AtlasLootWorldEvents" },
		},

		["DireMaulNorth"] = {
			["Bosses"] = {
				{ "DMNGuardMoldar", 4 },
				{ "DMNStomperKreeg", 5 },
				{ "DMNGuardFengus", 6 },
				{ "DMNGuardSlipkik", 7 },
				{ "DMNThimblejack", 8 },
				{ "DMNCaptainKromcrush", 9 },
				{ "DMNKingGordok", 10 },
				{ "DMNChoRush", 11 }, 
				{ "DMNTRIBUTERUN", 13 },
				{ "DMBooks", 14 },
			},
			["Info"] = { BabbleZone["Dire Maul (North)"], "AtlasLootClassicWoW", mapname = "DireMaul" },
		},

		["DireMaulEast"] = {
			["Bosses"] = {
				{ "DMELethtendrisPimgib", {8,9} },
				{ "DMEHydro", 10 },
				{ "DMEZevrimThornhoof", 11 },
				{ "DMEAlzzin", 12 },
				{ "DMEPusillin", {13,14} },
				{ "DMETrash", 17 },
				{ "DMBooks", 18 },
			},
			["Info"] = { BabbleZone["Dire Maul (East)"], "AtlasLootClassicWoW", mapname = "DireMaul" },
		},

		["DireMaulWest"] = {
			["Bosses"] = {
				{ "OldKeys", 1, hide = true },
				{ "DMWTendrisWarpwood", 4 },
				{ "DMWMagisterKalendris", 5 },
				{ "DMWIllyannaRavenoak", 6 },
				{ "DMWImmolthar", 8 },
				{ "DMWHelnurath", 9 },
				{ "DMWPrinceTortheldrin", 10 },
				{ "DMWTsuzee", 11 },
				{ "DMWTrash", 23, hide = true },
				{ "DMWTrash", 25 },
				{ "DMBooks", 26 },
			},
			["Info"] = { BabbleZone["Dire Maul (West)"], "AtlasLootClassicWoW", mapname = "DireMaul" },
		},

		["Maraudon"] = {
			["Bosses"] = {
				{ "MaraudonLoot#1", {4,5,6,7,12} },
				{ "MaraudonLoot#2", {8,9,10,11}, hide = true }, 
				{ "LunarFestival", 13, hide = true },
			},
			["Info"] = { BabbleZone["Maraudon"], "AtlasLootClassicWoW", mapname = "Maraudon" },
		},

		["Uldaman"] = {
			["Bosses"] = {
				{ "UldShovelphlange", },
				{ "UldBaelog", {4,5,6,7} },
				{ "UldRevelosh", 8 },
				{ "UldIronaya", 9 },
				{ "UldObsidianSentinel", 10 },
				{ "UldAncientStoneKeeper", 11 },
				{ "UldGalgannFirehammer", 12 },
				{ "UldGrimlok", 13 },
				{ "UldArchaedas", 14 },
				{ "UldTrash", 24 },
			},
			["Info"] = { BabbleZone["Uldaman"], "AtlasLootClassicWoW", mapname = "Uldaman" },
		},

		["StratholmeCrusader"] = {
			["Bosses"] = {
				{ "STRATTheUnforgiven", 5 },
				{ "STRATTimmytheCruel", 6 },
				{ "STRATWilleyHopebreaker", 8 },
				{ "STRATInstructorGalford", 9 },
				{ "STRATBalnazzar", 10 },
				{ "STRATSkull", 12 },
				{ "STRATFrasSiabi", 13 },
				{ "STRATHearthsingerForresten", 14 },
				{ "STRATRisenHammersmith", {15,16} },
				{ "LunarFestival", 19, hide = true },
				{ "STRATTrash", 23 },
				{ "VWOWSets#2", {17,18,20,21}, hide = true },
			},
			["Info"] = { BabbleZone["Stratholme"].." - "..AL["Crusader's Square"], "AtlasLootClassicWoW", mapname = "Stratholme" },
		},

		["StratholmeGauntlet"] = {
			["Bosses"] = {
				{ "STRATBaronessAnastari", 3 },
				{ "STRATNerubenkan", 4 },
				{ "STRATMalekithePallid", 5 },
				{ "STRATMagistrateBarthilas", 6 },
				{ "STRATRamsteintheGorger", 7 },
				{ "STRATLordAuriusRivendare", 8 },
				{ "STRATBlackGuardSwordsmith", {9,10} },
				{ "STRATStonespine", },
				{ "STRATTrash", 17 },
				{ "VWOWSets#2", 11, hide = true },
			},
			["Info"] = { BabbleZone["Stratholme"].." - "..AL["The Gauntlet"], "AtlasLootClassicWoW", mapname = "Stratholme" },
		},

		["RazorfenDowns"] = {
			["Bosses"] = {
				{ "RazorfenDownsLoot#1", {3,4,5,8,10} },
				{ "RazorfenDownsLoot#2", {6,7}, hide = true },
			},
			["Info"] = { BabbleZone["Razorfen Downs"], "AtlasLootClassicWoW", mapname = "RazorfenDowns" },
		},

		["RazorfenKraul"] = {
			["Bosses"] = {
				{ "RazorfenKraulLoot#1", {3,4,5,6,7,10} }, 
				{ "RazorfenKraulLoot#2", {8,11}, hide = true }, 
			},
			["Info"] = { BabbleZone["Razorfen Kraul"], "AtlasLootClassicWoW", mapname = "RazorfenKraul" },
		},

		["TheSunkenTemple"] = {
			["Bosses"] = { 
				{ "STAvatarofHakkar", 3 },
				{ "STJammalanandOgom", {4,5} },
				{ "STDragons", {6,7,8,9} },
				{ "STEranikus", 10 },
				{ "LunarFestival", 12, hide = true },
				{ "STTrash", 14 },
			},
			["Info"] = { BabbleZone["Sunken Temple"], "AtlasLootClassicWoW", mapname = "TempleOfAtalHakkar" },
		},

		["RagefireChasm"] = {
			["Bosses"] = {
				{ "RagefireChasmLoot", {2,3,4,5} },
			},
			["Info"] = { BabbleZone["Ragefire Chasm"], "AtlasLootClassicWoW", mapname = "Ragefire" },
		},

		["MoltenCore"] = {
			["Bosses"] = {
				{ "BloodsailHydraxian", 2, hide = true },
				{ "MCLucifron", 4 },
				{ "MCMagmadar", 5 },
				{ "MCGehennas", 6 },
				{ "MCGarr", 7 },
				{ "MCShazzrah", 8 },
				{ "MCGeddon", 9 },
				{ "MCGolemagg", 10 },
				{ "MCSulfuron", 11 },
				{ "MCMajordomo", 12 },
				{ "MCRagnaros", 13 },
				{ "T1T2T3SET", 15, hide = true },
				{ "MCRANDOMBOSSDROPPS", 16 },
				{ "MCTrashMobs", 17 },
			},
			["Info"] = { BabbleZone["Molten Core"], "AtlasLootClassicWoW", mapname = "MoltenCore", raid = true },
		},

		["TheTempleofAhnQiraj"] = {
			["Bosses"] = {
				{ "AQBroodRings", 1, hide = true },
				{ "AQ40Skeram", 4 },
				{ "AQ40BugFam", {5,6,7,8} },
				{ "AQ40Sartura", 9 },
				{ "AQ40Fankriss", 10 },
				{ "AQ40Viscidus", 11 },
				{ "AQ40Huhuran", 12 },
				{ "AQ40Emperors", {13,14,15} },
				{ "AQ40Ouro", 17 },
				{ "AQ40CThun", {18,19} },
				{ "AQ40Trash", 28 },
				{ "AQ40Sets", 29, hide = true },
				{ "AQEnchants", 30 },
			},
			["Info"] = { BabbleZone["Temple of Ahn'Qiraj"], "AtlasLootClassicWoW", mapname = "TempleofAhnQiraj", raid = true },
		},

		["ShadowfangKeep"] = {
			["Bosses"] = {
				{ "ShadowfangAshbury", 3, EncounterJournalID = 96 },
				{ "ShadowfangSilverlaine", 4, EncounterJournalID = 97 },
				{ "ShadowfangSpringvale", 9, EncounterJournalID = 98 },
				{ "ShadowfangWalden", 10, EncounterJournalID = 99 },
				{ "ShadowfangGodfrey", 11, EncounterJournalID = 100 },
				{ "Valentineday#3", 12, hide = true },
				{ "ShadowfangTrash", 21 },
			},
			["Info"] = { BabbleZone["Shadowfang Keep"], {"AtlasLootClassicWoW", "AtlasLootCataclysm"}, mapname = "ShadowfangKeep", EncounterJournalID = 64 },
		},

		["Gnomeregan"] = {
			["Bosses"] = {
				{ "GnomereganLoot#1", {4,7,8,9} },
				{ "GnomereganLoot#2", {10}, hide = true },
			},
			["Info"] = { BabbleZone["Gnomeregan"], "AtlasLootClassicWoW", mapname = "Gnomeregan" },
		},

		["SMArmory"] = {
			["Bosses"] = {
				{ "SMArmoryLoot", 4 },
				{ "SMTrash", 7 },
				{ "VWOWSets#1", 8, hide = true },
			},
			["Info"] = { BabbleZone["Scarlet Monastery"]..": "..BabbleZone["Armory"], "AtlasLootClassicWoW", mapname = "ScarletMonastery" },
		},

		["SMCathedral"] = {
			["Bosses"] = {
				{ "SMCathedralLoot", {2,3,4} },
				{ "SMTrash", 9 },
				{ "VWOWSets#1", 10, hide = true },
			},
			["Info"] = { BabbleZone["Scarlet Monastery"]..": "..BabbleZone["Cathedral"], "AtlasLootClassicWoW", mapname = "ScarletMonastery" },
		},

		["SMLibrary"] = {
			["Bosses"] = {
				{ "SMLibraryLoot", {2,3} },
				{ "SMTrash", 9 },
				{ "VWOWSets#1", 10, hide = true },
			},
			["Info"] = { BabbleZone["Scarlet Monastery"]..": "..BabbleZone["Library"], "AtlasLootClassicWoW", mapname = "ScarletMonastery" },
		},

		["SMGraveyard"] = {
			["Bosses"] = {
				{ "SMGraveyardLoot", {2,4} },
				{ "HeadlessHorseman", 5, hide = true },
				{ "SMTrash", 10 },
				{ "VWOWSets#1", 11, hide = true },
			},
			["Info"] = { BabbleZone["Scarlet Monastery"]..": "..BabbleZone["Graveyard"], "AtlasLootClassicWoW", mapname = "ScarletMonastery" },
		},

		["Scholomance"] = {
			["Bosses"] = {
				{ "OldKeys", {1,2}, hide = true },
				{ "SCHOLOKirtonostheHerald", 9 },
				{ "SCHOLOJandiceBarov", 10 },
				{ "SCHOLORattlegore", 11 },
				{ "SCHOLODeathKnight", 12 },
				{ "SCHOLORasFrostwhisper", 13 },
				{ "SCHOLOLorekeeperPolkelt", 14 },
				{ "SCHOLODoctorTheolenKrastinov", 15 },
				{ "SCHOLOInstructorMalicia", 16 },
				{ "SCHOLOLadyIlluciaBarov", 17 },
				{ "SCHOLOLordAlexeiBarov", 18 },
				{ "SCHOLOQuestItems", {19,25,27,28}, hide = true },
				{ "SCHOLOTheRavenian", 20 },
				{ "SCHOLODarkmasterGandling", 21 },
				{ "SCHOLOMardukVectus", {22,23} },
				{ "SCHOLOBloodStewardofKirtonos", 24 },
				{ "SCHOLOTrash", 30 },
				{ "VWOWScholo", 31, hide = true },
			},
			["Info"] = { BabbleZone["Scholomance"], "AtlasLootClassicWoW", mapname = "Scholomance" },
		},

		["TheDeadminesEnt"] = "TheDeadminesEaI",
		["TheDeadmines"] = "TheDeadminesEaI",
		["TheDeadminesEaI"] = {
			["TheDeadminesEnt"] = {
				{ "DeadminesTrash", {4,5}, hide = true },
			},
			["TheDeadmines"] = {
				{ "DeadminesGlubtok", 3, EncounterJournalID = 89 },
				{ "DeadminesGearbreaker", 5, EncounterJournalID = 90 },
				{ "DeadminesFoeReaper", 6, EncounterJournalID = 91 },
				{ "DeadminesRipsnarl", 7, EncounterJournalID = 92 },
				{ "DeadminesCookie", 8, EncounterJournalID = 93 },
				{ "DeadminesVanessa", 9, EncounterJournalID = 95 },
				{ "DeadminesTrash", 18 },
			},
			["Info"] = { BabbleZone["The Deadmines"], {"AtlasLootClassicWoW", "AtlasLootCataclysm"}, sortOrder = { "TheDeadminesEnt", "TheDeadmines" }, mapname = "TheDeadmines", EncounterJournalID = 63 },
		},

		["WailingCavernsEnt"] = "WailingCavernsEaI",
		["WailingCaverns"] = "WailingCavernsEaI",
		["WailingCavernsEaI"] = {
			["WailingCavernsEnt"] = {
				{ "WailingCavernsLoot#1", 3, hide = true },
			},
			["WailingCaverns"] = {
				{ "WailingCavernsLoot#1", {2,3,4,5} },
				{ "WailingCavernsLoot#2", {6,7,8,10,11}, hide = true },
				{ "VWOWSets#1", 16, hide = true },
			},
			["Info"] = { BabbleZone["Wailing Caverns"], "AtlasLootClassicWoW", sortOrder = { "WailingCavernsEnt", "WailingCaverns" }, mapname = "WailingCaverns" },
		},

		["TheStockade"] = {
			["Bosses"] = {
				{ "Stockade", {2,3,4} },
			},
			["Info"] = { BabbleZone["The Stockade"], "AtlasLootClassicWoW", mapname = "TheStockade" },
		},

		["TheRuinsofAhnQiraj"] = {
			["Bosses"] = {
				{ "CenarionCircle", 1, hide = true },
				{ "AQ20Kurinnaxx", 3 },
				{ "AQ20Rajaxx", {6,7,8,9,10,11,12,13} },
				{ "AQ20Moam", 14 },
				{ "AQ20Buru", 15 },
				{ "AQ20Ayamiss", 16 },
				{ "AQ20Ossirian", 17 },
				{ "AQ20Trash", 20 },
				{ "AQ20Sets", 21, hide = true },
				{ "AQEnchants", 22 },
			},
			["Info"] = { BabbleZone["Ruins of Ahn'Qiraj"], "AtlasLootClassicWoW", mapname = "RuinsofAhnQiraj", raid = true },
		},

		["ZulFarrak"] = {
			["Bosses"] = {
				{ "ZFGahzrilla", 5 },
				{ "ZFSezzziz", 12 },
				{ "ZFChiefUkorzSandscalp", 14 },
				{ "ZFWitchDoctorZumrah", 16 },
				{ "ZFAntusul", 17 },
				{ "ZFHydromancerVelratha", 19 },
				{ "ZFDustwraith", 21 },
				{ "ZFZerillis", 22 },
				{ "LunarFestival", 23, hide = true },
				{ "ZFTrash", 25 },
			},
			["Info"] = { BabbleZone["Zul'Farrak"], "AtlasLootClassicWoW", mapname = "ZulFarrak" },
		},
	},

---------------------
--- Battlegrounds ---
---------------------

	["Battlegrounds"] = {

		["AlteracValleyNorth"] = {
			["Bosses"] = {
				{ "MiscFactions", 1 },
				{ "AVMisc", 48 },
				{ "AVBlue", 49 },
			},
			["Info"] = { BabbleZone["Alterac Valley"], "AtlasLootClassicWoW" },
		},

		["AlteracValleySouth"] = {
			["Bosses"] = {
				{ "MiscFactions", 1 },
				{ "AVMisc", 31 },
				{ "AVBlue", 32 },
			},
			["Info"] = { BabbleZone["Alterac Valley"], "AtlasLootClassicWoW" },
		},

		["ArathiBasin"] = {
			["Bosses"] = {
				{ "MiscFactions", {1,2} },
				{ "AB2039", 11 },
				{ "AB4049", 12 },
				{ "ABSets", 13 },
				{ "ABMisc", 14 },
			},
			["Info"] = { BabbleZone["Arathi Basin"], "AtlasLootClassicWoW" },
		},

		["HalaaPvP"] = {
			["Bosses"] = {
				{ "Nagrand", 1 },
			},
			["Info"] = { BabbleZone["Nagrand"]..": "..AL["Halaa"], "AtlasLootBurningCrusade" },
		},

		["HellfirePeninsulaPvP"] = {
			["Bosses"] = {
				{ "Hellfire", 1 },
			},
			["Info"] = { BabbleZone["Hellfire Peninsula"]..": "..AL["Hellfire Fortifications"], "AtlasLootBurningCrusade" },
		},

		["TerokkarForestPvP"] = {
			["Bosses"] = {
				{ "Terokkar", 1 },
			},
			["Info"] = { BabbleZone["Terokkar Forest"]..": "..AL["Spirit Towers"], "AtlasLootBurningCrusade" },
		},

		["ZangarmarshPvP"] = {
			["Bosses"] = {
				{ "Zangarmarsh", 1 },
			},
			["Info"] = { BabbleZone["Zangarmarsh"]..": "..AL["Twin Spire Ruins"], "AtlasLootBurningCrusade" },
		},

		["WintergraspPvP"] = {
			["Bosses"] = {
				{ "LakeWintergrasp", 1 },
			},
			["Info"] = { BabbleZone["Wintergrasp"], "AtlasLootWotLK" },
		},

		["TolBarad"] = {
			["Bosses"] = {
				{ "BaradinsWardens", 1 },
				{ "HellscreamsReach", 2 },
			},
			["Info"] = { BabbleZone["Tol Barad"], "AtlasLootCataclysm" },
		},

		["TwinPeaks"] = {
			["Bosses"] = {
				{ "WildhammerClan", 1 },
				{ "DragonmawClan", 2 },
			},
			["Info"] = { BabbleZone["Twin Peaks"], "AtlasLootCataclysm" },
		},
	},

--------------------
--- World Bosses ---
--------------------

	["WorldBosses"] = {

		["DoomLordKazzak"] = {
			["Bosses"] = {
				{ "WorldBossesBC", 1 },
				{ "Thrallmar", 5, hide = true },
			},
			["Info"] = { BabbleBoss["Doom Lord Kazzak"], "AtlasLootBurningCrusade" },
		},

		["Doomwalker"] = {
			["Bosses"] = {
				{ "WorldBossesBC", 1 },
			},
			["Info"] = { BabbleBoss["Doomwalker"], "AtlasLootBurningCrusade" },
		},

		["Skettis"] = {
			["Bosses"] = {
				{ "Terokk", 9 },
				{ "DarkscreecherAkkarai", 18 },
				{ "GezzaraktheHuntress", 19 },
				{ "Karrog", 20 },
				{ "VakkiztheWindrager", 21 },
			},
			["Info"] = { AL["Skettis"], "AtlasLootWorldEvents" },
		},
	},

--------------------
--- World Events ---
--------------------

	["WorldEvents"] = {

		["MidsummerFestival"] = {
			["Bosses"] = {
				{ "MidsummerFestival" },
				{ "LordAhune" },
			},
			["Info"] = { AL["Midsummer Fire Festival"], "AtlasLootWorldEvents"},
		},
	},

----------------
--- Crafting ---
----------------

	["Crafting"] = {

		["Leatherworking"] = {
			["Bosses"] = {
				{ "Dragonscale" },
				{ "Elemental" },
				{ "Tribal" },
			},
			["Info"] = { LEATHERWORKING, "AtlasLootCrafting"},
		},

		["Tailoring"] = {
			["Bosses"] = {
				{ "Mooncloth" },
				{ "Shadoweave" },
				{ "Spellfire" },
			},
			["Info"] = { TAILORING, "AtlasLootCrafting"},
		},

		["BlacksmithingMail"] = {
			["Bosses"] = {
				{ "BlacksmithingMailBloodsoulEmbrace" },
				{ "BlacksmithingMailFelIronChain" },
			},
			["Info"] = { BLACKSMITHING..": "..BabbleInventory["Mail"], "AtlasLootCrafting"},
		},

		["BlacksmithingPlate"] = {
			["Bosses"] = {
				{ "BlacksmithingPlateImperialPlate" },
				{ "BlacksmithingPlateTheDarksoul" },
				{ "BlacksmithingPlateFelIronPlate" },
				{ "BlacksmithingPlateAdamantiteB" },
				{ "BlacksmithingPlateFlameG" },
				{ "BlacksmithingPlateEnchantedAdaman" },
				{ "BlacksmithingPlateKhoriumWard" },
				{ "BlacksmithingPlateFaithFelsteel" },
				{ "BlacksmithingPlateBurningRage" },
				{ "BlacksmithingPlateOrnateSaroniteBattlegear" },
				{ "BlacksmithingPlateSavageSaroniteBattlegear" },
			},
			["Info"] = { BLACKSMITHING..": "..BabbleInventory["Plate"], "AtlasLootCrafting"},
		},

		["LeatherworkingLeather"] = {
			["Bosses"] = {
				{ "LeatherworkingLeatherVolcanicArmor" },
				{ "LeatherworkingLeatherIronfeatherArmor" },
				{ "LeatherworkingLeatherStormshroudArmor" },
				{ "LeatherworkingLeatherDevilsaurArmor" },
				{ "LeatherworkingLeatherBloodTigerH" },
				{ "LeatherworkingLeatherPrimalBatskin" },
				{ "LeatherworkingLeatherWildDraenishA" },
				{ "LeatherworkingLeatherThickDraenicA" },
				{ "LeatherworkingLeatherFelSkin" },
				{ "LeatherworkingLeatherSClefthoof" },
				{ "LeatherworkingLeatherPrimalIntent" },
				{ "LeatherworkingLeatherWindhawkArmor" },
				{ "LeatherworkingLeatherBoreanEmbrace" },
				{ "LeatherworkingLeatherIceborneEmbrace" },
				{ "LeatherworkingLeatherEvisceratorBattlegear" },
				{ "LeatherworkingLeatherOvercasterBattlegear" },
			},
			["Info"] = { LEATHERWORKING..": "..BabbleInventory["Leather"], "AtlasLootCrafting"},
		},

		["LeatherworkingMail"] = {
			["Bosses"] = {
				{ "LeatherworkingMailGreenDragonM" },
				{ "LeatherworkingMailBlueDragonM" },
				{ "LeatherworkingMailBlackDragonM" },
				{ "LeatherworkingMailScaledDraenicA" },
				{ "LeatherworkingMailFelscaleArmor" },
				{ "LeatherworkingMailFelstalkerArmor" },
				{ "LeatherworkingMailNetherFury" },
				{ "LeatherworkingMailNetherscaleArmor" },
				{ "LeatherworkingMailNetherstrikeArmor" },
				{ "LeatherworkingMailFrostscaleBinding" },
				{ "LeatherworkingMailNerubianHive" },
				{ "LeatherworkingMailStormhideBattlegear" },
				{ "LeatherworkingMailSwiftarrowBattlefear" },
			},
			["Info"] = { LEATHERWORKING..": "..BabbleInventory["Mail"], "AtlasLootCrafting"},
		},

		["TailoringSets"] = {
			["Bosses"] = {
				{ "TailoringBloodvineG" },
				{ "TailoringNeatherVest" },
				{ "TailoringImbuedNeather" },
				{ "TailoringArcanoVest" },
				{ "TailoringTheUnyielding" },
				{ "TailoringWhitemendWis" },
				{ "TailoringSpellstrikeInfu" },
				{ "TailoringBattlecastG" },
				{ "TailoringSoulclothEm" },
				{ "TailoringPrimalMoon" },
				{ "TailoringShadowEmbrace" },
				{ "TailoringSpellfireWrath" },
				{ "TailoringFrostwovenPower" },
				{ "TailoringDuskweaver" },
				{ "TailoringFrostsavageBattlegear" },
			},
			["Info"] = { TAILORING..": "..BabbleInventory["Cloth"], "AtlasLootCrafting"},
		},
	},

	["Misc"] = {
		["Pets"] = {
			["Bosses"] = {
				{ "PetsMerchant" },
				{ "PetsQuest" },
				{ "PetsCrafted" },
				{ "PetsAchievementFaction" },
				{ "PetsRare" },
				{ "PetsEvent" },
				{ "PetsPromotional" },
				{ "PetsCardGame" },
				{ "PetsPetStore" },
				{ "PetsRemoved" },
				{ "PetsAccessories" },
			},
			["Info"] = { BabbleInventory["Companions"], "AtlasLootCataclysm"},
		},

		["Mounts"] = {
			["Bosses"] = {
				{ "MountsFaction" },
				{ "MountsPvP" },
				{ "MountsRareDungeon" },
				{ "MountsRareRaid" },
				{ "MountsAchievement" },
				{ "MountsCraftQuest" },
				{ "MountsCardGamePromotional" },
				{ "MountsEvent" },
				{ "MountsRemoved" },
			},
			["Info"] = { BabbleInventory["Mounts"], "AtlasLootCataclysm"},
		},

		["Tabards"] = {
			["Bosses"] = {
				{ "TabardsAlliance" },
				{ "TabardsHorde" },
				{ "TabardsAchievementQuestRareMisc" },
				{ "TabardsRemoved" },
			},
			["Info"] = { BabbleInventory["Tabards"], "AtlasLootCataclysm"},
		},
		
		["TransformationItems"] = {
			["Bosses"] = {
				{ "TransformationNonconsumedItems" },
				{ "TransformationConsumableItems" },
				{ "TransformationAdditionalEffects" },
			},
			["Info"] = { AL["Transformation Items"], "AtlasLootCataclysm"},
		},
		
		["WorldEpics"] = {
			["Bosses"] = {
				{ "WorldEpics85" },
				{ "WorldEpics80" },
				{ "WorldEpics70" },
				{ "WorldEpics5060" },
				{ "WorldEpics4049" },
				{ "WorldEpics3039" },
			},
			["Info"] = { AL["BoE World Epics"], "AtlasLootWotLK"},
		},
	},

	["PVP"] = {
		["AlteracValley"] = {
			["Bosses"] = {
				{ "AVMisc" },
				{ "AVBlue" },
			},
			["Info"] = { BabbleZone["Alterac Valley"].." "..AL["Rewards"], "AtlasLootClassicWoW"},
		},

		["WarsongGulch"] = {
			["Bosses"] = {
				{ "WSGMisc", 6 },
				{ "WSGAccessories", 7 },
				{ "WSGWeapons", 8 },
				{ "WSGArmor", 10 },
			},
			["Info"] = { BabbleZone["Warsong Gulch"].." "..AL["Rewards"], "AtlasLootClassicWoW"},
		},
	},

	["Sets"] = {
		["EmblemofTriumph"] = {
			["Bosses"] = {
				{ "EmblemofTriumph" },
				{ "EmblemofTriumph2" },
			},
			["Info"] = { AL["ilvl 245"].." - "..AL["Rewards"], "AtlasLootWotLK"},
		},
	},	
}

AtlasLoot_LootTableRegister["Instances"]["EmptyPage"] = {
	["Bosses"] = {{"EmptyPage"}},
	["Info"] = { "EmptyPage" },
}

AtlasLoot_Data["EmptyPage"] = {
	["Normal"] = {{}};
	info = {
		name = "EmptyPage",
		instance = "EmptyPage",
	};
}