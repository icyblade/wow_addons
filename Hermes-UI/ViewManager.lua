--[[
TODO: Improve sort order to put disconnected people last for example
Note: I can probably improve the performance greatly by not trying to be intelligent about syncing up, and instead just checking if it exists in the various tables
 ]]--
local Hermes = LibStub("AceAddon-3.0"):GetAddon("Hermes")
local UI = LibStub("AceAddon-3.0"):GetAddon("Hermes-UI")
local mod = UI:NewModule("ViewManager", "AceEvent-3.0", "AceTimer-3.0")
local LIB_AceConfigDialog = LibStub("AceConfigDialog-3.0")  or error("Required library AceConfigDialog-3.0 not found")
local LIB_AceConfigRegistry = LibStub("AceConfigRegistry-3.0") or error("Required library AceConfigRegistry-3.0 not found")
local LIB_LibSharedMedia = LibStub("LibSharedMedia-3.0") or error("Required library LibSharedMedia-3.0 not found")
local L = LibStub('AceLocale-3.0'):GetLocale('Hermes-UI')

local VIEWS = {}
local VIEW_MODULES = {}
local VIEW_PROFILES = {}
local VIEW_SENDERS = {} --tracks which senders each views has access to, and also which ones they're currently accessing.
local HERMES_INVENTORY = {}
local HERMES_ABILITIES = {}
local HERMES_INSTANCES = {}
local HERMES_SENDERS = {}

local ONINSTANCE_UPDATE_CACHE = {} --Caches for views receiving onpdate calls. For performance

local DEFAULT_VIEW_MODULE = "GridButtons"
local dbp = nil
local blizzArgs = nil
local SELECTED_VIEW = nil

local DIFFICULTY_10 = {[1] = true, [3] = true}
local DIFFICULTY_25 = {[2] = true, [4] = true}

------------------------------------------------------------
-- HELPERS
------------------------------------------------------------
local function _deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

local function _findTableIndex(tbl, item)
	for index, i in ipairs(tbl) do
		if(i == item) then
			return index
		end
	end

	return nil
end

local function _deleteFromIndexedTable(tbl, item)
	local index = _findTableIndex(tbl, item) 
	if not index then error("failed to locate item in table") end
	tremove(tbl, index)
end

local function _wipeOnUpdateCache()
	wipe(ONINSTANCE_UPDATE_CACHE)
end
------------------------------------------------------------
-- HERMES_INVENTORY and related events
------------------------------------------------------------
function mod:UpdateHermesInventory()
	wipe(HERMES_INVENTORY)
	HERMES_INVENTORY = Hermes:GetInventoryList()
end

function mod:HandleHermesInventoryChanges()
	self:UpdateHermesInventory()
	self:SynchronizeViewWithInventory()
	self:UpdateOptionsTable()
	UI:BlizOptionsTable_ViewManager()
end

function mod:SynchronizeViewWithInventory(view)
	if view then
		local profile = VIEW_PROFILES[view]
		--remove abilities no longer in Hermes inventory
		local removed = {}
		for key, ability in ipairs(profile.abilities) do
			if HERMES_INVENTORY[ability.id] == nil then
				tinsert(removed, ability)
			end
		end
		
		for _, ability in ipairs(removed) do
			_deleteFromIndexedTable(profile.abilities, ability)
		end
		
		wipe(removed)
		
		--now add enabled items that aren't already in the list
		for id, enabled in pairs(HERMES_INVENTORY) do
			if enabled == true then
				--only add them if they're enabled in Hermes
				local ability, index = self:GetViewAbilityInfo(profile, id)
				if not ability then
					tinsert(profile.abilities, { id = id, enabled = false} ) --default to disabled
				end
			end
		end
		
		--clear the onupdate cache
		_wipeOnUpdateCache()
	else
		for _, v in ipairs(VIEWS) do
			self:SynchronizeViewWithInventory(v)
		end
	end
end

function mod:OnInventorySpellAdded(id)
	self:HandleHermesInventoryChanges()
end

function mod:OnInventoryItemAdded(id)
	self:HandleHermesInventoryChanges()
end

function mod:OnInventorySpellRemoved(id)
	self:HandleHermesInventoryChanges()
end

function mod:OnInventoryItemRemoved(id)
	self:HandleHermesInventoryChanges()
end

function mod:OnInventorySpellChanged(id)
	self:HandleHermesInventoryChanges()
end

function mod:OnInventoryItemChanged(id)
	self:HandleHermesInventoryChanges()
end

------------------------------------------------------------
-- ADDON
------------------------------------------------------------
function mod:RAID_ROSTER_UPDATE()
	--group might have changed
	self:UpdatePlayerData()
	self:SyncViewWithPlayerFilters()
end

function mod:OnEnable()
	for name, module in mod:IterateModules() do
		module:Enable()
	end

	SELECTED_VIEW = nil
	self:UpdateHermesInventory()
	self:CreateViews()
	self:UpdateOptionsTable()
end

function mod:OnDisable()
	--release all the views
	while #VIEWS > 0 do
		self:ReleaseView(VIEWS[1])
	end
	
	--clear the tables, they should already be empty though
	wipe(VIEWS)
	wipe(VIEW_MODULES)
	wipe(VIEW_PROFILES)
	wipe(VIEW_SENDERS)
	wipe(HERMES_INVENTORY)
	wipe(HERMES_ABILITIES)
	wipe(HERMES_INSTANCES)
	--clear the onupdate cache
	_wipeOnUpdateCache()
		
	--disable all the modules
	for name, module in mod:IterateModules() do
		module:Disable()
	end
	
	--helps catch bugs when set to nil vs. leaving it as is
	dbp = nil
	SELECTED_VIEW = nil
end

function mod:OnInitialize()
	--be default, do not enable this module
	self:SetEnabledState(false)
	LIB_LibSharedMedia.RegisterCallback(self, "LibSharedMedia_Registered", "OnLibSharedMediaUpdate") --register for media update callbacks
end

------------------------------------------------------------
-- OPTIONS
------------------------------------------------------------
function mod:GetNewViewDefaults()
	local defaults = {
		name = nil,
		module = DEFAULT_VIEW_MODULE,
		profiles = {},
		enabled = true,
		includeAll = false,
		filterself = false,
		filter10man = true,
		filter25man = true,
		filterdead = false,
		filterrange = true,
		filterconnection = true,
		filterplayertype = "disabled",
		abilities = {},
		playerfilters = {},
	}
	
	return defaults
end

function mod:SetProfile(db)
	SELECTED_VIEW = nil
	dbp = db
	
	--upgrade db for old views
	for _, dbview in ipairs(dbp.views) do
		if dbview.filterself == nil then
			dbview.filterself = false
		end
		if dbview.filter10man == nil then
			dbview.filter10man = true
		end
		if dbview.filter25man == nil then
			dbview.filter25man = true
		end
		if dbview.playerfilters == nil then
			dbview.playerfilters = {}
		end
		if dbview.filterdead == nil then
			dbview.filterdead = false
		end
		if dbview.filterrange == nil then
			dbview.filterrange = false
		end
		if dbview.filterconnection == nil then
			dbview.filterconnection = true
		end
		if dbview.filterplayertype == nil then
			dbview.filterplayertype = "disabled"
		end
	end
end

function mod:GetViewAbilityInfo(profile, id)
	for index, ability in ipairs(profile.abilities) do
		if ability.id == id then
			return ability, index
		end
	end
end

function mod:MoveSpell(abilities, value, moveup)
	--first find the index of the value in the table
	local start
	for i, v in ipairs(abilities) do
		if v == value then
			start = i
			break
		end
	end

	if not start then
		error("item not found")
	end

	--assume down
	local increment = 1
	local stop = #abilities

	if moveup then
		increment = -1
		stop = 1
	end

	local target
	for current = start + increment, stop, increment do
		--we want to move it above or below the first item in the profile list that is enabled, and which hermes is also tracking
		--local id, _, _, _, enabled = Hermes:GetInventoryDetail(abilities[current].id)
		local hermesEnabled = HERMES_INVENTORY[abilities[current].id]
		--if abilities[current].enabled == true and hermesEnabled ~= nil and hermesEnabled == true then
		--if abilities[current].enabled == true and hermesEnabled ~= nil and hermesEnabled == true then
		if hermesEnabled ~= nil and hermesEnabled == true then
			target = current
			break
		end
	end

	--if target is nil, then put at beginning or end, depending on direction
	if target == nil then
		if moveup then
			target = 1
		else
			target = #abilities
		end
	end

	if start == target then
		--no change needed
		return
	end

	--remove from old location
	tremove(abilities, start)
	
	--add to new location
	tinsert(abilities, target, value)
	
	return 1 --return a value that indicates the sort changed
