-- ------------------------------------------------------------------------------ --
--                            TradeSkillMaster_Mailing                            --
--            http://www.curse.com/addons/wow/tradeskillmaster_mailing            --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...)
local Inbox = TSM:NewModule("Inbox", "AceEvent-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Mailing") -- loads the localization table
local private = {recheckTime=1, allowTimerStart=true, moneyCollected=0, threadId=nil, frame=nil, mode=nil, modeModified=nil}


function Inbox:OnEnable()
	Inbox:RegisterEvent("MAIL_SHOW")
	Inbox:RegisterEvent("MAIL_INBOX_UPDATE", function() TSMAPI.Delay:AfterTime("mailingInboxUpdate", 0.2, private.InboxUpdate) end)
	Inbox:RegisterEvent("MAIL_CLOSED")
end

function Inbox:CreateTab()
	local BFC = TSMAPI.GUI:GetBuildFrameConstants()
	local frameInfo = {
		type = "Frame",
		key = "inboxTab",
		hidden = true,
		points = "ALL",
		scripts = {"OnShow", "OnHide"},
		children = {
			{
				type = "Text",
				key = "topLabel",
				text = "",
				textFont = {TSMAPI.Design:GetContentFont("small")},
				justify = {"CENTER", "MIDDLE"},
				size = {0, 15},
				points = {{"TOPLEFT", 5, -5}, {"TOPRIGHT", -5, -5}},
			},
			{
				type = "HLine",
				offset = -25,
			},
			{
				type = "ScrollingTableFrame",
				key = "st",
				points = {{"TOPLEFT", 5, -30}, {"BOTTOMRIGHT", -5, 55}},
				scripts = {"OnClick"},
			},
			{
				type = "Button",
				key = "allBtn",
				text = L["Open All Mail"],
				textHeight = 18,
				tooltip = L["Opens all mail in your inbox. If you have more than 50 items in your inbox, the opening will automatically continue when the inbox refreshes."].."\n\n"..TSMAPI.Design:GetInlineColor("link")..L["Shift-Click|r to leave mail with gold."],
				size = {0, 20},
				points = {{"BOTTOMLEFT", 5, 30}, {"BOTTOMRIGHT", -5, 30}},
				scripts = {"OnClick"},
			},
			{
				type = "Text",
				key = "ahMailLabel",
				text = L["AH Mail:"],
				textFont = {TSMAPI.Design:GetContentFont("normal")},
				justify = {"RIGHT", "CENTER"},
				size = {70, 20},
				points = {{"BOTTOMLEFT", 5, 5}},
			},
			{
				type = "Button",
				key = "salesBtn",
				text = L["Sales"],
				textHeight = 18,
				tooltip = L["Opens all mail containing gold from sales."].."\n\n"..format(L["%sShift-Click|r to continue opening after an inbox refresh if you have more than 50 items in your inbox."], TSMAPI.Design:GetInlineColor("link")),
				size = {70, 20},
				points = {{"BOTTOMLEFT", BFC.PREV, "BOTTOMRIGHT", 5, 0}},
				scripts = {"OnClick"},
			},
			{
				type = "Button",
				key = "buysBtn",
				text = L["Buys"],
				tooltip = L["Opens all mail containing items you have bought."].."\n\n"..format(L["%sShift-Click|r to continue opening after an inbox refresh if you have more than 50 items in your inbox."], TSMAPI.Design:GetInlineColor("link")),
				textHeight = 18,
				size = {70, 20},
				points = {{"BOTTOMLEFT", BFC.PREV, "BOTTOMRIGHT", 5, 0}},
				scripts = {"OnClick"},
			},
			{
				type = "Button",
				key = "cancelsBtn",
				text = L["Cancels"],
				textHeight = 18,
				tooltip = L["Opens all mail containing canceled auctions."].."\n\n"..format(L["%sShift-Click|r to continue opening after an inbox refresh if you have more than 50 items in your inbox."], TSMAPI.Design:GetInlineColor("link")),
				size = {70, 20},
				points = {{"BOTTOMLEFT", BFC.PREV, "BOTTOMRIGHT", 5, 0}},
				scripts = {"OnClick"},
			},
			{
				type = "Button",
				key = "expiresBtn",
				text = L["Expires"],
				textHeight = 18,
				tooltip = L["Opens all mail containing expired auctions."].."\n\n"..format(L["%sShift-Click|r to continue opening after an inbox refresh if you have more than 50 items in your inbox."], TSMAPI.Design:GetInlineColor("link")),
				size = {0, 20},
				points = {{"BOTTOMLEFT", BFC.PREV, "BOTTOMRIGHT", 5, 0}, {"BOTTOMRIGHT", -5, 5}},
				scripts = {"OnClick"},
			},
			{
				type = "Button",
				key = "reloadBtn",
				text = RELOADUI,
				textHeight = 16,
				size = {150, 20},
				points = {{"CENTER"}},
				scripts = {"OnClick"},
			},
		},
		handlers = {
			OnShow = function(self)
				private.frame = self
				self.reloadBtn:SetFrameStrata("HIGH")
				self.reloadBtn:Hide()

				if not self.helpBtn then
					local TOTAL_WIDTH = private.frame:GetParent():GetWidth()
					local helpPlateInfo = {
						FramePos = {x = 0, y = 70},
						FrameSize = {width = TOTAL_WIDTH, height = private.frame:GetHeight()},
						{
							ButtonPos = {x = 100, y = -20},
							HighLightBox = {x = 70, y = -35, width = TOTAL_WIDTH-70, height = 30},
							ToolTipDir = "DOWN",
							ToolTipText = L["These buttons change what is shown in the mailbox frame. You can view your inbox, automatically mail items in groups, quickly send items to other characters, and more in the various tabs."],
						},
						{
							ButtonPos = {x = 200, y = -200},
							HighLightBox = {x = 0, y = -65, width = TOTAL_WIDTH, height = 305},
							ToolTipDir = "RIGHT",
							ToolTipText = L["This is where the items in your inbox are listed in an information and easy to read format."],
						},
						{
							ButtonPos = {x = 300, y = -360},
							HighLightBox = {x = 0, y = -370, width = TOTAL_WIDTH, height = 55},
							ToolTipDir = "RIGHT",
							ToolTipText = L["The 'Open All Mail' button will open all mail in your inbox (including beyond the 50-mail limit). The AH mail buttons below that will open specific types of mail from your inbox."],
						},
					}

					self.helpBtn = CreateFrame("Button", nil, private.frame, "MainHelpPlateButton")
					self.helpBtn:SetPoint("TOPLEFT", 50, 100)
					self.helpBtn:SetScript("OnClick", function() TSM.MailTab:ToggleHelpPlate(private.frame, helpPlateInfo, self.helpBtn, true) end)
					self.helpBtn:SetScript("OnHide", function() if HelpPlate_IsShowing(helpPlateInfo) then TSM.MailTab:ToggleHelpPlate(private.frame, helpPlateInfo, self.helpBtn, false) end end)
					if not TSM.db.global.helpPlatesShown.inbox then
						TSM.db.global.helpPlatesShown.inbox = true
						TSM.MailTab:ToggleHelpPlate(private.frame, helpPlateInfo, self.helpBtn, false)
					end
				end

				private:InboxUpdate()
			end,
			OnHide = private.MailThreadDone,
			st = {
				OnClick = function(_, data)
					if IsShiftKeyDown() and select(6, GetInboxHeaderInfo(data.index)) <= 0 then
						if private:CanLootMailIndex(data.index, true) then
							private:PrintOpenMailMessage(data.index)
							AutoLootMailItem(data.index)
						else
							TSM:Print(L["Could not loot item from mail because your bags are full."])
						end
					end

					if InboxFrame.openMailID ~= data.index then
						InboxFrame.openMailID = data.index
						OpenMailFrame.updateButtonPositions = true
						OpenMail_Update()
						ShowUIPanel(OpenMailFrame)
						OpenMailFrameInset:SetPoint("TOPLEFT", 4, -80)
						PlaySound("igSpellBookOpen")
					else
						InboxFrame.openMailID = 0
						HideUIPanel(OpenMailFrame)
					end
					InboxFrame_Update()
				end,
			},
			allBtn = {
				OnClick = function() private:StartOpenMail("all") end,
			},
			buysBtn = {
				OnClick = function() private:StartOpenMail("buys") end,
			},
			salesBtn = {
				OnClick = function() private:StartOpenMail("sales") end,
			},
			cancelsBtn = {
				OnClick = function() private:StartOpenMail("cancels") end,
			},
			expiresBtn = {
				OnClick = function() private:StartOpenMail("expires") end,
			},
			reloadBtn = {
				OnClick = ReloadUI,
			},
		},
	}
	return frameInfo
