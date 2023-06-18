local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.FlightMap then return end

	FlightMapTimesFrame:StripTextures()
	FlightMapTimesFrame:CreateBackdrop("Transparent")

	FlightMapTimesFrame:SetStatusBarTexture(E.media.normTex)
	E:RegisterStatusBar(FlightMapTimesFrame)

	FlightMapTimesText:ClearAllPoints()
	FlightMapTimesText:Point("CENTER", FlightMapTimesFrame)

	local base = "InterfaceOptionsFlightMapPanel"
	for optid, option in pairs(FLIGHTMAP_OPTIONS) do
		S:HandleCheckBox(_G[base.."Option"..optid])
	end
end

S:AddCallbackForAddon("FlightMap", "FlightMap", LoadSkin)