local E, L, V, P, G = unpack(ElvUI)
local AS = E:GetModule("AddOnSkins")
local S = E:GetModule("Skins")

local _G = _G
local select, unpack = select, unpack

local function LoadSkin()
	if not E.private.addOnSkins.AtlasLoot then return end

	-- Default Frame
	AtlasLootDefaultFrame:StripTextures()
	AtlasLootDefaultFrame:CreateBackdrop("Transparent")
	AtlasLootDefaultFrame.backdrop:Point("TOPLEFT", 24, -18)
	AtlasLootDefaultFrame.backdrop:Point("BOTTOMRIGHT", -4, 0)
	AtlasLootDefaultFrame:Size(790, 630)

	AtlasLootDefaultFrame.VersionNumber:Hide()

	AtlasLootDefaultFrame.Title:Point("TOP", Frame, "TOP", 0, -23)

	S:HandleDropDownBox(AtlasLootDefaultFrame.ModuleSelect, 240)
	AtlasLootDefaultFrame.ModuleSelect:Point("TOPLEFT", 20, -54)
	AtlasLootDefaultFrame.ModuleSelect.Text:SetTextColor(1, 1, 1)

	S:HandleDropDownBox(AtlasLootDefaultFrame.InstanceSelect, 255)
	AtlasLootDefaultFrame.InstanceSelect:Point("LEFT", AtlasLootDefaultFrame.ModuleSelect, "RIGHT", 252, -2)
	AtlasLootDefaultFrame.InstanceSelect.Text:SetTextColor(1, 1, 1)

	AtlasLootDefaultFrame.InstanceName:Point("TOPLEFT", 526, -95)
	AtlasLootDefaultFrame.InstanceName:SetTextColor(1, 0.8, 0.1)

	AtlasLootDefaultFrame.ScrollFrame:CreateBackdrop("Transparent")
	AtlasLootDefaultFrame.ScrollFrame.backdrop:Point("TOPLEFT", 10, 1)
	AtlasLootDefaultFrame.ScrollFrame:Show()
	AtlasLootDefaultFrame.ScrollFrame.Hide = E.noop
	AtlasLootDefaultFrame.ScrollFrame:Point("TOPLEFT", 515, -112)
	AtlasLootDefaultFrame.ScrollFrame:Size(240, 431)

	S:HandleScrollBar(AtlasLootDefaultFrame.ScrollFrame.ScrollBar)

	AtlasLootDefaultFrame.ScrollFrame:HookScript("OnUpdate", function()
		for i = 1, 30 do
			local Button = _G["AtlasLootDefaultFrame_ScrollLine"..i]

			if Button and not Button.isSkinned then
				Button:Width(225)

				Button:SetHighlightTexture(E.Media.Textures.Highlight)
				Button.SetHighlightTexture = E.noop

				local Highlight = Button:GetHighlightTexture()
				Highlight:SetVertexColor(1, 0.8, 0.1, 0.35)
				Highlight:Point("TOPLEFT", 0, -1)
				Highlight:Point("BOTTOMRIGHT", 0, 1)

				Button.Selected:SetTexture(E.Media.Textures.Highlight)
				Button.Selected:SetVertexColor(1, 0.8, 0.1, 0.35)
				Button.Selected:Point("TOPLEFT", 0, -1)
				Button.Selected:Point("BOTTOMRIGHT", 0, 1)

				Button.Text:SetTextColor(1, 1, 1)
				Button.Loot:SetAlpha(0)

				Button.isSkinned = true
			end
		end
	end)

	S:HandleButton(AtlasLootDefaultFrame.CompareFrame)
	AtlasLootDefaultFrame.CompareFrame:Point("TOPLEFT", 337, -547)
	AtlasLootDefaultFrame.CompareFrame:Size(185, 24)

	-- Bonus Roll Button
	AtlasLootItemsFrame_BonusRoll:CreateBackdrop()
	AtlasLootItemsFrame_BonusRoll:Size(24)
	AtlasLootItemsFrame_BonusRoll:StyleButton()
	AtlasLootItemsFrame_BonusRoll.hover:SetInside(AtlasLootItemsFrame_BonusRoll.backdrop)
	AtlasLootItemsFrame_BonusRoll:ClearAllPoints()
	AtlasLootItemsFrame_BonusRoll.ClearAllPoints = E.noop
	AtlasLootItemsFrame_BonusRoll:Point("RIGHT", AtlasLootDefaultFrame.EncounterJournal, "LEFT", -4, 0)
	AtlasLootItemsFrame_BonusRoll.SetPoint = E.noop

	AtlasLootItemsFrame_BonusRollIcon:SetTexCoord(unpack(E.TexCoords))
	AtlasLootItemsFrame_BonusRollIcon:SetInside(AtlasLootItemsFrame_BonusRoll.backdrop)

	AtlasLootItemsFrame_BonusRollRing:SetTexture(nil)

	-- Encounter Journal Button
	AtlasLootDefaultFrame.EncounterJournal:CreateBackdrop()
	AtlasLootDefaultFrame.EncounterJournal:Size(24)
	AtlasLootDefaultFrame.EncounterJournal:StyleButton(nil, true)
	AtlasLootDefaultFrame.EncounterJournal.hover:SetInside(AtlasLootDefaultFrame.EncounterJournal.backdrop)
	AtlasLootDefaultFrame.EncounterJournal:ClearAllPoints()
	AtlasLootDefaultFrame.EncounterJournal:Point("LEFT", AtlasLootDefaultFrame.CompareFrame, "RIGHT", -28, -28)

	AtlasLootDefaultFrame_EncounterJournalIcon:SetTexCoord(unpack(E.TexCoords))
	AtlasLootDefaultFrame_EncounterJournalIcon:SetInside(AtlasLootDefaultFrame.EncounterJournal.backdrop)

	AtlasLootDefaultFrame_EncounterJournalRing:SetTexture(nil)

	AS:Desaturate(AtlasLootDefaultFrame.LockButton)

	S:HandleCloseButton(AtlasLootDefaultFrame.CloseButton, AtlasLootDefaultFrame.backdrop)

	-- Item Frame
	AtlasLoot.ItemFrame:StripTextures()
	AtlasLoot.ItemFrame:CreateBackdrop("Transparent")
	AtlasLoot.ItemFrame.backdrop:Point("TOPLEFT", 15, -27)
	AtlasLoot.ItemFrame.backdrop:Point("BOTTOMRIGHT", -6, 50)

	for i = 1, 30 do
		local Item = _G["AtlasLootItem_"..i]

		Item:CreateBackdrop()
		Item.backdrop:SetOutside(Item.MenuIcon)

		Item:StyleButton(nil, true)
		Item.hover:Point("TOPLEFT", 26, 0)
		Item.hover:Point("BOTTOMRIGHT", -2, 2)

		Item.MenuIcon:SetTexCoord(unpack(E.TexCoords))
		Item.MenuIcon:Size(24)
		Item.MenuIcon:Point("TOPLEFT", nil, "TOPLEFT", 0, -1)
		Item.MenuIconBorder:SetTexture(nil)

		Item.Icon:SetTexCoord(unpack(E.TexCoords))
		Item.Icon:SetInside(Item.backdrop)
		Item.Icon:Size(24)

		Item.QueryIcon:SetTexCoord(unpack(E.TexCoords))
		Item.QueryIcon:SetInside(Item.backdrop)

		Item.Unsafe:SetTexture(1, 0, 0, 0.5)
		Item.Unsafe:SetInside(Item.backdrop)
		Item.Unsafe:SetDrawLayer("OVERLAY")

		Item.QA:StyleButton(nil, true)

		Item.QA.ExtraIcon:SetTexCoord(unpack(E.TexCoords))
		Item.QA.ExtraIcon:Size(12)

		for j = 1, 4 do
			_G["AtlasLootItem_"..i.."_BonusRoll_Spec"..j.."SpecIcon"]:SetTexCoord(unpack(E.TexCoords))
		end
	end

	AtlasLoot.ItemFrame.BossName:SetTextColor(1, 0.8, 0.1)
	AtlasLoot.ItemFrame.BossName:Point("TOPLEFT", AtlasLoot.ItemFrame, "TOPLEFT", 18, -2)
	AtlasLoot.ItemFrame.BossName:SetJustifyH("LEFT")

	S:HandleNextPrevButton(AtlasLoot.ItemFrame.QuickLooks, nil, {1, 0.8, 0.1})
	AtlasLoot.ItemFrame.QuickLooks:Point("BOTTOM", -114, 25)
	AtlasLoot.ItemFrame.QuickLooks:Size(20)
	AtlasLoot.ItemFrame.QuickLooks.BG = CreateFrame("Frame", nil, AtlasLoot.ItemFrame.QuickLooks)
	AtlasLoot.ItemFrame.QuickLooks.BG:CreateBackdrop()
	AtlasLoot.ItemFrame.QuickLooks.BG:Point("TOPLEFT", AtlasLoot.ItemFrame.QuickLooksName, 91, -2)
	AtlasLoot.ItemFrame.QuickLooks.BG:Point("BOTTOMRIGHT", AtlasLoot.ItemFrame.QuickLooks, 1, -1)

	AtlasLoot.ItemFrame.QuickLooksName:Point("BOTTOM", -230, 23)
	AtlasLoot.ItemFrame.QuickLooksName:SetParent(AtlasLoot.ItemFrame.QuickLooks.BG)
	AtlasLoot.ItemFrame.QuickLooksName:SetTextColor(1, 1, 1)

	S:HandleButton(AtlasLoot.ItemFrame.Back)
	AtlasLoot.ItemFrame.Back:Size(100, 24)
	AtlasLoot.ItemFrame.Back:Point("BOTTOM", 114, -4)

	S:HandleButton(AtlasLoot.ItemFrame.Switch)
	AtlasLoot.ItemFrame.Switch:Height(24)
	AtlasLoot.ItemFrame.Switch:Point("BOTTOM", AtlasLoot.ItemFrame, "BOTTOM", -19, 23)

	S:HandleCheckBox(AtlasLoot.ItemFrame.Filter)
	AtlasLoot.ItemFrame.Filter:Point("BOTTOM", -105, -5)
	AtlasLootFilterCheckText:SetTextColor(1, 1, 1)

	S:HandleCheckBox(AtlasLoot.ItemFrame.Heroic)
	AtlasLoot.ItemFrame.Heroic:Point("BOTTOM", -231, -5)
	AtlasLoot.ItemFrame.Heroic:Size(26)
	AtlasLootItemsFrame_HeroicText:SetTextColor(1, 1, 1)

	S:HandleCheckBox(AtlasLoot.ItemFrame.RaidFinder)
	AtlasLoot.ItemFrame.RaidFinder:Size(26)
	AtlasLootItemsFrame_RaidFinderText:SetTextColor(1, 1, 1)

	S:HandleCheckBox(AtlasLoot.ItemFrame.Flexible)
	AtlasLoot.ItemFrame.Flexible:Size(26)
	AtlasLoot.ItemFrame.Flexible:Point("TOPLEFT", AtlasLootItemsFrame_RaidFinder, "TOPRIGHT", 100, 0)
	AtlasLootItemsFrame_FlexibleText:SetTextColor(1, 1, 1)

	S:HandleCheckBox(AtlasLoot.ItemFrame.Thunderforged)
	AtlasLoot.ItemFrame.Thunderforged:Size(26)
	AtlasLoot.ItemFrame.Thunderforged:Point("TOPLEFT", AtlasLootItemsFrame_Flexible, "TOPRIGHT", 100, 0)
	AtlasLootItemsFrame_ThunderforgedText:SetTextColor(1, 1, 1)

	S:HandleNextPrevButton(AtlasLoot.ItemFrame.Next, nil, nil, true)
	AtlasLoot.ItemFrame.Next:Size(32)
	AtlasLoot.ItemFrame.Next:Point("BOTTOMRIGHT", 254, -30)

	S:HandleNextPrevButton(AtlasLoot.ItemFrame.Prev, nil, nil, true)
	AtlasLoot.ItemFrame.Prev:Size(32)
	AtlasLoot.ItemFrame.Prev:Point("BOTTOMLEFT", 692, -30)

	AtlasLoot.ItemFrame.EncounterJournal:Kill()

	-- Info Frame
	AtlasLoot.AtlasInfoFrame.Info:Hide()
	AtlasLoot.AtlasInfoFrame.Version:Hide()

	S:HandleButton(AtlasLoot.AtlasInfoFrame.Button)
	AtlasLoot.AtlasInfoFrame.Button:Point("TOPLEFT", -10, -510)
	AtlasLoot.AtlasInfoFrame.Button:Height(24)

	-- Loot Panel
	AtlasLoot.AtlasLootPanel:StripTextures()
	AtlasLoot.AtlasLootPanel:CreateBackdrop("Transparent")
	AtlasLoot.AtlasLootPanel.backdrop:Point("TOPLEFT", 24, 0)
	AtlasLoot.AtlasLootPanel.backdrop:Point("BOTTOMRIGHT", -4, 2)
	AtlasLoot.AtlasLootPanel:Width(AtlasLootDefaultFrame:GetWidth())
	AtlasLoot.AtlasLootPanel.SetWidth = E.noop
	AtlasLoot.AtlasLootPanel:Point("TOP", AtlasLootDefaultFrame, "BOTTOM", 0, -1)
	AtlasLoot.AtlasLootPanel.SetPoint = E.noop

	AtlasLoot.AtlasLootPanel.Titel:Hide()

	AtlasLoot.AtlasLootPanel:HookScript("OnShow", function()
		for i = 1, 12 do
			local button = _G["AtlasLoot_PanelButton_"..i]

			if not button.isSkinned then
				S:HandleButton(button)
				button:Height(24)
				button.SetHeight = E.noop

				if i == 1 then
					button:Point("TOPLEFT", AtlasLoot.AtlasLootPanel, "TOPLEFT", 39, -14)
				elseif i == 7 then
					button:Point("TOPLEFT", AtlasLoot.AtlasLootPanel, "TOPLEFT", 39, -40)
				else
					button:Point("LEFT", _G["AtlasLoot_PanelButton_"..(i - 1)], "RIGHT", 2, 0)
				end
				button.SetPoint = E.noop

				button.isSkinned = true
			end
		end
	end)

	S:HandleEditBox(AtlasLootPanelSearch_Box)
	AtlasLootPanelSearch_Box:Size(240, 20)
	AtlasLootPanelSearch_Box:ClearAllPoints()
	AtlasLootPanelSearch_Box:Point("TOP", AtlasLoot_PanelButton_7, "BOTTOM", 61, -3)

	S:HandleButton(AtlasLootPanelSearch_SearchButton)
	AtlasLootPanelSearch_SearchButton:Size(120, 22)
	AtlasLootPanelSearch_SearchButton:Point("LEFT", AtlasLootPanelSearch_Box, "RIGHT", 3, 0)

	S:HandleNextPrevButton(AtlasLootPanelSearch_SelectModuel)
	AtlasLootPanelSearch_SelectModuel:Size(22)
	AtlasLootPanelSearch_SelectModuel:Point("LEFT", AtlasLootPanelSearch_SearchButton, "RIGHT", 2, 0)

	S:HandleButton(AtlasLootPanelSearch_ClearButton)
	AtlasLootPanelSearch_ClearButton:Size(120, 22)
	AtlasLootPanelSearch_ClearButton:Point("LEFT", AtlasLootPanelSearch_SelectModuel, "RIGHT", 100, 0)

	S:HandleButton(AtlasLootPanelSearch_LastResultButton)
	AtlasLootPanelSearch_LastResultButton:Size(120, 22)
	AtlasLootPanelSearch_LastResultButton:Point("LEFT", AtlasLootPanelSearch_ClearButton, "RIGHT", 2, 0)

	-- Compare Frame
	AtlasLootCompareFrame:StripTextures()
	AtlasLootCompareFrame:SetTemplate("Transparent")

	AtlasLootCompareFrame_ScrollFrameMainFilterScrollChildFrame:StripTextures()
	AtlasLootCompareFrame.ScrollFrameItemFrame:StripTextures()
	AtlasLootCompareFrame.ScrollFrameMainFilter:StripTextures()

	S:HandleDropDownBox(AtlasLootCompareFrameSearch_StatsListDropDown)
	AtlasLootCompareFrameSearch_StatsListDropDown:Width(240)
	AtlasLootCompareFrameSearch_StatsListDropDown:Point("TOPRIGHT", -25, -38)

	S:HandleDropDownBox(AtlasLootCompareFrame_WishlistDropDown)
	AtlasLootCompareFrame_WishlistDropDown:Width(240)

	S:HandleEditBox(AtlasLootCompareFrameSearch_Box)
	AtlasLootCompareFrameSearch_Box:Size(145, 20)
	AtlasLootCompareFrameSearch_Box:ClearAllPoints()
	AtlasLootCompareFrameSearch_Box:Point("TOPLEFT", AtlasLootCompareFrame, "TOPLEFT", 13, -60)

	S:HandleButton(AtlasLootCompareFrameSearch_SearchButton)
	AtlasLootCompareFrameSearch_SearchButton:Size(122, 22)
	AtlasLootCompareFrameSearch_SearchButton:ClearAllPoints()
	AtlasLootCompareFrameSearch_SearchButton:Point("TOPRIGHT", AtlasLootCompareFrameSearch_Box, "TOPLEFT", 121, 26)

	S:HandleNextPrevButton(AtlasLootCompareFrameSearch_SelectModuel)
	AtlasLootCompareFrameSearch_SelectModuel:Size(22)
	AtlasLootCompareFrameSearch_SelectModuel:Point("LEFT", AtlasLootCompareFrameSearch_SearchButton, "RIGHT", 3, 0)

	AtlasLootCompareFrameSearch_ClearButton:Hide()

	S:HandleButton(AtlasLootCompareFrame_CloseButton2)
	AtlasLootCompareFrame_CloseButton2:Point("BOTTOMRIGHT", -38, 9)

	S:HandleButton(AtlasLootCompareFrame_WishlistButton)
	AtlasLootCompareFrame_WishlistButton:Point("RIGHT", AtlasLootCompareFrame_CloseButton2, "LEFT", -4, 0)

	S:HandleCheckBox(AtlasLootCompareFrameSearch_FilterCheck)
	AtlasLootCompareFrameSearch_FilterCheck:Point("TOPLEFT", 183, -412)
	AtlasLootCompareFrameSearch_FilterCheckText:SetTextColor(1, 1, 1)
	S:HandleScrollBar(AtlasLootCompareFrame_WishlistScrollFrameScrollBar)

	AtlasLootCompareFrame.EncounterJournal:SetTemplate()
	AtlasLootCompareFrame.EncounterJournal:Size(20)
	AtlasLootCompareFrame.EncounterJournal:StyleButton(nil, true)
	AtlasLootCompareFrame_EncounterJournalIcon:SetTexCoord(unpack(E.TexCoords))
	AtlasLootCompareFrame_EncounterJournalIcon:SetInside()
	AtlasLootCompareFrame_EncounterJournalRing:SetTexture(nil)

	S:HandleCloseButton(AtlasLootCompareFrame.CloseButton)
	AtlasLootCompareFrame.CloseButton:Point("TOPRIGHT", -2, 2)

	S:HandleCloseButton(AtlasLootCompareFrame_CloseButton_Wishlist)

	AtlasLootCompareFrame_ScrollFrameMainFilter:CreateBackdrop("Transparent")
	AtlasLootCompareFrame_ScrollFrameMainFilter.backdrop:Point("TOPLEFT", 14, 0)
	AtlasLootCompareFrame_ScrollFrameMainFilter.backdrop:Point("BOTTOMRIGHT", 0, 0)

	AtlasLootCompareFrame_ScrollFrameMainFilter:Show()
	AtlasLootCompareFrame_ScrollFrameMainFilter.Hide = E.noop

	S:HandleScrollBar(AtlasLootCompareFrame_ScrollFrameMainFilterScrollBar)

	for i = 1, 15 do
		local Button = _G["AtlasLootCompareFrameMainFilterButton"..i]

		Button:StripTextures()
		Button:Width(136)
		Button.SetWidth = E.noop

		if i == 1 then
			Button:Point("TOPLEFT", 15, -105)
		end

		Button:SetHighlightTexture(E.Media.Textures.Highlight)
		Button.SetHighlightTexture = E.noop

		local Highlight = Button:GetHighlightTexture()
		Highlight:SetVertexColor(1, 0.8, 0.1, 0.35)
		Highlight:Point("TOPLEFT", 0, -1)
		Highlight:Point("BOTTOMRIGHT", 0, 1)
	end

	AtlasLootCompareFrame_ScrollFrameItemFrame:CreateBackdrop("Transparent")

	AtlasLootCompareFrame_ScrollFrameItemFrame:Show()
	AtlasLootCompareFrame_ScrollFrameItemFrame.Hide = E.noop

	S:HandleScrollBar(AtlasLootCompareFrame_ScrollFrameItemFrameScrollBar)

	for i = 1, 8 do
		local Button = _G["AtlasLootCompareFrame_ScrollFrameItemFrame_Item"..i]

		Button:StripTextures()

		Button:SetHighlightTexture(E.Media.Textures.Highlight)
		Button.SetHighlightTexture = E.noop

		local Highlight = Button:GetHighlightTexture()
		Highlight:SetVertexColor(1, 0.8, 0.1, 0.35)
		Highlight:Point("TOPLEFT", 0, -1)
		Highlight:Point("BOTTOMRIGHT", 0, 1)

		for j = 1, Button:GetNumChildren() do
			local child = select(j, Button:GetChildren())

			if child then
				S:HandleItemButton(child)
			end
		end
	end

	AtlasLootCompareFrameSortButton_Name:StripTextures()
	AtlasLootCompareFrameSortButton_Name:SetNormalTexture([[Interface\Buttons\UI-SortArrow]])
	AtlasLootCompareFrameSortButton_Name:StyleButton()
	AtlasLootCompareFrameSortButton_Name:Width(99)
	AtlasLootCompareFrameSortButton_Name.SetWidth = E.noop

	AtlasLootCompareFrameSortButton_Rarity:StripTextures()
	AtlasLootCompareFrameSortButton_Rarity:SetNormalTexture([[Interface\Buttons\UI-SortArrow]])
	AtlasLootCompareFrameSortButton_Rarity:StyleButton()
	AtlasLootCompareFrameSortButton_Rarity:Width(99)
	AtlasLootCompareFrameSortButton_Rarity.SetWidth = E.noop

	AtlasLootCompareFrame:HookScript("OnUpdate", function(self)
		for i = 1, 9 do
			local Button = _G["AtlasLootCompareFrameSortButton_"..i]

			if Button and not Button.isSkinned then
				Button:StripTextures()
				Button:SetNormalTexture([[Interface\Buttons\UI-SortArrow]])
				Button:GetNormalTexture():ClearAllPoints()
				Button:GetNormalTexture():Point("LEFT", Button, "RIGHT", -10, 0)
				Button:GetNormalTexture().SetPoint = E.noop
				Button:StyleButton()
				Button:Width(50)
				Button.SetWidth = E.noop

				Button.isSkinned = true
			end
		end
	end)

	-- Tooltip
	AtlasLootTooltip:HookScript("OnShow", function(self)
		self:SetTemplate("Transparent")

		local link = select(2, self:GetItem())
		local quality = link and select(3, GetItemInfo(link))

		if quality and quality > 1 then
			self:SetBackdropBorderColor(GetItemQualityColor(quality))
		else
			self:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end)
end

S:AddCallbackForAddon("AtlasLoot", "AtlasLoot", LoadSkin)