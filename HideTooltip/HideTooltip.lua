HideTooltip = LibStub("AceAddon-3.0"):NewAddon("HideTooltip", "AceEvent-3.0", "AceHook-3.0")

local isInCombat = false

function HideTooltip:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
    self:Hook(GameTooltip, "SetUnit", true)
end

function HideTooltip:PLAYER_REGEN_DISABLED()
    isInCombat = true
end

function HideTooltip:PLAYER_REGEN_ENABLED()
    isInCombat = false
end

function HideTooltip:UPDATE_MOUSEOVER_UNIT()
    if isInCombat then
		GameTooltip:Hide()
	end
end

function HideTooltip:SetUnit(tooltip, unit, anchor)
    if isInCombat then
		GameTooltip:Hide()
	end
end
