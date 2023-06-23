local SM = LibStub:GetLibrary("LibSharedMedia-3.0")
local Astrolabe = DongleStub("Astrolabe-1.0")
local Events = LibStub("AceEvent-3.0")
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("Spy")
local _

function Spy:SetFontSize(string, size)
	local Font, Height, Flags = string:GetFont()
	string:SetFont(Font, size, Flags)
end

function Spy:CreateMapNote(num)
	local notemin = 1
	if num < notemin or Spy.MapNoteList[num] then
		return
	end

	local worldIcon = CreateFrame("Button", "Spy_MapNoteList_world"..num, WorldMapDetailFrame)
	worldIcon:SetFrameStrata(WorldMapDetailFrame:GetFrameStrata())
	worldIcon:SetParent(WorldMapDetailFrame)
	worldIcon:SetFrameLevel(WorldMapDetailFrame:GetFrameLevel() + 5)
	worldIcon:SetScript("OnEnter", function(self) Spy:ShowMapTooltip(self, true) end)
	worldIcon:SetScript("OnLeave", function(self) Spy:ShowMapTooltip(self, false) end)
	worldIcon:SetWidth(28)
	worldIcon:SetHeight(28)
	worldIcon.id = num

	local worldTexture = worldIcon:CreateTexture(nil, "OVERLAY")
	worldTexture:SetTexture("Interface\\WorldStateFrame\\"..Spy.EnemyFactionName.."Icon.blp")
	worldTexture:SetAllPoints(worldIcon)
	worldIcon.texture = worldTexture

	local miniIcon = CreateFrame("Button", "Spy_MapNoteList_mini"..num, Minimap)
	miniIcon:SetFrameStrata(Minimap:GetFrameStrata())
	miniIcon:SetParent(Minimap)
	miniIcon:SetFrameLevel(Minimap:GetFrameLevel() + 5)
	miniIcon:SetScript("OnEnter", function(self) Spy:ShowMapTooltip(self, true) end)
	miniIcon:SetScript("OnLeave", function(self) Spy:ShowMapTooltip(self, false) end)
	miniIcon:SetWidth(14)
	miniIcon:SetHeight(14)
	miniIcon.id = num

	local miniTexture = miniIcon:CreateTexture(nil, "OVERLAY")
	miniTexture:SetTexture("Interface\\WorldStateFrame\\"..Spy.EnemyFactionName.."Icon.blp")
	miniTexture:SetAllPoints(miniIcon)
	miniIcon.texture = worldTexture

	Spy.MapNoteList[num] = {}
	Spy.MapNoteList[num].displayed = false
	Spy.MapNoteList[num].continentIndex = 0
	Spy.MapNoteList[num].zoneIndex = 0
	Spy.MapNoteList[num].mapX = 0
	Spy.MapNoteList[num].mapY = 0
	Spy.MapNoteList[num].worldIcon = worldIcon
	Spy.MapNoteList[num].worldIcon:Hide()
	Spy.MapNoteList[num].miniIcon = miniIcon
	Spy.MapNoteList[num].miniIcon:Hide()
end

function Spy:CreateRow(num)
	local rowmin = 1
	if num < rowmin or Spy.MainWindow.Rows[num] then
		return
	end

	local row = CreateFrame("Button", "Spy_MainWindow_Bar"..num, Spy.MainWindow, "SpySecureActionButtonTemplate")
	row:SetPoint("TOPLEFT", Spy.MainWindow, "TOPLEFT", 2, -34 - (Spy.db.profile.MainWindow.RowHeight + Spy.db.profile.MainWindow.RowSpacing) * (num - 1))
	row:SetHeight(Spy.db.profile.MainWindow.RowHeight)
	row:SetWidth(Spy.MainWindow:GetWidth() - 4)

	Spy:SetupBar(row)
	Spy.MainWindow.Rows[num] = row
	Spy.MainWindow.Rows[num]:Hide()
	row.id = num
end

function Spy:SetupBar(row)
	row.StatusBar = CreateFrame("StatusBar", nil, row)
	row.StatusBar:SetAllPoints(row)

	local BarTexture
	if not BarTexture then
		BarTexture = Spy.db.profile.BarTexture
	end

	if not BarTexture then
		BarTexture = SM:Fetch("statusbar", "blend")
	else
		BarTexture = SM:Fetch("statusbar", BarTexture)
	end
	row.StatusBar:SetStatusBarTexture(BarTexture)
	row.StatusBar:SetStatusBarColor(.5, .5, .5, 0.8)
	row.StatusBar:SetMinMaxValues(0, 100)
	row.StatusBar:SetValue(100)
	row.StatusBar:Show()

	row.LeftText = row.StatusBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	row.LeftText:SetPoint("TOPLEFT", row.StatusBar, "TOPLEFT", 2, -4)
	row.LeftText:SetJustifyH("LEFT")
	row.LeftText:SetHeight(Spy.db.profile.MainWindow.TextHeight)
	row.LeftText:SetTextColor(1, 1, 1, 1)
	Spy:SetFontSize(row.LeftText, Spy.db.profile.MainWindow.RowHeight - 8)
	Spy:AddFontString(row.LeftText)

	row.RightText = row.StatusBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	row.RightText:SetPoint("TOPRIGHT", row.StatusBar, "TOPRIGHT", -2, -5.5)
	row.RightText:SetJustifyH("RIGHT")
	row.RightText:SetTextColor(1, 1, 1, 1)
	Spy:SetFontSize(row.RightText, Spy.db.profile.MainWindow.RowHeight - 12)
	Spy:AddFontString(row.RightText)

	Spy.Colors:RegisterFont("Bar", "Bar Text", row.LeftText)
	Spy.Colors:RegisterFont("Bar", "Bar Text", row.RightText)
end

