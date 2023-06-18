local E, L, V, P, G = unpack(ElvUI)
local TI = E:NewModule("Enhanced_TooltipIcon", "AceHook-3.0")

local _G = _G
local select, type = select, type
local find, match = string.find, string.match

local GetAchievementInfo = GetAchievementInfo
local GetItemIcon = GetItemIcon
local GetSpellInfo = GetSpellInfo

local itemTooltips = {
	GameTooltip,
	ItemRefTooltip,
	ShoppingTooltip1,
	ShoppingTooltip2
}

local spellTooltips = {
	GameTooltip,
	ItemRefTooltip
}

local function AddIcon(self, icon)
	if not icon then return end

	local title = _G[self:GetName().."TextLeft1"]
	local text = title and title:GetText()

	if text and not find(text, "|T"..icon) then
		title:SetFormattedText("|T%s:30:30:0:0:64:64:5:59:5:59|t %s", icon, text)
	end
end

local function ItemIcon(self)
	local _, link = self:GetItem()
	local icon = link and GetItemIcon(link)
	AddIcon(self, icon)
end

local function SpellIcon(self)
	local id = self:GetSpell()
	if id then
		AddIcon(self, select(3, GetSpellInfo(id)))
	end
end

local function AchievementIcon(self, link)
	if type(link) ~= "string" then return end

	local linkType, id = match(link, "^([^:]+):(%d+)")
	if id and (linkType == "achievement") then
		AddIcon(self, select(10, GetAchievementInfo(id)))
	end
end

function TI:ToggleItemsState()
	local state = E.db.enhanced.tooltip.tooltipIcon.tooltipIconItems and E.db.enhanced.tooltip.tooltipIcon.enable

	for _, tooltip in ipairs(itemTooltips) do
		if state then
			if not self:IsHooked(tooltip, "OnTooltipSetItem", ItemIcon) then
				self:SecureHookScript(tooltip, "OnTooltipSetItem", ItemIcon)
			end
		else
			self:Unhook(tooltip, "OnTooltipSetItem")
		end
	end
end

function TI:ToggleSpellsState()
	local state = E.db.enhanced.tooltip.tooltipIcon.tooltipIconSpells and E.db.enhanced.tooltip.tooltipIcon.enable

	for _, tooltip in ipairs(spellTooltips) do
		if state then
			if not self:IsHooked(tooltip, "OnTooltipSetSpell", SpellIcon) then
				self:SecureHookScript(tooltip, "OnTooltipSetSpell", SpellIcon)
			end
		else
			self:Unhook(tooltip, "OnTooltipSetSpell")
		end
	end
end

function TI:ToggleAchievementsState()
	local state = E.db.enhanced.tooltip.tooltipIcon.tooltipIconAchievements and E.db.enhanced.tooltip.tooltipIcon.enable

	if state then
		if not self:IsHooked(GameTooltip, "SetHyperlink", AchievementIcon) then
			self:SecureHook(GameTooltip, "SetHyperlink", AchievementIcon)
		end
	else
		self:Unhook(GameTooltip, "SetHyperlink")
	end
end

function TI:Initialize()
	if not E.db.enhanced.tooltip.tooltipIcon.enable then return end

	self:ToggleItemsState()
	self:ToggleSpellsState()
	self:ToggleAchievementsState()
end

local function InitializeCallback()
	TI:Initialize()
end

E:RegisterModule(TI:GetName(), InitializeCallback)