local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if(not E.private.addOnSkins.ACP) then return end

	local function cbResize()
		for i = 1, 20, 1 do
			local checkbox = _G["ACP_AddonListEntry"..i.."Enabled"]
			local collapse = _G["ACP_AddonListEntry"..i.."Collapse"]

			checkbox:Point("LEFT", 5, 0)
			checkbox:Size(26)

			if not collapse:IsShown() then
				checkbox:Point("LEFT", 15, 0)
				checkbox:Size(20)
			end
		end
	end
	hooksecurefunc(ACP, "AddonList_OnShow_Fast", cbResize)

	ACP_AddonList:StripTextures()
	ACP_AddonList:SetTemplate("Transparent")
	ACP_AddonList:Height(502)
	ACP_AddonList:SetScale(UIParent:GetScale())

	ACP_AddonList_ScrollFrame:StripTextures()
	ACP_AddonList_ScrollFrame:CreateBackdrop("Default")
	ACP_AddonList_ScrollFrame:Size(590, 412)
	ACP_AddonList_ScrollFrame:Point("TOPLEFT", 20, -53)

	S:HandleButton(ACP_AddonListDisableAll)
	ACP_AddonListDisableAll:Point("BOTTOMLEFT", 90, 8)

	S:HandleButton(ACP_AddonListEnableAll)
	ACP_AddonListEnableAll:Point("BOTTOMLEFT", 175, 8)

	S:HandleButton(ACP_AddonList_ReloadUI)
	ACP_AddonList_ReloadUI:Point("BOTTOMRIGHT", -160, 8)

	S:HandleButton(ACP_AddonListSetButton)
	ACP_AddonListSetButton:Point("BOTTOMLEFT", 20, 8)

	S:HandleButton(ACP_AddonListBottomClose)
	ACP_AddonListBottomClose:Point("BOTTOMRIGHT", -50, 8)

	S:HandleCloseButton(ACP_AddonListCloseButton)
	ACP_AddonListCloseButton:Point("TOPRIGHT", 4, 5)

	ACP_AddonListEntry1:Point("TOPLEFT", 47, -62)

	S:HandleButton(GameMenuButtonAddOns)
	S:HandleScrollBar(ACP_AddonList_ScrollFrameScrollBar)
	S:HandleCheckBox(ACP_AddonList_NoRecurse)
	S:HandleDropDownBox(ACP_AddonListSortDropDown, 130)

	for i = 1, 20 do
		S:HandleButton(_G["ACP_AddonListEntry"..i.."LoadNow"])
		S:HandleCheckBox(_G["ACP_AddonListEntry"..i.."Enabled"])
	end
end

S:AddCallbackForAddon("ACP", "ACP", LoadSkin)