function Spy:UpdateBarTextures()
	for _, v in pairs(Spy.MainWindow.Rows) do
		v.StatusBar:SetStatusBarTexture(SM:Fetch(SM.MediaType.STATUSBAR, Spy.db.profile.BarTexture))
		if IsAddOnLoaded("Tukui") then v.StatusBar:SetStatusBarTexture("Interface\\AddOns\\Tukui\\medias\\textures\\normTex.tga") end
		if IsAddOnLoaded("ElvUI") then v.StatusBar:SetStatusBarTexture("Interface\\AddOns\\ElvUI\\media\\textures\\normTex.tga") end
	end

	if Spy.db.profile.Font then
		Spy:SetFont(Spy.db.profile.Font)
		if IsAddOnLoaded("Tukui") then Spy:SetFont("Interface\AddOns\Tukui\medias\fonts\normal_font.ttf") end
	end
end

function Spy:SetBarTextures(handle)
	local Texture = SM:Fetch(SM.MediaType.STATUSBAR,handle)
	Spy.db.profile.BarTexture=handle
	for _, v in pairs(Spy.MainWindow.Rows) do
		v.StatusBar:SetStatusBarTexture(Texture)
		if IsAddOnLoaded("Tukui") then v.StatusBar:SetStatusBarTexture("Interface\\AddOns\\Tukui\\medias\\textures\\normTex.tga") end
		if IsAddOnLoaded("ElvUI") then v.StatusBar:SetStatusBarTexture("Interface\\AddOns\\ElvUI\\media\\textures\\normTex.tga") end
	end
end

local info = {}
function Spy_CreateBarDropdown(self, level)
	if not level then return end
	for k in pairs(info) do info[k] = nil end
	if self and self.relativeTo.LeftText then
		local player = self.relativeTo.LeftText:GetText()
		if level == 1 then
			info.isTitle = 1
			info.text = player
			info.notCheckable = true
			UIDropDownMenu_AddButton(info, level)

			info = UIDropDownMenu_CreateInfo()

			if Spy.db.profile.CurrentList == 1 or Spy.db.profile.CurrentList == 2 then
				info.isTitle = nil
				info.notCheckable = true
				info.hasArrow = true
				info.disabled = nil
				info.text = L["AnnounceDropDownMenu"]
				info.value = { ["Key"] = L["AnnounceDropDownMenu"] }
				info.arg1 = self.relativeTo.name
				UIDropDownMenu_AddButton(info, level)
			end

			if not SpyPerCharDB.KOSData[player] then
				info.isTitle = nil
				info.notCheckable = true
				info.hasArrow = false
				info.disabled = nil
				info.text = L["AddToKOSList"]
				info.func = function() Spy:ToggleKOSPlayer(true, player) end
				info.value = nil
				info.arg1 = self.relativeTo.name
				UIDropDownMenu_AddButton(info, level)
			else
				info.isTitle = nil
				info.notCheckable = true
				info.hasArrow = true
				info.disabled = nil
				info.text = L["KOSReasonDropDownMenu"]
				info.value = { ["Key"] = L["KOSReasonDropDownMenu"] }
				info.arg1 = self.relativeTo.name
				UIDropDownMenu_AddButton(info, level)

				info.isTitle = nil
				info.notCheckable = true
				info.hasArrow = false
				info.disabled = nil
				info.text = L["RemoveFromKOSList"]
				info.func = function() Spy:ToggleKOSPlayer(false, player) end
				info.value = nil
				info.arg1 = self.relativeTo.name
				UIDropDownMenu_AddButton(info, level)
			end
			if not SpyPerCharDB.IgnoreData[player] then
				info.isTitle = nil
				info.notCheckable = true
				info.hasArrow = false
				info.disabled = nil
				info.text = L["AddToIgnoreList"]
				info.func = function() Spy:ToggleIgnorePlayer(true, player) end
				info.value = nil
				info.arg1 = self.relativeTo.name
				UIDropDownMenu_AddButton(info, level)
			else
				info.isTitle = nil
				info.notCheckable = true
				info.hasArrow = false
				info.disabled = nil
				info.text = L["RemoveFromIgnoreList"]
				info.func = function() Spy:ToggleIgnorePlayer(false, player) end
				info.value = nil
				info.arg1 = self.relativeTo.name
				UIDropDownMenu_AddButton(info, level)
			end

			if Spy.db.profile.CurrentList == 1 then
				info.isTitle = nil
				info.notCheckable = true
				info.disabled = nil
				info.text = L["Clear"]
				info.func = function() Spy:RemovePlayerFromList(player) end
				info.value = nil
				info.arg1 = self.relativeTo.name
				UIDropDownMenu_AddButton(info, level)
			end
		elseif level == 2 then
			local key = UIDROPDOWNMENU_MENU_VALUE["Key"]
			info = UIDropDownMenu_CreateInfo()

			if key == L["AnnounceDropDownMenu"] and (Spy.db.profile.CurrentList == 1 or Spy.db.profile.CurrentList == 2) then
				info.isTitle = nil
				info.notCheckable = true
				info.hasArrow = false
				info.disabled = nil
				info.text = L["PartyDropDownMenu"]
				info.func = function() Spy:AnnouncePlayer(player, "PARTY") end
				info.value = { ["Key"] = key; ["Subkey"] = 1; }
				info.arg1 = self.relativeTo.name
				UIDropDownMenu_AddButton(info, level)

				info.isTitle = nil
				info.notCheckable = true
				info.hasArrow = false
				info.disabled = nil
				info.text = L["RaidDropDownMenu"]
				info.func = function() Spy:AnnouncePlayer(player, "RAID") end
				info.value = { ["Key"] = key; ["Subkey"] = 2; }
				info.arg1 = self.relativeTo.name
				UIDropDownMenu_AddButton(info, level)

				info.isTitle = nil
				info.notCheckable = true
				info.hasArrow = false
				info.disabled = nil
				info.text = L["GuildDropDownMenu"]
				info.func = function() Spy:AnnouncePlayer(player, "GUILD") end
				info.value = { ["Key"] = key; ["Subkey"] = 3; }
				info.arg1 = self.relativeTo.name
				UIDropDownMenu_AddButton(info, level)

				info.isTitle = nil
				info.notCheckable = true
				info.hasArrow = false
				info.disabled = nil
				info.text = L["LocalDefenseDropDownMenu"]
				info.func = function() Spy:AnnouncePlayer(player, "LOCAL") end
				info.value = { ["Key"] = key; ["Subkey"] = 4; }
				info.arg1 = self.relativeTo.name
				UIDropDownMenu_AddButton(info, level)
			end

			if key == L["KOSReasonDropDownMenu"] then
				for i = 1, Spy_KOSReasonListLength do
					local reason = Spy_KOSReasonList[i]
					info.isTitle = nil
					info.notCheckable = true
					info.hasArrow = true
					info.disabled = nil
					info.text = reason.title
					info.value = { ["Key"] = key; ["Subkey"] = reason.title; ["Index"] = i; }
					info.arg1 = self.relativeTo.name
					UIDropDownMenu_AddButton(info, level)
				end

				info.isTitle = nil
				info.notCheckable = true
				info.hasArrow = false
				info.disabled = nil
				info.text = L["KOSReasonClear"]
				info.func = function()
					Spy:SetKOSReason(player, nil)
					CloseDropDownMenus(1)
				end
				info.value = nil
				info.arg1 = self.relativeTo.name
				UIDropDownMenu_AddButton(info, level)
			end
		elseif level == 3 then
			local key = UIDROPDOWNMENU_MENU_VALUE["Key"]
			local subkey = UIDROPDOWNMENU_MENU_VALUE["Subkey"]
			local index = UIDROPDOWNMENU_MENU_VALUE["Index"]
			local playerData = SpyPerCharDB.PlayerData[player]
			if key == L["KOSReasonDropDownMenu"] then
				for _, reason in pairs(Spy_KOSReasonList[index].content) do
					info.isTitle = nil
					info.notCheckable = false
					info.hasArrow = false
					info.disabled = nil
					info.text = reason
					info.func = function()
						Spy:SetKOSReason(player, reason)
						CloseDropDownMenus(1)
					end
					info.checked = nil
					if playerData and playerData.reason and playerData.reason[reason] == true then
						info.checked = true
					end
					info.value = { ["Key"] = subkey; ["Subkey"] = index; }
					info.arg1 = self.relativeTo.name
					UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end
