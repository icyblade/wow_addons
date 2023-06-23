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

The drop down menu can also be used to set the reasons why you have added someone to the Kill On Sight list. If you want to enter a specific reason that is not in the list, then use the "Enter your own reason..." in the Other list.


|cffffd000Author: http://www.curse.com/users/slipjack|cffffffff

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
L["LockSpy"] = "Lock the Spy window"
L["LockSpyDescription"] = "Locks the Spy window in place so it doesn't move."
L["InvertSpy"] = "Invert the Spy window"
L["InvertSpyDescription"] = "Flips the Spy window upside down."
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
L["Enable"] = "Enable"
L["EnableDescription"] = "Enables Spy and shows the main window."
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

--++ Class descriptions
L["DEATHKNIGHT"] = "Death Knight"
L["DRUID"] = "Druid"
L["HUNTER"] = "Hunter"
L["MAGE"] = "Mage"
L["MONK"] = "Monk"
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

--++ Minimap color codes
L["MinimapClassTextDEATHKNIGHT"] = "|cffc41e3a"
L["MinimapClassTextDRUID"] = "|cffff7c0a"
L["MinimapClassTextHUNTER"] = "|cffaad372"
L["MinimapClassTextMAGE"] = "|cff68ccef"
L["MinimapClassTextMONK"] = "|cff00ff96"
L["MinimapClassTextPALADIN"] = "|cfff48cba"
L["MinimapClassTextPRIEST"] = "|cffffffff"
L["MinimapClassTextROGUE"] = "|cfffff468"
L["MinimapClassTextSHAMAN"] = "|cff2359ff"
L["MinimapClassTextWARLOCK"] = "|cff9382c9"
L["MinimapClassTextWARRIOR"] = "|cffc69b6d"
L["MinimapClassTextUNKNOWN"] = "|cff191919"
L["MinimapGuildText"] = "|cffffffff"

-- Output messages
L["AlertStealthTitle"] = "Stealth player detected!"
L["AlertKOSTitle"] = "Kill On Sight player detected!"
L["AlertKOSGuildTitle"] = "Kill On Sight player guild detected!"
L["AlertTitle_kosaway"] = "Kill On Sight player located by "
L["AlertTitle_kosguildaway"] = "Kill On Sight player guild located by "
L["StealthWarning"] = "|cff9933ffStealth player detected: |cffffffff"
L["KOSWarning"] = "|cffff0000Kill On Sight player detected: |cffffffff"
L["KOSGuildWarning"] = "|cffff0000Kill On Sight player guild detected: |cffffffff"
L["SpySignatureColored"] = "|cff9933ff[Spy] "
L["PlayerDetectedColored"] = "Player detected: |cffffffff"
L["PlayersDetectedColored"] = "Players detected: |cffffffff"
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
L["Close"] = "Close"
L["CloseDescription"] = "|cffffffffHides the Spy window. By default will show again when the next enemy player is detected."
L["Left/Right"] = "Left/Right"
L["Left/RightDescription"] = "|cffffffffNavigates between the Nearby, Last Hour, Ignore and Kill On Sight lists."
L["Clear"] = "Clear"
L["ClearDescription"] = "|cffffffffClears the list of players that have been detected. CTRL click will Enable/Disable Spy while displayed."
L["NearbyCount"] = "Nearby Count"
L["NearbyCountDescription"] = "|cffffffffSends the count of nearby players to chat."
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
L["KOSReasonOther"] = "Enter your own reason..."
L["KOSReasonClear"] = "Clear"
L["StatsWins"] = "|cff40ff00Wins: "
L["StatsSeparator"] = "  "
L["StatsLoses"] = "|cff0070ddLoses: "
L["Located"] = "located:"
L["Yards"] = "yards"

