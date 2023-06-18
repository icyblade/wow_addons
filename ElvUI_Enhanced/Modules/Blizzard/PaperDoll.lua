local E, L, V, P, G = unpack(ElvUI)
local mod = E:GetModule("Enhanced_Blizzard")

function mod:UpdateCharacterModelFrame()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.character then return end

	local db = E.db.enhanced.blizzard.backgrounds

	for _, corner in pairs({"TopLeft", "TopRight", "BotLeft", "BotRight", "Overlay"}) do
		local bg = _G["CharacterModelFrameBackground"..corner]

		if bg then
			bg:SetShown(db.characterBackground)
			bg.ignoreDesaturated = not db.characterDesaturate
		end
	end

	CharacterModelFrame.backdrop:SetShown(db.characterBackdrop)
end

function mod:UpdateInspectModelFrame()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.inspect then return end
	if not InspectModelFrame then return end
	local db = E.db.enhanced.blizzard.backgrounds

	for _, corner in pairs({"TopLeft", "TopRight", "BotLeft", "BotRight", "Overlay"}) do
		local bg = _G["InspectModelFrameBackground"..corner]

		if bg then
			bg:SetShown(db.inspectBackground)
			bg.ignoreDesaturated = not db.inspectDesaturate
		end
	end

	InspectModelFrame.backdrop:SetShown(db.inspectBackdrop)
end

function mod:PaperDollBackgrounds()
	mod:UpdateCharacterModelFrame()

	mod:RegisterEvent("ADDON_LOADED", function(event, addon)
		if addon == "Blizzard_InspectUI" then
			mod:UnregisterEvent(event)
			mod:SecureHook("InspectFrame_UpdateTabs", "UpdateInspectModelFrame")
		end
	end)
end