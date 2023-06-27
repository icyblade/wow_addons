-- $Id$
local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");
local BabbleBoss = AtlasLoot_GetLocaleLibBabble("LibBabble-Boss-3.0")
local BabbleFaction = AtlasLoot_GetLocaleLibBabble("LibBabble-Faction-3.0")
local BabbleInventory = AtlasLoot_GetLocaleLibBabble("LibBabble-Inventory-3.0")
local BabbleItemSet = AtlasLoot_GetLocaleLibBabble("LibBabble-ItemSet-3.0")
local BabbleZone = AtlasLoot_GetLocaleLibBabble("LibBabble-Zone-3.0")
local moduleName = "AtlasLootCrafting"

-- Using alchemy skill to get localized rank
local JOURNEYMAN = select(2, GetSpellInfo(3101));
local EXPERT = select(2, GetSpellInfo(3464));
local ARTISAN = select(2, GetSpellInfo(11611));
local MASTER = select(2, GetSpellInfo(28596));

local ALCHEMY, APPRENTICE = GetSpellInfo(2259);
local ARCHAEOLOGY = GetSpellInfo(78670)
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

-- Index
--- Tradeskill List
---- Alchemy
----- Battle Elixirs
----- Guardian Elixirs
----- Other Elixirs
----- Potions
----- Flasks
----- Transmutes
----- Cauldrons
----- Oils
----- Miscellaneous
---- Archaeology
----- Armor and Weapons
----- Miscellaneous
---- Blacksmithing
----- Armor
----- Weapons
----- Armor Enhancements
----- Weapon Enhancements
----- Miscellaneous
----- Armorsmith
----- Weaponsmith
----- Axesmith
----- Hammersmith
----- Swordsmith
----- Cataclysm Vendor Sold Plans
---- Cooking
---- Enchanting
----- Boots
----- Bracers
----- Chest
----- Cloaks
----- Gloves
----- Rings
----- Shields
----- 2 Hand Weapons
----- 1 Hand Weapons
----- Staves
----- Miscellaneous
----- Cataclysm Vendor Sold Formulas
---- Engineering
---- First Aid
---- Inscription
---- Jewelcrafting
---- Leatherworking
----- Leather Armor
----- Mail Armor
----- Cloaks
----- Item Enhancements
----- Drums / Bags / Misc
----- Leather
----- Dragonscale
----- Elemental
----- Tribal
----- Cataclysm Vendor Sold Patterns
---- Mining
---- Tailoring
----- Armor
----- Bags
----- Miscellaneous
----- Shirts
----- Mooncloth
----- Shadoweave
----- Spellfire
----- Cataclysm Vendor Sold Patterns
--- Profession Sets
---- Blacksmithing Mail Sets
---- Blacksmithing Plate Sets
---- Leatherworking Leather Sets
---- Leatherworking Mail Sets
---- Tailoring Sets
--- Other
---- Crafted Epic Weapons
--- Daily Profession Rewards
---- Cooking Daily
---- Fishing Daily
---- Jewelcrafting Daily

	-----------------------
	--- Tradeskill List ---
	-----------------------

		---------------
		--- Alchemy ---
		---------------

	AtlasLoot_Data["AlchemyBattleElixir"] = {
		["Normal"] = {
			{
				{ 1, "s80497", "58148", "=q1=Elixir of the Master", "=ds=#sr# 495", "=ds="..AL["Trainer"]};
				{ 2, "s80493", "58144", "=q1=Elixir of Mighty Speed", "=ds=#sr# 490", "=ds="..AL["Trainer"]};
				{ 3, "s80491", "58094", "=q1=Elixir of Impossible Accuracy", "=ds=#sr# 480", "=ds="..AL["Trainer"]};
				{ 4, "s80484", "58092", "=q1=Elixir of the Cobra", "=ds=#sr# 465", "=ds="..AL["Trainer"]};
				{ 5, "s80480", "58089", "=q1=Elixir of the Naga", "=ds=#sr# 455", "=ds="..AL["Trainer"]};
				{ 6, "s80477", "58084", "=q1=Ghost Elixir", "=ds=#sr# 450", "=ds="..AL["Trainer"]};
				{ 8, "s60355", "44327", "=q1=Elixir of Deadly Strikes", "=ds=#sr# 400", "=ds="..GetSpellInfo(60893)};
				{ 9, "s60357", "44329", "=q1=Elixir of Expertise", "=ds=#sr# 400", "=ds="..GetSpellInfo(60893)};
				{ 10, "s60366", "44331", "=q1=Elixir of Lightning Speed", "=ds=#sr# 400", "=ds="..GetSpellInfo(60893)};
				{ 12, "s60354", "44325", "=q1=Elixir of Accuracy", "=ds=#sr# 400", "=ds="..GetSpellInfo(60893)};
				{ 13, "s63732", "45621", "=q1=Elixir of Minor Accuracy", "=ds=#sr# 135", "=ds="..AL["Trainer"]};
				{ 16, "s53848", "40076", "=q1=Guru's Elixir", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
				{ 17, "s33741", "28104", "=q1=Elixir of Mastery", "=ds=#sr# 315", "=ds="..AL["Trainer"]};
				{ 19, "s60365", "44330", "=q1=Elixir of Armor Piercing", "=ds=#sr# 400", "=ds="..GetSpellInfo(60893)};
				{ 20, "s53840", "39666", "=q1=Elixir of Mighty Agility", "=ds=#sr# 395", "=ds="..AL["Trainer"]};
				{
					{ 21, "s28553", "22831", "=q1=Elixir of Major Agility", "=ds=#sr# 330", "=ds="..BabbleFaction["Thrallmar"].." - "..BabbleFaction["Honored"] };
					{ 21, "s28553", "22831", "=q1=Elixir of Major Agility", "=ds=#sr# 330", "=ds="..BabbleFaction["Honor Hold"].." - "..BabbleFaction["Honored"] };
				};
				{ 22, "s17571", "13452", "=q1=Elixir of the Mongoose", "=ds=#sr# 280", "=ds="..BabbleZone["Felwood"]};
				{ 23, "s11467", "9187", "=q1=Elixir of Greater Agility", "=ds=#sr# 240", "=ds="..AL["Trainer"]};
				{ 24, "s11449", "8949", "=q1=Elixir of Agility", "=ds=#sr# 185", "=ds="..AL["Trainer"]};
				{ 25, "s2333", "3390", "=q1=Elixir of Lesser Agility", "=ds=#sr# 140", "=ds="..AL["World Drop"]};
				{ 26, "s3230", "2457", "=q1=Elixir of Minor Agility", "=ds=#sr# 50", "=ds="..AL["World Drop"]};
			};
			{

				{ 1, "s54218", "40073", "=q1=Elixir of Mighty Strength", "=ds=#sr# 385", "=ds="..AL["Trainer"]};
				{ 2, "s28544", "22824", "=q1=Elixir of Major Strength", "=ds=#sr# 305", "=ds="..AL["Trainer"]};
				{ 3, "s11472", "9206", "=q1=Elixir of Giants", "=ds=#sr# 245", "=ds="..AL["World Drop"]};
				{ 4, "s17557", "13453", "=q1=Elixir of Brute Force", "=ds=#sr# 275", "=ds="..AL["Trainer"]};
				{ 5, "s8240", "6662", "=q1=Elixir of Giant Growth", "=ds=#sr# 90", "=ds="..BabbleZone["The Barrens"]};
				{ 6, "s3188", "3391", "=q1=Elixir of Ogre's Strength", "=ds=#sr# 150", "=ds="..AL["World Drop"]};
				{ 7, "s2329", "2454", "=q1=Elixir of Lion's Strength", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
				{ 9, "s53841", "40068", "=q1=Wrath Elixir", "=ds=#sr# 355", "=ds="..AL["Trainer"]};
				{ 10, "s38960", "31679", "=q1=Fel Strength Elixir", "=ds=#sr# 335", "=ds="..BabbleZone["Shadowmoon Valley"]};
				{ 11, "s33738", "28102", "=q1=Onslaught Elixir", "=ds=#sr# 300", "=ds="..AL["Trainer"]};
				{ 12, "s11477", "9224", "=q1=Elixir of Demonslaying", "=ds=#sr# 250", "=ds="..AL["Vendor"]};
				{ 16, "s53842", "40070", "=q1=Spellpower Elixir", "=ds=#sr# 365", "=ds="..AL["Trainer"]};
				{ 17, "s28558", "22835", "=q1=Elixir of Major Shadow Power", "=ds=#sr# 350", "=ds="..BabbleFaction["Lower City"].." - "..BabbleFaction["Revered"]};
				{ 18, "s28556", "22833", "=q1=Elixir of Major Firepower", "=ds=#sr# 345", "=ds="..BabbleFaction["The Scryers"].." - "..BabbleFaction["Revered"]};
				{ 19, "s28549", "22827", "=q1=Elixir of Major Frost Power", "=ds=#sr# 320", "=ds="..AL["Vendor"]..": "..BabbleZone["Zangarmarsh"]};
				{ 20, "s28545", "22825", "=q1=Elixir of Healing Power", "=ds=#sr# 310", "=ds="..AL["Trainer"]};
				{ 21, "s33740", "28103", "=q1=Adept's Elixir", "=ds=#sr# 300", "=ds="..AL["Trainer"]};
				{ 22, "s17573", "13454", "=q1=Greater Arcane Elixir", "=ds=#sr# 285", "=ds="..AL["Trainer"]};
				{ 23, "s26277", "21546", "=q1=Elixir of Greater Firepower", "=ds=#sr# 290", "=ds="..BabbleZone["Searing Gorge"]};
				{
					{ 24, "s11476", "9264", "=q1=Elixir of Shadow Power", "=ds=#sr# 250", "=ds="..AL["Vendor"]..": "..BabbleZone["Undercity"] };
					{ 24, "s11476", "9264", "=q1=Elixir of Shadow Power", "=ds=#sr# 250", "=ds="..AL["Vendor"]..": "..BabbleZone["Stormwind City"] };
				};
				{ 25, "s11461", "9155", "=q1=Arcane Elixir", "=ds=#sr# 285", "=ds="..AL["Trainer"]};
				{ 26, "s21923", "17708", "=q1=Elixir of Frost Power", "=ds=#sr# 190", "=ds="..AL["Feast of Winter Veil"]};
				{ 27, "s7845", "6373", "=q1=Elixir of Firepower", "=ds=#sr# 140", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = ALCHEMY..": "..AL["Battle Elixirs"],
			module = moduleName, menu = "ALCHEMYMENU",
		};
	};

	AtlasLoot_Data["AlchemyGuardianElixir"] = {
		["Normal"] = {
			{
				{ 1, "s80492", "58143", "=q1=Prismatic Elixir", "=ds=#sr# 480", "=ds="..AL["Trainer"]};
				{ 2, "s80488", "58093", "=q1=Elixir of Deep Earth", "=ds=#sr# 475", "=ds="..AL["Trainer"]};
				{ 4, "s60356", "44328", "=q1=Elixir of Mighty Defense", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 5, "s56519", "40109", "=q1=Elixir of Mighty Mageblood", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 6, "s54220", "40097", "=q1=Elixir of Protection", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 7, "s62410", "8827", "=q1=Elixir of Water Walking", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 8, "s60367", "44332", "=q1=Elixir of Mighty Thoughts", "=ds=#sr# 395", "=ds="..AL["Trainer"]};
				{ 9, "s53898", "40078", "=q1=Elixir of Mighty Fortitude", "=ds=#sr# 390", "=ds="..AL["Trainer"]};
				{ 10, "s53847", "40072", "=q1=Elixir of Spirit", "=ds=#sr# 385", "=ds="..AL["Trainer"]};
				{ 11, "s28578", "22848", "=q1=Elixir of Empowerment", "=ds=#sr# 365", "=ds="..AL["World Drop"]};
				{ 12, "s28570", "22840", "=q1=Elixir of Major Mageblood", "=ds=#sr# 355", "=ds="..AL["World Drop"]};
				{ 13, "s28557", "22834", "=q1=Elixir of Major Defense", "=ds=#sr# 345", "=ds="..AL["Vendor"]};
				{ 14, "s39639", "32068", "=q1=Elixir of Ironskin", "=ds=#sr# 330", "=ds="..AL["Vendor"]..": "..BabbleZone["Nagrand"]};
				{ 15, "s39637", "32063", "=q1=Earthen Elixir", "=ds=#sr# 320", "=ds="..BabbleFaction["Cenarion Expedition"].." - "..BabbleFaction["Honored"]};
				{ 16, "s39638", "32067", "=q1=Elixir of Draenic Wisdom", "=ds=#sr# 320", "=ds="..AL["Trainer"]};
				{ 17, "s39636", "32062", "=q1=Elixir of Major Fortitude", "=ds=#sr# 310", "=ds="..AL["Trainer"]};
				{ 18, "s24368", "20004", "=q1=Mighty Troll's Blood Elixir", "=ds=#sr# 290", "=ds="..BabbleFaction["Zandalar Tribe"].." - "..BabbleFaction["Honored"]};
				{ 19, "s24365", "20007", "=q1=Mageblood Elixir", "=ds=#sr# 275", "=ds="..BabbleFaction["Zandalar Tribe"].." - "..BabbleFaction["Revered"]};
				{
					{ 20, "s17554", "13445", "=q1=Elixir of Superior Defense", "=ds=#sr# 265", "=ds="..AL["Vendor"]..": "..BabbleZone["Orgrimmar"] };
					{ 20, "s17554", "13445", "=q1=Elixir of Superior Defense", "=ds=#sr# 265", "=ds="..AL["Vendor"]..": "..BabbleZone["Ironforge"] };
				};
				{ 21, "s17555", "13447", "=q1=Elixir of the Sages", "=ds=#sr# 270", "=ds="..AL["Trainer"]};
				{ 22, "s11466", "9088", "=q1=Gift of Arthas", "=ds=#sr# 240", "=ds="..BabbleZone["Western Plaguelands"]};
				{ 23, "s11465", "9179", "=q1=Elixir of Greater Intellect", "=ds=#sr# 235", "=ds="..AL["Trainer"]};
				{ 24, "s11450", "8951", "=q1=Elixir of Greater Defense", "=ds=#sr# 195", "=ds="..AL["Trainer"]};
				{ 25, "s3451", "3826", "=q1=Major Troll's Blood Elixir", "=ds=#sr# 180", "=ds="..AL["World Drop"]};
				{ 26, "s3450", "3825", "=q1=Elixir of Fortitude", "=ds=#sr# 175", "=ds="..AL["Trainer"]};
				{ 27, "s3177", "3389", "=q1=Elixir of Defense", "=ds=#sr# 130", "=ds="..AL["Trainer"]};
				{ 28, "s3176", "3388", "=q1=Strong Troll's Blood Potion", "=ds=#sr# 125", "=ds="..AL["Trainer"]};
				{ 29, "s3171", "3383", "=q1=Elixir of Wisdom", "=ds=#sr# 90", "=ds="..AL["Trainer"]};
				{ 30, "s2334", "2458", "=q1=Elixir of Minor Fortitude", "=ds=#sr# 50", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, "s3170", "3382", "=q1=Weak Troll's Blood Elixir", "=ds=#sr# 15", "=ds="..AL["Trainer"]};
				{ 2, "s7183", "5997", "=q1=Elixir of Minor Defense", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
				{ 3, "s12609", "10592", "=q1=Catseye Elixir", "=ds=#sr# 200", "=ds="..AL["Trainer"]};	
			};
		};
		info = {
			name = ALCHEMY..": "..AL["Guardian Elixirs"],
			module = moduleName, menu = "ALCHEMYMENU",
		};
	};

	AtlasLoot_Data["AlchemyOtherElixir"] = {
		["Normal"] = {
			{
				{ 1, "s28552", "22830", "=q1=Elixir of the Searching Eye", "=ds=#sr# 325", "=ds="..AL["World Drop"]};
				{ 2, "s28543", "22823", "=q1=Elixir of Camouflage", "=ds=#sr# 305", "=ds="..AL["Vendor"]};
				{ 3, "s11478", "9233", "=q1=Elixir of Detect Demon", "=ds=#sr# 250", "=ds="..AL["Trainer"]};
				{ 4, "s11468", "9197", "=q1=Elixir of Dream Vision", "=ds=#sr# 240", "=ds="..AL["World Drop"]};
				{ 5, "s11460", "9154", "=q1=Elixir of Detect Undead", "=ds=#sr# 230", "=ds="..AL["Trainer"]};
				{ 6, "s22808", "18294", "=q1=Elixir of Greater Water Breathing", "=ds=#sr# 215", "=ds="..AL["Trainer"]};
				{ 7, "s3453", "3828", "=q1=Elixir of Detect Lesser Invisibility", "=ds=#sr# 195", "=ds="..AL["World Drop"]};
				{ 8, "s7179", "5996", "=q1=Elixir of Water Breathing", "=ds=#sr# 90", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = ALCHEMY..": "..AL["Other Elixirs"],
			module = moduleName, menu = "ALCHEMYMENU",
		};
	};

	AtlasLoot_Data["AlchemyPotion"] = {
		["Normal"] = {
			{
				{ 1, "s80498", "57191", "=q1=Mythical Healing Potion", "=ds=#sr# 495", "=ds="..AL["Trainer"]};
				{ 2, "s80494", "57192", "=q1=Mythical Mana Potion", "=ds=#sr# 485", "=ds="..AL["Trainer"]};
				{ 3, "s80490", "57193", "=q1=Mighty Rejuvenation Potion", "=ds=#sr# 475", "=ds="..AL["Trainer"]};
				{ 4, "s80487", "57099", "=q1=Mysterious Potion", "=ds=#sr# 470", "=ds="..AL["Trainer"]};
				{ 5, "s80482", "57194", "=q1=Potion of Concentration", "=ds=#sr# 465", "=ds="..AL["Trainer"]};
				{ 6, "s93935", "67415", "=q1=Draught of War", "=ds=#sr# 425", "=ds="..AL["Trainer"]};
				{ 8, "s80496", "58146", "=q1=Golemblood Potion", "=ds=#sr# 490", "=ds="..AL["Trainer"]};
				{ 9, "s80495", "58145", "=q1=Potion of the Tol'vir", "=ds=#sr# 485", "=ds="..AL["Trainer"]};
				{ 10, "s80481", "58091", "=q1=Volcanic Potion", "=ds=#sr# 460", "=ds="..AL["Trainer"]};
				{ 11, "s80478", "58090", "=q1=Earthen Potion", "=ds=#sr# 450", "=ds="..AL["Trainer"]};
				{ 13, "s80725", "58487", "=q1=Potion of Deepholm", "=ds=#sr# 525", "=ds="..AL["Trainer"]};
				{ 14, "s80726", "58488", "=q1=Potion of Treasure Finding", "=ds=#sr# 525", "=ds="..AL["Trainer"]};
				{ 15, "s80269", "58489", "=q1=Potion of Illusion", "=ds=#sr# 460", "=ds="..AL["Trainer"]};
				{ 16, "s54221", "40211", "=q1=Potion of Speed", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 17, "s54222", "40212", "=q1=Potion of Wild Magic", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 18, "s53904", "40087", "=q1=Powerful Rejuvenation Potion", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 19, "s58868", "43570", "=q1=Endless Mana Potion", "=ds=#sr# 410", "=ds="..AL["Trainer"]};
				{ 20, "s53837", "33448", "=q1=Runic Mana Potion", "=ds=#sr# 410", "=ds="..AL["Trainer"]};
				{ 21, "s58871", "43569", "=q1=Endless Healing Potion", "=ds=#sr# 410", "=ds="..AL["Trainer"]};
				{ 22, "s53836", "33447", "=q1=Runic Healing Potion", "=ds=#sr# 405", "=ds="..AL["Trainer"]};
				{ 23, "s53936", "40213", "=q1=Mighty Arcane Protection Potion", "=ds=#sr# 400", "=ds="..BabbleZone["Icecrown"]};
				{ 24, "s53939", "40214", "=q1=Mighty Fire Protection Potion", "=ds=#sr# 400", "=ds="..AL["Drop"]};
				{ 25, "s53937", "40215", "=q1=Mighty Frost Protection Potion", "=ds=#sr# 400", "=ds="..AL["Drop"]};
				{ 26, "s53942", "40216", "=q1=Mighty Nature Protection Potion", "=ds=#sr# 400", "=ds="..AL["Drop"]};
				{ 27, "s53938", "40217", "=q1=Mighty Shadow Protection Potion", "=ds=#sr# 400", "=ds="..BabbleZone["Icecrown"]};
				{ 28, "s53905", "40093", "=q1=Indestructible Potion", "=ds=#sr# 395", "=ds="..AL["Trainer"]};
				{ 29, "s53900", "40081", "=q1=Potion of Nightmares", "=ds=#sr# 380", "=ds="..AL["Trainer"]};
				{ 30, "s53895", "40077", "=q1=Crazy Alchemist's Potion", "=ds=#sr# 400", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, "s53839", "40067", "=q1=Icy Mana Potion", "=ds=#sr# 360", "=ds="..AL["Trainer"]};
				{ 2, "s53838", "39671", "=q1=Resurgent Healing Potion", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 3, "s28586", "22850", "=q1=Super Rejuvenation Potion", "=ds=#sr# 300", "=ds="..AL["Discovery"]};
				{ 4, "s38961", "31677", "=q1=Fel Mana Potion", "=ds=#sr# 360", "=ds="..BabbleZone["Shadowmoon Valley"]};
				{ 5, "s28579", "22849", "=q1=Ironshield Potion", "=ds=#sr# 365", "=ds="..BabbleBoss["Captain Skarloc"]..": "..BabbleZone["Old Hillsbrad Foothills"]};
				{ 6, "s28575", "22845", "=q1=Major Arcane Protection Potion", "=ds=#sr# 360", "=ds="..BabbleZone["Nagrand"]};
				{ 7, "s28571", "22841", "=q1=Major Fire Protection Potion", "=ds=#sr# 360", "=ds="..BabbleZone["The Mechanar"]};
				{ 8, "s28572", "22842", "=q1=Major Frost Protection Potion", "=ds=#sr# 360", "=ds="..BabbleBoss["Nexus-Prince Shaffar"]..": "..BabbleZone["Mana-Tombs"]};
				{ 9, "s28577", "22847", "=q1=Major Holy Protection Potion", "=ds=#sr# 360", "=ds="..BabbleZone["Blade's Edge Mountains"]};
				{ 10, "s28573", "22844", "=q1=Major Nature Protection Potion", "=ds=#sr# 360", "=ds="..BabbleFaction["Cenarion Expedition"].." - "..BabbleFaction["Exalted"]};
				{ 11, "s28576", "22846", "=q1=Major Shadow Protection Potion", "=ds=#sr# 360", "=ds="..BabbleZone["Shadowmoon Valley"]};
				{ 12, "s28565", "22839", "=q1=Destruction Potion", "=ds=#sr# 350", "=ds="..AL["World Drop"]};
				{ 13, "s28564", "22838", "=q1=Haste Potion", "=ds=#sr# 350", "=ds="..AL["World Drop"]};
				{ 14, "s28563", "22837", "=q1=Heroic Potion", "=ds=#sr# 350", "=ds="..AL["World Drop"]};
				{ 15, "s28562", "22836", "=q1=Major Dreamless Sleep Potion", "=ds=#sr# 350", "=ds="..AL["Vendor"]};
				{ 16, "s38962", "31676", "=q1=Fel Regeneration Potion", "=ds=#sr# 345", "=ds="..BabbleZone["Shadowmoon Valley"]};
				{ 17, "s28555", "22832", "=q1=Super Mana Potion", "=ds=#sr# 340", "=ds="..AL["Vendor"]};
				{ 18, "s28554", "22871", "=q1=Shrouding Potion", "=ds=#sr# 335", "=ds="..BabbleFaction["Sporeggar"].." - "..BabbleFaction["Exalted"]};
				{ 19, "s45061", "34440", "=q1=Mad Alchemist's Potion", "=ds=#sr# 325", "=ds="..AL["Trainer"]};
				{ 20, "s28551", "22829", "=q1=Super Healing Potion", "=ds=#sr# 325", "=ds="..AL["Trainer"]};
				{ 21, "s28550", "22828", "=q1=Insane Strength Potion", "=ds=#sr# 320", "=ds="..AL["World Drop"]};
				{ 22, "s28546", "22826", "=q1=Sneaking Potion", "=ds=#sr# 315", "=ds="..AL["Vendor"]};
				{ 23, "s33733", "28101", "=q1=Unstable Mana Potion", "=ds=#sr# 310", "=ds="..AL["Trainer"]};
				{ 25, "s22732", "18253", "=q1=Major Rejuvenation Potion", "=ds=#sr# 300", "=ds="..BabbleZone["Molten Core"]};
				{ 26, "s33732", "28100", "=q1=Volatile Healing Potion", "=ds=#sr# 300", "=ds="..AL["Trainer"]};
				{ 27, "s17580", "13444", "=q1=Major Mana Potion", "=ds=#sr# 295", "=ds="..AL["Vendor"]..": "..BabbleZone["Western Plaguelands"]};
				{ 28, "s17577", "13461", "=q1=Greater Arcane Protection Potion", "=ds=#sr# 290", "=ds="..BabbleZone["Winterspring"]};
				{ 29, "s17574", "13457", "=q1=Greater Fire Protection Potion", "=ds=#sr# 290", "=ds="..BabbleZone["Blackrock Spire"]};
				{ 30, "s17575", "13456", "=q1=Greater Frost Protection Potion", "=ds=#sr# 290", "=ds="..BabbleZone["Winterspring"]};
			};
			{
				{ 1, "s17576", "13458", "=q1=Greater Nature Protection Potion", "=ds=#sr# 290", "=ds="..BabbleZone["Western Plaguelands"]};
				{ 2, "s17578", "13459", "=q1=Greater Shadow Protection Potion", "=ds=#sr# 290", "=ds="..BabbleZone["Eastern Plaguelands"]};
				{ 3, "s24367", "20008", "=q1=Living Action Potion", "=ds=#sr# 285", "=ds="..BabbleFaction["Zandalar Tribe"].." - "..BabbleFaction["Exalted"]};
				{ 4, "s17572", "13462", "=q1=Purification Potion", "=ds=#sr# 285", "=ds="..AL["World Drop"]};
				{ 5, "s17570", "13455", "=q1=Greater Stoneshield Potion", "=ds=#sr# 280", "=ds="..AL["World Drop"]};
				{ 6, "s24366", "20002", "=q1=Greater Dreamless Sleep Potion", "=ds=#sr# 275", "=ds="..BabbleFaction["Zandalar Tribe"].." - "..BabbleFaction["Friendly"]};
				{ 7, "s17556", "13446", "=q1=Major Healing Potion", "=ds=#sr# 275", "=ds="..AL["Trainer"]};
				{ 8, "s17553", "13443", "=q1=Superior Mana Potion", "=ds=#sr# 260", "=ds="..AL["Trainer"]};
				{ 9, "s17552", "13442", "=q1=Mighty Rage Potion", "=ds=#sr# 255", "=ds="..AL["Trainer"]};
				{ 10, "s3175", "3387", "=q1=Limited Invulnerability Potion", "=ds=#sr# 250", "=ds="..AL["World Drop"]};
				{ 11, "s11464", "9172", "=q1=Invisibility Potion", "=ds=#sr# 235", "=ds="..AL["World Drop"]};
				{ 12, "s15833", "12190", "=q1=Dreamless Sleep Potion", "=ds=#sr# 230", "=ds="..AL["Trainer"]};
				{ 13, "s11458", "9144", "=q1=Wildvine Potion", "=ds=#sr# 225", "=ds="..BabbleZone["The Hinterlands"].."/"..BabbleZone["Stranglethorn Vale"]};
				{ 14, "s4942", "4623", "=q1=Lesser Stoneshield Potion", "=ds=#sr# 215", "=ds="..BabbleInventory["Quest"]..": "..BabbleZone["Badlands"]};
				{ 15, "s11457", "3928", "=q1=Superior Healing Potion", "=ds=#sr# 215", "=ds="..AL["Trainer"]};
				{ 16, "s11453", "9036", "=q1=Magic Resistance Potion", "=ds=#sr# 210", "=ds="..AL["World Drop"]};
				{ 17, "s11452", "9030", "=q1=Restorative Potion", "=ds=#sr# 210", "=ds="..BabbleInventory["Quest"]..": "..BabbleZone["Badlands"]};
				{ 18, "s11448", "6149", "=q1=Greater Mana Potion", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 19, "s7258", "6050", "=q1=Frost Protection Potion", "=ds=#sr# 190", "=ds="..AL["Vendor"]};
				{ 20, "s7259", "6052", "=q1=Nature Protection Potion", "=ds=#sr# 190", "=ds="..AL["Vendor"]};
				{ 21, "s6618", "5633", "=q1=Great Rage Potion", "=ds=#sr# 175", "=ds="..AL["Vendor"]};
				{ 22, "s3448", "3823", "=q1=Lesser Invisibility Potion", "=ds=#sr# 165", "=ds="..AL["Trainer"]};
				{ 23, "s7257", "6049", "=q1=Fire Protection Potion", "=ds=#sr# 165", "=ds="..AL["Vendor"]};
				{ 24, "s3452", "3827", "=q1=Mana Potion", "=ds=#sr# 160", "=ds="..AL["Trainer"]};
				{ 25, "s7181", "1710", "=q1=Greater Healing Potion", "=ds=#sr# 155", "=ds="..AL["Trainer"]};
				{ 26, "s6624", "5634", "=q1=Free Action Potion", "=ds=#sr# 150", "=ds="..AL["Vendor"]};
				{ 27, "s7256", "6048", "=q1=Shadow Protection Potion", "=ds=#sr# 135", "=ds="..AL["Vendor"]};
				{ 28, "s3173", "3385", "=q1=Lesser Mana Potion", "=ds=#sr# 120", "=ds="..AL["Trainer"]};
				{ 29, "s3174", "3386", "=q1=Potion of Curing", "=ds=#sr# 120", "=ds="..AL["World Drop"]};
				{ 30, "s3447", "929", "=q1=Healing Potion", "=ds=#sr# 110", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, "s3172", "3384", "=q1=Minor Magic Resistance Potion", "=ds=#sr# 110", "=ds="..AL["World Drop"]};
				{ 2, "s7255", "6051", "=q1=Holy Protection Potion", "=ds=#sr# 100", "=ds="..AL["Vendor"]};
				{ 3, "s7841", "6372", "=q1=Swim Speed Potion", "=ds=#sr# 100", "=ds="..AL["Trainer"]};
				{ 4, "s4508", "4596", "=q1=Discolored Healing Potion", "=ds=#sr# 90", "=ds="..AL["No Longer Available"]};
				{ 5, "s2332", "2456", "=q1=Minor Rejuvenation Potion", "=ds=#sr# 90", "=ds="..AL["Trainer"]};
				{ 6, "s6617", "5631", "=q1=Rage Potion", "=ds=#sr# 60", "=ds="..AL["Vendor"]};
				{ 7, "s2335", "2459", "=q1=Swiftness Potion", "=ds=#sr# 60", "=ds="..AL["World Drop"]};
				{ 8, "s2337", "858", "=q1=Lesser Healing Potion", "=ds=#sr# 55", "=ds="..AL["Trainer"]};
				{ 9, "s2331", "2455", "=q1=Minor Mana Potion", "=ds=#sr# 25", "=ds="..AL["Trainer"]};
				{ 10, "s2330", "118", "=q1=Minor Healing Potion", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = ALCHEMY..": "..AL["Potions"],
			module = moduleName, menu = "ALCHEMYMENU",
		};
	};

	AtlasLoot_Data["AlchemyFlask"] = {
		["Normal"] = {
			{
				{ 1, "s80721", "58087", "=q1=Flask of the Winds", "=ds=#sr# 510", "=ds="..AL["Trainer"]};
				{ 2, "s80723", "58088", "=q1=Flask of Titanic Strength", "=ds=#sr# 510", "=ds="..AL["Trainer"]};
				{ 3, "s80720", "58086", "=q1=Flask of the Draconic Mind", "=ds=#sr# 505", "=ds="..AL["Trainer"]};
				{ 4, "s80724", "58149", "=q3=Flask of Enhancement", "=ds=#sr# 500", "=ds="..AL["Trainer"]};
				{ 5, "s94162", "67438", "=q1=Flask of Flowing Water", "=ds=#sr# 500", "=ds="..AL["Trainer"]};
				{ 6, "s80719", "58085", "=q1=Flask of Steelskin", "=ds=#sr# 500", "=ds="..AL["Trainer"]};
				{ 8, "s53903", "46377", "=q1=Flask of Endless Rage", "=ds=#sr# 435", "=ds="..AL["Trainer"]};
				{ 9, "s54213", "46378", "=q1=Flask of Pure Mojo", "=ds=#sr# 435", "=ds="..AL["Trainer"]};
				{ 10, "s53902", "46379", "=q1=Flask of Stoneblood", "=ds=#sr# 435", "=ds="..AL["Trainer"]};
				{ 11, "s53901", "46376", "=q1=Flask of the Frost Wyrm", "=ds=#sr# 435", "=ds="..AL["Trainer"]};
				{ 12, "s67025", "47499", "=q3=Flask of the North", "=ds=#sr# 425", "=ds="..AL["Trainer"]};
				{ 13, "s62213", "44939", "=q1=Lesser Flask of Resistance", "=ds=#sr# 385", "=ds="..AL["Trainer"]};
				{ 14, "s53899", "40079", "=q1=Lesser Flask of Toughness", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
				{ 16, "s42736", "33208", "=q1=Flask of Chromatic Wonder", "=ds=#sr# 375", "=ds="..BabbleFaction["The Violet Eye"].." - "..BabbleFaction["Honored"]};
				{ 17, "s28590", "22861", "=q1=Flask of Blinding Light", "=ds=#sr# 300", "=ds="..AL["Discovery"]};
				{ 18, "s28587", "22851", "=q1=Flask of Fortification", "=ds=#sr# 300", "=ds="..AL["Discovery"]};
				{ 19, "s28588", "22853", "=q1=Flask of Mighty Restoration", "=ds=#sr# 300", "=ds="..AL["Discovery"]};
				{ 20, "s28591", "22866", "=q1=Flask of Pure Death", "=ds=#sr# 300", "=ds="..AL["Discovery"]};
				{ 21, "s28589", "22854", "=q1=Flask of Relentless Assault", "=ds=#sr# 300", "=ds="..AL["Discovery"]};
				{ 23, "s17638", "13513", "=q1=Flask of Chromatic Resistance", "=ds=#sr# 300", "=ds="..BabbleFaction["Lower City"].." - "..BabbleFaction["Exalted"]};
				{ 24, "s17636", "13511", "=q1=Flask of Distilled Wisdom", "=ds=#sr# 300", "=ds="..BabbleFaction["Cenarion Expedition"].." - "..BabbleFaction["Exalted"]};
				{ 25, "s17637", "13512", "=q1=Flask of Supreme Power", "=ds=#sr# 300", "=ds="..BabbleFaction["Keepers of Time"].." - "..BabbleFaction["Exalted"]};
				{ 26, "s17635", "13510", "=q1=Flask of the Titans", "=ds=#sr# 300", "=ds="..BabbleFaction["The Sha'tar"].." - "..BabbleFaction["Exalted"]};
			};
		};
		info = {
			name = ALCHEMY..": "..AL["Flasks"],
			module = moduleName, menu = "ALCHEMYMENU",
		};
	};

	AtlasLoot_Data["AlchemyTransmute"] = {
		["Normal"] = {
			{
				--{ 1, "s101823", "71807", "=q3=Transmute: Deepholm Iolite", "=ds=#sr# 525", "=ds="};
				--{ 2, "s101824", "71810", "=q3=Transmute: Elven Peridot", "=ds=#sr# 525", "=ds="};
				--{ 3, "s101825", "71808", "=q3=Transmute: Lava Coral", "=ds=#sr# 525", "=ds="};
				--{ 4, "s101828", "71806", "=q3=Transmute: Lightstone", "=ds=#sr# 525", "=ds="};
				--{ 5, "s101827", "71805", "=q3=Transmute: Queen's Garnet", "=ds=#sr# 525", "=ds="};
				--{ 6, "s101826", "71809", "=q3=Transmute: Shadow Spinel", "=ds=#sr# 525", "=ds="};
				{ 1, "s80245", "52190", "=q3=Transmute: Inferno Ruby", "=ds=#sr# 525", "=ds="..AL["Trainer"]};
				{ 2, "s80237", "52303", "=q3=Transmute: Shadowspirit Diamond", "=ds=#sr# 525", "=ds="..AL["Trainer"]};
				{ 3, "s80247", "52195", "=q3=Transmute: Amberjewel", "=ds=#sr# 520", "=ds="..AL["Trainer"]};
				{ 4, "s80248", "52194", "=q3=Transmute: Demonseye", "=ds=#sr# 515", "=ds="..AL["Trainer"]};
				{ 5, "s80246", "52191", "=q3=Transmute: Ocean Sapphire", "=ds=#sr# 515", "=ds="..AL["Trainer"]};
				{ 6, "s80250", "52193", "=q3=Transmute: Ember Topaz", "=ds=#sr# 510", "=ds="..AL["Trainer"]};
				{ 7, "s80251", "52192", "=q3=Transmute: Dream Emerald", "=ds=#sr# 505", "=ds="..AL["Trainer"]};
				{ 16, "s80243", "58480", "=q2=Transmute: Truegold", "=ds=#sr# 525", "=ds="..AL["Trainer"]};
				{ 17, "s80244", "51950", "=q2=Transmute: Pyrium Bar", "=ds=#sr# 520", "=ds="..AL["Trainer"]};
				{ 19, "s78866", "54464", "=q1=Transmute: Living Elements", "=ds=#sr# 485", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, "s66658", "36931", "=q4=Transmute: Ametrine", "=ds=#sr# 450", "=ds="..AL["Trainer"]};
				{ 2, "s66662", "36928", "=q4=Transmute: Dreadstone", "=ds=#sr# 450", "=ds="..AL["Trainer"]};
				{ 3, "s66664", "36934", "=q4=Transmute: Eye of Zul", "=ds=#sr# 450", "=ds="..AL["Trainer"]};
				{ 4, "s66660", "36922", "=q4=Transmute: King's Amber", "=ds=#sr# 450", "=ds="..AL["Trainer"]};
				{ 5, "s66663", "36925", "=q4=Transmute: Majestic Zircon", "=ds=#sr# 450", "=ds="..AL["Trainer"]};
				{ 6, "s66659", "36919", "=q4=Transmute: Cardinal Ruby", "=ds=#sr# 440", "=ds="..AL["Quest Reward"]};
				{ 8, "s57425", "41266", "=q3=Transmute: Skyflare Diamond", "=ds=#sr# 430", "=ds="..AL["Trainer"]};
				{ 9, "s57427", "41334", "=q3=Transmute: Earthsiege Diamond", "=ds=#sr# 425", "=ds="..AL["Trainer"]};
				{ 12, "s60350", "41163", "=q2=Transmute: Titanium", "=ds=#sr# 395", "=ds="..AL["Trainer"]};
				{ 16, "s53777", "35624", "=q2=Transmute: Eternal Air to Earth", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 17, "s53776", "35622", "=q2=Transmute: Eternal Air to Water", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 18, "s53781", "35623", "=q2=Transmute: Eternal Earth to Air", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 19, "s53782", "35627", "=q2=Transmute: Eternal Earth to Shadow", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 20, "s53775", "35625", "=q2=Transmute: Eternal Fire to Life", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 21, "s53774", "35622", "=q2=Transmute: Eternal Fire to Water", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 22, "s53773", "36860", "=q2=Transmute: Eternal Life to Fire", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 23, "s53771", "35627", "=q2=Transmute: Eternal Life to Shadow", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 24, "s53779", "35624", "=q2=Transmute: Eternal Shadow to Earth", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 25, "s53780", "35625", "=q2=Transmute: Eternal Shadow to Life", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 26, "s53783", "35623", "=q2=Transmute: Eternal Water to Air", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
				{ 27, "s53784", "36860", "=q2=Transmute: Eternal Water to Fire", "=ds=#sr# 400", "=ds="..AL["Discovery"]};
			};
			{
				{ 1, "s29688", "23571", "=q3=Transmute: Primal Might", "=ds=#sr# 350", "=ds="..AL["Vendor"]};
				{ 2, "s32765", "25867", "=q3=Transmute: Earthstorm Diamond", "=ds=#sr# 350", "=ds="..BabbleFaction["Cenarion Expedition"].." - "..BabbleFaction["Honored"]};
				{
					{ 3, "s32766", "25868", "=q3=Transmute: Skyfire Diamond", "=ds=#sr# 350", "=ds="..BabbleFaction["Thrallmar"].." - "..BabbleFaction["Honored"] };
					{ 3, "s32766", "25868", "=q3=Transmute: Skyfire Diamond", "=ds=#sr# 350", "=ds="..BabbleFaction["Honor Hold"].." - "..BabbleFaction["Honored"] };
				};
				{ 5, "s28585", "21886", "=q2=Transmute: Primal Earth to Life", "=ds=#sr# 300", "=ds="..AL["Discovery"]};
				{ 6, "s28583", "22457", "=q2=Transmute: Primal Fire to Mana", "=ds=#sr# 300", "=ds="..AL["Discovery"]};
				{ 7, "s28584", "22452", "=q2=Transmute: Primal Life to Earth", "=ds=#sr# 300", "=ds="..AL["Discovery"]};
				{ 8, "s28582", "21884", "=q2=Transmute: Primal Mana to Fire", "=ds=#sr# 300", "=ds="..AL["Discovery"]};
				{ 9, "s28580", "21885", "=q2=Transmute: Primal Shadow to Water", "=ds=#sr# 300", "=ds="..AL["Discovery"]};
				{ 10, "s28581", "22456", "=q2=Transmute: Primal Water to Shadow", "=ds=#sr# 300", "=ds="..AL["Discovery"]};
				{ 11, "s28566", "21884", "=q2=Transmute: Primal Air to Fire", "=ds=#sr# 350", "=ds="..BabbleFaction["The Sha'tar"].." - "..BabbleFaction["Revered"]};
				{ 12, "s28567", "21885", "=q2=Transmute: Primal Earth to Water", "=ds=#sr# 350", "=ds="..BabbleFaction["Sporeggar"].." - "..BabbleFaction["Revered"]};
				{
					{ 13, "s28568", "22452", "=q2=Transmute: Primal Fire to Earth", "=ds=#sr# 350", "=ds="..BabbleFaction["The Mag'har"].." - "..BabbleFaction["Revered"] };
					{ 13, "s28568", "22452", "=q2=Transmute: Primal Fire to Earth", "=ds=#sr# 350", "=ds="..BabbleFaction["Kurenai"].." - "..BabbleFaction["Revered"] };
				};
				{ 14, "s28569", "22451", "=q2=Transmute: Primal Water to Air", "=ds=#sr# 350", "=ds="..BabbleFaction["Cenarion Expedition"].." - "..BabbleFaction["Revered"]};
				{ 16, "s17187", "12360", "=q2=Transmute: Arcanite", "=ds=#sr# 275", "=ds="..AL["Vendor"]..": "..BabbleZone["Tanaris"]};
				{ 17, "s11479", "3577", "=q2=Transmute: Iron to Gold", "=ds=#sr# 225", "=ds="..AL["Vendor"]..": "..BabbleZone["Tanaris"]};
				{ 18, "s11480", "6037", "=q2=Transmute: Mithril to Truesilver", "=ds=#sr# 225", "=ds="..AL["Vendor"]..": "..BabbleZone["Tanaris"]};
				{ 20, "s25146", "7068", "=q1=Transmute: Elemental Fire", "=ds=#sr# 300", "=ds="..AL["Vendor"]..": "..BabbleZone["Blackrock Depths"]};
				{ 21, "s17559", "7078", "=q2=Transmute: Air to Fire", "=ds=#sr# 275", "=ds="..BabbleFaction["Argent Dawn"].." - "..BabbleFaction["Honored"]};
				{ 22, "s17566", "12803", "=q2=Transmute: Earth to Life", "=ds=#sr# 275", "=ds="..AL["World Drop"]};
				{ 23, "s17561", "7080", "=q2=Transmute: Earth to Water", "=ds=#sr# 275", "=ds="..AL["Vendor"]..": "..BabbleZone["Felwood"]};
				{ 24, "s17560", "7076", "=q2=Transmute: Fire to Earth", "=ds=#sr# 275", "=ds="..AL["Vendor"]..": "..BabbleZone["Blackrock Depths"]};
				{ 25, "s17565", "7076", "=q2=Transmute: Life to Earth", "=ds=#sr# 275", "=ds="..AL["World Drop"]};
				{ 26, "s17563", "7080", "=q2=Transmute: Undeath to Water", "=ds=#sr# 275", "=ds="..AL["World Drop"]};
				{ 27, "s17562", "7082", "=q2=Transmute: Water to Air", "=ds=#sr# 275", "=ds="..AL["Vendor"]..": "..BabbleZone["Western Plaguelands"]};
				{ 28, "s17564", "12808", "=q2=Transmute: Water to Undeath", "=ds=#sr# 275", "=ds="..AL["World Drop"]};
			};
		};
		info = {
			name = ALCHEMY..": "..AL["Transmutes"],
			module = moduleName, menu = "ALCHEMYMENU",
		};
	};

	AtlasLoot_Data["AlchemyCauldron"] = {
		["Normal"] = {
			{
				{ 1, "s92688", "65460", "=q1=Big Cauldron of Battle", "=ds=#sr# 525", "=ds="..AL["Guild"].." - "..BabbleFaction["Friendly"]};
				{ 2, "s92643", "62288", "=q1=Cauldron of Battle", "=ds=#sr# 525", "=ds="..AL["Guild"].." - "..BabbleFaction["Friendly"]};
				{ 16, "s41458", "32839", "=q1=Cauldron of Major Arcane Protection Potion", "=ds=#sr# 300", "=ds="..AL["Discovery"]};
				{ 17, "s41500", "32849", "=q1=Cauldron of Major Fire Protection Potion", "=ds=#sr# 300", "=ds="..AL["Discovery"]};
				{ 18, "s41501", "32850", "=q1=Cauldron of Major Frost Protection Potion", "=ds=#sr# 300", "=ds="..AL["Discovery"]};
				{ 19, "s41502", "32851", "=q1=Cauldron of Major Nature Protection Potion", "=ds=#sr# 300", "=ds="..AL["Discovery"]};
				{ 20, "s41503", "32852", "=q1=Cauldron of Major Shadow Protection Potion", "=ds=#sr# 300", "=ds="..AL["Discovery"]};
			};
		};
		info = {
			name = ALCHEMY..": "..AL["Cauldron"],
			module = moduleName, menu = "ALCHEMYMENU",
		};
	};

	AtlasLoot_Data["AlchemyOil"] = {
		["Normal"] = {
			{
				{ 2, "s80486", "56850", "=q1=Deepstone Oil", "=ds=#sr# 470", "=ds="..AL["Trainer"]};
				{ 3, "s62409", "44958", "=q1=Ethereal Oil", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
				{ 4, "s53812", "40195", "=q1=Pygmy Oil", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
				{ 5, "s17551", "13423", "=q1=Stonescale Oil", "=ds=#sr# 250", "=ds="..AL["Trainer"]};
				{ 6, "s11451", "8956", "=q1=Oil of Immolation", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 17, "s3454", "3829", "=q1=Frost Oil", "=ds=#sr# 200", "=ds="..AL["Vendor"]..": "..BabbleZone["Alterac Mountains"]};
				{ 18, "s3449", "3824", "=q1=Shadow Oil", "=ds=#sr# 165", "=ds="..AL["Vendor"]};
				{ 19, "s7837", "6371", "=q1=Fire Oil", "=ds=#sr# 130", "=ds="..AL["Trainer"]};
				{ 20, "s7836", "6370", "=q1=Blackmouth Oil", "=ds=#sr# 80", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = ALCHEMY..": "..AL["Oil"],
			module = moduleName, menu = "ALCHEMYMENU",
		};
	};

	AtlasLoot_Data["AlchemyMisc"] = {
		["Normal"] = {
			{
				{ 1, "s80508", "58483", "=q4=Lifebound Alchemist Stone", "=ds=#sr# 500", "=ds="..AL["Trainer"]};
				{ 2, "s96252", "68775", "=q4=Volatile Alchemist Stone", "=ds=#sr# 500", "=ds="..AL["Trainer"]};
				{ 3, "s96253", "68776", "=q4=Quicksilver Alchemist Stone", "=ds=#sr# 500", "=ds="..AL["Trainer"]};
				{ 4, "s96254", "68777", "=q4=Vibrant Alchemist Stone", "=ds=#sr# 500", "=ds="..AL["Trainer"]};
				{ 6, "s60403", "44323", "=q3=Indestructible Alchemist Stone", "=ds=#sr# 400", "=ds="..AL["Trainer"]};
				{ 7, "s60396", "44322", "=q3=Mercurial Alchemist Stone", "=ds=#sr# 400", "=ds="..AL["Trainer"]};
				{ 8, "s60405", "44324", "=q3=Mighty Alchemist Stone", "=ds=#sr# 400", "=ds="..AL["Trainer"]};
				{ 10, "s47050", "35751", "=q4=Assassin's Alchemist Stone", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Exalted"]};
				{ 11, "s47046", "35748", "=q4=Guardian's Alchemist Stone", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Exalted"]};
				{ 12, "s47049", "35750", "=q4=Redeemer's Alchemist Stone", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Exalted"]};
				{ 13, "s47048", "35749", "=q4=Sorcerer's Alchemist Stone", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Exalted"]};
				{ 14, "s17632", "13503", "=q4=Alchemist's Stone", "=ds=#sr# 350", "=ds="..BabbleFaction["The Sha'tar"].." - "..BabbleFaction["Revered"]};
				{ 16, "s38070", "31080", "=q2=Mercurial Stone", "=ds=#sr# 325", "=ds="..AL["Trainer"]};
				{ 17, "s11459", "9149", "=q2=Philosopher's Stone", "=ds=#sr# 225", "=ds="..AL["Vendor"]..": "..BabbleZone["Tanaris"]};
				{ 18, "s11456", "9061", "=q1=Goblin Rocket Fuel", "=ds=#sr# 210", "=ds="..AL["Crafted"]..": "..GetSpellInfo(4036)};
				{ 19, "s11473", "9210", "=q1=Ghost Dye", "=ds=#sr# 245", "=ds="..AL["Vendor"]..": "..BabbleZone["Feralas"]};
				{ 20, "s24266", "19931", "=q3=Gurubashi Mojo Madness", "=ds=#sr# 300", "=ds="..AL["No Longer Available"]};
			};
		};
		info = {
			name = ALCHEMY..": "..BabbleInventory["Miscellaneous"],
			module = moduleName, menu = "ALCHEMYMENU",
		};
	};

		-------------------
		--- Archaeology ---
		-------------------

	AtlasLoot_Data["ArchaeologyArmorAndWeapons"] = {
		["Normal"] = {
			{
				{ 2, "s90616", "64643", "=q4=Queen Azshara's Dressing Gown", "=ds="..AL["Night Elf"], "=ds=#s5#, #a1#"};
				{ 3, "s90843", "64644", "=q4=Headdress of the First Shaman", "=ds="..AL["Orc"], "=ds=#s1#, #a3#"};
				{ 4, "s92168", "64904", "=q4=Ring of the Boy Emperor", "=ds="..AL["Tol'vir"], "=ds=#s13#"};
				{ 5, "s91757", "64645", "=q4=Tyrande's Favorite Doll", "=ds="..AL["Night Elf"], "=ds=#s14#"};
				{ 17, "s92163", "64885", "=q4=Scimitar of the Sirocco", "=ds="..AL["Tol'vir"], "=ds=#h1#, #w10#"};
				{ 18, "s90608", "64377", "=q4=Zin'rokh, Destroyer of Worlds", "=ds="..AL["Troll"], "=ds=#h2#, #w10#"};
				{ 19, "s90997", "64460", "=q4=Nifflevar Bearded Axe", "=ds="..AL["Vrykul"], "=ds=#h1#, #w1#"};
				{ 20, "s92139", "64880", "=q4=Staff of Ammunae", "=ds="..AL["Tol'vir"], "=ds=#w9#"};
				{ 21, "s91227", "64489", "=q4=Staff of Sorcerer-Thane Thaurissan", "=ds="..AL["Dwarf"], "=ds=#w9#"};
				{ 22, "s98533", "69764", "=q4=Extinct Turtle Shell", "=ds="..AL["Fossil"], "=ds=#w8#"};
			};
		};
		info = {
			name = ARCHAEOLOGY,
			switchText = {AL["Culture"], AL["Slot"]},
			module = moduleName, menu = "ARCHAEOLOGYMENU"
		};
	};

	AtlasLoot_Data["ArchaeologyMisc"] = {
		["Normal"] = {
			{
				{ 2, 67538, "", "=q4=Recipe: Vial of the Sands", "=ds="..AL["Tol'vir"], "=ds=#p1# (525)"};
				{ 3, "s91214", "64481", "=q4=Blessing of the Old God", "=ds="..AL["Fossil"]};
				{ 4, "s91761", "64646", "=q4=Bones of Transformation", "=ds="..AL["Night Elf"]};
				{ 5, "s92145", "64881", "=q4=Pendant of the Scarab Storm", "=ds="..AL["Tol'vir"]};
				{ 6, "s91215", "64482", "=q4=Puzzle Box of Yogg-Saron", "=ds="..AL["Fossil"]};
				{ 7, "s91773", "64651", "=q4=Wisp Amulet", "=ds="..AL["Night Elf"]};
				{ 17, "s98560", "69776", "=q3=Ancient Amber", "=ds="..AL["Fossil"], "=ds="};
				{ 18, "s90983", "64456", "=q3=Arrival of the Naaru", "=ds="..AL["Draenei"]};
				{ 19, "s90553", "64373", "=q3=Chalice of the Mountain Kings", "=ds="..AL["Dwarf"]};
				{ 20, "s90493", "64361", "=q3=Druid and Priest Statue Set", "=ds="..AL["Night Elf"]};
				{ 21, "s98556", "69777", "=q3=Haunted War Drum", "=ds="..AL["Troll"]};
				{ 22, "s90464", "64358", "=q3=Highborne Soul Mirror", "=ds="..AL["Night Elf"]};
				{ 23, "s90614", "64383", "=q3=Kaldorei Wind Chimes", "=ds="..AL["Night Elf"]};
				{ 24, "s91226", "64488", "=q3=The Innkeeper's Daughter", "=ds="..AL["Dwarf"]};
				{ 25, "s90984", "64457", "=q3=The Last Relic of Argus", "=ds="..AL["Draenei"]};
				{ 26, "s98569", "69775", "=q3=Vrykul Drinking Horn", "=ds="..AL["Vrykul"]};
			};
		};
		info = {
			name = ARCHAEOLOGY,
			switchText = {AL["Culture"], AL["Slot"]},
			module = moduleName, menu = "ARCHAEOLOGYMENU"
		};
	};

	AtlasLoot_Data["ArchaeologyDwarf"] = {
		["Normal"] = {
			{
				{ 1, "s91227", "64489", "=q4=Staff of Sorcerer-Thane Thaurissan", "=ds=#sr# 450", "=ds=#w9#"};
				{ 3, "s90521", "64372", "=q3=Clockwork Gnome", "=ds=#sr# 225", "=ds=#e13#"};
				{ 4, "s90553", "64373", "=q3=Chalice of the Mountain Kings", "=ds=#sr# 150"};
				{ 5, "s91226", "64488", "=q3=The Innkeeper's Daughter", "=ds=#sr# 150"};
				{ 7, "s88910", "63113", "=q0=Belt Buckle with Anvilmar Crest", "=ds=#sr# 1"};
				{ 8, "s90411", "64339", "=q0=Bodacious Door Knocker", "=ds=#sr# 1"};
				{ 9, "s86866", "63112", "=q0=Bone Gaming Dice", "=ds=#sr# 1"};
				{ 10, "s90412", "64340", "=q0=Boot Heel with Scrollwork", "=ds=#sr# 1"};
				{ 11, "s86864", "63409", "=q0=Ceramic Funeral Urn", "=ds=#sr# 1"};
				{ 12, "s90504", "64362", "=q0=Dented Shield of Horuz Killcrow", "=ds=#sr# 1", "#ACHIEVEMENTID:5193#"};
				{ 13, "s93440", "66054", "=q0=Dwarven Baby Socks", "=ds=#sr# 1"};
				{ 14, "s90413", "64342", "=q0=Golden Chamber Pot", "=ds=#sr# 1"};
				{ 15, "s90419", "64344", "=q0=Ironstar's Petrified Shield", "=ds=#sr# 1", "#ACHIEVEMENTID:4859#"};
				{ 16, "s90518", "64368", "=q0=Mithril Chain of Angerforge", "=ds=#sr# 1", "#ACHIEVEMENTID:4859#"};
				{ 17, "s89717", "63414", "=q0=Moltenfist's Jeweled Goblet", "=ds=#sr# 1", "#ACHIEVEMENTID:4859#"};
				{ 18, "s90410", "64337", "=q0=Notched Sword of Tunadil the Redeemer", "=ds=#sr# 1", "#ACHIEVEMENTID:5193#"};
				{ 19, "s86857", "63408", "=q0=Pewter Drinking Cup", "=ds=#sr# 1"};
				{ 20, "s91793", "64659", "=q0=Pipe of Franclorn Forgewright", "=ds=#sr# 1"};
				{ 21, "s91225", "64487", "=q0=Scepter of Bronzebeard", "=ds=#sr# 1", "#ACHIEVEMENTID:4858#"};
				{ 22, "s90509", "64367", "=q0=Scepter of Charlga Razorflank", "=ds=#sr# 1", "#ACHIEVEMENTID:4858#"};
				{ 23, "s90506", "64366", "=q0=Scorched Staff of Shadow Priest Anund", "=ds=#sr# 1", "#ACHIEVEMENTID:5193#"};
				{ 24, "s91219", "64483", "=q0=Silver Kris of Korl", "=ds=#sr# 1", "#ACHIEVEMENTID:5193#"};
				{ 25, "s88181", "63411", "=q0=Silver Neck Torc", "=ds=#sr# 1"};
				{ 26, "s90519", "64371", "=q0=Skull Staff of Shadowforge", "=ds=#sr# 1", "#ACHIEVEMENTID:4859#"};
				{ 27, "s91223", "64485", "=q0=Spiked Gauntlets of Anvilrage", "=ds=#sr# 1", "#ACHIEVEMENTID:4859#"};
				{ 28, "s88180", "63410", "=q0=Stone Gryphon", "=ds=#sr# 1"};
				{ 29, "s91221", "64484", "=q0=Warmaul of Burningeye", "=ds=#sr# 1", "#ACHIEVEMENTID:4859#"};
				{ 30, "s90415", "64343", "=q0=Winged Helm of Corehammer", "=ds=#sr# 1", "#ACHIEVEMENTID:4859#"};
			};
			{
				{ 1, "s88909", "63111", "=q0=Wooden Whistle", "=ds=#sr# 1"};
				{ 2, "s91224", "64486", "=q0=Word of Empress Zoe", "=ds=#sr# 1"};
				{ 3, "s86865", "63110", "=q0=Worn Hunting Knife", "=ds=#sr# 1"};
			};
		};
		info = {
			name = ARCHAEOLOGY..": "..AL["Dwarf"],
			switchText = {AL["Skill"], AL["Description"]},
			module = moduleName, menu = "ARCHAEOLOGYMENU"
		};
	};

	AtlasLoot_Data["ArchaeologyNightElf"] = {
		["Normal"] = {
			{
				{ 1, "s91757", "64645", "=q4=Tyrande's Favorite Doll", "=ds=#sr# 450", "=ds=#s14#"};
				{ 2, "s91761", "64646", "=q4=Bones of Transformation", "=ds=#sr# 450", "=ds="};
				{ 3, "s91773", "64651", "=q4=Wisp Amulet", "=ds=#sr# 450"};
				{ 4, "s90616", "64643", "=q4=Queen Azshara's Dressing Gown", "=ds=#sr# 225", "=ds=#s5#, #a1#"};
				{ 6, "s91762", "64647", "=q0=Carcanet of the Hundred Magi", "=ds=#sr# 450"};
				{ 7, "s91766", "64648", "=q0=Silver Scroll Case", "=ds=#sr# 450", "#ACHIEVEMENTID:5191#"};
				{ 8, "s91769", "64650", "=q0=Umbra Crescent", "=ds=#sr# 450"};
				{ 9, "s90610", "64379", "=q0=Chest of Tiny Glass Animals", "=ds=#sr# 1", "#ACHIEVEMENTID:5191#"};
				{ 10, "s89696", "63407", "=q0=Cloak Clasp with Antlers", "=ds=#sr# 1", "#ACHIEVEMENTID:5191#"};
				{ 11, "s89893", "63525", "=q0=Coin from Eldre'Thalas", "=ds=#sr# 1"};
				{ 12, "s90611", "64381", "=q0=Cracked Crystal Vial", "=ds=#sr# 1", "#ACHIEVEMENTID:5191#"};
				{ 13, "s90458", "64357", "=q0=Delicate Music Box", "=ds=#sr# 1", "#ACHIEVEMENTID:5191#"};
				{ 14, "s89896", "63528", "=q0=Green Dragon Ring", "=ds=#sr# 1"};
				{ 16, "s90614", "64383", "=q3=Kaldorei Wind Chimes", "=ds=#sr# 250"};
				{ 17, "s90493", "64361", "=q3=Druid and Priest Statue Set", "=ds=#sr# 150"};
				{ 18, "s90464", "64358", "=q3=Highborne Soul Mirror", "=ds=#sr# 150"};
				{ 21, "s90453", "64356", "=q0=Hairpin of Silver and Malachite", "=ds=#sr# 1", "#ACHIEVEMENTID:5191#"};
				{ 22, "s89009", "63129", "=q0=Highborne Pyxis", "=ds=#sr# 1"};
				{ 23, "s89012", "63130", "=q0=Inlaid Ivory Comb", "=ds=#sr# 1"};
				{ 24, "s90451", "64354", "=q0=Kaldorei Amphora", "=ds=#sr# 1"};
				{ 25, "s93441", "66055", "=q0=Necklace with Elune Pendant", "=ds=#sr# 1"};
				{ 26, "s89014", "63131", "=q0=Scandalous Silk Nightgown", "=ds=#sr# 1"};
				{ 27, "s90612", "64382", "=q0=Scepter of Xavius", "=ds=#sr# 1", "#ACHIEVEMENTID:4858#"};
				{ 28, "s89894", "63526", "=q0=Shattered Glaive", "=ds=#sr# 1"};
				{ 29, "s90609", "64378", "=q0=String of Small Pink Pearls", "=ds=#sr# 1"};
			};
		};
		info = {
			name = ARCHAEOLOGY..": "..AL["Night Elf"],
			switchText = {AL["Skill"], AL["Description"]},
			module = moduleName, menu = "ARCHAEOLOGYMENU"
		};
	};

	AtlasLoot_Data["ArchaeologyFossil"] = {
		["Normal"] = {
			{
				{ 2, "s98533", "69764", "=q4=Extinct Turtle Shell", "=ds=#sr# 150", "=ds=#w8#"};
				{ 3, "s90619", "60954", "=q4=Fossilized Raptor", "=ds=#sr# 150", "=ds=#e26#"};
				{ 6, "s91132", "64473", "=q0=Imprint of a Kraken Tentacle", "=ds=#sr# 300"};
				{ 7, "s91089", "64468", "=q0=Proto-Drake Skeleton", "=ds=#sr# 300"};
				{ 8, "s90452", "64355", "=q0=Ancient Shark Jaws", "=ds=#sr# 1"};
				{ 9, "s88930", "63121", "=q0=Beautiful Preserved Fern", "=ds=#sr# 1"};
				{ 10, "s88929", "63109", "=q0=Black Trilobite", "=ds=#sr# 1"};
				{ 11, "s90432", "64349", "=q0=Devilsaur Tooth", "=ds=#sr# 1"};
				{ 17, "s98582", "69821", "=q3=Pterrordax Hatchling", "=ds=#sr# 120", "=ds=#e13#"};
				{ 18, "s98560", "69776", "=q3=Ancient Amber", "=ds=#sr# 100", "=ds="};
				{ 19, "s89693", "60955", "=q3=Fossilized Hatchling", "=ds=#sr# 75", "=ds=#e13#"};
				{ 21, "s90617", "64385", "=q0=Feathered Raptor Arm", "=ds=#sr# 1"};
				{ 22, "s90433", "64350", "=q0=Insect in Amber", "=ds=#sr# 1"};
				{ 23, "s93442", "66056", "=q0=Shard of Petrified Wood", "=ds=#sr# 1"};
				{ 24, "s93443", "66057", "=q0=Strange Velvet Worm", "=ds=#sr# 1"};
				{ 25, "s89895", "63527", "=q0=Twisted Ammonite Shell", "=ds=#sr# 1"};
				{ 26, "s90618", "64387", "=q0=Vicious Ancient Fish", "=ds=#sr# 1"};
			};
		};
		info = {
			name = ARCHAEOLOGY..": "..AL["Fossil"],
			switchText = {AL["Skill"], AL["Description"]},
			module = moduleName, menu = "ARCHAEOLOGYMENU"
		};
	};

	AtlasLoot_Data["ArchaeologyTroll"] = {
		["Normal"] = {
			{
				{ 2, "s90608", "64377", "=q4=Zin'rokh, Destroyer of Worlds", "=ds=#sr# 450", "=ds=#h2#, #w10#"};
				{ 5, "s90429", "64348", "=q0=Atal'ai Scepter", "=ds=#sr# 1", "#ACHIEVEMENTID:4858#"};
				{ 6, "s90421", "64346", "=q0=Bracelet of Jade and Coins", "=ds=#sr# 1"};
				{ 7, "s89891", "63524", "=q0=Cinnabar Bijou", "=ds=#sr# 1"};
				{ 8, "s90581", "64375", "=q0=Drakkari Sacrificial Knife", "=ds=#sr# 1"};
				{ 9, "s89890", "63523", "=q0=Eerie Smolderthorn Idol", "=ds=#sr# 1"};
				{ 10, "s89711", "63413", "=q0=Feathered Gold Earring", "=ds=#sr# 1"};
				{ 11, "s88907", "63120", "=q0=Fetish of Hir'eek", "=ds=#sr# 1"};
				{ 17, "s98588", "69824", "=q3=Voodoo Figurine", "=ds=#sr# 100", "=ds=#e13#"};
				{ 18, "s98556", "69777", "=q3=Haunted War Drum", "=ds=#sr# 100"};
				{ 20, "s93444", "66058", "=q0=Fine Bloodscalp Dinnerware", "=ds=#sr# 1"};
				{ 21, "s90423", "64347", "=q0=Gahz'rilla Figurine", "=ds=#sr# 1"};
				{ 22, "s89701", "63412", "=q0=Jade Asp with Ruby Eyes", "=ds=#sr# 1"};
				{ 23, "s88908", "63118", "=q0=Lizard Foot Charm", "=ds=#sr# 1"};
				{ 24, "s90420", "64345", "=q0=Skull-Shaped Planter", "=ds=#sr# 1"};
				{ 25, "s90558", "64374", "=q0=Tooth with Gold Filling", "=ds=#sr# 1"};
				{ 26, "s88262", "63115", "=q0=Zandalari Voodoo Doll", "=ds=#sr# 1"};
			};
		};
		info = {
			name = ARCHAEOLOGY..": "..AL["Troll"],
			switchText = {AL["Skill"], AL["Description"]},
			module = moduleName, menu = "ARCHAEOLOGYMENU"
		};
	};

	AtlasLoot_Data["ArchaeologyOrc"] = {
		["Normal"] = {
			{
				{ 2, "s90843", "64644", "=q4=Headdress of the First Shaman", "=ds=#sr# 300", "=ds=#s1#, #a3#"};
				{ 4, "s90831", "64436", "=q0=Fiendish Whip", "=ds=#sr# 300"};
				{ 5, "s90734", "64421", "=q0=Fierce Wolf Figurine", "=ds=#sr# 300"};
				{ 6, "s90728", "64418", "=q0=Gray Candle Stub", "=ds=#sr# 300", "#ACHIEVEMENTID:5192#" };
				{ 7, "s90720", "64417", "=q0=Maul of Stone Guard Mur'og", "=ds=#sr# 300", "#ACHIEVEMENTID:5192#" };
				{ 8, "s90730", "64419", "=q0=Rusted Steak Knife", "=ds=#sr# 300", "#ACHIEVEMENTID:5192#" };
				{ 19, "s90732", "64420", "=q0=Scepter of Nekros Skullcrusher", "=ds=#sr# 300", "#ACHIEVEMENTID:4858#" };
				{ 20, "s90833", "64438", "=q0=Skull Drinking Cup", "=ds=#sr# 300"};
				{ 21, "s90832", "64437", "=q0=Tile of Glazed Clay", "=ds=#sr# 300"};
				{ 22, "s90622", "64389", "=q0=Tiny Bronze Scorpion", "=ds=#sr# 300", "#ACHIEVEMENTID:5192#" };
			};
		};
		info = {
			name = ARCHAEOLOGY..": "..AL["Orc"],
			switchText = {AL["Skill"], AL["Description"]},
			module = moduleName, menu = "ARCHAEOLOGYMENU"
		};
	};

	AtlasLoot_Data["ArchaeologyDraenei"] = {
		["Normal"] = {
			{
				{ 2, "s90983", "64456", "=q3=Arrival of the Naaru", "=ds=#sr# 300" };
				{ 4, "s90853", "64440", "=q0=Anklet with Golden Bells", "=ds=#sr# 300"};
				{ 5, "s90968", "64453", "=q0=Baroque Sword Scabbard", "=ds=#sr# 300"};
				{ 6, "s90860", "64442", "=q0=Carved Harp of Exotic Wood", "=ds=#sr# 300"};
				{ 7, "s90975", "64455", "=q0=Dignified Portrait", "=ds=#sr# 300"};
				{ 17, "s90984", "64457", "=q3=The Last Relic of Argus", "=ds=#sr# 300" };
				{ 19, "s90974", "64454", "=q0=Fine Crystal Candelabra", "=ds=#sr# 300"};
				{ 20, "s90987", "64458", "=q0=Plated Elekk Goad", "=ds=#sr# 300"};
				{ 21, "s90864", "64444", "=q0=Scepter of the Nathrezim", "=ds=#sr# 300", "#ACHIEVEMENTID:4858#"};
				{ 22, "s90861", "64443", "=q0=Strange Silver Paperweight", "=ds=#sr# 300"};
			};
		};
		info = {
			name = ARCHAEOLOGY..": "..AL["Draenei"],
			switchText = {AL["Skill"], AL["Description"]},
			module = moduleName, menu = "ARCHAEOLOGYMENU"
		};
	};

	AtlasLoot_Data["ArchaeologyVrykul"] = {
		["Normal"] = {
			{
				{ 2, "s90997", "64460", "=q4=Nifflevar Bearded Axe", "=ds=#sr# 375", "=ds=#h1#, #w1#" };
				{ 4, "s91014", "64464", "=q0=Fanged Cloak Pin", "=ds=#sr# 375"};
				{ 5, "s91012", "64462", "=q0=Flint Striker", "=ds=#sr# 375"};
				{ 6, "s90988", "64459", "=q0=Intricate Treasure Chest Key", "=ds=#sr# 375"};
				{ 17, "s98569", "69775", "=q3=Vrykul Drinking Horn", "=ds=#sr# 100" };
				{ 19, "s91008", "64461", "=q0=Scramseax", "=ds=#sr# 375"};
				{ 20, "s91084", "64467", "=q0=Thorned Necklace", "=ds=#sr# 375"};
			};
		};
		info = {
			name = ARCHAEOLOGY..": "..AL["Vrykul"],
			switchText = {AL["Skill"], AL["Description"]},
			module = moduleName, menu = "ARCHAEOLOGYMENU"
		};
	};

	AtlasLoot_Data["ArchaeologyNerubian"] = {
		["Normal"] = {
			{
				{ 2, "s91214", "64481", "=q4=Blessing of the Old God", "=ds=#sr# 375"};
				{ 4, "s91209", "64479", "=q0=Ewer of Jormungar Blood", "=ds=#sr# 375"};
				{ 5, "s91191", "64477", "=q0=Gruesome Heart Box", "=ds=#sr# 375"};
				{ 6, "s91188", "64476", "=q0=Infested Ruby Ring", "=ds=#sr# 375"};
				{ 7, "s91170", "64475", "=q0=Scepter of Nezar'Azret", "=ds=#sr# 375", "#ACHIEVEMENTID:4858#"};
				{ 17, "s91215", "64482", "=q4=Puzzle Box of Yogg-Saron", "=ds=#sr# 375"};
				{ 19, "s91197", "64478", "=q0=Six-Clawed Cornice", "=ds=#sr# 375"};
				{ 20, "s91133", "64474", "=q0=Spidery Sundial", "=ds=#sr# 375"};
				{ 21, "s91211", "64480", "=q0=Vizier's Scrawled Streamer", "=ds=#sr# 375"};
			};
		};
		info = {
			name = ARCHAEOLOGY..": "..AL["Nerubian"],
			switchText = {AL["Skill"], AL["Description"]},
			module = moduleName, menu = "ARCHAEOLOGYMENU"
		};
	};

	AtlasLoot_Data["ArchaeologyTolvir"] = {
		["Normal"] = {
			{
				{ 1, 67538, "", "=q4=Recipe: Vial of the Sands", "=ds=#sr# 450", "=ds=#p1# (525)"};
				{ 2, "s92168", "64904", "=q4=Ring of the Boy Emperor", "=ds=#sr# 450", "=ds=#s13#"};
				{ 3, "s92163", "64885", "=q4=Scimitar of the Sirocco", "=ds=#sr# 450", "=ds=#h1#, #w10#"};
				{ 4, "s92139", "64880", "=q4=Staff of Ammunae", "=ds=#sr# 450", "=ds=#w9#"};
				{ 6, "s91790", "64657", "=q1=Canopic Jar", "=ds=#sr# 450"};
				{ 7, "s91775", "64652", "=q0=Castle of Sand", "=ds=#sr# 450"};
				{ 8, "s91779", "64653", "=q0=Cat Statue with Emerald Eyes", "=ds=#sr# 450"};
				{ 9, "s91785", "64656", "=q0=Engraved Scimitar Hilt", "=ds=#sr# 450"};
				{ 16, "s92137", "60847", "=q4=Crawling Claw", "=ds=#sr# 450", "=ds=#e13#"};
				{ 17, "s92148", "64883", "=q4=Scepter of Azj'Aqir", "=ds=#sr# 450", "=ds=#e12#"};
				{ 18, "s92145", "64881", "=q4=Pendant of the Scarab Storm", "=ds=#sr# 450", "=ds="};
				{ 21, "s91792", "64658", "=q0=Sketch of a Desert Palace", "=ds=#sr# 450"};
				{ 22, "s91780", "64654", "=q0=Soapstone Scarab Necklace", "=ds=#sr# 450"};
				{ 23, "s91782", "64655", "=q0=Tiny Oasis Mosaic", "=ds=#sr# 450"};
			};
		};
		info = {
			name = ARCHAEOLOGY..": "..AL["Tol'vir"],
			switchText = {AL["Skill"], AL["Description"]},
			module = moduleName, menu = "ARCHAEOLOGYMENU"
		};
	};

		---------------------
		--- Blacksmithing ---
		---------------------

	AtlasLoot_Data["SmithingArmorOld"] = {
		["Normal"] = {
			{
				{ 1, "s27589", "22194", "=q4=Black Grasp of the Destroyer", "=ds=#sr# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Ruins of Ahn'Qiraj"]};
				{ 2, "s24399", "20039", "=q4=Dark Iron Boots", "=ds=#sr# 300", "=ds="..BabbleFaction["Thorium Brotherhood"].." - "..BabbleFaction["Exalted"]};
				{ 3, "s23637", "19164", "=q4=Dark Iron Gauntlets", "=ds=#sr# 300", "=ds="..BabbleFaction["Thorium Brotherhood"].." - "..BabbleFaction["Revered"]};
				{ 4, "s23636", "19148", "=q4=Dark Iron Helm", "=ds=#sr# 300", "=ds="..BabbleFaction["Thorium Brotherhood"].." - "..BabbleFaction["Honored"]};
				{ 5, "s20876", "17013", "=q4=Dark Iron Leggings", "=ds=#sr# 300", "=ds="..BabbleFaction["Thorium Brotherhood"].." - "..BabbleFaction["Revered"]};
				{ 6, "s20873", "16988", "=q4=Fiery Chain Shoulders", "=ds=#sr# 300", "=ds="..BabbleFaction["Thorium Brotherhood"].." - "..BabbleFaction["Revered"]};
				{ 7, "s16746", "12641", "=q4=Invulnerable Mail", "=ds=#sr# 300", "=ds="..AL["World Drop"]};
				{ 8, "s27586", "22198", "=q4=Jagged Obsidian Shield", "=ds=#sr# 300", "=ds="..BabbleFaction["Cenarion Circle"].." - "..BabbleFaction["Revered"]};
				{ 9, "s16729", "12640", "=q4=Lionheart Helm", "=ds=#sr# 300", "=ds="..AL["World Drop"]};
				{ 10, "s27590", "22191", "=q4=Obsidian Mail Tunic", "=ds=#sr# 300", "=ds="..AL["Vendor"]..": "..BabbleZone["Ruins of Ahn'Qiraj"]};
				{ 11, "s16741", "12639", "=q4=Stronghold Gauntlets", "=ds=#sr# 300", "=ds="..AL["World Drop"]};
				{ 12, "s27587", "22196", "=q4=Thick Obsidian Breastplate", "=ds=#sr# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Temple of Ahn'Qiraj"]};
				{ 13, "s27829", "22385", "=q4=Titanic Leggings", "=ds=#sr# 300", "=ds="..AL["World Drop"]};
				{ 14, "s20874", "17014", "=q4=Dark Iron Bracers", "=ds=#sr# 295", "=ds="..BabbleFaction["Thorium Brotherhood"].." - "..BabbleFaction["Friendly"]};
				{ 15, "s20872", "16989", "=q4=Fiery Chain Girdle", "=ds=#sr# 295", "=ds="..BabbleFaction["Thorium Brotherhood"].." - "..BabbleFaction["Honored"]};
				{ 16, "s24914", "20550", "=q3=Darkrune Breastplate", "=ds=#sr# 300", "=ds=#QUESTID:8324#"};
				{ 17, "s24912", "20549", "=q3=Darkrune Gauntlets", "=ds=#sr# 300", "=ds=#QUESTID:8324#"};
				{ 18, "s24913", "20551", "=q3=Darkrune Helm", "=ds=#sr# 300", "=ds=#QUESTID:8324#"};
				{ 19, "s16745", "12618", "=q3=Enchanted Thorium Breastplate", "=ds=#sr# 300", "=ds=#QUESTID:7649#"};
				{ 20, "s16742", "12620", "=q3=Enchanted Thorium Helm", "=ds=#sr# 300", "=ds=#QUESTID:7651#"};
				{ 21, "s16744", "12619", "=q3=Enchanted Thorium Leggings", "=ds=#sr# 300", "=ds=#QUESTID:7650#"};
				{ 22, "s23633", "19057", "=q3=Gloves of the Dawn", "=ds=#sr# 300", "=ds="..BabbleFaction["Argent Dawn"].." - "..BabbleFaction["Revered"]};
				{ 23, "s27585", "22197", "=q3=Heavy Obsidian Belt", "=ds=#sr# 300", "=ds="..BabbleFaction["Cenarion Circle"].." - "..BabbleFaction["Friendly"]};
				{ 24, "s23629", "19048", "=q3=Heavy Timbermaw Boots", "=ds=#sr# 300", "=ds="..BabbleFaction["Timbermaw Hold"].." - "..BabbleFaction["Revered"]};
				{ 25, "s16728", "12636", "=q3=Helm of the Great Chief", "=ds=#sr# 300", "=ds="..AL["World Drop"]};
				{ 26, "s28463", "22764", "=q3=Ironvine Belt", "=ds=#sr# 300", "=ds="..BabbleFaction["Cenarion Circle"].." - "..BabbleFaction["Friendly"]};
				{ 27, "s28461", "22762", "=q3=Ironvine Breastplate", "=ds=#sr# 300", "=ds="..BabbleFaction["Cenarion Circle"].." - "..BabbleFaction["Revered"]};
				{ 28, "s28462", "22763", "=q3=Ironvine Gloves", "=ds=#sr# 300", "=ds="..BabbleFaction["Cenarion Circle"].." - "..BabbleFaction["Honored"]};
				{ 29, "s27588", "22195", "=q3=Light Obsidian Belt", "=ds=#sr# 300", "=ds="..BabbleFaction["Cenarion Circle"].." - "..BabbleFaction["Honored"]};
				{ 30, "s16724", "12633", "=q3=Whitesoul Helm", "=ds=#sr# 300", "=ds="..AL["World Drop"]};
			};
			{
				{ 1, "s16663", "12422", "=q2=Imperial Plate Chest", "=ds=#sr# 300", "=ds="..AL["Trainer"]};
				{ 2, "s16730", "12429", "=q2=Imperial Plate Leggings", "=ds=#sr# 300", "=ds="..AL["Trainer"]};
				{ 3, "s16725", "12420", "=q2=Radiant Leggings", "=ds=#sr# 300", "=ds="..AL["World Drop"]};
				{ 4, "s16731", "12613", "=q2=Runic Breastplate", "=ds=#sr# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Dustwallow Marsh"]};
				{ 5, "s16732", "12614", "=q2=Runic Plate Leggings", "=ds=#sr# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Western Plaguelands"]};
				{ 6, "s16726", "12612", "=q2=Runic Plate Helm", "=ds=#sr# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Dustwallow Marsh"]};
				{ 7, "s16664", "12610", "=q2=Runic Plate Shoulders", "=ds=#sr# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Dustwallow Marsh"]};
				{ 8, "s16662", "12414", "=q2=Thorium Leggings", "=ds=#sr# 300", "=ds="..AL["Trainer"]};
				{ 9, "s16657", "12426", "=q2=Imperial Plate Boots", "=ds=#sr# 295", "=ds="..AL["Trainer"]};
				{ 10, "s16658", "12427", "=q2=Imperial Plate Helm", "=ds=#sr# 295", "=ds="..AL["Trainer"]};
				{ 11, "s16659", "12417", "=q2=Radiant Circlet", "=ds=#sr# 295", "=ds="..AL["World Drop"]};
				{ 12, "s16661", "12632", "=q3=Storm Gauntlets", "=ds=#sr# 295", "=ds="..AL["World Drop"]};
				{ 13, "s16660", "12625", "=q3=Dawnbringer Shoulders", "=ds=#sr# 290", "=ds="..AL["World Drop"]};
				{ 14, "s23632", "19051", "=q3=Girdle of the Dawn", "=ds=#sr# 290", "=ds="..BabbleFaction["Argent Dawn"].." - "..BabbleFaction["Honored"]};
				{ 15, "s23628", "19043", "=q3=Heavy Timbermaw Belt", "=ds=#sr# 290", "=ds="..BabbleFaction["Timbermaw Hold"].." - "..BabbleFaction["Honored"]};
				{ 16, "s16656", "12419", "=q2=Radiant Boots", "=ds=#sr# 290", "=ds="..AL["World Drop"]};
				{ 17, "s15296", "11604", "=q3=Dark Iron Plate", "=ds=#sr# 285", "=ds="..AL["Drop"]..": "..BabbleZone["Blackrock Depths"]};
				{ 18, "s16654", "12418", "=q2=Radiant Gloves", "=ds=#sr# 285", "=ds="..AL["World Drop"]};
				{ 19, "s16652", "12409", "=q2=Thorium Boots", "=ds=#sr# 280", "=ds="..AL["Trainer"]};
				{ 20, "s16653", "12410", "=q2=Thorium Helm", "=ds=#sr# 280", "=ds="..AL["Trainer"]};
				{ 21, "s15295", "11605", "=q3=Dark Iron Shoulders", "=ds=#sr# 280", "=ds="..AL["Drop"]..": "..BabbleZone["Blackrock Depths"]};
				{ 22, "s15293", "11606", "=q3=Dark Iron Mail", "=ds=#sr# 270", "=ds="..AL["Drop"]..": "..BabbleZone["Blackrock Depths"]};
				{ 23, "s16649", "12425", "=q2=Imperial Plate Bracers", "=ds=#sr# 270", "=ds="..AL["Trainer"]};
				{ 24, "s16648", "12415", "=q2=Radiant Breastplate", "=ds=#sr# 270", "=ds="..AL["World Drop"]};
				{ 25, "s16647", "12424", "=q2=Imperial Plate Belt", "=ds=#sr# 265", "=ds="..AL["Trainer"]};
				{ 26, "s16646", "12428", "=q2=Imperial Plate Shoulders", "=ds=#sr# 265", "=ds="..AL["Trainer"]};
				{ 27, "s16645", "12416", "=q2=Radiant Belt", "=ds=#sr# 260", "=ds="..AL["World Drop"]};
				{ 28, "s16644", "12408", "=q2=Thorium Bracers", "=ds=#sr# 255", "=ds="..AL["Trainer"]};
				{ 29, "s16642", "12405", "=q2=Thorium Armor", "=ds=#sr# 250", "=ds="..AL["Trainer"]};
				{ 30, "s16643", "12406", "=q2=Thorium Belt", "=ds=#sr# 250", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, "s9970", "7934", "=q2=Heavy Mithril Helm", "=ds=#sr# 245", "=ds="..AL["World Drop"]};
				{ 2, "s9966", "7932", "=q2=Mithril Scale Shoulders", "=ds=#sr# 235", "=ds="..AL["World Drop"]};
				{ 3, "s9968", "7933", "=q2=Heavy Mithril Boots", "=ds=#sr# 235", "=ds="..AL["Trainer"]};
				{ 4, "s9959", "7930", "=q2=Heavy Mithril Breastplate", "=ds=#sr# 230", "=ds="..AL["Trainer"]};
				{ 5, "s9961", "7931", "=q2=Mithril Coif", "=ds=#sr# 230", "=ds="..AL["Trainer"]};
				{ 6, "s9935", "7922", "=q3=Steel Plate Helm", "=ds=#sr# 215", "=ds="..AL["Trainer"]};
				{
					{ 7, "s9937", "7924", "=q2=Mithril Scale Bracers", "=ds=#sr# 215", "=ds="..AL["Vendor"]..": "..BabbleZone["Swamp of Sorrows"]};
					{ 7, "s9937", "7924", "=q2=Mithril Scale Bracers", "=ds=#sr# 215", "=ds="..AL["Vendor"]..": "..BabbleZone["The Hinterlands"]};
				};
				{ 8, "s9931", "7920", "=q2=Mithril Scale Pants", "=ds=#sr# 210", "=ds="..AL["Trainer"]};
				{ 9, "s9933", "7921", "=q2=Heavy Mithril Pants", "=ds=#sr# 210", "=ds="..AL["World Drop"]};
				{ 10, "s9928", "7919", "=q2=Heavy Mithril Gauntlet", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 11, "s9926", "7918", "=q2=Heavy Mithril Shoulder", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 12, "s9916", "7963", "=q2=Steel Breastplate", "=ds=#sr# 200", "=ds="..AL["Trainer"]};
				{ 13, "s3515", "3847", "=q2=Golden Scale Boots", "=ds=#sr# 200", "=ds="..AL["World Drop"]};
				{ 14, "s3511", "3845", "=q2=Golden Scale Cuirass", "=ds=#sr# 195", "=ds="..AL["World Drop"]};
				{ 15, "s3503", "3837", "=q2=Golden Scale Coif", "=ds=#sr# 190", "=ds="..AL["Vendor"]..": "..BabbleZone["Gadgetzan"]};
				{ 16, "s3513", "3846", "=q2=Polished Steel Boots", "=ds=#sr# 185", "=ds="..AL["World Drop"]};
				{ 17, "s7223", "6040", "=q2=Golden Scale Bracers", "=ds=#sr# 185", "=ds="..AL["Trainer"]};
				{ 18, "s9820", "7917", "=q2=Barbaric Iron Gloves", "=ds=#sr# 185", "=ds=#QUESTID:2755#"};
				{ 19, "s9818", "7916", "=q2=Barbaric Iron Boots", "=ds=#sr# 180", "=ds=#QUESTID:2753#"};
				{ 20, "s3508", "3844", "=q3=Green Iron Hauberk", "=ds=#sr# 180", "=ds="..AL["Trainer"]};
				{ 21, "s9814", "7915", "=q2=Barbaric Iron Helm", "=ds=#sr# 175", "=ds=#QUESTID:2754#"};
				{ 22, "s3505", "3841", "=q2=Golden Scale Shoulders", "=ds=#sr# 175", "=ds="..AL["World Drop"]};
				{ 23, "s3507", "3843", "=q2=Golden Scale Leggings", "=ds=#sr# 170", "=ds="..AL["World Drop"]};
				{ 24, "s3502", "3836", "=q2=Green Iron Helm", "=ds=#sr# 170", "=ds="..AL["Trainer"]};
				{ 25, "s9813", "7914", "=q2=Barbaric Iron Breastplate", "=ds=#sr# 160", "=ds=#QUESTID:2751#"};
				{ 26, "s9811", "7913", "=q2=Barbaric Iron Shoulders", "=ds=#sr# 160", "=ds=#QUESTID:2752#"};
				{ 27, "s3504", "3840", "=q2=Green Iron Shoulders", "=ds=#sr# 160", "=ds="..AL["World Drop"]};
				{ 28, "s3501", "3835", "=q2=Green Iron Bracers", "=ds=#sr# 165", "=ds="..AL["Trainer"]};
				{ 29, "s3506", "3842", "=q2=Green Iron Leggings", "=ds=#sr# 155", "=ds="..AL["Trainer"]};
				{ 30, "s12259", "10423", "=q2=Silvered Bronze Leggings", "=ds=#sr# 155", "=ds="..AL["World Drop"]};
			};
			{
				{ 1, "s3336", "3485", "=q2=Green Iron Gauntlets", "=ds=#sr# 150", "=ds="..AL["World Drop"]};
				{ 2, "s3334", "3484", "=q2=Green Iron Boots", "=ds=#sr# 145", "=ds="..AL["World Drop"]};
				{ 3, "s2675", "2870", "=q3=Shining Silver Breastplate", "=ds=#sr# 145", "=ds="..AL["Trainer"]};
				{ 4, "s3333", "3483", "=q2=Silvered Bronze Gauntlets", "=ds=#sr# 135", "=ds="..AL["Trainer"]};
				{ 5, "s3331", "3482", "=q2=Silvered Bronze Boots", "=ds=#sr# 130", "=ds="..AL["Trainer"]};
				{ 6, "s2673", "2869", "=q2=Silvered Bronze Breastplate", "=ds=#sr# 130", "=ds="..AL["World Drop"]};
				{ 7, "s3330", "3481", "=q2=Silvered Bronze Shoulders", "=ds=#sr# 125", "=ds="..AL["World Drop"]};
				{ 8, "s2672", "2868", "=q2=Patterned Bronze Bracers", "=ds=#sr# 120", "=ds="..AL["Trainer"]};
				{ 9, "s3328", "3480", "=q2=Rough Bronze Shoulders", "=ds=#sr# 110", "=ds="..AL["Trainer"]};
				{ 10, "s2670", "2866", "=q2=Rough Bronze Cuirass", "=ds=#sr# 105", "=ds="..AL["Trainer"]};
				{ 11, "s2668", "2865", "=q2=Rough Bronze Leggings", "=ds=#sr# 105", "=ds="..AL["Trainer"]};
				{ 12, "s8367", "6731", "=q2=Ironforge Breastplate", "=ds=#sr# 100", "=ds=#QUESTID:1618#"};
				{ 13, "s7817", "6350", "=q2=Rough Bronze Boots", "=ds=#sr# 95", "=ds="..AL["Trainer"]};
				{ 14, "s2664", "2854", "=q2=Runed Copper Bracers", "=ds=#sr# 90", "=ds="..AL["Trainer"]};
				{ 15, "s2667", "2864", "=q2=Runed Copper Breastplate", "=ds=#sr# 80", "=ds="..AL["World Drop"]};
				{ 16, "s2666", "2857", "=q2=Runed Copper Belt", "=ds=#sr# 70", "=ds="..AL["Trainer"]};
				{ 17, "s3325", "3474", "=q2=Gemmed Copper Gauntlets", "=ds=#sr# 60", "=ds="..AL["World Drop"]};
				{ 18, "s3324", "3473", "=q2=Runed Copper Pants", "=ds=#sr# 45", "=ds="..AL["Trainer"]};
				{ 19, "s3323", "3472", "=q2=Runed Copper Gauntlets", "=ds=#sr# 40", "=ds="..AL["Trainer"]};
				{ 20, "s3321", "3471", "=q2=Copper Chain Vest", "=ds=#sr# 35", "=ds="..AL["World Drop"]};
				{ 21, "s2661", "2851", "=q1=Copper Chain Belt", "=ds=#sr# 35", "=ds="..AL["Trainer"]};
				{ 22, "s3319", "3469", "=q1=Copper Chain Boots", "=ds=#sr# 20", "=ds="..AL["Trainer"]};
				{ 23, "s2663", "2853", "=q1=Copper Bracers", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
				{ 24, "s2662", "2852", "=q1=Copper Chain Pants", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
				{ 25, "s12260", "10421", "=q1=Rough Copper Vest", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = BLACKSMITHING..": "..BabbleInventory["Armor"].." - "..AL["Classic WoW"],
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};

	AtlasLoot_Data["SmithingArmorBC"] = {
		["Normal"] = {
			{
				{ 1, "s36389", "30034", "=q4=Belt of the Guardian", "=ds=#sr# 375"};
				{ 2, "s36391", "30033", "=q4=Boots of the Protector", "=ds=#sr# 375"};
				{ 3, "s34534", "28484", "=q4=Bulwark of Kings", "=ds=#sr# 375"};
				{ 4, "s36257", "28485", "=q4=Bulwark of the Ancient Kings", "=ds=#sr# 375"};
				{ 5, "s41134", "32571", "=q4=Dawnsteel Bracers", "=ds=#sr# 375"};
				{ 6, "s41135", "32573", "=q4=Dawnsteel Shoulders", "=ds=#sr# 375"};
				{ 7, "s36256", "23565", "=q4=Embrace of the Twisting Nether", "=ds=#sr# 375"};
				{ 8, "s38477", "31369", "=q4=Iceguard Breastplate", "=ds=#sr# 375"};
				{ 9, "s38479", "31371", "=q4=Iceguard Helm", "=ds=#sr# 375"};
				{ 10, "s38478", "31370", "=q4=Iceguard Leggings", "=ds=#sr# 375"};
				{ 11, "s36390", "30032", "=q4=Red Belt of Battle", "=ds=#sr# 375"};
				{ 12, "s36392", "30031", "=q4=Red Havoc Boots", "=ds=#sr# 375"};
				{ 13, "s40034", "32403", "=q4=Shadesteel Bracers", "=ds=#sr# 375"};
				{ 14, "s40036", "32401", "=q4=Shadesteel Girdle", "=ds=#sr# 375"};
				{ 15, "s40035", "32404", "=q4=Shadesteel Greaves", "=ds=#sr# 375"};
				{ 16, "s40033", "32402", "=q4=Shadesteel Sabots", "=ds=#sr# 375"};
				{ 17, "s41132", "32568", "=q4=Swiftsteel Bracers", "=ds=#sr# 375"};
				{ 18, "s41133", "32570", "=q4=Swiftsteel Shoulders", "=ds=#sr# 375"};
				{ 19, "s34530", "23564", "=q4=Twisting Nether Chain Shirt", "=ds=#sr# 375"};
				{ 20, "s38473", "31364", "=q4=Wildguard Breastplate", "=ds=#sr# 375"};
				{ 21, "s38476", "31368", "=q4=Wildguard Helm", "=ds=#sr# 375"};
				{ 22, "s38475", "31367", "=q4=Wildguard Leggings", "=ds=#sr# 375"};
				{ 23, "s29669", "23537", "=q4=Black Felsteel Bracers", "=ds=#sr# 365"};
				{ 24, "s29672", "23539", "=q4=Blessed Bracers", "=ds=#sr# 365"};
				{ 25, "s29671", "23538", "=q4=Bracers of the Green Fortress", "=ds=#sr# 365"};
				{ 26, "s29658", "23531", "=q4=Felfury Gauntlets", "=ds=#sr# 365"};
				{ 27, "s29622", "23532", "=q4=Gauntlets of the Iron Tower", "=ds=#sr# 365"};
				{ 28, "s46141", "34378", "=q4=Hard Khorium Battlefists", "=ds=#sr# 365"};
				{ 29, "s46144", "34377", "=q4=Hard Khorium Battleplate", "=ds=#sr# 365"};
				{ 30, "s29664", "23535", "=q4=Helm of the Stalwart Defender", "=ds=#sr# 365"};
			};
			{
				{ 1, "s29668", "23536", "=q4=Oathkeeper's Helm", "=ds=#sr# 365"};
				{ 2, "s29662", "23533", "=q4=Steelgrip Gauntlets", "=ds=#sr# 365"};
				{ 3, "s29663", "23534", "=q4=Storm Helm", "=ds=#sr# 365"};
				{ 4, "s46142", "34379", "=q4=Sunblessed Breastplate", "=ds=#sr# 365"};
				{ 5, "s46140", "34380", "=q4=Sunblessed Gauntlets", "=ds=#sr# 365"};
				{ 6, "s34533", "28483", "=q4=Breastplate of Kings", "=ds=#sr# 350"};
				{ 7, "s34529", "23563", "=q4=Nether Chain Shirt", "=ds=#sr# 350"};
				{ 8, "s29649", "23527", "=q3=Earthpeace Breastplate", "=ds=#sr# 370"};
				{ 9, "s29645", "23522", "=q3=Ragesteel Breastplate", "=ds=#sr# 370"};
				{ 10, "s29648", "23526", "=q3=Swiftsteel Gloves", "=ds=#sr# 370"};
				{ 11, "s29613", "23512", "=q3=Enchanted Adamantite Leggings", "=ds=#sr# 365"};
				{ 12, "s29621", "23519", "=q3=Felsteel Helm", "=ds=#sr# 365"};
				{ 13, "s29617", "23513", "=q3=Flamebane Breastplate", "=ds=#sr# 365"};
				{ 14, "s29630", "23525", "=q3=Khorium Boots", "=ds=#sr# 365"};
				{ 15, "s29642", "23520", "=q3=Ragesteel Gloves", "=ds=#sr# 365"};
				{ 16, "s29643", "23521", "=q3=Ragesteel Helm", "=ds=#sr# 365"};
				{ 17, "s42662", "33173", "=q3=Ragesteel Shoulders", "=ds=#sr# 365"};
				{ 18, "s29610", "23509", "=q3=Enchanted Adamantite Breastplate", "=ds=#sr# 360"};
				{ 19, "s29619", "23517", "=q3=Felsteel Gloves", "=ds=#sr# 360"};
				{ 20, "s29620", "23518", "=q3=Felsteel Leggings", "=ds=#sr# 360"};
				{ 21, "s29616", "23514", "=q3=Flamebane Gloves", "=ds=#sr# 360"};
				{ 22, "s29628", "23524", "=q3=Khorium Belt", "=ds=#sr# 360"};
				{ 23, "s29629", "23523", "=q3=Khorium Pants", "=ds=#sr# 360"};
				{ 24, "s29608", "23510", "=q3=Enchanted Adamantite Belt", "=ds=#sr# 355"};
				{ 25, "s29611", "23511", "=q3=Enchanted Adamantite Boots", "=ds=#sr# 355"};
				{ 26, "s29615", "23516", "=q3=Flamebane Helm", "=ds=#sr# 355"};
				{ 27, "s29614", "23515", "=q3=Flamebane Bracers", "=ds=#sr# 350"};
				{ 28, "s29606", "23507", "=q3=Adamantite Breastplate", "=ds=#sr# 340"};
				{ 29, "s29603", "23506", "=q3=Adamantite Plate Bracers", "=ds=#sr# 335"};
				{ 30, "s29605", "23508", "=q3=Adamantite Plate Gloves", "=ds=#sr# 335"};
			};
			{
				{ 1, "s36129", "30074", "=q3=Heavy Earthforged Breastplate", "=ds=#sr# 330"};
				{ 2, "s36130", "30076", "=q3=Stormforged Hauberk", "=ds=#sr# 330"};
				{ 3, "s29550", "23489", "=q2=Fel Iron Breastplate", "=ds=#sr# 325"};
				{ 4, "s29556", "23490", "=q2=Fel Iron Chain Tunic", "=ds=#sr# 320"};
				{ 5, "s29548", "23487", "=q2=Fel Iron Plate Boots", "=ds=#sr# 315"};
				{ 6, "s29549", "23488", "=q2=Fel Iron Plate Pants", "=ds=#sr# 315"};
				{ 7, "s29553", "23494", "=q2=Fel Iron Chain Bracers", "=ds=#sr# 315"};
				{ 8, "s29552", "23491", "=q2=Fel Iron Chain Gloves", "=ds=#sr# 310"};
				{ 9, "s29547", "23484", "=q2=Fel Iron Plate Belt", "=ds=#sr# 305"};
				{ 10, "s29551", "23493", "=q2=Fel Iron Chain Coif", "=ds=#sr# 300"};
				{ 11, "s29545", "23482", "=q2=Fel Iron Plate Gloves", "=ds=#sr# 300"};
			};
		};
		info = {
			name = BLACKSMITHING..": "..BabbleInventory["Armor"].." - "..AL["Burning Crusade"],
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};

	AtlasLoot_Data["SmithingArmorWrath"] = {
		["Normal"] = {
			{
				{ 1, "s70568", "49907", "=q4=Boots of Kingly Upheaval", "=ds="..AL["Vendor"]..""};
				{ 2, "s70566", "49906", "=q4=Hellfrozen Bonegrinders", "=ds="..AL["Vendor"]..""};
				{ 3, "s70565", "49903", "=q4=Legplates of Painful Death", "=ds="..AL["Vendor"]..""};
				{ 4, "s70567", "49904", "=q4=Pillars of Might", "=ds="..AL["Vendor"]..""};
				{ 5, "s70563", "49905", "=q4=Protectors of Life", "=ds="..AL["Vendor"]..""};
				{ 6, "s70562", "49902", "=q4=Puresteel Legplates", "=ds="..AL["Vendor"]..""};
				{
					{ 7, "s67130", "47592", "=q4=Breastplate of the White Knight", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
					{ 7, "s67091", "47591", "=q4=Breastplate of the White Knight", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				};
				{
					{ 8, "s67131", "47571", "=q4=Saronite Swordbreakers", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
					{ 8, "s67092", "47570", "=q4=Saronite Swordbreakers", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				};
				{
					{ 9, "s67135", "47575", "=q4=Sunforged Bracers", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
					{ 9, "s67096", "47574", "=q4=Sunforged Bracers", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				};
				{
					{ 10, "s67134", "47594", "=q4=Sunforged Breastplate", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
					{ 10, "s67095", "47593", "=q4=Sunforged Breastplate", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				};
				{
					{ 11, "s67132", "47590", "=q4=Titanium Razorplate", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
					{ 11, "s67093", "47589", "=q4=Titanium Razorplate", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				};
				{
					{ 12, "s67133", "47573", "=q4=Titanium Spikeguards", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
					{ 12, "s67094", "47572", "=q4=Titanium Spikeguards", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				};
				{ 13, "s63188", "45559", "=q4=Battlelord's Plate Boots", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 14, "s63187", "45550", "=q4=Belt of the Titans", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 15, "s63191", "45551", "=q4=Indestructible Plate Girdle", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 16, "s63189", "45552", "=q4=Plate Girdle of Righteousness", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 17, "s63192", "45560", "=q4=Spiked Deathdealers", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 18, "s63190", "45561", "=q4=Treads of Destiny", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 19, "s55374", "41388", "=q4=Brilliant Titansteel Helm", "=ds="..AL["Trainer"] };
				{ 20, "s55377", "41394", "=q4=Brilliant Titansteel Treads", "=ds="..AL["Trainer"] };
				{ 21, "s55372", "41386", "=q4=Spiked Titansteel Helm", "=ds="..AL["Trainer"] };
				{ 22, "s55375", "41391", "=q4=Spiked Titansteel Treads", "=ds="..AL["Trainer"] };
				{ 23, "s55373", "41387", "=q4=Tempered Titansteel Helm", "=ds="..AL["Trainer"] };
				{ 24, "s55376", "41392", "=q4=Tempered Titansteel Treads", "=ds="..AL["Trainer"] };
				{ 25, "s56400", "42508", "=q4=Titansteel Shield Wall", "=ds="..AL["Trainer"] };
				{ 26, "s61008", "43586", "=q4=Icebane Chestguard", "=ds="..AL["Trainer"] };
				{ 27, "s61009", "43587", "=q4=Icebane Girdle", "=ds="..AL["Trainer"] };
				{ 28, "s61010", "43588", "=q4=Icebane Treads", "=ds="..AL["Trainer"] };
				{ 29, "s55303", "41345", "=q3=Daunting Legplates", "=ds="..AL["Trainer"] };
				{ 30, "s55302", "41344", "=q3=Helm of Command", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s56555", "42725", "=q3=Ornate Saronite Hauberk", "=ds="..AL["Trainer"] };
				{ 2, "s56554", "42726", "=q3=Ornate Saronite Legplates", "=ds="..AL["Trainer"] };
				{ 3, "s56556", "42728", "=q3=Ornate Saronite Skullshield", "=ds="..AL["Trainer"] };
				{ 4, "s55304", "41346", "=q3=Righteous Greaves", "=ds="..AL["Trainer"] };
				{ 5, "s55311", "41353", "=q3=Savage Saronite Hauberk", "=ds="..AL["Trainer"] };
				{ 6, "s55310", "41347", "=q3=Savage Saronite Legplates", "=ds="..AL["Trainer"] };
				{ 7, "s55312", "41350", "=q3=Savage Saronite Skullshield", "=ds="..AL["Trainer"] };
				{ 8, "s55301", "41357", "=q3=Daunting Handguards", "=ds="..AL["Trainer"] };
				{ 9, "s56553", "42724", "=q3=Ornate Saronite Gauntlets", "=ds="..AL["Trainer"] };
				{ 10, "s56550", "42727", "=q3=Ornate Saronite Pauldrons", "=ds="..AL["Trainer"] };
				{ 11, "s56551", "42729", "=q3=Ornate Saronite Waistguard", "=ds="..AL["Trainer"] };
				{ 12, "s56552", "42730", "=q3=Ornate Saronite Walkers", "=ds="..AL["Trainer"] };
				{ 13, "s55300", "41356", "=q3=Righteous Gauntlets", "=ds="..AL["Trainer"] };
				{ 14, "s55309", "41349", "=q3=Savage Saronite Gauntlets", "=ds="..AL["Trainer"] };
				{ 15, "s55306", "41351", "=q3=Savage Saronite Pauldrons", "=ds="..AL["Trainer"] };
				{ 16, "s55307", "41352", "=q3=Savage Saronite Waistguard", "=ds="..AL["Trainer"] };
				{ 17, "s55308", "41348", "=q3=Savage Saronite Walkers", "=ds="..AL["Trainer"] };
				{ 18, "s56549", "42723", "=q3=Ornate Saronite Bracers", "=ds="..AL["Trainer"] };
				{ 19, "s55305", "41354", "=q3=Savage Saronite Bracers", "=ds="..AL["Trainer"] };
				{ 20, "s55298", "41355", "=q3=Vengeance Bindings", "=ds="..AL["Trainer"] };
				{ 21, "s55058", "41129", "=q3=Brilliant Saronite Breastplate", "=ds="..AL["Trainer"] };
				{ 22, "s59441", "43870", "=q3=Brilliant Saronite Helm", "=ds="..AL["Trainer"] };
				{ 23, "s55186", "41189", "=q3=Chestplate of Conquest", "=ds="..AL["Trainer"] };
				{ 24, "s55187", "41190", "=q3=Legplates of Conquest", "=ds="..AL["Trainer"] };
				{ 25, "s55015", "41114", "=q3=Tempered Saronite Gauntlets", "=ds="..AL["Trainer"] };
				{ 26, "s55014", "41113", "=q3=Saronite Bulwark", "=ds="..AL["Trainer"] };
				{ 27, "s55017", "41116", "=q3=Tempered Saronite Bracers", "=ds="..AL["Trainer"] };
				{ 28, "s55057", "41128", "=q3=Brilliant Saronite Boots", "=ds="..AL["Trainer"] };
				{ 29, "s59440", "43865", "=q3=Brilliant Saronite Pauldrons", "=ds="..AL["Trainer"] };
				{ 30, "s54555", "40673", "=q3=Tempered Saronite Helm", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s54556", "40675", "=q3=Tempered Saronite Shoulders", "=ds="..AL["Trainer"] };
				{ 2, "s59438", "43864", "=q3=Brilliant Saronite Bracers", "=ds="..AL["Trainer"] };
				{ 3, "s55056", "41127", "=q3=Brilliant Saronite Gauntlets", "=ds="..AL["Trainer"] };
				{ 4, "s54552", "40671", "=q3=Tempered Saronite Boots", "=ds="..AL["Trainer"] };
				{ 5, "s54553", "40672", "=q3=Tempered Saronite Breastplate", "=ds="..AL["Trainer"] };
				{ 6, "s59436", "43860", "=q3=Brilliant Saronite Belt", "=ds="..AL["Trainer"] };
				{ 7, "s55055", "41126", "=q3=Brilliant Saronite Legplates", "=ds="..AL["Trainer"] };
				{ 8, "s54551", "40669", "=q3=Tempered Saronite Belt", "=ds="..AL["Trainer"] };
				{ 9, "s54554", "40674", "=q3=Tempered Saronite Legplates", "=ds="..AL["Trainer"] };
				{ 10, "s54557", "40670", "=q3=Saronite Defender", "=ds="..AL["Trainer"] };
				{ 11, "s55013", "41117", "=q3=Saronite Protector", "=ds="..AL["Trainer"] };
				{ 12, "s54949", "40955", "=q2=Horned Cobalt Helm", "=ds="..AL["Trainer"] };
				{ 13, "s54948", "40954", "=q2=Spiked Cobalt Bracers", "=ds="..AL["Trainer"] };
				{ 14, "s54946", "40953", "=q2=Spiked Cobalt Belt", "=ds="..AL["Trainer"] };
				{ 15, "s54947", "40943", "=q2=Spiked Cobalt Legplates", "=ds="..AL["Trainer"] };
				{ 16, "s54945", "40952", "=q2=Spiked Cobalt Gauntlets", "=ds="..AL["Trainer"] };
				{ 17, "s54941", "40950", "=q2=Spiked Cobalt Shoulders", "=ds="..AL["Trainer"] };
				{ 18, "s54918", "40949", "=q2=Spiked Cobalt Boots", "=ds="..AL["Trainer"] };
				{ 19, "s54944", "40951", "=q2=Spiked Cobalt Chestpiece", "=ds="..AL["Trainer"] };
				{ 20, "s54978", "40956", "=q2=Reinforced Cobalt Shoulders", "=ds="..AL["Drop"]..": "..BabbleZone["Dragonblight"] };
				{ 21, "s54979", "40957", "=q2=Reinforced Cobalt Helm", "=ds="..AL["Drop"]..": "..BabbleZone["Grizzly Hills"] };
				{ 22, "s54980", "40958", "=q2=Reinforced Cobalt Legplates", "=ds="..AL["Drop"]..": "..BabbleZone["Zul'Drak"] };
				{ 23, "s54981", "40959", "=q2=Reinforced Cobalt Chestpiece", "=ds="..AL["Drop"]..": "..BabbleZone["Sholazar Basin"] };
				{ 24, "s54917", "40942", "=q2=Spiked Cobalt Helm", "=ds="..AL["Trainer"] };
				{ 25, "s52570", "39085", "=q2=Cobalt Chestpiece", "=ds="..AL["Trainer"] };
				{ 26, "s52571", "39084", "=q2=Cobalt Helm", "=ds="..AL["Trainer"] };
				{ 27, "s52567", "39086", "=q2=Cobalt Legplates", "=ds="..AL["Trainer"] };
				{ 28, "s55835", "41975", "=q2=Cobalt Gauntlets", "=ds="..AL["Trainer"] };
				{ 29, "s55834", "41974", "=q2=Cobalt Bracers", "=ds="..AL["Trainer"] };
				{ 30, "s52572", "39083", "=q2=Cobalt Shoulders", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s54550", "40668", "=q2=Cobalt Triangle Shield", "=ds="..AL["Trainer"] };
				{ 2, "s52568", "39087", "=q2=Cobalt Belt", "=ds="..AL["Trainer"] };
				{ 3, "s52569", "39088", "=q2=Cobalt Boots", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = BLACKSMITHING..": "..BabbleInventory["Armor"].." - "..AL["Wrath of the Lich King"],
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};

	AtlasLoot_Data["SmithingArmorCata"] = {
		["Normal"] = {
			{
				{ 1, "s101931", "71992", "=q4=Bracers of Destructive Strength", "=ds=#s8#, #a4# / =q1=#sk# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 2, "s101932", "71993", "=q4=Titanguard Wristplates", "=ds=#s8#, #a4# / =q1=#sk# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 3, "s101929", "71991", "=q4=Soul Redeemer Bracers", "=ds=#s8#, #a4# / =q1=#sk# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 4, "s101925", "71983", "=q4=Unstoppable Destroyer's Legplates", "=ds=#s11#, #a4# / =q1=#sk# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 5, "s101928", "71984", "=q4=Foundations of Courage", "=ds=#s11#, #a4# / =q1=#sk# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 6, "s101924", "71982", "=q4=Pyrium Legplates of Purified Evil", "=ds=#s11#, #a4# / =q1=#sk# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 7, "s99439", "69936", "=q4=Fists of Fury", "=ds=#s9#, #a4# / =q1=#sk# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 8, "s99440", "69937", "=q4=Eternal Elementium Handguards", "=ds=#s9#, #a4# / =q1=#sk# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 9, "s99441", "69938", "=q4=Holy Flame Gauntlets", "=ds=#s9#, #a4# / =q1=#sk# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 10, "s99452", "69946", "=q4=Warboots of Mighty Lords", "=ds=#s12#, #a4# / =q1=#sk# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 11, "s99453", "69947", "=q4=Mirrored Boots", "=ds=#s12#, #a4# / =q1=#sk# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 12, "s99454", "69948", "=q4=Emberforged Elementium Boots", "=ds=#s12#, #a4# / =q1=#sk# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 13, "s76464", "75135", "=q3=Vicious Pyrium Breastplate", "=ds=#s5#, #a4# / =q1=#sk# 525", "=ds="..AL["Vendor"]};
				{ 14, "s76463", "75126", "=q3=Vicious Pyrium Helm", "=ds=#s1#, #a4# / =q1=#sk# 525", "=ds="..AL["Vendor"]};
				{ 15, "s76462", "75136", "=q3=Vicious Pyrium Legguards", "=ds=#s11#, #a4# / =q1=#sk# 525", "=ds="..AL["Vendor"]};
				{ 16, "s76472", "75128", "=q3=Vicious Ornate Pyrium Breastplate", "=ds=#s5#, #a4# / =q1=#sk# 525", "=ds="..AL["Vendor"]};
				{ 17, "s76471", "75129", "=q3=Vicious Ornate Pyrium Helm", "=ds=#s1#, #a4# / =q1=#sk# 525", "=ds="..AL["Vendor"]};
				{ 18, "s76470", "75133", "=q3=Vicious Ornate Pyrium Legguards", "=ds=#s11#, #a4# / =q1=#sk# 525", "=ds="..AL["Vendor"]};
				{ 19, "s76461", "75119", "=q3=Vicious Pyrium Shoulders", "=ds=#s3#, #a4# / =q1=#sk# 520", "=ds="..AL["Vendor"]};
				{ 20, "s76469", "75134", "=q3=Vicious Ornate Pyrium Shoulders", "=ds=#s3#, #a4# / =q1=#sk# 520", "=ds="..AL["Vendor"]};
				{ 21, "s76445", "55060", "=q4=Elementium Deathplate", "=ds=#s5#, #a4# / =q1=#sk# 515", "=ds="..AL["Vendor"]};
				{ 22, "s76443", "55058", "=q4=Hardened Elementium Hauberk", "=ds=#s5#, #a4# / =q1=#sk# 515", "=ds="..AL["Vendor"]};
				{ 23, "s76447", "55062", "=q4=Light Elementium Chestguard", "=ds=#s5#, #a4# / =q1=#sk# 515", "=ds="..AL["Vendor"]};
				{ 24, "s76459", "75120", "=q3=Vicious Pyrium Boots", "=ds=#s12#, #a4# / =q1=#sk# 515", "=ds="..AL["Vendor"]};
				{ 25, "s76468", "75132", "=q3=Vicious Ornate Pyrium Boots", "=ds=#s12#, #a4# / =q1=#sk# 515", "=ds="..AL["Vendor"]};
				{ 26, "s76446", "55061", "=q4=Elementium Girdle of Pain", "=ds=#s10#, #a4# / =q1=#sk# 510", "=ds="..AL["Vendor"]};
				{ 27, "s76444", "55059", "=q4=Hardened Elementium Girdle", "=ds=#s10#, #a4# / =q1=#sk# 500", "=ds="..AL["Vendor"]};
				{ 28, "s76448", "55063", "=q4=Light Elementium Belt", "=ds=#s10#, #a4# / =q1=#sk# 510", "=ds="..AL["Vendor"]};
				{ 29, "s76458", "75123", "=q3=Vicious Pyrium Belt", "=ds=#s10#, #a4# / =q1=#sk# 510", "=ds="..AL["Vendor"]};
				{ 30, "s76467", "75118", "=q3=Vicious Ornate Pyrium Belt", "=ds=#s10#, #a4# / =q1=#sk# 510", "=ds="..AL["Vendor"]};
			};
			{
				{ 1, "s76457", "75122", "=q3=Vicious Pyrium Gauntlets", "=ds=#s9#, #a4# / =q1=#sk# 505", "=ds="..AL["Vendor"]};
				{ 2, "s76466", "75121", "=q3=Vicious Ornate Pyrium Gauntlets", "=ds=#s9#, #a4# / =q1=#sk# 505", "=ds="..AL["Vendor"]};
				{ 3, "s76456", "75124", "=q3=Vicious Pyrium Bracers", "=ds=#s8#, #a4# / =q1=#sk# 500", "=ds="..AL["Vendor"]};
				{ 4, "s76465", "75125", "=q3=Vicious Ornate Pyrium Bracers", "=ds=#s8#, #a4# / =q1=#sk# 500", "=ds="..AL["Vendor"]};
				{ 5, "s76270", "55032", "=q3=Redsteel Breastplate", "=ds=#s5#, #a4# / =q1=#sk# 500", "=ds="..AL["Trainer"] };
				{ 6, "s76261", "55024", "=q2=Hardened Obsidium Breastplate", "=ds=#s5#, #a4# / =q1=#sk# 500", "=ds="..AL["Trainer"]};
				{ 7, "s76289", "55040", "=q2=Stormforged Breastplate", "=ds=#s5#, #a4# / =q1=#sk# 500", "=ds="..AL["Trainer"]};
				{ 8, "s76269", "55031", "=q2=Redsteel Helm", "=ds=#s1#, #a4# / =q1=#sk# 500", "=ds="..AL["Trainer"]};
				{ 9, "s76260", "55023", "=q3=Hardened Obsidium Helm", "=ds=#s1#, #a4# / =q1=#sk# 490", "=ds="..AL["Trainer"]};
				{ 10, "s76288", "55039", "=q3=Stormforged Helm", "=ds=#s1#, #a4# / =q1=#sk# 490", "=ds="..AL["Trainer"]};
				{ 11, "s76259", "55022", "=q2=Hardened Obsidium Legguards", "=ds=#s11#, #a4# / =q1=#sk# 490", "=ds="..AL["Trainer"]};
				{ 12, "s76267", "55030", "=q2=Redsteel Legguards", "=ds=#s11#, #a4# / =q1=#sk# 490", "=ds="..AL["Trainer"]};
				{ 13, "s76287", "55038", "=q3=Stormforged Legguards", "=ds=#s11#, #a4# / =q1=#sk# 480", "=ds="..AL["Trainer"]};
				{ 14, "s76258", "54876", "=q3=Hardened Obsidium Shoulders", "=ds=#s3#, #a4# / =q1=#sk# 480", "=ds="..AL["Trainer"]};
				{ 15, "s76266", "55029", "=q3=Redsteel Shoulders", "=ds=#s3#, #a4# / =q1=#sk# 480", "=ds="..AL["Trainer"]};
				{ 16, "s76286", "55037", "=q3=Stormforged Shoulders", "=ds=#s3#, #a4# / =q1=#sk# 480", "=ds="..AL["Trainer"]};
				{ 17, "s76182", "54854", "=q2=Hardened Obsidium Boots", "=ds=#s12#, #a4# / =q1=#sk# 470", "=ds="..AL["Trainer"]};
				{ 18, "s76265", "55028", "=q2=Redsteel Boots", "=ds=#s12#, #a4# / =q1=#sk# 470", "=ds="..AL["Trainer"]};
				{ 19, "s76285", "55036", "=q2=Stormforged Boots", "=ds=#s12#, #a4# / =q1=#sk# 470", "=ds="..AL["Trainer"]};
				{ 20, "s76181", "54853", "=q2=Hardened Obsidium Belt", "=ds=#s10#, #a4# / =q1=#sk# 460", "=ds="..AL["Trainer"]};
				{ 21, "s76264", "55027", "=q2=Redsteel Belt", "=ds=#s10#, #a4# / =q1=#sk# 460", "=ds="..AL["Trainer"]};
				{ 22, "s76283", "55035", "=q2=Stormforged Belt", "=ds=#s10#, #a4# / =q1=#sk# 460", "=ds="..AL["Trainer"]};
				{ 23, "s76180", "54852", "=q2=Hardened Obsidium Gauntlets", "=ds=#s9#, #a4# / =q1=#sk# 450", "=ds="..AL["Trainer"]};
				{ 24, "s76263", "55026", "=q2=Redsteel Gauntlets", "=ds=#s9#, #a4# / =q1=#sk# 450", "=ds="..AL["Trainer"]};
				{ 25, "s76281", "55034", "=q3=Stormforged Gauntlets", "=ds=#s9#, #a4# / =q1=#sk# 450", "=ds="..AL["Trainer"]};
				{ 26, "s76179", "54850", "=q2=Hardened Obsidium Bracers", "=ds=#s8#, #a4# / =q1=#sk# 440", "=ds="..AL["Trainer"]};
				{ 27, "s76262", "55025", "=q2=Redsteel Bracers", "=ds=#s8#, #a4# / =q1=#sk# 440", "=ds="..AL["Trainer"]};
				{ 28, "s76280", "55033", "=q2=Stormforged Bracers", "=ds=#s8#, #a4# / =q1=#sk# 440", "=ds="..AL["Trainer"]};
				{ 29, "s76291", "55041", "=q2=Hardened Obsidium Shield", "=ds=#w8# / =q1=#sk# 425", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = BLACKSMITHING..": "..BabbleInventory["Armor"].." - "..AL["Cataclysm"],
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};

	AtlasLoot_Data["SmithingWeaponOld"] = {
		["Normal"] = {
			{
				{ 1, "s23638", "19166", "=q4=Black Amnesty", "=ds=#h1#, #w4# / #sk# 300", "=ds="..BabbleFaction["Thorium Brotherhood"].." - "..BabbleFaction["Revered"]};
				{ 2, "s23639", "19167", "=q4=Blackfury", "=ds=#w7# / #sk# 300", "=ds="..BabbleFaction["Thorium Brotherhood"].." - "..BabbleFaction["Revered"]};
				{ 3, "s23652", "19168", "=q4=Blackguard", "=ds=#h1#, #w10# / #sk# 300", "=ds="..BabbleFaction["Thorium Brotherhood"].." - "..BabbleFaction["Exalted"]};
				{ 4, "s23650", "19170", "=q4=Ebon Hand", "=ds=#h1#, #w6# / #sk# 300", "=ds="..BabbleFaction["Thorium Brotherhood"].." - "..BabbleFaction["Exalted"]};
				{ 5, "s23653", "19169", "=q4=Nightfall", "=ds=#h2#, #w1# / #sk# 300", "=ds="..BabbleFaction["Thorium Brotherhood"].." - "..BabbleFaction["Exalted"]};
				{ 6, "s27830", "22384", "=q4=Persuader", "=ds=#h1#, #w6# / #sk# 300", "=ds="..AL["World Drop"]};
				{ 7, "s27832", "22383", "=q4=Sageblade", "=ds=#h3#, #w10# / #sk# 300", "=ds="..AL["World Drop"]};
				{ 8, "s21161", "17193", "=q4=Sulfuron Hammer", "=ds=#h2#, #w6# / #sk# 300", "=ds=#QUESTID:7604#"};
				{ 9, "s16991", "12798", "=q3=Annihilator", "=ds=#h1#, #w1# / #sk# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Lower Blackrock Spire"]};
				{ 10, "s16990", "12790", "=q3=Arcanite Champion", "=ds=#h2#, #w10# / #sk# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Upper Blackrock Spire"]};
				{ 11, "s16994", "12784", "=q3=Arcanite Reaper", "=ds=#h2#, #w1# / #sk# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Lower Blackrock Spire"]};
				{ 12, "s20897", "17016", "=q3=Dark Iron Destroyer", "=ds=#h1#, #w1# / #sk# 300", "=ds="..BabbleFaction["Thorium Brotherhood"].." - "..BabbleFaction["Honored"]};
				{ 13, "s20890", "17015", "=q3=Dark Iron Reaver", "=ds=#h1#, #w10# / #sk# 300", "=ds="..BabbleFaction["Thorium Brotherhood"].." - "..BabbleFaction["Honored"]};
				{ 14, "s16992", "12797", "=q3=Frostguard", "=ds=#h1#, #w10# / #sk# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Western Plaguelands"]};
				{ 15, "s16988", "12796", "=q3=Hammer of the Titans", "=ds=#h2#, #w6# / #sk# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Stratholme"]};
				{ 16, "s16995", "12783", "=q3=Heartseeker", "=ds=#h1#, #w4# / #sk# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Stratholme"]};
				{ 17, "s16993", "12794", "=q3=Masterwork Stormhammer", "=ds=#h1#, #w6# / #sk# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Upper Blackrock Spire"]};
				{ 18, "s34982", "29203", "=q2=Enchanted Thorium Blades", "=ds=#w11# / #sk# 300", "=ds="..AL["Trainer"]};
				{ 19, "s16985", "12782", "=q3=Corruption", "=ds=#h2#, #w10# / #sk# 290", "=ds="..AL["Drop"]..": "..BabbleZone["Stratholme"]};
				{ 20, "s16983", "12781", "=q3=Serenity", "=ds=#h1#, #w6# / #sk# 285", "=ds="..AL["Drop"]..": "..BabbleZone["Stratholme"]};
				{ 21, "s16971", "12775", "=q2=Huge Thorium Battleaxe", "=ds=#h2#, #w1# / #sk# 280", "=ds="..AL["Trainer"]};
				{ 22, "s15294", "11607", "=q3=Dark Iron Sunderer", "=ds=#h2#, #w1# / #sk# 275", "=ds="..AL["Drop"]..": "..BabbleZone["Blackrock Depths"]};
				{ 23, "s16969", "12773", "=q2=Ornate Thorium Handaxe", "=ds=#h1#, #w1# / #sk# 275", "=ds="..AL["Trainer"]};
				{ 24, "s10007", "7961", "=q3=Phantom Blade", "=ds=#h1#, #w10# / #sk# 270"};
				{ 25, "s15292", "11608", "=q3=Dark Iron Pulverizer", "=ds=#h2#, #w6# / #sk# 265", "=ds="..AL["Drop"]..": "..BabbleZone["Blackrock Depths"]};
				{ 26, "s10013", "7947", "=q2=Ebon Shiv", "=ds=#h1#, #w4# / #sk# 255", "=ds="..AL["Vendor"]..": "..BabbleZone["Western Plaguelands"]};
				{ 27, "s10009", "7946", "=q2=Runed Mithril Hammer", "=ds=#h1#, #w6# / #sk# 245", "=ds="..AL["World Drop"]};
				{ 28, "s10005", "7944", "=q2=Dazzling Mithril Rapier", "=ds=#h1#, #w10# / #sk# 240", "=ds="..AL["World Drop"]};
				{ 29, "s10001", "7945", "=q2=Big Black Mace", "=ds=#h1#, #w6# / #sk# 230", "=ds="..AL["Trainer"]};
				{ 30, "s9997", "7943", "=q2=Wicked Mithril Blade", "=ds=#h1#, #w10# / #sk# 225", "=ds="..AL["World Drop"]};
			};
			{
				{ 1, "s9995", "7942", "=q2=Blue Glittering Axe", "=ds=#h1#, #w1# / #sk# 220", "=ds="..AL["World Drop"]};
				{ 2, "s9993", "7941", "=q2=Heavy Mithril Axe", "=ds=#h1#, #w1# / #sk# 210", "=ds="..AL["Trainer"]};
				{ 3, "s3497", "3854", "=q2=Frost Tiger Blade", "=ds=#h2#, #w10# / #sk# 200", "=ds="..AL["World Drop"]};
				{ 4, "s3500", "3856", "=q2=Shadow Crescent Axe", "=ds=#h2#, #w1# / #sk# 200", "=ds="..AL["World Drop"]};
				{ 5, "s34981", "29202", "=q2=Whirling Steel Axes", "=ds=#w11# / #sk# 200", "=ds="..AL["Trainer"]};
				{ 6, "s21913", "17704", "=q2=Edge of Winter", "=ds=#h1#, #w1# / #sk# 190", "=ds="..AL["Feast of Winter Veil"]};
				{ 7, "s15973", "12260", "=q2=Searing Golden Blade", "=ds=#h3#, #w4# / #sk# 190", "=ds="..AL["World Drop"]};
				{ 8, "s3498", "3855", "=q2=Massive Iron Axe", "=ds=#h2#, #w1# / #sk# 185", "=ds="..AL["Vendor"]..": "..BabbleZone["Northern Stranglethorn"]};
				{ 9, "s15972", "12259", "=q2=Glinting Steel Dagger", "=ds=#h1#, #w4# / #sk# 180", "=ds="..AL["Trainer"]};
				{ 10, "s3496", "3853", "=q2=Moonsteel Broadsword", "=ds=#h2#, #w10# / #sk# 180", "=ds="..AL["Vendor"]..": "..BabbleZone["Booty Bay"]};
				{ 11, "s3493", "3850", "=q2=Jade Serpentblade", "=ds=#h1#, #w10# / #sk# 175", "=ds="..AL["World Drop"]};
				{ 12, "s3495", "3852", "=q2=Golden Iron Destroyer", "=ds=#h2#, #w6# / #sk# 170", "=ds="..AL["World Drop"]};
				{ 13, "s3492", "3849", "=q2=Hardened Iron Shortsword", "=ds=#h1#, #w10# / #sk# 160", "=ds="..AL["Vendor"]};
				{ 14, "s3494", "3851", "=q2=Solid Iron Maul", "=ds=#h2#, #w6# / #sk# 155", "=ds="..AL["Vendor"]};
				{ 15, "s3297", "3492", "=q2=Mighty Iron Hammer", "=ds=#h1#, #w6# / #sk# 145", "=ds="..AL["World Drop"]};
				{ 16, "s6518", "5541", "=q2=Iridescent Hammer", "=ds=#h1#, #w6# / #sk# 140", "=ds="..AL["World Drop"]};
				{ 17, "s9987", "7958", "=q2=Bronze Battle Axe", "=ds=#h2#, #w1# / #sk# 135", "=ds="..AL["Trainer"]};
				{ 18, "s9986", "7957", "=q2=Bronze Greatsword", "=ds=#h2#, #w10 / #sk# 130", "=ds="..AL["Trainer"]};
				{ 19, "s3296", "3491", "=q2=Heavy Bronze Mace", "=ds=#h1#, #w6# / #sk# 130", "=ds="..AL["Trainer"]};
				{ 20, "s9985", "7956", "=q2=Bronze Warhammer", "=ds=#h2#, #w6# / #sk# 125", "=ds="..AL["Trainer"]};
				{ 21, "s3295", "3490", "=q2=Deadly Bronze Poniard", "=ds=#h1#, #w4# / #sk# 125", "=ds="..AL["World Drop"]};
				{ 22, "s2742", "2850", "=q2=Bronze Shortsword", "=ds=#h3#, #w10# / #sk# 120", "=ds="..AL["Trainer"]};
				{ 23, "s2741", "2849", "=q2=Bronze Axe", "=ds=#h3#, #w1# / #sk# 115", "=ds="..AL["Trainer"]};
				{ 24, "s2740", "2848", "=q2=Bronze Mace", "=ds=#h3#, #w6# / #sk# 110", "=ds="..AL["Trainer"]};
				{ 25, "s6517", "5540", "=q2=Pearl-Handled Dagger", "=ds=#h1#, #w4# / #sk# 110", "=ds="..AL["Trainer"]};
				{ 26, "s3491", "3848", "=q2=Big Bronze Knife", "=ds=#h1#, #w4# / #sk# 105", "=ds="..AL["Trainer"]};
				{ 27, "s34979", "29201", "=q2=Thick Bronze Darts", "=ds=#w11# / #sk# 100", "=ds="..AL["Trainer"]};
				{ 28, "s3292", "3487", "=q2=Heavy Copper Broadsword", "=ds=#h2#, #w10# / #sk# 95", "=ds="..AL["Trainer"]};
				{ 29, "s3294", "3489", "=q2=Thick War Axe", "=ds=#h1#, #w1# / #sk# 70", "=ds="..AL["Trainer"]};
				{ 30, "s7408", "6214", "=q2=Heavy Copper Maul", "=ds=#h2#, #w6# / #sk# 65", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, "s3293", "3488", "=q2=Copper Battle Axe", "=ds=#h2#, #w1# / #sk# 35", "=ds="..AL["Trainer"]};
				{ 2, "s43549", "33791", "=q2=Heavy Copper Longsword", "=ds=#h1#, #w10# / #sk# 35", "=ds=#QUESTID:1578#"};
				{ 3, "s9983", "7955", "=q1=Copper Claymore", "=ds=#h2#, #w10# / #sk# 30", "=ds="..AL["Trainer"]};
				{ 4, "s8880", "7166", "=q1=Copper Dagger", "=ds=#h1#, #w4# / #sk# 30", "=ds="..AL["Trainer"]};
				{ 5, "s2739", "2847", "=q1=Copper Shortsword", "=ds=#h3#, #w10# / #sk# 25", "=ds="..AL["Trainer"]};
				{ 6, "s2738", "2845", "=q1=Copper Axe", "=ds=#h3#, #w1# / #sk# 20", "=ds="..AL["Trainer"]};
				{ 7, "s2737", "2844", "=q1=Copper Mace", "=ds=#h3#, #w6# / #sk# 15", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = BLACKSMITHING..": "..BabbleInventory["Weapon"].." - "..AL["Classic WoW"],
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};

	AtlasLoot_Data["SmithingWeaponBC"] = {
		["Normal"] = {
			{
				{ 1, "s34542", "28432", "=q4=Black Planar Edge", "=ds=#sr# 375"};
				{ 2, "s36258", "28427", "=q4=Blazefury", "=ds=#sr# 375"};
				{ 3, "s34537", "28426", "=q4=Blazeguard", "=ds=#sr# 375"};
				{ 4, "s36261", "28436", "=q4=Bloodmoon", "=ds=#sr# 375"};
				{ 5, "s34548", "28441", "=q4=Deep Thunder", "=ds=#sr# 375"};
				{ 6, "s34546", "28438", "=q4=Dragonmaw", "=ds=#sr# 375"};
				{ 7, "s36262", "28439", "=q4=Dragonstrike", "=ds=#sr# 375"};
				{ 8, "s34540", "28429", "=q4=Lionheart Champion", "=ds=#sr# 375"};
				{ 9, "s36259", "28430", "=q4=Lionheart Executioner", "=ds=#sr# 375"};
				{ 10, "s34544", "28435", "=q4=Mooncleaver", "=ds=#sr# 375"};
				{ 11, "s36263", "28442", "=q4=Stormherald", "=ds=#sr# 375"};
				{ 12, "s36260", "28433", "=q4=Wicked Edge of the Planes", "=ds=#sr# 375"};
				{ 13, "s29699", "23555", "=q4=Dirge", "=ds=#sr# 365"};
				{ 14, "s29698", "23554", "=q4=Eternium Runed Blade", "=ds=#sr# 365"};
				{ 15, "s29694", "23542", "=q4=Fel Edged Battleaxe", "=ds=#sr# 365"};
				{ 16, "s29697", "23546", "=q4=Fel Hardened Maul", "=ds=#sr# 365"};
				{ 17, "s29692", "23540", "=q4=Felsteel Longblade", "=ds=#sr# 365"};
				{ 18, "s29695", "23543", "=q4=Felsteel Reaper", "=ds=#sr# 365"};
				{ 19, "s43846", "32854", "=q4=Hammer of Righteous Might", "=ds=#sr# 365"};
				{ 20, "s29700", "23556", "=q4=Hand of Eternity", "=ds=#sr# 365"};
				{ 21, "s29693", "23541", "=q4=Khorium Champion", "=ds=#sr# 365"};
				{ 22, "s29696", "23544", "=q4=Runic Hammer", "=ds=#sr# 365"};
				{ 23, "s34545", "28437", "=q4=Drakefist Hammer", "=ds=#sr# 350"};
				{ 24, "s34535", "28425", "=q4=Fireguard", "=ds=#sr# 350"};
				{ 25, "s34538", "28428", "=q4=Lionheart Blade", "=ds=#sr# 350"};
				{ 26, "s34543", "28434", "=q4=Lunar Crescent", "=ds=#sr# 350"};
				{ 27, "s34541", "28431", "=q4=The Planar Edge", "=ds=#sr# 350"};
				{ 28, "s34547", "28440", "=q4=Thunder", "=ds=#sr# 350"};
				{ 29, "s34983", "29204", "=q3=Felsteel Whisper Knives", "=ds=#sr# 350"};
				{ 30, "s36137", "30093", "=q3=Great Earthforged Hammer", "=ds=#sr# 330"};
			};
			{
				{ 1, "s36136", "30089", "=q3=Lavaforged Warhammer", "=ds=#sr# 330"};
				{ 2, "s36135", "30088", "=q3=Skyforged Great Axe", "=ds=#sr# 330"};
				{ 3, "s36133", "30086", "=q3=Stoneforged Claymore", "=ds=#sr# 330"};
				{ 4, "s36134", "30087", "=q3=Stormforged Axe", "=ds=#sr# 330"};
				{ 5, "s36131", "30077", "=q3=Windforged Rapier", "=ds=#sr# 330"};
				{ 6, "s29571", "23505", "=q2=Adamantite Rapier", "=ds=#sr# 335"};
				{ 7, "s29568", "23503", "=q2=Adamantite Cleaver", "=ds=#sr# 330"};
				{ 8, "s29569", "23504", "=q2=Adamantite Dagger", "=ds=#sr# 330"};
				{ 9, "s29566", "23502", "=q2=Adamantite Maul", "=ds=#sr# 325"};
				{ 10, "s29565", "23499", "=q2=Fel Iron Greatsword", "=ds=#sr# 320"};
				{ 11, "s29558", "23498", "=q2=Fel Iron Hammer", "=ds=#sr# 315"};
				{ 12, "s29557", "23497", "=q2=Fel Iron Hatchet", "=ds=#sr# 310"};
			};
		};
		info = {
			name = BLACKSMITHING..": "..BabbleInventory["Weapon"].." - "..AL["Burning Crusade"],
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};

	AtlasLoot_Data["SmithingWeaponWrath"] = {
		["Normal"] = {
			{
				{ 1, "s63182", "45085", "=q4=Titansteel Spellblade", "=ds="..AL["Trainer"] };
				{ 2, "s55370", "41383", "=q4=Titansteel Bonecrusher", "=ds="..AL["Trainer"] };
				{ 3, "s55369", "41257", "=q4=Titansteel Destroyer", "=ds="..AL["Trainer"] };
				{ 4, "s55371", "41384", "=q4=Titansteel Guardian", "=ds="..AL["Trainer"] };
				{ 5, "s56234", "42435", "=q4=Titansteel Shanker", "=ds="..AL["Trainer"] };
				{ 6, "s55183", "41186", "=q3=Corroded Saronite Edge", "=ds="..AL["Trainer"] };
				{ 7, "s55184", "41187", "=q3=Corroded Saronite Woundbringer", "=ds="..AL["Trainer"] };
				{ 8, "s55185", "41188", "=q3=Saronite Mindcrusher", "=ds="..AL["Trainer"] };
				{ 9, "s56280", "42443", "=q3=Cudgel of Saronite Justice", "=ds="..AL["Trainer"] };
				{ 10, "s55182", "41185", "=q3=Furious Saronite Beatstick", "=ds="..AL["Trainer"] };
				{ 11, "s59442", "43871", "=q3=Saronite Spellblade", "=ds="..AL["Trainer"] };
				{ 12, "s55206", "41245", "=q3=Deadly Saronite Dirk", "=ds="..AL["Trainer"] };
				{ 13, "s55181", "41184", "=q3=Saronite Shiv", "=ds="..AL["Trainer"] };
				{ 14, "s55179", "41183", "=q3=Saronite Ambusher", "=ds="..AL["Trainer"] };
				{ 15, "s55177", "41182", "=q3=Savage Cobalt Slicer", "=ds="..AL["Trainer"] };
				{ 16, "s55174", "41181", "=q3=Honed Cobalt Cleaver", "=ds="..AL["Trainer"] };
				{ 17, "s55204", "41243", "=q2=Notched Cobalt War Axe", "=ds="..AL["Trainer"] };
				{ 18, "s55202", "41241", "=q2=Sure-fire Shuriken", "=ds="..AL["Trainer"] };
				{ 19, "s55201", "41240", "=q2=Cobalt Tenderizer", "=ds="..AL["Trainer"] };
				{ 20, "s55200", "41239", "=q2=Sturdy Cobalt Quickblade", "=ds="..AL["Trainer"] };
				{ 21, "s55203", "41242", "=q2=Forged Cobalt Claymore", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = BLACKSMITHING..": "..BabbleInventory["Weapon"].." - "..AL["Wrath of the Lich King"],
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};
	
	AtlasLoot_Data["SmithingWeaponCata"] = {
		["Normal"] = {
			{
				{ 1, "s99652", "70155", "=q4=Brainsplinter", "=ds=#h1#, #w4# / =q1=#sk# 525", "=ds="..BabbleZone["Molten Front"]};
				{ 2, "s99655", "70158", "=q4=Elementium-Edged Scalper", "=ds=#h1#, #w1# / =q1=#sk# 525", "=ds="..BabbleZone["Molten Front"]};
				{ 3, "s99654", "70157", "=q4=Lightforged Elementium Hammer", "=ds=#h3#, #w6# / =q1=#sk# 525", "=ds="..BabbleZone["Molten Front"]};
				{ 4, "s99658", "70164", "=q4=Masterwork Elementium Deathblade", "=ds=#h2#, #w10# / =q1=#sk# 525", "=ds="..BabbleZone["Molten Front"]};
				{ 5, "s99653", "70156", "=q4=Masterwork Elementium Spellblade", "=ds=#h3#, #w4# / =q1=#sk# 525", "=ds="..BabbleZone["Molten Front"]};
				{ 6, "s99656", "70162", "=q4=Pyrium Spellward", "=ds=#h1#, #w10# / =q1=#sk# 525", "=ds="..BabbleZone["Molten Front"]};
				{ 7, "s99657", "70163", "=q4=Unbreakable Guardian", "=ds=#h1#, #w10# / =q1=#sk# 525", "=ds="..BabbleZone["Molten Front"]};
				{ 8, "s99660", "70165", "=q4=Witch-Hunter's Harvester", "=ds=#h2#, #w7# / =q1=#sk# 525", "=ds="..BabbleZone["Molten Front"]};
				{ 9, "s76454", "55069", "=q4=Elementium Earthguard", "=ds=#w8# / =q1=#sk# 520", "=ds="..AL["Vendor"]};
				{ 10, "s76455", "55070", "=q4=Elementium Stormshield", "=ds=#w8# / =q1=#sk# 520", "=ds="..AL["Vendor"]};
				{ 11, "s76451", "55066", "=q3=Elementium Poleaxe", "=ds=#w7# / =q1=#sk# 520", "=ds="..AL["Vendor"]};
				{ 12, "s76453", "55068", "=q3=Elementium Shank", "=ds=#h1#, #w4# / =q1=#sk# 520", "=ds="..AL["Vendor"]};
				{ 13, "s76449", "55064", "=q3=Elementium Spellblade", "=ds=#h3#, #w4# / =q1=#sk# 520", "=ds="..AL["Vendor"]};
				{ 14, "s94732", "67605", "=q3=Forged Elementium Mindcrusher", "=ds=#h2#, #w6# / =q1=#sk# 520", "=ds="..AL["Vendor"]};
				{ 15, "s94718", "67602", "=q3=Elementium Gutslicer", "=ds=#h1#, #w1# / =q1=#sk# 515", "=ds="..AL["Vendor"]};
				{ 16, "s76452", "55067", "=q3=Elementium Bonesplitter", "=ds=#h1#, #w1# / =q1=#sk# 515", "=ds="..AL["Vendor"]};
				{ 17, "s76450", "55065", "=q3=Elementium Hammer", "=ds=#h3#, #w6# / =q1=#sk# 515", "=ds="..AL["Vendor"]};
				{ 18, "s76433", "55043", "=q3=Decapitator's Razor", "=ds=#h1#, #w1# / =q1=#sk# 460", "=ds="..AL["Trainer"]};
				{ 19, "s76434", "55044", "=q3=Cold-Forged Shank", "=ds=#h1#, #w4# / =q1=#sk# 470","=ds="..AL["Trainer"]};
				{ 20, "s76474", "55246", "=q3=Obsidium Bladespear", "=ds=#w7# / =q1=#sk# 470","=ds="..AL["Trainer"]};
				{ 21, "s76435", "55045", "=q3=Fire-Etched Dagger", "=ds=#h3#, #w4# / =q1=#sk# 480","=ds="..AL["Trainer"]};
				{ 22, "s76436", "55046", "=q3=Lifeforce Hammer", "=ds=#h3#, #w6#   =q1=#sk# 480","=ds="..AL["Trainer"]};
				{ 23, "s76437", "55052", "=q3=Obsidium Executioner", "=ds=#h2#, #w10# / =q1=#sk# 480","=ds="..AL["Trainer"]};
				{ 24, "s76293", "55042", "=q2=Stormforged Shield", "=ds=#w8# / =q1=#sk# 470","=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = BLACKSMITHING..": "..BabbleInventory["Weapon"].." - "..AL["Cataclysm"],
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};

	AtlasLoot_Data["SmithingArmorEnhancement"] = {
		["Normal"] = {
			{
				{ 1, "s76439", "55054", "=q3=Ebonsteel Belt Buckle", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 2, "s55656", "41611", "=q3=Eternal Belt Buckle", "=ds=#sr# 415", "=ds="..AL["Trainer"]};
				{ 3, "s55628", "item_socketedbracer", "=ds=Socket Bracer", "=ds=#sr# 400", "=ds="..AL["Trainer"]};
				{ 4, "s55641", "INV_GAUNTLETS_61", "=ds=Socket Gloves", "=ds=#sr# 400", "=ds="..AL["Trainer"]};
				{ 6, "s32285", "25521", "=q1=Greater Rune of Warding", "=ds=#sr# 350", "=ds="..BabbleFaction["Cenarion Expedition"].." - "..BabbleFaction["Honored"]};
				{ 7, "s32284", "23559", "=q1=Lesser Rune of Warding", "=ds=#sr# 325", "=ds="..AL["Trainer"]};
				{ 9, "s9964", "7969", "=q2=Mithril Spurs", "=ds=#sr# 235", "=ds="..AL["World Drop"]};
				{ 16, "s76440", "55056", "=q3=Pyrium Shield Spike", "=ds=#sr# 525", "=ds="..AL["Trainer"]};
				{ 17, "s76441", "55055", "=q2=Elementium Shield Spike", "=ds=#sr# 490", "=ds="..AL["Trainer"]};
				{ 18, "s56357", "42500", "=q2=Titanium Shield Spike", "=ds=#sr# 420", "=ds="..AL["Trainer"]};
				{
					{ 19, "s29657", "23530", "=q2=Felsteel Shield Spike", "=ds=#sr# 360", "=ds="..BabbleFaction["Thrallmar"].." - "..BabbleFaction["Exalted"]};
					{ 19, "s29657", "23530", "=q2=Felsteel Shield Spike", "=ds=#sr# 360", "=ds="..BabbleFaction["Honor Hold"].." - "..BabbleFaction["Exalted"]};
				};
				{ 20, "s16651", "12645", "=q2=Thorium Shield Spike", "=ds=#sr# 275", "=ds="..AL["World Drop"]};
				{ 21, "s9939", "7967", "=q2=Mithril Shield Spike", "=ds=#sr# 215", "=ds="..AL["World Drop"]};
				{ 22, "s7221", "6042", "=q1=Iron Shield Spike", "=ds=#sr# 150", "=ds="..AL["World Drop"]};
				{
					{ 24, "s62202", "44936", "=q3=Titanium Plating", "=ds=#sr# 450", "=ds="..BabbleFaction["Horde Expedition"].." - "..BabbleFaction["Exalted"]};
					{ 24, "s62202", "44936", "=q3=Titanium Plating", "=ds=#sr# 450", "=ds="..BabbleFaction["Alliance Vanguard"].." - "..BabbleFaction["Exalted"]};
				};
				{ 25, "s29729", "23576", "=q1=Greater Ward of Shielding", "=ds=#sr# 375", "=ds="..AL["Drop"]..": "..BabbleZone["Netherstorm"]};
				{
					{ 26, "s29728", "23575", "=q1=Lesser Ward of Shielding", "=ds=#sr# 340", "=ds="..AL["Vendor"]..": "..BabbleZone["Hellfire Peninsula"].." / "..BabbleZone["Kelp'thar Forest"]};
					{ 26, "s29728", "23575", "=q1=Lesser Ward of Shielding", "=ds=#sr# 340", "=ds="..AL["Vendor"]..": "..BabbleZone["Shadowmoon Valley"].." / "..BabbleZone["Kelp'thar Forest"]};
				};
			};
		};
		info = {
			name = BLACKSMITHING..": "..AL["Armor Enhancements"],
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};

	AtlasLoot_Data["SmithingWeaponEnhancement"] = {
		["Normal"] = {
			{
				{ 1, "s22757", "18262", "=q2=Elemental Sharpening Stone", "=ds=#sr# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Molten Core"]};
				{ 2, "s29656", "23529", "=q2=Adamantite Sharpening Stone", "=ds=#sr# 350", "=ds="..BabbleFaction["Cenarion Expedition"].." - "..BabbleFaction["Honored"]};
				{ 3, "s29654", "23528", "=q1=Fel Sharpening Stone", "=ds=#sr# 300", "=ds="..AL["Trainer"]};
				{ 4, "s16641", "12404", "=q1=Dense Sharpening Stone", "=ds=#sr# 250", "=ds="..AL["Trainer"]};
				{ 5, "s9918", "7964", "=q1=Solid Sharpening Stone", "=ds=#sr# 200", "=ds="..AL["Trainer"]};
				{ 6, "s2674", "2871", "=q1=Heavy Sharpening Stone", "=ds=#sr# 125", "=ds="..AL["Trainer"]};
				{ 7, "s2665", "2863", "=q1=Coarse Sharpening Stone", "=ds=#sr# 65", "=ds="..AL["Trainer"]};
				{ 8, "s2660", "2862", "=q1=Rough Sharpening Stone", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
				{ 10, "s76442", "55057", "=q2=Pyrium Weapon Chain", "=ds=#sr# 500", "=ds="..AL["Vendor"]};
				{ 11, "s55839", "41976", "=q2=Titanium Weapon Chain", "=ds=#sr# 420", "=ds="..AL["Trainer"]};
				{ 12, "s42688", "33185", "=q2=Adamantite Weapon Chain", "=ds=#sr# 335", "=ds="..AL["Drop"]..": "..BabbleZone["Magisters' Terrace"].." / "..AL["World Drop"]};
				{ 13, "s7224", "6041", "=q1=Steel Weapon Chain", "=ds=#sr# 190", "=ds="..AL["World Drop"]};
				{ 16, "s34608", "28421", "=q2=Adamantite Weightstone", "=ds=#sr# 350", "=ds="..BabbleFaction["Cenarion Expedition"].." - "..BabbleFaction["Honored"]};
				{ 17, "s34607", "28420", "=q1=Fel Weightstone", "=ds=#sr# 300", "=ds="..AL["Trainer"]};
				{ 18, "s16640", "12643", "=q1=Dense Weightstone", "=ds=#sr# 250", "=ds="..AL["Trainer"]};
				{ 19, "s9921", "7965", "=q1=Solid Weightstone", "=ds=#sr# 200", "=ds="..AL["Trainer"]};
				{ 20, "s3117", "3241", "=q1=Heavy Weightstone", "=ds=#sr# 125", "=ds="..AL["Trainer"]};
				{ 21, "s3116", "3240", "=q1=Coarse Weightstone", "=ds=#sr# 65", "=ds="..AL["Trainer"]};
				{ 22, "s3115", "3239", "=q1=Rough Weightstone", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
				{ 24, "s7222", "6043", "=q1=Iron Counterweight", "=ds=#sr# 165", "=ds="..AL["World Drop"]};
			};
		};
		info = {
			name = BLACKSMITHING..": "..AL["Weapon Enhancements"],
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};

	AtlasLoot_Data["SmithingMisc"] = {
		["Normal"] = {
			{
				{ 1, "s76438", "55053", "=q1=Obsidium Skeleton Key", "=ds=#sr# 475", "=ds="..AL["Trainer"]};
				{ 2, "s59406", "43853", "=q2=Titanium Skeleton Key", "=ds=#sr# 430", "=ds="..AL["Trainer"]};
				{ 3, "s59405", "43854", "=q2=Cobalt Skeleton Key", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 4, "s19669", "15872", "=q2=Arcanite Skeleton Key", "=ds=#sr# 275", "=ds="..AL["Trainer"]};
				{ 5, "s19668", "15871", "=q2=Truesilver Skeleton Key", "=ds=#sr# 200", "=ds="..AL["Trainer"]};
				{ 6, "s19667", "15870", "=q2=Golden Skeleton Key", "=ds=#sr# 150", "=ds="..AL["Trainer"]};
				{ 7, "s19666", "15869", "=q2=Silver Skeleton Key", "=ds=#sr# 100", "=ds="..AL["Trainer"]};
				{ 9, "s76178", "65365", "=q1=Folded Obsidium", "=ds=#sr# 425", "=ds="..AL["Trainer"]};
				{ 10, "s16639", "12644", "=q1=Dense Grinding Stone", "=ds=#sr# 250", "=ds="..AL["Trainer"]};
				{ 11, "s9920", "7966", "=q1=Solid Grinding Stone", "=ds=#sr# 200", "=ds="..AL["Trainer"]};
				{ 12, "s3337", "3486", "=q1=Heavy Grinding Stone", "=ds=#sr# 125", "=ds="..AL["Trainer"]};
				{ 13, "s3326", "3478", "=q1=Coarse Grinding Stone", "=ds=#sr# 75", "=ds="..AL["Trainer"]};
				{ 14, "s3320", "3470", "=q1=Rough Grinding Stone", "=ds=#sr# 25", "=ds="..AL["Trainer"]};
				{ 16, "s92375", "65358", "=q1=Elementium Rod", "=ds=#sr# 475", "=ds="..AL["Trainer"] };
				{ 17, "s55732", "41745", "=q1=Titanium Rod", "=ds=#sr# 420", "=ds="..AL["Trainer"]};
				{
					{ 18, "s32657", "25845", "=q1=Eternium Rod", "=ds=#sr# 360", "=ds="..AL["Vendor"]..": "..BabbleZone["Hellfire Peninsula"].." / "..BabbleZone["Kelp'thar Forest"]};
					{ 18, "s32657", "25845", "=q1=Eternium Rod", "=ds=#sr# 360", "=ds="..AL["Vendor"]..": "..BabbleZone["Shadowmoon Valley"].." / "..BabbleZone["Kelp'thar Forest"]};
				};
				{ 19, "s32656", "25844", "=q1=Adamantite Rod", "=ds=#sr# 350", "=ds="..AL["Vendor"]..": "..BabbleZone["Shattrath City"].." / "..BabbleZone["Kelp'thar Forest"]};
				{ 20, "s32655", "25843", "=q1=Fel Iron Rod", "=ds=#sr# 300", "=ds="..AL["Trainer"]};
				{ 21, "s20201", "16206", "=q1=Arcanite Rod", "=ds=#sr# 275", "=ds="..AL["Trainer"]};
				{ 22, "s14380", "11144", "=q1=Truesilver Rod", "=ds=#sr# 200", "=ds="..AL["Trainer"]};
				{ 23, "s14379", "11128", "=q1=Golden Rod", "=ds=#sr# 150", "=ds="..AL["Trainer"]};
				{ 24, "s7818", "6338", "=q1=Silver Rod", "=ds=#sr# 100", "=ds="..AL["Trainer"]};
				{ 26, "s11454", "9060", "=q1=Inlaid Mithril Cylinder", "=ds=#sr# 200", "=ds="..AL["Crafted"]..": "..GetSpellInfo(4036).." (205)"};
				{ 27, "s8768", "7071", "=q1=Iron Buckle", "=ds=#sr# 150", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = BLACKSMITHING..": "..BabbleInventory["Miscellaneous"],
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};

	AtlasLoot_Data["Armorsmith"] = {
		["Normal"] = {
			{
				{ 1, "s55187", "41190", "=q3=Legplates of Conquest", "=ds=#sr# 415"};
				{ 2, "s55186", "41189", "=q3=Chestplate of Conquest", "=ds=#sr# 415"};
				{ 3, "s34530", "23564", "=q4=Twisting Nether Chain Shirt", "=ds=#sr# 375"};
				{ 4, "s36256", "23565", "=q4=Embrace of the Twisting Nether", "=ds=#sr# 375"};
				{ 5, "s36257", "28485", "=q4=Bulwark of the Ancient Kings", "=ds=#sr# 375"};
				{ 6, "s34534", "28484", "=q4=Bulwark of Kings", "=ds=#sr# 375"};
				{ 7, "s34529", "23563", "=q4=Nether Chain Shirt", "=ds=#sr# 350"};
				{ 8, "s34533", "28483", "=q4=Breastplate of Kings", "=ds=#sr# 350"};
				{ 9, "s36130", "30076", "=q3=Stormforged Hauberk", "=ds=#sr# 330"};
				{ 10, "s36129", "30074", "=q3=Heavy Earthforged Breastplate", "=ds=#sr# 330"};
				{ 11, "s36124", "30070", "=q3=Windforged Leggings", "=ds=#sr# 260"};
				{ 12, "s36122", "30069", "=q3=Earthforged Leggings", "=ds=#sr# 260"};
			};
		};
		info = {
			name = ARMORSMITH,
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};

	AtlasLoot_Data["Weaponsmith"] = {
		["Normal"] = {
			{
				{ 1, "s55185", "41188", "=q3=Saronite Mindcrusher", "=ds=#sr# 415"};
				{ 2, "s55184", "41187", "=q3=Corroded Saronite Woundbringer", "=ds=#sr# 415"};
				{ 3, "s55183", "41186", "=q3=Corroded Saronite Edge", "=ds=#sr# 415"};
				{ 4, "s36126", "30072", "=q3=Light Skyforged Axe", "=ds=#sr# 260"};
				{ 5, "s36128", "30073", "=q3=Light Emberforged Hammer", "=ds=#sr# 260"};
				{ 6, "s36125", "30071", "=q3=Light Earthforged Blade", "=ds=#sr# 260"};
			};
		};
		info = {
			name = WEAPONSMITH,
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};

	AtlasLoot_Data["Axesmith"] = {
		["Normal"] = {
			{
				{ 1, "s36260", "28433", "=q4=Wicked Edge of the Planes", "=ds=#sr# 375"};
				{ 2, "s34544", "28435", "=q4=Mooncleaver", "=ds=#sr# 375"};
				{ 3, "s36261", "28436", "=q4=Bloodmoon", "=ds=#sr# 375"};
				{ 4, "s34542", "28432", "=q4=Black Planar Edge", "=ds=#sr# 375"};
				{ 5, "s34541", "28431", "=q4=The Planar Edge", "=ds=#sr# 350"};
				{ 6, "s34543", "28434", "=q4=Lunar Crescent", "=ds=#sr# 350"};
				{ 7, "s36134", "30087", "=q3=Stormforged Axe", "=ds=#sr# 330"};
				{ 8, "s36135", "30088", "=q3=Skyforged Great Axe", "=ds=#sr# 330"};
			};
		};
		info = {
			name = AXESMITH,
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};

	AtlasLoot_Data["Hammersmith"] = {
		["Normal"] = {
			{
				{ 1, "s36263", "28442", "=q4=Stormherald", "=ds=#sr# 375"};
				{ 2, "s36262", "28439", "=q4=Dragonstrike", "=ds=#sr# 375"};
				{ 3, "s34546", "28438", "=q4=Dragonmaw", "=ds=#sr# 375"};
				{ 4, "s34548", "28441", "=q4=Deep Thunder", "=ds=#sr# 375"};
				{ 5, "s34547", "28440", "=q4=Thunder", "=ds=#sr# 350"};
				{ 6, "s34545", "28437", "=q4=Drakefist Hammer", "=ds=#sr# 350"};
				{ 7, "s36136", "30089", "=q3=Lavaforged Warhammer", "=ds=#sr# 330"};
				{ 8, "s36137", "30093", "=q3=Great Earthforged Hammer", "=ds=#sr# 330"};
			};
		};
		info = {
			name = HAMMERSMITH,
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};

	AtlasLoot_Data["Swordsmith"] = {
		["Normal"] = {
			{
				{ 1, "s36259", "28430", "=q4=Lionheart Executioner", "=ds=#sr# 375"};
				{ 2, "s34540", "28429", "=q4=Lionheart Champion", "=ds=#sr# 375"};
				{ 3, "s34537", "28426", "=q4=Blazeguard", "=ds=#sr# 375"};
				{ 4, "s36258", "28427", "=q4=Blazefury", "=ds=#sr# 375"};
				{ 5, "s34538", "28428", "=q4=Lionheart Blade", "=ds=#sr# 350"};
				{ 6, "s34535", "28425", "=q4=Fireguard", "=ds=#sr# 350"};
				{ 7, "s36131", "30077", "=q3=Windforged Rapier", "=ds=#sr# 330"};
				{ 8, "s36133", "30086", "=q3=Stoneforged Claymore", "=ds=#sr# 330"};
			};
		};
		info = {
			name = SWORDSMITH,
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};

	AtlasLoot_Data["SmithingCataVendor"] = {
		["Normal"] = {
			{
				{ 1, 66117, "", "=q1=Plans: Vicious Pyrium Bracers", "=ds=#p2# (500)", "20 #elementiumbar#" },
				{ 2, 66125, "", "=q1=Plans: Vicious Ornate Pyrium Bracers", "=ds=#p2# (500)", "20 #elementiumbar#" },
				{ 3, 66103, "", "=q1=Plans: Pyrium Weapon Chain", "=ds=#p2# (500)", "20 #elementiumbar#" },
				{ 4, 66118, "", "=q1=Plans: Vicious Pyrium Gauntlets", "=ds=#p2# (505)", "20 #elementiumbar#" },
				{ 5, 66126, "", "=q1=Plans: Vicious Ornate Pyrium Gauntlets", "=ds=#p2# (505)", "20 #elementiumbar#" },
				{ 6, 66119, "", "=q1=Plans: Vicious Pyrium Belt", "=ds=#p2# (510)", "20 #elementiumbar#" },
				{ 7, 66107, "", "=q1=Plans: Elementium Girdle of Pain", "=ds=#p2# (510)", "20 #elementiumbar#" },
				{ 8, 66105, "", "=q1=Plans: Hardened Elementium Girdle", "=ds=#p2# (510)", "20 #elementiumbar#" },
				{ 9, 66109, "", "=q1=Plans: Light Elementium Belt", "=ds=#p2# (510)", "20 #elementiumbar#" },
				{ 10, 66127, "", "=q1=Plans: Vicious Ornate Pyrium Belt", "=ds=#p2# (510)", "20 #elementiumbar#" },
				{ 11, 66120, "", "=q1=Plans: Vicious Pyrium Boots", "=ds=#p2# (515)", "2 #hardenedelementiumbar#" },
				{ 12, 67603, "", "=q1=Plans: Elementium Gutslicer", "=ds=#p2# (515)", "2 #hardenedelementiumbar#" },
				{ 13, 66113, "", "=q1=Plans: Elementium Bonesplitter", "=ds=#p2# (515)", "2 #hardenedelementiumbar#" },
				{ 14, 66106, "", "=q1=Plans: Elementium Deathplate", "=ds=#p2# (515)", "2 #hardenedelementiumbar#" },
				{ 15, 66111, "", "=q1=Plans: Elementium Hammer", "=ds=#p2# (515)", "2 #hardenedelementiumbar#" },
				{ 16, 66104, "", "=q1=Plans: Hardened Elementium Hauberk", "=ds=#p2# (515)", "2 #hardenedelementiumbar#" },
				{ 17, 66108, "", "=q1=Plans: Light Elementium Chestguard", "=ds=#p2# (515)", "2 #hardenedelementiumbar#" },
				{ 18, 66128, "", "=q1=Plans: Vicious Ornate Pyrium Boots", "=ds=#p2# (515)", "2 #hardenedelementiumbar#" },
				{ 19, 66121, "", "=q1=Plans: Vicious Pyrium Shoulders", "=ds=#p2# (520)", "2 #hardenedelementiumbar#" },
				{ 20, 66115, "", "=q1=Plans: Elementium Earthguard", "=ds=#p2# (520)", "2 #hardenedelementiumbar#" },
				{ 21, 66112, "", "=q1=Plans: Elementium Poleaxe", "=ds=#p2# (520)", "2 #hardenedelementiumbar#" },
				{ 22, 66114, "", "=q1=Plans: Elementium Shank", "=ds=#p2# (520)", "2 #hardenedelementiumbar#" },
				{ 23, 66110, "", "=q1=Plans: Elementium Spellblade", "=ds=#p2# (520)", "2 #hardenedelementiumbar#" },
				{ 24, 66116, "", "=q1=Plans: Elementium Stormshield", "=ds=#p2# (520)", "2 #hardenedelementiumbar#" },
				{ 25, 67606, "", "=q1=Plans: Forged Elementium Mindcrusher", "=ds=#p2# (520)", "5 #pyriumbar#" },
				{ 26, 66129, "", "=q1=Plans: Vicious Ornate Pyrium Shoulders", "=ds=#p2# (520)", "2 #hardenedelementiumbar#" },
				{ 27, 67606, "", "=q1=Plans: Forged Elementium Mindcrusher", "=ds=#p2# (520)", "5 #pyriumbar#" },
				{ 28, 66124, "", "=q1=Plans: Vicious Pyrium Breastplate", "=ds=#p2# (525)", "5 #pyriumbar#" },
				{ 29, 66123, "", "=q1=Plans: Vicious Pyrium Helm", "=ds=#p2# (525)", "5 #pyriumbar#" },
				{ 30, 66122, "", "=q1=Plans: Vicious Pyrium Legguards", "=ds=#p2# (525)", "5 #pyriumbar#" },
			};
			{
				{ 1, 66100, "", "=q1=Plans: Ebonsteel Belt Buckle", "=ds=#p2# (525)", "5 #pyriumbar#" },
				{ 2, 66132, "", "=q1=Plans: Vicious Ornate Pyrium Breastplate", "=ds=#p2# (525)", "5 #pyriumbar#" },
				{ 3, 66131, "", "=q1=Plans: Vicious Ornate Pyrium Helm", "=ds=#p2# (525)", "5 #pyriumbar#" },
				{ 4, 66130, "", "=q1=Plans: Vicious Ornate Pyrium Legguards", "=ds=#p2# (525)", "5 #pyriumbar#" },
				{ 5, 66101, "", "=q1=Plans: Pyrium Shield Spike", "=ds=#p2# (525)", "5 #pyriumbar#" },
			};
		};
		info = {
			name = BLACKSMITHING..": "..AL["Cataclysm Vendor Sold Plans"],
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};

	AtlasLoot_Data["SmithingArmorRemoved"] = {
		["Normal"] = {
			{
				{ 1, "s28244", "22671", "=q4=Icebane Bracers", "=ds=#sr# 300"};
				{ 2, "s28242", "22669", "=q4=Icebane Breastplate", "=ds=#sr# 300"};
				{ 3, "s28243", "22670", "=q4=Icebane Gauntlets", "=ds=#sr# 300"};
				{ 4, "s24136", "19690", "=q3=Bloodsoul Breastplate", "=ds=#sr# 300"};
				{ 5, "s24138", "19692", "=q3=Bloodsoul Gauntlets", "=ds=#sr# 300"};
				{ 6, "s24137", "19691", "=q3=Bloodsoul Shoulders", "=ds=#sr# 300"};
				{ 7, "s24139", "19693", "=q3=Darksoul Breastplate", "=ds=#sr# 300"};
				{ 8, "s24140", "19694", "=q3=Darksoul Leggings", "=ds=#sr# 300"};
				{ 9, "s24141", "19695", "=q3=Darksoul Shoulders", "=ds=#sr# 300"};
				{ 10, "s16665", "12611", "=q2=Runic Plate Boots", "=ds=#sr# 300"};
				{ 11, "s16655", "12631", "=q3=Fiery Plate Gauntlets", "=ds=#sr# 290"};
				{ 12, "s16667", "12628", "=q3=Demon Forged Breastplate", "=ds=#sr# 285"};
				{ 13, "s36122", "30069", "=q3=Earthforged Leggings", "=ds=#sr# 260"};
				{ 14, "s36124", "30070", "=q3=Windforged Leggings", "=ds=#sr# 260"};
				{ 15, "s9974", "7939", "=q3=Truesilver Breastplate", "=ds=#sr# 245"};
				{ 16, "s9979", "7936", "=q2=Ornate Mithril Boots", "=ds=#sr# 245"};
				{ 17, "s9980", "7937", "=q2=Ornate Mithril Helm", "=ds=#sr# 245"};
				{ 18, "s9972", "7935", "=q2=Ornate Mithril Breastplate", "=ds=#sr# 240"};
				{ 19, "s9954", "7938", "=q3=Truesilver Gauntlets", "=ds=#sr# 225"};
				{ 20, "s9952", "7928", "=q2=Ornate Mithril Shoulder", "=ds=#sr# 225"};
				{ 21, "s9950", "7927", "=q2=Ornate Mithril Gloves", "=ds=#sr# 220"};
				{ 22, "s9945", "7926", "=q2=Ornate Mithril Pants", "=ds=#sr# 220"};
				{ 23, "s9957", "7929", "=q2=Orcish War Leggings", "=ds=#sr# 230"};
				{ 24, "s11643", "9366", "=q2=Golden Scale Gauntlets", "=ds=#sr# 205"};
			};
		};
		info = {
			name = BLACKSMITHING..": "..BabbleInventory["Armor"],
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};

	AtlasLoot_Data["SmithingWeaponRemoved"] = {
		["Normal"] = {
			{
				{ 1, "s16978", "12777", "=q3=Blazing Rapier", "=ds=#h1#, #w10#"};
				{ 2, "s10011", "7959", "=q3=Blight", "=ds=#w7#"};
				{ 3, "s16970", "12774", "=q3=Dawn's Edge", "=ds=#h1#, #w1#"};
				{ 4, "s16973", "12776", "=q3=Enchanted Battlehammer", "=ds=#h2#, #w6#"};
				{ 5, "s36125", "30071", "=q3=Light Earthforged Blade", "=ds=#h1#, #w10#"};
				{ 6, "s36128", "30073", "=q3=Light Emberforged Hammer", "=ds=#h1#, #w6#"};
				{ 7, "s36126", "30072", "=q3=Light Skyforged Axe", "=ds=#h1#, #w1#"};
				{ 8, "s10003", "7954", "=q3=The Shatterer", "=ds=#h1#, #w6#"};
				{ 9, "s10015", "7960", "=q3=Truesilver Champion", "=ds=#h2#, #w10#"};
				{ 10, "s16984", "12792", "=q2=Volcanic Hammer", "=ds=#h1#, #w6#"};
			};
		};
		info = {
			name = BLACKSMITHING..": "..BabbleInventory["Weapon"],
			module = moduleName, menu = "SMITHINGMENU", instance = "Blacksmithing",
		};
	};
		---------------
		--- Cooking ---
		---------------

	AtlasLoot_Data["CookingStandard"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Health"]};
				{ 2, "s88018", "62677", "=q1=Fish Fry", "=ds=#sr# 500", "=ds="..AL["Cooking Daily"]};
				{ 3, "s88006", "62676", "=q1=Blackened Surprise", "=ds=#sr# 425", "=ds="..AL["Trainer"]};
				{ 4, "s57421", "34747", "=q1=Northern Stew", "=ds=#sr# 350", "=ds="..BabbleInventory["Quest"]};
				{ 5, "s42296", "33048", "=q1=Stewed Trout", "=ds=#sr# 320", "=ds="..AL["Trainer"]};
				{ 6, "s33290", "27661", "=q1=Blackened Trout", "=ds=#sr# 300", "=ds="..AL["Vendor"]..": "..BabbleZone["Zangarmarsh"]};
				{ 7, "s18247", "13935", "=q1=Baked Salmon", "=ds=#sr# 275", "=ds="..AL["Vendor"]..": "..BabbleZone["Feralas"]};
				{ 8, "s18245", "13933", "=q1=Lobster Stew", "=ds=#sr# 275", "=ds="..AL["Vendor"]..": "..BabbleZone["Feralas"]};
				{ 9, "s18241", "13930", "=q1=Filet of Redgill", "=ds=#sr# 225", "=ds="..AL["Vendor"]..": "..BabbleZone["Stranglethorn Vale"]};
				{ 10, "s18238", "6887", "=q1=Spotted Yellowtail", "=ds=#sr# 225", "=ds="..AL["Trainer"]};
				{ 11, "s20626", "16766", "=q1=Undermine Clam Chowder", "=ds=#sr# 225", "=ds="..AL["Vendor"]..": "..BabbleZone["Tanaris"]};
				{ 12, "s20916", "8364", "=q1=Mithril Head Trout", "=ds=#sr# 175", "=ds="..AL["Vendor"]};
				{ 13, "s7828", "4594", "=q1=Rockscale Cod", "=ds=#sr# 175", "=ds="..AL["Vendor"]};
				{ 14, "s2548", "2685", "=q1=Succulent Pork Ribs", "=ds=#sr# 110", "=ds="..AL["Drop"]};
				{ 15, "s7755", "4593", "=q1=Bristle Whisker Catfish", "=ds=#sr# 100", "=ds="..AL["Vendor"]};
				{ 17, "s6501", "5526", "=q1=Clam Chowder", "=ds=#sr# 90", "=ds="..AL["Vendor"]};
				{ 18, "s6417", "5478", "=q1=Dig Rat Stew", "=ds=#sr# 90", "=ds="..AL["Vendor"]};
				{ 19, "s2543", "733", "=q1=Westfall Stew", "=ds=#sr# 90", "=ds="..AL["Drop"]};
				{ 20, "s7754", "6316", "=q1=Loch Frenzy Delight", "=ds=#sr# 50", "=ds="..AL["Vendor"]};	
				{ 21, "s7753", "4592", "=q1=Longjaw Mud Snapper", "=ds=#sr# 50", "=ds="..AL["Vendor"]};
				{ 22, "s7827", "5095", "=q1=Rainbow Fin Albacore", "=ds=#sr# 50", "=ds="..AL["Vendor"]};
				{ 23, "s93741", "67230", "=q1=Venison Jerky", "=ds=#sr# 40", "=ds="..AL["Trainer"]};
				{ 24, "s8607", "6890", "=q1=Smoked Bear Meat", "=ds=#sr# 40", "=ds="..AL["Vendor"]};
				{ 25, "s7751", "6290", "=q1=Brilliant Smallfish", "=ds=#sr# 1", "=ds="..AL["Vendor"]};
				{ 26, "s2538", "2679", "=q1=Charred Wolf Meat", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
				{ 27, "s2540", "2681", "=q1=Roasted Boar Meat", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
				{ 28, "s7752", "787", "=q1=Slitherskin Mackerel", "=ds=#sr# 1", "=ds="..AL["Vendor"]};
				{ 29, "s37836", "30816", "=q1=Spice Bread", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Health and Mana"]};
				{ 2, "s96133", "68687", "=q1=Scalding Murglesnout", "=ds=#sr# 500", "=ds="..AL["Cooking Daily"]};
				{ 3, "s64358", "45932", "=q1=Black Jelly", "=ds=#sr# 400", "=ds="..AL["Trainer"]};
				{ 4, "s45561", "34760", "=q1=Grilled Bonescale", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 5, "s42305", "33053", "=q1=Hot Buttered Trout", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 6, "s45562", "34761", "=q1=Sauteed Goby", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 7, "s45560", "34759", "=q1=Smoked Rockfin", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 8, "s2545", "2682", "=q1=Cooked Crab Claw", "=ds=#sr# 85", "=ds="..AL["World Drop"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Mana"]};
				{ 17, "s88044", "62672", "=q1=South Island Ice Tea", "=ds=#sr# 525", "=ds="..AL["Cooking Daily"]};
				{ 18, "s88045", "62675", "=q1=Starfire Espresso", "=ds=#sr# 450", "=ds="..AL["Cooking Daily"]};
				{ 19, "s53056", "39520", "=q1=Kungaloosh", "=ds=#sr# 350", "=ds=#QUESTID:13571#"};
				{ 20, "s13028", "10841", "=q1=Goldthorn Tea", "=ds=#sr# 175", "=ds="..BabbleZone["Razorfen Downs"]};
			};
		};
		info = {
			name = COOKING,
			module = moduleName, menu = "COOKINGMENU"
		};
	};

	AtlasLoot_Data["CookingSpecial"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Tracking"]};
				{ 2, "s57438", "42997", "=q1=Blackened Worg Steak", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 3, "s57443", "43001", "=q1=Tracker Snacks", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 5, 0, "INV_Box_01", "=q6="..AL["Emotions"]};
				{ 6, "s58523", "43491", "=q1=Bad Clams", "=ds=#sr# 350", "=ds="..AL["Drop"]};
				{ 7, "s58525", "43492", "=q1=Haunted Herring", "=ds=#sr# 350", "=ds="..AL["Drop"]};
				{ 8, "s58521", "43488", "=q1=Last Week's Mammoth", "=ds=#sr# 350", "=ds="..AL["Drop"]};
				{ 9, "s58512", "43490", "=q1=Tasty Cupcake", "=ds=#sr# 350", "=ds="..AL["Drop"]};
				{ 10, "s43779", "33924", "=q1=Delicious Chocolate Cake", "=ds=#sr# 1", "=ds="..AL["Cooking Daily"]};
				{ 12, 0, "INV_Box_01", "=q6=#p24#"};
				{ 13, "s88017", "62673", "=q1=Feathered Lure", "=ds=#sr# 450", "=ds="..AL["Cooking Daily"]};
				{ 14, "s45695", "34832", "=q1=Captain Rumsey's Lager", "=ds=#sr# 100", "=ds="..AL["Drop"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Alcohol"]};
				{ 17, "s88015", "62790", "=q1=Darkbrew Lager", "=ds=#sr# 415", "=ds="..AL["Trainer"]};
				{ 18, "s88022", "62674", "=q1=Highland Spirits", "=ds=#sr# 450", "=ds="..AL["Cooking Daily"]};
				{ 20, 0, "INV_Box_01", "=q6="..AL["Other"]};
				{ 21, "s88013", "62680", "=q1=Chocolate Cookie", "=ds=#sr# 505", "=ds="..AL["Cooking Daily"]};
				{ 22, "s57435", "43004", "=q1=Critter Bites", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 23, "s43758", "33866", "=q1=Stormchops", "=ds=#sr# 300", "=ds="..AL["Drop"]};
				{ 24, "s15906", "12217", "=q1=Dragonbreath Chili", "=ds=#sr# 200", "=ds="..AL["Vendor"]};
				{ 25, "s8238", "6657", "=q1=Savory Deviate Delight", "=ds=#sr# 85", "=ds="..AL["Drop"]};
				{ 26, "s9513", "7676", "=q1=Thistle Tea", "=ds=#sr# 60", "=ds="..AL["Vendor"]..": "..BabbleZone["Hillsbrad Foothills"]};
				{ 27, "s6413", "5473", "=q1=Scorpid Surprise", "=ds=#sr# 20", "=ds="..AL["Vendor"]..": "..BabbleZone["Durotar"]};
			};
		};
		info = {
			name = COOKING,
			module = moduleName, menu = "COOKINGMENU"
		};
	};

	AtlasLoot_Data["CookingBuff"] = {
		["Normal"] = {
			{
				{ 1, "s88016", "62666", "=q1=Delicious Sagefish Tail", "=ds=#sr# 500", "=ds="..AL["Cooking Daily"]};
				{ 2, "s88047", "62656", "=q1=Whitecrest Gumbo", "=ds=#sr# 450", "=ds="..AL["Cooking Daily"]};
				{ 3, "s57439", "42998", "=q1=Cuttlesteak", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 4, "s57433", "42993", "=q1=Spicy Fried Herring", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 5, "s45559", "34758", "=q1=Mighty Rhino Dogs", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 6, "s42302", "33052", "=q1=Fisherman's Feast", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 7, "s45566", "34765", "=q1=Pickled Fangtooth", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 8, "s45553", "34752", "=q1=Rhino Dogs", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 9, "s33296", "27667", "=q1=Spicy Crawdad", "=ds=#sr# 350", "=ds="..AL["Vendor"]..": "..BabbleZone["Terokkar Forest"]};
				{ 10, "s38867", "31672", "=q1=Mok'Nathal Shortribs", "=ds=#sr# 335", "=ds="..AL["Vendor"]..": "..BabbleZone["Blade's Edge Mountains"]};
				{ 11, "s45022", "34411", "=q1=Hot Apple Cider", "=ds=#sr# 325", "=ds="..AL["Vendor"]};
				{ 12, "s33289", "27660", "=q1=Talbuk Steak", "=ds=#sr# 325", "=ds="..AL["Vendor"]..": "..BabbleZone["Nagrand"]};
				{ 13, "s33279", "27651", "=q1=Buzzard Bites", "=ds=#sr# 300", "=ds="..BabbleInventory["Quest"]};
				{ 14, "s36210", "30155", "=q1=Clam Bar", "=ds=#sr# 300", "=ds="..AL["Vendor"]..": "..BabbleZone["Zangarmarsh"]};
				{ 15, "s25659", "21023", "=q1=Dirge's Kickin' Chimaerok Chops", "=ds=#sr# 300", "=ds="..BabbleInventory["Quest"]};
				{ 16, "s33291", "27662", "=q1=Feltail Delight", "=ds=#sr# 300", "=ds="..AL["Vendor"]..": "..BabbleZone["Zangarmarsh"]};
				{ 17, "s18246", "13934", "=q1=Mightfish Steak", "=ds=#sr# 275", "=ds="..AL["Vendor"]..": "..BabbleZone["Feralas"]};
				{ 18, "s18242", "13929", "=q1=Hot Smoked Bass", "=ds=#sr# 240", "=ds="..AL["Vendor"]..": "..BabbleZone["Stranglethorn Vale"]};
				{ 19, "s18239", "13927", "=q1=Cooked Glossy Mightfish", "=ds=#sr# 225", "=ds="..AL["Vendor"]..": "..BabbleZone["Stranglethorn Vale"]};
				{ 20, "s15933", "12218", "=q1=Monster Omelet", "=ds=#sr# 225", "=ds="..AL["Vendor"]};
				{ 21, "s15915", "12216", "=q1=Spiced Chili Crab", "=ds=#sr# 225", "=ds="..AL["Vendor"]};
				{ 22, "s22480", "18045", "=q1=Tender Wolf Steak", "=ds=#sr# 225", "=ds="..AL["Vendor"]};
				{ 23, "s15910", "12215", "=q1=Heavy Kodo Stew", "=ds=#sr# 200", "=ds="..AL["Vendor"]..": "..BabbleZone["Desolace"]};
				{ 24, "s21175", "17222", "=q1=Spider Sausage", "=ds=#sr# 200", "=ds="..AL["Trainer"]};
				{ 25, "s4094", "4457", "=q1=Barbecued Buzzard Wing", "=ds=#sr# 175", "=ds="..AL["Trainer"]};
				{ 26, "s15863", "12213", "=q1=Carrion Surprise", "=ds=#sr# 175", "=ds="..AL["Vendor"]};
				{ 27, "s7213", "6038", "=q1=Giant Clam Scorcho", "=ds=#sr# 175", "=ds="..AL["Vendor"]..": "..BabbleZone["Stranglethorn Vale"]};
				{ 28, "s15856", "13851", "=q1=Hot Wolf Ribs", "=ds=#sr# 175", "=ds="..AL["Vendor"]};
				{ 29, "s15861", "12212", "=q1=Jungle Stew", "=ds=#sr# 175", "=ds="..AL["Vendor"]};
				{ 30, "s15865", "12214", "=q1=Mystery Stew", "=ds=#sr# 175", "=ds="..AL["Vendor"]};
			};
			{
				{ 1, "s15855", "12210", "=q1=Roast Raptor", "=ds=#sr# 175", "=ds="..AL["Vendor"]};
				{ 2, "s3400", "3729", "=q1=Soothing Turtle Bisque", "=ds=#sr# 175", "=ds="..BabbleInventory["Quest"]};
				{ 3, "s24418", "20074", "=q1=Heavy Crocolisk Stew", "=ds=#sr# 150", "=ds="..AL["Vendor"]..": "..BabbleZone["Dustwallow Marsh"]};
				{ 4, "s3399", "3728", "=q1=Tasty Lion Steak", "=ds=#sr# 150", "=ds="..BabbleInventory["Quest"]};
				{ 5, "s3376", "3665", "=q1=Curiously Tasty Omelet", "=ds=#sr# 130", "=ds="..AL["Vendor"]};
				{ 6, "s6500", "5527", "=q1=Goblin Deviled Clams", "=ds=#sr# 125", "=ds="..AL["Trainer"]};
				{ 7, "s15853", "12209", "=q1=Lean Wolf Steak", "=ds=#sr# 125", "=ds="..AL["Vendor"]..": "..BabbleZone["Desolace"]};
				{ 8, "s3373", "3664", "=q1=Crocolisk Gumbo", "=ds=#sr# 120", "=ds="..AL["Vendor"]};
				{ 9, "s3397", "3726", "=q1=Big Bear Steak", "=ds=#sr# 110", "=ds="..AL["Vendor"]..": "..BabbleZone["Desolace"]};
				{ 10, "s3377", "3666", "=q1=Gooey Spider Cake", "=ds=#sr# 110", "=ds="..BabbleInventory["Quest"]};
				{ 11, "s6419", "5480", "=q1=Lean Venison", "=ds=#sr# 110", "=ds="..AL["Vendor"]..": "..BabbleZone["Desolace"]};
				{ 12, "s6418", "5479", "=q1=Crispy Lizard Tail", "=ds=#sr# 100", "=ds="..AL["Vendor"]..": "..BabbleZone["Northern Barrens"]};
				{ 13, "s2547", "1082", "=q1=Redridge Goulash", "=ds=#sr# 100", "=ds="..AL["Vendor"]..": "..BabbleZone["Stormwind City"]};
				{ 14, "s2549", "1017", "=q1=Seasoned Wolf Kabob", "=ds=#sr# 100", "=ds="..BabbleInventory["Quest"]};
				{ 15, "s3372", "3663", "=q1=Murloc Fin Soup", "=ds=#sr# 90", "=ds="..AL["Vendor"]..": "..BabbleZone["Stormwind City"]};
				{ 16, "s3370", "3662", "=q1=Crocolisk Steak", "=ds=#sr# 80", "=ds="..AL["Vendor"]..": "..BabbleZone["Stormwind City"]};
				{ 17, "s2546", "2687", "=q1=Dry Pork Ribs", "=ds=#sr# 80", "=ds="..AL["Trainer"]};
				{ 18, "s2544", "2683", "=q1=Crab Cake", "=ds=#sr# 75", "=ds="..AL["Trainer"]};
				{ 19, "s3371", "3220", "=q1=Blood Sausage", "=ds=#sr# 60", "=ds="..AL["Vendor"]..": "..BabbleZone["Stormwind City"]};
				{ 20, "s28267", "22645", "=q1=Crunchy Spider Surprise", "=ds=#sr# 60", "=ds="..AL["Vendor"]};
				{ 21, "s33278", "27636", "=q1=Bat Bites", "=ds=#sr# 50", "=ds="..AL["Vendor"]};
				{ 22, "s6499", "5525", "=q1=Boiled Clams", "=ds=#sr# 50", "=ds="..AL["Trainer"]};
				{ 23, "s2541", "2684", "=q1=Coyote Steak", "=ds=#sr# 50", "=ds="..AL["Trainer"]};
				{ 24, "s6415", "5476", "=q1=Fillet of Frenzy", "=ds=#sr# 50", "=ds="..AL["Vendor"]};
				{ 25, "s2542", "724", "=q1=Goretusk Liver Pie", "=ds=#sr# 50", "=ds="..AL["Vendor"]..": "..BabbleZone["Stormwind City"]};
				{ 26, "s6416", "5477", "=q1=Strider Stew", "=ds=#sr# 50", "=ds="..AL["Vendor"]..": "..BabbleZone["Northern Barrens"]};
				{ 27, "s21144", "17198", "=q1=Egg Nog", "=ds=#sr# 35", "=ds="..AL["Vendor"]};
				{ 28, "s6414", "5474", "=q1=Roasted Kodo Meat", "=ds=#sr# 35", "=ds="..AL["Vendor"]..": "..BabbleZone["Mulgore"]};
				{ 29, "s2795", "2888", "=q1=Beer Basted Boar Ribs", "=ds=#sr# 10", "=ds="..AL["Vendor"]..": "..BabbleZone["Stormwind City"]};
				{ 30, "s6412", "5472", "=q1=Kaldorei Spider Kabob", "=ds=#sr# 10", "=ds="..BabbleInventory["Quest"]};
			};
			{
				{ 1, "s2539", "2680", "=q1=Spiced Wolf Meat", "=ds=#sr# 10", "=ds="..AL["Trainer"]};
				{ 2, "s15935", "12224", "=q1=Crispy Bat Wing", "=ds=#sr# 1", "=ds="..AL["Vendor"]};
				{ 3, "s21143", "17197", "=q1=Gingerbread Cookie", "=ds=#sr# 1", "=ds="..AL["Vendor"]};
				{ 4, "s8604", "6888", "=q1=Herb Baked Egg", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
				{ 5, "s33276", "27635", "=q1=Lynx Steak", "=ds=#sr# 1", "=ds="..AL["Vendor"]};
				{ 6, "s33277", "24105", "=q1=Roasted Moongraze Tenderloin", "=ds=#sr# 1", "=ds="..BabbleInventory["Quest"]};
				{
					{ 8, "s66036", "44836", "=q1=Pumpkin Pie", "=ds=#sr# 100", "=ds="..AL["Vendor"]};
					{ 8, "s62044", "44836", "=q1=Pumpkin Pie", "=ds=#sr# 100", "=ds="..AL["Vendor"]};
				};
				{ 9, "s65454", "46691", "=q1=Bread of the Dead", "=ds=#sr# 1", "=ds="..AL["Vendor"]};
			};
		};
		info = {
			name = COOKING,
			module = moduleName, menu = "COOKINGMENU"
		};
	};

	AtlasLoot_Data["CookingAPSP"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Spell Power"], ""};
				{ 2, "s57423", "43015", "=q1=Fish Feast", "=ds=#sr# 450", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 3, "s45568", "34767", "=q1=Firecracker Salmon", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 4, "s45556", "34755", "=q1=Tender Shoveltusk Steak", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 5, "s58065", "43268", "=q1=Dalaran Clam Chowder", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 6, "s45554", "34753", "=q1=Great Feast", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
				{ 7, "s45550", "34749", "=q1=Shoveltusk Steak", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 8, "s45564", "34763", "=q1=Smoked Salmon", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 9, "s33286", "27657", "=q1=Blackened Basilisk", "=ds=#sr# 315", "=ds="..AL["Vendor"]..": "..BabbleZone["Terokkar Forest"]};
				{ 10, "s38868", "31673", "=q1=Crunchy Serpent", "=ds=#sr# 335", "=ds="..AL["Vendor"]..": "..BabbleZone["Blade's Edge Mountains"]};
				{ 11, "s33295", "27666", "=q1=Golden Fish Sticks", "=ds=#sr# 325", "=ds="..AL["Vendor"]..": "..BabbleZone["Terokkar Forest"]};
				{ 12, "s33294", "27665", "=q1=Poached Bluefish", "=ds=#sr# 320", "=ds="..AL["Vendor"]..": "..BabbleZone["Nagrand"]};
				{ 13, "s46688", "35565", "=q1=Juicy Bear Burger", "=ds=#sr# 250", "=ds="..AL["Vendor"]..": "..BabbleZone["Felwood"]};
				{ 14, "s64054", "33004", "=q1=Clamlette Magnifique", "=ds=#sr# 250", "=ds="..BabbleInventory["Quest"]..""};
				{
					{ 15, "s66035", "44840", "=q1=Cranberry Chutney", "=ds=#sr# 160", "=ds="..AL["Vendor"]};
					{ 15, "s62049", "44840", "=q1=Cranberry Chutney", "=ds=#sr# 160", "=ds="..AL["Vendor"]};
				};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Attack Power"], ""};
				{ 17, "s57423", "43015", "=q1=Fish Feast", "=ds=#sr# 450", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 18, "s45555", "34754", "=q1=Mega Mammoth Meal", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 19, "s45567", "34766", "=q1=Poached Northern Sculpin", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 20, "s58065", "43268", "=q1=Dalaran Clam Chowder", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 21, "s45554", "34753", "=q1=Great Feast", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
				{ 22, "s45563", "34762", "=q1=Grilled Sculpin", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 23, "s45549", "34748", "=q1=Mammoth Meal", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 24, "s33284", "27655", "=q1=Ravager Dog", "=ds=#sr# 300", "=ds="..AL["Vendor"]..": "..BabbleZone["Hellfire Peninsula"]};
				{ 25, "s46684", "35563", "=q1=Charred Bear Kabobs", "=ds=#sr# 250", "=ds="..AL["Vendor"]..": "..BabbleZone["Felwood"]};
				{ 26, "s64054", "33004", "=q1=Clamlette Magnifique", "=ds=#sr# 250", "=ds="..BabbleInventory["Quest"]..""};
				{
					{ 27, "s66037", "44838", "=q1=Slow-Roasted Turkey", "=ds=#sr# 280", "=ds="..AL["Vendor"]};
					{ 27, "s62045", "44838", "=q1=Slow-Roasted Turkey", "=ds=#sr# 280", "=ds="..AL["Vendor"]};
				};	
			};
		};
		info = {
			name = COOKING,
			module = moduleName, menu = "COOKINGMENU"
		};
	};

	AtlasLoot_Data["CookingAgiStrInt"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Agility"]};
				{ 2, "s88042", "62669", "=q1=Skewered Eel", "=ds=#sr# 500", "=ds="..AL["Cooking Daily"]};
				{ 3, "s88046", "62658", "=q1=Tender Baked Turtle", "=ds=#sr# 475", "=ds="..AL["Cooking Daily"]};
				{ 4, "s57441", "42999", "=q1=Blackened Dragonfin", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 5, "s33288", "27659", "=q1=Warp Burger", "=ds=#sr# 325", "=ds="..AL["Vendor"]..": "..BabbleZone["Terokkar Forest"]};
				{ 6, "s33293", "27664", "=q1=Grilled Mudfish", "=ds=#sr# 320", "=ds="..AL["Vendor"]..": "..BabbleZone["Nagrand"]};
				{ 7, "s18240", "13928", "=q1=Grilled Squid", "=ds=#sr# 240", "=ds="..AL["Trainer"]};
				{ 9, 0, "INV_Box_01", "=q6="..AL["Intellect"]};
				{ 10, "s88039", "62671", "=q1=Severed Sagefish Head", "=ds=#sr# 500", "=ds="..AL["Cooking Daily"]};
				{ 11, "s88033", "62660", "=q1=Pickled Guppy", "=ds=#sr# 475", "=ds="..AL["Cooking Daily"]};
				{ 12, "s22761", "18254", "=q1=Runn Tum Tuber Surprise", "=ds=#sr# 275", "=ds="..AL["Drop"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Strength"]};
				{ 17, "s88005", "62670", "=q1=Bear-Basted Crocolisk", "=ds=#sr# 500", "=ds="..AL["Cooking Daily"]};
				{ 18, "s88021", "62659", "=q1=Hearty Seafood Soup", "=ds=#sr# 475", "=ds="..AL["Cooking Daily"]};
				{ 19, "s57442", "43000", "=q1=Dragonfin Filet", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 20, "s33287", "27658", "=q1=Roasted Clefthoof", "=ds=#sr# 325", "=ds="..AL["Vendor"]..": "..BabbleZone["Nagrand"]};
				{ 21, "s24801", "20452", "=q1=Smoked Desert Dumplings", "=ds=#sr# 285", "=ds="..BabbleInventory["Quest"]};
			};
		};
		info = {
			name = COOKING,
			module = moduleName, menu = "COOKINGMENU"
		};
	};

	AtlasLoot_Data["CookingOtherBuffs"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..BabbleInventory["Pet"]};
				{ 2, "s57440", "43005", "=q1=Spiced Mammoth Treats", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 3, "s43772", "33874", "=q1=Kibler's Bits", "=ds=#sr# 300", "=ds="..AL["Drop"]};
				{ 5, 0, "INV_Box_01", "=q6="..AL["Resistance"]};
				{ 6, "s43761", "33867", "=q1=Broiled Bloodfin", "=ds=#sr# 300", "=ds="..AL["Drop"]};
				{ 8, 0, "INV_Box_01", "=q6="..AL["Health / Second"]};
				{ 9, "s18244", "13932", "=q1=Poached Sunscale Salmon", "=ds=#sr# 250", "=ds="..AL["Trainer"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Mana / Second"]};
				{ 17, "s33292", "27663", "=q1=Blackened Sporefish", "=ds=#sr# 310", "=ds="..AL["Vendor"]..": "..BabbleZone["Zangarmarsh"]};
				{ 18, "s18243", "13931", "=q1=Nightfin Soup", "=ds=#sr# 250", "=ds="..AL["Trainer"]};
				{ 19, "s25954", "21217", "=q1=Sagefish Delight", "=ds=#sr# 175", "=ds="..AL["Vendor"]};
				{ 20, "s25704", "21072", "=q1=Smoked Sagefish", "=ds=#sr# 80", "=ds="..AL["Vendor"]};
			};
		};
		info = {
			name = COOKING,
			module = moduleName, menu = "COOKINGMENU"
		};
	};

	AtlasLoot_Data["CookingHitCrit"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Crit Rating"], ""};
				{ 2, "s88003", "62661", "=q1=Baked Rockfish", "=ds=#sr# 500", "=ds="..AL["Cooking Daily"]};
				{ 3, "s88028", "62561", "=q1=Lightly Fried Lurker", "=ds=#sr# 450", "=ds="..AL["Cooking Daily"]};
				{ 4, "s57436", "42995", "=q1=Hearty Rhino", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 5, "s45557", "34756", "=q1=Spiced Worm Burger", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 6, "s45571", "34768", "=q1=Spicy Blue Nettlefish", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 7, "s45565", "34764", "=q1=Poached Nettlefish", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 8, "s45551", "34750", "=q1=Worm Delight", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 9, "s43707", "33825", "=q1=Skullfish Soup", "=ds=#sr# 325", "=ds="..AL["Drop"]..""};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Hit Rating"], ""};
				{ 17, "s88020", "62662", "=q1=Grilled Dragon", "=ds=#sr# 500", "=ds="..AL["Cooking Daily"]};
				{ 18, "s88037", "62652", "=q1=Seasoned Crab", "=ds=#sr# 450", "=ds="..AL["Cooking Daily"]};
				{ 19, "s57437", "42996", "=q1=Snapper Extreme", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 20, "s62350", "44953", "=q1=Worg Tartare", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 21, "s43765", "33872", "=q1=Spicy Hot Talbuk", "=ds=#sr# 325", "=ds="..AL["Drop"]};
				{ 22, "s66038", "44837", "=q1=Spice Bread Stuffing", "=ds=#sr# 1", "=ds="..AL["Vendor"]};
			};
		};
		info = {
			name = COOKING,
			module = moduleName, menu = "COOKINGMENU"
		};
	};

	AtlasLoot_Data["CookingRating"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Haste Rating"], ""};
				{ 2, "s88004", "62665", "=q1=Basilisk Liverdog", "=ds=#sr# 500", "=ds="..AL["Cooking Daily"]};
				{ 3, "s88012", "62655", "=q1=Broiled Mountain Trout", "=ds=#sr# 450", "=ds="..AL["Cooking Daily"]};
				{ 4, "s45570", "34769", "=q1=Imperial Manta Steak", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 5, "s45558", "34757", "=q1=Very Burnt Worg", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 6, "s45569", "42942", "=q1=Baked Manta Ray", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 7, "s45552", "34751", "=q1=Roasted Worg", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{
					{ 8, "s66034", "44839", "=q1=Candied Sweet Potato", "=ds=#sr# 220", "=ds="..AL["Vendor"]};
					{ 8, "s62051", "44839", "=q1=Candied Sweet Potato", "=ds=#sr# 220", "=ds="..AL["Vendor"]};
				};
				{ 10, 0, "INV_Box_01", "=q6="..AL["Expertise Rating"], ""};
				{ 11, "s88014", "62664", "=q1=Crocolisk Au Gratin", "=ds=#sr# 500", "=ds="..AL["Cooking Daily"]};
				{ 12, "s88024", "62654", "=q1=Lavascale Fillet", "=ds=#sr# 450", "=ds="..AL["Cooking Daily"]};
				{ 13, "s57434", "42994", "=q1=Rhinolicious Wormsteak", "=ds=#sr# 400", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Mastery Rating"], ""};
				{ 17, "s88025", "62663", "=q1=Lavascale Minestrone", "=ds=#sr# 500", "=ds="..AL["Cooking Daily"]};
				{ 18, "s88035", "62653", "=q1=Salted Eye", "=ds=#sr# 450", "=ds="..AL["Cooking Daily"]};
				{ 20, 0, "INV_Box_01", "=q6="..AL["Dodge Rating"], ""};
				{ 21, "s88031", "62667", "=q1=Mushroom Sauce Mudfish", "=ds=#sr# 500", "=ds="..AL["Cooking Daily"]};
				{ 22, "s88030", "62657", "=q1=Lurker Lunch", "=ds=#sr# 450", "=ds="..AL["Cooking Daily"]};
				{ 24, 0, "INV_Box_01", "=q6="..AL["Parry Rating"], ""};
				{ 25, "s88034", "62668", "=q1=Blackbelly Sushi", "=ds=#sr# 500", "=ds="..AL["Cooking Daily"]};
			};
		};
		info = {
			name = COOKING,
			module = moduleName, menu = "COOKINGMENU"
		};
	};

		------------------
		--- Enchanting ---
		------------------

	AtlasLoot_Data["EnchantingBoots"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Agility"], ""};
				{ 2, "s74213", "Spell_Holy_GreaterHeal", "=ds=Enchant Boots - Major Agility", "=ds=#sr# 475", "=ds="..AL["Trainer"]};
				{ 3, "s74252", "inv_enchant_formulagood_01", "=ds=Enchant Boots - Assassin's Step", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 4, "s44589", "inv_enchant_formulagood_01", "=ds=Enchant Boots - Superior Agility", "=ds=#sr# 410", "=ds="..AL["Trainer"]};
				{ 5, "s27951", "inv_enchant_formulagood_01", "=ds=Enchant Boots - Dexterity", "=ds=#sr# 340", "=ds="..BabbleZone["Auchenai Crypts"]};
				{ 6, "s20023", "inv_enchant_formulagood_01", "=ds=Enchant Boots - Greater Agility", "=ds=#sr# 295", "=ds="..AL["Trainer"]};
				{ 7, "s34007", "inv_enchant_formulasuperior_01", "=ds=Enchant Boots - Cat's Swiftness", "=ds=#sr# 360", "=ds="..AL["World Drop"]};
				{ 8, "s13935", "Spell_Holy_GreaterHeal", "=ds=Enchant Boots - Agility", "=ds=#sr# 235", "=ds="..AL["Trainer"]};
				{ 9, "s13637", "Spell_Holy_GreaterHeal", "=ds=Enchant Boots - Lesser Agility", "=ds=#sr# 160", "=ds="..AL["Trainer"]};
				{ 10, "s7867", "inv_misc_note_01", "=ds=Enchant Boots - Minor Agility", "=ds=#sr# 125", "=ds="..AL["Vendor"]};
				{ 12, 0, "INV_Box_01", "=q6="..AL["Spirit"], ""};
				{ 13, "s44508", "Spell_Holy_GreaterHeal", "=ds=Enchant Boots - Greater Spirit", "=ds=#sr# 410", "=ds="..AL["Trainer"]};
				{ 14, "s20024", "inv_enchant_formulagood_01", "=ds=Enchant Boots - Spirit", "=ds=#sr# 275", "=ds="..AL["World Drop"]};
				{ 15, "s13687", "inv_enchant_formulagood_01", "=ds=Enchant Boots - Lesser Spirit", "=ds=#sr# 190", "=ds="..AL["World Drop"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Stamina"], ""};
				{ 17, "s74189", "spell_holy_greaterheal", "=ds=Enchant Boots - Earthen Vitality", "=ds=#sr# 425", "=ds="..AL["Trainer"]};
				{ 18, "s44528", "Spell_Holy_GreaterHeal", "=ds=Enchant Boots - Greater Fortitude", "=ds=#sr# 385", "=ds="..AL["Trainer"]};
				{ 19, "s47901", "inv_enchant_formulagood_01", "=ds=Enchant Boots - Tuskarr's Vitality", "=ds=#sr# 440", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 20, "s27950", "inv_enchant_formulagood_01", "=ds=Enchant Boots - Fortitude", "=ds=#sr# 320", "=ds="..BabbleZone["Mana-Tombs"]};
				{ 21, "s34008", "inv_enchant_formulasuperior_01", "=ds=Enchant Boots - Boar's Speed", "=ds=#sr# 360", "=ds="..AL["World Drop"]};
				{ 22, "s20020", "inv_enchant_formulagood_01", "=ds=Enchant Boots - Greater Stamina", "=ds=#sr# 260", "=ds="..AL["World Drop"]};
				{ 23, "s13836", "Spell_Holy_GreaterHeal", "=ds=Enchant Boots - Stamina", "=ds=#sr# 215", "=ds="..AL["Trainer"]};
				{ 24, "s13644", "Spell_Holy_GreaterHeal", "=ds=Enchant Boots - Lesser Stamina", "=ds=#sr# 170", "=ds="..AL["Trainer"]};
				{ 25, "s7863", "Spell_Holy_GreaterHeal", "=ds=Enchant Boots - Minor Stamina", "=ds=#sr# 125", "=ds="..AL["Trainer"]};
				{ 27, 0, "INV_Box_01", "=q6="..AL["Attack Power"], ""};
				{ 28, "s60763", "inv_enchant_formulagood_01", "=ds=Enchant Boots - Greater Assault", "=ds=#sr# 440", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 29, "s60606", "Spell_Holy_GreaterHeal", "=ds=Enchant Boots - Assault", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Ratings"], ""};
				{ 2, "s74253", "inv_enchant_formulagood_01", "=ds=Enchant Boots - Lavawalker", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 3, "s74238", "spell_holy_greaterheal", "=ds=Enchant Boots - Mastery", "=ds=#sr# 510", "=ds="..AL["Trainer"]};
				{ 4, "s74236", "spell_holy_greaterheal", "=ds=Enchant Boots - Precision", "=ds=#sr# 505", "=ds="..AL["Trainer"]};
				{ 5, "s74199", "spell_holy_greaterheal", "=ds=Enchant Boots - Haste", "=ds=#sr# 455", "=ds="..AL["Trainer"]};
				{ 6, "s60623", "Spell_Holy_GreaterHeal", "=ds=Enchant Boots - Icewalker", "=ds=#sr# 385", "=ds="..AL["Trainer"]};
				{ 7, "s27954", "inv_enchant_formulagood_01", "=ds=Enchant Boots - Surefooted", "=ds=#sr# 370", "=ds="..BabbleZone["Karazhan"]};
				{ 8, "s63746", "Spell_Holy_GreaterHeal", "=ds=Enchant Boots - Lesser Accuracy", "=ds=#sr# 225", "=ds="..AL["Trainer"]};
				{ 10, 0, "INV_Box_01", "=q6="..AL["Other"], ""};
				{ 11, "s44584", "Spell_Holy_GreaterHeal", "=ds=Enchant Boots - Greater Vitality", "=ds=#sr# 405", "=ds="..AL["Trainer"]};
				{ 12, "s27948", "inv_enchant_formulagood_01", "=ds=Enchant Boots - Vitality", "=ds=#sr# 305", "=ds="..AL["World Drop"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Speed"], ""};
				{ 17, "s74252", "inv_enchant_formulagood_01", "=ds=Enchant Boots - Assassin's Step", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 18, "s74253", "inv_enchant_formulagood_01", "=ds=Enchant Boots - Lavawalker", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 19, "s34008", "inv_enchant_formulasuperior_01", "=ds=Enchant Boots - Boar's Speed", "=ds=#sr# 360", "=ds="..AL["World Drop"]};
				{ 20, "s34007", "inv_enchant_formulasuperior_01", "=ds=Enchant Boots - Cat's Swiftness", "=ds=#sr# 360", "=ds="..AL["World Drop"]};
				{ 21, "s74189", "spell_holy_greaterheal", "=ds=Enchant Boots - Earthen Vitality", "=ds=#sr# 425", "=ds="..AL["Trainer"]};
				{ 22, "s47901", "inv_enchant_formulagood_01", "=ds=Enchant Boots - Tuskarr's Vitality", "=ds=#sr# 440", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 23, "s13890", "Spell_Holy_GreaterHeal", "=ds=Enchant Boots - Minor Speed", "=ds=#sr# 225", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = ENCHANTING..": "..AL["Enchant Boots"],
			module = moduleName, menu = "ENCHANTINGMENU", instance = "Enchanting",
		};
	};

	AtlasLoot_Data["EnchantingBracer"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Strength"], ""};
				{ 2, "s96261", "inv_enchant_formulasuperior_01", "=ds=Enchant Bracers - Major Strength", "=ds=#sr# 515", "=ds="..AL["World Drop"]};
				{ 3, "s27899", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Brawn", "=ds=#sr# 305", "=ds="..AL["Trainer"]};
				{ 4, "s20010", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Superior Strength", "=ds=#sr# 295", "=ds="..BabbleZone["Deadwind Pass"]};
				{ 5, "s13939", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Greater Strength", "=ds=#sr# 240", "=ds="..AL["Trainer"]};
				{ 6, "s13661", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Strength", "=ds=#sr# 180", "=ds="..AL["Trainer"]};
				{ 7, "s13536", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Lesser Strength", "=ds=#sr# 140", "=ds="..AL["Vendor"]};
				{ 8, "s7782", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Minor Strength", "=ds=#sr# 80", "=ds="..AL["World Drop"]};
				{ 10, 0, "INV_Box_01", "=q6="..AL["Spell Power"], ""};
				{ 11, "s60767", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Superior Spellpower", "=ds=#sr# 440", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 12, "s44635", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Greater Spellpower", "=ds=#sr# 395", "=ds="..AL["Trainer"]};
				{ 13, "s27917", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Spellpower", "=ds=#sr# 360", "=ds="..AL["Drop"]};
				{
					{ 14, "s27911", "inv_misc_note_01", "=ds=Enchant Bracers - Superior Healing", "=ds=#sr# 325", "=ds="..BabbleFaction["Thrallmar"].." - "..BabbleFaction["Friendly"]};
					{ 14, "s27911", "inv_misc_note_01", "=ds=Enchant Bracers - Superior Healing", "=ds=#sr# 325", "=ds="..BabbleFaction["Honor Hold"].." - "..BabbleFaction["Friendly"]};
				};
				{ 15, "s23802", "inv_misc_note_01", "=ds=Enchant Bracers - Healing Power", "=ds=#sr# 300", "=ds="..BabbleFaction["Argent Dawn"].." - "..BabbleFaction["Revered"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Intellect"], ""};
				{ 17, "s96262", "inv_enchant_formulasuperior_01", "=ds=Enchant Bracers - Mighty Intellect", "=ds=#sr# 515", "=ds="..AL["World Drop"]};
				{ 18, "s44555", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Exceptional Intellect", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
				{ 19, "s34001", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Major Intellect", "=ds=#sr# 305", "=ds="..AL["Trainer"]};
				{ 20, "s20008", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Greater Intellect", "=ds=#sr# 255", "=ds="..AL["Trainer"]};
				{ 21, "s13822", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Intellect", "=ds=#sr# 210", "=ds="..AL["Trainer"]};
				{ 22, "s13622", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Lesser Intellect", "=ds=#sr# 150", "=ds="..AL["Trainer"]};
				{ 24, 0, "INV_Box_01", "=q6="..AL["Haste Rating"], ""};
				{ 25, "s74256", "inv_enchant_formulagood_01", "=ds=Enchant Bracer - Greater Speed", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 26, "s74193", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracer - Speed", "=ds=#sr# 435", "=ds="..AL["Trainer"]};
				{ 28, 0, "INV_Box_01", "=q6="..AL["Crit Rating"], ""};
				{ 29, "s74248", "inv_enchant_formulagood_01", "=ds=Enchant Bracer - Greater Critical Strike", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 30, "s74201", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracer - Critical Strike", "=ds=#sr# 460", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Stamina"], ""};
				{ 2, "s62256", "inv_enchant_formulasuperior_01", "=ds=Enchant Bracers - Major Stamina", "=ds=#sr# 450", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 3, "s27914", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Fortitude", "=ds=#sr# 350", "=ds="..BabbleZone["The Steamvault"]};
				{ 4, "s20011", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Superior Stamina", "=ds=#sr# 300", "=ds="..AL["World Drop"]};
				{ 5, "s13945", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Greater Stamina", "=ds=#sr# 245", "=ds="..AL["World Drop"]};
				{ 6, "s13648", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Stamina", "=ds=#sr# 170", "=ds="..AL["Trainer"]};
				{ 7, "s13501", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Lesser Stamina", "=ds=#sr# 130", "=ds="..AL["Trainer"]};
				{ 8, "s7457", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Minor Stamina", "=ds=#sr# 50", "=ds="..AL["Trainer"]};
				{ 9, "s7418", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Minor Health", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
				{ 11, 0, "INV_Box_01", "=q6="..AL["Agility"], ""};
				{ 12, "s96264", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Agility", "=ds=#sr# 515", "=ds="..AL["World Drop"]};
				{ 13, "s7779", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Minor Agility", "=ds=#sr# 80", "=ds="..AL["Trainer"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Spirit"], ""};
				{ 17, "s74237", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracer - Exceptional Spirit", "=ds=#sr# 505", "=ds="..AL["Trainer"]};
				{ 18, "s44593", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Major Spirit", "=ds=#sr# 400", "=ds="..AL["Trainer"]};
				{ 19, "s20009", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Superior Spirit", "=ds=#sr# 270", "=ds="..AL["World Drop"]};
				{ 20, "s13846", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Greater Spirit", "=ds=#sr# 220", "=ds="..AL["World Drop"]};
				{ 21, "s13642", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Spirit", "=ds=#sr# 165", "=ds="..AL["Trainer"]};
				{ 22, "s7859", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Lesser Spirit", "=ds=#sr# 120", "=ds="..AL["World Drop"]};
				{ 23, "s7766", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Minor Spirit", "=ds=#sr# 60", "=ds="..AL["World Drop"]};
				{ 25, 0, "INV_Box_01", "=q6="..AL["Attack Power"], ""};
				{ 26, "s44575", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Greater Assault", "=ds=#sr# 430", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 27, "s60616", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Striking", "=ds=#sr# 360", "=ds="..AL["Trainer"]};
				{ 28, "s34002", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Assault", "=ds=#sr# 300", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Dodge Rating"], ""};
				{ 2, "s74229", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracer - Dodge", "=ds=#sr# 490", "=ds="..AL["Trainer"]};
				{ 3, "s13931", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Deflection", "=ds=#sr# 235", "=ds="..AL["Vendor"]};
				{ 4, "s13646", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Lesser Deflection", "=ds=#sr# 170", "=ds="..AL["Vendor"]};
				{ 5, "s7428", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Minor Deflection", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
				{ 7, 0, "INV_Box_01", "=q6="..AL["Mana / Second"], ""};
				{ 8, "s27913", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Restore Mana Prime", "=ds=#sr# 335", "=ds="..AL["World Drop"]};
				{ 9, "s23801", "inv_misc_note_01", "=ds=Enchant Bracers - Mana Regeneration", "=ds=#sr# 290", "=ds="..BabbleFaction["Argent Dawn"].." - "..BabbleFaction["Honored"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Stats"], ""};
				{ 17, "s44616", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Greater Stats", "=ds=#sr# 400", "=ds="..AL["Trainer"]};
				{ 18, "s27905", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Stats", "=ds=#sr# 315", "=ds="..AL["Trainer"]};
				{ 20, 0, "INV_Box_01", "=q6="..AL["Other"], ""};
				{ 21, "s74239", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracers - Greater Expertise", "=ds=#sr# 510", "=ds="..AL["Trainer"]};
				{ 22, "s74232", "Spell_Holy_GreaterHeal", "=ds=Enchant Bracer - Precision", "=ds=#sr# 495", "=ds="..AL["Trainer"]};
				{ 23, "s44598", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Expertise", "=ds=#sr# 420", "=ds="..AL["Trainer"]};
				{ 24, "s27906", "inv_enchant_formulagood_01", "=ds=Enchant Bracers - Major Defense", "=ds=#sr# 320", "=ds="..BabbleZone["Netherstorm"]};

			};
		};
		info = {
			name = ENCHANTING..": "..AL["Enchant Bracer"],
			module = moduleName, menu = "ENCHANTINGMENU", instance = "Enchanting",
		};
	};

	AtlasLoot_Data["EnchantingChest"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Stats"], ""};
				{ 2, "s74250", "inv_enchant_formulagood_01", "=ds=Enchant Chest - Peerless Stats", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 3, "s74191", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Mighty Stats", "=ds=#sr# 425", "=ds="..AL["Trainer"]};
				{ 4, "s60692", "inv_enchant_formulagood_01", "=ds=Enchant Chest - Powerful Stats", "=ds=#sr# 440", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 5, "s44623", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Super Stats", "=ds=#sr# 370", "=ds="..AL["Trainer"]};
				{ 6, "s27960", "inv_misc_note_01", "=ds=Enchant Chest - Exceptional Stats", "=ds=#sr# 345", "=ds="..AL["Vendor"]};
				{ 7, "s20025", "inv_enchant_formulagood_01", "=ds=Enchant Chest - Greater Stats", "=ds=#sr# 300", "=ds="..AL["World Drop"]};
				{ 8, "s13941", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Stats", "=ds=#sr# 245", "=ds="..AL["Trainer"]};
				{ 9, "s13700", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Lesser Stats", "=ds=#sr# 200", "=ds="..AL["Trainer"]};
				{ 10, "s13626", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Minor Stats", "=ds=#sr# 150", "=ds="..AL["Trainer"]};
				{ 12, 0, "INV_Box_01", "=q6="..AL["Resilience"], ""};
				{ 13, "s74214", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Mighty Resilience", "=ds=#sr# 475", "=ds="..AL["Trainer"]};
				{ 14, "s44588", "inv_enchant_formulagood_01", "=ds=Enchant Chest - Exceptional Resilience", "=ds=#sr# 410", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 15, "s33992", "inv_enchant_formulagood_01", "=ds=Enchant Chest - Major Resilience", "=ds=#sr# 345", "=ds="..AL["World Drop"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Health"], ""};
				{ 17, "s74251", "inv_enchant_formulagood_01", "=ds=Enchant Chest - Greater Stamina", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 18, "s74200", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Stamina", "=ds=#sr# 460", "=ds="..AL["Trainer"]};
				{ 19, "s47900", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Super Health", "=ds=#sr# 425", "=ds="..AL["Trainer"]};
				{ 20, "s44492", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Mighty Health", "=ds=#sr# 395", "=ds="..AL["Trainer"]};
				{ 21, "s27957", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Exceptional Health", "=ds=#sr# 315", "=ds="..AL["Trainer"]};
				{ 22, "s20026", "inv_misc_note_01", "=ds=Enchant Chest - Major Health", "=ds=#sr# 275", "=ds="..AL["Vendor"]};
				{ 23, "s13858", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Superior Health", "=ds=#sr# 220", "=ds="..AL["Trainer"]};
				{ 24, "s13640", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Greater Health", "=ds=#sr# 160", "=ds="..AL["Trainer"]};
				{ 25, "s7857", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Health", "=ds=#sr# 120", "=ds="..AL["Trainer"]};
				{ 26, "s7748", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Lesser Health", "=ds=#sr# 60", "=ds="..AL["Trainer"]};
				{ 27, "s7420", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Minor Health", "=ds=#sr# 15", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Mana"], ""};
				{ 2, "s27958", "inv_misc_note_01", "=ds=Enchant Chest - Exceptional Mana", "=ds=#sr# 325", "=ds="..AL["Trainer"]};
				{ 3, "s20028", "inv_enchant_formulagood_01", "=ds=Enchant Chest - Major Mana", "=ds=#sr# 290", "=ds="..AL["Trainer"]};
				{ 4, "s13917", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Superior Mana", "=ds=#sr# 230", "=ds="..AL["Trainer"]};
				{ 5, "s13663", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Greater Mana", "=ds=#sr# 185", "=ds="..AL["Trainer"]};
				{ 6, "s13607", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Mana", "=ds=#sr# 145", "=ds="..AL["Trainer"]};
				{ 7, "s7776", "inv_enchant_formulagood_01", "=ds=Enchant Chest - Lesser Mana", "=ds=#sr# 80", "=ds="..AL["Vendor"]};
				{ 8, "s7443", "inv_enchant_formulagood_01", "=ds=Enchant Chest - Minor Mana", "=ds=#sr# 20", "=ds="..AL["World Drop"]};
				{ 10, 0, "INV_Box_01", "=q6="..AL["Mana / Second"], ""};
				{ 11, "s44509", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Greater Mana Restoration", "=ds=#sr# 420", "=ds="..AL["Trainer"]};
				{ 12, "s33991", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Restore Mana Prime", "=ds=#sr# 300", "=ds="..AL["Trainer"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Spirit"], ""};
				{ 17, "s74231", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Exceptional Spirit", "=ds=#sr# 495", "=ds="..AL["Trainer"]};
				{ 18, "s33990", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Major Spirit", "=ds=#sr# 320", "=ds="..AL["Trainer"]};
				{ 20, 0, "INV_Box_01", "=q6="..AL["Dodge Rating"], ""};
				{ 21, "s47766", "inv_enchant_formulagood_01", "=ds=Enchant Chest - Greater Defense", "=ds=#sr# 400", "=ds="..AL["Trainer"]};
				{ 22, "s46594", "inv_misc_note_01", "=ds=Enchant Chest - Defense", "=ds=#sr# 360", "=ds="..AL["Vendor"]};
				{ 24, 0, "INV_Box_01", "=q6="..AL["Damage Absorption"], ""};
				{ 25, "s13538", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Lesser Absorption", "=ds=#sr# 140", "=ds="..AL["Trainer"]};
				{ 26, "s7426", "Spell_Holy_GreaterHeal", "=ds=Enchant Chest - Minor Absorption", "=ds=#sr# 40", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = ENCHANTING..": "..AL["Enchant Chest"],
			module = moduleName, menu = "ENCHANTINGMENU", instance = "Enchanting",
		};
	};

	AtlasLoot_Data["EnchantingCloak"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Agility"], ""};
				{ 2, "s60663", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Major Agility", "=ds=#sr# 420", "=ds="..AL["Trainer"]};
				{ 3, "s44500", "inv_enchant_formulagood_01", "=ds=Enchant Cloak - Superior Agility", "=ds=#sr# 400", "=ds="..AL["Trainer"]};
				{ 4, "s34004", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Greater Agility", "=ds=#sr# 310", "=ds="..AL["Trainer"]};
				{ 5, "s13882", "inv_enchant_formulagood_01", "=ds=Enchant Cloak - Lesser Agility", "=ds=#sr# 225", "=ds="..BabbleZone["Tanaris"]};
				{ 6, "s13419", "inv_enchant_formulagood_01", "=ds=Enchant Cloak - Minor Agility", "=ds=#sr# 110", "=ds="..AL["Vendor"]};
				{ 8, 0, "INV_Box_01", "=q6="..AL["Intellect"], ""};
				{ 9, "s74240", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Greater Intellect", "=ds=#sr# 510", "=ds="..AL["Trainer"]};
				{ 10, "s74202", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Intellect", "=ds=#sr# 465", "=ds="..AL["Trainer"]};
				{ 12, 0, "INV_Box_01", "=q6="..AL["Crit Rating"], ""};
				{ 13, "s74247", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Greater Critical Strike", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 14, "s74230", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Critical Strike", "=ds=#sr# 490", "=ds="..AL["Trainer"]};
				{ 16, 0, "INV_Box_01", "=q6="..BabbleInventory["Armor"], ""};
				{ 17, "s74234", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Protection", "=ds=#sr# 500", "=ds="..AL["Trainer"]};
				{ 18, "s47672", "inv_enchant_formulagood_01", "=ds=Enchant Cloak - Mighty Armor", "=ds=#sr# 430", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 19, "s27961", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Major Armor", "=ds=#sr# 310", "=ds="..AL["Trainer"]};
				{ 20, "s20015", "inv_misc_note_01", "=ds=Enchant Cloak - Superior Defense", "=ds=#sr# 285", "=ds="..AL["Vendor"]};
				{ 21, "s13746", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Greater Defense", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 22, "s13635", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Defense", "=ds=#sr# 155", "=ds="..AL["Trainer"]};
				{ 23, "s13421", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Lesser Protection", "=ds=#sr# 115", "=ds="..AL["Trainer"]};
				{ 24, "s7771", "inv_enchant_formulagood_01", "=ds=Enchant Cloak - Minor Protection", "=ds=#sr# 70", "=ds="..AL["Trainer"]};
				{ 26, 0, "INV_Box_01", "=q6="..AL["Dodge Rating"], ""};
				{ 27, "s44591", "inv_enchant_formulagood_01", "=ds=Enchant Cloak - Titanweave", "=ds=#sr# 435", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 28, "s47051", "inv_enchant_formulasuperior_01", "=ds=Enchant Cloak - Steelweave", "=ds=#sr# 375", "=ds="..BabbleZone["Magisters' Terrace"]};
				{ 29, "s25086", "inv_enchant_formulasuperior_01", "=ds=Enchant Cloak - Dodge", "=ds=#sr# 300", "=ds="..AL["Vendor"]};
				{ 30, "s25083", "inv_enchant_formulasuperior_01", "=ds=Enchant Cloak - Stealth", "=ds=#sr# 300", "=ds="..AL["Vendor"]};
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Resistance"], ""};
				{ 2, "s27962", "inv_enchant_formulagood_01", "=ds=Enchant Cloak - Major Resistance", "=ds=#sr# 330", "=ds="..AL["World Drop"]};
				{ 3, "s20014", "inv_enchant_formulagood_01", "=ds=Enchant Cloak - Greater Resistance", "=ds=#sr# 265", "=ds="..AL["Trainer"]};
				{ 4, "s13794", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Resistance", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 5, "s7454", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Minor Resistance", "=ds=#sr# 45", "=ds="..AL["Trainer"]};
				{ 7, 0, "INV_Box_01", "=q6="..AL["Other"], ""};
				{ 8, "s44631", "inv_enchant_formulagood_01", "=ds=Enchant Cloak - Shadow Armor", "=ds=#sr# 440", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 9, "s47899", "inv_enchant_formulagood_01", "=ds=Enchant Cloak - Wisdom", "=ds=#sr# 440", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 10, "s74192", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Greater Spell Piercing", "=ds=#sr# 435", "=ds="..AL["Trainer"]};
				{ 11, "s47898", "inv_enchant_formulagood_01", "=ds=Enchant Cloak - Greater Speed", "=ds=#sr# 430", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 12, "s44582", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Spell Piercing", "=ds=#sr# 395", "=ds="..AL["Trainer"]};
				{ 13, "s60609", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Speed", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 14, "s34003", "inv_enchant_formulagood_01", "=ds=Enchant Cloak - Spell Penetration", "=ds=#sr# 325", "=ds="..AL["Vendor"]};
				{
					{ 15, "s25084", "inv_enchant_formulasuperior_01", "=ds=Enchant Cloak - Subtlety", "=ds=#sr# 300", "=ds="..BabbleFaction["Thrallmar"].." - "..BabbleFaction["Exalted"]};
					{ 15, "s25084", "inv_enchant_formulasuperior_01", "=ds=Enchant Cloak - Subtlety", "=ds=#sr# 300", "=ds="..BabbleFaction["Honor Hold"].." - "..BabbleFaction["Exalted"]};
				};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Specific Resistance"], ""};
				{ 17, "s44596", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Superior Arcane Resistance", "=ds=#sr# 400", "=ds="..BabbleZone["Icecrown"]};
				{ 18, "s44556", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Superior Fire Resistance", "=ds=#sr# 400", "=ds="..BabbleZone["Icecrown"]};
				{ 19, "s44483", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Superior Frost Resistance", "=ds=#sr# 400", "=ds="..BabbleZone["Icecrown"]};
				{ 20, "s44494", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Superior Nature Resistance", "=ds=#sr# 400", "=ds="..BabbleZone["Icecrown"]};
				{ 21, "s44590", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Superior Shadow Resistance", "=ds=#sr# 400", "=ds="..BabbleZone["Icecrown"]};
				{ 22, "s34005", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Greater Arcane Resistance", "=ds=#sr# 350", "=ds="..BabbleZone["Shadowmoon Valley"]};
				{ 23, "s34006", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Greater Shadow Resistance", "=ds=#sr# 350", "=ds="..BabbleZone["Netherstorm"]};
				{ 24, "s25082", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Greater Nature Resistance", "=ds=#sr# 300", "=ds="..AL["Vendor"]};
				{ 25, "s25081", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Greater Fire Resistance", "=ds=#sr# 300", "=ds="..AL["Vendor"]};
				{ 26, "s13657", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Fire Resistance", "=ds=#sr# 175", "=ds="..AL["Trainer"]};
				{ 27, "s13522", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Lesser Shadow Resistance", "=ds=#sr# 135", "=ds="..AL["World Drop"]};
				{ 28, "s7861", "Spell_Holy_GreaterHeal", "=ds=Enchant Cloak - Lesser Fire Resistance", "=ds=#sr# 125", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = ENCHANTING..": "..AL["Enchant Cloak"],
			module = moduleName, menu = "ENCHANTINGMENU", instance = "Enchanting",
		};
	};

	AtlasLoot_Data["EnchantingGloves"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Agility"], ""};
				{ 2, "s44529", "Spell_Holy_GreaterHeal", "=ds=Enchant Gloves - Major Agility", "=ds="..AL["Trainer"]};
				{ 3, "s25080", "inv_enchant_formulasuperior_01", "=ds=Enchant Gloves - Superior Agility", "=ds=#sr# 300", "=ds="..BabbleFaction["Keepers of Time"].." - "..BabbleFaction["Exalted"]};
				{ 4, "s20012", "inv_enchant_formulagood_01", "=ds=Enchant Gloves - Greater Agility", "=ds=#sr# 270", "=ds="..AL["Trainer"]};
				{ 5, "s13815", "Spell_Holy_GreaterHeal", "=ds=Enchant Gloves - Agility", "=ds=#sr# 210", "=ds="..AL["Trainer"]};
				{ 7, 0, "INV_Box_01", "=q6="..AL["Attack Power"], ""};
				{ 8, "s60668", "Spell_Holy_GreaterHeal", "=ds=Enchant Gloves - Crusher", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 9, "s44513", "inv_enchant_formulagood_01", "=ds=Enchant Gloves - Greater Assault", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 10, "s33996", "Spell_Holy_GreaterHeal", "=ds=Enchant Gloves - Assault", "=ds=#sr# 310", "=ds="..AL["Trainer"]};
				{ 12, 0, "INV_Box_01", "=q6="..AL["Hit Rating"], ""};
				{ 13, "s44488", "Spell_Holy_GreaterHeal", "=ds=Enchant Gloves - Precision", "=ds=#sr# 410", "=ds="..AL["Trainer"] };
				{ 14, "s33994", "inv_enchant_formulagood_01", "=ds=Enchant Gloves - Precise Strikes", "=ds=#sr# 360", "=ds="..BabbleFaction["Cenarion Expedition"].." - "..BabbleFaction["Revered"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Strength"], ""};
				{ 17, "s74254", "inv_enchant_formulagood_01", "=ds=Enchant Gloves - Mighty Strength", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 18, "s74212", "Spell_Holy_GreaterHeal", "=ds=Enchant Gloves - Exceptional Strength", "=ds=#sr# 470", "=ds="..AL["Trainer"]};
				{ 19, "s33995", "Spell_Holy_GreaterHeal", "=ds=Enchant Gloves - Major Strength", "=ds=#sr# 340", "=ds="..AL["Trainer"]};
				{ 20, "s20013", "inv_enchant_formulagood_01", "=ds=Enchant Gloves - Greater Strength", "=ds=#sr# 295", "=ds="..AL["Trainer"]};
				{ 21, "s13887", "inv_enchant_formulagood_01", "=ds=Enchant Gloves - Strength", "=ds=#sr# 225", "=ds="..AL["Trainer"]};
				{ 23, 0, "INV_Box_01", "=q6="..AL["Mastery Rating"], ""};
				{ 24, "s74255", "inv_enchant_formulagood_01", "=ds=Enchant Gloves - Greater Mastery", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 25, "s74132", "Spell_Holy_GreaterHeal", "=ds=Enchant Gloves - Mastery", "=ds=#sr# 425", "=ds="..AL["Trainer"]};
				{ 27, 0, "INV_Box_01", "=q6="..AL["Haste Rating"], ""};
				{ 28, "s74198", "Spell_Holy_GreaterHeal", "=ds=Enchant Gloves - Haste", "=ds=#sr# 455", "=ds="..AL["Trainer"]};
				{ 29, "s13948", "Spell_Holy_GreaterHeal", "=ds=Enchant Gloves - Minor Haste", "=ds=#sr# 250", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Spell Power"], ""};
				{ 2, "s44592", "Spell_Holy_GreaterHeal", "=ds=Enchant Gloves - Exceptional Spellpower", "=ds=#sr# 360", "=ds="..AL["Trainer"] };
				{ 3, "s33997", "inv_enchant_formulagood_01", "=ds=Enchant Gloves - Major Spellpower", "=ds=#sr# 360", "=ds="..AL["Vendor"]};
				{ 4, "s33999", "Spell_Holy_GreaterHeal", "=ds=Enchant Gloves - Major Healing", "=ds=#sr# 350", "=ds="..AL["Vendor"]};
				{ 5, "s25078", "inv_enchant_formulasuperior_01", "=ds=Enchant Gloves - Fire Power", "=ds=#sr# 300", "=ds="..BabbleZone["Ahn'Qiraj"]};
				{ 6, "s25074", "inv_enchant_formulasuperior_01", "=ds=Enchant Gloves - Frost Power", "=ds=#sr# 300", "=ds="..BabbleZone["Ahn'Qiraj"]};
				{ 7, "s25079", "inv_enchant_formulasuperior_01", "=ds=Enchant Gloves - Healing Power", "=ds=#sr# 300", "=ds="..BabbleZone["Ahn'Qiraj"]};
				{ 8, "s25073", "inv_enchant_formulasuperior_01", "=ds=Enchant Gloves - Shadow Power", "=ds=#sr# 300", "=ds="..BabbleZone["Ahn'Qiraj"]};
				{ 10, 0, "INV_Box_01", "=q6="..AL["Other"], ""};
				{ 11, "s44625", "Spell_Holy_GreaterHeal", "=ds=Enchant Gloves - Armsman", "=ds=#sr# 435", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 12, "s33993", "Spell_Holy_GreaterHeal", "=ds=Enchant Gloves - Blasting", "=ds=#sr# 305", "=ds="..AL["Trainer"]};
				{ 13, "s25072", "inv_enchant_formulasuperior_01", "=ds=Enchant Gloves - Threat", "=ds=#sr# 300", "=ds="..BabbleFaction["The Sha'tar"].." - "..BabbleFaction["Exalted"]};
				{ 14, "s13947", "inv_enchant_formulagood_01", "=ds=Enchant Gloves - Riding Skill", "=ds=#sr# 250", "=ds="..AL["World Drop"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Expertise Rating"], ""};
				{ 17, "s74220", "Spell_Holy_GreaterHeal", "=ds=Enchant Gloves - Greater Expertise", "=ds=#sr# 480", "=ds="..AL["Trainer"] };
				{ 18, "s44484", "Spell_Holy_GreaterHeal", "=ds=Enchant Gloves - Expertise", "=ds=#sr# 405", "=ds="..AL["Trainer"] };
				{ 20, 0, "INV_Box_01", "=q6="..AL["Professions"], ""};
				{ 21, "s44506", "Spell_Holy_GreaterHeal", "=ds=Enchant Gloves - Gatherer", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
				{ 22, "s71692", "inv_enchant_formulagood_01", "=ds=Enchant Gloves - Angler", "=ds=#sr# 375", "=ds="..AL["Drop"]};
				{ 23, "s13868", "inv_enchant_formulagood_01", "=ds=Enchant Gloves - Advanced Herbalism", "=ds=#sr# 225", "=ds="..AL["Drop"]};
				{ 24, "s13841", "inv_enchant_formulagood_01", "=ds=Enchant Gloves - Advanced Mining", "=ds=#sr# 215", "=ds="..AL["Drop"]};
				{ 25, "s13698", "inv_enchant_formulagood_01", "=ds=Enchant Gloves - Skinning", "=ds=#sr# 200", "=ds="..AL["Drop"]};
				{ 26, "s13620", "inv_enchant_formulagood_01", "=ds=Enchant Gloves - Fishing", "=ds=#sr# 145", "=ds="..AL["Drop"]};
				{ 27, "s13617", "inv_enchant_formulagood_01", "=ds=Enchant Gloves - Herbalism", "=ds=#sr# 145", "=ds="..AL["Drop"]};
				{ 28, "s13612", "inv_enchant_formulagood_01", "=ds=Enchant Gloves - Mining", "=ds=#sr# 145", "=ds="..AL["Drop"]};
			};
		};
		info = {
			name = ENCHANTING..": "..AL["Enchant Gloves"],
			module = moduleName, menu = "ENCHANTINGMENU", instance = "Enchanting",
		};
	};

	AtlasLoot_Data["EnchantingRing"] = {
		["Normal"] = {
			{
				{ 1, "s74216", "Spell_Holy_GreaterHeal", "=ds=Enchant Ring - Agility", "=ds=#sr# 475", "=ds="..AL["Trainer"]};
				{ 2, "s74218", "Spell_Holy_GreaterHeal", "=ds=Enchant Ring - Greater Stamina", "=ds=#sr# 475", "=ds="..AL["Trainer"]};
				{ 3, "s74217", "Spell_Holy_GreaterHeal", "=ds=Enchant Ring - Intellect", "=ds=#sr# 475", "=ds="..AL["Trainer"]};
				{ 4, "s74215", "Spell_Holy_GreaterHeal", "=ds=Enchant Ring - Strength", "=ds=#sr# 475", "=ds="..AL["Trainer"]};
				{ 5, "s44645", "Spell_Holy_GreaterHeal", "=ds=Enchant Ring - Assault", "=ds=#sr# 400", "=ds="..AL["Trainer"]};
				{ 6, "s44636", "Spell_Holy_GreaterHeal", "=ds=Enchant Ring - Greater Spellpower", "=ds=#sr# 400", "=ds="..AL["Trainer"]};
				{ 7, "s59636", "Spell_Holy_GreaterHeal", "=ds=Enchant Ring - Stamina", "=ds=#sr# 400", "=ds="..AL["Trainer"]};
				{ 16, "s27927", "inv_misc_note_01", "=ds=Enchant Ring - Stats", "=ds=#sr# 375", "=ds="..AL["Vendor"]};
				{ 17, "s27926", "inv_misc_note_01", "=ds=Enchant Ring - Healing Power", "=ds=#sr# 370", "=ds="..AL["Vendor"]};
				{ 18, "s27924", "inv_misc_note_01", "=ds=Enchant Ring - Spellpower", "=ds=#sr# 360", "=ds="..AL["Vendor"]};
				{ 19, "s27920", "inv_misc_note_01", "=ds=Enchant Ring - Striking", "=ds=#sr# 360", "=ds="..AL["Vendor"]};
			};
		};
		info = {
			name = ENCHANTING..": "..AL["Enchant Ring"],
			module = moduleName, menu = "ENCHANTINGMENU", instance = "Enchanting",
		};
	};

	AtlasLoot_Data["EnchantingShield"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Other"], ""};
				{ 2, "s74226", "Spell_Holy_GreaterHeal", "=ds=Enchant Shield - Blocking", "=ds=#sr# 485", "=ds="..AL["Trainer"]};
				{ 3, "s74207", "Spell_Holy_GreaterHeal", "=ds=Enchant Shield - Protection", "=ds=#sr# 465", "=ds="..AL["Trainer"]};
				{ 4, "s44489", "Spell_Holy_GreaterHeal", "=ds=Enchant Shield - Defense", "=ds=#sr# 420", "=ds="..AL["Trainer"]};
				{ 5, "s60653", "Spell_Holy_GreaterHeal", "=ds=Enchant Shield - Greater Intellect", "=ds=#sr# 395", "=ds="..AL["Trainer"]};
				{ 6, "s27947", "inv_enchant_formulagood_01", "=ds=Enchant Shield - Resistance", "=ds=#sr# 360", "=ds="..AL["World Drop"]};
				{ 7, "s27946", "inv_enchant_formulagood_01", "=ds=Enchant Shield - Shield Block", "=ds=#sr# 340", "=ds="..AL["World Drop"]};
				{ 8, "s44383", "Spell_Holy_GreaterHeal", "=ds=Enchant Shield - Resilience", "=ds=#sr# 330", "=ds="..AL["Trainer"]};
				{ 9, "s27945", "inv_misc_note_01", "=ds=Enchant Shield - Intellect", "=ds=#sr# 325", "=ds="..AL["Vendor"]};
				{ 10, "s27944", "Spell_Holy_GreaterHeal", "=ds=Enchant Shield - Tough Shield", "=ds=#sr# 310", "=ds="..AL["Trainer"]};
				{ 11, "s20016", "inv_enchant_formulagood_01", "=ds=Enchant Shield - Vitality", "=ds=#sr# 280", "=ds="..AL["Trainer"]};
				{ 12, "s13933", "inv_enchant_formulagood_01", "=ds=Enchant Shield - Frost Resistance", "=ds=#sr# 235", "=ds="..AL["World Drop"]};
				{ 13, "s13689", "inv_enchant_formulagood_01", "=ds=Enchant Shield - Lesser Parry", "=ds=#sr# 195", "=ds="..AL["World Drop"]};
				{ 14, "s13464", "inv_enchant_formulagood_01", "=ds=Enchant Shield - Lesser Protection", "=ds=#sr# 115", "=ds="..AL["World Drop"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Stamina"], ""};
				{ 17, "s34009", "inv_misc_note_01", "=ds=Enchant Shield - Major Stamina", "=ds=#sr# 325", "=ds="..AL["Vendor"]};
				{ 18, "s20017", "inv_misc_note_01", "=ds=Enchant Shield - Greater Stamina", "=ds=#sr# 265", "=ds="..AL["Vendor"]};
				{ 19, "s13817", "inv_enchant_formulagood_01", "=ds=Enchant Shield - Stamina", "=ds=#sr# 210", "=ds="..AL["World Drop"]};
				{ 20, "s13631", "Spell_Holy_GreaterHeal", "=ds=Enchant Shield - Lesser Stamina", "=ds=#sr# 155", "=ds="..AL["Trainer"]};
				{ 21, "s13378", "Spell_Holy_GreaterHeal", "=ds=Enchant Shield - Minor Stamina", "=ds=#sr# 105", "=ds="..AL["Trainer"]};
				{ 23, 0, "INV_Box_01", "=q6="..AL["Spirit"], ""};
				{ 24, "s13905", "Spell_Holy_GreaterHeal", "=ds=Enchant Shield - Greater Spirit", "=ds=#sr# 230", "=ds="..AL["Trainer"]};
				{ 25, "s13659", "Spell_Holy_GreaterHeal", "=ds=Enchant Shield - Spirit", "=ds=#sr# 180", "=ds="..AL["Trainer"]};
				{ 26, "s13485", "Spell_Holy_GreaterHeal", "=ds=Enchant Shield - Lesser Spirit", "=ds=#sr# 130", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = ENCHANTING..": "..AL["Enchant Shield"],
			module = moduleName, menu = "ENCHANTINGMENU", instance = "Enchanting",
		};
	};

	AtlasLoot_Data["Enchanting2HWeapon"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Agility"], ""};
				{ 2, "s95471", "Spell_Holy_GreaterHeal", "=ds=Enchant 2H Weapon - Mighty Agility", "=ds=#sr# 470", "=ds="..AL["Trainer"]};
				{ 3, "s27977", "inv_enchant_formulagood_01", "=ds=Enchant 2H Weapon - Major Agility", "=ds=#sr# 360", "=ds="..BabbleZone["The Arcatraz"]};
				{ 4, "s27837", "inv_misc_note_01", "=ds=Enchant 2H Weapon - Agility", "=ds=#sr# 290", "=ds="..AL["Vendor"]};
				{ 6, 0, "INV_Box_01", "=q6="..AL["Attack Power"], ""};
				{ 7, "s60691", "Spell_Holy_GreaterHeal", "=ds=Enchant 2H Weapon - Massacre", "=ds=#sr# 430", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 8, "s44630", "inv_enchant_formulagood_01", "=ds=Enchant 2H Weapon - Greater Savagery", "=ds=#sr# 410", "=ds="..AL["Trainer"]};
				{ 9, "s27971", "inv_enchant_formulagood_01", "=ds=Enchant 2H Weapon - Savagery", "=ds=#sr# 350", "=ds="..BabbleZone["The Shattered Halls"]};
				{ 11, 0, "INV_Box_01", "=q6="..AL["Intellect"], ""};
				{ 12, "s20036", "inv_enchant_formulagood_01", "=ds=Enchant 2H Weapon - Major Intellect", "=ds=#sr# 300", "=ds="..BabbleZone["Stratholme"]};
				{ 13, "s7793", "inv_misc_note_01", "=ds=Enchant 2H Weapon - Lesser Intellect", "=ds=#sr# 100", "=ds="..AL["Vendor"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Damage"], ""};
				{ 17, "s20030", "inv_enchant_formulagood_01", "=ds=Enchant 2H Weapon - Superior Impact", "=ds=#sr# 295", "=ds="..AL["Trainer"]};
				{ 18, "s13937", "Spell_Holy_GreaterHeal", "=ds=Enchant 2H Weapon - Greater Impact", "=ds=#sr# 240", "=ds="..AL["Trainer"]};
				{ 19, "s13695", "Spell_Holy_GreaterHeal", "=ds=Enchant 2H Weapon - Impact", "=ds=#sr# 200", "=ds="..AL["Trainer"]};
				{ 20, "s13529", "Spell_Holy_GreaterHeal", "=ds=Enchant 2H Weapon - Lesser Impact", "=ds=#sr# 145", "=ds="..AL["Trainer"]};
				{ 21, "s7745", "Spell_Holy_GreaterHeal", "=ds=Enchant 2H Weapon - Minor Impact", "=ds=#sr# 100", "=ds="..AL["Trainer"]};
				{ 23, 0, "INV_Box_01", "=q6="..AL["Spirit"], ""};
				{ 24, "s20035", "inv_enchant_formulagood_01", "=ds=Enchant 2H Weapon - Major Spirit", "=ds=#sr# 300", "=ds="..BabbleZone["Scholomance"]};
				{ 25, "s13380", "inv_enchant_formulagood_01", "=ds=Enchant 2H Weapon - Lesser Spirit", "=ds=#sr# 110", "=ds="..AL["World Drop"]};
				{ 27, 0, "INV_Box_01", "=q6="..AL["Other"], ""};
				{ 28, "s44595", "Spell_Holy_GreaterHeal", "=ds=Enchant 2H Weapon - Scourgebane", "=ds=#sr# 430", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
			};
		};
		info = {
			name = ENCHANTING..": "..AL["Enchant 2H Weapon"],
			module = moduleName, menu = "ENCHANTINGMENU", instance = "Enchanting",
		};
	};

	AtlasLoot_Data["EnchantingWeapon"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Proc"], ""};
				{ 2, "s74244", "inv_enchant_formulasuperior_01", "=ds=Enchant Weapon - Windwalk", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 3, "s74223", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Hurricane", "=ds=#sr# 480", "=ds="..AL["Trainer"]};
				{ 4, "s74197", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Avalanche", "=ds=#sr# 450", "=ds="..AL["Trainer"]};
				{ 5, "s74195", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Mending", "=ds=#sr# 450", "=ds="..AL["Trainer"]};
				{ 6, "s64441", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Blade Ward", "=ds=#sr# 450"};
				{ 7, "s64579", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Blood Draining", "=ds=#sr# 450"};
				{ 8, "s59625", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Black Magic", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 9, "s44576", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Lifeward", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 10, "s44524", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Icebreaker", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 11, "s42974", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Executioner", "=ds=#sr# 375"};
				{ 12, "s28004", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Battlemaster", "=ds=#sr# 360"};
				{ 13, "s28003", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Spellsurge", "=ds=#sr# 360"};
				{ 14, "s46578", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Deathfrost", "=ds=#sr# 350"};
				{ 15, "s20034", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Crusader", "=ds=#sr# 300"};
				{ 16, "s20032", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Lifestealing", "=ds=#sr# 300"};
				{ 17, "s20033", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Unholy Weapon", "=ds=#sr# 295"};
				{ 18, "s20029", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Icy Chill", "=ds=#sr# 285"};
				{ 19, "s13898", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Fiery Weapon", "=ds=#sr# 265"};
				{ 21, 0, "INV_Box_01", "=q6="..AL["Agility"], ""};
				{ 22, "s44633", "inv_enchant_formulagood_01", "=ds=Enchant Weapon - Exceptional Agility", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 23, "s27984", "inv_enchant_formulasuperior_01", "=ds=Enchant Weapon - Mongoose", "=ds=#sr# 375", "=ds="..AL["Drop"]};
				{ 24, "s42620", "inv_misc_note_01", "=ds=Enchant Weapon - Greater Agility", "=ds=#sr# 350", "=ds="..BabbleFaction["The Violet Eye"].." - "..BabbleFaction["Exalted"]};
				{ 25, "s23800", "inv_misc_note_01", "=ds=Enchant Weapon - Agility", "=ds=#sr# 290", "=ds="..BabbleFaction["Timbermaw Hold"].." - "..BabbleFaction["Honored"]};
				{ 27, 0, "INV_Box_01", "=q6="..AL["Intellect"], ""};
				{ 28, "s74242", "inv_enchant_formulasuperior_01", "=ds=Enchant Weapon - Power Torrent", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 29, "s27968", "inv_enchant_formulagood_01", "=ds=Enchant Weapon - Major Intellect", "=ds=#sr# 340", "=ds="..AL["Drop"]};
				{ 30, "s23804", "inv_misc_note_01", "=ds=Enchant Weapon - Mighty Intellect", "=ds=#sr# 300", "=ds="..AL["Vendor"]};
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Damage"], ""};
				{ 2, "s74211", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Elemental Slayer", "=ds=#sr# 470", "=ds="..AL["Trainer"]};
				{ 3, "s44621", "inv_enchant_formulasuperior_01", "=ds=Enchant Weapon - Giant Slayer", "=ds=#sr# 430", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 4, "s27967", "inv_misc_note_01", "=ds=Enchant Weapon - Major Striking", "=ds=#sr# 340", "=ds="..BabbleFaction["The Consortium"].." - "..BabbleFaction["Honored"]};
				{ 5, "s20031", "inv_enchant_formulasuperior_01", "=ds=Enchant Weapon - Superior Striking", "=ds=#sr# 300", "=ds="..AL["Drop"]};
				{ 6, "s13943", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Greater Striking", "=ds=#sr# 245", "=ds="..AL["Trainer"]};
				{ 7, "s13915", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Demonslaying", "=ds=#sr# 230", "=ds="..AL["Drop"]};
				{ 8, "s13693", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Striking", "=ds=#sr# 195", "=ds="..AL["Trainer"]};
				{ 9, "s13653", "inv_enchant_formulagood_01", "=ds=Enchant Weapon - Lesser Beastslayer", "=ds=#sr# 175", "=ds="..AL["Drop"]};
				{ 10, "s13655", "inv_enchant_formulagood_01", "=ds=Enchant Weapon - Lesser Elemental Slayer", "=ds=#sr# 175", "=ds="..AL["Drop"]};
				{ 11, "s13503", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Lesser Striking", "=ds=#sr# 140", "=ds="..AL["Trainer"]};
				{ 12, "s7786", "inv_enchant_formulagood_01", "=ds=Enchant Weapon - Minor Beastslayer", "=ds=#sr# 90", "=ds="..AL["Drop"]};
				{ 13, "s7788", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Minor Striking", "=ds=#sr# 90", "=ds="..AL["Trainer"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Strength"], ""};
				{ 17, "s27972", "inv_enchant_formulagood_01", "=ds=Enchant Weapon - Potency", "=ds=#sr# 350", "=ds="..AL["Drop"]};
				{ 18, "s23799", "inv_misc_note_01", "=ds=Enchant Weapon - Strength", "=ds=#sr# 290", "=ds="..AL["Vendor"]};
				{ 20, 0, "INV_Box_01", "=q6="..AL["Attack Power"], ""};
				{ 21, "s74246", "inv_enchant_formulasuperior_01", "=ds=Enchant Weapon - Landslide", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 22, "s59621", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Berserking", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 23, "s60707", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Superior Potency", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 24, "s60621", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Greater Potency", "=ds="..AL["Trainer"] };
				{ 26, 0, "INV_Box_01", "=q6="..AL["Spirit"], ""};
				{ 27, "s74225", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Heartsong", "=ds=#sr# 485", "=ds="..AL["Trainer"]};
				{ 28, "s44510", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Exceptional Spirit", "=ds="..AL["Trainer"] };
				{ 29, "s23803", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Mighty Spirit", "=ds=#sr# 300"};
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Spell Power"], ""};
				{ 2, "s60714", "inv_enchant_formulasuperior_01", "=ds=Enchant Weapon - Mighty Spellpower", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 3, "s44629", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Exceptional Spellpower", "=ds=#sr# 395", "=ds="..AL["Trainer"] };
				{ 4, "s27982", "inv_enchant_formulasuperior_01", "=ds=Enchant Weapon - Soulfrost", "=ds=#sr# 375"};
				{ 5, "s27981", "inv_enchant_formulasuperior_01", "=ds=Enchant Weapon - Sunfire", "=ds=#sr# 375"};
				{ 6, "s34010", "inv_enchant_formulagood_01", "=ds=Enchant Weapon - Major Healing", "=ds=#sr# 350"};
				{ 7, "s27975", "inv_enchant_formulagood_01", "=ds=Enchant Weapon - Major Spellpower", "=ds=#sr# 350"};
				{ 8, "s22750", "inv_enchant_formulasuperior_01", "=ds=Enchant Weapon - Healing Power", "=ds=#sr# 300"};
				{ 9, "s22749", "inv_enchant_formulasuperior_01", "=ds=Enchant Weapon - Spellpower", "=ds=#sr# 300"};
				{ 10, "s21931", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Winter's Might", "=ds=#sr# 190"};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Other"], ""};
				{ 17, "s59619", "Spell_Holy_GreaterHeal", "=ds=Enchant Weapon - Accuracy", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
			};
		};
		info = {
			name = ENCHANTING..": "..AL["Enchant Weapon"],
			module = moduleName, menu = "ENCHANTINGMENU", instance = "Enchanting",
		};
	};

	AtlasLoot_Data["EnchantingStaff"] = {
		["Normal"] = {
			{
				{ 1, "s62948", "Spell_Holy_GreaterHeal", "=ds=Enchant Staff - Greater Spellpower", "=ds="};
				{ 2, "s62959", "Spell_Holy_GreaterHeal", "=ds=Enchant Staff - Spellpower", "=ds="};
			};
		};
		info = {
			name = ENCHANTING..": "..BabbleInventory["Staff"],
			module = moduleName, menu = "ENCHANTINGMENU", instance = "Enchanting",
		};
	};

	AtlasLoot_Data["EnchantingMisc"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Rod"], ""};
				{ 2, "s92370", "52723", "=q3=Runed Elementium Rod", "=ds=#sr# 515", "=ds="..AL["Vendor"]};
				{ 3, "s60619", "44452", "=q3=Runed Titanium Rod", "=ds=#sr# 425", "=ds="..AL["Trainer"]};
				{ 4, "s32667", "22463", "=q3=Runed Eternium Rod", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
				{ 5, "s32665", "22462", "=q2=Runed Adamantite Rod", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 6, "s32664", "22461", "=q1=Runed Fel Iron Rod", "=ds=#sr# 300", "=ds="..AL["Trainer"]};
				{ 7, "s20051", "16207", "=q1=Runed Arcanite Rod", "=ds=#sr# 290", "=ds="..AL["Trainer"]};
				{ 8, "s13702", "11145", "=q1=Runed Truesilver Rod", "=ds=#sr# 200", "=ds="..AL["Trainer"]};
				{ 9, "s13628", "11130", "=q1=Runed Golden Rod", "=ds=#sr# 150", "=ds="..AL["Trainer"]};
				{ 10, "s7795", "6339", "=q1=Runed Silver Rod", "=ds=#sr# 100", "=ds="..AL["Trainer"]};
				{ 11, "s7421", "6218", "=q1=Runed Copper Rod", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
				{ 13, 0, "INV_Box_01", "=q6="..BabbleInventory["Companions"], ""};
				{ 14, "s93843", "67275", "=q3=Magic Lamp", "=ds=#sr# 525", "=ds="..AL["Vendor"]..", "..BabbleFaction["Alliance"]};
				{ 15, "s93841", "67274", "=q3=Enchanted Lantern", "=ds=#sr# 525", "=ds="..AL["Vendor"]..", "..BabbleFaction["Horde"]};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Oil"], ""};
				{ 17, "s28019", "22522", "=q1=Superior Wizard Oil", "=ds=#sr# 340", "=ds="..AL["Vendor"]..": "..BabbleZone["Shattrath City"]};
				{ 18, "s28016", "22521", "=q1=Superior Mana Oil", "=ds=#sr# 310", "=ds="..AL["Vendor"]..": "..BabbleZone["Shattrath City"]};
				{ 19, "s25128", "20750", "=q1=Wizard Oil", "=ds=#sr# 275", "=ds="..AL["Vendor"]..": "..BabbleZone["Silithus"]};
				{ 20, "s25127", "20747", "=q1=Lesser Mana Oil", "=ds=#sr# 250", "=ds="..AL["Vendor"]..": "..BabbleZone["Silithus"]};
				{ 21, "s25126", "20746", "=q1=Lesser Wizard Oil", "=ds=#sr# 200", "=ds="..AL["Vendor"]};
				{ 22, "s25125", "20745", "=q1=Minor Mana Oil", "=ds=#sr# 150", "=ds="..AL["Vendor"]};
				{ 23, "s25124", "20744", "=q1=Minor Wizard Oil", "=ds=#sr# 45", "=ds="..AL["Vendor"]};
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Other"], ""};
				{ 2, "s104698", "52721", "=q3=Maelstrom Shatter", "=ds=#sr# 525", "=ds="};
				{ 3, "s45765", "22449", "=q3=Void Shatter", "=ds=#sr# 360", "=ds="..AL["Vendor"]..": "..BabbleZone["Isle of Quel'Danas"]};
				{ 4, "s28028", "22459", "=q4=Void Sphere", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 5, "s28022", "22449", "=q3=Large Prismatic Shard", "=ds=#sr# 335", "=ds="..AL["Vendor"]..": "..BabbleZone["Shattrath City"]};
				{ 6, "s42615", "22448", "=q3=Small Prismatic Shard", "=ds=#sr# 335", "=ds="..AL["Trainer"]};
				{ 7, "s28027", "22460", "=q3=Prismatic Sphere", "=ds=#sr# 325", "=ds="..AL["Trainer"]};
				{ 8, "s42613", "22448", "=q3=Nexus Transformation", "=ds=#sr# 300", "=ds="..AL["Trainer"]};
				{ 9, "s15596", "11811", "=q3=Smoking Heart of the Mountain", "=ds=#sr# 265", "=ds="..AL["Drop"]..": "..BabbleBoss["Lord Roccor"]};
				{ 10, "s17181", "12810", "=q1=Enchanted Leather", "=ds=#sr# 250", "=ds="..AL["Trainer"]};
				{ 11, "s17180", "12655", "=q1=Enchanted Thorium", "=ds=#sr# 250", "=ds="..AL["Trainer"]};
				{ 16, 0, "INV_Box_01", "=q6="..BabbleInventory["Wand"], ""};
				{ 17, "s14810", "11290", "=q2=Greater Mystic Wand", "=ds=#sr# 175", "=ds="..AL["Trainer"]};
				{ 18, "s14809", "11289", "=q2=Lesser Mystic Wand", "=ds=#sr# 155", "=ds="..AL["Trainer"]};
				{ 19, "s14807", "11288", "=q2=Greater Magic Wand", "=ds=#sr# 70", "=ds="..AL["Trainer"]};
				{ 20, "s14293", "11287", "=q2=Lesser Magic Wand", "=ds=#sr# 10", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = ENCHANTING..": "..BabbleInventory["Miscellaneous"],
			module = moduleName, menu = "ENCHANTINGMENU", instance = "Enchanting",
		};
	};

	AtlasLoot_Data["EnchantingCataVendor"] = {
		["Normal"] = {
			{
				{ 1, 65359, "", "=q1=Formula: Runed Elementium Rod", "=ds=#p4# (515)", "1 #heavenlyshard#" },
				{ 2, 64411, "", "=q2=Formula: Enchant Boots - Assassin's Step", "=ds=#p4# (525)", "5 #heavenlyshard#" },
				{ 3, 64412, "", "=q2=Formula: Enchant Boots - Lavawalker", "=ds=#p4# (525)", "5 #heavenlyshard#" },
				{ 4, 52738, "", "=q2=Formula: Enchant Bracer - Greater Critical Strike", "=ds=#p4# (525)", "5 #heavenlyshard#" },
				{ 5, 64413, "", "=q2=Formula: Enchant Bracer - Greater Speed", "=ds=#p4# (525)", "5 #heavenlyshard#" },
				{ 6, 52740, "", "=q2=Formula: Enchant Chest - Greater Stamina", "=ds=#p4# (525)", "5 #heavenlyshard#" },
				{ 7, 52739, "", "=q2=Formula: Enchant Chest - Peerless Stats", "=ds=#p4# (525)", "5 #heavenlyshard#" },
				{ 8, 52737, "", "=q2=Formula: Enchant Cloak - Greater Critical Strike", "=ds=#p4# (525)", "5 #heavenlyshard#" },
				{ 9, 64414, "", "=q2=Formula: Enchant Gloves - Greater Mastery", "=ds=#p4# (525)", "5 #heavenlyshard#" },
				{ 10, 64415, "", "=q2=Formula: Enchant Gloves - Mighty Strength", "=ds=#p4# (525)", "5 #heavenlyshard#" },
				{ 11, 52736, "", "=q3=Formula: Enchant Weapon - Landslide", "=ds=#p4# (525)", "5 #maelstromcrystal#" },
				{ 12, 52733, "", "=q3=Formula: Enchant Weapon - Power Torrent", "=ds=#p4# (525)", "5 #maelstromcrystal#" },
				{ 13, 52735, "", "=q3=Formula: Enchant Weapon - Windwalk", "=ds=#p4# (525)", "5 #maelstromcrystal#" },
				{ 14, 67312, "", "=q3=Formula: Magic Lamp", "=ds=#p4# (525)", "20 #hypnoticdust#, =ds="..BabbleFaction["Alliance"] },
				{ 15, 67308, "", "=q3=Formula: Enchanted Lantern", "=ds=#p4# (525)", "20 #hypnoticdust#, =ds="..BabbleFaction["Horde"] },
			};
		};
		info = {
			name = ENCHANTING..": "..AL["Cataclysm Vendor Sold Formulas"],
			module = moduleName, menu = "ENCHANTINGMENU", instance = "Enchanting",
		};
	};

		-------------------
		--- Engineering ---
		-------------------

	AtlasLoot_Data["EngineeringArmorCloth"] = {
		["Normal"] = {
			{
				{ 1, "s81725", "59449", "=q4=Lightweight Bio-Optic Killshades", "=ds=#sr# 525", "=ds="..AL["Trainer"] };
				{ 2, "s56484", "42553", "=q4=Visage Liquification Goggles", "=ds=#sr# 440", "=ds="..AL["Trainer"] };
				{ 3, "s46111", "34847", "=q4=Annihilator Holo-Gogs", "=ds=#sr# 375", "=ds="..BabbleZone["Sunwell Plateau"] };
				{ 4, "s30565", "23838", "=q4=Foreman's Enchanted Helmet", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
				{ 5, "s30574", "23828", "=q4=Gnomish Power Goggles", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
				{ 6, "s46108", "35181", "=q4=Powerheal 9000 Lens", "=ds=#sr# 375", "=ds="..BabbleZone["Sunwell Plateau"] };
				{ 7, "s41320", "32494", "=q4=Destruction Holo-Gogs", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 8, "s41321", "32495", "=q4=Powerheal 4000 Lens", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = ENGINEERING..": "..BabbleInventory["Cloth"],
			module = moduleName, menu = "ENGINEERINGMENU", instance = "Engineering",
		};
	};

	AtlasLoot_Data["EngineeringArmorLeather"] = {
		["Normal"] = {
			{
				{ 1, "s81722", "59455", "=q4=Agile Bio-Optic Killshades", "=ds=#sr# 525", "=ds="..AL["Trainer"] };
				{ 2, "s81724", "59453", "=q4=Camouflauge Bio-Optic Killshades", "=ds=#sr# 525", "=ds="..AL["Trainer"] };
				{ 3, "s56486", "42554", "=q4=Greensight Gogs", "=ds=#sr# 440", "=ds="..AL["Trainer"] };
				{ 4, "s56481", "42550", "=q4=Weakness Spectralizers", "=ds=#sr# 440", "=ds="..AL["Trainer"] };
				{ 5, "s30575", "23829", "=q4=Gnomish Battle Goggles", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
				{ 6, "s46109", "35182", "=q4=Hyper-Magnified Moon Specs", "=ds=#sr# 375", "=ds="..BabbleZone["Sunwell Plateau"] };
				{ 7, "s46116", "34353", "=q4=Quad Deathblow X44 Goggles", "=ds=#sr# 375", "=ds="..BabbleZone["Sunwell Plateau"] };
				{ 8, "s46106", "35183", "=q4=Wonderheal XT68 Shades", "=ds=#sr# 375", "=ds="..BabbleZone["Sunwell Plateau"] };
				{ 9, "s41317", "32478", "=q4=Deathblow X11 Goggles", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 10, "s41319", "32480", "=q4=Magnified Moon Specs", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 11, "s41318", "32479", "=q4=Wonderheal XT40 Shades", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = ENGINEERING..": "..BabbleInventory["Leather"],
			module = moduleName, menu = "ENGINEERINGMENU", instance = "Engineering",
		};
	};

	AtlasLoot_Data["EngineeringArmorMail"] = {
		["Normal"] = {
			{
				{ 1, "s81716", "59456", "=q4=Deadly Bio-Optic Killshades", "=ds=#sr# 525", "=ds="..AL["Trainer"] };
				{ 2, "s81720", "59458", "=q4=Energized Bio-Optic Killshades", "=ds=#sr# 525", "=ds="..AL["Trainer"] };
				{ 3, "s56487", "42555", "=q4=Electroflux Sight Enhancers", "=ds=#sr# 440", "=ds="..AL["Trainer"] };
				{ 4, "s56574", "42551", "=q4=Truesight Ice Blinders", "=ds=#sr# 440", "=ds="..AL["Trainer"] };
				{ 5, "s30566", "23839", "=q4=Foreman's Reinforced Helmet", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
				{ 6, "s46112", "34355", "=q4=Lightning Etched Specs", "=ds=#sr# 375", "=ds="..BabbleZone["Sunwell Plateau"] };
				{ 7, "s46110", "35184", "=q4=Primal-Attuned Goggles", "=ds=#sr# 375", "=ds="..BabbleZone["Sunwell Plateau"] };
				{ 8, "s46113", "34356", "=q4=Surestrike Goggles v3.0", "=ds=#sr# 375", "=ds="..BabbleZone["Sunwell Plateau"] };
				{ 9, "s41315", "32476", "=q4=Gadgetstorm Goggles", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 10, "s41316", "32475", "=q4=Living Replicator Specs", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 11, "s41314", "32474", "=q4=Surestrike Goggles v2.0", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = ENGINEERING..": "..BabbleInventory["Mail"],
			module = moduleName, menu = "ENGINEERINGMENU", instance = "Engineering",
		};
	};

	AtlasLoot_Data["EngineeringArmorPlate"] = {
		["Normal"] = {
			{
				{ 1, "s81714", "59359", "=q4=Reinforced Bio-Optic Killshades", "=ds=#sr# 525", "=ds="..AL["Trainer"] };
				{ 2, "s81715", "59448", "=q4=Specialized Bio-Optic Killshades", "=ds=#sr# 525", "=ds="..AL["Trainer"] };
				{ 3, "s56480", "42549", "=q4=Armored Titanium Goggles", "=ds=#sr# 440", "=ds="..AL["Trainer"] };
				{ 4, "s56483", "42552", "=q4=Charged Titanium Specs", "=ds=#sr# 440", "=ds="..AL["Trainer"] };
				{ 5, "s62271", "44949", "=q4=Unbreakable Healing Amplifiers", "=ds=#sr# 440", "=ds="..AL["Trainer"] };
				{ 6, "s46115", "34357", "=q4=Hard Khorium Goggles", "=ds=#sr# 375", "=ds="..BabbleZone["Sunwell Plateau"] };
				{ 7, "s46107", "35185", "=q4=Justicebringer 3000 Specs", "=ds=#sr# 375", "=ds="..BabbleZone["Sunwell Plateau"] };
				{ 8, "s46114", "34354", "=q4=Mayhem Projection Goggles", "=ds=#sr# 375", "=ds="..BabbleZone["Sunwell Plateau"] };
				{ 9, "s40274", "32461", "=q4=Furious Gizmatic Goggles", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 10, "s41312", "32473", "=q4=Tankatronic Goggles", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = ENGINEERING..": "..BabbleInventory["Plate"],
			module = moduleName, menu = "ENGINEERINGMENU", instance = "Engineering",
		};
	};

	AtlasLoot_Data["EngineeringArmorTrinket"] = {
		["Normal"] = {
			{
				{ 1, "s95705", "40727", "=q3=Gnomish Gravity Well", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 2, "s84418", "60403", "=q3=Elementium Dragonling", "=ds=#sr# 475", "=ds="..AL["Trainer"] };
				{ 3, "s56469", "41121", "=q3=Gnomish Lightning Generator", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 4, "s56467", "40865", "=q3=Noise Machine", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 5, "s56466", "40767", "=q3=Sonic Booster", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 6, "s30563", "23836", "=q3=Goblin Rocket Launcher", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 7, "s30569", "23835", "=q3=Gnomish Poultryizer", "=ds=#sr# 340", "=ds="..AL["Trainer"] };
				{ 8, "s19830", "16022", "=q3=Arcanite Dragonling", "=ds=#sr# 300", "=ds="..AL["Vendor"] };
				{ 9, "s23082", "18639", "=q3=Ultra-Flash Shadow Reflector", "=ds=#sr# 300", "=ds="..BabbleZone["Stratholme"] };
				{ 10, "s23081", "18638", "=q3=Hyper-Radiant Flame Reflector", "=ds=#sr# 290", "=ds="..BabbleZone["Blackrock Spire"] };
				{ 11, "s23079", "18637", "=q2=Major Recombobulator", "=ds=#sr# 275", "=ds="..BabbleZone["Dire Maul"] };
				{ 12, "s63750", "45631", "=q3=High-powered Flashlight", "=ds=#sr# 270", "=ds="..AL["Vendor"] };
				{ 13, "s23077", "18634", "=q3=Gyrofreeze Ice Reflector", "=ds=#sr# 260", "=ds="..AL["Vendor"] };
				{ 14, "s12624", "10576", "=q2=Mithril Mechanical Dragonling", "=ds=#sr# 250", "=ds="..AL["Trainer"] };
				{ 15, "s12759", "10645", "=q1=Gnomish Death Ray", "=ds=#sr# 240", "=ds="..AL["Trainer"] };
				{ 16, "s12908", "10727", "=q1=Goblin Dragon Gun", "=ds=#sr# 240", "=ds="..AL["Trainer"] };
				{ 17, "s12906", "10725", "=q1=Gnomish Battle Chicken", "=ds=#sr# 230", "=ds="..AL["Trainer"] };
				{ 18, "s12755", "10587", "=q1=Goblin Bomb Dispenser", "=ds=#sr# 230", "=ds="..AL["Trainer"] };
				{ 19, "s12899", "10716", "=q2=Gnomish Shrink Ray", "=ds=#sr# 205", "=ds="..AL["Trainer"] };
				{ 20, "s12716", "10577", "=q2=Goblin Mortar", "=ds=#sr# 205", "=ds="..AL["Trainer"] };
				{ 21, "s3971", "4397", "=q2=Gnomish Cloaking Device", "=ds=#sr# 200", "=ds="..AL["Vendor"] };
				{ 22, "s3969", "4396", "=q2=Mechanical Dragonling", "=ds=#sr# 200", "=ds="..AL["Vendor"] };
				{ 23, "s3952", "4381", "=q2=Minor Recombobulator", "=ds=#sr# 140", "=ds="..AL["Vendor"] };
				{ 24, "s9269", "7506", "=q2=Gnomish Universal Remote", "=ds=#sr# 125", "=ds="..BabbleZone["Gnomeregan"] };
			};
		};
		info = {
			name = ENGINEERING..": "..BabbleInventory["Trinket"],
			module = moduleName, menu = "ENGINEERINGMENU", instance = "Engineering",
		};
	};

	AtlasLoot_Data["EngineeringArmor"] = {
		["Normal"] = {
			{
				{ 1, "s56473", "40895", "=q3=Gnomish X-Ray Specs", "=ds=#sr# 425", "=ds="..AL["Trainer"]};
				{ 2, "s61483", "44742", "=q3=Mechanized Snow Goggles", "=ds=#sr# 420", "=ds="..AL["Trainer"]};
				{ 3, "s30325", "23763", "=q3=Hyper-Vision Goggles", "=ds=#sr# 360", "=ds="..AL["Drop"]};
				{ 4, "s30556", "23824", "=q3=Rocket Boots Xtreme", "=ds=#sr# 355", "=ds="..BabbleZone["The Steamvault"]};
				{ 5, "s46697", "35581", "=q3=Rocket Boots Xtreme Lite", "=ds=#sr# 355", "=ds="..BabbleZone["The Mechanar"]};
				{ 6, "s30570", "23825", "=q3=Nigh-Invulnerability Belt", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 7, "s30318", "23762", "=q3=Ultra-Spectropic Detection Goggles", "=ds=#sr# 350", "=ds="..AL["Vendor"]};
				{ 8, "s30316", "23758", "=q3=Cogspinner Goggles", "=ds=#sr# 340", "=ds="..AL["Vendor"]};
				{ 9, "s30317", "23761", "=q3=Power Amplification Goggles", "=ds=#sr# 340", "=ds="..AL["World Drop"]};
				{ 10, "s22797", "18168", "=q4=Force Reactive Disk", "=ds=#sr# 300", "=ds="..BabbleZone["Molten Core"]};
				{ 11, "s24356", "19999", "=q3=Bloodvine Goggles", "=ds=#sr# 300", "=ds="..BabbleFaction["Zandalar Tribe"].." - "..BabbleFaction["Honored"]};
				{ 12, "s24357", "19998", "=q3=Bloodvine Lens", "=ds=#sr# 300", "=ds="..BabbleFaction["Zandalar Tribe"].." - "..BabbleFaction["Friendly"]};
				{ 13, "s19825", "16008", "=q2=Master Engineer's Goggles", "=ds=#sr# 290", "=ds="..AL["Trainer"]};
				{ 14, "s19819", "16009", "=q2=Voice Amplification Modulator", "=ds=#sr# 290", "=ds="..BabbleZone["Stratholme"]};
				{ 15, "s19794", "15999", "=q2=Spellpower Goggles Xtreme Plus", "=ds=#sr# 270", "=ds="..AL["Trainer"]};
				{ 16, "s12622", "10504", "=q3=Green Lens", "=ds=#sr# 245", "=ds="..AL["Trainer"]};
				{ 17, "s12758", "10588", "=q2=Goblin Rocket Helmet", "=ds=#sr# 245", "=ds="..AL["Trainer"]};
				{ 18, "s12907", "10726", "=q2=Gnomish Mind Control Cap", "=ds=#sr# 235", "=ds="..AL["Trainer"]};
				{ 19, "s12617", "10506", "=q2=Deepdive Helmet", "=ds=#sr# 230", "=ds=???"}; --recipe removed with Cata
				{ 20, "s12618", "10503", "=q2=Rose Colored Goggles", "=ds=#sr# 230", "=ds="..AL["Trainer"]};
				{ 21, "s12905", "10724", "=q2=Gnomish Rocket Boots", "=ds=#sr# 225", "=ds="..AL["Trainer"]};
				{ 22, "s8895", "7189", "=q2=Goblin Rocket Boots", "=ds=#sr# 225", "=ds="..AL["Trainer"]};
				{ 23, "s12616", "10518", "=q2=Parachute Cloak", "=ds=#sr# 225", "=ds="..AL["Trainer"]};
				{ 24, "s12615", "10502", "=q2=Spellpower Goggles Xtreme", "=ds=#sr# 225"};
				{ 25, "s12607", "10501", "=q2=Catseye Ultra Goggles", "=ds=#sr# 220", "=ds="..AL["World Drop"]};
				{ 26, "s12903", "10721", "=q2=Gnomish Harm Prevention Belt", "=ds=#sr# 215", "=ds="..AL["Trainer"]};
				{ 27, "s12897", "10545", "=q2=Gnomish Goggles", "=ds=#sr# 210", "=ds="..AL["Trainer"]};
				{ 28, "s12594", "10500", "=q2=Fire Goggles", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 29, "s12718", "10543", "=q2=Goblin Construction Helmet", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 30, "s12717", "10542", "=q2=Goblin Mining Helmet", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, "s3966", "4393", "=q2=Craftsman's Monocle", "=ds=#sr# 185", "=ds="..AL["World Drop"]};
				{ 2, "s12587", "10499", "=q2=Bright-Eye Goggles", "=ds=#sr# 175", "=ds="..AL["World Drop"]};
				{ 3, "s3956", "4385", "=q2=Green Tinted Goggles", "=ds=#sr# 150", "=ds="..AL["Trainer"]};
				{ 4, "s3940", "4373", "=q2=Shadow Goggles", "=ds=#sr# 120", "=ds="..AL["World Drop"]};
				{ 5, "s3934", "4368", "=q2=Flying Tiger Goggles", "=ds=#sr# 100", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = ENGINEERING..": "..BabbleInventory["Armor"],
			module = moduleName, menu = "ENGINEERINGMENU", instance = "Engineering",
		};
	};

	AtlasLoot_Data["EngineeringExplosives"] = {
		["Normal"] = {
			{
				{ 1, "s95707", "63396", "=q1=Big Daddy", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 2, "s84409", "60853", "=q1=Volatile Seaforium Blastpack", "=ds=#sr# 455", "=ds="..AL["Trainer"] };
				{ 3, "s56514", "42641", "=q1=Global Thermal Sapper Charge", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 4, "s56468", "44951", "=q1=Box of Bombs", "=ds=#sr# 405", "=ds="..AL["Trainer"] };
				{ 5, "s56463", "40536", "=q1=Explosive  ", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
				{ 6, "s56460", "40771", "=q1=Cobalt Frag Bomb", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 7, "s30547", "23819", "=q1=Elemental Seaforium Charge", "=ds=#sr# 350", "=ds="..BabbleFaction["The Consortium"].." - "..BabbleFaction["Revered"] };
				{ 8, "s30560", "23827", "=q1=Super Sapper Charge", "=ds=#sr# 340", "=ds="..AL["Trainer"] };
				{ 9, "s39973", "32413", "=q1=Frost Grenades", "=ds=#sr# 335", "=ds="..AL["Trainer"] };
				{ 10, "s30311", "23737", "=q1=Adamantite Grenade", "=ds=#sr# 325", "=ds="..AL["Trainer"] };
				{ 11, "s30558", "23826", "=q1=The Bigger One", "=ds=#sr# 325", "=ds="..AL["Trainer"] };
				{ 12, "s19831", "16040", "=q1=Arcane Bomb", "=ds=#sr# 300", "=ds="..AL["World Drop"] };
				{ 13, "s30310", "23736", "=q1=Fel Iron Bomb", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{ 14, "s19799", "16005", "=q1=Dark Iron Bomb", "=ds=#sr# 285", "=ds="..BabbleZone["Blackrock Depths"] };
				{ 15, "s23080", "18594", "=q1=Powerful Seaforium Charge", "=ds=#sr# 275", "=ds="..AL["Vendor"] };
				{ 16, "s19790", "15993", "=q1=Thorium Grenade", "=ds=#sr# 260", "=ds="..AL["Trainer"] };
				{ 17, "s23070", "18641", "=q1=Dense Dynamite", "=ds=#sr# 250", "=ds="..AL["Trainer"] };
				{ 18, "s12619", "10562", "=q1=Hi-Explosive Bomb", "=ds=#sr# 235", "=ds="..AL["Trainer"] };
				{ 19, "s12754", "10586", "=q1=The Big One", "=ds=#sr# 235", "=ds="..AL["Trainer"] };
				{ 20, "s12603", "10514", "=q1=Mithril Frag Bomb", "=ds=#sr# 215", "=ds="..AL["Trainer"] };
				{ 21, "s12760", "10646", "=q1=Goblin Sapper Charge", "=ds=#sr# 205", "=ds="..AL["Trainer"] };
				{ 22, "s13240", "10577", "=q2=The Mortar: Reloaded", "=ds=#sr# 205", "=ds="..AL["Trainer"] };
				{ 23, "s23069", "18588", "=q1=Ez-Thro Dynamite II", "=ds=#sr# 200", "=ds="..AL["Vendor"] };
				{ 24, "s3972", "4398", "=q1=Large Seaforium Charge", "=ds=#sr# 200", "=ds="..AL["World Drop"] };
				{ 25, "s3968", "4395", "=q1=Goblin Land Mine", "=ds=#sr# 195", "=ds="..AL["World Drop"] };
				{ 26, "s3967", "4394", "=q1=Big Iron Bomb", "=ds=#sr# 190", "=ds="..AL["Trainer"] };
				{ 27, "s8243", "4852", "=q1=Flash Bomb", "=ds=#sr# 185", "=ds="..BabbleZone["Gnomeregan"] };
				{ 28, "s3962", "4390", "=q1=Iron Grenade", "=ds=#sr# 175", "=ds="..AL["Trainer"] };
				{ 29, "s12586", "10507", "=q1=Solid Dynamite", "=ds=#sr# 175", "=ds="..AL["Trainer"] };
				{ 30, "s3960", "4403", "=q1=Portable Bronze Mortar", "=ds=#sr# 165", "=ds="..AL["World Drop"] };
			};
			{
				{ 1, "s3950", "4380", "=q1=Big Bronze Bomb", "=ds=#sr# 140", "=ds="..AL["Trainer"] };
				{ 2, "s3946", "4378", "=q1=Heavy Dynamite", "=ds=#sr# 125", "=ds="..AL["Trainer"] };
				{ 3, "s3941", "4374", "=q1=Small Bronze Bomb", "=ds=#sr# 120", "=ds="..AL["Trainer"] };
				{ 4, "s3937", "4370", "=q1=Large Copper Bomb", "=ds=#sr# 105", "=ds="..AL["Trainer"] };
				{ 5, "s8339", "6714", "=q1=Ez-Thro Dynamite", "=ds=#sr# 100", "=ds="..AL["World Drop"] };
				{ 6, "s3933", "4367", "=q1=Small Seaforium Charge", "=ds=#sr# 100", "=ds="..AL["World Drop"] };
				{ 7, "s3931", "4365", "=q1=Coarse Dynamite", "=ds=#sr# 75", "=ds="..AL["Trainer"] };
				{ 8, "s3923", "4360", "=q1=Rough Copper Bomb", "=ds=#sr# 30", "=ds="..AL["Trainer"] };
				{ 9, "s3919", "4358", "=q1=Rough Dynamite", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = ENGINEERING..": "..BabbleInventory["Explosives"],
			module = moduleName, menu = "ENGINEERINGMENU", instance = "Engineering",
		};
	};

	AtlasLoot_Data["EngineeringScope"] = {
		["Normal"] = {
			{
				{ 1, "s100587", "70139", "=q3=Flintlocke's Woodchucker", "=ds=#sr# 515", "=ds="..BabbleZone["Molten Front"]};
				{ 2, "s84428", "59594", "=q3=Gnomish X-Ray Scope", "=ds=#sr# 515", "=ds="..AL["Trainer"] };
				{ 3, "s84410", "59596", "=q3=Safety Catch Removal Kit", "=ds=#sr# 450", "=ds="..AL["Trainer"] };
				{ 4, "s84408", "59595", "=q3=R19 Threatfinder", "=ds=#sr# 450", "=ds="..AL["Trainer"] };
				{ 6, "s56478", "41167", "=q3=Heartseeker Scope", "=ds=#sr# 430", "=ds="..AL["Trainer"] };
				{ 7, "s56470", "41146", "=q3=Sun Scope", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 8, "s61471", "44739", "=q1=Diamond-Cut Refractor Scope", "=ds=#sr# 390", "=ds="..AL["Trainer"] };
				{ 10, "s30334", "23766", "=q3=Stabilized Eternium Scope", "=ds=#sr# 375", "=ds="..BabbleZone["Karazhan"] };
				{ 11, "s30332", "23765", "=q3=Khorium Scope", "=ds=#sr# 360", "=ds="..BabbleZone["Netherstorm"] };
				{ 12, "s30329", "23764", "=q2=Adamantite Scope", "=ds=#sr# 335", "=ds="..AL["Vendor"] };
				{ 16, "s22793", "18283", "=q3=Biznicks 247x128 Accurascope", "=ds=#sr# 300", "=ds="..BabbleZone["Molten Core"] };
				{ 17, "s12620", "10548", "=q1=Sniper Scope", "=ds=#sr# 240", "=ds="..AL["World Drop"] };
				{ 18, "s12597", "10546", "=q1=Deadly Scope", "=ds=#sr# 210", "=ds="..AL["Vendor"] };
				{ 19, "s3979", "4407", "=q2=Accurate Scope", "=ds=#sr# 180", "=ds="..AL["Vendor"] };
				{ 20, "s3978", "4406", "=q1=Standard Scope", "=ds=#sr# 110", "=ds="..AL["Trainer"] };
				{ 21, "s3977", "4405", "=q1=Crude Scope", "=ds=#sr# 60", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = ENGINEERING..": "..AL["Scope"],
			module = moduleName, menu = "ENGINEERINGMENU", instance = "Engineering",
		};
	};

	AtlasLoot_Data["EngineeringTinker"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#s4#", "" };
				{ 2, "s55002", "Trade_Engineering", "=ds=Flexweave Underlay", "=ds=#sr# 380", "=ds="..AL["Trainer"] };
				{ 4, 0, "INV_Box_01", "=q6=#s9#", "" };
				{ 5, "s82177", "Trade_Engineering", "=ds=Quickflip Deflection Plates", "=ds=#sr# 450+", "=ds="..AL["Discovery"] };
				{ 6, "s82200", "Trade_Engineering", "=ds=Spinal Healing Injector", "=ds=#sr# 450+", "=ds="..AL["Discovery"] };
				{ 7, "s82175", "Trade_Engineering", "=ds=Synapse Springs", "=ds=#sr# 450+", "=ds="..AL["Discovery"] };
				{ 8, "s82180", "Trade_Engineering", "=ds=Tazik Shocker", "=ds=#sr# 450+", "=ds="..AL["Discovery"] };
				{ 9, "s82201", "Trade_Engineering", "=ds=Z50 Mana Gulper", "=ds=#sr# 450+", "=ds="..AL["Discovery"] };
				{ 10, "s54998", "Trade_Engineering", "=ds=Hand-Mounted Pyro Rocket", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 11, "s54999", "Trade_Engineering", "=ds=Hyperspeed Accelerators", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 12, "s63770", "Trade_Engineering", "=ds=Reticulated Armor Webbing", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 16, 0, "INV_Box_01", "=q6=#s10#", "" };
				{ 17, "s84424", "Trade_Engineering", "=ds=Invisibility Field", "=ds=#sr# 450+", "=ds="..AL["Discovery"] };
				{ 18, "s84425", "Trade_Engineering", "=ds=Cardboard Assassin", "=ds=#sr# 450+", "=ds="..AL["Discovery"] };
				{ 19, "s84427", "Trade_Engineering", "=ds=Grounded Plasma Shield", "=ds=#sr# 450+", "=ds="..AL["Discovery"] };
				{ 20, "s55016", "Trade_Engineering", "=ds=Nitro Boosts", "=ds=#sr# 405", "=ds="..AL["Trainer"] };
				{ 21, "s67839", "Trade_Engineering", "=ds=Mind Amplification Dish", "=ds=#sr# 390", "=ds="..AL["Trainer"] };
				{ 22, "s54736", "Trade_Engineering", "=ds=Personal Electromagnetic Pulse Generator", "=ds=#sr# 390", "=ds="..AL["Trainer"] };
				{ 23, "s54793", "Trade_Engineering", "=ds=Frag Belt", "=ds=#sr# 380", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = ENGINEERING..": "..AL["Tinker"],
			module = moduleName, menu = "ENGINEERINGMENU", instance = "Engineering",
		};
	};

	AtlasLoot_Data["EngineeringMisc"] = {
		["Normal"] = {
			{
				{ 1, "s84430", "68049", "=q1=Heat-Treated Spinning Lure", "=ds=#sr# 510", "=ds="..AL["Trainer"]};
				{ 2, "s84429", "60858", "=q3=Goblin Barbecue", "=ds=#sr# 505", "=ds="..AL["Trainer"]};
				{ 4, "s84421", "60854", "=q3=Loot-a-Rang", "=ds=#sr# 490", "=ds="..AL["Trainer"]};
				{ 3, "s84416", "60217", "=q3=Elementium Toolbox", "=ds=#sr# 475", "=ds="..AL["Trainer"]};
				{ 5, "s84415", "60218", "=q3=Lure Master Tackle Box", "=ds=#sr# 475", "=ds="..AL["Trainer"]};
				{ 6, "s84411", "60223", "=q3=High-Powered Bolt Gun", "=ds=#sr# 465", "=ds="..AL["Trainer"]};
				{ 7, "s68067", "49040", "=q4=Jeeves", "=ds=#sr# 450", "=ds="..AL["Drop"]};
				{ 8, "s95703", "67494", "=q3=Electrostatic Condenser", "=ds=#sr# 440", "=ds="..AL["Trainer"]};
				{ 9, "s56462", "40772", "=q1=Gnomish Army Knife", "=ds=#sr# 435", "=ds="..AL["Trainer"]};
				{ 10, "s56472", "40768", "=q3=MOLL-E", "=ds=#sr# 425", "=ds="..AL["Trainer"]};
				{ 11, "s56477", "42546", "=q1=Mana Injector Kit", "=ds=#sr# 415", "=ds="..AL["Trainer"]};
				{ 12, "s55252", "40769", "=q1=Scrapbot Construction Kit", "=ds=#sr# 415", "=ds=#QUESTID:12889#"};
				{ 13, "s67920", "48933", "=q3=Wormhole Generator: Northrend", "=ds=#sr# 415", "=ds="..AL["Trainer"]};
				{ 14, "s56476", "37567", "=q1=Healing Injector Kit", "=ds=#sr# 410", "=ds="..AL["Trainer"]};
				{ 15, "s30349", "23775", "=q3=Titanium Toolbox", "=ds=#sr# 405", "=ds="..AL["Drop"]};
				{ 16, "s67326", "47828", "=q1=Goblin Beam Welder", "=ds=#sr# 400", "=ds="..AL["Trainer"]};
				{ 17, "s56461", "40893", "=q1=Bladed Pickaxe", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
				{ 18, "s56459", "40892", "=q1=Hammer Pick", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
				{ 19, "s44391", "34113", "=q1=Field Repair Bot 110G", "=ds=#sr# 360", "=ds="..AL["Drop"]};
				{ 20, "s36954", "30542", "=q2=Dimensional Ripper - Area 52", "=ds=#sr# 350"};
				{ 21, "s36955", "30544", "=q2=Ultrasafe Transporter - Toshley's Station", "=ds=#sr# 350"};
				{ 22, "s30552", "33093", "=q1=Mana Potion Injector", "=ds=#sr# 345", "=ds="..AL["Drop"]};
				{ 23, "s30551", "33092", "=q1=Healing Potion Injector", "=ds=#sr# 330", "=ds="..AL["Drop"]};
				{ 24, "s30337", "23767", "=q2=Crashin' Thrashin' Robot", "=ds=#sr# 325", "=ds="..AL["Drop"]};
				{ 25, "s30348", "23774", "=q2=Fel Iron Toolbox", "=ds=#sr# 325", "=ds="..AL["Vendor"]};
				{ 26, "s30568", "23841", "=q1=Gnomish Flame Turret", "=ds=#sr# 325", "=ds="..AL["Trainer"]};
				{ 27, "s30548", "23821", "=q1=Zapthrottle Mote Extractor", "=ds=#sr# 305", "=ds="..BabbleInventory["Quest"]};
				{ 28, "s22704", "18232", "=q1=Field Repair Bot 74A", "=ds=#sr# 300", "=ds="..BabbleZone["Blackrock Depths"]};
				{ 29, "s19814", "16023", "=q1=Masterwork Target Dummy", "=ds=#sr# 275", "=ds="..AL["Vendor"]};
				{ 30, "s28327", "22728", "=q1=Steam Tonk Controller", "=ds=#sr# 275", "=ds="..BabbleFaction["Darkmoon Faire"]};
			};
			{
				{ 1, "s23096", "18645", "=q2=Gnomish Alarm-O-Bot", "=ds=#sr# 265", "=ds="..BabbleZone["Blackrock Depths"]};
				{ 2, "s23078", "18587", "=q1=Goblin Jumper Cables XL", "=ds=#sr# 265", "=ds="..BabbleZone["Blackrock Depths"]};
				{ 3, "s23129", "18660", "=q2=World Enlarger", "=ds=#sr# 260", "=ds="..AL["Drop"]};
				{ 4, "s19567", "15846", "=q1=Salt Shaker", "=ds=#sr# 250", "=ds="..AL["Trainer"]};
				{ 5, "s12902", "10720", "=q1=Gnomish Net-o-Matic Projector", "=ds=#sr# 210", "=ds="..AL["Trainer"]};
				{ 6, "s12715", "10644", "=q1=Recipe: Goblin Rocket Fuel", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 7, "s12895", "10713", "=q1=Plans: Inlaid Mithril Cylinder", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 8, "s15255", "11590", "=q1=Mechanical Repair Kit", "=ds=#sr# 200", "=ds="..AL["Trainer"]};
				{ 9, "s21940", "17716", "=q1=Snowmaster 9000", "=ds=#sr# 190", "=ds="..AL["Feast of Winter Veil"]};
				{ 10, "s3965", "4392", "=q1=Advanced Target Dummy", "=ds=#sr# 185", "=ds="..AL["Trainer"]};
				{ 11, "s3963", "4391", "=q1=Compact Harvest Reaper Kit", "=ds=#sr# 175", "=ds="..AL["Trainer"]};
				{ 12, "s9273", "7148", "=q1=Goblin Jumper Cables", "=ds=#sr# 165", "=ds="..AL["Vendor"]};
				{ 13, "s3959", "4388", "=q1=Discombobulator Ray", "=ds=#sr# 160", "=ds="..BabbleZone["Gnomeregan"]};
				{ 14, "s3957", "4386", "=q1=Ice Deflector", "=ds=#sr# 155", "=ds=???"}; --schematic removed with Cata
				{ 15, "s3955", "4384", "=q1=Explosive Sheep", "=ds=#sr# 150", "=ds="..AL["Trainer"]};
				{ 16, "s9271", "6533", "=q1=Aquadynamic Fish Attractor", "=ds=#sr# 150", "=ds="..AL["Trainer"]};
				{ 17, "s6458", "5507", "=q1=Ornate Spyglass", "=ds=#sr# 135", "=ds="..AL["Trainer"]};
				{ 18, "s3944", "4376", "=q1=Flame Deflector", "=ds=#sr# 125", "=ds="..BabbleZone["Gnomeregan"]};
				{ 19, "s8334", "6712", "=q1=Practice Lock", "=ds=#sr# 100", "=ds="..AL["Trainer"]};
				{ 20, "s3932", "4366", "=q1=Target Dummy", "=ds=#sr# 85", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = ENGINEERING..": "..BabbleInventory["Miscellaneous"],
			module = moduleName, menu = "ENGINEERINGMENU", instance = "Engineering",
		};
	};

	AtlasLoot_Data["EngineeringReagents"] = {
		["Normal"] = {
			{
				{ 1, "s94748", "67749", "=q1=Electrified Ether", "=ds=#sr# 445", "=ds="..AL["Trainer"]};
				{ 2, "s84403", "60224", "=q1=Handful of Obsidium Bolts", "=ds=#sr# 425", "=ds="..AL["Trainer"]};
				{ 3, "s56471", "39683", "=q1=Froststeel Tube", "=ds=#sr# 390", "=ds="..AL["Trainer"]};
				{ 4, "s56464", "39682", "=q1=Overcharged Capacitor", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
				{ 5, "s56349", "39681", "=q1=Handful of Cobalt Bolts", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 6, "s53281", "39690", "=q1=Volatile Blasting Trigger", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 7, "s30309", "23787", "=q1=Felsteel Stabilizer", "=ds=#sr# 340", "=ds="..AL["Trainer"]};
				{ 8, "s30307", "23785", "=q1=Hardened Adamantite Tube", "=ds=#sr# 340", "=ds="..AL["Trainer"]};
				{ 9, "s30308", "23786", "=q1=Khorium Power Core", "=ds=#sr# 340", "=ds="..AL["Trainer"]};
				{ 10, "s39971", "32423", "=q1=Icy Blasting Primers", "=ds=#sr# 335", "=ds="..AL["Trainer"]};
				{ 11, "s30306", "23784", "=q1=Adamantite Frame", "=ds=#sr# 325", "=ds="..AL["Trainer"]};
				{ 12, "s30305", "23783", "=q1=Handful of Fel Iron Bolts", "=ds=#sr# 300", "=ds="..AL["Trainer"]};
				{ 13, "s30303", "23781", "=q1=Elemental Blasting Powder", "=ds=#sr# 300", "=ds="..AL["Trainer"]};
				{ 14, "s30304", "23782", "=q1=Fel Iron Casing", "=ds=#sr# 300", "=ds="..AL["Trainer"]};
				{ 15, "s19815", "16006", "=q1=Delicate Arcanite Converter", "=ds=#sr# 285", "=ds="..AL["Vendor"]};
				{ 16, "s19795", "16000", "=q1=Thorium Tube", "=ds=#sr# 275", "=ds="..AL["Trainer"]};
				{ 17, "s39895", "7191", "=q1=Fused Wiring", "=ds=#sr# 275", "=ds="..AL["Vendor"]};
				{ 18, "s19791", "15994", "=q1=Thorium Widget", "=ds=#sr# 260", "=ds="..AL["Trainer"]};
				{ 19, "s23071", "18631", "=q1=Truesilver Transformer", "=ds=#sr# 260", "=ds="..AL["Trainer"]};
				{ 20, "s19788", "15992", "=q1=Dense Blasting Powder", "=ds=#sr# 250", "=ds="..AL["Trainer"]};
				{ 21, "s12599", "10561", "=q1=Mithril Casing", "=ds=#sr# 215", "=ds="..AL["Trainer"]};
				{ 22, "s12591", "10560", "=q1=Unstable Trigger", "=ds=#sr# 200", "=ds="..AL["Trainer"]};
				{ 23, "s12589", "10559", "=q1=Mithril Tube", "=ds=#sr# 195", "=ds="..AL["Trainer"]};
				{ 24, "s12590", "10498", "=q1=Gyromatic Micro-Adjustor", "=ds=#sr# 175", "=ds="..AL["Trainer"]};
				{ 25, "s12585", "10505", "=q1=Solid Blasting Powder", "=ds=#sr# 175", "=ds="..AL["Trainer"]};
				{ 26, "s3961", "4389", "=q1=Gyrochronatom", "=ds=#sr# 170", "=ds="..AL["Trainer"]};
				{ 27, "s3958", "4387", "=q1=Iron Strut", "=ds=#sr# 160", "=ds="..AL["Trainer"]};
				{ 28, "s12584", "10558", "=q1=Gold Power Core", "=ds=#sr# 150", "=ds="..AL["Trainer"]};
				{ 29, "s3953", "4382", "=q1=Bronze Framework", "=ds=#sr# 145", "=ds="..AL["Trainer"]};
				{ 30, "s3942", "4375", "=q1=Whirring Bronze Gizmo", "=ds=#sr# 125", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, "s3945", "4377", "=q1=Heavy Blasting Powder", "=ds=#sr# 125", "=ds="..AL["Trainer"] };
				{ 2, "s3938", "4371", "=q1=Bronze Tube", "=ds=#sr# 105", "=ds="..AL["Trainer"] };
				{ 3, "s3973", "4404", "=q1=Silver Contact", "=ds=#sr# 90", "=ds="..AL["Trainer"] };
				{ 4, "s3929", "4364", "=q1=Coarse Blasting Powder", "=ds=#sr# 75", "=ds="..AL["Trainer"] };
				{ 5, "s3924", "4361", "=q1=Copper Tube", "=ds=#sr# 50", "=ds="..AL["Trainer"] };
				{ 6, "s3922", "4359", "=q1=Handful of Copper Bolts", "=ds=#sr# 30", "=ds="..AL["Trainer"] };
				{ 7, "s3918", "4357", "=q1=Rough Blasting Powder", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = ENGINEERING..": "..AL["Reagents"],
			module = moduleName, menu = "ENGINEERINGMENU", instance = "Engineering",
		};
	};

	AtlasLoot_Data["EngineeringWeapon"] = {
		["Normal"] = {
			{
				{ 1, "s100687", "71077", "=q4=Extreme-Impact Hole Puncher", "=ds=#sr# 525", "=ds="..BabbleZone["Molten Front"]};
				{ 2, "s84431", "59364", "=q3=Overpowered Chicken Splitter", "=ds=#sr# 525", "=ds="..AL["Trainer"]};
				{ 3, "s84432", "59367", "=q3=Kickback 5000", "=ds=#sr# 525", "=ds="..AL["Trainer"]};
				{ 4, "s84417", "59599", "=q3=Volatile Thunderstick", "=ds=#sr# 495", "=ds="..AL["Trainer"]};
				{ 5, "s84420", "59598", "=q3=Finely-Tuned Throat Needler", "=ds=#sr# 490", "=ds="..AL["Trainer"]};
				{ 6, "s56479", "41168", "=q4=Armor Plated Combat Shotgun", "=ds=#sr# 450", "=ds="..AL["Trainer"]};
				{ 7, "s60874", "44504", "=q4=Nesingwary 4000", "=ds=#sr# 450", "=ds="..AL["Trainer"]};
				{ 8, "s54353", "39688", "=q3=Mark \"S\" Boomstick", "=ds=#sr# 400", "=ds="..AL["Trainer"]};
				{ 9, "s41307", "32756", "=q4=Gyro-Balanced Khorium Destroyer", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
				{ 10, "s30315", "23748", "=q3=Ornate Khorium Rifle", "=ds=#sr# 375", "=ds="..AL["World Drop"]};
				{ 11, "s30314", "23747", "=q3=Felsteel Boomstick", "=ds=#sr# 360", "=ds="..AL["Drop"]};
				{ 12, "s30313", "23746", "=q2=Adamantite Rifle", "=ds=#sr# 350", "=ds="..AL["Vendor"]};
				{ 13, "s30312", "23742", "=q2=Fel Iron Musket", "=ds=#sr# 320", "=ds="..AL["Trainer"]};
				{ 14, "s22795", "18282", "=q4=Core Marksman Rifle", "=ds=#sr# 300", "=ds="..BabbleZone["Molten Core"]};
				{ 15, "s19833", "16007", "=q3=Flawless Arcanite Rifle", "=ds=#sr# 300", "=ds="..BabbleZone["Eastern Plaguelands"]};
				{ 16, "s19796", "16004", "=q3=Dark Iron Rifle", "=ds=#sr# 275", "=ds="..BabbleZone["Blackrock Depths"]};
				{ 17, "s19792", "15995", "=q2=Thorium Rifle", "=ds=#sr# 260", "=ds="..AL["Trainer"]};
				{ 18, "s12614", "10510", "=q2=Mithril Heavy-Bore Rifle", "=ds=#sr# 220", "=ds="..AL["World Drop"]};
				{ 19, "s12595", "10508", "=q2=Mithril Blunderbuss", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 20, "s3954", "4383", "=q2=Moonsight Rifle", "=ds=#sr# 145", "=ds="..AL["World Drop"]};
				{ 21, "s3949", "4379", "=q2=Silver-Plated Shotgun", "=ds=#sr# 130", "=ds="..AL["Trainer"]};
				{ 22, "s3939", "4372", "=q2=Lovingly Crafted Boomstick", "=ds=#sr# 120", "=ds="..BabbleZone["Thousand Needles"]};
				{ 23, "s3936", "4369", "=q2=Deadly Blunderbuss", "=ds=#sr# 105", "=ds="..AL["Trainer"]};
				{ 24, "s3925", "4362", "=q2=Rough Boomstick", "=ds=#sr# 50", "=ds="..AL["Trainer"]};
				{ 25, "s7430", "6219", "=q1=Arclight Spanner", "=ds=#sr# 50", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = ENGINEERING..": "..BabbleInventory["Weapon"],
			module = moduleName, menu = "ENGINEERINGMENU", instance = "Engineering",
		};
	};

	AtlasLoot_Data["Gnomish"] = {
		["Normal"] = {
			{
				{ 1, "s95705", "40727", "=q3=Gnomish Gravity Well", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 2, "s84413", "60216", "=q3=De-Weaponized Mechanical Companion", "=ds=#sr# 475", "=ds="..AL["Trainer"]};
				{ 3, "s56473", "40895", "=q3=Gnomish X-Ray Specs", "=ds=#sr# 425", "=ds="..AL["Trainer"]};
				{ 4, "s30575", "23829", "=q4=Gnomish Battle Goggles", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
				{ 5, "s30574", "23828", "=q4=Gnomish Power Goggles", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
				{ 6, "s30570", "23825", "=q3=Nigh-Invulnerability Belt", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 7, "s36955", "30544", "=q2=Ultrasafe Transporter - Toshley's Station", "=ds=#sr# 350"};
				{ 8, "s30569", "23835", "=q3=Gnomish Poultryizer", "=ds=#sr# 340", "=ds="..AL["Trainer"]};
				{ 9, "s30568", "23841", "=q1=Gnomish Flame Turret", "=ds=#sr# 325", "=ds="..AL["Trainer"]};
				{ 10, "s23096", "18645", "=q2=Gnomish Alarm-O-Bot", "=ds=#sr# 265", "=ds="..BabbleZone["Blackrock Depths"]};
				{ 11, "s23489", "18986", "=q2=Ultrasafe Transporter - Gadgetzan", "=ds=#sr# 260"};
				{ 12, "s23129", "18660", "=q2=World Enlarger", "=ds=#sr# 260", "=ds="..BabbleZone["Blackrock Depths"]};
				{ 13, "s12759", "10645", "=q1=Gnomish Death Ray", "=ds=#sr# 240", "=ds="..AL["Trainer"]};
				{ 14, "s12907", "10726", "=q2=Gnomish Mind Control Cap", "=ds=#sr# 235", "=ds="..AL["Trainer"]};
				{ 15, "s12906", "10725", "=q1=Gnomish Battle Chicken", "=ds=#sr# 230", "=ds="..AL["Trainer"]};
				{ 16, "s12905", "10724", "=q2=Gnomish Rocket Boots", "=ds=#sr# 225", "=ds="..AL["Trainer"]};
				{ 17, "s12903", "10721", "=q2=Gnomish Harm Prevention Belt", "=ds=#sr# 215", "=ds="..AL["Trainer"]};
				{ 18, "s12897", "10545", "=q2=Gnomish Goggles", "=ds=#sr# 210", "=ds="..AL["Trainer"]};
				{ 19, "s12902", "10720", "=q1=Gnomish Net-o-Matic Projector", "=ds=#sr# 210", "=ds="..AL["Trainer"]};
				{ 20, "s12899", "10716", "=q1=Gnomish Shrink Ray", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 21, "s12895", "10713", "=q1=Inlaid Mithril Cylinder Plans", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = GNOMISH,
			module = moduleName, menu = "ENGINEERINGMENU", instance = "Engineering",
		};
	};

	AtlasLoot_Data["Goblin"] = {
		["Normal"] = {
			{
				{ 1, "s95707", "63396", "=q1=Big Daddy", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 2, "s84412", "59597", "=q3=Personal World Destroyer", "=ds=#sr# 475", "=ds="..AL["Trainer"]};
				{ 3, "s56514", "42641", "=q1=Global Thermal Sapper Charge", "=ds=#sr# 425", "=ds="..AL["Trainer"]};
				{ 4, "s30565", "23838", "=q4=Foreman's Enchanted Helmet", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
				{ 5, "s30566", "23839", "=q4=Foreman's Reinforced Helmet", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
				{ 6, "s30563", "23836", "=q3=Goblin Rocket Launcher", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 7, "s36954", "30542", "=q2=Dimensional Ripper - Area 52", "=ds=#sr# 350"};
				{ 8, "s30560", "23827", "=q1=Super Sapper Charge", "=ds=#sr# 340", "=ds="..AL["Trainer"]};
				{ 9, "s30558", "23826", "=q1=The Bigger One", "=ds=#sr# 325", "=ds="..AL["Trainer"]};
				{ 10, "s23078", "18587", "=q1=Goblin Jumper Cables XL", "=ds=#sr# 265", "=ds="..BabbleZone["Blackrock Depths"]};
				{ 11, "s23486", "18984", "=q2=Dimensional Ripper - Everlook", "=ds=#sr# 260"};
				{ 12, "s12758", "10588", "=q2=Goblin Rocket Helmet", "=ds=#sr# 245", "=ds="..AL["Trainer"]};
				{ 13, "s12908", "10727", "=q1=Goblin Dragon Gun", "=ds=#sr# 240", "=ds="..AL["Trainer"]};
				{ 14, "s12754", "10586", "=q1=The Big One", "=ds=#sr# 235", "=ds="..AL["Trainer"]};
				{ 15, "s12755", "10587", "=q1=Goblin Bomb Dispenser", "=ds=#sr# 230", "=ds="..AL["Trainer"]};
				{ 16, "s8895", "7189", "=q2=Goblin Rocket Boots", "=ds=#sr# 225", "=ds="..AL["Trainer"]};
				{ 17, "s12718", "10543", "=q2=Goblin Construction Helmet", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 18, "s12717", "10542", "=q2=Goblin Mining Helmet", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 19, "s12716", "10577", "=q2=Goblin Mortar", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 20, "s12715", "10644", "=q1=Recipe: Goblin Rocket Fuel", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 21, "s12760", "10646", "=q1=Goblin Sapper Charge", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 22, "s13240", "10577", "=q1=The Mortar: Reloaded", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = GOBLIN,
			module = moduleName, menu = "ENGINEERINGMENU", instance = "Engineering",
		};
	};

	AtlasLoot_Data["EngineeringGem"] = {
		["Normal"] = {
			{
				{ 2, "", "59480", "=q3=Fractured Cogwheel", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 3, "", "59491", "=q3=Flashing Cogwheel", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 4, "", "68660", "=q3=Mystic Cogwheel", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 5, "", "59489", "=q3=Precise Cogwheel", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 6, "", "59479", "=q3=Quick Cogwheel", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 17, "", "59493", "=q3=Rigid Cogwheel", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 18, "", "59496", "=q3=Sparkling Cogwheel", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 19, "", "59478", "=q3=Smooth Cogwheel", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 20, "", "59477", "=q3=Subtle Cogwheel", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
			};
		};
		info = {
			name = ENGINEERING..": "..BabbleInventory["Cogwheel"],
			module = moduleName, menu = "ENGINEERINGMENU", instance = "Engineering",
		};
	};

	AtlasLoot_Data["EngineeringPetMount"] = {
		["Normal"] = {
			{
				{ 1, "s84413", "60216", "=q3=De-Weaponized Mechanical Companion", "=ds=#sr# 475", "=ds="..AL["Trainer"]};
				{ 2, "s84412", "59597", "=q3=Personal World Destroyer", "=ds=#sr# 475", "=ds="..AL["Trainer"]};
				{ 3, "s19793", "15996", "=q1=Lifelike Mechanical Toad", "=ds=#sr# 265", "=ds="..AL["World Drop"] };
				{ 4, "s26011", "21277", "=q1=Tranquil Mechanical Yeti", "=ds=#sr# 250", "=ds="..AL["Quest Reward"] };
				{ 5, "s15633", "11826", "=q1=Lil' Smoky", "=ds=#sr# 205", "=ds="..BabbleZone["Gnomeregan"] };
				{ 6, "s15628", "11825", "=q1=Pet Bombling", "=ds=#sr# 205", "=ds="..BabbleZone["Gnomeregan"] };
				{ 7, "s3928", "4401", "=q1=Mechanical Squirrel Box", "=ds=#sr# 75", "=ds="..AL["World Drop"] };
				{ 16, "s60866", "41508", "=q4=Mechano-Hog", "=ds=#sr# 450", "=ds="..BabbleFaction["Horde Expedition"].." - "..BabbleFaction["Exalted"] };
				{ 17, "s60867", "44413", "=q4=Mekgineer's Chopper", "=ds=#sr# 450", "=ds="..BabbleFaction["Alliance Vanguard"].." - "..BabbleFaction["Exalted"] };
				{ 18, "s44157", "34061", "=q4=Turbo-Charged Flying Machine Control", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
				{ 19, "s44155", "34060", "=q3=Flying Machine Control", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = ENGINEERING..": "..BabbleInventory["Pet"].." & "..BabbleInventory["Mount"],
			module = moduleName, menu = "ENGINEERINGMENU", instance = "Engineering",
		};
	};

	AtlasLoot_Data["EngineeringFirework"] = {
		["Normal"] = {
			{
				{ 19, "s30344", "23771", "=q1=Green Smoke Flare", "=ds=#sr# 335", "=ds="..AL["Vendor"]};
				{ 20, "s32814", "25886", "=q1=Purple Smoke Flare", "=ds=#sr# 335", "=ds="..AL["World Drop"]};
				{ 21, "s30341", "23768", "=q1=White Smoke Flare", "=ds=#sr# 335", "=ds="..AL["Vendor"]};
				{ 28, "s26443", "21570", "=q1=Firework Cluster Launcher", "=ds=#sr# 275", "=ds="..AL["Lunar Festival"]};
				{ 30, "s26426", "21714", "=q1=Large Blue Rocket Cluster", "=ds=#sr# 275", "=ds="..AL["Lunar Festival"]};
				{ 1, "s26427", "21716", "=q1=Large Green Rocket Cluster", "=ds=#sr# 275", "=ds="..AL["Lunar Festival"]};
				{ 2, "s26428", "21718", "=q1=Large Red Rocket Cluster", "=ds=#sr# 275", "=ds="..AL["Lunar Festival"]};
				{ 6, "s23507", "19026", "=q1=Snake Burst Firework", "=ds=#sr# 250", "=ds="..AL["Vendor"]};
				{ 7, "s26442", "21569", "=q1=Firework Launcher", "=ds=#sr# 225", "=ds="..AL["Lunar Festival"]};
				{ 8, "s26423", "21571", "=q1=Blue Rocket Cluster", "=ds=#sr# 225", "=ds="..AL["Lunar Festival"]};
				{ 9, "s26424", "21574", "=q1=Green Rocket Cluster", "=ds=#sr# 225", "=ds="..AL["Lunar Festival"]};
				{ 10, "s26425", "21576", "=q1=Red Rocket Cluster", "=ds=#sr# 225", "=ds="..AL["Lunar Festival"]};
				{ 18, "s26420", "21589", "=q1=Large Blue Rocket", "=ds=#sr# 175", "=ds="..AL["Lunar Festival"]};
				{ 19, "s26421", "21590", "=q1=Large Green Rocket", "=ds=#sr# 175", "=ds="..AL["Lunar Festival"]};
				{ 20, "s26422", "21592", "=q1=Large Red Rocket", "=ds=#sr# 175", "=ds="..AL["Lunar Festival"]};
				{ 27, "s23067", "9312", "=q1=Blue Firework", "=ds=#sr# 150", "=ds="..AL["Vendor"]};
				{ 28, "s23068", "9313", "=q1=Green Firework", "=ds=#sr# 150", "=ds="..AL["Vendor"]};
				{ 29, "s23066", "9318", "=q1=Red Firework", "=ds=#sr# 150", "=ds="..AL["Vendor"]};
				{ 1, "s26416", "21558", "=q1=Small Blue Rocket", "=ds=#sr# 125", "=ds="..AL["Lunar Festival"] };
				{ 2, "s26417", "21559", "=q1=Small Green Rocket", "=ds=#sr# 125", "=ds="..AL["Lunar Festival"] };
				{ 3, "s26418", "21557", "=q1=Small Red Rocket", "=ds=#sr# 125", "=ds="..AL["Lunar Festival"] };
			};
		};
		info = {
			name = ENGINEERING..": "..AL["Fireworks"],
			module = moduleName, menu = "ENGINEERINGMENU", instance = "Engineering",
		};
	};

		-----------------
		--- First Aid ---
		-----------------

	AtlasLoot_Data["FirstAid"] = {
		["Normal"] = {
			{
				{ 1, "s74558", "53051", "=q1=Dense Embersilk Bandage", "=ds=#sr# 525", "=ds="..AL["Trainer"] };
				{ 2, "s88893", "53051", "=q1=Dense Embersilk Bandage", "=ds=#sr# 525", "=ds="..AL["Trainer"] };
				{ 3, "s74557", "53050", "=q1=Heavy Embersilk Bandage", "=ds=#sr# 475", "=ds="..AL["Trainer"] };
				{ 4, "s74556", "53049", "=q1=Embersilk Bandage", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 5, "s45546", "34722", "=q1=Heavy Frostweave Bandage", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 6, "s45545", "34721", "=q1=Frostweave Bandage", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 7, "s27033", "21991", "=q1=Heavy Netherweave Bandage", "=ds=#sr# 330", "=ds="..AL["Trainer"] };
				{ 8, "s27032", "21990", "=q1=Netherweave Bandage", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{ 9, "s23787", "19440", "=q1=Powerful Anti-Venom", "=ds=#sr# 300", "=ds="..AL["Vendor"] };
				{ 10, "s18630", "14530", "=q1=Heavy Runecloth Bandage", "=ds=#sr# 290", "=ds="..AL["Trainer"] };
				{ 11, "s18629", "14529", "=q1=Runecloth Bandage", "=ds=#sr# 260", "=ds="..AL["Trainer"] };
				{ 12, "s10841", "8545", "=q1=Heavy Mageweave Bandage", "=ds=#sr# 240", "=ds="..AL["Trainer"] };
				{ 13, "s10840", "8544", "=q1=Mageweave Bandage", "=ds=#sr# 210", "=ds="..AL["Trainer"] };
				{ 14, "s7929", "6451", "=q1=Heavy Silk Bandage", "=ds=#sr# 180", "=ds="..AL["Trainer"] };
				{ 15, "s7928", "6450", "=q1=Silk Bandage", "=ds=#sr# 150", "=ds="..AL["Trainer"] };
				{ 16, "s7935", "6453", "=q1=Strong Anti-Venom", "=ds=#sr# 130", "=ds="..AL["Drop"] };
				{ 17, "s3278", "3531", "=q1=Heavy Wool Bandage", "=ds=#sr# 115", "=ds="..AL["Trainer"] };
				{ 18, "s3277", "3530", "=q1=Wool Bandage", "=ds=#sr# 80", "=ds="..AL["Trainer"] };
				{ 19, "s7934", "6452", "=q1=Anti-Venom", "=ds=#sr# 80", "=ds="..AL["Trainer"] };
				{ 20, "s3276", "2581", "=q1=Heavy Linen Bandage", "=ds=#sr# 40", "=ds="..AL["Trainer"] };
				{ 21, "s3275", "1251", "=q1=Linen Bandage", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = FIRSTAID,
			module = moduleName, menu = "CRAFTINGMENU"
		};
	};

		-------------------
		--- Inscription ---
		-------------------

	AtlasLoot_Data["Inscription_OffHand"] = {
		["Normal"] = {
			{
				{ 2, "s86643", "62236", "=q3=Battle Tome", "=ds=#sr# 510", "=ds="..AL["Trainer"] };
				{ 3, "s86642", "62235", "=q3=Divine Companion", "=ds=#sr# 510", "=ds="..AL["Trainer"] };
				{ 4, "s86641", "62234", "=q3=Dungeoneering Guide", "=ds=#sr# 510", "=ds="..AL["Trainer"] };
				{ 5, "s86616", "62231", "=q3=Book of Blood", "=ds=#sr# 475", "=ds="..AL["Trainer"] };
				{ 6, "s86640", "62233", "=q3=Lord Rottington's Pressed Wisp Book", "=ds=#sr# 475", "=ds="..AL["Trainer"] };
				{ 7, "s59498", "44210", "=q4=Faces of Doom", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 8, "s59497", "38322", "=q4=Iron-bound Tome", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 9, "s64051", "45854", "=q3=Rituals of the New Moon", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 10, "s64053", "45849", "=q3=Twilight Tome", "=ds=#sr# 350", "=ds="..AL["Trainer"]};
				{ 11, "s59496", "43667", "=q3=Book of Clever Tricks", "=ds=#sr# 325", "=ds="..AL["Trainer"] };
				{ 17, "s59495", "43666", "=q3=Hellfire Tome", "=ds=#sr# 325", "=ds="..AL["Trainer"] };
				{ 18, "s59494", "43664", "=q3=Manual of Clouds", "=ds=#sr# 275", "=ds="..AL["Trainer"] };
				{ 19, "s59493", "43663", "=q3=Stormbound Tome", "=ds=#sr# 275", "=ds="..AL["Trainer"] };
				{ 20, "s59490", "43661", "=q3=Book of Stars", "=ds=#sr# 225", "=ds="..AL["Trainer"] };
				{ 21, "s59489", "43660", "=q3=Fire Eater's Guide", "=ds=#sr# 225", "=ds="..AL["Trainer"] };
				{ 22, "s59486", "43657", "=q3=Royal Guide of Escape Routes", "=ds=#sr# 175", "=ds="..AL["Trainer"] };
				{ 23, "s59484", "43656", "=q3=Tome of Kings", "=ds=#sr# 175", "=ds="..AL["Trainer"] };
				{ 24, "s59478", "43655", "=q3=Book of Survival", "=ds=#sr# 125", "=ds="..AL["Trainer"] };
				{ 25, "s59475", "43654", "=q3=Tome of the Dawn", "=ds=#sr# 125", "=ds="..AL["Trainer"] };
				{ 26, "s58565", "43515", "=q3=Mystic Tome", "=ds=#sr# 85", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = INSCRIPTION..": "..AL["Off-Hand Items"],
			module = moduleName, menu = "INSCRIPTIONMENU"
		};
	};
	
	AtlasLoot_Data["Inscription_RelicsEnchants"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Relics"], "" };
				{ 2, "s99547", "75079", "=q3=Vicious Charm of Triumph", "=ds=#sr# 520", "=ds="..AL["Trainer"] };
				{ 3, "s99548", "75066", "=q3=Vicious Eyeball of Dominance", "=ds=#sr# 520", "=ds="..AL["Trainer"] };
				{ 4, "s99549", "75069", "=q3=Vicious Jawbone of Conquest", "=ds=#sr# 520", "=ds="..AL["Trainer"] };
				{ 6, "s86650", "62243", "=q3=Notched Jawbone", "=ds=#sr# 515", "=ds="..AL["Trainer"] };
				{ 7, "s86653", "62245", "=q3=Silver Inlaid Leaf", "=ds=#sr# 515", "=ds="..AL["Trainer"] };
				{ 8, "s86652", "62244", "=q3=Tattooed Eyeball", "=ds=#sr# 515", "=ds="..AL["Trainer"] };
				{ 10, "s86649", "62242", "=q3=Runed Dragonscale", "=ds=#sr# 505", "=ds="..AL["Trainer"] };
				{ 11, "s86647", "62240", "=q3=Etched Horn", "=ds=#sr# 480", "=ds="..AL["Trainer"] };
				{ 12, "s86648", "62241", "=q3=Manual of the Planes", "=ds=#sr# 480", "=ds="..AL["Trainer"] };
				{ 16, 0, "INV_Box_01", "=q6="..AL["Shoulder Enchants"], "" };
				{ 17, "s86403", "INV_Misc_MastersInscription", "=ds=Felfire Inscription", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 18, "s86402", "INV_Misc_MastersInscription", "=ds=Inscription of the Earthen Prince", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 19, "s86401", "INV_Misc_MastersInscription", "=ds=Lionsmane Inscription", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 20, "s86375", "INV_Misc_MastersInscription", "=ds=Swiftsteel Inscription", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 22, "s61117", "INV_Misc_MastersInscription", "=ds=Master's Inscription of the Axe", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 23, "s61118", "INV_Misc_MastersInscription", "=ds=Master's Inscription of the Crag", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 24, "s61119", "INV_Misc_MastersInscription", "=ds=Master's Inscription of the Pinnacle", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 25, "s61120", "INV_Misc_MastersInscription", "=ds=Master's Inscription of the Storm", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = INSCRIPTION..": "..AL["Relics/Shoulder Enchants"],
			module = moduleName, menu = "INSCRIPTIONMENU"
		};
	};

	AtlasLoot_Data["Inscription_Scrolls"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Darkmoon Faire Card"], "" };
				{ 2, "s86615", "61987", "=q3=Darkmoon Card of the Destruction", "=ds=#sr# 525", "=ds="..AL["Trainer"] };
				{ 3, "s86609", "60838", "=q1=Mysterious Fortune Card", "=ds=#sr# 450", "=ds="..AL["Trainer"] };
				{ 4, "s59504", "44318", "=q3=Darkmoon Card of the North", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 5, "s59503", "44317", "=q3=Greater Darkmoon Card", "=ds=#sr# 325", "=ds="..AL["Trainer"] };
				{ 6, "s59502", "44316", "=q3=Darkmoon Card", "=ds=#sr# 275", "=ds="..AL["Trainer"] };
				{ 17, "s59491", "44163", "=q1=Shadowy Tarot", "=ds=#sr# 225", "=ds="..AL["Trainer"] };
				{ 18, "s59487", "44161", "=q1=Arcane Tarot", "=ds=#sr# 175", "=ds="..AL["Trainer"] };
				{ 19, "s48247", "37168", "=q1=Mysterious Tarot", "=ds=#sr# 125", "=ds="..AL["Trainer"] };
				{ 20, "s59480", "44142", "=q1=Strange Tarot", "=ds=#sr# 85", "=ds="..AL["Trainer"] };
				{ 8, 0, "INV_Box_01", "=q6="..AL["Runescrolls"], "" };
				{ 9, "s85785", "62251", "=q1=Runescroll of Fortitude II", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 24, "s69385", "49632", "=q1=Runescroll of Fortitude", "=ds=#sr# 440", "=ds="..AL["Trainer"] };
				{ 11, 0, "INV_Box_01", "=q6="..AL["Recall"].." "..AL["Scrolls"], "" };
				{ 12, "s60337", "44315", "=q1=Scroll of Recall III", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 13, "s60336", "44314", "=q1=Scroll of Recall II", "=ds=#sr# 200", "=ds="..AL["Trainer"] };
				{ 27, "s48248", "37118", "=q1=Scroll of Recall", "=ds=#sr# 35", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Agility"].." "..AL["Scrolls"], "" };
				{ 2, "s89370", "63303", "=q1=Scroll of Agility IX", "=ds=#sr# 470", "=ds="..AL["Trainer"] };
				{ 3, "s58483", "43464", "=q1=Scroll of Agility VIII", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 4, "s58482", "43463", "=q1=Scroll of Agility VII", "=ds=#sr# 370", "=ds="..AL["Trainer"] };
				{ 5, "s58481", "33457", "=q1=Scroll of Agility VI", "=ds=#sr# 310", "=ds="..AL["Trainer"] };
				{ 6, "s58480", "27498", "=q1=Scroll of Agility V", "=ds=#sr# 270", "=ds="..AL["Trainer"] };
				{ 17, "s58478", "10309", "=q1=Scroll of Agility IV", "=ds=#sr# 225", "=ds="..AL["Trainer"] };
				{ 18, "s58476", "4425", "=q1=Scroll of Agility III", "=ds=#sr# 175", "=ds="..AL["Trainer"] };
				{ 19, "s58473", "1477", "=q1=Scroll of Agility II", "=ds=#sr# 85", "=ds="..AL["Trainer"] };
				{ 20, "s58472", "3012", "=q1=Scroll of Agility", "=ds=#sr# 15", "=ds="..AL["Trainer"] };
				{ 8, 0, "INV_Box_01", "=q6="..AL["Intellect"].." "..AL["Scrolls"], "" };
				{ 9, "s89368", "63305", "=q1=Scroll of Intellect IX", "=ds=#sr# 445", "=ds="..AL["Trainer"] };
				{ 10, "s50604", "37092", "=q1=Scroll of Intellect VIII", "=ds=#sr# 410", "=ds="..AL["Trainer"] };
				{ 11, "s50603", "37091", "=q1=Scroll of Intellect VII", "=ds=#sr# 360", "=ds="..AL["Trainer"] };
				{ 12, "s50602", "33458", "=q1=Scroll of Intellect VI", "=ds=#sr# 310", "=ds="..AL["Trainer"] };
				{ 13, "s50601", "27499", "=q1=Scroll of Intellect V", "=ds=#sr# 260", "=ds="..AL["Trainer"] };
				{ 24, "s50600", "10308", "=q1=Scroll of Intellect IV", "=ds=#sr# 215", "=ds="..AL["Trainer"] };
				{ 25, "s50599", "4419", "=q1=Scroll of Intellect III", "=ds=#sr# 165", "=ds="..AL["Trainer"] };
				{ 26, "s50598", "2290", "=q1=Scroll of Intellect II", "=ds=#sr# 75", "=ds="..AL["Trainer"] };
				{ 27, "s48114", "955", "=q1=Scroll of Intellect", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Spirit"].." "..AL["Scrolls"], "" };
				{ 2, "s89371", "63307", "=q1=Scroll of Spirit IX", "=ds=#sr# 455", "=ds="..AL["Trainer"] };
				{ 3, "s50611", "37098", "=q1=Scroll of Spirit VIII", "=ds=#sr# 405", "=ds="..AL["Trainer"] };
				{ 4, "s50610", "37097", "=q1=Scroll of Spirit VII", "=ds=#sr# 355", "=ds="..AL["Trainer"] };
				{ 5, "s50609", "33460", "=q1=Scroll of Spirit VI", "=ds=#sr# 295", "=ds="..AL["Trainer"] };
				{ 6, "s50608", "27501", "=q1=Scroll of Spirit V", "=ds=#sr# 255", "=ds="..AL["Trainer"] };
				{ 17, "s50607", "10306", "=q1=Scroll of Spirit IV", "=ds=#sr# 210", "=ds="..AL["Trainer"] };
				{ 18, "s50606", "4424", "=q1=Scroll of Spirit III", "=ds=#sr# 160", "=ds="..AL["Trainer"] };
				{ 19, "s50605", "1712", "=q1=Scroll of Spirit II", "=ds=#sr# 75", "=ds="..AL["Trainer"] };
				{ 20, "s48116", "1181", "=q1=Scroll of Spirit", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
				{ 8, 0, "INV_Box_01", "=q6="..AL["Stamina"].." "..AL["Scrolls"], "" };
				{ 9, "s89372", "63306", "=q1=Scroll of Stamina IX", "=ds=#sr# 460", "=ds="..AL["Trainer"] };
				{ 10, "s50620", "37094", "=q1=Scroll of Stamina VIII", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 11, "s50619", "37093", "=q1=Scroll of Stamina VII", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 12, "s50618", "33461", "=q1=Scroll of Stamina VI", "=ds=#sr# 290", "=ds="..AL["Trainer"] };
				{ 13, "s50617", "27502", "=q1=Scroll of Stamina V", "=ds=#sr# 250", "=ds="..AL["Trainer"] };
				{ 24, "s50616", "10307", "=q1=Scroll of Stamina IV", "=ds=#sr# 205", "=ds="..AL["Trainer"] };
				{ 25, "s50614", "4422", "=q1=Scroll of Stamina III", "=ds=#sr# 155", "=ds="..AL["Trainer"] };
				{ 26, "s50612", "1711", "=q1=Scroll of Stamina II", "=ds=#sr# 75", "=ds="..AL["Trainer"] };
				{ 27, "s45382", "1180", "=q1=Scroll of Stamina", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Strength"].." "..AL["Scrolls"], "" };
				{ 2, "s89369", "63304", "=q1=Scroll of Strength IX", "=ds=#sr# 465", "=ds="..AL["Trainer"] };
				{ 3, "s58491", "43466", "=q1=Scroll of Strength VIII", "=ds=#sr# 415", "=ds="..AL["Trainer"] };
				{ 4, "s58490", "43465", "=q1=Scroll of Strength VII", "=ds=#sr# 365", "=ds="..AL["Trainer"] };
				{ 5, "s58489", "33462", "=q1=Scroll of Strength VI", "=ds=#sr# 305", "=ds="..AL["Trainer"] };
				{ 6, "s58488", "27503", "=q1=Scroll of Strength V", "=ds=#sr# 265", "=ds="..AL["Trainer"] };
				{ 17, "s58487", "10310", "=q1=Scroll of Strength IV", "=ds=#sr# 220", "=ds="..AL["Trainer"] };
				{ 18, "s58486", "4426", "=q1=Scroll of Strength III", "=ds=#sr# 170", "=ds="..AL["Trainer"] };
				{ 19, "s58485", "2289", "=q1=Scroll of Strength II", "=ds=#sr# 80", "=ds="..AL["Trainer"] };
				{ 20, "s58484", "954", "=q1=Scroll of Strength", "=ds=#sr# 15", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = INSCRIPTION..": "..AL["Scrolls"].."/"..AL["Darkmoon Faire Card"],
			module = moduleName, menu = "INSCRIPTIONMENU"
		};
	};

	AtlasLoot_Data["Inscription_Misc"] = {
		["Normal"] = {
			{
				{ 1, "s86654", "63276", "=q1=Forged Documents", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 2, "s86646", "63246", "=q1=Origami Beetle", "=ds=#sr# 500", "=ds="..AL["World Drop"] };
				{ 3, "s86645", "62238", "=q1=Origami Rock", "=ds=#sr# 490", "=ds="..AL["World Drop"] };
				{ 4, "s86644", "62239", "=q1=Origami Slime", "=ds=#sr# 480", "=ds="..AL["World Drop"] };
				{ 16, "s92027", "63388", "=q1=Dust of Disappearance", "=ds=#sr# 475", "=ds="..AL["Trainer"] };
				{ 17, "s89367", "62237", "=q1=Adventurer's Journal", "=ds=#sr# 460", "=ds="..AL["Trainer"] };
				{ 18, "s59387", "43850", "=q1=Certificate of Ownership", "=ds=#sr# 200", "=ds="..AL["Trainer"] };
				{ 19, "s92026", "64670", "=q1=Vanishing Powder", "=ds=#sr# 75", "=ds="..AL["Trainer"] };
				{ 20, "s52739", "38682", "=q1=Enchanting Vellum", "=ds=#sr# 35", "=ds="..AL["Trainer"] };
				{ 6, 0, "INV_Box_01", "=q6="..AL["Reagents"], "" };
				{ 7, "s86005", "61981", "=q2=Inferno Ink", "=ds=#sr# 475", "=ds="..AL["Trainer"] };
				{ 8, "s86004", "61978", "=q1=Blackfallow Ink", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 9, "s57716", "43127", "=q2=Snowfall Ink", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
				{ 10, "s57715", "43126", "=q1=Ink of the Sea", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 11, "s57714", "43125", "=q2=Darkflame Ink", "=ds=#sr# 325", "=ds="..AL["Trainer"] };
				{ 12, "s57713", "43124", "=q1=Ethereal Ink", "=ds=#sr# 290", "=ds="..AL["Trainer"] };
				{ 13, "s57712", "43123", "=q2=Ink of the Sky", "=ds=#sr# 275", "=ds="..AL["Trainer"] };
				{ 14, "s57711", "43122", "=q1=Shimmering Ink", "=ds=#sr# 250", "=ds="..AL["Trainer"] };
				{ 15, "s57710", "43121", "=q2=Fiery Ink", "=ds=#sr# 225", "=ds="..AL["Trainer"] };
				{ 22, "s57709", "43120", "=q1=Celestial Ink", "=ds=#sr# 200", "=ds="..AL["Trainer"] };
				{ 23, "s57708", "43119", "=q2=Royal Ink", "=ds=#sr# 175", "=ds="..AL["Trainer"] };
				{ 24, "s57707", "43118", "=q1=Jadefire Ink", "=ds=#sr# 150", "=ds="..AL["Trainer"] };
				{ 25, "s57706", "43117", "=q2=Dawnstar Ink", "=ds=#sr# 125", "=ds="..AL["Trainer"] };
				{ 26, "s57704", "43116", "=q1=Lion's Ink", "=ds=#sr# 100", "=ds="..AL["Trainer"] };
				{ 27, "s57703", "43115", "=q2=Hunter's Ink", "=ds=#sr# 85", "=ds="..AL["Trainer"] };
				{ 28, "s53462", "39774", "=q1=Midnight Ink", "=ds=#sr# 75", "=ds="..AL["Trainer"] };
				{ 29, "s52843", "39469", "=q1=Moonglow Ink", "=ds=#sr# 35", "=ds="..AL["Trainer"] };
				{ 30, "s52738", "37101", "=q1=Ivory Ink", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
				
				--[[ Not really a recipe :\
				{ 14, "s52175", "INV_Misc_Book_11", "=ds=Decipher", "=ds="..AL["Trainer"] };
				]]--
			};
		};
		info = {
			name = INSCRIPTION..": "..BabbleInventory["Miscellaneous"],
			module = moduleName, menu = "INSCRIPTIONMENU"
		};
	};

	AtlasLoot_Data["Inscription_DeathKnight"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Prime Glyph"], "" };
				{ 2, "s57214", "43542", "=q1=Glyph of Death and Decay", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 3, "s64266", "45804", "=q1=Glyph of Death Coil", "=ds=#sr# 275", "=ds="..AL["Trainer"] };
				{ 4, "s59340", "43827", "=q1=Glyph of Death Strike", "=ds=#sr# 340", "=ds="..AL["Trainer"] };
				{ 5, "s57216", "43543", "=q1=Glyph of Frost Strike", "=ds=#sr# 270", "=ds="..AL["Trainer"] };
				{ 6, "s57208", "43534", "=q1=Glyph of Heart Strike", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 7, "s64300", "45806", "=q1=Glyph of Howling Blast", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 17, "s57219", "43546", "=q1=Glyph of Icy Touch", "=ds=#sr# 280", "=ds="..AL["Trainer"] };
				{ 18, "s57220", "43547", "=q1=Glyph of Obliterate", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 19, "s57222", "43549", "=q1=Glyph of Raise Dead", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 20, "s57223", "43550", "=q1=Glyph of Rune Strike", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 21, "s57224", "43551", "=q1=Glyph of Scourge Strike", "=ds=#sr# 330", "=ds="..AL["Trainer"] };
				{ 9, 0, "INV_Box_01", "=q6="..AL["Minor Glyph"], "" };
				{ 10, "s57209", "43535", "=q1=Glyph of Blood Tap", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 11, "s57215", "43539", "=q1=Glyph of Death's Embrace", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 12, "s57217", "43544", "=q1=Glyph of Horn of Winter", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 25, "s57229", "43671", "=q1=Glyph of Path of Frost", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 26, "s57228", "43673", "=q1=Glyph of Raise Ally", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 27, "s57230", "43672", "=q1=Glyph of Resilient Grip", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
			};
			{ 
				{ 1, 0, "INV_Box_01", "=q6="..AL["Major Glyph"], "" };
				{ 2, "s57207", "43533", "=q1=Glyph of Anti-Magic Shell", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 3, "s59339", "43826", "=q1=Glyph of Blood Boil", "=ds=#sr# 320", "=ds="..AL["Trainer"] };
				{ 4, "s57210", "43536", "=q1=Glyph of Bone Shield", "=ds=#sr# 265", "=ds="..AL["Trainer"] };
				{ 5, "s57211", "43537", "=q1=Glyph of Chains of Ice", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 6, "s64297", "45799", "=q1=Glyph of Dancing Rune Weapon", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 7, "s96284", "68793", "=q1=Glyph of Dark Succor", "=ds=#sr# 280", "=ds="..AL["Trainer"] };
				{ 8, "s57213", "43541", "=q1=Glyph of Death Grip", "=ds=#sr# 285", "=ds="..AL["Trainer"] };
				{ 17, "s64298", "45800", "=q1=Glyph of Hungering Cold", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 18, "s57221", "43548", "=q1=Glyph of Pestilence", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{ 19, "s57226", "43553", "=q1=Glyph of Pillar of Frost", "=ds=#sr# 305", "=ds="..AL["Trainer"] };
				{ 20, "s59338", "43825", "=q1=Glyph of Rune Tap", "=ds=#sr# 310", "=ds="..AL["Trainer"] };
				{ 21, "s57225", "43552", "=q1=Glyph of Strangulate", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
				{ 22, "s57227", "43554", "=q1=Glyph of Vampiric Blood", "=ds=#sr# 345", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = INSCRIPTION..": "..AL["Glyph"].." - "..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"],
			module = moduleName, menu = "INSCRIPTIONMENU"
		};
	};

	AtlasLoot_Data["Inscription_Druid"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Prime Glyph"], "" };
				{ 2, "s64268", "45601", "=q1=Glyph of Berserk", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 3, "s56948", "40919", "=q1=Glyph of Insect Swarm", "=ds=#sr# 150", "=ds="..AL["Trainer"] };
				{ 4, "s94402", "67484", "=q1=Glyph of Lacerate", "=ds=#sr# 330", "=ds="..AL["Trainer"] };
				{ 5, "s56949", "40915", "=q1=Glyph of Lifebloom", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 6, "s56950", "40900", "=q1=Glyph of Mangle", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 7, "s56951", "40923", "=q1=Glyph of Moonfire", "=ds=#sr# 130", "=ds="..AL["Trainer"] };
				{ 8, "s56954", "40912", "=q1=Glyph of Regrowth", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 9, "s56955", "40913", "=q1=Glyph of Rejuvenation", "=ds=#sr# 80", "=ds="..AL["Trainer"] };
				{ 17, "s56956", "40902", "=q1=Glyph of Rip", "=ds=#sr# 200", "=ds="..AL["Trainer"] };
				{ 18, "s64307", "45604", "=q1=Glyph of Savage Roar", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 19, "s56957", "40901", "=q1=Glyph of Shred", "=ds=#sr# 260", "=ds="..AL["Trainer"] };
				{ 20, "s56959", "40916", "=q1=Glyph of Starfire", "=ds=#sr# 220", "=ds="..AL["Trainer"] };
				{ 21, "s64313", "45603", "=q1=Glyph of Starsurge", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 22, "s56960", "40906", "=q1=Glyph of Swiftmend", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 23, "s94401", "67487", "=q1=Glyph of Tiger's Fury", "=ds=#sr# 120", "=ds="..AL["Trainer"] };
				{ 24, "s56963", "40922", "=q1=Glyph of Wrath", "=ds=#sr# 85", "=ds="..AL["Trainer"] };
				{ 11, 0, "INV_Box_01", "=q6="..AL["Minor Glyph"], "" };
				{ 12, "s58286", "43316", "=q1=Glyph of Aquatic Form", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 13, "s58287", "43334", "=q1=Glyph of Challenging Roar", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 14, "s59315", "43674", "=q1=Glyph of Dash", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 15, "s58296", "43335", "=q1=Glyph of Mark of the Wild", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 27, "s95215", "68039", "=q1=Glyph of the Treant", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 28, "s56965", "44922", "=q1=Glyph of Typhoon", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 29, "s58288", "43331", "=q1=Glyph of Unburdened Rebirth", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Major Glyph"], "" };
				{ 2, "s64256", "45623", "=q1=Glyph of Barkskin", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 3, "s48121", "40924", "=q1=Glyph of Entangling Roots", "=ds=#sr# 100", "=ds="..AL["Trainer"] };
				{ 4, "s94403", "67485", "=q1=Glyph of Faerie Fire", "=ds=#sr# 120", "=ds="..AL["Trainer"] };
				{ 5, "s94404", "67486", "=q1=Glyph of Feral Charge", "=ds=#sr# 150", "=ds="..AL["Trainer"] };
				{ 6, "s67600", "48720", "=q1=Glyph of Ferocious Bite", "=ds=#sr# 100", "=ds="..AL["Trainer"] };
				{ 7, "s62162", "44928", "=q1=Glyph of Focus", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
				{ 8, "s56943", "40896", "=q1=Glyph of Frenzied Regeneration", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 9, "s56945", "40914", "=q1=Glyph of Healing Touch", "=ds=#sr# 115", "=ds="..AL["Trainer"] };
				{ 10, "s56946", "40920", "=q1=Glyph of Hurricane", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 17, "s56947", "40908", "=q1=Glyph of Innervate", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 18, "s56961", "40897", "=q1=Glyph of Maul", "=ds=#sr# 90", "=ds="..AL["Trainer"] };
				{ 19, "s64258", "45622", "=q1=Glyph of Monsoon", "=ds=#sr# 250", "=ds="..AL["Trainer"] };
				{ 20, "s56952", "40903", "=q1=Glyph of Pounce", "=ds=#sr# 310", "=ds="..AL["Trainer"] };
				{ 21, "s56953", "40909", "=q1=Glyph of Rebirth", "=ds=#sr# 170", "=ds="..AL["Trainer"] };
				{ 22, "s56944", "40899", "=q1=Glyph of Solar Beam", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 23, "s56958", "40921", "=q1=Glyph of Starfall", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 24, "s58289", "43332", "=q1=Glyph of Thorns", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 25, "s64270", "45602", "=q1=Glyph of Wild Growth", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
			};
		};
		info = {
			name = INSCRIPTION..": "..AL["Glyph"].." - "..LOCALIZED_CLASS_NAMES_MALE["DRUID"],
			module = moduleName, menu = "INSCRIPTIONMENU"
		};
	};

	AtlasLoot_Data["Inscription_Hunter"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Prime Glyph"], "" };
				{ 2, "s56994", "42897", "=q1=Glyph of Aimed Shot", "=ds=#sr# 175", "=ds="..AL["Trainer"] };
				{ 3, "s56995", "42898", "=q1=Glyph of Arcane Shot", "=ds=#sr# 100", "=ds="..AL["Trainer"] };
				{ 4, "s64271", "45625", "=q1=Glyph of Chimera Shot", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 5, "s64273", "45731", "=q1=Glyph of Explosive Shot", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 6, "s57012", "42915", "=q1=Glyph of Kill Command", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 17, "s64304", "45732", "=q1=Glyph of Kill Shot", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 18, "s57008", "42911", "=q1=Glyph of Rapid Fire", "=ds=#sr# 315", "=ds="..AL["Trainer"] };
				{ 19, "s57009", "42912", "=q1=Glyph of Serpent Sting", "=ds=#sr# 90", "=ds="..AL["Trainer"] };
				{ 20, "s57011", "42914", "=q1=Glyph of Steady Shot", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 21, "s57006", "42909", "=q1=Glyph of the Dazzled Prey", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
				{ 8, 0, "INV_Box_01", "=q6="..AL["Minor Glyph"], "" };
				{ 9, "s58297", "43355", "=q1=Glyph of Aspect of the Pack", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 10, "s58302", "43351", "=q1=Glyph of Feign Death", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 11, "s58301", "43350", "=q1=Glyph of Lesser Proportion", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 24, "s58299", "43338", "=q1=Glyph of Revive Pet", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 25, "s58298", "43356", "=q1=Glyph of Scare Beast", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Major Glyph"], "" };
				{ 2, "s56999", "42902", "=q1=Glyph of Bestial Wrath", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 3, "s56998", "42901", "=q1=Glyph of Concussive Shot", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 4, "s57000", "42903", "=q1=Glyph of Deterrence", "=ds=#sr# 200", "=ds="..AL["Trainer"] };
				{ 5, "s57001", "42904", "=q1=Glyph of Disengage", "=ds=#sr# 225", "=ds="..AL["Trainer"] };
				{ 6, "s57002", "42905", "=q1=Glyph of Freezing Trap", "=ds=#sr# 260", "=ds="..AL["Trainer"] };
				{ 7, "s57003", "42906", "=q1=Glyph of Ice Trap", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 8, "s57005", "42908", "=q1=Glyph of Immolation Trap", "=ds=#sr# 130", "=ds="..AL["Trainer"] };
				{ 9, "s64253", "45733", "=q1=Glyph of Master's Call", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 17, "s56997", "42900", "=q1=Glyph of Mending", "=ds=#sr# 115", "=ds="..AL["Trainer"] };
				{ 18, "s57004", "42907", "=q1=Glyph of Misdirection", "=ds=#sr# 80", "=ds="..AL["Trainer"] };
				{ 19, "s64246", "45735", "=q1=Glyph of Raptor Strike", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 20, "s64249", "45734", "=q1=Glyph of Scatter Shot", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 21, "s57007", "42910", "=q1=Glyph of Silencing Shot", "=ds=#sr# 150", "=ds="..AL["Trainer"] };
				{ 22, "s57010", "42913", "=q1=Glyph of Snake Trap", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 23, "s56996", "42899", "=q1=Glyph of Trap Launcher", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 24, "s57014", "42917", "=q1=Glyph of Wyvern Sting", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
			};
		};
		info = {
			name = INSCRIPTION..": "..AL["Glyph"].." - "..LOCALIZED_CLASS_NAMES_MALE["HUNTER"],
			module = moduleName, menu = "INSCRIPTIONMENU"
		};
	};

	AtlasLoot_Data["Inscription_Mage"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Prime Glyph"], "" };
				{ 2, "s64276", "45738", "=q1=Glyph of Arcane Barrage", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 3, "s56991", "44955", "=q1=Glyph of Arcane Blast", "=ds=#sr# 315", "=ds="..AL["Trainer"] };
				{ 4, "s56971", "42735", "=q1=Glyph of Arcane Missiles", "=ds=#sr# 115", "=ds="..AL["Trainer"] };
				{ 5, "s56988", "42753", "=q1=Glyph of Cone of Cold", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 6, "s64274", "45736", "=q1=Glyph of Deep Freeze", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 7, "s56975", "42739", "=q1=Glyph of Fireball", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 8, "s56977", "42742", "=q1=Glyph of Frostbolt", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 17, "s61677", "44684", "=q1=Glyph of Frostfire", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 18, "s56980", "42745", "=q1=Glyph of Ice Lance", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
				{ 19, "s94000", "63539", "=q1=Glyph of Living Bomb", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 20, "s56984", "42749", "=q1=Glyph of Mage Armor", "=ds=#sr# 325", "=ds="..AL["Trainer"] };
				{ 21, "s56986", "42751", "=q1=Glyph of Molten Armor", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 22, "s56978", "42743", "=q1=Glyph of Pyroblast", "=ds=#sr# 90", "=ds="..AL["Trainer"] };
				{ 10, 0, "INV_Box_01", "=q6="..AL["Minor Glyph"], "" };
				{ 11, "s58303", "43339", "=q1=Glyph of Arcane Brilliance", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 12, "s95710", "63416", "=q1=Glyph of Armors", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 13, "s58306", "43359", "=q1=Glyph of Conjuring", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 14, "s64314", "45739", "=q1=Glyph of Mirror Image", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 26, "s58308", "43364", "=q1=Glyph of Slow Fall", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 27, "s58307", "43360", "=q1=Glyph of the Monkey", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 28, "s58310", "43361", "=q1=Glyph of the Penguin", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Major Glyph"], "" };
				{ 2, "s56972", "42736", "=q1=Glyph of Arcane Power", "=ds=#sr# 335", "=ds="..AL["Trainer"] };
				{ 3, "s56990", "44920", "=q1=Glyph of Blast Wave", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 4, "s56973", "42737", "=q1=Glyph of Blink", "=ds=#sr# 130", "=ds="..AL["Trainer"] };
				{ 5, "s56989", "42754", "=q1=Glyph of Dragon's Breath", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 6, "s56974", "42738", "=q1=Glyph of Evocation", "=ds=#sr# 155", "=ds="..AL["Trainer"] };
				{ 7, "s56976", "42741", "=q1=Glyph of Frost Nova", "=ds=#sr# 80", "=ds="..AL["Trainer"] };
				{ 8, "s98398", "69773", "=q1=Glyph of Frost Armor", "=ds=#sr# 430", "=ds="..GetSpellInfo(61177) };
				{ 17, "s64257", "45740", "=q1=Glyph of Ice Barrier", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 18, "s56979", "42744", "=q1=Glyph of Ice Block", "=ds=#sr# 225", "=ds="..AL["Trainer"] };
				{ 19, "s56981", "42746", "=q1=Glyph of Icy Veins", "=ds=#sr# 175", "=ds="..AL["Trainer"] };
				{ 20, "s56983", "42748", "=q1=Glyph of Invisibility", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 21, "s71101", "50045", "=q1=Glyph of Mana Shield", "=ds=#sr# 250", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 22, "s56987", "42752", "=q1=Glyph of Polymorph", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 23, "s64275", "45737", "=q1=Glyph of Slow", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
			};
		};
		info = {
			name = INSCRIPTION..": "..AL["Glyph"].." - "..LOCALIZED_CLASS_NAMES_MALE["MAGE"],
			module = moduleName, menu = "INSCRIPTIONMENU"
		};
	};

	AtlasLoot_Data["Inscription_Paladin"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Prime Glyph"], "" };
				{ 2, "s57024", "41098", "=q1=Glyph of Crusader Strike", "=ds=#sr# 230", "=ds="..AL["Trainer"] };
				{ 3, "s57029", "41106", "=q1=Glyph of Divine Favor", "=ds=#sr# 105", "=ds="..AL["Trainer"] };
				{ 4, "s57025", "41103", "=q1=Glyph of Exorcism", "=ds=#sr# 265", "=ds="..AL["Trainer"] };
				{ 5, "s64278", "45742", "=q1=Glyph of Hammer of the Righteous", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 6, "s64254", "45746", "=q1=Glyph of Holy Shock", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 7, "s57030", "41092", "=q1=Glyph of Judgement", "=ds=#sr# 120", "=ds="..AL["Trainer"] };
				{ 17, "s57034", "41110", "=q1=Glyph of Seal of Insight", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 18, "s59561", "43869", "=q1=Glyph of Seal of Truth", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 19, "s64308", "45744", "=q1=Glyph of Shield of the Righteous", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 20, "s64279", "45743", "=q1=Glyph of Templar's Verdict", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"]};
				{ 21, "s57026", "41105", "=q1=Glyph of Word of Glory", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{ 9, 0, "INV_Box_01", "=q6="..AL["Minor Glyph"], "" };
				{ 10, "s58311", "43365", "=q1=Glyph of Blessing of Kings", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 11, "s58314", "43340", "=q1=Glyph of Blessing of Might", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 12, "s58312", "43366", "=q1=Glyph of Insight", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 25, "s58316", "43369", "=q1=Glyph of Justice", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 26, "s58313", "43367", "=q1=Glyph of Lay on Hands", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 27, "s58315", "43368", "=q1=Glyph of Truth", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Major Glyph"], "" };
				{ 2, "s64277", "45741", "=q1=Glyph of Beacon of Light", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 3, "s57020", "41104", "=q1=Glyph of Cleansing", "=ds=#sr# 180", "=ds="..AL["Trainer"] };
				{ 4, "s57023", "41099", "=q1=Glyph of Consecration", "=ds=#sr# 205", "=ds="..AL["Trainer"] };
				{ 5, "s59560", "43868", "=q1=Glyph of Dazing Shield", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 6, "s64305", "45745", "=q1=Glyph of Divine Plea", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 7, "s57022", "41096", "=q1=Glyph of Divine Protection", "=ds=#sr# 80", "=ds="..AL["Trainer"] };
				{ 8, "s57031", "41108", "=q1=Glyph of Divinity", "=ds=#sr# 135", "=ds="..AL["Trainer"] };
				{ 9, "s57019", "41101", "=q1=Glyph of Focused Shield", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 10, "s57027", "41095", "=q1=Glyph of Hammer of Justice", "=ds=#sr# 90", "=ds="..AL["Trainer"] };
				{ 17, "s57028", "41097", "=q1=Glyph of Hammer of Wrath", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 18, "s59559", "43867", "=q1=Glyph of Holy Wrath", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 19, "s57035", "41109", "=q1=Glyph of Light of Dawn", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 20, "s57033", "41094", "=q1=Glyph of Rebuke", "=ds=#sr# 335", "=ds="..AL["Trainer"] };
				{ 21, "s57032", "41100", "=q1=Glyph of Righteousness", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 22, "s64251", "45747", "=q1=Glyph of Salvation", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 23, "s57021", "41107", "=q1=Glyph of the Ascetic Crusader", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 24, "s95825", "66918", "=q1=Glyph of the Long Word", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 25, "s57036", "41102", "=q1=Glyph of Turn Evil", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = INSCRIPTION..": "..AL["Glyph"].." - "..LOCALIZED_CLASS_NAMES_MALE["PALADIN"],
			module = moduleName, menu = "INSCRIPTIONMENU"
		};
	};

	AtlasLoot_Data["Inscription_Priest"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Prime Glyph"], "" };
				{ 2, "s64280", "45753", "=q1=Glyph of Dispersion", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 3, "s57186", "42400", "=q1=Glyph of Flash Heal", "=ds=#sr# 120", "=ds="..AL["Trainer"] };
				{ 4, "s64281", "45755", "=q1=Glyph of Guardian Spirit", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"]};
				{ 5, "s57189", "42403", "=q1=Glyph of Lightwell", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 6, "s57200", "42415", "=q1=Glyph of Mind Flay", "=ds=#sr# 180", "=ds="..AL["Trainer"] };
				{ 7, "s64282", "45756", "=q1=Glyph of Penance", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 17, "s57193", "42407", "=q1=Glyph of Power Word: Barrier", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 18, "s57194", "42408", "=q1=Glyph of Power Word: Shield", "=ds=#sr# 80", "=ds="..AL["Trainer"] };
				{ 19, "s57195", "42409", "=q1=Glyph of Prayer of Healing", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 20, "s57197", "42411", "=q1=Glyph of Renew", "=ds=#sr# 160", "=ds="..AL["Trainer"] };
				{ 21, "s57199", "42414", "=q1=Glyph of Shadow Word: Death", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 22, "s57192", "42406", "=q1=Glyph of Shadow Word: Pain", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 9, 0, "INV_Box_01", "=q6="..AL["Minor Glyph"], "" };
				{ 10, "s58317", "43342", "=q1=Glyph of Fading", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 11, "s58318", "43371", "=q1=Glyph of Fortitude", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 12, "s58319", "43370", "=q1=Glyph of Levitate", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 13, "s107907", "77101", "=q1=Glyph of Shadow", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 25, "s58320", "43373", "=q1=Glyph of Shackle Undead", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 26, "s58321", "43372", "=q1=Glyph of Shadow Protection", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 27, "s58322", "43374", "=q1=Glyph of Shadowfiend", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Major Glyph"], "" };
				{ 2, "s57181", "42396", "=q1=Glyph of Circle of Healing", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 3, "s64259", "45760", "=q1=Glyph of Desperation", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 4, "s57183", "42397", "=q1=Glyph of Dispel Magic", "=ds=#sr# 230", "=ds="..AL["Trainer"] };
				{ 5, "s64283", "45758", "=q1=Glyph of Divine Accuracy", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 6, "s57184", "42398", "=q1=Glyph of Fade", "=ds=#sr# 105", "=ds="..AL["Trainer"] };
				{ 7, "s57185", "42399", "=q1=Glyph of Fear Ward", "=ds=#sr# 270", "=ds="..AL["Trainer"] };
				{ 8, "s57187", "42401", "=q1=Glyph of Holy Nova", "=ds=#sr# 315", "=ds="..AL["Trainer"] };
				{ 9, "s57188", "42402", "=q1=Glyph of Inner Fire", "=ds=#sr# 135", "=ds="..AL["Trainer"] };
				{ 17, "s57190", "42404", "=q1=Glyph of Mass Dispel", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 18, "s57202", "42417", "=q1=Glyph of Prayer of Mending", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 19, "s57191", "42405", "=q1=Glyph of Psychic Horror", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 20, "s57196", "42410", "=q1=Glyph of Psychic Scream", "=ds=#sr# 95", "=ds="..AL["Trainer"] };
				{ 21, "s57198", "42412", "=q1=Glyph of Scourge Imprisonment", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
				{ 22, "s57201", "42416", "=q1=Glyph of Smite", "=ds=#sr# 210", "=ds="..AL["Trainer"] };
				{ 23, "s64309", "45757", "=q1=Glyph of Spirit Tap", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
			};
		};
		info = {
			name = INSCRIPTION..": "..AL["Glyph"].." - "..LOCALIZED_CLASS_NAMES_MALE["PRIEST"],
			module = moduleName, menu = "INSCRIPTIONMENU"
		};
	};
--http://ptr.wowhead.com/item=71799 needs to be checked before 4.3 goes live.
	AtlasLoot_Data["Inscription_Rogue"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Prime Glyph"], "" };
				{ 2, "s57112", "42954", "=q1=Glyph of Adrenaline Rush", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 3, "s57114", "42956", "=q1=Glyph of Backstab", "=ds=#sr# 80", "=ds="..AL["Trainer"] };
				{ 4, "s57120", "42961", "=q1=Glyph of Eviscerate", "=ds=#sr# 105", "=ds="..AL["Trainer"] };
				{ 5, "s57126", "42967", "=q1=Glyph of Hemorrhage", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 6, "s64285", "45762", "=q1=Glyph of Killing Spree", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 7, "s64260", "45768", "=q1=Glyph of Mutilate", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 17, "s57124", "42965", "=q1=Glyph of Revealing Strike", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 18, "s57128", "42969", "=q1=Glyph of Rupture", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 19, "s64286", "45764", "=q1=Glyph of Shadow Dance", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 20, "s57131", "42972", "=q1=Glyph of Sinister Strike", "=ds=#sr# 210", "=ds="..AL["Trainer"] };
				{ 21, "s57132", "42973", "=q1=Glyph of Slice and Dice", "=ds=#sr# 235", "=ds="..AL["Trainer"] };
				{ 22, "s64284", "45761", "=q1=Glyph of Vendetta", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 9, 0, "INV_Box_01", "=q6="..AL["Minor Glyph"], "" };
				{ 10, "s58323", "43379", "=q1=Glyph of Blurred Speed", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 11, "s58324", "43376", "=q1=Glyph of Distract", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 12, "s58325", "43377", "=q1=Glyph of Pick Lock", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 25, "s58326", "43343", "=q1=Glyph of Pick Pocket", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 26, "s58328", "43380", "=q1=Glyph of Poisons", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 27, "s58327", "43378", "=q1=Glyph of Safe Fall", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Major Glyph"], "" };
				{ 2, "s57113", "42955", "=q1=Glyph of Ambush", "=ds=#sr# 340", "=ds="..AL["Trainer"] };
				{ 3, "s57115", "42957", "=q1=Glyph of Blade Flurry", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 4, "s92579", "64493", "=q1=Glyph of Blind", "=ds=#sr# 180", "=ds="..AL["Trainer"] };
				{ 5, "s64303", "45769", "=q1=Glyph of Cloak of Shadows", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 6, "s57116", "42958", "=q1=Glyph of Crippling Poison", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 7, "s57117", "42959", "=q1=Glyph of Deadly Throw", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 8, "s57119", "42960", "=q1=Glyph of Evasion", "=ds=#sr# 95", "=ds="..AL["Trainer"] };
				{ 9, "s57121", "42962", "=q1=Glyph of Expose Armor", "=ds=#sr# 120", "=ds="..AL["Trainer"] };
				{ 10, "s64315", "45766", "=q1=Glyph of Fan of Knives", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 17, "s57122", "42963", "=q1=Glyph of Feint", "=ds=#sr# 305", "=ds="..AL["Trainer"] };
				{ 18, "s57123", "42964", "=q1=Glyph of Garrote", "=ds=#sr# 135", "=ds="..AL["Trainer"] };
				{ 19, "s57125", "42966", "=q1=Glyph of Gouge", "=ds=#sr# 160", "=ds="..AL["Trainer"] };
				{ 20, "s57130", "42971", "=q1=Glyph of Kick", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 21, "s57127", "42968", "=q1=Glyph of Preparation", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 22, "s57129", "42970", "=q1=Glyph of Sap", "=ds=#sr# 185", "=ds="..AL["Trainer"] };
				{ 23, "s57133", "42974", "=q1=Glyph of Sprint", "=ds=#sr# 285", "=ds="..AL["Trainer"] };
				{ 24, "s64310", "45767", "=q1=Glyph of Tricks of the Trade", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 25, "s94711", "63420", "=q1=Glyph of Vanish", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
			};
		};
		info = {
			name = INSCRIPTION..": "..AL["Glyph"].." - "..LOCALIZED_CLASS_NAMES_MALE["ROGUE"],
			module = moduleName, menu = "INSCRIPTIONMENU"
		};
	};

	AtlasLoot_Data["Inscription_Shaman"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Prime Glyph"], "" };
				{ 2, "s64261", "45775", "=q1=Glyph of Earth Shield", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 3, "s57236", "41527", "=q1=Glyph of Earthliving Weapon", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{ 4, "s64288", "45771", "=q1=Glyph of Feral Spirit", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 5, "s57237", "41529", "=q1=Glyph of Fire Elemental Totem", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 6, "s57239", "41531", "=q1=Glyph of Flame Shock", "=ds=#sr# 85", "=ds="..AL["Trainer"] };
				{ 7, "s57240", "41532", "=q1=Glyph of Flametongue Weapon", "=ds=#sr# 125", "=ds="..AL["Trainer"] };
				{ 8, "s57234", "41524", "=q1=Glyph of Lava Burst", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 9, "s57249", "41540", "=q1=Glyph of Lava Lash", "=ds=#sr# 165", "=ds="..AL["Trainer"] };
				{ 17, "s57245", "41536", "=q1=Glyph of Lightning Bolt", "=ds=#sr# 140", "=ds="..AL["Trainer"] };
				{ 18, "s64289", "45772", "=q1=Glyph of Riptide", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"]};
				{ 19, "s57235", "41526", "=q1=Glyph of Shocking", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 20, "s57248", "41539", "=q1=Glyph of Stormstrike", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
				{ 21, "s101057", "71155", "=q1=Glyph of Unleashed Lightning", "=ds=#sr# 430", "=ds="..GetSpellInfo(61177) };
				{ 22, "s57251", "41541", "=q1=Glyph of Water Shield", "=ds=#sr# 275", "=ds="..AL["Trainer"] };
				{ 23, "s57252", "41542", "=q1=Glyph of Windfury Weapon", "=ds=#sr# 330", "=ds="..AL["Trainer"] };
				{ 11, 0, "INV_Box_01", "=q6="..AL["Minor Glyph"], "" };
				{ 12, "s58329", "43381", "=q1=Glyph of Astral Recall", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 13, "s58330", "43385", "=q1=Glyph of Renewed Life", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 14, "s58332", "43386", "=q1=Glyph of the Arctic Wolf", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 27, "s57253", "44923", "=q1=Glyph of Thunderstorm", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 28, "s58331", "43344", "=q1=Glyph of Water Breathing", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 29, "s58333", "43388", "=q1=Glyph of Water Walking", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Major Glyph"], "" };
				{ 2, "s57232", "41517", "=q1=Glyph of Chain Heal", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 3, "s57233", "41518", "=q1=Glyph of Chain Lightning", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 4, "s57250", "41552", "=q1=Glyph of Elemental Mastery", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 5, "s57238", "41530", "=q1=Glyph of Fire Nova", "=ds=#sr# 110", "=ds="..AL["Trainer"] };
				{ 6, "s57241", "41547", "=q1=Glyph of Frost Shock", "=ds=#sr# 185", "=ds="..AL["Trainer"] };
				{ 7, "s59326", "43725", "=q1=Glyph of Ghost Wolf", "=ds=#sr# 100", "=ds="..AL["Trainer"] };
				{ 8, "s57247", "41538", "=q1=Glyph of Grounding Totem", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 9, "s57242", "41533", "=q1=Glyph of Healing Stream Totem", "=ds=#sr# 215", "=ds="..AL["Trainer"] };
				{ 17, "s57243", "41534", "=q1=Glyph of Healing Wave", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 18, "s64316", "45777", "=q1=Glyph of Hex", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 19, "s57246", "41537", "=q1=Glyph of Lightning Shield", "=ds=#sr# 95", "=ds="..AL["Trainer"] };
				{ 20, "s64262", "45776", "=q1=Glyph of Shamanistic Rage", "=ds=#sr# 255", "=ds="..AL["Trainer"] };
				{ 21, "s64247", "45778", "=q1=Glyph of Stoneclaw Totem", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 22, "s64287", "45770", "=q1=Glyph of Thunder", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"]};
				{ 23, "s57244", "41535", "=q1=Glyph of Totemic Recall", "=ds=#sr# 235", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = INSCRIPTION..": "..AL["Glyph"].." - "..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"],
			module = moduleName, menu = "INSCRIPTIONMENU"
		};
	};

	AtlasLoot_Data["Inscription_Warlock"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Prime Glyph"], "" };
				{ 2, "s57260", "42456", "=q1=Glyph of Bane of Agony", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 3, "s64294", "45781", "=q1=Glyph of Chaos Bolt", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 4, "s57258", "42454", "=q1=Glyph of Conflagrate", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 5, "s57259", "42455", "=q1=Glyph of Corruption", "=ds=#sr# 85", "=ds="..AL["Trainer"] };
				{ 6, "s57263", "42459", "=q1=Glyph of Felguard", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 7, "s64291", "45779", "=q1=Glyph of Haunt", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"]};
				{ 8, "s57268", "42464", "=q1=Glyph of Immolate", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 17, "s57269", "42465", "=q1=Glyph of Imp", "=ds=#sr# 140", "=ds="..AL["Trainer"] };
				{ 18, "s57257", "42453", "=q1=Glyph of Incinerate", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 19, "s71102", "50077", "=q1=Glyph of Lash of Pain", "=ds=#sr# 375", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 20, "s64318", "45780", "=q1=Glyph of Metamorphosis", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 21, "s57272", "42468", "=q1=Glyph of Shadowburn", "=ds=#sr# 275", "=ds="..AL["Trainer"] };
				{ 22, "s57276", "42472", "=q1=Glyph of Unstable Affliction", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 10, 0, "INV_Box_01", "=q6="..AL["Minor Glyph"], "" };
				{ 11, "s58338", "43392", "=q1=Glyph of Curse of Exhaustion", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 12, "s58337", "43390", "=q1=Glyph of Drain Soul", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 13, "s58339", "43393", "=q1=Glyph of Enslave Demon", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 14, "s58340", "43391", "=q1=Glyph of Eye of Kilrogg", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 26, "s57265", "42461", "=q1=Glyph of Health Funnel", "=ds=#sr# 75", "=ds="..AL["Trainer"] };
				{ 27, "s58341", "43394", "=q1=Glyph of Ritual of Souls", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 28, "s58336", "43389", "=q1=Glyph of Unending Breath", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Major Glyph"], "" };
				{ 2, "s57261", "42457", "=q1=Glyph of Death Coil", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 3, "s64317", "45782", "=q1=Glyph of Demonic Circle", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 4, "s57262", "42458", "=q1=Glyph of Fear", "=ds=#sr# 125", "=ds="..AL["Trainer"] };
				{ 5, "s57264", "42460", "=q1=Glyph of Felhunter", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 6, "s57266", "42462", "=q1=Glyph of Healthstone", "=ds=#sr# 95", "=ds="..AL["Trainer"] };
				{ 7, "s57267", "42463", "=q1=Glyph of Howl of Terror", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 8, "s64248", "45785", "=q1=Glyph of Life Tap", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 17, "s57275", "42471", "=q1=Glyph of Seduction", "=ds=#sr# 325", "=ds="..AL["Trainer"] };
				{ 18, "s57271", "42467", "=q1=Glyph of Shadow Bolt", "=ds=#sr# 165", "=ds="..AL["Trainer"] };
				{ 19, "s64311", "45783", "=q1=Glyph of Shadowflame", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 20, "s64250", "45789", "=q1=Glyph of Soul Link", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 21, "s57270", "42466", "=q1=Glyph of Soul Swap", "=ds=#sr# 215", "=ds="..AL["Trainer"] };
				{ 22, "s57274", "42470", "=q1=Glyph of Soulstone", "=ds=#sr# 240", "=ds="..AL["Trainer"] };
				{ 23, "s57277", "42473", "=q1=Glyph of Voidwalker", "=ds=#sr# 190", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = INSCRIPTION..": "..AL["Glyph"].." - "..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"],
			module = moduleName, menu = "INSCRIPTIONMENU"
		};
	};

	AtlasLoot_Data["Inscription_Warrior"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Prime Glyph"], "" };
				{ 2, "s64295", "45790", "=q1=Glyph of Bladestorm", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"]};
				{ 3, "s57156", "43416", "=q1=Glyph of Bloodthirst", "=ds=#sr# 285", "=ds="..AL["Trainer"] };
				{ 4, "s57155", "43415", "=q1=Glyph of Devastate", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 5, "s57160", "43421", "=q1=Glyph of Mortal Strike", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 6, "s57161", "43422", "=q1=Glyph of Overpower", "=ds=#sr# 170", "=ds="..AL["Trainer"] };
				{ 17, "s57172", "43432", "=q1=Glyph of Raging Blow", "=ds=#sr# 345", "=ds="..AL["Trainer"] };
				{ 18, "s57165", "43424", "=q1=Glyph of Revenge", "=ds=#sr# 190", "=ds="..AL["Trainer"] };
				{ 19, "s57152", "43425", "=q1=Glyph of Shield Slam", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 20, "s57163", "43423", "=q1=Glyph of Slam", "=ds=#sr# 110", "=ds="..AL["Trainer"] };
				{ 8, 0, "INV_Box_01", "=q6="..AL["Minor Glyph"], "" };
				{ 9, "s58342", "43395", "=q1=Glyph of Battle", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 10, "s58343", "43396", "=q1=Glyph of Berserker Rage", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 11, "s57153", "43412", "=q1=Glyph of Bloody Healing", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 12, "s68166", "49084", "=q1=Glyph of Command", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 13, "s58345", "43398", "=q1=Glyph of Demoralizing Shout", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 24, "s58347", "43400", "=q1=Glyph of Enduring Victory", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 25, "s64255", "45793", "=q1=Glyph of Furious Sundering", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 26, "s64312", "45794", "=q1=Glyph of Intimidating Shout", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 27, "s58344", "43397", "=q1=Glyph of Long Charge", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
				{ 28, "s58346", "43399", "=q1=Glyph of Thunder Clap", "=ds=#sr# 75", "=ds="..GetSpellInfo(61288) };
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Major Glyph"], "" };
				{ 2, "s57154", "43414", "=q1=Glyph of Cleaving", "=ds=#sr# 240", "=ds="..AL["Trainer"] };
				{ 3, "s89815", "63481", "=q1=Glyph of Colossus Smash", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"] };
				{ 4, "s94405", "67483", "=q1=Glyph of Death Wish", "=ds=#sr# 150", "=ds="..AL["Trainer"] };
				{ 5, "s57158", "43418", "=q1=Glyph of Heroic Throw", "=ds=#sr# 95", "=ds="..AL["Trainer"] };
				{ 6, "s94406", "67482", "=q1=Glyph of Intercept", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 7, "s57159", "43419", "=q1=Glyph of Intervene", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 8, "s57157", "43417", "=q1=Glyph of Piercing Howl", "=ds=#sr# 125", "=ds="..AL["Trainer"] };
				{ 9, "s57162", "43413", "=q1=Glyph of Rapid Charge", "=ds=#sr# 85", "=ds="..AL["Trainer"] };
				{ 17, "s57164", "43430", "=q1=Glyph of Resonating Power", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
				{ 18, "s64252", "45797", "=q1=Glyph of Shield Wall", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"]};
				{ 19, "s64296", "45792", "=q1=Glyph of Shockwave", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"]};
				{ 20, "s64302", "45795", "=q1=Glyph of Spell Reflection", "=ds=#sr# 425", "=ds="..AL["Book of Glyph Mastery"]};
				{ 21, "s57167", "43427", "=q1=Glyph of Sunder Armor", "=ds=#sr# 140", "=ds="..AL["Trainer"] };
				{ 22, "s57168", "43428", "=q1=Glyph of Sweeping Strikes", "=ds=#sr# 320", "=ds="..AL["Trainer"] };
				{ 23, "s57170", "43431", "=q1=Glyph of Victory Rush", "=ds=#sr# 385", "=ds="..GetSpellInfo(61177) };
			};
		};
		info = {
			name = INSCRIPTION..": "..AL["Glyph"].." - "..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"],
			module = moduleName, menu = "INSCRIPTIONMENU"
		};
	};

		---------------------
		--- Jewelcrafting ---
		---------------------

	AtlasLoot_Data["JewelRed"] ={
		["Normal"] = {
			{
				{ 1, "s101799", "71883", "=q4=Bold Queen's Garnet", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 2, "s101797", "71881", "=q4=Brilliant Queen's Garnet", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 3, "s101795", "71879", "=q4=Delicate Queen's Garnet", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 4, "s101798", "71882", "=q4=Flashing Queen's Garnet", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 5, "s101796", "71880", "=q4=Precise Queen's Garnet", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 7, "s73335", "52206", "=q3=Bold Inferno Ruby", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 8, "s73338", "52207", "=q3=Brilliant Inferno Ruby", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 9, "s73336", "52212", "=q3=Delicate Inferno Ruby", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 10, "s73337", "52216", "=q3=Flashing Inferno Ruby", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 11, "s73339", "52230", "=q3=Precise Inferno Ruby", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 16, "s73222", "52081", "=q2=Bold Carnelian", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 17, "s73225", "52084", "=q2=Brilliant Carnelian", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 18, "s73223", "52082", "=q2=Delicate Carnelian", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 19, "s73224", "52083", "=q2=Flashing Carnelian", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 20, "s73226", "52085", "=q2=Precise Carnelian", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s66447", "40111", "=q4=Bold Cardinal Ruby", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 2, "s66446", "40113", "=q4=Brilliant Cardinal Ruby", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 3, "s66448", "40112", "=q4=Delicate Cardinal Ruby", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 4, "s66453", "40116", "=q4=Flashing Cardinal Ruby", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 5, "s66450", "40118", "=q4=Precise Cardinal Ruby", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 7, "s53830", "39996", "=q3=Bold Scarlet Ruby", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 8, "s53946", "39998", "=q3=Brilliant Scarlet Ruby", "=ds=#sr# 390", "=ds="..BabbleFaction["Kirin Tor"].." - "..BabbleFaction["Exalted"] };
				{ 9, "s53945", "39997", "=q3=Delicate Scarlet Ruby", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 10, "s53949", "40001", "=q3=Flashing Scarlet Ruby", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 11, "s53951", "40003", "=q3=Precise Scarlet Ruby", "=ds=#sr# 390", "=ds="..BabbleBoss["Herald Volazj"].." ("..AL["Heroic"]..")" };
				{ 16, "s53831", "39900", "=q2=Bold Bloodstone", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 17, "s53834", "39911", "=q2=Brilliant Bloodstone", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 18, "s53832", "39905", "=q2=Delicate Bloodstone", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 19, "s53844", "39908", "=q2=Flashing Bloodstone", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 20, "s54017", "39910", "=q2=Precise Bloodstone", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s39705", "32193", "=q4=Bold Crimson Spinel", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Friendly"] };
				{ 2, "s39710", "32195", "=q4=Brilliant Crimson Spinel", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Friendly"] };
				{ 3, "s39706", "32194", "=q4=Delicate Crimson Spinel", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Friendly"] };
				{ 4, "s39714", "32199", "=q4=Flashing Crimson Spinel", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Exalted"] };
				{ 6, "s42589", "33131", "=q4=Crimson Sun", "=ds=#sr# 360", "=ds="..BabbleFaction["The Consortium"].." - "..BabbleFaction["Revered"] };
				{ 7, "s42558", "33133", "=q4=Don Julio's Heart", "=ds=#sr# 360", "=ds="..BabbleFaction["The Consortium"].." - "..BabbleFaction["Revered"] };
				{ 8, "s42588", "33134", "=q4=Kailee's Rose", "=ds=#sr# 360", "=ds="..BabbleFaction["The Sha'tar"].." - "..BabbleFaction["Honored"] };
				{ 16, "s31084", "24027", "=q3=Bold Living Ruby", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 17, "s31087", "24029", "=q3=Brilliant Living Ruby", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 18, "s31085", "24028", "=q3=Delicate Living Ruby", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 19, "s31091", "24036", "=q3=Flashing Living Ruby", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 21, "s28905", "23095", "=q2=Bold Blood Garnet", "=ds=#sr# 305", "=ds="..AL["Trainer"] };
				{ 22, "s28906", "23096", "=q2=Brilliant Blood Garnet", "=ds=#sr# 305", "=ds="..BabbleFaction["The Scryers"].." - "..BabbleFaction["Friendly"] };
				{ 23, "s28907", "23097", "=q2=Delicate Blood Garnet", "=ds=#sr# 305", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = JEWELCRAFTING..": "..BabbleInventory["Red"].." "..BabbleInventory["Gem"],
			module = moduleName, menu = "JEWELCRAFTINGMENU"
		};
	};

	AtlasLoot_Data["JewelBlue"] = {
		["Normal"] = {
			{
				{ 1, "s101735", "71817", "=q4=Rigid Deepholm Iolite", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 2, "s101742", "71820", "=q4=Solid Deepholm Iolite", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 3, "s101741", "71819", "=q4=Sparkling Deepholm Iolite", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 4, "s101740", "71818", "=q4=Stormy Deepholm Iolite", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 6, "s73344", "52235", "=q3=Rigid Ocean Sapphire", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 7, "s73340", "52242", "=q3=Solid Ocean Sapphire", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 8, "s73341", "52244", "=q3=Sparkling Ocean Sapphire", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 9, "s73343", "52246", "=q3=Stormy Ocean Sapphire", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 11, "s73230", "52089", "=q2=Rigid Zephyrite", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 12, "s73227", "52086", "=q2=Solid Zephyrite", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 13, "s73228", "52087", "=q2=Sparkling Zephyrite", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 14, "s73229", "52088", "=q2=Stormy Zephyrite", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 16, "s66501", "40125", "=q4=Rigid Majestic Zircon", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 17, "s66497", "40119", "=q4=Solid Majestic Zircon", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 18, "s66498", "40120", "=q4=Sparkling Majestic Zircon", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 19, "s66499", "40122", "=q4=Stormy Majestic Zircon", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 21, "s53958", "40014", "=q3=Rigid Sky Sapphire", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 22, "s53952", "40008", "=q3=Solid Sky Sapphire", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 23, "s53953", "40009", "=q3=Sparkling Sky Sapphire", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 24, "s53955", "40011", "=q3=Stormy Sky Sapphire", "=ds=#sr# 390", "=ds="..BabbleZone["Wintergrasp"] };
				{ 26, "s53854", "39915", "=q2=Rigid Chalcedony", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 27, "s53934", "39919", "=q2=Solid Chalcedony", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 28, "s53940", "39920", "=q2=Sparkling Chalcedony", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 29, "s53943", "39932", "=q2=Stormy Chalcedony", "=ds=#sr# 350", "#DALARANJW:1#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
			};
			{
				{ 1, "s39721", "32206", "=q4=Rigid Empyrean Sapphire", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Revered"] };
				{ 2, "s39715", "32200", "=q4=Solid Empyrean Sapphire", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Friendly"] };
				{ 3, "s39716", "32201", "=q4=Sparkling Empyrean Sapphire", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Friendly"] };
				{ 4, "s39718", "32203", "=q4=Stormy Empyrean Sapphire", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Exalted"] };
				{ 5, "s42590", "33135", "=q4=Falling Star", "=ds=#sr# 360", "=ds="..BabbleFaction["Lower City"].." - "..BabbleFaction["Revered"] };
				{ 7, "s31098", "24051", "=q3=Rigid Star of Elune", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 8, "s31092", "24033", "=q3=Solid Star of Elune", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 9, "s31149", "24035", "=q3=Sparkling Star of Elune", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 10, "s31095", "24039", "=q3=Stormy Star of Elune", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 16, "s28948", "23116", "=q2=Rigid Azure Moonstone", "=ds=#sr# 325", "=ds="..AL["Trainer"]};
				{ 17, "s28955", "23120", "=q2=Stormy Azure Moonstone", "=ds=#sr# 315", "=ds="..AL["World Drop"]};
				{ 18, "s28950", "23118", "=q2=Solid Azure Moonstone", "=ds=#sr# 305", "=ds="..AL["Trainer"]};
				{ 19, "s28953", "23119", "=q2=Sparkling Azure Moonstone", "=ds=#sr# 300", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = JEWELCRAFTING..": "..BabbleInventory["Blue"].." "..BabbleInventory["Gem"],
			module = moduleName, menu = "JEWELCRAFTINGMENU"
		};
	};

	AtlasLoot_Data["JewelYellow"] = {
		["Normal"] = {
			{
				{ 1, "s101803", "71877", "=q4=Fractured Lightstone", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 2, "s101804", "71878", "=q4=Mystic Lightstone", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 3, "s101802", "71876", "=q4=Quick Lightstone", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 4, "s101800", "71874", "=q4=Smooth Lightstone", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 5, "s101801", "71875", "=q4=Subtle Lightstone", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 7, "s73349", "52219", "=q3=Fractured Amberjewel", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 8, "s73347", "52226", "=q3=Mystic Amberjewel", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 9, "s73348", "52232", "=q3=Quick Amberjewel", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 10, "s73346", "52241", "=q3=Smooth Amberjewel", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 11, "s73345", "52247", "=q3=Subtle Amberjewel", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 16, "s73239", "52094", "=q2=Fractured Alicite", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 17, "s73234", "52093", "=q2=Quick Alicite", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 18, "s73232", "52091", "=q2=Smooth Alicite", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 19, "s73231", "52090", "=q2=Subtle Alicite", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
			};
			{
				{ 1, "s66505", "40127", "=q4=Mystic King's Amber", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 2, "s66506", "40128", "=q4=Quick King's Amber", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 3, "s66502", "40124", "=q4=Smooth King's Amber", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 4, "s66504", "40126", "=q4=Subtle King's Amber", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 6, "s53960", "40016", "=q3=Mystic Autumn's Glow", "=ds=#sr# 390", "=ds="..BabbleZone["Wintergrasp"] };
				{ 7, "s53961", "40017", "=q3=Quick Autumn's Glow", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 8, "s53957", "40013", "=q3=Smooth Autumn's Glow", "=ds=#sr# 390", "=ds="..BabbleFaction["The Sons of Hodir"].." - "..BabbleFaction["Exalted"] };
				{ 9, "s53959", "40015", "=q3=Subtle Autumn's Glow", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 11, "s53857", "39917", "=q2=Mystic Sun Crystal", "=ds=#sr# 350", "#DALARANJW:1#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 12, "s53856", "39918", "=q2=Quick Sun Crystal", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 13, "s53853", "39914", "=q2=Smooth Sun Crystal", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 14, "s53855", "39916", "=q2=Subtle Sun Crystal", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 16, "s39724", "32209", "=q4=Mystic Lionseye", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Exalted"] };
				{ 17, "s47056", "35761", "=q4=Quick Lionseye", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Revered"] };
				{ 18, "s39720", "32205", "=q4=Smooth Lionseye", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Friendly"] };
				{ 19, "s39723", "32208", "=q4=Subtle Lionseye", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Friendly"] };
				{ 20, "s42592", "33140", "=q4=Blood of Amber", "=ds=#sr# 360", "=ds="..BabbleFaction["The Sha'tar"].." - "..BabbleFaction["Revered"] };
				{ 21, "s42593", "33144", "=q4=Facet of Eternity", "=ds=#sr# 360", "=ds="..BabbleFaction["Keepers of Time"].." - "..BabbleFaction["Honored"] };
				{ 22, "s42591", "33143", "=q4=Stone of Blades", "=ds=#sr# 360", "=ds="..BabbleFaction["Keepers of Time"].." - "..BabbleFaction["Revered"] };
				{ 24, "s31101", "24053", "=q3=Mystic Dawnstone", "=ds=#sr# 350", "=ds="..AL["Vendor"]..": "..BabbleZone["Nagrand"] };
				{ 25, "s46403", "35315", "=q3=Quick Dawnstone", "=ds=#sr# 350", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Exalted"] };
				{ 26, "s31097", "24048", "=q3=Smooth Dawnstone", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 27, "s31100", "24052", "=q3=Subtle Dawnstone", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 29, "s34069", "28290", "=q2=Smooth Golden Draenite", "=ds=#sr# 325", "=ds="..BabbleFaction["The Aldor"].." - "..BabbleFaction["Friendly"] };
				{ 30, "s28947", "23115", "=q2=Subtle Golden Draenite", "=ds=#sr# 315", "=ds="..BabbleFaction["The Consortium"].." - "..BabbleFaction["Honored"] };
			};
		};
		info = {
			name = JEWELCRAFTING..": "..BabbleInventory["Yellow"].." "..BabbleInventory["Gem"],
			module = moduleName, menu = "JEWELCRAFTINGMENU"
		};
	};

	AtlasLoot_Data["JewelGreen"] = {
		["Normal"] = {
			{
				{ 1, "s101749", "71828", "=q4=Balanced Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 2, "s101754", "71833", "=q4=Energized Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 3, "s101757", "71836", "=q4=Forceful Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 4, "s101747", "71826", "=q4=Infused Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 5, "s101755", "71834", "=q4=Jagged Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 6, "s101745", "71824", "=q4=Lightning Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 7, "s101743", "71822", "=q4=Misty Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 8, "s101758", "71837", "=q4=Nimble Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 9, "s101744", "71823", "=q4=Piercing Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 16, "s101759", "71838", "=q4=Puissant Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 17, "s101752", "71831", "=q4=Radiant Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 18, "s101756", "71835", "=q4=Regal Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 19, "s101746", "71825", "=q4=Sensei's Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 20, "s101753", "71832", "=q4=Shattered Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 21, "s101760", "71839", "=q4=Steady Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 22, "s101751", "71830", "=q4=Turbid Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 23, "s101750", "71829", "=q4=Vivid Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 24, "s101748", "71827", "=q4=Zen Elven Peridot", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
			};
			{
				{ 1, "s73380", "52218", "=q3=Forceful Dream Emerald", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 2, "s73377", "52223", "=q3=Jagged Dream Emerald", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 3, "s73381", "52225", "=q3=Lightning Dream Emerald", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 4, "s73376", "52227", "=q3=Nimble Dream Emerald", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 5, "s73378", "52228", "=q3=Piercing Dream Emerald", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 6, "s73382", "52231", "=q3=Puissant Dream Emerald", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 8, "s73277", "52124", "=q2=Forceful Jasper", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 9, "s73274", "52121", "=q2=Jagged Jasper", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 10, "s73278", "52125", "=q2=Lightning Jasper", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 11, "s73273", "52120", "=q2=Nimble Jasper", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 12, "s73275", "52122", "=q2=Piercing Jasper", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 16, "s73375", "52233", "=q3=Regal Dream Emerald", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 17, "s73384", "52237", "=q3=Sensei's Dream Emerald", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 18, "s73379", "52245", "=q3=Steady Dream Emerald", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 19, "s96226", "68741", "=q3=Vivid Dream Emerald", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 20, "s73383", "52250", "=q3=Zen Dream Emerald", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 23, "s73279", "52126", "=q2=Puissant Jasper", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 24, "s73272", "52119", "=q2=Regal Jasper", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 25, "s73281", "52128", "=q2=Sensei's Jasper", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 26, "s73276", "52123", "=q2=Steady Jasper", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 27, "s73280", "52127", "=q2=Zen Jasper", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
			};
			{
				{ 1, "s66442", "40179", "=q4=Energized Eye of Zul", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 2, "s66434", "40169", "=q4=Forceful Eye of Zul", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 3, "s66431", "40165", "=q4=Jagged Eye of Zul", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 4, "s66439", "40177", "=q4=Lightning Eye of Zul", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 5, "s66435", "40171", "=q4=Misty Eye of Zul", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 6, "s66429", "40166", "=q4=Nimble Eye of Zul", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 7, "s66441", "40180", "=q4=Radiant Eye of Zul", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 8, "s66338", "40167", "=q4=Regal Eye of Zul", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 9, "s66443", "40182", "=q4=Shattered Eye of Zul", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 10, "s66428", "40168", "=q4=Steady Eye of Zul", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 11, "s66445", "40173", "=q4=Turbid Eye of Zul", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 16, "s54011", "40105", "=q3=Energized Forest Emerald", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 17, "s54001", "40091", "=q3=Forceful Forest Emerald", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 18, "s53996", "40086", "=q3=Jagged Forest Emerald", "=ds=#sr# 390", "=ds="..BabbleFaction["Frenzyheart Tribe"].." - "..BabbleFaction["Revered"] };
				{ 19, "s54009", "40100", "=q3=Lightning Forest Emerald", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 20, "s54003", "40095", "=q3=Misty Forest Emerald", "=ds=#sr# 390", "=ds="..BabbleFaction["The Oracles"].." - "..BabbleFaction["Revered"] };
				{ 21, "s53997", "40088", "=q3=Nimble Forest Emerald", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 22, "s54012", "40098", "=q3=Radiant Forest Emerald", "=ds=#sr# 390", "=ds="..AL["Drop"]..": "..BabbleZone["The Storm Peaks"] };
				{ 23, "s53998", "40089", "=q3=Regal Forest Emerald", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 24, "s54014", "40106", "=q3=Shattered Forest Emerald", "=ds=#sr# 390", "=ds="..BabbleZone["Wintergrasp"] };
				{ 25, "s54000", "40090", "=q3=Steady Forest Emerald", "=ds=#sr# 390", "=ds="..BabbleZone["Wintergrasp"] };
				{ 26, "s54005", "40102", "=q3=Turbid Forest Emerald", "=ds=#sr# 390", "=ds="..BabbleZone["Wintergrasp"] };
			};
			{
				{ 1, "s53930", "39989", "=q2=Energized Dark Jade", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 2, "s53920", "39978", "=q2=Forceful Dark Jade", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 3, "s53916", "39974", "=q2=Jagged Dark Jade", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 4, "s53928", "39986", "=q2=Lightning Dark Jade", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 5, "s53922", "39980", "=q2=Misty Dark Jade", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 6, "s53917", "39975", "=q2=Nimble Dark Jade", "=ds=#sr# 350", "=ds="..BabbleFaction["The Oracles"].." - "..BabbleFaction["Friendly"] };
				{ 7, "s53931", "39990", "=q2=Radiant Dark Jade", "=ds=#sr# 350", "#DALARANJW:1#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 8, "s53918", "39976", "=q2=Regal Dark Jade", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 9, "s53933", "39992", "=q2=Shattered Dark Jade", "=ds=#sr# 350", "#DALARANJW:1#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 10, "s53919", "39977", "=q2=Steady Dark Jade", "=ds=#sr# 350", "#DALARANJW:1#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 11, "s53924", "39982", "=q2=Turbid Dark Jade", "=ds=#sr# 350", "#DALARANJW:1#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 16, "s47053", "35759", "=q4=Forceful Seaspray Emerald", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Revered"] };
				{ 17, "s39742", "32226", "=q4=Jagged Seaspray Emerald", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Honored"] };
				{ 18, "s39740", "32224", "=q4=Radiant Seaspray Emerald", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Honored"] };
				{ 19, "s39739", "32223", "=q4=Regal Seaspray Emerald", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Revered"] };
				{ 20, "s47054", "35758", "=q4=Steady Seaspray Emerald", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Revered"] };
				{ 22, "s46405", "35318", "=q3=Forceful Talasite", "=ds=#sr# 350", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Exalted"] };
				{ 23, "s31113", "24067", "=q3=Jagged Talasite", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 24, "s31111", "24066", "=q3=Radiant Talasite", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 25, "s31110", "24062", "=q3=Regal Talasite", "=ds=#sr# 350", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Revered"] };
				{ 26, "s43493", "33782", "=q3=Steady Talasite", "=ds=#sr# 350", "=ds=#sr# "..AL["Vendor"]..": "..BabbleZone["Nagrand"] };
				{
					{ 28, "s28918", "23105", "=q2=Regal Deep Peridot", "=ds=#sr# 315", "=ds="..BabbleFaction["Thrallmar"].." - "..BabbleFaction["Friendly"] };
					{ 28, "s28918", "23105", "=q2=Regal Deep Peridot", "=ds=#sr# 315", "=ds="..BabbleFaction["Honor Hold"].." - "..BabbleFaction["Friendly"] };
				};
				{ 29, "s28917", "23104", "=q2=Jagged Deep Peridot", "=ds=#sr# 305", "=ds="..AL["Trainer"] };
				{ 30, "s28916", "23103", "=q2=Radiant Deep Peridot", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = JEWELCRAFTING..": "..BabbleInventory["Green"].." "..BabbleInventory["Gem"],
			module = moduleName, menu = "JEWELCRAFTINGMENU"
		};
	};

	AtlasLoot_Data["JewelOrange"] = {
		["Normal"] = {
			{
				{ 1, "s101773", "71852", "=q4=Adept Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 2, "s101775", "71854", "=q4=Artful Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 3, "s101768", "71847", "=q4=Champion's Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 4, "s101762", "71841", "=q4=Crafty Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 5, "s101761", "71840", "=q4=Deadly Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 6, "s101769", "71848", "=q4=Deft Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 7, "s101772", "71851", "=q4=Fierce Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 8, "s101776", "71855", "=q4=Fine Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 9, "s101764", "71843", "=q4=Inscribed Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 10, "s101774", "71853", "=q4=Keen Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 11, "s101778", "71857", "=q4=Lucent Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 16, "s101765", "71844", "=q4=Polished Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 17, "s101763", "71842", "=q4=Potent Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 18, "s101771", "71850", "=q4=Reckless Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 19, "s101766", "71845", "=q4=Resolute Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 20, "s101782", "71861", "=q4=Resplendent Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 21, "s101777", "71856", "=q4=Skillful Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 22, "s101781", "71860", "=q4=Splendid Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 23, "s101767", "71846", "=q4=Stalwart Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 24, "s101779", "71858", "=q4=Tenuous Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 25, "s101770", "71849", "=q4=Wicked Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 26, "s101780", "71859", "=q4=Willful Lava Coral", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
			};
			{
				{ 1, "s73371", "52204", "=q3=Adept Ember Topaz", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 2, "s73373", "52205", "=q3=Artful Ember Topaz", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 3, "s73365", "52209", "=q3=Deadly Ember Topaz", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 4, "s73368", "52211", "=q3=Deft Ember Topaz", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 5, "s73367", "52214", "=q3=Fierce Ember Topaz", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 6, "s73372", "52215", "=q3=Fine Ember Topaz", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 7, "s73364", "52222", "=q3=Inscribed Ember Topaz", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 8, "s73374", "52224", "=q3=Keen Ember Topaz", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 10, "s73268", "52115", "=q2=Adept Hessonite", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 11, "s73270", "52117", "=q2=Artful Hessonite", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 12, "s73262", "52109", "=q2=Deadly Hessonite", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 13, "s73265", "52112", "=q2=Deft Hessonite", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 14, "s73264", "52111", "=q2=Fierce Hessonite", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 15, "s73269", "52116", "=q2=Fine Hessonite", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 16, "s95755", "68357", "=q3=Lucent Ember Topaz", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 17, "s73361", "52229", "=q3=Polished Ember Topaz", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 18, "s73366", "52239", "=q3=Potent Ember Topaz", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 19, "s73369", "52208", "=q3=Reckless Ember Topaz", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 20, "s73362", "52249", "=q3=Resolute Ember Topaz", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 21, "s95756", "68358", "=q3=Resplendent Ember Topaz", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 22, "s73370", "52240", "=q3=Skillful Ember Topaz", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 23, "s95754", "68356", "=q3=Willful Ember Topaz", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 25, "s73260", "52108", "=q2=Inscribed Hessonite", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 26, "s73271", "52118", "=q2=Keen Hessonite", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 27, "s73258", "52106", "=q2=Polished Hessonite", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 28, "s73263", "52110", "=q2=Potent Hessonite", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 29, "s73266", "52113", "=q2=Reckless Hessonite", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 30, "s73267", "52114", "=q2=Skillful Hessonite", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s66579", "40144", "=q4=Champion's Ametrine", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 2, "s66568", "40147", "=q4=Deadly Ametrine", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 3, "s66584", "40150", "=q4=Deft Ametrine", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 4, "s66583", "40146", "=q4=Fierce Ametrine", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 5, "s66567", "40142", "=q4=Inscribed Ametrine", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 6, "s66585", "40149", "=q4=Lucent Ametrine", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 7, "s66569", "40152", "=q4=Potent Ametrine", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 8, "s66574", "40155", "=q4=Reckless Ametrine", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 9, "s66586", "40163", "=q4=Resolute Ametrine", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 10, "s66582", "40145", "=q4=Resplendent Ametrine", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 11, "s66581", "40160", "=q4=Stalwart Ametrine", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 12, "s66571", "40154", "=q4=Willful Ametrine", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 16, "s53977", "40039", "=q3=Champion's Monarch Topaz", "=ds=#sr# 390", "=ds="..AL["World Drop"]..""};
				{ 17, "s53979", "40043", "=q3=Deadly Monarch Topaz", "=ds=#sr# 390", "=ds="..BabbleFaction["Knights of the Ebon Blade"].." - "..BabbleFaction["Revered"] };
				{ 18, "s53982", "40046", "=q3=Deft Monarch Topaz", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 19, "s54019", "40041", "=q3=Fierce Monarch Topaz", "=ds=#sr# 390", "=ds="..BabbleBoss["Ingvar the Plunderer"].." ("..AL["Heroic"]..")" };
				{ 20, "s53975", "40037", "=q3=Inscribed Monarch Topaz", "=ds=#sr# 390", "=ds="..AL["World Drop"]..""};
				{ 21, "s53981", "40045", "=q3=Lucent Monarch Topaz", "=ds=#sr# 390", "=ds="..BabbleZone["Wintergrasp"] };
				{ 22, "s53984", "40048", "=q3=Potent Monarch Topaz", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 23, "s53987", "40051", "=q3=Reckless Monarch Topaz", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 24, "s54023", "40059", "=q3=Resolute Monarch Topaz", "=ds=#sr# 390", "=ds="..AL["World Drop"]..""};
				{ 25, "s53978", "40040", "=q3=Resplendent Monarch Topaz", "=ds=#sr# 390", "=ds="..BabbleZone["Wintergrasp"] };
				{ 26, "s53992", "40056", "=q3=Stalwart Monarch Topaz", "=ds=#sr# 390", "=ds="..BabbleFaction["The Wyrmrest Accord"].." - "..BabbleFaction["Exalted"] };
				{ 27, "s53986", "40050", "=q3=Willful Monarch Topaz", "=ds=#sr# 390", "=ds="..BabbleZone["Wintergrasp"] };
			};
			{
				{ 1, "s53874", "39949", "=q2=Champion's Huge Citrine", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 2, "s53877", "39952", "=q2=Deadly Huge Citrine", "=ds=#sr# 350", "=ds="..BabbleFaction["Knights of the Ebon Blade"].." - "..BabbleFaction["Friendly"] };
				{ 3, "s53880", "39955", "=q2=Deft Huge Citrine", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 4, "s53876", "39951", "=q2=Fierce Huge Citrine", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 5, "s53872", "39947", "=q2=Inscribed Huge Citrine", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 6, "s53879", "39954", "=q2=Lucent Huge Citrine", "=ds=#sr# 350", "#DALARANJW:1#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 7, "s53882", "39956", "=q2=Potent Huge Citrine", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 8, "s53885", "39959", "=q2=Reckless Huge Citrine", "=ds=#sr# 350", "=ds="..BabbleFaction["Frenzyheart Tribe"].." - "..BabbleFaction["Friendly"] };
				{ 9, "s53893", "39967", "=q2=Resolute Huge Citrine", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 10, "s53875", "39950", "=q2=Resplendent Huge Citrine", "=ds=#sr# 350", "#DALARANJW:1#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 11, "s53890", "39964", "=q2=Stalwart Huge Citrine", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 12, "s53884", "39958", "=q2=Willful Huge Citrine", "=ds=#sr# 350", "#DALARANJW:1#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 16, "s39738", "32222", "=q4=Deadly Pyrestone", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Revered"] };
				{ 17, "s39733", "32217", "=q4=Inscribed Pyrestone", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Exalted"] };
				{ 18, "s39734", "32218", "=q4=Potent Pyrestone", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Honored"] };
				{ 19, "s47055", "35760", "=q4=Reckless Pyrestone", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Honored"] };
				{ 21, "s39471", "31868", "=q3=Deadly Noble Topaz", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 22, "s31106", "24058", "=q3=Inscribed Noble Topaz", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 23, "s31107", "24059", "=q3=Potent Noble Topaz", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 24, "s46404", "35316", "=q3=Reckless Noble Topaz", "=ds=#sr# 350", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Exalted"] };
				{ 26, "s39467", "31869", "=q2=Deadly Flame Spessarite", "=ds=#sr# 325", "=ds="..AL["Drop"]..": "..BabbleZone["Blade's Edge Mountains"] };
				{ 27, "s28915", "23101", "=q2=Potent Flame Spessarite", "=ds=#sr# 325", "=ds="..BabbleFaction["Lower City"].." - "..BabbleFaction["Friendly"] };
				{ 28, "s28912", "23099", "=q2=Reckless Flame Spessarite", "=ds=#sr# 305", "=ds="..BabbleFaction["The Consortium"].." - "..BabbleFaction["Friendly"] };
				{ 29, "s28910", "23098", "=q2=Inscribed Flame Spessarite", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = JEWELCRAFTING..": "..BabbleInventory["Orange"].." "..BabbleInventory["Gem"],
			module = moduleName, menu = "JEWELCRAFTINGMENU"
		};
	};

	AtlasLoot_Data["JewelPurple"] = {
		["Normal"] = {
			{
				{ 1, "s101784", "71863", "=q4=Accurate Shadow Spinel", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 2, "s101793", "71872", "=q4=Defender's Shadow Spinel", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 3, "s101787", "71866", "=q4=Etched Shadow Spinel", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 4, "s101783", "71862", "=q4=Glinting Shadow Spinel", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 5, "s101791", "71870", "=q4=Guardian's Shadow Spinel", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 6, "s101788", "71867", "=q4=Mysterious Shadow Spinel", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 8, "s73360", "52203", "=q3=Accurate Demonseye", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 9, "s73352", "52210", "=q3=Defender's Demonseye", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 10, "s73356", "52213", "=q3=Etched Demonseye", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 11, "s73357", "52220", "=q3=Glinting Demonseye", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 12, "s73354", "52221", "=q3=Guardian's Demonseye", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 13, "s73355", "52236", "=q3=Purified Demonseye", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 16, "s101789", "71868", "=q4=Purified Shadow Spinel", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 17, "s101786", "71865", "=q4=Retaliating Shadow Spinel", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 18, "s101790", "71869", "=q4=Shifting Shadow Spinel", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 19, "s101794", "71873", "=q4=Sovereign Shadow Spinel", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 20, "s101792", "71871", "=q4=Timeless Shadow Spinel", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 21, "s101785", "71864", "=q4=Veiled Shadow Spinel", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 23, "s73358", "52234", "=q3=Retaliating Demonseye", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 24, "s73351", "52238", "=q3=Shifting Demonseye", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 25, "s73350", "52243", "=q3=Souvereign Demonseye", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 26, "s73353", "52248", "=q3=Timeless Demonseye", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
				{ 27, "s73359", "52217", "=q3=Veiled Demonseye", "=ds=#sr# 465", "#CATAJW:3#"..AL["Vendor"] };
			};
			{
				{ 1, "s73250", "52105", "=q2=Accurate Nightstone", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 2, "s73242", "52097", "=q2=Defender's Nightstone", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 3, "s73246", "52101", "=q2=Etched Nightstone", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 4, "s73247", "52102", "=q2=Glinting Nightstone", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 5, "s73244", "52099", "=q2=Guardian's Nightstone", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 6, "s73245", "52100", "=q2=Purified Nightstone", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 7, "s73248", "52103", "=q2=Retaliating Nightstone", "=ds=#sr# 425", "=ds="..AL["World Drop"] };
				{ 8, "s73241", "52096", "=q2=Shifting Nightstone", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 9, "s73240", "52095", "=q2=Souvereign Nightstone", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 10, "s73243", "52098", "=q2=Timeless Nightstone", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 11, "s73249", "52104", "=q2=Veiled Nightstone", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 16, "s66576", "40162", "=q4=Accurate Dreadstone", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 17, "s66560", "40139", "=q4=Defender's Dreadstone", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 18, "s66572", "40143", "=q4=Etched Dreadstone", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 19, "s66564", "40137", "=q4=Glinting Dreadstone", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 20, "s66561", "40141", "=q4=Guardian's Dreadstone", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 21, "s66562", "40135", "=q4=Mysterious Dreadstone", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 22, "s66556", "40133", "=q4=Purified Dreadstone", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 23, "s66557", "40130", "=q4=Shifting Dreadstone", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 24, "s66554", "40129", "=q4=Sovereign Dreadstone", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 25, "s66555", "40132", "=q4=Timeless Dreadstone", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 26, "s66570", "40153", "=q4=Veiled Dreadstone", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
			};
			{
				{ 1, "s53994", "40058", "=q3=Accurate Twilight Opal", "=ds=#sr# 390", "=ds="..AL["Drop"]..": "..BabbleZone["The Storm Peaks"] };
				{ 2, "s53972", "40032", "=q3=Defender's Twilight Opal", "=ds=#sr# 390", "=ds="..AL["Drop"]..": "..BabbleZone["The Storm Peaks"] };
				{ 3, "s53976", "40038", "=q3=Etched Twilight Opal", "=ds=#sr# 390", "=ds="..AL["World Drop"] };
				{ 4, "s53970", "40030", "=q3=Glinting Twilight Opal", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 5, "s53974", "40034", "=q3=Guardian's Twilight Opal", "=ds=#sr# 390", "=ds="..BabbleFaction["Argent Crusade"].." - "..BabbleFaction["Revered"] };
				{ 6, "s53968", "40028", "=q3=Mysterious Twilight Opal", "=ds=#sr# 390", "=ds="..BabbleZone["Wintergrasp"] };
				{ 7, "s53966", "40026", "=q3=Purified Twilight Opal", "=ds=#sr# 390", "=ds="..AL["World Drop"] };
				{ 8, "s53963", "40023", "=q3=Shifting Twilight Opal", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 9, "s53962", "40022", "=q3=Sovereign Twilight Opal", "=ds=#sr# 390", "=ds="..AL["World Drop"] };
				{ 10, "s53965", "40025", "=q3=Timeless Twilight Opal", "=ds=#sr# 390", "=ds="..BabbleFaction["Knights of the Ebon Blade"].." - "..BabbleFaction["Exalted"] };
				{ 11, "s53985", "40049", "=q3=Veiled Twilight Opal", "=ds=#sr# 390", "#DALARANJW:3#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 16, "s53892", "39966", "=q2=Accurate Shadow Crystal", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 17, "s53869", "39939", "=q2=Defender's Shadow Crystal", "=ds=#sr# 350", "=ds="..BabbleFaction["The Kalu'ak"].." - "..BabbleFaction["Honored"] };
				{ 18, "s53873", "39948", "=q2=Etched Shadow Crystal", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 19, "s53867", "39944", "=q2=Glinting Shadow Crystal", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 20, "s53871", "39940", "=q2=Guardian's Shadow Crystal", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 21, "s53865", "39945", "=q2=Mysterious Shadow Crystal", "=ds=#sr# 350", "#DALARANJW:1#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 22, "s53921", "39979", "=q2=Purified Shadow Crystal", "=ds=#sr# 350", "=ds="..BabbleFaction["The Kalu'ak"].." - "..BabbleFaction["Friendly"] };
				{ 23, "s53860", "39935", "=q2=Shifting Shadow Crystal", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 24, "s53859", "39934", "=q2=Sovereign Shadow Crystal", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 25, "s53894", "39968", "=q2=Timeless Shadow Crystal", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 26, "s53883", "39957", "=q2=Veiled Shadow Crystal", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s39736", "32220", "=q4=Glinting Shadowsong Amethyst", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Honored"] };
				{ 2, "s48789", "37503", "=q4=Purified Shadowsong Amethyst", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Honored"] };
				{ 3, "s39728", "32212", "=q4=Shifting Shadowsong Amethyst", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Exalted"] };
				{ 4, "s39727", "32211", "=q4=Sovereign Shadowsong Amethyst", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Exalted"] };
				{ 5, "s39731", "32215", "=q4=Timeless Shadowsong Amethyst", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Honored"] };
				{ 6, "s39737", "32221", "=q4=Veiled Shadowsong Amethyst", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Exalted"] };
				{ 8, "s39462", "31865", "=q3=Glinting Nightseye", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 9, "s31105", "24057", "=q3=Purified Nightseye", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 10, "s31103", "24055", "=q3=Shifting Nightseye", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 11, "s31102", "24054", "=q3=Sovereign Nightseye", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 12, "s31104", "24056", "=q3=Timeless Nightseye", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 13, "s39470", "31867", "=q3=Veiled Nightseye", "=ds=#sr# 350", "=ds="..AL["World Drop"] };
				{ 16, "s41429", "32836", "=q3=Purified Shadow Pearl", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 17, "s41420", "32833", "=q2=Purified Jaggal Pearl", "=ds=#sr# 325", "=ds="..AL["Trainer"] };
				{ 19, "s28933", "23110", "=q2=Shifting Shadow Draenite", "=ds=#sr# 325", "=ds="..AL["Vendor"] };
				{ 20, "s28936", "23111", "=q2=Sovereign Shadow Draenite", "=ds=#sr# 325", "=ds="..AL["Trainer"] };
				{ 21, "s39466", "31866", "=q2=Veiled Shadow Draenite", "=ds=#sr# 325", "=ds="..AL["Drop"]..": "..BabbleZone["Blade's Edge Mountains"] };
				{ 22, "s28914", "23100", "=q2=Glinting Shadow Draenite", "=ds=#sr# 315", "=ds="..AL["Trainer"] };
				{ 23, "s28927", "23109", "=q2=Purified Shadow Draenite", "=ds=#sr# 305", "=ds="..BabbleFaction["The Aldor"].." / "..BabbleFaction["The Scryers"].." - "..BabbleFaction["Honored"] };
				{ 24, "s28925", "23108", "=q2=Timeless Shadow Draenite", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = JEWELCRAFTING..": "..BabbleInventory["Purple"].." "..BabbleInventory["Gem"],
			module = moduleName, menu = "JEWELCRAFTINGMENU"
		};
	};

	AtlasLoot_Data["JewelMeta"] = {
		["Normal"] = {
			{
				{ 1, "s96255", "68778", "=q3=Agile Shadowspirit Diamond", "=ds=#sr# 490", "=ds="..AL["World Drop"] };
				{ 2, "s73468", "52294", "=q3=Austere Shadowspirit Diamond", "=ds=#sr# 490", "#CATAJW:4#"..AL["Vendor"] };
				{ 3, "s73466", "52292", "=q3=Bracing Shadowspirit Diamond", "=ds=#sr# 490", "#CATAJW:4#"..AL["Vendor"] };
				{ 4, "s96257", "68780", "=q3=Burning Shadowspirit Diamond", "=ds=#sr# 490", "=ds="..AL["World Drop"] };
				{ 5, "s73465", "52291", "=q3=Chaotic Shadowspirit Diamond", "=ds=#sr# 490", "#CATAJW:4#"..AL["Vendor"] };
				{ 6, "s73472", "52298", "=q3=Destructive Shadowspirit Diamond", "=ds=#sr# 490", "#CATAJW:4#"..AL["Vendor"] };
				{ 7, "s73469", "52295", "=q3=Efullgent Shadowspirit Diamond", "=ds=#sr# 490", "#CATAJW:4#"..AL["Vendor"] };
				{ 8, "s73470", "52296", "=q3=Ember Shadowspirit Diamond", "=ds=#sr# 490", "#CATAJW:4#"..AL["Vendor"] };
				{ 10, "s55401", "41380", "=q3=Austere Earthsiege Diamond", "=ds=#sr# 420", "=ds="..BabbleBoss["King Ymiron"] };
				{ 11, "s55405", "41389", "=q3=Beaming Earthsiege Diamond", "=ds=#sr# 420", "=ds="..AL["World Drop"]..""};
				{ 12, "s55397", "41395", "=q3=Bracing Earthsiege Diamond", "=ds=#sr# 420", "=ds="..BabbleBoss["Ley-Guardian Eregos"] };
				{ 13, "s55398", "41396", "=q3=Eternal Earthsiege Diamond", "=ds=#sr# 420", "=ds="..BabbleBoss["Loken"] };
				{ 14, "s55396", "41401", "=q3=Insightful Earthsiege Diamond", "=ds=#sr# 420", "#DALARANJW:5#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 16, "s73474", "52300", "=q3=Enigmatic Shadowspirit Diamond", "=ds=#sr# 490", "#CATAJW:4#"..AL["Vendor"] };
				{ 17, "s73467", "52293", "=q3=Eternal Shadowspirit Diamond", "=ds=#sr# 490", "#CATAJW:4#"..AL["Vendor"] };
				{ 18, "s73464", "52289", "=q3=Fleet Shadowspirit Diamond", "=ds=#sr# 490", "#CATAJW:4#"..AL["Vendor"] };
				{ 19, "s73476", "52302", "=q3=Forlorn Shadowspirit Diamond", "=ds=#sr# 490", "#CATAJW:4#"..AL["Vendor"] };
				{ 20, "s73475", "52301", "=q3=Impassive Shadowspirit Diamond", "=ds=#sr# 490", "#CATAJW:4#"..AL["Vendor"] };
				{ 21, "s73473", "52299", "=q3=Powerful Shadowspirit Diamond", "=ds=#sr# 490", "#CATAJW:4#"..AL["Vendor"] };
				{ 22, "s96256", "68779", "=q3=Reverberating Shadowspirit Diamond", "=ds=#sr# 490", "=ds="..AL["World Drop"] };
				{ 23, "s73471", "52297", "=q3=Revitalizing Shadowspirit Diamond", "=ds=#sr# 490", "#CATAJW:4#"..AL["Vendor"] };
				{ 25, "s55404", "41385", "=q3=Invigorating Earthsiege Diamond", "=ds=#sr# 420", "#DALARANJW:5#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 26, "s55402", "41381", "=q3=Persistant Earthsiege Diamond", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 27, "s55399", "41397", "=q3=Powerful Earthsiege Diamond", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 28, "s55400", "41398", "=q3=Relentless Earthsiege Diamond", "=ds=#sr# 420", "#DALARANJW:5#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 29, "s55403", "41382", "=q3=Trenchant Earthsiege Diamond", "=ds=#sr# 420", "#DALARANJW:5#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
			};
			{
				{ 1, "s55389", "41285", "=q3=Chaotic Skyflare Diamond", "=ds=#sr# 420", "#DALARANJW:5#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 2, "s55390", "41307", "=q3=Destructive Skyflare Diamond", "=ds=#sr# 420", "=ds="..AL["World Drop"]..""};
				{ 3, "s55392", "41333", "=q3=Ember Skyflare Diamond", "=ds=#sr# 420", "#DALARANJW:5#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 4, "s55393", "41335", "=q3=Enigmatic Skyflare Diamond", "=ds=#sr# 420", "=ds="..BabbleZone["Wintergrasp"] };
				{ 5, "s55387", "41378", "=q3=Forlorn Skyflare Diamond", "=ds=#sr# 420", "=ds="..BabbleZone["Wintergrasp"] };
				{ 6, "s55388", "41379", "=q3=Impassive Skyflare Diamond", "=ds=#sr# 420", "=ds="..BabbleZone["Wintergrasp"] };
				{ 8, "s46597", "35501", "=q3=Eternal Earthstorm Diamond", "=ds=#sr# 370", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Revered"] };
				{ 9, "s32867", "25897", "=q3=Bracing Earthstorm Diamond", "=ds=#sr# 365", "=ds="..BabbleFaction["The Consortium"].." - "..BabbleFaction["Revered"] };
				{ 10, "s32869", "25899", "=q3=Brutal Earthstorm Diamond", "=ds=#sr# 365", "=ds="..AL["World Drop"] };
				{ 11, "s32870", "25901", "=q3=Insightful Earthstorm Diamond", "=ds=#sr# 365", "=ds="..BabbleFaction["The Sha'tar"].." - "..BabbleFaction["Friendly"] };
				{ 12, "s32866", "25896", "=q3=Powerful Earthstorm Diamond", "=ds=#sr# 365", "=ds="..BabbleFaction["The Consortium"].." - "..BabbleFaction["Honored"] };
				{ 13, "s39961", "32409", "=q3=Relentless Earthstorm Diamond", "=ds=#sr# 365", "=ds="..BabbleFaction["The Consortium"].." - "..BabbleFaction["Exalted"] };
				{ 14, "s32868", "25898", "=q3=Tenacious Earthstorm Diamond", "=ds=#sr# 365", "=ds="..AL["World Drop"] };
				{ 16, "s55407", "41376", "=q3=Revitalizing Skyflare Diamond", "=ds=#sr# 420", "#DALARANJW:5#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 17, "s55384", "41377", "=q3=Shielded Skyflare Diamond", "=ds=#sr# 420", "#DALARANJW:5#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 18, "s55394", "41339", "=q3=Swift Skyflare Diamond", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 19, "s55395", "41400", "=q3=Thundering Skyflare Diamond", "=ds=#sr# 420", "=ds="..AL["World Drop"] };
				{ 20, "s55386", "41375", "=q3=Tireless Skyflare Diamond", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 23, "s46601", "35503", "=q3=Ember Skyfire Diamond", "=ds=#sr# 370", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Revered"] };
				{ 24, "s44794", "34220", "=q3=Chaotic Skyfire Diamond", "=ds=#sr# 365", "=ds="..AL["Drop"]..": "..BabbleZone["Shadowmoon Valley"] };
				{ 25, "s32871", "25890", "=q3=Destructive Skyfire Diamond", "=ds=#sr# 365", "=ds="..AL["World Drop"] };
				{ 26, "s32874", "25895", "=q3=Enigmatic Skyfire Diamond", "=ds=#sr# 365", "=ds="..BabbleFaction["Keepers of Time"].." - "..BabbleFaction["Honored"] };
				{ 27, "s32872", "25893", "=q3=Mystical Skyfire Diamond", "=ds=#sr# 365", "=ds="..AL["World Drop"] };
				{ 28, "s32873", "25894", "=q3=Swift Skyfire Diamond", "=ds=#sr# 365", "=ds="..BabbleFaction["The Consortium"].." - "..BabbleFaction["Honored"] };
				{ 29, "s39963", "32410", "=q3=Thundering Skyfire Diamond", "=ds=#sr# 365", "=ds="..AL["World Drop"] };
			};
		};
		info = {
			name = JEWELCRAFTING..": "..BabbleInventory["Meta"].." "..BabbleInventory["Gem"],
			module = moduleName, menu = "JEWELCRAFTINGMENU"
		};
	};

	AtlasLoot_Data["JewelPrismatic"] = {
		["Normal"] = {
			{
				{ 2, "s68253", "49110", "=q4=Nightmare Tear", "=ds=#sr# 450", "#DALARANJW:4#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 3, "s28028", "22459", "=q4=Void Sphere", "=ds="..GetSpellInfo(7411) };
				{ 4, "s56531", "42702", "=q3=Enchanted Tear", "=ds=#sr# 390", "=ds="..AL["Trainer"] };
				{ 17, "s28027", "22460", "=q3=Prismatic Sphere", "=ds="..GetSpellInfo(7411) };
				{ 18, "s56530", "42701", "=q2=Enchanted Pearl", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 19, "s62941", "42701", "=q2=Prismatic Black Diamond", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = JEWELCRAFTING..": "..BabbleInventory["Prismatic"].." "..BabbleInventory["Gem"],
			module = moduleName, menu = "JEWELCRAFTINGMENU"
		};
	};

	AtlasLoot_Data["JewelDragonsEye"] = {
		["Normal"] = {
			{
				{ 1, "s56049", "42142", "=q4=Bold Dragon's Eye", "=ds=#sr# 370", "#DALARANJW:2#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 2, "s56074", "42148", "=q4=Brilliant Dragon's Eye", "=ds=#sr# 370", "#DALARANJW:2#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 3, "s56052", "42143", "=q4=Delicate Dragon's Eye", "=ds=#sr# 370", "#DALARANJW:2#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 4, "s56056", "42152", "=q4=Flashing Dragon's Eye", "=ds=#sr# 370", "#DALARANJW:2#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 5, "s56081", "42154", "=q4=Precise Dragon's Eye", "=ds=#sr# 370", "#DALARANJW:2#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 7, "s56079", "42158", "=q4=Mystic Dragon's Eye", "=ds=#sr# 370", "#DALARANJW:2#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 8, "s56083", "42150", "=q4=Quick Dragon's Eye", "=ds=#sr# 370", "#DALARANJW:2#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 9, "s56085", "42149", "=q4=Smooth Dragon's Eye", "=ds=#sr# 370", "#DALARANJW:2#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 10, "s56055", "42151", "=q4=Subtle Dragon's Eye", "=ds=#sr# 370", "#DALARANJW:2#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 16, "s56084", "42156", "=q4=Rigid Dragon's Eye", "=ds=#sr# 370", "#DALARANJW:2#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 17, "s56086", "36767", "=q4=Solid Dragon's Eye", "=ds=#sr# 370", "#DALARANJW:2#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 18, "s56087", "42145", "=q4=Sparkling Dragon's Eye", "=ds=#sr# 370", "#DALARANJW:2#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 19, "s56088", "42155", "=q4=Stormy Dragon's Eye", "=ds=#sr# 370", "#DALARANJW:2#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 21, 42225, "", "=q3=Dragon's Eye", "=ds=#e8#", "#DALARANJW:1#"};
			};
		};
		info = {
			name = JEWELCRAFTING..": "..AL["Dragon's Eye"],
			module = moduleName, menu = "JEWELCRAFTINGMENU"
		};
	};

	AtlasLoot_Data["JewelChimerasEye"] = {
		["Normal"] = {
			{
				{ 1, "s73396", "52255", "=q4=Bold Chimera's Eye", "=ds=#sr# 500", "#CATAJW:2#"..AL["Vendor"] };
				{ 2, "s73399", "52257", "=q4=Brilliant Chimera's Eye", "=ds=#sr# 500", "#CATAJW:2#"..AL["Vendor"] };
				{ 3, "s73397", "52258", "=q4=Delicate Chimera's Eye", "=ds=#sr# 500", "#CATAJW:2#"..AL["Vendor"] };
				{ 4, "s73398", "52259", "=q4=Flashing Chimera's Eye", "=ds=#sr# 500", "#CATAJW:2#"..AL["Vendor"] };
				{ 5, "s73400", "52260", "=q4=Precise Chimera's Eye", "=ds=#sr# 500", "#CATAJW:2#"..AL["Vendor"] };
				{ 7, "s73409", "52269", "=q4=Fractured Chimera's Eye", "=ds=#sr# 500", "#CATAJW:2#"..AL["Vendor"] };
				{ 8, "s73407", "52267", "=q4=Mystic Chimera's Eye", "=ds=#sr# 500", "#CATAJW:2#"..AL["Vendor"] };
				{ 9, "s73408", "52268", "=q4=Quick Chimera's Eye", "=ds=#sr# 500", "#CATAJW:2#"..AL["Vendor"] };
				{ 10, "s73406", "52266", "=q4=Smooth Chimera's Eye", "=ds=#sr# 500", "#CATAJW:2#"..AL["Vendor"] };
				{ 11, "s73405", "52265", "=q4=Subtle Chimera's Eye", "=ds=#sr# 500", "#CATAJW:2#"..AL["Vendor"] };
				{ 16, "s73404", "52264", "=q4=Rigid Chimera's Eye", "=ds=#sr# 500", "#CATAJW:2#"..AL["Vendor"] };
				{ 17, "s73401", "52261", "=q4=Solid Chimera's Eye", "=ds=#sr# 500", "#CATAJW:2#"..AL["Vendor"] };
				{ 18, "s73402", "52262", "=q4=Sparkling Chimera's Eye", "=ds=#sr# 500", "#CATAJW:2#"..AL["Vendor"] };
				{ 19, "s73403", "52263", "=q4=Stormy Chimera's Eye", "=ds=#sr# 500", "#CATAJW:2#"..AL["Vendor"] };
				{ 21, 52196, "", "=q3=Chimera's Eye", "=ds=#e8#", "#CATAJW:1#"..AL["Vendor"] };
			};
		};
		info = {
			name = JEWELCRAFTING..": "..AL["Chimera's Eye"],
			module = moduleName, menu = "JEWELCRAFTINGMENU"
		};
	};

	AtlasLoot_Data["JewelTrinket"] = {
		["Normal"] = {
			{
				{ 1, "s73640", "52199", "=q3=Figurine - Demon Panther", "=ds=#sr# 475", "=ds=#QUESTID:25047#" };
				{ 2, "s73643", "52354", "=q3=Figurine - Dream Owl", "=ds=#sr# 475", "=ds=#QUESTID:28777#" };
				{ 3, "s73641", "52352", "=q3=Figurine - Earthen Guardian", "=ds=#sr# 475", "=ds=#QUESTID:28776#" };
				{ 4, "s73642", "52353", "=q3=Figurine - Jeweled Serpent", "=ds=#sr# 475", "=ds=#QUESTID:28775#" };
				{ 5, "s73639", "52351", "=q3=Figurine - King of Boars", "=ds=#sr# 475", "=ds=#QUESTID:28778#" };
				{ 7, "s56203", "42418", "=q3=Figurine - Emerald Boar", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 8, "s59759", "44063", "=q3=Figurine - Monarch Crab", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 9, "s56199", "42341", "=q3=Figurine - Ruby Hare", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 10, "s56202", "42413", "=q3=Figurine - Sapphire Owl", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 11, "s56201", "42395", "=q3=Figurine - Twilight Serpent", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 16, "s46777", "35700", "=q4=Figurine - Crimson Serpent", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Revered"] };
				{ 17, "s46775", "35693", "=q4=Figurine - Empyrean Tortoise", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Revered"] };
				{ 18, "s46776", "35694", "=q4=Figurine - Khorium Boar", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Revered"] };
				{ 19, "s46779", "35703", "=q4=Figurine - Seaspray Albatross", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Revered"] };
				{ 20, "s46778", "35702", "=q4=Figurine - Shadowsong Panther", "=ds=#sr# 375", "=ds="..BabbleFaction["Shattered Sun Offensive"].." - "..BabbleFaction["Revered"] };
				{
					{ 22, "s31080", "24125", "=q3=Figurine - Dawnstone Crab", "=ds=#sr# 370", "=ds="..BabbleFaction["Thrallmar"].." - "..BabbleFaction["Revered"] };
					{ 22, "s31080", "24125", "=q3=Figurine - Dawnstone Crab", "=ds=#sr# 370", "=ds="..BabbleFaction["Honor Hold"].." - "..BabbleFaction["Revered"] };
				};
				{ 23, "s31079", "24124", "=q3=Figurine - Felsteel Boar", "=ds=#sr# 370", "=ds="..BabbleFaction["Lower City"].." - "..BabbleFaction["Revered"] };
				{ 24, "s31081", "24126", "=q3=Figurine - Living Ruby Serpent", "=ds=#sr# 370", "=ds="..BabbleFaction["Keepers of Time"].." - "..BabbleFaction["Revered"] };
				{ 25, "s31083", "24128", "=q3=Figurine - Nightseye Panther", "=ds=#sr# 370", "=ds="..BabbleFaction["Cenarion Expedition"].." - "..BabbleFaction["Revered"] };
				{ 26, "s31082", "24127", "=q3=Figurine - Talasite Owl", "=ds=#sr# 370", "=ds="..BabbleFaction["The Sha'tar"].." - "..BabbleFaction["Revered"] };
			};
			{
				{ 1, "s26912", "21784", "=q3=Figurine - Black Diamond Crab", "=ds=#sr# 300", "=ds="..BabbleBoss["Quartermaster Zigris"] };
				{ 2, "s26914", "21789", "=q3=Figurine - Dark Iron Scorpid", "=ds=#sr# 300", "=ds="..BabbleBoss["Golem Lord Argelmach"] };
				{ 4, "s26909", "21777", "=q2=Figurine - Emerald Owl", "=ds=#sr# 285", "=ds="..AL["World Drop"] };
				{ 5, "s26900", "21769", "=q2=Figurine - Ruby Serpent", "=ds=#sr# 260", "=ds="..AL["World Drop"] };
				{ 6, "s26882", "21763", "=q2=Figurine - Truesilver Boar", "=ds=#sr# 235", "=ds="..AL["World Drop"] };
				{
					{ 7, "s26881", "21760", "=q2=Figurine - Truesilver Crab", "=ds=#sr# 225", "=ds="..AL["Vendor"]..": "..BabbleZone["Northern Stranglethorn"] };
					{ 7, "s26881", "21760", "=q2=Figurine - Truesilver Crab", "=ds=#sr# 225", "=ds="..AL["Vendor"]..": "..BabbleZone["Dustwallow Marsh"] };
				};
				{
					{ 8, "s26875", "21758", "=q2=Figurine - Black Pearl Panther", "=ds=#sr# 215", "=ds="..AL["Vendor"]..": "..BabbleZone["Swamp of Sorrows"] };
					{ 8, "s26875", "21758", "=q2=Figurine - Black Pearl Panther", "=ds=#sr# 215", "=ds="..AL["Vendor"]..": "..BabbleZone["Dustwallow Marsh"] };
				};
				{ 9, "s26873", "21756", "=q2=Figurine - Golden Hare", "=ds=#sr# 200", "=ds="..AL["World Drop"] };
				{ 10, "s26872", "21748", "=q2=Figurine - Jade Owl", "=ds=#sr# 200", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = JEWELCRAFTING..": "..BabbleInventory["Trinket"],
			module = moduleName, menu = "JEWELCRAFTINGMENU"
		};
	};

	AtlasLoot_Data["JewelRing"] = {
		["Normal"] = {
			{
				{ 1, "s73498", "52318", "=q3=Band of Blades", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 2, "s73520", "52348", "=q3=Elementium Destroyer's Ring", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 3, "s73503", "52320", "=q3=Elementium Moebius Band", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 4, "s98921", "69852", "=q3=Punisher's Band", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 5, "s73502", "52319", "=q3=Ring of Warring Elements", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 6, "s99540", "75068", "=q3=Vicious Amberjewel Band", "=ds=#sr# 510", "=ds="..AL["Trainer"] };
				{ 7, "s99541", "75071", "=q3=Vicious Ruby Signet", "=ds=#sr# 510", "=ds="..AL["Trainer"] };
				{ 8, "s99539", "75067", "=q3=Vicious Sapphire Ring", "=ds=#sr# 510", "=ds="..AL["Trainer"] };
				{ 9, "s73495", "52308", "=q2=Hessonite Band", "=ds=#sr# 450", "=ds="..AL["Trainer"] };
				{ 10, "s56497", "42643", "=q4=Titanium Earthguard Ring", "=ds=#sr# 430", "#DALARANJW:6#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 11, "s56496", "42642", "=q4=Titanium Impact Band", "=ds=#sr# 430", "#DALARANJW:6#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 12, "s56498", "42644", "=q4=Titanium Spellshock Ring", "=ds=#sr# 430", "#DALARANJW:6#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 13, "s73494", "52306", "=q2=Jasper Ring", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 14, "s58954", "43582", "=q4=Titanium Frostguard Ring", "=ds=#sr# 420", "#DALARANJW:6#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 15, "s56197", "42340", "=q3=Dream Signet", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 16, "s58147", "43250", "=q3=Ring of Earthen Might", "=ds=#sr# 420", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 17, "s58150", "43253", "=q3=Ring of Northern Tears", "=ds=#sr# 420", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 18, "s58148", "43251", "=q3=Ring of Scarlet Shadows", "=ds=#sr# 420", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 19, "s64727", "45808", "=q3=Runed Mana Band", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 20, "s58507", "43498", "=q3=Savage Titanium Band", "=ds=#sr# 420", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 21, "s58492", "43482", "=q3=Savage Titanium Ring", "=ds=#sr# 420", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 22, "s64728", "45809", "=q3=Scarlet Signet", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 23, "s58149", "43252", "=q3=Windfire Band", "=ds=#sr# 420", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 24, "s58146", "43249", "=q2=Shadowmight Ring", "=ds=#sr# 390", "=ds="..AL["Trainer"] };
				{ 25, "s58145", "43248", "=q2=Stoneguard Band", "=ds=#sr# 390", "=ds="..AL["Trainer"] };
				{ 26, "s38503", "31398", "=q4=The Frozen Eye", "=ds=#sr# 375", "=ds="..BabbleFaction["The Violet Eye"].." - "..BabbleFaction["Honored"] };
				{ 27, "s38504", "31399", "=q4=The Natural Ward", "=ds=#sr# 375", "=ds="..BabbleFaction["Cenarion Expedition"].." - "..BabbleFaction["Exalted"] };
				{ 28, "s46124", "34361", "=q4=Hard Khorium Band", "=ds=#sr# 365", "=ds="..AL["Drop"]..": "..BabbleZone["Sunwell Plateau"] };
				{ 29, "s46122", "34362", "=q4=Loop of Forged Power", "=ds=#sr# 365", "=ds="..AL["Drop"]..": "..BabbleZone["Sunwell Plateau"] };
				{ 30, "s46123", "34363", "=q4=Ring of Flowing Life", "=ds=#sr# 365", "=ds="..AL["Drop"]..": "..BabbleZone["Sunwell Plateau"] };
			};
			{
				{ 1, "s31061", "24089", "=q3=Blazing Eternium Band", "=ds=#sr# 365", "=ds="..AL["World Drop"] };
				{ 2, "s31057", "24086", "=q3=Arcane Khorium Band", "=ds=#sr# 365", "=ds="..AL["Drop"]..": "..BabbleZone["Netherstorm"] };
				{ 3, "s31056", "24085", "=q3=Khorium Band of Leaves", "=ds=#sr# 360", "=ds="..AL["Drop"]..": "..BabbleZone["Blade's Edge Mountains"]};
				{ 4, "s37855", "30825", "=q3=Ring of Arcane Shielding", "=ds=#sr# 360", "=ds="..BabbleFaction["The Sha'tar"].." - "..BabbleFaction["Honored"] };
				{ 5, "s31060", "24088", "=q3=Delicate Eternium Ring", "=ds=#sr# 355", "=ds="..AL["World Drop"] };
				{ 6, "s31054", "24080", "=q3=Khorium Band of Frost", "=ds=#sr# 355", "=ds="..AL["Drop"]..": "..BabbleZone["The Steamvault"] };
				{ 7, "s31055", "24082", "=q3=Khorium Inferno Band", "=ds=#sr# 355", "=ds="..BabbleBoss["Darkweaver Syth"] };
				{ 8, "s58143", "43246", "=q3=Earthshadow Ring", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 9, "s58144", "43247", "=q3=Jade Ring of Slaying", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 10, "s31053", "24079", "=q3=Khorium Band of Shadows", "=ds=#sr# 350", "=ds="..AL["Drop"]..": "..BabbleZone["Shadowmoon Valley"] };
				{ 11, "s56193", "42336", "=q2=Bloodstone Band", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 12, "s56194", "42337", "=q2=Sun Rock Ring", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 13, "s31058", "24087", "=q3=Heavy Felsteel Ring", "=ds=#sr# 345", "=ds="..AL["World Drop"] };
				{ 14, "s31052", "24078", "=q2=Heavy Adamantite Ring", "=ds=#sr# 335", "=ds="..AL["Trainer"] };
				{ 15, "s41415", "32774", "=q3=The Black Pearl", "=ds=#sr# 330", "=ds="..AL["Trainer"] };
				{ 16, "s41414", "32772", "=q3=Brilliant Pearl Band", "=ds=#sr# 325", "=ds="..AL["Trainer"] };
				{ 17, "s31050", "24076", "=q2=Azure Moonstone Ring", "=ds=#sr# 320", "=ds="..AL["Trainer"] };
				{ 18, "s26916", "21779", "=q3=Band of Natural Fire", "=ds=#sr# 310", "=ds="..AL["Trainer"] };
				{ 19, "s31048", "24074", "=q2=Fel Iron Blood Ring", "=ds=#sr# 305", "=ds="..AL["Trainer"] };
				{ 20, "s31049", "24075", "=q2=Golden Draenite Ring", "=ds=#sr# 305", "=ds="..AL["Trainer"] };
				{ 21, "s34961", "29160", "=q2=Emerald Lion Ring", "=ds=#sr# 290", "=ds="..AL["Trainer"] };
				{ 22, "s26910", "21778", "=q2=Ring of Bitter Shadows", "=ds=#sr# 285", "=ds="..AL["Vendor"]..": "..BabbleZone["Eastern Plaguelands"] };
				{ 23, "s34960", "29159", "=q2=Glowing Thorium Band", "=ds=#sr# 280", "=ds="..AL["Trainer"] };
				{ 24, "s26907", "21775", "=q2=Onslaught Ring", "=ds=#sr# 280", "=ds="..AL["Trainer"] };
				{ 25, "s26903", "21768", "=q3=Sapphire Signet", "=ds=#sr# 275", "=ds="..AL["Trainer"] };
				{ 26, "s36526", "30422", "=q2=Diamond Focus Ring", "=ds=#sr# 265", "=ds="..AL["Trainer"] };
				{ 27, "s26902", "21767", "=q2=Simple Opal Ring", "=ds=#sr# 260", "=ds="..AL["Trainer"] };
				{ 28, "s26896", "21753", "=q3=Gem Studded Band", "=ds=#sr# 250", "=ds="..AL["World Drop"] };
				{ 29, "s26887", "21754", "=q2=The Aquamarine Ward", "=ds=#sr# 245", "=ds="..AL["World Drop"] };
				{ 30, "s26885", "21765", "=q2=Truesilver Healing Ring", "=ds=#sr# 240", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s36525", "30421", "=q2=Red Ring of Destruction", "=ds=#sr# 230", "=ds="..AL["Trainer"] };
				{ 2, "s26874", "20964", "=q3=Aquamarine Signet", "=ds=#sr# 210", "=ds="..AL["Trainer"] };
				{ 3, "s34959", "29158", "=q3=Truesilver Commander's Ring", "=ds=#sr# 200", "=ds="..AL["Trainer"] };
				{ 4, "s34955", "29157", "=q3=Golden Ring of Power", "=ds=#sr# 180", "=ds="..AL["Trainer"] };
				{ 5, "s25621", "20961", "=q2=Citrine Ring of Rapid Healing", "=ds=#sr# 180", "=ds="..AL["Trainer"] };
				{ 6, "s25620", "20960", "=q2=Engraved Truesilver Ring", "=ds=#sr# 170", "=ds="..AL["Trainer"] };
				{ 7, "s25619", "20959", "=q2=The Jade Eye", "=ds=#sr# 170", "=ds="..AL["Vendor"] };
				{ 8, "s25617", "20958", "=q2=Blazing Citrine Ring", "=ds=#sr# 150", "=ds="..AL["Trainer"] };
				{ 9, "s25613", "20955", "=q2=Golden Dragon Ring", "=ds=#sr# 135", "=ds="..AL["Trainer"] };
				{ 10, "s25323", "20833", "=q2=Wicked Moonstone Ring", "=ds=#sr# 125", "=ds="..AL["Vendor"] };
				{ 11, "s36524", "30420", "=q2=Heavy Jade Ring", "=ds=#sr# 105", "=ds="..AL["Trainer"] };
				{ 12, "s25318", "20828", "=q2=Ring of Twilight Shadows", "=ds=#sr# 100", "=ds="..AL["Trainer"] };
				{ 13, "s25305", "20826", "=q3=Heavy Silver Ring", "=ds=#sr# 90", "=ds="..AL["Trainer"] };
				{ 14, "s25317", "20827", "=q2=Ring of Silver Might", "=ds=#sr# 80", "=ds="..AL["Trainer"] };
				{ 15, "s25287", "20823", "=q2=Gloom Band", "=ds=#sr# 70", "=ds="..AL["Trainer"] };
				{ 16, "s37818", "30804", "=q3=Bronze Band of Force", "=ds=#sr# 65", "=ds="..AL["Trainer"] };
				{ 17, "s25284", "20820", "=q2=Simple Pearl Ring", "=ds=#sr# 60", "=ds="..AL["Trainer"] };
				{ 18, "s25280", "20818", "=q2=Elegant Silver Ring", "=ds=#sr# 50", "=ds="..AL["Trainer"] };
				{ 19, "s25490", "20907", "=q2=Solid Bronze Ring", "=ds=#sr# 50", "=ds="..AL["Trainer"] };
				{ 20, "s25283", "20821", "=q2=Inlaid Malachite Ring", "=ds=#sr# 30", "=ds="..AL["Trainer"] };
				{ 21, "s32179", "25439", "=q2=Tigerseye Band", "=ds=#sr# 20", "=ds="..AL["Trainer"] };
				{ 22, "s26926", "21932", "=q2=Heavy Copper Ring", "=ds=#sr# 5", "=ds="..AL["Trainer"] };
				{ 23, "s25493", "20906", "=q2=Braided Copper Ring", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
				{ 24, "s26925", "21931", "=q2=Woven Copper Ring", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = JEWELCRAFTING..": "..BabbleInventory["Ring"],
			module = moduleName, menu = "JEWELCRAFTINGMENU"
		};
	};

	AtlasLoot_Data["JewelNeck"] = {
		["Normal"] = {
			{
				{ 1, "s73521", "52350", "=q3=Brazen Elementium Medallion", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 2, "s73506", "52323", "=q3=Elementium Guardian", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 3, "s73504", "52321", "=q3=Entwined Elementium Choker", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 4, "s73505", "52322", "=q3=Eye of Many Deaths", "=ds=#sr# 525", "#CATAJW:5#"..AL["Vendor"] };
				{ 5, "s99543", "75075", "=q3=Vicious Amberjewel Pendant", "=ds=#sr# 520", "=ds="..AL["Trainer"] };
				{ 6, "s99544", "75078", "=q3=Vicious Ruby Choker", "=ds=#sr# 520", "=ds="..AL["Trainer"] };
				{ 7, "s99542", "75074", "=q3=Vicious Sapphire Necklace", "=ds=#sr# 520", "=ds="..AL["Trainer"] };
				{ 8, "s73497", "52309", "=q2=Nightstone Choker", "=ds=#sr# 460", "=ds="..AL["Trainer"] };
				{ 9, "s56500", "42646", "=q4=Titanium Earthguard Chain", "=ds=#sr# 440", "#DALARANJW:6#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 10, "s56499", "42645", "=q4=Titanium Impact Choker", "=ds=#sr# 440", "#DALARANJW:6#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 11, "s56501", "42647", "=q4=Titanium Spellshock Necklace", "=ds=#sr# 440", "#DALARANJW:6#"..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 12, "s73496", "52307", "=q2=Alicite Pendant", "=ds=#sr# 435", "=ds="..AL["Trainer"] };
				{ 13, "s64725", "45812", "=q3=Emerald Choker", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 14, "s64726", "45813", "=q3=Sky Sapphire Amulet", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 15, "s56196", "42339", "=q3=Blood Sun Necklace", "=ds=#sr# 380", "=ds="..AL["Trainer"] };
				{ 16, "s56195", "42338", "=q3=Jade Dagger Pendant", "=ds=#sr# 380", "=ds="..AL["Trainer"] };
				{ 17, "s46126", "34360", "=q4=Amulet of Flowing Life", "=ds=#sr# 365", "=ds="..AL["Drop"]..": "..BabbleZone["Sunwell Plateau"] };
				{ 18, "s46127", "34358", "=q4=Hard Khorium Choker", "=ds=#sr# 365", "=ds="..AL["Drop"]..": "..BabbleZone["Sunwell Plateau"] };
				{ 19, "s46125", "34359", "=q4=Pendant of Sunfire", "=ds=#sr# 365", "=ds="..AL["Drop"]..": "..BabbleZone["Sunwell Plateau"] };
				{ 20, "s31076", "24121", "=q3=Chain of the Twilight Owl", "=ds=#sr# 365", "=ds="..AL["World Drop"] };
				{ 21, "s31072", "24117", "=q3=Embrace of the Dawn", "=ds=#sr# 365", "=ds="..AL["World Drop"] };
				{ 22, "s31070", "24114", "=q3=Braided Eternium Chain", "=ds=#sr# 360", "=ds="..AL["World Drop"] };
				{ 23, "s31071", "24116", "=q3=Eye of the Night", "=ds=#sr# 360", "=ds="..AL["World Drop"] };
				{ 24, "s31062", "24092", "=q3=Pendant of Frozen Flame", "=ds=#sr# 360", "=ds="..BabbleFaction["Keepers of Time"].." - "..BabbleFaction["Revered"] };
				{ 25, "s31065", "24097", "=q3=Pendant of Shadow's End", "=ds=#sr# 360", "=ds="..BabbleFaction["The Aldor"].." - "..BabbleFaction["Revered"] };
				{ 26, "s31063", "24093", "=q3=Pendant of Thawing", "=ds=#sr# 360", "=ds="..BabbleFaction["Lower City"].." - "..BabbleFaction["Revered"] };
				{ 27, "s31066", "24098", "=q3=Pendant of the Null Rune", "=ds=#sr# 360", "=ds="..BabbleFaction["The Consortium"].." - "..BabbleFaction["Revered"] };
				{ 28, "s31064", "24095", "=q3=Pendant of Withering", "=ds=#sr# 360", "=ds="..BabbleFaction["The Scryers"].." - "..BabbleFaction["Revered"] };
				{ 29, "s31068", "24110", "=q3=Living Ruby Pendant", "=ds=#sr# 355", "=ds="..AL["World Drop"] };
				{ 30, "s31067", "24106", "=q3=Thick Felsteel Necklace", "=ds=#sr# 355", "=ds="..AL["World Drop"] };
			};
			{
				{ 1, "s58142", "43245", "=q2=Crystal Chalcedony Amulet", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 2, "s58141", "43244", "=q2=Crystal Citrine Necklace", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 3, "s40514", "32508", "=q3=Necklace of the Deep", "=ds=#sr# 340", "=ds="..AL["Trainer"] };
				{ 4, "s31051", "24077", "=q2=Thick Adamantite Necklace", "=ds=#sr# 335", "=ds="..AL["Trainer"] };
				{ 5, "s26915", "21792", "=q3=Necklace of the Diamond Tower", "=ds=#sr# 305", "=ds="..AL["Vendor"]..": "..BabbleZone["Winterspring"] };
				{ 6, "s26911", "21791", "=q3=Living Emerald Pendant", "=ds=#sr# 290", "=ds="..AL["Trainer"] };
				{ 7, "s26908", "21790", "=q2=Sapphire Pendant of Winter Night", "=ds=#sr# 280", "=ds="..AL["Trainer"] };
				{ 8, "s26897", "21766", "=q3=Opal Necklace of Impact", "=ds=#sr# 250", "=ds="..AL["Vendor"] };
				{ 9, "s26883", "21764", "=q2=Ruby Pendant of Fire", "=ds=#sr# 235", "=ds="..AL["Trainer"] };
				{ 10, "s26876", "21755", "=q2=Aquamarine Pendant of the Warrior", "=ds=#sr# 220", "=ds="..AL["Trainer"] };
				{ 11, "s63743", "45627", "=q3=Amulet of Truesight", "=ds=#sr# 200", "=ds="..AL["Trainer"] };
				{ 12, "s25622", "20967", "=q2=Citrine Pendant of Golden Healing", "=ds=#sr# 190", "=ds="..AL["World Drop"] };
				{ 13, "s25618", "20966", "=q2=Jade Pendant of Blasting", "=ds=#sr# 160", "=ds="..AL["World Drop"] };
				{ 14, "s25320", "20831", "=q2=Heavy Golden Necklace of Battle", "=ds=#sr# 150", "=ds="..AL["Vendor"] };
				{ 15, "s25610", "20950", "=q2=Pendant of the Agate Shield", "=ds=#sr# 120", "=ds="..AL["Trainer"] };
				{ 16, "s25339", "20830", "=q2=Amulet of the Moon", "=ds=#sr# 110", "=ds="..AL["Vendor"] };
				{ 17, "s25498", "20909", "=q2=Barbaric Iron Collar", "=ds=#sr# 110", "=ds="..AL["Trainer"] };
				{ 18, "s38175", "31154", "=q2=Bronze Torc", "=ds=#sr# 80", "=ds="..AL["Trainer"] };
				{ 19, "s36523", "30419", "=q2=Brilliant Necklace", "=ds=#sr# 75", "=ds="..AL["Trainer"] };
				{ 20, "s26927", "21933", "=q2=Thick Bronze Necklace", "=ds=#sr# 50", "=ds="..AL["Trainer"] };
				{ 21, "s26928", "21934", "=q2=Ornate Tigerseye Necklace", "=ds=#sr# 30", "=ds="..AL["Trainer"] };
				{ 22, "s32178", "25438", "=q2=Malachite Pendant", "=ds=#sr# 20", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = JEWELCRAFTING..": "..BabbleInventory["Neck"],
			module = moduleName, menu = "JEWELCRAFTINGMENU"
		};
	};

	AtlasLoot_Data["JewelMisc"] = {
		["Normal"] = {
			{
				{ 1, "s73623", "52489", "=q3=Rhinestone Sunglasses", "=ds=#sr# 525", "=ds="..AL["World Drop"] };
				{ 2, "s73478", "52304", "=q3=Fire Prism", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 3, "s73621", "52493", "=q3=The Perforator", "=ds=#sr# 490", "=ds="..AL["Trainer"] };
				{ 4, "s73627", "52487", "=q3=Jeweler's Amber Monocle", "=ds=#sr# 460", "=ds="..AL["World Drop"] };
				{ 5, "s73620", "52492", "=q2=Carnelian Spikes", "=ds=#sr# 460", "=ds="..AL["Trainer"] };
				{ 6, "s73626", "52486", "=q3=Jeweler's Sapphire Monocle", "=ds=#sr# 455", "=ds="..AL["World Drop"] };
				{ 7, "s73625", "52485", "=q3=Jeweler's Ruby Monocle", "=ds=#sr# 450", "=ds="..AL["World Drop"] };
				{ 8, "s73622", "52490", "=q1=Stardust", "=ds=#sr# 435", "=ds="..AL["Trainer"] };
				{ 9, "s62242", "44943", "=q3=Icy Prism", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 10, "s31078", "24123", "=q4=Circlet of Arcane Might", "=ds=#sr# 370", "=ds="..BabbleZone["Old Hillsbrad Foothills"] };
				{ 11, "s31077", "24122", "=q4=Coronet of the Verdant Flame", "=ds=#sr# 370", "=ds="..BabbleZone["The Botanica"] };
				{ 12, "s41418", "32776", "=q3=Crown of the Sea Witch", "=ds=#sr# 365", "=ds="..AL["Trainer"] };
				{ 13, "s47280", "35945", "=q3=Brilliant Glass", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 14, "s56208", "42421", "=q2=Shadow Jade Focusing Lens", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 15, "s56206", "42420", "=q2=Shadow Crystal Focusing Lens", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 16, "s56205", "41367", "=q2=Dark Jade Focusing Lens", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 17, "s38068", "31079", "=q3=Mercurial Adamantite", "=ds=#sr# 325", "=ds="..AL["Trainer"] };
				{ 18, "s26906", "21774", "=q3=Emerald Crown of Destruction", "=ds=#sr# 275", "=ds="..AL["Vendor"]..": "..BabbleZone["Silithus"] };
				{ 19, "s26878", "20969", "=q3=Ruby Crown of Restoration", "=ds=#sr# 225", "=ds="..AL["Vendor"]..": "..BabbleZone["Arathi Highlands"] };
				{ 20, "s26880", "21752", "=q1=Thorium Setting", "=ds=#sr# 225", "=ds="..AL["Trainer"]};
				{ 21, "s32809", "25883", "=q1=Dense Stone Statue", "=ds=#sr# 225", "=ds="..AL["Trainer"]};
				{ 22, "s32808", "25882", "=q1=Solid Stone Statue", "=ds=#sr# 175", "=ds="..AL["Trainer"]};
				{ 23, "s25615", "20963", "=q1=Mithril Filigree", "=ds=#sr# 150", "=ds="..AL["Trainer"]};
				{ 24, "s25612", "20954", "=q2=Heavy Iron Knuckles", "=ds=#sr# 125", "=ds="..AL["Trainer"]};
				{ 25, "s25321", "20832", "=q3=Moonsoul Crown", "=ds=#sr# 120", "=ds="..AL["Trainer"]};
				{ 26, "s32807", "25881", "=q1=Heavy Stone Statue", "=ds=#sr# 110", "=ds="..AL["Trainer"]};
				{ 27, "s25278", "20817", "=q1=Bronze Setting", "=ds=#sr# 50", "=ds="..AL["Trainer"]};
				{ 28, "s32801", "25880", "=q1=Coarse Stone Statue", "=ds=#sr# 50", "=ds="..AL["Trainer"]};
				{ 29, "s25255", "20816", "=q1=Delicate Copper Wire", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
				{ 30, "s32259", "25498", "=q1=Rough Stone Statue", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = JEWELCRAFTING..": "..BabbleInventory["Miscellaneous"],
			module = moduleName, menu = "JEWELCRAFTINGMENU"
		};
	};

		----------------------
		--- Leatherworking ---
		----------------------

	AtlasLoot_Data["LeatherLeatherArmorOld"] = {
		["Normal"] = {
			{
				{ 1, "s23709", "19162", "=q4=Corehound Belt", "=ds=#sr# 300"};
				{ 2, "s22927", "18510", "=q4=Hide of the Wild", "=ds=#sr# 300"};
				{ 3, "s23707", "19149", "=q4=Lava Belt", "=ds=#sr# 300"};
				{ 4, "s23710", "19163", "=q4=Molten Belt", "=ds=#sr# 300"};
				{ 5, "s20854", "16983", "=q4=Molten Helm", "=ds=#sr# 300"};
				{ 6, "s28221", "22663", "=q4=Polar Bracers", "=ds=#sr# 300"};
				{ 7, "s28220", "22662", "=q4=Polar Gloves", "=ds=#sr# 300"};
				{ 8, "s28219", "22661", "=q4=Polar Tunic", "=ds=#sr# 300"};
				{ 9, "s24124", "19688", "=q3=Blood Tiger Breastplate", "=ds=#sr# 300"};
				{ 10, "s24125", "19689", "=q3=Blood Tiger Shoulders", "=ds=#sr# 300"};
				{ 11, "s28474", "22761", "=q3=Bramblewood Belt", "=ds=#sr# 300"};
				{ 12, "s28473", "22760", "=q3=Bramblewood Boots", "=ds=#sr# 300"};
				{ 13, "s28472", "22759", "=q3=Bramblewood Helm", "=ds=#sr# 300"};
				{ 14, "s19097", "15062", "=q3=Devilsaur Leggings", "=ds=#sr# 300"};
				{ 15, "s22921", "18504", "=q3=Girdle of Insight", "=ds=#sr# 300"};
				{ 16, "s23706", "19058", "=q3=Golden Mantle of the Dawn", "=ds=#sr# 300"};
				{ 17, "s19095", "15059", "=q3=Living Breastplate", "=ds=#sr# 300"};
				{ 18, "s22922", "18506", "=q3=Mongoose Boots", "=ds=#sr# 300"};
				{ 19, "s24123", "19687", "=q3=Primal Batskin Bracers", "=ds=#sr# 300"};
				{ 20, "s24122", "19686", "=q3=Primal Batskin Gloves", "=ds=#sr# 300"};
				{ 21, "s24121", "19685", "=q3=Primal Batskin Jerkin", "=ds=#sr# 300"};
				{ 22, "s26279", "21278", "=q3=Stormshroud Gloves", "=ds=#sr# 300"};
				{ 23, "s23704", "19049", "=q3=Timbermaw Brawlers", "=ds=#sr# 300"};
				{ 24, "s19104", "15068", "=q2=Frostsaber Tunic", "=ds=#sr# 300"};
				{ 25, "s19102", "15090", "=q2=Runic Leather Armor", "=ds=#sr# 300"};
				{ 26, "s19091", "15095", "=q2=Runic Leather Pants", "=ds=#sr# 300"};
				{ 27, "s19103", "15096", "=q2=Runic Leather Shoulders", "=ds=#sr# 300"};
				{ 28, "s19101", "15055", "=q2=Volcanic Shoulders", "=ds=#sr# 300"};
				{ 29, "s19098", "15085", "=q2=Wicked Leather Armor", "=ds=#sr# 300"};
				{ 30, "s19092", "15088", "=q2=Wicked Leather Belt", "=ds=#sr# 300"};
			};
			{
				{ 1, "s20853", "16982", "=q4=Corehound Boots", "=ds=#sr# 295"};
				{ 2, "s19090", "15058", "=q3=Stormshroud Shoulders", "=ds=#sr# 295"};
				{ 3, "s19087", "15070", "=q2=Frostsaber Gloves", "=ds=#sr# 295"};
				{ 4, "s23705", "19052", "=q3=Dawn Treaders", "=ds=#sr# 290"};
				{ 5, "s19084", "15063", "=q3=Devilsaur Gauntlets", "=ds=#sr# 290"};
				{ 6, "s19086", "15066", "=q3=Ironfeather Breastplate", "=ds=#sr# 290"};
				{ 7, "s23703", "19044", "=q3=Might of the Timbermaw", "=ds=#sr# 290"};
				{ 8, "s19081", "15075", "=q2=Chimeric Vest", "=ds=#sr# 290"};
				{ 9, "s19082", "15094", "=q2=Runic Leather Headband", "=ds=#sr# 290"};
				{ 10, "s19083", "15087", "=q2=Wicked Leather Pants", "=ds=#sr# 290"};
				{ 11, "s19078", "15060", "=q3=Living Leggings", "=ds=#sr# 285"};
				{ 12, "s19079", "15056", "=q3=Stormshroud Armor", "=ds=#sr# 285"};
				{ 13, "s19080", "15065", "=q3=Warbear Woolies", "=ds=#sr# 285"};
				{ 14, "s19074", "15069", "=q2=Frostsaber Leggings", "=ds=#sr# 285"};
				{ 15, "s19076", "15053", "=q2=Volcanic Breastplate", "=ds=#sr# 285"};
				{ 16, "s44953", "34086", "=q1=Winter Boots", "=ds=#sr# 285", "=ds="..AL["Feast of Winter Veil"]};
				{ 17, "s19073", "15072", "=q2=Chimeric Leggings", "=ds=#sr# 280", "=ds="..AL["World Drop"]};
				{ 18, "s19072", "15093", "=q2=Runic Leather Belt", "=ds=#sr# 280", "=ds="..AL["Trainer"]};
				{ 19, "s19071", "15086", "=q2=Wicked Leather Headband", "=ds=#sr# 280", "=ds="..AL["Trainer"]};
				{ 20, "s19067", "15057", "=q3=Stormshroud Pants", "=ds=#sr# 275", "=ds="..AL["Vendor"]};
				{ 21, "s19068", "15064", "=q3=Warbear Harness", "=ds=#sr# 275", "=ds="..AL["Vendor"]};
				{ 22, "s19063", "15073", "=q2=Chimeric Boots", "=ds=#sr# 275", "=ds="..AL["World Drop"]};
				{ 23, "s19065", "15092", "=q2=Runic Leather Bracers", "=ds=#sr# 275", "=ds="..AL["Trainer"]};
				{ 24, "s19066", "15071", "=q2=Frostsaber Boots", "=ds=#sr# 275", "=ds="..AL["Vendor"]};
				{ 25, "s19062", "15067", "=q3=Ironfeather Shoulders", "=ds=#sr# 270", "=ds="..AL["Vendor"]};
				{ 26, "s19061", "15061", "=q3=Living Shoulders", "=ds=#sr# 270", "=ds="..AL["Vendor"]};
				{ 27, "s19055", "15091", "=q2=Runic Leather Gauntlets", "=ds=#sr# 270", "=ds="..AL["Trainer"]};
				{ 28, "s19059", "15054", "=q2=Volcanic Leggings", "=ds=#sr# 270", "=ds="..AL["Drop"]};
				{ 29, "s19053", "15074", "=q2=Chimeric Gloves", "=ds=#sr# 265", "=ds=???"};--pattern removed with Cataclysm
				{ 30, "s19052", "15084", "=q2=Wicked Leather Bracers", "=ds=#sr# 265", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, "s36074", "29964", "=q3=Blackstorm Leggings", "=ds=#sr# 260", "=ds="..AL["Trainer"]};
				{ 2, "s36075", "29970", "=q3=Wildfeather Leggings", "=ds=#sr# 260", "=ds="..AL["Trainer"]};
				{ 3, "s19049", "15083", "=q2=Wicked Leather Gauntlets", "=ds=#sr# 260", "=ds="..AL["Vendor"]};
				{ 4, "s10647", "8349", "=q3=Feathered Breastplate", "=ds=#sr# 250", "=ds="..AL["Trainer"]};
				{ 5, "s10632", "8348", "=q3=Helm of Fire", "=ds=#sr# 250", "=ds="..AL["Trainer"]};
				{
					{ 6, "s10572", "8212", "=q2=Wild Leather Leggings", "=ds=#sr# 250", "=ds=#QUESTID:2859#"};
					{ 6, "s10572", "8212", "=q2=Wild Leather Leggings", "=ds=#sr# 250", "=ds=#QUESTID:2852#"};
				};
				{
					{ 7, "s10566", "8213", "=q2=Wild Leather Boots", "=ds=#sr# 245", "=ds=#QUESTID:2858#"};
					{ 7, "s10566", "8213", "=q2=Wild Leather Boots", "=ds=#sr# 245", "=ds=#QUESTID:2851#"};
				};
				{ 8, "s10560", "8202", "=q2=Big Voodoo Pants", "=ds=#sr# 240", "=ds="..AL["World Drop"]};
				{ 9, "s10558", "8197", "=q2=Nightscape Boots", "=ds=#sr# 235", "=ds="..AL["Trainer"]};
				{ 10, "s10630", "8346", "=q3=Gauntlets of the Sea", "=ds=#sr# 230", "=ds="..AL["Trainer"]};
				{ 11, "s10548", "8193", "=q2=Nightscape Pants", "=ds=#sr# 230", "=ds="..AL["Trainer"]};
				{ 12, "s10621", "8345", "=q3=Wolfshead Helm", "=ds=#sr# 225"};
				{
					{ 13, "s10546", "8214", "=q2=Wild Leather Helmet", "=ds=#sr# 225", "=ds=#QUESTID:2857#"};
					{ 13, "s10546", "8214", "=q2=Wild Leather Helmet", "=ds=#sr# 225", "=ds=#QUESTID:2850#"};
				};
				{
					{ 14, "s10544", "8211", "=q2=Wild Leather Vest", "=ds=#sr# 225", "=ds=#QUESTID:2856#"};
					{ 14, "s10544", "8211", "=q2=Wild Leather Vest", "=ds=#sr# 225", "=ds=#QUESTID:2849#"};
				};
				{ 15, "s10531", "8201", "=q2=Big Voodoo Mask", "=ds=#sr# 220", "=ds="..AL["World Drop"]};
				{
					{ 16, "s10529", "8210", "=q2=Wild Leather Shoulders", "=ds=#sr# 220", "=ds=#QUESTID:2855#"};
					{ 16, "s10529", "8210", "=q2=Wild Leather Shoulders", "=ds=#sr# 220", "=ds=#QUESTID:2848#"};
				};
				{ 17, "s10520", "8200", "=q2=Big Voodoo Robe", "=ds=#sr# 215", "=ds="..AL["World Drop"]};
				{ 18, "s10516", "8192", "=q2=Nightscape Shoulders", "=ds=#sr# 210", "=ds="..AL["Vendor"]};
				{ 19, "s10507", "8176", "=q2=Nightscape Headband", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 20, "s10499", "8175", "=q2=Nightscape Tunic", "=ds=#sr# 205", "=ds="..AL["Trainer"]};
				{ 21, "s10490", "8174", "=q3=Comfortable Leather Hat", "=ds=#sr# 200", "=ds="..AL["World Drop"]};
				{ 22, "s3779", "4264", "=q2=Barbaric Belt", "=ds=#sr# 200", "=ds="..AL["World Drop"]};
				{ 23, "s9207", "7390", "=q2=Dusky Boots", "=ds=#sr# 200", "=ds="..AL["World Drop"]};
				{ 24, "s22711", "18238", "=q3=Shadowskin Gloves", "=ds=#sr# 200", "=ds="..AL["Vendor"]};
				{ 25, "s9208", "7391", "=q2=Swift Boots", "=ds=#sr# 200", "=ds="..AL["World Drop"]};
				{ 26, "s9206", "7387", "=q2=Dusky Belt", "=ds=#sr# 195", "=ds="..AL["Trainer"]};
				{ 27, "s3777", "4260", "=q2=Guardian Leather Bracers", "=ds=#sr# 195", "=ds="..AL["World Drop"]};
				{ 28, "s21943", "17721", "=q2=Gloves of the Greatfather", "=ds=#sr# 190", "=ds="..AL["Feast of Winter Veil"]};
				{ 29, "s9202", "7386", "=q2=Green Whelp Bracers", "=ds=#sr# 190", "=ds="..AL["Vendor"]};
				{ 30, "s6705", "5783", "=q2=Murloc Scale Bracers", "=ds=#sr# 190", "=ds="..AL["Vendor"]};
			};
			{
				{ 1, "s6661", "5739", "=q1=Barbaric Harness", "=ds=#sr# 190", "=ds="..AL["Trainer"]};
				{ 2, "s7156", "5966", "=q1=Guardian Gloves", "=ds=#sr# 190", "=ds="..AL["Trainer"]};
				{ 3, "s3778", "4262", "=q3=Gem-studded Leather Belt", "=ds=#sr# 185", "=ds="..AL["Vendor"]};
				{ 4, "s9201", "7378", "=q2=Dusky Bracers", "=ds=#sr# 185", "=ds="..AL["Trainer"]};
				{ 5, "s3776", "4259", "=q2=Green Leather Bracers", "=ds=#sr# 180", "=ds="..AL["Trainer"]};
				{ 6, "s7151", "5964", "=q2=Barbaric Shoulders", "=ds=#sr# 175", "=ds="..AL["Trainer"]};
				{ 7, "s9196", "7374", "=q2=Dusky Leather Armor", "=ds=#sr# 175", "=ds="..AL["Trainer"]};
				{ 8, "s9197", "7375", "=q2=Green Whelp Armor", "=ds=#sr# 175", "=ds="..AL["World Drop"]};
				{ 9, "s3773", "4256", "=q2=Guardian Armor", "=ds=#sr# 175", "=ds="..AL["World Drop"]};
				{ 10, "s7149", "5963", "=q2=Barbaric Leggings", "=ds=#sr# 170", "=ds="..AL["Vendor"]};
				{ 11, "s3775", "4258", "=q2=Guardian Belt", "=ds=#sr# 170", "=ds="..AL["World Drop"]};
				{ 12, "s6704", "5782", "=q2=Thick Murloc Armor", "=ds=#sr# 170", "=ds="..AL["Vendor"]};
				{ 13, "s9195", "7373", "=q2=Dusky Leather Leggings", "=ds=#sr# 165", "=ds="..AL["World Drop"]};
				{ 14, "s4097", "4456", "=q2=Raptor Hide Belt", "=ds=#sr# 165", "=ds="..AL["Vendor"]};
				{ 15, "s4096", "4455", "=q2=Raptor Hide Harness", "=ds=#sr# 165", "=ds="..AL["Vendor"]};
				{ 16, "s3774", "4257", "=q2=Green Leather Belt", "=ds=#sr# 160", "=ds="..AL["Trainer"]};
				{ 17, "s7147", "5962", "=q2=Guardian Pants", "=ds=#sr# 160", "=ds="..AL["Trainer"]};
				{ 18, "s23399", "18948", "=q3=Barbaric Bracers", "=ds=#sr# 155", "=ds="..AL["Vendor"]};
				{ 19, "s3772", "4255", "=q2=Green Leather Armor", "=ds=#sr# 155", "=ds="..AL["Vendor"]};
				{ 20, "s3771", "4254", "=q2=Barbaric Gloves", "=ds=#sr# 150", "=ds="..AL["World Drop"]};
				{ 21, "s9149", "7359", "=q2=Heavy Earthen Gloves", "=ds=#sr# 145", "=ds="..AL["World Drop"]};
				{ 22, "s3764", "4247", "=q2=Hillman's Leather Gloves", "=ds=#sr# 145", "=ds="..AL["Trainer"]};
				{ 23, "s3769", "4252", "=q2=Dark Leather Shoulders", "=ds=#sr# 140", "=ds="..AL["World Drop"]};
				{ 24, "s9148", "7358", "=q2=Pilferer's Gloves", "=ds=#sr# 140", "=ds="..AL["World Drop"]};
				{ 25, "s3770", "4253", "=q3=Toughened Leather Gloves", "=ds=#sr# 135", "=ds="..AL["Trainer"]};
				{ 26, "s9147", "7352", "=q2=Earthen Leather Shoulders", "=ds=#sr# 135", "=ds="..AL["Vendor"]};
				{ 27, "s9146", "7349", "=q2=Herbalist's Gloves", "=ds=#sr# 135", "=ds="..AL["Vendor"]};
				{ 28, "s3768", "4251", "=q2=Hillman's Shoulders", "=ds=#sr# 130", "=ds="..AL["Trainer"]};
				{ 29, "s9145", "7348", "=q3=Fletcher's Gloves", "=ds=#sr# 125", "=ds="..AL["Trainer"]};
				{ 30, "s3766", "4249", "=q2=Dark Leather Belt", "=ds=#sr# 125", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, "s2166", "2314", "=q3=Toughened Leather Armor", "=ds=#sr# 120", "=ds="..AL["Trainer"]};
				{ 2, "s3765", "4248", "=q2=Dark Leather Gloves", "=ds=#sr# 120", "=ds="..AL["World Drop"]};
				{ 3, "s3767", "4250", "=q2=Hillman's Belt", "=ds=#sr# 120", "=ds="..AL["World Drop"]};
				{ 4, "s9074", "7285", "=q2=Nimble Leather Gloves", "=ds=#sr# 120", "=ds="..AL["Trainer"]};
				{ 5, "s9072", "7284", "=q2=Red Whelp Gloves", "=ds=#sr# 120", "=ds="..AL["Vendor"]};
				{ 6, "s7955", "6468", "=q3=Deviate Scale Belt", "=ds=#sr# 115", "=ds="..BabbleInventory["Quest"]};--quest was removed with Cataclysm
				{ 7, "s7135", "5961", "=q2=Dark Leather Pants", "=ds=#sr# 115", "=ds="..AL["Trainer"]};
				{ 8, "s7954", "6467", "=q2=Deviate Scale Gloves", "=ds=#sr# 105", "=ds="..AL["Vendor"]};
				{ 9, "s7133", "5958", "=q2=Fine Leather Pants", "=ds=#sr# 105", "=ds="..AL["World Drop"]};
				{ 10, "s24940", "20575", "=q2=Black Whelp Tunic", "=ds=#sr# 100", "=ds="..AL["Vendor"]};
				{ 11, "s2167", "2315", "=q2=Dark Leather Boots", "=ds=#sr# 100", "=ds="..AL["Trainer"]};
				{ 12, "s2169", "2317", "=q2=Dark Leather Tunic", "=ds=#sr# 100", "=ds="..AL["World Drop"]};
				{ 13, "s3762", "4244", "=q2=Hillman's Leather Vest", "=ds=#sr# 100", "=ds="..AL["World Drop"]};
				{ 14, "s9068", "7282", "=q2=Light Leather Pants", "=ds=#sr# 95", "=ds="..AL["Trainer"]};
				{ 15, "s6703", "5781", "=q2=Murloc Scale Breastplate", "=ds=#sr# 95", "=ds="..AL["Vendor"]};
				{ 16, "s2158", "2307", "=q2=Fine Leather Boots", "=ds=#sr# 90", "=ds="..AL["World Drop"]};
				{ 17, "s8322", "6709", "=q2=Moonglow Vest", "=ds=#sr# 90", "=ds=#QUESTID:1582#"};
				{ 18, "s6702", "5780", "=q2=Murloc Scale Belt", "=ds=#sr# 90", "=ds="..AL["Vendor"]};
				{ 19, "s3761", "4243", "=q2=Fine Leather Tunic", "=ds=#sr# 85", "=ds="..AL["Trainer"]};
				{ 20, "s3763", "4246", "=q2=Fine Leather Belt", "=ds=#sr# 80", "=ds="..AL["Trainer"]};
				{ 21, "s3759", "4242", "=q2=Embossed Leather Pants", "=ds=#sr# 75", "=ds="..AL["Trainer"]};
				{ 22, "s2164", "2312", "=q2=Fine Leather Gloves", "=ds=#sr# 75", "=ds="..AL["World Drop"]};
				{ 23, "s9065", "7281", "=q2=Light Leather Bracers", "=ds=#sr# 70", "=ds="..AL["Trainer"]};
				{ 24, "s2163", "2311", "=q2=White Leather Jerkin", "=ds=#sr# 60", "=ds="..AL["World Drop"]};
				{ 25, "s2161", "2309", "=q2=Embossed Leather Boots", "=ds=#sr# 55", "=ds="..AL["Trainer"]};
				{ 26, "s3756", "4239", "=q2=Embossed Leather Gloves", "=ds=#sr# 55", "=ds="..AL["Trainer"]};
				{ 27, "s2160", "2300", "=q2=Embossed Leather Vest", "=ds=#sr# 40", "=ds="..AL["Trainer"]};
				{ 28, "s9064", "7280", "=q2=Rugged Leather Pants", "=ds=#sr# 35", "=ds="..AL["World Drop"]};
				{ 29, "s3753", "4237", "=q1=Handstitched Leather Belt", "=ds=#sr# 25", "=ds="..AL["Trainer"]};
				{ 30, "s2153", "2303", "=q1=Handstitched Leather Pants", "=ds=#sr# 15", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, "s2149", "2302", "=q1=Handstitched Leather Boots", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
				{ 2, "s9059", "7277", "=q1=Handstitched Leather Bracers", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
				{ 3, "s7126", "5957", "=q1=Handstitched Leather Vest", "=ds=#sr# 1", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = LEATHERWORKING..": "..AL["Leather Armor"],
			module = moduleName, menu = "LEATHERWORKINGMENU"
		};
	};

	AtlasLoot_Data["LeatherLeatherArmorBC"] = {
		["Normal"] = {
			{
				{ 1, "s36351", "30040", "=q4=Belt of Deep Shadow", "=ds=#sr# 375"};
				{ 2, "s36349", "30042", "=q4=Belt of Natural Power", "=ds=#sr# 375"};
				{ 3, "s36355", "30041", "=q4=Boots of Natural Grace", "=ds=#sr# 375"};
				{ 4, "s36357", "30039", "=q4=Boots of Utter Darkness", "=ds=#sr# 375"};
				{ 5, "s41156", "32582", "=q4=Bracers of Renewed Life", "=ds=#sr# 375"};
				{ 6, "s35590", "29526", "=q4=Primalstrike Belt", "=ds=#sr# 375"};
				{ 7, "s35591", "29527", "=q4=Primalstrike Bracers", "=ds=#sr# 375"};
				{ 8, "s35589", "29525", "=q4=Primalstrike Vest", "=ds=#sr# 375"};
				{ 9, "s40006", "32393", "=q4=Redeemed Soul Cinch", "=ds=#sr# 375"};
				{ 10, "s40005", "32396", "=q4=Redeemed Soul Legguards", "=ds=#sr# 375"};
				{ 11, "s40003", "32394", "=q4=Redeemed Soul Moccasins", "=ds=#sr# 375"};
				{ 12, "s40004", "32395", "=q4=Redeemed Soul Wristguards", "=ds=#sr# 375"};
				{ 13, "s41157", "32583", "=q4=Shoulderpads of Renewed Life", "=ds=#sr# 375"};
				{ 14, "s41158", "32580", "=q4=Swiftstrike Bracers", "=ds=#sr# 375"};
				{ 15, "s41160", "32581", "=q4=Swiftstrike Shoulders", "=ds=#sr# 375"};
				{ 16, "s35587", "29524", "=q4=Windhawk Belt", "=ds=#sr# 375"};
				{ 17, "s35588", "29523", "=q4=Windhawk Bracers", "=ds=#sr# 375"};
				{ 18, "s35585", "29522", "=q4=Windhawk Hauberk", "=ds=#sr# 375"};
				{ 19, "s46138", "34369", "=q4=Carapace of Sun and Shadow", "=ds=#sr# 365"};
				{ 20, "s35559", "29503", "=q4=Cobrascale Gloves", "=ds=#sr# 365"};
				{ 21, "s35558", "29502", "=q4=Cobrascale Hood", "=ds=#sr# 365"};
				{ 22, "s46134", "34370", "=q4=Gloves of Immortal Dusk", "=ds=#sr# 365"};
				{ 23, "s35562", "29506", "=q4=Gloves of the Living Touch", "=ds=#sr# 365"};
				{ 24, "s35561", "29505", "=q4=Hood of Primal Life", "=ds=#sr# 365"};
				{ 25, "s46136", "34371", "=q4=Leather Chestguard of the Sun", "=ds=#sr# 365"};
				{ 26, "s46132", "34372", "=q4=Leather Gauntlets of the Sun", "=ds=#sr# 365"};
				{ 27, "s42731", "33204", "=q4=Shadowprowler's Chestguard", "=ds=#sr# 365"};
				{ 28, "s35560", "29504", "=q4=Windscale Hood", "=ds=#sr# 365"};
				{ 29, "s35563", "29507", "=q4=Windslayer Wraps", "=ds=#sr# 365"};
				{ 30, "s32495", "25689", "=q3=Heavy Clefthoof Vest", "=ds=#sr# 360"};
			};
			{
				{ 1, "s32497", "25691", "=q3=Heavy Clefthoof Boots", "=ds=#sr# 355"};
				{ 2, "s32496", "25690", "=q3=Heavy Clefthoof Leggings", "=ds=#sr# 355"};
				{ 3, "s35537", "29500", "=q3=Blastguard Belt", "=ds=#sr# 350"};
				{ 4, "s35536", "29499", "=q3=Blastguard Boots", "=ds=#sr# 350"};
				{ 5, "s35535", "29498", "=q3=Blastguard Pants", "=ds=#sr# 350"};
				{ 6, "s35534", "29497", "=q3=Enchanted Clefthoof Boots", "=ds=#sr# 350"};
				{ 7, "s35533", "29496", "=q3=Enchanted Clefthoof Gloves", "=ds=#sr# 350"};
				{ 8, "s35532", "29495", "=q3=Enchanted Clefthoof Leggings", "=ds=#sr# 350"};
				{ 9, "s32493", "25686", "=q3=Fel Leather Boots", "=ds=#sr# 350"};
				{ 10, "s32494", "25687", "=q3=Fel Leather Leggings", "=ds=#sr# 350"};
				{ 11, "s32489", "25682", "=q3=Stylin' Jungle Hat", "=ds=#sr# 350"};
				{ 12, "s32485", "25680", "=q3=Stylin' Purple Hat", "=ds=#sr# 350"};
				{ 13, "s32490", "25685", "=q3=Fel Leather Gloves", "=ds=#sr# 340"};
				{ 14, "s36078", "29974", "=q3=Living Crystal Breastplate", "=ds=#sr# 330"};
				{ 15, "s36077", "29973", "=q3=Primalstorm Breastplate", "=ds=#sr# 330"};
				{ 16, "s32473", "25671", "=q2=Thick Draenic Vest", "=ds=#sr# 330"};
				{ 17, "s32481", "25676", "=q2=Wild Draenish Vest", "=ds=#sr# 330"};
				{ 18, "s32472", "25668", "=q2=Thick Draenic Boots", "=ds=#sr# 320"};
				{ 19, "s32480", "25675", "=q2=Wild Draenish Leggings", "=ds=#sr# 320"};
				{ 20, "s32471", "25670", "=q2=Thick Draenic Pants", "=ds=#sr# 315"};
				{ 21, "s32479", "25674", "=q2=Wild Draenish Gloves", "=ds=#sr# 310"};
				{ 22, "s32470", "25669", "=q2=Thick Draenic Gloves", "=ds=#sr# 300"};
				{ 23, "s32478", "25673", "=q2=Wild Draenish Boots", "=ds=#sr# 300"};
			};
		};
		info = {
			name = LEATHERWORKING..": "..AL["Leather Armor"],
			module = moduleName, menu = "LEATHERWORKINGMENU"
		};
	};

	AtlasLoot_Data["LeatherLeatherArmorWrath"] = {
		["Normal"] = {
			{
				{ 1, "s70556", "49899", "=q4=Bladeborn Leggings", "=ds="..AL["Vendor"]..""};
				{ 2, "s70555", "49894", "=q4=Blessed Cenarion Boots", "=ds="..AL["Vendor"]..""};
				{ 3, "s70557", "49895", "=q4=Footpads of Impending Death", "=ds="..AL["Vendor"]..""};
				{ 4, "s70554", "49898", "=q4=Legwraps of Unleashed Nature", "=ds="..AL["Vendor"]..""};
				{ 5, "s67142", "47600", "=q4=Knightbane Carapace", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 6, "s67086", "47599", "=q4=Knightbane Carapace", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 7, "s67084", "47602", "=q4=Lunar Eclipse Chestguard", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 8, "s67140", "47601", "=q4=Lunar Eclipse Chestguard", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 9, "s67087", "47581", "=q4=Bracers of Swift Death", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 10, "s67139", "47582", "=q4=Bracers of Swift Death", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 11, "s67085", "47583", "=q4=Moonshadow Armguards", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 12, "s67141", "47584", "=q4=Moonshadow Armguards", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 13, "s63200", "45556", "=q4=Belt of Arctic Life", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 14, "s63201", "45565", "=q4=Boots of Wintry Endurance", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 15, "s63198", "45555", "=q4=Death-warmed Belt", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 16, "s63199", "45564", "=q4=Footpads of Silence", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 17, "s60760", "43495", "=q4=Earthgiving Legguards", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 18, "s60761", "43502", "=q4=Earthgiving Boots", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 19, "s60758", "43481", "=q4=Trollwoven Spaulders", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 20, "s60759", "43484", "=q4=Trollwoven Girdle", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 21, "s60996", "43590", "=q4=Polar Vest", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 22, "s60997", "43591", "=q4=Polar Cord", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 23, "s60998", "43592", "=q4=Polar Boots", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 24, "s62176", "44930", "=q4=Windripper Boots", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 25, "s62177", "44931", "=q4=Windripper Leggings", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 26, "s60697", "43260", "=q3=Eviscerator's Facemask", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 27, "s60702", "43433", "=q3=Eviscerator's Shoulderpads", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 28, "s60703", "43434", "=q3=Eviscerator's Chestguard", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 29, "s60704", "43435", "=q3=Eviscerator's Bindings", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 30, "s60705", "43436", "=q3=Eviscerator's Gauntlets", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
			};
			{
				{ 1, "s60706", "43437", "=q3=Eviscerator's Waistguard", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 2, "s60711", "43438", "=q3=Eviscerator's Legguards", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 3, "s60712", "43439", "=q3=Eviscerator's Treads", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 4, "s60715", "43261", "=q3=Overcast Headguard", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 5, "s60716", "43262", "=q3=Overcast Spaulders", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 6, "s60718", "43263", "=q3=Overcast Chestguard", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 7, "s60720", "43264", "=q3=Overcast Bracers", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 8, "s60721", "43265", "=q3=Overcast Handwraps", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 9, "s60723", "43266", "=q3=Overcast Belt", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 10, "s60725", "43271", "=q3=Overcast Leggings", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 11, "s60727", "43273", "=q3=Overcast Boots", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 12, "s60669", "43257", "=q3=Wildscale Breastplate", "=ds="..AL["Trainer"]};
				{ 13, "s60660", "42731", "=q3=Leggings of Visceral Strikes", "=ds="..AL["Trainer"]};
				{ 14, "s60671", "43258", "=q3=Purehorn Spaulders", "=ds="..AL["Trainer"]};
				{ 15, "s60665", "43255", "=q3=Seafoam Gauntlets", "=ds="..AL["Trainer"]};
				{ 16, "s60666", "43256", "=q3=Jormscale Footpads", "=ds="..AL["Trainer"]};
				{ 17, "s51568", "38590", "=q3=Black Chitinguard Boots", "=ds="..AL["Trainer"]};
				{ 18, "s60620", "44442", "=q3=Bugsquashers", "=ds="..AL["Trainer"]};
				{ 19, "s51570", "38592", "=q3=Dark Arctic Chestpiece", "=ds="..AL["Trainer"]};
				{ 20, "s51569", "38591", "=q3=Dark Arctic Leggings", "=ds="..AL["Trainer"]};
				{ 21, "s60613", "44441", "=q3=Dark Iceborne Chestguard", "=ds="..AL["Trainer"]};
				{ 22, "s60611", "44440", "=q3=Dark Iceborne Leggings", "=ds="..AL["Trainer"]};
				{ 23, "s51572", "38437", "=q2=Arctic Helm", "=ds="..AL["Trainer"]};
				{ 24, "s50946", "38402", "=q2=Arctic Shoulderpads", "=ds="..AL["Trainer"]};
				{ 25, "s50944", "38400", "=q2=Arctic Chestpiece", "=ds="..AL["Trainer"]};
				{ 26, "s51571", "38433", "=q2=Arctic Wristguards", "=ds="..AL["Trainer"]};
				{ 27, "s50947", "38403", "=q2=Arctic Gloves", "=ds="..AL["Trainer"]};
				{ 28, "s50949", "38405", "=q2=Arctic Belt", "=ds="..AL["Trainer"]};
				{ 29, "s50945", "38401", "=q2=Arctic Leggings", "=ds="..AL["Trainer"]};
				{ 30, "s50948", "38404", "=q2=Arctic Boots", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, "s60608", "38438", "=q2=Iceborne Helm", "=ds="..AL["Trainer"]};
				{ 2, "s50940", "38411", "=q2=Iceborne Shoulderpads", "=ds="..AL["Trainer"]};
				{ 3, "s50938", "38408", "=q2=Iceborne Chestguard", "=ds="..AL["Trainer"]};
				{ 4, "s60607", "38434", "=q2=Iceborne Wristguards", "=ds="..AL["Trainer"]};
				{ 5, "s50941", "38409", "=q2=Iceborne Gloves", "=ds="..AL["Trainer"]};
				{ 6, "s50943", "38406", "=q2=Iceborne Belt", "=ds="..AL["Trainer"]};
				{ 7, "s50939", "38410", "=q2=Iceborne Leggings", "=ds="..AL["Trainer"]};
				{ 8, "s50942", "38407", "=q2=Iceborne Boots", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = LEATHERWORKING..": "..AL["Leather Armor"],
			module = moduleName, menu = "LEATHERWORKINGMENU"
		};
	};
	
	AtlasLoot_Data["LeatherLeatherArmorCata"] = {
		["Normal"] = {
			{
				{ 1, "s101940", "71994", "=q4=Bladeshadow Wristguards", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 2, "s101937", "71995", "=q4=Bracers of Flowing Serenity", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 3, "s101935", "71985", "=q4=Bladeshadow Leggings", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 4, "s101933", "71986", "=q4=Leggings of Nature's Champion", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 5, "s99446", "69942", "=q4=Clutches of Evil", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 6, "s99447", "69943", "=q4=Heavenly Gloves of the Moon", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 7, "s99458", "69952", "=q4=Ethereal Footfalls", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 8, "s99457", "69951", "=q4=Treads of the Craft", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 9, "s78488", "56562", "=q4=Assassin's Chestplate", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 10, "s78461", "56537", "=q4=Belt of Nefarious Whispers", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 11, "s78487", "56561", "=q4=Chestguard of Nature's Fury", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 12, "s78460", "56536", "=q4=Lightning Lash", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 13, "s78481", "75103", "=q3=Vicious Leather Chest", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 14, "s78482", "75112", "=q3=Vicious Leather Legs", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 15, "s78480", "75111", "=q3=Vicious Wyrmhide Helm", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 16, "s78479", "75080", "=q3=Vicious Wyrmhide Legs", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 17, "s78468", "75127", "=q3=Vicious Leather Belt", "=ds=#sr# 520", "=ds="..AL["Vendor"] };
				{ 18, "s78469", "75105", "=q3=Vicious Leather Helm", "=ds=#sr# 520", "=ds="..AL["Vendor"] };
				{ 19, "s78467", "75107", "=q3=Vicious Wyrmhide Chest", "=ds=#sr# 520", "=ds="..AL["Vendor"] };
				{ 20, "s78464", "75099", "=q3=Vicious Wyrmhide Shoulders", "=ds=#sr# 520", "=ds="..AL["Vendor"] };
				{ 21, "s78454", "75130", "=q3=Vicious Leather Boots", "=ds=#sr# 515", "=ds="..AL["Vendor"] };
				{ 22, "s78455", "75113", "=q3=Vicious Leather Shoulders", "=ds=#sr# 515", "=ds="..AL["Vendor"] };
				{ 23, "s78453", "75101", "=q3=Vicious Wyrmhide Boots", "=ds=#sr# 515", "=ds="..AL["Vendor"] };
				{ 24, "s78452", "75109", "=q3=Vicious Wyrmhide Gloves", "=ds=#sr# 515", "=ds="..AL["Vendor"] };
				{ 25, "s78446", "75131", "=q3=Vicious Leather Bracers", "=ds=#sr# 510", "=ds="..AL["Vendor"] };
				{ 26, "s78447", "75104", "=q3=Vicious Leather Gloves", "=ds=#sr# 510", "=ds="..AL["Vendor"] };
				{ 27, "s78445", "75117", "=q3=Vicious Wyrmhide Belt", "=ds=#sr# 510", "=ds="..AL["Vendor"] };
				{ 28, "s78444", "75106", "=q3=Vicious Wyrmhide Bracers", "=ds=#sr# 510", "=ds="..AL["Vendor"] };
				{ 29, "s78424", "56505", "=q2=Darkbrand Helm", "=ds=#sr# 490", "=ds="..AL["Trainer"] };
				{ 30, "s78433", "56513", "=q3=Darkbrand Leggings", "=ds=#sr# 485", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s78428", "56509", "=q2=Darkbrand Chestguard", "=ds=#sr# 480", "=ds="..AL["Trainer"] };
				{ 2, "s78399", "56484", "=q3=Darkbrand Gloves", "=ds=#sr# 480", "=ds="..AL["Trainer"] };
				{ 3, "s78411", "56495", "=q2=Darkbrand Shoulders", "=ds=#sr# 475", "=ds="..AL["Trainer"] };
				{ 4, "s78407", "56491", "=q2=Darkbrand Boots", "=ds=#sr# 470", "=ds="..AL["Trainer"] };
				{ 5, "s78416", "56499", "=q2=Darkbrand Belt", "=ds=#sr# 455", "=ds="..AL["Trainer"] };
				{ 6, "s78398", "56483", "=q2=Darkbrand Bracers", "=ds=#sr# 450", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = LEATHERWORKING..": "..AL["Leather Armor"],
			module = moduleName, menu = "LEATHERWORKINGMENU"
		};
	};

	AtlasLoot_Data["LeatherMailArmorOld"] = {
		["Normal"] = {
			{
				{ 1, "s28224", "22665", "=q4=Icy Scale Bracers", "=ds=#sr# 300"};
				{ 2, "s28222", "22664", "=q4=Icy Scale Breastplate", "=ds=#sr# 300"};
				{ 3, "s28223", "22666", "=q4=Icy Scale Gauntlets", "=ds=#sr# 300"};
				{ 4, "s24703", "20380", "=q4=Dreamscale Breastplate", "=ds=#sr# 300"};
				{ 5, "s23708", "19157", "=q4=Chromatic Gauntlets", "=ds=#sr# 300"};
				{ 6, "s20855", "16984", "=q4=Black Dragonscale Boots", "=ds=#sr# 300"};
				{ 7, "s22923", "18508", "=q3=Swift Flight Bracers", "=ds=#sr# 300"};
				{ 8, "s24849", "20476", "=q3=Sandstalker Bracers", "=ds=#sr# 300"};
				{ 9, "s24851", "20478", "=q3=Sandstalker Breastplate", "=ds=#sr# 300"};
				{ 10, "s24850", "20477", "=q3=Sandstalker Gauntlets", "=ds=#sr# 300"};
				{ 11, "s24846", "20481", "=q3=Spitfire Bracers", "=ds=#sr# 300"};
				{ 12, "s24848", "20479", "=q3=Spitfire Breastplate", "=ds=#sr# 300"};
				{ 13, "s24847", "20480", "=q3=Spitfire Gauntlets", "=ds=#sr# 300"};
				{ 14, "s19054", "15047", "=q3=Red Dragonscale Breastplate", "=ds=#sr# 300"};
				{ 15, "s24654", "20295", "=q3=Blue Dragonscale Leggings", "=ds=#sr# 300"};
				{ 16, "s19107", "15052", "=q3=Black Dragonscale Leggings", "=ds=#sr# 300"};
				{ 17, "s19094", "15051", "=q3=Black Dragonscale Shoulders", "=ds=#sr# 300"};
				{ 18, "s19100", "15081", "=q2=Heavy Scorpid Shoulders", "=ds=#sr# 300"};
				{ 19, "s19089", "15049", "=q3=Blue Dragonscale Shoulders", "=ds=#sr# 295"};
				{ 20, "s19088", "15080", "=q2=Heavy Scorpid Helm", "=ds=#sr# 295"};
				{ 21, "s19085", "15050", "=q3=Black Dragonscale Breastplate", "=ds=#sr# 290"};
				{ 22, "s19075", "15079", "=q2=Heavy Scorpid Leggings", "=ds=#sr# 285"};
				{ 23, "s19077", "15048", "=q3=Blue Dragonscale Breastplate", "=ds=#sr# 285"};
				{ 24, "s24655", "20296", "=q3=Green Dragonscale Gauntlets", "=ds=#sr# 280", "=ds="..AL["Trainer"]};
				{ 25, "s19070", "15082", "=q2=Heavy Scorpid Belt", "=ds=#sr# 280", "=ds="..AL["World Drop"]};
				{ 26, "s19064", "15078", "=q2=Heavy Scorpid Gauntlets", "=ds=#sr# 275", "=ds="..AL["Drop"]};
				{ 27, "s19060", "15046", "=q3=Green Dragonscale Leggings", "=ds=#sr# 270", "=ds="..AL["Drop"]};
				{ 28, "s19051", "15076", "=q2=Heavy Scorpid Vest", "=ds=#sr# 265", "=ds="..AL["Drop"]};
				{ 29, "s36076", "29971", "=q3=Dragonstrike Leggings", "=ds=#sr# 260", "=ds="..AL["Trainer"]};
				{ 30, "s19050", "15045", "=q3=Green Dragonscale Breastplate", "=ds=#sr# 260", "=ds="..AL["Vendor"]};
			};
			{
				{ 1, "s10650", "8367", "=q3=Dragonscale Breastplate", "=ds=#sr# 255", "=ds="..AL["Trainer"]};
				{ 2, "s19048", "15077", "=q2=Heavy Scorpid Bracers", "=ds=#sr# 255", "=ds="..AL["Vendor"]};
				{ 3, "s10570", "8208", "=q2=Tough Scorpid Helm", "=ds=#sr# 250", "=ds="..AL["Drop"]};
				{ 4, "s10568", "8206", "=q2=Tough Scorpid Leggings", "=ds=#sr# 245", "=ds="..AL["Drop"]};
				{ 5, "s10564", "8207", "=q2=Tough Scorpid Shoulders", "=ds=#sr# 240", "=ds="..AL["Drop"]};
				{ 6, "s10554", "8209", "=q2=Tough Scorpid Boots", "=ds=#sr# 235", "=ds="..AL["Drop"]};
				{ 7, "s10556", "8185", "=q2=Turtle Scale Leggings", "=ds=#sr# 235", "=ds="..AL["Trainer"]};
				{ 8, "s10552", "8191", "=q2=Turtle Scale Helm", "=ds=#sr# 230", "=ds="..AL["Trainer"]};
				{ 9, "s10619", "8347", "=q3=Dragonscale Gauntlets", "=ds=#sr# 225", "=ds="..AL["Trainer"]};
				{ 10, "s10542", "8204", "=q2=Tough Scorpid Gloves", "=ds=#sr# 225", "=ds="..AL["Drop"]};
				{ 11, "s10533", "8205", "=q2=Tough Scorpid Bracers", "=ds=#sr# 220", "=ds="..AL["Drop"]};
				{ 12, "s10525", "8203", "=q2=Tough Scorpid Breastplate", "=ds=#sr# 220", "=ds="..AL["Drop"]};
				{ 13, "s10518", "8198", "=q2=Turtle Scale Bracers", "=ds=#sr# 210", "=ds="..AL["Trainer"]};
				{ 14, "s10511", "8189", "=q2=Turtle Scale Breastplate", "=ds=#sr# 210", "=ds="..AL["Trainer"]};
				{ 15, "s10509", "8187", "=q2=Turtle Scale Gloves", "=ds=#sr# 205", "=ds="..AL["World Drop"]};
			};
		};
		info = {
			name = LEATHERWORKING..": "..AL["Mail Armor"],
			module = moduleName, menu = "LEATHERWORKINGMENU"
		};
	};

	AtlasLoot_Data["LeatherMailArmorBC"] = {
		["Normal"] = {
			{
				{ 1, "s40002", "32397", "=q4=Waistguard of Shackled Souls", "=ds=#sr# 375"};
				{ 2, "s41162", "32575", "=q4=Shoulders of Lightning Reflexes", "=ds=#sr# 375"};
				{ 3, "s35582", "29520", "=q4=Netherstrike Belt", "=ds=#sr# 375"};
				{ 4, "s35584", "29521", "=q4=Netherstrike Bracers", "=ds=#sr# 375"};
				{ 5, "s35580", "29519", "=q4=Netherstrike Breastplate", "=ds=#sr# 375"};
				{ 6, "s36353", "30044", "=q4=Monsoon Belt", "=ds=#sr# 375"};
				{ 7, "s52733", "32399", "=q4=Bracers of Shackled Souls", "=ds="..AL["Vendor"]..""};
				{ 8, "s35576", "29516", "=q4=Ebon Netherscale Belt", "=ds=#sr# 375"};
				{ 9, "s35577", "29517", "=q4=Ebon Netherscale Bracers", "=ds=#sr# 375"};
				{ 10, "s35575", "29515", "=q4=Ebon Netherscale Breastplate", "=ds=#sr# 375"};
				{ 11, "s40001", "32400", "=q4=Greaves of Shackled Souls", "=ds=#sr# 375"};
				{ 12, "s36359", "30043", "=q4=Hurricane Boots", "=ds=#sr# 375"};
				{ 13, "s41163", "32577", "=q4=Living Earth Bindings", "=ds=#sr# 375"};
				{ 14, "s41164", "32579", "=q4=Living Earth Shoulders", "=ds=#sr# 375"};
				{ 15, "s39997", "32398", "=q4=Boots of Shackled Souls", "=ds=#sr# 375"};
				{ 16, "s36358", "30045", "=q4=Boots of the Crimson Hawk", "=ds=#sr# 375"};
				{ 17, "s36352", "30046", "=q4=Belt of the Black Eagle", "=ds=#sr# 375"};
				{ 18, "s41161", "32574", "=q4=Bindings of Lightning Reflexes", "=ds=#sr# 375"};
				{ 19, "s46139", "34375", "=q4=Sun-Drenched Scale Chestguard", "=ds=#sr# 365"};
				{ 20, "s46135", "34376", "=q4=Sun-Drenched Scale Gloves", "=ds=#sr# 365"};
				{ 21, "s46137", "34373", "=q4=Embrace of the Phoenix", "=ds=#sr# 365"};
				{ 22, "s46133", "34374", "=q4=Fletcher's Gloves of the Phoenix", "=ds=#sr# 365"};
				{ 23, "s35568", "29509", "=q4=Windstrike Gloves", "=ds=#sr# 365"};
				{ 24, "s35574", "29514", "=q4=Thick Netherscale Breastplate", "=ds=#sr# 365"};
				{ 25, "s35564", "29508", "=q4=Living Dragonscale Helm", "=ds=#sr# 365"};
				{ 26, "s35573", "29511", "=q4=Netherdrake Gloves", "=ds=#sr# 365"};
				{ 27, "s35572", "29510", "=q4=Netherdrake Helm", "=ds=#sr# 365"};
				{ 28, "s35567", "29512", "=q4=Earthen Netherscale Boots", "=ds=#sr# 365"};
				{ 29, "s32499", "25697", "=q3=Felstalker Bracer", "=ds=#sr# 360"};
				{ 30, "s32500", "25696", "=q3=Felstalker Breastplate", "=ds=#sr# 360"};
			};
			{
				{ 1, "s32487", "25681", "=q3=Stylin' Adventure Hat", "=ds=#sr# 350"};
				{ 2, "s32488", "25683", "=q3=Stylin' Crimson Hat", "=ds=#sr# 350"};
				{ 3, "s32498", "25695", "=q3=Felstalker Belt", "=ds=#sr# 350"};
				{ 4, "s35531", "29494", "=q3=Flamescale Belt", "=ds=#sr# 350"};
				{ 5, "s35528", "29493", "=q3=Flamescale Boots", "=ds=#sr# 350"};
				{ 6, "s35529", "29492", "=q3=Flamescale Leggings", "=ds=#sr# 350"};
				{ 7, "s32503", "25693", "=q3=Netherfury Boots", "=ds=#sr# 350"};
				{ 8, "s35527", "29491", "=q3=Enchanted Felscale Boots", "=ds=#sr# 350"};
				{ 9, "s35526", "29490", "=q3=Enchanted Felscale Gloves", "=ds=#sr# 350"};
				{ 10, "s35525", "29489", "=q3=Enchanted Felscale Leggings", "=ds=#sr# 350"};
				{ 11, "s32501", "25694", "=q3=Netherfury Belt", "=ds=#sr# 340"};
				{ 12, "s32502", "25692", "=q3=Netherfury Leggings", "=ds=#sr# 340"};
				{ 13, "s36079", "29975", "=q3=Golden Dragonstrike Breastplate", "=ds=#sr# 330"};
				{ 14, "s32465", "25657", "=q2=Felscale Breastplate", "=ds=#sr# 335"};
				{ 15, "s32469", "25659", "=q2=Scaled Draenic Boots", "=ds=#sr# 335"};
				{ 16, "s32468", "25660", "=q2=Scaled Draenic Vest", "=ds=#sr# 325"};
				{ 17, "s32464", "25656", "=q2=Felscale Pants", "=ds=#sr# 320"};
				{ 18, "s32467", "25661", "=q2=Scaled Draenic Gloves", "=ds=#sr# 310"};
				{ 19, "s32463", "25655", "=q2=Felscale Boots", "=ds=#sr# 310"};
				{ 20, "s32466", "25662", "=q2=Scaled Draenic Pants", "=ds=#sr# 300"};
				{ 21, "s32462", "25654", "=q2=Felscale Gloves", "=ds=#sr# 300"};
			};
		};
		info = {
			name = LEATHERWORKING..": "..AL["Mail Armor"],
			module = moduleName, menu = "LEATHERWORKINGMENU"
		};
	};

	AtlasLoot_Data["LeatherMailArmorWrath"] = {
		["Normal"] = {
			{
				{ 1, "s70560", "49901", "=q4=Draconic Bonesplinter Legguards", "=ds="..AL["Vendor"]..""};
				{ 2, "s70559", "49896", "=q4=Earthsoul Boots", "=ds="..AL["Vendor"]..""};
				{ 3, "s70558", "49900", "=q4=Lightning-Infused Leggings", "=ds="..AL["Vendor"]..""};
				{ 4, "s70561", "49897", "=q4=Rock-Steady Treads", "=ds="..AL["Vendor"]..""};
				{ 5, "s67138", "47596", "=q4=Crusader's Dragonscale Breastplate", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 6, "s67082", "47595", "=q4=Crusader's Dragonscale Breastplate", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 7, "s67080", "47597", "=q4=Ensorcelled Nerubian Breastplate", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 8, "s67136", "47598", "=q4=Ensorcelled Nerubian Breastplate", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 9, "s67137", "47580", "=q4=Black Chitin Bracers", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 10, "s67081", "47579", "=q4=Black Chitin Bracers", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 11, "s67083", "47576", "=q4=Crusader's Dragonscale Bracers", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 12, "s67143", "47577", "=q4=Crusader's Dragonscale Bracers", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 13, "s63194", "45553", "=q4=Belt of Dragons", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 14, "s63196", "45554", "=q4=Blue Belt of Chaos", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 15, "s63195", "45562", "=q4=Boots of Living Scale", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 16, "s63197", "45563", "=q4=Lightning Grounded Boots", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 17, "s60755", "43459", "=q4=Giantmaim Bracers", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 18, "s60754", "43458", "=q4=Giantmaim Legguards", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 19, "s60756", "43461", "=q4=Revenant's Breastplate", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 20, "s60757", "43469", "=q4=Revenant's Treads", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 21, "s60999", "43593", "=q4=Icy Scale Chestguard", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 22, "s61000", "43594", "=q4=Icy Scale Belt", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 23, "s61002", "43595", "=q4=Icy Scale Boots", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 24, "s60728", "43447", "=q3=Swiftarrow Helm", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 25, "s60729", "43449", "=q3=Swiftarrow Shoulderguards", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 26, "s60730", "43445", "=q3=Swiftarrow Hauberk", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 27, "s60731", "43444", "=q3=Swiftarrow Bracers", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 28, "s60732", "43446", "=q3=Swiftarrow Gauntlets", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 29, "s60734", "43442", "=q3=Swiftarrow Belt", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 30, "s60735", "43448", "=q3=Swiftarrow Leggings", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
			};
			{
				{ 1, "s60737", "43443", "=q3=Swiftarrow Boots", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 2, "s60743", "43455", "=q3=Stormhide Crown", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 3, "s60746", "43457", "=q3=Stormhide Shoulders", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 4, "s60747", "43453", "=q3=Stormhide Hauberk", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 5, "s60748", "43452", "=q3=Stormhide Wristguards", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 6, "s60749", "43454", "=q3=Stormhide Grips", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 7, "s60750", "43450", "=q3=Stormhide Belt", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 8, "s60751", "43456", "=q3=Stormhide Legguards", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 9, "s60752", "43451", "=q3=Stormhide Stompers", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 10, "s60649", "43129", "=q3=Razorstrike Breastplate", "=ds="..AL["Trainer"]};
				{ 11, "s60655", "43132", "=q3=Nightshock Hood", "=ds="..AL["Trainer"]};
				{ 12, "s60651", "43130", "=q3=Virulent Spaulders", "=ds="..AL["Trainer"]};
				{ 13, "s60658", "43133", "=q3=Nightshock Girdle", "=ds="..AL["Trainer"]};
				{ 14, "s60652", "43131", "=q3=Eaglebane Bracers", "=ds="..AL["Trainer"]};
				{ 15, "s60605", "44438", "=q3=Dragonstompers", "=ds="..AL["Trainer"]};
				{ 16, "s60630", "44445", "=q3=Scaled Icewalkers", "=ds="..AL["Trainer"]};
				{ 17, "s60604", "44437", "=q3=Dark Frostscale Breastplate", "=ds="..AL["Trainer"]};
				{ 18, "s60601", "44436", "=q3=Dark Frostscale Leggings", "=ds="..AL["Trainer"]};
				{ 19, "s60629", "44444", "=q3=Dark Nerubian Chestpiece", "=ds="..AL["Trainer"]};
				{ 20, "s60627", "44443", "=q3=Dark Nerubian Leggings", "=ds="..AL["Trainer"]};
				{ 21, "s60600", "38440", "=q2=Frostscale Helm", "=ds="..AL["Trainer"]};
				{ 22, "s50952", "38424", "=q2=Frostscale Shoulders", "=ds="..AL["Trainer"]};
				{ 23, "s50950", "38414", "=q2=Frostscale Chestguard", "=ds="..AL["Trainer"]};
				{ 24, "s60599", "38436", "=q2=Frostscale Bracers", "=ds="..AL["Trainer"]};
				{ 25, "s50953", "38415", "=q2=Frostscale Gloves", "=ds="..AL["Trainer"]};
				{ 26, "s50955", "38412", "=q2=Frostscale Belt", "=ds="..AL["Trainer"]};
				{ 27, "s50951", "38416", "=q2=Frostscale Leggings", "=ds="..AL["Trainer"]};
				{ 28, "s50954", "38413", "=q2=Frostscale Boots", "=ds="..AL["Trainer"]};
				{ 29, "s60624", "38439", "=q2=Nerubian Helm", "=ds="..AL["Trainer"]};
				{ 30, "s50958", "38417", "=q2=Nerubian Shoulders", "=ds="..AL["Trainer"]};
			};
			{
				{ 1, "s50956", "38420", "=q2=Nerubian Chestguard", "=ds="..AL["Trainer"]};
				{ 2, "s60622", "38435", "=q2=Nerubian Bracers", "=ds="..AL["Trainer"]};
				{ 3, "s50959", "38421", "=q2=Nerubian Gloves", "=ds="..AL["Trainer"]};
				{ 4, "s50961", "38418", "=q2=Nerubian Belt", "=ds="..AL["Trainer"]};
				{ 5, "s50957", "38422", "=q2=Nerubian Legguards", "=ds="..AL["Trainer"]};
				{ 6, "s50960", "38419", "=q2=Nerubian Boots", "=ds="..AL["Trainer"]};
			};
		};
		info = {
			name = LEATHERWORKING..": "..AL["Mail Armor"],
			module = moduleName, menu = "LEATHERWORKINGMENU"
		};
	};

	AtlasLoot_Data["LeatherMailArmorCata"] = {
		["Normal"] = {
			{
				{ 1, "s101941", "71996", "=q4=Bracers of the Hunter-Killer", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 2, "s101939", "71997", "=q4=Thundering Deathscale Wristguards", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 3, "s101936", "71987", "=q4=Rended Earth Leggings", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 4, "s101934", "71988", "=q4=Deathscale Leggings of the Storm", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 5, "s99443", "69939", "=q4=Dragonfire Gloves", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 6, "s99445", "69941", "=q4=Gloves of Unforgiving Flame", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 7, "s99455", "69949", "=q4=Earthen Scale Sabatons", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 8, "s99456", "69950", "=q4=Footwraps of Quenched Fire", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 9, "s78463", "56539", "=q4=Corded Viper Belt", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 10, "s78490", "56564", "=q4=Dragonkiller Tunic", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 11, "s78462", "56538", "=q4=Stormleather Sash", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 12, "s78489", "56563", "=q4=Twilight Scale Chestguard", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 13, "s78486", "75115", "=q3=Vicious Dragonscale Chest", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 14, "s78485", "75108", "=q3=Vicious Dragonscale Legs", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 15, "s78483", "75084", "=q3=Vicious Charscale Chest", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 16, "s78484", "75090", "=q3=Vicious Charscale Helm", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 17, "s78473", "75100", "=q3=Vicious Dragonscale Belt", "=ds=#sr# 520", "=ds="..AL["Vendor"] };
				{ 18, "s78474", "75102", "=q3=Vicious Dragonscale Helm", "=ds=#sr# 520", "=ds="..AL["Vendor"] };
				{ 19, "s78471", "75097", "=q3=Vicious Charscale Legs", "=ds=#sr# 520", "=ds="..AL["Vendor"] };
				{ 20, "s78470", "75061", "=q3=Vicious Charscale Shoulders", "=ds=#sr# 520", "=ds="..AL["Vendor"] };
				{ 21, "s78458", "75110", "=q3=Vicious Dragonscale Boots", "=ds=#sr# 515", "=ds="..AL["Vendor"] };
				{ 22, "s78459", "75081", "=q3=Vicious Dragonscale Gloves", "=ds=#sr# 515", "=ds="..AL["Vendor"] };
				{ 23, "s78457", "75083", "=q3=Vicious Charscale Belt", "=ds=#sr# 515", "=ds="..AL["Vendor"] };
				{ 24, "s78456", "75092", "=q3=Vicious Charscale Boots", "=ds=#sr# 515", "=ds="..AL["Vendor"] };
				{ 25, "s78450", "75114", "=q3=Vicious Dragonscale Bracers", "=ds=#sr# 510", "=ds="..AL["Vendor"] };
				{ 26, "s78451", "75116", "=q3=Vicious Dragonscale Shoulders", "=ds=#sr# 510", "=ds="..AL["Vendor"] };
				{ 27, "s78448", "75094", "=q3=Vicious Charscale Bracers", "=ds=#sr# 510", "=ds="..AL["Vendor"] };
				{ 28, "s78449", "75085", "=q3=Vicious Charscale Gloves", "=ds=#sr# 510", "=ds="..AL["Vendor"] };
				{ 29, "s78423", "56504", "=q3=Tsunami Chestguard", "=ds=#sr# 490", "=ds="..AL["Trainer"] };
				{ 30, "s78432", "56512", "=q2=Tsunami Helm", "=ds=#sr# 485", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s78427", "56508", "=q2=Tsunami Leggings", "=ds=#sr# 480", "=ds="..AL["Trainer"] };
				{ 2, "s78406", "56490", "=q2=Tsunami Gloves", "=ds=#sr# 475", "=ds="..AL["Trainer"] };
				{ 3, "s78396", "56482", "=q2=Tsunami Belt", "=ds=#sr# 475", "=ds="..AL["Trainer"] };
				{ 4, "s78388", "56481", "=q2=Tsunami Bracers", "=ds=#sr# 460", "=ds="..AL["Trainer"] };
				{ 5, "s78415", "56498", "=q3=Tsunami Shoulders", "=ds=#sr# 455", "=ds="..AL["Trainer"] };
				{ 6, "s78410", "56494", "=q2=Tsunami Boots", "=ds=#sr# 450", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = LEATHERWORKING..": "..AL["Mail Armor"],
			module = moduleName, menu = "LEATHERWORKINGMENU"
		};
	};

	AtlasLoot_Data["LeatherCloaks"] = {
		["Normal"] = {
			{
				{ 1, "s78475", "56549", "=q3=Razor-Edged Cloak", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 2, "s78476", "56548", "=q3=Twilight Dragonscale Cloak", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 3, "s99536", "75076", "=q3=Vicious Fur Cloak", "=ds=#sr# 510", "=ds="..AL["Trainer"] };
				{ 4, "s99535", "75077", "=q3=Vicious Hide Cloak", "=ds=#sr# 510", "=ds="..AL["Trainer"] };
				{ 5, "s78438", "56518", "=q3=Cloak of Beasts", "=ds=#sr# 495", "=ds="..AL["Trainer"] };
				{ 6, "s78439", "56519", "=q3=Cloak of War", "=ds=#sr# 495", "=ds="..AL["Trainer"] };
				{ 7, "s78405", "56489", "=q2=Hardened Scale Cloak", "=ds=#sr# 470", "=ds="..AL["Trainer"] };
				{ 8, "s78380", "56480", "=q2=Savage Cloak", "=ds=#sr# 460", "=ds="..AL["Trainer"] };
				{ 9, "s60637", "43566", "=q4=Ice Striker's Cloak", "=ds=#sr# 440", "=ds="..AL["Trainer"] };
				{ 10, "s55199", "41238", "=q3=Cloak of Tormented Skies", "=ds=#sr# 395", "=ds="..AL["Trainer"] };
				{ 11, "s60631", "38441", "=q3=Cloak of Harsh Winds", "=ds=#sr# 380", "=ds="..AL["Trainer"] };	
				{ 12, "s42546", "33122", "=q4=Cloak of Darkness", "=ds=#sr# 360", "=ds="..BabbleFaction["The Violet Eye"].." - "..BabbleFaction["Exalted"] };
				{ 13, "s22926", "18509", "=q4=Chromatic Cloak", "=ds=#sr# 300", "=ds="..BabbleZone["Dire Maul"] };
				{ 14, "s22928", "18511", "=q4=Shifting Cloak", "=ds=#sr# 300", "=ds="..BabbleZone["Dire Maul"] };
				{
					{ 16, "s19093", "15138", "=q3=Onyxia Scale Cloak", "=ds=#sr# 300", "=ds=#QUESTID:7493#" };
					{ 16, "s19093", "15138", "=q3=Onyxia Scale Cloak", "=ds=#sr# 300", "=ds=#QUESTID:7497#" };
				};
				{
					{ 17, "s10574", "8215", "=q2=Wild Leather Cloak", "=ds=#sr# 250", "=ds=#QUESTID:2860#" };
					{ 17, "s10574", "8215", "=q2=Wild Leather Cloak", "=ds=#sr# 250", "=ds=#QUESTID:2853#" };
				};
				{ 18, "s10562", "8216", "=q2=Big Voodoo Cloak", "=ds=#sr# 240", "=ds="..AL["World Drop"] };
				{ 19, "s7153", "5965", "=q2=Guardian Cloak", "=ds=#sr# 185", "=ds="..AL["World Drop"] };
				{ 20, "s9198", "7377", "=q2=Frost Leather Cloak", "=ds=#sr# 180", "=ds="..AL["Trainer"] };
				{ 21, "s3760", "3719", "=q2=Hillman's Cloak", "=ds=#sr# 150", "=ds="..AL["Trainer"] };
				{ 22, "s2168", "2316", "=q2=Dark Leather Cloak", "=ds=#sr# 110", "=ds="..AL["Trainer"] };
				{ 23, "s9070", "7283", "=q2=Black Whelp Cloak", "=ds=#sr# 100", "=ds="..AL["Vendor"]..": "..BabbleZone["Redridge Mountains"] };
				{ 24, "s7953", "6466", "=q2=Deviate Scale Cloak", "=ds=#sr# 90", "=ds="..AL["Vendor"]..": "..BabbleZone["Northern Barrens"] };
				{ 25, "s2159", "2308", "=q2=Fine Leather Cloak", "=ds=#sr# 85", "=ds="..AL["Trainer"] };
				{ 26, "s2162", "2310", "=q2=Embossed Leather Cloak", "=ds=#sr# 60", "=ds="..AL["Trainer"] };
				{ 27, "s9058", "7276", "=q1=Handstitched Leather Cloak", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = LEATHERWORKING..": "..AL["Cloaks"],
			module = moduleName, menu = "LEATHERWORKINGMENU"
		};
	};

	AtlasLoot_Data["LeatherItemEnhancement"] = {
		["Normal"] = {
			{
				{ 1, "s78478", "56551", "=q4=Charscale Leg Armor", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 2, "s78477", "56550", "=q4=Dragonscale Leg Armor", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 3, "s101599", "71720", "=q4=Drakehide Leg Armor", "=ds=#sr# 525", "=ds="..AL["Vendor"] };
				{ 4, "s85008", "Trade_LeatherWorking", "=ds=Draconic Embossment - Agility", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 5, "s85010", "Trade_LeatherWorking", "=ds=Draconic Embossment - Intellect", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 6, "s85007", "Trade_LeatherWorking", "=ds=Draconic Embossment - Stamina", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 7, "s85009", "Trade_LeatherWorking", "=ds=Draconic Embossment - Strength", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 8, "s78437", "56517", "=q2=Heavy Savage Armor Kit", "=ds=#sr# 485", "=ds="..AL["Trainer"] };
				{ 9, "s78420", "56503", "=q3=Twilight Leg Armor", "=ds=#sr# 480", "=ds="..AL["Trainer"] };
				{ 10, "s78419", "56502", "=q3=Scorched Leg Armor", "=ds=#sr# 475", "=ds="..AL["Trainer"] };
				{ 11, "s85068", "Trade_LeatherWorking", "=ds=Charscale Leg Reinforcements", "=ds=#sr# 465", "=ds="..AL["Trainer"] };
				{ 12, "s85067", "Trade_LeatherWorking", "=ds=Dragonbone Leg Reinforcements", "=ds=#sr# 465", "=ds="..AL["Trainer"] };
				{ 13, "s101600", "Trade_LeatherWorking", "=ds=Dragonbone Leg Reinforcements", "=ds=#sr# 465", "=ds="..AL["Trainer"] };
				{ 14, "s78379", "56477", "=q1=Savage Armor Kit", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 15, "s62448", "44963", "=q4=Earthen Leg Armor", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 16, "s50965", "38373", "=q4=Frosthide Leg Armor", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 17, "s50967", "38374", "=q4=Icescale Leg Armor", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 18, "s50964", "38371", "=q3=Jormungar Leg Armor", "=ds=#sr# 405", "=ds="..AL["Trainer"] };
				{ 19, "s60583", "Trade_LeatherWorking", "=ds=Jormungar Leg Reinforcements", "=ds=#sr# 405", "=ds="..AL["Trainer"] };
				{ 20, "s57683", "Trade_LeatherWorking", "=ds=Fur Lining - Attack Power", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 21, "s57701", "Trade_LeatherWorking", "=ds=Fur Lining - Arcane Resist", "=ds=#sr# 400", "=ds="..AL["Drop"]..": "..BabbleZone["Icecrown"] };
				{ 22, "s57692", "Trade_LeatherWorking", "=ds=Fur Lining - Fire Resist", "=ds=#sr# 400", "=ds="..AL["Drop"]..": "..BabbleZone["Icecrown"] };
				{ 23, "s57694", "Trade_LeatherWorking", "=ds=Fur Lining - Frost Resist", "=ds=#sr# 400", "=ds="..AL["Drop"]..": "..BabbleZone["Icecrown"] };
				{ 24, "s57699", "Trade_LeatherWorking", "=ds=Fur Lining - Nature Resist", "=ds=#sr# 400", "=ds="..AL["Drop"]..": "..BabbleZone["Icecrown"] };
				{ 25, "s57696", "Trade_LeatherWorking", "=ds=Fur Lining - Shadow Resist", "=ds=#sr# 400", "=ds="..AL["Drop"]..": "..BabbleZone["Icecrown"] };
				{ 26, "s57691", "Trade_LeatherWorking", "=ds=Fur Lining - Spell Power", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 27, "s57690", "Trade_LeatherWorking", "=ds=Fur Lining - Stamina", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 28, "s50966", "38372", "=q3=Nerubian Leg Armor", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 29, "s60584", "Trade_LeatherWorking", "=ds=Nerubian Leg Reinforcements", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 30, "s50963", "38376", "=q2=Heavy Borean Armor Kit", "=ds=#sr# 395", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s35557", "29536", "=q4=Nethercleft Leg Armor", "=ds=#sr# 365", "=ds="..BabbleFaction["Cenarion Expedition"].." - "..BabbleFaction["Exalted"] };
				{
					{ 2, "s35554", "29535", "=q4=Nethercobra Leg Armor", "=ds=#sr# 365", "=ds="..BabbleFaction["Thrallmar"].." - "..BabbleFaction["Exalted"] };
					{ 2, "s35554", "29535", "=q4=Nethercobra Leg Armor", "=ds=#sr# 365", "=ds="..BabbleFaction["Honor Hold"].." - "..BabbleFaction["Exalted"] };
				};
				{ 3, "s44770", "34207", "=q2=Glove Reinforcements", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 4, "s50962", "38375", "=q1=Borean Armor Kit", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 5, "s44970", "34330", "=q1=Heavy Knothide Armor Kit", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 6, "s35524", "29488", "=q2=Arcane Armor Kit", "=ds=#sr# 340", "=ds="..AL["Drop"]..": "..BabbleZone["The Black Morass"] };
				{ 7, "s35521", "29485", "=q2=Flame Armor Kit", "=ds=#sr# 340", "=ds="..AL["Drop"]..": "..BabbleZone["The Arcatraz"] };
				{ 8, "s35522", "29486", "=q2=Frost Armor Kit", "=ds=#sr# 340", "=ds="..AL["Drop"]..": "..BabbleZone["The Steamvault"] };
				{ 9, "s35523", "29487", "=q2=Nature Armor Kit", "=ds=#sr# 340", "=ds="..AL["Drop"]..": "..BabbleZone["The Slave Pens"] };
				{ 10, "s35520", "29483", "=q2=Shadow Armor Kit", "=ds=#sr# 340", "=ds="..AL["Drop"]..": "..BabbleZone["Sethekk Halls"] };
				{ 11, "s35555", "29534", "=q3=Clefthide Leg Armor", "=ds=#sr# 335", "=ds="..BabbleFaction["Cenarion Expedition"].." - "..BabbleFaction["Honored"] };
				{
					{ 12, "s35549", "29533", "=q3=Cobrahide Leg Armor", "=ds=#sr# 335", "=ds="..BabbleFaction["Thrallmar"].." - "..BabbleFaction["Honored"] };
					{ 12, "s35549", "29533", "=q3=Cobrahide Leg Armor", "=ds=#sr# 335", "=ds="..BabbleFaction["Honor Hold"].." - "..BabbleFaction["Honored"] };
				};
				{ 16, "s32458", "25652", "=q1=Magister's Armor Kit", "=ds=#sr# 325", "=ds="..BabbleFaction["The Scryers"].." - "..BabbleFaction["Revered"] };
				{ 17, "s32457", "25651", "=q1=Vindicator's Armor Kit", "=ds=#sr# 325", "=ds="..BabbleFaction["The Aldor"].." - "..BabbleFaction["Revered"] };
				{ 18, "s22727", "18251", "=q3=Core Armor Kit", "=ds=#sr# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Molten Core"] };
				{ 19, "s32456", "25650", "=q1=Knothide Armor Kit", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{ 20, "s19058", "15564", "=q1=Rugged Armor Kit", "=ds=#sr# 250", "=ds="..AL["Trainer"] };
				{ 21, "s10487", "8173", "=q1=Thick Armor Kit", "=ds=#sr# 200", "=ds="..AL["Trainer"] };
				{ 22, "s3780", "4265", "=q1=Heavy Armor Kit", "=ds=#sr# 150", "=ds="..AL["Trainer"] };
				{ 23, "s2165", "2313", "=q1=Medium Armor Kit", "=ds=#sr# 100", "=ds="..AL["Trainer"] };
				{ 24, "s2152", "2304", "=q1=Light Armor Kit", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = LEATHERWORKING..": "..AL["Item Enhancements"],
			module = moduleName, menu = "LEATHERWORKINGMENU"
		};
	};

	AtlasLoot_Data["LeatherDrumsBagsMisc"] = {
		["Normal"] = {
			{
				{ 1, "s100583", "70136", "=q3=Royal Scribe's Satchel", "=ds=#sr# 510", "=ds="..BabbleZone["Molten Front"]};
				{ 2, "s100586", "70137", "=q3=Triple-Reinforced Mining Bag", "=ds=#sr# 500", "=ds="..BabbleZone["Molten Front"]};
				{ 3, "s69386", "49633", "=q1=Drums of Forgotten Kings", "=ds=#sr# 450", "=ds="..AL["Trainer"] };
				{ 4, "s69388", "49634", "=q1=Drums of the Wild", "=ds=#sr# 450", "=ds="..AL["Trainer"] };
				{ 5, "s50971", "38347", "=q3=Mammoth Mining Bag", "=ds=#sr# 415", "=ds="..BabbleFaction["The Sons of Hodir"].." - "..BabbleFaction["Honored"] };
				{ 6, "s60643", "44446", "=q3=Pack of Endless Pockets", "=ds=#sr# 415", "=ds="..AL["Trainer"] };
				{ 7, "s50970", "38399", "=q3=Trapper's Traveling Pack", "=ds=#sr# 415", "=ds="..BabbleFaction["The Kalu'ak"].." - "..BabbleFaction["Revered"] };
				{ 8, "s35538", "29532", "=q2=Drums of Panic", "=ds=#sr# 370", "=ds="..BabbleFaction["Keepers of Time"].." - "..BabbleFaction["Honored"] };
				{ 9, "s35543", "29529", "=q3=Drums of Battle", "=ds=#sr# 365", "=ds="..BabbleFaction["The Sha'tar"].." - "..BabbleFaction["Honored"] };
				{ 10, "s44359", "34105", "=q3=Quiver of a Thousand Feathers", "=ds=#sr# 360" };
				{ 11, "s45117", "34490", "=q3=Bag of Many Hides", "=ds=#sr# 350", "=ds="..AL["Drop"]..": "..BabbleZone["Terokkar Forest"] };
				{ 16, "s32461", "25653", "=q3=Riding Crop", "=ds=#sr# 350", "=ds="..AL["Vendor"]..": "..BabbleZone["Old Hillsbrad Foothills"] };
				{
					{ 17, "s35539", "29531", "=q2=Drums of Restoration", "=ds=#sr# 350", "=ds="..BabbleFaction["The Mag'har"].." - "..BabbleFaction["Honored"] };
					{ 17, "s35539", "29531", "=q2=Drums of Restoration", "=ds=#sr# 350", "=ds="..BabbleFaction["Kurenai"].." - "..BabbleFaction["Honored"] };
				};
				{
					{ 18, "s35544", "29530", "=q2=Drums of Speed", "=ds=#sr# 345", "=ds="..BabbleFaction["The Mag'har"].." - "..BabbleFaction["Honored"] };
					{ 18, "s35544", "29530", "=q2=Drums of Speed", "=ds=#sr# 345", "=ds="..BabbleFaction["Kurenai"].." - "..BabbleFaction["Honored"] };
				};
				{ 19, "s35540", "29528", "=q2=Drums of War", "=ds=#sr# 340", "=ds="..AL["Trainer"] };
				{
					{ 20, "s35530", "29540", "=q2=Reinforced Mining Bag", "=ds=#sr# 325", "=ds="..BabbleFaction["The Mag'har"].." - "..BabbleFaction["Honored"] };
					{ 20, "s35530", "29540", "=q2=Reinforced Mining Bag", "=ds=#sr# 325", "=ds="..BabbleFaction["Kurenai"].." - "..BabbleFaction["Honored"] };
				};
				{ 21, "s45100", "34482", "=q2=Leatherworker's Satchel", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{
					{ 22, "s32482", "25679", "=q1=Comfortable Insoles", "=ds=#sr# 300", "=ds="..AL["Vendor"].." - "..BabbleZone["Silvermoon City"] };
					{ 22, "s32482", "25679", "=q1=Comfortable Insoles", "=ds=#sr# 300", "=ds="..AL["Vendor"].." - "..BabbleZone["The Exodar"] };
				};
				{
					{ 23, "s44953", "34086", "=q1=Winter Boots", "=ds=#sr# 285", "=ds="..AL["Feast of Winter Veil"].." "..AL["Vendor"]..": "..BabbleZone["Orgrimmar"] };
					{ 23, "s44953", "34086", "=q1=Winter Boots", "=ds=#sr# 285", "=ds="..AL["Feast of Winter Veil"].." "..AL["Vendor"]..": "..BabbleZone["Ironforge"] };
				};
				{ 24, "s22815", "18258", "=q2=Gordok Ogre Suit", "=ds=#sr# 275", "=ds="..AL["Old Quest Reward"] };
				{
					{ 25, "s23190", "18662", "=q1=Heavy Leather Ball", "=ds=#sr# 150", "=ds="..AL["Vendor"]..": "..BabbleZone["Orgrimmar"] };
					{ 25, "s23190", "18662", "=q1=Heavy Leather Ball", "=ds=#sr# 150", "=ds="..AL["Vendor"]..": "..BabbleZone["Ironforge"] };
				};
				{
					{ 26, "s5244", "5081", "=q1=Kodo Hide Bag", "=ds=#sr# 40", "=ds=#QUESTID:769#" };
					{ 26, "", "", "", "" };
				};
			};
		};
		info = {
			name = LEATHERWORKING..": "..AL["Drums, Bags and Misc."],
			module = moduleName, menu = "LEATHERWORKINGMENU"
		};
	};

	AtlasLoot_Data["LeatherLeather"] = {
		["Normal"] = {
			{
				{ 1, "s78436", "56516", "=q1=Heavy Savage Leather", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 2, "s84950", "52976", "=q1=Savage Leather", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 3, "s50936", "38425", "=q1=Heavy Borean Leather", "=ds=#sr# 390", "=ds="..AL["Trainer"] };
				{ 4, "s64661", "33568", "=q1=Borean Leather", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 5, "s32455", "23793", "=q1=Heavy Knothide Leather", "=ds=#sr# 325", "=ds="..AL["Trainer"] };
				{ 6, "s32454", "21887", "=q1=Knothide Leather", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{ 7, "s19047", "15407", "=q1=Cured Rugged Hide", "=ds=#sr# 250", "=ds="..AL["Trainer"] };
				{ 8, "s22331", "8170", "=q1=Rugged Leather", "=ds=#sr# 250", "=ds="..AL["Trainer"] };
				{ 16, "s10482", "8172", "=q1=Cured Thick Hide", "=ds=#sr# 200", "=ds="..AL["Trainer"] };
				{ 17, "s20650", "4304", "=q1=Thick Leather", "=ds=#sr# 200", "=ds="..AL["Trainer"] };
				{ 18, "s3818", "4236", "=q1=Cured Heavy Hide", "=ds=#sr# 150", "=ds="..AL["Trainer"] };
				{ 19, "s20649", "4234", "=q1=Heavy Leather", "=ds=#sr# 150", "=ds="..AL["Trainer"] };
				{ 20, "s3817", "4233", "=q1=Cured Medium Hide", "=ds=#sr# 100", "=ds="..AL["Trainer"] };
				{ 21, "s20648", "2319", "=q1=Medium Leather", "=ds=#sr# 100", "=ds="..AL["Trainer"] };
				{ 22, "s3816", "4231", "=q1=Cured Light Hide", "=ds=#sr# 35", "=ds="..AL["Trainer"] };
				{ 23, "s2881", "2318", "=q1=Light Leather", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = LEATHERWORKING..": "..BabbleInventory["Leather"],
			module = moduleName, menu = "LEATHERWORKINGMENU"
		};
	};

	AtlasLoot_Data["LeatherSpecializations"] = {
		["Normal"] = {
			{
				-- Dragonscale LW
				{ 1, 0, "INV_Box_01", "=q6="..DRAGONSCALE, "" };
				{
					{ 2, "s35576", "29516", "=q4=Ebon Netherscale Belt", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Badlands"] };
					{ 2, "s35576", "29516", "=q4=Ebon Netherscale Belt", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Azshara"] };
				};
				{
					{ 3, "s35577", "29517", "=q4=Ebon Netherscale Bracers", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Badlands"] };
					{ 3, "s35577", "29517", "=q4=Ebon Netherscale Bracers", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Azshara"] };
				};
				{
					{ 4, "s35575", "29515", "=q4=Ebon Netherscale Breastplate", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Badlands"] };
					{ 4, "s35575", "29515", "=q4=Ebon Netherscale Breastplate", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Azshara"] };
				};
				{
					{ 5, "s35582", "29520", "=q4=Netherstrike Belt", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Badlands"] };
					{ 5, "s35582", "29520", "=q4=Netherstrike Belt", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Azshara"] };
				};
				{
					{ 17, "s35584", "29521", "=q4=Netherstrike Bracers", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Badlands"] };
					{ 17, "s35584", "29521", "=q4=Netherstrike Bracers", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Azshara"] };
				};
				{
					{ 18, "s35580", "29519", "=q4=Netherstrike Breastplate", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Badlands"] };
					{ 18, "s35580", "29519", "=q4=Netherstrike Breastplate", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Azshara"] };
				};
				{ 19, "s36079", "29975", "=q3=Golden Dragonstrike Breastplate", "=ds=#sr# 330", "=ds="..AL["Trainer"] };
				{ 20, "s36076", "29971", "=q3=Dragonstrike Leggings", "=ds=#sr# 260", "=ds="..AL["Trainer"] };
				-- Elemental LW
				{ 7, 0, "INV_Box_01", "=q6="..ELEMENTAL, "" };
				{
					{ 8, "s35590", "29526", "=q4=Primalstrike Belt", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Thunder Bluff"] };
					{ 8, "s35590", "29526", "=q4=Primalstrike Belt", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Stormwind"] };
				};
				{
					{ 9, "s35591", "29527", "=q4=Primalstrike Bracers", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Thunder Bluff"] };
					{ 9, "s35591", "29527", "=q4=Primalstrike Bracers", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Stormwind"] };
				};
				{
					{ 10, "s35589", "29525", "=q4=Primalstrike Vest", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Thunder Bluff"] };
					{ 10, "s35589", "29525", "=q4=Primalstrike Vest", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Stormwind"] };
				};
				{ 23, "s36077", "29973", "=q3=Primalstorm Breastplate", "=ds=#sr# 330", "=ds="..AL["Trainer"] };
				{ 24, "s36074", "29964", "=q3=Blackstorm Leggings", "=ds=#sr# 260", "=ds="..AL["Trainer"] };
				-- Tribal LW
				{ 12, 0, "INV_Box_01", "=q6="..TRIBAL, "" };
				{
					{ 13, "s35587", "29524", "=q4=Windhawk Belt", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Northern Stranglethorn"] };
					{ 13, "s35587", "29524", "=q4=Windhawk Belt", "=ds=#sr# 375", "=ds="..AL["Trainer"].." "..AL["No Longer Available"] };
				};
				{
					{ 14, "s35588", "29523", "=q4=Windhawk Bracers", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Northern Stranglethorn"] };
					{ 14, "s35588", "29523", "=q4=Windhawk Bracers", "=ds=#sr# 375", "=ds="..AL["Trainer"].." "..AL["No Longer Available"] };
				};
				{
					{ 15, "s35585", "29522", "=q4=Windhawk Hauberk", "=ds=#sr# 375", "=ds="..AL["Trainer"]..": "..BabbleZone["Northern Stranglethorn"] };
					{ 15, "s35585", "29522", "=q4=Windhawk Hauberk", "=ds=#sr# 375", "=ds="..AL["Trainer"].." "..AL["No Longer Available"] };
				};
				{ 28, "s36078", "29974", "=q3=Living Crystal Breastplate", "=ds=#sr# 330", "=ds="..AL["Trainer"] };
				{ 29, "s36075", "29970", "=q3=Wildfeather Leggings", "=ds=#sr# 260", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = LEATHERWORKING..": "..AL["Specializations"],
			module = moduleName, menu = "LEATHERWORKINGMENU",
		};
	};

	AtlasLoot_Data["LeatherworkingCataVendor"] = {
		["Normal"] = {
			{
				{ 1, 52980, "", "=q3=Pristine Hide", "=ds=#e8#", "10 #heavysavageleather#" },
				{ 2, 67054, "", "=q1=Pattern: Vicious Dragonscale Bracers", "=ds=#p7# (510)", "10 #heavysavageleather#" },
				{ 3, 67055, "", "=q1=Pattern: Vicious Dragonscale Shoulders", "=ds=#p7# (510)", "10 #heavysavageleather#" },
				{ 4, 67046, "", "=q1=Pattern: Vicious Leather Bracers", "=ds=#p7# (510)", "10 #heavysavageleather#" },
				{ 5, 67048, "", "=q1=Pattern: Vicious Leather Gloves", "=ds=#p7# (510)", "10 #heavysavageleather#" },
				{ 6, 67049, "", "=q1=Pattern: Vicious Charscale Bracers", "=ds=#p7# (510)", "10 #heavysavageleather#" },
				{ 7, 67053, "", "=q1=Pattern: Vicious Charscale Gloves", "=ds=#p7# (510)", "10 #heavysavageleather#" },
				{ 8, 67044, "", "=q1=Pattern: Vicious Wyrmhide Belt", "=ds=#p7# (510)", "10 #heavysavageleather#" },
				{ 9, 67042, "", "=q1=Pattern: Vicious Wyrmhide Bracers", "=ds=#p7# (510)", "10 #heavysavageleather#" },
				{ 10, 67065, "", "=q1=Pattern: Vicious Dragonscale Boots", "=ds=#p7# (515)", "10 #heavysavageleather#" },
				{ 11, 67066, "", "=q1=Pattern: Vicious Dragonscale Gloves", "=ds=#p7# (515)", "10 #heavysavageleather#" },
				{ 12, 67060, "", "=q1=Pattern: Vicious Leather Boots", "=ds=#p7# (515)", "10 #heavysavageleather#" },
				{ 13, 67062, "", "=q1=Pattern: Vicious Leather Shoulders", "=ds=#p7# (515)", "10 #heavysavageleather#" },
				{ 14, 67064, "", "=q1=Pattern: Vicious Charscale Belt", "=ds=#p7# (515)", "10 #heavysavageleather#" },
				{ 15, 67063, "", "=q1=Pattern: Vicious Charscale Boots", "=ds=#p7# (515)", "10 #heavysavageleather#" },
				{ 16, 67058, "", "=q1=Pattern: Vicious Wyrmhide Boots", "=ds=#p7# (515)", "10 #heavysavageleather#" },
				{ 17, 67056, "", "=q1=Pattern: Vicious Wyrmhide Gloves", "=ds=#p7# (515)", "10 #heavysavageleather#" },
				{ 18, 67080, "", "=q1=Pattern: Vicious Dragonscale Belt", "=ds=#p7# (520)", "10 #heavysavageleather#" },
				{ 19, 67081, "", "=q1=Pattern: Vicious Dragonscale Helm", "=ds=#p7# (520)", "10 #heavysavageleather#" },
				{ 20, 67076, "", "=q1=Pattern: Vicious Leather Belt", "=ds=#p7# (520)", "10 #heavysavageleather#" },
				{ 21, 67077, "", "=q1=Pattern: Vicious Leather Helm", "=ds=#p7# (520)", "10 #heavysavageleather#" },
				{ 22, 67079, "", "=q1=Pattern: Vicious Charscale Legs", "=ds=#p7# (520)", "10 #heavysavageleather#" },
				{ 23, 67078, "", "=q1=Pattern: Vicious Charscale Shoulders", "=ds=#p7# (520)", "10 #heavysavageleather#" },
				{ 24, 67075, "", "=q1=Pattern: Vicious Wyrmhide Chest", "=ds=#p7# (520)", "10 #heavysavageleather#" },
				{ 25, 67074, "", "=q1=Pattern: Vicious Wyrmhide Shoulders", "=ds=#p7# (520)", "10 #heavysavageleather#" },
				{ 26, 67095, "", "=q1=Pattern: Assassin's Chestplate", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 27, 67070, "", "=q1=Pattern: Belt of Nefarious Whispers", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 28, 67093, "", "=q1=Pattern: Vicious Dragonscale Chest", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 29, 67092, "", "=q1=Pattern: Vicious Dragonscale Legs", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 30, 67087, "", "=q1=Pattern: Vicious Leather Chest", "=ds=#p7# (525)", "10 #heavysavageleather#" },
			};
			{
				{ 1, 67089, "", "=q1=Pattern: Vicious Leather Legs", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 2, 67090, "", "=q1=Pattern: Vicious Charscale Chest", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 3, 67091, "", "=q1=Pattern: Vicious Charscale Helm", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 4, 67086, "", "=q1=Pattern: Vicious Wyrmhide Helm", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 5, 67085, "", "=q1=Pattern: Vicious Wyrmhide Legs", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 6, 67084, "", "=q1=Pattern: Charscale Leg Armor", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 7, 67094, "", "=q1=Pattern: Chestguard of Nature's Fury", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 8, 67073, "", "=q1=Pattern: Corded Viper Belt", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 9, 67100, "", "=q1=Pattern: Dragonkiller Tunic", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 10, 68193, "", "=q1=Pattern: Dragonscale Leg Armor", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 11, 67068, "", "=q1=Pattern: Lightning Lash", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 12, 67082, "", "=q1=Pattern: Razor-Edged Cloak", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 13, 67072, "", "=q1=Pattern: Stormleather Sash", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 14, 67083, "", "=q1=Pattern: Twilight Dragonscale Cloak", "=ds=#p7# (525)", "10 #heavysavageleather#" },
				{ 15, 67096, "", "=q1=Pattern: Twilight Scale Chestguard", "=ds=#p7# (525)", "10 #heavysavageleather#" },
			};
		};
		info = {
			name = LEATHERWORKING..": "..AL["Cataclysm Vendor Sold Patterns"],
			module = moduleName, menu = "LEATHERWORKINGMENU",
		};
	};

		--------------
		--- Mining ---
		--------------

	AtlasLoot_Data["Mining"] = {
		["Normal"] = {
			{
				{ 1, "s74529", "51950", "=q2=Smelt Pyrium", "=ds=#sr# 525", "=ds="..AL["Trainer"] };
				{ 2, "s74537", "53039", "=q1=Smelt Hardened Elementium", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 3, "s74530", "52186", "=q1=Smelt Elementium", "=ds=#sr# 475", "=ds="..AL["Trainer"] };
				{ 4, "s84038", "54849", "=q1=Smelt Obsidium", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 5, "s55208", "37663", "=q2=Smelt Titansteel", "=ds=#sr# 450", "=ds="..AL["Trainer"] };
				{ 6, "s55211", "41163", "=q2=Smelt Titanium", "=ds=#sr# 450", "=ds="..AL["Trainer"] };
				{ 7, "s49258", "36913", "=q1=Smelt Saronite", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 8, "s49252", "36916", "=q1=Smelt Cobalt", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 9, "s46353", "35128", "=q2=Smelt Hardened Khorium", "=ds=#sr# 375", "=ds="..AL["Drop"]..": "..BabbleZone["Sunwell Plateau"] };
				{ 10, "s29686", "23573", "=q1=Smelt Hardened Adamantite", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
				{ 11, "s29361", "23449", "=q2=Smelt Khorium", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
				{ 12, "s29360", "23448", "=q2=Smelt Felsteel", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 13, "s29359", "23447", "=q2=Smelt Eternium", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 14, "s29358", "23446", "=q1=Smelt Adamantite", "=ds=#sr# 325", "=ds="..AL["Trainer"] };
				{ 15, "s29356", "23445", "=q1=Smelt Fel Iron", "=ds=#sr# 275", "=ds="..AL["Trainer"] };
				{ 16, "s35751", "22574", "=q1=Fire Sunder", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{ 17, "s35750", "22573", "=q1=Earth Shatter", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{ 18, "s22967", "17771", "=q5=Smelt Enchanted Elementium", "=ds=#sr# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Blackwing Lair"] };
				{ 19, "s70524", "12655", "=q1=Enchanted Thorium", "=ds=#sr# 250", "=ds="..AL["Trainer"] };
				{ 20, "s14891", "11371", "=q1=Smelt Dark Iron", "=ds=#sr# 230", "=ds=#QUESTID:4083#"};
				{ 21, "s16153", "12359", "=q1=Smelt Thorium", "=ds=#sr# 230", "=ds="..AL["Trainer"] };
				{ 22, "s10098", "6037", "=q2=Smelt Truesilver", "=ds=#sr# 230", "=ds="..AL["Trainer"] };
				{ 23, "s10097", "3860", "=q1=Smelt Mithril", "=ds=#sr# 175", "=ds="..AL["Trainer"] };
				{ 24, "s3569", "3859", "=q1=Smelt Steel", "=ds=#sr# 165", "=ds="..AL["Trainer"] };
				{ 25, "s3308", "3577", "=q2=Smelt Gold", "=ds=#sr# 155", "=ds="..AL["Trainer"] };
				{ 26, "s3307", "3575", "=q1=Smelt Iron", "=ds=#sr# 125", "=ds="..AL["Trainer"] };
				{ 27, "s2658", "2842", "=q2=Smelt Silver", "=ds=#sr# 75", "=ds="..AL["Trainer"] };
				{ 28, "s2659", "2841", "=q1=Smelt Bronze", "=ds=#sr# 65", "=ds="..AL["Trainer"] };
				{ 29, "s3304", "3576", "=q1=Smelt Tin", "=ds=#sr# 65", "=ds="..AL["Trainer"] };
				{ 30, "s2657", "2840", "=q1=Smelt Copper", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = MINING,
			module = moduleName, menu = "CRAFTINGMENU",
		};
	};

		-----------------
		--- Tailoring ---
		-----------------

	AtlasLoot_Data["TailoringArmorOld"] = {
		["Normal"] = {
			{
				{ 1, "s22866", "18405", "=q4=Belt of the Archmage", "=ds=#sr# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Dire Maul"]};
				{ 2, "s20849", "16979", "=q4=Flarecore Gloves", "=ds=#sr# 300", "=ds="..AL["Vendor"]..": "..BabbleZone["Blackrock Depths"]};
				{ 3, "s23667", "19165", "=q4=Flarecore Leggings", "=ds=#sr# 300", "=ds="..AL["Vendor"]..": "..BabbleZone["Blackrock Depths"]};
				{ 4, "s20848", "16980", "=q4=Flarecore Mantle", "=ds=#sr# 300", "=ds="..AL["Vendor"]..": "..BabbleZone["Blackrock Depths"]};
				{ 5, "s23666", "19156", "=q4=Flarecore Robe", "=ds=#sr# 300", "=ds="..AL["Vendor"]..": "..BabbleZone["Blackrock Depths"]};
				{ 6, "s22759", "18263", "=q4=Flarecore Wraps", "=ds=#sr# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Molten Core"]};
				{ 7, "s28208", "22658", "=q4=Glacial Cloak", "=ds=#sr# 300"};
				{ 8, "s28205", "22654", "=q4=Glacial Gloves", "=ds=#sr# 300"};
				{ 9, "s28207", "22652", "=q4=Glacial Vest", "=ds=#sr# 300"};
				{ 10, "s28209", "22655", "=q4=Glacial Wrists", "=ds=#sr# 300"};
				{ 11, "s18454", "14146", "=q4=Gloves of Spell Mastery", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{ 12, "s18457", "14152", "=q4=Robe of the Archmage", "=ds=#sr# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Lower Blackrock Spire"]};
				{ 13, "s18458", "14153", "=q4=Robe of the Void", "=ds=#sr# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Scholomance"]};
				{ 14, "s18456", "14154", "=q4=Truefaith Vestments", "=ds=#sr# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Stratholme"]};
				{ 15, "s23665", "19059", "=q3=Argent Shoulders", "=ds=#sr# 300", "=ds="..BabbleFaction["Argent Dawn"].." - "..BabbleFaction["Revered"]};
				{ 16, "s24093", "19684", "=q3=Bloodvine Boots", "=ds=#sr# 300", "=ds="..BabbleFaction["Zandalar Tribe"].." - "..BabbleFaction["Friendly"]};
				{ 17, "s24092", "19683", "=q3=Bloodvine Leggings", "=ds=#sr# 300", "=ds="..BabbleFaction["Zandalar Tribe"].." - "..BabbleFaction["Honored"]};
				{ 18, "s24091", "19682", "=q3=Bloodvine Vest", "=ds=#sr# 300", "=ds="..BabbleFaction["Zandalar Tribe"].." - "..BabbleFaction["Revered"]};
				{ 19, "s22870", "18413", "=q3=Cloak of Warding", "=ds=#sr# 300", "=ds="..AL["Drop"]};
				{ 20, "s22867", "18407", "=q3=Felcloth Gloves", "=ds=#sr# 300", "=ds="..AL["Drop"]};
				{ 21, "s28210", "22660", "=q3=Gaea's Embrace", "=ds=#sr# 300", "=ds="..BabbleFaction["Cenarion Circle"].." - "..BabbleFaction["Revered"]};
				{ 22, "s22868", "18408", "=q3=Inferno Gloves", "=ds=#sr# 300", "=ds="..AL["Drop"]};
				{ 23, "s23663", "19050", "=q3=Mantle of the Timbermaw", "=ds=#sr# 300", "=ds="..BabbleFaction["Timbermaw Hold"].." - "..BabbleFaction["Revered"]};
				{ 24, "s18452", "14140", "=q3=Mooncloth Circlet", "=ds=#sr# 300", "=ds="..AL["Drop"]};
				{ 25, "s22869", "18409", "=q3=Mooncloth Gloves", "=ds=#sr# 300", "=ds="..AL["Drop"]};
				{ 26, "s22902", "18486", "=q3=Mooncloth Robe", "=ds=#sr# 300", "=ds="..AL["Vendor"]};
				{ 27, "s18448", "14139", "=q3=Mooncloth Shoulders", "=ds=#sr# 300", "=ds="..AL["Drop"]};
				{ 28, "s18447", "14138", "=q3=Mooncloth Vest", "=ds=#sr# 300", "=ds="..AL["Drop"]};
				{ 29, "s24902", "20539", "=q3=Runed Stygian Belt", "=ds=#sr# 300", "=ds="..AL["Drop"]};
				{ 30, "s24903", "20537", "=q3=Runed Stygian Boots", "=ds=#sr# 300", "=ds="..AL["Drop"]};
			};
			{
				{ 1, "s24901", "20538", "=q3=Runed Stygian Leggings", "=ds=#sr# 300", "=ds="..AL["Drop"]};
				{ 2, "s28481", "22757", "=q3=Sylvan Crown", "=ds=#sr# 300", "=ds="..BabbleFaction["Cenarion Circle"].." - "..BabbleFaction["Honored"]};
				{ 3, "s28482", "22758", "=q3=Sylvan Shoulders", "=ds=#sr# 300", "=ds="..BabbleFaction["Cenarion Circle"].." - "..BabbleFaction["Friendly"]};
				{ 4, "s28480", "22756", "=q3=Sylvan Vest", "=ds=#sr# 300", "=ds="..BabbleFaction["Cenarion Circle"].." - "..BabbleFaction["Revered"]};
				{ 5, "s19435", "15802", "=q3=Mooncloth Boots", "=ds=#sr# 290", "=ds=#QUESTID:6032#"};
				{ 6, "s23664", "19056", "=q3=Argent Boots", "=ds=#sr# 290", "=ds="..BabbleFaction["Argent Dawn"].." - "..BabbleFaction["Honored"]};
				{ 7, "s18440", "14137", "=q3=Mooncloth Leggings", "=ds=#sr# 290", "=ds="..AL["Drop"]};
				{ 8, "s23662", "19047", "=q3=Wisdom of the Timbermaw", "=ds=#sr# 290", "=ds="..BabbleFaction["Timbermaw Hold"].." - "..BabbleFaction["Honored"]};
				{ 9, "s18436", "14136", "=q3=Robe of Winter Night", "=ds=#sr# 285", "=ds="..AL["Drop"]};
				{ 10, "s18422", "14134", "=q3=Cloak of Fire", "=ds=#sr# 275", "=ds="..AL["Drop"]..": "..BabbleZone["Blackrock Mountain"]};
				{ 11, "s12092", "10041", "=q3=Dreamweave Circlet", "=ds=#sr# 250", "=ds="..AL["Trainer"] };
				{ 12, "s12067", "10019", "=q3=Dreamweave Gloves", "=ds=#sr# 225", "=ds="..AL["Trainer"] };
				{ 13, "s12070", "10021", "=q3=Dreamweave Vest", "=ds=#sr# 225", "=ds="..AL["Trainer"] };
				{ 14, "s3862", "4327", "=q3=Icy Cloak", "=ds=#sr# 200", "=ds="..AL["Vendor"] };
				{ 15, "s8770", "7054", "=q3=Robe of Power", "=ds=#sr# 190", "=ds="..AL["Trainer"] };
				{ 16, "s63742", "45626", "=q3=Spidersilk Drape", "=ds=#sr# 125", "=ds="..AL["Trainer"] };
				{ 17, "s3855", "4320", "=q3=Spidersilk Boots", "=ds=#sr# 125", "=ds="..AL["Trainer"] };
				{ 18, "s18451", "14106", "=q2=Felcloth Robe", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{ 19, "s18453", "14112", "=q2=Felcloth Shoulders", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{ 20, "s18449", "13867", "=q2=Runecloth Shoulders", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{ 21, "s18446", "14128", "=q2=Wizardweave Robe", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{ 22, "s18450", "14130", "=q2=Wizardweave Turban", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{ 23, "s18439", "14104", "=q2=Brightcloth Pants", "=ds=#sr# 290", "=ds="..AL["Drop"] };
				{ 24, "s18442", "14111", "=q2=Felcloth Hood", "=ds=#sr# 290", "=ds="..AL["Trainer"] };
				{ 25, "s18441", "14144", "=q2=Ghostweave Pants", "=ds=#sr# 290", "=ds="..AL["Trainer"] };
				{ 26, "s18444", "13866", "=q2=Runecloth Headband", "=ds=#sr# 295", "=ds="..AL["Trainer"] };
				{ 27, "s18437", "14108", "=q2=Felcloth Boots", "=ds=#sr# 285", "=ds="..AL["Trainer"] };
				{ 28, "s18438", "13865", "=q2=Runecloth Pants", "=ds=#sr# 285", "=ds="..AL["Trainer"] };
				{ 29, "s18434", "14045", "=q2=Cindercloth Pants", "=ds=#sr# 280", "=ds="..AL["Drop"]..": "..BabbleZone["Burning Steppes"]};
				{ 30, "s18424", "13871", "=q2=Frostweave Pants", "=ds=#sr# 280", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s18423", "13864", "=q2=Runecloth Boots", "=ds=#sr# 280", "=ds="..AL["Trainer"] };
				{ 2, "s18420", "14103", "=q2=Brightcloth Cloak", "=ds=#sr# 275", "=ds="..AL["Trainer"] };
				{ 3, "s18418", "14044", "=q2=Cindercloth Cloak", "=ds=#sr# 275", "=ds="..AL["Drop"]..": "..BabbleZone["Burning Steppes"]};
				{ 4, "s18419", "14107", "=q2=Felcloth Pants", "=ds=#sr# 275", "=ds="..AL["Vendor"] };
				{ 5, "s18416", "14141", "=q2=Ghostweave Vest", "=ds=#sr# 275", "=ds="..AL["Trainer"] };
				{ 6, "s22813", "18258", "=q2=Gordok Ogre Suit", "=ds=#sr# 275", "=ds=#QUESTID:27119#"};
				{ 7, "s18417", "13863", "=q2=Runecloth Gloves", "=ds=#sr# 275", "=ds="..AL["Trainer"] };
				{ 8, "s18421", "14132", "=q2=Wizardweave Leggings", "=ds=#sr# 275", "=ds="..AL["Trainer"] };
				{ 9, "s18415", "14101", "=q2=Brightcloth Gloves", "=ds=#sr# 270", "=ds="..AL["Trainer"] };
				{ 10, "s18414", "14100", "=q2=Brightcloth Robe", "=ds=#sr# 270", "=ds="..AL["Trainer"] };
				{ 11, "s18412", "14043", "=q2=Cindercloth Gloves", "=ds=#sr# 270", "=ds="..AL["Drop"]..": "..BabbleZone["Searing Gorge"]};
				{ 12, "s18413", "14142", "=q2=Ghostweave Gloves", "=ds=#sr# 270", "=ds="..AL["Trainer"] };
				{ 13, "s18411", "13870", "=q2=Frostweave Gloves", "=ds=#sr# 265", "=ds="..AL["Trainer"] };
				{ 14, "s18410", "14143", "=q2=Ghostweave Belt", "=ds=#sr# 265", "=ds="..AL["Trainer"] };
				{ 15, "s18409", "13860", "=q2=Runecloth Cloak", "=ds=#sr# 265", "=ds="..AL["Trainer"] };
				{ 16, "s18408", "14042", "=q2=Cindercloth Vest", "=ds=#sr# 260", "=ds="..AL["Drop"]..": "..BabbleZone["Searing Gorge"]};
				{ 17, "s18406", "13858", "=q2=Runecloth Robe", "=ds=#sr# 260", "=ds="..AL["Trainer"] };
				{ 18, "s18407", "13857", "=q2=Runecloth Tunic", "=ds=#sr# 260", "=ds="..AL["Trainer"] };
				{ 19, "s18404", "13868", "=q2=Frostweave Robe", "=ds=#sr# 255", "=ds="..AL["Drop"] };
				{ 20, "s18403", "13869", "=q2=Frostweave Tunic", "=ds=#sr# 255", "=ds="..AL["Trainer"] };
				{ 21, "s18402", "13856", "=q2=Runecloth Belt", "=ds=#sr# 255", "=ds="..AL["Trainer"] };
				{ 22, "s12088", "10044", "=q2=Cindercloth Boots", "=ds=#sr# 245", "=ds="..AL["Trainer"] };
				{ 23, "s12086", "10025", "=q2=Shadoweave Mask", "=ds=#sr# 245"};
				{ 24, "s12081", "10030", "=q2=Admiral's Hat", "=ds=#sr# 240", "=ds="..AL["Vendor"]..": "..BabbleZone["The Cape of Stranglethorn"]};
				{ 25, "s12084", "10033", "=q2=Red Mageweave Headband", "=ds=#sr# 240", "=ds="..AL["Drop"] };
				{ 26, "s12082", "10031", "=q2=Shadoweave Boots", "=ds=#sr# 240", "=ds="..AL["Trainer"] };
				{ 27, "s12078", "10029", "=q2=Red Mageweave Shoulders", "=ds=#sr# 235", "=ds="..AL["Drop"] };
				{ 28, "s12076", "10028", "=q2=Shadoweave Shoulders", "=ds=#sr# 235", "=ds="..AL["Trainer"] };
				{ 29, "s12073", "10026", "=q2=Black Mageweave Boots", "=ds=#sr# 230", "=ds="..AL["Trainer"] };
				{ 30, "s12072", "10024", "=q2=Black Mageweave Headband", "=ds=#sr# 230", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s12074", "10027", "=q2=Black Mageweave Shoulders", "=ds=#sr# 230", "=ds="..AL["Trainer"] };
				{ 2, "s12069", "10042", "=q2=Cindercloth Robe", "=ds=#sr# 225", "=ds="..AL["Trainer"] };
				{ 3, "s12066", "10018", "=q2=Red Mageweave Gloves", "=ds=#sr# 225", "=ds="..AL["Drop"] };
				{ 4, "s12071", "10023", "=q2=Shadoweave Gloves", "=ds=#sr# 225", "=ds="..AL["Trainer"] };
				{ 5, "s12059", "10008", "=q2=White Bandit Mask", "=ds=#sr# 215", "=ds="..AL["Drop"] };
				{ 6, "s12053", "10003", "=q2=Black Mageweave Gloves", "=ds=#sr# 215", "=ds="..AL["Trainer"] };
				{ 7, "s12060", "10009", "=q2=Red Mageweave Pants", "=ds=#sr# 215", "=ds="..AL["Drop"] };
				{ 8, "s12056", "10007", "=q2=Red Mageweave Vest", "=ds=#sr# 215", "=ds="..AL["Drop"] };
				{ 9, "s12055", "10004", "=q2=Shadoweave Robe", "=ds=#sr# 215", "=ds="..AL["Trainer"] };
				{ 10, "s12050", "10001", "=q2=Black Mageweave Robe", "=ds=#sr# 210", "=ds="..AL["Trainer"] };
				{ 11, "s8804", "7064", "=q2=Crimson Silk Gloves", "=ds=#sr# 210", "=ds="..AL["Trainer"] };
				{ 12, "s12052", "10002", "=q2=Shadoweave Pants", "=ds=#sr# 210", "=ds="..AL["Trainer"] };
				{ 13, "s12049", "9999", "=q2=Black Mageweave Leggings", "=ds=#sr# 205", "=ds="..AL["Trainer"] };
				{ 14, "s12048", "9998", "=q2=Black Mageweave Vest", "=ds=#sr# 205", "=ds="..AL["Trainer"] };
				{ 15, "s8802", "7063", "=q2=Crimson Silk Robe", "=ds=#sr# 205", "=ds="..AL["Vendor"]..": "..BabbleZone["Tanaris"]};
				{ 16, "s3864", "4329", "=q2=Star Belt", "=ds=#sr# 200", "=ds="..AL["Drop"] };
				{ 17, "s8797", "7061", "=q2=Earthen Silk Belt", "=ds=#sr# 195", "=ds="..AL["Drop"] };
				{ 18, "s8795", "7060", "=q2=Azure Shoulders", "=ds=#sr# 190", "=ds="..AL["Drop"] };
				{ 19, "s8793", "7059", "=q2=Crimson Silk Shoulders", "=ds=#sr# 190", "=ds="..AL["Drop"] };
				{ 20, "s3861", "4326", "=q2=Long Silken Cloak", "=ds=#sr# 185", "=ds="..AL["Trainer"] };
				{ 21, "s3863", "4328", "=q2=Spider Belt", "=ds=#sr# 180", "=ds="..AL["Drop"] };
				{ 22, "s8789", "7056", "=q2=Crimson Silk Cloak", "=ds=#sr# 180", "=ds="..AL["Vendor"]..": "..BabbleZone["The Cape of Stranglethorn"]};
				{ 23, "s8774", "7057", "=q2=Green Silken Shoulders", "=ds=#sr# 180", "=ds="..AL["Trainer"] };
				{ 24, "s8766", "7052", "=q2=Azure Silk Belt", "=ds=#sr# 175", "=ds="..AL["Trainer"] };
				{ 25, "s8786", "7053", "=q2=Azure Silk Cloak", "=ds=#sr# 175", "=ds="..AL["Vendor"]..": "..BabbleZone["Arathi Highlands"]};
				{ 26, "s3860", "4325", "=q2=Boots of the Enchanter", "=ds=#sr# 175", "=ds="..AL["Drop"] };
				{ 27, "s8772", "7055", "=q2=Crimson Silk Belt", "=ds=#sr# 175", "=ds="..AL["Trainer"] };
				{ 28, "s8764", "7051", "=q2=Earthen Vest", "=ds=#sr# 170", "=ds="..AL["Trainer"] };
				{ 29, "s3858", "4323", "=q2=Shadow Hood", "=ds=#sr# 170", "=ds="..AL["Drop"] };
				{ 30, "s3857", "4322", "=q2=Enchanter's Cowl", "=ds=#sr# 165", "=ds="..AL["Vendor"]..": "..BabbleZone["The Cape of Stranglethorn"]};
			};
			{
				{ 1, "s8784", "7065", "=q2=Green Silk Armor", "=ds=#sr# 165", "=ds="..AL["Drop"] };
				{ 2, "s3859", "4324", "=q2=Azure Silk Vest", "=ds=#sr# 150", "=ds="..AL["Trainer"] };
				{ 3, "s102171", "72101", "=q2=Black Silk Vest", "=ds=#sr# 150", "=ds="..AL["Drop"] };
				{ 4, "s6692", "5770", "=q2=Robes of Arcana", "=ds=#sr# 150", "=ds="..AL["Drop"]..": "..BabbleZone["Thousand Needles"]};
				{ 5, "s8782", "7049", "=q2=Truefaith Gloves", "=ds=#sr# 150", "=ds="..AL["Drop"] };
				{ 6, "s3854", "4319", "=q2=Azure Silk Gloves", "=ds=#sr# 145", "=ds="..AL["Vendor"] };
				{ 7, "s8780", "7047", "=q2=Hands of Darkness", "=ds=#sr# 145", "=ds="..AL["Drop"] };
				{ 8, "s8758", "7046", "=q2=Azure Silk Pants", "=ds=#sr# 140", "=ds="..AL["Trainer"] };
				{ 9, "s3856", "4321", "=q2=Spider Silk Slippers", "=ds=#sr# 140", "=ds="..AL["Drop"] };
				{ 10, "s6690", "5766", "=q2=Lesser Wizard's Robe", "=ds=#sr# 135", "=ds="..AL["Trainer"] };
				{ 11, "s3852", "4318", "=q2=Gloves of Meditation", "=ds=#sr# 130", "=ds="..AL["Trainer"] };
				{ 12, "s3868", "4331", "=q2=Phoenix Gloves", "=ds=#sr# 125", "=ds="..AL["Drop"] };
				{ 13, "s3851", "4317", "=q2=Phoenix Pants", "=ds=#sr# 125", "=ds="..AL["Drop"] };
				{ 14, "s12047", "10048", "=q2=Colorful Kilt", "=ds=#sr# 120", "=ds="..AL["Drop"] };
				{ 15, "s7643", "6264", "=q2=Greater Adept's Robe", "=ds=#sr# 115", "=ds="..AL["Vendor"] };
				{ 16, "s3850", "4316", "=q2=Heavy Woolen Pants", "=ds=#sr# 110", "=ds="..AL["Trainer"] };
				{ 17, "s2403", "2585", "=q2=Gray Woolen Robe", "=ds=#sr# 105", "=ds="..AL["Drop"] };
				{ 18, "s7639", "6263", "=q2=Blue Overalls", "=ds=#sr# 100", "=ds="..AL["Vendor"] };
				{ 19, "s3844", "4311", "=q2=Heavy Woolen Cloak", "=ds=#sr# 100", "=ds="..AL["Drop"] };
				{ 20, "s3847", "4313", "=q2=Red Woolen Boots", "=ds=#sr# 95", "=ds="..AL["Drop"] };
				{ 21, "s2401", "2583", "=q2=Woolen Boots", "=ds=#sr# 95", "=ds="..AL["Trainer"] };
				{ 22, "s6521", "5542", "=q2=Pearl-clasped Cloak", "=ds=#sr# 90", "=ds="..AL["Trainer"] };
				{ 23, "s3843", "4310", "=q2=Heavy Woolen Gloves", "=ds=#sr# 85", "=ds="..AL["Trainer"] };
				{ 24, "s3845", "4312", "=q2=Soft-soled Linen Boots", "=ds=#sr# 80", "=ds="..AL["Trainer"] };
				{ 25, "s2395", "2578", "=q2=Barbaric Linen Vest", "=ds=#sr# 70", "=ds="..AL["Trainer"] };
				{ 26, "s7633", "6242", "=q2=Blue Linen Robe", "=ds=#sr# 70", "=ds="..AL["Vendor"] };
				{ 27, "s3842", "4309", "=q2=Handstitched Linen Britches", "=ds=#sr# 70", "=ds="..AL["Trainer"] };
				{ 28, "s7630", "6240", "=q2=Blue Linen Vest", "=ds=#sr# 55", "=ds="..AL["Vendor"] };
				{ 29, "s7629", "6239", "=q2=Red Linen Vest", "=ds=#sr# 55", "=ds="..AL["Drop"] };
				{ 30, "s2389", "2572", "=q2=Red Linen Robe", "=ds=#sr# 40", "=ds="..AL["Drop"] };
			};
			{
				{ 1, "s7623", "6238", "=q2=Brown Linen Robe", "=ds=#sr# 30", "=ds="..AL["Trainer"] };
				{ 2, "s7624", "6241", "=q2=White Linen Robe", "=ds=#sr# 30", "=ds="..AL["Trainer"] };
				{ 3, "s49677", "6836", "=q1=Dress Shoes", "=ds=#sr# 250", "=ds="..AL["Vendor"]..": "..BabbleZone["Tanaris"]};
				{ 4, "s50644", "38277", "=q1=Haliscan Jacket", "=ds=#sr# 250", "=ds="..AL["Vendor"]..": "..BabbleZone["Tanaris"]};
				{ 5, "s50647", "38278", "=q1=Haliscan Pantaloons", "=ds=#sr# 245", "=ds="..AL["Vendor"]..": "..BabbleZone["Tanaris"]};
				{ 6, "s26403", "21154", "=q1=Festival Dress", "=ds=#sr# 250", "=ds="..AL["Vendor"]..": "..BabbleZone["Moonglade"]};
				{ 7, "s26407", "21542", "=q1=Festive Red Pant Suit", "=ds=#sr# 250", "=ds="..AL["Vendor"]..": "..BabbleZone["Moonglade"]};
				{ 8, "s12093", "10036", "=q1=Tuxedo Jacket", "=ds=#sr# 250", "=ds="..AL["Vendor"] };
				{ 9, "s44950", "34087", "=q1=Green Winter Clothes", "=ds=#sr# 250", "=ds="..AL["Vendor"] };
				{ 10, "s44958", "34085", "=q1=Red Winter Clothes", "=ds=#sr# 250", "=ds="..AL["Vendor"] };
				{ 11, "s12091", "10040", "=q1=White Wedding Dress", "=ds=#sr# 250", "=ds="..AL["Vendor"] };
				{ 12, "s12089", "10035", "=q1=Tuxedo Pants", "=ds=#sr# 245", "=ds="..AL["Vendor"] };
				{ 13, "s12077", "10053", "=q1=Simple Black Dress", "=ds=#sr# 235", "=ds="..AL["Trainer"] };
				{ 14, "s8799", "7062", "=q1=Crimson Silk Pantaloons", "=ds=#sr# 195", "=ds="..AL["Trainer"] };
				{ 15, "s8791", "7058", "=q1=Crimson Silk Vest", "=ds=#sr# 185", "=ds="..AL["Trainer"] };
				{ 16, "s8762", "7050", "=q1=Silk Headband", "=ds=#sr# 160", "=ds="..AL["Trainer"] };
				{ 17, "s8760", "7048", "=q1=Azure Silk Hood", "=ds=#sr# 145", "=ds="..AL["Trainer"] };
				{ 18, "s3849", "4315", "=q1=Reinforced Woolen Shoulders", "=ds=#sr# 120", "=ds="..AL["Drop"] };
				{ 19, "s3848", "4314", "=q1=Double-stitched Woolen Shoulders", "=ds=#sr# 110", "=ds="..AL["Trainer"] };
				{ 20, "s8467", "6787", "=q1=White Woolen Dress", "=ds=#sr# 110", "=ds="..AL["Trainer"] };
				{ 21, "s2399", "2582", "=q1=Green Woolen Vest", "=ds=#sr# 85", "=ds="..AL["Trainer"] };
				{ 22, "s12046", "10047", "=q1=Simple Kilt", "=ds=#sr# 75", "=ds="..AL["Trainer"] };
				{ 23, "s2402", "2584", "=q1=Woolen Cape", "=ds=#sr# 75", "=ds="..AL["Trainer"] };
				{ 24, "s2386", "2569", "=q1=Linen Boots", "=ds=#sr# 65", "=ds="..AL["Trainer"] };
				{ 25, "s3841", "4308", "=q1=Green Linen Bracers", "=ds=#sr# 60", "=ds="..AL["Trainer"] };
				{ 26, "s2397", "2580", "=q1=Reinforced Linen Cape", "=ds=#sr# 60", "=ds="..AL["Trainer"] };
				{ 27, "s8465", "6786", "=q1=Simple Dress", "=ds=#sr# 40", "=ds="..AL["Trainer"] };
				{ 28, "s3840", "4307", "=q1=Heavy Linen Gloves", "=ds=#sr# 35", "=ds="..AL["Trainer"] };
				{ 29, "s3914", "4343", "=q1=Brown Linen Pants", "=ds=#sr# 30", "=ds="..AL["Trainer"] };
				{ 30, "s12045", "10046", "=q1=Simple Linen Boots", "=ds=#sr# 20", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s8776", "7026", "=q1=Linen Belt", "=ds=#sr# 15", "=ds="..AL["Trainer"] };
				{ 2, "s2385", "2568", "=q1=Brown Linen Vest", "=ds=#sr# 10", "=ds="..AL["Trainer"] };
				{ 3, "s2387", "2570", "=q1=Linen Cloak", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
				{ 4, "s12044", "10045", "=q1=Simple Linen Pants", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = TAILORING..": "..AL["Cloth Armor"],
			module = moduleName, menu = "TAILORINGMENU",
		};
	};

	AtlasLoot_Data["TailoringArmorBC"] = {
		["Normal"] = {
			{
				{ 1, "s31456", "24267", "=q4=Battlecast Hood", "=ds=#sr# 375", "=ds="..AL["Drop"] };
				{ 2, "s31453", "24263", "=q4=Battlecast Pants", "=ds=#sr# 375", "=ds="..AL["Drop"] };
				{ 3, "s36315", "30038", "=q4=Belt of Blasting", "=ds=#sr# 375", "=ds="..AL["Drop"] };
				{ 4, "s36316", "30036", "=q4=Belt of the Long Road", "=ds=#sr# 375", "=ds="..AL["Drop"] };
				{ 5, "s36317", "30037", "=q4=Boots of Blasting", "=ds=#sr# 375", "=ds="..AL["Drop"] };
				{ 6, "s36318", "30035", "=q4=Boots of the Long Road", "=ds=#sr# 375", "=ds="..AL["Drop"] };
				{ 7, "s41205", "32586", "=q4=Bracers of Nimble Thought", "=ds=#sr# 375", "=ds="..AL["Drop"] };
				{ 8, "s26758", "21871", "=q4=Frozen Shadoweave Robe", "=ds=#sr# 375", "=ds="..AL["Vendor"] };
				{ 9, "s41206", "32587", "=q4=Mantle of Nimble Thought", "=ds=#sr# 375", "=ds="..AL["Drop"] };
				{ 10, "s40060", "32420", "=q4=Night's End", "=ds=#sr# 375", "=ds="..BabbleFaction["Ashtongue Deathsworn"].." - "..BabbleFaction["Honored"]};
				{ 11, "s26762", "21875", "=q4=Primal Mooncloth Robe", "=ds=#sr# 375", "=ds="..AL["Vendor"] };
				{ 12, "s26781", "21865", "=q4=Soulcloth Vest", "=ds=#sr# 375", "=ds="..AL["Drop"] };
				{ 13, "s40021", "32392", "=q4=Soulguard Bracers", "=ds=#sr# 375", "=ds="..BabbleFaction["Ashtongue Deathsworn"].." - "..BabbleFaction["Friendly"]};
				{ 14, "s40024", "32390", "=q4=Soulguard Girdle", "=ds=#sr# 375", "=ds="..BabbleFaction["Ashtongue Deathsworn"].." - "..BabbleFaction["Friendly"]};
				{ 15, "s40023", "32389", "=q4=Soulguard Leggings", "=ds=#sr# 375", "=ds="..BabbleFaction["Ashtongue Deathsworn"].." - "..BabbleFaction["Honored"]};
				{ 16, "s40020", "32391", "=q4=Soulguard Slippers", "=ds=#sr# 375", "=ds="..BabbleFaction["Ashtongue Deathsworn"].." - "..BabbleFaction["Honored"]};
				{ 17, "s26754", "21848", "=q4=Spellfire Robe", "=ds=#sr# 375", "=ds="..AL["Vendor"] };
				{ 18, "s31455", "24266", "=q4=Spellstrike Hood", "=ds=#sr# 375", "=ds="..AL["Drop"] };
				{ 19, "s31452", "24262", "=q4=Spellstrike Pants", "=ds=#sr# 375", "=ds="..AL["Drop"] };
				{ 20, "s41208", "32585", "=q4=Swiftheal Mantle", "=ds=#sr# 375", "=ds="..AL["Drop"] };
				{ 21, "s41207", "32584", "=q4=Swiftheal Wraps", "=ds=#sr# 375", "=ds="..AL["Drop"] };
				{ 22, "s31454", "24264", "=q4=Whitemend Hood", "=ds=#sr# 375", "=ds="..AL["Drop"] };
				{ 23, "s31451", "24261", "=q4=Whitemend Pants", "=ds=#sr# 375", "=ds="..AL["Drop"] };
				{ 24, "s31444", "24257", "=q4=Black Belt of Knowledge", "=ds=#sr# 365", "=ds="..AL["Drop"] };
				{ 25, "s26757", "21870", "=q4=Frozen Shadoweave Boots", "=ds=#sr# 365", "=ds="..AL["Vendor"] };
				{ 26, "s31443", "24256", "=q4=Girdle of Ruination", "=ds=#sr# 365", "=ds="..AL["Drop"] };
				{ 27, "s46129", "34367", "=q4=Hands of Eternal Light", "=ds=#sr# 365", "=ds="..AL["Drop"] };
				{ 28, "s31450", "24260", "=q4=Manaweave Cloak", "=ds=#sr# 365", "=ds="..AL["Drop"] };
				{ 29, "s26761", "21874", "=q4=Primal Mooncloth Shoulders", "=ds=#sr# 365", "=ds="..AL["Vendor"] };
				{ 30, "s31448", "24258", "=q4=Resolute Cape", "=ds=#sr# 365", "=ds="..AL["Drop"] };
			};
			{
				{ 1, "s46131", "34365", "=q4=Robe of Eternal Light", "=ds=#sr# 365", "=ds="..AL["Drop"] };
				{ 2, "s26780", "21864", "=q4=Soulcloth Shoulders", "=ds=#sr# 365", "=ds="..AL["Drop"] };
				{ 3, "s26753", "21847", "=q4=Spellfire Gloves", "=ds=#sr# 365", "=ds="..AL["Vendor"] };
				{ 4, "s46128", "34366", "=q4=Sunfire Handwraps", "=ds=#sr# 365", "=ds="..AL["Drop"] };
				{ 5, "s46130", "34364", "=q4=Sunfire Robe", "=ds=#sr# 365", "=ds="..AL["Drop"] };
				{ 6, "s31442", "24255", "=q4=Unyielding Girdle", "=ds=#sr# 365", "=ds="..AL["Drop"] };
				{ 7, "s31449", "24259", "=q4=Vengeance Wrap", "=ds=#sr# 365", "=ds="..AL["Drop"] };
				{ 8, "s26756", "21869", "=q4=Frozen Shadoweave Shoulders", "=ds=#sr# 355", "=ds="..AL["Vendor"] };
				{ 9, "s26760", "21873", "=q4=Primal Mooncloth Belt", "=ds=#sr# 355", "=ds="..AL["Vendor"] };
				{ 10, "s26779", "21863", "=q4=Soulcloth Gloves", "=ds=#sr# 355", "=ds="..AL["Vendor"] };
				{ 11, "s26752", "21846", "=q4=Spellfire Belt", "=ds=#sr# 355", "=ds="..AL["Vendor"] };
				{ 12, "s26784", "21868", "=q3=Arcanoweave Robe", "=ds=#sr# 370", "=ds="..AL["Drop"] };
				{ 13, "s37884", "30839", "=q3=Flameheart Vest", "=ds=#sr# 370", "=ds="..BabbleFaction["The Aldor"].." - "..BabbleFaction["Exalted"]};
				{ 14, "s26783", "21867", "=q3=Arcanoweave Boots", "=ds=#sr# 360", "=ds="..AL["Drop"] };
				{ 15, "s37883", "30838", "=q3=Flameheart Gloves", "=ds=#sr# 360", "=ds="..BabbleFaction["The Aldor"].." - "..BabbleFaction["Honored"]};
				{ 16, "s26777", "21861", "=q3=Imbued Netherweave Robe", "=ds=#sr# 360", "=ds="..AL["Vendor"] };
				{ 17, "s26778", "21862", "=q3=Imbued Netherweave Tunic", "=ds=#sr# 360", "=ds="..AL["Vendor"] };
				{ 18, "s26782", "21866", "=q3=Arcanoweave Bracers", "=ds=#sr# 350", "=ds="..AL["Drop"] };
				{ 19, "s31437", "24251", "=q3=Blackstrike Bracers", "=ds=#sr# 350", "=ds="..AL["Drop"] };
				{ 20, "s31435", "24250", "=q3=Bracers of Havok", "=ds=#sr# 350", "=ds="..AL["Drop"] };
				{ 21, "s37873", "30831", "=q3=Cloak of Arcane Evasion", "=ds=#sr# 350", "=ds="..BabbleFaction["Lower City"].." - "..BabbleFaction["Honored"]};
				{ 22, "s31440", "24253", "=q3=Cloak of Eternity", "=ds=#sr# 350", "=ds="..AL["Drop"] };
				{ 23, "s31438", "24252", "=q3=Cloak of the Black Void", "=ds=#sr# 350", "=ds="..AL["Drop"] };
				{ 24, "s37882", "30837", "=q3=Flameheart Bracers", "=ds=#sr# 350", "=ds="..BabbleFaction["The Aldor"].." - "..BabbleFaction["Friendly"]};
				{ 25, "s26776", "21860", "=q3=Imbued Netherweave Boots", "=ds=#sr# 350", "=ds="..AL["Vendor"]..": "..BabbleZone["Zangarmarsh"]};
				{ 26, "s31434", "24249", "=q3=Unyielding Bracers", "=ds=#sr# 350", "=ds="..AL["Drop"] };
				{ 27, "s31441", "24254", "=q3=White Remedy Cape", "=ds=#sr# 350", "=ds="..AL["Drop"] };
				{ 28, "s26775", "21859", "=q3=Imbued Netherweave Pants", "=ds=#sr# 340", "=ds="..AL["Vendor"]..": "..BabbleZone["Zangarmarsh"]};
				{ 29, "s26774", "21855", "=q2=Netherweave Tunic", "=ds=#sr# 345", "=ds="..AL["Vendor"] };
				{ 30, "s26773", "21854", "=q2=Netherweave Robe", "=ds=#sr# 340", "=ds="..AL["Vendor"] };
			};
			{
				{ 1, "s26772", "21853", "=q2=Netherweave Boots", "=ds=#sr# 335", "=ds="..AL["Trainer"] };
				{ 2, "s26771", "21852", "=q2=Netherweave Pants", "=ds=#sr# 325", "=ds="..AL["Trainer"] };
				{ 3, "s26770", "21851", "=q2=Netherweave Gloves", "=ds=#sr# 320", "=ds="..AL["Trainer"] };
				{ 4, "s26765", "21850", "=q2=Netherweave Belt", "=ds=#sr# 310", "=ds="..AL["Trainer"] };
				{ 5, "s26764", "21849", "=q2=Netherweave Bracers", "=ds=#sr# 310", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = TAILORING..": "..AL["Cloth Armor"],
			module = moduleName, menu = "TAILORINGMENU",
		};
	};

	AtlasLoot_Data["TailoringArmorWotLK"] = {
		["Normal"] = {
			{
				{ 1, "s70551", "49890", "=q4=Deathfrost Boots", "=ds=#sr# 450", "=ds="..AL["Vendor"]..""};
				{ 2, "s70550", "49891", "=q4=Leggings of Woven Death", "=ds=#sr# 450", "=ds="..AL["Vendor"]..""};
				{ 3, "s70552", "49892", "=q4=Lightweave Leggings", "=ds=#sr# 450", "=ds="..AL["Vendor"]..""};
				{ 4, "s70553", "49893", "=q4=Sandals of Consecration", "=ds=#sr# 450", "=ds="..AL["Vendor"]..""};
				{ 5, "s67066", "47603", "=q4=Merlin's Robe", "=ds=#sr# 450", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 6, "s67146", "47604", "=q4=Merlin's Robe", "=ds=#sr# 450", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 7, "s67064", "47605", "=q4=Royal Moonshroud Robe", "=ds=#sr# 450", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 8, "s67144", "47606", "=q4=Royal Moonshroud Robe", "=ds=#sr# 450", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 9, "s67145", "47586", "=q4=Bejeweled Wizard's Bracers", "=ds=#sr# 450", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 10, "s67079", "47585", "=q4=Bejeweled Wizard's Bracers", "=ds=#sr# 450", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 11, "s67065", "47587", "=q4=Royal Moonshroud Bracers", "=ds=#sr# 450", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 12, "s67147", "47588", "=q4=Royal Moonshroud Bracers", "=ds=#sr# 450", "=ds="..AL["Drop"]..": "..BabbleZone["Trial of the Crusader"]};
				{ 13, "s63205", "45558", "=q4=Cord of the White Dawn", "=ds=#sr# 450", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 14, "s63203", "45557", "=q4=Sash of Ancient Power", "=ds=#sr# 450", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 15, "s63206", "45567", "=q4=Savior's Slippers", "=ds=#sr# 450", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 16, "s63204", "45566", "=q4=Spellslinger's Slippers", "=ds=#sr# 450", "=ds="..AL["Drop"]..": "..BabbleZone["Ulduar"]};
				{ 17, "s56017", "41610", "=q4=Deathchill Cloak", "=ds=#sr# 420", "=ds="..AL["Achievement"] };
				{ 18, "s56016", "41609", "=q4=Wispcloak", "=ds=#sr# 415", "=ds="..AL["Achievement"] };
				{ 19, "s56026", "42101", "=q4=Ebonweave Robe", "=ds=#sr# 450", "=ds="..AL["Trainer"] };
				{ 20, "s56024", "42100", "=q4=Moonshroud Robe", "=ds=#sr# 450", "=ds="..AL["Trainer"] };
				{ 21, "s56028", "42102", "=q4=Spellweave Robe", "=ds=#sr# 450", "=ds="..AL["Trainer"] };
				{ 22, "s56027", "42111", "=q4=Ebonweave Gloves", "=ds=#sr# 440", "=ds="..AL["Trainer"] };
				{ 23, "s56025", "42103", "=q4=Moonshroud Gloves", "=ds=#sr# 440", "=ds="..AL["Trainer"] };
				{ 24, "s56029", "42113", "=q4=Spellweave Gloves", "=ds=#sr# 440", "=ds="..AL["Trainer"] };
				{ 25, "s60993", "43583", "=q4=Glacial Robe", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 26, "s60994", "43585", "=q4=Glacial Slippers", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 27, "s60990", "43584", "=q4=Glacial Waistband", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 28, "s56021", "42093", "=q3=Frostmoon Pants", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 29, "s56018", "41984", "=q3=Hat of Wintry Doom", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 30, "s56023", "42096", "=q3=Aurora Slippers", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s56020", "41986", "=q3=Deep Frozen Cord", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 2, "s59585", "43970", "=q3=Frostsavage Boots", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 3, "s59589", "43971", "=q3=Frostsavage Cowl", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 4, "s59586", "41516", "=q3=Frostsavage Gloves", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 5, "s59588", "43975", "=q3=Frostsavage Leggings", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 6, "s59587", "43972", "=q3=Frostsavage Robe", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 7, "s59584", "43973", "=q3=Frostsavage Shoulders", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 8, "s56022", "42095", "=q3=Light Blessed Mittens", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 9, "s56019", "41985", "=q3=Silky Iceshard Boots", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 10, "s55941", "41554", "=q3=Black Duskweave Robe", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 11, "s55925", "41553", "=q3=Black Duskweave Leggings", "=ds=#sr# 415", "=ds="..AL["Trainer"] };
				{ 12, "s55943", "41555", "=q3=Black Duskweave Wristwraps", "=ds=#sr# 415", "=ds="..AL["Trainer"] };
				{ 13, "s64730", "45810", "=q3=Cloak of Crimson Snow", "=ds=#sr# 405", "=ds="..AL["Trainer"] };
				{ 14, "s64729", "45811", "=q3=Frostguard Drape", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 15, "s59582", "43969", "=q3=Frostsavage Belt", "=ds=#sr# 415", "=ds="..AL["Trainer"] };
				{ 16, "s59583", "43974", "=q3=Frostsavage Bracers", "=ds=#sr# 415", "=ds="..AL["Trainer"] };
				{ 17, "s56015", "41608", "=q3=Cloak of Frozen Spirits", "=ds=#sr# 395", "=ds="..AL["Trainer"] };
				{ 18, "s56014", "41607", "=q3=Cloak of the Moon", "=ds=#sr# 390", "=ds="..AL["Trainer"] };
				{ 19, "s55911", "41525", "=q3=Mystic Frostwoven Robe", "=ds=#sr# 390", "=ds="..AL["Trainer"] };
				{ 20, "s55910", "41523", "=q3=Mystic Frostwoven Shoulders", "=ds=#sr# 385", "=ds="..AL["Trainer"] };
				{ 21, "s55913", "41528", "=q3=Mystic Frostwoven Wriststraps", "=ds=#sr# 385", "=ds="..AL["Trainer"] };
				{ 22, "s55923", "41550", "=q2=Duskweave Shoulders", "=ds=#sr# 410", "=ds="..AL["Trainer"] };
				{ 23, "s55924", "41544", "=q2=Duskweave Boots", "=ds=#sr# 410", "=ds="..AL["Trainer"] };
				{ 24, "s55921", "41549", "=q2=Duskweave Robe", "=ds=#sr# 405", "=ds="..AL["Trainer"] };
				{ 25, "s55922", "41545", "=q2=Duskweave Gloves", "=ds=#sr# 405", "=ds="..AL["Trainer"] };
				{ 26, "s55920", "41551", "=q2=Duskweave Wriststraps", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 27, "s55914", "41543", "=q2=Duskweave Belt", "=ds=#sr# 395", "=ds="..AL["Trainer"] };
				{ 28, "s55919", "41546", "=q2=Duskweave Cowl", "=ds=#sr# 395", "=ds="..AL["Trainer"] };
				{ 29, "s55901", "41548", "=q2=Duskweave Leggings", "=ds=#sr# 395", "=ds="..AL["Trainer"] };
				{ 30, "s55907", "41521", "=q2=Frostwoven Cowl", "=ds=#sr# 380", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s56030", "41519", "=q2=Frostwoven Leggings", "=ds=#sr# 380", "=ds="..AL["Trainer"] };
				{ 2, "s55906", "41520", "=q2=Frostwoven Boots", "=ds=#sr# 375", "=ds="..AL["Trainer"] };
				{ 3, "s55908", "41522", "=q2=Frostwoven Belt", "=ds=#sr# 370", "=ds="..AL["Trainer"] };
				{ 4, "s55904", "44211", "=q2=Frostwoven Gloves", "=ds=#sr# 360", "=ds="..AL["Trainer"] };
				{ 5, "s55903", "41515", "=q2=Frostwoven Robe", "=ds=#sr# 360", "=ds="..AL["Trainer"] };
				{ 6, "s55902", "41513", "=q2=Frostwoven Shoulders", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 7, "s56031", "41512", "=q2=Frostwoven Wriststraps", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = TAILORING..": "..AL["Cloth Armor"],
			module = moduleName, menu = "TAILORINGMENU",
		};
	};

	AtlasLoot_Data["TailoringArmorCata"] = {
		["Normal"] = {
			{
				{ 1, "s101923", "71989", "=q4=Bracers of Unconquered Power", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 2, "s101922", "71990", "=q4=Dreamwraps of the Light", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 3, "s101921", "71980", "=q4=Lavaquake Legwraps", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 4, "s101920", "71981", "=q4=World Mender's Pants", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Dragon Soul"]};
				{ 5, "s99449", "69945", "=q4=Don Tayo's Inferno Mittens", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 6, "s99448", "69944", "=q4=Grips of Altered Reality", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 7, "s99460", "69954", "=q4=Boots of the Black Flame", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 8, "s99459", "69953", "=q4=Endless Dream Walkers", "=ds=#sr# 525", "=ds="..AL["Drop"]..": "..BabbleZone["Firelands"]};
				{ 9, "s75301", "54506", "=q4=Flame-Ascended Pantaloons", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 10, "s75298", "54504", "=q4=Belt of the Depths", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 11, "s75300", "54505", "=q4=Breeches of Mended Nightmares", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 12, "s75299", "54503", "=q4=Dreamless Belt", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 13, "s75307", "75072", "=q3=Vicious Embersilk Pants", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 14, "s75306", "75073", "=q3=Vicious Embersilk Cowl", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 15, "s75305", "75093", "=q3=Vicious Embersilk Robe", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 16, "s75304", "75062", "=q3=Vicious Fireweave Cowl", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 17, "s75303", "75088", "=q3=Vicious Fireweave Robe", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 18, "s75302", "75082", "=q3=Vicious Fireweave Pants", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 19, "s75297", "75095", "=q3=Vicious Embersilk Boots", "=ds=#sr# 520", "=ds="..AL["Trainer"] };
				{ 20, "s75296", "75063", "=q3=Vicious Fireweave Gloves", "=ds=#sr# 520", "=ds="..AL["Trainer"] };
				{ 21, "s75294", "75087", "=q3=Vicious Fireweave Boots", "=ds=#sr# 515", "=ds="..AL["Trainer"] };
				{ 22, "s75295", "75070", "=q3=Vicious Embersilk Gloves", "=ds=#sr# 515", "=ds="..AL["Trainer"] }; 
				{ 23, "s75292", "75091", "=q3=Vicious Fireweave Shoulders", "=ds=#sr# 510", "=ds="..AL["Trainer"] };
				{ 24, "s75269", "75086", "=q3=Vicious Fireweave Belt", "=ds=#sr# 510", "=ds="..AL["Trainer"] };
				{ 25, "s75293", "75096", "=q3=Vicious Embersilk Belt", "=ds=#sr# 510", "=ds="..AL["Trainer"] };
				{ 26, "s75291", "75064", "=q3=Vicious Embersilk Shoulders", "=ds=#sr# 505", "=ds="..AL["Trainer"] };
				{ 27, "s75270", "75098", "=q3=Vicious Embersilk Bracers", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 28, "s75290", "75089", "=q3=Vicious Fireweave Bracers", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 29, "s99537", "75065", "=q3=Vicious Embersilk Cape", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 30, "s75266", "54485", "=q3=Spiritmend Cowl", "=ds=#sr# 485", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s75267", "54486", "=q2=Spiritmend Robe", "=ds=#sr# 485", "=ds="..AL["Trainer"] };
				{ 2, "s75263", "54483", "=q2=Spiritmend Leggings", "=ds=#sr# 480", "=ds="..AL["Trainer"] };
				{ 3, "s75262", "54484", "=q2=Spiritmend Gloves", "=ds=#sr# 480", "=ds="..AL["Trainer"] };
				{ 4, "s75261", "54482", "=q2=Spiritmend Boots", "=ds=#sr# 475", "=ds="..AL["Trainer"] };
				{ 5, "s75260", "54479", "=q3=Spiritmend Shoulders", "=ds=#sr# 475", "=ds="..AL["Trainer"] };
				{ 6, "s75259", "54480", "=q2=Spiritmend Bracers", "=ds=#sr# 470", "=ds="..AL["Trainer"] };
				{ 7, "s75258", "54481", "=q2=Spiritmend Belt", "=ds=#sr# 470", "=ds="..AL["Trainer"] };
				{ 8, "s75256", "54476", "=q2=Deathsilk Cowl", "=ds=#sr# 465", "=ds="..AL["Trainer"] };
				{ 9, "s75257", "54475", "=q3=Deathsilk Robe", "=ds=#sr# 465", "=ds="..AL["Trainer"] };
				{ 10, "s75253", "54478", "=q3=Deathsilk Gloves", "=ds=#sr# 460", "=ds="..AL["Trainer"] };
				{ 11, "s75254", "54472", "=q2=Deathsilk Leggings", "=ds=#sr# 460", "=ds="..AL["Trainer"] };
				{ 12, "s75251", "54474", "=q2=Deathsilk Shoulders", "=ds=#sr# 455", "=ds="..AL["Trainer"] };
				{ 13, "s75252", "54477", "=q2=Deathsilk Boots", "=ds=#sr# 445", "=ds="..AL["Trainer"] };
				{ 14, "s75249", "54473", "=q2=Deathsilk Bracers", "=ds=#sr# 445", "=ds="..AL["Trainer"] };
				{ 15, "s75248", "54471", "=q2=Deathsilk Belt", "=ds=#sr# 445", "=ds="..AL["Trainer"] };
				{ 16, "s75288", "54441", "=q1=Black Embersilk Gown", "=ds=#sr# 500", "=ds="..AL["Vendor"]};
			};
		};
		info = {
			name = TAILORING..": " ..AL["Cloth Armor"],
			module = moduleName, menu = "TAILORINGMENU",
		};
	};

	AtlasLoot_Data["TailoringBags"] = {
		["Normal"] = {
			{
				{ 1, "s75308", "54444", "=q3=Illusionary Bag", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 2, "s100585", "70138", "=q3=Luxurious Silk Gem Bag", "=ds=#sr# 515", "=ds="..BabbleZone["Molten Front"]};
				{ 3, "s75268", "54446", "=q2=Hyjal Expedition Bag", "=ds=#sr# 490", "=ds="..AL["Trainer"] };
				{ 4, "s75264", "54443", "=q2=Embersilk Bag", "=ds=#sr# 480", "=ds="..AL["Trainer"] };
				{ 5, "s75265", "54445", "=q3=Otherworldly Bag", "=ds=#sr# 480", "=ds="..AL["Trainer"] };
				{ 6, "s56007", "41599", "=q2=Frostweave Bag", "=ds=#sr# 410", "=ds="..AL["Trainer"] };
				{ 7, "s56005", "41600", "=q3=Glacial Bag", "=ds=#sr# 445", "=ds="..BabbleFaction["The Sons of Hodir"].." - "..BabbleFaction["Exalted"] };
				{ 8, "s56006", "41598", "=q3=Mysterious Bag", "=ds=#sr# 440", "=ds="..BabbleFaction["The Wyrmrest Accord"].." - "..BabbleFaction["Revered"] };
				{ 9, "s56004", "41597", "=q3=Abyssal Bag", "=ds=#sr# 435", "=ds="..BabbleFaction["Knights of the Ebon Blade"].." - "..BabbleFaction["Revered"] };
				{ 10, "s63924", "45773", "=q3=Emerald Bag", "=ds=#sr# 435", "=ds="..BabbleFaction["The Kalu'ak"].." - "..BabbleFaction["Revered"] };
				{ 11, "s26759", "21872", "=q3=Ebon Shadowbag",  "=ds=#sr# 375", "=ds="..AL["Vendor"] };
				{ 12, "s50194", "38225", "=q3=Mycah's Botanical Bag", "=ds=#sr# 375", "=ds="..BabbleFaction["Sporeggar"].." - "..BabbleFaction["Revered"] };
				{ 13, "s26763", "21876", "=q3=Primal Mooncloth Bag", "=ds=#sr# 375", "=ds="..AL["Vendor"] };
				{ 14, "s26755", "21858", "=q3=Spellfire Bag", "=ds=#sr# 375", "=ds="..AL["Vendor"] };
				{ 15, "s31459", "24270", "=q2=Bag of Jewels", "=ds=#sr# 340", "=ds="..AL["Vendor"] };
				{ 16, "s26749", "21843", "=q2=Imbued Netherweave Bag", "=ds=#sr# 340", "=ds="..AL["Vendor"] };
				{ 17, "s26746", "21841", "=q2=Netherweave Bag", "=ds=#sr# 315", "=ds="..AL["Trainer"] };
				{ 18, "s26087", "21342", "=q4=Core Felcloth Bag", "=ds=#sr# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Molten Core"] };
				{ 19, "s18455", "14156", "=q3=Bottomless Bag", "=ds=#sr# 300", "=ds="..AL["Drop"]};
				{ 20, "s27660", "22249", "=q2=Big Bag of Enchantment", "=ds=#sr# 300", "=ds="..AL["Drop"]..": "..BabbleZone["Dire Maul"] };
				{ 21, "s18445", "14155", "=q2=Mooncloth Bag", "=ds=#sr# 300", "=ds="..AL["Drop"]};
				{ 22, "s27725", "22252", "=q2=Satchel of Cenarius", "=ds=#sr# 300", "=ds="..BabbleFaction["Cenarion Circle"].." - "..BabbleFaction["Revered"] };
				{ 23, "s26086", "21341", "=q3=Felcloth Bag", "=ds=#sr# 280", "=ds="..AL["Drop"]..": "..BabbleZone["Scholomance"] };
				{ 24, "s27659", "22248", "=q2=Enchanted Runecloth Bag", "=ds=#sr# 275", "=ds="..AL["Vendor"]..": "..BabbleZone["Silithus"]};
				{ 25, "s27724", "22251", "=q2=Cenarion Herb Bag", "=ds=#sr# 275", "=ds="..BabbleFaction["Cenarion Circle"].." - "..BabbleFaction["Friendly"] };
				{ 26, "s26085", "21340", "=q2=Soul Pouch", "=ds=#sr# 260", "=ds="..AL["Vendor"]..": "..BabbleZone["Tanaris"]};
				{ 27, "s27658", "22246", "=q2=Enchanted Mageweave Pouch", "=ds=#sr# 225", "=ds="..AL["Vendor"]..""};
				{ 28, "s18405", "14046", "=q1=Runecloth Bag", "=ds=#sr# 260", "=ds="..AL["Vendor"]..": "..BabbleZone["Winterspring"]};
				{ 29, "s12079", "10051", "=q1=Red Mageweave Bag", "=ds=#sr# 235", "=ds="..AL["Trainer"] };
				{ 30, "s12065", "10050", "=q1=Mageweave Bag", "=ds=#sr# 225", "=ds="..AL["Trainer"] };
			};
			{
				{ 1, "s6695", "5765", "=q1=Black Silk Pack", "=ds=#sr# 185", "=ds="..AL["Drop"]};
				{ 2, "s6693", "5764", "=q1=Green Silk Pack", "=ds=#sr# 175", "=ds="..AL["Drop"]};
				{ 3, "s3813", "4245", "=q1=Small Silk Pack", "=ds=#sr# 150", "=ds="..AL["Trainer"] };
				{ 4, "s6688", "5763", "=q1=Red Woolen Bag", "=ds=#sr# 115", "=ds="..AL["Vendor"] };
				{ 5, "s3758", "4241", "=q1=Green Woolen Bag", "=ds=#sr# 95", "=ds="..AL["Drop"]};
				{ 6, "s3757", "4240", "=q1=Woolen Bag", "=ds=#sr# 80", "=ds="..AL["Trainer"] };
				{ 7, "s6686", "5762", "=q1=Red Linen Bag", "=ds=#sr# 70", "=ds="..AL["Vendor"] };
				{ 8, "s3755", "4238", "=q1=Linen Bag", "=ds=#sr# 45", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = TAILORING..": "..AL["Bags"],
			module = moduleName, menu = "TAILORINGMENU",
		};
	};

	AtlasLoot_Data["TailoringItemEnhancement"] = {
		["Normal"] = {
			{
				{ 1, "s75175", "INV_Misc_Thread_01", "=ds=Darkglow Embroidery - Rank 2", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 2, "s55769", "INV_Misc_Thread_01", "=ds=Darkglow Embroidery - Rank 1", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 4, "s75172", "INV_Misc_Thread_01", "=ds=Lightweave Embroidery - Rank 2", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 5, "s55642", "INV_Misc_Thread_01", "=ds=Lightweave Embroidery - Rank 1", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 7, "s75178", "INV_Misc_Thread_01", "=ds=Swordguard Embroidery - Rank 2", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 8, "s55777", "INV_Misc_Thread_01", "=ds=Swordguard Embroidery - Rank 1", "=ds=#sr# 420", "=ds="..AL["Trainer"] };
				{ 10, "s75154", "Spell_Nature_AstralRecalGroup", "=ds=Master's Spellthread - Rank 2", "=ds=#sr# 475", "=ds="..AL["Trainer"] };
				{ 11, "s56034", "Spell_Nature_AstralRecalGroup", "=ds=Master's Spellthread - Rank 1", "=ds=#sr# 405", "=ds="..AL["Trainer"] };
				{ 13, "s75155", "Spell_Nature_AstralRecalGroup", "=ds=Sanctified Spellthread - Rank 2", "=ds=#sr# 475", "=ds="..AL["Trainer"] };
				{ 14, "s56039", "Spell_Nature_AstralRecalGroup", "=ds=Sanctified Spellthread - Rank 1", "=ds=#sr# 405", "=ds="..AL["Trainer"] };
				{ 16, "s75309", "54448", "=q4=Powerful Enchanted Spellthread", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 17, "s75310", "54450", "=q4=Powerful Ghostly Spellthread", "=ds=#sr# 525", "=ds="..AL["Vendor"]};
				{ 18, "s56009", "41602", "=q4=Brilliant Spellthread", "=ds=#sr# 430", "=ds="..BabbleFaction["Argent Crusade"].." - "..BabbleFaction["Exalted"] };
				{ 19, "s56011", "41604", "=q4=Sapphire Spellthread", "=ds=#sr# 430", "=ds="..BabbleFaction["Kirin Tor"].." - "..BabbleFaction["Exalted"] };
				{ 20, "s31433", "24276", "=q4=Golden Spellthread", "=ds=#sr# 375", "=ds="..BabbleFaction["The Aldor"].." - "..BabbleFaction["Exalted"] };
				{ 21, "s31432", "24274", "=q4=Runic Spellthread", "=ds=#sr# 375", "=ds="..BabbleFaction["The Scryers"].." - "..BabbleFaction["Exalted"] };
				{ 22, "s75255", "54449", "=q3=Ghostly Spellthread", "=ds=#sr# 450", "=ds="..AL["Trainer"] };
				{ 23, "s75250", "54447", "=q3=Enchanted Spellthread", "=ds=#sr# 450", "=ds="..AL["Trainer"] };
				{ 24, "s56010", "41603", "=q3=Azure Spellthread", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 25, "s56008", "41601", "=q3=Shining Spellthread", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 26, "s31430", "24273", "=q3=Mystic Spellthread", "=ds=#sr# 335", "=ds="..BabbleFaction["The Scryers"].." - "..BabbleFaction["Honored"] };
				{ 27, "s31431", "24275", "=q3=Silver Spellthread", "=ds=#sr# 335", "=ds="..BabbleFaction["The Aldor"].." - "..BabbleFaction["Honored"] };
			};
		};
		info = {
			name = TAILORING..": "..AL["Item Enhancements"],
			module = moduleName, menu = "TAILORINGMENU",
		};
	};

	AtlasLoot_Data["TailoringMisc"] = {
		["Normal"] = {
			{
				{ 1, "s75597", "54797", "=q4=Frosty Flying Carpet", "=ds=#sr# 425", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"] };
				{ 2, "s60971", "44558", "=q4=Magnificent Flying Carpet", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 3, "s60969", "44554", "=q3=Flying Carpet", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{ 4, "s75247", "54442", "=q1=Embersilk Net", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 5, "s55898", "41509", "=q1=Frostweave Net", "=ds=#sr# 360", "=ds="..AL["Trainer"] };
				{ 6, "s31460", "24268", "=q1=Netherweave Net", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = TAILORING..": "..BabbleInventory["Miscellaneous"],
			module = moduleName, menu = "TAILORINGMENU",
		};
	};

	AtlasLoot_Data["TailoringCloth"] = {
		["Normal"] = {
			{
				{ 1, "s94743", "54440", "=q3=Dream of Destruction", "=ds=#sr# 525", "=ds="..AL["Trainer"] };
				{ 2, "s75141", "54440", "=q3=Dream of Skywall", "=ds=#sr# 515", "=ds="..AL["Trainer"] };
				{ 3, "s75145", "54440", "=q3=Dream of Ragnaros", "=ds=#sr# 510", "=ds="..AL["Trainer"] };
				{ 4, "s75142", "54440", "=q3=Dream of Deepholm", "=ds=#sr# 505", "=ds="..AL["Trainer"] };
				{ 5, "s75144", "54440", "=q3=Dream of Hyjal", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 6, "s75146", "54440", "=q3=Dream of Azshara", "=ds=#sr# 500", "=ds="..AL["Trainer"] };
				{ 7, "s56002", "41593", "=q3=Ebonweave", "=ds=#sr# 415", "=ds="..AL["Trainer"] };
				{ 8, "s56001", "41594", "=q3=Moonshroud", "=ds=#sr# 415", "=ds="..AL["Trainer"] };
				{ 9, "s56003", "41595", "=q3=Spellweave", "=ds=#sr# 415", "=ds="..AL["Trainer"] };
				{ 10, "s26751", "21845", "=q3=Primal Mooncloth", "=ds=#sr# 350", "=ds="..AL["Vendor"] };
				{ 11, "s36686", "24272", "=q3=Shadowcloth", "=ds=#sr# 350", "=ds="..AL["Vendor"] };
				{ 12, "s31373", "24271", "=q3=Spellcloth", "=ds=#sr# 350", "=ds="..AL["Vendor"] };
				{ 13, "s18560", "14342", "=q1=Mooncloth", "=ds=#sr# 250", "=ds="..AL["Vendor"]..": "..BabbleZone["Winterspring"]};
				{ 16, "s74964", "53643", "=q1=Bolt of Embersilk Cloth", "=ds=#sr# 425", "=ds="..AL["Trainer"] };
				{ 17, "s55900", "41511", "=q2=Bolt of Imbued Frostweave", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 18, "s55899", "41510", "=q1=Bolt of Frostweave", "=ds=#sr# 350", "=ds="..AL["Trainer"] };
				{ 19, "s26750", "21844", "=q1=Bolt of Soulcloth", "=ds=#sr# 345", "=ds="..AL["Vendor"] };
				{ 20, "s26747", "21842", "=q2=Bolt of Imbued Netherweave", "=ds=#sr# 325", "=ds="..AL["Vendor"] };
				{ 21, "s26745", "21840", "=q1=Bolt of Netherweave", "=ds=#sr# 300", "=ds="..AL["Trainer"] };
				{ 22, "s18401", "14048", "=q1=Bolt of Runecloth", "=ds=#sr# 250", "=ds="..AL["Trainer"] };
				{ 23, "s3865", "4339", "=q1=Bolt of Mageweave", "=ds=#sr# 175", "=ds="..AL["Trainer"] };
				{ 24, "s3839", "4305", "=q1=Bolt of Silk Cloth", "=ds=#sr# 125", "=ds="..AL["Trainer"] };
				{ 25, "s2964", "2997", "=q1=Bolt of Woolen Cloth", "=ds=#sr# 75", "=ds="..AL["Trainer"] };
				{ 26, "s2963", "2996", "=q1=Bolt of Linen Cloth", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = TAILORING..": "..BabbleInventory["Cloth"],
			module = moduleName, menu = "TAILORINGMENU",
		};
	};

	AtlasLoot_Data["TailoringShirts"] = {
		["Normal"] = {
			{
				{ 1, "s55994", "41249", "=q1=Blue Lumberjack Shirt", "=ds=#sr# 400", "=ds="..AL["Drop"] };
				{ 2, "s55998", "41253", "=q1=Blue Workman's Shirt", "=ds=#sr# 400", "=ds="..AL["Drop"] };
				{ 3, "s55996", "41250", "=q1=Green Lumberjack Shirt", "=ds=#sr# 400", "=ds="..AL["Drop"] };
				{ 4, "s56000", "41255", "=q1=Green Workman's Shirt", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 5, "s55993", "41248", "=q1=Red Lumberjack Shirt", "=ds=#sr# 400", "=ds="..AL["Drop"] };
				{ 6, "s55997", "41252", "=q1=Red Workman's Shirt", "=ds=#sr# 400", "=ds="..AL["Drop"] };
				{ 7, "s55999", "41254", "=q1=Rustic Workman's Shirt", "=ds=#sr# 400", "=ds="..AL["Drop"] };
				{ 8, "s55995", "41251", "=q1=Yellow Lumberjack Shirt", "=ds=#sr# 400", "=ds="..AL["Trainer"] };
				{ 9, "s12085", "10034", "=q1=Tuxedo Shirt", "=ds=#sr# 240", "=ds="..AL["Vendor"] };
				{ 10, "s12080", "10055", "=q1=Pink Mageweave Shirt", "=ds=#sr# 235", "=ds="..AL["Vendor"] };
				{ 11, "s12075", "10054", "=q1=Lavender Mageweave Shirt", "=ds=#sr# 230", "=ds="..AL["Vendor"] };
				{ 12, "s12064", "10052", "=q1=Orange Martial Shirt", "=ds=#sr# 220", "=ds="..AL["Vendor"] };
				{ 13, "s12061", "10056", "=q1=Orange Mageweave Shirt", "=ds=#sr# 215", "=ds="..AL["Trainer"] };
				{ 14, "s3873", "4336", "=q1=Black Swashbuckler's Shirt", "=ds=#sr# 200", "=ds="..AL["Vendor"]..": "..BabbleZone["The Cape of Stranglethorn"] };
				{ 15, "s21945", "17723", "=q1=Green Holiday Shirt", "=ds=#sr# 190", "=ds=#QUESTID:6984#"};
				{ 16, "s3872", "4335", "=q1=Rich Purple Silk Shirt", "=ds=#sr# 185", "=ds="..AL["Drop"] };
				{ 17, "s8489", "6796", "=q1=Red Swashbuckler's Shirt", "=ds=#sr# 175", "=ds="..AL["Trainer"] };
				{ 18, "s3871", "4334", "=q1=Formal White Shirt", "=ds=#sr# 170", "=ds="..AL["Trainer"] };
				{ 19, "s8483", "6795", "=q1=White Swashbuckler's Shirt", "=ds=#sr# 160", "=ds="..AL["Trainer"] };
				{ 20, "s3870", "4333", "=q1=Dark Silk Shirt", "=ds=#sr# 155", "=ds="..AL["Vendor"] };
				{ 21, "s3869", "4332", "=q1=Bright Yellow Shirt", "=ds=#sr# 135", "=ds="..AL["Trainer"] };
				{ 22, "s7892", "6384", "=q1=Stylish Blue Shirt", "=ds=#sr# 120", "=ds="..AL["Drop"] };
				{ 23, "s7893", "6385", "=q1=Stylish Green Shirt", "=ds=#sr# 120", "=ds="..AL["Drop"] };
				{ 24, "s3866", "4330", "=q1=Stylish Red Shirt", "=ds=#sr# 110", "=ds="..AL["Trainer"] };
				{ 25, "s2406", "2587", "=q1=Gray Woolen Shirt", "=ds=#sr# 100", "=ds="..AL["Trainer"] };
				{ 26, "s2396", "2579", "=q1=Green Linen Shirt", "=ds=#sr# 70", "=ds="..AL["Trainer"] };
				{ 27, "s2394", "2577", "=q1=Blue Linen Shirt", "=ds=#sr# 40", "=ds="..AL["Trainer"] };
				{ 28, "s2392", "2575", "=q1=Red Linen Shirt", "=ds=#sr# 40", "=ds="..AL["Trainer"] };
				{ 29, "s2393", "2576", "=q1=White Linen Shirt", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
				{ 30, "s3915", "4344", "=q1=Brown Linen Shirt", "=ds=#sr# 1", "=ds="..AL["Trainer"] };
			};
		};
		info = {
			name = TAILORING..": "..AL["Shirts"],
			module = moduleName, menu = "TAILORINGMENU",
		};
	};

	AtlasLoot_Data["Mooncloth"] = {
		["Normal"] = {
			{
				{ 1, "s26760", "21873", "=q4=Primal Mooncloth Belt", "=ds=#sr# 355", "=ds="..AL["Vendor"] };
				{ 2, "s26761", "21874", "=q4=Primal Mooncloth Shoulders", "=ds=#sr# 365", "=ds="..AL["Vendor"] };
				{ 3, "s26762", "21875", "=q4=Primal Mooncloth Robe", "=ds=#sr# 375", "=ds="..AL["Vendor"] };
			};
		};
		info = {
			name = MOONCLOTH,
			module = moduleName, menu = "TAILORINGMENU", instance = "Tailoring",
		};
	};

	AtlasLoot_Data["Shadoweave"] = {
		["Normal"] = {
			{
				{ 1, "s26756", "21869", "=q4=Frozen Shadoweave Shoulders", "=ds=#sr# 355", "=ds="..AL["Vendor"] };
				{ 2, "s26757", "21870", "=q4=Frozen Shadoweave Boots", "=ds=#sr# 365", "=ds="..AL["Vendor"] };
				{ 3, "s26758", "21871", "=q4=Frozen Shadoweave Robe", "=ds=#sr# 375", "=ds="..AL["Vendor"] };
			};
		};
		info = {
			name = SHADOWEAVE,
			module = moduleName, menu = "TAILORINGMENU", instance = "Tailoring",
		};
	};

	AtlasLoot_Data["Spellfire"] = {
		["Normal"] = {
			{
				{ 1, "s26752", "21846", "=q4=Spellfire Belt", "=ds=#sr# 355", "=ds="..AL["Vendor"] };
				{ 2, "s26753", "21847", "=q4=Spellfire Gloves", "=ds=#sr# 365", "=ds="..AL["Vendor"] };
				{ 3, "s26754", "21848", "=q4=Spellfire Robe", "=ds=#sr# 375", "=ds="..AL["Vendor"] };
			};
		};
		info = {
			name = SPELLFIRE,
			module = moduleName, menu = "TAILORINGMENU", instance = "Tailoring",
		};
	};

	AtlasLoot_Data["TailoringCataVendor"] = {
		["Normal"] = {
			{
				{ 1, 68199, "", "=q3=Pattern: Black Embersilk Gown", "=ds=#p8# (500)", "8 #embersilkboltl#" },
				{ 2, 54593, "", "=q3=Pattern: Vicious Embersilk Cowl", "=ds=#p8# (525)", "8 #embersilkboltl#" },
				{ 3, 54594, "", "=q3=Pattern: Vicious Embersilk Pants", "=ds=#p8# (525)", "8 #embersilkboltl#" },
				{ 4, 54595, "", "=q3=Pattern: Vicious Embersilk Robe", "=ds=#p8# (525)", "8 #embersilkboltl#" },
				{ 5, 54596, "", "=q3=Pattern: Vicious Fireweave Cowl", "=ds=#p8# (525)", "8 #embersilkboltl#" },
				{ 6, 54597, "", "=q3=Pattern: Vicious Fireweave Pants", "=ds=#p8# (525)", "8 #embersilkboltl#" },
				{ 7, 54598, "", "=q3=Pattern: Vicious Fireweave Robe", "=ds=#p8# (525)", "8 #embersilkboltl#" },
				{ 8, 54600, "", "=q3=Pattern: Powerful Ghostly Spellthread", "=ds=#p8# (525)", "8 #embersilkboltl#" },
				{ 9, 54599, "", "=q3=Pattern: Powerful Enchanted Spellthread", "=ds=#p8# (525)", "8 #embersilkboltl#" },
				{ 10, 54601, "", "=q3=Pattern: Belt of the Depths", "=ds=#p8# (525)", "1 #dreamcloth#" },
				{ 11, 54603, "", "=q3=Pattern: Breeches of Mended Nightmares", "=ds=#p8# (525)", "1 #dreamcloth#" },
				{ 12, 54602, "", "=q3=Pattern: Dreamless Belt", "=ds=#p8# (525)", "1 #dreamcloth#" },
				{ 13, 54604, "", "=q3=Pattern: Flame-Ascended Pantaloons", "=ds=#p8# (525)", "1 #dreamcloth#" },
				{ 14, 54605, "", "=q3=Pattern: Illusionary Bag", "=ds=#p8# (525)", "1 #dreamcloth#" },
			};
		};
		info = {
			name = TAILORING..": "..AL["Cataclysm Vendor Sold Patterns"],
			module = moduleName, menu = "TAILORINGMENU",
		};
	};

	-----------------------
	--- Profession Sets ---
	-----------------------

		-------------------------------
		--- Blacksmithing Mail Sets ---
		-------------------------------

	AtlasLoot_Data["BlacksmithingMailBloodsoulEmbrace"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Hammer_20", "=q6="..BabbleItemSet["Bloodsoul Embrace"], ""};
				{ 2, 19691, "", "=q3=Bloodsoul Shoulders", "=ds=#s3#, #a3#"};
				{ 3, 19690, "", "=q3=Bloodsoul Breastplate", "=ds=#s5#, #a3#"};
				{ 4, 19692, "", "=q3=Bloodsoul Gauntlets", "=ds=#s9#, #a3#"};
			};
		};
		info = {
			name = BabbleItemSet["Bloodsoul Embrace"],
			module = moduleName, menu = "CRAFTSET", instance = "BlacksmithingMail",
		};
	};

	AtlasLoot_Data["BlacksmithingMailFelIronChain"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Hammer_20", "=q6="..BabbleItemSet["Fel Iron Chain"], ""};
				{ 2, 23493, "", "=q2=Fel Iron Chain Coif", "=ds=#s1#, #a3#"};
				{ 3, 23490, "", "=q2=Fel Iron Chain Tunic", "=ds=#s5#, #a3#"};
				{ 4, 23494, "", "=q2=Fel Iron Chain Bracers", "=ds=#s8#, #a3#"};
				{ 5, 23491, "", "=q2=Fel Iron Chain Gloves", "=ds=#s9#, #a3#"};
			};
		};
		info = {
			name = BabbleItemSet["Fel Iron Chain"],
			module = moduleName, menu = "CRAFTSET", instance = "BlacksmithingMail",
		};
	};

		--------------------------------
		--- Blacksmithing Plate Sets ---
		--------------------------------

	AtlasLoot_Data["BlacksmithingPlateImperialPlate"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Hammer_20", "=q6=#craftbp1#", ""};
				{ 2, 12427, "", "=q2=Imperial Plate Helm", "=ds=#s1#, #a4#"};
				{ 3, 12428, "", "=q2=Imperial Plate Shoulders", "=ds=#s3#, #a4#"};
				{ 4, 12422, "", "=q2=Imperial Plate Chest", "=ds=#s5#, #a4#"};
				{ 5, 12425, "", "=q2=Imperial Plate Bracers", "=ds=#s8#, #a4#"};
				{ 6, 12424, "", "=q2=Imperial Plate Belt", "=ds=#s10#, #a4#"};
				{ 7, 12429, "", "=q2=Imperial Plate Leggings", "=ds=#s11#, #a4#"};
				{ 8, 12426, "", "=q2=Imperial Plate Boots", "=ds=#s12#, #a4#"};
			};
		};
		info = {
			name = BabbleItemSet["Imperial Plate"],
			module = moduleName, menu = "CRAFTSET", instance = "BlacksmithingPlate",
		};
	};

	AtlasLoot_Data["BlacksmithingPlateTheDarksoul"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Hammer_20", "=q6=#craftbp2#", ""};
				{ 2, 19695, "", "=q3=Darksoul Shoulders", "=ds=#s3#, #a4#"};
				{ 3, 19693, "", "=q3=Darksoul Breastplate", "=ds=#s5#, #a4#"};
				{ 4, 19694, "", "=q3=Darksoul Leggings", "=ds=#s11#, #a4#"};
			};
		};
		info = {
			name = BabbleItemSet["The Darksoul"],
			module = moduleName, menu = "CRAFTSET", instance = "BlacksmithingPlate",
		};
	};

	AtlasLoot_Data["BlacksmithingPlateFelIronPlate"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Hammer_20", "=q6=#craftbp3#", ""};
				{ 2, 23489, "", "=q2=Fel Iron Breastplate", "=ds=#s5#, #a4#"};
				{ 3, 23482, "", "=q2=Fel Iron Plate Gloves", "=ds=#s9#, #a4#"};
				{ 4, 23484, "", "=q2=Fel Iron Plate Belt", "=ds=#s10#, #a4#"};
				{ 5, 23488, "", "=q2=Fel Iron Plate Pants", "=ds=#s11#, #a4#"};
				{ 6, 23487, "", "=q2=Fel Iron Plate Boots", "=ds=#s12#, #a4#"};
			};
		};
		info = {
			name = BabbleItemSet["Fel Iron Plate"],
			module = moduleName, menu = "CRAFTSET", instance = "BlacksmithingPlate",
		};
	};

	AtlasLoot_Data["BlacksmithingPlateAdamantiteB"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Hammer_20", "=q6=#craftbp4#", ""};
				{ 2, 23507, "", "=q3=Adamantite Breastplate", "=ds=#s5#, #a4#"};
				{ 3, 23506, "", "=q3=Adamantite Plate Bracers", "=ds=#s8#, #a4#"};
				{ 4, 23508, "", "=q3=Adamantite Plate Gloves", "=ds=#s9#, #a4#"};
			};
		};
		info = {
			name = BabbleItemSet["Adamantite Battlegear"],
			module = moduleName, menu = "CRAFTSET", instance = "BlacksmithingPlate",
		};
	};

	AtlasLoot_Data["BlacksmithingPlateFlameG"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Hammer_20", "=q6=#craftbp5#", "=q1=#j11#"};
				{ 2, 23516, "", "=q3=Flamebane Helm", "=ds=#s1#, #a4#"};
				{ 3, 23513, "", "=q3=Flamebane Breastplate", "=ds=#s5#, #a4#"};
				{ 4, 23515, "", "=q3=Flamebane Bracers", "=ds=#s8#, #a4#"};
				{ 5, 23514, "", "=q3=Flamebane Gloves", "=ds=#s9#, #a4#"};
			};
		};
		info = {
			name = BabbleItemSet["Flame Guard"],
			module = moduleName, menu = "CRAFTSET", instance = "BlacksmithingPlate",
		};
	};

	AtlasLoot_Data["BlacksmithingPlateEnchantedAdaman"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Hammer_20", "=q6=#craftbp6#", "=q1=#j12#"};
				{ 2, 23509, "", "=q3=Enchanted Adamantite Breastplate", "=ds=#s5#, #a4#"};
				{ 3, 23510, "", "=q3=Enchanted Adamantite Belt", "=ds=#s10#, #a4#"};
				{ 4, 23512, "", "=q3=Enchanted Adamantite Leggings", "=ds=#s11#, #a4#"};
				{ 5, 23511, "", "=q3=Enchanted Adamantite Boots", "=ds=#s12#, #a4#"};
			};
		};
		info = {
			name = BabbleItemSet["Enchanted Adamantite Armor"],
			module = moduleName, menu = "CRAFTSET", instance = "BlacksmithingPlate",
		};
	};

	AtlasLoot_Data["BlacksmithingPlateKhoriumWard"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Hammer_20", "=q6=#craftbp7#", ""};
				{ 2, 23524, "", "=q3=Khorium Belt", "=ds=#s10#, #a4#"};
				{ 3, 23523, "", "=q3=Khorium Pants", "=ds=#s11#, #a4#"};
				{ 4, 23525, "", "=q3=Khorium Boots", "=ds=#s12#, #a4#"};
			};
		};
		info = {
			name = BabbleItemSet["Khorium Ward"],
			module = moduleName, menu = "CRAFTSET", instance = "BlacksmithingPlate",
		};
	};

	AtlasLoot_Data["BlacksmithingPlateFaithFelsteel"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Hammer_20", "=q6=#craftbp8#", ""};
				{ 2, 23519, "", "=q3=Felsteel Helm", "=ds=#s1#, #a4#"};
				{ 3, 23517, "", "=q3=Felsteel Gloves", "=ds=#s9#, #a4#"};
				{ 4, 23518, "", "=q3=Felsteel Leggings", "=ds=#s11#, #a4#"};
			};
		};
		info = {
			name = BabbleItemSet["Faith in Felsteel"],
			module = moduleName, menu = "CRAFTSET", instance = "BlacksmithingPlate",
		};
	};

	AtlasLoot_Data["BlacksmithingPlateBurningRage"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Hammer_20", "=q6=#craftbp9#", ""};
				{ 2, 23521, "", "=q3=Ragesteel Helm", "=ds=#s1#, #a4#"};
				{ 3, 33173, "", "=q3=Ragesteel Shoulders", "=ds=#s3#, #a4#"};
				{ 4, 23522, "", "=q3=Ragesteel Breastplate", "=ds=#s5#, #a4#"};
				{ 5, 23520, "", "=q3=Ragesteel Gloves", "=ds=#s9#, #a4#"};
			};
		};
		info = {
			name = BabbleItemSet["Burning Rage"],
			module = moduleName, menu = "CRAFTSET", instance = "BlacksmithingPlate",
		};
	};
	
	AtlasLoot_Data["BlacksmithingPlateOrnateSaroniteBattlegear"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Hammer_20", "=q6=#craftbp10#", ""};
				{ 2, 42728, "", "=q3=Ornate Saronite Skullshield", "=ds=#s1#, #a4#"};
				{ 3, 42727, "", "=q3=Ornate Saronite Pauldrons", "=ds=#s3#, #a4#"};
				{ 4, 42725, "", "=q3=Ornate Saronite Hauberk", "=ds=#s5#, #a4#"};
				{ 5, 42723, "", "=q3=Ornate Saronite Bracers", "=ds=#s8#, #a4#"};
				{ 6, 42724, "", "=q3=Ornate Saronite Gauntlets", "=ds=#s9#, #a4#"};
				{ 7, 42729, "", "=q3=Ornate Saronite Waistguard", "=ds=#s10#, #a4#"};
				{ 8, 42726, "", "=q3=Ornate Saronite Legplates", "=ds=#s11#, #a4#"};
				{ 9, 42730, "", "=q3=Ornate Saronite Walkers", "=ds=#s12#, #a4#"};
			};
		};
		info = {
			name = BabbleItemSet["Ornate Saronite Battlegear"],
			module = moduleName, menu = "CRAFTSET", instance = "BlacksmithingPlate",
		};
	};

	AtlasLoot_Data["BlacksmithingPlateSavageSaroniteBattlegear"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Hammer_20", "=q6=#craftbp11#", ""};
				{ 2, 41350, "", "=q3=Savage Saronite Skullshield", "=ds=#s1#, #a4#"};
				{ 3, 41351, "", "=q3=Savage Saronite Pauldrons", "=ds=#s3#, #a4#"};
				{ 4, 41353, "", "=q3=Savage Saronite Hauberk", "=ds=#s5#, #a4#"};
				{ 5, 41354, "", "=q3=Savage Saronite Bracers", "=ds=#s8#, #a4#"};
				{ 6, 41349, "", "=q3=Savage Saronite Gauntlets", "=ds=#s9#, #a4#"};
				{ 7, 41352, "", "=q3=Savage Saronite Waistguard", "=ds=#s10#, #a4#"};
				{ 8, 41347, "", "=q3=Savage Saronite Legplates", "=ds=#s11#, #a4#"};
				{ 9, 41348, "", "=q3=Savage Saronite Walkers", "=ds=#s12#, #a4#"};
			};
		};
		info = {
			name = BabbleItemSet["Savage Saronite Battlegear"],
			module = moduleName, menu = "CRAFTSET", instance = "BlacksmithingPlate",
		};
	};

		-----------------------------------
		--- Leatherworking Leather Sets ---
		-----------------------------------

	AtlasLoot_Data["LeatherworkingLeatherVolcanicArmor"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwl1#", "=q1=#j11#"};
				{ 2, 15055, "", "=q2=Volcanic Shoulders", "=ds=#s3#, #a2#"};
				{ 3, 15053, "", "=q2=Volcanic Breastplate", "=ds=#s5#, #a2#"};
				{ 4, 15054, "", "=q2=Volcanic Leggings", "=ds=#s11#, #a2#"};
			};
		};
		info = {
			name = BabbleItemSet["Volcanic Armor"],
			module = moduleName, menu = "CRAFTSET#2", instance = "LeatherworkingLeather",
		};
	};

	AtlasLoot_Data["LeatherworkingLeatherIronfeatherArmor"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwl2#", ""};
				{ 2, 15067, "", "=q3=Ironfeather Shoulders", "=ds=#s3#, #a2#"};
				{ 3, 15066, "", "=q3=Ironfeather Breastplate", "=ds=#s5#, #a2#"};
			};
		};
		info = {
			name = BabbleItemSet["Ironfeather Armor"],
			module = moduleName, menu = "CRAFTSET#2", instance = "LeatherworkingLeather",
		};
	};

	AtlasLoot_Data["LeatherworkingLeatherStormshroudArmor"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwl3#", ""};
				{ 2, 15058, "", "=q3=Stormshroud Shoulders", "=ds=#s3#, #a2#"};
				{ 3, 15056, "", "=q3=Stormshroud Armor", "=ds=#s5#, #a2#"};
				{ 4, 21278, "", "=q3=Stormshroud Gloves", "=ds=#s9#, #a2#"};
				{ 5, 15057, "", "=q3=Stormshroud Pants", "=ds=#s11#, #a2#"};
			};
		};
		info = {
			name = BabbleItemSet["Stormshroud Armor"],
			module = moduleName, menu = "CRAFTSET#2", instance = "LeatherworkingLeather",
		};
	};

	AtlasLoot_Data["LeatherworkingLeatherDevilsaurArmor"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwl4#", ""};
				{ 2, 15063, "", "=q3=Devilsaur Gauntlets", "=ds=#s9#, #a2#"};
				{ 3, 15062, "", "=q3=Devilsaur Leggings", "=ds=#s11#, #a2#"};
			};
		};
		info = {
			name = BabbleItemSet["Devilsaur Armor"],
			module = moduleName, menu = "CRAFTSET#2", instance = "LeatherworkingLeather",
		};
	};

	AtlasLoot_Data["LeatherworkingLeatherBloodTigerH"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwl5#", ""};
				{ 2, 19689, "", "=q3=Blood Tiger Shoulders", "=ds=#s3#, #a2#"};
				{ 3, 19688, "", "=q3=Blood Tiger Breastplate", "=ds=#s5#, #a2#"};
			};
		};
		info = {
			name = BabbleItemSet["Blood Tiger Harness"],
			module = moduleName, menu = "CRAFTSET#2", instance = "LeatherworkingLeather",
		};
	};

	AtlasLoot_Data["LeatherworkingLeatherPrimalBatskin"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwl6#", ""};
				{ 2, 19685, "", "=q3=Primal Batskin Jerkin", "=ds=#s5#, #a2#"};
				{ 3, 19687, "", "=q3=Primal Batskin Bracers", "=ds=#s8#, #a2#"};
				{ 4, 19686, "", "=q3=Primal Batskin Gloves", "=ds=#s9#, #a2#"};
			};
		};
		info = {
			name = BabbleItemSet["Primal Batskin"],
			module = moduleName, menu = "CRAFTSET#2", instance = "LeatherworkingLeather",
		};
	};

	AtlasLoot_Data["LeatherworkingLeatherWildDraenishA"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwl7#", ""};
				{ 2, 25676, "", "=q2=Wild Draenish Vest", "=ds=#s5#, #a2#"};
				{ 3, 25674, "", "=q2=Wild Draenish Gloves", "=ds=#s9#, #a2#"};
				{ 4, 25675, "", "=q2=Wild Draenish Leggings", "=ds=#s11#, #a2#"};
				{ 5, 25673, "", "=q2=Wild Draenish Boots", "=ds=#s12#, #a2#"};
			};
		};
		info = {
			name = BabbleItemSet["Wild Draenish Armor"],
			module = moduleName, menu = "CRAFTSET#2", instance = "LeatherworkingLeather",
		};
	};

	AtlasLoot_Data["LeatherworkingLeatherThickDraenicA"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwl8#", ""};
				{ 2, 25671, "", "=q2=Thick Draenic Vest", "=ds=#s5#, #a2#"};
				{ 3, 25669, "", "=q2=Thick Draenic Gloves", "=ds=#s9#, #a2#"};
				{ 4, 25670, "", "=q2=Thick Draenic Pants", "=ds=#s11#, #a2#"};
				{ 5, 25668, "", "=q2=Thick Draenic Boots", "=ds=#s12#, #a2#"};
			};
		};
		info = {
			name = BabbleItemSet["Thick Draenic Armor"],
			module = moduleName, menu = "CRAFTSET#2", instance = "LeatherworkingLeather",
		};
	};

	AtlasLoot_Data["LeatherworkingLeatherFelSkin"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwl9#", ""};
				{ 2, 25685, "", "=q3=Fel Leather Gloves", "=ds=#s9#, #a2#"};
				{ 3, 25687, "", "=q3=Fel Leather Leggings", "=ds=#s11#, #a2#"};
				{ 4, 25686, "", "=q3=Fel Leather Boots", "=ds=#s12#, #a2#"};
			};
		};
		info = {
			name = BabbleItemSet["Fel Skin"],
			module = moduleName, menu = "CRAFTSET#2", instance = "LeatherworkingLeather",
		};
	};

	AtlasLoot_Data["LeatherworkingLeatherSClefthoof"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwl10#", ""};
				{ 2, 25689, "", "=q3=Heavy Clefthoof Vest", "=ds=#s5#, #a2#"};
				{ 3, 25690, "", "=q3=Heavy Clefthoof Leggings", "=ds=#s11#, #a2#"};
				{ 4, 25691, "", "=q3=Heavy Clefthoof Boots", "=ds=#s12#, #a2#"};
			};
		};
		info = {
			name = BabbleItemSet["Strength of the Clefthoof"],
			module = moduleName, menu = "CRAFTSET2", instance = "LeatherworkingLeather",
		};
	};

	AtlasLoot_Data["LeatherworkingLeatherPrimalIntent"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwe1#", "=q1=#p11#"};
				{ 2, 29525, "", "=q4=Primalstrike Vest", "=ds=#s5#, #a2#"};
				{ 3, 29527, "", "=q4=Primalstrike Bracers", "=ds=#s8#, #a2#"};
				{ 4, 29526, "", "=q4=Primalstrike Belt", "=ds=#s10#, #a2#"};
			};
		};
		info = {
			name = BabbleItemSet["Primal Intent"],
			module = moduleName, menu = "CRAFTSET#2", instance = "LeatherworkingLeather",
		};
	};

	AtlasLoot_Data["LeatherworkingLeatherWindhawkArmor"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwt1#", "=q1=#p10#"};
				{ 2, 29522, "", "=q4=Windhawk Hauberk", "=ds=#s5#, #a2#"};
				{ 3, 29523, "", "=q4=Windhawk Bracers", "=ds=#s8#, #a2#"};
				{ 4, 29524, "", "=q4=Windhawk Belt", "=ds=#s10#, #a2#"};
			};
		};
		info = {
			name = BabbleItemSet["Windhawk Armor"],
			module = moduleName, menu = "CRAFTSET#2", instance = "LeatherworkingLeather",
		};
	};

	AtlasLoot_Data["LeatherworkingLeatherBoreanEmbrace"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwl11#", ""};
				{ 2, 38437, "", "=q2=Arctic Helm", "=ds=#s1#, #a2#"};
				{ 3, 38402, "", "=q2=Arctic Shoulderpads", "=ds=#s3#, #a2#"};
				{ 4, 38400, "", "=q2=Arctic Chestpiece", "=ds=#s5#, #a2#"};
				{ 5, 38433, "", "=q2=Arctic Wristguards", "=ds=#s8#, #a2#"};
				{ 6, 38403, "", "=q2=Arctic Gloves", "=ds=#s9#, #a2#"};
				{ 7, 38405, "", "=q2=Arctic Belt", "=ds=#s10#, #a2#"};
				{ 8, 38401, "", "=q2=Arctic Leggings", "=ds=#s11#, #a2#"};
				{ 9, 38404, "", "=q2=Arctic Boots", "=ds=#s12#, #a2#"};
			};
		};
		info = {
			name = BabbleItemSet["Borean Embrace"],
			module = moduleName, menu = "CRAFTSET#2", instance = "LeatherworkingLeather",
		};
	};

	AtlasLoot_Data["LeatherworkingLeatherIceborneEmbrace"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwl12#", ""};
				{ 2, 38438, "", "=q2=Iceborne Helm", "=ds=#s1#, #a2#"};
				{ 3, 38411, "", "=q2=Iceborne Shoulderpads", "=ds=#s3#, #a2#"};
				{ 4, 38408, "", "=q2=Iceborne Chestguard", "=ds=#s5#, #a2#"};
				{ 5, 38434, "", "=q2=Iceborne Wristguards", "=ds=#s8#, #a2#"};
				{ 6, 38409, "", "=q2=Iceborne Gloves", "=ds=#s9#, #a2#"};
				{ 7, 38406, "", "=q2=Iceborne Belt", "=ds=#s10#, #a2#"};
				{ 8, 38410, "", "=q2=Iceborne Leggings", "=ds=#s11#, #a2#"};
				{ 9, 38407, "", "=q2=Iceborne Boots", "=ds=#s12#, #a2#"};
			};
		};
		info = {
			name = BabbleItemSet["Iceborne Embrace"],
			module = moduleName, menu = "CRAFTSET#2", instance = "LeatherworkingLeather",
		};
	};

	AtlasLoot_Data["LeatherworkingLeatherEvisceratorBattlegear"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwl13#", ""};
				{ 2, 43260, "", "=q3=Eviscerator's Facemask", "=ds=#s1#, #a2#"};
				{ 3, 43433, "", "=q3=Eviscerator's Shoulderpads", "=ds=#s3#, #a2#"};
				{ 4, 43434, "", "=q3=Eviscerator's Chestguard", "=ds=#s5#, #a2#"};
				{ 5, 43435, "", "=q3=Eviscerator's Bindings", "=ds=#s8#, #a2#"};
				{ 6, 43436, "", "=q3=Eviscerator's Gauntlets", "=ds=#s9#, #a2#"};
				{ 7, 43437, "", "=q3=Eviscerator's Waistguard", "=ds=#s10#, #a2#"};
				{ 8, 43438, "", "=q3=Eviscerator's Legguards", "=ds=#s11#, #a2#"};
				{ 9, 43439, "", "=q3=Eviscerator's Treads", "=ds=#s12#, #a2#"};
			};
		};
		info = {
			name = BabbleItemSet["Eviscerator's Battlegear"],
			module = moduleName, menu = "CRAFTSET#2", instance = "LeatherworkingLeather",
		};
	};

	AtlasLoot_Data["LeatherworkingLeatherOvercasterBattlegear"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwl14#", ""};
				{ 2, 43261, "", "=q3=Overcast Headguard", "=ds=#s1#, #a2#"};
				{ 3, 43262, "", "=q3=Overcast Spaulders", "=ds=#s3#, #a2#"};
				{ 4, 43263, "", "=q3=Overcast Chestguard", "=ds=#s5#, #a2#"};
				{ 5, 43264, "", "=q3=Overcast Bracers", "=ds=#s8#, #a2#"};
				{ 6, 43265, "", "=q3=Overcast Handwraps", "=ds=#s9#, #a2#"};
				{ 7, 43266, "", "=q3=Overcast Belt", "=ds=#s10#, #a2#"};
				{ 8, 43271, "", "=q3=Overcast Leggings", "=ds=#s11#, #a2#"};
				{ 9, 43273, "", "=q3=Overcast Boots", "=ds=#s12#, #a2#"};
			};
		};
		info = {
			name = BabbleItemSet["Overcaster Battlegear"],
			module = moduleName, menu = "CRAFTSET#2", instance = "LeatherworkingLeather",
		};
	};

		--------------------------------
		--- Leatherworking Mail Sets ---
		--------------------------------

	AtlasLoot_Data["LeatherworkingMailGreenDragonM"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwm1#", "=q1=#j13#"};
				{ 2, 15045, "", "=q3=Green Dragonscale Breastplate", "=ds=#s5#, #a3#"};
				{ 3, 20296, "", "=q3=Green Dragonscale Gauntlets", "=ds=#s9#, #a3#"};
				{ 4, 15046, "", "=q3=Green Dragonscale Leggings", "=ds=#s11#, #a3#"};
			};
		};
		info = {
			name = BabbleItemSet["Green Dragon Mail"],
			module = moduleName, menu = "CRAFTSET#3", instance = "LeatherworkingMail",
		};
	};

	AtlasLoot_Data["LeatherworkingMailBlueDragonM"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwm2#", "=q1=#j12#"};
				{ 2, 15049, "", "=q3=Blue Dragonscale Shoulders", "=ds=#s3#, #a3#"};
				{ 3, 15048, "", "=q3=Blue Dragonscale Breastplate", "=ds=#s5#, #a3#"};
				{ 4, 20295, "", "=q3=Blue Dragonscale Leggings", "=ds=#s11#, #a3#"};
			};
		};
		info = {
			name = BabbleItemSet["Blue Dragon Mail"],
			module = moduleName, menu = "CRAFTSET#3", instance = "LeatherworkingMail",
		};
	};

	AtlasLoot_Data["LeatherworkingMailBlackDragonM"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwm3#", "=q1=#j11#"};
				{ 2, 15051, "", "=q3=Black Dragonscale Shoulders", "=ds=#s3#, #a3#"};
				{ 3, 15050, "", "=q3=Black Dragonscale Breastplate", "=ds=#s5#, #a3#"};
				{ 4, 15052, "", "=q3=Black Dragonscale Leggings", "=ds=#s11#, #a3#"};
				{ 5, 16984, "", "=q4=Black Dragonscale Boots", "=ds=#s12#, #a3#"};
			};
		};
		info = {
			name = BabbleItemSet["Black Dragon Mail"],
			module = moduleName, menu = "CRAFTSET#3", instance = "LeatherworkingMail",
		};
	};

	AtlasLoot_Data["LeatherworkingMailScaledDraenicA"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwm4#", ""};
				{ 2, 25660, "", "=q2=Scaled Draenic Vest", "=ds=#s5#, #a3#"};
				{ 3, 25661, "", "=q2=Scaled Draenic Gloves", "=ds=#s9#, #a3#"};
				{ 4, 25662, "", "=q2=Scaled Draenic Pants", "=ds=#s11#, #a3#"};
				{ 5, 25659, "", "=q2=Scaled Draenic Boots", "=ds=#s12#, #a3#"};
			};
		};
		info = {
			name = BabbleItemSet["Scaled Draenic Armor"],
			module = moduleName, menu = "CRAFTSET#3", instance = "LeatherworkingMail",
		};
	};

	AtlasLoot_Data["LeatherworkingMailFelscaleArmor"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwm5#", ""};
				{ 2, 25657, "", "=q2=Felscale Breastplate", "=ds=#s5#, #a3#"};
				{ 3, 25654, "", "=q2=Felscale Gloves", "=ds=#s9#, #a3#"};
				{ 4, 25656, "", "=q2=Felscale Pants", "=ds=#s11#, #a3#"};
				{ 5, 25655, "", "=q2=Felscale Boots", "=ds=#s12#, #a3#"};
			};
		};
		info = {
			name = BabbleItemSet["Felscale Armor"],
			module = moduleName, menu = "CRAFTSET#3", instance = "LeatherworkingMail",
		};
	};

	AtlasLoot_Data["LeatherworkingMailFelstalkerArmor"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwm6#", ""};
				{ 2, 25696, "", "=q3=Felstalker Breastplate", "=ds=#s5#, #a3#"};
				{ 3, 25697, "", "=q3=Felstalker Bracers", "=ds=#s8#, #a3#"};
				{ 4, 25695, "", "=q3=Felstalker Belt", "=ds=#s10#, #a3#"};
			};
		};
		info = {
			name = BabbleItemSet["Felstalker Armor"],
			module = moduleName, menu = "CRAFTSET#3", instance = "LeatherworkingMail",
		};
	};

	AtlasLoot_Data["LeatherworkingMailNetherFury"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwm7#", ""};
				{ 2, 25694, "", "=q3=Netherfury Belt", "=ds=#s10#, #a3#"};
				{ 3, 25692, "", "=q3=Netherfury Leggings", "=ds=#s11#, #a3#"};
				{ 4, 25693, "", "=q3=Netherfury Boots", "=ds=#s12#, #a3#"};
			};
		};
		info = {
			name = BabbleItemSet["Fury of the Nether"],
			module = moduleName, menu = "CRAFTSET#3", instance = "LeatherworkingMail",
		};
	};

	AtlasLoot_Data["LeatherworkingMailNetherscaleArmor"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwd1#", "=q1=#p9#"};
				{ 2, 29515, "", "=q4=Ebon Netherscale Breastplate", "=ds=#s5#, #a3#"};
				{ 3, 29517, "", "=q4=Ebon Netherscale Bracers", "=ds=#s8#, #a3#"};
				{ 4, 29516, "", "=q4=Ebon Netherscale Belt", "=ds=#s10#, #a3#"};
			};
		};
		info = {
			name = BabbleItemSet["Netherscale Armor"],
			module = moduleName, menu = "CRAFTSET#3", instance = "LeatherworkingMail",
		};
	};

	AtlasLoot_Data["LeatherworkingMailNetherstrikeArmor"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwd2#", "=q1=#p9#"};
				{ 2, 29519, "", "=q4=Netherstrike Breastplate", "=ds=#s5#, #a3#"};
				{ 3, 29521, "", "=q4=Netherstrike Bracers", "=ds=#s8#, #a3#"};
				{ 4, 29520, "", "=q4=Netherstrike Belt", "=ds=#s10#, #a3#"};
			};
		};
		info = {
			name = BabbleItemSet["Netherstrike Armor"],
			module = moduleName, menu = "CRAFTSET#3", instance = "LeatherworkingMail",
		};
	};

	AtlasLoot_Data["LeatherworkingMailFrostscaleBinding"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwm8#", ""};
				{ 2, 38440, "", "=q2=Frostscale Helm", "=ds=#s1#, #a3#"};
				{ 3, 38424, "", "=q2=Frostscale Shoulders", "=ds=#s3#, #a3#"};
				{ 4, 38414, "", "=q2=Frostscale Chestguard", "=ds=#s5#, #a3#"};
				{ 5, 38436, "", "=q2=Frostscale Bracers", "=ds=#s8#, #a3#"};
				{ 6, 38415, "", "=q2=Frostscale Gloves", "=ds=#s9#, #a3#"};
				{ 7, 38412, "", "=q2=Frostscale Belt", "=ds=#s10#, #a3#"};
				{ 8, 38416, "", "=q2=Frostscale Leggings", "=ds=#s11#, #a3#"};
				{ 9, 38413, "", "=q2=Frostscale Boots", "=ds=#s12#, #a3#"};
			};
		};
		info = {
			name = BabbleItemSet["Frostscale Binding"],
			module = moduleName, menu = "CRAFTSET#3", instance = "LeatherworkingMail",
		};
	};

	AtlasLoot_Data["LeatherworkingMailNerubianHive"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwm9#", ""};
				{ 2, 38439, "", "=q2=Nerubian Helm", "=ds=#s1#, #a3#"};
				{ 3, 38417, "", "=q2=Nerubian Shoulders", "=ds=#s3#, #a3#"};
				{ 4, 38420, "", "=q2=Nerubian Chestguard", "=ds=#s5#, #a3#"};
				{ 5, 38435, "", "=q2=Nerubian Bracers", "=ds=#s8#, #a3#"};
				{ 6, 38421, "", "=q2=Nerubian Gloves", "=ds=#s9#, #a3#"};
				{ 7, 38418, "", "=q2=Nerubian Belt", "=ds=#s10#, #a3#"};
				{ 8, 38422, "", "=q2=Nerubian Legguards", "=ds=#s11#, #a3#"};
				{ 9, 38419, "", "=q2=Nerubian Boots", "=ds=#s12#, #a3#"};
			};
		};
		info = {
			name = BabbleItemSet["Nerubian Hive"],
			module = moduleName, menu = "CRAFTSET#3", instance = "LeatherworkingMail",
		};
	};

	AtlasLoot_Data["LeatherworkingMailStormhideBattlegear"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwm10#", ""};
				{ 2, 43455, "", "=q3=Stormhide Crown", "=ds=#s1#, #a3#"};
				{ 3, 43457, "", "=q3=Stormhide Shoulders", "=ds=#s3#, #a3#"};
				{ 4, 43453, "", "=q3=Stormhide Hauberk", "=ds=#s5#, #a3#"};
				{ 5, 43452, "", "=q3=Stormhide Wristguards", "=ds=#s8#, #a3#"};
				{ 6, 43454, "", "=q3=Stormhide Grips", "=ds=#s9#, #a3#"};
				{ 7, 43450, "", "=q3=Stormhide Belt", "=ds=#s10#, #a3#"};
				{ 8, 43456, "", "=q3=Stormhide Legguards", "=ds=#s11#, #a3#"};
				{ 9, 43451, "", "=q3=Stormhide Stompers", "=ds=#s12#, #a3#"};
			};
		};
		info = {
			name = BabbleItemSet["Stormhide Battlegear"],
			module = moduleName, menu = "CRAFTSET#3", instance = "LeatherworkingMail",
		};
	};

	AtlasLoot_Data["LeatherworkingMailSwiftarrowBattlefear"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#craftlwm11#", ""};
				{ 2, 43447, "", "=q3=Swiftarrow Helm", "=ds=#s1#, #a3#"};
				{ 3, 43449, "", "=q3=Swiftarrow Shoulderguards", "=ds=#s3#, #a3#"};
				{ 4, 43445, "", "=q3=Swiftarrow Hauberk", "=ds=#s5#, #a3#"};
				{ 5, 43444, "", "=q3=Swiftarrow Bracers", "=ds=#s8#, #a3#"};
				{ 6, 43446, "", "=q3=Swiftarrow Gauntlets", "=ds=#s9#, #a3#"};
				{ 7, 43442, "", "=q3=Swiftarrow Belt", "=ds=#s10#, #a3#"};
				{ 8, 43448, "", "=q3=Swiftarrow Leggings", "=ds=#s11#, #a3#"};
				{ 9, 43443, "", "=q3=Swiftarrow Boots", "=ds=#s12#, #a3#"};
			};
		};
		info = {
			name = BabbleItemSet["Swiftarrow Battlegear"],
			module = moduleName, menu = "CRAFTSET#3", instance = "LeatherworkingMail",
		};
	};

		----------------------
		--- Tailoring Sets ---
		----------------------

	AtlasLoot_Data["TailoringBloodvineG"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Fabric_Linen_02", "=q6=#craftt1#", ""};
				{ 2, 19682, "", "=q3=Bloodvine Vest", "=ds=#s5#, #a1#"};
				{ 3, 19683, "", "=q3=Bloodvine Leggings", "=ds=#s11#, #a1#"};
				{ 4, 19684, "", "=q3=Bloodvine Boots", "=ds=#s12#, #a1#"};
			};
		};
		info = {
			name = BabbleItemSet["Bloodvine Garb"],
			module = moduleName, menu = "CRAFTSET#4", instance = "TailoringSets",
		};
	};

	AtlasLoot_Data["TailoringNeatherVest"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Fabric_Linen_02", "=q6=#craftt2#", ""};
				{ 2, 21855, "", "=q2=Netherweave Tunic", "=ds=#s5#, #a1#"};
				{ 3, 21854, "", "=q2=Netherweave Robe", "=ds=#s5#, #a1#"};
				{ 4, 21849, "", "=q2=Netherweave Bracers", "=ds=#s8#, #a1#"};
				{ 5, 21851, "", "=q2=Netherweave Gloves", "=ds=#s9#, #a1##"};
				{ 6, 21850, "", "=q2=Netherweave Belt", "=ds=#s10#, #a1#"};
				{ 7, 21852, "", "=q2=Netherweave Pants", "=ds=#s11#, #a1#"};
				{ 8, 21853, "", "=q2=Netherweave Boots", "=ds=#s12#, #a1#"};
			};
		};
		info = {
			name = BabbleItemSet["Netherweave Vestments"],
			module = moduleName, menu = "CRAFTSET#4", instance = "TailoringSets",
		};
	};

	AtlasLoot_Data["TailoringImbuedNeather"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Fabric_Linen_02", "=q6=#craftt3#", ""};
				{ 2, 21862, "", "=q3=Imbued Netherweave Tunic", "=ds=#s5#, #a1#"};
				{ 3, 21861, "", "=q3=Imbued Netherweave Robe", "=ds=#s5#, #a1#"};
				{ 4, 21859, "", "=q3=Imbued Netherweave Pants", "=ds=#s11#, #a1#"};
				{ 5, 21860, "", "=q3=Imbued Netherweave Boots", "=ds=#s12#, #a1#"};
			};
		};
		info = {
			name = BabbleItemSet["Imbued Netherweave"],
			module = moduleName, menu = "CRAFTSET#4", instance = "TailoringSets",
		};
	};

	AtlasLoot_Data["TailoringArcanoVest"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Fabric_Linen_02", "=q6=#craftt4#", "=q1=#j12#"};
				{ 2, 21868, "", "=q3=Arcanoweave Robe", "=ds=#s5#, #a1#"};
				{ 3, 21866, "", "=q3=Arcanoweave Bracers", "=ds=#s8#, #a1#"};
				{ 4, 21867, "", "=q3=Arcanoweave Boots", "=ds=#s12#, #a1#"};
			};
		};
		info = {
			name = BabbleItemSet["Arcanoweave Vestments"],
			module = moduleName, menu = "CRAFTSET#4", instance = "TailoringSets",
		};
	};

	AtlasLoot_Data["TailoringTheUnyielding"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Fabric_Linen_02", "=q6=#craftt5#", ""};
				{ 2, 24249, "", "=q3=Unyielding Bracers", "=ds=#s8#, #a1#"};
				{ 3, 24255, "", "=q4=Unyielding Girdle", "=ds=#s10#, #a1#"};
			};
		};
		info = {
			name = BabbleItemSet["The Unyielding"],
			module = moduleName, menu = "CRAFTSET#4", instance = "TailoringSets",
		};
	};

	AtlasLoot_Data["TailoringWhitemendWis"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Fabric_Linen_02", "=q6=#craftt6#", ""};
				{ 2, 24264, "", "=q4=Whitemend Hood", "=ds=#s1#, #a1#"};
				{ 3, 24261, "", "=q4=Whitemend Pants", "=ds=#s11#, #a1#"};
			};
		};
		info = {
			name = BabbleItemSet["Whitemend Wisdom"],
			module = moduleName, menu = "CRAFTSET#4", instance = "TailoringSets",
		};
	};

	AtlasLoot_Data["TailoringSpellstrikeInfu"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Fabric_Linen_02", "=q6=#craftt7#", ""};
				{ 2, 24266, "", "=q4=Spellstrike Hood", "=ds=#s1#, #a1#"};
				{ 3, 24262, "", "=q4=Spellstrike Pants", "=ds=#s11#, #a1#"};
			};
		};
		info = {
			name = BabbleItemSet["Spellstrike Infusion"],
			module = moduleName, menu = "CRAFTSET#4", instance = "TailoringSets",
		};
	};

	AtlasLoot_Data["TailoringBattlecastG"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Fabric_Linen_02", "=q6=#craftt8#", ""};
				{ 2, 24267, "", "=q4=Battlecast Hood", "=ds=#s1#, #a1#"};
				{ 3, 24263, "", "=q4=Battlecast Pants", "=ds=#s11#, #a1#"};
			};
		};
		info = {
			name = BabbleItemSet["Battlecast Garb"],
			module = moduleName, menu = "CRAFTSET#4", instance = "TailoringSets",
		};
	};

	AtlasLoot_Data["TailoringSoulclothEm"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Fabric_Linen_02", "=q6=#craftt9#", "=q1=#j12#"};
				{ 2, 21864, "", "=q4=Soulcloth Shoulders", "=ds=#s3#, #a1#"};
				{ 3, 21865, "", "=q4=Soulcloth Vest", "=ds=#s5#, #a1#"};
				{ 4, 21863, "", "=q4=Soulcloth Gloves", "=ds=#s9#, #a1#"};
			};
		};
		info = {
			name = BabbleItemSet["Soulcloth Embrace"],
			module = moduleName, menu = "CRAFTSET#4", instance = "TailoringSets",
		};
	};

	AtlasLoot_Data["TailoringPrimalMoon"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Fabric_Linen_02", "=q6=#crafttm1#", "=q1=#p19#"};
				{ 2, 21874, "", "=q4=Primal Mooncloth Shoulders", "=ds=#s3#, #a1#"};
				{ 3, 21875, "", "=q4=Primal Mooncloth Robe", "=ds=#s5#, #a1#"};
				{ 4, 21873, "", "=q4=Primal Mooncloth Belt", "=ds=#s10#, #a1#"};
			};
		};
		info = {
			name = BabbleItemSet["Primal Mooncloth"],
			module = moduleName, menu = "CRAFTSET#4", instance = "TailoringSets",
		};
	};

	AtlasLoot_Data["TailoringShadowEmbrace"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Fabric_Linen_02", "=q6=#crafttsh1#", "=q1=#p20#"};
				{ 2, 21869, "", "=q4=Frozen Shadoweave Shoulders", "=ds=#s3#, #a1#"};
				{ 3, 21871, "", "=q4=Frozen Shadoweave Vest", "=ds=#s5#, #a1#"};
				{ 4, 21870, "", "=q4=Frozen Shadoweave Boots", "=ds=#s12#, #a1#"};
			};
		};
		info = {
			name = BabbleItemSet["Shadow's Embrace"],
			module = moduleName, menu = "CRAFTSET#4", instance = "TailoringSets",
		};
	};

	AtlasLoot_Data["TailoringSpellfireWrath"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Fabric_Linen_02", "=q6=#crafttsf1#", "=q1=#p21#"};
				{ 2, 21848, "", "=q4=Spellfire Robe", "=ds=#s5#, #a1#"};
				{ 3, 21847, "", "=q4=Spellfire Gloves", "=ds=#s9#, #a1#"};
				{ 4, 21846, "", "=q4=Spellfire Belt", "=ds=#s10#, #a1#"};
			};
		};
		info = {
			name = BabbleItemSet["Wrath of Spellfire"],
			module = moduleName, menu = "CRAFTSET#4", instance = "TailoringSets",
		};
	};

	AtlasLoot_Data["TailoringFrostwovenPower"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Fabric_Linen_02", "=q6=#craftt10#", ""};
				{ 2, 41521, "", "=q2=Frostwoven Cowl", "=ds=#s1#, #a1#"};
				{ 3, 41513, "", "=q2=Frostwoven Shoulders", "=ds=#s3#, #a1#"};
				{ 4, 41515, "", "=q2=Frostwoven Robe", "=ds=#s5#, #a1#"};
				{ 5, 41512, "", "=q2=Frostwoven Wristwraps", "=ds=#s8#, #a1#"};
				{ 6, 44211, "", "=q2=Frostwoven Gloves", "=ds=#s9#, #a1#"};
				{ 7, 41522, "", "=q2=Frostwoven Belt", "=ds=#s10#, #a1#"};
				{ 8, 41519, "", "=q2=Frostwoven Leggings", "=ds=#s11#, #a1#"};
				{ 9, 41520, "", "=q2=Frostwoven Boots", "=ds=#s12#, #a1#"};
			};
		};
		info = {
			name = BabbleItemSet["Frostwoven Power"],
			module = moduleName, menu = "CRAFTSET#4", instance = "TailoringSets",
		};
	};

	AtlasLoot_Data["TailoringDuskweaver"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Fabric_Linen_02", "=q6=#craftt11#", ""};
				{ 2, 41546, "", "=q2=Duskweave Cowl", "=ds=#s1#, #a1#"};
				{ 3, 41550, "", "=q2=Duskweave Shoulders", "=ds=#s3#, #a1#"};
				{ 4, 41549, "", "=q2=Duskweave Robe", "=ds=#s5#, #a1#"};
				{ 5, 41551, "", "=q2=Duskweave Wristwraps", "=ds=#s8#, #a1#"};
				{ 6, 41545, "", "=q2=Duskweave Gloves", "=ds=#s9#, #a1#"};
				{ 7, 41543, "", "=q2=Duskweave Belt", "=ds=#s10#, #a1#"};
				{ 8, 41548, "", "=q2=Duskweave Leggings", "=ds=#s11#, #a1#"};
				{ 9, 41544, "", "=q2=Duskweave Boots", "=ds=#s12#, #a1#"};
			};
		};
		info = {
			name = BabbleItemSet["Duskweaver"],
			module = moduleName, menu = "CRAFTSET#4", instance = "TailoringSets",
		};
	};

	AtlasLoot_Data["TailoringFrostsavageBattlegear"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Fabric_Linen_02", "=q6=#craftt12#", ""};
				{ 2, 43971, "", "=q3=Frostsavage Cowl", "=ds=#s1#, #a1#"};
				{ 3, 43973, "", "=q3=Frostsavage Shoulders", "=ds=#s3#, #a1#"};
				{ 4, 43972, "", "=q3=Frostsavage Robe", "=ds=#s5#, #a1#"};
				{ 5, 43974, "", "=q3=Frostsavage Bracers", "=ds=#s8#, #a1#"};
				{ 6, 41516, "", "=q3=Frostsavage Gloves", "=ds=#s9#, #a1#"};
				{ 7, 43969, "", "=q3=Frostsavage Belt", "=ds=#s10#, #a1#"};
				{ 8, 43975, "", "=q3=Frostsavage Leggings", "=ds=#s11#, #a1#"};
				{ 9, 43970, "", "=q3=Frostsavage Boots", "=ds=#s12#, #a1#"};
			};
		};
		info = {
			name = BabbleItemSet["Frostsavage Battlegear"],
			module = moduleName, menu = "CRAFTSET#4", instance = "TailoringSets",
		};
	};

	-------------
	--- Other ---
	-------------

		----------------------------
		--- Crafted Epic Weapons ---
		----------------------------

	AtlasLoot_Data["CraftedWeapons"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#p2#", "=q1="..AL["Level 85"]};
				{ 2, 70155, "", "=q4=Brainsplinter", "=ds=#h1#, #w4#"};
				{ 3, 70158, "", "=q4=Elementium-Edged Scalper", "=ds=#h1#, #w1#"};
				{ 4, 70157, "", "=q4=Lightforged Elementium Hammer", "=ds=#h3#, #w6#"};
				{ 5, 70164, "", "=q4=Masterwork Elementium Deathblade", "=ds=#h2#, #w10#"};
				{ 6, 70156, "", "=q4=Masterwork Elementium Spellblade", "=ds=#h3#, #w4#"};
				{ 7, 70162, "", "=q4=Pyrium Spellward", "=ds=#h1#, #w10#"};
				{ 8, 70163, "", "=q4=Unbreakable Guardian", "=ds=#h1#, #w10#"};
				{ 9, 70165, "", "=q4=Witch-Hunter's Harvester", "=ds=#h2#, #w7#"};
				{ 10, 55069, "", "=q4=Elementium Earthguard", "=ds=#w8#"};
				{ 11, 55070, "", "=q4=Elementium Stormshield", "=ds=#w8#"};
				{ 13, 0, "INV_Box_01", "=q6=#p5#", "=q1="..AL["Level 85"]};
				{ 14, 71077, "", "=q4=Extreme-Impact Hole Puncher", "=ds=#w5#"};
				{ 16, 0, "INV_Box_01", "=q6=#p2#", "=q1="..AL["Level 80"]};
				{ 17, 45085, "", "=q4=Titansteel Spellblade", "=ds=#h3#, #w4#"};
				{ 18, 42435, "", "=q4=Titansteel Shanker", "=ds=#h1#, #w4#"};
				{ 19, 41383, "", "=q4=Titansteel Bonecrusher", "=ds=#h3#, #w6#"};
				{ 20, 41384, "", "=q4=Titansteel Guardian", "=ds=#h3#, #w6#"};
				{ 21, 41257, "", "=q4=Titansteel Destroyer", "=ds=#h2#, #w6#"};
				{ 22, 42508, "", "=q4=Titansteel Shield Wall", "=ds=#w8#"};
				{ 24, 0, "INV_Box_01", "=q6=#p5#", "=q1="..AL["Level 80"]};
				{ 25, 41168, "", "=q4=Armor Plated Combat Shotgun", "=ds=#w5#"};
				{ 26, 44504, "", "=q4=Nesingwary 4000", "=ds=#w5#"};
				{ 28, 49888, "", "=q4=Shadow's Edge", "=ds=#h2#, #w1#"};
			};
			{
				{ 1, 0, "INV_Box_01", "=q6=#p2#", "=q1="..AL["Level 60"]};
				{ 2, 19166, "", "=q4=Black Amnesty", "=ds=#h1#, #w4#"};
				{ 3, 22383, "", "=q4=Sageblade", "=ds=#h3#, #w10#"};
				{ 4, 19168, "", "=q4=Blackguard", "=ds=#h1#, #w10#"};
				{ 5, 19169, "", "=q4=Nightfall", "=ds=#h2#, #w1#"};
				{ 6, 19170, "", "=q4=Ebon Hand", "=ds=#h1#, #w6#"};
				{ 7, 22384, "", "=q4=Persuader", "=ds=#h1#, #w6#"};
				{ 8, 17193, "", "=q4=Sulfuron Hammer", "=ds=#h2#, #w6#"};
				{ 9, 19167, "", "=q4=Blackfury", "=ds=#w7#"};
				{ 10, 22198, "", "=q4=Jagged Obsidian Shield", "=ds=#w8#"};
				{ 12, 0, "INV_Box_01", "=q6=#p5#", "=q1="..AL["Level 60"]};
				{ 13, 18282, "", "=q4=Core Marksman Rifle", "=ds=#w5#"};
				{ 14, 18168, "", "=q4=Force Reactive Disk", "=ds=#w8#"};
				{ 16, 0, "INV_Box_01", "=q6=#p2#", "=q1="..AL["Level 70"]};
				{ 17, 23554, "", "=q4=Eternium Runed Blade", "=ds=#h3#, #w4#"};
				{ 18, 23555, "", "=q4=Dirge", "=ds=#h1#, #w4#"};
				{ 19, 23540, "", "=q4=Felsteel Longblade", "=ds=#h1#, #w10#"};
				{ 20, 23541, "", "=q4=Khorium Champion", "=ds=#h2#, #w10#"};
				{ 21, 23542, "", "=q4=Fel Edged Battleaxe", "=ds=#h1#, #w1#"};
				{ 22, 23543, "", "=q4=Felsteel Reaper", "=ds=#h2#, #w1#"};
				{ 23, 23556, "", "=q4=Hand of Eternity", "=ds=#h3#, #w6#"};
				{ 24, 23544, "", "=q4=Runic Hammer", "=ds=#h1#, #w6#"};
				{ 25, 23546, "", "=q4=Fel Hardened Maul", "=ds=#h2#, #w6#"};
				{ 26, 32854, "", "=q4=Hammer of Righteous Might", "=ds=#h2#, #w6#"};
				{ 28, 0, "INV_Box_01", "=q6=#p5#", "=q1="..AL["Level 70"]};
				{ 29, 32756, "", "=q4=Gyro-Balanced Khorium Destroyer", "=ds=#w5#"};
			};
			{
				{ 1, 0, "INV_Box_01", "=q6=#p15#", ""};
				{ 2, 28425, "", "=q4=Fireguard", "=ds=#h1#, #w10#"};
				{ 3, 28426, "", "=q4=Blazeguard", "=ds=#h1#, #w10#"};
				{ 4, 28427, "", "=q4=Blazefury", "=ds=#h1#, #w10#"};
				{ 5, 28428, "", "=q4=Lionheart Blade", "=ds=#h2#, #w10#"};
				{ 6, 28429, "", "=q4=Lionheart Champion", "=ds=#h2#, #w10#"};
				{ 7, 28430, "", "=q4=Lionheart Executioner", "=ds=#h2#, #w10#"};
				{ 9, 0, "INV_Box_01", "=q6=#p14#", ""};
				{ 10, 28431, "", "=q4=The Planar Edge", "=ds=#h3#, #w1#"};
				{ 11, 28432, "", "=q4=Black Planar Edge", "=ds=#h3#, #w1#"};
				{ 12, 28433, "", "=q4=Wicked Edge of the Planes", "=ds=#h3#, #w1#"};
				{ 13, 28434, "", "=q4=Lunar Crescent", "=ds=#h2#, #w1#"};
				{ 14, 28435, "", "=q4=Mooncleaver", "=ds=#h2#, #w1#"};
				{ 15, 28436, "", "=q4=Bloodmoon", "=ds=#h2#, #w1#"};
				{ 16, 0, "INV_Box_01", "=q6=#p22#", ""};
				{ 17, 28437, "", "=q4=Drakefist Hammer", "=ds=#h3#, #w6#"};
				{ 18, 28438, "", "=q4=Dragonmaw", "=ds=#h3#, #w6#"};
				{ 19, 28439, "", "=q4=Dragonstrike", "=ds=#h3#, #w6#"};
				{ 20, 28440, "", "=q4=Thunder", "=ds=#h2#, #w6#"};
				{ 21, 28441, "", "=q4=Deep Thunder", "=ds=#h2#, #w6#"};
				{ 22, 28442, "", "=q4=Stormherald", "=ds=#h2#, #w6#"};
			};
		};
		info = {
			name = AL["Crafted Epic Weapons"],
			module = moduleName, menu = "CRAFTINGMENU",
		};
	};

	--------------------------------
	--- Daily Profession Rewards ---
	--------------------------------

		---------------------
		--- Cooking Daily ---
		---------------------

	AtlasLoot_Data["CookingDaily"] = {
		["Normal"] = {
			{
				{ 1, 65411, "", "=q2=Recipe: Broiled Mountain Trout", "=ds=#sr# (450)", "#CHEFAWARD:3#"};
				{ 2, 65408, "", "=q2=Recipe: Feathered Lure", "=ds=#sr# (450)", "#CHEFAWARD:3#"};
				{ 3, 65415, "", "=q2=Recipe: Highland Spirits", "=ds=#sr# (450)", "#CHEFAWARD:3#"};
				{ 4, 65407, "", "=q2=Recipe: Lavascale Fillet", "=ds=#sr# (450)", "#CHEFAWARD:3#"};
				{ 5, 65412, "", "=q2=Recipe: Lightly Fried Lurker", "=ds=#sr# (450)", "#CHEFAWARD:3#"};
				{ 6, 65416, "", "=q2=Recipe: Lurker Lunch", "=ds=#sr# (450)", "#CHEFAWARD:3#"};
				{ 7, 65410, "", "=q2=Recipe: Salted Eye", "=ds=#sr# (450)", "#CHEFAWARD:3#"};
				{ 8, 65413, "", "=q2=Recipe: Seasoned Crab", "=ds=#sr# (450)", "#CHEFAWARD:3#"};
				{ 9, 65414, "", "=q2=Recipe: Starfire Espresso", "=ds=#sr# (450)", "#CHEFAWARD:3#"};
				{ 10, 65406, "", "=q2=Recipe: Whitecrest Gumbo", "=ds=#sr# (450)", "#CHEFAWARD:3#"};
				{ 11, 65418, "", "=q2=Recipe: Hearty Seafood Soup", "=ds=#sr# (475)", "#CHEFAWARD:3#"};
				{ 12, 65417, "", "=q2=Recipe: Pickled Guppy", "=ds=#sr# (475)", "#CHEFAWARD:3#"};
				{ 13, 65419, "", "=q2=Recipe: Tender Baked Turtle", "=ds=#sr# (475)", "#CHEFAWARD:3#"};
				{ 14, 65426, "", "=q2=Recipe: Baked Rockfish", "=ds=#sr# (500)", "#CHEFAWARD:3#"};
				{ 15, 65427, "", "=q2=Recipe: Basilisk Liverdog", "=ds=#sr# (500)", "#CHEFAWARD:3#"};
				{ 16, 65429, "", "=q2=Recipe: Beer-Basted Crocolisk", "=ds=#sr# (500)", "#CHEFAWARD:3#"};
				{ 17, 65424, "", "=q2=Recipe: Blackbelly Sushi", "=ds=#sr# (500)", "#CHEFAWARD:3#"};
				{ 18, 65430, "", "=q2=Recipe: Crocolisk Au Gratin", "=ds=#sr# (500)", "#CHEFAWARD:3#"};
				{ 19, 65422, "", "=q2=Recipe: Delicious Sagefish Tail", "=ds=#sr# (500)", "#CHEFAWARD:3#"};
				{ 20, 65423, "", "=q2=Recipe: Fish Fry", "=ds=#sr# (500)", "#CHEFAWARD:3#"};
				{ 21, 65428, "", "=q2=Recipe: Grilled Dragon", "=ds=#sr# (500)", "#CHEFAWARD:3#"};
				{ 22, 65409, "", "=q2=Recipe: Lavascale Minestrone", "=ds=#sr# (500)", "#CHEFAWARD:3#"};
				{ 23, 65420, "", "=q2=Recipe: Mushroom Sauce Mudfish", "=ds=#sr# (500)", "#CHEFAWARD:3#"};
				{ 24, 68688, "", "=q2=Recipe: Scalding Murglesnout", "=ds=#sr# (500)", "#CHEFAWARD:3#"};
				{ 25, 65421, "", "=q2=Recipe: Severed Sagefish Head", "=ds=#sr# (500)", "#CHEFAWARD:3#"};
				{ 26, 65425, "", "=q2=Recipe: Skewered Eel", "=ds=#sr# (500)", "#CHEFAWARD:3#"};
				{ 27, 65431, "", "=q2=Recipe: Chocolate Cookie", "=ds=#sr# (505)", "#CHEFAWARD:3#"};
				{ 28, 65432, "", "=q2=Recipe: Fortune Cookie", "=ds=#sr# (525)", "#CHEFAWARD:5#"};
				{ 29, 65433, "", "=q2=Recipe: South Island Iced Tea", "=ds=#sr# (525)", "#CHEFAWARD:5#"};
				extraText = ": "..BabbleZone["Stormwind"] .." / "..BabbleZone["Orgrimmar"];
			};
			{
				{ 1, 43035, "", "=q2=Recipe: Blackened Dragonfin", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 2, 43032, "", "=q2=Recipe: Blackened Worg Steak", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 3, 43029, "", "=q2=Recipe: Critter Bites", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 4, 43033, "", "=q2=Recipe: Cuttlesteak", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 5, 43036, "", "=q2=Recipe: Dragonfin Filet", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 6, 43024, "", "=q2=Recipe: Firecracker Salmon", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 7, 43030, "", "=q2=Recipe: Hearty Rhino", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 8, 43026, "", "=q2=Recipe: Imperial Manta Steak", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 9, 43018, "", "=q2=Recipe: Mega Mammoth Meal", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 10, 43022, "", "=q2=Recipe: Mighty Rhino Dogs", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 11, 43023, "", "=q2=Recipe: Poached Northern Sculpin", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 12, 43028, "", "=q2=Recipe: Rhinolicious Wormsteak", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 13, 43031, "", "=q2=Recipe: Snapper Extreme", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 14, 43034, "", "=q2=Recipe: Spiced Mammoth Treats", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 15, 43020, "", "=q2=Recipe: Spiced Worm Burger", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 16, 43025, "", "=q2=Recipe: Spicy Blue Nettlefish", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 17, 43027, "", "=q2=Recipe: Spicy Fried Herring", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 18, 43019, "", "=q2=Recipe: Tender Shoveltusk Steak", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 19, 43037, "", "=q2=Recipe: Tracker Snacks", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 20, 43021, "", "=q2=Recipe: Very Burnt Worg", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 21, 44954, "", "=q2=Recipe: Worg Tartare", "=ds=#sr# (400)", "#DALARANCK:3#"};
				{ 22, 43505, "", "=q2=Recipe: Gigantic Feast", "=ds=#sr# (425)", "#DALARANCK:3#"};
				{ 23, 43506, "", "=q2=Recipe: Small Feast", "=ds=#sr# (425)", "#DALARANCK:3#"};
				{ 24, 43017, "", "=q2=Recipe: Fish Feast", "=ds=#sr# (450)", "#DALARANCK:5#"};
				{ 26, 0, "inv_misc_bag_11", "=q6="..AL["Small Spice Bag"], ""};
				{ 27, 33925, "", "=q3=Recipe: Delicious Chocolate Cake", "=ds=#sr# (1)", ""};
				{ 28, 33871, "", "=q3=Recipe: Stormchops", "=ds=#sr# (300)", ""};
				{ 29, 44228, "", "=q1=Baby Spice", "=ds=#m20#", ""};
				{ 30, 44114, "", "=q1=Old Spices", "=ds=#m20#", ""};
				extraText = ": "..BabbleZone["Dalaran"];
			};
			{
				{ 2, 33870, "", "=q2=Recipe: Skullfish Soup", "=ds=#sr# (325)", "", ""};
				{ 3, 33873, "", "=q2=Recipe: Spicy Hot Talbuk", "=ds=#sr# (325)", "", ""};
				{ 4, 33869, "", "=q2=Recipe: Broiled Bloodfin", "=ds=#sr# (300)", "", ""};
				{ 5, 33875, "", "=q2=Recipe: Kibler's Bits", "=ds=#sr# (300)", "", ""};
				{ 17, 33871, "", "=q3=Recipe: Stormchops", "=ds=#sr# (300)", "", ""};
				{ 18, 33925, "", "=q3=Recipe: Delicious Chocolate Cake", "=ds=#sr# (1)", "", ""};
				extraText = ": "..BabbleZone["Shattrath"];
			};
		};
		info = {
			name = AL["Cooking Daily"],
			module = moduleName, menu = "COOKINGDAILYMENU",
		};
	}

		---------------------
		--- Fishing Daily ---
		---------------------

	AtlasLoot_Data["FishingDaily"] = {
		["Normal"] = {
			{
				{ 1, 45862, "", "=q4=Bold Stormjewel", "=ds=#e7#", "", ""};
				{ 2, 45882, "", "=q4=Brilliant Stormjewel", "=ds=#e7#", "", ""};
				{ 3, 45879, "", "=q4=Delicate Stormjewel", "=ds=#e7#", "", ""};
				{ 4, 45987, "", "=q4=Rigid Stormjewel", "=ds=#e7#", "", ""};
				{ 5, 45880, "", "=q4=Solid Stormjewel", "=ds=#e7#", "", ""};
				{ 6, 45881, "", "=q4=Sparkling Stormjewel", "=ds=#e7#", "", ""};
				{ 8, 33820, "", "=q3=Weather-Beaten Fishing Hat", "=ds=#s1#, #a1#", "", ""};
				{ 9, 45991, "", "=q3=Bone Fishing Pole", "=ds=#e20#", "", ""};
				{ 10, 45992, "", "=q3=Jeweled Fishing Pole", "=ds=#e20#", "", ""};
				{ 11, 44983, "", "=q3=Strand Crawler", "=ds=#e13#", "", ""};
				{ 12, 36784, "", "=q3=Siren's Tear", "=ds=#e7#", "", ""};
				{ 13, 45986, "", "=q3=Tiny Titanium Lockbox", "=ds=", "", ""};
				{ 16, 34834, "", "=q2=Recipe: Captain Rumsey's Lager", "=ds=#sr# (100)", "", ""};
				{ 17, 19971, "", "=q2=High Test Eternium Fishing Line", "=ds=#p24# #e17#", "", ""};
				{ 19, 45998, "", "=q1=Battered Jungle Hat", "=ds=#s1#", "", ""};
				{ 20, 45861, "", "=q1=Diamond-Tipped Cane", "=ds=#h2#", "", ""};
				{ 21, 46006, "", "=q1=Glow Worm", "=ds=#e24#", "", ""};
				{ 22, 45984, "", "=q1=Unusual Compass", "=ds=", "", ""};
				{ 23, 40195, "", "=q1=Pygmy Oil", "=ds=#e2#", "", ""};
				{ 24, 8827, "", "=q1=Elixir of Water Walking", "=ds=#e2#", "", ""};
				{ 25, 46004, "", "=q1=Sealed Vial of Poison", "=ds=#m2#", "", ""};
				{ 26, 48679, "", "=q1=Waterlogged Recipe", "=ds=#m2# #sr# (350)", "", ""};
				extraText = ": "..BabbleZone["Dalaran"];
			};
			{
				{ 1, 34837, "", "=q4=The 2 Ring", "=ds=#s13#", "", ""};
				{ 3, 33820, "", "=q3=Weather-Beaten Fishing Hat", "=ds=#s1#, #a1#", "", ""};
				{ 4, 35350, "", "=q3=Chuck's Bucket", "=ds=#e13#", "", ""};
				{ 5, 33818, "", "=q3=Muckbreath's Bucket", "=ds=#e13#", "", ""};
				{ 6, 35349, "", "=q3=Snarly's Bucket", "=ds=#e13#", "", ""};
				{ 7, 33816, "", "=q3=Toothy's Bucket", "=ds=#e13#", "", ""};
				{ 8, 34831, "", "=q3=Eye of the Sea", "=ds=#e7#", "", ""};
				{ 10, 34834, "", "=q2=Recipe: Captain Rumsey's Lager", "=ds=#sr# (100)", "", ""};
				{ 11, 34836, "", "=q2=Spun Truesilver Fishing Line", "=ds=#p24# #e17#", "", ""};
				{ 16, 34827, "", "=q1=Noble's Monocle", "=ds=#s1#", "", ""};
				{ 17, 34828, "", "=q1=Antique Silver Cufflinks", "=ds=#s8#", "", ""};
				{ 18, 34826, "", "=q1=Gold Wedding Band", "=ds=#s13#", "", ""};
				{ 19, 34829, "", "=q1=Ornate Drinking Stein", "=ds=#s15#", "", ""};
				{ 20, 34859, "", "=q1=Razor Sharp Fillet Knife", "=ds=#h1#, #w4#", "", ""};
				{ 21, 34109, "", "=q1=Weather-Beaten Journal", "=ds=#e10#", "", ""};
				{ 22, 8827, "", "=q1=Elixir of Water Walking", "=ds=#e2#", "", ""};
				{ 23, 34861, "", "=q1=Sharpened Fish Hook", "=ds=#e24#", "", ""};
				extraText = ": "..BabbleZone["Terokkar Forest"];
			};
		};
		info = {
			name = AL["Fishing Daily"],
			module = moduleName, menu = "FISHINGDAILYMENU",
		};
	}

		---------------------------
		--- Jewelcrafting Daily ---
		---------------------------

	AtlasLoot_Data["JewelcraftingDailyRed"] = {
		["Normal"] = {
			{
				{ 1, 41576, "", "=q3=Design: Bold Scarlet Ruby", "=ds=#p12# (390)"};
				{ 2, 41577, "", "=q3=Design: Delicate Scarlet Ruby", "=ds=#p12# (390)"};
				{ 3, 41578, "", "=q3=Design: Flashing Scarlet Ruby", "=ds=#p12# (390)"};
				{ 4, 46917, "", "=q3=Design: Bold Cardinal Ruby", "=ds=#p12# (450)"};
				{ 5, 46916, "", "=q3=Design: Brilliant Cardinal Ruby", "=ds=#p12# (450)"}; --v1
				{ 6, 46930, "", "=q3=Design: Brilliant Cardinal Ruby", "=ds=#p12# (450)"}; --v2
				{ 7, 46918, "", "=q3=Design: Delicate Cardinal Ruby", "=ds=#p12# (450)"}; --v1
				{ 8, 46919, "", "=q3=Design: Delicate Cardinal Ruby", "=ds=#p12# (450)"}; --v2
				{ 9, 46923, "", "=q3=Design: Flashing Cardinal Ruby", "=ds=#p12# (450)"};
				{ 10, 46920, "", "=q3=Design: Precise Cardinal Ruby", "=ds=#p12# (450)"};
			};
		};
		info = {
			name = AL["Jewelcrafting Daily"],
			module = moduleName, menu = "JEWELCRAFTINGDAILYMENU",
		};
	}

	AtlasLoot_Data["JewelcraftingDailyYellow"] = {
		["Normal"] = {
			{
				{ 1, 41579, "", "=q3=Design: Quick Autumn's Glow", "=ds=#p12# (390)"};
				{ 2, 41719, "", "=q3=Design: Subtle Autumn's Glow", "=ds=#p12# (390)"}; --v1
				{ 3, 41791, "", "=q3=Design: Subtle Autumn's Glow", "=ds=#p12# (390)"}; --v2
				{ 4, 46932, "", "=q3=Design: Mystic King's Amber", "=ds=#p12# (450)"};
				{ 5, 46933, "", "=q3=Design: Quick King's Amber", "=ds=#p12# (450)"};
				{ 6, 46929, "", "=q3=Design: Smooth King's Amber", "=ds=#p12# (450)"}; --v1
				{ 7, 46921, "", "=q3=Design: Smooth King's Amber", "=ds=#p12# (450)"}; --v2
				{ 8, 46931, "", "=q3=Design: Subtle King's Amber", "=ds=#p12# (450)"}; --v1
				{ 9, 46922, "", "=q3=Design: Subtle King's Amber", "=ds=#p12# (450)"}; --v2
			};
		};
		info = {
			name = AL["Jewelcrafting Daily"],
			module = moduleName, menu = "JEWELCRAFTINGDAILYMENU",
		};
	}

	AtlasLoot_Data["JewelcraftingDailyOrange"] = {
		["Normal"] = {
			{
				{ 1, 41686, "", "=q3=Design: Potent Monarch Topaz", "=ds=#p12# (390)"};
				{ 2, 41690, "", "=q3=Design: Reckless Monarch Topaz", "=ds=#p12# (390)"}; --v1
				{ 3, 41689, "", "=q3=Design: Reckless Monarch Topaz", "=ds=#p12# (390)"}; --v2
				{ 4, 47015, "", "=q3=Design: Champion's Ametrine", "=ds=#p12# (450)"};
				{ 5, 46949, "", "=q3=Design: Deadly Ametrine", "=ds=#p12# (450)"}; --v1
				{ 6, 47011, "", "=q3=Design: Deadly Ametrine", "=ds=#p12# (450)"}; --v2
				{ 7, 47020, "", "=q3=Design: Deft Ametrine", "=ds=#p12# (450)"}; --v1
				{ 8, 47023, "", "=q3=Design: Deft Ametrine", "=ds=#p12# (450)"}; --v2
				{ 9, 47019, "", "=q3=Design: Fierce Ametrine", "=ds=#p12# (450)"};
				{ 10, 46948, "", "=q3=Design: Inscribed Ametrine", "=ds=#p12# (450)"};
				{ 11, 47021, "", "=q3=Design: Lucent Ametrine", "=ds=#p12# (450)"}; --v1
				{ 12, 47016, "", "=q3=Design: Lucent Ametrine", "=ds=#p12# (450)"}; --v2
				{ 13, 46950, "", "=q3=Design: Potent Ametrine", "=ds=#p12# (450)"};
				{ 14, 47007, "", "=q3=Design: Reckless Ametrine", "=ds=#p12# (450)"};
				{ 15, 47022, "", "=q3=Design: Resolute Ametrine", "=ds=#p12# (450)"};
				{ 16, 47018, "", "=q3=Design: Resplendent Ametrine", "=ds=#p12# (450)"};
				{ 17, 47017, "", "=q3=Design: Stalwart Ametrine", "=ds=#p12# (450)"}; --v1
				{ 18, 47012, "", "=q3=Design: Stalwart Ametrine", "=ds=#p12# (450)"}; --v2
				{ 19, 41687, "", "=q3=Design: Deft Monarch Topaz", "=ds=#p12# (390)"}; --v1
				{ 20, 41792, "", "=q3=Design: Deft Monarch Topaz", "=ds=#p12# (390)"}; --v2
				{ 21, 46952, "", "=q3=Design: Willful Ametrine", "=ds=#p12# (450)"};
			};
		};
		info = {
			name = AL["Jewelcrafting Daily"],
			module = moduleName, menu = "JEWELCRAFTINGDAILYMENU",
		};
	}

	AtlasLoot_Data["JewelcraftingDailyGreen"] = {
		["Normal"] = {
			{
				{ 1, 41692, "", "=q3=Design: Energized Forest Emerald", "=ds=#p12# (390)"}; --v1
				{ 2, 41694, "", "=q3=Design: Energized Forest Emerald", "=ds=#p12# (390)"}; --v2
				{ 3, 41693, "", "=q3=Design: Forceful Forest Emerald", "=ds=#p12# (390)"};
				{ 4, 46912, "", "=q3=Design: Energized Eye of Zul", "=ds=#p12# (450)"}; --v1
				{ 5, 46910, "", "=q3=Design: Energized Eye of Zul", "=ds=#p12# (450)"}; --v2
				{ 6, 46904, "", "=q3=Design: Forceful Eye of Zul", "=ds=#p12# (450)"};
				{ 7, 46901, "", "=q3=Design: Jagged Eye of Zul", "=ds=#p12# (450)"}; --v1
				{ 8, 46944, "", "=q3=Design: Jagged Eye of Zul", "=ds=#p12# (450)"}; --v2
				{ 9, 46905, "", "=q3=Design: Misty Eye of Zul", "=ds=#p12# (450)"}; --v1
				{ 10, 46906, "", "=q3=Design: Misty Eye of Zul", "=ds=#p12# (450)"}; --v2
				{ 11, 46911, "", "=q3=Design: Radiant Eye of Zul", "=ds=#p12# (450)"}; --v1
				{ 12, 46908, "", "=q3=Design: Radiant Eye of Zul", "=ds=#p12# (450)"}; --v2
				{ 13, 46913, "", "=q3=Design: Shattered Eye of Zul", "=ds=#p12# (450)"};
				{ 14, 46898, "", "=q3=Design: Steady Eye of Zul", "=ds=#p12# (450)"};
				{ 15, 46915, "", "=q3=Design: Turbid Eye of Zul", "=ds=#p12# (450)"}; --v1
				{ 16, 46914, "", "=q3=Design: Turbid Eye of Zul", "=ds=#p12# (450)"}; --v2
				{ 17, 41698, "", "=q3=Design: Nimble Forest Emerald", "=ds=#p12# (390)"};
				{ 18, 41703, "", "=q3=Design: Regal Forest Emerald", "=ds=#p12# (390)"}; --v1
				{ 19, 41697, "", "=q3=Design: Regal Forest Emerald", "=ds=#p12# (390)"}; --v2
				{ 20, 41696, "", "=q3=Design: Lightning Forest Emerald", "=ds=#p12# (390)"}; --v1
				{ 21, 41782, "", "=q3=Design: Lightning Forest Emerald", "=ds=#p12# (390)"}; --v2
				{ 22, 41702, "", "=q3=Design: Jagged Forest Emerald", "=ds=#p12# (390)"}; --v1
				{ 23, 41723, "", "=q3=Design: Jagged Forest Emerald", "=ds=#p12# (390)"}; --v2
				{ 24, 46897, "", "=q3=Design: Regal Eye of Zul", "=ds=#p12# (450)"}; --v1
				{ 25, 46940, "", "=q3=Design: Regal Eye of Zul", "=ds=#p12# (450)"}; --v2
				{ 26, 46899, "", "=q3=Design: Nimble Eye of Zul", "=ds=#p12# (450)"};
				{ 27, 46909, "", "=q3=Design: Lightning Eye of Zul", "=ds=#p12# (450)"}; --v1
				{ 28, 46907, "", "=q3=Design: Lightning Eye of Zul", "=ds=#p12# (450)"}; --v2
			};
		};
		info = {
			name = AL["Jewelcrafting Daily"],
			module = moduleName, menu = "JEWELCRAFTINGDAILYMENU",
		};
	}

	AtlasLoot_Data["JewelcraftingDailyPurple"] = {
		["Normal"] = {
			{
				{ 1, 46941, "", "=q3=Design: Defender's Dreadstone", "=ds=#p12# (450)"};
				{ 2, 46942, "", "=q3=Design: Guardian's Dreadstone", "=ds=#p12# (450)"};
				{ 3, 46943, "", "=q3=Design: Mysterious Dreadstone", "=ds=#p12# (450)"};
				{ 4, 46937, "", "=q3=Design: Purified Dreadstone", "=ds=#p12# (450)"}; --v1
				{ 5, 46903, "", "=q3=Design: Purified Dreadstone", "=ds=#p12# (450)"}; --v2
				{ 6, 46947, "", "=q3=Design: Purified Dreadstone", "=ds=#p12# (450)"}; --v3
				{ 7, 46900, "", "=q3=Design: Purified Dreadstone", "=ds=#p12# (450)"}; --v4
				{ 8, 46939, "", "=q3=Design: Purified Dreadstone", "=ds=#p12# (450)"}; --v5
				{ 9, 46938, "", "=q3=Design: Shifting Dreadstone", "=ds=#p12# (450)"};
				{ 10, 46935, "", "=q3=Design: Sovereign Dreadstone", "=ds=#p12# (450)"};
				{ 11, 41582, "", "=q3=Design: Glinting Twilight Opal", "=ds=#p12# (390)"}; --v1
				{ 12, 41796, "", "=q3=Design: Glinting Twilight Opal", "=ds=#p12# (390)"}; --v2
				{ 13, 41785, "", "=q3=Design: Glinting Twilight Opal", "=ds=#p12# (390)"}; --v3
				{ 14, 41688, "", "=q3=Design: Veiled Twilight Opal", "=ds=#p12# (390)"};
				{ 15, 41747, "", "=q3=Design: Shifting Twilight Opal", "=ds=#p12# (390)"};
				{ 16, 46902, "", "=q3=Design: Timeless Dreadstone", "=ds=#p12# (450)"}; --v1
				{ 17, 46936, "", "=q3=Design: Timeless Dreadstone", "=ds=#p12# (450)"}; --v2
				{ 18, 46951, "", "=q3=Design: Veiled Dreadstone", "=ds=#p12# (390)"};
				{ 19, 46953, "", "=q3=Design: Etched Dreadstone", "=ds=#p12# (450)"};
				{ 20, 46956, "", "=q3=Design: Glinting Dreadstone", "=ds=#p12# (450)"}; --v1
				{ 21, 46946, "", "=q3=Design: Glinting Dreadstone", "=ds=#p12# (450)"}; --v2
				{ 22, 46945, "", "=q3=Design: Glinting Dreadstone", "=ds=#p12# (450)"}; --v3
				{ 23, 47008, "", "=q3=Design: Glinting Dreadstone", "=ds=#p12# (450)"}; --v4
				{ 24, 47010, "", "=q3=Design: Accurate Dreadstone", "=ds=#p12# (450)"};
			};
		};
		info = {
			name = AL["Jewelcrafting Daily"],
			module = moduleName, menu = "JEWELCRAFTINGDAILYMENU",
		};
	}


	AtlasLoot_Data["JewelcraftingDailyBlue"] = {
		["Normal"] = {
			{
				{ 1, 41580, "", "=q3=Design: Rigid Sky Sapphire", "=ds=#p12# (390)"};
				{ 2, 42138, "", "=q3=Design: Solid Sky Sapphire", "=ds=#p12# (390)"};
				{ 3, 46928, "", "=q3=Design: Rigid Majestic Zircon", "=ds=#p12# (450)"};
				{ 4, 46924, "", "=q3=Design: Solid Majestic Zircon", "=ds=#p12# (450)"};
				{ 5, 46925, "", "=q3=Design: Sparkling Majestic Zircon", "=ds=#p12# (450)"}; --v1
				{ 6, 46927, "", "=q3=Design: Sparkling Majestic Zircon", "=ds=#p12# (450)"}; --v2
				{ 7, 46926, "", "=q3=Design: Stormy Majestic Zircon", "=ds=#p12# (450)"};
				{ 8, 41581, "", "=q3=Design: Sparkling Sky Sapphire", "=ds=#p12# (420)"};
			};
		};
		info = {
			name = AL["Jewelcrafting Daily"],
			module = moduleName, menu = "JEWELCRAFTINGDAILYMENU",
		};
	}

	AtlasLoot_Data["JewelcraftingDailyMeta"] = {
		["Normal"] = {
			{
				{ 1, 41704, "", "=q3=Design: Chaotic Skyflare Diamond", "=ds=#p12# (420)"};
				{ 2, 41706, "", "=q3=Design: Ember Skyflare Diamond", "=ds=#p12# (420)"};
				{ 3, 41708, "", "=q3=Design: Insightful Earthsiege Diamond", "=ds=#p12# (420)"};
				{ 4, 41709, "", "=q3=Design: Invigorating Earthsiege Diamond", "=ds=#p12# (420)"};
				{ 5, 41710, "", "=q3=Design: Relentless Earthsiege Diamond", "=ds=#p12# (420)"};
				{ 6, 41707, "", "=q3=Design: Revitalizing Skyflare Diamond", "=ds=#p12# (420)"};
				{ 7, 41711, "", "=q3=Design: Trenchant Earthsiege Diamond", "=ds=#p12# (420)"};
				{ 8, 41705, "", "=q3=Design: Shielded Skyflare Diamond", "=ds=#p12# (420)"};
			};
		};
		info = {
			name = AL["Jewelcrafting Daily"],
			module = moduleName, menu = "JEWELCRAFTINGDAILYMENU",
		};
	}

	AtlasLoot_Data["JewelcraftingDailyDragonEye"] = {
		["Normal"] = {
			{
				{ 1, 42298, "", "=q3=Design: Bold Dragon's Eye", "=ds=#p12# (370)"};
				{ 2, 42300, "", "=q3=Design: Brilliant Dragon's Eye", "=ds=#p12# (370)"}; --v1
				{ 3, 42309, "", "=q3=Design: Brilliant Dragon's Eye", "=ds=#p12# (370)"}; --v2
				{ 4, 42301, "", "=q3=Design: Delicate Dragon's Eye", "=ds=#p12# (370)"}; --v1
				{ 5, 42299, "", "=q3=Design: Delicate Dragon's Eye", "=ds=#p12# (370)"}; --v2
				{ 6, 42302, "", "=q3=Design: Flashing Dragon's Eye", "=ds=#p12# (370)"};
				{ 7, 42305, "", "=q3=Design: Mystic Dragon's Eye", "=ds=#p12# (370)"};
				{ 8, 42306, "", "=q3=Design: Precise Dragon's Eye", "=ds=#p12# (370)"};
				{ 9, 42307, "", "=q3=Design: Quick Dragon's Eye", "=ds=#p12# (370)"};
				{ 10, 42308, "", "=q3=Design: Rigid Dragon's Eye", "=ds=#p12# (370)"};
				{ 11, 42310, "", "=q3=Design: Smooth Dragon's Eye", "=ds=#p12# (370)"}; --v1
				{ 12, 42303, "", "=q3=Design: Smooth Dragon's Eye", "=ds=#p12# (370)"}; --v2
				{ 13, 42311, "", "=q3=Design: Solid Dragon's Eye", "=ds=#p12# (370)"};
				{ 14, 42312, "", "=q3=Design: Sparkling Dragon's Eye", "=ds=#p12# (370)"}; --v1
				{ 15, 42304, "", "=q3=Design: Sparkling Dragon's Eye", "=ds=#p12# (370)"}; --v2
				{ 16, 42313, "", "=q3=Design: Stormy Dragon's Eye", "=ds=#p12# (370)"};
				{ 17, 42314, "", "=q3=Design: Subtle Dragon's Eye", "=ds=#p12# (370)"}; --v1
				{ 18, 42315, "", "=q3=Design: Subtle Dragon's Eye", "=ds=#p12# (370)"}; --v2
			};
		};
		info = {
			name = AL["Jewelcrafting Daily"],
			module = moduleName, menu = "JEWELCRAFTINGDAILYMENU",
		};
	}

	AtlasLoot_Data["JewelcraftingDailyNeckRing"] = {
		["Normal"] = {
			{
				{ 1, 42652, "", "=q4=Design: Titanium Earthguard Chain", "=ds=#p12# (420)"};
				{ 2, 42649, "", "=q4=Design: Titanium Earthguard Ring", "=ds=#p12# (420)"};
				{ 3, 42648, "", "=q4=Design: Titanium Impact Band", "=ds=#p12# (420)"};
				{ 4, 42651, "", "=q4=Design: Titanium Impact Choker", "=ds=#p12# (420)"};
				{ 5, 42653, "", "=q4=Design: Titanium Spellshock Necklace", "=ds=#p12# (420)"};
				{ 6, 42650, "", "=q4=Design: Titanium Spellshock Ring", "=ds=#p12# (420)"};
				{ 7, 43497, "", "=q3=Design: Savage Titanium Band", "=ds=#p12# (420)"};
				{ 8, 43485, "", "=q3=Design: Savage Titanium Ring", "=ds=#p12# (420)"};
				{ 9, 43318, "", "=q3=Design: Ring of Scarlet Shadows", "=ds=#p12# (420)"};
				{ 10, 43319, "", "=q3=Design: Windfire Band", "=ds=#p12# (420)"};
				{ 11, 43317, "", "=q3=Design: Ring of Earthen Might", "=ds=#p12# (420)"};
				{ 12, 43320, "", "=q3=Design: Ring of Northern Tears", "=ds=#p12# (420)"};
				{ 13, 43597, "", "=q4=Design: Titanium Frostguard Ring", "=ds=#p12# (420)"};
			};
		};
		info = {
			name = AL["Jewelcrafting Daily"],
			module = moduleName, menu = "JEWELCRAFTINGDAILYMENU",
		};
	}

	AtlasLoot_Data["JewelcraftingDailyRemoved"] = {
		["Normal"] = {
			{
				{ 1, 47010, "", "=q3=Design: Accurate Ametrine", "=ds=#p12# (450)"};
				{ 2, 46952, "", "=q3=Design: Durable Ametrine", "=ds=#p12# (450)"};
				{ 3, 47016, "", "=q3=Design: Empowered Ametrine", "=ds=#p12# (450)"};
				{ 4, 46953, "", "=q3=Design: Etched Ametrine", "=ds=#p12# (450)"};
				{ 5, 47012, "", "=q3=Design: Glimmering Ametrine", "=ds=#p12# (450)"};
				{ 6, 47008, "", "=q3=Design: Glinting Ametrine", "=ds=#p12# (450)"};
				{ 7, 46947, "", "=q3=Design: Luminous Ametrine", "=ds=#p12# (450)"};
				{ 8, 46956, "", "=q3=Design: Pristine Ametrine", "=ds=#p12# (450)"};
				{ 9, 47023, "", "=q3=Design: Stark Ametrine", "=ds=#p12# (450)"};
				{ 10, 46951, "", "=q3=Design: Veiled Ametrine", "=ds=#p12# (450)"};
				{ 11, 47011, "", "=q3=Design: Wicked Ametrine", "=ds=#p12# (450)"};
				{ 12, 41582, "", "=q3=Design: Glinting Monarch Topaz", "=ds=#p12# (390)"};
				{ 13, 41689, "", "=q3=Design: Luminous Monarch Topaz", "=ds=#p12# (390)"};
				{ 14, 41687, "", "=q3=Design: Stark Monarch Topaz", "=ds=#p12# (390)"};
				{ 15, 41688, "", "=q3=Design: Veiled Monarch Topaz", "=ds=#p12# (390)"};
				{ 16, 46900, "", "=q3=Design: Dazzling Eye of Zul", "=ds=#p12# (450)"};
				{ 17, 46897, "", "=q3=Design: Enduring Eye of Zul", "=ds=#p12# (450)"};
				{ 18, 46910, "", "=q3=Design: Intricate Eye of Zul", "=ds=#p12# (450)"};
				{ 19, 46914, "", "=q3=Design: Opaque Eye of Zul", "=ds=#p12# (450)"};
				{ 20, 46903, "", "=q3=Design: Seer's Eye of Zul", "=ds=#p12# (450)"};
				{ 21, 46907, "", "=q3=Design: Shining Eye of Zul", "=ds=#p12# (450)"};
				{ 22, 46909, "", "=q3=Design: Lambent Eye of Zul", "=ds=#p12# (450)"};
				{ 23, 46906, "", "=q3=Design: Sundered Eye of Zul", "=ds=#p12# (450)"};
				{ 24, 46908, "", "=q3=Design: Tense Eye of Zul", "=ds=#p12# (450)"};
				{ 25, 46902, "", "=q3=Design: Timeless Eye of Zul", "=ds=#p12# (450)"};
				{ 26, 46899, "", "=q3=Design: Vivid Eye of Zul", "=ds=#p12# (450)"};
				{ 27, 41697, "", "=q3=Design: Enduring Forest Emerald", "=ds=#p12# (390)"};
				{ 28, 41694, "", "=q3=Design: Intricate Forest Emerald", "=ds=#p12# (390)"};
				{ 29, 41696, "", "=q3=Design: Lambent Forest Emerald", "=ds=#p12# (390)"};
				{ 30, 41699, "", "=q3=Design: Seer's Forest Emerald", "=ds=#p12# (390)"};
			};
			{
				{ 1, 41698, "", "=q3=Design: Vivid Forest Emerald", "=ds=#p12# (390)"};
				{ 2, 46934, "", "=q3=Design: Balanced Dreadstone", "=ds=#p12# (450)"};
				{ 3, 46936, "", "=q3=Design: Glowing Dreadstone", "=ds=#p12# (450)"};
				{ 4, 46945, "", "=q3=Design: Infused Dreadstone", "=ds=#p12# (450)"};
				{ 5, 46944, "", "=q3=Design: Puissant Dreadstone", "=ds=#p12# (450)"};
				{ 6, 46940, "", "=q3=Design: Regal Dreadstone", "=ds=#p12# (450)"};
				{ 7, 46939, "", "=q3=Design: Royal Dreadstone", "=ds=#p12# (450)"};
				{ 8, 46946, "", "=q3=Design: Tenuous Dreadstone", "=ds=#p12# (450)"};
				{ 9, 41702, "", "=q3=Design: Puissant Twilight Opal", "=ds=#p12# (390)"};
				{ 10, 41703, "", "=q3=Design: Regal Twilight Opal", "=ds=#p12# (390)"};
				{ 11, 41701, "", "=q3=Design: Royal Twilight Opal", "=ds=#p12# (390)"};
				{ 12, 46927, "", "=q3=Design: Lustrous Majestic Zircon", "=ds=#p12# (450)"};
				{ 13, 41581, "", "=q3=Design: Lustrous Sky Sapphire", "=ds=#p12# (390)"};
				{ 14, 41705, "", "=q3=Design: Effulgent Skyflare Diamond", "=ds=#p12# (420)"};
				{ 15, 42299, "", "=q3=Design: Bright Dragon's Eye", "=ds=#p12# (370)"};
				{ 16, 42303, "", "=q3=Design: Fractured Dragon's Eye", "=ds=#p12# (370)"};
				{ 17, 42304, "", "=q3=Design: Lustrous Dragon's Eye", "=ds=#p12# (370)"};
				{ 18, 42309, "", "=q3=Design: Runed Dragon's Eye", "=ds=#p12# (370)"};
				{ 19, 42315, "", "=q3=Design: Thick Dragon's Eye", "=ds=#p12# (370)"};
			};
		};
		info = {
			name = AL["Jewelcrafting Daily"],
			module = moduleName, menu = "JEWELCRAFTINGDAILYMENU",
		};
	}