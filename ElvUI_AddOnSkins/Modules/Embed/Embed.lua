local E, L, V, P, G = unpack(ElvUI)
local Loc = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale or "enUS")
local EMB = E:NewModule("EmbedSystem")
local AS = E:GetModule("AddOnSkins")
local Chat = E:GetModule("Chat")
local Layout = E:GetModule("Layout")

local _G = _G
local pairs, tonumber = pairs, tonumber
local format, lower, match = string.format, string.lower, string.match
local floor = math.floor
local tinsert = table.insert

local hooksecurefunc = hooksecurefunc
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS

function EMB:GetChatWindowInfo()
	local chatTabInfo = {["NONE"] = Loc["NONE"]}
	for i = 1, NUM_CHAT_WINDOWS do
		chatTabInfo["ChatFrame"..i] = _G["ChatFrame"..i.."Tab"]:GetText()
	end
	return chatTabInfo
end

function EMB:ToggleChatFrame(hide)
	local chatFrame = E.db.addOnSkins.embed.hideChat
	if chatFrame == "NONE" then return end

	if hide then
		_G[chatFrame].originalParent = _G[chatFrame]:GetParent()
		_G[chatFrame]:SetParent(E.HiddenFrame)

		_G[chatFrame.."Tab"].originalParent = _G[chatFrame.."Tab"]:GetParent()
		_G[chatFrame.."Tab"]:SetParent(E.HiddenFrame)
	else
		if _G[chatFrame].originalParent then
			_G[chatFrame]:SetParent(_G[chatFrame].originalParent)
			_G[chatFrame.."Tab"]:SetParent(_G[chatFrame.."Tab"].originalParent)
		end
	end
end

function EMB:EmbedShow()
	if _G[self.leftFrame.frameName] then
		_G[self.leftFrame.frameName]:Show()
	end

	if E.db.addOnSkins.embed.embedType == "DOUBLE" then
		if _G[self.rightFrame.frameName] then
			_G[self.rightFrame.frameName]:Show()
		end
	end

	self:ToggleChatFrame(true)
	self.switchButton:SetAlpha(1)
end

function EMB:EmbedHide()
	if _G[self.leftFrame.frameName] then
		_G[self.leftFrame.frameName]:Hide()
	end

	if E.db.addOnSkins.embed.embedType == "DOUBLE" then
		if _G[self.rightFrame.frameName] then
			_G[self.rightFrame.frameName]:Hide()
		end
	end

	self:ToggleChatFrame(false)
	self.switchButton:SetAlpha(0.6)
end

function EMB:CheckEmbed(addon)
	local db = E.db.addOnSkins.embed
	local left, right, embed = lower(db.leftWindow), lower(db.rightWindow), lower(addon)

	if AS:CheckAddOn(addon) and ((db.embedType == "SINGLE" and match(left, embed)) or db.embedType == "DOUBLE" and (match(left, embed) or match(right, embed))) then
		return true
	else
		return false
	end
end

function EMB:EmbedUpdate()
	if E.db.addOnSkins.embed.embedType == "DISABLE" then return end

	if not self.embedCreated then
		self:EmbedCreate()
	end

	self:WindowResize()

	if self:CheckEmbed("Omen") then self:EmbedOmen() end
	if self:CheckEmbed("Recount") then self:EmbedRecount() end
	if self:CheckEmbed("Skada") then self:EmbedSkada() end
end