end

local function CacheFrameOnUpdate(self, elapsed)
	if not private.waitingForData then
		local seconds = self.endTime - GetTime()
		if seconds <= 0 then
			-- Look for new mail
			-- Sometimes it fails and isn't available at exactly 60-61 seconds, and more like 62-64, will keep rechecking every 1 second
			-- until data becomes available
			if TSM.db.global.autoCheck then
				private.waitingForData = true
				self.timeLeft = private.recheckTime
				CheckInbox()
				private.frame.reloadBtn:Hide()
			else
				self:Hide()
			end
			return
		end

		private:UpdateTopLabel()
	else
		self.timeLeft = self.timeLeft - elapsed
		if self.timeLeft <= 0 then
			self.timeLeft = private.recheckTime
			CheckInbox()
			private.frame.reloadBtn:Hide()
		end
	end
end

function Inbox:MAIL_SHOW()
	TSMAPI.Delay:AfterTime("mailingGetSellers", 0.1, private.RequestSellerInfo, 0.1)
	if not private.cacheFrame then
		-- Timer for mailbox cache updates
		private.cacheFrame = CreateFrame("Frame", nil, MailFrame)
		private.cacheFrame:Hide()
		private.cacheFrame:SetScript("OnUpdate", CacheFrameOnUpdate)
	end
