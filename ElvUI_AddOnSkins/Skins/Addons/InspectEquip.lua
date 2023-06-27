local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.InspectEquip then return end

	InspectEquip_InfoWindow:SetTemplate("Transparent")

	S:HandleCloseButton(InspectEquip_InfoWindow_CloseButton)

	S:SecureHook(InspectEquip, "SetParent", function(_, frame)
		InspectEquip_InfoWindow:ClearAllPoints()
		InspectEquip_InfoWindow:Point("TOPLEFT", _G[frame:GetName().."CloseButton"], "TOPRIGHT", -1, -5)
	end)

	GearManagerDialogPopup:HookScript("OnShow", function()
		InspectEquip_InfoWindow:Hide()
	end)

	GearManagerDialogPopup:HookScript("OnHide", function(self)
		if not self:IsShown() then
			InspectEquip_InfoWindow:Show()
		end
	end)
end

S:AddCallbackForAddon("InspectEquip", "InspectEquip", LoadSkin)