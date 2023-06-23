if GetLocale() ~= 'deDE' then return end
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)
local L = HandyNotes.Locals

L.OptionsDescription = "Position der Raren Elite Mobs auf der Zeitlosen Insel."
L.OptionsArgsDescription = "Diese Einstellungen kontrollieren das aussehen der Icons."
L.OptionsIconScaleName = "Icon Groesse"
L.OptionsIconScaleDescription = "Die groesse der Icons"
L.OptionsIconAlphaName = "Icon Sichtbarkeit"
L.OptionsIconAlphaDescription = "Die Transparenz der Icons"

L.EmeralGander = "Smaragdkranich"
L.EmeralGanderDrop = "Windfeder"
L.EmeralGanderInfo = "Erscheint an verschiedenen Orten rund um den Hof der Erhabenen."

L.IronfurSteelhorn = "Eisenfellstahlhorn"
L.IronfurSteelhornDrop = "Büschel Yakfell"

L.ImperialPython = "Kaiserpython"
L.ImperialPythonDrop = "Todesnatterjungtier"

L.GreatTurtleFuryshell = "Großschildkröte Zornpanzer"
L.GreatTurtleFuryshellDrop = "Gehärteter Panzer"
L.GreatTurtleFuryshellInfo = "Patrolliert am westlichen Strand bei den Schildkröten auf der Insel."

L.GuchiSwarmbringer = "Gu'chi der Schwarmbringer"
L.GuchiSwarmbringerDrop = "Schwarmling von Gu'chi"
L.GuchiSwarmbringerInfo = "Erscheint rund um Alt Pi'Jiu."

L.Zesqua = "Zesqua"
L.ZesquaDrop = "Regenstein"
L.ZesquaInfo = "Erscheint Südöstlich von Alt Pi'Jiu an der Küste."

L.ZhuGonSour = "Zhu-Gon der Saure"
L.ZhuGonSourDrop = "Ranziger Bierlementar"
L.ZhuGonSourInfo = "Erscheint nach beendigung des Ranzigen Bier Mini Events an der gleichen Position."

L.Karkanos = "Karkanos"
L.KarkanosDrop = "Großer Beutel voll zeitloser Münzen"
L.KarkanosInfo = "Erscheint nachdem man Finn Langtatze direkt am Steg angesprochen hat."

L.Chelon = "Chelon"
L.ChelonDrop = "Gehärteter Panzer"
L.ChelonInfo = "Erscheint nachdem man den Leblosen Panzer untersucht hat."

L.Spelurk = "Spelurk"
L.SpelurkDrop = "Verfluchter Talisman"
L.SpelurkInfo = "Wird beschworen indem nan die verschüttete Höhle aufbricht.Dazu wird der Hammer benutzt den man zuvor in der noch offenen Höhle findet.Alternativ kann auch einer der seltenen Schätze zum öffnen der Höhle benutzt werden.Dieses wären der Flammenherzschal, Schneewehentigerkrallen oder der Dreizack des Flusssprechers.Einfach den Aktion Button vor der geschlossenen Höhle benutzen."

L.Cranegnasher = "Kranichknirscher"
L.CranegnasherDrop = "Makelloser Pirscherbalg"
L.CranegnasherInfo = "Muss beschworen werden. Du findest den toten Körper eines Vollgefressenen Kranich. Beim lesen erfährst du das es die lieblingsspeise einer Kreatur ist. Das bedeutet du must einen Lebenden Vollgefressenen Kranich zum toten Körper bringen um Kranichknirscher zu beschwören! Du findest Vollgefressenene Kraniche gleich südlich am Stand.Kite sie bis zum leblosen Körper und Kranichknirscher erscheint."

L.Rattleskew = "Klapperknochen"
L.RattleskewDrop = "Kapitän Zvezdans verlorenes Bein"
L.RattleskewInfo = "spawns in Tsavoka's Den."

L.MonstrousSpineclaw = "Monströse Dornzange"
L.MonstrousSpineclawDrop = "Dornzangenkrabbe"
L.MonstrousSpineclawInfo = "Patroliert unter Wasser an der südlichen Küste der Insel."

L.SpiritJadefire = "Jadefeuergeist"
L.SpiritJadefireDrop = "Leuchtende grüne Asche"
L.SpiritJadefireDrop2 = "Jadefeuergeist"
L.SpiritJadefireInfo = "Erscheint in der Höhle der verlorenen Geister.Meistens kurz hinter dem Geisterschädel von Zarhym auf der rechten Seite."