end

function private:RequestSellerInfo()
	local isDone = true
	for i=1, GetInboxNumItems() do
		local invoiceType, _, seller = GetInboxInvoiceInfo(i)
		if invoiceType and seller == "" then
			isDone = false
		end
	end
	if isDone and GetInboxNumItems() > 0 then
		TSMAPI.Delay:Cancel("mailingGetSellers")
	end
end

local function FormatDaysLeft(daysLeft, index)
	-- code taken from Blizzard MailFrame.lua code
	if daysLeft >= 1 then
		if InboxItemCanDelete(index) then
			daysLeft = YELLOW_FONT_COLOR_CODE .. format(DAYS_ABBR, floor(daysLeft)) .. " " .. FONT_COLOR_CODE_CLOSE;
		else
			daysLeft = GREEN_FONT_COLOR_CODE .. format(DAYS_ABBR, floor(daysLeft)) .. " " .. FONT_COLOR_CODE_CLOSE;
		end
	else
		daysLeft = RED_FONT_COLOR_CODE .. SecondsToTime(floor(daysLeft * 24 * 60 * 60)) .. FONT_COLOR_CODE_CLOSE;
	end
	return daysLeft
end

function private:UpdateTopLabel()
	local parts = {}

	local numMail, totalMail = GetInboxNumItems()
	if totalMail == numMail then
		tinsert(parts, format(L["Showing all %d mail."], numMail))
	else
		tinsert(parts, format(L["Showing %d of %d mail."], numMail, totalMail))
	end

	local collectGold = private.collectGold or 0
	if collectGold > 0 then
		tinsert(parts, format(L["%s to collect."], TSMAPI:MoneyToString(collectGold)))
	end

	local nextRefresh = private.cacheFrame:IsVisible() and private.cacheFrame.endTime
	if nextRefresh then
		if numMail == 0 and TSM.db.global.showReloadBtn then
			private.frame.reloadBtn:Show()
		end
		tinsert(parts, format(L["Inbox update in %d seconds."], max(ceil(nextRefresh - GetTime()), 0)))
	end

	private.frame.topLabel:SetText(table.concat(parts, " "))
end