function EMB:SetHooks()
	hooksecurefunc(Chat, "PositionChat", function(self, override)
		if override then
			EMB:EmbedUpdate()
		end
	end)
	hooksecurefunc(Layout, "ToggleChatPanels", function() EMB:EmbedUpdate() end)

	hooksecurefunc(LeftChatPanel, "fadeFunc", function()
		LeftChatPanel:Hide()
		if not E.db.addOnSkins.embed.rightChatPanel then
			EMB.switchButton:Hide()
		end
	end)
	hooksecurefunc(RightChatPanel, "fadeFunc", function()
		RightChatPanel:Hide()
		if E.db.addOnSkins.embed.rightChatPanel then
			EMB.switchButton:Hide()
		end
	end)

	RightChatToggleButton:RegisterForClicks("AnyDown")
	RightChatToggleButton:HookScript("OnClick", function(self, btn)
		if btn == "RightButton" then
			if E.db.addOnSkins.embed.rightChatPanel then
				if EMB.mainFrame:IsShown() then
					EMB.mainFrame:Hide()
				else
					EMB.mainFrame:Show()
				end
			end
		end
		EMB:UpdateSwitchButton()
	end)

	RightChatToggleButton:HookScript("OnEnter", function()
		if E.db.addOnSkins.embed.rightChatPanel then
			GameTooltip:AddDoubleLine(L["Right Click:"], L["Toggle Embedded Addon"], 1, 1, 1)
			GameTooltip:Show()
			EMB:UpdateSwitchButton()
		end
	end)

	LeftChatToggleButton:RegisterForClicks("AnyDown")
	LeftChatToggleButton:HookScript("OnClick", function(self, btn)
		if btn == "RightButton" then
			if not E.db.addOnSkins.embed.rightChatPanel then
				if EMB.mainFrame:IsShown() then
					EMB.mainFrame:Hide()
				else
					EMB.mainFrame:Show()
				end
			end
		end
		EMB:UpdateSwitchButton()
	end)

	LeftChatToggleButton:HookScript("OnEnter", function()
		if not E.db.addOnSkins.embed.rightChatPanel then
			GameTooltip:AddDoubleLine(L["Right Click:"], L["Toggle Embedded Addon"], 1, 1, 1)
			GameTooltip:Show()
			EMB:UpdateSwitchButton()
		end
	end)
end

function EMB:WindowResize()
	if not self.embedCreated then return end

	local db = E.db.addOnSkins.embed
	local SPACING = E.Border + E.Spacing
	local chatPanel = db.rightChatPanel and RightChatPanel or LeftChatPanel
	local chatTab = db.rightChatPanel and RightChatTab or LeftChatTab
	local chatData = db.rightChatPanel and RightChatDataPanel or LeftChatToggleButton
	local topRight = chatData == RightChatDataPanel and (E.db.datatexts.rightChatPanel and "TOPLEFT" or "BOTTOMLEFT") or chatData == LeftChatToggleButton and (E.db.datatexts.leftChatPanel and "TOPLEFT" or "BOTTOMLEFT")
	local yOffset = (chatData == RightChatDataPanel and E.db.datatexts.rightChatPanel and SPACING) or (chatData == LeftChatToggleButton and E.db.datatexts.leftChatPanel and SPACING) or 0
	local isDouble = db.embedType == "DOUBLE"

	self.mainFrame:SetParent(chatPanel)
	self.mainFrame:ClearAllPoints()

	self.mainFrame:Point("BOTTOMLEFT", chatData, topRight, 0, yOffset)
	self.mainFrame:Point("TOPRIGHT", chatTab, db.belowTopTab and "BOTTOMRIGHT" or "TOPRIGHT", 0, db.belowTopTab and -SPACING or 0)

	if isDouble then
		self.leftFrame:ClearAllPoints()
		self.leftFrame:Point("TOPLEFT", self.mainFrame)
		self.leftFrame:Point("BOTTOMRIGHT", self.mainFrame, "BOTTOMRIGHT", -(self.mainFrame:GetWidth() - db.leftWindowWidth  + SPACING), 0)

		self.rightFrame:ClearAllPoints()
		self.rightFrame:Point("TOPLEFT", self.leftFrame, "TOPRIGHT", SPACING, 0)
		self.rightFrame:Point("BOTTOMRIGHT", self.mainFrame)
	else
		self.leftFrame:ClearAllPoints()
		self.leftFrame:Point("TOPLEFT", self.mainFrame)
		self.leftFrame:Point("BOTTOMRIGHT", self.mainFrame)
	end

	self:UpdateSwitchButton()

	if IsAddOnLoaded("ElvUI_OptionsUI") then
		E.Options.args.elvuiPlugins.args.addOnSkins.args.embed.args.leftWindowWidth.min = floor(chatPanel:GetWidth() * 0.25)
		E.Options.args.elvuiPlugins.args.addOnSkins.args.embed.args.leftWindowWidth.max = floor(chatPanel:GetWidth() * 0.75)
	end
end