--Spy_KOSReasonListLength = 13
Spy_KOSReasonListLength = 6
Spy_KOSReasonList = {
	[1] = {
		["title"] = "Started combat";
		["content"] = {
--			"Ambushed me",
--			"Always attacks me on sight",
			"Attacked me for no reason",
			"Attacked me at a quest giver", 
			"Attacked me while I was fighting NPCs",
			"Attacked me while I was entering/leaving an instance",
			"Attacked me while I was AFK",
--			"Attacked me while I was in a pet battle", --++
			"Attacked me while I was mounted/flying",
			"Attacked me while I had low health/mana",
--			"Steamrolled me with a group of enemies",
--			"Doesn't attack without backup",
--			"Dared to challenge me",
		};
	},
	[2] = {
		["title"] = "Style of combat";
		["content"] = {
			"Ambushed me",
			"Always attacks me on sight",
			"Killed me with a higher level character",
			"Steamrolled me with a group of enemies",
			"Doesn't attack without backup",
			"Always calls for help",
--			"Pushed me off a cliff",
--			"Uses engineering tricks",
			"Uses too much crowd control",
--			"Spams one ability all the time",
--			"Forced me to take durability damage",
--			"Killed me and escaped from my friends",
--			"Ran away then ambushed me",
--			"Always manages to escape",
--			"Bubble hearths to escape",
--			"Manages to stay in melee range",
--			"Manages to stay at kiting range",
--			"Absorbs too much damage",
--			"Heals too much",
--			"DPS's too much",
		};
	},
--	[3] = {
--		["title"] = "General behaviour";
-- 		["content"] = {
--			"Annoying",
--			"Rudeness",
--			"Cowardice",
--			"Arrogance",
--			"Overconfidence",
--			"Untrustworthy",
--			"Emotes too much",
--			"Stalked me/friends",
--			"Pretends to be good",
--			"Emotes 'not going to happen'",
--			"Waves goodbye at low health",
--			"Tried to placate me with a wave",
--			"Performed foul acts on my corpse",
--			"Laughed at me",
--			"Spat on me",
--		};
--	},
	[3] = {
		["title"] = "Camping";
		["content"] = {
			"Camped me",
			"Camped an alt",
			"Camped lowbies",
			"Camped from stealth",
			"Camped guild members",
			"Camped game NPCs/objectives",
			"Camped a city/site",
--			"Called in help to camp me",
--			"Made leveling a nightmare",
--			"Forced me to logout",
--			"Won't fight my main",
		};
	},
	[4] = {
		["title"] = "Questing";
		["content"] = {
			"Attacked me while I was questing",
			"Attacked me after I helped with a quest",
			"Interfered with a quest objective",
			"Started a quest I wanted to do",
			"Killed my faction's NPCs",
			"Killed a quest NPC",
		};
	},
	[5] = {
		["title"] = "Stole resources";
		["content"] = {
			"Gathered herbs I wanted",
			"Gathered minerals I wanted",
			"Gathered resources I wanted",
--			"Extracted gas from a cloud I wanted",
			"Killed me and stole my target/rare NPC",
			"Skinned my kills",
			"Salvaged my kills",
			"Fished in my pool",
		};
	},
--[[	[7] = {
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
			"Pandarens keep telling me to slow down", --++
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
			"Monks chi is weak", --++
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
	},]]--
--	[13] = {
	[6] = {
		["title"] = "Other";
		["content"] = {
--			"Karma",
--			"Red is dead",
--			"Just because",
--			"Fails at PvP",
			"Flagged for PvP",
--			"Doesn't want to PvP",
--			"Wastes both our time",
--			"This player is a noob",
--			"I really hate this player",
--			"Doesn't level fast enough",
			"Pushed me off a cliff",
			"Uses engineering tricks",
			"Always manages to escape",
			"Uses items and skills to escape",
			"Exploits game mechanics",
--			"Suspected hacker",
--			"Farmer",
--			"Other...",
			"Enter your own reason...",
		};
	},
}

StaticPopupDialogs["Spy_SetKOSReasonOther"] = {
	preferredIndex=STATICPOPUPS_NUMDIALOGS,  -- http://forums.wowace.com/showthread.php?p=320956
	text = "Enter the Kill On Sight reason for %s:",
	button1 = "Set",
	button2 = "Cancel",
	timeout = 20,
	hasEditBox = 1,
	whileDead = 1,
	hideOnEscape = 1,
	OnShow = function(self)
		self.editBox:SetText("");
	end,
    	OnAccept = function(self)
		local reason = self.editBox:GetText()
--		Spy:SetKOSReason(self.playerName, "Other...", reason)
		Spy:SetKOSReason(self.playerName, "Enter your own reason...", reason)
	end,
};

Spy_AbilityList = {

-----------------------------------------------------------
-- Allows an estimation of the race, class and level of a
-- player to be determined from what abilities are observed
-- in the combat log.
-----------------------------------------------------------

--++ Racials ++
	["Stoneform"] = 			{ race = "Dwarf", level = 1, },
	["Escape Artist"] = 		{ race = "Gnome", level = 1, },
	["Every Man for Himself"] = { race = "Human", level = 1, },
	["Shadowmeld"] = 			{ race = "Night Elf", level = 1, },
	["Gift of the Naaru"] = 	{ race = "Draenei", level = 1, },
	["Darkflight"] = 			{ race = "Worgen", level = 1, },
	["Two Forms"] = 			{ race = "Worgen", level = 1, },
	["Running Wild"] = 			{ race = "Worgen", level = 1, },
	["Blood Fury"] = 			{ race = "Orc", level = 1, },
	["War Stomp"] = 			{ race = "Tauren", level = 1, },
	["Berserking"] = 			{ race = "Troll", level = 1, },
	["Will of the Forsaken"] = 	{ race = "Undead", level = 1, },
	["Cannibalize"] = 			{ race = "Undead", level = 1, },
	["Arcane Torrent"] = 		{ race = "Blood Elf", level = 1, },
	["Rocket Jump"] = 			{ race = "Goblin", level = 1, },
	["Rocket Barrage"] = 		{ race = "Goblin", level = 1, },
	["Pack Hobgoblin"] = 		{ race = "Goblin", level = 1, },
	["Quaking Palm"] =			{ race = "Pandaren", level = 1, },

--++ Death Knight Abilities ++
	["Blood Plague"] = 			{ class = "DEATHKNIGHT", level = 55, }, --++
	["Blood Strike"] = 			{ class = "DEATHKNIGHT", level = 55, }, --++
	["Death Coil"] = 			{ class = "DEATHKNIGHT", level = 55, },  
	["Death Gate"] = 			{ class = "DEATHKNIGHT", level = 55, }, 
	["Death Grip"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Frost Fever"] = 			{ class = "DEATHKNIGHT", level = 55, },	--++
	["Frost Presence"] = 		{ class = "DEATHKNIGHT", level = 55, },  
	["Icy Touch"] = 			{ class = "DEATHKNIGHT", level = 55, },  
	["Plague Strike"] = 		{ class = "DEATHKNIGHT", level = 55, },  
	["Runeforging"] = 			{ class = "DEATHKNIGHT", level = 55, },  
--	["Plate Specialization"] = 	{ class = "DEATHKNIGHT", level = 55, }, 
 	["Blood Boil"] = 			{ class = "DEATHKNIGHT", level = 56, }, --++
	["Death Strike"] = 			{ class = "DEATHKNIGHT", level = 56, },  
	["Pestilence"] = 			{ class = "DEATHKNIGHT", level = 56, },  
	["Raise Dead"] = 			{ class = "DEATHKNIGHT", level = 56, }, 
 	["Blood Presence"] = 		{ class = "DEATHKNIGHT", level = 57, }, --++	
	["Mind Freeze"] = 			{ class = "DEATHKNIGHT", level = 57, },  
	["Chains of Ice"] = 		{ class = "DEATHKNIGHT", level = 58, },  
	["Strangulate"] = 			{ class = "DEATHKNIGHT", level = 58, },  
	["Death and Decay"] = 		{ class = "DEATHKNIGHT", level = 60, },  
	["On a Pale Horse"] = 		{ class = "DEATHKNIGHT", level = 61, },  
	["Icebound Fortitude"] = 	{ class = "DEATHKNIGHT", level = 62, },
	["Unholy Presence"] = 		{ class = "DEATHKNIGHT", level = 64, }, --++ Changed	
	["Horn of Winter"] = 		{ class = "DEATHKNIGHT", level = 65, },  
	["Path of Frost"] = 		{ class = "DEATHKNIGHT", level = 66, }, 
	["Anti-Magic Shell"] = 		{ class = "DEATHKNIGHT", level = 69, }, --++	
	["Control Undead"] = 		{ class = "DEATHKNIGHT", level = 69, },  
 	["Raise Ally"] = 			{ class = "DEATHKNIGHT", level = 72, },  
	["Empower Rune Weapon"] = 	{ class = "DEATHKNIGHT", level = 76, }, 
	["Army of the Dead"] = 		{ class = "DEATHKNIGHT", level = 80, }, 
	["Outbreak"] = 				{ class = "DEATHKNIGHT", level = 81, },  
	["Necrotic Strike"] = 		{ class = "DEATHKNIGHT", level = 83, },  
	["Dark Simulacrum"] = 		{ class = "DEATHKNIGHT", level = 85, },  
	["Rune of Cinderglacier"] = { class = "DEATHKNIGHT", level = 55, },
	["Rune of Fallen Crusader"] = { class = "DEATHKNIGHT", level = 70, },	
	["Rune of Lichbane"] = 		{ class = "DEATHKNIGHT", level = 60, },
	["Rune of Razorice"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Rune of Spellbreaking"] = { class = "DEATHKNIGHT", level = 57, },
	["Rune of Spellshattering"] = { class = "DEATHKNIGHT", level = 57, },
	["Rune of Swordbreaking"] = { class = "DEATHKNIGHT", level = 63, },
	["Rune of Swordshattering"] = { class = "DEATHKNIGHT", level = 63, },
	["Rune of the Nerubian Carapace"] = { class = "DEATHKNIGHT", level = 72, },
	["Rune of the Stoneskin Gargoyle"] = { class = "DEATHKNIGHT", level = 72, },
    --++ Glyph Abilities ++
	["Corpse Explosion"] = 		{ class = "DEATHKNIGHT", level = 25, },	
--++ Death Knight Specialization ++
	--++ Blood/Frost/Unholy ++
	["Soul Reaper"] = 			{ class = "DEATHKNIGHT", level = 87, }, 
	--++ Frost/Unholy ++
	["Unholy Aura"] = 			{ class = "DEATHKNIGHT", level = 60, },
	--++ Blood ++
	["Blood Rites"]  = 			{ class = "DEATHKNIGHT", level = 55, },	  
	["Vengeance"]  = 			{ class = "DEATHKNIGHT", level = 55, },	  
	["Veteran of the Third War"] = { class = "DEATHKNIGHT", level = 55, },	  
	["Dark Command"]  = 		{ class = "DEATHKNIGHT", level = 58, },	  
	["Heart Strike"]  = 		{ class = "DEATHKNIGHT", level = 60, },	  
	["Scent of Blood"] = 		{ class = "DEATHKNIGHT", level = 62, },	  
	["Improved Blood Presence"] = { class = "DEATHKNIGHT", level = 64, },	  
	["Rune Tap"] = 				{ class = "DEATHKNIGHT", level = 64, },	  
	["Rune Strike"] = 			{ class = "DEATHKNIGHT", level = 65, },	  
	["Blood Parasite"] = 		{ class = "DEATHKNIGHT", level = 66, },	  
	["Scarlet Fever"] = 		{ class = "DEATHKNIGHT", level = 68, },	  
	["Will of the Necropolis"] = { class = "DEATHKNIGHT", level = 70, },	  
	["Sanguine Fortitude"] = 	{ class = "DEATHKNIGHT", level = 72, },	  
	["Dancing Rune Weapon"] = 	{ class = "DEATHKNIGHT", level = 74, },	
--	["Ripsote"] = 				{ class = "DEATHKNIGHT", level = 76, }, --Added in Patch 5.4 but not activated since Warriors also have this ability	
	["Vampiric Blood"] = 		{ class = "DEATHKNIGHT", level = 76, },	  
	["Bone Shield"] = 			{ class = "DEATHKNIGHT", level = 78, },
	["Blood Shield"] = 			{ class = "DEATHKNIGHT", level = 80, },
	["Crimson Scourge"] = 		{ class = "DEATHKNIGHT", level = 84, },	--++
	--++ Frost ++ 
	["Blood of the North"] = 	{ class = "DEATHKNIGHT", level = 55, },	  
	["Frost Strike"] = 			{ class = "DEATHKNIGHT", level = 55, },	  
	["Howling Blast"] = 		{ class = "DEATHKNIGHT", level = 55, },	  
	["Icy Talons"] = 			{ class = "DEATHKNIGHT", level = 55, },	  
	["Obliterate"] = 			{ class = "DEATHKNIGHT", level = 58, },	  
	["Killing Machine"] = 		{ class = "DEATHKNIGHT", level = 63, },	  
	["Improved Frost Presence"] = { class = "DEATHKNIGHT", level = 65, },	  
	["Brittle Bones"] = 		{ class = "DEATHKNIGHT", level = 66, },	  
	["Pillar of Frost"] = 		{ class = "DEATHKNIGHT", level = 68, },	  
	["Rime"] = 					{ class = "DEATHKNIGHT", level = 70, },	  
	["Might of the Frozen Wastes"] = { class = "DEATHKNIGHT", level = 74, },	  
	["Threat of Thassarian"] = 	{ class = "DEATHKNIGHT", level = 74, },	  
	["Frozen Heart"] = 			{ class = "DEATHKNIGHT", level = 80, },	
	--++ Unholy ++  
	["Master of Ghouls"] = 		{ class = "DEATHKNIGHT", level = 55, },	  
	["Reaping"] = 				{ class = "DEATHKNIGHT", level = 55, },	  
	["Unholy Might"] = 			{ class = "DEATHKNIGHT", level = 55, },	  
	["Scourge Strike"] = 		{ class = "DEATHKNIGHT", level = 58, },	  
	["Shadow Infusion"] = 		{ class = "DEATHKNIGHT", level = 60, },	  
	["Festering Strike"] = 		{ class = "DEATHKNIGHT", level = 62, },	  
	["Sudden Doom"] = 			{ class = "DEATHKNIGHT", level = 64, },	  
	["Unholy Frenzy"] = 		{ class = "DEATHKNIGHT", level = 66, },	  
	["Ebon Plaguebringer"] = 	{ class = "DEATHKNIGHT", level = 68, },	  
	["Dark Transformation"] = 	{ class = "DEATHKNIGHT", level = 70, },	  
	["Summon Gargoyle"] = 		{ class = "DEATHKNIGHT", level = 74, },	  
	["Improved Unholy Presence"] = { class = "DEATHKNIGHT", level = 75, },	  
	["Dreadblade"] = 			{ class = "DEATHKNIGHT", level = 80, },	 
--++ Death Knight Talents ++
	["Roiling Blood"] = 		{ class = "DEATHKNIGHT", level = 56, },	
	["Plague Leech"] = 			{ class = "DEATHKNIGHT", level = 56, },	
	["Unholy Blight"] = 		{ class = "DEATHKNIGHT", level = 56, },	  
	["Lichborne"] = 			{ class = "DEATHKNIGHT", level = 57, },	
	["Anti-Magic Zone"] = 		{ class = "DEATHKNIGHT", level = 57, },	
	["Purgatory"] = 			{ class = "DEATHKNIGHT", level = 57, },	 
	["Death's Advance"] = 		{ class = "DEATHKNIGHT", level = 58, },	
	["Chilblains"] = 			{ class = "DEATHKNIGHT", level = 58, },	
	["Asphyxiate"] = 			{ class = "DEATHKNIGHT", level = 58, },	  
	["Death Pact"] = 			{ class = "DEATHKNIGHT", level = 60, },	
	["Death Siphon"] =	 		{ class = "DEATHKNIGHT", level = 60, },	
	["Conversion"] = 			{ class = "DEATHKNIGHT", level = 60, },	 
	["Blood Tap"] = 			{ class = "DEATHKNIGHT", level = 75, },	
	["Runic Empowerment"] = 	{ class = "DEATHKNIGHT", level = 75, },	
	["Runic Corruption"] = 		{ class = "DEATHKNIGHT", level = 75, },	 
	["Gorefiend's Grasp"] = 	{ class = "DEATHKNIGHT", level = 90, },	
	["Remorseless Winter"] = 	{ class = "DEATHKNIGHT", level = 90, },	
	["Desecrated Ground"] = 	{ class = "DEATHKNIGHT", level = 90, },	 

--++ Druid Abilities ++
	["Wrath"] = 				{ class = "DRUID", level = 1, },  
	["Moonfire"] = 				{ class = "DRUID", level = 3, },
	["Rejuvenation"] = 			{ class = "DRUID", level = 4, },
	["Cat Form"] = 				{ class = "DRUID", level = 6, },
	["Feline Grace"] = 			{ class = "DRUID", level = 6, },
	["Mangle"] = 				{ class = "DRUID", level = 6, },
	["Prowl"] = 				{ class = "DRUID", level = 6, },
	["Rake"] = 					{ class = "DRUID", level = 6, },
	["Ferocious Bite"] = 		{ class = "DRUID", level = 6, },
	["Bear Form"] = 			{ class = "DRUID", level = 8, },
	["Growl"] = 				{ class = "DRUID", level = 8, },
	["Maul"] = 					{ class = "DRUID", level = 8, },
	["Clearcasting"] =	 		{ class = "DRUID", level = 10, }, --++
	["Entangling Roots"] = 		{ class = "DRUID", level = 10, },
	["Revive"] = 				{ class = "DRUID", level = 12, },
	["Teleport: Moonglade"] = 	{ class = "DRUID", level = 14, },
	["Travel Form"] = 			{ class = "DRUID", level = 16, },
	["Aquatic Form"] = 			{ class = "DRUID", level = 18, },
	["Ravage!"] = 				{ class = "DRUID", level = 22, }, --++
	["Swipe"] = 				{ class = "DRUID", level = 22, },	
	["Dash"] = 					{ class = "DRUID", level = 24, },
	["Healing Touch"] = 		{ class = "DRUID", level = 26, },
	["Faerie Fire"] = 			{ class = "DRUID", level = 28, },
	["Thrash"] = 		 		{ class = "DRUID", level = 28, }, --++
	["Primal Fury"] = 			{ class = "DRUID", level = 30, },
	["Pounce"] = 				{ class = "DRUID", level = 32, },
	["Track Humanoids"] = 		{ class = "DRUID", level = 36, },
	["Lacerate"] = 				{ class = "DRUID", level = 38, },
	["Astral Storm"] = 			{ class = "DRUID", level = 42, }, --++
	["Hurricane"] = 			{ class = "DRUID", level = 42, },
	["Barkskin"] = 				{ class = "DRUID", level = 44, },
--	["Leather Specialization"] = { class = "DRUID", level = 50, },
	["Nature's Grasp"] = 		{ class = "DRUID", level = 52, },
	["Innervate"] = 			{ class = "DRUID", level = 54, },
	["Rebirth"] = 				{ class = "DRUID", level = 56, },
	["Flight Form"] = 			{ class = "DRUID", level = 58, },
	["Soothe"] = 				{ class = "DRUID", level = 60, },
	["Mark of the Wild"] = 		{ class = "DRUID", level = 62, },
	["Hibernate"] = 			{ class = "DRUID", level = 66, },
	["Frenzied Regeneration"] = { class = "DRUID", level = 68, },
	["Swift Flight Form"] = 	{ class = "DRUID", level = 70, },
	["Might of Ursoc"] = 		{ class = "DRUID", level = 72, },
	["Tranquility"] = 			{ class = "DRUID", level = 74, },
	["Cyclone"] = 				{ class = "DRUID", level = 78, },
	["Maim"] = 					{ class = "DRUID", level = 82, },
	["Stampeding Roar"] = 		{ class = "DRUID", level = 84, },
	["Symbiosis"] = 			{ class = "DRUID", level = 87, }, 
	--++ Glyph Abilities ++
	["Charm Woodland Creature"] = { class = "DRUID", level = 25, },
	["Treant Form"] = 			{ class = "DRUID", level = 25, },	
--++ Druid Specialization ++
	--++ Balance/Restoration ++
	["Natural Insight"] = 		{ class = "DRUID", level = 10, }, --++
	["Nature's Swiftness"] = 	{ class = "DRUID", level = 30, }, --Added in Patch 5.4
	["Killer Instinct"] = 		{ class = "DRUID", level = 34, },
	["Wild Mushroom"] = 		{ class = "DRUID", level = 84, },
	--++ Balance/Feral/Guardian ++
	["Remove Corruption"] = 	{ class = "DRUID", level = 22, },
	--++ Feral/Guardian ++
	["Rip"] = 					{ class = "DRUID", level = 20, },
	["Nurturing Instinct"] = 	{ class = "DRUID", level = 34, },
	["Infected Wounds"] = 		{ class = "DRUID", level = 40, },
	["Leader of the Pack"] =	{ class = "DRUID", level = 46, },
	["Berserk"] = 				{ class = "DRUID", level = 48, },
	["Ravage"] = 				{ class = "DRUID", level = 54, },
	["Survival Instincts"] = 	{ class = "DRUID", level = 56, },
	["Skull Bash"] = 			{ class = "DRUID", level = 64, },
	--++ Feral/Resoration ++
	["Omen of Clarity"] = 		{ class = "DRUID", level = 38, },
	--++ Balance ++
	["Balance of Power"] = 		{ class = "DRUID", level = 10, },
--	["Eclipse"] = 				{ class = "DRUID", level = 10, },
	["Starfire"] = 				{ class = "DRUID", level = 10, },
	["Starsurge"] = 			{ class = "DRUID", level = 12, },
--	["Celestial Focus"] = 		{ class = "DRUID", level = 14, },
	["Moonkin Form"] = 			{ class = "DRUID", level = 16, },
	["Sunfire"] = 				{ class = "DRUID", level = 18, },
	["Astral Communion"] = 		{ class = "DRUID", level = 20, },
	["Shooting Stars"] = 		{ class = "DRUID", level = 26, },
	["Solar Beam"] = 			{ class = "DRUID", level = 28, },
	["Euphoria"] = 				{ class = "DRUID", level = 38, },
	["Owlkin Frenzy"] = 		{ class = "DRUID", level = 48, },
	["Celestial Alignment"] = 	{ class = "DRUID", level = 68, },
	["Starfall"] = 				{ class = "DRUID", level = 76, },
	["Total Eclipse"] = 		{ class = "DRUID", level = 80, },
	["Lunar Shower"] = 			{ class = "DRUID", level = 82, },
	["Wild Mushroom: Detonate"] = { class = "DRUID", level = 84, },
	--++ Feral ++
	["Tiger's Fury"] = 			{ class = "DRUID", level = 10, },
--	["Feral Instinct"] = 		{ class = "DRUID", level = 14, },
	["Shred"] = 				{ class = "DRUID", level = 16, },
	["Savage Roar"] = 			{ class = "DRUID", level = 18, },
	["Predatory Swiftness"] = 	{ class = "DRUID", level = 26, },
	["Razor Claws"] = 			{ class = "DRUID", level = 80, },
	--++ Guardian ++ 
	["Savage Defense"] = 		{ class = "DRUID", level = 10, },
	["Vengeance"] = 			{ class = "DRUID", level = 10, },
	["Thick Hide"] = 			{ class = "DRUID", level = 14, },
	["Bear Hug"] = 				{ class = "DRUID", level = 18, },
	["Tooth and Claw"] = 		{ class = "DRUID", level = 32, }, --++
	["Enrage"] = 				{ class = "DRUID", level = 76, },
	["Nature's Guardian"] = 	{ class = "DRUID", level = 80, },
	--++ Restoration ++  
	["Naturalist"] = 			{ class = "DRUID", level = 10, },
	["Swiftmend"] = 			{ class = "DRUID", level = 10, },
	["Nourish"] = 				{ class = "DRUID", level = 12, },
	["Meditation"] = 			{ class = "DRUID", level = 14, },
	["Nature's Focus"] = 		{ class = "DRUID", level = 16, },
	["Regrowth"] = 				{ class = "DRUID", level = 18, },
	["Nature's Cure"] = 		{ class = "DRUID", level = 22, },
	["Living Seed"] = 			{ class = "DRUID", level = 28, },
	["Lifebloom"] = 			{ class = "DRUID", level = 36, },
	["Swift Rejuvenation"] = 	{ class = "DRUID", level = 46, },
	["Ironbark"] = 				{ class = "DRUID", level = 64, },
	["Wild Growth"] = 			{ class = "DRUID", level = 76, },
	["Harmony"] = 				{ class = "DRUID", level = 80, },
	["Malfurion's Gift"] = 		{ class = "DRUID", level = 82, },
	["Wild Mushroom: Bloom"] = 	{ class = "DRUID", level = 84, },
	["Genesis"] = 				{ class = "DRUID", level = 88, }, --Added in Patch 5.4
	--++ Druid Talents ++
	["Feline Swiftness"] = 		{ class = "DRUID", level = 15, },
	["Displacer Beast"] = 		{ class = "DRUID", level = 15, },
	["Wild Charge"] = 			{ class = "DRUID", level = 15, }, 
--	["Nature's Swiftness"] = 	{ class = "DRUID", level = 30, }, --Removed in Patch 5.4
	["Ysera's Gift"] = 			{ class = "DRUID", level = 30, }, --Added in Patch 5.4
	["Renewal"] = 				{ class = "DRUID", level = 30, },
	["Cenarion Ward"] = 		{ class = "DRUID", level = 30, }, 
	["Faerie Swarm"] = 			{ class = "DRUID", level = 45, },
	["Mass Entanglement"] = 	{ class = "DRUID", level = 45, },
	["Typhoon"] = 				{ class = "DRUID", level = 45, }, 
	["Soul of the Forest"] = 	{ class = "DRUID", level = 60, },
	["Incarnation"] = 			{ class = "DRUID", level = 60, },
	["Force of Nature"] = 		{ class = "DRUID", level = 60, },
	["Disorienting Roar"] = 	{ class = "DRUID", level = 75, },
	["Ursol's Vortex"] = 		{ class = "DRUID", level = 75, },
	["Mighty Bash"] = 			{ class = "DRUID", level = 75, }, 
	["Heart of the Wild"] = 	{ class = "DRUID", level = 90, },
	["Dream of Cenarius"] = 	{ class = "DRUID", level = 90, },
	["Nature's Vigil"] = 		{ class = "DRUID", level = 90, }, 

--++ Hunter Abilities ++
	["Arcane Shot"] = 			{ class = "HUNTER", level = 1, },
	["Auto Shot"] = 			{ class = "HUNTER", level = 1, },
	["Call Pet 1"] = 			{ class = "HUNTER", level = 1, },
	["Revive Pet"] = 			{ class = "HUNTER", level = 1, },
	["Steady Shot"] = 			{ class = "HUNTER", level = 3, },
	["Tracking"] = 				{ class = "HUNTER", level = 4, },
	["Concussive Shot"] = 		{ class = "HUNTER", level = 8, },
	["Beast Lore"] = 			{ class = "HUNTER", level = 10, },
	["Dismiss Pet"] = 			{ class = "HUNTER", level = 10, },
	["Serpent Sting"] = 		{ class = "HUNTER", level = 10, },
	["Tame Beast"] = 			{ class = "HUNTER", level = 10, },
	["Control Pet"] = 			{ class = "HUNTER", level = 10, },
	["Feed Pet"] = 				{ class = "HUNTER", level = 11, },
	["Aspect of the Hawk"] = 	{ class = "HUNTER", level = 12, },
	["Disengage"] = 			{ class = "HUNTER", level = 14, },
	["Hunter's Mark"] = 		{ class = "HUNTER", level = 14, },
	["Scatter Shot"] = 			{ class = "HUNTER", level = 15, },
	["Eagle Eye"] = 			{ class = "HUNTER", level = 16, },
	["Mend Pet"] = 				{ class = "HUNTER", level = 16, },
	["Call Pet 2"] = 			{ class = "HUNTER", level = 18, },
	["Counter Shot"] = 			{ class = "HUNTER", level = 22, }, --Added in Patch 5.4
	["Aspect of the Cheetah"] = { class = "HUNTER", level = 24, },
	["Multi-Shot"] = 			{ class = "HUNTER", level = 24, },
	["Freezing Trap"] = 		{ class = "HUNTER", level = 28, },
	["Feign Death"] = 			{ class = "HUNTER", level = 32, },
	["Kill Shot"] = 			{ class = "HUNTER", level = 35, },
	["Tranquilizing Shot"] = 	{ class = "HUNTER", level = 35, },
	["Scare Beast"] = 			{ class = "HUNTER", level = 36, },
	["Explosive Trap"] = 		{ class = "HUNTER", level = 38, },
	["Flare"] = 				{ class = "HUNTER", level = 38, },
	["Trueshot Aura"] = 		{ class = "HUNTER", level = 39, },
	["Widow Venom"] = 			{ class = "HUNTER", level = 40, },
	["Call Pet 3"] = 			{ class = "HUNTER", level = 42, },
	["Ice Trap"] = 				{ class = "HUNTER", level = 46, },
	["Trap Launcher"] = 		{ class = "HUNTER", level = 48, },
--	["Mail Specialization"] = 	{ class = "HUNTER", level = 50, },
	["Distracting Shot"] = 		{ class = "HUNTER", level = 52, },
	["Rapid Fire"] = 			{ class = "HUNTER", level = 54, },
	["Aspect of the Pack"] = 	{ class = "HUNTER", level = 56, },
--	["Readiness"] = 			{ class = "HUNTER", level = 60, }, --Removed in Patch 5.4
	["Call Pet 4"] = 			{ class = "HUNTER", level = 62, },
	["Snake Trap"] = 			{ class = "HUNTER", level = 66, },
	["Master's Call"] = 		{ class = "HUNTER", level = 74, },
	["Misdirection"] = 			{ class = "HUNTER", level = 76, },
	["Deterrence"] = 			{ class = "HUNTER", level = 78, },
	["Call Pet 5"] = 			{ class = "HUNTER", level = 82, },
	["Camouflage"] = 			{ class = "HUNTER", level = 85, },
	["Stampede"] = 				{ class = "HUNTER", level = 87, }, 
	--++ Glyph Abilities ++
	["Aspect of the Beast"] = 	{ class = "HUNTER", level = 25, }, 
	["Fetch"] = 				{ class = "HUNTER", level = 25, }, 
	["Fireworks"] = 			{ class = "HUNTER", level = 25, }, 
--++ Hunter Specialization ++
	--++ Beast Mastery/Survival ++
	["Cobra Shot"] = 			{ class = "HUNTER", level = 81, },
	--++ Beast Mastery ++
	["Kill Command"] = 			{ class = "HUNTER", level = 10, },
	["Go for the Throat"] = 	{ class = "HUNTER", level = 20, },
	["Beast Cleave"] = 			{ class = "HUNTER", level = 24, },
	["Frenzy"] = 				{ class = "HUNTER", level = 30, },
	["Focus Fire"] = 			{ class = "HUNTER", level = 32, },
	["Bestial Wrath"] = 		{ class = "HUNTER", level = 40, },
	["Cobra Strikes"] = 		{ class = "HUNTER", level = 43, },
	["The Beast Within"] = 		{ class = "HUNTER", level = 50, },
	["Kindred Spirits"] = 		{ class = "HUNTER", level = 58, },
	["Invigoration"] = 			{ class = "HUNTER", level = 63, },
	["Exotic Beasts"] = 		{ class = "HUNTER", level = 69, },
	["Master of Beasts"] = 		{ class = "HUNTER", level = 80, },
	--++ Marksmanship ++ 
	["Aimed Shot"] = 			{ class = "HUNTER", level = 10, },
	["Careful Aim"] = 			{ class = "HUNTER", level = 20, },
	["Silencing Shot"] = 		{ class = "HUNTER", level = 30, }, --Added in Patch 5.4
--	["Binding Shot"] = 			{ class = "HUNTER", level = 30, }, --Removed in Patch 5.4
	["Concussive Barrage"] = 	{ class = "HUNTER", level = 30, },
	["Bombardment"] = 			{ class = "HUNTER", level = 45, },
	["Rapid Recuperation"] = 	{ class = "HUNTER", level = 54, }, --Changed
	["Master Marksman"] = 		{ class = "HUNTER", level = 58, },
	["Chimera Shot"] = 			{ class = "HUNTER", level = 60, },
	["Steady Focus"] = 			{ class = "HUNTER", level = 63, },
	["Piercing Shots"] = 		{ class = "HUNTER", level = 72, },
	["Wild Quiver"] = 			{ class = "HUNTER", level = 80, },
	--++ Survival ++  
	["Explosive Shot"] = 		{ class = "HUNTER", level = 10, },
	["Lock and Load"] = 		{ class = "HUNTER", level = 43, },
	["Black Arrow"] = 			{ class = "HUNTER", level = 50, },
	["Entrapment"] = 			{ class = "HUNTER", level = 55, },
	["Viper Venom"] = 			{ class = "HUNTER", level = 63, },
	["Trap Mastery"] = 			{ class = "HUNTER", level = 64, },
	["Serpent Spread"] = 		{ class = "HUNTER", level = 68, },
	["Improved Serpent Sting"] = { class = "HUNTER", level = 70, },
	["Essence of the Viper"] = 	{ class = "HUNTER", level = 80, },
--++ Hunter Talents ++
	["Posthaste"] = 			{ class = "HUNTER", level = 15, },
	["Narrow Escape"] = 		{ class = "HUNTER", level = 15, },
	["Crouching Tiger, Hidden Chimera"] = { class = "HUNTER", level = 15, }, 
	["Binding Shot"] = 			{ class = "HUNTER", level = 30, }, --Added in Patch 5.4
--	["Silencing Shot"] = 		{ class = "HUNTER", level = 30, }, --Removed in Patch 5.4
	["Wyvern Sting"] = 			{ class = "HUNTER", level = 30, },
	["Intimidation"] = 			{ class = "HUNTER", level = 30, }, --++
	["Exhilaration"] = 			{ class = "HUNTER", level = 45, },
	["Aspect of the Iron Hawk"] = { class = "HUNTER", level = 45, },
	["Spirit Bond"] = 			{ class = "HUNTER", level = 45, }, 
	["Fervor"] = 				{ class = "HUNTER", level = 60, },
	["Dire Beast"] = 			{ class = "HUNTER", level = 60, },
	["Thrill of the Hunt"] = 	{ class = "HUNTER", level = 60, }, 
	["A Murder of Crows"] = 	{ class = "HUNTER", level = 75, },
	["Blink Strikes"] = 		{ class = "HUNTER", level = 75, },
	["Lynx Rush"] = 			{ class = "HUNTER", level = 75, }, 
	["Glaive Toss"] = 			{ class = "HUNTER", level = 90, },
	["Powershot"] = 			{ class = "HUNTER", level = 90, },
	["Barrage"] = 				{ class = "HUNTER", level = 90, }, 

--++ Mage Abilities ++
	["Frostfire Bolt"] = 		{ class = "MAGE", level = 1, },
	["Frost Nova"] = 			{ class = "MAGE", level = 3, },
	["Fire Blast"] = 			{ class = "MAGE", level = 5, },
	["Blink"] = 				{ class = "MAGE", level = 7, },
	["Counterspell"] = 			{ class = "MAGE", level = 8, },
	["Polymorph"] = 			{ class = "MAGE", level = 14, },
	["Shatter"] = 				{ class = "MAGE", level = 16, },
	["Arcane Explosion"] = 		{ class = "MAGE", level = 18, },
	["Ice Lance"] = 			{ class = "MAGE", level = 22, },
	["Ice Block"] = 			{ class = "MAGE", level = 26, },
	["Cone of Cold"] = 			{ class = "MAGE", level = 28, },
	["Remove Curse"] = 			{ class = "MAGE", level = 29, },
	["Slow Fall"] = 			{ class = "MAGE", level = 32, },
	["Molten Armor"] = 			{ class = "MAGE", level = 34, },
	["Conjure Refreshment"] = 	{ class = "MAGE", level = 38, },
	["Evocation"] = 			{ class = "MAGE", level = 40, },
	["Flamestrike"] = 			{ class = "MAGE", level = 44, },
	["Conjure Mana Gem"] = 		{ class = "MAGE", level = 47, },
	["Mirror Image"] = 			{ class = "MAGE", level = 49, },
	["Wizardry"] = 				{ class = "MAGE", level = 50, },
	["Blizzard"] = 				{ class = "MAGE", level = 52, },
	["Frost Armor"] = 			{ class = "MAGE", level = 54, },
	["Frost Bolt"] = 			{ class = "MAGE", level = 54, },	--++
	["Invisibility"] = 			{ class = "MAGE", level = 56, },
	["Arcane Brilliance"] = 	{ class = "MAGE", level = 58, },
	["Spellsteal"] = 			{ class = "MAGE", level = 64, },
	["Deep Freeze"] = 			{ class = "MAGE", level = 66, },
	["Improved Counterspell"] =	{ class = "MAGE", level = 70, },
	["Conjure Refreshment Table"] =	{ class = "MAGE", level = 72, },	
	["Nether Attunement"] = 	{ class = "MAGE", level = 74, },
	["Mage Bomb"] = 			{ class = "MAGE", level = 75, },
	["Dalaran Brilliance"] = 	{ class = "MAGE", level = 80, }, 
	["Mage Armor"] = 			{ class = "MAGE", level = 80, },
	["Burning Soul"] = 			{ class = "MAGE", level = 82, },
	["Time Warp"] = 			{ class = "MAGE", level = 84, },
	["Alter Time"] = 			{ class = "MAGE", level = 87, }, 
	["Polymorph: Pig"] = 		{ class = "MAGE", level = 60, },
	["Polymorph: Rabbit"] = 	{ class = "MAGE", level = 60, },
	["Polymorph: Turtle"] = 	{ class = "MAGE", level = 60, },
	["Polymorph: Black Cat"] = 	{ class = "MAGE", level = 60, }, 
	["Polymorph: Turkey"] = 	{ class = "MAGE", level = 60, }, 
	["Ancient Portal: Dalaran"] = { class = "MAGE", level = 74, }, --++
	["Portal: Dalaran"] = 		{ class = "MAGE", level = 74, },
	["Portal: Darnassus"] = 	{ class = "MAGE", level = 42, },
	["Portal: Exodar"] = 		{ class = "MAGE", level = 42, },
	["Portal: Ironforge"] = 	{ class = "MAGE", level = 42, },
	["Portal: Orgrimmar"] = 	{ class = "MAGE", level = 42, },
	["Portal: Shattrath"] = 	{ class = "MAGE", level = 66, },
	["Portal: Silvermoon"] = 	{ class = "MAGE", level = 42, },
	["Portal: Stonard"] = 		{ class = "MAGE", level = 52, },
	["Portal: Stormwind"] = 	{ class = "MAGE", level = 42, },
	["Portal: Theramore"] = 	{ class = "MAGE", level = 42, },
	["Portal: Thunder Bluff"] =	{ class = "MAGE", level = 42, },
	["Portal: Tol Barad"] = 	{ class = "MAGE", level = 85, },
	["Portal: Undercity"] = 	{ class = "MAGE", level = 42, },
	["Portal: Vale of Eternal Blossoms"] = { class = "MAGE", level = 90, }, --++	
	["Ancient Teleport: Dalaran"] = { class = "MAGE", level = 71, }, --++
	["Teleport: Dalaran"] = 	{ class = "MAGE", level = 71, },
	["Teleport: Darnassus"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Exodar"] = 		{ class = "MAGE", level = 17, },
	["Teleport: Ironforge"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Orgrimmar"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Shattrath"] = 	{ class = "MAGE", level = 62, },
	["Teleport: Silvermoon"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Stonard"] = 	{ class = "MAGE", level = 52, },
	["Teleport: Stormwind"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Theramore"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Thunder Bluff"] = { class = "MAGE", level = 17, },
	["Teleport: Tol Barad"] = 	{ class = "MAGE", level = 85, },
	["Teleport: Undercity"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Vale of Eternal Blossoms"] = { class = "MAGE", level = 90, }, --++
	--++ Glyph Abilities ++
	["Conjure Familiar"] = 		{ class = "MAGE", level = 25, },
	["Illusion"] =   			{ class = "MAGE", level = 25, },
--++ Mage Specialization ++
	--++ Arcane ++
	["Arcane Blast"] = 			{ class = "MAGE", level = 10, },
	["Arcane Charge"] = 		{ class = "MAGE", level = 10, },
	["Arcane Barrage"] = 		{ class = "MAGE", level = 12, },
	["Arcane Missiles"] = 		{ class = "MAGE", level = 24, },
	["Slow"] = 					{ class = "MAGE", level = 36, },
	["Arcane Power"] = 			{ class = "MAGE", level = 62, },
	["Mana Adept"] = 			{ class = "MAGE", level = 80, }, 
	--++ Fire ++ 
	["Pyroblast"] = 			{ class = "MAGE", level = 10, },
	["Fireball"] = 				{ class = "MAGE", level = 12, },
	["Inferno Blast"] = 		{ class = "MAGE", level = 24, },
	["Critical Mass"] = 		{ class = "MAGE", level = 36, },
	["Scorch"] = 				{ class = "MAGE", level = 48, },  --++ Changed
	["Dragon's Breath"] = 		{ class = "MAGE", level = 62, },
	["Combustion"] = 			{ class = "MAGE", level = 77, }, --++
	["Ignite"] = 				{ class = "MAGE", level = 80, },
	["Pyromaniac"] = 			{ class = "MAGE", level = 85, },
	--++ Frost ++ 
	["Summon Water Elemental"] = { class = "MAGE", level = 10, },
	["Frostbolt"] = 			{ class = "MAGE", level = 12, },
	["Fingers of Frost"] = 		{ class = "MAGE", level = 24, },
	["Icy Veins"] = 			{ class = "MAGE", level = 36, },
	["Frozen Orb"] = 			{ class = "MAGE", level = 62, },
	["Brain Freeze"] = 			{ class = "MAGE", level = 77, },
--	["Frostburn"] = 			{ class = "MAGE", level = 80, }, --Removed in Patch 5.4
	["Icicles"] = 				{ class = "MAGE", level = 80, }, --Added in Patch 5.4
--++ Mage Talents ++
	["Presence of Mind"] = 		{ class = "MAGE", level = 15, },
	["Blazing Speed"] = 		{ class = "MAGE", level = 15, }, --++
	["Ice Floes"] = 			{ class = "MAGE", level = 15, }, 
	["Flameglow"] = 			{ class = "MAGE", level = 30, },
	["Temporal Shield"] = 		{ class = "MAGE", level = 30, },
	["Ice Barrier"] = 			{ class = "MAGE", level = 30, }, 
	["Ring of Frost"] = 		{ class = "MAGE", level = 45, },
	["Ice Ward"] = 				{ class = "MAGE", level = 45, },
	["Frostjaw"] = 				{ class = "MAGE", level = 45, }, 
	["Greater Invisibility"] = 	{ class = "MAGE", level = 60, },
	["Cauterize"] = 			{ class = "MAGE", level = 60, },
	["Cold Snap"] = 			{ class = "MAGE", level = 60, }, 
	["Nether Tempest"] = 		{ class = "MAGE", level = 75, },
	["Living Bomb"] = 			{ class = "MAGE", level = 75, },
	["Frost Bomb"] = 			{ class = "MAGE", level = 75, }, 
	["Invocation"] = 			{ class = "MAGE", level = 90, },
	["Rune of Power"] = 		{ class = "MAGE", level = 90, },
	["Incanter's Ward"] = 		{ class = "MAGE", level = 90, }, 

--++ Monk Abilities ++
	["Jab"]   = 				{ class = "MONK", level = 1, },
	["Stance of the Fierce Tiger"] = { class = "MONK", level = 1, },  
	["Way of the Monk"]   = 	{ class = "MONK", level = 1, },  
	["Tiger Palm"]   = 			{ class = "MONK", level = 3, },  
	["Roll"]   = 				{ class = "MONK", level = 5, },  
	["Blackout Kick"]   = 		{ class = "MONK", level = 7, },  
	["Provoke"]   = 			{ class = "MONK", level = 14, },  
	["Resuscitate"]   = 		{ class = "MONK", level = 18, },  
	["Detox"]   = 				{ class = "MONK", level = 20, },  
	["Zen Pilgrimage"]   = 		{ class = "MONK", level = 20, },  
	["Legacy of the Emperor"] = { class = "MONK", level = 22, },  
	["Touch of Death"]   = 		{ class = "MONK", level = 22, },  
	["Swift Reflexes"]   = 		{ class = "MONK", level = 23, }, 
	["Fortifying Brew"]   = 	{ class = "MONK", level = 24, },  
	["Expel Harm"]   = 			{ class = "MONK", level = 26, },  
	["Disable"]   = 			{ class = "MONK", level = 28, },
	["Nimble Brew"]   = 		{ class = "MONK", level = 30, }, --++
	["Zen Pilgrimage: Return"] = { class = "MONK", level = 30, }, --++
	["Spear Hand Strike"]   = 	{ class = "MONK", level = 32, },  
	["Paralysis"]   = 			{ class = "MONK", level = 44, },  
--	["Rushing Jade Wind"] =		{ class = "MONK", level = 46, },  --Removed in Patch 5.4
	["Spinning Crane Kick"]   = { class = "MONK", level = 46, },  --Added in Patch 5.4	  
	["Crackling Jade Lightning"]  = { class = "MONK", level = 54, },  
	["Healing Sphere"]   = 		{ class = "MONK", level = 64, },  
--  ["Path of Blossoms"]   = 	{ class = "MONK", level = 64, },  --Removed in 5.2
	["Grapple Weapon"]   = 		{ class = "MONK", level = 68, }, 
	["Zen Meditation"]   = 		{ class = "MONK", level = 82, },  
	["Transcendence"]   = 		{ class = "MONK", level = 87, },  
	["Transcendence: Transfer"] = { class = "MONK", level = 87, },
	--++ Glyph Abilities ++
	["Leer of the Ox"] = 		{ class = "MONK", level = 25, },
	["Zen Flight"] =   			{ class = "MONK", level = 25, },	
--++ Monk Specialization ++
	--++ Mistweaver/Windwalker ++	
	["Tiger Strikes"]   = 		{ class = "MONK", level = 10, },	
	--++ Brewmaster ++ 
	["Stance of the Sturdy Ox"] = { class = "MONK", level = 10, },  
	["Dizzying Haze"]   = 		{ class = "MONK", level = 10, },  
 	["Vengeance"]   = 			{ class = "MONK", level = 10, },  
	["Keg Smash"]   = 			{ class = "MONK", level = 11, },  
	["Clash"]   = 				{ class = "MONK", level = 18, },  
	["Breath of Fire"]   = 		{ class = "MONK", level = 18, },  
	["Guard"]   = 				{ class = "MONK", level = 26, },  
	["Brewmaster Training"] =	{ class = "MONK", level = 34, },  
	["Elusive Brew"]   = 		{ class = "MONK", level = 36, },  
	["Brewing: Elusive Brew"] =	{ class = "MONK", level = 36, },  
	["Desperate Measures"]   = 	{ class = "MONK", level = 45, },  
	["Avert Harm"]   = 			{ class = "MONK", level = 48, },  
--	["Leather Specialization"] = { class = "MONK", level = 50, },  
	["Gift of the Ox"]   = 		{ class = "MONK", level = 56, },  
	["Summon Black Ox Statue"] = { class = "MONK", level = 70, },  
	["Purifying Brew"]   = 		{ class = "MONK", level = 75, },  
	["Elusive Brawler"]   = 	{ class = "MONK", level = 80, },
	--++ Mistweaver ++ 	
	["Stance of the Wise Serpent"] = { class = "MONK", level = 10, },  
	["Soothing Mist"]   = 		{ class = "MONK", level = 10, },  
	["Mana Meditation"]   = 	{ class = "MONK", level = 10, },
	["Enveloping Mist"]   = 	{ class = "MONK", level = 16, },  	
	["Internal Medicine"]   = 	{ class = "MONK", level = 20, }, 
	["Muscle Memory"]   = 		{ class = "MONK", level = 20, }, --++
	["Surging Mist"]   = 		{ class = "MONK", level = 32, },  
	["Teachings of the Monastery"] = { class = "MONK", level = 34, },  
	["Renewing Mist"]   = 		{ class = "MONK", level = 42, },  
	["Demateralize"]   = 		{ class = "MONK", level = 45, },  
	["Life Cocoon"]   = 		{ class = "MONK", level = 50, },  
--	["Leather Specialization"] = { class = "MONK", level = 50, },  
	["Mana Tea"]   = 			{ class = "MONK", level = 56, },  
	["Brewing: Mana Tea"]   = 	{ class = "MONK", level = 56, },  
	["Uplift"]   = 				{ class = "MONK", level = 62, },  
	["Thunder Focus Tea"]   = 	{ class = "MONK", level = 66, },  
	["Summon Jade Serpent Statue"] = { class = "MONK", level = 70, },  
	["Revival"]   = 			{ class = "MONK", level = 78, }, 
	["Gift of the Serpent"] = 	{ class = "MONK", level = 80, }, 
	--++ Windwalker ++ 	
	["Fists of Fury"] = 		{ class = "MONK", level =  10, }, 
	["Combo Breaker"] = 		{ class = "MONK", level =  15, }, 
	["Flying Serpent Kick"] = 	{ class = "MONK", level =  18, }, 
	["Combat Conditioning"] = 	{ class = "MONK", level =  20, }, 
	["Touch of Karma"] = 		{ class = "MONK", level =  22, }, 
	["Afterlife"] = 			{ class = "MONK", level =  26, }, 
	["Energizing Brew"] = 		{ class = "MONK", level =  36, }, 
	["Sparring"] = 				{ class = "MONK", level =  42, }, 
	["Adaptation"] = 			{ class = "MONK", level =  45, }, 
	["Spinning Fire Blossom"] =	{ class = "MONK", level =  48, }, 
--	["Leather Specialization"] = { class = "MONK", level =  50, }, 
	["Rising Sun Kick"] = 		{ class = "MONK", level =  56, }, 
	["Tigereye Brew"] = 		{ class = "MONK", level =  56, }, 	
	["Brewing: Tigereye Brew"] = { class = "MONK", level =  56, }, 
	["Storm, Earth and Fire"] = { class = "MONK", level =  75, }, 
	["Bottled Fury"] = 			{ class = "MONK", level = 80, },	
	["Legacy of the White Tiger"] = { class = "MONK", level =  81, }, 
--++ Monk Talents ++
	["Celerity"]  = 			{ class = "MONK", level = 15, },  
	["Tiger's Lust"] =  		{ class = "MONK", level = 15, },  
	["Momentum"]  = 			{ class = "MONK", level = 15, }, 
	["Chi Wave"]  = 			{ class = "MONK", level = 30, },  
	["Zen Sphere"]  = 			{ class = "MONK", level = 30, },  
	["Chi Burst"]  = 			{ class = "MONK", level = 30, }, 
	["Power Strikes"]  = 		{ class = "MONK", level = 45, },  
	["Ascension"]  = 			{ class = "MONK", level = 45, },  
	["Chi Brew"]  = 			{ class = "MONK", level = 45, }, 
	["Ring of Peace"]  = 		{ class = "MONK", level = 60, },
--  ["Deadly Reach"]  = 		{ class = "MONK", level = 60, },  --Removed in Patch 5.2
	["Charging Ox Wave"]  = 	{ class = "MONK", level = 60, },  
	["Leg Sweep"]  = 			{ class = "MONK", level = 60, }, 
	["Healing Elixirs"]  = 		{ class = "MONK", level = 75, },  
	["Dampen Harm"]  = 			{ class = "MONK", level = 75, },  
	["Diffuse Magic"]  = 		{ class = "MONK", level = 75, }, 
	["Rushing Jade Wind"]  = 	{ class = "MONK", level = 90, },  
	["Invoke Xuen, the White Tiger"] = { class = "MONK", level = 90, },  
	["Chi Torpedo"] = 			{ class = "MONK", level = 90, },  

--++ Paladin Abilities ++
	["Crusader Strike"] = 		{ class = "PALADIN", level = 1, },
	["Seal of Command"] = 		{ class = "PALADIN", level = 3, },
	["Judgment"] = 				{ class = "PALADIN", level = 5, },
	["Hammer of Justice"] = 	{ class = "PALADIN", level = 7, },
	["Harsh Word"] = 			{ class = "PALADIN", level = 9, },
	["Word of Glory"] = 		{ class = "PALADIN", level = 9, },
	["Righteous Fury"] = 		{ class = "PALADIN", level = 12, },
	["Redemption"] = 			{ class = "PALADIN", level = 13, },
	["Flash of Light"] = 		{ class = "PALADIN", level = 14, },
	["Reckoning"] = 			{ class = "PALADIN", level = 15, }, --Changed
	["Lay on Hands"] = 			{ class = "PALADIN", level = 16, },
	["Divine Shield"] = 		{ class = "PALADIN", level = 18, },
	["Cleanse"] = 				{ class = "PALADIN", level = 20, },
	["Seal of Truth"] = 		{ class = "PALADIN", level = 24, },
	["Divine Protection"] = 	{ class = "PALADIN", level = 26, },
	["Blessing of Kings"] = 	{ class = "PALADIN", level = 30, },
	["Seal of Insight"] = 		{ class = "PALADIN", level = 32, },
	["Supplication"] = 			{ class = "PALADIN", level = 34, },
	["Rebuke"] = 				{ class = "PALADIN", level = 36, },
	["Hammer of Wrath"] = 		{ class = "PALADIN", level = 38, },
	["Seal of Righteousness"] = { class = "PALADIN", level = 42, },
	["Heart of the Crusader"] = { class = "PALADIN", level = 44, },
	["Turn Evil"] = 			{ class = "PALADIN", level = 46, },
	["Hand of Protection"] = 	{ class = "PALADIN", level = 48, },
	["Hand of Freedom"] = 		{ class = "PALADIN", level = 52, },
	["Sanctity of Battle"] = 	{ class = "PALADIN", level = 58, },
	["Devotion Aura"] = 		{ class = "PALADIN", level = 60, },
	["Hand of Salvation"] = 	{ class = "PALADIN", level = 66, },
	["Avenging Wrath"] = 		{ class = "PALADIN", level = 72, },
	["Hand of Sacrifice"] = 	{ class = "PALADIN", level = 80, },
	["Blessing of Might"] = 	{ class = "PALADIN", level = 81, },
	["Boundless Conviction"] = 	{ class = "PALADIN", level = 85, },
	["Blinding Light"] = 		{ class = "PALADIN", level = 87, },
	--++ Glyph Abilities ++
	["Contemplation"] = 		{ class = "PALADIN", level = 25, },
--++ Paladin Specialization ++
	--++ Protection/Retribution ++ 
	["Hammer of the Righteous"] = { class = "PALADIN", level = 20, },
	--++ Holy/Protection/Retribution ++	
	["Guardian of the Ancient Kings"] = { class = "PALADIN", level = 75, },	--++
	--++ Holy ++
	["Holy Shock"] = 			{ class = "PALADIN", level = 10, },
	["Holy Insight"] = 			{ class = "PALADIN", level = 10, },
	["Denounce"] = 				{ class = "PALADIN", level = 20, },
	["Sacred Cleansing"] = 		{ class = "PALADIN", level = 20, }, --changed
	["Holy Radiance"] = 		{ class = "PALADIN", level = 28, },
	["Holy Light"] = 			{ class = "PALADIN", level = 34, },
	["Beacon of Light"] = 		{ class = "PALADIN", level = 39, },
	["Divine Plea"] = 			{ class = "PALADIN", level = 46, },
	["Infusion of Light"] = 	{ class = "PALADIN", level = 50, },
	["Divine Light"] = 			{ class = "PALADIN", level = 54, },
	["Daybreak"] = 				{ class = "PALADIN", level = 56, },
	["Divine Favor"] = 			{ class = "PALADIN", level = 62, },
	["Tower of Radiance"] = 	{ class = "PALADIN", level = 64, },
	["Light of Dawn"] = 		{ class = "PALADIN", level = 70, },
	["Illuminated Healing"] = 	{ class = "PALADIN", level = 80, }, 
	--++ Protection ++ 
	["Avenger's Shield"] = 		{ class = "PALADIN", level = 10, },
	["Guarded by the Light"] = 	{ class = "PALADIN", level = 10, },
	["Vengeance"] = 			{ class = "PALADIN", level = 10, },
	["Holy Wrath"] = 			{ class = "PALADIN", level = 20, },
	["Judgments of the Wise"] = { class = "PALADIN", level = 28, },
	["Consecration"] = 			{ class = "PALADIN", level = 34, },
	["Shield of the Righteous"] = { class = "PALADIN", level = 40, },
	["Grand Crusader"] = 		{ class = "PALADIN", level = 50, },
	["Sanctuary"] = 			{ class = "PALADIN", level = 64, },
	["Ardent Defender"] = 		{ class = "PALADIN", level = 70, },
	["Divine Bulwark"] = 		{ class = "PALADIN", level = 80, },
	--++ Retribution ++  
	["Templar's Verdict"] = 	{ class = "PALADIN", level = 10, },
	["Sword of Light"] = 		{ class = "PALADIN", level = 10, },
	["Judgments of the Bold"] = { class = "PALADIN", level = 28, },
	["Divine Storm"] = 			{ class = "PALADIN", level = 34, },
	["Exorcism"] = 				{ class = "PALADIN", level = 46, },
	["The Art of War"] = 		{ class = "PALADIN", level = 50, },
	["Emancipate"] = 			{ class = "PALADIN", level = 54, },
	["Seal of Justice"] = 		{ class = "PALADIN", level = 70, },
	["Absolve"] = 				{ class = "PALADIN", level = 80, },	--++
	["Hand of Light"] = 		{ class = "PALADIN", level = 80, },
	["Inquisition"] = 			{ class = "PALADIN", level = 81, }, 
--++ Paladin Talents ++
	["Speed of Light"] = 		{ class = "PALADIN", level = 15, },
	["Long Arm of the Law"] = 	{ class = "PALADIN", level = 15, },
	["Pursuit of Justice"] = 	{ class = "PALADIN", level = 15, }, 
	["Fist of Justice"] = 		{ class = "PALADIN", level = 30, },
	["Repentance"] = 			{ class = "PALADIN", level = 30, },
--	["Burden of Guilt"] = 		{ class = "PALADIN", level = 30, }, --Removed in Patch 5.4
	["Evil is a Point of View"] = { class = "PALADIN", level = 30, }, --Added in Patch 5.4
	["Selfless Healer"] = 		{ class = "PALADIN", level = 45, },
	["Eternal Flame"] = 		{ class = "PALADIN", level = 45, },
	["Sacred Shield"] = 		{ class = "PALADIN", level = 45, }, 
	["Hand of Purity"] = 		{ class = "PALADIN", level = 60, },
	["Unbreakable Spirit"] =	{ class = "PALADIN", level = 60, },
	["Clemency"] = 				{ class = "PALADIN", level = 60, }, 
	["Holy Avenger"] = 			{ class = "PALADIN", level = 75, },
	["Sanctified Wrath"] = 		{ class = "PALADIN", level = 75, },
	["Divine Purpose"] = 		{ class = "PALADIN", level = 75, }, 
	["Holy Prism"] = 			{ class = "PALADIN", level = 90, },
	["Light's Hammer"] = 		{ class = "PALADIN", level = 90, },
	["Execution Sentence"] = 	{ class = "PALADIN", level = 90, },

--++ Priest Abilities ++
	["Smite"] = 				{ class = "PRIEST", level = 1, },
	["Shadow Word: Pain"] = 	{ class = "PRIEST", level = 3, },
	["Power Word: Shield"] = 	{ class = "PRIEST", level = 5, },
	["Flash Heal"] = 			{ class = "PRIEST", level = 7, },
	["Inner Fire"] = 			{ class = "PRIEST", level = 9, },
	["Divine Focus"] = 			{ class = "PRIEST", level = 10, },
	["Psychic Scream"] = 		{ class = "PRIEST", level = 12, },
	["Resurrection"] = 			{ class = "PRIEST", level = 18, },
	["Power Word: Fortitude"] = { class = "PRIEST", level = 22, },
	["Fade"] = 					{ class = "PRIEST", level = 24, },
	["Dispel Magic"] = 			{ class = "PRIEST", level = 26, },
	["Renew"] = 				{ class = "PRIEST", level = 26, },
	["Shackle Undead"] = 		{ class = "PRIEST", level = 32, },
	["Levitate"] = 				{ class = "PRIEST", level = 34, },
	["Mind Vision"] = 			{ class = "PRIEST", level = 42, },
	["Shadowfiend"] = 			{ class = "PRIEST", level = 42, },
	["Shadow Word: Death"] = 	{ class = "PRIEST", level = 46, },
	["Binding Heal"] = 			{ class = "PRIEST", level = 48, },
	["Mysticism"] = 			{ class = "PRIEST", level = 50, },
	["Fear Ward"] = 			{ class = "PRIEST", level = 54, },
	["Hymn of Hope"] = 			{ class = "PRIEST", level = 66, },
	["Prayer of Mending"] = 	{ class = "PRIEST", level = 68, },
	["Mass Dispel"] = 			{ class = "PRIEST", level = 72, },
	["Mind Sear"] = 			{ class = "PRIEST", level = 76, },
	["Inner Will"] = 			{ class = "PRIEST", level = 80, },
	["Leap of Faith"] = 		{ class = "PRIEST", level = 84, },
	["Void Shift"] = 			{ class = "PRIEST", level = 87, },
	--++ Glyph Abilities ++
	["Holy Nova"] = 			{ class = "PRIEST", level = 25, },
	["Confession"] = 			{ class = "PRIEST", level = 25, },
--++ Priest Specialization ++
	--++ Discipline/Holy ++
	["Meditation"] = 			{ class = "PRIEST", level = 10, },
	["Spiritual Healing"] = 	{ class = "PRIEST", level = 10, }, --++
--	["Divine Fury"] = 			{ class = "PRIEST", level = 16, },
	["Holy Fire"] = 			{ class = "PRIEST", level = 18, },
	["Purify"] = 				{ class = "PRIEST", level = 22, },
	["Heal"] = 					{ class = "PRIEST", level = 28, },
	["Focused Will"] = 			{ class = "PRIEST", level = 30, }, --++
	["Greater Heal"] = 			{ class = "PRIEST", level = 34, },
	["Evangelism"] = 			{ class = "PRIEST", level = 44, },
	["Prayer of Healing"] = 	{ class = "PRIEST", level = 46, },
	--++ Discipline ++
	["Rapture"] = 				{ class = "PRIEST", level = 10, },
	["Penance"] = 				{ class = "PRIEST", level = 10, },
	["Divine Aegis"] = 			{ class = "PRIEST", level = 24, },
	["Spirit Shell"] = 			{ class = "PRIEST", level = 28, },
	["Inner Focus"] = 			{ class = "PRIEST", level = 36, },
	["Atonement"] = 			{ class = "PRIEST", level = 38, }, --changed
	["Grace"] = 				{ class = "PRIEST", level = 45, },
	["Archangel"] = 			{ class = "PRIEST", level = 50, },
	["Strength of Soul"] = 		{ class = "PRIEST", level = 52, },
	["Pain Suppression"] = 		{ class = "PRIEST", level = 58, },
	["Borrowed Time"] = 		{ class = "PRIEST", level = 62, },
	["Power Word: Barrier"] = 	{ class = "PRIEST", level = 70, },
	["Train of Thought"] = 		{ class = "PRIEST", level = 78, },
	["Shield Discipline"] = 	{ class = "PRIEST", level = 80, },
	--++ Holy ++
	["Holy Word: Chastise"] = 	{ class = "PRIEST", level = 10, },
	["Spirit of Redemption"] = 	{ class = "PRIEST", level = 30, },
	["Serendipity"] = 			{ class = "PRIEST", level = 34, },
	["Lightwell"] = 			{ class = "PRIEST", level = 36, }, --Added in Patch 5.4 
	["Circle of Healing"] = 	{ class = "PRIEST", level = 50, },
	["Chakra: Chastise"] = 		{ class = "PRIEST", level = 56, },
	["Chakra: Sanctuary"] = 	{ class = "PRIEST", level = 56, },
	["Chakra: Serenity"] = 		{ class = "PRIEST", level = 56, },
	["Rapid Renewal"] = 		{ class = "PRIEST", level = 64, },
	["Guardian Spirit"] = 		{ class = "PRIEST", level = 70, },
	["Divine Hymn"] = 			{ class = "PRIEST", level = 78, },
	["Echo of Light"] = 		{ class = "PRIEST", level = 80, },
	--++ Shadow ++
	["Mind Flay"] = 			{ class = "PRIEST", level = 10, },
	["Spiritual Precision"] = 	{ class = "PRIEST", level = 10, }, --changed
	["Devouring Plague"] = 		{ class = "PRIEST", level = 21, },
	["Mind Blast"] = 			{ class = "PRIEST", level = 21, },
	["Shadow Orbs"] = 			{ class = "PRIEST", level = 21, },
	["Shadowform"] = 			{ class = "PRIEST", level = 24, },
	["Vampiric Touch"] = 		{ class = "PRIEST", level = 28, },
	["Shadowy Apparitions"] = 	{ class = "PRIEST", level = 42, },
	["Mind Spike"] = 			{ class = "PRIEST", level = 44, },
	["Silence"] = 				{ class = "PRIEST", level = 52, },
	["Dispersion"] = 			{ class = "PRIEST", level = 60, },
	["Psychic Horror"] = 		{ class = "PRIEST", level = 74, },
	["Vampiric Embrace"] = 		{ class = "PRIEST", level = 78, },
	["Shadowy Recall"] = 		{ class = "PRIEST", level = 80, },
--++ Priest Talents ++
	["Void Tendrils"] = 		{ class = "PRIEST", level = 15, },
	["Psyfiend"] = 				{ class = "PRIEST", level = 15, },
	["Dominate Mind"] = 		{ class = "PRIEST", level = 15, }, 
	["Body and Soul"] = 		{ class = "PRIEST", level = 30, },
	["Angelic Feather"] = 		{ class = "PRIEST", level = 30, },
	["Phantasm"] = 				{ class = "PRIEST", level = 30, }, 
	["From Darkness, Comes Light"] = { class = "PRIEST", level = 45, },
	["Mindbender"] = 			{ class = "PRIEST", level = 45, },
	["Solace and Insanity"] = 	{ class = "PRIEST", level = 45, }, --changed
--	["Shadow Word: Insanity"] = { class = "PRIEST", level = 45, }, 
	["Desperate Prayer"] = 		{ class = "PRIEST", level = 60, },
	["Spectral Guise"] = 		{ class = "PRIEST", level = 60, },
	["Angelic Bulwark"] = 		{ class = "PRIEST", level = 60, }, 
	["Twist of Fate"] = 		{ class = "PRIEST", level = 75, },
	["Power Infusion"] = 		{ class = "PRIEST", level = 75, },
	["Divine Insight"] = 		{ class = "PRIEST", level = 75, }, 
	["Cascade"] = 				{ class = "PRIEST", level = 90, },
	["Divine Star"] = 			{ class = "PRIEST", level = 90, },
	["Halo"] = 					{ class = "PRIEST", level = 90, },

--++ Rogue Abilities ++
	["Sinister Strike"] = 		{ class = "ROGUE", level = 1, },
	["Eviscerate"] = 			{ class = "ROGUE", level = 3, },
	["Stealth"] = 				{ class = "ROGUE", level = 5, },
	["Ambush"] = 				{ class = "ROGUE", level = 6, },
	["Evasion"] = 				{ class = "ROGUE", level = 8, },
	["Deadly Poison"] = 		{ class = "ROGUE", level = 10, },
	["Sap"] = 					{ class = "ROGUE", level = 12, },
	["Slice and Dice"] = 		{ class = "ROGUE", level = 14, },
	["Pick Pocket"] = 			{ class = "ROGUE", level = 15, },
	["Recuperate"] = 			{ class = "ROGUE", level = 16, },
	["Kick"] = 					{ class = "ROGUE", level = 18, },
	["Crippling Poison"] = 		{ class = "ROGUE", level = 20, },
	["Gouge"] = 				{ class = "ROGUE", level = 22, },
	["Pick Lock"] = 			{ class = "ROGUE", level = 24, },
	["Sprint"] = 				{ class = "ROGUE", level = 26, },
	["Distract"] = 				{ class = "ROGUE", level = 28, },
	["Mind-numbing Poison"] = 	{ class = "ROGUE", level = 28, },
	["Cheap Shot"] = 			{ class = "ROGUE", level = 30, },
	["Wound Poison"] = 			{ class = "ROGUE", level = 30, },
	["Swiftblade's Cunning"] =	{ class = "ROGUE", level = 30, },
	["Vanish"] = 				{ class = "ROGUE", level = 34, },
	["Expose Armor"] = 			{ class = "ROGUE", level = 36, },
	["Blind"] = 				{ class = "ROGUE", level = 38, },
	["Kidney Shot"] = 			{ class = "ROGUE", level = 40, },
	["Detect Traps"] = 			{ class = "ROGUE", level = 42, },
	["Feint"] = 				{ class = "ROGUE", level = 44, },
	["Rupture"] = 				{ class = "ROGUE", level = 46, },
	["Garrote"] = 				{ class = "ROGUE", level = 48, },
	["Safe Fall"] = 			{ class = "ROGUE", level = 48, },
--	["Leather Specialization"] = { class = "ROGUE", level = 50, },
	["Dismantle"] = 			{ class = "ROGUE", level = 52, },
	["Relentless Strikes"] = 	{ class = "ROGUE", level = 54, },
	["Disarm Trap"] = 			{ class = "ROGUE", level = 56, },
	["Cloak of Shadows"] = 		{ class = "ROGUE", level = 58, },
	["Fleet Footed"] = 			{ class = "ROGUE", level = 62, },
	["Master Poisoner"] = 		{ class = "ROGUE", level = 64, },
	["Fan of Knives"] = 		{ class = "ROGUE", level = 66, },
	["Preparation"] = 			{ class = "ROGUE", level = 68, },
	["Shadow Walk"] = 			{ class = "ROGUE", level = 72, },
	["Shiv"] = 					{ class = "ROGUE", level = 74, },
--	["Shroud of Concealment"] = { class = "ROGUE", level = 76, },
	["Tricks of the Trade"] = 	{ class = "ROGUE", level = 78, },
	["Redirect"] = 				{ class = "ROGUE", level = 81, },
	["Crimson Tempest"] = 		{ class = "ROGUE", level = 83, },
	["Smoke Bomb"] = 			{ class = "ROGUE", level = 85, },
	["Shadow Blades"] = 		{ class = "ROGUE", level = 87, },
	--++ Glyph Abilities ++
	["Detection"] = 			{ class = "ROGUE", level = 25, },	
--++ Rogue Specialization ++
	--++ Assassination ++  
	["Assassin's Resolve"] = 	{ class = "ROGUE", level = 10, },
	["Improved Poisons"] = 		{ class = "ROGUE", level = 10, },
	["Mutilate"] = 				{ class = "ROGUE", level = 10, },
	["Envenom"] = 				{ class = "ROGUE", level = 20, },
	["Seal Fate"] = 			{ class = "ROGUE", level = 30, },
	["Dispatch"] = 				{ class = "ROGUE", level = 40, },
	["Venomous Wounds"] = 		{ class = "ROGUE", level = 50, },
	["Cut to the Chase"] = 		{ class = "ROGUE", level = 60, },
	["Blindside"] = 			{ class = "ROGUE", level = 70, },
	["Vendetta"] = 				{ class = "ROGUE", level = 80, },
	["Potent Poisons"] = 		{ class = "ROGUE", level = 80, },
	--++ Combat ++  
	["Ambidexterity"] = 		{ class = "ROGUE", level = 10, },
	["Vitality"] = 				{ class = "ROGUE", level = 10, },
	["Blade Flurry"] = 			{ class = "ROGUE", level = 10, },
	["Revealing Strike"] = 		{ class = "ROGUE", level = 20, },
	["Combat Potency"] = 		{ class = "ROGUE", level = 30, },
	["Ruthlessness"] = 			{ class = "ROGUE", level = 32, }, -- Added in Patch 5.4
	["Adrenaline Rush"] = 		{ class = "ROGUE", level = 40, },
	["Restless Blades"] = 		{ class = "ROGUE", level = 50, },
	["Bandit's Guile"] = 		{ class = "ROGUE", level = 60, },
	["Killing Spree"] = 		{ class = "ROGUE", level = 80, },
	["Main Gauche"] = 			{ class = "ROGUE", level = 80, },
	--++ Subtlety ++
	["Hemorrhage"] = 			{ class = "ROGUE", level = 10, },
	["Master of Subtlety"] = 	{ class = "ROGUE", level = 10, },
	["Sinister Calling"] = 		{ class = "ROGUE", level = 10, },
	["Find Weakness"] = 		{ class = "ROGUE", level = 20, },
	["Premeditation"] = 		{ class = "ROGUE", level = 30, },
	["Backstab"] = 				{ class = "ROGUE", level = 40, },
	["Honor Among Thieves"] = 	{ class = "ROGUE", level = 50, },
	["Sanguinary Vein"] = 		{ class = "ROGUE", level = 60, },
	["Energetic Recovery"] = 	{ class = "ROGUE", level = 70, },
	["Shadow Dance"] = 			{ class = "ROGUE", level = 80, },
	["Executioner"] = 			{ class = "ROGUE", level = 80, }, 
--++ Rogue Talents ++
	["Nightstalker"] = 			{ class = "ROGUE", level = 15, },
	["Subterfuge"] = 			{ class = "ROGUE", level = 15, },
	["Shadow Focus"] = 			{ class = "ROGUE", level = 15, },
	["Deadly Throw"] = 			{ class = "ROGUE", level = 30, },
	["Nerve Strike"] = 			{ class = "ROGUE", level = 30, },
	["Combat Readiness"] = 		{ class = "ROGUE", level = 30, }, 
	["Cheat Death"] = 			{ class = "ROGUE", level = 45, },
	["Leeching Poison"] = 		{ class = "ROGUE", level = 45, },
	["Elusiveness"] = 			{ class = "ROGUE", level = 45, }, 
	["Shadowstep"] = 			{ class = "ROGUE", level = 60, },
	["Burst of Speed"] = 		{ class = "ROGUE", level = 60, }, 
	["Cloak and Dagger"] = 		{ class = "ROGUE", level = 60, }, 
	["Prey on the Weak"] = 		{ class = "ROGUE", level = 75, },
	["Paralytic Poison"] = 		{ class = "ROGUE", level = 75, },
	["Dirty Tricks"] = 			{ class = "ROGUE", level = 75, }, 
	["Shuriken Toss"] = 		{ class = "ROGUE", level = 90, },
--  ["Versatility"] = 			{ class = "ROGUE", level = 90, }, --Removed in Patch 5.2
	["Marked for Death"] =		{ class = "ROGUE", level = 90, },
	["Anticipation"] = 			{ class = "ROGUE", level = 90, },

--++ Shaman Abilities ++
	["Lightning Bolt"] = 		{ class = "SHAMAN", level = 1, },
	["Primal Strike"] = 		{ class = "SHAMAN", level = 3, },
	["Earth Shock"] = 			{ class = "SHAMAN", level = 6, },
	["Healing Surge"] = 		{ class = "SHAMAN", level = 7, },
	["Lightning Shield"] = 		{ class = "SHAMAN", level = 8, },
	["Flametongue Weapon"] = 	{ class = "SHAMAN", level = 10, },
	["Flame Shock"] = 			{ class = "SHAMAN", level = 12, },
	["Purge"] = 				{ class = "SHAMAN", level = 12, },
	["Ancestral Spirit"] = 		{ class = "SHAMAN", level = 14, },
	["Ghost Wolf"] = 			{ class = "SHAMAN", level = 15, },
	["Searing Totem"] = 		{ class = "SHAMAN", level = 16, },
	["Wind Shear"] = 			{ class = "SHAMAN", level = 16, },
	["Cleanse Spirit"] = 		{ class = "SHAMAN", level = 18, },
	["Water Shield"] = 			{ class = "SHAMAN", level = 20, },
	["Frost Shock"] = 			{ class = "SHAMAN", level = 22, },
	["Water Walking"] = 		{ class = "SHAMAN", level = 24, },
	["Earthbind Totem"] = 		{ class = "SHAMAN", level = 26, },
	["Chain Lightning"] = 		{ class = "SHAMAN", level = 28, },
	["Healing Stream Totem"] = 	{ class = "SHAMAN", level = 30, }, --Removed in Patch 5.4 ??
--	["Rushing Streams"] = 		{ class = "SHAMAN", level = 30, }, --Added in Patch 5.4 ??
	["Totemic Recall"] = 		{ class = "SHAMAN", level = 30, },
	["Reincarnation"] = 		{ class = "SHAMAN", level = 32, },
	["Astral Recall"] = 		{ class = "SHAMAN", level = 34, },
	["Far Sight"] = 			{ class = "SHAMAN", level = 36, },
	["Magma Totem"] = 			{ class = "SHAMAN", level = 36, },
	["Grounding Totem"] = 		{ class = "SHAMAN", level = 38, },
	["Burning Wrath"] = 		{ class = "SHAMAN", level = 40, },
	["Chain Heal"] = 			{ class = "SHAMAN", level = 44, },
	["Frostbrand Weapon"] = 	{ class = "SHAMAN", level = 46, },
--	["Mail Specialization"] = 	{ class = "SHAMAN", level = 50, },
	["Tremor Totem"] = 			{ class = "SHAMAN", level = 54, },
	["Earth Elemental Totem"] = { class = "SHAMAN", level = 58, },
	["Healing Rain"] = 			{ class = "SHAMAN", level = 60, },
	["Capacitor Totem"] = 		{ class = "SHAMAN", level = 63, },
	["Healing Tide Totem"] = 	{ class = "SHAMAN", level = 65, }, --++
	["Fire Elemental Totem"] = 	{ class = "SHAMAN", level = 66, },
	["Heroism"] = 				{ class = "SHAMAN", level = 70, },
	["Bloodlust"] = 			{ class = "SHAMAN", level = 70, },
	["Bind Elemental"] = 		{ class = "SHAMAN", level = 72, },
	["Hex"] = 					{ class = "SHAMAN", level = 75, },
	["Rockbiter Weapon"] = 		{ class = "SHAMAN", level = 75, },
	["Stormlash Totem"] = 		{ class = "SHAMAN", level = 78, },
	["Grace of Air"] = 			{ class = "SHAMAN", level = 80, },
	["Unleash Elements"] = 		{ class = "SHAMAN", level = 81, },
	["Spiritwalker's Grace"] = 	{ class = "SHAMAN", level = 85, },
	["Ascendance"] = 			{ class = "SHAMAN", level = 87, },
--++ Shaman Specialization ++
	--++ Elemental/Restoration ++ 
	["Spiritual Insight"] = 	{ class = "SHAMAN", level = 10, },
	["Lava Burst"] = 			{ class = "SHAMAN", level = 34, },
	--++ Elemental/Enhancement ++
	["Shamanistic Rage"] = 		{ class = "SHAMAN", level = 65, },	
	--++ Elemental ++ 
	["Elemental Fury"] = 		{ class = "SHAMAN", level = 10, },
	["Elemental Precision"] = 	{ class = "SHAMAN", level = 10, },
	["Elemental Reach"] = 		{ class = "SHAMAN", level = 10, },
	["Shamanism"] = 			{ class = "SHAMAN", level = 10, },
	["Thunderstorm"] = 			{ class = "SHAMAN", level = 10, },
	["Rolling Thunder"] = 		{ class = "SHAMAN", level = 20, },
	["Fulmination"] = 			{ class = "SHAMAN", level = 20, }, --changed
	["Elemental Focus"] = 		{ class = "SHAMAN", level = 40, },
	["Lava Surge"] = 			{ class = "SHAMAN", level = 50, },
	["Elemental Oath"] = 		{ class = "SHAMAN", level = 55, },
	["Earthquake"] = 			{ class = "SHAMAN", level = 60, },
	["Elemental Overload"] = 	{ class = "SHAMAN", level = 80, },
	--++ Enhancement ++
	["Lava Lash"] = 			{ class = "SHAMAN", level = 10, },
	["Mental Quickness"] = 		{ class = "SHAMAN", level = 10, },
	["Primal Wisdom"] = 		{ class = "SHAMAN", level = 10, }, --++
	["Flurry"] = 				{ class = "SHAMAN", level = 20, },
	["Stormstrike"] = 			{ class = "SHAMAN", level = 26, },
	["Windfury Weapon"] = 		{ class = "SHAMAN", level = 30, },
	["Searing Flames"] = 		{ class = "SHAMAN", level = 34, },
	["Static Shock"] = 			{ class = "SHAMAN", level = 40, },
	["Fire Nova"] = 			{ class = "SHAMAN", level = 44, },
	["Maelstrom Weapon"] = 		{ class = "SHAMAN", level = 50, },
	["Unleashed Rage"] = 		{ class = "SHAMAN", level = 55, },
	["Feral Spirit"] = 			{ class = "SHAMAN", level = 60, },
	["Spirit Walk"] = 			{ class = "SHAMAN", level = 60, },
	["Enhanced Elements"] = 	{ class = "SHAMAN", level = 80, },
	--++ Restoration ++
	["Meditation"] = 			{ class = "SHAMAN", level = 10, },
	["Purification"] = 			{ class = "SHAMAN", level = 10, },
	["Riptide"] = 				{ class = "SHAMAN", level = 10, },
	["Purify Spirit"] = 		{ class = "SHAMAN", level = 18, },	--++
	["Healing Wave"] = 			{ class = "SHAMAN", level = 20, },
	["Earth Shield"] = 			{ class = "SHAMAN", level = 26, },
	["Earthliving Weapon"] = 	{ class = "SHAMAN", level = 30, },
	["Ancestral Awakening"] = 	{ class = "SHAMAN", level = 34, },
	["Resurgence"] = 			{ class = "SHAMAN", level = 40, },
	["Tidal Waves"] = 			{ class = "SHAMAN", level = 50, },
	["Mana Tide Totem"] = 		{ class = "SHAMAN", level = 56, },
	["Greater Healing Wave"] = 	{ class = "SHAMAN", level = 60, },
	["Spirit Link Totem"] = 	{ class = "SHAMAN", level = 70, },
	["Deep Healing"] = 			{ class = "SHAMAN", level = 80, }, 
--++ Shaman Talents ++
	["Nature's Guardian"] = 	{ class = "SHAMAN", level = 15, },
	["Stone Bulwark Totem"] = 	{ class = "SHAMAN", level = 15, },
	["Astral Shift"] = 			{ class = "SHAMAN", level = 15, }, 
	["Frozen Power"] = 			{ class = "SHAMAN", level = 30, },
	["Earthgrab Totem"] = 		{ class = "SHAMAN", level = 30, },
	["Windwalk Totem"] = 		{ class = "SHAMAN", level = 30, }, 
	["Call of the Elements"] = 	{ class = "SHAMAN", level = 45, },
--	["Totemic Restoration"] = 	{ class = "SHAMAN", level = 45, }, --Removed in Patch 5.4
	["Totemic Persistence"] = 	{ class = "SHAMAN", level = 45, }, --Added in Patch 5.4
	["Totemic Projection"] = 	{ class = "SHAMAN", level = 45, }, 
	["Elemental Mastery"] = 	{ class = "SHAMAN", level = 60, },
	["Ancestral Swiftness"] = 	{ class = "SHAMAN", level = 60, },
	["Echo of the Elements"] = 	{ class = "SHAMAN", level = 60, }, 
	["Rushing Streams"] = 		{ class = "SHAMAN", level = 75, }, --changed
	["Ancestral Guidance"] = 	{ class = "SHAMAN", level = 75, },
	["Conductivity"] = 			{ class = "SHAMAN", level = 75, }, 
	["Unleashed Fury"] = 		{ class = "SHAMAN", level = 90, },
	["Primal Elementalist"] = 	{ class = "SHAMAN", level = 90, },
	["Elemental Blast"] = 		{ class = "SHAMAN", level = 90, },

--++ Warlock Abilities ++
	["Shadow Bolt"] = 			{ class = "WARLOCK", level = 1, },
	["Demonic Slash"] = 		{ class = "WARLOCK", level = 1, }, -- Dark Apotheosis Ability
	["Siphon Life"] = 			{ class = "WARLOCK", level = 1, }, --++
	["Summon Imp"] = 			{ class = "WARLOCK", level = 1, },
	["Corruption"] = 			{ class = "WARLOCK", level = 3, },
	["Drain Life"] = 			{ class = "WARLOCK", level = 7, },
	["Summon Voidwalker"] = 	{ class = "WARLOCK", level = 8, },
	["Create Healthstone"] = 	{ class = "WARLOCK", level = 9, },
	["Control Demon"] = 		{ class = "WARLOCK", level = 10, },
	["Health Funnel"] = 		{ class = "WARLOCK", level = 11, },
	["Fear"] = 					{ class = "WARLOCK", level = 14, },
	["Sleep"] = 				{ class = "WARLOCK", level = 14, }, -- Dark Apotheosis Ability
	["Life Tap"] = 				{ class = "WARLOCK", level = 16, },
	["Curse of Enfeeblement"] = { class = "WARLOCK", level = 17, },
	["Soulstone"] = 			{ class = "WARLOCK", level = 18, },
	["Summon Succubus"] = 		{ class = "WARLOCK", level = 20, },
	["Eye of Kilrogg"] = 		{ class = "WARLOCK", level = 22, },
	["Unending Breath"] = 		{ class = "WARLOCK", level = 24, },
	["Soul Harvest"] = 			{ class = "WARLOCK", level = 27, },
	["Summon Felhunter"] = 		{ class = "WARLOCK", level = 29, },
	["Howl of Terror"] = 		{ class = "WARLOCK", level = 30, }, --Added in Patch 5.4 
	["Enslave Demon"] = 		{ class = "WARLOCK", level = 31, },
	["Banish"] = 				{ class = "WARLOCK", level = 32, },
	["Twilight Ward"] = 		{ class = "WARLOCK", level = 34, },
	["Fury Ward"] = 			{ class = "WARLOCK", level = 34, }, -- Dark Apotheosis Ability
	["Fel Armor"] = 			{ class = "WARLOCK", level = 38, },
	["Ritual of Summoning"] = 	{ class = "WARLOCK", level = 42, },
	["Summon Infernal"] = 		{ class = "WARLOCK", level = 49, },
	["Nethermancy"] = 			{ class = "WARLOCK", level = 50, },
	["Curse of the Elements"] = { class = "WARLOCK", level = 51, },
	["Command Demon"] = 		{ class = "WARLOCK", level = 56, },
	["Summon Doomguard"] = 		{ class = "WARLOCK", level = 58, },
	["Unending Resolve"] = 		{ class = "WARLOCK", level = 64, },
	["Soulshatter"] = 			{ class = "WARLOCK", level = 66, },
	["Provocation"] = 			{ class = "WARLOCK", level = 66, }, -- Dark Apotheosis Ability
	["Create Soulwell"] = 		{ class = "WARLOCK", level = 68, },
	["Demonic Circle: Summon"] = { class = "WARLOCK", level = 76, },
	["Demonic Circle: Teleport"] = { class = "WARLOCK", level = 76, },
	["Fel Flame"] = 			{ class = "WARLOCK", level = 77, },
	["Dark Intent"] = 			{ class = "WARLOCK", level = 82, },
	["Demonic Gateway"] = 		{ class = "WARLOCK", level = 87, },
	["Pandemic"] = 				{ class = "WARLOCK", level = 90, }, 
	--++ Glyph Abilities ++
	["Dark Apotheosis"] = 		{ class = "WARLOCK", level = 25, },
	["Imp Swarm"] = 			{ class = "WARLOCK", level = 25, },
--++ Warlock Specialization ++
	--++ Affliction/Destruction ++
	["Rain of Fire"] = 			{ class = "WARLOCK", level = 21, },
	--++ Affliction ++
	["Unstable Affliction"] = 	{ class = "WARLOCK", level = 10, },
	["Drain Soul"] = 			{ class = "WARLOCK", level = 19, },
	["Soulburn"] = 				{ class = "WARLOCK", level = 19, },
	["Soulburn: Health Funnel"] = { class = "WARLOCK", level = 27, },
	["Curse of Exhaustion"] = 	{ class = "WARLOCK", level = 32, },
	["Agony"] = 				{ class = "WARLOCK", level = 36, },
	["Malefic Grasp"] = 		{ class = "WARLOCK", level = 42, },
	["Nightfall"] = 			{ class = "WARLOCK", level = 54, },
	["Seed of Corruption"] = 	{ class = "WARLOCK", level = 60, },
	["Haunt"] = 				{ class = "WARLOCK", level = 62, },
	["Soulburn: Seed of Corruption"] = { class = "WARLOCK", level = 62, },
	["Improved Fear"] = 		{ class = "WARLOCK", level = 69, },
	["Soulburn: Curse"] = 		{ class = "WARLOCK", level = 73, },
	["Soul Swap"] = 			{ class = "WARLOCK", level = 79, },
	["Soulburn: Soul Swap"] = 	{ class = "WARLOCK", level = 79, },	--++
	["Potent Afflictions"] = 	{ class = "WARLOCK", level = 80, },
	["Dark Soul: Misery"] = 	{ class = "WARLOCK", level = 84, },
	["Soulburn: Demonic Circle: Teleport"] = { class = "WARLOCK", level = 86, },
	--++ Demonology ++
	["Demonic Fury"] = 			{ class = "WARLOCK", level = 10, },
	["Metamorphosis"] = 		{ class = "WARLOCK", level = 10, },
	["Demonic Leap"] = 			{ class = "WARLOCK", level = 12, },
	["Soul Fire"] = 			{ class = "WARLOCK", level = 13, },
	["Hand of Gul'dan"] = 		{ class = "WARLOCK", level = 19, },
	["Hellfire"] = 				{ class = "WARLOCK", level = 22, },
	["Metamorphosis: Touch of Chaos"] = { class = "WARLOCK", level = 25, }, --changed
	["Nether Plating"] = 		{ class = "WARLOCK", level = 27, },
	["Wild Imps"] = 			{ class = "WARLOCK", level = 32, },
	["Metamorphosis: Doom"] = 	{ class = "WARLOCK", level = 36, }, --changed
	["Summon Felguard"] = 		{ class = "WARLOCK", level = 42, },
	["Carrion Swarm"] = 		{ class = "WARLOCK", level = 47, },
	["Demonic Rebirth"] = 		{ class = "WARLOCK", level = 54, },
	["Metamorphosis: Immolation Aura"] = { class = "WARLOCK", level = 62, }, --changed
	["Metamorphosis: Cursed Auras"] = { class = "WARLOCK", level = 67, }, --changed
	["Molten Core"] = 			{ class = "WARLOCK", level = 69, },
	["Decimation"] = 			{ class = "WARLOCK", level = 73, },
	["Metamorphosis: Chaos Wave"] = { class = "WARLOCK", level = 79, },
	["Master Demonologist"] = 	{ class = "WARLOCK", level = 80, },
	["Dark Soul: Knowledge"] = 	{ class = "WARLOCK", level = 84, },
	["Metamorphosis: Void Ray"] = { class = "WARLOCK", level = 85, }, --changed
	--++ Destruction ++
	["Chaotic Energy"] = 		{ class = "WARLOCK", level = 10, },
	["Conflagrate"] = 			{ class = "WARLOCK", level = 10, },
	["Incinerate"] = 			{ class = "WARLOCK", level = 10, },
	["Immolate"] = 				{ class = "WARLOCK", level = 12, },
	["Backlash"] = 				{ class = "WARLOCK", level = 32, },
	["Havoc"] = 				{ class = "WARLOCK", level = 36, },
	["Chaos Bolt"] = 			{ class = "WARLOCK", level = 42, },
	["Ember Tap"] = 			{ class = "WARLOCK", level = 42, },
	["Burning Embers"] = 		{ class = "WARLOCK", level = 42, },
	["Shadowburn"] = 			{ class = "WARLOCK", level = 47, },
	["Fire and Brimstone"] = 	{ class = "WARLOCK", level = 54, },
	["Aftermath"] = 			{ class = "WARLOCK", level = 54, },
	["Backdraft"] = 			{ class = "WARLOCK", level = 69, },
	["Flames of Xoroth"] = 		{ class = "WARLOCK", level = 79, },
	["Emberstorm"] = 			{ class = "WARLOCK", level = 80, },
	["Dark Soul: Instability"] = { class = "WARLOCK", level = 84, },
	["Pyroclasm"] = 			{ class = "WARLOCK", level = 86, },
--++ Warlock Talents ++
	["Dark Regeneration"] = 	{ class = "WARLOCK", level = 15, },
	["Soul Leech"] = 			{ class = "WARLOCK", level = 15, },
	["Harvest Life"] = 			{ class = "WARLOCK", level = 15, }, 
--	["Howl of Terror"] = 		{ class = "WARLOCK", level = 30, }, --Removed in Patch 5.4
	["Demonic Breath"] = 		{ class = "WARLOCK", level = 30, }, --Added in Patch 5.4
	["Mortal Coil"] = 			{ class = "WARLOCK", level = 30, },
	["Shadowfury"] = 			{ class = "WARLOCK", level = 30, }, 
	["Soul Link"] = 			{ class = "WARLOCK", level = 45, },
	["Sacrificial Pact"] = 		{ class = "WARLOCK", level = 45, },
	["Dark Bargain"] = 			{ class = "WARLOCK", level = 45, }, 
	["Blood Horror"] = 			{ class = "WARLOCK", level = 60, }, --changed
	["Burning Rush"] = 			{ class = "WARLOCK", level = 60, },
	["Unbound Will"] = 			{ class = "WARLOCK", level = 60, }, 
	["Grimoire of Supremacy"] = { class = "WARLOCK", level = 75, },
	["Grimoire of Service"] = 	{ class = "WARLOCK", level = 75, },
	["Grimoire of Sacrifice"] = { class = "WARLOCK", level = 75, }, 
--	["Archimonde's Vengeance"] = { class = "WARLOCK", level = 90, }, --Removed in Patch 5.4
	["Archimonde's Darkness"] = { class = "WARLOCK", level = 90, }, --Removed in Patch 5.4
	["Kil'jaeden's Cunning"] = 	{ class = "WARLOCK", level = 90, },
	["Mannoroth's Fury"] = 		{ class = "WARLOCK", level = 90, }, 

--++ Warrior Abilities ++
	["Battle Stance"] = 		{ class = "WARRIOR", level = 1, },
	["Heroic Strike"] = 		{ class = "WARRIOR", level = 1, },
	["Charge"] = 				{ class = "WARRIOR", level = 3, },
	["Victory Rush"] = 			{ class = "WARRIOR", level = 5, },
	["Execute"] = 				{ class = "WARRIOR", level = 7, },
	["Defensive Stance"] = 		{ class = "WARRIOR", level = 9, },
	["Taunt"] = 				{ class = "WARRIOR", level = 12, },
	["Enrage"] = 				{ class = "WARRIOR", level = 14, },
	["Sunder Armor"] = 			{ class = "WARRIOR", level = 16, },
	["Thunder Clap"] = 			{ class = "WARRIOR", level = 20, },
	["Heroic Throw"] = 			{ class = "WARRIOR", level = 22, },
	["Pummel"] = 				{ class = "WARRIOR", level = 24, },
	["Disarm"] = 				{ class = "WARRIOR", level = 28, },
	["Deep Wounds"] = 			{ class = "WARRIOR", level = 32, },
	["Berserker Stance"] = 		{ class = "WARRIOR", level = 34, },
	["Hamstring"] = 			{ class = "WARRIOR", level = 36, },
	["Battle Shout"] = 			{ class = "WARRIOR", level = 42, },
	["Cleave"] = 				{ class = "WARRIOR", level = 44, },
	["Shield Wall"] = 			{ class = "WARRIOR", level = 48, },
--	["Plate Specialization"] = 	{ class = "WARRIOR", level = 50, },
	["Intimidating Shout"] = 	{ class = "WARRIOR", level = 52, },
	["Berserker Rage"] = 		{ class = "WARRIOR", level = 54, },
	["Recklessness"] = 			{ class = "WARRIOR", level = 62, },
--	["Deadly Calm"] = 			{ class = "WARRIOR", level = 62, },  --removed
	["Spell Reflection"] = 		{ class = "WARRIOR", level = 66, },
	["Commanding Shout"] = 		{ class = "WARRIOR", level = 68, },
	["Intervene"] = 			{ class = "WARRIOR", level = 72, },
	["Shattering Throw"] = 		{ class = "WARRIOR", level = 74, },
--	["Ripsote"] = 				{ class = "WARRIOR", level = 76, }, --Added in Patch 5.4 but not activated since Death Knights also have this ability
	["Rallying Cry"] = 			{ class = "WARRIOR", level = 83, },
	["Heroic Leap"] = 			{ class = "WARRIOR", level = 85, },
	["Demoralizing Banner"] = 	{ class = "WARRIOR", level = 87, },
	["Mocking Banner"] = 		{ class = "WARRIOR", level = 87, },
	["Skull Banner"] = 			{ class = "WARRIOR", level = 87, },
--	["War Banner"] = 			{ class = "WARRIOR", level = 87, }, --removed
--++ Warrior Specialization ++
	--++ Arms/Fury ++
	["Whirlwind"] = 			{ class = "WARRIOR", level = 26, },
	["Die by the Sword"] = 		{ class = "WARRIOR", level = 56, },
	["Unbridled Wrath"] = 		{ class = "WARRIOR", level = 56, }, --++
	["Colossus Smash"] = 		{ class = "WARRIOR", level = 81, },
	--++ Arms/Protection ++	
	["Blood and Thunder"] = 	{ class = "WARRIOR", level = 46, },
	--++ Arms ++
	["Mortal Strike"] = 		{ class = "WARRIOR", level = 10, },
	["Seasoned Soldier"] = 		{ class = "WARRIOR", level = 10, },
	["Slam"] = 					{ class = "WARRIOR", level = 18, },
	["Overpower"] = 			{ class = "WARRIOR", level = 30, },
	["Taste for Blood"] = 		{ class = "WARRIOR", level = 30, },
	["Sweeping Strikes"] = 		{ class = "WARRIOR", level = 60, },
	["Strikes of Opportunity"] = { class = "WARRIOR", level = 80, },
	["Sudden Death"] = 			{ class = "WARRIOR", level = 81, },
	--++ Fury ++
	["Bloodthirst"] = 			{ class = "WARRIOR", level = 10, },
	["Crazed Berserker"] = 		{ class = "WARRIOR", level = 10, },
	["Wild Strike"] = 			{ class = "WARRIOR", level = 18, },
	["Raging Blow"] = 			{ class = "WARRIOR", level = 30, },
	["Titan's Grip"] = 			{ class = "WARRIOR", level = 38, },
	["Single-Minded Fury"] = 	{ class = "WARRIOR", level = 38, },
	["Bloodsurge"] = 			{ class = "WARRIOR", level = 50, },
	["Meat Cleaver"] = 			{ class = "WARRIOR", level = 58, },
	["Flurry"] = 				{ class = "WARRIOR", level = 60, },
	["Unshackled Fury"] = 		{ class = "WARRIOR", level = 80, },
	--++ Protection ++  
	["Shield Slam"] = 			{ class = "WARRIOR", level = 10, },
	["Unwavering Sentinel"] = 	{ class = "WARRIOR", level = 10, },
	["Vengeance"] = 			{ class = "WARRIOR", level = 10, },
	["Shield Block"] = 			{ class = "WARRIOR", level = 18, },
	["Devastate"] = 			{ class = "WARRIOR", level = 26, },
	["Revenge"] = 				{ class = "WARRIOR", level = 30, },
	["Last Stand"] = 			{ class = "WARRIOR", level = 38, },
--	["Plate Specialization"] = 	{ class = "WARRIOR", level = 50, },
	["Sword and Board"] = 		{ class = "WARRIOR", level = 50, },
	["Demoralizing Shout"] = 	{ class = "WARRIOR", level = 56, },
	["Ultimatum"] = 			{ class = "WARRIOR", level = 58, },
	["Bastion of Defense"] = 	{ class = "WARRIOR", level = 60, },
	["Critical Block"] = 		{ class = "WARRIOR", level = 80, },
	["Shield Barrier"] = 		{ class = "WARRIOR", level = 81, },
	--++ Warrior Talents ++
	["Juggernaut"] = 			{ class = "WARRIOR", level = 15, },
	["Double Time"] = 			{ class = "WARRIOR", level = 15, },
	["Warbringer"] = 			{ class = "WARRIOR", level = 15, }, 
	["Enraged Regeneration"] = 	{ class = "WARRIOR", level = 30, },
	["Second Wind"] = 			{ class = "WARRIOR", level = 30, },
	["Impending Victory"] = 	{ class = "WARRIOR", level = 30, }, 
	["Staggering Shout"] = 		{ class = "WARRIOR", level = 45, },
	["Piercing Howl"] = 		{ class = "WARRIOR", level = 45, },
	["Disrupting Shout"] = 		{ class = "WARRIOR", level = 45, },
	["Bladestorm"] = 			{ class = "WARRIOR", level = 60, },
	["Shockwave"] = 			{ class = "WARRIOR", level = 60, },
	["Dragon Roar"] = 			{ class = "WARRIOR", level = 60, }, 
	["Mass Spell Reflection"] = { class = "WARRIOR", level = 75, },
	["Safeguard"] = 			{ class = "WARRIOR", level = 75, },
	["Vigilance"] = 			{ class = "WARRIOR", level = 75, }, 
	["Avatar"] = 				{ class = "WARRIOR", level = 90, },
	["Bloodbath"] = 			{ class = "WARRIOR", level = 90, },
	["Storm Bolt"] = 			{ class = "WARRIOR", level = 90, }, 
};
