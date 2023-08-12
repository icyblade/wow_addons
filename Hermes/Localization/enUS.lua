-- English localization file for enUS
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")

local debug = false
--[===[@debug@
debug = true
--@end-debug@]===]

local L = AceLocale:NewLocale("Hermes", "enUS", true, debug)
if not L then return end

L["Add"] = true
L["Alive"] = true
L["Anchor Point"] = true
L["Available Bar Color"] = true
L["Available Font Color"] = true
L["Background"] = true
L["Bar Direction"] = true
L["Bars"] = true
L["Bars to Show"] = true
L["Behavior"] = true
L["Bottom Left"] = true
L["Bottom Right"] = true
L["Bottom to Top"] = true
L["Cell Padding"] = true
L["Class Colored Borders"] = true
L["Color"] = true
L["Configure"] = true
L["Conn"] = true
L["Container"] = true
L["Cooldown Style"] = true
L["Default"] = true
L["Delete"] = true
L["Drop Shadow"] = true
L["Enabled"] = true
L["Font"] = true
L["Font Size"] = true
L["Foreground"] = true
L["Gap Between Bars"] = true
L["Height"] = true
L["Hide"] = true
L["Hide Abilities without Senders"] = true
L["Hide Self"] = true
L["Icon"] = true
L["Inner Padding"] = true
L["Layout"] = true
L["Left"] = true
L["Left to Right"] = true
L["Lock Window"] = true
L["Merge Spells"] = true
L["Name on Right"] = true
L["None"] = true
L["None found"] = true
L["On Cooldown Bar Color"] = true
L["On Cooldown Font Color"] = true
L["Only show bar when spell is on cooldown"] = true
L["Outline"] = true
L["Padding"] = true
L["Player/Duration Width Ratio (%)"] = true
L["Range"] = true
L["Ready"] = true
L["Requires spell metadata key duration. If such a key exists, an additional timer bar will be displayed based on it's value. For example. you could supply a duration key with a value of 6 for Divine Guardian's 6 second duration."] = true
L["Reset Position"] = true
L["Reverse Direction"] = true
L["Right"] = true
L["Right to Left"] = true
L["Scale"] = true
L["Show"] = true
L["Show Icon"] = true
L["Show Nameplate"] = true
L["Size"] = true
L["Spell Metadata"] = true
L["Spells"] = true
L["Starts Empty"] = true
L["Starts Full"] = true
L["Swap Name and Duration"] = true
L["Texture"] = true
L["Time"] = true
L["Tooltip"] = true
L["Top Left"] = true
L["Top Right"] = true
L["Top to Bottom"] = true
L["Unavailable Bar Color"] = true
L["Unavailable Font Color"] = true
L["Use Class Color"] = true
L["Width"] = true
L["Window"] = true
L["dead"] = true
L["offline"] = true
L["range"] = true

