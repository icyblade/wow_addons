-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- general static data tables

local TSM = select(2, ...)
TSM.STATIC_DATA = {}
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster")
local WEAPON, ARMOR = GetAuctionItemClasses()



-- ============================================================================
-- Vendor-Bought Items / Costs
-- ============================================================================

TSM.STATIC_DATA.preloadedVendorCosts = {
	["i:80433"] = 2000000, -- Blood Spirit
	["i:83092"] = 200000000, -- Orb of Mystery
	["i:65893"] = 30000000, -- Sands of Time
	["i:58265"] = 20000, -- Highland Pomegranate
	["i:65892"] = 50000000, -- Pyrium-Laced Crystalline Vial
	["i:67319"] = 328990, -- Preserved Ogre Eye
	["i:67335"] = 445561, -- Silver Charm Bracelet
	["i:74659"] = 30000, -- Farm Chicken
	["i:74660"] = 15000, -- Pandaren Peach
	["i:74832"] = 12000, -- Barley
	["i:74845"] = 35000, -- Ginseng
	["i:74851"] = 14000, -- Rice
	["i:74852"] = 16000, -- Yak Milk
	["i:74854"] = 7000, -- Instant Noodles
	["i:85583"] = 12000, -- Needle Mushrooms
	["i:85584"] = 17000, -- Silkworm Pupa
	["i:85585"] = 27000, -- Red Beans
	["i:102539"] = 5000, -- Fresh Strawberries
	["i:102540"] = 5000, -- Fresh Mangos
	["i:52188"] = 15000, -- Jeweler's Setting
	["i:62323"] = 60000, -- Deathwing Scale Fragment
	["i:43102"] = 750000, -- Frozen Orb
	["i:44499"] = 30000000, -- Salvaged Iron Golem Parts
	["i:44500"] = 15000000, -- Elementium-Plated Exhaust Pipe
	["i:44501"] = 10000000, -- Goblin-Machined Piston
	["i:45087"] = 1000000, -- Runed Orb
	["i:47556"] = 1250000, -- Crusader Orb
	["i:49908"] = 1500000, -- Primordial Saronite
	["i:40533"] = 50000, -- Walnut Stock
	["i:30183"] = 700000, -- Nether Vortex
	["i:35948"] = 16000, -- Savory Snowplum
	["i:58278"] = 16000, -- Tropical Sunfruit
	["i:39684"] = 9000, -- Hair Trigger
	["i:34249"] = 1000000, -- Hula Girl Doll
	["i:38426"] = 30000, -- Eternium Thread
	["i:23572"] = 500000, -- Primal Nether
	["i:27860"] = 6400, -- Purified Draenic Water
	["i:35949"] = 8500, -- Tundra Berries
	["i:18567"] = 30000, -- Elemental Flux
	["i:90146"] = 20000, -- Tinker's Kit
	["i:4342"] = 2500, -- Purple Dye
	["i:10290"] = 2500, -- Pink Dye
	["i:10647"] = 2000, -- Engineer's Ink
	["i:14341"] = 5000, -- Rune Thread
	["i:34412"] = 1000, -- Sparkling Apple Cider
	["i:2325"] = 1000, -- Black Dye
	["i:8343"] = 2000, -- Heavy Silken Thread
	["i:2595"] = 2000, -- Jug of Badlands Bourbon
	["i:6261"] = 1000, -- Orange Dye
	["i:3857"] = 500, -- Coal
	["i:4291"] = 500, -- Silken Thread
	["i:11291"] = 4500, -- Star Wood
	["i:2594"] = 1500, -- Flagon of Dwarven Mead
	["i:3466"] = 2000, -- Strong Flux
	["i:4340"] = 350, -- Gray Dye
	["i:4341"] = 500, -- Yellow Dye
	["i:4400"] = 2000, -- Heavy Stock
	["i:2321"] = 100, -- Fine Thread
	["i:6530"] = 100, -- Nightcrawlers
	["i:2593"] = 150, -- Flask of Stormwind Tawny
	["i:2596"] = 120, -- Skin of Dwarven Stout
	["i:2605"] = 100, -- Green Dye
	["i:2604"] = 50, -- Red Dye
	["i:4289"] = 50, -- Salt
	["i:4399"] = 200, -- Wooden Stock
	["i:6260"] = 50, -- Blue Dye
	["i:1179"] = 125, -- Ice Cold Milk
	["i:2320"] = 10, -- Coarse Thread
	["i:2324"] = 25, -- Bleach
	["i:2678"] = 10, -- Mild Spices
	["i:2880"] = 100, -- Weak Flux
	["i:4470"] = 38, -- Simple Wood
	["i:4537"] = 125, -- Tel'Abim Banana
	["i:6217"] = 124, -- Copper Rod
	["i:17194"] = 10, -- Holiday Spices
	["i:17202"] = 10, -- Snowball
	["i:30817"] = 25, -- Simple Flour
	["i:44835"] = 10, -- Autumnal Herbs
	["i:2901"] = 81, -- Mining Pick
	["i:7005"] = 82, -- Skinning Knife
	["i:159"] = 25, -- Refreshing Spring Water
	["i:3371"] = 100, -- Crystal Vial
	["i:5956"] = 18, -- Blacksmith Hammer
	["i:17196"] = 50, -- Holiday Spirits
	["i:39354"] = 15, -- Light Parchment
	["i:44853"] = 25, -- Honey
	["i:44854"] = 25, -- Tangy Wetland Cranberries
	["i:44855"] = 25, -- Teldrassil Sweet Potato
	["i:46784"] = 25, -- Ripe Elwynn Pumpkin
	["i:46793"] = 25, -- Tangy Southfury Cranberries
	["i:46796"] = 25, -- Ripe Tirisfal Pumpkin
	["i:46797"] = 25, -- Mulgore Sweet Potato
	["i:79740"] = 23, -- Plain Wooden Staff
}



-- ============================================================================
-- Soulbound Crafting Mats
-- ============================================================================

TSM.STATIC_DATA.soulboundMats = {
	["i:79731"] = true, -- Scroll of Wisdom
	["i:82447"] = true, -- Imperial Silk
	["i:54440"] = true, -- Dreamcloth
	["i:94111"] = true, -- Lightning Steel Ingot
	["i:94113"] = true, -- Jard's Peculiar Energy Source
	["i:98717"] = true, -- Balanced Trillium Ingot
	["i:98619"] = true, -- Celestial Cloth
	["i:98617"] = true, -- Hardened Magnificent Hide
	["i:108257"] = true, -- Truesteel Ingot
	["i:108995"] = true, -- Metamorphic Crystal
	["i:110611"] = true, -- Burnished Leather
	["i:111366"] = true, -- Gearspring Parts
	["i:111556"] = true, -- Hexweave Cloth
	["i:112377"] = true, -- War Paints
	["i:115524"] = true, -- Taladite Crystal
	["i:120945"] = true, -- Primal Spirit
}



-- ============================================================================
-- Non-Disenchantable Items
-- ============================================================================

-- URLs for non-disenchantable items:
-- 	http://www.wowhead.com/items=2?filter=qu=2%3A3%3A4%3Bcr=8%3A2%3Bcrs=2%3A2%3Bcrv=0%3A0
-- 	http://www.wowhead.com/items=4?filter=qu=2%3A3%3A4%3Bcr=8%3A2%3Bcrs=2%3A2%3Bcrv=0%3A0
TSM.STATIC_DATA.notDisenchantable = {
	["i:11290"] = true,
	["i:11289"] = true,
	["i:11288"] = true,
	["i:11287"] = true,
	["i:60223"] = true,
	["i:52252"] = true,
	["i:20406"] = true,
	["i:20407"] = true,
	["i:20408"] = true,
	["i:21766"] = true,
	["i:52485"] = true,
	["i:52486"] = true,
	["i:52487"] = true,
	["i:52488"] = true,
	["i:75274"] = true,
	["i:97826"] = true,
	["i:97827"] = true,
	["i:97828"] = true,
	["i:97829"] = true,
	["i:97830"] = true,
	["i:97831"] = true,
	["i:97832"] = true,
	["i:109262"] = true,
}



-- ============================================================================
-- Disenchanting Ratios
-- ============================================================================

