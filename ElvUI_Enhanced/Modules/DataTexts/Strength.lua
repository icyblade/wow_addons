local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local EE = E:GetModule("ElvUI_Enhanced")

local select = select
local join = string.join

local STRENGTH_COLON = STRENGTH_COLON
local ITEM_MOD_STRENGTH_SHORT = ITEM_MOD_STRENGTH_SHORT

local displayNumberString = ""
local lastPanel

local function OnEvent(self)
	self.text:SetFormattedText(displayNumberString, STRENGTH_COLON, select(2, UnitStat("player", 1)))
	lastPanel = self
end

local function ValueColorUpdate(hex)
	displayNumberString = join("", "%s ", hex, "%.f|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("Strength", {"UNIT_STATS", "UNIT_AURA", "FORGE_MASTER_ITEM_CHANGED", "ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_TALENT_UPDATE"}, OnEvent, nil, nil, nil, nil, EE:ColorizeSettingName(ITEM_MOD_STRENGTH_SHORT))
