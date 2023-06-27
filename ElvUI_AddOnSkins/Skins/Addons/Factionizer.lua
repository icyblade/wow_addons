local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local pairs = pairs
local find = string.find

-- Factionazier v4.3.0.1

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
		FIZ_ReputationDetailAtWarCheckBox
	}

	for _, checkbox in pairs(checkboxes) do
		S:HandleCheckBox(checkbox)
	end

	FIZ_ShowNoneButton:Point("TOPLEFT", FIZ_ReputationDetailDivider3, "BOTTOMLEFT", 230, -5)
	FIZ_SupressNoneGlobalButton:Point("TOPLEFT", FIZ_SupressNoneFactionButton, "BOTTOMLEFT", 0, -5)
	FIZ_OrderByStandingCheckBox:Point("TOPLEFT", 10, -15)
	FIZ_OptionsButton:Point("TOPRIGHT", -37, -15)

	FIZ_ReputationDetailAtWarCheckBox:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-SwordCheck")

	S:HandleScrollBar(FIZ_UpdateListScrollFrameScrollBar, 5)
	S:HandleSliderFrame(FIZ_ChatFrameSlider)

	for i = 1, 13 do
		local entryTex = _G["FIZ_UpdateEntry"..i.."Texture"]

		entryTex:SetTexture(E.Media.Textures.Plus)
		entryTex:Size(14)

		hooksecurefunc(entryTex, "SetTexture", function(self, texture)
			if find(texture, "MinusButton") then
				self:SetTexture(E.Media.Textures.Minus)
			elseif find(texture, "PlusButton") then
				self:SetTexture(E.Media.Textures.Plus)
 			end
		end)
	end

	-- Interface Options
	S:HandleCheckBox(FIZ_OptionEnableMissingCB)
	S:HandleCheckBox(FIZ_OptionExtendDetailsCB)
	S:HandleCheckBox(FIZ_OptionGainToChatCB)
	S:HandleCheckBox(FIZ_OptionNoGuildGainCB)
	S:HandleCheckBox(FIZ_OptionSupressOriginalGainCB)
	S:HandleCheckBox(FIZ_OptionShowPreviewRepCB)
	S:HandleCheckBox(FIZ_OptionSwitchFactionBarCB)
	S:HandleCheckBox(FIZ_OptionSilentSwitchCB)
	S:HandleCheckBox(FIZ_OptionNoGuildSwitchCB)
	S:HandleCheckBox(FIZ_OptionGuildCapCB)

	S:HandleSliderFrame(FIZ_OptionChatFrameSlider)
end

S:AddCallbackForAddon("Factionizer", "Factionizer", LoadSkin)