function EMB:UpdateSwitchButton()
	local db = E.db.addOnSkins.embed
	local chatPanel = db.rightChatPanel and RightChatPanel or LeftChatPanel
	local chatTab = db.rightChatPanel and RightChatTab or LeftChatTab
	local isDouble = db.embedType == "DOUBLE"

	self.switchButton:SetParent(chatPanel)

	if db.belowTopTab and chatPanel:IsShown() then
		self.switchButton:Show()
		self.switchButton.text:SetText(isDouble and db.leftWindow.." / "..db.rightWindow or db.leftWindow)
		self.switchButton:ClearAllPoints()

		if E.Chat.RightChatWindowID and _G["ChatFrame"..E.Chat.RightChatWindowID.."Tab"]:IsVisible() then
			self.switchButton:Point("LEFT", _G["ChatFrame"..E.Chat.RightChatWindowID.."Tab"], "RIGHT", 0, 0)
		else
			self.switchButton:Point(db.rightChatPanel and "LEFT" or "RIGHT", chatTab, 5, 4)
		end
	elseif self.switchButton:IsShown() then
		self.switchButton:Hide()
	end
end

function EMB:EmbedCreate()
	if self.embedCreated then return end

	self.mainFrame = CreateFrame("Frame", "ElvUI_AddOnSkins_Embed_MainWindow", UIParent)
	self.leftFrame = CreateFrame("Frame", "ElvUI_AddOnSkins_Embed_LeftWindow", self.mainFrame)
	self.rightFrame = CreateFrame("Frame", "ElvUI_AddOnSkins_Embed_RightWindow", self.mainFrame)

	self.switchButton = CreateFrame("Button", "ElvUI_AddOnSkins_Embed_SwitchButton", UIParent)
	self.switchButton:Size(120, 32)
	self.switchButton:RegisterForClicks("AnyUp")

	self.switchButton.text = self.switchButton:CreateFontString(nil, "OVERLAY")
	self.switchButton.text:FontTemplate(E.LSM:Fetch("font", E.db.chat.tabFont), E.db.chat.tabFontSize, E.db.chat.tabFontOutline)
	self.switchButton.text:SetTextColor(unpack(E.media.rgbvaluecolor))
	self.switchButton.text:SetPoint("LEFT", 16, -5)

	self.switchButton:SetScript("OnClick", function(self, button)
		if EMB.mainFrame:IsShown() then
			EMB.mainFrame:Hide()
			self:SetAlpha(0.6)
		else
			EMB.mainFrame:Show()
			self:SetAlpha(1)
		end
		EMB:UpdateSwitchButton()
	end)

	self.switchButton:SetScript("OnMouseDown", function(self) self.text:Point("LEFT", 18, -7) end)
	self.switchButton:SetScript("OnMouseUp", function(self) self.text:Point("LEFT", 16, -5) end)

	self.mainFrame:SetScript("OnShow", function() EMB:EmbedShow() end)
	self.mainFrame:SetScript("OnHide", function() EMB:EmbedHide() end)

	self.embedCreated = true

	self:SetHooks()
	self:ToggleChatFrame(false)
	self:EmbedUpdate()
end

if AS:CheckAddOn("Recount") then
	function EMB:EmbedRecount()
		local parent = self.leftFrame
		if E.db.addOnSkins.embed.embedType == "DOUBLE" then
			parent = E.db.addOnSkins.embed.rightWindow == "Recount" and self.rightFrame or self.leftFrame
		end
		parent.frameName = "Recount_MainWindow"

		Recount_MainWindow:SetParent(parent)
		Recount_MainWindow:ClearAllPoints()
		Recount_MainWindow:SetPoint("TOPLEFT", parent, "TOPLEFT", E.PixelMode and -1 or 0, E.PixelMode and 8 or 7)
		Recount_MainWindow:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", E.PixelMode and 1 or 0, E.PixelMode and -1 or 0)

		Recount.db.profile.Locked = true
		Recount.db.profile.Scaling = 1
		Recount.db.profile.ClampToScreen = true
		Recount.db.profile.FrameStrata = "2-LOW"
		Recount:SetStrataAndClamp()
		Recount:LockWindows(true)

		Recount_MainWindow:StartSizing("BOTTOMLEFT")
		Recount_MainWindow:StopMovingOrSizing()
		Recount:ResizeMainWindow()
	end
end