end

function Spy:BarDropDownOpen(myframe)
	Spy_BarDropDownMenu = CreateFrame("Frame", "Spy_BarDropDownMenu", myframe)
	Spy_BarDropDownMenu.displayMode = "MENU"
	Spy_BarDropDownMenu.initialize	= Spy_CreateBarDropdown

	local leftPos = myframe:GetLeft()
	local rightPos = myframe:GetRight()
	local side
	local oside
	if not rightPos then
		rightPos = 0
	end
	if not leftPos then
		leftPos = 0
	end

	local rightDist = GetScreenWidth() - rightPos

	if leftPos and rightDist < leftPos then
		side = "TOPLEFT"
		oside = "TOPRIGHT"
	else
		side = "TOPRIGHT"
		oside = "TOPLEFT"
	end
	UIDropDownMenu_SetAnchor(Spy_BarDropDownMenu, 0, 0, oside, myframe, side)
end

function Spy:SetupMainWindowButtons()
	for k, v in pairs(Spy.db.profile.MainWindow.Buttons) do
		if v then
			Spy.MainWindow[k]:Show()
			Spy.MainWindow[k]:SetWidth(16)
		else
			Spy.MainWindow[k]:SetWidth(1)
			Spy.MainWindow[k]:Hide()
		end
	end
end

function Spy:CreateMainWindow()
	if not Spy.MainWindow then
		Spy.MainWindow = Spy:CreateFrame("Spy_MainWindow", L["Nearby"], 44, 200,
		function()
			Spy.db.profile.MainWindowVis = true
		end,
		function()
			Spy.db.profile.MainWindowVis = false
		end)

		local theFrame = Spy.MainWindow
		theFrame:SetResizable(true)
		theFrame:SetMinResize(90, 44)
		theFrame:SetMaxResize(300, 264)
		theFrame:SetScript("OnSizeChanged",
		function(self)
			if (self.isResizing) then
				Spy:ResizeMainWindow()
			end
		end)
--		if Spy.db.profile.LockSpy == true then
--			theFrame:SetMovable(false)
--		else
		theFrame:SetMovable(true)
		theFrame.TitleClick = CreateFrame("FRAME", nil, theFrame)
		theFrame.TitleClick:SetAllPoints(theFrame.Title)
		theFrame.TitleClick:EnableMouse(true)
		theFrame.TitleClick:SetScript("OnMouseDown",
		function(self, button) 
			local parent = self:GetParent()
			if (((not parent.isLocked) or (parent.isLocked == 0)) and (button == "LeftButton")) then
				Spy:SetWindowTop(parent)
				parent:StartMoving();
				parent.isMoving = true;
			end
		end)
		theFrame.TitleClick:SetScript("OnMouseUp",
		function(self) 
			local parent = self:GetParent()
			if (parent.isMoving) then
				parent:StopMovingOrSizing();
				parent.isMoving = false;
				Spy:SaveMainWindowPosition()
			end
		end)
