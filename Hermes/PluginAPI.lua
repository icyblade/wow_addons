------------------------------------------------------------------------
-- Plugin and Event API Documentation Overview
------------------------------------------------------------------------
--[[

A Hermes plugin is created by utilizing the Plugin API and Events desctibed in this document.

Plugins provide the following benefits that Events alone do not:
    * Plugins are automatically enabled and disabled by Hermes as needed.
    * Plugins are listed in the "Registered Plugins" section of Hermes' configuration tabs, where users can enable and disable them completely.
    * Plugin profile db (if specified) can be managed by Hermes.
    * Plugin configuration windows (AceConfigDialog) can be displayed within Hermes configuration windows. A separate tab gets created for each plugin configured to support it. 

The main advantage of plugin are how it allows a user to configure them from Hermes without having to dig for
other options somewhere else. If none of these features seem useful to you, then there's no need to create a plugin.

For a complex example of a plugin, take a look at DefaultUI\DefaultUI.lua

For very simple example, take a look at any of these plugins on curse:
	http://wow.curse.com/downloads/wow-addons/details/hermes_miksbt.aspx
	http://wow.curse.com/downloads/wow-addons/details/hermes_parrot.aspx
	http://wow.curse.com/downloads/wow-addons/details/hermes_sct.aspx

]]--


------------------------------------------------------------------------
-- HERMES TABLE DESCRIPTIONS
------------------------------------------------------------------------
--[[ sender
Desription: Contains information about a sender.

** You should never modify these values.

sender = {
	name		--the name of the sender
	class		--the class of the sender (e.g. "WARRIOR")
	online		--true if the sender is online, otherwise false
	dead		--true if the sender is dead, otherwise false
	virtual		--1 if this sender is not running Hermes (but Spell Monitor picked it up), otherwise nil.
	visible		--1 if the sender is in the player's area of interest, otherwise nil.
}
	
]]--

--[[ ability
Desription: Contains information about an ability. An ability is either a spell or an item.

** You should never modify these values.

ability = {
	id			--the Hermes id for the ability (for spells it will be the spell id, for items it will be the item id multiplied by negative 1)
	name		--the name of the ability
	class		--the class that this ability requires (e.g. "WARRIOR", "ANY")
	icon		--the icon texture representing this ability.
}
	
]]--

--[[ instance
Desription: Contains information about an instance of an ability. An instance is the association of a sender to an ability, and the status for that ability/sender.

** You should never modify these values.

instance = {
	ability		--a direct reference to the the ability that this is an instance for.
	sender		--a direct reference to the sender who owns this instance.
	remaining	--the amount of time currently remaining before this instance goes off cooldown, or nil if it's available.
}
		
]]--


------------------------------------------------------------------------
-- HERMES EVENTS
------------------------------------------------------------------------
--[[ OnStartSending()
Description: Fired everytime Hermes begins Sending. This can happen for various reasons including users
enabling a disabled Plugin, converting from a Party to a Raid (or vice-versa), and a few other situations.
]]--

--[[ OnStopSending()
Description: Fired everytime Hermes stops Sending.
]]--

--[[ OnStartReceiving()
Description: Fired everytime Hermes begins Receiving. This can happen for various reasons including users
enabling a disabled Plugin, converting from a Party to a Raid (or vice-versa), and a few other situations.
]]--

--[[ OnStopReceiving()
Description: Fired everytime Hermes stops Receiving.
]]--

--[[ OnSenderAdded(sender)
Description: Fired when Hermes is adding a new sender.
]]--

--[[ OnSenderRemoved(sender)
Description: Fired when Hermes is removing an existing sender.
]]--

--[[ OnSenderVisibilityChanged(sender)
Description: Fired when the visibility (range) of a sender changed.
]]--

--[[ OnSenderOnlineChanged(sender)
Description: Fired when the online status of a sender changed.
]]--

--[[ OnSenderDeadChanged(sender)
Description: Fired when a sender dies or comes back alive.
]]--

--[[ OnSenderAvailabilityChanged(sender)
Description: Fired when any of visibility, online, or dead status changes. 
]]--

--[[ OnPlayerGroupStatusChanged(isInGroup)
Description: Fired when the player's raid/party status changes.
]]--

--[[ OnAbilityAdded(ability)
Description: Fired when an ability is requested to be tracked. For example, this will get called for each
enabled ability shortly after Hermes starts receiving. Or when the user checks an ability in the config
while Hermes is already receiving.

Note that OnAbilityInstanceAdded will never fire before OnAbilityAdded.
]]--

--[[ OnAbilityRemoved(ability)
Description: Fired when an ability is no longer being tracked. For example, this will get called for each
enabled ability when Hermes is shutting down. Or when the user unchecks an ability in the config
while Hermes is receiving.

Note that OnAbilityInstanceRemoved will fire for each instance of this ability before OnAbilityRemoved is fired.
]]--

