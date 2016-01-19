--[[
	Copyright (c) 2009-2015, Hendrik "Nevcairiel" Leppkes < h.leppkes at gmail dot com >
	All rights reserved.
]]
print(1)
local _, Bartender4 = ...
local L = LibStub("AceLocale-3.0"):GetLocale("Bartender4")

-- fetch upvalues
local Bar = Bartender4.Bar.prototype

local table_insert, setmetatable = table.insert, setmetatable

-- GLOBALS: ArtifactWatchBar

local defaults = { profile = Bartender4:Merge({
	enabled = false,
}, Bartender4.Bar.defaults) }

-- register module
local ABarMod = Bartender4:NewModule("ABar", "AceHook-3.0")

-- create prototype information
local ABar = setmetatable({}, {__index = Bar})

function ABarMod:OnInitialize()
	self.db = Bartender4.db:RegisterNamespace("ABar", defaults)
	self:SetEnabledState(self.db.profile.enabled)
end

function ABarMod:OnEnable()
	if not self.bar then
		self.bar = setmetatable(Bartender4.Bar:Create("ArtiBar", self.db.profile, L["Artifact Bar"]), {__index = ABar})
		self.bar.content = ArtifactWatchBar

		self.bar.content:SetParent(self.bar)
		self.bar.content:SetFrameLevel(self.bar:GetFrameLevel() + 1)
	end
	self:SecureHook("ArtifactBar_Update")
	self.bar:Enable()
	self:ToggleOptions()
	self:ApplyConfig()
end

function ABarMod:ApplyConfig()
	self.bar:ApplyConfig(self.db.profile)
end

function ABarMod:ArtifactBar_Update()
	self.bar:PerformLayout()
end

function ABar:ApplyConfig(config)
	Bar.ApplyConfig(self, config)

	self:PerformLayout()
end

ABar.width = 1033
ABar.height = 17
ABar.offsetX = 5
function ABar:PerformLayout()
	self:SetSize(self.width, self.height)
	local bar = self.content
	bar:ClearAllPoints()
	bar:SetPoint("TOPLEFT", self, "TOPLEFT", self.offsetX, -3)
end

ABar.ClickThroughSupport = true
function ABar:ControlClickThrough()
	self.content:EnableMouse(not self.config.clickthrough)
end

