local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local find = string.find

local function LoadSkin()
	if not E.private.addOnSkins.FishingBuddy then return end

	FishingBuddyFrame:CreateBackdrop("Transparent")
	FishingBuddyFrame.backdrop:Point("TOPLEFT", 14, -14)
	FishingBuddyFrame.backdrop:Point("BOTTOMRIGHT", -32, 74)

	FishingBuddyFramePortrait:Kill()
	FishingLocationsFrame:StripTextures()
	FishingOptionsFrame:StripTextures()
	FishingLocationExpandButtonFrame:StripTextures()

	S:HandleCloseButton(FishingBuddyFrameCloseButton, FishingBuddyFrame.backdrop)

	FishingLocsScrollFrame:StripTextures()
	S:HandleScrollBar(FishingLocsScrollFrameScrollBar)

	S:HandleTab(FishingBuddyFrameTab1)
	S:HandleTab(FishingBuddyFrameTab2)

	S:HandleButton(FishingLocationsSwitchButton)

	S:HandleSliderFrame(FishingBuddyOption_MinimapRadSlider)
	S:HandleSliderFrame(FishingBuddyOption_MinimapPosSlider)

	S:HandleDropDownBox(FishingBuddyOption_OutfitMenu, 210)
	S:HandleDropDownBox(FishingBuddyOption_EasyCastKeys, 140)

	S:HandleCheckBox(FishingBuddyOptionSLZ)

	S:HandleSliderFrame(FishingBuddyOption_MaxVolumeSlider)
	FishingPetFrame:StripTextures()
	FishingPetFrame:CreateBackdrop("Default")
	FishingPetFrame.backdrop:Point("TOPLEFT", 10, -2)
	FishingPetFrame.backdrop:Point("BOTTOMRIGHT", -13, 9)

	S:HandleNextPrevButton(FishingPetFrameButton)
	FishingPetFrameButton:Point("TOPRIGHT", FishingPetFrameRight, "TOPRIGHT", -16, -21)

	FishingPetsMenu:StripTextures()
	FishingPetsMenu:SetTemplate("Transparent")

	local function SkinCheckBoxes()
		local checkBox

		for i = 1, 14 do
			checkBox = _G["FishingBuddyOption"..i]
			if checkBox and not checkBox.isSkinned then
				S:HandleCheckBox(checkBox)
				checkBox.isSkinned = true
			end
		end
	end

	S:HookScript(FishingOptionsFrame, "OnShow", function()
		E:Delay(0.01, SkinCheckBoxes)
		S:Unhook(FishingOptionsFrame, "OnShow")
	end)

	local optionTabs = {
		FishingBuddyOptionTab1,
		FishingBuddyOptionTab2,
		FishingBuddyOptionTab3,
		FishingBuddyOptionTab4,
		FishingBuddyOptionTab5
	}

	for _, frame in pairs(optionTabs) do
		frame:SetTemplate("Default")
		frame:StyleButton(nil, true)
		frame:DisableDrawLayer("BACKGROUND")
		frame:GetNormalTexture():SetInside(frame.backdrop)
		frame:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))

		frame:HookScript("OnClick", function(self)
			if not self.isSkinned then
				SkinCheckBoxes()

				self.isSkinned = true
			end
		end)
	end

	for i = 0, 21 do
		local button = _G["FishingLocations"..i]

		if i == 0 then
			button = FishingLocationsCollapseAllButton
		end

		if button then
			button:SetNormalTexture("")
			button.SetNormalTexture = E.noop

			button:SetPushedTexture("")
			button.SetPushedTexture = E.noop

			button:SetHighlightTexture("")
			button.SetHighlightTexture = E.noop

			button:SetDisabledTexture("")
			button.SetDisabledTexture = E.noop

			button.Text = button:CreateFontString(nil, "OVERLAY")
			button.Text:FontTemplate(nil, 22)
			button.Text:Point("LEFT", 5, 0)
			button.Text:SetText("")

			hooksecurefunc(button, "SetNormalTexture", function(self, texture)
				if find(texture, "MinusButton") then
					self.Text:SetText("-")
				elseif find(texture, "PlusButton") then
					self.Text:SetText("+")
				else
					self.Text:SetText("")
				end
			end)
		end
	end

	FishingWatchDrag:SetClampedToScreen(true)
	FishingWatchDrag:SetClampRectInsets(0, 0, 23, 0)

	FishingWatchTab:CreateBackdrop("Transparent")
	FishingWatchTab.backdrop:Point("TOPLEFT", 4, -11)
	FishingWatchTab.backdrop:Point("BOTTOMRIGHT", -2, 0)
	FishingWatchTab:DisableDrawLayer("BACKGROUND")
end

S:AddCallbackForAddon("FishingBuddy", "FishingBuddy", LoadSkin)