--		end
		theFrame.DragBottomRight = CreateFrame("Button", "SpyResizeGripRight", theFrame)
		theFrame.DragBottomRight:Show()
		theFrame.DragBottomRight:SetFrameLevel(theFrame:GetFrameLevel() + 10)
		theFrame.DragBottomRight:SetNormalTexture("Interface\\AddOns\\Spy\\Textures\\resize-right.tga")
		theFrame.DragBottomRight:SetHighlightTexture("Interface\\AddOns\\Spy\\Textures\\resize-right.tga")
		theFrame.DragBottomRight:SetWidth(16)
		theFrame.DragBottomRight:SetHeight(16)
		theFrame.DragBottomRight:SetPoint("BOTTOMRIGHT", theFrame, "BOTTOMRIGHT", 0, 0)
		theFrame.DragBottomRight:EnableMouse(true)
		theFrame.DragBottomRight:SetScript("OnMouseDown", function(self, button) if (((not self:GetParent().isLocked) or (self:GetParent().isLocked == 0)) and (button == "LeftButton")) then self:GetParent().isResizing = true; self:GetParent():StartSizing("BOTTOMRIGHT") end end)
		theFrame.DragBottomRight:SetScript("OnMouseUp", function(self, button) if self:GetParent().isResizing == true then self:GetParent():StopMovingOrSizing(); Spy:SaveMainWindowPosition(); Spy:RefreshCurrentList(); self:GetParent().isResizing = false; end end)

		theFrame.DragBottomLeft = CreateFrame("Button", "SpyResizeGripLeft", theFrame)
		theFrame.DragBottomLeft:Show()
		theFrame.DragBottomLeft:SetFrameLevel(theFrame:GetFrameLevel() + 10)
		theFrame.DragBottomLeft:SetNormalTexture("Interface\\AddOns\\Spy\\Textures\\resize-left.tga")
		theFrame.DragBottomLeft:SetHighlightTexture("Interface\\AddOns\\Spy\\Textures\\resize-left.tga")
		theFrame.DragBottomLeft:SetWidth(16)
		theFrame.DragBottomLeft:SetHeight(16)
		theFrame.DragBottomLeft:SetPoint("BOTTOMLEFT", theFrame, "BOTTOMLEFT", 0, 0)
		theFrame.DragBottomLeft:EnableMouse(true)
		theFrame.DragBottomLeft:SetScript("OnMouseDown", function(self, button) if (((not self:GetParent().isLocked) or (self:GetParent().isLocked == 0)) and (button == "LeftButton")) then self:GetParent().isResizing = true; self:GetParent():StartSizing("BOTTOMLEFT") end end)
		theFrame.DragBottomLeft:SetScript("OnMouseUp", function(self, button) if self:GetParent().isResizing == true then self:GetParent():StopMovingOrSizing(); Spy:SaveMainWindowPosition(); Spy:RefreshCurrentList(); self:GetParent().isResizing = false; end end)

		theFrame.RightButton = CreateFrame("Button", nil, theFrame)
		theFrame.RightButton:SetNormalTexture("Interface\\AddOns\\Spy\\Textures\\button-right.tga")
		theFrame.RightButton:SetPushedTexture("Interface\\AddOns\\Spy\\Textures\\button-right.tga")
		theFrame.RightButton:SetHighlightTexture("Interface\\AddOns\\Spy\\Textures\\button-highlight.tga")
		theFrame.RightButton:SetWidth(16)
		theFrame.RightButton:SetHeight(16)
		theFrame.RightButton:SetPoint("TOPRIGHT", theFrame, "TOPRIGHT", -23, -14.5)
		theFrame.RightButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(L["Left/Right"], 1, 0.82, 0, 1)
		GameTooltip:AddLine(L["Left/RightDescription"],0,0,0,1)
		GameTooltip:Show()
		end)
		theFrame.RightButton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		theFrame.RightButton:SetScript("OnClick", function() Spy:MainWindowNextMode() end)
		theFrame.RightButton:SetFrameLevel(theFrame.RightButton:GetFrameLevel() + 1)

		theFrame.LeftButton = CreateFrame("Button", nil, theFrame)
		theFrame.LeftButton:SetNormalTexture("Interface\\AddOns\\Spy\\Textures\\button-left.tga")
		theFrame.LeftButton:SetPushedTexture("Interface\\AddOns\\Spy\\Textures\\button-left.tga")
		theFrame.LeftButton:SetHighlightTexture("Interface\\AddOns\\Spy\\Textures\\button-highlight.tga")
		theFrame.LeftButton:SetWidth(16)
		theFrame.LeftButton:SetHeight(16)
		theFrame.LeftButton:SetPoint("RIGHT", theFrame.RightButton, "LEFT", 0, 0)
		theFrame.LeftButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(L["Left/Right"], 1, 0.82, 0, 1)
		GameTooltip:AddLine(L["Left/RightDescription"],0,0,0,1)
		GameTooltip:Show()
		end)
		theFrame.LeftButton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		theFrame.LeftButton:SetScript("OnClick", function() Spy:MainWindowPrevMode() end)
		theFrame.LeftButton:SetFrameLevel(theFrame.LeftButton:GetFrameLevel() + 1)

		theFrame.ClearButton = CreateFrame("Button", nil, theFrame)
		theFrame.ClearButton:SetNormalTexture("Interface\\AddOns\\Spy\\Textures\\button-clear.tga")
		theFrame.ClearButton:SetPushedTexture("Interface\\AddOns\\Spy\\Textures\\button-clear.tga")
		theFrame.ClearButton:SetHighlightTexture("Interface\\AddOns\\Spy\\Textures\\button-highlight.tga")
		theFrame.ClearButton:SetWidth(16)
		theFrame.ClearButton:SetHeight(16)
		theFrame.ClearButton:SetPoint("RIGHT", theFrame.LeftButton,"LEFT", 0, 0)
		theFrame.ClearButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(L["Clear"], 1, 0.82, 0, 1)
		GameTooltip:AddLine(L["ClearDescription"],0,0,0,1)
		GameTooltip:Show()
		end)
		theFrame.ClearButton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		theFrame.ClearButton:SetScript("OnClick", function() Spy:ClearList() end)
		theFrame.ClearButton:SetFrameLevel(theFrame.ClearButton:GetFrameLevel() + 1)
		
		theFrame.CountButton = CreateFrame("Button", nil, theFrame)
		theFrame.CountButton:SetNormalTexture("Interface\\AddOns\\Spy\\Textures\\button-crosshairs.tga")
		theFrame.CountButton:SetPushedTexture("Interface\\AddOns\\Spy\\Textures\\button-crosshairs.tga")
		theFrame.CountButton:SetHighlightTexture("Interface\\AddOns\\Spy\\Textures\\button-highlight.tga")
		theFrame.CountButton:SetWidth(12)
		theFrame.CountButton:SetHeight(12)
		theFrame.CountButton:SetPoint("RIGHT", theFrame.ClearButton,"LEFT", -4, 0)
		theFrame.CountButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(L["NearbyCount"], 1, 0.82, 0, 1)
		GameTooltip:AddLine(L["NearbyCountDescription"],0,0,0,1)
		GameTooltip:Show()
		end)
		theFrame.CountButton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		theFrame.CountButton:SetScript("OnClick", function() DEFAULT_CHAT_FRAME:AddMessage(L["SpySignatureColored"]..L["PlayersDetectedColored"]..Spy:GetNearbyListSize()) end)
		theFrame.CountButton:SetFrameLevel(theFrame.CountButton:GetFrameLevel() + 1)

		
		Spy.MainWindow.Rows = {}
		Spy.MainWindow.CurRows = 0

		for i = 1, Spy.ButtonLimit do
			Spy:CreateRow(i)
		end

		Spy:RestoreMainWindowPosition(Spy.db.profile.MainWindow.Position.x, Spy.db.profile.MainWindow.Position.y, Spy.db.profile.MainWindow.Position.w, 44)
		Spy:SetupMainWindowButtons()
		Spy:ResizeMainWindow()
		Spy:ScheduleRepeatingTimer("ManageExpirations", 10, true)
		Spy:InitOrder()
	end

	if not Spy.AlertWindow then
		Spy.AlertWindow = CreateFrame("Frame", "Spy_AlertWindow", UIParent)
		Spy.AlertWindow:ClearAllPoints()
		Spy.AlertWindow:SetPoint("TOP", UIParent, "TOP", 0, -90)
		Spy.AlertWindow:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		Spy.AlertWindow:SetHeight(42)
		Spy.AlertWindow:SetBackdrop({
			bgFile = "Interface\\AddOns\\Spy\\Textures\\alert-background.tga", tile = true, tileSize = 8,
			edgeFile = "Interface\\AddOns\\Spy\\Textures\\alert-industrial.tga", edgeSize = 8,
			insets = { left = 8, right = 8, top = 8, bottom = 8 },
		})
		Spy.Colors:RegisterBackground("Alert", "Background", Spy.AlertWindow)

		Spy.AlertWindow.Icon = CreateFrame("Frame", nil, Spy.AlertWindow)
		Spy.AlertWindow.Icon:ClearAllPoints()
		Spy.AlertWindow.Icon:SetPoint("TOPLEFT", Spy.AlertWindow, "TOPLEFT", 6, -5)
		Spy.AlertWindow.Icon:SetWidth(32)
		Spy.AlertWindow.Icon:SetHeight(32)

		Spy.AlertWindow.Title = Spy.AlertWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		Spy.AlertWindow.Title:SetPoint("TOPLEFT", Spy.AlertWindow, "TOPLEFT", 42, -3)
		Spy.AlertWindow.Title:SetJustifyH("LEFT")
		Spy.AlertWindow.Title:SetHeight(Spy.db.profile.MainWindow.TextHeight)
		Spy:AddFontString(Spy.AlertWindow.Title)

		Spy.AlertWindow.Name = Spy.AlertWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		Spy.AlertWindow.Name:SetPoint("TOPLEFT", Spy.AlertWindow, "TOPLEFT", 42, -15)
		Spy.AlertWindow.Name:SetJustifyH("LEFT")
		Spy.AlertWindow.Name:SetHeight(Spy.db.profile.MainWindow.TextHeight)
		Spy:AddFontString(Spy.AlertWindow.Name)
		Spy:SetFontSize(Spy.AlertWindow.Name, Spy.db.profile.AlertWindowNameSize)

		Spy.AlertWindow.Location = Spy.AlertWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		Spy.AlertWindow.Location:SetPoint("TOPLEFT", Spy.AlertWindow, "TOPLEFT", 42, -26)
		Spy.AlertWindow.Location:SetJustifyH("LEFT")
		Spy.AlertWindow.Location:SetHeight(Spy.db.profile.MainWindow.TextHeight)
		Spy:AddFontString(Spy.AlertWindow.Location)
		Spy:SetFontSize(Spy.AlertWindow.Location, Spy.db.profile.AlertWindowLocationSize)

		Spy.AlertWindow:Hide()
	end

	if not Spy.MapNoteList then
		Spy.MapNoteList = {}
		for i = 1, Spy.MapNoteLimit do
			Spy:CreateMapNote(i)
		end
	end

	if not Spy.MapTooltip then
		Spy.MapTooltip = CreateFrame("GameTooltip", "Spy_GameTooltip", nil, "GameTooltipTemplate")
	end

	Spy:SetCurrentList(1)
	if not Spy.db.profile.Enabled or not Spy.db.profile.MainWindowVis then
		Spy.MainWindow:Hide()
	end
