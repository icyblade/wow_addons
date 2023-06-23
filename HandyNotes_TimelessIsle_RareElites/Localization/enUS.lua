local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)
local L = {}

L.OptionsDescription = "Locations of RareElites on Timeless Isle."
L.OptionsArgsDescription = "These settings control the look and feel of the icon."
L.OptionsIconScaleName = "Icon Scale"
L.OptionsIconScaleDescription = "The scale of the icons"
L.OptionsIconAlphaName = "Icon Alpha"
L.OptionsIconAlphaDescription = "The alpha transparency of the icons"

L.EmeralGander = "Emeral Gander"
L.EmeralGanderDrop = "Windfeather Plume"
L.EmeralGanderInfo = "spawns at various locations around the Celestial Court."

L.IronfurSteelhorn = "Ironfur Steelhorn"
L.IronfurSteelhornDrop = "Tuft of Yak Fur"

L.ImperialPython = "Imperial Python"
L.ImperialPythonDrop = "Death Adder Hatchling"

L.GreatTurtleFuryshell = "Great Turtle Furyshell"
L.GreatTurtleFuryshellDrop = "Hardened Shell"
L.GreatTurtleFuryshellInfo = "patrols among the turtles on the western shore of the island."

L.GuchiSwarmbringer = "Gu'chi the Swarmbringer"
L.GuchiSwarmbringerDrop = "Swarmling of Gu'chi"
L.GuchiSwarmbringerInfo = "spawns around Old Pi'Jiu."

L.Zesqua = "Zesqua"
L.ZesquaDrop = "Rain Stone"
L.ZesquaInfo = "spawns off the coast of Pi'Jiu, slightly to the east."

L.ZhuGonSour = "Zhu-Gon the Sour"
L.ZhuGonSourDrop = "Skunky Alemental"
L.ZhuGonSourInfo = "spawns after completing the Skunky Beer mini-event at the same location."

L.Karkanos = "Karkanos"
L.KarkanosDrop = "Giant Purse of Timeless Coins"
L.KarkanosInfo = "is summoned by talking to Fin Longpaw."

L.Chelon = "Chelon"
L.ChelonDrop = "Hardened Shell"
L.ChelonInfo = "spawns after you inspect the shell."

L.Spelurk = "Spelurk"
L.SpelurkDrop = "Cursed Talisman"
L.SpelurkInfo = "can be summoned by breaking the cave-in of the Mysterious Den. You can break the cave-in by using the new action button you get from finding and opening the objects of Timeless Legends Icon Timeless Legends. Alternatively, a Mage with Blink Icon Blink can teleport to the other side of the wall and use the hammer inside the cave to destroy the wall."

L.Cranegnasher = "Cranegnasher"
L.CranegnasherDrop = "Pristine Stalker Hide"
L.CranegnasherInfo = "needs to be summoned. You will find the corpse of a dead Fishgorged Crane. Inspecting the corpse indicates that these cranes are the favorite food of a creature. This means that you need to kite a live Fishgorged Crane onto the corpse to summon Cranegnasher (you will find these ads just south of the corpse)."

L.Rattleskew = "Rattleskew"
L.RattleskewDrop = "Captain Zvezdan's Lost Leg"
L.RattleskewInfo = "spawns in Tsavoka's Den."

L.MonstrousSpineclaw = "Monstrous Spineclaw"
L.MonstrousSpineclawDrop = "Spineclaw Crab"
L.MonstrousSpineclawInfo = "patrols underwater, off the southern coast of the island."

L.SpiritJadefire = "Spirit of Jadefire"
L.SpiritJadefireDrop = "Glowing Green Ash"
L.SpiritJadefireDrop2 = "Jadefire Spirit"
L.SpiritJadefireInfo = "spawns inside the Caverns of Lost Spirits in the recess on the right, almost facing Zarhym."

