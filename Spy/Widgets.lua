function Spy:CreateFrame(Name, Title, Height, Width, ShowFunc, HideFunc)
	local theFrame = CreateFrame("Frame", Name, UIParent)

	theFrame:ClearAllPoints()
	theFrame:SetPoint("TOPLEFT", UIParent)
	theFrame:SetHeight(Height)
	theFrame:SetWidth(Width)

	theFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\AddOns\\Spy\\Textures\\title-industrial.tga", edgeSize = 32,
		insets = {left = 0, right = 0, top = 31, bottom = 0},
	})

	if Name == "Spy_MainWindow" then
		Spy.Colors:RegisterBorder("Window", "Title", theFrame)
		Spy.Colors:RegisterBackground("Window", "Background", theFrame)
	else
		Spy.Colors:RegisterBorder("Other Windows", "Title", theFrame)
		Spy.Colors:RegisterBackground("Other Windows", "Background", theFrame)
	end

	theFrame:EnableMouse(true)
	theFrame:SetMovable(true)

	theFrame:SetScript("OnMouseDown",
	function(self, event) 
		if (((not self.isLocked) or (self.isLocked == 0)) and (event == "LeftButton")) then
			Spy:SetWindowTop(self)
			self:StartMoving();
			self.isMoving = true;
		end
	end)
	theFrame:SetScript("OnMouseUp",
	function(self) 
		if (self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
			Spy:SaveMainWindowPosition()
		end
	end)
	theFrame.ShowFunc = ShowFunc
	theFrame:SetScript("OnShow",
	function(self)
		Spy:SetWindowTop(self)
		if (self.ShowFunc) then
			self:ShowFunc()
		end
	end)
	theFrame.HideFunc = HideFunc
	theFrame:SetScript("OnHide",
	function(self) 
		if (self.isMoving) then
			self:StopMovingOrSizing();
			self.isMoving = false;
		end
		if (self.HideFunc) then
			self:HideFunc()
		end
	end)
	theFrame.Title = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -16)
	theFrame.Title:SetJustifyH("LEFT")
	theFrame.Title:SetTextColor(1.0, 1.0, 1.0, 1.0)
	theFrame.Title:SetText(Title)
	theFrame.Title:SetHeight(Spy.db.profile.MainWindow.TextHeight)
	Spy:AddFontString(theFrame.Title)

	if Name == "Spy_MainWindow" then
		Spy.Colors:UnregisterItem(theFrame.Title)
		Spy.Colors:RegisterFont("Window", "Title Text", theFrame.Title)
	else
		Spy.Colors:UnregisterItem(theFrame.Title)
		Spy.Colors:RegisterFont("Other Windows", "Title Text", theFrame.Title)
	end

	theFrame.CloseButton = CreateFrame("Button", nil, theFrame)
	theFrame.CloseButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up.blp")
	theFrame.CloseButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down.blp")
	theFrame.CloseButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp")
	theFrame.CloseButton:SetWidth(20)
	theFrame.CloseButton:SetHeight(20)
	theFrame.CloseButton:SetPoint("TOPRIGHT", theFrame, "TOPRIGHT", -4, -12)
	theFrame.CloseButton:SetScript("OnClick", function(self) self:GetParent():Hide() end)

	return theFrame
end