end

function Spy:SetBar(num, name, desc, value, colorgroup, colorclass, tooltipData, opacity)
	local rowmin = 1

	if num < rowmin or not Spy.MainWindow.Rows[num] then
		return
	end

	local Row = Spy.MainWindow.Rows[num]
	Row.StatusBar:SetValue(value)
	Row.LeftText:SetText(name)
	Row.RightText:SetText(desc)
	Row.Name = name
	Row.TooltipData = tooltipData
	Row.LeftText:SetWidth(Row:GetWidth() - Row.RightText:GetStringWidth() - 4)

	if colorgroup and colorclass and type(colorclass) == "string" then
		Spy.Colors:UnregisterItem(Row.StatusBar)
		local Multi = { r = 1, b = 1, g = 1, a = opacity }
		Spy.Colors:RegisterTexture(colorgroup, colorclass, Row.StatusBar, Multi)
	end

	Row.LeftText:SetTextColor(Spy.db.profile.Colors.Bar["Bar Text"].r, Spy.db.profile.Colors.Bar["Bar Text"].g, Spy.db.profile.Colors.Bar["Bar Text"].b, opacity)
	Row.RightText:SetTextColor(Spy.db.profile.Colors.Bar["Bar Text"].r, Spy.db.profile.Colors.Bar["Bar Text"].g, Spy.db.profile.Colors.Bar["Bar Text"].b, opacity)
