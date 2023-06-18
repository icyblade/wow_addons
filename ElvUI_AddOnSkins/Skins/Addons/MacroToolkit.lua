local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.MacroToolkit then return end

	S:HandleButton(MacroToolkitOpen)
	MacroToolkitOpen:Width(83)
	MacroToolkitOpen:Point("LEFT", MacroDeleteButton, "RIGHT", 2, 0)

	MacroNewButton:Point("BOTTOMRIGHT", -87, 4)
end

S:AddCallbackForAddon("MacroToolkit", "MacroToolkit", LoadSkin)