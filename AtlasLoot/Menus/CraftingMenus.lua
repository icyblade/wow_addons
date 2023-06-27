-- $Id: CraftingMenus.lua 3697 2012-01-31 15:17:37Z lag123 $
-- Invoke libraries
local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");
local BabbleBoss = AtlasLoot_GetLocaleLibBabble("LibBabble-Boss-3.0")
local BabbleInventory = AtlasLoot_GetLocaleLibBabble("LibBabble-Inventory-3.0")
local BabbleItemSet = AtlasLoot_GetLocaleLibBabble("LibBabble-ItemSet-3.0")
local BabbleFaction = AtlasLoot_GetLocaleLibBabble("LibBabble-Faction-3.0")
local BabbleZone = AtlasLoot_GetLocaleLibBabble("LibBabble-Zone-3.0")

-- TEMP FIX REMOVE WITH PATCH/CATA
local GetSpellInfoOri = GetSpellInfo
local function GetSpellInfo(id) local info = GetSpellInfoOri(id) return info or "CATA SPELL" end

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

	AtlasLoot_Data["CRAFTINGMENU"] = {
		["Normal"] = {
			{
				{ 2, "ALCHEMYMENU", "INV_Potion_23", "=ds="..GetSpellInfo(2259), ""};
				{ 3, "SMITHINGMENU", "Trade_BlackSmithing", "=ds="..GetSpellInfo(2018), ""};
				{ 4, "ENCHANTINGMENU", "Trade_Engraving", "=ds="..GetSpellInfo(7411), ""};
				{ 5, "ENGINEERINGMENU", "Trade_Engineering", "=ds="..GetSpellInfo(4036), ""};
				{ 6, "INSCRIPTIONMENU", "INV_Inscription_Tradeskill01", "=ds="..GetSpellInfo(45357), ""};
				{ 7, "JEWELCRAFTINGMENU", "INV_Misc_Gem_01", "=ds="..GetSpellInfo(25229), ""};
				{ 8, "LEATHERWORKINGMENU", "INV_Misc_ArmorKit_17", "=ds="..GetSpellInfo(2108), ""};
				{ 9, "Mining", "Trade_Mining", "=ds="..GetSpellInfo(2575), ""};
				{ 10, "TAILORINGMENU", "Trade_Tailoring", "=ds="..GetSpellInfo(3908), ""};
				{ 12, "ARCHAEOLOGYMENU", "trade_archaeology", "=ds="..GetSpellInfo(78670), ""};
				{ 13, "COOKINGMENU", "INV_Misc_Food_15", "=ds="..GetSpellInfo(2550), ""};
				{ 14, "FirstAid", "Spell_Holy_SealOfSacrifice", "=ds="..GetSpellInfo(3273), ""};
				{ 17, "CRAFTSET", "INV_Box_01", AL["Crafted Sets"], ""};
				{ 18, "CraftedWeapons", "INV_Sword_1H_Blacksmithing_02", AL["Crafted Epic Weapons"], ""};
				{ 20, "COOKINGDAILYMENU", "INV_Misc_Food_15", AL["Cooking Daily"], ""};
				{ 21, "FISHINGDAILYMENU", "inv_fishingpole_03", AL["Fishing Daily"], ""};
				{ 22, "JEWELCRAFTINGDAILYMENU", "INV_Misc_Gem_01", AL["Jewelcrafting Daily"], ""};
			};
		};
		info = {
			name = AL["Crafting"],
		};
	}

	AtlasLoot_Data["ALCHEMYMENU"] = {
		["Normal"] = {
			{
				{ 1, "AlchemyBattleElixir", "inv_alchemy_potion_06", "=ds="..AL["Battle Elixirs"], "" };
				{ 2, "AlchemyGuardianElixir", "inv_potion_164", "=ds="..AL["Guardian Elixirs"], "" };			
				{ 4, "AlchemyFlask", "inv_alchemy_endlessflask_04", "=ds="..AL["Flasks"], "" };
				{ 5, "AlchemyCauldron", "inv_misc_cauldron_fire", "=ds="..AL["Cauldrons"], "" };
				{ 7, "AlchemyPotion", "inv_alchemy_elixir_02", "=ds="..AL["Potions"], "" };
				{ 16, "AlchemyOtherElixir", "inv_potion_112", "=ds="..AL["Other Elixirs"], "" };				
				{ 19, "AlchemyTransmute", "inv_elemental_eternal_air", "=ds="..AL["Transmutes"], "" };				
				{ 20, "AlchemyMisc", "spell_holy_aspiration", "=ds="..BabbleInventory["Miscellaneous"], "" };
				{ 22, "AlchemyOil", "inv_potion_07", "=ds="..AL["Oils"], "" };
			};
		};
		info = {
			name = ALCHEMY,
			menu = "CRAFTINGMENU",
		};
	}

	AtlasLoot_Data["SMITHINGMENU"] = {
		["Normal"] = {
			{
				{ 2, "SmithingArmorCata", "Trade_BlackSmithing", "=ds="..BabbleInventory["Armor"], "=q5="..AL["Cataclysm"] };
				{ 3, "SmithingArmorWrath", "Trade_BlackSmithing", "=ds="..BabbleInventory["Armor"], "=q5="..AL["Wrath of the Lich King"] };
				{ 4, "SmithingArmorBC", "Trade_BlackSmithing", "=ds="..BabbleInventory["Armor"], "=q5="..AL["Burning Crusade"] };
				{ 5, "SmithingArmorOld", "Trade_BlackSmithing", "=ds="..BabbleInventory["Armor"], "=q5="..AL["Classic WoW"] };
				{ 7, "SmithingArmorEnhancement", "inv_titanium_shield_spike", "=ds="..AL["Armor Enhancements"], "" };
				{ 8, "SmithingMisc", "inv_misc_key_07", "=ds="..BabbleInventory["Miscellaneous"], "" };
				{ 10, "Armorsmith", "inv_chest_plate16", "=ds="..GetSpellInfo(9788), "" };
				{ 11, "Axesmith", "inv_axe_1h_blacksmithing_01", "=ds="..GetSpellInfo(17041), "" };
				{ 12, "Swordsmith", "inv_sword_1h_blacksmithing_02", "=ds="..GetSpellInfo(17039), "" };
				{ 14, "SmithingCataVendor", "inv_scroll_04", "=ds="..AL["Cataclysm Vendor Sold Plans"], "=q5="..BabbleZone["Twilight Highlands"] };
				--{ 15, "SmithingArmorRemoved", "Trade_BlackSmithing", "=ds=Removed (Temp Name)", "" };
				{ 17, "SmithingWeaponCata", "Trade_BlackSmithing", "=ds="..AL["Weapons"], "=q5="..AL["Cataclysm"] };
				{ 18, "SmithingWeaponWrath", "Trade_BlackSmithing", "=ds="..AL["Weapons"], "=q5="..AL["Wrath of the Lich King"] };
				{ 19, "SmithingWeaponBC", "Trade_BlackSmithing", "=ds="..AL["Weapons"], "=q5="..AL["Burning Crusade"] };
				{ 20, "SmithingWeaponOld", "Trade_BlackSmithing", "=ds="..AL["Weapons"], "=q5="..AL["Classic WoW"] };
				{ 22, "SmithingWeaponEnhancement", "inv_misc_steelweaponchain", "=ds="..AL["Weapon Enhancements"], "" };
				{ 25, "Weaponsmith", "inv_hammer_21", "=ds="..GetSpellInfo(9787), "" };
				{ 26, "Hammersmith", "inv_hammer_09", "=ds="..GetSpellInfo(17040), "" };
				--{ 30, "SmithingWeaponRemoved", "Trade_BlackSmithing", "=ds=Removed (Temp Name)", "" };
			};
		};
		info = {
			name = BLACKSMITHING,
			menu = "CRAFTINGMENU",
		};
	}

	AtlasLoot_Data["ENCHANTINGMENU"] = {
		["Normal"] = {
			{
				{ 2, "EnchantingBoots", "inv_enchant_formulasuperior_01", "=ds="..AL["Enchant Boots"], "" };
				{ 3, "EnchantingBracer", "Trade_Engraving", "=ds="..AL["Enchant Bracer"], "" };
				{ 4, "EnchantingCloak", "inv_enchant_formulasuperior_01", "=ds="..AL["Enchant Cloak"], "" };
				{ 5, "EnchantingChest", "inv_enchant_formulagood_01", "=ds="..AL["Enchant Chest"], "" };
				{ 6, "EnchantingGloves", "Spell_Holy_GreaterHeal", "=ds="..AL["Enchant Gloves"], "" };
				{ 8, "EnchantingMisc", "inv_rod_enchantedadamantite", "=ds="..BabbleInventory["Miscellaneous"], "" };
				{ 10, "EnchantingCataVendor", "inv_enchant_formulasuperior_01", "=ds="..AL["Cataclysm Vendor Sold Formulas"], "=q5="..BabbleZone["Twilight Highlands"] };
				{ 17, "EnchantingRing", "inv_misc_note_01", "=ds="..AL["Enchant Ring"], "" };
				{ 18, "EnchantingShield", "Spell_Holy_GreaterHeal", "=ds="..AL["Enchant Shield"], "" };
				{ 19, "Enchanting2HWeapon", "Trade_Engraving", "=ds="..AL["Enchant 2H Weapon"], "" };
				{ 20, "EnchantingStaff", "Trade_Engraving", "=ds="..BabbleInventory["Staff"], "" };
				{ 21, "EnchantingWeapon", "Trade_Engraving", "=ds="..AL["Enchant Weapon"], "" };
			};
		};
		info = {
			name = ENCHANTING,
			menu = "CRAFTINGMENU",
		};
	}

	AtlasLoot_Data["ENGINEERINGMENU"] = {
		["Normal"] = {
			{
				{ 2, "EngineeringGem", "inv_gizmo_gnomishflameturret", "=ds="..BabbleInventory["Cogwheel"], "" };
				{ 3, "EngineeringMisc", "inv_pet_lilsmoky", "=ds="..BabbleInventory["Miscellaneous"], "" };
				{ 4, "EngineeringReagents", "inv_misc_enggizmos_27", "=ds="..AL["Reagents"], "" };
				{ 5, "EngineeringScope", "inv_misc_spyglass_02", "=ds="..AL["Scope"], "" };				
				{ 6, "EngineeringWeapon", "inv_weapon_rifle_08", "=ds="..BabbleInventory["Weapon"], "" };				
				{ 8, "Gnomish", "inv_helmet_49", "=ds="..GetSpellInfo(20220), "" };
				{ 10, "EngineeringArmorCloth", "inv_gizmo_newgoggles", "=ds="..BabbleInventory["Armor"], "=q5="..BabbleInventory["Cloth"] };
				{ 11, "EngineeringArmorLeather", "inv_gizmo_newgoggles", "=ds="..BabbleInventory["Armor"], "=q5="..BabbleInventory["Leather"] };
				{ 12, "EngineeringArmor", "spell_arcane_portaldarnassus", "=ds="..BabbleInventory["Armor"], "=q5="..BabbleInventory["Miscellaneous"] };
				{ 17, "EngineeringExplosives", "spell_shadow_mindbomb", "=ds="..BabbleInventory["Explosives"], "" };
				{ 18, "EngineeringPetMount", "inv_misc_key_06", "=ds="..BabbleInventory["Pet"].." & "..BabbleInventory["Mount"], "" };
				{ 19, "EngineeringTinker", "Trade_Engineering", "=ds="..AL["Tinker"], "" };
				{ 20, "EngineeringArmorTrinket", "inv_misc_head_dragon_bronze", "=ds="..BabbleInventory["Trinket"], "" };
				{ 23, "Goblin", "inv_gizmo_supersappercharge", "=ds="..GetSpellInfo(20221), "" };
				{ 25, "EngineeringArmorMail", "inv_gizmo_newgoggles", "=ds="..BabbleInventory["Armor"], "=q5="..BabbleInventory["Mail"] };
				{ 26, "EngineeringArmorPlate", "inv_gizmo_newgoggles", "=ds="..BabbleInventory["Armor"], "=q5="..BabbleInventory["Plate"] };
			};
		};
		info = {
			name = ENGINEERING,
			menu = "CRAFTINGMENU",
		};
	}

	AtlasLoot_Data["INSCRIPTIONMENU"] = {
		["Normal"] = {
			{
				{ 2, "Inscription_RelicsEnchants", "inv_misc_mastersinscription", "=ds="..AL["Relics/Shoulder Enchants"], "" };
				{ 17, "Inscription_OffHand", "inv_misc_book_16", "=ds="..AL["Off-Hand Items"], "" };
				{ 3, "Inscription_Scrolls", "inv_scroll_15", "=ds="..AL["Scrolls"].."/"..AL["Darkmoon Faire Card"], "" };
				{ 18, "Inscription_Misc", "INV_Inscription_Tradeskill01", "=ds="..BabbleInventory["Miscellaneous"], "" };
				{ 5, "Inscription_DeathKnight", "spell_deathknight_classicon", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["Glyph"] };
				{ 20, "Inscription_Druid", "ability_druid_maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Glyph"] };
				{ 6, "Inscription_Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], "=q5="..AL["Glyph"] };
				{ 21, "Inscription_Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], "=q5="..AL["Glyph"] };
				{ 7, "Inscription_Paladin", "ability_thunderbolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Glyph"] };
				{ 22, "Inscription_Priest", "inv_staff_30", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Glyph"] };
				{ 8, "Inscription_Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], "=q5="..AL["Glyph"] };
				{ 23, "Inscription_Shaman", "spell_nature_bloodlust", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Glyph"] };
				{ 9, "Inscription_Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], "=q5="..AL["Glyph"] };
				{ 24, "Inscription_Warrior", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["Glyph"] };
			};
		};
		info = {
			name = INSCRIPTION,
			menu = "CRAFTINGMENU",
		};
	}

	AtlasLoot_Data["JEWELCRAFTINGMENU"] = {
		["Normal"] = {
			{
				{ 1, "JewelRed", "inv_jewelcrafting_gem_37", "=ds="..BabbleInventory["Red"].." "..BabbleInventory["Gem"], "" };
				{ 2, "JewelBlue", "inv_jewelcrafting_gem_42", "=ds="..BabbleInventory["Blue"].." "..BabbleInventory["Gem"], "" };
				{ 3, "JewelYellow", "inv_jewelcrafting_gem_38", "=ds="..BabbleInventory["Yellow"].." "..BabbleInventory["Gem"], "" };
				{ 4, "JewelGreen", "inv_jewelcrafting_gem_41", "=ds="..BabbleInventory["Green"].." "..BabbleInventory["Gem"], "" };
				{ 5, "JewelOrange", "inv_jewelcrafting_gem_39", "=ds="..BabbleInventory["Orange"].." "..BabbleInventory["Gem"], "" };
				{ 6, "JewelPurple", "inv_jewelcrafting_gem_40", "=ds="..BabbleInventory["Purple"].." "..BabbleInventory["Gem"], "" };
				{ 7, "JewelMeta", "inv_jewelcrafting_shadowspirit_02", "=ds="..BabbleInventory["Meta"].." "..BabbleInventory["Gem"], "" };
				{ 8, "JewelPrismatic", "inv_misc_gem_pearl_12", "=ds="..BabbleInventory["Prismatic"].." "..BabbleInventory["Gem"], "" };
				{ 9, "JewelChimerasEye", "inv_jewelcrafting_dragonseye05", "=ds="..AL["Chimera's Eye"], "" };
				{ 10, "JewelDragonsEye", "inv_jewelcrafting_dragonseye05", "=ds="..AL["Dragon's Eye"], "" };
				{ 16, "JewelNeck", "inv_jewelry_necklace_35", "=ds="..BabbleInventory["Neck"], "" };
				{ 17, "JewelTrinket", "inv_jewelcrafting_crimsonhare", "=ds="..BabbleInventory["Trinket"], "" };
				{ 18, "JewelRing", "inv_jewelry_ring_55", "=ds="..BabbleInventory["Ring"], "" };
				{ 19, "JewelMisc", "inv_misc_gem_diamond_02", "=ds="..BabbleInventory["Miscellaneous"], "" };
			};
		};
		info = {
			name = JEWELCRAFTING,
			menu = "CRAFTINGMENU",
		};
	}

	AtlasLoot_Data["LEATHERWORKINGMENU"] = {
		["Normal"] = {
			{
				{ 2, "LeatherLeatherArmorCata", "INV_Misc_ArmorKit_17", "=ds="..AL["Leather Armor"], "=q5="..AL["Cataclysm"] };
				{ 3, "LeatherLeatherArmorWrath", "INV_Misc_ArmorKit_17", "=ds="..AL["Leather Armor"], "=q5="..AL["Wrath of the Lich King"] };
				{ 4, "LeatherLeatherArmorBC", "INV_Misc_ArmorKit_17", "=ds="..AL["Leather Armor"], "=q5="..AL["Burning Crusade"] };
				{ 5, "LeatherLeatherArmorOld", "INV_Misc_ArmorKit_17", "=ds="..AL["Leather Armor"], "=q5="..AL["Classic WoW"] };
				{ 7, "LeatherCloaks", "inv_misc_cape_05", "=ds="..AL["Cloaks"], "" };
				{ 8, "LeatherDrumsBagsMisc", "inv_misc_drum_03", "=ds="..AL["Drums, Bags and Misc."], "" };
				{ 10, "LeatherworkingCataVendor", "inv_scroll_03", "=ds="..AL["Cataclysm Vendor Sold Plans"], "=q5="..BabbleZone["Twilight Highlands"] };
				{ 17, "LeatherMailArmorCata", "INV_Misc_ArmorKit_17", "=ds="..AL["Mail Armor"], "=q5="..AL["Cataclysm"] };
				{ 18, "LeatherMailArmorWrath", "INV_Misc_ArmorKit_17", "=ds="..AL["Mail Armor"], "=q5="..AL["Wrath of the Lich King"] };
				{ 19, "LeatherMailArmorBC", "INV_Misc_ArmorKit_17", "=ds="..AL["Mail Armor"], "=q5="..AL["Burning Crusade"] };
				{ 20, "LeatherMailArmorOld", "INV_Misc_ArmorKit_17", "=ds="..AL["Mail Armor"], "=q5="..AL["Classic WoW"] };
				{ 22, "LeatherItemEnhancement", "inv_misc_armorkit_18", "=ds="..AL["Item Enhancements"], "" };
				{ 23, "LeatherSpecializations", "INV_Misc_ArmorKit_17", "=ds="..AL["Specializations"], "" };
				{ 25, "LeatherLeather", "inv_misc_leatherscrap_10", "=ds="..BabbleInventory["Leather"], "" };
			};
		};
		info = {
			name = LEATHERWORKING,
			menu = "CRAFTINGMENU",
		};
	}

	AtlasLoot_Data["TAILORINGMENU"] = {
		["Normal"] = {
			{
				{ 2, "TailoringArmorCata", "Trade_Tailoring", "=ds="..AL["Cloth Armor"], "=q5="..AL["Cataclysm"] };
				{ 3, "TailoringArmorWotLK", "Trade_Tailoring", "=ds="..AL["Cloth Armor"], "=q5="..AL["Wrath of the Lich King"] };
				{ 4, "TailoringArmorBC", "Trade_Tailoring", "=ds="..AL["Cloth Armor"], "=q5="..AL["Burning Crusade"] };
				{ 5, "TailoringArmorOld", "Trade_Tailoring", "=ds="..AL["Cloth Armor"], "=q5="..AL["Classic WoW"] };
				{ 7, "TailoringItemEnhancement", "inv_misc_thread_01", "=ds="..AL["Item Enhancements"], "" };
				{ 9, "Mooncloth", "Trade_Tailoring", "=ds="..GetSpellInfo(26798), "" };
				{ 10, "Shadoweave", "Trade_Tailoring", "=ds="..GetSpellInfo(26801), "" };
				{ 12, "TailoringCataVendor", "inv_scroll_05", "=ds="..AL["Cataclysm Vendor Sold Plans"], "=q5="..BabbleZone["Twilight Highlands"] };
				{ 17, "TailoringBags", "inv_misc_bag_enchantedrunecloth", "=ds="..AL["Bags"], "" };
				{ 18, "TailoringMisc", "ability_mount_magnificentflyingcarpet", "=ds="..BabbleInventory["Miscellaneous"], "" };
				{ 19, "TailoringShirts", "inv_shirt_white_01", "=ds="..AL["Shirts"], "" };
				{ 20, "TailoringCloth", "inv_fabric_netherweave_bolt", "=ds="..BabbleInventory["Cloth"], "" };
				{ 24, "Spellfire", "Trade_Tailoring", "=ds="..GetSpellInfo(26797), "" };
			};
		};
		info = {
			name = TAILORING,
			menu = "CRAFTINGMENU",
		};
	}

	AtlasLoot_Data["ARCHAEOLOGYMENU"] = {
		["Normal"] = {
			{
				{ 2, "ArchaeologyDwarf", "trade_archaeology_dwarf_runestone", "=ds="..AL["Dwarf"], "" };
				{ 3, "ArchaeologyDraenei", "trade_archaeology_draenei_tome", "=ds="..AL["Draenei"], "" };
				{ 4, "ArchaeologyFossil", "trade_archaeology_dwarf_runestone", "=ds="..AL["Fossil"], "" };
				{ 5, "ArchaeologyNightElf", "trade_archaeology_highborne_scroll", "=ds="..AL["Night Elf"], "" };
				{ 6, "ArchaeologyNerubian", "trade_archaeology_nerubian_obelisk", "=ds="..AL["Nerubian"], "" };
				{ 17, "ArchaeologyOrc", "trade_archaeology_orc_bloodtext", "=ds="..AL["Orc"], "" };
				{ 18, "ArchaeologyTolvir", "trade_archaeology_aqir_artifactfragment", "=ds="..AL["Tol'vir"], "" };
				{ 19, "ArchaeologyTroll", "trade_archaeology_troll_tablet", "=ds="..AL["Troll"], "" };
				{ 20, "ArchaeologyVrykul", "trade_archaeology_vrykul_runestick", "=ds="..AL["Vrykul"], "" };
				{ 8, "ArchaeologyArmorAndWeapons", "trade_archaeology_ancientorcshamanheaddress", "=ds="..BabbleInventory["Armor"].." & "..AL["Weapons"], "" };
				{ 23, "ArchaeologyMisc", "trade_archaeology_theinnkeepersdaughter", "=ds="..BabbleInventory["Miscellaneous"], "" };
				{ 10, "s92137", "60847", "=q4=Crawling Claw", "=ds="..AL["Tol'vir"], "=ds=#e13#"};
				{ 11, "s90521", "64372", "=q3=Clockwork Gnome", "=ds="..AL["Dwarf"], "=ds=#e13#"};
				{ 12, "s89693", "60955", "=q3=Fossilized Hatchling", "=ds="..AL["Fossil"], "=ds=#e13#"};
				{ 13, "s98582", "69821", "=q3=Pterrordax Hatchling", "=ds="..AL["Fossil"], "=ds=#e13#"};
				{ 14, "s98588", "69824", "=q3=Voodoo Figurine", "=ds="..AL["Troll"], "=ds=#e13#"};
				{ 25, "s90619", "60954", "=q4=Fossilized Raptor", "=ds="..AL["Fossil"], "=ds=#e12#"};
				{ 26, "s92148", "64883", "=q4=Scepter of Azj'Aqir", "=ds="..AL["Tol'vir"], "=ds=#e12#"};
			};
		};
		info = {
			name = ARCHAEOLOGY,
			switchText = {AL["Culture"], AL["Slot"]},
			menu = "CRAFTINGMENU",
		};
	}

	AtlasLoot_Data["COOKINGMENU"] = {
		["Normal"] = {
			{
				{ 2, "CookingAgiStrInt", "inv_misc_food_64", "=ds="..AL["Agility, Intellect, Strength"], "" };
				{ 17, "CookingAPSP", "inv_misc_cauldron_frost", "=ds="..AL["Spell/Attack Power"], "" };
				{ 3, "CookingHitCrit", "inv_misc_food_129_fish", "=ds="..AL["Crit/Hit Rating"], "" };
				{ 18, "CookingRating", "inv_misc_food_140_fish", "=ds="..AL["Other Ratings"], "" };
				{ 19, "CookingOtherBuffs", "inv_misc_food_87_sporelingsnack", "=ds="..AL["Other Buffs"], "" };
				{ 6, "CookingSpecial", "inv_valentineschocolate01", "=ds="..AL["Special"], ""};
				{ 21, "CookingStandard", "inv_drink_15", "=ds="..AL["Food without Buffs"], ""};
				{ 4, "CookingBuff", "inv_misc_food_68", "=ds="..AL["Standard Buffs"], "" };
				{ 8, "s88036", "62290", "=q1=Seafood Magnifique Feast", "=ds=#sr# 525", "#ACHIEVEMENTID:5036#"};
				{ 9, "s88011", "62289", "=q1=Broiled Dragon Feast", "=ds=#sr# 500", "#ACHIEVEMENTID:5467#"};
				{ 10, "s57423", "43015", "=q1=Fish Feast", "=ds=#sr# 450", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 11, "s58527", "43478", "=q1=Gigantic Feast", "=ds=#sr# 425", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 12, "s58528", "43480", "=q1=Small Feast", "=ds=#sr# 425", "=ds="..AL["Vendor"]..": "..BabbleZone["Dalaran"]};
				{ 13, "s45554", "34753", "=q1=Great Feast", "=ds=#sr# 375", "=ds="..AL["Trainer"]};
				{ 23, "s88019", "62649", "=q1=Fortune Cookie", "=ds=#sr# 525", "=ds="..AL["Cooking Daily"]};
			};
		};
		info = {
			name = COOKING,
			menu = "CRAFTINGMENU",
		};
	}

	AtlasLoot_Data["CRAFTSET"] = {
		["Normal"] = {
			{
				{ 1, "", "INV_Chest_Plate05", "=q6="..GetSpellInfo(2018), "=q5="..BabbleInventory["Plate"] };
				{ 2, "BlacksmithingPlateImperialPlate", "INV_Belt_01", "=ds="..BabbleItemSet["Imperial Plate"], "" };
				{ 3, "BlacksmithingPlateTheDarksoul", "INV_Shoulder_01", "=ds="..BabbleItemSet["The Darksoul"], "" };
				{ 4, "BlacksmithingPlateFelIronPlate", "INV_Chest_Plate07", "=ds="..BabbleItemSet["Fel Iron Plate"], "" };
				{ 5, "BlacksmithingPlateAdamantiteB", "INV_Gauntlets_30", "=ds="..BabbleItemSet["Adamantite Battlegear"], "" };
				{ 6, "BlacksmithingPlateFlameG", "INV_Helmet_22", "=ds="..BabbleItemSet["Flame Guard"], "=q5="..AL["Fire Resistance Gear"] };
				{ 7, "BlacksmithingPlateEnchantedAdaman", "INV_Belt_29", "=ds="..BabbleItemSet["Enchanted Adamantite Armor"], "=q5="..AL["Arcane Resistance Gear"] };
				{ 8, "BlacksmithingPlateKhoriumWard", "INV_Boots_Chain_01", "=ds="..BabbleItemSet["Khorium Ward"], "" };
				{ 9, "BlacksmithingPlateFaithFelsteel", "INV_Pants_Plate_06", "=ds="..BabbleItemSet["Faith in Felsteel"], "" };
				{ 10, "BlacksmithingPlateBurningRage", "INV_Gauntlets_26", "=ds="..BabbleItemSet["Burning Rage"], "" };
				{ 11, "BlacksmithingPlateOrnateSaroniteBattlegear", "inv_helmet_130", "=ds="..BabbleItemSet["Ornate Saronite Battlegear"], "" };
				{ 12, "BlacksmithingPlateSavageSaroniteBattlegear", "inv_helmet_130", "=ds="..BabbleItemSet["Savage Saronite Battlegear"], "" };
				{ 16, "", "INV_Chest_Chain_04", "=q6="..GetSpellInfo(2018), "=q5="..BabbleInventory["Mail"] };
				{ 17, "BlacksmithingMailBloodsoulEmbrace", "INV_Shoulder_15", "=ds="..BabbleItemSet["Bloodsoul Embrace"], "" };
				{ 18, "BlacksmithingMailFelIronChain", "INV_Helmet_35", "=ds="..BabbleItemSet["Fel Iron Chain"], "" };
				extraText = " : "..BLACKSMITHING
			};
			{
				{ 1, "LeatherworkingLeatherVolcanicArmor", "INV_Pants_06", "=ds="..BabbleItemSet["Volcanic Armor"], "=q5="..AL["Fire Resistance Gear"] };
				{ 2, "LeatherworkingLeatherIronfeatherArmor", "INV_Chest_Leather_06", "=ds="..BabbleItemSet["Ironfeather Armor"], "" };
				{ 3, "LeatherworkingLeatherStormshroudArmor", "INV_Chest_Leather_08", "=ds="..BabbleItemSet["Stormshroud Armor"], "" };
				{ 4, "LeatherworkingLeatherDevilsaurArmor", "INV_Pants_Wolf", "=ds="..BabbleItemSet["Devilsaur Armor"], "" };
				{ 5, "LeatherworkingLeatherBloodTigerH", "INV_Shoulder_23", "=ds="..BabbleItemSet["Blood Tiger Harness"], "" };
				{ 6, "LeatherworkingLeatherPrimalBatskin", "INV_Chest_Leather_03", "=ds="..BabbleItemSet["Primal Batskin"], "" };
				{ 7, "LeatherworkingLeatherWildDraenishA", "INV_Pants_Leather_07", "=ds="..BabbleItemSet["Wild Draenish Armor"], "" };
				{ 8, "LeatherworkingLeatherThickDraenicA", "INV_Boots_Chain_01", "=ds="..BabbleItemSet["Thick Draenic Armor"], "" };
				{ 9, "LeatherworkingLeatherFelSkin", "INV_Gauntlets_22", "=ds="..BabbleItemSet["Fel Skin"], "" };
				{ 10, "LeatherworkingLeatherSClefthoof", "INV_Boots_07", "=ds="..BabbleItemSet["Strength of the Clefthoof"], "" };
				{ 11, "LeatherworkingLeatherPrimalIntent", "INV_Chest_Cloth_45", "=ds="..BabbleItemSet["Primal Intent"], "=q5="..GetSpellInfo(10658) };
				{ 12, "LeatherworkingLeatherWindhawkArmor", "INV_Chest_Leather_01", "=ds="..BabbleItemSet["Windhawk Armor"], "=q5="..GetSpellInfo(10660) };
				{ 16, "LeatherworkingLeatherBoreanEmbrace", "inv_helmet_110", "=ds="..BabbleItemSet["Borean Embrace"], "" };
				{ 17, "LeatherworkingLeatherIceborneEmbrace", "inv_chest_fur", "=ds="..BabbleItemSet["Iceborne Embrace"], "" };
				{ 18, "LeatherworkingLeatherEvisceratorBattlegear", "inv_helmet_04", "=ds="..BabbleItemSet["Eviscerator's Battlegear"], "" };
				{ 19, "LeatherworkingLeatherOvercasterBattlegear", "inv_pants_leather_09", "=ds="..BabbleItemSet["Overcaster Battlegear"], "" };	
				extraText = " : "..LEATHERWORKING				
			};
			{
				{ 1, "LeatherworkingMailGreenDragonM", "INV_Pants_05", "=ds="..BabbleItemSet["Green Dragon Mail"], "=q5="..AL["Nature Resistance Gear"] };
				{ 2, "LeatherworkingMailBlueDragonM", "INV_Chest_Chain_04", "=ds="..BabbleItemSet["Blue Dragon Mail"], "=q5="..AL["Arcane Resistance Gear"] };
				{ 3, "LeatherworkingMailBlackDragonM", "INV_Pants_03", "=ds="..BabbleItemSet["Black Dragon Mail"], "=q5="..AL["Fire Resistance Gear"] };
				{ 4, "LeatherworkingMailScaledDraenicA", "INV_Pants_Mail_07", "=ds="..BabbleItemSet["Scaled Draenic Armor"], "" };
				{ 5, "LeatherworkingMailFelscaleArmor", "INV_Boots_Chain_08", "=ds="..BabbleItemSet["Felscale Armor"], "" };
				{ 6, "LeatherworkingMailFelstalkerArmor", "INV_Belt_13", "=ds="..BabbleItemSet["Felstalker Armor"], "" };
				{ 7, "LeatherworkingMailNetherFury", "INV_Pants_Plate_12", "=ds="..BabbleItemSet["Fury of the Nether"], "" };
				{ 8, "LeatherworkingMailNetherscaleArmor", "INV_Belt_29", "=ds="..BabbleItemSet["Netherscale Armor"], "=q5="..GetSpellInfo(10656) };
				{ 9, "LeatherworkingMailNetherstrikeArmor", "INV_Belt_03", "=ds="..BabbleItemSet["Netherstrike Armor"], "=q5="..GetSpellInfo(10656) };
				{ 16, "LeatherworkingMailFrostscaleBinding", "inv_chest_chain_13", "=ds="..BabbleItemSet["Frostscale Binding"], "" };
				{ 17, "LeatherworkingMailNerubianHive", "inv_helmet_110", "=ds="..BabbleItemSet["Nerubian Hive"], "" };
				{ 18, "LeatherworkingMailStormhideBattlegear", "inv_pants_mail_18", "=ds="..BabbleItemSet["Stormhide Battlegear"], "" };
				{ 19, "LeatherworkingMailSwiftarrowBattlefear", "inv_belt_19", "=ds="..BabbleItemSet["Swiftarrow Battlegear"], "" };	
				extraText = " : "..LEATHERWORKING
			};
			{
				{ 1, "TailoringBloodvineG", "INV_Pants_Cloth_14", "=ds="..BabbleItemSet["Bloodvine Garb"], "" };
				{ 2, "TailoringNeatherVest", "INV_Chest_Cloth_29", "=ds="..BabbleItemSet["Netherweave Vestments"], "" };
				{ 3, "TailoringImbuedNeather", "INV_Pants_Leather_09", "=ds="..BabbleItemSet["Imbued Netherweave"], "" };
				{ 4, "TailoringArcanoVest", "INV_Chest_Cloth_01", "=ds="..BabbleItemSet["Arcanoweave Vestments"], "=q5="..AL["Arcane Resistance Gear"] };
				{ 5, "TailoringTheUnyielding", "INV_Belt_03", "=ds="..BabbleItemSet["The Unyielding"], "" };
				{ 6, "TailoringWhitemendWis", "INV_Helmet_53", "=ds="..BabbleItemSet["Whitemend Wisdom"], "" };
				{ 7, "TailoringSpellstrikeInfu", "INV_Pants_Cloth_14", "=ds="..BabbleItemSet["Spellstrike Infusion"], "" };
				{ 8, "TailoringBattlecastG", "INV_Helmet_70", "=ds="..BabbleItemSet["Battlecast Garb"], "" };
				{ 9, "TailoringSoulclothEm", "INV_Chest_Cloth_12", "=ds="..BabbleItemSet["Soulcloth Embrace"], "=q5="..AL["Arcane Resistance Gear"] };
				{ 10, "TailoringPrimalMoon", "INV_Chest_Cloth_04", "=ds="..BabbleItemSet["Primal Mooncloth"], "=q5="..GetSpellInfo(26798) };
				{ 11, "TailoringShadowEmbrace", "INV_Shoulder_25", "=ds="..BabbleItemSet["Shadow's Embrace"], "=q5="..GetSpellInfo(26801) };
				{ 12, "TailoringSpellfireWrath", "INV_Gauntlets_19", "=ds="..BabbleItemSet["Wrath of Spellfire"], "=q5="..GetSpellInfo(26797) };
				{ 16, "TailoringFrostwovenPower", "inv_belt_29", "=ds="..BabbleItemSet["Frostwoven Power"], "" };
				{ 17, "TailoringDuskweaver", "inv_chest_cloth_19", "=ds="..BabbleItemSet["Frostsavage Battlegear"], "" };
				{ 18, "TailoringFrostsavageBattlegear", "inv_helmet_125", "=ds="..BabbleItemSet["Battlecast Garb"], "" };
				extraText = " : "..TAILORING
			};
		};
		info = {
			name = AL["Crafted Sets"],
			menu = "CRAFTINGMENU",
		};
	}
	
	AtlasLoot_Data["COOKINGDAILYMENU"] = {
		["Normal"] = {
			{
				{ 2, "CookingDaily#1", "inv_misc_food_meat_cooked_09", "=ds="..BabbleZone["Stormwind"] .." / "..BabbleZone["Orgrimmar"], "=q5="..AL["Cataclysm"] };
				{ 4, 62786, "", "=q1=Cocoa Beans", "=ds=#e8#", "10 #silver#"};
				{ 5, 65513, "", "=q1=Crate of Tasty Meat", "=ds=#m20#", "#CHEFAWARD:2#"};
				{ 8, "CookingDaily#3", "inv_misc_cauldron_arcane", "=ds="..BabbleZone["Shattrath"], "=q5="..AL["Burning Crusade"] };
				{ 17, "CookingDaily#2", "inv_misc_food_12", "=ds="..BabbleZone["Dalaran"], "=q5="..AL["Wrath of the Lich King"] };
				{ 19, 46349, "", "=q3=Chef's Hat", "=ds=#s1#", "#DALARANCK:100#"};
				{ 20, 43007, "", "=q1=Northern Spices", "=ds=#e8#", "#DALARANCK:1#"};
			};
		};
		info = {
			name = AL["Cooking Daily"],
			menu = "CRAFTINGMENU",
		};
	}

	AtlasLoot_Data["FISHINGDAILYMENU"] = {
		["Normal"] = {
			{
				{ 2, "FishingDaily#1", "inv_fishingpole_03", "=ds="..BabbleZone["Dalaran"], "=q5="..AL["Wrath of the Lich King"] };
				{ 4, 33820, "", "=q3=Weather-Beaten Fishing Hat", "=ds=#s1#, #a1#", "", ""};
				{ 5, 45991, "", "=q3=Bone Fishing Pole", "=ds=#e20#", "", ""};
				{ 6, 45992, "", "=q3=Jeweled Fishing Pole", "=ds=#e20#", "", ""};
				{ 7, 44983, "", "=q3=Strand Crawler", "=ds=#e13#", "", ""};
				{ 17, "FishingDaily#2", "achievement_profession_fishing_oldmanbarlowned", "=ds="..BabbleZone["Terokkar Forest"], "=q5="..AL["Burning Crusade"] };
				{ 19, 34834, "", "=q2=Recipe: Captain Rumsey's Lager", "=ds=#sr# (100)", "", ""};
				{ 21, 67404, "", "=q1=Glass Fishing Bobber", "=ds=#e24#", "", ""};
				{ 22, 34109, "", "=q1=Weather-Beaten Journal", "=ds=#e10#", "", ""};
			};
		};
		info = {
			name = AL["Fishing Daily"],
			menu = "CRAFTINGMENU",
		};
	}

	AtlasLoot_Data["JEWELCRAFTINGDAILYMENU"] = {
		["Normal"] = {
			{
				{ 2, "JewelcraftingDailyRed", "inv_jewelcrafting_gem_32", "=ds="..BabbleInventory["Red"].." "..BabbleInventory["Gem"], "=q5="..AL["Wrath of the Lich King"] };
				{ 3, "JewelcraftingDailyYellow", "inv_jewelcrafting_gem_36", "=ds="..BabbleInventory["Yellow"].." "..BabbleInventory["Gem"], "=q5="..AL["Wrath of the Lich King"] };
				{ 4, "JewelcraftingDailyGreen", "inv_jewelcrafting_gem_34", "=ds="..BabbleInventory["Green"].." "..BabbleInventory["Gem"], "=q5="..AL["Wrath of the Lich King"] };
				{ 5, "JewelcraftingDailyBlue", "inv_jewelcrafting_gem_35", "=ds="..BabbleInventory["Blue"].." "..BabbleInventory["Gem"], "=q5="..AL["Wrath of the Lich King"] };
				{ 6, "JewelcraftingDailyMeta", "inv_jewelcrafting_icediamond_01", "=ds="..BabbleInventory["Meta"].." "..BabbleInventory["Gem"], "=q5="..AL["Wrath of the Lich King"] };
				{ 17, "JewelcraftingDailyOrange", "inv_jewelcrafting_gem_33", "=ds="..BabbleInventory["Orange"].." "..BabbleInventory["Gem"], "=q5="..AL["Wrath of the Lich King"] };
				{ 18, "JewelcraftingDailyPurple", "inv_jewelcrafting_gem_31", "=ds="..BabbleInventory["Purple"].." "..BabbleInventory["Gem"], "=q5="..AL["Wrath of the Lich King"] };
				{ 19, "JewelcraftingDailyDragonEye", "inv_jewelcrafting_dragonseye01", "=ds="..AL["Dragon's Eye"], "=q5="..AL["Wrath of the Lich King"] };
				{ 20, "JewelcraftingDailyNeckRing", "inv_jewelry_necklace_14", "=ds="..BabbleInventory["Neck"].." / "..BabbleInventory["Ring"], "=q5="..AL["Wrath of the Lich King"] };
				{ 21, "JewelcraftingDailyRemoved", "inv_jewelcrafting_dragonseye01", "=ds="..BabbleInventory["Gem"], "=q5="..AL["Wrath of the Lich King"] };
			};
		};
		info = {
			name = AL["Jewelcrafting Daily"],
			menu = "CRAFTINGMENU",
		};
	}

    --Please don't delete EmptyTable, it is needed as it is certain to load
    --even if no loot modules have loaded
	AtlasLoot_Data["EmptyTable"] = {
	};
