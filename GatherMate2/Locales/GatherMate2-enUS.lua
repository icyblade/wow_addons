-- GatherMate Locale
-- Please use the Localization App on WoWAce to Update this
-- http://www.wowace.com/projects/gathermate2/localization/

local debug = false
--[===[@debug@
debug = true
--@end-debug@]===]

local L = LibStub("AceLocale-3.0"):NewLocale("GatherMate2", "enUS", true, debug)

L["Add this location to Cartographer_Waypoints"] = true
L["Add this location to TomTom waypoints"] = true
L["Always show"] = true
L["Archaeology"] = true
L["Archaeology filter"] = true
L["Are you sure you want to delete all nodes from this database?"] = true
L["Are you sure you want to delete all of the selected node from the selected zone?"] = true
L["Auto Import"] = true
L["Auto import complete for addon "] = true
L["Automatically import when ever you update your data module, your current import choice will be used."] = true
L["Cataclysm"] = true
L["Cleanup Complete."] = true
L["Cleanup Database"] = true
L["Cleanup_Desc"] = "Over time, your database might become crowded. Cleaning up your database involves looking for nodes of the same profession type that are near each other and determining if they can be collapsed into a single node."
L["Cleanup radius"] = true
L["CLEANUP_RADIUS_DESC"] = "The radius in yards where duplicate nodes should be removed. The default is |cffffd20050|r yards for Extract Gas and |cffffd20015|r yards for everything else. These settings are also followed when adding nodes."
L["Cleanup your database by removing duplicates. This takes a few moments, be patient."] = true
L["Clear database selections"] = true
L["Clear node selections"] = true
L["Clear zone selections"] = true
L["Color of the tracking circle."] = true
L["Control various aspects of node icons on both the World Map and Minimap."] = true
L["Conversion_Desc"] = "Convert Existing GatherMate data to GatherMate2 format."
L["Convert Databses"] = true
L["Database locking"] = true
L["Database Locking"] = true
L["DATABASE_LOCKING_DESC"] = "The database locking feature allows you to freeze a database state. Once locked you will no longer be able to add, delete or modify the database. This includes cleanup and imports."
L["Database Maintenance"] = true
L["Databases to Import"] = true
L["Databases you wish to import"] = true
L["Delete"] = true
L["Delete Entire Database"] = true
L["DELETE_ENTIRE_DESC"] = "This will ignore Database Locking and remove all nodes from all zones from the selected database."
L["Delete selected node from selected zone"] = true
L["DELETE_SPECIFIC_DESC"] = "Remove all of the selected node from the selected zone. You must disable Database Locking for this to work."
L["Delete Specific Nodes"] = true
L["Display Settings"] = true
L["Engineering"] = true
L["Expansion"] = true
L["Expansion Data Only"] = true
L["Failed to load GatherMateData due to "] = true
L["FAQ"] = true
L["FAQ_TEXT"] = [=[|cffffd200
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
Kagaro, Xinhuan, Nevcairiel and Ammo]=]
L["Filter_Desc"] = "Select node types that you want displayed in the World and Minimap. Unselected node types will still be recorded in the database."
L["Filters"] = true
L["Fishes"] = true
L["Fish filter"] = true
L["Fishing"] = true
L["Frequently Asked Questions"] = true
L["Gas Clouds"] = true
L["Gas filter"] = true
L["GatherMate2Data has been imported."] = true
L["GatherMate Conversion"] = true
L["GatherMate data has been imported."] = true
L["GatherMateData has been imported."] = true
L["GatherMate Pin Options"] = true
L["General"] = true
L["Herbalism"] = true
L["Herb Bushes"] = true
L["Herb filter"] = true
L["Icon Alpha"] = true
L["Icon alpha value, this lets you change the transparency of the icons. Only applies on World Map."] = true
L["Icons"] = true
L["Icon Scale"] = true
L["Icon scaling, this lets you enlarge or shrink your icons on both the World Map and Minimap."] = true
L["Icon scaling, this lets you enlarge or shrink your icons on the Minimap."] = true
L["Icon scaling, this lets you enlarge or shrink your icons on the World Map."] = true
L["Import Data"] = true
L["Import GatherMate2Data"] = true
L["Import GatherMateData"] = true
L["Importing_Desc"] = "Importing allows GatherMate to get node data from other sources apart from what you find yourself in the game world. After importing data, you may need to perform a database cleanup."
L["Import Options"] = true
L["Import Style"] = true
L["Keybind to toggle Minimap Icons"] = true
L["Load GatherMate2Data and import the data to your database."] = true
L["Load GatherMateData and import the data to your database."] = true
L["Merge"] = true
L["Merge will add GatherMate2Data to your database. Overwrite will replace your database with the data in GatherMate2Data"] = true
L["Merge will add GatherMateData to your database. Overwrite will replace your database with the data in GatherMateData"] = true
L["Mine filter"] = true
L["Mineral Veins"] = true
L["Minimap Icon Scale"] = true
L["Minimap Icon Tooltips"] = true
L["Mining"] = true
L["Never show"] = true
L["Only import selected expansion data from WoWDB"] = true
L["Only import selected expansion data from WoWhead"] = true
L["Only while tracking"] = true
L["Only with digsite"] = true
L["Only with profession"] = true
L["Overwrite"] = true
L["Processing "] = true
L["Select All"] = true
L["Select all databases"] = true
L["Select all nodes"] = true
L["Select all zones"] = true
L["Select Database"] = true
L["Select Databases"] = true
L["Selected databases are shown on both the World Map and Minimap."] = true
L["Select Node"] = true
L["Select None"] = true
L["Select the archaeology nodes you wish to display."] = true
L["Select the fish nodes you wish to display."] = true
L["Select the gas clouds you wish to display."] = true
L["Select the herb nodes you wish to display."] = true
L["Select the mining nodes you wish to display."] = true
L["Select the treasure you wish to display."] = true
L["Select Zone"] = true
L["Select Zones"] = true
L["Show Archaeology Nodes"] = true
L["Show Databases"] = true
L["Show Fishing Nodes"] = true
L["Show Gas Clouds"] = true
L["Show Herbalism Nodes"] = true
L["Show Minimap Icons"] = true
L["Show Mining Nodes"] = true
L["Show Nodes on Minimap Border"] = true
L["Shows more Nodes that are currently out of range on the minimap's border."] = true
L["Show Tracking Circle"] = true
L["Show Treasure Nodes"] = true
L["Show World Map Icons"] = true
L["The Burning Crusades"] = true
L["The distance in yards to a node before it turns into a tracking circle"] = true
L["The Frozen Sea"] = true
L["The North Sea"] = true
L["Toggle showing archaeology nodes."] = true
L["Toggle showing fishing nodes."] = true
L["Toggle showing gas clouds."] = true
L["Toggle showing herbalism nodes."] = true
L["Toggle showing Minimap icons."] = true
L["Toggle showing Minimap icon tooltips."] = true
L["Toggle showing mining nodes."] = true
L["Toggle showing the tracking circle."] = true
L["Toggle showing treasure nodes."] = true
L["Toggle showing World Map icons."] = true
L["Tracking Circle Color"] = true
L["Tracking Distance"] = true
L["Treasure"] = true
L["Treasure filter"] = true
L["World Map Icon Scale"] = true
L["Wrath of the Lich King"] = true


