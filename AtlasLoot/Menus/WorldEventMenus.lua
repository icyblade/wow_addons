-- $Id: WorldEventMenus.lua 3697 2012-01-31 15:17:37Z lag123 $
local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");
local BabbleBoss = AtlasLoot_GetLocaleLibBabble("LibBabble-Boss-3.0")
local BabbleInventory = AtlasLoot_GetLocaleLibBabble("LibBabble-Inventory-3.0")
local BabbleFaction = AtlasLoot_GetLocaleLibBabble("LibBabble-Faction-3.0")
local BabbleZone = AtlasLoot_GetLocaleLibBabble("LibBabble-Zone-3.0")


	AtlasLoot_Data["WORLDEVENTMENU"] = {
		["Normal"] = {
			{
				{ 1, "ARGENTMENU", "Ability_Paladin_ArtofWar", "=ds="..AL["Argent Tournament"], "=q5="..BabbleZone["Icecrown"]};
				{ 3, "BREWFESTMENU", "achievement_worldevent_brewmaster", "=ds="..AL["Brewfest"], "=q5="..AL["Various Locations"]};
				{ 4, "DayoftheDead", "inv_misc_bone_humanskull_02", "=ds="..AL["Day of the Dead"], "=q5="..AL["Various Locations"]};
				{ 5, "HALLOWSENDMENU", "achievement_halloween_witch_01", "=ds="..AL["Hallow's End"], "=q5="..AL["Various Locations"]};
				{ 6, "Valentineday", "achievement_worldevent_valentine", "=ds="..AL["Love is in the Air"], "=q5="..AL["Various Locations"]};
				{ 7, "MidsummerFestival", "inv_summerfest_symbol_high", "=ds="..AL["Midsummer Fire Festival"], "=q5="..AL["Various Locations"]};
				{ 8, "PilgrimsBounty", "inv_thanksgiving_turkey", "=ds="..AL["Pilgrim's Bounty"], "=q5="..AL["Various Locations"]};
				{ 10, "BashirLanding", "INV_Trinket_Naxxramas02", "=ds="..AL["Bash'ir Landing Skyguard Raid"], "=q5="..BabbleZone["Blade's Edge Mountains"]};
				{ 11, "GurubashiArena", "inv_misc_armorkit_04", "=ds="..AL["Gurubashi Arena Booty Run"], "=q5="..BabbleZone["Stranglethorn Vale"]};
				{ 13, "ABYSSALMENU", "INV_Staff_13", "=ds="..AL["Abyssal Council"], "=q5="..BabbleZone["Silithus"]};
				{ 14, "SKETTISMENU", "Spell_Nature_NaturesWrath", "=ds="..AL["Skettis"], "=q5="..BabbleZone["Terokkar Forest"]};
				{ 16, "DARKMOONMENU", "INV_Misc_Ticket_Tarot_Madness", "=ds="..BabbleFaction["Darkmoon Faire"], "=q5="..AL["Various Locations"]};
				{ 18, "ChildrensWeek", "inv_misc_toy_04", "=ds="..AL["Children's Week"], "=q5="..AL["Various Locations"]};
				{ 19, "Winterviel", "achievement_worldevent_merrymaker", "=ds="..AL["Feast of Winter Veil"], "=q5="..AL["Various Locations"]};
				{ 20, "HarvestFestival", "INV_Misc_Food_33", "=ds="..AL["Harvest Festival"], "=q5="..AL["Various Locations"]};
				{ 21, "LunarFestival", "achievement_worldevent_lunar", "=ds="..AL["Lunar Festival"], "=q5="..AL["Various Locations"]};
				{ 22, "Noblegarden", "inv_egg_09", "=ds="..AL["Noblegarden"], "=q5="..AL["Various Locations"]};
				{ 25, "FishingExtravaganza", "inv_misc_fish_06", "=ds="..AL["Fishing Contests"], "=q5="..BabbleZone["Stranglethorn Vale"].." / "..BabbleZone["Northrend"]};
				{ 28, "ETHEREUMMENU", "INV_Misc_PunchCards_Prismatic", "=ds="..AL["Ethereum Prison"], ""};
			};
		};
		info = {
			name = AL["World Events"],
		};
	}

	AtlasLoot_Data["ARGENTMENU"] = {
		["Normal_A"] = {
			{
				{ 2, "ATArmor", "inv_boots_plate_09", "=ds="..BabbleInventory["Armor"].." / "..AL["Weapons"], ""};
				{ 3, "ATHeirlooms", "inv_jewelry_talisman_01", "=ds="..AL["Heirloom"], ""};
				{ 17, "ATPets", "achievement_reputation_argentchampion", "=ds="..BabbleInventory["Companions"]};
				{ 18, "ATMounts", "ability_mount_warhippogryph", "=ds="..BabbleInventory["Mounts"]};
				{ 5, 45714, "", "=q2=Darnassus Commendation Badge",  "", "=ds=#CHAMPWRIT:1#"};
				{ 6, 45715, "", "=q2=Exodar Commendation Badge", "",  "=ds=#CHAMPWRIT:1#"};
				{ 7, 45716, "", "=q2=Gnomeregan Commendation Badge", "",  "=ds=#CHAMPWRIT:1#"};
				{ 9, 46874, "", "=q3=Argent Crusader's Tabard", "=ds=#s7#", "#CHAMPSEAL:50#"};
				{ 10, 45579, "", "=q1=Darnassus Tabard", "=ds=#s7#", "#CHAMPSEAL:50#"};
				{ 11, 45580, "", "=q1=Exodar Tabard", "=ds=#s7#", "#CHAMPSEAL:50#"};
				{ 12, 45578, "", "=q1=Gnomeregan Tabard", "=ds=#s7#", "#CHAMPSEAL:50#"};
				{ 13, 45577, "", "=q1=Ironforge Tabard", "=ds=#s7#", "#CHAMPSEAL:50#"};
				{ 14, 45574, "", "=q1=Stormwind Tabard", "=ds=#s7#", "#CHAMPSEAL:50#"};
				{ 15, 46817, "", "=q1=Silver Covenant Tabard", "=ds=#s7#", "#CHAMPSEAL:50#"};
				{ 20, 45717, "", "=q2=Ironforge Commendation Badge", "",  "=ds=#CHAMPWRIT:1#"};
				{ 21, 45718, "", "=q2=Stormwind Commendation Badge", "",  "=ds=#CHAMPWRIT:1#"};
				{ 24, 46843, "", "=q1=Argent Crusader's Banner", "=ds=#e14#", "#CHAMPSEAL:15#"};
				{ 25, 45021, "", "=q1=Darnassus Banner", "=ds=#e14#", "#CHAMPSEAL:15#"};
				{ 26, 45020, "", "=q1=Exodar Banner", "=ds=#e14#", "#CHAMPSEAL:15#"};
				{ 27, 45019, "", "=q1=Gnomeregan Banner", "=ds=#e14#", "#CHAMPSEAL:15#"};
				{ 28, 45018, "", "=q1=Ironforge Banner", "=ds=#e14#", "#CHAMPSEAL:15#"};
				{ 29, 45011, "", "=q1=Stormwind Banner", "=ds=#e14#", "#CHAMPSEAL:15#"};
			};
		};
		["Normal_H"] = {
			{
				{ 2, "ATArmor", "inv_boots_plate_09", "=ds="..BabbleInventory["Armor"].." / "..AL["Weapons"], ""};
				{ 3, "ATHeirlooms", "inv_jewelry_talisman_01", "=ds="..AL["Heirloom"], ""};
				{ 17, "ATPets", "achievement_reputation_argentchampion", "=ds="..BabbleInventory["Companions"]};
				{ 18, "ATMounts", "ability_mount_warhippogryph", "=ds="..BabbleInventory["Mounts"]};
				{ 5, 45719, "", "=q2=Orgrimmar Commendation Badge", "",  "=ds=#CHAMPWRIT:1#"};
				{ 6, 45723, "", "=q2=Undercity Commendation Badge", "",  "=ds=#CHAMPWRIT:1#"};
				{ 7, 45722, "", "=q2=Thunder Bluff Commendation Badge", "",  "=ds=#CHAMPWRIT:1#"};
				{ 9, 46874, "", "=q3=Argent Crusader's Tabard", "=ds=#s7#", "#CHAMPSEAL:50#"};
				{ 10, 45581, "", "=q1=Orgrimmar Tabard", "=ds=#s7#", "#CHAMPSEAL:50#"};
				{ 11, 45583, "", "=q1=Undercity Tabard", "=ds=#s7#", "#CHAMPSEAL:50#"};
				{ 12, 45584, "", "=q1=Thunder Bluff Tabard", "=ds=#s7#", "#CHAMPSEAL:50#"};
				{ 13, 45582, "", "=q1=Darkspear Tabard", "=ds=#s7#", "#CHAMPSEAL:50#"};
				{ 14, 45585, "", "=q1=Silvermoon City Tabard", "=ds=#s7#", "#CHAMPSEAL:50#"};
				{ 15, 46818, "", "=q1=Sunreaver Tabard", "=ds=#s7#", "#CHAMPSEAL:50#"};
				{ 20, 45720, "", "=q2=Sen'jin Commendation Badge", "",  "=ds=#CHAMPWRIT:1#"};
				{ 21, 45721, "", "=q2=Silvermoon Commendation Badge", "",  "=ds=#CHAMPWRIT:1#"};
				{ 24, 46843, "", "=q1=Argent Crusader's Banner", "=ds=#e14#", "#CHAMPSEAL:15#"};
				{ 25, 45014, "", "=q1=Orgrimmar Banner", "=ds=#e14#", "#CHAMPSEAL:15#"};
				{ 26, 45016, "", "=q1=Undercity Banner", "=ds=#e14#", "#CHAMPSEAL:15#"};
				{ 27, 45013, "", "=q1=Thunder Bluff Banner", "=ds=#e14#", "#CHAMPSEAL:15#"};
				{ 28, 45015, "", "=q1=Sen'jin Banner", "=ds=#e14#", "#CHAMPSEAL:15#"};
				{ 29, 45017, "", "=q1=Silvermoon City Banner", "=ds=#e14#", "#CHAMPSEAL:15#"};
			};
		};
		info = {
			name = AL["Argent Tournament"],
			menu = "WORLDEVENTMENU",
		};
	}

	AtlasLoot_Data["BREWFESTMENU"] = {
		["Normal"] = {
			{
				{ 1, "Brewfest", "inv_holiday_beerfestpretzel01", "=ds="..AL["Food and Drinks"], ""};
				{ 2, "Brewfest#2", "inv_holiday_brewfestbuff_01", "=ds="..AL["Brew of the Month Club"], ""};
				{ 16, "CorenDirebrew", "inv_misc_head_dwarf_01", "=ds="..BabbleBoss["Coren Direbrew"], ""};
			    { 4, 56836, "", "=q3=Overflowing Purple Brewfest Stein", "=ec1=2011 =q1=#m4#: =ds=#h1#"};
				{ 5, 37892, "", "=q3=Green Brewfest Stein", "#ACHIEVEMENTID:4782#"};
				{ 6, 33016, "", "=q3=Blue Brewfest Stein", "#ACHIEVEMENTID:1293#"};
				{ 7, 32912, "", "=q3=Yellow Brewfest Stein", "#ACHIEVEMENTID:1292#"};
				{ 8, 34140, "", "=q3=Dark Iron Tankard", "=ec1=2007 =q1=#m4#: =ds=#s15#"};
				{ 9, 33976, "", "=q3=Brewfest Ram", "=ec1=2007 =q1=#m4#: =ds=#e26#"};
				{ 11, 33927, "", "=q3=Brewfest Pony Keg", "=ds=#m20#", "#BREWFEST:100#"};
				{ 12, 46707, "", "=q3=Pint-Sized Pink Pachyderm", "=ds=#e13#", "#BREWFEST:100#"};
				{ 13, 32233, "", "=q3=Wolpertinger's Tankard", "=ds=#e13#", "40 #silver#"};
				{ 14, 37816, "", "=q2=Preserved Brewfest Hops", "=ds=#m20#", "#BREWFEST:20#"};
				{
					{ 19, 34008, "", "=q1=Blix's Eyesight Enhancing Romance Goggles", "=ds=#s1#", "#BREWFEST:100#"};
					{ 19, 33047, "", "=q1=Belbi's Eyesight Enhancing Romance Goggles", "=ds=#s1#", "#BREWFEST:100#"};
				};
				{ 20, 33968, "", "=q1=Blue Brewfest Hat", "=ds=#s1#", "#BREWFEST:50#"};
				{ 21, 33864, "", "=q1=Brown Brewfest Hat", "=ds=#s1#", "#BREWFEST:50#"};
				{ 22, 33967, "", "=q1=Green Brewfest Hat", "=ds=#s1#", "#BREWFEST:50#"};
				{ 23, 33969, "", "=q1=Purple Brewfest Hat", "=ds=#s1#", "#BREWFEST:50#"};
				{ 24, 33863, "", "=q1=Brewfest Dress", "=ds=#s5#", "#BREWFEST:200#"};
				{ 25, 33862, "", "=q1=Brewfest Regalia", "=ds=#s5#", "#BREWFEST:200#"};
				{ 26, 33868, "", "=q1=Brewfest Boots", "=ds=#s12#", "#BREWFEST:100#"};
				{ 27, 33966, "", "=q1=Brewfest Slippers", "=ds=#s12#", "#BREWFEST:100#"};
				{ 29, 37750, "", "=q1=Fresh Brewfest Hops", "=ds=#m20#", "#BREWFEST:2#"};
				{
					{ 30, 39477, "", "=q1=Fresh Dwarven Brewfest Hops", "=ec1=#m6# =ds=#m20#", "#BREWFEST:5#"};
					{ 30, 39476, "", "=q1=Fresh Goblin Brewfest Hops", "=ec1=#m7# =ds=#m20#", "#BREWFEST:5#"};
				};
			};
		};
		info = {
			name = AL["Brewfest"],
			menu = "WORLDEVENTMENU",
		};
	}

	AtlasLoot_Data["HALLOWSENDMENU"] = {
		["Normal"] = {
			{
				{ 1, "Halloween", "achievement_halloween_ghost_01", "=ds="..AL["Consumable Wands & Masks"], ""};
				{ 2, "Halloween#2", "inv_mask_04", "=ds="..AL["Permanent Masks"], ""};
				{ 16, "HeadlessHorseman", "inv_misc_food_59", "=ds="..BabbleBoss["Headless Horseman"], ""};
				{ 4, 33117, "", "=q3=Jack-o'-Lantern", "=ds=#e1# =q2="..AL["Various Locations"]};
				{ 5, 20400, "", "=q2=Pumpkin Bag", "=ds=#e1# =q2="..AL["Various Locations"]};
				{ 7, 37011, "", "=q3=Magic Broom", "=ds=#e12#", "#HALLOWSEND:150#"};
				{ 8, 33292, "", "=q3=Hallowed Helm", "=ds=#s1#, #a1#", "#HALLOWSEND:150#"};
				{ 9, 70722, "", "=q3=Little Wickerman", "=ds=#m20#", "#HALLOWSEND:150#"};
				{ 10, 33154, "", "=q3=Sinister Squashling", "=ds=#e13#", "#HALLOWSEND:150#"};
				{ 11, 70908, "", "=q1=Feline Familiar", "=ds=#e13#", "#HALLOWSEND:150#"};
				{ 12, 37604, "", "=q1=Tooth Pick", "=ds=#m20#", "#HALLOWSEND:2#"};
				{ 14, 71076, "", "=q1=Creepy Crate", "=ds=#m4#, #e13#"};
				{ 19, 33189, "", "=q2=Rickety Magic Broom", "=ds=#e12#"};
				{ 20, 20516, "", "=q1=Bobbing Apple", "=ds=#e3#"};
				{ 22, 0, "inv_gauntlets_06", "=q6="..AL["Handful of Treats"], ""};
				{ 23, 37585, "", "=q1=Chewy Fel Taffy", "=ds=#m20#", "#HALLOWSEND:2#"};
				{ 24, 37583, "", "=q1=G.N.E.R.D.S.", "=ds=#m20#", "#HALLOWSEND:2#"};
				{ 25, 37582, "", "=q1=Pyroblast Cinnamon Ball", "=ds=#m20#", "#HALLOWSEND:2#"};
				{ 26, 37584, "", "=q1=Soothing Spearmint Candy", "=ds=#m20#", "#HALLOWSEND:2#"};
				{ 27, 37606, "", "=q1=Penny Pouch", "=ds=#e1#"};
			};
		};
		info = {
			name = AL["Hallow's End"],
			menu = "WORLDEVENTMENU",
		};
	}

	AtlasLoot_Data["DARKMOONMENU"] = {
		["Normal"] = {
			{
				{ 2, "DarkmoonD1D2", "ability_druid_maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=ec1=#j8# - #j9#"};
				{ 3, "DarkmoonD1D2#2", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], "=ec1=#j8# - #j9#"};
				{ 4, "DarkmoonD1D2#3", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], "=ec1=#j8# - #j9#"};
				{ 5, "DarkmoonD1D2#4", "ability_thunderbolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=ec1=#j8# - #j9#"};
				{ 6, "DarkmoonD1D2#5", "inv_staff_30", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=ec1=#j8# - #j9#"};
				{ 7, "DarkmoonD1D2#6", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], "=ec1=#j8# - #j9#"};
				{ 8, "DarkmoonD1D2#7", "spell_nature_bloodlust", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=ec1=#j8# - #j9#"};
				{ 9, "DarkmoonD1D2#8", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], "=ec1=#j8# - #j9#"};
				{ 10, "DarkmoonD1D2#9", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=ec1=#j8# - #j9#"};
				{ 17, "Darkmoon", "ability_hunter_pet_bear", "=ds="..BabbleInventory["Mounts"].." / "..BabbleInventory["Companions"], ""};
				{ 18, "Darkmoon#2", "inv_misc_food_164_fish_seadog", "=ds="..AL["Food and Drinks"], ""};
				{ 19, "Darkmoon#3", "inv_misc_bone_taurenskull_01", "=ds="..AL["Heirloom"], ""};
				{ 21, "DarkmoonDeck", "inv_inscription_tarot_hurricanecard", "=ds="..AL["Level 85 Trinkets"], ""};
				{ 22, "DarkmoonDeck#2", "INV_Inscription_TarotGreatness", "=ds="..AL["Level 80 Trinkets"], ""};
				{ 23, "DarkmoonDeck#3", "INV_Misc_Ticket_Tarot_Madness", "=ds="..AL["Level 60 & 70 Trinkets"], ""};
				{ 24, "DarkmoonDeck#4", "INV_Misc_Ticket_Tarot_Furies", "=ds="..AL["Low Level Decks"], ""};
			};
		};
		info = {
			name = BabbleFaction["Darkmoon Faire"],
			menu = "WORLDEVENTMENU",
		};
	}

	AtlasLoot_Data["ABYSSALMENU"] = {
		["Normal"] = {
			{
				{ 1, "Templars", "INV_Jewelry_Talisman_05", "=ds="..AL["Abyssal Council"].." - "..AL["Templars"], ""};
				{ 3, 0, "INV_Box_01", "=q6="..BabbleBoss["Prince Skaldrenox"], "=q1=#j19#"};
				{ 4, 20682, "", "=q4=Elemental Focus Band", "=ds=#s13#", "", "22.83%"};
				{ 5, 20515, "", "=q4=Abyssal Scepter", "=ds=#m3#", "", "100%"};
				{ 6, 20681, "", "=q3=Abyssal Leather Bracers", "=ds=#s8#, #a2#", "", "24.70%"};
				{ 7, 20680, "", "=q3=Abyssal Mail Pauldrons", "=ds=#s3#, #a3#", "", "24.21%"};
				{ 9, 0, "INV_Box_01", "=q6="..BabbleBoss["Lord Skwol"], "=q1=#j20#"};
				{ 10, 20685, "", "=q4=Wavefront Necklace", "=ds=#s2#", "", "24.48%"};
				{ 11, 20515, "", "=q4=Abyssal Scepter", "=ds=#m3#", "", "100%"};
				{ 12, 20684, "", "=q3=Abyssal Mail Armguards", "=ds=#s8#, #a3#", "", "27.68%"};
				{ 13, 20683, "", "=q3=Abyssal Plate Epaulets", "=ds=#s3#, #a4#", "", "21.52%"};
				{ 14, 20687, "", "=q3=Abyssal Plate Vambraces", "=ds=#s8#, #a4#", "", "23.66%"};
				{ 16, "Dukes", "INV_Jewelry_Ring_36", "=ds="..AL["Abyssal Council"].." - "..AL["Dukes"], ""};
				{ 18, 0, "INV_Box_01", "=q6="..BabbleBoss["High Marshal Whirlaxis"], "=q1=#j21#"};
				{ 19, 20691, "", "=q4=Windshear Cape", "=ds=#s4#", "", "22.08%"};
				{ 20, 20515, "", "=q4=Abyssal Scepter", "=ds=#m3#", "", "100%"};
				{ 21, 20690, "", "=q3=Abyssal Cloth Wristbands", "=ds=#s8#, #a1#", "", "23.60%"};
				{ 22, 20689, "", "=q3=Abyssal Leather Shoulders", "=ds=#s3#, #a3#", "", "23.40%"};
				{ 24, 0, "INV_Box_01", "=q6="..BabbleBoss["Baron Kazum"], "=q1=#j22#"};
				{ 25, 20688, "", "=q4=Earthen Guard", "=ds=#w8#", "", "20.64%"};
				{ 26, 20515, "", "=q4=Abyssal Scepter", "=ds=#m3#", "", "100%"};
				{ 27, 20686, "", "=q3=Abyssal Cloth Amice", "=ds=#s3#, #a1#", "", "23.96%"};
			};
		};
		info = {
			name = AL["Abyssal Council"],
			menu = "WORLDEVENTMENU",
		};
	}

	AtlasLoot_Data["ETHEREUMMENU"] = {
		["Normal"] = {
			{
				{ 2, "ArmbreakerHuffaz", "INV_Jewelry_Ring_59", "=ds="..AL["Armbreaker Huffaz"], ""};
				{ 3, "Forgosh", "INV_Boots_05", "=ds="..AL["Forgosh"], ""};
				{ 4, "MalevustheMad", "INV_Boots_Chain_04", "=ds="..AL["Malevus the Mad"], ""};
				{ 5, "WrathbringerLaztarash", "INV_Misc_Orb_01", "=ds="..AL["Wrathbringer Laz-tarash"], ""};
				{ 17, "FelTinkererZortan", "INV_Boots_Chain_08", "=ds="..AL["Fel Tinkerer Zortan"], ""};
				{ 18, "Gulbor", "INV_Jewelry_Necklace_29Naxxramas", "=ds="..AL["Gul'bor"], ""};
				{ 19, "PorfustheGemGorger", "INV_Boots_Cloth_01", "=ds="..AL["Porfus the Gem Gorger"], ""};
				{ 20, "BashirStasisChambers", "INV_Trinket_Naxxramas02", "=ds="..AL["Bash'ir Landing Stasis Chambers"], ""};
			};
		};
		info = {
			name = AL["Ethereum Prison"],
			menu = "WORLDEVENTMENU",
		};
	}

	AtlasLoot_Data["SKETTISMENU"] = {
		["Normal"] = {
			{
				{ 2, "DarkscreecherAkkarai", "INV_Misc_Rune_07", "=ds="..AL["Darkscreecher Akkarai"], ""};
				{ 3, "GezzaraktheHuntress", "INV_Misc_Rune_07", "=ds="..AL["Gezzarak the Huntress"], ""};
				{ 4, "Terokk", "INV_Misc_Rune_07", "=ds="..AL["Terokk"], ""};
				{ 17, "Karrog", "INV_Misc_Rune_07", "=ds="..AL["Karrog"], ""};
				{ 18, "VakkiztheWindrager", "INV_Misc_Rune_07", "=ds="..AL["Vakkiz the Windrager"], ""};
			};
		};
		info = {
			name = AL["Skettis"],
			menu = "WORLDEVENTMENU",
		};
	}