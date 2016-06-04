-- ------------------------------------------------------------------------------ --
--                            TradeSkillMaster_Mailing                            --
--            http://www.curse.com/addons/wow/tradeskillmaster_mailing            --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...)
local MailTab = TSM:NewModule("MailTab", "AceEvent-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Mailing") -- loads the localization table
local private = {frame=nil, tabs={}, didHook=nil}


function MailTab:OnEnable()
	MailTab:RegisterEvent("MAIL_SHOW", function() TSMAPI.Delay:AfterTime(0, private.OnMailShow) end)
end

function MailTab:ToggleHelpPlate(frame, info, btn, isUser)
	if not HelpPlate_IsShowing(info) then
		HelpPlate:SetParent(frame)
		HelpPlate:SetFrameStrata("DIALOG")
		HelpPlate_Show(info, frame, btn, isUser)
	else
		HelpPlate:SetParent(UIParent)
		HelpPlate:SetFrameStrata("DIALOG")
		HelpPlate_Hide(isUser)
	end
end

function private:OnMailShow()
	private:CreateMailTab()
	if not private.didHook then
		private.didHook = true
		MailTab:Hook("MailFrameTab_OnClick", private.OnOtherTabClick, true)
	end
	
	local currentTab = PanelTemplates_GetSelectedTab(MailFrame)
	if TSM.db.global.defaultMailTab then
		for i=1, MailFrame.numTabs do
			if _G["MailFrameTab"..i].isTSMTab then
				currentTab = i
			end
		end
	end
	
	-- make sure the second tab gets loaded so we can send mail
	MailFrameTab2:Click()
	_G["MailFrameTab"..currentTab]:Click()
end

function private:CreateMailTab()
	if private.frame then return end
	
	local BFC = TSMAPI.GUI:GetBuildFrameConstants()
	local frameInfo = {
		type = "Frame",
		parent = MailFrame,
		hidden = true,
		mouse = true,
		points = {{"TOPLEFT"}, {"BOTTOMRIGHT", 40, 0}},
		children = {
			{
				type = "TSMLogo",
				size = {80, 80},
				points = {{"CENTER", BFC.PARENT, "TOPLEFT", 25, -25}},
			},
			{
				type = "Text",
				text = "TSM_Mailing - "..TSM._version,
				textHeight = 18,
				justify = {"CENTER", "MIDDLE"},
				points = {{"TOPLEFT", 40, -5}, {"BOTTOMRIGHT", BFC.PARENT, "TOPRIGHT", -5, -25}},
			},
			{
				type = "Button",
				key = "closeBtn",
				text = "X",
				textHeight = 19,
				size = {20, 20},
				points = {{"TOPRIGHT", -5, -5}},
				scripts = {"OnClick"},
			},
			{
				type = "VLine",
				size = {2, 30},
				points = {{"TOPRIGHT", -30, -1}},
			},
			{
				type = "HLine",
				offset = -28,
			},
			{
				type = "Button",
				key = "inboxBtn",
				text = INBOX,
				textHeight = 15,
				size = {55, 20},
				points = {{"TOPLEFT", 70, -40}},
				scripts = {"OnClick"},
			},
			{
				type = "Button",
				key = "groupsBtn",
				text = L["TSM Groups"],
				textHeight = 15,
				size = {95, 20},
				points = {{"TOPLEFT", BFC.PREV, "TOPRIGHT", 5, 0}},
				scripts = {"OnClick"},
			},
			{
				type = "Button",
				key = "quickSendBtn",
				text = L["Quick Send"],
				textHeight = 15,
				size = {85, 20},
				points = {{"TOPLEFT", BFC.PREV, "TOPRIGHT", 5, 0}},
				scripts = {"OnClick"},
			},
			{
				type = "Button",
				key = "otherBtn",
				text = OTHER,
				textHeight = 15,
				size = {0, 20},
				points = {{"TOPLEFT", BFC.PREV, "TOPRIGHT", 5, 0}, {"TOPRIGHT", -5, -40}},
				scripts = {"OnClick"},
			},
			{
				type = "HLine",
				offset = -70,
			},
			{
				type = "Frame",
				key = "content",
				points = {{"TOPLEFT", 0, -70}, {"BOTTOMRIGHT"}},
				children = {
					TSM.Inbox:CreateTab(),
					TSM.Groups:CreateTab(),
					TSM.Other:CreateTab(),
					TSM.QuickSend:CreateTab(),
				},
			},
		},
		handlers = {
			closeBtn = {
				OnClick = CloseMail,
			},
			inboxBtn = {
				OnClick = private.OnButtonClick,
			},
			groupsBtn = {
				OnClick = private.OnButtonClick,
			},
			quickSendBtn = {
				OnClick = private.OnButtonClick,
			},
			otherBtn = {
				OnClick = private.OnButtonClick,
			},
		},
	}
	
	local frame = TSMAPI.GUI:BuildFrame(frameInfo)
	TSMAPI.Design:SetFrameBackdropColor(frame)

	local n = MailFrame.numTabs + 1
	local tab = CreateFrame("Button", "MailFrameTab"..n, MailFrame, "FriendsFrameTabTemplate")
	tab:Hide()
	tab:SetID(n)
	tab:SetText(TSMAPI.Design:GetInlineColor("link2").."TSM_Mailing|r")
	tab:SetNormalFontObject(GameFontHighlightSmall)
	tab.isTSMTab = true
	tab:SetPoint("LEFT", _G["MailFrameTab"..n-1], "RIGHT", -8, 0)
	tab:Show()
	tab:SetScript("OnClick", private.OnTabClick)
	PanelTemplates_SetNumTabs(MailFrame, n)
	PanelTemplates_EnableTab(MailFrame, n)
	frame.tab = tab
	
	TSMAPI.Design:SetFrameColor(frame.content.groupsTab.groupTreeContainer)
	TSMAPI.Design:SetFrameColor(frame.content.otherTab.deBox)
	TSMAPI.Design:SetFrameColor(frame.content.otherTab.sendGoldBox)
	
	private.frame = frame
