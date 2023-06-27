local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local EDC = E:NewModule("Enhanced_DataTextColors", "AceEvent-3.0")

function EDC:ColorFont()
	local db = E.db.enhanced.datatexts.dataTextColors
	local classColor = E:ClassColor(E.myclass)
	local defaultColor = E.db.general.valuecolor

	for panelName, panel in pairs(DT.RegisteredPanels) do
		for i = 1, panel.numPoints do
			local pointIndex = DT.PointLocation[i]

			if db.colorType == "CLASS" then
				panel.dataPanels[pointIndex].text:SetTextColor(classColor.r, classColor.g, classColor.b)
			elseif db.colorType == "CUSTOM" then
				panel.dataPanels[pointIndex].text:SetTextColor(db.color.r, db.color.g, db.color.b)
			else
				panel.dataPanels[pointIndex].text:SetTextColor(defaultColor.r, defaultColor.g, defaultColor.b)
			end
		end
	end
end

function EDC:PLAYER_ENTERING_WORLD()
	self:ColorFont()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function EDC:Initialize()
	if not E.private.enhanced.dataTextColors then return end

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

local function InitializeCallback()
	EDC:Initialize()
end

E:RegisterModule(EDC:GetName(), InitializeCallback)