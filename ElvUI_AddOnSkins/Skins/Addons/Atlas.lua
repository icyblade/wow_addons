local E, L, V, P, G = unpack(ElvUI)
local AS = E:GetModule("AddOnSkins")
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.Atlas then return end

	AtlasFrame:StripTextures()
	AtlasFrame:SetTemplate("Transparent")

	AtlasMap:SetDrawLayer("BORDER")

	AtlasFrameCloseButton:Point("TOPRIGHT", AtlasFrame, "TOPRIGHT", -5, -7)
	AtlasFrameLockButton:Point("RIGHT", AtlasFrameCloseButton, "LEFT", 12, 0)
	S:HandleCloseButton(AtlasFrameCloseButton)

	AS:Desaturate(AtlasFrameLockButton)

	S:HandleButton(Atlas_JournalEncounter_InstanceButton)
	Atlas_JournalEncounter_InstanceButton.icon = Atlas_JournalEncounter_InstanceButton:CreateTexture(nil, "OVERLAY")
	Atlas_JournalEncounter_InstanceButton.icon:SetTexCoord(unpack(E.TexCoords))
	Atlas_JournalEncounter_InstanceButton.icon:SetTexture("Interface\\AddOns\\Atlas\\Images\\UI-EJ-PortraitIcon")
	Atlas_JournalEncounter_InstanceButton.icon:SetAllPoints()

	S:HandleDropDownBox(AtlasFrameDropDownType)
	S:HandleDropDownBox(AtlasFrameDropDown)

	S:HandleEditBox(AtlasSearchEditBox)
	AtlasSearchEditBox:Height(22)

	S:HandleButton(AtlasSwitchButton)
	AtlasSwitchButton:Height(24)
	S:HandleButton(AtlasSearchButton)
	AtlasSearchButton:Height(24)
	AtlasSearchButton:Point("LEFT", AtlasSearchEditBox, "RIGHT", 3, 0)
	S:HandleButton(AtlasSearchClearButton)
	AtlasSearchClearButton:Height(24)
	AtlasSearchClearButton:Point("LEFT", AtlasSearchButton, "RIGHT", 2, 0)
	S:HandleButton(AtlasFrameOptionsButton)

	S:HandleScrollBar(AtlasScrollBarScrollBar)

	S:HandleCheckBox(AtlasOptionsFrameToggleButton)
	S:HandleCheckBox(AtlasOptionsFrameAutoSelect)
	S:HandleCheckBox(AtlasOptionsFrameRightClick)
	S:HandleCheckBox(AtlasOptionsFrameAcronyms)
	S:HandleCheckBox(AtlasOptionsFrameClamped)
	S:HandleCheckBox(AtlasOptionsFrameCtrl)
	S:HandleCheckBox(AtlasOptionsFrameLock)
	S:HandleCheckBox(AtlasOptionsFrameBossDesc)

	S:HandleSliderFrame(AtlasOptionsFrameSliderButtonPos)
	S:HandleSliderFrame(AtlasOptionsFrameSliderButtonRad)
	S:HandleSliderFrame(AtlasOptionsFrameSliderAlpha)
	S:HandleSliderFrame(AtlasOptionsFrameSliderScale)
	S:HandleSliderFrame(AtlasOptionsFrameSliderBossDescScale)

	S:HandleDropDownBox(AtlasOptionsFrameDropDownCats)

	S:HandleButton(AtlasOptionsFrameResetPosition)
end

S:AddCallbackForAddon("Atlas", "Atlas", LoadSkin)