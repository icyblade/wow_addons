local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local pairs = pairs

local function LoadSkin()
	if not E.private.addOnSkins.EasyMail then return end

	EasyMail_CheckAllButton:StripTextures()
	EasyMail_CheckAllButton:Size(24)
	EasyMail_CheckAllButton:SetNormalTexture(E.Media.Textures.Copy)
	EasyMail_CheckAllButton:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
	EasyMail_CheckAllButton:GetNormalTexture():SetInside()
	EasyMail_CheckAllButton:SetPushedTexture(E.Media.Textures.Copy)
	EasyMail_CheckAllButton:GetPushedTexture():SetTexCoord(0, 1, 0, 1)

	EasyMail_CheckPageButton:StripTextures()
	EasyMail_CheckPageButton:Size(24)
	EasyMail_CheckPageButton:SetNormalTexture(E.Media.Textures.Copy)
	EasyMail_CheckPageButton:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
	EasyMail_CheckPageButton:GetNormalTexture():SetInside()
	EasyMail_CheckPageButton:SetPushedTexture(E.Media.Textures.Copy)
	EasyMail_CheckPageButton:GetPushedTexture():SetTexCoord(0, 1, 0, 1)

	for _, button in pairs({EasyMail_ClearAllButton, EasyMail_ClearPageButton}) do
		button:StripTextures()
		button:Size(24)

		local normal = button:GetNormalTexture()
		normal:SetTexture(E.Media.Textures.Close)
		normal:SetTexCoord(0, 1, 0, 1)
		normal:SetVertexColor(1, 0, 0)
		normal:Point("TOPLEFT", 4, -4)
		normal:Point("BOTTOMRIGHT", -4, 4)

		local pushed = button:GetPushedTexture()
		pushed:SetTexture(E.Media.Textures.Close)
		pushed:SetTexCoord(0, 1, 0, 1)
		pushed:Point("TOPLEFT", 3, -3)
		pushed:Point("BOTTOMRIGHT", -3, 3)
	end

	S:HandleButton(EasyMail_GetAllButton)
	EasyMail_GetAllButton:Size(46, 26)
	EasyMail_GetAllButton.arrow = EasyMail_GetAllButton:CreateTexture(nil, "ARTWORK")
	EasyMail_GetAllButton.arrow:SetTexture(E.Media.Textures.ArrowUp)
	EasyMail_GetAllButton.arrow:Size(24)
	EasyMail_GetAllButton.arrow:Point("LEFT", EasyMail_GetAllButton, -2, 0)
	EasyMail_GetAllButton.arrow:SetRotation(-1.57)
	EasyMail_GetAllButton.texture = EasyMail_GetAllButton:CreateTexture(nil, "ARTWORK")
	EasyMail_GetAllButton.texture:SetTexture("Interface\\Buttons\\Button-Backpack-Up")
	EasyMail_GetAllButton.texture:SetTexCoord(unpack(E.TexCoords))
	EasyMail_GetAllButton.texture:SetDesaturated(true)
	EasyMail_GetAllButton.texture:Size(24)
	EasyMail_GetAllButton.texture:Point("RIGHT", EasyMail_GetAllButton, -2, 0)

	EasyMail_GetAllButton:HookScript("OnEnable", function(btn)
		btn.arrow:SetVertexColor(1, 0.8, 0.1)
		btn.texture:SetDesaturated(false)
	end)

	EasyMail_GetAllButton:HookScript("OnDisable", function(btn)
		btn.arrow:SetVertexColor(1, 1, 1)
		btn.texture:SetDesaturated(true)
	end)

	EasyMail_CheckAllButton:Point("TOPLEFT", InboxFrame, 36, -36)
	EasyMail_ClearAllButton:Point("TOPLEFT", EasyMail_CheckAllButton, "TOPRIGHT", 2, 0)
	EasyMail_CheckPageButton:Point("TOPLEFT", EasyMail_ClearAllButton, "TOPRIGHT", 60, 0)
	EasyMail_ClearPageButton:Point("TOPLEFT", EasyMail_CheckPageButton, "TOPRIGHT", 2, 0)
	EasyMail_GetAllButton:Point("TOPLEFT", EasyMail_ClearPageButton, "TOPRIGHT", 60, 0)

	for i = 1, 7 do
		local checkBox = _G["EasyMail_CheckButton"..i]

		S:HandleCheckBox(checkBox)
		checkBox:Size(26)
		checkBox:Point("TOPLEFT", -28, -7)
	end

	S:HandleNextPrevButton(EasyMail_MailButton, "down")
	EasyMail_MailButton:Point("TOPLEFT", SendMailNameEditBox, "TOPRIGHT", 4, 1)
	EasyMail_MailButton:Size(20)

	EasyMail_MailDropdownBackdrop:StripTextures()
	EasyMail_MailDropdownBackdrop:SetTemplate("Transparent")

	OpenMailCancelButton:Point("BOTTOMRIGHT", -3, 3)

	S:HandleButton(EasyMail_AttButton)

	S:HandleButton(EasyMail_ForwardButton)
	EasyMail_ForwardButton:Point("RIGHT", OpenMailReplyButton, "LEFT", -2, 0)

	-- Options
	S:HandleCheckBox(EasyMail_OptionsPanelAutoAdd)
	S:HandleCheckBox(EasyMail_OptionsPanelFriends)
	S:HandleCheckBox(EasyMail_OptionsPanelGuild)
	S:HandleCheckBox(EasyMail_OptionsPanelBlizzList)
	S:HandleCheckBox(EasyMail_OptionsPanelClickGet)
	S:HandleCheckBox(EasyMail_OptionsPanelClickDel)
	S:HandleCheckBox(EasyMail_OptionsPanelDelPrompt)
	S:HandleCheckBox(EasyMail_OptionsPanelTextTooltip)
	S:HandleCheckBox(EasyMail_OptionsPanelDelPending)
	S:HandleCheckBox(EasyMail_OptionsPanelMoney)
	S:HandleCheckBox(EasyMail_OptionsPanelTotal)

	S:HandleButton(EasyMail_OptionsPanelClear)

	S:HandleEditBox(EasyMail_OptionsPanelListLen)
end

S:AddCallbackForAddon("EasyMail", "EasyMail", LoadSkin)