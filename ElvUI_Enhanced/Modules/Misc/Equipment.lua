local E, L, V, P, G = unpack(ElvUI)
local EQ = E:NewModule("Equipment", "AceHook-3.0", "AceEvent-3.0")

local select = select
local join = string.join

local GetEquipmentSetInfo = GetEquipmentSetInfo
local GetActiveSpecGroup = GetActiveSpecGroup
local IsInInstance = IsInInstance
local GetSpecializationInfo = GetSpecializationInfo
local GetSpecialization = GetSpecialization
local TALENT_SPEC_PRIMARY = TALENT_SPEC_PRIMARY
local TALENT_SPEC_SECONDARY = TALENT_SPEC_SECONDARY

local changingEquipmentSet = nil

function EQ:GetCurrentEquipmentSet()
	if GetNumEquipmentSets() == 0 then return false end

	for i = 1, GetNumEquipmentSets() do
		local name, _, _, isEquipped = GetEquipmentSetInfo(i)
		if isEquipped then
			return name
		end
	end

	return false
end

function EQ:CheckForGearChange()
	if InCombatLockdown() or GetNumEquipmentSets() == 0 or not self.db then return end

	local active, activeSet = GetActiveSpecGroup(), EQ:GetCurrentEquipmentSet()

	if self.db.battleground.enable then
		local inInstance, instanceType = IsInInstance()
		if inInstance and (instanceType == "pvp" or instanceType == "arena") then
			local set = self.db.equipmentset
			if set ~= "none" and set ~= activeSet then
				changingEquipmentSet = set
				UseEquipmentSet(set)
			end

			return
		end
	end

	if not GetSpecializationInfo(1) then return end

	if self.db.specialization.enable then
		local set = active == 1 and self.db.primary or self.db.secondary
		if set ~= "none" and set ~= activeSet then
			changingEquipmentSet = set
			UseEquipmentSet(set)
		end
	end
end

function EQ:UpdateTalentConfiguration()
	if not E.Options.args.equipment then return end

	local specialization = GetSpecialization(false, false, 1)
	if specialization then
		E.Options.args.equipment.args.specialization.args.primary.name = select(2, GetSpecializationInfo(specialization)) or TALENT_SPEC_PRIMARY
	end
	specialization = GetSpecialization(false, false, 2)
	if specialization then
		E.Options.args.equipment.args.specialization.args.secondary.name = select(2, GetSpecializationInfo(specialization)) or TALENT_SPEC_SECONDARY
	end
end

function EQ:EquipmentSwapFinished()
	if changingEquipmentSet then
		E:Print(join("", L["You have equipped equipment set: "], changingEquipmentSet))
		changingEquipmentSet = nil
	end
end

function EQ:Initialize()
	E.equipment = self

	self.db = E.private.equipment

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckForGearChange")
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "CheckForGearChange")
	self:RegisterEvent("CHARACTER_POINTS_CHANGED", "UpdateTalentConfiguration")
	self:RegisterEvent("PLAYER_TALENT_UPDATE", "UpdateTalentConfiguration")
	self:RegisterEvent("EQUIPMENT_SWAP_FINISHED", "EquipmentSwapFinished")

	self:UpdateTalentConfiguration()
end

local function InitializeCallback()
	EQ:Initialize()
end

E:RegisterModule(EQ:GetName(), InitializeCallback)