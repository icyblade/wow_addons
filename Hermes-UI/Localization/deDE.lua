local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("Hermes-UI", "deDE", false)
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

-- L["10 Man (hide 3-8)"] = "10 Man (hide 3-8)"
-- L["25 Man (hide 6-8)"] = "25 Man (hide 6-8)"
-- L["Apply"] = "Apply"
-- L["Blacklist"] = "Blacklist"
-- L["Container and it's settings will be deleted permanently. Continue?"] = "Container and it's settings will be deleted permanently. Continue?"
-- L["Containers"] = "Containers"
-- L["Copy"] = "Copy"
-- L["Disabled"] = "Disabled"
-- L["Duration Timer"] = "Duration Timer"
-- L["Filter Type"] = "Filter Type"
-- L["Hermes isn't tracking any spells or abilities."] = "Hermes isn't tracking any spells or abilities."
-- L["Hermes must be actively Receiving or in Config mode to change UI settings. Config Mode can be turned on in the General tab of Hermes."] = "Hermes must be actively Receiving or in Config mode to change UI settings. Config Mode can be turned on in the General tab of Hermes."
-- L["Hide Dead"] = "Hide Dead"
-- L["Hide Disconnected"] = "Hide Disconnected"
-- L["Hide Not In Range"] = "Hide Not In Range"
-- L["Include all enabled Hermes spells"] = "Include all enabled Hermes spells"
-- L["LOGGER_VIEW_DESCRIPTION"] = "A simple frame where messages are sent when a spell is used and becomes available."
-- L["Move Down"] = "Move Down"
-- L["Move Up"] = "Move Up"
-- L["Name"] = "Name"
-- L["New Container"] = "New Container"
-- L["No description provided"] = "No description provided"
-- L["No views are available, you must have at least one view addon enabled."] = "No views are available, you must have at least one view addon enabled."
-- L["Outline"] = "Outline"
-- L["Player Filters"] = "Player Filters"
-- L["Player Names"] = "Player Names"
-- L["Player Status"] = "Player Status"
-- L["Raid Groups"] = "Raid Groups"
-- L["Show Label"] = "Show Label"
-- L["Show Player Name"] = "Show Player Name"
-- L["Show Slider"] = "Show Slider"
-- L["Show Spell Name"] = "Show Spell Name"
-- L["Show Time"] = "Show Time"
-- L["Swap Label Positions"] = "Swap Label Positions"
-- L["View"] = "View"
-- L["View Description"] = "View Description"
-- L["View Settings"] = "View Settings"
-- L["Whitelist"] = "Whitelist"

L["Alpha"] = "Transparenz" -- Needs review
-- L["COOLDOWNBARS_VIEW_DESCRIPTION"] = "Basic spell bars similar to oRA3 or DBM-SpellTimers. Only shows spells on cooldown. Great option for those that don't want to fiddle with Spell Monitor setup for monitoring non Hermes users."
L["Direction"] = "Ausrichtung" -- Needs review
L["Grow Up"] = "Nach oben erweitern" -- Needs review

-- L["Bar Options"] = "Bar Options"
-- L["Cell Options"] = "Cell Options"
--[==[ L["GRIDBARS_VIEW_DESCRIPTION"] = [=[A highly configurable spell bar view using a grid layout. Shows both available and unavailable spells.

Features include:
* Ability to merge spells as one.
* Tooltip for additional detail.
* Automatic grid layout based on window size.]=] ]==]
-- L["Vertex Color No Senders"] = "Vertex Color No Senders"
-- L["range"] = "range"

--[==[ L["GRIDBUTTONS_VIEW_DESCRIPTION"] = [=[A button view using a grid layout. Shows both available and unavailable spells.

Features include:
* Minimal screen space.
* Ability to merge spells as one.
* Tooltip for additional detail.
* Automatic grid layout based on window size.]=] ]==]
-- L["Icon Texture"] = "Icon Texture"
-- L["Select from loaded textures"] = "Select from loaded textures"
-- L["Vertex Color Unavailable"] = "Vertex Color Unavailable"

--[==[ L["BARS_VIEW_DESCRIPTION"] = [=[A highly configurable spell bar view. Fewer layout choices than GridBars, but with the advantage of not using a fixed bar count. Shows both available and unavailable spells.

Features include:
* Ability to merge spells as one.
* Adjusts bar count as needed.]=] ]==]
-- L["Bar Location"] = "Bar Location"
-- L["Bottom"] = "Bottom"
-- L["Padding"] = "Padding"
-- L["Top"] = "Top"