end

function Spy:AutomaticallyResize()
	local detected = Spy.ListAmountDisplayed
	if detected > Spy.ButtonLimit then detected = Spy.ButtonLimit end
	local height = 45 + (detected * (Spy.db.profile.MainWindow.RowHeight + Spy.db.profile.MainWindow.RowSpacing))
	Spy.MainWindow.CurRows = detected
	if not InCombatLockdown() then Spy:RestoreMainWindowPosition(Spy.MainWindow:GetLeft(), Spy.MainWindow:GetTop(), Spy.MainWindow:GetWidth(), height) end
end

function Spy:ManageBarsDisplayed()
	local detected = Spy.ListAmountDisplayed
	local bars = math.floor((Spy.MainWindow:GetHeight() - 44) / (Spy.db.profile.MainWindow.RowHeight + Spy.db.profile.MainWindow.RowSpacing))
	if bars > detected then bars = detected end
	if bars > Spy.ButtonLimit then bars = Spy.ButtonLimit end
	Spy.MainWindow.CurRows = bars

	if not InCombatLockdown() then
		for i = 1, Spy.ButtonLimit do
			if i <= Spy.MainWindow.CurRows then
				Spy.MainWindow.Rows[i]:Show()
			else
				Spy.MainWindow.Rows[i]:Hide()
			end
		end
	end
end

function Spy:ResizeMainWindow()
	if Spy.MainWindow.Rows[0] then Spy.MainWindow.Rows[0]:Hide() end

	local CurWidth = Spy.MainWindow:GetWidth() - 4
	Spy.MainWindow.Title:SetWidth(CurWidth - 75)
	for i = 1, Spy.ButtonLimit do
		Spy.MainWindow.Rows[i]:SetWidth(CurWidth)
	end

	Spy:ManageBarsDisplayed()
end

function Spy:SetCurrentList(mode)
	if not mode or mode > #Spy.ListTypes then
		mode = 1
	end
	Spy.db.profile.CurrentList = mode
	Spy:ManageExpirations()

	local data = Spy.ListTypes[mode]
	Spy.MainWindow.Title:SetText(data[1])

	Spy:RefreshCurrentList()
end

function Spy:MainWindowNextMode()
	local mode = Spy.db.profile.CurrentList + 1
	if mode > table.maxn(Spy.ListTypes) then
		mode = 1
	end
	Spy:SetCurrentList(mode)
end

function Spy:MainWindowPrevMode()
	local mode = Spy.db.profile.CurrentList - 1
	if mode == 0 then
		mode = table.maxn(Spy.ListTypes)
	end
	Spy:SetCurrentList(mode)
end

function Spy:SaveMainWindowPosition()
	Spy.db.profile.MainWindow.Position.x = Spy.MainWindow:GetLeft()
	Spy.db.profile.MainWindow.Position.y = Spy.MainWindow:GetTop()
	Spy.db.profile.MainWindow.Position.w = Spy.MainWindow:GetWidth()
	Spy.db.profile.MainWindow.Position.h = Spy.MainWindow:GetHeight()
end

function Spy:RestoreMainWindowPosition(x, y, width, height)
	Spy.MainWindow:ClearAllPoints()
	Spy.MainWindow:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)
	Spy.MainWindow:SetWidth(width)
	for i = 1, Spy.ButtonLimit do
		Spy.MainWindow.Rows[i]:SetWidth(width - 4)
	end
	Spy.MainWindow:SetHeight(height)
	Spy:SaveMainWindowPosition()
end

