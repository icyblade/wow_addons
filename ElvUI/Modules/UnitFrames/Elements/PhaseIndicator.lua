local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")

function UF:PostUpdate_PhaseIcon(isInSamePhase)
	self.Center:SetShown(not isInSamePhase)
end

function UF:Construct_PhaseIcon(frame)
	local PhaseIndicator = frame.RaisedElementParent.TextureParent:CreateTexture(nil, "OVERLAY", nil, 6)
	PhaseIndicator:SetTexture(E.Media.Textures.PhaseBorder)
	PhaseIndicator:Point("CENTER", frame.Health)
	PhaseIndicator:Size(32)

	local Center = frame.RaisedElementParent.TextureParent:CreateTexture(nil, "OVERLAY", nil, 7)
	Center:SetTexture(E.Media.Textures.PhaseCenter)
	Center:Point("CENTER", frame.Health)
	Center:Size(32)
	Center:Hide()

	PhaseIndicator.Center = Center
	PhaseIndicator.PostUpdate = UF.PostUpdate_PhaseIcon

	return PhaseIndicator
end

function UF:Configure_PhaseIcon(frame)
	local PhaseIndicator = frame.PhaseIndicator
	PhaseIndicator:ClearAllPoints()
	PhaseIndicator:Point(frame.db.phaseIndicator.anchorPoint, frame.Health, frame.db.phaseIndicator.anchorPoint, frame.db.phaseIndicator.xOffset, frame.db.phaseIndicator.yOffset)

	local size = 32 * (frame.db.phaseIndicator.scale or 1)
	PhaseIndicator:Size(size)

	PhaseIndicator.Center:Size(size)
	PhaseIndicator.Center:ClearAllPoints()
	PhaseIndicator.Center:SetAllPoints(PhaseIndicator)
	PhaseIndicator.Center:SetVertexColor(frame.db.phaseIndicator.color.r, frame.db.phaseIndicator.color.g, frame.db.phaseIndicator.color.b)

	if frame.db.phaseIndicator.enable and not frame:IsElementEnabled("PhaseIndicator") then
		frame:EnableElement("PhaseIndicator")
	elseif not frame.db.phaseIndicator.enable and frame:IsElementEnabled("PhaseIndicator") then
		frame:DisableElement("PhaseIndicator")
		PhaseIndicator.Center:Hide()
	end
end