local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local EE = E:GetModule("ElvUI_Enhanced")

local GetInboxNumItems = GetInboxNumItems
local GetLatestThreeSenders = GetLatestThreeSenders
local HasNewMail = HasNewMail

local MAIL_LABEL = MAIL_LABEL
local HAVE_MAIL_FROM = HAVE_MAIL_FROM

local Mail_Icon = "|TInterface\\MINIMAP\\TRACKING\\Mailbox.blp:14:14|t"

local readMail, unreadMail

local function MakeIconString()
	local str = ""
	str = str..Mail_Icon

	return str
end

local function OnEvent(self, event, ...)
	local newMail = false

	if event == "UPDATE_PENDING_MAIL" or event == "PLAYER_ENTERING_WORLD" or event =="PLAYER_LOGIN" then
		newMail = HasNewMail()

		if unreadMail ~= newMail then
			unreadMail = newMail
		end

		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:UnregisterEvent("PLAYER_LOGIN")
	end

	if event == "MAIL_INBOX_UPDATE" or event == "MAIL_SHOW" or event == "MAIL_CLOSED" then
		for i = 1, GetInboxNumItems() do
			local _, _, _, _, _, _, _, _, wasRead = GetInboxHeaderInfo(i)

			if not wasRead then
				newMail = true
				break
			end
		end
	end

	if newMail then
		self.text:SetText(MakeIconString()..L["New Mail"])
		self.text:SetTextColor(0, 1, 0)

		readMail = false
	else
		self.text:SetText(L["No Mail"])
		self.text:SetTextColor(1, 1, 1)

		readMail = true
	end
end

local function OnUpdate(self)
	OnEvent(self, "UPDATE_PENDING_MAIL")
	self:SetScript("OnUpdate", nil)
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	local sender1, sender2, sender3 = GetLatestThreeSenders()

	if not readMail then
		DT.tooltip:AddLine(HAVE_MAIL_FROM)

		if sender1 then DT.tooltip:AddLine("    "..sender1) end
		if sender2 then DT.tooltip:AddLine("    "..sender2) end
		if sender3 then DT.tooltip:AddLine("    "..sender3) end
	end

	DT.tooltip:Show()
end

DT:RegisterDatatext("Mail", {"PLAYER_ENTERING_WORLD", "MAIL_INBOX_UPDATE", "UPDATE_PENDING_MAIL", "MAIL_CLOSED", "PLAYER_LOGIN", "MAIL_SHOW"}, OnEvent, OnUpdate, nil, OnEnter, nil, EE:ColorizeSettingName(MAIL_LABEL))