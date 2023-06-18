local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.BugSack then return end

	hooksecurefunc(BugSack, "OpenSack", function()
		if BugSackFrame.isSkinned then return end

		BugSackFrame:StripTextures()
		BugSackFrame:SetTemplate("Transparent")

		BugSackScroll:CreateBackdrop()
		BugSackScroll.backdrop:Point("TOPLEFT", -3, 3)
		BugSackScroll.backdrop:Point("BOTTOMRIGHT", 3, -3)

		local scrollBar = BugSackScrollScrollBar and BugSackScrollScrollBar or BugSackFrameScrollScrollBar
		S:HandleScrollBar(scrollBar)
		scrollBar:ClearAllPoints()
		scrollBar:Point("TOPRIGHT", BugSackScroll, 23, -15)
		scrollBar:Point("BOTTOMRIGHT", BugSackScroll, 0, 15)

		S:HandleButton(BugSackPrevButton)
		BugSackPrevButton:Point("BOTTOMLEFT", 13, 6)

		S:HandleButton(BugSackNextButton)
		BugSackNextButton:Point("BOTTOMRIGHT", -8, 6)

		if BugSack.Serialize then
			S:HandleButton(BugSackSendButton)
			BugSackSendButton:Point("LEFT", BugSackPrevButton, "RIGHT", E.PixelMode and 2 or 4, 0)
			BugSackSendButton:Point("RIGHT", BugSackNextButton, "LEFT", -(E.PixelMode and 2 or 4), 0)
		end

		S:HandleTab(BugSackTabAll)
		BugSackTabAll:Point("TOPLEFT", BugSackFrame, "BOTTOMLEFT", 0, 2)

		S:HandleTab(BugSackTabSession)
		S:HandleTab(BugSackTabLast)

		for _, child in pairs({BugSackFrame:GetChildren()}) do
			if child:IsObjectType("Button") and child:GetScript("OnClick") == BugSack.CloseSack then
				S:HandleCloseButton(child)
			end
		end

		BugSackFrame.isSkinned = true
	end)
end

S:AddCallbackForAddon("BugSack", "BugSack", LoadSkin)