local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins');
local Sk = SLE:GetModule("Skins")
local _G = _G
local unpack = unpack

local function LoadSkin()
	if not E.private.sle.skins.questguru.enable then return end
	_G["QuestGuru"]:StripTextures()
	_G["QuestGuruPortraitFrame"]:Kill()
	_G["QGC_FramePortrait"]:Kill()
	_G["QuestGuruInset"]:StripTextures()
	_G["QuestGuru"]:SetTemplate("Transparent")

	_G["QuestGuruScrollFrame"]:StripTextures()
	_G["QuestGuruScrollFrame"].expandAll:StripTextures()
	_G["QuestGuruDetailScrollFrame"]:StripTextures()
	_G["QuestGuru"].count:StripTextures()

	S:HandleScrollBar(_G["QuestGuruScrollFrameScrollBar"])
	S:HandleScrollBar(_G["QuestGuruDetailScrollFrameScrollBar"])
	if (E.private.sle.skins.questguru.removeParchment) then
		_G["QuestGuruDetailScrollFrame"]:StripTextures();
	else
		_G["QuestGuruDetailScrollFrame"].DetailBG:SetTexture("Interface\\QuestFrame\\QuestBG")
	end

	_G["QuestGuru"].abandon.RightSeparator:Kill()
	_G["QuestGuru"].push.RightSeparator:Kill()
	_G["QuestGuru"].Track.RightSeparator:Kill()
	S:HandleButton(_G["QuestGuru"].abandon)
	S:HandleButton(_G["QuestGuru"].push)
	S:HandleButton(_G["QuestGuru"].Track)
	S:HandleCloseButton(_G["QuestGuruCloseButton"])

	local CloseButton = _G["QuestGuruText"]:GetParent()
	CloseButton.LeftSeparator:Kill()
	S:HandleButton(CloseButton)
end

S:RegisterSkin('QuestGuru', LoadSkin)
