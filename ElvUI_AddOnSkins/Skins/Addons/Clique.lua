local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.Clique then return end

	CliqueDialog:StripTextures()
	CliqueDialog:SetTemplate("Transparent")

	CliqueConfig:StripTextures()
	CliqueConfig:SetTemplate("Transparent")

	CliqueClickGrabber:StripTextures()
	CliqueClickGrabber:SetTemplate("Transparent")

	CliqueConfigBindAlert:StripTextures()
	CliqueConfigBindAlert:SetTemplate("Transparent")

	for i = 1, 2 do
		local page = _G["CliqueConfigPage"..i]

		page:StripTextures()
		page:SetTemplate("Transparent")
	end

	CliqueSpellTab:StyleButton(nil, true)
	CliqueSpellTab:SetTemplate("Default", true)
	CliqueSpellTab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	CliqueSpellTab:GetNormalTexture():SetInside()
	select(1, CliqueSpellTab:GetRegions()):Hide()

	S:HandleButton(CliqueConfigPage1ButtonSpell)
	S:HandleButton(CliqueConfigPage1ButtonOther)
	S:HandleButton(CliqueConfigPage1ButtonOptions)
	S:HandleButton(CliqueDialogButtonBinding)
	S:HandleButton(CliqueDialogButtonAccept)
	S:HandleButton(CliqueConfigPage2ButtonBinding)
	S:HandleButton(CliqueConfigPage2ButtonSave)
	S:HandleButton(CliqueConfigPage2ButtonCancel)

	CliqueConfigPage1:SetScript("OnShow", function()
		for i = 1, 12 do
			local Row = _G["CliqueRow"..i]
			local Icon = _G["CliqueRow"..i.."Icon"]
			local Bind = _G["CliqueRow"..i.."Bind"]

			if Row then
				Row:CreateBackdrop()
				Row.backdrop:SetOutside(Icon)

				Icon:SetTexCoord(unpack(E.TexCoords))
				Icon:SetParent(Row.backdrop)

				Row:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)

				Bind:ClearAllPoints()
				if Row == CliqueRow1 then
					Bind:SetPoint("RIGHT", Row, 8, 0)
				else
					Bind:SetPoint("RIGHT", Row, -9, 0)
				end
			end
		end

		CliqueRow1:ClearAllPoints()
		CliqueRow1:Point("TOPLEFT", 5, - (CliqueConfigPage1Column1:GetHeight() + 3))
	end)

	CliqueConfigPage1Column1:StripTextures()
	CliqueConfigPage1Column2:StripTextures()

	CliqueConfigPage1Column1:StyleButton()
	CliqueConfigPage1Column2:StyleButton()

	CliqueConfigPage1_VSlider:StripTextures(true)

	CliqueConfigInset:StripTextures()

	CliqueConfigBindAlertArrow:Kill()
	CliqueConfigBindAlert:ClearAllPoints()
	CliqueConfigBindAlert:Point("TOPLEFT", SpellBookFrame, "TOPLEFT", 0, E.PixelMode and 45 or 47)

	CliqueConfigPage1ButtonSpell:Point("BOTTOMLEFT", 3, 2)
	CliqueConfigPage1ButtonOptions:Point("BOTTOMRIGHT", -5, 2)
	CliqueConfigPage2ButtonSave:Point("BOTTOMLEFT", 3, 2)
	CliqueConfigPage2ButtonCancel:Point("BOTTOMRIGHT", -5, 2)

	S:HandleScrollBar(CliqueScrollFrameScrollBar)

	CliqueTabAlert:StripTextures()
	CliqueTabAlert:SetTemplate()

	S:HandleCloseButton(CliqueTabAlertClose)
	S:HandleCloseButton(CliqueDialogCloseButton)
	S:HandleCloseButton(CliqueConfigCloseButton)
end

S:AddCallbackForAddon("Clique", "Clique", LoadSkin)