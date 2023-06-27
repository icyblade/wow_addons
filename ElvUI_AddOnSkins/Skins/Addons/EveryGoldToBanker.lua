local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.EveryGoldToBanker then return end

	TitleFrame:StripTextures()
	AmountFrame:StripTextures()
	ResponseFrame:StripTextures()
	ReceiverFrame:StripTextures()
	DefaultAmountFrame:StripTextures()
	DefaultReceiverFrame:StripTextures()

	EveryGoldToBankerCalculator:StripTextures()
	EveryGoldToBankerCalculator:SetTemplate("Transparent")

	SettingFrame:StripTextures()
	SettingFrame:SetTemplate("Transparent")
	SettingFrame:Point("TOPLEFT", 15, -237)

	S:HandleEditBox(AmountEditBox)
	AmountEditBox:Height(22)

	S:HandleEditBox(ReceiverEditBox)
	ReceiverEditBox:Height(22)

	S:HandleEditBox(DefaultAmountEditBox)
	DefaultAmountEditBox:Height(22)

	S:HandleEditBox(DefaultReceiverEditBox)
	DefaultReceiverEditBox:Height(22)

	S:HandleButton(CheckButton)
	S:HandleButton(SendButton)
	S:HandleButton(SettingButton)
	S:HandleButton(DoneSettingButton)

	S:HandleCloseButton(MinimizeButton)
	MinimizeButton:Size(30)
	MinimizeButton:Point("TOPLEFT", 262, 2)
end

S:AddCallbackForAddon("EveryGoldToBanker", "EveryGoldToBanker", LoadSkin)