end

----------------------------------------------------------
-- VIEWS
----------------------------------------------------------
function mod:GetFirstViewModule()
	for name, m in mod:IterateModules() do
		return name, m
	end
end

function mod:CreateView(profile)
	local moduleName = profile.module
	
	--try to load specified module
	local module = self:GetModule(moduleName, 1)		--silent failure on profile module
	
	if not module then
		--try to load default module
		moduleName = DEFAULT_VIEW_MODULE
		module = self:GetModule(moduleName, 1)			--silent fail on default module
	end
	
	--try to load any module
	if not module then
		moduleName, module = self:GetFirstViewModule()
	end
	
	--if still no module, we're done
	if not module then
		print("|cFFFF0000Hermes-UI Error:|r Container failed to load because no views are available.")
		return
	end
	
	profile.module = moduleName
	
	--find viewProfile
	local moduleProfile = profile.profiles[moduleName]
		
	--ensure viewProfile exists, create it if not
	if not moduleProfile then
		profile.profiles[moduleName] = module:GetViewDefaults()
		moduleProfile = profile.profiles[moduleName]
	end
	
	local view = {
		name = profile.name,
		abilities = {},
		instances = {},
		profile = moduleProfile,
		enabled = false,
	}
	
	tinsert(VIEWS, view)
	
	VIEW_MODULES[view] = module
	VIEW_PROFILES[view] = profile
	VIEW_SENDERS[view] = {}
	
	module:AcquireView(view)
	self:SynchronizeViewWithInventory(view)
	self:EnableView(view)
	
	--clear the onupdate cache so that this view can be added
	_wipeOnUpdateCache()
	
	return view
end

function mod:CreateViews()
	for _, db in ipairs(dbp.views) do
		self:CreateView(db)
	end
end

function mod:Start()
	self:RegisterEvent("RAID_ROSTER_UPDATE")
	self:EnableView() --shows all the views when receiving
end

function mod:Stop()
	self:UnregisterEvent("RAID_ROSTER_UPDATE")
	self:EnableView() --shows all the views when not receiving
end

function mod:EnableView(view)
	if view then
		local module = VIEW_MODULES[view]
		local profile = VIEW_PROFILES[view]
		
		if Hermes:IsReceiving() == true and profile.enabled == true then
			module:EnableView(view)
		else
			module:DisableView(view)
		end
	else
		for _, v in ipairs(VIEWS) do
			self:EnableView(v)
		end
	end
end

function mod:ReleaseView(view)
	local module = VIEW_MODULES[view]
	module:ReleaseView(view)
	
	VIEW_MODULES[view] = nil
	VIEW_PROFILES[view] = nil
	VIEW_SENDERS[view] = nil
	
	_deleteFromIndexedTable(VIEWS, view)
	if view.instances["all"] then
		wipe(view.instances["all"])
	end
	wipe(view)
	view = nil
	
	--clear the onupdate cache so that this view can be removed
	_wipeOnUpdateCache()
end

function mod:ChangeViewModule(view, name)
	--view should exist if this method is called
	local profile = VIEW_PROFILES[view]
	
	if not profile then error("error") end
	
	--no need to release view if it's not enabled
	if profile.enabled then
		self:ReleaseView(view)
	end
	
	--change the module
	profile.module = name
	
	if not SELECTED_VIEW then error("error") end --error checking
	
	--update SELECTED_VIEW because the table address changed
	SELECTED_VIEW.profile = profile
	SELECTED_VIEW.view = nil
	
	--if enabled, then ReCreateView
	if profile.enabled then
		local newview = self:CreateView(profile)
		--update SELECTED_VIEW because the table address changed
		SELECTED_VIEW.view = newview
		--if receiving, then sync receiving state
		if Hermes:IsReceiving() == true then
			self:SyncViewWithReceivingState(newview)
		end
	end
end

function mod:GetViewTablesFromName(viewName) --CODESMELL: I hate that I had to make this. It exists solely for the Buttons view and LBGRegisterCallback. Something of a limitaion in LBF and my code.
	for view, profile in pairs(VIEW_PROFILES) do
		if viewName == profile.name then
			return view, profile
		end
	end
end

----------------------------------------------------------
-- HERMES_ABILITIES
----------------------------------------------------------
function mod:InsertHermesAbility(ability)
	HERMES_ABILITIES[ability.id] = ability
	HERMES_INSTANCES[ability] = {}
end

function mod:RemoveHermesAbility(ability)
	HERMES_INSTANCES[ability] = nil
	HERMES_ABILITIES[ability.id] = nil
end

----------------------------------------------------------
-- HERMES_INSTANCES
----------------------------------------------------------
function mod:InsertHermesInstance(instance)
	tinsert(HERMES_INSTANCES[instance.ability], instance)
	--clear the onupdate cache
	_wipeOnUpdateCache()
end

function mod:RemoveHermesInstance(instance) --should I clear cache here?
	_deleteFromIndexedTable(HERMES_INSTANCES[instance.ability], instance)
	_wipeOnUpdateCache()
end

----------------------------------------------------------
-- HERMES_SENDERS
----------------------------------------------------------
function mod:IsPlayerFiltered(view, sender, player)
	local profile = VIEW_PROFILES[view]
	
	--Note: Occasionally, and there's no explanation for this (except a Blizzard bug) unit and guid info is not available. So just don't filter these people
	if player.unit == nil then
		return nil
	end
	
	if UnitIsUnit("player", player.unit) then
		if profile.filterself == true then
			return 1
		end
	end
	
	--if the group is set, then the assumption is that we're in a raid, and we need to check the raid group filters
	if player.group then
		local difficulty = GetRaidDifficulty()

		if DIFFICULTY_10[difficulty] and profile.filter10man == true and player.group > 2 then
			return 1
		end
			
		if DIFFICULTY_25[difficulty] and profile.filter25man == true and player.group > 5 then
			return 1
		end
	end
	
	--handle dead
	if profile.filterdead == true and sender.dead == true then
		return 1
	end
	
	--handle disconnected
	if profile.filterconnection == true and sender.online == false then
		return 1
	end
	
	--handle range
	if profile.filterrange == true and not sender.visible then
		return 1
	end
	
	--now handle white/black lists
	if profile.filterplayertype ~= "disabled" and profile.playerfilters then
		if profile.filterplayertype == "black" then
			for _, name in ipairs(profile.playerfilters) do
				if name == player.name then
					return 1 --hide it
				end
			end
		elseif profile.filterplayertype == "white" then
			for _, name in ipairs(profile.playerfilters) do	
				if name == player.name then
					return nil --allow it
				end
			end
			
			if not UnitIsUnit("player", player.unit) then --don't hide yourself via whitelist, that's what the hideself option is for.
				return 1 --hide it
			end
		end
	end
	
	--NOTE: If I add more filters then I need to change the code above that returns filter
	return nil
end

function mod:UpdatePlayerData(player)
	local prefix = "none"
	local members = nil

	if GetNumRaidMembers() > 0 then
		prefix = "raid"
		members = GetNumRaidMembers()
	elseif GetNumPartyMembers() > 0 then
		prefix = "party"
		members = GetNumPartyMembers()
	end
	
	if prefix == "raid" then
		for i = 1, members do
			local unit = prefix..tostring(i)
			local name, _, group = GetRaidRosterInfo(i)
				
			--only update the single player is specified, otherwise update everyone
			if player then
				if player.name == name then
					player.unit, player.group = unit, group
					return --no more work needed
				end
			else
				for sender, p in pairs(HERMES_SENDERS) do
					if p.name == name then
						p.unit, p.group = unit, group
						break --stop looping through senders
					end
				end
			end
		end

	elseif prefix == "party" then
		--handle self
		if player.name == UnitName("player") then
			player.unit = "player"
			player.group = nil
		else
			--handle the other party members
			for i = 1, members do
				local unit = prefix..tostring(i)
				local name = UnitName(unit)
					
				--only update the single player is specified, otherwise update everyone
				if player then
					if player.name == name then
						player.unit, player.group = unit, nil --always set group to nil when in a party
						break --stop looping through senders
					end
				else
					for sender, p in pairs(HERMES_SENDERS) do
						if p.name == name then
							p.unit, p.group = unit, nil--always set group to nil when in a party
							break --stop looping through senders
						end
					end
				end
			end
		end

	elseif prefix == "none" then
		--you'll get here if not in a party or raid
		--this might mean you're in config mode, and it might not.
		--if player specified, then you're probably in config mode
		if player then
			if player.name ~= UnitName("player") then error("this was unexpected") end
			player.group = nil
			player.unit = "player"
		end
	end
