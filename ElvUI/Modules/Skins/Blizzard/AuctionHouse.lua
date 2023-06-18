local E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local pairs, unpack = pairs, unpack

local hooksecurefunc = hooksecurefunc
local CreateFrame = CreateFrame
local GetAuctionSellItemInfo = GetAuctionSellItemInfo

local function LoadSkin()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.auctionhouse then return end

	AuctionFrame:StripTextures(true)
	AuctionFrame:SetTemplate("Transparent")

	local Buttons = {
		BrowseSearchButton,
		BrowseResetButton,
		BrowseBidButton,
		BrowseBuyoutButton,
		BrowseCloseButton,
		BidBidButton,
		BidBuyoutButton,
		BidCloseButton,
		AuctionsCreateAuctionButton,
		AuctionsCancelAuctionButton,
		AuctionsStackSizeMaxButton,
		AuctionsNumStacksMaxButton,
		AuctionsCloseButton
	}

	local CheckBoxes = {
		IsUsableCheckButton,
		ShowOnPlayerCheckButton
	}

	local EditBoxes = {
		BrowseName,
		BrowseMinLevel,
		BrowseMaxLevel,
		BrowseBidPriceGold,
		BrowseBidPriceSilver,
		BrowseBidPriceCopper,
		BidBidPriceGold,
		BidBidPriceSilver,
		BidBidPriceCopper,
		AuctionsStackSizeEntry,
		AuctionsNumStacksEntry,
		StartPriceGold,
		StartPriceSilver,
		StartPriceCopper,
		BuyoutPriceGold,
		BuyoutPriceSilver,
		BuyoutPriceCopper
	}

	local SortTabs = {
		BrowseQualitySort,
		BrowseLevelSort,
		BrowseDurationSort,
		BrowseHighBidderSort,
		BrowseCurrentBidSort,
		BidQualitySort,
		BidLevelSort,
		BidDurationSort,
		BidBuyoutSort,
		BidStatusSort,
		BidBidSort,
		AuctionsQualitySort,
		AuctionsDurationSort,
		AuctionsHighBidderSort,
		AuctionsBidSort
	}

	for _, Button in pairs(Buttons) do
		S:HandleButton(Button, true)
	end

	for _, CheckBox in pairs(CheckBoxes) do
		S:HandleCheckBox(CheckBox)
	end

	for _, EditBox in pairs(EditBoxes) do
		S:HandleEditBox(EditBox)
		EditBox:SetTextInsets(1, 1, -1, 1)
	end

	for i = 1, AuctionFrame.numTabs do
		local tab = _G["AuctionFrameTab"..i]

		S:HandleTab(tab)

		if i == 1 then
			tab:ClearAllPoints()
			tab:Point("BOTTOMLEFT", AuctionFrame, "BOTTOMLEFT", 0, -30)
			tab.SetPoint = E.noop
		end
	end

	for _, Tab in pairs(SortTabs) do
		Tab:StripTextures()
		Tab:SetNormalTexture([[Interface\Buttons\UI-SortArrow]])
		Tab:StyleButton()
	end

	for i = 1, NUM_FILTERS_TO_DISPLAY do
		local tab = _G["AuctionFilterButton"..i]

		tab:StripTextures()
		tab:SetHighlightTexture(E.Media.Textures.Highlight)

		local highlight = tab:GetHighlightTexture()
		highlight:SetInside()
		highlight:SetAlpha(0.35)
	end

	S:HandleCloseButton(AuctionFrameCloseButton)
	AuctionFrameCloseButton:Point("TOPRIGHT", 2, 2)

	AuctionFrameMoneyFrame:Point("BOTTOMRIGHT", AuctionFrame, "BOTTOMLEFT", 181, 11)

	-- Browse Frame
	BrowseTitle:ClearAllPoints()
	BrowseTitle:Point("TOP", AuctionFrame, 0, -5)

	BrowseScrollFrame:StripTextures()

	BrowseFilterScrollFrame:StripTextures()

	S:HandleScrollBar(BrowseFilterScrollFrameScrollBar)
	BrowseFilterScrollFrameScrollBar:ClearAllPoints()
	BrowseFilterScrollFrameScrollBar:Point("TOPRIGHT", BrowseFilterScrollFrame, 22, -18)
	BrowseFilterScrollFrameScrollBar:Point("BOTTOMRIGHT", BrowseFilterScrollFrame, 0, 17)

	S:HandleScrollBar(BrowseScrollFrameScrollBar)
	BrowseScrollFrameScrollBar:ClearAllPoints()
	BrowseScrollFrameScrollBar:Point("TOPRIGHT", BrowseScrollFrame, 24, -18)
	BrowseScrollFrameScrollBar:Point("BOTTOMRIGHT", BrowseScrollFrame, 0, 18)

	S:HandleNextPrevButton(BrowsePrevPageButton, nil, nil, true)
	BrowsePrevPageButton:Point("TOPLEFT", 640, -50)
	BrowsePrevPageButton:Size(32)

	S:HandleNextPrevButton(BrowseNextPageButton, nil, nil, true)
	BrowseNextPageButton:Point("TOPRIGHT", 60, -50)
	BrowseNextPageButton:Size(32)

	BrowseCloseButton:Point("BOTTOMRIGHT", 66, 6)
	BrowseBuyoutButton:Point("RIGHT", BrowseCloseButton, "LEFT", -4, 0)
	BrowseBidButton:Point("RIGHT", BrowseBuyoutButton, "LEFT", -4, 0)
	BrowseResetButton:Point("TOPLEFT", 20, -74)
	BrowseSearchButton:Point("TOPRIGHT", 10, -30)

	BrowseNameText:Point("TOPLEFT", 18, -30)
	BrowseName:Point("TOPLEFT", BrowseNameText, "BOTTOMLEFT", 3, -3)
	BrowseName:Size(140, 18)

	BrowseLevelText:Point("BOTTOMLEFT", AuctionFrameBrowse, "TOPLEFT", 200, -40)
	BrowseMaxLevel:Point("LEFT", BrowseMinLevel, "RIGHT", 8, 0)

	BrowseBidPrice:Point("BOTTOM", 25, 10)

	-- Bid Frame
	BidTitle:ClearAllPoints()
	BidTitle:Point("TOP", AuctionFrame, 0, -5)

	BidScrollFrame:StripTextures()

	BidCloseButton:Point("BOTTOMRIGHT", 66, 6)
	BidBuyoutButton:Point("RIGHT", BidCloseButton, "LEFT", -4, 0)
	BidBidButton:Point("RIGHT", BidBuyoutButton, "LEFT", -4, 0)

	BidBidPrice:Point("BOTTOM", 25, 10)

	S:HandleScrollBar(BidScrollFrameScrollBar)
	BidScrollFrameScrollBar:ClearAllPoints()
	BidScrollFrameScrollBar:Point("TOPRIGHT", BidScrollFrame, 23, -18)
	BidScrollFrameScrollBar:Point("BOTTOMRIGHT", BidScrollFrame, 0, 16)

	-- Auctions Frame
	AuctionsTitle:ClearAllPoints()
	AuctionsTitle:Point("TOP", AuctionFrame, 0, -5)

	AuctionsScrollFrame:StripTextures()

	S:HandleScrollBar(AuctionsScrollFrameScrollBar)
	AuctionsScrollFrameScrollBar:ClearAllPoints()
	AuctionsScrollFrameScrollBar:Point("TOPRIGHT", AuctionsScrollFrame, 23, -20)
	AuctionsScrollFrameScrollBar:Point("BOTTOMRIGHT", AuctionsScrollFrame, 0, 18)

	AuctionsCloseButton:Point("BOTTOMRIGHT", 66, 6)
	AuctionsCancelAuctionButton:Point("RIGHT", AuctionsCloseButton, "LEFT", -4, 0)

	AuctionsStackSizeEntry.backdrop:SetAllPoints()
	AuctionsNumStacksEntry.backdrop:SetAllPoints()

	AuctionsItemButton:StripTextures()
	AuctionsItemButton:SetTemplate("Default", true)
	AuctionsItemButton:StyleButton()

	AuctionsItemButton:HookScript("OnEvent", function(self, event)
		local normal = self:GetNormalTexture()

		if event == "NEW_AUCTION_UPDATE" and normal then
			normal:SetTexCoord(unpack(E.TexCoords))
			normal:SetInside()

			local _, _, _, quality = GetAuctionSellItemInfo()
			if quality then
				self:SetBackdropBorderColor(GetItemQualityColor(quality))
			else
				self:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		else
			self:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end)

	S:HandleDropDownBox(BrowseDropDown, 155)
	BrowseDropDown:Point("TOPLEFT", BrowseLevelText, "BOTTOMRIGHT", -5, 2)
	S:HandleDropDownBox(PriceDropDown)
	S:HandleDropDownBox(DurationDropDown)

	-- Progress Frame
	AuctionProgressFrame:StripTextures()
	AuctionProgressFrame:SetTemplate("Transparent")

	S:HandleButton(AuctionProgressFrameCancelButton)
	AuctionProgressFrameCancelButton:SetHitRectInsets(0, 0, 0, 0)
	AuctionProgressFrameCancelButton:GetNormalTexture():SetTexture(E.Media.Textures.Close)
	AuctionProgressFrameCancelButton:GetNormalTexture():SetInside()
	AuctionProgressFrameCancelButton:Size(28)
	AuctionProgressFrameCancelButton:Point("LEFT", AuctionProgressBar, "RIGHT", 8, 0)

	AuctionProgressBarIcon.backdrop = CreateFrame("Frame", nil, AuctionProgressBarIcon:GetParent())
	AuctionProgressBarIcon.backdrop:SetTemplate()
	AuctionProgressBarIcon.backdrop:SetOutside(AuctionProgressBarIcon)

	AuctionProgressBarIcon:SetTexCoord(unpack(E.TexCoords))
	AuctionProgressBarIcon:SetParent(AuctionProgressBarIcon.backdrop)

	AuctionProgressBarText:ClearAllPoints()
	AuctionProgressBarText:SetPoint("CENTER")

	AuctionProgressBar:StripTextures()
	AuctionProgressBar:CreateBackdrop()
	AuctionProgressBar:SetStatusBarTexture(E.media.normTex)
	AuctionProgressBar:SetStatusBarColor(1, 1, 0)

	for Frame, NumButtons in pairs({["Browse"] = NUM_BROWSE_TO_DISPLAY, ["Auctions"] = NUM_AUCTIONS_TO_DISPLAY, ["Bid"] = NUM_BIDS_TO_DISPLAY}) do
		for i = 1, NumButtons do
			local Button = _G[Frame.."Button"..i]
			local ItemButton = _G[Frame.."Button"..i.."Item"]
			local Texture = _G[Frame.."Button"..i.."ItemIconTexture"]
			local Name = _G[Frame.."Button"..i.."Name"]
			local Highlight = _G[Frame.."Button"..i.."Highlight"]

			if Button then
				Button:StripTextures()
				Highlight:SetTexture(E.Media.Textures.Highlight)
				Highlight:SetInside()
				hooksecurefunc(Name, "SetVertexColor", function(_, r, g, b) Highlight:SetVertexColor(r, g, b, 0.35) end)
			end

			if ItemButton then
				ItemButton:SetTemplate()
				ItemButton:StyleButton()
				ItemButton:GetNormalTexture():SetTexture("")
				ItemButton:Point("TOPLEFT", 0, -1)
				ItemButton:Size(34)

				Texture:SetTexCoord(unpack(E.TexCoords))
				Texture:SetInside()

				hooksecurefunc(Name, "SetVertexColor", function(_, r, g, b) ItemButton:SetBackdropBorderColor(r, g, b) end)
				hooksecurefunc(Name, "Hide", function() ItemButton:SetBackdropBorderColor(unpack(E.media.bordercolor)) end)
			end
		end
	end

	-- Custom Backdrops
	for _, Frame in pairs({AuctionFrameBrowse, AuctionFrameAuctions}) do
		Frame.LeftBackground = CreateFrame("Frame", nil, Frame)
		Frame.LeftBackground:SetTemplate("Transparent")
		Frame.LeftBackground:SetFrameLevel(Frame:GetFrameLevel() - 1)

		Frame.RightBackground = CreateFrame("Frame", nil, Frame)
		Frame.RightBackground:SetTemplate("Transparent")
		Frame.RightBackground:SetFrameLevel(Frame:GetFrameLevel() - 1)
	end

	AuctionFrameAuctions.LeftBackground:Point("TOPLEFT", 15, -72)
	AuctionFrameAuctions.LeftBackground:Point("BOTTOMRIGHT", -545, 34)

	AuctionFrameAuctions.RightBackground:Point("TOPLEFT", AuctionFrameAuctions.LeftBackground, "TOPRIGHT", 3, 0)
	AuctionFrameAuctions.RightBackground:Point("BOTTOMRIGHT", AuctionFrame, -8, 34)

	AuctionFrameBrowse.LeftBackground:Point("TOPLEFT", 20, -103)
	AuctionFrameBrowse.LeftBackground:Point("BOTTOMRIGHT", -575, 34)

	AuctionFrameBrowse.RightBackground:Point("TOPLEFT", AuctionFrameBrowse.LeftBackground, "TOPRIGHT", 4, 0)
	AuctionFrameBrowse.RightBackground:Point("BOTTOMRIGHT", AuctionFrame, "BOTTOMRIGHT", -8, 34)

	AuctionFrameBid.Background = CreateFrame("Frame", nil, AuctionFrameBid)
	AuctionFrameBid.Background:SetTemplate("Transparent")
	AuctionFrameBid.Background:Point("TOPLEFT", 22, -72)
	AuctionFrameBid.Background:Point("BOTTOMRIGHT", 66, 34)
	AuctionFrameBid.Background:SetFrameLevel(AuctionFrameBid:GetFrameLevel() - 1)
end

S:AddCallbackForAddon("Blizzard_AuctionUI", "AuctionHouse", LoadSkin)