local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.Omen then return end

	OmenTitle:SetTemplate("Default", true)
	OmenBarList:SetTemplate("Default")
end

S:AddCallbackForAddon("Omen", "Omen", LoadSkin)