end

local _deleteInstances = {}
--TODO: CACHE THESE CALCULATIONS FOR PERFORMANCE
function mod:SyncViewWithPlayerFilters(view, sender)
	if view then
		if sender then
			local reqdel = false --set to true if this sender needs to be removed from the view
			local reqadd = false --set to true if this sender needs to be added to the view
			local player = HERMES_SENDERS[sender]
			local exists = VIEW_SENDERS[view][sender]
			
			------------------------------
			-- PROCESS
			------------------------------
			if self:IsPlayerFiltered(view, sender, player) then
				reqdel = exists
			else
				reqadd = not exists
			end
			
			--debug code
			if reqadd == true and reqdel == true then
				error("unexpected condition")
			end
			------------------------------
			-- ADD
			------------------------------
			if reqdel then
				--clear the onupdate cache
				_wipeOnUpdateCache()
				
				--we have to be careful here, we can't just blindly loop through all instances of each ability because of the "all" table.
				--otherwise we'll accidentally try to delete the same instance twice
				--so we'll just loop through the all table, it's supposed to represent every instance anyway. Note that it might not exist, hence the check
				local profile = VIEW_PROFILES[view]
				if view.instances["all"] then
					for _, instance in ipairs(view.instances["all"]) do
						--the ability also has to be enabled in order to be elegible for removal
						local info, _ = self:GetViewAbilityInfo(profile, instance.ability.id)
						if info.enabled == true or profile.includeAll == true then
							--add instances to remove
							if instance.sender == sender then
								tinsert(_deleteInstances, instance)
							end
						end
					end
					for _, instance in ipairs(_deleteInstances) do
						--remove them
						self:RemoveInstanceFromView(view, instance.ability, instance)
					end
				end
				--remove the sender from the view
				VIEW_SENDERS[view][sender] = nil
				
			------------------------------
			-- DELETE
			------------------------------	
			elseif reqadd then
				--clear the onupdate cache
				_wipeOnUpdateCache()
				
				--add the sender to the view senders
				VIEW_SENDERS[view][sender] = true
				local profile = VIEW_PROFILES[view]
				--loop through all instances for all abilities, and add any belonging to this sender
				for ability, instances in pairs(HERMES_INSTANCES) do
					--the ability also has to be enabled in order to be elegible for removal
					local info, _ = self:GetViewAbilityInfo(profile, ability.id)
					if info.enabled == true or profile.includeAll == true then
						for _, instance in ipairs(instances) do
							if instance.sender == sender then
								self:AddExistingInstanceToView(view, ability, instance)	
							end
						end
					end
				end
			end
			
			------------------------------
			-- CLEANUP
			------------------------------
			wipe(_deleteInstances)
		else
			for sender, player in pairs(HERMES_SENDERS) do
				self:SyncViewWithPlayerFilters(view, sender)
			end
		end
	else
		if sender then
			for _, view in ipairs(VIEWS) do
				self:SyncViewWithPlayerFilters(view, sender)
			end
		else
			for _, view in ipairs(VIEWS) do
				self:SyncViewWithPlayerFilters(view, nil)
			end
		end
	end
end

function mod:InsertHermesSender(sender)
	local player = {
		name = sender.name,
		unit = nil,		--gets set in UpdatePlayerData
		group = nil,	--gets set in UpdatePlayerData
	}
	
	self:UpdatePlayerData(player)
	
	HERMES_SENDERS[sender] = player

	--add the sender to each view table if it applies
	for _, view in ipairs(VIEWS) do
		
		--error checking to make sure sender does't already exist, because that would mean bad coding somewhere. delete this code once tested
		if not VIEW_SENDERS[view] then error("nil view players table") end
		
		if not self:IsPlayerFiltered(view, sender, player) then
			VIEW_SENDERS[view][sender] = true
		end
	end
	
	--clear the onupdate cache
	_wipeOnUpdateCache()
end

