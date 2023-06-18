local E, L, V, P, G = unpack(ElvUI)
local LSM = E.Libs.LSM
local M = [[Interface\AddOns\ElvUI_Enhanced\Media\]]

E.EnhancedMedia = {
	Fonts = {
		TukUI = M..[[Fonts\TukUI_UF_Font.ttf]]
	},
	Textures = {
		DeathRecap = M..[[Textures\DeathRecap.blp]],
		BuiOnePixel = M..[[Textures\BuiOnePixel.tga]]
	}
}

LSM:Register("statusbar", "BuiOnePixel", E.EnhancedMedia.Textures.BuiOnePixel)
LSM:Register("font", "TukUI Unitframes", E.EnhancedMedia.Fonts.TukUI, LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)