local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.stable then return end

	NUM_PET_STABLE_SLOTS = 20
	NUM_PET_STABLE_PAGES = 1

	PetStableFrame:StripTextures()
	PetStableFrame:CreateBackdrop("Transparent")
	PetStableFrame.page = 1

	PetStableFrameInset:StripTextures()
	PetStableFrameInset:Point("BOTTOMRIGHT", -6, 142)

	PetStableLeftInset:StripTextures()

	PetStableModel:CreateBackdrop("Transparent")

	PetStableModelShadow:Kill()

	PetStableFrameModelBg:Height(265)

	PetStableNextPageButton:Hide()
	PetStablePrevPageButton:Hide()

	PetStableModelRotateRightButton:Hide()
	PetStableModelRotateLeftButton:Hide()

	PetStablePetInfo:CreateBackdrop()
	PetStablePetInfo.backdrop:SetOutside(PetStableSelectedPetIcon)

	PetStableSelectedPetIcon:SetTexCoord(unpack(E.TexCoords))
	PetStableSelectedPetIcon:Point("TOPLEFT", PetStablePetInfo, 0, 2)

	PetStableDiet:StripTextures()
	PetStableDiet:CreateBackdrop()
	PetStableDiet:Point("TOPRIGHT", -1, 2)
	PetStableDiet:Size(40)

	S:HandleFrameHighlight(PetStableDiet, PetStableDiet.backdrop)

	PetStableDiet.icon = PetStableDiet:CreateTexture(nil, "ARTWORK")
	PetStableDiet.icon:SetTexture([[Interface\Icons\Ability_Hunter_BeastTraining]])
	PetStableDiet.icon:SetTexCoord(unpack(E.TexCoords))
	PetStableDiet.icon:SetInside(PetStableDiet.backdrop)

	PetStableTypeText:Point("BOTTOMRIGHT", -47, 2)

	PetStableBottomInset:StripTextures()
	PetStableBottomInset:CreateBackdrop()
	PetStableBottomInset.backdrop:Point("TOPLEFT", 4, 0)
	PetStableBottomInset.backdrop:Point("BOTTOMRIGHT", -5, 6)

	S:HandleCloseButton(PetStableFrameCloseButton)

	local function PetButtons(btn)
		local button = _G[btn]
		local icon = _G[btn.."IconTexture"]
		local highlight = button:GetHighlightTexture()

		button:StripTextures()

		if button.Checked then
			button.Checked:SetTexture(1, 1, 1, 0.3)
			button.Checked:SetAllPoints(icon)
		end

		if highlight then
			highlight:SetTexture(1, 1, 1, 0.3)
			highlight:SetAllPoints(icon)
		end

		if icon then
			icon:SetTexCoord(unpack(E.TexCoords))
			icon:ClearAllPoints()
			icon:Point("TOPLEFT", E.PixelMode and 1 or 2, -(E.PixelMode and 1 or 2))
			icon:Point("BOTTOMRIGHT", -(E.PixelMode and 1 or 2), E.PixelMode and 1 or 2)

			button:SetFrameLevel(button:GetFrameLevel() + 2)
			if not button.backdrop then
				button:CreateBackdrop("Default", true)
				button.backdrop:SetAllPoints()
			end
		end
	end

	for i = 1, NUM_PET_ACTIVE_SLOTS do
		PetButtons("PetStableActivePet"..i)

	end

	for i = 11, 20 do
		if not _G["PetStableStabledPet"..i] then
			CreateFrame("Button", "PetStableStabledPet"..i, PetStableFrame, "PetStableSlotTemplate", i)
		end
	end

	for i = 1, NUM_PET_STABLE_SLOTS do
		local button = _G["PetStableStabledPet"..i]

		PetButtons("PetStableStabledPet"..i)

		button:ClearAllPoints()
		if i ~= 1 and i ~= 8 and i ~= 15 then
			button:Point("LEFT", _G["PetStableStabledPet"..i - 1], "RIGHT", 7, 0)
		end
	end

	PetStableStabledPet1:Point("TOPLEFT", PetStableBottomInset, 9, -5)
	PetStableStabledPet8:Point("TOPLEFT", PetStableStabledPet1, "BOTTOMLEFT", 0, -5)
	PetStableStabledPet15:Point("TOPLEFT", PetStableStabledPet8, "BOTTOMLEFT", 0, -5)
end

S:AddCallback("Stable", LoadSkin)