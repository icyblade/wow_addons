local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local select, unpack = select, unpack

local function LoadSkin()
	if not E.private.addOnSkins.Clique then return end

	CliqueConfigInset:StripTextures()

	CliqueConfig:StripTextures()
	CliqueConfig:SetTemplate("Transparent")

	CliqueTabAlert:StripTextures()
	CliqueTabAlert:SetTemplate()

	CliqueDialog:StripTextures()
	CliqueDialog:SetTemplate("Transparent")

	for i = 1, CliqueDialog:GetNumChildren() do
		local child = select(i, CliqueDialog:GetChildren())
		if child.GetPushedTexture and child:GetPushedTexture() and not child:GetName() then
			S:HandleCloseButton(child)
			child:Point("TOPRIGHT", 2, 2)
		end
	end

	CliqueClickGrabber:StripTextures()
	CliqueClickGrabber:CreateBackdrop()
	CliqueClickGrabber.backdrop:Point("TOPLEFT", 2, -2)
	CliqueClickGrabber.backdrop:Point("BOTTOMRIGHT", -24, 2)

	CliqueConfigBindAlert:StripTextures()
	CliqueConfigBindAlert:SetTemplate("Transparent")

	CliqueSpellTab:StyleButton(nil, true)
	CliqueSpellTab:SetTemplate("Default", true)
	CliqueSpellTab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	CliqueSpellTab:GetNormalTexture():SetInside()
	select(1, CliqueSpellTab:GetRegions()):Hide()

	CliqueConfigPage1:CreateBackdrop("Transparent")
	CliqueConfigPage1:HookScript("OnShow", function()
		for i = 1, 12 do
			local row = _G["CliqueRow"..i]
			local icon = _G["CliqueRow"..i.."Icon"]
			local bind = _G["CliqueRow"..i.."Bind"]

			if row and not row.isSkinned then
				row:CreateBackdrop()
				row.backdrop:SetOutside(icon)
				S:HandleButtonHighlight(row)

				icon:SetTexCoord(unpack(E.TexCoords))
				icon:SetParent(row.backdrop)

				bind:ClearAllPoints()
				bind:Point("RIGHT", row, -4, 0)

				row.isSkinned = true
			end
		end
	end)

	CliqueConfigPage1Column1:StripTextures()
	CliqueConfigPage1Column1:StyleButton()
	CliqueConfigPage1Column1:Width(190)

	CliqueConfigPage1Column2:StripTextures()
	CliqueConfigPage1Column2:StyleButton()
	CliqueConfigPage1Column2:Width(117)

	CliqueConfigPage1_VSlider:StripTextures()
	S:HandleSliderFrame(CliqueConfigPage1_VSlider)
	CliqueConfigPage1_VSlider:Point("TOPRIGHT", -3, -20)
	CliqueConfigPage1_VSlider:Point("BOTTOMRIGHT", 0, 10)

	S:HandleButton(CliqueConfigPage1ButtonSpell)
	CliqueConfigPage1ButtonSpell:Point("BOTTOMLEFT", CliqueConfig, 4, 2)

	S:HandleButton(CliqueConfigPage1ButtonOther)
	CliqueConfigPage1ButtonOther:Point("TOPLEFT", CliqueConfigPage1ButtonSpell, "TOPRIGHT", 22, 0)
	S:HandleButton(CliqueDialogButtonBinding)
	S:HandleButton(CliqueDialogButtonAccept)

	S:HandleButton(CliqueConfigPage2ButtonBinding)
	CliqueConfigPage2ButtonBinding:Point("CENTER", 0, -5)

	S:HandleButton(CliqueConfigPage1ButtonOptions)
	CliqueConfigPage1ButtonOptions:Point("BOTTOMRIGHT", CliqueConfig, -6, 2)

	S:HandleButton(CliqueConfigPage2ButtonSave)
	CliqueConfigPage2ButtonSave:Point("BOTTOMLEFT", CliqueConfig, 4, 2)

	S:HandleButton(CliqueConfigPage2ButtonCancel)
	CliqueConfigPage2ButtonCancel:Point("BOTTOMRIGHT", CliqueConfig, -6, 2)

	CliqueConfigBindAlertArrow:Kill()
	CliqueConfigBindAlert:ClearAllPoints()
	CliqueConfigBindAlert:Point("TOPLEFT", SpellBookFrame, 0, E.PixelMode and 45 or 47)

	S:HandleScrollBar(CliqueScrollFrameScrollBar)

	S:HandleCloseButton(CliqueTabAlertClose)
	S:HandleCloseButton(CliqueConfigCloseButton)
end

S:AddCallbackForAddon("Clique", "Clique", LoadSkin)