--[[ OnAbilityAvailableSendersChanged(ability)
Description: Fired when the number of available senders for this ability changes.
]]--

--[[ OnAbilityTotalSendersChanged(ability)
Description: Fired when the total number of senders for this ability changes.
]]--

--[[ OnAbilityInstanceAdded(instance)
Description: Fired when Hermes detects a sender with an ability being tracked.
]]--

--[[ OnAbilityInstanceRemoved(instance)
Description: Fired when Hermes is removing an instance of an ability, for example when it detects that
a sender is no longer in your raid. Can also be fired is an existing Sender reloads their UI (as Hermes
will drop the sender and recreate it)
]]--

--[[ OnAbilityInstanceStartCooldown(instance)
Description: Fired when Hermes detects that a sender used this ability. Note that it may not necessarily
be the full duration of the instance. For example, if a sender just logged in then it may be partially
on cooldown.
]]--

--[[ OnAbilityInstanceUpdateCooldown(instance)
Description: Fired every 0.05 seconds for an instance that has a duration greater than 0. You can
use this event to avoid the need to create your own update timers for UI animations. Or you can
choose not to register this event and create your own.
]]--

--[[ OnAbilityInstanceStopCooldown(instance)
Description: Fired when an instance was on cooldown, and just finished.
]]--

--[[ OnAbilityInstanceAvailabilityChanged(instance)
Description: Fired when Hermes detects that the sender's availability for this instance changed.
]]--

--[[ OnInventorySpellAdded(hermesid)
Description: Fired when a new spell is added to Hermes inventory
]]--

--[[ OnInventoryItemAdded(hermesid)
Description: Fired when a new item is added to Hermes inventory
]]--

--[[ OnInventorySpellRemoved(hermesid)
Description: Fired when a spell is removed from Hermes inventory
]]--

--[[ OnInventoryItemRemoved(hermesid)
Description: Fired when an item is removed from Hermes inventory
]]--

--[[ OnInventorySpellChanged(hermesid)
Description: Fired when the properties of a spell in Hermes inventory changes, such as the enabled status.
]]--

--[[ OnInventoryItemChanged(hermesid)
Description: Fired when the properties of an item in Hermes inventory changes, such as the enabled status.
]]--

------------------------------------------------------------------------
-- AVAILABLE HERMES METHODS
------------------------------------------------------------------------
--[[ Hermes:RegisterHermesEvent(event, key, handler)
Description: Registers callbacks for the specified event
Returns: nil
Parameters:
	event: The name of the Hermes event to register
	key: A unique string represting your addon/plugin. Usually the name of your addon/plugin.
	handler: The function you want Hermes to run for the event.
]]--

--[[ Hermes:UnregisterHermesEvent(event, key)
Description: Unregisters callbacks for the specified event
Returns: nil
Parameters:
	event: The name of the Hermes event to unregister
	key: The value passed during RegisterHermesEvent
]]--

--[[ Hermes:RegisterHermesPlugin(name, OnEnableCallback, OnDisableCallback, OnSetProfileCallback, OnGetBlizzOptionsTable)
Description: Registers a plugin with Hermes
Returns: nil
Parameters:
	name: A unique string representing the name of your plugin.
		The name provided is what Hermes exposes to the user in the Registered Plugins area.
		Just make sure it's unique and represents your addon correctly.
		
	OnEnableCallback(): A function to call when Hermes enables your plugin, or nil.
		Hermes will call the function your provide here when it enables your plugin.
		This will fire initially after Hermes loads, and subsequently any time
		Hermes is reset (such as the user toggling the "Enable Hermes" option in
		the main config window or the user changing profiles). It can be set to nil
		if you don't need to react to this. Typically however this is where you would
		want to initialize any objects as if your addon was starting from scratch.
		
		OnEnableCallback is always called immediately after OnSetProfileCallback.
		
		Example Code:
		function OnEnableCallback()

	OnDisableCallback():  A function to call when Hermes disabled your plugin, or nil.
		Hermes will call the function your provide here when it disables your plugin.
		This fires any time Hermes is disabled (such as the user toggling the "Enable Hermes"
		option in the main config window or the user changing profiles). It can be set
		to nil if you don't need to react to this. Typically however this is where you
		would want to reset any values and put your addon into a "fresh" state in
		preparation for another OnEnableCallback function call.
		
		Example Code:
		function OnDisableCallback()
		
	OnSetProfileCallback(dbplugins): A function to call when Hermes profile is changed, or nil.
		If you do not want Hermes to manage any Saved Variables for you, then set this to nil.
		If a valid function is provided, it will be called every time Hermes enables your plugin.
		dbplugins is the root table for all plugin options managed by Hermes. You cannot assume
		that options for your plugin exist. You should check first and potentially create
		them if needed.
		
		Example Code:
		function MyAddon:OnSetMyAddonPluginProfile(dbplugins)
			if not dbplugins[MyAddonName] then
				dbplugins[MyAddonName] = { }
			end
			dbp = dbplugins[MyAddonName]
		end

	OnGetBlizzOptionsTable(): Executed when Hermes wants your AceConfig option tables, or nil.
		Hermes calls this when it wants to load your AceConfig option table. Set to nil if
		you don't want Hermes to display a configuration tab for your plugin inside of Hermes.
		If you DO want Hermes to display configuration options, then the return value of this
		function should return a properly configured AceConfig options table. If your function
		itself returns nil, then a configuration tab will also not be displayed.
		
		Example Code:
		
		function MyAddon:GetBlizzOptionsTable()
			local options = {
				name = "MyAddon",
				type="group",
				inline = false,
				args = {
					FancyOption = {
						type = "toggle",
						name = "Some Fancy Option",
						get = function(info) return dbp.FancyOption end,
						order = 0,
						set = function(info, value) dbp.FancyOption = value end,
					},
				},
			}
			return options
		}
]]--

