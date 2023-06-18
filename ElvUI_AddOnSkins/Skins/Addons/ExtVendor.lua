local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.ExtVendor or not E.private.skins.blizzard.merchant then return end

	for i = 13, 20 do
		local item = _G["MerchantItem"..i]
		local button = _G["MerchantItem"..i.."ItemButton"]
		local icon = _G["MerchantItem"..i.."ItemButtonIconTexture"]
		local money = _G["MerchantItem"..i.."MoneyFrame"]

		item:StripTextures(true)
		item:CreateBackdrop()

		button:StripTextures()
		button:SetTemplate("Default", true)
		button:StyleButton()
		button:Size(40)
		button:Point("TOPLEFT", 2, -2)

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()

		_G["MerchantItem"..i.."ItemButtonStock"]:Point("TOPLEFT", 2, -2)

		money:ClearAllPoints()
		money:Point("BOTTOMLEFT", button, "BOTTOMRIGHT", 3, 0)

		for j = 1, 2 do
			local currency = _G["MerchantItem"..i.."AltCurrencyFrameItem"..j]
			local currencyIcon = _G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"]

			currency:CreateBackdrop()
			currency.backdrop:SetOutside(currencyIcon)

			currencyIcon:SetTexCoord(unpack(E.TexCoords))
			currencyIcon:SetParent(currency.backdrop)
		end
	end

	local function UpdateMerchantFrame()
		local numMerchantItems = GetMerchantNumItems()
		local _, index, button, name, currency, price, extendedCost
		local link, quality, r, g, b

		for i = 1, MERCHANT_ITEMS_PER_PAGE do
			index = (((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i)
			button = _G["MerchantItem"..i.."ItemButton"]
			name = _G["MerchantItem"..i.."Name"]
			currency = _G["MerchantItem"..i.."AltCurrencyFrame"]

			if index <= numMerchantItems then
				link = GetMerchantItemLink(index)
				_, _, price, _, _, _, extendedCost = GetMerchantItemInfo(index)

				currency:ClearAllPoints()
				if extendedCost and (price and price <= 0) then
					currency:Point("BOTTOMLEFT", _G["MerchantItem"..i.."NameFrame"], 2, 34)
				elseif extendedCost and (price and price > 0) then
					currency:Point("LEFT", _G["MerchantItem"..i.."MoneyFrame"], "RIGHT", -12, 0)
				end

				if link then
					quality = select(3, GetItemInfo(link))
					if quality then
						r, g, b = GetItemQualityColor(quality)
						button:SetBackdropBorderColor(r, g, b)
						name:SetTextColor(r, g, b)
					else
						button:SetBackdropBorderColor(unpack(E.media.bordercolor))
						name:SetTextColor(1, 1, 1)
					end
				else
					button:SetBackdropBorderColor(unpack(E.media.bordercolor))
					name:SetTextColor(1, 1, 1)
				end
			end
		end
	end
	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", UpdateMerchantFrame)
	hooksecurefunc("ExtVendor_UpdateMerchantInfo", UpdateMerchantFrame)

	S:HandleButton(MerchantFrameFilterButton)
	S:HandleEditBox(MerchantFrameSearchBox)

	MerchantBuyBackItem:Point("TOPLEFT", MerchantItem10, "BOTTOMLEFT", -8, -30)
	MerchantNextPageButton:Point("CENTER", MerchantFrame, "BOTTOM", 315, 60)
	MerchantPrevPageButton:Point("CENTER", MerchantFrame, "BOTTOM", 20, 60)

	-- Junk
	S:HandleItemButton(MerchantFrameSellJunkButton)
	MerchantFrameSellJunkButton:Point("TOPLEFT", 26, -27)
	MerchantFrameSellJunkButton.hover:SetInside(MerchantFrameSellJunkButton.backdrop)
	MerchantFrameSellJunkButton.pushed:SetInside(MerchantFrameSellJunkButton.backdrop)

	ExtVendor_SellJunkPopup:StripTextures()
	ExtVendor_SellJunkPopup:SetTemplate("Transparent")

	S:HandleButton(ExtVendor_SellJunkPopupYesButton)
	S:HandleButton(ExtVendor_SellJunkPopupNoButton)

	-- Options
	ExtVendorConfigContainer:StripTextures()

	ExtVendorConfig_GeneralContainer:StripTextures()
	ExtVendorConfig_GeneralContainer:SetTemplate("Transparent")

	ExtVendorConfig_FilterContainer:StripTextures()
	ExtVendorConfig_FilterContainer:SetTemplate("Transparent")

	ExtVendorConfig_QuickVendorContainer:StripTextures()
	ExtVendorConfig_QuickVendorContainer:SetTemplate("Transparent")

	ExtVendorConfig_GeneralContainer_Scale:StripTextures()
	ExtVendorConfig_GeneralContainer_Scale:SetTemplate()
	ExtVendorConfig_GeneralContainer_Scale:Height(12)

	ExtVendorConfig_GeneralContainer_ScaleThumb:SetTexture(E.Media.Textures.Melli)
	ExtVendorConfig_GeneralContainer_ScaleThumb:SetVertexColor(1, 0.82, 0, 0.8)
	ExtVendorConfig_GeneralContainer_ScaleThumb:Size(10)

	S:HandleCheckBox(ExtVendorConfig_GeneralContainer_ShowLoadMsg, true)
	S:HandleCheckBox(ExtVendorConfig_GeneralContainer_MouseWheel, true)
	S:HandleCheckBox(ExtVendorConfig_FilterContainer_StockDefaultAll, true)
	S:HandleCheckBox(ExtVendorConfig_FilterContainer_ShowSuboptimalArmor, true)
	S:HandleCheckBox(ExtVendorConfig_QuickVendorContainer_SuboptimalArmor, true)
	S:HandleCheckBox(ExtVendorConfig_QuickVendorContainer_AlreadyKnown, true)
	S:HandleCheckBox(ExtVendorConfig_QuickVendorContainer_UnusableEquip, true)
	S:HandleCheckBox(ExtVendorConfig_QuickVendorContainer_WhiteGear, true)
	S:HandleCheckBox(ExtVendorConfig_QuickVendorContainer_EnableButton, true)

	S:HandleScrollBar(ExtVendorConfigContainerScrollScrollBar)
end

S:AddCallbackForAddon("ExtVendor", "ExtVendor", LoadSkin)