local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local pairs, ipairs, select, unpack = pairs, ipairs, select, unpack

local GetItemIcon = GetItemIcon
local IsAddOnLoaded = IsAddOnLoaded

local function LoadSkin()
	if not E.private.addOnSkins.Auctionator then return end

	hooksecurefunc("Atr_SetTextureButton", function(elementName, _, itemlink)
		local textureElement = _G[elementName]

		if not textureElement.backdrop then
			textureElement:StyleButton(nil, true)
			textureElement:SetTemplate("Default", true)

			textureElement.backdrop = true
		end

		if GetItemIcon(itemlink) then
			local normal = textureElement:GetNormalTexture()

			normal:SetTexCoord(unpack(E.TexCoords))
			normal:SetInside()
		end
	end)

	Atr_Error_Frame:SetTemplate("Transparent")
	S:HandleButton((Atr_Error_Frame:GetChildren()))

	Atr_Confirm_Frame:SetTemplate("Transparent")
	S:HandleButton(Atr_Confirm_Cancel)
	S:HandleButton(select(2, Atr_Confirm_Frame:GetChildren()))

	S:HandleButton(Atr_UCConfigFrame_Reset)
	S:HandleButton(Atr_StackingOptionsFrame_Edit)
	S:HandleButton(Atr_StackingOptionsFrame_New)

	S:SecureHook("Atr_OnAddonLoaded", function()
		if not IsAddOnLoaded("Blizzard_TradeSkillUI") then return end
		S:HandleButton(Auctionator_Search)
	end)

	S:SecureHook("Atr_OnAuctionHouseShow", function()
		AuctionatorTitle:Point("TOP", -68, -5)

		-- Buy Tab
		S:HandleDropDownBox(Atr_DropDownSL, 210)
		Atr_DropDownSL:Point("TOPLEFT", -210, -36)
		Atr_DropDownSLText:ClearAllPoints()
		Atr_DropDownSLText.ClearAllPoints = E.noop
		Atr_DropDownSLText:Point("LEFT", Atr_DropDownSL, 18, 0)
		Atr_DropDownSLText.SetPoint = E.noop
		Atr_DropDownSLText:SetJustifyH("LEFT")
		Atr_DropDownSLText.SetJustifyH = E.noop

		S:HandleEditBox(Atr_Search_Box)
		Atr_Search_Box:Point("TOPLEFT", 7, -41)

		S:HandleButton(Atr_Search_Button)
		Atr_Search_Button:Point("LEFT", Atr_Search_Box, "RIGHT", 5, 0)

		S:HandleButton(Atr_Adv_Search_Button)
		Atr_Adv_Search_Button:Height(22)
		Atr_Adv_Search_Button:Point("LEFT", Atr_Search_Button, "RIGHT", 5, 0)

		S:HandleButton(Atr_FullScanButton)
		Atr_FullScanButton:Size(132, 22)
		Atr_FullScanButton:ClearAllPoints()
		Atr_FullScanButton:Point("LEFT", Atr_Adv_Search_Button, "RIGHT", 5, 0)

		S:HandleButton(Auctionator1Button)
		Auctionator1Button:Height(22)
		Auctionator1Button:ClearAllPoints()
		Auctionator1Button:Point("LEFT", Atr_FullScanButton, "RIGHT", 5, 0)

		Atr_Hlist:StripTextures()
		Atr_Hlist:CreateBackdrop("Transparent")
		Atr_Hlist.backdrop:Point("BOTTOMRIGHT", 6, 0)
		Atr_Hlist:ClearAllPoints()
		Atr_Hlist:Point("TOPLEFT", -197, -70)

		S:HandleScrollBar(Atr_Hlist_ScrollFrameScrollBar)
		Atr_Hlist_ScrollFrameScrollBar:ClearAllPoints()
		Atr_Hlist_ScrollFrameScrollBar:Point("TOPRIGHT", Atr_Hlist, 27, -17)
		Atr_Hlist_ScrollFrameScrollBar:Point("BOTTOMRIGHT", Atr_Hlist, 0, 18)

		for i = 1, 20 do
			local entry = _G["AuctionatorHEntry"..i]

			S:HandleButtonHighlight(entry)

			for j = 1, entry:GetNumRegions() do
				local region = select(j, entry:GetRegions())

				if (region.IsObjectType and region:IsObjectType("Texture")) and (region.GetTexture and region:GetTexture() == "Interface\\HelpFrame\\HelpFrameButton-Highlight") then
					region:SetTexture(E.Media.Textures.Highlight)
					region:SetVertexColor(1, 0.82, 0, 0.35)
					region:SetTexCoord(0, 1, 0, 1)
					region.SetTexCoord = E.noop
				end
			end
		end

		S:HandleButton(Atr_AddToSListButton)
		Atr_AddToSListButton:Point("TOPLEFT", -198, -326)

		S:HandleButton(Atr_RemFromSListButton)
		Atr_RemFromSListButton:Point("TOPLEFT", -100, -326)

		S:HandleButton(Atr_SrchSListButton)
		Atr_SrchSListButton:Point("TOPLEFT", -198, -347)
		Atr_SrchSListButton:Width(199)

		S:HandleButton(Atr_MngSListsButton)
		Atr_MngSListsButton:Point("TOPLEFT", -198, -368)
		Atr_MngSListsButton:Width(199)

		S:HandleButton(Atr_NewSListButton)
		Atr_NewSListButton:Point("TOPLEFT", -198, -389)
		Atr_NewSListButton:Width(199)

		-- Sell Tab
		Atr_SellControls:CreateBackdrop("Transparent")
		Atr_SellControls.backdrop:Point("TOPLEFT", 0, 0)
		Atr_SellControls.backdrop:Point("BOTTOMRIGHT", 27, 1)

		S:HandleButton(Atr_CreateAuctionButton)

		S:HandleButton(Atr_CheckActiveButton)
		Atr_CheckActiveButton:SetWidth(195)

		S:HandleEditBox(Atr_StackPriceGold)
		S:HandleEditBox(Atr_StackPriceSilver)
		S:HandleEditBox(Atr_StackPriceCopper)
		S:HandleEditBox(Atr_ItemPriceGold)
		S:HandleEditBox(Atr_ItemPriceSilver)
		S:HandleEditBox(Atr_ItemPriceCopper)
		S:HandleEditBox(Atr_StartingPriceGold)
		S:HandleEditBox(Atr_StartingPriceSilver)
		S:HandleEditBox(Atr_StartingPriceCopper)
		S:HandleEditBox(Atr_Batch_NumAuctions)
		S:HandleEditBox(Atr_Batch_Stacksize)

		S:HandleDropDownBox(Atr_Duration, 130)
		Atr_Duration:Point("TOPLEFT", Atr_Duration_Text, 56, 7)

		Atr_Batch_MaxAuctions_Text:ClearAllPoints()
		Atr_Batch_MaxAuctions_Text:Point("BOTTOM", Atr_Batch_NumAuctions, 0, -14)

		Atr_Batch_MaxStacksize_Text:ClearAllPoints()
		Atr_Batch_MaxStacksize_Text:Point("BOTTOM", Atr_Batch_Stacksize, 0, -14)

		S:HandleButton(AuctionatorCloseButton)
		AuctionatorCloseButton:Point("BOTTOMRIGHT", Atr_Main_Panel, 66, 6)

		S:HandleButton(Atr_CancelSelectionButton)
		S:HandleButton(Atr_Buy1_Button)

		AuctionatorScrollFrame:CreateBackdrop("Transparent")
		AuctionatorScrollFrame.backdrop:Point("TOPLEFT", 7, 1)
		AuctionatorScrollFrame.backdrop:Point("BOTTOMRIGHT", 5, 0)
		AuctionatorScrollFrame:Show()
		AuctionatorScrollFrame.Hide = E.noop

		S:HandleScrollBar(AuctionatorScrollFrameScrollBar)
		AuctionatorScrollFrameScrollBar:ClearAllPoints()
		AuctionatorScrollFrameScrollBar:Point("TOPRIGHT", AuctionatorScrollFrame, 26, -17)
		AuctionatorScrollFrameScrollBar:Point("BOTTOMRIGHT", AuctionatorScrollFrame, 0, 18)
		AuctionatorScrollFrameScrollBar.SetPoint = E.noop

		for i = 1, 12 do
			local entry = _G["AuctionatorEntry"..i]

			S:HandleButtonHighlight(entry)

			for j = 1, entry:GetNumRegions() do
				local region = select(j, entry:GetRegions())

				if (region.IsObjectType and region:IsObjectType("Texture")) and (region.GetTexture and region:GetTexture() == "Interface\\HelpFrame\\HelpFrameButton-Highlight") then
					region:SetTexture(E.Media.Textures.Highlight)
					region:SetVertexColor(1, 0.82, 0, 0.35)
					region:SetTexCoord(0, 1, 0, 1)
					region.SetTexCoord = E.noop
				end
			end
		end

		Atr_HeadingsBar:StripTextures()
		Atr_HeadingsBar:SetTemplate("Transparent")
		Atr_HeadingsBar:Size(586, 22)
		Atr_HeadingsBar:Point("TOPLEFT", 7, -188)

		for _, frame in pairs({"Atr_Col1_Heading_Button", "Atr_Col3_Heading_Button"}) do
			local header = _G[frame]

			header:SetHighlightTexture(E.Media.Textures.Highlight)

			local highlight = header:GetHighlightTexture()
			highlight:SetVertexColor(1, 0.8, 0.1, 0.35)
			highlight:Point("TOPLEFT", 0, -1)
			highlight:Point("BOTTOMRIGHT", 0, -1)
		end

		Atr_Col1_Heading_Button:Point("TOPLEFT", 46, 0)
		Atr_Col3_Heading_Button:Point("TOPLEFT", 172, 0)

		Atr_ActiveItems_Text:Point("TOP", -385, -50)
		for i = 1, 3 do
			local tab = _G["Atr_ListTabsTab"..i]

			tab:StripTextures()
			S:HandleButton(tab)
			tab:Height(22)

			if i == 3 then
				tab:Point("BOTTOMRIGHT", Atr_ListTabs, 0, 24)
			end
		end

		S:HandleButton(Atr_Back_Button)
		Atr_Back_Button:Height(22)
		Atr_Back_Button:Point("TOPLEFT", Atr_HeadingsBar, 0, 24)

		S:HandleButton(Atr_SaveThisList_Button)
		Atr_SaveThisList_Button:Height(22)
		Atr_SaveThisList_Button:Point("TOPLEFT", Atr_HeadingsBar, 0, 24)

		Atr_Hilite1:SetTemplate("Transparent", true, true)
		Atr_Hilite1:SetBackdropColor(0, 0, 0, 0)

		S:HandleDropDownBox(Atr_ASDD_Class, 180)
		S:HandleDropDownBox(Atr_ASDD_Subclass, 180)

		S:HandleButton(Atr_FullScanStartButton)
		S:HandleButton(Atr_FullScanDone)
		S:HandleButton(Atr_Adv_Search_ResetBut)
		S:HandleButton(Atr_Adv_Search_OKBut)
		S:HandleButton(Atr_Adv_Search_CancelBut)
		S:HandleButton(Atr_Buy_Confirm_OKBut)
		S:HandleButton(Atr_Buy_Confirm_CancelBut)

		S:HandleEditBox(Atr_AS_Searchtext)
		S:HandleEditBox(Atr_AS_Minlevel)
		S:HandleEditBox(Atr_AS_Maxlevel)

		Atr_FullScanResults:StripTextures()
		Atr_FullScanResults:SetTemplate("Transparent")

		Atr_Adv_Search_Dialog:StripTextures()
		Atr_Adv_Search_Dialog:SetTemplate("Transparent")

		Atr_FullScanFrame:StripTextures()
		Atr_FullScanFrame:SetTemplate("Transparent")

		Atr_Buy_Confirm_Frame:StripTextures()
		Atr_Buy_Confirm_Frame:SetTemplate("Transparent")

		Atr_CheckActives_Frame:StripTextures()
		Atr_CheckActives_Frame:SetTemplate("Transparent")

		Atr_Buy1_Button:Point("RIGHT", AuctionatorCloseButton, "LEFT", -5, 0)
		Atr_CancelSelectionButton:Point("RIGHT", Atr_Buy1_Button, "LEFT", -5, 0)

		for i = 1, AuctionFrame.numTabs do
			S:HandleTab(_G["AuctionFrameTab"..i])
		end

		Atr_Mask:SetAllPoints(AuctionFrame.backdrop)

		for i = 1, Atr_CheckActives_Frame:GetNumChildren() do
			local child = select(i, Atr_CheckActives_Frame:GetChildren())

			if child and child:IsObjectType("Button") then
				S:HandleButton(child)
			end
		end

		S:Unhook("Atr_OnAuctionHouseShow")
	end)

	-- Options
	local Frames = {
		Atr_BasicOptionsFrame,
		Atr_TooltipsOptionsFrame,
		Atr_UCConfigFrame,
		Atr_StackingOptionsFrame,
		Atr_ScanningOptionsFrame,
		AuctionatorDescriptionFrame,
		Atr_Stacking_List,
		AuctionatorResetsFrame,
		Atr_ShpList_Frame,
		Atr_ShpList_Options_Frame,
	}
	for _, frame in pairs(Frames) do
		frame:StripTextures()
	end

	local CheckBox = {
		AuctionatorOption_Enable_Alt_CB,
		AuctionatorOption_Open_All_Bags_CB,
		AuctionatorOption_Show_StartingPrice_CB,
		ATR_tipsVendorOpt_CB,
		ATR_tipsAuctionOpt_CB,
		ATR_tipsDisenchantOpt_CB,

	}
	for _, frame in pairs(CheckBox) do
		S:HandleCheckBox(frame)
	end

	local DropDown = {
		AuctionatorOption_Deftab,
		Atr_tipsShiftDD,
		Atr_deDetailsDD,
		Atr_scanLevelDD,
	}
	for _, frame in pairs(DropDown) do
		S:HandleDropDownBox(frame)
	end
	AuctionatorOption_Deftab:Width(130)
	Atr_tipsShiftDD:Width(160)

	local moneyEditBoxes = {
		"UC_5000000_MoneyInput",
		"UC_1000000_MoneyInput",
		"UC_200000_MoneyInput",
		"UC_50000_MoneyInput",
		"UC_10000_MoneyInput",
		"UC_2000_MoneyInput",
		"UC_500_MoneyInput",
	}
	for _, name in ipairs(moneyEditBoxes) do
		S:HandleEditBox(_G[name.."Gold"])
		S:HandleEditBox(_G[name.."Silver"])
		S:HandleEditBox(_G[name.."Copper"])
	end

	Atr_Stacking_List:CreateBackdrop("Transparent")
	Atr_ShpList_Frame:CreateBackdrop("Transparent")

	S:HandleEditBox(Atr_Starting_Discount)
	S:HandleEditBox(Atr_ScanOpts_MaxHistAge)

	Atr_deDetailsDDText:SetJustifyH("RIGHT")

	S:HandleButton(Atr_ShpList_DeleteButton)
	S:HandleButton(Atr_ShpList_EditButton)
	S:HandleButton(Atr_ShpList_RenameButton)
	S:HandleButton(Atr_ShpList_ExportButton)

	for _, frame in ipairs({_G["Atr_ShpList_Options_Frame"]:GetChildren()}) do
		if frame:GetName() == "Atr_ShpList_ImportButton" then
			S:HandleButton(frame)
		end
	end

	for i = 1, AuctionatorResetsFrame:GetNumChildren() do
		local child = select(i, AuctionatorResetsFrame:GetChildren())
		if child.IsObjectType and child:IsObjectType("Button") then
			S:HandleButton(child)
		end
	end

	S:HandleRadioButton(Atr_RB_N)
	S:HandleRadioButton(Atr_RB_S)
	S:HandleRadioButton(Atr_RB_M)
	S:HandleRadioButton(Atr_RB_L)
end

S:AddCallbackForAddon("Auctionator", "Auctionator", LoadSkin)