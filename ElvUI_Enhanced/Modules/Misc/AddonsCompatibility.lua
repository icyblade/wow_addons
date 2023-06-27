local E, L, V, P, G = unpack(ElvUI)
local AC = E:NewModule("Enhanced_AddonsCompat", "AceEvent-3.0")

local pairs, ipairs = pairs, ipairs
local type = type
local tinsert, tremove = table.insert, table.remove

local GetAddOnInfo = GetAddOnInfo
local GetNumAddOns = GetNumAddOns
local IsAddOnLoadOnDemand = IsAddOnLoadOnDemand
local IsAddOnLoaded = IsAddOnLoaded

local externalFixes = {}
local addonFixes = {}

function AC:AddAddon(addon, func)
	if type(addon) ~= "string" then
		error(string.format("bad argument #1 to 'AddAddon' (string expected, got %s)", addon ~= nil and type(addon) or "no value"), 2)
	elseif func and type(func) ~= "function" then
		error(string.format("bad argument #2 to 'AddAddon' (function expected, got %s)", func ~= nil and type(func) or "no value"), 2)
	end

	if not self.initialized then
		self.preinitList = self.preinitList or {}
		self.preinitList[addon] = func
		return
	end

	if not self.addonList[addon] then return end

	if IsAddOnLoaded(addon) then
		self:ApplyFix(addon, func)
	elseif IsAddOnLoadOnDemand(addon) then
		if not addonFixes[addon] then
			externalFixes[addon] = externalFixes[addon] or {}
			tinsert(externalFixes[addon], func)
		end

		tinsert(self.addonQueue, addon)
		self:RegisterEvent("ADDON_LOADED")
	end
end

function AC:ApplyFix(addon, func)
	if func then
		func()

		if addonFixes[addon] then
			addonFixes[addon] = nil
		end
	else
		if addonFixes[addon] then
			addonFixes[addon]()
			addonFixes[addon] = nil
		end

		if externalFixes[addon] then
			for i = 1, #externalFixes[addon] do
				externalFixes[addon][i]()
			end

			externalFixes[addon] = nil
		end
	end
end

function AC:ADDON_LOADED(_, addonName)
	if not (addonFixes[addonName] or externalFixes[addonName]) then return end

	for i, addon in ipairs(self.addonQueue) do
		if addon == addonName then
			self:ApplyFix(addon)

			tremove(self.addonQueue, i)

			if #self.addonQueue == 0 then
				self:UnregisterEvent("ADDON_LOADED")
			end

			break
		end
	end
end

function AC:Initialize()
	self.addonQueue = {}
	self.addonList = {}

	for i = 1, GetNumAddOns() do
		local name, _, _, enabled = GetAddOnInfo(i)

		if enabled or IsAddOnLoadOnDemand(i) then
			self.addonList[name] = true
		end
	end

	self.initialized = true

	for addon, func in pairs(addonFixes) do
		self:AddAddon(addon, func)
	end

	if self.preinitList then
		for addon, func in pairs(self.preinitList) do
			self:AddAddon(addon, func)
		end
	end
end

local function InitializeCallback()
	AC:Initialize()
end

E:RegisterModule(AC:GetName(), InitializeCallback)