-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
local _G = getfenv(0)

-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local LibStub = _G.LibStub
local DS = LibStub("LibBabble-DigSites-3.0"):GetLookupTable()

-----------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------
local RACE_DWARF = 1
local RACE_DRAENEI = 2
local RACE_FOSSIL = 3
local RACE_NIGHTELF = 4
local RACE_NERUBIAN = 5
local RACE_ORC = 6
local RACE_TOLVIR = 7
local RACE_TROLL = 8
local RACE_VRYKUL = 9

local DIG_SITES = {
	-----------------------------------------------------------------------
	-- Kalimdor
	-----------------------------------------------------------------------
	[DS["Abyssal Sands Fossil Ridge"]] = {
		continent = 1,
		map = 161,
		blob_id = 56375,
		race = RACE_FOSSIL
	},
	[DS["Akhenet Fields Digsite"]] = {
		continent = 1,
		map = 720,
		blob_id = 56608,
		race = RACE_TOLVIR
	},
	[DS["Bael Modan Digsite"]] = {
		continent = 1,
		map = 607,
		blob_id = 55410,
		race = RACE_DWARF
	},
	[DS["Broken Commons Digsite"]] = {
		continent = 1,
		map = 121,
		blob_id = 56329,
		race = RACE_NIGHTELF
	},
	[DS["Broken Pillar Digsite"]] = {
		continent = 1,
		map = 161,
		blob_id = 56367,
		race = RACE_TROLL
	},
	[DS["Constellas Digsite"]] = {
		continent = 1,
		map = 182,
		blob_id = 56343,
		race = RACE_NIGHTELF
	},
	[DS["Cursed Landing Digsite"]] = {
		continent = 1,
		map = 720,
		blob_id = 56609,
		race = RACE_TOLVIR
	},
	[DS["Darkmist Digsite"]] = {
		continent = 1,
		map = 121,
		blob_id = 56337,
		race = RACE_NIGHTELF
	},
	[DS["Dire Maul Digsite"]] = {
		continent = 1,
		map = 121,
		blob_id = 56327,
		race = RACE_NIGHTELF
	},
	[DS["Dunemaul Fossil Ridge"]] = {
		continent = 1,
		map = 161,
		blob_id = 56373,
		race = RACE_FOSSIL
	},
	[DS["Eastmoon Ruins Digsite"]] = {
		continent = 1,
		map = 161,
		blob_id = 56369,
		race = RACE_TROLL
	},
	[DS["Ethel Rethor Digsite"]] = {
		continent = 1,
		map = 101,
		blob_id = 55420,
		race = RACE_NIGHTELF
	},
	[DS["Fields of Blood Fossil Bank"]] = {
		continent = 1,
		map = 607,
		blob_id = 56358,
		race = RACE_FOSSIL
	},
	[DS["Forest Song Digsite"]] = {
		continent = 1,
		map = 43,
		blob_id = 55402,
		race = RACE_NIGHTELF
	},
	[DS["Frostwhisper Gorge Digsite"]] = {
		continent = 1,
		map = 281,
		blob_id = 56356,
		race = RACE_NIGHTELF
	},
	[DS["Grove of Aessina Digsite"]] = {
		continent = 1,
		map = 606,
		blob_id = 56570,
		race = RACE_NIGHTELF
	},
	[DS["Ironwood Digsite"]] = {
		continent = 1,
		map = 182,
		blob_id = 56349,
		race = RACE_NIGHTELF
	},
	[DS["Jaedenar Digsite"]] = {
		continent = 1,
		map = 182,
		blob_id = 56347,
		race = RACE_NIGHTELF
	},
	[DS["Keset Pass Digsite"]] = {
		continent = 1,
		map = 720,
		blob_id = 56611,
		race = RACE_TOLVIR
	},
	[DS["Khartut's Tomb Digsite"]] = {
		continent = 1,
		map = 720,
		blob_id = 56591,
		race = RACE_TOLVIR
	},
	[DS["Kodo Graveyard"]] = {
		continent = 1,
		map = 101,
		blob_id = 55426,
		race = RACE_FOSSIL
	},
	[DS["Lake Kel'Theril Digsite"]] = {
		continent = 1,
		map = 281,
		blob_id = 56351,
		race = RACE_NIGHTELF
	},
	[DS["Lower Lakkari Tar Pits"]] = {
		continent = 1,
		map = 201,
		blob_id = 56380,
		race = RACE_FOSSIL
	},
	[DS["Mannoroc Coven Digsite"]] = {
		continent = 1,
		map = 101,
		blob_id = 55424,
		race = RACE_NIGHTELF
	},
	[DS["Marshlands Fossil Bank"]] = {
		continent = 1,
		map = 201,
		blob_id = 56388,
		race = RACE_FOSSIL
	},
	[DS["Morlos'Aran Digsite"]] = {
		continent = 1,
		map = 182,
		blob_id = 56345,
		race = RACE_NIGHTELF
	},
	[DS["Nazj'vel Digsite"]] = {
		continent = 1,
		map = 42,
		blob_id = 55354,
		race = RACE_NIGHTELF
	},
	[DS["Neferset Digsite"]] = {
		continent = 1,
		map = 720,
		blob_id = 56597,
		race = RACE_TOLVIR
	},
	[DS["Nightmare Scar Digsite"]] = {
		continent = 1,
		map = 607,
		blob_id = 56362,
		race = RACE_NIGHTELF
	},
	[DS["North Isildien Digsite"]] = {
		continent = 1,
		map = 121,
		blob_id = 56341,
		race = RACE_NIGHTELF
	},
	[DS["Obelisk of the Stars Digsite"]] = {
		continent = 1,
		map = 720,
		blob_id = 60358,
		race = RACE_TOLVIR
	},
	[DS["Oneiros Digsite"]] = {
		continent = 1,
		map = 121,
		blob_id = 56333,
		race = RACE_NIGHTELF
	},
	[DS["Orsis Digsite"]] = {
		continent = 1,
		map = 720,
		blob_id = 56599,
		race = RACE_TOLVIR
	},
	[DS["Owl Wing Thicket Digsite"]] = {
		continent = 1,
		map = 281,
		blob_id = 56354,
		race = RACE_NIGHTELF
	},
	[DS["Quagmire Fossil Field"]] = {
		continent = 1,
		map = 141,
		blob_id = 55757,
		race = RACE_FOSSIL
	},
	[DS["Ravenwind Digsite"]] = {
		continent = 1,
		map = 121,
		blob_id = 56331,
		race = RACE_NIGHTELF
	},
	[DS["River Delta Digsite"]] = {
		continent = 1,
		map = 720,
		blob_id = 60350,
		race = RACE_TOLVIR
	},
	[DS["Ruins of Ahmtul Digsite"]] = {
		continent = 1,
		map = 720,
		blob_id = 56607,
		race = RACE_TOLVIR
	},
	[DS["Ruins of Ammon Digsite"]] = {
		continent = 1,
		map = 720,
		blob_id = 56601,
		race = RACE_TOLVIR
	},
	[DS["Ruins of Arkkoran"]] = {
		continent = 1,
		map = 181,
		blob_id = 55414,
		race = RACE_NIGHTELF
	},
	[DS["Ruins of Eldarath"]] = {
		continent = 1,
		map = 181,
		blob_id = 55412,
		race = RACE_NIGHTELF
	},
	[DS["Ruins of Eldre'Thar"]] = {
		continent = 1,
		map = 81,
		blob_id = 55406,
		race = RACE_NIGHTELF
	},
	[DS["Ruins of Khintaset Digsite"]] = {
		continent = 1,
		map = 720,
		blob_id = 56603,
		race = RACE_TOLVIR
	},
	[DS["Ruins of Lar'donir Digsite"]] = {
		continent = 1,
		map = 606,
		blob_id = 56566,
		race = RACE_NIGHTELF
	},
	[DS["Ruins of Ordil'Aran"]] = {
		continent = 1,
		map = 43,
		blob_id = 55398,
		race = RACE_NIGHTELF
	},
	[DS["Ruins of Stardust"]] = {
		continent = 1,
		map = 43,
		blob_id = 55400,
		race = RACE_NIGHTELF
	},
	[DS["Sahket Wastes Digsite"]] = {
		continent = 1,
		map = 720,
		blob_id = 60361,
		race = RACE_TOLVIR
	},
	[DS["Sanctuary of Malorne Digsite"]] = {
		continent = 1,
		map = 606,
		blob_id = 56572,
		race = RACE_NIGHTELF
	},
	[DS["Sargeron Digsite"]] = {
		continent = 1,
		map = 101,
		blob_id = 55428,
		race = RACE_NIGHTELF
	},
	[DS["Schnottz's Landing"]] = {
		continent = 1,
		map = 720,
		blob_id = 60363,
		race = RACE_TOLVIR
	},
	[DS["Scorched Plain Digsite"]] = {
		continent = 1,
		map = 606,
		blob_id = 56574,
		race = RACE_NIGHTELF
	},
	[DS["Screaming Reaches Fossil Field"]] = {
		continent = 1,
		map = 201,
		blob_id = 56386,
		race = RACE_FOSSIL
	},
	[DS["Shrine of Goldrinn Digsite"]] = {
		continent = 1,
		map = 606,
		blob_id = 56568,
		race = RACE_NIGHTELF
	},
	[DS["Slitherblade Shore Digsite"]] = {
		continent = 1,
		map = 101,
		blob_id = 55418,
		race = RACE_NIGHTELF
	},
	[DS["Solarsal Digsite"]] = {
		continent = 1,
		map = 121,
		blob_id = 56335,
		race = RACE_NIGHTELF
	},
	[DS["South Isildien Digsite"]] = {
		continent = 1,
		map = 121,
		blob_id = 56339,
		race = RACE_NIGHTELF
	},
	[DS["Southmoon Ruins Digsite"]] = {
		continent = 1,
		map = 161,
		blob_id = 56371,
		race = RACE_TROLL
	},
	[DS["Southwind Village Digsite"]] = {
		continent = 1,
		map = 261,
		blob_id = 56390,
		race = RACE_NIGHTELF
	},
	[DS["Steps of Fate Digsite"]] = {
		continent = 1,
		map = 720,
		blob_id = 56595,
		race = RACE_TOLVIR
	},
	[DS["Stonetalon Peak"]] = {
		continent = 1,
		map = 81,
		blob_id = 55404,
		race = RACE_NIGHTELF
	},
	[DS["Temple of Uldum Digsite"]] = {
		continent = 1,
		map = 720,
		blob_id = 56605,
		race = RACE_TOLVIR
	},
	[DS["Terror Run Fossil Field"]] = {
		continent = 1,
		map = 201,
		blob_id = 56384,
		race = RACE_FOSSIL
	},
	[DS["Tombs of the Precursors Digsite"]] = {
		continent = 1,
		map = 720,
		blob_id = 56593,
		race = RACE_TOLVIR
	},
	[DS["Unearthed Grounds"]] = {
		continent = 1,
		map = 81,
		blob_id = 55408,
		race = RACE_FOSSIL
	},
	[DS["Upper Lakkari Tar Pits"]] = {
		continent = 1,
		map = 201,
		blob_id = 56382,
		race = RACE_FOSSIL
	},
	[DS["Valley of Bones"]] = {
		continent = 1,
		map = 101,
		blob_id = 55422,
		race = RACE_FOSSIL
	},
	[DS["Wyrmbog Fossil Field"]] = {
		continent = 1,
		map = 141,
		blob_id = 55755,
		race = RACE_FOSSIL
	},
	[DS["Zoram Strand Digsite"]] = {
		continent = 1,
		map = 43,
		blob_id = 55356,
		race = RACE_NIGHTELF
	},
	[DS["Zul'Farrak Digsite"]] = {
		continent = 1,
		map = 161,
		blob_id = 56364,
		race = RACE_TROLL
	},

	-----------------------------------------------------------------------
	-- Eastern Kingdoms
	-----------------------------------------------------------------------
	[DS["Aerie Peak Digsite"]] = {
		continent = 2,
		map = 26,
		blob_id = 54136,
		race = RACE_DWARF
	},
	[DS["Agol'watha Digsite"]] = {
		continent = 2,
		map = 26,
		blob_id = 54141,
		race = RACE_TROLL
	},
	[DS["Altar of Zul Digsite"]] = {
		continent = 2,
		map = 26,
		blob_id = 54138,
		race = RACE_TROLL
	},
	[DS["Andorhal Fossil Bank"]] = {
		continent = 2,
		map = 22,
		blob_id = 55482,
		race = RACE_FOSSIL
	},
	[DS["Bal'lal Ruins Digsite"]] = {
		continent = 2,
		map = 37,
		blob_id = 55458,
		race = RACE_TROLL
	},
	[DS["Balia'mah Digsite"]] = {
		continent = 2,
		map = 37,
		blob_id = 55460,
		race = RACE_TROLL
	},
	[DS["Dreadmaul Fossil Field"]] = {
		continent = 2,
		map = 19,
		blob_id = 55436,
		race = RACE_FOSSIL
	},
	[DS["Dun Garok Digsite"]] = {
		continent = 2,
		map = 24,
		blob_id = 54134,
		race = RACE_DWARF
	},
	[DS["Dunwald Ruins Digsite"]] = {
		continent = 2,
		map = 700,
		blob_id = 56583,
		race = RACE_DWARF
	},
	[DS["Eastern Ruins of Thaurissan"]] = {
		continent = 2,
		map = 29,
		blob_id = 55444,
		race = RACE_DWARF
	},
	[DS["Eastern Zul'Kunda Digsite"]] = {
		continent = 2,
		map = 37,
		blob_id = 55454,
		race = RACE_TROLL
	},
	[DS["Eastern Zul'Mamwe Digsite"]] = {
		continent = 2,
		map = 37,
		blob_id = 55464,
		race = RACE_TROLL
	},
	[DS["Felstone Fossil Field"]] = {
		continent = 2,
		map = 22,
		blob_id = 55478,
		race = RACE_FOSSIL
	},
	[DS["Greenwarden's Fossil Bank"]] = {
		continent = 2,
		map = 40,
		blob_id = 54127,
		race = RACE_FOSSIL
	},
	[DS["Grim Batol Digsite"]] = {
		continent = 2,
		map = 700,
		blob_id = 56589,
		race = RACE_DWARF
	},
	[DS["Grimesilt Digsite"]] = {
		continent = 2,
		map = 28,
		blob_id = 55438,
		race = RACE_DWARF
	},
	[DS["Gurubashi Arena Digsite"]] = {
		continent = 2,
		map = 673,
		blob_id = 55474,
		race = RACE_TROLL
	},
	[DS["Hammertoe's Digsite"]] = {
		continent = 2,
		map = 17,
		blob_id = 54832,
		race = RACE_DWARF
	},
	[DS["Humboldt Conflagration Digsite"]] = {
		continent = 2,
		map = 700,
		blob_id = 56587,
		race = RACE_DWARF
	},
	[DS["Infectis Scar Fossil Field"]] = {
		continent = 2,
		map = 23,
		blob_id = 55452,
		race = RACE_FOSSIL
	},
	[DS["Ironband's Excavation Site"]] = {
		continent = 2,
		map = 35,
		blob_id = 54097,
		race = RACE_DWARF
	},
	[DS["Ironbeard's Tomb"]] = {
		continent = 2,
		map = 40,
		blob_id = 54124,
		race = RACE_DWARF
	},
	[DS["Jintha'Alor Lower City Digsite"]] = {
		continent = 2,
		map = 26,
		blob_id = 54139,
		race = RACE_TROLL
	},
	[DS["Jintha'Alor Upper City Digsite"]] = {
		continent = 2,
		map = 26,
		blob_id = 54140,
		race = RACE_TROLL
	},
	[DS["Lakeridge Highway Fossil Bank"]] = {
		continent = 2,
		map = 36,
		blob_id = 55416,
		race = RACE_FOSSIL
	},
	[DS["Misty Reed Fossil Bank"]] = {
		continent = 2,
		map = 38,
		blob_id = 54864,
		race = RACE_FOSSIL
	},
	[DS["Nek'mani Wellspring Digsite"]] = {
		continent = 2,
		map = 673,
		blob_id = 55476,
		race = RACE_TROLL
	},
	[DS["Northridge Fossil Field"]] = {
		continent = 2,
		map = 22,
		blob_id = 55480,
		race = RACE_FOSSIL
	},
	[DS["Plaguewood Digsite"]] = {
		continent = 2,
		map = 23,
		blob_id = 60444,
		race = RACE_NERUBIAN
	},
	[DS["Pyrox Flats Digsite"]] = {
		continent = 2,
		map = 28,
		blob_id = 55440,
		race = RACE_DWARF
	},
	[DS["Quel'Lithien Lodge Digsite"]] = {
		continent = 2,
		map = 23,
		blob_id = 55450,
		race = RACE_NIGHTELF
	},
	[DS["Red Reaches Fossil Bank"]] = {
		continent = 2,
		map = 19,
		blob_id = 55434,
		race = RACE_FOSSIL
	},
	[DS["Ruins of Aboraz"]] = {
		continent = 2,
		map = 673,
		blob_id = 55470,
		race = RACE_TROLL
	},
	[DS["Ruins of Jubuwal"]] = {
		continent = 2,
		map = 673,
		blob_id = 55472,
		race = RACE_TROLL
	},
	[DS["Savage Coast Raptor Fields"]] = {
		continent = 2,
		map = 37,
		blob_id = 55468,
		race = RACE_FOSSIL
	},
	[DS["Shadra'Alor Digsite"]] = {
		continent = 2,
		map = 26,
		blob_id = 54137,
		race = RACE_TROLL
	},
	[DS["Southshore Fossil Field"]] = {
		continent = 2,
		map = 24,
		blob_id = 54135,
		race = RACE_FOSSIL
	},
	[DS["Sunken Temple Digsite"]] = {
		continent = 2,
		map = 38,
		blob_id = 54862,
		race = RACE_TROLL
	},
	[DS["Terror Wing Fossil Field"]] = {
		continent = 2,
		map = 29,
		blob_id = 55446,
		race = RACE_FOSSIL
	},
	[DS["Terrorweb Tunnel Digsite"]] = {
		continent = 2,
		map = 23,
		blob_id = 55443,
		race = RACE_NERUBIAN
	},
	[DS["Thandol Span"]] = {
		continent = 2,
		map = 40,
		blob_id = 54133,
		race = RACE_DWARF
	},
	[DS["Thoradin's Wall"]] = {
		continent = 2,
		map = 16,
		blob_id = 54129,
		race = RACE_DWARF
	},
	[DS["Thundermar Ruins Digsite"]] = {
		continent = 2,
		map = 700,
		blob_id = 56585,
		race = RACE_DWARF
	},
	[DS["Tomb of the Watchers Digsite"]] = {
		continent = 2,
		map = 17,
		blob_id = 54834,
		race = RACE_DWARF
	},
	[DS["Twilight Grove Digsite"]] = {
		continent = 2,
		map = 34,
		blob_id = 55350,
		race = RACE_NIGHTELF
	},
	[DS["Uldaman Entrance Digsite"]] = {
		continent = 2,
		map = 17,
		blob_id = 54838,
		race = RACE_DWARF
	},
	[DS["Vul'Gol Fossil Bank"]] = {
		continent = 2,
		map = 34,
		blob_id = 55352,
		race = RACE_FOSSIL
	},
	[DS["Western Ruins of Thaurissan"]] = {
		continent = 2,
		map = 29,
		blob_id = 55442,
		race = RACE_DWARF
	},
	[DS["Western Zul'Kunda Digsite"]] = {
		continent = 2,
		map = 37,
		blob_id = 55456,
		race = RACE_TROLL
	},
	[DS["Western Zul'Mamwe Digsite"]] = {
		continent = 2,
		map = 37,
		blob_id = 55466,
		race = RACE_TROLL
	},
	[DS["Whelgar's Excavation Site"]] = {
		continent = 2,
		map = 40,
		blob_id = 54126,
		race = RACE_DWARF
	},
	[DS["Witherbark Digsite"]] = {
		continent = 2,
		map = 16,
		blob_id = 54132,
		race = RACE_TROLL
	},
	[DS["Ziata'jai Digsite"]] = {
		continent = 2,
		map = 37,
		blob_id = 55462,
		race = RACE_TROLL
	},
	[DS["Zul'Mashar Digsite"]] = {
		continent = 2,
		map = 23,
		blob_id = 55448,
		race = RACE_TROLL
	},

	-----------------------------------------------------------------------
	-- Outland
	-----------------------------------------------------------------------
	[DS["Ancestral Grounds Digsite"]] = {
		continent = 3,
		map = 477,
		blob_id = 56412,
		race = RACE_ORC
	},
	[DS["Arklon Ruins Digsite"]] = {
		continent = 3,
		map = 479,
		blob_id = 56408,
		race = RACE_DRAENEI
	},
	[DS["Bleeding Hollow Ruins Digsite"]] = {
		continent = 3,
		map = 478,
		blob_id = 56428,
		race = RACE_ORC
	},
	[DS["Boha'mu Ruins Digsite"]] = {
		continent = 3,
		map = 467,
		blob_id = 56402,
		race = RACE_DRAENEI
	},
	[DS["Bone Wastes Digsite"]] = {
		continent = 3,
		map = 478,
		blob_id = 56432,
		race = RACE_DRAENEI
	},
	[DS["Bonechewer Ruins Digsite"]] = {
		continent = 3,
		map = 478,
		blob_id = 56430,
		race = RACE_ORC
	},
	[DS["Burning Blade Digsite"]] = {
		continent = 3,
		map = 477,
		blob_id = 56420,
		race = RACE_ORC
	},
	[DS["Coilskar Point Digsite"]] = {
		continent = 3,
		map = 473,
		blob_id = 56441,
		race = RACE_DRAENEI
	},
	[DS["Dragonmaw Fortress"]] = {
		continent = 3,
		map = 473,
		blob_id = 56455,
		race = RACE_ORC
	},
	[DS["East Auchindoun Digsite"]] = {
		continent = 3,
		map = 478,
		blob_id = 56434,
		race = RACE_DRAENEI
	},
	[DS["Eclipse Point Digsite"]] = {
		continent = 3,
		map = 473,
		blob_id = 56448,
		race = RACE_DRAENEI
	},
	[DS["Gor'gaz Outpost Digsite"]] = {
		continent = 3,
		map = 465,
		blob_id = 56392,
		race = RACE_ORC
	},
	[DS["Grangol'var Village Digsite"]] = {
		continent = 3,
		map = 478,
		blob_id = 56424,
		race = RACE_ORC
	},
	[DS["Halaa Digsite"]] = {
		continent = 3,
		map = 477,
		blob_id = 56422,
		race = RACE_DRAENEI
	},
	[DS["Hellfire Basin Digsite"]] = {
		continent = 3,
		map = 465,
		blob_id = 56396,
		race = RACE_ORC
	},
	[DS["Hellfire Citadel Digsite"]] = {
		continent = 3,
		map = 465,
		blob_id = 56398,
		race = RACE_ORC
	},
	[DS["Illidari Point Digsite"]] = {
		continent = 3,
		map = 473,
		blob_id = 56439,
		race = RACE_DRAENEI
	},
	[DS["Laughing Skull Digsite"]] = {
		continent = 3,
		map = 477,
		blob_id = 56418,
		race = RACE_ORC
	},
	[DS["Ruins of Baa'ri Digsite"]] = {
		continent = 3,
		map = 473,
		blob_id = 56446,
		race = RACE_DRAENEI
	},
	[DS["Ruins of Enkaat Digsite"]] = {
		continent = 3,
		map = 479,
		blob_id = 56406,
		race = RACE_DRAENEI
	},
	[DS["Ruins of Farahlon Digsite"]] = {
		continent = 3,
		map = 479,
		blob_id = 56410,
		race = RACE_DRAENEI
	},
	[DS["Sha'naar Digsite"]] = {
		continent = 3,
		map = 465,
		blob_id = 56400,
		race = RACE_DRAENEI
	},
	[DS["Sunspring Post Digsite"]] = {
		continent = 3,
		map = 477,
		blob_id = 56416,
		race = RACE_ORC
	},
	[DS["Tuurem Digsite"]] = {
		continent = 3,
		map = 478,
		blob_id = 56426,
		race = RACE_DRAENEI
	},
	[DS["Twin Spire Ruins Digsite"]] = {
		continent = 3,
		map = 467,
		blob_id = 56404,
		race = RACE_DRAENEI
	},
	[DS["Warden's Cage Digsite"]] = {
		continent = 3,
		map = 473,
		blob_id = 56450,
		race = RACE_ORC
	},
	[DS["West Auchindoun Digsite"]] = {
		continent = 3,
		map = 478,
		blob_id = 56437,
		race = RACE_DRAENEI
	},
	[DS["Zeth'Gor Digsite"]] = {
		continent = 3,
		map = 465,
		blob_id = 56394,
		race = RACE_ORC
	},

	-----------------------------------------------------------------------
	-- Northrend
	-----------------------------------------------------------------------
	[DS["Altar of Quetz'lun Digsite"]] = {
		continent = 4,
		map = 496,
		blob_id = 56539,
		race = RACE_TROLL
	},
	[DS["Altar of Sseratus Digsite"]] = {
		continent = 4,
		map = 496,
		blob_id = 56533,
		race = RACE_TROLL
	},
	[DS["Baleheim Digsite"]] = {
		continent = 4,
		map = 491,
		blob_id = 56512,
		race = RACE_VRYKUL
	},
	[DS["Brunnhildar Village Digsite"]] = {
		continent = 4,
		map = 495,
		blob_id = 56549,
		race = RACE_VRYKUL
	},
	[DS["Drakil'Jin Ruins Digsite"]] = {
		continent = 4,
		map = 490,
		blob_id = 56547,
		race = RACE_TROLL
	},
	[DS["En'kilah Digsite"]] = {
		continent = 4,
		map = 486,
		blob_id = 56522,
		race = RACE_NERUBIAN
	},
	[DS["Gjalerbron Digsite"]] = {
		continent = 4,
		map = 491,
		blob_id = 56516,
		race = RACE_VRYKUL
	},
	[DS["Halgrind Digsite"]] = {
		continent = 4,
		map = 491,
		blob_id = 56506,
		race = RACE_VRYKUL
	},
	[DS["Jotunheim Digsite"]] = {
		continent = 4,
		map = 492,
		blob_id = 56562,
		race = RACE_VRYKUL
	},
	[DS["Kolramas Digsite"]] = {
		continent = 4,
		map = 496,
		blob_id = 56524,
		race = RACE_NERUBIAN
	},
	[DS["Moonrest Gardens Digsite"]] = {
		continent = 4,
		map = 488,
		blob_id = 56520,
		race = RACE_NIGHTELF
	},
	[DS["Nifflevar Digsite"]] = {
		continent = 4,
		map = 491,
		blob_id = 56514,
		race = RACE_VRYKUL
	},
	[DS["Njorndar Village Digsite"]] = {
		continent = 4,
		map = 492,
		blob_id = 56564,
		race = RACE_VRYKUL
	},
	[DS["Pit of Fiends Digsite"]] = {
		continent = 4,
		map = 492,
		blob_id = 60367,
		race = RACE_NERUBIAN
	},
	[DS["Pit of Narjun Digsite"]] = {
		continent = 4,
		map = 488,
		blob_id = 56518,
		race = RACE_NERUBIAN
	},
	[DS["Riplash Ruins Digsite"]] = {
		continent = 4,
		map = 486,
		blob_id = 56526,
		race = RACE_NIGHTELF
	},
	[DS["Ruins of Shandaral Digsite"]] = {
		continent = 4,
		map = 510,
		blob_id = 56530,
		race = RACE_NIGHTELF
	},
	[DS["Sands of Nasam"]] = {
		continent = 4,
		map = 486,
		blob_id = 60369,
		race = RACE_NERUBIAN
	},
	[DS["Scourgeholme Digsite"]] = {
		continent = 4,
		map = 492,
		blob_id = 56555,
		race = RACE_NERUBIAN
	},
	[DS["Shield Hill Digsite"]] = {
		continent = 4,
		map = 491,
		blob_id = 56510,
		race = RACE_VRYKUL
	},
	[DS["Sifreldar Village Digsite"]] = {
		continent = 4,
		map = 495,
		blob_id = 56551,
		race = RACE_VRYKUL
	},
	[DS["Skorn Digsite"]] = {
		continent = 4,
		map = 491,
		blob_id = 56504,
		race = RACE_VRYKUL
	},
	[DS["Talramas Digsite"]] = {
		continent = 4,
		map = 486,
		blob_id = 56541,
		race = RACE_NERUBIAN
	},
	[DS["Valkyrion Digsite"]] = {
		continent = 4,
		map = 495,
		blob_id = 56553,
		race = RACE_VRYKUL
	},
	[DS["Violet Stand Digsite"]] = {
		continent = 4,
		map = 510,
		blob_id = 56528,
		race = RACE_NIGHTELF
	},
	[DS["Voldrune Digsite"]] = {
		continent = 4,
		map = 490,
		blob_id = 56543,
		race = RACE_VRYKUL
	},
	[DS["Wyrmskull Digsite"]] = {
		continent = 4,
		map = 491,
		blob_id = 56508,
		race = RACE_VRYKUL
	},
	[DS["Ymirheim Digsite"]] = {
		continent = 4,
		map = 492,
		blob_id = 56560,
		race = RACE_VRYKUL
	},
	[DS["Zim'Rhuk Digsite"]] = {
		continent = 4,
		map = 496,
		blob_id = 56535,
		race = RACE_TROLL
	},
	[DS["Zol'Heb Digsite"]] = {
		continent = 4,
		map = 496,
		blob_id = 56537,
		race = RACE_TROLL
	},
}

-- Workaround for Blizzard bug with GetMapLandmarkInfo()
DIG_SITES[DS["Grimsilt Digsite"]] = DIG_SITES[DS["Grimesilt Digsite"]]

local EMPTY_DIGSITE = {
	continent = 0,
	map = 0,
	blob_id = 0,
	race = 0
}

_G.setmetatable(DIG_SITES, {
	__index = function(t, k)
		if k then
			_G.DEFAULT_CHAT_FRAME:AddMessage("Archy is missing data for dig site " .. k)
		end
		return EMPTY_DIGSITE
	end
})

private.dig_sites = DIG_SITES
