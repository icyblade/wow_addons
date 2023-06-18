local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack

local function LoadSkin()
	if not E.private.addOnSkins.BindPad then return end

	BindPadFrame:StripTextures(true)
	BindPadFrame:CreateBackdrop("Transparent")
	BindPadFrame.backdrop:Point("TOPLEFT", 10, -11)
	BindPadFrame.backdrop:Point("BOTTOMRIGHT", -31, 71)

	local function HandleMicroButton(button)
		local pushed = button:GetPushedTexture()
		local normal = button:GetNormalTexture()
		local disabled = button:GetDisabledTexture()

		button:GetHighlightTexture():Kill()

		local frame = CreateFrame("Frame", nil, button)
		frame:Point("BOTTOMLEFT", button, 2, 0)
		frame:Point("TOPRIGHT", button, -2, -28)
		frame:SetTemplate()
		frame:SetFrameLevel(button:GetFrameLevel() - 1)

		pushed:SetTexCoord(0.17, 0.87, 0.5, 0.908)
		pushed:SetInside(frame)

		normal:SetTexCoord(0.17, 0.87, 0.5, 0.908)
		normal:SetInside(frame)

		if disabled then
			disabled:SetTexCoord(0.17, 0.87, 0.5, 0.908)
			disabled:SetInside(frame)
		end
	end

	BindPadFrame:HookScript("OnShow", function()
		for i = 1, 42 do
			local slot = _G["BindPadSlot"..i]

			if slot and not slot.isSkinned then
				local icon = _G["BindPadSlot"..i.."Icon"]
				local border = _G["BindPadSlot"..i.."Border"]
				local button = _G["BindPadSlot"..i.."AddButton"]

				slot:SetNormalTexture(nil)
				slot:SetTemplate(nil, true)
				slot:StyleButton(nil, nil, true)

				icon:SetInside()
				icon:SetTexCoord(unpack(E.TexCoords))
				icon:SetDrawLayer("ARTWORK")

				border:SetTexture(1, 1, 0, 0.3)
				border:SetInside()

				button:SetNormalTexture(nil)
				button:SetPushedTexture(nil)
				button:SetDisabledTexture(nil)
				button:SetHighlightTexture(nil)

				button.Text = button:CreateFontString(nil, "OVERLAY")
				button.Text:FontTemplate(nil, 22)
				button.Text:Point("CENTER", 0, 0)
				button.Text:SetText("+")

				slot.isSkinned = true
			end
		end
	end)

	for i = 1, 4 do
		local tab = _G["BindPadFrameTab"..i]

		tab:StripTextures()
		tab.backdrop = CreateFrame("Frame", nil, tab)
		tab.backdrop:SetTemplate(nil, true)
		tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
		tab.backdrop:Point("TOPLEFT", 3, -7)
		tab.backdrop:Point("BOTTOMRIGHT", -2, -1)

		tab:HookScript("OnEnter", S.SetModifiedBackdrop)
		tab:HookScript("OnLeave", S.SetOriginalBackdrop)
	end

	BindPadFrameTab1:Point("TOPLEFT", 80, -39)

	for i = 1, 5 do
		local tab = _G["BindPadProfileTab"..i]
		local icon = _G["BindPadProfileTab"..i.."SubIcon"]
		local bg = _G["BindPadProfileTab"..i.."Background"]

		tab:StripTextures()
		tab:SetTemplate(nil, true)
		tab:StyleButton(nil, true)

		tab:GetNormalTexture():SetInside()
		tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
		tab:GetNormalTexture():SetDrawLayer("ARTWORK")

		icon:SetTexCoord(unpack(E.TexCoords))

		bg:SetAlpha(0)
	end

	S:HandleCloseButton(BindPadFrameCloseButton)

	S:HandleCheckBox(BindPadFrameCharacterButton)
	S:HandleCheckBox(BindPadFrameSaveAllKeysButton)
	S:HandleCheckBox(BindPadFrameShowHotkeyButton)

	BindPadScrollFrame:StripTextures()
	BindPadScrollFrame:CreateBackdrop("Transparent")

	S:HandleScrollBar(BindPadScrollFrameScrollBar)

	S:HandleButton(BindPadFrameExitButton)

	HandleMicroButton(BindPadFrameOpenSpellBookButton)
	HandleMicroButton(BindPadFrameOpenMacroButton)
	HandleMicroButton(BindPadFrameOpenBagButton)

	BindPadBindFrame:StripTextures(true)
	BindPadBindFrame:SetTemplate("Transparent")
	BindPadBindFrame:Size(350, 150)

	S:HandleCloseButton(BindPadBindFrameCloseButton)

	S:HandleButton(BindPadBindFrameExitButton)
	S:HandleButton(BindPadBindFrameUnbindButton)

	BindPadMacroPopupFrame:StripTextures()
	BindPadMacroPopupFrame:CreateBackdrop("Transparent")
	BindPadMacroPopupFrame.backdrop:Point("TOPLEFT", 10, -9)
	BindPadMacroPopupFrame.backdrop:Point("BOTTOMRIGHT", -7, 9)

	BindPadMacroPopupNameLeft:SetTexture(nil)
	BindPadMacroPopupNameMiddle:SetTexture(nil)
	BindPadMacroPopupNameRight:SetTexture(nil)
	S:HandleEditBox(BindPadMacroPopupEditBox)

	BindPadMacroPopupScrollFrame:StripTextures()
	S:HandleScrollBar(BindPadMacroPopupScrollFrameScrollBar)

	for i = 1, 20 do
		local button = _G["BindPadMacroPopupButton"..i]
		local buttonIcon = _G["BindPadMacroPopupButton"..i.."Icon"]

		button:StripTextures()
		button:StyleButton(nil, true)
		button:SetTemplate(nil, true)

		buttonIcon:SetInside()
		buttonIcon:SetTexCoord(unpack(E.TexCoords))
	end

	S:HandleButton(BindPadMacroPopupCancelButton)
	S:HandleButton(BindPadMacroPopupOkayButton)

	BindPadMacroFrame:StripTextures(true)
	BindPadMacroFrame:CreateBackdrop("Transparent")
	BindPadMacroFrame.backdrop:Point("TOPLEFT", 10, -11)
	BindPadMacroFrame.backdrop:Point("BOTTOMRIGHT", -31, 71)

	BindPadMacroFrameSlotButton:StripTextures()
	BindPadMacroFrameSlotButton:SetTemplate(nil, true)

	BindPadMacroFrameSlotButtonIcon:SetInside()
	BindPadMacroFrameSlotButtonIcon:SetTexCoord(unpack(E.TexCoords))

	S:HandleScrollBar(BindPadMacroFrameScrollFrameScrollBar)

	BindPadMacroFrameTextBackground:SetTemplate()

	S:HandleButton(BindPadMacroFrameEditButton)
	S:HandleButton(BindPadMacroFrameTestButton)
	S:HandleButton(BindPadMacroFrameExitButton)
	S:HandleButton(BindPadMacroDeleteButton)

	S:HandleCloseButton(BindPadMacroFrameCloseButton)

	S:HandleNextPrevButton(BindPadShowLessSlotButton, "left", nil, true)
	BindPadShowLessSlotButton:Size(24)

	S:HandleNextPrevButton(BindPadShowMoreSlotButton, "right", nil, true)
	BindPadShowMoreSlotButton:Size(24)

	BindPadDialogFrame:StripTextures()
	BindPadDialogFrame:SetTemplate("Transparent")

	S:HandleButton(BindPadDialogFrame.okaybutton)
	S:HandleButton(BindPadDialogFrame.cancelbutton)
end

S:AddCallbackForAddon("BindPad", "BindPad", LoadSkin)