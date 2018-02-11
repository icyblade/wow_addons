local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local mod = E:GetModule('NamePlates')

--Cache global variables
--Lua functions
--WoW API / Variables
local UnitClassification = UnitClassification

function mod:UpdateElement_Elite(frame)
	if not self.db.units[frame.UnitType].eliteIcon then return; end

	local icon = frame.Elite
	if self.db.units[frame.UnitType].eliteIcon.enable then
		local c = UnitClassification(frame.unit)
		if c == 'elite' or c == "worldboss" then
			icon:SetTexCoord(0, 0.15, 0.35, 0.63)
			icon:Show()
		elseif c == 'rareelite' or c == 'rare' then
			icon:SetTexCoord(0, 0.15, 0.63, 0.91)
			icon:Show()
		else
			icon:Hide()
		end
	else
		icon:Hide()
	end
end

function mod:ConfigureElement_Elite(frame)
	if not self.db.units[frame.UnitType].eliteIcon then return; end

	local icon = frame.Elite
	local size = self.db.units[frame.UnitType].eliteIcon.size
	local position = self.db.units[frame.UnitType].eliteIcon.position

	icon:SetSize(size,size)
	icon:ClearAllPoints()

	if frame.HealthBar:IsShown() then
		icon:SetParent(frame.HealthBar)
		icon:SetPoint(position, frame.HealthBar, position, self.db.units[frame.UnitType].eliteIcon.xOffset, self.db.units[frame.UnitType].eliteIcon.yOffset)
	else
		icon:SetParent(frame)
		icon:SetPoint(position, frame, position, self.db.units[frame.UnitType].eliteIcon.xOffset, self.db.units[frame.UnitType].eliteIcon.yOffset)
	end
end

function mod:ConstructElement_Elite(frame)
	local icon = frame.HealthBar:CreateTexture(nil, "OVERLAY")
	icon:SetTexture("Interface\\TARGETINGFRAME\\Nameplates")
	icon:Hide()

	return icon
end