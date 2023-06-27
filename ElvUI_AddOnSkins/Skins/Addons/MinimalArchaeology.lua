local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack

local function LoadSkin()
	if not E.private.addOnSkins.MinimalArchaeology then return end

	MinArchMain:StripTextures()
	MinArchMain:SetTemplate("Transparent")

	MinArchMainButtonClose:GetNormalTexture():SetTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Up")
	MinArchMainButtonClose:GetPushedTexture():SetTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Down")
	MinArchMainButtonClose:GetHighlightTexture():SetTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Highlight")
	S:HandleCloseButton(MinArchMainButtonClose)
	MinArchMainButtonClose:Size(32)
	MinArchMainButtonClose:Point("TOPRIGHT", 2, 4)

	S:HandleButton(MinArchMainButtonOpenADI)
	MinArchMainButtonOpenADI:Size(18)
	MinArchMainButtonOpenADI:Point("TOPRIGHT", -216, -3)
	MinArchMainButtonOpenADI.texture = MinArchMainButtonOpenADI:CreateTexture(nil, "OVERLAY")
	MinArchMainButtonOpenADI.texture:SetTexture("INTERFACE\\ICONS\\INV_Misc_Map02")
	MinArchMainButtonOpenADI.texture:SetInside()
	MinArchMainButtonOpenADI.texture:SetTexCoord(unpack(E.TexCoords))

	S:HandleButton(MinArchMainButtonOpenHist)
	MinArchMainButtonOpenHist:Size(18)
	MinArchMainButtonOpenHist:Point("TOPRIGHT", -237, -3)
	MinArchMainButtonOpenHist.texture = MinArchMainButtonOpenHist:CreateTexture(nil, "OVERLAY")
	MinArchMainButtonOpenHist.texture:SetTexture("INTERFACE\\ICONS\\INV_ZulGurubTrinket")
	MinArchMainButtonOpenHist.texture:SetInside()
	MinArchMainButtonOpenHist.texture:SetTexCoord(unpack(E.TexCoords))

	S:HandleButton(MinArchMainButtonOpenArch)
	MinArchMainButtonOpenArch:Size(18)
	MinArchMainButtonOpenArch:Point("TOPRIGHT", -258, -3)
	MinArchMainButtonOpenArch.texture = MinArchMainButtonOpenArch:CreateTexture(nil, "OVERLAY")
	MinArchMainButtonOpenArch.texture:SetTexture("INTERFACE\\ICONS\\trade_archaeology")
	MinArchMainButtonOpenArch.texture:SetInside()
	MinArchMainButtonOpenArch.texture:SetTexCoord(unpack(E.TexCoords))

	MinArchMainSkillBar:StripTextures()
	MinArchMainSkillBar:CreateBackdrop()
	MinArchMainSkillBar:SetStatusBarTexture(E.media.normTex)
	MinArchMainSkillBar:SetStatusBarColor(0.13, 0.35, 0.80)
	MinArchMainSkillBar:Point("TOP", 2, -24)
	MinArchMainSkillBar:Width(253)

	for i = 1, 10 do
		local bar = _G["MinArchMainArtifactBar"..i]
		local button = _G["MinArchMainArtifactBar"..i.."ButtonSolve"]

		bar:StripTextures()
		bar:CreateBackdrop()
		bar:SetStatusBarTexture(E.media.normTex)
		bar:SetStatusBarColor(1.0, 0.4, 0)

		S:HandleButton(button)
		button:Height(17)
		button:Point("TOPLEFT", bar, "TOPRIGHT", 5, 2)

		S:HandleCheckBox(_G["MinArchOptionPanelHideArtifact"..i])
		S:HandleCheckBox(_G["MinArchOptionPanelFragmentCap"..i])

		if _G["MinArchOptionPanelUseKeystones"..i] then 
			S:HandleCheckBox(_G["MinArchOptionPanelUseKeystones"..i])
		end
	end

	MinArchDigsites:StripTextures()
	MinArchDigsites:SetTemplate("Transparent")

	MinArchDigsitesButtonClose:GetNormalTexture():SetTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Up")
	MinArchDigsitesButtonClose:GetPushedTexture():SetTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Down")
	MinArchDigsitesButtonClose:GetHighlightTexture():SetTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Highlight")
	S:HandleCloseButton(MinArchDigsitesButtonClose)
	MinArchDigsitesButtonClose:Size(32)
	MinArchDigsitesButtonClose:Point("TOPRIGHT", 2, 4)

	MinArchDigsitesKalimdorButton:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	MinArchDigsitesKalimdorButton:GetPushedTexture():SetTexCoord(unpack(E.TexCoords))
	MinArchDigsitesKalimdorButton:GetHighlightTexture():SetTexCoord(unpack(E.TexCoords))

	MinArchDigsitesEasternButton:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	MinArchDigsitesEasternButton:GetPushedTexture():SetTexCoord(unpack(E.TexCoords))
	MinArchDigsitesEasternButton:GetHighlightTexture():SetTexCoord(unpack(E.TexCoords))

	MinArchDigsitesOutlandsButton:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	MinArchDigsitesOutlandsButton:GetPushedTexture():SetTexCoord(unpack(E.TexCoords))
	MinArchDigsitesOutlandsButton:GetHighlightTexture():SetTexCoord(unpack(E.TexCoords))

	MinArchDigsitesNorthrendButton:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	MinArchDigsitesNorthrendButton:GetPushedTexture():SetTexCoord(unpack(E.TexCoords))
	MinArchDigsitesNorthrendButton:GetHighlightTexture():SetTexCoord(unpack(E.TexCoords))

	MinArchHist:StripTextures()
	MinArchHist:SetTemplate("Transparent")

	MinArchHistButtonClose:GetNormalTexture():SetTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Up")
	MinArchHistButtonClose:GetPushedTexture():SetTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Down")
	MinArchHistButtonClose:GetHighlightTexture():SetTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Highlight")
	S:HandleCloseButton(MinArchHistButtonClose)
	MinArchHistButtonClose:Size(32)
	MinArchHistButtonClose:Point("TOPRIGHT", 2, 4)

	MinArchTooltipIcon.icon:SetTexCoord(unpack(E.TexCoords))

	hooksecurefunc(MinArch, "CreateHistoryList", function()
		MinArchScrollFrame:StripTextures()
		S:HandleSliderFrame(MinArchScrollBar)
	end)

	hooksecurefunc(MinArch, "CreateDigSitesList", function()
		MinArchDSScrollFrame:StripTextures()
		S:HandleSliderFrame(MinArchScrollDSBar)
	end)

	-- Interface Options
	MinArchOptionPanelHideArtifact:StripTextures()
	MinArchOptionPanelHideArtifact:SetTemplate("Transparent")

	MinArchOptionPanelFragmentCap:StripTextures()
	MinArchOptionPanelFragmentCap:SetTemplate("Transparent")

	MinArchOptionPanelUseKeystones:StripTextures()
	MinArchOptionPanelUseKeystones:SetTemplate("Transparent")

	MinArchOptionPanelMiscOptions:StripTextures()
	MinArchOptionPanelMiscOptions:SetTemplate("Transparent")

	MinArchOptionPanelFrameScale:StripTextures()
	MinArchOptionPanelFrameScale:SetTemplate("Transparent")

	local checkbox = {
		MinArchOptionPanelMiscOptionsHideMinimap,
		MinArchOptionPanelMiscOptionsDisableSound,
		MinArchOptionPanelMiscOptionsStartHidden,
		MinArchOptionPanelMiscOptionsHideAfter,
		MinArchOptionPanelMiscOptionsWaitForSolve
	}

	for _, boxes in pairs(checkbox) do
		S:HandleCheckBox(boxes)
	end

	S:HandleSliderFrame(MinArchOptionPanelFrameScaleSlider)
end

S:AddCallbackForAddon("MinimalArchaeology", "MinimalArchaeology", LoadSkin)