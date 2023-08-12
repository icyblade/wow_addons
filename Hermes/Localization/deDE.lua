-- English localization file for enUS
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("Hermes", "deDE", false)
if not L then return end

L["Add"] = "hinzufügen" -- Needs review
L["Alive"] = "Am Leben"
-- L["Anchor Point"] = "Anchor Point"
L["Available Bar Color"] = "'verfügbar' Leistenfarbe"
L["Available Font Color"] = "'verfügbar' Schriftfarbe"
L["Background"] = "Hintergrund"
L["Bar Direction"] = "Leistenausrichtung"
L["Bars"] = "Leisten"
L["Bars to Show"] = "Leistenanzahl"
-- L["Behavior"] = "Behavior"
L["Bottom Left"] = "Unten Links" -- Needs review
L["Bottom Right"] = "Unten Rechts" -- Needs review
L["Bottom to Top"] = "von unten nach oben"
-- L["Cell Padding"] = "Cell Padding"
L["Class Colored Borders"] = "Umrandungen in Klassenfarbe"
L["Color"] = "Farbe"
-- L["Configure"] = "Configure"
L["Conn"] = true
L["Container"] = true -- Needs review
-- L["Cooldown Style"] = "Cooldown Style"
L["Default"] = "Standart"
L["Delete"] = "Löschen" -- Needs review
-- L["Drop Shadow"] = "Drop Shadow"
-- L["Enabled"] = "Enabled"
L["Font"] = "Schrift"
L["Font Size"] = "Schriftgröße"
-- L["Foreground"] = "Foreground"
L["Gap Between Bars"] = "Abstand zwischen den Leisten"
L["Height"] = "Höhe"
-- L["Hide"] = "Hide"
L["Hide Abilities without Senders"] = "Verstecke Fähigkeiten ohne Sender"
L["Hide Self"] = "Selbst Verstecken" -- Needs review
-- L["Icon"] = "Icon"
-- L["Inner Padding"] = "Inner Padding"
-- L["Layout"] = "Layout"
-- L["Left"] = "Left"
L["Left to Right"] = "von links nach rechts"
L["Lock Window"] = "Sperre Fenster" -- Needs review
-- L["Merge Spells"] = "Merge Spells"
-- L["Name on Right"] = "Name on Right"
-- L["None"] = "None"
L["None found"] = "nicht gefunden" -- Needs review
L["On Cooldown Bar Color"] = "'auf Cooldown' Leistenfarbe"
L["On Cooldown Font Color"] = "'auf Cooldown' Schriftfarbe"
L["Only show bar when spell is on cooldown"] = "Zeige leiste nur wenn der Zauber auf Cooldown ist"
L["Outline"] = "Umriss"
L["Padding"] = true -- Needs review
L["Player/Duration Width Ratio (%)"] = "Spieler/Dauer breiten Verhältnis (%)" -- Needs review
L["Range"] = "Reichweite"
L["Ready"] = "Bereit"
-- L["Requires spell metadata key duration. If such a key exists, an additional timer bar will be displayed based on it's value. For example. you could supply a duration key with a value of 6 for Divine Guardian's 6 second duration."] = "Requires spell metadata key duration. If such a key exists, an additional timer bar will be displayed based on it's value. For example. you could supply a duration key with a value of 6 for Divine Guardian's 6 second duration."
L["Reset Position"] = "Position zurücksetzen"
-- L["Reverse Direction"] = "Reverse Direction"
-- L["Right"] = "Right"
L["Right to Left"] = "von rechts nach links"
L["Scale"] = "Skalierung" -- Needs review
-- L["Show"] = "Show"
L["Show Icon"] = "Zeige Icon"
L["Show Nameplate"] = "Zeige Namensplakete"
L["Size"] = "Größe"
-- L["Spell Metadata"] = "Spell Metadata"
L["Spells"] = "Zauber"
-- L["Starts Empty"] = "Starts Empty"
-- L["Starts Full"] = "Starts Full"
-- L["Swap Name and Duration"] = "Swap Name and Duration"
L["Texture"] = "Textur"
L["Time"] = "Zeit"
-- L["Tooltip"] = "Tooltip"
L["Top Left"] = "Oben Links"
L["Top Right"] = "Oben Rechts"
L["Top to Bottom"] = "von oben nach unten"
L["Unavailable Bar Color"] = "'nicht verfügbar' Leistenfarbe"
L["Unavailable Font Color"] = "'Nicht verfügbar' Schriftfarbe"
L["Use Class Color"] = "In Klassenfarbe"
L["Width"] = "Breite"
L["Window"] = "Fenster" -- Needs review
L["dead"] = "tot"
L["offline"] = true
L["range"] = "Reichweite"

