local E, L, V, P, G = unpack(ElvUI)
local AS = E:GetModule("AddOnSkins")
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.Recount then return end

	local function SkinFrame(frame)
		frame:SetBackdrop(nil)

		local backdrop = CreateFrame("Frame", nil, frame)
		backdrop:SetFrameLevel(frame:GetFrameLevel() - 1)
		backdrop:Point("BOTTOMLEFT", frame, E.PixelMode and 1 or 0, E.PixelMode and 1 or 0)
		backdrop:Point("TOPRIGHT", frame, E.PixelMode and -1 or 0, -(E.PixelMode and 31 or 30))
		if frame == Recount.MainWindow then
			backdrop:SetTemplate()
		else
			backdrop:SetTemplate("Transparent")
		end
		frame.backdrop = backdrop

		local header = CreateFrame("Frame", nil, backdrop)
		header:Height(22)
		header:Point("TOPLEFT", frame, E.PixelMode and 1 or 0, -(E.PixelMode and 8 or 7))
		header:Point("TOPRIGHT", frame, E.PixelMode and -1 or 0, 0)
		header:SetTemplate("Default", true)

		frame.Title:ClearAllPoints()
		frame.Title:SetPoint("LEFT", header, 6, 0)
		frame.Title:FontTemplate()
		frame.Title:SetTextColor(unpack(E.media.rgbvaluecolor))

		if frame.CloseButton then
			frame.CloseButton:ClearAllPoints()
			frame.CloseButton:SetPoint("RIGHT", header, -6, 0)
		end
	end

	SkinFrame(Recount.MainWindow)

	-- Right Button
	Recount.MainWindow.RightButton:SetNormalTexture([[Interface\Buttons\SquareButtonTextures]])
	Recount.MainWindow.RightButton:SetPushedTexture([[Interface\Buttons\SquareButtonTextures]])

	local normal, pushed = Recount.MainWindow.RightButton:GetNormalTexture(), Recount.MainWindow.RightButton:GetPushedTexture()

	normal:SetTexCoord(0.421, 0.234, 0.015, 0.203)
	normal:Point("TOPLEFT", 2, -4)
	normal:Point("BOTTOMRIGHT", -2, 4)

	pushed:SetTexCoord(0.421, 0.234, 0.015, 0.203)
	pushed:Point("TOPLEFT", 2, -4)
	pushed:Point("BOTTOMRIGHT", -2, 4)

	-- Left Button
	Recount.MainWindow.LeftButton:SetNormalTexture([[Interface\Buttons\SquareButtonTextures]])
	Recount.MainWindow.LeftButton:SetPushedTexture([[Interface\Buttons\SquareButtonTextures]])

	normal, pushed = Recount.MainWindow.LeftButton:GetNormalTexture(), Recount.MainWindow.LeftButton:GetPushedTexture()

	normal:SetTexCoord(0.234, 0.421, 0.015, 0.203)
	normal:Point("TOPLEFT", 2, -4)
	normal:Point("BOTTOMRIGHT", -2, 4)

	pushed:SetTexCoord(0.234, 0.421, 0.015, 0.203)
	pushed:Point("TOPLEFT", 2, -4)
	pushed:Point("BOTTOMRIGHT", -2, 4)

	-- Reset Button
	Recount.MainWindow.ResetButton:SetNormalTexture([[Interface\Buttons\SquareButtonTextures]])
	Recount.MainWindow.ResetButton:SetPushedTexture([[Interface\Buttons\SquareButtonTextures]])

	normal, pushed = Recount.MainWindow.ResetButton:GetNormalTexture(), Recount.MainWindow.ResetButton:GetPushedTexture()

	normal:SetTexCoord(0.015, 0.203, 0.015, 0.203)
	normal:Point("TOPLEFT", 2, -2)
	normal:Point("BOTTOMRIGHT", -2, 2)

	pushed:SetTexCoord(0.015, 0.203, 0.015, 0.203)
	pushed:Point("TOPLEFT", 2, -2)
	pushed:Point("BOTTOMRIGHT", -2, 2)

	local buttons = {
		Recount.MainWindow.CloseButton,
		Recount.MainWindow.RightButton,
		Recount.MainWindow.LeftButton,
		Recount.MainWindow.ResetButton,
		Recount.MainWindow.FileButton,
		Recount.MainWindow.ConfigButton,
		Recount.MainWindow.ReportButton
	}

	for i = 1, #buttons do
		local button = buttons[i]
		if button then
			AS:Desaturate(button)
		end
	end

	Recount.MainWindow.FileButton:HookScript("OnClick", function(self) if LibDropdownFrame0 then LibDropdownFrame0:SetTemplate("Transparent") end end)

	Recount.MainWindow.DragBottomLeft:SetNormalTexture(nil)
	Recount.MainWindow.DragBottomRight:SetNormalTexture(nil)

	S:HandleScrollBar(Recount_MainWindow_ScrollBarScrollBar)

	hooksecurefunc(Recount, "ShowScrollbarElements", function(self, name) Recount_MainWindow_ScrollBarScrollBar:Show() end)
	hooksecurefunc(Recount, "HideScrollbarElements", function(self, name) Recount_MainWindow_ScrollBarScrollBar:Hide() end)

	if Recount.db.profile.MainWindow.ShowScrollbar == false then
		Recount:HideScrollbarElements("Recount_MainWindow_ScrollBar")
	end

	hooksecurefunc(Recount, "ShowReport", function()
		if not Recount_ReportWindow.isSkinned then
			SkinFrame(Recount_ReportWindow)

			S:HandleButton(Recount_ReportWindow.ReportButton)
			S:HandleSliderFrame(Recount_ReportWindow_Slider)

			AS:Desaturate(Recount_ReportWindow.CloseButton)

			Recount_ReportWindow.Whisper:StripTextures(true)
			S:HandleEditBox(Recount_ReportWindow.Whisper)
			Recount_ReportWindow.Whisper:Height(16)

			Recount_ReportWindow.isSkinned = true
		end
	end)

	hooksecurefunc(Recount, "ShowConfig", function()
		if not Recount.ConfigWindow.isSkinned then
			SkinFrame(Recount.ConfigWindow)

			AS:Desaturate(Recount.ConfigWindow.CloseButton)

			Recount.ConfigWindow.isSkinned = true
		end
	end)

	hooksecurefunc(Recount, "AddWindow", function(self, window)
		if window.YesButton and not window.isSkinned then
			SkinFrame(window)
			window.Text:FontTemplate()
			window.Text:SetPoint("TOP", window.backdrop, 0, -3)

			S:HandleButton(window.YesButton)
			window.YesButton:SetPoint("BOTTOMRIGHT", window, "BOTTOM", -3, 5)
			S:HandleButton(window.NoButton)
			window.NoButton:SetPoint("BOTTOMLEFT", window, "BOTTOM", 3, 5)
		end
	end)
end

S:AddCallbackForAddon("Recount", "Recount", LoadSkin)