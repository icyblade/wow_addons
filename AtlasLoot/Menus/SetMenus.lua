-- $Id: SetMenus.lua 3697 2012-01-31 15:17:37Z lag123 $
local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");
local BabbleBoss = AtlasLoot_GetLocaleLibBabble("LibBabble-Boss-3.0")
local BabbleFaction = AtlasLoot_GetLocaleLibBabble("LibBabble-Faction-3.0")
local BabbleInventory = AtlasLoot_GetLocaleLibBabble("LibBabble-Inventory-3.0")
local BabbleItemSet = AtlasLoot_GetLocaleLibBabble("LibBabble-ItemSet-3.0")
local BabbleZone = AtlasLoot_GetLocaleLibBabble("LibBabble-Zone-3.0")


	AtlasLoot_Data["SETMENU"] = {
		["Normal"] = {
			{
				{ 1, "VALORPOINTSMENU", "inv_misc_cape_cataclysm_tank_d_01", "=ds="..AL["Valor Points"].." "..AL["Rewards"], "=q5="..AL["Cataclysm"]};
				{ 2, "JUSTICEPOINTSMENU", "inv_misc_necklacea10", "=ds="..AL["Justice Points"].." "..AL["Rewards"], "=q5="..AL["Cataclysm"]};
				{ 4, "WOTLKEMBLEMMENU", "inv_misc_frostemblem_01", "=ds="..AL["Justice Points"].." "..AL["Rewards"], "=q5="..AL["Wrath of the Lich King"]};
				{ 5, "70TOKENMENU", "inv_valentineperfumebottle", "=ds="..AL["Justice Points"].." "..AL["Rewards"], "=q5="..AL["Burning Crusade"]};
				{ 7, "WORLDEPICS", "INV_Sword_76", "=ds="..AL["BoE World Epics"], ""};
				{ 8, "Legendaries", "inv_hammer_unique_sulfuras", "=ds="..AL["Legendary Items"], ""};
				{ 9, "MOUNTMENU", "ability_hunter_pet_dragonhawk", "=ds="..BabbleInventory["Mounts"], ""};
				{ 10, "PETMENU", "INV_Box_PetCarrier_01", "=ds="..BabbleInventory["Companions"], ""};
				{ 11, "TABARDMENU", "inv_chest_cloth_30", "=ds="..BabbleInventory["Tabards"], ""};
				{ 12, "TRANSFORMATIONMENU", "inv_misc_orb_03", "=ds="..AL["Transformation Items"], ""};
				{ 13, "CardGame", "inv_misc_ogrepinata", "=ds="..AL["TCG Items"], ""};
				{ 16, "MoltenFront", "inv_neck_hyjaldaily_04", "=ds="..BabbleZone["Molten Front"].." "..AL["Rewards"], ""};
				{ 17, "SETSMISCMENU", "inv_misc_monsterscales_15", "=ds="..AL["Misc Sets"], ""};
				{ 19, "Heirloom", "INV_Sword_43", "=ds="..AL["Heirloom"], "=q5="..AL["Level 80"]};
				{ 20, "Heirloom#3", "inv_helmet_04", "=ds="..AL["Heirloom"], "=q5="..AL["Level 85"]};
				{ 22, "T1T2T3SET", "INV_Pants_Mail_03", "=ds="..AL["Tier 1/2/3 Set"], "=q5="..AL["Classic WoW"]};
				{ 23, "T456SET", "INV_Gauntlets_63", "=ds="..AL["Tier 4/5/6 Set"], "=q5="..AL["Burning Crusade"]};
				{ 24, "T7T8SET", "INV_Chest_Chain_15", "=ds="..AL["Tier 7/8 Set"], "=q5="..AL["Wrath of the Lich King"]};
				{ 25, "T9SET", "inv_gauntlets_80", "=ds="..AL["Tier 9 Set"], "=q5="..AL["Wrath of the Lich King"]};
				{ 26, "T10SET", "inv_chest_plate_26", "=ds="..AL["Tier 10 Set"], "=q5="..AL["Wrath of the Lich King"]};
				{ 27, "T1112SET", "inv_helm_robe_raidmage_i_01", "=ds="..AL["Tier 11/12 Set"], "=q5="..AL["Cataclysm"]};
				{ 28, "T13SET", "inv_shoulder_plate_raiddeathknight_j_01", "=ds="..AL["Tier 13 Set"], "=q5="..AL["Cataclysm"]};
				--{ 30, "43MENU", "inv_misc_monsterscales_15", "=ds=Patch 4.3 Stuff", ""};
			};
		};
		info = {
			name = AL["Collections"],
		};
	}

	AtlasLoot_Data["VALORPOINTSMENU"] = {
		["Normal"] = {
			{
				{ 2, "ValorPoints", "inv_helmet_robe_raidwarlock_k_01", "=ds="..BabbleInventory["Cloth"], ""};
				{ 3, "ValorPoints#2", "inv_chest_mail_raidhunter_k_01", "=ds="..BabbleInventory["Mail"], ""};
				{ 5, "ValorPoints#4", "inv_qiraj_jewelengraved", "=ds="..AL["Accessories"], ""};
    			{ 7, 77087, "", "=q4=Darting Chakram", "=ds=#w11#", "#VALOR:700#" },
    			{ 8, 77085, "", "=q4=Unexpected Backup", "=ds=#w11#", "#VALOR:700#" },
    			{ 9, 77086, "", "=q4=Windslicer Boomerang", "=ds=#w11#", "#VALOR:700#" },
				{ 17, "ValorPoints", "inv_gauntlets_leather_raidrogue_k_01", "=ds="..BabbleInventory["Leather"], ""};
				{ 18, "ValorPoints#3", "plate_raiddeathknight_k_01_belt", "=ds="..BabbleInventory["Plate"], ""};
				{ 22, 77079, "", "=q4=Hungermouth Wand", "=ds=#w12#", "#VALOR:700#" },
    			{ 23, 77078, "", "=q4=Scintillating Rods", "=ds=#w12#", "#VALOR:700#" },
			};
		};
		info = {
			name = AL["Valor Points"].." "..AL["Rewards"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["JUSTICEPOINTSMENU"] = {
		["Normal"] = {
			{
				{ 2, "JusticePoints", "inv_chest_robe_dungeonrobe_c_04", "=ds="..BabbleInventory["Cloth"], ""};
				{ 3, "JusticePoints#3", "inv_chest_mail_dungeonmail_c_04", "=ds="..BabbleInventory["Mail"], ""};
				{ 5, "JusticePoints#5", "inv_misc_forestnecklace", "=ds="..AL["Accessories"], ""};
				{ 7, 52722, "", "=q4=Maelstrom Crystal", "", "#JUSTICE:3750#" },
				{ 8, 68813, "", "=q3=Satchel of Freshly-Picked Herbs", "", "#JUSTICE:1500#" },
				{ 9, 53010, "", "=q1=Embersilk Cloth", "", "#JUSTICE:1250#" },
				{ 10, 52185, "", "=q1=Elementium Ore", "", "#JUSTICE:1000#" },
				{ 17, "JusticePoints#2", "inv_helmet_193", "=ds="..BabbleInventory["Leather"], ""};
				{ 18, "JusticePoints#4", "inv_gauntlets_plate_dungeonplate_c_04", "=ds="..BabbleInventory["Plate"], ""};
				{ 20, "JusticePoints#7", "inv_misc_greateressence", "=ds="..AL["Weapons"], ""};
				{ 22, 52721, "", "=q3=Heavenly Shard", "", "#JUSTICE:600#" },
				{ 23, 52719, "", "=q2=Greater Celestial Essence", "", "#JUSTICE:400#" },
				{ 24, 52976, "", "=q1=Savage Leather", "", "#JUSTICE:375#" },
				{ 25, 52555, "", "=q1=Hypnotic Dust", "", "#JUSTICE:100#" },
			};
		};
		info = {
			name = AL["Justice Points"].." "..AL["Rewards"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["WOTLKEMBLEMMENU"] = {
		["Normal"] = {
			{
				{ 2, "EmblemofFrost", "inv_misc_frostemblem_01", "=ds="..AL["ilvl 264"], "=q5="..BabbleInventory["Armor"].." & "..AL["Weapons"]};
				{ 4, "EmblemofTriumph", "spell_holy_summonchampion", "=ds="..AL["ilvl 245"], "=q5="..BabbleInventory["Armor"]};
				{ 5, "EmblemofTriumph2", "spell_holy_summonchampion", "=ds="..AL["ilvl 245"], "=q5="..AL["Accessories"].." & "..AL["Weapons"]};
				{ 7, "EmblemofConquest", "Spell_Holy_ChampionsGrace", "=ds="..AL["ilvl 226"], "=q5="..BabbleInventory["Armor"]};
				{ 9, "EmblemofValor", "Spell_Holy_ProclaimChampion_02", "=ds="..AL["ilvl 213"], "=q5="..BabbleInventory["Armor"]};
				{ 11, "EmblemofHeroism", "Spell_Holy_ProclaimChampion", "=ds="..AL["ilvl 200"], "=q5="..BabbleInventory["Armor"].." & "..AL["Weapons"]};
				{ 12, "EmblemofHeroism#3", "Spell_Holy_ProclaimChampion", "=ds="..AL["ilvl 200"], "=q5="..BabbleInventory["Miscellaneous"]};
				{ 14, "PVP80SET", "INV_Boots_01", "=ds="..AL["PvP Armor Sets"], "=q5="..AL["Level 80"]};
				{ 17, "T10SET", "inv_misc_frostemblem_01", "=ds="..AL["Tier 10 Set"], "=q5="..AL["10/25 Man"]};
				{ 19, "T9SET", "spell_holy_summonchampion", "=ds="..AL["Tier 9 Set"], "=q5="..AL["10/25 Man"]};
				{ 22, "EmblemofConquest#2", "Spell_Holy_ChampionsGrace", "=ds="..AL["ilvl 226"], "=q5="..AL["Accessories"]};
				{ 24, "EmblemofValor#2", "Spell_Holy_ProclaimChampion_02", "=ds="..AL["ilvl 213"], "=q5="..AL["Accessories"]};
				{ 26, "EmblemofHeroism#2", "Spell_Holy_ProclaimChampion", "=ds="..AL["ilvl 200"], "=q5="..AL["Accessories"]};
			};
		};
		info = {
			name = AL["Justice Points"].." "..AL["Rewards"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["70TOKENMENU"] = {
		["Normal"] = {
			{
				{ 2, "HardModeCloth", "inv_pants_cloth_15", "=ds="..BabbleInventory["Cloth"], ""};
				{ 3, "HardModeMail", "inv_pants_mail_26", "=ds="..BabbleInventory["Mail"], ""};
				{ 4, "HardModeResist", "inv_chest_cloth_18", "=ds="..AL["Fire Resistance Gear"], ""};
				{ 6, "HardModeRelic", "spell_nature_sentinal", "=ds="..BabbleInventory["Relic"], ""};
				{ 8, "HardModeWeapons", "inv_shield_33", "=ds="..AL["Weapons"], ""};
				{ 17, "HardModeLeather", "inv_shoulder_83", "=ds="..BabbleInventory["Leather"], ""};
				{ 18, "HardModePlate", "inv_belt_27", "=ds="..BabbleInventory["Plate"], ""};
				{ 19, "HardModeCloaks", "inv_misc_cape_06", "=ds="..BabbleInventory["Back"], ""};
				{ 21, "HardModeArena", "inv_bracer_07", "=ds="..AL["PvP Rewards"], ""};
				{ 23, "HardModeAccessories", "inv_valentineperfumebottle", "=ds="..AL["Accessories"], ""};
			};
		};
		info = {
			name = AL["Justice Points"].." "..AL["Rewards"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["WORLDEPICS"] = {
		["Normal"] = {
			{
				{ 2, "WorldEpics85", "inv_misc_cape_cataclysm_caster_c_01", "=ds="..AL["Level 85"], ""};
				{ 3, "WorldEpics70", "INV_Sword_76", "=ds="..AL["Level 70"], ""};
				{ 4, "WorldEpics4049", "INV_Staff_29", "=ds="..AL["Level 40-49"], ""};
				{ 17, "WorldEpics80", "INV_Sword_109", "=ds="..AL["Level 80"], ""};
				{ 18, "WorldEpics5060", "INV_Jewelry_Amulet_01", "=ds="..AL["Level 50-60"], ""};
				{ 19, "WorldEpics3039", "INV_Jewelry_Ring_15", "=ds="..AL["Level 30-39"], ""};
			};
		};
		info = {
			name = AL["BoE World Epics"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["MOUNTMENU"] = {
		["Normal"] = {
			{
				{ 2, "MountsAlliance", "achievement_pvp_a_16", "=ds="..BabbleFaction["Darnassus"].." / "..BabbleFaction["Gnomeregan"], "=ec1="..AL["Alliance Mounts"]};
				{ 3, "MountsAlliance#2", "achievement_pvp_a_16", "=ds="..BabbleFaction["Ironforge"].." / "..BabbleFaction["Exodar"].." / "..BabbleFaction["Stormwind"], "=ec1="..AL["Alliance Mounts"]};
				{ 4, "MountsAlliance#3", "achievement_pvp_a_16", "=ds="..AL["Alliance Flying Mounts"].." / "..BabbleFaction["Kurenai"], "=ec1="..AL["Alliance Mounts"]};
				{ 5, "MountsAlliance#4", "achievement_pvp_a_16", "=ds="..BabbleZone["Dalaran"].." / "..AL["Misc"], "=ec1="..AL["Alliance Mounts"]};
				{ 7, "MountsFaction", "ability_mount_warhippogryph", "=ds="..AL["Neutral Faction Mounts"], ""};
				{ 8, "MountsRareDungeon", "ability_mount_drake_bronze", "=ds="..AL["Rare Mounts"], "=ec1="..AL["Dungeon"].." / "..AL["Outdoor"]};
				{ 9, "MountsCraftQuest", "ability_mount_gyrocoptorelite", "=ds="..BabbleInventory["Quest"].." / "..AL["Crafted Mounts"], ""};
				{ 10, "MountsEvent", "achievement_halloween_witch_01", "=ds="..AL["World Events"], ""};
				{ 17, "MountsHorde", "achievement_pvp_h_16", "=ds="..BabbleFaction["Orgrimmar"].." / "..BabbleFaction["Silvermoon City"], "=ec1="..AL["Horde Mounts"]};
				{ 18, "MountsHorde#2", "achievement_pvp_h_16", "=ds="..BabbleFaction["Darkspear Trolls"].." / "..BabbleFaction["Thunder Bluff"].." / "..BabbleFaction["Undercity"], "=ec1="..AL["Horde Mounts"]};
				{ 19, "MountsHorde#3", "achievement_pvp_h_16", "=ds="..AL["Horde Flying Mounts"].." / "..BabbleFaction["The Mag'har"], "=ec1="..AL["Horde Mounts"]};
				{ 20, "MountsHorde#4", "achievement_pvp_h_16", "=ds="..BabbleZone["Dalaran"].." / "..AL["Misc"], "=ec1="..AL["Horde Mounts"]};
				{ 22, "MountsPvP", "ability_mount_netherdrakeelite", "=ds="..AL["PvP Mounts"], ""};
				{ 23, "MountsRareRaid", "inv_misc_summerfest_brazierorange", "=ds="..AL["Rare Mounts"], "=ec1="..AL["Raid"]};
				{ 24, "MountsAchievement", "inv_mount_allianceliong", "=ds="..AL["Achievement Reward"], ""};
				{ 25, "MountsCardGamePromotional", "ability_mount_bigblizzardbear", "=ds="..AL["Promotional & Card Game"], ""};
				{ 26, "MountsRemoved", "INV_Misc_QirajiCrystal_05", "=ds="..AL["Unobtainable Mounts"], ""};
			};
		};
		info = {
			name = BabbleInventory["Mounts"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["PETMENU"] = {
		["Normal"] = {
			{
				{ 2, "PetsMerchant", "spell_nature_polymorph", "=ds="..AL["Merchant Sold Companions"], ""};
				{ 3, "PetsCrafted", "inv_drink_19", "=ds="..AL["Crafted Companions"], ""};
				{ 4, "PetsRare", "spell_shaman_hex", "=ds="..AL["Rare Companions"], ""};
				{ 5, "PetsPromotional", "inv_netherwhelp", "=ds="..AL["Promotional Companions"], ""};
				{ 6, "PetsPetStore", "INV_Misc_Coin_01", "=ds="..AL["Blizzard Store"], ""};
				{ 7, "PetsRemoved", "inv_pet_babyblizzardbear", "=ds="..AL["Unobtainable Companions"], ""};
				{ 17, "PetsQuest", "inv_drink_19", "=ds="..AL["Quest Reward Companions"], ""};
				{ 18, "PetsAchievementFaction", "spell_shaman_hex", "=ds="..AL["Achievement & Faction Reward"], ""};
				{ 19, "PetsEvent", "inv_pet_egbert", "=ds="..AL["World Events"], ""};
				{ 20, "PetsCardGame", "inv_netherwhelp", "=ds="..AL["Card Game Companions"], ""};
				{ 21, "PetsAccessories", "inv_misc_petbiscuit_01", "=ds="..AL["Companion Accessories"], ""};
			};
		};
		info = {
			name = BabbleInventory["Companions"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["TABARDMENU"] = {
		["Normal"] = {
			{
				{ 1, "TabardsAlliance", "achievement_pvp_a_16", "=ds="..AL["Alliance Tabards"], ""};
				{ 2, "TabardsRemoved", "INV_Jewelry_Ring_15", "=ds="..AL["Unobtainable Tabards"], ""};
				{ 4, 65904, "", "=q1=Tabard of Ramkahen", "=ds=#s7#"};
				{ 5, 65909, "", "=q1=Tabard of the Dragonmaw Clan", "=ds=#s7#"};
				{ 6, 65905, "", "=q1=Tabard of the Earthen Ring", "=ds=#s7#"};
				{ 7, 65906, "", "=q1=Tabard of the Guardians of Hyjal", "=ds=#s7#"};
				{ 8, 65907, "", "=q1=Tabard of Therazane", "=ds=#s7#"};
				{ 9, 65908, "", "=q1=Tabard of the Wildhammer Clan", "=ds=#s7#"};
				{ 11, 46874, "", "=q3=Argent Crusader's Tabard", "=ds=#s7#"};
				{ 12, 43154, "", "=q1=Tabard of the Argent Crusade", "=ds=#s7#"};
				{ 13, 43155, "", "=q1=Tabard of the Ebon Blade", "=ds=#s7#"};
				{ 14, 43157, "", "=q1=Tabard of the Kirin Tor", "=ds=#s7#"};
				{ 15, 43156, "", "=q1=Tabard of the Wyrmrest Accord", "=ds=#s7#"};
				{ 16, "TabardsHorde", "achievement_pvp_h_16", "=ds="..AL["Horde Tabards"], ""};
				{ 17, "TabardsAchievementQuestRareMisc", "inv_shirt_guildtabard_01", "=ds="..AL["Achievement & Quest Reward Tabards"], ""};
				{ 19, 31779, "", "=q1=Aldor Tabard", "=ds=#s7#"};
				{ 20, 31804, "", "=q1=Cenarion Expedition Tabard", "=ds=#s7#"};
				{ 21, 31776, "", "=q1=Consortium Tabard", "=ds=#s7#"};
				{ 22, 31777, "", "=q1=Keepers of Time Tabard", "=ds=#s7#"};
				{ 23, 31778, "", "=q1=Lower City Tabard", "=ds=#s7#"};
				{ 24, 32828, "", "=q1=Ogri'la Tabard", "=ds=#s7#"};
				{ 25, 31781, "", "=q1=Sha'tar Tabard", "=ds=#s7#"};
				{ 26, 31775, "", "=q1=Sporeggar Tabard", "=ds=#s7#"};
				{ 27, 31780, "", "=q1=Scryers Tabard", "=ds=#s7#"};
				{ 28, 32445, "", "=q1=Skyguard Tabard", "=ds=#s7#"};
				{ 29, 35221, "", "=q1=Tabard of the Shattered Sun", "=ds=#s7#"};
			};
		};
		info = {
			name = BabbleInventory["Tabards"],
			menu = "SETMENU",
		};
	}
	
	AtlasLoot_Data["TRANSFORMATIONMENU"] = {
		["Normal"] = {
			{
				{ 2, "TransformationNonconsumedItems", "inv_misc_orb_02", "=ds="..AL["Non-consumed Transformation Items"], ""};
				{ 4, "TransformationAdditionalEffects", "stave_2h_tarecgosa_e_01stagefinal", "=ds="..AL["Additional Effects Transformation Items"]};
				{ 17, "TransformationConsumableItems", "inv_misc_monsterhead_04", "=ds="..AL["Consumable Transformation Items"], ""};
			};
		};
		info = {
			name = AL["Transformation Items"],
			menu = "SETMENU",
		};
	}	
	
	AtlasLoot_Data["SETSMISCMENU"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..BabbleItemSet["Jaws of Retribution"], "=q1="..BabbleZone["Dragon Soul"]};
				{ 2, 77945, "", "=q4=Fear", "=ds=#h3#, #w4#", "" };
				{ 3, 77946, "", "=q4=Vengeance", "=ds=#h4#, #w4#", "" };
				{ 5, 0, "INV_Box_01", "=q6="..BabbleItemSet["Maw of Oblivion"], "=q1="..BabbleZone["Dragon Soul"]};
				{ 6, 77947, "", "=q4=The Sleeper", "=ds=#h3#, #w4#", "" };
				{ 7, 77948, "", "=q4=The Dreamer", "=ds=#h4#, #w4#", "" };
				{ 9, "AQ20Sets", "achievement_boss_ossiriantheunscarred", "=ds="..BabbleZone["Ruins of Ahn'Qiraj"].." "..AL["Set"], "=q5="..AL["Classic WoW"]};
				{ 11, "T0SET", "INV_Chest_Chain_03", "=ds="..AL["Dungeon Set 1/2"], "=q5="..AL["No Longer Available"]};
				--{ 13, "DS4Cloth", "INV_Helmet_15", "=ds="..AL["Dungeon Set 4"], "=q5="..BabbleInventory["Cloth"]};
				--{ 14, "DS4Mail", "INV_Helmet_15", "=ds="..AL["Dungeon Set 4"], "=q5="..BabbleInventory["Mail"]};
				{ 16, 0, "INV_Box_01", "=q6="..BabbleItemSet["Fangs of the Father"], "=q1="..BabbleZone["Dragon Soul"]};
				{ 17, 77949, "", "=q5=Golad, Twilight of Aspects", "=ds=#h3#, #w4#", "" };
				{ 18, 77950, "", "=q5=Tiriosh, Nightmare of Ages", "=ds=#h4#, #w4#", "" };
				{ 20, "SETSCLASSIC", "INV_Sword_43", "=ds="..AL["Classic WoW"].." "..AL["Sets"], ""};
				{ 21, "TBCSets", "INV_Weapon_Glave_01", "=ds="..AL["Burning Crusade"].." "..AL["Sets"], ""};
				{ 22, "WOTLKSets", "inv_misc_monsterscales_15", "=ds="..AL["Wrath of the Lich King"].." "..AL["Sets"], ""};
				{ 24, "AQ40Sets", "achievement_boss_cthun", "=ds="..BabbleZone["Temple of Ahn'Qiraj"].." "..AL["Set"], "=q5="..AL["Classic WoW"]};
				{ 26, "DS3SET", "INV_Helmet_15", "=ds="..AL["Dungeon Set 3"], "=q5="..AL["Burning Crusade"]};
				--{ 28, "DS4Leather", "INV_Helmet_15", "=ds="..AL["Dungeon Set 4"], "=q5="..BabbleInventory["Leather"]};
				--{ 29, "DS4Plate", "INV_Helmet_15", "=ds="..AL["Dungeon Set 4"], "=q5="..BabbleInventory["Plate"]};
			};
		};
		info = {
			name = AL["Misc Sets"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["SETSCLASSIC"] = {
		["Normal"] = {
			{
				{ 2, "VWOWSets#1", "INV_Pants_12", "=ds="..BabbleItemSet["Defias Leather"], "=q5="..BabbleZone["The Deadmines"]};
				{ 3, "VWOWSets#1", "INV_Shirt_16", "=ds="..BabbleItemSet["Embrace of the Viper"], "=q5="..BabbleZone["Wailing Caverns"]};
				{ 4, "VWOWSets#1", "INV_Gauntlets_19", "=ds="..BabbleItemSet["Chain of the Scarlet Crusade"], "=q5="..BabbleZone["Scarlet Monastery"]};
				{ 5, "VWOWSets#1", "INV_Helmet_01", "=ds="..BabbleItemSet["The Gladiator"], "=q5="..BabbleZone["Blackrock Depths"]};
				{ 6, "VWOWSets#2", "INV_Boots_Cloth_05", "=ds="..BabbleItemSet["Ironweave Battlesuit"], "=q5="..AL["Various Locations"]};
				{ 7, "VWOWSets#2", "INV_Boots_02", "=ds="..BabbleItemSet["The Postmaster"], "=q5="..BabbleZone["Stratholme"]};
				{ 8, "VWOWScholo", "INV_Shoulder_02", "=ds="..BabbleItemSet["Necropile Raiment"], "=q5="..BabbleZone["Scholomance"]};
				{ 17, "VWOWScholo", "INV_Belt_16", "=ds="..BabbleItemSet["Cadaverous Garb"], "=q5="..BabbleZone["Scholomance"]};
				{ 18, "VWOWScholo", "INV_Gauntlets_26", "=ds="..BabbleItemSet["Bloodmail Regalia"], "=q5="..BabbleZone["Scholomance"]};
				{ 19, "VWOWScholo", "INV_Belt_12", "=ds="..BabbleItemSet["Deathbone Guardian"], "=q5="..BabbleZone["Scholomance"]};
				{ 20, "VWOWSets#3", "INV_Weapon_ShortBlade_16", "=ds="..BabbleItemSet["Spider's Kiss"], "=q5="..BabbleZone["Lower Blackrock Spire"]};
				{ 21, "VWOWSets#3", "INV_Sword_43", "=ds="..BabbleItemSet["Dal'Rend's Arms"], "=q5="..BabbleZone["Upper Blackrock Spire"]};
				{ 22, "VWOWSets#3", "INV_Misc_MonsterScales_15", "=ds="..BabbleItemSet["Shard of the Gods"], "=q5="..AL["Various Locations"]};
				{ 23, "VWOWSets#3", "INV_Misc_MonsterClaw_04", "=ds="..BabbleItemSet["Spirit of Eskhandar"], "=q5="..AL["Various Locations"]};
			};
		};
		info = {
			name = AL["Classic WoW"].." "..AL["Sets"],
			menu = "SETSMISCMENU",
		};
	}

	AtlasLoot_Data["T0SET"] = {
		["Normal"] = {
			{
				{ 3, "T0Druid", "ability_druid_maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], ""};
				{ 4, "T0Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 5, "T0Priest", "inv_staff_30", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], ""};
				{ 6, "T0Shaman", "spell_nature_bloodlust", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], ""};
				{ 7, "T0Warrior", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], ""};
				{ 18, "T0Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 19, "T0Paladin", "ability_thunderbolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], ""};
				{ 20, "T0Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 21, "T0Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
			};
		};
		info = {
			name = AL["Dungeon Set 1/2"],
			menu = "SETSMISCMENU",
		};
	}

	AtlasLoot_Data["DS3SET"] = {
		["Normal"] = {
			{
				{ 2, "DS3Cloth", "Spell_Holy_InnerFire", "=ds="..BabbleItemSet["Hallowed Raiment"], "=q5="..BabbleInventory["Cloth"]};
				{ 3, "DS3Cloth", "INV_Elemental_Mote_Nether", "=ds="..BabbleItemSet["Mana-Etched Regalia"], "=q5="..BabbleInventory["Cloth"]};
				{ 5, "DS3Leather", "Ability_Rogue_SinisterCalling", "=ds="..BabbleItemSet["Assassination Armor"], "=q5="..BabbleInventory["Leather"]};
				{ 6, "DS3Leather", "Ability_Hunter_RapidKilling", "=ds="..BabbleItemSet["Wastewalker Armor"], "=q5="..BabbleInventory["Leather"]};
				{ 8, "DS3Mail", "Ability_Hunter_Pet_Wolf", "=ds="..BabbleItemSet["Beast Lord Armor"], "=q5="..BabbleInventory["Mail"]};
				{ 9, "DS3Mail", "INV_Helmet_70", "=ds="..BabbleItemSet["Tidefury Raiment"], "=q5="..BabbleInventory["Mail"]};
				{ 11, "DS3Plate", "Spell_Fire_EnchantWeapon", "=ds="..BabbleItemSet["Bold Armor"], "=q5="..BabbleInventory["Plate"]};
				{ 12, "DS3Plate", "INV_Hammer_02", "=ds="..BabbleItemSet["Righteous Armor"], "=q5="..BabbleInventory["Plate"]};
				{ 17, "DS3Cloth", "Ability_Creature_Cursed_04", "=ds="..BabbleItemSet["Incanter's Regalia"], "=q5="..BabbleInventory["Cloth"]};
				{ 18, "DS3Cloth", "Ability_Creature_Cursed_03", "=ds="..BabbleItemSet["Oblivion Raiment"], "=q5="..BabbleInventory["Cloth"]};
				{ 20, "DS3Leather", "Spell_Holy_SealOfRighteousness", "=ds="..BabbleItemSet["Moonglade Raiment"], "=q5="..BabbleInventory["Leather"]};
				{ 23, "DS3Mail", "Ability_FiegnDead", "=ds="..BabbleItemSet["Desolation Battlegear"], "=q5="..BabbleInventory["Mail"]};
				{ 26, "DS3Plate", "INV_Helmet_08", "=ds="..BabbleItemSet["Doomplate Battlegear"], "=q5="..BabbleInventory["Plate"]};
			};
		};
		info = {
			name = AL["Dungeon Set 3"],
			menu = "SETSMISCMENU",
		};
	}

	AtlasLoot_Data["T1T2T3SET"] = {
		["Normal"] = {
			{
				{ 1, "T1T2Druid", "ability_druid_maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Tier 1/2 Set"]};
				{ 2, "T3Druid", "ability_druid_maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Tier 3 Set"]};
				{ 4, "T1T2Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], "=q5="..AL["Tier 1/2 Set"]};
				{ 5, "T3Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], "=q5="..AL["Tier 3 Set"]};
				{ 7, "T1T2Priest", "inv_staff_30", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Tier 1/2 Set"]};
				{ 8, "T3Priest", "inv_staff_30", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Tier 3 Set"]};
				{ 10, "T1T2Shaman", "spell_nature_bloodlust", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Tier 1/2 Set"]};
				{ 11, "T3Shaman", "spell_nature_bloodlust", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Tier 3 Set"]};
				{ 13, "T1T2Warrior", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["Tier 1/2 Set"]};
				{ 14, "T3Warrior", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["Tier 3 Set"]};
				{ 17, "T1T2Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], "=q5="..AL["Tier 1/2 Set"]};
				{ 18, "T3Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], "=q5="..AL["Tier 3 Set"]};
				{ 20, "T1T2Paladin", "ability_thunderbolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Tier 1/2 Set"]};
				{ 21, "T3Paladin", "ability_thunderbolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Tier 3 Set"]};
				{ 23, "T1T2Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], "=q5="..AL["Tier 1/2 Set"]};
				{ 24, "T3Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], "=q5="..AL["Tier 3 Set"]};
				{ 26, "T1T2Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], "=q5="..AL["Tier 1/2 Set"]};
				{ 27, "T3Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], "=q5="..AL["Tier 3 Set"]};
			};
		};
		info = {
			name = AL["Tier 1/2/3 Set"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["T456SET"] = {
		["Normal"] = {
			{
				{ 3, "T456DruidBalance", "spell_nature_starfall", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Balance"]};
				{ 4, "T456DruidFeral", "ability_racial_bearform", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Feral"]};
				{ 5, "T456DruidRestoration", "spell_nature_healingtouch", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Restoration"]};
				{ 7, "T456Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 9, "T456Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 11, "T456PaladinHoly", "Spell_Holy_HolyBolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Holy"]};
				{ 12, "T456PaladinProtection", "spell_holy_devotionaura", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Protection"]};
				{ 13, "T456PaladinRetribution", "Spell_Holy_AuraOfLight", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Retribution"]};
				{ 17, "T456PriestHoly", "spell_holy_guardianspirit", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Holy"]};
				{ 18, "T456PriestShadow", "spell_shadow_shadowwordpain", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Shadow"]};
				{ 20, "T456Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 22, "T456ShamanElemental", "Spell_Nature_Lightning", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Elemental"]};
				{ 23, "T456ShamanEnhancement", "spell_nature_lightningshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Enhancement"]};
				{ 24, "T456ShamanRestoration", "spell_nature_magicimmunity", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Restoration"]};
				{ 26, "T456Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 28, "T456WarriorFury", "ability_warrior_innerrage", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["DPS"]};
				{ 29, "T456WarriorProtection", "ability_warrior_defensivestance", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["Protection"]};
			};
		};
		info = {
			name = AL["Tier 4/5/6 Set"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["T7T8SET"] = {
		["Normal"] = {
			{
				{ 2, "NaxxDeathKnightDPS", "spell_deathknight_frostpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["DPS"]};
				{ 3, "NaxxDeathKnightTank", "spell_deathknight_bloodpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["Tanking"]};
				{ 5, "NaxxDruidBalance", "spell_nature_starfall", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Balance"]};
				{ 6, "NaxxDruidFeral", "ability_racial_bearform", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Feral"]};
				{ 7, "NaxxDruidRestoration", "spell_nature_healingtouch", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Restoration"]};
				{ 9, "NaxxHunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 11, "NaxxMage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 13, "NaxxPaladinHoly", "Spell_Holy_HolyBolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Holy"]};
				{ 14, "NaxxPaladinProtection", "spell_holy_devotionaura", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Protection"]};
				{ 15, "NaxxPaladinRetribution", "Spell_Holy_AuraOfLight", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Retribution"]};
				{ 17, "NaxxPriestHoly", "spell_holy_guardianspirit", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Holy"]};
				{ 18, "NaxxPriestShadow", "spell_shadow_shadowwordpain", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Shadow"]};
				{ 20, "NaxxRogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 22, "NaxxShamanElemental", "Spell_Nature_Lightning", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Elemental"]};
				{ 23, "NaxxShamanEnhancement", "spell_nature_lightningshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Enhancement"]};
				{ 24, "NaxxShamanRestoration", "spell_nature_magicimmunity", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Restoration"]};
				{ 26, "NaxxWarlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 28, "NaxxWarriorFury", "ability_warrior_innerrage", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["DPS"]};
				{ 29, "NaxxWarriorProtection", "ability_warrior_defensivestance", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["Protection"]};
			};
		};
		info = {
			name = AL["Tier 7/8 Set"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["T9SET"] = {
		["Normal"] = {
			{
				{ 2, "T9DeathKnightDPS", "spell_deathknight_frostpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["DPS"]};
				{ 3, "T9DeathKnightTank", "spell_deathknight_bloodpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["Tanking"]};
				{ 5, "T9DruidBalance", "spell_nature_starfall", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Balance"]};
				{ 6, "T9DruidFeral", "ability_racial_bearform", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Feral"]};
				{ 7, "T9DruidRestoration", "spell_nature_healingtouch", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Restoration"]};
				{ 9, "T9Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 11, "T9Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 13, "T9PaladinHoly", "Spell_Holy_HolyBolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Holy"]};
				{ 14, "T9PaladinProtection", "spell_holy_devotionaura", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Protection"]};
				{ 15, "T9PaladinRetribution", "Spell_Holy_AuraOfLight", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Retribution"]};
				{ 17, "T9PriestHoly", "spell_holy_guardianspirit", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Holy"]};
				{ 18, "T9PriestShadow", "spell_shadow_shadowwordpain", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Shadow"]};
				{ 20, "T9Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 22, "T9ShamanElemental", "Spell_Nature_Lightning", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Elemental"]};
				{ 23, "T9ShamanEnhancement", "spell_nature_lightningshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Enhancement"]};
				{ 24, "T9ShamanRestoration", "spell_nature_magicimmunity", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Restoration"]};
				{ 26, "T9Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 28, "T9WarriorFury", "ability_warrior_innerrage", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["DPS"]};
				{ 29, "T9WarriorProtection", "ability_warrior_defensivestance", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["Protection"]};
			};
		};
		info = {
			name = AL["Tier 9 Set"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["T10SET"] = {
		["Normal"] = {
			{
				{ 2, "T10DeathKnightDPS", "spell_deathknight_frostpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["DPS"]};
				{ 3, "T10DeathKnightTank", "spell_deathknight_bloodpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["Tanking"]};
				{ 5, "T10DruidBalance", "spell_nature_starfall", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Balance"]};
				{ 6, "T10DruidFeral", "ability_racial_bearform", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Feral"]};
				{ 7, "T10DruidRestoration", "spell_nature_healingtouch", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Restoration"]};
				{ 9, "T10Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 11, "T10Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 13, "T10PaladinHoly", "Spell_Holy_HolyBolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Holy"]};
				{ 14, "T10PaladinProtection", "spell_holy_devotionaura", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Protection"]};
				{ 15, "T10PaladinRetribution", "Spell_Holy_AuraOfLight", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Retribution"]};
				{ 17, "T10PriestHoly", "spell_holy_guardianspirit", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Holy"]};
				{ 18, "T10PriestShadow", "spell_shadow_shadowwordpain", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Shadow"]};
				{ 20, "T10Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 22, "T10ShamanElemental", "Spell_Nature_Lightning", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Elemental"]};
				{ 23, "T10ShamanEnhancement", "spell_nature_lightningshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Enhancement"]};
				{ 24, "T10ShamanRestoration", "spell_nature_magicimmunity", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Restoration"]};
				{ 26, "T10Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 28, "T10WarriorFury", "ability_warrior_innerrage", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["DPS"]};
				{ 29, "T10WarriorProtection", "ability_warrior_defensivestance", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["Protection"]};
			};
		};
		info = {
			name = AL["Tier 10 Set"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["T1112SET"] = {
		["Normal"] = {
			{
				{ 2, "T1112DeathKnightDPS", "spell_deathknight_frostpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["DPS"]};
				{ 3, "T1112DeathKnightTank", "spell_deathknight_bloodpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["Tanking"]};
				{ 5, "T1112DruidBalance", "spell_nature_starfall", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Balance"]};
				{ 6, "T1112DruidFeral", "ability_racial_bearform", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Feral"]};
				{ 7, "T1112DruidRestoration", "spell_nature_healingtouch", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Restoration"]};
				{ 9, "T1112Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 11, "T1112Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 13, "T1112PaladinHoly", "Spell_Holy_HolyBolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Holy"]};
				{ 14, "T1112PaladinProtection", "spell_holy_devotionaura", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Protection"]};
				{ 15, "T1112PaladinRetribution", "Spell_Holy_AuraOfLight", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Retribution"]};
				{ 17, "T1112PriestHoly", "spell_holy_guardianspirit", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Holy"]};
				{ 18, "T1112PriestShadow", "spell_shadow_shadowwordpain", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Shadow"]};
				{ 20, "T1112Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 22, "T1112ShamanElemental", "Spell_Nature_Lightning", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Elemental"]};
				{ 23, "T1112ShamanEnhancement", "spell_nature_lightningshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Enhancement"]};
				{ 24, "T1112ShamanRestoration", "spell_nature_magicimmunity", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Restoration"]};
				{ 26, "T1112Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 28, "T1112WarriorFury", "ability_warrior_innerrage", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["DPS"]};
				{ 29, "T1112WarriorProtection", "ability_warrior_defensivestance", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["Protection"]};
			};
		};
		info = {
			name = AL["Tier 11/12 Set"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["T13SET"] = {
		["Normal"] = {
			{
				{ 2, "T13DeathKnightDPS", "spell_deathknight_frostpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["DPS"]};
				{ 3, "T13DeathKnightTank", "spell_deathknight_bloodpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["Tanking"]};
				{ 5, "T13DruidBalance", "spell_nature_starfall", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Balance"]};
				{ 6, "T13DruidFeral", "ability_racial_bearform", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Feral"]};
				{ 7, "T13DruidRestoration", "spell_nature_healingtouch", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Restoration"]};
				{ 9, "T13Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 11, "T13Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 13, "T13PaladinHoly", "Spell_Holy_HolyBolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Holy"]};
				{ 14, "T13PaladinProtection", "spell_holy_devotionaura", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Protection"]};
				{ 15, "T13PaladinRetribution", "Spell_Holy_AuraOfLight", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Retribution"]};
				{ 17, "T13PriestHoly", "spell_holy_guardianspirit", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Holy"]};
				{ 18, "T13PriestShadow", "spell_shadow_shadowwordpain", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Shadow"]};
				{ 20, "T13Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 22, "T13ShamanElemental", "Spell_Nature_Lightning", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Elemental"]};
				{ 23, "T13ShamanEnhancement", "spell_nature_lightningshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Enhancement"]};
				{ 24, "T13ShamanRestoration", "spell_nature_magicimmunity", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Restoration"]};
				{ 26, "T13Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 28, "T13WarriorFury", "ability_warrior_innerrage", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["DPS"]};
				{ 29, "T13WarriorProtection", "ability_warrior_defensivestance", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["Protection"]};
			};
		};
		info = {
			name = AL["Tier 13 Set"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["ARCHAVON"] = {
		["Normal"] = {
			{
				{ 2, "VoAArchavon", "spell_deathknight_classicon", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], ""};
				{ 3, "VoAArchavon#2", "ability_druid_maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], ""};
				{ 4, "VoAArchavon#3", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 5, "VoAArchavon#3", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 6, "VoAArchavon#4", "ability_thunderbolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], ""};
				{ 8, 43959, "", "=q4=Reins of the Grand Black War Mammoth", "=ds=#e26# =ec1=#m7#", "", ""};
				{ 17, "VoAArchavon#5", "inv_staff_30", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], ""};
				{ 18, "VoAArchavon#3", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 19, "VoAArchavon#6", "spell_nature_bloodlust", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], ""};
				{ 20, "VoAArchavon#7", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 21, "VoAArchavon#7", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], ""};
				{ 23, 44083, "", "=q4=Reins of the Grand Black War Mammoth", "=ds=#e26# =ec1=#m6#", "", ""};
			};
		};
		info = {
			name = BabbleBoss["Archavon the Stone Watcher"],
		};
	}

	AtlasLoot_Data["EMALON"] = {
		["Normal"] = {
			{
				{ 2, "VoAEmalon#5", "spell_deathknight_classicon", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], ""};
				{ 3, "VoAEmalon#2", "ability_druid_maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], ""};
				{ 4, "VoAEmalon", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 5, "VoAEmalon#3", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 6, "VoAEmalon#4", "ability_thunderbolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], ""};
				{ 8, "VoAEmalon#6", "INV_Boots_Cloth_12", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Cloth"]};
				{ 9, "VoAEmalon#7", "INV_Boots_Plate_06", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Mail"]};
				{ 10, "VoAEmalon#8", "inv_misc_cape_19", "=ds="..AL["PvP Non-Set Epics"], "=q5="..AL["Misc"]};
				{ 12, 43959, "", "=q4=Reins of the Grand Black War Mammoth", "=ds=#e26# =ec1=#m7#", "", ""};
				{ 17, "VoAEmalon", "inv_staff_30", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], ""};
				{ 18, "VoAEmalon#2", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 19, "VoAEmalon#3", "spell_nature_bloodlust", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], ""};
				{ 20, "VoAEmalon", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 21, "VoAEmalon#5", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], ""};
				{ 23, "VoAEmalon#6", "INV_Boots_08", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Leather"]};
				{ 24, "VoAEmalon#7", "INV_Boots_Plate_04", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Plate"]};
				{ 27, 44083, "", "=q4=Reins of the Grand Black War Mammoth", "=ds=#e26# =ec1=#m6#", "", ""};
			};
		};
		info = {
			name = BabbleBoss["Emalon the Storm Watcher"],
		};
	}

	AtlasLoot_Data["KORALON"] = {
		["Normal"] = {
			{
				{ 2, "VoAKoralon#5", "spell_deathknight_classicon", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], ""};
				{ 3, "VoAKoralon#2", "ability_druid_maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], ""};
				{ 4, "VoAKoralon", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 5, "VoAKoralon#3", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 6, "VoAKoralon#4", "ability_thunderbolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], ""};
				{ 8, "VoAKoralon#6", "INV_Boots_Cloth_12", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Cloth"]};
				{ 9, "VoAKoralon#7", "INV_Boots_Plate_06", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Mail"]};
				{ 10, "VoAKoralon#8", "inv_misc_cape_19", "=ds="..AL["PvP Non-Set Epics"], "=q5="..AL["Misc"]};
				{ 12, 43959, "", "=q4=Reins of the Grand Black War Mammoth", "=ds=#e26# =ec1=#m7#", "", ""};
				{ 17, "VoAKoralon", "inv_staff_30", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], ""};
				{ 18, "VoAKoralon#2", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 19, "VoAKoralon#3", "spell_nature_bloodlust", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], ""};
				{ 20, "VoAKoralon", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 21, "VoAKoralon#5", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], ""};
				{ 23, "VoAKoralon#6", "INV_Boots_08", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Leather"]};
				{ 24, "VoAKoralon#7", "INV_Boots_Plate_04", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Plate"]};
				{ 27, 44083, "", "=q4=Reins of the Grand Black War Mammoth", "=ds=#e26# =ec1=#m6#", "", ""};
			};
		};
		info = {
			name = BabbleBoss["Koralon the Flame Watcher"],
		};
	}

	AtlasLoot_Data["TORAVON"] = {
		["Normal"] = {
			{
				{ 2, "VoAToravon#5", "spell_deathknight_classicon", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], ""};
				{ 3, "VoAToravon#2", "ability_druid_maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], ""};
				{ 4, "VoAToravon", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 5, "VoAToravon#3", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 6, "VoAToravon#4", "ability_thunderbolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], ""};
				{ 8, "VoAToravon#6", "INV_Boots_Cloth_12", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Cloth"]};
				{ 9, "VoAToravon#7", "INV_Boots_Plate_06", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Mail"]};
				{ 10, "VoAToravon#8", "inv_misc_cape_19", "=ds="..AL["PvP Non-Set Epics"], "=q5="..AL["Misc"]};
				{ 12, 43959, "", "=q4=Reins of the Grand Black War Mammoth", "=ds=#e26# =ec1=#m7#", "", ""};
				{ 17, "VoAToravon", "inv_staff_30", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], ""};
				{ 18, "VoAToravon#2", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 19, "VoAToravon#3", "spell_nature_bloodlust", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], ""};
				{ 20, "VoAToravon", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 21, "VoAToravon#5", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], ""};
				{ 23, "VoAToravon#6", "INV_Boots_08", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Leather"]};
				{ 24, "VoAToravon#7", "INV_Boots_Plate_04", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Plate"]};
				{ 27, 44083, "", "=q4=Reins of the Grand Black War Mammoth", "=ds=#e26# =ec1=#m6#", "", ""};
			};
		};
		info = {
			name = BabbleBoss["Toravon the Ice Watcher"],
		};
	}

	AtlasLoot_Data["ARGALOTH"] = {
		["Normal"] = {
			{
				{ 2, "BHArgaloth#6", "spell_deathknight_classicon", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], ""};
				{ 3, "BHArgaloth", "ability_druid_maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], ""};
				{ 4, "BHArgaloth#2", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 5, "BHArgaloth#2", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 6, "BHArgaloth#3", "ability_thunderbolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], ""};
				{ 8, "BHArgaloth#7", "inv_bracer_mail_pvphunter_c_01", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Cloth"].." / "..BabbleInventory["Leather"]};
				{ 9, "BHArgaloth#9", "inv_jewelry_ring_80", "=ds="..AL["PvP Accessories"], "=q5="..AL["Level 85"]};
				{ 17, "BHArgaloth#4", "inv_staff_30", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], ""};
				{ 18, "BHArgaloth#2", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 19, "BHArgaloth#5", "spell_nature_bloodlust", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], ""};
				{ 20, "BHArgaloth#2", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 21, "BHArgaloth#6", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], ""};
				{ 23, "BHArgaloth#8", "inv_bracer_mail_pvphunter_c_01", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Mail"].." / "..BabbleInventory["Plate"]};
				{ 24, "BHArgaloth#10", "inv_misc_token_argentdawn3", "=ds="..AL["PvP Trinkets"], "=q5="..AL["Level 85"]};
			};
		};
		info = {
			name = BabbleBoss["Argaloth"],
		};
	}

	AtlasLoot_Data["OCCUTHAR"] = {
		["Normal"] = {
			{
				{ 2, "BHOccuthar#6", "spell_deathknight_classicon", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], ""};
				{ 3, "BHOccuthar", "ability_druid_maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], ""};
				{ 4, "BHOccuthar#2", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 5, "BHOccuthar#2", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 6, "BHOccuthar#3", "ability_thunderbolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], ""};
				{ 8, "BHOccuthar#7", "inv_bracer_mail_pvphunter_c_01", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Cloth"].." / "..BabbleInventory["Leather"]};
				{ 9, "BHOccuthar#9", "inv_jewelry_ring_80", "=ds="..AL["PvP Accessories"], "=q5="..AL["Level 85"]};
				{ 17, "BHOccuthar#4", "inv_staff_30", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], ""};
				{ 18, "BHOccuthar#2", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 19, "BHOccuthar#5", "spell_nature_bloodlust", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], ""};
				{ 20, "BHOccuthar#2", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 21, "BHOccuthar#6", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], ""};
				{ 23, "BHOccuthar#8", "inv_bracer_mail_pvphunter_c_01", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Mail"].." / "..BabbleInventory["Plate"]};
				{ 24, "BHOccuthar#10", "inv_misc_token_argentdawn3", "=ds="..AL["PvP Trinkets"], "=q5="..AL["Level 85"]};
			};
		};
		info = {
			name = BabbleBoss["Occu'thar"],
		};
	}

	AtlasLoot_Data["ALIZABAL"] = {
		["Normal"] = {
			{
				{ 2, "BHAlizabal#6", "spell_deathknight_classicon", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], ""};
				{ 3, "BHAlizabal", "ability_druid_maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], ""};
				{ 4, "BHAlizabal#2", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 5, "BHAlizabal#2", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 6, "BHAlizabal#3", "ability_thunderbolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], ""};
				{ 8, "BHAlizabal#7", "inv_bracer_mail_pvphunter_c_01", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Cloth"].." / "..BabbleInventory["Leather"]};
				{ 9, "BHAlizabal#9", "inv_jewelry_ring_80", "=ds="..AL["PvP Accessories"], "=q5="..AL["Level 85"]};
				{ 17, "BHAlizabal#4", "inv_staff_30", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], ""};
				{ 18, "BHAlizabal#2", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 19, "BHAlizabal#5", "spell_nature_bloodlust", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], ""};
				{ 20, "BHAlizabal#2", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 21, "BHAlizabal#6", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], ""};
				{ 23, "BHAlizabal#8", "inv_bracer_mail_pvphunter_c_01", "=ds="..AL["PvP Non-Set Epics"], "=q5="..BabbleInventory["Mail"].." / "..BabbleInventory["Plate"]};
				{ 24, "BHAlizabal#10", "inv_misc_token_argentdawn3", "=ds="..AL["PvP Trinkets"], "=q5="..AL["Level 85"]};
			};
		};
		info = {
			name = "Alizabal",
		};
	}

--[[	AtlasLoot_Data["43MENU"] = {
		["Normal"] = {
			{
				{ 2, "Pets43", "spell_nature_polymorph", "=ds=Patch 4.3 Companions", ""};
				{ 3, "Mounts43", "spell_nature_polymorph", "=ds=Patch 4.3 Mounts", ""};
				{ 17, "PVP85SET2", "inv_helm_plate_pvppaladin_c_01", "=ds="..AL["PvP Armor Sets"], "=q5="..AL["Level 85"]};
				{ 18, "PVP85Trinkets2", "inv_misc_token_argentdawn3", "=ds="..AL["PvP Trinkets"], "=q5="..AL["Level 85"]};
				{ 19, "PVP85Accessories2", "inv_jewelry_ring_80", "=ds="..AL["PvP Accessories"], "=q5="..AL["Level 85"]};
				{ 20, "PVP85NonSet2", "inv_bracer_mail_pvphunter_c_01", "=ds="..AL["PvP Non-Set Epics"], "=q5="..AL["Level 85"]};
				{ 21, "PVP85Weapons5", "inv_hand_1h_pvp400_c_01", "=ds="..AL["PvP Weapons"].. " - " ..AL["ilvl 397"], "=q5="..AL["Level 85"]};
				{ 22, "PVP85Weapons4", "inv_hand_1h_pvp400_c_01", "=ds="..AL["PvP Weapons"].. " - " ..AL["ilvl 410"], "=q5="..AL["Level 85"]};
			};
		};
		info = {
			name = "Patch 4.3 Stuff",
		};
	}]]--
--placeholder
	AtlasLoot_Data["PVP85SET2"] = {
		["Normal"] = {
			{
				{ 2, "PVP85DeathKnight2", "spell_deathknight_classicon", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], ""};
				{ 4, "PVP85DruidBalance2", "spell_nature_starfall", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Balance"]};
				{ 5, "PVP85DruidFeral2", "ability_racial_bearform", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Feral"]};
				{ 6, "PVP85DruidRestoration2", "spell_nature_healingtouch", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Restoration"]};
				{ 8, "PVP85Hunter2", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 10, "PVP85Mage2", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 12, "PVP85PaladinHoly2", "Spell_Holy_HolyBolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Holy"]};
				{ 13, "PVP85PaladinRetribution2", "Spell_Holy_AuraOfLight", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Retribution"]};
				{ 17, "PVP85PriestHoly2", "spell_holy_powerwordshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Discipline"]};
				{ 18, "PVP85PriestShadow2", "spell_shadow_shadowwordpain", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Shadow"]};
				{ 20, "PVP85Rogue2", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 22, "PVP85ShamanElemental2", "Spell_Nature_Lightning", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Elemental"]};
				{ 23, "PVP85ShamanEnhancement2", "spell_nature_lightningshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Enhancement"]};
				{ 24, "PVP85ShamanRestoration2", "spell_nature_magicimmunity", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Restoration"]};
				{ 26, "PVP85Warlock2", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 28, "PVP85Warrior2", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], ""};
			};
		};
		info = {
			name = AL["PvP Armor Sets"]..": "..AL["Level 85"],
			menu = "PVPMENU",
		};
	}