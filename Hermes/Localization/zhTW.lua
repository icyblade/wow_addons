-- English localization file for enUS
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("Hermes", "zhTW", false)
if not L then return end

L["Add"] = "加入" -- Needs review
L["Alive"] = "存活" -- Needs review
-- L["Anchor Point"] = "Anchor Point"
-- L["Available Bar Color"] = "Available Bar Color"
-- L["Available Font Color"] = "Available Font Color"
-- L["Background"] = "Background"
-- L["Bar Direction"] = "Bar Direction"
-- L["Bars"] = "Bars"
-- L["Bars to Show"] = "Bars to Show"
-- L["Behavior"] = "Behavior"
L["Bottom Left"] = "左下" -- Needs review
L["Bottom Right"] = "右下" -- Needs review
-- L["Bottom to Top"] = "Bottom to Top"
-- L["Cell Padding"] = "Cell Padding"
L["Class Colored Borders"] = "職業顏色邊框" -- Needs review
L["Color"] = "顏色" -- Needs review
-- L["Configure"] = "Configure"
-- L["Conn"] = "Conn"
-- L["Container"] = "Container"
-- L["Cooldown Style"] = "Cooldown Style"
L["Default"] = "預設" -- Needs review
L["Delete"] = "刪除" -- Needs review
-- L["Drop Shadow"] = "Drop Shadow"
-- L["Enabled"] = "Enabled"
L["Font"] = "字型" -- Needs review
-- L["Font Size"] = "Font Size"
-- L["Foreground"] = "Foreground"
-- L["Gap Between Bars"] = "Gap Between Bars"
L["Height"] = "高度" -- Needs review
-- L["Hide"] = "Hide"
-- L["Hide Abilities without Senders"] = "Hide Abilities without Senders"
-- L["Hide Self"] = "Hide Self"
-- L["Icon"] = "Icon"
-- L["Inner Padding"] = "Inner Padding"
-- L["Layout"] = "Layout"
-- L["Left"] = "Left"
L["Left to Right"] = "左到右" -- Needs review
-- L["Lock Window"] = "Lock Window"
-- L["Merge Spells"] = "Merge Spells"
-- L["Name on Right"] = "Name on Right"
-- L["None"] = "None"
L["None found"] = "沒有找到" -- Needs review
-- L["On Cooldown Bar Color"] = "On Cooldown Bar Color"
-- L["On Cooldown Font Color"] = "On Cooldown Font Color"
-- L["Only show bar when spell is on cooldown"] = "Only show bar when spell is on cooldown"
-- L["Outline"] = "Outline"
L["Padding"] = "填充" -- Needs review
-- L["Player/Duration Width Ratio (%)"] = "Player/Duration Width Ratio (%)"
-- L["Range"] = "Range"
-- L["Ready"] = "Ready"
-- L["Requires spell metadata key duration. If such a key exists, an additional timer bar will be displayed based on it's value. For example. you could supply a duration key with a value of 6 for Divine Guardian's 6 second duration."] = "Requires spell metadata key duration. If such a key exists, an additional timer bar will be displayed based on it's value. For example. you could supply a duration key with a value of 6 for Divine Guardian's 6 second duration."
L["Reset Position"] = "重設位置" -- Needs review
-- L["Reverse Direction"] = "Reverse Direction"
-- L["Right"] = "Right"
-- L["Right to Left"] = "Right to Left"
L["Scale"] = "縮放" -- Needs review
-- L["Show"] = "Show"
-- L["Show Icon"] = "Show Icon"
-- L["Show Nameplate"] = "Show Nameplate"
-- L["Size"] = "Size"
-- L["Spell Metadata"] = "Spell Metadata"
L["Spells"] = "法術" -- Needs review
-- L["Starts Empty"] = "Starts Empty"
-- L["Starts Full"] = "Starts Full"
-- L["Swap Name and Duration"] = "Swap Name and Duration"
-- L["Texture"] = "Texture"
L["Time"] = "時間" -- Needs review
-- L["Tooltip"] = "Tooltip"
L["Top Left"] = "左上" -- Needs review
L["Top Right"] = "右上" -- Needs review
-- L["Top to Bottom"] = "Top to Bottom"
-- L["Unavailable Bar Color"] = "Unavailable Bar Color"
-- L["Unavailable Font Color"] = "Unavailable Font Color"
-- L["Use Class Color"] = "Use Class Color"
L["Width"] = "寬度" -- Needs review
-- L["Window"] = "Window"
-- L["dead"] = "dead"
-- L["offline"] = "offline"
-- L["range"] = "range"