function private:InboxUpdate()
	if not private.frame or not private.frame:IsVisible() then return end

	local numMail, totalMail = GetInboxNumItems()

	local greenColor, redColor = "|cff00ff00", "|cffff0000"
	local mailInfo = {}
	local collectGold = 0
	for i = 1, numMail do
		mailInfo[i] = ""
		local isInvoice = select(4, GetInboxText(i))
		local _, _, sender, subject, money, cod, daysLeft, hasItem = GetInboxHeaderInfo(i)
		if isInvoice then
			local invoiceType, itemName, playerName, bid, _, _, ahcut, _, _, _, quantity = GetInboxInvoiceInfo(i)
			if invoiceType == "buyer" then
				local itemLink = private:GetFirstInboxItemLink(i) or itemName
				mailInfo[i] = format(L["Buy: %s (%d) | %s | %s"], itemLink, quantity, TSMAPI:MoneyToString(bid, redColor), FormatDaysLeft(daysLeft, i))
			elseif invoiceType == "seller" then
				collectGold = collectGold + bid - ahcut
				mailInfo[i] = format(L["Sale: %s (%d) | %s | %s"], itemName, quantity, TSMAPI:MoneyToString(bid - ahcut, greenColor), FormatDaysLeft(daysLeft, i))
			end
		elseif hasItem then
			local itemLink
			local quantity = 0
			for j = 1, hasItem do
				local link = GetInboxItemLink(i, j)
				itemLink = itemLink or link
                local icy_tmp = GetInboxItem(i, j)
                if icy_tmp then
                    quantity = quantity + select(5, GetInboxItem(i, j)) -- ICY: fix
                end
				if TSMAPI.Item:ToItemString(itemLink) ~= TSMAPI.Item:ToItemString(link) then
					itemLink = L["Multiple Items"]
					quantity = -1
					break
				end
			end
			if hasItem == 1 then
				itemLink = private:GetFirstInboxItemLink(i) or itemLink
			end
			local itemDesc = (quantity > 0 and format("%s (%d)", itemLink, quantity)) or (quantity == -1 and L["Multiple Items"]) or "---"

			if hasItem == 1 and itemLink and strfind(subject, "^" .. TSMAPI.Util:StrEscape(format(AUCTION_EXPIRED_MAIL_SUBJECT, TSMAPI.Item:GetInfo(itemLink)))) then
				mailInfo[i] = format(L["Expired: %s | %s"], itemDesc, FormatDaysLeft(daysLeft, i))
			elseif cod > 0 then
				mailInfo[i] = format(L["COD: %s | %s | (%s) | %s | %s"], itemDesc, TSMAPI:MoneyToString(cod, redColor), quantity > 0 and TSMAPI:MoneyToString(floor(cod / quantity + 0.5), redColor) or "---", sender or "---", FormatDaysLeft(daysLeft, i))
			elseif money > 0 then
				collectGold = collectGold + money
				mailInfo[i] = format("%s + %s | %s | %s", itemDesc, TSMAPI:MoneyToString(money, greenColor), sender or "---", FormatDaysLeft(daysLeft, i))
			else
				mailInfo[i] = format("%s | %s | %s", itemDesc, sender or "---", FormatDaysLeft(daysLeft, i))
			end
		elseif money > 0 then
			mailInfo[i] = format("%s | %s | %s | %s", subject, TSMAPI:MoneyToString(money, greenColor), sender or "---", FormatDaysLeft(daysLeft, i))
		else
			mailInfo[i] = format("%s | %s | %s", subject, sender or "---", FormatDaysLeft(daysLeft, i))
		end
	end
	private.collectGold = collectGold

	local stData = {}
	for i, info in ipairs(mailInfo) do
		tinsert(stData, { cols = { { value = info } }, index = i })
	end
	private.frame.st:SetData(stData)

	if numMail > 0 then
		private.frame.reloadBtn:Hide()
	end
	private:UpdateTopLabel()

	if private.cacheFrame.endTime and numMail == totalMail and private.lastTotal ~= totalMail then
		-- Yay nothing else to loot, so nothing else to update the cache for!
		private.cacheFrame.endTime = nil
		private.cacheFrame:Hide()
	elseif (private.cacheFrame.endTime and numMail >= 50 and private.lastTotal ~= totalMail) or (numMail >= 50 and private.allowTimerStart) then
		-- Start a timer since we're over the limit of 50 items before waiting for it to recache
		private.allowTimerStart = nil
		private.waitingForData = nil
		private.lastTotal = totalMail
		private.cacheFrame.endTime = GetTime() + 60
		private.cacheFrame:Show()
	end
end