L["-- Select --"] = "-- Auswählen --"
-- L["A full reset clears all cached talents, races, cooldowns, requirements and adjustments. Useful if Blizzard changes talents for any classes. Hermes will automatically rebuild talents and races while in a party or raid, and apply the latest cooldowns, requirements and adjustments."] = "A full reset clears all cached talents, races, cooldowns, requirements and adjustments. Useful if Blizzard changes talents for any classes. Hermes will automatically rebuild talents and races while in a party or raid, and apply the latest cooldowns, requirements and adjustments."
L["Add Adjustment"] = "Anpassung hinzufügen"
L["Add Item"] = "Item hinzufügen"
L["Add Requirement"] = "Anforderung hinzufügen"
L["Add Spell"] = "Zauber hinzufügen" -- Needs review
-- L["Adds the latest spells provided by Hermes (if not already added)."] = "Adds the latest spells provided by Hermes (if not already added)."
L["Adjustments"] = "Anpassungen"
-- L["All talents, races, cooldowns, requirements, and adjustment will be reset."] = "All talents, races, cooldowns, requirements, and adjustment will be reset."
L["Any"] = "Jeder"
L["Back"] = "zurück"
L["Base Cooldown"] = "Basis Cooldown"
L["COMBAT_LOGGING_INSTRUCTIONS"] = [=[|cFFFFD414Schrit für Schritt:|r
1) Ensure Spell Monitor support is Enabled above.
2) Go to the Spells configuration tab.
3) For each spell you wish to enable Spell Monitor for, do the following:
    A) Click the 'Spell Monitor' button.
    B) Provide a Base Cooldown (or try Auto Detection).
    C) Click the 'Requirements >>' button and create any relevent requirements.
    D) Click the '<< Back' button.
    E) Click the 'Adjustments >>' button and create any relevent adjustments.

|cFFFFD414Base Cooldown:|r
A Base Cooldown is required for Spell Scanning support. Check the Status at the bottom of the page for help.

|cFFFFD414Requirements:|r
Hermes uses requirements to determine which spells a player has access to.

|cFFFFD414Adjustments:|r
Adjustments are cumulative, and are added to the Base Cooldown you provided. If an adjustment reduces the Base Cooldown, then you should use a negative number.

|cFFFFD414Talent and Race Dropdowns:|r
Talents and races are scanned automatically by Hermes while in a group. They may not be available the first time you install Hermes. Wait a minute or two after joining a raid and try again. Once gathered, you won't have to wait again.

|cFFFFD414Example:|r
All Paladins have Divine Protection available at level 30. It's base cooldown is 60 seconds. Holy Paladins have a talent called Paragon of Virtue which reduces the base cooldown by 10 seconds for each point spent (2 points max).

