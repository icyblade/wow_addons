local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local pairs = pairs
local find = string.find

local function LoadSkin()
	if not E.private.addOnSkins.Factionizer then return end

	FIZ_ReputationDetailFrame:StripTextures()
	FIZ_ReputationDetailFrame:SetTemplate("Transparent")
	FIZ_ReputationDetailFrame:Point("TOPLEFT", ReputationFrame, "TOPRIGHT", 1, 0)

	S:HandleCloseButton(FIZ_ReputationDetailCloseButton)
	FIZ_ReputationDetailCloseButton:Point("TOPRIGHT", 4, 5)

	FIZ_OptionsFrame:StripTextures()
	FIZ_OptionsFrame:SetTemplate("Transparent")
	FIZ_OptionsFrame:Width(360)
	FIZ_OptionsFrame:Point("TOPLEFT", ReputationFrame, "TOPRIGHT", 1, 0)

	S:HandleCloseButton(FIZ_OptionsFrameClose)
	FIZ_OptionsFrameClose:Point("TOPRIGHT", 4, 5)

	local buttons = {
		FIZ_OptionsButton,
		FIZ_ShowAllButton,
		FIZ_ExpandButton,
		FIZ_ShowNoneButton,
		FIZ_CollapseButton,
		FIZ_SupressNoneFactionButton,
		FIZ_SupressNoneGlobalButton,
		FIZ_ClearSessionGainButton
	}

	for _, button in pairs(buttons) do
		S:HandleButton(button)
	end

	local checkboxes = {
		FIZ_OrderByStandingCheckBox,
		FIZ_EnableMissingBox,
		FIZ_ExtendDetailsBox,
		FIZ_GainToChatBox,
		FIZ_NoGuildGainBox,
		FIZ_SupressOriginalGainBox,
		FIZ_ShowPreviewRepBox,
		FIZ_SwitchFactionBarBox,
		FIZ_SilentSwitchBox,
		FIZ_NoGuildSwitchBox,
		FIZ_ReputationDetailInactiveCheckBox,
		FIZ_ReputationDetailMainScreenCheckBox,
		FIZ_ShowQuestButton,
		FIZ_ShowInstancesButton,
		FIZ_ShowMobsButton,
		FIZ_ShowItemsButton,
		FIZ_ShowGeneralButton,
		FIZ_GuildCapBox,
		FIZ_ReputationDetailAtWarCheckBox,
		-- Interface Options
		FIZ_OptionEnableMissingCB,
		FIZ_OptionExtendDetailsCB,
		FIZ_OptionGainToChatCB,
		FIZ_OptionNoGuildGainCB,
		FIZ_OptionSupressOriginalGainCB,
		FIZ_OptionShowPreviewRepCB,
		FIZ_OptionSwitchFactionBarCB,
		FIZ_OptionSilentSwitchCB,
		FIZ_OptionNoGuildSwitchCB
	}

	for _, checkbox in pairs(checkboxes) do
		S:HandleCheckBox(checkbox)
	end

	FIZ_ShowNoneButton:Point("TOPLEFT", FIZ_ReputationDetailDivider3, "BOTTOMLEFT", 230, -5)
	FIZ_SupressNoneGlobalButton:Point("TOPLEFT", FIZ_SupressNoneFactionButton, "BOTTOMLEFT", 0, -5)
	FIZ_OrderByStandingCheckBox:Point("TOPLEFT", 10, -15)
	FIZ_OptionsButton:Point("TOPRIGHT", -37, -15)

	FIZ_ReputationDetailAtWarCheckBox:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-SwordCheck")

	FIZ_UpdateListScrollFrame:CreateBackdrop("Transparent")
	FIZ_UpdateListScrollFrame.backdrop:Point("BOTTOMRIGHT", 4, -1)
	FIZ_UpdateListScrollFrame:Show()
	FIZ_UpdateListScrollFrame.Hide = E.noop

	S:HandleScrollBar(FIZ_UpdateListScrollFrameScrollBar)
	FIZ_UpdateListScrollFrameScrollBar:ClearAllPoints()
	FIZ_UpdateListScrollFrameScrollBar:Point("TOPRIGHT", FIZ_UpdateListScrollFrame, 28, -17)
	FIZ_UpdateListScrollFrameScrollBar:Point("BOTTOMRIGHT", FIZ_UpdateListScrollFrame, 0, 17)

	for i = 1, 13 do
		S:HandleButtonHighlight(_G["FIZ_UpdateEntry"..i], true, 1, 0.8, 0.2)

		local texture = _G["FIZ_UpdateEntry"..i.."Texture"]
		texture:SetTexture(E.Media.Textures.Plus)
		texture:Size(14)

		hooksecurefunc(texture, "SetTexture", function(self, texture)
			if find(texture, "MinusButton") then
				self:SetTexture(E.Media.Textures.Minus)
			elseif find(texture, "PlusButton") then
				self:SetTexture(E.Media.Textures.Plus)
 			end
		end)
	end
end

S:AddCallbackForAddon("Factionizer", "Factionizer", LoadSkin)