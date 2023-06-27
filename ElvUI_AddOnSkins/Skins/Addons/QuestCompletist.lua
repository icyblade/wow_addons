local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G

-- QuestCompletist v99.7

local function LoadSkin()
	if not E.private.addOnSkins.QuestCompletist then return end

	-- Quest Log Button
	S:HandleButton(qcQuestLogButton)

	-- Main Frame
	qcQuestCompletistUI:StripTextures()
	qcQuestCompletistUI:SetTemplate("Transparent")
	qcQuestCompletistUI:Size(315, 380)
	qcQuestCompletistUI:CreateBackdrop("Transparent")
	qcQuestCompletistUI.backdrop:Point("TOPLEFT", 18, -56)
	qcQuestCompletistUI.backdrop:Point("BOTTOMRIGHT", -34, 62)
	qcQuestCompletistUI.backdrop:SetFrameLevel(qcQuestCompletistUI:GetFrameLevel() + 1)
	qcQuestCompletistUI:SetClampedToScreen(true)

	qcQuestCompletistUI.qcTitleText:ClearAllPoints()
	qcQuestCompletistUI.qcTitleText:Point("TOP", 0, -4)

	qcQuestCompletistUI.qcCurrentCategoryQuestCount:ClearAllPoints()
	qcQuestCompletistUI.qcCurrentCategoryQuestCount:Point("BOTTOMRIGHT", -10, 4)

	qcQuestCompletistUI.qcSelectedCategory:Point("TOPLEFT", 20, -38)
	qcQuestCompletistUI.qcSelectedCategory:SetJustifyH("LEFT")

	S:HandleButton(qcOptionsButton)
	qcOptionsButton:Point("TOPLEFT", 216, -323)

	S:HandleButton(qcCategoryDropdownButton)
	qcCategoryDropdownButton:Point("TOPLEFT", 171, -32)

	S:HandleSliderFrame(qcMenuSlider)
	qcMenuSlider:Point("TOPLEFT", 285, -56)
	qcMenuSlider:Height(262)

	S:HandleEditBox(qcSearchBox)
	qcSearchBox:Size(160, 18)
	qcSearchBox:Point("TOPLEFT", 19, -325)

	S:HandleCloseButton(qcXButton)
	qcXButton:Point("TOPLEFT", 286, 4)

	for i = 1, 16 do
		local button = _G["qcMenuButton"..i]

		button:SetHighlightTexture(E.Media.Textures.Highlight)
		button.SetHighlightTexture = E.noop

		local Highlight = button:GetHighlightTexture()
		Highlight:SetVertexColor(1, 1, 1, 0.35)
		Highlight:Point("TOPLEFT", 0, -1)
		Highlight:Point("BOTTOMRIGHT", 0, 1)

		if i == 1 then
			button:Point("TOPLEFT", 15, -60)
		end
	end

	-- Tooltips
	local tooltips = {
		"qcMapTooltip",
		"qcQuestInformationTooltip",
		"qcToastTooltip",
		"qcQuestReputationTooltip",
		"qcNewDataAlertTooltip",
		"qcMutuallyExclusiveAlertTooltip"
	}

	for _, object in pairs(tooltips) do
		if _G[object] then
			_G[object]:SetFrameStrata("DIALOG")
			_G[object]:SetBackdrop(nil)
			_G[object]:CreateBackdrop("Transparent")
		end
	end

	-- Options
	S:HandleCheckBox(qcIO_M_SHOW_ICONS)
	S:HandleCheckBox(qcIO_M_HIDE_COMPLETED)
	S:HandleCheckBox(qcIO_M_HIDE_LOWLEVEL)
	S:HandleCheckBox(qcIO_M_HIDE_PROFESSION)
	S:HandleCheckBox(qcIO_M_HIDE_SEASONAL)
	S:HandleCheckBox(qcIO_M_HIDE_INPROGRESS)
	S:HandleCheckBox(qcIO_L_HIDE_COMPLETED)
	S:HandleCheckBox(qcIO_L_HIDE_LOWLEVEL)
	S:HandleCheckBox(qcIO_L_HIDE_PROFESSION)
	S:HandleCheckBox(qcIO_ML_HIDE_FACTION)
	S:HandleCheckBox(qcIO_ML_HIDE_RACECLASS)
end

S:AddCallbackForAddon("QuestCompletist", "QuestCompletist", LoadSkin)