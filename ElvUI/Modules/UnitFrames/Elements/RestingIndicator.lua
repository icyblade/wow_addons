local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")

local DEFAULT = [[Interface\CharacterFrame\UI-StateIcon]]

function UF:Construct_RestingIndicator(frame)
	return frame.RaisedElementParent.TextureParent:CreateTexture(nil, "OVERLAY")
end

function UF:Configure_RestingIndicator(frame)
	if not frame.VARIABLES_SET then return end

	local Icon = frame.RestingIndicator
	local db = frame.db.RestIcon

	if db.enable then
		if not frame:IsElementEnabled("RestingIndicator") then
			frame:EnableElement("RestingIndicator")
		end

		if db.defaultColor then
			Icon:SetVertexColor(1, 1, 1, 1)
			Icon:SetDesaturated(false)
		else
			Icon:SetVertexColor(db.color.r, db.color.g, db.color.b, db.color.a)
			Icon:SetDesaturated(true)
		end

		if db.texture == "CUSTOM" and db.customTexture then
			Icon:SetTexture(db.customTexture)
			Icon:SetTexCoord(0, 1, 0, 1)
		elseif db.texture ~= "DEFAULT" and E.Media.RestIcons[db.texture] then
			Icon:SetTexture(E.Media.RestIcons[db.texture])
			Icon:SetTexCoord(0, 1, 0, 1)
		else
			Icon:SetTexture(DEFAULT)
			Icon:SetTexCoord(0, 0.5, 0, 0.421875)
		end

		Icon:Size(db.size)
		Icon:ClearAllPoints()
		if frame.ORIENTATION ~= "RIGHT" and (frame.USE_PORTRAIT and not frame.USE_PORTRAIT_OVERLAY) then
			Icon:Point("CENTER", frame.Portrait, db.anchorPoint, db.xOffset, db.yOffset)
		else
			Icon:Point("CENTER", frame.Health, db.anchorPoint, db.xOffset, db.yOffset)
		end
	elseif frame:IsElementEnabled("RestingIndicator") then
		frame:DisableElement("RestingIndicator")
	end
end