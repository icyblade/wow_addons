local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G

local function LoadSkin()
	if not E.private.addOnSkins.VanasKoS then return end

	VanasKoS_WarnFrame:SetTemplate("Transparent", nil, true)
	VanasKoS_WarnFrame.SetBackdropBorderColor = E.noop

	for i = 1, 2 do
		S:HandleTab(_G["VanasKoSFrameTab"..i])
	end

	S:HandleDropDownBox(VanasKoSFrameChooseListDropDown, 145)
	VanasKoSFrameChooseListDropDown:Point("TOPLEFT", 20, -40)

	S:HandleCheckBox(VanasKoSListFrameCheckBox)
	VanasKoSListFrameCheckBox:Point("TOPLEFT", 225, -41)

	S:HandleButton(VanasKoSListFrameAddButton)
	VanasKoSListFrameAddButton:Point("BOTTOMRIGHT", VanasKoSListFrame, "BOTTOMRIGHT", -39, 82)

	S:HandleButton(VanasKoSListFrameRemoveButton)
	VanasKoSListFrameRemoveButton:Point("RIGHT", VanasKoSListFrameAddButton, "LEFT", -2, 0)

	S:HandleButton(VanasKoSListFrameChangeButton)
	VanasKoSListFrameChangeButton:Point("RIGHT", VanasKoSListFrameRemoveButton, "LEFT", -2, 0)

	S:HandleButton(VanasKoSListFrameConfigurationButton)
	VanasKoSListFrameConfigurationButton:Point("BOTTOM", VanasKoSListFrameAddButton, "TOP", 0, 2)

	VanasKoSListTooltip:StripTextures()
	VanasKoSListTooltip:CreateBackdrop("Transparent")

	for i = 1, 9 do
		local button = _G["VanasKoSListFrameColButton"..i]

		button:StripTextures()
		button:StyleButton()
	end

	for i = 1, 17 do
		local button = _G["VanasKoSListFrameListButton"..i]

		button:StyleButton()

		button.stripe = button:CreateTexture(nil, "BACKGROUND")
		button.stripe:SetTexture("Interface\\GuildFrame\\GuildFrame")
		button.stripe:SetTexCoord(0.362, 0.381, 0.958, 0.998)
		button.stripe:SetInside()
	end

	VanasKoSListFrameListButton1:Point("TOPLEFT", 21, -95)

	VanasKoSListFrameToggleRightButton:Size(27)
	S:HandleNextPrevButton(VanasKoSListFrameToggleRightButton)
	VanasKoSListFrameToggleRightButton:Point("BOTTOMRIGHT", VanasKoSListFrame, "BOTTOMRIGHT", -39, 130)
	VanasKoSListFrameToggleLeftButton:Size(27)
	S:HandleNextPrevButton(VanasKoSListFrameToggleLeftButton)

	VanasKoSListFrameNoTogglePatch:StripTextures()

	VanasKoSListScrollFrame:StripTextures()
	S:HandleScrollBar(VanasKoSListScrollFrameScrollBar)

	VanasKoSListFrameSearchBox:SetSize(215, 20)
	S:HandleEditBox(VanasKoSListFrameSearchBox)
	VanasKoSListFrameSearchBox:Point("BOTTOMLEFT", VanasKoSListFrame, "BOTTOMLEFT", 17, 107)

	VanasKoSFrame:StripTextures(true)
	VanasKoSFrame:CreateBackdrop("Transparent")
	VanasKoSFrame.backdrop:Point("TOPLEFT", 11, -12)
	VanasKoSFrame.backdrop:Point("BOTTOMRIGHT", -34, 75)

	S:HandleCloseButton(VanasKosFrameCloseButton)

	S:HandleTab(FriendsFrameTab5)
	FriendsFrameTab5:ClearAllPoints()
	FriendsFrameTab5:Point("TOPLEFT", FriendsFrameTab4, "TOPRIGHT", -15, 0)

	S:HandleDropDownBox(VanasKoSPvPStatsCharacterDropDown, 90)
	VanasKoSPvPStatsCharacterDropDown:Point("RIGHT", VanasKoSListFrameToggleLeftButton, "LEFT", 6, -4)

	S:HandleDropDownBox(VanasKoSPvPStatsTimeSpanDropDown, 90)
	VanasKoSPvPStatsTimeSpanDropDown:Point("RIGHT", VanasKoSPvPStatsCharacterDropDown, "LEFT", 26, 0)
end

S:AddCallbackForAddon("VanasKoS", "VanasKoS", LoadSkin)