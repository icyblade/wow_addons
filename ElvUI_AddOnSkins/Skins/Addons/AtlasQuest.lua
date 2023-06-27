local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local ipairs = ipairs

local function LoadSkin()
	if not E.private.addOnSkins.AtlasQuest then return end

	local buttons = {
		STORYbutton,
		OPTIONbutton,
		CLOSEbutton3,
		AQOptionCloseButton
	}
	for _, button in ipairs(buttons) do
		S:HandleButton(button)
	end

	local checkBoxes = {
		AQACB,
		AQHCB,
		AQFinishedQuest,
		AQAutoshowOption,
		AQLEFTOption,
		AQRIGHTOption,
		AQColourOption,
		AQCheckQuestlogButton,
		AQAutoQueryOption,
		AQNoQuerySpamOption,
		AQCompareTooltipOption
	}
	for _, checkBox in ipairs(checkBoxes) do
		S:HandleCheckBox(checkBox)
	end

	local closeButtons = {
		CLOSEbutton,
		CLOSEbutton2
	}
	for _, closeButton in ipairs(closeButtons) do
		S:HandleCloseButton(closeButton)
	end

	AtlasQuestFrame:StripTextures()
	AtlasQuestFrame:SetTemplate("Transparent")
	AtlasQuestFrame:Size(198, 601)
	AtlasQuestFrame:ClearAllPoints()
	AtlasQuestFrame:Point("BOTTOMRIGHT", AtlasFrame, "BOTTOMLEFT", 1, 0)

	AQ_HordeTexture:SetTexture("Interface\\TargetingFrame\\UI-PVP-HORDE")
	AQ_AllianceTexture:SetTexture("Interface\\TargetingFrame\\UI-PVP-ALLIANCE")

	if AtlasMap then
		AtlasQuestInsideFrame:Size(AtlasMap:GetSize())
	end

	AtlasQuestOptionFrame:StripTextures()
	AtlasQuestOptionFrame:SetTemplate("Transparent")

	CLOSEbutton:ClearAllPoints()
	CLOSEbutton:Point("TOPLEFT", AtlasQuestFrame, "TOPLEFT", 4, -4)
	CLOSEbutton:Size(32)

	CLOSEbutton2:Size(32)

	AtlasQuestTooltip:SetTemplate("Transparent")

	for i = 1, 6 do
		local button = _G["AtlasQuestItemframe"..i]
		local icon = _G["AtlasQuestItemframe"..i.."_Icon"]

		button:StyleButton()

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:Size(28)
	end

	for i = 1, 22 do
		_G["AQQuestbutton"..i]:StyleButton()
	end

	function AQ_AtlasOrAlphamap()
		if AtlasFrame and AtlasFrame:IsVisible() then
			AtlasORAlphaMap = "Atlas"
			AtlasQuestFrame:SetParent(AtlasFrame)

			if AQ_ShownSide == "Right" then
				AtlasQuestFrame:ClearAllPoints()
				AtlasQuestFrame:Point("BOTTOMLEFT", AtlasFrame, "BOTTOMRIGHT", -1, 0)
			else
				AtlasQuestFrame:ClearAllPoints()
				AtlasQuestFrame:Point("BOTTOMRIGHT", AtlasFrame, "BOTTOMLEFT", 1, 0)
			end

			AtlasQuestInsideFrame:SetParent(AtlasFrame)
			AtlasQuestInsideFrame:ClearAllPoints()
			AtlasQuestInsideFrame:Point("TOPLEFT", "AtlasFrame", 18, -84)
		elseif AlphaMapFrame and AlphaMapFrame:IsVisible() then
			AtlasORAlphaMap = "AlphaMap"
			AtlasQuestFrame:SetParent(AlphaMapFrame)

			if AQ_ShownSide == "Right" then
				AtlasQuestFrame:ClearAllPoints()
				AtlasQuestFrame:Point("TOP", "AlphaMapFrame", 400, -107)
			else
				AtlasQuestFrame:ClearAllPoints()
				AtlasQuestFrame:Point("TOPLEFT", "AlphaMapFrame", -195, -107)
			end

			AtlasQuestInsideFrame:SetParent(AlphaMapFrame)
			AtlasQuestInsideFrame:ClearAllPoints()
			AtlasQuestInsideFrame:Point("TOPLEFT", "AlphaMapFrame", 1, -108)
		end
	end
end

S:AddCallbackForAddon("AtlasQuest", "AtlasQuest", LoadSkin)