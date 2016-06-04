-- ------------------------------------------------------------------------------ --
--                            TradeSkillMaster_Mailing                            --
--            http://www.curse.com/addons/wow/tradeskillmaster_mailing            --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...)
local AutoMail = TSM:NewModule("AutoMail", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Mailing") -- loads the localization table
local private = {}


function AutoMail:OnEnable()
	AutoMail:RegisterEvent("MAIL_CLOSED", function()
		if private.sendThreadId then
			TSMAPI.Threading:Kill(private.sendThreadId)
			private.sendThreadId = nil
		end
	end)
end

function AutoMail:SendItems(items, target, callback, codPerItem, isDryRun)
	if private.sendThreadId or TSMAPI.Player:IsPlayer(target) or not MailFrame:IsVisible() then return end
	private.sendThreadId = TSMAPI.Threading:Start(private.SendMailThread, 0.7, private.DoneSending, { items, target, codPerItem, isDryRun })
	private.callback = callback
	return true
end

-- returns the number of items currently attached to the mail
function private:GetNumPendingAttachments()
	local totalAttached = 0
	for i = 1, ATTACHMENTS_MAX_SEND do
		if GetSendMailItem(i) then
			totalAttached = totalAttached + 1
		end
	end

	return totalAttached
end

function private:HasPendingAttachments()
	for i = 1, ATTACHMENTS_MAX_SEND do
		if GetSendMailItem(i) then
			return true
		end
	end
	return false
end

function private:GetCompleteLocations(locations, numToSend)
	-- first try in descending order of quantity
	sort(locations, function(a, b) return a.quantity > b.quantity end)
	local total, index = 0, 0
	while index < #locations and total < numToSend do
		index = index + 1
		total = total + locations[index].quantity
	end
	if total <= numToSend then
		return index
	end

	-- next try in ascending order of quantity
	sort(locations, function(a, b) return a.quantity < b.quantity end)
	local total, index = 0, 0
	while index < #locations and total < numToSend do
		index = index + 1
		total = total + locations[index].quantity
	end
	if total <= numToSend then
		return index
	end
end

function private:GetSlotSortValue(bag, slot, specialBags)
	local val = 0
	if not specialBags[bag] then
		val = val + 100000
	end
	return val + bag * 1000 + slot
end

function private:SendOffMailThread(self, target, codPerItem)
	local attachments = private:GetNumPendingAttachments()
	if attachments == 0 or not target then return end
	SendMailNameEditBox:SetText(target)
	SetSendMailMoney(0)
	if codPerItem then
		local numItems = 0
		for i = 1, ATTACHMENTS_MAX_SEND do
			local count = select(3, GetSendMailItem(i))
			numItems = numItems + count
		end
		SetSendMailCOD(codPerItem * numItems)
	else
		SetSendMailCOD(0)
	end

	-- send the mail and wait for it to be sent
	SendMail(target, SendMailSubjectEditBox:GetText() or "TSM_Mailing", "")

	local sendMsg = nil
	if TSM.db.global.sendMessages then
		local items = {}
		for i = 1, attachments do
			local num = select(3, GetSendMailItem(i))
			local link = GetSendMailItemLink(i)
			local itemString = TSMAPI.Item:ToItemString(link)
			if itemString then
				items[itemString] = items[itemString] or { num = 0, link = link }
				items[itemString].num = items[itemString].num + num
			end
		end
		local temp = {}
		for itemString, info in pairs(items) do
			tinsert(temp, format("%sx%d", info.link, info.num))
		end
		local cod = GetSendMailCOD()
		if cod and cod > 0 then
			sendMsg = format(L["Sent %s to %s with a COD of %s."], table.concat(temp, ", "), target, TSMAPI:MoneyToString(cod))
		else
			sendMsg = format(L["Sent %s to %s."], table.concat(temp, ", "), target)
		end
	end

	-- wait for mail to be sent
	local inventoryQuantities = {}
	for i=1, ATTACHMENTS_MAX_SEND do
		local itemString = TSMAPI.Item:ToItemString(GetSendMailItemLink(i))
		if itemString then
			local count = select(3, GetSendMailItem(i))
			inventoryQuantities[itemString] = max(TSMAPI.Inventory:GetBagQuantity(itemString) - count, 0)
		end
	end
	local errorEvent = nil
	self:RegisterEvent("UI_ERROR_MESSAGE", function(_, msg)
		if msg == ERR_NOT_ENOUGH_MONEY or msg == ERR_MAIL_TARGET_NOT_FOUND or msg == ERR_REALM_NOT_FOUND then
			-- not enough money to send mail
			errorEvent = msg
		end
	end)
	while private:HasPendingAttachments() do
		self:Yield(true)
		if errorEvent then
			-- bail when we can't send the mail
			while private:HasPendingAttachments() do
				ClearSendMail()
				self:Yield(true)
			end
			TSM:Print(L["Failed to send mail:"].." "..errorEvent)
			self:Exit(true)
		end
	end
	self:UnregisterEvent("UI_ERROR_MESSAGE")
	local timeout = GetTime() + 3
	while GetTime() < timeout do
		local isDone = true
		for itemString, quantity in pairs(inventoryQuantities) do
			if quantity ~= TSMAPI.Inventory:GetBagQuantity(itemString) then
				isDone = false
				break
			end
		end
		if isDone then break end
		self:Yield(true)
	end
	if sendMsg then
		TSM:Print(sendMsg)
	end
end

function private:GetEmptyBagSlotsThread(self, itemFamily)
	local specialBags = {}
	if itemFamily and itemFamily > 0 then
		for bag = 1, NUM_BAG_SLOTS do
			local bagFamily = GetItemFamily(GetInventoryItemLink("player", ContainerIDToInventoryID(bag)))
			if bagFamily and bagFamily > 0 and bit.band(itemFamily, bagFamily) > 0 then
				specialBags[bag] = true
			end
		end
	end

	-- get a list of empty slots which we can use to split items into
	local emptySlots = {}
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			if not GetContainerItemInfo(bag, slot) then
				local family = (bag == 0) and 0 or GetItemFamily(GetInventoryItemLink("player", ContainerIDToInventoryID(bag)))
				tinsert(emptySlots, { bag = bag, slot = slot, family = family })
			end
		end
		self:Yield()
	end
	-- sort the empty slots such that we'll use special bags first if possible
	sort(emptySlots, function(a, b) return private:GetSlotSortValue(a.bag, a.slot, specialBags) < private:GetSlotSortValue(b.bag, b.slot, specialBags) end)
	return emptySlots
end

-- fills the current mail with items to be sent to the target
function private.SendMailThread(self, args)
	self:SetThreadName("MAILING_SEND_MAIL")
	local numToSend, target, codPerItem, isDryRun = unpack(args)

	if isDryRun then
		TSM:Printf(L["Mailing would send the following items to %s:"], target)
		local numSent = {}
		for bag, slot, itemString, quantity in TSMAPI.Inventory:BagIterator(true, false, true) do
			if (numToSend[itemString] or 0) > 0 then
				quantity = min(quantity, numToSend[itemString])
				numSent[itemString] = (numSent[itemString] or 0) + quantity
				numToSend[itemString] = numToSend[itemString] - quantity
			end
		end
		for itemString, quantity in pairs(numSent) do
			print(format("  %sx%d", TSMAPI.Item:ToItemLink(itemString), quantity))
		end
		return
	end

	-- clear any pending items
	while private:HasPendingAttachments() do
		ClearSendMail()
		self:Yield(true)
	end

	-- populate the itemInfo table with the necessary info
	local itemInfo = {}
	for itemString, quantity in pairs(numToSend) do
		if quantity > 0 then
			itemInfo[itemString] = { locations = {}, done = false }
		end
	end
	for bag, slot, itemString, quantity, locked in TSMAPI.Inventory:BagIterator(true, false, true) do
		if not locked and itemInfo[itemString] then
			tinsert(itemInfo[itemString].locations, { bag = bag, slot = slot, quantity = quantity })
		end
		self:Yield()
	end

	-- first check for items which we can easily send without splitting stacks
	for itemString, info in pairs(itemInfo) do
		if not info.done then
			local endIndex = private:GetCompleteLocations(info.locations, numToSend[itemString])
			if endIndex then
				for i = 1, endIndex do
					PickupContainerItem(info.locations[i].bag, info.locations[i].slot)
					ClickSendMailItemButton()
					if private:GetNumPendingAttachments() == ATTACHMENTS_MAX_SEND then
						-- mail is full, so send it off
						private:SendOffMailThread(self, target, codPerItem)
					end
				end
				info.done = true
				if TSM.db.global.sendItemsIndividually then
					-- we only want to send one type of item per mail, so send it off
					private:SendOffMailThread(self, target, codPerItem)
				end
				self:Yield()
			end
		end
	end

	-- for anything that's left, split stacks as necessary
	local printedBagsFullMsg = false
	for itemString, info in pairs(itemInfo) do
		if not info.done then
			local family = GetItemFamily(TSMAPI.Item:ToItemID(itemString)) or 0
			-- get a list of empty slots which we can use to split items into
			local emptySlots = private:GetEmptyBagSlotsThread(self, family)
			-- use stacks in ascending order of size
			sort(info.locations, function(a, b) return a.quantity < b.quantity end)
			local quantity = numToSend[itemString]
			for _, location in ipairs(info.locations) do
				if quantity == 0 then break end
				if location.quantity <= quantity then
					quantity = quantity - location.quantity
					PickupContainerItem(location.bag, location.slot)
					ClickSendMailItemButton()
					if private:GetNumPendingAttachments() == ATTACHMENTS_MAX_SEND then
						-- mail is full, so send it off
						private:SendOffMailThread(self, target, codPerItem)
					end
				else
					local splitTarget
					for i = 1, #emptySlots do
						if emptySlots[i].family == 0 or bit.band(family, emptySlots[i].family) > 0 then
							splitTarget = emptySlots[i]
							tremove(emptySlots, i)
							break
						end
					end
					if splitTarget then
						SplitContainerItem(location.bag, location.slot, quantity)
						PickupContainerItem(splitTarget.bag, splitTarget.slot)
						-- wait for the stack to be split
						while not GetContainerItemInfo(splitTarget.bag, splitTarget.slot) do self:Yield(true) end
						PickupContainerItem(splitTarget.bag, splitTarget.slot)
						ClickSendMailItemButton()
						if private:GetNumPendingAttachments() == ATTACHMENTS_MAX_SEND then
							-- mail is full, so send it off
							private:SendOffMailThread(self, target, codPerItem)
						end
					else
						-- the player's bags are full
						if not printedBagsFullMsg then
							TSM:Print(L["Could not send mail due to not having free bag space available to split a stack of items."])
							printedBagsFullMsg = true
						end
					end
					-- we're done
					quantity = 0
					break
				end
				self:Yield(true)
			end
			info.done = true
			if TSM.db.global.sendItemsIndividually then
				-- we only want to send one type of item per mail, so send it off
				private:SendOffMailThread(self, target, codPerItem)
			end
		end
	end

	if private:HasPendingAttachments() then
		-- send off the last mail
		private:SendOffMailThread(self, target, codPerItem)
	end
end

function private:DoneSending()
	private.sendThreadId = nil
	private.callback()
end
