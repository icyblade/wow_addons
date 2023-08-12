--[[

]]--

local AddonName, mod = ...
local Hermes = LibStub("AceAddon-3.0"):GetAddon("Hermes")
local LIB_AceAddon = LibStub("AceAddon-3.0") or error("Required library AceAddon-3.0 not found")
local LIB_AceDB = LibStub("AceDB-3.0") or error("Required library AceDB-3.0 not found")
_G[AddonName] = LIB_AceAddon:NewAddon(mod, AddonName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local LIB_AceConfig = LibStub("AceConfig-3.0") or error("Required library AceConfig-3.0 not found")
local LIB_AceConfigDialog = LibStub("AceConfigDialog-3.0")  or error("Required library AceConfigDialog-3.0 not found")
local L = LibStub('AceLocale-3.0'):GetLocale('Hermes-UI')

local dbp
local ViewManager
local optionTables = nil

function mod:OnSetHermesPluginProfile(dbplugins)
	if not dbplugins[AddonName] then
		dbplugins[AddonName] = self:GetDefaultOptions()
		
		--create a default container for new profiles
		local defaultView = ViewManager:GetNewViewDefaults()
		defaultView.name = L["Default"]
		defaultView.includeAll = true --have the default view watch all spells
		tinsert(dbplugins[AddonName].views, defaultView)
	end
	
	dbp = dbplugins[AddonName]
	ViewManager:SetProfile(dbp)
end

function mod:OnEnable() --OnSetHermesPluginProfile is always called before OnEnable is called
	--provide events for starting and stopping receiving, which is when we'll want to show the UI
	Hermes:RegisterHermesEvent("OnStartReceiving", AddonName, function() self:OnStartReceiving() end)
	Hermes:RegisterHermesEvent("OnStopReceiving", AddonName, function() self:OnStopReceiving() end)
	Hermes:RegisterHermesEvent("OnInventorySpellAdded", AddonName, function(id) ViewManager:OnInventorySpellAdded(id) end)
	Hermes:RegisterHermesEvent("OnInventoryItemAdded", AddonName, function(id) ViewManager:OnInventoryItemAdded(id) end)
	Hermes:RegisterHermesEvent("OnInventorySpellRemoved", AddonName, function(id) ViewManager:OnInventorySpellRemoved(id) end)
	Hermes:RegisterHermesEvent("OnInventoryItemRemoved", AddonName, function(id) ViewManager:OnInventoryItemRemoved(id) end)
	Hermes:RegisterHermesEvent("OnInventorySpellChanged", AddonName, function(id) ViewManager:OnInventorySpellChanged(id) end)
	Hermes:RegisterHermesEvent("OnInventoryItemChanged", AddonName, function(id) ViewManager:OnInventoryItemChanged(id) end)
	
	--Enable the ViewManager
	ViewManager:Enable()
	
	--rebuild the options table
	self:UpdateBlizzOptionsTable()
end

function mod:OnDisable()
	Hermes:UnregisterHermesEvent("OnStartReceiving", AddonName)
	Hermes:UnregisterHermesEvent("OnStopReceiving", AddonName)
	Hermes:UnregisterHermesEvent("OnInventorySpellAdded", AddonName)
	Hermes:UnregisterHermesEvent("OnInventoryItemAdded", AddonName)
	Hermes:UnregisterHermesEvent("OnInventorySpellRemoved", AddonName)
	Hermes:UnregisterHermesEvent("OnInventoryItemRemoved", AddonName)
	Hermes:UnregisterHermesEvent("OnInventorySpellChanged", AddonName)
	Hermes:UnregisterHermesEvent("OnInventoryItemChanged", AddonName)
	
	self:OnStopReceiving()
	ViewManager:Disable()
end

function mod:OnStartReceiving()
	ViewManager:UpdateOptionsTable()
	self:UpdateBlizzOptionsTable()
	ViewManager:Start()
	--start capturing events
	self:HookEvents(true)
end

function mod:OnStopReceiving()
	self:HookEvents(false)
	ViewManager:UpdateOptionsTable()
	self:UpdateBlizzOptionsTable()
	ViewManager:Stop()
end

function mod:OnInitialize()
	--be default, do not enable this addon until hermes enables it
	self:SetEnabledState(false)
	
	--we'll need a reference to this all the time
	ViewManager = self:GetModule("ViewManager")
	
	--register as Hermes plugin
	Hermes:RegisterHermesPlugin(
		"UI",
		function () self:Enable() end,
		function () self:Disable() end,
		function (dbplugins) self:OnSetHermesPluginProfile(dbplugins) end,
		function () return self:GetBlizzOptionsTable() end
	)
end

function mod:HookEvents(hook)
	if hook and hook == true then
		Hermes:RegisterHermesEvent("OnSenderAdded", AddonName, function(sender) ViewManager:OnSenderAdded(sender) end)
		Hermes:RegisterHermesEvent("OnSenderRemoved", AddonName, function(sender) ViewManager:OnSenderRemoved(sender) end)
		Hermes:RegisterHermesEvent("OnSenderVisibilityChanged", AddonName, function(sender) ViewManager:OnSenderVisibilityChanged(sender) end)
		Hermes:RegisterHermesEvent("OnSenderOnlineChanged", AddonName, function(sender) ViewManager:OnSenderOnlineChanged(sender) end)
		Hermes:RegisterHermesEvent("OnSenderDeadChanged", AddonName, function(sender) ViewManager:OnSenderDeadChanged(sender) end)
		--Hermes:RegisterHermesEvent("OnSenderAvailabilityChanged", AddonName, function(sender) ViewManager:OnSenderAvailabilityChanged(sender) end)
		
		--Hermes:RegisterHermesEvent("OnPlayerGroupStatusChanged", AddonName, function(isInGroup) vm:OnPlayerGroupStatusChanged(isInGroup) end)
		
		Hermes:RegisterHermesEvent("OnAbilityAdded", AddonName, function(ability) ViewManager:OnAbilityAdded(ability) end)
		Hermes:RegisterHermesEvent("OnAbilityRemoved", AddonName, function(ability) ViewManager:OnAbilityRemoved(ability) end)
		Hermes:RegisterHermesEvent("OnAbilityAvailableSendersChanged", AddonName, function(ability) ViewManager:OnAbilityAvailableSendersChanged(ability) end)
		Hermes:RegisterHermesEvent("OnAbilityTotalSendersChanged", AddonName, function(ability) ViewManager:OnAbilityTotalSendersChanged(ability) end)
		
		Hermes:RegisterHermesEvent("OnAbilityInstanceAdded", AddonName, function(instance) ViewManager:OnInstanceAdded(instance) end)
		Hermes:RegisterHermesEvent("OnAbilityInstanceRemoved", AddonName, function(instance) ViewManager:OnInstanceRemoved(instance)end)
		Hermes:RegisterHermesEvent("OnAbilityInstanceStartCooldown", AddonName, function(instance) ViewManager:OnInstanceStartCooldown(instance) end)
		Hermes:RegisterHermesEvent("OnAbilityInstanceUpdateCooldown", AddonName, function(instance) ViewManager:OnInstanceUpdateCooldown(instance) end)
		Hermes:RegisterHermesEvent("OnAbilityInstanceStopCooldown", AddonName, function(instance) ViewManager:OnInstanceStopCooldown(instance) end)
		Hermes:RegisterHermesEvent("OnAbilityInstanceAvailabilityChanged", AddonName, function(instance) ViewManager:OnInstanceAvailabilityChanged(instance) end)

	else
		Hermes:UnregisterHermesEvent("OnSenderAdded", AddonName)
		Hermes:UnregisterHermesEvent("OnSenderRemoved", AddonName)
		Hermes:UnregisterHermesEvent("OnSenderVisibilityChanged", AddonName)
		Hermes:UnregisterHermesEvent("OnSenderOnlineChanged", AddonName)
		Hermes:UnregisterHermesEvent("OnSenderDeadChanged", AddonName)
		--Hermes:UnregisterHermesEvent("OnSenderAvailabilityChanged", AddonName)
		
		--Hermes:UnregisterHermesEvent("OnPlayerGroupStatusChanged", AddonName)
		
		Hermes:UnregisterHermesEvent("OnAbilityAdded", AddonName)
		Hermes:UnregisterHermesEvent("OnAbilityRemoved", AddonName)
		Hermes:UnregisterHermesEvent("OnAbilityAvailableSendersChanged", AddonName)
		Hermes:UnregisterHermesEvent("OnAbilityTotalSendersChanged", AddonName)
		
		Hermes:UnregisterHermesEvent("OnAbilityInstanceAdded", AddonName)
		Hermes:UnregisterHermesEvent("OnAbilityInstanceRemoved", AddonName)
		Hermes:UnregisterHermesEvent("OnAbilityInstanceStartCooldown", AddonName)
		Hermes:UnregisterHermesEvent("OnAbilityInstanceUpdateCooldown", AddonName)
		Hermes:UnregisterHermesEvent("OnAbilityInstanceStopCooldown", AddonName)
		Hermes:UnregisterHermesEvent("OnAbilityInstanceAvailabilityChanged", AddonName)
	end
end

--------------------------------------------------------------
-- OPTIONS
--------------------------------------------------------------
function mod:GetDefaultOptions()
	local defaults = {
		views = {

		},
	}
	
	return defaults
end

function mod:GetBlizzOptionsTable()
	return optionTables
end

function mod:UpdateBlizzOptionsTable()
	if not optionTables then
		optionTables = {
			name = "UI",
			type="group",
			childGroups="tab",
			inline = false,
		}
	end

	self:BlizOptionsTable_ViewManager()
end

function mod:BlizOptionsTable_ViewManager()
	if optionTables.args then
		wipe(optionTables.args)
	end
	optionTables.args = ViewManager:GetOptionsTable()
end

