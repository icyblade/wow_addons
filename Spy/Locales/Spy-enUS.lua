local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("Spy", "enUS", true)
if not L then return end

-- Addon information
L["Spy"] = "Spy"
L["Version"] = "Version"
L["LoadDescription"] = "|cff9933ffSpy addon loaded. Type |cffffffff/spy|cff9933ff for options."
L["SpyEnabled"] = "|cff9933ffSpy addon enabled."
L["SpyDisabled"] = "|cff9933ffSpy addon disabled. Type |cffffffff/spy show|cff9933ff to enable."
L["UpgradeAvailable"] = "|cff9933ffA new version of Spy is available. It can be downloaded from:\n|cffffffffhttp://wow.curse.com/downloads/wow-addons/details/spy.aspx"

-- Configuration strings
L["Profiles"] = "Profiles"

L["GeneralSettings"] = "General Settings"
L["SpyDescription1"] = [[
Spy is an addon that will alert you to the presence of nearby enemy players.
]]
L["SpyDescription2"] = [[

|cffffd000Nearby list|cffffffff
The Nearby list displays any enemy players that have been detected nearby. Clicking the list allows you to target the player, however this only works out of combat. Players are removed from the list if they have not been detected after a period of time.

The clear button in the title bar can be used to clear the list, and holding Control while clearing the list will allow you to quickly enable/disable Spy.

|cffffd000Last Hour list|cffffffff
The Last Hour list displays all enemies that have been detected in the last hour.

|cffffd000Ignore list|cffffffff
Players that are added to the Ignore list will not be reported by Spy. You can add and remove players to/from this list by using the button's drop down menu or by holding the Control key while clicking the button.

|cffffd000Kill On Sight list|cffffffff
Players on your Kill On Sight list cause an alarm to sound when detected. You can add and remove players to/from this list by using the button's drop down menu or by holding the Shift key while clicking the button.

The drop down menu can also be used to set the reasons why you have added someone to the Kill On Sight list. If you want to enter a specific reason that is not in the list, then use the "Other..." option.


|cffffd000Author: http://www.wowhead.com/?user=Immolation|cffffffff

]]
L["EnableSpy"] = "Enable Spy"
L["EnableSpyDescription"] = "Enables or disables Spy both now and also on login."
L["EnabledInBattlegrounds"] = "Enable Spy in battlegrounds"
L["EnabledInBattlegroundsDescription"] = "Enables or disables Spy when you are in a battleground."
L["EnabledInArenas"] = "Enable Spy in arenas"
L["EnabledInArenasDescription"] = "Enables or disables Spy when you are in an arena."
L["EnabledInWintergrasp"] = "Enable Spy in world combat zones"
L["EnabledInWintergraspDescription"] = "Enables or disables Spy when you are in world combat zones such as Lake Wintergrasp in Northrend."
L["DisableWhenPVPUnflagged"] = "Disable Spy when not flagged for PVP"
L["DisableWhenPVPUnflaggedDescription"] = "Enables or disables Spy depending on your PVP status."

L["DisplayOptions"] = "Display"
L["DisplayOptionsDescription"] = [[
Spy can be shown or hidden automatically.
]]
L["ShowOnDetection"] = "Show Spy when enemy players are detected"
L["ShowOnDetectionDescription"] = "Set this to display the Spy window and the Nearby list if Spy is hidden when enemy players are detected."
L["HideSpy"] = "Hide Spy when no enemy players are detected"
L["HideSpyDescription"] = "Set this to hide Spy when the Nearby list is displayed and it becomes empty. Spy will not be hidden if you clear the list manually."
L["ResizeSpy"] = "Resize the Spy window automatically"
L["ResizeSpyDescription"] = "Set this to automatically resize the Spy window as enemy players are added and removed."
L["TooltipDisplayWinLoss"] = "Display win/loss statistics in tooltip"
L["TooltipDisplayWinLossDescription"] = "Set this to display the win/loss statistics of a player in the player's tooltip."
L["TooltipDisplayKOSReason"] = "Display Kill On Sight reasons in tooltip"
L["TooltipDisplayKOSReasonDescription"] = "Set this to display the Kill On Sight reasons of a player in the player's tooltip."
L["TooltipDisplayLastSeen"] = "Display last seen details in tooltip"
L["TooltipDisplayLastSeenDescription"] = "Set this to display the last known time and location of a player in the player's tooltip."

L["AlertOptions"] = "Alerts"
L["AlertOptionsDescription"] = [[
You can announce the details on an encounter to a chat channel and control how Spy alerts you when enemy players are detected.
]]
L["Announce"] = "Announce to:"
L["None"] = "None"
L["NoneDescription"] = "Do not announce when enemy players are detected."
L["Self"] = "Self"
L["SelfDescription"] = "Announce to yourself when enemy players are detected."
L["Party"] = "Party"
L["PartyDescription"] = "Announce to your party when enemy players are detected."
L["Guild"] = "Guild"
L["GuildDescription"] = "Announce to your guild when enemy players are detected."
L["Raid"] = "Raid"
L["RaidDescription"] = "Announce to your raid when enemy players are detected."
L["LocalDefense"] = "Local Defense"
L["LocalDefenseDescription"] = "Announce to the Local Defense channel when enemy players are detected."
L["OnlyAnnounceKoS"] = "Only announce enemy players that are Kill On Sight"
L["OnlyAnnounceKoSDescription"] = "Set this to only announce enemy players that are on your Kill On Sight list."
L["WarnOnStealth"] = "Warn upon stealth detection"
L["WarnOnStealthDescription"] = "Set this to display a warning and sound an alert when an enemy player gains stealth."
L["WarnOnKOS"] = "Warn upon Kill On Sight detection"
L["WarnOnKOSDescription"] = "Set this to display a warning and sound an alert when an enemy player on your Kill On Sight list is detected."
L["WarnOnKOSGuild"] = "Warn upon Kill On Sight guild detection"
L["WarnOnKOSGuildDescription"] = "Set this to display a warning and sound an alert when an enemy player in the same guild as someone on your Kill On Sight list is detected."
L["DisplayWarningsInErrorsFrame"] = "Display warnings in the errors frame"
L["DisplayWarningsInErrorsFrameDescription"] = "Set this to use the errors frame to display warnings instead of using the graphical popup frames."
L["EnableSound"] = "Enable audio alerts"
L["EnableSoundDescription"] = "Set this to enable audio alerts when enemy players are detected. Different alerts sound if an enemy player gains stealth or if an enemy player is on your Kill On Sight list."

L["ListOptions"] = "Nearby List"
L["ListOptionsDescription"] = [[
You can configure how Spy adds and removes enemy players to and from the Nearby list.
]]
L["RemoveUndetected"] = "Remove enemy players from the Nearby list after:"
L["1Min"] = "1 minute"
L["1MinDescription"] = "Remove an enemy player who has been undetected for over 1 minute."
L["2Min"] = "2 minutes"
L["2MinDescription"] = "Remove an enemy player who has been undetected for over 2 minutes."
L["5Min"] = "5 minutes"
L["5MinDescription"] = "Remove an enemy player who has been undetected for over 5 minutes."
L["10Min"] = "10 minutes"
L["10MinDescription"] = "Remove an enemy player who has been undetected for over 10 minutes."
L["15Min"] = "15 minutes"
L["15MinDescription"] = "Remove an enemy player who has been undetected for over 15 minutes."
L["Never"] = "Never remove"
L["NeverDescription"] = "Never remove enemy players. The Nearby list can still be cleared manually."
L["ShowNearbyList"] = "Switch to the Nearby list upon enemy player detection"
L["ShowNearbyListDescription"] = "Set this to display the Nearby list if it is not already visible when enemy players are detected."
L["PrioritiseKoS"] = "Prioritise Kill On Sight enemy players in the Nearby list"
L["PrioritiseKoSDescription"] = "Set this to always show Kill On Sight enemy players first in the Nearby list."

L["MinimapOptions"] = "Map"
L["MinimapOptionsDescription"] = [[
For players who can track humanoids the minimap can be utilised to provide additional features.

Players who can track humanoids include hunters, druids, and those who have received the ability through other means such as eating a Blackened Worg Steak.
]]
L["MinimapTracking"] = "Enable minimap tracking"
L["MinimapTrackingDescription"] = "Set this to enable minimap tracking and detection. Known enemy players detected on the minimap will be added to the Nearby list."
L["MinimapDetails"] = "Display level/class details in tooltips"
L["MinimapDetailsDescription"] = "Set this to update the map tooltips so that level/class details are displayed alongside enemy names."
L["DisplayOnMap"] = "Display enemy location on map"
L["DisplayOnMapDescription"] = "Set this to display on the world map and minimap the location of enemies detected by other Spy users in your party, raid and guild."
L["MapDisplayLimit"] = "Limit displayed map icons to:"
L["LimitNone"] = "Everywhere"
L["LimitNoneDescription"] = "Displayes all detected enemies on the map regardless of your current location."
L["LimitSameZone"] = "Same zone"
L["LimitSameZoneDescription"] = "Only displays detected enemies on the map if you are in the same zone."
L["LimitSameContinent"] = "Same continent"
L["LimitSameContinentDescription"] = "Only displays detected enemies on the map if you are on the same continent."

L["DataOptions"] = "Data Management"
L["DataOptionsDescription"] = [[
You can configure how Spy maintains and gathers its data.
]]
L["PurgeData"] = "Purge undetected enemy player data after:"
L["OneDay"] = "1 day"
L["OneDayDescription"] = "Purge data for enemy players that have been undetected for 1 day."
L["FiveDays"] = "5 days"
L["FiveDaysDescription"] = "Purge data for enemy players that have been undetected for 5 days."
L["TenDays"] = "10 days"
L["TenDaysDescription"] = "Purge data for enemy players that have been undetected for 10 days."
L["ThirtyDays"] = "30 days"
L["ThirtyDaysDescription"] = "Purge data for enemy players that have been undetected for 30 days."
L["SixtyDays"] = "60 days"
L["SixtyDaysDescription"] = "Purge data for enemy players that have been undetected for 60 days."
L["NinetyDays"] = "90 days"
L["NinetyDaysDescription"] = "Purge data for enemy players that have been undetected for 90 days."
L["ShareData"] = "Share data with other Spy addon users"
L["ShareDataDescription"] = "Set this to share the details of your enemy player encounters with other Spy users in your party, raid and guild."
L["UseData"] = "Use data from other Spy addon users"
L["UseDataDescription"] = [[Set this to use the data collected by other Spy users in your party, raid and guild.

If another Spy user detects an enemy player then that enemy player will be added to your Nearby list if there is room.
]]
L["ShareKOSBetweenCharacters"] = "Share Kill On Sight players between your characters"
L["ShareKOSBetweenCharactersDescription"] = "Set this to share the players you mark as Kill On Sight between other characters that you play on the same server and faction."

L["SlashCommand"] = "Slash Command"
L["SpySlashDescription"] = "These buttons execute the same functions as the ones in the slash command /spy"
L["Show"] = "Show"
L["ShowDescription"] = "Shows the main window."
L["Reset"] = "Reset"
L["ResetDescription"] = "Resets the position and appearance of the main window."
L["Config"] = "Config"
L["ConfigDescription"] = "Open the Interface Addons configuration window for Spy."
L["KOS"] = "KOS"
L["KOSDescription"] = "Add/remove a player to/from the Kill On Sight list."
L["Ignore"] = "Ignore"
L["IgnoreDescription"] = "Add/remove a player to/from the Ignore list."

-- Lists
L["Nearby"] = "Nearby"
L["LastHour"] = "Last Hour"
L["Ignore"] = "Ignore"
L["KillOnSight"] = "Kill On Sight"

-- Class descriptions
L["DEATHKNIGHT"] = "Death Knight"
L["DRUID"] = "Druid"
L["HUNTER"] = "Hunter"
L["MAGE"] = "Mage"
L["PALADIN"] = "Paladin"
L["PRIEST"] = "Priest"
L["ROGUE"] = "Rogue"
L["SHAMAN"] = "Shaman"
L["WARLOCK"] = "Warlock"
L["WARRIOR"] = "Warrior"
L["UNKNOWN"] = "Unknown"

-- Stealth abilities
L["Stealth"] = "Stealth"
L["Prowl"] = "Prowl"

-- Channel names
L["LocalDefenseChannelName"] = "LocalDefense"

-- Minimap color codes
L["MinimapClassTextDEATHKNIGHT"] = "|cffc41e3a"
L["MinimapClassTextDRUID"] = "|cffff7c0a"
L["MinimapClassTextHUNTER"] = "|cffaad372"
L["MinimapClassTextMAGE"] = "|cff68ccef"
L["MinimapClassTextPALADIN"] = "|cfff48cba"
L["MinimapClassTextPRIEST"] = "|cffffffff"
L["MinimapClassTextROGUE"] = "|cfffff468"
L["MinimapClassTextSHAMAN"] = "|cff2359ff"
L["MinimapClassTextWARLOCK"] = "|cff9382c9"
L["MinimapClassTextWARRIOR"] = "|cffc69b6d"
L["MinimapClassTextUNKNOWN"] = "|cff191919"
L["MinimapGuildText"] = "|cffffffff"

