-- $Id: PvPMenus.lua 3697 2012-01-31 15:17:37Z lag123 $
local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");
local BabbleInventory = AtlasLoot_GetLocaleLibBabble("LibBabble-Inventory-3.0")
local BabbleFaction = AtlasLoot_GetLocaleLibBabble("LibBabble-Faction-3.0")
local BabbleZone = AtlasLoot_GetLocaleLibBabble("LibBabble-Zone-3.0")

	AtlasLoot_Data["PVPMENU"] = {
		["Normal"] = {
			{
				{ 2, "PVP85Accessories", "inv_jewelry_ring_80", "=ds="..AL["PvP Accessories"], "=q5="..AL["Level 85"]};
				{ 3, "PVP85Trinkets", "inv_misc_token_argentdawn3", "=ds="..AL["PvP Trinkets"], "=q5="..AL["Level 85"]};
				{ 4, "PVP85SET", "inv_helm_plate_pvppaladin_c_01", "=ds="..AL["PvP Armor Sets"], "=q5="..AL["Level 85"]};
				{ 5, "PVP85NonSet", "inv_bracer_mail_pvphunter_c_01", "=ds="..AL["PvP Non-Set Epics"], "=q5="..AL["Level 85"]};
				{ 7, "PVP80Accessories", "INV_Jewelry_Necklace_36", "=ds="..AL["PvP Accessories"], "=q5="..AL["Level 80"]};
				{ 8, "PVP80SET", "INV_Boots_01", "=ds="..AL["PvP Armor Sets"], "=q5="..AL["Level 80"]};
				{ 10, "PVPMENU2", "INV_Jewelry_Necklace_21", "=ds="..AL["BG/Open PvP Rewards"], ""};
				{ 17, "PVP85Weapons2", "inv_weapon_shortblade_107", "=ds="..AL["PvP Weapons"].. " - " ..AL["ilvl 378"], "=q5="..AL["Level 85"]};
				{ 18, "PVP85Weapons4", "inv_hand_1h_pvp400_c_01", "=ds="..AL["PvP Weapons"].. " - " ..AL["ilvl 397"], "=q5="..AL["Level 85"]};
				{ 19, "PVP85Weapons5", "inv_hand_1h_pvp400_c_01", "=ds="..AL["PvP Weapons"].. " - " ..AL["ilvl 410"], "=q5="..AL["Level 85"]};
				{ 20, "PVP85Misc", "ability_warrior_rampage", "=ds="..AL["Misc"], "=q5="..AL["Level 85"]};
				{ 22, "PVP80NONSETEPICS", "inv_bracer_51", "=ds="..AL["PvP Non-Set Epics"], "=q5="..AL["Level 80"]};
				{ 23, "PVP80Weapons", "INV_Sword_86", "=ds="..AL["PvP Weapons"], "=q5="..AL["Level 80"] };
				{ 25, "PVPMENU3", "inv_belt_13", "=ds="..AL["Old PvP Rewards"], "=q5="..AL["Level 60"].. " / " ..AL["Level 70"]};
			};
		};
		info = {
			name = AL["PvP Rewards"],
		};
	}

	AtlasLoot_Data["PVPMENU2"] = {
		["Normal"] = {
			{
				{ 2, "ABMisc", "INV_Jewelry_Amulet_07", "=ds="..AL["Misc. Rewards"], "=q5="..BabbleZone["Arathi Basin"]};
				{ 3, "ABSets", "INV_Jewelry_Amulet_07", "=ds="..AL["Arathi Basin Sets"], ""};
				{ 5, "WSGMisc", "INV_Misc_Rune_07", "=ds="..AL["Misc. Rewards"], "=q5="..BabbleZone["Warsong Gulch"]};
				{ 6, "WSGAccessories", "INV_Misc_Rune_07", "=ds="..AL["Accessories"], "=q5="..BabbleZone["Warsong Gulch"]};
				{ 8, "AVMisc", "INV_Jewelry_Necklace_21", "=ds="..BabbleZone["Alterac Valley"], ""};
				{ 10, "Hellfire", "INV_Misc_Token_HonorHold", "=ds="..BabbleZone["Hellfire Peninsula"], "=q5="..AL["Hellfire Fortifications"]};
				{ 11, "Zangarmarsh", "Spell_Nature_ElementalPrecision_1", "=ds="..BabbleZone["Zangarmarsh"], "=q5="..AL["Twin Spire Ruins"]};
				{ 13, "WINTERGRASPMENU", "INV_Misc_Platnumdisks", "=ds="..BabbleZone["Wintergrasp"], ""};
				{ 17, "AB4049", "INV_Jewelry_Amulet_07", "=ds="..AL["Level 40-49 Rewards"], "=q5="..BabbleZone["Arathi Basin"]};
				{ 18, "AB2039", "INV_Jewelry_Amulet_07", "=ds="..AL["Level 20-39 Rewards"], "=q5="..BabbleZone["Arathi Basin"]};
				{ 20, "WSGWeapons", "INV_Misc_Rune_07", "=ds="..AL["Weapons"], "=q5="..BabbleZone["Warsong Gulch"]};
				{ 21, "WSGArmor", "INV_Misc_Rune_07", "=ds="..BabbleInventory["Armor"], "=q5="..BabbleZone["Warsong Gulch"]};
				{ 25, "Terokkar", "INV_Jewelry_FrostwolfTrinket_04", "=ds="..BabbleZone["Terokkar Forest"], "=q5="..AL["Spirit Towers"]};
				{ 26, "Nagrand", "INV_Misc_Rune_09", "=ds="..BabbleZone["Nagrand"], "=q5="..AL["Halaa"]};
				{ 28, "VentureBay", "INV_Misc_Coin_16", "=ds="..BabbleZone["Grizzly Hills"], "=q5="..AL["Venture Bay"]};
			};
		};
		info = {
			name = AL["PvP Rewards"],
			menu = "PVPMENU",
		};
	}

	AtlasLoot_Data["PVPMENU3"] = {
		["Normal"] = {
			{
				{ 2, "PVP60Accessories", "inv_jewelry_trinketpvp_01", "=ds="..AL["PvP Accessories"], "=q5="..AL["Level 60"]};
				{ 3, "PVP60SET", "INV_Axe_02", "=ds="..AL["PvP Armor Sets"], "=q5="..AL["Level 60"]};
				{ 5, "PVP70Accessories", "inv_jewelry_ring_60", "=ds="..AL["PvP Accessories"], "=q5="..AL["Level 70"]};
				{ 6, "PVP70RepSET", "INV_Axe_02", "=ds="..AL["PvP Reputation Sets"], "=q5="..AL["Level 70"]};
				{ 8, "PVPGladiatorWeapons", "inv_weapon_hand_13", "=ds="..AL["PvP Weapons"], "=q5="..AL["Level 70"].." - "..AL["Gladiator"]};
				{ 9, "PVPMercilessWeapons", "inv_staff_53", "=ds="..AL["PvP Weapons"], "=q5="..AL["Level 70"].." - "..AL["Merciless"]};
				{ 17, "PVP60Weapons", "INV_Weapon_Bow_08", "=ds="..AL["PvP Weapons"], "=q5="..AL["Level 60"]};
				{ 20, "PVP70NonSet", "inv_belt_13", "=ds="..AL["PvP Non-Set Epics"], "=q5="..AL["Level 70"]};
				{ 21, "PVP70SET", "inv_gauntlets_29", "=ds="..AL["PvP Armor Sets"], "=q5="..AL["Level 70"]};
				{ 23, "PVPVengefulWeapons", "inv_weapon_shortblade_62", "=ds="..AL["PvP Weapons"], "=q5="..AL["Level 70"].." - "..AL["Vengeful"]};
				{ 24, "PVP70Weapons", "INV_Weapon_Crossbow_10", "=ds="..AL["PvP Weapons"], "=q5="..AL["Level 70"].." - "..AL["Brutal"]};
			};
		};
		info = {
			name = AL["PvP Rewards"],
			menu = "PVPMENU",
		};
	}

	AtlasLoot_Data["PVP60SET"] = {
		["Normal"] = {
			{
				{ 3, "PVP60Druid", "ability_druid_maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], ""};
				{ 4, "PVP60Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 5, "PVP60Priest", "inv_staff_30", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], ""};
				{ 6, "PVP60Shaman", "spell_nature_bloodlust", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], ""};
				{ 7, "PVP60Warrior", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], ""};
				{ 18, "PVP60Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 19, "PVP60Paladin", "ability_thunderbolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], ""};
				{ 20, "PVP60Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 21, "PVP60Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
			};
		};
		info = {
			name = AL["PvP Armor Sets"]..": "..AL["Level 60"],
			menu = "PVPMENU3",
		};
	}

	AtlasLoot_Data["PVP70SET"] = {
		["Normal"] = {
			{
				{ 2, "PVP70DeathKnight", "spell_deathknight_classicon", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], ""};
				{ 4, "PVP70DruidBalance", "spell_nature_starfall", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Balance"]};
				{ 5, "PVP70DruidFeral", "ability_racial_bearform", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Feral"]};
				{ 6, "PVP70DruidRestoration", "spell_nature_healingtouch", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Restoration"]};		
				{ 8, "PVP70Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};		
				{ 10, "PVP70Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};		
				{ 12, "PVP70PaladinHoly", "Spell_Holy_HolyBolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Holy"]};
				{ 13, "PVP70PaladinProtection", "spell_holy_devotionaura", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Protection"]};
				{ 14, "PVP70PaladinRetribution", "Spell_Holy_AuraOfLight", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Retribution"]};		
				{ 17, "PVP70PriestHoly", "spell_holy_powerwordshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Discipline"]};
				{ 18, "PVP70PriestShadow", "spell_shadow_shadowwordpain", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Shadow"]};		
				{ 20, "PVP70Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};		
				{ 22, "PVP70ShamanElemental", "Spell_Nature_Lightning", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Elemental"]};
				{ 23, "PVP70ShamanEnhancement", "spell_nature_lightningshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Enhancement"]};
				{ 24, "PVP70ShamanRestoration", "spell_nature_magicimmunity", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Restoration"]};	
				{ 26, "PVP70WarlockDemonology", "spell_shadow_deathcoil", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], "=q5="..AL["Demonology"]};
				{ 27, "PVP70WarlockDestruction", "spell_shadow_rainoffire", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], "=q5="..AL["Destruction"]};
				{ 29, "PVP70Warrior", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], ""};
			};
		};
		info = {
			name = AL["PvP Armor Sets"]..": "..AL["Level 70"],
			menu = "PVPMENU3",
		};
	}
	
	AtlasLoot_Data["PVP70RepSET"] = {
		["Normal"] = {
			{
				{ 3, "PVP70Rep#2", "ability_druid_maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], ""};
				{ 4, "PVP70Rep", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 5, "PVP70Rep", "inv_staff_30", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], ""};
				{ 6, "PVP70Rep#3", "spell_nature_bloodlust", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], ""};
				{ 7, "PVP70Rep#4", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], ""};
				{ 18, "PVP70Rep#3", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 19, "PVP70Rep#4", "ability_thunderbolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], ""};
				{ 20, "PVP70Rep#2", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 21, "PVP70Rep", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
			};
		};
		info = {
			name = AL["PvP Reputation Sets"]..": "..AL["Level 70"],
			menu = "PVPMENU3",
		};
	}

	AtlasLoot_Data["PVP80NONSETEPICS"] = {
		["Normal"] = {
			{
				{ 2, "PVP80NonSet#1", "INV_Boots_Cloth_12", "=ds="..BabbleInventory["Cloth"], ""};
				{ 3, "PVP80NonSet#3", "INV_Boots_Plate_06", "=ds="..BabbleInventory["Mail"], ""};
				{ 4, "PVP80NonSet#5", "Spell_Frost_SummonWaterElemental", "=ds="..BabbleInventory["Relic"], "" };
				{ 17, "PVP80NonSet#2", "INV_Boots_08", "=ds="..BabbleInventory["Leather"], ""};
				{ 18, "PVP80NonSet#4", "INV_Boots_Plate_04", "=ds="..BabbleInventory["Plate"], ""};
			};
		};
		info = {
			name = AL["PvP Non-Set Epics"],
			menu = "PVPMENU",
		};
	}

	AtlasLoot_Data["PVP80SET"] = {
		["Normal"] = {
			{
				{ 2, "PVP80DeathKnight", "spell_deathknight_classicon", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], ""};
				{ 4, "PVP80DruidBalance", "spell_nature_starfall", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Balance"]};
				{ 5, "PVP80DruidFeral", "ability_racial_bearform", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Feral"]};
				{ 6, "PVP80DruidRestoration", "spell_nature_healingtouch", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Restoration"]};
				{ 8, "PVP80Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 10, "PVP80Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 12, "PVP80PaladinHoly", "Spell_Holy_HolyBolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Holy"]};
				{ 13, "PVP80PaladinRetribution", "Spell_Holy_AuraOfLight", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Retribution"]};
				{ 17, "PVP80PriestHoly", "spell_holy_powerwordshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Discipline"]};
				{ 18, "PVP80PriestShadow", "spell_shadow_shadowwordpain", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Shadow"]};
				{ 20, "PVP80Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 22, "PVP80ShamanElemental", "Spell_Nature_Lightning", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Elemental"]};
				{ 23, "PVP80ShamanEnhancement", "spell_nature_lightningshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Enhancement"]};
				{ 24, "PVP80ShamanRestoration", "spell_nature_magicimmunity", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Restoration"]};
				{ 26, "PVP80Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 28, "PVP80Warrior", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], ""};
			};
		};
		info = {
			name = AL["PvP Armor Sets"]..": "..AL["Level 80"],
			menu = "PVPMENU",
		};
	}

	AtlasLoot_Data["PVP85SET"] = {
		["Normal"] = {
			{
				{ 2, "PVP85DeathKnight", "spell_deathknight_classicon", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], ""};
				{ 4, "PVP85DruidBalance", "spell_nature_starfall", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Balance"]};
				{ 5, "PVP85DruidFeral", "ability_racial_bearform", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Feral"]};
				{ 6, "PVP85DruidRestoration", "spell_nature_healingtouch", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Restoration"]};
				{ 8, "PVP85Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 10, "PVP85Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 12, "PVP85PaladinHoly", "Spell_Holy_HolyBolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Holy"]};
				{ 13, "PVP85PaladinRetribution", "Spell_Holy_AuraOfLight", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Retribution"]};
				{ 17, "PVP85PriestHoly", "spell_holy_powerwordshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"]};
				{ 18, "PVP85PriestShadow", "spell_shadow_shadowwordpain", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"]};
				{ 20, "PVP85Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 22, "PVP85ShamanElemental", "Spell_Nature_Lightning", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Elemental"]};
				{ 23, "PVP85ShamanEnhancement", "spell_nature_lightningshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Enhancement"]};
				{ 24, "PVP85ShamanRestoration", "spell_nature_magicimmunity", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Restoration"]};
				{ 26, "PVP85Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 28, "PVP85Warrior", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], ""};
			};
		};
		info = {
			name = AL["PvP Armor Sets"]..": "..AL["Level 85"],
			menu = "PVPMENU",
		};
	}

	AtlasLoot_Data["WINTERGRASPMENU"] = {
		["Normal"] = {
			{
				{ 2, "LakeWintergrasp#2", "inv_helmet_136", "=ds="..BabbleInventory["Cloth"], ""};
				{ 3, "LakeWintergrasp#3", "INV_Helmet_141", "=ds="..BabbleInventory["Leather"], ""};
				{ 4, "LakeWintergrasp#4", "INV_Helmet_138", "=ds="..BabbleInventory["Mail"], ""};
				{ 5, "LakeWintergrasp#5", "inv_helmet_134", "=ds="..BabbleInventory["Plate"], ""};
				{ 17, "LakeWintergrasp", "inv_misc_rune_11", "=ds="..AL["Accessories"], ""};
				{ 18, "LakeWintergrasp#6", "inv_jewelcrafting_icediamond_02", "=ds="..AL["PVP Gems/Enchants/Jewelcrafting Designs"], ""};
			};
		};
		info = {
			name = BabbleZone["Wintergrasp"],
			menu = "PVPMENU2",
		};
	}
	
	