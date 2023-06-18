local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local split = string.split

local function LoadSkin()
	if not E.private.addOnSkins.PetJournal_QuickFilter then return end

	for i = 1, 10 do
		local button = _G["PetJournalQuickFilterButton"..i]
		local texture = button.Icon:GetTexture()

		button:StripTextures()
		button:SetTemplate(nil, true)
		button:StyleButton()
		button:ClearAllPoints()

		if i == 1 then
			button:Point("TOPLEFT", 0, -33)
		else
			button:Point("LEFT", _G["PetJournalQuickFilterButton"..i - 1], "RIGHT", 2, 0)
		end

		local _, petType = split("-", texture, 2)
		button.Icon:SetTexture(E.Media.BattlePetTypes[petType])
		button.Icon:SetTexCoord(0, 1, 0, 1)
		button.Icon:Size(18)
	end
end

S:AddCallbackForAddon("PetJournal_QuickFilter", "PetJournal_QuickFilter", LoadSkin)