-- Output messages
L["AlertStealthTitle"] = "Stealthed player detected!"
L["AlertKOSTitle"] = "Kill On Sight player detected!"
L["AlertKOSGuildTitle"] = "Kill On Sight player guild detected!"
L["AlertTitle_kosaway"] = "Kill On Sight player located by "
L["AlertTitle_kosguildaway"] = "Kill On Sight player guild located by "
L["StealthWarning"] = "|cff9933ffStealthed player detected: |cffffffff"
L["KOSWarning"] = "|cffff0000Kill On Sight player detected: |cffffffff"
L["KOSGuildWarning"] = "|cffff0000Kill On Sight player guild detected: |cffffffff"
L["SpySignatureColored"] = "|cff9933ff[Spy] "
L["PlayerDetectedColored"] = "Player detected: |cffffffff"
L["KillOnSightDetectedColored"] = "Kill On Sight player detected: |cffffffff"
L["PlayerAddedToIgnoreColored"] = "Added player to Ignore list: |cffffffff"
L["PlayerRemovedFromIgnoreColored"] = "Removed player from Ignore list: |cffffffff"
L["PlayerAddedToKOSColored"] = "Added player to Kill On Sight list: |cffffffff"
L["PlayerRemovedFromKOSColored"] = "Removed player from Kill On Sight list: |cffffffff"
L["PlayerDetected"] = "[Spy] Player detected: "
L["KillOnSightDetected"] = "[Spy] Kill On Sight player detected: "
L["Level"] = "Level"
L["LastSeen"] = "Last seen"
L["LessThanOneMinuteAgo"] = "less than a minute ago"
L["MinutesAgo"] = "minutes ago"
L["HoursAgo"] = "hours ago"
L["DaysAgo"] = "days ago"
L["Clear"] = "Clear"
L["AddToIgnoreList"] = "Add to Ignore list"
L["AddToKOSList"] = "Add to Kill On Sight list"
L["RemoveFromIgnoreList"] = "Remove from Ignore list"
L["RemoveFromKOSList"] = "Remove from Kill On Sight list"
L["AnnounceDropDownMenu"] = "Announce"
L["KOSReasonDropDownMenu"] = "Set Kill On Sight reason"
L["PartyDropDownMenu"] = "Party"
L["RaidDropDownMenu"] = "Raid"
L["GuildDropDownMenu"] = "Guild"
L["LocalDefenseDropDownMenu"] = "Local Defense"
L["Player"] = " (Player)"
L["KOSReason"] = "Kill On Sight"
L["KOSReasonIndent"] = "    "
L["KOSReasonOther"] = "Other..."
L["KOSReasonClear"] = "Clear"
L["StatsWins"] = "|cff40ff00Wins: "
L["StatsSeparator"] = "  "
L["StatsLoses"] = "|cff0070ddLoses: "
L["Located"] = "located:"
L["Yards"] = "yards"

Spy_KOSReasonListLength = 13
Spy_KOSReasonList = {
	[1] = {
		["title"] = "Started combat";
		["content"] = {
			"Ambushed me",
			"Always attacks me on sight",
			"Attacked me for no reason",
			"Attacked me while fighting mobs",
			"Attacked me while entering/leaving instances",
			"Attacked me while I was AFK",
			"Attacked me while I was mounted/flying",
			"Attacked me while I had low health/mana",
			"Steamrolled me with a group of enemies",
			"Doesn't attack without backup",
			"Dared to challenge me",
		};
	},
	[2] = {
		["title"] = "Style of combat";
		["content"] = {
			"Always calls for help",
			"Pushed me off a cliff",
			"Uses engineering tricks",
			"Uses too much crowd control",
			"Spams one ability all the time",
			"Forced me to take durability damage",
			"Killed me and escaped from my friends",
			"Ran away then ambushed me",
			"Always manages to escape",
			"Bubble hearths to escape",
			"Manages to stay in melee range",
			"Manages to stay at kiting range",
			"Absorbs too much damage",
			"Heals too much",
			"DPS's too much",
		};
	},
	[3] = {
		["title"] = "General behaviour";
		["content"] = {
			"Annoying",
			"Rudeness",
			"Cowardice",
			"Arrogance",
			"Overconfidence",
			"Untrustworthy",
			"Emotes too much",
			"Stalked me/friends",
			"Pretends to be good",
			"Emotes 'not going to happen'",
			"Waves goodbye at low health",
			"Tried to placate me with a wave",
			"Performed foul acts on my corpse",
			"Laughed at me",
			"Spat on me",
		};
	},
	[4] = {
		["title"] = "Camping";
		["content"] = {
			"Camped me",
			"Camped an alt",
			"Camped lowbies",
			"Camped from stealth",
			"Camped guild members",
			"Camped game NPCs/objectives",
			"Called in help to camp me",
			"Made levelling a nightmare",
			"Forced me to logout",
			"Won't fight my main",
		};
	},
	[5] = {
		["title"] = "Questing";
		["content"] = {
			"Attacked me while questing",
			"Attacked me after I helped with a quest",
			"Interfered with quest objectives",
			"Started a quest I wanted to do",
			"Killed my faction's NPCs",
			"Killed a quest NPC",
		};
	},
	[6] = {
		["title"] = "Stole resources";
		["content"] = {
			"Gathered herbs I wanted",
			"Gathered minerals I wanted",
			"Gathered resources I wanted",
			"Extracted gas from a cloud I wanted",
			"Killed me and stole my mob",
			"Skinned my kills",
			"Salvaged my kills",
			"Fished in my pool",
		};
	},
	[7] = {
		["title"] = "Battlegrounds";
		["content"] = {
			"Always loots corpses",
			"Very good flag runner",
			"Backcaps flags or bases",
			"Stealth caps flags or bases",
			"Killed me and took the flag",
			"Interferes with battleground objectives",
			"Took a power-up I wanted",
			"Forced tank to lose agro",
			"Caused a wipe",
			"Destroys siege engines",
			"Drops bombs",
			"Disarms bombs",
			"Fear bomber",
		};
	},
	[8] = {
		["title"] = "Real life";
		["content"] = {
			"Friend in real life",
			"Enemy in real life",
			"Spreads rumours about me",
			"Complains on the forums",
			"Spy for the other faction",
			"Traitor to my faction",
			"Reneged on a deal",
			"Pretentious nub",
			"Another know-it-all",
			"Another Johnny-come-lately",
			"Cross faction trash talker",
		};
	},
	[9] = {
		["title"] = "Difficulty";
		["content"] = {
			"Impossible to kill",
			"Wins most of the time",
			"Seems like a fair match",
			"Loses most of the time",
			"Fun to kill",
			"Easy honor",
		};
	},
	[10] = {
		["title"] = "Race";
		["content"] = {
			"Hate the player's race",
			"Blood Elves are narcissistic",
			"Draenei are slimy space squids",
			"Dwarves are short hairy doorstops",
			"Goblins would sell their own mothers for a profit",
			"Gnomes belong in a garden",
			"Humans are righteous busybodies",
			"Night Elves hug too many trees",
			"Orcs are warmongering barbarians",
			"Tauren should be on my burger",
			"Trolls should stay on web forums",
			"Undead are unnatural abominations",
			"Worgen have too many fleas",
		};
	},
	[11] = {
		["title"] = "Class";
		["content"] = {
			"Hate the player's class",
			"Death Knights are overpowered",
			"Druids are dirty animals",
			"Hunters are easy mode",
			"Mages are deluded intellects",
			"Paladins are sanctimonious fools",
			"Priests are pious preachers",
			"Rogues have no honor",
			"Shamans talk to imaginary animals",
			"Warlocks are necromantic sadists",
			"Warriors have anger issues",
		};
	},
	[12] = {
		["title"] = "Name";
		["content"] = {
			"Has a ridiculous name",
			"Pretentious name",
			"Variant of Legolas",
			"Name has weird characters",
			"Guild name is ridiculous",
			"Guild name uses only capital letters",
			"Guild name uses capital letters and spaces",
			"Guild name states they hate my faction",
		};
	},
	[13] = {
		["title"] = "Other";
		["content"] = {
			"Karma",
			"Red is dead",
			"Just because",
			"Fails at PvP",
			"Flagged for PvP",
			"Doesn't want to PvP",
			"Wastes both our time",
			"This player is a noob",
			"I really hate this player",
			"Doesn't level fast enough",
			"Exploits game mechanics",
			"Suspected hacker",
			"Farmer",
			"Other...",
		};
	},
}

StaticPopupDialogs["Spy_SetKOSReasonOther"] = {
	text = "Enter the Kill On Sight reason for %s:",
	button1 = "Set",
	button2 = "Cancel",
	timeout = 0,
	hasEditBox = 1,
	whileDead = 1,
	hideOnEscape = 1,
	OnShow = function(self)
		self.editBox:SetText("");
	end,
    	OnAccept = function(self)
		local reason = self.editBox:GetText()
		Spy:SetKOSReason(self.playerName, "Other...", reason)
	end,
};

