local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

--Cache global variables
--Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
--WoW API / Variables

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.trainer ~= true then return end

	--Class Trainer Frame
	local StripAllTextures = {
		"ClassTrainerFrame",
		"ClassTrainerScrollFrameScrollChild",
		"ClassTrainerFrameSkillStepButton",
		"ClassTrainerFrameBottomInset",
		"ClassTrainerFrameInset",
	}

	local buttons = {
		"ClassTrainerTrainButton",
	}

	local KillTextures = {
		"ClassTrainerFramePortrait",
		"ClassTrainerScrollFrameScrollBarBG",
		"ClassTrainerScrollFrameScrollBarTop",
		"ClassTrainerScrollFrameScrollBarBottom",
		"ClassTrainerScrollFrameScrollBarMiddle",
	}

	local ClassTrainerFrame = _G["ClassTrainerFrame"]
	for i= 1, #ClassTrainerFrame.scrollFrame.buttons do
		local button = _G["ClassTrainerScrollFrameButton"..i]
		button:StripTextures()
		button:StyleButton()
		button.icon:SetTexCoord(unpack(E.TexCoords))
		button:CreateBackdrop()
		button.backdrop:SetOutside(button.icon)
		button.icon:SetParent(button.backdrop)
		button.selectedTex:SetColorTexture(1, 1, 1, 0.3)
		button.selectedTex:SetInside()
	end

	S:HandleScrollBar(ClassTrainerScrollFrameScrollBar, 5)

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	for _, texture in pairs(KillTextures) do
		_G[texture]:Kill()
	end

	for i = 1, #buttons do
		_G[buttons[i]]:StripTextures()
		S:HandleButton(_G[buttons[i]])
	end

	S:HandleDropDownBox(ClassTrainerFrameFilterDropDown, 155)

	ClassTrainerFrame:SetHeight(ClassTrainerFrame:GetHeight() + 5)
	ClassTrainerFrame:CreateBackdrop("Transparent")
	ClassTrainerFrame.backdrop:Point("TOPLEFT", ClassTrainerFrame, "TOPLEFT")
	ClassTrainerFrame.backdrop:Point("BOTTOMRIGHT", ClassTrainerFrame, "BOTTOMRIGHT")
	S:HandleCloseButton(ClassTrainerFrameCloseButton,ClassTrainerFrame)
	ClassTrainerFrameSkillStepButton.icon:SetTexCoord(unpack(E.TexCoords))
	ClassTrainerFrameSkillStepButton:CreateBackdrop("Default")
	ClassTrainerFrameSkillStepButton.backdrop:SetOutside(ClassTrainerFrameSkillStepButton.icon)
	ClassTrainerFrameSkillStepButton.icon:SetParent(ClassTrainerFrameSkillStepButton.backdrop)
	ClassTrainerFrameSkillStepButtonHighlight:SetColorTexture(1,1,1,0.3)
	ClassTrainerFrameSkillStepButton.selectedTex:SetColorTexture(1,1,1,0.3)

	ClassTrainerStatusBar:StripTextures()
	ClassTrainerStatusBar:SetStatusBarTexture(E["media"].normTex)
	ClassTrainerStatusBar:CreateBackdrop("Default")
	ClassTrainerStatusBar.rankText:ClearAllPoints()
	ClassTrainerStatusBar.rankText:Point("CENTER", ClassTrainerStatusBar, "CENTER")
	E:RegisterStatusBar(ClassTrainerStatusBar)
end

S:AddCallbackForAddon("Blizzard_TrainerUI", "Trainer", LoadSkin)