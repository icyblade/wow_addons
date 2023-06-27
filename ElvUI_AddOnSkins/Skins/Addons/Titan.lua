local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack

local function LoadSkin()
	if not E.private.addOnSkins.Titan then return end

	E:Delay(1, function()
		Titan_Bar__Display_Bar:StripTextures()
		Titan_Bar__Display_Bar:SetTemplate("Transparent", true)

		Titan_Bar__Display_Bar2:StripTextures()
		Titan_Bar__Display_Bar2:SetTemplate("Transparent", true)

		Titan_Bar__Display_AuxBar:StripTextures()
		Titan_Bar__Display_AuxBar:SetTemplate("Transparent", true)

		Titan_Bar__Display_AuxBar2:StripTextures()
		Titan_Bar__Display_AuxBar2:SetTemplate("Transparent", true)

		local Icons = {
			"TitanPanelGoldButtonIcon",
			"TitanPanelDefenseButtonIcon",
			"TitanPanelBroker_PortalsButtonIcon",
			"TitanPanelMNButtonIcon",
			"TitanPanelCOButtonIcon",
			"TitanPanelALButtonIcon",
			"TitanPanelHPButtonIcon",
			"TitanPanelSKButtonIcon",
			"TitanPanelFAButtonIcon",
			"TitanPanelAYButtonIcon",
			"TitanPanelAYButtonIcon",
			"TitanPanelBSButtonIcon",
			"TitanPanelENButtonIcon",
			"TitanPanelEGButtonIcon",
			"TitanPanelJCButtonIcon",
			"TitanPanelLWButtonIcon",
			"TitanPanelTLButtonIcon",
			"TitanPanelFHButtonIcon",
			"TitanPanelSPButtonIcon"
		}

		for i = 1, #Icons do
			if _G[Icons[i]] then
				_G[Icons[i]]:SetTexCoord(unpack(E.TexCoords))
			end
		end

		for i = 0, 9 do
			if _G["TitanPanelA"..i.."ButtonIcon"] then
				_G["TitanPanelA"..i.."ButtonIcon"]:SetTexCoord(unpack(E.TexCoords))
			end
		end
	end)
end

S:AddCallbackForAddon("Titan", "Titan", LoadSkin)