TSM.STATIC_DATA.disenchantInfo = {
	{
		desc = L["Dust"],
		["i:10940"] = { -- Strange Dust
			minLevel = 0,
			maxLevel = 24,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 5, maxItemLevel = 15, amountOfMats = 1.2},
				{itemType = ARMOR, rarity = 2, minItemLevel = 16, maxItemLevel = 20, amountOfMats = 1.875},
				{itemType = ARMOR, rarity = 2, minItemLevel = 21, maxItemLevel = 25, amountOfMats = 3.75},
				{itemType = WEAPON, rarity = 2, minItemLevel = 5, maxItemLevel = 15, amountOfMats = 0.3},
				{itemType = WEAPON, rarity = 2, minItemLevel = 16, maxItemLevel = 20, amountOfMats = 0.5},
				{itemType = WEAPON, rarity = 2, minItemLevel = 21, maxItemLevel = 25, amountOfMats = 0.75},
			},
		},
		["i:11083"] = { -- Soul Dust
			minLevel = 20,
			maxLevel = 30,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 26, maxItemLevel = 30, amountOfMats = 1.125},
				{itemType = ARMOR, rarity = 2, minItemLevel = 31, maxItemLevel = 35, amountOfMats = 2.625},
				{itemType = WEAPON, rarity = 2, minItemLevel = 26, maxItemLevel = 30, amountOfMats = 0.3},
				{itemType = WEAPON, rarity = 2, minItemLevel = 31, maxItemLevel = 35, amountOfMats = 0.7},
			},
		},
		["i:11137"] = { -- Vision Dust
			minLevel = 30,
			maxLevel = 40,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 36, maxItemLevel = 40, amountOfMats = 1.125},
				{itemType = ARMOR, rarity = 2, minItemLevel = 41, maxItemLevel = 45, amountOfMats = 2.625},
				{itemType = WEAPON, rarity = 2, minItemLevel = 36, maxItemLevel = 40, amountOfMats = 0.3},
				{itemType = WEAPON, rarity = 2, minItemLevel = 41, maxItemLevel = 45, amountOfMats = 0.7},
			},
		},
		["i:11176"] = { -- Dream Dust
			minLevel = 41,
			maxLevel = 50,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 46, maxItemLevel = 50, amountOfMats = 1.125},
				{itemType = ARMOR, rarity = 2, minItemLevel = 51, maxItemLevel = 55, amountOfMats = 2.625},
				{itemType = WEAPON, rarity = 2, minItemLevel = 46, maxItemLevel = 50, amountOfMats = 0.3},
				{itemType = WEAPON, rarity = 2, minItemLevel = 51, maxItemLevel = 55, amountOfMats = 0.77},
			},
		},
		["i:16204"] = { -- Illusion Dust
			minLevel = 51,
			maxLevel = 60,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 56, maxItemLevel = 60, amountOfMats = 1.125},
				{itemType = ARMOR, rarity = 2, minItemLevel = 61, maxItemLevel = 65, amountOfMats = 2.625},
				{itemType = WEAPON, rarity = 2, minItemLevel = 56, maxItemLevel = 60, amountOfMats = 0.33},
				{itemType = WEAPON, rarity = 2, minItemLevel = 61, maxItemLevel = 65, amountOfMats = 0.77},
			},
		},
		["i:22445"] = { -- Arcane Dust
			minLevel = 57,
			maxLevel = 70,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 79, maxItemLevel = 79, amountOfMats = 1.5},
				{itemType = ARMOR, rarity = 2, minItemLevel = 80, maxItemLevel = 99, amountOfMats = 1.875},
				{itemType = ARMOR, rarity = 2, minItemLevel = 100, maxItemLevel = 120, amountOfMats = 2.625},
				{itemType = WEAPON, rarity = 2, minItemLevel = 80, maxItemLevel = 99, amountOfMats = 0.55},
				{itemType = WEAPON, rarity = 2, minItemLevel = 100, maxItemLevel = 120, amountOfMats = 0.77},
			},
		},
		["i:34054"] = { -- Infinite Dust
			minLevel = 67,
			maxLevel = 80,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 130, maxItemLevel = 151, amountOfMats = 1.5},
				{itemType = ARMOR, rarity = 2, minItemLevel = 152, maxItemLevel = 200, amountOfMats = 3.375},
				{itemType = WEAPON, rarity = 2, minItemLevel = 130, maxItemLevel = 151, amountOfMats = 0.55},
				{itemType = WEAPON, rarity = 2, minItemLevel = 152, maxItemLevel = 200, amountOfMats = 1.1},
			},
		},
		["i:52555"] = { -- Hypnotic Dust
			minLevel = 77,
			maxLevel = 85,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 272, maxItemLevel = 275, amountOfMats = 1.125},
				{itemType = ARMOR, rarity = 2, minItemLevel = 276, maxItemLevel = 290, amountOfMats = 1.5},
				{itemType = ARMOR, rarity = 2, minItemLevel = 291, maxItemLevel = 305, amountOfMats = 1.875},
				{itemType = ARMOR, rarity = 2, minItemLevel = 306, maxItemLevel = 315, amountOfMats = 2.25},
				{itemType = ARMOR, rarity = 2, minItemLevel = 316, maxItemLevel = 325, amountOfMats = 2.625},
				{itemType = ARMOR, rarity = 2, minItemLevel = 326, maxItemLevel = 350, amountOfMats = 3},
				{itemType = WEAPON, rarity = 2, minItemLevel = 272, maxItemLevel = 275, amountOfMats = 0.375},
				{itemType = WEAPON, rarity = 2, minItemLevel = 276, maxItemLevel = 290, amountOfMats = 0.5},
				{itemType = WEAPON, rarity = 2, minItemLevel = 291, maxItemLevel = 305, amountOfMats = 0.625},
				{itemType = WEAPON, rarity = 2, minItemLevel = 306, maxItemLevel = 315, amountOfMats = 0.75},
				{itemType = WEAPON, rarity = 2, minItemLevel = 316, maxItemLevel = 325, amountOfMats = 0.875},
				{itemType = WEAPON, rarity = 2, minItemLevel = 326, maxItemLevel = 350, amountOfMats = 1},
			},
		},
		["i:74249"] = { -- Spirit Dust
			minLevel = 83,
			maxLevel = 88,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 364, maxItemLevel = 390, amountOfMats = 2.125},
				{itemType = ARMOR, rarity = 2, minItemLevel = 391, maxItemLevel = 410, amountOfMats = 2.55},
				{itemType = ARMOR, rarity = 2, minItemLevel = 411, maxItemLevel = 450, amountOfMats = 3.4},
				{itemType = WEAPON, rarity = 2, minItemLevel = 364, maxItemLevel = 390, amountOfMats = 2.125},
				{itemType = WEAPON, rarity = 2, minItemLevel = 391, maxItemLevel = 410, amountOfMats = 2.55},
				{itemType = WEAPON, rarity = 2, minItemLevel = 411, maxItemLevel = 450, amountOfMats = 3.4},
			},
		},
		["i:109693"] = { -- Draenic Dust
			minLevel = 90,
			maxLevel = 100,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 483, maxItemLevel = 593, amountOfMats = 2.125},
				{itemType = ARMOR, rarity = 3, minItemLevel = 505, maxItemLevel = 593, amountOfMats = 8.1},
				{itemType = ARMOR, rarity = 3, minItemLevel = 594, maxItemLevel = 680, amountOfMats = 12},
				{itemType = WEAPON, rarity = 2, minItemLevel = 483, maxItemLevel = 593, amountOfMats = 2.125},
				{itemType = WEAPON, rarity = 3, minItemLevel = 505, maxItemLevel = 593, amountOfMats = 8.1},
				{itemType = WEAPON, rarity = 3, minItemLevel = 594, maxItemLevel = 680, amountOfMats = 12},
			},
		},
	},
	{
		desc = L["Essences"],
		["i:10939"] = { -- Greater Magic Essence
			minLevel = 1,
			maxLevel = 15,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 5, maxItemLevel = 15, amountOfMats = 0.1},
				{itemType = ARMOR, rarity = 2, minItemLevel = 16, maxItemLevel = 20, amountOfMats = 0.3},
				{itemType = WEAPON, rarity = 2, minItemLevel = 5, maxItemLevel = 15, amountOfMats = 0.4},
				{itemType = WEAPON, rarity = 2, minItemLevel = 16, maxItemLevel = 20, amountOfMats = 1.125},
			},
		},
		["i:11082"] = { -- Greater Astral Essence
			minLevel = 16,
			maxLevel = 25,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 21, maxItemLevel = 25, amountOfMats = .075},
				{itemType = ARMOR, rarity = 2, minItemLevel = 26, maxItemLevel = 30, amountOfMats = 0.3},
				{itemType = WEAPON, rarity = 2, minItemLevel = 21, maxItemLevel = 25, amountOfMats = 0.375},
				{itemType = WEAPON, rarity = 2, minItemLevel = 26, maxItemLevel = 30, amountOfMats = 1.125},
			},
		},
		["i:11135"] = { -- Greater Mystic Essence
			minLevel = 26,
			maxLevel = 35,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 31, maxItemLevel = 35, amountOfMats = 0.1},
				{itemType = ARMOR, rarity = 2, minItemLevel = 36, maxItemLevel = 40, amountOfMats = 0.3},
				{itemType = WEAPON, rarity = 2, minItemLevel = 31, maxItemLevel = 35, amountOfMats = 0.375},
				{itemType = WEAPON, rarity = 2, minItemLevel = 36, maxItemLevel = 40, amountOfMats = 1.125},
			},
		},
		["i:11175"] = { -- Greater Nether Essence
			minLevel = 36,
			maxLevel = 45,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 41, maxItemLevel = 45, amountOfMats = 0.1},
				{itemType = ARMOR, rarity = 2, minItemLevel = 46, maxItemLevel = 50, amountOfMats = 0.3},
				{itemType = WEAPON, rarity = 2, minItemLevel = 41, maxItemLevel = 45, amountOfMats = 0.375},
				{itemType = WEAPON, rarity = 2, minItemLevel = 46, maxItemLevel = 50, amountOfMats = 1.125},
			},
		},
		["i:16203"] = { -- Greater Eternal Essence
			minLevel = 46,
			maxLevel = 60,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 51, maxItemLevel = 55, amountOfMats = 0.1},
				{itemType = ARMOR, rarity = 2, minItemLevel = 56, maxItemLevel = 60, amountOfMats = 0.3},
				{itemType = ARMOR, rarity = 2, minItemLevel = 61, maxItemLevel = 65, amountOfMats = 0.5},
				{itemType = WEAPON, rarity = 2, minItemLevel = 51, maxItemLevel = 55, amountOfMats = 0.375},
				{itemType = WEAPON, rarity = 2, minItemLevel = 56, maxItemLevel = 60, amountOfMats = 0.125},
				{itemType = WEAPON, rarity = 2, minItemLevel = 61, maxItemLevel = 65, amountOfMats = 1.875},
			},
		},
		["i:22446"] = { -- Greater Planar Essence
			minLevel = 58,
			maxLevel = 70,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 66, maxItemLevel = 99, amountOfMats = 0.167},
				{itemType = ARMOR, rarity = 2, minItemLevel = 100, maxItemLevel = 120, amountOfMats = 0.3},
				{itemType = WEAPON, rarity = 2, minItemLevel = 79, maxItemLevel = 79, amountOfMats = 0.625},
				{itemType = WEAPON, rarity = 2, minItemLevel = 80, maxItemLevel = 99, amountOfMats = 0.625},
				{itemType = WEAPON, rarity = 2, minItemLevel = 100, maxItemLevel = 120, amountOfMats = 1.125},
			},
		},
		["i:34055"] = { -- Greater Cosmic Essence
			minLevel = 67,
			maxLevel = 80,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 130, maxItemLevel = 151, amountOfMats = 0.1},
				{itemType = ARMOR, rarity = 2, minItemLevel = 152, maxItemLevel = 200, amountOfMats = 0.3},
				{itemType = WEAPON, rarity = 2, minItemLevel = 130, maxItemLevel = 151, amountOfMats = 0.375},
				{itemType = WEAPON, rarity = 2, minItemLevel = 152, maxItemLevel = 200, amountOfMats = 1.125},
			},
		},
		["i:52719"] = { -- Greater Celestial Essence
			minLevel = 77,
			maxLevel = 85,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 201, maxItemLevel = 275, amountOfMats = 0.125},
				{itemType = ARMOR, rarity = 2, minItemLevel = 276, maxItemLevel = 290, amountOfMats = 0.167},
				{itemType = ARMOR, rarity = 2, minItemLevel = 291, maxItemLevel = 305, amountOfMats = 0.208},
				{itemType = ARMOR, rarity = 2, minItemLevel = 306, maxItemLevel = 315, amountOfMats = 0.375},
				{itemType = ARMOR, rarity = 2, minItemLevel = 316, maxItemLevel = 325, amountOfMats = 0.625},
				{itemType = ARMOR, rarity = 2, minItemLevel = 326, maxItemLevel = 350, amountOfMats = 0.75},
				{itemType = WEAPON, rarity = 2, minItemLevel = 201, maxItemLevel = 275, amountOfMats = 0.375},
				{itemType = WEAPON, rarity = 2, minItemLevel = 276, maxItemLevel = 290, amountOfMats = 0.5},
				{itemType = WEAPON, rarity = 2, minItemLevel = 291, maxItemLevel = 305, amountOfMats = 0.625},
				{itemType = WEAPON, rarity = 2, minItemLevel = 306, maxItemLevel = 315, amountOfMats = 1.125},
				{itemType = WEAPON, rarity = 2, minItemLevel = 316, maxItemLevel = 325, amountOfMats = 1.875},
				{itemType = WEAPON, rarity = 2, minItemLevel = 326, maxItemLevel = 350, amountOfMats = 2.25},
			},
		},
		["i:74250"] = { -- Mysterious Essence
			minLevel = 83,
			maxLevel = 88,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 364, maxItemLevel = 390, amountOfMats = 0.15},
				{itemType = ARMOR, rarity = 2, minItemLevel = 391, maxItemLevel = 410, amountOfMats = 0.225},
				{itemType = ARMOR, rarity = 2, minItemLevel = 411, maxItemLevel = 450, amountOfMats = 0.3},
				{itemType = WEAPON, rarity = 2, minItemLevel = 364, maxItemLevel = 390, amountOfMats = 0.15},
				{itemType = WEAPON, rarity = 2, minItemLevel = 391, maxItemLevel = 410, amountOfMats = 0.225},
				{itemType = WEAPON, rarity = 2, minItemLevel = 411, maxItemLevel = 450, amountOfMats = 0.3},
			},
		},
	},
	{
		desc = L["Shards"],
		["i:10978"] = { -- Small Glimmering Shard
			minLevel = 1,
			maxLevel = 20,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 1, maxItemLevel = 20, amountOfMats = 0.05},
				{itemType = ARMOR, rarity = 2, minItemLevel = 21, maxItemLevel = 25, amountOfMats = 0.1},
				{itemType = ARMOR, rarity = 3, minItemLevel = 1, maxItemLevel = 25, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 3, minItemLevel = 1, maxItemLevel = 25, amountOfMats = 1.000},
			},
		},
		["i:11084"] = { -- Large Glimmering Shard
			minLevel = 16,
			maxLevel = 25,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 26, maxItemLevel = 30, amountOfMats = 0.05},
				{itemType = ARMOR, rarity = 3, minItemLevel = 26, maxItemLevel = 30, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 3, minItemLevel = 26, maxItemLevel = 30, amountOfMats = 1.000},
			},
		},
		["i:11138"] = { -- Small Glowing Shard
			minLevel = 26,
			maxLevel = 30,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 31, maxItemLevel = 35, amountOfMats = 0.05},
				{itemType = ARMOR, rarity = 3, minItemLevel = 31, maxItemLevel = 35, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 2, minItemLevel = 31, maxItemLevel = 35, amountOfMats = 0.05},
				{itemType = WEAPON, rarity = 3, minItemLevel = 31, maxItemLevel = 35, amountOfMats = 1.000},
			},
		},
		["i:11139"] = { -- Large Glowing Shard
			minLevel = 31,
			maxLevel = 35,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 36, maxItemLevel = 40, amountOfMats = 0.05},
				{itemType = ARMOR, rarity = 3, minItemLevel = 36, maxItemLevel = 40, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 2, minItemLevel = 36, maxItemLevel = 40, amountOfMats = 0.05},
				{itemType = WEAPON, rarity = 3, minItemLevel = 36, maxItemLevel = 40, amountOfMats = 1.000},
			},
		},
		["i:11177"] = { -- Small Radiant Shard
			minLevel = 36,
			maxLevel = 40,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 41, maxItemLevel = 45, amountOfMats = 0.05},
				{itemType = ARMOR, rarity = 3, minItemLevel = 41, maxItemLevel = 45, amountOfMats = 1.000},
				{itemType = ARMOR, rarity = 4, minItemLevel = 36, maxItemLevel = 40, amountOfMats = 3},
				{itemType = ARMOR, rarity = 4, minItemLevel = 41, maxItemLevel = 45, amountOfMats = 3.5},
				{itemType = WEAPON, rarity = 2, minItemLevel = 41, maxItemLevel = 45, amountOfMats = 0.05},
				{itemType = WEAPON, rarity = 3, minItemLevel = 41, maxItemLevel = 45, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 4, minItemLevel = 36, maxItemLevel = 40, amountOfMats = 3},
				{itemType = WEAPON, rarity = 4, minItemLevel = 41, maxItemLevel = 45, amountOfMats = 3.5},
			},
		},
		["i:11178"] = { -- Large Radiant Shard
			minLevel = 41,
			maxLevel = 45,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 46, maxItemLevel = 50, amountOfMats = 0.05},
				{itemType = ARMOR, rarity = 3, minItemLevel = 46, maxItemLevel = 50, amountOfMats = 1.000},
				{itemType = ARMOR, rarity = 4, minItemLevel = 46, maxItemLevel = 50, amountOfMats = 3.5},
				{itemType = WEAPON, rarity = 2, minItemLevel = 46, maxItemLevel = 50, amountOfMats = 0.05},
				{itemType = WEAPON, rarity = 3, minItemLevel = 46, maxItemLevel = 50, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 4, minItemLevel = 46, maxItemLevel = 50, amountOfMats = 3.5},
			},
		},
		["i:14343"] = { -- Small Brilliant Shard
			minLevel = 46,
			maxLevel = 50,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 51, maxItemLevel = 55, amountOfMats = 0.05},
				{itemType = ARMOR, rarity = 3, minItemLevel = 51, maxItemLevel = 55, amountOfMats = 1.000},
				{itemType = ARMOR, rarity = 4, minItemLevel = 51, maxItemLevel = 55, amountOfMats = 3.5},
				{itemType = WEAPON, rarity = 2, minItemLevel = 51, maxItemLevel = 55, amountOfMats = 0.05},
				{itemType = WEAPON, rarity = 3, minItemLevel = 51, maxItemLevel = 55, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 4, minItemLevel = 51, maxItemLevel = 55, amountOfMats = 3.5},
			},
		},
		["i:14344"] = { -- Large Brilliant Shard
			minLevel = 56,
			maxLevel = 75,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 56, maxItemLevel = 65, amountOfMats = 0.05},
				{itemType = ARMOR, rarity = 3, minItemLevel = 56, maxItemLevel = 65, amountOfMats = 0.995},
				{itemType = WEAPON, rarity = 2, minItemLevel = 56, maxItemLevel = 65, amountOfMats = 0.05},
				{itemType = WEAPON, rarity = 3, minItemLevel = 56, maxItemLevel = 65, amountOfMats = 0.995},
			},
		},
		["i:22449"] = { -- Large Prismatic Shard
			minLevel = 56,
			maxLevel = 70,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 66, maxItemLevel = 99, amountOfMats = 0.0167},
				{itemType = ARMOR, rarity = 2, minItemLevel = 100, maxItemLevel = 120, amountOfMats = 0.05},
				{itemType = ARMOR, rarity = 3, minItemLevel = 66, maxItemLevel = 99, amountOfMats = 0.33},
				{itemType = ARMOR, rarity = 3, minItemLevel = 100, maxItemLevel = 120, amountOfMats = 1},
				{itemType = WEAPON, rarity = 2, minItemLevel = 66, maxItemLevel = 99, amountOfMats = 0.0167},
				{itemType = WEAPON, rarity = 2, minItemLevel = 100, maxItemLevel = 120, amountOfMats = 0.05},
				{itemType = WEAPON, rarity = 3, minItemLevel = 66, maxItemLevel = 99, amountOfMats = 0.33},
				{itemType = WEAPON, rarity = 3, minItemLevel = 100, maxItemLevel = 120, amountOfMats = 1},
			},
		},
		["i:34052"] = { -- Dream Shard
			minLevel = 68,
			maxLevel = 80,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 121, maxItemLevel = 151, amountOfMats = 0.0167},
				{itemType = ARMOR, rarity = 2, minItemLevel = 152, maxItemLevel = 200, amountOfMats = 0.05},
				{itemType = ARMOR, rarity = 3, minItemLevel = 121, maxItemLevel = 164, amountOfMats = 0.33},
				{itemType = ARMOR, rarity = 3, minItemLevel = 165, maxItemLevel = 200, amountOfMats = 1},
				{itemType = WEAPON, rarity = 2, minItemLevel = 121, maxItemLevel = 151, amountOfMats = 0.0167},
				{itemType = WEAPON, rarity = 2, minItemLevel = 152, maxItemLevel = 200, amountOfMats = 0.05},
				{itemType = WEAPON, rarity = 3, minItemLevel = 121, maxItemLevel = 164, amountOfMats = 0.33},
				{itemType = WEAPON, rarity = 3, minItemLevel = 165, maxItemLevel = 200, amountOfMats = 1},
			},
		},
		["i:52720"] = { -- Small Heavenly Shard
			minLevel = 78,
			maxLevel = 85,
			sourceInfo = {
				{itemType = ARMOR, rarity = 3, minItemLevel = 282, maxItemLevel = 316, amountOfMats = 1},
				{itemType = WEAPON, rarity = 3, minItemLevel = 282, maxItemLevel = 316, amountOfMats = 1},
			},
		},
		["i:52721"] = { -- Heavenly Shard
			minLevel = 78,
			maxLevel = 85,
			sourceInfo = {
				{itemType = ARMOR, rarity = 3, minItemLevel = 282, maxItemLevel = 316, amountOfMats = 0.33},
				{itemType = ARMOR, rarity = 3, minItemLevel = 317, maxItemLevel = 377, amountOfMats = 1},
				{itemType = WEAPON, rarity = 3, minItemLevel = 282, maxItemLevel = 316, amountOfMats = 0.33},
				{itemType = WEAPON, rarity = 3, minItemLevel = 317, maxItemLevel = 377, amountOfMats = 1},
			},
		},
		["i:74252"] = { --Small Ethereal Shard
			minLevel = 85,
			maxLevel = 90,
			sourceInfo = {
				{itemType = ARMOR, rarity = 3, minItemLevel = 384, maxItemLevel = 429, amountOfMats = 1},
				{itemType = WEAPON, rarity = 3, minItemLevel = 384, maxItemLevel = 429, amountOfMats = 1},
			},
		},
		["i:74247"] = { -- Ethereal Shard
			minLevel = 85,
			maxLevel = 90,
			sourceInfo = {
				{itemType = ARMOR, rarity = 3, minItemLevel = 384, maxItemLevel = 429, amountOfMats = 0.33},
				{itemType = ARMOR, rarity = 3, minItemLevel = 430, maxItemLevel = 500, amountOfMats = 1},
				{itemType = WEAPON, rarity = 3, minItemLevel = 384, maxItemLevel = 429, amountOfMats = 0.33},
				{itemType = WEAPON, rarity = 3, minItemLevel = 430, maxItemLevel = 500, amountOfMats = 1},
			},
		},
		["i:111245"] = { -- Luminous Shard
			minLevel = 90,
			maxLevel = 100,
			sourceInfo = {
				{itemType = ARMOR, rarity = 3, minItemLevel = 505, maxItemLevel = 569, amountOfMats = 0.14},
				{itemType = ARMOR, rarity = 3, minItemLevel = 570, maxItemLevel = 680, amountOfMats = 0.14},
				{itemType = WEAPON, rarity = 3, minItemLevel = 505, maxItemLevel = 569, amountOfMats = 0.14},
				{itemType = WEAPON, rarity = 3, minItemLevel = 570, maxItemLevel = 680, amountOfMats = 0.14},
			},
		},
	},
	{
		desc = L["Crystals"],
		["i:20725"] = { -- Nexus Crystal
			minLevel = 56,
			maxLevel = 60,
			sourceInfo = {
				{itemType = ARMOR, rarity = 4, minItemLevel = 56, maxItemLevel = 60, amountOfMats = 1.000},
				{itemType = ARMOR, rarity = 4, minItemLevel = 61, maxItemLevel = 94, amountOfMats = 1.5},
				{itemType = WEAPON, rarity = 4, minItemLevel = 56, maxItemLevel = 60, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 4, minItemLevel = 61, maxItemLevel = 94, amountOfMats = 1.5},
			},
		},
		["i:22450"] = { -- Void Crystal
			minLevel = 70,
			maxLevel = 70,
			sourceInfo = {
				{itemType = ARMOR, rarity = 4, minItemLevel = 95, maxItemLevel = 99, amountOfMats = 1},
				{itemType = ARMOR, rarity = 4, minItemLevel = 100, maxItemLevel = 164, amountOfMats = 1.5},
				{itemType = WEAPON, rarity = 4, minItemLevel = 95, maxItemLevel = 99, amountOfMats = 1},
				{itemType = WEAPON, rarity = 4, minItemLevel = 100, maxItemLevel = 164, amountOfMats = 1.5},
			},
		},
		["i:34057"] = { -- Abyss Crystal
			minLevel = 80,
			maxLevel = 80,
			sourceInfo = {
				{itemType = ARMOR, rarity = 4, minItemLevel = 165, maxItemLevel = 299, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 4, minItemLevel = 165, maxItemLevel = 299, amountOfMats = 1.000},
			},
		},
		["i:52722"] = { -- Maelstrom Crystal
			minLevel = 85,
			maxLevel = 85,
			sourceInfo = {
				{itemType = ARMOR, rarity = 4, minItemLevel = 300, maxItemLevel = 419, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 4, minItemLevel = 285, maxItemLevel = 419, amountOfMats = 1.000},
			},
		},
		["i:74248"] = { -- Sha Crystal
			minLevel = 85,
			maxLevel = 90,
			sourceInfo = {
				{itemType = ARMOR, rarity = 4, minItemLevel = 420, maxItemLevel = 600, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 4, minItemLevel = 420, maxItemLevel = 600, amountOfMats = 1.000},
			},
		},
		["i:115504"] = { -- Fractured Temporal Crystal
			minLevel = 90,
			maxLevel = 100,
			sourceInfo = {
				{itemType = ARMOR, rarity = 4, minItemLevel = 630, maxItemLevel = 735, amountOfMats = 5},
				{itemType = WEAPON, rarity = 4, minItemLevel = 630, maxItemLevel = 735, amountOfMats = 5},
			},
		},
		["i:113588"] = { -- Temporal Crystal
			minLevel = 90,
			maxLevel = 100,
			sourceInfo = {
				{itemType = ARMOR, rarity = 4, minItemLevel = 630, maxItemLevel = 735, amountOfMats = 0.13},
				{itemType = WEAPON, rarity = 4, minItemLevel = 630, maxItemLevel = 735, amountOfMats = 0.13},
			},
		},
	},
}