Hermes would need you to...
1) Create a "Player Level' requirement for level 30.
2) Create a 'Talent Name' adjustment for 'Paragon of Virtue' with Rank 1 and a 'Cooldown Offset' of -10.
3) Create another 'Talent Name' adjustment for 'Paragon of Virtue' with Rank 2 and a 'Cooldown Offset' of -10.]=] -- Needs review
L["Capture spell cooldowns for players without Hermes"] = "Erfassung der Zauber Cooldowns von Spielern ohne Hermes"
L["Class"] = "Klasse" -- Needs review
L["Clear Talent Cache"] = "Lösche Talente Cache"
-- L["Click to replace talent related cooldowns, requirements and adjustments with the latest version."] = "Click to replace talent related cooldowns, requirements and adjustments with the latest version."
L["Close"] = "Schließen"
L["Communication"] = "Kommunikation"
L["Config Mode"] = "Konfigurations Modus"
-- L["Configuration"] = "Configuration"
-- L["Configure spell data for detection of non Hermes users."] = "Configure spell data for detection of non Hermes users."
-- L["Configure spell metadata (advanced users only)."] = "Configure spell metadata (advanced users only)."
L["Cooldown Offset"] = "Cooldown Abweichung"
-- L["Default Spells"] = "Default Spells"
-- L["Details"] = "Details"
-- L["Done!"] = "Done!"
-- L["Each row represents a key/value pair. Provide a key in the last row to create a new entry. Delete an existing entry by clearing the key. The data provided here can be used by other addons leveraging Hermes API."] = "Each row represents a key/value pair. Provide a key in the last row to create a new entry. Delete an existing entry by clearing the key. The data provided here can be used by other addons leveraging Hermes API."
L["Edit Settings"] = "Einstellungen editieren"
L["Enable Hermes"] = "Hermes einschalten"
L["Enable Party Support"] = "Gruppen Support"
L["Enable Receiving"] = "Empfang einschalten"
L["Enable Sending"] = "Senden einschalten"
-- L["Full Reset"] = "Full Reset"
L["General"] = "Allgemein"
L["Hermes is running in Config Mode."] = "Hermes läuft im Konfigurations Modus."
-- L["If provided, only these players are monitored for this spell."] = "If provided, only these players are monitored for this spell."
L["Instructions"] = "Anweisungen"
L["Item has already been added"] = "Das Item wurde bereits hinzugefügt"
-- L["Item name or id not found. If you're confident the id or name is correct, try having someone link the item or putting the item in your inventory and adding again."] = "Item name or id not found. If you're confident the id or name is correct, try having someone link the item or putting the item in your inventory and adding again."
L["Item will be deleted. Continue?"] = "Items werden gelöscht. Weiter?" -- Needs review
L["Items"] = true -- Needs review
-- L["Key"] = "Key"
-- L["Level"] = "Level"
L["List"] = "Liste"
-- L["List any default spells not in your inventory."] = "List any default spells not in your inventory."
-- L["Maintenance"] = "Maintenance"
-- L["Metadata"] = "Metadata"
L["Name or ID"] = "Name oder ID" -- Needs review
-- L["No Talent Cache"] = "No Talent Cache"
-- L["Offset cooldown by |cFF00FF00%s|r if player has |cFF00FF00%s|r or more points in |cFF00FF00"] = "Offset cooldown by |cFF00FF00%s|r if player has |cFF00FF00%s|r or more points in |cFF00FF00"
-- L["Offset cooldown by |cFF00FF00%s|r if player level is at least |cFF00FF00%s|r"] = "Offset cooldown by |cFF00FF00%s|r if player level is at least |cFF00FF00%s|r"
-- L["Offset cooldown by |cFF00FF00%s|r if player name is |cFF00FF00%s|r"] = "Offset cooldown by |cFF00FF00%s|r if player name is |cFF00FF00%s|r"
-- L["Offset cooldown by |cFF00FF00%s|r if player specced |cFF00FF00%s|r"] = "Offset cooldown by |cFF00FF00%s|r if player specced |cFF00FF00%s|r"
L["Open Configuration"] = "Öffne Konfiguration"
L["Player Level"] = "Spieler Level"
L["Player Name"] = "Spieler Name"
L["Player Names"] = "Spieler Namen"
L["Player Race"] = "Spieler Rasse"
-- L["Player has |cFF00FF00%s|r or more points in |cFF00FF00%s|r"] = "Player has |cFF00FF00%s|r or more points in |cFF00FF00%s|r"
-- L["Player is at least level |cFF00FF00%s|r"] = "Player is at least level |cFF00FF00%s|r"
-- L["Player is specced |cFF00FF00%s|r"] = "Player is specced |cFF00FF00%s|r"
-- L["Player is |cFF00FF00%s|r"] = "Player is |cFF00FF00%s|r"
-- L["Player name in |cFF00FF00%s|r"] = "Player name in |cFF00FF00%s|r"
L["Primary Tree"] = "Haupt Talentbaum"
L["Race"] = "Rasse"
L["Rank"] = "Rang"
L["Registered Plugins"] = "Registrierte Plugins"
L["Requirements"] = "Anforderungen"
-- L["Requires update"] = "Requires update"
L["Restore Default Spells"] = "Update Fähigkeiten Standards" -- Needs review
-- L["Show spell monitor status for each class."] = "Show spell monitor status for each class."
-- L["Spell Monitor"] = "Spell Monitor"
-- L["Spell Monitor is disabled until talents for this class are cached."] = "Spell Monitor is disabled until talents for this class are cached."
L["Spell will be deleted. Continue?"] = "Zauber wird gelöscht. Fortfahren?"
L["Talent Name"] = true
L["Talent Spec"] = true
L["Toggle it on or off in the 'General' settings tab."] = "Schalte ihn im 'Allgemein' tab ein oder aus."
-- L["Type"] = "Type"
L["Unknown"] = "Unbekannt"
-- L["Update Metadata"] = "Update Metadata"
-- L["Updates the metadata for the spells in your inventory with the latest values."] = "Updates the metadata for the spells in your inventory with the latest values."
L["Upgrade Options"] = "Upgrade Optionen"
L["Use Auto Detection"] = "Automatisch erkennen"
-- L["Value"] = "Value"
-- L["latest version"] = "latest version"
L["multiple id's were found. The first id was chosen"] = "Verschiedene id's wurden gefunden. Die erste id wurde gewählt"
L["now sending"] = "sende"
L["queuing requests for %s seconds..."] = "Einreihen von anfragen für %s Sekunden..."
L["searching"] = "Suche"
L["spell has already been added"] = "Zauber wurde bereits hinzugefügt" -- Needs review
L["spell name or id not found"] = "Zauber Name oder ID nicht gefunden" -- Needs review
L["|cFF00FF00Spell Monitor Enabled!"] = "|cFF00FF00Spell Monitor aktiviert!"
L["|cFFFF0000Hermes Warning|r"] = "|cFFFF0000Hermes Warnungen|r" -- Needs review
-- L["|cFFFF2200Base Cooldown Required:|r A Base Cooldown is required to enable Spell Monitor support."] = "|cFFFF2200Base Cooldown Required:|r A Base Cooldown is required to enable Spell Monitor support."
-- L["|cFFFF2200Base Cooldown Unknown:|r Hermes hasn't detected a cooldown for this spell yet."] = "|cFFFF2200Base Cooldown Unknown:|r Hermes hasn't detected a cooldown for this spell yet."
-- L["|cFFFF3333Missing Talents:|r Hermes has yet to inspect a player of this class for talent information. Try again later when this class is in your group."] = "|cFFFF3333Missing Talents:|r Hermes has yet to inspect a player of this class for talent information. Try again later when this class is in your group."