L.Leafmender = "Leafmender"
L.LeafmenderDrop = "Ashleaf Spriteling"
L.LeafmenderInfo = "spawns in the Blazing Way, around the tree."

L.Bufo = "Bufo"
L.BufoDrop = "Gulp Froglet"
L.BufoInfo = "spawns in the area filled with Gulp Frogs."

L.Garnia = "Garnia"
L.GarniaDrop = "Ruby Droplet"
L.GarniaInfo = "spawns in the Red Lake."

L.Tsavoka = "Tsavo'ka"
L.TsavokaDrop = "Pristine Stalker Hide"
L.TsavokaInfo = "spawns in Tsavoka's Den."

L.Stinkbraid = "Stinkbraid"
L.StinkbraidInfo = "spawns on the deck of the pirate ship."

L.RockMoss = "Rock Moss"
L.RockMossDrop = "Golden Moss"
L.RockMossInfo = "spawns at the bottom of the Cavern of Lost Spirits."

L.WatcherOsu = "Watcher Osu"
L.WatcherOsuDrop = "Ashen Stone"
L.WatcherOsuInfo = "spawns in the Firewalker Ruins."

L.JakurOrdon = "Jakur of Ordon"
L.JakurOrdonDrop = "Warning Sign"
L.JakurOrdonInfo = "Jakur of Ordon."

L.ChampionBlackFlame = "Champion of the Black Flame"
L.ChampionBlackFlameDrop = "Blackflame Daggers"
L.ChampionBlackFlameDrop2 = "Big Bag of Herbs"
L.ChampionBlackFlameInfo = "are three adds that patrol between the two bridges of the Blazing Way."

L.Cinderfall = "Cinderfall"
L.CinderfallDrop = "Falling Flame"
L.CinderfallInfo = "spawns on the broken bridge."

L.UrdurCauterizer = "Urdur the Cauterizer"
L.UrdurCauterizerDrop = "Sunset Stone"
L.UrdurCauterizerInfo = "spawns on western court of Ordon Sanctuary."

L.FlintlordGairan = "Flintlord Gairan"
L.FlintlordGairanDrop = "Ordon Death Chime"
L.FlintlordGairanInfo = "spawns at various locations around the Ordon Sanctuary."

L.Huolon = "Huolon"
L.HuolonDrop = "Reins of the Thundering Onyx Cloud Serpent"
L.HuolonInfo = "flies around the Blazing Way and the Firewalker Ruins."

L.Golganarr = "Golganarr"
L.GolganarrDrop = "Odd Polished Stone"
L.GolganarrDrop2 = "Glinting Pile of Stone"
L.GolganarrInfo = "spawns around here."

L.Evermaw = "Evermaw"
L.EvermawDrop = "Mist-Filled Spirit Lantern"
L.EvermawInfo = "This mark is not the exact location as she swims clockwise around the island."

L.DreadShipVazuvius = "Dread Ship Vazuvius"
L.DreadShipVazuviusDrop = "Rime of the Time-Lost Mariner"
L.DreadShipVazuviusInfo = "It needs to be summoned at the nearby beach with the Mist-Filled Spirit Lantern Icon Mist-Filled Spirit Lantern that drops from Evermaw."

L.ArchiereusFlame = "Archiereus of Flame"
L.ArchiereusFlameDrop = "Elixir of Ancient Knowledge"
L.ArchiereusFlameInfo = "spawns inside the Ordon Sanctuary, so players who do not have the legendary cloak will need to use a Scroll of Challenge Icon Scroll of Challenge at the Challenger's Stone."

L.Rattleskew ="Rattleskew - Captain Zvezdan"
L.RattleskewDrop ="Captain Zvezdan's Lost Leg"
L.RattleskewDrop2 ="Technique: Glyph of Skeleton"
L.RattleskewInfo ="Underwater Shipwreck - Partial boat on sea floor\nif Captain Zvezdan is there the event is available. You can join his crew of undead and clear the ship. This spawns Rattleskew"


HandyNotes.Locals = L