-- GatherMate Locale
-- Please use the Localization App on WoWAce to Update this
-- http://www.wowace.com/projects/gathermate2/localization

local L = LibStub("AceLocale-3.0"):NewLocale("GatherMate2", "itIT")
if not L then return end

-- L["Add this location to Cartographer_Waypoints"] = "Add this location to Cartographer_Waypoints"
-- L["Add this location to TomTom waypoints"] = "Add this location to TomTom waypoints"
L["Always show"] = "Mostra Sempre" -- Needs review
L["Archaeology"] = "Archeologia" -- Needs review
-- L["Archaeology filter"] = "Archaeology filter"
L["Are you sure you want to delete all nodes from this database?"] = "Sei sicuro di voler cancellare tutti i nodi da questo database?" -- Needs review
L["Are you sure you want to delete all of the selected node from the selected zone?"] = "Sei sicuro di voler cancellare tutti i nodi selezionati da questa zona?" -- Needs review
L["Auto Import"] = "Importa automaticamente" -- Needs review
-- L["Auto import complete for addon "] = "Auto import complete for addon "
-- L["Automatically import when ever you update your data module, your current import choice will be used."] = "Automatically import when ever you update your data module, your current import choice will be used."
-- L["Cataclysm"] = "Cataclysm"
-- L["Cleanup Complete."] = "Cleanup Complete."
-- L["Cleanup Database"] = "Cleanup Database"
-- L["Cleanup_Desc"] = "Over time, your database might become crowded. Cleaning up your database involves looking for nodes of the same profession type that are near each other and determining if they can be collapsed into a single node."
-- L["Cleanup Failed."] = "Cleanup Failed."
-- L["Cleanup in progress."] = "Cleanup in progress."
-- L["Cleanup radius"] = "Cleanup radius"
-- L["CLEANUP_RADIUS_DESC"] = "The radius in yards where duplicate nodes should be removed. The default is |cffffd20050|r yards for Extract Gas and |cffffd20015|r yards for everything else. These settings are also followed when adding nodes."
-- L["Cleanup Started."] = "Cleanup Started."
-- L["Cleanup your database by removing duplicates. This takes a few moments, be patient."] = "Cleanup your database by removing duplicates. This takes a few moments, be patient."
-- L["Clear database selections"] = "Clear database selections"
-- L["Clear node selections"] = "Clear node selections"
-- L["Clear zone selections"] = "Clear zone selections"
-- L["Click to toggle minimap icons."] = "Click to toggle minimap icons."
-- L["Color of the tracking circle."] = "Color of the tracking circle."
-- L["Control various aspects of node icons on both the World Map and Minimap."] = "Control various aspects of node icons on both the World Map and Minimap."
-- L["Conversion_Desc"] = "Convert Existing GatherMate data to GatherMate2 format."
-- L["Convert Databses"] = "Convert Databses"
-- L["Database locking"] = "Database locking"
-- L["Database Locking"] = "Database Locking"
-- L["DATABASE_LOCKING_DESC"] = "The database locking feature allows you to freeze a database state. Once locked you will no longer be able to add, delete or modify the database. This includes cleanup and imports."
-- L["Database Maintenance"] = "Database Maintenance"
-- L["Databases to Import"] = "Databases to Import"
-- L["Databases you wish to import"] = "Databases you wish to import"
-- L["Delete"] = "Delete"
-- L["Delete Entire Database"] = "Delete Entire Database"
-- L["DELETE_ENTIRE_DESC"] = "This will ignore Database Locking and remove all nodes from all zones from the selected database."
-- L["Delete selected node from selected zone"] = "Delete selected node from selected zone"
-- L["DELETE_SPECIFIC_DESC"] = "Remove all of the selected node from the selected zone. You must disable Database Locking for this to work."
-- L["Delete Specific Nodes"] = "Delete Specific Nodes"
-- L["Disabled"] = "Disabled"
-- L["Display Settings"] = "Display Settings"
-- L["Enabled"] = "Enabled"
-- L["Engineering"] = "Engineering"
-- L["Expansion"] = "Expansion"
-- L["Expansion Data Only"] = "Expansion Data Only"
-- L["Failed to load GatherMateData due to "] = "Failed to load GatherMateData due to "
-- L["FAQ"] = "FAQ"
--[==[ L["FAQ_TEXT"] = [=[|cffffd200
I just installed GatherMate, but I see no nodes on my maps. What am I doing wrong?
|r
GatherMate does not come with any data by itself. When you gather herbs, mine ore, collect gas or fish, GatherMate will then add and update your map accordingly. Also, check your Display Settings.

|cffffd200
I am seeing nodes on my World Map but not on my Minimap! What am I doing wrong now?
|r
|cffffff78Minimap Button Bag|r (and possibly other similar addons) likes to eat all the buttons we put on the Minimap. Disable them.

|cffffd200
How or where can I get existing data?
|r
You can import existing data into GatherMate in these ways:

1. |cffffff78GatherMate_Data|r - This LoD addon contains a WowHead datamined copy of all the nodes and is updated weekly. There are auto-updating options

2. |cffffff78GatherMate_CartImport|r - This addon allows you to import your existing databases in |cffffff78Cartographer_<Profession>|r modules into GatherMate. For this to work, both your |cffffff78Cartographer_<Profession>|r modules and GatherMate_CartImport must be loaded and active.

Note that importing data into GatherMate is not an automatic process. You must actively go to the Import Data section and click on the "Import" button.

This differs from |cffffff78Cartographer_Data|r in that the user is given the choice in how and when you want your data to be modified, |cffffff78Cartographer_Data|r when loaded will simply overwrite your existing databases without warning and destroy all new nodes that you have found.

|cffffd200
Can you add support for showing the locations of things like mailboxes and flightmasters?
|r
The answer is no. However, another addon author could create an addon or module for this purpose, the core GatherMate addon will not do this.

|cffffd200
I've found a bug! Where do I report it?
|r
You can report bugs or give suggestions at |cffffff78http://www.wowace.com/forums/index.php?topic=10990.0|r

Alternatively, you can also find us on |cffffff78irc://irc.freenode.org/wowace|r

When reporting a bug, make sure you include the |cffffff78steps on how to reproduce the bug|r, supply any |cffffff78error messages|r with stack traces if possible, give the |cffffff78revision number|r of GatherMate the problem occured in and state whether you are using an |cffffff78English client or otherwise|r.

|cffffd200
Who wrote this cool addon?
|r
Kagaro, Xinhuan, Nevcairiel and Ammo]=] ]==]
-- L["Filter_Desc"] = "Select node types that you want displayed in the World and Minimap. Unselected node types will still be recorded in the database."
-- L["Filters"] = "Filters"
-- L["Fishes"] = "Fishes"
-- L["Fish filter"] = "Fish filter"
-- L["Fishing"] = "Fishing"
-- L["Frequently Asked Questions"] = "Frequently Asked Questions"
-- L["Gas Clouds"] = "Gas Clouds"
-- L["Gas filter"] = "Gas filter"
-- L["GatherMate2Data has been imported."] = "GatherMate2Data has been imported."
-- L["GatherMate Conversion"] = "GatherMate Conversion"
-- L["GatherMate data has been imported."] = "GatherMate data has been imported."
-- L["GatherMateData has been imported."] = "GatherMateData has been imported."
-- L["GatherMate Pin Options"] = "GatherMate Pin Options"
-- L["General"] = "General"
-- L["Herbalism"] = "Herbalism"
-- L["Herb Bushes"] = "Herb Bushes"
-- L["Herb filter"] = "Herb filter"
-- L["Icon Alpha"] = "Icon Alpha"
-- L["Icon alpha value, this lets you change the transparency of the icons. Only applies on World Map."] = "Icon alpha value, this lets you change the transparency of the icons. Only applies on World Map."
-- L["Icons"] = "Icons"
-- L["Icon Scale"] = "Icon Scale"
-- L["Icon scaling, this lets you enlarge or shrink your icons on both the World Map and Minimap."] = "Icon scaling, this lets you enlarge or shrink your icons on both the World Map and Minimap."
-- L["Icon scaling, this lets you enlarge or shrink your icons on the Minimap."] = "Icon scaling, this lets you enlarge or shrink your icons on the Minimap."
-- L["Icon scaling, this lets you enlarge or shrink your icons on the World Map."] = "Icon scaling, this lets you enlarge or shrink your icons on the World Map."
-- L["Import Data"] = "Import Data"
-- L["Import GatherMate2Data"] = "Import GatherMate2Data"
-- L["Import GatherMateData"] = "Import GatherMateData"
-- L["Importing_Desc"] = "Importing allows GatherMate to get node data from other sources apart from what you find yourself in the game world. After importing data, you may need to perform a database cleanup."
-- L["Import Options"] = "Import Options"
-- L["Import Style"] = "Import Style"
-- L["Keybind to toggle Minimap Icons"] = "Keybind to toggle Minimap Icons"
-- L["Keybind to toggle Worldmap Icons"] = "Keybind to toggle Worldmap Icons"
-- L["Load GatherMate2Data and import the data to your database."] = "Load GatherMate2Data and import the data to your database."
-- L["Load GatherMateData and import the data to your database."] = "Load GatherMateData and import the data to your database."
L["Merge"] = "Unisci" -- Needs review
-- L["Merge will add GatherMate2Data to your database. Overwrite will replace your database with the data in GatherMate2Data"] = "Merge will add GatherMate2Data to your database. Overwrite will replace your database with the data in GatherMate2Data"
-- L["Merge will add GatherMateData to your database. Overwrite will replace your database with the data in GatherMateData"] = "Merge will add GatherMateData to your database. Overwrite will replace your database with the data in GatherMateData"
-- L["Mine filter"] = "Mine filter"
-- L["Mineral Veins"] = "Mineral Veins"
-- L["Minimap Icons"] = "Minimap Icons"
-- L["Minimap Icon Scale"] = "Minimap Icon Scale"
-- L["Minimap Icon Tooltips"] = "Minimap Icon Tooltips"
L["Mining"] = "Estrazione" -- Needs review
-- L["Mists of Pandaria"] = "Mists of Pandaria"
L["Never show"] = "Non mostrare mai" -- Needs review
L["Only import selected expansion data from WoWDB"] = "Importa solo i dati delle espansioni selezionate da WoWDB" -- Needs review
L["Only import selected expansion data from WoWhead"] = "Importa solo i dati delle espansioni selezionate da WoWhead" -- Needs review
L["Only while tracking"] = "Solo in Tracciamento" -- Needs review
-- L["Only with digsite"] = "Only with digsite"
L["Only with profession"] = "Solo con la professione" -- Needs review
L["Overwrite"] = "Sovrascrivi" -- Needs review
-- L["Processing "] = "Processing "
-- L["Right-click for options."] = "Right-click for options."
L["Select All"] = "Seleziona tutto" -- Needs review
L["Select all databases"] = "Seleziona tutti i database" -- Needs review
L["Select all nodes"] = "Seleziona tutti i nodi" -- Needs review
L["Select all zones"] = "Seleziona tutte le zone" -- Needs review
L["Select Database"] = "Seleziona Database" -- Needs review
L["Select Databases"] = "Seleziona i database" -- Needs review
-- L["Selected databases are shown on both the World Map and Minimap."] = "Selected databases are shown on both the World Map and Minimap."
L["Select Node"] = "Seleziona Nodo" -- Needs review
L["Select None"] = "Cancella la selezione" -- Needs review
L["Select the archaeology nodes you wish to display."] = "Seleziona i nodi di archeologia che vuoi mostrare" -- Needs review
L["Select the fish nodes you wish to display."] = "Seleziona i nodi di pesca che vuoi mostrare" -- Needs review
-- L["Select the gas clouds you wish to display."] = "Select the gas clouds you wish to display."
-- L["Select the herb nodes you wish to display."] = "Select the herb nodes you wish to display."
-- L["Select the mining nodes you wish to display."] = "Select the mining nodes you wish to display."
-- L["Select the treasure you wish to display."] = "Select the treasure you wish to display."
L["Select Zone"] = "Seleziona Zona" -- Needs review
L["Select Zones"] = "Seleziona le zone" -- Needs review
-- L["Shift-click to toggle world map icons."] = "Shift-click to toggle world map icons."
L["Show Archaeology Nodes"] = "Mostra i nodi di archeologia" -- Needs review
-- L["Show Databases"] = "Show Databases"
-- L["Show Fishing Nodes"] = "Show Fishing Nodes"
-- L["Show Gas Clouds"] = "Show Gas Clouds"
-- L["Show Herbalism Nodes"] = "Show Herbalism Nodes"
-- L["Show Minimap Icons"] = "Show Minimap Icons"
L["Show Mining Nodes"] = "Mostra nodi di estrazione" -- Needs review
L["Show Nodes on Minimap Border"] = "Mostra i nodi sul bordo della minimappa" -- Needs review
L["Shows more Nodes that are currently out of range on the minimap's border."] = "Mostra più nodi che al momento sono fuori portata sul bordo della minimappa" -- Needs review
-- L["Show Timber Nodes"] = "Show Timber Nodes"
L["Show Tracking Circle"] = "Mostra il cerchio di tracciamento" -- Needs review
L["Show Treasure Nodes"] = "Mostra i nodi dei tesori" -- Needs review
L["Show World Map Icons"] = "Mostra le icone sulla World Map" -- Needs review
-- L["The Burning Crusades"] = "The Burning Crusades"
-- L["The distance in yards to a node before it turns into a tracking circle"] = "The distance in yards to a node before it turns into a tracking circle"
-- L["The Frozen Sea"] = "The Frozen Sea"
-- L["The North Sea"] = "The North Sea"
-- L["Toggle showing archaeology nodes."] = "Toggle showing archaeology nodes."
-- L["Toggle showing fishing nodes."] = "Toggle showing fishing nodes."
-- L["Toggle showing gas clouds."] = "Toggle showing gas clouds."
-- L["Toggle showing herbalism nodes."] = "Toggle showing herbalism nodes."
-- L["Toggle showing Minimap icons."] = "Toggle showing Minimap icons."
-- L["Toggle showing Minimap icon tooltips."] = "Toggle showing Minimap icon tooltips."
-- L["Toggle showing mining nodes."] = "Toggle showing mining nodes."
-- L["Toggle showing the tracking circle."] = "Toggle showing the tracking circle."
-- L["Toggle showing timber nodes."] = "Toggle showing timber nodes."
-- L["Toggle showing treasure nodes."] = "Toggle showing treasure nodes."
-- L["Toggle showing World Map icons."] = "Toggle showing World Map icons."
-- L["Tracking Circle Color"] = "Tracking Circle Color"
-- L["Tracking Distance"] = "Tracking Distance"
-- L["Treasure"] = "Treasure"
-- L["Treasure filter"] = "Treasure filter"
-- L["Warlords of Draenor"] = "Warlords of Draenor"
-- L["World Map Icons"] = "World Map Icons"
-- L["World Map Icon Scale"] = "World Map Icon Scale"
-- L["Wrath of the Lich King"] = "Wrath of the Lich King"


