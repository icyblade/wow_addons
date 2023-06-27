local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local ipairs = ipairs
local find = string.find

local function LoadSkin()
	if not E.private.addOnSkins.AdvancedTradeSkillWindow then return end

	local scrollBars = {
		-- Main Frame
		"ATSWListScrollFrameScrollBar",
		"ATSWQueueScrollFrameScrollBar",
		-- Sorting Editor
		"ATSWCSUListScrollFrameScrollBar",
		"ATSWCSSListScrollFrameScrollBar"
	}

	local buttons = {
		-- Scan
		"ATSWScanDelayFrameSkipButton",
		"ATSWScanDelayFrameAbortButton",
		-- Main Frame
		"ATSWCSButton",
		"ATSWOptionsButton",
		"ATSWQueueAllButton",
		"ATSWCreateAllButton",
		"ATSWCreateButton",
		"ATSWQueueButton",
		"ATSWQueueStartStopButton",
		"ATSWQueueDeleteButton",
		"ATSWReagentsButton",
		"ATSWQueueItem1DeleteButton",
		"ATSWQueueItem2DeleteButton",
		"ATSWQueueItem3DeleteButton",
		"ATSWQueueItem4DeleteButton",
		-- Sorting Editor
		"ATSWAddCategoryButton",
		-- Reagent Frame
		"ATSWBuyReagentsButton",
		-- Options
		"ATSWOptionsFrameOKButton"
	}

	local checkBoxes = {
		-- Main Frame
		"ATSWHeaderSortButton",
		"ATSWNameSortButton",
		"ATSWDifficultySortButton",
		"ATSWCustomSortButton",
		"ATSWOnlyCreatableButton",
		-- Options
		"ATSWOFUnifiedCounterButton",
		"ATSWOFSeparateCounterButton",
		"ATSWOFIncludeBankButton",
		"ATSWOFIncludeAltsButton",
		"ATSWOFIncludeMerchantsButton",
		"ATSWOFAutoBuyButton",
		"ATSWOFTooltipButton",
		"ATSWOFShoppingListButton",
		"ATSWOFReagentListButton"
	}

	local editBoxes = {
		-- Main Frame
		"ATSWFilterBox",
		"ATSWInputBox",
		-- Sorting Editor
		"ATSWCSNewCategoryBox"
	}

	local dropDownBoxes = {
		-- Main Frame
		"ATSWSubClassDropDown",
		"ATSWInvSlotDropDown"
	}

	local closeButtons = {
		-- Main Frame
		"ATSWFrameCloseButton",
		-- Reagent Frame
		"ATSWReagentFrameCloseButton",
		-- Sorting Editor
		"ATSWCSFrameCloseButton"
	}

	local statusBars = {
		-- Scan
		"ATSWScanDelayFrameBar",
		-- Main Frame
		"ATSWRankFrame"
	}

	for _, scrollBar in ipairs(scrollBars) do
		_G[scrollBar]:GetParent():StripTextures()
		S:HandleScrollBar(_G[scrollBar])
	end
	for _, button in ipairs(buttons) do
		S:HandleButton(_G[button])
	end
	for _, checkBox in ipairs(checkBoxes) do
		S:HandleCheckBox(_G[checkBox])
	end
	for _, editBox in ipairs(editBoxes) do
		S:HandleEditBox(_G[editBox])
	end
	for _, dropDownBox in ipairs(dropDownBoxes) do
		S:HandleDropDownBox(_G[dropDownBox])
	end
	for _, closeButton in ipairs(closeButtons) do
		S:HandleCloseButton(_G[closeButton], _G[closeButton]:GetParent().backdrop)
	end
	for _, statusBar in ipairs(statusBars) do
		_G[statusBar]:StripTextures()
		_G[statusBar]:CreateBackdrop()
		_G[statusBar]:SetStatusBarTexture(E.media.normTex)
		E:RegisterStatusBar(_G[statusBar])
	end

	ATSWScanDelayFrame:StripTextures()
	ATSWScanDelayFrame:SetTemplate("Transparent")

	ATSWOptionsFrame:SetParent(E.UIParent)
	ATSWOptionsFrame:StripTextures()
	ATSWOptionsFrame:SetTemplate("Transparent")

	ATSWFrame:StripTextures()
	ATSWFrame:CreateBackdrop("Transparent")
	ATSWFrame.backdrop:Point("TOPLEFT", 10, -12)
	ATSWFrame.backdrop:Point("BOTTOMRIGHT", -34, 10)
	ATSWFrame:SetClampedToScreen()

	ATSWCSFrame:StripTextures()
	ATSWCSFrame:CreateBackdrop("Transparent")
	ATSWCSFrame.backdrop:Point("TOPLEFT", 10, -12)
	ATSWCSFrame.backdrop:Point("BOTTOMRIGHT", -34, 10)
	ATSWCSFrame:SetClampedToScreen()

	ATSWReagentFrame:StripTextures()
	ATSWReagentFrame:CreateBackdrop("Transparent")
	ATSWReagentFrame.backdrop:Point("TOPLEFT", 12, -14)
	ATSWReagentFrame.backdrop:Point("BOTTOMRIGHT", -34, 74)

	S:HandleNextPrevButton(_G["ATSWDecrementButton"])
	S:HandleNextPrevButton(_G["ATSWIncrementButton"])

	ATSWTradeskillTooltip:SetTemplate("Transparent")

	ATSWScanDelayFrame:Size(400, 151) -- fix pixelperfect

	ATSWFramePortrait:Kill()

	for i = 1, 23 do
		local button = _G["ATSWSkill"..i]

		button:SetNormalTexture("Interface\\Buttons\\UI-PlusMinus-Buttons")
		button.SetNormalTexture = E.noop
		button:GetNormalTexture():Size(11)
		button:GetNormalTexture():Point("LEFT", 3, 1)

		button:GetHighlightTexture():SetAlpha(0)

		button:SetDisabledTexture("Interface\\Buttons\\UI-PlusMinus-Buttons")
		button.SetDisabledTexture = E.noop
		button:GetDisabledTexture():Point("LEFT", 3, 2)
		button:GetDisabledTexture():Size(12)
		button:GetDisabledTexture():SetDesaturated(true)

		hooksecurefunc(button, "SetNormalTexture", function(self, texture)
			if find(texture, "MinusButton") then
				self:GetNormalTexture():SetTexCoord(0.5625, 1, 0, 0.4375)
			elseif find(texture, "PlusButton") then
				self:GetNormalTexture():SetTexCoord(0, 0.4375, 0, 0.4375)
			else
				self:GetNormalTexture():SetTexCoord(0, 0, 0, 0)
			end
		end)
	end

	ATSWExpandButtonFrame:StripTextures()

	ATSWCollapseAllButton:Point("LEFT", ATSWExpandTabLeft, "RIGHT", 0, -18)

	ATSWCollapseAllButton:SetNormalTexture("Interface\\Buttons\\UI-PlusMinus-Buttons")
	ATSWCollapseAllButton.SetNormalTexture = E.noop
	ATSWCollapseAllButton:GetNormalTexture():Size(11)
	ATSWCollapseAllButton:GetNormalTexture():Point("LEFT", 3, 1)
	ATSWCollapseAllButton:GetNormalTexture():SetTexCoord(0.5625, 1, 0, 0.4375)

	ATSWCollapseAllButton:SetHighlightTexture("")
	ATSWCollapseAllButton.SetHighlightTexture = E.noop

	ATSWCollapseAllButton:SetDisabledTexture("Interface\\Buttons\\UI-PlusMinus-Buttons")
	ATSWCollapseAllButton.SetDisabledTexture = E.noop
	ATSWCollapseAllButton:GetDisabledTexture():Point("LEFT", 3, 2)
	ATSWCollapseAllButton:GetDisabledTexture():Size(12)
	ATSWCollapseAllButton:GetDisabledTexture():SetDesaturated(true)

	ATSWCollapseAllButton:HookScript("OnClick", function(self)
		if self.collapsed then
			self:GetNormalTexture():SetTexCoord(0, 0.4375, 0, 0.4375)
		else
			self:GetNormalTexture():SetTexCoord(0.5625, 1, 0, 0.4375)
		end
	end)

	ATSWRankFrameBorder:StripTextures()
	ATSWRankFrameBorder:Hide()

	local function SkinIcon(reagent, icon, count)
		reagent:StripTextures()
		reagent:CreateBackdrop("Transparent", true)
		reagent.backdrop:SetAllPoints()
		reagent:StyleButton(nil, true)
		reagent:Size(reagent:GetWidth(), reagent:GetHeight() + 1)

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetDrawLayer("OVERLAY")
		icon:Size(38)
		icon:Point("TOPLEFT", 2, -2)

		icon.backdrop = CreateFrame("Frame", nil, reagent)
		icon.backdrop:SetFrameLevel(reagent:GetFrameLevel() - 1)
		icon.backdrop:SetTemplate("Default")
		icon.backdrop:SetOutside(icon)

		icon:SetParent(icon.backdrop)
		count:SetParent(icon.backdrop)
		count:SetDrawLayer("OVERLAY")
	end

	for i = 1, ATSW_MAX_TRADE_SKILL_REAGENTS do
		local reagent = _G["ATSWReagent"..i]
		local icon = _G["ATSWReagent"..i.."IconTexture"]
		local count = _G["ATSWReagent"..i.."Count"]

		SkinIcon(reagent, icon, count)
	end

	for i = 1, 17 do
		local buttonDelete = _G["ATSWCSCSkill"..i.."Delete"]
		local buttonUp = _G["ATSWCSCSkill"..i.."MoveUp"]
		local buttonDown = _G["ATSWCSCSkill"..i.."MoveDown"]

		buttonDelete:Size(17)
		buttonUp:Size(24)
		buttonDown:Size(24)

		S:HandleButton(buttonDelete)
		S:HandleNextPrevButton(buttonUp)
		S:HandleNextPrevButton(buttonDown)
	end

	ATSWSkillIcon:StyleButton(nil, true)
	ATSWSkillIcon:SetTemplate()

	ATSWRequirementLabel:SetTextColor(1, 0.80, 0.10)

	hooksecurefunc("ATSWFrame_SetSelection", function(id)
		ATSWRankFrame:SetStatusBarColor(0.13, 0.35, 0.80)

		if ATSWSkillIcon:GetNormalTexture() then
			ATSWSkillIcon:SetAlpha(1)
			ATSWSkillIcon:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
			ATSWSkillIcon:GetNormalTexture():SetInside()
		else
			ATSWSkillIcon:SetAlpha(0)
		end

		local skillLink = GetTradeSkillItemLink(id)
		if skillLink then
			local quality = select(3, GetItemInfo(skillLink))
			if quality and quality > 1 then
				ATSWSkillIcon:SetBackdropBorderColor(GetItemQualityColor(quality))
				ATSWSkillName:SetTextColor(GetItemQualityColor(quality))
			else
				ATSWSkillIcon:SetBackdropBorderColor(unpack(E.media.bordercolor))
				ATSWSkillName:SetTextColor(1, 1, 1)
			end
		end

		local numReagents = GetTradeSkillNumReagents(id)
		for i = 1, numReagents, 1 do
			local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(id, i)
			local reagentLink = GetTradeSkillReagentItemLink(id, i)
			local icon = _G["ATSWReagent"..i.."IconTexture"]
			local name = _G["ATSWReagent"..i.."Name"]

			if reagentLink then
				local quality = select(3, GetItemInfo(reagentLink))
				if quality and quality > 1 then
					icon.backdrop:SetBackdropBorderColor(GetItemQualityColor(quality))
					 if playerReagentCount < reagentCount then
						name:SetTextColor(0.5, 0.5, 0.5)
					else
						name:SetTextColor(GetItemQualityColor(quality))
					end
				else
					icon.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
 				end
			end
		end
	end)

	ATSWReagent1:Point("TOPLEFT", ATSWReagentLabel, "BOTTOMLEFT", -2, -3)
	ATSWReagent2:Point("LEFT", ATSWReagent1, "RIGHT", 3, 0)
	ATSWReagent4:Point("LEFT", ATSWReagent3, "RIGHT", 3, 0)
	ATSWReagent6:Point("LEFT", ATSWReagent5, "RIGHT", 3, 0)
	ATSWReagent8:Point("LEFT", ATSWReagent7, "RIGHT", 3, 0)

	ATSWRankFrame:Size(330, 17)
	ATSWRankFrame:ClearAllPoints()
	ATSWRankFrame:Point("TOPLEFT", ATSWFrame, "TOPRIGHT", -400, -43)

	ATSWRankFrameSkillRank:FontTemplate(nil, 12, "OUTLINE")
	ATSWRankFrameSkillRank:ClearAllPoints()
	ATSWRankFrameSkillRank:Point("CENTER", ATSWRankFrame, "CENTER", 50, 0)

	ATSWRankFrameSkillName:Hide()

	ATSWOnlyCreatableButton:ClearAllPoints()
	ATSWOnlyCreatableButton:Point("TOPLEFT", ATSWFrame, "TOPLEFT", 23, -18)

	ATSWHeaderSortButton:ClearAllPoints()
	ATSWHeaderSortButton:Point("TOPLEFT", ATSWFrame, "TOPLEFT", 23, -35)

	ATSWNameSortButton:ClearAllPoints()
	ATSWNameSortButton:Point("TOP", ATSWHeaderSortButton, "BOTTOM", 0, 6)

	ATSWDifficultySortButton:ClearAllPoints()
	ATSWDifficultySortButton:Point("LEFT", ATSWHeaderSortButton, "RIGHT", 140, 0)

	ATSWCustomSortButton:ClearAllPoints()
	ATSWCustomSortButton:Point("TOP", ATSWDifficultySortButton, "BOTTOM", 0, 6)

	ATSWOptionsButton:Height(20)
	ATSWOptionsButton:ClearAllPoints()
	ATSWOptionsButton:Point("TOPLEFT", ATSWFrame, "TOPRIGHT", -130, -50)

	ATSWCreateButton:ClearAllPoints()
	ATSWCreateButton:Point("CENTER", ATSWFrame, "TOPLEFT", 627, -348)

	ATSWDecrementButton:ClearAllPoints()
	ATSWDecrementButton:Point("LEFT", ATSWCreateAllButton, "RIGHT", 5, 0)

	ATSWInputBox:ClearAllPoints()
	ATSWInputBox:Point("LEFT", ATSWDecrementButton, "RIGHT", 5, 0)

	ATSWIncrementButton:ClearAllPoints()
	ATSWIncrementButton:Point("LEFT", ATSWInputBox, "RIGHT", 5, 0)

	ATSWReagentsButton:ClearAllPoints()
	ATSWReagentsButton:Point("BOTTOMLEFT", ATSWFrame, "BOTTOMRIGHT", -130, 20)

	ATSWQueueDeleteButton:ClearAllPoints()
	ATSWQueueDeleteButton:Point("RIGHT", ATSWReagentsButton, "LEFT", -8, 0)

	ATSWQueueStartStopButton:ClearAllPoints()
	ATSWQueueStartStopButton:Point("RIGHT", ATSWQueueDeleteButton, "LEFT", -8, 0)

	ATSWFilterBox:Point("TOPLEFT", 75, -71)
	ATSWFilterBox:Width(225)

	ATSWFilterLabel:Point("TOPLEFT", 33, -73)

	ATSWInvSlotDropDown:ClearAllPoints()
	ATSWInvSlotDropDown:Point("TOPLEFT", ATSWFrame, "TOPLEFT", 170, -94)
	ATSWInvSlotDropDown:Width(140)

	ATSWSubClassDropDown:ClearAllPoints()
	ATSWSubClassDropDown:Point("RIGHT", ATSWInvSlotDropDown, "LEFT", 24, 0)
	ATSWSubClassDropDown:Width(140)

	ATSWCSNewCategoryBox:ClearAllPoints()
	ATSWCSNewCategoryBox:Point("TOPLEFT", ATSWCSFrame, "TOPLEFT", 398, -471)

	ATSWAddCategoryButton:ClearAllPoints()
	ATSWAddCategoryButton:Point("LEFT", ATSWCSNewCategoryBox, "RIGHT", 3, 0)

	ATSWCSButton:Point("CENTER", ATSWFrame, "TOPLEFT", 402, -75)

	ATSWOptionsButton:Point("TOPLEFT", ATSWFrame, "TOPRIGHT", -158, -65)

	ATSWFrameTitleText:Point("TOP", 130, -20)

	ATSWTradeSkillLinkButton:Point("LEFT", ATSWFrameTitleText, "RIGHT", 5, 1)

	-- ChatLink fix
	ATSWTradeSkillLinkButton:SetScript("OnClick", function()
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		if not ChatFrameEditBox:IsShown() then
			ChatEdit_ActivateChat(ChatFrameEditBox)
		end

		ChatFrameEditBox:Insert(GetTradeSkillListLink())
	end)
end

S:AddCallbackForAddon("AdvancedTradeSkillWindow", "AdvancedTradeSkillWindow", LoadSkin)