L.Leafmender = "Blattheiler"
L.LeafmenderDrop = "Eschenblattgeistling"
L.LeafmenderInfo = "Erscheint beim Loderndem Pfad, direkt beim Baum."

L.Bufo = "Bufo"
L.BufoDrop = "Schluckfroschling"
L.BufoInfo = "Erscheint in der Gegend mit den ganzen Schluckfröschen."

L.Garnia = "Garnia"
L.GarniaDrop = "Rubinrotes Tröpfchen"
L.GarniaInfo = "Erscheint im roten See. Albatos oder Umhang benutzen um zum See zu kommen."

L.Tsavoka = "Tsavo'ka"
L.TsavokaDrop = "Makelloser Pirscherbalg"
L.TsavokaInfo = "Erscheint in Tsavoka's Höhle."

L.Stinkbraid = "Stinkezopf "
L.StinkbraidInfo = "Erscheint auf dem Deck des Piratenschiffs."

L.RockMoss = "Steinmoos"
L.RockMossDrop = "Goldenes Moos"
L.RockMossInfo = "Erscheint am ende der Höhle der verlorenen Geister."

L.WatcherOsu = "Behüter Osu"
L.WatcherOsuDrop = "Aschestein"
L.WatcherOsuInfo = "Erscheint in den Feuerwächter Ruinen."

L.JakurOrdon = "Jakur von Ordos"
L.JakurOrdonDrop = "Warnschild"
L.JakurOrdonInfo = "Erscheint südlich der Feuerwächter Ruinen."

L.ChampionBlackFlame = "Champion der Schwarzen Flamme"
L.ChampionBlackFlameDrop = "Schwarzflammendolche"
L.ChampionBlackFlameDrop2 = "Großer Sack voll Kräuter"
L.ChampionBlackFlameInfo = "Patroliert zwischen den zwei Brücken beim Lodernden Pfad."

L.Cinderfall = "Glutfall"
L.CinderfallDrop = "Flammenschnuppe"
L.CinderfallInfo = "Erscheint auf der zerbrochenen Brücke."

L.UrdurCauterizer = "Urdur der Kauterisierer"
L.UrdurCauterizerDrop = "Sonnenuntergangsstein"
L.UrdurCauterizerInfo = "Erscheint im Westlichen Hof vom Heiligtum von Ordos."

L.FlintlordGairan = "Funkenlord Gairan"
L.FlintlordGairanDrop = "Totenglocke von Ordos"
L.FlintlordGairanInfo = "Erscheint an verschiedenen Orten rund um dem Heiligtum von Ordos."

L.Huolon = "Huolon"
L.HuolonDrop = "Zügel der donnernden Onyxwolkenschlange"
L.HuolonInfo = "Fliegt zwischen dem Loderndem Pfad und den Feuerwächter Ruinen umher."

L.Golganarr = "Golganarr"
L.GolganarrDrop = "Seltsamer glatt geschliffener Stein"
L.GolganarrDrop2 = "Haufen glitzernder Steine"
L.GolganarrInfo = "Erscheint in dieser Gegend."

L.Evermaw = "Tiefenschlund"
L.EvermawDrop = "Nebelgefüllte Geistlaterne"
L.EvermawInfo = "Das ist nicht die genaue Position da er im Uhrzeigersinn um die Insel herrum schwimmt."

L.DreadShipVazuvius = "Schreckensschiff Vazuvius"
L.DreadShipVazuviusDrop = "Reif des zeitverlorenen Seefahrers"
L.DreadShipVazuviusInfo = "Wird mit der Nebelgefüllten Geistlaterne, erhältlich von Tiefenschlund, nahe des Strandes am Leuchtendem Schrein beschworen."

L.ArchiereusFlame = "Archiereus der Flamme"
L.ArchiereusFlameDrop = "Elixier des uralten Wissens"
L.ArchiereusFlameInfo = "Erscheint gleich Nördlich vom Hof der Erhabenen auf dem Plateau.Spieler ohne den Legendären Umhang benötigen die Schriftrolle der Herausforderung zum beschwören die am Herausfordererstein benutzt wird."

L.Rattleskew ="Klapperknochen - Kapitän Zvezdan"
L.RattleskewDrop ="Kapitän Zvezdans verlorenes Bein"
L.RattleskewDrop2 ="Technik: Glyphe 'Skelett'"
L.RattleskewInfo ="Unterwasser Schiffswrack - Falls Kapitän Zvezdan am Schiffswrack zu sehen ist kann das Event gestartet werden. Helfe der Untoten Mannschaft die Angriffe zurückzuschlagen und Klapperknochen erscheint darauf."

HandyNotes.Locals = L