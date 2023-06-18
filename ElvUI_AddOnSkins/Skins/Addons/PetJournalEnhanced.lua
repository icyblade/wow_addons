local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local select, unpack = select, unpack
local format = string.format

local C_PetJournal_GetPetStats = C_PetJournal.GetPetStats
local C_PetJournal_GetPetInfoByIndex = C_PetJournal.GetPetInfoByIndex
local C_PetJournal_GetPetInfoByPetID = C_PetJournal.GetPetInfoByPetID
local C_PetJournal_GetPetLoadOutInfo = C_PetJournal.GetPetLoadOutInfo

local function LoadSkin()
	if not E.private.addOnSkins.PetJournalEnhanced then return end

	local UniquePets = PetJournalEnhanced:GetModule("UniquePets")
	local Sorting = PetJournalEnhanced:GetModule("Sorting")
	local Config = PetJournalEnhanced:GetModule("Config")

	hooksecurefunc(UniquePets, "SetShown", function(_, enabled)
		PetJournal.PetCount:Point("TOPLEFT", 4, -(enabled and 16 or 25))
	end)

	PJEUniquePetCount:StripTextures()
	PJEUniquePetCount:SetTemplate("Transparent")
	PJEUniquePetCount:ClearAllPoints()
	PJEUniquePetCount:Point("TOP", PetJournal.PetCount, "BOTTOM", 0, -2)

	S:HandleButton(PetJournalEnhancedFilterButton)

	-- Scroll Frame
	PetJournalEnhancedListScrollFrame:StripTextures()
	PetJournalEnhancedListScrollFrame:CreateBackdrop("Transparent")
	PetJournalEnhancedListScrollFrame.backdrop:Point("TOPLEFT", -3, 1)
	PetJournalEnhancedListScrollFrame.backdrop:Point("BOTTOMRIGHT", 0, -2)

	S:HandleScrollBar(PetJournalEnhancedListScrollFrameScrollBar)
	PetJournalEnhancedListScrollFrameScrollBar:ClearAllPoints()
	PetJournalEnhancedListScrollFrameScrollBar:Point("TOPRIGHT", PetJournalEnhancedListScrollFrame, 23, -15)
	PetJournalEnhancedListScrollFrameScrollBar:Point("BOTTOMRIGHT", PetJournalEnhancedListScrollFrame, 0, 14)

	for i = 1, #PetJournalEnhancedListScrollFrame.buttons do
		local button = PetJournalEnhancedListScrollFrame.buttons[i]

		button:DisableDrawLayer("BACKGROUND")
		S:HandleIcon(button.icon, parent)

		button.dragButton.levelBG:SetAlpha(0)
		button.dragButton.favorite:SetParent(button.backdrop)

		button.isDead:SetTexture("Interface\\PetBattles\\DeadPetIcon")
		button.isDead:SetParent(button.backdrop)

		button.dragButton.level:SetTextColor(1, 1, 1)
		button.dragButton.level:SetParent(button.backdrop)
		button.dragButton.level:FontTemplate(nil, 12, "OUTLINE")

		button.icon:Size(40)

		S:HandleButtonHighlight(button)
		button.handledHighlight:SetInside()

		button.petTypeIcon:SetTexCoord(0, 1, 0, 1)
		button.petTypeIcon:SetAlpha(0.2)
		button.petTypeIcon:Size(46, 40)
		button.petTypeIcon:Point("BOTTOMRIGHT", 0, 3)

		for _, object in pairs({button.selectedTexture, button.dragButton.ActiveTexture}) do
			object:SetTexture(E.Media.Textures.Highlight)
			object:SetAlpha(0.35)
			object:SetInside(button)
			object:SetTexCoord(0, 1, 0, 1)
		end

		button.dragButton.ActiveTexture:SetVertexColor(1, 0.80, 0.10)
	end

	local function ColorSelectedPet()
		local petButtons = PetJournalEnhancedListScrollFrame.buttons
		local isWild = PetJournal.isWild

		for i = 1, #petButtons do
			local button = petButtons[i]
			local index = button.index
			if not index then break end

			local mappedPet = Sorting:GetPetByIndex(index)
			if not mappedPet then return end
			local petID, _, isOwned, customName, _, _, isRevoked, _, _, petType = C_PetJournal_GetPetInfoByIndex(mappedPet.index, isWild)
			button.petTypeIcon:SetTexture(E.Media.BattlePetTypes[PET_TYPE_SUFFIX[petType]])

			if isOwned then
				button.petTypeIcon:SetDesaturated(isRevoked and true or false)
			else
				button.petTypeIcon:SetDesaturated(true)
			end

			if petID ~= nil then
				local quality = select(5, C_PetJournal_GetPetStats(petID))

				if quality then
					local color = ITEM_QUALITY_COLORS[quality - 1]

					button.selectedTexture:SetVertexColor(color.r, color.g, color.b)
					button.handledHighlight:SetVertexColor(color.r, color.g, color.b)
					button.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)

					if customName then
						button.name:SetTextColor(1, 1, 1)
						button.subName:SetTextColor(color.r, color.g, color.b)
					else
						button.name:SetTextColor(color.r, color.g, color.b)
						button.subName:SetTextColor(1, 1, 1)
					end
				else
					button.selectedTexture:SetVertexColor(1, 1, 1)
					button.handledHighlight:SetVertexColor(1, 1, 1)
					button.name:SetTextColor(1, 1, 1)
					button.subName:SetTextColor(1, 1, 1)
					button.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
				end
			else
				button.selectedTexture:SetVertexColor(1, 1, 1)
				button.handledHighlight:SetVertexColor(1, 1, 1)
				button.name:SetTextColor(0.6, 0.6, 0.6)
				button.subName:SetTextColor(0.6, 0.6, 0.6)
				button.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		end
	end
	hooksecurefunc("PetJournal_UpdatePetList", ColorSelectedPet)
	hooksecurefunc("HybridScrollFrame_Update", ColorSelectedPet)

	local breedInfo = LibStub("LibPetBreedInfo-1.0")
	local function GetColor(confidence)
		local color = "|cffffcc00"
		if confidence < 2.5 then color = "|cff888888" end
		return color
	end

	hooksecurefunc("PetJournal_UpdatePetLoadOut", function()
		for i = 1, 3 do
			local frame = PetJournal.Loadout["Pet"..i]
			local petID, _, _, _, locked = C_PetJournal_GetPetLoadOutInfo(i)

			if not locked and petID then
				local _, customName, _, _, _, _, _, name = C_PetJournal_GetPetInfoByPetID(petID)
				local quality = select(5, C_PetJournal_GetPetStats(petID))
				local hex = select(4, GetItemQualityColor(quality - 1))
				local breedIndex, confidence = breedInfo:GetBreedByPetID(petID)
				local breedName = Config.display.breedInfo and ((breedIndex and confidence) and format("%s%s|r", GetColor(confidence), breedInfo:GetBreedName(breedIndex)) or "") or ""

				frame.name:SetText(format("|c%s%s|r %s", hex, name, breedName))

				if customName then
					frame.subName:SetText(format("|c%s%s|r", "fffffff", customName))
				end
			end
		end
	end)
end

S:AddCallbackForAddon("PetJournalEnhanced", "PetJournalEnhanced", LoadSkin)