if AS:CheckAddOn("Omen") then
	function EMB:EmbedOmen()
		local parent = self.leftFrame
		if E.db.addOnSkins.embed.embedType == "DOUBLE" then
			parent = E.db.addOnSkins.embed.rightWindow == "Omen" and self.rightFrame or self.leftFrame
		end
		parent.frameName = "OmenAnchor"

		local db = Omen.db
		db.profile.Scale = 1
		db.profile.Bar.Spacing = 1
		db.profile.Background.EdgeSize = 1
		db.profile.Background.BarInset = 2
		db.profile.TitleBar.UseSameBG = true
		db.profile.ShowWith.UseShowWith = false
		db.profile.Locked = true
		db.profile.TitleBar.ShowTitleBar = true
		db.profile.FrameStrata = "2-LOW"

		OmenAnchor:SetParent(parent)
		OmenAnchor:ClearAllPoints()
		OmenAnchor:SetAllPoints()

		hooksecurefunc(Omen, "SetAnchors", function(self)
			self.Anchor:SetParent(parent)
			self.Anchor:SetInside(parent, 0, 0)

			if Omen.activeModule then
				Omen.activeModule:UpdateLayout()
			end
			Omen:ResizeBars()
		end)
	end
end

if AS:CheckAddOn("Skada") then
	EMB.skadaWindows = {}

	local function EmbedWindow(window, width, height, point, relativeFrame, relativePoint, ofsx, ofsy)
		if not window then return end

		local barmod = Skada.displays.bar
		local offsety
		if window.db.reversegrowth then
			offsety = 0
		else
			offsety = 1 + (window.db.enabletitle and window.db.title.height or 0)
		end

		window.db.barwidth = width
		window.db.background.height = height - (window.db.enabletitle and window.db.title.height or 0) - (E.PixelMode and 1 or 2)
		window.db.spark = false
		window.db.barslocked = true

		window.bargroup.ClearAllPoints = nil
		window.bargroup:ClearAllPoints()
		window.bargroup.ClearAllPoints = function() end
		window.bargroup.SetPoint = nil
		window.bargroup:SetPoint(point, relativeFrame, relativePoint, ofsx, -offsety)
		window.bargroup.SetPoint = function() end
		window.bargroup:SetParent(relativeFrame)
		window.bargroup:ClearAllPoints()
		window.bargroup:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
		window.bargroup:SetFrameStrata("LOW")

		barmod.ApplySettings(barmod, window)
	end

	function EMB:EmbedSkada()
		wipe(self.skadaWindows)
		for _, window in pairs(Skada:GetWindows()) do
			tinsert(self.skadaWindows, window)
		end

		local db = E.db.addOnSkins.embed
		local numberToEmbed = 0
		if db.embedType == "SINGLE" then
			numberToEmbed = 1
		elseif db.embedType == "DOUBLE" then
			if db.rightWindow == "Skada" then numberToEmbed = numberToEmbed + 1 end
			if db.leftWindow == "Skada" then numberToEmbed = numberToEmbed + 1 end
		end

		if numberToEmbed == 1 then
			local parent = self.leftFrame
			if db.embedType == "DOUBLE" then
				parent = db.rightWindow == "Skada" and self.rightFrame or self.leftFrame
			end

			EmbedWindow(self.skadaWindows[1], parent:GetWidth() -(E.Border*2), parent:GetHeight(), "TOPLEFT", parent, "TOPLEFT", E.Border, -E.Border)
		elseif numberToEmbed == 2 then
			EmbedWindow(self.skadaWindows[1], self.leftFrame:GetWidth() -(E.Border*2), self.leftFrame:GetHeight(), "TOPLEFT", self.leftFrame, "TOPLEFT", E.Border, -E.Border)
			EmbedWindow(self.skadaWindows[2], self.rightFrame:GetWidth() -(E.Border*2), self.rightFrame:GetHeight(), "TOPRIGHT", self.rightFrame, "TOPRIGHT", -E.Border, -E.Border)
		end
	end
end

function EMB:Initialize()
	if E.db.addOnSkins.embed.embedType == "DISABLE" then return end

	self:EmbedCreate()
end

local function InitializeCallback()
	EMB:Initialize()
end

E:RegisterModule(EMB:GetName(), InitializeCallback)