function Spy:ShowTooltip(self, show, id)
	if show then
		local name = Spy.ButtonName[self.id]
		if name and name ~= "" then
			local titleText = Spy.db.profile.Colors.Tooltip["Title Text"]

			GameTooltip:SetOwner(Spy.MainWindow, "ANCHOR_NONE")
			GameTooltip:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -CONTAINER_OFFSET_X - 13, CONTAINER_OFFSET_Y)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(string.gsub(name, "%-", " - "), titleText.r, titleText.g, titleText.b)

			local playerData = SpyPerCharDB.PlayerData[name]
			if playerData then
				local detailsText = Spy.db.profile.Colors.Tooltip["Details Text"]
				if playerData.guild and playerData.guild ~= "" then
					GameTooltip:AddLine(playerData.guild, detailsText.r, detailsText.g, detailsText.b)
				end

				local details = ""
				if playerData.level then details = L["Level"].." "..playerData.level.." " end
				if playerData.race then details = details..playerData.race.." " end
				if playerData.class then details = details..L[playerData.class] end
				if details ~= "" then
					GameTooltip:AddLine(details..L["Player"], detailsText.r, detailsText.g, detailsText.b)
				end

				if Spy.db.profile.DisplayWinLossStatistics then
					local wins = "0"
					local loses = "0"
					if playerData.wins then wins = playerData.wins end
					if playerData.loses then loses = playerData.loses end
					GameTooltip:AddLine(L["StatsWins"]..wins..L["StatsSeparator"]..L["StatsLoses"]..loses, detailsText.r, detailsText.g, detailsText.b)
				end

				if SpyPerCharDB.KOSData[name] then
					local reasonText = Spy.db.profile.Colors.Tooltip["Reason Text"]
					GameTooltip:AddLine(L["KOSReason"], reasonText.r, reasonText.g, reasonText.b)
					if playerData.reason and Spy.db.profile.DisplayKOSReason then
						for reason in pairs(playerData.reason) do
							if reason == L["KOSReasonOther"] then
								GameTooltip:AddLine(L["KOSReasonIndent"]..playerData.reason[reason], reasonText.r, reasonText.g, reasonText.b)
							else
								GameTooltip:AddLine(L["KOSReasonIndent"]..reason, reasonText.r, reasonText.g, reasonText.b)
							end
						end
					end
				end

				if Spy.db.profile.DisplayLastSeen then
					local locationText = Spy.db.profile.Colors.Tooltip["Location Text"]
					if playerData.time then
						local lastSeen = L["LastSeen"]
						local minutes = math.floor((time() - playerData.time) / 60)
						local hours = math.floor(minutes / 60)
						if minutes <= 0 then
							lastSeen = lastSeen.." "..L["LessThanOneMinuteAgo"]
						elseif minutes > 0 and minutes < 60 then
							lastSeen = lastSeen.." "..minutes.." "..L["MinutesAgo"]
						elseif hours > 0 and hours < 24 then
							lastSeen = lastSeen.." "..hours.." "..L["HoursAgo"]
						else
							local days = math.floor(hours / 24)
							lastSeen = lastSeen.." "..days.." "..L["DaysAgo"]
						end
						GameTooltip:AddLine(lastSeen, locationText.r, locationText.g, locationText.b)
					end
					GameTooltip:AddLine(Spy:GetPlayerLocation(playerData), locationText.r, locationText.g, locationText.b)
				end
			end

			GameTooltip:Show()
		end
	else
		GameTooltip:Hide()
	end
end

function Spy:ShowMapTooltip(icon, show)
	local tooltip = Spy.MapTooltip
	if show then
		local titleText = Spy.db.profile.Colors.Tooltip["Details Text"]
		local locationText = Spy.db.profile.Colors.Tooltip["Location Text"]

		local distance = Astrolabe:GetDistanceToIcon(icon)
		if distance == nil then
			distance = ""
		else
			distance = math.floor(distance).." "..L["Yards"]
		end

		tooltip:SetOwner(icon, "ANCHOR_NONE")
		tooltip:SetPoint("TOPLEFT", icon, "TOPRIGHT", 16, 0)
		tooltip:ClearLines()
		tooltip:AddDoubleLine(Spy.EnemyFactionName.." "..L["Located"], distance, titleText.r, titleText.g, titleText.b, locationText.r, locationText.g, locationText.b)

		for player in pairs(Spy.PlayerCommList) do
			if Spy.PlayerCommList[player] == icon.id then
				local name, description = player, ""
				local playerData = SpyPerCharDB.PlayerData[player]
				if playerData and playerData.isEnemy then
					if playerData.guild and strlen(playerData.guild) > 0 then
						name = name..L["MinimapGuildText"].." <"..playerData.guild..">"
					end
					if Spy.db.profile.MinimapDetails then
						if playerData.class and playerData.level then
							description = description..L["MinimapClassText"..playerData.class].."["..playerData.level.." "..L[playerData.class].."]"
						elseif playerData.class then
							description = description..L["MinimapClassText"..playerData.class].."["..L[playerData.class].."]"
						elseif playerData.level then
							description = description.."["..playerData.level.."]"
						end
					end
				end
				tooltip:AddDoubleLine(name, description)
			end
		end
		tooltip:Show()
	else
		tooltip:Hide()
	end
end