local NL = LibStub("AceLocale-3.0"):NewLocale("GatherMate2Nodes", "enUS", true, debug)

NL["Abundant Bloodsail Wreckage"] = true
NL["Abundant Firefin Snapper School"] = true
NL["Abundant Oily Blackmouth School"] = true
NL["Adamantite Bound Chest"] = true
NL["Adamantite Deposit"] = true
NL["Adder's Tongue"] = true
NL["Albino Cavefish School"] = true
NL["Algaefin Rockfish School"] = true
NL["Ancient Lichen"] = true
NL["Arcane Vortex"] = true
NL["Arctic Cloud"] = true
NL["Arthas' Tears"] = true
NL["Azshara's Veil"] = true
NL["Battered Chest"] = true
NL["Battered Footlocker"] = true
NL["Blackbelly Mudfish School"] = true
NL["Black Lotus"] = true
NL["Black Trillium Deposit"] = true
NL["Blindweed"] = true
NL["Blood of Heroes"] = true
NL["Bloodpetal Sprout"] = true
NL["Bloodsail Wreckage"] = true
NL["Bloodthistle"] = true
NL["Bloodvine"] = true
NL["Bluefish School"] = true
NL["Borean Man O' War School"] = true
NL["Bound Adamantite Chest"] = true
NL["Bound Fel Iron Chest"] = true
NL["Brackish Mixed School"] = true
NL["Briarthorn"] = true
NL["Brightly Colored Egg"] = true
NL["Bruiseweed"] = true
NL["Buccaneer's Strongbox"] = true
NL["Burial Chest"] = true
NL["Cinderbloom"] = true
NL["Cinder Cloud"] = true
NL["Cobalt Deposit"] = true
NL["Copper Vein"] = true
NL["Dark Iron Deposit"] = true
NL["Dark Iron Treasure Chest"] = true
NL["Dart's Nest"] = true
NL["Deep Sea Monsterbelly School"] = true
NL["Deepsea Sagefish School"] = true
NL["Dented Footlocker"] = true
NL["Draenei Archaeology Find"] = true
NL["Dragonfin Angelfish School"] = true
NL["Dragon's Teeth"] = true
NL["Dreamfoil"] = true
NL["Dreaming Glory"] = true
NL["Dwarf Archaeology Find"] = true
NL["Earthroot"] = true
NL["Elementium Vein"] = true
NL["Emperor Salmon School"] = true
NL["Everfrost Chip"] = true
NL["Fadeleaf"] = true
NL["Fangtooth Herring School"] = true
NL["Fathom Eel Swarm"] = true
NL["Fel Iron Chest"] = true
NL["Fel Iron Deposit"] = true
NL["Felmist"] = true
NL["Felsteel Chest"] = true
NL["Feltail School"] = true
NL["Felweed"] = true
NL["Firebloom"] = true
NL["Firefin Snapper School"] = true
NL["Firethorn"] = true
NL["Flame Cap"] = true
NL["Floating Debris"] = true
NL["Floating Shipwreck Debris"] = true
NL["Floating Wreckage"] = true
NL["Floating Wreckage Pool"] = true
NL["Fool's Cap"] = true
NL["Fossil Archaeology Find"] = true
NL["Frost Lotus"] = true
NL["Frozen Herb"] = true
NL["Ghost Iron Deposit"] = true
NL["Ghost Mushroom"] = true
NL["Giant Clam"] = true
NL["Giant Mantis Shrimp Swarm"] = true
NL["Glacial Salmon School"] = true
NL["Glassfin Minnow School"] = true
NL["Glowcap"] = true
NL["Goldclover"] = true
NL["Golden Carp School"] = true
NL["Golden Lotus"] = true
NL["Golden Sansam"] = true
NL["Goldthorn"] = true
NL["Gold Vein"] = true
NL["Grave Moss"] = true
NL["Greater Sagefish School"] = true
NL["Green Tea Leaf"] = true
NL["Gromsblood"] = true
NL["Heartblossom"] = true
NL["Heavy Fel Iron Chest"] = true
NL["Highland Guppy School"] = true
NL["Highland Mixed School"] = true
NL["Huge Obsidian Slab"] = true
NL["Icecap"] = true
NL["Icethorn"] = true
NL["Imperial Manta Ray School"] = true
NL["Incendicite Mineral Vein"] = true
NL["Indurium Mineral Vein"] = true
NL["Iron Deposit"] = true
NL["Jade Lungfish School"] = true
NL["Khadgar's Whisker"] = true
NL["Khorium Vein"] = true
NL["Kingsblood"] = true
NL["Krasarang Paddlefish School"] = true
NL["Large Battered Chest"] = true
NL["Large Darkwood Chest"] = true
NL["Large Iron Bound Chest"] = true
NL["Large Mithril Bound Chest"] = true
NL["Large Obsidian Chunk"] = true
NL["Large Solid Chest"] = true
NL["Lesser Bloodstone Deposit"] = true
NL["Lesser Firefin Snapper School"] = true
NL["Lesser Floating Debris"] = true
NL["Lesser Oily Blackmouth School"] = true
NL["Lesser Sagefish School"] = true
NL["Lichbloom"] = true
NL["Liferoot"] = true
NL["Mageroyal"] = true
NL["Mana Thistle"] = true
NL["Maplewood Treasure Chest"] = true
NL["Mithril Deposit"] = true
NL["Mogu Archaeology Find"] = true
NL["Moonglow Cuttlefish School"] = true
NL["Mossy Footlocker"] = true
NL["Mountain Silversage"] = true
NL["Mountain Trout School"] = true
NL["Muddy Churning Water"] = true
NL["Mudfish School"] = true
NL["Musselback Sculpin School"] = true
NL["Mysterious Camel Figurine"] = true
NL["Nerubian Archaeology Find"] = true
NL["Netherbloom"] = true
NL["Nethercite Deposit"] = true
NL["Netherdust Bush"] = true
NL["Netherwing Egg"] = true
NL["Nettlefish School"] = true
NL["Night Elf Archaeology Find"] = true
NL["Nightmare Vine"] = true
NL["Obsidian Chunk"] = true
NL["Obsidium Deposit"] = true
NL["Oil Spill"] = true
NL["Oily Blackmouth School"] = true
NL["Ooze Covered Gold Vein"] = true
NL["Ooze Covered Mithril Deposit"] = true
NL["Ooze Covered Rich Thorium Vein"] = true
NL["Ooze Covered Silver Vein"] = true
NL["Ooze Covered Thorium Vein"] = true
NL["Ooze Covered Truesilver Deposit"] = true
NL["Orc Archaeology Find"] = true
NL["Other Archaeology Find"] = true
NL["Pandaren Archaeology Find"] = true
NL["Patch of Elemental Water"] = true
NL["Peacebloom"] = true
NL["Plaguebloom"] = true
NL["Pool of Fire"] = true
NL["Practice Lockbox"] = true
NL["Primitive Chest"] = true
NL["Pure Saronite Deposit"] = true
NL["Pure Water"] = true
NL["Purple Lotus"] = true
NL["Pyrite Deposit"] = true
NL["Ragveil"] = true
NL["Rain Poppy"] = true
NL["Ravasaur Matriarch's Nest"] = true
NL["Razormaw Matriarch's Nest"] = true
NL["Redbelly Mandarin School"] = true
NL["Reef Octopus Swarm"] = true
NL["Rich Adamantite Deposit"] = true
NL["Rich Cobalt Deposit"] = true
NL["Rich Elementium Vein"] = true
NL["Rich Ghost Iron Deposit"] = true
NL["Rich Obsidium Deposit"] = true
NL["Rich Pyrite Deposit"] = true
NL["Rich Saronite Deposit"] = true
NL["Rich Thorium Vein"] = true
NL["Runestone Treasure Chest"] = true
NL["Sagefish School"] = true
NL["Saronite Deposit"] = true
NL["Scarlet Footlocker"] = true
NL["School of Darter"] = true
NL["School of Deviate Fish"] = true
NL["School of Tastyfish"] = true
NL["Schooner Wreckage"] = true
NL["Sha-Touched Herb"] = true
NL["Shipwreck Debris"] = true
NL["Silken Treasure Chest"] = true
NL["Silkweed"] = true
NL["Silverbound Treasure Chest"] = true
NL["Silverleaf"] = true
NL["Silver Vein"] = true
NL["'Small Obsidian Chunk"] = true
NL["Small Obsidian Chunk"] = true
NL["Small Thorium Vein"] = true
NL["Snow Lily"] = true
NL["Solid Chest"] = true
NL["Solid Fel Iron Chest"] = true
NL["Sorrowmoss"] = true
NL["Sparse Firefin Snapper School"] = true
NL["Sparse Oily Blackmouth School"] = true
NL["Sparse Schooner Wreckage"] = true
NL["Sporefish School"] = true
NL["Steam Cloud"] = true
NL["Steam Pump Flotsam"] = true
NL["Stonescale Eel Swarm"] = true
NL["Stormvine"] = true
NL["Strange Pool"] = true
NL["Stranglekelp"] = true
NL["Sturdy Treasure Chest"] = true
NL["Sungrass"] = true
NL["Swamp Gas"] = true
NL["Takk's Nest"] = true
NL["Talandra's Rose"] = true
NL["Tattered Chest"] = true
NL["Teeming Firefin Snapper School"] = true
NL["Teeming Floating Wreckage"] = true
NL["Teeming Oily Blackmouth School"] = true
NL["Terocone"] = true
NL["Tiger Lily"] = true
NL["Tin Vein"] = true
NL["Titanium Vein"] = true
NL["Tol'vir Archaeology Find"] = true
NL["Troll Archaeology Find"] = true
NL["Truesilver Deposit"] = true
NL["Twilight Jasmine"] = true
NL["Un'Goro Dirt Pile"] = true
NL["Vrykul Archaeology Find"] = true
NL["Waterlogged Footlocker"] = true
NL["Waterlogged Wreckage"] = true
NL["Whiptail"] = true
NL["White Trillium Deposit"] = true
NL["Wicker Chest"] = true
NL["Wild Steelbloom"] = true
NL["Windy Cloud"] = true
NL["Wintersbite"] = true