Spy_AbilityList = {

-----------------------------------------------------------
-- Allows an estimation of the race, class and level of a
-- player to be determined from what abilities are observed
-- in the combat log.
-----------------------------------------------------------

--== Racials ==
	["Stoneform"] = 		{ race = "Dwarf", level = 1, },
	["Escape Artist"] = 		{ race = "Gnome", level = 1, },
	["Every Man for Himself"] = 	{ race = "Human", level = 1, },
	["Shadowmeld"] = 		{ race = "Night Elf", level = 1, },
	["Gift of the Naaru"] = 	{ race = "Draenei", level = 1, },
	["Darkflight"] = 		{ race = "Worgen", level = 1, },
	["Two Forms"] = 		{ race = "Worgen", level = 1, },
	["Running Wild"] = 		{ race = "Worgen", level = 1, },
	["Blood Fury"] = 		{ race = "Orc", level = 1, },
	["War Stomp"] = 		{ race = "Tauren", level = 1, },
	["Berserking"] = 		{ race = "Troll", level = 1, },
	["Will of the Forsaken"] = 	{ race = "Undead", level = 1, },
	["Cannibalize"] = 		{ race = "Undead", level = 1, },
	["Arcane Torrent"] = 		{ race = "Blood Elf", level = 1, },
	["Mana Tap"] = 			{ race = "Blood Elf", level = 1, },
	["Rocket Jump"] = 		{ race = "Goblin", level = 1, },
	["Rocket Barrage"] = 		{ race = "Goblin", level = 1, },
	["Pack Hobgoblin"] = 		{ race = "Goblin", level = 1, },

--== Death Knight Abilities ==
	["Anti-Magic Shell"] = 			{ class = "DEATHKNIGHT", level = 68, },
	["Army of the Dead"] = 			{ class = "DEATHKNIGHT", level = 80, },
	["Blood Boil"] = 			{ class = "DEATHKNIGHT", level = 58, },
	["Blood Plague"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Blood Presence"] = 			{ class = "DEATHKNIGHT", level = 57, },
	["Blood Strike"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Blood Tap"] = 			{ class = "DEATHKNIGHT", level = 64, },
	["Chains of Ice"] = 			{ class = "DEATHKNIGHT", level = 58, },
	["Dark Command"] = 			{ class = "DEATHKNIGHT", level = 65, },
	["Dark Simulacrum"] = 			{ class = "DEATHKNIGHT", level = 85, },
	["Death Gate"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Death Grip"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Death Pact"] = 			{ class = "DEATHKNIGHT", level = 66, },
	["Death Strike"] = 			{ class = "DEATHKNIGHT", level = 56, },
	["Death and Decay"] = 			{ class = "DEATHKNIGHT", level = 60, },
	["Empower Rune Weapon"] = 		{ class = "DEATHKNIGHT", level = 75, },
	["Festering Strike"] = 			{ class = "DEATHKNIGHT", level = 64, },
	["Forceful Deflection"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Frost Fever"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Frost Presence"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Horn of Winter"] = 			{ class = "DEATHKNIGHT", level = 65, },
	["Icebound Fortitude"] = 		{ class = "DEATHKNIGHT", level = 62, },
	["Icy Touch"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Mind Freeze"] = 			{ class = "DEATHKNIGHT", level = 57, },
	["Necrotic Strike"] = 			{ class = "DEATHKNIGHT", level = 83, },
	["Obliterate"] = 			{ class = "DEATHKNIGHT", level = 61, },
	["Outbreak"] = 				{ class = "DEATHKNIGHT", level = 81, },
	["Path of Frost"] = 			{ class = "DEATHKNIGHT", level = 61, },
	["Pestilence"] = 			{ class = "DEATHKNIGHT", level = 56, },
	["Plague Strike"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Raise Ally"] = 			{ class = "DEATHKNIGHT", level = 72, },
	["Raise Dead"] = 			{ class = "DEATHKNIGHT", level = 56, },
	["Rune Strike"] = 			{ class = "DEATHKNIGHT", level = 67, },
	["Rune of Cinderglacier"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Rune of Lichbane"] = 			{ class = "DEATHKNIGHT", level = 60, },
	["Rune of Razorice"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Rune of Spellbreaking"] = 		{ class = "DEATHKNIGHT", level = 57, },
	["Rune of Spellshattering"] = 		{ class = "DEATHKNIGHT", level = 57, },
	["Rune of Swordbreaking"] = 		{ class = "DEATHKNIGHT", level = 63, },
	["Rune of Swordshattering"] = 		{ class = "DEATHKNIGHT", level = 63, },
	["Rune of the Nerubian Carapace"] = 	{ class = "DEATHKNIGHT", level = 72, },
	["Rune of the Stoneskin Gargoyle"] = 	{ class = "DEATHKNIGHT", level = 72, },
	["Runeforging"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Runic Empowerment"] = 		{ class = "DEATHKNIGHT", level = 68, },
	["Strangulate"] = 			{ class = "DEATHKNIGHT", level = 59, },
	["Unholy Presence"] = 			{ class = "DEATHKNIGHT", level = 70, },
--== Death Knight Talents ==
	["Abomination's Might"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Acherus Deathcharger"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Annihilation"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Anti-Magic Zone"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Blade Barrier"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Bladed Armor"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Blood Parasite"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Blood-Caked Blade"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Bone Shield"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Brittle Bones"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Butchery"] = 				{ class = "DEATHKNIGHT", level = 55, },
	["Chilblains"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Chill of the Grave"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Contagion"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Crimson Scourge"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Dancing Rune Weapon"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Dark Transformation"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Desecration"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Ebon Plaguebringer"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Endless Winter"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Epidemic"] = 				{ class = "DEATHKNIGHT", level = 55, },
	["Hand of Doom"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Howling Blast"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Hungering Cold"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Icy Reach"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Improved Blood Presence"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Improved Blood Tap"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Improved Death Strike"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Improved Frost Presence"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Improved Icy Talons"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Improved Unholy Presence"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Killing Machine"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Lichborne"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Magic Suppression"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Merciless Combat"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Might of the Frozen Wastes"] = 	{ class = "DEATHKNIGHT", level = 55, },
	["Morbidity"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Nerves of Cold Steel"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Pillar of Frost"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Rage of Rivendare"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Resilient Infection"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Rime"] = 				{ class = "DEATHKNIGHT", level = 55, },
	["Rune Tap"] = 				{ class = "DEATHKNIGHT", level = 55, },
	["Runic Corruption"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Runic Power Mastery"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Sanguine Fortitude"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Scarlet Fever"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Scent of Blood"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Shadow Infusion"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Sudden Doom"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Summon Gargoyle"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Threat of Thassarian"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Unholy Blight"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Unholy Command"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Unholy Frenzy"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Vampiric Blood"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Virulence"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Will of the Necropolis"] = 		{ class = "DEATHKNIGHT", level = 55, },
--== Death Knight Specialization ==
	["Blightcaller"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Blood Rites"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Blood Shield"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Blood of the North"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Frost Strike"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Frozen Heart"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Heart Strike"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Icy Talons"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Master of Ghouls"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Reaping"] = 				{ class = "DEATHKNIGHT", level = 55, },
	["Scourge Strike"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Unholy Might"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Veteran of the Third War"] = 		{ class = "DEATHKNIGHT", level = 55, },

--== Druid Abilities ==
	["Aquatic Form"] = 			{ class = "DRUID", level = 16, },
	["Barkskin"] = 				{ class = "DRUID", level = 58, },
	["Bash"] = 				{ class = "DRUID", level = 32, },
	["Bear Form"] = 			{ class = "DRUID", level = 15, },
	["Cat Form"] = 				{ class = "DRUID", level = 8, },
	["Challenging Roar"] = 			{ class = "DRUID", level = 28, },
	["Claw"] = 				{ class = "DRUID", level = 8, },
	["Cower"] = 				{ class = "DRUID", level = 26, },
	["Cyclone"] = 				{ class = "DRUID", level = 74, },
	["Dash"] = 				{ class = "DRUID", level = 26, },
	["Demoralizing Roar"] = 		{ class = "DRUID", level = 15, },
	["Entangling Roots"] = 			{ class = "DRUID", level = 7, },
	["Faerie Fire"] = 			{ class = "DRUID", level = 24, },
	["Faerie Fire (Feral)"] = 		{ class = "DRUID", level = 24, },
	["Feline Grace"] = 			{ class = "DRUID", level = 26, },
	["Ferocious Bite"] = 			{ class = "DRUID", level = 8, },
	["Flight Form"] = 			{ class = "DRUID", level = 60, },
	["Frenzied Regeneration"] = 		{ class = "DRUID", level = 52, },
	["Growl"] = 				{ class = "DRUID", level = 15, },
	["Healing Touch"] = 			{ class = "DRUID", level = 3, },
	["Hibernate"] = 			{ class = "DRUID", level = 48, },
	["Hurricane"] = 			{ class = "DRUID", level = 44, },
	["Innervate"] = 			{ class = "DRUID", level = 28, },
	["Insect Swarm"] = 			{ class = "DRUID", level = 20, },
	["Lacerate"] = 				{ class = "DRUID", level = 66, },
	["Lifebloom"] = 			{ class = "DRUID", level = 64, },
	["Maim"] = 				{ class = "DRUID", level = 62, },
	["Mark of the Wild"] = 			{ class = "DRUID", level = 30, },
	["Maul"] = 				{ class = "DRUID", level = 15, },
	["Moonfire"] = 				{ class = "DRUID", level = 4, },
	["Nature's Focus"] = 			{ class = "DRUID", level = 1, },
	["Nature's Grasp"] = 			{ class = "DRUID", level = 52, },
	["Nourish"] = 				{ class = "DRUID", level = 78, },
	["Omen of Clarity"] = 			{ class = "DRUID", level = 20, },
	["Pounce"] = 				{ class = "DRUID", level = 32, },
	["Prowl"] = 				{ class = "DRUID", level = 10, },
	["Rake"] = 				{ class = "DRUID", level = 8, },
	["Ravage"] = 				{ class = "DRUID", level = 22, },
	["Ravage!"] = 				{ class = "DRUID", level = 22, },
	["Rebirth"] = 				{ class = "DRUID", level = 20, },
	["Regrowth"] = 				{ class = "DRUID", level = 12, },
	["Rejuvenation"] = 			{ class = "DRUID", level = 8, },
	["Remove Corruption"] = 		{ class = "DRUID", level = 24, },
	["Revive"] = 				{ class = "DRUID", level = 12, },
	["Rip"] = 				{ class = "DRUID", level = 54, },
	["Savage Defense"] = 			{ class = "DRUID", level = 40, },
	["Savage Roar"] = 			{ class = "DRUID", level = 76, },
	["Shred"] = 				{ class = "DRUID", level = 46, },
	["Skull Bash"] = 			{ class = "DRUID", level = 22, },
	["Soothe"] = 				{ class = "DRUID", level = 28, },
	["Stampeding Roar"] = 			{ class = "DRUID", level = 83, },
	["Starfire"] = 				{ class = "DRUID", level = 8, },
	["Swift Flight Form"] = 		{ class = "DRUID", level = 71, },
	["Swipe"] = 				{ class = "DRUID", level = 36, },
	["Teleport: Moonglade"] = 		{ class = "DRUID", level = 15, },
	["Thorns"] = 				{ class = "DRUID", level = 5, },
	["Thrash"] = 				{ class = "DRUID", level = 81, },
	["Tiger's Fury"] = 			{ class = "DRUID", level = 24, },
	["Tranquility"] = 			{ class = "DRUID", level = 68, },
	["Travel Form"] = 			{ class = "DRUID", level = 16, },
	["Wild Mushroom"] = 			{ class = "DRUID", level = 85, },
	["Wild Mushroom: Detonate"] = 		{ class = "DRUID", level = 85, },
	["Wrath"] = 				{ class = "DRUID", level = 1, },
--== Druid Talents ==
	["Balance of Power"] = 			{ class = "DRUID", level = 15, },
	["Berserk"] = 				{ class = "DRUID", level = 40, },
	["Blessing of the Grove"] = 		{ class = "DRUID", level = 10, },
	["Blood in the Water"] = 		{ class = "DRUID", level = 35, },
	["Brutal Impact"] = 			{ class = "DRUID", level = 25, },
	["Dreamstate"] = 			{ class = "DRUID", level = 30, },
	["Earth and Moon"] = 			{ class = "DRUID", level = 30, },
	["Efflorescence"] = 			{ class = "DRUID", level = 30, },
	["Empowered Touch"] = 			{ class = "DRUID", level = 25, },
	["Endless Carnage"] = 			{ class = "DRUID", level = 30, },
	["Euphoria"] = 				{ class = "DRUID", level = 20, },
	["Feral Aggression"] = 			{ class = "DRUID", level = 15, },
	["Feral Charge"] = 			{ class = "DRUID", level = 20, },
	["Feral Swiftness"] = 			{ class = "DRUID", level = 10, },
	["Force of Nature"] = 			{ class = "DRUID", level = 30, },
	["Fungal Growth"] = 			{ class = "DRUID", level = 35, },
	["Furor"] = 				{ class = "DRUID", level = 10, },
	["Fury Swipes"] = 			{ class = "DRUID", level = 15, },
	["Fury of Stormrage"] = 		{ class = "DRUID", level = 20, },
	["Gale Winds"] = 			{ class = "DRUID", level = 25, },
	["Genesis"] = 				{ class = "DRUID", level = 15, },
	["Gift of the Earthmother"] = 		{ class = "DRUID", level = 35, },
	["Heart of the Wild"] = 		{ class = "DRUID", level = 10, },
	["Improved Rejuvenation"] = 		{ class = "DRUID", level = 15, },
	["Infected Wounds"] = 			{ class = "DRUID", level = 15, },
	["King of the Jungle"] = 		{ class = "DRUID", level = 20, },
	["Leader of the Pack"] = 		{ class = "DRUID", level = 25, },
	["Living Seed"] = 			{ class = "DRUID", level = 20, },
	["Lunar Shower"] = 			{ class = "DRUID", level = 35, },
	["Malfurion's Gift"] = 			{ class = "DRUID", level = 25, },
	["Master Shapeshifter"] = 		{ class = "DRUID", level = 15, },
	["Moonglow"] = 				{ class = "DRUID", level = 15, },
	["Moonkin Form"] = 			{ class = "DRUID", level = 20, },
	["Natural Reaction"] = 			{ class = "DRUID", level = 30, },
	["Natural Shapeshifter"] = 		{ class = "DRUID", level = 10, },
	["Naturalist"] = 			{ class = "DRUID", level = 10, },
	["Nature's Bounty"] = 			{ class = "DRUID", level = 25, },
	["Nature's Cure"] = 			{ class = "DRUID", level = 30, },
	["Nature's Grace"] = 			{ class = "DRUID", level = 10, },
	["Nature's Majesty"] = 			{ class = "DRUID", level = 10, },
	["Nature's Ward"] = 			{ class = "DRUID", level = 30, },
	["Nurturing Instinct"] = 		{ class = "DRUID", level = 25, },
	["Owlkin Frenzy"] = 			{ class = "DRUID", level = 25, },
	["Perseverance"] = 			{ class = "DRUID", level = 15, },
	["Predatory Strikes"] = 		{ class = "DRUID", level = 10, },
	["Primal Fury"] = 			{ class = "DRUID", level = 15, },
	["Primal Madness"] = 			{ class = "DRUID", level = 30, },
	["Pulverize"] = 			{ class = "DRUID", level = 35, },
	["Rend and Tear"] = 			{ class = "DRUID", level = 35, },
	["Revitalize"] = 			{ class = "DRUID", level = 20, },
	["Shooting Stars"] = 			{ class = "DRUID", level = 20, },
	["Solar Beam"] = 			{ class = "DRUID", level = 25, },
	["Stampede"] = 				{ class = "DRUID", level = 20, },
	["Starfall"] = 				{ class = "DRUID", level = 40, },
	["Starlight Wrath"] = 			{ class = "DRUID", level = 10, },
	["Sunfire"] = 				{ class = "DRUID", level = 30, },
	["Survival Instincts"] = 		{ class = "DRUID", level = 30, },
	["Swift Rejuvenation"] = 		{ class = "DRUID", level = 35, },
	["Thick Hide"] = 			{ class = "DRUID", level = 20, },
	["Tree of Life"] = 			{ class = "DRUID", level = 40, },
	["Typhoon"] = 				{ class = "DRUID", level = 20, },
	["Wild Growth"] = 			{ class = "DRUID", level = 30, },
--== Druid Specialization ==
	["Feral Instinct"] = 			{ class = "DRUID", level = 10, },
	["Gift of Nature"] = 			{ class = "DRUID", level = 10, },
	["Mangle"] = 				{ class = "DRUID", level = 10, },
	["Moonfury"] = 				{ class = "DRUID", level = 10, },
	["Razor Claws"] = 			{ class = "DRUID", level = 10, },
	["Savage Defender"] = 			{ class = "DRUID", level = 10, },
	["Starsurge"] = 			{ class = "DRUID", level = 10, },
	["Swiftmend"] = 			{ class = "DRUID", level = 10, },
	["Symbiosis"] = 			{ class = "DRUID", level = 10, },
	["Total Eclipse"] = 			{ class = "DRUID", level = 10, },

--== Hunter Abilities ==
	["Aimed Shot!"] = 			{ class = "HUNTER", level = 20, },
	["Arcane Shot"] = 			{ class = "HUNTER", level = 1, },
	["Aspect of the Cheetah"] = 		{ class = "HUNTER", level = 16, },
	["Aspect of the Fox"] = 		{ class = "HUNTER", level = 83, },
	["Aspect of the Hawk"] = 		{ class = "HUNTER", level = 12, },
	["Aspect of the Pack"] = 		{ class = "HUNTER", level = 56, },
	["Aspect of the Wild"] = 		{ class = "HUNTER", level = 64, },
	["Auto Shot"] = 			{ class = "HUNTER", level = 1, },
	["Beast Lore"] = 			{ class = "HUNTER", level = 10, },
	["Call Pet 1"] = 			{ class = "HUNTER", level = 1, },
	["Call Pet 2"] = 			{ class = "HUNTER", level = 18, },
	["Call Pet 3"] = 			{ class = "HUNTER", level = 42, },
	["Call Pet 4"] = 			{ class = "HUNTER", level = 62, },
	["Call Pet 5"] = 			{ class = "HUNTER", level = 82, },
	["Camouflage"] = 			{ class = "HUNTER", level = 85, },
	["Cobra Shot"] = 			{ class = "HUNTER", level = 81, },
	["Concussive Shot"] = 			{ class = "HUNTER", level = 8, },
	["Control Pet"] = 			{ class = "HUNTER", level = 10, },
	["Deterrence"] = 			{ class = "HUNTER", level = 78, },
	["Disengage"] = 			{ class = "HUNTER", level = 14, },
	["Dismiss Pet"] = 			{ class = "HUNTER", level = 10, },
	["Distracting Shot"] = 			{ class = "HUNTER", level = 52, },
	["Eagle Eye"] = 			{ class = "HUNTER", level = 16, },
	["Explosive Trap"] = 			{ class = "HUNTER", level = 38, },
	["Feed Pet"] = 				{ class = "HUNTER", level = 10, },
	["Feign Death"] = 			{ class = "HUNTER", level = 32, },
	["Flare"] = 				{ class = "HUNTER", level = 38, },
	["Freezing Trap"] = 			{ class = "HUNTER", level = 28, },
	["Hunter's Mark"] = 			{ class = "HUNTER", level = 14, },
	["Ice Trap"] = 				{ class = "HUNTER", level = 46, },
	["Immolation Trap"] = 			{ class = "HUNTER", level = 22, },
	["Kill Command"] = 			{ class = "HUNTER", level = 10, },
	["Kill Shot"] = 			{ class = "HUNTER", level = 35, },
	["Master's Call"] = 			{ class = "HUNTER", level = 74, },
	["Mend Pet"] = 				{ class = "HUNTER", level = 16, },
	["Misdirection"] = 			{ class = "HUNTER", level = 76, },
	["Multi-Shot"] = 			{ class = "HUNTER", level = 24, },
	["Rapid Fire"] = 			{ class = "HUNTER", level = 54, },
	["Raptor Strike"] = 			{ class = "HUNTER", level = 6, },
	["Revive Pet"] = 			{ class = "HUNTER", level = 1, },
	["Scare Beast"] = 			{ class = "HUNTER", level = 36, },
	["Scatter Shot"] = 			{ class = "HUNTER", level = 15, },
	["Serpent Sting"] = 			{ class = "HUNTER", level = 10, },
	["Snake Trap"] = 			{ class = "HUNTER", level = 48, },
	["Steady Shot"] = 			{ class = "HUNTER", level = 3, },
	["Tame Beast"] = 			{ class = "HUNTER", level = 10, },
	["Track Beasts"] = 			{ class = "HUNTER", level = 4, },
	["Track Demons"] = 			{ class = "HUNTER", level = 36, },
	["Track Dragonkin"] = 			{ class = "HUNTER", level = 52, },
	["Track Elementals"] = 			{ class = "HUNTER", level = 34, },
	["Track Giants"] = 			{ class = "HUNTER", level = 46, },
	["Track Hidden"] = 			{ class = "HUNTER", level = 26, },
	["Track Undead"] = 			{ class = "HUNTER", level = 18, },
	["Tranquilizing Shot"] = 		{ class = "HUNTER", level = 35, },
	["Trap Launcher"] = 			{ class = "HUNTER", level = 48, },
	["Widow Venom"] = 			{ class = "HUNTER", level = 40, },
	["Wing Clip"] = 			{ class = "HUNTER", level = 12, },
--== Hunter Talents ==
	["Beast Mastery"] = 			{ class = "HUNTER", level = 40, },
	["Bestial Discipline"] = 		{ class = "HUNTER", level = 10, },
	["Bestial Wrath"] = 			{ class = "HUNTER", level = 30, },
	["Black Arrow"] = 			{ class = "HUNTER", level = 40, },
	["Bombardment"] = 			{ class = "HUNTER", level = 25, },
	["Careful Aim"] = 			{ class = "HUNTER", level = 15, },
	["Chimera Shot"] = 			{ class = "HUNTER", level = 40, },
	["Cobra Strikes"] = 			{ class = "HUNTER", level = 20, },
	["Concussive Barrage"] = 		{ class = "HUNTER", level = 20, },
	["Counterattack"] = 			{ class = "HUNTER", level = 20, },
	["Crouching Tiger, Hidden Chimera"] = 	{ class = "HUNTER", level = 30, },
	["Efficiency"] = 			{ class = "HUNTER", level = 10, },
	["Entrapment"] = 			{ class = "HUNTER", level = 15, },
	["Ferocious Inspiration"] = 		{ class = "HUNTER", level = 30, },
	["Fervor"] = 				{ class = "HUNTER", level = 20, },
	["Focus Fire"] = 			{ class = "HUNTER", level = 20, },
	["Frenzy"] = 				{ class = "HUNTER", level = 15, },
	["Go for the Throat"] = 		{ class = "HUNTER", level = 10, },
	["Hunter vs. Wild"] = 			{ class = "HUNTER", level = 10, },
	["Hunting Party"] = 			{ class = "HUNTER", level = 30, },
	["Improved Kill Command"] = 		{ class = "HUNTER", level = 10, },
	["Improved Mend Pet"] = 		{ class = "HUNTER", level = 15, },
	["Improved Serpent Sting"] = 		{ class = "HUNTER", level = 11, },
	["Improved Steady Shot"] = 		{ class = "HUNTER", level = 15, },
	["Invigoration"] = 			{ class = "HUNTER", level = 35, },
	["Killing Streak"] = 			{ class = "HUNTER", level = 25, },
	["Kindred Spirits"] = 			{ class = "HUNTER", level = 35, },
	["Lock and Load"] = 			{ class = "HUNTER", level = 20, },
	["Longevity"] = 			{ class = "HUNTER", level = 25, },
	["Marked for Death"] = 			{ class = "HUNTER", level = 35, },
	["Master Marksman"] = 			{ class = "HUNTER", level = 30, },
	["Mirrored Blades"] = 			{ class = "HUNTER", level = 25, },
	["Noxious Stings"] = 			{ class = "HUNTER", level = 30, },
	["One with Nature"] = 			{ class = "HUNTER", level = 10, },
	["Pathfinding"] = 			{ class = "HUNTER", level = 15, },
	["Pathing"] = 				{ class = "HUNTER", level = 10, },
	["Piercing Shots"] = 			{ class = "HUNTER", level = 20, },
	["Point of No Escape"] = 		{ class = "HUNTER", level = 15, },
	["Posthaste"] = 			{ class = "HUNTER", level = 35, },
	["Rapid Killing"] = 			{ class = "HUNTER", level = 10, },
	["Rapid Recuperation"] = 		{ class = "HUNTER", level = 30, },
	["Readiness"] = 			{ class = "HUNTER", level = 30, },
	["Resistance is Futile"] = 		{ class = "HUNTER", level = 25, },
	["Resourcefulness"] = 			{ class = "HUNTER", level = 25, },
	["Serpent Spread"] = 			{ class = "HUNTER", level = 35, },
	["Sic 'Em!"] = 				{ class = "HUNTER", level = 15, },
	["Silencing Shot"] = 			{ class = "HUNTER", level = 20, },
	["Sniper Training"] = 			{ class = "HUNTER", level = 35, },
	["Spirit Bond"] = 			{ class = "HUNTER", level = 15, },
	["Survival Tactics"] = 			{ class = "HUNTER", level = 15, },
	["T.N.T."] = 				{ class = "HUNTER", level = 25, },
	["Termination"] = 			{ class = "HUNTER", level = 25, },
	["The Beast Within"] = 			{ class = "HUNTER", level = 35, },
	["Thrill of the Hunt"] = 		{ class = "HUNTER", level = 20, },
	["Toxicology"] = 			{ class = "HUNTER", level = 30, },
	["Trap Mastery"] = 			{ class = "HUNTER", level = 15, },
	["Trueshot Aura"] = 			{ class = "HUNTER", level = 25, },
	["Wyvern Sting"] = 			{ class = "HUNTER", level = 30, },
--== Hunter Specialization ==
	["Aimed Shot"] = 			{ class = "HUNTER", level = 10, },
	["Animal Handler"] = 			{ class = "HUNTER", level = 10, },
	["Artisan Quiver"] = 			{ class = "HUNTER", level = 10, },
	["Essence of the Viper"] = 		{ class = "HUNTER", level = 10, },
	["Explosive Shot"] = 			{ class = "HUNTER", level = 10, },
	["Intimidation"] = 			{ class = "HUNTER", level = 10, },
	["Into the Wilderness"] = 		{ class = "HUNTER", level = 10, },
	["Master of Beasts"] = 			{ class = "HUNTER", level = 10, },
	["Wild Quiver"] = 			{ class = "HUNTER", level = 10, },

--== Mage Abilities ==
	["Conjure Mana Gem"] = 			{ class = "MAGE", level = 48, },
	["Arcane Blast"] = 			{ class = "MAGE", level = 20, },
	["Arcane Brilliance"] = 		{ class = "MAGE", level = 58, },
	["Arcane Explosion"] = 			{ class = "MAGE", level = 22, },
	["Arcane Missiles"] = 			{ class = "MAGE", level = 3, },
	["Blink"] = 				{ class = "MAGE", level = 16, },
	["Blizzard"] = 				{ class = "MAGE", level = 52, },
	["Cone of Cold"] = 			{ class = "MAGE", level = 18, },
	["Conjure Refreshment"] = 		{ class = "MAGE", level = 38, },
	["Counterspell"] = 			{ class = "MAGE", level = 9, },
	["Dalaran Brilliance"] = 		{ class = "MAGE", level = 80, },
	["Evocation"] = 			{ class = "MAGE", level = 12, },
	["Fire Blast"] = 			{ class = "MAGE", level = 5, },
	["Fireball"] = 				{ class = "MAGE", level = 1, },
	["Flame Orb"] = 			{ class = "MAGE", level = 81, },
	["Flamestrike"] = 			{ class = "MAGE", level = 44, },
	["Frost Armor"] = 			{ class = "MAGE", level = 54, },
	["Frost Nova"] = 			{ class = "MAGE", level = 8, },
	["Frostbolt"] = 			{ class = "MAGE", level = 7, },
	["Frostfire Bolt"] = 			{ class = "MAGE", level = 56, },
	["Ice Block"] = 			{ class = "MAGE", level = 30, },
	["Ice Lance"] = 			{ class = "MAGE", level = 28, },
	["Invisibility"] = 			{ class = "MAGE", level = 78, },
	["Mage Armor"] = 			{ class = "MAGE", level = 68, },
	["Mage Ward"] = 			{ class = "MAGE", level = 36, },
	["Mana Shield"] = 			{ class = "MAGE", level = 46, },
	["Mirror Image"] = 			{ class = "MAGE", level = 50, },
	["Molten Armor"] = 			{ class = "MAGE", level = 34, },
	["Polymorph"] = 			{ class = "MAGE", level = 14, },
	["Portal: Dalaran"] = 			{ class = "MAGE", level = 74, },
	["Portal: Darnassus"] = 		{ class = "MAGE", level = 42, },
	["Portal: Exodar"] = 			{ class = "MAGE", level = 42, },
	["Portal: Ironforge"] = 		{ class = "MAGE", level = 42, },
	["Portal: Orgrimmar"] = 		{ class = "MAGE", level = 42, },
	["Portal: Shattrath"] = 		{ class = "MAGE", level = 66, },
	["Portal: Silvermoon"] = 		{ class = "MAGE", level = 42, },
	["Portal: Stonard"] = 			{ class = "MAGE", level = 52, },
	["Portal: Stormwind"] = 		{ class = "MAGE", level = 42, },
	["Portal: Theramore"] = 		{ class = "MAGE", level = 42, },
	["Portal: Thunder Bluff"] = 		{ class = "MAGE", level = 42, },
	["Portal: Tol Barad"] = 		{ class = "MAGE", level = 85, },
	["Portal: Undercity"] = 		{ class = "MAGE", level = 42, },
	["Pyroblast!"] = 			{ class = "MAGE", level = 10, },
	["Remove Curse"] = 			{ class = "MAGE", level = 30, },
	["Ring of Frost"] = 			{ class = "MAGE", level = 83, },
	["Ritual of Refreshment"] = 		{ class = "MAGE", level = 70, },
	["Scorch"] = 				{ class = "MAGE", level = 26, },
	["Slow Fall"] = 			{ class = "MAGE", level = 32, },
	["Spellsteal"] = 			{ class = "MAGE", level = 76, },
	["Teleport: Dalaran"] = 		{ class = "MAGE", level = 71, },
	["Teleport: Darnassus"] = 		{ class = "MAGE", level = 24, },
	["Teleport: Exodar"] = 			{ class = "MAGE", level = 24, },
	["Teleport: Ironforge"] = 		{ class = "MAGE", level = 24, },
	["Teleport: Orgrimmar"] = 		{ class = "MAGE", level = 24, },
	["Teleport: Shattrath"] = 		{ class = "MAGE", level = 62, },
	["Teleport: Silvermoon"] = 		{ class = "MAGE", level = 24, },
	["Teleport: Stonard"] = 		{ class = "MAGE", level = 52, },
	["Teleport: Stormwind"] = 		{ class = "MAGE", level = 24, },
	["Teleport: Theramore"] = 		{ class = "MAGE", level = 24, },
	["Teleport: Thunder Bluff"] = 		{ class = "MAGE", level = 24, },
	["Teleport: Tol Barad"] = 		{ class = "MAGE", level = 85, },
	["Teleport: Undercity"] = 		{ class = "MAGE", level = 24, },
	["Time Warp"] = 			{ class = "MAGE", level = 85, },
	["Wizardry"] = 				{ class = "MAGE", level = 1, },
--== Mage Talents ==
	["Arcane Concentration"] = 		{ class = "MAGE", level = 10, },
	["Arcane Flows"] = 			{ class = "MAGE", level = 20, },
	["Arcane Potency"] = 			{ class = "MAGE", level = 30, },
	["Arcane Power"] = 			{ class = "MAGE", level = 40, },
	["Arcane Tactics"] = 			{ class = "MAGE", level = 25, },
	["Blast Wave"] = 			{ class = "MAGE", level = 20, },
	["Blazing Speed"] = 			{ class = "MAGE", level = 15, },
	["Brain Freeze"] = 			{ class = "MAGE", level = 25, },
	["Burning Soul"] = 			{ class = "MAGE", level = 10, },
	["Cauterize"] = 			{ class = "MAGE", level = 20, },
	["Cold Snap"] = 			{ class = "MAGE", level = 25, },
	["Combustion"] = 			{ class = "MAGE", level = 25, },
	["Critical Mass"] = 			{ class = "MAGE", level = 35, },
	["Deep Freeze"] = 			{ class = "MAGE", level = 40, },
	["Dragon's Breath"] = 			{ class = "MAGE", level = 30, },
	["Early Frost"] = 			{ class = "MAGE", level = 10, },
	["Enduring Winter"] = 			{ class = "MAGE", level = 25, },
	["Fingers of Frost"] = 			{ class = "MAGE", level = 20, },
	["Fire Power"] = 			{ class = "MAGE", level = 15, },
	["Firestarter"] = 			{ class = "MAGE", level = 25, },
	["Focus Magic"] = 			{ class = "MAGE", level = 35, },
	["Frostfire Orb"] = 			{ class = "MAGE", level = 35, },
	["Hot Streak"] = 			{ class = "MAGE", level = 20, },
	["Ice Barrier"] = 			{ class = "MAGE", level = 30, },
	["Ice Floes"] = 			{ class = "MAGE", level = 15, },
	["Ice Shards"] = 			{ class = "MAGE", level = 20, },
	["Icy Veins"] = 			{ class = "MAGE", level = 20, },
	["Ignite"] = 				{ class = "MAGE", level = 15, },
	["Impact"] = 				{ class = "MAGE", level = 15, },
	["Improved Arcane Explosion"] = 	{ class = "MAGE", level = 25, },
	["Improved Arcane Missiles"] = 		{ class = "MAGE", level = 15, },
	["Improved Blink"] = 			{ class = "MAGE", level = 15, },
	["Improved Cone of Cold"] = 		{ class = "MAGE", level = 15, },
	["Improved Counterspell"] = 		{ class = "MAGE", level = 10, },
	["Improved Fire Blast"] = 		{ class = "MAGE", level = 10, },
	["Improved Flamestrike"] = 		{ class = "MAGE", level = 30, },
	["Improved Freeze"] = 			{ class = "MAGE", level = 20, },
	["Improved Hot Streak"] = 		{ class = "MAGE", level = 25, },
	["Improved Mana Gem"] = 		{ class = "MAGE", level = 35, },
	["Improved Polymorph"] = 		{ class = "MAGE", level = 25, },
	["Improved Scorch"] = 			{ class = "MAGE", level = 20, },
	["Incanter's Absorption"] = 		{ class = "MAGE", level = 25, },
	["Invocation"] = 			{ class = "MAGE", level = 15, },
	["Living Bomb"] = 			{ class = "MAGE", level = 40, },
	["Master of Elements"] = 		{ class = "MAGE", level = 10, },
	["Missile Barrage"] = 			{ class = "MAGE", level = 20, },
	["Molten Fury"] = 			{ class = "MAGE", level = 30, },
	["Molten Shields"] = 			{ class = "MAGE", level = 25, },
	["Nether Vortex"] = 			{ class = "MAGE", level = 30, },
	["Netherwind Presence"] = 		{ class = "MAGE", level = 10, },
	["Permafrost"] = 			{ class = "MAGE", level = 15, },
	["Piercing Chill"] = 			{ class = "MAGE", level = 15, },
	["Piercing Ice"] = 			{ class = "MAGE", level = 10, },
	["Presence of Mind"] = 			{ class = "MAGE", level = 20, },
	["Prismatic Cloak"] = 			{ class = "MAGE", level = 20, },
	["Pyromaniac"] = 			{ class = "MAGE", level = 35, },
	["Reactive Barrier"] = 			{ class = "MAGE", level = 30, },
	["Shatter"] = 				{ class = "MAGE", level = 10, },
	["Shattered Barrier"] = 		{ class = "MAGE", level = 30, },
	["Slow"] = 				{ class = "MAGE", level = 30, },
	["Torment the Weak"] = 			{ class = "MAGE", level = 15, },
--== Mage Specialization ==
	["Arcane Barrage"] = 			{ class = "MAGE", level = 10, },
	["Arcane Specialization"] = 		{ class = "MAGE", level = 10, },
	["Fire Specialization"] = 		{ class = "MAGE", level = 10, },
	["Flashburn"] = 			{ class = "MAGE", level = 10, },
	["Frost Specialization"] = 		{ class = "MAGE", level = 10, },
	["Frostburn"] = 			{ class = "MAGE", level = 10, },
	["Mana Adept"] = 			{ class = "MAGE", level = 10, },
	["Pyroblast"] = 			{ class = "MAGE", level = 10, },
	["Summon Water Elemental"] = 		{ class = "MAGE", level = 10, },

--== Paladin Abilities ==
	["Avenging Wrath"] = 			{ class = "PALADIN", level = 72, },
	["Blessing of Kings"] = 		{ class = "PALADIN", level = 22, },
	["Blessing of Might"] = 		{ class = "PALADIN", level = 56, },
	["Cleanse"] = 				{ class = "PALADIN", level = 34, },
	["Concentration Aura"] = 		{ class = "PALADIN", level = 42, },
	["Consecration"] = 			{ class = "PALADIN", level = 24, },
	["Crusader Aura"] = 			{ class = "PALADIN", level = 62, },
	["Crusader Strike"] = 			{ class = "PALADIN", level = 1, },
	["Devotion Aura"] = 			{ class = "PALADIN", level = 5, },
	["Divine Light"] = 			{ class = "PALADIN", level = 62, },
	["Divine Plea"] = 			{ class = "PALADIN", level = 44, },
	["Divine Protection"] = 		{ class = "PALADIN", level = 30, },
	["Divine Shield"] = 			{ class = "PALADIN", level = 48, },
	["Exorcism"] = 				{ class = "PALADIN", level = 18, },
	["Flash of Light"] = 			{ class = "PALADIN", level = 16, },
	["Guardian of Ancient Kings"] = 	{ class = "PALADIN", level = 85, },
	["Hammer of Justice"] = 		{ class = "PALADIN", level = 7, },
	["Hammer of Wrath"] = 			{ class = "PALADIN", level = 46, },
	["Hand of Freedom"] = 			{ class = "PALADIN", level = 52, },
	["Hand of Protection"] = 		{ class = "PALADIN", level = 18, },
	["Hand of Reckoning"] = 		{ class = "PALADIN", level = 14, },
	["Hand of Sacrifice"] = 		{ class = "PALADIN", level = 80, },
	["Hand of Salvation"] = 		{ class = "PALADIN", level = 66, },
	["Holy Light"] = 			{ class = "PALADIN", level = 14, },
	["Holy Radiance"] = 			{ class = "PALADIN", level = 83, },
	["Holy Wrath"] = 			{ class = "PALADIN", level = 28, },
	["Inquisition"] = 			{ class = "PALADIN", level = 81, },
	["Judgement"] = 			{ class = "PALADIN", level = 3, },
	["Lay on Hands"] = 			{ class = "PALADIN", level = 16, },
	["Redemption"] = 			{ class = "PALADIN", level = 12, },
	["Resistance Aura"] = 			{ class = "PALADIN", level = 76, },
	["Retribution Aura"] = 			{ class = "PALADIN", level = 26, },
	["Righteous Defense"] = 		{ class = "PALADIN", level = 36, },
	["Righteous Fury"] = 			{ class = "PALADIN", level = 12, },
	["Seal of Insight"] = 			{ class = "PALADIN", level = 32, },
	["Seal of Justice"] = 			{ class = "PALADIN", level = 64, },
	["Seal of Righteousness"] = 		{ class = "PALADIN", level = 3, },
	["Seal of Truth"] = 			{ class = "PALADIN", level = 44, },
	["Turn Evil"] = 			{ class = "PALADIN", level = 78, },
	["Word of Glory"] = 			{ class = "PALADIN", level = 9, },
--== Paladin Talents ==
	["Acts of Sacrifice"] = 		{ class = "PALADIN", level = 35, },
	["Arbiter of the Light"] = 		{ class = "PALADIN", level = 10, },
	["Ardent Defender"] = 			{ class = "PALADIN", level = 40, },
	["Aura Mastery"] = 			{ class = "PALADIN", level = 30, },
	["Beacon of Light"] = 			{ class = "PALADIN", level = 25, },
	["Blazing Light"] = 			{ class = "PALADIN", level = 15, },
	["Blessed Life"] = 			{ class = "PALADIN", level = 35, },
	["Clarity of Purpose"] = 		{ class = "PALADIN", level = 15, },
	["Communion"] = 			{ class = "PALADIN", level = 20, },
	["Conviction"] = 			{ class = "PALADIN", level = 30, },
	["Crusade"] = 				{ class = "PALADIN", level = 10, },
	["Daybreak"] = 				{ class = "PALADIN", level = 20, },
	["Denounce"] = 				{ class = "PALADIN", level = 20, },
	["Divine Favor"] = 			{ class = "PALADIN", level = 20, },
	["Divine Guardian"] = 			{ class = "PALADIN", level = 30, },
	["Divine Purpose"] = 			{ class = "PALADIN", level = 30, },
	["Divine Storm"] = 			{ class = "PALADIN", level = 20, },
	["Divinity"] = 				{ class = "PALADIN", level = 10, },
	["Enlightened Judgements"] = 		{ class = "PALADIN", level = 25, },
	["Eternal Glory"] = 			{ class = "PALADIN", level = 10, },
	["Eye for an Eye"] = 			{ class = "PALADIN", level = 10, },
	["Grand Crusader"] = 			{ class = "PALADIN", level = 25, },
	["Guarded by the Light"] = 		{ class = "PALADIN", level = 30, },
	["Guardian's Favor"] = 			{ class = "PALADIN", level = 15, },
	["Hallowed Ground"] = 			{ class = "PALADIN", level = 20, },
	["Hammer of the Righteous"] = 		{ class = "PALADIN", level = 20, },
	["Holy Shield"] = 			{ class = "PALADIN", level = 30, },
	["Improved Hammer of Justice"] = 	{ class = "PALADIN", level = 15, },
	["Improved Judgement"] = 		{ class = "PALADIN", level = 10, },
	["Infusion of Light"] = 		{ class = "PALADIN", level = 20, },
	["Inquiry of Faith"] = 			{ class = "PALADIN", level = 35, },
	["Judgements of the Just"] = 		{ class = "PALADIN", level = 15, },
	["Judgements of the Pure"] = 		{ class = "PALADIN", level = 10, },
	["Last Word"] = 			{ class = "PALADIN", level = 15, },
	["Light of Dawn"] = 			{ class = "PALADIN", level = 40, },
	["Long Arm of the Law"] = 		{ class = "PALADIN", level = 20, },
	["Paragon of Virtue"] = 		{ class = "PALADIN", level = 30, },
	["Protector of the Innocent"] = 	{ class = "PALADIN", level = 10, },
	["Pursuit of Justice"] = 		{ class = "PALADIN", level = 15, },
	["Rebuke"] = 				{ class = "PALADIN", level = 25, },
	["Reckoning"] = 			{ class = "PALADIN", level = 25, },
	["Repentance"] = 			{ class = "PALADIN", level = 30, },
	["Rule of Law"] = 			{ class = "PALADIN", level = 15, },
	["Sacred Cleansing"] = 			{ class = "PALADIN", level = 25, },
	["Sacred Duty"] = 			{ class = "PALADIN", level = 35, },
	["Sanctified Wrath"] = 			{ class = "PALADIN", level = 25, },
	["Sanctity of Battle"] = 		{ class = "PALADIN", level = 25, },
	["Sanctuary"] = 			{ class = "PALADIN", level = 20, },
	["Seals of Command"] = 			{ class = "PALADIN", level = 25, },
	["Seals of the Pure"] = 		{ class = "PALADIN", level = 10, },
	["Selfless Healer"] = 			{ class = "PALADIN", level = 30, },
	["Shield of the Righteous"] = 		{ class = "PALADIN", level = 25, },
	["Shield of the Templar"] = 		{ class = "PALADIN", level = 35, },
	["Speed of Light"] = 			{ class = "PALADIN", level = 25, },
	["The Art of War"] = 			{ class = "PALADIN", level = 20, },
	["Tower of Radiance"] = 		{ class = "PALADIN", level = 35, },
	["Vindication"] = 			{ class = "PALADIN", level = 30, },
	["Wrath of the Lightbringer"] = 	{ class = "PALADIN", level = 20, },
	["Zealotry"] = 				{ class = "PALADIN", level = 40, },
--== Paladin Specialization ==
	["Avenger's Shield"] = 			{ class = "PALADIN", level = 10, },
	["Divine Bulwark"] = 			{ class = "PALADIN", level = 10, },
	["Hand of Light"] = 			{ class = "PALADIN", level = 10, },
	["Holy Shock"] = 			{ class = "PALADIN", level = 10, },
	["Illuminated Healing"] = 		{ class = "PALADIN", level = 10, },
	["Judgements of the Bold"] = 		{ class = "PALADIN", level = 10, },
	["Judgements of the Wise"] = 		{ class = "PALADIN", level = 10, },
	["Sheath of Light"] = 			{ class = "PALADIN", level = 10, },
	["Templar's Verdict"] = 		{ class = "PALADIN", level = 10, },
	["Touched by the Light"] = 		{ class = "PALADIN", level = 10, },
	["Walk in the Light"] = 		{ class = "PALADIN", level = 10, },

--== Priest Abilities ==
	["Binding Heal"] = 			{ class = "PRIEST", level = 48, },	
	["Blessed Healing"] = 			{ class = "PRIEST", level = 20, },	
	["Cure Disease"] = 			{ class = "PRIEST", level = 22, },	
	["Devouring Plague"] = 			{ class = "PRIEST", level = 28, },	
	["Dispel Magic"] = 			{ class = "PRIEST", level = 26, },	
	["Divine Hymn"] = 			{ class = "PRIEST", level = 78, },	
	["Fade"] = 				{ class = "PRIEST", level = 24, },
	["Fear Ward"] = 			{ class = "PRIEST", level = 54, },	
	["Flash Heal"] = 			{ class = "PRIEST", level = 3, },	
	["Greater Heal"] = 			{ class = "PRIEST", level = 38, },	
	["Heal"] = 				{ class = "PRIEST", level = 16, },
	["Holy Fire"] = 			{ class = "PRIEST", level = 18, },	
	["Holy Nova"] = 			{ class = "PRIEST", level = 62, },	
	["Holy Word: Serenity"] = 		{ class = "PRIEST", level = 20, },		
	["Hymn of Hope"] = 			{ class = "PRIEST", level = 64, },	
	["Inner Fire"] = 			{ class = "PRIEST", level = 7, },	
	["Inner Will"] = 			{ class = "PRIEST", level = 83, },	
	["Leap of Faith"] = 			{ class = "PRIEST", level = 85, },	
	["Levitate"] = 				{ class = "PRIEST", level = 34, },
	["Mana Burn"] = 			{ class = "PRIEST", level = 58, },	
	["Mass Dispel"] = 			{ class = "PRIEST", level = 72, },	
	["Mind Blast"] = 			{ class = "PRIEST", level = 9, },	
	["Mind Control"] = 			{ class = "PRIEST", level = 38, },	
	["Mind Sear"] = 			{ class = "PRIEST", level = 74, },	
	["Mind Soothe"] = 			{ class = "PRIEST", level = 56, },	
	["Mind Spike"] = 			{ class = "PRIEST", level = 81, },	
	["Mind Vision"] = 			{ class = "PRIEST", level = 36, },	
	["Mysticism"] = 			{ class = "PRIEST", level = 50, },	
	["Power Word: Fortitude"] = 		{ class = "PRIEST", level = 14, },		
	["Power Word: Shield"] = 		{ class = "PRIEST", level = 5, },		
	["Prayer of Healing"] = 		{ class = "PRIEST", level = 44, },		
	["Prayer of Mending"] = 		{ class = "PRIEST", level = 68, },		
	["Psychic Scream"] = 			{ class = "PRIEST", level = 12, },	
	["Renew"] = 				{ class = "PRIEST", level = 8, },
	["Resurrection"] = 			{ class = "PRIEST", level = 14, },	
	["Shackle Undead"] = 			{ class = "PRIEST", level = 32, },	
	["Shadow Protection"] = 		{ class = "PRIEST", level = 52, },		
	["Shadow Word: Death"] = 		{ class = "PRIEST", level = 32, },		
	["Shadow Word: Pain"] = 		{ class = "PRIEST", level = 4, },		
	["Shadowfiend"] = 			{ class = "PRIEST", level = 66, },	
	["Smite"] = 				{ class = "PRIEST", level = 1, },
--== Priest Talents ==
	["Archangel"] = 			{ class = "PRIEST", level = 15, },
	["Atonement"] = 			{ class = "PRIEST", level = 20, },
	["Blessed Resilience"] = 		{ class = "PRIEST", level = 30, },
	["Body and Soul"] = 			{ class = "PRIEST", level = 30, },
	["Borrowed Time"] = 			{ class = "PRIEST", level = 25, },
	["Chakra"] = 				{ class = "PRIEST", level = 30, },
	["Circle of Healing"] = 		{ class = "PRIEST", level = 35, },
	["Darkness"] = 				{ class = "PRIEST", level = 10, },
	["Desperate Prayer"] = 			{ class = "PRIEST", level = 15, },
	["Dispersion"] = 			{ class = "PRIEST", level = 40, },
	["Divine Aegis"] = 			{ class = "PRIEST", level = 30, },
	["Divine Fury"] = 			{ class = "PRIEST", level = 10, },
	["Divine Touch"] = 			{ class = "PRIEST", level = 20, },
	["Empowered Healing"] = 		{ class = "PRIEST", level = 10, },
	["Evangelism"] = 			{ class = "PRIEST", level = 15, },
	["Focused Will"] = 			{ class = "PRIEST", level = 35, },
	["Grace"] = 				{ class = "PRIEST", level = 35, },
	["Guardian Spirit"] = 			{ class = "PRIEST", level = 40, },
	["Harnessed Shadows"] = 		{ class = "PRIEST", level = 20, },
	["Holy Concentration"] = 		{ class = "PRIEST", level = 20, },
	["Improved Devouring Plague"] = 	{ class = "PRIEST", level = 15, },
	["Improved Mind Blast"] = 		{ class = "PRIEST", level = 15, },
	["Improved Power Word: Shield"] = 	{ class = "PRIEST", level = 10, },
	["Improved Psychic Scream"] = 		{ class = "PRIEST", level = 15, },
	["Improved Renew"] = 			{ class = "PRIEST", level = 10, },
	["Improved Shadow Word: Pain"] = 	{ class = "PRIEST", level = 10, },
	["Inner Focus"] = 			{ class = "PRIEST", level = 20, },
	["Inner Sanctum"] = 			{ class = "PRIEST", level = 15, },
	["Inspiration"] = 			{ class = "PRIEST", level = 15, },
	["Lightwell"] = 			{ class = "PRIEST", level = 20, },
	["Masochism"] = 			{ class = "PRIEST", level = 25, },
	["Mental Agility"] = 			{ class = "PRIEST", level = 10, },
	["Mind Melt"] = 			{ class = "PRIEST", level = 25, },
	["Pain Suppression"] = 			{ class = "PRIEST", level = 30, },
	["Pain and Suffering"] = 		{ class = "PRIEST", level = 30, },
	["Paralysis"] = 			{ class = "PRIEST", level = 30, },
	["Phantasm"] = 				{ class = "PRIEST", level = 20, },
	["Power Infusion"] = 			{ class = "PRIEST", level = 20, },
	["Power Word: Barrier"] = 		{ class = "PRIEST", level = 40, },
	["Psychic Horror"] = 			{ class = "PRIEST", level = 35, },
	["Rapid Renewal"] = 			{ class = "PRIEST", level = 25, },
	["Rapture"] = 				{ class = "PRIEST", level = 25, },
	["Reflective Shield"] = 		{ class = "PRIEST", level = 25, },
	["Renewed Hope"] = 			{ class = "PRIEST", level = 20, },
	["Revelations"] = 			{ class = "PRIEST", level = 30, },
	["Serendipity"] = 			{ class = "PRIEST", level = 25, },
	["Shadowform"] = 			{ class = "PRIEST", level = 20, },
	["Shadowy Apparition"] = 		{ class = "PRIEST", level = 35, },
	["Silence"] = 				{ class = "PRIEST", level = 25, },
	["Sin and Punishment"] = 		{ class = "PRIEST", level = 35, },
	["Soul Warding"] = 			{ class = "PRIEST", level = 15, },
	["Spirit of Redemption"] = 		{ class = "PRIEST", level = 25, },
	["State of Mind"] = 			{ class = "PRIEST", level = 35, },
	["Strength of Soul"] = 			{ class = "PRIEST", level = 30, },
	["Surge of Light"] = 			{ class = "PRIEST", level = 15, },
	["Test of Faith"] = 			{ class = "PRIEST", level = 35, },
	["Tome of Light"] = 			{ class = "PRIEST", level = 20, },
	["Train of Thought"] = 			{ class = "PRIEST", level = 30, },
	["Twin Disciplines"] = 			{ class = "PRIEST", level = 10, },
	["Twisted Faith"] = 			{ class = "PRIEST", level = 15, },
	["Vampiric Embrace"] = 			{ class = "PRIEST", level = 25, },
	["Vampiric Touch"] = 			{ class = "PRIEST", level = 30, },
	["Veiled Shadows"] = 			{ class = "PRIEST", level = 10, },
--== Priest Specialization ==
	["Echo of Light"] = 			{ class = "PRIEST", level = 10, },
	["Enlightenment"] = 			{ class = "PRIEST", level = 10, },
	["Holy Word: Chastise"] = 		{ class = "PRIEST", level = 10, },
	["Mind Flay"] = 			{ class = "PRIEST", level = 10, },
	["Penance"] = 				{ class = "PRIEST", level = 10, },
	["Shadow Orb Power"] = 			{ class = "PRIEST", level = 10, },
	["Shadow Orbs"] = 			{ class = "PRIEST", level = 10, },
	["Shadow Power"] = 			{ class = "PRIEST", level = 10, },
	["Shield Discipline"] = 		{ class = "PRIEST", level = 10, },
	["Spiritual Healing"] = 		{ class = "PRIEST", level = 10, },

--== Rogue Abilities ==
	["Ambush"] = 				{ class = "ROGUE", level = 8, },
	["Backstab"] = 				{ class = "ROGUE", level = 18, },
	["Blind"] = 				{ class = "ROGUE", level = 34, },
	["Cheap Shot"] =		 	{ class = "ROGUE", level = 26, },
	["Cloak of Shadows"] = 			{ class = "ROGUE", level = 58, },
	["Combat Readiness"] = 			{ class = "ROGUE", level = 81, },
	["Deadly Throw"] = 			{ class = "ROGUE", level = 62, },
	["Detect Traps"] = 			{ class = "ROGUE", level = 32, },
	["Disarm Trap"] = 			{ class = "ROGUE", level = 44, },
	["Dismantle"] = 			{ class = "ROGUE", level = 38, },
	["Distract"] = 				{ class = "ROGUE", level = 28, },
	["Envenom"] = 				{ class = "ROGUE", level = 54, },
	["Evasion"] = 				{ class = "ROGUE", level = 9, },
	["Eviscerate"] = 			{ class = "ROGUE", level = 3, },
	["Expose Armor"] = 			{ class = "ROGUE", level = 36, },
	["Fan of Knives"] = 			{ class = "ROGUE", level = 80, },
	["Feint"] = 				{ class = "ROGUE", level = 42, },
	["Garrote"] = 				{ class = "ROGUE", level = 40, },
	["Gouge"] = 				{ class = "ROGUE", level = 16, },
	["Kick"] = 				{ class = "ROGUE", level = 14, },
	["Kidney Shot"] = 			{ class = "ROGUE", level = 30, },
	["Pick Lock"] = 			{ class = "ROGUE", level = 16, },
	["Pick Pocket"] = 			{ class = "ROGUE", level = 7, },
	["Poisons"] = 				{ class = "ROGUE", level = 10, },
	["Recuperate"] = 			{ class = "ROGUE", level = 12, },
	["Redirect"] = 				{ class = "ROGUE", level = 83, },
	["Rupture"] = 				{ class = "ROGUE", level = 46, },
	["Safe Fall"] = 			{ class = "ROGUE", level = 48, },
	["Sap"] = 				{ class = "ROGUE", level = 10, },
	["Shiv"] = 				{ class = "ROGUE", level = 70, },
	["Sinister Strike"] = 			{ class = "ROGUE", level = 1, },
	["Sinister Strike Enabler"] = 		{ class = "ROGUE", level = 3, },
	["Slice and Dice"] = 			{ class = "ROGUE", level = 22, },
	["Smoke Bomb"] = 			{ class = "ROGUE", level = 85, },
	["Sprint"] = 				{ class = "ROGUE", level = 16, },
	["Stealth"] = 				{ class = "ROGUE", level = 5, },
	["Tricks of the Trade"] = 		{ class = "ROGUE", level = 75, },
	["Vanish"] = 				{ class = "ROGUE", level = 24, },
--== Rogue Talents ==
	["Adrenaline Rush"] = 			{ class = "ROGUE", level = 30, },
	["Bandit's Guile"] = 			{ class = "ROGUE", level = 35, },
	["Blackjack"] = 			{ class = "ROGUE", level = 15, },
	["Blade Twisting"] = 			{ class = "ROGUE", level = 25, },
	["Cheat Death"] = 			{ class = "ROGUE", level = 30, },
	["Cold Blood"] = 			{ class = "ROGUE", level = 20, },
	["Combat Potency"] = 			{ class = "ROGUE", level = 25, },
	["Coup de Grace"] = 			{ class = "ROGUE", level = 10, },
	["Cut to the Chase"] = 			{ class = "ROGUE", level = 35, },
	["Deadened Nerves"] = 			{ class = "ROGUE", level = 25, },
	["Deadly Brew"] = 			{ class = "ROGUE", level = 20, },
	["Deadly Momentum"] = 			{ class = "ROGUE", level = 10, },
	["Elusiveness"] = 			{ class = "ROGUE", level = 15, },
	["Energetic Recovery"] = 		{ class = "ROGUE", level = 20, },
	["Enveloping Shadows"] = 		{ class = "ROGUE", level = 25, },
	["Find Weakness"] = 			{ class = "ROGUE", level = 20, },
	["Hemorrhage"] = 			{ class = "ROGUE", level = 20, },
	["Honor Among Thieves"] = 		{ class = "ROGUE", level = 25, },
	["Improved Ambush"] = 			{ class = "ROGUE", level = 10, },
	["Improved Expose Armor"] = 		{ class = "ROGUE", level = 30, },
	["Improved Gouge"] = 			{ class = "ROGUE", level = 20, },
	["Improved Kick"] = 			{ class = "ROGUE", level = 15, },
	["Improved Recuperate"] = 		{ class = "ROGUE", level = 10, },
	["Improved Sinister Strike"] = 		{ class = "ROGUE", level = 10, },
	["Improved Slice and Dice"] = 		{ class = "ROGUE", level = 15, },
	["Improved Sprint"] = 			{ class = "ROGUE", level = 15, },
	["Initiative"] = 			{ class = "ROGUE", level = 15, },
	["Killing Spree"] = 			{ class = "ROGUE", level = 40, },
	["Lethality"] = 			{ class = "ROGUE", level = 10, },
	["Lightning Reflexes"] = 		{ class = "ROGUE", level = 20, },
	["Master Poisoner"] = 			{ class = "ROGUE", level = 30, },
	["Murderous Intent"] = 			{ class = "ROGUE", level = 30, },
	["Nightstalker"] = 			{ class = "ROGUE", level = 10, },
	["Opportunity"] = 			{ class = "ROGUE", level = 15, },
	["Overkill"] = 				{ class = "ROGUE", level = 30, },
	["Precision"] = 			{ class = "ROGUE", level = 10, },
	["Premeditation"] = 			{ class = "ROGUE", level = 25, },
	["Preparation"] = 			{ class = "ROGUE", level = 30, },
	["Puncturing Wounds"] = 		{ class = "ROGUE", level = 15, },
	["Quickening"] = 			{ class = "ROGUE", level = 15, },
	["Reinforced Leather"] = 		{ class = "ROGUE", level = 20, },
	["Relentless Strikes"] = 		{ class = "ROGUE", level = 10, },
	["Restless Blades"] = 			{ class = "ROGUE", level = 35, },
	["Revealing Strike"] = 			{ class = "ROGUE", level = 20, },
	["Ruthlessness"] = 			{ class = "ROGUE", level = 15, },
	["Sanguinary Vein"] = 			{ class = "ROGUE", level = 30, },
	["Savage Combat"] = 			{ class = "ROGUE", level = 30, },
	["Seal Fate"] = 			{ class = "ROGUE", level = 25, },
	["Serrated Blades"] = 			{ class = "ROGUE", level = 35, },
	["Shadow Dance"] = 			{ class = "ROGUE", level = 40, },
	["Slaughter from the Shadows"] = 	{ class = "ROGUE", level = 35, },
	["Throwing Specialization"] = 		{ class = "ROGUE", level = 30, },
	["Vendetta"] = 				{ class = "ROGUE", level = 40, },
	["Venomous Wounds"] = 			{ class = "ROGUE", level = 35, },
	["Vile Poisons"] = 			{ class = "ROGUE", level = 20, },
	["Waylay"] = 				{ class = "ROGUE", level = 15, },
--== Rogue Specialization ==
	["Ambidexterity"] = 			{ class = "ROGUE", level = 10, },
	["Assassin's Resolve"] = 		{ class = "ROGUE", level = 10, },
	["Blade Flurry"] = 			{ class = "ROGUE", level = 10, },
	["Improved Poisons"] = 			{ class = "ROGUE", level = 10, },
	["Main Gauche"] = 			{ class = "ROGUE", level = 10, },
	["Master of Subtlety"] = 		{ class = "ROGUE", level = 10, },
	["Mutilate"] = 				{ class = "ROGUE", level = 10, },
	["Potent Poisons"] = 			{ class = "ROGUE", level = 10, },
	["Shadowstep"] = 			{ class = "ROGUE", level = 10, },
	["Sinister Calling"] = 			{ class = "ROGUE", level = 10, },
	["Vitality"] = 				{ class = "ROGUE", level = 10, },

--== Shaman Abilities ==
	["Ancestral Spirit"] = 			{ class = "SHAMAN", level = 12, },
	["Astral Recall"] = 			{ class = "SHAMAN", level = 30, },
	["Bind Elemental"] = 			{ class = "SHAMAN", level = 64, },
	["Bloodlust"] = 			{ class = "SHAMAN", level = 70, },
	["Call of the Ancestors"] = 		{ class = "SHAMAN", level = 40, },
	["Call of the Elements"] = 		{ class = "SHAMAN", level = 30, },
	["Call of the Spirits"] = 		{ class = "SHAMAN", level = 50, },
	["Chain Heal"] = 			{ class = "SHAMAN", level = 40, },
	["Chain Lightning"] = 			{ class = "SHAMAN", level = 28, },
	["Cleanse Spirit"] = 			{ class = "SHAMAN", level = 18, },
	["Earth Elemental Totem"] = 		{ class = "SHAMAN", level = 56, },
	["Earth Shock"] = 			{ class = "SHAMAN", level = 5, },
	["Earthbind Totem"] = 			{ class = "SHAMAN", level = 18, },
	["Earthliving Weapon"] = 		{ class = "SHAMAN", level = 54, },
	["Elemental Resistance Totem"] = 	{ class = "SHAMAN", level = 62, },
	["Far Sight"] = 			{ class = "SHAMAN", level = 36, },
	["Fire Elemental Totem"] = 		{ class = "SHAMAN", level = 66, },
	["Fire Nova"] = 			{ class = "SHAMAN", level = 28, },
	["Flame Shock"] = 			{ class = "SHAMAN", level = 14, },
	["Flametongue Totem"] = 		{ class = "SHAMAN", level = 12, },
	["Flametongue Weapon"] = 		{ class = "SHAMAN", level = 10, },
	["Frost Shock"] = 			{ class = "SHAMAN", level = 22, },
	["Frostbrand Weapon"] = 		{ class = "SHAMAN", level = 26, },
	["Ghost Wolf"] = 			{ class = "SHAMAN", level = 16, },
	["Greater Healing Wave"] = 		{ class = "SHAMAN", level = 68, },
	["Grounding Totem"] = 			{ class = "SHAMAN", level = 38, },
	["Healing Rain"] = 			{ class = "SHAMAN", level = 83, },
	["Healing Stream Totem"] = 		{ class = "SHAMAN", level = 20, },
	["Healing Surge"] = 			{ class = "SHAMAN", level = 20, },
	["Healing Wave"] = 			{ class = "SHAMAN", level = 7, },
	["Heroism"] = 				{ class = "SHAMAN", level = 70, },
	["Hex"] = 				{ class = "SHAMAN", level = 80, },
	["Lava Burst"] = 			{ class = "SHAMAN", level = 34, },
	["Lightning Bolt"] = 			{ class = "SHAMAN", level = 1, },
	["Lightning Shield"] = 			{ class = "SHAMAN", level = 8, },
	["Magma Totem"] = 			{ class = "SHAMAN", level = 36, },
	["Mana Spring Totem"] = 		{ class = "SHAMAN", level = 42, },
	["Primal Strike"] = 			{ class = "SHAMAN", level = 3, },
	["Purge"] = 				{ class = "SHAMAN", level = 12, },
	["Reincarnation"] = 			{ class = "SHAMAN", level = 30, },
	["Rockbiter Weapon"] = 			{ class = "SHAMAN", level = 75, },
	["Searing Totem"] = 			{ class = "SHAMAN", level = 10, },
	["Spiritwalker's Grace"] = 		{ class = "SHAMAN", level = 85, },
	["Stoneclaw Totem"] = 			{ class = "SHAMAN", level = 58, },
	["Stoneskin Totem"] = 			{ class = "SHAMAN", level = 48, },
	["Strength of Earth Totem"] = 		{ class = "SHAMAN", level = 4, },
	["Totem of Tranquil Mind"] = 		{ class = "SHAMAN", level = 74, },
	["Totemic Recall"] = 			{ class = "SHAMAN", level = 30, },
	["Tremor Totem"] = 			{ class = "SHAMAN", level = 52, },
	["Unleash Elements"] = 			{ class = "SHAMAN", level = 81, },
	["Water Breathing"] = 			{ class = "SHAMAN", level = 46, },
	["Water Shield"] = 			{ class = "SHAMAN", level = 20, },
	["Water Walking"] = 			{ class = "SHAMAN", level = 24, },
	["Wind Shear"] = 			{ class = "SHAMAN", level = 16, },
	["Windfury Totem"] = 			{ class = "SHAMAN", level = 30, },
	["Windfury Weapon"] = 			{ class = "SHAMAN", level = 32, },
	["Wrath of Air Totem"] = 		{ class = "SHAMAN", level = 44, },
--== Shaman Talents ==
	["Acuity"] = 				{ class = "SHAMAN", level = 10, },
	["Ancestral Awakening"] = 		{ class = "SHAMAN", level = 30, },
	["Ancestral Healing"] = 		{ class = "SHAMAN", level = 20, },
	["Ancestral Resolve"] = 		{ class = "SHAMAN", level = 10, },
	["Ancestral Swiftness"] = 		{ class = "SHAMAN", level = 15, },
	["Blessing of the Eternals"] = 		{ class = "SHAMAN", level = 35, },
	["Call of Flame"] = 			{ class = "SHAMAN", level = 15, },
	["Cleansing Waters"] = 			{ class = "SHAMAN", level = 25, },
	["Concussion"] = 			{ class = "SHAMAN", level = 10, },
	["Convection"] = 			{ class = "SHAMAN", level = 10, },
	["Earth's Grasp"] = 			{ class = "SHAMAN", level = 30, },
	["Earthen Power"] = 			{ class = "SHAMAN", level = 30, },
	["Earthquake"] = 			{ class = "SHAMAN", level = 40, },
	["Elemental Devastation"] = 		{ class = "SHAMAN", level = 15, },
	["Elemental Focus"] = 			{ class = "SHAMAN", level = 20, },
	["Elemental Mastery"] = 		{ class = "SHAMAN", level = 30, },
	["Elemental Oath"] = 			{ class = "SHAMAN", level = 25, },
	["Elemental Precision"] = 		{ class = "SHAMAN", level = 15, },
	["Elemental Reach"] = 			{ class = "SHAMAN", level = 20, },
	["Elemental Warding"] = 		{ class = "SHAMAN", level = 15, },
	["Elemental Weapons"] = 		{ class = "SHAMAN", level = 10, },
	["Feedback"] = 				{ class = "SHAMAN", level = 35, },
	["Feral Spirit"] = 			{ class = "SHAMAN", level = 40, },
	["Focused Insight"] = 			{ class = "SHAMAN", level = 15, },
	["Focused Strikes"] = 			{ class = "SHAMAN", level = 10, },
	["Frozen Power"] = 			{ class = "SHAMAN", level = 25, },
	["Fulmination"] = 			{ class = "SHAMAN", level = 30, },
	["Improved Cleanse Spirit"] = 		{ class = "SHAMAN", level = 25, },
	["Improved Fire Nova"] = 		{ class = "SHAMAN", level = 25, },
	["Improved Lava Lash"] = 		{ class = "SHAMAN", level = 35, },
	["Improved Shields"] = 			{ class = "SHAMAN", level = 10, },
	["Improved Water Shield"] = 		{ class = "SHAMAN", level = 15, },
	["Lava Flows"] = 			{ class = "SHAMAN", level = 25, },
	["Lava Surge"] = 			{ class = "SHAMAN", level = 35, },
	["Maelstrom Weapon"] = 			{ class = "SHAMAN", level = 35, },
	["Mana Tide Totem"] = 			{ class = "SHAMAN", level = 30, },
	["Nature's Blessing"] = 		{ class = "SHAMAN", level = 20, },
	["Nature's Guardian"] = 		{ class = "SHAMAN", level = 15, },
	["Reverberation"] = 			{ class = "SHAMAN", level = 15, },
	["Riptide"] = 				{ class = "SHAMAN", level = 40, },
	["Rolling Thunder"] = 			{ class = "SHAMAN", level = 20, },
	["Searing Flames"] = 			{ class = "SHAMAN", level = 25, },
	["Shamanistic Rage"] = 			{ class = "SHAMAN", level = 30, },
	["Soothing Rains"] = 			{ class = "SHAMAN", level = 25, },
	["Spark of Life"] = 			{ class = "SHAMAN", level = 10, },
	["Static Shock"] = 			{ class = "SHAMAN", level = 20, },
	["Stormstrike"] = 			{ class = "SHAMAN", level = 20, },
	["Telluric Currents"] = 		{ class = "SHAMAN", level = 30, },
	["Tidal Focus"] = 			{ class = "SHAMAN", level = 10, },
	["Tidal Waves"] = 			{ class = "SHAMAN", level = 35, },
	["Totemic Focus"] = 			{ class = "SHAMAN", level = 15, },
	["Totemic Reach"] = 			{ class = "SHAMAN", level = 15, },
	["Totemic Wrath"] = 			{ class = "SHAMAN", level = 30, },
	["Unleashed Rage"] = 			{ class = "SHAMAN", level = 30, },
--== Shaman Specialization ==
	["Deep Healing"] = 			{ class = "SHAMAN", level = 10, },
	["Earth Shield"] = 			{ class = "SHAMAN", level = 10, },
	["Elemental Fury"] = 			{ class = "SHAMAN", level = 10, },
	["Elemental Overload"] = 		{ class = "SHAMAN", level = 10, },
	["Enhanced Elements"] = 		{ class = "SHAMAN", level = 10, },
	["Lava Lash"] = 			{ class = "SHAMAN", level = 10, },
	["Mental Quickness"] = 			{ class = "SHAMAN", level = 10, },
	["Primal Wisdom"] = 			{ class = "SHAMAN", level = 10, },
	["Purification"] = 			{ class = "SHAMAN", level = 10, },
	["Shamanism"] = 			{ class = "SHAMAN", level = 10, },
	["Thunderstorm"] = 			{ class = "SHAMAN", level = 10, },

--== Warlock Abilities ==
	["Amplify Curse"] = 			{ class = "WARLOCK", level = 1, },
	["Bane of Agony"] = 			{ class = "WARLOCK", level = 12, },
	["Bane of Doom"] = 			{ class = "WARLOCK", level = 20, },
	["Banish"] = 				{ class = "WARLOCK", level = 32, },
	["Control Demon"] = 			{ class = "WARLOCK", level = 10, },
	["Corruption"] = 			{ class = "WARLOCK", level = 4, },
	["Create Healthstone"] = 		{ class = "WARLOCK", level = 9, },
	["Create Soulstone"] = 			{ class = "WARLOCK", level = 18, },
	["Curse of the Elements"] = 		{ class = "WARLOCK", level = 52, },
	["Curse of Tongues"] = 			{ class = "WARLOCK", level = 26, },
	["Curse of Weakness"] = 		{ class = "WARLOCK", level = 16, },
	["Dark Intent"] = 			{ class = "WARLOCK", level = 83, },
	["Demon Armor"] = 			{ class = "WARLOCK", level = 8, },
	["Demon Leap"] = 			{ class = "WARLOCK", level = 60, },
	["Demon Soul"] = 			{ class = "WARLOCK", level = 85, },
	["Demonic Circle: Summon"] = 		{ class = "WARLOCK", level = 78, },
	["Demonic Circle: Teleport"] = 		{ class = "WARLOCK", level = 78, },
	["Drain Life"] = 			{ class = "WARLOCK", level = 6, },
	["Drain Mana"] = 			{ class = "WARLOCK", level = 24, },
	["Drain Soul"] = 			{ class = "WARLOCK", level = 10, },
	["Enslave Demon"] = 			{ class = "WARLOCK", level = 30, },
	["Eye of Kilrogg"] = 			{ class = "WARLOCK", level = 22, },
	["Fear"] = 				{ class = "WARLOCK", level = 14, },
	["Fel Armor"] = 			{ class = "WARLOCK", level = 62, },
	["Fel Flame"] = 			{ class = "WARLOCK", level = 81, },
	["Health Funnel"] = 			{ class = "WARLOCK", level = 12, },
	["Hellfire"] = 				{ class = "WARLOCK", level = 30, },
	["Howl of Terror"] = 			{ class = "WARLOCK", level = 44, },
	["Immolate"] = 				{ class = "WARLOCK", level = 3, },
	["Immolation Aura"] = 			{ class = "WARLOCK", level = 60, },
	["Incinerate"] = 			{ class = "WARLOCK", level = 64, },
	["Life Tap"] = 				{ class = "WARLOCK", level = 5, },
	["Nethermancy"] = 			{ class = "WARLOCK", level = 50, },
	["Rain of Fire"] = 			{ class = "WARLOCK", level = 18, },
	["Ritual of Souls"] = 			{ class = "WARLOCK", level = 68, },
	["Ritual of Summoning"] = 		{ class = "WARLOCK", level = 42, },
	["Searing Pain"] = 			{ class = "WARLOCK", level = 18, },
	["Seed of Corruption"] = 		{ class = "WARLOCK", level = 72, },
	["Shadow Bolt"] = 			{ class = "WARLOCK", level = 1, },
	["Shadow Ward"] = 			{ class = "WARLOCK", level = 34, },
	["Shadowflame"] = 			{ class = "WARLOCK", level = 76, },
	["Soul Fire"] = 			{ class = "WARLOCK", level = 54, },
	["Soul Harvest"] = 			{ class = "WARLOCK", level = 12, },
	["Soul Link"] = 			{ class = "WARLOCK", level = 20, },
	["Soulburn"] = 				{ class = "WARLOCK", level = 10, },
	["Soulshatter"] = 			{ class = "WARLOCK", level = 66, },
	["Summon Doomguard"] = 			{ class = "WARLOCK", level = 58, },
	["Summon Felhunter"] = 			{ class = "WARLOCK", level = 30, },
	["Summon Imp"] = 			{ class = "WARLOCK", level = 1, },
	["Summon Infernal"] = 			{ class = "WARLOCK", level = 50, },
	["Summon Succubus"] = 			{ class = "WARLOCK", level = 20, },
	["Summon Voidwalker"] = 		{ class = "WARLOCK", level = 8, },
	["Unending Breath"] = 			{ class = "WARLOCK", level = 16, },
--== Warlock Talents ==
	["Aftermath"] = 			{ class = "WARLOCK", level = 20, },
	["Ancient Grimoire"] = 			{ class = "WARLOCK", level = 30, },
	["Aura of Foreboding"] = 		{ class = "WARLOCK", level = 25, },
	["Backdraft"] = 			{ class = "WARLOCK", level = 20, },
	["Backlash"] = 				{ class = "WARLOCK", level = 25, },
	["Bane"] = 				{ class = "WARLOCK", level = 10, },
	["Bane of Havoc"] = 			{ class = "WARLOCK", level = 35, },
	["Burning Embers"] = 			{ class = "WARLOCK", level = 25, },
	["Chaos Bolt"] = 			{ class = "WARLOCK", level = 40, },
	["Cremation"] = 			{ class = "WARLOCK", level = 35, },
	["Curse of Exhaustion"] = 		{ class = "WARLOCK", level = 20, },
	["Dark Arts"] = 			{ class = "WARLOCK", level = 10, },
	["Death's Embrace"] = 			{ class = "WARLOCK", level = 30, },
	["Decimation"] = 			{ class = "WARLOCK", level = 30, },
	["Demonic Aegis"] = 			{ class = "WARLOCK", level = 15, },
	["Demonic Embrace"] = 			{ class = "WARLOCK", level = 10, },
	["Demonic Empowerment"] = 		{ class = "WARLOCK", level = 20, },
	["Demonic Pact"] = 			{ class = "WARLOCK", level = 35, },
	["Demonic Rebirth"] = 			{ class = "WARLOCK", level = 15, },
	["Doom and Gloom"] = 			{ class = "WARLOCK", level = 10, },
	["Emberstorm"] = 			{ class = "WARLOCK", level = 15, },
	["Empowered Imp"] = 			{ class = "WARLOCK", level = 35, },
	["Eradication"] = 			{ class = "WARLOCK", level = 20, },
	["Everlasting Affliction"] = 		{ class = "WARLOCK", level = 35, },
	["Fel Synergy"] = 			{ class = "WARLOCK", level = 10, },
	["Fire and Brimstone"] = 		{ class = "WARLOCK", level = 30, },
	["Hand of Gul'dan"] = 			{ class = "WARLOCK", level = 25, },
	["Haunt"] = 				{ class = "WARLOCK", level = 40, },
	["Impending Doom"] = 			{ class = "WARLOCK", level = 20, },
	["Improved Corruption"] = 		{ class = "WARLOCK", level = 10, },
	["Improved Fear"] = 			{ class = "WARLOCK", level = 20, },
	["Improved Health Funnel"] = 		{ class = "WARLOCK", level = 20, },
	["Improved Howl of Terror"] = 		{ class = "WARLOCK", level = 25, },
	["Improved Immolate"] = 		{ class = "WARLOCK", level = 10, },
	["Improved Life Tap"] = 		{ class = "WARLOCK", level = 10, },
	["Improved Searing Pain"] = 		{ class = "WARLOCK", level = 15, },
	["Improved Soul Fire"] = 		{ class = "WARLOCK", level = 15, },
	["Inferno"] = 				{ class = "WARLOCK", level = 30, },
	["Jinx"] = 				{ class = "WARLOCK", level = 15, },
	["Mana Feed"] = 			{ class = "WARLOCK", level = 15, },
	["Master Summoner"] = 			{ class = "WARLOCK", level = 15, },
	["Metamorphosis"] = 			{ class = "WARLOCK", level = 40, },
	["Molten Core"] = 			{ class = "WARLOCK", level = 25, },
	["Nether Protection"] = 		{ class = "WARLOCK", level = 30, },
	["Nether Ward"] = 			{ class = "WARLOCK", level = 34, },
	["Nightfall"] = 			{ class = "WARLOCK", level = 30, },
	["Pandemic"] = 				{ class = "WARLOCK", level = 35, },
	["Shadow Embrace"] = 			{ class = "WARLOCK", level = 25, },
	["Shadow and Flame"] = 			{ class = "WARLOCK", level = 10, },
	["Shadowburn"] = 			{ class = "WARLOCK", level = 20, },
	["Shadowfury"] = 			{ class = "WARLOCK", level = 30, },
	["Siphon Life"] = 			{ class = "WARLOCK", level = 15, },
	["Soul Leech"] = 			{ class = "WARLOCK", level = 25, },
	["Soul Siphon"] = 			{ class = "WARLOCK", level = 15, },
	["Soul Swap"] = 			{ class = "WARLOCK", level = 25, },
	["Soulburn: Seed of Corruption"] = 	{ class = "WARLOCK", level = 30, },
--== Warlock Specialization ==
	["Cataclysm"] = 			{ class = "WARLOCK", level = 10, },
	["Conflagrate"] = 			{ class = "WARLOCK", level = 10, },
	["Demonic Knowledge"] = 		{ class = "WARLOCK", level = 10, },
	["Fiery Apocalypse"] = 			{ class = "WARLOCK", level = 10, },
	["Master Demonologist"] = 		{ class = "WARLOCK", level = 10, },
	["Potent Afflictions"] = 		{ class = "WARLOCK", level = 10, },
	["Shadow Mastery"] = 			{ class = "WARLOCK", level = 10, },
	["Summon Felguard"] = 			{ class = "WARLOCK", level = 10, },
	["Unstable Affliction"] = 		{ class = "WARLOCK", level = 10, },

--== Warrior Abilities ==
	["Battle Shout"] = 			{ class = "WARRIOR", level = 20, },
	["Battle Stance"] = 			{ class = "WARRIOR", level = 1, },
	["Berserker Rage"] = 			{ class = "WARRIOR", level = 54, },
	["Berserker Stance"] = 			{ class = "WARRIOR", level = 30, },
	["Challenging Shout"] = 		{ class = "WARRIOR", level = 46, },
	["Charge"] = 				{ class = "WARRIOR", level = 3, },
	["Cleave"] = 				{ class = "WARRIOR", level = 24, },
	["Colossus Smash"] = 			{ class = "WARRIOR", level = 81, },
	["Commanding Shout"] = 			{ class = "WARRIOR", level = 68, },
	["Defensive Stance"] = 			{ class = "WARRIOR", level = 10, },
	["Demoralizing Shout"] = 		{ class = "WARRIOR", level = 52, },
	["Disarm"] = 				{ class = "WARRIOR", level = 34, },
	["Enraged Regeneration"] = 		{ class = "WARRIOR", level = 76, },
	["Execute"] = 				{ class = "WARRIOR", level = 16, },
	["Hamstring"] = 			{ class = "WARRIOR", level = 26, },
	["Heroic Leap"] = 			{ class = "WARRIOR", level = 85, },
	["Heroic Strike"] = 			{ class = "WARRIOR", level = 14, },
	["Heroic Throw"] = 			{ class = "WARRIOR", level = 78, },
	["Inner Rage"] = 			{ class = "WARRIOR", level = 83, },
	["Intercept"] = 			{ class = "WARRIOR", level = 50, },
	["Intervene"] = 			{ class = "WARRIOR", level = 72, },
	["Intimidating Shout"] = 		{ class = "WARRIOR", level = 42, },
	["Overpower"] = 			{ class = "WARRIOR", level = 22, },
	["Parry"] = 				{ class = "WARRIOR", level = 10, },
	["Pummel"] = 				{ class = "WARRIOR", level = 38, },
	["Recklessness"] = 			{ class = "WARRIOR", level = 64, },
	["Rend"] = 				{ class = "WARRIOR", level = 7, },
	["Retaliation"] = 			{ class = "WARRIOR", level = 62, },
	["Revenge"] = 				{ class = "WARRIOR", level = 40, },
	["Shattering Throw"] = 			{ class = "WARRIOR", level = 74, },
	["Shield Bash"] = 			{ class = "WARRIOR", level = 20, },
	["Shield Block"] = 			{ class = "WARRIOR", level = 28, },
	["Shield Wall"] = 			{ class = "WARRIOR", level = 48, },
	["Slam"] = 				{ class = "WARRIOR", level = 44, },
	["Spell Reflection"] = 			{ class = "WARRIOR", level = 66, },
	["Stance Mastery"] = 			{ class = "WARRIOR", level = 58, },
	["Strike"] = 				{ class = "WARRIOR", level = 1, },
	["Sunder Armor"] = 			{ class = "WARRIOR", level = 18, },
	["Taunt"] = 				{ class = "WARRIOR", level = 12, },
	["Thunder Clap"] = 			{ class = "WARRIOR", level = 9, },
	["Victory Rush"] = 			{ class = "WARRIOR", level = 5, },
	["Whirlwind"] = 			{ class = "WARRIOR", level = 36, },
--== Warrior Talents ==
	["Bastion of Defense"] = 		{ class = "WARRIOR", level = 20, },
	["Battle Trance"] = 			{ class = "WARRIOR", level = 10, },
	["Bladestorm"] = 			{ class = "WARRIOR", level = 40, },
	["Blitz"] = 				{ class = "WARRIOR", level = 10, },
	["Blood Craze"] = 			{ class = "WARRIOR", level = 10, },
	["Blood Frenzy"] = 			{ class = "WARRIOR", level = 25, },
	["Blood and Thunder"] = 		{ class = "WARRIOR", level = 10, },
	["Bloodsurge"] = 			{ class = "WARRIOR", level = 35, },
	["Booming Voice"] = 			{ class = "WARRIOR", level = 15, },
	["Concussion Blow"] = 			{ class = "WARRIOR", level = 20, },
	["Cruelty"] = 				{ class = "WARRIOR", level = 10, },
	["Deadly Calm"] = 			{ class = "WARRIOR", level = 25, },
	["Death Wish"] = 			{ class = "WARRIOR", level = 20, },
	["Deep Wounds"] = 			{ class = "WARRIOR", level = 15, },
	["Devastate"] = 			{ class = "WARRIOR", level = 25, },
	["Die by the Sword"] = 			{ class = "WARRIOR", level = 25, },
	["Drums of War"] = 			{ class = "WARRIOR", level = 15, },
	["Field Dressing"] = 			{ class = "WARRIOR", level = 10, },
	["Furious Attacks"] = 			{ class = "WARRIOR", level = 30, },
	["Gag Order"] = 			{ class = "WARRIOR", level = 15, },
	["Heavy Repercussions"] = 		{ class = "WARRIOR", level = 30, },
	["Heroic Fury"] = 			{ class = "WARRIOR", level = 25, },
	["Hold the Line"] = 			{ class = "WARRIOR", level = 15, },
	["Impale"] = 				{ class = "WARRIOR", level = 20, },
	["Impending Victory"] = 		{ class = "WARRIOR", level = 25, },
	["Improved Hamstring"] = 		{ class = "WARRIOR", level = 20, },
	["Improved Revenge"] = 			{ class = "WARRIOR", level = 25, },
	["Improved Slam"] = 			{ class = "WARRIOR", level = 25, },
	["Incite"] = 				{ class = "WARRIOR", level = 10, },
	["Intensify Rage"] = 			{ class = "WARRIOR", level = 30, },
	["Juggernaut"] = 			{ class = "WARRIOR", level = 30, },
	["Lambs to the Slaughter"] = 		{ class = "WARRIOR", level = 30, },
	["Last Stand"] = 			{ class = "WARRIOR", level = 20, },
	["Meat Cleaver"] = 			{ class = "WARRIOR", level = 30, },
	["Piercing Howl"] = 			{ class = "WARRIOR", level = 15, },
	["Raging Blow"] = 			{ class = "WARRIOR", level = 25, },
	["Rampage"] = 				{ class = "WARRIOR", level = 25, },
	["Rude Interruption"] = 		{ class = "WARRIOR", level = 15, },
	["Safeguard"] = 			{ class = "WARRIOR", level = 35, },
	["Second Wind"] = 			{ class = "WARRIOR", level = 15, },
	["Shield Mastery"] = 			{ class = "WARRIOR", level = 15, },
	["Shield Specialization"] = 		{ class = "WARRIOR", level = 15, },
	["Shockwave"] = 			{ class = "WARRIOR", level = 40, },
	["Single-Minded Fury"] = 		{ class = "WARRIOR", level = 40, },
	["Skirmisher"] = 			{ class = "WARRIOR", level = 35, },
	["Sudden Death"] = 			{ class = "WARRIOR", level = 30, },
	["Sweeping Strikes"] = 			{ class = "WARRIOR", level = 20, },
	["Sword and Board"] = 			{ class = "WARRIOR", level = 35, },
	["Tactical Mastery"] = 			{ class = "WARRIOR", level = 15, },
	["Taste for Blood"] = 			{ class = "WARRIOR", level = 20, },
	["Throwdown"] = 			{ class = "WARRIOR", level = 35, },
	["Thunderstruck"] = 			{ class = "WARRIOR", level = 30, },
	["Titan's Grip"] = 			{ class = "WARRIOR", level = 40, },
	["Vigilance"] = 			{ class = "WARRIOR", level = 30, },
	["War Academy"] = 			{ class = "WARRIOR", level = 10, },
	["Warbringer"] = 			{ class = "WARRIOR", level = 20, },
	["Wrecking Crew"] = 			{ class = "WARRIOR", level = 35, },
--== Warrior Specialization ==
	["Anger Management"] = 			{ class = "WARRIOR", level = 10, },
	["Bloodthirst"] = 			{ class = "WARRIOR", level = 10, },
	["Critical Block"] = 			{ class = "WARRIOR", level = 10, },
	["Mortal Strike"] = 			{ class = "WARRIOR", level = 10, },
	["Sentinel"] = 				{ class = "WARRIOR", level = 10, },
	["Shield Slam"] = 			{ class = "WARRIOR", level = 10, },
	["Strikes of Opportunity"] = 		{ class = "WARRIOR", level = 10, },
	["Unshackled Fury"] = 			{ class = "WARRIOR", level = 10, },

};