local NL = LibStub("AceLocale-3.0"):NewLocale("GatherMate2Nodes", "itIT")
if not NL then return end

-- NL["Abundant Bloodsail Wreckage"] = "Abundant Bloodsail Wreckage"
-- NL["Abundant Firefin Snapper School"] = "Abundant Firefin Snapper School"
-- NL["Abundant Oily Blackmouth School"] = "Abundant Oily Blackmouth School"
-- NL["Abyssal Gulper School"] = "Abyssal Gulper School"
-- NL["Adamantite Bound Chest"] = "Adamantite Bound Chest"
-- NL["Adamantite Deposit"] = "Adamantite Deposit"
NL["Adder's Tongue"] = "Lingua di vipera" -- Needs review
-- NL["Albino Cavefish School"] = "Albino Cavefish School"
-- NL["Algaefin Rockfish School"] = "Algaefin Rockfish School"
NL["Ancient Lichen"] = "Lichene Antico" -- Needs review
-- NL["Arakkoa Archaeology Find"] = "Arakkoa Archaeology Find"
-- NL["Arcane Vortex"] = "Arcane Vortex"
-- NL["Arctic Cloud"] = "Arctic Cloud"
NL["Arthas' Tears"] = "Lacrima di Arthas" -- Needs review
NL["Azshara's Veil"] = "Velo di Azshara" -- Needs review
-- NL["Battered Chest"] = "Battered Chest"
-- NL["Battered Footlocker"] = "Battered Footlocker"
-- NL["Blackbelly Mudfish School"] = "Blackbelly Mudfish School"
NL["Black Lotus"] = "Fiore di Loto Nero" -- Needs review
-- NL["Blackrock Deposit"] = "Blackrock Deposit"
-- NL["Black Trillium Deposit"] = "Black Trillium Deposit"
-- NL["Blackwater Whiptail School"] = "Blackwater Whiptail School"
-- NL["Blind Lake Sturgeon School"] = "Blind Lake Sturgeon School"
NL["Blindweed"] = "Erbacieca" -- Needs review
-- NL["Blood of Heroes"] = "Blood of Heroes"
-- NL["Bloodpetal Sprout"] = "Bloodpetal Sprout"
-- NL["Bloodsail Wreckage"] = "Bloodsail Wreckage"
NL["Bloodsail Wreckage Pool"] = "Rottami dei Velerosse" -- Needs review
-- NL["Bloodthistle"] = "Bloodthistle"
-- NL["Bloodvine"] = "Bloodvine"
-- NL["Bluefish School"] = "Bluefish School"
NL["Borean Man O' War School"] = "Banco di Meduse Boreali" -- Needs review
-- NL["Bound Adamantite Chest"] = "Bound Adamantite Chest"
-- NL["Bound Fel Iron Chest"] = "Bound Fel Iron Chest"
-- NL["Brackish Mixed School"] = "Brackish Mixed School"
NL["Briarthorn"] = "Grandespina" -- Needs review
-- NL["Brightly Colored Egg"] = "Brightly Colored Egg"
NL["Bruiseweed"] = "Erbalivida" -- Needs review
-- NL["Buccaneer's Strongbox"] = "Buccaneer's Strongbox"
-- NL["Burial Chest"] = "Burial Chest"
NL["Cinderbloom"] = "Sbocciacenere" -- Needs review
-- NL["Cinder Cloud"] = "Cinder Cloud"
NL["Cobalt Deposit"] = "Deposito di Cobalto" -- Needs review
NL["Copper Vein"] = "Vena di Rame" -- Needs review
-- NL["Dark Iron Deposit"] = "Dark Iron Deposit"
-- NL["Dark Iron Treasure Chest"] = "Dark Iron Treasure Chest"
-- NL["Dark Soil"] = "Dark Soil"
-- NL["Dart's Nest"] = "Dart's Nest"
-- NL["Deep Sea Monsterbelly School"] = "Deep Sea Monsterbelly School"
-- NL["Deepsea Sagefish School"] = "Deepsea Sagefish School"
-- NL["Dented Footlocker"] = "Dented Footlocker"
-- NL["Draenei Archaeology Find"] = "Draenei Archaeology Find"
-- NL["Draenor Clans Archaeology Find"] = "Draenor Clans Archaeology Find"
NL["Dragonfin Angelfish School"] = "Banco di Pesci Angelo Pinnadrago" -- Needs review
-- NL["Dragon's Teeth"] = "Dragon's Teeth"
NL["Dreamfoil"] = "Foglia Onirica" -- Needs review
-- NL["Dreaming Glory"] = "Dreaming Glory"
NL["Dwarf Archaeology Find"] = "Scoperta Archeologica Nanica" -- Needs review
NL["Earthroot"] = "Bulboterro" -- Needs review
-- NL["Elementium Vein"] = "Elementium Vein"
-- NL["Emperor Salmon School"] = "Emperor Salmon School"
-- NL["Everfrost Chip"] = "Everfrost Chip"
NL["Fadeleaf"] = "Foglia Eterea" -- Needs review
NL["Fangtooth Herring School"] = "Banco di Aringhe Zannute" -- Needs review
-- NL["Fathom Eel Swarm"] = "Fathom Eel Swarm"
-- NL["Fat Sleeper School"] = "Fat Sleeper School"
-- NL["Fel Iron Chest"] = "Fel Iron Chest"
-- NL["Fel Iron Deposit"] = "Fel Iron Deposit"
-- NL["Felmist"] = "Felmist"
-- NL["Felmouth Frenzy School"] = "Felmouth Frenzy School"
-- NL["Felsteel Chest"] = "Felsteel Chest"
-- NL["Feltail School"] = "Feltail School"
-- NL["Felweed"] = "Felweed"
-- NL["Fire Ammonite School"] = "Fire Ammonite School"
NL["Firebloom"] = "Sbocciafuoco" -- Needs review
-- NL["Firefin Snapper School"] = "Firefin Snapper School"
-- NL["Firethorn"] = "Firethorn"
-- NL["Fireweed"] = "Fireweed"
NL["Flame Cap"] = "Corolla Infernale" -- Needs review
-- NL["Floating Debris"] = "Floating Debris"
-- NL["Floating Debris Pool"] = "Floating Debris Pool"
-- NL["Floating Shipwreck Debris"] = "Floating Shipwreck Debris"
NL["Floating Wreckage"] = "Rottami Galleggianti" -- Needs review
-- NL["Floating Wreckage Pool"] = "Floating Wreckage Pool"
-- NL["Fool's Cap"] = "Fool's Cap"
NL["Fossil Archaeology Find"] = "Scoperta Archeologica Fossile" -- Needs review
-- NL["Frost Lotus"] = "Frost Lotus"
-- NL["Frostweed"] = "Frostweed"
-- NL["Frozen Herb"] = "Frozen Herb"
NL["Ghost Iron Deposit"] = "Deposito di Ectoferro"
NL["Ghost Mushroom"] = "Fungo Fantasma" -- Needs review
-- NL["Giant Clam"] = "Giant Clam"
-- NL["Giant Mantis Shrimp Swarm"] = "Giant Mantis Shrimp Swarm"
-- NL["Glacial Salmon School"] = "Glacial Salmon School"
NL["Glassfin Minnow School"] = "Banco di Pesci di Vetro" -- Needs review
-- NL["Gleaming Draenic Chest"] = "Gleaming Draenic Chest"
-- NL["Glowcap"] = "Glowcap"
-- NL["Goldclover"] = "Goldclover"
NL["Golden Carp School"] = "Banco di Carpe Dorate" -- Needs review
-- NL["Golden Lotus"] = "Golden Lotus"
NL["Golden Sansam"] = "Sansam Dorato" -- Needs review
NL["Goldthorn"] = "Orospino" -- Needs review
NL["Gold Vein"] = "Vena d'Oro" -- Needs review
-- NL["Gorgrond Flytrap"] = "Gorgrond Flytrap"
NL["Grave Moss"] = "Muschio di Tomba" -- Needs review
NL["Greater Sagefish School"] = "Banco di Gran Pescisalvia" -- Needs review
-- NL["Green Tea Leaf"] = "Green Tea Leaf"
NL["Gromsblood"] = "Sangue di Grom" -- Needs review
-- NL["Heartblossom"] = "Heartblossom"
-- NL["Heavy Fel Iron Chest"] = "Heavy Fel Iron Chest"
-- NL["Highland Guppy School"] = "Highland Guppy School"
-- NL["Highland Mixed School"] = "Highland Mixed School"
-- NL["Highmaul Reliquary"] = "Highmaul Reliquary"
-- NL["Huge Obsidian Slab"] = "Huge Obsidian Slab"
NL["Icecap"] = "Corolla Invernale" -- Needs review
-- NL["Icethorn"] = "Icethorn"
NL["Imperial Manta Ray School"] = "Banco di Mante Imperiali" -- Needs review
-- NL["Incendicite Mineral Vein"] = "Incendicite Mineral Vein"
-- NL["Indurium Mineral Vein"] = "Indurium Mineral Vein"
NL["Iron Deposit"] = "Deposito di Ferro" -- Needs review
-- NL["Jade Lungfish School"] = "Jade Lungfish School"
-- NL["Jawless Skulker School"] = "Jawless Skulker School"
-- NL["Jewel Danio School"] = "Jewel Danio School"
NL["Khadgar's Whisker"] = "Ciuffo di Khadgar" -- Needs review
-- NL["Khorium Vein"] = "Khorium Vein"
NL["Kingsblood"] = "Sanguesacro" -- Needs review
-- NL["Krasarang Paddlefish School"] = "Krasarang Paddlefish School"
NL["Kyparite Deposit"] = "Deposito di Kyparite" -- Needs review
-- NL["Lagoon Pool"] = "Lagoon Pool"
-- NL["Large Battered Chest"] = "Large Battered Chest"
-- NL["Large Darkwood Chest"] = "Large Darkwood Chest"
-- NL["Large Iron Bound Chest"] = "Large Iron Bound Chest"
-- NL["Large Mithril Bound Chest"] = "Large Mithril Bound Chest"
-- NL["Large Obsidian Chunk"] = "Large Obsidian Chunk"
-- NL["Large Solid Chest"] = "Large Solid Chest"
-- NL["Large Timber"] = "Large Timber"
-- NL["Lesser Bloodstone Deposit"] = "Lesser Bloodstone Deposit"
-- NL["Lesser Firefin Snapper School"] = "Lesser Firefin Snapper School"
-- NL["Lesser Floating Debris"] = "Lesser Floating Debris"
-- NL["Lesser Oily Blackmouth School"] = "Lesser Oily Blackmouth School"
-- NL["Lesser Sagefish School"] = "Lesser Sagefish School"
-- NL["Lichbloom"] = "Lichbloom"
NL["Liferoot"] = "Bulbovivo" -- Needs review
-- NL["Lumber Mill"] = "Lumber Mill"
NL["Mageroyal"] = "Magareale" -- Needs review
-- NL["Mana Thistle"] = "Mana Thistle"
-- NL["Mantid Archaeology Find"] = "Mantid Archaeology Find"
-- NL["Maplewood Treasure Chest"] = "Maplewood Treasure Chest"
NL["Mithril Deposit"] = "Deposito di Mithril" -- Needs review
-- NL["Mixed Ocean School"] = "Mixed Ocean School"
-- NL["Mogu Archaeology Find"] = "Mogu Archaeology Find"
-- NL["Moonglow Cuttlefish School"] = "Moonglow Cuttlefish School"
-- NL["Mossy Footlocker"] = "Mossy Footlocker"
NL["Mountain Silversage"] = "Ramargento Montano" -- Needs review
-- NL["Mountain Trout School"] = "Mountain Trout School"
-- NL["Muddy Churning Water"] = "Muddy Churning Water"
-- NL["Mudfish School"] = "Mudfish School"
NL["Musselback Sculpin School"] = "Banco di Dragonetti" -- Needs review
-- NL["Mysterious Camel Figurine"] = "Mysterious Camel Figurine"
-- NL["Nagrand Arrowbloom"] = "Nagrand Arrowbloom"
NL["Nerubian Archaeology Find"] = "Scoperta Archeologica Nerubiana" -- Needs review
-- NL["Netherbloom"] = "Netherbloom"
-- NL["Nethercite Deposit"] = "Nethercite Deposit"
-- NL["Netherdust Bush"] = "Netherdust Bush"
-- NL["Netherwing Egg"] = "Netherwing Egg"
NL["Nettlefish School"] = "Banco di Ragnoli" -- Needs review
NL["Night Elf Archaeology Find"] = "Ritrovamento Archeologico Elfico" -- Needs review
-- NL["Nightmare Vine"] = "Nightmare Vine"
-- NL["Obsidian Chunk"] = "Obsidian Chunk"
NL["Obsidium Deposit"] = "Deposito d'Obsidio" -- Needs review
-- NL["Ogre Archaeology Find"] = "Ogre Archaeology Find"
-- NL["Oil Spill"] = "Oil Spill"
-- NL["Oily Abyssal Gulper School"] = "Oily Abyssal Gulper School"
NL["Oily Blackmouth School"] = "Banco di Boccanera Oleosi" -- Needs review
-- NL["Oily Sea Scorpion School"] = "Oily Sea Scorpion School"
-- NL["Onyx Egg"] = "Onyx Egg"
-- NL["Ooze Covered Gold Vein"] = "Ooze Covered Gold Vein"
-- NL["Ooze Covered Mithril Deposit"] = "Ooze Covered Mithril Deposit"
-- NL["Ooze Covered Rich Thorium Vein"] = "Ooze Covered Rich Thorium Vein"
-- NL["Ooze Covered Silver Vein"] = "Ooze Covered Silver Vein"
-- NL["Ooze Covered Thorium Vein"] = "Ooze Covered Thorium Vein"
-- NL["Ooze Covered Truesilver Deposit"] = "Ooze Covered Truesilver Deposit"
NL["Orc Archaeology Find"] = "Scoperta Archeologica Orchesca" -- Needs review
-- NL["Other Archaeology Find"] = "Other Archaeology Find"
-- NL["Pandaren Archaeology Find"] = "Pandaren Archaeology Find"
-- NL["Patch of Elemental Water"] = "Patch of Elemental Water"
NL["Peacebloom"] = "Sbocciapace" -- Needs review
-- NL["Plaguebloom"] = "Plaguebloom"
-- NL["Pool of Fire"] = "Pool of Fire"
-- NL["Practice Lockbox"] = "Practice Lockbox"
-- NL["Primitive Chest"] = "Primitive Chest"
-- NL["Pure Saronite Deposit"] = "Pure Saronite Deposit"
-- NL["Pure Water"] = "Pure Water"
NL["Purple Lotus"] = "Fiore di Loto Purpureo" -- Needs review
-- NL["Pyrite Deposit"] = "Pyrite Deposit"
-- NL["Radiating Apexis Shard"] = "Radiating Apexis Shard"
NL["Ragveil"] = "Velorotto" -- Needs review
NL["Rain Poppy"] = "Papavero" -- Needs review
-- NL["Ravasaur Matriarch's Nest"] = "Ravasaur Matriarch's Nest"
-- NL["Razormaw Matriarch's Nest"] = "Razormaw Matriarch's Nest"
NL["Redbelly Mandarin School"] = "Banco di Panciarossa Mandarini" -- Needs review
NL["Reef Octopus Swarm"] = "Banco di Polpi di Scogliera" -- Needs review
NL["Rich Adamantite Deposit"] = "Deposito Ricco di Adamantite" -- Needs review
-- NL["Rich Blackrock Deposit"] = "Rich Blackrock Deposit"
NL["Rich Cobalt Deposit"] = "Deposito Ricco di Cobalto" -- Needs review
NL["Rich Elementium Vein"] = "Vena Ricca di Elementio" -- Needs review
NL["Rich Ghost Iron Deposit"] = "Deposito Ricco di Ectoferro" -- Needs review
NL["Rich Kyparite Deposit"] = "Deposito Ricco di Kyparite" -- Needs review
-- NL["Rich Obsidium Deposit"] = "Rich Obsidium Deposit"
-- NL["Rich Pyrite Deposit"] = "Rich Pyrite Deposit"
NL["Rich Saronite Deposit"] = "Deposito Ricco di Saronite" -- Needs review
NL["Rich Thorium Vein"] = "Vena Ricca di Torio" -- Needs review
NL["Rich Trillium Vein"] = "Vena Ricca di Trillio" -- Needs review
-- NL["Rich True Iron Deposit"] = "Rich True Iron Deposit"
-- NL["Runestone Treasure Chest"] = "Runestone Treasure Chest"
NL["Sagefish School"] = "Banco di Pescisalvia" -- Needs review
NL["Saronite Deposit"] = "Deposito di Saronite" -- Needs review
-- NL["Savage Piranha Pool"] = "Savage Piranha Pool"
-- NL["Scarlet Footlocker"] = "Scarlet Footlocker"
-- NL["School of Darter"] = "School of Darter"
-- NL["School of Deviate Fish"] = "School of Deviate Fish"
-- NL["School of Tastyfish"] = "School of Tastyfish"
-- NL["Schooner Wreckage"] = "Schooner Wreckage"
-- NL["Schooner Wreckage Pool"] = "Schooner Wreckage Pool"
-- NL["Sea Scorpion School"] = "Sea Scorpion School"
-- NL["Sha-Touched Herb"] = "Sha-Touched Herb"
-- NL["Shipwreck Debris"] = "Shipwreck Debris"
NL["Silken Treasure Chest"] = "Cassa del Tesoro di Seta" -- Needs review
-- NL["Silkweed"] = "Silkweed"
NL["Silverbound Treasure Chest"] = "Cassa del Tesoro Rinforzata in Argento" -- Needs review
NL["Silverleaf"] = "Fogliargenta" -- Needs review
NL["Silver Vein"] = "Vena d'Argento" -- Needs review
-- NL["Small Obsidian Chunk"] = "Small Obsidian Chunk"
NL["Small Thorium Vein"] = "Vena Piccola di Torio" -- Needs review
-- NL["Small Timber"] = "Small Timber"
NL["Snow Lily"] = "Giglio della Neve" -- Needs review
-- NL["Solid Chest"] = "Solid Chest"
-- NL["Solid Fel Iron Chest"] = "Solid Fel Iron Chest"
NL["Sorrowmoss"] = "Muschiocupo" -- Needs review
-- NL["Sparkling Pool"] = "Sparkling Pool"
-- NL["Sparse Firefin Snapper School"] = "Sparse Firefin Snapper School"
-- NL["Sparse Oily Blackmouth School"] = "Sparse Oily Blackmouth School"
-- NL["Sparse Schooner Wreckage"] = "Sparse Schooner Wreckage"
-- NL["Spinefish School"] = "Spinefish School"
-- NL["Sporefish School"] = "Sporefish School"
-- NL["Starflower"] = "Starflower"
-- NL["Steam Cloud"] = "Steam Cloud"
-- NL["Steam Pump Flotsam"] = "Steam Pump Flotsam"
NL["Stonescale Eel Swarm"] = "Banco di Anguille Squamapietra" -- Needs review
NL["Stormvine"] = "Vite Tempestosa" -- Needs review
-- NL["Strange Pool"] = "Strange Pool"
NL["Stranglekelp"] = "Algatorta" -- Needs review
NL["Sturdy Treasure Chest"] = "Robusto Baule del Tesoro" -- Needs review
NL["Sungrass"] = "Erbasole" -- Needs review
-- NL["Suspiciously Glowing Chest"] = "Suspiciously Glowing Chest"
-- NL["Swamp Gas"] = "Swamp Gas"
-- NL["Takk's Nest"] = "Takk's Nest"
-- NL["Talador Orchid"] = "Talador Orchid"
NL["Talandra's Rose"] = "Rosa di Talandra" -- Needs review
-- NL["Tattered Chest"] = "Tattered Chest"
-- NL["Teeming Firefin Snapper School"] = "Teeming Firefin Snapper School"
-- NL["Teeming Floating Wreckage"] = "Teeming Floating Wreckage"
-- NL["Teeming Oily Blackmouth School"] = "Teeming Oily Blackmouth School"
-- NL["Terocone"] = "Terocone"
-- NL["Tiger Gourami School"] = "Tiger Gourami School"
NL["Tiger Lily"] = "Giglio Tigrato" -- Needs review
-- NL["Timber"] = "Timber"
NL["Tin Vein"] = "Vena di Stagno" -- Needs review
NL["Titanium Vein"] = "Vena di Titanio" -- Needs review
-- NL["Tol'vir Archaeology Find"] = "Tol'vir Archaeology Find"
NL["Trillium Vein"] = "Vena di Trillio" -- Needs review
NL["Troll Archaeology Find"] = "Scoperta Archeologica Troll" -- Needs review
-- NL["Trove of the Thunder King"] = "Trove of the Thunder King"
-- NL["True Iron Deposit"] = "True Iron Deposit"
NL["Truesilver Deposit"] = "Deposito di Verargento" -- Needs review
NL["Twilight Jasmine"] = "Gelsomino del Crepuscolo" -- Needs review
-- NL["Un'Goro Dirt Pile"] = "Un'Goro Dirt Pile"
NL["Vrykul Archaeology Find"] = "Scoperta Archeologica Vrykul" -- Needs review
-- NL["Waterlogged Footlocker"] = "Waterlogged Footlocker"
-- NL["Waterlogged Wreckage"] = "Waterlogged Wreckage"
-- NL["Waterlogged Wreckage Pool"] = "Waterlogged Wreckage Pool"
NL["Whiptail"] = "Frustaliana" -- Needs review
-- NL["White Trillium Deposit"] = "White Trillium Deposit"
-- NL["Wicker Chest"] = "Wicker Chest"
-- NL["Wild Steelbloom"] = "Wild Steelbloom"
-- NL["Windy Cloud"] = "Windy Cloud"
-- NL["Wintersbite"] = "Wintersbite"
-- NL["Withered Herb"] = "Withered Herb"

