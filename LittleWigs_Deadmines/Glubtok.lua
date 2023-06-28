-------------------------------------------------------------------------------
--  Module Declaration

local mod = BigWigs:NewBoss("Glubtok", 756)
if not mod then return end
mod.partyContent = true
mod:RegisterEnableMob(47162)
mod.toggleOptions = {
	"phase",
	"bosskill",
}

-------------------------------------------------------------------------------
--  Localization

local L = mod:NewLocale("enUS", true)
if L then

L["phase"] = "Phases"
L["phase_desc"] = "Warn for phase changes."
L["phase_warning"] = "Phase 2 soon!"

end
L = mod:GetLocale()

-------------------------------------------------------------------------------
--  Initialization

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_HEALTH")

	self:Death("Win", 47162)
end

function mod:VerifyEnable()
	if GetInstanceDifficulty() == 2 then return true end
end

-------------------------------------------------------------------------------
--  Event Handlers

function mod:UNIT_HEALTH(_, unit)
	if unit ~= "boss1" then return end
	if UnitName(unit) == self.displayName then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		if hp <= 53 then
			self:Message("phase", L["phase_warning"], "Attention")
			self:UnregisterEvent("UNIT_HEALTH")
		end
	end
end

