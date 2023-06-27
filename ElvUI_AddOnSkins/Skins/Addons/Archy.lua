local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local pairs, unpack = pairs, unpack

local function LoadSkin()
	if not E.private.addOnSkins.Archy then return end

	for _, object in pairs({ArchyArtifactFrame, ArchyDigSiteFrame}) do
		object:SetTemplate("Transparent")
		object.SetBackdrop = E.noop
		object.SetBackdropColor = E.noop
		object.SetBackdropBorderColor = E.noop
	end

	if ArchyDistanceIndicatorFrame then
		S:HandleButton(ArchyDistanceIndicatorFrameSurveyButton)
	end

	if ArchyArtifactFrameSkillBar then
		ArchyArtifactFrameSkillBar:StripTextures()
		ArchyArtifactFrameSkillBar:CreateBackdrop()
		ArchyArtifactFrameSkillBar:SetStatusBarTexture(E.media.normTex)
		ArchyArtifactFrameSkillBar.text:SetTextColor(1, 1, 1)
		ArchyArtifactFrameSkillBar.text.SetTextColor = E.noop
		ArchyArtifactFrameSkillBar.text:FontTemplate(nil, 14, "OUTLINE")
	end

	if Archy.db.profile.general.theme ~= "Minimal" then
		hooksecurefunc(Archy, "RefreshRacesDisplay", function()
			for _, child in pairs(ArchyArtifactFrame.children) do
				if child then
					local icon = child.icon
					local fragmentBar = child.fragmentBar
					local solveButton = child.solveButton

					fragmentBar:StripTextures()
					fragmentBar:CreateBackdrop("Transparent", true)
					fragmentBar:SetStatusBarTexture(E.media.normTex)
					fragmentBar.isSkinned = true

					if not solveButton.isSkinned then
						S:HandleButton(solveButton)
						solveButton:StyleButton()
						solveButton.isSkinned = true
					end

					if not icon.isSkinned then
						icon:CreateBackdrop()
						icon.texture:SetTexCoord(unpack(E.TexCoords))
						icon.texture:SetAllPoints()

						icon.isSkinned = true
					end

					if solveButton:GetNormalTexture() then
						solveButton:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
						solveButton:GetDisabledTexture():SetTexCoord(unpack(E.TexCoords))
					end

					icon:Size(solveButton:GetHeight(),solveButton:GetHeight())

					fragmentBar:Point("TOPLEFT", icon, "TOPRIGHT", 7, -2)
				end
			end
		end)
	end

	Archy:RefreshRacesDisplay()
end

S:AddCallbackForAddon("Archy", "Archy", LoadSkin)