function mod:RemoveHermesSender(sender)
	HERMES_SENDERS[sender] = nil
	--now sender remove an views that have it. It's important to note that Hermes always removes a sender last (instances, then abilities, then senderrs) so we don't need to handle those other elements (they'll already be gone)
	for _, view in ipairs(VIEWS) do
		--error checking to make sure sender does't already exist, because that would mean bad coding somewhere. delete this code once tested
		if not VIEW_SENDERS[view] then error("nil view senders table") end
		--add sender to view if it's not filtered
		if VIEW_SENDERS[view][sender] then
			VIEW_SENDERS[view][sender] = nil
			--note, no syncing needed because hermes will have already removed instances for the sender
		end
	end
	
	--clear the onupdate cache
	_wipeOnUpdateCache()
end

----------------------------------------------------------
-- HERMES EVENT HANDLERS
----------------------------------------------------------
function mod:OnSenderAdded(sender)
	self:InsertHermesSender(sender)
end

function mod:OnSenderRemoved(sender)
	self:RemoveHermesSender(sender)
end

function mod:OnSenderVisibilityChanged(sender)
	--update all the views based on status
	self:SyncViewWithPlayerFilters(nil, sender)
end

function mod:OnSenderOnlineChanged(sender)
	--update all the views based on status
	self:SyncViewWithPlayerFilters(nil, sender)
end

function mod:OnSenderDeadChanged(sender)
	--update all the views based on status
	self:SyncViewWithPlayerFilters(nil, sender)
end

function mod:OnAbilityAdded(ability)
	self:InsertHermesAbility(ability)
	for _, view in ipairs(VIEWS) do
		local profile = VIEW_PROFILES[view]
		local info, _ = self:GetViewAbilityInfo(profile, ability.id)
		if info.enabled == true or profile.includeAll == true then
			self:AddNewAbilityToView(view, ability)
		end
	end
end

function mod:OnAbilityRemoved(ability)
	--remove from views first
	for _, view in ipairs(VIEWS) do
		local profile = VIEW_PROFILES[view]
		local info, _ = self:GetViewAbilityInfo(profile, ability.id)
		if info.enabled == true or profile.includeAll == true then
			self:RemoveAbilityFromView(view, ability)
		end
	end
	
	--now remove from view manager
	self:RemoveHermesAbility(ability)
end

function mod:OnAbilityAvailableSendersChanged(ability)
	for _, view in ipairs(VIEWS) do
		local profile = VIEW_PROFILES[view]
		local info, _ = self:GetViewAbilityInfo(profile, ability.id)
		if info.enabled == true or profile.includeAll == true then
			local module = VIEW_MODULES[view]
			local func = module.OnAbilityAvailableSendersChanged
			if func and type(func) == "function" then
				module:OnAbilityAvailableSendersChanged(view, ability)
			end
		end
	end
end

function mod:OnAbilityTotalSendersChanged(ability)
	for _, view in ipairs(VIEWS) do
		local profile = VIEW_PROFILES[view]
		local info, _ = self:GetViewAbilityInfo(profile, ability.id)
		if info.enabled == true or profile.includeAll == true then
			local module = VIEW_MODULES[view]
			local func = module.OnAbilityTotalSendersChanged
			if func and type(func) == "function" then
				module:OnAbilityTotalSendersChanged(view, ability)
			end
		end
	end
end

function mod:OnInstanceAdded(instance) -- MODIFIED FOR FILTER
	self:InsertHermesInstance(instance) --also wipes onupdate cache
	local ability = instance.ability
	for _, view in ipairs(VIEWS) do
		local profile = VIEW_PROFILES[view]
		local info, _ = self:GetViewAbilityInfo(profile, ability.id)
		if info.enabled == true or profile.includeAll == true then
			if VIEW_SENDERS[view][instance.sender] then --player filter check
				self:AddNewInstanceToView(view, ability, instance)
			end
		end
	end
end

function mod:OnInstanceRemoved(instance)-- MODIFIED FOR FILTER
	--no need to change sort?
	
	--remove from views first
	local ability = instance.ability
	for _, view in ipairs(VIEWS) do
		local profile = VIEW_PROFILES[view]
		local info, _ = self:GetViewAbilityInfo(profile, ability.id)
		if info.enabled == true or profile.includeAll == true then
			if VIEW_SENDERS[view][instance.sender] then --player filter check
				self:RemoveInstanceFromView(view, ability, instance)
			end
		end
	end
	
	--now remove from view manager
	self:RemoveHermesInstance(instance) --also wipes onupdate cache
end

function mod:OnInstanceStartCooldown(instance)-- MODIFIED FOR FILTER
	local ability = instance.ability
	for _, view in ipairs(VIEWS) do
		local profile = VIEW_PROFILES[view]
		local info, _ = self:GetViewAbilityInfo(profile, ability.id)
		if info.enabled == true or profile.includeAll == true then
			if VIEW_SENDERS[view][instance.sender] then --player filter check
				self:SortViewAbilityInstances(view, ability, 1, 1)
				local module = VIEW_MODULES[view]
				local func = module.OnInstanceStartCooldown
				if func and type(func) == "function" then
					module:OnInstanceStartCooldown(view, ability, instance)
				end
			end
		end
	end
end

--this caching strategy cuts the CPU usage of this method roughly in half vs. not caching
function mod:OnInstanceUpdateCooldown(instance)-- MODIFIED FOR FILTER
	local cache = ONINSTANCE_UPDATE_CACHE[instance]
	
	if cache then																					--we've processed and cached this instance before
		if cache.views then																			--there are views that we need to fire callbacks for
			for view, module in pairs(cache.views) do												--fire the event for each view
				module:OnInstanceUpdateCooldown(view, instance.ability, instance)
			end
		end
		--no views are interested in this instance
	else
		--One time cache setup for instance
		ONINSTANCE_UPDATE_CACHE[instance] = {}
		
		local ability = instance.ability
		for _, view in ipairs(VIEWS) do
			local profile = VIEW_PROFILES[view]
			local info, _ = self:GetViewAbilityInfo(profile, ability.id)
			if info.enabled == true or profile.includeAll == true then
				if VIEW_SENDERS[view][instance.sender] then --player filter check
					--no need to change sort
					local module = VIEW_MODULES[view]
					local func = module.OnInstanceUpdateCooldown
					if func and type(func) == "function" then
						module:OnInstanceUpdateCooldown(view, ability, instance)
						--create cache entry
						local cache = ONINSTANCE_UPDATE_CACHE[instance]
						if not cache.views then
							cache.views = {}
						end
						cache.views[view] = module
					end
					--view doesn't implement OnInstanceUpdateCooldown
				end
				--view filtered out sender
			end
			--view doesn't have spell enabled
		end
	end
end

function mod:OnInstanceStopCooldown(instance)-- MODIFIED FOR FILTER
	local ability = instance.ability
	for _, view in ipairs(VIEWS) do
		local profile = VIEW_PROFILES[view]
		local info, _ = self:GetViewAbilityInfo(profile, ability.id)
		if info.enabled == true or profile.includeAll == true then
			if VIEW_SENDERS[view][instance.sender] then --player filter check
				self:SortViewAbilityInstances(view, ability, 1, 1)
				local module = VIEW_MODULES[view]
				local func = module.OnInstanceStopCooldown
				if func and type(func) == "function" then
					module:OnInstanceStopCooldown(view, ability, instance)
				end
			end
		end
	end
end

--TODO: OPTIMIZE THIS METHOD WITH TABLE CACHING OR SOMETHING TO AVOID THE LOOKUPS
function mod:OnInstanceAvailabilityChanged(instance)-- MODIFIED FOR FILTER
	--wipe the onupdate cache
	_wipeOnUpdateCache()
	
	local ability = instance.ability
	for _, view in ipairs(VIEWS) do
		local profile = VIEW_PROFILES[view]
		local info, _ = self:GetViewAbilityInfo(profile, ability.id)
		if info.enabled == true or profile.includeAll == true then
			if VIEW_SENDERS[view][instance.sender] then --player filter check
				self:SortViewAbilityInstances(view, ability, 1, 1)
				local module = VIEW_MODULES[view]
				local func = module.OnInstanceAvailabilityChanged
				if func and type(func) == "function" then
					module:OnInstanceAvailabilityChanged(view, ability, instance)
				end
			end
		end
	end
end

----------------------------------------------------------
-- ABILITY AND INSTANCE METHODS
----------------------------------------------------------
function mod:AddNewAbilityToView(view, ability)
	--add ability to view
	tinsert(view.abilities, ability)
	--initialize instance table
	view.instances[ability] = {}
	if not view.instances["all"] then
		view.instances["all"] = {}
	end
	--sort the abilities
	self:SortViewAbilities(view)
	--handle callback
	local module = VIEW_MODULES[view]
	local func = module.OnAbilityAdded
	if func and type(func) == "function" then
		module:OnAbilityAdded(view, ability)
	end
end

function mod:AddExistingAbilityToView(view, ability)-- MODIFIED FOR FILTER, because SyncViewWithReceivingState calls this
	self:AddNewAbilityToView(view, ability)
	for _, instance in ipairs(HERMES_INSTANCES[ability]) do
		if VIEW_SENDERS[view][instance.sender] then --player filter check
			self:AddExistingInstanceToView(view, ability, instance)
		end
	end
end

function mod:AddNewInstanceToView(view, ability, instance)
	--wipe the onupdate cache
	_wipeOnUpdateCache()
	
	tinsert(view.instances[ability], instance)
	tinsert(view.instances["all"], instance)
	self:SortViewAbilityInstances(view, ability, 1, nil) --event fireing not needed because it's assumed it'll be handled in following event
	local module = VIEW_MODULES[view]
	local func = module.OnInstanceAdded
	if func and type(func) == "function" then
		module:OnInstanceAdded(view, ability, instance)
	end
end

function mod:AddExistingInstanceToView(view, ability, instance)
	--wipe the onupdate cache
	_wipeOnUpdateCache()
	
	--might not exist if no instances added yet (due to filtering)
	if not view.instances[ability] then
		view.instances[ability] = {}
	end
	tinsert(view.instances[ability], instance)
	
	--might not exist if no instances added yet
	if not view.instances["all"] then
		view.instances["all"] = {}
	end
	tinsert(view.instances["all"], instance)
	
	--self:SortViewInstances(view, ability, false) --event fireing not needed because it's assumed it'll be handled in following event
	self:SortViewAbilityInstances(view, ability, 1, nil) --event fireing not needed because it's assumed it'll be handled in following event
	local module = VIEW_MODULES[view]
	
	--simulate stuff Hermes would do were this an actual new instance
	if module.OnAbilityTotalSendersChanged and type(module.OnAbilityTotalSendersChanged) == "function" then
		module:OnAbilityTotalSendersChanged(view, ability)
	end
	
	--simulate stuff Hermes would do were this an actual new instance
	if module.OnAbilityAvailableSendersChanged and type(module.OnAbilityAvailableSendersChanged) == "function" then
		module:OnAbilityAvailableSendersChanged(view, ability)
	end
	
	--the main event that needs to be run
	if module.OnInstanceAdded and type(module.OnInstanceAdded) == "function" then
		module:OnInstanceAdded(view, ability, instance)
	end
	
	--simulate stuff Hermes would do were this an actual new instance
	if instance.remaining then
		if module.OnAbilityAvailableSendersChanged and type(module.OnAbilityAvailableSendersChanged) == "function" then
			module:OnAbilityAvailableSendersChanged(view, ability)
		end
		if module.OnInstanceStartCooldown and type(module.OnInstanceStartCooldown) == "function" then
			module:OnInstanceStartCooldown(view, ability, instance)
		end
	end
end

function mod:RemoveAbilityFromView(view, ability)
	--remove all the instances
	while #view.instances[ability] > 0 do
		--if there's ever a place for a bug with player filters this could be it
		local instance = view.instances[ability][1]
		self:RemoveInstanceFromView(view, ability, instance)
	end
	
	--delete ability and instances
	local index = _findTableIndex(view.abilities, ability)	--find the index
	view.instances[view.abilities[index]] = nil 			--delete the instance table
	tremove(view.abilities, index)							--delete the ability
	
	--notify view
	local module = VIEW_MODULES[view]
	local func = module.OnAbilityRemoved
	if func and type(func) == "function" then
		module:OnAbilityRemoved(view, ability)
	end
end

function mod:RemoveInstanceFromView(view, ability, instance)
	--wipe the onupdate cache
	_wipeOnUpdateCache()
	
	--delete instances
	local index = _findTableIndex(view.instances[ability], instance)	--find the index
	tremove(view.instances[ability], index)								--delete the instance
	
	index = _findTableIndex(view.instances["all"], instance)			--find the index
	tremove(view.instances["all"], index)								--delete the instance
	
	--notify view
	local module = VIEW_MODULES[view]
	local func = module.OnInstanceRemoved
	if func and type(func) == "function" then
		module:OnInstanceRemoved(view, ability, instance)
	end
end

function mod:SyncViewWithReceivingState(view)
	if #view.abilities > 0 then error("error") end --error checking
	
	--wipe the onupdate cache
	_wipeOnUpdateCache()
	
	--sync senders
	for sender, player in pairs(HERMES_SENDERS) do
		if not self:IsPlayerFiltered(view, sender, player) then
			VIEW_SENDERS[view][sender] = true
		end
	end
	
	--sync abilities
	for id, ability in pairs(HERMES_ABILITIES) do
		if view.instances[ability] then error("error") end --error checking
		local profile = VIEW_PROFILES[view]
		local info, _ = self:GetViewAbilityInfo(profile, ability.id)
		if info.enabled == true or profile.includeAll == true then
			self:AddExistingAbilityToView(view, ability)
		end
	end
end

------------------------------------------------------------------
--LIBSHAREDMEDIA
------------------------------------------------------------------
function mod:OnLibSharedMediaUpdate(event, mediatype, key)
	--CODESMELL: it sucks that I have to put this code here, but not much choice given
	--that view modules aren't required to remember all the frames and stuff they use
	for _, view in ipairs(VIEWS) do
		--handle callback
		local module = VIEW_MODULES[view]
		local func = module.OnLibSharedMediaUpdate
		if func and type(func) == "function" then
			module:OnLibSharedMediaUpdate(view, mediatype, key)
		end
	end
end

----------------------------------------------------------
-- HELPERS/MOCK
----------------------------------------------------------
function mod:GetTotalAbilityStats(view)
	--this is almost a direct cut and pase from Hermes:GetAbilityStats.
	--it's just modified to work with a single table of instances
	--and avoids some unnecessary table lookups were I to just loop through
	--abilities or something instead
	local m = nil
	local t = 0
	local o = 0
	local a = 0
	local u = 0
	
	--instances["all"] may not exist if there are no instances.
	local instances = view.instances["all"]
	
	if instances then
		for _, instance in ipairs(instances) do
			local sender = Hermes:IsSenderAvailable(instance.sender)

			t = t + 1
			
			if not sender then
				u = u + 1
			end

			if sender and instance.remaining then
				if not m then
					m = instance.remaining
				else
					if instance.remaining < m then
						m = instance.remaining
					end
				end
			end
			
			if sender and not instance.remaining then
				a = a + 1
			end
			
			if sender and instance.remaining then
				o = o + 1
			end
		end
	end
	return m, t, o, a, u
end

function mod:GetAbilityStats(view, ability)
	--this is almost a direct cut and pase from Hermes:GetAbilityStats.
	--it's just modified to work with a single table of instances
	--and avoids some unnecessary table lookups were I to just loop through
	--abilities or something instead
	local m = nil
	local t = 0
	local o = 0
	local a = 0
	local u = 0
	
	--instances["all"] may not exist if there are no instances.
	local instances = view.instances[ability]
	
	if instances then
		for _, instance in ipairs(instances) do
			local sender = Hermes:IsSenderAvailable(instance.sender)

			t = t + 1
			
			if not sender then
				u = u + 1
			end

			if sender and instance.remaining then
				if not m then
					m = instance.remaining
				else
					if instance.remaining < m then
						m = instance.remaining
					end
				end
			end
			
			if sender and not instance.remaining then
				a = a + 1
			end
			
			if sender and instance.remaining then
				o = o + 1
			end
		end
	end
	return m, t, o, a, u
end

----------------------------------------------------------
-- SORTING
----------------------------------------------------------
function mod:SortViewAbilities(view)
	local profile = VIEW_PROFILES[view]
	sort(view.abilities,
		function(a, b)
			local iA, _ = select(2, self:GetViewAbilityInfo(profile, a.id))
			local iB, _ = select(2, self:GetViewAbilityInfo(profile, b.id))
			return iA < iB
		end
	)
end

function mod:FireOnAbilitySortChanged(view)
	local module = VIEW_MODULES[view]
	local func = module.OnAbilitySortChanged
	if func and type(func) == "function" then
		module:OnAbilitySortChanged(view)
	end
end

function mod:FireOnInstanceSortChanged(view, ability)
	local module = VIEW_MODULES[view]
	local func = module.OnInstanceSortChanged
	if func and type(func) == "function" then
		module:OnInstanceSortChanged(view, ability)
	end
end

local function SortInstancesByPlayerName(view, a, b)
	return a.sender.name < b.sender.name
end

local function SortInstancesBySpellOrder(view, a, b)
	if a.ability == b.ability then
		return SortInstancesByPlayerName(view, a, b)
	else
		local iA, _ = _findTableIndex(view.abilities, a.ability)
		local iB, _ = _findTableIndex(view.abilities, b.ability)
		return iA < iB
	end
end

local function SortInstancesByDuration(view, a, b)
	local durationA 
	local durationB

	if(not a.remaining) then
		durationA = 0
	else
		durationA = a.remaining
	end
	
	if(not b.remaining) then
		durationB = 0
	else
		durationB = b.remaining
	end

	if(durationA == durationB) then
		return SortInstancesBySpellOrder(view, a, b)
	else
		return durationA < durationB
	end
end

local function SortInstancesByAvailability(view, a, b)
	local senderAAvailable = Hermes:IsSenderAvailable(a.sender)
	local senderBAvailable = Hermes:IsSenderAvailable(b.sender)
	
	--online
	if(senderAAvailable == false and senderBAvailable == true) then
		return false --A below B
	end
	if(senderAAvailable == true and senderBAvailable == false) then
		return true --A above B
	end

	--they're both available, sort by duration
	return SortInstancesByDuration(view, a, b)
end

--Availability -> Duration -> SpellOrder -> SenderName
function mod:SortViewAbilityInstances(view, ability, includeall, fireevent) --sorts the instances for the specified ability
	--only sort the all table once
	if includeall then
		sort(view.instances["all"], function(a, b) return SortInstancesByAvailability(view, a, b) end)
	end
	
	if ability then
		sort(view.instances[ability], function(a, b) return SortInstancesByAvailability(view, a, b) end)
		if fireevent then
			self:FireOnInstanceSortChanged(view, ability)
		end
	else
		for _, ability in ipairs(view.abilities) do
			self:SortViewAbilityInstances(view, ability, nil, fireevent)
		end
	end
end

----------------------------------------------------------
-- OPTIONS
----------------------------------------------------------
function mod:CheckLastSelectedView()
	self:SortProfileViews()
	
	if not SELECTED_VIEW then
		--no view is selected, select the first in the list
		if #dbp.views > 0 then
			SELECTED_VIEW = {
				profile = dbp.views[1],
				view = nil,
			}
			
			if SELECTED_VIEW.profile.enabled == true then
				-- if view is enabled, then find the corresponding view
				for view, profile in pairs(VIEW_PROFILES) do
					if profile == SELECTED_VIEW.profile then
						--found it
						SELECTED_VIEW.view = view
					end
				end
			end
		end
	end
end

function mod:GenerateUniqueViewName(startWith)
	local exists = true
	local count = 1
	local name

	while (exists == true) do
		name = startWith..format("%.0f", count)
		local match = false
		for _, view in ipairs(VIEWS) do
			local profile = VIEW_PROFILES[view]
			if(profile.name == name) then
				match = true
			end
		end
		
		if(match == false) then
			exists = false
		end
		count = count + 1
	end
	return name
end

function mod:UpdateViewSpellsTable()
	if blizzArgs.viewspells.args then
		wipe(blizzArgs.viewspells.args)
	end
	
	self:CheckLastSelectedView()
	
	--don't show if no selected view or the selected view isn't enabled
	if not SELECTED_VIEW or not SELECTED_VIEW.view then
		blizzArgs.viewspells.disabled = true
		blizzArgs.viewspells.args = {
			empty = {
				type = "description",
				name = "",
				order = 5,
				width = "full",
			},
		}
		return
	end
	
	local view = SELECTED_VIEW.view
	local profile = SELECTED_VIEW.profile
	
	blizzArgs.viewspells.disabled = false
	
	blizzArgs.viewspells.args.includeAll = {
		type = "toggle",
		name = L["Include all enabled Hermes spells"],
		order = 1,
		width = "full",
		get = function() return profile.includeAll end,
		set = function(info, value)
			if(value) then
				profile.includeAll = true
				--very important to only work with abilities if receiving, otherwise it won't exist
				if Hermes:IsReceiving() == true then
					--we need sync up existing in view with all
					for id, ha in pairs(HERMES_ABILITIES) do
						local exists = false
						for _, va in ipairs(view.abilities) do
							if ha == va then
								exists = true
								break
							end
						end
						
						if exists == false then
							self:AddExistingAbilityToView(view, ha)
						end
					end
				end
			else
				profile.includeAll = false
				--very important to only work with abilities if receiving, otherwise it won't exist
				if Hermes:IsReceiving() == true then
					--we need to somehow sync up existing with not all
					for id, ha in pairs(HERMES_ABILITIES) do
						local info, _ = self:GetViewAbilityInfo(profile, id)
						if info.enabled == false then
							self:RemoveAbilityFromView(view, ha)
						end
					end
				end
			end
			self:UpdateViewSpellsTable()
		end,
	}
	
	blizzArgs.viewspells.args.spacer = {
		type = "header",
		name = "",
		order = 2,
		width = "full",
	}
	
	local count = 0
	for index, abilityProfile in ipairs(profile.abilities) do
		local id, name, class, icon, enabled = Hermes:GetInventoryDetail(abilityProfile.id)

		if not id then
			error("uh oh, ability was in profile that wasn't enabled by Hermes")
		end
		
		if id and enabled == true then
			--only show the ability if it is enabled through Hermes
			count = count + 1
			blizzArgs.viewspells.args[tostring(id)] = {
				type = "group",
				inline = true,
				name = "",
				order = count + 2, --offset by two due to having added the includeAll and spacer values above
				args = {
					name = {
						type = "toggle",
						name = "|T"..icon..":0:0:0:0|t "..name,
						order = 5,
						width = "normal",
						desc = tostring(Hermes:AbilityIdToBlizzId(id)),
						disabled = profile.includeAll == true,
						--disabled = true,
						get = function() return abilityProfile.enabled or profile.includeAll == true end,
						set = function(info, value)
							if(value) then
								abilityProfile.enabled = true
								--very important to only work with abilities if receiving, otherwise it won't exist
								if Hermes:IsReceiving() == true then
									--add ability
									self:AddExistingAbilityToView(view, HERMES_ABILITIES[id])
								end
							else
								abilityProfile.enabled = false
								--very important to only work with abilities if receiving, otherwise it won't exist
								if Hermes:IsReceiving() == true then
									--remove ability
									self:RemoveAbilityFromView(view, HERMES_ABILITIES[id])
								end
							end
						end,
					},
					moveup = {
						type = "execute",
						name = L["Move Up"],
						width = "normal",
						order = 10,
						func = function()
							if self:MoveSpell(profile.abilities, abilityProfile, true) then
								--very important to only work with abilities if receiving, otherwise it won't exist
								if Hermes:IsReceiving() == true then
									self:SortViewAbilities(view)
									self:SortViewAbilityInstances(view, nil, 1, 1)
									self:FireOnAbilitySortChanged(view)
									self:UpdateViewSpellsTable()
								end
							end
						end,
					},
					movedown = {
						type = "execute",
						name = L["Move Down"],
						width = "normal",
						order = 15,
						func = function()
							if self:MoveSpell(profile.abilities, abilityProfile, false) then
								--very important to only work with abilities if receiving, otherwise it won't exist
								if Hermes:IsReceiving() == true then
									self:SortViewAbilities(view)
									self:SortViewAbilityInstances(view, nil, 1, 1)
									self:FireOnAbilitySortChanged(view)
									self:UpdateViewSpellsTable()
								end
							end
						end,
					},
				}
			}
		end
	end

	--if no items were added, then it's because Hermes doesn't have any abilities enabled
	if count == 0 then
		blizzArgs.viewspells.args = {
			empty = {
				type = "description",
				name = L["Hermes isn't tracking any spells or abilities."],
				order = 5,
				fontSize = "medium",
				width = "full",
			},
		}
		return
	end
end

function mod:UpdateViewPlayerFiltersTable()
	if blizzArgs.playerfilters.args then
		wipe(blizzArgs.playerfilters.args)
	end
	
	self:CheckLastSelectedView()
	
	--don't show if no selected view or the selected view isn't enabled
	if not SELECTED_VIEW or not SELECTED_VIEW.view then
		blizzArgs.playerfilters.disabled = true
		blizzArgs.playerfilters.args = {
			empty = {
				type = "description",
				name = "",
				order = 5,
				width = "full",
			},
		}
		return
	end
	
	local view = SELECTED_VIEW.view
	local profile = SELECTED_VIEW.profile
	
	blizzArgs.playerfilters.disabled = false
	
	blizzArgs.playerfilters.args.self = {
		type = "group",
		name = "",
		order = 5,
		inline = true,
		args = {
			filterself = {
				type = "toggle",
				name = L["Hide Self"],
				order = 5,
				width = "normal",
				get = function()
					return profile.filterself
				end,
				set = function(info, value)
					profile.filterself = value
					if Hermes:IsReceiving() == true then
						--sync with all senders
						for sender, player in pairs(HERMES_SENDERS) do
							self:SyncViewWithPlayerFilters(view, sender)
						end
					end
				end,
			},
		},
	}
	
	blizzArgs.playerfilters.args.raid = {
		type = "group",
		name = L["Raid Groups"],
		order = 10,
		inline = true,
		args = {
			filter10man = {
				type = "toggle",
				name = L["10 Man (hide 3-8)"],
				order = 5,
				width = "normal",
				get = function()
					return profile.filter10man
				end,
				set = function(info, value)
					profile.filter10man = value
					if Hermes:IsReceiving() == true then
						--sync with all senders
						for sender, player in pairs(HERMES_SENDERS) do
							self:SyncViewWithPlayerFilters(view, sender)
						end
					end
				end,
			},
			filter25man = {
				type = "toggle",
				name = L["25 Man (hide 6-8)"],
				order = 10,
				width = "normal",
				get = function()
					return profile.filter25man
				end,
				set = function(info, value)
					profile.filter25man = value
					if Hermes:IsReceiving() == true then
						--sync with all senders
						for sender, player in pairs(HERMES_SENDERS) do
							self:SyncViewWithPlayerFilters(view, sender)
						end
					end
				end,
			},
		},
	}
	
	blizzArgs.playerfilters.args.status = {
		type = "group",
		name = L["Player Status"],
		order = 15,
		inline = true,
		args = {
			filterdead = {
				type = "toggle",
				name = L["Hide Dead"],
				order = 5,
				width = "normal",
				get = function()
					return profile.filterdead
				end,
				set = function(info, value)
					profile.filterdead = value
					if Hermes:IsReceiving() == true then
						--sync with all senders
						for sender, player in pairs(HERMES_SENDERS) do
							self:SyncViewWithPlayerFilters(view, sender)
						end
					end
				end,
			},
			filterrange = {
				type = "toggle",
				name = L["Hide Not In Range"],
				order = 10,
				width = "normal",
				get = function()
					return profile.filterrange
				end,
				set = function(info, value)
					profile.filterrange = value
					if Hermes:IsReceiving() == true then
						--sync with all senders
						for sender, player in pairs(HERMES_SENDERS) do
							self:SyncViewWithPlayerFilters(view, sender)
						end
					end
				end,
			},
			filterconnection = {
				type = "toggle",
				name = L["Hide Disconnected"],
				order = 15,
				width = "normal",
				get = function()
					return profile.filterconnection
				end,
				set = function(info, value)
					profile.filterconnection = value
					if Hermes:IsReceiving() == true then
						--sync with all senders
						for sender, player in pairs(HERMES_SENDERS) do
							self:SyncViewWithPlayerFilters(view, sender)
						end
					end
				end,
			},
		},
	}
	
	blizzArgs.playerfilters.args.names = {
		type = "group",
		name = L["Player Names"],
		order = 20,
		inline = true,
		args = {
			filter = {
				type = "select",
				name = L["Filter Type"],
				width = "double",
				order = 5,
				get = function() return profile.filterplayertype end,
				values = {
					["disabled"] = L["Disabled"],
					["white"] = L["Whitelist"],
					["black"] = L["Blacklist"],
				},
				set = function(info, value)
					profile.filterplayertype = value
					if Hermes:IsReceiving() == true then
						--sync with all senders
						self:SyncViewWithPlayerFilters(view, nil)
					end
				end,
			},
			spacer1 = {
				type = "description",
				name = "",
				width = "full",
				order = 10,
			},
			add = {
				type = "select",
				name = L["Add"],
				width = "normal",
				order = 15,
				get = function() return nil end,
				values = function()
					local names = {}
					for sender, player in pairs(HERMES_SENDERS) do
						local exists
						--don't add if already in list
						for _, name in ipairs(profile.playerfilters) do
							if name == sender.name then
								exists = 1
								break
							end
						end
						
						if not exists and UnitName("player") ~= sender.name then
							names[sender.name] = sender.name
						end
					end
					
					return names
				end,
				set = function(info, name)
					tinsert(profile.playerfilters, name)
					--sort it
					sort(profile.playerfilters,
						function(a, b)
							return a < b
						end
					)
					
					if Hermes:IsReceiving() == true then
						--find the sender we just added
						for sender, player in pairs(HERMES_SENDERS) do
							if sender.name == name then
								self:SyncViewWithPlayerFilters(view, sender)
								break
							end
						end
						--if the sender wasn't found, that's perfectly fine, it could happen
					end
					
					self:UpdateViewPlayerFiltersTable()
				end,
			},
			removep = {
				type = "select",
				name = L["Delete"],
				width = "normal",
				order = 20,
				get = function() return nil end,
				values = function()
					local names = {}
					for _, name in ipairs(profile.playerfilters) do
						names[name] = name
					end
					return names
				end,
				set = function(info, name)
					_deleteFromIndexedTable(profile.playerfilters, name)
					--there's really no guarantee that this sender even exists right now
					if Hermes:IsReceiving() == true then
						--find the sender we just removed, if possible
						for sender, player in pairs(HERMES_SENDERS) do
							if sender.name == name then
								self:SyncViewWithPlayerFilters(view, sender)
								break
							end
						end
						--if the sender wasn't found, that's perfectly fine, it could happen
					end
						
					self:UpdateViewPlayerFiltersTable()
				end,
			},
		},
	}
	
end

local LAST_SELECTED_MODULE = nil
function mod:UpdateViewGeneralTable()
	if blizzArgs.viewgeneral.args then
		wipe(blizzArgs.viewgeneral.args)
		blizzArgs.viewgeneral.args = nil
	end
	
	self:CheckLastSelectedView()
	
	--don't show if no selected view or the selected view isn't enabled
	if not SELECTED_VIEW or not SELECTED_VIEW.view then
		blizzArgs.viewgeneral.disabled = true
		blizzArgs.viewgeneral.args = {
			empty = {
				type = "description",
				name = "",
				order = 5,
				width = "full",
			},
		}
		
		return
	end
	
	local view = SELECTED_VIEW.view
	local profile = SELECTED_VIEW.profile
	local module
	if LAST_SELECTED_MODULE then
		module = self:GetModule(LAST_SELECTED_MODULE)
	else
		module = VIEW_MODULES[view]
	end
	
	blizzArgs.viewgeneral.disabled = false
	blizzArgs.viewgeneral.args = {
		name = {
			type = "input",
			name = L["Name"],
			width = "double",
			order = 5,
			get = function()
				return profile.name
			end,
			validate = function(info, value)
				--make sure value is entered
				local text = strtrim(value)
				if(string.len(text) == 0) then
					return "Value required"
				end
				
				--check for duplicates
				for k, v in ipairs(dbp.views) do
					if v.name == text and profile.name ~= text then
						return "Container name exists"
					end
				end
				
				return true
			end,
			set = function(info, value)
				local oldname = view.name
				local text = strtrim(value)
				--update profile
				profile.name = text
				--update display value
				view.name = text
				
				--notify the view that the name changed
				local module = VIEW_MODULES[view]
				local func = module.OnViewNameChanged
				if func and type(func) == "function" then
					module:OnViewNameChanged(view, oldname, view.name)
				end
				
				mod:UpdateOptionsTable()
				UI:BlizOptionsTable_ViewManager()
				
				--select the new container back in the general tab
				LIB_AceConfigDialog:SelectGroup(Hermes.HERMES_VERSION_STRING, "UI", "viewgeneral", profile.name)
			end,
		},
		spacer1 = {
			type = "description",
			name = "",
			width = "full",
			order = 10,
		},
		viewsetup = {
			type = "group",
			inline = true,
			name = "",
			order = 15,
			args = {
				list = {
					type = "select",
					name = L["View"],
					width = "double",
					order = 5,
					get = function()
						if LAST_SELECTED_MODULE then
							return LAST_SELECTED_MODULE
						else
							return profile.module
						end
					end,
					values = function()
						local modules = {}
						for name, m in mod:IterateModules() do
							if name == profile.module then
								modules[name] = "|cFF00FF00"..m:GetViewDisplayName().."|r"
							else
								modules[name] = m:GetViewDisplayName()
							end
						end
						return modules
					end,
					set = function(info, name)
						LAST_SELECTED_MODULE = name
						self:UpdateViewOptions()
					end,
				},
				spacer1 = {
					type = "description",
					name = "",
					width = "full",
					order = 10,
				},
				apply = {
					type = "execute",
					name = L["Apply"],
					width = "double",
					order = 15,
					disabled = profile.module == LAST_SELECTED_MODULE or LAST_SELECTED_MODULE == nil,
					func = function()
						self:ChangeViewModule(view, LAST_SELECTED_MODULE)
						LAST_SELECTED_MODULE = nil
						self:UpdateViewOptions()
					end,
				},
				spacer2 = {
					type = "description",
					name = "",
					width = "full",
					order = 20,
				},
				description = {
					type = "group",
					inline = true,
					order = 25,
					name = L["View Description"],
					args = {
						description = {
							type = "description",
							name = module:GetViewDisplayDescription() or L["No description provided"],
							width = "full",
							fontSize = "medium",
							order = 5,
						},
					},
				},
			},
		},
	}
end

function mod:UpdateViewModuleTable()
	if blizzArgs.viewmodule.args then
		wipe(blizzArgs.viewmodule.args)
	end
	
	self:CheckLastSelectedView()
	
	--don't show if no selected view or the selected view isn't enabled
	if not SELECTED_VIEW or not SELECTED_VIEW.view then
		blizzArgs.viewmodule.disabled = true
		blizzArgs.viewmodule.args = {
			empty = {
				type = "description",
				name = "",
				order = 5,
				width = "full",
			},
		}
		
		return
	end
	
	local view = SELECTED_VIEW.view
	local module = VIEW_MODULES[view]
	
	--get options from the module
	blizzArgs.viewmodule.disabled = false
	blizzArgs.viewmodule.args = module:GetViewOptionsTable(view)
	
	--module may have returned nil, set to real value
	if not blizzArgs.viewmodule.args then
		blizzArgs.viewmodule.args = {}
	end
end

function mod:UpdateViewOptions()
	self:UpdateViewGeneralTable()
	self:UpdateViewModuleTable()
	self:UpdateViewSpellsTable()
	self:UpdateViewPlayerFiltersTable()
end

function mod:SortProfileViews()
	sort(dbp.views,
		function(a, b)
			return a.name < b.name
		end
	)
end

local nameSelection = {}
function mod:UpdateNameSelection()
	--setup name selection table
	if nameSelection then
		wipe(nameSelection)
	end
	
	for index, profile in ipairs(dbp.views) do
		tinsert(nameSelection, profile.name)
	end
	tinsert(nameSelection, "|cFF00FF00"..L["New Container"].."|r")
	
	if SELECTED_VIEW then
		tinsert(nameSelection, "|cFF00FF00"..L["Copy"].." "..SELECTED_VIEW.profile.name.."|r")
	end
end

function mod:UpdateOptionsTable()
	if blizzArgs then
		wipe(blizzArgs)
	end
	
	if self:GetFirstViewModule() == nil then
		blizzArgs = {
			nomodules = {
				type = "description",
				name = "No views are available, you must have at least one view addon enabled.",
				order = 5,
				width = "full",
				fontSize = "medium",
			},
		}
	
		return
	end
	
	self:CheckLastSelectedView()
	
	if Hermes:IsReceiving() == false then
		blizzArgs = {
			empty = {
				type = "description",
				fontSize = "medium",
				name = L["Hermes must be actively Receiving or in Config mode to change UI settings. Config Mode can be turned on in the General tab of Hermes."],
				order = 5,
				width = "full",
			},
		}
		return
	end
	
	self:UpdateNameSelection()
	
	blizzArgs = {
		viewselection = {
			type = "select",
			name = L["Containers"],
			width = "normal",
			order = 5,
			get = function()
				if SELECTED_VIEW then
					if not SELECTED_VIEW.profile then error("error") end
					return _findTableIndex(nameSelection, SELECTED_VIEW.profile.name)
				end
			end,
			values = function()
				return nameSelection
			end,
			set = function(info, index)
				local name = nameSelection[index]
				if index > #dbp.views then
					if index == #dbp.views + 1 then -- add
						--generate a unique name for the container
						local name = self:GenerateUniqueViewName(L["Container"].." ")
							
						--clone defaults for the container
						local db = mod:GetNewViewDefaults()
							
						--make sure to set the view name!!
						db.name = name
							
						--add view db values to profile
						tinsert(dbp.views, db)
							
						--add container to display, need to copy the defaults again due to profile changes
						local view = self:CreateView(db)
							
						if not SELECTED_VIEW then
							SELECTED_VIEW = {}
						end
							
						SELECTED_VIEW.profile = db
						SELECTED_VIEW.view = view
						
						--since this view did not previously exist, we need to manually add all the senders, abilities, and instances to it.
						--although in the case of a new view, no abilities will get added.
						if Hermes:IsReceiving() == true then
							self:SyncViewWithReceivingState(view)
						end
						
						--force the config window to update with latest view added
						self:UpdateOptionsTable()
						UI:BlizOptionsTable_ViewManager()
					elseif index == #dbp.views + 2 then --copy
						--generate a unique name for the container
						local sourceDB = dbp.views[_findTableIndex(dbp.views, SELECTED_VIEW.profile)]
						local name = self:GenerateUniqueViewName(sourceDB.name.." ")
						
						--clone defaults for the container
						local db = _deepcopy(sourceDB)

						--make sure to set the view name!!
						db.name = name
						
						--CODESMELL: this step is something I'm not sure about, but doing it anyway. The purpose is to reset the location so
						--that it doesn't completely overlap the old bar. There's no guarantee that views even use this,
						--but I'll have to personally remember that I do this for my views.
						for moduleName, profile in pairs(db.profiles) do
							profile.w = nil
							profile.h = nil
							profile.x = nil
							profile.y = nil
						end
							
						--add view db values to profile
						tinsert(dbp.views, db)
							
						--add container to display, need to copy the defaults again due to profile changes
						local view = self:CreateView(db)
							
						if not SELECTED_VIEW then
							SELECTED_VIEW = {}
						end
							
						SELECTED_VIEW.profile = db
						SELECTED_VIEW.view = view
						
						-- since this view did not previously exist, we need to manually add all the senders, abilities, and instances to it
						if Hermes:IsReceiving() == true then
							self:SyncViewWithReceivingState(view)
						end
					
						--force the config window to update with latest view added
						self:UpdateOptionsTable()
						UI:BlizOptionsTable_ViewManager()
					end
				else
					if not SELECTED_VIEW then error("error") end -- error checking
					--user switched from one view to another
					SELECTED_VIEW.profile = nil
					SELECTED_VIEW.view = nil
					
					--view may or may not be enabled and thus may or may not exist
					for _, profile in ipairs(dbp.views) do
						if profile.name == name then
							--we found the profile
							SELECTED_VIEW.profile = profile
							if profile.enabled == true then
								--an enabled view should exist
								for view, p in pairs(VIEW_PROFILES) do
									if p == profile then
										SELECTED_VIEW.view = view
										self:UpdateViewOptions()
										self:UpdateNameSelection()
										return
									end
								end
							else
								SELECTED_VIEW.view = nil
								self:UpdateViewOptions()
								self:UpdateNameSelection()
								return
							end
						end
					end

					--error catching
					error("error")
				end
				
				LAST_SELECTED_MODULE = nil --force the module selection to grab the module of the view
			end,
		},
		enabled = {
			type = "toggle",
			name = L["Enabled"],
			order = 10,
			width = "normal",
			disabled = SELECTED_VIEW == nil,
			get = function()
				--only return true if a view is selected that is enabled
				if SELECTED_VIEW then
					if SELECTED_VIEW.profile == nil then error("error") end -- error checking
					return SELECTED_VIEW.profile.enabled
				end
				
				--if selected view name is nil or table is nil then set to false, as it's disabled
				return false
			end,
			set = function(info, value)
				if not SELECTED_VIEW then error("error") end -- error checking
				
				if value == true then
					--enabling a view that was disabled
					if SELECTED_VIEW.view ~= nil then error("error") end --error checking
					if SELECTED_VIEW.profile == nil then error("error") end --error checking
					if SELECTED_VIEW.profile.enabled ~= false then error("error") end --error checking
					
					SELECTED_VIEW.profile.enabled = true
					SELECTED_VIEW.view = self:CreateView(SELECTED_VIEW.profile)
					
					-- since this view did not previously exist, we need to manually add all the abilities and instances to it
					if Hermes:IsReceiving() == true then
						self:SyncViewWithReceivingState(SELECTED_VIEW.view)
					end
				else
					--disabling a view that was enabled
					if SELECTED_VIEW.view == nil then error("error") end --error checking
					if SELECTED_VIEW.profile == nil then error("error") end --error checking
					
					SELECTED_VIEW.profile.enabled = false
					self:ReleaseView(SELECTED_VIEW.view)
					
					--reset selected view so that we know it's disabled
					SELECTED_VIEW.view = nil
				end
				
				--now update the options
				self:UpdateViewOptions()
			end,
		},
		delete = {
			type = "execute",
			name = L["Delete"],
			width = "normal",
			order = 15,
			confirm = function() return L["Container and it's settings will be deleted permanently. Continue?"] end,
			disabled = SELECTED_VIEW == nil,
			func = function()
				if SELECTED_VIEW == nil then error("error") end --error checking
				if SELECTED_VIEW.profile == nil then error("error") end --error checking
				
				--remove the view's profile
				for key, dbc in ipairs(dbp.views) do
					if dbc == SELECTED_VIEW.profile then
						tremove(dbp.views, key)
						break
					end
				end
				
				--the view may or may not be enabled, thus may or may not have table
				if SELECTED_VIEW.profile.enabled == true then
					if SELECTED_VIEW.view == nil then error("error") end --error checking
					--release the view, only needed for enabled views
					self:ReleaseView(SELECTED_VIEW.view)
				else
					if SELECTED_VIEW.view ~= nil then error("error") end --error checking
				end
				
				--reset last selected view
				SELECTED_VIEW = nil
				
				--update config display
				mod:UpdateOptionsTable()
				UI:BlizOptionsTable_ViewManager()
			end,
		},
		viewgeneral = {
			name = L["Container"],
			type = "group",
			order = 20,
			inline = false,
			args = {
			
			},
		},
		viewspells = {
			name = L["Spells"],
			type = "group",
			order = 25,
			inline = false,
			args = {
			
			},
		},
		viewmodule = {
			name = L["View Settings"],
			type = "group",
			order = 30,
			inline = false,
			args = {
			
			},
		},
		playerfilters = {
			name = L["Player Filters"],
			type = "group",
			order = 35,
			inline = false,
			args = {
			
			},
		},
	}
	
	self:UpdateViewOptions()
end

function mod:GetOptionsTable()
	return blizzArgs
end



