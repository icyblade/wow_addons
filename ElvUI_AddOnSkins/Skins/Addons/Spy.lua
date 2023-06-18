local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G

local function LoadSkin()
	if not E.private.addOnSkins.Spy then return end

	Spy_AlertWindow:StripTextures()
	Spy_AlertWindow:SetTemplate("Transparent")
	Spy_AlertWindow:Point("TOP", UIParent, "TOP", 0, -130)

	Spy.AlertWindow.Title:FontTemplate(nil, 12)
	Spy.AlertWindow.Name:FontTemplate(nil, 12)
	Spy.AlertWindow.Location:FontTemplate(nil, 12)

	Spy_MainWindow:StripTextures()
	Spy_MainWindow:SetTemplate("Transparent")

	for i = 1, 10 do
		local bar = _G["Spy_MainWindow_Bar"..i]

		bar:StyleButton()
		bar.StatusBar:SetStatusBarTexture(E.media.normTex)
		bar.LeftText:FontTemplate(nil, 12)
		bar.RightText:FontTemplate(nil, 12)
	end

	Spy.MainWindow.Title:FontTemplate(nil, 12)

	S:HandleCloseButton(Spy_MainWindow.CloseButton)
	Spy_MainWindow.CloseButton:Size(32)
	Spy_MainWindow.CloseButton:Point("TOPRIGHT", 2, -6)

	S:HandleNextPrevButton(Spy_MainWindow.RightButton, nil, nil, true)
	Spy_MainWindow.RightButton:Size(26)
	Spy_MainWindow.RightButton:GetNormalTexture():SetRotation(-1.57)
	Spy_MainWindow.RightButton:GetPushedTexture():SetRotation(-1.57)
	Spy_MainWindow.RightButton:Point("TOPRIGHT", -27, -9)

	S:HandleNextPrevButton(Spy_MainWindow.LeftButton, nil, nil, true)
	Spy_MainWindow.LeftButton:Size(26)
	Spy_MainWindow.LeftButton:GetNormalTexture():SetRotation(1.57)
	Spy_MainWindow.LeftButton:GetPushedTexture():SetRotation(1.57)
	Spy_MainWindow.LeftButton:Point("RIGHT", Spy_MainWindow.RightButton, "LEFT", -3, 0)
--[[
	S:HandleNextPrevButton(Spy_MainWindow.ClearButton)
	Spy_MainWindow.ClearButton:Size(16)
	Spy_MainWindow.ClearButton:Point("RIGHT", Spy_MainWindow.LeftButton, "LEFT", -3, 0)

	S:HandleCloseButton(Spy_MainWindow.CountButton)
	Spy_MainWindow.CountButton.backdrop:SetAllPoints()
	Spy_MainWindow.CountButton.text:SetText("!")
	Spy_MainWindow.CountButton.text:FontTemplate(nil, 14, "OUTLINE")
	Spy_MainWindow.CountButton.text:Point("CENTER", 1, 0)
	Spy_MainWindow.CountButton:Size(16)
]]
	Spy_MainWindow.DragBottomLeft:SetNormalTexture(nil)
	Spy_MainWindow.DragBottomRight:SetNormalTexture(nil)

	hooksecurefunc(Spy, "ShowMapTooltip", function()
		if Spy.MapTooltip then
			Spy.MapTooltip:SetTemplate("Transparent")
		end
	end)
end

S:AddCallbackForAddon("Spy", "Spy", LoadSkin)