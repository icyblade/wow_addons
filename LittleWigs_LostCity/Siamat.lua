-------------------------------------------------------------------------------
--  Module Declaration

local mod = BigWigs:NewBoss("Siamat", 747)
if not mod then return end
mod.partyContent = true
mod:RegisterEnableMob(44819)
mod.toggleOptions = {
	"servant",
	"phase",
	"bosskill",
}

-------------------------------------------------------------------------------
--  Locals

local adds = 0

-------------------------------------------------------------------------------
--  Localization

local L = mod:NewLocale("enUS", true)
if L then

L["engage_trigger"] = "Winds of the south, rise and come to your master's aid!"
L["phase"] = "Phase 2"
L["phase_desc"] = "Warn when Siamat is close to phase 2."
L["phase_warning"] = "Phase 2 soon!"
L["servant"] = "Summon Servant"
L["servant_desc"] = "Warn when a Servant of Siamat is summoned."
L["servant_message"] = "Servant of Siamat Summoned!"

end
L = mod:GetLocale()

-------------------------------------------------------------------------------
--  Initialization

function mod:OnBossEnable()
	self:Log("SPELL_SUMMON", "Servant", 90014, 90013, 84553)
	self:Yell("Engage", L["engage_trigger"])

	self:Death("Win", 44819)
end

function mod:OnEngage()
	adds = 0
end

-------------------------------------------------------------------------------
--  Event Handlers

function mod:Servant(_, spellId)
	adds = adds + 1
	if adds == 3 then
		self:Message("phase", L["phase_warning"], "Attention")
		adds = 0
	end
	self:Message("servant", L["servant_message"], "Important", spellId, "Alert")
end