L["-- Select --"] = "-- 選擇 --" -- Needs review
-- L["A full reset clears all cached talents, races, cooldowns, requirements and adjustments. Useful if Blizzard changes talents for any classes. Hermes will automatically rebuild talents and races while in a party or raid, and apply the latest cooldowns, requirements and adjustments."] = "A full reset clears all cached talents, races, cooldowns, requirements and adjustments. Useful if Blizzard changes talents for any classes. Hermes will automatically rebuild talents and races while in a party or raid, and apply the latest cooldowns, requirements and adjustments."
-- L["Add Adjustment"] = "Add Adjustment"
L["Add Item"] = "加入物品" -- Needs review
-- L["Add Requirement"] = "Add Requirement"
L["Add Spell"] = "加入法術" -- Needs review
-- L["Adds the latest spells provided by Hermes (if not already added)."] = "Adds the latest spells provided by Hermes (if not already added)."
-- L["Adjustments"] = "Adjustments"
-- L["All talents, races, cooldowns, requirements, and adjustment will be reset."] = "All talents, races, cooldowns, requirements, and adjustment will be reset."
L["Any"] = "任何" -- Needs review
-- L["Back"] = "Back"
-- L["Base Cooldown"] = "Base Cooldown"
--[==[ L["COMBAT_LOGGING_INSTRUCTIONS"] = [=[|cFFFFD414Step By Step:|r
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
3) Create another 'Talent Name' adjustment for 'Paragon of Virtue' with Rank 2 and a 'Cooldown Offset' of -10.]=] ]==]
-- L["Capture spell cooldowns for players without Hermes"] = "Capture spell cooldowns for players without Hermes"
L["Class"] = "職業" -- Needs review
-- L["Clear Talent Cache"] = "Clear Talent Cache"
-- L["Click to replace talent related cooldowns, requirements and adjustments with the latest version."] = "Click to replace talent related cooldowns, requirements and adjustments with the latest version."
L["Close"] = "關閉" -- Needs review
L["Communication"] = "通訊" -- Needs review
L["Config Mode"] = "設置模式" -- Needs review
-- L["Configuration"] = "Configuration"
-- L["Configure spell data for detection of non Hermes users."] = "Configure spell data for detection of non Hermes users."
-- L["Configure spell metadata (advanced users only)."] = "Configure spell metadata (advanced users only)."
-- L["Cooldown Offset"] = "Cooldown Offset"
-- L["Default Spells"] = "Default Spells"
-- L["Details"] = "Details"
-- L["Done!"] = "Done!"
-- L["Each row represents a key/value pair. Provide a key in the last row to create a new entry. Delete an existing entry by clearing the key. The data provided here can be used by other addons leveraging Hermes API."] = "Each row represents a key/value pair. Provide a key in the last row to create a new entry. Delete an existing entry by clearing the key. The data provided here can be used by other addons leveraging Hermes API."
L["Edit Settings"] = "編輯設定" -- Needs review
L["Enable Hermes"] = "啟用 Hermes" -- Needs review
L["Enable Party Support"] = "啟用隊伍支援" -- Needs review
L["Enable Receiving"] = "啟用接收" -- Needs review
L["Enable Sending"] = "啟用傳送" -- Needs review
-- L["Full Reset"] = "Full Reset"
L["General"] = "一般" -- Needs review
L["Hermes is running in Config Mode."] = "Hermes 正運行在設置模式。" -- Needs review
-- L["If provided, only these players are monitored for this spell."] = "If provided, only these players are monitored for this spell."
-- L["Instructions"] = "Instructions"
L["Item has already been added"] = "物品已經加入" -- Needs review
-- L["Item name or id not found. If you're confident the id or name is correct, try having someone link the item or putting the item in your inventory and adding again."] = "Item name or id not found. If you're confident the id or name is correct, try having someone link the item or putting the item in your inventory and adding again."
L["Item will be deleted. Continue?"] = "物品將被刪除。確定嗎？" -- Needs review
L["Items"] = "物品" -- Needs review
-- L["Key"] = "Key"
-- L["Level"] = "Level"
-- L["List"] = "List"
-- L["List any default spells not in your inventory."] = "List any default spells not in your inventory."
-- L["Maintenance"] = "Maintenance"
-- L["Metadata"] = "Metadata"
L["Name or ID"] = "名稱或 ID" -- Needs review
-- L["No Talent Cache"] = "No Talent Cache"
-- L["Offset cooldown by |cFF00FF00%s|r if player has |cFF00FF00%s|r or more points in |cFF00FF00"] = "Offset cooldown by |cFF00FF00%s|r if player has |cFF00FF00%s|r or more points in |cFF00FF00"
-- L["Offset cooldown by |cFF00FF00%s|r if player level is at least |cFF00FF00%s|r"] = "Offset cooldown by |cFF00FF00%s|r if player level is at least |cFF00FF00%s|r"
-- L["Offset cooldown by |cFF00FF00%s|r if player name is |cFF00FF00%s|r"] = "Offset cooldown by |cFF00FF00%s|r if player name is |cFF00FF00%s|r"
-- L["Offset cooldown by |cFF00FF00%s|r if player specced |cFF00FF00%s|r"] = "Offset cooldown by |cFF00FF00%s|r if player specced |cFF00FF00%s|r"
L["Open Configuration"] = "開啟設置" -- Needs review
-- L["Player Level"] = "Player Level"
-- L["Player Name"] = "Player Name"
-- L["Player Names"] = "Player Names"
-- L["Player Race"] = "Player Race"
-- L["Player has |cFF00FF00%s|r or more points in |cFF00FF00%s|r"] = "Player has |cFF00FF00%s|r or more points in |cFF00FF00%s|r"
-- L["Player is at least level |cFF00FF00%s|r"] = "Player is at least level |cFF00FF00%s|r"
-- L["Player is specced |cFF00FF00%s|r"] = "Player is specced |cFF00FF00%s|r"
-- L["Player is |cFF00FF00%s|r"] = "Player is |cFF00FF00%s|r"
-- L["Player name in |cFF00FF00%s|r"] = "Player name in |cFF00FF00%s|r"
-- L["Primary Tree"] = "Primary Tree"
-- L["Race"] = "Race"
-- L["Rank"] = "Rank"
-- L["Registered Plugins"] = "Registered Plugins"
-- L["Requirements"] = "Requirements"
-- L["Requires update"] = "Requires update"
-- L["Restore Default Spells"] = "Restore Default Spells"
-- L["Show spell monitor status for each class."] = "Show spell monitor status for each class."
-- L["Spell Monitor"] = "Spell Monitor"
-- L["Spell Monitor is disabled until talents for this class are cached."] = "Spell Monitor is disabled until talents for this class are cached."
L["Spell will be deleted. Continue?"] = "法術將被刪除。確定嗎？" -- Needs review
-- L["Talent Name"] = "Talent Name"
-- L["Talent Spec"] = "Talent Spec"
-- L["Toggle it on or off in the 'General' settings tab."] = "Toggle it on or off in the 'General' settings tab."
-- L["Type"] = "Type"
-- L["Unknown"] = "Unknown"
-- L["Update Metadata"] = "Update Metadata"
-- L["Updates the metadata for the spells in your inventory with the latest values."] = "Updates the metadata for the spells in your inventory with the latest values."
-- L["Upgrade Options"] = "Upgrade Options"
-- L["Use Auto Detection"] = "Use Auto Detection"
-- L["Value"] = "Value"
-- L["latest version"] = "latest version"
-- L["multiple id's were found. The first id was chosen"] = "multiple id's were found. The first id was chosen"
-- L["now sending"] = "now sending"
-- L["queuing requests for %s seconds..."] = "queuing requests for %s seconds..."
L["searching"] = "搜尋中" -- Needs review
L["spell has already been added"] = "法術已經加入" -- Needs review
L["spell name or id not found"] = "找不到法術名稱或 ID" -- Needs review
-- L["|cFF00FF00Spell Monitor Enabled!"] = "|cFF00FF00Spell Monitor Enabled!"
L["|cFFFF0000Hermes Warning|r"] = "|cFFFF0000Hermes 警告|r" -- Needs review
-- L["|cFFFF2200Base Cooldown Required:|r A Base Cooldown is required to enable Spell Monitor support."] = "|cFFFF2200Base Cooldown Required:|r A Base Cooldown is required to enable Spell Monitor support."
-- L["|cFFFF2200Base Cooldown Unknown:|r Hermes hasn't detected a cooldown for this spell yet."] = "|cFFFF2200Base Cooldown Unknown:|r Hermes hasn't detected a cooldown for this spell yet."
-- L["|cFFFF3333Missing Talents:|r Hermes has yet to inspect a player of this class for talent information. Try again later when this class is in your group."] = "|cFFFF3333Missing Talents:|r Hermes has yet to inspect a player of this class for talent information. Try again later when this class is in your group."