function private:CanLootMailIndex(index, force)
	local money, cod, _, hasItem = select(5, GetInboxHeaderInfo(index))
	-- check if this would put them over the gold cap
	money = (money or 0) + (cod or 0)
	local MAX_COPPER = 9999999999
	local currentMoney = GetMoney()
	TSMAPI:Assert(currentMoney <= MAX_COPPER)
	if currentMoney + money > MAX_COPPER then return end
	if not hasItem or hasItem == 0 then return true end

	if force or not TSM.db.global.keepMailSpace or TSM.db.global.keepMailSpace == 0 then
		for j = 1, ATTACHMENTS_MAX_RECEIVE do
			local link = GetInboxItemLink(index, j)
			local itemString = TSMAPI.Item:ToItemString(link)
			local quantity = select(3, GetInboxItem(index, j))
			local space = 0
			if itemString then
				for bag = 0, NUM_BAG_SLOTS do
					if TSMAPI.Inventory:ItemWillGoInBag(link, bag) then
						for slot = 1, GetContainerNumSlots(bag) do
							local iString = TSMAPI.Item:ToItemString(GetContainerItemLink(bag, slot))
							if iString == itemString then
								local stackSize = select(2, GetContainerItemInfo(bag, slot))
								local maxStackSize = select(8, TSMAPI.Item:GetInfo(itemString))
								if (maxStackSize - stackSize) >= quantity then
									return true
								end
							elseif not iString then
								return true
							end
						end
					end
				end

				-- Cannot loot the first item, so return.
				private.inventoryFull = true
				return
			end
		end
	else
		-- get number of free slots per generic / special bags and partial slots by bag
		local genericSpace, uniqueSpace, partSlots = private:GetBagSlots()
		local usedSlots = {}
		for j = 1, ATTACHMENTS_MAX_RECEIVE do
			local link = GetInboxItemLink(index, j)
			local itemString = TSMAPI.Item:ToItemString(link)
			local quantity = select(3, GetInboxItem(index, j))
			local isDone = false
			if itemString then
				for bag = 0, NUM_BAG_SLOTS do
					if TSMAPI.Inventory:ItemWillGoInBag(link, bag) then
						for slot = 1, GetContainerNumSlots(bag) do
							local iString = TSMAPI.Item:ToItemString(GetContainerItemLink(bag, slot))
							if iString == itemString and (partSlots[bag] and partSlots[bag][slot]) then
								local stackSize = select(2, GetContainerItemInfo(bag, slot))
								local maxStackSize = select(8, TSMAPI.Item:GetInfo(itemString))
								if (maxStackSize - stackSize - (usedSlots[bag] and usedSlots[bag][slot] or 0)) >= quantity then
									if stackSize + quantity == maxStackSize then
										if partSlots[bag] and partSlots[bag][slot] then
											partSlots[bag][slot] = nil -- this partial slot would be filled so remove it from available part slots
										end
									else
										if not usedSlots[bag] then
											usedSlots[bag] = {}
										end
										usedSlots[bag][slot] = (usedSlots[bag][slot] or 0) + stackSize -- store the stacksize for this slot after adding this item
									end
									isDone = true
									break
								end
							else
								local itemFamily = GetItemFamily(TSMAPI.Item:ToItemID(itemString)) or 0
								local bagFamily = GetItemFamily(GetBagName(bag)) or 0
								if itemFamily and bagFamily and bagFamily > 0 and bit.band(itemFamily, bagFamily) > 0 and (uniqueSpace[bag] and uniqueSpace[bag] > 0) then
									uniqueSpace[bag] = uniqueSpace[bag] - 1 -- remove one empty slot from the bag
									isDone = true
									break
								else
									if genericSpace[bag] and genericSpace[bag] > 0 then
										genericSpace[bag] = genericSpace[bag] - 1 -- remove one empty slot from the bag
										if genericSpace[bag] <= 0 then
											genericSpace[bag] = nil
										end
										isDone = true
										break
									end
								end
							end
						end
						if isDone then break end
					end
				end
			end
		end

		--calculate the total remaining empty slots in generic bags after looting this mail
		local remainingSpace = 0
		for bag, space in pairs(genericSpace) do
			remainingSpace = remainingSpace + space
		end
		if remainingSpace >= TSM.db.global.keepMailSpace then
			return true -- either not using keepMailSpace option or we can loot all of this mail
		else
			private.keepFreeSlots = true -- can't loot the whole of this mail and leave enough free slots so set the flag that displays the chat message
		end
	end
