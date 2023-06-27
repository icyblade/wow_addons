local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.BugSack then return end

	hooksecurefunc(BugSack, "OpenSack", function()
		if BugSackFrame.isSkinned then return end

		BugSackFrame:StripTextures()
		BugSackFrame:SetTemplate("Transparent")

		BugSackScroll:SetTemplate("Default")

		S:HandleButton(BugSackNextButton)
		S:HandleButton(BugSackPrevButton)

		if BugSack.Serialize then
			S:HandleButton(BugSackSendButton)
			BugSackSendButton:SetPoint("LEFT", BugSackPrevButton, "RIGHT", E.PixelMode and 1 or 3, 0)
			BugSackSendButton:SetPoint("RIGHT", BugSackNextButton, "LEFT", -(E.PixelMode and 1 or 3), 0)
		end

		local scrollBar = BugSackScrollScrollBar and BugSackScrollScrollBar or BugSackFrameScrollScrollBar
		S:HandleScrollBar(scrollBar)

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