-- ============================================================================
-- Static Pre-Defined Conversions
-- ============================================================================

TSM.STATIC_DATA.predefinedConversions = {
	-- ======================================= Common Pigments =======================================
	["i:39151"] = { -- Alabaster Pigment (Ivory / Moonglow Ink)
		{"i:765", 0.5, "mill"},
		{"i:2447", 0.5, "mill"},
		{"i:2449", 0.6, "mill"},
	},
	["i:39343"] = { -- Azure Pigment (Ink of the Sea)
		{"i:39969", 0.5, "mill"},
		{"i:36904", 0.5, "mill"},
		{"i:36907", 0.5, "mill"},
		{"i:36901", 0.5, "mill"},
		{"i:39970", 0.5, "mill"},
		{"i:37921", 0.5, "mill"},
		{"i:36905", 0.6, "mill"},
		{"i:36906", 0.6, "mill"},
		{"i:36903", 0.6, "mill"},
	},
	["i:61979"] = { -- Ashen Pigment (Blackfallow Ink)
		{"i:52983", 0.5, "mill"},
		{"i:52984", 0.5, "mill"},
		{"i:52985", 0.5, "mill"},
		{"i:52986", 0.5, "mill"},
		{"i:52987", 0.6, "mill"},
		{"i:52988", 0.6, "mill"},
	},
	["i:39334"] = { -- Dusky Pigment (Midnight Ink)
		{"i:785", 0.5, "mill"},
		{"i:2450", 0.5, "mill"},
		{"i:2452", 0.5, "mill"},
		{"i:2453", 0.6, "mill"},
		{"i:3820", 0.6, "mill"},
	},
	["i:39339"] = { -- Emerald Pigment (Jadefire Ink)
		{"i:3818", 0.5, "mill"},
		{"i:3821", 0.5, "mill"},
		{"i:3358", 0.6, "mill"},
		{"i:3819", 0.6, "mill"},
	},
	["i:39338"] = { -- Golden Pigment (Lion's Ink)
		{"i:3355", 0.5, "mill"},
		{"i:3369", 0.5, "mill"},
		{"i:3356", 0.6, "mill"},
		{"i:3357", 0.6, "mill"},
	},
	["i:39342"] = { -- Nether Pigment (Ethereal Ink)
		{"i:22785", 0.5, "mill"},
		{"i:22786", 0.5, "mill"},
		{"i:22787", 0.5, "mill"},
		{"i:22789", 0.5, "mill"},
		{"i:22790", 0.6, "mill"},
		{"i:22791", 0.6, "mill"},
		{"i:22792", 0.6, "mill"},
		{"i:22793", 0.6, "mill"},
	},
	["i:79251"] = { -- Shadow Pigment (Ink of Dreams)
		{"i:72237", 0.5, "mill"},
		{"i:72234", 0.5, "mill"},
		{"i:79010", 0.5, "mill"},
		{"i:72235", 0.5, "mill"},
		{"i:89639", 0.5, "mill"},
		{"i:79011", 0.6, "mill"},
	},
	["i:39341"] = { -- Silvery Pigment (Shimmering Ink)
		{"i:13463", 0.5, "mill"},
		{"i:13464", 0.5, "mill"},
		{"i:13465", 0.6, "mill"},
		{"i:13466", 0.6, "mill"},
		{"i:13467", 0.6, "mill"},
	},
	["i:39340"] = { -- Violet Pigment (Celestial Ink)
		{"i:4625", 0.5, "mill"},
		{"i:8831", 0.5, "mill"},
		{"i:8838", 0.5, "mill"},
		{"i:8839", 0.6, "mill"},
		{"i:8845", 0.6, "mill"},
		{"i:8846", 0.6, "mill"},
	},
	["i:114931"] = { -- Cerulean Pigment (Warbinder's Ink)
		{"i:109124", 0.42, "mill"},
		{"i:109125", 0.42, "mill"},
		{"i:109126", 0.42, "mill"},
		{"i:109127", 0.42, "mill"},
		{"i:109128", 0.42, "mill"},
		{"i:109129", 0.42, "mill"},
	},
	-- ======================================= Rare Pigments =======================================
	["i:43109"] = { -- Icy Pigment (Snowfall Ink)
		{"i:39969", 0.05, "mill"},
		{"i:36904", 0.05, "mill"},
		{"i:36907", 0.05, "mill"},
		{"i:36901", 0.05, "mill"},
		{"i:39970", 0.05, "mill"},
		{"i:37921", 0.05, "mill"},
		{"i:36905", 0.1, "mill"},
		{"i:36906", 0.1, "mill"},
		{"i:36903", 0.1, "mill"},
	},
	["i:61980"] = { -- Burning Embers (Inferno Ink)
		{"i:52983", 0.05, "mill"},
		{"i:52984", 0.05, "mill"},
		{"i:52985", 0.05, "mill"},
		{"i:52986", 0.05, "mill"},
		{"i:52987", 0.1, "mill"},
		{"i:52988", 0.1, "mill"},
	},
	["i:43104"] = { -- Burnt Pigment (Dawnstar Ink)
		{"i:3356", 0.1, "mill"},
		{"i:3357", 0.1, "mill"},
		{"i:3369", 0.05, "mill"},
		{"i:3355", 0.05, "mill"},
	},
	["i:43108"] = { -- Ebon Pigment (Darkflame Ink)
		{"i:22792", 0.1, "mill"},
		{"i:22790", 0.1, "mill"},
		{"i:22791", 0.1, "mill"},
		{"i:22793", 0.1, "mill"},
		{"i:22786", 0.05, "mill"},
		{"i:22785", 0.05, "mill"},
		{"i:22787", 0.05, "mill"},
		{"i:22789", 0.05, "mill"},
	},
	["i:43105"] = { -- Indigo Pigment (Royal Ink)
		{"i:3358", 0.1, "mill"},
		{"i:3819", 0.1, "mill"},
		{"i:3821", 0.05, "mill"},
		{"i:3818", 0.05, "mill"},
	},
	["i:79253"] = { -- Misty Pigment (Starlight Ink)
		{"i:72237", 0.05, "mill"},
		{"i:72234", 0.05, "mill"},
		{"i:79010", 0.05, "mill"},
		{"i:72235", 0.05, "mill"},
		{"i:79011", 0.1, "mill"},
		{"i:89639", 0.05, "mill"},
	},
	["i:43106"] = { -- Ruby Pigment (Fiery Ink)
		{"i:4625", 0.05, "mill"},
		{"i:8838", 0.05, "mill"},
		{"i:8831", 0.05, "mill"},
		{"i:8845", 0.1, "mill"},
		{"i:8846", 0.1, "mill"},
		{"i:8839", 0.1, "mill"},
	},
	["i:43107"] = { -- Sapphire Pigment (Ink of the Sky)
		{"i:13463", 0.05, "mill"},
		{"i:13464", 0.05, "mill"},
		{"i:13465", 0.1, "mill"},
		{"i:13466", 0.1, "mill"},
		{"i:13467", 0.1, "mill"},
	},
	["i:43103"] = { -- Sapphire Pigment (Ink of the Sky)
		{"i:2453", 0.1, "mill"},
		{"i:3820", 0.1, "mill"},
		{"i:2450", 0.05, "mill"},
		{"i:785", 0.05, "mill"},
		{"i:2452", 0.05, "mill"},
	},
	-- ======================================== Vanilla Gems =======================================
	["i:774"] = { -- Malachite
		{"i:2770", 0.1, "prospect"},
	},
	["i:818"] = { -- Tigerseye
		{"i:2770", 0.1, "prospect"},
	},
	["i:1210"] = {  -- Shadowgem
		{"i:2771", 0.08, "prospect"},
		{"i:2770", 0.02, "prospect"},
	},
	["i:1206"] = { -- Moss Agate
		{"i:2771", 0.06, "prospect"},
	},
	["i:1705"] = { -- Lesser Moonstone
		{"i:2771", 0.08, "prospect"},
		{"i:2772", 0.06, "prospect"},
	},
	["i:1529"] = { -- Jade
		{"i:2772", 0.08, "prospect"},
		{"i:2771", 0.006, "prospect"},
	},
	["i:3864"] = { -- Citrine
		{"i:2772", 0.08, "prospect"},
		{"i:3858", 0.06, "prospect"},
		{"i:2771", 0.006, "prospect"},
	},
	["i:7909"] = { -- Aquamarine
		{"i:3858", 0.06, "prospect"},
		{"i:2772", 0.01, "prospect"},
		{"i:2771", 0.006, "prospect"},
	},
	["i:7910"] = { -- Star Ruby
		{"i:3858", 0.08, "prospect"},
		{"i:10620", 0.02, "prospect"},
		{"i:2772", 0.01, "prospect"},
	},
	["i:12361"] = { -- Blue Sapphire
		{"i:10620", 0.06, "prospect"},
		{"i:3858", 0.006, "prospect"},
	},
	["i:12799"] = { -- Large Opal
		{"i:10620", 0.06, "prospect"},
		{"i:3858", 0.006, "prospect"},
	},
	["i:12800"] = { -- Azerothian Diamond
		{"i:10620", 0.06, "prospect"},
		{"i:3858", 0.004, "prospect"},
	},
	["i:12364"] = { -- Huge Emerald
		{"i:10620", 0.06, "prospect"},
		{"i:3858", 0.004, "prospect"},
	},
	-- ======================================== Uncommon Gems ======================================
	["i:23117"] = { -- Azure Moonstone
		{"i:23424", 0.04, "prospect"},
		{"i:23425", 0.04, "prospect"},
	},
	["i:23077"] = { -- Blood Garnet
		{"i:23424", 0.04, "prospect"},
		{"i:23425", 0.04, "prospect"},
	},
	["i:23079"] = { -- Deep Peridot
		{"i:23424", 0.04, "prospect"},
		{"i:23425", 0.04, "prospect"},
	},
	["i:21929"] = { -- Flame Spessarite
		{"i:23424", 0.04, "prospect"},
		{"i:23425", 0.04, "prospect"},
	},
	["i:23112"] = { -- Golden Draenite
		{"i:23424", 0.04, "prospect"},
		{"i:23425", 0.04, "prospect"},
	},
	["i:23107"] = { -- Shadow Draenite
		{"i:23424", 0.04, "prospect"},
		{"i:23425", 0.04, "prospect"},
	},
	["i:36917"] = { -- Bloodstone
		{"i:36909", 0.05, "prospect"},
		{"i:36912", 0.04, "prospect"},
		{"i:36910", 0.05, "prospect"},
	},
	["i:36923"] = { -- Chalcedony
		{"i:36909", 0.05, "prospect"},
		{"i:36912", 0.04, "prospect"},
		{"i:36910", 0.05, "prospect"},
	},
	["i:36932"] = { -- Dark Jade
		{"i:36909", 0.05, "prospect"},
		{"i:36912", 0.04, "prospect"},
		{"i:36910", 0.05, "prospect"},
	},
	["i:36929"] = { -- Huge Citrine
		{"i:36909", 0.05, "prospect"},
		{"i:36912", 0.04, "prospect"},
		{"i:36910", 0.05, "prospect"},
	},
	["i:36926"] = { -- Shadow Crystal
		{"i:36909", 0.05, "prospect"},
		{"i:36912", 0.04, "prospect"},
		{"i:36910", 0.05, "prospect"},
	},
	["i:36920"] = { -- Sun Crystal
		{"i:36909", 0.05, "prospect"},
		{"i:36912", 0.04, "prospect"},
		{"i:36910", 0.04, "prospect"},
	},
	["i:52182"] = { -- Jasper
		{"i:53038", 0.05, "prospect"},
		{"i:52185", 0.04, "prospect"},
		{"i:52183", 0.04, "prospect"},
	},
	["i:52180"] = { -- Nightstone
		{"i:53038", 0.05, "prospect"},
		{"i:52185", 0.04, "prospect"},
		{"i:52183", 0.04, "prospect"},
	},
	["i:52178"] = { -- Zephyrite
		{"i:53038", 0.05, "prospect"},
		{"i:52185", 0.04, "prospect"},
		{"i:52183", 0.04, "prospect"},
	},
	["i:52179"] = { -- Alicite
		{"i:53038", 0.05, "prospect"},
		{"i:52185", 0.04, "prospect"},
		{"i:52183", 0.04, "prospect"},
	},
	["i:52177"] = { -- Carnelian
		{"i:53038", 0.05, "prospect"},
		{"i:52185", 0.04, "prospect"},
		{"i:52183", 0.04, "prospect"},
	},
	["i:52181"] = { -- Hessonite
		{"i:53038", 0.05, "prospect"},
		{"i:52185", 0.04, "prospect"},
		{"i:52183", 0.04, "prospect"},
	},
	["i:76130"] = { -- Tiger Opal
		{"i:72092", 0.05, "prospect"},
		{"i:72093", 0.05, "prospect"},
		{"i:72103", 0.04, "prospect"},
		{"i:72094", 0.04, "prospect"},
	},
	["i:76133"] = { -- Lapis Lazuli
		{"i:72092", 0.05, "prospect"},
		{"i:72093", 0.05, "prospect"},
		{"i:72103", 0.04, "prospect"},
		{"i:72094", 0.04, "prospect"},
	},
	["i:76134"] = { -- Sunstone
		{"i:72092", 0.05, "prospect"},
		{"i:72093", 0.05, "prospect"},
		{"i:72103", 0.04, "prospect"},
		{"i:72094", 0.04, "prospect"},
	},
	["i:76135"] = { -- Roguestone
		{"i:72092", 0.05, "prospect"},
		{"i:72093", 0.05, "prospect"},
		{"i:72103", 0.04, "prospect"},
		{"i:72094", 0.04, "prospect"},
	},
	["i:76136"] = { -- Pandarian Garnet
		{"i:72092", 0.05, "prospect"},
		{"i:72093", 0.05, "prospect"},
		{"i:72103", 0.04, "prospect"},
		{"i:72094", 0.04, "prospect"},
	},
	["i:76137"] = { -- Alexandrite
		{"i:72092", 0.05, "prospect"},
		{"i:72093", 0.05, "prospect"},
		{"i:72103", 0.04, "prospect"},
		{"i:72094", 0.04, "prospect"},
	},
	-- ========================================== Rare Gems ========================================
	["i:23440"] = { -- Dawnstone
		{"i:23424", 0.002, "prospect"},
		{"i:23425", 0.008, "prospect"},
	},
	["i:23436"] = { -- Living Ruby
		{"i:23424", 0.002, "prospect"},
		{"i:23425", 0.008, "prospect"},
	},
	["i:23441"] = { -- Nightseye
		{"i:23424", 0.002, "prospect"},
		{"i:23425", 0.008, "prospect"},
	},
	["i:23439"] = { -- Noble Topaz
		{"i:23424", 0.002, "prospect"},
		{"i:23425", 0.008, "prospect"},
	},
	["i:23438"] = { -- Star of Elune
		{"i:23424", 0.002, "prospect"},
		{"i:23425", 0.008, "prospect"},
	},
	["i:23437"] = { -- Talasite
		{"i:23424", 0.002, "prospect"},
		{"i:23425", 0.008, "prospect"},
	},
	["i:36921"] = { -- Autumn's Glow
		{"i:36909", 0.002, "prospect"},
		{"i:36912", 0.008, "prospect"},
		{"i:36910", 0.008, "prospect"},
	},
	["i:36933"] = { -- Forest Emerald
		{"i:36909", 0.002, "prospect"},
		{"i:36912", 0.008, "prospect"},
		{"i:36910", 0.008, "prospect"},
	},
	["i:36930"] = { -- Monarch Topaz
		{"i:36909", 0.002, "prospect"},
		{"i:36912", 0.008, "prospect"},
		{"i:36910", 0.008, "prospect"},
	},
	["i:36918"] = { -- Scarlet Ruby
		{"i:36909", 0.002, "prospect"},
		{"i:36912", 0.008, "prospect"},
		{"i:36910", 0.008, "prospect"},
	},
	["i:36924"] = { -- Sky Sapphire
		{"i:36909", 0.002, "prospect"},
		{"i:36912", 0.008, "prospect"},
		{"i:36910", 0.008, "prospect"},
	},
	["i:36927"] = { -- Twilight Opal
		{"i:36909", 0.002, "prospect"},
		{"i:36912", 0.008, "prospect"},
		{"i:36910", 0.008, "prospect"},
	},
	["i:52192"] = { -- Dream Emerald
		{"i:53038", 0.016, "prospect"},
		{"i:52185", 0.01, "prospect"},
		{"i:52183", 0.008, "prospect"},
	},
	["i:52193"] = { -- Ember Topaz
		{"i:53038", 0.016, "prospect"},
		{"i:52185", 0.01, "prospect"},
		{"i:52183", 0.008, "prospect"},
	},
	["i:52190"] = { -- Inferno Ruby
		{"i:53038", 0.016, "prospect"},
		{"i:52185", 0.01, "prospect"},
		{"i:52183", 0.008, "prospect"},
	},
	["i:52195"] = { -- Amberjewel
		{"i:53038", 0.016, "prospect"},
		{"i:52185", 0.01, "prospect"},
		{"i:52183", 0.008, "prospect"},
	},
	["i:52194"] = { -- Demonseye
		{"i:53038", 0.016, "prospect"},
		{"i:52185", 0.01, "prospect"},
		{"i:52183", 0.008, "prospect"},
	},
	["i:52191"] = { -- Ocean Sapphire
		{"i:53038", 0.016, "prospect"},
		{"i:52185", 0.01, "prospect"},
		{"i:52183", 0.008, "prospect"},
	},
	["i:76131"] = { -- Primordial Ruby
		{"i:72092", 0.008, "prospect"},
		{"i:72093", 0.008, "prospect"},
		{"i:72103", 0.03, "prospect"},
		{"i:72094", 0.03, "prospect"},
	},
	["i:76138"] = { -- River's Heart
		{"i:72092", 0.008, "prospect"},
		{"i:72093", 0.008, "prospect"},
		{"i:72103", 0.03, "prospect"},
		{"i:72094", 0.03, "prospect"},
	},
	["i:76139"] = { -- Wild Jade
		{"i:72092", 0.008, "prospect"},
		{"i:72093", 0.008, "prospect"},
		{"i:72103", 0.03, "prospect"},
		{"i:72094", 0.03, "prospect"},
	},
	["i:76140"] = { -- Vermillion Onyx
		{"i:72092", 0.008, "prospect"},
		{"i:72093", 0.008, "prospect"},
		{"i:72103", 0.03, "prospect"},
		{"i:72094", 0.03, "prospect"},
	},
	["i:76141"] = { -- Imperial Amethyst
		{"i:72092", 0.008, "prospect"},
		{"i:72093", 0.008, "prospect"},
		{"i:72103", 0.03, "prospect"},
		{"i:72094", 0.03, "prospect"},
	},
	["i:76142"] = { -- Sun's Radiance
		{"i:72092", 0.008, "prospect"},
		{"i:72093", 0.008, "prospect"},
		{"i:72103", 0.03, "prospect"},
		{"i:72094", 0.03, "prospect"},
	},
	-- =========================================== Essences ========================================
	["i:52719"] = {{"i:52718", 1/3, "transform"}}, -- Celestial Essence
	["i:52718"] = {{"i:52719", 3, "transform"}}, -- Celestial Essence
	["i:34055"] = {{"i:34056", 1/3, "transform"}}, -- Cosmic Essence
	["i:34056"] = {{"i:34055", 3, "transform"}}, -- Cosmic Essence
	["i:22446"] = {{"i:22447", 1/3, "transform"}}, -- Planar Essence
	["i:22447"] = {{"i:22446", 3, "transform"}}, -- Planar Essence
	["i:16203"] = {{"i:16202", 1/3, "transform"}}, -- Eternal Essence
	["i:16202"] = {{"i:16203", 3, "transform"}}, -- Eternal Essence
	["i:11175"] = {{"i:11174", 1/3, "transform"}}, -- Nether Essence
	["i:11174"] = {{"i:11175", 3, "transform"}}, -- Nether Essence
	["i:11135"] = {{"i:11134", 1/3, "transform"}}, -- Mystic Essence
	["i:11134"] = {{"i:11135", 3, "transform"}}, -- Mystic Essence
	["i:11082"] = {{"i:10998", 1/3, "transform"}}, -- Astral Essence
	["i:10998"] = {{"i:11082", 3, "transform"}}, -- Astral Essence
	["i:10939"] = {{"i:10938", 1/3, "transform"}}, -- Magic Essence
	["i:10938"] = {{"i:10939", 3, "transform"}}, -- Magic Essence
	-- ============================================ Shards =========================================
	["i:52721"] = {{"i:52720", 1/3, "transform"}}, -- Heavenly Shard
	["i:34052"] = {{"i:34053", 1/3, "transform"}}, -- Dream Shard
	["i:74247"] = {{"i:74252", 1/3, "transform"}}, -- Ethereal Shard
	["i:111245"] = {{"i:115502", 0.1, "transform"}}, -- Luminous Shard
	-- =========================================== Crystals ========================================
	["i:113588"] = {{"i:115504", 0.1, "transform"}}, -- Temporal Crystal
	-- ======================================== Primals / Motes ====================================
	["i:21885"] = {{"i:22578", 0.1, "transform"}}, -- Water
	["i:22456"] = {{"i:22577", 0.1, "transform"}}, -- Shadow
	["i:22457"] = {{"i:22576", 0.1, "transform"}}, -- Mana
	["i:21886"] = {{"i:22575", 0.1, "transform"}}, -- Life
	["i:21884"] = {{"i:22574", 0.1, "transform"}}, -- Fire
	["i:22452"] = {{"i:22573", 0.1, "transform"}}, -- Earth
	["i:22451"] = {{"i:22572", 0.1, "transform"}}, -- Air
	-- ===================================== Crystalized / Eternal =================================
	["i:37700"] = {{"i:35623", 10, "transform"}}, -- Air
	["i:35623"] = {{"i:37700", 0.1, "transform"}}, -- Air
	["i:37701"] = {{"i:35624", 10, "transform"}}, -- Earth
	["i:35624"] = {{"i:37701", 0.1, "transform"}}, -- Earth
	["i:37702"] = {{"i:36860", 10, "transform"}}, -- Fire
	["i:36860"] = {{"i:37702", 0.1, "transform"}}, -- Fire
	["i:37703"] = {{"i:35627", 10, "transform"}}, -- Shadow
	["i:35627"] = {{"i:37703", 0.1, "transform"}}, -- Shadow
	["i:37704"] = {{"i:35625", 10, "transform"}}, -- Life
	["i:35625"] = {{"i:37704", 0.1, "transform"}}, -- Life
	["i:37705"] = {{"i:35622", 10, "transform"}}, -- Water
	["i:35622"] = {{"i:37705", 0.1, "transform"}}, -- Water
	-- ========================================= Wod Fish ==========================================
	["i:109137"] = {
		{"i:111601", 4, "transform"}, -- Enormous Crescent Saberfish
		{"i:111595", 2, "transform"}, -- Crescent Saberfish
		{"i:111589", 1, "transform"}, -- Small Crescent Saberfish
	},
	["i:109138"] = {
		{"i:111676", 4, "transform"}, -- Enormous Jawless Skulker
		{"i:111669", 2, "transform"}, -- Jawless Skulker
		{"i:111650", 1, "transform"}, -- Small Jawless Skulker
	},
	["i:109139"] = {
		{"i:111675", 4, "transform"}, -- Enormous Fat Sleeper
		{"i:111668", 2, "transform"}, -- Fat Sleeper
		{"i:111651", 1, "transform"}, -- Small Fat Sleeper
	},
	["i:109140"] = {
		{"i:111674", 4, "transform"}, -- Enormous Blind Lake Sturgeon
		{"i:111667", 2, "transform"}, -- Blind Lake Sturgeon
		{"i:111652", 1, "transform"}, -- Small Blind Lake Sturgeon
	},
	["i:109141"] = {
		{"i:111673", 4, "transform"}, -- Enormous Fire Ammonite
		{"i:111666", 2, "transform"}, -- Fire Ammonite
		{"i:111656", 1, "transform"}, -- Small Fire Ammonite
	},
	["i:109142"] = {
		{"i:111672", 4, "transform"}, -- Enormous Sea Scorpion
		{"i:111665", 2, "transform"}, -- Sea Scorpion
		{"i:111658", 1, "transform"}, -- Small Sea Scorpion
	},
	["i:109143"] = {
		{"i:111671", 4, "transform"}, -- Enormous Abyssal Gulper Eel
		{"i:111664", 2, "transform"}, -- Abyssal Gulper Eel
		{"i:111659", 1, "transform"}, -- Small Abyssal Gulper Eel
	},
	["i:109144"] = {
		{"i:111670", 4, "transform"}, -- Enormous Blackwater Whiptail
		{"i:111663", 2, "transform"}, -- Blackwater Whiptail
		{"i:111662", 1, "transform"}, -- Small Blackwater Whiptail
	},
	-- ========================================== Ore Nuggets =======================================
	["i:2771"] = {{"i:108295", 0.1, "transform"}},   -- Tin Ore
	["i:2772"] = {{"i:108297", 0.1, "transform"}},   -- Iron Ore
	["i:2775"] = {{"i:108294", 0.1, "transform"}},   -- Silver Ore
	["i:2776"] = {{"i:108296", 0.1, "transform"}},   -- Gold Ore
	["i:3858"] = {{"i:108300", 0.1, "transform"}},   -- Mithril Ore
	["i:7911"] = {{"i:108299", 0.1, "transform"}},   -- Truesilver Ore
	["i:10620"] = {{"i:108298", 0.1, "transform"}},  -- Thorium Ore
	["i:23424"] = {{"i:108301", 0.1, "transform"}},  -- Fel Iron Ore
	["i:23425"] = {{"i:108302", 0.1, "transform"}},  -- Adamantite Ore
	["i:23426"] = {{"i:108304", 0.1, "transform"}},  -- Khorium Ore
	["i:23427"] = {{"i:108303", 0.1, "transform"}},  -- Eternium Ore
	["i:36909"] = {{"i:108305", 0.1, "transform"}},  -- Cobalt Ore
	["i:36910"] = {{"i:108391", 0.1, "transform"}},  -- Titanium Ore
	["i:36912"] = {{"i:108306", 0.1, "transform"}},  -- Saronite Ore
	["i:52183"] = {{"i:108309", 0.1, "transform"}},  -- Pyrite Ore
	["i:52185"] = {{"i:108308", 0.1, "transform"}},  -- Elementium Ore
	["i:53038"] = {{"i:108307", 0.1, "transform"}},  -- Obsidium Ore
	["i:72092"] = {{"i:97512", 0.1, "transform"}},   -- Ghost Iron Ore
	["i:109119"] = {{"i:109991", 0.1, "transform"}}, -- True Iron Ore
	-- =========================================== Herb Parts ======================================
	["i:2449"] = {{"i:108319", 0.1, "transform"}}, -- Earthroot
	-- ========================================= Vendor Trades =====================================
	["i:37101"] = {{"i:113111", 1, "vendortrade"}},   -- Ivory Ink
	["i:39469"] = {{"i:113111", 1, "vendortrade"}},   -- Moonglow Ink
	["i:39774"] = {{"i:113111", 1, "vendortrade"}},   -- Midnight Ink
	["i:43116"] = {{"i:113111", 1, "vendortrade"}},   -- Lion's Ink
	["i:43118"] = {{"i:113111", 1, "vendortrade"}},   -- Jadefire Ink
	["i:43120"] = {{"i:113111", 1, "vendortrade"}},   -- Celestial Ink
	["i:43122"] = {{"i:113111", 1, "vendortrade"}},   -- Shimmering Ink
	["i:43124"] = {{"i:113111", 1, "vendortrade"}},   -- Ethereal Ink
	["i:43126"] = {{"i:113111", 1, "vendortrade"}},   -- Ink of the Sea
	["i:43127"] = {{"i:113111", 0.1, "vendortrade"}}, -- Snowfall Ink
	["i:61978"] = {{"i:113111", 1, "vendortrade"}},   -- Blackfallow Ink
	["i:61981"] = {{"i:113111", 0.1, "vendortrade"}}, -- Inferno Ink
	["i:79254"] = {{"i:113111", 1, "vendortrade"}},   -- Ink of Dreams
	["i:79255"] = {{"i:113111", 0.1, "vendortrade"}}, -- Starlight Ink
}



-- ============================================================================
-- Static Pre-Defined Conversions
-- ============================================================================

TSM.STATIC_DATA.importantBonusId = {
	[19] = true,
	[32] = true,
	[33] = true,
	[34] = true,
	[35] = true,
	[36] = true,
	[37] = true,
	[38] = true,
	[39] = true,
	[40] = true,
	[41] = true,
	[42] = true,
	[43] = true,
	[45] = true,
	[66] = true,
	[87] = true,
	[108] = true,
	[129] = true,
	[150] = true,
	[175] = true,
	[196] = true,
	[217] = true,
	[238] = true,
	[259] = true,
	[280] = true,
	[301] = true,
	[322] = true,
	[343] = true,
	[364] = true,
	[385] = true,
	[406] = true,
	[427] = true,
	[525] = true,
	[526] = true,
	[527] = true,
	[558] = true,
	[559] = true,
	[560] = true,
	[561] = true,
	[562] = true,
	[563] = true,
	[564] = true,
	[565] = true,
	[566] = true,
	[567] = true,
	[593] = true,
	[594] = true,
	[617] = true,
	[618] = true,
	[619] = true,
	[620] = true,
	[651] = true,
}