end

function private.OnTabClick(tabFrame)
	PanelTemplates_SetTab(MailFrame, tabFrame:GetID())
	ButtonFrameTemplate_HideButtonBar(MailFrame)
	InboxFrame:Hide()
	OpenMailFrame:Hide()
    if StationeryPopupFrame then -- ICY: fix
        StationeryPopupFrame:Hide()
    end
	SendMailFrame:Hide()
	SetSendMailShowing(false)
	
	MailFrameInset:Hide()
	MailFramePortraitFrame:Hide()
	MailFrameBg:Hide()
	if MailFrameText then MailFrameText:Hide() end
	MailFrameTitleBg:Hide()
	MailFrameTitleText:Hide()
	MailFrameCloseButton:Hide()
	
	MailFrameLeftBorder:Hide()
	MailFrameTopBorder:Hide()
	MailFrameRightBorder:Hide()
	MailFrameBottomBorder:Hide()
	MailFrameTopTileStreaks:Hide()
	MailFrameTopRightCorner:Hide()
	MailFrameBotLeftCorner:Hide()
	MailFrameBotRightCorner:Hide()
	
	private.frame:Show()
	if TSM.db.global.defaultPage == 1 then
		private.frame.inboxBtn:Click()
	elseif TSM.db.global.defaultPage == 2 then
		private.frame.groupsBtn:Click()
	elseif TSM.db.global.defaultPage == 3 then
		private.frame.quickSendBtn:Click()
	elseif TSM.db.global.defaultPage == 4 then
		private.frame.otherBtn:Click()
	end
end

function private.OnOtherTabClick()
	private.frame:Hide()
	MailFrameLeftBorder:Show()
	MailFrameTopBorder:Show()
	MailFrameRightBorder:Show()
	MailFrameBottomBorder:Show()
	MailFrameTopTileStreaks:Show()
	MailFrameTopRightCorner:Show()
	MailFrameBotLeftCorner:Show()
	MailFrameBotRightCorner:Show()
	
	MailFrameInset:Show()
	MailFramePortraitFrame:Show()
	MailFrameBg:Show()
	if MailFrameText then MailFrameText:Show() end
	MailFrameTitleBg:Show()
	MailFrameTitleText:Show()
	MailFrameCloseButton:Show()
end

function private.OnButtonClick(self)
	private.frame.content.inboxTab:Hide()
	private.frame.content.groupsTab:Hide()
	private.frame.content.otherTab:Hide()
	private.frame.content.quickSendTab:Hide()
	
	private.frame.inboxBtn:UnlockHighlight()
	private.frame.groupsBtn:UnlockHighlight()
	private.frame.otherBtn:UnlockHighlight()
	private.frame.quickSendBtn:UnlockHighlight()
	self:LockHighlight()

	if self == private.frame.inboxBtn then
		private.frame.content.inboxTab:Show()
	elseif self == private.frame.groupsBtn then
		private.frame.content.groupsTab:Show()
	elseif self == private.frame.otherBtn then
		private.frame.content.otherTab:Show()
	elseif self == private.frame.quickSendBtn then
		private.frame.content.quickSendTab:Show()
	end
end