end

function private:GetBagSlots()
	local genericSpace, uniqueSpace, partSlots = {}, {}, {}
	for bag = 0, NUM_BAG_SLOTS do
		if (GetItemFamily(GetBagName(bag)) or 0) > 0 then
			uniqueSpace[bag] = GetContainerNumFreeSlots(bag) or 0
		else
			genericSpace[bag] = GetContainerNumFreeSlots(bag) or 0
		end
		for slot = 1, GetContainerNumSlots(bag) do
			local iLink = GetContainerItemLink(bag, slot)
			if iLink then
				if not partSlots[bag] then
					partSlots[bag] = {}
				end
				table.insert(partSlots[bag], slot)
			end
		end
	end
	return genericSpace, uniqueSpace, partSlots
end

function Inbox:MAIL_CLOSED()
	private.allowTimerStart = true
	private.waitingForData = nil
	TSMAPI.Delay:Cancel("mailingGetSellers")
	private:MailThreadDone()
end

function private:ShouldDeleteMail(index)
	local subject, money, cod, numItems, wasReturned, canReply, isGM = TSMAPI.Util:Select({4, 5, 6, 8, 10, 12, 13}, GetInboxHeaderInfo(index))
	if not TSM.db.global.deleteEmptyNPCMail then return false end
	if isGM then return false end
	if canReply then return false end
	if numItems then return false end
	if cod > 0 then return false end
	if money > 0 then return false end
	if wasReturned then return false end
	return true
end

function private:ShouldOpenMail(index)
	local subject, money, cod, numItems, isGM = TSMAPI.Util:Select({4, 5, 6, 8, 13}, GetInboxHeaderInfo(index))
	cod = cod or 0
	money = money or 0
	numItems = numItems or 0

	if isGM or cod > 0 or (money == 0 and numItems == 0) then return end
	if not private:CanLootMailIndex(index) then return end

	if private.mode == "all" then
		if private.modeModified then
			return money == 0
		else
			return true
		end
	elseif private.mode == "sales" then
		return money > 0 and GetInboxInvoiceInfo(index) == "seller"
	elseif private.mode == "buys" then
		return numItems > 0 and GetInboxInvoiceInfo(index) == "buyer"
	elseif private.mode == "cancels" then
		local isInvoice = select(4, GetInboxText(index))
		if not isInvoice and numItems == 1 then
			local itemName = TSMAPI.Item:GetInfo(private:GetFirstInboxItemLink(index))
			if itemName then
				local quantity = select(3, GetInboxItem(index, 1))
				if quantity and quantity > 0 and (subject == format(AUCTION_REMOVED_MAIL_SUBJECT.." (%d)", itemName, quantity) or subject == format(AUCTION_REMOVED_MAIL_SUBJECT, itemName)) then
					return true
				end
			end
		end
	elseif private.mode == "expires" then
		local isInvoice = select(4, GetInboxText(index))
		if not isInvoice and numItems == 1 then
			local itemName = TSMAPI.Item:GetInfo(private:GetFirstInboxItemLink(index))
			if itemName and strfind(subject, "^" .. TSMAPI.Util:StrEscape(format(AUCTION_EXPIRED_MAIL_SUBJECT, itemName))) then
				return true
			end
		end
	end
end

