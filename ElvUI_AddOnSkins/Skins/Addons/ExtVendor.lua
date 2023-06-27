local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.ExtVendor or not E.private.skins.blizzard.merchant then return end

	MerchantFrame:Size(720, 525)

	S:HandleButton(MerchantFrameFilterButton)
	S:HandleEditBox(MerchantFrameSearchBox)

	S:HandleItemButton(MerchantFrameSellJunkButton)
	MerchantFrameSellJunkButton:Point("TOPLEFT", 26, -27)

	ExtVendor_SellJunkPopup:SetTemplate("Transparent")

	S:HandleButton(ExtVendor_SellJunkPopupYesButton)
	S:HandleButton(ExtVendor_SellJunkPopupNoButton)

	for i = 13, 20 do
		local item = _G["MerchantItem"..i]
		local itemButton = _G["MerchantItem"..i.."ItemButton"]
		local iconTexture = _G["MerchantItem"..i.."ItemButtonIconTexture"]
		local moneyFrame = _G["MerchantItem"..i.."MoneyFrame"]
		local altCurrencyFrame = _G["MerchantItem"..i.."AltCurrencyFrame"]
		local altCurrencyItem1 = _G["MerchantItem"..i.."AltCurrencyFrameItem1"]
		local altCurrencyTex1 = _G["MerchantItem"..i.."AltCurrencyFrameItem1Texture"]
		local altCurrencyTex2 = _G["MerchantItem"..i.."AltCurrencyFrameItem2Texture"]

		item:StripTextures(true)
		item:CreateBackdrop("Default")

		itemButton:StripTextures()
		itemButton:StyleButton()
		itemButton:SetTemplate("Default", true)
		itemButton:Size(40)
		itemButton:Point("TOPLEFT", 2, -2)

		iconTexture:SetTexCoord(unpack(E.TexCoords))
		iconTexture:SetInside()

		altCurrencyItem1:Point("LEFT", altCurrencyFrame, "LEFT", 15, 4)

		altCurrencyTex1:SetTexCoord(unpack(E.TexCoords))
		altCurrencyTex2:SetTexCoord(unpack(E.TexCoords))

		moneyFrame:ClearAllPoints()
		moneyFrame:Point("BOTTOMLEFT", itemButton, "BOTTOMRIGHT", 3, 0)
	end

	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
		for i = 13, 20 do
			local itemButton = _G["MerchantItem"..i.."ItemButton"]
			local itemName = _G["MerchantItem"..i.."Name"]

			if itemButton.link then
				local _, _, quality = GetItemInfo(itemButton.link)
				local r, g, b = GetItemQualityColor(quality)

				if quality and quality > 1 then
					itemButton:SetBackdropBorderColor(r, g, b)
					itemName:SetTextColor(r, g, b)
				else
					itemButton:SetBackdropBorderColor(unpack(E.media.bordercolor))
					itemName:SetTextColor(1, 1, 1)
				end
			end
		end
	end)

	-- Options
	ExtVendorConfigContainer:StripTextures()

	ExtVendorConfig_GeneralContainer:StripTextures()
	ExtVendorConfig_GeneralContainer:SetTemplate("Transparent")

	ExtVendorConfig_FilterContainer:StripTextures()
	ExtVendorConfig_FilterContainer:SetTemplate("Transparent")

	ExtVendorConfig_QuickVendorContainer:StripTextures()
	ExtVendorConfig_QuickVendorContainer:SetTemplate("Transparent")

	S:HandleCheckBox(ExtVendorConfig_GeneralContainer_ShowLoadMsg, true)
	S:HandleCheckBox(ExtVendorConfig_FilterContainer_ShowSuboptimalArmor, true)
	S:HandleCheckBox(ExtVendorConfig_QuickVendorContainer_SuboptimalArmor, true)
	S:HandleCheckBox(ExtVendorConfig_QuickVendorContainer_AlreadyKnown, true)
	S:HandleCheckBox(ExtVendorConfig_QuickVendorContainer_UnusableEquip, true)
	S:HandleCheckBox(ExtVendorConfig_QuickVendorContainer_WhiteGear, true)

	S:HandleScrollBar(ExtVendorConfigContainerScrollScrollBar)
end

S:AddCallbackForAddon("ExtVendor", "ExtVendor", LoadSkin)