local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G

local function LoadSkin()
	if not E.private.addOnSkins.Postal then return end

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local mail = _G["MailItem"..i]
		local expire = _G["MailItem"..i.."ExpireTime"]
		local inboxCB = _G["PostalInboxCB"..i]

		if expire then
			expire:Point("TOPRIGHT", mail, "TOPRIGHT", -5, -10)

			if expire.returnicon then
				expire.returnicon:StripTextures(true)
				S:HandleCloseButton(expire.returnicon)
				expire.returnicon:Point("TOPRIGHT", expire, "TOPRIGHT", 34, 2)
				expire.returnicon:Size(26)
				expire.returnicon.Texture:SetVertexColor(1, 0, 0)

				expire.returnicon:HookScript("OnEnter", function(btn) btn.Texture:SetVertexColor(1, 1, 1) end)
				expire.returnicon:HookScript("OnLeave", function(btn) btn.Texture:SetVertexColor(1, 0, 0) end)
			end
		end

		if inboxCB then
			S:HandleCheckBox(inboxCB)
			inboxCB:Point("RIGHT", mail, "LEFT", -3, 0)
		end
	end

	if PostalSelectOpenButton then
		S:HandleButton(PostalSelectOpenButton, true)
		PostalSelectOpenButton:ClearAllPoints()
		PostalSelectOpenButton:Point("TOPLEFT", InboxFrame, "TOPLEFT", 30, -38)
	end

	if PostalSelectReturnButton then
		S:HandleButton(PostalSelectReturnButton, true)
		PostalSelectReturnButton:ClearAllPoints()
		PostalSelectReturnButton:Point("LEFT", PostalSelectOpenButton, "RIGHT", 43, 0)
	end

	if Postal_OpenAllMenuButton then
		S:HandleNextPrevButton(Postal_OpenAllMenuButton)
		Postal_OpenAllMenuButton:ClearAllPoints()
		Postal_OpenAllMenuButton:Point("LEFT", PostalOpenAllButton, "RIGHT", 2, 0)
		Postal_OpenAllMenuButton:Size(25)
	end

	if PostalOpenAllButton then
		S:HandleButton(PostalOpenAllButton, true)
		PostalOpenAllButton:Point("CENTER", InboxFrame, "TOP", -36, -400)
	end

	if Postal_ModuleMenuButton then
		S:HandleNextPrevButton(Postal_ModuleMenuButton, nil, nil, true)
		Postal_ModuleMenuButton:Point("TOPRIGHT", MailFrame, -24, 3)
		Postal_ModuleMenuButton:Size(26)
	end

	if Postal_BlackBookButton then
		S:HandleNextPrevButton(Postal_BlackBookButton)
		Postal_BlackBookButton:ClearAllPoints()
		Postal_BlackBookButton:Point("LEFT", SendMailNameEditBox, "RIGHT", 2, 0)
		Postal_BlackBookButton:Size(20)
	end

	hooksecurefunc(Postal, "CreateAboutFrame", function()
		if PostalAboutFrame then
			PostalAboutFrame:StripTextures()
			PostalAboutFrame:SetTemplate("Transparent")

			if PostalAboutScroll then
				S:HandleScrollBar(PostalAboutScrollScrollBar)
			end

			local closeButton = select(2, PostalAboutFrame:GetChildren())
			if closeButton then
				S:HandleCloseButton(closeButton)
			end
		end
	end)
end

S:AddCallbackForAddon("Postal", "Postal", LoadSkin)