--[[ Hermes:IsSending()
Description: Determines if Hermes has sending enabled.
Returns: true if sending is enabled, otherwise false
Parameters: none
]]--

--[[ Hermes:IsReceiving()
Description: Determines if Hermes has receiving enabled.
Returns: true if receiving is enabled, otherwise false
Parameters: none
]]--

--[[ Hermes:IsSenderAvailable(sender)
Description: Returns the overall availabiity of the sender (online, alive, and in range).
Parameters:
	sender: The sender table passed during an OnSenderAdded or related event.
Returns: true or false
]]--

--[[ Hermes:GetPlayerStatus()
Description: returns basic information about yourself
Returns: name, class, raid, party, battleground
Parameters: none
]]--

--[[ Hermes:GetAbilityStats(ability)
Description: Returns a summary of the state of the given ability and it's instances
Returns: min_available_time, instances_total, instances_oncooldown, instances_available, instances_unavailable
	min_available_time: The shortest cooldown among all instances of the ability, or nil if they are all available.
	instances_total: The number of instances (senders) registerd with this ability.
	instances_oncooldown: The amount of instances (senders) that have this ability on cooldown.
	instances_available: The total number of available instances (senders) for this ability.
	instances_unavailable: The total number of unavailable instances (senders) for this ability.
Parameters:
	ability: The ability table passed during an OnAbilityAdded or related event.
]]--

--[[ Hermes:GetClassColorRGB(class) 
Description: Gets the color for the specified class.
	Note that Hermes internally uses a class called "ANY" and that's why this method is useful.
	If you relied on RAID_CLASS_COLORS it would cause issues with Hermes class value of "ANY".
Returns: color (an RGB table)
Parameters:
	class: class can be either a non localized Blizzard classToken (e.g. "WARRIOR", "ANY") or the enum number Hermes uses internally to represent classes.
]]--

--[[ Hermes:GetClassColorHEX(class) 
Description: Same as GetClassColorRGB but returns a hex string in the form of FFRRGGBB
]]--

--[[ Hermes:GetClassColorString(text, class) 
Description: A convenient wrapper method which calls GetClassColorHEX and then wraps the supplied text value with color.
Returns: the value of text, but surrounded with hex color tags, e.g. "|cFF44A732"..text.."|r"
]]--

--[[ Hermes:AbilityIdToBlizzId(id)
Description: Decodes Hermes ability id's to the blizzard format.
	Hermes encodes spell and item id's in order to keep addon communication simple.
	It uses positive numbers for spell id's, and negative numbers for item id's.
Returns: id, type
	id: The value representing the actual blizzard id of a Hermes ability.
	type: The type of the ability, either "spell" or "item".
Parameters: id
]]--

--[[ Hermes:ReloadBlizzPluginOptions()
Description: Causes Hermes to reload the Plugins interface tab.
	Can be useful if you require AceConfigDialog to reload your options table.
Returns: nil
Parameters: none
]]--

--[[ Hermes:GetInventoryList()
Description: Returns a table with the current spells and abilities Hermes has
	The format of each value in the table is ability[hermesid] = enabled (true or false)
	loop through it using pairs, not ipairs.
Returns: table
Parameters: none
]]--

--[[ Hermes:GetInventoryDetail(hermesid)
Description: Returns details for the given inventory item or nil if not found
Returns: hermesid, name, class, icon, enabled
Parameters: hermesid
]]--

--[[ Hermes:GetAbilityMetaDataValue(hermesid, key)
Description: Returns the value for the given hermesid and key, or nil if key doesn't exist
MetaData setup by Hermes users, and used in plugins as a way of generically associating data with a spell or ability
Returns: value or nil
Parameters: hermesid, key
]]--