function private:PrintOpenMailMessage(index)
	if not TSM.db.global.inboxMessages then return end
	local _, _, sender, subject, money, cod, _, hasItem = GetInboxHeaderInfo(index)
	local greenColor, redColor = "|cff00ff00", "|cffff0000"
	sender = sender or "?"
	if select(4, GetInboxText(index)) then
		-- it's an invoice
		local invoiceType, itemName, playerName, bid, _, _, ahcut, _, _, _, quantity = GetInboxInvoiceInfo(index)
		playerName = playerName or "?"
		if invoiceType == "buyer" then
			local itemLink = private:GetFirstInboxItemLink(index) or itemName
			TSM:Printf(L["Bought %sx%d for %s from %s"], itemLink, quantity, TSMAPI:MoneyToString(bid, redColor), playerName)
		elseif invoiceType == "seller" then
			TSM:Printf(L["Sold [%s]x%d for %s to %s"], itemName, quantity, TSMAPI:MoneyToString(bid - ahcut, greenColor), playerName)
		end
	elseif hasItem then
		local itemLink
		local quantity = 0
		for i = 1, hasItem do
			local link = GetInboxItemLink(index, i)
			itemLink = itemLink or link
            local icy_tmp = select(3, GetInboxItem(index, i))
            if icy_tmp then
                quantity = quantity + icy_tmp
            end
			if TSMAPI.Item:ToItemString(itemLink) ~= TSMAPI.Item:ToItemString(link) then
				itemLink = L["Multiple Items"]
				quantity = -1
				break
			end
		end
		if hasItem == 1 then
			itemLink = private:GetFirstInboxItemLink(index) or itemLink
		end
		local itemName = TSMAPI.Item:GetInfo(itemLink)
		local itemDesc = (quantity > 0 and format("%s (%d)", itemLink, quantity)) or (quantity == -1 and "Multiple Items") or "?"
		if hasItem == 1 and itemLink and strfind(subject, "^" .. TSMAPI.Util:StrEscape(format(AUCTION_EXPIRED_MAIL_SUBJECT, TSMAPI.Item:GetInfo(itemLink)))) then
			TSM:Printf(L["Your auction of %s expired"], itemDesc)
		elseif hasItem == 1 and quantity > 0 and (subject == format(AUCTION_REMOVED_MAIL_SUBJECT.." (%d)", itemName, quantity) or subject == format(AUCTION_REMOVED_MAIL_SUBJECT, itemName)) then
			TSM:Printf(L["Cancelled auction of %sx%d"], itemLink, quantity)
		elseif cod > 0 then
			TSM:Printf(L["%s sent you a COD of %s for %s"], sender, TSMAPI:MoneyToString(cod, redColor), itemDesc)
		elseif money > 0 then
			TSM:Printf(L["%s sent you %s and %s"], sender, itemDesc, TSMAPI:MoneyToString(money, greenColor))
		else
			TSM:Printf(L["%s sent you %s"], sender, itemDesc)
		end
	elseif money > 0 then
		TSM:Printf(L["%s sent you %s"], sender, TSMAPI:MoneyToString(money, greenColor))
	else
		TSM:Printf(L["%s sent you a message: %s"], sender, subject)
	end
end