function Spy:ShowAlert(type, name, source, location)
	if not UIFrameIsFading(Spy.AlertWindow) then
		Spy.AlertType = nil
	end

	if type == "kos" then
		Spy.Colors:RegisterBorder("Alert", "KOS Border", Spy.AlertWindow)
		Spy.AlertWindow.Icon:SetBackdrop({ bgFile = "Interface\\Icons\\Ability_Creature_Cursed_02" })
		Spy.Colors:RegisterBorder("Alert", "Background", Spy.AlertWindow.Icon)
		Spy.Colors:RegisterBackground("Alert", "Icon", Spy.AlertWindow.Icon)
		Spy.Colors:RegisterFont("Alert", "KOS Text", Spy.AlertWindow.Title)
		Spy.AlertWindow.Title:SetText(L["AlertKOSTitle"])
		Spy.Colors:RegisterFont("Alert", "Name Text", Spy.AlertWindow.Name)
		Spy.AlertWindow.Name:SetText(name)
		Spy.Colors:RegisterFont("Alert", "KOS Text", Spy.AlertWindow.Location)
		Spy.AlertWindow.Location:SetText(location)
		Spy.AlertWindow:SetWidth(Spy.AlertWindow.Title:GetStringWidth() + 52)
		if (Spy.AlertWindow.Title:GetStringWidth() < Spy.AlertWindow.Name:GetStringWidth()) then
			Spy.AlertWindow:SetWidth(Spy.AlertWindow.Name:GetStringWidth() + 52)
		else
			Spy.AlertWindow:SetWidth(Spy.AlertWindow.Title:GetStringWidth() + 52)
		end

		UIFrameFlashStop(Spy.AlertWindow)
		UIFrameFlash(Spy.AlertWindow, 0, 1, 4, false, 3, 0)
		Spy.AlertType = type
	elseif type == "kosguild" and Spy.AlertType ~= "kos" then
		Spy.Colors:RegisterBorder("Alert", "KOS Guild Border", Spy.AlertWindow)
		Spy.AlertWindow.Icon:SetBackdrop({ bgFile = "Interface\\Icons\\Spell_Holy_PrayerofSpirit" })
		Spy.Colors:RegisterBorder("Alert", "Background", Spy.AlertWindow.Icon)
		Spy.Colors:RegisterBackground("Alert", "Icon", Spy.AlertWindow.Icon)
		Spy.Colors:RegisterFont("Alert", "KOS Guild Text", Spy.AlertWindow.Title)
		Spy.AlertWindow.Title:SetText(L["AlertKOSGuildTitle"])
		Spy.Colors:RegisterFont("Alert", "Name Text", Spy.AlertWindow.Name)
		Spy.AlertWindow.Name:SetText(name)
		Spy.AlertWindow.Location:SetText("")
		Spy.AlertWindow:SetWidth(Spy.AlertWindow.Title:GetStringWidth() + 52)
		if (Spy.AlertWindow.Title:GetStringWidth() < Spy.AlertWindow.Name:GetStringWidth()) then
			Spy.AlertWindow:SetWidth(Spy.AlertWindow.Name:GetStringWidth() + 52)
		else
			Spy.AlertWindow:SetWidth(Spy.AlertWindow.Title:GetStringWidth() + 52)
		end

		UIFrameFlashStop(Spy.AlertWindow)
		UIFrameFlash(Spy.AlertWindow, 0, 1, 4, false, 3, 0)
		Spy.AlertType = type
	elseif type == "stealth" and Spy.AlertType ~= "kos" and Spy.AlertType ~= "kosguild" then
		Spy.Colors:RegisterBorder("Alert", "Stealth Border", Spy.AlertWindow)
		Spy.AlertWindow.Icon:SetBackdrop({ bgFile = "Interface\\Icons\\Ability_Stealth" })
		Spy.Colors:RegisterBorder("Alert", "Background", Spy.AlertWindow.Icon)
		Spy.Colors:RegisterBackground("Alert", "Icon", Spy.AlertWindow.Icon)
		Spy.Colors:RegisterFont("Alert", "Stealth Text", Spy.AlertWindow.Title)
		Spy.AlertWindow.Title:SetText(L["AlertStealthTitle"])
		Spy.Colors:RegisterFont("Alert", "Name Text", Spy.AlertWindow.Name)
		Spy.AlertWindow.Name:SetText(name)
		Spy.AlertWindow.Location:SetText("")
		Spy.AlertWindow:SetWidth(Spy.AlertWindow.Title:GetStringWidth() + 52)
		if (Spy.AlertWindow.Title:GetStringWidth() < Spy.AlertWindow.Name:GetStringWidth()) then
			Spy.AlertWindow:SetWidth(Spy.AlertWindow.Name:GetStringWidth() + 52)
		else
			Spy.AlertWindow:SetWidth(Spy.AlertWindow.Title:GetStringWidth() + 52)
		end

		UIFrameFlashStop(Spy.AlertWindow)
		UIFrameFlash(Spy.AlertWindow, 0, 1, 4, false, 3, 0)
		Spy.AlertType = type
	elseif (type == "kosaway" or type == "kosguildaway") and Spy.AlertType ~= "kos" and Spy.AlertType ~= "kosguild" and Spy.AlertType ~= "stealth" then
		local realmSeparator = strfind(source, "-")
		if realmSeparator and realmSeparator > 1 then
			source = string.gsub(strsub(source, 1, realmSeparator - 1), " ", "")
		end
		Spy.Colors:RegisterBorder("Alert", "Away Border", Spy.AlertWindow)
		Spy.AlertWindow.Icon:SetBackdrop({ bgFile = "Interface\\Icons\\Ability_Hunter_SniperShot" })
		Spy.Colors:RegisterBorder("Alert", "Background", Spy.AlertWindow.Icon)
		Spy.Colors:RegisterBackground("Alert", "Icon", Spy.AlertWindow.Icon)
		Spy.Colors:RegisterFont("Alert", "Away Text", Spy.AlertWindow.Title)
		Spy.AlertWindow.Title:SetText(L["AlertTitle_"..type]..source.."!")
		Spy.Colors:RegisterFont("Alert", "Name Text", Spy.AlertWindow.Name)
		Spy.AlertWindow.Name:SetText(name)
		Spy.Colors:RegisterFont("Alert", "Location Text", Spy.AlertWindow.Location)
		Spy.AlertWindow.Location:SetText(location)
		if (Spy.AlertWindow.Title:GetStringWidth() < Spy.AlertWindow.Location:GetStringWidth()) then
			Spy.AlertWindow:SetWidth(Spy.AlertWindow.Location:GetStringWidth() + 52)
		else
			Spy.AlertWindow:SetWidth(Spy.AlertWindow.Title:GetStringWidth() + 52)
		end

		UIFrameFlashStop(Spy.AlertWindow)
		UIFrameFlash(Spy.AlertWindow, 0, 1, 4, false, 3, 0)
		Spy.AlertType = type
	end
	Spy.AlertWindow.Name:SetWidth(Spy.AlertWindow:GetWidth() - 52)
	Spy.AlertWindow.Location:SetWidth(Spy.AlertWindow:GetWidth() - 52)
end

--[[function Spy:InverseAnchors ()
	TOPLEFT = "BOTTOMLEFT"
	TOPRIGHT = "BOTTOMRIGHT"
	BOTTOMLEFT = "TOPLEFT"
	BOTTOMRIGHT = "TOPRIGHT"
end]]