L["-- Select --"] = true
L["A full reset clears all cached talents, races, cooldowns, requirements and adjustments. Useful if Blizzard changes talents for any classes. Hermes will automatically rebuild talents and races while in a party or raid, and apply the latest cooldowns, requirements and adjustments."] = true
L["Add Adjustment"] = true
L["Add Item"] = true
L["Add Requirement"] = true
L["Add Spell"] = true
L["Adds the latest spells provided by Hermes (if not already added)."] = true
L["Adjustments"] = true
L["All talents, races, cooldowns, requirements, and adjustment will be reset."] = true
L["Any"] = true
L["Back"] = true
L["Base Cooldown"] = true
L["COMBAT_LOGGING_INSTRUCTIONS"] = [=[|cFFFFD414Step By Step:|r
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
3) Create another 'Talent Name' adjustment for 'Paragon of Virtue' with Rank 2 and a 'Cooldown Offset' of -10.]=]
L["Capture spell cooldowns for players without Hermes"] = true
L["Class"] = true
L["Clear Talent Cache"] = true
L["Click to replace talent related cooldowns, requirements and adjustments with the latest version."] = true
L["Close"] = true
L["Communication"] = true
L["Config Mode"] = true
L["Configuration"] = true
L["Configure spell data for detection of non Hermes users."] = true
L["Configure spell metadata (advanced users only)."] = true
L["Cooldown Offset"] = true
L["Default Spells"] = true
L["Details"] = true
L["Done!"] = true
L["Each row represents a key/value pair. Provide a key in the last row to create a new entry. Delete an existing entry by clearing the key. The data provided here can be used by other addons leveraging Hermes API."] = true
L["Edit Settings"] = true
L["Enable Hermes"] = true
L["Enable Party Support"] = true
L["Enable Receiving"] = true
L["Enable Sending"] = true
L["Full Reset"] = true
L["General"] = true
L["Hermes is running in Config Mode."] = true
L["If provided, only these players are monitored for this spell."] = true
L["Instructions"] = true
L["Item has already been added"] = true
L["Item name or id not found. If you're confident the id or name is correct, try having someone link the item or putting the item in your inventory and adding again."] = true
L["Item will be deleted. Continue?"] = true
L["Items"] = true
L["Key"] = true
L["Level"] = true
L["List"] = true
L["List any default spells not in your inventory."] = true
L["Maintenance"] = true
L["Metadata"] = true
L["Name or ID"] = true
L["No Talent Cache"] = true
L["Offset cooldown by |cFF00FF00%s|r if player has |cFF00FF00%s|r or more points in |cFF00FF00"] = true
L["Offset cooldown by |cFF00FF00%s|r if player level is at least |cFF00FF00%s|r"] = true
L["Offset cooldown by |cFF00FF00%s|r if player name is |cFF00FF00%s|r"] = true
L["Offset cooldown by |cFF00FF00%s|r if player specced |cFF00FF00%s|r"] = true
L["Open Configuration"] = true
L["Player Level"] = true
L["Player Name"] = true
L["Player Names"] = true
L["Player Race"] = true
L["Player has |cFF00FF00%s|r or more points in |cFF00FF00%s|r"] = true
L["Player is at least level |cFF00FF00%s|r"] = true
L["Player is specced |cFF00FF00%s|r"] = true
L["Player is |cFF00FF00%s|r"] = true
L["Player name in |cFF00FF00%s|r"] = true
L["Primary Tree"] = true
L["Race"] = true
L["Rank"] = true
L["Registered Plugins"] = true
L["Requirements"] = true
L["Requires update"] = true
L["Restore Default Spells"] = true
L["Show spell monitor status for each class."] = true
L["Spell Monitor"] = true
L["Spell Monitor is disabled until talents for this class are cached."] = true
L["Spell will be deleted. Continue?"] = true
L["Talent Name"] = true
L["Talent Spec"] = true
L["Toggle it on or off in the 'General' settings tab."] = true
L["Type"] = true
L["Unknown"] = true
L["Update Metadata"] = true
L["Updates the metadata for the spells in your inventory with the latest values."] = true
L["Upgrade Options"] = true
L["Use Auto Detection"] = true
L["Value"] = true
L["latest version"] = true
L["multiple id's were found. The first id was chosen"] = true
L["now sending"] = true
L["queuing requests for %s seconds..."] = true
L["searching"] = true
L["spell has already been added"] = true
L["spell name or id not found"] = true
L["|cFF00FF00Spell Monitor Enabled!"] = true
L["|cFFFF0000Hermes Warning|r"] = true
L["|cFFFF2200Base Cooldown Required:|r A Base Cooldown is required to enable Spell Monitor support."] = true
L["|cFFFF2200Base Cooldown Unknown:|r Hermes hasn't detected a cooldown for this spell yet."] = true
L["|cFFFF3333Missing Talents:|r Hermes has yet to inspect a player of this class for talent information. Try again later when this class is in your group."] = true
