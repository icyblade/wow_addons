local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.SilverDragon then return end

	local silverDragon = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
	if not silverDragon then return end

	local frame = silverDragon:GetModule("ClickTarget")
	if frame then
		frame.popup:SetParent(UIParent)

		frame.popup:SetNormalTexture(nil)
		frame.popup:SetTemplate("Transparent")

		frame.popup.close:ClearAllPoints()
		S:HandleCloseButton(frame.popup.close, frame.popup)

		frame.popup:HookScript("OnEnter", S.SetModifiedBackdrop)
		frame.popup:HookScript("OnLeave", S.SetOriginalBackdrop)

		frame.popup.details:SetTextColor(1, 1, 1)
		frame.popup.subtitle:SetTextColor(0.5, 0.5, 0.5)
	end
end

S:AddCallbackForAddon("SilverDragon", "SilverDragon", LoadSkin)