function private.OpenMailThread(self)
	self:SetThreadName("MAILING_OPEN_MAIL")

	local eventStatus = nil
	self:RegisterEvent("UI_ERROR_MESSAGE", function(_, msg)
		if msg == ERR_MAIL_DATABASE_ERROR or msg == ERR_INV_FULL or msg == ERR_ITEM_MAX_COUNT then
			-- internal mail error, inventory full, or too many unique items
			eventStatus = "ERROR"
		end
	end)
	self:RegisterEvent("MAIL_INBOX_UPDATE", function() eventStatus = "UPDATE" end)
	private.frame.allBtn:Disable()
	private.frame.salesBtn:Disable()
	private.frame.buysBtn:Disable()
	private.frame.cancelsBtn:Disable()
	private.frame.expiresBtn:Disable()

	-- wait for any pending mail to arrive
	while select(2, GetInboxNumItems()) == 0 and HasNewMail() do self:Yield(true) end

	private.moneyCollected = 0
	local attemptedToOpenMail = true
	local shouldWait = false
	while attemptedToOpenMail do
		attemptedToOpenMail = nil
		local encounteredError = nil
		local numMail, totalMail = GetInboxNumItems()
		for index=numMail, 1, -1 do
			if private:ShouldOpenMail(index) then
				if shouldWait then
					-- this isn't the first time through the loop, so give the pending opens some times to clear out
					self:Sleep(2)
					shouldWait = nil
					attemptedToOpenMail = true
					break
				end
				local money = select(5, GetInboxHeaderInfo(index)) or 0
				local numItems = select(8, GetInboxHeaderInfo(index)) or 0
				local numInboxItems = GetInboxNumItems()

				-- auto-loot the mail
				private:PrintOpenMailMessage(index)
				AutoLootMailItem(index)

				-- wait for an inbox event
				eventStatus = nil
				local triedDeleting = nil
				while not eventStatus do self:Yield(true) end
				if eventStatus == "UPDATE" then
					-- wait for the number of mails to go down by 1 (for at most 1 second per item)
					local waitEndTime = debugprofilestop() + (max(numItems, 1) * 1000)
					while debugprofilestop() < waitEndTime do
						if GetInboxNumItems() == numInboxItems - 1 then break end
						if not triedDeleting and private:ShouldDeleteMail(index) then
							DeleteInboxItem(index)
							triedDeleting = true
						end
						if eventStatus == "ERROR" then
							TSM:LOG_ERR("Encountered error at index %d (triedDeleting=%s)", index, tostring(triedDeleting))
							encounteredError = true
							break
						end
						self:Yield(true)
					end

					if not encounteredError then
						attemptedToOpenMail = true
					end
				elseif eventStatus == "ERROR" then
					-- there was an error trying to open this mail, so skip it silently and try again
					encounteredError = true
				end

				-- track money collected
				private.moneyCollected = private.moneyCollected + money
			elseif private:ShouldDeleteMail(index) then
				-- wait for an inbox event
				DeleteInboxItem(index)
				eventStatus = nil
				while not eventStatus do self:Yield(true) end

				if eventStatus == "UPDATE" then
					attemptedToOpenMail = true
				elseif eventStatus == "ERROR" then
					encounteredError = true
				end
			end
		end
		local numMail, totalMail = GetInboxNumItems()
		if attemptedToOpenMail and totalMail > numMail and numMail < 50 and (private.mode == "all" or private.modeModified) then
			-- wait for the inbox to update and then continue
			while true do
				local numMail, totalMail = GetInboxNumItems()
				if numMail == 50 or numMail == totalMail then break end
				self:Sleep(0.5)
			end
			self:Sleep(1)
		elseif not attemptedToOpenMail and encounteredError then
			TSM:Print(L["Cannot finish auto looting, inventory is full or too many unique items."])
		else
			shouldWait = true
		end
	end

	-- check if we ran out of
	if private.keepFreeSlots then
		TSM:Printf(L["Stopped opening mail to keep %d slots free."], TSM.db.global.keepMailSpace)
		private.keepFreeSlots = nil
	end

	if private.inventoryFull then
		TSM:Print(L["Cannot finish auto looting, inventory is full or too many unique items."])
		private.inventoryFull = nil
	end

	-- play sound
	TSMAPI:DoPlaySound(TSM.db.global.openMailSound)
end

function private:MailThreadDone()
	if not private.threadId then return end
	-- Tell user how much money has been collected if enabled
	if private.moneyCollected > 0 and TSM.db.global.displayMoneyCollected then
		TSM:Printf(L["Total Gold Collected: %s"], TSMAPI:MoneyToString(private.moneyCollected))
		private.moneyCollected = 0
	end

	TSMAPI.Threading:Kill(private.threadId)
	private.threadId = nil
	private.mode = nil
	private.modeModified = nil
	private.frame.allBtn:Enable()
	private.frame.salesBtn:Enable()
	private.frame.buysBtn:Enable()
	private.frame.cancelsBtn:Enable()
	private.frame.expiresBtn:Enable()
end

function private:StartOpenMail(mode)
	private:MailThreadDone()
	private.mode = mode
	private.modeModified = IsShiftKeyDown()
	private.threadId = TSMAPI.Threading:Start(private.OpenMailThread, 0.7, private.MailThreadDone)
end

function private:GetFirstInboxItemLink(index)
	if not TSMMailingInboxTooltip then
		CreateFrame("GameTooltip", "TSMMailingInboxTooltip", UIParent, "GameTooltipTemplate")
	end
	TSMMailingInboxTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	TSMMailingInboxTooltip:ClearLines()
	local _, speciesId, level, breedQuality, maxHealth, power, speed, name = TSMMailingInboxTooltip:SetInboxItem(index)
	local link = nil
	if (speciesId or 0) > 0 then
		link = TSMAPI.Item:ToItemLink(strjoin(":", "p", speciesId, level, breedQuality, maxHealth, power, speed))
	else
		link = GetInboxItemLink(index, 1)
	end
	TSMMailingInboxTooltip:Hide()
	return link
end